// New Pampas
// revised for fan patch by RF-Gandalf

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
// Text
   	rmSetStatusText("",0.01);

   string native1Name = "";
   string native2Name = "";

// ********************** MAP PARAMETERS *********************
   // Map size
   int playerTiles = 10000;
   if (cNumberNonGaiaPlayers >4)
	playerTiles = 8000;
   if (cNumberNonGaiaPlayers >6)
	playerTiles = 6000;		
   int size=1.7*sqrt(cNumberNonGaiaPlayers*playerTiles);
   int longSide=1.3*size;      // 'Longside' is used to make the map rectangular
   if (cNumberNonGaiaPlayers > 6)  // wider for larger player numbers
	longSide=1.55*size;
   else if (cNumberNonGaiaPlayers > 4)
	longSide=1.45*size;  
   rmEchoInfo("Map size="+size+"m x "+longSide+"m");
   rmSetMapSize(longSide, size);
   rmSetMapElevationParameters(cElevTurbulence, 0.05, 10, 0.4, 7.0);
   rmSetMapElevationHeightBlend(1);
	
   // Picks a default water height
   rmSetSeaLevel(5.0);
   rmSetLightingSet("Pampas");

   // Picks default terrain and water
   rmSetSeaType("Mongolia River");
   rmSetBaseTerrainMix("mongolia_grass");
   rmTerrainInitialize("mongolia\ground_grass1_mongol", 6.0);
   rmEnableLocalWater(false);
   rmSetMapType("desert");
   rmSetMapType("land");
   rmSetMapType("mongolia");
   rmSetMapType("asia");
   rmSetWorldCircleConstraint(true);
   rmSetWindMagnitude(2.0);

   chooseMercs();		
	
// *********************** DEFINE CLASSES *********************
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classPatch");
   rmDefineClass("corner");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("classNugget");
   rmDefineClass("natives");
   rmDefineClass("classCliff");
   rmDefineClass("center");

// *************************** DEFINE CONSTRAINTS **************************
   // Map edge constraints
	int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
	int longEdgeConstraint=rmCreateBoxConstraint("long edge of map", rmXTilesToFraction(15), rmZTilesToFraction(15), 1.0-rmXTilesToFraction(15), 1.0-rmZTilesToFraction(15), 0.01);

   // Cardinal Directions
	int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
	int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
	int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
	int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

	int Nconstraint = rmCreateBoxConstraint("stay in N portion", 0, 0.5, 1, 1);
	int Sconstraint = rmCreateBoxConstraint("stay in S portion", 0, 0, 1, 0.5);

   // Player constraints
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 30.0);
	int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 70.0);
	int minePlayerConstraint=rmCreateClassDistanceConstraint("mine stays away from players", classPlayer, 35.0);
	int mediumPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players medium", classPlayer, 15.0);
	int shortPlayerConstraint=rmCreateClassDistanceConstraint("short stay away from players", classPlayer, 5.0);
	int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 50.0);
	int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 60.0);
	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
	int shortAvoidResource=rmCreateTypeDistanceConstraint("resource avoid resource short", "resource", 5.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 15.0);
	int avoidCoinShort=rmCreateTypeDistanceConstraint("avoid coin short", "Mine", 10.0);
	int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 10.0);

	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("avoid Town Center Short", "townCenter", 17.0);
	int avoidTownCenterMed=rmCreateTypeDistanceConstraint("avoid Town Center Med", "townCenter", 35.0);

      int centerConstraint=rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), 55.0);

   // Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
	int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int avoidCliffs=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 50.0);
	int shortAvoidCliffs=rmCreateClassDistanceConstraint("short cliff vs. cliff", rmClassID("classCliff"), 5.0);
	int avoidSilver=rmCreateTypeDistanceConstraint("gold avoid gold", "Mine", 50.0);
	int avoidSilverLong=rmCreateTypeDistanceConstraint("gold avoid gold long", "Mine", 55.0);
	int mediumAvoidSilver=rmCreateTypeDistanceConstraint("medium gold avoid gold", "Mine", 25.0);
	if (cNumberNonGaiaPlayers > 4)
	   mediumAvoidSilver=rmCreateTypeDistanceConstraint("medium gold avoid gold shorter", "Mine", 20.0);
	int shortAvoidTrees=rmCreateTypeDistanceConstraint("short avoid trees", "ypTreeMongolia", 30.0);
	int deerAvoidDeer=rmCreateTypeDistanceConstraint("deer avoid deer", "ypSaiga", 50.0);
	int deerAvoidDeerShort=rmCreateTypeDistanceConstraint("deer avoid deer", "ypSaiga", 20.0);
	int avoidNuggets=rmCreateClassDistanceConstraint("nugget vs. nugget", rmClassID("classNugget"), 20.0);
	int avoidNuggetFar=rmCreateClassDistanceConstraint("nugget vs. nugget far", rmClassID("classNugget"), 70.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 10.0);

   // Specify true so constraint stays outside of circle (i.e. inside corners)
	int cornerConstraint0=rmCreateCornerConstraint("in corner 0", 0, true);
	int cornerConstraint1=rmCreateCornerConstraint("in corner 1", 1, true);
	int cornerConstraint2=rmCreateCornerConstraint("in corner 2", 2, true);
	int cornerConstraint3=rmCreateCornerConstraint("in corner 3", 3, true);
	int insideCircleConstraint=rmCreateCornerConstraint("inside circle", -1, false);
	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // Unit avoidance
	int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 40.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), rmXFractionToMeters(0.3));
	int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 12.0);
	int shortAvoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other short", rmClassID("importantItem"), 10);
	int farAvoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives alot", rmClassID("natives"), 80.0);
	int avoidLlama=rmCreateTypeDistanceConstraint("llama avoids llama", "ypYak", 50.0);

   // Decoration avoidance
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 7.0);

   // Trade route avoidance.
	int shortAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route short", 5.0);
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 15.0);
	int avoidTradeRouteSockets=rmCreateTypeDistanceConstraint("avoid trade route sockets", "sockettraderoute", 15.0);
	int avoidTradeRouteSocketsFar=rmCreateTypeDistanceConstraint("avoid trade route sockets far", "sockettraderoute", 15.0);

