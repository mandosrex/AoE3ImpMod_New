// NEW ENGLAND
// A Random Map for Age of Empires III: The Third One
// revised by RF_Gandalf for the AS Fan-Patch
// Update by iCourt
// Update by Garja

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{

	if (false) {
		sqrt(1);
	}


   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

   //Chooses which natives appear on the map
   int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;
   int subCiv3=-1;

	// Thingy to randomize location of the four "equal" VP sites.
	int vpLocation=-1;
	// vpLocation = rmRandInt(1,4);
	vpLocation = 1;

	int whichVariation=-1;
	// Used to be 1-4, but taking the mega-cliffs out for now.
//	whichVariation = rmRandInt(1,2);
	whichVariation = 2; ///only one island

	int whichNative=rmRandInt(1,4);
	if ( whichNative > 1 )
	{
		subCiv0=rmGetCivID("Huron");
		rmEchoInfo("subCiv0 is Huron "+subCiv0);

		subCiv1=rmGetCivID("Huron");
		rmEchoInfo("subCiv1 is Huron "+subCiv1);
	}
	else
	{
		subCiv0=rmGetCivID("Cherokee");
		rmEchoInfo("subCiv0 is Cherokee "+subCiv0);

		subCiv1=rmGetCivID("Cherokee");
		rmEchoInfo("subCiv1 is Cherokee "+subCiv1);
	}

	subCiv2=rmGetCivID("Cree");
	rmEchoInfo("subCiv2 is Cree "+subCiv2);

	rmSetSubCiv(0, "Cherokee", true);
	rmSetSubCiv(1, "Huron", true);
	rmSetSubCiv(2, "Cree", true);

	float handedness = rmRandFloat(0, 1);

   // Picks the map size
	int playerTiles=12500;
   if (cNumberNonGaiaPlayers >4)
		playerTiles = 11500;

   // Picks default terrain and water
   rmSetSeaType("new england coast");
   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

	// Some map turbulence...
	rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);  // Like Texas for the moment.
	rmSetMapElevationHeightBlend(0.2);

   // Picks a default water height
   rmSetSeaLevel(4.0);
   rmEnableLocalWater(false);
   rmTerrainInitialize("water");
	rmSetMapType("newEngland");
	rmSetMapType("water");
	rmSetWorldCircleConstraint(true);
	rmSetWindMagnitude(2.0);
	// rmSetLightingSet("new england start");
	rmSetLightingSet("new england");
	rmSetMapType("grass");
	rmSetMapType("namerica");
	rmSetMapType("AIFishingUseful");

	// Sets up the lighting change trigger - happy dawn in New England
	// REMOVED
	/*
	rmCreateTrigger("Day");
   rmSwitchToTrigger(rmTriggerID("Day"));
   rmSetTriggerActive(true);
   rmAddTriggerCondition("Timer");
   rmSetTriggerConditionParamInt("Param1", 2);
   rmAddTriggerEffect("Set Lighting");
   rmSetTriggerEffectParam("SetName", "new england");
   rmSetTriggerEffectParamInt("FadeTime", 120);
   */

	// Choose mercs.
	chooseMercs();

   // Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classCliff");
   rmDefineClass("classPatch");
	rmDefineClass("classWall");
   int classbigContinent=rmDefineClass("big continent");
   rmDefineClass("corner");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
	rmDefineClass("secrets");
	rmDefineClass("socketClass");
	rmDefineClass("nuggets");
   int classClearing=rmDefineClass("classClearing");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other

   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
   int avoidTownCenterMed=rmCreateTypeDistanceConstraint("avoid Town Center Med", "townCenter", 35.0);
   int avoidTownCenter40=rmCreateTypeDistanceConstraint("avoid Town Center by 40", "townCenter", 40.0);
   int avoidTownCenter50=rmCreateTypeDistanceConstraint("avoid Town Center by 50", "townCenter", 50.0);

   // Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 10.0);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("stuff stays away from players", classPlayer, 65.0);
   int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);
   int minePlayerConstraint=rmCreateClassDistanceConstraint("mine stays away from players", classPlayer, 40.0);

   // Directional constraints
	int Northeastward=rmCreatePieConstraint("northwestMapConstraint", 0.54, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(360), rmDegreesToRadians(180));  // 225 135, 300, 45
   int Southwestward=rmCreatePieConstraint("southeastMapConstraint", 0.46, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(180), rmDegreesToRadians(360));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.29, 0, rmZFractionToMeters(0.75), rmDegreesToRadians(5), rmDegreesToRadians(100));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.29, 0, rmZFractionToMeters(0.75), rmDegreesToRadians(260), rmDegreesToRadians(355));

   // Bonus area constraint.
   int bigContinentConstraint=rmCreateClassDistanceConstraint("avoid bonus island", classbigContinent, 18.0+cNumberNonGaiaPlayers);

   // Resource avoidance
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 13.0);
   int avoidDeer=rmCreateTypeDistanceConstraint("food avoids food", "deer", 45.0);
   int avoidDeerShort=rmCreateTypeDistanceConstraint("food avoids food short", "deer", 28.0);
	int avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", 30.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 50);
    int avoidCoinMin=rmCreateTypeDistanceConstraint("coin avoids coin min", "gold", 8);
   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 35.0);
   int avoidPlayerNugget=rmCreateTypeDistanceConstraint("player nugget avoid nugget", "AbstractNugget", 20.0);
   int avoidNuggetSmall=rmCreateTypeDistanceConstraint("nugget avoid nugget small", "AbstractNugget", 10.0);
   int avoidTree=rmCreateTypeDistanceConstraint("spacing for trees", "TreeNewEngland", 10.0);

	int mediumAvoidSilver=rmCreateTypeDistanceConstraint("medium gold avoid gold", "Mine", 30.0);
	if (cNumberNonGaiaPlayers > 4)
	   mediumAvoidSilver=rmCreateTypeDistanceConstraint("medium gold avoid gold shorter", "Mine", 20.0);

   // Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int avoidCliffs=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
	int avoidCliff = rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 6.0);
	int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int wallConstraint=rmCreateClassDistanceConstraint("wall vs. wall", rmClassID("classWall"), 40.0);
	int avoidSheep=rmCreateTypeDistanceConstraint("sheep avoids sheep", "sheep", 75.0);

   // Specify true so constraint stays outside of circle (i.e. inside corners)
   int cornerConstraint0=rmCreateCornerConstraint("in corner 0", 0, true);
   int cornerConstraint1=rmCreateCornerConstraint("in corner 1", 1, true);
   int cornerConstraint2=rmCreateCornerConstraint("in corner 2", 2, true);
   int cornerConstraint3=rmCreateCornerConstraint("in corner 3", 3, true);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 18.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);
   int avoidStartingUnitsLong=rmCreateClassDistanceConstraint("objects avoid starting units long", rmClassID("startingUnit"), 40.0);

   // ships vs. ships
   int shipVsShip=rmCreateTypeDistanceConstraint("ships avoid ship", "ship", 5.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 5.0);
   int avoidClearing=rmCreateClassDistanceConstraint("avoid clearings", rmClassID("classClearing"), 6.0);

   // VP avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 6.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 30.0);
	int avoidSocket=rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 10.0);

   // Constraint to avoid water.
   int avoidWater5 = rmCreateTerrainDistanceConstraint("avoid water 5", "Land", false, 5.0);
   int avoidWater15 = rmCreateTerrainDistanceConstraint("avoid water 10", "Land", false, 10.0);
   int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 20.0);
   int avoidWater30 = rmCreateTerrainDistanceConstraint("avoid water mid-long", "Land", false, 30.0);
   int avoidWater40 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 40.0);

   // New extra stuff for water spawn point avoidance.
	int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 20.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 15);
	int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-20, rmGetMapXSize()-10, 0, 0, 0);

	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

	int whaleLand = rmCreateTerrainDistanceConstraint("whale v. land", "land", true, 20.0);

   // Text
   rmSetStatusText("",0.10);

	// DEFINE AREAS
   // Set up player starting locations. These are just used to place Caravels away from each other.
   /* DAL - old placement.
	rmSetPlacementSection(0.35, 0.65);
   rmSetTeamSpacingModifier(0.50);
   rmPlacePlayersCircular(0.45, 0.45, rmDegreesToRadians(5.0));
	*/

   // Text
   rmSetStatusText("",0.20);

	// Build up big continent - called, unoriginally enough, "big continent"
   int bigContinentID=rmCreateArea("big continent");
   rmSetAreaSize(bigContinentID, 0.52, 0.52);		// 0.65, 0.65
   rmSetAreaWarnFailure(bigContinentID, false);
   rmAddAreaToClass(bigContinentID, classbigContinent);
   rmSetAreaSmoothDistance(bigContinentID, 25);
	rmSetAreaMix(bigContinentID, "newengland_grass");
   rmSetAreaElevationType(bigContinentID, cElevTurbulence);
   rmSetAreaElevationVariation(bigContinentID, 2.0);
   rmSetAreaBaseHeight(bigContinentID, 6.0);
   rmSetAreaElevationMinFrequency(bigContinentID, 0.09);
   rmSetAreaElevationOctaves(bigContinentID, 3);
   rmSetAreaElevationPersistence(bigContinentID, 0.2);
	rmSetAreaCoherence(bigContinentID, 0.5);
	rmSetAreaLocation(bigContinentID, 0.5, 0.85);
   rmSetAreaEdgeFilling(bigContinentID, 5);
	rmSetAreaObeyWorldCircleConstraint(bigContinentID, false);
	rmBuildArea(bigContinentID);

	rmSetStatusText("",0.30);

	// Build up small continent spurs called "small continent spur 1 & 2"
   int smallContinent1ID=rmCreateArea("small continent spur 1");
   rmSetAreaSize(smallContinent1ID, 0.2, 0.2);
   rmSetAreaWarnFailure(smallContinent1ID, false);
   rmAddAreaToClass(smallContinent1ID, classbigContinent);
   rmSetAreaSmoothDistance(smallContinent1ID, 25);
	rmSetAreaMix(smallContinent1ID, "newengland_grass");
   rmSetAreaElevationType(smallContinent1ID, cElevTurbulence);
   rmSetAreaElevationVariation(smallContinent1ID, 2.0);
   rmSetAreaBaseHeight(smallContinent1ID, 6.0);
   rmSetAreaElevationMinFrequency(smallContinent1ID, 0.09);
   rmSetAreaElevationOctaves(smallContinent1ID, 3);
   rmSetAreaElevationPersistence(smallContinent1ID, 0.2);
	rmSetAreaCoherence(smallContinent1ID, 0.5);
	rmSetAreaLocation(smallContinent1ID, 0.8, 0.6);
   rmSetAreaEdgeFilling(smallContinent1ID, 5);
   rmSetAreaObeyWorldCircleConstraint(smallContinent1ID, false);
	rmBuildArea(smallContinent1ID);

   rmSetStatusText("",0.35);

	// Build up small continent spurs called "small continent spur 1 & 2"
   int smallContinent2ID=rmCreateArea("small continent spur 2");
   rmSetAreaSize(smallContinent2ID, 0.2, 0.2);
   rmSetAreaWarnFailure(smallContinent2ID, false);
   rmAddAreaToClass(smallContinent2ID, classbigContinent);
   rmSetAreaSmoothDistance(smallContinent2ID, 25);
	rmSetAreaMix(smallContinent2ID, "newengland_grass");
   rmSetAreaElevationType(smallContinent2ID, cElevTurbulence);
   rmSetAreaElevationVariation(smallContinent2ID, 2.0);
   rmSetAreaBaseHeight(smallContinent2ID, 6.0);
   rmSetAreaElevationMinFrequency(smallContinent2ID, 0.09);
   rmSetAreaElevationOctaves(smallContinent2ID, 3);
   rmSetAreaElevationPersistence(smallContinent2ID, 0.2);
	rmSetAreaCoherence(smallContinent2ID, 0.5);
	rmSetAreaLocation(smallContinent2ID, 0.2, 0.6);
   rmSetAreaEdgeFilling(smallContinent2ID, 5);
   rmSetAreaObeyWorldCircleConstraint(smallContinent2ID, false);
	rmBuildArea(smallContinent2ID);


	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
  // Set up player starting locations.

		teamZeroCount = cNumberNonGaiaPlayers / 2;
		teamOneCount = cNumberNonGaiaPlayers / 2;

		int playerSide = rmRandInt(1,2);

		if ( cNumberTeams == 2 )
		{
		 if (playerSide == 1)
			rmSetPlacementTeam(0);
		 else
			rmSetPlacementTeam(1);
		 rmPlacePlayersLine(0.2, 0.5, 0.2, 0.8, 0.0, 0.2);

		 if (playerSide == 1)
			rmSetPlacementTeam(1);
		 else
			rmSetPlacementTeam(0);
		 rmPlacePlayersLine(0.8, 0.5, 0.8, 0.8, 0.0, 0.2);
		}
		else
		{
			rmSetPlacementSection(0.75, 0.25);
			rmSetTeamSpacingModifier(0.75);
			rmPlacePlayersCircular(0.4, 0.4, 0);
		}


    // Set up player areas.
   float playerFraction=rmAreaTilesToFraction(100);
   for(i=1; <cNumberPlayers)
   {
      // Create the area.
      int id=rmCreateArea("Player"+i);
      // Assign to the player.
      rmSetPlayerArea(i, id);
      // Set the size.
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      // rmAddAreaConstraint(id, playerConstraint);
      // rmAddAreaConstraint(id, playerEdgeConstraint);
      rmSetAreaLocPlayer(id, i);
      rmSetAreaWarnFailure(id, false);
   }

   // Build the areas.
   rmBuildAllAreas();

