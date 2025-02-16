// Desert Flood
// a random map for AOE3:TAD
// original concept by Kastor
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
   string forestFloor = "";
   string cliffType = "";
   string forestType = "";
   string forest2Type = "";
   string treeType = "";
   string deerType = "";
   string deer2Type = "";
   string sheepType = "";
   string riverType = "";
   string centerHerdType = "";
   string native1Name = "";
   string native2Name = "";
   string patchMixType = "";
   string patchTerrainType = "";
   string patchTerrain2Type = "";
   string mineType = "";

// Pick pattern for trees, terrain, features, etc.
   int variantChance = rmRandInt(1,2);
   int lightingChance = rmRandInt(1,4);
   int nativeSetup = rmRandInt(1,4);
   int forestDist = rmRandInt(22,24);
   int sheepChance = rmRandInt(1,2);
   int twoChoice = rmRandInt(1,2);
   int placeGold = rmRandInt(1,3);
   int nativePattern = rmRandInt(1,2);

// Pick the map size
   int scalingNumber = 1;
   float scalingFactor = 0;
   int size = 1;
   int longSide = 1;

   if (cNumberNonGaiaPlayers == 2) 
   {   
      scalingNumber = 1;
      scalingFactor = 1.7;
      size = 260;
      longSide = 1.2*size;
   }	 
   else if (cNumberNonGaiaPlayers == 3)
   {
	scalingNumber = 2;
	scalingFactor = 2.0;
      size = 270;
      longSide = 1.4*size;
   }	
   else if (cNumberNonGaiaPlayers == 4)
   {
	scalingNumber = 2;
	scalingFactor = 2.2;
      size = 280;
      longSide = 1.6*size;
   }
   else if (cNumberNonGaiaPlayers == 5) 
   {
	scalingNumber = 3;
	scalingFactor = 2.5;
      size = 290;
      longSide = 1.8*size;
   }
   else if (cNumberNonGaiaPlayers == 6) 
   {
	scalingNumber = 3;
	scalingFactor = 2.8;
      size = 300;
      longSide = 2.0*size;
   }	
   else if (cNumberNonGaiaPlayers > 6)    // 7 or 8 players
   {
	scalingNumber = 4;
	scalingFactor = 3.1;
      size = 310;
      longSide = 2.3*size;
   }

   rmSetMapSize(size, longSide);

// Elevation
   rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);
   rmSetMapElevationHeightBlend(1.0);
   rmSetSeaLevel(0.0);

   // Text
   rmSetStatusText("",0.05);
	
// Pick terrain patterns and features 
   rmSetMapType("middleEast");
   rmSetMapType("grass");
   if (lightingChance == 1)
	rmSetLightingSet("pampas");
   else if (lightingChance == 2)
      rmSetLightingSet("pampas");
   else if (lightingChance == 3)  
      rmSetLightingSet("pampas");
   else
      rmSetLightingSet("pampas");
   baseType = "tigris2";
   riverType = "tigris";
   forestType = "nile palm forest";
   treeType = "TreeNile";
   cliffType = "Sonora";
   if (variantChance == 1)
   {
         deerType = "Crane";
         deer2Type = "Crane";
         centerHerdType = "Dromedary";
   }
   else 
   {     
         deerType = "Crane";
         deer2Type = "Crane";
         centerHerdType = "Dromedary";        
   }
   if (sheepChance == 1)
      sheepType = "ypGoat";
   else
      sheepType = "ypWaterBuffalo";

   if (placeGold == 1)
	mineType = "mineTin"; 
   else if (placeGold == 2)
	mineType = "mine"; 
   else if (placeGold == 3)
	mineType = "mineCopper"; 

   rmSetBaseTerrainMix("tigris2");
   rmTerrainInitialize("water", 2);
   rmEnableLocalWater(true);
   rmSetMapType("land");
   rmSetMapType("asia");

   rmSetWorldCircleConstraint(false);
   
   rmSetWindMagnitude(2.0); 
   chooseMercs();

// Native setup 
  if (nativePattern == 1)
  {
      rmSetSubCiv(0, "saltpeter");
      native1Name = "saltpeter_0";
      rmSetSubCiv(1, "sufi");
      native2Name = "native sufi mosque deccan ";
  }
  else if (nativePattern == 2)
  {
      rmSetSubCiv(0, "sufi");
      native1Name = "native sufi mosque deccan ";
      rmSetSubCiv(1, "saltpeter");
      native2Name = "saltpeter_0";
  }

// Define some classes.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classPatch");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
   rmDefineClass("classCliff");
   rmDefineClass("classNugget");
   rmDefineClass("socketClass");
   int classHuntable=rmDefineClass("huntableFood");   
   int classHerdable=rmDefineClass("herdableFood"); 

   // Text
   rmSetStatusText("",0.10);

