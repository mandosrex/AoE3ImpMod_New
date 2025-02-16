//attackMethods
//==============================================================================
// chooseAttackPlayerID
/*
	Given a point/radius, look for enemy units, and choose the owner of one
	as an appropriate player to attack.
	
	If none found, return mostHatedEnemy.
*/
//==============================================================================
int chooseAttackPlayerID(vector point = cInvalidVector, float radius = 50.0)
{
	
	int retVal = aiGetMostHatedPlayerID();
	static int queryID = -1;

	if (point == cInvalidVector)
		return (retVal);

	if (queryID == -1) 
	{
		queryID = kbUnitQueryCreate("Choose attack player" + getQueryId());
		kbUnitQuerySetPlayerID(queryID,-1,false);
		kbUnitQuerySetPlayerRelation(queryID, cPlayerRelationEnemyNotGaia); // Any enemy units in point/radius
		kbUnitQuerySetIgnoreKnockedOutUnits(queryID, true);
		kbUnitQuerySetState(queryID, cUnitStateAlive);
	}
	kbUnitQueryResetResults(queryID);
	kbUnitQuerySetUnitType(queryID, cUnitTypeUnit);
	kbUnitQuerySetPosition(queryID, point);
	kbUnitQuerySetMaximumDistance(queryID, radius);
	
	int count = kbUnitQueryExecute(queryID);
	int index = 0;
	int unitID = 0;
	for (index = 0; < count)
	{
		unitID = kbUnitQueryGetResult(queryID, index);
		if (kbUnitGetPlayerID(unitID) > 0) // Not Gaia
		{
			retVal = kbUnitGetPlayerID(unitID); // Owner of first (random) non-gaia unit
			break;
		}
	}

	return (retVal);
}

void findEnemyBase(void)
{
	if(getMapIsIsland() == true) return;

	if (cvOkToExplore == false)
		return ();

	// Decide on which unit type to use as scout
	// If possible, cheap infantry is used
	int scoutType = -1;
	if (kbUnitCount(cMyID, cUnitTypeCrossbowman, cUnitStateAlive) >= 1)
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

	//Create an explore plan to go there.
	vector myBaseLocation = gMainBaseLocation; // Main base location...need to find reflection.
	vector centerOffset = gMapCenter - myBaseLocation;
	vector targetLocation = gMapCenter + centerOffset;
	// TargetLocation is now a mirror image of my base.
	//aiEcho("My base is at "+myBaseLocation+", enemy base should be near "+targetLocation);
	static int exploreID = -1;
	if(aiPlanGetActive(exploreID) == false)
	{
		aiPlanDestroy(exploreID);
		exploreID = -1;
	}
	if(exploreID == -1) 
	{
		exploreID = aiPlanCreate("Probe Enemy Base", cPlanExplore);
		aiPlanAddUnitType(exploreID, scoutType, 1, 1, 1); // Infantry or cavalry only, no explorer!
		aiPlanAddWaypoint(exploreID, targetLocation);
		aiPlanSetVariableBool(exploreID, cExplorePlanDoLoops, 0, false);
		aiPlanSetVariableBool(exploreID, cExplorePlanQuitWhenPointIsVisible, 0, true);
		aiPlanSetVariableBool(exploreID, cExplorePlanAvoidingAttackedAreas, 0, false);
		aiPlanSetVariableInt(exploreID, cExplorePlanNumberOfLoops, 0, -1);
		aiPlanSetRequiresAllNeedUnits(exploreID, true);
		aiPlanSetVariableVector(exploreID, cExplorePlanQuitWhenPointIsVisiblePt, 0, targetLocation);
		aiPlanSetDesiredPriority(exploreID, 100);
		aiPlanSetActive(exploreID);
	}
}


