//livestock

extern int livestockPlan = -1;
extern int livestockPlanKill = -1;
//==============================================================================
/*
 livestockManager
 updatedOn 2022/05/30
 Creates a maintain plan for livestock, finds the best livestock to train and sets the max number to train. 
*/
//==============================================================================
void livestockManager()
{ //train new livestock

	if (gCurrentAge == cAge1 || kbBaseGetUnderAttack(cMyID, gMainBase) == true) return; //skip when in age 1 or civs which cannot hunt or under attack
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"livestockManager") == false) return;
	lastRunTime = gCurrentGameTime;
	if (getCivIsNative() == true && gCurrentAge == cAge3 && kbUnitCount(cMyID, gLivestockPenUnit, cUnitStateABQ) < 2)
	{
		
		if (checkBuildingPlan(gLivestockPenUnit) == -1)
		{
			buildingBluePrint(gLivestockPenUnit,-1);
			//createSimpleBuildPlan(gLivestockPenUnit, 1, 65, true, cEconomyEscrowID, gMainBase, 1); //add another gLivestockPenUnit
		}
	}
	else if (getCivIsNative() == true && gCurrentAge == cAge4 && kbUnitCount(cMyID, gLivestockPenUnit, cUnitStateABQ) < 3)
	{
		if (checkBuildingPlan(gLivestockPenUnit) == -1)
		{
			buildingBluePrint(gLivestockPenUnit,-1);
			//createSimpleBuildPlan(gLivestockPenUnit, 1, 65, true, cEconomyEscrowID, gMainBase, 1); //add another gLivestockPenUnit
		}
	}
	else if ((gCurrentCiv == cCivIndians || gCurrentCiv == cCivSPCIndians) && 
	gCurrentAge > cAge1 && 
	kbUnitCount(cMyID, gLivestockPenUnit, cUnitStateABQ) < kbGetBuildLimit(cMyID, gLivestockPenUnit))
	{
		if (checkBuildingPlan(gLivestockPenUnit) == -1)
		{
			buildingBluePrint(gLivestockPenUnit,-1);
			//createSimpleBuildPlan(gLivestockPenUnit, 1, 100, true, cEconomyEscrowID, gMainBase, 1); //add another gLivestockPenUnit
		}
	}
	int livestockAvailable = -1;
	int useLivestock = -1;
	//selected the best livestock available, if more than 1 type then use the highest food first
	livestockAvailable = kbProtoUnitAvailable(cUnitTypeypGoat);
	if (livestockAvailable == 1 && kbUnitCount(cMyID, cUnitTypeypGoat, cUnitStateABQ) < kbGetBuildLimit(cMyID, cUnitTypeypGoat)) useLivestock = cUnitTypeypGoat;
	livestockAvailable = kbProtoUnitAvailable(cUnitTypeSheep);
	if (livestockAvailable == 1 && kbUnitCount(cMyID, cUnitTypeSheep, cUnitStateABQ) < kbGetBuildLimit(cMyID, cUnitTypeSheep)) useLivestock = cUnitTypeSheep;
	livestockAvailable = kbProtoUnitAvailable(cUnitTypeLlama);
	if (livestockAvailable == 1 && kbUnitCount(cMyID, cUnitTypeLlama, cUnitStateABQ) < kbGetBuildLimit(cMyID, cUnitTypeLlama)) useLivestock = cUnitTypeLlama;
	livestockAvailable = kbProtoUnitAvailable(cUnitTypeCow);
	if (livestockAvailable == 1 && kbUnitCount(cMyID, cUnitTypeCow, cUnitStateABQ) < kbGetBuildLimit(cMyID, cUnitTypeCow)) useLivestock = cUnitTypeCow;
	livestockAvailable = kbProtoUnitAvailable(cUnitTypeypWaterBuffalo);
	if (livestockAvailable == 1 && kbUnitCount(cMyID, cUnitTypeypWaterBuffalo, cUnitStateABQ) < kbGetBuildLimit(cMyID, cUnitTypeypWaterBuffalo)) useLivestock = cUnitTypeypWaterBuffalo;
	livestockAvailable = kbProtoUnitAvailable(cUnitTypeypSacredCow);
	if (livestockAvailable == 1 && kbUnitCount(cMyID, cUnitTypeypSacredCow, cUnitStateABQ) < kbGetBuildLimit(cMyID, cUnitTypeypSacredCow)) useLivestock = cUnitTypeypSacredCow;
	if(useLivestock == -1)return; //no livestock found
	int maxLivestock = kbGetBuildLimit(cMyID, useLivestock); //get the max sheep limit
	switch (gCurrentAge)
	{ //set maxLivestock for each age
		case cAge1:{maxLivestock = 0;break;}
		case cAge2:{maxLivestock = 0;break;}
		case cAge3:{maxLivestock = 5;break;}
		case cAge4:{maxLivestock = 15;break;}
		case cAge5:{maxLivestock = maxLivestock;break;}
	} //end switch
	
	int diff = maxLivestock - kbUnitCount(cMyID, useLivestock, cUnitStateABQ); //see how many sheep you need
	if(gCurrentFood > 5000) diff = 2; //when the AI has more than 5000 food limit livestock
	if(getCivHuntAbility() == false) diff = maxLivestock;
	if(getCivSlaughterAbility() == false) diff = maxLivestock;
	
	static int livestockCreatePlan = -1;
	livestockCreatePlan = checkPlanIsActive(livestockCreatePlan); //check if the plan is active
	if(livestockCreatePlan == -1)livestockCreatePlan = createSimpleMaintainPlan(useLivestock, 0, true, gMainBase, 1, livestockCreatePlan);
	aiPlanSetVariableInt(livestockCreatePlan, cTrainPlanNumberToMaintain, 0, diff);
	livestockPlanKill = 1;
} //end livestockManager