// -------------Define constraints
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));

   int treeBoxConstraint=rmCreateBoxConstraint("trees close to river", 0.2, 0.0, 0.48, 1.0, 0.01);
   int treeBoxConstraint2=rmCreateBoxConstraint("trees not as close to river", 0.35, 0.0, 0.75, 1.0, 0.01);
   int forestBoxConstraint=rmCreateBoxConstraint("forest close to river", 0.2, 0.0, 0.65, 1.0, 0.01);
   int berryBoxConstraint=rmCreateBoxConstraint("berries in river", 0.02, 0.0, 0.25, 1.0, 0.01);
   int desertBoxConstraint=rmCreateBoxConstraint("objects in desert", 0.65, 0.0, 1.0, 1.0, 0.01);
   int desertBoxConstraint2=rmCreateBoxConstraint("objects in smaller desert area", 0.78, 0.0, 1.0, 1.0, 0.01);

   // Player constraints
   int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 15.0);
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 45.0);
   int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 20.0);
   int nuggetPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 60.0);
   int farPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players more", classPlayer, 85.0);
   int fartherPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players the most", classPlayer, 95.0);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 70.0); 

   // Nature avoidance
   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int shortForestConstraint=rmCreateClassDistanceConstraint("patch vs. forest", rmClassID("classForest"), 15.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), forestDist);
   int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 20.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 10.0);
   int shortAvoidSilver=rmCreateTypeDistanceConstraint("short gold avoid gold", "Mine", 20.0);
   int coinAvoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 35.0);
   int longAvoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin long", "gold", 50.0);
   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   int avoidSheep=rmCreateClassDistanceConstraint("sheep avoids sheep etc", rmClassID("herdableFood"), 45.0);
   int huntableConstraint=rmCreateClassDistanceConstraint("huntable constraint", rmClassID("huntableFood"), 35.0);
   int longHuntableConstraint=rmCreateClassDistanceConstraint("long huntable constraint", rmClassID("huntableFood"), 55.0);
   int forestsAvoidBison=rmCreateClassDistanceConstraint("forest avoids bison", rmClassID("huntableFood"), 15.0);

   // Avoid impassable land, certain features
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 18.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 15.0);
   int avoidCliffs=rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 10.0);
   int avoidCliffsShort=rmCreateClassDistanceConstraint("stuff vs. cliff short", rmClassID("classCliff"), 6.0);
   int cliffsAvoidCliffs=rmCreateClassDistanceConstraint("cliffs vs. cliffs", rmClassID("classCliff"), 30.0);
   int avoidWater10 = rmCreateTerrainDistanceConstraint("avoid water mid-long", "Land", false, 10.0);
   int avoidWater5 = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 5.0);
  
   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 10.0);
   int avoidStartingUnitsLarge=rmCreateClassDistanceConstraint("objects avoid starting units large", rmClassID("startingUnit"), 50.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("things avoid each other", rmClassID("importantItem"), 10.0);
   int avoidImportantItemSmall=rmCreateClassDistanceConstraint("important item small avoidance", rmClassID("importantItem"), 7.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 60.0);
   int avoidNativesMed=rmCreateClassDistanceConstraint("stuff avoids natives medium", rmClassID("natives"), 37.0);
   int avoidNativesShort=rmCreateClassDistanceConstraint("stuff avoids natives shorter", rmClassID("natives"), 15.0);
   int avoidNugget=rmCreateClassDistanceConstraint("nugget vs. nugget", rmClassID("classNugget"), 42.0);
   int avoidNuggetMed=rmCreateClassDistanceConstraint("nugget vs. nugget med", rmClassID("classNugget"), 55.0);
   int avoidNuggetLong=rmCreateClassDistanceConstraint("nugget vs. nugget long", rmClassID("classNugget"), 70.0);
   int avoidNuggetSmall=rmCreateClassDistanceConstraint("avoid nuggets by a little", rmClassID("classNugget"), 10.0);
   int avoidBerries=rmCreateTypeDistanceConstraint("avoid berries", "BerryBush", 15.0);
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
   int avoidKOTH=rmCreateTypeDistanceConstraint("avoid KOTH", "ypKingsHill", 8.0);
   int avoidKOTHlong=rmCreateTypeDistanceConstraint("avoid KOTH long", "ypKingsHill", 20.0);

   // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
   int avoidSocket=rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 10.0);

// End of constraints ------------------------------------------------------------------------------------------------

   // Text
   rmSetStatusText("",0.15);

   // Player placing  
   float spawnSwitch = rmRandFloat(0,1.2);

	if (cNumberTeams == 2){
		if (spawnSwitch <=0.6){
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.4, 0.65, 0.5, 0.87, 0, 0);
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.4, 0.35, 0.5, 0.13, 0, 0);
		}else if(spawnSwitch <=1.2){
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.4, 0.65, 0.5, 0.87, 0, 0);
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.4, 0.35, 0.5, 0.13, 0, 0);
		}
	}else{
		rmPlacePlayersLine(0.45, 0.9, 0.45, 0.1, 0, 0);
	}

   // Text
   rmSetStatusText("",0.20);
	
// Set up player areas.
   float playerFraction=rmAreaTilesToFraction(120);
   for(i=1; <cNumberPlayers)
   {
      int id=rmCreateArea("Player"+i);
      rmSetPlayerArea(i, id);
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmSetAreaMix(id, "tigris2");
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmAddAreaConstraint(id, playerConstraint); 
      rmAddAreaConstraint(id, longAvoidImpassableLand);
      rmAddAreaConstraint(id, playerEdgeConstraint); 
      rmSetAreaLocPlayer(id, i);
      rmSetAreaWarnFailure(id, false);
   }
   rmBuildAllAreas();

   // Text
   rmSetStatusText("",0.25);

// The River

   int waterPatch2ID=rmCreateArea("water area 2");
   rmSetAreaSize(waterPatch2ID, 0.20, 0.20);
   rmSetAreaLocation(waterPatch2ID, 0.14, 0.5);
   rmAddAreaInfluenceSegment(waterPatch2ID, 0.14, 0.0, 0.14, 1.0);

   rmSetAreaWaterType(waterPatch2ID, "tigris");
   rmSetAreaBaseHeight(waterPatch2ID, 0);

   rmSetAreaSmoothDistance(waterPatch2ID, 12);
   rmSetAreaCoherence(waterPatch2ID, 0.7);
   rmBuildArea(waterPatch2ID);

   int waterPatch1ID=rmCreateArea("water area 1");
   rmSetAreaSize(waterPatch1ID, 0.08, 0.08);
   rmSetAreaLocation(waterPatch1ID, 0.03, 0.5);
   rmAddAreaInfluenceSegment(waterPatch1ID, 0.03, 0.0, 0.03, 1.0);

   rmSetAreaWaterType(waterPatch1ID, "tigris");
   rmSetAreaBaseHeight(waterPatch1ID, -2);

   rmSetAreaSmoothDistance(waterPatch1ID, 25);
   rmSetAreaCoherence(waterPatch1ID, 0.99);
   rmBuildArea(waterPatch1ID);

