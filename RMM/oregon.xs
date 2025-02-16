// Canyonlands
// A random map for AOE3
// by RF_Gandalf

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
   // Text
   rmSetStatusText("",0.01);

// **************** CHOOSE NATIVES ****************

   int subCiv0=-1;
   int subCiv1=-1;

   if (rmAllocateSubCivs(2) == true)
   {
		subCiv0=rmGetCivID("Apache");
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Apache");
		
		subCiv1=rmGetCivID("Navajo");
      if (subCiv1 >= 0)
         rmSetSubCiv(1, "Navajo");
   }

// ***************** MAP PARAMETERS ***************
   // Picks the map size
   int playerTiles = 15500;
   if (cNumberNonGaiaPlayers >4)
      playerTiles = 14000;
   if (cNumberNonGaiaPlayers >6)
      playerTiles = 13000;
		
/*
   if(cMapSize == 1)
   {
      playerTiles = 18000;
      rmEchoInfo("Large map");
   }
*/
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	rmSetMapElevationParameters(cElevTurbulence, 0.02, 4, 0.7, 8.0);
	rmSetMapElevationHeightBlend(1);

	// Picks a default water height
	rmSetSeaLevel(4.0);

      // Picks default terrain and water
	rmSetSeaType("Amazon River");
	rmSetBaseTerrainMix("sonora_dirt");
	rmTerrainInitialize("sonora\ground2_son", 4.0);
	rmSetMapType("sonora");
	rmSetMapType("grass");
	rmSetMapType("land");
	rmSetMapType("namerica");
	rmSetLightingSet("pampas");

	// Choose mercs.
	chooseMercs();

	// Corner constraint.
	rmSetWorldCircleConstraint(false);

   // Text
   rmSetStatusText("",0.05);