// Clearing areas
   int northClearArea=rmCreateArea("north clearing");
   rmSetAreaSize(northClearArea, 0.035, 0.035);
   rmSetAreaLocation(northClearArea, 0.5, 0.8);
   rmAddAreaInfluenceSegment(northClearArea, 0.5, 0.8, 0.75, 0.72);
   rmAddAreaInfluenceSegment(northClearArea, 0.5, 0.8, 0.25, 0.72);
   rmSetAreaCoherence(northClearArea, 0.99);
   rmSetAreaSmoothDistance(northClearArea, 20);
   rmAddAreaToClass(northClearArea, rmClassID("classClearing"));

   int southClearArea=rmCreateArea("south clearing");
   rmSetAreaSize(southClearArea, 0.035, 0.035);
   rmSetAreaLocation(southClearArea, 0.5, 0.415);
   rmAddAreaInfluenceSegment(southClearArea, 0.5, 0.415, 0.75, 0.5);
   rmAddAreaInfluenceSegment(southClearArea, 0.5, 0.415, 0.25, 0.5);
   rmSetAreaCoherence(southClearArea, 0.99);
   rmSetAreaSmoothDistance(southClearArea, 20);
   rmAddAreaToClass(southClearArea, rmClassID("classClearing"));

   int eastClearArea=rmCreateArea("east clearing");
   rmSetAreaSize(eastClearArea, 0.02, 0.02);
   rmSetAreaLocation(eastClearArea, 0.71, 0.65);
   rmAddAreaInfluenceSegment(eastClearArea, 0.71, 0.65, 0.71, 0.5);
   rmAddAreaInfluenceSegment(eastClearArea, 0.71, 0.65, 0.74, 0.78);
   rmSetAreaCoherence(eastClearArea, 0.99);
   rmSetAreaSmoothDistance(eastClearArea, 20);
   rmAddAreaToClass(eastClearArea, rmClassID("classClearing"));

   int westClearArea=rmCreateArea("west clearing");
   rmSetAreaSize(westClearArea, 0.02, 0.02);
   rmSetAreaLocation(westClearArea, 0.29, 0.65);
   rmAddAreaInfluenceSegment(westClearArea, 0.29, 0.65, 0.29, 0.5);
   rmAddAreaInfluenceSegment(westClearArea, 0.29, 0.65, 0.26, 0.78);
   rmSetAreaCoherence(westClearArea, 0.99);
   rmSetAreaSmoothDistance(westClearArea, 20);
   rmAddAreaToClass(westClearArea, rmClassID("classClearing"));

   rmBuildAllAreas();

   // Placement order
   // Trade route -> Lakes -> Natives -> Secrets -> Cliffs -> Nuggets
   // Text
   rmSetStatusText("",0.40);

   // TRADE ROUTES
	int tradeRouteID = rmCreateTradeRoute();

	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);
	if ( cNumberNonGaiaPlayers < 4 )
	{
		rmAddObjectDefConstraint(socketID, avoidWater15); // To make it avoid the water and the cliffs.
		rmAddObjectDefConstraint(socketID, avoidCliff);
	}

	else
	{
		rmAddObjectDefConstraint(socketID, avoidWater20); // To make it avoid the water and the cliffs - by more if larger map
		rmAddObjectDefConstraint(socketID, avoidCliff);
	}

	// Hacky trade route stuff for weird FFA cases, to handle player placement.
	if ( cNumberTeams == 3 || cNumberTeams > 4 )
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.8);
	}
	else
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 1.0);
	}
	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 1.0);

	if ( cNumberNonGaiaPlayers < 4 )
	{
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.45, 10, 2);
	}
	else
	{
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.4, 10, 4);
	}

   bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route");

	// add the meeting poles along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.4);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.65);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.95);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	// LAKES
	int lakeClass=rmDefineClass("lake");
	int lakeConstraint=rmCreateClassDistanceConstraint("lake vs. lake", rmClassID("lake"), 20.0);

	// Half the time there are two extra lakes.
	int extraLakes=-1;
	extraLakes = rmRandInt(1,2);

   int numLakeTrees = -1;
   int lakeTreeID=rmCreateObjectDef("lake trees");