// Patches for desert area
   int desertPatch0ID=rmCreateArea("desert patch 0");
   rmAddAreaToClass(desertPatch0ID, rmClassID("classPatch"));
   rmSetAreaSize(desertPatch0ID, 0.5, 0.5);
   rmSetAreaLocation(desertPatch0ID, 0.45, 0.5);
   rmAddAreaInfluenceSegment(desertPatch0ID, 0.45, 0.0, 0.45, 1.0);
   rmSetAreaMix(desertPatch0ID, "tigris2");
   rmSetAreaSmoothDistance(desertPatch0ID, 25);
   rmSetAreaCoherence(desertPatch0ID, 0.99);
   rmBuildArea(desertPatch0ID);

   int desertPatch1ID=rmCreateArea("desert patch 1");
   rmAddAreaToClass(desertPatch1ID, rmClassID("classPatch"));
   rmSetAreaSize(desertPatch1ID, 0.5, 0.5);
   rmSetAreaLocation(desertPatch1ID, 0.65, 0.5);
   rmAddAreaInfluenceSegment(desertPatch1ID, 0.65, 0.0, 0.65, 1.0);
   rmSetAreaMix(desertPatch1ID, "tigris1");
   rmSetAreaSmoothDistance(desertPatch1ID, 25);
   rmSetAreaCoherence(desertPatch1ID, 0.9);
   rmBuildArea(desertPatch1ID);

   int desertPatch2ID=rmCreateArea("desert patch 2");
   rmAddAreaToClass(desertPatch2ID, rmClassID("classPatch"));
   rmSetAreaSize(desertPatch2ID, 0.2, 0.21);
   rmSetAreaLocation(desertPatch2ID, 0.85, 0.5);
   rmAddAreaInfluenceSegment(desertPatch2ID, 0.85, 0.0, 0.85, 1.0);
   rmSetAreaMix(desertPatch2ID, "tigris0");
   rmSetAreaSmoothDistance(desertPatch2ID, 25);
   rmSetAreaCoherence(desertPatch2ID, 0.5);
   rmBuildArea(desertPatch2ID);

   int desertPatch3ID=rmCreateArea("desert patch 3");
   rmAddAreaToClass(desertPatch3ID, rmClassID("classPatch"));
   rmSetAreaSize(desertPatch3ID, 0.12, 0.12);
   rmSetAreaLocation(desertPatch3ID, 0.95, 0.5);
   rmAddAreaInfluenceSegment(desertPatch3ID, 0.95, 0.0, 0.95, 1.0);
   rmSetAreaMix(desertPatch3ID, "tigris0");
   rmSetAreaSmoothDistance(desertPatch3ID, 25);
   rmSetAreaCoherence(desertPatch3ID, 0.99);
   rmBuildArea(desertPatch3ID);

   // Text
   rmSetStatusText("",0.30);

// Trade Route
   int routeChoice = rmRandInt(1,2);
   int tradeRouteID10 = rmCreateTradeRoute();
   vector tradeRoutePoint = cOriginVector;

   tradeRoutePoint = rmFindClosestPoint(0.8, 0.03, 5.0);
   rmAddTradeRouteWaypoint(tradeRouteID10, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)));
   rmAddRandomTradeRouteWaypoints(tradeRouteID10, 0.73, 0.32, 2, 7);
   rmAddRandomTradeRouteWaypoints(tradeRouteID10, 0.79, 0.45, 2, 7);
   rmAddRandomTradeRouteWaypoints(tradeRouteID10, 0.79, 0.55, 2, 7);
   rmAddRandomTradeRouteWaypoints(tradeRouteID10, 0.73, 0.68, 2, 7);
   tradeRoutePoint = rmFindClosestPoint(0.8, 0.97, 5.0);
   rmAddRandomTradeRouteWaypoints(tradeRouteID10, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)), 2, 7);

   bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID10, "water");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route"); 

   //Text
   rmSetStatusText("",0.35);

// Trade sockets
   int socketPattern = rmRandInt(1,2);
   twoChoice = rmRandInt(1,2);
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
   rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 6.0);

   rmSetObjectDefTradeRouteID(socketID, tradeRouteID10);
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.0);
   if (socketPattern == 1)
   {
	if (twoChoice == 1) // 6 TPs
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.1);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.25);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.41);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.59);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.75);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.9);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else  // 4 TPs
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.12);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.36);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.64);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.88);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }
   else if (socketPattern == 2)
   {
	if (twoChoice == 1) // 5 TPs
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.1);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.31);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.69);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.9);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else // 3 TPs
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.16);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.84);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }

   // Text
   rmSetStatusText("",0.40);

