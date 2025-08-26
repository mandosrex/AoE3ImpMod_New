// CALIFORNIA
// JANUARY 2006
// Revised by RF_Gandalf for the AS Fan Patch
// Completely reworked by Neuron & iCourt 2013


include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{

	if (rmIsSpecialEventVariant()) {
		activateAprilFoolsTextures();
	}

   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);


   //Chooses which natives appear on the map
   int subCiv0=-1;
   int subCiv1=-1;

   if (rmAllocateSubCivs(2) == true)
   {

	  if(rmRandFloat(0,1) < 0.65)

	  {
		  subCiv0=rmGetCivID("Klamath");
      rmEchoInfo("subCiv0 is Klamath "+subCiv0);
	  if (subCiv0 >= 0)
		 rmSetSubCiv(0, "Klamath");
	  }
      else
	  {
		subCiv0=rmGetCivID("Nootka");
      rmEchoInfo("subCiv0 is Nootka "+subCiv0);
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Nootka");
	  }
	  
	  if (rmRandFloat(0,1) < 0.65)
	  {
		subCiv1=rmGetCivID("Nootka");
      rmEchoInfo("subCiv1 is Nootka "+subCiv1);
      if (subCiv1 >= 0)
         rmSetSubCiv(1, "Nootka");
      }
	  else
	  {
		  subCiv1=rmGetCivID("Klamath");
      rmEchoInfo("subCiv1 is Klamath "+subCiv1);
	  if (subCiv1 >= 0)
		 rmSetSubCiv(1, "Klamath");
	  }
   }

	// Picks the map size
	int playerTiles=15000;
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=14000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=13000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=12000;

	size=2*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	// Some map turbulence...
	rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);  // 
	rmSetMapElevationHeightBlend(0.2);

	// Picks a default water height
	rmSetSeaLevel(2.0);

	// Picks default terrain and water
	rmSetSeaType("california coast");
	rmEnableLocalWater(false);
	rmTerrainInitialize("water");
	rmSetMapType("california");
	rmSetMapType("water");
	rmSetWorldCircleConstraint(true);
	rmSetWindMagnitude(2.0);
	rmSetMapType("grass");
	rmSetMapType("desert");
	rmSetMapType("namerica");
	rmSetMapType("AIFishingUseful");
	rmSetLightingSet("california");

	chooseMercs();

	// Define some classes. These are used later for constraints.
	int classPlayer=rmDefineClass("player");
	rmDefineClass("classCliff");
	rmDefineClass("classPatch");
	int classbigContinent=rmDefineClass("big continent");
	rmDefineClass("corner");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	rmDefineClass("classForest");
	rmDefineClass("natives");
	rmDefineClass("importantItem");
	rmDefineClass("secrets");
	rmDefineClass("flag");
	rmDefineClass("classHillArea");
	int randomClass = rmDefineClass("randomAreaClass");

	// Player placement
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
  	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 10.0);

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
	// Map edge constraintsw
	//int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(28), rmZTilesToFraction(28), 1.0-rmXTilesToFraction(28), 1.0-rmZTilesToFraction(28), 0.01);
	int playerEdgeConstraint=rmCreatePieConstraint("player edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.40), rmDegreesToRadians(0), rmDegreesToRadians(360));
	
	int randomAreaConstraint=rmCreateClassDistanceConstraint("continent avoids random areas", randomClass, 20.0);

	// Player constraints
	int playerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 30.0);
	int playerForestConstraint=rmCreateClassDistanceConstraint("forest vs. player", rmClassID("classForest"), 20.0);

	int NorthConstraint = rmCreatePieConstraint("stay in upper part", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.49), rmDegreesToRadians(310), rmDegreesToRadians(130));

	int SouthConstraint = rmCreatePieConstraint("stay in lower part", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.49), rmDegreesToRadians(130), rmDegreesToRadians(310));

	int Eastconstraint = rmCreateBoxConstraint("stay in Far East portion", 0, .7, 1, 0);
	int EastForestconstraint = rmCreateBoxConstraint("stay in East portion", 0.4, 0.0, 0.8, 1.0);
	int WestForestconstraint = rmCreateBoxConstraint("stay in Far West portion", 0, 1, 0.60, 0);
	int Centralconstraint = rmCreateBoxConstraint("stay in Central portion", 0.45, 0.75, 0.55, 0.25);
	int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);
	int flagConstraint=rmCreateHCGPConstraint("flags avoid same", 20.0);
	int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-180, rmGetMapXSize()-40, 0, 0, 0);
	int nearWater10 = rmCreateTerrainDistanceConstraint("near water", "Water", true, 10.0);
	int shipVsShip=rmCreateTypeDistanceConstraint("ships avoid ship", "ship", 5.0);

	// Bonus area constraint
	int bigContinentConstraint=rmCreateClassDistanceConstraint("avoid bonus island", classbigContinent, 20.0);

	// Resource avoidance
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 20.0);
	int cliffConstraint=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 35.0);
	int avoidCliff=rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 10.0);
	int shortAvoidCliff=rmCreateClassDistanceConstraint("short stuff vs. cliff", rmClassID("classCliff"), 8.0);
	int avoidDeer=rmCreateTypeDistanceConstraint("food avoids food", "deer", 50.0);
	int avoidDeerShort=rmCreateTypeDistanceConstraint("food avoids food short", "deer", 25.0);
	int avoidElk=rmCreateTypeDistanceConstraint("elk avoids elk", "elk", 40.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 45.0);
	int avoidCoinShort=rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 22.0);
	int avoidCoinFar=rmCreateTypeDistanceConstraint("coin avoids coin Far", "gold", 75.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 40.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 30.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint("resources avoid Town Center", "townCenter", 35.0);
	int avoidTownCenterMed=rmCreateTypeDistanceConstraint("resources avoid Town Center farther", "townCenter", 45.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 60.0);
	int avoidHomeCityWaterSpawnFlag=rmCreateTypeDistanceConstraint("avoid HomeCityWaterSpawnFlag", "HomeCityWaterSpawnFlag", 20.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 15);
	int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 8.0);
	int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
    int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);
	int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "HumpbackWhale", 30.0);
	int whaleLand = rmCreateTerrainDistanceConstraint("whale land", "land", true, 18.0);
	int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 55.0);

	// Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 10.0);
	int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 25.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int mediumAvoidImpassableLand=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 15.0);
	int mediumShortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("mediumshort avoid impassable land", "Land", false, 10.0);
	int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 20.0);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 15.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.9);

   // VP avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 12.0);
   int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 5.0);
   int nativeAvoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 20.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 10.0);
   // Text
