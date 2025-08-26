// --------------------------------------------------------------------------------------------------------------------
// --------------------------------------------- C O L O R A D O --------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------


// ---------------------------------------------- Commentaries ----------------------------------------------------
// An idea of yoqpasa.
// Map done by Rikikipu (February 2016)


// --------------------------------------------- Introduction ------------------------------------------------------


include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";


void main(void)
{


   rmSetStatusText("",0.01);


	int playerTiles = 13000;
	if (cNumberNonGaiaPlayers >2)
		playerTiles = 12000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 11000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 10000;

	int size=1.9*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmSetMapSize(size, size*1.25);
    	rmSetSeaLevel(0.0);
	rmTerrainInitialize("rockies\clifftop_roc", 10.0); // and then i add a negative cliff in the middle
	rmSetMapType("rockies");
	rmSetMapType("mountain");
	rmSetMapType("land");
	rmSetMapType("namerica");
    	rmSetLightingSet("rockies");

	chooseMercs();

	// Corner constraint.
	rmSetWorldCircleConstraint(true);

   // Define some classes. These are used later for constraints.
	int classPlayer=rmDefineClass("player");
	rmDefineClass("classHill");
	rmDefineClass("classPatch");
	rmDefineClass("classPatch2");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("natives");
	rmDefineClass("classCliff");
	rmDefineClass("secrets");
	rmDefineClass("nuggets");
	rmDefineClass("center");
	rmDefineClass("tradeIslands");
    rmDefineClass("socketClass");

	int classGreatLake=rmDefineClass("great lake");

// ------------------------------------------------------------- Constraints --------------------------------------------------

	// Edge avoidance
	int stayMiddle = rmCreateBoxConstraint("Edge cliff design", rmXTilesToFraction(5), rmZTilesToFraction(2), 1.0-rmXTilesToFraction(5), 1.0-rmZTilesToFraction(2), 0.0);
    int stayMiddleEdge = rmCreateBoxConstraint("middle patch design", rmXTilesToFraction(6), rmZTilesToFraction(5), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(5), 0.0);

	// starting constraints
    int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 63.0);
    int avoidTownCenterFar1=rmCreateTypeDistanceConstraint("avoid Town Center Far 1", "townCenter", 30.0);
	int avoidTownCenterFar2=rmCreateTypeDistanceConstraint("avoid Town Center Far 2", "townCenter", 50.0);
	int avoidCoinStart=rmCreateTypeDistanceConstraint("avoid coin starts", "Mine", 30.0);
	int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 10.0);
	int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 45.0);
	int shortAvoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units short", rmClassID("startingUnit"), 10.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 10.0);

	// Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
    int avoidCliffshort=rmCreateClassDistanceConstraint("cliff vs. cliff short", rmClassID("classCliff"), 6.0);
	int avoidCliffs=rmCreateClassDistanceConstraint("cliff vs. cliff ", rmClassID("classCliff"), 10.0);
        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.99), rmDegreesToRadians(0), rmDegreesToRadians(360));

	// Ressource avoidance
	int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 50.0);
    int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 40.0);
	int avoidNuggetStart=rmCreateTypeDistanceConstraint("nugget avoid nugget1", "AbstractNugget", 20.0);
	int ElkConstraint=rmCreateTypeDistanceConstraint("avoid the Elk", "Elk", 40.0);
	int BighornConstraint=rmCreateTypeDistanceConstraint("avoid the Bighorn", "BighornSheep", 40.0);
	int shortElkConstraint=rmCreateTypeDistanceConstraint("short avoid the Elk", "Elk", 20.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 20.0);
    int avoidCoinShort=rmCreateTypeDistanceConstraint("avoids coin short", "gold", 8.0);
    int avoidElk = rmCreateTypeDistanceConstraint("avoid Elk", "Elk", 45.0);
    int avoidBighornSheep = rmCreateTypeDistanceConstraint("avoid bighornsheep", "BighornSheep", 45.0);

	// Decoration avoidance
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

	// Trade route avoidance.
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
	int shortAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("short trade route", 2.0);
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);
	int avoidTradeSockets = rmCreateTypeDistanceConstraint("avoid trade sockets", "sockettraderoute", 10.0);
	int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 8.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid Natives short", rmClassID("natives"), 10.0);
    int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("trade route small", 4.0);


	rmSetStatusText("",0.10);
