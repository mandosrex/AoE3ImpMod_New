/*
================================================================================
The Improved AI
Last updated by
ageekhere 2024/07/04
V 3.01
================================================================================
*/
//Global Variables
extern const string gVersionNumber = "3.01 2024/07/04"; //AI version and last update info
extern const bool gDebugMessage = false; //Enables the debug logger so that it will wright debug logs 
extern const int gDebugLevel = 100; //Sets the debug logger log depth, the higher the value the more depth
extern const int gNumResourceTypes = 3; //Holds the number of resource types, which are Food, Wood and Gold, note Fame will not be counted as a resource type
// Start mode constants.
extern const int gStartModeScenarioNoTC = 0; // Scenario, wait for aiStart unit, then play without a TC
extern const int gStartModeScenarioTC = 1; // Scenario, wait for aiStart unit, then play with starting TC
extern const int gStartModeScenarioWagon = 2; // Scenario, wait for aiStart unit, then start TC build plan.
extern const int gStartModeBoat = 3; // RM or GC game, with a caravel start.  Wait to unload, then start TC build plan.
extern const int gStartModeLandTC = 4; // RM or GC game, starting with a TC...just go.
extern const int gStartModeLandWagon = 5; // RM or GC game, starting with a wagon.  Explore, start TC build plan.

extern int gMaxVillPop = -1; //Holds the max village pop
extern int gCurrentGameTime = 0; //Holds the current game time 
extern int gDefaultDeck = -1; // Home city deck used by each AI
extern bool gTimeToFarm = false; //Set to true when we start to run out of cheap early food.
extern bool gTimeForPlantations = false; // Set true when we start to run out of mine-able gold.
//Unit types which will be set in setUnitTypes(void)
extern int gEconUnit = -1;
extern int gHouseUnit = -1;
extern int gTowerUnit = -1;
extern int gFarmUnit = -1;
extern int gPlantationUnit = -1;
extern int gLivestockPenUnit = -1;
extern int gCoveredWagonUnit = -1;
extern int gMarketUnit = -1;
extern int gDockUnit = -1;
extern int gSpecialUnit = -1;
extern int gTownCenter = -1;
extern int gBarracksUnit = -1;
extern int gStableUnit = -1;
extern int gArtilleryDepotUnit = -1;
extern int gArsenalUnit = -1; 
extern int gChurchUnit = -1;
extern int gFishingUnit = -1; 
extern int gTransportUnit = -1;
extern int gCaravelUnit = -1;
extern int gGalleonUnit = -1;
extern int gFrigateUnit = -1; 
extern int gNavyClass1 = -1;
extern int gNavyClass2 = -1;
extern int gNavyClass3 = -1;
extern int gNavyClassS1 = -1;
extern int gNavyClassS2 = -1;
extern int gExplorerUnit = -1;
extern int gExplorerUnit2 = -1;
extern int gTradingPostUnit = -1;
extern int gCapitolUnit = -1;
extern int gFirePitUnit = -1;


extern bool gChosenConsulateFlag = false; // need to make sure they only build one
extern bool gOkToMakeHouses = true; //sets if AI can make houses
extern int gLastTribSentTime = 0; //The last game time the ai sent tribute
extern int gTCBuildPlanID = -1; //Hold the town center build plan - NOT USE ATM
extern int gStartMode = -1; // See start mode constants. This variable is set in main() and is used to decide which cascades of rules should be used to start the AI.
extern int gSettlerMaintainPlan = -1; // Main plan to control settler population
extern bool gWaterMap = false; // True when we are on a water map
extern bool gWaterShorelineCheck = false;
extern vector gNavyTransportLocation = cInvalidVector; //Holds the drop off location for navy transporting
extern vector gNavyLoadLocation = cInvalidVector; //Holds the load location for navy transporting
extern int gNavyFlagUnit = -1; //Hold the water flag unit cUnitTypeHomeCityWaterSpawnFlag
extern vector gNavyFlagLocation = cInvalidVector; //Holds the navy flag location
extern vector gTCSearchVector = cInvalidVector; // Used to define the center of the TC building placement search.
extern int gAgeUpResearchPlan = -1; // Plan used to send politician from HC, used to detect if an age upgrade is in progress.
extern int gFeedGoldTo = -1; // If set, this indicates which player we need to be supplying with regular gold shipments.
extern int gFeedWoodTo = -1; // for wood
extern int gFeedFoodTo = -1; // for food
extern const int gForwardBaseStateNone = -1; // None exists, none in progress
extern const int gForwardBaseStateBuilding = 0; // Fort wagon exists, but no fort yet.
extern const int gForwardBaseStateActive = 1; // Base is active, defend and train plans there.
extern int gForwardBaseState = gForwardBaseStateNone; //Holds the state of the foward base
extern int gForwardBaseID = -1; //Holds the id of the foward base
extern int gForwardBaseBuildPlan = -1; //Holds the plan for the foward base
extern vector gForwardBaseLocation = cInvalidVector; // Set when state goes to 'building' or earlier.
extern vector gFrontBaseLocation = cInvalidVector; //Holds the front of main base location
extern vector gBackBaseLocation = cInvalidVector; //Holds the back of main base location
extern int gNativeDancePlan = -1; //Native dance plan
extern bool gBaseRelocateStatus = false; //Changes if the AI ever relocates main base

extern int gLandDefendPlan0 = -1; // Primary land defend plan
extern int gLandReservePlan = -1; // Reserve defend plan, gathers units for use in the next military mission
extern bool gDefenseReflex = false; // Set true when a defense reflex is overriding normal ops.
extern bool gDefenseReflexPaused = false; // Set true when we're in a defense reflex, but overwhelmed, so we're hiding to rebuild an army.
extern int gDefenseReflexBaseID = -1; // Set to the base ID that we're defending in this emergency
extern vector gDefenseReflexLocation = cInvalidVector; // Location we're defending in this emergency
extern int gDefenseReflexStartTime = 0; //The time from reflex start
extern int gLandUnitPicker = -1; // Picks the best land military units to train.
extern int gMainAttackGoal = -1; // Attack goal monitors opportunities, launches missions.
extern int gWaterExploreMaintain = -1;

