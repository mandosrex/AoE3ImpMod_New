//specialUnitMoveMethods
			
//==============================================================================
/*
 pfKiteUnit_checkType
 updatedOn 2023/01/25
 Private function of pfKiteUnit, targets a self unit to an enemy unit
 
 How to use
 auto called in kiteUnit
*/
//==============================================================================		
bool pfKiteUnit_checkType(int pEnemyUnit = -1, int pSelfUnit = -1, bool pTargetHit = false, int pSelfType = -1,int pEnemyType = -1,)
{
	if (kbUnitIsType(pEnemyUnit, pEnemyType) == true && kbUnitIsType(pSelfUnit, pSelfType) == true) 
	{ //check for a unit type match up
		aiTaskUnitWork(pSelfUnit, pEnemyUnit);
		pTargetHit = true;
		return(pTargetHit);
	} //end if
	return(pTargetHit);
} //end pfKiteUnit_checkType
//==============================================================================
/*
 pfKiteUnit_unitMove
 updatedOn 2023/01/25
 Finds the location to kite a unit to
 
 How to use
 auto called in kiteUnit
*/
//==============================================================================
vector pfKiteUnit_unitMove(int pSelfUnitId = -1, vector pLocation = cInvalidVector, float pMoveAmount = 0)
{
	static vector pKiteLocation = cInvalidVector;
	static vector pUnitPosition = cInvalidVector;
	static float pXUValue = -1.0;
	static float pXEValue = -1.0;
	static float pZUValue = -1.0;
	static float pZEValue = -1.0;
	static float pXv = -1.0;
	static float pZv = -1.0;
	pUnitPosition = kbUnitGetPosition(pSelfUnitId);
	pXUValue = xsVectorGetX(pUnitPosition);
	pXEValue = xsVectorGetX(pLocation);
	pZUValue = xsVectorGetZ(pUnitPosition);
	pZEValue = xsVectorGetZ(pLocation);
	pXv = (pXUValue - pXEValue) * pMoveAmount;
	pZv = (pZUValue - pZEValue) * pMoveAmount;
	pKiteLocation = xsVectorSetX(pKiteLocation, (pXUValue + pXv));
	pKiteLocation = xsVectorSetZ(pKiteLocation, (pZUValue + pZv));
	return(pKiteLocation);	
}

