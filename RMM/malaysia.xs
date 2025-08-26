// Borneo
// PJJ
// Dec 2006

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{


   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

  int whichVersion = 1;
  // initialize map type variables
  string nativeCiv1 = "Jesuit";
  string nativeCiv2 = "Sufi";
  string baseMix = "borneo_grass_a";
  string paintMix = "borneo_underbrush";
  string baseTerrain = "borneo\ground_grass3_borneo";
  string seaType = "borneo coast2";
  string startTreeType = "ypTreeBorneo";
  string forestType = "Borneo Forest";
  string forestType2 = "Borneo Palm Forest";
  string forestTypeSpecial = "Borneo Palm Forest"; // special forest only available on EP
  if (false == false)
  {
	forestTypeSpecial = "Borneo Forest";
  }
  string patchTerrain = "borneo\ground_grass1_borneo";
  string patchType1 = "borneo\ground_grass2_borneo";
  string patchType2 = "borneo\ground_grass5_borneo";
  string mapType1 = "borneo";
  string mapType2 = "grass";
  string mapType3 = "asia";
  string herdableType = "ypWaterBuffalo";
  string huntable1 = "Peafowl";
  string huntable2 = "ypWildElephant";
  string fish1 = "ypFishMolaMola";
  string fish2 = "ypFishTuna";
  string whale1 = "HumpbackWhale";
  string lightingType = "Borneo";
  string tradeRouteType = "water";
  
  bool weird = false;
  int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
    
  // FFA and imbalanced teams
  if ( cNumberTeams > 2 || ((teamZeroCount - teamOneCount) > 2) || ((teamOneCount - teamZeroCount) > 2) )
    weird = true;
  
  rmEchoInfo("weird = "+weird);
  
// Natives

	
// Map Basics
	int playerTiles = 15000;
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=14000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=13000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=12000;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	rmSetMapElevationParameters(cElevTurbulence, 0.05, 10, 0.4, 7.0);
	rmSetMapElevationHeightBlend(1);
	
	rmSetSeaLevel(1.0);
	rmSetLightingSet(lightingType);

	rmSetSeaType(seaType);
	rmSetBaseTerrainMix(baseMix);
	rmTerrainInitialize("water");
	rmSetMapType(mapType1);
	rmSetMapType(mapType2);
	rmSetMapType(mapType3);
	rmSetMapType("water");
	rmSetMapType("AIFishingUseful");
	rmSetWorldCircleConstraint(true);
	rmSetWindMagnitude(3.0);

	chooseMercs();
	
// Classes
	int classPlayer = rmDefineClass("player");
	int classForest = rmDefineClass("classForest");
	int classImportant = rmDefineClass("importantItem");
	int classPonds = rmDefineClass("Ponds");
	int classSocket = rmDefineClass("socketClass");
	int nativeClass = rmDefineClass("natives");
	int classStartingUnit = rmDefineClass("startingUnit");
	int classPatch = rmDefineClass("patch");
	
	
		string Hunt1name="Peafowl";
	string Hunt2name="ypSaiga";
	

// Constraints
    
	// Avoid impassable land
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.00),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
	int avoidPonds=rmCreateClassDistanceConstraint("avoid ponds ", classPonds, 5.0);

		// starting constraints
	int avoidCoinStart=rmCreateTypeDistanceConstraint("avoid coin starts", "Mine", 30.0);
	int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 10.0);
	int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", classStartingUnit, 45.0);
	int shortAvoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units short", classStartingUnit, 10.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", classImportant, 10.0);

	// Ressource avoidance
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center Far 2", "townCenter", 50.0);
    int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 63.0);
    int avoidTownCenterShort=rmCreateTypeDistanceConstraint("avoid Town Center Far short", "townCenter", 30.0);
	int avoidTownCenterVeryShort=rmCreateTypeDistanceConstraint("avoid Town Center Far very short", "townCenter", 20.0);

	int avoidCoinShort=rmCreateTypeDistanceConstraint("avoids coin short", "gold", 8.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 50.0);
	int avoidHunt1=rmCreateTypeDistanceConstraint("avoid the hunt1", Hunt1name, 40.0);
	int avoidHunt2=rmCreateTypeDistanceConstraint("avoid the hunt2", Hunt2name, 40.0);
	int yakVsyak=rmCreateTypeDistanceConstraint("avoid the yaks", "ypWaterBuffalo", 30.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", classForest, 25.0);
	int forestConstraintshort=rmCreateClassDistanceConstraint("forest vs. forest short", classForest, 4.0);
	int avoidTreasuresShort=rmCreateTypeDistanceConstraint("nugget avoid nugget start", "AbstractNugget", 20.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 35.0);

	// Trade route avoidance.
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 4.0);
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 15.0);
	int avoidTradeSockets = rmCreateTypeDistanceConstraint("avoid trade sockets", "sockettraderoute", 8.0);
	int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", classSocket, 10.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid Natives short", nativeClass, 5.0);

	int avoidWater = rmCreateTerrainDistanceConstraint("hunt vs water", "water", true, 6.0);
  int avoidLand = rmCreateTerrainDistanceConstraint("ship avoid land", "land", true, 15.0);

  // fish & whale constraints
  int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", fish1, 12.0);
	int fishVsFish2ID=rmCreateTypeDistanceConstraint("fish v fish2", fish2, 12.0);
	int fishWhale = rmCreateTypeDistanceConstraint("fish v whale", fish1, 4.0);
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);

  int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", whale1, 23.0);
	int whaleLand = rmCreateTerrainDistanceConstraint("whale land", "land", true, 13.0);
  int whaleEdgeConstraint=rmCreatePieConstraint("whale edge of map", 0.5, 0.5, 0, rmGetMapXSize()-25, 0, 0, 0);

  // flag constraints
  int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 15.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 20.0);
	int flagEdgeConstraint=rmCreatePieConstraint("flag edge of map", 0.5, 0.5, 0, rmGetMapXSize()-25, 0, 0, 0);