// Starting TCs and units 		
   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));
   rmSetObjectDefMinDistance(startingUnits, 5.0);
   rmSetObjectDefMaxDistance(startingUnits, 10.0);
   rmAddObjectDefConstraint(startingUnits, avoidAll);

   int startingTCID= rmCreateObjectDef("startingTC");
   rmAddObjectDefToClass(startingTCID, rmClassID("startingUnit"));
   rmSetObjectDefMinDistance(startingTCID, 0.0);
   rmSetObjectDefMaxDistance(startingTCID, 8.0);
   rmAddObjectDefConstraint(startingTCID, avoidAll);
   rmAddObjectDefConstraint(startingTCID, avoidTradeRoute);
   rmAddObjectDefConstraint(startingTCID, longAvoidImpassableLand );                
   if ( rmGetNomadStart())
   {
	rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
   }
   else
   {
      rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
   }

   // start area trees 
   int StartAreaTreeID=rmCreateObjectDef("starting trees");
   rmAddObjectDefItem(StartAreaTreeID, treeType, 1, 0.0);
   rmSetObjectDefMinDistance(StartAreaTreeID, 10);
   rmSetObjectDefMaxDistance(StartAreaTreeID, 12);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidAll);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidCliffs);
 //  rmPlaceObjectDefPerPlayer(StartAreaTreeID, false, 3);

   // berry bushes
   int StartBerryBushID=rmCreateObjectDef("starting berry bush");
   rmAddObjectDefItem(StartBerryBushID, "BerryBush", rmRandInt(3,3), 4.0);
   rmSetObjectDefMinDistance(StartBerryBushID, 10.0);
   rmSetObjectDefMaxDistance(StartBerryBushID, 16.0);
   rmAddObjectDefConstraint(StartBerryBushID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartBerryBushID, avoidCliffsShort);
 //  rmPlaceObjectDefPerPlayer(StartBerryBushID, false, 1);

   // start area huntable
   int deerNum = rmRandInt(4,5);
   int startPronghornID=rmCreateObjectDef("starting pronghorn");
   rmAddObjectDefItem(startPronghornID, deerType, deerNum, 5.0);
   rmAddObjectDefToClass(startPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(startPronghornID, 14);
   rmSetObjectDefMaxDistance(startPronghornID, 18);
   rmAddObjectDefConstraint(startPronghornID, avoidStartResource);
   rmAddObjectDefConstraint(startPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(startPronghornID, avoidAll);
   rmSetObjectDefCreateHerd(startPronghornID, false);
   //rmPlaceObjectDefPerPlayer(startPronghornID, false, 1);

   // start area goats or cows
   int startGoatsID=rmCreateObjectDef("starting goats");
   rmAddObjectDefItem(startGoatsID, sheepType, 2, 4.0);
   rmSetObjectDefMinDistance(startGoatsID, 10);
   rmSetObjectDefMaxDistance(startGoatsID, 12);
   rmAddObjectDefConstraint(startGoatsID, avoidStartResource);
   rmAddObjectDefConstraint(startGoatsID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(startGoatsID, avoidAll);
   rmSetObjectDefCreateHerd(startGoatsID, true);

   // Silver mines - players
   int silverType = -1;
   silverType = rmRandInt(1,10);
   int playerGoldID=rmCreateObjectDef("player silver closer");
   rmAddObjectDefItem(playerGoldID, mineType, 1, 0.0);
   rmAddObjectDefConstraint(playerGoldID, shortAvoidSilver);
   rmAddObjectDefConstraint(playerGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(playerGoldID, avoidAll);
   rmAddObjectDefConstraint(playerGoldID, avoidWater10);
   rmSetObjectDefMinDistance(playerGoldID, 15.0);
   rmSetObjectDefMaxDistance(playerGoldID, 20.0);
//   rmPlaceObjectDefPerPlayer(playerGoldID, false, 1);

   silverType = rmRandInt(1,10);
   int GoldMediumID=rmCreateObjectDef("player silver med");
   rmAddObjectDefItem(GoldMediumID, mineType, 1, 0.0);
   rmAddObjectDefConstraint(GoldMediumID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldMediumID, avoidSocket);
   rmAddObjectDefConstraint(GoldMediumID, shortAvoidSilver);
   rmAddObjectDefConstraint(GoldMediumID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(GoldMediumID, playerConstraint);
   rmAddObjectDefConstraint(GoldMediumID, circleConstraint);
   rmAddObjectDefConstraint(GoldMediumID, avoidAll);
   rmAddObjectDefConstraint(GoldMediumID, avoidWater10);
   rmAddObjectDefConstraint(GoldMediumID, desertBoxConstraint);
   rmSetObjectDefMinDistance(GoldMediumID, 48.0);
   rmSetObjectDefMaxDistance(GoldMediumID, 54.0);
 //  rmPlaceObjectDefPerPlayer(GoldMediumID, false, 1);

   // Player Nuggets
   int playerNuggetID=rmCreateObjectDef("player nugget");
   rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
   rmAddObjectDefToClass(playerNuggetID, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(playerNuggetID, 35.0);
   rmSetObjectDefMaxDistance(playerNuggetID, 45.0);
   rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerNuggetID, avoidSocket);
   rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
   rmAddObjectDefConstraint(playerNuggetID, avoidWater10);
   rmAddObjectDefConstraint(playerNuggetID, avoidCliffsShort);

   for(i=1; <cNumberPlayers)
   {	
      rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));

      rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      rmPlaceObjectDefAtLoc(StartBerryBushID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      rmPlaceObjectDefAtLoc(startPronghornID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      rmPlaceObjectDefAtLoc(startGoatsID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      rmPlaceObjectDefAtLoc(playerGoldID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      rmPlaceObjectDefAtLoc(GoldMediumID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

 	rmSetNuggetDifficulty(1, 1);
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

   }

   // Text
   rmSetStatusText("",0.45);

// NATIVES
   if (cNumberNonGaiaPlayers == 2)  // 2 or 3 villages only 
	nativeSetup = rmRandInt(1,3);
   if (cNumberNonGaiaPlayers > 4)  // 3 or 4 villages only 
	nativeSetup = rmRandInt(2,4);
   if (cNumberNonGaiaPlayers > 6)  // 3 or 4 villages only 
	nativeSetup = rmRandInt(3,4);

   // Village A 
   int villageAID = -1;
   int whichNative = rmRandInt(1,2);
   int villageType = rmRandInt(1,5);

   if (whichNative == 1)
	   villageAID = rmCreateGrouping("village A", native1Name+villageType);
   else if (whichNative == 2)
	   villageAID = rmCreateGrouping("village A", native2Name+villageType);
   rmAddGroupingToClass(villageAID, rmClassID("natives"));
   rmAddGroupingToClass(villageAID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageAID, 0.0);
   rmSetGroupingMaxDistance(villageAID, rmXFractionToMeters(0.12));
   rmAddGroupingConstraint(villageAID, avoidImpassableLand);
   rmAddGroupingConstraint(villageAID, avoidTradeRoute);
   rmAddGroupingConstraint(villageAID, avoidWater10);
   rmAddGroupingConstraint(villageAID, avoidSocket);
   rmAddGroupingConstraint(villageAID, avoidNativesMed);
   rmAddGroupingConstraint(villageAID, nuggetPlayerConstraint);

   // Village D - same or opposite type from A 
   villageType = rmRandInt(1,5);
   int villageDID = -1;
   whichNative = rmRandInt(1,2);

   if (whichNative == 2)
	   villageDID = rmCreateGrouping("village D", native1Name+villageType);
   else if (whichNative == 1)
	   villageDID = rmCreateGrouping("village D", native2Name+villageType);
   rmAddGroupingToClass(villageDID, rmClassID("natives"));
   rmAddGroupingToClass(villageDID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageDID, 0.0);
   rmSetGroupingMaxDistance(villageDID, rmXFractionToMeters(0.12));
   rmAddGroupingConstraint(villageDID, avoidImpassableLand);
   rmAddGroupingConstraint(villageDID, avoidTradeRoute);
   rmAddGroupingConstraint(villageDID, avoidWater10);
   rmAddGroupingConstraint(villageDID, avoidSocket);
   rmAddGroupingConstraint(villageDID, avoidNativesMed);
   rmAddGroupingConstraint(villageDID, nuggetPlayerConstraint);

   // Text
   rmSetStatusText("",0.50);

// Placement of Natives
   if (nativeSetup == 1)
   {
      rmPlaceGroupingAtLoc(villageDID, 0, 0.91, 0.18);
      rmPlaceGroupingAtLoc(villageAID, 0, 0.91, 0.81);
   }
   else if (nativeSetup < 4)
   {
      rmPlaceGroupingAtLoc(villageAID, 0, 0.91, 0.18);
      rmPlaceGroupingAtLoc(villageDID, 0, 0.91, 0.81);
      rmPlaceGroupingAtLoc(villageAID, 0, 0.92, 0.5);
   }
   else if (nativeSetup == 4)
   {
      rmPlaceGroupingAtLoc(villageAID, 0, 0.92, 0.14);
      rmPlaceGroupingAtLoc(villageAID, 0, 0.92, 0.84);
      rmPlaceGroupingAtLoc(villageDID, 0, 0.93, 0.35);
      rmPlaceGroupingAtLoc(villageDID, 0, 0.93, 0.65);
   }
/*  ==============================================================
   if (nativeSetup == 1)
   {
      rmPlaceGroupingAtLoc(villageDID, 0, 0.895, 0.18);
      rmPlaceGroupingAtLoc(villageAID, 0, 0.895, 0.81);
   }
   else if (nativeSetup < 4)
   {
      rmPlaceGroupingAtLoc(villageAID, 0, 0.895, 0.18);
      rmPlaceGroupingAtLoc(villageDID, 0, 0.895, 0.81);
      rmPlaceGroupingAtLoc(villageAID, 0, 0.895, 0.5);
   }
   else if (nativeSetup == 4)
   {
      rmPlaceGroupingAtLoc(villageAID, 0, 0.895, 0.14);
      rmPlaceGroupingAtLoc(villageAID, 0, 0.895, 0.84);
      rmPlaceGroupingAtLoc(villageDID, 0, 0.895, 0.35);
      rmPlaceGroupingAtLoc(villageDID, 0, 0.895, 0.65);
   }
===================================================================  */
   // Text
   rmSetStatusText("",0.55);

// Random Nuggets
   int nugget2= rmCreateObjectDef("nugget medium"); 
   rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(2, 2);
   rmAddObjectDefToClass(nugget2, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget2, 60.0);
   rmSetObjectDefMaxDistance(nugget2, 100.0);
   rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget2, avoidSocket);
   rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget2, nuggetPlayerConstraint);
   rmAddObjectDefConstraint(nugget2, avoidNuggetMed);
   rmAddObjectDefConstraint(nugget2, circleConstraint);
   rmAddObjectDefConstraint(nugget2, avoidWater10);
   rmAddObjectDefConstraint(nugget2, avoidAll);
   rmPlaceObjectDefPerPlayer(nugget2, false, 1);

   rmSetObjectDefMinDistance(nugget2, 20.0);
   rmSetObjectDefMaxDistance(nugget2, 150.0);
   rmPlaceObjectDefAtLoc(nugget2, 0, 0.5, 0.5, 2);

   // Text
   rmSetStatusText("",0.60);

   int nugget3= rmCreateObjectDef("nugget hard"); 
   rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(3, 3);
   rmAddObjectDefToClass(nugget3, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget3, 80.0);
   rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.6));
   rmAddObjectDefConstraint(nugget3, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget3, avoidSocket);
   rmAddObjectDefConstraint(nugget3, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget3, longPlayerConstraint);
   rmAddObjectDefConstraint(nugget3, avoidNuggetLong);
   rmAddObjectDefConstraint(nugget3, circleConstraint);
   rmAddObjectDefConstraint(nugget3, avoidWater10);
   rmAddObjectDefConstraint(nugget3, avoidAll);
   rmPlaceObjectDefPerPlayer(nugget3, false, 1);

   rmSetObjectDefMinDistance(nugget3, 40.0);
   rmSetObjectDefMaxDistance(nugget3, 170.0);
   rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, 3);

   int nugget4= rmCreateObjectDef("nugget nuts"); 
   rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(4, 4);
   rmAddObjectDefToClass(nugget4, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget4, 80.0);
   rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(nugget4, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget4, avoidSocket);
   rmAddObjectDefConstraint(nugget4, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget4, farPlayerConstraint);
   rmAddObjectDefConstraint(nugget4, avoidNuggetLong);
   rmAddObjectDefConstraint(nugget4, circleConstraint);
   rmAddObjectDefConstraint(nugget4, avoidWater10);
   rmAddObjectDefConstraint(nugget4, avoidAll);
   rmPlaceObjectDefPerPlayer(nugget4, false, 1);

   rmSetObjectDefMinDistance(nugget4, 40.0);
   rmSetObjectDefMaxDistance(nugget4, 170.0);
   rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, 2);

   // Text
   rmSetStatusText("",0.65);

// second huntable  
   int deer2Num = rmRandInt(4,5);
   int farPronghornID=rmCreateObjectDef("far pronghorn");
   rmAddObjectDefItem(farPronghornID, deer2Type, deer2Num, 5.0);
   rmAddObjectDefToClass(farPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farPronghornID, 42.0);
   rmSetObjectDefMaxDistance(farPronghornID, 65.0);
   rmAddObjectDefConstraint(farPronghornID, avoidStartResource);
   rmAddObjectDefConstraint(farPronghornID, playerConstraint);
   rmAddObjectDefConstraint(farPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(farPronghornID, avoidNativesShort);
   rmAddObjectDefConstraint(farPronghornID, huntableConstraint);
   rmAddObjectDefConstraint(farPronghornID, avoidAll);
   rmSetObjectDefCreateHerd(farPronghornID, true);
   rmPlaceObjectDefPerPlayer(farPronghornID, false, 1); 

// Extra tree clumps near players - to ensure fair access to wood
   int extraTreesID=rmCreateObjectDef("extra trees");
   rmAddObjectDefItem(extraTreesID, treeType, 5, 5.0);
   rmSetObjectDefMinDistance(extraTreesID, 14);
   rmSetObjectDefMaxDistance(extraTreesID, 18);
   rmAddObjectDefConstraint(extraTreesID, avoidAll);
   rmAddObjectDefConstraint(extraTreesID, avoidCoin);
   rmAddObjectDefConstraint(extraTreesID, avoidSocket);
   rmAddObjectDefConstraint(extraTreesID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraTreesID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(extraTreesID, playerConstraintForest);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTreesID, 0, rmAreaID("player"+i), 1);

   int extraTrees2ID=rmCreateObjectDef("more extra trees");
   rmAddObjectDefItem(extraTrees2ID, treeType, 5, 6.0);
   rmSetObjectDefMinDistance(extraTrees2ID, 19);
   rmSetObjectDefMaxDistance(extraTrees2ID, 30);
   rmAddObjectDefConstraint(extraTrees2ID, avoidAll);
   rmAddObjectDefConstraint(extraTrees2ID, avoidCoin);
   rmAddObjectDefConstraint(extraTrees2ID, avoidSocket);
   rmAddObjectDefConstraint(extraTrees2ID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraTrees2ID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(extraTrees2ID, playerConstraintForest);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTrees2ID, 0, rmAreaID("player"+i), 2);

   // Text
   rmSetStatusText("",0.70);

// Main forests
   int coverForestPatchID = 0;
   int failCount=0;
   int numForest=9*scalingFactor;

   for (i=0; <numForest)
   {
      int forest=rmCreateArea("forest "+i);
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(165), rmAreaTilesToFraction(250));
      rmSetAreaForestType(forest, forestType);
      rmSetAreaForestDensity(forest, rmRandFloat(0.7, 1.0));
      rmSetAreaForestClumpiness(forest, rmRandFloat(0.7, 0.9));
      rmSetAreaCoherence(forest, rmRandFloat(0.65, 0.7));
      rmSetAreaSmoothDistance(forest, rmRandInt(10,20));
      rmAddAreaToClass(forest, rmClassID("classForest")); 
	rmAddAreaConstraint(forest, mediumPlayerConstraint);
      rmAddAreaConstraint(forest, forestConstraint);
      rmAddAreaConstraint(forest, avoidAll); 
	rmAddAreaConstraint(forest, avoidCoin);  
      rmAddAreaConstraint(forest, avoidImpassableLand); 
      rmAddAreaConstraint(forest, avoidTradeRoute);
	rmAddAreaConstraint(forest, avoidStartingUnits);
	rmAddAreaConstraint(forest, forestBoxConstraint);
	rmAddAreaConstraint(forest, avoidSocket);
      rmAddAreaConstraint(forest, avoidCliffsShort);
	rmAddAreaConstraint(forest, avoidNativesShort);
      rmAddAreaConstraint(forest, forestsAvoidBison); 

      if(rmBuildArea(forest)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==5)
            break;
      }
      else
         failCount=0; 

      coverForestPatchID = rmCreateArea("cover forest patch"+i, rmAreaID("forest "+i));   
      rmSetAreaWarnFailure(coverForestPatchID, false);
      rmSetAreaSize(coverForestPatchID, rmAreaTilesToFraction(265), rmAreaTilesToFraction(265));
      rmSetAreaCoherence(coverForestPatchID, 0.99);
      rmSetAreaMix(coverForestPatchID, baseType); 
	rmBuildArea(coverForestPatchID);
   } 

   // Text
   rmSetStatusText("",0.75);

// Extra silver mines - distant
//   if (rmRandInt(1,6) == 1)  ======================================== test
	mineType = "minegold";
   silverType = rmRandInt(1,10);
   int GoldFarID=rmCreateObjectDef("silver far");
   rmAddObjectDefItem(GoldFarID, mineType, 1, 0.0);
   rmAddObjectDefConstraint(GoldFarID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldFarID, avoidSocket);
   rmAddObjectDefConstraint(GoldFarID, longAvoidCoin);
   rmAddObjectDefConstraint(GoldFarID, avoidImportantItemSmall);
//   rmAddObjectDefConstraint(GoldFarID, circleConstraint);
   rmAddObjectDefConstraint(GoldFarID, avoidAll);
//   rmAddObjectDefConstraint(GoldFarID, farPlayerConstraint);
   rmAddObjectDefConstraint(GoldFarID, desertBoxConstraint);
   rmSetObjectDefMinDistance(GoldFarID, 75.0);
   rmSetObjectDefMaxDistance(GoldFarID, 100.0);
   rmPlaceObjectDefPerPlayer(GoldFarID, false, 1);

 //  if (rmRandInt(1,6) == 1)
//	mineType = "minegold";

mineType = "mine";  // ==============================================
   silverType = rmRandInt(1,10);
   int extraGoldID = rmCreateObjectDef("extra silver");
   rmAddObjectDefItem(extraGoldID, mineType, 1, 0.0);
   rmAddObjectDefToClass(extraGoldID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(extraGoldID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraGoldID, avoidSocket);
   rmAddObjectDefConstraint(extraGoldID, longAvoidCoin);
   rmAddObjectDefConstraint(extraGoldID, avoidImportantItemSmall);
//   rmAddObjectDefConstraint(extraGoldID, fartherPlayerConstraint);
   rmAddObjectDefConstraint(extraGoldID, desertBoxConstraint2);
   rmAddObjectDefConstraint(extraGoldID, avoidAll);
   rmSetObjectDefMinDistance(extraGoldID, 0.0);
   rmSetObjectDefMaxDistance(extraGoldID, 90.0);

   rmPlaceObjectDefInArea(extraGoldID, 0, rmAreaID("desert patch 2"), cNumberNonGaiaPlayers);
   rmPlaceObjectDefInArea(extraGoldID, 0, rmAreaID("desert patch 3"), 2 + cNumberNonGaiaPlayers);

   // Text
   rmSetStatusText("",0.80);

// sheep etc
   int sheepID=rmCreateObjectDef("herdable animal");
   rmAddObjectDefItem(sheepID, sheepType, 2, 4.0);
   rmAddObjectDefToClass(sheepID, rmClassID("herdableFood"));
   rmSetObjectDefMinDistance(sheepID, 45.0);
   rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.3));
   rmAddObjectDefConstraint(sheepID, avoidSheep);
   rmAddObjectDefConstraint(sheepID, avoidAll);
   rmAddObjectDefConstraint(sheepID, playerConstraint);
   rmAddObjectDefConstraint(sheepID, avoidCliffsShort);
   rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
   rmPlaceObjectDefPerPlayer(sheepID, false, 1);

   rmAddObjectDefConstraint(sheepID, farPlayerConstraint);
   rmSetObjectDefMinDistance(sheepID, 80.0);
   rmSetObjectDefMaxDistance(sheepID, longSide*0.5);
   rmPlaceObjectDefPerPlayer(sheepID, false, 2); 

   // Text
   rmSetStatusText("",0.85);

