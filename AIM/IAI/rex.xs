//reflex
//==============================================================================
/*
	moveDefenseReflex(vector, radius, baseID)
	
	Move the defend and reserve plans to the specified location
	Sets the gLandDefendPlan0 to a high pop count, so it steals units from the reserve plan,
	which will signal the AI to not start new attacks as no reserves are available.
*/
//==============================================================================
void moveDefenseReflex(vector location = cInvalidVector, float radius = -1.0, int baseID = -1)
{
	if (radius < 0.0)
		radius = cvDefenseReflexRadiusActive;
	if (location != cInvalidVector)
	{
		aiPlanSetVariableVector(gLandDefendPlan0, cDefendPlanDefendPoint, 0, location);
		aiPlanSetVariableFloat(gLandDefendPlan0, cDefendPlanEngageRange, 0, radius);
		aiPlanSetVariableFloat(gLandDefendPlan0, cDefendPlanGatherDistance, 0, radius - 10.0);
		aiPlanAddUnitType(gLandDefendPlan0, cUnitTypeLogicalTypeLandMilitary, 0, 0, 200);

		aiPlanSetVariableVector(gLandReservePlan, cDefendPlanDefendPoint, 0, location);
		aiPlanSetVariableFloat(gLandReservePlan, cDefendPlanEngageRange, 0, radius);
		aiPlanSetVariableFloat(gLandReservePlan, cDefendPlanGatherDistance, 0, radius - 10.0);
		aiPlanAddUnitType(gLandReservePlan, cUnitTypeLogicalTypeLandMilitary, 0, 0, 1);

		gDefenseReflex = true;
		gDefenseReflexBaseID = baseID;
		gDefenseReflexLocation = location;
		gDefenseReflexStartTime = gCurrentGameTime;
		gDefenseReflexPaused = false;
	}
	//aiEcho("******** Defense reflex moved to base "+baseID+" with radius "+radius+" and location "+location);
}

//==============================================================================
/*
	pauseDefenseReflex()
	
	The base (gDefenseReflexBaseID) is still under attack, but we don't have enough
	forces to engage.  Retreat to main base, set a small radius, and wait until we 
	have enough troops to re-engage through a moveDefenseReflex() call.
	Sets gLandDefendPlan0 to high troop count to keep reserve plan empty.
	Leaves the base ID and location untouched, even though units will gather at home.
*/
//==============================================================================
void pauseDefenseReflex(void)
{
	vector loc = kbBaseGetMilitaryGatherPoint(cMyID, kbBaseGetMainID(cMyID));
	if (gForwardBaseState != gForwardBaseStateNone)
		loc = gForwardBaseLocation;

	aiPlanSetVariableVector(gLandDefendPlan0, cDefendPlanDefendPoint, 0, loc);
	aiPlanSetVariableFloat(gLandDefendPlan0, cDefendPlanEngageRange, 0, cvDefenseReflexRadiusPassive);
	aiPlanSetVariableFloat(gLandDefendPlan0, cDefendPlanGatherDistance, 0, cvDefenseReflexRadiusPassive - 10.0);

	aiPlanSetVariableVector(gLandReservePlan, cDefendPlanDefendPoint, 0, loc);
	aiPlanSetVariableFloat(gLandReservePlan, cDefendPlanEngageRange, 0, cvDefenseReflexRadiusPassive);
	aiPlanSetVariableFloat(gLandReservePlan, cDefendPlanGatherDistance, 0, cvDefenseReflexRadiusPassive - 10.0);

	aiPlanAddUnitType(gLandDefendPlan0, cUnitTypeLogicalTypeLandMilitary, 0, 0, 200);
	aiPlanAddUnitType(gLandReservePlan, cUnitTypeLogicalTypeLandMilitary, 0, 0, 1);


	gDefenseReflexPaused = true;

	//aiEcho("******** Defense reflex paused.");
}