extern bool gNavyMap = false; // Setting this false prevents navies
extern const int cNavyModeOff = 0;
extern const int cNavyModeActive = 2;
extern int gNavyMode = cNavyModeOff; // Tells us whether we're making no navy, just an exploring ship, or a full navy.
extern vector gNavyVec = cInvalidVector; // The center of the navy's operations.
extern int gNumArmyUnitTypes = 19; // How many land unit types do we want to train?
extern int gGoodArmyPop = -1; 

extern int gUnitPickSource = cOpportunitySourceAutoGenerated; // Indicates who decides which units are being trained...self, trigger, or ally player.
extern int gUnitPickPlayerID = -1; // If the source is cOpportunitySourceAllyRequest, this will hold the player ID.
extern int gMostRecentAllyOpportunityID = -1; // Which opportunity (if any) was created by an ally?  (Only one at a time allowed.)
extern int gMostRecentTriggerOpportunityID = -1; // Which opportunity (if any) was created by a trigger?  (Only one at a time allowed.)
extern int gLastClaimMissionTime = -1;
extern int gLastAttackMissionTime = -1;
extern int gLastDefendMissionTime = -1;
extern const int gClaimMissionInterval = 600000; // 10 minutes.  This variable indicates how long it takes for claim opportunities to score their maximum.  Typically, a new one will launch before this time.
extern const int gAttackMissionInterval = 180000; // 3 minutes.  Suppresses attack scores (linearly) for 3 minutes after one launches.  Attacks will usually happen before this period is over.
extern const int gDefendMissionInterval = 300000; // 5 minutes.   Makes the AI less likely to do another defend right after doing one.
extern bool gDelayAttacks = false; // Can be used on low difficulty levels to prevent attacks before the AI is attacked.  (AI is defend-only until this variable is

extern int gGameType = -1;
extern bool gSPC = false; // Set true in main if this is an spc or campaign game
extern int gExplorerControlPlan = -1; // Defend plan set up to control the explorer's location
extern int gLandExplorePlan = -1; // Primary land exploration
extern int gMainBase = -1;
extern vector gMainBaseLocation = cInvalidVector;
extern int gNumTowers = -1; // How many towers do we want to build?
extern int gPrevNumTowers = -1; // Set when a command is received, to allow resetting when a cancel is received.
extern bool gIsMonopolyRunning = false; // Set true while a monopoly countdown is in effect.
extern int gMonopolyTeam = -1; // TeamID of team that will win if the monopoly timer completes.
extern int gMonopolyEndTime = -1; // Gametime when current monopoly should end
extern bool gIsKOTHRunning = false; // Set true while a KOTH countdown is in effect.
extern int gKOTHTeam = -1; // TeamID of team that will win if the KOTH timer completes.

extern int gDockBuildNum = 2; //Sets the amount of docks an ai can build at the given age
extern int gDockPlacement0 = 1; //dock placement main base
extern int gDockPlacement1 = 0; //dock placement flag
extern vector gWallMidPosition = cInvalidVector; //The middle of the team position
extern vector gBuildFrontLocation = cInvalidVector; //base locaiton
extern vector gfowardBaseLocation = cInvalidVector;

extern bool gAiRevolted = false;
extern bool gLosingDigin = false;
extern int gGatherRange = 50;
extern int gPetardTarget = -1;

extern int gCurrentShipTransport = -1;
extern bool gIslandLanded = false;
extern int gIslandLandedLocationUnit = -1;
extern bool gReallocateSettlers = false;
extern const float gPiValue = 3.1415926535897932384626433832795028;

extern int gBringInHuntSettlers = -1;
extern int gBringInHuntSettlerTime = -1;
extern int gBringInHuntSettlerTarget = -1;
extern int gBringInHuntSettlerLastHunt = -1;
extern int gOpeningStrategy = 0;

extern int gMissionToCancel = -1; // Function returns # of units available, sets global var so commhandler can kill the mission if needed.
extern int gTownCenterNumber = 0; //Replaces kbUnitCount(cMyID, gTownCenter, cUnitStateAlive) calls, called once per AI turn in mainRules
extern int gCurrentWood = -1; //Replaces kbResourceGet(cResourceWood) calls, called once per AI turn in mainRules
extern int gCurrentFood = -1; //Replaces kbResourceGet(cResourceFood) calls, called once per AI turn in mainRules
extern int gCurrentCoin = -1; //Replaces kbResourceGet(cResourceCoin) calls, called once per AI turn in mainRules
extern int gCurrentFame = -1; //Replaces kbResourceGet(cResourceFame) calls, called once per AI turn in mainRules
extern int gCurrentPop = -1; //Replaces kbGetPop() calls, called once per AI turn in mainRules
extern int gCurrentPopCap = -1; //Replaces kbGetPopCap() calls, called once per AI turn in mainRules
extern int gCurrentAliveSettlers = 1; //Uses getPlayerAliveSettlers() called once per AI turn in mainRules
extern int gCurrentIdleSettlers = 1; //Holds current number of idle settlers

extern int gSettlerWagonNum = -1; //Hold the current number of alive cUnitTypeSettlerWagon
extern int gBankNum = -1; //Hold the current number of alive cUnitTypeBank
extern int gFactoryNum = -1; //Hold the current number of alive cUnitTypeFactory
extern int gFishingUnitNum = -1;
extern bool gMapTypeIsland = false;
extern int gCurrentAge = -1;
extern bool gTreatyActive = false;
extern int gGetMostHatedPlayerID = -1;
extern int gCurrentCiv = -1;
extern bool gExplorerFindingHerds = false;
extern int gMainTownCenter = -1;
extern vector gMainTownCenterLocation = cInvalidVector;
extern int gPlayerTeam = -1;
extern vector gMapCenter = cInvalidVector;
extern int gWorldDifficulty = -1;
extern bool gHaveFameAgeUpCard = false;