// Desert herds
   int centralHerdID=rmCreateObjectDef("central herd");  
   rmAddObjectDefItem(centralHerdID, centerHerdType, rmRandInt(4,5), 6.0);
   rmAddObjectDefToClass(centralHerdID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(centralHerdID, rmXFractionToMeters(0.05));
   rmSetObjectDefMaxDistance(centralHerdID, longSide*0.25);
   rmAddObjectDefConstraint(centralHerdID, avoidTradeRoute);
   rmAddObjectDefConstraint(centralHerdID, avoidImportantItem);
   rmAddObjectDefConstraint(centralHerdID, avoidWater10);
   rmAddObjectDefConstraint(centralHerdID, avoidCliffsShort);
   rmAddObjectDefConstraint(centralHerdID, farPlayerConstraint);
   rmAddObjectDefConstraint(centralHerdID, longHuntableConstraint);
   rmAddObjectDefConstraint(centralHerdID, desertBoxConstraint);
   rmSetObjectDefCreateHerd(centralHerdID, true);
   if (cNumberNonGaiaPlayers > 5)
      rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.9, 0.5, 3);
   if (cNumberNonGaiaPlayers > 3)
      rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.9, 0.5, 2);
   else
      rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.9, 0.5, 1);

   rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.9, 0.78, 1);

   rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.9, 0.22, 1);

   // Text
   rmSetStatusText("",0.90);

