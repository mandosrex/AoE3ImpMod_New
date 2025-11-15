//init

//==============================================================================
// init...Called once we have units in the new world.
//==============================================================================
void init(void)
{
	//Set the Explore Danger Threshold.
	aiSetExploreDangerThreshold(110.0);

	//Setup the resign handler
	aiSetHandler("resignHandler", cXSResignHandler);

	//Setup the nugget handler
	aiSetHandler("nuggetHandler", cXSNuggetHandler);

	// Set up the age-up chat handler
	aiSetHandler("ageUpHandler", cXSPlayerAgeHandler);
	
	//-- set the ScoreOppHandler
	aiSetHandler("scoreOpportunity", cXSScoreOppHandler);

	//Set up the communication handler
	aiCommsSetEventHandler("commHandler");

	// This handler runs when you have a shipment available in the home city
	aiSetHandler("shipGrantedHandler", cXSShipResourceGranted);

	// Handlers for mission start/end
	aiSetHandler("missionStartHandler", cXSMissionStartHandler);
	aiSetHandler("missionEndHandler", cXSMissionEndHandler);

	// Game ending handler, to save game-to-game data before game ends
	aiSetHandler("gameOverHandler", cXSGameOverHandler);

	// Handler when a player starts the monopoly victory timer
	aiSetHandler("monopolyStartHandler", cXSMonopolyStartHandler);

	// And when a monopoly timer prematurely ends
	aiSetHandler("monopolyEndHandler", cXSMonopolyEndHandler);

	// Handler when a player starts the KOTH victory timer
	aiSetHandler("KOTHVictoryStartHandler", cXSKOTHVictoryStartHandler);

	// And when a KOTH timer prematurely ends
	aiSetHandler("KOTHVictoryEndHandler", cXSKOTHVictoryEndHandler);

	//-- init Econ and Military stuff.

	aiSetAttackResponseDistance(70.0);
	mostHatedEnemy();
	aiSetAutoGatherMilitaryUnits(true);

	if ((gGameType == cGameTypeCampaign) || (gGameType == cGameTypeScenario))
		cvOkToResign = false; // Default is to not allow resignation in scenarios.  Can override in postInit().

	// Fishing always viable on these maps
	/*
	if ((cRandomMapName == "carolina") ||
        (cRandomMapName == "carolinalarge") ||
        (cRandomMapName == "newengland") ||
        (cRandomMapName == "caribbean") ||
        (cRandomMapName == "patagonia") ||
        (cRandomMapName == "yucatan") ||
        (cRandomMapName == "newguinea") ||
        (cRandomMapName == "bosphorus") ||
        (cRandomMapName == "hispaniola") ||
        (cRandomMapName == "araucania") ||
        (cRandomMapName == "california") ||
        (cRandomMapName == "northwestterritory") ||
        (cRandomMapName == "saguenay") ||
        (cRandomMapName == "saguenaylarge") ||
        (cRandomMapName == "unknown") ||
        (cRandomMapName == "ceylon") ||
        (cRandomMapName == "borneo") ||
        (cRandomMapName == "honshu") ||
        (cRandomMapName == "regicidehonshu") ||
        (cRandomMapName == "korea") ||
        (cRandomMapName == "alaska") ||
        (cRandomMapName == "bajacalifornia") ||
        (cRandomMapName == "dhaka") ||
        (cRandomMapName == "florida") ||
        (cRandomMapName == "indonesia") ||
        (cRandomMapName == "malaysia") ||
        (cRandomMapName == "manchuria") ||
        (cRandomMapName == "thailand") ||
        (cRandomMapName == "volgadelta") ||
        (cRandomMapName == "micronesia") ||
        (cRandomMapName == "shikoku"))
    {
		//gGoodFishingMap = true;
	}
	if (gSPC == false)
		if (gNavyFlagUnit > 0) // We have a flag, there must be water...
			//gGoodFishingMap = true;

	if (gSPC == true)
	{
		if (aiIsMapType("AIFishingUseful") == true)
			//gGoodFishingMap = true;
		else
			//gGoodFishingMap = false;
	}
*/

	if (kbUnitCount(cMyID, cUnitTypeHomeCityWaterSpawnFlag) > 0) 
	{
		gNavyVec = kbUnitGetPosition(getUnit(cUnitTypeHomeCityWaterSpawnFlag, cMyID));
		gNavyMap = true; // We have a flag, there must be water...
	}
	
	

	// natives aim for slightly more villagers (fire pit dancers!)
	if (getCivIsNative() == true)
	{
		int i = 0;
		for (i = 0; <= cAge5)
		{
			xsArraySetInt(gTargetSettlerCounts, i, xsArrayGetInt(gTargetSettlerCounts, i) * 1.1);
		}
	}


	// Create a temporary main base so the plans have something to deal with.
	// If there is a scenarioStart object, use it.  If not, use the TC, if any.
	// Failing that, use an explorer, a war chief, a monk, a settlerWagon, or a Settler.  
	// Failing that, select any freakin' unit and use it.
	vector tempBaseVec = cInvalidVector;
	int unitID = -1;
	unitID = getUnit(cUnitTypeAIStart, cMyID, cUnitStateAlive);
	if (unitID < 0)
		unitID = getUnit(gTownCenter, cMyID, cUnitStateAlive);
	if (unitID < 0)
		unitID = getUnit(gExplorerUnit, cMyID, cUnitStateAlive);
	if (unitID < 0)
		unitID = getUnit(cUnitTypexpAztecWarchief, cMyID, cUnitStateAlive);
	if (unitID < 0)
		unitID = getUnit(cUnitTypexpIroquoisWarChief, cMyID, cUnitStateAlive);
	if (unitID < 0)
		unitID = getUnit(cUnitTypexpLakotaWarchief, cMyID, cUnitStateAlive);
	if (unitID < 0)
		unitID = getUnit(cUnitTypeypMonkChinese, cMyID, cUnitStateAlive);
	if (unitID < 0)
		unitID = getUnit(cUnitTypeypMonkIndian, cMyID, cUnitStateAlive);
	if (unitID < 0)
		unitID = getUnit(cUnitTypeypMonkIndian2, cMyID, cUnitStateAlive);
	if (unitID < 0)
		unitID = getUnit(cUnitTypeypMonkJapanese, cMyID, cUnitStateAlive);
	if (unitID < 0)
		unitID = getUnit(cUnitTypeypMonkJapanese2, cMyID, cUnitStateAlive);
	if (unitID < 0)
		unitID = getUnit(gCoveredWagonUnit, cMyID, cUnitStateAlive);
	if (unitID < 0)
		unitID = getUnit(cUnitTypeSettler, cMyID, cUnitStateAlive);
	if (unitID < 0)
		unitID = getUnit(gEconUnit, cMyID, cUnitStateAlive);

	if (unitID < 0)
		aiEcho("**** I give up...I can't find an aiStart unit, TC, wagon, explorer or settler.  How do you expect me to play?!");
	else
		tempBaseVec = kbUnitGetPosition(unitID);

	// This will create an interim main base at this location. 
	// Only done if there is no TC, otherwise we rely on the auto-created base
	if ((gStartMode == gStartModeScenarioNoTC) || (getUnit(gTownCenter, cMyID, cUnitStateAlive) < 0))
	{
		gMainBase = createMainBase(tempBaseVec);
	}
	// If we have a covered wagon, let's pick a spot for the TC search to begin, and a TC start time to activate the build plan.
	int coveredWagon = getUnit(gCoveredWagonUnit, cMyID, cUnitStateAlive);
	if (coveredWagon >= 0)
	{
		vector coveredWagonPos = kbUnitGetPosition(coveredWagon);
		vector normalVec = xsVectorNormalize(gMapCenter - coveredWagonPos);
		int offset = 40;
		gTCSearchVector = coveredWagonPos + (normalVec * offset);

		while (kbAreaGroupGetIDByPosition(gTCSearchVector) != kbAreaGroupGetIDByPosition(coveredWagonPos))
		{
			// Try for a goto point 40 meters toward center.  Fall back 5m at a time if that's on another continent/ocean.  
			// If under 5, we'll take it.
			offset = offset - 5;
			gTCSearchVector = coveredWagonPos + (normalVec * offset);
			if (offset < 5)
				break;
		}

		// Note...if this is a scenario, we should use the AIStart object's position, NOT the covered wagon position.  Override...
		int aiStart = getUnit(cUnitTypeAIStart, cMyID, cUnitStateAny);
		if (aiStart >= 0)
		{
			gTCSearchVector = kbUnitGetPosition(aiStart);
			//aiEcho("Using aiStart object at "+gTCSearchVector+" to start TC placement search");
		}
	}


	// Keep Dutch envoy busy
	//xsEnableRule("envoyMonitor");

	// Keep native scouts busy
	//xsEnableRule("nativeScoutMonitor");

	// Keep mongol scouts busy
	//xsEnableRule("mongolScoutMonitor");

	// Enable explorer rescue plan
	//xsEnableRule("rescueExplorer");

	// Enable explorer ransoming
	//xsEnableRule("ransomExplorer");

	// Disables early groups, starts nugget hunting, moves explorer later.
	//xsEnableRule("exploreMonitor");

	if ((gStartMode == gStartModeScenarioWagon) ||
		(gStartMode == gStartModeLandWagon) ||
		(gStartMode == gStartModeBoat))
	{
		//aiEcho("Creating a TC build plan.");
		// Make a town center, pri 100, econ, main base, 1 builder.
		int buildPlan = aiPlanCreate("TC Build plan ", cPlanBuild);
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
		if ((gStartMode == gStartModeBoat) && (kbUnitCount(cMyID, gCoveredWagonUnit, cUnitStateAlive) == 0))
		{
			switch (kbGetCiv())
			{
				case cCivXPAztec:
					{
						aiPlanAddUnitType(buildPlan, cUnitTypexpAztecWarchief, 1, 1, 1);
						break;
					}
				case cCivXPIroquois:
					{
						aiPlanAddUnitType(buildPlan, cUnitTypexpIroquoisWarChief, 1, 1, 1);
						break;
					}
				case cCivXPSioux:
					{
						aiPlanAddUnitType(buildPlan, cUnitTypexpLakotaWarchief, 1, 1, 1);
						break;
					}
				case cCivChinese:
					{
						aiPlanAddUnitType(buildPlan, cUnitTypeypMonkChinese, 1, 1, 1);
						break;
					}
				case cCivIndians:
					{
						aiPlanAddUnitType(buildPlan, cUnitTypeypMonkIndian, 1, 1, 1);
						aiPlanAddUnitType(buildPlan, cUnitTypeypMonkIndian2, 1, 1, 1);
						break;
					}
				case cCivJapanese:
					{
						aiPlanAddUnitType(buildPlan, cUnitTypeypMonkJapanese, 1, 1, 1);
						aiPlanAddUnitType(buildPlan, cUnitTypeypMonkJapanese2, 1, 1, 1);
						break;
					}
				default:
					{
						aiPlanAddUnitType(buildPlan, gExplorerUnit, 1, 1, 1);
						break;
					}
			}
		}
		else
		{
			aiPlanAddUnitType(buildPlan, gCoveredWagonUnit, 1, 1, 1);
		}
		// Instead of base ID or areas, use a center position and falloff.
		if (gTCSearchVector == cInvalidVector)
			aiPlanSetVariableVector(buildPlan, cBuildPlanCenterPosition, 0, coveredWagonPos);
		else
			aiPlanSetVariableVector(buildPlan, cBuildPlanCenterPosition, 0, gTCSearchVector);
		aiPlanSetVariableFloat(buildPlan, cBuildPlanCenterPositionDistance, 0, 40.00);

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
		aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitDistance, 1, 50.0); // 50 meter range for gold
		aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitValue, 1, 300.0); // 300 points each
		aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitFalloff, 1, cBPIFalloffLinear); // Linear slope falloff
		aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitTypeID, 2, cUnitTypeMine);
		aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitDistance, 2, 20.0); // 20 meter inhibition to keep some space
		aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitValue, 2, -300.0); // -300 points each
		aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitFalloff, 2, cBPIFalloffNone); // Cliff falloff

		// Two position weights
		aiPlanSetNumberVariableValues(buildPlan, cBuildPlanInfluencePosition, 2, true);
		aiPlanSetNumberVariableValues(buildPlan, cBuildPlanInfluencePositionDistance, 2, true);
		aiPlanSetNumberVariableValues(buildPlan, cBuildPlanInfluencePositionValue, 2, true);
		aiPlanSetNumberVariableValues(buildPlan, cBuildPlanInfluencePositionFalloff, 2, true);

		// Give it a positive but wide-range prefernce for the search area, and a more intense but smaller negative to avoid the landing area.
		// Weight it to prefer the general starting neighborhood
		aiPlanSetVariableVector(buildPlan, cBuildPlanInfluencePosition, 0, gTCSearchVector); // Position influence for search position
		aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluencePositionDistance, 0, 200.0); // 200m range.
		aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluencePositionValue, 0, 300.0); // 300 points max
		aiPlanSetVariableInt(buildPlan, cBuildPlanInfluencePositionFalloff, 0, cBPIFalloffLinear); // Linear slope falloff

		// Add negative weight to avoid initial drop-off beach area
		aiPlanSetVariableVector(buildPlan, cBuildPlanInfluencePosition, 1, gMainBaseLocation); // Position influence for landing position
		aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluencePositionDistance, 1, 50.0); // Smaller, 50m range.
		aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluencePositionValue, 1, -400.0); // -400 points max
		aiPlanSetVariableInt(buildPlan, cBuildPlanInfluencePositionFalloff, 1, cBPIFalloffLinear); // Linear slope falloff
		// This combo will make it dislike the immediate landing (-100), score +25 at 50m, score +150 at 100m, then gradually fade to +0 at 200m.


		// Wait to activate TC build plan, to allow adequate exploration
		gTCBuildPlanID = buildPlan; // Save in a global var so the rule can access it.
		aiPlanSetEventHandler(buildPlan, cPlanEventStateChange, "tcPlacedEventHandler");

		//xsEnableRule("tcBuildPlanDelay");
	}

	

	xsEnableRule("townCenterComplete"); // Rule to build other buildings after TC completion
	//xsEnableRule("coveredWagonMonitor");   
	//xsEnableRule("factoryWagonMonitor");
	//xsEnableRule("tcMonitor"); // Has explorer, war chief, Asian monks or settlers build a TC if there is none
	//xsEnableRule("ageUpgradeMonitor"); // Make sure we freeze spending to allow age-ups at certain villie pop levels


	postInit(); // All normal initialization is done, let loader file clean up what it needs to.

	//aiEcho("INITIAL BEHAVIOR SETTINGS");
	//aiEcho("    Rush "+btRushBoom);
	//aiEcho("    Offense "+btOffenseDefense);
	//aiEcho("    Cav "+btBiasCav);
	//aiEcho("    Inf "+btBiasInf);
	//aiEcho("    Art "+btBiasArt);
	//aiEcho("    Natives "+btBiasNative);
	//aiEcho("    Trade "+btBiasTrade);

	// Re-do politician choices now that postInit() is complete...
	int poliScores = xsArrayCreateFloat(6, 0.0, "Politician scores");
	int numChoices = -1;
	int politician = -1;
	float bonus = 0.0;

	for (age = cAge2; <= cAge5)
	{
		for (p = 0; < 6)
			xsArraySetFloat(poliScores, p, 0.0); // Reset scores
		numChoices = aiGetPoliticianListCount(age);
		for (p = 0; < numChoices)
		{ // Score each of these choices based on the strength of our behavior settings.
			politician = aiGetPoliticianListByIndex(age, p);
			// Rusher bonuses
			if (btRushBoom > 0.0)
				bonus = btRushBoom;
			else
				bonus = 0.0;
			if ((politician == cTechPoliticianQuartermaster) ||
				(politician == cTechPoliticianScout) ||
				(politician == cTechPoliticianScoutRussian) ||
				(politician == cTechPoliticianSergeantDutch) ||
				(politician == cTechPoliticianSergeantGerman) ||
				(politician == cTechPoliticianSergeantSpanish) ||
				(politician == cTechPoliticianMohawk) ||
				(politician == cTechPoliticianMarksman) ||
				(politician == cTechPoliticianMarksmanOttoman) ||
				(politician == cTechPoliticianMarksmanPortuguese) ||
				(politician == cTechPoliticianAdventurerBritish) ||
				(politician == cTechPoliticianAdventurerRussian) ||
				(politician == cTechPoliticianAdventurerSpanish))
			{
				xsArraySetFloat(poliScores, p, xsArrayGetFloat(poliScores, p) + bonus); // Add in a bonus based on our rusher trait.
			}
			// Boomer bonuses
			if (btRushBoom < 0.0)
				bonus = -1.0 * btRushBoom;
			else
				bonus = 0.0;
			if ((politician == cTechPoliticianBishop) ||
				(politician == cTechPoliticianBishopGerman) ||
				(politician == cTechPoliticianTycoon) ||
				(politician == cTechPoliticianExiledPrince) ||
				(politician == cTechPoliticianPresidenteEU) ||
				(politician == cTechPoliticianPresidente))
			{
				xsArraySetFloat(poliScores, p, xsArrayGetFloat(poliScores, p) + bonus); // Add in a bonus based on our boomer trait.
			}
			// Defense bonuses
			if (btOffenseDefense < 0.0)
				bonus = -1.0 * btOffenseDefense; // Defense rating
			else
				bonus = 0.0;
			if (politician == cTechPoliticianGovernor)
			{
				xsArraySetFloat(poliScores, p, xsArrayGetFloat(poliScores, p) + bonus); // Add in a bonus based on our defense trait.
			}
			// Offense bonuses
			if (btOffenseDefense > 0.0)
				bonus = btOffenseDefense;
			else
				bonus = 0.0;
			if ((politician == cTechPoliticianScout) ||
				(politician == cTechPoliticianScoutRussian) ||
				(politician == cTechPoliticianSergeantDutch) ||
				(politician == cTechPoliticianSergeantGerman) ||
				(politician == cTechPoliticianSergeantSpanish) ||
				(politician == cTechPoliticianMohawk) ||
				(politician == cTechPoliticianMarksman) ||
				(politician == cTechPoliticianMarksmanOttoman) ||
				(politician == cTechPoliticianMarksmanPortuguese) ||
				(politician == cTechPoliticianAdventurerBritish) ||
				(politician == cTechPoliticianAdventurerRussian) ||
				(politician == cTechPoliticianAdventurerSpanish) ||
				(politician == cTechPoliticianGeneral) ||
				(politician == cTechPoliticianGeneralUSA) ||
				(politician == cTechPoliticianGeneralBritish) ||
				(politician == cTechPoliticianGeneralOttoman))
			{
				xsArraySetFloat(poliScores, p, xsArrayGetFloat(poliScores, p) + bonus); // Add in a bonus based on our offense trait.
			}
			if (gNavyMap == false)
			{
				bonus = -10.0; // Essentially disqualify any navy polis
				if ((politician == cTechPoliticianAdmiral) ||
					(politician == cTechPoliticianAdmiralOttoman) ||
					(politician == cTechPoliticianPirate))
				{
					xsArraySetFloat(poliScores, p, xsArrayGetFloat(poliScores, p) + bonus); // Disqualify naval polis on land maps
				}
			}
		} // for (p=0; <numChoices)

		// The scores are set, find the high score
		int bestChoice = 0; // Select 0th item if all else fails
		float bestScore = -100.0; // Impossibly low
		for (p = 0; < numChoices)
		{
			if (xsArrayGetFloat(poliScores, p) > bestScore)
			{
				bestScore = xsArrayGetFloat(poliScores, p);
				bestChoice = p;
			}
		}
		politician = aiGetPoliticianListByIndex(age, bestChoice);
		aiSetPoliticianChoice(age, politician);
		//aiEcho("Politician for age "+age+" is #"+politician+", "+kbGetTechName(politician));
	} //for (age = cAge2; <= cAge5)
		
	gMapTypeIsland = getMapIsIsland();
}