// --------------------------------------- BUILDING WATER and GROUND AREAS -----------------------------------------------------
	int WaterTop = rmCreateArea("Water Top");
	rmSetAreaLocation(WaterTop,0.9,0.9);
	rmAddAreaInfluenceSegment(WaterTop,1.0,1.0,0.75,0.75);
	rmAddAreaInfluenceSegment(WaterTop,0.9,0.6,0.7,0.9);
	rmAddAreaInfluenceSegment(WaterTop,1.0,0.7,0.8,1.0);
	rmSetAreaCoherence(WaterTop,0.75);
	rmSetAreaSize(WaterTop,0.131,0.131);
	rmAddAreaToClass(WaterTop, classPonds);
	rmSetAreaObeyWorldCircleConstraint(WaterTop, false);
	rmBuildArea(WaterTop);

	int WaterBottom = rmCreateArea("Water Bottom");
	rmSetAreaLocation(WaterBottom,0.1,0.1);
	rmAddAreaInfluenceSegment(WaterBottom,0.0,0.0,0.25,0.25);
	rmAddAreaInfluenceSegment(WaterBottom,0.3,0.1,0.1,0.4);
	rmAddAreaInfluenceSegment(WaterBottom,0.2,0.0,0.0,0.3);
	rmSetAreaCoherence(WaterBottom,0.75);
	rmSetAreaSize(WaterBottom,0.131,0.131);
	rmAddAreaToClass(WaterBottom, classPonds);
	rmSetAreaObeyWorldCircleConstraint(WaterBottom, false);
	rmBuildArea(WaterBottom);


	int riverID = rmRiverCreate(-1, "Borneo Coast2", 15, 8, (2), (2)); //
	rmRiverAddWaypoint(riverID, 0.1, 0.9);
	rmRiverAddWaypoint(riverID, 0.3, 0.7);
	rmRiverSetShallowRadius(riverID, 50);
	rmRiverAddShallow(riverID, 0.50);
	rmRiverBuild(riverID);

	int riverID1 = rmRiverCreate(-1, "Borneo Coast2", 15, 8, (2), (2)); //
	rmRiverAddWaypoint(riverID1, 0.9, 0.1);
	rmRiverAddWaypoint(riverID1, 0.7, 0.3);
	rmRiverSetShallowRadius(riverID1, 50);
	rmRiverAddShallow(riverID1, 0.50);
	rmRiverBuild(riverID1);


	int avoid2Waters = rmCreateClassDistanceConstraint("avoid top and bottom water", classPonds, 5);
	int stayInWaterTop = rmCreateAreaMaxDistanceConstraint("stay in top water", WaterTop, 0);
	int stayInWaterBottom = rmCreateAreaMaxDistanceConstraint("stay in bottom water", WaterBottom, 0);

	int groundMap = rmCreateArea("the ground");
	rmSetAreaLocation(groundMap,0.5,0.5);
    rmSetAreaSize(groundMap,0.6, 0.6);
    rmSetAreaCoherence(groundMap, 0.05);
    rmSetAreaBaseHeight(groundMap, 3);
    rmSetAreaSmoothDistance(groundMap, 5);
    rmSetAreaObeyWorldCircleConstraint(groundMap, false);
    rmAddAreaToClass(groundMap, classPatch);
    rmAddAreaConstraint(groundMap,avoid2Waters);
    rmSetAreaMix(groundMap,baseMix);
    rmBuildArea(groundMap);
   

