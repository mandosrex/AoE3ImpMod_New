// Sierra del Oro - Gold Mountains
// a map for AOE3: TWC 
// by RF_Gandalf

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
// Text
   rmSetStatusText("",0.01);

// Set up for variables
   string baseType = "";
   string cliffType = "";
   string forestType = "";
   string treeType = "";
   string tree2Type = "";
   string deerType = "";
   string deer2Type = "";
   string sheepType = "";
   string centerHerdType = "";
   string native1Name = "";
   string native2Name = "";

// Pick pattern for trees, terrain, features, etc.
   int handedness = rmRandInt(1,2);
   int patternChance = rmRandInt(1,2);   
   int variantChance = rmRandInt(1,2);
   int socketPattern = rmRandInt(1,2);   
   int nativePattern = rmRandInt(1,2);
   int endPosition = rmRandInt(1,3);
   int sidePosition = rmRandInt(1,3);
   int sheepChance = rmRandInt(1,2);
   int makeCliffs = -1; 
   int cliffVariety = rmRandInt(1,2);
   int placeBerries = 1;
   int forestDist = rmRandInt(12,18);
   int circChance = rmRandInt(1,5);
   int placeCircular = 0;
   int playerSide = rmRandInt(1,2);   
   int twoChoice = rmRandInt(1,2);
   int threeChoice = rmRandInt(1,3);
   int fourChoice = rmRandInt(1,4);
   int fiveChoice = rmRandInt(1,5);
   int placeGold = rmRandInt(1,5);
   int coverUp = 0;
   int trPattern = rmRandInt(1,2);

// Picks the map size
   int playerTiles = 15500;
   if (cNumberNonGaiaPlayers >6)
	playerTiles = 12000;
   else if (cNumberNonGaiaPlayers >4)
      playerTiles = 13500;
   else if (cNumberNonGaiaPlayers >2)
      playerTiles = 14500;			

   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

// Elevation
   rmSetSeaLevel(6.0);

// Picks default terrain and water

//   handedness = 2;
//   patternChance = 1;

   if (patternChance == 1) // texas desert
   {   
      rmSetMapType("australia");
	rmSetMapType("desert");
          rmSetLightingSet("pampas");
      baseType = "painteddesert_groundmix_2";
	forestType = "pampas forest";
      cliffType = "Painteddesert";
	treeType = "TreePampas";
	tree2Type = "TreeSonora";
      if (variantChance == 1)
	{
         deerType = "Kangaroo";
         deer2Type = "Wombat";
         centerHerdType = "Kangaroo";         
	}
      else 
	{     
         deerType = "Wombat";
         deer2Type = "Kangaroo";
         centerHerdType = "Kangaroo";         
	}
      if (sheepChance == 1)
         sheepType = "sheep";
      else
         sheepType = "cow";
	coverUp = 1;
   }
   else if (patternChance == 2) // sonora
   {   
      rmSetMapType("australia");
	rmSetMapType("desert");
          rmSetLightingSet("pampas");
      baseType = "painteddesert_groundmix_2";
	forestType = "pampas forest";
      cliffType = "Painteddesert";
	treeType = "TreePampas";
	tree2Type = "TreeSonora";
      if (variantChance == 1)
	{
         deerType = "Kangaroo";
         deer2Type = "Wombat";
         centerHerdType = "Kangaroo";         
	}
      else 
	{     
         deerType = "Kangaroo";
         deer2Type = "Kangaroo";
         centerHerdType = "Wombat";         
	}
      if (sheepChance == 1)
         sheepType = "sheep";
      else
         sheepType = "cow";
	coverUp = 1;
   }

   rmEnableLocalWater(false);
   rmTerrainInitialize("painteddesert\pd_ground_diffuse_e", 2.0);
   rmSetBaseTerrainMix(baseType);
   rmSetMapType("land");
   rmSetWorldCircleConstraint(true);
   rmSetWindMagnitude(2.0);


  if (nativePattern == 1)
  {
      rmSetSubCiv(0, "Jesuit");
      native1Name = "native jesuit mission america 0";
      rmSetSubCiv(1, "Jesuit");
      native2Name = "native jesuit mission america 0";
  }
  else if (nativePattern == 2)
  {
      rmSetSubCiv(0, "Jesuit");
      native1Name = "native jesuit mission america 0";
      rmSetSubCiv(1, "Jesuit");
      native2Name = "native jesuit mission america 0";
  }


// =================================================================================================================

   chooseMercs();

// Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classCliff");
   int classbigContinent=rmDefineClass("big continent");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("classInvis");
   rmDefineClass("inland");
   int classHuntable=rmDefineClass("huntableFood");  