rmSetStatusText("",0.10);


// DEFINE AREAS

// Set up player starting locations 

if(cNumberTeams == 2)
{
float teamStartLoc = rmRandFloat(0.0, 1.0);

	if (teamStartLoc > 0.5) 				// Team 0 up north, team 1 down south
	{
		if(cNumberNonGaiaPlayers >= 5) 
		{ 
			rmSetPlacementTeam(0);
			rmSetPlacementSection(0.05, 0.23);
			rmPlacePlayersCircular(0.37, 0.37, 0);

			rmSetPlacementTeam(1);
			rmSetPlacementSection(0.52, 0.7);
			rmPlacePlayersCircular(0.37, 0.37, 0);

			rmSetTeamSpacingModifier(0.3);
		} 

		else if (cNumberNonGaiaPlayers >= 3) 
		{ 
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(.675, .8, .8, .6, .0, .15); 
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(.2, .325, .40, .20, .0, .15); 
			rmSetTeamSpacingModifier(0.3); 
		}

		else if (cNumberNonGaiaPlayers == 2) 
		{ 
			rmPlacePlayer(1, .73, .73);
			rmPlacePlayer(2, .27, .27); 
		}
	}
	else								// The reverse (0 south, 1 north)
	{
		if(cNumberNonGaiaPlayers >= 5) 
		{ 
			rmSetPlacementTeam(0);
			rmSetPlacementSection(0.52, 0.7);
			rmPlacePlayersCircular(0.37, 0.37, 0);

			rmSetPlacementTeam(1);
			rmSetPlacementSection(0.05, 0.23);
			rmPlacePlayersCircular(0.37, 0.37, 0);

			rmSetTeamSpacingModifier(0.3);
		}

		else if (cNumberNonGaiaPlayers >= 3) 
		{ 
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(.2, .325, .40, .20, .0, .15);
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(.675, .8, .8, .6, .0, .15);
			rmSetTeamSpacingModifier(0.3); 
		}

		else if (cNumberNonGaiaPlayers == 2) 
		{
			rmPlacePlayer(1, .27, .27);
			rmPlacePlayer(2, .73, .73); 
		}
	}
}

else									// FFA 
		rmSetPlacementSection(0.05, 0.7);
		rmSetTeamSpacingModifier(0.6);
		rmPlacePlayersCircular(0.37, 0.37, 0);


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
		rmAddAreaConstraint(id, playerConstraint); 
		rmAddAreaConstraint(id, playerEdgeConstraint); //this is for land only
		rmSetAreaLocPlayer(id, i);
		rmSetAreaTerrainType(id, "california\ground5_cal");
		rmSetAreaWarnFailure(id, false);
	}

// Build the areas.
rmBuildAllAreas();

// Text
rmSetStatusText("",0.20);

// Build up big continent - called, unoriginally enough, "big continent"
   int bigContinentID=rmCreateArea("big continent");
   rmSetAreaSize(bigContinentID, 0.55, 0.55);		// 0.65, 0.65
   rmSetAreaWarnFailure(bigContinentID, false);
   rmAddAreaToClass(bigContinentID, classbigContinent);
   rmSetAreaSmoothDistance(bigContinentID, 50);
	rmSetAreaMix(bigContinentID, "california_grass");
   rmSetAreaElevationType(bigContinentID, cElevTurbulence);
   rmSetAreaElevationVariation(bigContinentID, 4.0);
   rmSetAreaBaseHeight(bigContinentID, 4.0);
   rmSetAreaElevationMinFrequency(bigContinentID, 0.09);
   rmSetAreaElevationOctaves(bigContinentID, 3);
   rmSetAreaElevationPersistence(bigContinentID, 0.2);      
	rmSetAreaCoherence(bigContinentID, 0.80);
	rmSetAreaLocation(bigContinentID, 0.57, 0.43);
   rmSetAreaEdgeFilling(bigContinentID, 0);
	rmSetAreaObeyWorldCircleConstraint(bigContinentID, false);
	rmBuildArea(bigContinentID);

	rmSetStatusText("",0.30);

// Two correction land areas -- to fill up the north and south parts of the continent

   int smallContinent1ID=rmCreateArea("small continent spur 1");
   rmSetAreaSize(smallContinent1ID, 0.2, 0.2);
   rmSetAreaWarnFailure(smallContinent1ID, false);
   rmAddAreaToClass(smallContinent1ID, classbigContinent);
   rmSetAreaSmoothDistance(smallContinent1ID, 50);
	rmSetAreaMix(smallContinent1ID, "california_grass");
   rmSetAreaElevationType(smallContinent1ID, cElevTurbulence);
   rmSetAreaElevationVariation(smallContinent1ID, 4.0);
   rmSetAreaBaseHeight(smallContinent1ID, 4.0);
   rmSetAreaElevationMinFrequency(smallContinent1ID, 0.09);
   rmSetAreaElevationOctaves(smallContinent1ID, 3);
   rmSetAreaElevationPersistence(smallContinent1ID, 0.2);      
	rmSetAreaCoherence(smallContinent1ID, 0.80);
	rmSetAreaLocation(smallContinent1ID, 0.75, 0.75);