// ---------------------------------------------- TradeRoute and Cliffs -----------------------------------------------

   int tradeRouteID = rmCreateTradeRoute();
   int tradeRouteID1 = rmCreateTradeRoute();

   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
   int socketIDB=rmCreateObjectDef("sockets to dock Trade Posts B");
   rmSetObjectDefTradeRouteID(socketIDB, tradeRouteID);
   int socketID1=rmCreateObjectDef("sockets to dock Trade Posts1");
   rmSetObjectDefTradeRouteID(socketID1, tradeRouteID1);
   int socketID1B=rmCreateObjectDef("sockets to dock Trade Posts1 B");
   rmSetObjectDefTradeRouteID(socketID1B, tradeRouteID1);



   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 6.0);
   rmAddObjectDefConstraint(socketID, avoidCliffshort);

   rmAddObjectDefItem(socketIDB, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketIDB, true);
   rmAddObjectDefToClass(socketIDB, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketIDB, 0.0);
   rmSetObjectDefMaxDistance(socketIDB, 6.0);
   rmAddObjectDefConstraint(socketIDB, avoidCliffshort);

   rmAddObjectDefItem(socketID1, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID1, true);
   rmAddObjectDefToClass(socketID1, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketID1, 0.0);
   rmSetObjectDefMaxDistance(socketID1, 6.0);
   rmAddObjectDefConstraint(socketID1, avoidCliffshort);

   rmAddObjectDefItem(socketID1B, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID1B, true);
   rmAddObjectDefToClass(socketID1B, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketID1B, 0.0);
   rmSetObjectDefMaxDistance(socketID1B, 6.0);
   rmAddObjectDefConstraint(socketID1B, avoidCliffshort);

	rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.85);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.7, 0.85, 2, 2);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.8, 0.75, 2, 2 );
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.8, 0.6, 2, 2 );
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.7, 0.5, 2, 2 );
	if (rmGetIsKOTH()) {
		rmAddTradeRouteWaypoint(tradeRouteID, 0.57, 0.5);
	} else {
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.54, 0.5, 0, 0);
	}

	rmAddTradeRouteWaypoint(tradeRouteID1, 0.65, 0.15);
	rmAddRandomTradeRouteWaypoints(tradeRouteID1, 0.3, 0.15, 2, 2);
    rmAddRandomTradeRouteWaypoints(tradeRouteID1, 0.2, 0.25, 2, 2);
	rmAddRandomTradeRouteWaypoints(tradeRouteID1, 0.2, 0.4, 2, 2);
	rmAddRandomTradeRouteWaypoints(tradeRouteID1, 0.3, 0.5, 2, 2);
	if (rmGetIsKOTH()) {
		rmAddTradeRouteWaypoint(tradeRouteID1, 0.40, 0.5);
	} else {
		rmAddRandomTradeRouteWaypoints(tradeRouteID1, 0.46, 0.5, 0, 0);
	}

	bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
	bool placedTradeRoute1 = rmBuildTradeRoute(tradeRouteID1, "dirt");


   int cliffID1 = rmCreateArea("cliff middle 1");
   rmSetAreaLocation(cliffID1, 0.5, 0.5);
   rmSetAreaSize(cliffID1, 0.7, 0.7);
   rmSetAreaCoherence(cliffID1, 0.85);
   rmSetAreaSmoothDistance(cliffID1, 15.0);
   rmSetAreaHeightBlend(cliffID1, 6.0);
   rmSetAreaCliffHeight(cliffID1, -8.0, 0.0, 0.0);
   rmSetAreaCliffType(cliffID1, "rocky mountain2");
   rmSetAreaCliffEdge(cliffID1, 1.0, 1.0);
   rmSetAreaMix(cliffID1, "rockies_snow");
   //rmAddAreaToClass(cliffID1, rmClassID("classPatch"));
   rmAddAreaConstraint(cliffID1, stayMiddle);
   rmSetAreaCliffPainting(cliffID1, true, true, true, 0.0, false);
   rmSetAreaWarnFailure(cliffID1, false);
   rmBuildArea(cliffID1);

   int stayMiddleEdge1 = rmCreateCliffEdgeDistanceConstraint("test for cliffs", cliffID1, 4.0);
   int stayMiddleEdge2 = rmCreateCliffEdgeDistanceConstraint("test for cliffs2", cliffID1, 10.0);
   int stayGrass = rmCreateAreaMaxDistanceConstraint("stay in grass", cliffID1, 0.0);

   int middleGrass = rmCreateArea("middle grass area");
   rmSetAreaLocation(middleGrass, 0.5, 0.5);
   rmSetAreaWarnFailure(middleGrass, false);
   rmSetAreaSize(middleGrass,0.67, 0.67);
   rmSetAreaCoherence(middleGrass, 1.0);
   rmSetAreaSmoothDistance(middleGrass, 15);
   rmAddAreaConstraint(middleGrass, stayMiddleEdge);
   rmSetAreaObeyWorldCircleConstraint(middleGrass, false);
   rmSetAreaMix(middleGrass, "rockies_grass");
   rmAddAreaToClass(middleGrass, rmClassID("classPatch2"));
   rmAddAreaTerrainLayer(middleGrass, "rockies\groundsnow1_roc", 0 ,1);
   rmAddAreaTerrainLayer(middleGrass, "rockies\groundsnow7_roc", 1 ,4);
   rmAddAreaTerrainLayer(middleGrass, "rockies\groundsnow8_roc", 4 ,8);
   rmBuildArea(middleGrass);

	rmSetMapElevationParameters(cElevTurbulence, 0.25, 2, 0.5, 2.0); /////////////// xDDDDDD

   int stayMiddleGrass = rmCreateAreaConstraint("units don't go edge", middleGrass);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);

   for(i=0; <cNumberNonGaiaPlayers*20)
   {
   int newGrass = rmCreateArea("new grass"+i);
   rmSetAreaLocation(newGrass, rmRandFloat(0.1,0.9), rmRandFloat(0.1,0.9));
   rmSetAreaWarnFailure(newGrass, false);
   rmAddAreaToClass(newGrass, rmClassID("classPatch"));
   rmSetAreaSize(newGrass, rmAreaTilesToFraction(120), rmAreaTilesToFraction(150));
   rmSetAreaCoherence(newGrass, 0.0);
   rmSetAreaSmoothDistance(newGrass, 3);
   rmAddAreaConstraint(newGrass, stayMiddleGrass);
   rmAddAreaConstraint(newGrass, patchConstraint);
   rmSetAreaObeyWorldCircleConstraint(newGrass, false);
   rmSetAreaTerrainType(newGrass, "rockies\ground5_roc");
   rmBuildArea(newGrass);
   }


	// need to build sockets after having designed edge cliffs and middle patch
    vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.05);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
    rmPlaceObjectDefAtPoint(socketIDB, 0, socketLoc);

     socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.05);
     rmPlaceObjectDefAtPoint(socketID1, 0, socketLoc);
     socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.8);
     rmPlaceObjectDefAtPoint(socketID1B, 0, socketLoc);