// -------------Done defining constraints
// Text
	rmSetStatusText("",0.05);

// ********** Map feature choices **********
   int riverPlacement = -1;
   float tradeRouteVersion = rmRandFloat(0.0,1.0);
   int centerTradeRoute = 0;
   int leftTradeRoute = 0;
   int rightTradeRoute = 0;
   int centerRiverCrossing = rmRandInt(0,1);

   if(rmGetIsKOTH())
	tradeRouteVersion = rmRandFloat(0.4,1.0);

   if (cNumberTeams > 2)
	tradeRouteVersion = rmRandFloat(0.4,1.0);

   if (tradeRouteVersion < 0.4)  		// trade route across center axis
   {
      riverPlacement = rmRandInt(1,2);    // river either side
	centerTradeRoute = 1;
	centerRiverCrossing = 0;
   }
   else if (tradeRouteVersion < 0.7)  	// left trade route
   {
      riverPlacement = 2;  			// right river
	leftTradeRoute = 1;
   }
   else						// right trade route
   { 					 	
      riverPlacement = 1;  			// left river
      rightTradeRoute = 1;
   }	

// ***************** PLACE THE RIVER ******************
   int rivermin = -1;
   int rivermax = -1;
   if (cNumberNonGaiaPlayers <= 3)
   {
	rivermin = 5;
	rivermax = 6;
   }
   else
   {
	 rivermin = 6;
	 rivermax = 8;
   }

   int coloradoRiver = rmRiverCreate(-1, "Mongolia River", 30, 10, rivermin, rivermax);
   if (riverPlacement == 1)
   {
      if (cNumberNonGaiaPlayers > 6)
         rmRiverSetConnections(coloradoRiver, 0.19, 0.0, 0.19, 1.0);
      else if (cNumberNonGaiaPlayers > 4)
         rmRiverSetConnections(coloradoRiver, 0.2, 0.0, 0.2, 1.0);
      else
         rmRiverSetConnections(coloradoRiver, 0.22, 0.0, 0.22, 1.0);
   }
   else if (riverPlacement == 2)
   {
      if (cNumberNonGaiaPlayers > 6)
         rmRiverSetConnections(coloradoRiver, 0.81, 0.0, 0.81, 1.0);
      else if (cNumberNonGaiaPlayers > 4)
         rmRiverSetConnections(coloradoRiver, 0.8, 0.0, 0.8, 1.0);
      else
         rmRiverSetConnections(coloradoRiver, 0.78, 0.0, 0.78, 1.0);
   }
      	
   rmRiverSetShallowRadius(coloradoRiver, rmRandInt(9, 11));
   rmRiverAddShallow(coloradoRiver, rmRandFloat(0.13, 0.16));

   if (centerRiverCrossing == 1)
   {
      rmRiverSetShallowRadius(coloradoRiver, rmRandInt(9, 11));
      rmRiverAddShallow(coloradoRiver, rmRandFloat(0.30, 0.35));

   }

   rmRiverSetShallowRadius(coloradoRiver, rmRandInt(9, 11));
   rmRiverAddShallow(coloradoRiver, rmRandFloat(0.63, 0.66));

   rmRiverSetBankNoiseParams(coloradoRiver, 0.07, 2, 1.5, 10.0, 0.667, 3.0);
   rmRiverBuild(coloradoRiver);
//   rmRiverReveal(coloradoRiver, 1);   

// Text
	rmSetStatusText("",0.10);

