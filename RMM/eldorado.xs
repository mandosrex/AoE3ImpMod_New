// East India Trading Company - Deccan
// August 06 - PJJ
// Started with Amazonia script

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{

  // Text
  // These status text lines are used to manually animate the map generation progress bar
  rmSetStatusText("",0.01);

  // determines map orientation - 1 is E/W, 2 is N/S
  int whichVersion = rmRandInt(1,2);
  
  // version switcher for testing
  // whichVersion = 2;
  
  //Bhakti/Udasi appear on this map
  int subCiv0=-1;
  int subCiv1=-1;
  int subCiv2=-1;

  if (rmAllocateSubCivs(3) == true) {
		subCiv0=rmGetCivID("Incas");
		rmEchoInfo("subCiv0 is Incas "+subCiv0);
		if (subCiv0 >= 0)
			rmSetSubCiv(0, "Incas");

		subCiv1=rmGetCivID("Maya");
		rmEchoInfo("subCiv1 is Maya "+subCiv1);
		if (subCiv1 >= 0)
			rmSetSubCiv(1, "Maya");
    
    subCiv2=rmGetCivID("zapotec");
		rmEchoInfo("subCiv1 is zapotec "+subCiv2);
		if (subCiv2 >= 0)
			rmSetSubCiv(2, "zapotec");
	}

   // Picks the map size
	int playerTiles = 13000;
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=12000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=11000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=10000;			

  int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
  rmEchoInfo("Map size="+size+"m x "+size+"m");
  rmSetMapSize(size, size);

	rmSetWindMagnitude(2);

  // Picks a default water height
  rmSetSeaLevel(-3.0);

   // Picks default terrain and water
	//	rmSetMapElevationParameters(long type, float minFrequency, long numberOctaves, float persistence, float heightVariation)
	rmSetMapElevationParameters(cElevTurbulence, 0.06, 1, 0.4, 3.0);
  rmSetMapElevationHeightBlend(0.6);
	rmSetMapType("yucatan");
	rmSetMapType("grass");
	rmSetMapType("land");
	rmSetMapType("samerica");
	rmSetWorldCircleConstraint(true);
  rmSetLightingSet("Borneo");

  // Init map.
  rmSetBaseTerrainMix("amazon grass");
  rmTerrainInitialize("deccan\ground_grass2_deccan", -2);

	chooseMercs();

	// Make it rain
  rmSetGlobalRain( 0.3 );

  // Define some classes. These are used later for constraints.
  int classPlayer=rmDefineClass("player");
  rmDefineClass("classForest");
  rmDefineClass("importantItem");
  rmDefineClass("socketClass");
  int foodClass = rmDefineClass("FoodClass");

  // -------------Define constraints
  // These are used to have objects and areas avoid each other
   
  // Map edge constraints
  int playerEdgeConstraint=rmCreatePieConstraint("player edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.45), rmDegreesToRadians(0), rmDegreesToRadians(360));
  int resourceEdgeConstraint=rmCreatePieConstraint("resource edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
  int forestMidConstraint=rmCreatePieConstraint("dense middle forests", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.16), rmDegreesToRadians(0), rmDegreesToRadians(360));
  int edgeForestConstraint=rmCreatePieConstraint("Ring for sparse forests near edge of map", 0.5, 0.5, rmXFractionToMeters(0.24), rmXFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));

  // Player constraints
  int playerConstraint=rmCreateClassDistanceConstraint("avoid players", classPlayer, 10.0);
  int playerConstraintMid=rmCreateClassDistanceConstraint("resources avoid players", classPlayer, 15.0);
  int playerConstraintFar=rmCreateClassDistanceConstraint("resources avoid players far", classPlayer, 35.0);
  int playerConstraintNative=rmCreateClassDistanceConstraint("natives avoid players far", classPlayer, 35.0);
  int playerConstraintNugget=rmCreateClassDistanceConstraint("nuggets avoid players far", classPlayer, 65.0);
  int avoidTC = rmCreateTypeDistanceConstraint("avoid TCs", "TownCenter", 20.0);
 
  // Nature avoidance
  int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
  int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 25.0);
  int forestConstraintSmall=rmCreateClassDistanceConstraint("forest vs. forest less", rmClassID("classForest"), 15.0);
  int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
  int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "mine", 50.0);
  int avoidGold=rmCreateTypeDistanceConstraint("avoid gold", "MineShipRuins2", 20.0);
  int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0);
  int avoidFood = rmCreateClassDistanceConstraint("avoid foods", foodClass, 12.0);
  int avoidFoodMid = rmCreateClassDistanceConstraint("avoid foods mid", foodClass, 25.0);
  int avoidFoodFar = rmCreateClassDistanceConstraint("avoid foods far", foodClass, 45.0);
  int avoidElephants = rmCreateTypeDistanceConstraint("avoid elephants far", "ypWildElephant", 60.0);
  int avoidHerdables=rmCreateTypeDistanceConstraint("avoids cattle", "ypWaterBuffalo", 65.0); 
  int avoidImportantItem=rmCreateClassDistanceConstraint("important stuff avoids each other", rmClassID("importantItem"), 5.0);
  int avoidImportantItemFar=rmCreateClassDistanceConstraint("important stuff avoids each other far", rmClassID("importantItem"), 15.0);
  int avoidBerries = rmCreateTypeDistanceConstraint("avoid berries", "berrybush", 65.0);
  
  // Avoid impassable land
  int avoidImpassableLandShort=rmCreateTerrainDistanceConstraint("avoid impassable land short", "Land", false, 4.0);
  int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
  int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("avoid impassable land far", "Land", false, 12.5);
  
  // Constraint to avoid water.
  int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 4.0);
  int avoidWater10 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 10.0);
  

  // Unit avoidance
  int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 10.0);

  // general avoidance
  int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 4.0);

  // Trade route avoidance.
  int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
  int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 35.0);
  int avoidTradeRouteSocketsFar=rmCreateTypeDistanceConstraint("avoid trade route sockets far", "Socket", 25.0);
  int avoidTradeRouteSockets=rmCreateTypeDistanceConstraint("avoid trade route sockets", "Socket", 10.0);

  // Player placing  


	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);

	if ( cNumberTeams <= 2 && teamZeroCount <= 4 && teamOneCount <= 4)
	{
		rmSetPlacementTeam(0);
		rmSetPlacementSection(0.7, 0.9); // 0.5
		rmSetTeamSpacingModifier(0.25);
		rmPlacePlayersCircular(0.34, 0.36, 0);
			
		rmSetPlacementTeam(1);
		rmSetPlacementSection(0.2, 0.4); // 0.5
		rmSetTeamSpacingModifier(0.25);
		rmPlacePlayersCircular(0.34, 0.36, 0);
	}
	else
	{
		rmSetTeamSpacingModifier(0.7);
		rmPlacePlayersCircular(0.34, 0.36, 0.0);
	}

  

 // determine where the river is going to be now so we can push the player on the dry side out a bit
  int randomRiver = rmRandInt(1,2);
  // Text
  rmSetStatusText("",0.10);

  float playerFraction=rmAreaTilesToFraction(100);
  for(i=1; <cNumberPlayers) {
    // Create the area.
    int id=rmCreateArea("Player"+i);
    // Assign to the player.
    rmSetPlayerArea(i, id);
    // Set the size.
    rmSetAreaSize(id, playerFraction, playerFraction);
    rmAddAreaToClass(id, classPlayer); 
    rmAddAreaConstraint(id, playerConstraint); 
    rmAddAreaConstraint(id, playerEdgeConstraint); 
    rmAddAreaConstraint(id, avoidImpassableLand);
    rmAddAreaConstraint(id, avoidTradeRoute);
    rmAddAreaConstraint(id, avoidWater10);
    rmSetAreaCoherence(id, 1.0);
    //rmSetAreaLocPlayer(id, i);
    rmSetAreaWarnFailure(id, false);
  }
  
  rmBuildAllAreas();
  
  // Text
  rmSetStatusText("",0.25);

  // Placement order
  // Rivers & Cliffs -> Trade route -> Resources -> Nuggets


  
  // Cliff only present in non-FFA games
  int startingCliff1=rmCreateArea("Plateau");
  rmSetAreaSize(startingCliff1, .125, .125);
  rmSetAreaLocation(startingCliff1, .5, .5);
  rmSetAreaWarnFailure(startingCliff1, false);
  rmSetAreaSmoothDistance(startingCliff1, 10);
  rmSetAreaCoherence(startingCliff1, .6);
  rmSetAreaCliffType(startingCliff1, "ElDorado");
  rmSetAreaCliffEdge(startingCliff1, 6, .14, 0, 1.0, 0);
