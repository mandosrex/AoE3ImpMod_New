//levy

//==============================================================================
// useLevy
//==============================================================================
rule useLevy
inactive
//group tcComplete
minInterval 10
{

	// Disable rule for native or Asian civs
	if ((getCivIsNative() == true) || (getCivIsAsian() == true))
	{
		xsDisableSelf();
		return;
	}

	// Check to see if town is being overrun.  If so, generate a plan
	// to 'research' levy.  If plan is active but enemies disappear, 
	// kill it.  Once research is complete, end this rule.

	static int levyPlan = -1;

	vector mainBaseVec = cInvalidVector;

	mainBaseVec = gMainBaseLocation;

	int enemyCount = getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, mainBaseVec, 40.0);
	int allyCount = getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationAlly, cUnitStateAlive, mainBaseVec, 40.0);


	/*
		if (kbTechGetStatus(cTechLevy) != cTechStatusActive) // this check does not work!
		{  // We're done, we've used levy
		aiEcho("   ** We've used levy, disabling useLevy rule.");
		xsDisableSelf();
		return;
		}  
	*/
createSimpleResearchPlan(cTechLevy, getUnitByLocation(gTownCenter, cMyID, cUnitStateAlive, mainBaseVec, 40.0), cMilitaryEscrowID, 99);
	if (levyPlan < 0) // No plan, see if we need one.
	{
		//if (enemyCount >= (allyCount + 6)) // We're behind by 6 or more
		//{
			//aiEcho("***** Starting a levy plan, there are "+enemyCount+" enemy units in my base against "+allyCount+" friendlies.");
			levyPlan = createSimpleResearchPlan(cTechLevy, getUnitByLocation(gTownCenter, cMyID, cUnitStateAlive, mainBaseVec, 40.0), cMilitaryEscrowID, 99); // Extreme priority
			
		//}
	}
	else // Plan exists, make sure it's still needed
	{
		if (enemyCount > (allyCount + 2))
		{ // Do nothing
			aiEcho("   ** Still waiting for Levy.");
		}
		else
		{
			//aiEcho("   ** Cancelling levy.");
			aiPlanDestroy(levyPlan);
			levyPlan = -1;
		}
	}
}

//rule consulateLevy
//inactive
//minInterval 10
void consulateLevy()
{
	// Check to see if town is being overrun. If so, generate a plan
	// to research Ottoman levy at the consulate. 
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"consulateLevy") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	int levyPlan = -1;
	vector mainBaseVec = cInvalidVector;

	mainBaseVec = gMainBaseLocation;
	int enemyCount = getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, mainBaseVec, 40.0);
	int allyCount = getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationAlly, cUnitStateAlive, mainBaseVec, 40.0);

	if (enemyCount >= (allyCount + 6)) // We're behind by 6 or more
	{
		//aiEcho("***** Starting consulate levy plan, there are "+enemyCount+" enemy units in my base against "+allyCount+" friendlies.");
		if (kbTechGetStatus(cTechypConsulateOttomansSettlerCombat) == cTechStatusObtainable)
			levyPlan = createSimpleResearchPlan(cTechypConsulateOttomansSettlerCombat, getUnit(cUnitTypeypConsulate), cMilitaryEscrowID, 99); // Extreme priority
	}
}

//==============================================================================
/* rule call_levies
	updatedOn 2019/09/14 By ageekhere  
*/
//==============================================================================
//rule call_levies
//active
//minInterval 5
void call_levies()
{ //trains levies when base is under attack
	static int lastRunTime = 0;
	static int timeRan = 0; //add some extra random time
	if(gCurrentGameTime < lastRunTime + 5000 + timeRan )return;
	lastRunTime = gCurrentGameTime;
	timeRan = aiRandInt(10);
	timeRan = timeRan * 1000; 
	
	int base = -1;
	int town = -1;
	for (i = 0; < kbBaseGetNumber(cMyID))
	{
		base = kbBaseGetIDByIndex(cMyID, i);
		if (kbBaseGetUnderAttack(cMyID, base) == false) continue;
		//if(getUnitByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, gMainBaseLocation, 80) < 10) continue;
		town = getUnitByLocation(gTownCenter, cMyID, cUnitStateAlive, kbBaseGetLocation(cMyID, base), 80.0);
		if (town == -1) continue;

		aiTaskUnitTrain(town, cUnitTypeLevyMin);
		aiTaskUnitTrain(town, cUnitTypeLevyIre);
		aiTaskUnitTrain(town, cUnitTypeLevyAsi);
	} //end for
} //end call_levies

void levyMain()
{
}