rule resignDelayTimer
inactive
minInterval 1
{
	//if(cMyID != 2) return;
	//if(gCurrentGameTime < 300000) return;
	gCurrentWood = kbResourceGet(cResourceWood);
	gCurrentFood = kbResourceGet(cResourceFood);
	gCurrentCoin = kbResourceGet(cResourceGold);
	
	static int count = 0;
	static bool removeAllUnits = false;
	count++;
	
	int humanPlayer = getHumanOnTeam();
	int aiPlayer = getAIOnTeam();
	if(humanPlayer != -1)
	{
		if(gCurrentWood > 500) aiTribute(humanPlayer, cResourceWood, (gCurrentWood - 500));	
		if(gCurrentFood > 500) aiTribute(humanPlayer, cResourceFood, (gCurrentFood - 500));
		if(gCurrentCoin > 500) aiTribute(humanPlayer, cResourceGold, (gCurrentCoin - 500));			
	}
	else if(aiPlayer != -1)
	{
		if(gCurrentWood > 500) aiTribute(1, cResourceWood, (gCurrentWood - 500));	
		if(gCurrentFood > 500) aiTribute(1, cResourceFood, (gCurrentFood - 500));
		if(gCurrentCoin > 500) aiTribute(1, cResourceGold, (gCurrentCoin - 500));	
	}

	if((gCurrentFood < 1000 && gCurrentWood < 1000 && gCurrentCoin < 1000 && removeAllUnits == false) || count == 3)
	{
		static int queryBuildingID = -1;
		if(queryBuildingID == -1) queryBuildingID = kbUnitQueryCreate("resignDelteBuilding");
		kbUnitQueryResetResults(queryBuildingID);
		kbUnitQuerySetPlayerID(queryBuildingID, cMyID, true);
		kbUnitQuerySetUnitType(queryBuildingID, cUnitTypeMilitaryBuilding);  //cUnitTypeBuilding
		kbUnitQuerySetState(queryBuildingID, cUnitStateABQ);
		for (x = 0; < kbUnitQueryExecute(queryBuildingID))
		{
			if(kbUnitIsType( kbUnitQueryGetResult(queryBuildingID, x), gTownCenter ) == true) continue; 
			aiTaskUnitDelete( kbUnitQueryGetResult(queryBuildingID, x) );
		}
		
		static int queryUnitID = -1;
		if(queryUnitID == -1) queryUnitID = kbUnitQueryCreate("resignDelteUnits");
		kbUnitQueryResetResults(queryUnitID);
		kbUnitQuerySetPlayerID(queryUnitID, cMyID, true);
		kbUnitQuerySetUnitType(queryUnitID, cUnitTypeUnit);
		kbUnitQuerySetState(queryUnitID, cUnitStateABQ);
		
		for (x = 0; < kbUnitQueryExecute(queryUnitID))
		{
			aiTaskUnitDelete( kbUnitQueryGetResult(queryUnitID, x) );
		}
		
		kbUnitQueryResetResults(queryBuildingID);
		kbUnitQuerySetPlayerID(queryBuildingID, cMyID, true);
		kbUnitQuerySetUnitType(queryBuildingID, gTownCenter);
		kbUnitQuerySetState(queryBuildingID, cUnitStateABQ);
		for (x = 0; < kbUnitQueryExecute(queryBuildingID))
		{
			if(kbUnitIsType( kbUnitQueryGetResult(queryBuildingID, x), gTownCenter ) != true) continue; 
			aiTaskUnitDelete( kbUnitQueryGetResult(queryBuildingID, x) );
		}
		removeAllUnits = true;
	}
	if(gCurrentFood < 1000 && gCurrentWood < 1000 && gCurrentCoin < 1000 && removeAllUnits == true)
	{
		aiResign();
		xsDisableSelf();
	}
	if(count == 3)
	{
		aiResign();
		xsDisableSelf();
	}
}

