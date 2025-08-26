// Glacier
// a map for AOE3
// created by RF_Gandalf

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{
// Text
   rmSetStatusText("",0.01);

// Chooses which natives appear on the map
   int subCiv0=-1;
   subCiv0=rmGetCivID("Udasi");
   rmEchoInfo("subCiv0 is Udasi "+subCiv0);
   if (subCiv0 >= 0)
   	rmSetSubCiv(0, "Udasi");

// Picks the map size
	int playerTiles = 15000;
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=14000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=13000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=12000;

   int size=2*sqrt(cNumberNonGaiaPlayers*playerTiles);
   int longSide=1.5*size; 
   rmSetMapSize(longSide, size);

// Picks a default height
   rmSetSeaLevel(0.0);

// Picks default terrain and water
   rmSetMapElevationParameters(cElevTurbulence, 0.02, 3, 0.5, 8.0);
   rmSetMapElevationHeightBlend(1);

   rmSetBaseTerrainMix("rockies_snow");
   rmTerrainInitialize("rockies\groundsnow1_roc", 12);
   int lightChance = rmRandInt(1,3);
   rmSetLightingSet("yukon"); 
   rmSetMapType("himalayas");
   rmSetMapType("land");
   rmSetWorldCircleConstraint(true);
   rmSetMapType("snow");
   rmSetMapType("asia");
   rmSetGlobalSnow( 0.7 );
   chooseMercs();

// Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("nuggets");
   rmDefineClass("classIce");
   rmDefineClass("classMountain");
   rmDefineClass("socketClass");
   rmDefineClass("classCliff");
   rmDefineClass("classHuntable");

// Text
   rmSetStatusText("",0.05);

// -------------Define constraints
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(7), rmZTilesToFraction(7), 1.0-rmXTilesToFraction(7), 1.0-rmZTilesToFraction(7), 0.01);
   int silverEdgeConstraint=rmCreateBoxConstraint("silver edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
   int cliffEdgeConstraint=rmCreateBoxConstraint("cliff edge of map", rmXTilesToFraction(16), rmZTilesToFraction(16), 1.0-rmXTilesToFraction(16), 1.0-rmZTilesToFraction(16), 0.01);
   int forestEdgeConstraint=rmCreatePieConstraint("forest edge of map", 0.5, 0.5, 0, rmGetMapXSize()-30, 0, 0, 0);
   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 10.0);
   int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 25.0);
   int nuggetPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 60.0);
   int farPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players more", classPlayer, 85.0);
   int fartherPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players the most", classPlayer, 95.0);

   // Resource avoidance
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. things", rmClassID("classForest"), 8.0);
   int forestVsForestConstraint=rmCreateClassDistanceConstraint("forest vs. other forests", rmClassID("classForest"), 16.0);
   if (cNumberNonGaiaPlayers < 3)
   {
	forestVsForestConstraint=rmCreateClassDistanceConstraint("forest vs. other forests smaller", rmClassID("classForest"), 12.0);
   }
   int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 18.0);
   int avoidBighorn=rmCreateClassDistanceConstraint("avoid huntables", rmClassID("classHuntable"), 35.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("stuff avoids coin", "gold", 15.0);
   int coinAvoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 60.0);
   int avoidNuggets=rmCreateClassDistanceConstraint("stuff avoids nuggets", rmClassID("nuggets"), 30.0);
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int avoidIce = rmCreateClassDistanceConstraint("avoid ice", rmClassID("classIce"), 5.0);
   int avoidIceLarge = rmCreateClassDistanceConstraint("avoid ice by a lot", rmClassID("classIce"), 20.0);
   int avoidMts = rmCreateClassDistanceConstraint("avoid mountains", rmClassID("classMountain"), 25.0);
   int avoidCliffs=rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 12.0);
   int avoidCliff20=rmCreateClassDistanceConstraint("avoid cliffs 20", rmClassID("classCliff"), 20.0);
   int avoidCliff30=rmCreateClassDistanceConstraint("avoid cliffs 30", rmClassID("classCliff"), 30.0);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 15.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);

   // VP avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 4.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 10.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("important stuff avoids each other", rmClassID("importantItem"), 15.0);
   int avoidImportantItemSmall=rmCreateClassDistanceConstraint("important item small avoidance", rmClassID("importantItem"), 7.0);
   int avoidImportantItemForest=rmCreateClassDistanceConstraint("important stuff avoids each forest", rmClassID("importantItem"), 10.0);
   int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 8.0);

   // Cardinal Directions - "halves" of the map.
   int NWConstraint = rmCreateBoxConstraint("stay in NW portion", 0, 0.5, 1, 1);
   int SEConstraint = rmCreateBoxConstraint("stay in SE portion", 0, 0, 1, 0.5);
   int NEConstraint = rmCreateBoxConstraint("stay in NE portion", 0.5, 0, 1, 1);
   int SWConstraint = rmCreateBoxConstraint("stay in SW portion", 0, 0, 0.5, 1);

