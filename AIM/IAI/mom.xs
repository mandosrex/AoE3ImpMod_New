
//monitorMethods
//==============================================================================
/*
 buildingMonitorBuildCheck
 updatedOn 2022/10/01
 function for buildingMonitor to check conditions before making a plan
 
 How to use
 auto called from buildingMonitor
*/
//==============================================================================

void buildingMonitorBuildCheck(int pUnit = -1)
{
	if(kbProtoUnitAvailable(pUnit) == true && 
	checkBuildingPlan(pUnit) == -1 && 
	checkBuildingLimit(pUnit) == false && 
	gCurrentWood >= kbUnitCostPerResource(pUnit, cResourceWood))
	{ //check if unit is available, that there are no plans and not at the building limit
		if(pUnit == gTownCenter && kbUnitCount(cMyID, cUnitTypeCoveredWagon, cUnitStateABQ) > 0) 
		{
			buildingBluePrint(pUnit,getUnit(cUnitTypeCoveredWagon, cMyID, cUnitStateAlive));
			return;
		}
		if(pUnit == gTownCenter && kbUnitCount(cMyID, cUnitTypeCoveredWagon, cUnitStateABQ) > 0) buildingBluePrint(pUnit,getUnit(cUnitTypeCoveredWagon, cMyID, cUnitStateAlive));
		buildingBluePrint(pUnit,-1);
	}
}

//==============================================================================
/*
 buildingMonitor
 updatedOn 2023/12/15
 Tells the AI what to build
 
 How to use
 auto called from mainRules
*/
//==============================================================================
void buildingMonitor()
{
	static bool pFirstRun = true;
	static int pBuildingPriArray = -1;
	static int pBuildingArray = -1;
	static int pUnitScore = -1;
	static int pHighestValue = -1;
	static int pSlot = -1;
	static int pHouseDifCap = 10;

	const int pBuildingPriArraySize = 21;
	const int pBuildingArraySize = 21;
	pUnitScore = 0;
	pHighestValue = -1;
	pSlot = -1;
	if (kbUnitCount(cMyID, gTownCenter, cUnitStateAlive) == 0) return;
	if(pFirstRun) 
	{ //set array for all building types on the first run
		pBuildingPriArray = xsArrayCreateInt(pBuildingPriArraySize, 0, "pBuildingPriArray");
		pBuildingArray = xsArrayCreateInt(pBuildingArraySize, 0, "pBuildingArray");
		xsArraySetInt(pBuildingArray, 0, gHouseUnit);
		xsArraySetInt(pBuildingArray, 1, gTowerUnit);
		xsArraySetInt(pBuildingArray, 2, gFarmUnit);
		xsArraySetInt(pBuildingArray, 3, gLivestockPenUnit);
		xsArraySetInt(pBuildingArray, 4, gMarketUnit);
		xsArraySetInt(pBuildingArray, 5, gDockUnit);
		xsArraySetInt(pBuildingArray, 6, gTownCenter);
		xsArraySetInt(pBuildingArray, 7, gBarracksUnit);
		xsArraySetInt(pBuildingArray, 8, gStableUnit);
		xsArraySetInt(pBuildingArray, 9, gArtilleryDepotUnit);
		xsArraySetInt(pBuildingArray, 10, gArsenalUnit);
		xsArraySetInt(pBuildingArray, 11, gChurchUnit);
		xsArraySetInt(pBuildingArray, 12, gTradingPostUnit);
		xsArraySetInt(pBuildingArray, 13, gCapitolUnit);
		xsArraySetInt(pBuildingArray, 14, gFirePitUnit);
		xsArraySetInt(pBuildingArray, 15, cUnitTypeypCastle);
		xsArraySetInt(pBuildingArray, 16, cUnitTypeSPCIncaTemple);
		xsArraySetInt(pBuildingArray, 17, cUnitTypeBank);
		xsArraySetInt(pBuildingArray, 18, cUnitTypeypSacredField);
		xsArraySetInt(pBuildingArray, 19, cUnitTypeWarTent);
		xsArraySetInt(pBuildingArray, 20, cUnitTypeSPCFortCenter);
		pFirstRun = false;
	} //end if


	switch (gCurrentAge)
	{
		case cAge1: { pHouseDifCap = 5; break; }	
		case cAge2: { pHouseDifCap = 10; break; }	
		case cAge3: { pHouseDifCap = 20; break; }	
		case cAge4: { pHouseDifCap = 30; break; }	
		case cAge5: { pHouseDifCap = 40; break; }	
	}
	//house score
	if (gCurrentWood > 1500 && (getCivIsJapan() || gCurrentCiv == cCivBritish)) pUnitScore = 1;


	if ((gCurrentPopCap - gCurrentPop) < pHouseDifCap || gCurrentPop > gCurrentPopCap)
	{
		pUnitScore = 10;
	}


	if(gOkToMakeHouses == false || 
	gMainTownCenter == -1 || 
	gCurrentWood < kbUnitCostPerResource(gHouseUnit, cResourceWood) ||
	kbUnitCount(cMyID, gHouseUnit, cUnitStateQueued) > 0 ||
	kbUnitCount(cMyID, gHouseUnit, cUnitStateBuilding) > 0 ||
	checkBuildingLimit(gHouseUnit) == true || 
	kbProtoUnitAvailable(gHouseUnit) == false || 
	checkBuildingPlan(gHouseUnit) != -1)  pUnitScore = 0;

	if(gCurrentCiv == cCivMaltese && checkBuildingLimit(gHouseUnit) == false )
	{
		switch (gCurrentAge)
		{
			case cAge1: { if(kbUnitCount(cMyID, gHouseUnit, cUnitStateABQ) < 5 && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) > 0) pUnitScore = 5; break; }
			case cAge2: { if(kbUnitCount(cMyID, gHouseUnit, cUnitStateABQ) < 15 && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) > 1 ) pUnitScore = 5; break; }
			case cAge3: { if(kbUnitCount(cMyID, gHouseUnit, cUnitStateABQ) < 25 && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) > 2) pUnitScore = 5; break; }
			case cAge4: { if(kbUnitCount(cMyID, gHouseUnit, cUnitStateABQ) < 40 && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) > 3) pUnitScore = 5; break; }
		}

	}
	xsArraySetInt(pBuildingPriArray, 0, pUnitScore);
	//market score
	pUnitScore = 0;
	if(kbUnitCount(cMyID, gMarketUnit, cUnitStateABQ) == 0) pUnitScore = 3;
	if(gMainTownCenter == -1 || 
	gCurrentWood < kbUnitCostPerResource(gMarketUnit, cResourceWood) ||
	kbUnitCount(cMyID, gMarketUnit, cUnitStateQueued) > 0 ||
	kbUnitCount(cMyID, gMarketUnit, cUnitStateBuilding) > 0 ||
	checkBuildingLimit(gMarketUnit) == true || 
	kbProtoUnitAvailable(gMarketUnit) == false || 
	checkBuildingPlan(gMarketUnit) != -1)  pUnitScore = 0;
	xsArraySetInt(pBuildingPriArray, 4, pUnitScore);


	//barrack score
	pUnitScore = 0;
	if(gCurrentAge > cAge2 && kbUnitCount(cMyID, gBarracksUnit, cUnitStateABQ) == 0)
	{
		pUnitScore = 8;
	}
	else
	{
		switch(gCurrentAge)
		{
			case cAge2 : { if(kbUnitCount(cMyID, gBarracksUnit, cUnitStateABQ) == 0) pUnitScore = 1; break; }
			case cAge3 : { if(kbUnitCount(cMyID, gBarracksUnit, cUnitStateABQ) < 3) pUnitScore = 1; break; }
			case cAge4 : { if(kbUnitCount(cMyID, gBarracksUnit, cUnitStateABQ) < 4) pUnitScore = 1; break; }
			case cAge5 : { if(kbUnitCount(cMyID, gStableUnit, cUnitStateABQ) >= kbUnitCount(cMyID, gBarracksUnit, cUnitStateABQ)) pUnitScore = 1; break;}
		}
	}
	if(gMainTownCenter == -1 || 
	kbUnitCount(cMyID, gBarracksUnit, cUnitStateQueued) > 0 ||
	kbUnitCount(cMyID, gBarracksUnit, cUnitStateBuilding) > 0 ||
	gCurrentWood < kbUnitCostPerResource(gBarracksUnit, cResourceWood) ||
	checkBuildingLimit(gBarracksUnit) == true || 
	kbProtoUnitAvailable(gBarracksUnit) == false || 
	checkBuildingPlan(gBarracksUnit) != -1 ||
	gCurrentAge == cAge1)  pUnitScore = 0;
	xsArraySetInt(pBuildingPriArray, 7, pUnitScore);
	pUnitScore = 0;

	//stable score
	pUnitScore = 0;
	switch(gCurrentAge)
	{
		case cAge2 : { if(kbUnitCount(cMyID, gStableUnit, cUnitStateABQ) == 0 && getCivIsNative()) pUnitScore = 9; break; }
		case cAge3 : { if(kbUnitCount(cMyID, gStableUnit, cUnitStateABQ) < 3) pUnitScore = 1; break; }
		case cAge4 : { if(kbUnitCount(cMyID, gStableUnit, cUnitStateABQ) < 4) pUnitScore = 1; break; }
		case cAge5 : { if(kbUnitCount(cMyID, gStableUnit, cUnitStateABQ) < kbUnitCount(cMyID, gBarracksUnit, cUnitStateABQ)) pUnitScore = 1; break;}
	}
	if(gMainTownCenter == -1 || 
	kbUnitCount(cMyID, gStableUnit, cUnitStateQueued) > 0 ||
	kbUnitCount(cMyID, gStableUnit, cUnitStateBuilding) > 0 ||
	gCurrentWood < kbUnitCostPerResource(gStableUnit, cResourceWood) ||
	checkBuildingLimit(gStableUnit) == true || 
	kbProtoUnitAvailable(gStableUnit) == false || 
	checkBuildingPlan(gStableUnit) != -1)  pUnitScore = 0;
	if(gCurrentCiv == cCivMaltese && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) < 2) pUnitScore = 0;
	xsArraySetInt(pBuildingPriArray, 8, pUnitScore);

	//church score
	pUnitScore = 0;
	if(kbUnitCount(cMyID, gChurchUnit, cUnitStateABQ) == 0) pUnitScore = 2;
	if(gMainTownCenter == -1 || 
	gCurrentAge == cAge1 ||
	kbUnitCount(cMyID, gBarracksUnit, cUnitStateABQ) == 0 || 
	kbUnitCount(cMyID, gChurchUnit, cUnitStateABQ) > 0 ||
	gCurrentWood < kbUnitCostPerResource(gChurchUnit, cResourceWood) ||
	checkBuildingLimit(gChurchUnit) == true || 
	kbProtoUnitAvailable(gChurchUnit) == false || 
	checkBuildingPlan(gChurchUnit) != -1)  pUnitScore = 0;
	if(gCurrentCiv == cCivMaltese && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) < 2) pUnitScore = 0;
	xsArraySetInt(pBuildingPriArray, 11, pUnitScore);

	if (getCivIsNative())
	{
		pUnitScore = 0;
		if(kbUnitCount(cMyID, gFirePitUnit, cUnitStateABQ) == 0) pUnitScore = 1;
		if(gMainTownCenter == -1 || 
		gCurrentAge == cAge1 ||
		kbUnitCount(cMyID, cUnitTypeMilitaryBuilding, cUnitStateABQ) == 0 || 
		kbUnitCount(cMyID, gFirePitUnit, cUnitStateABQ) > 0 ||
		gCurrentWood < kbUnitCostPerResource(gFirePitUnit, cResourceWood) ||
		checkBuildingLimit(gFirePitUnit) == true || 
		kbProtoUnitAvailable(gFirePitUnit) == false || 
		checkBuildingPlan(gFirePitUnit) != -1)  pUnitScore = 0;
		xsArraySetInt(pBuildingPriArray, 14, pUnitScore);
	}

	//arsenal score
	pUnitScore = 0;
	if(kbUnitCount(cMyID, gArsenalUnit, cUnitStateABQ) == 0) pUnitScore = 4;
	if(gMainTownCenter == -1 || 
	gCurrentAge < cAge3 ||
	kbUnitCount(cMyID, cUnitTypeMilitaryBuilding, cUnitStateABQ) < 3 || 
	kbUnitCount(cMyID, gArsenalUnit, cUnitStateABQ) > 0 ||
	gCurrentWood < kbUnitCostPerResource(gArsenalUnit, cResourceWood) ||
	checkBuildingLimit(gArsenalUnit) == true || 
	kbProtoUnitAvailable(gArsenalUnit) == false || 
	checkBuildingPlan(gArsenalUnit) != -1)  pUnitScore = 0;
	if(gCurrentCiv == cCivMaltese && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) < 3) pUnitScore = 0;
	xsArraySetInt(pBuildingPriArray, 10, pUnitScore);

	//artillery score
	pUnitScore = 0;
	if(kbUnitCount(cMyID, gArtilleryDepotUnit, cUnitStateABQ) == 0) pUnitScore = 1;
	if(gMainTownCenter == -1 || 
	gCurrentAge < cAge2 ||
	kbUnitCount(cMyID, cUnitTypeMilitaryBuilding, cUnitStateABQ) < 3 || 
	kbUnitCount(cMyID, gArtilleryDepotUnit, cUnitStateQueued) > 0 ||
	kbUnitCount(cMyID, gArtilleryDepotUnit, cUnitStateBuilding) > 0 ||
	gCurrentWood < kbUnitCostPerResource(gArtilleryDepotUnit, cResourceWood) ||
	checkBuildingLimit(gArtilleryDepotUnit) == true || 
	kbProtoUnitAvailable(gArtilleryDepotUnit) == false || 
	checkBuildingPlan(gArtilleryDepotUnit) != -1)  pUnitScore = 0;
	if(gCurrentCiv == cCivMaltese && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) < 3) pUnitScore = 0;
	xsArraySetInt(pBuildingPriArray, 9, pUnitScore);

	//capitol score
	if(getCivIsEuropean())
	{
		pUnitScore = 0;
		if(kbUnitCount(cMyID, gCapitolUnit, cUnitStateABQ) == 0) pUnitScore = 9;
		if(gMainTownCenter == -1 || 
		gCurrentAge < cAge5 ||
		kbUnitCount(cMyID, gCapitolUnit, cUnitStateQueued) > 0 ||
		kbUnitCount(cMyID, gCapitolUnit, cUnitStateBuilding) > 0 ||
		gCurrentWood < kbUnitCostPerResource(gCapitolUnit, cResourceWood) ||
		checkBuildingLimit(gCapitolUnit) == true || 
		kbProtoUnitAvailable(gCapitolUnit) == false || 
		checkBuildingPlan(gCapitolUnit) != -1)  pUnitScore = 0;
		xsArraySetInt(pBuildingPriArray, 13, pUnitScore);
	}

	//castle score
	if(getCivIsAsian())
	{
		pUnitScore = 0;
		if(kbUnitCount(cMyID, cUnitTypeypCastle, cUnitStateABQ) < kbGetBuildLimit(cMyID, cUnitTypeypCastle)) pUnitScore = 3;
		if(gMainTownCenter == -1 || 
		gCurrentAge < cAge3 ||
		kbUnitCount(cMyID, cUnitTypeypCastle, cUnitStateQueued) > 0 ||
		kbUnitCount(cMyID, cUnitTypeypCastle, cUnitStateBuilding) > 0 ||
		gCurrentWood < kbUnitCostPerResource(cUnitTypeypCastle, cResourceWood) ||
		checkBuildingLimit(cUnitTypeypCastle) == true || 
		kbProtoUnitAvailable(cUnitTypeypCastle) == false || 
		checkBuildingPlan(cUnitTypeypCastle) != -1)  pUnitScore = 0;
		xsArraySetInt(pBuildingPriArray, 15, pUnitScore);
	}
	
	//temple score
	if(getCivIsNative())
	{
		pUnitScore = 0;
		if(kbUnitCount(cMyID, cUnitTypeSPCIncaTemple, cUnitStateABQ) == 0) pUnitScore = 9;
		if(gMainTownCenter == -1 || 
		kbUnitCount(cMyID, cUnitTypeSPCIncaTemple, cUnitStateQueued) > 0 ||
		kbUnitCount(cMyID, cUnitTypeSPCIncaTemple, cUnitStateBuilding) > 0 ||
		gCurrentWood < kbUnitCostPerResource(cUnitTypeSPCIncaTemple, cResourceWood) ||
		checkBuildingLimit(cUnitTypeSPCIncaTemple) == true || 
		kbProtoUnitAvailable(cUnitTypeSPCIncaTemple) == false || 
		checkBuildingPlan(cUnitTypeSPCIncaTemple) != -1)  pUnitScore = 0;
		xsArraySetInt(pBuildingPriArray, 16, pUnitScore);
	}
	
	//bank score
	pUnitScore = 0;
	if(kbUnitCount(cMyID, cUnitTypeBank, cUnitStateABQ) <  kbGetBuildLimit(cMyID, cUnitTypeBank)) pUnitScore = 3;
	if(gMainTownCenter == -1 || 
	kbUnitCount(cMyID, cUnitTypeMilitaryBuilding, cUnitStateABQ) < 1 || 
	kbUnitCount(cMyID, cUnitTypeBank, cUnitStateQueued) > 0 ||
	kbUnitCount(cMyID, cUnitTypeBank, cUnitStateBuilding) > 0 ||
	gCurrentWood < kbUnitCostPerResource(cUnitTypeBank, cResourceWood) ||
	checkBuildingLimit(cUnitTypeBank) == true || 
	kbProtoUnitAvailable(cUnitTypeBank) == false || 
	checkBuildingPlan(cUnitTypeBank) != -1)  pUnitScore = 0;
	xsArraySetInt(pBuildingPriArray, 17, pUnitScore);

	//sacredField score
	if(getCivIsAsian())
	{
		pUnitScore = 0;
		if(kbUnitCount(cMyID, cUnitTypeypSacredField, cUnitStateABQ) < kbGetBuildLimit(cMyID, cUnitTypeypSacredField)) pUnitScore = 3;
		if(gMainTownCenter == -1 || 
		kbUnitCount(cMyID, cUnitTypeMilitaryBuilding, cUnitStateABQ) < 1 || 
		kbUnitCount(cMyID, cUnitTypeypSacredField, cUnitStateQueued) > 0 ||
		kbUnitCount(cMyID, cUnitTypeypSacredField, cUnitStateBuilding) > 0 ||
		gCurrentWood < kbUnitCostPerResource(cUnitTypeypSacredField, cResourceWood) ||
		checkBuildingLimit(cUnitTypeypSacredField) == true || 
		kbProtoUnitAvailable(cUnitTypeypSacredField) == false || 
		checkBuildingPlan(cUnitTypeypSacredField) != -1)  pUnitScore = 0;
		xsArraySetInt(pBuildingPriArray, 18, pUnitScore);
	}

	//warTent score
	if(getCivIsNative())
	{
		pUnitScore = 0;
		if(kbUnitCount(cMyID, cUnitTypeWarTent, cUnitStateABQ) < kbGetBuildLimit(cMyID, cUnitTypeWarTent)) pUnitScore = 3;
		if(gMainTownCenter == -1 || 
		kbUnitCount(cMyID, cUnitTypeMilitaryBuilding, cUnitStateABQ) < 1 || 
		kbUnitCount(cMyID, cUnitTypeWarTent, cUnitStateQueued) > 0 ||
		kbUnitCount(cMyID, cUnitTypeWarTent, cUnitStateBuilding) > 0 ||
		gCurrentWood < kbUnitCostPerResource(cUnitTypeWarTent, cResourceWood) ||
		checkBuildingLimit(cUnitTypeWarTent) == true || 
		kbProtoUnitAvailable(cUnitTypeWarTent) == false || 
		checkBuildingPlan(cUnitTypeWarTent) != -1)  pUnitScore = 0;
		xsArraySetInt(pBuildingPriArray, 19, pUnitScore);
	}
	
	//command post score
	if(getCivIsEuropean())
	{
		pUnitScore = 0;
		if(kbUnitCount(cMyID, cUnitTypeSPCFortCenter, cUnitStateABQ) < kbGetBuildLimit(cMyID, cUnitTypeSPCFortCenter)) pUnitScore = 3;
		if(gMainTownCenter == -1 || 
		kbUnitCount(cMyID, cUnitTypeMilitaryBuilding, cUnitStateABQ) < 1 || 
		kbUnitCount(cMyID, cUnitTypeSPCFortCenter, cUnitStateQueued) > 0 ||
		kbUnitCount(cMyID, cUnitTypeSPCFortCenter, cUnitStateBuilding) > 0 ||
		gCurrentWood < kbUnitCostPerResource(cUnitTypeSPCFortCenter, cResourceWood) ||
		checkBuildingLimit(cUnitTypeSPCFortCenter) == true || 
		kbProtoUnitAvailable(cUnitTypeSPCFortCenter) == false || 
		checkBuildingPlan(cUnitTypeSPCFortCenter) != -1)  pUnitScore = 0;
		if(gCurrentCiv == cCivMaltese && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) < 2) pUnitScore = 0;
		xsArraySetInt(pBuildingPriArray, 20, pUnitScore);
	}

	for(i = 0; < pBuildingArraySize)
	{ //find the highest score building
		if(xsArrayGetInt(pBuildingPriArray,i) == -1) break;
		if(pHighestValue < xsArrayGetInt(pBuildingPriArray,i))
		{
			pHighestValue = xsArrayGetInt(pBuildingPriArray,i);
			if(pHighestValue != 0) pSlot = i;
		}
	}
	if(pSlot != -1) buildingMonitorBuildCheck(xsArrayGetInt(pBuildingArray,pSlot));
	
	for(i = 0; < pBuildingArraySize)
	{ //reset array
		xsArraySetInt(pBuildingPriArray, i, 0);
	}

	/*
	gTradingPostUnit
	gFarmUnit
	gPlantationUnit	
    */
}

//==============================================================================
/*
 ageMonitor
 updatedOn 2023/07/12
 
 How to use
 is auto called in main_rules mainRules
*/
//==============================================================================
void ageMonitor()
{
	debugRule("ageMonitor ", -1);
	static bool pInAge2 = false;
	if (gCurrentAge > cAge2 && pInAge2 == false)
	{
		debugRule("ageMonitor - findEnemyBase  ", 1);
		pInAge2 = true;
		findEnemyBase(); // Create a one-off explore plan to probe the likely enemy base location.
		gLastAttackMissionTime = gCurrentGameTime - 180000; // Pretend they all fired 3 minutes ago, even if that's a negative number.
		gLastDefendMissionTime = gCurrentGameTime - 300000; // Actually, start defense ratings at 100% charge, i.e. 5 minutes since last one.
		gLastClaimMissionTime = gCurrentGameTime - 180000;
	}
	debugRule("ageMonitor - end", 0);
}

//==============================================================================
// wallMonitor
/*
Ai logic for building walls, currently using the ring method.
limitations, trade roads overlap
*/
// updatedOn 2022/02/23 By ageekhere
//==============================================================================
void wallMonitor()
{
	if(gIslandLanded == true || kbBaseGetUnderAttack(cMyID, gMainBase) == true) return;
	if(gTreatyActive == true || gCurrentAge < cAge3)return;	
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 60000,"wallMonitor") == false) return;
	lastRunTime = gCurrentGameTime;
	
	static int lastGameTime = 0; //time from last plan set to active
	static bool sentChat = false; //for onlying chatting once for walls	
	static int enemyWallQry = -1; //find enemy walls
	static bool wallChat = false;
	
	static int wallPlan = -1;
	int enemyCount = getUnitCountByLocation(cUnitTypeUnit, cPlayerRelationEnemyNotGaia, cUnitStateAlive, gMainBaseLocation, 100.0);
	if(enemyCount > 0)
	{
		if(wallPlan != -1) aiPlanDestroy(wallPlan);
		return();
	}
	
	if(aiPlanGetActive(wallPlan) == true)return;
	aiPlanDestroy(wallPlan);
	if (wallChat == false)
	{ //Check if enemy wall chat has been sent
		if (enemyWallQry == -1) 
		{
			enemyWallQry = kbUnitQueryCreate("enemyWallQry"+getQueryId()); //new enemy wall qry
			kbUnitQuerySetPlayerID(enemyWallQry,-1,false);
			kbUnitQuerySetPlayerRelation(enemyWallQry, cPlayerRelationEnemyNotGaia); // find enemy walls that are not gaia
			kbUnitQuerySetUnitType(enemyWallQry, cUnitTypeAbstractWall); //set to look for enemy walls
			kbUnitQuerySetIgnoreKnockedOutUnits(enemyWallQry, true);
			kbUnitQuerySetState(enemyWallQry, cUnitStateAlive); //that are alive
		}
		kbUnitQueryResetResults(enemyWallQry);	

		if (kbUnitQueryExecute(enemyWallQry) > 0)
		{ //found wall
			wallChat = true; //disable chat
			sendStatement(cPlayerRelationEnemy, cAICommPromptToEnemyWhenHeWallsIn);
			sendStatement(cPlayerRelationAlly, cAICommPromptToAllyWhenHeWallsIn, kbUnitGetPosition(kbUnitQueryGetResult(enemyWallQry, 0))); //send chat	
		} //end if
	} //end if
	if(gCurrentGameTime < 600000 || 
		getUnit(gTownCenter, cMyID, cUnitStateAlive) == -1 || 
		gBaseRelocateStatus == true || 
		cvOkToBuildWalls == false ||
		gGameType == cGameTypeCampaign || 
		gGameType == cGameTypeScenario || 
		lastGameTime > gCurrentGameTime)return; //return when time, no tc, have not moved base, cannot build walls, is campaign or scenario
	static int wallRingRadius = -1; //the size of the wall radius around the TC
	lastGameTime = gCurrentGameTime + 20000; //Time delay between new plans
	static vector startTCposition = cInvalidVector; //store the start TC location
	if (startTCposition == cInvalidVector) startTCposition = gMainBaseLocation;//kbUnitGetPosition(getUnit(gTownCenter, cMyID, cUnitStateAlive)); //store the start TC location
	int teamTcDist = 99999999; //stores the min dist to team TC
	int tcID = -1; //temp store tc ID
	int tcDist = -1; //temp store tc Dist
	int teamSize = 0; //store team size
	if (wallRingRadius == -1)
	{ //find the ring radius size
		for (i = 1; < cNumberPlayers)
		{ //loop through players
			if (gPlayerTeam == kbGetPlayerTeam(i) && (i != cMyID))
			{ //That are on my team and is not me
				teamSize++; //count the team size
				tcID = getUnit(gTownCenter, i, cUnitStateAlive); //get start tc
				tcDist = distance(startTCposition, kbUnitGetPosition(tcID)); //get dist from my tc to this tc
				if (teamTcDist > tcDist && tcID != -1) teamTcDist = tcDist; //if the dist is more than my last dist check store it
			} //end if
		} //end for i
		wallRingRadius = teamTcDist * 0.45; //sore the ring radius 
	} //end if
	if(teamSize < 4)wallRingRadius = 70;
	else if (wallRingRadius > 40) wallRingRadius = 40; //have a max wall size of 44
	else if (wallRingRadius > 20 && wallRingRadius < 30) wallRingRadius = 20; // if the ring radius is between 20 and 30, just make the wall size 20
	static int wallPlanID = -1; //new wall plan
	aiPlanDestroy(wallPlanID); //Destroy the wall plan, the reason is even though there is an active wall plan the AI does not rebuild the wall. So a new plan is created to fill in any gaps. 
	wallPlanID = -1; //reset id
	if (wallRingRadius >= 20)
	{ //only build a town wall when you are more than 20 away from a team TC
		wallPlan = createWallPlanRing(wallPlanID, "WallInBase", 2, startTCposition, wallRingRadius, 16);
		if (sentChat == false)
		{ //check if the ai has sent a message when walling up
			sentChat = true; //turn off wall chatting
			sendStatement(cPlayerRelationAlly, cAICommPromptToAllyWhenIWallIn); //send the wall chat
		} //end if
	} //end if
	return;
	if (gCurrentAge < cAge5) return; //do not build outer wall
	if (gCurrentAge == cAge5 && teamSize > 3) return; //do not build outer wall
	//Build an out wall around all players
	vector outerWallPosition = cInvalidVector; //The wall location
	static int flankPlayerA = 0; //team player flank A position
	static int flankPlayerB = 0; //team player flank B position
	int wallOuterPlanID = -1; //new outer wall plan
	aiPlanDestroy(wallOuterPlanID); //Destroy the wall plan
	wallOuterPlanID = -1; //reset id
	float mapSizeValue = kbGetMapZSize(); //set the map size
	if (kbGetMapZSize() > kbGetMapXSize()) mapSizeValue = kbGetMapXSize(); //change the map size if X is < Z
	wallRingRadius = mapSizeValue * 35 * 0.01; //set the ring size
	teamTcDist = 0; //reset the tc dist
	if (flankPlayerA == 0 || flankPlayerB == 0)
	{ //Find the two flank players
		for (i = 1; < cNumberPlayers)
		{ //loop through players
			if (gPlayerTeam == kbGetPlayerTeam(i))
			{ //That are on my team and is not me
				for (j = 1; < cNumberPlayers)
				{ //loop through players
					if (kbGetPlayerTeam(i) == kbGetPlayerTeam(j) && (j != cMyID))
					{ //check team
						tcDist = distance(kbUnitGetPosition(getUnit(gTownCenter, i, cUnitStateAlive)), kbUnitGetPosition(getUnit(gTownCenter, j, cUnitStateAlive))); //store dist
						if (teamTcDist < tcDist)
						{ //check dist
							teamTcDist = tcDist; //set team tc dist
							flankPlayerA = i; //set flank player
							flankPlayerB = j; //set flank player
						} //end if
					} //end if
				} //end for j
			} //end if
		} //end for i
	} //end if
	if (teamSize < 3 )
	{
		flankPlayerA = cMyID;
		flankPlayerB = cMyID;
		wallRingRadius = 100;
		
	}		
	if (flankPlayerA == 0 || flankPlayerB == 0) return; //return if the flank players are not found
	/*
	if (outerWallPosition == cInvalidVector)
	{ //find the middle position of the two flank players 
		outerWallPosition = xsVectorSet((xsVectorGetX(kbBaseGetLocation(flankPlayerA, kbBaseGetMainID(flankPlayerA))) +
			xsVectorGetX(kbBaseGetLocation(flankPlayerB, kbBaseGetMainID(flankPlayerB)))) * 0.5, 0, (xsVectorGetZ(kbBaseGetLocation(flankPlayerA, kbBaseGetMainID(flankPlayerA))) +
			xsVectorGetZ(kbBaseGetLocation(flankPlayerB, kbBaseGetMainID(flankPlayerB)))) * 0.5);
	} //end if
	*/
	
	createWallPlanRing(wallOuterPlanID, "wallOuterPlanID", 2, outerWallPosition, wallRingRadius, 25);
} //end