void resignHandler(int answer = -1)
{
	if (answer == 0) return;
	xsEnableRule("resignDelayTimer");	
}

//==============================================================================
// initRule
// Add a brief delay to make sure the covered wagon (if any) has time to unload
//==============================================================================
rule initRule
inactive
minInterval 3
{
	if (cvInactiveAI == true)
		return; // Wait forever unless this changes
	init();

	xsDisableSelf();
}

//==============================================================================
/* initArrays()
	updatedOn 2019/07/20 By ageekhere 
	Initialize all global arrays here, to make it easy to find var type and size.
*/
//==============================================================================
void initArrays(void)
{ //Initialize arrays
	gForecasts = xsArrayCreateFloat(gNumResourceTypes, 0.0, "Forecasts");
	gMapNames = xsArrayCreateString(98, "", "Map names");
	xsArraySetString(gMapNames, 0, "amazonia");
	xsArraySetString(gMapNames, 1, "bayou");
	xsArraySetString(gMapNames, 2, "caribbean");
	xsArraySetString(gMapNames, 3, "carolina");
	xsArraySetString(gMapNames, 4, "greatlakes");
	xsArraySetString(gMapNames, 5, "greatplains");
	xsArraySetString(gMapNames, 6, "newengland");
	xsArraySetString(gMapNames, 7, "pampas");
	xsArraySetString(gMapNames, 8, "patagonia");
	xsArraySetString(gMapNames, 9, "rockies");
	xsArraySetString(gMapNames, 10, "saguenay");
	xsArraySetString(gMapNames, 11, "sonora");
	xsArraySetString(gMapNames, 12, "texas");
	xsArraySetString(gMapNames, 13, "yucatan");
	xsArraySetString(gMapNames, 14, "yukon");
	xsArraySetString(gMapNames, 15, "greatplainslarge");
	xsArraySetString(gMapNames, 16, "carolinalarge");
	xsArraySetString(gMapNames, 17, "saguenaylarge");
	xsArraySetString(gMapNames, 18, "sonoraLarge");
	xsArraySetString(gMapNames, 19, "texaslarge");
	xsArraySetString(gMapNames, 20, "hispaniola");
	xsArraySetString(gMapNames, 21, "andes");
	xsArraySetString(gMapNames, 22, "ozarks");
	xsArraySetString(gMapNames, 23, "araucania");
	xsArraySetString(gMapNames, 24, "california");
	xsArraySetString(gMapNames, 25, "grandcanyon");
	xsArraySetString(gMapNames, 26, "northwestterritory");
	xsArraySetString(gMapNames, 27, "painteddesert");
	xsArraySetString(gMapNames, 28, "unknown");
	xsArraySetString(gMapNames, 29, "borneo");
	xsArraySetString(gMapNames, 30, "ceylon");
	xsArraySetString(gMapNames, 31, "deccan");
	xsArraySetString(gMapNames, 32, "himalayas");
	xsArraySetString(gMapNames, 33, "Honshu");
	xsArraySetString(gMapNames, 34, "mongolia");
	xsArraySetString(gMapNames, 35, "silkroad");
	xsArraySetString(gMapNames, 36, "yellowriverdry");
	xsArraySetString(gMapNames, 37, "yellowriverlarge");
	xsArraySetString(gMapNames, 38, "deccanLarge");
	xsArraySetString(gMapNames, 39, "himalayasupper");
	xsArraySetString(gMapNames, 40, "regicidehonshu");
	xsArraySetString(gMapNames, 41, "indochina");
	xsArraySetString(gMapNames, 42, "plymouth");
	xsArraySetString(gMapNames, 43, "siberia");
	xsArraySetString(gMapNames, 44, "siberialarge");
	xsArraySetString(gMapNames, 45, "silkroadlarge");
	xsArraySetString(gMapNames, 46, "australia");
	xsArraySetString(gMapNames, 47, "korea");
	xsArraySetString(gMapNames, 48, "oasis");
	xsArraySetString(gMapNames, 49, "tigrisflood");
	xsArraySetString(gMapNames, 50, "volgadelta");
	xsArraySetString(gMapNames, 51, "ESOCadirondacks");
	xsArraySetString(gMapNames, 52, "ESOCalaska");
	xsArraySetString(gMapNames, 53, "ESOCarizona");
	xsArraySetString(gMapNames, 54, "ESOCarkansas");
	xsArraySetString(gMapNames, 55, "ESOCbajacalifornia");
	xsArraySetString(gMapNames, 56, "ESOCbengal");
	xsArraySetString(gMapNames, 57, "ESOCberingstrait");
	xsArraySetString(gMapNames, 58, "ESOCcascaderange");
	xsArraySetString(gMapNames, 59, "ESOCcerrado");
	xsArraySetString(gMapNames, 60, "ESOCdhaka");
	xsArraySetString(gMapNames, 61, "ESOCfertilecrescent");
	xsArraySetString(gMapNames, 62, "ESOCflorida");
	xsArraySetString(gMapNames, 63, "ESOCfraserriver");
	xsArraySetString(gMapNames, 64, "ESOCgranchaco");
	xsArraySetString(gMapNames, 65, "ESOCgreatbasin");
	xsArraySetString(gMapNames, 66, "ESOChighplains");
	xsArraySetString(gMapNames, 67, "ESOCindonesia");
	xsArraySetString(gMapNames, 68, "ESOCiowa");
	xsArraySetString(gMapNames, 69, "ESOCkamchatka");
	xsArraySetString(gMapNames, 70, "ESOCklondike");
	xsArraySetString(gMapNames, 71, "ESOCmalaysia");
	xsArraySetString(gMapNames, 72, "ESOCmanchuria");
	xsArraySetString(gMapNames, 73, "ESOCmendocino");
	xsArraySetString(gMapNames, 74, "ESOCmississippi");
	xsArraySetString(gMapNames, 75, "ESOCnahanni");
	xsArraySetString(gMapNames, 76, "ESOCnewmexico");
	xsArraySetString(gMapNames, 77, "ESOCpampassierras");
	xsArraySetString(gMapNames, 78, "ESOCparallelrivers");
	xsArraySetString(gMapNames, 79, "ESOCthailand");
	xsArraySetString(gMapNames, 80, "ESOCthardesert");
	xsArraySetString(gMapNames, 81, "ESOCtibet");
	xsArraySetString(gMapNames, 82, "ESOCtuparro");
	xsArraySetString(gMapNames, 83, "ESOCyaluriver");
	xsArraySetString(gMapNames, 84, "ESOCzagros");
	xsArraySetString(gMapNames, 85, "regicideandes");
	xsArraySetString(gMapNames, 86, "regicidedeccan");
	xsArraySetString(gMapNames, 87, "regicidegreatlakes");
	xsArraySetString(gMapNames, 88, "regicideindochina");
	xsArraySetString(gMapNames, 89, "regicidekorea");
	xsArraySetString(gMapNames, 90, "regicidepampas");
	xsArraySetString(gMapNames, 91, "regicidesiberia");
	xsArraySetString(gMapNames, 92, "regicideyellowriver");
	xsArraySetString(gMapNames, 93, "regicideESOCcerrado");

	gTargetSettlerCounts = xsArrayCreateInt(cAge5 + 1, 0, "Target Settler Counts");
	xsArraySetInt(gTargetSettlerCounts, cAge1, 25);
	xsArraySetInt(gTargetSettlerCounts, cAge2, 50);
	xsArraySetInt(gTargetSettlerCounts, cAge3, 75);
	xsArraySetInt(gTargetSettlerCounts, cAge4, 90);
	xsArraySetInt(gTargetSettlerCounts, cAge5, 100);

	if (aiGetGameMode() == cGameModeDeathmatch)
	{ //BHG: JFR: if we are in deatmatch we dont want to research the consulate tech that takes us to age 5
		gConsulateTechsSize = 32;
	} //end if
	else
	{
		gConsulateTechsSize = 33;
	} //end else BHG: JFR:

	gConsulateTechs = xsArrayCreateInt(40, 0, "Consulate Tech IDs");
	xsArraySetInt(gConsulateTechs, 0, cTechypConsulateBritishBrigade);
	xsArraySetInt(gConsulateTechs, 1, cTechypConsulateBritishLifeGuards);
	xsArraySetInt(gConsulateTechs, 2, cTechypConsulateBritishRedcoats);
	xsArraySetInt(gConsulateTechs, 3, cTechypConsulateBritishRogersRangers);
	xsArraySetInt(gConsulateTechs, 4, cTechypConsulateDutchBrigade);
	xsArraySetInt(gConsulateTechs, 5, cTechypConsulateFrenchBrigade);
	xsArraySetInt(gConsulateTechs, 6, cTechypConsulateFrenchCoinCrates);
	xsArraySetInt(gConsulateTechs, 7, cTechypConsulateFrenchFoodCrates);
	xsArraySetInt(gConsulateTechs, 8, cTechypConsulateFrenchHotAirBalloonsPreq);
	xsArraySetInt(gConsulateTechs, 9, cTechypConsulateFrenchWoodCrates);
	xsArraySetInt(gConsulateTechs, 10, cTechypConsulateGermansBrigade);
	xsArraySetInt(gConsulateTechs, 11, cTechypConsulateGermansCoinTrickle);
	xsArraySetInt(gConsulateTechs, 12, cTechypConsulateGermansFoodTrickle);
	xsArraySetInt(gConsulateTechs, 13, cTechypConsulateGermansWoodTrickle);
	xsArraySetInt(gConsulateTechs, 14, cTechypConsulateJapaneseKoujou);
	xsArraySetInt(gConsulateTechs, 15, cTechypConsulateJapaneseMilitaryRickshaw);
	xsArraySetInt(gConsulateTechs, 16, cTechypConsulateJapaneseMasterTraining);
	xsArraySetInt(gConsulateTechs, 17, cTechypConsulateOttomansBrigade);
	xsArraySetInt(gConsulateTechs, 18, cTechypConsulateOttomansGunpowderSiege);
	xsArraySetInt(gConsulateTechs, 19, cTechypConsulateOttomansInfantrySpeed);
	xsArraySetInt(gConsulateTechs, 20, cTechypConsulateOttomansSettlerCombat);
	xsArraySetInt(gConsulateTechs, 21, cTechypConsulatePortugueseBrigade);
	xsArraySetInt(gConsulateTechs, 22, cTechypConsulatePortugueseExpeditionaryFleet);
	xsArraySetInt(gConsulateTechs, 23, cTechypConsulatePortugueseExplorationFleet);
	xsArraySetInt(gConsulateTechs, 24, cTechypConsulatePortugueseFishingFleet);
	xsArraySetInt(gConsulateTechs, 25, cTechypConsulateRussianBrigade);
	xsArraySetInt(gConsulateTechs, 26, cTechypConsulateRussianFactoryWagon);
	xsArraySetInt(gConsulateTechs, 27, cTechypConsulateRussianFortWagon);
	xsArraySetInt(gConsulateTechs, 28, cTechypConsulateSpanishBrigade);
	xsArraySetInt(gConsulateTechs, 29, cTechypConsulateSpanishEnhancedProfits);
	xsArraySetInt(gConsulateTechs, 30, cTechypConsulateSpanishFasterShipments);
	xsArraySetInt(gConsulateTechs, 31, cTechypConsulateSpanishMercantilism);

	if (aiGetGameMode() != cGameModeDeathmatch)
	{ //BHG: JFR: if we are in deatmatch we dont want to research the consulate tech that takes us to age 5...
		xsArraySetInt(gConsulateTechs, 32, cTechypConsulateJapaneseMeijiRestoration);
	} //end //...BHG: JFR:

	gAsianWonders = xsArrayCreateInt(5, 0, "Wonder Age IDs");
	int wonderchoice = aiRandInt(4); //wonder is decided by random, could be changed using logic

	if ((cMyCiv == cCivJapanese) || (cMyCiv == cCivSPCJapanese) || (cMyCiv == cCivSPCJapaneseEnemy))
	{ //Giant Buddha, Golden Pavillion, Shogunate, Torii Gates, Toshogu Shrine 
		if (wonderchoice == 0)
		{
			xsArraySetInt(gAsianWonders, 0, cUnitTypeypWJGiantBuddha2);
			xsArraySetInt(gAsianWonders, 1, cUnitTypeypWJGoldenPavillion3);
			xsArraySetInt(gAsianWonders, 2, cUnitTypeypWJShogunate4);
			xsArraySetInt(gAsianWonders, 3, cUnitTypeypWJToshoguShrine5);
		}
		else if (wonderchoice == 1)
		{
			xsArraySetInt(gAsianWonders, 0, cUnitTypeypWJGoldenPavillion2);
			xsArraySetInt(gAsianWonders, 1, cUnitTypeypWJGiantBuddha3);
			xsArraySetInt(gAsianWonders, 2, cUnitTypeypWJToshoguShrine4);
			xsArraySetInt(gAsianWonders, 3, cUnitTypeypWJShogunate5);
		}
		else if (wonderchoice == 2)
		{
			xsArraySetInt(gAsianWonders, 0, cUnitTypeypWJShogunate2);
			xsArraySetInt(gAsianWonders, 1, cUnitTypeypWJToriiGates3);
			xsArraySetInt(gAsianWonders, 2, cUnitTypeypWJGiantBuddha4);
			xsArraySetInt(gAsianWonders, 3, cUnitTypeypWJGoldenPavillion5);
		}
		else
		{
			xsArraySetInt(gAsianWonders, 0, cUnitTypeypWJToriiGates2);
			xsArraySetInt(gAsianWonders, 1, cUnitTypeypWJToshoguShrine3);
			xsArraySetInt(gAsianWonders, 2, cUnitTypeypWJGoldenPavillion4);
			xsArraySetInt(gAsianWonders, 3, cUnitTypeypWJShogunate5);
		}
	} //end if
	if ((cMyCiv == cCivChinese) || (cMyCiv == cCivSPCChinese))
	{ //Confucian Academy, Porcelain Tower, Summer Palace, Temple of Heaven, White Pagoda
		if (wonderchoice == 0)
		{
			xsArraySetInt(gAsianWonders, 0, cUnitTypeypWCConfucianAcademy2);
			xsArraySetInt(gAsianWonders, 1, cUnitTypeypWCPorcelainTower3);
			xsArraySetInt(gAsianWonders, 2, cUnitTypeypWCSummerPalace4);
			xsArraySetInt(gAsianWonders, 3, cUnitTypeypWCTempleOfHeaven5);
		}
		else if (wonderchoice == 1)
		{
			xsArraySetInt(gAsianWonders, 0, cUnitTypeypWCWhitePagoda2);
			xsArraySetInt(gAsianWonders, 1, cUnitTypeypWCConfucianAcademy3);
			xsArraySetInt(gAsianWonders, 2, cUnitTypeypWCSummerPalace4);
			xsArraySetInt(gAsianWonders, 3, cUnitTypeypWCPorcelainTower5);
		}
		else if (wonderchoice == 2)
		{
			xsArraySetInt(gAsianWonders, 0, cUnitTypeypWCSummerPalace2);
			xsArraySetInt(gAsianWonders, 1, cUnitTypeypWCWhitePagoda3);
			xsArraySetInt(gAsianWonders, 2, cUnitTypeypWCTempleOfHeaven4);
			xsArraySetInt(gAsianWonders, 3, cUnitTypeypWCConfucianAcademy5);
		}
		else
		{
			xsArraySetInt(gAsianWonders, 0, cUnitTypeypWCTempleOfHeaven2);
			xsArraySetInt(gAsianWonders, 1, cUnitTypeypWCWhitePagoda3);
			xsArraySetInt(gAsianWonders, 2, cUnitTypeypWCSummerPalace4);
			xsArraySetInt(gAsianWonders, 3, cUnitTypeypWCConfucianAcademy5);
		}
	} //end if
	if ((cMyCiv == cCivIndians) || (cMyCiv == cCivSPCIndians))
	{ //Agra Fort, Charminar Gate, Karni Mata, Taj Mahal, Tower of Victory
		if (wonderchoice == 0)
		{
			xsArraySetInt(gAsianWonders, 0, cUnitTypeypWIAgraFort2);
			xsArraySetInt(gAsianWonders, 1, cUnitTypeypWICharminarGate3);
			xsArraySetInt(gAsianWonders, 2, cUnitTypeypWIKarniMata4);
			xsArraySetInt(gAsianWonders, 3, cUnitTypeypWITajMahal5);
		}
		else if (wonderchoice == 1)
		{
			xsArraySetInt(gAsianWonders, 0, cUnitTypeypWITowerOfVictory2);
			xsArraySetInt(gAsianWonders, 1, cUnitTypeypWIAgraFort3);
			xsArraySetInt(gAsianWonders, 2, cUnitTypeypWICharminarGate4);
			xsArraySetInt(gAsianWonders, 3, cUnitTypeypWIKarniMata5);
		}
		else if (wonderchoice == 2)
		{
			xsArraySetInt(gAsianWonders, 0, cUnitTypeypWICharminarGate2);
			xsArraySetInt(gAsianWonders, 1, cUnitTypeypWITajMahal3);
			xsArraySetInt(gAsianWonders, 2, cUnitTypeypWIAgraFort4);
			xsArraySetInt(gAsianWonders, 3, cUnitTypeypWITowerOfVictory5);
		}
		else
		{
			xsArraySetInt(gAsianWonders, 0, cUnitTypeypWITajMahal2);
			xsArraySetInt(gAsianWonders, 1, cUnitTypeypWIKarniMata3);
			xsArraySetInt(gAsianWonders, 2, cUnitTypeypWITowerOfVictory4);
			xsArraySetInt(gAsianWonders, 3, cUnitTypeypWICharminarGate5);
		}
	} //end if

	gAge2PoliticianList = xsArrayCreateInt(7, 0, "Age 2 Politician List");
	xsArraySetInt(gAge2PoliticianList, 0, cTechPoliticianQuartermaster );
	xsArraySetInt(gAge2PoliticianList, 1, cTechPoliticianGovernor);
	xsArraySetInt(gAge2PoliticianList, 2, cTechPoliticianPhilosopherPrince);
	xsArraySetInt(gAge2PoliticianList, 3, cTechPoliticianNaturalist);
	xsArraySetInt(gAge2PoliticianList, 4, cTechPoliticianBishop);
	xsArraySetInt(gAge2PoliticianList, 5, cTechPoliticianDiplomat);
	xsArraySetInt(gAge2PoliticianList, 6, cTechPoliticianArtist);

	gAge3PoliticianList = xsArrayCreateInt(8, 0, "Age 3 Politician List");
	xsArraySetInt(gAge3PoliticianList, 0, cTechPoliticianExiledPrince);
	xsArraySetInt(gAge3PoliticianList, 1, cTechPoliticianAdmiral);
	xsArraySetInt(gAge3PoliticianList, 2, cTechPoliticianMarksman);
	xsArraySetInt(gAge3PoliticianList, 3, cTechPoliticianSergeant);
	xsArraySetInt(gAge3PoliticianList, 4, cTechPoliticianAdventurer);
	xsArraySetInt(gAge3PoliticianList, 5, cTechPoliticianScout);
	xsArraySetInt(gAge3PoliticianList, 6, cTechPoliticianMohawk);
	xsArraySetInt(gAge3PoliticianList, 7, cTechPoliticianPirate);

	gAge4PoliticianList = xsArrayCreateInt(8, 0, "Age 4 Politician List");
	xsArraySetInt(gAge4PoliticianList, 0, cTechPoliticianTycoon);
	xsArraySetInt(gAge4PoliticianList, 1, cTechPoliticianMusketeer);
	xsArraySetInt(gAge4PoliticianList, 2, cTechPoliticianGrandVizier);
	xsArraySetInt(gAge4PoliticianList, 3, cTechPoliticianEngineer);
	xsArraySetInt(gAge4PoliticianList, 4, cTechPoliticianCavalier);
	xsArraySetInt(gAge4PoliticianList, 5, cTechPoliticianWarMinister);
	xsArraySetInt(gAge4PoliticianList, 6, cTechPoliticianViceroy);
	xsArraySetInt(gAge4PoliticianList, 7, cTechPoliticianMercenary);

	gAge5PoliticianList = xsArrayCreateInt(4, 0, "Age 5 Politician List");
	xsArraySetInt(gAge5PoliticianList, 0, cTechPoliticianPresidente);
	xsArraySetInt(gAge5PoliticianList, 1, cTechPoliticianPresidenteEU);
	xsArraySetInt(gAge5PoliticianList, 2, cTechPoliticianGeneral);
	xsArraySetInt(gAge5PoliticianList, 3, cTechPoliticianGeneralUSA);


	gAge2WonderList = xsArrayCreateInt(15, 0, "Age 2 Wonder List");
	xsArraySetInt(gAge2WonderList, 0, cUnitTypeypWCConfucianAcademy2);
	xsArraySetInt(gAge2WonderList, 1, cUnitTypeypWCPorcelainTower2);
	xsArraySetInt(gAge2WonderList, 2, cUnitTypeypWCSummerPalace2);
	xsArraySetInt(gAge2WonderList, 3, cUnitTypeypWCTempleOfHeaven2);
	xsArraySetInt(gAge2WonderList, 4, cUnitTypeypWCWhitePagoda2);
	xsArraySetInt(gAge2WonderList, 5, cUnitTypeypWIAgraFort2);
	xsArraySetInt(gAge2WonderList, 6, cUnitTypeypWICharminarGate2);
	xsArraySetInt(gAge2WonderList, 7, cUnitTypeypWIKarniMata2);
	xsArraySetInt(gAge2WonderList, 8, cUnitTypeypWITajMahal2);
	xsArraySetInt(gAge2WonderList, 9, cUnitTypeypWITowerOfVictory2);
	xsArraySetInt(gAge2WonderList, 10, cUnitTypeypWJGiantBuddha2);
	xsArraySetInt(gAge2WonderList, 11, cUnitTypeypWJGoldenPavillion2);
	xsArraySetInt(gAge2WonderList, 12, cUnitTypeypWJShogunate2);
	xsArraySetInt(gAge2WonderList, 13, cUnitTypeypWJToriiGates2);
	xsArraySetInt(gAge2WonderList, 14, cUnitTypeypWJToshoguShrine2);

	gAge3WonderList = xsArrayCreateInt(15, 0, "Age 3 Wonder List");
	xsArraySetInt(gAge3WonderList, 0, cUnitTypeypWCConfucianAcademy3);
	xsArraySetInt(gAge3WonderList, 1, cUnitTypeypWCPorcelainTower3);
	xsArraySetInt(gAge3WonderList, 2, cUnitTypeypWCSummerPalace3);
	xsArraySetInt(gAge3WonderList, 3, cUnitTypeypWCTempleOfHeaven3);
	xsArraySetInt(gAge3WonderList, 4, cUnitTypeypWCWhitePagoda3);
	xsArraySetInt(gAge3WonderList, 5, cUnitTypeypWIAgraFort3);
	xsArraySetInt(gAge3WonderList, 6, cUnitTypeypWICharminarGate3);
	xsArraySetInt(gAge3WonderList, 7, cUnitTypeypWIKarniMata3);
	xsArraySetInt(gAge3WonderList, 8, cUnitTypeypWITajMahal3);
	xsArraySetInt(gAge3WonderList, 9, cUnitTypeypWITowerOfVictory3);
	xsArraySetInt(gAge3WonderList, 10, cUnitTypeypWJGiantBuddha3);
	xsArraySetInt(gAge3WonderList, 11, cUnitTypeypWJGoldenPavillion3);
	xsArraySetInt(gAge3WonderList, 12, cUnitTypeypWJShogunate3);
	xsArraySetInt(gAge3WonderList, 13, cUnitTypeypWJToriiGates3);
	xsArraySetInt(gAge3WonderList, 14, cUnitTypeypWJToshoguShrine3);

	gAge4WonderList = xsArrayCreateInt(15, 0, "Age 4 Wonder List");
	xsArraySetInt(gAge4WonderList, 0, cUnitTypeypWCConfucianAcademy4);
	xsArraySetInt(gAge4WonderList, 1, cUnitTypeypWCPorcelainTower4);
	xsArraySetInt(gAge4WonderList, 2, cUnitTypeypWCSummerPalace4);
	xsArraySetInt(gAge4WonderList, 3, cUnitTypeypWCTempleOfHeaven4);
	xsArraySetInt(gAge4WonderList, 4, cUnitTypeypWCWhitePagoda4);
	xsArraySetInt(gAge4WonderList, 5, cUnitTypeypWIAgraFort4);
	xsArraySetInt(gAge4WonderList, 6, cUnitTypeypWICharminarGate4);
	xsArraySetInt(gAge4WonderList, 7, cUnitTypeypWIKarniMata4);
	xsArraySetInt(gAge4WonderList, 8, cUnitTypeypWITajMahal4);
	xsArraySetInt(gAge4WonderList, 9, cUnitTypeypWITowerOfVictory4);
	xsArraySetInt(gAge4WonderList, 10, cUnitTypeypWJGiantBuddha4);
	xsArraySetInt(gAge4WonderList, 11, cUnitTypeypWJGoldenPavillion4);
	xsArraySetInt(gAge4WonderList, 12, cUnitTypeypWJShogunate4);
	xsArraySetInt(gAge4WonderList, 13, cUnitTypeypWJToriiGates4);
	xsArraySetInt(gAge4WonderList, 14, cUnitTypeypWJToshoguShrine4);

	gAge5WonderList = xsArrayCreateInt(15, 0, "Age 5 Wonder List");
	xsArraySetInt(gAge5WonderList, 0, cUnitTypeypWCConfucianAcademy5);
	xsArraySetInt(gAge5WonderList, 1, cUnitTypeypWCPorcelainTower5);
	xsArraySetInt(gAge5WonderList, 2, cUnitTypeypWCSummerPalace5);
	xsArraySetInt(gAge5WonderList, 3, cUnitTypeypWCTempleOfHeaven5);
	xsArraySetInt(gAge5WonderList, 4, cUnitTypeypWCWhitePagoda5);
	xsArraySetInt(gAge5WonderList, 5, cUnitTypeypWIAgraFort5);
	xsArraySetInt(gAge5WonderList, 6, cUnitTypeypWICharminarGate5);
	xsArraySetInt(gAge5WonderList, 7, cUnitTypeypWIKarniMata5);
	xsArraySetInt(gAge5WonderList, 8, cUnitTypeypWITajMahal5);
	xsArraySetInt(gAge5WonderList, 9, cUnitTypeypWITowerOfVictory5);
	xsArraySetInt(gAge5WonderList, 10, cUnitTypeypWJGiantBuddha5);
	xsArraySetInt(gAge5WonderList, 11, cUnitTypeypWJGoldenPavillion5);
	xsArraySetInt(gAge5WonderList, 12, cUnitTypeypWJShogunate5);
	xsArraySetInt(gAge5WonderList, 13, cUnitTypeypWJToriiGates5);
	xsArraySetInt(gAge5WonderList, 14, cUnitTypeypWJToshoguShrine5);

	gAge2WonderTechList = xsArrayCreateInt(15, 0, "Age 2 WonderTech List");
	xsArraySetInt(gAge2WonderTechList, 0, cTechYPWonderChineseConfucianAcademy2);
	xsArraySetInt(gAge2WonderTechList, 1, cTechYPWonderChinesePorcelainTower2);
	xsArraySetInt(gAge2WonderTechList, 2, cTechYPWonderChineseSummerPalace2);
	xsArraySetInt(gAge2WonderTechList, 3, cTechYPWonderChineseTempleOfHeaven2);
	xsArraySetInt(gAge2WonderTechList, 4, cTechYPWonderChineseWhitePagoda2);
	xsArraySetInt(gAge2WonderTechList, 5, cTechYPWonderIndianAgra2);
	xsArraySetInt(gAge2WonderTechList, 6, cTechYPWonderIndianCharminar2);
	xsArraySetInt(gAge2WonderTechList, 7, cTechYPWonderIndianKarniMata2);
	xsArraySetInt(gAge2WonderTechList, 8, cTechYPWonderIndianTajMahal2);
	xsArraySetInt(gAge2WonderTechList, 9, cTechYPWonderIndianTowerOfVictory2);
	xsArraySetInt(gAge2WonderTechList, 10, cTechYPWonderJapaneseGiantBuddha2);
	xsArraySetInt(gAge2WonderTechList, 11, cTechYPWonderJapaneseGoldenPavillion2);
	xsArraySetInt(gAge2WonderTechList, 12, cTechYPWonderJapaneseShogunate2);
	xsArraySetInt(gAge2WonderTechList, 13, cTechYPWonderJapaneseToriiGates2);
	xsArraySetInt(gAge2WonderTechList, 14, cTechYPWonderJapaneseToshoguShrine2);

	gAge3WonderTechList = xsArrayCreateInt(15, 0, "Age 3 WonderTech List");
	xsArraySetInt(gAge3WonderTechList, 0, cTechYPWonderChineseConfucianAcademy3);
	xsArraySetInt(gAge3WonderTechList, 1, cTechYPWonderChinesePorcelainTower3);
	xsArraySetInt(gAge3WonderTechList, 2, cTechYPWonderChineseSummerPalace3);
	xsArraySetInt(gAge3WonderTechList, 3, cTechYPWonderChineseTempleOfHeaven3);
	xsArraySetInt(gAge3WonderTechList, 4, cTechYPWonderChineseWhitePagoda3);
	xsArraySetInt(gAge3WonderTechList, 5, cTechYPWonderIndianAgra3);
	xsArraySetInt(gAge3WonderTechList, 6, cTechYPWonderIndianCharminar3);
	xsArraySetInt(gAge3WonderTechList, 7, cTechYPWonderIndianKarniMata3);
	xsArraySetInt(gAge3WonderTechList, 8, cTechYPWonderIndianTajMahal3);
	xsArraySetInt(gAge3WonderTechList, 9, cTechYPWonderIndianTowerOfVictory3);
	xsArraySetInt(gAge3WonderTechList, 10, cTechYPWonderJapaneseGiantBuddha3);
	xsArraySetInt(gAge3WonderTechList, 11, cTechYPWonderJapaneseGoldenPavillion3);
	xsArraySetInt(gAge3WonderTechList, 12, cTechYPWonderJapaneseShogunate3);
	xsArraySetInt(gAge3WonderTechList, 13, cTechYPWonderJapaneseToriiGates3);
	xsArraySetInt(gAge3WonderTechList, 14, cTechYPWonderJapaneseToshoguShrine3);

	gAge4WonderTechList = xsArrayCreateInt(15, 0, "Age 4 WonderTech List");
	xsArraySetInt(gAge4WonderTechList, 0, cTechYPWonderChineseConfucianAcademy4);
	xsArraySetInt(gAge4WonderTechList, 1, cTechYPWonderChinesePorcelainTower4);
	xsArraySetInt(gAge4WonderTechList, 2, cTechYPWonderChineseSummerPalace4);
	xsArraySetInt(gAge4WonderTechList, 3, cTechYPWonderChineseTempleOfHeaven4);
	xsArraySetInt(gAge4WonderTechList, 4, cTechYPWonderChineseWhitePagoda4);
	xsArraySetInt(gAge4WonderTechList, 5, cTechYPWonderIndianAgra4);
	xsArraySetInt(gAge4WonderTechList, 6, cTechYPWonderIndianCharminar4);
	xsArraySetInt(gAge4WonderTechList, 7, cTechYPWonderIndianKarniMata4);
	xsArraySetInt(gAge4WonderTechList, 8, cTechYPWonderIndianTajMahal4);
	xsArraySetInt(gAge4WonderTechList, 9, cTechYPWonderIndianTowerOfVictory4);
	xsArraySetInt(gAge4WonderTechList, 10, cTechYPWonderJapaneseGiantBuddha4);
	xsArraySetInt(gAge4WonderTechList, 11, cTechYPWonderJapaneseGoldenPavillion4);
	xsArraySetInt(gAge4WonderTechList, 12, cTechYPWonderJapaneseShogunate4);
	xsArraySetInt(gAge4WonderTechList, 13, cTechYPWonderJapaneseToriiGates4);
	xsArraySetInt(gAge4WonderTechList, 14, cTechYPWonderJapaneseToshoguShrine4);

	gAge5WonderTechList = xsArrayCreateInt(15, 0, "Age 5 WonderTech List");
	xsArraySetInt(gAge5WonderTechList, 0, cTechYPWonderChineseConfucianAcademy5);
	xsArraySetInt(gAge5WonderTechList, 1, cTechYPWonderChinesePorcelainTower5);
	xsArraySetInt(gAge5WonderTechList, 2, cTechYPWonderChineseSummerPalace5);
	xsArraySetInt(gAge5WonderTechList, 3, cTechYPWonderChineseTempleOfHeaven5);
	xsArraySetInt(gAge5WonderTechList, 4, cTechYPWonderChineseWhitePagoda5);
	xsArraySetInt(gAge5WonderTechList, 5, cTechYPWonderIndianAgra5);
	xsArraySetInt(gAge5WonderTechList, 6, cTechYPWonderIndianCharminar5);
	xsArraySetInt(gAge5WonderTechList, 7, cTechYPWonderIndianKarniMata5);
	xsArraySetInt(gAge5WonderTechList, 8, cTechYPWonderIndianTajMahal5);
	xsArraySetInt(gAge5WonderTechList, 9, cTechYPWonderIndianTowerOfVictory5);
	xsArraySetInt(gAge5WonderTechList, 10, cTechYPWonderJapaneseGiantBuddha5);
	xsArraySetInt(gAge5WonderTechList, 11, cTechYPWonderJapaneseGoldenPavillion5);
	xsArraySetInt(gAge5WonderTechList, 12, cTechYPWonderJapaneseShogunate5);
	xsArraySetInt(gAge5WonderTechList, 13, cTechYPWonderJapaneseToriiGates5);
	xsArraySetInt(gAge5WonderTechList, 14, cTechYPWonderJapaneseToshoguShrine5);

	gAgeUpPoliticians = xsArrayCreateInt(6, 0, "Ageup Politicians");
	gPoliticianScores = xsArrayCreateInt(6, 0, "European Politicians");
	gNatCouncilScores = xsArrayCreateInt(6, 0, "Native Council");
	gAsianWonderScores = xsArrayCreateInt(6, 0, "Asian Wonders");

	gExcludeSettlersArray = xsArrayCreateInt(200, -1, "excludeSettlers");

	gShorelineArray = xsArrayCreateVector(2000, cInvalidVector, "shorelineTargets");
	gTransportShipsArray = xsArrayCreateInt(50, -1, "transportShips");
	gShorelineEnemyBuildingsArray = xsArrayCreateInt(1000, -1, "shorelineEnemyBuildings");

	gBringInHuntSettlers = xsArrayCreateInt(10, -1, "gBringInHuntSettlers");

	gBringInHuntSettlerTime = xsArrayCreateInt(100, 0, "gBringInHuntSettlerTime");
	gBringInHuntSettlerTarget = xsArrayCreateVector(100, cInvalidVector, "gBringInHuntSettlerTarget");
	gBringInHuntSettlerLastHunt = xsArrayCreateInt(100, -1, "gBringInHuntSettlerLastHunt");
	
	gIdleArray = xsArrayCreateInt(200, -1, "idleSettlers"); //Create the array to hold the settlers that need to be allocated
	gWagonBuildLocation = xsArrayCreateVector(100, cInvalidVector, "gWagonBuildLocation");
	gWagonBuildLocationId = xsArrayCreateInt(100, -1, "gWagonBuildLocationId");

	if (gBlockedResourceArray == -1) gBlockedResourceArray = xsArrayCreateInt(1000, -1, "gBlockedResourceArray"); //Create array to hold resouces to avoid because they could be blocked
	gPlayerHumanStatusArray = xsArrayCreateBool(cNumberPlayers, false, "gPlayerHumanStatusArray");

	gOrphanBuildingWagonCheckArray = xsArrayCreateInt(20, -1, "gOrphanBuildingWagonCheckArray");
	gOrphanBuildingWagonCheckArray = xsArrayCreateFloat(20, -1.0, "gOrphanBuildingWagonHealthArray");


	gNatTechs = xsArrayCreateInt(170,-1, "gNatTechs");
	xsArraySetInt(gNatTechs, 0, cTechNatChinampa);
	xsArraySetInt(gNatTechs, 1, cTechNatGarlandWars);
	xsArraySetInt(gNatTechs, 2, cTechNatAztecInitiation);
	xsArraySetInt(gNatTechs, 3, cTechNativeTreatyAztec);
	xsArraySetInt(gNatTechs, 4, cTechypNativeEmbassyEnableShadow);
	xsArraySetInt(gNatTechs, 5, cTechypNativeTradeTreatyAztec);
	xsArraySetInt(gNatTechs, 6, cTechNatHorseBreeding);
	xsArraySetInt(gNatTechs, 7, cTechNatMustangs);
	xsArraySetInt(gNatTechs, 8, cTechNatTradeLanguage);
	xsArraySetInt(gNatTechs, 9, cTechNativeTreatyComanche);
	xsArraySetInt(gNatTechs, 10, cTechypNativeTradeTreatyComanche);
	xsArraySetInt(gNatTechs, 11, cTechNatGuerillaWars);
	xsArraySetInt(gNatTechs, 12, cTechNatBowyery);
	xsArraySetInt(gNatTechs, 13, cTechNatInvincibles);
	xsArraySetInt(gNatTechs, 14, cTechNativeTreatySeminole);
	xsArraySetInt(gNatTechs, 15, cTechypNativeTradeTreatySeminole);
	xsArraySetInt(gNatTechs, 16, cTechNatMorningWars);
	xsArraySetInt(gNatTechs, 17, cTechNatLacrosse);
	xsArraySetInt(gNatTechs, 18, cTechNatIroquoisLeague);
	xsArraySetInt(gNatTechs, 19, cTechNativeTreatyIroquois);
	xsArraySetInt(gNatTechs, 20, cTechypNativeTradeTreatyIroquois);
	xsArraySetInt(gNatTechs, 21, cTechNatWarDance);
	xsArraySetInt(gNatTechs, 22, cTechNatBasketweaving);
	xsArraySetInt(gNatTechs, 23, cTechNatSequoyahSyllabary);
	xsArraySetInt(gNatTechs, 24, cTechNativeTreatyCherokee);
	xsArraySetInt(gNatTechs, 25, cTechypNativeTradeTreatyCherokee);
	xsArraySetInt(gNatTechs, 26, cTechNatRoadbuilding);
	xsArraySetInt(gNatTechs, 27, cTechNatMetalworking);
	xsArraySetInt(gNatTechs, 28, cTechNatChasquisMessengers);
	xsArraySetInt(gNatTechs, 29, cTechNativeTreatyInca);
	xsArraySetInt(gNatTechs, 30, cTechypNativeTradeTreatyInca);
	xsArraySetInt(gNatTechs, 31, cTechNatGarifunaDrums);
	xsArraySetInt(gNatTechs, 32, cTechNatKasiriBeer);
	xsArraySetInt(gNatTechs, 33, cTechNatCeremonialFeast);
	xsArraySetInt(gNatTechs, 34, cTechNatBlowgunnerAmbush);
	xsArraySetInt(gNatTechs, 35, cTechNativeTreatyCaribs);
	xsArraySetInt(gNatTechs, 36, cTechypNativeTradeTreatyCaribs);
	xsArraySetInt(gNatTechs, 37, cTechNativeTreatyLakota);
	xsArraySetInt(gNatTechs, 38, cTechypNativeTradeTreatyLakota);
	xsArraySetInt(gNatTechs, 39, cTechNatPotlatch);
	xsArraySetInt(gNatTechs, 40, cTechNatBarkClothing);
	xsArraySetInt(gNatTechs, 41, cTechNatLoyalClubman);
	xsArraySetInt(gNatTechs, 42, cTechNativeTreatyNootka);
	xsArraySetInt(gNatTechs, 43, cTechypNativeTradeTreatyNootka);
	xsArraySetInt(gNatTechs, 44, cTechNatKinship);
	xsArraySetInt(gNatTechs, 45, cTechNatTanning);
	xsArraySetInt(gNatTechs, 46, cTechNatTextileCraftsmanship);
	xsArraySetInt(gNatTechs, 47, cTechNativeTreatyCree);
	xsArraySetInt(gNatTechs, 48, cTechypNativeTradeTreatyCree);
	xsArraySetInt(gNatTechs, 49, cTechImpLegendaryNatives);
	xsArraySetInt(gNatTechs, 50, cTechNatCottonArmor);
	xsArraySetInt(gNatTechs, 51, cTechNatCalendar);
	xsArraySetInt(gNatTechs, 52, cTechNatChocolateRecipes);
	xsArraySetInt(gNatTechs, 53, cTechNativeTreatyMaya);
	xsArraySetInt(gNatTechs, 54, cTechypNativeTradeTreatyMaya);
	xsArraySetInt(gNatTechs, 55, cTechNatAnimalLore);
	xsArraySetInt(gNatTechs, 56, cTechNatPoisonArrowFrogs);
	xsArraySetInt(gNatTechs, 57, cTechNatForestBurning);
	xsArraySetInt(gNatTechs, 58, cTechNativeTreatyTupi);
	xsArraySetInt(gNatTechs, 59, cTechypNativeTradeTreatyTupi);
	xsArraySetInt(gNatTechs, 60, cTechNativeUpgrades);
	xsArraySetInt(gNatTechs, 61, cTechNativeUpgrades2);
	xsArraySetInt(gNatTechs, 62, cTechNatXPZapotecCloudPeople);
	xsArraySetInt(gNatTechs, 63, cTechNatXPZapotecCultOfTheDead);
	xsArraySetInt(gNatTechs, 64, cTechNatXPZapotecFoodOfTheGods);
	xsArraySetInt(gNatTechs, 65, cTechNativeTreatyZapotec);
	xsArraySetInt(gNatTechs, 66, cTechypNativeTradeTreatyZapotec);
	xsArraySetInt(gNatTechs, 67, cTechNatXPCheyenneFury);
	xsArraySetInt(gNatTechs, 68, cTechNatXPCheyenneHorseTrading);
	xsArraySetInt(gNatTechs, 69, cTechNatXPCheyenneHuntingGrounds);
	xsArraySetInt(gNatTechs, 70, cTechNativeTreatyCheyenne);
	xsArraySetInt(gNatTechs, 71, cTechypNativeTradeTreatyCheyenne);
	xsArraySetInt(gNatTechs, 72, cTechNatXPHuronTradeMonopoly);
	xsArraySetInt(gNatTechs, 73, cTechNatXPHuronSunCeremony);
	xsArraySetInt(gNatTechs, 74, cTechNatXPHuronFishWedding);
	xsArraySetInt(gNatTechs, 75, cTechNativeTreatyHuron);
	xsArraySetInt(gNatTechs, 76, cTechypNativeTradeTreatyHuron);
	xsArraySetInt(gNatTechs, 77, cTechAANativeStartingTechs);
	xsArraySetInt(gNatTechs, 78, cTechDisableNativeMining);
	xsArraySetInt(gNatTechs, 79, cTechEnableNativeMining);
	xsArraySetInt(gNatTechs, 80, cTechAANativeStartingTechsPI);
	xsArraySetInt(gNatTechs, 81, cTechImpLegendaryNativesNatives);
	xsArraySetInt(gNatTechs, 82, cTechImpExcessiveTributeNative);
	xsArraySetInt(gNatTechs, 83, cTechNativeMarketGold);
	xsArraySetInt(gNatTechs, 84, cTechImpDeforestationNative);
	xsArraySetInt(gNatTechs, 85, cTechNatXPKlamathHuckleberryFeast);
	xsArraySetInt(gNatTechs, 86, cTechNatXPKlamathStrategy);
	xsArraySetInt(gNatTechs, 87, cTechNatXPKlamathWorkEthos);
	xsArraySetInt(gNatTechs, 88, cTechNativeTreatyKlamath);
	xsArraySetInt(gNatTechs, 89, cTechypNativeTradeTreatyKlamath);
	xsArraySetInt(gNatTechs, 90, cTechNatXPNavajoCraftsmanship);
	xsArraySetInt(gNatTechs, 91, cTechNatXPNavajoShepherds);
	xsArraySetInt(gNatTechs, 92, cTechNatXPNavajoWeaving);
	xsArraySetInt(gNatTechs, 93, cTechNativeTreatyNavajo);
	xsArraySetInt(gNatTechs, 94, cTechypNativeTradeTreatyNavajo);
	xsArraySetInt(gNatTechs, 95, cTechNatXPApacheCactus);
	xsArraySetInt(gNatTechs, 96, cTechNatXPApacheEndurance);
	xsArraySetInt(gNatTechs, 97, cTechNatXPApacheRaiding);
	xsArraySetInt(gNatTechs, 98, cTechNativeTreatyApache);
	xsArraySetInt(gNatTechs, 99, cTechypNativeTradeTreatyApache);
	xsArraySetInt(gNatTechs, 100, cTechNatXPMapucheTactics);
	xsArraySetInt(gNatTechs, 101, cTechNatXPMapucheAdMapu);
	xsArraySetInt(gNatTechs, 102, cTechNativeTreatyMapuche);
	xsArraySetInt(gNatTechs, 103, cTechNatXPMapucheTreatyOfQuillin);
	xsArraySetInt(gNatTechs, 104, cTechypNativeTradeTreatyMapuche);
	xsArraySetInt(gNatTechs, 105, cTechypNativeEmbassyEnabler);
	xsArraySetInt(gNatTechs, 106, cTechypNatDisciplinedBhakti);
	xsArraySetInt(gNatTechs, 107, cTechypNatHonoredBhakti);
	xsArraySetInt(gNatTechs, 108, cTechypNatDisciplinedUdasi);
	xsArraySetInt(gNatTechs, 109, cTechypNatHonoredUdasi);
	xsArraySetInt(gNatTechs, 110, cTechypNatDisciplinedZen);
	xsArraySetInt(gNatTechs, 111, cTechypNatHonoredZen);
	xsArraySetInt(gNatTechs, 112, cTechypNatDisciplinedShaolin);
	xsArraySetInt(gNatTechs, 113, cTechypNatHonoredShaolin);
	xsArraySetInt(gNatTechs, 114, cTechypNatDisciplinedJesuit);
	xsArraySetInt(gNatTechs, 115, cTechypNatHonoredJesuit);
	xsArraySetInt(gNatTechs, 116, cTechypNatDisciplinedSufi);
	xsArraySetInt(gNatTechs, 117, cTechypNatHonoredSufi);
	xsArraySetInt(gNatTechs, 118, cTechypNatDisciplinedSaltpeter);
	xsArraySetInt(gNatTechs, 119, cTechypNatHonoredSaltpeter);
	xsArraySetInt(gNatTechs, 120, cTechypImpLegendaryNatives2);
	xsArraySetInt(gNatTechs, 121, cTechYPNatJesuitSmokelessPowder);
	xsArraySetInt(gNatTechs, 122, cTechYPNatJesuitSchools);
	xsArraySetInt(gNatTechs, 123, cTechYPNatJesuitFlyingButtress);
	xsArraySetInt(gNatTechs, 124, cTechypNativeTreatyJesuit);
	xsArraySetInt(gNatTechs, 125, cTechypNativeTradeTreatyJesuit);
	xsArraySetInt(gNatTechs, 126, cTechYPNativeJunk);
	xsArraySetInt(gNatTechs, 127, cTechYPNativeCatamaran);
	xsArraySetInt(gNatTechs, 128, cTechYPNatZenMeritocracy);
	xsArraySetInt(gNatTechs, 129, cTechYPNatZenMeditation);
	xsArraySetInt(gNatTechs, 130, cTechYPNatZenMasterLessons);
	xsArraySetInt(gNatTechs, 131, cTechypNativeTreatyZen);
	xsArraySetInt(gNatTechs, 132, cTechypNativeTradeTreatyZen);
	xsArraySetInt(gNatTechs, 133, cTechYPNatShaolinClenchedFist);
	xsArraySetInt(gNatTechs, 134, cTechYPNatShaolinDimMak);
	xsArraySetInt(gNatTechs, 135, cTechYPNatShaolinWoodClearing);
	xsArraySetInt(gNatTechs, 136, cTechypNativeTreatyShaolin);
	xsArraySetInt(gNatTechs, 137, cTechypNativeTradeTreatyShaolin);
	xsArraySetInt(gNatTechs, 138, cTechYPNatBhaktiYoga);
	xsArraySetInt(gNatTechs, 139, cTechYPNatBhaktiVegetarianism);
	xsArraySetInt(gNatTechs, 140, cTechYPNatBhaktiReinforcedGuantlets);
	xsArraySetInt(gNatTechs, 141, cTechypNativeTreatyBhakti);
	xsArraySetInt(gNatTechs, 142, cTechypNativeTradeTreatyBhakti);
	xsArraySetInt(gNatTechs, 143, cTechYPNatSufiSharia);
	xsArraySetInt(gNatTechs, 144, cTechYPNatSufiPilgramage);
	xsArraySetInt(gNatTechs, 145, cTechYPNatSufiFasting);
	xsArraySetInt(gNatTechs, 146, cTechypNativeTreatySufi);
	xsArraySetInt(gNatTechs, 147, cTechypNativeTradeTreatySufi);
	xsArraySetInt(gNatTechs, 148, cTechYPNatUdasiNewYear);
	xsArraySetInt(gNatTechs, 149, cTechYPNatUdasiGurus);
	xsArraySetInt(gNatTechs, 150, cTechYPNatUdasiArmyOfThePure);
	xsArraySetInt(gNatTechs, 151, cTechypNativeTreatyUdasi);
	xsArraySetInt(gNatTechs, 152, cTechypNativeTradeTreatyUdasi);
	xsArraySetInt(gNatTechs, 153, cTechYPDisciplinedNaginataRider);
	xsArraySetInt(gNatTechs, 154, cTechYPHonoredNaginataRider);
	xsArraySetInt(gNatTechs, 155, cTechYPExaltedNaginataRider);
	xsArraySetInt(gNatTechs, 156, cTechYPWonderJapaneseShogunate5);
	xsArraySetInt(gNatTechs, 157, cTechYPWonderJapaneseShogunate4);
	xsArraySetInt(gNatTechs, 158, cTechYPWonderJapaneseShogunate3);
	xsArraySetInt(gNatTechs, 159, cTechYPWonderJapaneseShogunate2);
	xsArraySetInt(gNatTechs, 160, cTechNatElephants);
	xsArraySetInt(gNatTechs, 161, cTechNatFinePowder);
	xsArraySetInt(gNatTechs, 162, cTechNativeTreatySaltpeter);
	xsArraySetInt(gNatTechs, 163, cTechypNativeTradeTreatySaltpeter);
	xsArraySetInt(gNatTechs, 164, cTechHCNativeTreaties);
	xsArraySetInt(gNatTechs, 165, cTechYPWonderJapaneseShogunateDisable);
	xsArraySetInt(gNatTechs, 166, cTechYPHCNativeTradeTax);
	xsArraySetInt(gNatTechs, 167, cTechNativeTreatyDahomey);
	xsArraySetInt(gNatTechs, 168, cTechypNativeTradeTreatyDahomey);
	
	gNatTech2dArray = xs2DArrayCreate();
	for(i = 0; < xsArrayGetSize(gNatTechs))
	{
		xs2DArraySetInt(gNatTech2dArray, 0, i, xsArrayGetInt(gNatTechs,i) );
		xs2DArraySetInt(gNatTech2dArray, 1, i, 0);
	}

	/*gBuildLimitArray = xsArrayCreateInt(2000, -1, "gBuildLimitArray");
	for(i = 0; < 2000)
	{
		switch(i)
		{
			case cUnitTypeFactory:{ xsArraySetInt(gBuildLimitArray,i, -2); break; }
			case cUnitTypeFortFrontier:{ xsArraySetInt(gBuildLimitArray,i, -2); break; }
			case cUnitTypeBank:{ xsArraySetInt(gBuildLimitArray,i, -2); break; }
			case cUnitTypeOutpost:{ xsArraySetInt(gBuildLimitArray,i, -2); break; }
			case cUnitTypeWarHut:{ xsArraySetInt(gBuildLimitArray,i, -2); break; }
			case cUnitTypeypCastle:{ xsArraySetInt(gBuildLimitArray,i, -2); break; }
			case cUnitTypeBlockhouse:{ xsArraySetInt(gBuildLimitArray,i, -2); break; }
			case cUnitTypeTownCenter:{ xsArraySetInt(gBuildLimitArray,i, -2); break; }
			case cUnitTypeDock:{ xsArraySetInt(gBuildLimitArray,i, -2); break; }
			default:{ xsArraySetInt(gBuildLimitArray,i, kbGetBuildLimit(cMyID, i)); break; }
		}
	}
	*/
	

} //end initArrays

void initMain()
{

}