//==============================================================================
/*
 kiteUnit
 updatedOn 2022/06/23
 
 How to use
*/
//==============================================================================
void kiteUnit()
{
	static int pMaxDistEnemyRangeCannon = 50; //max dist to check for cannons
	static int pMaxDistEnemyRangeInf = 10; //max dist to check for range inf
	static float pInfCannonKiteDist = 0.4; //cannon kite dist
	static float pRangeKiteDist = 2; //range kite dist
	static int pEnemyUnit = -1; //Holds temp enemy unit id
	static int pSelfUnit = -1; //Holds temp our unit id
	static int pMaxTargetDist = 20; //how far away to target units 
	static int pTargetCount = 0; //count number of enemy units that is targeted
	static bool pTargetHit = false; //flag to check if a unit has a target
	static float dist = 0.0; //hold dist
	if (gNumEnemyLandMilitary == 0) return; //Using the globle value from enemyLandMilitaryQry() get num of enemy land units 
	if (gNumSelfLandMilitary == 0) return;  //Using the globle value from selfLandMilitaryQry() get num of self land units 
	
	static int pSelfAssignedUnits = -1;
	static int pSelfMoveUnits = -1;
	pSelfAssignedUnits = 0;
	pSelfMoveUnits = 0;
	//int pLimit = 0;
	for (i = 0; < gNumEnemyLandMilitary)
	{ //loop through all enemy land Military units
		if(pSelfAssignedUnits > gSelfLandMilitaryQry || pSelfMoveUnits > gSelfLandMilitaryQry) break;
		pTargetCount = 0; //reset target count
		pTargetHit = false; //reset unit has target
		pEnemyUnit = kbUnitQueryGetResult(gEnemyLandMilitaryQry, i); //get enemy unit at i
		
		for (j = 0; < gNumSelfLandMilitary)
		{ //loop through self land units
			pSelfUnit = kbUnitQueryGetResult(gSelfLandMilitaryQry, j); //get self land unit
			if (kbUnitGetActionType(pSelfUnit) == 15) continue; //skip if unit is moving
			dist = distance(kbUnitGetPosition(pSelfUnit), kbUnitGetPosition(pEnemyUnit)); //get dist
			if(dist > pMaxTargetDist || dist < pRangeKiteDist)continue; //do not kite in the range
			
			pTargetHit = pfKiteUnit_checkType(pEnemyUnit,pSelfUnit,pTargetHit,cUnitTypeAbstractInfantry,cUnitTypeAbstractInfantry);
			pTargetHit = pfKiteUnit_checkType(pEnemyUnit,pSelfUnit,pTargetHit,cUnitTypeAbstractCavalry,cUnitTypeAbstractRangedInfantry);
			pTargetHit = pfKiteUnit_checkType(pEnemyUnit,pSelfUnit,pTargetHit,cUnitTypeAbstractCavalry,cUnitTypeAbstractCavalry);
			pTargetHit = pfKiteUnit_checkType(pEnemyUnit,pSelfUnit,pTargetHit,cUnitTypeAbstractHandInfantry,cUnitTypeAbstractRangedInfantry);
			pTargetHit = pfKiteUnit_checkType(pEnemyUnit,pSelfUnit,pTargetHit,cUnitTypeAbstractHandInfantry,cUnitTypeAbstractCavalry);
			pTargetHit = pfKiteUnit_checkType(pEnemyUnit,pSelfUnit,pTargetHit,cUnitTypeAbstractHandCavalry,cUnitTypeAbstractRangedCavalry);
			pTargetHit = pfKiteUnit_checkType(pEnemyUnit,pSelfUnit,pTargetHit,cUnitTypeAbstractArtillery,cUnitTypeAbstractInfantry);
			pTargetHit = pfKiteUnit_checkType(pEnemyUnit,pSelfUnit,pTargetHit,cUnitTypeAbstractArtillery,cUnitTypeAbstractCavalry);
			pTargetHit = pfKiteUnit_checkType(pEnemyUnit,pSelfUnit,pTargetHit,cUnitTypeAbstractArtillery,cUnitTypeAbstractArtillery);	
			if (pTargetHit == true) 
			{
				pTargetCount++;
				pSelfAssignedUnits++;
			}
			if (pTargetCount > 5) break;	
		}
		if (kbUnitIsType(pEnemyUnit, cUnitTypeAbstractArtillery) == true && 
		    distance(kbUnitGetPosition(pEnemyUnit), gMainBaseLocation) > 90 )
		{ //Check to see if unit is Artillery
			for (j = 0; < gNumSelfLandMilitary)
			{ //loop through self land units that are near Artillery 
				pSelfUnit = kbUnitQueryGetResult(gSelfLandMilitaryQry, j); //get self unit
				if(distance(kbUnitGetPosition(pSelfUnit), kbUnitGetPosition(pEnemyUnit)) > pMaxDistEnemyRangeCannon )continue;
				if (kbUnitIsType(pSelfUnit, cUnitTypeAbstractInfantry) == true && 
					kbUnitIsType(pSelfUnit, cUnitTypeAbstractArtillery) == false ) 
				{ //unit check
					aiPlanDestroy(pSelfUnit);
					pSelfMoveUnits++;
					aiTaskUnitMove(pSelfUnit, pfKiteUnit_unitMove(pSelfUnit,kbUnitGetPosition(pEnemyUnit),pInfCannonKiteDist));
				} //end if
			} //end if
		} //end if
		
		else if (kbUnitIsType(pEnemyUnit, cUnitTypeRanged) == false &&
				 kbUnitIsType(pEnemyUnit, cUnitTypeAbstractHandCavalry) == false &&
				 kbUnitIsType(pEnemyUnit, cUnitTypeAbstractArtillery) == false)
		{
			for (j = 0; < gNumSelfLandMilitary)
			{	
				pSelfUnit = kbUnitQueryGetResult(gSelfLandMilitaryQry, j);
				if(distance(kbUnitGetPosition(pSelfUnit), kbUnitGetPosition(pEnemyUnit)) > pMaxDistEnemyRangeInf )continue;
				if (kbUnitIsType(pSelfUnit, cUnitTypeRanged) == true) 
				{
					aiPlanDestroy(pSelfUnit);
					pSelfMoveUnits++;
					aiTaskUnitMove(pSelfUnit, pfKiteUnit_unitMove(pSelfUnit,kbUnitGetPosition(pEnemyUnit),pRangeKiteDist));
				} //end if
			} //end for
		} //end else if
	} //end for
} //end kiteUnit