// Riverbank trees
   for(i=0; <scalingFactor*5)
   {
      int riverbankTreeID=rmCreateObjectDef("riverbank trees"+i);
      rmAddObjectDefItem(riverbankTreeID, treeType, rmRandInt(2,4), 6.0);
      rmAddObjectDefConstraint(riverbankTreeID, avoidAll);
      rmAddObjectDefConstraint(riverbankTreeID, avoidCoin);
      rmAddObjectDefConstraint(riverbankTreeID, avoidCliffsShort);
      rmAddObjectDefConstraint(riverbankTreeID, avoidSocket);
      rmAddObjectDefConstraint(riverbankTreeID, treeBoxConstraint);
      rmAddObjectDefConstraint(riverbankTreeID, avoidWater5);
      rmSetObjectDefMinDistance(riverbankTreeID, 0.0);
      rmSetObjectDefMaxDistance(riverbankTreeID, longSide*0.2);
      rmPlaceObjectDefAtLoc(riverbankTreeID, 0, 0.4, 0.2, 1);
      rmPlaceObjectDefAtLoc(riverbankTreeID, 0, 0.4, 0.4, 1);
      rmPlaceObjectDefAtLoc(riverbankTreeID, 0, 0.4, 0.6, 1);
      rmPlaceObjectDefAtLoc(riverbankTreeID, 0, 0.4, 0.8, 1);
   }