// ----------------------------------Define constraints

   // Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 20.0);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("continent stays away from players", classPlayer, rmXFractionToMeters(0.15));
   int farPlayerConstraint=rmCreateClassDistanceConstraint("stay far away from players", classPlayer, 70.0);
   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360)); 
   
   // Area constraints
   int invisConstraint=rmCreateClassDistanceConstraint("continent avoid invis continent", rmClassID("classInvis"), rmXFractionToMeters(0.18));
   if (cNumberNonGaiaPlayers >6)
      invisConstraint=rmCreateClassDistanceConstraint("continent avoid invis continent large map", rmClassID("classInvis"), rmXFractionToMeters(0.20));
   int inlandConstraint=rmCreateClassDistanceConstraint("avoid inland area", rmClassID("inland"), rmXFractionToMeters(0.22));
   int bigContinentConstraint=rmCreateClassDistanceConstraint("avoid continent long", classbigContinent, 16.0);
   int shortContinentConstraint=rmCreateClassDistanceConstraint("avoid continent short", classbigContinent, 10.0);

   // Resource avoidance
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 20.0);
   int avoidDeer=rmCreateTypeDistanceConstraint("deer avoids deer", "deer", 40.0);
   int avoidBerries=rmCreateTypeDistanceConstraint("berry vs berry", "berryBush", 60.0);
   int avoidSheep=rmCreateTypeDistanceConstraint("sheep avoids sheep", "sheep", 40.0);
   int avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", 30.0);
   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "abstractNugget", 30.0);
   int huntableConstraint=rmCreateClassDistanceConstraint("huntable constraint", rmClassID("huntableFood"), 35.0);
   int longHuntableConstraint=rmCreateClassDistanceConstraint("long huntable constraint", rmClassID("huntableFood"), 50.0);

   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 20.0);
   if (cNumberNonGaiaPlayers < 3)
	longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land small map", "Land", false, 12.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 4.0);

   // Cliff constraints
   int avoidCliffs=rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 25.0);
   int cliffsAvoidCliffs=rmCreateClassDistanceConstraint("cliffs vs. cliffs", rmClassID("classCliff"), 16.0);
   int avoidCliffsShort=rmCreateClassDistanceConstraint("stuff vs. cliff short", rmClassID("classCliff"), 8.0);
   
   // Unit avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 4.0);
   int TCvsTC=rmCreateTypeDistanceConstraint("TC avoid same", "TownCenter", 50.0);
   int CWvsCW=rmCreateTypeDistanceConstraint("CW avoid same", "CoveredWagon", 50.0);
   int forestvsTC=rmCreateTypeDistanceConstraint("forest vs. TC", "TownCenter", 35.0);
   int forestvsCW=rmCreateTypeDistanceConstraint("forest vs. CW", "CoveredWagon", 35.0);
   int avoidTC=rmCreateTypeDistanceConstraint("stuff vs TC", "TownCenter", 60.0);
   int shortAvoidTC=rmCreateTypeDistanceConstraint("stuff less vs TC", "TownCenter", 20.0);
   int shortestAvoidTC=rmCreateTypeDistanceConstraint("stuff least vs TC", "TownCenter", 14.0);
   int avoidCW=rmCreateTypeDistanceConstraint("stuff vs CW", "CoveredWagon", 60.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 50.0);
   int avoidNativesMed=rmCreateClassDistanceConstraint("stuff avoids natives medium", rmClassID("natives"), 25.0);

   // Important object avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
   int nativeAvoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 20.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("sockets avoid each other", rmClassID("importantItem"), 15.0);
   int silverAvoidImportantItem=rmCreateClassDistanceConstraint("silver avoids sockets", rmClassID("importantItem"), 12.0);

// Text
   rmSetStatusText("",0.10);

// Player placement
   if (handedness == 1)  // NW cliffs
   {
	// If only 2 players place as 2 points
	if(cNumberNonGaiaPlayers == 2)
	{
		rmPlacePlayer(1, 0.87, 0.53);
		rmPlacePlayer(2, 0.13, 0.53);
	}
	// Place by team if 2 teams and sane teams
	else if(cNumberTeams == 2 && rmGetNumberPlayersOnTeam(0) < 5 && rmGetNumberPlayersOnTeam(1) < 5)
	{
	   if (cNumberNonGaiaPlayers < 5)
	   {
		rmSetPlacementTeam(0);
		rmSetPlacementSection(0.26, 0.40);
		rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
		rmSetPlacementTeam(1);
		rmSetPlacementSection(0.60, 0.74);
		rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
	   }
	   else
	   {
		rmSetPlacementTeam(0);
		rmSetPlacementSection(0.22, 0.42);
		rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
		rmSetPlacementTeam(1);
		rmSetPlacementSection(0.58, 0.78);
		rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
	   }
	}
	// otherwise just place in one arc FFA style
	else
	{
		rmSetPlacementSection(0.27, 0.72);
		rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
	}
   }
   else // NE cliffs
   {
	// If only 2 players place as 2 points
	if(cNumberNonGaiaPlayers == 2)
	{
		rmPlacePlayer(1, 0.47, 0.87);
		rmPlacePlayer(2, 0.47, 0.13);
	}
	// Place by team if 2 teams and sane teams
	else if(cNumberTeams == 2 && rmGetNumberPlayersOnTeam(0) < 5 && rmGetNumberPlayersOnTeam(1) < 5)
	{
	   if (cNumberNonGaiaPlayers < 5)
	   {
		rmSetPlacementTeam(0);
		rmSetPlacementSection(0.85, 0.0);
		rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
		rmSetPlacementTeam(1);
		rmSetPlacementSection(0.50, 0.65);
		rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
	   }
	   else
	   {
		rmSetPlacementTeam(0);
		rmSetPlacementSection(0.82, 0.02);
		rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
		rmSetPlacementTeam(1);
		rmSetPlacementSection(0.48, 0.68);
		rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
	   }
	}
	// otherwise just place in one arc FFA style
	else
	{
		rmSetPlacementSection(0.46, 0.02);
		rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
	}
   }

// Set up player areas.
   float playerFraction=rmAreaTilesToFraction(1200);
   for(i=1; <cNumberPlayers)
   {
      int id=rmCreateArea("Player"+i);
      rmSetPlayerArea(i, id);
	rmSetAreaWarnFailure(id, false);
      rmSetAreaSize(id, playerFraction, playerFraction);
	rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmAddAreaConstraint(id, playerConstraint);
      rmSetAreaLocPlayer(id, i);
	rmSetAreaCoherence(id, 0.9);
   }
   rmBuildAllAreas();

// Text
   rmSetStatusText("",0.25);

// Invisible continent added to have big continent avoid cliffs
   int invisContinentID=rmCreateArea("invisible continent for constraint");
   rmSetAreaSize(invisContinentID, 0.01, 0.01);
   rmSetAreaWarnFailure(invisContinentID, false);
   if (handedness == 1) // NW cliffs
   {
	rmSetAreaLocation(invisContinentID, 0.5, 0.89);
	rmAddAreaInfluenceSegment(invisContinentID, 0.5, 0.99, 0.3, 0.8);
	rmAddAreaInfluenceSegment(invisContinentID, 0.5, 0.99, 0.7, 0.8);
	rmAddAreaInfluenceSegment(invisContinentID, 0.5, 0.99, 0.5, 0.65);
   }
   else // NE cliffs
   {			
	rmSetAreaLocation(invisContinentID, 0.89, 0.5);
	rmAddAreaInfluenceSegment(invisContinentID, 0.99, 0.5, 0.8, 0.30);
	rmAddAreaInfluenceSegment(invisContinentID, 0.99, 0.5, 0.8, 0.70);
	rmAddAreaInfluenceSegment(invisContinentID, 0.99, 0.5, 0.65, 0.5);
   }
   rmAddAreaToClass(invisContinentID, rmClassID("classInvis"));
   rmSetAreaCoherence(invisContinentID, 0.8);
   rmBuildArea(invisContinentID);

