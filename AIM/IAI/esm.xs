//escrowsMethods
//==============================================================================
// updateEscrows
/*
	Set the econ/mil escrow balances based on age, personality and our current
	settler pop compared to what we want to have.
	
	When we lose a lot of settlers, the economy escrow is expanded and the 
	military escrow is reduced until the econ recovers.  
*/
//==============================================================================
void updateEscrows(void)
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 30000,"updateEscrows") == false) return;
	lastRunTime = gCurrentGameTime;
	
	float econPercent = 0.0;
	float milPercent = 0.0;
	float villTarget = xsArrayGetInt(gTargetSettlerCounts, gCurrentAge); // How many we want to have this age
	float villCount = kbUnitCount(cMyID, gEconUnit, cUnitStateABQ); // How many do we have?
	float villRatio = 1.00;
	if (villTarget > 0.0)
		villRatio = villCount / villTarget; // Actual over desired.
	float villShortfall = 1.0 - villRatio; // 0.0 means at target, 0.3 means 30% short of target

	switch (gCurrentAge)
	{
		case cAge1:
			{
				econPercent = 0.90 - (0.1 * btRushBoom); // 80% rushers, 100% boomers
				break;
			}
		case cAge2:
			{
				econPercent = 0.45 - (0.35 * btRushBoom); // 10% rushers, 80% boomers
				break;
			}
		case cAge3:
			{
				econPercent = 0.30 - (0.15 * btRushBoom) + (0.3 * villShortfall); // 0.3,  +/- up to 0.15, + up to 0.3 if we have no vills.
				// At 1/2 our target vill pop, this works out to 0.45 +/- rushBoom effect.  At vill pop, it's 0.3 +/- rushBoom factor.
				break;
			}
		case cAge4:
			{
				econPercent = 0.30 - (0.1 * btRushBoom) + (0.3 * villShortfall);
				break;
			}
		case cAge5:
			{
				econPercent = 0.20 - (0.1 * btRushBoom) + (0.3 * villShortfall);
				break;
			}
	}
	if (econPercent < 0.0)
		econPercent = 0.0;
	if (econPercent > 0.8)
		econPercent = 0.8;
	milPercent = 0.8 - econPercent;
	if (gCurrentAge == cAge1)
		milPercent = 0.0;

	kbEscrowSetPercentage(cEconomyEscrowID, cResourceFood, econPercent);
	kbEscrowSetPercentage(cEconomyEscrowID, cResourceWood, econPercent / 2.0); // Leave most wood at the root  
	kbEscrowSetPercentage(cEconomyEscrowID, cResourceGold, econPercent);


	kbEscrowSetPercentage(cEconomyEscrowID, cResourceFame, 0.0);
	kbEscrowSetPercentage(cEconomyEscrowID, cResourceSkillPoints, 0.0);
	kbEscrowSetCap(cEconomyEscrowID, cResourceFood, 1000); // Save for age upgrades
	kbEscrowSetCap(cEconomyEscrowID, cResourceWood, 200);
	if (gCurrentAge >= cAge3)
		kbEscrowSetCap(cEconomyEscrowID, cResourceWood, 600); // Needed for mills, plantations
	kbEscrowSetCap(cEconomyEscrowID, cResourceGold, 1000); // Save for age upgrades
	if (kbGetCiv() == cCivDutch)
	{
		kbEscrowSetCap(cEconomyEscrowID, cResourceFood, 350); // Needed for banks
		kbEscrowSetCap(cEconomyEscrowID, cResourceWood, 350);
	}
	else if ((cvMaxAge > -1) && (gCurrentAge >= cvMaxAge))
	{ // Not dutch, and not facing age upgrade, so reduce food/gold withholding
		kbEscrowSetCap(cEconomyEscrowID, cResourceFood, 250);
		kbEscrowSetCap(cEconomyEscrowID, cResourceWood, 250);
	}

	//updatedOn 2019/03/29 By ageekhere  
	//--------------------------- 

	if (gTownCenterNumber < 1)
	{
		kbEscrowSetCap(cEconomyEscrowID, cResourceWood, 600); //save for town center
	}
	//--------------------------- 

	kbEscrowSetPercentage(cMilitaryEscrowID, cResourceFood, milPercent);
	kbEscrowSetPercentage(cMilitaryEscrowID, cResourceWood, milPercent / 2.0);
	kbEscrowSetPercentage(cMilitaryEscrowID, cResourceGold, milPercent);


	kbEscrowSetPercentage(cMilitaryEscrowID, cResourceFame, 0.0);
	kbEscrowSetPercentage(cMilitaryEscrowID, cResourceSkillPoints, 0.0);
	kbEscrowSetCap(cMilitaryEscrowID, cResourceFood, 300);
	kbEscrowSetCap(cMilitaryEscrowID, cResourceWood, 200);
	kbEscrowSetCap(cMilitaryEscrowID, cResourceGold, 300);

	kbEscrowAllocateCurrentResources();
}