// Random trees
   int StragglerTreeID=rmCreateObjectDef("stragglers");
   rmAddObjectDefItem(StragglerTreeID, "ypTreeBorneoPalm", 1, 0.0);
   rmAddObjectDefConstraint(StragglerTreeID, avoidAll);
   rmAddObjectDefConstraint(StragglerTreeID, avoidStartingUnits);
   rmAddObjectDefConstraint(StragglerTreeID, avoidCoin);
   rmAddObjectDefConstraint(StragglerTreeID, avoidCliffsShort);
   rmAddObjectDefConstraint(StragglerTreeID, treeBoxConstraint2);
   rmAddObjectDefConstraint(StragglerTreeID, avoidWater10);
   rmAddObjectDefConstraint(StragglerTreeID, mediumPlayerConstraint);
   rmSetObjectDefMinDistance(StragglerTreeID, 10.0);
   rmSetObjectDefMaxDistance(StragglerTreeID, longSide*0.5);
   for(i=0; <scalingFactor*18)
      rmPlaceObjectDefAtLoc(StragglerTreeID, 0, 0.5, 0.5);

   // Text
   rmSetStatusText("",0.95);

// Trees on islands
   int islandTreeID=rmCreateObjectDef("trees on islands");
   rmAddObjectDefItem(islandTreeID, "ypTreeBorneoPalm", 1, 0.0);
   rmAddObjectDefConstraint(islandTreeID, avoidAll);