// ------------------------------------ Design : middle cliffs  ------------------------------------------


   int cliffIDB1 = rmCreateArea("cliff bottom center step 1");
   rmSetAreaLocation(cliffIDB1, 0.5, 0.35);
   rmAddAreaInfluenceSegment(cliffIDB1, 0.5, 0.28, 0.5, 0.4);
   rmSetAreaSize(cliffIDB1, 0.018, 0.018);
   rmSetAreaCoherence(cliffIDB1, 0.8);
   rmSetAreaSmoothDistance(cliffIDB1, 4.0);
   rmSetAreaHeightBlend(cliffIDB1, 6.0);
   rmSetAreaCliffHeight(cliffIDB1, 7.0, 0.0, 0.0);
   rmSetAreaMix(cliffIDB1, "rockies_snow");
   rmSetAreaCliffType(cliffIDB1, "rocky mountain2");
   rmSetAreaCliffEdge(cliffIDB1, 1.0, 1.0, 0.0, 1.0, 0);
   rmAddAreaToClass(cliffIDB1, rmClassID("classCliff"));
   rmSetAreaCliffPainting(cliffIDB1, true, true, true, 1.0, true);
   rmSetAreaWarnFailure(cliffIDB1, false);
   rmBuildArea(cliffIDB1);

   int cliffIDB2 = rmCreateArea("cliff bottom center step 2");
   rmSetAreaLocation(cliffIDB2, 0.5, 0.34);
   rmAddAreaInfluenceSegment(cliffIDB2, 0.5, 0.29, 0.5, 0.36);
   rmSetAreaSize(cliffIDB2, 0.009, 0.009);
   rmSetAreaCoherence(cliffIDB2, 0.75);
   rmSetAreaSmoothDistance(cliffIDB2, 4.0);
   rmSetAreaHeightBlend(cliffIDB2, 6.0);
   rmSetAreaCliffHeight(cliffIDB2, 5.0, 0.0, 0.0);
   rmSetAreaMix(cliffIDB2, "rockies_snow");
   rmSetAreaCliffType(cliffIDB2, "rocky mountain2");
   rmSetAreaCliffEdge(cliffIDB2, 1.0, 1.0, 0.0, 0.5, 0);
   rmAddAreaToClass(cliffIDB2, rmClassID("classCliff"));
   rmSetAreaCliffPainting(cliffIDB2, true, true, true, 1.0, true);
   rmSetAreaWarnFailure(cliffIDB2, false);
   //rmBuildArea(cliffIDB2);

   int cliffIDT1 = rmCreateArea("cliff top center step 1");
   rmSetAreaLocation(cliffIDT1, 0.5, 0.65);
   rmAddAreaInfluenceSegment(cliffIDT1, 0.5, 0.75, 0.5, 0.6);
   rmSetAreaSize(cliffIDT1, 0.018, 0.018);
   rmSetAreaCoherence(cliffIDT1, 0.75);
   rmSetAreaSmoothDistance(cliffIDT1, 4.0);
   rmSetAreaHeightBlend(cliffIDT1, 6.0);
   rmSetAreaCliffHeight(cliffIDT1, 7.0, 0.0, 0.0);
   rmSetAreaMix(cliffIDT1, "rockies_snow");
   rmSetAreaCliffType(cliffIDT1, "rocky mountain2");
   rmSetAreaCliffEdge(cliffIDT1, 1.0, 1.0, 0.0, 1.0, 0);
   rmAddAreaToClass(cliffIDT1, rmClassID("classCliff"));
   rmSetAreaCliffPainting(cliffIDT1, true, true, true, 1.0, true);
   rmSetAreaWarnFailure(cliffIDT1, false);
   rmBuildArea(cliffIDT1);

   int cliffIDT2 = rmCreateArea("cliff top center step 2");
   rmSetAreaLocation(cliffIDT2, 0.5, 0.65);
   rmAddAreaInfluenceSegment(cliffIDT2, 0.5, 0.72, 0.5, 0.63);
   rmSetAreaSize(cliffIDT2, 0.009, 0.009);
   rmSetAreaCoherence(cliffIDT2, 0.75);
   rmSetAreaSmoothDistance(cliffIDT2, 4.0);
   rmSetAreaHeightBlend(cliffIDT2, 6.0);
   rmSetAreaCliffHeight(cliffIDT2, 5.0, 0.0, 0.0);
   rmSetAreaMix(cliffIDT2, "rockies_snow");
   rmSetAreaCliffType(cliffIDT2, "rocky mountain2");
   rmSetAreaCliffEdge(cliffIDT2, 1.0, 1.0, 0.0, 0.5, 0);
   rmAddAreaToClass(cliffIDT2, rmClassID("classCliff"));
   rmSetAreaCliffPainting(cliffIDT2, true, true, true, 1.0, true);
   rmSetAreaWarnFailure(cliffIDT2, false);
   //rmBuildArea(cliffIDT2);


	// Text
	rmSetStatusText("",0.50);
	int numTries = -1;
	int failCount = -1;

// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

  if (rmGetIsKOTH()) {

    int randLoc = rmRandInt(1,3);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.01;

    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }


// -------------------------------------------------------------- Let's place some design (oasis and forest ) ---------------------------------------------

      int ComancheVillageID = -1;
      ComancheVillageID = rmCreateGrouping("Comanche village", "native Comanche village "+3);
      rmSetGroupingMinDistance(ComancheVillageID, 0.0);
      rmSetGroupingMaxDistance(ComancheVillageID, 0.0);
      rmAddGroupingConstraint(ComancheVillageID, avoidImpassableLand);
      rmAddGroupingToClass(ComancheVillageID, rmClassID("natives"));
      rmPlaceGroupingAtLoc(ComancheVillageID, 0, 0.3, 0.3);

      int ComancheVillageAID = -1;
      ComancheVillageAID = rmCreateGrouping("Comanche village A", "native Comanche village "+2);
      rmSetGroupingMinDistance(ComancheVillageAID, 0.0);
     rmSetGroupingMaxDistance(ComancheVillageAID, 0.00);
      rmAddGroupingConstraint(ComancheVillageAID, avoidImpassableLand);
      rmAddGroupingToClass(ComancheVillageAID, rmClassID("natives"));
      rmPlaceGroupingAtLoc(ComancheVillageAID, 0, 0.7, 0.7);



 // ----------------------------------------------------- Players and blabla starting stuff -------------------------------------------------

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);


		if (cNumberTeams==2)
		{
			if (cNumberNonGaiaPlayers==2)
			{
		   if (rmRandFloat(0,1)<0.5)
		   {
		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.87, 0.22);
		   rmPlacePlayersCircular(0.33, 0.34, 0);

		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.37, 0.72);
		   rmPlacePlayersCircular(0.33, 0.34, 0);
		   }
		   else
		   {
		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.87, 0.22);
		   rmPlacePlayersCircular(0.33, 0.34, 0);

		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.37, 0.72);
		   rmPlacePlayersCircular(0.33, 0.34, 0);
		   }
			}
			else
			{
		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.75, 0.89);
		   rmPlacePlayersCircular(0.35, 0.36, 0);

		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.25, 0.39);
		   rmPlacePlayersCircular(0.35, 0.36, 0);
			}
		}
		else
		{
			rmPlacePlayer(1, 0.23, 0.8);
			rmPlacePlayer(2, 0.77, 0.2);
			rmPlacePlayer(3, 0.2, 0.2);
			rmPlacePlayer(4, 0.8, 0.8);
			rmPlacePlayer(5, 0.18, 0.5);
			rmPlacePlayer(6, 0.82, 0.5);
			rmPlacePlayer(7, 0.5, 0.87);
			rmPlacePlayer(8, 0.5, 0.13);

		}



	int startingTCID= rmCreateObjectDef("startingTC");
	if (rmGetNomadStart())
		{
			rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
		}
		else
		{
            rmAddObjectDefItem(startingTCID, "townCenter", 1, 0.0);
		}
	rmAddObjectDefConstraint(startingTCID, avoidImpassableLand);
	rmAddObjectDefConstraint(startingTCID, avoidTradeRoute);
	rmAddObjectDefToClass(startingTCID, rmClassID("player"));
	rmSetObjectDefMinDistance(startingTCID, 0.0);
	rmSetObjectDefMaxDistance(startingTCID, 5.0);


	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 6.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);
	rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeRockies", 3, 4.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 10);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 18);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartResource);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidCoinShort);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidStartingUnits);
	rmAddObjectDefConstraint(StartAreaTreeID, stayMiddle);


	int StartBighornSheepID=rmCreateObjectDef("first hunt");
	rmAddObjectDefItem(StartBighornSheepID, "BighornSheep", 8, 6.0);
	rmSetObjectDefCreateHerd(StartBighornSheepID, false);
	rmSetObjectDefMinDistance(StartBighornSheepID, 13);
	rmSetObjectDefMaxDistance(StartBighornSheepID, 15);
	rmAddObjectDefConstraint(StartBighornSheepID, avoidStartResource);
	rmAddObjectDefConstraint(StartBighornSheepID, avoidCoinShort);
	rmAddObjectDefConstraint(StartBighornSheepID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartBighornSheepID, stayMiddle);

	int StartElkT=rmCreateObjectDef("starting moose1");
	rmAddObjectDefItem(StartElkT, "Elk", rmRandInt(10,11), 9.0);
	rmSetObjectDefCreateHerd(StartElkT, true);
	rmSetObjectDefCreateHerd(StartElkT, true);
	rmSetObjectDefMinDistance(StartElkT, 36);
	rmSetObjectDefMaxDistance(StartElkT, 38);
	rmAddObjectDefConstraint(StartElkT, ElkConstraint);
	rmAddObjectDefConstraint(StartElkT, avoidCliffs);
	rmAddObjectDefConstraint(StartElkT, avoidCliffshort);
	rmAddObjectDefConstraint(StartElkT, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartElkT, avoidAll);
	rmAddObjectDefConstraint(StartElkT, stayMiddleGrass);
	rmAddObjectDefConstraint(StartElkT, stayMiddleEdge2);

	int startSilverID = rmCreateObjectDef("first mine");
	rmAddObjectDefItem(startSilverID, "mine", 1, 5.0);
	rmSetObjectDefMinDistance(startSilverID, 13.0);
	rmSetObjectDefMaxDistance(startSilverID, 15.0);
	rmAddObjectDefConstraint(startSilverID, avoidStartResource);
	rmAddObjectDefConstraint(startSilverID, avoidTradeSockets);
	rmAddObjectDefConstraint(startSilverID, shortAvoidTradeRoute);
	rmAddObjectDefConstraint(startSilverID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(startSilverID, stayMiddle);

	int startSilverIDT = rmCreateObjectDef("mine for team");
	rmAddObjectDefItem(startSilverIDT, "mine", 1, 0.0);
	rmSetObjectDefMinDistance(startSilverIDT, 40.0);
	rmSetObjectDefMaxDistance(startSilverIDT, 42.0);
	rmAddObjectDefConstraint(startSilverIDT, avoidTradeRouteFar);
	rmAddObjectDefConstraint(startSilverIDT, stayMiddle);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
	rmAddObjectDefToClass(playerNuggetID, rmClassID("startingUnit"));
    rmSetObjectDefMinDistance(playerNuggetID, 23.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 32.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetStart);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidSocket);
	rmAddObjectDefConstraint(playerNuggetID, avoidAll);

	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i),);

    if(ypIsAsian(i) && rmGetNomadStart() == false)
	{
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    	}
		rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(startSilverID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if (cNumberNonGaiaPlayers !=2)
    	{
		rmPlaceObjectDefAtLoc(StartElkT, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startSilverIDT, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		}
		rmPlaceObjectDefAtLoc(StartBighornSheepID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}



// --------------------------------------------- Ressources  -----------------------------------------------------------

// ********************************************* mines *****************************************************************

   int stayNE = rmCreatePieConstraint("stay NE",0.5,0.5, rmZFractionToMeters(0.0),rmZFractionToMeters(0.5), rmDegreesToRadians(1),rmDegreesToRadians(179));
   int staySW = rmCreatePieConstraint("stay SW",0.5,0.5, rmZFractionToMeters(0.0),rmZFractionToMeters(0.5), rmDegreesToRadians(181),rmDegreesToRadians(359));

   	int silverIDNE = rmCreateObjectDef("mines for 1V1");
	rmAddObjectDefItem(silverIDNE, "mine", 1, 0);
	rmSetObjectDefMinDistance(silverIDNE, 0.0);
	rmSetObjectDefMaxDistance(silverIDNE, 10);
	rmAddObjectDefConstraint(silverIDNE, avoidTradeRoute);
	rmAddObjectDefConstraint(silverIDNE, avoidCliffshort);
	rmAddObjectDefConstraint(silverIDNE, stayMiddleEdge);
	rmAddObjectDefConstraint(silverIDNE, avoidNativesShort);
	rmAddObjectDefConstraint(silverIDNE, avoidSocket);

if (cNumberNonGaiaPlayers==2)
{
	rmPlaceObjectDefAtLoc(silverIDNE, 0, 0.45, 0.88); // behind cliffs
	rmPlaceObjectDefAtLoc(silverIDNE, 0, 0.55, 0.12);

    if (rmRandFloat(0,1)<0.5)
    {
	rmPlaceObjectDefAtLoc(silverIDNE, 0, 0.82, 0.4); // in front
	rmPlaceObjectDefAtLoc(silverIDNE, 0, 0.18, 0.6);

	rmPlaceObjectDefAtLoc(silverIDNE, 0, 0.15, 0.3); // side
	rmPlaceObjectDefAtLoc(silverIDNE, 0, 0.85, 0.7);

	rmPlaceObjectDefAtLoc(silverIDNE, 0, 0.65, 0.62); // next to native tp
	rmPlaceObjectDefAtLoc(silverIDNE, 0, 0.35, 0.38);
	}
    else
    {
	rmPlaceObjectDefAtLoc(silverIDNE, 0, 0.6, 0.44);
	rmPlaceObjectDefAtLoc(silverIDNE, 0, 0.4, 0.56);

	rmPlaceObjectDefAtLoc(silverIDNE, 0, 0.13, 0.48);
	rmPlaceObjectDefAtLoc(silverIDNE, 0, 0.87, 0.52);

	rmPlaceObjectDefAtLoc(silverIDNE, 0, 0.7, 0.77);
	rmPlaceObjectDefAtLoc(silverIDNE, 0, 0.3, 0.23);
	}

}
else
{
	   for (i=0; <cNumberNonGaiaPlayers*3)
      {
   	int silverIDT = rmCreateObjectDef("mines for 1V1"+i);
	rmAddObjectDefItem(silverIDT, "mine", 1, 0);
	rmSetObjectDefMinDistance(silverIDT, 0.0);
	rmSetObjectDefMaxDistance(silverIDT, rmZFractionToMeters(0.45));
	rmAddObjectDefConstraint(silverIDT, avoidTradeRoute);
	rmAddObjectDefConstraint(silverIDT, avoidCliffs);
	rmAddObjectDefConstraint(silverIDT, stayMiddleEdge1);
	rmAddObjectDefConstraint(silverIDT, avoidNativesShort);
	rmAddObjectDefConstraint(silverIDT, avoidSocket);
    	rmAddObjectDefConstraint(silverIDT, avoidCoin);
  	rmAddObjectDefConstraint(silverIDT, stayGrass);
	rmPlaceObjectDefAtLoc(silverIDT, 0, 0.5, 0.5);
      }
}
//   ******************************************** forests ************************************X marks the spot

   int failCont=0;

	int northforestcount = cNumberNonGaiaPlayers*14; // 6
	int stayInNorthForest = -1;
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land like Arkansas", "Land", false, 3.0);

	for (i=0; < northforestcount)
	{
		int YellowForest = rmCreateArea("north forest"+i);
		rmSetAreaWarnFailure(YellowForest, false);
		rmSetAreaSize(YellowForest, rmAreaTilesToFraction(80), rmAreaTilesToFraction(120));
		rmSetAreaMinBlobs(YellowForest, 1);
		rmSetAreaMaxBlobs(YellowForest, 4);
		rmSetAreaMinBlobDistance(YellowForest, 14.0);
		rmSetAreaMaxBlobDistance(YellowForest, 30.0);
		rmSetAreaCoherence(YellowForest, 0.4);
		rmSetAreaSmoothDistance(YellowForest, 5);
		rmAddAreaToClass(YellowForest, rmClassID("classForest"));
         rmAddAreaConstraint(YellowForest, forestConstraint);
         rmAddAreaConstraint(YellowForest, avoidAll);
		 rmAddAreaConstraint(YellowForest, avoidCoinShort);
		 rmAddAreaConstraint(YellowForest, avoidCliffshort);
         rmAddAreaConstraint(YellowForest, shortAvoidImpassableLand);
         rmAddAreaConstraint(YellowForest, avoidTradeRouteSmall);
         rmAddAreaConstraint(YellowForest, avoidTownCenterFar1);
		 rmAddAreaConstraint(YellowForest, stayMiddleEdge1);
		 rmBuildArea(YellowForest);

		stayInNorthForest = rmCreateAreaMaxDistanceConstraint("stay in north forest"+i, YellowForest, 0);

		for (j=0; < rmRandInt(4,5)) //18,20
		{
			int northtreeID = rmCreateObjectDef("north tree"+i+j);
			rmAddObjectDefItem(northtreeID, "TreeNorthwestTerritory", rmRandInt(1,2), 4.0); // 1,2
      			rmAddObjectDefItem(northtreeID, "UnderbrushRockies", rmRandInt(1,1), 4.0);
			rmSetObjectDefMinDistance(northtreeID, 0);
			rmSetObjectDefMaxDistance(northtreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(northtreeID, rmClassID("classForest"));
			rmAddObjectDefConstraint(northtreeID, stayInNorthForest);
			rmAddObjectDefConstraint(northtreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(northtreeID, avoidCliffshort);
  			rmAddObjectDefConstraint(northtreeID, stayGrass);
			rmPlaceObjectDefAtLoc(northtreeID, 0, 0.50, 0.50);
		}
				for (j=0; < rmRandInt(4,5)) //18,20
		{
			int northtreeID1 = rmCreateObjectDef("north tree rockies"+i+j);
			rmAddObjectDefItem(northtreeID1, "TreeRockies", rmRandInt(1,2), 4.0); // 1,2
      			rmAddObjectDefItem(northtreeID1, "UnderbrushRockies", rmRandInt(1,1), 4.0);
			rmSetObjectDefMinDistance(northtreeID1, 0);
			rmSetObjectDefMaxDistance(northtreeID1, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(northtreeID1, rmClassID("classForest"));
			rmAddObjectDefConstraint(northtreeID1, stayInNorthForest);
			rmAddObjectDefConstraint(northtreeID1, avoidImpassableLandShort);
			rmAddObjectDefConstraint(northtreeID1, avoidCliffshort);
  			rmAddObjectDefConstraint(northtreeID1, stayGrass);
			rmPlaceObjectDefAtLoc(northtreeID1, 0, 0.50, 0.50);
		}
	}

//   ******************************************* hunts *****************************************X marks the spot

if (cNumberNonGaiaPlayers<=3)
{
	int ElkID1=rmCreateObjectDef("Elk herd");
	rmAddObjectDefItem(ElkID1, "Elk", rmRandInt(10,12), 7.0);
	rmSetObjectDefMinDistance(ElkID1, 0.0);
	rmSetObjectDefMaxDistance(ElkID1, 11);
    rmAddObjectDefConstraint(ElkID1, avoidAll);
    rmAddObjectDefConstraint(ElkID1, avoidCoinShort);
	rmAddObjectDefConstraint(ElkID1, avoidSocket);
	rmAddObjectDefConstraint(ElkID1, avoidCliffshort);
	rmAddObjectDefConstraint(ElkID1, stayMiddleEdge2);
  	rmAddObjectDefConstraint(ElkID1, stayGrass);
	rmSetObjectDefCreateHerd(ElkID1, true);

	int BighornSheepID1=rmCreateObjectDef("BighornSheep herd");
	rmAddObjectDefItem(BighornSheepID1, "BighornSheep", rmRandInt(10,12), 7.0);
	rmSetObjectDefMinDistance(BighornSheepID1, 0.0);
	rmSetObjectDefMaxDistance(BighornSheepID1, 11);
	rmAddObjectDefConstraint(BighornSheepID1, avoidAll);
	rmAddObjectDefConstraint(BighornSheepID1, avoidImpassableLand);
	rmAddObjectDefConstraint(BighornSheepID1, avoidSocket);
	rmAddObjectDefConstraint(BighornSheepID1, avoidCliffshort);
	rmAddObjectDefConstraint(BighornSheepID1, stayMiddleEdge2);
    rmAddObjectDefConstraint(BighornSheepID1, avoidCoinShort);
  	rmAddObjectDefConstraint(BighornSheepID1, stayGrass);
	rmSetObjectDefCreateHerd(BighornSheepID1, true);

	if (rmRandFloat(0.5,1)<0.5)
	{
	rmPlaceObjectDefAtLoc(BighornSheepID1, 0, 0.49, 0.88, 1); // behind cliffs
	rmPlaceObjectDefAtLoc(BighornSheepID1, 0, 0.51, 0.12, 1);

	rmPlaceObjectDefAtLoc(ElkID1, 0, 0.7, 0.43, 1); // in front of tc (second hunt)
	rmPlaceObjectDefAtLoc(ElkID1, 0, 0.3, 0.57, 1);

	rmPlaceObjectDefAtLoc(BighornSheepID1, 0, 0.75, 0.75, 1); // on the traderoute
	rmPlaceObjectDefAtLoc(BighornSheepID1, 0, 0.25, 0.25, 1);

	rmPlaceObjectDefAtLoc(ElkID1, 0, 0.9, 0.52, 1); // cliff sided edge
	rmPlaceObjectDefAtLoc(ElkID1, 0, 0.1, 0.48, 1);
	}
	else
	{
	rmPlaceObjectDefAtLoc(BighornSheepID1, 0, 0.37, 0.82, 1); // behind tc (second hunt)
	rmPlaceObjectDefAtLoc(BighornSheepID1, 0, 0.64, 0.19, 1);

	rmPlaceObjectDefAtLoc(ElkID1, 0, 0.14, 0.54, 1); // in front of tc, near to the edge a bit
	rmPlaceObjectDefAtLoc(ElkID1, 0, 0.86, 0.46, 1);

	rmPlaceObjectDefAtLoc(BighornSheepID1, 0, 0.75, 0.67, 1); // on the traderoute
	rmPlaceObjectDefAtLoc(BighornSheepID1, 0, 0.25, 0.33, 1);

	rmPlaceObjectDefAtLoc(ElkID1, 0, 0.65, 0.85, 1); // cliff sided top and bottom
	rmPlaceObjectDefAtLoc(ElkID1, 0, 0.35, 0.15, 1);
	}
	rmPlaceObjectDefAtLoc(BighornSheepID1, 0, 0.5, 0.5, 1);
}
else
{

for (i=0;<cNumberNonGaiaPlayers*2)
	{
	int ElkIDT=rmCreateObjectDef("Elk herd team"+i);
	rmAddObjectDefItem(ElkIDT, "Elk", rmRandInt(9,10), 7.0);
	rmSetObjectDefMinDistance(ElkIDT, 0.0);
	rmSetObjectDefMaxDistance(ElkIDT, rmZFractionToMeters(0.36));
    rmAddObjectDefConstraint(ElkIDT, avoidAll);
    rmAddObjectDefConstraint(ElkIDT, avoidImpassableLand);
    rmAddObjectDefConstraint(ElkIDT, avoidCoinShort);
	rmAddObjectDefConstraint(ElkIDT, avoidSocket);
	rmAddObjectDefConstraint(ElkIDT, avoidCliffs);
	rmAddObjectDefConstraint(ElkIDT, stayMiddleEdge2);
	rmAddObjectDefConstraint(ElkIDT, avoidElk);
	rmAddObjectDefConstraint(ElkIDT, avoidBighornSheep);
	rmAddObjectDefConstraint(ElkIDT, avoidTownCenterFar);
  	rmAddObjectDefConstraint(ElkIDT, stayGrass);
	rmSetObjectDefCreateHerd(ElkIDT, true);
	rmPlaceObjectDefAtLoc(ElkIDT, 0, 0.5, 0.5, 1);
	}

for (i=0;<cNumberNonGaiaPlayers*2)
	{
	int BighornSheepIDT=rmCreateObjectDef("BighornSheep herd team"+i);
	rmAddObjectDefItem(BighornSheepIDT, "BighornSheep", rmRandInt(10,12), 7.0);
	rmSetObjectDefMinDistance(BighornSheepIDT, 0.0);
	rmSetObjectDefMaxDistance(BighornSheepIDT, rmZFractionToMeters(0.36));
	rmAddObjectDefConstraint(BighornSheepIDT, avoidAll);
	rmAddObjectDefConstraint(BighornSheepIDT, avoidImpassableLand);
	rmAddObjectDefConstraint(BighornSheepIDT, avoidSocket);
	rmAddObjectDefConstraint(BighornSheepIDT, avoidCliffs);
    rmAddObjectDefConstraint(BighornSheepIDT, avoidCoinShort);
	rmAddObjectDefConstraint(BighornSheepIDT, stayMiddleEdge2);
	rmAddObjectDefConstraint(BighornSheepIDT, avoidTownCenterFar);
	rmAddObjectDefConstraint(BighornSheepIDT, avoidElk);
	rmAddObjectDefConstraint(BighornSheepIDT, avoidBighornSheep);
  	rmAddObjectDefConstraint(BighornSheepIDT, stayGrass);
	rmSetObjectDefCreateHerd(BighornSheepIDT, true);
	rmPlaceObjectDefAtLoc(BighornSheepIDT, 0, 0.5, 0.5, 1);
	}

}

// -------------------------------------------------- Treasure time ---------------------------------------------------

   	int nuggetID1= rmCreateObjectDef("nugget1");
	rmAddObjectDefItem(nuggetID1, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID1, 0.0);
	rmSetObjectDefMaxDistance(nuggetID1, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID1, avoidImpassableLand);
  	rmAddObjectDefConstraint(nuggetID1, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetID1, avoidSocket);
    	rmAddObjectDefConstraint(nuggetID1, avoidTownCenterFar2);
	rmAddObjectDefConstraint(nuggetID1, avoidCliffs);
	rmAddObjectDefConstraint(nuggetID1, stayMiddleEdge2);
	rmAddObjectDefConstraint(nuggetID1, avoidCoinShort);
  	rmAddObjectDefConstraint(nuggetID1, avoidAll);
  	rmAddObjectDefConstraint(nuggetID1, avoidNugget);
  	rmAddObjectDefConstraint(nuggetID1, stayGrass);
	rmSetNuggetDifficulty(2, 3);
	rmPlaceObjectDefAtLoc(nuggetID1, 0, 0.5, 0.5, cNumberNonGaiaPlayers*5);


   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .05, 0);
   }

// --------------------------------------------------------------- E N D ----------------------------------------------

	// Text
	rmSetStatusText("",1.0);


	}