// rmSetAreaEdgeFilling(smallContinent1ID, 0);		                                 // Keep one commented
   rmSetAreaObeyWorldCircleConstraint(smallContinent1ID, false);
	rmBuildArea(smallContinent1ID);
   int smallContinent2ID=rmCreateArea("small continent spur 2");
   rmSetAreaSize(smallContinent2ID, 0.2, 0.2);
   rmSetAreaWarnFailure(smallContinent2ID, false);
   rmAddAreaToClass(smallContinent2ID, classbigContinent);
   rmSetAreaSmoothDistance(smallContinent2ID, 50);
	rmSetAreaMix(smallContinent2ID, "california_grass");
   rmSetAreaElevationType(smallContinent2ID, cElevTurbulence);
   rmSetAreaElevationVariation(smallContinent2ID, 4.0);
   rmSetAreaBaseHeight(smallContinent2ID, 4.0);
   rmSetAreaElevationMinFrequency(smallContinent2ID, 0.09);
   rmSetAreaElevationOctaves(smallContinent2ID, 3);
   rmSetAreaElevationPersistence(smallContinent2ID, 0.2);      
	rmSetAreaCoherence(smallContinent2ID, 0.80);
	rmSetAreaLocation(smallContinent2ID, 0.25, 0.25);
   rmSetAreaEdgeFilling(smallContinent2ID, 5);		                                 // Keep one on, so we still get the continuous edge filling along the coastline
   rmSetAreaObeyWorldCircleConstraint(smallContinent2ID, false);
	rmBuildArea(smallContinent2ID);

// Hilly areas
int hillCentralID=rmCreateArea("central hills");
int avoidCentral = rmCreateAreaDistanceConstraint("avoid central", hillCentralID, 3.0);
int CentralHillConstraint = rmCreateAreaConstraint("Central Hill Constraint", hillCentralID);

	rmSetAreaSize(hillCentralID, 0.2, 0.2);
	rmSetAreaWarnFailure(hillCentralID, false);
	rmSetAreaSmoothDistance(hillCentralID, 30);
	rmSetAreaMix(hillCentralID, "california_grassrocks");
	rmSetAreaElevationType(hillCentralID, cElevTurbulence);
	rmSetAreaElevationVariation(hillCentralID, 2.0);
	rmSetAreaBaseHeight(hillCentralID, 4);
	rmSetAreaElevationMinFrequency(hillCentralID, 0.05);
	rmSetAreaElevationOctaves(hillCentralID, 3);
	rmSetAreaElevationPersistence(hillCentralID, 0.3);      
	rmSetAreaElevationNoiseBias(hillCentralID, 0.5);
	rmSetAreaElevationEdgeFalloffDist(hillCentralID, 0.0);
	rmSetAreaCoherence(hillCentralID, 0.7);
	rmSetAreaLocation(hillCentralID, 0.5, 0.5);
	rmAddAreaInfluenceSegment(hillCentralID, 0.275, 0.0, 0.9, .725);
	rmSetAreaHeightBlend(hillCentralID, 1);
	rmSetAreaEdgeFilling(hillCentralID, 1);	
	rmSetAreaObeyWorldCircleConstraint(hillCentralID, false);
	rmAddAreaToClass(hillCentralID, rmClassID("classHillArea"));
	rmBuildArea(hillCentralID);

int hillEastID=rmCreateArea("East hills");
int avoidE = rmCreateAreaDistanceConstraint("avoid e", hillEastID, 5.0);
int EastHillConstraint = rmCreateAreaConstraint("East Hill Constraint", hillEastID);
int avoidEastHillShort = rmCreateAreaDistanceConstraint("avoid east hill short", hillEastID, 1.0);

	rmSetAreaSize(hillEastID, 0.20, 0.20);
	rmSetAreaWarnFailure(hillEastID, false);
	rmSetAreaSmoothDistance(hillEastID, 20);
	rmSetAreaMix(hillEastID, "california_desert0");
	rmAddAreaTerrainLayer(hillEastID, "california\desert5_cal", 0, 4);
	rmAddAreaTerrainLayer(hillEastID, "california\desert4_cal", 4, 8);
	rmAddAreaTerrainLayer(hillEastID, "california\desert3_cal", 8, 12);
	rmSetAreaElevationType(hillEastID, cElevTurbulence);
	rmSetAreaElevationVariation(hillEastID, 4.0);
	rmSetAreaBaseHeight(hillEastID, 4.0);
	rmSetAreaElevationMinFrequency(hillEastID, 0.05);
	rmSetAreaElevationOctaves(hillEastID, 3);
	rmSetAreaElevationPersistence(hillEastID, 0.3);      
	rmSetAreaElevationNoiseBias(hillEastID, 0.5);
	rmSetAreaElevationEdgeFalloffDist(hillEastID, 25.0); 
	rmSetAreaCoherence(hillEastID, 0.5);
	rmSetAreaLocation(hillEastID, 0.75, 0.25);
	rmSetAreaEdgeFilling(hillEastID, 10);
	rmAddAreaInfluenceSegment(hillEastID, 0.5, 0.0, 1.0, 0.5);
	rmSetAreaHeightBlend(hillEastID, 1);
	rmSetAreaObeyWorldCircleConstraint(hillEastID, false);
	rmAddAreaToClass(hillEastID, rmClassID("classHillArea"));
	rmBuildArea(hillEastID);


// Placement order
// Trade route -> River (none on this map) -> Natives -> Secrets -> Cliffs -> Nuggets

rmSetStatusText("",0.40);

// TRADE ROUTES
	int tradeRouteID = rmCreateTradeRoute();
	int socketID=rmCreateObjectDef("sockets for Trade Route");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmAddObjectDefConstraint(socketID, avoidImpassableLand);
	rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 10.0);
	
	if(cNumberNonGaiaPlayers >= 5)                                                                      
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 1.0, .550);
		rmAddTradeRouteWaypoint(tradeRouteID, .450, 0.0);
	}

	else
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 1.0, .625);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.9, 0.4, 2.0, 0.0);
		rmAddTradeRouteWaypoint(tradeRouteID, .7, .3);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.6, 0.1, 2.0, 0.0);
		rmAddTradeRouteWaypoint(tradeRouteID, .375, 0.0);
	}
	
	bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
	if(placedTradeRoute == false) 
	rmEchoError("Failed to place trade route"); 

	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.40);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.65);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.90);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