// ---------------------------------------------------------- DESIGN STRUCTURE ----------------------------------------------------	

	int i=0;

   int newGrass = rmCreateArea("new grass");
   rmSetAreaLocation(newGrass, 0.2, 0.8);
   rmAddAreaInfluenceSegment(newGrass,0.3,0.9,0.05,0.65);
   rmSetAreaWarnFailure(newGrass, false);
   rmSetAreaSize(newGrass,0.09, 0.09);
   rmSetAreaCoherence(newGrass, 0.95);
   rmSetAreaSmoothDistance(newGrass, 10);
   rmSetAreaObeyWorldCircleConstraint(newGrass, false);
   rmAddAreaToClass(newGrass, classPatch);
   rmSetAreaTerrainType(newGrass, "borneo\ground_grass1_borneo");
      rmAddAreaTerrainReplacement(newGrass, "borneo\shoreline1_borneo", "borneo\ground_grass2_borneo");
//   rmAddAreaTerrainLayer(newGrass, "borneo\ground_grass3_borneo", 0, 8);
	rmSetAreaMix(newGrass, "borneo_grass_a");
    rmAddAreaConstraint(newGrass,avoid2Waters);
   rmBuildArea(newGrass);

   int newGrass2 = rmCreateArea("new grass2");
   rmSetAreaLocation(newGrass2, 0.8, 0.2);
   rmAddAreaInfluenceSegment(newGrass2,0.95,0.35,0.7,0.1);
   rmSetAreaWarnFailure(newGrass2, false);
   rmSetAreaSize(newGrass2,0.09, 0.09);
   rmSetAreaCoherence(newGrass2, 0.95);
   rmSetAreaSmoothDistance(newGrass2, 10);
   rmSetAreaObeyWorldCircleConstraint(newGrass2, false);
   rmAddAreaToClass(newGrass2, classPatch);
   rmSetAreaTerrainType(newGrass2, "borneo\ground_grass1_borneo");
      rmAddAreaTerrainReplacement(newGrass2, "borneo\shoreline1_borneo", "borneo\ground_grass2_borneo");