//==============================================================================
/*
 strayLivestockMonitor
 updatedOn 2022/05/31
 Finds stray livestock and sends them to gLivestockPenUnit or gMainBaseLocation if no pen
*/
//==============================================================================
void strayLivestockMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"strayLivestockMonitor") == false) return;
	lastRunTime = gCurrentGameTime;
	
	static int stockQuery = -1;
	if (stockQuery == -1) 
	{
		stockQuery = kbUnitQueryCreate("stockQuery"+getQueryId());
		kbUnitQuerySetPlayerID(stockQuery, cMyID, false);
		kbUnitQuerySetPlayerRelation(stockQuery, -1);
		kbUnitQuerySetIgnoreKnockedOutUnits(stockQuery, true);
		kbUnitQuerySetUnitType(stockQuery, cUnitTypeHerdable);
		kbUnitQuerySetState(stockQuery, cUnitStateAlive);
	}
	kbUnitQueryResetResults(stockQuery);
	int stockNum = kbUnitQueryExecute(stockQuery);
	
	static int penQuery = -1;
	if (penQuery == -1) 
	{
		penQuery = kbUnitQueryCreate("penQuery"+getQueryId());
		kbUnitQuerySetPlayerID(penQuery, cMyID, false);
		kbUnitQuerySetPlayerRelation(penQuery, -1);
		kbUnitQuerySetIgnoreKnockedOutUnits(penQuery, true);
		kbUnitQuerySetUnitType(penQuery, gLivestockPenUnit);
		kbUnitQuerySetState(penQuery, cUnitStateAlive);
	}
	kbUnitQueryResetResults(penQuery);
	int penNum = kbUnitQueryExecute(penQuery);
	
	static int farmQuery = -1;
	if (farmQuery == -1) 
	{
		farmQuery = kbUnitQueryCreate("farmQuery"+getQueryId());
		kbUnitQuerySetPlayerID(farmQuery, cMyID, false);
		kbUnitQuerySetPlayerRelation(farmQuery, -1);
		kbUnitQuerySetIgnoreKnockedOutUnits(farmQuery, true);
		kbUnitQuerySetUnitType(farmQuery, gFarmUnit);
		kbUnitQuerySetState(farmQuery, cUnitStateAlive);
	}
	kbUnitQueryResetResults(farmQuery);
	int farmNum = kbUnitQueryExecute(farmQuery);
	
	vector penLocation = gMainBaseLocation; 
	bool notFound = false;
	int livestockID = -1;
	int livestockPenID = -1;
	int farmID = -1;
	int gatherLimit = 9;
	
	for (i = 0; < stockNum)
	{
		livestockID = kbUnitQueryGetResult(stockQuery, i);
		if(kbUnitGetTargetUnitID(livestockID) != -1)continue; 
		if(kbUnitIsInventoryFull(livestockID) == true && gCurrentCiv != cCivJapanese && gCurrentCiv != cCivSPCJapanese && gCurrentCiv != cCivSPCJapaneseEnemy)continue; 
		notFound = true;
		aiTaskUnitMove(livestockID, penLocation);
		
		for(j = 0; < penNum)
		{
			gatherLimit = 9;
			livestockPenID = kbUnitQueryGetResult(penQuery, j);
			if(livestockPenID == -1) break;
			
			if (kbUnitIsType( livestockPenID, gHouseUnit ) == true) gatherLimit = 1;
			if (gCurrentCiv == cCivJapanese || gCurrentCiv == cCivSPCJapanese || gCurrentCiv == cCivSPCJapaneseEnemy) gatherLimit = 3;
			
			if( kbUnitGetNumberWorkers(livestockPenID) >= unitGathererLimit(kbUnitGetProtoUnitID(livestockPenID)) ) continue; 
			penLocation = kbUnitGetPosition(livestockPenID);
			aiTaskUnitWork(livestockID, livestockPenID);
			notFound = false;
			break;
		}

		if (getCivIsNative() == true && livestockPenID == -1)
		{
			for(j = 0; < farmNum)
			{
				farmID = kbUnitQueryGetResult(farmQuery, j);
				if(farmID == -1) break;
			
				if( kbUnitGetNumberWorkers(farmID) >= unitGathererLimit(kbUnitGetProtoUnitID(livestockPenID)) ) continue; 
				penLocation = kbUnitGetPosition(farmID);
				aiTaskUnitWork(livestockID, farmID);
				notFound = false;
				break;
			}
		}
		
		if(gCurrentCiv == cCivJapanese || gCurrentCiv == cCivSPCJapanese || gCurrentCiv == cCivSPCJapaneseEnemy)
		{
			if(kbUnitCount(cMyID, cUnitTypeypWJToshoguShrine2, cUnitStateAlive) > 0)
			{
				livestockPenID = getUnit(cUnitTypeypWJToshoguShrine2);
			}
			else if(kbUnitCount(cMyID, cUnitTypeypWJToshoguShrine3, cUnitStateAlive) > 0)
			{
				livestockPenID = getUnit(cUnitTypeypWJToshoguShrine3);
			}
			else if(kbUnitCount(cMyID, cUnitTypeypWJToshoguShrine4, cUnitStateAlive) > 0)
			{
				livestockPenID = getUnit(cUnitTypeypWJToshoguShrine4);
			}
			else if(kbUnitCount(cMyID, cUnitTypeypWJToshoguShrine5, cUnitStateAlive) > 0)
			{
				livestockPenID = getUnit(cUnitTypeypWJToshoguShrine5);
			}
			if(livestockPenID != -1)
			{
				if(kbUnitGetNumberWorkers(livestockPenID) >= unitGathererLimit(kbUnitGetProtoUnitID(livestockPenID)))
				{
					aiTaskUnitWork(livestockID, livestockPenID);
					continue; 
				}
			}
			
		}
	}
	
}