// ***************** TRADE ROUTE ******************
   int newTradeRouteID = rmCreateTradeRoute();
   vector tradeRoutePoint = cOriginVector;

   if (centerTradeRoute == 1)
      tradeRoutePoint = rmFindClosestPoint(0.0, 0.5, 15.0);
   else if (leftTradeRoute == 1)
	if (cNumberNonGaiaPlayers > 4)
         tradeRoutePoint = rmFindClosestPoint(0.09, 0.0, 15.0);
	else
         tradeRoutePoint = rmFindClosestPoint(0.15, 0.0, 15.0);
   else if (rightTradeRoute == 1)
	if (cNumberNonGaiaPlayers > 4)
         tradeRoutePoint = rmFindClosestPoint(0.91, 1.0, 15.0);
	else
         tradeRoutePoint = rmFindClosestPoint(0.85, 1.0, 15.0);

   rmAddTradeRouteWaypoint(newTradeRouteID, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)));

   if (centerTradeRoute == 1)
   {
      rmAddRandomTradeRouteWaypoints(newTradeRouteID, 0.4, 0.45, 4, 6);
      rmAddRandomTradeRouteWaypoints(newTradeRouteID, 0.6, 0.55, 2, 6);
      tradeRoutePoint = rmFindClosestPoint(1.0, 0.5, 15.0);
   }
   else if (leftTradeRoute == 1)
   {
      rmAddRandomTradeRouteWaypoints(newTradeRouteID, 0.22, 0.45, 4, 6);
      rmAddRandomTradeRouteWaypoints(newTradeRouteID, 0.22, 0.55, 2, 6);
	if (cNumberNonGaiaPlayers > 4)
         tradeRoutePoint = rmFindClosestPoint(0.1, 1.0, 15.0);
	else
         tradeRoutePoint = rmFindClosestPoint(0.15, 1.0, 15.0);
   }
   else if (rightTradeRoute == 1)
   {
      rmAddRandomTradeRouteWaypoints(newTradeRouteID, 0.78, 0.55, 4, 6);
      rmAddRandomTradeRouteWaypoints(newTradeRouteID, 0.78, 0.45, 2, 6);
	if (cNumberNonGaiaPlayers > 4)
         tradeRoutePoint = rmFindClosestPoint(0.9, 0.0, 15.0);
	else
         tradeRoutePoint = rmFindClosestPoint(0.85, 0.0, 20.0);
   }
   rmAddRandomTradeRouteWaypoints(newTradeRouteID, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)), 4, 6);

   bool placedTradeRoute = rmBuildTradeRoute(newTradeRouteID, "dirt");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route"); 

// Text
	rmSetStatusText("",0.15);

   // Sockets
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 8.0);
   rmAddObjectDefConstraint(socketID, avoidWater);
   rmSetObjectDefTradeRouteID(socketID, newTradeRouteID);
   vector socketLoc = rmGetTradeRouteWayPoint(newTradeRouteID, 0.0);

   if (cNumberNonGaiaPlayers > 4)
      socketLoc = rmGetTradeRouteWayPoint(newTradeRouteID, 0.13);
   else
      socketLoc = rmGetTradeRouteWayPoint(newTradeRouteID, 0.1);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(newTradeRouteID, 0.36);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(newTradeRouteID, 0.64);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   if (cNumberNonGaiaPlayers > 4)
      socketLoc = rmGetTradeRouteWayPoint(newTradeRouteID, 0.87);
   else
      socketLoc = rmGetTradeRouteWayPoint(newTradeRouteID, 0.9);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

// Text
	rmSetStatusText("",0.20);