//rule saveBase
//active
//minInterval 60
void saveBase()
{
	static int lastRunTime = 0;
	static int timeRan = 0; //add some extra random time
	if(gCurrentGameTime < lastRunTime + 60000 + timeRan )return;
	lastRunTime = gCurrentGameTime;
	timeRan = aiRandInt(10);
	timeRan = timeRan * 1000;
	
	if (aiTreatyActive() == true) return;

	static int enemy = -1;
	if(enemy == -1)	enemy = kbUnitQueryCreate("enemy"+getQueryId());
	kbUnitQueryResetResults(enemy);
	kbUnitQuerySetPlayerRelation(enemy, cPlayerRelationEnemyNotGaia);
	kbUnitQuerySetUnitType(enemy, cUnitTypeMilitary);
	kbUnitQuerySetPosition(enemy, gMainBaseLocation); //set the location
	kbUnitQuerySetMaximumDistance(enemy, 40);
	kbUnitQuerySetIgnoreKnockedOutUnits(enemy, true);
	kbUnitQuerySetState(enemy, cUnitStateAlive);

	if (kbUnitQueryExecute(enemy) > 40)
	{
		static int militaryHome = -1;
		if (militaryHome == -1) militaryHome = kbUnitQueryCreate("militaryHome"+getQueryId());
		kbUnitQueryResetResults(militaryHome);
		kbUnitQuerySetPlayerID(militaryHome, cMyID, false);
		kbUnitQuerySetUnitType(militaryHome, cUnitTypeMilitary);
		kbUnitQuerySetState(militaryHome, cUnitStateAlive);

		for (j = 0; < kbUnitQueryExecute(militaryHome))
		{
			int militaryHimeId = kbUnitQueryGetResult(militaryHome, j);
			aiTaskUnitMove(militaryHimeId, gMainBaseLocation);
		}

	}
}