// **************** DEFINITIONS ******************

	// define classes
	int classPlayer=rmDefineClass("player");
	rmDefineClass("classHill");
	rmDefineClass("classPatch");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("natives");
	rmDefineClass("classCliff");
	rmDefineClass("classNugget");
	rmDefineClass("center");
	int canyon=rmDefineClass("canyon");
      int connectionClass=rmDefineClass("connection");
	int teamClass=rmDefineClass("teamClass"); 

	// define constraints
	int socketAvoidSocket=rmCreateTypeDistanceConstraint("socket avoid socket", "Socket", 30.0);
	int avoidVultures=rmCreateTypeDistanceConstraint("avoids Vultures", "PropVulturePerching", 40.0);
	int canyonConstraint=rmCreateClassDistanceConstraint("canyons start away from each other", canyon, 5.0);
	int avoidCanyons=rmCreateClassDistanceConstraint("avoid canyons", rmClassID("canyon"), 35.0);
	int shortAvoidCanyons=rmCreateClassDistanceConstraint("short avoid canyons", rmClassID("canyon"), 15.0);
	int avoidNatives=rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 15.0);
	int avoidSilver=rmCreateTypeDistanceConstraint("gold avoid gold", "Mine", 45.0);
	int shortAvoidSilver=rmCreateTypeDistanceConstraint("short gold avoid gold", "Mine", 20.0);
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 10.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 4.0);
      int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("forests avoid impassable land", "land", false, 18.0);
	int centerConstraintFar=rmCreateClassDistanceConstraint("stay away from center far", rmClassID("center"), rmXFractionToMeters(0.23));
	int centerConstraint=rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), rmXFractionToMeters(0.10));
	int keepToEdge=rmCreateClassDistanceConstraint("stay near edge of map", rmClassID("center"), rmXFractionToMeters(0.49));
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 50.0);
	int shortForestConstraint=rmCreateClassDistanceConstraint("short forest vs. forest", rmClassID("classForest"), 10.0);

      int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
      int edgeConstraint=rmCreateBoxConstraint("avoid edge of map", rmXTilesToFraction(12), rmZTilesToFraction(12), 1.0-rmXTilesToFraction(12), 1.0-rmZTilesToFraction(12), 0.01);

	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
	int avoidBuzzards=rmCreateTypeDistanceConstraint("buzzard avoid buzzard", "BuzzardFlock", 70.0);
	int avoidBison=rmCreateTypeDistanceConstraint("avoid Bison", "Bison", 20);
	int avoidPronghorn=rmCreateTypeDistanceConstraint("avoid Pronghorn", "Pronghorn", 15.0);
	int avoidCow=rmCreateTypeDistanceConstraint("cow avoids cow", "cow", 50.0);
	int avoidBighorn=rmCreateTypeDistanceConstraint("avoid bighorn", "bighornsheep", 35.0);
	int avoidTradeRoute=rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
	int avoidTradeRouteMore=rmCreateTradeRouteDistanceConstraint("trade route more", 15.0);
	int longPlayerConstraint=rmCreateClassDistanceConstraint("long stay away from players", classPlayer, 60.0);
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 30.0);
	int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 20.0);
	int shortPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players short", classPlayer, 8.0);
	int avoidNugget=rmCreateClassDistanceConstraint("nugget vs. nugget long", rmClassID("classNugget"), 60.0);
	int avoidNuggetLong=rmCreateClassDistanceConstraint("nugget vs. nugget longer", rmClassID("classNugget"), 80.0);
	int shortAvoidNugget=rmCreateClassDistanceConstraint("nugget vs. nugget short", rmClassID("classNugget"), 8.0);
	int avoidTradeRouteSockets=rmCreateTypeDistanceConstraint("avoid Trade Socket", "sockettraderoute", 10);
	int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 8.0);
      int avoidImportantItem=rmCreateClassDistanceConstraint("things avoid each other", rmClassID("importantItem"), 10.0);
	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
      int connectionConstraint=rmCreateClassDistanceConstraint("stay away from connection", connectionClass, 5.0);
      int connectionConstraintLong=rmCreateClassDistanceConstraint("stay farther away from connection", connectionClass, 25.0);
	int avoidTeamLands=rmCreateClassDistanceConstraint("avoid team lands", rmClassID("teamClass"), 2.0);

   // Cardinal Directions - "halves" of the map.
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(265), rmDegreesToRadians(95));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(85), rmDegreesToRadians(275));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(355), rmDegreesToRadians(185));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(175), rmDegreesToRadians(5));

   // Text
   rmSetStatusText("",0.1);
		
   // starting resources defined

	int TCID = rmCreateObjectDef("player TC");
	if (rmGetNomadStart())
	{
	   rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
         rmAddObjectDefItem(TCID, "townCenter", 1, 0);
	}
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 10.0);
	rmAddObjectDefConstraint(TCID, avoidTradeRoute);
	rmAddObjectDefToClass(TCID, rmClassID("player"));
	rmAddObjectDefToClass(TCID, rmClassID("startingUnit"));

	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 8.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);
	rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(startingUnits, avoidStartingUnits);

	int playerSilverID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(playerSilverID, "mine", 1, 0);
	rmAddObjectDefConstraint(playerSilverID, avoidTradeRoute);
	rmSetObjectDefMinDistance(playerSilverID, 20.0);
	rmSetObjectDefMaxDistance(playerSilverID, 26.0);
	rmAddObjectDefToClass(playerSilverID, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(playerSilverID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerSilverID, avoidStartingUnits);

	int playerSilver2ID = rmCreateObjectDef("player silver second");
	rmAddObjectDefItem(playerSilver2ID, "mine", 1, 0);
	rmAddObjectDefConstraint(playerSilver2ID, avoidTradeRoute);
	rmSetObjectDefMinDistance(playerSilver2ID, 40.0);
	rmSetObjectDefMaxDistance(playerSilver2ID, 50.0);
	rmAddObjectDefToClass(playerSilver2ID, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(playerSilver2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerSilver2ID, avoidStartingUnits);
      rmAddObjectDefConstraint(playerSilver2ID, shortAvoidSilver);
      rmAddObjectDefConstraint(playerSilver2ID, playerConstraint);

	int playerSilver3ID = rmCreateObjectDef("player silver third");
	rmAddObjectDefItem(playerSilver3ID, "mine", 1, 0);
	rmAddObjectDefConstraint(playerSilver3ID, avoidTradeRoute);
	rmSetObjectDefMinDistance(playerSilver3ID, 60.0);
	rmSetObjectDefMaxDistance(playerSilver3ID, 70.0);
	rmAddObjectDefToClass(playerSilver3ID, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(playerSilver3ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerSilver3ID, avoidStartingUnits);
      rmAddObjectDefConstraint(playerSilver3ID, shortAvoidSilver);
      rmAddObjectDefConstraint(playerSilver3ID, longPlayerConstraint);

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeSonora", rmRandInt(7,10), 5.0);
	rmAddObjectDefItem(StartAreaTreeID, "UnderbrushDesert", rmRandInt(4,6), 4.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 10);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 15);
	rmAddObjectDefToClass(StartAreaTreeID, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(StartAreaTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidSilver);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidResource);

      int berryNum = rmRandInt(2,5);
	int StartBerriesID=rmCreateObjectDef("starting berries");
	rmAddObjectDefItem(StartBerriesID, "berrybush", berryNum, 4.0);
	rmSetObjectDefMinDistance(StartBerriesID, 10);
	rmSetObjectDefMaxDistance(StartBerriesID, 15);
	rmAddObjectDefToClass(StartBerriesID, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(StartBerriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(StartBerriesID, avoidTradeRoute);
	rmAddObjectDefConstraint(StartBerriesID, avoidStartingUnits);
	rmAddObjectDefConstraint(StartBerriesID, avoidResource);

	int pronghornNum = rmRandInt(6, 8);
	int pronghornID=rmCreateObjectDef("pronghorn herd");
	rmAddObjectDefItem(pronghornID, "Pronghorn", pronghornNum, 6.0);
	rmSetObjectDefCreateHerd(pronghornID, false);
	rmSetObjectDefMinDistance(pronghornID, 14.0);
	rmSetObjectDefMaxDistance(pronghornID, 18.0);
	rmAddObjectDefToClass(pronghornID, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(pronghornID, avoidResource);
	rmAddObjectDefConstraint(pronghornID, avoidImpassableLand);
//	rmAddObjectDefConstraint(pronghornID, avoidNatives);
	rmAddObjectDefConstraint(pronghornID, shortAvoidNugget);
	rmAddObjectDefConstraint(pronghornID, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(pronghornID, edgeConstraint);
//	rmPlaceObjectDefPerPlayer(pronghornID, false, 1);

   // Text
   rmSetStatusText("",0.15);

// ************** BUILD AREAS ***************************************

   // Build up land mass to make cliff edges
   int bigContinentID=rmCreateArea("big continent");
   if (cNumberNonGaiaPlayers >3)
      rmSetAreaSize(bigContinentID, 0.78, 0.78);
   else 
      rmSetAreaSize(bigContinentID, 0.77, 0.77);
   rmSetAreaWarnFailure(bigContinentID, false);
   rmSetAreaSmoothDistance(bigContinentID, 10);
   rmSetAreaMix(bigContinentID, "sonora_dirt");
   rmSetAreaCoherence(bigContinentID, 0.9);
   rmSetAreaLocation(bigContinentID, 0.5, 0.5);
   rmSetAreaCliffType(bigContinentID, "Sonora");
   rmSetAreaCliffEdge(bigContinentID, 1, 1.0, 0.0, 0.0, 0);
   rmSetAreaCliffHeight(bigContinentID, -5, 1.0, 0.3);
   rmSetAreaCliffPainting(bigContinentID, false, false, true);
   rmAddAreaToClass(bigContinentID, rmClassID("classCliff"));
   rmBuildArea(bigContinentID);

   int bigContinent2ID=rmCreateArea("big continent 2");
   if (cNumberNonGaiaPlayers >3)
      rmSetAreaSize(bigContinent2ID, 0.71, 0.71); 
   else
      rmSetAreaSize(bigContinent2ID, 0.69, 0.70); 
   rmSetAreaWarnFailure(bigContinent2ID, false);
   rmSetAreaSmoothDistance(bigContinent2ID, 10);
   rmSetAreaMix(bigContinent2ID, "sonora_dirt");
   rmSetAreaCoherence(bigContinent2ID, 0.9);
   rmSetAreaLocation(bigContinent2ID, 0.5, 0.5);
   rmSetAreaCliffType(bigContinent2ID, "Sonora");
   rmSetAreaCliffEdge(bigContinent2ID, 1, 1.0, 0.0, 0.0, 0);
   rmSetAreaCliffHeight(bigContinent2ID, -5, 1.0, 0.3);
   rmSetAreaCliffPainting(bigContinent2ID, false, false, true);
   rmAddAreaToClass(bigContinent2ID, rmClassID("classCliff"));
   rmBuildArea(bigContinent2ID);

   // Text
   rmSetStatusText("",0.20);

   // Set up for axis and player side
   int axisChance = -1;
   axisChance = rmRandInt(1, 2);
   int playerSide = -1;
   playerSide = rmRandInt(1, 2);

   // Set up player starting locations
   if (cNumberTeams == 2)
   {
      if (axisChance == 1)
      {
	   if (playerSide == 1)
         {
		rmSetPlacementTeam(0);
	   }
         else if (playerSide == 2)
	   {
		rmSetPlacementTeam(1);
	   }
         rmSetPlacementSection(0.20, 0.35);
	   if (cNumberNonGaiaPlayers >6)
	   {
		rmSetPlacementSection(0.12, 0.38);
         }
	   rmPlacePlayersCircular(0.36, 0.37, 0.0);

	   if (playerSide == 1)
         {
		rmSetPlacementTeam(1);
	   }
         else if (playerSide == 2)
	   {
		rmSetPlacementTeam(0);
	   }
	   rmSetPlacementSection(0.70, 0.85);
	   if (cNumberNonGaiaPlayers >6)
	   {
		rmSetPlacementSection(0.62, 0.88);
         }
	   rmPlacePlayersCircular(0.36, 0.37, 0.0);
      }
      else if (axisChance == 2)
      {
	   if (playerSide == 1)
         {
		rmSetPlacementTeam(0);
	   }
         else if (playerSide == 2)
	   {
		rmSetPlacementTeam(1);
	   }
	   rmSetPlacementSection(0.45, 0.60);
	   if (cNumberNonGaiaPlayers >6)
	   {
		rmSetPlacementSection(0.38, 0.63);
	   }
	   rmPlacePlayersCircular(0.36, 0.37, 0.0);
	   if (playerSide == 1)
         {
		rmSetPlacementTeam(1);
	   }
         else if (playerSide == 2)
	   {
		rmSetPlacementTeam(0);
	   }
	   rmSetPlacementSection(0.95, 0.10);
	   if (cNumberNonGaiaPlayers >6)
	   {
		rmSetPlacementSection(0.88, 0.13);
	   }
	   rmPlacePlayersCircular(0.36, 0.37, 0.0);
      }
   }
   else
   {     
	   rmPlacePlayersCircular(0.36, 0.37, 0.0);
   }

   // Text
   rmSetStatusText("",0.30);

   // Set up a connection
   int connectionID=rmCreateConnection("passes");
   rmSetConnectionType(connectionID, cConnectAreas, false, 1.0);
   rmAddConnectionTerrainReplacement(connectionID, "sonora\cliff_edge_son", "sonora\ground7_son");
   rmAddConnectionTerrainReplacement(connectionID, "sonora\ground1clifftop_son", "sonora\ground2_son");
   rmSetConnectionWarnFailure(connectionID, false);
   if (cNumberTeams == 2)
      rmSetConnectionWidth(connectionID, 20, 2);
   else
      rmSetConnectionWidth(connectionID, 10, 0);  
   rmSetConnectionTerrainCost(connectionID, "sonora\cliff_edge_son", 95.0);
   rmSetConnectionTerrainCost(connectionID, "sonora\ground1clifftop_son", 5.0);
   rmSetConnectionTerrainCost(connectionID, "sonora\ground7_son", 1.0);
   rmSetConnectionPositionVariance(connectionID, 0.5);
   rmSetConnectionBaseHeight(connectionID, 1.0);
   rmSetConnectionHeightBlend(connectionID, 10);
   rmSetConnectionCoherence(connectionID, 0.9);
   rmAddConnectionToClass(connectionID, connectionClass); 

   // Build team areas.
   int baseDividerWidth = -1;
   baseDividerWidth = 28;

   int teamConstraint=rmCreateClassDistanceConstraint("team constraint", teamClass, baseDividerWidth);

   float percentPerPlayer = 0.9/cNumberNonGaiaPlayers;
   float teamSize = 0;

   for(i=0; <cNumberTeams)
   {
     int teamID=rmCreateArea("team"+i);
     teamSize = percentPerPlayer*rmGetNumberPlayersOnTeam(i);
     rmEchoInfo ("team size "+teamSize);
     rmSetAreaSize(teamID, teamSize, teamSize);
     rmSetAreaWarnFailure(teamID, false);
     rmSetAreaTerrainType(teamID, "sonora\ground7_son");
     rmSetAreaMix(teamID, "sonora_dirt");
     rmSetAreaMinBlobs(teamID, 1);
     rmSetAreaMaxBlobs(teamID, 5);
     rmSetAreaMinBlobDistance(teamID, 20.0);
     rmSetAreaMaxBlobDistance(teamID, 40.0);
     rmSetAreaCoherence(teamID, 0.1);
     rmAddAreaToClass(teamID, teamClass);
     rmSetAreaSmoothDistance(teamID, 10);
     rmSetAreaCliffType(teamID, "Sonora");
     rmSetAreaCliffEdge(teamID, 1, 1.0, 0.0, 0.0, 0);
     rmSetAreaCliffHeight(teamID, 8, 2.0, 0.3);
     rmSetAreaHeightBlend(teamID, 1);
     rmAddConnectionArea(connectionID, teamID);
     if (cNumberTeams == 2)
     { 
       if (axisChance == 2)
       {
	   if (playerSide == 2)
         {
            if (i == 0)
               rmAddAreaConstraint(teamID, Northward);
	      else if (i == 1)
               rmAddAreaConstraint(teamID, Southward);
	   }
	   else if (playerSide == 1)
         {
            if (i == 1)
               rmAddAreaConstraint(teamID, Northward);
	      else if (i == 0)
               rmAddAreaConstraint(teamID, Southward);
	   }  
      }
      else if (axisChance == 1)
      { 
	   if (playerSide == 1)
         {
            if (i == 0)
               rmAddAreaConstraint(teamID, Eastward);
            else if (i == 1)
               rmAddAreaConstraint(teamID, Westward);
         }
	   else if (playerSide == 2)
         {
            if (i == 1)
               rmAddAreaConstraint(teamID, Eastward);
            else if (i == 0)
               rmAddAreaConstraint(teamID, Westward);
         }
       }   
     }
     rmAddAreaConstraint(teamID, teamConstraint);
     rmSetAreaLocTeam(teamID, i);
   }
   rmBuildAllAreas();

   // Set up player areas.
   float playerFraction=rmAreaTilesToFraction(100);
   for(i=1; <cNumberPlayers)
   {
      int id=rmCreateArea("Player"+i, rmAreaID("team"+rmGetPlayerTeam(i)));
      rmSetPlayerArea(i, id);
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmAddAreaConstraint(id, playerConstraint); 
      rmAddAreaConstraint(id, playerEdgeConstraint); 
      rmSetAreaLocPlayer(id, i);
      rmSetAreaMix(id, "sonora_dirt");
	rmSetAreaTerrainType(id, "sonora\ground7_son");
      rmSetAreaWarnFailure(id, false);
   }
   rmBuildAllAreas();
   rmBuildConnection(connectionID);

   // Center area
   int centerArea=rmCreateArea("TheCenter");
   rmSetAreaSize(centerArea, 0.01, 0.01);
   rmSetAreaLocation(centerArea, 0.5, 0.5);
   rmAddAreaToClass(centerArea, rmClassID("center")); 
	
   // Text
   rmSetStatusText("",0.4);

// **************** TRADE ROUTES **********************

if (cNumberTeams == 2)
{
   int tradeRouteID = rmCreateTradeRoute();
   if (axisChance == 1)
   {
     rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 1.0);
     rmAddTradeRouteWaypoint(tradeRouteID, 0.34, 0.65);
     rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 0.5);
     rmAddTradeRouteWaypoint(tradeRouteID, 0.34, 0.35);
     rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 0.0);
   }
   else if (axisChance == 2)
   {
      rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 0.3);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.34);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.3);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.34);
      rmAddTradeRouteWaypoint(tradeRouteID, 1.0, 0.3);
   }
   rmBuildTradeRoute(tradeRouteID, "dirt");

   int tradeRoute2ID = rmCreateTradeRoute();
   if (axisChance == 1)
   {
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.7, 1.0);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.66, 0.65);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.7, 0.5);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.66, 0.35);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.7, 0.0);
   }
   else if (axisChance == 2)
   {
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.0, 0.7);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.35, 0.66);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.5, 0.7);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.65, 0.66);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 1.0, 0.7);
   }
   rmBuildTradeRoute(tradeRoute2ID, "carolinas\trade_route");  

   // Trading post sockets
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 8.0);
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

   // sockets for 1st trade route
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.12);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.88);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   if (cNumberNonGaiaPlayers > 5)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }

   // sockets for 2nd trade route
   rmSetObjectDefTradeRouteID(socketID, tradeRoute2ID);
   socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.12);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.88);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   if (cNumberNonGaiaPlayers > 5)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
}

   // Text
   rmSetStatusText("",0.5);