//   rmAddAreaTerrainLayer(newGrass2, "borneo\ground_grass3_borneo", 0, 8);
	rmSetAreaMix(newGrass2, "borneo_grass_a");
   rmAddAreaConstraint(newGrass2,avoid2Waters);
   rmBuildArea(newGrass2);


		 int stayInSide = rmCreateAreaMaxDistanceConstraint("stay in side", newGrass2, 0);
		 int stayInSide1 = rmCreateAreaMaxDistanceConstraint("stay in side1", newGrass, 0);
		 int LandSquare = rmCreateBoxConstraint("Land square", 0.6, 0.9, 0.4, 0.1, 1);
		int LandSquare1 = rmCreateBoxConstraint("Land square1", 0.9, 0.6, 0.1, 0.4, 1);		 
		 
		int northforestcount = cNumberNonGaiaPlayers*14; // 6
		int stayInNorthForest = -1;
		int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land like Arkansas", "Land", false, 3.0);

		int YellowForest2 = rmCreateArea("vertical trees 1");
		rmSetAreaLocation(YellowForest2,0.3,0.75);
		rmAddAreaInfluenceSegment(YellowForest2,0.1,0.55,0.45,0.9);
		rmSetAreaSize(YellowForest2, 0.01, 0.01);
		rmSetAreaBaseHeight(YellowForest2, 0.0);
		rmSetAreaCoherence(YellowForest2, 0.75);
		rmSetAreaSmoothDistance(YellowForest2, 5);
		rmSetAreaMix(YellowForest2, "borneo_underbrush");
		 rmBuildArea(YellowForest2);
			 
		int stayInNorthForest2 = rmCreateAreaMaxDistanceConstraint("stay in north forest2", YellowForest2, 0);

				for (j=0; < 9*cNumberNonGaiaPlayers + 5 ) //18,20
		{
			int northtreeID2 = rmCreateObjectDef("north tree rockiesC"+j);
			rmAddObjectDefItem(northtreeID2, "ypTreeBorneo", rmRandInt(3,4), 4.0); // 1,2
			rmSetObjectDefMinDistance(northtreeID2, 0);
			rmSetObjectDefMaxDistance(northtreeID2, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(northtreeID2, classForest);
			rmAddObjectDefConstraint(northtreeID2, stayInNorthForest2);
			rmAddObjectDefConstraint(northtreeID2, forestConstraintshort);

			rmPlaceObjectDefAtLoc(northtreeID2, 0, 0.50, 0.50);
		}

		int YellowForest3 = rmCreateArea("vertical trees 2");
		rmSetAreaLocation(YellowForest3,0.75,0.3);
		rmAddAreaInfluenceSegment(YellowForest3,0.55,0.1,0.9,0.45);
		rmSetAreaSize(YellowForest3, 0.01, 0.01);
		rmSetAreaBaseHeight(YellowForest3, 0.0);
		rmSetAreaCoherence(YellowForest3, 0.75);
		rmSetAreaSmoothDistance(YellowForest3, 5);
		rmSetAreaMix(YellowForest3, "borneo_underbrush");
		 rmBuildArea(YellowForest3);

		int stayInNorthForest3 = rmCreateAreaMaxDistanceConstraint("stay in north forest3", YellowForest3, 0);

				for (j=0; < 9*cNumberNonGaiaPlayers + 5) //18,20
		{
			int northtreeID3 = rmCreateObjectDef("north tree rockiesD"+j);
			rmAddObjectDefItem(northtreeID3, "ypTreeBorneo", rmRandInt(3,5), 4.0); // 1,2
			rmSetObjectDefMinDistance(northtreeID3, 0);
			rmSetObjectDefMaxDistance(northtreeID3, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(northtreeID3, classForest);
			rmAddObjectDefConstraint(northtreeID3, stayInNorthForest3);
			rmAddObjectDefConstraint(northtreeID3, forestConstraintshort);
			rmPlaceObjectDefAtLoc(northtreeID3, 0, 0.50, 0.50);
		}

	
// --------------------------------------------- TRADE ROUTE ------------------------------------------------------------------------

   int numTries=1;
   int failCount=0;

   int tradeRouteID1 = rmCreateTradeRoute();

   int socketID1=rmCreateObjectDef("sockets to dock Trade Posts1");
   rmSetObjectDefTradeRouteID(socketID1, tradeRouteID1);

   rmAddObjectDefItem(socketID1, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID1, true);
   rmAddObjectDefToClass(socketID1, classSocket);
   rmSetObjectDefMinDistance(socketID1, 0.0);
   rmSetObjectDefMaxDistance(socketID1, 6.0);


	rmAddTradeRouteWaypoint(tradeRouteID1, 0.5, 0);
	rmAddRandomTradeRouteWaypoints(tradeRouteID1, 0.5, 0.05, 0, 0);
	rmAddRandomTradeRouteWaypoints(tradeRouteID1, 0.6, 0.3, 0, 0);
	rmAddRandomTradeRouteWaypoints(tradeRouteID1, 0.5, 0.5, 0, 0);
	rmAddRandomTradeRouteWaypoints(tradeRouteID1, 0.4, 0.7, 0, 0);
	rmAddRandomTradeRouteWaypoints(tradeRouteID1, 0.5, 0.95, 0, 0);
	rmAddRandomTradeRouteWaypoints(tradeRouteID1, 0.5, 1, 0, 0);

	bool placedTradeRoute1 = rmBuildTradeRoute(tradeRouteID1, "water");

	rmPlaceObjectDefAtLoc(socketID1, 0, 0.5, 0.15);
	rmPlaceObjectDefAtLoc(socketID1, 0, 0.5, 0.85);
	rmPlaceObjectDefAtLoc(socketID1, 0, 0.6, 0.35);
	rmPlaceObjectDefAtLoc(socketID1, 0, 0.4, 0.65);


// -------------------------------------------- NATIVES TP -----------------------------------------------------------------------------	
	int subCiv0=rmGetCivID("Jesuit");
	rmSetSubCiv(0, "Jesuit");
	if (subCiv0 == rmGetCivID("Jesuit"))
	{  
		int JesuitVillageID = -1;
		int JesuitVillageType = rmRandInt(1,5);
		int randomPlacement = rmRandInt(1,10);
		JesuitVillageID = rmCreateGrouping("Jesuit village", "native jesuit mission borneo 0"+JesuitVillageType);
		rmSetGroupingMinDistance(JesuitVillageID, 0.0);
		rmSetGroupingMaxDistance(JesuitVillageID, 0.0);
		rmAddGroupingToClass(JesuitVillageID, nativeClass);
		rmPlaceGroupingAtLoc(JesuitVillageID, 0, 0.2, 0.8);
		
	}
		int subCiv1=rmGetCivID("Sufi");
	rmSetSubCiv(1, "Sufi");
	if (subCiv1 == rmGetCivID("Sufi"))
	{  
		int SufiVillageID = -1;
		int SufiVillageType = rmRandInt(1,5);
		SufiVillageID = rmCreateGrouping("Sufi village", "native sufi mosque borneo "+SufiVillageType);
		rmSetGroupingMinDistance(SufiVillageID, 0.0);
		rmSetGroupingMaxDistance(SufiVillageID, 0.0);
		rmAddGroupingToClass(SufiVillageID, nativeClass);
		rmPlaceGroupingAtLoc(SufiVillageID, 0, 0.8, 0.2);  //KSW ---> Was 0.82, 0.5
		
	}


// --------------------------------------------------- STARTING LOCATION ----------------------------------------------------------	


		if (cNumberNonGaiaPlayers==2)
	   {
		if (rmRandFloat(0,1)>0.5)
		{
		rmPlacePlayer(2, 0.7, 0.5);
		rmPlacePlayer(1, 0.3, 0.5);
		}
		else
		{
		rmPlacePlayer(1, 0.7, 0.5);
		rmPlacePlayer(2, 0.3, 0.5);
		}
	   }
	   else if ( cNumberTeams == 2 )
	   {
	   if (rmRandFloat(0,1)>0.5)
	   {
	   rmSetPlacementTeam(0);
	   rmPlacePlayersLine(0.75,0.5,0.5,0.75,0,0);

	   rmSetPlacementTeam(1);
	   rmPlacePlayersLine(0.25,0.5,0.5,0.25,0,0);
	   }
	   else
	   {
	   rmSetPlacementTeam(1);
	   rmPlacePlayersLine(0.75,0.5,0.5,0.75,0,0);

	   rmSetPlacementTeam(0);
	   rmPlacePlayersLine(0.25,0.5,0.5,0.25,0,0);
	   }
	   }
	else
	{
  		rmSetPlacementSection(0.0, 0.95);
  		rmPlacePlayersCircular(0.24, 0.24, 0.00);
	}


    rmClearClosestPointConstraints();
   	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 6.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);

	int startingTCID = rmCreateObjectDef("startingTC");
	if ( rmGetNomadStart())
	{
		rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
	}
	rmAddObjectDefToClass(startingTCID, classStartingUnit);
	rmSetObjectDefMinDistance(startingTCID, 0.0);
	rmSetObjectDefMaxDistance(startingTCID, 6.0);

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "ypTreeBorneo", 1, 0.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 12.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 20.0);
	rmAddObjectDefToClass(StartAreaTreeID, classStartingUnit);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidStartingUnits);

	
	int SizeHunt=-1;
	if (cNumberNonGaiaPlayers<6)
	{
		SizeHunt=rmRandInt(9,10);
	}
	else
	{
		SizeHunt = rmRandInt(13,14); // because in 3v3, the middle guy doesn't have easy access to the map, and second hunt so
	}
	int StartDeerID1=rmCreateObjectDef("starting Deer");
	rmAddObjectDefItem(StartDeerID1, Hunt2name, SizeHunt, 5.0);
	rmSetObjectDefMinDistance(StartDeerID1, 10.0);
	rmSetObjectDefMaxDistance(StartDeerID1, 14.0);
	rmSetObjectDefCreateHerd(StartDeerID1, false);
	rmAddObjectDefToClass(StartDeerID1, classStartingUnit);
	rmAddObjectDefConstraint(StartDeerID1, shortAvoidStartingUnits);
	rmAddObjectDefConstraint(StartDeerID1, avoidWater);
	
	int StartBerriesID=rmCreateObjectDef("starting berries");
	rmAddObjectDefItem(StartBerriesID, "berrybush", 3, 3.0);
	rmSetObjectDefMinDistance(StartBerriesID, 10);
	rmSetObjectDefMaxDistance(StartBerriesID, 15);
	rmAddObjectDefToClass(StartBerriesID, classStartingUnit);
	 rmAddObjectDefConstraint(StartBerriesID, shortAvoidStartingUnits);
	 rmAddObjectDefConstraint(StartBerriesID, avoidWater);

		int silverType = -1;
	int playerGoldID = -1;

 	for(i=1; <=cNumberNonGaiaPlayers)
	{
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));

    		if(ypIsAsian(i) && rmGetNomadStart() == false)
      		rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 0), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

   		int waterFlagID=rmCreateObjectDef("HC water flag "+i);
   		rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 2.0);
  		 rmAddClosestPointConstraint(flagVsFlag);
  		 rmAddClosestPointConstraint(flagLand);
		 rmAddClosestPointConstraint(flagEdgeConstraint);


		silverType = rmRandInt(1,10);
		playerGoldID = rmCreateObjectDef("player silver closer "+i);
		rmAddObjectDefItem(playerGoldID, "MineTin", 1, 0.0);
		rmAddObjectDefToClass(playerGoldID, classStartingUnit);
		rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(playerGoldID, avoidCoinShort);
		rmAddObjectDefConstraint(playerGoldID, shortAvoidStartingUnits);
		rmSetObjectDefMinDistance(playerGoldID, 15.0);
		rmSetObjectDefMaxDistance(playerGoldID, 16.0);

		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		rmPlaceObjectDefAtLoc(StartDeerID1, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartBerriesID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Placing starting trees...
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
		 rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
  		  rmClearClosestPointConstraints();

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}
	