//==============================================================================
/* rule f_moveArmy, rule for void newAttack()
	updatedOn 2020/04/16 By ageekhere 
*/
//==============================================================================
void f_moveArmy(vector targetLocation = cInvalidVector, )
{
	static int moveArmyID = -1;
	if(aiPlanGetActive(moveArmyID) == true)return;
	aiPlanDestroy(moveArmyID);

	moveArmyID = aiPlanCreate("moveArmyID", cPlanExplore);
	aiPlanAddUnitType(moveArmyID, cUnitTypeLogicalTypeLandMilitary, 300, 300, 300);
	aiPlanAddWaypoint(moveArmyID, targetLocation);
	aiPlanSetVariableBool(moveArmyID, cExplorePlanDoLoops, 0, true);
	//aiPlanSetVariableBool(moveArmyID, cExplorePlanQuitWhenPointIsVisible, 0, true);
	aiPlanSetVariableBool(moveArmyID, cExplorePlanAvoidingAttackedAreas, 0, false);
	aiPlanSetVariableInt(moveArmyID, cExplorePlanNumberOfLoops, 0, 2);
	aiPlanSetRequiresAllNeedUnits(moveArmyID, true);
	//aiPlanSetVariableVector(moveArmyID, cExplorePlanQuitWhenPointIsVisiblePt, 0, targetLocation);
	aiPlanSetDesiredPriority(moveArmyID, 100);
	aiPlanSetActive(moveArmyID);
}

//==============================================================================
/* rule newAttack, creates new attack targets
	updatedOn 2020/04/16 By ageekhere 
*/
//==============================================================================