// ****** Set up player starting locations ******
   int playerSide = rmRandInt(1,2);

   if (cNumberNonGaiaPlayers == 2)
   {
      if (playerSide == 1)
      {
	   rmSetPlacementTeam(0);
 	}
      else if (playerSide == 2)
	{
         rmSetPlacementTeam(1);
	}
      rmSetPlacementSection(0.52, 0.53);
	rmPlacePlayersCircular(0.38, 0.385, 0.0);

	if (playerSide == 1)
      {
	   rmSetPlacementTeam(1);
      }
      else if (playerSide == 2)
      {
   	   rmSetPlacementTeam(0);
	}
      rmSetPlacementSection(0.02, 0.03);
	rmPlacePlayersCircular(0.38, 0.385, 0.0);
   }
   else if (cNumberTeams == 2)
   {
      if (cNumberNonGaiaPlayers < 5) 
      {
	    if (playerSide == 1)
          {
		rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
          rmSetPlacementSection(0.45, 0.55);
	    rmPlacePlayersCircular(0.39, 0.395, 0.0);  

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
          rmSetPlacementSection(0.95, 0.05);
	    rmPlacePlayersCircular(0.39, 0.395, 0.0);
	}
	else if (cNumberNonGaiaPlayers < 7)  
      {
	    if (playerSide == 1)
          {
		rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
          rmSetPlacementSection(0.418, 0.582);
	    rmPlacePlayersCircular(0.395, 0.40, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
          rmSetPlacementSection(0.918, 0.082);
	    rmPlacePlayersCircular(0.395, 0.40, 0.0);
	}
	else    
      {
	    if (playerSide == 1)
          {
		rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
          rmSetPlacementSection(0.412, 0.588);
	    rmPlacePlayersCircular(0.40, 0.405, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
          rmSetPlacementSection(0.912, 0.088);
	    rmPlacePlayersCircular(0.40, 0.405, 0.0);
	}
   }
   else // FFA
   {
	rmSetPlayerPlacementArea(0.28,0.05,0.72,0.95);
	rmPlacePlayersSquare(0.4, 0.0, 0.0);
   }

// Text
	rmSetStatusText("",0.25);
	
// Set up player areas.
   float playerFraction=rmAreaTilesToFraction(200);
   for(i=1; <cNumberPlayers)
   {
      // Create the area.
      int id=rmCreateArea("Player"+i);
      // Assign to the player.
      rmSetPlayerArea(i, id);
      // Set the size.
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMix(id, "mongolia_grass_b");
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmAddAreaConstraint(id, playerConstraint); 
      rmAddAreaConstraint(id, playerEdgeConstraint); 
	rmSetAreaCoherence(id, 1.0);
	rmAddAreaConstraint(id, longAvoidImpassableLand);
	rmSetAreaLocPlayer(id, i);
	rmSetAreaWarnFailure(id, false);
   }

// Center area
   int centerArea=rmCreateArea("TheCenter");
   rmSetAreaSize(centerArea, 0.02, 0.02);
   rmSetAreaLocation(centerArea, 0.5, 0.5);
   rmAddAreaToClass(centerArea, rmClassID("center")); 

   rmBuildAllAreas();

// ********** Starting resources **********
   int TCfloat = -1;
   if (cNumberNonGaiaPlayers <= 4)
	TCfloat = 10;
   else 
	TCfloat = 15;

   int startingTCID= rmCreateObjectDef("startingTC");
   if (rmGetNomadStart())
   {
	rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 5.0);
   }
   else
   {
      rmAddObjectDefItem(startingTCID, "townCenter", 1, 5.0);
   }
   rmSetObjectDefMinDistance(startingTCID, 0);
   rmSetObjectDefMaxDistance(startingTCID, TCfloat);
   rmAddObjectDefConstraint(startingTCID, avoidImpassableLand);
   rmAddObjectDefConstraint(startingTCID, shortAvoidTradeRoute);
   rmAddObjectDefConstraint(startingTCID, avoidTradeRouteSockets);
   rmAddObjectDefToClass(startingTCID, rmClassID("player"));
   rmAddObjectDefToClass(startingTCID, rmClassID("startingUnit"));

   int StartAreaTreeID=rmCreateObjectDef("starting trees");
   rmAddObjectDefItem(StartAreaTreeID, "ypTreeMongolia", 3, 6.0);
   rmSetObjectDefMinDistance(StartAreaTreeID, 10);
   rmSetObjectDefMaxDistance(StartAreaTreeID, 14);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidStartResource);
   rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidNatives);

   int StartBerriesID=rmCreateObjectDef("starting berries");
   rmAddObjectDefItem(StartBerriesID, "berrybush", 3, 5.0);
   rmSetObjectDefMinDistance(StartBerriesID, 10);
   rmSetObjectDefMaxDistance(StartBerriesID, 15);
   rmAddObjectDefConstraint(StartBerriesID, avoidStartResource);
   rmAddObjectDefConstraint(StartBerriesID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(StartBerriesID, avoidNatives);
   rmAddObjectDefConstraint(StartBerriesID, shortPlayerConstraint);

   int startSilverID = rmCreateObjectDef("player silver");
   rmAddObjectDefItem(startSilverID, "mine", 1, 0);
   rmAddObjectDefConstraint(startSilverID, shortAvoidTradeRoute);
   rmSetObjectDefMinDistance(startSilverID, 14.0);
   rmSetObjectDefMaxDistance(startSilverID, 18.0);
   rmAddObjectDefConstraint(startSilverID, avoidAll);
   rmAddObjectDefConstraint(startSilverID, avoidImpassableLand);

   int startSilver2ID = rmCreateObjectDef("player second silver");
   rmAddObjectDefItem(startSilver2ID, "mine", 1, 0);
   rmAddObjectDefConstraint(startSilver2ID, shortAvoidTradeRoute);
   rmSetObjectDefMinDistance(startSilver2ID, 36.0);
   rmSetObjectDefMaxDistance(startSilver2ID, 42.0);
   rmAddObjectDefConstraint(startSilver2ID, avoidAll);
   rmAddObjectDefConstraint(startSilver2ID, avoidImpassableLand);
   rmAddObjectDefConstraint(startSilver2ID, avoidTownCenterMed);
   rmAddObjectDefConstraint(startSilver2ID, mediumAvoidSilver);
   if (cNumberNonGaiaPlayers == 2)
      rmAddObjectDefConstraint(startSilver2ID, centerConstraint);
   
   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 6.0);
   rmSetObjectDefMaxDistance(startingUnits, 12.0);
   rmAddObjectDefConstraint(startingUnits, avoidAll);
   rmAddObjectDefConstraint(startingUnits, avoidResource);
   rmAddObjectDefConstraint(startingUnits, avoidImpassableLand);

   int nearDeerID=rmCreateObjectDef("MuskDeer herds near town");
   rmAddObjectDefItem(nearDeerID, "ypMuskDeer", rmRandInt(7,7), 8.0);
   rmSetObjectDefMinDistance(nearDeerID, 14);
   rmSetObjectDefMaxDistance(nearDeerID, 18);
   rmAddObjectDefConstraint(nearDeerID, avoidAll);
   rmAddObjectDefConstraint(nearDeerID, avoidImpassableLand);
   rmSetObjectDefCreateHerd(nearDeerID, false);

   int farDeerID=rmCreateObjectDef("MuskDeer herds far away");
   rmAddObjectDefItem(farDeerID, "ypMuskDeer", rmRandInt(6,6), 8.0);
   rmSetObjectDefMinDistance(farDeerID, 35);
   rmSetObjectDefMaxDistance(farDeerID, 40);
   rmAddObjectDefConstraint(farDeerID, deerAvoidDeerShort);
   rmAddObjectDefConstraint(farDeerID, avoidAll);
   rmAddObjectDefConstraint(farDeerID, avoidTownCenterMed);
   rmAddObjectDefConstraint(farDeerID, avoidImpassableLand);
   rmAddObjectDefConstraint(farDeerID, playerEdgeConstraint);
   rmSetObjectDefCreateHerd(farDeerID, true);

// Text
      rmSetStatusText("",0.30);

   for(i=1; <cNumberPlayers)
   {
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
          
		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(StartBerriesID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(startSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(nearDeerID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(startSilver2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(farDeerID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));

    		if(ypIsAsian(i) && rmGetNomadStart() == false)
      		rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 0), i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}
	
   }

// Text`
	rmSetStatusText("",0.35);

// ***************** NATIVES ******************
   int nativePattern = rmRandInt(1,2);

   if (nativePattern == 1)
   {
      rmSetSubCiv(0, "Udasi");
      native1Name = "native udasi village ";
      rmSetSubCiv(1, "Bhakti");
      native2Name = "native bhakti village ";
   }
   else if (nativePattern == 2)
   {
      rmSetSubCiv(0, "Bhakti");
      native1Name = "native bhakti village ";
      rmSetSubCiv(1, "Udasi");
      native2Name = "native udasi village ";
   }


   // Village A 
   int villageAID = -1;
   int whichNative = rmRandInt(1,2);
   int villageType = rmRandInt(1,5);
   if (whichNative == 1)
	   villageAID = rmCreateGrouping("Udasi village A", native1Name+villageType);
   else if (whichNative == 2)
	   villageAID = rmCreateGrouping("Bhakti village A", native2Name+villageType);
   rmAddGroupingToClass(villageAID, rmClassID("natives"));
   rmAddGroupingToClass(villageAID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageAID, 0.0);
   rmSetGroupingMaxDistance(villageAID, rmXFractionToMeters(0.09));
   rmAddGroupingConstraint(villageAID, avoidImpassableLand);
   rmAddGroupingConstraint(villageAID, avoidTradeRouteFar);
   rmAddGroupingConstraint(villageAID, avoidTradeRouteSocketsFar);
   rmAddGroupingConstraint(villageAID, farAvoidNatives);
   rmAddGroupingConstraint(villageAID, avoidWater);
   rmAddGroupingConstraint(villageAID, mediumPlayerConstraint);

   // Village D - opposite type from A 
   int villageDID = -1;
   villageType = rmRandInt(1,5);
   if (whichNative == 2)
	   villageDID = rmCreateGrouping("Udasi village B", native1Name+villageType);
   else if (whichNative == 1)
	   villageDID = rmCreateGrouping("Bhakti village B", native2Name+villageType);
   rmAddGroupingToClass(villageDID, rmClassID("natives"));
   rmAddGroupingToClass(villageDID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageDID, 0.0);
   rmSetGroupingMaxDistance(villageDID, rmXFractionToMeters(0.09));
   rmAddGroupingConstraint(villageDID, avoidImpassableLand);
   rmAddGroupingConstraint(villageDID, avoidTradeRouteFar);
   rmAddGroupingConstraint(villageDID, avoidTradeRouteSocketsFar);
   rmAddGroupingConstraint(villageDID, farAvoidNatives);
   rmAddGroupingConstraint(villageDID, avoidWater);
   rmAddGroupingConstraint(villageDID, mediumPlayerConstraint);

   if (centerTradeRoute == 1)  
   {
      if (riverPlacement == 1)
      {
         rmPlaceGroupingAtLoc(villageAID, 0, 0.1, 0.715);
         rmPlaceGroupingAtLoc(villageAID, 0, 0.1, 0.285);

         rmPlaceGroupingAtLoc(villageDID, 0, 0.87, 0.67);
         rmPlaceGroupingAtLoc(villageDID, 0, 0.87, 0.33);
      }
      else if (riverPlacement == 2)  
      {
         rmPlaceGroupingAtLoc(villageAID, 0, 0.9, 0.715);
         rmPlaceGroupingAtLoc(villageAID, 0, 0.9, 0.285);

         rmPlaceGroupingAtLoc(villageDID, 0, 0.13, 0.67);
         rmPlaceGroupingAtLoc(villageDID, 0, 0.13, 0.33);
      }
   }
   else
   {
      if (riverPlacement == 1)
      {
         rmPlaceGroupingAtLoc(villageAID, 0, 0.1, 0.715);
         rmPlaceGroupingAtLoc(villageAID, 0, 0.1, 0.285);

	   if (cNumberTeams == 2)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.68, 0.5);
	      if (cNumberNonGaiaPlayers > 4)  
               rmPlaceGroupingAtLoc(villageDID, 0, 0.4, 0.5);
	   }
	   else
	   {
	      if(rmGetIsKOTH())
		   rmPlaceGroupingAtLoc(villageDID, 0, 0.9, 0.5);
		else
		   rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.5);
	   }	
      }
      else if (riverPlacement == 2)  
      {
         rmPlaceGroupingAtLoc(villageAID, 0, 0.9, 0.715);
         rmPlaceGroupingAtLoc(villageAID, 0, 0.9, 0.285);

	   if (cNumberTeams == 2)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.32, 0.5);
	      if (cNumberNonGaiaPlayers > 4)  
               rmPlaceGroupingAtLoc(villageDID, 0, 0.6, 0.5);
	   }
	   else
	   {
	      if(rmGetIsKOTH())
		   rmPlaceGroupingAtLoc(villageDID, 0, 0.1, 0.5);
		else
		   rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.5);
	   }		
      }
   }