extern int gEnemyLandMilitaryQry = -1; //A qry to get all enemy land units
extern int gSelfLandMilitaryQry = -1; //A qry to get all self land units
extern int gNumEnemyLandMilitary = -1;
extern int gNumSelfLandMilitary = -1;
extern bool gNationalRedoubtEnabled = false;
extern bool gBlockhouseEngineeringEnabled = false;
extern bool gBuildPlanSettlerOveride = false;
extern bool gNomadStart = false;
extern int gWagonBuildLocation = -1;
extern int gWagonBuildLocationId = -1;

// Function forward declarations.
mutable void preInit(void) {}// Used in loader file to override default values, called at start of main()
mutable void postInit(void) {}// Used in loader file to override initialization decisions, called at end of main()
mutable void econManager(int mode = -1, int value = -1) {}
mutable void shipGrantedHandler(int parm = -1) {}
mutable int initUnitPicker(string name = "BUG", int numberTypes = 1, int minUnits = 10, int maxUnits = 20, int minPop = -1, int maxPop = -1, int numberBuildings = 1, bool guessEnemyUnitType = false) { return (-1); }
mutable void setForecasts(void) {}
mutable void setUnitPickerPreference(int upID = -1) {}
mutable void endDefenseReflex(void) {}
// Global Arrays
extern int gForecasts = -1;
extern int gMapNames = -1; // An array of random map names, so we can store ID numbers in player histories
extern int gTargetSettlerCounts = -1; // How many settlers do we want per age?
extern int gConsulateTechs = -1; //List of all the consulate techs
extern int gConsulateTechsSize = -1; //Size of the list of all the consulate techs
extern int gAsianWonders = -1; //List of wonders for the Asian civs
extern int gAge2PoliticianList = -1; // List of Age 2 European politicians
extern int gAge3PoliticianList = -1; // List of Age 3 European politicians
extern int gAge4PoliticianList = -1; // List of Age 4 European politicians
extern int gAge5PoliticianList = -1; // List of Age 5 European politicians
extern int gAge2WonderList = -1; // List of Age 2 Asian age-up wonders
extern int gAge3WonderList = -1; // List of Age 3 Asian age-up wonders
extern int gAge4WonderList = -1; // List of Age 4 Asian age-up wonders
extern int gAge5WonderList = -1; // List of Age 5 Asian age-up wonders
extern int gAge2WonderTechList = -1; // List of Age 2 Asian age-up technologies
extern int gAge3WonderTechList = -1; // List of Age 3 Asian age-up technologies
extern int gAge4WonderTechList = -1; // List of Age 4 Asian age-up technologies
extern int gAge5WonderTechList = -1; // List of Age 5 Asian age-up technologies
extern int gAgeUpPoliticians = -1; // Array of available age-up politicians
extern int gPoliticianScores = -1; // Array used to calculate "scores" for different European politicians
extern int gNatCouncilScores = -1; // Array used to calculate "scores" for different native council members
extern int gAsianWonderScores = -1; // Array used to calculate "scores" for different Asian wonders
extern int gIdleArray = -1; //array that holds idle settlers
extern int gShorelineEnemyBuildingsArray = -1;
extern int gTransportShipsArray = -1;
extern int gShorelineArray = -1;
extern int gExcludeSettlersArray = -1;
extern int gBuildListArray = -1;
extern int gBlockedResourceArray = -1; //array that holds resources that are blocked
extern int gPlayerHumanStatusArray = -1;
extern int gOrphanBuildingWagonCheckArray = -1;
extern int gOrphanBuildingWagonHealthArray = -1;
extern bool gAutoSaveStatus = false;
extern int gNatTechs = -1;
extern int gNatTech2dArray = -1;

	
extern int gQ_FIND = -1;
extern int gQ_FINDAT = -1;
extern int gQ_COUNTAT = -1;
extern int gQ_DOUBLE = -1;
extern int gQ_ACTION = -1;
extern int gTradePostManagerTime = 0;
extern bool gMainBaseUnderAttack = false;

extern int gWaterIslandTradeSocket = -1;

//==============================================================================
/*
	debugRule
	updatedOn 2023/06/24
	Creates debug logs which are saved in Documents\My Games\AoE3 Improvement Mod\UHC Plugin
	
	How to use
	Pass message and what level the debug should be, note -1 is for the frist debug message for the function
	
	Example debugRule("My error",0);
*/
//==============================================================================
void debugRule(string message = "DEFAULT", int level = -1) //int debugType = -1
{
	if (gDebugMessage && level == -1) aiLog("");
	if (gDebugMessage && gDebugLevel >= level) aiLog("Debug player: " + cMyID + " " + message + " Time " + xsGetTime());	
} //end debugRule

//==============================================================================
/*
	messagePlayers
	updatedOn 2023/06/24
	Makes the AI send a chat message to all players
	
	How to use
	Pass a message
	
	Example messagePlayers("Ai said hi");
*/
//==============================================================================
void messagePlayers(string message = "DEFAULT")
{ //Provides on-screen Chat from the AI player
	debugRule("messagePlayers",-1);
	for (i = 1; < cNumberPlayers)
	{ //loop through all players starting from player 1 to cNumberPlayers (which also counts gaia player so that is why it starts at 1)
		debugRule("messagePlayers - Checking to send message to player " + i, 1);
		if (xsArrayGetBool(gPlayerHumanStatusArray, i) == false)
		{ //check if player is human
			debugRule("messagePlayers - player " + i + " is AI, not sending message", 2);
			continue; //Skip sending message to other AI players
		} //end if
		debugRule("messagePlayers - Sending message to player " + i + " message: " + message, 1);
		aiChat(i, message); //send message to player
	} //end for
	debugRule("messagePlayers - end",0);
} //end messagePlayers

