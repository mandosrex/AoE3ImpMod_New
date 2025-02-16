// NEW ANDES - river removed, player positions improved, resource balance improved, trade route position altered slightly
// edited by RF_Gandalf for the AS Fan-Patch

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{
   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

   //Chooses which natives appear on the map
   int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;
   int subCiv3=-1;
   
   // All Inca all the time
   if (rmAllocateSubCivs(4) == true)
   {
		subCiv0=rmGetCivID("Incas");
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Incas");

		subCiv1=rmGetCivID("Incas");
      if (subCiv1 >= 0)
         rmSetSubCiv(1, "Incas");

		subCiv2=rmGetCivID("Incas");
      if (subCiv2 >= 0)
         rmSetSubCiv(2, "Incas");

		subCiv3=rmGetCivID("Incas");
      if (subCiv3 >= 0)
         rmSetSubCiv(3, "Incas");
	}

   // Picks the map size
	int playerTiles=10500;
	if (cNumberNonGaiaPlayers<3)
		int size=2.2*sqrt(cNumberNonGaiaPlayers*playerTiles);
	else if (cNumberNonGaiaPlayers<7)
		size=2.1*sqrt(cNumberNonGaiaPlayers*playerTiles);
	else
		size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Picks a default water height
	rmSetSeaLevel(3.0);   // height of river surface compared to surrounding land. River depth is in the river XML.
	rmSetWindMagnitude(2);

	// Picks default terrain and water

	rmSetBaseTerrainMix("andes_grass_a");
      rmTerrainInitialize("andes\ground10_and", 4);
	rmSetMapType("andes");
	rmSetMapType("grass");
	rmSetMapType("mountain");
	rmSetMapType("samerica");
	rmSetMapType("land");
      rmSetLightingSet("sonora");

	// Make the corners.
	rmSetWorldCircleConstraint(true);

	// Choose Mercs
	chooseMercs();

   // Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classHill");
   rmDefineClass("classPatch");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
   rmDefineClass("classCliff");
   rmDefineClass("classMountain");
   rmDefineClass("classClearing"); 

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
	int coinEdgeConstraint=rmCreateBoxConstraint("coin edge of map", rmXTilesToFraction(7), rmZTilesToFraction(7), 1.0-rmXTilesToFraction(7), 1.0-rmZTilesToFraction(7), 0.01);
	int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(25), rmZTilesToFraction(25), 1.0-rmXTilesToFraction(25), 1.0-rmZTilesToFraction(25), 0.01);

   // Directional constraints
	int NWconstraint = rmCreateBoxConstraint("stay in NW portion", 0, 0.5, 1, 1);
	int SEconstraint = rmCreateBoxConstraint("stay in SE portion", 0, 0, 1, 0.5);
	int NEconstraint = rmCreateBoxConstraint("stay in NE portion", 0.65, 0.0, 1, 1);
	int extremeNEconstraint = rmCreateBoxConstraint("stay deep into NE portion", 0.6, 0.0, 1.0, 1.0);
   
   // Player constraints
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 20.0);
	int longPlayerConstraint=rmCreateClassDistanceConstraint("stay far away from players", classPlayer, 50.0);
	int longerPlayerConstraint=rmCreateClassDistanceConstraint("stay farther away from players", classPlayer, 65.0);
 
   // Nature avoidance
 	int shortForestConstraint=rmCreateClassDistanceConstraint("forest avoids forest", rmClassID("classForest"), 15.0);
	int avoidLlama=rmCreateTypeDistanceConstraint("llama avoids llama", "Llama", 60.0);
	int avoidGuanaco=rmCreateTypeDistanceConstraint("guanaco avoids guanaco", "Guanaco", 40.0);
	int avoidGuanacoShort=rmCreateTypeDistanceConstraint("guanaco avoids guanaco short", "Guanaco", 25.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 40.0);
	int avoidCoinShort=rmCreateTypeDistanceConstraint("avoid coin short", "Mine", 30.0);
	int avoidCoinFar=0;
	if (cNumberNonGaiaPlayers < 4)
   	   avoidCoinFar=rmCreateTypeDistanceConstraint("avoid coin far for less players", "Mine", 50.0);
	else
	   avoidCoinFar=rmCreateTypeDistanceConstraint("avoid coin far", "Mine", 60.0);
      int avoidClearing=rmCreateClassDistanceConstraint("avoid clearings", rmClassID("classClearing"), 10.0);  
   
   // Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int avoidCliff=rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 12.0);
	int avoidCliffFar=rmCreateClassDistanceConstraint("stuff vs. cliff far", rmClassID("classCliff"), 22.0);
	int cliffAvoidCliff=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);

   // Unit avoidance	
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 20.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("avoid Town Center Short", "townCenter", 17.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 42.0);
	int avoidTownCenterSupaFar=rmCreateTypeDistanceConstraint("avoid Town Center Supa Far", "townCenter", 80.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 60.0);
	int shortAvoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other by a bit", rmClassID("importantItem"), 10.0);
	int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 10.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 30.0);
	int avoidNuggetFar=rmCreateTypeDistanceConstraint("nugget avoid nugget far", "AbstractNugget", 45.0);
	int avoidTradeRouteSockets=rmCreateTypeDistanceConstraint("avoid Trade Socket", "sockettraderoute", 10);
	int avoidTradeRouteSocketsTC=rmCreateTypeDistanceConstraint("avoid Trade Socket from TC", "sockettraderoute", 25);
	int avoidIncaSocketsTC=rmCreateTypeDistanceConstraint("avoid Inca Socket from TC", "socketinca", 85);
	
   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 8.0);

   // Important object avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 15.0);
   int avoidTradeRouteTC = rmCreateTradeRouteDistanceConstraint("TC avoid trade route", 20.0);
   int avoidKOTH=rmCreateTypeDistanceConstraint("avoid KOTH", "ypKingsHill", 15.0);

   // -------------Define objects
   // These objects are all defined so they can be placed later

   rmSetStatusText("",0.10);
   int playerSide = rmRandInt(1,2);

   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 10.0);

   if (cNumberTeams > 2)   // ffa
   {
	if (cNumberNonGaiaPlayers < 4)
	   rmSetPlacementSection(0.57, 0.95);
	else if (cNumberNonGaiaPlayers < 7)
	   rmSetPlacementSection(0.55, 0.0);
	else 
	   rmSetPlacementSection(0.45, 0.05);

	if (cNumberNonGaiaPlayers < 4)
	   rmPlacePlayersCircular(0.385, 0.39, 0);
	else if (cNumberNonGaiaPlayers < 7)
	   rmPlacePlayersCircular(0.395, 0.405, 0);
	else
	   rmPlacePlayersCircular(0.41, 0.415, 0);
   }
   else if (cNumberNonGaiaPlayers == 2)
   {
      if (playerSide == 1)
	   rmSetPlacementTeam(0);
	else
	   rmSetPlacementTeam(1);	
	rmSetPlacementSection(0.97, 0.985);
	rmPlacePlayersCircular(0.39, 0.40, 0);

	if (playerSide == 1)
	   rmSetPlacementTeam(1);
	else
	   rmSetPlacementTeam(0);	
  	rmSetPlacementSection(0.525, 0.54);
	rmPlacePlayersCircular(0.39, 0.40, 0);
   }
   else if (cNumberNonGaiaPlayers < 5)  // under 5 players, 2 teams
   {
	if (playerSide == 1)
 	   rmSetPlacementTeam(0);
	else
	   rmSetPlacementTeam(1);
      rmSetPlacementSection(0.47, 0.58);
	rmPlacePlayersCircular(0.4, 0.405, 0);

	if (playerSide == 1)
	   rmSetPlacementTeam(1);
	else
	   rmSetPlacementTeam(0);
	rmSetPlacementSection(0.92, 0.03);
	rmPlacePlayersCircular(0.4, 0.405, 0);
   }
   else if (cNumberNonGaiaPlayers < 7)  // under 7 players, 2 teams
   {
	if (playerSide == 1)
 	   rmSetPlacementTeam(0);
	else
	   rmSetPlacementTeam(1);
      rmSetPlacementSection(0.46, 0.61);
	rmPlacePlayersCircular(0.4, 0.415, 0);

	if (playerSide == 1)
	   rmSetPlacementTeam(1);
	else
	   rmSetPlacementTeam(0);
	rmSetPlacementSection(0.89, 0.04);
	rmPlacePlayersCircular(0.41, 0.415, 0);
   }
   else // over 4 players, 2 teams
   {
	if (playerSide == 1)
	  rmSetPlacementTeam(0);
	else
	   rmSetPlacementTeam(1);
      rmSetPlacementSection(0.45, 0.68);
	rmPlacePlayersCircular(0.41, 0.415, 0);

	if (playerSide == 1)
	   rmSetPlacementTeam(1);
	else
	   rmSetPlacementTeam(0);
	rmSetPlacementSection(0.82, 0.05);
	rmPlacePlayersCircular(0.41, 0.415, 0);
   }

   // Build a north area
	int northIslandID = rmCreateArea("north island");
	rmSetAreaLocation(northIslandID, 0.5, 0.9); 
	rmSetAreaWarnFailure(northIslandID, false);
	rmSetAreaSize(northIslandID, 0.5, 0.5);
	rmSetAreaCoherence(northIslandID, 0.5);

	rmSetAreaElevationType(northIslandID, cElevTurbulence);
	rmSetAreaElevationVariation(northIslandID, 3.0);
	rmSetAreaBaseHeight(northIslandID, 4.0);
	rmSetAreaElevationMinFrequency(northIslandID, 0.07);
	rmSetAreaElevationOctaves(northIslandID, 4);
	rmSetAreaElevationPersistence(northIslandID, 0.5);
	rmSetAreaElevationNoiseBias(northIslandID, 1);
   
	rmSetAreaObeyWorldCircleConstraint(northIslandID, false);
	rmSetAreaMix(northIslandID, "andes_grass_b");


   // Text
   rmSetStatusText("",0.20);

   // Build a south area
   int southIslandID = rmCreateArea("south island");
   rmSetAreaLocation(southIslandID, 0.5, 0.1); 
   rmSetAreaWarnFailure(southIslandID, false);
   rmSetAreaSize(southIslandID, 0.5, 0.5);
   rmSetAreaCoherence(southIslandID, 0.5);

   rmSetAreaElevationType(southIslandID, cElevTurbulence);
   rmSetAreaElevationVariation(southIslandID, 5.0);
   rmSetAreaBaseHeight(southIslandID, 4.0);
   rmSetAreaElevationMinFrequency(southIslandID, 0.07);
   rmSetAreaElevationOctaves(southIslandID, 4);
   rmSetAreaElevationPersistence(southIslandID, 0.5);
   rmSetAreaElevationNoiseBias(southIslandID, 1); 
   rmAddAreaTerrainLayer(southIslandID, "andes\ground10_and", 0, 5);
   rmSetAreaObeyWorldCircleConstraint(southIslandID, false);
   rmSetAreaMix(southIslandID, "andes_grass_a");

   rmBuildAllAreas();

   // Text
   rmSetStatusText("",0.30);

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
      rmAddAreaConstraint(id, playerConstraint); 
      rmAddAreaConstraint(id, playerEdgeConstraint);
      rmSetAreaLocPlayer(id, i);
	rmSetAreaTerrainType(id, "carolina\marshflats");
      rmSetAreaWarnFailure(id, false);
   }

   // Build the areas.
   rmBuildAllAreas();
   
	// Text
	rmSetStatusText("",0.40);

	// TRADE ROUTES
   // Trade route setup
   int tradeRoutePos = rmRandInt(1,2);
   if (cNumberNonGaiaPlayers > 5)
	tradeRoutePos = 2;

   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 10.0);
	
   int tradeRoute1ID = rmCreateTradeRoute();

   if (tradeRoutePos == 1)  // Trade Route in a V shape
   {
	rmAddTradeRouteWaypoint(tradeRoute1ID, 0, 0.8);
	rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.55, 0.54, 5, 8);
      rmAddTradeRouteWaypoint(tradeRoute1ID, 0.55, 0.46);
	rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0, 0.2, 5, 8);
   }
   else  //Trade Route down the middle
   { 
	rmAddTradeRouteWaypoint(tradeRoute1ID, 0, 0.5);
	rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.5, 0.5, 8, 10);
	rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 1, 0.5, 8, 10);
   }


	bool placedTradeRoute1 = rmBuildTradeRoute(tradeRoute1ID, "dirt");
	if(placedTradeRoute1 == false)
		rmEchoError("Failed to place trade route one");

	// add the meeting sockets along the trade route.
      rmSetObjectDefTradeRouteID(socketID, tradeRoute1ID);
	vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, 0.13);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

	socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, 0.5);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

	socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, 0.87);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

	// Text
	rmSetStatusText("",0.45);

  // check for KOTH game mode
  if(rmGetIsKOTH())
  {
    int randLoc = rmRandInt(1,2);
    
    if(randLoc == 1 || cNumberTeams > 2)
      ypKingsHillPlacer(0.9, 0.5, 0.1, avoidCliff);
    else 
      ypKingsHillPlacer(0.1, 0.5, 0.05, avoidCliff);
  }

	// Text
	rmSetStatusText("",0.50);

	if (subCiv0 == rmGetCivID("Incas"))
	{  
		int incaVillageAID = -1;
		incaVillageAID = rmCreateGrouping("back inca village", "native inca village "+1);
		rmSetGroupingMinDistance(incaVillageAID, 0.0);
		rmSetGroupingMaxDistance(incaVillageAID, 0.20);
		rmAddGroupingToClass(incaVillageAID, rmClassID("natives"));
		rmAddGroupingToClass(incaVillageAID, rmClassID("importantItem"));
		rmAddGroupingConstraint(incaVillageAID, avoidTradeRoute);
		rmAddGroupingConstraint(incaVillageAID, avoidNatives);
		rmPlaceGroupingAtLoc(incaVillageAID, 0, 0.83, 0.75);
	}

	if (subCiv1 == rmGetCivID("Incas"))
	{  
		int incavillageBID = -1;
		incavillageBID = rmCreateGrouping("left city", "native inca village "+2);
		rmSetGroupingMinDistance(incavillageBID, 0.0);
		rmSetGroupingMaxDistance(incavillageBID, 20.0);
		rmAddGroupingToClass(incavillageBID, rmClassID("natives"));
		rmAddGroupingToClass(incavillageBID, rmClassID("importantItem"));
		rmAddGroupingConstraint(incavillageBID, avoidTradeRoute);
		rmAddGroupingConstraint(incavillageBID, avoidNatives);
		rmPlaceGroupingAtLoc(incavillageBID, 0, 0.73, 0.70);
	}

	if (subCiv2 == rmGetCivID("Incas"))
	{  
		int incavillageCID = -1;
		incavillageCID = rmCreateGrouping("right city", "native inca village "+3);
		rmSetGroupingMinDistance(incavillageCID, 0.0);
		rmSetGroupingMaxDistance(incavillageCID, 20.0);
		rmAddGroupingToClass(incavillageCID, rmClassID("natives"));
		rmAddGroupingToClass(incavillageCID, rmClassID("importantItem"));
		rmAddGroupingConstraint(incavillageCID, avoidTradeRoute);
		rmAddGroupingConstraint(incavillageCID, avoidNatives);
		rmPlaceGroupingAtLoc(incavillageCID, 0, 0.85, 0.25);
	}

	if (subCiv3 == rmGetCivID("Incas"))
	{  
		int incavillageDID = -1;
		incavillageDID = rmCreateGrouping("front city", "native inca village "+4);
		rmSetGroupingMinDistance(incavillageDID, 0.0);
		rmSetGroupingMaxDistance(incavillageDID, 20.0);
		rmAddGroupingToClass(incavillageDID, rmClassID("natives"));
		rmAddGroupingToClass(incavillageDID, rmClassID("importantItem"));
		rmAddGroupingConstraint(incavillageDID, avoidTradeRoute);
		rmAddGroupingConstraint(incavillageDID, avoidNatives);
		rmPlaceGroupingAtLoc(incavillageDID, 0, 0.73, 0.35);
	}


	// Text
	rmSetStatusText("",0.50);
	int failCount = -1;

	int numTries=cNumberNonGaiaPlayers+2;

	// PLAYER STARTING RESOURCES
	rmClearClosestPointConstraints();

	int TCID = rmCreateObjectDef("player TC");
	if (rmGetNomadStart())
	{
		rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);
	}

	rmAddObjectDefConstraint(TCID, playerEdgeConstraint);
	int TCfloat = -1;

	if (cNumberTeams == 2)
	{
		rmAddObjectDefConstraint(TCID, avoidTradeRouteTC);
		rmAddObjectDefConstraint(TCID, avoidTradeRouteSocketsTC);
		TCfloat = 18;
	}
	else 
	{
		rmAddObjectDefConstraint(TCID, avoidTradeRouteFar);
		TCfloat = 28;
	}

	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, TCfloat);

	rmAddObjectDefConstraint(TCID, avoidIncaSocketsTC);
	rmAddObjectDefConstraint(TCID, avoidTownCenterFar);

	int playerSilverID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playerSilverID, "mine", 1, 0);
	rmAddObjectDefConstraint(playerSilverID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerSilverID, avoidTownCenter);
	rmSetObjectDefMinDistance(playerSilverID, 15.0);
	rmSetObjectDefMaxDistance(playerSilverID, 18.0);
      rmAddObjectDefConstraint(playerSilverID, avoidImpassableLand);

	int playerMedSilverID = rmCreateObjectDef("player medium mine");
	rmAddObjectDefItem(playerMedSilverID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playerMedSilverID, 42.0);
	rmSetObjectDefMaxDistance(playerMedSilverID, 47.0);
	rmAddObjectDefConstraint(playerMedSilverID, avoidAll);
      rmAddObjectDefConstraint(playerMedSilverID, avoidImpassableLand);
      rmAddObjectDefConstraint(playerMedSilverID, playerConstraint);
      rmAddObjectDefConstraint(playerMedSilverID, avoidCoin); // avoidCoinShort
	rmAddObjectDefConstraint(playerMedSilverID, avoidTradeRoute);

	int playerGuanacoID=rmCreateObjectDef("player guanaco");
      rmAddObjectDefItem(playerGuanacoID, "guanaco", rmRandInt(15,15), 18.0);
      rmSetObjectDefMinDistance(playerGuanacoID, 10);
      rmSetObjectDefMaxDistance(playerGuanacoID, 18);
	rmAddObjectDefConstraint(playerGuanacoID, avoidAll);
      rmAddObjectDefConstraint(playerGuanacoID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerGuanacoID, avoidCliff);
      rmSetObjectDefCreateHerd(playerGuanacoID, false);

	int farGuanacoID=rmCreateObjectDef("player far guanaco");
      rmAddObjectDefItem(farGuanacoID, "guanaco", rmRandInt(10,10), 12.0);
      rmSetObjectDefMinDistance(farGuanacoID, 50);
      rmSetObjectDefMaxDistance(farGuanacoID, 55);
	rmAddObjectDefConstraint(farGuanacoID, avoidAll);
      rmAddObjectDefConstraint(farGuanacoID, avoidImpassableLand);
	rmAddObjectDefConstraint(farGuanacoID, avoidCliff);
	rmAddObjectDefConstraint(farGuanacoID, longPlayerConstraint);
	rmAddObjectDefConstraint(farGuanacoID, avoidGuanacoShort);
      rmSetObjectDefCreateHerd(farGuanacoID, true);

	int playerNuggetID= rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
  	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
  	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
  	rmAddObjectDefConstraint(playerNuggetID, avoidAll);
	rmAddObjectDefConstraint(playerNuggetID, avoidCliff);
	rmAddObjectDefConstraint(playerNuggetID, playerEdgeConstraint);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 30.0);

	int playerTreeID=rmCreateObjectDef("player trees");
      rmAddObjectDefItem(playerTreeID, "TreePuya", rmRandInt(6,10), 8.0);
      rmSetObjectDefMinDistance(playerTreeID, 10);
      rmSetObjectDefMaxDistance(playerTreeID, 25);
	rmAddObjectDefConstraint(playerTreeID, avoidAll);
      rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);

	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerMedSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerGuanacoID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(farGuanacoID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

    		if(ypIsAsian(i) && rmGetNomadStart() == false)
      	  rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		rmClearClosestPointConstraints();

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}

	// Text
	rmSetStatusText("",0.55);

	//Add cliff area
	for(i=0; <numTries)
	{
		int cliffID=rmCreateArea("cliff"+i);
	      rmSetAreaSize(cliffID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(600));
		rmSetAreaWarnFailure(cliffID, false);
		rmSetAreaCliffType(cliffID, "Andeswall");
		rmAddAreaToClass(cliffID, rmClassID("classCliff"));
		rmSetAreaCliffEdge(cliffID, 1, 1.0, 0.1, 1.0, 0);
		rmSetAreaCliffHeight(cliffID, rmRandInt(5,6), 1.0, 1.0);
		rmAddAreaConstraint(cliffID, cliffAvoidCliff);
		rmSetAreaMinBlobs(cliffID, 3);
		rmSetAreaMaxBlobs(cliffID, 5);
		rmSetAreaMinBlobDistance(cliffID, 3.0);
		rmSetAreaMaxBlobDistance(cliffID, 5.0);
		rmSetAreaCoherence(cliffID, 0.2);
		rmSetAreaSmoothDistance(cliffID, 10);
		rmAddAreaConstraint(cliffID, avoidTownCenterSupaFar);
		rmAddAreaConstraint(cliffID, avoidNatives); 
		rmAddAreaConstraint(cliffID, avoidTradeRouteSockets);
		rmAddAreaConstraint(cliffID, avoidTradeRoute);
		rmAddAreaConstraint(cliffID, avoidKOTH);
		rmAddAreaConstraint(cliffID, NEconstraint);
		rmSetAreaObeyWorldCircleConstraint(cliffID, false);
		if(rmBuildArea(cliffID)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==10)
				break;
		}
		else
			failCount=0;
	}

	// Text
	rmSetStatusText("",0.60);

	// Define and place Nuggets

	int nuggeteasyID= rmCreateObjectDef("nugget easy SE"); 
	rmAddObjectDefItem(nuggeteasyID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(nuggeteasyID, 0.0);
	rmSetObjectDefMaxDistance(nuggeteasyID, rmXFractionToMeters(0.5));
  	rmAddObjectDefConstraint(nuggeteasyID, avoidNuggetFar);
  	rmAddObjectDefConstraint(nuggeteasyID, avoidTownCenter);
  	rmAddObjectDefConstraint(nuggeteasyID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggeteasyID, avoidCliff);
  	rmAddObjectDefConstraint(nuggeteasyID, avoidAll);
  	rmAddObjectDefConstraint(nuggeteasyID, avoidImpassableLand);
	rmAddObjectDefConstraint(nuggeteasyID, SEconstraint);
	rmPlaceObjectDefAtLoc(nuggeteasyID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);

	int nuggeteasyNWID= rmCreateObjectDef("nugget easy NW"); 
	rmAddObjectDefItem(nuggeteasyNWID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(nuggeteasyNWID, 0.0);
	rmSetObjectDefMaxDistance(nuggeteasyNWID, rmXFractionToMeters(0.5));
  	rmAddObjectDefConstraint(nuggeteasyNWID, avoidNuggetFar);
  	rmAddObjectDefConstraint(nuggeteasyNWID, avoidTownCenter);
  	rmAddObjectDefConstraint(nuggeteasyNWID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggeteasyNWID, avoidCliff);
  	rmAddObjectDefConstraint(nuggeteasyNWID, avoidAll);
  	rmAddObjectDefConstraint(nuggeteasyNWID, avoidImpassableLand);
	rmAddObjectDefConstraint(nuggeteasyNWID, NWconstraint);
	rmPlaceObjectDefAtLoc(nuggeteasyNWID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);

	// Text
	rmSetStatusText("",0.65);

	if(rmRandFloat(0,1) < 0.80) //only places medium nuggets 75% of the time
	{
		int nuggetmediumID= rmCreateObjectDef("nugget medium SE"); 
		rmAddObjectDefItem(nuggetmediumID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(2, 2);
		rmSetObjectDefMinDistance(nuggetmediumID, 0.0);
		rmSetObjectDefMaxDistance(nuggetmediumID, rmXFractionToMeters(0.5));
  		rmAddObjectDefConstraint(nuggetmediumID, avoidNuggetFar);
  		rmAddObjectDefConstraint(nuggetmediumID, avoidTownCenter);
  		rmAddObjectDefConstraint(nuggetmediumID, avoidTradeRoute);
		rmAddObjectDefConstraint(nuggetmediumID, avoidCliff);
  		rmAddObjectDefConstraint(nuggetmediumID, avoidAll);
  		rmAddObjectDefConstraint(nuggetmediumID, avoidImpassableLand);
		rmAddObjectDefConstraint(nuggetmediumID, SEconstraint);
		rmPlaceObjectDefAtLoc(nuggetmediumID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);

		int nuggetmediumNWID= rmCreateObjectDef("nugget medium NW"); 
		rmAddObjectDefItem(nuggetmediumNWID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(2, 2);
		rmSetObjectDefMinDistance(nuggetmediumNWID, 0.0);
		rmSetObjectDefMaxDistance(nuggetmediumNWID, rmXFractionToMeters(0.5));
  		rmAddObjectDefConstraint(nuggetmediumNWID, avoidNuggetFar);
  		rmAddObjectDefConstraint(nuggetmediumNWID, avoidTownCenter);
  		rmAddObjectDefConstraint(nuggetmediumNWID, avoidTradeRoute);
		rmAddObjectDefConstraint(nuggetmediumNWID, avoidCliff);
  		rmAddObjectDefConstraint(nuggetmediumNWID, avoidAll);
  		rmAddObjectDefConstraint(nuggetmediumNWID, avoidImpassableLand);
		rmAddObjectDefConstraint(nuggetmediumNWID, NWconstraint);
		rmPlaceObjectDefAtLoc(nuggetmediumNWID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);
	}

	if(rmRandFloat(0,1) < 0.50) //only places hard nuggets 50% of the time
	{
	int nuggethardID= rmCreateObjectDef("nugget hard SE"); 
	rmAddObjectDefItem(nuggethardID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(3, 3);
	rmSetObjectDefMinDistance(nuggethardID, 0.0);
	rmSetObjectDefMaxDistance(nuggethardID, rmXFractionToMeters(0.5));
  	rmAddObjectDefConstraint(nuggethardID, avoidNuggetFar);
  	rmAddObjectDefConstraint(nuggethardID, avoidTownCenter);
  	rmAddObjectDefConstraint(nuggethardID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggethardID, avoidCliff);
  	rmAddObjectDefConstraint(nuggethardID, avoidAll);
	rmAddObjectDefConstraint(nuggethardID, playerEdgeConstraint);
  	rmAddObjectDefConstraint(nuggethardID, avoidImpassableLand);
	rmAddObjectDefConstraint(nuggethardID, SEconstraint);
	rmPlaceObjectDefAtLoc(nuggethardID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/4);

	int nuggethardNWID= rmCreateObjectDef("nugget hard NW"); 
	rmAddObjectDefItem(nuggethardNWID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(3, 3);
	rmSetObjectDefMinDistance(nuggethardNWID, 0.0);
	rmSetObjectDefMaxDistance(nuggethardNWID, rmXFractionToMeters(0.5));
  	rmAddObjectDefConstraint(nuggethardNWID, avoidNuggetFar);
  	rmAddObjectDefConstraint(nuggethardNWID, avoidTownCenter);
  	rmAddObjectDefConstraint(nuggethardNWID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggethardNWID, avoidCliff);
  	rmAddObjectDefConstraint(nuggethardNWID, avoidAll);
	rmAddObjectDefConstraint(nuggethardNWID, playerEdgeConstraint);
  	rmAddObjectDefConstraint(nuggethardNWID, avoidImpassableLand);
	rmAddObjectDefConstraint(nuggethardNWID, NWconstraint);
	rmPlaceObjectDefAtLoc(nuggethardNWID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/4);
	}

	//only try to place these 20% of the time
	   if(rmRandFloat(0,1) < 0.20)
	   {
		int nuggetnutsID= rmCreateObjectDef("nugget nuts SE"); 
		rmAddObjectDefItem(nuggetnutsID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(4, 4);
		rmSetObjectDefMinDistance(nuggetnutsID, 0.0);
		rmSetObjectDefMaxDistance(nuggetnutsID, rmXFractionToMeters(0.5));
  		rmAddObjectDefConstraint(nuggetnutsID, avoidNuggetFar);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidTownCenter);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidTradeRoute);
		rmAddObjectDefConstraint(nuggetnutsID, avoidCliff);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidAll);
		rmAddObjectDefConstraint(nuggetnutsID, playerEdgeConstraint);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidImpassableLand);
		rmAddObjectDefConstraint(nuggetnutsID, SEconstraint);
		rmPlaceObjectDefAtLoc(nuggetnutsID, 0, 0.5, 0.5, 1);

		int nuggetnutsNWID= rmCreateObjectDef("nugget nuts NW"); 
		rmAddObjectDefItem(nuggetnutsNWID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(4, 4);
		rmSetObjectDefMinDistance(nuggetnutsNWID, 0.0);
		rmSetObjectDefMaxDistance(nuggetnutsNWID, rmXFractionToMeters(0.5));
  		rmAddObjectDefConstraint(nuggetnutsNWID, avoidNuggetFar);
  		rmAddObjectDefConstraint(nuggetnutsNWID, avoidTownCenter);
  		rmAddObjectDefConstraint(nuggetnutsNWID, avoidTradeRoute);
		rmAddObjectDefConstraint(nuggetnutsNWID, avoidCliff);
  		rmAddObjectDefConstraint(nuggetnutsNWID, avoidAll);
		rmAddObjectDefConstraint(nuggetnutsNWID, playerEdgeConstraint);
  		rmAddObjectDefConstraint(nuggetnutsNWID, avoidImpassableLand);
		rmAddObjectDefConstraint(nuggetnutsNWID, NWconstraint);
		rmPlaceObjectDefAtLoc(nuggetnutsNWID, 0, 0.5, 0.5, 1);
	   }

	// Text
	rmSetStatusText("",0.70);

	// Silver mines
	int silverType = -1;
	int silverCount = (cNumberNonGaiaPlayers + rmRandInt(2,3));
	rmEchoInfo("silver count = "+silverCount);

	for(i=0; < silverCount)
	{
	  int silverID = rmCreateObjectDef("silver "+i);
	  rmAddObjectDefItem(silverID, "mine", 1, 0.0);
        rmSetObjectDefMinDistance(silverID, 0.0);
        rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
	  rmAddObjectDefConstraint(silverID, avoidCoinFar);
        rmAddObjectDefConstraint(silverID, avoidAll);
        rmAddObjectDefConstraint(silverID, avoidTownCenterSupaFar);
	  rmAddObjectDefConstraint(silverID, avoidTradeRoute);
	  rmAddObjectDefConstraint(silverID, avoidNatives);
	  rmAddObjectDefConstraint(silverID, avoidCliff);
	  rmAddObjectDefConstraint(silverID, coinEdgeConstraint);
	  rmAddObjectDefConstraint(silverID, NWconstraint);
	  rmPlaceObjectDefAtLoc(silverID, 0, 0.25, 0.75);
   }

	for(i=0; < silverCount)
	{
	  int silverSouthID = rmCreateObjectDef("silverSouth "+i);
	  rmAddObjectDefItem(silverSouthID, "mine", 1, 0.0);
        rmSetObjectDefMinDistance(silverSouthID, 0.0);
        rmSetObjectDefMaxDistance(silverSouthID, rmXFractionToMeters(0.5));
	  rmAddObjectDefConstraint(silverSouthID, avoidCoinFar);
        rmAddObjectDefConstraint(silverSouthID, avoidAll);
        rmAddObjectDefConstraint(silverSouthID, avoidTownCenterSupaFar);
	  rmAddObjectDefConstraint(silverSouthID, avoidTradeRoute);
	  rmAddObjectDefConstraint(silverSouthID, avoidNatives);
	  rmAddObjectDefConstraint(silverSouthID, avoidCliff);
	  rmAddObjectDefConstraint(silverSouthID, coinEdgeConstraint);
	  rmAddObjectDefConstraint(silverSouthID, SEconstraint);
	  rmPlaceObjectDefAtLoc(silverSouthID, 0, 0.75, 0.25);
   }

// Extra tree clumps near players - to ensure fair access to wood
   int extraTreesID=rmCreateObjectDef("extra trees");
   rmAddObjectDefItem(extraTreesID, "TreeAndes", 2, 2.0);
   rmAddObjectDefItem(extraTreesID, "TreePuya", 2, 2.0);
   rmSetObjectDefMinDistance(extraTreesID, 18);
   rmSetObjectDefMaxDistance(extraTreesID, 22);
   rmAddObjectDefConstraint(extraTreesID, avoidAll);
   rmAddObjectDefConstraint(extraTreesID, avoidCoin);
   rmAddObjectDefConstraint(extraTreesID, avoidTradeRouteSockets);
   rmAddObjectDefConstraint(extraTreesID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraTreesID, avoidTownCenterShort);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTreesID, 0, rmAreaID("player"+i), 1);

   int extraTrees2ID=rmCreateObjectDef("more extra trees");
   rmAddObjectDefItem(extraTrees2ID, "TreeAndes", 3, 3.0);
   rmAddObjectDefItem(extraTrees2ID, "TreePuya", 3, 3.0);
   rmSetObjectDefMinDistance(extraTrees2ID, 20);
   rmSetObjectDefMaxDistance(extraTrees2ID, 27);
   rmAddObjectDefConstraint(extraTrees2ID, avoidAll);
   rmAddObjectDefConstraint(extraTrees2ID, avoidCoin);
   rmAddObjectDefConstraint(extraTrees2ID, avoidTradeRouteSockets);
   rmAddObjectDefConstraint(extraTrees2ID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraTrees2ID, avoidTownCenterShort);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTrees2ID, 0, rmAreaID("player"+i), 1);

	// Text
	rmSetStatusText("",0.75);

// Huntables
      int guanacoCount = 0;
	if (cNumberNonGaiaPlayers<5)
		guanacoCount =4*cNumberNonGaiaPlayers;
	else if (cNumberNonGaiaPlayers<7)
		guanacoCount =3*cNumberNonGaiaPlayers;
	else
		guanacoCount =1.75*cNumberNonGaiaPlayers;

	for (i=0; <guanacoCount/2)
	{
		int guanacoID = rmCreateObjectDef("guanaco herd " +i);
		rmAddObjectDefItem(guanacoID, "guanaco", rmRandInt(8,10), 13);
		rmSetObjectDefMinDistance(guanacoID, 0.0);
		rmSetObjectDefMaxDistance(guanacoID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(guanacoID, avoidGuanaco);
		rmAddObjectDefConstraint(guanacoID, avoidAll);
		rmAddObjectDefConstraint(guanacoID, longerPlayerConstraint);
		rmAddObjectDefConstraint(guanacoID, avoidNatives);
		rmAddObjectDefConstraint(guanacoID, avoidTradeRoute);
		rmAddObjectDefConstraint(guanacoID, avoidCliffFar);
		rmAddObjectDefConstraint(guanacoID, NWconstraint);
		rmSetObjectDefCreateHerd(guanacoID, true);
		rmPlaceObjectDefAtLoc(guanacoID, 0, 0.5, 0.75);
	}

	for (i=0; <guanacoCount/2)
	{
		int guanacoSEID = rmCreateObjectDef("guanaco SE herd " +i);
		rmAddObjectDefItem(guanacoSEID, "guanaco", rmRandInt(8,10), 13);
		rmSetObjectDefMinDistance(guanacoSEID, 0.0);
		rmSetObjectDefMaxDistance(guanacoSEID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(guanacoSEID, avoidGuanaco);
		rmAddObjectDefConstraint(guanacoSEID, avoidAll);
		rmAddObjectDefConstraint(guanacoSEID, longerPlayerConstraint);
		rmAddObjectDefConstraint(guanacoSEID, avoidNatives);
		rmAddObjectDefConstraint(guanacoSEID, avoidTradeRoute);
		rmAddObjectDefConstraint(guanacoSEID, avoidCliffFar);
		rmAddObjectDefConstraint(guanacoSEID, SEconstraint);
		rmSetObjectDefCreateHerd(guanacoSEID, true);
		rmPlaceObjectDefAtLoc(guanacoSEID, 0, 0.5, 0.25);
	}

// Central Clearing
   int forestClearing=rmCreateArea("forest clearing ");
   rmSetAreaWarnFailure(forestClearing, false);
   rmSetAreaSize(forestClearing, rmAreaTilesToFraction(600), rmAreaTilesToFraction(700));
   rmSetAreaLocation(forestClearing, 0.5, 0.5);
   rmAddAreaInfluenceSegment(forestClearing, 0.25, 0.5, 0.65, 0.5);
   rmSetAreaMix(forestClearing, "andes_grass_b");
   rmAddAreaToClass(forestClearing, rmClassID("classClearing"));
   rmSetAreaCoherence(forestClearing, 0.5);
   rmSetAreaSmoothDistance(forestClearing, 10);
   rmBuildArea(forestClearing);

	// Text
	rmSetStatusText("",0.80);

// Forest areas
	if (cNumberNonGaiaPlayers < 4)
		numTries=8*cNumberNonGaiaPlayers;
	else if (cNumberNonGaiaPlayers < 6)
		numTries=6*cNumberNonGaiaPlayers;
	else if (cNumberNonGaiaPlayers == 6)
		numTries=5*cNumberNonGaiaPlayers;
	else
		numTries=4*cNumberNonGaiaPlayers;
	failCount=0;
	for (i=0; <numTries)
	{   
		int forestID=rmCreateArea("forestID"+i, southIslandID);
		rmSetAreaWarnFailure(forestID, false);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(160), rmAreaTilesToFraction(200));
		rmSetAreaForestType(forestID, "andes forest");
		rmSetAreaForestDensity(forestID, 0.9);
		rmSetAreaForestClumpiness(forestID, 0.7);		
		rmSetAreaForestUnderbrush(forestID, 0.6);
		rmSetAreaMinBlobs(forestID, 1);
		rmSetAreaMaxBlobs(forestID, 4);						
		rmSetAreaMinBlobDistance(forestID, 5.0);
		rmSetAreaMaxBlobDistance(forestID, 20.0);
		rmSetAreaCoherence(forestID, 0.4);
		rmSetAreaSmoothDistance(forestID, 10);
		rmAddAreaToClass(forestID, rmClassID("classForest"));
		rmAddAreaConstraint(forestID, shortForestConstraint);  
		rmAddAreaConstraint(forestID, avoidTradeRoute);
		rmAddAreaConstraint(forestID, shortAvoidImportantItem);
		rmAddAreaConstraint(forestID, playerConstraint);
		rmAddAreaConstraint(forestID, avoidCliff);
		rmAddAreaConstraint(forestID, avoidClearing);
		rmAddAreaConstraint(forestID, avoidAll);
		if(rmBuildArea(forestID)==false)
		{
			// Stop trying once we fail 5 times in a row.
			failCount++;
			if(failCount==10)
				break;
		}
		else
			failCount=0; 
	}

	// Text
	rmSetStatusText("",0.85);

	if (cNumberNonGaiaPlayers < 4)
		numTries=8*cNumberNonGaiaPlayers;
	else if (cNumberNonGaiaPlayers < 6)
		numTries=6*cNumberNonGaiaPlayers;
	else if (cNumberNonGaiaPlayers == 6)
		numTries=5*cNumberNonGaiaPlayers;
	else
		numTries=4*cNumberNonGaiaPlayers;

	failCount=0;
	for (i=0; <numTries)
	{   
		int forestnorthID=rmCreateArea("forestNorthID"+i, northIslandID);
		rmSetAreaWarnFailure(forestnorthID, false);
		rmSetAreaSize(forestnorthID, rmAreaTilesToFraction(160), rmAreaTilesToFraction(200));
		rmSetAreaForestType(forestnorthID, "andes forest");
		rmSetAreaForestDensity(forestnorthID, 0.5);
		rmSetAreaForestClumpiness(forestnorthID, 0.4);		
		rmSetAreaForestUnderbrush(forestnorthID, 0.7);
		rmSetAreaMinBlobs(forestnorthID, 1);
		rmSetAreaMaxBlobs(forestnorthID, 4);						
		rmSetAreaMinBlobDistance(forestnorthID, 5.0);
		rmSetAreaMaxBlobDistance(forestnorthID, 20.0);
		rmSetAreaCoherence(forestnorthID, 0.4);
		rmSetAreaSmoothDistance(forestnorthID, 10);
		rmAddAreaToClass(forestnorthID, rmClassID("classForest"));
		rmAddAreaConstraint(forestID, shortForestConstraint);   
		rmAddAreaConstraint(forestnorthID, avoidTradeRoute);
		rmAddAreaConstraint(forestnorthID, shortAvoidImportantItem);
		rmAddAreaConstraint(forestnorthID, playerConstraint);
		rmAddAreaConstraint(forestnorthID, avoidCliff);
		rmAddAreaConstraint(forestnorthID, avoidClearing);
		rmAddAreaConstraint(forestnorthID, avoidAll);
		if(rmBuildArea(forestnorthID)==false)
		{
			// Stop trying once we fail 5 times in a row.
			failCount++;
			if(failCount==10)
				break;
		}
		else
			failCount=0; 
	}

	// Text
	rmSetStatusText("",0.90);

// Resources that can be placed after forests

	if(rmRandFloat(0,1) < 0.75) //place llamas 75% of the time
	{
		if (cNumberNonGaiaPlayers<5)
			int llamaCount =rmRandInt(1,3)*cNumberNonGaiaPlayers;
		else
			llamaCount = rmRandInt(1,2)*cNumberNonGaiaPlayers;
		for (i=0; <llamaCount)
		{
			int llamaID = rmCreateObjectDef("llama herd "+i);
			rmAddObjectDefItem(llamaID, "llama", rmRandInt(1,2), 8);
			rmSetObjectDefMinDistance(llamaID, 0.0);
			rmSetObjectDefMaxDistance(llamaID, rmXFractionToMeters(0.5));
			rmAddObjectDefConstraint(llamaID, avoidLlama);
			rmAddObjectDefConstraint(llamaID, avoidAll);
			rmAddObjectDefConstraint(llamaID, avoidTownCenterFar);
			rmAddObjectDefConstraint(llamaID, avoidCliffFar);
			rmSetObjectDefCreateHerd(llamaID, false);
			rmPlaceObjectDefAtLoc(llamaID, 0, 0.5, 0.5);
		}
	}

	// Text
	rmSetStatusText("",0.95);

	// Define and place Puyas
	int puyaCount = (cNumberNonGaiaPlayers*3);
	rmEchoInfo("puya count = "+puyaCount);
	for (i=0; <puyaCount)
	{   
		int puyaTreeID= rmCreateObjectDef("puya tree"+i); 
		rmAddObjectDefItem(puyaTreeID, "treePuya", 1, 0.0);
		rmAddObjectDefConstraint(puyaTreeID, shortAvoidImpassableLand);
  		rmAddObjectDefConstraint(puyaTreeID, avoidNugget);
 		rmAddObjectDefConstraint(puyaTreeID, avoidTradeRoute);
		rmAddObjectDefConstraint(puyaTreeID, avoidTownCenter);
 		rmAddObjectDefConstraint(puyaTreeID, avoidAll);
		rmAddObjectDefConstraint(puyaTreeID, avoidCliff);
		rmAddObjectDefConstraint(puyaTreeID, playerEdgeConstraint);
		rmPlaceObjectDefAtLoc(puyaTreeID, 0, 0.5, 0.5);
	}

	// Text
	rmSetStatusText("",1.0);	
       


}  