// Text
	rmSetStatusText("",0.35);

// ********** KOTH game mode **********
   if(rmGetIsKOTH())
   {    
      float xLoc = rmRandFloat(0.45, 0.51); // if river placement is 2
      float yLoc = 0.5;
      float walk = 0.03;

	if (riverPlacement == 1)
	   xLoc = rmRandFloat(0.49, 0.55); 

	if (cNumberTeams > 2)
	{
	   xLoc = 0.5;
	   walk = 0.07;
	}
   
      ypKingsHillPlacer(xLoc, yLoc, walk, 0);
   }
	
// Text
	rmSetStatusText("",0.40);

// **************** TERRAIN PATCHES *******************
   for (i=0; < 6*cNumberNonGaiaPlayers)
   {
      int patch=rmCreateArea("first patch "+i);
      rmSetAreaWarnFailure(patch, false);
      rmSetAreaSize(patch, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
      rmSetAreaMix(patch, "mongolia_grass_b");
      rmAddAreaToClass(patch, rmClassID("classPatch"));
      rmSetAreaMinBlobs(patch, 1);
      rmSetAreaMaxBlobs(patch, 5);
      rmSetAreaMinBlobDistance(patch, 16.0);
      rmSetAreaMaxBlobDistance(patch, 40.0);
      rmSetAreaCoherence(patch, 0.0);
	rmAddAreaConstraint(patch, shortAvoidImpassableLand);
      rmBuildArea(patch); 
   }

   for (i=0; < 9*cNumberNonGaiaPlayers)
   {
      int dirtPatch=rmCreateArea("open dirt patch "+i);
      rmSetAreaWarnFailure(dirtPatch, false);
      rmSetAreaSize(dirtPatch, rmAreaTilesToFraction(50), rmAreaTilesToFraction(75));
      rmSetAreaMix(dirtPatch, "mongolia_grass_b");
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

// Text
	rmSetStatusText("",0.45);

// **************** Random silver mines ******************
   int silverType = rmRandInt(1,10);
   int silverNID = -1;
   int silverSID = -1;
   int silverCount = cNumberNonGaiaPlayers*2;	

   for(i=0; < cNumberNonGaiaPlayers)
   {
	silverNID = rmCreateObjectDef("north silver mines"+i);
	rmAddObjectDefItem(silverNID, "mine", rmRandInt(1,1), 5.0);
	rmSetObjectDefMinDistance(silverNID, 0.0);
	rmSetObjectDefMaxDistance(silverNID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(silverNID, avoidNatives);
	rmAddObjectDefConstraint(silverNID, avoidImpassableLand);
	rmAddObjectDefConstraint(silverNID, avoidSilver);
	rmAddObjectDefConstraint(silverNID, longPlayerConstraint);
	rmAddObjectDefConstraint(silverNID, avoidWater);
      rmAddObjectDefConstraint(silverNID, avoidAll);
      rmAddObjectDefConstraint(silverNID, Nconstraint);
	rmAddObjectDefConstraint(silverNID, shortAvoidTradeRoute);
	rmAddObjectDefConstraint(silverNID, avoidTradeRouteSockets);
	rmPlaceObjectDefAtLoc(silverNID, 0, 0.5, 0.75);
   } 

   for(i=0; < cNumberNonGaiaPlayers)
   {
	silverSID = rmCreateObjectDef("south silver mines"+i);
	rmAddObjectDefItem(silverSID, "mine", rmRandInt(1,1), 5.0);
	rmSetObjectDefMinDistance(silverSID, 0.0);
	rmSetObjectDefMaxDistance(silverSID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(silverSID, avoidNatives);
	rmAddObjectDefConstraint(silverSID, avoidImpassableLand);
	rmAddObjectDefConstraint(silverSID, avoidSilver);
	rmAddObjectDefConstraint(silverSID, longPlayerConstraint);
	rmAddObjectDefConstraint(silverSID, avoidWater);
      rmAddObjectDefConstraint(silverSID, avoidAll);
      rmAddObjectDefConstraint(silverSID, Sconstraint);
	rmAddObjectDefConstraint(silverSID, shortAvoidTradeRoute);
	rmAddObjectDefConstraint(silverSID, avoidTradeRouteSockets);
	rmPlaceObjectDefAtLoc(silverSID, 0, 0.5, 0.25);
   }

// Extra mines - at ends and far
   silverType = rmRandInt(1,10);
   int GoldFarID=rmCreateObjectDef("extra silver far");
   rmAddObjectDefItem(GoldFarID, "mine", 1, 0);
   rmAddObjectDefConstraint(GoldFarID, avoidImpassableLand);
   rmAddObjectDefConstraint(GoldFarID, shortAvoidTradeRoute);
   rmAddObjectDefConstraint(GoldFarID, avoidTradeRouteSockets);
   rmAddObjectDefConstraint(GoldFarID, avoidSilverLong);
   rmAddObjectDefConstraint(GoldFarID, shortAvoidImportantItem);
   rmAddObjectDefConstraint(GoldFarID, avoidWater);
   rmAddObjectDefConstraint(GoldFarID, avoidAll);
   rmAddObjectDefConstraint(GoldFarID, longPlayerConstraint);
   rmSetObjectDefMinDistance(GoldFarID, 0.0);
   rmSetObjectDefMaxDistance(GoldFarID, rmXFractionToMeters(0.4));
   rmPlaceObjectDefAtLoc(GoldFarID, 0, 0.05, 0.5);
   rmPlaceObjectDefAtLoc(GoldFarID, 0, 0.95, 0.5);
   if (cNumberNonGaiaPlayers > 3)
   {
      rmPlaceObjectDefAtLoc(GoldFarID, 0, 0.05, 0.5);
      rmPlaceObjectDefAtLoc(GoldFarID, 0, 0.95, 0.5);
   }
   if (cNumberNonGaiaPlayers > 5)
   {
      rmPlaceObjectDefAtLoc(GoldFarID, 0, 0.05, 0.5);
      rmPlaceObjectDefAtLoc(GoldFarID, 0, 0.95, 0.5);
      rmPlaceObjectDefAtLoc(GoldFarID, 0, 0.5, 0.5);
   }
   if (cNumberNonGaiaPlayers > 6)
   {
      rmPlaceObjectDefAtLoc(GoldFarID, 0, 0.5, 0.5);
      rmPlaceObjectDefAtLoc(GoldFarID, 0, 0.5, 0.5);
   }

// Text
	rmSetStatusText("",0.50);

// ************** WOOD RESOURCES ***************
// Extra tree clumps near players - to ensure fair access to wood
   int extraTreesID=rmCreateObjectDef("extra trees");
   rmAddObjectDefItem(extraTreesID, "ypTreeMongolia", 4, 5.0);
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
   rmAddObjectDefItem(extraTrees2ID, "ypTreeMongolia", 4, 6.0);
   rmSetObjectDefMinDistance(extraTrees2ID, 23);
   rmSetObjectDefMaxDistance(extraTrees2ID, 27);
   rmAddObjectDefConstraint(extraTrees2ID, avoidAll);
   rmAddObjectDefConstraint(extraTrees2ID, avoidCoin);
   rmAddObjectDefConstraint(extraTrees2ID, avoidTradeRouteSockets);
   rmAddObjectDefConstraint(extraTrees2ID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraTrees2ID, avoidTownCenterShort);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTrees2ID, 0, rmAreaID("player"+i), 1);

// Text
	rmSetStatusText("",0.60);

// Forests
   int numTries=10*cNumberNonGaiaPlayers;  
   int failCount=0;
   for (i=0; <numTries)
   {   
	int forestID=rmCreateArea("forest"+i);
	rmSetAreaWarnFailure(forestID, false);
	rmSetAreaSize(forestID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
	rmSetAreaForestType(forestID, "Mongolian Forest");
	rmSetAreaForestDensity(forestID, 0.8);
	rmSetAreaForestClumpiness(forestID, 0.0);		
	rmSetAreaForestUnderbrush(forestID, 0.0);
	rmSetAreaMinBlobs(forestID, 1);
	rmSetAreaMaxBlobs(forestID, 3);				
	rmSetAreaMinBlobDistance(forestID, 12.0);
	rmSetAreaMaxBlobDistance(forestID, 14.0);
	rmSetAreaCoherence(forestID, 0.4);
	rmSetAreaSmoothDistance(forestID, 10);
	rmAddAreaConstraint(forestID, avoidNatives);		 
	rmAddAreaConstraint(forestID, mediumPlayerConstraint);  
	rmAddAreaConstraint(forestID, shortAvoidTrees);   
	rmAddAreaConstraint(forestID, shortAvoidResource);			
	rmAddAreaConstraint(forestID, shortAvoidTradeRoute);
	rmAddAreaConstraint(forestID, avoidTradeRouteSockets);
	rmAddAreaConstraint(forestID, avoidCoinShort);
	rmAddAreaConstraint(forestID, shortAvoidImportantItem);
	rmAddAreaConstraint(forestID, avoidAll);
	if(rmBuildArea(forestID)==false)
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

// *********** HUNTABLES ************
   int deerID=rmCreateObjectDef("Saiga herd");
   rmAddObjectDefItem(deerID, "ypSaiga", rmRandInt(8,10), 6.0);
   rmSetObjectDefCreateHerd(deerID, true);
   rmSetObjectDefMinDistance(deerID, 0.0);
   rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.45));
   rmAddObjectDefConstraint(deerID, avoidResource);
   rmAddObjectDefConstraint(deerID, longPlayerConstraint);
   rmAddObjectDefConstraint(deerID, avoidImpassableLand);
   rmAddObjectDefConstraint(deerID, deerAvoidDeer);
   rmAddObjectDefConstraint(deerID, avoidNatives);
   rmAddObjectDefConstraint(deerID, avoidAll);
   rmAddObjectDefConstraint(deerID, avoidTradeRouteSockets);
   rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);

// Text
	rmSetStatusText("",0.75);

// ******************** TREASURES *******************
   int nugget1= rmCreateObjectDef("nugget easy"); 
   rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(1, 1);
   rmAddObjectDefToClass(nugget1, rmClassID("classNugget"));
   rmAddObjectDefConstraint(nugget1, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget1, shortAvoidImportantItem);
   rmAddObjectDefConstraint(nugget1, avoidResource);
   rmAddObjectDefConstraint(nugget1, avoidNuggetFar);
   rmAddObjectDefConstraint(nugget1, shortAvoidTradeRoute);
   rmAddObjectDefConstraint(nugget1, avoidTradeRouteSockets);
   rmAddObjectDefConstraint(nugget1, mediumPlayerConstraint);
   rmAddObjectDefConstraint(nugget1, longEdgeConstraint);
   rmAddObjectDefConstraint(nugget1, avoidAll);
   rmSetObjectDefMinDistance(nugget1, 40.0);
   rmSetObjectDefMaxDistance(nugget1, 60.0);
   rmPlaceObjectDefPerPlayer(nugget1, false, 2);

   int nugget2= rmCreateObjectDef("nugget medium"); 
   rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(2, 2);
   rmAddObjectDefToClass(nugget2, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget2, 0.0);
   rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(nugget2, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget2, shortAvoidImportantItem);
   rmAddObjectDefConstraint(nugget2, avoidResource);
   rmAddObjectDefConstraint(nugget2, avoidNuggetFar);
   rmAddObjectDefConstraint(nugget2, shortAvoidTradeRoute);
   rmAddObjectDefConstraint(nugget2, avoidTradeRouteSockets);
   rmAddObjectDefConstraint(nugget2, mediumPlayerConstraint);
   rmAddObjectDefConstraint(nugget1, longEdgeConstraint);
   rmAddObjectDefConstraint(nugget2, avoidAll);
   rmSetObjectDefMinDistance(nugget2, 80.0);
   rmSetObjectDefMaxDistance(nugget2, 120.0);
   rmPlaceObjectDefPerPlayer(nugget2, false, 1);

// Text
	rmSetStatusText("",0.80);

   int nugget3= rmCreateObjectDef("nugget hard"); 
   rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(3, 3);
   rmAddObjectDefToClass(nugget3, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget3, 0.05);
   rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.25));
   rmAddObjectDefConstraint(nugget3, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget3, shortAvoidImportantItem);
   rmAddObjectDefConstraint(nugget3, avoidResource);
   rmAddObjectDefConstraint(nugget3, avoidNuggetFar);
   rmAddObjectDefConstraint(nugget3, shortAvoidTradeRoute);
   rmAddObjectDefConstraint(nugget3, avoidTradeRouteSockets);
   rmAddObjectDefConstraint(nugget3, mediumPlayerConstraint);
   rmAddObjectDefConstraint(nugget1, longEdgeConstraint);
   rmAddObjectDefConstraint(nugget3, avoidAll);
   rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

   int nugget4= rmCreateObjectDef("nugget nuts"); 
   rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(4, 4);
   rmAddObjectDefToClass(nugget4, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget4, 0.0);
   rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.2));
   rmAddObjectDefConstraint(nugget4, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget4, shortAvoidImportantItem);
   rmAddObjectDefConstraint(nugget4, avoidResource);
   rmAddObjectDefConstraint(nugget4, avoidNuggetFar);
   rmAddObjectDefConstraint(nugget4, shortAvoidTradeRoute);
   rmAddObjectDefConstraint(nugget4, avoidTradeRouteSockets);
   rmAddObjectDefConstraint(nugget4, mediumPlayerConstraint);
   rmAddObjectDefConstraint(nugget1, longEdgeConstraint);

   rmAddObjectDefConstraint(nugget4, avoidAll);
   rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, rmRandInt(2,3));

// ****************** Yaks *******************
   int herdableID=rmCreateObjectDef("Yak");
   rmAddObjectDefItem(herdableID, "ypYak", 2, 4.0);
   rmSetObjectDefMinDistance(herdableID, 0.0);
   rmSetObjectDefMaxDistance(herdableID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(herdableID, avoidLlama);
   rmAddObjectDefConstraint(herdableID, avoidAll);
   rmAddObjectDefConstraint(herdableID, playerConstraint);
   rmAddObjectDefConstraint(herdableID, avoidImpassableLand);
   rmPlaceObjectDefAtLoc(herdableID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);


// Text
	rmSetStatusText("",0.99);	  
}  