// *********************  PLACE NATIVES  *********************

   int nativeChoice = rmRandInt(1,2);
   int villageAID = -1;
   int villageType = rmRandInt(1,3);

   if (nativeChoice == 1)
	villageAID = rmCreateGrouping("village A", "native apache village "+villageType);
   else if (nativeChoice == 2)
	villageAID = rmCreateGrouping("village A", "native navajo village "+villageType);
   rmSetGroupingMinDistance(villageAID, 25.0);
   rmSetGroupingMaxDistance(villageAID, 90.0);
   rmAddGroupingToClass(villageAID, rmClassID("natives"));
   rmAddGroupingToClass(villageAID, rmClassID("importantItem"));
   rmAddGroupingConstraint(villageAID, avoidImpassableLand);
   rmAddGroupingConstraint(villageAID, avoidTradeRouteMore);
   rmAddGroupingConstraint(villageAID, avoidImportantItem);
   rmAddGroupingConstraint(villageAID, avoidNatives);
   rmAddGroupingConstraint(villageAID, socketAvoidSocket);

   for(i=1; <cNumberPlayers)
   {
	rmPlaceGroupingAtLoc(villageAID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
   }

// *************************  PLACE STARTING UNITS ETC ***************************
   for(i=1; <cNumberPlayers)
   {
	rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(playerSilverID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(playerSilver2ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartBerriesID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(pronghornID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

   }

   // Text
   rmSetStatusText("",0.6);

// ****************************  MESAS  ************************************


   // larger mesas
   int failCount=0;
   int numTries=cNumberNonGaiaPlayers*5;

   for(j=0; <cNumberTeams)
   {
	for(i=0; <numTries)
	{
		int mesaID=rmCreateArea("team"+j+"mesa"+i, rmAreaID("team"+j));
		rmSetAreaSize(mesaID, rmAreaTilesToFraction(20), rmAreaTilesToFraction(140));  
		rmSetAreaWarnFailure(mesaID, false);
		rmSetAreaCliffType(mesaID, "Sonora");
		rmAddAreaToClass(mesaID, rmClassID("canyon"));	
		rmSetAreaCliffEdge(mesaID, 1, 1.0, 0.1, 1.0, 0);
		rmSetAreaCliffHeight(mesaID, rmRandInt(6,7), 1.0, 1.0);
		rmAddAreaConstraint(mesaID, avoidCanyons);
		rmAddAreaConstraint(mesaID, avoidNatives);
		rmAddAreaConstraint(mesaID, avoidImportantItem);
		rmSetAreaMinBlobs(mesaID, 3);
		rmSetAreaMaxBlobs(mesaID, 5);
		rmSetAreaMinBlobDistance(mesaID, 3.0);
		rmSetAreaMaxBlobDistance(mesaID, 5.0);
		rmSetAreaCoherence(mesaID, 0.5);
		rmAddAreaConstraint(mesaID, playerConstraint); 
		rmAddAreaConstraint(mesaID, avoidTradeRouteSockets);
		rmAddAreaConstraint(mesaID, avoidTradeRoute);
		rmAddAreaConstraint(mesaID, shortAvoidSilver);
		rmAddAreaConstraint(mesaID, connectionConstraintLong);
		if(rmBuildArea(mesaID)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==2)
				break;
		}
		else
			failCount=0;

	}
   }

   // small rock spires
   numTries=cNumberNonGaiaPlayers*11;
   for(i=0; <numTries)
   {
	int smallMesaID=rmCreateArea("small mesa"+i, teamID);
	rmSetAreaSize(smallMesaID, rmAreaTilesToFraction(4), rmAreaTilesToFraction(10));  
	rmSetAreaWarnFailure(smallMesaID, false);
	rmSetAreaCliffType(smallMesaID, "Sonora");
	rmAddAreaToClass(smallMesaID, rmClassID("canyon"));	
	rmSetAreaCliffEdge(smallMesaID, 1, 1.0, 0.1, 1.0, 0);
	rmSetAreaCliffHeight(smallMesaID, rmRandInt(6,7), 1.0, 1.0);
	rmAddAreaConstraint(smallMesaID, shortAvoidCanyons);
	rmSetAreaMinBlobs(smallMesaID, 1);
	rmSetAreaMaxBlobs(smallMesaID, 2);
	rmSetAreaMinBlobDistance(smallMesaID, 4.0);
	rmSetAreaMaxBlobDistance(smallMesaID, 6.0);
	rmSetAreaCoherence(smallMesaID, 0.3);
	rmAddAreaConstraint(smallMesaID, mediumPlayerConstraint); 
	rmAddAreaConstraint(smallMesaID, avoidNatives);
	rmAddAreaConstraint(smallMesaID, avoidImportantItem); 
	rmAddAreaConstraint(smallMesaID, avoidTradeRouteSockets);
	rmAddAreaConstraint(smallMesaID, avoidTradeRoute);
	rmAddAreaConstraint(smallMesaID, shortAvoidSilver);
	rmAddAreaConstraint(smallMesaID, connectionConstraintLong);
	rmAddAreaConstraint(smallMesaID, edgeConstraint);
	if(rmBuildArea(smallMesaID)==false)
	{
		// Stop trying once we fail 3 times in a row.
		failCount++;
		if(failCount==20)
			break;
	}
	else
		failCount=0;
   }

   // Text
   rmSetStatusText("",0.7);

// ************************************ FORESTS **************************************

   for(j=0; <cNumberTeams)
   {  
	 for(i=0; <cNumberNonGaiaPlayers*9)
	 {
		int edgeForestID=rmCreateArea("team"+j+"edgeForest"+i, rmAreaID("team"+j));
		rmSetAreaWarnFailure(edgeForestID, false);
		rmSetAreaSize(edgeForestID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
		rmSetAreaForestType(edgeForestID, "sonora forest");
		rmSetAreaForestDensity(edgeForestID, 1.0);
		rmSetAreaForestClumpiness(edgeForestID, 1.0);		
		rmSetAreaForestUnderbrush(edgeForestID, 0.0);
		rmAddAreaToClass(edgeForestID, rmClassID("classForest"));
		rmSetAreaMinBlobs(edgeForestID, 1);
		rmSetAreaMaxBlobs(edgeForestID, 3);					
		rmSetAreaMinBlobDistance(edgeForestID, 16.0);
		rmSetAreaMaxBlobDistance(edgeForestID, 30.0);
		rmSetAreaCoherence(edgeForestID, 0.6);
		rmSetAreaSmoothDistance(edgeForestID, 10);
		rmAddAreaConstraint(edgeForestID, shortPlayerConstraint);
		rmAddAreaConstraint(edgeForestID, forestConstraint); 
		rmAddAreaConstraint(edgeForestID, shortAvoidSilver);  
		rmAddAreaConstraint(edgeForestID, canyonConstraint); 
		rmAddAreaConstraint(edgeForestID, avoidTradeRoute);
		rmAddAreaConstraint(edgeForestID, avoidTradeRouteSockets);
		rmAddAreaConstraint(edgeForestID, avoidStartingUnits);
		rmAddAreaConstraint(edgeForestID, avoidNatives);
		rmAddAreaConstraint(edgeForestID, connectionConstraintLong);
		rmAddAreaConstraint(edgeForestID, shortAvoidImpassableLand);
		if(rmBuildArea(edgeForestID)==false)
		{
			// Stop trying once we fail 5 times in a row.  
			failCount++;
			if(failCount==5)
				break;
		}
		else
			failCount=0; 
	 }
   }

// ************************* RESOURCES *****************************
   // Silver
	int silverType = rmRandInt(1,10);
	int silverID = -1;
	int silverCount = cNumberNonGaiaPlayers*3;	
	rmEchoInfo("silver count = "+silverCount);

	for(i=0; <cNumberTeams)
	{
		silverID = rmCreateObjectDef("silver"+i);
		rmAddObjectDefItem(silverID, "mine", 1, 0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.36));
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, canyonConstraint);
		rmAddObjectDefConstraint(silverID, avoidSilver);
		rmAddObjectDefConstraint(silverID, longPlayerConstraint);
		rmAddObjectDefConstraint(silverID, shortForestConstraint);
		rmAddObjectDefConstraint(silverID, avoidNatives);
		rmAddObjectDefConstraint(silverID, avoidTradeRouteSockets);
		rmAddObjectDefConstraint(silverID, edgeConstraint);
            rmPlaceObjectDefInArea(silverID, 0, rmAreaID("team"+i), 2);
		if (cNumberNonGaiaPlayers > 5)
		   rmPlaceObjectDefInArea(silverID, 0, rmAreaID("team"+i));  
	}

	int canyonSilverID = rmCreateObjectDef("canyon silver");
	rmAddObjectDefItem(canyonSilverID, "mine", 1, 0);
	rmSetObjectDefMinDistance(canyonSilverID, 40.0);
	rmSetObjectDefMaxDistance(canyonSilverID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(canyonSilverID, shortAvoidImpassableLand);
      rmAddObjectDefConstraint(canyonSilverID, shortAvoidSilver);
      rmAddObjectDefConstraint(canyonSilverID, edgeConstraint);
	rmAddObjectDefConstraint(canyonSilverID, avoidTeamLands);
	rmAddObjectDefConstraint(canyonSilverID, connectionConstraintLong);
	rmPlaceObjectDefAtLoc(canyonSilverID, 0, 0.5, 0.5, rmRandInt(2,3));

   // Text
   rmSetStatusText("",0.8);

   // Nuggets
	int nugget5= rmCreateObjectDef("nuggets in canyon"); 
	rmAddObjectDefItem(nugget5, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(3, 4);
	rmAddObjectDefToClass(nugget5, rmClassID("classNugget"));
	rmSetObjectDefMinDistance(nugget5, 0.0);
	rmSetObjectDefMaxDistance(nugget5, rmXFractionToMeters(0.4));
	rmAddObjectDefConstraint(nugget5, avoidTeamLands);
	rmAddObjectDefConstraint(nugget5, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nugget5, avoidNuggetLong);
	rmAddObjectDefConstraint(nugget5, edgeConstraint);
	rmAddObjectDefConstraint(nugget5, connectionConstraintLong);
	rmPlaceObjectDefAtLoc(nugget5, 0, 0.5, 0.5, rmRandInt(2,3));

	int nugget1= rmCreateObjectDef("nugget easy"); 
	rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmAddObjectDefToClass(nugget1, rmClassID("classNugget"));
	rmAddObjectDefConstraint(nugget1, avoidResource);
	rmAddObjectDefConstraint(nugget1, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nugget1, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(nugget1, avoidTradeRoute);
	rmAddObjectDefConstraint(nugget1, shortPlayerConstraint);
	rmAddObjectDefConstraint(nugget1, avoidStartingUnits);
	rmAddObjectDefConstraint(nugget1, shortAvoidCanyons);
	rmAddObjectDefConstraint(nugget1, avoidNugget);
	rmAddObjectDefConstraint(nugget1, avoidNatives);
	rmAddObjectDefConstraint(nugget1, circleConstraint);
	rmAddObjectDefConstraint(nugget1, edgeConstraint);
	rmAddObjectDefConstraint(nugget1, connectionConstraintLong);
	rmSetObjectDefMinDistance(nugget1, 35.0);
	rmSetObjectDefMaxDistance(nugget1, 55.0);
	rmPlaceObjectDefPerPlayer(nugget1, false, 2);

	int nugget2= rmCreateObjectDef("nugget medium"); 
	rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(2, 2);
	rmAddObjectDefToClass(nugget2, rmClassID("classNugget"));
	rmSetObjectDefMinDistance(nugget2, 0.0);
	rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nugget2, avoidResource);
	rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nugget2, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
	rmAddObjectDefConstraint(nugget2, shortPlayerConstraint);
	rmAddObjectDefConstraint(nugget2, shortAvoidCanyons);
	rmAddObjectDefConstraint(nugget2, avoidStartingUnits);
	rmAddObjectDefConstraint(nugget2, avoidNugget);
	rmAddObjectDefConstraint(nugget2, avoidNatives);
	rmAddObjectDefConstraint(nugget2, circleConstraint);
	rmAddObjectDefConstraint(nugget2, edgeConstraint);
	rmAddObjectDefConstraint(nugget2, connectionConstraintLong);
	rmSetObjectDefMinDistance(nugget2, 70.0);
	rmSetObjectDefMaxDistance(nugget2, 110.0);
	rmPlaceObjectDefPerPlayer(nugget2, false, 1);

	int nugget3= rmCreateObjectDef("nugget hard"); 
	rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(3, 3);
	rmAddObjectDefToClass(nugget3, rmClassID("classNugget"));
	rmSetObjectDefMinDistance(nugget3, 0.0);
	rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.4));
	rmAddObjectDefConstraint(nugget3, avoidResource);
	rmAddObjectDefConstraint(nugget3, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nugget3, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(nugget3, avoidTradeRoute);
	rmAddObjectDefConstraint(nugget3, longPlayerConstraint);
	rmAddObjectDefConstraint(nugget3, shortAvoidCanyons);
	rmAddObjectDefConstraint(nugget3, avoidStartingUnits);
	rmAddObjectDefConstraint(nugget3, avoidNugget);
	rmAddObjectDefConstraint(nugget3, avoidNatives);
	rmAddObjectDefConstraint(nugget3, circleConstraint);
	rmAddObjectDefConstraint(nugget3, edgeConstraint);
	rmAddObjectDefConstraint(nugget3, connectionConstraintLong);	
	rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	int nugget4= rmCreateObjectDef("nugget nuts"); 
	rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(4, 4);
	rmAddObjectDefToClass(nugget4, rmClassID("classNugget"));
	rmSetObjectDefMinDistance(nugget4, 0.0);
	rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.4));
	rmAddObjectDefConstraint(nugget4, avoidResource);
	rmAddObjectDefConstraint(nugget4, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nugget4, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(nugget4, avoidTradeRoute);
	rmAddObjectDefConstraint(nugget4, longPlayerConstraint);
	rmAddObjectDefConstraint(nugget4, shortAvoidCanyons);
	rmAddObjectDefConstraint(nugget4, avoidStartingUnits);
	rmAddObjectDefConstraint(nugget4, avoidNuggetLong);
	rmAddObjectDefConstraint(nugget4, avoidNatives);
	rmAddObjectDefConstraint(nugget4, circleConstraint);
	rmAddObjectDefConstraint(nugget4, edgeConstraint);
	rmAddObjectDefConstraint(nugget4, connectionConstraintLong);
	for(i=0; <cNumberTeams)
	{
	   rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, 1);
      }

   // More fauna
	int bisonID=rmCreateObjectDef("Bison herd");
	rmAddObjectDefItem(bisonID, "bison", rmRandInt(7, 8), 6.0);
	rmSetObjectDefCreateHerd(bisonID, true);
	rmSetObjectDefMinDistance(bisonID, 0.35);
	rmSetObjectDefMaxDistance(bisonID, rmXFractionToMeters(0.32));
	rmAddObjectDefConstraint(bisonID, avoidResource);
	rmAddObjectDefConstraint(bisonID, avoidImpassableLand);
	rmAddObjectDefConstraint(bisonID, avoidBison);
	rmAddObjectDefConstraint(bisonID, avoidNatives);
	rmAddObjectDefConstraint(bisonID, avoidPronghorn);
	rmAddObjectDefConstraint(bisonID, shortAvoidNugget);
	rmAddObjectDefConstraint(bisonID, playerConstraint);
	rmAddObjectDefConstraint(bisonID, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(bisonID, edgeConstraint);
	rmPlaceObjectDefPerPlayer(bisonID, false, 2);

      int farPronghornNum = rmRandInt(6, 8);
	int farPronghornID=rmCreateObjectDef("far pronghorn");
	rmAddObjectDefItem(farPronghornID, "Pronghorn", farPronghornNum, 6.0);
	rmSetObjectDefMinDistance(farPronghornID, 45.0);
	rmSetObjectDefMaxDistance(farPronghornID, 95.0);
	rmAddObjectDefConstraint(farPronghornID, avoidResource);
	rmAddObjectDefConstraint(farPronghornID, avoidImpassableLand);
	rmAddObjectDefConstraint(farPronghornID, avoidPronghorn);
	rmAddObjectDefConstraint(farPronghornID, shortAvoidNugget);	
	rmAddObjectDefConstraint(farPronghornID, playerConstraint);
	rmAddObjectDefConstraint(farPronghornID, avoidBison);
	rmAddObjectDefConstraint(farPronghornID, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(farPronghornID, edgeConstraint);
	rmSetObjectDefCreateHerd(farPronghornID, true);
	rmPlaceObjectDefPerPlayer(farPronghornID, false, 1);

      int cowID=rmCreateObjectDef("cow");
      rmAddObjectDefItem(cowID, "cow", 2, 4.0);
      rmSetObjectDefMinDistance(cowID, 0.0);
      rmSetObjectDefMaxDistance(cowID, rmXFractionToMeters(0.49));
      rmAddObjectDefConstraint(cowID, avoidCow);
	rmAddObjectDefConstraint(cowID, playerConstraint);
	rmAddObjectDefConstraint(cowID, shortAvoidCanyons);
      rmAddObjectDefConstraint(cowID, avoidImpassableLand);
	rmAddObjectDefConstraint(cowID, edgeConstraint);
	for(i=0; <cNumberTeams)
	{
         rmPlaceObjectDefInArea(cowID, 0, rmAreaID("team"+i), cNumberNonGaiaPlayers*2); 
	}

	int canyonCowID = rmCreateObjectDef("canyon cow");
	rmAddObjectDefItem(canyonCowID, "cow", 1, 0);
	rmSetObjectDefMinDistance(canyonCowID, 20.0);
	rmSetObjectDefMaxDistance(canyonCowID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(canyonCowID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(canyonCowID, avoidTeamLands);
	rmAddObjectDefConstraint(canyonCowID, connectionConstraintLong);
	rmPlaceObjectDefAtLoc(canyonCowID, 0, 0.5, 0.5, rmRandInt(3,5));

   // Random Trees
	for(i=0; < 10*cNumberNonGaiaPlayers)
	{
		int randomTreeID=rmCreateObjectDef("random tree "+i);
		rmAddObjectDefItem(randomTreeID, "TreeSonora", rmRandInt(1,4), 3.0);
		rmSetObjectDefMinDistance(randomTreeID, 0.0);
		rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(randomTreeID, avoidResource);
		rmAddObjectDefConstraint(randomTreeID, shortAvoidImpassableLand);
		rmAddObjectDefConstraint(randomTreeID, avoidTradeRouteSockets);
		rmAddObjectDefConstraint(randomTreeID, shortPlayerConstraint);
		rmAddObjectDefConstraint(randomTreeID, avoidStartingUnits);
		rmAddObjectDefConstraint(randomTreeID, edgeConstraint);
		rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5);
     }

   // Text
   rmSetStatusText("",0.9);

// *******************  DECO ***************************

	int buzzardFlockID=rmCreateObjectDef("buzzards");
	rmAddObjectDefItem(buzzardFlockID, "BuzzardFlock", 1, 3.0);
	rmSetObjectDefMinDistance(buzzardFlockID, 0.0);
	rmSetObjectDefMaxDistance(buzzardFlockID, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(buzzardFlockID, avoidBuzzards);
	rmAddObjectDefConstraint(buzzardFlockID, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(buzzardFlockID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(buzzardFlockID, playerConstraint);
	rmPlaceObjectDefAtLoc(buzzardFlockID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

	int randomVultureTreeID=rmCreateObjectDef("random vulture tree");
	rmAddObjectDefItem(randomVultureTreeID, "PropVulturePerching", 1, 2.0);
	rmSetObjectDefMinDistance(randomVultureTreeID, 0.0);
	rmSetObjectDefMaxDistance(randomVultureTreeID, rmXFractionToMeters(0.40));
      rmAddObjectDefConstraint(randomVultureTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(randomVultureTreeID, playerConstraint);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidBuzzards);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidVultures);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidTradeRoute);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidTradeRouteSockets);
	rmPlaceObjectDefAtLoc(randomVultureTreeID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

	for (i=0; <4*cNumberNonGaiaPlayers)
      {
		int dirtPatch=rmCreateArea("open dirt patch "+i);
		rmSetAreaWarnFailure(dirtPatch, false);
		rmSetAreaSize(dirtPatch, rmAreaTilesToFraction(140), rmAreaTilesToFraction(200));
		rmSetAreaTerrainType(dirtPatch, "sonora\ground7_son");
		rmAddAreaToClass(dirtPatch, rmClassID("classPatch"));
		rmSetAreaMinBlobs(dirtPatch, 1);
		rmSetAreaMaxBlobs(dirtPatch, 5);
		rmSetAreaMinBlobDistance(dirtPatch, 16.0);
		rmSetAreaMaxBlobDistance(dirtPatch, 40.0);
		rmSetAreaCoherence(dirtPatch, 0.0);
		rmSetAreaSmoothDistance(dirtPatch, 10);
		rmAddAreaConstraint(dirtPatch, shortAvoidImpassableLand);
		rmAddAreaConstraint(dirtPatch, patchConstraint);
		rmBuildArea(dirtPatch); 
      }

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.05;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }

   // Text
   rmSetStatusText("",1.0);
}  
