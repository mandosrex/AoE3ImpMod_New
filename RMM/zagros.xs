/* Durokan's Zagros - February 16 2020 Version 1.4*/

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";
 
void main(void) {
 
   //Picks the map size
	int playerTiles=13000;
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=12000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=11000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=10000;
	
   int size = 2.0 * sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmSetMapSize(size, size);

   rmSetMapType("land");
   rmSetMapType("desert");
   rmSetMapType("asia");
   rmSetMapType("middleEast");
   rmTerrainInitialize("grass");
   rmSetLightingSet("Zagros");

   rmSetWorldCircleConstraint(false);

   rmDefineClass("classForest");
   rmDefineClass("classPlateau");

			rmSetStatusText("",0.01);
	
   //Constraints
   int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 16.0);

   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.49), rmDegreesToRadians(0), rmDegreesToRadians(360));

   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
   int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);

   int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 50.0);
   int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 10.0);

   int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 50.0);

   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
   int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 60.0);
   int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 5.0);

   int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 8.0);
   int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 25.0);

   int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 35.0);
   int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
   int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 40.0);  

   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 60.0);
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // Player placing  
   float spawnSwitch = rmRandFloat(0,1.2);

	if (cNumberTeams == 2){
		if (spawnSwitch <=0.6){
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.15, 0.35, 0.15, 0.65, 0, 0);
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.85, 0.65, 0.85, 0.35, 0, 0);
		}else if(spawnSwitch <=1.2){
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.15, 0.35, 0.15, 0.65, 0, 0);
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.85, 0.65, 0.85, 0.35, 0, 0);
		}
	}else{
		rmPlacePlayersCircular(0.4, 0.4, 0.02);
	}
   
   chooseMercs();
		rmSetStatusText("",0.1);

   int continent2 = rmCreateArea("continent");
   rmSetAreaSize(continent2, 1.0, 1.0);
   rmSetAreaLocation(continent2, 0.5, 0.5);
   rmSetAreaMix(continent2, "deccan_grassy_dirt_a");
   rmSetAreaBaseHeight(continent2, 10.0);
   rmSetAreaCoherence(continent2, 1.0);
   rmSetAreaSmoothDistance(continent2, 10);
   rmSetAreaHeightBlend(continent2, 1);
   rmSetAreaElevationNoiseBias(continent2, 0);
   rmSetAreaElevationEdgeFalloffDist(continent2, 10);
   rmSetAreaElevationVariation(continent2, 5);
   rmSetAreaElevationPersistence(continent2, .2);
   rmSetAreaElevationOctaves(continent2, 5);
   rmSetAreaElevationMinFrequency(continent2, 0.04);
   rmSetAreaElevationType(continent2, cElevTurbulence);  
   rmBuildArea(continent2);    

   int classPatch = rmDefineClass("patch");
   int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 22.0);
   int classCenter = rmDefineClass("center");
   int avoidCenter = rmCreateClassDistanceConstraint("avoid center", rmClassID("center"), 3.0);
   int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));

   int center = rmCreateArea("center");
   rmAddAreaToClass(center, rmClassID("center"));
   rmSetAreaSize(center, .1, .1);
   rmSetAreaLocation(center, 0.5, 0.5);
   rmSetAreaCoherence(center, 1.0);
   rmBuildArea(center);    

   //leftcliff
   int leftCliff = rmCreateArea("leftCliff");
   rmSetAreaSize(leftCliff, 0.1, 0.1); 
   //rmAddAreaToClass(leftCliff, rmClassID("classPlateau"));
   rmSetAreaTerrainType(leftCliff, "Deccan\ground_grass4_deccan");
   rmSetAreaMix(leftCliff, "deccan_grass_a");
   rmSetAreaCliffType(leftCliff, "Deccan Plateau");
   rmSetAreaCliffEdge(leftCliff, 1, 1.0, 0.0, 0.0, 2); //4,.225 looks cool too
   rmSetAreaCliffPainting(leftCliff, true, true, true, 1.5, true);
   rmSetAreaCliffHeight(leftCliff, -4, 0.1, 0.5);
   //rmAddAreaConstraint(leftCliff, avoidCenter);
   rmSetAreaCoherence(leftCliff, 0.95);
   rmSetAreaLocation(leftCliff, .2, .5);	
   rmAddAreaInfluenceSegment(leftCliff, 0.08, 0.72, .2, 0.6); 		
   rmAddAreaInfluenceSegment(leftCliff, 0.2, 0.6, .2, .4); 		
   rmAddAreaInfluenceSegment(leftCliff, 0.2, 0.4, .08, .28); 		
   rmBuildArea(leftCliff);

   //rightCliff
   int rightCliff = rmCreateArea("rightCliff");
   rmSetAreaSize(rightCliff, 0.1, 0.1); 
   //rmAddAreaToClass(rightCliff, rmClassID("classPlateau"));
   rmSetAreaTerrainType(rightCliff, "Deccan\ground_grass4_deccan");
   rmSetAreaMix(rightCliff, "deccan_grass_a");
   rmSetAreaCliffType(rightCliff, "Deccan Plateau");
   rmSetAreaCliffEdge(rightCliff, 1, 1.0, 0.0, 0.0, 2); //4,.225 looks cool too
   rmSetAreaCliffPainting(rightCliff, true, true, true, 1.5, true);
   rmSetAreaCliffHeight(rightCliff, -4, 0.1, 0.5);
   //rmAddAreaConstraint(rightCliff, avoidCenter);
   rmSetAreaCoherence(rightCliff, 0.95);
   rmSetAreaLocation(rightCliff, .8, .5);	
   rmAddAreaInfluenceSegment(rightCliff, 0.92, 0.28, .8, 0.4); 		
   rmAddAreaInfluenceSegment(rightCliff, 0.8, 0.4, .8, .6); 		
   rmAddAreaInfluenceSegment(rightCliff, 0.8, 0.6, .92, .72); 		
   rmBuildArea(rightCliff);
   rmSetStatusText("",0.3);

   int rampNumbers = 8;

   //creates ramps for our left and right sections
   for(i=i; < rampNumbers) { 
      int rampLarge = rmCreateArea("top left center basin left ramp"+i);
      rmAddAreaTerrainReplacement(rampLarge, "deccan\wall_deccan", "deccan\ground_grass2_deccan");
      rmPaintAreaTerrain(rampLarge);
      rmSetAreaSize(rampLarge, 0.0044, 0.0044);
      rmSetAreaBaseHeight(rampLarge, 7.6);
      //rmSetAreaSmoothDistance(rampLarge, 1);	
      //rmSetAreaSmoothDistance(rampLarge, 4);
      rmSetAreaHeightBlend(rampLarge, 2);
      rmSetAreaCoherence(rampLarge, 1);
      if(i == 1){
         rmSetAreaLocation(rampLarge, 0.725, 0.5);
      }else if(i == 2){
         rmSetAreaLocation(rampLarge, 0.275, 0.5);
      }else if(i == 3){
         rmSetAreaLocation(rampLarge, 0.875, 0.5);
      }else if(i == 4){
         rmSetAreaLocation(rampLarge, 0.125, 0.5);
      }else if(i == 5){
         rmSetAreaLocation(rampLarge, 0.8, 0.3);
      }else if(i == 6){
         rmSetAreaLocation(rampLarge, 0.2, 0.7);
      }else if(i == 7){
         rmSetAreaLocation(rampLarge, 0.8, 0.7);
      }else{
         rmSetAreaLocation(rampLarge, 0.2, 0.3);
      }
      rmBuildArea(rampLarge); 
   }
   
   rmSetStatusText("",0.4);

   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 6.0);      

   int tradeRouteID = rmCreateTradeRoute();
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
   rmAddTradeRouteWaypoint(tradeRouteID, .8, .86);
   rmAddTradeRouteWaypoint(tradeRouteID, .5, .95);
   rmAddTradeRouteWaypoint(tradeRouteID, .2, .86);

   rmBuildTradeRoute(tradeRouteID, "water");

   vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
   socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		
   //TR 2
   int socketID2=rmCreateObjectDef("sockets to dock Trade Posts2");
   rmAddObjectDefItem(socketID2, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID2, true);
   rmSetObjectDefMinDistance(socketID2, 0.0);
   rmSetObjectDefMaxDistance(socketID2, 6.0);      

   int tradeRouteID2 = rmCreateTradeRoute();
   rmSetObjectDefTradeRouteID(socketID2, tradeRouteID2);
   rmAddTradeRouteWaypoint(tradeRouteID2, .2, .14);
   rmAddTradeRouteWaypoint(tradeRouteID2, .5, .05);
   rmAddTradeRouteWaypoint(tradeRouteID2, .8, .14);

   rmBuildTradeRoute(tradeRouteID2, "water");

   vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.8);
   rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
   socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.2);
   rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
      
   //end tr 2
   rmSetStatusText("",0.5);

   //centerCliff
   int centerCliff = rmCreateArea("centerCliff");
   rmSetAreaSize(centerCliff, 0.015, 0.015); 
   //rmAddAreaToClass(centerCliff, rmClassID("classPlateau"));
   rmSetAreaMix(centerCliff, "deccan_grass_a");
   rmSetAreaTerrainType(centerCliff, "Deccan\ground_grass4_deccan");
   rmSetAreaCliffType(centerCliff, "Deccan Plateau");
   rmSetAreaCliffEdge(centerCliff, 4, .2, 0.0, 0.0, 2); //4,.225 looks cool too
   rmSetAreaCliffPainting(centerCliff, true, true, true, 1.5, true);
   rmSetAreaCliffHeight(centerCliff, 4, 0.1, 0.5);
   rmSetAreaCoherence(centerCliff, 0.95);
   rmSetAreaLocation(centerCliff, .5, .5);		
   rmBuildArea(centerCliff);
   rmSetStatusText("",0.55);

	//Natives
	int nativeSwitch = rmRandInt(0,1);
	
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Sufi");
	subCiv1 = rmGetCivID("Saltpeter");
	rmSetSubCiv(0, "Sufi");
	rmSetSubCiv(1, "Saltpeter");
	
	int nativeID0 = -1;
    int nativeID2 = -1;
				
	nativeID0 = rmCreateGrouping("Sufi village", "native sufi mosque deccan "+4);
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 1.00);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	
	nativeID2 = rmCreateGrouping("Saltpeter village", "saltpeter_0"+2);
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 1.00);
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));

	if(nativeSwitch == 0){
	rmPlaceGroupingAtLoc(nativeID0, 0, .5, .75);
	rmPlaceGroupingAtLoc(nativeID2, 0, .5, .25);
	}else{
	rmPlaceGroupingAtLoc(nativeID2, 0, .5, .25);
	rmPlaceGroupingAtLoc(nativeID0, 0, .5, .75);
	}
   
   //starting objects

   int playerStart = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(playerStart, 7.0);
   rmSetObjectDefMaxDistance(playerStart, 12.0);

   int goldID = rmCreateObjectDef("starting gold");
   rmAddObjectDefItem(goldID, "mine", 1, 4.0);
   rmSetObjectDefMinDistance(goldID, 10.0);
   rmSetObjectDefMaxDistance(goldID, 12.0);

   int goldID2 = rmCreateObjectDef("starting gold 2");
   rmAddObjectDefItem(goldID2, "mine", 1, 16.0);
   rmSetObjectDefMinDistance(goldID2, 12.0);
   rmSetObjectDefMaxDistance(goldID2, 14.0);
   rmAddObjectDefConstraint(goldID2, avoidCoin);

   int berryID = rmCreateObjectDef("starting berries");
   rmAddObjectDefItem(berryID, "BerryBush", 2, 6.0);
   rmSetObjectDefMinDistance(berryID, 10.0);
   rmSetObjectDefMaxDistance(berryID, 12.0);
   rmAddObjectDefConstraint(berryID, avoidCoin);

   int treeID = rmCreateObjectDef("starting trees");
   rmAddObjectDefItem(treeID, "ypTreeSaxaul", rmRandInt(8,9), 10.0);
   rmSetObjectDefMinDistance(treeID, 10.0);
   rmSetObjectDefMaxDistance(treeID, 14.0);
   rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
   rmAddObjectDefConstraint(treeID, avoidCoin);
 
   int foodID = rmCreateObjectDef("starting hunt");
   rmAddObjectDefItem(foodID, "Heron", 6, 8.0);
   rmSetObjectDefMinDistance(foodID, 10.0);
   rmSetObjectDefMaxDistance(foodID, 12.0);
   rmAddObjectDefConstraint(foodID, avoidPlateau);
   rmSetObjectDefCreateHerd(foodID, false);

   int foodID2 = rmCreateObjectDef("starting hunt 2");
   rmAddObjectDefItem(foodID2, "Heron", 7, 8.0);
   rmSetObjectDefMinDistance(foodID2, 35.0);
   rmSetObjectDefMaxDistance(foodID2, 40.0);
   rmAddObjectDefConstraint(foodID2, avoidPlateau);
   rmSetObjectDefCreateHerd(foodID2, true);
                 
   int foodID3 = rmCreateObjectDef("starting hunt 3");
   rmAddObjectDefItem(foodID3, "Heron", 8, 8.0);
   rmSetObjectDefMinDistance(foodID3, 55.0);
   rmSetObjectDefMaxDistance(foodID3, 65.0);	
   rmAddObjectDefConstraint(foodID3, avoidPlateau);
   rmAddObjectDefConstraint(foodID3, forestConstraintShort);
   rmSetObjectDefCreateHerd(foodID3, true);

 	int startnuggetID= rmCreateObjectDef("starting nugget"); 
	rmAddObjectDefItem(startnuggetID, "Nugget", 1, 0.0); 
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(startnuggetID, 10.0);
	rmSetObjectDefMaxDistance(startnuggetID, 15.0);
	rmAddObjectDefConstraint(startnuggetID, avoidNugget); 
	rmAddObjectDefConstraint(startnuggetID, circleConstraint);
	rmAddObjectDefConstraint(startnuggetID, avoidAll);
               
    for(i=1; < cNumberNonGaiaPlayers + 1) {
		int id=rmCreateArea("Player"+i);
		rmSetPlayerArea(i, id);
		int startID = rmCreateObjectDef("object"+i);
		if(rmGetNomadStart()){
			rmAddObjectDefItem(startID, "CoveredWagon", 1, 5.0);
		}else{
			rmAddObjectDefItem(startID, "TownCenter", 1, 5.0);
		}		
      		rmSetObjectDefMinDistance(startID, 0.0);
      		rmSetObjectDefMaxDistance(startID, 8.0);

      		rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      		rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      		rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      		rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      		rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      		//rmPlaceObjectDefAtLoc(goldID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      		rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      		rmPlaceObjectDefAtLoc(foodID3, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      		rmPlaceObjectDefAtLoc(startnuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      		rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}
			rmSetStatusText("",0.6);

	/*
	==================
	resource placement
	==================
	*/
	
   int pronghornHunts = rmCreateObjectDef("pronghornHunts");
	rmAddObjectDefItem(pronghornHunts, "Gazelle", rmRandInt(7,8), 14.0);
	rmSetObjectDefCreateHerd(pronghornHunts, true);
	rmSetObjectDefMinDistance(pronghornHunts, 0);
	rmSetObjectDefMaxDistance(pronghornHunts, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(pronghornHunts, circleConstraint);
	rmAddObjectDefConstraint(pronghornHunts, avoidTownCenterMore);
	rmAddObjectDefConstraint(pronghornHunts, avoidHunt);
	rmAddObjectDefConstraint(pronghornHunts, avoidPlateau);	
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);

  	int islandminesID = rmCreateObjectDef("island silver");
	rmAddObjectDefItem(islandminesID, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(islandminesID, 0.0);
	rmSetObjectDefMaxDistance(islandminesID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(islandminesID, avoidCoinMed);
	rmAddObjectDefConstraint(islandminesID, avoidTownCenterMore);
	rmAddObjectDefConstraint(islandminesID, avoidSocket);
	rmAddObjectDefConstraint(islandminesID, avoidPlateau);	
	rmAddObjectDefConstraint(islandminesID, avoidWaterShort);
	rmAddObjectDefConstraint(islandminesID, forestConstraintShort);
	rmAddObjectDefConstraint(islandminesID, circleConstraint);
	rmPlaceObjectDefAtLoc(islandminesID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
  
 	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
	rmAddObjectDefConstraint(nuggetID, forestConstraintShort);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(nuggetID, avoidSocket); 
	rmAddObjectDefConstraint(nuggetID, avoidPlateau);	
	rmAddObjectDefConstraint(nuggetID, avoidAll);
	rmSetNuggetDifficulty(2, 3); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);  
 
   rmSetStatusText("",0.7);

   int mapTrees=rmCreateObjectDef("map trees");
   rmAddObjectDefItem(mapTrees, "ypTreeSaxaul", rmRandInt(12,15), rmRandFloat(11.0,14.0));
   rmAddObjectDefToClass(mapTrees, rmClassID("classForest")); 
   rmSetObjectDefMinDistance(mapTrees, 0);
   rmSetObjectDefMaxDistance(mapTrees, rmXFractionToMeters(0.45));
   rmAddObjectDefConstraint(mapTrees, avoidTradeRouteSmall);
   rmAddObjectDefConstraint(mapTrees, avoidSocket);
   rmAddObjectDefConstraint(mapTrees, circleConstraint);
   rmAddObjectDefConstraint(mapTrees, forestConstraint);
   rmAddObjectDefConstraint(mapTrees, avoidTownCenter);	
   rmAddObjectDefConstraint(mapTrees, avoidPlateau);	
   rmAddObjectDefConstraint(mapTrees, avoidWaterShort);	
   rmPlaceObjectDefAtLoc(mapTrees, 0, 0.5, 0.5, 30*cNumberNonGaiaPlayers);
   rmSetStatusText("",0.8); 
	
	int herdableCow = rmCreateObjectDef("herdableCow");
	rmAddObjectDefItem(herdableCow, "sheep", rmRandInt(1,1), 4.0);
	rmSetObjectDefMinDistance(herdableCow, 0);
	rmSetObjectDefMaxDistance(herdableCow, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(herdableCow, circleConstraint);
	rmAddObjectDefConstraint(herdableCow, avoidTownCenterMore);
	rmAddObjectDefConstraint(herdableCow, avoidHerd);
	rmAddObjectDefConstraint(herdableCow, avoidPlateau);	
	rmAddObjectDefConstraint(herdableCow, avoidWaterShort);	
	rmPlaceObjectDefAtLoc(herdableCow, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);
   
   rmSetStatusText("",0.9);

   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .04, 0);
   }
   		rmSetStatusText("", 1.0);

}