//==============================================================================
// bankWagonMonitor
// updatedOn 2020/03/15 By ageekhere
//==============================================================================
void bankWagonMonitor()
{
	return;
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"bankWagonMonitor") == false) return;
	lastRunTime = gCurrentGameTime;
	
	//if (gCurrentAge < cAge2 || kbGetCiv() != cCivDutch) return;
	static int sendBank = -1;
	if(sendBank == -1)
	{
		sendBank = kbUnitQueryCreate("sendBank"+getQueryId());
		kbUnitQuerySetPlayerID(sendBank, cMyID, false);
		kbUnitQuerySetPlayerRelation(sendBank, -1);
		kbUnitQuerySetUnitType(sendBank, cUnitTypeBankWagon);
		kbUnitQuerySetState(sendBank, cUnitStateAlive);
		kbUnitQuerySetActionType(sendBank, 7);
	}
	kbUnitQueryResetResults(sendBank);

	static int sendBank2 = -1;
	if(sendBank2 == -1)
	{
		sendBank2 = kbUnitQueryCreate("sendBank2"+getQueryId());
		kbUnitQuerySetPlayerRelation(sendBank2, -1);
		kbUnitQuerySetPlayerID(sendBank2, cMyID, false);
		kbUnitQuerySetUnitType(sendBank2, cUnitTypeypBankWagon);
		kbUnitQuerySetState(sendBank2, cUnitStateAlive);
		kbUnitQuerySetActionType(sendBank2, 7);
	}
	kbUnitQueryResetResults(sendBank2);

	int banktype1 = kbUnitQueryExecute(sendBank);
	int banktype2 = kbUnitQueryExecute(sendBank2);
	int totalWagons = banktype1 + banktype2;
	int buildLimit = kbGetBuildLimit(cMyID, cUnitTypeBank);

	int total = 0;
	if (gBankNum == buildLimit) return;

	if (totalWagons > buildLimit) total = buildLimit;
	if (totalWagons <= buildLimit) total = totalWagons;
		
	if (total > 0)
	{
		//aiTaskUnitBuild( kbUnitQueryGetResult(sendBank, 0) , cUnitTypeBank, aiRandLocation() );
		if(banktype1 > 0)
		{
			if(getWagonBuildCheck(cUnitTypeBank, cUnitTypeBankWagon) == false )return;
			//buildingBluePrint(cUnitTypeBankWagon,kbUnitQueryGetResult(sendBank, 0));
			createLocationBuildPlan(cUnitTypeBank, 1, 100, true, cEconomyEscrowID, gMainBaseLocation, 1,-1); //build in base
		}
		if(banktype2 > 0)
		{
			if(getWagonBuildCheck(cUnitTypeypBankAsian, cUnitTypeypBankAsian) == false )return;
			//buildingBluePrint(cUnitTypeBankWagon,kbUnitQueryGetResult(sendBank2, 0));
			createLocationBuildPlan(cUnitTypeypBankAsian, 1, 100, true, cEconomyEscrowID, gMainBaseLocation, 1,-1); //build in base
		}
	}
}

//==============================================================================
/*
 coveredWagonMonitor
 updatedOn 2023/12/09
 uses covered Wagon to build towncenters
 
 How to use
 Is auto called in mainRules()
*/
//==============================================================================
extern int coveredWagonId = -1;
void coveredWagonMonitor()
{ // Handle nomad start, extra covered wagons.
	static bool pFirstRun = true;
	static int lastRunTime = 0;
	if(pFirstRun)
	{
		pFirstRun = false;
		if(functionDelay(lastRunTime, 10000,"coveredWagonMonitor") == false) return;
		lastRunTime = gCurrentGameTime;
	}
	int coveredWagon = getUnit(gCoveredWagonUnit, cMyID, cUnitStateAlive);
	if (coveredWagon == -1) return;
	if(checkBuildingLimit(gCoveredWagonUnit) == true) return;
	//if ( (coveredWagon >= 0) && (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gTownCenter) < 0) )// Check if we have a covered wagon, but no TC build plan....
	if ((coveredWagon >= 0) && (coveredWagonId != coveredWagon))
	{
		coveredWagonId = coveredWagon;
		// We need to figure out where to put the new TC.  Start with the current main base as an anchor.
		// From that, check all gold mines within 100 meters and on the same area group.  For each, see if there
		// is a TC nearby, if not, do it.  
		// If all gold mines fail, use the main base location and let it sort it out in the build plan, i.e. TCs repel, gold attracts, etc.
		static int mineQuery = -1;
		if (mineQuery == -1) 
		{
			mineQuery = kbUnitQueryCreate("Mine query for TC placement"+getQueryId());
			kbUnitQuerySetPlayerID(mineQuery, 0,false);
			kbUnitQuerySetPlayerRelation(mineQuery, -1); 
			kbUnitQuerySetUnitType(mineQuery, cUnitTypeMine);
			kbUnitQuerySetMaximumDistance(mineQuery, 100.0);
			kbUnitQuerySetAscendingSort(mineQuery, true); // Ascending distance from initial location
		}
		kbUnitQueryResetResults(mineQuery);
		kbUnitQuerySetPosition(mineQuery, gMainBaseLocation);
		
		int mineCount = kbUnitQueryExecute(mineQuery);
		int i = 0;
		int mineID = -1;
		vector loc = cInvalidVector;
		int mineAreaGroup = -1;
		int mainAreaGroup = kbAreaGroupGetIDByPosition(gMainBaseLocation);
		bool found = false;
		for (i = 0; < mineCount)
		{ // Check each mine for a nearby TC, i.e. w/in 30 meters.
			mineID = kbUnitQueryGetResult(mineQuery, i);
			loc = kbUnitGetPosition(mineID);
			mineAreaGroup = kbAreaGroupGetIDByPosition(loc);
			if ((getUnitByLocation(gTownCenter, cPlayerRelationAny, cUnitStateABQ, loc, 30.0) < 0) && (mineAreaGroup == mainAreaGroup))
			{
				found = true;
				break;
			}
		}
		if(getWagonBuildCheck(cUnitTypeTownCenter, gCoveredWagonUnit) == false )return;
		
		// If we found a mine without a nearby TC, use that mine's location.  If not, use the main base.
		if (found == false) loc = gMainBaseLocation;
		if (loc == cInvalidVector) loc = kbUnitGetPosition(coveredWagon);
		gTCSearchVector = loc;
		aiTaskUnitMove(coveredWagon, gTCSearchVector);
		createTCBuildPlan(gTCSearchVector);
	}
}


//==============================================================================
/* BHG Consulate monitor
	
	Make sure we have a Consulate around.
	Research Consulate Techs as appropriate.
	
*/
//==============================================================================
//rule consulateMonitor
//inactive
//minInterval 45
void consulateMonitor()
{
	static int lastRunTime = 0;
	static int consulateQueryID = -1;
	if(functionDelay(lastRunTime, 30000,"consulateMonitor") == false) return;
	lastRunTime = gCurrentGameTime;
	
	// Disable rule for non-Asian civilizations
	if (getCivIsAsian() == false)
	{
		//xsDisableSelf();
		return;
	}

	// Quit if consulate is not allowed and not already built
	if ((cvOkToBuildConsulate == false) && (kbUnitCount(cMyID, cUnitTypeypConsulate, cUnitStateAlive) == 0))
	{
		return;
	}

	// Build a consulate if there is none
	if ((kbUnitCount(cMyID, cUnitTypeypConsulate, cUnitStateABQ) < 1) && (checkBuildingPlan(cUnitTypeypConsulate) < 0))
	{
		buildingBluePrint(cUnitTypeypConsulate,-1);
		//createSimpleBuildPlan(cUnitTypeypConsulate, 1, 75, true, cEconomyEscrowID, kbBaseGetMainID(cMyID), 1);
		//aiEcho("Starting a new consulate build plan.");
	}

	// If no option has been chosen already, choose one now
	if ((kbUnitCount(cMyID, cUnitTypeypConsulate, cUnitStateAlive) > 0) && (gChosenConsulateFlag == false))
	{
		chooseConsulateFlag();
	}

	// Maximize export generation in Age 4 and above
	if (gCurrentAge >= cAge4)
	{
		if(consulateQueryID == -1) 
		{
			consulateQueryID = kbUnitQueryCreate("consulateGetUnitQuery"+getQueryId());
			kbUnitQuerySetIgnoreKnockedOutUnits(consulateQueryID, true);
			kbUnitQuerySetPlayerRelation(consulateQueryID, -1);
			kbUnitQuerySetPlayerID(consulateQueryID, cMyID,false);
			kbUnitQuerySetUnitType(consulateQueryID, cUnitTypeypConsulate);
			kbUnitQuerySetState(consulateQueryID, cUnitStateAlive);
		}
		
		kbUnitQueryResetResults(consulateQueryID);
		
		//Define a query to get consulate
		if (consulateQueryID != -1)
		{
			int numberFound = kbUnitQueryExecute(consulateQueryID);
			// Set export gathering rate to +60 %
			if (numberFound > 0)
			{
				aiUnitSetTactic(kbUnitQueryGetResult(consulateQueryID, 0), cTacticTax10);
			}
		}
	}
	// Research consulate technologies one at a time
	// Unavailable techs are simply ignored
	int upgradePlanID = -1;

	// British technologies
	// (none)

	// Dutch technologies
	// (bank wagon, arsenal wagon, church wagon)
	if (kbTechGetStatus(cTechypConsulateDutchSaloonWagon) == cTechStatusObtainable)
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulateDutchSaloonWagon);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypConsulateDutchSaloonWagon, getUnit(cUnitTypeypConsulate), cEconomyEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechypConsulateDutchArsenalWagon) == cTechStatusObtainable)
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulateDutchArsenalWagon);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypConsulateDutchArsenalWagon, getUnit(cUnitTypeypConsulate), cEconomyEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechypConsulateDutchChurchWagon) == cTechStatusObtainable)
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulateDutchChurchWagon);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypConsulateDutchChurchWagon, getUnit(cUnitTypeypConsulate), cEconomyEscrowID, 50);
		return;
	}

	// French technologies
	// (none)

	// German technologies
	// (none)

	// Japanese isolation technologies
	// (Clan offerings)
	if ((kbTechGetStatus(cTechypConsulateJapaneseKoujou) == cTechStatusObtainable) && (kbUnitCount(cMyID, cUnitTypeypCastle, cUnitStateAlive) >= 5))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulateJapaneseKoujou);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypConsulateJapaneseKoujou, getUnit(cUnitTypeypConsulate), cMilitaryEscrowID, 50);
		return;
	}

	// Ottoman technologies
	// (Great bombards)
	if (kbTechGetStatus(cTechypConsulateOttomansGunpowderSiege) == cTechStatusObtainable)
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulateOttomansGunpowderSiege);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypConsulateOttomansGunpowderSiege, getUnit(cUnitTypeypConsulate), cMilitaryEscrowID, 50);
		return;
	}

	// Portuguese technologies
	// (Ironclad)
	if ((kbTechGetStatus(cTechypConsulatePortugueseExpeditionaryFleet) == cTechStatusObtainable) && (gNavyFlagUnit > 0))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulatePortugueseExpeditionaryFleet);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypConsulatePortugueseExpeditionaryFleet, getUnit(cUnitTypeypConsulate), cMilitaryEscrowID, 50);
		return;
	}

	// Russian technologies
	// (fort wagon, factory wagon, blockhouse wagon)
	if (kbTechGetStatus(cTechypConsulateRussianFortWagon) == cTechStatusObtainable)
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulateRussianFortWagon);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypConsulateRussianFortWagon, getUnit(cUnitTypeypConsulate), cMilitaryEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechypConsulateRussianFactoryWagon) == cTechStatusObtainable)
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulateRussianFactoryWagon);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypConsulateRussianFactoryWagon, getUnit(cUnitTypeypConsulate), cEconomyEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechypConsulateRussianOutpostWagon) == cTechStatusObtainable)
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulateRussianOutpostWagon);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypConsulateRussianOutpostWagon, getUnit(cUnitTypeypConsulate), cEconomyEscrowID, 50);
		return;
	}

	// Spanish technologies
	// (none)
}


//==============================================================================
/* BHG regicide monitor
	
	Pop the regent in the castle
	
*/
//==============================================================================
//rule regicideMonitor
//inactive
//minInterval 10
void regicideMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"regicideMonitor") == false) return;
	lastRunTime = gCurrentGameTime;
	
	//if the castle is up, put the guy in it

	if (kbUnitCount(cMyID, cUnitTypeypDaimyoRegicide, cUnitStateAlive) > 0)
	{
		//gotta find the castle
		static int castleQueryID = -1;
		//If we don't have the query yet, create one.
		if (castleQueryID == -1) 
		{
			castleQueryID = kbUnitQueryCreate("castleGetUnitQuery"+getQueryId());
			kbUnitQuerySetIgnoreKnockedOutUnits(castleQueryID, true);
			kbUnitQuerySetPlayerRelation(castleQueryID, -1);
			kbUnitQuerySetPlayerID(castleQueryID, cMyID,false);
			kbUnitQuerySetUnitType(castleQueryID, cUnitTypeTownCenter);
			kbUnitQuerySetState(castleQueryID, cUnitStateAlive);
		}
		kbUnitQueryResetResults(castleQueryID);
		kbUnitQueryExecute(castleQueryID);

		//gotta find the regent
		static int regentQueryID = -1;
		//If we don't have the query yet, create one.
		
		if (regentQueryID == -1) 
		{
			regentQueryID = kbUnitQueryCreate("regentGetUnitQuery"+getQueryId());
			kbUnitQuerySetIgnoreKnockedOutUnits(regentQueryID, true);
			//Define a query to get all matching units
			kbUnitQuerySetPlayerRelation(regentQueryID, -1);
			kbUnitQuerySetPlayerID(regentQueryID, cMyID,false);
			kbUnitQuerySetUnitType(regentQueryID, cUnitTypeypDaimyoRegicide);
			kbUnitQuerySetState(regentQueryID, cUnitStateAlive);
		}
		kbUnitQueryResetResults(regentQueryID);

		kbUnitQueryExecute(regentQueryID);

		int index = 0;
		aiTaskUnitWork(kbUnitQueryGetResult(regentQueryID, index), kbUnitQueryGetResult(castleQueryID, index));
	}
	//else
	//{
	//	xsDisableSelf();
	//}
}

//==============================================================================
/* BHG orchard monitor
	
	If we have a wagon, build an orchard immediately.
	
*/
//==============================================================================


//==============================================================================
/* xpBuilder monitor
	
	Use an idle xpBuilder to build as needed.
*/
//==============================================================================
//rule xpBuilderMonitor
//inactive
//group tcComplete
//minInterval 10
void xpBuilderMonitor() //to remove
{
	return; 
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"xpBuilderMonitor") == false) return;
	lastRunTime = gCurrentGameTime;
	
	if (getCivIsNative() == false)
	{
		//xsDisableSelf();
		return;
	}
	if (gCurrentAge < cAge2) return;

	static int activePlan = -1;

	if (activePlan != -1) // We already have something active?
	{
		if ((aiPlanGetState(activePlan) < 0) || (aiPlanGetState(activePlan) == cPlanStateNone))
		{
			aiPlanDestroy(activePlan);
			activePlan = -1; // Plan is bad, but didn't die.  It's dead now, so continue below.
		}
		else
		{
			return; // Something is active, let it run.
		}
	}

	// If we get this far, there is no active plan.  See if we have a xpBuilder to use.
	int xpBuilderID = -1;
	int buildingToMake = -1;
	int buildertype = -1;
	if (kbUnitCount(cMyID, cUnitTypexpBuilderStart, cUnitStateAlive) > 0)
	{
		xpBuilderID = getUnit(cUnitTypexpBuilderStart);
		buildingToMake = gHouseUnit; // If all else fails, make a house since we can't make warhuts.
		buildertype = cUnitTypexpBuilderStart;
	}
	else
	{
		xpBuilderID = getUnit(cUnitTypexpBuilder);
		buildingToMake = cUnitTypeWarHut; // If all else fails, make a war hut.
		buildertype = cUnitTypexpBuilder;
	}
	if (xpBuilderID < 0) return;

	// We have a xpBuilder, and no plan to use it.  Find something to do with it.  
	// Simple logic.  Farm if less than 3.  War hut if less than 2.  Corral if < 2.
	// Plantations if less than 3 in Age 3 and above.   House if below build limit.
	// Siege Workshop if less than 2 in Age 3 and above.
	// One override....avoid farms in age 1, they're too slow.
	// Avoid war huts and corrals in Age 1 as starting travois cannot build them.
	//if ( (kbUnitCount(cMyID, gFarmUnit, cUnitStateABQ) < 3) && (gCurrentAge > cAge1) )
	//buildingToMake = gFarmUnit;
	/*
		if ( (kbUnitCount(cMyID, cUnitTypeWarHut, cUnitStateABQ) < 2) && (gCurrentAge > cAge1) )
		buildingToMake = cUnitTypeWarHut;
		else if ( (kbUnitCount(cMyID, cUnitTypeCorral, cUnitStateABQ) < 2) && (gCurrentAge > cAge1) )
		buildingToMake = cUnitTypeCorral;gPlantationUnit
		//else if ( (kbUnitCount(cMyID, cUnitTypePlantation, cUnitStateABQ) < 3) && (gCurrentAge > cAge2) )
		//buildingToMake = cUnitTypePlantation;
		//else if (kbUnitCount(cMyID, gHouseUnit, cUnitStateABQ) < kbGetBuildLimit(cMyID, gHouseUnit))
		//buildingToMake = gHouseUnit;
		else if ( (kbUnitCount(cMyID, cUnitTypeArtilleryDepot, cUnitStateABQ) < 2) && (gCurrentAge > cAge2) )
		buildingToMake = cUnitTypeArtilleryDepot;
	*/


	if (kbUnitCount(cMyID, gBarracksUnit, cUnitStateABQ) < kbGetBuildLimit(cMyID, gBarracksUnit))
	{
		buildingToMake = gBarracksUnit;
	}
	else if (kbUnitCount(cMyID, gStableUnit, cUnitStateABQ) < 3)
	{
		buildingToMake = cUnitTypeStable;
	}
	else if (kbUnitCount(cMyID, gArtilleryDepotUnit, cUnitStateABQ) < 3 && gCurrentAge > cAge3)
	{
		buildingToMake = gArtilleryDepotUnit;
	}
	else if (kbUnitCount(cMyID, gFarmUnit, cUnitStateABQ) >= kbUnitCount(cMyID, gPlantationUnit, cUnitStateABQ))
	{
		buildingToMake = gPlantationUnit;
	}
	else
	{
		buildingToMake = gFarmUnit;
	}

	if (buildingToMake >= 0)
	{
		activePlan = aiPlanCreate("Use an xpBuilder", cPlanBuild);
		// What to build
		aiPlanSetVariableInt(activePlan, cBuildPlanBuildingTypeID, 0, buildingToMake);

		// 8 meter separation for farms and plantations, 3 meter for everything else
		aiPlanSetVariableFloat(activePlan, cBuildPlanBuildingBufferSpace, 0, 3.0);
		if ((buildingToMake == gFarmUnit) || (buildingToMake == cUnitTypePlantation))
			aiPlanSetVariableFloat(activePlan, cBuildPlanBuildingBufferSpace, 0, 8.0);

		//Priority.
		aiPlanSetDesiredPriority(activePlan, 95);
		//Mil vs. Econ.
		if ((buildingToMake == cUnitTypeWarHut) ||
			(buildingToMake == cUnitTypeCorral) ||
			(buildingToMake == cUnitTypeArtilleryDepot))

		{
			aiPlanSetMilitary(activePlan, true);
			aiPlanSetEconomy(activePlan, false);
		}
		else
		{
			aiPlanSetMilitary(activePlan, false);
			aiPlanSetEconomy(activePlan, true);
		}
		aiPlanSetEscrowID(activePlan, cEconomyEscrowID);

		aiPlanAddUnitType(activePlan, buildertype, 1, 1, 1);

		aiPlanSetBaseID(activePlan, kbBaseGetMainID(cMyID));

		//Go.
		aiPlanSetActive(activePlan);
	}
}

//==============================================================================
/* Native Dance Monitor
	
	Manage the number of natives dancing, and the 'tactic' they're dancing for.
	
	const int cTacticFertilityDance=12;   Faster training
	const int cTacticGiftDance=13;         Faster XP trickle
	const int cTacticCityDance=14;
	const int cTacticWaterDance=15;       Increases navy HP/attack
	const int cTacticAlarmDance=16;        Town defense...
	const int cTacticFounderDance=17;      xpBuilder units - Iroquois
	const int cTacticMorningWarsDance=18;
	const int cTacticEarthMotherDance=19;
	const int cTacticHealingDance=20;
	const int cTacticFireDance=21;
	const int cTacticWarDanceSong=22;
	const int cTacticGarlandWarDance=23;
	const int cTacticWarChiefDance=24;    new war chief (Iroquois)
	const int cTacticHolyDance=25;
	const int cTacticWarChiefDanceSioux=28;    new war chief (Sioux)
	const int cTacticWarChiefDanceAztec=29;    new war chief (Aztec)
	
*/
//==============================================================================
//rule danceMonitor
//inactive
//group tcComplete
//minInterval 20
void danceMonitor() 
{
	if (getCivIsNative() == false) return;
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 20000,"danceMonitor") == false) return;
	lastRunTime = gCurrentGameTime;
	
	if (kbUnitCount(cMyID, cUnitTypeFirePit, cUnitStateAlive) == 0) return;
	if (gCurrentAge < cAge3) 
	{
		aiPlanSetVariableInt(gNativeDancePlan, cNativeResearchPlanTacticID, 0, cTacticFertilityDance);
		return;
	}

	if (aiPlanGetState(gNativeDancePlan) == -1)
	{
		aiPlanDestroy(gNativeDancePlan);
		gNativeDancePlan = -1;
	}
	static int counter = 0;

	static int lastTactic = -1;
	static int lastTacticTime = -1;
	static int lastWarChiefTime = -1;
	static int warChiefCount = 0;

	int buildingID = getUnit(cUnitTypeFirePit);
	if (gNativeDancePlan < 0)
	{
		counter++;
		gNativeDancePlan = aiPlanCreate("NativeResearch" + counter, cPlanNativeResearch);

		aiPlanSetVariableInt(gNativeDancePlan, cNativeResearchPlanTacticID, 0, cTacticNormal);
		aiPlanSetVariableInt(gNativeDancePlan, cNativeResearchPlanBuildingID, 0, buildingID);
		aiPlanSetDesiredPriority(gNativeDancePlan, 85);
		aiPlanAddUnitType(gNativeDancePlan, gEconUnit, 1, 1, 1);
		aiPlanSetActive(gNativeDancePlan);

		lastTactic = cTacticNormal;
		lastTacticTime = gCurrentGameTime;
	}

	// Use all available warrior priests as dancers
	int numWarPriests = kbUnitCount(cMyID, cUnitTypexpMedicineManAztec, cUnitStateAlive);
	
	int pMedicineLimit = kbGetBuildLimit(cMyID,cUnitTypexpMedicineManAztec);

	// Add a number of dancers equivalent to 1/5 of settler pop, rounded down
	// Make sure no more than 25 units are assigned in total
	
	//int want = -1;
	//want = gCurrentAliveSettlers / 10;
	int pNumOnFire = kbUnitGetNumberWorkersIfSeeable(buildingID);
	int pNumToSend = 0;

	pNumToSend = 22 - pNumOnFire;
	if(pNumToSend < 1)
	{
		pNumToSend = 0;
	}
	else
	{
		if(gCurrentAliveSettlers < 10)
		{
			pNumToSend = 1;
		}
		else if(gCurrentAliveSettlers < 20)
		{
			pNumToSend = 2;
		}
		else if(gCurrentAliveSettlers < 30)
		{
			pNumToSend = 5;
		}
		else if(gCurrentAliveSettlers < 40)
		{
			pNumToSend = 8;
		}
		else if(gCurrentAliveSettlers < 50)
		{
			pNumToSend = 10;
		}
	}
	if (pNumOnFire < 23 && pNumToSend != 0 )//&& pNumToSend != pNumOnFire - pNumToSend
	{
		if(pNumOnFire - numWarPriests < 23) aiPlanAddUnitType(gNativeDancePlan, cUnitTypexpMedicineManAztec, numWarPriests, numWarPriests, numWarPriests);
		aiPlanAddUnitType(gNativeDancePlan, gEconUnit, pNumToSend, pNumToSend, pNumToSend);
	}

	if(gCurrentAliveSettlers < 50 && pNumOnFire > 10)
	{
		for(i = 0; < 23)
		{
			if (kbUnitIsType(kbUnitGetWorkerID(buildingID,i), gEconUnit)) aiTaskUnitWork(kbUnitGetWorkerID(buildingID,i), kbUnitGetWorkerID(buildingID,i));
		}
	}
	// Select a tactic 
	// Alarm dance if base is under attack
	if (gDefenseReflexBaseID == kbBaseGetMainID(cMyID))
	{
		aiPlanSetVariableInt(gNativeDancePlan, cNativeResearchPlanTacticID, 0, cTacticAlarmDance);
		lastTactic = cTacticAlarmDance;
		lastTacticTime = gCurrentGameTime;
		return;
	}
	// Recover war chief
	if (aiGetFallenExplorerID() >= 0)
	{
		if (cMyCiv == cCivXPIroquois)
		{
			aiPlanSetVariableInt(gNativeDancePlan, cNativeResearchPlanTacticID, 0, cTacticWarChiefDance);
			lastTactic = cTacticWarChiefDance;
		}
		else if (cMyCiv == cCivXPAztec)
		{
			aiPlanSetVariableInt(gNativeDancePlan, cNativeResearchPlanTacticID, 0, cTacticWarChiefDanceAztec);
			lastTactic = cTacticWarChiefDanceAztec;
		}
		else if (cMyCiv == cCivXPSioux)
		{
			aiPlanSetVariableInt(gNativeDancePlan, cNativeResearchPlanTacticID, 0, cTacticWarChiefDanceSioux);
			lastTactic = cTacticWarChiefDanceSioux;
		}
		lastTacticTime = gCurrentGameTime;
		return;
	}

	// Train units faster
	if ((aiPlanGetVariableInt(gSettlerMaintainPlan, cTrainPlanNumberToMaintain, 0) > (kbUnitCount(cMyID, gEconUnit, cUnitStateABQ) + 5)) && (gCurrentPop < gCurrentPopCap))
	{
		aiPlanSetVariableInt(gNativeDancePlan, cNativeResearchPlanTacticID, 0, cTacticFertilityDance);
		lastTactic = cTacticFertilityDance;
		lastTacticTime = gCurrentGameTime;
		return;
	}

	// Travois if age 1 or 2 (Iroquois only)
	// To be used only if they still make sense, i.e. if there are buildings left to be erected 
	if ((gCurrentAge < cAge3) &&
		(kbUnitCount(cMyID, cUnitTypexpBuilder, cUnitStateAlive) < 2) &&
		(kbUnitCount(cMyID, cUnitTypeWarHut, cUnitStateAlive) < kbGetBuildLimit(cMyID, cUnitTypeWarHut)) &&
		(cMyCiv == cCivXPIroquois))
	{
		aiPlanSetVariableInt(gNativeDancePlan, cNativeResearchPlanTacticID, 0, cTacticFounderDance);
		lastTactic = cTacticFounderDance;
		lastTacticTime = gCurrentGameTime;
		return;
	}

	// Spawn skull knights in age 4 or 5 (Aztecs only)
	if ((gCurrentAge >= cAge4) && (cMyCiv == cCivXPAztec) && (aiGetAvailableMilitaryPop() >= 10))
	{
		aiPlanSetVariableInt(gNativeDancePlan, cNativeResearchPlanTacticID, 0, cTacticGarlandWarDance);
		lastTactic = cTacticGarlandWarDance;
		lastTacticTime = gCurrentGameTime;
		return;
	}

	// Spawn dog soldiers in age 4 or 5 (Sioux only)
	if ((gCurrentAge >= cAge4) && (cMyCiv == cCivXPSioux) && (aiGetAvailableMilitaryPop() >= 10))
	{
		aiPlanSetVariableInt(gNativeDancePlan, cNativeResearchPlanTacticID, 0, cTacticWarDanceSong);
		lastTactic = cTacticWarDanceSong;
		lastTacticTime = gCurrentGameTime;
		return;
	}

	// Default: XP trickle
	aiPlanSetVariableInt(gNativeDancePlan, cNativeResearchPlanTacticID, 0, cTacticGiftDance);
	lastTactic = cTacticGiftDance;
	lastTacticTime = gCurrentGameTime;
}