// Text
   rmSetStatusText("",0.35); 

// Build up big continent called "big continent"
   int bigContinentID = -1;
   bigContinentID=rmCreateArea("big continent");
   rmSetAreaSize(bigContinentID, 0.42, 0.46); 
   rmSetAreaWarnFailure(bigContinentID, false);
   rmAddAreaConstraint(bigContinentID, invisConstraint);
   rmAddAreaToClass(bigContinentID, classbigContinent);
   rmSetAreaMinBlobs(bigContinentID, 10);
   rmSetAreaMaxBlobs(bigContinentID, 10);
   rmSetAreaMinBlobDistance(bigContinentID, rmXFractionToMeters(0.1));
   rmSetAreaMaxBlobDistance(bigContinentID, rmXFractionToMeters(0.4));
   rmSetAreaSmoothDistance(bigContinentID, 30);
   rmSetAreaMix(bigContinentID, baseType);
   rmSetAreaCoherence(bigContinentID, 0.5);
   // CHOOSE RIGHT OR LEFT-HANDED CLIFF AREA
   if (handedness == 1) // NW cliffs
   {
      rmSetAreaLocation(bigContinentID, 0.5, 0.25);
	rmAddAreaInfluenceSegment(bigContinentID, 0.0, 0.5, 1.0, 0.5); 
	rmAddAreaInfluenceSegment(bigContinentID, 0.5, 0.0, 0.5, 0.4);
   }
   else // NE cliffs
   {
      rmSetAreaLocation(bigContinentID, 0.25, 0.5);
	rmAddAreaInfluenceSegment(bigContinentID, 0.5, 0.0, 0.5, 1.0); 
	rmAddAreaInfluenceSegment(bigContinentID, 0.0, 0.5, 0.4, 0.5);
   }
   rmSetAreaEdgeFilling(bigContinentID, 10);
   rmSetAreaObeyWorldCircleConstraint(bigContinentID, false);
   rmBuildArea(bigContinentID);

// Invisible inland area
   int inlandID=rmCreateArea("invisible inland area");
   rmSetAreaSize(inlandID, 0.05, 0.05);
   rmSetAreaWarnFailure(inlandID, false);
   if (handedness == 1) // NW cliffs
   {
	rmSetAreaLocation(inlandID, 0.5, 0.03);
   }
   else // NE cliffs
   {			
	rmSetAreaLocation(inlandID, 0.03, 0.5);
   }
   rmAddAreaToClass(inlandID, rmClassID("inland"));
   rmSetAreaCoherence(inlandID, 0.8);
   rmBuildArea(inlandID);

// Text
   rmSetStatusText("",0.40);

// TRADE ROUTES
if (trPattern == 1)
{
   int tradeRouteID = rmCreateTradeRoute();
   vector tradeRoutePoint = cOriginVector;

   if (handedness == 1) // cliffs to NW
   {
	tradeRoutePoint = rmFindClosestPoint(0.05, 0.3, 20.0);
	rmAddTradeRouteWaypoint(tradeRouteID, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)));

	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.5, 6, 6);

	tradeRoutePoint = rmFindClosestPoint(0.95, 0.3, 20.0);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)), 4, 6);
   }
   else // cliffs to NE
   {
	tradeRoutePoint = rmFindClosestPoint(0.3, 0.05, 20.0);
	rmAddTradeRouteWaypoint(tradeRouteID, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)));

	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.5, 6, 6);
	tradeRoutePoint = rmFindClosestPoint(0.3, 0.95, 20.0);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)), 4, 6);
   } 

   bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route");  
}
else if (trPattern == 2)  // 2 side-to-side routes
{
   int tradeRouteID8A = rmCreateTradeRoute();
   if (handedness == 1) // cliffs to NW
   {
	tradeRoutePoint = rmFindClosestPoint(0.75, 1.0, 20.0);
	rmAddTradeRouteWaypoint(tradeRouteID8A, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)));

	rmAddRandomTradeRouteWaypoints(tradeRouteID8A, 0.68, 0.5, 6, 12);

	tradeRoutePoint = rmFindClosestPoint(0.61, 0.0, 20.0);
	rmAddRandomTradeRouteWaypoints(tradeRouteID8A, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)), 4, 6);
   }
   else  // NE cliffs
   {
	tradeRoutePoint = rmFindClosestPoint(1.0, 0.75, 20.0);
	rmAddTradeRouteWaypoint(tradeRouteID8A, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)));

	rmAddRandomTradeRouteWaypoints(tradeRouteID8A, 0.5, 0.68, 6, 12);

	tradeRoutePoint = rmFindClosestPoint(0.0, 0.61, 20.0);
	rmAddRandomTradeRouteWaypoints(tradeRouteID8A, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)), 4, 6);
   }
   rmBuildTradeRoute(tradeRouteID8A, "carolinas\trade_route");

   int tradeRouteID8B = rmCreateTradeRoute();
   if (handedness == 1) // cliffs to NW
   {
	tradeRoutePoint = rmFindClosestPoint(0.39, 0.0, 20.0);
	rmAddTradeRouteWaypoint(tradeRouteID8B, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)));

	rmAddRandomTradeRouteWaypoints(tradeRouteID8B, 0.32, 0.5, 6, 12);

	tradeRoutePoint = rmFindClosestPoint(0.25, 1.0, 20.0);
	rmAddRandomTradeRouteWaypoints(tradeRouteID8B, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)), 4, 6);
   }
   else // NE cliffs
   {
	tradeRoutePoint = rmFindClosestPoint(0.0, 0.39, 20.0);
	rmAddTradeRouteWaypoint(tradeRouteID8B, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)));

	rmAddRandomTradeRouteWaypoints(tradeRouteID8B, 0.5, 0.32, 6, 12);

	tradeRoutePoint = rmFindClosestPoint(1.0, 0.25, 20.0);
	rmAddRandomTradeRouteWaypoints(tradeRouteID8B, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)), 4, 6);
   }
   rmBuildTradeRoute(tradeRouteID8B, "dirt");
}