//==============================================================================
/*
	endDefenseReflex()
	
	Move the defend and reserve plans to their default positions
*/
//==============================================================================
void endDefenseReflex(void)
{
	vector resLoc = kbBaseGetMilitaryGatherPoint(cMyID, kbBaseGetMainID(cMyID));
	vector defLoc = gMainBaseLocation;
	if (gForwardBaseState != gForwardBaseStateNone)
	{
		resLoc = gForwardBaseLocation;
		defLoc = gForwardBaseLocation;
	}
	aiPlanSetVariableVector(gLandDefendPlan0, cDefendPlanDefendPoint, 0, defLoc); // Main base or forward base (if forward base exists)
	aiPlanSetVariableFloat(gLandDefendPlan0, cDefendPlanEngageRange, 0, cvDefenseReflexRadiusActive);
	aiPlanSetVariableFloat(gLandDefendPlan0, cDefendPlanGatherDistance, 0, cvDefenseReflexRadiusActive - 10.0);
	aiPlanAddUnitType(gLandDefendPlan0, cUnitTypeLogicalTypeLandMilitary, 0, 0, 1); // Defend plan will use 1 unit to defend against stray snipers, etc.

	aiPlanSetVariableVector(gLandReservePlan, cDefendPlanDefendPoint, 0, resLoc);
	aiPlanSetVariableFloat(gLandReservePlan, cDefendPlanEngageRange, 0, cvDefenseReflexRadiusPassive); // Small radius
	aiPlanSetVariableFloat(gLandReservePlan, cDefendPlanGatherDistance, 0, cvDefenseReflexRadiusPassive - 10.0);
	aiPlanAddUnitType(gLandReservePlan, cUnitTypeLogicalTypeLandMilitary, 0, 0, 200); // All unused troops

	//aiEcho("******** Defense reflex terminated for base "+gDefenseReflexBaseID+" at location "+gDefenseReflexLocation);
	//aiEcho("******** Returning to "+resLoc);
	//aiEcho(" Forward base ID is "+gForwardBaseID+", location is "+gForwardBaseLocation);

	gDefenseReflex = false;
	gDefenseReflexPaused = false;
	gDefenseReflexBaseID = -1;
	gDefenseReflexLocation = cInvalidVector;
	gDefenseReflexStartTime = -1;
}

rule endDefenseReflexDelay // Use this instead of calling endDefenseReflex in the createMainBase function, so that the new BaseID will be available.
inactive
minInterval 1
{
	xsDisableSelf();
	endDefenseReflex();
}



//==============================================================================
/* rule defenseReflex
	
	Monitor each VP site that we own, plus our main base.  Move and reconfigure 
	the defense and reserve plans as needed.
	
	At rest, the defend plan has only one unit, is centered on the main base, and
	is used to send one unit after trivial invasions, typically a scouting unit. 
	The reserve plan has a much larger MAX number, so it gets all the remaining units.
	It is centered on the military gather point with a conservative radius, to avoid
	engaging units far in front of the main base.
	
	When defending a base in a defense reflex, the defend plan gets a high MAX number
	so that it takes units from the reserve plan.  The low unit count in reserve 
	acts as a signal to not launch new attacks, as troops aren't available.  The 
	defend plan and reserve plan are relocated to the endangered base, with an aggressive
	engage radius.
	
	The search, active engage and passive engage radii are set by global 
	control variables, cvDefenseReflexRadiusActive, cvDefenseReflexRadiusPassive, and
	cvDefenseReflexSearchRadius.
	
	Once in a defense reflex, the AI stays in it until that base is cleared, unless
	it's defending a non-main base, and the main base requires defense.  In that case,
	the defense reflex moves back to the main base.
	
	pauseDefenseReflex() can only be used when already in a defense reflex.  So valid 
	state transitions are:
	
	none to defending       // start reflex with moveDefenseReflex(), sets all the base/location globals.
	defending to paused     // use pauseDefenseReflex(), takes no parms, uses vars set in prior moveDefenseReflex call.
	defending to end        // use endDefenseReflex(), clears global vars
	paused to end           // use endDefenseReflex(), clears global vars
	paused to defending     // use moveDefenseReflex(), set global vars again.
	
*/
//==============================================================================
// 