//==============================================================================
/*
 livestockFatten
 updatedOn 2022/05/31
 Makes fatten livestock to form a ring around the TC 
*/
//==============================================================================

void livestockFatten()
{ //moves fatten livestock to area around tc
	if (getCivIsJapan() || getCivIsIndia() || gMainTownCenter == -1) return;
	
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 5000,"livestockFatten") == false) return;
	lastRunTime = gCurrentGameTime;
	
	static int lifeStockCount = -1; //current fatten livestock
	if (lifeStockCount == -1) 
	{
		lifeStockCount = kbUnitQueryCreate("lifeStockCount"+getQueryId()); //livestock counter 
		kbUnitQuerySetPlayerID(lifeStockCount, cMyID, false);
		kbUnitQuerySetPlayerRelation(lifeStockCount, -1);
		kbUnitQuerySetUnitType(lifeStockCount, cUnitTypeHerdable);
		kbUnitQuerySetState(lifeStockCount, cUnitStateAlive);
	}
	kbUnitQueryResetResults(lifeStockCount);

	float vectSpace = 1; //for spacing
	int livestockId = -1;
	bool getInventory = false;
	float cxLocation = -1;
	float czLocation = -1;
	float dxLocation = -1;
	float dzLocation = -1;
	float xDiff = -1;
	float zDiff = -1;
	vector cLocation = cInvalidVector;
	vector dLocation = cInvalidVector;
	for (i = 0; < kbUnitQueryExecute(lifeStockCount))
	{ //loop through livestock
		livestockId = kbUnitQueryGetResult(lifeStockCount, i); //get livestock id
		getInventory = kbUnitIsInventoryFull(livestockId); //getInventory value
		vector vecDist = vector(8.0, 0.0, 8.0); //que spacing
		for (j = 0; < vectSpace)
		{ // create a que around the tc
			if (j < 7) vecDist = vecDist + vector(0.0, 0.0, -3.0);
			else if (j < 14) vecDist = vecDist + vector(-3.0, 0.0, 0.0);
			else if (j < 21) vecDist = vecDist + vector(0.0, 0.0, 3.0);
			else if (j > 20) vecDist = vecDist + vector(3.0, 0.0, 0.0);
		} //end for

		if (getInventory == true)
		{ //que fatten livestock
			//do not move livestock if at tc
			cLocation = kbUnitGetPosition(livestockId);
			dLocation = gMainTownCenterLocation - vecDist;
			cxLocation = xsVectorGetX(cLocation);
			czLocation = xsVectorGetZ(cLocation);
			dxLocation = xsVectorGetX(dLocation);
			dzLocation = xsVectorGetZ(dLocation);
			xDiff = cxLocation - dxLocation;
			zDiff = czLocation - dzLocation;

			vectSpace = vectSpace + 1;
			if ((xDiff > 1 || xDiff < -1) || (zDiff > 1 || zDiff < -1))
			{
				//aiPlanDestroy(livestockPlan);
				livestockPlanKill = 1;
				//livestockPlan = -1;
				aiTaskUnitMove(livestockId, gMainTownCenterLocation - vecDist);

			}
		} //end if
	} //end for
} //end livestockFatten


void livestockMain()
{

}