// end constraints ---------------------------------------------------------------------------------------------------

// Text
   rmSetStatusText("",0.10);

   int failCount = 0;
   int numTries = -1;
   int locationChance = rmRandInt(1,3);
   int threeChoice = rmRandInt(1,3);

// DEFINE AREAS
   // Build up edge cliffs
   int bigContinentID=rmCreateArea("big continent");
   rmSetAreaSize(bigContinentID, 0.99, 0.99); 
   rmSetAreaBaseHeight(bigContinentID, 10.0);
   rmSetAreaWarnFailure(bigContinentID, false);
   rmSetAreaHeightBlend(bigContinentID, 1.0);
   rmSetAreaSmoothDistance(bigContinentID, 1);
   rmSetAreaElevationType(bigContinentID, cElevTurbulence);
   rmSetAreaElevationVariation(bigContinentID, 3.0);
   rmSetAreaElevationMinFrequency(bigContinentID, 0.05);
   rmSetAreaElevationOctaves(bigContinentID, 3);
   rmSetAreaElevationPersistence(bigContinentID, 0.3);
   rmSetAreaElevationNoiseBias(bigContinentID, 0.5);
   rmSetAreaElevationEdgeFalloffDist(bigContinentID, 20.0);
   rmSetAreaMix(bigContinentID, "rockies_snow");
   rmSetAreaCoherence(bigContinentID, 0.9);
   rmSetAreaLocation(bigContinentID, 0.5, 0.5);
   rmSetAreaObeyWorldCircleConstraint(bigContinentID, false);
   rmBuildArea(bigContinentID);


   // Set up player starting locations.
   if ( cNumberTeams > 2 )
   {
	rmSetTeamSpacingModifier(0.75);
	rmSetPlacementSection(0.15, 0.85);
	rmPlacePlayersCircular(0.38, 0.38, 0);
   }
   else
   {
	rmSetPlacementTeam(0);
	if (cNumberNonGaiaPlayers == 2)
	{
	   rmSetPlacementSection(0.21, 0.26);
	   rmPlacePlayersCircular(0.38, 0.38, 0);
	}
	else if (cNumberNonGaiaPlayers < 5)
	{
	   rmSetPlacementSection(0.17, 0.33);
	   rmPlacePlayersCircular(0.38, 0.38, 0);
	}
	else if (cNumberNonGaiaPlayers < 7)
	{
	   rmSetPlacementSection(0.14, 0.36);
	   rmPlacePlayersCircular(0.37, 0.37, 0);
	}
	else
	{
	   rmSetPlacementSection(0.12, 0.38);	
	   rmPlacePlayersCircular(0.36, 0.36, 0);
	}
		
	rmSetPlacementTeam(1);
	if (cNumberNonGaiaPlayers == 2)
	{
	   rmSetPlacementSection(0.71, 0.76);
	   rmPlacePlayersCircular(0.38, 0.38, 0);
	}
	else if (cNumberNonGaiaPlayers < 5)
	{
	   rmSetPlacementSection(0.67, 0.83);
	   rmPlacePlayersCircular(0.38, 0.38, 0);
	}
	else if (cNumberNonGaiaPlayers < 7)
	{
	   rmSetPlacementSection(0.64, 0.86);
	   rmPlacePlayersCircular(0.37, 0.37, 0);
	}
	else
	{
	   rmSetPlacementSection(0.62, 0.88);
	   rmPlacePlayersCircular(0.36, 0.36, 0);
	}
   }

// Text
   rmSetStatusText("",0.15);

// Set up player areas.
   float playerFraction=rmAreaTilesToFraction(500);
   for(i=1; <cNumberPlayers)
   {
      int id=rmCreateArea("Player"+i);
      rmSetPlayerArea(i, id);
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaCoherence(id, 0.6);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmAddAreaConstraint(id, playerConstraint); 
      rmAddAreaConstraint(id, playerEdgeConstraint); 
	rmAddAreaConstraint(id, avoidTradeRoute); 
      rmSetAreaLocPlayer(id, i);
      rmSetAreaWarnFailure(id, false);
   }
 //  rmBuildAllAreas();