//load external xs files
include "IAI/mth.xs"; include "IAI/get.xs"; include "IAI/tls.xs"; include "IAI/acm.xs"; include "IAI/fcs.xs"; include "IAI/cms.xs"; include "IAI/csu.xs"; include "IAI/cpl.xs";
include "IAI/atm.xs"; include "IAI/aum.xs"; include "IAI/esm.xs"; include "IAI/set.xs"; include "IAI/cbp.xs"; include "IAI/mms.xs"; include "IAI/dah.xs"; include "IAI/mom.xs";
include "IAI/upr.xs"; include "IAI/rex.xs"; include "IAI/lrn.xs"; include "IAI/crd.xs"; include "IAI/nit.xs"; include "IAI/cha.xs"; include "IAI/ini.xs"; include "IAI/opp.xs";
include "IAI/mpl.xs"; include "IAI/lvy.xs"; include "IAI/lsk.xs"; include "IAI/cht.xs"; include "IAI/eco.xs"; include "IAI/smm.xs"; include "IAI/qry.xs"; include "IAI/kth.xs";
include "IAI/wat.xs"; include "IAI/ret.xs";
//==============================================================================
/*
	waitForStartup
	updatedOn 2023/06/24
	Check what type of start for the AI it is
	
	How to use 
	Is auto called from ini.xs and mn.xs
*/
//==============================================================================
rule waitForStartup
inactive
minInterval 1
{
	debugRule("waitForStartup", -1);
	if (kbUnitCount(cMyID, cUnitTypeAIStart, cUnitStateAny) < 1)
	{ //Check for AI start
		debugRule("waitForStartup - Warning no AIstart found", 1);
		debugRule("waitForStartup - end", 0);
		return;
	} //end if
	if (gTownCenterNumber > 0)
	{ //check for TownCenter start
		debugRule("waitForStartup - TownCenter found, gStartModeScenarioTC ", 1);
		gStartMode = gStartModeScenarioTC;
	} //end if
	else if (kbUnitCount(cMyID, cUnitTypeLogicalTypeTCBuildLimit, cUnitStateAlive) > 0)
	{ //check for TownCenter wagon start, note we use LogicalTypeTCBuildLimit to include CoveredWagon
		debugRule("waitForStartup - wagon found, gStartModeScenarioWagon ", 1);
		gStartMode = gStartModeScenarioWagon;
	} //end if
	else
	{ //No TownCenter or wagon found, use no TownCenter start
		debugRule("waitForStartup - Nothing found, gStartModeScenarioNoTC ", 1);
		gStartMode = gStartModeScenarioNoTC;
	} //end else
	if (cvInactiveAI == false)
	{ //check if the ai is active 
		debugRule("waitForStartup - cvInactiveAI is false, start transportArrive", 1);
		transportArrive();
	} //end if 
	else
	{ //ai is not active
		debugRule("waitForStartup - cvInactiveAI is true", 1);
	} //end else
	xsDisableSelf();
	debugRule("waitForStartup - end", 0);
} //end waitForStartup