// Text
   rmSetStatusText("",0.45);

// Trade Route Sockets
   int socketID=rmCreateObjectDef("sockets for Trade Route");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
   rmSetObjectDefAllowOverlap(socketID, true);
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 8.0);
   variantChance = rmRandInt(1,2);
if (trPattern == 1)
{
   if (variantChance == 1)
   {  
      // add the sockets along the trade route.
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
      vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.19);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.39);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.61);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.81);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else
   {  
      // add the sockets along the trade route.
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.22);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.78);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
}
else if (trPattern == 2)
{
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID8A);
   if (variantChance == 1) // 3 sockets per route
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8A, 0.2);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8A, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8A, 0.8);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else  // 2 sockets per route
   {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8A, 0.2);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8A, 0.8);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }

   // change the trade route for the new sockets
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID8B);
   if (variantChance == 1) // 3 sockets per route
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8B, 0.2);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8B, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8B, 0.8);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else  // 2 sockets per route
   {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8B, 0.2);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8B, 0.8);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
}
   rmClearClosestPointConstraints();

// Text
   rmSetStatusText("",0.50); 
  
// PLAYER STARTING RESOURCES
   int TCID = rmCreateObjectDef("player TC");
   if ( rmGetNomadStart())
 	rmAddObjectDefItem(TCID, "coveredWagon", 1, 0);
   else
	rmAddObjectDefItem(TCID, "townCenter", 1, 0);
   rmSetObjectDefMinDistance(TCID, 0.0);
   rmSetObjectDefMaxDistance(TCID, 10.0);
   rmAddObjectDefConstraint(TCID, avoidTradeRoute);
   rmAddObjectDefConstraint(TCID, TCvsTC);
   rmAddObjectDefConstraint(TCID, CWvsCW);
   rmAddObjectDefConstraint(TCID, avoidImpassableLand);
   for(i=1; <cNumberPlayers)
   {
	rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
   }

   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 6.0);
   rmSetObjectDefMaxDistance(startingUnits, 10.0);
   rmAddObjectDefConstraint(startingUnits, avoidAll);
   rmAddObjectDefConstraint(startingUnits, shortAvoidImpassableLand);

   int playerSilverID = rmCreateObjectDef("player silver");
   rmAddObjectDefItem(playerSilverID, "mine", 1, 0);
   rmAddObjectDefConstraint(playerSilverID, avoidTradeRoute);
   rmSetObjectDefMinDistance(playerSilverID, 18.0);
   rmSetObjectDefMaxDistance(playerSilverID, 22.0);
   rmAddObjectDefConstraint(playerSilverID, avoidAll);
   rmAddObjectDefConstraint(playerSilverID, shortAvoidImpassableLand);

   int playerBerryID=rmCreateObjectDef("player berries");
   rmAddObjectDefItem(playerBerryID, "berryBush", rmRandInt(4,4), 2.0);
   rmSetObjectDefMinDistance(playerBerryID, 10);
   rmSetObjectDefMaxDistance(playerBerryID, 15);
   rmAddObjectDefConstraint(playerBerryID, avoidAll);
   rmAddObjectDefConstraint(playerBerryID, shortAvoidImpassableLand);

   int playerTreeID=rmCreateObjectDef("player trees");
   rmAddObjectDefItem(playerTreeID, treeType, 1, 0.0);
   rmSetObjectDefMinDistance(playerTreeID, 8);
   rmSetObjectDefMaxDistance(playerTreeID, 12);
   rmAddObjectDefConstraint(playerTreeID, avoidAll);
   rmAddObjectDefConstraint(playerTreeID, shortAvoidImpassableLand);
	 
// Text
   rmSetStatusText("",0.55); 

   // Nuggets per player
   int nugget1= rmCreateObjectDef("nugget easy"); 
   rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(1, 1);
   rmAddObjectDefConstraint(nugget1, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget1, avoidNugget);
   rmAddObjectDefConstraint(nugget1, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget1, avoidAll);
   rmAddObjectDefConstraint(nugget1, circleConstraint);
   rmSetObjectDefMinDistance(nugget1, 30.0);
   rmSetObjectDefMaxDistance(nugget1, 40.0);

   int nugget2= rmCreateObjectDef("nugget medium"); 
   rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(2, 2);
   rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget2, avoidNugget);
   rmAddObjectDefConstraint(nugget2, avoidTC);
   rmAddObjectDefConstraint(nugget2, avoidCW);
   rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget2, avoidAll);
   rmAddObjectDefConstraint(nugget2, circleConstraint);
   rmSetObjectDefMinDistance(nugget2, 40.0);
   rmSetObjectDefMaxDistance(nugget2, 55.0);

// Text
   rmSetStatusText("",0.60);
	