// Some objects defined for placement on land areas
   // Hard Nuggets
   int nugget4= rmCreateObjectDef("nugget nuts"); 
   rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(4, 4);
   rmAddObjectDefToClass(nugget4, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(nugget4, 0.0);
   rmSetObjectDefMaxDistance(nugget4, 10.0);
   rmAddObjectDefConstraint(nugget4, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget4, avoidNuggets);
   rmAddObjectDefConstraint(nugget4, avoidAll);

   // Gold mines
   int silverType = rmRandInt(1,10);
   int GoldFarID=rmCreateObjectDef("player silver far");
   rmAddObjectDefItem(GoldFarID, "minegold", 1, 0);
   rmAddObjectDefConstraint(GoldFarID, avoidAll);
   rmAddObjectDefConstraint(GoldFarID, avoidCoin);
   rmSetObjectDefMinDistance(GoldFarID, 0.0);
   rmSetObjectDefMaxDistance(GoldFarID, 10.0);

   // Trees
   int StragglerTreeID=rmCreateObjectDef("straggler trees");
   rmAddObjectDefItem(StragglerTreeID, "TreeRockiesSnow", 1, 0.0);
   rmAddObjectDefConstraint(StragglerTreeID, avoidAll);
   rmAddObjectDefConstraint(StragglerTreeID, avoidStartingUnitsSmall);
   rmSetObjectDefMinDistance(StragglerTreeID, 0);
   rmSetObjectDefMaxDistance(StragglerTreeID, 30);

// Glacier
   int icePatchID=rmCreateArea("center glacier");   
   rmSetAreaMix(icePatchID, "great_lakes_ice");
   rmSetAreaBaseHeight(icePatchID, 10.0);
   rmSetAreaTerrainType(icePatchID, "great_lakes\ground_ice1_gl");
   if (cNumberTeams > 2) 
   {
      rmSetAreaLocation(icePatchID, 0.5, 0.7); 
      rmSetAreaSize(icePatchID, 0.24, 0.24);
      rmAddAreaInfluenceSegment(icePatchID, 0.5, 1.2, 0.5, 0.4);
   }
   else
   {
      rmSetAreaLocation(icePatchID, 0.5, 0.5); 
      rmSetAreaSize(icePatchID, 0.3, 0.31);
      rmAddAreaInfluenceSegment(icePatchID, 0.5, 1.2, 0.5, -0.2);
   }
   rmSetAreaWarnFailure(icePatchID, false);
   rmSetAreaSmoothDistance(icePatchID, 15);
   rmSetAreaCliffType(icePatchID, "rocky mountain edge");
   if (rmRandInt(1,2) == 1)
      rmSetAreaCliffEdge(icePatchID, 7, 0.12, 0.09, 0.4, 0);
   else
      rmSetAreaCliffEdge(icePatchID, 8, 0.11, 0.08, 0.3, 0);
   rmSetAreaCliffHeight(icePatchID, -8, 1.0, 0.3);
   rmSetAreaCoherence(icePatchID, 0.8);
   rmSetAreaHeightBlend(icePatchID, 0.8);
   rmSetAreaCliffPainting(icePatchID, true, true, true, 1.5, true);
   rmAddAreaToClass(icePatchID, rmClassID("classIce"));
   rmSetAreaObeyWorldCircleConstraint(icePatchID, false);
   rmBuildArea(icePatchID);

// Text
   rmSetStatusText("",0.20);

// Mountain tops for resources
   playerFraction = rmAreaTilesToFraction(900);
   int mountAID=rmCreateArea("mount A");
   rmSetAreaSize(mountAID, 0.8*playerFraction, 1.1*playerFraction);
   if (cNumberTeams > 2)
      rmSetAreaLocation(mountAID, 0.5, 0.42);
   else 
   { 
      if (locationChance == 1)
         rmSetAreaLocation(mountAID, 0.5, 0.22);
      else if (locationChance == 2)
         rmSetAreaLocation(mountAID, 0.5, 0.29);
      else if (locationChance == 3)
         rmSetAreaLocation(mountAID, 0.5, 0.16);
   }
   rmAddAreaToClass(mountAID, rmClassID("classMountain"));
   rmSetAreaMinBlobs(mountAID, 2);
   rmSetAreaMaxBlobs(mountAID, 3);
   rmSetAreaMinBlobDistance(mountAID, 15.0);
   rmSetAreaMaxBlobDistance(mountAID, 25.0);
   rmSetAreaCoherence(mountAID, 0.8);
   rmSetAreaCliffType(mountAID, "rocky mountain edge");
   rmSetAreaCliffEdge(mountAID, 3, 0.29, 0.2, 1.0, 1);
   rmSetAreaCliffPainting(mountAID, true, true, true, 1.5, true);
   rmSetAreaTerrainType(mountAID, "great_lakes\groundforestsnow_gl");
   rmSetAreaCliffHeight(mountAID, rmRandInt(6,8), 1.0, 0.5);
   rmSetAreaHeightBlend(mountAID, 1);
   rmSetAreaSmoothDistance(mountAID, 20);
   rmBuildArea(mountAID);


   rmPlaceObjectDefInArea(GoldFarID, 0, mountAID, 2);
   rmPlaceObjectDefInArea(nugget4, 0, mountAID, 1);
   rmPlaceObjectDefInArea(StragglerTreeID, 0, mountAID, 6);


   int mountBID=rmCreateArea("mount B");
   rmSetAreaSize(mountBID, 0.9*playerFraction, 1.1*playerFraction);
   if (cNumberTeams > 2)
      rmSetAreaLocation(mountBID, 0.5, 0.8);
   else 
   {
      if (locationChance == 1)
         rmSetAreaLocation(mountBID, 0.5, 0.78);
      else if (locationChance == 2)
         rmSetAreaLocation(mountBID, 0.5, 0.71);
      else if (locationChance == 3)
         rmSetAreaLocation(mountBID, 0.5, 0.84);
   }
   rmAddAreaToClass(mountBID, rmClassID("classMountain"));
   rmSetAreaMinBlobs(mountBID, 2);
   rmSetAreaMaxBlobs(mountBID, 3);
   rmSetAreaMinBlobDistance(mountBID, 15.0);
   rmSetAreaMaxBlobDistance(mountBID, 25.0);
   rmSetAreaCoherence(mountBID, 0.8);
   rmSetAreaCliffType(mountBID, "rocky mountain edge");
   rmSetAreaCliffEdge(mountBID, 3, 0.27, 0.15, 1.0, 1);
   rmSetAreaCliffPainting(mountBID, true, true, true, 1.5, true);
   rmSetAreaTerrainType(mountBID, "great_lakes\groundforestsnow_gl");
   rmSetAreaCliffHeight(mountBID, rmRandInt(6,8), 1.0, 0.5);
   rmSetAreaHeightBlend(mountBID, 1);
   rmSetAreaSmoothDistance(mountBID, 20);
   rmBuildArea(mountBID);


   rmPlaceObjectDefInArea(GoldFarID, 0, mountBID, 2);
   rmPlaceObjectDefInArea(nugget4, 0, mountBID, 1);
   rmPlaceObjectDefInArea(StragglerTreeID, 0, mountBID, 6);

// Text
   rmSetStatusText("",0.25);

// Additional 'mountain tops' 
   if (cNumberNonGaiaPlayers < 4)
	numTries = 2;
   else if (cNumberNonGaiaPlayers > 6)
	numTries = 6; 
   else
	numTries = cNumberNonGaiaPlayers - 1;
   for(i=0; <numTries)
   { 
	threeChoice = rmRandInt(1,3);
      int smallLandID=rmCreateArea("small land"+i, rmAreaID("center glacier"));
      rmAddAreaToClass(smallLandID, rmClassID("classMountain"));
      rmSetAreaWarnFailure(smallLandID, false);
      rmSetAreaSize(smallLandID, rmAreaTilesToFraction(450), rmAreaTilesToFraction(700));
      rmSetAreaCliffType(smallLandID, "rocky mountain edge");
      rmAddAreaConstraint(smallLandID, avoidMts);
      rmAddAreaConstraint(smallLandID, avoidImpassableLand);
      rmAddAreaConstraint(smallLandID, silverEdgeConstraint); 
      rmSetAreaMinBlobs(smallLandID, 1);
      rmSetAreaMaxBlobs(smallLandID, 2);
      rmSetAreaMinBlobDistance(smallLandID, 15.0);
      rmSetAreaMaxBlobDistance(smallLandID, 20.0);
      if (threeChoice == 1)
        rmSetAreaCliffEdge(smallLandID, 1, 0.9, 0.1, 1.0, 0);
	else if (threeChoice == 2) 
        rmSetAreaCliffEdge(smallLandID, 2, 0.43, 0.1, 1.0, 0);
	else
        rmSetAreaCliffEdge(smallLandID, 3, 0.29, 0.1, 1.0, 0);
      rmSetAreaCliffPainting(smallLandID, true, true, true, 1.5, true);
      rmSetAreaTerrainType(smallLandID, "great_lakes\groundforestsnow_gl");
      rmSetAreaCliffHeight(smallLandID, rmRandInt(6,8), 1.0, 1.0);
      rmSetAreaCoherence(smallLandID, 0.75);
      rmSetAreaSmoothDistance(smallLandID, 15);
      rmSetAreaHeightBlend(smallLandID, 1);
      rmBuildArea(smallLandID);

      rmPlaceObjectDefInArea(GoldFarID, 0, rmAreaID("small land"+i), 1);
      rmPlaceObjectDefInArea(StragglerTreeID, 0, rmAreaID("small land"+i), 4);
   }  

// Text
   rmSetStatusText("",0.30);

// Trade Routes - one per side
   int tradeRouteID6 = rmCreateTradeRoute();
   rmAddTradeRouteWaypoint(tradeRouteID6, 0.83, 1.0);
   rmAddTradeRouteWaypoint(tradeRouteID6, 0.85, 0.87);
   rmAddTradeRouteWaypoint(tradeRouteID6, 0.89, 0.75);
   rmAddTradeRouteWaypoint(tradeRouteID6, 0.92, 0.5);
   rmAddTradeRouteWaypoint(tradeRouteID6, 0.89, 0.25);
   rmAddTradeRouteWaypoint(tradeRouteID6, 0.86, 0.13);
   rmAddTradeRouteWaypoint(tradeRouteID6, 0.83, 0.0);
   rmBuildTradeRoute(tradeRouteID6, "carolinas\trade_route");	

   int tradeRouteID6A = rmCreateTradeRoute();
   rmAddTradeRouteWaypoint(tradeRouteID6A, 0.17, 0.0);
   rmAddTradeRouteWaypoint(tradeRouteID6A, 0.15, 0.13);
   rmAddTradeRouteWaypoint(tradeRouteID6A, 0.11, 0.25);
   rmAddTradeRouteWaypoint(tradeRouteID6A, 0.08, 0.5);
   rmAddTradeRouteWaypoint(tradeRouteID6A, 0.11, 0.75);
   rmAddTradeRouteWaypoint(tradeRouteID6A, 0.15, 0.87);
   rmAddTradeRouteWaypoint(tradeRouteID6A, 0.17, 1.0);
   rmBuildTradeRoute(tradeRouteID6A, "dirt");

// Text
   rmSetStatusText("",0.35);

// Sockets for the trade routes
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 7.0);
   int socketPattern = rmRandInt(1,2);

   // first route
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID6);
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.17);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   if (socketPattern == 1)
   {
	if (cNumberNonGaiaPlayers < 4)
	{ 
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.5);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else
	{ 
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.38);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.62);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }
   
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.83);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // second route
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID6A);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6A, 0.83);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   if (socketPattern == 1)
   {
	if (cNumberNonGaiaPlayers < 4)
	{ 
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6A, 0.5);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else
	{ 
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6A, 0.38);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6A, 0.62);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6A, 0.17);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