//   rmAddObjectDefItem(lakeTreeID, "TreeNewEngland", 2, 2.0);
   rmSetObjectDefMinDistance(lakeTreeID, 0);
   rmSetObjectDefMaxDistance(lakeTreeID, 10);
   rmAddObjectDefConstraint(lakeTreeID, avoidAll);
   rmAddObjectDefConstraint(lakeTreeID, avoidSocket);
   rmAddObjectDefConstraint(lakeTreeID, avoidTradeRoute);
   rmAddObjectDefConstraint(lakeTreeID, avoidCliff);

	int smalllakeID=rmCreateArea("small lake 1");

	/*
	if ( whichVariation < 3 )
	{
		if ( cNumberNonGaiaPlayers < 4 )
			rmSetAreaSize(smalllakeID, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
		else if ( cNumberNonGaiaPlayers < 6 )
			rmSetAreaSize(smalllakeID, rmAreaTilesToFraction(700), rmAreaTilesToFraction(700));
		else
			rmSetAreaSize(smalllakeID, rmAreaTilesToFraction(900), rmAreaTilesToFraction(900));
		rmSetAreaWaterType(smalllakeID, "new england lake");
		rmSetAreaBaseHeight(smalllakeID, 2.0);
		rmSetAreaMinBlobs(smalllakeID, 3);
		rmSetAreaMaxBlobs(smalllakeID, 3);
		rmSetAreaMinBlobDistance(smalllakeID, 8.0);
		rmSetAreaMaxBlobDistance(smalllakeID, 12.0);
		// rmSetAreaSmoothDistance(smalllakeID, 20);
		rmAddAreaToClass(smalllakeID, lakeClass);
		rmAddAreaConstraint(smalllakeID, playerConstraint);
		rmAddAreaConstraint(smalllakeID, avoidTradeRoute);
		rmAddAreaConstraint(smalllakeID, avoidSocket);
		rmSetAreaLocation(smalllakeID, 0.38, 0.65);
		rmAddAreaInfluenceSegment(smalllakeID, 0.4, 0.50, 0.34, 0.66);
		rmSetAreaCoherence(smalllakeID, 0.7);
		rmSetAreaWarnFailure(smalllakeID, false);
		rmBuildArea(smalllakeID);


		int smalllakeID2=rmCreateArea("small lake 2");
		if ( cNumberNonGaiaPlayers < 4 )
			rmSetAreaSize(smalllakeID2, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
		else if ( cNumberNonGaiaPlayers < 6 )
			rmSetAreaSize(smalllakeID2, rmAreaTilesToFraction(700), rmAreaTilesToFraction(700));
		else
			rmSetAreaSize(smalllakeID2, rmAreaTilesToFraction(770), rmAreaTilesToFraction(770));
		rmSetAreaWaterType(smalllakeID2, "new england lake");
		rmSetAreaBaseHeight(smalllakeID2, 2.0);
		rmSetAreaMinBlobs(smalllakeID2, 3);
		rmSetAreaMaxBlobs(smalllakeID2, 3);
		rmSetAreaMinBlobDistance(smalllakeID2, 5.0);
		rmSetAreaMaxBlobDistance(smalllakeID2, 10.0);
		// rmSetAreaSmoothDistance(smalllakeID2, 20);
		rmAddAreaToClass(smalllakeID2, lakeClass);
		rmAddAreaConstraint(smalllakeID2, playerConstraint);
		rmAddAreaConstraint(smalllakeID2, avoidTradeRoute);
		rmAddAreaConstraint(smalllakeID2, avoidSocket);
		rmSetAreaLocation(smalllakeID2, 0.62, 0.65);
		rmAddAreaInfluenceSegment(smalllakeID2, 0.6, 0.50, 0.66, 0.66);
		rmSetAreaCoherence(smalllakeID2, 0.7);
		rmSetAreaWarnFailure(smalllakeID2, false);
		rmBuildArea(smalllakeID2);


		// Two extra lakes?  Sometimes - only if more than two players.
		if ( extraLakes == 2 && cNumberNonGaiaPlayers > 2 )
		{
			int smallLakeID3=rmCreateArea("small lake 3");
			rmSetAreaSize(smallLakeID3, rmAreaTilesToFraction(380), rmAreaTilesToFraction(380));
			rmSetAreaWaterType(smallLakeID3, "new england lake");
			rmSetAreaBaseHeight(smallLakeID3, 2.0);
			rmAddAreaToClass(smallLakeID3, lakeClass);
			rmAddAreaConstraint(smallLakeID3, playerConstraint);
			rmAddAreaConstraint(smallLakeID3, avoidTradeRoute);
			rmSetAreaLocation(smallLakeID3, 0.16, 0.65);
			rmSetAreaCoherence(smallLakeID3, 0.3);
			rmSetAreaWarnFailure(smallLakeID3, false);
	//		rmBuildArea(smallLakeID3);

      		numLakeTrees = rmRandInt(5,8);
     			for (j=0; <numLakeTrees)
         	   	   rmPlaceObjectDefInArea(lakeTreeID, 0, rmAreaID("small lake 3"), rmRandInt(2,3));

			int smallLakeID4=rmCreateArea("small lake 4");
			rmSetAreaSize(smallLakeID4, rmAreaTilesToFraction(380), rmAreaTilesToFraction(380));
			rmSetAreaWaterType(smallLakeID4, "new england lake");
			rmSetAreaBaseHeight(smallLakeID4, 2.0);
			rmAddAreaToClass(smallLakeID4, lakeClass);
			rmAddAreaConstraint(smallLakeID4, playerConstraint);
			rmAddAreaConstraint(smallLakeID4, avoidTradeRoute);
			rmSetAreaLocation(smallLakeID4, 0.84, 0.65);
			rmSetAreaCoherence(smallLakeID4, 0.3);
			rmSetAreaWarnFailure(smallLakeID4, false);
	//		rmBuildArea(smallLakeID4);

      		numLakeTrees = rmRandInt(5,8);
     			for (j=0; <numLakeTrees)
         	   	   rmPlaceObjectDefInArea(lakeTreeID, 0, rmAreaID("small lake 4"), rmRandInt(2,3));
		}
	}
	*/

	// Place two crazy cliffs at the spots the lakes WOULD have been otherwise (i.e., if the lakes aren't there).

	if ( whichVariation < 3 )
	{
		int bigCliff1ID=rmCreateArea("big cliff 1");
		if ( cNumberNonGaiaPlayers < 4 )
			rmSetAreaSize(bigCliff1ID, rmAreaTilesToFraction(400), rmAreaTilesToFraction(400));
		else if ( cNumberNonGaiaPlayers < 6 )
			rmSetAreaSize(bigCliff1ID, rmAreaTilesToFraction(500), rmAreaTilesToFraction(500));
		else
			rmSetAreaSize(bigCliff1ID, rmAreaTilesToFraction(700), rmAreaTilesToFraction(700));
		rmSetAreaWarnFailure(bigCliff1ID, false);
		rmSetAreaCliffType(bigCliff1ID, "New England Inland Grass");
		rmAddAreaToClass(bigCliff1ID, rmClassID("classCliff"));		// Attempt to keep cliffs away from each other.
		rmSetAreaCliffEdge(bigCliff1ID, 1, 1.0, 0.1, 1.0, 0);  // DAL NOTE: Number of edges, second is size of each edge, third is variance
		rmSetAreaCliffPainting(bigCliff1ID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(bigCliff1ID, 6, 1.0, 1.0);
		rmSetAreaHeightBlend(bigCliff1ID, 1.0);
		rmAddAreaTerrainLayer(bigCliff1ID, "new_england\ground4_ne", 0, 2);
		rmAddAreaConstraint(bigCliff1ID, avoidImportantItem);
		rmAddAreaConstraint(bigCliff1ID, avoidTradeRoute);
		rmSetAreaMinBlobs(bigCliff1ID, 3);
		rmSetAreaMaxBlobs(bigCliff1ID, 5);
		rmSetAreaMinBlobDistance(bigCliff1ID, 8.0);
		rmSetAreaMaxBlobDistance(bigCliff1ID, 10.0);
		rmSetAreaSmoothDistance(bigCliff1ID, 20);
		rmSetAreaCoherence(bigCliff1ID, 0.7);
		rmSetAreaLocation(bigCliff1ID, 0.38, 0.65);
		rmAddAreaInfluenceSegment(bigCliff1ID, 0.4, 0.50, 0.34, 0.66);
		rmBuildArea(bigCliff1ID);

      	numLakeTrees = rmRandInt(9,11);
     		for (j=0; <numLakeTrees)
         	   rmPlaceObjectDefInArea(lakeTreeID, 0, rmAreaID("big cliff 1"), rmRandInt(2,3));


		int bigCliff2ID=rmCreateArea("big cliff 2");
		if ( cNumberNonGaiaPlayers < 4 )
			rmSetAreaSize(bigCliff2ID, rmAreaTilesToFraction(400), rmAreaTilesToFraction(400));
		else if ( cNumberNonGaiaPlayers < 6 )
			rmSetAreaSize(bigCliff2ID, rmAreaTilesToFraction(500), rmAreaTilesToFraction(500));
		else
			rmSetAreaSize(bigCliff2ID, rmAreaTilesToFraction(700), rmAreaTilesToFraction(700));
		rmSetAreaWarnFailure(bigCliff2ID, false);
		rmSetAreaCliffType(bigCliff2ID, "New England Inland Grass");
		rmAddAreaToClass(bigCliff2ID, rmClassID("classCliff"));		// Attempt to keep cliffs away from each other.
		rmSetAreaCliffEdge(bigCliff2ID, 1, 1.0, 0.1, 1.0, 0);
		rmSetAreaCliffPainting(bigCliff2ID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(bigCliff2ID, 6, 1.0, 1.0);
		rmSetAreaHeightBlend(bigCliff2ID, 1.0);
		rmAddAreaTerrainLayer(bigCliff2ID, "new_england\ground4_ne", 0, 2);
		rmAddAreaConstraint(bigCliff2ID, avoidImportantItem);
		rmAddAreaConstraint(bigCliff2ID, avoidTradeRoute);
		rmSetAreaMinBlobs(bigCliff2ID, 3);
		rmSetAreaMaxBlobs(bigCliff2ID, 5);
		rmSetAreaMinBlobDistance(bigCliff2ID, 8.0);
		rmSetAreaMaxBlobDistance(bigCliff2ID, 10.0);
		rmSetAreaSmoothDistance(bigCliff2ID, 20);
		rmSetAreaCoherence(bigCliff2ID, 0.7);
		rmSetAreaLocation(bigCliff2ID, 0.62, 0.65);
		rmAddAreaInfluenceSegment(bigCliff2ID, 0.6, 0.50, 0.66, 0.66);
		rmBuildArea(bigCliff2ID);

      	numLakeTrees = rmRandInt(10,13);
     		for (j=0; <numLakeTrees)
         	   rmPlaceObjectDefInArea(lakeTreeID, 0, rmAreaID("big cliff 2"), rmRandInt(2,3));

	}


   // Isles of Shoals - these are set in specific locations.
   int bonusIslandID1=rmCreateArea("isle of shoals 1");
   rmSetAreaSize(bonusIslandID1, rmAreaTilesToFraction(420), rmAreaTilesToFraction(420));
   rmSetAreaTerrainType(bonusIslandID1, "new_england\ground1_ne");
   rmSetAreaMix(bonusIslandID1, "newengland_grass");
	// rmSetAreaMix(bonusIslandID1, "newengland_rock");
   rmSetAreaBaseHeight(bonusIslandID1, 6.0);
   rmSetAreaSmoothDistance(bonusIslandID1, 5);
   rmSetAreaWarnFailure(bonusIslandID1, false);
	rmSetAreaMinBlobs(bonusIslandID1, 4);
   rmSetAreaMaxBlobs(bonusIslandID1, 5);
   rmSetAreaMinBlobDistance(bonusIslandID1, 8.0);
	rmSetAreaMaxBlobDistance(bonusIslandID1, 12.0);
   rmSetAreaCoherence(bonusIslandID1, 0.50);
   rmAddAreaConstraint(bonusIslandID1, bigContinentConstraint);

	// this may be the only island!  On a 2 or a 4.
	if ( whichVariation == 1 || whichVariation == 3 )
	{
		rmSetAreaLocation(bonusIslandID1, 0.40, 0.15);
	}
	else
		rmSetAreaLocation(bonusIslandID1, 0.50, 0.15);
   rmBuildArea(bonusIslandID1);

	// Only make the second island half the time.
	if ( whichVariation == 1 || whichVariation == 3 )
	{
		int bonusIslandID2=rmCreateArea("isle of shoals 2");
		rmSetAreaSize(bonusIslandID2, rmAreaTilesToFraction(420), rmAreaTilesToFraction(420));
		rmSetAreaTerrainType(bonusIslandID2, "new_england\ground1_ne");
		rmSetAreaMix(bonusIslandID2, "newengland_grass");
		// rmSetAreaMix(bonusIslandID2, "newengland_rock");
		rmSetAreaBaseHeight(bonusIslandID2, 6.0);
		rmSetAreaSmoothDistance(bonusIslandID2, 5);
		rmSetAreaWarnFailure(bonusIslandID2, false);
		rmSetAreaMinBlobs(bonusIslandID2, 4);
		rmSetAreaMaxBlobs(bonusIslandID2, 5);
		rmSetAreaMinBlobDistance(bonusIslandID2, 8.0);
		rmSetAreaMaxBlobDistance(bonusIslandID2, 12.0);
		rmSetAreaCoherence(bonusIslandID2, 0.50);
		rmAddAreaConstraint(bonusIslandID2, bigContinentConstraint);
		rmSetAreaLocation(bonusIslandID2, 0.60, 0.15);
		rmBuildArea(bonusIslandID2);
	}


	int avoidBonusIsland1 = rmCreateAreaDistanceConstraint("avoid bonus island 1", bonusIslandID1, 2.0);
	int avoidBonusIsland2 = rmCreateAreaDistanceConstraint("avoid bonus island 2", bonusIslandID2, 2.0);

   // NATIVE AMERICANS
   // Text
   rmSetStatusText("",0.50);

   float NativeVillageLoc = rmRandFloat(0,1);

   // Huron are always on the mainland
   int huronVillageAID = -1;
   int huronVillageType = rmRandInt(1,3);
   if ( whichNative > 1 )
   {
		huronVillageAID = rmCreateGrouping("huron village A", "native huron village "+huronVillageType);
   }
   else
   {
	   	huronVillageAID = rmCreateGrouping("cherokee village A", "native cherokee village "+huronVillageType);
   }
   rmSetGroupingMinDistance(huronVillageAID, 0.0);
   rmSetGroupingMaxDistance(huronVillageAID, rmXFractionToMeters(0.05));
   rmAddGroupingConstraint(huronVillageAID, avoidImpassableLand);
   rmAddGroupingToClass(huronVillageAID, rmClassID("importantItem"));
   rmAddGroupingConstraint(huronVillageAID, avoidTradeRoute);

	if ( vpLocation < 3 )
	{
		rmPlaceGroupingAtLoc(huronVillageAID, 0, 0.35, 0.8); // used to be 0.3 DAL
	}
	else if ( vpLocation == 3 )
	{
		rmPlaceGroupingAtLoc(huronVillageAID, 0, 0.2, 0.6);
	}
	else
	{
		rmPlaceGroupingAtLoc(huronVillageAID, 0, 0.8, 0.6);
	}

	int huronVillageBID = -1;
	huronVillageType = rmRandInt(1,3);
	if ( whichNative > 1 )
	{
		huronVillageBID = rmCreateGrouping("huron village B", "native huron village "+huronVillageType);
	}
	else
	{
		huronVillageBID = rmCreateGrouping("cherokee village B", "native cherokee village "+huronVillageType);
	}
	rmSetGroupingMinDistance(huronVillageBID, 0.0);
	rmSetGroupingMaxDistance(huronVillageBID, rmXFractionToMeters(0.05));
	rmAddGroupingConstraint(huronVillageBID, avoidImpassableLand);
	rmAddGroupingToClass(huronVillageBID, rmClassID("importantItem"));
	rmAddGroupingConstraint(huronVillageBID, avoidTradeRoute);

	if ( vpLocation == 1 )
	{
		rmPlaceGroupingAtLoc(huronVillageBID, 0, 0.65, 0.8); // used to be 0.7 DAL
	}
	else if ( vpLocation == 2 )
	{
		rmPlaceGroupingAtLoc(huronVillageBID, 0, 0.8, 0.6);
	}
	else if ( vpLocation == 3 )
	{
		rmPlaceGroupingAtLoc(huronVillageBID, 0, 0.7, 0.8);
	}
	else
	{
		rmPlaceGroupingAtLoc(huronVillageBID, 0, 0.2, 0.6);
	}

	// The Cree get placed on one of the islands.  Ahistorical, perhaps, but fun!
	/* DAL - CREE TAKEN OUT
   int creeVillageID = -1;
   int creeVillageType = rmRandInt(1,3);
   creeVillageID = rmCreateGrouping("cree village", "native cree village "+creeVillageType);
   rmSetGroupingMinDistance(creeVillageID, 0.0);
   rmSetGroupingMaxDistance(creeVillageID, rmXFractionToMeters(0.05));
   rmAddGroupingConstraint(creeVillageID, avoidImpassableLand);
   rmAddGroupingToClass(creeVillageID, rmClassID("importantItem"));
	if ( vpLocation < 3 )
	{
		// Only gets placed if island #2 actually exists.
		if ( whichVariation == 1 || whichVariation == 3 )
		{
			rmPlaceGroupingInArea(creeVillageID, 0, bonusIslandID2);
		}
	}
	else
	{
		rmPlaceGroupingInArea(creeVillageID, 0, bonusIslandID1);
	}
	*/

   // Starting Unit placement
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 10.0);
	rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(startingUnits, avoidAll);

	int startingTCID= rmCreateObjectDef("startingTC");
	if ( rmGetNomadStart())
	{
		rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
	}
	rmAddObjectDefToClass(startingTCID, rmClassID("startingUnit"));

	int silverType = -1;
	int playerGoldID = -1;

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeNewEngland", 1, 0.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 10.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 15.0);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);

	int StartBerryBushID=rmCreateObjectDef("starting BerryBush");
	rmAddObjectDefItem(StartBerryBushID, "BerryBush", 3, 5.0);
	rmSetObjectDefMinDistance(StartBerryBushID, 12.0);
	rmSetObjectDefMaxDistance(StartBerryBushID, 14.0);
	rmAddObjectDefConstraint(StartBerryBushID, avoidStartingUnitsSmall);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
	rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
    rmSetObjectDefMinDistance(playerNuggetID, 30.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 35.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(playerNuggetID, avoidPlayerNugget);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
	// rmAddObjectDefConstraint(playerNuggetID, avoidImportantItem);

   int startSilver2ID = rmCreateObjectDef("player second silver");
   rmAddObjectDefItem(startSilver2ID, "mine", 1, 0);
   rmSetObjectDefMinDistance(startSilver2ID, 36.0);
   rmSetObjectDefMaxDistance(startSilver2ID, 40.0);
   rmAddObjectDefConstraint(startSilver2ID, avoidAll);
   rmAddObjectDefConstraint(startSilver2ID, avoidImpassableLand);
   rmAddObjectDefConstraint(startSilver2ID, avoidWater30);
   rmAddObjectDefConstraint(startSilver2ID, avoidTownCenterMed);
   rmAddObjectDefConstraint(startSilver2ID, mediumAvoidSilver);
   rmAddObjectDefConstraint(startSilver2ID, avoidTradeRoute);
   rmAddObjectDefConstraint(startSilver2ID, avoidCliffs);

   int playerDeerID=rmCreateObjectDef("player deer");
   rmAddObjectDefItem(playerDeerID, "deer", rmRandInt(8,8), 7.0);
   rmSetObjectDefMinDistance(playerDeerID, 14);
   rmSetObjectDefMaxDistance(playerDeerID, 18);
   rmAddObjectDefConstraint(playerDeerID, avoidAll);
   rmAddObjectDefConstraint(playerDeerID, avoidStartingUnitsSmall);
   rmSetObjectDefCreateHerd(playerDeerID, false);

   int farDeerID=rmCreateObjectDef("second deer herd");
   rmAddObjectDefItem(farDeerID, "deer", rmRandInt(8,8), 7.0);
   rmSetObjectDefMinDistance(farDeerID, 30);
   rmSetObjectDefMaxDistance(farDeerID, 35);
   rmAddObjectDefConstraint(farDeerID, avoidDeerShort);
   rmAddObjectDefConstraint(farDeerID, avoidAll);
//   rmAddObjectDefConstraint(farDeerID, avoidTownCenter40);
   rmAddObjectDefConstraint(farDeerID, avoidImpassableLand);
   rmAddObjectDefConstraint(farDeerID, avoidWater15);
   rmAddObjectDefConstraint(farDeerID, avoidCliff);
   rmSetObjectDefCreateHerd(farDeerID, true);

   int fartherDeerID=rmCreateObjectDef("third deer herd");
   rmAddObjectDefItem(fartherDeerID, "deer", rmRandInt(8,8), 7.0);
// rmAddObjectDefItem(fartherDeerID, "cow", 0, 3.0);   // ========================================== test
   rmSetObjectDefMinDistance(fartherDeerID, 50);
   rmSetObjectDefMaxDistance(fartherDeerID, 55);
   rmAddObjectDefConstraint(fartherDeerID, avoidDeerShort);
   rmAddObjectDefConstraint(fartherDeerID, avoidAll);
//   rmAddObjectDefConstraint(fartherDeerID, avoidTownCenter50);
   rmAddObjectDefConstraint(fartherDeerID, avoidImpassableLand);
   rmAddObjectDefConstraint(fartherDeerID, avoidWater15);
   rmAddObjectDefConstraint(fartherDeerID, avoidCliff);
   rmSetObjectDefCreateHerd(fartherDeerID, true);

	int waterFlagID=-1;

	for(i=1; <cNumberPlayers)
	{
		rmClearClosestPointConstraints();
		// Place starting units and a TC!
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Everyone gets one ore grouping close by.
		silverType = rmRandInt(1,10);
		playerGoldID = rmCreateObjectDef("player silver closer "+i);
		rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
		// rmAddGroupingToClass(playerGoldID, rmClassID("importantItem"));
		rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
		rmSetObjectDefMinDistance(playerGoldID, 15.0);
		rmSetObjectDefMaxDistance(playerGoldID, 18.0);
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Placing starting food...
		rmPlaceObjectDefAtLoc(StartBerryBushID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(farDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(fartherDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Placing starting trees...
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Nuggets
		rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

	//	rmPlaceObjectDefAtLoc(startSilver2ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

    		if(ypIsAsian(i) && rmGetNomadStart() == false)
      		rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Water flag
		waterFlagID=rmCreateObjectDef("HC water flag "+i);
		rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 0.0);
		rmAddClosestPointConstraint(flagEdgeConstraint);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand);
		vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
        	vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));

		rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
		rmClearClosestPointConstraints();

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}

	// Text
   rmSetStatusText("",0.60);

	// A few smallish cliffs on the northwest side (inland)
	/* DAL Temp - take these suckers out, now that there are some lakes
	int numTries=cNumberNonGaiaPlayers;
	int failCount=0;
	for(i=0; <numTries)
	{
		int cliffID=rmCreateArea("cliff "+i);
	   rmSetAreaSize(cliffID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(100));
		rmSetAreaWarnFailure(cliffID, false);
		rmSetAreaCliffType(cliffID, "New England Inland Grass");
		rmAddAreaToClass(cliffID, rmClassID("classCliff"));	// Attempt to keep cliffs away from each other.

		// rmSetAreaCliffEdge(cliffID, 1, 0.6, 0.1, 1.0, 0);
		rmSetAreaCliffEdge(cliffID, 1, 1);
		rmSetAreaCliffPainting(cliffID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(cliffID, 4, 1.0, 1.0);
		rmSetAreaHeightBlend(cliffID, 1.0);
		rmAddAreaTerrainLayer(cliffID, "new_england\ground4_ne", 0, 2);

		rmAddAreaConstraint(cliffID, avoidCliffs);				// Avoid other cliffs, please!
		rmAddAreaConstraint(cliffID, avoidImportantItem);
		rmAddAreaConstraint(cliffID, avoidTradeRoute);
		rmAddAreaConstraint(cliffID, avoidWater20);
		rmAddAreaConstraint(cliffID, Northwestward);				// Cliff are on the northwest side of the map.
		rmSetAreaSmoothDistance(cliffID, 10);
		rmSetAreaCoherence(cliffID, 0.25);

		if(rmBuildArea(cliffID)==false)
		{
			// Stop trying once we fail 3 times in a row
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}
	*/


   // fish
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 20.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
   int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "minkeWhale", 30.0);


   /*
   int playerFishID=rmCreateObjectDef("player fish");
   rmAddObjectDefItem(playerFishID, "FishCod", 1, 10.0);
   rmSetObjectDefMinDistance(playerFishID, 0.0);
   rmSetObjectDefMaxDistance(playerFishID, 20.0);
   rmAddObjectDefConstraint(playerFishID, fishVsFishID);
   rmAddObjectDefConstraint(playerFishID, fishLand);
   */

   // rmPlaceObjectDefPerPlayer(playerFishID, false);

   // FAST COIN -- WHALES
   for (i=1; < 2*cNumberNonGaiaPlayers+1)
   {
		int whaleID=rmCreateObjectDef("whale"+i);
	   rmAddObjectDefItem(whaleID, "minkeWhale", 1, 5.0);
	   rmSetObjectDefMinDistance(whaleID, 0.0);
	   rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
	   rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
	   rmAddObjectDefConstraint(whaleID, whaleLand);
	   if(i%2 == 0)
			rmAddObjectDefConstraint(whaleID, Northeastward);
		else
			rmAddObjectDefConstraint(whaleID, Southwestward);
	   rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5);
   }

   int fishID=rmCreateObjectDef("fish");
   rmAddObjectDefItem(fishID, "FishCod", 2, 5.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.0, cNumberNonGaiaPlayers*5);