//==============================================================================
/* Rice Paddy Monitor
	
	Switch from Food to Coin.
	
	cTacticPaddyFood
	cTacticPaddyCoin
	
*/
//==============================================================================
//rule ricepaddyMonitor
//inactive
//group tcComplete
//minInterval 60
void ricepaddyMonitor()
{
	if (getCivIsAsian() == false) return;
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 30000,"ricepaddyMonitor") == false) return;
	lastRunTime = gCurrentGameTime;
	
	static int paddyQueryID = -1;
	if (paddyQueryID == -1) paddyQueryID = kbUnitQueryCreate("paddyGetUnitQuery"+getQueryId());
	kbUnitQueryResetResults(paddyQueryID);
	kbUnitQuerySetIgnoreKnockedOutUnits(paddyQueryID, true);
	kbUnitQuerySetPlayerRelation(paddyQueryID, -1);
	kbUnitQuerySetPlayerID(paddyQueryID, cMyID,false);
	kbUnitQuerySetUnitType(paddyQueryID, cUnitTypeypRicePaddy);
	kbUnitQuerySetState(paddyQueryID, cUnitStateAlive);
	
	int numberFound = kbUnitQueryExecute(paddyQueryID);
	for (i = 0; < numberFound)
	{
		if(gCurrentFood > gCurrentCoin && gCurrentFood > 1000)
		{
			aiUnitSetTactic(kbUnitQueryGetResult(paddyQueryID, i), cTacticPaddyCoin);
		}
		
		if(gCurrentCoin > gCurrentFood)
		{
			aiUnitSetTactic(kbUnitQueryGetResult(paddyQueryID, i), cTacticPaddyFood);
		}
	}
}

//==============================================================================
/* Shrine Monitor
	
	Uses shrine wagons to build shrines. In Age 3 and above shrine production
	is cycled through the resource options once per minute.
	
*/
//==============================================================================
//rule shrineMonitor
//inactive
//group tcComplete
//minInterval 20
void shrineMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"shrineMonitor") == false) return;
	lastRunTime = gCurrentGameTime;
	
	// Disable for anybody but Japanese
	if (kbGetCiv() != cCivJapanese && kbGetCiv() != cCivSPCJapanese && kbGetCiv() != cCivSPCJapaneseEnemy)
	{
		//xsDisableSelf();
		return;
	}


	// Use shrine wagons
	if ((kbUnitCount(cMyID, cUnitTypeypShrineWagon, cUnitStateAlive) > 0) && (checkBuildingPlan(cUnitTypeypShrineJapanese) < 0))
	{
		if(getWagonBuildCheck(cUnitTypeypShrineJapanese, cUnitTypeypShrineWagon) == false )return;
		buildingBluePrint(cUnitTypeypShrineJapanese,-1);
		//createSimpleBuildPlan(cUnitTypeypShrineJapanese, 1, 100, true, cEconomyEscrowID, kbBaseGetMainID(cMyID), 1);
	}
	
	
	static int shrineQueryID = -1;
	if (shrineQueryID == -1) shrineQueryID = kbUnitQueryCreate("shrineGetUnitQuery"+getQueryId());
	kbUnitQueryResetResults(shrineQueryID);
	kbUnitQuerySetIgnoreKnockedOutUnits(shrineQueryID, true);
	kbUnitQuerySetPlayerRelation(shrineQueryID, -1);
	kbUnitQuerySetPlayerID(shrineQueryID, cMyID,false);
	kbUnitQuerySetUnitType(shrineQueryID, cUnitTypeypShrineJapanese);
	kbUnitQuerySetState(shrineQueryID, cUnitStateAlive);
	
	int num = kbUnitQueryExecute(shrineQueryID);

	for(i = 0; < num )
	{

		if (gCurrentAge == cAge1)
		{
			aiUnitSetTactic(kbUnitQueryGetResult(shrineQueryID, i), cTacticShrineFood);
		}
		
		else if (gCurrentAge > cAge2 && gCurrentWood < 450)
		{
			aiUnitSetTactic(kbUnitQueryGetResult(shrineQueryID, i), cTacticShrineFood);
		}
		
		else if(gCurrentCoin < gCurrentFood)
		{
			aiUnitSetTactic(kbUnitQueryGetResult(shrineQueryID, i), cTacticShrineCoin);
		}
		else if(gCurrentFood < gCurrentCoin)
		{
			aiUnitSetTactic(kbUnitQueryGetResult(shrineQueryID, i), cTacticShrineFood);
		}	
	}

	
	return;
	
/*
	// Cycle through resource generation options
	static int shrineTactic = -1;
	if (gCurrentAge >= cAge2)
	{
		// Define a query to get all matching units
		int shrineQueryID = -1;
		shrineQueryID = kbUnitQueryCreate("shrineGetUnitQuery");
		kbUnitQuerySetIgnoreKnockedOutUnits(shrineQueryID, true);
		if (shrineQueryID != -1)
		{
			kbUnitQuerySetPlayerRelation(shrineQueryID, -1);
			kbUnitQuerySetPlayerID(shrineQueryID, cMyID);
			kbUnitQuerySetUnitType(shrineQueryID, cUnitTypeypShrineJapanese);
			kbUnitQuerySetState(shrineQueryID, cUnitStateAlive);
			kbUnitQueryResetResults(shrineQueryID);
			int numberFound = kbUnitQueryExecute(shrineQueryID);
			if (numberFound > 0)
			{
				shrineTactic = shrineTactic + 1;
				if (shrineTactic > 8)
					shrineTactic = 0;
				switch (shrineTactic)
				{
					case 0:
						{
							aiUnitSetTactic(kbUnitQueryGetResult(shrineQueryID, 0), cTacticShrineFood);
							break;
						}
					case 3:
						{
							aiUnitSetTactic(kbUnitQueryGetResult(shrineQueryID, 0), cTacticShrineWood);
							break;
						}
					case 6:
						{
							aiUnitSetTactic(kbUnitQueryGetResult(shrineQueryID, 0), cTacticShrineCoin);
							break;
						}
					default:
						{
							// stay with what we are at for one or two more cycles
							break;
						}
				}
			}
		}
	}
	else
	{
		aiUnitSetTactic(kbUnitQueryGetResult(shrineQueryID, 0), cTacticShrineFood);
	}
	*/
}


//rule tcMonitor
//inactive
//minInterval 10
void buildTownCenterMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"buildTownCenterMonitor") == false) return;
	lastRunTime = gCurrentGameTime;

	if(gCurrentCiv == cCivMaltese && checkBuildingLimit(gTownCenter) == false )
	{
		switch (gCurrentAge)
		{
			case cAge1: { if(kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) < 1) createLocationBuildPlan(gTownCenter, 1, 100, true, cEconomyEscrowID, gMainBaseLocation, 1,-1); break; }
			case cAge2: { if(kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) < 3) createLocationBuildPlan(gTownCenter, 1, 100, true, cEconomyEscrowID, gMainBaseLocation, 1,-1); break; }
			case cAge3: { if(kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) < 4) createLocationBuildPlan(gTownCenter, 1, 100, true, cEconomyEscrowID, gMainBaseLocation, 1,-1); break; }
			case cAge4: { if(kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) < 5) createLocationBuildPlan(gTownCenter, 1, 100, true, cEconomyEscrowID, gMainBaseLocation, 1,-1); break; }
		}
		return;
	}

	if(gCurrentCiv == cCivPortuguese && gCurrentAge < cAge4)return;
	
	static bool killAllPlans = false;
	static int lastKillTime = 0;

	if(kbUnitCount(cMyID, cUnitTypeCoveredWagon,cUnitStateABQ) > 0)return;

	if (gCurrentAge < cAge3 && getUnit(gTownCenter, cMyID, cUnitStateABQ) != -1) return;
	
	if (gCurrentWood > 600 && kbUnitCount(cMyID, gTownCenter,cUnitStateAlive) < kbGetBuildLimit(cMyID, gTownCenter))
	{
		createLocationBuildPlan(gTownCenter, 1, 100, true, cEconomyEscrowID, gMainBaseLocation, 1,-1);
	}
	if(getUnit(gTownCenter, cMyID, cUnitStateABQ) == -1 && gCurrentWood < 600 && killAllPlans == false)
	{
		lastKillTime = gCurrentGameTime;
		killAllPlans = true;
		for (j = 0; < 3000)
		{ //loop through all settlers
			aiPlanDestroy(j);
		}
	}
	bool foundTeamPlayer = false;
	static bool allocateNewBase = false;
	static int newBaseID = -1;
	if(gCurrentWood > 600 && getUnit(gTownCenter, cMyID, cUnitStateABQ) == -1)
	{
		for (t = 1; < cNumberPlayers)
		{ //loop through players
			if (gPlayerTeam == kbGetPlayerTeam(t) && (t != cMyID) && kbHasPlayerLost(t) == false && getUnit(gTownCenter, t, cUnitStateAlive) != -1)
			{ //That are on my team and is not me
				createLocationBuildPlan(gTownCenter, 1, 100, true, cEconomyEscrowID, kbUnitGetPosition(getUnit(gTownCenter, t, cUnitStateAlive)) , 100,-1);
				foundTeamPlayer = true;
				allocateNewBase = true;
				break;
			}
		}
		
		if(foundTeamPlayer == false) 
		{
			createLocationBuildPlan(gTownCenter, 1, 100, true, cEconomyEscrowID, gMainBaseLocation, 100,-1);
		}
		return;
	}
	if(allocateNewBase == true && getUnit(gTownCenter, cMyID, cUnitStateAlive) != -1) 
	{	
		kbBaseDestroyAll(cMyID);
		newBaseID = kbBaseCreate(cMyID, "Base" + kbBaseGetNextID(), kbUnitGetPosition(getUnit(gTownCenter, t, cUnitStateAlive)), 50.0);
		kbBaseSetMain(cMyID, newBaseID, true);
		allocateNewBase = false;
		createMainBase(kbUnitGetPosition(getUnit(gTownCenter, cMyID, cUnitStateAlive)));
		gBaseRelocateStatus = true;
	}


	if(lastKillTime - gCurrentGameTime > 300000 )
	{
		lastKillTime = gCurrentGameTime;
		killAllPlans = true;
		newBaseID = -1;
	}


 


return;
/*
	//updatedOn 2019/04/04 By ageekhere  
	//---------------------------
	//if (kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) < 1 && kbUnitCount(cMyID, cUnitTypeSettlerWagon, cUnitStateABQ) == 0) xsDisableSelf(); //this stops overriding the runaway rule

	//---------------------------
	if (cvOkToBuild == false)
		return; // Quit if AI is not allowed to build

	if (gCurrentGameTime < 60000)
		return; // Give first plan 60 sec to get going

	static float nextRadius = 50.0;

	int count = kbUnitCount(cMyID, gTownCenter, cUnitStateABQ);
	int plan = -1;
	if (count < 1)
		plan = aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gTownCenter, true);

	if ((count > 0) || (plan >= 0))
		return; // We have a TC or a TC build plan, no more work to do.

	if ((count == 0) && (plan >= 0))
		aiPlanDestroy(plan); // Destroy old plan to keep it from blocking the rule

	//aiEcho("Starting a new TC build plan.");
	// Make a town center, pri 100, econ, main base, 1 builder (explorer).
	int buildPlan = aiPlanCreate("TC Build plan explorer", cPlanBuild);
	// What to build
	aiPlanSetVariableInt(buildPlan, cBuildPlanBuildingTypeID, 0, gTownCenter);
	// Priority.
	aiPlanSetDesiredPriority(buildPlan, 100);
	// Mil vs. Econ.
	aiPlanSetMilitary(buildPlan, false);
	aiPlanSetEconomy(buildPlan, true);
	// Escrow.
	aiPlanSetEscrowID(buildPlan, cEconomyEscrowID);
	// Builders.
	int wantVill = 1;
	if (kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) < 1 && kbUnitCount(cMyID, cUnitTypeSettlerWagon, cUnitStateABQ) == 0) wantVill = getUnit(gEconUnit, cMyID, cUnitStateAlive);
	switch (kbGetCiv())
	{
		case cCivXPAztec:
			{
				aiPlanAddUnitType(buildPlan, cUnitTypexpAztecWarchief, wantVill, wantVill, wantVill);
				aiPlanAddUnitType(buildPlan, gEconUnit, wantVill, wantVill, wantVill);
				break;
			}
		case cCivXPIroquois:
			{
				aiPlanAddUnitType(buildPlan, cUnitTypexpIroquoisWarChief, wantVill, wantVill, wantVill);
				aiPlanAddUnitType(buildPlan, gEconUnit, wantVill, wantVill, wantVill);
				break;
			}
		case cCivXPSioux:
			{
				aiPlanAddUnitType(buildPlan, cUnitTypexpLakotaWarchief, wantVill, wantVill, wantVill);
				aiPlanAddUnitType(buildPlan, gEconUnit, wantVill, wantVill, wantVill);
				break;
			}
		case cCivChinese:
			{
				aiPlanAddUnitType(buildPlan, cUnitTypeypMonkChinese, wantVill, wantVill, wantVill);
				aiPlanAddUnitType(buildPlan, gEconUnit, wantVill, wantVill, wantVill);
				break;
			}
		case cCivIndians:
			{
				aiPlanAddUnitType(buildPlan, cUnitTypeypMonkIndian, wantVill, wantVill, wantVill);
				aiPlanAddUnitType(buildPlan, cUnitTypeypMonkIndian2, wantVill, wantVill, wantVill);
				aiPlanAddUnitType(buildPlan, gEconUnit, wantVill, wantVill, wantVill);
				break;
			}
		case cCivJapanese:
			{
				aiPlanAddUnitType(buildPlan, cUnitTypeypMonkJapanese, wantVill, wantVill, wantVill);
				aiPlanAddUnitType(buildPlan, cUnitTypeypMonkJapanese2, wantVill, wantVill, wantVill);
				aiPlanAddUnitType(buildPlan, gEconUnit, wantVill, wantVill, wantVill);
				break;
			}
		default:
			{
				aiPlanAddUnitType(buildPlan, gExplorerUnit, wantVill, wantVill, wantVill);
				aiPlanAddUnitType(buildPlan, cUnitTypeEnvoy, wantVill, wantVill, wantVill);
				aiPlanAddUnitType(buildPlan, gEconUnit, wantVill, wantVill, wantVill);
				break;
			}
	}
	xsEnableRule("townCenterComplete"); //activate town center complete
	kbBaseSetActive(cMyID, gMainBase, true); //set base as active

	// Instead of base ID or areas, use a center position and falloff.
	aiPlanSetVariableVector(buildPlan, cBuildPlanCenterPosition, 0, gMainBaseLocation);
	aiPlanSetVariableFloat(buildPlan, cBuildPlanCenterPositionDistance, 0, nextRadius);
	nextRadius = nextRadius + 50.0; // If it fails again, search even farther out.

	// Add position influences for trees, gold
	aiPlanSetNumberVariableValues(buildPlan, cBuildPlanInfluenceUnitTypeID, 3, true);
	aiPlanSetNumberVariableValues(buildPlan, cBuildPlanInfluenceUnitDistance, 3, true);
	aiPlanSetNumberVariableValues(buildPlan, cBuildPlanInfluenceUnitValue, 3, true);
	aiPlanSetNumberVariableValues(buildPlan, cBuildPlanInfluenceUnitFalloff, 3, true);
	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitTypeID, 0, cUnitTypeWood);
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitDistance, 0, 30.0); // 30m range.
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitValue, 0, 10.0); // 10 points per tree
	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitFalloff, 0, cBPIFalloffLinear); // Linear slope falloff
	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitTypeID, 1, cUnitTypeMine);
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitDistance, 1, 40.0); // 40 meter range for gold
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitValue, 1, 100.0); // 100 points each
	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitFalloff, 1, cBPIFalloffLinear); // Linear slope falloff
	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitTypeID, 2, cUnitTypeMine);
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitDistance, 2, 20.0); // 20 meter inhibition to keep some space
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitValue, 2, -100.0); // -100 points each
	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitFalloff, 2, cBPIFalloffNone); // Cliff falloff

	// Weight it to prefer the general starting neighborhood
	aiPlanSetVariableVector(buildPlan, cBuildPlanInfluencePosition, 0, gMainBaseLocation); // Position inflence for landing position
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluencePositionDistance, 0, 200.0); // 200m range.
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluencePositionValue, 0, 300.0); // 500 points max
	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluencePositionFalloff, 0, cBPIFalloffLinear); // Linear slope falloff

	// Activate
	aiPlanSetActive(buildPlan);
	*/
}


//==============================================================================
/*
 ageUpgradeMonitor
 updatedOn 2023/06/30
 Creates plans for upgrading to the next age
 
 How to use
 is auto called by main - mainRules
 
 Note: For now the AI will not revolt
*/
//==============================================================================
void ageUpgradeMonitor(void)
{
	debugRule("ageUpgradeMonitor",-1);
	if (gCurrentAge == cAge5 || gCurrentAge == cvMaxAge) return;
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 5000,"ageUpgradeMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	if (gAgeUpResearchPlan >= 0)
	{ //Check if there is an age up plan
		debugRule("ageUpgradeMonitor - plan found",1);
		if (aiPlanGetState(gAgeUpResearchPlan) < 0)
		{ //Clear the plan when state is -1
			debugRule("ageUpgradeMonitor - plan kill plan",2);
			aiPlanDestroy(gAgeUpResearchPlan);
			gAgeUpResearchPlan = -1;
		} //end if
		else return;
	} //end if
	if (getCivIsAsian() == true)
	{ //check for wonder build
		debugRule("ageUpgradeMonitor - build wonder",1);
		buildingBluePrint(chooseAsianWonder(),-1);
	} //end if
	else if (getCivIsNative() == true)
	{ //check for native 
		debugRule("ageUpgradeMonitor - navtive age up",1);
		gAgeUpResearchPlan = createSimpleResearchPlan(chooseNativeCouncilMember(), -1, cEmergencyEscrowID, 100);
	} //end else if
	else
	{ //euro age up
		debugRule("ageUpgradeMonitor - European age up",1);
		gAgeUpResearchPlan = createSimpleResearchPlan(chooseEuropeanPolitician(), -1, cEmergencyEscrowID, 100);
	} //end else
	debugRule("ageUpgradeMonitor - end",0);
} //end ageUpgradeMonitor

//==============================================================================
// extraShipMonitor
// Checks for shipments (not just for extra ones!) and calls appropriate handler
//==============================================================================
//rule extraShipMonitor
//inactive
//group tcComplete
//minInterval 20
void extraShipMonitor()
{
	if (kbResourceGet(cResourceShips) > 0)
	{
		shipGrantedHandler(); // normal shipment handler
	}
}

//==============================================================================
/*
 resignMonitor
 updatedOn 2022/07/13
 Checks to see if the AI should ask to resign
 
 How to use
 Is auto called in mainRules
 
 Example
 int humanPlayer = getHumanOnTeam()
*/
//==============================================================================

void resignMonitor(void)
{
	if (gGameType == cGameTypeCampaign || gGameType == cGameTypeScenario) return;
	if(gCurrentGameTime < 240000) return;

	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"resignMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	static bool haveAskedToResign = false;	
	
	if(kbUnitCount(cMyID, gTownCenter, cUnitStateAlive ) == 0 && kbUnitCount(cMyID, gEconUnit, cUnitStateAlive ) < 5 && haveAskedToResign == false)
	{
		if(kbIsFFA() == true ) 
		{
			haveAskedToResign = true;
			xsEnableRule("resignDelayTimer");
			return;
		}
		
		haveAskedToResign = true;
		aiAttemptResign(cAICommPromptToEnemyMayIResign);
	}
}