void sendRaid(int unitType = -1)
{ //hunt down settlers and explorers 
	if (aiTreatyActive() == true) return;
	vector sendPosition = cInvalidVector;
	//get enemy setters
	static int enemySettler = -1;
	if(enemySettler == -1) enemySettler = kbUnitQueryCreate("enemySettler"+getQueryId()); //
	kbUnitQueryResetResults(enemySettler);
	kbUnitQuerySetPlayerID(enemySettler, aiGetMostHatedPlayerID(), false);
	kbUnitQuerySetUnitType(enemySettler, cUnitTypeAffectedByTownBell);
	kbUnitQuerySetPosition(enemySettler, kbBaseGetLocation(aiGetMostHatedPlayerID(), kbBaseGetMainID(aiGetMostHatedPlayerID())));
	kbUnitQuerySetAscendingSort(enemySettler, true);
	kbUnitQuerySetIgnoreKnockedOutUnits(enemySettler, true);
	kbUnitQuerySetState(enemySettler, cUnitStateAlive);

	static int enemyExplorer = -1;
	if(enemyExplorer == -1) kbUnitQueryCreate("enemyExplorer"+getQueryId());
	kbUnitQueryResetResults(enemyExplorer);
	kbUnitQuerySetPlayerID(enemyExplorer, aiGetMostHatedPlayerID(), false);
	kbUnitQuerySetUnitType(enemyExplorer, gExplorerUnit);
	kbUnitQuerySetPosition(enemyExplorer, kbBaseGetLocation(aiGetMostHatedPlayerID(), kbBaseGetMainID(aiGetMostHatedPlayerID())));
	kbUnitQuerySetAscendingSort(enemyExplorer, true);
	kbUnitQuerySetIgnoreKnockedOutUnits(enemyExplorer, true);
	kbUnitQuerySetState(enemyExplorer, cUnitStateAlive);

	static int enemyAnimalPrey = -1;
	if(enemyAnimalPrey == -1) enemyAnimalPrey = kbUnitQueryCreate("enemyAnimalPrey"+getQueryId());
	kbUnitQueryResetResults(enemyAnimalPrey);
	kbUnitQuerySetPlayerID(enemyAnimalPrey, 0,false);
	kbUnitQuerySetUnitType(enemyAnimalPrey, cUnitTypeAnimalPrey);
	kbUnitQuerySetPosition(enemyAnimalPrey, kbBaseGetLocation(aiGetMostHatedPlayerID(), kbBaseGetMainID(aiGetMostHatedPlayerID())));
	kbUnitQuerySetAscendingSort(enemyAnimalPrey, true);
	kbUnitQuerySetIgnoreKnockedOutUnits(enemyAnimalPrey, true);
	kbUnitQuerySetState(enemyAnimalPrey, cUnitStateAlive);

	static int enemyGold = -1;
	if(enemyGold == -1) enemyGold = kbUnitQueryCreate("enemyGold"+getQueryId());
	kbUnitQueryResetResults(enemyGold);
	kbUnitQuerySetPlayerID(enemyGold, 0,false);
	kbUnitQuerySetUnitType(enemyGold, cUnitTypeAbstractMine);
	kbUnitQuerySetPosition(enemyGold, kbBaseGetLocation(aiGetMostHatedPlayerID(), kbBaseGetMainID(aiGetMostHatedPlayerID())));
	kbUnitQuerySetAscendingSort(enemyGold, true);
	kbUnitQuerySetIgnoreKnockedOutUnits(enemyGold, true);
	kbUnitQuerySetState(enemyGold, cUnitStateAlive);

	int attackUnit = -1;
	float targetDist = -1;
	if (kbUnitQueryExecute(enemySettler) > 0)
	{
		attackUnit = kbUnitQueryGetResult(enemySettler, 0);
		sendPosition = kbUnitGetPosition(attackUnit);
		targetDist = distance(sendPosition, kbUnitGetPosition(kbBaseGetMainID(aiGetMostHatedPlayerID())));
	}
	else if (kbUnitQueryExecute(enemyExplorer) > 0)
	{
		attackUnit = kbUnitQueryGetResult(enemyExplorer, 0);
		sendPosition = kbUnitGetPosition(attackUnit);
		targetDist = distance(sendPosition, kbUnitGetPosition(kbBaseGetMainID(aiGetMostHatedPlayerID())));
	}

	static int sendUnit = -1;
	if (sendUnit == -1) sendUnit = kbUnitQueryCreate("sendUnit"+getQueryId());
	kbUnitQueryResetResults(sendUnit);
	kbUnitQuerySetPlayerID(sendUnit, cMyID, false);
	kbUnitQuerySetUnitType(sendUnit, unitType);
	kbUnitQuerySetPosition(sendUnit, kbBaseGetLocation(aiGetMostHatedPlayerID(), kbBaseGetMainID(aiGetMostHatedPlayerID())));
	kbUnitQuerySetAscendingSort(sendUnit, true);
	kbUnitQuerySetState(sendUnit, cUnitStateAlive);

	int sendUnitId = -1;
	if (sendPosition != cInvalidVector && targetDist < 30)
	{
		for (i = 0; < kbUnitQueryExecute(sendUnit))
		{
			if (kbUnitIsType(kbUnitQueryGetResult(sendUnit, i), cUnitTypeHero) == true) continue;
			if (kbUnitGetPlanID(kbUnitQueryGetResult(sendUnit, i)) != -1) continue;
			if (i > 5) return;
			sendUnitId = kbUnitQueryGetResult(sendUnit, i);
			//aiPlanDestroy(kbUnitGetPlanID(sendUnitId));
			aiTaskUnitWork(sendUnitId, attackUnit);
		}

	}
	else
	{
		int sendCount = 0;
		int sendAmount = 5;
		if (gCurrentAge < cAge3) sendAmount = 2;
		bool sendToGold = true;
		for (i = 0; < kbUnitQueryExecute(sendUnit))
		{
			if (kbUnitIsType(kbUnitQueryGetResult(sendUnit, i), cUnitTypeHero) == true) continue;
			if (kbUnitGetPlanID(kbUnitQueryGetResult(sendUnit, i)) != -1) continue;
			
			if (sendCount > sendAmount) return;
			sendUnitId = kbUnitQueryGetResult(sendUnit, i);
			if (kbUnitIsType(sendUnitId, cUnitTypeAbstractMonk) == true) continue;
			sendCount++;
			//aiPlanDestroy(kbUnitGetPlanID(sendUnitId));
			static int enemyBuildings = -1;

			for (j = 0; < kbUnitQueryExecute(enemyAnimalPrey))
			{
				if (distance(kbUnitGetPosition(kbUnitQueryGetResult(enemyAnimalPrey, j)), kbBaseGetLocation(aiGetMostHatedPlayerID(), kbBaseGetMainID(aiGetMostHatedPlayerID()))) < 20) continue;
				if (distance(kbUnitGetPosition(kbUnitQueryGetResult(enemyAnimalPrey, j)), kbBaseGetLocation(aiGetMostHatedPlayerID(), kbBaseGetMainID(aiGetMostHatedPlayerID()))) > 80) continue;
				if (kbUnitQueryExecute(enemyBuildings) > 0) continue;

				if(enemyBuildings == -1) enemyBuildings = kbUnitQueryCreate("enemyBuildings"+getQueryId());
				kbUnitQueryResetResults(enemyBuildings);
				kbUnitQuerySetPlayerRelation(enemyBuildings, cPlayerRelationEnemyNotGaia);
				kbUnitQuerySetUnitType(enemyBuildings, cUnitTypeLogicalTypeBuildingsNotWalls);
				kbUnitQuerySetPosition(enemyBuildings, kbUnitGetPosition(kbUnitQueryGetResult(enemyAnimalPrey, j)));
				kbUnitQuerySetMaximumDistance(enemyBuildings, 30);
				kbUnitQuerySetAscendingSort(enemyBuildings, true);
				kbUnitQuerySetIgnoreKnockedOutUnits(enemyBuildings, true);
				kbUnitQuerySetState(enemyBuildings, cUnitStateAlive);

				if (distance(kbUnitGetPosition(kbUnitQueryGetResult(enemyAnimalPrey, j)), kbUnitGetPosition(sendUnitId)) < 20) return;
				sendToGold = false;
				aiTaskUnitMove(sendUnitId, kbUnitGetPosition(kbUnitQueryGetResult(enemyAnimalPrey, j)));
				break;
			}
			if (sendToGold == true)
			{
				if (distance(kbUnitGetPosition(kbUnitQueryGetResult(enemyGold, j)), kbBaseGetLocation(aiGetMostHatedPlayerID(), kbBaseGetMainID(aiGetMostHatedPlayerID()))) < 20) continue;
				if (distance(kbUnitGetPosition(kbUnitQueryGetResult(enemyGold, j)), kbBaseGetLocation(aiGetMostHatedPlayerID(), kbBaseGetMainID(aiGetMostHatedPlayerID()))) > 80) continue;
				if (kbUnitQueryExecute(enemyBuildings) > 0) continue;

				enemyBuildings = kbUnitQueryCreate("enemyBuildings"+getQueryId());
				kbUnitQueryResetResults(enemyBuildings);
				kbUnitQuerySetPlayerRelation(enemyBuildings, cPlayerRelationEnemyNotGaia);
				kbUnitQuerySetUnitType(enemyBuildings, cUnitTypeLogicalTypeBuildingsNotWalls);
				kbUnitQuerySetPosition(enemyBuildings, kbUnitGetPosition(kbUnitQueryGetResult(enemyAnimalPrey, j)));
				kbUnitQuerySetMaximumDistance(enemyBuildings, 30);
				kbUnitQuerySetAscendingSort(enemyBuildings, true);
				kbUnitQuerySetIgnoreKnockedOutUnits(enemyBuildings, true);
				kbUnitQuerySetState(enemyBuildings, cUnitStateAlive);
				if (distance(kbUnitGetPosition(kbUnitQueryGetResult(enemyGold, j)), kbUnitGetPosition(sendUnitId)) < 20) return;
				sendToGold = false;
				aiTaskUnitMove(sendUnitId, kbUnitGetPosition(kbUnitQueryGetResult(enemyGold, j)));
				break;
			}
		}
	}

}