// Text
   rmSetStatusText("",0.40);

// NATIVES
   int VillageAID = -1;
   int VillageType = rmRandInt(1,5);
   VillageAID = rmCreateGrouping("Udasi village A", "native udasi village himal "+VillageType);
   rmSetGroupingMinDistance(VillageAID, 0.0);
   rmSetGroupingMaxDistance(VillageAID, 15.0);
   rmAddGroupingConstraint(VillageAID, avoidImpassableLand);
   rmAddGroupingToClass(VillageAID, rmClassID("importantItem"));
   rmAddGroupingConstraint(VillageAID, avoidSocket);
   rmAddGroupingConstraint(VillageAID, avoidTradeRoute);
   rmAddGroupingConstraint(VillageAID, avoidIce);

   int VillageBID = -1;
   VillageType = rmRandInt(1,5);
   VillageBID = rmCreateGrouping("Udasi village B", "native udasi village himal "+VillageType);
   rmSetGroupingMinDistance(VillageBID, 0.0);
   rmSetGroupingMaxDistance(VillageBID, 15.0);
   rmAddGroupingConstraint(VillageBID, avoidImpassableLand);
   rmAddGroupingToClass(VillageBID, rmClassID("importantItem"));
   rmAddGroupingConstraint(VillageBID, avoidSocket);
   rmAddGroupingConstraint(VillageBID, avoidTradeRoute);
   rmAddGroupingConstraint(VillageBID, avoidIce);