// ------------------------------------------------------------------ RESSOURCES : MINES and HUNTS -----------------------------------------------		
	int minePlacement=0;
	float minePositionX=-1;
	float minePositionZ=-1;
	int result=0;
	int leaveWhile=0;

	int silverIDA = -1;
	silverIDA = rmCreateObjectDef("silver half partA");
	rmAddObjectDefItem(silverIDA, "MineCopper", 1, 0.0);
	rmSetObjectDefMinDistance(silverIDA, 0.0);
	rmSetObjectDefMaxDistance(silverIDA, 0.0);
	rmAddObjectDefConstraint(silverIDA, avoidTownCenter);
	rmAddObjectDefConstraint(silverIDA, avoidNativesShort);
	//rmAddObjectDefConstraint(silverIDA, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(silverIDA, avoidCoin);
	rmAddObjectDefConstraint(silverIDA, avoidAll);
	rmAddObjectDefConstraint(silverIDA, avoidEdge);
	rmAddObjectDefConstraint(silverIDA, avoidTradeRoute);
	rmAddObjectDefConstraint(silverIDA, avoidSocket);
	rmAddObjectDefConstraint(silverIDA, avoidWater);
	
	int silverIDB = -1;
	silverIDB = rmCreateObjectDef("silver bottom partB");
	rmAddObjectDefItem(silverIDB, "MineCopper", 1, 0.0);
	rmSetObjectDefMinDistance(silverIDB, 0.0);
	rmSetObjectDefMaxDistance(silverIDB, 0.0);
	

	int numberOfMines=cNumberNonGaiaPlayers*2;