// Fixed forest
   int forest=-1;

   // NE forest clump
      forest=rmCreateArea("north east forest clump");
      rmAddAreaToClass(forest, rmClassID("classForest"));
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(180), rmAreaTilesToFraction(220));
      rmSetAreaForestType(forest, "new england forest");
      rmSetAreaForestDensity(forest, 0.80);
      rmSetAreaForestClumpiness(forest, 0.9);
      rmSetAreaForestUnderbrush(forest, 0.0);
      rmSetAreaCoherence(forest, 0.6);
      rmSetAreaSmoothDistance(forest, 10);
      rmAddAreaConstraint(forest, avoidAll);
	rmSetAreaLocation(forest, 0.935, 0.44);
	rmBuildArea(forest);

   // SW forest clump
      forest=rmCreateArea("south west forest clump");
      rmAddAreaToClass(forest, rmClassID("classForest"));
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(200));
      rmSetAreaForestType(forest, "new england forest");
      rmSetAreaForestDensity(forest, 0.80);
      rmSetAreaForestClumpiness(forest, 0.9);
      rmSetAreaForestUnderbrush(forest, 0.0);
      rmSetAreaCoherence(forest, 0.6);
      rmSetAreaSmoothDistance(forest, 10);
      rmAddAreaConstraint(forest, avoidAll);
	rmSetAreaLocation(forest, 0.065, 0.44);
	rmBuildArea(forest);

   // Text
   rmSetStatusText("",0.65);

   // Place resources that we want forests to avoid
   
   // Fixed mines
   int fixedsilverID = -1;
	fixedsilverID = rmCreateObjectDef("silver east "+i);
	rmAddObjectDefItem(fixedsilverID, "mine", 1, 0.0);
	rmPlaceObjectDefAtLoc(fixedsilverID, 0, 0.05, 0.62);
	rmPlaceObjectDefAtLoc(fixedsilverID, 0, 0.95, 0.62);
   
   
	// Fast Coin
	int silverID = -1;
	int silverWestID = -1;
	int silverCount = 1*cNumberNonGaiaPlayers;	// 3 per player in each half of map, plus starting 1.
	rmEchoInfo("silver count = "+silverCount);

	for(i=0; < silverCount)
	{
		silverType = rmRandInt(1,10);
		silverID = rmCreateObjectDef("silver east "+i);
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverID, minePlayerConstraint);
		rmAddObjectDefConstraint(silverID, avoidCoin);
		rmAddObjectDefConstraint(silverID, avoidAll);
		rmAddObjectDefConstraint(silverID, Eastward);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverID, avoidSocket);
		rmAddObjectDefConstraint(silverID, avoidStartingUnits);
		// Keep silver away from the water, to avoid the art problem with the "cliffs."
		rmAddObjectDefConstraint(silverID, avoidWater40);
		rmAddObjectDefConstraint(silverID, avoidCliffs);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.75, 0.60);
   }

	for(i=0; < silverCount)
	{
		silverType = rmRandInt(1,10);
		silverWestID = rmCreateObjectDef("silver west "+i);
		rmAddObjectDefItem(silverWestID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverWestID, 0.0);
		rmSetObjectDefMaxDistance(silverWestID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverWestID, minePlayerConstraint);
		rmAddObjectDefConstraint(silverWestID, avoidCoin);
		rmAddObjectDefConstraint(silverWestID, avoidAll);
		rmAddObjectDefConstraint(silverWestID, Westward);
		rmAddObjectDefConstraint(silverWestID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverWestID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverWestID, avoidSocket);
		rmAddObjectDefConstraint(silverWestID, avoidStartingUnits);
		// Keep silver away from the water, to avoid the art problem with the "cliffs."
		rmAddObjectDefConstraint(silverWestID, avoidWater40);
		rmAddObjectDefConstraint(silverWestID, avoidCliffs);
		rmPlaceObjectDefAtLoc(silverWestID, 0, 0.25, 0.60);
   }

	// silver mine on islands
	silverType = rmRandInt(1,10);
	int islandSilverID = rmCreateObjectDef("silver on island");
	rmAddObjectDefItem(islandSilverID, "mine", 1, 0.0);
	rmSetObjectDefMinDistance(islandSilverID, 0.0);
	rmSetObjectDefMaxDistance(islandSilverID, 10.0);
	rmAddObjectDefConstraint(islandSilverID, avoidImpassableLand);
	rmPlaceObjectDefInArea(islandSilverID, 0, bonusIslandID1, 1);
	if ( whichVariation == 1 )
	{
		rmPlaceObjectDefInArea(islandSilverID, 0, bonusIslandID2, 1);
	}

	// trees on islands
	int islandNativeID= rmCreateObjectDef("island trees");
	rmAddObjectDefConstraint(islandNativeID, avoidWater5);
	rmAddObjectDefItem(islandNativeID, "TreeNewEngland", 1, 0.0);
	rmAddObjectDefConstraint(islandNativeID, avoidAll);
	rmPlaceObjectDefInArea(islandNativeID, 0, bonusIslandID1, rmRandInt(3,5));
	if ( whichVariation == 1 )
	{
		rmPlaceObjectDefInArea(islandNativeID, 0, bonusIslandID2, rmRandInt(4,6) );
	}

	// FORESTS
   int numTries=5*cNumberNonGaiaPlayers;
   if (cNumberNonGaiaPlayers == 2)
      numTries=4*cNumberNonGaiaPlayers;
   if (cNumberNonGaiaPlayers == 3)
      numTries=4*cNumberNonGaiaPlayers;
   int failCount=0;

   // east forest
   for (i=0; < 2+numTries)
   {
      forest=rmCreateArea("east forest "+i);
      rmAddAreaToClass(forest, rmClassID("classForest"));
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(250));
      rmSetAreaForestType(forest, "new england forest");
      rmSetAreaForestDensity(forest, 0.80);
      rmSetAreaForestClumpiness(forest, 0.9);
      rmSetAreaForestUnderbrush(forest, 0.0);
      rmSetAreaCoherence(forest, 0.6);
      rmSetAreaSmoothDistance(forest, 10);
      rmAddAreaConstraint(forest, forestConstraint);
	  rmAddAreaConstraint(forest, avoidCoinMin);
      rmAddAreaConstraint(forest, avoidAll);
      rmAddAreaConstraint(forest, avoidImpassableLand);
      rmAddAreaConstraint(forest, avoidTradeRoute);
	rmAddAreaConstraint(forest, avoidStartingUnits);
	rmAddAreaConstraint(forest, avoidSocket);
	rmAddAreaConstraint(forest, avoidCliff);
	rmAddAreaConstraint(forest, Eastward);

      if(rmBuildArea(forest)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==6)
            break;
      }
      else
         failCount=0;
   }

   // west forest
   for (i=0; <numTries)
   {
      forest=rmCreateArea("west forest "+i);
      rmAddAreaToClass(forest, rmClassID("classForest"));
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(250));
      rmSetAreaForestType(forest, "new england forest");
      rmSetAreaForestDensity(forest, 0.80);
      rmSetAreaForestClumpiness(forest, 0.9);
      rmSetAreaForestUnderbrush(forest, 0.0);
      rmSetAreaCoherence(forest, 0.6);
      rmSetAreaSmoothDistance(forest, 10);
      rmAddAreaConstraint(forest, forestConstraint);
	  rmAddAreaConstraint(forest, avoidCoinMin);
      rmAddAreaConstraint(forest, avoidAll);
      rmAddAreaConstraint(forest, avoidImpassableLand);
      rmAddAreaConstraint(forest, avoidTradeRoute);
	  rmAddAreaConstraint(forest, avoidStartingUnits);
		rmAddAreaConstraint(forest, avoidSocket);
	rmAddAreaConstraint(forest, avoidCliff);
	rmAddAreaConstraint(forest, Westward);

      if(rmBuildArea(forest)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==6)
            break;
      }
      else
         failCount=0;
   }

   // Text
   rmSetStatusText("",0.70);

 	// DEER
	int bonusChance=rmRandFloat(0, 1);
   int deerCID=rmCreateObjectDef("central deer herds");
   rmAddObjectDefItem(deerCID, "deer", rmRandInt(6,8), 5.0);
   rmSetObjectDefMinDistance(deerCID, 0.0);
   rmSetObjectDefMaxDistance(deerCID, 17.0);
   rmAddObjectDefConstraint(deerCID, avoidDeer);
   rmAddObjectDefConstraint(deerCID, avoidAll);
   rmAddObjectDefConstraint(deerCID, avoidSocket);
   rmAddObjectDefConstraint(deerCID, avoidTradeRoute);
   rmAddObjectDefConstraint(deerCID, avoidImpassableLand);
   rmAddObjectDefConstraint(deerCID, avoidCliff);
   rmAddObjectDefConstraint(deerCID, avoidStartingUnits);
   rmAddObjectDefConstraint(deerCID, longPlayerConstraint);
   rmSetObjectDefCreateHerd(deerCID, true);
   rmPlaceObjectDefAtLoc(deerCID, 0, 0.5, 0.65);
   rmPlaceObjectDefAtLoc(deerCID, 0, 0.5, 0.92);

   int deerID=rmCreateObjectDef("east deer herd");
	if(bonusChance<0.5)
      rmAddObjectDefItem(deerID, "deer", rmRandInt(6,8), 5.0);
   else
      rmAddObjectDefItem(deerID, "deer", rmRandInt(7,9), 6.0);

   rmSetObjectDefMinDistance(deerID, 0.0);
   rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(deerID, Eastward);
   rmAddObjectDefConstraint(deerID, avoidDeer);
	rmAddObjectDefConstraint(deerID, avoidAll);
	rmAddObjectDefConstraint(deerID, avoidSocket);
	rmAddObjectDefConstraint(deerID, avoidTradeRoute);
   rmAddObjectDefConstraint(deerID, avoidImpassableLand);
   rmAddObjectDefConstraint(deerID, avoidCliff);
      rmAddObjectDefConstraint(deerID, avoidStartingUnits);
   rmAddObjectDefConstraint(deerID, longPlayerConstraint);
	rmSetObjectDefCreateHerd(deerID, true);
	rmPlaceObjectDefInArea(deerID, 0, bigContinentID, cNumberNonGaiaPlayers*5);

   int deerWID=rmCreateObjectDef("west deer herd");
   if(bonusChance<0.5)
      rmAddObjectDefItem(deerWID, "deer", rmRandInt(6,8), 5.0);
   else
      rmAddObjectDefItem(deerWID, "deer", rmRandInt(7,9), 6.0);

   rmSetObjectDefMinDistance(deerWID, 0.0);
   rmSetObjectDefMaxDistance(deerWID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(deerWID, Westward);
   rmAddObjectDefConstraint(deerWID, avoidDeer);
   rmAddObjectDefConstraint(deerWID, avoidAll);
   rmAddObjectDefConstraint(deerWID, avoidSocket);
   rmAddObjectDefConstraint(deerWID, avoidTradeRoute);
   rmAddObjectDefConstraint(deerWID, avoidImpassableLand);
   rmAddObjectDefConstraint(deerWID, avoidCliff);
   rmAddObjectDefConstraint(deerWID, avoidStartingUnits);
   rmAddObjectDefConstraint(deerWID, longPlayerConstraint);
   rmSetObjectDefCreateHerd(deerWID, true);
   rmPlaceObjectDefInArea(deerWID, 0, bigContinentID, cNumberNonGaiaPlayers);

	// Text
   rmSetStatusText("",0.80);

	for(i=1; < cNumberNonGaiaPlayers*2+1)
	{
		int sheepID=rmCreateObjectDef("sheep"+i);
		rmAddObjectDefItem(sheepID, "sheep", 2, 4.0);
		rmSetObjectDefMinDistance(sheepID, 0.0);
		rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(sheepID, avoidSheep);
		rmAddObjectDefConstraint(sheepID, avoidCoinMin);
		rmAddObjectDefConstraint(sheepID, avoidAll);
		rmAddObjectDefConstraint(sheepID, avoidSocket);
		rmAddObjectDefConstraint(sheepID, avoidTradeRoute);
		rmAddObjectDefConstraint(sheepID, avoidTownCenter40);
//		rmAddObjectDefConstraint(sheepID, avoidCliffs);
		rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
		rmAddObjectDefConstraint(sheepID, avoidWater20);
//		rmAddObjectDefConstraint(sheepID, avoidBonusIsland2);
		if(i%2 == 0)
			rmAddObjectDefConstraint(sheepID, Northeastward);
		else
			rmAddObjectDefConstraint(sheepID, Southwestward);
		rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5);
	}


   // Text
   rmSetStatusText("",0.9);

  // check for KOTH game mode
  if(rmGetIsKOTH()) {

    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.9;
    float walk = 0.05;

    if(randLoc == 1 || cNumberTeams > 2)
      yLoc = .3;

    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }

// Clearing trees
   int randomTreeNum = 3;
   if (cNumberNonGaiaPlayers > 5)
	randomTreeNum = 4;
   int treePattern = rmRandInt(1,4);
   int StragglerTreeID = -1;

for (i=0; <randomTreeNum)
{
   StragglerTreeID=rmCreateObjectDef("stragglers"+i);
   if  (treePattern == 1)
 	rmAddObjectDefItem(StragglerTreeID, "TreeNewEngland", 1, 0.0);
   else if (treePattern == 2)
      rmAddObjectDefItem(StragglerTreeID, "TreeNewEngland", 2, 2.0);
   else if (treePattern == 3)
      rmAddObjectDefItem(StragglerTreeID, "TreeNewEngland", 1, 1.0);
   else
      rmAddObjectDefItem(StragglerTreeID, "TreeNewEngland", 2, 4.0);
   rmAddObjectDefConstraint(StragglerTreeID, avoidAll);
   rmAddObjectDefConstraint(StragglerTreeID, avoidStartingUnits);
   rmAddObjectDefConstraint(StragglerTreeID, avoidTree);
   rmAddObjectDefConstraint(StragglerTreeID, avoidCliff);

//   rmPlaceObjectDefInArea(StragglerTreeID, 0, northClearArea, 1);

//   rmPlaceObjectDefInArea(StragglerTreeID, 0, eastClearArea, 1);

//   rmPlaceObjectDefInArea(StragglerTreeID, 0, southClearArea, 1);

//   rmPlaceObjectDefInArea(StragglerTreeID, 0, westClearArea, 1);

   // add few trees between lakes
   rmSetObjectDefMinDistance(StragglerTreeID, 0.0);
   rmSetObjectDefMaxDistance(StragglerTreeID, 35.0);
//   rmPlaceObjectDefAtLoc(StragglerTreeID, 0, 0.5, 0.6, 1);

   treePattern = rmRandInt(1,4);
}


   // Define and place Nuggets

	int nuggetID= rmCreateObjectDef("nugget");
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID, shortAvoidImpassableLand);
  	rmAddObjectDefConstraint(nuggetID, avoidNugget);
	rmAddObjectDefConstraint(nuggetID, avoidStartingUnits);
	rmAddObjectDefConstraint(nuggetID, avoidCoinMin);
  	rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetID, avoidSocket);
  	rmAddObjectDefConstraint(nuggetID, avoidAll);
  	rmAddObjectDefConstraint(nuggetID, avoidWater20);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenter40);
  	rmAddObjectDefConstraint(nuggetID, avoidWater20);
	rmAddObjectDefConstraint(nuggetID, avoidCliff);
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmSetNuggetDifficulty(2, 3);
	rmPlaceObjectDefInArea(nuggetID, 0, bigContinentID, cNumberNonGaiaPlayers*5);

	// Alternate nugget definition for island nuggets - no constraints (practically)
	/*
	int nuggetID2= rmCreateObjectDef("nugget 2");
	rmAddObjectDefItem(nuggetID2, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID2, 0.0);
	rmSetObjectDefMaxDistance(nuggetID2, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID2, shortAvoidImpassableLand);

	// Extra nuggets on the non-native island.
	if ( vpLocation < 3 )
	{
		rmPlaceObjectDefInArea(nuggetID2, 0, bonusIslandID1, 4);
	}
	else
	{
		if ( whichVariation == 1 || whichVariation == 3 )
		{
			rmPlaceObjectDefInArea(nuggetID2, 0, bonusIslandID2, 4);
		}
	}
	*/

	// Placement of crates on the bonus islands.
	// DAL - "nuggets" for now instead
	int whichCrate=-1;
	whichCrate = rmRandInt(1,3);

	int islandCrateID= rmCreateObjectDef("island crates");
	rmSetNuggetDifficulty(4, 4);
	rmAddObjectDefConstraint(islandCrateID, avoidWater5);
	rmAddObjectDefConstraint(islandCrateID, avoidCliff);
	rmAddObjectDefConstraint(islandCrateID, avoidNuggetSmall);
	if ( whichCrate == 1 )
	{
		rmAddObjectDefItem(islandCrateID, "Nugget", 1, 0.0);
	}
	else if ( whichCrate == 2 )
	{
		rmAddObjectDefItem(islandCrateID, "Nugget", 1, 0.0);
	}
	else
   		rmAddObjectDefItem(islandCrateID, "Nugget", 1, 0.0);


	rmPlaceObjectDefInArea(islandCrateID, 0, bonusIslandID1, 1);
	if ( whichVariation == 1 )
	{
		rmPlaceObjectDefInArea(islandCrateID, 0, bonusIslandID2, 1);
	}


	// Silly Rock Walls can get placed last.  May not place at all...
	int stoneWallType = -1;
	int stoneWallID = -1;
	int stoneWallCount = cNumberNonGaiaPlayers*2;
	rmEchoInfo("stoneWall count = "+stoneWallCount);

	for(i=0; < stoneWallCount)
	{
		stoneWallType = rmRandInt(1,4);
      stoneWallID = rmCreateGrouping("stone wall "+i, "ne_rockwall "+stoneWallType);
		rmAddGroupingToClass(stoneWallID, rmClassID("classWall"));
      rmSetGroupingMinDistance(stoneWallID, 0.0);
      rmSetGroupingMaxDistance(stoneWallID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(stoneWallID, avoidFastCoin);
		rmAddGroupingConstraint(stoneWallID, avoidImpassableLand);
		rmAddGroupingConstraint(stoneWallID, avoidTradeRoute);
		rmAddGroupingConstraint(stoneWallID, avoidSocket);
		rmAddGroupingConstraint(stoneWallID, wallConstraint);
		rmAddGroupingConstraint(stoneWallID, avoidWater20);
		rmAddGroupingConstraint(stoneWallID, avoidCliffs);
		rmAddGroupingConstraint(stoneWallID, avoidStartingUnitsLong);
		rmPlaceGroupingAtLoc(stoneWallID, 0, 0.5, 0.5);
   }


  // Water nuggets

  int avoidNuggetLand=rmCreateTerrainDistanceConstraint("nugget avoid land", "land", true, 15.0);
  int avoidNuggetWater=rmCreateTypeDistanceConstraint("nugget vs. nugget water", "AbstractNugget", 80.0);
  
  int nuggetW= rmCreateObjectDef("nugget water"); 
  rmAddObjectDefItem(nuggetW, "ypNuggetBoat", 1, 0.0);
  rmSetNuggetDifficulty(5, 5);
  rmSetObjectDefMinDistance(nuggetW, rmXFractionToMeters(0.0));
  rmSetObjectDefMaxDistance(nuggetW, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nuggetW, avoidNuggetLand);
  rmAddObjectDefConstraint(nuggetW, avoidNuggetWater);
  rmPlaceObjectDefAtLoc(nuggetW, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4);


   // Text
   rmSetStatusText("",0.99);

}