//==============================================================================
// spy
// updatedOn 2019/12/09 By ageekhere
//==============================================================================
//rule spy
//active
//minInterval 10
void spy()
{
	static int lastRunTime = 0;
	static int timeRan = 0; //add some extra random time
	if(gCurrentGameTime < lastRunTime + 10000 + timeRan )return;
	lastRunTime = gCurrentGameTime;
	timeRan = aiRandInt(10);
	timeRan = timeRan * 1000;
	
	static int randomSpy = -1;
	static int spyPlan = -1;

	if (gCurrentAge > cAge3)
	{
		aiPlanDestroy(spyPlan);
		return;
	}
	if (randomSpy == -1) randomSpy = aiRandInt(2);
	randomSpy = 0;
	if (randomSpy == 0 && gWorldDifficulty != cDifficultyExpert && gWorldDifficulty != cDifficultyHard) return;
	if (aiTreatyActive() == true) return;
	if (gCurrentAge < cAge2 || getCivIsNative() == true || getCivIsAsian() == true || aiTreatyActive() == true || gWorldDifficulty == cDifficultySandbox || gWorldDifficulty == cDifficultyEasy) return;
	int spyNum = 1; //1
	
	if (gWorldDifficulty == cDifficultyModerate) spyNum = 1;
	if (gWorldDifficulty == cDifficultyHard) spyNum = 10;
	if (gWorldDifficulty == cDifficultyExpert) spyNum = 10;

	if (spyPlan < 0 && kbUnitCount(cMyID, gChurchUnit, cUnitStateAlive) > 0)
	{ //create spy
		spyPlan = createSimpleMaintainPlan(cUnitTypexpSpy, spyNum, false, kbBaseGetMainID(cMyID), spyNum,spyPlan);
	}
	sendRaid(cUnitTypexpSpy);

}

void militaryRaid()
{

	if (gCurrentAge > cAge2) return;
	sendRaid(cUnitTypeLogicalTypeLandMilitary);
}