// FOOD	
   int nearDeerID=rmCreateObjectDef("deer herds near town");
   rmAddObjectDefItem(nearDeerID, deerType, rmRandInt(6,6), 8.0);
   rmAddObjectDefToClass(nearDeerID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(nearDeerID, 15);
   rmSetObjectDefMaxDistance(nearDeerID, 20);
   rmAddObjectDefConstraint(nearDeerID, huntableConstraint);
   rmAddObjectDefConstraint(nearDeerID, avoidAll);
   rmAddObjectDefConstraint(nearDeerID, avoidImpassableLand);
   rmSetObjectDefCreateHerd(nearDeerID, false);

   int farDeerID=rmCreateObjectDef("deer herds far away");
   int bonusChance=rmRandFloat(0, 1);
   if(bonusChance<0.5)   
      rmAddObjectDefItem(farDeerID, deer2Type, rmRandInt(7,7), 8.0);
   else
      rmAddObjectDefItem(farDeerID, deer2Type, rmRandInt(9,9), 10.0);
   rmAddObjectDefToClass(farDeerID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farDeerID, 40);
   rmSetObjectDefMaxDistance(farDeerID, 60);
   rmAddObjectDefConstraint(farDeerID, huntableConstraint);
   rmAddObjectDefConstraint(farDeerID, avoidAll);
   rmAddObjectDefConstraint(farDeerID, avoidTC);
   rmAddObjectDefConstraint(farDeerID, avoidCW);
   rmAddObjectDefConstraint(farDeerID, avoidImpassableLand);
   rmAddObjectDefConstraint(farDeerID, circleConstraint);
   rmSetObjectDefCreateHerd(farDeerID, true);
   
// Text
   rmSetStatusText("",0.65);

// Place player starting resources
   for(i=1; <cNumberPlayers)
   {
	vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
      vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));

	rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));	
	rmPlaceObjectDefAtLoc(playerBerryID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(playerSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(nugget1, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(nugget1, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(nugget2, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(nearDeerID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(farDeerID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

   }
   rmClearClosestPointConstraints();

// Oases       
   int numTrees = -1;
   int oasisTreesID=rmCreateObjectDef("oasis trees");
   rmAddObjectDefItem(oasisTreesID, treeType, 2, 3.0);
   rmSetObjectDefMinDistance(oasisTreesID, 0);
   rmSetObjectDefMaxDistance(oasisTreesID, 1);
   rmAddObjectDefConstraint(oasisTreesID, avoidAll);
   rmAddObjectDefConstraint(oasisTreesID, nativeAvoidTradeRouteSocket);
   rmAddObjectDefConstraint(oasisTreesID, avoidTradeRoute);
   rmAddObjectDefConstraint(oasisTreesID, shortAvoidTC);

   for(i=1; <cNumberPlayers)   
   {
	int smallPondID=rmCreateArea("Player"+i+"small pond", rmAreaID("Player"+i));
	rmSetAreaSize(smallPondID, rmAreaTilesToFraction(70), rmAreaTilesToFraction(90));
      rmSetAreaWaterType(smallPondID, "andes pond");
      rmSetAreaBaseHeight(smallPondID, 1);
	rmSetAreaHeightBlend(smallPondID, 3.0);
      rmSetAreaMinBlobs(smallPondID, 1);
      rmSetAreaMaxBlobs(smallPondID, 2);
      rmSetAreaMinBlobDistance(smallPondID, 5.0);
      rmSetAreaMaxBlobDistance(smallPondID, 9.0);
      rmAddAreaConstraint(smallPondID, shortestAvoidTC);
      rmAddAreaConstraint(smallPondID, avoidNativesMed);
      rmAddAreaConstraint(smallPondID, avoidTradeRoute);
      rmAddAreaConstraint(smallPondID, nativeAvoidTradeRouteSocket);
      rmAddAreaConstraint(smallPondID, avoidAll);
      rmSetAreaCoherence(smallPondID, rmRandFloat(0.7,0.9));
      rmSetAreaWarnFailure(smallPondID, false);
      rmBuildArea(smallPondID);

      numTrees = rmRandInt(12,15);
      for (j=0; <numTrees)   
         rmPlaceObjectDefInArea(oasisTreesID, 0, rmAreaID("Player"+i+"small pond"), rmRandInt(2,3));
   }

// Text
   rmSetStatusText("",0.70);

// Natives
   int villageType = rmRandInt(1,5); 
   int nativeType = rmRandInt(1,2); 
 
   int village1ID = -1;  //  edge center
   if (nativeType == 1) 
      village1ID = rmCreateGrouping("native village 1", native1Name+villageType);
   else
      village1ID = rmCreateGrouping("native village 1", native2Name+villageType);
   rmSetGroupingMinDistance(village1ID, 0.0);
   rmSetGroupingMaxDistance(village1ID, 30);
   rmAddGroupingConstraint(village1ID, avoidImpassableLand);
   rmAddGroupingToClass(village1ID, rmClassID("importantItem"));
   rmAddGroupingConstraint(village1ID, avoidTradeRoute);
   rmAddGroupingConstraint(village1ID, avoidImportantItem);
   rmAddGroupingConstraint(village1ID, nativeAvoidTradeRouteSocket);
   rmAddGroupingConstraint(village1ID, avoidTC);
   rmAddGroupingConstraint(village1ID, avoidCW);
   if (cNumberTeams == 2)
   {
      if (handedness == 1)
         rmPlaceGroupingAtLoc(village1ID, 0, 0.5, 0.07);
      else 
         rmPlaceGroupingAtLoc(village1ID, 0, 0.07, 0.5);
   }
   else  // away from edge to avoid middle player
   {
      if (handedness == 1)
         rmPlaceGroupingAtLoc(village1ID, 0, 0.5, 0.25);
      else 
         rmPlaceGroupingAtLoc(village1ID, 0, 0.25, 0.5);
   }

   int village2ID = -1;   // in mts
   villageType = rmRandInt(1,5);
   nativeType = rmRandInt(1,2); 
   if (nativeType == 1) 
      village2ID = rmCreateGrouping("native village 2", native1Name+villageType);
   else
      village2ID = rmCreateGrouping("native village 2", native2Name+villageType); 
   rmSetGroupingMinDistance(village2ID, 0.0);
   rmSetGroupingMaxDistance(village2ID, 40);
   rmAddGroupingConstraint(village2ID, avoidImpassableLand);
   rmAddGroupingToClass(village2ID, rmClassID("importantItem"));
   rmAddGroupingConstraint(village2ID, avoidTradeRoute);
   rmAddGroupingConstraint(village2ID, avoidImportantItem);
   rmAddGroupingConstraint(village2ID, nativeAvoidTradeRouteSocket);
   rmAddGroupingConstraint(village2ID, avoidTC);
   rmAddGroupingConstraint(village2ID, avoidCW);
   if (handedness == 1)
      rmPlaceGroupingAtLoc(village2ID, 0, 0.5, 0.75); 
   else 
      rmPlaceGroupingAtLoc(village2ID, 0, 0.75, 0.5); 
  
   int village3ID = -1;   // paired, away from mts
   villageType = rmRandInt(1,5);
   nativeType = rmRandInt(1,2); 
   if (nativeType == 1) 
      village3ID = rmCreateGrouping("native village 3", native1Name+villageType);
   else
      village3ID = rmCreateGrouping("native village 3", native2Name+villageType); 
   rmSetGroupingMinDistance(village3ID, 0.0);
   rmSetGroupingMaxDistance(village3ID, 45);
   rmAddGroupingConstraint(village3ID, avoidImpassableLand);
   rmAddGroupingToClass(village3ID, rmClassID("importantItem"));
   rmAddGroupingConstraint(village3ID, avoidTradeRoute);
   rmAddGroupingConstraint(village3ID, avoidImportantItem);
   rmAddGroupingConstraint(village3ID, nativeAvoidTradeRouteSocket);
   rmAddGroupingConstraint(village3ID, shortAvoidTC);
   if (handedness == 1)
   {
      rmPlaceGroupingAtLoc(village3ID, 0, 0.3, 0.38); 
      rmPlaceGroupingAtLoc(village3ID, 0, 0.7, 0.38);
   } 
   else
   {
      rmPlaceGroupingAtLoc(village3ID, 0, 0.38, 0.3);
	rmPlaceGroupingAtLoc(village3ID, 0, 0.38, 0.7);
   }  

   if (cNumberNonGaiaPlayers > 4) // extra near center for larger player numbers
   {
      if (handedness == 2)
      {
	   if (rmRandInt(1,2) == 1)
	      rmPlaceGroupingAtLoc(village1ID, 0, 0.58, 0.5);
	   else
	      rmPlaceGroupingAtLoc(village2ID, 0, 0.58, 0.5); 
      } 
      else
      {
	   if (rmRandInt(1,2) == 1)
	      rmPlaceGroupingAtLoc(village2ID, 0, 0.5, 0.58);
	   else
	      rmPlaceGroupingAtLoc(village1ID, 0, 0.5, 0.58); 
      }
   }

// Text
   rmSetStatusText("",0.75);

// Define Far Mines
   int farMineID = -1;
   farMineID = rmCreateObjectDef("silver "+i);
   rmAddObjectDefItem(farMineID, "minegold", 1, 0.0);
   rmSetObjectDefMinDistance(farMineID, 0.0);
   rmSetObjectDefMaxDistance(farMineID, 5.0);
   rmAddObjectDefConstraint(farMineID, avoidFastCoin);
   rmAddObjectDefConstraint(farMineID, avoidTradeRoute);

// Mountain Trees
   int StragglerTreeID=rmCreateObjectDef("straggler trees");
   rmAddObjectDefItem(StragglerTreeID, tree2Type, 1, 0.0);
   rmAddObjectDefConstraint(StragglerTreeID, avoidAll);
   rmSetObjectDefMinDistance(StragglerTreeID, 0);
   rmSetObjectDefMaxDistance(StragglerTreeID, 10);

// Mountain Rams
   int mtRamsID=rmCreateObjectDef("mountain rams");
   rmAddObjectDefItem(mtRamsID, "wombat", rmRandInt(2,3), 3.0);
   rmAddObjectDefToClass(mtRamsID, rmClassID("classHuntable"));
   rmSetObjectDefMinDistance(mtRamsID, 0);
   rmSetObjectDefMaxDistance(mtRamsID, 16);
   rmAddObjectDefConstraint(mtRamsID, avoidAll);
   rmSetObjectDefCreateHerd(mtRamsID, true);

// Text
   rmSetStatusText("",0.80); 

// Cliffs
   int cliffHt = -1;
   int failCount=0;
   int numCliffs = cNumberNonGaiaPlayers*2 + rmRandInt(2,3);
   for (i=0; <numCliffs)
   {
	cliffHt = rmRandInt(6,8);    
	int bigCliffID=rmCreateArea("big cliff" +i);
	rmSetAreaWarnFailure(bigCliffID, false);
	rmSetAreaCliffType(bigCliffID, cliffType);
	if (cliffVariety == 1) // like Patagonia
	{
   	   rmSetAreaSize(bigCliffID, rmAreaTilesToFraction(350), rmAreaTilesToFraction(700));
	   rmAddAreaToClass(bigCliffID, rmClassID("classCliff"));
         if (rmRandInt(1,2) == 1)
            rmSetAreaCliffEdge(bigCliffID, 2, 0.38, 0.1, 1.0, 0);
	   else
            rmSetAreaCliffEdge(bigCliffID, 3, 0.3, 0.1, 1.0, 0);
         rmSetAreaCliffPainting(bigCliffID, false, true, true, 1.5, true);
	   rmSetAreaCliffHeight(bigCliffID, cliffHt, 2.0, 0.5);
	   rmSetAreaCoherence(bigCliffID, 0.5);
	   rmSetAreaSmoothDistance(bigCliffID, 5);
	   rmSetAreaHeightBlend(bigCliffID, 1.0);
	   rmSetAreaMinBlobs(bigCliffID, 1);
	   rmSetAreaMaxBlobs(bigCliffID, 5);
	   rmSetAreaMinBlobDistance(bigCliffID, 6.0);
	   rmSetAreaMaxBlobDistance(bigCliffID, 20.0);
	}
	else  // kinda random, kinda like Texas or NE
	{
   	   rmSetAreaSize(bigCliffID, rmAreaTilesToFraction(350), rmAreaTilesToFraction(700));
	   rmAddAreaToClass(bigCliffID, rmClassID("classCliff"));
         if (rmRandInt(1,2) == 1)
	      rmSetAreaCliffEdge(bigCliffID, 1, 0.6, 0.2, 1.0, 0);
	   else
	      rmSetAreaCliffEdge(bigCliffID, 1, 0.8, 0.07, 1.0, 0);
	   rmSetAreaCliffPainting(bigCliffID, false, true, true, 1.5, true);
	   rmSetAreaCliffHeight(bigCliffID, cliffHt, 2.0, 1.0);
	   rmSetAreaCoherence(bigCliffID, rmRandFloat(0.4, 0.9));
	   rmSetAreaSmoothDistance(bigCliffID, 15);
	   rmSetAreaHeightBlend(bigCliffID, 1.0);
	   rmSetAreaMinBlobs(bigCliffID, 3);
	   rmSetAreaMaxBlobs(bigCliffID, 5);
	   rmSetAreaMinBlobDistance(bigCliffID, 6.0);
	   rmSetAreaMaxBlobDistance(bigCliffID, 20.0);
	}
	rmAddAreaConstraint(bigCliffID, avoidImportantItem);
	rmAddAreaConstraint(bigCliffID, avoidTradeRoute);
      rmAddAreaConstraint(bigCliffID, avoidNativesMed);
	rmAddAreaConstraint(bigCliffID, cliffsAvoidCliffs);
	rmAddAreaConstraint(bigCliffID, farPlayerConstraint);
	rmAddAreaConstraint(bigCliffID, bigContinentConstraint);
      rmAddAreaConstraint(bigCliffID, circleConstraint);
	rmBuildArea(bigCliffID);
      cliffVariety = rmRandInt(1,2);
      rmPlaceObjectDefInArea(farMineID, 0, rmAreaID("big cliff" +i), 2);
      rmPlaceObjectDefInArea(StragglerTreeID, 0, rmAreaID("big cliff" +i), rmRandInt(2,5));
	if (rmRandInt(1,3) > 1)
         rmPlaceObjectDefInArea(mtRamsID, 0, rmAreaID("big cliff" +i));
   }

   numCliffs = cNumberNonGaiaPlayers + rmRandInt(4,6);
   for (i=0; <numCliffs)
   {
	cliffHt = rmRandInt(5,7);    
	int lilCliffID=rmCreateArea("little cliff" +i);
	rmSetAreaWarnFailure(lilCliffID, false);
	rmSetAreaCliffType(lilCliffID, cliffType);
	if (cliffVariety == 1) // like Patagonia
	{
   	   rmSetAreaSize(lilCliffID, rmAreaTilesToFraction(250), rmAreaTilesToFraction(400));
	   rmAddAreaToClass(lilCliffID, rmClassID("classCliff"));
         if (rmRandInt(1,2) == 1)
            rmSetAreaCliffEdge(lilCliffID, 2, 0.38, 0.1, 1.0, 0);
	   else
            rmSetAreaCliffEdge(lilCliffID, 3, 0.3, 0.1, 1.0, 0);
         rmSetAreaCliffPainting(lilCliffID, false, true, true, 1.5, true);
	   rmSetAreaCliffHeight(lilCliffID, cliffHt, 2.0, 0.5);
	   rmSetAreaCoherence(lilCliffID, 0.5);
	   rmSetAreaSmoothDistance(lilCliffID, 5);
	   rmSetAreaHeightBlend(lilCliffID, 1.0);
	   rmSetAreaMinBlobs(lilCliffID, 1);
	   rmSetAreaMaxBlobs(lilCliffID, 5);
	   rmSetAreaMinBlobDistance(lilCliffID, 6.0);
	   rmSetAreaMaxBlobDistance(lilCliffID, 10.0);
	}
	else  // kinda random, kinda like Texas or NE
	{
   	   rmSetAreaSize(lilCliffID, rmAreaTilesToFraction(250), rmAreaTilesToFraction(400));
	   rmAddAreaToClass(lilCliffID, rmClassID("classCliff"));
         if (rmRandInt(1,2) == 1)
	      rmSetAreaCliffEdge(lilCliffID, 1, 0.6, 0.2, 1.0, 0);
	   else
	      rmSetAreaCliffEdge(lilCliffID, 1, 0.8, 0.07, 1.0, 0);
	   rmSetAreaCliffPainting(lilCliffID, false, true, true, 1.5, true);
	   rmSetAreaCliffHeight(lilCliffID, cliffHt, 2.0, 1.0);
	   rmSetAreaCoherence(lilCliffID, rmRandFloat(0.4, 0.9));
	   rmSetAreaSmoothDistance(lilCliffID, 15);
	   rmSetAreaHeightBlend(lilCliffID, 1.0);
	   rmSetAreaMinBlobs(lilCliffID, 3);
	   rmSetAreaMaxBlobs(lilCliffID, 5);
	   rmSetAreaMinBlobDistance(lilCliffID, 6.0);
	   rmSetAreaMaxBlobDistance(lilCliffID, 10.0);
	}
	rmAddAreaConstraint(lilCliffID, avoidImportantItem);
	rmAddAreaConstraint(lilCliffID, avoidTradeRoute);
      rmAddAreaConstraint(lilCliffID, avoidNativesMed);
	rmAddAreaConstraint(lilCliffID, cliffsAvoidCliffs);
	rmAddAreaConstraint(lilCliffID, shortContinentConstraint);
      rmAddAreaConstraint(lilCliffID, circleConstraint);
	rmBuildArea(lilCliffID);
      cliffVariety = rmRandInt(1,2);
      rmPlaceObjectDefInArea(StragglerTreeID, 0, rmAreaID("little cliff" +i), rmRandInt(2,5));
	if (rmRandInt(1,3) > 1)
         rmPlaceObjectDefInArea(mtRamsID, 0, rmAreaID("little cliff" +i));
	if (rmRandInt(1,3) == 1)
         rmPlaceObjectDefInArea(farMineID, 0, rmAreaID("little cliff" +i));
   }

// Text
   rmSetStatusText("",0.85);

// Place extra nuggets not per player
   int nugget3= rmCreateObjectDef("nugget hard"); 
   rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(3, 3);
   rmSetObjectDefMinDistance(nugget3, 0.0);
   rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(nugget3, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget3, avoidNugget);
   rmAddObjectDefConstraint(nugget3, avoidTC);
   rmAddObjectDefConstraint(nugget3, avoidCW);
   rmAddObjectDefConstraint(nugget3, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget3, avoidAll);
   rmAddObjectDefConstraint(nugget3, circleConstraint);
   rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

   int nugget4= rmCreateObjectDef("nugget nuts"); 
   rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(4, 4);
   rmSetObjectDefMinDistance(nugget4, 0.0);
   rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.12));
   rmAddObjectDefConstraint(nugget4, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget4, avoidNugget);
   rmAddObjectDefConstraint(nugget4, avoidTC);
   rmAddObjectDefConstraint(nugget4, bigContinentConstraint);
   rmAddObjectDefConstraint(nugget4, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget4, avoidAll);
   rmAddObjectDefConstraint(nugget4, circleConstraint);
   rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, rmRandInt(1,2));

// Text
   rmSetStatusText("",0.90);

// FORESTS
   int forestTreeID = 0;
   int numTries=7*cNumberNonGaiaPlayers;
   if (cNumberNonGaiaPlayers == 3)
      numTries=6*cNumberNonGaiaPlayers;
   if (cNumberNonGaiaPlayers > 3)
      numTries=5*cNumberNonGaiaPlayers;
   failCount=0;
   for (i=0; <numTries)
   {   
      int forest=rmCreateArea("forest "+i, rmAreaID("big continent"));
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(220), rmAreaTilesToFraction(400));
      rmSetAreaForestType(forest, forestType);
      rmSetAreaForestDensity(forest, 0.8);
      rmSetAreaForestClumpiness(forest, rmRandFloat(0.5,0.8));
      rmSetAreaForestUnderbrush(forest, 0.0);
      rmSetAreaMinBlobs(forest, 1);
      rmSetAreaMaxBlobs(forest, 3);
      rmSetAreaMinBlobDistance(forest, 16.0);
      rmSetAreaMaxBlobDistance(forest, 70.0);
      rmSetAreaCoherence(forest, 0.4);
      rmSetAreaSmoothDistance(forest, 0);
      rmAddAreaToClass(forest, rmClassID("classForest")); 
      rmAddAreaConstraint(forest, forestConstraint);
      rmAddAreaConstraint(forest, avoidAll);
      rmAddAreaConstraint(forest, forestvsTC);
      rmAddAreaConstraint(forest, forestvsCW); 
      rmAddAreaConstraint(forest, longAvoidImpassableLand); 
      rmAddAreaConstraint(forest, avoidTradeRoute);
      rmAddAreaConstraint(forest, avoidCliffs);

      if(rmBuildArea(forest)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==5)
            break;
      }
      else
         failCount=0; 
   }

// far huntable
   int farHuntableID=rmCreateObjectDef("far huntable");
   rmAddObjectDefItem(farHuntableID, centerHerdType, rmRandInt(8,9), 6.0);
   rmAddObjectDefToClass(farHuntableID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farHuntableID, 0.25*size);
   rmSetObjectDefMaxDistance(farHuntableID, 0.35*size);
   rmAddObjectDefConstraint(farHuntableID, avoidImportantItem);
   rmAddObjectDefConstraint(farHuntableID, farPlayerConstraint);
   rmAddObjectDefConstraint(farHuntableID, longHuntableConstraint);
   rmAddObjectDefConstraint(farHuntableID, avoidAll);
   rmAddObjectDefConstraint(farHuntableID, avoidCliffs);
   rmSetObjectDefCreateHerd(farHuntableID, true);
   rmPlaceObjectDefPerPlayer(farHuntableID, true, 1);

// Sheep 
   int sheepID=rmCreateObjectDef("herdable animal");
   rmAddObjectDefItem(sheepID, sheepType, 2, 4.0);
   rmSetObjectDefMinDistance(sheepID, 45.0);
   rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.25));
   rmAddObjectDefConstraint(sheepID, avoidSheep);
   rmAddObjectDefConstraint(sheepID, avoidAll);
   rmAddObjectDefConstraint(sheepID, playerConstraint);
   rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
   rmAddObjectDefConstraint(sheepID, circleConstraint);
   if (rmRandInt(1,2) == 1)
      rmPlaceObjectDefPerPlayer(sheepID, false, 2);
   else 
      rmPlaceObjectDefPerPlayer(sheepID, false, 3);
   rmAddObjectDefConstraint(sheepID, farPlayerConstraint);
   rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.4));
   rmPlaceObjectDefPerPlayer(sheepID, false, rmRandInt(1,2));  

// Text
   rmSetStatusText("",0.95);

// Patch to cover forest floor, cliffs in some patterns
if (coverUp == 1)
{
   int desertID = rmCreateArea("desert");
   rmSetAreaLocation(desertID, 0.5, 0.5); 
   rmSetAreaWarnFailure(desertID, false);
   rmSetAreaSize(desertID, 0.99, 0.99);
   rmSetAreaCoherence(desertID, 0.99);
   rmSetAreaMix(desertID, baseType);
   rmBuildArea(desertID);

   int desert2ID = rmCreateArea("desert 2");
   rmSetAreaLocation(desert2ID, 0.5, 0.5); 
   rmSetAreaWarnFailure(desert2ID, false);
   rmSetAreaSize(desert2ID, 0.99, 0.99);
   rmSetAreaCoherence(desert2ID, 0.99);
   rmSetAreaMix(desert2ID, baseType);
   rmBuildArea(desert2ID);
}
  

// KOTH game mode 
   if(rmGetIsKOTH())
   {
      float xLoc = 0.5;
      float yLoc = 0.5;
      float walk = 0.05;
    
      ypKingsHillPlacer(xLoc, yLoc, walk, 0);
   }


// Text
   rmSetStatusText("",0.99);    
}  