//  if(cNumberTeams == 2) 
    rmSetAreaCliffHeight(startingCliff1, 6, 2.0, 0.5);

//  else
//    rmSetAreaCliffHeight(startingCliff1, 0, 0.0, 0.5);
    
  rmSetAreaTerrainType(startingCliff1, "amazon\ground4_ama");
  rmAddAreaTerrainLayer(startingCliff1, "amazon\ground4_ama", 1, 5);
  rmAddAreaTerrainLayer(startingCliff1, "props\east_colony2", 5, 7);
  rmAddAreaTerrainLayer(startingCliff1, "amazon\ground4_ama", 7, 12);
  rmAddAreaTerrainLayer(startingCliff1, "props\east_colony2", 12, 14);
  rmAddAreaTerrainLayer(startingCliff1, "amazon\ground4_ama", 14, 18);
  rmAddAreaTerrainLayer(startingCliff1, "props\east_colony2", 18, 20);
  rmAddAreaTerrainLayer(startingCliff1, "amazon\ground4_ama", 20, 24);
  rmAddAreaTerrainLayer(startingCliff1, "props\east_colony2", 24, 26);
  rmAddAreaTerrainLayer(startingCliff1, "amazon\ground4_ama", 26, 30);
  rmAddAreaTerrainLayer(startingCliff1, "props\east_colony2", 30, 32);
  rmAddAreaTerrainLayer(startingCliff1, "amazon\ground4_ama", 32, 36);
  rmAddAreaTerrainLayer(startingCliff1, "props\east_colony2", 36, 46);
  rmSetAreaMix(startingCliff1, "amazon grass");
  //rmSetAreaCliffPainting(startingCliff1, true, true, true, 0, true);
  rmAddAreaConstraint(startingCliff1, avoidWater10);
  rmBuildArea(startingCliff1);
  

  // Natives
  
  int randomNative1 = rmRandInt(1,3);
  int randomNative2 = rmRandInt(1,3);
  
  string nativeString1 = "native inca village ";
  string nativeString2 = "native maya village ";
  string nativeString3 = "native zapotec village ";
  
  string stringNative1 = "";
  string stringNative2 = "";
  
  if(randomNative1 == 1)
    stringNative1 = nativeString1;
  
  else if (randomNative1 == 2)
    stringNative1 = nativeString2;
  
  else
    stringNative1 = nativeString3;
    
  if(randomNative2 == 1)
    stringNative2 = nativeString1;
  
  else if (randomNative2 == 2)
    stringNative2 = nativeString2;
  
  else
    stringNative2 = nativeString3;
  
  
  if (subCiv0 == rmGetCivID("Incas")) {  
    int udasiVillageAID = -1;
    int udasiVillageType = rmRandInt(1,5);
    udasiVillageAID = rmCreateGrouping("Udasi village A", stringNative1+udasiVillageType);
    rmSetGroupingMinDistance(udasiVillageAID, 0.0);
    rmSetGroupingMaxDistance(udasiVillageAID, 15.0);
    rmAddGroupingConstraint(udasiVillageAID, avoidImpassableLand);
    rmAddGroupingToClass(udasiVillageAID, rmClassID("importantItem"));
    
        rmPlaceGroupingAtLoc(udasiVillageAID, 0, 0.1, 0.5); 
        rmPlaceGroupingAtLoc(udasiVillageAID, 0, 0.5, 0.38);
  }
    
    if (subCiv1 == rmGetCivID("Maya")) {   
      int bhaktiVillageAID = -1;
      int bhaktiVillageType = rmRandInt(1,5);
      bhaktiVillageAID = rmCreateGrouping("Bhakti village A", stringNative2+bhaktiVillageType);
      rmSetGroupingMinDistance(bhaktiVillageAID, 0.0);
      rmSetGroupingMaxDistance(bhaktiVillageAID, 15.0);
      rmAddGroupingConstraint(bhaktiVillageAID, avoidImpassableLand);
      rmAddGroupingToClass(bhaktiVillageAID, rmClassID("importantItem"));
      
        rmPlaceGroupingAtLoc(bhaktiVillageAID, 0, 0.9, 0.5);  
        rmPlaceGroupingAtLoc(bhaktiVillageAID, 0, 0.5, 0.62);
  }

  
   // Text
   rmSetStatusText("",0.45);

	// PLAYER STARTING RESOURCES

   rmClearClosestPointConstraints();

	// Player placement
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 10.0);
  
	int TCID = rmCreateObjectDef("player TC");
	if (rmGetNomadStart()) {
			rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
  }
	else {
		rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);
  }

	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 5.0);

	rmAddObjectDefConstraint(TCID, avoidTownCenter);
	rmAddObjectDefConstraint(TCID, playerEdgeConstraint);
	rmAddObjectDefConstraint(TCID, avoidImpassableLand);

	int playerSilverID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playerSilverID, "MineGold", 1, 0);
	rmAddObjectDefConstraint(playerSilverID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerSilverID, avoidTownCenter);
	rmSetObjectDefMinDistance(playerSilverID, 12.0);
	rmSetObjectDefMaxDistance(playerSilverID, 16.0);
  rmAddObjectDefConstraint(playerSilverID, avoidImpassableLand);

	int playerFoodID=rmCreateObjectDef("player nilgai");
  rmAddObjectDefItem(playerFoodID, "capybara", 8, 6.0);
  rmAddObjectDefToClass(playerFoodID, foodClass);
  rmSetObjectDefMinDistance(playerFoodID, 10);
  rmSetObjectDefMaxDistance(playerFoodID, 14);
	rmAddObjectDefConstraint(playerFoodID, avoidAll);
  rmAddObjectDefConstraint(playerFoodID, avoidFood);
  rmAddObjectDefConstraint(playerFoodID, avoidImpassableLand);
  rmSetObjectDefCreateHerd(playerFoodID, false);

	int playerTreeID=rmCreateObjectDef("player trees");
  rmAddObjectDefItem(playerTreeID, "treeamazon", 7, 13);
  rmSetObjectDefMinDistance(playerTreeID, 8);
  rmSetObjectDefMaxDistance(playerTreeID, 12);
	rmAddObjectDefConstraint(playerTreeID, avoidAll);
  rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
  
  int playerNuggetID=rmCreateObjectDef("player nugget");
  rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
  rmSetObjectDefMinDistance(playerNuggetID, 15.0);
  rmSetObjectDefMaxDistance(playerNuggetID, 20.0);
  rmAddObjectDefConstraint(playerNuggetID, avoidAll);
  rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
  
  int playerCrateID=rmCreateObjectDef("bonus starting crates");
  rmAddObjectDefItem(playerCrateID, "crateOfFood", 3, 7.0);
  rmAddObjectDefItem(playerCrateID, "crateOfWood", 2, 4.0);
  rmAddObjectDefItem(playerCrateID, "crateOfCoin", 2, 4.0);
  rmSetObjectDefMinDistance(playerCrateID, 10);
  rmSetObjectDefMaxDistance(playerCrateID, 12);
	rmAddObjectDefConstraint(playerCrateID, avoidAll);
  rmAddObjectDefConstraint(playerCrateID, avoidImpassableLand);

  
  int playerBerryID=rmCreateObjectDef("player berries");
  rmAddObjectDefItem(playerBerryID, "berryBush", 4, 4.0);
  rmSetObjectDefMinDistance(playerBerryID, 10);
  rmSetObjectDefMaxDistance(playerBerryID, 15);
	rmAddObjectDefConstraint(playerBerryID, avoidAll);
  rmAddObjectDefConstraint(playerBerryID, avoidImpassableLand);

	for(i=1; <cNumberPlayers) {
	  rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	  vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

	  rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	  rmPlaceObjectDefAtLoc(playerSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	  rmPlaceObjectDefAtLoc(playerFoodID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//    rmPlaceObjectDefAtLoc(playerCrateID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceObjectDefAtLoc(playerBerryID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

    rmSetNuggetDifficulty(1, 1);
    rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    
    // Japanese
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

  }
  
  rmClearClosestPointConstraints();
  
  // Text
  rmSetStatusText("",0.55);
  
	int silverID = -1;
	int silverCount = 3;
  
  if (cNumberNonGaiaPlayers < 5)
    silverCount = 4;
  
	rmEchoInfo("silver count = "+silverCount);

  int rightSilverID = rmCreateObjectDef("silver "+i);
  rmAddObjectDefItem(rightSilverID, "MineShipRuins2", 1, 0.0);
  rmSetObjectDefMinDistance(rightSilverID, rmXFractionToMeters(0.2));
  rmSetObjectDefMaxDistance(rightSilverID, rmXFractionToMeters(0.48));
  rmAddObjectDefConstraint(rightSilverID, avoidAll);
  rmAddObjectDefConstraint(rightSilverID, avoidImpassableLand);
  rmAddObjectDefConstraint(rightSilverID, avoidImportantItem);
  rmAddObjectDefConstraint(rightSilverID, playerConstraintFar);
  rmAddObjectDefConstraint(rightSilverID, avoidGold);
  rmAddObjectDefConstraint(rightSilverID, avoidTradeRouteSockets);
  rmPlaceObjectDefInArea(rightSilverID, 0, rmAreaID("Plateau"), cNumberNonGaiaPlayers*4);

  
  int numTries=4*cNumberNonGaiaPlayers;
  int failCount=0;
  
  // Text
  rmSetStatusText("",0.60);

  // Central temples
	int hardNugget= rmCreateObjectDef("nugget hard"); 
	rmAddObjectDefItem(hardNugget, "AztecTempleProp", 1, 0.0);
	rmSetObjectDefAllowOverlap(hardNugget, false);
  rmSetObjectDefMinDistance(hardNugget, rmXFractionToMeters(0.2));
  rmSetObjectDefMaxDistance(hardNugget, rmXFractionToMeters(0.48));
  rmAddObjectDefConstraint(hardNugget, avoidAll);
  rmAddObjectDefConstraint(hardNugget, avoidImpassableLand);
  rmAddObjectDefConstraint(hardNugget, avoidImportantItemFar);
  rmAddObjectDefConstraint(hardNugget, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(hardNugget, playerConstraintFar);
  rmAddObjectDefToClass(hardNugget, rmClassID("importantItem"));
  rmPlaceObjectDefInArea(hardNugget, 0, rmAreaID("Plateau"), 1);

	int hardNugget2= rmCreateObjectDef("nugget hard 2"); 
	rmAddObjectDefItem(hardNugget2, "AztecTempleProp", 1, 0.0);
	rmSetObjectDefAllowOverlap(hardNugget2, false);
  rmSetObjectDefMinDistance(hardNugget2, rmXFractionToMeters(0.2));
  rmSetObjectDefMaxDistance(hardNugget2, rmXFractionToMeters(0.48));
  rmAddObjectDefConstraint(hardNugget2, avoidAll);
  rmAddObjectDefConstraint(hardNugget2, avoidImpassableLand);
  rmAddObjectDefConstraint(hardNugget2, avoidImportantItemFar);
  rmAddObjectDefConstraint(hardNugget2, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(hardNugget2, playerConstraintFar);
  rmAddObjectDefToClass(hardNugget2, rmClassID("importantItem"));
  rmPlaceObjectDefInArea(hardNugget2, 0, rmAreaID("Plateau"), 1);


  // heavier forests in central area
  for (i=0; <numTries) {   
    int forest=rmCreateArea("foresta"+i, startingCliff1);
    rmSetAreaWarnFailure(forest, false);
    rmSetAreaSize(forest, rmAreaTilesToFraction(230), rmAreaTilesToFraction(270));
    rmSetAreaForestType(forest, "amazon rain forest");
    rmSetAreaForestDensity(forest, 0.9);
    rmSetAreaForestClumpiness(forest, 0.8);
    rmSetAreaForestUnderbrush(forest, 0.5);
    rmSetAreaCoherence(forest, 0.7);
    rmAddAreaToClass(forest, rmClassID("classForest"));
    rmAddAreaConstraint(forest, forestConstraintSmall);
    rmAddAreaConstraint(forest, forestObjConstraint);
    rmAddAreaConstraint(forest, forestMidConstraint);
    rmAddAreaConstraint(forest, avoidImportantItem);
    rmAddAreaConstraint(forest, playerConstraintMid);
    rmAddAreaConstraint(forest, avoidWater4); 
    rmAddAreaConstraint(forest, avoidTradeRoute);
    rmAddAreaConstraint(forest, avoidNugget);
    rmAddAreaConstraint(forest, avoidTradeRouteSocketsFar);

     if(rmBuildArea(forest)==false)
     {
        // Stop trying once we fail 3 times in a row.
        failCount++;
        if(failCount==3)
           break;
     }
     else
        failCount=0; 
  } 
 
  // sparser forests around the outside where the gold is
  numTries=7*cNumberNonGaiaPlayers;
  failCount=0;
  
  for (i=0; <numTries) {   
    int outerForest=rmCreateArea("forestb"+i);
    rmSetAreaWarnFailure(outerForest, false);
    rmSetAreaSize(outerForest, rmAreaTilesToFraction(120), rmAreaTilesToFraction(170));
    rmSetAreaForestType(outerForest, "amazon rain forest");
    rmSetAreaForestDensity(outerForest, 0.8);
    rmSetAreaForestClumpiness(outerForest, 0.45);
    rmSetAreaForestUnderbrush(outerForest, 0.8);
    rmSetAreaCoherence(outerForest, 0.5);
    rmAddAreaToClass(outerForest, rmClassID("classForest"));
    rmAddAreaConstraint(outerForest, forestConstraint);
    rmAddAreaConstraint(outerForest, forestObjConstraint);
    rmAddAreaConstraint(outerForest, edgeForestConstraint);
    rmAddAreaConstraint(outerForest, avoidImportantItem);
    rmAddAreaConstraint(outerForest, avoidWater4); 
    rmAddAreaConstraint(outerForest, playerConstraintMid); 
    rmAddAreaConstraint(outerForest, avoidTradeRoute);
    rmAddAreaConstraint(outerForest, avoidTradeRouteSocketsFar);

    if(rmBuildArea(outerForest)==false)
    {
      // Stop trying once we fail 3 times in a row.
      failCount++;
      if(failCount==3)
        break;
    }
    else
      failCount=0; 
  } 
    
  // Text
  rmSetStatusText("",0.75);

  int foodCount = rmRandInt(6,8);

  int foodID=rmCreateObjectDef("nilgai");
  rmAddObjectDefItem(foodID, "tapir", foodCount, 6.0);
  rmAddObjectDefToClass(foodID, foodClass);
  rmSetObjectDefMinDistance(foodID, 0.0);
  rmSetObjectDefMaxDistance(foodID, rmXFractionToMeters(0.15));
  rmAddObjectDefConstraint(foodID, avoidImpassableLand);
  rmAddObjectDefConstraint(foodID, playerConstraintMid);
  rmAddObjectDefConstraint(foodID, avoidFoodMid);
  rmAddObjectDefConstraint(foodID, avoidImportantItem);
  rmAddObjectDefConstraint(foodID, avoidTradeRouteSocketsFar); 
  rmSetObjectDefCreateHerd(foodID, true);
  rmPlaceObjectDefAtLoc(foodID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
  
  // smaller herds around the map edges
  foodCount = rmRandInt(4,5);
  
  int food2ID=rmCreateObjectDef("more nilgai");
  rmAddObjectDefItem(food2ID, "capybara", foodCount, 4.0);
  rmAddObjectDefToClass(food2ID, foodClass);
  rmSetObjectDefMinDistance(food2ID, 0.0);
  rmSetObjectDefMaxDistance(food2ID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(food2ID, avoidImpassableLand);
  rmAddObjectDefConstraint(food2ID, avoidFoodFar);
  rmAddObjectDefConstraint(food2ID, playerConstraintMid);
  rmAddObjectDefConstraint(food2ID, avoidWater4);
  rmAddObjectDefConstraint(food2ID, avoidImportantItem); 
  rmAddObjectDefConstraint(food2ID, edgeForestConstraint);
  rmAddObjectDefConstraint(food2ID, avoidTradeRouteSocketsFar); 
  rmSetObjectDefCreateHerd(food2ID, true);
  rmPlaceObjectDefAtLoc(food2ID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
  
  foodCount = rmRandInt(2,2);
  

  
  // Berries
	int berriesID=rmCreateObjectDef("berries");
	rmAddObjectDefItem(berriesID, "berrybush", 4, 3.0);
	rmSetObjectDefMinDistance(berriesID, 0);
	rmSetObjectDefMaxDistance(berriesID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(berriesID, avoidTradeRoute);
	rmAddObjectDefConstraint(berriesID, avoidTradeRouteSocketsFar);
	rmAddObjectDefConstraint(berriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(berriesID, playerConstraintFar); 
	rmAddObjectDefConstraint(berriesID, avoidBerries);
	rmAddObjectDefConstraint(berriesID, avoidImportantItem);
	rmAddObjectDefConstraint(berriesID, avoidResource);
	rmPlaceObjectDefAtLoc(berriesID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4);  

  // Text
  rmSetStatusText("",0.90);
  
  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.075;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }
  
  // some hostile gaia


  int herdID=rmCreateObjectDef("water buffalo");
  rmAddObjectDefItem(herdID, "xpSkullKnight", 3, 2.5);
        rmAddObjectDefItem(herdID, "crateOfCoin", 1, 4.0);
  rmSetObjectDefMinDistance(herdID, 0.0);
  rmSetObjectDefMaxDistance(herdID, rmXFractionToMeters(0.225));
  rmAddObjectDefConstraint(herdID, avoidHerdables);
  rmAddObjectDefConstraint(herdID, avoidAll);
  rmAddObjectDefConstraint(herdID, avoidTradeRoute);
  rmAddObjectDefConstraint(herdID, avoidImpassableLandShort);
  rmAddObjectDefConstraint(herdID, avoidTradeRouteSocketsFar);
  rmAddObjectDefConstraint(herdID, avoidTC);
        rmPlaceObjectDefInArea(herdID, 0, rmAreaID("Plateau"), cNumberNonGaiaPlayers*2);



	int crazyNugget= rmCreateObjectDef("nugget crazy"); 
	rmAddObjectDefItem(crazyNugget, "NativeHouseIncaProp", 1, 0.0);
	rmSetObjectDefMinDistance(crazyNugget, 0.0);
	rmSetObjectDefMaxDistance(crazyNugget, rmXFractionToMeters(0.25));
	rmAddObjectDefConstraint(crazyNugget, avoidImpassableLand);
  rmAddObjectDefConstraint(crazyNugget, avoidNugget);
  rmAddObjectDefConstraint(crazyNugget, avoidWater4);
  rmAddObjectDefConstraint(crazyNugget, avoidAll);
  rmAddObjectDefConstraint(crazyNugget, playerConstraintNugget);
  rmAddObjectDefConstraint(crazyNugget, avoidImportantItemFar);
  rmAddObjectDefConstraint(crazyNugget, avoidTradeRouteSockets);
  rmAddObjectDefToClass(crazyNugget, rmClassID("importantItem"));
        rmPlaceObjectDefInArea(crazyNugget, 0, rmAreaID("Plateau"), cNumberNonGaiaPlayers*3);

  
	int strongholdID= rmCreateObjectDef("stronghold"); 
	rmAddObjectDefItem(strongholdID, "HuariStrongholdAndes", 1, 0.0);
	rmSetObjectDefMinDistance(strongholdID, 0.0);
	rmSetObjectDefMaxDistance(strongholdID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(strongholdID, avoidNugget);
	rmAddObjectDefConstraint(strongholdID, avoidAll);
	rmAddObjectDefConstraint(strongholdID, avoidImpassableLand);
	rmAddObjectDefConstraint(strongholdID, playerConstraintNugget);
	rmAddObjectDefConstraint(strongholdID, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(strongholdID, avoidImportantItemFar);
	rmAddObjectDefToClass(strongholdID, rmClassID("importantItem"));
        rmPlaceObjectDefInArea(strongholdID, 0, rmAreaID("Plateau"), cNumberNonGaiaPlayers);


  
  // medium nuggets
	int mediumNugget= rmCreateObjectDef("nugget medium"); 
	rmAddObjectDefItem(mediumNugget, "Skulls", 1, 0.0);
	rmAddObjectDefItem(mediumNugget, "UnderbrushAmazon", 2, 4.0);
	rmSetObjectDefMinDistance(mediumNugget, rmXFractionToMeters(0.15));
	rmSetObjectDefMaxDistance(mediumNugget, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(mediumNugget, avoidImpassableLand);
	rmAddObjectDefConstraint(mediumNugget, avoidNugget);
	rmAddObjectDefConstraint(mediumNugget, avoidTradeRoute);
	rmAddObjectDefConstraint(mediumNugget, avoidWater4);
	rmAddObjectDefConstraint(mediumNugget, avoidAll);
	rmAddObjectDefConstraint(mediumNugget, playerConstraintNugget);
	rmAddObjectDefConstraint(mediumNugget, resourceEdgeConstraint);
	rmAddObjectDefConstraint(mediumNugget, avoidImportantItem);
	rmAddObjectDefConstraint(mediumNugget, avoidTradeRouteSocketsFar); 
	rmPlaceObjectDefAtLoc(mediumNugget, 0, 0.5, 0.5, cNumberNonGaiaPlayers*10);

  // easy nuggets 
	int easyNugget= rmCreateObjectDef("easy nuggets"); 
	rmAddObjectDefItem(easyNugget, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(2, 2);
	rmSetObjectDefMinDistance(easyNugget, rmXFractionToMeters(0.25));
	rmSetObjectDefMaxDistance(easyNugget, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(easyNugget, avoidImpassableLand);
	rmAddObjectDefConstraint(easyNugget, avoidNugget);
	rmAddObjectDefConstraint(easyNugget, avoidTradeRoute);
	rmAddObjectDefConstraint(easyNugget, avoidWater4);
	rmAddObjectDefConstraint(easyNugget, avoidAll);
	rmAddObjectDefConstraint(easyNugget, playerConstraintFar);
	rmAddObjectDefConstraint(easyNugget, resourceEdgeConstraint);
	rmAddObjectDefConstraint(easyNugget, avoidImportantItem); 
	rmAddObjectDefConstraint(easyNugget, avoidTradeRouteSockets); 
	rmPlaceObjectDefAtLoc(easyNugget, 0, 0.5, 0.5, cNumberNonGaiaPlayers*7);
  
  // Team nuggets
  if(cNumberTeams == 2 && cNumberNonGaiaPlayers > 2){
    rmSetNuggetDifficulty(2, 4);
	  rmPlaceObjectDefAtLoc(easyNugget, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
  }
  
  // Text
  rmSetStatusText("",1.0);
      
}  