//rule ramManager
//active
//minInterval 10
void ramManager()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"ramManager") == false) return;
	lastRunTime = gCurrentGameTime;
	
	if (aiTreatyActive() == true) return;
	if (kbGetCiv() != cCivXPIroquois) return;
	if (gCurrentAge < cAge4) return;
	static int ramPlan = -1;
	int ramNum = 10; //kbGetBuildLimit(cMyID, cUnitTypexpRam);
	if (ramPlan < 0 && kbUnitCount(cMyID, cUnitTypeArtilleryDepot, cUnitStateAlive) > 0)
	{
		ramPlan = createSimpleMaintainPlan(cUnitTypexpRam, ramNum, false, kbBaseGetMainID(cMyID), ramNum,ramPlan);
	}

	static int ramUnit = -1;
	if (ramUnit == -1) ramUnit = kbUnitQueryCreate("ramUnit"+getQueryId());
	kbUnitQueryResetResults(ramUnit);
	kbUnitQuerySetPlayerID(ramUnit, cMyID, false);
	kbUnitQuerySetUnitType(ramUnit, cUnitTypexpRam);
	kbUnitQuerySetState(ramUnit, cUnitStateAlive);

	int ramId = -1;
	static int millCheck = -1;
	if(millCheck == -1) millCheck = kbUnitQueryCreate("millCheck"+getQueryId());
	kbUnitQueryResetResults(millCheck);
	kbUnitQuerySetPlayerID(millCheck, cMyID,false);
	kbUnitQuerySetIgnoreKnockedOutUnits(millCheck, true);
	kbUnitQuerySetUnitType(millCheck, cUnitTypeLogicalTypeLandMilitary);
	kbUnitQuerySetState(millCheck, cUnitStateAlive);

	if (kbUnitQueryExecute(ramUnit) > 2 && kbUnitQueryExecute(millCheck) > 50)
	{
		for (j = 0; < kbUnitQueryExecute(ramUnit))
		{
			ramId = kbUnitQueryGetResult(ramUnit, j);
			aiTaskUnitWork(ramId, gPetardTarget);
		}
	}

}

//==============================================================================
// blackPowderManager
// updatedOn 2020/02/29 By ageekhere
//==============================================================================

//rule blackPowderManager
//active
//minInterval 10
void blackPowderManager()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"blackPowderManager") == false) return;
	lastRunTime = gCurrentGameTime;
	
	if (aiTreatyActive() == true) return;
	if (gCurrentAge < cAge4) return;
	if (kbGetCiv() == cCivUSA || kbGetCiv() == cCivColombians)
	{
		
		static int powderPlan = -1;
		int powderNum = kbGetBuildLimit(cMyID, cUnitTypeBlackPowderWagon);
		
		if(kbUnitCount(cMyID, cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive) > 70)
		{
			if (powderPlan < 0)
			{ //create mortars
				powderPlan = createSimpleMaintainPlan(cUnitTypeBlackPowderWagon, powderNum, false, kbBaseGetMainID(cMyID), powderNum,powderPlan);
			} //end if
			if (kbGetCiv() == cCivUSA && kbUnitCount(cMyID, cUnitTypeBlackPowderWagon, cUnitStateABQ) == 0) aiTaskUnitTrain(getUnit(gBarracksUnit), cUnitTypeBlackPowderWagon);
			else if (kbGetCiv() == cCivColombians && kbUnitCount(cMyID, cUnitTypeBlackPowderWagon, cUnitStateABQ) == 0) aiTaskUnitTrain(getUnit(gStableUnit), cUnitTypeBlackPowderWagon);
		}
		else
		{
			aiPlanDestroy(powderPlan);
		}
		

		static int powderUnit = -1;
		if (powderUnit == -1) powderUnit = kbUnitQueryCreate("powderUnit"+getQueryId());
		kbUnitQueryResetResults(powderUnit);
		kbUnitQuerySetPlayerID(powderUnit, cMyID, false);
		kbUnitQuerySetUnitType(powderUnit, cUnitTypeBlackPowderWagon);
		kbUnitQuerySetState(powderUnit, cUnitStateAlive);

		int powderId = -1;
		static int millCheck = -1;
		if(millCheck == -1) millCheck = kbUnitQueryCreate("millCheck"+getQueryId());
		kbUnitQueryResetResults(millCheck);
		kbUnitQuerySetPlayerID(millCheck, cMyID,false);
		kbUnitQuerySetIgnoreKnockedOutUnits(millCheck, true);
		kbUnitQuerySetUnitType(millCheck, cUnitTypeLogicalTypeLandMilitary);
		kbUnitQuerySetState(millCheck, cUnitStateAlive);

		if (kbUnitQueryExecute(powderUnit) > 0 && kbUnitQueryExecute(millCheck) > 50)
		{
			for (j = 0; < kbUnitQueryExecute(powderUnit))
			{
				powderId = kbUnitQueryGetResult(powderUnit, j);
				aiTaskUnitWork(powderId, gPetardTarget);
			}
		}
	}
}