if (cNumberNonGaiaPlayers>2)
	numberOfMines=cNumberNonGaiaPlayers*3;

	minePlacement=0;
	minePositionX=-1;
	minePositionZ=-1;
	result=0;
	leaveWhile=0;
	
	while (minePlacement<numberOfMines)
	{
		minePositionX=rmRandFloat(0.02,0.98);
		minePositionZ=rmRandFloat(0.52,0.98);
		result=rmPlaceObjectDefAtLoc(silverIDA, 0, minePositionX, minePositionZ);
		if (result==1)
		{
			rmPlaceObjectDefAtLoc(silverIDB, 0, 1.0-minePositionX, 1.0-minePositionZ);
			minePlacement++;
			leaveWhile=0;
		}
		else
		{
			leaveWhile++;
		}
		if (leaveWhile==500)
			break;

	}

    failCount=0;
   for (i=0; <cNumberNonGaiaPlayers*15)
      {   
         int forest=rmCreateArea("forest "+i);
         rmSetAreaWarnFailure(forest, false);
         rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(250));
         rmSetAreaForestType(forest, forestTypeSpecial);
         rmSetAreaForestDensity(forest, 0.5);
         rmSetAreaForestClumpiness(forest, 0.0);
         rmSetAreaForestUnderbrush(forest, 0.0);
         rmSetAreaMinBlobs(forest, 1);
         rmSetAreaMaxBlobs(forest, 4);
         rmSetAreaMinBlobDistance(forest, 16.0);
         rmSetAreaMaxBlobDistance(forest, 20.0);
         rmSetAreaCoherence(forest, 0.2);
		 rmSetAreaForestDensity(forest, 0.75);
         rmSetAreaSmoothDistance(forest, 5);
         rmAddAreaToClass(forest, classForest);
         rmAddAreaConstraint(forest, forestConstraint);
		 rmAddAreaConstraint(forest, avoidCoinShort);
         rmAddAreaConstraint(forest, avoidTradeRoute);
		 rmAddAreaConstraint(forest, avoidNativesShort);
		 rmAddAreaConstraint(forest, avoidSocket);
		 rmAddAreaConstraint(forest, avoidWater);
	rmAddAreaConstraint(forest, avoidTownCenterVeryShort);			 
	rmBuildArea(forest);
      }

		int numberOfHunts=cNumberNonGaiaPlayers*1+1;
	int IbexPlacement=0;
	float IbexPositionX=-1;
	float IbexPositionZ=-1;
	result=0;
	leaveWhile=0;
	
	int IbexSize = rmRandInt(8,11);
   int IbexID=rmCreateObjectDef("Ibex herd");
   rmAddObjectDefItem(IbexID, Hunt1name, IbexSize, 8.0);
   rmSetObjectDefMinDistance(IbexID, 0.0);
   rmSetObjectDefMaxDistance(IbexID, rmXFractionToMeters(0.0));
   rmAddObjectDefConstraint(IbexID, avoidHunt1);
   rmAddObjectDefConstraint(IbexID, avoidTownCenterShort);
   rmAddObjectDefConstraint(IbexID, avoidCoinShort);
   rmAddObjectDefConstraint(IbexID, avoidEdge);
   rmAddObjectDefConstraint(IbexID, avoidPonds);
   rmSetObjectDefCreateHerd(IbexID, true);


   int IbexID1=rmCreateObjectDef("Ibex herd bottom");
   rmAddObjectDefItem(IbexID1, Hunt1name, IbexSize, 8.0);
   rmSetObjectDefMinDistance(IbexID1, 0.0);
   rmSetObjectDefMaxDistance(IbexID1, 0.0);
   rmSetObjectDefCreateHerd(IbexID1, true);


	while (IbexPlacement<numberOfHunts)
	{   
		IbexPositionX=rmRandFloat(0.02,0.98);
		IbexPositionZ=rmRandFloat(0.53,0.98);
		result=rmPlaceObjectDefAtLoc(IbexID, 0, IbexPositionX, IbexPositionZ,1);
		if (result!=0)
		{
			rmPlaceObjectDefAtLoc(IbexID1, 0, 1.0-IbexPositionX, 1.0-IbexPositionZ,1);
			IbexPlacement++;
			leaveWhile=0;
		}
		else
		{
			leaveWhile++;
		}
		if (leaveWhile==60)
			break;
	}
	
	
    numberOfHunts=cNumberNonGaiaPlayers/2;
	int ElifentPlacement=0;
	float ElifentPositionX=-1;
	float ElifentPositionZ=-1;
	result=0;
	leaveWhile=0;
	
	int ElifentSize = rmRandInt(9,10);
   int ElifentID=rmCreateObjectDef("Elephant herd");
   rmAddObjectDefItem(ElifentID, Hunt2name, ElifentSize, 8.0);
   rmSetObjectDefMinDistance(ElifentID, 0.0);
   rmSetObjectDefMaxDistance(ElifentID, rmXFractionToMeters(0.0));
   rmAddObjectDefConstraint(ElifentID, avoidHunt1);
   rmAddObjectDefConstraint(ElifentID, avoidHunt2);
   rmAddObjectDefConstraint(ElifentID, avoidTownCenterShort);
   rmAddObjectDefConstraint(ElifentID, avoidCoinShort);
   rmAddObjectDefConstraint(ElifentID, avoidEdge);
   rmAddObjectDefConstraint(ElifentID, avoidPonds);
    rmSetObjectDefCreateHerd(ElifentID, true);


   int ElifentID1=rmCreateObjectDef("Elephant herd bottom");
   rmAddObjectDefItem(ElifentID1, Hunt2name, ElifentSize, 8.0);
   rmSetObjectDefMinDistance(ElifentID1, 0.0);
   rmSetObjectDefMaxDistance(ElifentID1, 0.0);
   rmSetObjectDefCreateHerd(ElifentID1, true);
	
		while (ElifentPlacement<numberOfHunts)
	{   
		ElifentPositionX=rmRandFloat(0.02,0.98);
		ElifentPositionZ=rmRandFloat(0.53,0.98);
		result=rmPlaceObjectDefAtLoc(ElifentID, 0, ElifentPositionX, ElifentPositionZ,1);
		if (result!=0)
		{
			rmPlaceObjectDefAtLoc(ElifentID1, 0, 1.0-ElifentPositionX, 1.0-ElifentPositionZ,1);
			ElifentPlacement++;
			leaveWhile=0;
		}
		else
		{
			leaveWhile++;
		}
		if (leaveWhile==60)
			break;
	}

	