void newAttack()
{
	if (gTreatyActive == true || gCurrentAge == cAge1) return;
	if (gCurrentAge < cAge3 && getCivIsNative() == false && gOpeningStrategy != 1 && getCivIsAsian() == false) return; //do not attack untill age 3 unless rushing, exclude natives
	static float pEnemyPercentageCap = 50.0;
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"newAttack") == false) return;
	lastRunTime = gCurrentGameTime;
	
	static int pEnemyUnitNum = -1;
	if(gGetMostHatedPlayerID == -1)return;
	int pId = cMyID;
	
	//kbUnitCountConsole(2, 1,cUnitTypeLogicalTypeLandMilitary,cUnitStateAlive)

	xsSetContextPlayer(gGetMostHatedPlayerID);
	pEnemyUnitNum = kbUnitCount(gGetMostHatedPlayerID, cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive);
	xsSetContextPlayer(pId);
	
	static float pPercentage = -1.0;
	static float pDifference = -1.0;

	if(pEnemyUnitNum > gNumSelfLandMilitary)
	{
		pDifference = pEnemyUnitNum - gNumSelfLandMilitary;
		pPercentage =(pDifference / pEnemyUnitNum) * 100;
		if (pPercentage > pEnemyPercentageCap) return;
	}

	//if(gMainBaseUnderAttack == true) return;
	//static int moveArmyToFront = -1;
	//if(gCurrentAge > cAge2 && gCurrentAge < cAge5 && kbUnitCount(cMyID, cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive) < 30 )return;
	static int pEnemyBuildingQry = -1;
	int pEnemyNum =0;
	
	if (pEnemyBuildingQry == -1) 
	{
		pEnemyBuildingQry = kbUnitQueryCreate("pEnemyBuildingQry"+getQueryId());
		kbUnitQueryResetResults(pEnemyBuildingQry);
		kbUnitQuerySetPlayerRelation(pEnemyBuildingQry, -1);
		kbUnitQuerySetUnitType(pEnemyBuildingQry, cUnitTypeLogicalTypeLandMilitary);
		kbUnitQuerySetIgnoreKnockedOutUnits(pEnemyBuildingQry, true);
		kbUnitQuerySetState(pEnemyBuildingQry, cUnitStateAlive);
		kbUnitQuerySetPosition(pEnemyBuildingQry,gMainBaseLocation);
		kbUnitQuerySetAscendingSort(pEnemyBuildingQry,true);
	}	
	kbUnitQueryResetResults(pEnemyBuildingQry);
	kbUnitQuerySetPlayerID(pEnemyBuildingQry,gGetMostHatedPlayerID,false);
	pEnemyNum = kbUnitQueryExecute(pEnemyBuildingQry);
	
	if(pEnemyNum == 0)return;
	vector attackLocation = kbUnitGetPosition(kbUnitQueryGetResult(pEnemyBuildingQry, 0));
	
	
	//static int pActivePlans = -1;
	//pActivePlans = aiPlanGetNumber(cPlanDefend, -1, true);
	//int pInactivePlans = aiPlanGetNumber(cPlanDefend, -1, false);
	/*
	static int pPlanId = -1;
	for (i = 0; < pActivePlans)
	{ //loop through all build plans
		pPlanId = aiPlanGetIDByIndex(cPlanDefend, -1, true, i);
		aiPlanDestroy(pPlanId);			
			/*pTimeMade = aiPlanGetUserVariableInt(pPlanId, 0, 0);

			if(gCurrentGameTime - pTimeMade > 300000)
			{
				aiPlanDestroy(pPlanId);				
			}

	}
	*/
	
	static int count = 0;
	//aiArmyClear(0);
	static int pSelfUnit = -1;
	int cont = 0;
	aiArmyClear(count);
	for (i = 0; < gNumSelfLandMilitary)
	{ 
		cont++;
		pSelfUnit = kbUnitQueryGetResult(gSelfLandMilitaryQry, i); //get self land unit
		if(kbUnitGetHealth(pSelfUnit) == 0.0) continue;
		
		if (kbUnitIsType(pSelfUnit, cUnitTypeHealerUnit)) continue;
		if (kbUnitGetPlanID(pSelfUnit) != -1 || kbUnitGetActionType(pSelfUnit) != 7) continue; 
		//if(getMapIsIsland() == false) aiTaskUnitMove(pSelfUnit,attackLocation);
		aiArmyAddUnit(count, pSelfUnit);
		if(cont > 75) 
		{
			cont = 0;
			aiArmyMove(count, attackLocation, true);
			count++;
			if(count == 9) count = 0;
		}
	}
	aiArmyMove(count, attackLocation, true);
	count++;
	if(count == 9) count = 0;
	
	/*
	int planID = -1;
	if(planID == -1) 
	{
		planID = aiPlanCreate("MainAttackPlan", cPlanAttack);
	}
		aiPlanSetDesiredPriority(planID, 100);
		aiPlanSetUnitStance(planID, cUnitStanceAggressive);		
		aiPlanSetAllowUnderAttackResponse(planID, true);
		aiPlanSetVariableFloat(planID, cAttackPlanAttackPointEngageRange, 0, 60.0);
		aiPlanSetNumberVariableValues(planID, cAttackPlanTargetTypeID, 2, true);
		aiPlanSetVariableInt(planID, cAttackPlanTargetTypeID, 0, cUnitTypeLogicalTypeBuildingsNotWalls );
		aiPlanSetVariableInt(planID, cAttackPlanTargetTypeID, 1, cUnitTypeLogicalTypeLandMilitary); //cUnitTypeMusketeer cUnitTypeLogicalTypeLandMilitary cUnitTypeLogicalTypeLandMilitary
		aiPlanSetVariableInt(planID, cAttackPlanAttackRoutePattern, 0, cAttackPlanAttackRoutePatternBest);
		aiPlanSetVariableBool(planID, cAttackPlanMoveAttack, 0, true);
		aiPlanSetVariableInt(planID, cAttackPlanRefreshFrequency, 0, 6);
		aiPlanSetVariableInt(planID, cAttackPlanHandleDamageFrequency, 0, 6);
		aiPlanSetVariableInt(planID, cAttackPlanBaseAttackMode, 0, cAttackPlanBaseAttackModeRandom);
		aiPlanSetVariableInt(planID, cAttackPlanRetreatMode, 0, cAttackPlanRetreatModeNone);
		aiPlanSetVariableInt(planID, cAttackPlanGatherWaitTime, 0, 0);
		aiPlanSetVariableVector(planID, cAttackPlanGatherPoint, 0, gMainBaseLocation);
		aiPlanSetVariableFloat(planID, cAttackPlanGatherDistance, 0, 100.0);
		aiPlanSetInitialPosition(planID, gMainBaseLocation);
		aiPlanSetVariableInt(planID, cAttackPlanPlayerID, 0, gGetMostHatedPlayerID);
		aiPlanSetVariableVector(planID, cAttackPlanAttackPoint, 0, attackLocation);
		aiPlanAddUnitType(planID, cUnitTypeLogicalTypeLandMilitary, kbUnitCount(cMyID, cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive), 300, 300);  //cUnitTypeMusketeer cUnitTypeLogicalTypeLandMilitary
		aiPlanSetActive(planID, true);
	*/
}			

void attackMain()
{

}