//==============================================================================
/*
	mainRun
	updatedOn 2023/06/24
	Sets up the ai before the ai starts the game
	
	How to use 
	Is auto called from aiMain.xs
*/
//==============================================================================
void mainRun(void)
{
	debugRule("mainRun", -1);
	gCurrentCiv = kbGetCiv(); debugRule("mainRun - gCurrentCiv " + gCurrentCiv, 0);
	setUnitTypes();
	gTownCenterNumber = kbUnitCount(cMyID, gTownCenter, cUnitStateAlive); debugRule("mainRun - gTownCenterNumber " + gTownCenterNumber, 0);
	gWorldDifficulty = aiGetWorldDifficulty(); debugRule("mainRun - gWorldDifficulty " + gWorldDifficulty, 0);
	gCurrentAge = kbGetAge(); debugRule("mainRun - gCurrentAge " + gCurrentAge, 0); 
	gMapCenter = kbGetMapCenter(); debugRule("mainRun - gMapCenter " + gMapCenter, 0); 
	gPlayerTeam = kbGetPlayerTeam(cMyID); debugRule("mainRun - gPlayerTeam " + gPlayerTeam, 0); 
	gNomadStart = kbIsNomad(); debugRule("mainRun - gNomadStart " + gNomadStart, 0); 
	gTreatyActive = aiTreatyActive(); debugRule("mainRun - gTreatyActive " + gTreatyActive, 0); 
	gGameType = aiGetGameType(); debugRule("mainRun - gGameType " + gGameType, 0); 
	
	gMaxVillPop = kbGetBuildLimit(cMyID, gEconUnit); debugRule("mainRun - gMaxVillPop " + gMaxVillPop, 0);


	gNavyFlagUnit = getUnit(cUnitTypeHomeCityWaterSpawnFlag, cMyID); debugRule("mainRun - gNavyFlagUnit " + gNavyFlagUnit, 0); 
	if (gNavyFlagUnit > 0)
	{ //check if the ai has a water flag
		gNavyFlagLocation = kbUnitGetPosition(gNavyFlagUnit);
		aiSetWaterMap(true);
		gWaterMap = true;
		debugRule("mainRun - is a water map", 1); 
	} //end if

	if(aiGetAutosaveOn())gAutoSaveStatus = true;

	initArrays(); // Create the global arrays
	aiRandSetSeed(-1); // Set our random seed.  "-1" is a random init
	kbAreaCalculate(); // Analyze the map, create area matrix
	aiPopulatePoliticianList(); // Fill out the PoliticanLists.
	setPersonality(); //Find out what our personality is, init variables from it.
	preInit(); //Allow loader file to change default values before we start.
	kbLookAtAllUnitsOnMap(); //all Difficulty levels now look at the map at start
	autoSaveManager(); //Trigger first autosave immediately
	init();

	if ((gGameType == cGameTypeCampaign) || (gGameType == cGameTypeScenario)) 
	{ //Set gSPC
		gSPC = true; //Checks if game type is Campaign or Scenario,default is false
		debugRule("mainRun - gGameType is cGameTypeCampaign or cGameTypeScenario", 1); 
	} //end if

	if (gSPC)
	{ //set the opening strategy to 0 for campaigns and scenarios
		gOpeningStrategy = 0;
		debugRule("mainRun - gGameType is a cGameTypeCampaign or cGameTypeScenario  " + gGameType, 1); 
	} //end if
	else if(gTreatyActive == false)
	{ //Set a opening strategy
		switch (aiRandInt(3))
		{ //Randomly pick an open strategy
			case 0: { gOpeningStrategy = 1; debugRule("mainRun - gOpeningStrategy 1 rush", 1); break; } //rush in age 2
			case 1: { gOpeningStrategy = 2; debugRule("mainRun - gOpeningStrategy 2 fast age 3", 1); break; } //get to age 3 fast
			default:{ gOpeningStrategy = 0; debugRule("mainRun - gOpeningStrategy 0", 1); break; }
		} //end switch
	} //end else if
	else if(gTreatyActive)
	{ //set Treaty opening
		gOpeningStrategy = 2;
		debugRule("mainRun - gGameType is treaty", 1); 
	} //end else if
	else
	{ //set default opening
		gOpeningStrategy = 0;
		debugRule("mainRun - gGameType is 0", 1); 
	} //end else

	for(i = 1; < cNumberPlayers)
	{ //Removed kbIsPlayerHuman(int player) calls, now all values are stored once in an array
		xsArraySetBool(gPlayerHumanStatusArray,i,kbIsPlayerHuman(i));
		debugRule("mainRun - player " + i + " humanStatus " + kbIsPlayerHuman(i), 1);
	} //end for i

	//Set ai handiCap
	float startingHandicap = kbGetPlayerHandicap(cMyID); //get Handicap for player
	float sandboxHandicap = 0.5;
	float easyHandicap = 1.0;
	float moderateHandicap = 1.2;
	float hardHandicap = 1.3;
	float expertHandicap = 1.6;
	debugRule("mainRun - gWorldDifficulty " + gWorldDifficulty, 1);
	switch (gWorldDifficulty)
	{ //set Difficulty properties 
		case cDifficultySandbox: // Sandbox
		{ //Sandbox mode
				kbSetPlayerHandicap(cMyID, startingHandicap * sandboxHandicap); //Set handicap to a small fraction of baseline, i.e. minus %.
				gDelayAttacks = true; // Prevent attacks...actually stays that way, never turns true.
				cvOkToBuildForts = false; //Do not build forts
				break;
		} //end case
		case cDifficultyEasy: { kbSetPlayerHandicap(cMyID, startingHandicap * easyHandicap); break; } 
		case cDifficultyModerate: { kbSetPlayerHandicap(cMyID, startingHandicap * moderateHandicap); break; }
		case cDifficultyHard: { kbSetPlayerHandicap(cMyID, startingHandicap * hardHandicap); break; }
		case cDifficultyExpert: { kbSetPlayerHandicap(cMyID, startingHandicap * expertHandicap); break; }
	} //end switch
	
	if (cvInactiveAI == true)
	{ //using inactive ai
		cvOkToSelectMissions = false; cvOkToTrainArmy = false; cvOkToAllyNatives = false; cvOkToClaimTrade = false; cvOkToGatherFood = false; 
		cvOkToGatherGold = false; cvOkToGatherWood = false; cvOkToExplore = false; cvOkToResign = false; cvOkToAttack = false;
		debugRule("mainRun - cvInactiveAI is true ", 1);
	} //end if

	if (gSPC == true)
	{ // Figure out the starting conditions, and deal with them.
		cvOkToTaunt = false; //Taunt defaults to true, but needs to be false in scenario games.
		// Wait for the aiStart unit to appear, then figure out what to do.
		// That rule will have to set the start mode to ScenarioTC or ScenarioNoTC.
		xsEnableRule("waitForStartup");
		debugRule("mainRun - gSPC is true ", 1);
	} //end if
	else
	{ //RM or GC game
		debugRule("mainRun - RM or GC game", 1);
		aiSetRandomMap(true); //set to use random map
		if (gTownCenterNumber > 0)
		{ //Check for a TC.
			debugRule("mainRun - RM or GC game - TC start", 2);
			gStartMode = gStartModeLandTC; // TC start
			popManager(); //Call the rule once as a function, to get all the pop limits set up.  
		} //end if
		else
		{ // Check for a Boat.
			if (kbUnitCount(cMyID, cUnitTypeAbstractWarShip, cUnitStateAlive) > 0)
			{
				debugRule("mainRun - RM or GC game - boat start", 2);
				gStartMode = gStartModeBoat;
				aiSetHandler("transportArrive", cXSHomeCityTransportArriveHandler); // Needed for first transport unloading 
				xsEnableRule("initializeAIFailsafe"); // Rule that fires after 30 seconds in case something goes wrong with unloading
			} //end if
			else
			{ // This must be a land nomad start
				gStartMode = gStartModeLandWagon;
				transportArrive(); // Call the function that sets up explore plans, etc.
			} //end else
		} //end else
	} //end else

	if (gNomadStart)
	{ //Create a build plan for nomad start
		debugRule("mainRun - nomad start ", 2);
		int startingWagon = getUnit(gCoveredWagonUnit, cMyID);
		createLocationBuildPlan(gTownCenter, 1, 100, true, cEconomyEscrowID, kbUnitGetPosition(startingWagon),1, startingWagon);
		aiTaskUnitBuild(startingWagon, gTownCenter, kbUnitGetPosition(startingWagon));
	} //end if

	if ((gGameType != cGameTypeCampaign) && (gGameType != cGameTypeScenario))
	{ //send AI info
		for (i = 1; < cNumberPlayers)
		{ //loop through players
			if(xsArrayGetBool(gPlayerHumanStatusArray,i) == false)
			{ //Skip if human
				if (i == cMyID)
				{ //Only send chat if t matches player id
					if (gWorldDifficulty == cDifficultySandbox) xsNotify("The Improved AI version " + gVersionNumber + " - Time for some sleep");
					else if (gWorldDifficulty == cDifficultyEasy) xsNotify("The Improved AI version " + gVersionNumber + " - So we play on an even playing field, Good Luck");
					else if (gWorldDifficulty == cDifficultyModerate) xsNotify("The Improved AI version " + gVersionNumber + " - If you do not mind I will help myself to a few coins in the war chest (Handicap 1.2)");
					else if (gWorldDifficulty == cDifficultyHard) xsNotify("The Improved AI version " + gVersionNumber + " - Ah finally a worthy opponent, Good Luck (Handicap 1.3 + AI EarlyCheats and AI LateCheats)");
					else if (gWorldDifficulty == cDifficultyExpert) xsNotify("The Improved AI version " + gVersionNumber + " - Now you're in for it! (Handicap 1.6 + AI EarlyCheats and AI LateCheats)");
					if(kbGetHCLevel(cMyID) < 100) xsNotify("I see that my Home City Level is below 100. As a result, I will not be able to pick my favourite cards, which is a pity");
				} //end if
				break; //ai was found break so other ai's do not resend message
			} //end if
		} //end for i
	} //end if
	
	
	if(getMapIsIsland() && gMainTownCenter == -1) waterFindShoreline();
	xsEnableRule("createHomeBase");
	if(gNomadStart == false)
	{
		xsEnableRule("mainTimer");
		xsEnableRuleGroup("startup");
		econManager();

		if(kbUnitCount(cMyID, gTownCenter, cUnitStateAlive) == 0 && gSPC == false) 
		{
			for (i = 1; < cNumberPlayers)
			{ 
				if(kbUnitCount(i, gTownCenter, cUnitStateAlive) > 0)
				{
					messagePlayers("It seems that I did not start with a Town Center. Can we please restart the game??");
					break;
				}
			}
			
		}
	}
	if(kbGetCiv() == cCivColombians) messagePlayers("This civilization is still under development and not complete");
	debugRule("mainRun - end", 0);
} //end main