// ----------------------------------------------------------- COWS and TREASURES ------------------------------------------------------------------	
	int asianCows = rmCreateObjectDef("asianCows");
	rmAddObjectDefItem(asianCows, "ypWaterBuffalo", 1, 1.0);
	rmSetObjectDefMinDistance(asianCows, 0.0);
	rmSetObjectDefMaxDistance(asianCows, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(asianCows, avoidAll);
	rmAddObjectDefConstraint(asianCows, avoidTownCenter);
	rmAddObjectDefConstraint(asianCows, yakVsyak);
	rmAddObjectDefConstraint(asianCows, avoidEdge);
	rmPlaceObjectDefAtLoc(asianCows, 0, 0.5, 0.5,cNumberNonGaiaPlayers*4+4);
	
	
	int nuggetID1= rmCreateObjectDef("nugget1"); 
	rmAddObjectDefItem(nuggetID1, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID1, 0.0);
	rmSetObjectDefMaxDistance(nuggetID1, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID1, avoidImpassableLand);
  	rmAddObjectDefConstraint(nuggetID1, avoidNugget);
  	rmAddObjectDefConstraint(nuggetID1, avoidTownCenter);
  	rmAddObjectDefConstraint(nuggetID1, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetID1, avoidSocket);
	rmAddObjectDefConstraint(nuggetID1, avoidCoinShort);
  	rmAddObjectDefConstraint(nuggetID1, avoidPonds);
	rmAddObjectDefConstraint(nuggetID1, avoidAll);
	rmAddObjectDefConstraint(nuggetID1, avoidEdge);
	rmSetNuggetDifficulty(2, 3);
	rmPlaceObjectDefAtLoc(nuggetID1, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);
	
	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
  	rmAddObjectDefConstraint(nuggetID, avoidNugget);
  	rmAddObjectDefConstraint(nuggetID, avoidTownCenterShort);
  	rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetID, avoidSocket);
	rmAddObjectDefConstraint(nuggetID, avoidCoinShort);
  	rmAddObjectDefConstraint(nuggetID, avoidPonds);
	rmAddObjectDefConstraint(nuggetID, avoidAll);
	rmSetNuggetDifficulty(1, 2);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4);
	