void exploreMonitor()
{
	return;
	if(gExplorerFindingHerds == true) return;
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 20000,"exploreMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
   const int   cExploreModeStart = 0;     // Initial setting, when first starting out
   const int   cExploreModeNugget = 1;    // Explore and gather nuggets.  Heavy staffing, OK to recruit more units.
   const int   cExploreModeStaff = 2;     // Restaffing the plan, active for 10 seconds to let the plan grab 1 more unit.
   const int   cExploreModeExplore = 3;   // Normal...explore until this unit dies, check again in 5 minutes.
   
   static int  exploreMode = cExploreModeStart;
   static int  age2Time = -1;
   static int  nextStaffTime = -1;        // Prevent the explore plan from constantly sucking in units.
   
   if ( (age2Time < 0) && (kbGetAge() >= cAge2) )
      age2Time = xsGetTime();

   // Check for a failed plan
   if ( (gLandExplorePlan >= 0) && (aiPlanGetState(gLandExplorePlan) < 0) )
   {
      // Somehow, the plan has died.  Reset it to start up again if allowed.
      gLandExplorePlan = -1;
      exploreMode = cExploreModeStart;
      nextStaffTime = -1;
   }
   
   // First, check the control variable and react appropriately
   
   if ( cvOkToExplore == true )
   {
      if (aiPlanGetActive(gLandExplorePlan) == false)
         if (gLandExplorePlan >= 0)
            aiPlanSetActive(gLandExplorePlan);     // Reactivate if we were shut off
      switch(exploreMode)
      {
         case cExploreModeStart:
         {
            if (aiPlanGetState(gLandExplorePlan) < 0)
            {  // Need to create it.
               gLandExplorePlan=aiPlanCreate("Land Explore", cPlanExplore);
               aiPlanSetDesiredPriority(gLandExplorePlan, 75);
               if (cvOkToGatherNuggets == true)
               {
                  aiPlanAddUnitType(gLandExplorePlan, gExplorerUnit, 1, 1, 1);
                  aiPlanAddUnitType(gLandExplorePlan, cUnitTypeLogicalTypeScout, 1, 6, 10);
                  aiPlanSetVariableBool(gLandExplorePlan, cExplorePlanOkToGatherNuggets, 0, false);
                  exploreMode = cExploreModeNugget;
               }
               else
               {
                  aiPlanAddUnitType(gLandExplorePlan, cUnitTypeLogicalTypeScout, 1, 1, 1);
                  aiPlanAddUnitType(gLandExplorePlan, gExplorerUnit, 0, 0, 0);
                  aiPlanSetVariableBool(gLandExplorePlan, cExplorePlanOkToGatherNuggets, 0, false);
                  exploreMode = cExploreModeStaff;
                  nextStaffTime = xsGetTime() + 120000;     // Two minutes from now, let it get another soldier if it loses this one.
                  if (gExplorerControlPlan < 0)
                  {
                     gExplorerControlPlan = aiPlanCreate("Explorer control plan", cPlanDefend);
                     aiPlanAddUnitType(gExplorerControlPlan, gExplorerUnit, 1, 1, 1);    // One explorer
                     aiPlanSetVariableVector(gExplorerControlPlan, cDefendPlanDefendPoint, 0, kbBaseGetMilitaryGatherPoint(cMyID, kbBaseGetMainID(cMyID)));
                     aiPlanSetVariableFloat(gExplorerControlPlan, cDefendPlanEngageRange, 0, 20.0);    // Tight
                     aiPlanSetVariableBool(gExplorerControlPlan, cDefendPlanPatrol, 0, false);
                     aiPlanSetVariableFloat(gExplorerControlPlan, cDefendPlanGatherDistance, 0, 20.0);
                     aiPlanSetInitialPosition(gExplorerControlPlan, kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID)));
                     aiPlanSetUnitStance(gExplorerControlPlan, cUnitStanceDefensive);
                     aiPlanSetVariableInt(gExplorerControlPlan, cDefendPlanRefreshFrequency, 0, 30);
                     aiPlanSetVariableInt(gExplorerControlPlan, cDefendPlanAttackTypeID, 0, cUnitTypeUnit); // Only units
                     aiPlanSetDesiredPriority(gExplorerControlPlan, 90);    // Quite high, don't suck him into routine attack plans, etc.
                     aiPlanSetActive(gExplorerControlPlan);      
                  }     
               }
               aiPlanAddUnitType(gLandExplorePlan, cUnitTypeHealerUnit, 1, 2, 3);
			   aiPlanSetEscrowID(gLandExplorePlan, cEconomyEscrowID);
               aiPlanSetBaseID(gLandExplorePlan, kbBaseGetMainID(cMyID));
               aiPlanSetVariableBool(gLandExplorePlan, cExplorePlanDoLoops, 0, true);
               aiPlanSetVariableInt(gLandExplorePlan, cExplorePlanNumberOfLoops, 0, 1);
               aiPlanSetActive(gLandExplorePlan); 
            }
            else
            {
               exploreMode = cExploreModeNugget;
            }
            break;
         }
         case cExploreModeNugget:
         {  
            // Check to see if we're out of time, and switch to single-unit exploring if we are.
            if (age2Time >= 0)
            {
               if ( ((xsGetTime() - age2Time) > 180000) && (aiPlanGetState(gLandExplorePlan) != cPlanStateClaimNugget) )  // we've been in age 2 > 3 minutes
               {  // Switch to a normal explore plan, create explorer control plan
                  if (gExplorerControlPlan < 0)
                  {
                     gExplorerControlPlan = aiPlanCreate("Explorer control plan", cPlanDefend);
                     aiPlanAddUnitType(gExplorerControlPlan, gExplorerUnit, 1, 1, 1);    // One explorer
                     aiPlanSetVariableVector(gExplorerControlPlan, cDefendPlanDefendPoint, 0, kbBaseGetMilitaryGatherPoint(cMyID, kbBaseGetMainID(cMyID)));
                     aiPlanSetVariableFloat(gExplorerControlPlan, cDefendPlanEngageRange, 0, 20.0);    // Tight
                     aiPlanSetVariableBool(gExplorerControlPlan, cDefendPlanPatrol, 0, false);
                     aiPlanSetVariableFloat(gExplorerControlPlan, cDefendPlanGatherDistance, 0, 20.0);
                     aiPlanSetInitialPosition(gExplorerControlPlan, kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID)));
                     aiPlanSetUnitStance(gExplorerControlPlan, cUnitStanceDefensive);
                     aiPlanSetVariableInt(gExplorerControlPlan, cDefendPlanRefreshFrequency, 0, 30);
                     aiPlanSetVariableInt(gExplorerControlPlan, cDefendPlanAttackTypeID, 0, cUnitTypeUnit); // Only units
                     aiPlanSetDesiredPriority(gExplorerControlPlan, 90);    // Quite high, don't suck him into routine attack plans, etc.
                     aiPlanSetActive(gExplorerControlPlan);      
                  }                     
                  
                  aiPlanAddUnitType(gLandExplorePlan, gExplorerUnit, 0, 0, 0);
                  aiPlanAddUnitType(gLandExplorePlan, cUnitTypeLogicalTypeScout, 1, 1, 1);
                  aiPlanSetNoMoreUnits(gLandExplorePlan, false);
                  aiPlanSetVariableInt(gLandExplorePlan, cExplorePlanNumberOfLoops, 0, 0);
                  aiPlanSetVariableBool(gLandExplorePlan, cExplorePlanDoLoops, 0, false);
                  exploreMode = cExploreModeStaff;
                  nextStaffTime = xsGetTime() + 120000;     // Two minutes from now, let it get another soldier.
                  aiEcho("Allowing the explore plan to grab a unit.");
               }
            }
            if (cvOkToGatherNuggets == false)
            {
               aiPlanAddUnitType(gLandExplorePlan, gExplorerUnit, 0, 0, 0);
               aiPlanAddUnitType(gLandExplorePlan, cUnitTypeLogicalTypeScout, 1, 1, 1);
               aiPlanSetNoMoreUnits(gLandExplorePlan, false);
               aiPlanSetVariableInt(gLandExplorePlan, cExplorePlanNumberOfLoops, 0, 0);
               aiPlanSetVariableBool(gLandExplorePlan, cExplorePlanDoLoops, 0, false);
               exploreMode = cExploreModeStaff;
               nextStaffTime = xsGetTime() + 120000;     // Two minutes from now, let it get another soldier.
               aiEcho("Allowing the explore plan to grab a unit.");               
            }
            break;
         }
         case cExploreModeStaff:
         {
            // We've been staffing for 10 seconds, set no more units to true
            aiPlanSetNoMoreUnits(gLandExplorePlan, true);
            exploreMode = cExploreModeExplore;
            aiEcho("Setting the explore plan to 'noMoreUnits'");
            break;
         }
         case cExploreModeExplore:
         {  // See if we're allowed to add another unit
            if (xsGetTime() > nextStaffTime)
            {
               aiPlanSetNoMoreUnits(gLandExplorePlan, false);     // Let it grab a unit
               aiEcho("Setting the explore plan to grab a unit if needed.");
               nextStaffTime = xsGetTime() + 120000;
               exploreMode = cExploreModeStaff;
            }
            break;
         }
      }
   }
   else // cvOkToExplore = false
   {
      aiPlanSetActive(gLandExplorePlan, false);
   }
}

//rule scoreMonitor
//inactive
//minInterval 60
//group tcComplete
void scoreMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 60000,"scoreMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	static int startingScores = -1; // Array holding initial scores for each player
	static int highScores = -1; // Array, each player's high-score mark
	static int teamScores = -1;
	int player = -1;
	int teamSize = 0;
	int myTeam = gPlayerTeam;
	int enemyTeam = -1;
	int highAllyScore = -1;
	int highAllyPlayer = -1;
	int highEnemyScore = -1;
	int highEnemyPlayer = -1;
	int score = -1;
	int firstHumanAlly = -1;

	if (gGameType != cGameTypeRandom)
	{
		//xsDisableSelf();
		return;
	}

	if (highScores < 0)
	{
		highScores = xsArrayCreateInt(cNumberPlayers, 1, "High Scores"); // create array, init below.
	}
	if (startingScores < 0)
	{
		if (aiGetNumberTeams() != 3) // Gaia, plus two
		{
			// Only do this if there are two teams with the same number of players on each team.
			//xsDisableSelf();
			return;
		}
		startingScores = xsArrayCreateInt(cNumberPlayers, 1, "Starting Scores"); // init array
		for (player = 1; < cNumberPlayers)
		{
			score = aiGetScore(player);
			//aiEcho("Starting score for player "+player+" is "+score);
			xsArraySetInt(startingScores, player, score);
			xsArraySetInt(highScores, player, 0); // High scores will track score actual - starting score, to handle deathmatch better.
		}
	}

	teamSize = 0;
	for (player = 1; < cNumberPlayers)
	{
		if (kbGetPlayerTeam(player) == myTeam)
		{
			teamSize = teamSize + 1;
			//if ((kbIsPlayerHuman(player) == true) && (firstHumanAlly < 1))
			if ((xsArrayGetBool(gPlayerHumanStatusArray,(player)) ) && (firstHumanAlly < 1))
			
				firstHumanAlly = player;
		}
		else
			enemyTeam = kbGetPlayerTeam(player); // Don't know if team numbers are 0..1 or 1..2, this works either way.
	}

	if ((2 * teamSize) != (cNumberPlayers - 1)) // Teams aren't equal size
	{
		//xsDisableSelf();
		return;
	}

	// If we got this far, there are two teams and each has 'teamSize' players.  Otherwise, rule turns off.
	if (teamScores < 0)
	{
		teamScores = xsArrayCreateInt(3, 0, "Team total scores");
	}

	if (firstHumanAlly < 0) // No point if we don't have a human ally.
	{
		//xsDisableSelf();
		return;
	}

	// Update team totals, check for new high scores
	xsArraySetInt(teamScores, myTeam, 0);
	xsArraySetInt(teamScores, enemyTeam, 0);
	highAllyScore = -1;
	highEnemyScore = -1;
	highAllyPlayer = -1;
	highEnemyPlayer = -1;
	int lowestRemainingScore = 100000; // Very high, will be reset by first real score 
	int lowestRemainingPlayer = -1;
	int highestScore = -1;
	int highestPlayer = -1;

	for (player = 1; < cNumberPlayers)
	{
		score = aiGetScore(player) - xsArrayGetInt(startingScores, player); // Actual score relative to initial score
		if (kbHasPlayerLost(player) == true)
			continue;
		if (score < lowestRemainingScore)
		{
			lowestRemainingScore = score;
			lowestRemainingPlayer = player;
		}
		if (score > highestScore)
		{
			highestScore = score;
			highestPlayer = player;
		}
		if (score > xsArrayGetInt(highScores, player))
			xsArraySetInt(highScores, player, score); // Set personal high score
		if (kbGetPlayerTeam(player) == myTeam) // Update team scores, check for highs
		{
			xsArraySetInt(teamScores, myTeam, xsArrayGetInt(teamScores, myTeam) + score);
			if (score > highAllyScore)
			{
				highAllyScore = score;
				highAllyPlayer = player;
			}
		}
		else
		{
			xsArraySetInt(teamScores, enemyTeam, xsArrayGetInt(teamScores, enemyTeam) + score);
			if (score > highEnemyScore)
			{
				highEnemyScore = score;
				highEnemyPlayer = player;
			}
		}
	}

	// Bools used to indicate chat usage, prevent re-use.
	static bool enemyNearlyDead = false;
	static bool enemyStrong = false;
	static bool losingEnemyStrong = false;
	static bool losingEnemyWeak = false;
	static bool losingAllyStrong = false;
	static bool losingAllyWeak = false;
	static bool winningNormal = false;
	static bool winningAllyStrong = false;
	static bool winningAllyWeak = false;

	static int shouldResignCount = 0; // Set to 1, 2 and 3 as chats are used.
	static int shouldResignLastTime = 420000; // When did I last suggest resigning?  Consider it again 3 min later.          
	// Defaults to 7 min, so first suggestion won't be until 10 minutes.

	// Attempt to fire chats, from most specific to most general.
	// When we chat, mark that one used and exit for now, i.e no more than one chat per rule execution.

	// First, check the winning / losing / tie situations.  
	// Bail if earlier than 12 minutes
	if (gCurrentGameTime < 60 * 1000 * 12)
		return;

	if (aiTreatyActive() == true)
		return;

	bool winning = false;
	bool losing = false;
	gLosingDigin = false;
	float ourAverageScore = (aiGetScore(cMyID) + aiGetScore(firstHumanAlly)) / 2.0;

	if (xsArrayGetInt(teamScores, myTeam) > (1.20 * xsArrayGetInt(teamScores, enemyTeam)))
	{ // We are winning
		winning = true;

		// Are we winning because my ally rocks?
		if ((winningAllyStrong == false) && (firstHumanAlly == highestPlayer))
		{
			winningAllyStrong = true;
			sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreWinningHeIsStronger);
			return;
		}

		// Are we winning in spite of my weak ally?
		if ((winningAllyWeak == false) && (cMyID == highestPlayer))
		{
			winningAllyWeak = true;
			sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreWinningHeIsWeaker);
			return;
		}

		// OK, we're winning, but neither of us has high score.
		if (winningNormal == false)
		{
			winningNormal = true;
			sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreWinning);
			return;
		}
	} // End chats while we're winning.


	if (xsArrayGetInt(teamScores, myTeam) < (0.30 * xsArrayGetInt(teamScores, enemyTeam)))
	{ // We are losing
		losing = true;
		gLosingDigin = true;

		// Talk about resigning?
		if ((shouldResignCount < 3) && ((gCurrentGameTime - shouldResignLastTime) > 3 * 60 * 1000)) // Haven't done it 3 times or within 3 minutes
		{
			switch (shouldResignCount)
			{
				case 0:
					{
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeShouldResign1);
						break;
					}
				case 1:
					{
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeShouldResign2);
						break;
					}
				case 2:
					{
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeShouldResign3);
						break;
					}
			}
			shouldResignCount = shouldResignCount + 1;
			shouldResignLastTime = gCurrentGameTime;
			return;
		} // End resign

		// Check for "we are losing but let's kill the weakling"
		if ((losingEnemyWeak == false) && (kbIsPlayerEnemy(lowestRemainingPlayer) == true))
		{
			switch (kbGetCivForPlayer(lowestRemainingPlayer))
			{
				case cCivRussians:
					{
						losingEnemyWeak = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyWeakRussian);
						return;
						break;
					}
				case cCivFrench:
					{
						losingEnemyWeak = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyWeakFrench);
						return;
						break;
					}
				case cCivGermans:
					{
						losingEnemyWeak = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyWeakGerman);
						return;
						break;
					}
				case cCivBritish:
					{
						losingEnemyWeak = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyWeakBritish);
						return;
						break;
					}
				case cCivSpanish:
					{
						losingEnemyWeak = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyWeakSpanish);
						return;
						break;
					}
				case cCivDutch:
					{
						losingEnemyWeak = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyWeakDutch);
						return;
						break;
					}
				case cCivPortuguese:
					{
						losingEnemyWeak = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyWeakPortuguese);
						return;
						break;
					}
				case cCivOttomans:
					{
						losingEnemyWeak = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyWeakOttoman);
						return;
						break;
					}
				case cCivJapanese:
					{
						if (getCivIsAsian() == true)
						{
							losingEnemyWeak = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyWeakJapanese);
							return;
							break;
						}
					}
				case cCivChinese:
					{
						if (getCivIsAsian() == true)
						{
							losingEnemyWeak = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyWeakChinese);
							return;
							break;
						}
					}
				case cCivIndians:
					{
						if (getCivIsAsian() == true)
						{
							losingEnemyWeak = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyWeakIndian);
							return;
							break;
						}
					}

			}
		}

		// Check for losing while enemy player has high score.
		if ((losingEnemyStrong == false) && (kbIsPlayerEnemy(highestPlayer) == true))
		{
			switch (kbGetCivForPlayer(highestPlayer))
			{
				case cCivRussians:
					{
						losingEnemyStrong = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyStrongRussian);
						return;
						break;
					}
				case cCivFrench:
					{
						losingEnemyStrong = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyStrongFrench);
						return;
						break;
					}
				case cCivGermans:
					{
						losingEnemyStrong = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyStrongGerman);
						return;
						break;
					}
				case cCivBritish:
					{
						losingEnemyStrong = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyStrongBritish);
						return;
						break;
					}
				case cCivSpanish:
					{
						losingEnemyStrong = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyStrongSpanish);
						return;
						break;
					}
				case cCivDutch:
					{
						losingEnemyStrong = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyStrongDutch);
						return;
						break;
					}
				case cCivPortuguese:
					{
						losingEnemyStrong = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyStrongPortuguese);
						return;
						break;
					}
				case cCivOttomans:
					{
						losingEnemyStrong = true; // chat used.
						sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyStrongOttoman);
						return;
						break;
					}
				case cCivJapanese:
					{
						if (getCivIsAsian() == true)
						{
							losingEnemyStrong = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyStrongJapanese);
							return;
							break;
						}
					}
				case cCivChinese:
					{
						if (getCivIsAsian() == true)
						{
							losingEnemyStrong = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyStrongChinese);
							return;
							break;
						}
					}
				case cCivIndians:
					{
						if (getCivIsAsian() == true)
						{
							losingEnemyStrong = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingEnemyStrongIndian);
							return;
							break;
						}
					}
			}
		}

		// If we're here, we're losing but our team has the high score.  If it's my ally, we're losing because I suck.
		if ((losingAllyStrong == false) && (firstHumanAlly == highestPlayer))
		{
			losingAllyStrong = true;
			sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingHeIsStronger);
			return;
		}
		if ((losingAllyWeak == false) && (cMyID == highestPlayer))
		{
			losingAllyWeak = true;
			sendStatement(firstHumanAlly, cAICommPromptToAllyWeAreLosingHeIsWeaker);
			return;
		}
	} // End chats while we're losing.

	if ((winning == false) && (losing == false))
	{ // Close game

		// Check for a near-death enemy
		if ((enemyNearlyDead == false) && (kbIsPlayerEnemy(lowestRemainingPlayer) == true)) // Haven't used this chat yet
		{
			if ((lowestRemainingScore * 2) < xsArrayGetInt(highScores, lowestRemainingPlayer)) // He's down to half his high score.
			{
				switch (kbGetCivForPlayer(lowestRemainingPlayer))
				{
					case cCivRussians:
						{
							enemyNearlyDead = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyNearlyDeadRussian);
							return;
							break;
						}
					case cCivFrench:
						{
							enemyNearlyDead = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyNearlyDeadFrench);
							return;
							break;
						}
					case cCivBritish:
						{
							enemyNearlyDead = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyNearlyDeadBritish);
							return;
							break;
						}
					case cCivSpanish:
						{
							enemyNearlyDead = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyNearlyDeadSpanish);
							return;
							break;
						}
					case cCivGermans:
						{
							enemyNearlyDead = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyNearlyDeadGerman);
							return;
							break;
						}
					case cCivOttomans:
						{
							enemyNearlyDead = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyNearlyDeadOttoman);
							return;
							break;
						}
					case cCivDutch:
						{
							enemyNearlyDead = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyNearlyDeadDutch);
							return;
							break;
						}
					case cCivPortuguese:
						{
							enemyNearlyDead = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyNearlyDeadPortuguese);
							return;
							break;
						}
					case cCivJapanese:
						{
							if (getCivIsAsian() == true)
							{
								enemyNearlyDead = true; // chat used.
								sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyNearlyDeadJapanese);
								return;
								break;
							}
						}
					case cCivChinese:
						{
							if (getCivIsAsian() == true)
							{
								enemyNearlyDead = true; // chat used.
								sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyNearlyDeadChinese);
								return;
								break;
							}
						}
					case cCivIndians:
						{
							if (getCivIsAsian() == true)
							{
								enemyNearlyDead = true; // chat used.
								sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyNearlyDeadIndian);
								return;
								break;
							}
						}
				}
			}
		}

		// Check for very strong enemy
		if ((enemyStrong == false) && (kbIsPlayerEnemy(highestPlayer) == true))
		{
			if ((ourAverageScore * 1.5) < highestScore)
			{ // Enemy has high score, it's at least 50% above our average.
				switch (kbGetCivForPlayer(highestPlayer))
				{
					case cCivRussians:
						{
							enemyStrong = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyStrongRussian);
							return;
							break;
						}
					case cCivFrench:
						{
							enemyStrong = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyStrongFrench);
							return;
							break;
						}
					case cCivBritish:
						{
							enemyNearlyDead = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyStrongBritish);
							return;
							break;
						}
					case cCivSpanish:
						{
							enemyNearlyDead = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyStrongSpanish);
							return;
							break;
						}
					case cCivGermans:
						{
							enemyNearlyDead = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyStrongGerman);
							return;
							break;
						}
					case cCivOttomans:
						{
							enemyNearlyDead = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyStrongOttoman);
							return;
							break;
						}
					case cCivDutch:
						{
							enemyNearlyDead = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyStrongDutch);
							return;
							break;
						}
					case cCivPortuguese:
						{
							enemyNearlyDead = true; // chat used.
							sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyStrongPortuguese);
							return;
							break;
						}
					case cCivJapanese:
						{
							if (getCivIsAsian() == true)
							{
								enemyNearlyDead = true; // chat used.
								sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyStrongJapanese);
								return;
								break;
							}
						}
					case cCivChinese:
						{
							if (getCivIsAsian() == true)
							{
								enemyNearlyDead = true; // chat used.
								sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyStrongChinese);
								return;
								break;
							}
						}
					case cCivIndians:
						{
							if (getCivIsAsian() == true)
							{
								enemyNearlyDead = true; // chat used.
								sendStatement(firstHumanAlly, cAICommPromptToAllyEnemyStrongIndian);
								return;
								break;
							}
						}
				}
			}
		}
	} // End chats for close game 
}
//==============================================================================
// scoutMonitor
// updatedOn 2020/03/06
//==============================================================================
//rule scoutMonitor
//active
//minInterval 10
void scoutMonitor()
{ //make scouts for scouting
	//return;

	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 1000,"scoutMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	static int findHerdQuery = -1;
	if (findHerdQuery == -1) findHerdQuery = kbUnitQueryCreate("findHerdQuery"+getQueryId());
	kbUnitQueryResetResults(findHerdQuery);
	kbUnitQuerySetPlayerID(findHerdQuery, 0, false);
	kbUnitQuerySetIgnoreKnockedOutUnits(findHerdQuery, true);
	kbUnitQuerySetUnitType(findHerdQuery, cUnitTypeHerdable);
	kbUnitQuerySetState(findHerdQuery, cUnitStateAlive);
	kbUnitQuerySetPosition(findHerdQuery, gMainBaseLocation);
	kbUnitQuerySetAscendingSort(findHerdQuery, true);
	int herdNum = kbUnitQueryExecute(findHerdQuery);

	int scoutUnit = -1; //scout unit
	int scoutAvailable = -1; //scout available	
	scoutAvailable = kbProtoUnitAvailable(cUnitTypeEnvoy); //check Envoy unit
	gExplorerFindingHerds = false;
		
	if (scoutAvailable == 1) scoutUnit = cUnitTypeEnvoy; //set scout
	
	if (scoutAvailable == 0)
	{
		scoutAvailable = kbProtoUnitAvailable(cUnitTypeNativeScout); //check Native unit
		if (scoutAvailable == 1) scoutUnit = cUnitTypeNativeScout;
	}
	if (scoutAvailable == 0)
	{
		scoutAvailable = kbProtoUnitAvailable(cUnitTypeypMongolScout); //check Mongol unit
		if (scoutAvailable == 1) scoutUnit = cUnitTypeypMongolScout;
	}
	
	
	if (kbUnitCount(cMyID, scoutUnit, cUnitStateAlive) == 0 && herdNum > 0)
	{
		gExplorerFindingHerds = true;
		scoutUnit = cUnitTypeHero;
	}

	int scoutCount = 1; //kbGetBuildLimit(cMyID, scoutUnit); //get max build limit
	switch (gCurrentAge)
	{ //set limit per age
		case cAge1:
			{
				scoutCount = 1;
				break;
			}
		case cAge2:
			{
				scoutCount = 1;
				break;
			}
		case cAge3:
			{
				scoutCount = 1;
				break;
			}
		case cAge4:
			{
				scoutCount = 1;
				break;
			}
		case cAge5:
			{
				scoutCount = 1;
				break;
			}
	} //end switch
	if (kbUnitCount(cMyID, scoutUnit, cUnitStateABQ) < scoutCount && kbUnitCount(cMyID, gEconUnit, cUnitStateABQ) > 5) aiTaskUnitTrain(getUnit(gTownCenter), scoutUnit); //train when under limit
	
	static int scoutExplore = -1;
	
	if(herdNum > 0 && scoutExplore == -1) 
	{
		if(gCurrentGameTime < 180000) kbLookAtAllUnitsOnMap();
		
		static int getHeros = -1;
		if (getHeros == -1) getHeros = kbUnitQueryCreate("getHeros"+getQueryId());
		kbUnitQueryResetResults(getHeros);
		kbUnitQuerySetPlayerID(getHeros, cMyID, false);
		kbUnitQuerySetIgnoreKnockedOutUnits(getHeros, true);
		kbUnitQuerySetUnitType(getHeros, cUnitTypeHero);
		kbUnitQuerySetState(getHeros, cUnitStateAlive);
		
		int gotoHerd = 0;

		for(i = 0; < kbUnitQueryExecute(getHeros))
		{
			if(i > 0) gotoHerd = herdNum -i;
			
			if(kbCanPath2(kbUnitGetPosition(kbUnitQueryGetResult(getHeros, i)), 
			kbUnitGetPosition(kbUnitQueryGetResult(findHerdQuery, gotoHerd)),
			kbUnitGetProtoUnitID(kbUnitQueryGetResult(getHeros, i)),1000.0) == false) continue; //check path	
			aiTaskUnitMove(kbUnitQueryGetResult(getHeros, i), kbUnitGetPosition(kbUnitQueryGetResult(findHerdQuery, gotoHerd)));
		}
		return;
	}

	if(aiPlanGetActive(scoutExplore) == false)
	{
		aiPlanDestroy(scoutExplore);
		scoutExplore = -1;
	}
	if (scoutExplore == -1 && scoutUnit != cUnitTypeHero)
	{ // Create explore plan for each scout
		//for (i = 0; < kbGetBuildLimit(cMyID, scoutUnit))
		//{ //for each envo
			scoutExplore = aiPlanCreate("Envoy Explore", cPlanExplore);
			aiPlanSetDesiredPriority(scoutExplore, 100);
			aiPlanAddUnitType(scoutExplore, scoutUnit, 1, 1, 1);
			aiPlanSetEscrowID(scoutExplore, cEconomyEscrowID);
			aiPlanSetBaseID(scoutExplore, kbBaseGetMainID(cMyID));
			aiPlanSetVariableBool(scoutExplore, cExplorePlanDoLoops, 0, false);
			aiPlanSetActive(scoutExplore);
		//} //end for
	} //end if     
	
} //end envoyMonitor