rmClearClosestPointConstraints();


// PLAYER STARTING RESOURCES


	int TCID = rmCreateObjectDef("player TC");
	if (rmGetNomadStart())
	{
		rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
	rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);
	}
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 5.0);
	
//	rmAddObjectDefConstraint(TCID, avoidTradeRoute);
//	rmAddObjectDefConstraint(TCID, nativeAvoidTradeRouteSocket);
//	if (rmGetNumberPlayersOnTeam(0) == rmGetNumberPlayersOnTeam(1))
//		rmAddObjectDefConstraint(TCID, avoidTownCenterFar);
//	else
//		rmAddObjectDefConstraint(TCID, avoidTownCenter);
//	rmAddObjectDefConstraint(TCID, playerEdgeConstraint);
//	rmAddObjectDefConstraint(TCID, longAvoidImpassableLand);


// WATER HC ARRIVAL POINT

   int waterFlagID = 0;
   for(i=1; <cNumberPlayers)
    {
        waterFlagID=rmCreateObjectDef("HC water flag "+i);
        rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 20.0);
		rmAddClosestPointConstraint(flagEdgeConstraint);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand);
	}  

	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "minegold", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 10.0);
	rmSetObjectDefMaxDistance(playergoldID, 15.0);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergoldID, avoidCliff);
	rmAddObjectDefConstraint(playergoldID, avoidAll);
      rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);

	int playergold2ID = rmCreateObjectDef("player secondmine");
	rmAddObjectDefItem(playergold2ID, "minegold", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 35.0);
	rmSetObjectDefMaxDistance(playergold2ID, 40.0);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergold2ID, avoidCliff);
	rmAddObjectDefConstraint(playergold2ID, avoidAll);
	rmAddObjectDefConstraint(playergold2ID, avoidCoinShort);
      rmAddObjectDefConstraint(playergold2ID, avoidImpassableLand);
      rmAddObjectDefConstraint(playergold2ID, avoidTownCenterResources);

	int playerDeerID=rmCreateObjectDef("player deer");
      rmAddObjectDefItem(playerDeerID, "Deer", rmRandInt(7,7), 8.0);
      rmSetObjectDefMinDistance(playerDeerID, 10);
      rmSetObjectDefMaxDistance(playerDeerID, 16);
	rmAddObjectDefConstraint(playerDeerID, avoidAll);
	rmAddObjectDefConstraint(playerDeerID, avoidCliff);
      rmAddObjectDefConstraint(playerDeerID, avoidImpassableLand);
	rmSetObjectDefCreateHerd(playerDeerID, false);

	int playerElkID=rmCreateObjectDef("player elk");
      rmAddObjectDefItem(playerElkID, "elk", rmRandInt(9,9), 8.0);
      rmSetObjectDefMinDistance(playerElkID, 36);
      rmSetObjectDefMaxDistance(playerElkID, 42);
	rmAddObjectDefConstraint(playerElkID, avoidAll);
	rmAddObjectDefConstraint(playerElkID, avoidDeerShort);
	rmAddObjectDefConstraint(playerElkID, avoidCliff);
      rmAddObjectDefConstraint(playerElkID, avoidImpassableLand);
	rmSetObjectDefCreateHerd(playerElkID, true);
      rmAddObjectDefConstraint(playerElkID, avoidTownCenterResources);

	int playerTreeID=rmCreateObjectDef("player trees");
    rmAddObjectDefItem(playerTreeID, "TreeMadrone", rmRandInt(5,7), 8.0);
    rmSetObjectDefMinDistance(playerTreeID, 20);
    rmSetObjectDefMaxDistance(playerTreeID, 22);