// ------------------------------------------------------ FISH ---------------------------------------------------------------    
  int fishID=rmCreateObjectDef("fish top");
  rmAddObjectDefItem(fishID, "ypFishMolaMola", 1, 2.0);
  rmSetObjectDefMinDistance(fishID, 0.0);
  rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(fishID, stayInWaterTop);
  rmAddObjectDefConstraint(fishID, fishVsFishID);
  rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers/2+6);

  int whalesID=rmCreateObjectDef("whales top");
  rmAddObjectDefItem(whalesID, "HumpbackWhale", 1, 0.0);
  rmSetObjectDefMinDistance(whalesID, 0.0);
  rmSetObjectDefMaxDistance(whalesID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(whalesID, stayInWaterTop);
  rmAddObjectDefConstraint(whalesID, whaleLand);
  rmAddObjectDefConstraint(whalesID, whaleVsWhaleID);
  rmAddObjectDefConstraint(whalesID, fishWhale);
  rmPlaceObjectDefAtLoc(whalesID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2+3);

  int fishID1=rmCreateObjectDef("fish bottom");
  rmAddObjectDefItem(fishID1, "ypFishMolaMola", 1, 2.0);
  rmSetObjectDefMinDistance(fishID1, 0.0);
  rmSetObjectDefMaxDistance(fishID1, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(fishID1, stayInWaterBottom);
  rmAddObjectDefConstraint(fishID1, fishVsFishID);
  rmPlaceObjectDefAtLoc(fishID1, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers/2+6);

  int whalesID1=rmCreateObjectDef("whales bottom");
  rmAddObjectDefItem(whalesID1, "HumpbackWhale", 1, 0.0);
  rmSetObjectDefMinDistance(whalesID1, 0.0);
  rmSetObjectDefMaxDistance(whalesID1, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(whalesID1, stayInWaterBottom);
  rmAddObjectDefConstraint(whalesID1, whaleLand);
  rmAddObjectDefConstraint(whalesID1, whaleVsWhaleID);
  rmAddObjectDefConstraint(whalesID1, fishWhale);
  rmPlaceObjectDefAtLoc(whalesID1, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2+3);


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


     // ------------------------------------------------------ KOTH ---------------------------------------------------------------------


   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .05, 0);
   }


rmSetStatusText("",1.00);

	
 //END
}  