//rule healerMonitor
//inactive
//minInterval 30
void healerMonitor()
{
	static int healerPlan = -1;

	int priestCount = kbUnitCount(cMyID, cUnitTypePriest, cUnitStateAlive);
	int missionaryCount = kbUnitCount(cMyID, cUnitTypeMissionary, cUnitStateAlive);
	int surgeonCount = kbUnitCount(cMyID, cUnitTypeSurgeon, cUnitStateAlive);
	int imamCount = kbUnitCount(cMyID, cUnitTypeImam, cUnitStateAlive);
	int natMedicineManCount = kbUnitCount(cMyID, cUnitTypeNatMedicineMan, cUnitStateAlive);
	int xpMedicineManCount = kbUnitCount(cMyID, cUnitTypexpMedicineMan, cUnitStateAlive);
	int xpMedicineManAztecCount = kbUnitCount(cMyID, cUnitTypexpMedicineManAztec, cUnitStateAlive);

	static int pHealerQry = -1;
	static int pHealerNum = -1;
	static int pUnitId = -1;
	if(getCivIsNative() && kbUnitCount(cMyID, cUnitTypeFirePit, cUnitStateABQ) != 0)
	{
		if (pHealerQry == -1) 
		{
			pHealerQry = kbUnitQueryCreate("gSelfLandMilitaryQry"+getQueryId());
			kbUnitQuerySetPlayerID(pHealerQry,cMyID,false);
			kbUnitQuerySetPlayerRelation(pHealerQry, -1);
			kbUnitQuerySetUnitType(pHealerQry, cUnitTypeHealerUnit);
			kbUnitQuerySetIgnoreKnockedOutUnits(pHealerQry, true);
			kbUnitQuerySetState(pHealerQry, cUnitStateAlive);
		}	
		kbUnitQueryResetResults(pHealerQry);
		pHealerNum = kbUnitQueryExecute(pHealerQry);
		for(i = 0; < pHealerNum)
		{
			pUnitId = kbUnitQueryGetResult(pHealerQry, i);
			if(kbUnitGetActionType(pUnitId) == 7)
			{
				aiTaskUnitWork(pUnitId, getUnit(cUnitTypeFirePit, cMyID, cUnitStateAlive));
			}
		}
		
	}
	
	if (healerPlan < 0)
	{
		healerPlan = aiPlanCreate("Healer Control Plan", cPlanDefend);

		aiPlanAddUnitType(healerPlan, cUnitTypePriest, priestCount, priestCount, priestCount);
		aiPlanAddUnitType(healerPlan, cUnitTypeMissionary, missionaryCount, missionaryCount, missionaryCount);
		aiPlanAddUnitType(healerPlan, cUnitTypeSurgeon, surgeonCount, surgeonCount, surgeonCount);
		aiPlanAddUnitType(healerPlan, cUnitTypeImam, imamCount, imamCount, imamCount);
		aiPlanAddUnitType(healerPlan, cUnitTypeNatMedicineMan, natMedicineManCount, natMedicineManCount, natMedicineManCount);
		aiPlanAddUnitType(healerPlan, cUnitTypexpMedicineMan, xpMedicineManCount, xpMedicineManCount, xpMedicineManCount);
		if (kbUnitCount(cMyID, cUnitTypeFirePit, cUnitStateABQ) < 1) // Add warrior priest only if there is no fire pit to dance at
		{
			aiPlanAddUnitType(healerPlan, cUnitTypexpMedicineManAztec, xpMedicineManAztecCount, xpMedicineManAztecCount, xpMedicineManAztecCount);
		}
		else
		{
			aiPlanAddUnitType(healerPlan, cUnitTypexpMedicineManAztec, 0, 0, 0);
		}

		aiPlanSetVariableVector(healerPlan, cDefendPlanDefendPoint, 0, kbBaseGetMilitaryGatherPoint(cMyID, kbBaseGetMainID(cMyID)));
		aiPlanSetVariableFloat(healerPlan, cDefendPlanEngageRange, 0, cvDefenseReflexRadiusActive);
		aiPlanSetVariableBool(healerPlan, cDefendPlanPatrol, 0, false);
		aiPlanSetVariableFloat(healerPlan, cDefendPlanGatherDistance, 0, 10.0);
		aiPlanSetInitialPosition(healerPlan, gMainBaseLocation);
		aiPlanSetUnitStance(healerPlan, cUnitStanceDefensive);
		aiPlanSetVariableInt(healerPlan, cDefendPlanRefreshFrequency, 0, 5);
		aiPlanSetVariableInt(healerPlan, cDefendPlanAttackTypeID, 0, cUnitTypeUnit);
		aiPlanSetDesiredPriority(healerPlan, 95); // High priority to keep units from being sucked into other plans
		aiPlanSetActive(healerPlan);
		//aiEcho("Creating healer plan");
	}
	else
	{
		aiPlanAddUnitType(healerPlan, cUnitTypePriest, priestCount, priestCount, priestCount);
		aiPlanAddUnitType(healerPlan, cUnitTypeMissionary, missionaryCount, missionaryCount, missionaryCount);
		aiPlanAddUnitType(healerPlan, cUnitTypeSurgeon, surgeonCount, surgeonCount, surgeonCount);
		aiPlanAddUnitType(healerPlan, cUnitTypeImam, imamCount, imamCount, imamCount);
		aiPlanAddUnitType(healerPlan, cUnitTypeNatMedicineMan, natMedicineManCount, natMedicineManCount, natMedicineManCount);
		aiPlanAddUnitType(healerPlan, cUnitTypexpMedicineMan, xpMedicineManCount, xpMedicineManCount, xpMedicineManCount);
		if (kbUnitCount(cMyID, cUnitTypeFirePit, cUnitStateABQ) < 1) // Add warrior priest only if there is no fire pit to dance at
		{
			aiPlanAddUnitType(healerPlan, cUnitTypexpMedicineManAztec, xpMedicineManAztecCount, xpMedicineManAztecCount, xpMedicineManAztecCount);
		}
		else
		{
			aiPlanAddUnitType(healerPlan, cUnitTypexpMedicineManAztec, 0, 0, 0);
		}
		//aiEcho("Updating healer plan");
	}
}

//rule warriorSocietyUpgradeMonitor
//inactive
//minInterval 90
void warriorSocietyUpgradeMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 60000,"warriorSocietyUpgradeMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	int upgradePlanID = -1;

	// Get warrior society upgrades one at the time, provided a sufficient number of units to be improved are available
	// Research plans are "blindly" tried at different trading posts as there is no way to identify specific trading posts in the AI script

	if ((kbTechGetStatus(cTechWarriorSocietyAztecs) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatJaguarWarrior, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatEagleWarrior, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyAztecs);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyAztecs, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietyCaribs) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatBlowgunWarrior, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatBlowgunAmbusher, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercBlowgunWarrior, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyCaribs);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyCaribs, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietyCherokee) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatRifleman, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercRifleman, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyCherokee);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyCherokee, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietyComanche) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatHorseArcher, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercHorseArcher, cUnitStateAlive) >= 6))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyComanche);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyComanche, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietyCree) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatTracker, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercTracker, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyCree);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyCree, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietyInca) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatBolasWarrior, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatHuaminca, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyInca);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyInca, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietyIroquois) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatTomahawk, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMantlet, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyIroquois);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyIroquois, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
	}
	if ((kbTechGetStatus(cTechWarriorSocietyLakota) == cTechStatusObtainable) && (kbUnitCount(cMyID, cUnitTypeNatAxeRider, cUnitStateAlive) >= 6))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyLakota);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyLakota, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietyMaya) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatHolcanSpearman, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercHolcanSpearman, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyMaya);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyMaya, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietyNootka) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatClubman, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercClubman, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyNootka);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyNootka, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietySeminoles) == cTechStatusObtainable) && (kbUnitCount(cMyID, cUnitTypeNatSharktoothBowman, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietySeminoles);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietySeminoles, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietyTupi) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatBlackwoodArcher, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercBlackwoodArcher, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyTupi);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyTupi, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietyHuron) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatHuronMantlet, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercHuronMantlet, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyHuron);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyHuron, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietyZapotec) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatLightningWarrior, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercLightningWarrior, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyZapotec);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyZapotec, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietyKlamath) == cTechStatusObtainable) && (kbUnitCount(cMyID, cUnitTypeNatKlamathRifleman, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyKlamath);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyKlamath, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
	}
	if ((kbTechGetStatus(cTechWarriorSocietyApache) == cTechStatusObtainable) && (kbUnitCount(cMyID, cUnitTypeNatApacheCavalry, cUnitStateAlive) >= 6))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyApache);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyApache, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietyNavajo) == cTechStatusObtainable) && (kbUnitCount(cMyID, cUnitTypeNatNavajoRifleman, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyNavajo);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyNavajo, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietyCheyenne) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatCheyenneRider, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercCheyenneRider, cUnitStateAlive) >= 6))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyCheyenne);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyCheyenne, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechWarriorSocietyMapuche) == cTechStatusObtainable) && (kbUnitCount(cMyID, cUnitTypeNatMapucheClubman, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechWarriorSocietyMapuche);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechWarriorSocietyMapuche, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
}

//rule minorNativeChampionUpgradeMonitor
//inactive
//minInterval 90
void minorNativeChampionUpgradeMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 60000,"minorNativeChampionUpgradeMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	 
	
	int upgradePlanID = -1;

	// Get minor native champion upgrades one at the time, provided a sufficient number of units to be improved are available
	// Research plans are "blindly" tried at different trading posts as there is no way to identify specific trading posts in the AI script

	if ((kbTechGetStatus(cTechChampionAztecs) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatJaguarWarrior, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatEagleWarrior, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionAztecs);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionAztecs, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionCaribs) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatBlowgunWarrior, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatBlowgunAmbusher, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercBlowgunWarrior, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionCaribs);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionCaribs, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionCherokee) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatRifleman, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercRifleman, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionCherokee);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionCherokee, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionComanche) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatHorseArcher, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercHorseArcher, cUnitStateAlive) >= 6))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionComanche);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionComanche, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionCree) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatTracker, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercTracker, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionCree);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionCree, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionInca) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatBolasWarrior, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatHuaminca, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionInca);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionInca, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionIroquois) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatTomahawk, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMantlet, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionIroquois);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionIroquois, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionLakota) == cTechStatusObtainable) && (kbUnitCount(cMyID, cUnitTypeNatAxeRider, cUnitStateAlive) >= 6))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionLakota);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionLakota, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionMaya) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatHolcanSpearman, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercHolcanSpearman, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionMaya);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionMaya, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionNootka) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatClubman, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercClubman, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionNootka);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionNootka, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionSeminoles) == cTechStatusObtainable) && (kbUnitCount(cMyID, cUnitTypeNatSharktoothBowman, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionSeminoles);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionSeminoles, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionTupi) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatBlackwoodArcher, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercBlackwoodArcher, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionTupi);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionTupi, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionHuron) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatHuronMantlet, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercHuronMantlet, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionHuron);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionHuron, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionZapotec) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatLightningWarrior, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercLightningWarrior, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionZapotec);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionZapotec, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionKlamath) == cTechStatusObtainable) && (kbUnitCount(cMyID, cUnitTypeNatKlamathRifleman, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionKlamath);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionKlamath, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionApache) == cTechStatusObtainable) && (kbUnitCount(cMyID, cUnitTypeNatApacheCavalry, cUnitStateAlive) >= 6))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionApache);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionApache, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionNavajo) == cTechStatusObtainable) && (kbUnitCount(cMyID, cUnitTypeNatNavajoRifleman, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionNavajo);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionNavajo, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionCheyenne) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatCheyenneRider, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercCheyenneRider, cUnitStateAlive) >= 6))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionCheyenne);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionCheyenne, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechChampionMapuche) == cTechStatusObtainable) && (kbUnitCount(cMyID, cUnitTypeNatMapucheClubman, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChampionMapuche);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechChampionMapuche, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
}

//rule minorAsianDisciplinedUpgradeMonitor
//inactive
//minInterval 90
void minorAsianDisciplinedUpgradeMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 60000,"minorAsianDisciplinedUpgradeMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	 
	
	int upgradePlanID = -1;

	// Get disciplined upgrades for minor Asian civilizations one at the time, provided a sufficient number of units to be improved are available
	// Research plans are "blindly" tried at different trading posts as there is no way to identify specific trading posts in the AI script

	if ((kbTechGetStatus(cTechypNatDisciplinedBhakti) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeypNatTigerClaw, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeypNatMercTigerClaw, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypNatDisciplinedBhakti);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypNatDisciplinedBhakti, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechypNatDisciplinedJesuit) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeypNatConquistador, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeypNatMercConquistador, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypNatDisciplinedJesuit);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypNatDisciplinedJesuit, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechypNatDisciplinedShaolin) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeypNatRattanShield, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeypNatMercRattanShield, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypNatDisciplinedShaolin);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypNatDisciplinedShaolin, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechypNatDisciplinedSufi) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeypNatWarElephant, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeypNatMercWarElephant, cUnitStateAlive) >= 4))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypNatDisciplinedSufi);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypNatDisciplinedSufi, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechypNatDisciplinedUdasi) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeypNatChakram, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeypNatMercChakram, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypNatDisciplinedUdasi);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypNatDisciplinedUdasi, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechypNatDisciplinedZen) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeypNatSohei, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeypNatMercSohei, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypNatDisciplinedZen);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypNatDisciplinedZen, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
}

//rule minorAsianHonoredUpgradeMonitor
//inactive
//minInterval 90
void minorAsianHonoredUpgradeMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 60000,"minorAsianHonoredUpgradeMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	 
	
	int upgradePlanID = -1;

	// Get honored upgrades for minor Asian civilizations one at the time, provided a sufficient number of units to be improved are available
	// Research plans are "blindly" tried at different trading posts as there is no way to identify specific trading posts in the AI script

	if ((kbTechGetStatus(cTechypNatHonoredBhakti) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeypNatTigerClaw, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeypNatMercTigerClaw, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypNatHonoredBhakti);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypNatHonoredBhakti, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechypNatHonoredJesuit) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeypNatConquistador, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeypNatMercConquistador, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypNatHonoredJesuit);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypNatHonoredJesuit, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechypNatHonoredShaolin) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeypNatRattanShield, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeypNatMercRattanShield, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypNatHonoredShaolin);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypNatHonoredShaolin, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechypNatHonoredSufi) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeypNatWarElephant, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeypNatMercWarElephant, cUnitStateAlive) >= 4))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypNatHonoredSufi);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypNatHonoredSufi, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechypNatHonoredUdasi) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeypNatChakram, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeypNatMercChakram, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypNatHonoredUdasi);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypNatHonoredUdasi, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechypNatHonoredZen) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeypNatSohei, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeypNatMercSohei, cUnitStateAlive) >= 10))
	{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypNatHonoredZen);
		if (upgradePlanID >= 0)
			aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypNatHonoredZen, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
}

//rule sacredFieldMonitor
//inactive
//minInterval 60
void sacredFieldMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 60000,"sacredFieldMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	static int cowPlan = -1;
	int numHerdables = 0;
	int numCows = 0;

	// Build a sacred field if there is none
	if (kbUnitCount(cMyID, cUnitTypeypSacredField, cUnitStateAlive) < 1)
	{
		buildingBluePrint(cUnitTypeypSacredField,-1);
		//createSimpleBuildPlan(cUnitTypeypSacredField, 1, 50, true, cEconomyEscrowID, kbBaseGetMainID(cMyID), 1);
		return;
	}

	// Check number of captured herdables, add sacred cows as necessary to bring total number to 10
	numHerdables = kbUnitCount(cMyID, cUnitTypeHerdable, cUnitStateAlive) - kbUnitCount(cMyID, cUnitTypeypSacredCow, cUnitStateAlive);
	if (numHerdables < 0)
		numHerdables = 0;
	numCows = 10 - numHerdables;
	if (numCows > 0)
	{
		// Create/update maintain plan
		if (cowPlan < 0)
		{
			cowPlan = createSimpleMaintainPlan(cUnitTypeypSacredCow, numCows, true, kbBaseGetMainID(cMyID), 1,cowPlan);
		}
		else
		{
			aiPlanSetVariableInt(cowPlan, cTrainPlanNumberToMaintain, 0, numCows);
		}
	}

	int upgradePlanID = -1;
	/*
		// Get XP upgrade
		if (kbTechGetStatus(cTechypLivestockHoliness) == cTechStatusObtainable)
		{
		upgradePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypLivestockHoliness);
		if (upgradePlanID >= 0)
		aiPlanDestroy(upgradePlanID);
		createSimpleResearchPlan(cTechypLivestockHoliness, getUnit(cUnitTypeypSacredField), cMilitaryEscrowID, 50);
		return;
		}
	*/
}


bool wagonCheck(int pUnit = -1, int pWagonId = -1)
{
	debugRule("wagonCheck" ,0);
	if(pWagonId == -1 || pUnit == -1) debugRule("wagonCheck - Warning invalid unit " + pUnit + " pWagonId " + pWagonId,1);
	if(kbProtoUnitAvailable(pUnit))
	{
		debugRule("wagonCheck - unit is Available " + pUnit  ,1);
		if (kbUnitCount(cMyID, pUnit, cUnitStateABQ) < kbGetBuildLimit(cMyID,pUnit ) ||  kbGetBuildLimit(cMyID,pUnit) == -1) 
		{
			debugRule("wagonCheck -  Sending wagon to build, unit " + pUnit + " pWagonId " + pWagonId ,2);
			if(pUnit == cUnitTypeDock) createdock(pWagonId);
			else if(pUnit == gTradingPostUnit ) debugRule("wagonCheck -  tradepost wagon ",2);
			else buildingBluePrint(pUnit, pWagonId);
			return(true);
		}
	}
	return (false);
}