//==============================================================================
// petardManager
// updatedOn 2020/02/24 By ageekhere
//==============================================================================
//ule petardManager
//active
//minInterval 10
void petardManager()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"petardManager") == false) return;
	lastRunTime = gCurrentGameTime;
	
	if (aiTreatyActive() == true) return;
	if ((kbGetCiv() != cCivJapanese) && (kbGetCiv() != cCivSPCJapanese) && (kbGetCiv() != cCivSPCJapaneseEnemy)) return;
	if (gCurrentAge < cAge4) return;
	static int petardPlan = -1;
	int petardNum = kbGetBuildLimit(cMyID, cUnitTypexpPetard);
	
	if(kbUnitCount(cMyID, cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive) > 70)
	{
		if (petardPlan < 0 && kbUnitCount(cMyID, cUnitTypeypCastle, cUnitStateAlive) > 0)
		{ //create mortars
			petardPlan = createSimpleMaintainPlan(cUnitTypexpPetard, petardNum, false, kbBaseGetMainID(cMyID), petardNum,petardPlan);
		} //end if
		if (kbUnitCount(cMyID, cUnitTypexpPetard, cUnitStateABQ) == 0) aiTaskUnitTrain(getUnit(cUnitTypeypCastle), cUnitTypexpPetard);
	}
	else
	{
		aiPlanDestroy(petardPlan);
	}
	
	static int petardUnit = -1;
	if (petardUnit == -1) petardUnit = kbUnitQueryCreate("petardUnit"+getQueryId());
	kbUnitQueryResetResults(petardUnit);
	kbUnitQuerySetPlayerID(petardUnit, cMyID, false);
	kbUnitQuerySetUnitType(petardUnit, cUnitTypexpPetard);
	kbUnitQuerySetState(petardUnit, cUnitStateAlive);

	int petardId = -1;

	static int millCheck = -1;
	if(millCheck == -1) millCheck = kbUnitQueryCreate("millCheck"+getQueryId());
	kbUnitQueryResetResults(millCheck);
	kbUnitQuerySetPlayerID(millCheck, cMyID,false);
	kbUnitQuerySetIgnoreKnockedOutUnits(millCheck, true);
	kbUnitQuerySetUnitType(millCheck, cUnitTypeLogicalTypeLandMilitary);
	kbUnitQuerySetState(millCheck, cUnitStateAlive);

	if (kbUnitQueryExecute(petardUnit) > 2 && kbUnitQueryExecute(millCheck) > 50)
	{
		for (j = 0; < kbUnitQueryExecute(petardUnit))
		{
			petardId = kbUnitQueryGetResult(petardUnit, j);
			aiTaskUnitWork(petardId, gPetardTarget);
		}
	}


}
//==============================================================================
// mortarManager
// updatedOn 2020/02/24 By ageekhere
//==============================================================================
//rule mortarManager
//active
//minInterval 10
void mortarManager()
{ //targets nearby AbstractFort and attacks them
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000, "mortarManager") == false) return;
	lastRunTime = gCurrentGameTime;
	
	if (aiTreatyActive() == true) return;
	if (gCurrentAge < cAge4) return; //check if it is time to make mortars
		
	int mortarNum = 5; //number of mortars to build
	static int mortarPlan = -1;
	int mortarType = cUnitTypeMortar;
	int artilleryBuilding = cUnitTypeArtilleryDepot;
	gPetardTarget = -1;
	if ((kbGetCiv() == cCivJapanese) || (kbGetCiv() == cCivSPCJapanese) || (kbGetCiv() == cCivSPCJapaneseEnemy))
	{
		mortarType = cUnitTypeypMorutaru;
		artilleryBuilding = cUnitTypeypCastle;
	}
	
	if(kbUnitCount(cMyID, cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive) > 70)
	{
		if (mortarPlan < 0 && kbUnitCount(cMyID, artilleryBuilding, cUnitStateAlive) > 0)
		{ //create mortars
			mortarPlan = createSimpleMaintainPlan(mortarType, mortarNum, false, kbBaseGetMainID(cMyID), mortarNum,mortarPlan);
		} //end if
		if (kbUnitCount(cMyID, mortarType, cUnitStateABQ) == 0) aiTaskUnitTrain(getUnit(artilleryBuilding), mortarType);
	}
	else
	{
		aiPlanDestroy(mortarPlan);
	}
	
	int buildingId = -1;
	float currentDist = -1;
	float lastDist = 999999;
	int nearestId = -1;
	static int nearTarget = -1;
	for (t = 0; < cNumberPlayers)
	{ //loop through players
		if (gPlayerTeam != kbGetPlayerTeam(t) && (t != cMyID))
		{ //That are not on my team and is not me
			
			if (nearTarget == -1) nearTarget = kbUnitQueryCreate("nearTarget"+getQueryId());
			kbUnitQueryResetResults(nearTarget);
			kbUnitQuerySetPlayerID(nearTarget, t, false);
			kbUnitQuerySetUnitType(nearTarget, cUnitTypeMilitaryBuilding);
			kbUnitQuerySetState(nearTarget, cUnitStateAlive);

			for (i = 0; < kbUnitQueryExecute(nearTarget))
			{
				buildingId = kbUnitQueryGetResult(nearTarget, i);
				currentDist = distance(gMainBaseLocation, kbUnitGetPosition(buildingId));
				if (currentDist < lastDist)
				{
					lastDist = currentDist;
					nearestId = buildingId;
				}
			}
			
			
		}
	}

	if (nearestId != -1)
	{
		gPetardTarget = nearestId;
		static int mortarUnit = -1;
		if (mortarUnit == -1) mortarUnit = kbUnitQueryCreate("mortarUnit"+getQueryId());
		kbUnitQueryResetResults(mortarUnit);
		kbUnitQuerySetPlayerID(mortarUnit, cMyID, false);
		kbUnitQuerySetUnitType(mortarUnit, mortarType);
		kbUnitQuerySetState(mortarUnit, cUnitStateAlive);

		static int cavUnit = -1;
		if (cavUnit == -1) cavUnit = kbUnitQueryCreate("cavUnit"+getQueryId());
		kbUnitQueryResetResults(cavUnit);
		kbUnitQuerySetPlayerID(cavUnit, cMyID, false);
		kbUnitQuerySetUnitType(cavUnit, cUnitTypeAbstractLightCavalry);
		kbUnitQuerySetState(cavUnit, cUnitStateAlive);

		static int millCheck = -1;
		if(millCheck == -1) millCheck = kbUnitQueryCreate("millCheck"+getQueryId());
		kbUnitQueryResetResults(millCheck);
		kbUnitQuerySetPlayerID(millCheck, cMyID);
		kbUnitQuerySetIgnoreKnockedOutUnits(millCheck, false);
		kbUnitQuerySetUnitType(millCheck, cUnitTypeLogicalTypeLandMilitary);
		kbUnitQuerySetState(millCheck, cUnitStateAlive);

		if (kbUnitQueryExecute(millCheck) > 50)
		{
			int mortarId = -1;
			for (j = 0; < kbUnitQueryExecute(mortarUnit))
			{
				mortarId = kbUnitQueryGetResult(mortarUnit, j);
				aiTaskUnitWork(mortarId, nearestId);
			}

			if (mortarId != -1)
			{
				for (j = 0; < kbUnitQueryExecute(cavUnit))
				{
					int cavId = kbUnitQueryGetResult(cavUnit, j);
					aiTaskUnitWork(cavId, mortarId);
				}
			}
		}

	}
}

