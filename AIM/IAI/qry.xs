//qry methods

//kbUnitQueryExecute(gEnemyLandMilitaryQry);

void enemyLandMilitaryQry()
{
	if (gEnemyLandMilitaryQry == -1) 
	{ //Qry to find all enemy land units
		gEnemyLandMilitaryQry = kbUnitQueryCreate("gEnemyLandMilitaryQry"+getQueryId());
		kbUnitQuerySetPlayerRelation(gEnemyLandMilitaryQry, cPlayerRelationEnemyNotGaia);
		kbUnitQuerySetUnitType(gEnemyLandMilitaryQry, cUnitTypeLogicalTypeLandMilitary);
		kbUnitQuerySetIgnoreKnockedOutUnits(gEnemyLandMilitaryQry, true);
		kbUnitQuerySetState(gEnemyLandMilitaryQry, cUnitStateAlive);
	} //end if
	kbUnitQueryResetResults(gEnemyLandMilitaryQry);
	gNumEnemyLandMilitary = kbUnitQueryExecute(gEnemyLandMilitaryQry);
}

void selfLandMilitaryQry()
{
	
	if (gSelfLandMilitaryQry == -1) 
	{
		gSelfLandMilitaryQry = kbUnitQueryCreate("gSelfLandMilitaryQry"+getQueryId());
		kbUnitQuerySetPlayerID(gSelfLandMilitaryQry,cMyID,false);
		kbUnitQuerySetPlayerRelation(gSelfLandMilitaryQry, -1);
		kbUnitQuerySetUnitType(gSelfLandMilitaryQry, cUnitTypeLogicalTypeLandMilitary);
		kbUnitQuerySetIgnoreKnockedOutUnits(gSelfLandMilitaryQry, true);
		kbUnitQuerySetState(gSelfLandMilitaryQry, cUnitStateAlive);
	}	
	kbUnitQueryResetResults(gSelfLandMilitaryQry);
	gNumSelfLandMilitary = kbUnitQueryExecute(gSelfLandMilitaryQry);
}