//==============================================================================
// updateEscrowsGatherers
/*
	
*/
//==============================================================================

//==============================================================================
/*
 updateEscrowsGatherers
 updatedOn 2022/09/12
 Given the desired allocation of gatherers, set the desired number of gatherers for each active econ base, 
 and the breakdown between resources for each base.
 
 Allocate gatherers based on a weighted average of two systems.  The first system is based
 on the forecasts, ignoring current inventory, i.e. it wants to keep gatherers aligned with
 out medium-term demand, and not swing based on inventory.  The second system is based
 on forecast minus inventory, or shortfall.  This is short-term, highly reactive, and volatile.
 The former factor will be weighted more heavily when inventories are large, the latter when 
 inventories are tight.  (When inventories are zero, they are the same...the second method
 reacts strongly when one resource is at or over forecast, and others are low.)
 
 How to use
 is auto called in setForecasts
*/
//==============================================================================
void updateEscrowsGatherers(void)
{
	if(xsArrayGetFloat(gForecasts, 0) < 0 && xsArrayGetFloat(gForecasts, 1) < 0 && xsArrayGetFloat(gForecasts, 2) < 0 )return;
	
	static int pResourcePriorities = -1; // An array that holds our priorities for cResourceFood, etc.
	static int pForecastValues = -1; // Array holding the relative forecast-oriented values.
	static int pReactiveValues = -1;
	static int pGathererPercentages = -1;
	
	float pForecastWeight = 1.0;
	float pReactiveWeight = 0.0; // reactive + forecast = 1.0
	float pTotalForecast = 0.0;
	float pTotalShortfall = 0.0;
	float pFcst = 0.0;
	float pShortfall = 0.0;
	float pScratch = 0.0;
	float pTotalPercentages = 0.0;
	float pCoreGatherers = gCurrentAliveSettlers;
	float pGoldGatherers = 0.0;
	float pFoodGatherers = 0.0;
	float pTotalGatherers = 0.0;
	float pGoldWanted = 0.0;
	float pFoodWanted = 0.0;
	float pWoodWanted = 0.0;
	
	if (pResourcePriorities < 0) pResourcePriorities = xsArrayCreateFloat(gNumResourceTypes, 0.0, "pResourcePriorities");
	if (pForecastValues < 0) pForecastValues = xsArrayCreateFloat(gNumResourceTypes, 0.0, "forecast oriented values");
	if (pReactiveValues < 0) pReactiveValues = xsArrayCreateFloat(gNumResourceTypes, 0.0, "reactive values");
	if (pGathererPercentages < 0) pGathererPercentages = xsArrayCreateFloat(gNumResourceTypes, 0.0, "gatherer percentages");
	
	aiSetResourceGathererPercentageWeight(cRGPScript, 1.0);
	aiSetResourceGathererPercentageWeight(cRGPCost, 0.0);
	
	for (i = 0; < gNumResourceTypes)
	{
		pFcst = xsArrayGetFloat(gForecasts, i);
		pShortfall = pFcst - kbResourceGet(i);
		pTotalForecast = pTotalForecast + pFcst;
		if (pShortfall > 0.0) pTotalShortfall = pTotalShortfall + pShortfall;
	}
	
	if (pTotalForecast > 0) pReactiveWeight = pTotalShortfall / pTotalForecast;
	else pReactiveWeight = 1.0;
	pForecastWeight = 1.0 - pReactiveWeight;
	
	// Make reactive far more important
	if (pTotalShortfall > (0.3 * pTotalForecast)) // we have a significant pShortfall
	{ // If it was 40/60 reactive:forecast, this makes it 82/18.
		// 10/90 becomes 73/27;  80/20 becomes 94/6
		pReactiveWeight = pReactiveWeight + (0.7 * pForecastWeight);
		pForecastWeight = 1.0 - pReactiveWeight;
	}
	
	// Update the arrays
	for (i = 0; < gNumResourceTypes)
	{
		pFcst = xsArrayGetFloat(gForecasts, i);
		pShortfall = pFcst - kbResourceGet(i);
		xsArraySetFloat(pForecastValues, i, pFcst / pTotalForecast); // This resource's share of the total forecast
		if (pShortfall > 0) xsArraySetFloat(pReactiveValues, i, pShortfall / pTotalShortfall);
		else xsArraySetFloat(pReactiveValues, i, 0.0);
		pScratch = xsArrayGetFloat(pForecastValues, i) * pForecastWeight;
		pScratch = pScratch + (xsArrayGetFloat(pReactiveValues, i) * pReactiveWeight);
		xsArraySetFloat(pGathererPercentages, i, pScratch);
	}
	
	// Adjust for wood and gold being slower to gather
	xsArraySetFloat(pGathererPercentages, cResourceWood, xsArrayGetFloat(pGathererPercentages, cResourceWood) * 1.4);
	xsArraySetFloat(pGathererPercentages, cResourceGold, xsArrayGetFloat(pGathererPercentages, cResourceGold) * 1.2);

	// Normalize if not 1.0
	pTotalPercentages = 0.0;
	for (i = 0; < gNumResourceTypes) pTotalPercentages = pTotalPercentages + xsArrayGetFloat(pGathererPercentages, i);
	for (i = 0; < gNumResourceTypes) xsArraySetFloat(pGathererPercentages, i, xsArrayGetFloat(pGathererPercentages, i) / pTotalPercentages);

	// Now, consider the effects of dedicated gatherers, like fishing boats, factories and banks, since we need to end up with settler/coureur assignments to pick up the balance.	
	pCoreGatherers = pCoreGatherers + gSettlerWagonNum;
	pGoldGatherers = gBankNum * 5;
	if (gFactoryNum > 1) pGoldGatherers = pGoldGatherers + ((gFactoryNum - 1) * 10); // first factory will always produce artillery
	
	pFoodGatherers = gFishingUnitNum;
	pTotalGatherers = pCoreGatherers + pGoldGatherers + pFoodGatherers;
	
	pGoldWanted = pTotalGatherers * xsArrayGetFloat(pGathererPercentages, cResourceGold);	
	if (pGoldWanted < pGoldGatherers) pGoldWanted = pGoldGatherers; 
	pFoodWanted = pTotalGatherers * xsArrayGetFloat(pGathererPercentages, cResourceFood);
	if (pFoodWanted < pFoodGatherers) pFoodWanted = pFoodGatherers;
	pWoodWanted = pTotalGatherers * xsArrayGetFloat(pGathererPercentages, cResourceWood);

	// What percent of our core gatherers should be on each resource?
	xsArraySetFloat(pGathererPercentages, cResourceGold, (pGoldWanted - pGoldGatherers) / pCoreGatherers);
	xsArraySetFloat(pGathererPercentages, cResourceFood, (pFoodWanted - pFoodGatherers) / pCoreGatherers);
	xsArraySetFloat(pGathererPercentages, cResourceWood, (pWoodWanted / pCoreGatherers));
	// Normalize
	pTotalPercentages = 0.0;
	for (i = 0; < gNumResourceTypes) pTotalPercentages = pTotalPercentages + xsArrayGetFloat(pGathererPercentages, i);
	for (i = 0; < gNumResourceTypes) xsArraySetFloat(pGathererPercentages, i, xsArrayGetFloat(pGathererPercentages, i) / pTotalPercentages);

	// Stop gathering wood upon forest depletion
	if (kbGetAmountValidResources(kbBaseGetMainID(cMyID), cResourceWood, cAIResourceSubTypeEasy, 80.0) < 3000.0) xsArraySetFloat(pGathererPercentages, cResourceWood, 0.0);

	// Normalize
	pTotalPercentages = 0.0;
	for (i = 0; < gNumResourceTypes) pTotalPercentages = pTotalPercentages + xsArrayGetFloat(pGathererPercentages, i);
	for (i = 0; < gNumResourceTypes) xsArraySetFloat(pGathererPercentages, i, xsArrayGetFloat(pGathererPercentages, i) / pTotalPercentages);
	for (i = 0; < gNumResourceTypes) aiSetResourceGathererPercentage(i, xsArrayGetFloat(pGathererPercentages, i), false, cRGPScript);
	
	aiNormalizeResourceGathererPercentages(cRGPScript); // Set them to 1.0 total, just in case these don't add up.
}


void escrowsMain()
{

}