//	rmAddObjectDefConstraint(playerTreeID, avoidAll);
//	rmAddObjectDefConstraint(playerTreeID, avoidCliff);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);

	int playerNuggetID= rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmAddObjectDefConstraint(playerNuggetID, longAvoidImpassableLand);
  	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
  	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
  	rmAddObjectDefConstraint(playerNuggetID, avoidAll);
	rmAddObjectDefConstraint(playerNuggetID, avoidCliff);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 30.0);

	for(i=1; <cNumberPlayers)
   {
	rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

	rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(playergoldID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(playerDeerID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//	rmPlaceObjectDefAtLoc(playergold2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(playerElkID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
     
  if(ypIsAsian(i) && rmGetNomadStart() == false)
    rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

	vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
	rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

   }
   rmClearClosestPointConstraints();   	


// NATIVE AMERICANS

rmSetStatusText("",0.50);
   
float NativeVillageLoc = rmRandFloat(0,1); //
     
	int nootkaVillageID = -1;
	int nootkaVillageType = rmRandInt(1,5);
	int KlamathVillageID = -1;
	int KlamathVillageType = rmRandInt(1,3);
	int Klamath1VillageID = -1;
	int Klamath1VillageType = rmRandInt(1,3);
	int nootka1VillageID = -1;
	int nootka1VillageType = rmRandInt(1,5);

	if(subCiv0 == rmGetCivID("Klamath"))
	{   
		KlamathVillageID = rmCreateGrouping("Klamath village", "native Klamath village "+KlamathVillageType);
		rmSetGroupingMinDistance(KlamathVillageID, 0.0);
		rmSetGroupingMaxDistance(KlamathVillageID, 0.0); 					// Was rmXFractionToMeters(0.2)
		rmAddGroupingToClass(KlamathVillageID, rmClassID("natives"));
//		rmAddGroupingConstraint(KlamathVillageID, longAvoidImpassableLand);
		rmAddGroupingToClass(KlamathVillageID, rmClassID("importantItem"));
//		rmAddGroupingConstraint(KlamathVillageID, avoidTradeRoute);
//		rmAddGroupingConstraint(KlamathVillageID, avoidNatives);
//		rmAddGroupingConstraint(KlamathVillageID, avoidTownCenter);
		rmPlaceGroupingAtLoc(KlamathVillageID, 0, 0.35, 0.65);
	}

	else if (subCiv0 == rmGetCivID("Nootka"))
	{
		nootkaVillageID = rmCreateGrouping("nootka village", "native nootka village "+nootkaVillageType);
		rmSetGroupingMinDistance(nootkaVillageID, 0.0);
		rmSetGroupingMaxDistance(nootkaVillageID, 0.0); // Was rmXFractionToMeters(0.2)
		rmAddGroupingToClass(nootkaVillageID, rmClassID("natives"));
//		rmAddGroupingConstraint(nootkaVillageID, longAvoidImpassableLand);
		rmAddGroupingToClass(nootkaVillageID, rmClassID("importantItem"));
//		rmAddGroupingConstraint(nootkaVillageID, avoidTradeRoute);
//		rmAddGroupingConstraint(nootkaVillageID, avoidNatives);
		rmAddGroupingConstraint(nootkaVillageID, avoidTownCenter);
		rmPlaceGroupingAtLoc(nootkaVillageID, 0, 0.35, 0.65);
	}

	if(subCiv1 == rmGetCivID("Klamath"))
	{
		int Klamath2VillageID = -1;
		int Klamath2VillageType = rmRandInt(4,5);
		Klamath2VillageID = rmCreateGrouping("Klamath2 village", "native Klamath village "+Klamath2VillageType);
		rmSetGroupingMinDistance(Klamath2VillageID, 0.0);
		rmSetGroupingMaxDistance(Klamath2VillageID, 0.0); // Was rmXFractionToMeters(0.2)
		rmAddGroupingToClass(Klamath2VillageID, rmClassID("natives"));
//		rmAddObjectDefConstraint(Klamath2VillageID, longAvoidImpassableLand);
//		rmAddGroupingConstraint(Klamath2VillageID, longAvoidImpassableLand);
//		rmAddGroupingConstraint(Klamath2VillageID, avoidTradeRoute);
		rmAddGroupingConstraint(Klamath2VillageID, avoidTownCenter);
//		rmAddGroupingConstraint(Klamath2VillageID, avoidNatives);
		rmPlaceGroupingAtLoc(Klamath2VillageID, 0, 0.80, 0.20);
	}
	else if (subCiv1 == rmGetCivID("Nootka"))
	{   
		int nootka2VillageID = -1;
		int nootka2VillageType = rmRandInt(1,5);
		nootka2VillageID = rmCreateGrouping("nootka2 village", "native nootka village "+nootka2VillageType);
		rmSetGroupingMinDistance(nootka2VillageID, 0.0);
		rmSetGroupingMaxDistance(nootka2VillageID, 0.0); // Was rmXFractionToMeters(0.2)
		rmAddGroupingToClass(nootka2VillageID, rmClassID("natives"));
//		rmAddGroupingConstraint(nootka2VillageID, avoidImpassableLand);
		rmAddGroupingToClass(nootka2VillageID, rmClassID("importantItem"));
//		rmAddGroupingConstraint(nootka2VillageID, avoidTradeRoute);
//		rmAddGroupingConstraint(nootka2VillageID, avoidTownCenter);
//		rmAddGroupingConstraint(nootka2VillageID, avoidNatives);
		rmPlaceGroupingAtLoc(nootka2VillageID, 0, 0.80, 0.20);
	}


// Define and place Cliffs
   
int numTries=cNumberNonGaiaPlayers+2;

   for(i=0; <numTries)
   {
      int cliffID=rmCreateArea("cliff"+i);
	  rmSetAreaSize(cliffID, rmAreaTilesToFraction(350), rmAreaTilesToFraction(600));
      rmSetAreaWarnFailure(cliffID, false);
	  rmSetAreaCliffType(cliffID, "California");
	  rmSetAreaCliffEdge(cliffID, 1, 0.6, 0.8, 1.0, 0);
      rmSetAreaCliffPainting(cliffID, false, true, true, 1.5, true);
      rmSetAreaCliffHeight(cliffID, 5, 2.0, 0.5);
      rmSetAreaHeightBlend(cliffID, 1);
      rmAddAreaToClass(cliffID, rmClassID("classCliff")); 
      rmAddAreaConstraint(cliffID, longAvoidImpassableLand);
      rmAddAreaConstraint(cliffID, cliffConstraint);
	  rmAddAreaConstraint(cliffID, avoidTownCenterFar);
//	  rmAddAreaConstraint(cliffID, avoidTownCenterMed);
      rmAddAreaConstraint(cliffID, avoidImportantItem);
      rmAddAreaConstraint(cliffID, avoidTradeRoute);
	  rmAddAreaConstraint(cliffID, CentralHillConstraint);
  	  rmAddAreaConstraint(cliffID, avoidEastHillShort);
	  rmAddAreaConstraint(cliffID, avoidCoin);
      rmSetAreaMinBlobs(cliffID, 4);
      rmSetAreaMaxBlobs(cliffID, 6);
      rmSetAreaMinBlobDistance(cliffID, 16.0);
      rmSetAreaMaxBlobDistance(cliffID, 25.0);
      rmSetAreaSmoothDistance(cliffID, 10);
      rmSetAreaCoherence(cliffID, 0.9);
      rmBuildArea(cliffID);
   } 


   // Text
	rmSetStatusText("",0.60);
    
  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.0;
    float yLoc = 0.5;
    float walk = 0.055;
    
    if(randLoc == 1)
      xLoc = .35;
    
    else
      xLoc = .65;
      
    if(cNumberTeams > 2) {
      xLoc = .35;
      walk = 0.1;
    }
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }


// Place resources that we want forests to avoid

// Gold mines

 
	int goldType = -1;
	int goldCount = (cNumberNonGaiaPlayers + rmRandInt(1,2));
	rmEchoInfo("gold count = "+goldCount);

	for(i=0; < goldCount)
	{
	  int goldID = rmCreateObjectDef("gold North "+i);
	  rmAddObjectDefItem(goldID, "mine", 1, 0.0);
        rmSetObjectDefMinDistance(goldID, 0.0);
        rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.4));
	  rmAddObjectDefConstraint(goldID, avoidCoin);
        rmAddObjectDefConstraint(goldID, avoidAll);
	  rmAddObjectDefConstraint(goldID, avoidCliff);
        rmAddObjectDefConstraint(goldID, avoidTownCenterFar);
	  rmAddObjectDefConstraint(goldID, avoidTradeRoute);
        rmAddObjectDefConstraint(goldID, mediumAvoidImpassableLand);
	  rmAddObjectDefConstraint(goldID, NorthConstraint);