//rule defenseReflex
//inactive
//minInterval 10
//group startup
void defenseReflex()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"defenseReflex") == false) return;
	lastRunTime = gCurrentGameTime;
	
	int armySize = aiPlanGetNumberUnits(gLandDefendPlan0, cUnitTypeLogicalTypeLandMilitary) + aiPlanGetNumberUnits(gLandReservePlan, cUnitTypeLogicalTypeLandMilitary);
	int enemyArmySize = -1;
	static int lastHelpTime = -60000;
	static int lastHelpBaseID = -1;
	int i = 0;
	int unitID = -1;
	int protoUnitID = -1;
	bool panic = false; // Indicates need for call for help

	static int enemyArmyQuery = -1;
	if (enemyArmyQuery < 0) enemyArmyQuery = kbUnitQueryCreate("Enemy army query"+getQueryId());
	kbUnitQueryResetResults(enemyArmyQuery);
	kbUnitQuerySetIgnoreKnockedOutUnits(enemyArmyQuery, true);
	kbUnitQuerySetPlayerRelation(enemyArmyQuery, cPlayerRelationEnemyNotGaia);
	kbUnitQuerySetUnitType(enemyArmyQuery, cUnitTypeLogicalTypeLandMilitary);
	kbUnitQuerySetState(enemyArmyQuery, cUnitStateAlive);
	kbUnitQuerySetSeeableOnly(enemyArmyQuery, true); // Ignore units we think are under fog
	

	// Check main base first
	kbUnitQuerySetPosition(enemyArmyQuery, gMainBaseLocation);
	kbUnitQuerySetMaximumDistance(enemyArmyQuery, cvDefenseReflexSearchRadius);
	kbUnitQuerySetSeeableOnly(enemyArmyQuery, true);
	kbUnitQuerySetState(enemyArmyQuery, cUnitStateAlive);
	
	enemyArmySize = kbUnitQueryExecute(enemyArmyQuery);
	if (enemyArmySize >= 2)
	{ // Main base is under attack
		//aiEcho("******** Main base ("+kbBaseGetMainID(cMyID)+") under attack.");
		//aiEcho("******** Enemy count "+enemyArmySize+", my army count "+armySize);
		if (gDefenseReflexBaseID == kbBaseGetMainID(cMyID))
		{ // We're already in a defense reflex for the main base
			if (((armySize * 3.0) < enemyArmySize) && (enemyArmySize > 6.0)) // Army at least 3x my size and more than 6 units total.
			{ // Too big to handle
				if (gDefenseReflexPaused == false)
				{ // We weren't paused, do it
					pauseDefenseReflex();
				}
				// Consider a call for help
				panic = true;
				if (((gCurrentGameTime - lastHelpTime) < 300000) && (lastHelpBaseID == gDefenseReflexBaseID)) // We called for help in the last five minutes, and it was this base
					panic = false;
				if (((gCurrentGameTime - lastHelpTime) < 60000) && (lastHelpBaseID != gDefenseReflexBaseID)) // We called for help anywhere in the last minute
					panic = false;

				if (panic == true)
				{
					sendStatement(cPlayerRelationAlly, cAICommPromptToAllyINeedHelpMyBase, kbBaseGetLocation(cMyID, gDefenseReflexBaseID));
					//aiEcho("     I'm calling for help.");
					lastHelpTime = gCurrentGameTime;
				}
			}
			else
			{ // Size is OK to handle, shouldn't be in paused mode.
				if (gDefenseReflexPaused == true) // Need to turn it active
				{
					moveDefenseReflex(gMainBaseLocation, cvDefenseReflexRadiusActive, kbBaseGetMainID(cMyID));
				}
			}
		}
		else // Defense reflex wasn't set to main base.
		{ // Need to set the defense reflex to home base...doesn't matter if it was inactive or guarding another base, home base trumps all.
			moveDefenseReflex(gMainBaseLocation, cvDefenseReflexRadiusActive, kbBaseGetMainID(cMyID));
			// This is a new defense reflex in the main base.  Consider making a chat about it.
			int enemyPlayerID = kbUnitGetPlayerID(kbUnitQueryGetResult(enemyArmyQuery, 0));
			if ((enemyPlayerID > 0) && (gCurrentAge > cAge1))
			{ // Consider sending a chat as long as we're out of age 1.
				int enemyPlayerUnitCount = getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, enemyPlayerID, cUnitStateAlive, kbBaseGetLocation(cMyID, gDefenseReflexBaseID), 50.0);
				if ((enemyPlayerUnitCount > (2 * gGoodArmyPop)) && (enemyPlayerUnitCount > (3 * armySize)))
				{ // Enemy army is big, and we're badly outnumbered
					sendStatement(enemyPlayerID, cAICommPromptToEnemyISpotHisArmyMyBaseOverrun, kbBaseGetLocation(cMyID, gDefenseReflexBaseID));
					//aiEcho("Sending OVERRUN prompt to player "+enemyPlayerID+", he has "+enemyPlayerUnitCount+" units.");
					//aiEcho("I have "+armySize+" units, and "+gGoodArmyPop+" is a good army size.");
					return;
				}
				if (enemyPlayerUnitCount > (2 * gGoodArmyPop))
				{ // Big army, but I'm still in the fight
					sendStatement(enemyPlayerID, cAICommPromptToEnemyISpotHisArmyMyBaseLarge, kbBaseGetLocation(cMyID, gDefenseReflexBaseID));
					//aiEcho("Sending LARGE ARMY prompt to player "+enemyPlayerID+", he has "+enemyPlayerUnitCount+" units.");
					//aiEcho("I have "+armySize+" units, and "+gGoodArmyPop+" is a good army size.");
					return;
				}
				if (enemyPlayerUnitCount > gGoodArmyPop)
				{
					// Moderate size
					sendStatement(enemyPlayerID, cAICommPromptToEnemyISpotHisArmyMyBaseMedium, kbBaseGetLocation(cMyID, gDefenseReflexBaseID));
					//aiEcho("Sending MEDIUM ARMY prompt to player "+enemyPlayerID+", he has "+enemyPlayerUnitCount+" units.");
					//aiEcho("I have "+armySize+" units, and "+gGoodArmyPop+" is a good army size.");
					return;
				}
				if ((enemyPlayerUnitCount < gGoodArmyPop) && (enemyPlayerUnitCount < armySize))
				{ // Small, and under control
					sendStatement(enemyPlayerID, cAICommPromptToEnemyISpotHisArmyMyBaseSmall, kbBaseGetLocation(cMyID, gDefenseReflexBaseID));
					//aiEcho("Sending SMALL ARMY prompt to player "+enemyPlayerID+", he has "+enemyPlayerUnitCount+" units.");
					//aiEcho("I have "+armySize+" units, and "+gGoodArmyPop+" is a good army size.");
					return;
				}
			}
		}
		return; // Do not check other bases
	}

	// If we're this far, the main base is OK.  If we're in a defense reflex, see if we should stay in it, or change from passive to active.

	if (gDefenseReflex == true) // Currently in a defense mode, let's see if it should remain
	{
		kbUnitQueryResetResults(enemyArmyQuery);
		kbUnitQuerySetPosition(enemyArmyQuery, gDefenseReflexLocation);
		kbUnitQuerySetMaximumDistance(enemyArmyQuery, cvDefenseReflexSearchRadius);
		kbUnitQuerySetSeeableOnly(enemyArmyQuery, true);
		kbUnitQuerySetState(enemyArmyQuery, cUnitStateAlive);
		enemyArmySize = kbUnitQueryExecute(enemyArmyQuery);
		//aiEcho("******** Defense reflex in base "+gDefenseReflexBaseID+" at "+gDefenseReflexLocation);
		//aiEcho("******** Enemy unit count: "+enemyArmySize+", my unit count (defend+reserve) = "+armySize);
		for (i = 0; < enemyArmySize)
		{
			unitID = kbUnitQueryGetResult(enemyArmyQuery, i);
			protoUnitID = kbUnitGetProtoUnitID(unitID);
			if (i < 2)
				aiEcho("    " + unitID + " " + kbGetProtoUnitName(protoUnitID) + " " + kbUnitGetPosition(unitID));
		}

		if (enemyArmySize < 2)
		{ // Abort, no enemies, or just one scouting unit
			//aiEcho("******** Ending defense reflex, no enemies remain.");
			endDefenseReflex();
			return;
		}


		if (getBaseBuildingCount(gDefenseReflexBaseID,cPlayerRelationSelf ,cUnitTypeBuilding) <= 0)
		{ // Abort, no buildings
			//aiEcho("******** Ending defense reflex, base "+gDefenseReflexBaseID+" has no buildings.");
			endDefenseReflex();
			return;
		}

		if (kbBaseGetOwner(gDefenseReflexBaseID) <= 0)
		{ // Abort, base doesn't exist
			//aiEcho("******** Ending defense reflex, base "+gDefenseReflexBaseID+" doesn't exist.");
			endDefenseReflex();
			return;
		}

		// The defense reflex for this base should remain in effect.
		// Check whether to start/end paused mode.
		int unitsNeeded = gGoodArmyPop; // At least a credible army to fight them
		if (unitsNeeded > (enemyArmySize / 2)) // Or half their force, whichever is less.
			unitsNeeded = enemyArmySize / 2;
		bool shouldPause = false;
		if ((armySize < unitsNeeded) && ((armySize * 3.0) < enemyArmySize))
			shouldPause = true; // We should pause if not paused, or stay paused if we are

		if (gDefenseReflexPaused == false)
		{ // Not currently paused, do it
			if (shouldPause == true)
			{
				pauseDefenseReflex();
				//aiEcho("******** Enemy count "+enemyArmySize+", my army count "+armySize);
			}
		}
		else
		{ // Currently paused...should we remain paused, or go active?
			if (shouldPause == false)
			{
				moveDefenseReflex(gDefenseReflexLocation, cvDefenseReflexRadiusActive, gDefenseReflexBaseID); // Activate it 
				//aiEcho("******** Enemy count "+enemyArmySize+", my army count "+armySize);
			}
		}
		if (shouldPause == true)
		{ // Consider a call for help
			panic = true;
			if (((gCurrentGameTime - lastHelpTime) < 300000) && (lastHelpBaseID == gDefenseReflexBaseID)) // We called for help in the last five minutes, and it was this base
				panic = false;
			if (((gCurrentGameTime - lastHelpTime) < 60000) && (lastHelpBaseID != gDefenseReflexBaseID)) // We called for help anywhere in the last minute
				panic = false;

			if (panic == true)
			{
				sendStatement(cPlayerRelationAlly, cAICommPromptToAllyINeedHelpMyBase, kbBaseGetLocation(cMyID, gDefenseReflexBaseID));
				//aiEcho("     I'm calling for help.");
				lastHelpTime = gCurrentGameTime;
			}
		}
		return; // Done...we're staying in defense mode for this base, and have paused or gone active as needed.
	}


	// Not in a defense reflex, see if one is needed

	// Check other bases
	int baseCount = -1;
	int baseIndex = -1;
	int baseID = -1;

	baseCount = kbBaseGetNumber(cMyID);
	unitsNeeded = gGoodArmyPop / 2;
	if (baseCount > 0)
	{
		for (baseIndex = 0; < baseCount)
		{
			baseID = kbBaseGetIDByIndex(cMyID, baseIndex);
			if (baseID == kbBaseGetMainID(cMyID))
				continue; // Already checked main at top of function

			if (getBaseBuildingCount(baseID, cPlayerRelationSelf ,cUnitTypeBuilding) <= 0)
			{
				//aiEcho("Base "+baseID+" has no buildings.");
				continue; // Skip bases that have no buildings
			}

			// Check for overrun base
			kbUnitQueryResetResults(enemyArmyQuery);
			kbUnitQuerySetPosition(enemyArmyQuery, kbBaseGetLocation(cMyID, baseID));
			kbUnitQuerySetMaximumDistance(enemyArmyQuery, cvDefenseReflexSearchRadius);
			kbUnitQuerySetSeeableOnly(enemyArmyQuery, true);
			kbUnitQuerySetState(enemyArmyQuery, cUnitStateAlive);		
			enemyArmySize = kbUnitQueryExecute(enemyArmyQuery);
			// Do I need to call for help?

			if ((enemyArmySize >= 2))
			{ // More than just a scout...set defense reflex for this base
				moveDefenseReflex(kbBaseGetLocation(cMyID, baseID), cvDefenseReflexRadiusActive, baseID);
				//aiEcho("******** Enemy count is "+enemyArmySize+", my army size is "+armySize);                  

				if ((enemyArmySize > (armySize * 2.0)) && (enemyArmySize > 6)) // Double my size, get help...
				{
					panic = true;
					if (((gCurrentGameTime - lastHelpTime) < 300000) && (lastHelpBaseID == baseID)) // We called for help in the last five minutes, and it was this base
						panic = false;
					if (((gCurrentGameTime - lastHelpTime) < 60000) && (lastHelpBaseID != baseID)) // We called for help anywhere in the last minute
						panic = false;

					if (panic == true)
					{
						// Don't kill other missions, this isn't the main base.  Just call for help.
						sendStatement(cPlayerRelationAlly, cAICommPromptToAllyINeedHelpMyBase, kbBaseGetLocation(cMyID, baseID));
						//aiEcho("     I'm calling for help.");
						lastHelpTime = gCurrentGameTime;
					}

				}
				return; // If we're in trouble in any base, ignore the others.
			}
		} // For baseIndex...
	}
}


void reflexMain()
{

}