// Berries on islands
   int islandBerriesID=rmCreateObjectDef("berries on islands");
   rmAddObjectDefItem(islandBerriesID, "BerryBush", 2, 0.0);

// Small land areas in water
   for (i=0; <cNumberNonGaiaPlayers*4)   
   {
	   int colorPatch2=rmCreateArea("2nd color patch "+i, rmAreaID("water area 2"));
	   rmSetAreaWarnFailure(colorPatch2, false);
	   rmSetAreaSize(colorPatch2, rmAreaTilesToFraction(25), rmAreaTilesToFraction(40));
	   rmSetAreaBaseHeight(colorPatch2, 0.2);
         rmSetAreaMix(colorPatch2, "tigris2");
	   rmAddAreaToClass(colorPatch2, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(colorPatch2, 1);
	   rmSetAreaMaxBlobs(colorPatch2, 3);
	   rmSetAreaMinBlobDistance(colorPatch2, 5.0);
	   rmSetAreaMaxBlobDistance(colorPatch2, 9.0);
	   rmSetAreaCoherence(colorPatch2, 0.3);
	   rmSetAreaSmoothDistance(colorPatch2, 10);
	   rmAddAreaConstraint(colorPatch2, patchConstraint);
	   rmAddAreaConstraint(colorPatch2, berryBoxConstraint);
	   rmBuildArea(colorPatch2); 

         rmPlaceObjectDefInArea(islandTreeID, 0, rmAreaID("2nd color patch "+i), rmRandInt(1,2));
         rmPlaceObjectDefInArea(islandBerriesID, 0, rmAreaID("2nd color patch "+i), 1);
   }

//  Berries in the flood
   int farBerryBushID=rmCreateObjectDef("far berry bush");
   rmAddObjectDefItem(farBerryBushID, "BerryBush", rmRandInt(3,5), 4.0);
   rmAddObjectDefConstraint(farBerryBushID, playerConstraint);
   rmAddObjectDefConstraint(farBerryBushID, berryBoxConstraint);
   rmAddObjectDefConstraint(farBerryBushID, avoidBerries);
   rmAddObjectDefConstraint(farBerryBushID, avoidAll);
   rmSetObjectDefMinDistance(farBerryBushID, 10.0);
   rmSetObjectDefMaxDistance(farBerryBushID, 45.0);

   rmPlaceObjectDefAtLoc(farBerryBushID, 0, 0.1, 0.2, 2);
   rmPlaceObjectDefAtLoc(farBerryBushID, 0, 0.1, 0.4, 2);
   rmPlaceObjectDefAtLoc(farBerryBushID, 0, 0.1, 0.6, 2);
   rmPlaceObjectDefAtLoc(farBerryBushID, 0, 0.1, 0.8, 2);
   rmPlaceObjectDefInArea(farBerryBushID, 0, rmAreaID("water area 2"), 4*cNumberNonGaiaPlayers);


// KOTH game mode 
   if(rmGetIsKOTH())
   {
      float xLoc = 0.93;
      float yLoc = 0.5;
      float walk = 0.05;
    
      ypKingsHillPlacer(xLoc, yLoc, walk, 0);
   }

   // Text
   rmSetStatusText("",0.99);
}  