//	  rmAddObjectDefConstraint(goldID, WestForestconstraint);  // ===============================================
	  rmPlaceObjectDefAtLoc(goldID, 0, 0.6, 0.75);
   }

	goldCount = (cNumberNonGaiaPlayers + rmRandInt(1,2));
	rmEchoInfo("gold2 count = "+goldCount);

	for(i=0; < goldCount)
	{
	  int goldEastID = rmCreateObjectDef("gold South "+i);
	  rmAddObjectDefItem(goldEastID, "mine", 1, 0.0);
        rmSetObjectDefMinDistance(goldEastID, 0.0);
        rmSetObjectDefMaxDistance(goldEastID, rmXFractionToMeters(0.4));
	  rmAddObjectDefConstraint(goldEastID, avoidCoin);
        rmAddObjectDefConstraint(goldEastID, avoidAll);
	  rmAddObjectDefConstraint(goldEastID, avoidCliff);
        rmAddObjectDefConstraint(goldEastID, avoidTownCenterFar);
	  rmAddObjectDefConstraint(goldEastID, avoidTradeRoute);
        rmAddObjectDefConstraint(goldEastID, mediumAvoidImpassableLand);
	  rmAddObjectDefConstraint(goldEastID, SouthConstraint);
//	  rmAddObjectDefConstraint(goldEastID, EastHillConstraint);
	  rmPlaceObjectDefAtLoc(goldEastID, 0, 0.6, 0.25);
	}

	if (cNumberNonGaiaPlayers > 4)
		goldCount = (2);
	else
		goldCount = (cNumberNonGaiaPlayers + 1);
	rmEchoInfo("gold3 count = "+goldCount);

	for(i=0; < goldCount)
	{
	  int goldRandomID = rmCreateObjectDef("gold Random "+i);
	  rmAddObjectDefItem(goldRandomID, "mine", 1, 0.0);
        rmSetObjectDefMinDistance(goldRandomID, 0.0);
        rmSetObjectDefMaxDistance(goldRandomID, rmXFractionToMeters(0.5));
	  rmAddObjectDefConstraint(goldRandomID, avoidCoinFar);
        rmAddObjectDefConstraint(goldRandomID, avoidAll);
	  rmAddObjectDefConstraint(goldRandomID, shortAvoidCliff);
        rmAddObjectDefConstraint(goldRandomID, avoidTownCenterFar);
	  rmAddObjectDefConstraint(goldRandomID, avoidTradeRoute);
        rmAddObjectDefConstraint(goldRandomID, mediumAvoidImpassableLand);
  	  rmPlaceObjectDefAtLoc(goldRandomID, 0, 0.5, 0.5); 
      }

   // Text
   rmSetStatusText("",0.70); 


   // FORESTS											
      
   int forestTreeID = 0;
   numTries=2.5*cNumberNonGaiaPlayers;
   int failCount=0;
   for (i=0; <numTries)
      {   
         int forestRedwood=rmCreateArea("forest redwood "+i, rmAreaID("big continent"));
         rmSetAreaWarnFailure(forestRedwood, false);
         rmSetAreaSize(forestRedwood, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
         rmSetAreaForestType(forestRedwood, "california redwood forest");
		   rmSetAreaForestDensity(forestRedwood, 0.45);
         rmSetAreaForestClumpiness(forestRedwood, 0.15);
         rmSetAreaForestUnderbrush(forestRedwood, 0.6);
         rmSetAreaMinBlobs(forestRedwood, 12);
         rmSetAreaMaxBlobs(forestRedwood, 22);
         rmSetAreaMinBlobDistance(forestRedwood, 10.0);
         rmSetAreaMaxBlobDistance(forestRedwood, 20.0);
         rmSetAreaCoherence(forestRedwood, 0.35);
         rmSetAreaSmoothDistance(forestRedwood, 10);
         rmAddAreaToClass(forestRedwood, rmClassID("classForest")); 
         rmAddAreaConstraint(forestRedwood, forestConstraint);
         rmAddAreaConstraint(forestRedwood, avoidAll);
         rmAddAreaConstraint(forestRedwood, avoidImpassableLand); 
         rmAddAreaConstraint(forestRedwood, avoidTradeRouteShort);
		   rmAddAreaConstraint(forestRedwood, WestForestconstraint);
         rmAddAreaConstraint(forestRedwood, avoidEastHillShort);
         rmAddAreaConstraint(forestRedwood, avoidTownCenter);
		 
         if(rmBuildArea(forestRedwood)==false)
         {
            failCount++;
            if(failCount==4)
               break;
         }
         else
            failCount=0; 
      }

	forestTreeID = 0;
	numTries=3*cNumberNonGaiaPlayers;
	failCount=0;
	for (i=0; <numTries)
      {   
         int forest=rmCreateArea("forest pine forest "+i, rmAreaID("big continent"));
         rmSetAreaWarnFailure(forest, false);
         rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
         rmSetAreaForestType(forest, "California pine forest");
		   rmSetAreaForestDensity(forest, 0.85);
         rmSetAreaForestClumpiness(forest, 0.10);
         rmSetAreaForestUnderbrush(forest, 0.6);
         rmSetAreaMinBlobs(forest, 8);
         rmSetAreaMaxBlobs(forest, 15);
         rmSetAreaMinBlobDistance(forest, 20.0);
         rmSetAreaMaxBlobDistance(forest, 40.0);
         rmSetAreaCoherence(forest, 0.25);
         rmSetAreaSmoothDistance(forest, 10);
         rmAddAreaToClass(forest, rmClassID("classForest")); 
         rmAddAreaConstraint(forest, playerForestConstraint);
         rmAddAreaConstraint(forest, forestConstraint);
         rmAddAreaConstraint(forest, avoidAll);
         rmAddAreaConstraint(forest, avoidImpassableLand); 
         rmAddAreaConstraint(forest, avoidTradeRouteShort);
   	   rmAddAreaConstraint(forest, CentralHillConstraint);
         rmAddAreaConstraint(forest, avoidEastHillShort);
         rmAddAreaConstraint(forest, avoidTownCenter);
         
         if(rmBuildArea(forest)==false)
         {
            failCount++;
            if(failCount==5)
               break;
         }
         else
            failCount=0; 
      } 


	forestTreeID = 0;
	numTries=2*cNumberNonGaiaPlayers;
	failCount=0;
	for (i=0; <numTries)
      {   
         int forestEast=rmCreateArea("forest desert "+i, rmAreaID("big continent"));
         rmSetAreaWarnFailure(forestEast, false);
         rmSetAreaSize(forestEast, rmAreaTilesToFraction(150), rmAreaTilesToFraction(400));
         rmSetAreaForestType(forestEast, "California Desert Forest");
		   rmSetAreaForestDensity(forestEast, 0.6);
         rmSetAreaForestClumpiness(forestEast, 0.1);
         rmSetAreaForestUnderbrush(forestEast, 0.6);
         rmSetAreaMinBlobs(forestEast, 10);
         rmSetAreaMaxBlobs(forestEast, 20);
         rmSetAreaMinBlobDistance(forestEast, 0.0);
         rmSetAreaMaxBlobDistance(forestEast, 25.0);
         rmSetAreaCoherence(forestEast, 0.6);
         rmSetAreaSmoothDistance(forestEast, 10);
         rmAddAreaToClass(forestEast, rmClassID("classForest")); 
         rmAddAreaConstraint(forestEast, playerForestConstraint);
         rmAddAreaConstraint(forestEast, avoidTownCenter);
         rmAddAreaConstraint(forestEast, avoidImportantItem);
         rmAddAreaConstraint(forestEast, forestConstraint);
       rmAddAreaConstraint(forestEast, avoidAll);
         rmAddAreaConstraint(forestEast, avoidCliff);
         rmAddAreaConstraint(forestEast, avoidImpassableLand); 
         rmAddAreaConstraint(forestEast, avoidTradeRoute);
		   rmAddAreaConstraint(forestEast, EastHillConstraint);
		   
		 
         if(rmBuildArea(forestEast)==false)
         {
            failCount++;
            if(failCount==6)
               break;
         }
         else
            failCount=0; 
      } 


    forestTreeID = 0;
	numTries=2*cNumberNonGaiaPlayers;
	failCount=0;
	for (i=0; <numTries)
      {   
         int forestMadrone=rmCreateArea("forest madrone "+i, rmAreaID("big continent"));
         rmSetAreaWarnFailure(forestMadrone, false);
         rmSetAreaSize(forestMadrone, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
         rmSetAreaForestType(forestMadrone, "california madrone forest");
		   rmSetAreaForestDensity(forestMadrone, 0.65);
         rmSetAreaForestClumpiness(forestMadrone, 0.15);
         rmSetAreaForestUnderbrush(forestMadrone, 0.6);
         rmSetAreaMinBlobs(forestMadrone, 10);
         rmSetAreaMaxBlobs(forestMadrone, 20);
         rmSetAreaMinBlobDistance(forestMadrone, 20.0);
         rmSetAreaMaxBlobDistance(forestMadrone, 30.0);
         rmSetAreaCoherence(forestMadrone, 0.35);
         rmSetAreaSmoothDistance(forestMadrone, 10);
         rmAddAreaToClass(forestMadrone, rmClassID("classForest")); 
         rmAddAreaConstraint(forestMadrone, playerForestConstraint);
         rmAddAreaConstraint(forestMadrone, forestConstraint);
         rmAddAreaConstraint(forestMadrone, avoidAll);
         rmAddAreaConstraint(forestMadrone, avoidCliff);
         rmAddAreaConstraint(forestMadrone, avoidImpassableLand); 
         rmAddAreaConstraint(forestMadrone, avoidTradeRouteShort);
		   rmAddAreaConstraint(forestMadrone, avoidEastHillShort);
         rmAddAreaConstraint(forestMadrone, avoidTownCenter);
         
         if(rmBuildArea(forestMadrone)==false)
         {
            failCount++;
            if(failCount==4)
               break;
         }
         else
            failCount=0; 
      }

 
  // Text
   rmSetStatusText("",0.80); 


   // Deer & Elk
	int deerID=rmCreateObjectDef("deer herd");
	rmAddObjectDefItem(deerID, "deer", rmRandInt(6,9), 10.0);
	rmSetObjectDefMinDistance(deerID, 0.0);
	rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(deerID, avoidDeer);
	rmAddObjectDefConstraint(deerID, avoidElk);
	rmAddObjectDefConstraint(deerID, avoidAll);
	rmAddObjectDefConstraint(deerID, avoidE);
	rmAddObjectDefConstraint(deerID, avoidCentral);
	rmAddObjectDefConstraint(deerID, avoidImpassableLand);
	rmAddObjectDefConstraint(deerID, avoidTownCenterMed);
	rmSetObjectDefCreateHerd(deerID, true);

	int elkID=rmCreateObjectDef("elk herd");
	rmAddObjectDefItem(elkID, "elk", rmRandInt(8,9), 13);
	rmSetObjectDefMinDistance(elkID, 0.0);
	rmSetObjectDefMaxDistance(elkID, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(elkID, avoidElk);
	rmAddObjectDefConstraint(elkID, avoidDeer);
	rmAddObjectDefConstraint(elkID, avoidAll);
//	rmAddObjectDefConstraint(elkID, Eastconstraint);
	rmAddObjectDefConstraint(elkID, avoidImpassableLand);
	rmAddObjectDefConstraint(elkID, avoidTownCenterMed);
	rmSetObjectDefCreateHerd(elkID, true);

	if (cNumberNonGaiaPlayers > 6)
	{
		rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, 1*cNumberNonGaiaPlayers);
		rmPlaceObjectDefAtLoc(elkID, 0, 0.5, 0.5, 1*cNumberNonGaiaPlayers);
	}
	else
	{
		rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);
		rmPlaceObjectDefAtLoc(elkID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);
	}

   // Define and place Nuggets
   
	int nuggetID= rmCreateObjectDef("nugget easy"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
  	rmAddObjectDefConstraint(nuggetID, avoidNugget);
  	rmAddObjectDefConstraint(nuggetID, avoidTownCenterMed);
  	rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
  	rmAddObjectDefConstraint(nuggetID, avoidAll);
  	rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	int nuggetmediumID= rmCreateObjectDef("nugget medium"); 
	rmAddObjectDefItem(nuggetmediumID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(2, 2);
	rmSetObjectDefMinDistance(nuggetmediumID, 0.0);
	rmSetObjectDefMaxDistance(nuggetmediumID, rmXFractionToMeters(0.5));
  	rmAddObjectDefConstraint(nuggetmediumID, avoidNugget);
  	rmAddObjectDefConstraint(nuggetmediumID, avoidTownCenterMed);
  	rmAddObjectDefConstraint(nuggetmediumID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(nuggetmediumID, avoidCliff);
  	rmAddObjectDefConstraint(nuggetmediumID, avoidAll);
  	rmAddObjectDefConstraint(nuggetmediumID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(nuggetmediumID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	int nuggethardID= rmCreateObjectDef("nugget hard"); 
	rmAddObjectDefItem(nuggethardID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(3, 3);
	rmSetObjectDefMinDistance(nuggethardID, 0.0);
	rmSetObjectDefMaxDistance(nuggethardID, rmXFractionToMeters(0.5));
  	rmAddObjectDefConstraint(nuggethardID, avoidNugget);
  	rmAddObjectDefConstraint(nuggethardID, avoidTownCenterFar);
  	rmAddObjectDefConstraint(nuggethardID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(nuggethardID, avoidCliff);
  	rmAddObjectDefConstraint(nuggethardID, avoidAll);
	rmAddObjectDefConstraint(nuggethardID, playerEdgeConstraint);
  	rmAddObjectDefConstraint(nuggethardID, longAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(nuggethardID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);


	if(rmRandFloat(0,1) < 0.25) //places more hard 25% of the time
	{
		int nuggethard2ID= rmCreateObjectDef("nugget more hard"); 
		rmAddObjectDefItem(nuggethard2ID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(3, 3);
		rmSetObjectDefMinDistance(nuggethard2ID, 0.0);
		rmSetObjectDefMaxDistance(nuggethard2ID, rmXFractionToMeters(0.5));
  		rmAddObjectDefConstraint(nuggethard2ID, avoidNugget);
  		rmAddObjectDefConstraint(nuggethard2ID, avoidTownCenterFar);
  		rmAddObjectDefConstraint(nuggethard2ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(nuggethard2ID, avoidCliff);
  		rmAddObjectDefConstraint(nuggethard2ID, avoidAll);
		rmAddObjectDefConstraint(nuggethard2ID, playerEdgeConstraint);
  		rmAddObjectDefConstraint(nuggethard2ID, longAvoidImpassableLand);
		rmPlaceObjectDefAtLoc(nuggethard2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);
	}


	//only try to place these 50% of the time
	
	   if(rmRandFloat(0,1) < 0.50)
	   {
		int nuggetnutsID= rmCreateObjectDef("nugget nuts"); 
		rmAddObjectDefItem(nuggetnutsID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(4, 4);
		rmSetObjectDefMinDistance(nuggetnutsID, 0.0);
		rmSetObjectDefMaxDistance(nuggetnutsID, rmXFractionToMeters(0.5));
  		rmAddObjectDefConstraint(nuggetnutsID, avoidNugget);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidTownCenterFar);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(nuggetnutsID, avoidCliff);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidAll);
		rmAddObjectDefConstraint(nuggetnutsID, playerEdgeConstraint);
  		rmAddObjectDefConstraint(nuggetnutsID, longAvoidImpassableLand);
		rmPlaceObjectDefAtLoc(nuggetnutsID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);
	   }


// Place whales & fish

		int whaleID=rmCreateObjectDef("whale");
		rmAddObjectDefItem(whaleID, "HumpbackWhale", 1, 0.0);
		rmSetObjectDefMinDistance(whaleID, 0.0);
		rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
		rmAddObjectDefConstraint(whaleID, whaleLand);
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

   int fishID=rmCreateObjectDef("fish");
   rmAddObjectDefItem(fishID, "FishSalmon", 3, 9.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);


// Random sheep

   	int avoidSheep=rmCreateTypeDistanceConstraint("sheep avoids sheep", "sheep", 60.0);

	   int randomSheep = rmCreateObjectDef("random sheep");
		rmAddObjectDefItem(randomSheep, "sheep", 2, 3.0);
		rmSetObjectDefMinDistance(randomSheep, rmXFractionToMeters(0.10));
		rmSetObjectDefMaxDistance(randomSheep, rmXFractionToMeters(0.33));
//		rmAddObjectDefConstraint(randomSheep, avoidAll);
//		rmAddObjectDefConstraint(randomSheep, avoidImpassableLand);
//		rmAddObjectDefConstraint(randomSheep, avoidCliff);
   	rmAddObjectDefConstraint(randomSheep, avoidSheep);
		rmPlaceObjectDefAtLoc(randomSheep, 0, 0.5, 0.5, 4);

   rmSetStatusText("",0.90);

   rmSetMapClusteringPlacementParams(0.7, 0.2, 0.9, cClusterLand);
   rmSetMapClusteringObjectParams(0, 2, 0.5);
// rmPlaceMapClusters("carolinas\grass2", "underbrushShrub");


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


   rmSetStatusText("",1.0);     
}