//==============================================================================
// settlerGarrison
// updatedOn 2019/12/09 By ageekhere
//==============================================================================
//OOS ISSUES
/*
rule settlerGarrison
inactive
minInterval 1
//void garrison()
{
	if (aiTreatyActive() == true) return;
	static int timeout = 0;
	if (timeout > 0) timeout = timeout - 1;

	if (kbGetAge() >= cAge2)
	{
		static int nearTC = -1;
		if (nearTC == -1) nearTC = kbUnitQueryCreate("nearTC");
		kbUnitQuerySetPlayerID(nearTC, cMyID, false);
		kbUnitQuerySetUnitType(nearTC, gTownCenter);
		kbUnitQuerySetState(nearTC, cUnitStateAlive);
		kbUnitQueryResetResults(nearTC);

		static int nearBuilding = -1;
		if (nearBuilding == -1) nearBuilding = kbUnitQueryCreate("nearBuilding");
		kbUnitQuerySetPlayerID(nearBuilding, cMyID, false);
		kbUnitQuerySetUnitType(nearBuilding, cUnitTypeAbstractFort);
		kbUnitQuerySetState(nearBuilding, cUnitStateAlive);
		kbUnitQueryResetResults(nearBuilding);

		int settlerID = -1;
		int nearestId = -1;
		float lastDist = 999999;
		int buildingId = -1;
		float currentDist = 0;
		bool sendDefend = true;
		for (i = 0; < gCurrentAliveSettlers)
		{
			settlerID = FIND(gEconUnit, cMyID, i);
			nearestId = -1;
			lastDist = 999999;
			buildingId = -1;

			for (t = 0; < kbUnitQueryExecute(nearTC))
			{
				buildingId = kbUnitQueryGetResult(nearTC, t);
				currentDist = distance(kbUnitGetPosition(settlerID), kbUnitGetPosition(buildingId));
				if (currentDist < lastDist)
				{
					lastDist = currentDist;
					nearestId = buildingId;
				}
			}
			for (t = 0; < kbUnitQueryExecute(nearBuilding))
			{
				buildingId = kbUnitQueryGetResult(nearBuilding, t);
				if (kbUnitIsType(buildingId, cUnitTypeVictoryPointBuilding) == true) continue;
				if (kbUnitIsType(buildingId, cUnitTypeAbstractHouse) == true) continue;
				if (kbUnitGetProtoUnitID(buildingId) == 299) continue;
				currentDist = distance(kbUnitGetPosition(settlerID), kbUnitGetPosition(buildingId));
				if (currentDist < lastDist)
				{
					lastDist = currentDist;
					nearestId = buildingId;
				}
			}
			if (getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, kbUnitGetPosition(settlerID), 15) > 3)
			{
				aiPlanDestroy(kbUnitGetPlanID(settlerID));
				aiTaskUnitWork(settlerID, nearestId);
				timeout = 10;
				if (sendDefend == true)
				{
					moveDefenseReflex(kbUnitGetPosition(settlerID), cvDefenseReflexRadiusActive, kbBaseGetMainID(cMyID));
					sendDefend = false;
				}
			}
			if (timeout == 0)
			{
				for (t = 0; < kbUnitQueryExecute(nearTC))
				{

					if (getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, kbUnitGetPosition(kbUnitQueryGetResult(nearTC, t)), 30) < 3 && kbUnitGetNumberContained(kbUnitQueryGetResult(nearTC, t)) > 0) // && lastDist < 6)
					{
						aiTaskUnitEject(kbUnitQueryGetResult(nearTC, t));
					}
				}
				for (t = 0; < kbUnitQueryExecute(nearBuilding))
				{

					if (getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, kbUnitGetPosition(kbUnitQueryGetResult(nearBuilding, t)), 30) < 3 && kbUnitGetNumberContained(kbUnitQueryGetResult(nearBuilding, t)) > 0) // && lastDist < 6)
					{
						aiTaskUnitEject(kbUnitQueryGetResult(nearBuilding, t));
					}
				}
			}
		}
	}
}
*/
//==============================================================================
/*
	mainRun
	updatedOn 2023/06/25
	The main timer, makes each ai wait for their turn and also cuts up work over 
	multiple Intervals 
*/
//==============================================================================
rule mainTimer
active
minInterval 0
{	
	debugRule("mainTimer", -1);
	static int pCurrentFrame = 0;
	static int pOtherPlayerCurrentFrame = 1000;
	static int pPlayer = 1;
	static int pSavedPlayer = -1;
	static bool pNextTurn = false;
	static bool pUpdateGlobals = true;
	static bool pNomadStartEnd = false;
	static int pSafeExit = -1;
	static bool pExitWhile = true;
	static int pNumOfFunctions = 90;
	if(cvInactiveAI) { debugRule("mainTimer - AI is inactive", -1); return; } 
	pNextTurn = false;

	if(pSavedPlayer == -1)
	{
		debugRule("mainTimer - pSavedPlayer is -1", 1);
		if(gNomadStart && pNomadStartEnd == false)
		{ //check for nomad start
			if (kbUnitCount(cMyID, gTownCenter, cUnitStateAlive) == 0 && kbUnitCount(cMyID, gEconUnit, cUnitStateAlive) == 0 ) 
			{ //check for town center and settlers
				debugRule("mainTimer - Is a nomad start and there is no tc yet", 2); 
				return;
			} //end if
			if(cvInactiveAI == true) { debugRule("mainTimer - AI now ready to start from nomad", 1); return; } 
			pNomadStartEnd = true;
		} //end if

		if(pOtherPlayerCurrentFrame < 90)
		{ //counts what Interval the current ai player is on and waits until they are finish
			pOtherPlayerCurrentFrame++;
			debugRule("mainTimer - pOtherPlayerCurrentFrame " + pOtherPlayerCurrentFrame, 1);
			return;
		} //end if
		pOtherPlayerCurrentFrame = 1; //start from at 1

		pSafeExit = 0; //A just in case safe exit
		while(true)
		{ //find the next alive ai player
			pExitWhile = true;
			pSafeExit++;
			debugRule("mainTimer - pSafeExit " + pSafeExit, 1); 
			if(pSafeExit == 100)
			{ //a just in cause exit
				debugRule("mainTimer - pSafeExit Warning hit", 1); 
				break;
			} //end if
			if(pPlayer < cNumberPlayers -1) 
			{
				pPlayer++;
				debugRule("mainTimer - pPlayer++ " + pPlayer, 1); 
			}
			else 
			{
				pPlayer = 1;
				debugRule("mainTimer - pPlayer " + pPlayer, 1); 
			}
			if (xsArrayGetBool(gPlayerHumanStatusArray,pPlayer) ||  getIsPlayerAlive(pPlayer) == false) 
			{ //check if human or player is dead
				debugRule("mainTimer - skip player " + pPlayer, 1);
				pExitWhile = false;
			} //end if
			if(pExitWhile) 
			{
				debugRule("mainTimer - exit while ", 1);
				break;
			}
		}
		if (pPlayer != cMyID) 
		{
			return;
		}
		pSavedPlayer = pPlayer;
	} //end if
	
	if(pUpdateGlobals == true)
	{ //update globals only on a new ai player's turn once
		pUpdateGlobals = false;
		gCurrentGameTime = xsGetTime(); //replaces xsGetTime() calls with an already stored value
		gTownCenterNumber = kbUnitCount(cMyID, gTownCenter, cUnitStateAlive);
		gCurrentWood = kbResourceGet(cResourceWood);
		gCurrentFood = kbResourceGet(cResourceFood);
		gCurrentCoin = kbResourceGet(cResourceGold);
		gCurrentFame = kbResourceGet(cResourceFame);
		gCurrentAge = kbGetAge();
		gCurrentPop = kbGetPop();
		gCurrentPopCap = kbGetPopCap();
		gCurrentAliveSettlers = getPlayerAliveSettlers();
		gCurrentIdleSettlers = getPlayerIdleSettlers();
		gGoodArmyPop = aiGetMilitaryPop();
		gSettlerWagonNum = kbUnitCount(cMyID, cUnitTypeSettlerWagon, cUnitStateAlive);
		gBankNum = kbUnitCount(cMyID, cUnitTypeBank, cUnitStateAlive);
		gFactoryNum = kbUnitCount(cMyID, cUnitTypeFactory, cUnitStateAlive);
		if(gWaterMap) gFishingUnitNum = kbUnitCount(cMyID, gFishingUnit, cUnitStateAlive);
		enemyLandMilitaryQry();
		selfLandMilitaryQry();
		if(gTreatyActive == true) gTreatyActive = aiTreatyActive();
		gGetMostHatedPlayerID = aiGetMostHatedPlayerID();
		AI_AutoRepair();
		AI_EarlyCheats();
		AI_LateCheats();
		if (gMainBase == -1) gMainBase = kbBaseGetMainID(cMyID);
		if (gMainBaseLocation == cInvalidVector) gMainBaseLocation = kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID));
		if(gMainTownCenter == -1 || kbUnitGetHealth(gMainTownCenter) == 0) gMainTownCenter = getUnit(gTownCenter, cMyID, cUnitStateABQ);
		if(gMainTownCenter != -1 ) gMainTownCenterLocation = kbUnitGetPosition(gMainTownCenter);
		
		gMainBaseUnderAttack = kbBaseGetUnderAttack(cMyID,gMainBase);
		if(gMainBaseUnderAttack && getUnitByLocation(cUnitTypeMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, gMainBaseLocation, 20.0) < 3) gMainBaseUnderAttack = false;
		gNumTowers = kbGetBuildLimit(cMyID, gTowerUnit);
	} //end if
	
	if(gMainTownCenter == -1)
	{
		pUpdateGlobals = true;
		return;
	}

	switch(pCurrentFrame)
	{ //Runs each function in a new frame to avoid lag
		case 0: { setBaseFrontBack(); break; }
		case 1: { idleSettlerMonitor(); break; }
		case 2: { popManager(); break; }	
		case 3: { econManager(); break; }
		case 4: { ageUpgradeMonitor(); break; } 
		case 5: { ageMonitor(); break; } //could be removed
		case 6: { buildingMonitor(); break; }
		case 7: { autoSaveManager(); break; }
		case 8: { buildEconomy(); break; }
		case 9: { buyCards(); break; }
		case 10: { militaryManager(); break; }	
		case 11: { newAttack(); break; }
		case 12: { researchTech(); break; }
		case 13: { bankWagonMonitor(); break; }
		case 14: { blackPowderManager(); break; }
		case 15: { brigadeMonitor(); break; }
		case 16: { buildTownCenterMonitor(); break; }
		case 17: { call_levies(); break; }
		case 18: { capitolArmyManager(); break; }
		case 19: { consulateLevy(); break; }
		case 20: { consulateMonitor(); break; }
		case 21: { coveredWagonMonitor(); break; }
		case 22: { createDefendPlan(); break; }
		case 23: { danceMonitor(); break; }
		case 24: { defendBaseManager(); break; }
		case 25: { defenseReflex(); break; }
		case 26: { dojoTacticMonitor(); break; }
		case 27: { exploreMonitor(); break; }
		case 28: { extraShipMonitor(); break; }
		case 29: { factoryTacticMonitor(); break; }
		case 30: { orphanBuildMonitor(); break; }
		case 31: { fishingShipManager(); break; }
		case 32: { fortMonitor(); break; }
		case 33: { forwardBaseManager(); break; }
		case 34: { fowardBuildingManager(); break; }
		case 35: { goldenPavillionTacticMonitor(); break; }
		case 36: { healerMonitor(); break; }
		case 37: { heroMonitor(); break; }
		case 38: { livestockFatten(); break; }
		case 39: { livestockManager(); break; }
		case 40: { strayLivestockMonitor(); break; }
		case 41: { mansabdarMonitor(); break; }
		case 42: { marketManager(); break; }
		case 43: { militaryRaid(); break; }
		case 44: { minorAsianDisciplinedUpgradeMonitor(); break; }
		case 45: { minorAsianHonoredUpgradeMonitor(); break; }
		case 46: { minorAsianTribeTechMonitor(); break; }
		case 47: { minorNativeChampionUpgradeMonitor(); break; }
		case 48: { minorTribeTechMonitor(); break; }
		case 49: { monopolyManager(); break; }
		case 50: { mortarManager(); break; }
		case 51: { mostHatedEnemy(); break; }
		case 52: { navyManager(); break; }
		case 53: { navyTransport(); break; }
		case 54: { nuggetGatheringManager(); break; }
		case 55: { nuggetHandler(); break; }
		case 56: { balloonMonitor(); break; }
		case 57: { outpostWagonManager(); break; }
		case 58: { petardManager(); break; }
		case 59: { porcelainTowerTacticMonitor(); break; }
		case 60: { ramManager(); break; }
		case 61: { ransomExplorerMonitor(); break; }
		case 62: { regicideMonitor(); break; }
		case 63: { rescueExplorerMonitor(); break; }
		case 64: { ricepaddyMonitor(); break; }
		case 65: { sacredFieldMonitor(); break; }
		case 66: { saveBase(); break; }
		case 67: { scoreMonitor(); break; }
		case 68: { scoutMonitor(); break; }
		case 69: { sendHelpToSaveTeam(); break; }
		case 70: { setFowardBuildings(); break; }
		case 71: { resignMonitor(); break; }
		case 72: { shrineMonitor(); break; }
		case 73: { spy(); break; }
		case 74: { summerPalaceTacticMonitor(); break; }
		case 75: { towerManager(); break; }
		case 76: { tradePostManager(); break; }
		case 77: { updateEscrows(); break; }
		case 78: { wagonMonitor(); break; }
		case 79: { wallMonitor(); break; }
		case 80: { warPartiesMonitor(); break; }
		case 81: { warriorSocietyUpgradeMonitor(); break; }
		case 82: { waterAttack(); break; }
		case 83: { waterFindShoreline(); break; }
		case 84: { xpBuilderMonitor(); break; }
		case 85: { kiteUnit(); break; }
		case 86: { destroyBuildPlanMonitor(); break; }
		//case 88: { bringInhuntMonitor(); break; }
		default:
		{
			pNextTurn = true;
			break;
		}
	} //end switch
	pCurrentFrame++;
	if(pNextTurn)
	{ //reset values
		pSavedPlayer = -1;
		pCurrentFrame = 0;
		pUpdateGlobals = true;
		pOtherPlayerCurrentFrame = 1000;
	} //end if
	debugRule("mainTimer - end", 0);
}