//rule sendHelpToSaveTeam
//active
//inInterval 10
void sendHelpToSaveTeam()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"sendHelpToSaveTeam") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	static int teamTC = -1;
	if (teamTC == -1) teamTC = kbUnitQueryCreate("teamTC"+getQueryId());
	kbUnitQueryResetResults(teamTC);
	kbUnitQuerySetPlayerRelation(teamTC, cPlayerRelationAlly);
	kbUnitQuerySetUnitType(teamTC, gTownCenter);
	kbUnitQuerySetState(teamTC, cUnitStateAlive);
	
	static int armyHelp = -1;
	if (armyHelp == -1) armyHelp = kbUnitQueryCreate("armyHelp");
	kbUnitQueryResetResults(armyHelp);
	kbUnitQuerySetPlayerID(armyHelp, cMyID, false);
	kbUnitQuerySetIgnoreKnockedOutUnits(armyHelp, true);
	kbUnitQuerySetUnitType(armyHelp, cUnitTypeLogicalTypeLandMilitary);
	kbUnitQuerySetState(armyHelp, cUnitStateAlive);
	
	if (kbBaseGetUnderAttack(cMyID, kbBaseGetMainID(cMyID)) == false)
	{
		for (i = 0; < kbUnitQueryExecute(teamTC))
		{
			if (getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, kbUnitGetPosition(kbUnitQueryGetResult(teamTC, i)), 30.0) > 20)
			{
				for (j = 0; < kbUnitQueryExecute(armyHelp))
				{
					if (distance(kbUnitGetPosition(kbUnitQueryGetResult(armyHelp, j)), kbUnitGetPosition(kbUnitQueryGetResult(teamTC, i))) < 90) continue;
					aiPlanDestroy(kbUnitGetPlanID(kbUnitQueryGetResult(armyHelp, j)));
					aiTaskUnitMove(kbUnitQueryGetResult(armyHelp, j), kbUnitGetPosition(kbUnitQueryGetResult(teamTC, i)));
				}
			}
		}
	}
}


void specialMain()
{

}