void wagonMonitor()
{
	debugRule("wagonMonitor",-1);
	static int pWagonQry = -1;
	static int pWagonCount = -1;
	static int pWagonId = -1;
	if (kbUnitCount(cMyID, cUnitTypeAbstractWagon, cUnitStateAlive) > 0)
	{
		debugRule("wagonMonitor - Found Wagon ",1);
		if (pWagonQry == -1)
		{			
			debugRule("wagonMonitor - Creating query ",2);
			pWagonQry = kbUnitQueryCreate("pWagonQry"+getQueryId());
			kbUnitQuerySetPlayerID(pWagonQry,cMyID,false);
			kbUnitQuerySetPlayerRelation(pWagonQry, -1);
			kbUnitQuerySetUnitType(pWagonQry, cUnitTypeAbstractWagon);
			kbUnitQuerySetIgnoreKnockedOutUnits(pWagonQry, true);
			kbUnitQuerySetState(pWagonQry, cUnitStateAlive);
		}
		kbUnitQueryResetResults(pWagonQry);
		pWagonCount = kbUnitQueryExecute(pWagonQry);
		for(i = 0; < pWagonCount)
		{
			pWagonId = kbUnitQueryGetResult(pWagonQry, i);
			if(pWagonId == -1)return;
			if (kbUnitGetActionType(pWagonId) != 7) continue;
			switch( kbUnitGetProtoUnitID(pWagonId) )
			{
				case cUnitTypeBankWagon:
				{
					if(wagonCheck(cUnitTypeBank,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeypBankAsian,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeCoveredWagon:
				{
					if(wagonCheck(cUnitTypeTownCenter,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeOutpostWagon:
				{
					if(wagonCheck(cUnitTypeOutpost,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeYPOutpostAsian,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeGuardTower,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeLookout,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeBlockhouse,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}					
				case cUnitTypeFortWagon:
				{
					if(wagonCheck(cUnitTypeFortFrontier,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}	
				case cUnitTypeFactoryWagon:
				{
					if(wagonCheck(cUnitTypeFactory,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeWarHutTravois:
				{
					if(wagonCheck(cUnitTypeWarHut,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeFarmTravois:
				{
					if(wagonCheck(cUnitTypeFarm,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeMill,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeNoblesHutTravois:
				{
					if(wagonCheck(cUnitTypeNoblesHut,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypexpBuilder:
				{
					if(wagonCheck(cUnitTypeSPCCherokeeWarHut,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeSPCAztecTemple,pWagonId)) continue;
					else if(gWaterMap && wagonCheck(cUnitTypeDock,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeLivestockPen,pWagonId)) continue;

					else if(wagonCheck(cUnitTypeFirePit,pWagonId)) continue;
					else if(kbUnitCount(cMyID, cUnitTypeFarm, cUnitStateABQ) < 6 && wagonCheck(cUnitTypeFarm,pWagonId) ) continue;
					else if(kbUnitCount(cMyID, cUnitTypePlantation, cUnitStateABQ) < 6 && wagonCheck(cUnitTypePlantation,pWagonId)) continue;
					else if(kbUnitCount(cMyID, cUnitTypeMarket, cUnitStateABQ) == 0 && wagonCheck(cUnitTypeMarket,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeFarm,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeLonghouse,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeHouseAztec,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeTeepee,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}	
				case cUnitTypexpBuilderWar:
				{
					if(wagonCheck(cUnitTypeWarHut,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeSPCAztecTemple,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeSPCCherokeeWarHut,pWagonId)) continue;
					else if(gWaterMap && wagonCheck(cUnitTypeDock,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeLivestockPen,pWagonId)) continue;
					else if(kbUnitCount(cMyID, cUnitTypeFarm, cUnitStateABQ) > 0 && wagonCheck(cUnitTypeLonghouse,pWagonId)) continue;
					else if(kbUnitCount(cMyID, cUnitTypeFarm, cUnitStateABQ) > 0 && wagonCheck(cUnitTypeHouseAztec,pWagonId)) continue;
					else if(kbUnitCount(cMyID, cUnitTypeFarm, cUnitStateABQ) > 0 && wagonCheck(cUnitTypeTeepee,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeFirePit,pWagonId)) continue;
					else if(kbUnitCount(cMyID, cUnitTypeFarm, cUnitStateABQ) < 6 && wagonCheck(cUnitTypeFarm,pWagonId) ) continue;
					else if(kbUnitCount(cMyID, cUnitTypePlantation, cUnitStateABQ) < 6 && wagonCheck(cUnitTypePlantation,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeNativeEmbassy,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeNoblesHut,pWagonId)) continue;
					else if(kbUnitCount(cMyID, cUnitTypeMarket, cUnitStateABQ) == 0 && wagonCheck(cUnitTypeMarket,pWagonId)) continue;
					else if(kbUnitCount(cMyID, cUnitTypeArtilleryDepot, cUnitStateABQ) < 3 && wagonCheck(cUnitTypeArtilleryDepot,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeCorral,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeSPCXPFortWagon:
				{
					if(wagonCheck(cUnitTypeFortFrontier,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeTradingPostTravois:
				{
					if(wagonCheck(gTradingPostUnit,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeYPCoveredWagonAsian:
				{
					if(wagonCheck(cUnitTypeTownCenter,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeYPVillageWagon:
				{
					if(wagonCheck(cUnitTypeypVillage,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeYPRicePaddyWagon:
				{
					if(wagonCheck(cUnitTypeypRicePaddy,pWagonId)) continue;
					else if(kbUnitCount(cMyID, cUnitTypeMill, cUnitStateABQ) < 6 && wagonCheck(cUnitTypeMill,pWagonId)) continue;
					else if(kbUnitCount(cMyID, cUnitTypeFarm, cUnitStateABQ) < 6 && wagonCheck(cUnitTypeFarm,pWagonId)) continue;
					else if(wagonCheck(cUnitTypePlantation,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeypArsenalWagon:
				{
					if(wagonCheck(cUnitTypeypArsenalOttoman,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeypArsenalAsian,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeArsenal,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeYPCastleWagon:
				{
					if(wagonCheck(cUnitTypeypCastle,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeYPDojoWagon:
				{
					if(wagonCheck(cUnitTypeypDojo,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeypShrineWagon:
				{
					if(wagonCheck(cUnitTypeypShrineJapanese,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
					break;
				}
				case cUnitTypeYPBerryWagon1:
				{
					if(wagonCheck(cUnitTypeypBerryBuilding,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeYPDockWagon:
				{
					if(wagonCheck(cUnitTypeDock,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeYPDockAsian,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeypSPCConsulateWagon:
				{
					if(wagonCheck(cUnitTypeypConsulate,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeYPGroveWagon:
				{
					if(wagonCheck(cUnitTypeypGroveBuilding,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeYPStableWagon:
				{
					if(wagonCheck(cUnitTypeStable,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeCorral,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeypCaravanserai,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeypStableJapanese,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeypWarAcademy,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeWarHut,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeypMarketWagon:
				{
					if(wagonCheck(cUnitTypeypTradeMarketAsian,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeMarket,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeypTradingPostWagon:
				{
					if(wagonCheck(gTradingPostUnit,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeypChurchWagon:
				{
					if(wagonCheck(cUnitTypeypChurch,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeYPMonasteryWagon:
				{
					if(wagonCheck(cUnitTypeypMonastery,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeMosque,pWagonId)) continue;
					else if(wagonCheck(gChurchUnit,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeYPMilitaryRickshaw:
				{
					if(kbUnitCount(cMyID, cUnitTypeypBarracksJapanese, cUnitStateABQ) < 3 && wagonCheck(cUnitTypeypBarracksJapanese,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeypStableJapanese,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeypBankWagon:
				{
					if(wagonCheck(cUnitTypeypBankAsian,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypexpBuilderStart:
				{
					if(kbUnitCount(cMyID, cUnitTypeFarm, cUnitStateABQ) > 0 && wagonCheck(cUnitTypeLonghouse,pWagonId)) continue;
					else if(wagonCheck(cUnitTypePlantation,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeFarm,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeMarket,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeDock,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeFirePit,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeTeepee,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeHouseAztec,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeYPCastleWagonIndians:
				{
					if(wagonCheck(cUnitTypeypCastle,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeYPCoveredWagonJapan:
				{
					if(wagonCheck(cUnitTypeTownCenter,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeYPCoveredWagonIndians:
				{
					if(wagonCheck(cUnitTypeTownCenter,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeYPCastleWagonJapan:
				{
					if(wagonCheck(cUnitTypeypCastle,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeYPSacredFieldWagon:
				{
					if(wagonCheck(cUnitTypeypSacredField,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeypBlockhouseWagon:
				{
					if(wagonCheck(cUnitTypeAsianBlockhouse,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypePlantationTravois:
				{
					if(wagonCheck(cUnitTypePlantation,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeCharminarGateWagon:
				{
					if(wagonCheck(cUnitTypeFakeCharminarGate,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeCommandWagon:
				{
					if(wagonCheck(cUnitTypeSPCFortCenterJ,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeSPCFortCenter,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeMosque,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeLumberWagon:
				{
					if(wagonCheck(cUnitTypeLumberCamp,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeWagonMarket:
				{
					if(wagonCheck(cUnitTypeypTradeMarketAsian,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeMarket,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeWagonMill:
				{
					if(wagonCheck(cUnitTypeMill,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeFarm,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeWagonPlantation:
				{
					if(wagonCheck(cUnitTypePlantation,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}	
				case cUnitTypeWagonDock:
				{
					if(wagonCheck(cUnitTypeYPDockAsian,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeDock,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeWagonBuildings:
				{
					if(wagonCheck(cUnitTypeSPCIncaTemple,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeSPCAztecTemple,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeSPCCherokeeWarHut,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeLivestockPen,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeArsenal,pWagonId)) continue;	
					else if(wagonCheck(cUnitTypeFarm,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeMill,pWagonId)) continue;
					else if(wagonCheck(cUnitTypePlantation,pWagonId)) continue;
					else if(wagonCheck(gChurchUnit,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeHouseEast,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeHouseMed,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeHouse,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeFirePit,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeTeepee,pWagonId)) continue;
					else if(kbUnitCount(cMyID, cUnitTypeFarm, cUnitStateABQ) > 0 && wagonCheck(cUnitTypeLonghouse,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeHouseAztec,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeManor,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeHouseVilla,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeHouseTorp,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeBasilicaIt,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeSPCXPBaker,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeSPCXPMiningCamp,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeMarket,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeWagonBuildings2:
				{
					if(wagonCheck(gBarracksUnit,pWagonId)) continue;
					else if(wagonCheck(gStableUnit,pWagonId)) continue;
					else if(wagonCheck(gArtilleryDepotUnit,pWagonId)) continue;
 					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
                
				case cUnitTypeWagonCapitol:
				{
					if(wagonCheck(gCapitolUnit,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeWagonTradePost:
				{
					if(wagonCheck(gTradingPostUnit,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeWagonBuildingsFame:
				{
					if(gWaterMap && wagonCheck(cUnitTypeDock,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeBlockhouse,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeWarHut,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeBarracks,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeStable,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeCorral,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeNoblesHut,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeArtilleryDepot,pWagonId)) continue;
					else if(wagonCheck(cUnitTypeSPCFortCenter,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeToshoguShrineWagon:
				{
					if(wagonCheck(cUnitTypeFakeToshoguShrine,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeWhitePagodaWagon:
				{
					if(wagonCheck(cUnitTypeFakeWhitePagoda,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeToriiGatesWagon:
				{
					if(wagonCheck(cUnitTypeFakeToriiGates,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeTempleOfHeavenWagon:
				{
					if(wagonCheck(cUnitTypeFakeTempleOfHeaven,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeKarniMataWagon:
				{
					if(wagonCheck(cUnitTypeFakeKarniMata,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeShogunateWagon:
				{
					if(wagonCheck(cUnitTypeFakeShogunate,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypePorcelainTowerWagon:
				{
					if(wagonCheck(cUnitTypeFakePorcelainTower,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				case cUnitTypeTajMahalWagon:
				{
					if(wagonCheck(cUnitTypeFakeTajMahal,pWagonId)) continue;
					else debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " no build option found" ,3);
					continue; break;
				}
				default:
				{
					debugRule("wagonMonitor - Warning " + kbUnitGetProtoUnitID(pWagonId) + " Could not find wagon" ,3);
					break;
				}
			}
		}
	}
}

//rule brigadeMonitor
//inactive
//minInterval 120
void brigadeMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 120000,"brigadeMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	// Quit if there is no consulate
	if (kbUnitCount(cMyID, cUnitTypeypConsulate, cUnitStateAlive) < 1)
	{
		return;
	}

	// Research brigade technologies
	// Unavailable ones are simply ignored
	int brigadePlanID = -1;

	// British brigade
	if (kbTechGetStatus(cTechypConsulateBritishBrigade) == cTechStatusObtainable)
	{
		brigadePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulateBritishBrigade);
		if (brigadePlanID >= 0)
			aiPlanDestroy(brigadePlanID);
		createSimpleResearchPlan(cTechypConsulateBritishBrigade, getUnit(cUnitTypeypConsulate), cMilitaryEscrowID, 50);
		return;
	}

	// Dutch brigade
	// (skipped to avoid mortars)

	// French brigade
	if (kbTechGetStatus(cTechypConsulateFrenchBrigade) == cTechStatusObtainable)
	{
		brigadePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulateFrenchBrigade);
		if (brigadePlanID >= 0)
			aiPlanDestroy(brigadePlanID);
		createSimpleResearchPlan(cTechypConsulateFrenchBrigade, getUnit(cUnitTypeypConsulate), cMilitaryEscrowID, 50);
		return;
	}

	// German brigade
	if (kbTechGetStatus(cTechypConsulateGermansBrigade) == cTechStatusObtainable)
	{
		brigadePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulateGermansBrigade);
		if (brigadePlanID >= 0)
			aiPlanDestroy(brigadePlanID);
		createSimpleResearchPlan(cTechypConsulateGermansBrigade, getUnit(cUnitTypeypConsulate), cMilitaryEscrowID, 50);
		return;
	}

	// Ottoman brigade
	if (kbTechGetStatus(cTechypConsulateOttomansBrigade) == cTechStatusObtainable)
	{
		brigadePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulateOttomansBrigade);
		if (brigadePlanID >= 0)
			aiPlanDestroy(brigadePlanID);
		createSimpleResearchPlan(cTechypConsulateOttomansBrigade, getUnit(cUnitTypeypConsulate), cMilitaryEscrowID, 50);
		return;
	}

	// Portuguese brigade
	if (kbTechGetStatus(cTechypConsulatePortugueseBrigade) == cTechStatusObtainable)
	{
		brigadePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulatePortugueseBrigade);
		if (brigadePlanID >= 0)
			aiPlanDestroy(brigadePlanID);
		createSimpleResearchPlan(cTechypConsulatePortugueseBrigade, getUnit(cUnitTypeypConsulate), cMilitaryEscrowID, 50);
		return;
	}

	// Russian brigade
	if (kbTechGetStatus(cTechypConsulateRussianBrigade) == cTechStatusObtainable)
	{
		brigadePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulateRussianBrigade);
		if (brigadePlanID >= 0)
			aiPlanDestroy(brigadePlanID);
		createSimpleResearchPlan(cTechypConsulateRussianBrigade, getUnit(cUnitTypeypConsulate), cMilitaryEscrowID, 50);
		return;
	}

	// Spanish brigade
	if (kbTechGetStatus(cTechypConsulateSpanishBrigade) == cTechStatusObtainable)
	{
		brigadePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechypConsulateSpanishBrigade);
		if (brigadePlanID >= 0)
			aiPlanDestroy(brigadePlanID);
		createSimpleResearchPlan(cTechypConsulateSpanishBrigade, getUnit(cUnitTypeypConsulate), cMilitaryEscrowID, 50);
		return;
	}
}
//rule porcelainTowerTacticMonitor
//inactive
//group tcComplete
//mininterval 60
void porcelainTowerTacticMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 60000,"porcelainTowerTacticMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	static int porcelainTowerQueryID = -1;
	
	// Disable rule for anybody but Chinese
	if (kbGetCiv() != cCivChinese)
	{
		//xsDisableSelf();
		return;
	}

	int porcelainTowerType = -1;
	static int resourceType = -1;

	// Check for porcelain tower
	if (kbUnitCount(cMyID, cUnitTypeypWCPorcelainTower2, cUnitStateAlive) > 0)
	{
		porcelainTowerType = cUnitTypeypWCPorcelainTower2;
	}
	else if (kbUnitCount(cMyID, cUnitTypeypWCPorcelainTower3, cUnitStateAlive) > 0)
	{
		porcelainTowerType = cUnitTypeypWCPorcelainTower3;
	}
	else if (kbUnitCount(cMyID, cUnitTypeypWCPorcelainTower4, cUnitStateAlive) > 0)
	{
		porcelainTowerType = cUnitTypeypWCPorcelainTower4;
	}
	else if (kbUnitCount(cMyID, cUnitTypeypWCPorcelainTower5, cUnitStateAlive) > 0)
	{
		porcelainTowerType = cUnitTypeypWCPorcelainTower5;
	}

	if (porcelainTowerType > 0)
	{
		if( porcelainTowerQueryID == -1) porcelainTowerQueryID = kbUnitQueryCreate("porcelainTowerQueryID"+getQueryId());
		kbUnitQueryResetResults(porcelainTowerQueryID);
		kbUnitQuerySetIgnoreKnockedOutUnits(porcelainTowerQueryID, true);
		if (porcelainTowerQueryID != -1)
		{
			
			kbUnitQuerySetPlayerRelation(porcelainTowerQueryID, -1);
			kbUnitQuerySetPlayerID(porcelainTowerQueryID, cMyID,false);
			kbUnitQuerySetUnitType(porcelainTowerQueryID, porcelainTowerType);
			kbUnitQuerySetState(porcelainTowerQueryID, cUnitStateAlive);
			
			int numberFound = kbUnitQueryExecute(porcelainTowerQueryID);

			// Cycle resource generation through all three resources
			// (resources types are 0 - food, 1 - wood, 2 - coin)
			if (numberFound > 0)
			{
				resourceType = resourceType + 1;
				if (resourceType > 2)
					resourceType = 0;
				switch (resourceType)
				{
					case 0:
						{
							aiUnitSetTactic(kbUnitQueryGetResult(porcelainTowerQueryID, 0), cTacticWonderFood);
							break;
						}
					case 1:
						{
							aiUnitSetTactic(kbUnitQueryGetResult(porcelainTowerQueryID, 0), cTacticWonderWood);
							break;
						}
					case 2:
						{
							aiUnitSetTactic(kbUnitQueryGetResult(porcelainTowerQueryID, 0), cTacticWonderCoin);
							break;
						}
					default: // catch-all, should never happen
						{
							aiUnitSetTactic(kbUnitQueryGetResult(porcelainTowerQueryID, 0), cTacticWonderRainbow);
							break;
						}
				}
			}
		}
	}
}

//rule summerPalaceTacticMonitor
//inactive
//mininterval 10
void summerPalaceTacticMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"summerPalaceTacticMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	int summerPalaceType = -1;
	int randomizer = -1;
	static int summerPalaceQueryID = -1;

	// Check for summer palace
	if (kbUnitCount(cMyID, cUnitTypeypWCSummerPalace2, cUnitStateAlive) > 0)
	{
		summerPalaceType = cUnitTypeypWCSummerPalace2;
	}
	else if (kbUnitCount(cMyID, cUnitTypeypWCSummerPalace3, cUnitStateAlive) > 0)
	{
		summerPalaceType = cUnitTypeypWCSummerPalace3;
	}
	else if (kbUnitCount(cMyID, cUnitTypeypWCSummerPalace4, cUnitStateAlive) > 0)
	{
		summerPalaceType = cUnitTypeypWCSummerPalace4;
	}
	else if (kbUnitCount(cMyID, cUnitTypeypWCSummerPalace5, cUnitStateAlive) > 0)
	{
		summerPalaceType = cUnitTypeypWCSummerPalace5;
	}

	if (summerPalaceType > 0)
	{
		if(summerPalaceQueryID == -1) summerPalaceQueryID = kbUnitQueryCreate("summerPalaceQueryID"+getQueryId());
		kbUnitQueryResetResults(summerPalaceQueryID);
		kbUnitQuerySetIgnoreKnockedOutUnits(summerPalaceQueryID, true);
		if (summerPalaceQueryID != -1)
		{
			kbUnitQuerySetPlayerRelation(summerPalaceQueryID, -1);
			kbUnitQuerySetPlayerID(summerPalaceQueryID, cMyID,false);
			kbUnitQuerySetUnitType(summerPalaceQueryID, summerPalaceType);
			kbUnitQuerySetState(summerPalaceQueryID, cUnitStateAlive);
			
			int numberFound = kbUnitQueryExecute(summerPalaceQueryID);

			// In Age 3 and above, spawn either territorial, forbidden or imperial army
			// In Age 2, stay with standard army (default)
			if ((numberFound > 0) && (gCurrentAge >= cAge3))
			{
				randomizer = aiRandInt(3);
				switch (randomizer)
				{
					case 0:
						{
							aiUnitSetTactic(kbUnitQueryGetResult(summerPalaceQueryID, 0), cTacticTerritorialArmy);
							break;
						}
					case 1:
						{
							aiUnitSetTactic(kbUnitQueryGetResult(summerPalaceQueryID, 0), cTacticForbiddenArmy);
							break;
						}
					default:
						{
							aiUnitSetTactic(kbUnitQueryGetResult(summerPalaceQueryID, 0), cTacticImperialArmy);
							break;
						}
				}

				// Disable rule once a new tactic has been set
				//xsDisableSelf();
			}
		}
	}
}

//rule goldenPavillionTacticMonitor
//inactive
//group tcComplete
//mininterval 60
void goldenPavillionTacticMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 60000,"goldenPavillionTacticMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	static int goldenPavillionQueryID = -1;
	// Disable rule for anybody but Japanese
	if (kbGetCiv() != cCivJapanese)
	{
		//xsDisableSelf();
		return;
	}

	int goldenPavillionType = -1;

	// Check for golden pavillion
	if (kbUnitCount(cMyID, cUnitTypeypWJGoldenPavillion2, cUnitStateAlive) > 0)
	{
		goldenPavillionType = cUnitTypeypWJGoldenPavillion2;
	}
	else if (kbUnitCount(cMyID, cUnitTypeypWJGoldenPavillion3, cUnitStateAlive) > 0)
	{
		goldenPavillionType = cUnitTypeypWJGoldenPavillion3;
	}
	else if (kbUnitCount(cMyID, cUnitTypeypWJGoldenPavillion4, cUnitStateAlive) > 0)
	{
		goldenPavillionType = cUnitTypeypWJGoldenPavillion4;
	}
	else if (kbUnitCount(cMyID, cUnitTypeypWJGoldenPavillion5, cUnitStateAlive) > 0)
	{
		goldenPavillionType = cUnitTypeypWJGoldenPavillion5;
	}

	if (goldenPavillionType > 0)
	{
		if(goldenPavillionQueryID == -1) goldenPavillionQueryID = kbUnitQueryCreate("goldenPavillionQueryID"+getQueryId());
		kbUnitQueryResetResults(goldenPavillionQueryID);
		kbUnitQuerySetIgnoreKnockedOutUnits(goldenPavillionQueryID, true);
		if (goldenPavillionQueryID != -1)
		{
			kbUnitQuerySetPlayerRelation(goldenPavillionQueryID, -1);
			kbUnitQuerySetPlayerID(goldenPavillionQueryID, cMyID,false);
			kbUnitQuerySetUnitType(goldenPavillionQueryID, goldenPavillionType);
			kbUnitQuerySetState(goldenPavillionQueryID, cUnitStateAlive);
			
			int numberFound = kbUnitQueryExecute(goldenPavillionQueryID);

			// Activate land military hitpoint bonus and disable rule
			if (numberFound > 0)
			{
				aiUnitSetTactic(kbUnitQueryGetResult(goldenPavillionQueryID, 0), cTacticUnitHitpoints);
				//xsDisableSelf();
			}
		}
	}
}

//rule dojoTacticMonitor
//inactive
//minInterval 10
void dojoTacticMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 30000,"dojoTacticMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	int randomizer = -1;
	static int dojoTactic1 = -1;
	static int dojoTactic2 = -1;

	// Randomize unit generation option for first dojo
	if (dojoTactic1 < 0)
	{
		randomizer = aiRandInt(5);
		switch (randomizer)
		{
			case 0:
				{
					dojoTactic1 = cTacticYumi;
					break;
				}
			case 1:
				{
					dojoTactic1 = cTacticAshigaru;
					break;
				}
			case 2:
				{
					dojoTactic1 = cTacticSamurai;
					break;
				}
			case 3:
				{
					dojoTactic1 = cTacticNaginataRider;
					break;
				}
			default:
				{
					dojoTactic1 = cTacticYabusame;
					break;
				}
		}
	}

	// Randomize unit generation option for second dojo
	if (dojoTactic2 < 0)
	{
		randomizer = aiRandInt(5);
		switch (randomizer)
		{
			case 0:
				{
					dojoTactic2 = cTacticYumi;
					break;
				}
			case 1:
				{
					dojoTactic2 = cTacticAshigaru;
					break;
				}
			case 2:
				{
					dojoTactic2 = cTacticSamurai;
					break;
				}
			case 3:
				{
					dojoTactic2 = cTacticNaginataRider;
					break;
				}
			default:
				{
					dojoTactic2 = cTacticYabusame;
					break;
				}
		}
	}

	// Define a query to get all matching units
	static int dojoQueryID = -1;
	if(dojoQueryID == -1)dojoQueryID = kbUnitQueryCreate("dojoGetUnitQuery"+getQueryId());
	kbUnitQueryResetResults(dojoQueryID);
	kbUnitQuerySetIgnoreKnockedOutUnits(dojoQueryID, true);
	if (dojoQueryID != -1)
	{
		kbUnitQuerySetPlayerRelation(dojoQueryID, -1);
		kbUnitQuerySetPlayerID(dojoQueryID, cMyID,false);
		kbUnitQuerySetUnitType(dojoQueryID, cUnitTypeypDojo);
		kbUnitQuerySetState(dojoQueryID, cUnitStateAlive);
		
		int numberFound = kbUnitQueryExecute(dojoQueryID);
		if (numberFound == 1)
		{
			aiUnitSetTactic(kbUnitQueryGetResult(dojoQueryID, 0), dojoTactic1);
		}
		else if (numberFound == 2)
		{
			aiUnitSetTactic(kbUnitQueryGetResult(dojoQueryID, 0), dojoTactic1);
			aiUnitSetTactic(kbUnitQueryGetResult(dojoQueryID, 1), dojoTactic2);
			//xsDisableSelf();
		}
	}
}
//==============================================================================
/* factoryTacticMonitor
	updatedOn 2020/02/02 By ageekhere  
*/
//==============================================================================
//rule factoryTacticMonitor
//inactive
//minInterval 10
void factoryTacticMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"factoryTacticMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	// Define a query to get all matching units
	static int factoryQueryID = -1;

	if (factoryQueryID == -1) factoryQueryID = kbUnitQueryCreate("factoryGetUnitQuery"+getQueryId());
	kbUnitQueryResetResults(factoryQueryID);
	kbUnitQuerySetIgnoreKnockedOutUnits(factoryQueryID, true);
	kbUnitQuerySetPlayerRelation(factoryQueryID, -1);
	kbUnitQuerySetPlayerID(factoryQueryID, cMyID, false);
	kbUnitQuerySetUnitType(factoryQueryID, cUnitTypeFactory);
	kbUnitQuerySetState(factoryQueryID, cUnitStateAlive);
	
	int setTatic = cTacticWood;
	if (gCurrentWood > 1000)
	{
		if (gCurrentCoin > gCurrentFood) setTatic = cTacticFood;
		if (gCurrentCoin < gCurrentFood) setTatic = cTacticCoin;
	}

	if (factoryQueryID != -1)
	{
		
		int numberFound = kbUnitQueryExecute(factoryQueryID);
		if (numberFound == 1)
		{
			aiUnitSetTactic(kbUnitQueryGetResult(factoryQueryID, 0), setTatic);
		}
		else if (numberFound > 1)
		{
			aiUnitSetTactic(kbUnitQueryGetResult(factoryQueryID, 0), setTatic);
			aiUnitSetTactic(kbUnitQueryGetResult(factoryQueryID, 1), setTatic);
			//xsDisableSelf();
			kbUnitQueryDestroy(factoryQueryID);
		}
	}
}



//rule mansabdarMonitor
//inactive
//minInterval 10
void mansabdarMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"mansabdarMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	static int mansabdarRajputPlan = -1;
	static int mansabdarSepoyPlan = -1;
	static int mansabdarGurkhaPlan = -1;
	static int mansabdarSowarPlan = -1;
	static int mansabdarZamburakPlan = -1;

	int numRajputs = -1;
	int numSepoys = -1;
	int numGurkhas = -1;
	int numSowars = -1;
	int numZamburaks = -1;

	// Check number of rajputs, maintain mansabdar rajput as long as there are at least 10
	numRajputs = kbUnitCount(cMyID, cUnitTypeypRajput, cUnitStateAlive);
	if (numRajputs >= 10)
	{
		// Create/update maintain plan
		if (mansabdarRajputPlan < 0)
		{
			mansabdarRajputPlan = createSimpleMaintainPlan(cUnitTypeypRajputMansabdar, 1, false, kbBaseGetMainID(cMyID), 1,mansabdarRajputPlan);
		}
		else
		{
			aiPlanSetVariableInt(mansabdarRajputPlan, cTrainPlanNumberToMaintain, 0, 1);
		}
	}
	else
	{
		// Update maintain plan, provided it exists
		if (mansabdarRajputPlan >= 0)
		{
			aiPlanSetVariableInt(mansabdarRajputPlan, cTrainPlanNumberToMaintain, 0, 0);
		}
	}
	// Check number of sepoys, maintain mansabdar sepoy as long as there are at least 10
	numSepoys = kbUnitCount(cMyID, cUnitTypeypSepoy, cUnitStateAlive);
	if (numSepoys >= 10)
	{
		// Create/update maintain plan
		if (mansabdarSepoyPlan < 0)
		{
			mansabdarSepoyPlan = createSimpleMaintainPlan(cUnitTypeypSepoyMansabdar, 1, false, kbBaseGetMainID(cMyID), 1,mansabdarSepoyPlan);
		}
		else
		{
			aiPlanSetVariableInt(mansabdarSepoyPlan, cTrainPlanNumberToMaintain, 0, 1);
		}
	}
	else
	{
		// Update maintain plan, provided it exists
		if (mansabdarSepoyPlan >= 0)
		{
			aiPlanSetVariableInt(mansabdarSepoyPlan, cTrainPlanNumberToMaintain, 0, 0);
		}
	}
	// Check number of gurkhas, maintain mansabdar gurkha as long as there are at least 10
	numGurkhas = kbUnitCount(cMyID, cUnitTypeypNatMercGurkha, cUnitStateAlive);
	if (numGurkhas >= 10)
	{
		// Create/update maintain plan
		if (mansabdarGurkhaPlan < 0)
		{
			mansabdarGurkhaPlan = createSimpleMaintainPlan(cUnitTypeypNatMercGurkhaJemadar, 1, false, kbBaseGetMainID(cMyID), 1,mansabdarGurkhaPlan);
		}
		else
		{
			aiPlanSetVariableInt(mansabdarGurkhaPlan, cTrainPlanNumberToMaintain, 0, 1);
		}
	}
	else
	{
		// Update maintain plan, provided it exists
		if (mansabdarGurkhaPlan >= 0)
		{
			aiPlanSetVariableInt(mansabdarGurkhaPlan, cTrainPlanNumberToMaintain, 0, 0);
		}
	}
	// Check number of sowars, maintain mansabdar sowar as long as there are at least 10
	numSowars = kbUnitCount(cMyID, cUnitTypeypSowar, cUnitStateAlive);
	if (numSowars >= 10)
	{
		// Create/update maintain plan
		if (mansabdarSowarPlan < 0)
		{
			mansabdarSowarPlan = createSimpleMaintainPlan(cUnitTypeypSowarMansabdar, 1, false, kbBaseGetMainID(cMyID), 1,mansabdarSowarPlan);
		}
		else
		{
			aiPlanSetVariableInt(mansabdarSowarPlan, cTrainPlanNumberToMaintain, 0, 1);
		}
	}
	else
	{
		// Update maintain plan, provided it exists
		if (mansabdarSowarPlan >= 0)
		{
			aiPlanSetVariableInt(mansabdarSowarPlan, cTrainPlanNumberToMaintain, 0, 0);
		}
	}
	// Check number of zamburaks, maintain mansabdar zamburak as long as there are at least 10
	numZamburaks = kbUnitCount(cMyID, cUnitTypeypZamburak, cUnitStateAlive);
	if (numZamburaks >= 10)
	{
		// Create/update maintain plan
		if (mansabdarZamburakPlan < 0)
		{
			mansabdarZamburakPlan = createSimpleMaintainPlan(cUnitTypeypZamburakMansabdar, 1, false, kbBaseGetMainID(cMyID), 1,mansabdarZamburakPlan);
		}
		else
		{
			aiPlanSetVariableInt(mansabdarZamburakPlan, cTrainPlanNumberToMaintain, 0, 1);
		}
	}
	else
	{
		// Update maintain plan, provided it exists
		if (mansabdarZamburakPlan >= 0)
		{
			aiPlanSetVariableInt(mansabdarZamburakPlan, cTrainPlanNumberToMaintain, 0, 0);
		}
	}
}

rule monitorFeeding
inactive
minInterval 60
{
	// Once a minute, check the global vars to see if there is somebody we need
	// to be sending resources to.  If so, send whatever we have in root.  If not,
	// go to sleep.
	// Feeding is not allowed before Age 2 is reached
	bool stayAwake = false; // Set true if we have orders to feed anything, keeps rule active.
	float toSend = 0.0;
	bool goldSent = false; // Used for choosing chat at end.
	bool woodSent = false;
	bool foodSent = false;
	bool failure = false;
	int failPlayerID = -1;

	// Ignore already eliminated players
	if (kbHasPlayerLost(gFeedGoldTo) == true)
		gFeedGoldTo = 0;
	if (kbHasPlayerLost(gFeedWoodTo) == true)
		gFeedWoodTo = 0;
	if (kbHasPlayerLost(gFeedFoodTo) == true)
		gFeedFoodTo = 0;

	if (gFeedGoldTo > 0)
	{
		stayAwake = true; // There is work to do, stay active.
		toSend = 0.0;
		if (aiResourceIsLocked(cResourceGold) == false)
		{
			kbEscrowFlush(cEconomyEscrowID, cResourceGold, false);
			kbEscrowFlush(cMilitaryEscrowID, cResourceGold, false);
			toSend = kbEscrowGetAmount(cRootEscrowID, cResourceGold) * .85; // Round down for trib penalty
		}
		if ((toSend > 100.0) && (gCurrentAge >= cAge2))
		{ // can send something
			goldSent = true;
			gLastTribSentTime = gCurrentGameTime;
			if (toSend > 1000.0)
				toSend = 1000;
			if (toSend > 200.0)
				aiTribute(gFeedGoldTo, cResourceGold, toSend / 2);
			else
				aiTribute(gFeedGoldTo, cResourceGold, 100.0);
		}
		else
		{
			failure = true;
			failPlayerID = gFeedGoldTo;
		}
		stayAwake = true; // There is work to do, stay active.
	}

	if (gFeedWoodTo > 0)
	{
		stayAwake = true; // There is work to do, stay active.
		toSend = 0.0;
		if (aiResourceIsLocked(cResourceWood) == false)
		{
			kbEscrowFlush(cEconomyEscrowID, cResourceWood, false);
			kbEscrowFlush(cMilitaryEscrowID, cResourceWood, false);
			toSend = kbEscrowGetAmount(cRootEscrowID, cResourceWood) * .85; // Round down for trib penalty
		}
		if ((toSend > 100.0) && (gCurrentAge >= cAge2))
		{ // can send something
			gLastTribSentTime = gCurrentGameTime;
			woodSent = true;
			if (toSend > 1000.0)
				toSend = 1000;
			if (toSend > 200.0)
				aiTribute(gFeedWoodTo, cResourceWood, toSend / 2);
			else
				aiTribute(gFeedWoodTo, cResourceWood, 100.0);
		}
		else
		{
			failure = true;
			failPlayerID = gFeedWoodTo;
		}
		stayAwake = true; // There is work to do, stay active.
	}

	if (gFeedFoodTo > 0)
	{
		stayAwake = true; // There is work to do, stay active.
		toSend = 0.0;
		if (aiResourceIsLocked(cResourceFood) == false)
		{
			kbEscrowFlush(cEconomyEscrowID, cResourceFood, false);
			kbEscrowFlush(cMilitaryEscrowID, cResourceFood, false);
			toSend = kbEscrowGetAmount(cRootEscrowID, cResourceFood) * .85; // Round down for trib penalty
		}
		if ((toSend > 100.0) && (gCurrentAge >= cAge2))
		{ // can send something
			gLastTribSentTime = gCurrentGameTime;
			foodSent = true;
			if (toSend > 1000.0)
				toSend = 1000;
			if (toSend > 200.0)
				aiTribute(gFeedFoodTo, cResourceFood, toSend / 2);
			else
				aiTribute(gFeedFoodTo, cResourceFood, 100.0);
		}
		else
		{
			failure = true;
			failPlayerID = gFeedFoodTo;
		}
		stayAwake = true; // There is work to do, stay active.
	}

	int tributes = 0;
	if (goldSent == true)
		tributes = tributes + 1;
	if (woodSent == true)
		tributes = tributes + 1;
	if (foodSent == true)
		tributes = tributes + 1;

	if (stayAwake == false)
	{
		//aiEcho("Disabling monitorFeeding rule.");
		xsDisableSelf(); // No work to do, go to sleep.
	}
}


void rescueExplorerMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 60000,"rescueExplorerMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	static int rescuePlan = -1;

	// Disable rule for native civs
	if (getCivIsNative() == true)
	{
		//xsDisableSelf();
		return;
	}

	// Destroy old rescue plan (if any)
	if (rescuePlan >= 0)
	{
		aiPlanDestroy(rescuePlan);
		rescuePlan = -1;
		//aiEcho("Killing old rescue plan");
	}

	// Use only in Age 2 and above
	if ((gCurrentAge < cAge2) || (aiGetFallenExplorerID() < 0))
	{
		//aiEcho("No explorer to rescue");
		return;
	}

	// Use only when explorer is strong enough
	if (kbUnitGetHealth(aiGetFallenExplorerID()) < 0.3)
	{
		//aiEcho("Explorer too weak to be rescued");
		return;
	}

	// Decide on which unit type to use for rescue attempt
	// If possible, converted guardians or cheap infantry units are used
	int scoutType = -1;
	if (kbUnitCount(cMyID, cUnitTypeGuardian, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeGuardian;
	else if (kbUnitCount(cMyID, cUnitTypeCrossbowman, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeCrossbowman;
	else if (kbUnitCount(cMyID, cUnitTypePikeman, cUnitStateAlive) >= 1)
		scoutType = cUnitTypePikeman;
	else if (kbUnitCount(cMyID, cUnitTypeStrelet, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeStrelet;
	else if (kbUnitCount(cMyID, cUnitTypeLongbowman, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeLongbowman;
	else if (kbUnitCount(cMyID, cUnitTypeMusketeer, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeMusketeer;
	else if (kbUnitCount(cMyID, cUnitTypexpWarrior, cUnitStateAlive) >= 1)
		scoutType = cUnitTypexpWarrior;
	else if (kbUnitCount(cMyID, cUnitTypexpAenna, cUnitStateAlive) >= 1)
		scoutType = cUnitTypexpAenna;
	else if (kbUnitCount(cMyID, cUnitTypexpTomahawk, cUnitStateAlive) >= 1)
		scoutType = cUnitTypexpTomahawk;
	else if (kbUnitCount(cMyID, cUnitTypexpMacehualtin, cUnitStateAlive) >= 1)
		scoutType = cUnitTypexpMacehualtin;
	else if (kbUnitCount(cMyID, cUnitTypexpPumaMan, cUnitStateAlive) >= 1)
		scoutType = cUnitTypexpPumaMan;
	else if (kbUnitCount(cMyID, cUnitTypexpWarBow, cUnitStateAlive) >= 1)
		scoutType = cUnitTypexpWarBow;
	else if (kbUnitCount(cMyID, cUnitTypexpWarClub, cUnitStateAlive) >= 1)
		scoutType = cUnitTypexpWarClub;
	else if (kbUnitCount(cMyID, cUnitTypeSaloonOutlawPistol, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeSaloonOutlawPistol;
	else if (kbUnitCount(cMyID, cUnitTypeSaloonOutlawRifleman, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeSaloonOutlawRifleman;
	else if (kbUnitCount(cMyID, cUnitTypeJanissary, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeJanissary;
	else if (kbUnitCount(cMyID, cUnitTypeypQiangPikeman, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeypQiangPikeman;
	else if (kbUnitCount(cMyID, cUnitTypeypChuKoNu, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeypChuKoNu;
	else if (kbUnitCount(cMyID, cUnitTypeypMonkDisciple, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeypMonkDisciple;
	else if (kbUnitCount(cMyID, cUnitTypeypArquebusier, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeypArquebusier;
	else if (kbUnitCount(cMyID, cUnitTypeypChangdao, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeypChangdao;
	else if (kbUnitCount(cMyID, cUnitTypeypSepoy, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeypSepoy;
	else if (kbUnitCount(cMyID, cUnitTypeypNatMercGurkha, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeypNatMercGurkha;
	else if (kbUnitCount(cMyID, cUnitTypeypRajput, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeypRajput;
	else if (kbUnitCount(cMyID, cUnitTypeypYumi, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeypYumi;
	else if (kbUnitCount(cMyID, cUnitTypeypAshigaru, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeypAshigaru;
	else if (kbUnitCount(cMyID, cUnitTypeEnvoy, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeEnvoy;
	else if (kbUnitCount(cMyID, cUnitTypeNativeScout, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeNativeScout;
	else if (kbUnitCount(cMyID, cUnitTypeypMongolScout, cUnitStateAlive) >= 1)
		scoutType = cUnitTypeypMongolScout;
	else
		scoutType = cUnitTypeLogicalTypeValidSharpshoot;


	// Get position of fallen explorer and send scout unit there
	vector fallenExplorerLocation = kbUnitGetPosition(aiGetFallenExplorerID());
	rescuePlan = aiPlanCreate("Rescue Explorer", cPlanExplore);
	if (rescuePlan >= 0)
	{
		aiPlanAddUnitType(rescuePlan, scoutType, 1, 1, 1);
		aiPlanAddWaypoint(rescuePlan, fallenExplorerLocation);
		aiPlanSetVariableBool(rescuePlan, cExplorePlanDoLoops, 0, false);
		aiPlanSetVariableBool(rescuePlan, cExplorePlanAvoidingAttackedAreas, 0, false);
		aiPlanSetVariableInt(rescuePlan, cExplorePlanNumberOfLoops, 0, -1);
		aiPlanSetRequiresAllNeedUnits(rescuePlan, true);
		aiPlanSetDesiredPriority(rescuePlan, 42);
		aiPlanSetActive(rescuePlan);
		//aiEcho("Trying to rescue explorer");
	}
}

//==============================================================================
// tradeRouteUpgradeMonitor
/*
Monitors Trading Post Site and researches upgrades when appropriate. 
NOTES
1. Need to test when a trade post is destroyed while it is upgrading/researching does it kill the plan
2. more logic is needed for when there is more than 1 ai upgrading the same trade root
*/
// updatedOn 2021/06/25 By ageekhere
//==============================================================================
rule tradeRouteUpgradeMonitor
inactive
group tcComplete
minInterval 120
{
	if(kbIsFFA() == true)
	{
		xsDisableSelf();
		return;
	}
	if (tradeRouteFinderDone == false || gCurrentAge < cAge2) return;
	static int tradeRouteUpgradePlan1ID = -1; //stores the Trade Route Plan ID 
	static int tradeRouteUpgradePlan2ID = -1; //stores the Trade Route Plan ID 
	static int tradeRouteUpgradePlanID = -1; //stores the Trade Route Plan ID 
	static int tradeRouteUpgradeTechID = -1; //stores the Trade Route Tech ID 
	static int ownTPList = -1; //stores the VP Site Query ID
	static int tradeRouteUpgradeUnitID = -1; //stores the Trade Route Upgrade Unit ID
	static vector siteLocation1 = cInvalidVector; //stoes the site locaiton
	static vector siteLocation2 = cInvalidVector; //stoes the site locaiton
	static int tradeRouteUpgrade1Type = -1; //level 1 TradeRouteUpgrade1 
	static int tradeRouteUpgrade2Type = -1; //level 2 TradeRouteUpgrade1 
	//static int socketID = -1;
	static vector siteLocation = cInvalidVector;
	static bool disableRoot1 = false;
	static bool disableRoot2 = false;
	static int upgradeCountRoot1 = 0;
	static int upgradeCountRoot2 = 0;
	static int upgradeTechRoot1 = -1;
	static int upgradeTechRoot2 = -1;
	static int ownTradePost = -1;
	static int techUpgradeType1 = -1;
	static int techUpgradeType2 = -1;
	static bool emptyTradeRoot = false;
	static int rootId = -1;
	
	aiPlanDestroy(tradeRouteUpgradePlan1ID);
	aiPlanDestroy(tradeRouteUpgradePlan2ID);
	aiPlanDestroy(tradeRouteUpgradePlanID);
	aiPlanDestroy(tradeRouteUpgradeTechID);
	
	if (upgradeTechRoot1 == -1)
	{ //set the current root Tech upgrade and iron horse upgrade	
		if (kbTechGetStatus(cTechTradeRouteUpgrade1) == 1)
		{ //Check Tech status
			upgradeTechRoot1 = cTechTradeRouteUpgrade1; //root 1
			upgradeTechRoot2 = cTechTradeRouteUpgrade1; //root 2
			techUpgradeType1 = cTechTradeRouteUpgrade1; //Tech upgrade 1
			techUpgradeType2 = cTechTradeRouteUpgrade2; //Tech upgrade 2
		} //end if
		else if (kbTechGetStatus(cTechypTradeRouteUpgrade1) == 1)
		{ //Check Tech status
			upgradeTechRoot1 = cTechypTradeRouteUpgrade1; //root 1
			upgradeTechRoot2 = cTechypTradeRouteUpgrade1; //root 2
			techUpgradeType1 = cTechypTradeRouteUpgrade1; //Tech upgrade 1
			techUpgradeType2 = cTechypTradeRouteUpgrade2; //Tech upgrade 2
		} //end else if
		else if (kbTechGetStatus(cTechypTradeRouteUpgradeIndia1) == 1)
		{ //Check Tech status
			upgradeTechRoot1 = cTechypTradeRouteUpgradeIndia1; //root 1
			upgradeTechRoot2 = cTechypTradeRouteUpgradeIndia1; //root 2
			techUpgradeType1 = cTechypTradeRouteUpgradeIndia1; //Tech upgrade 1
			techUpgradeType2 = cTechypTradeRouteUpgradeIndia2; //Tech upgrade 2
		} //end else if

		for (i = 0; < tradeRoomCheckNumber)
		{ //Check for empty Trade Roots
			emptyTradeRoot = true; //reset 
			if (i == 0) rootId = tradeRoot1; //root 1
			else rootId = tradeRoot2; //root 2
			for (j = 0; < xsArrayGetSize(rootId))
			{ //Loop through root array
				if (xsArrayGetInt(rootId, j) != -1)
				{ //trade root found
					emptyTradeRoot = false; //not empty
					break;
				} //end if
			} //end for j
			if (emptyTradeRoot == true)
			{ //was it empty
				if (i == 0) disableRoot1 = true; //disable root 1
				else disableRoot2 = true; //disable root 2
			} //end if
		} //end for i
	} //end if
	siteLocation = cInvalidVector; //default site location
	siteLocation1 = cInvalidVector; //site location root 1
	siteLocation2 = cInvalidVector; //site location root 2
	if (ownTradePost == -1) ownTradePost = kbUnitQueryCreate("ownTradePost"+getQueryId()); //Create a new Trade unit Query
	kbUnitQueryResetResults(ownTradePost); //reset the results
	kbUnitQuerySetPlayerID(ownTradePost, cMyID,false); //set player
	kbUnitQuerySetUnitType(ownTradePost, gTradingPostUnit); //find unit
	kbUnitQuerySetState(ownTradePost, cUnitStateAlive); //set state
	for (i = 0; < kbUnitQueryExecute(ownTradePost))
	{ //Loop through all the own Tradingpost
		//socketID = kbUnitQueryGetResult(ownTradePost, i); //get id of TP
		if (kbUnitGetPosition(kbUnitQueryGetResult(ownTradePost, i)) == cInvalidVector) continue; //check if location is a valid location, may be not be needed
		for (j = 0; < xsArrayGetSize(tradeRoot1))
		{ //Loop through tradeRoot1 Array
			if (xsArrayGetInt(tradeRoot1, j) == -1 || kbUnitGetPosition(xsArrayGetInt(tradeRoot1, j)) == cInvalidVector) continue; //check for invaild ID and location of tradeRoot1
			if (distance(kbUnitGetPosition(xsArrayGetInt(tradeRoot1, j)), kbUnitGetPosition(kbUnitQueryGetResult(ownTradePost, i))) < 10)
			{ //Check if the location from the owned TP socket is in about the same location as the tradeRoot1 socket 	
				if (getUnitByLocation(cUnitTypeMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, kbUnitGetPosition(xsArrayGetInt(tradeRoot1, j)), 20.0) > 3) continue; //Check to see if the Tradepost is safe to upgrade from
				siteLocation1 = kbUnitGetPosition(xsArrayGetInt(tradeRoot1, j)); //set site 1 upgrade location
				break; //found upgrade site, exit (NOTE: more logic could be added to check if this site is safe from enemy) 
			} //end if 
		} //end for j
		for (j = 0; < xsArrayGetSize(tradeRoot2))
		{ //Loop through tradeRoot2 Array
			if (xsArrayGetInt(tradeRoot2, j) == -1 || kbUnitGetPosition(xsArrayGetInt(tradeRoot2, j)) == cInvalidVector) continue;
			if (distance(kbUnitGetPosition(xsArrayGetInt(tradeRoot2, j)), kbUnitGetPosition(kbUnitQueryGetResult(ownTradePost, i))) < 10)
			{ //Check if the location from the owned TP socket is in about the same location as the tradeRoot2 socket 
				if (getUnitByLocation(cUnitTypeMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, kbUnitGetPosition(xsArrayGetInt(tradeRoot1, j)), 20.0) > 3) continue; //Check to see if the Tradepost is safe to upgrade from
				siteLocation2 = kbUnitGetPosition(xsArrayGetInt(tradeRoot2, j)); //set site 2 upgrade location
				break; //found upgrade site, exit (NOTE: more logic could be added to check if this site is safe from enemy) 
			} //end if
		} //end for
	} //end for
	for (i = 0; < 2)
	{ //Begin the tradingpost update check
		if (i == 0) siteLocation = siteLocation1; //0 is for root 1
		if (i == 1) siteLocation = siteLocation2; //1 is for root 2
		if (siteLocation != cInvalidVector)
		{ //check if a valid site location has been found
			if (i == 0 && disableRoot1 == true) continue; //Check if root 1 has been disabled
			if (i == 1 && disableRoot2 == true) continue; //Check if root 2 has been disabled
			if (i == 0)
			{ //root 1
				tradeRouteUpgradeTechID = upgradeTechRoot1; //set the tech  
				upgradeTechRoot1 = techUpgradeType2; //update the tech to research
				upgradeCountRoot1++; //update root1 upgrade count
			} //end if
			if (i == 1)
			{ //root 2
				tradeRouteUpgradeTechID = upgradeTechRoot2; //set the tech 
				upgradeTechRoot2 = techUpgradeType2; //update the tech to research
				upgradeCountRoot2++; //update root2 upgrade count
			} //end if
			if (tradeRouteUpgradeTechID == techUpgradeType1 && gCurrentAge < cAge2) continue; //If the ai is in age 1, do not upgrade to stagecoach
			if (tradeRouteUpgradeTechID == techUpgradeType2 && gCurrentAge < cAge4) continue; //If the ai is not in age 4, do not upgrade to iron horse
			tradeRouteUpgradeUnitID = getUnitByLocation(cUnitTypeVictoryPointBuilding, cMyID, cUnitStateAlive, siteLocation, 10.0); //get the unit id of the tradepost at the site location   
			
			if (i == 0)
			{ //root 1
				tradeRouteUpgradePlan1ID = aiPlanCreate("Trade Route Upgrade Plan", cPlanResearch); //set root1 plan id
				tradeRouteUpgradePlanID = tradeRouteUpgradePlan1ID; //set plan
			} //end if
			if (i == 1)
			{ //root 2
				tradeRouteUpgradePlan2ID = aiPlanCreate("Trade Route Upgrade Plan", cPlanResearch); //set root2 plan id
				tradeRouteUpgradePlanID = tradeRouteUpgradePlan2ID; //set plan
			} //end if
			aiPlanSetDesiredPriority(tradeRouteUpgradePlanID, 100); //set Priority
			aiPlanSetEscrowID(tradeRouteUpgradePlanID, cEmergencyEscrowID); //set Escrow ID
			aiPlanSetVariableInt(tradeRouteUpgradePlanID, cResearchPlanBuildingTypeID, 0, kbUnitGetProtoUnitID(tradeRouteUpgradeUnitID)); //add building type to plan
			aiPlanSetVariableInt(tradeRouteUpgradePlanID, cResearchPlanBuildingID, 0, tradeRouteUpgradeUnitID); //add build ID to plan
			aiPlanSetVariableInt(tradeRouteUpgradePlanID, cResearchPlanTechID, 0, tradeRouteUpgradeTechID); //add Tech id to plan
			aiPlanSetActive(tradeRouteUpgradePlanID, true); //start plan  
			if (upgradeCountRoot1 == 2) disableRoot1 = true; //disable root 1 upgrades
			if (upgradeCountRoot2 == 2) disableRoot2 = true; //disable root 2 upgrades
		} //end if
	} //end for i
	if (disableRoot1 == true && disableRoot2 == true)
	{
		xsDisableSelf();
	}
} //end tradeRouteUpgradeMonitor	

//rule ransomExplorerMonitor
//inactive
//minInterval 60
void ransomExplorerMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 30000,"ransomExplorerMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	// Disable rule for native or Asian civs
	if (getCivIsNative() == true)
	{
		//xsDisableSelf();
		return;
	}

	// Use only in Age 2 and above
	if ((gCurrentAge < cAge2) || (aiGetFallenExplorerID() < 0))
	{
		return;
	}
	else
	if (aiGetFallenExplorerID() >= 0)
	{
		aiTaskUnitTrain(getUnit(gTownCenter), kbUnitGetProtoUnitID(aiGetFallenExplorerID()));
	}
}
//rule warPartiesMonitor
//inactive
//group tcComplete
//minInterval 10
void warPartiesMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"warPartiesMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	// Check to see if town is being overrun. If so, generate a plan
	// to research available war party. 

	// Disable rule for non-native civs
	if (getCivIsNative() == false)
	{
		//xsDisableSelf();
		return;
	}

	static int partyPlan = -1;
	vector mainBaseVec = cInvalidVector;

	mainBaseVec = gMainBaseLocation;
	int enemyCount = getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, mainBaseVec, 40.0);
	int allyCount = getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationAlly, cUnitStateAlive, mainBaseVec, 40.0);

	if (enemyCount >= (allyCount + 6)) // We're behind by 6 or more
	{
		//aiEcho("***** Starting a party plan, there are "+enemyCount+" enemy units in my base against "+allyCount+" friendlies.");
		if (cMyCiv == cCivXPAztec)
		{
			if (kbTechGetStatus(cTechBigAztecScoutingParty) == cTechStatusObtainable)
				partyPlan = createSimpleResearchPlan(cTechBigAztecScoutingParty, getUnitByLocation(gTownCenter, cMyID, cUnitStateAlive, mainBaseVec, 40.0), cMilitaryEscrowID, 99); // Extreme priority
			else if (kbTechGetStatus(cTechBigAztecRaidingParty) == cTechStatusObtainable)
				partyPlan = createSimpleResearchPlan(cTechBigAztecRaidingParty, getUnitByLocation(gTownCenter, cMyID, cUnitStateAlive, mainBaseVec, 40.0), cMilitaryEscrowID, 99); // Extreme priority
			else if (kbTechGetStatus(cTechBigAztecWarParty) == cTechStatusObtainable)
				partyPlan = createSimpleResearchPlan(cTechBigAztecWarParty, getUnitByLocation(gTownCenter, cMyID, cUnitStateAlive, mainBaseVec, 40.0), cMilitaryEscrowID, 99); // Extreme priority
		}
		else if (cMyCiv == cCivXPIroquois)
		{
			if (kbTechGetStatus(cTechBigIroquoisScoutingParty) == cTechStatusObtainable)
				partyPlan = createSimpleResearchPlan(cTechBigIroquoisScoutingParty, getUnitByLocation(gTownCenter, cMyID, cUnitStateAlive, mainBaseVec, 40.0), cMilitaryEscrowID, 99); // Extreme priority
			else if (kbTechGetStatus(cTechBigIroquoisRaidingParty) == cTechStatusObtainable)
				partyPlan = createSimpleResearchPlan(cTechBigIroquoisRaidingParty, getUnitByLocation(gTownCenter, cMyID, cUnitStateAlive, mainBaseVec, 40.0), cMilitaryEscrowID, 99); // Extreme priority
			else if (kbTechGetStatus(cTechBigIroquoisWarParty) == cTechStatusObtainable)
				partyPlan = createSimpleResearchPlan(cTechBigIroquoisWarParty, getUnitByLocation(gTownCenter, cMyID, cUnitStateAlive, mainBaseVec, 40.0), cMilitaryEscrowID, 99); // Extreme priority
		}
		else // cMyCiv == cCivXPSioux
		{
			if (gCurrentGameTime > 20 * 60 * 1000) // Use only after at least 20 minutes of game time (i.e. 7 units)
				partyPlan = createSimpleResearchPlan(cTechBigSiouxDogSoldiers, getUnitByLocation(gTownCenter, cMyID, cUnitStateAlive, mainBaseVec, 40.0), cMilitaryEscrowID, 99); // Extreme priority
		}
	}
}
//==============================================================================
/*
 balloonMonitor
 updatedOn 2022/07/07
 sends balloons out to explore
 
 How to use
 is autocalled in mainrules
*/
//==============================================================================
void balloonMonitor()
{
	if(cvOkToExplore == false) return;
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 5000,"balloonMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	int balloonType = -1;
	int balloonId = -1;
	balloonId = getUnit(cUnitTypeHotAirBalloon, cMyID, cUnitStateAlive);
	if(balloonId != -1) 
	{
		balloonType = cUnitTypeHotAirBalloon;
	}
	else
	{
		balloonId = getUnit(cUnitTypexpAdvancedBalloon, cMyID, cUnitStateAlive);
		if(balloonId != -1) balloonType = cUnitTypexpAdvancedBalloon;	
	}
	if(balloonType == -1 || kbUnitGetActionType(balloonId) != 7)return;
	// Create explore plan
	int balloonExplore = aiPlanCreate("Balloon Explore", cPlanExplore);
	aiPlanSetDesiredPriority(balloonExplore, 100);
	aiPlanAddUnitType(balloonExplore, balloonType, 1, 1, 1);
	aiPlanAddUnit(balloonExplore, balloonId);
	aiPlanSetEscrowID(balloonExplore, cEconomyEscrowID);
	aiPlanSetBaseID(balloonExplore, kbBaseGetMainID(cMyID));
	aiPlanSetVariableBool(balloonExplore, cExplorePlanDoLoops, 0, false);
	aiPlanSetActive(balloonExplore);
}

rule delayAttackMonitor
inactive
group tcComplete
minInterval 10
{
	// If this rule is active, it means that gDelayAttacks has been set true,
	// and we're on a diffuclty level where we can't attack until AFTER someone
	// has attacked us, or until we've reached age 4.  

	gDelayAttacks = false;
	if (gWorldDifficulty == cDifficultySandbox)
	{
		gDelayAttacks = true;
		xsDisableSelf();
		return;
	}
	/*
		if(gWorldDifficulty == cDifficultyEasy && gCurrentGameTime < 1800000) gDelayAttacks = true;
		
		if(gCurrentAge < cAge3 && gCurrentGameTime > 1200000)
		{
		gDelayAttacks = true;
		}
		
		if(gCurrentAge < cAge4 && gCurrentGameTime > 2500000)
		{
		gDelayAttacks = true;
		}
		if(gCurrentAge < cAge5 && gCurrentGameTime > 3500000)
		{
		gDelayAttacks = true;
		}
	*/

	/*
		if (gCurrentAge >= cAge4)
		{
		if ( (gDelayAttacks == true) && (gWorldDifficulty >= cDifficultyEasy) )
		{
		aiEcho(" ");
		aiEcho("    OK, THE GLOVES COME OFF NOW!");
		aiEcho(" ");
		gDelayAttacks = false;
		}
		//  xsDisableSelf();
		return;
		}
	*/
	/*
		// See if we're under attack.
		if (gDefenseReflexBaseID == kbBaseGetMainID(cMyID))
		{  // Main base is under attack
		if ( (gDelayAttacks == true) && (gWorldDifficulty >= cDifficultyEasy) )
		{
		aiEcho(" ");
		aiEcho("    OK, THE GLOVES COME OFF NOW!");
		aiEcho(" ");
		gDelayAttacks = false;
		}
		// xsDisableSelf();  // If sandbox, just turn off.
		}
	*/

}

//==============================================================================
/* rule fortMonitor
	updatedOn 2019/08/20 By ageekhere  
*/
//==============================================================================
//rule fortMonitor
//active
//minInterval 10
void fortMonitor()
{ //sends the fort Wagon to build a new fort
	return;
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"fortMonitor") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	//if (kbUnitCount(cMyID, cUnitTypeFortWagon, cUnitStateAlive) == 0) return; //Check for alive Fort Wagons	
	//if (kbUnitCount(cMyID, cUnitTypeFortFrontier, cUnitStateAlive) == 0) return; //Check for alive FortFrontier, Not ABQ, in case the existing wagon is used by plan	
	if(getWagonBuildCheck(cUnitTypeFortFrontier, cUnitTypeFortWagon) == false )return;
	//if (kbUnitCount(cMyID, cUnitTypeFortFrontier, cUnitStateABQ) >= kbGetBuildLimit(cMyID, cUnitTypeFortFrontier)) return; //Check if the number of Fort Frontiers is under build limit	
	//if (checkBuildingPlan(cUnitTypeFortFrontier) >= 0) return; //Check if there is already a plan	
	int fort_plan = -1; //2nd fort plan
	
	if(kbUnitCount(cMyID, cUnitTypeFortWagon, cUnitStateAlive) > 0 && kbUnitGetActionType(getUnit(cUnitTypeFortWagon, cMyID, cUnitStateAlive)) == 7) 
	{
		//if (gForwardBaseState != gForwardBaseStateActive) return; //Check if the current foward base state is not active
		createLocationBuildPlan(cUnitTypeFortFrontier, 1, 100, false, cRootEscrowID, gMainBaseLocation, 1 ,-1); //build in base
		aiPlanAddUnitType(fort_plan, cUnitTypeFortWagon, 1, 1, 1); //Add unit to plan
	}
	else if(gNationalRedoubtEnabled == true)
	{
		if(kbUnitCount(cMyID, cUnitTypeStrelet, cUnitStateAlive) > 0) 
		{
			createLocationBuildPlan(cUnitTypeFortFrontier, 1, 100, false, cRootEscrowID, gMainBaseLocation, 1,-1); //build in base
		}
	}

	/*
		Note: The ai can only send 1 FortWagon at a time to build a fort, an issue can happen while a fort is being built the ai will try and send the second FortWagon to the same location as the first FortWagon.
		However once the first fort is built the next FortWagon will go to a new location. Some time can be lost here.
	*/
	//aiPlanSetEventHandler(fort_plan, cPlanEventStateChange, "fort_2_state"); //disabled
} //end fortMonitor
//==============================================================================
/*
idleSettlerMonitor	
updatedOn 2022/02/12 By ageekhere
Finds all setters which are idle and holds them in an array so they can be reallocated to resources 
Also can make it so all player settlers can be reallocated 
*/
//==============================================================================
void idleSettlerMonitor(void)
{
	//debugRule("void idleSettlerMonitor",0);
	static int pIdleArrayCount = -1; //Counts the number 
	static int lastRunTime = 0;
	static int pSettlerTarget = -1;
	static int pSettlerID = -1;
	static float pDistForResouce = -1.0;
	static int pUnitNum = 0;
	static int pUnitId = 0;
	static float pUnitTargetDist = -1.0;
	static bool pSkipSettler = false;
	static int pExcludeSettlerId = -1;
	pIdleArrayCount = 0; //counts the added settlers

	if(functionDelay(lastRunTime, 300000,"idleSettlerMonitor - reallocateSettlers") || lastRunTime == 0)
	{ //run the reset rule
		//debugRule("void idleSettlerMonitor - reallocate reset",1);
		gReallocateSettlers = true;
		lastRunTime = gCurrentGameTime;
	}
	gCurrentIdleSettlers = getPlayerIdleSettlers();
	//debugRule("void idleSettlerMonitor - gCurrentIdleSettlers " + gCurrentIdleSettlers,0);
	if (gReallocateSettlers)
	{ //reallocate only settlers on wood
		//debugRule("void idleSettlerMonitor - gReallocateSettlers true ",1);
		gReallocateSettlers = false;
		setIntArrayToDefaults(gBlockedResourceArray);
		setIntArrayToDefaults(gExcludeSettlersArray);
		for (i = 0; < gCurrentAliveSettlers )
		{  //loop through all player settlers
			pSettlerID = kbUnitQueryGetResult(getAliveSettlersQuery , i);
			if(pSettlerID == -1) break;
			if(kbUnitIsType(pSettlerID,cUnitTypeGoldMiner)) continue; //skip miner
			if(kbUnitIsType(kbUnitGetTargetUnitID(pSettlerID),cUnitTypeWood) == false) continue; //only reallocate settlers on wood
			if(checkExcludeSettler(pSettlerID)) continue;
			
			for (j = 0; < 200)
			{ //Loop through all excluded settlers
				pExcludeSettlerId = xsArrayGetInt(gExcludeSettlersArray, j);
				if(pExcludeSettlerId == -1) break;			
				xsArraySetInt(gExcludeSettlersArray, j, -1); //un exclude settler because they are idle
				setUnitIdle(pExcludeSettlerId);
			} //end for	
			xsArraySetInt(gIdleArray, pIdleArrayCount, pSettlerID); //add the settler to the idle array
			pIdleArrayCount++;
			setUnitIdle(pSettlerID);
		} //end for
	} //end else if	
	else		
	{ //add idle settler into the idle array
		for (i = 0; < gCurrentIdleSettlers)
		{ //loop through idle settlers
			pSettlerID = kbUnitQueryGetResult(getIdleSettlersQuery , i);
			if(pSettlerID == -1) break;
			if(kbUnitGetActionType(pSettlerID) != 7) continue;
			if(checkExcludeSettler(pSettlerID)) continue;
			pSkipSettler = false;
			pSettlerTarget = kbUnitGetTargetUnitID(pSettlerID);
			if(pSettlerTarget != -1 && kbUnitIsType(pSettlerTarget,cUnitTypeAbstractResourceCrate) == false)
			{
				if(kbUnitGetActionType(pSettlerID) == 3 || kbUnitGetActionType(pSettlerID) == 6 )
				{
					pDistForResouce = 5.0;
					if (pSettlerTarget != -1 && kbUnitIsType(pSettlerTarget,cUnitTypeHuntedResource))
					{ //settler is asigned to a resouce however they are too far away to be able to collect from it so they must be stuck
					  if (kbUnitGetHealth(pSettlerTarget) > 0.0) pDistForResouce = 15.0;
					   pDistForResouce = 15.0;
					}
					else if (pSettlerTarget != -1 && kbUnitIsType(pSettlerTarget,cUnitTypeMinedResource))
					{
						pDistForResouce = 6.0;
					}
					else if (pSettlerTarget != -1 && kbUnitIsType(pSettlerTarget,cUnitTypeAbstractFruit))
					{
						pDistForResouce = 4.4;
					}
					else if (pSettlerTarget != -1 && kbUnitIsType(pSettlerTarget,cUnitTypeBuilding))
					{
						pDistForResouce = 6.0;
					}
					pUnitTargetDist = distance(kbUnitGetPosition(pSettlerID),kbUnitGetPosition(pSettlerTarget));
					if(pUnitTargetDist > pDistForResouce)
					{
						int count = 0;
						for(j = 0; < 1000)
						{
							count++;
							if(xsArrayGetInt(gBlockedResourceArray, j) == pSettlerTarget) break;
							if(xsArrayGetInt(gBlockedResourceArray, j) == -1)
							{
								xsArraySetInt(gBlockedResourceArray, j, pSettlerTarget);
								pSkipSettler = true;
								break;
							}
						}
						setUnitIdle(pSettlerID);
					}
				}
			}
			if(pSkipSettler) continue;
			
			
			for (j = 0; < 200)
			{ //Loop through all excluded settlers
				pExcludeSettlerId = xsArrayGetInt(gExcludeSettlersArray, j);
				if(pExcludeSettlerId == -1) break;				
				if (pSettlerID == pExcludeSettlerId) 
				{ //Check if the excluded settler is idle
					xsArraySetInt(gExcludeSettlersArray, j, -1); //un exclude settler because they are idle
					//pSkipSettler = true;
					break;
				} //end if
			} //end for	
			
			if(pSkipSettler) continue;
			xsArraySetInt(gIdleArray, pIdleArrayCount, pSettlerID); //add the settler to the idle array
			pIdleArrayCount++;
		
		} //end for
	} //end if
	
	for (i = 0; < gCurrentAliveSettlers)
	{
		if(gTreatyActive == false)
		{ //only check if a settler needs to act treaty is false
			pUnitId = getUnitByLocation(cUnitTypeUnitClass, cPlayerRelationEnemyNotGaia, cUnitStateAlive, kbUnitGetPosition(pSettlerID), 10.0); //check for any ememy unit//--------
			if(pUnitId != -1)
			{ //actions to do if there is an enemy unit near by
				pSkipSettler = true; //settler will be skiped
				aiTaskUnitWork(pSettlerID, pUnitId); //attack the unit
				pUnitNum = getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, kbUnitGetPosition(pSettlerID), 10.0); //count enemy land Military
				if(kbUnitGetHealth(pSettlerID) < 0.6 || pUnitNum > 2 ) 
				{ //if the settler has low health or X amount of units are near them
					if(distance(kbUnitGetPosition(pSettlerID), gMainBaseLocation) > 10)
					{
						if(gMainTownCenterLocation != cInvalidVector) 
						{
							aiTaskUnitMove(pSettlerID,gMainTownCenterLocation); //run home
						}
						else if(gMainBaseLocation != cInvalidVector)
						{
							aiTaskUnitMove(pSettlerID,gMainBaseLocation); //run home
						}
						else
						{
							aiTaskUnitMove(pSettlerID,gMapCenter); //run home
						}
					} 
					
				}
			}
		}
	}		
			
	if(pIdleArrayCount > 0) gathererManager(gIdleArray,pIdleArrayCount);	
	//gathererManager(gIdleArray,pIdleArrayCount);	
}



void heroMonitornew()
{

	// use hero to collect cows
		//if more then 1 hero split so both can collect cows
	//if there are nuggets score them and then task to them
	//switch to melay mode when fighting explorers
	//avoid town center


	//gExplorerUnit
	//gExplorerUnit2

	static int pNatHerdQuery = -1;
	static bool pDoneHerd = false;
	static int pHerdNum = -1;
	static int pSelfUnit = -1;
	static int pHerdUnit = -1;
	static int pHerdArray = -1;
	static bool pHerdArrayDone = false;
	
	if(pDoneHerd == false)
	{
		if (pNatHerdQuery == -1) 
		{
			pHerdArray = xsArrayCreateInt(100, -1, "pHerdArray");

			pNatHerdQuery = kbUnitQueryCreate("pNatHerdQuery"+getQueryId());
			kbUnitQuerySetPlayerID(pNatHerdQuery, 0, false);
			kbUnitQuerySetIgnoreKnockedOutUnits(pNatHerdQuery, true);
			kbUnitQuerySetUnitType(pNatHerdQuery, cUnitTypeHerdable);
			kbUnitQuerySetState(pNatHerdQuery, cUnitStateAlive);	
			kbUnitQuerySetAscendingSort(pNatHerdQuery, true);
		}
		kbUnitQuerySetPosition(pNatHerdQuery, gMainBaseLocation);
		kbUnitQueryResetResults(pNatHerdQuery);
		pHerdNum = kbUnitQueryExecute(pNatHerdQuery);
		
		float pLastDist = -1.0;
		vector pLastPost = cInvalidVector;
		int pArrayCount = 0;
		for (j = 0; < pHerdNum)
		{
			pHerdUnit = kbUnitQueryGetResult(pNatHerdQuery, j);
			if(pLastPost == cInvalidVector) 
			{
				pLastPost = kbUnitGetPosition(pHerdUnit);	
				xsArraySetInt(pHerdArray, pArrayCount, pHerdUnit);
				pArrayCount++;
			}
			else if(distance(pLastPost, kbUnitGetPosition(pHerdUnit)) > 10 )
			{
				pLastPost = kbUnitGetPosition(pHerdUnit);	
				xsArraySetInt(pHerdArray, pArrayCount, pHerdUnit);
				pArrayCount++;
			}
		}
		
		int pNextHerd = -1;
		float pDist = 99999;
		if(pHerdNum == 0) pDoneHerd = true;
		else
		{
			int pHerdAtNum = 0;
			for (i = 0; < gNumSelfLandMilitary)
			{ //loop through self land units
				pSelfUnit = kbUnitQueryGetResult(gSelfLandMilitaryQry, i); //get self land unit
				if (kbUnitGetActionType(pSelfUnit) != 7) continue;
				
				int pCount = 0;
				while(true)
				{
					//pHerdUnit = xsArrayGetInt(pHerdArray,pCount);
					pHerdUnit = kbUnitQueryGetResult(pNatHerdQuery, pCount);
					if(pHerdUnit == -1) break;
					if(pCount == 0 || distance(kbUnitGetPosition(kbUnitQueryGetResult(pNatHerdQuery, pCount)), 
					kbUnitGetPosition(kbUnitQueryGetResult(pNatHerdQuery, (pCount -1)))) > 10 )
					{
						pNextHerd = pHerdUnit;
						pHerdAtNum++;
						break;
					}
					pCount++;
				}
				aiTaskUnitMove(pSelfUnit, kbUnitGetPosition(pNextHerd));	
			}
		}
		
	}
	
	
}


void heroMonitor()
{
	//heroMonitornew();
	//return;
	static int meleeModeTimer = 0;
	static int heroFind = -1;
	static int enemyHP = -1;

	if (heroFind == -1) heroFind = kbUnitQueryCreate("heroFind"+getQueryId());
	kbUnitQueryResetResults(heroFind);
	kbUnitQuerySetPlayerID(heroFind, cMyID, false);
	kbUnitQuerySetIgnoreKnockedOutUnits(heroFind, true);
	kbUnitQuerySetUnitType(heroFind, cUnitTypeHero);
	kbUnitQuerySetState(heroFind, cUnitStateAlive);
	
	static int heroEnenmyFind = -1;
	if (heroEnenmyFind == -1) heroEnenmyFind = kbUnitQueryCreate("heroEnenmyFind"+getQueryId());
	kbUnitQueryResetResults(heroEnenmyFind);
	kbUnitQuerySetPlayerRelation(heroEnenmyFind, cPlayerRelationEnemyNotGaia);
	kbUnitQuerySetIgnoreKnockedOutUnits(heroEnenmyFind, true);
	kbUnitQuerySetUnitType(heroEnenmyFind, cUnitTypeHero);
	kbUnitQuerySetState(heroEnenmyFind, cUnitStateAlive);
	
	static int enemyTC = -1;
	if (enemyTC == -1) enemyTC = kbUnitQueryCreate("enemyTC"+getQueryId());
	kbUnitQueryResetResults(enemyTC);
	kbUnitQuerySetPlayerRelation(enemyTC, cPlayerRelationEnemyNotGaia);
	kbUnitQuerySetUnitType(enemyTC, gTownCenter);
	kbUnitQuerySetState(enemyTC, cUnitStateAlive);
	
	int timePass = gCurrentGameTime - meleeModeTimer;
	static int heroAttack = 0;
	for (i = 0; < kbUnitQueryExecute(heroFind))
	{
		if (gCurrentAge < cAge3)
		{
			for (j = 0; < kbUnitQueryExecute(heroEnenmyFind))
			{
				if (timePass > 30000)
				{
					if (kbUnitGetHealth(kbUnitQueryGetResult(heroEnenmyFind, j)) < enemyHP && aiUnitGetTactic(kbUnitQueryGetResult(heroFind, i)) == cTacticMelee)
					{
						aiUnitSetTactic(kbUnitQueryGetResult(heroFind, i), cTacticVolley);
						cvOkToExplore = true;
						cvOkToGatherNuggets = true;
					}
				}
				if (kbUnitGetHealth(kbUnitQueryGetResult(heroFind, i)) > kbUnitGetHealth(kbUnitQueryGetResult(heroEnenmyFind, j)) &&
					distance(kbUnitGetPosition(kbUnitQueryGetResult(heroFind, i)), kbUnitGetPosition(kbUnitQueryGetResult(heroEnenmyFind, j))) < 20) //&& timePass > 60000 && meleeModeOn == false && (gCurrentGameTime - meleeModeTimer) > 60000 )
				{
					if (aiUnitGetTactic(kbUnitQueryGetResult(heroFind, i)) != cTacticMelee)
					{
						meleeModeTimer = gCurrentGameTime;
						enemyHP = kbUnitGetHealth(kbUnitQueryGetResult(heroEnenmyFind, j));
						aiUnitSetTactic(kbUnitQueryGetResult(heroFind, i), cTacticMelee);
					}
					aiPlanDestroy(kbUnitGetPlanID(kbUnitQueryGetResult(heroFind, i)));
					aiTaskUnitWork(kbUnitGetHealth(kbUnitQueryGetResult(heroFind, i)), kbUnitGetHealth(kbUnitQueryGetResult(heroEnenmyFind, i)));
					heroAttack = kbUnitQueryGetResult(heroEnenmyFind, i);
					cvOkToExplore = false;
					cvOkToGatherNuggets = false;
					return;

				}
			}
		}
		if (aiUnitGetTactic(kbUnitQueryGetResult(heroFind, i)) == cTacticMelee)
		{
			aiUnitSetTactic(kbUnitQueryGetResult(heroFind, i), cTacticVolley);
		}

		if ((kbUnitGetHealth(kbUnitQueryGetResult(heroFind, i)) > 0.4 || distance(kbUnitGetPosition(kbUnitQueryGetResult(heroFind, i)), gMainBaseLocation) < 15) && cvOkToExplore == false)
		{
			cvOkToExplore = true;
			cvOkToGatherNuggets = true;
			aiUnitSetTactic(kbUnitQueryGetResult(heroFind, i), cTacticVolley);
		}

		if (kbUnitGetHealth(kbUnitQueryGetResult(heroFind, i)) < 0.4 &&
			distance(kbUnitGetPosition(kbUnitQueryGetResult(heroFind, i)), gMainBaseLocation) > 3 &&
			(kbUnitGetActionType(kbUnitQueryGetResult(heroFind, i)) == 15 || kbUnitGetActionType(kbUnitQueryGetResult(heroFind, i)) == 67) &&
			kbUnitGetActionType(kbUnitQueryGetResult(heroFind, i)) != 31)
		{
			cvOkToExplore = false;
			cvOkToGatherNuggets = false;
			aiPlanDestroy(kbUnitGetPlanID(kbUnitQueryGetResult(heroFind, i)));
			aiTaskUnitMove(kbUnitQueryGetResult(heroFind, i), kbUnitGetPosition(getUnit(gTownCenter, cMyID, cUnitStateAlive)));
			aiUnitSetTactic(kbUnitQueryGetResult(heroFind, i), cTacticVolley);
			return;
		}

		for (j = 0; < kbUnitQueryExecute(enemyTC))
		{
			if (distance(kbUnitGetPosition(kbUnitQueryGetResult(heroFind, i)), kbUnitGetPosition(kbUnitQueryGetResult(enemyTC, j))) < 30 &&
				kbUnitGetActionType(kbUnitQueryGetResult(heroFind, i)) != 31)
			{
				cvOkToExplore = false;
				cvOkToGatherNuggets = false;
				aiPlanDestroy(kbUnitGetPlanID(kbUnitQueryGetResult(heroFind, i)));
				aiTaskUnitMove(kbUnitQueryGetResult(heroFind, i), gMainBaseLocation); //
				aiUnitSetTactic(kbUnitQueryGetResult(heroFind, i), cTacticVolley);
				return;
			}
		}
	}
}

//==============================================================================
/*
bringInhuntMonitor	
updatedOn 2022/02/02 By ageekhere
A method for using settlers to herd huntables towards their town center
*/
//==============================================================================
rule bringInhuntMonitor
active
minInterval 1
//void bringInhuntMonitor()
{
	if (getCivHuntAbility() == false || gCurrentAge > cAge2) 
	{ //Check if ai civ is able to hunt
		//return; 
	}
	static int settlerHerderQuery = -1; //query for adding settlers to bring in hunts
	int numberOfHunters = 1; //number of settlers to use for bringing in hunts, currenly only 1 works correctly
	int playercount = 0;
	for (t = 1; < cNumberPlayers)
	{ //loop through players
		if (gPlayerTeam == kbGetPlayerTeam(t) && (t != cMyID))
		{ //That are on my team and is not me
			playercount = playercount + 1;
		}
	}
	/*
	switch (playercount)
	{
		case 2:
			{
				if (gCurrentAge == cAge1) numberOfHunters = 1;
				if (gCurrentAge == cAge2) numberOfHunters = 4;
				if (gCurrentAge > cAge2) numberOfHunters = 1;
				break;
			}
		case 3:
			{
				if (gCurrentAge == cAge1) numberOfHunters = 1;
				if (gCurrentAge == cAge2) numberOfHunters = 3;
				if (gCurrentAge > cAge2) numberOfHunters = 1;
				break;
			}
		case 4:
			{
				if (gCurrentAge == cAge1) numberOfHunters = 1;
				if (gCurrentAge == cAge2) numberOfHunters = 2;
				if (gCurrentAge > cAge2) numberOfHunters = 1;
				break;
			}
		default:
			{
				if (gCurrentAge == cAge1) numberOfHunters = 1;
				if (gCurrentAge == cAge2) numberOfHunters = 1;
				if (gCurrentAge > cAge2) numberOfHunters = 1;
			}
	}
	*/
	//NOTE hard coded to 1 for now
	/*
	the issue with having more than 1 is that multiple settlers will move to the same location and herd the same hunts
	untill a way is found to stop this 1 settler will be used
	*/
	
	bool settlerExcluded = false; //a check to see if a settler has been excluded
	//Send a settler to bring in a hunt
	for (i = 0; < xsArrayGetSize(gBringInHuntSettlers))
	{ //loop through all settlers that have been assigned to bring in hunts 
		if (xsArrayGetInt(gBringInHuntSettlers, i) == -1) continue; //skip -1 values
		if (kbUnitGetHealth(xsArrayGetInt(gBringInHuntSettlers, i)) <= 0.0)
		{ //check if the settler is dead, if so, remove it from the brin in hunt array
			xsArraySetInt(gBringInHuntSettlers, i, -1); //remove the settler
			xsArraySetInt(gBringInHuntSettlerTime, i, 0); //reset the timer slot
			xsArraySetVector(gBringInHuntSettlerTarget, i, cInvalidVector); //reset the target
			continue;
		} //end if

		if (numberOfHunters > 0)
		{ //send a settler to go and bring in a hunt
			if(kbUnitGetActionType(xsArrayGetInt(gBringInHuntSettlers, i)) != 9 && kbUnitGetActionType(xsArrayGetInt(gBringInHuntSettlers, i)) != 7) 
			{
				//setUnitIdle(xsArrayGetInt(gBringInHuntSettlers, i));
				
				int pResourceId = getNearestUnitByLocation(cUnitTypeTree, cPlayerRelationAny, cUnitStateAlive, kbUnitGetPosition(xsArrayGetInt(gBringInHuntSettlers, i)), 15.0);
				if(pResourceId != -1 && kbUnitIsType(kbUnitGetTargetUnitID(xsArrayGetInt(gBringInHuntSettlers, i)), cUnitTypeWood) == false)
				{
					aiTaskUnitWork(xsArrayGetInt(gBringInHuntSettlers, i), pResourceId);
				}
				else if(kbUnitIsType(kbUnitGetTargetUnitID(xsArrayGetInt(gBringInHuntSettlers, i)), cUnitTypeWood) == false)
				{
					setUnitIdle(xsArrayGetInt(gBringInHuntSettlers, i));
				}
				

			}
			bringInhuntManager(xsArrayGetInt(gBringInHuntSettlers, i),
				xsArrayGetInt(gBringInHuntSettlerTime, i),
				i,
				xsArrayGetVector(gBringInHuntSettlerTarget, i));
			numberOfHunters = numberOfHunters - 1;
		} //end if
		else
		{
			break;
		}
	} //end for i
	for (i = 0; < numberOfHunters)
	{ //add a new settler if under the limit
		if (settlerHerderQuery == -1) settlerHerderQuery = kbUnitQueryCreate("settlerHerderQuery"+getQueryId());
		kbUnitQueryResetResults(settlerHerderQuery);
		kbUnitQuerySetPlayerID(settlerHerderQuery, cMyID, false);
		kbUnitQuerySetUnitType(settlerHerderQuery, gEconUnit);
		kbUnitQuerySetState(settlerHerderQuery, cUnitStateAlive);
		kbUnitQuerySetPosition(settlerHerderQuery, gMainTownCenterLocation);
		kbUnitQuerySetAscendingSort(settlerHerderQuery, true);
		kbUnitQuerySetMaximumDistance(settlerHerderQuery, 400);
		
		for (j = 0; < kbUnitQueryExecute(settlerHerderQuery))
		{ //loop through the settler query
			if (kbUnitGetActionType(kbUnitQueryGetResult(settlerHerderQuery, j)) == 0) continue; //if settler is building, skip
			settlerExcluded = false; //set flag
			for (k = 0; < xsArrayGetSize(gBringInHuntSettlers))
			{ //loop through all setters in the bing in hunt array
				if (xsArrayGetInt(gBringInHuntSettlers, k) == -1) continue; //skip -1 value
				if (kbUnitQueryGetResult(settlerHerderQuery, j) == xsArrayGetInt(gBringInHuntSettlers, k))
				{ //check if a match is found
					settlerExcluded = true; //found in exclude
					break;
				} //end if
			} //end for

			if (settlerExcluded == false)
			{ //if no match
				for (k = 0; < xsArrayGetSize(gBringInHuntSettlers))
				{ //loop through the bring in hunt array
					if (xsArrayGetInt(gBringInHuntSettlers, k) == -1)
					{ //Find a free spot
						xsArraySetInt(gBringInHuntSettlers, k, kbUnitQueryGetResult(settlerHerderQuery, j)); //add the settler
						break;
					} //end if
				} //end for k
				
				if(checkExcludeSettler(kbUnitQueryGetResult(settlerHerderQuery, j)) == false)
				{
					addExcludeSettler(kbUnitQueryGetResult(settlerHerderQuery, j));
				}
				
				/*
				for (l = 0; < xsArrayGetSize(gExcludeSettlersArray))
				{ // add settler to the exclude array
					if (xsArrayGetInt(gExcludeSettlersArray, l) == -1)
					{ //find a free spot
						xsArraySetInt(gExcludeSettlersArray, l, kbUnitQueryGetResult(settlerHerderQuery, j));
						break;
					} //end if
				} //end for l
				*/
				break;
			} //end if
		} //end for j
	} //end for i
} //end bringInhuntMonitor

void destroyBuildPlanMonitor()
{
	static int pActiveBuildPlans = -1;
	pActiveBuildPlans = aiPlanGetNumber(cPlanBuild, -1, true);
	static int pPlanId = -1;
	static int pTimeMade = -1;
	for (i = 0; < pActiveBuildPlans)
	{ //loop through all build plans
		pPlanId = aiPlanGetIDByIndex(cPlanBuild, -1, true, i);
		if(aiPlanGetState(pPlanId) != cPlanStateBuild) 
		{
			pTimeMade = aiPlanGetUserVariableInt(pPlanId, 0, 0);
			if(gCurrentGameTime - pTimeMade > 300000) aiPlanDestroy(pPlanId);				
		}
	}	
}

void orphanBuildMonitor()
{
	static int pQryOrphan = -1;
	static int pQryResutls = -1;
	static int pBuildingId = -1;
	static int pSettlerId = -1;	
	static bool pSkipBuilding = false;

	static int pWagonQry = -1;
	static int pWagonCount = -1;
	static int pWagonId = -1;
	static int lastRunTime = 0;
	if(pQryOrphan == -1) 
	{
		pQryOrphan = kbUnitQueryCreate("orphanBuildMonitor"+getQueryId());
		kbUnitQueryResetResults(pQryOrphan);
		kbUnitQuerySetPlayerID(pQryOrphan, cMyID, false);
		kbUnitQuerySetUnitType(pQryOrphan, cUnitTypeBuilding);
		kbUnitQuerySetState(pQryOrphan, cUnitStateBuilding);
	}
	kbUnitQueryResetResults(pQryOrphan);
	pQryResutls = kbUnitQueryExecute(pQryOrphan);
	for(i = 0; < pQryResutls)
	{

		pSkipBuilding = false;
		pBuildingId = kbUnitQueryGetResult(pQryOrphan, i);
	
		for(j = 0; < xsArrayGetSize(gWagonBuildLocation))
		{
			if(xsArrayGetVector(gWagonBuildLocation,j) == kbUnitGetPosition(pBuildingId))
			{
				if(functionDelay(lastRunTime, 10000,"orphanBuildMonitor") == false) return;
				lastRunTime = gCurrentGameTime;

					if (kbUnitCount(cMyID, cUnitTypeAbstractWagon, cUnitStateAlive) > 0)
					{
						if (pWagonQry == -1)
						{			
							pWagonQry = kbUnitQueryCreate("pWagonQry"+getQueryId());
							kbUnitQuerySetPlayerID(pWagonQry,cMyID,false);
							kbUnitQuerySetPlayerRelation(pWagonQry, -1);
							kbUnitQuerySetUnitType(pWagonQry, cUnitTypeAbstractWagon);
							kbUnitQuerySetIgnoreKnockedOutUnits(pWagonQry, true);
							kbUnitQuerySetActionType(pWagonQry, 7);
							kbUnitQuerySetState(pWagonQry, cUnitStateAlive);
						}
						kbUnitQueryResetResults(pWagonQry);
						pWagonCount = kbUnitQueryExecute(pWagonQry);
						for(k = 0; < pWagonCount)
						{
							
							pWagonId = kbUnitQueryGetResult(pWagonQry, k);
							if(kbUnitGetActionType(pWagonId) == 7 && kbUnitGetPlanID(pWagonId) == -1 && aiQVGet("" + kbUnitGetPosition(pBuildingId) + "loc") == 0)
							{
								aiTaskUnitWork(pWagonId, pBuildingId);
								break;
							}
						}

					}

				pSkipBuilding = true;
				break;
			}
		}
		if(pSkipBuilding) continue;
		if (kbUnitIsType(pBuildingId, cUnitTypeFortFrontier) || kbUnitIsType(pBuildingId, cUnitTypeFactory)) continue;
		if (kbUnitIsType(pBuildingId, gTowerUnit) && kbUnitCount(cMyID, cUnitTypeOutpostWagon, cUnitStateAlive) > 0 ) continue;
		if (kbUnitIsType(pBuildingId, cUnitTypeLumberCamp) && kbUnitCount(cMyID, cUnitTypeLumberWagon, cUnitStateAlive) > 0 ) continue;
		
/*
		if (kbUnitIsType(pBuildingId, cUnitTypeLumberCamp))
		{
			// if(kbUnitCount(cMyID, cUnitTypeLumberWagon, cUnitStateAlive) > 0 )
			// {
			//	aiTaskUnitWork( getUnit(cUnitTypeLumberWagon, cMyID, cUnitStateAlive), pBuildingId);
			// }
			 if(kbUnitCount(cMyID, cUnitTypeLumberWagon, cUnitStateAlive) == 0 && kbUnitGetCurrentHitpoints(pBuildingId) == 0)
			 {
				aiTaskUnitDelete(pBuildingId);
			 }
			 continue;
		} 
*/

		//NOTE checkResourceAssignment is not counting wagons 

		if(checkResourceAssignment(pBuildingId, 0) == false && aiQVGet("" + kbUnitGetPosition(pBuildingId) + "loc") == 0)
		{
			bool pPass = true;
			if(kbUnitCount(cMyID, cUnitTypeAbstractWagon, cUnitStateAlive) > 0)
			{
				for(k = 0; < pWagonCount)
				{
					if(kbUnitGetActionType(kbUnitQueryGetResult(pWagonQry, k)) != 7)
					{
						pPass = false;
						break;
					}
				}
			}
			if(pPass)
			{
				pSettlerId = getNearestSettler(kbUnitGetPosition(pBuildingId));
				//addExcludeSettler(pSettlerId);
				aiTaskUnitWork(pSettlerId, pBuildingId);
			}
		}
	}
	if(kbUnitIsType(pBuildingId, cUnitTypeAbstractWonder) && kbUnitGetNumberWorkersIfSeeable(pBuildingId) < 7 && aiQVGet("" + kbUnitGetPosition(pBuildingId) + "loc") == 0)
	{
		pSettlerId = getNearestSettler(kbUnitGetPosition(pBuildingId));
		//addExcludeSettler(pSettlerId);
		aiTaskUnitWork(pSettlerId, pBuildingId);
	}

	for(j = 0; < xsArrayGetSize(gWagonBuildLocationId))
	{
		if(xsArrayGetInt(gWagonBuildLocationId,j) == -1)break;
		if(kbUnitGetActionType(xsArrayGetInt(gWagonBuildLocationId,j)) == -1 )
		{
			xsArraySetInt(gWagonBuildLocationId,j,-1);
			xsArraySetVector(gWagonBuildLocation,j,cInvalidVector);
		}
	}

}

void monitorMain()
{

}