//To remove the delay in the settlers at the start of the game, make all settlers go to food and que settlers
rule startOfGame
active
minInterval 0
{ 
	if (kbCanAffordUnit(gEconUnit, cEconomyEscrowID) == true && getUnit(gTownCenter) != -1) aiTaskUnitTrain(getUnit(gTownCenter), gEconUnit);
	int pStartOfGameSettlerQryId = kbUnitQueryCreate("pStartOfGameSettlerQryId"+getQueryId());
	int pQryVale = -1;
	int pSettlerId = -1;
	int pResourceFoodId = -1;
	int pResourceCoinId = -1;
	int pResourceWoodId = -1;   
	vector pStartPosition = cInvalidVector;
	kbUnitQuerySetPlayerID(pStartOfGameSettlerQryId, cMyID, false);
	kbUnitQuerySetPlayerRelation(pStartOfGameSettlerQryId, -1);
	kbUnitQuerySetState(pStartOfGameSettlerQryId, cUnitStateAlive);
	kbUnitQuerySetUnitType(pStartOfGameSettlerQryId, cUnitTypeAffectedByTownBell);
	pQryVale = kbUnitQueryExecute(pStartOfGameSettlerQryId);
	pStartPosition = kbUnitGetPosition(getUnit(cUnitTypeTownCenter, cMyID, cUnitStateAlive));
	pResourceFoodId = getUnitByLocation(cUnitTypeFood, cPlayerRelationAny, cUnitStateAlive, pStartPosition, 10);
	pResourceCoinId = getUnitByLocation(cUnitTypeAbstractMine, cPlayerRelationAny, cUnitStateAlive, pStartPosition, 50);
	pResourceWoodId = getUnitByLocation(cUnitTypeWood, cPlayerRelationAny, cUnitStateAlive, pStartPosition, 10);
	for(i = 0; < pQryVale)
	{
		pSettlerId = kbUnitQueryGetResult(pStartOfGameSettlerQryId,i);
		switch(gCurrentCiv)
		{
			case cCivSpanish :
			{
				aiTaskUnitWork(pSettlerId, pResourceWoodId);
				break;
			}
			default :
			{
				if(i == 0) aiTaskUnitWork(pSettlerId, pResourceCoinId);
				else if(i == 1) aiTaskUnitWork(pSettlerId, pResourceWoodId);
				else aiTaskUnitWork(pSettlerId, pResourceFoodId);
			}
		}	
	}
	xsDisableSelf();
}