// Text
   rmSetStatusText("",0.45);

   if (cNumberNonGaiaPlayers < 4)
   {
      if (rmRandInt(1,2) == 1)
      {
         rmPlaceGroupingAtLoc(VillageBID, 0, 0.235, 0.91);
         rmPlaceGroupingAtLoc(VillageAID, 0, 0.765, 0.09);
      }
      else
      {
         rmPlaceGroupingAtLoc(VillageAID, 0, 0.235, 0.09);
         rmPlaceGroupingAtLoc(VillageBID, 0, 0.765, 0.91);
	}
   }
   else
   {
      rmPlaceGroupingAtLoc(VillageBID, 0, 0.235, 0.91);
      rmPlaceGroupingAtLoc(VillageAID, 0, 0.235, 0.09);
      rmPlaceGroupingAtLoc(VillageBID, 0, 0.765, 0.09);
      rmPlaceGroupingAtLoc(VillageAID, 0, 0.765, 0.91);
   }

// Text
   rmSetStatusText("",0.50);

//STARTING UNITS
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
   rmAddObjectDefConstraint(startingTCID, avoidTradeRoute);
   rmSetObjectDefMinDistance(startingTCID, 0.0);
   rmSetObjectDefMaxDistance(startingTCID, 16.0);

   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 5.0);
   rmSetObjectDefMaxDistance(startingUnits, 8.0);
   rmAddObjectDefConstraint(startingUnits, avoidStartingUnitsSmall);
	
   int StartAreaTreeID=rmCreateObjectDef("starting trees");
   rmAddObjectDefItem(StartAreaTreeID, "TreeRockiesSnow", 1, 0.0);
   rmSetObjectDefMinDistance(StartAreaTreeID, 12.0);
   rmSetObjectDefMaxDistance(StartAreaTreeID, 20.0);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);

   int StartBighornID=rmCreateObjectDef("starting bighorn");
   rmAddObjectDefItem(StartBighornID, "ypMarcoPoloSheep", 5, 4.0);
   rmAddObjectDefToClass(StartBighornID, rmClassID("classHuntable"));
   rmSetObjectDefMinDistance(StartBighornID, 10.0);
   rmSetObjectDefMaxDistance(StartBighornID, 13.0);
   rmSetObjectDefCreateHerd(StartBighornID, false);
   rmAddObjectDefConstraint(StartBighornID, avoidStartingUnitsSmall);

   int playerNuggetID=rmCreateObjectDef("player nugget");
   rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
   rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
   rmAddObjectDefToClass(playerNuggetID, rmClassID("startingUnit"));
   rmSetObjectDefMinDistance(playerNuggetID, 30.0);
   rmSetObjectDefMaxDistance(playerNuggetID, 35.0);
   rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerNuggetID, avoidNuggets);
   rmAddObjectDefConstraint(playerNuggetID, forestEdgeConstraint);	
   rmAddObjectDefConstraint(playerNuggetID, circleConstraint);

   int playerGoldID=rmCreateObjectDef("player silver ore");
   silverType = rmRandInt(1,10);
   for(i=1; <cNumberPlayers)
   {
	rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

	// Everyone gets two ore groupings, one pretty close, the other a little further away.
	silverType = rmRandInt(1,10);
	playerGoldID = rmCreateObjectDef("player silver closer "+i);
	rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
	rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
	rmSetObjectDefMinDistance(playerGoldID, 15.0);
	rmSetObjectDefMaxDistance(playerGoldID, 20.0);

	rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	// Placing starting Pronghorns...
	rmPlaceObjectDefAtLoc(StartBighornID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	// Placing starting trees...
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

	// Nuggets
	rmSetNuggetDifficulty(1, 1);
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

   }

// Text
   rmSetStatusText("",0.55); 

// Cliffs
   int numCliffs = cNumberNonGaiaPlayers + rmRandInt(4,7);
   int cliffHt = 0;
   for (i=0; <numCliffs)
   {
	threeChoice = rmRandInt(1,3);
      cliffHt = rmRandInt(5,6);    
	int bigCliffID=rmCreateArea("big cliff" +i);
	rmSetAreaWarnFailure(bigCliffID, false);
	rmSetAreaCliffType(bigCliffID, "rocky mountain edge");
	rmAddAreaToClass(bigCliffID, rmClassID("classCliff"));
      rmSetAreaSize(bigCliffID, rmAreaTilesToFraction(280), rmAreaTilesToFraction(400));
	if (threeChoice == 1)
         rmSetAreaCliffEdge(bigCliffID, 1, 0.55, 0.1, 1.0, 0);
	else if (threeChoice == 2)
         rmSetAreaCliffEdge(bigCliffID, 1, 0.8, 0.1, 1.0, 0);
	else
         rmSetAreaCliffEdge(bigCliffID, 2, 0.41, 0.08, 1.0, 0);
      rmSetAreaCliffPainting(bigCliffID, true, true, true, 1.5, true);
      rmSetAreaCliffHeight(bigCliffID, cliffHt, 1.0, 1.0);
	rmSetAreaCoherence(bigCliffID, rmRandFloat(0.5, 0.9));
	rmSetAreaSmoothDistance(bigCliffID, 10);
	rmSetAreaHeightBlend(bigCliffID, 2.0);
	rmSetAreaMinBlobs(bigCliffID, 1);
	rmSetAreaMaxBlobs(bigCliffID, 3);
	rmSetAreaMinBlobDistance(bigCliffID, 8);
	rmSetAreaMaxBlobDistance(bigCliffID, 15);
	rmAddAreaConstraint(bigCliffID, avoidImportantItem);
	rmAddAreaConstraint(bigCliffID, avoidTradeRouteFar);
	rmAddAreaConstraint(bigCliffID, avoidCliff30);
	rmAddAreaConstraint(bigCliffID, avoidSocket);
	rmAddAreaConstraint(bigCliffID, avoidIce);
	rmAddAreaConstraint(bigCliffID, avoidCoin);
	rmAddAreaConstraint(bigCliffID, avoidStartingUnits);
	rmAddAreaConstraint(bigCliffID, nuggetPlayerConstraint);
	rmBuildArea(bigCliffID);
   }

// Text
   rmSetStatusText("",0.60);

// Define and place forests - west and east
   numTries=3*cNumberNonGaiaPlayers;  
   failCount=0;
   for (i=0; <numTries)
   {   
	int westForest=rmCreateArea("westForest"+i);
	rmSetAreaWarnFailure(westForest, false);
	rmAddAreaToClass(westForest, rmClassID("classForest"));
	rmSetAreaSize(westForest, rmAreaTilesToFraction(165), rmAreaTilesToFraction(210));
	rmSetAreaForestType(westForest, "rockies snow forest");
	rmSetAreaForestDensity(westForest, 0.9);
	rmSetAreaForestClumpiness(westForest, 0.3);					
	rmSetAreaForestUnderbrush(westForest, 0.0);
	rmSetAreaCoherence(westForest, 0.3);
	rmSetAreaSmoothDistance(westForest, 10);
	rmSetAreaObeyWorldCircleConstraint(westForest, false);
	rmAddAreaConstraint(westForest, avoidImportantItemForest);		
	rmAddAreaConstraint(westForest, playerConstraintForest);	
	rmAddAreaConstraint(westForest, forestVsForestConstraint);			
	rmAddAreaConstraint(westForest, SWConstraint);				
	rmAddAreaConstraint(westForest, avoidTradeRoute);
	rmAddAreaConstraint(westForest, avoidIce);
	rmAddAreaConstraint(westForest, avoidSocket);
	rmAddAreaConstraint(westForest, avoidCoin);
	//rmAddAreaConstraint(westForest, forestEdgeConstraint);
	rmAddAreaConstraint(westForest, avoidStartingUnits);
	if(rmBuildArea(westForest)==false)
	{
		// Stop trying once we fail 5 times in a row.
		failCount++;
		if(failCount==5)
			break;
	}
	else
		failCount=0; 
   }

// Text
   rmSetStatusText("",0.65);

   numTries=3*cNumberNonGaiaPlayers;  
   failCount=0;
   for (i=0; <numTries)
   {   
	int eastForest=rmCreateArea("eastForest"+i);
	rmSetAreaWarnFailure(eastForest, false);
	rmAddAreaToClass(eastForest, rmClassID("classForest"));
      rmSetAreaSize(eastForest, rmAreaTilesToFraction(165), rmAreaTilesToFraction(210));
	rmSetAreaForestType(eastForest, "rockies snow forest");
	rmSetAreaForestDensity(eastForest, 0.9);
	rmSetAreaForestClumpiness(eastForest, 0.3);					
	rmSetAreaForestUnderbrush(eastForest, 0.0);
	rmSetAreaCoherence(eastForest, 0.3);
	rmSetAreaSmoothDistance(eastForest, 10);
	rmSetAreaObeyWorldCircleConstraint(eastForest, false);
	rmAddAreaConstraint(eastForest, avoidImportantItemForest);	
	rmAddAreaConstraint(eastForest, playerConstraintForest);		
	rmAddAreaConstraint(eastForest, forestVsForestConstraint);		
	rmAddAreaConstraint(eastForest, NEConstraint);	
	rmAddAreaConstraint(eastForest, avoidTradeRoute);
	rmAddAreaConstraint(eastForest, avoidIce);
	rmAddAreaConstraint(eastForest, avoidSocket);
	rmAddAreaConstraint(eastForest, avoidCoin);
	//rmAddAreaConstraint(eastForest, forestEdgeConstraint);
	rmAddAreaConstraint(eastForest, avoidStartingUnits);
	if(rmBuildArea(eastForest)==false)
	{
		// Stop trying once we fail 5 times in a row.
		failCount++;
		if(failCount==5)
			break;
	}
	else
		failCount=0;
   } 

// Text
   rmSetStatusText("",0.70);

// Huntables - two groups on each side per player

   int bighorn1ID=rmCreateObjectDef("bighorn herd 1");
   rmAddObjectDefItem(bighorn1ID, "ypMarcoPoloSheep", rmRandInt(6,8), 10.0);
   rmAddObjectDefToClass(bighorn1ID, rmClassID("classHuntable"));
   rmSetObjectDefMinDistance(bighorn1ID, 40);
   rmSetObjectDefMaxDistance(bighorn1ID, size*0.35);
   rmAddObjectDefConstraint(bighorn1ID, avoidBighorn);
   rmAddObjectDefConstraint(bighorn1ID, avoidImpassableLand);
   rmAddObjectDefConstraint(bighorn1ID, avoidTradeRoute);
   rmAddObjectDefConstraint(bighorn1ID, avoidSocket);
   rmAddObjectDefConstraint(bighorn1ID, forestConstraint);
   rmAddObjectDefConstraint(bighorn1ID, avoidIce);
   rmAddObjectDefConstraint(bighorn1ID, avoidCoin);
   rmAddObjectDefConstraint(bighorn1ID, avoidStartingUnits);
   rmAddObjectDefConstraint(bighorn1ID, silverEdgeConstraint);
   rmSetObjectDefCreateHerd(bighorn1ID, true);
   rmPlaceObjectDefPerPlayer(bighorn1ID, false, 1);

   int bighorn2ID=rmCreateObjectDef("bighorn herd 2");
   rmAddObjectDefItem(bighorn2ID, "ypMarcoPoloSheep", rmRandInt(6,8), 10.0);
   rmAddObjectDefToClass(bighorn2ID, rmClassID("classHuntable"));
   rmSetObjectDefMinDistance(bighorn2ID, 65);
   rmSetObjectDefMaxDistance(bighorn2ID, size*0.5);
   rmAddObjectDefConstraint(bighorn2ID, avoidBighorn);
   rmAddObjectDefConstraint(bighorn2ID, avoidImpassableLand);
   rmAddObjectDefConstraint(bighorn2ID, avoidTradeRoute);
   rmAddObjectDefConstraint(bighorn2ID, avoidSocket);
   rmAddObjectDefConstraint(bighorn2ID, forestConstraint);
   rmAddObjectDefConstraint(bighorn2ID, avoidIce);
   rmAddObjectDefConstraint(bighorn2ID, avoidCoin);
   rmAddObjectDefConstraint(bighorn2ID, avoidStartingUnits);
   rmAddObjectDefConstraint(bighorn2ID, silverEdgeConstraint);
   rmSetObjectDefCreateHerd(bighorn2ID, true);
   rmPlaceObjectDefPerPlayer(bighorn2ID, false, 1);

// Text
   rmSetStatusText("",0.75);

// Random Nuggets
   int nugget2= rmCreateObjectDef("nugget medium"); 
   rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(2, 2);
   rmAddObjectDefToClass(nugget2, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(nugget2, 60.0);
   rmSetObjectDefMaxDistance(nugget2, 110.0);
   rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget2, avoidSocket);
   rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget2, nuggetPlayerConstraint);
   rmAddObjectDefConstraint(nugget2, avoidNuggets);
   rmAddObjectDefConstraint(nugget2, silverEdgeConstraint);
   //rmAddObjectDefConstraint(nugget2, circleConstraint);
   rmAddObjectDefConstraint(nugget2, avoidAll);
   rmAddObjectDefConstraint(nugget2, avoidIce);
   rmPlaceObjectDefPerPlayer(nugget2, false, 1);

   int nugget3= rmCreateObjectDef("nugget hard"); 
   rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(3, 3);
   rmAddObjectDefToClass(nugget3, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(nugget3, 80.0);
   rmSetObjectDefMaxDistance(nugget3, size*0.55);
   rmAddObjectDefConstraint(nugget3, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget3, avoidSocket);
   rmAddObjectDefConstraint(nugget3, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget3, farPlayerConstraint);
   rmAddObjectDefConstraint(nugget3, avoidNuggets);
   rmAddObjectDefConstraint(nugget3, silverEdgeConstraint);
   //rmAddObjectDefConstraint(nugget3, circleConstraint);
   rmAddObjectDefConstraint(nugget3, avoidAll);
   rmAddObjectDefConstraint(nugget3, avoidIce);
   rmPlaceObjectDefPerPlayer(nugget3, false, 1);

// Text
   rmSetStatusText("",0.80);

// Lone elk
   int loneElkID=rmCreateObjectDef("lone elk");
   rmAddObjectDefItem(loneElkID, "ypMarcoPoloSheep", rmRandInt(1,2), 3.0);
   rmSetObjectDefMinDistance(loneElkID, 80);
   rmSetObjectDefMaxDistance(loneElkID, 120);
   rmAddObjectDefConstraint(loneElkID, farPlayerConstraint);
   rmAddObjectDefConstraint(loneElkID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(loneElkID, silverEdgeConstraint);
   rmAddObjectDefConstraint(loneElkID, avoidBighorn);
   rmAddObjectDefConstraint(loneElkID, avoidAll);
   rmAddObjectDefConstraint(loneElkID, avoidIce);
   rmSetObjectDefCreateHerd(loneElkID, true);
   rmPlaceObjectDefPerPlayer(loneElkID, false, 2);

// Text
   rmSetStatusText("",0.85);

// Extra tree clumps near players - to ensure fair access to wood
   int extraTreesID=rmCreateObjectDef("extra trees");
   rmAddObjectDefItem(extraTreesID, "TreeRockiesSnow", 4, 5.0);  
   rmSetObjectDefMinDistance(extraTreesID, 14);
   rmSetObjectDefMaxDistance(extraTreesID, 19);
   rmAddObjectDefConstraint(extraTreesID, avoidAll);
   rmAddObjectDefConstraint(extraTreesID, avoidCoin);
   rmAddObjectDefConstraint(extraTreesID, avoidSocket);
   rmAddObjectDefConstraint(extraTreesID, avoidTradeRoute);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTreesID, 0, rmAreaID("Player"+i), 2);

// Text
   rmSetStatusText("",0.90);

// Random trees
   rmAddObjectDefConstraint(StragglerTreeID, avoidIce);
   rmSetObjectDefMinDistance(StragglerTreeID, 10.0);
   rmSetObjectDefMaxDistance(StragglerTreeID, size);
   for(i=0; <cNumberNonGaiaPlayers*18)
      rmPlaceObjectDefAtLoc(StragglerTreeID, 0, 0.5, 0.5);

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.07;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }

// Text
   rmSetStatusText("",1.0);
}