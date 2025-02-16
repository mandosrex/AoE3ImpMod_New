/* Durokan's Mt. Fuji - February 16 2020 Version 1.4*/

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";
 
void main(void) {
 
   // Picks the map size
	int playerTiles=11000;
	if (cNumberNonGaiaPlayers > 4){
		playerTiles = 10000;
	}else if (cNumberNonGaiaPlayers > 6){
		playerTiles = 8500;
	}
	
	int size = 2.0 * sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmSetMapSize(size, size);

   rmSetSeaLevel(10.0);

   rmSetBaseTerrainMix("araucania_grass_b");
   rmTerrainInitialize("araucania\ground_dirt4_ara", 3.0);
   rmSetMapType("land");
   rmSetMapType("desert");
   rmSetMapType("middleEast");
   rmSetMapType("AIFishingUseful");
   rmTerrainInitialize("grass");
   rmSetLightingSet("Honshu");

   rmSetWorldCircleConstraint(true);

   rmDefineClass("classForest");
   rmDefineClass("classPlateau");

   rmSetStatusText("",0.01);
		
   //Constraints
   int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 8.0);

	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 5.0);

   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.49), rmDegreesToRadians(0), rmDegreesToRadians(360));

   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
   int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);

   int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 50.0);
   int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 10.0);

   int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 50.0);

   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
   int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 50.0);
   //int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 60.0);
   int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 5.0);
   int avoidWater = rmCreateTerrainDistanceConstraint("avoid water 2", "Land", false, 15.0);
   int hugWater = rmCreateTerrainMaxDistanceConstraint("hug water 2", "water", true, 10.0);

   int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 8.0);
   int avoidSocketClass=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 25.0);
   int avoidSocket=rmCreateTypeDistanceConstraint("avoid socket", "socket", 25.0);
   int socketAvoidSocket=rmCreateTypeDistanceConstraint("socket avoid socket", "socketTradeRoute", 45.0);

   int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 35.0);
   int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
   int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 40.0);  

   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 60.0);
       
   int goldBuffer=rmCreateTypeDistanceConstraint("avoids mines by tiny", "Mine", 3.0);
   int nuggetbuffer=rmCreateTypeDistanceConstraint("avoids nuggets by tiny", "AbstractNugget", 3.0);
   int huntBuffer=rmCreateTypeDistanceConstraint("avoids hunts by tiny", "huntable", 3.0);
   int herdBuffer=rmCreateTypeDistanceConstraint("avoids herds by tiny", "herdable", 3.0);
   
   // Player placing  
   float spawnSwitch = rmRandFloat(0,1.2);
   float extraSpawnLen = 0.0;
   if(cNumberNonGaiaPlayers >6){
      extraSpawnLen = .05;
   }
   
   if(cNumberNonGaiaPlayers == 2){
      if (spawnSwitch<0.6) {	
         rmPlacePlayer(1, 0.45, 0.80);
         rmPlacePlayer(2, 0.80, 0.45);
      }else{
         rmPlacePlayer(2, 0.45, 0.80);
         rmPlacePlayer(1, 0.80, 0.45);
      }
   }else{
      if (cNumberTeams == 2){
         if (spawnSwitch <=0.6){
            rmSetPlacementTeam(0);
            rmPlacePlayersLine(0.75-extraSpawnLen, 0.35, 0.85+extraSpawnLen, 0.60, 0, 0);
            rmSetPlacementTeam(1);
            rmPlacePlayersLine(0.35, 0.75-extraSpawnLen, 0.60, 0.85+extraSpawnLen, 0, 0);
         }else if(spawnSwitch <=1.2){
            rmSetPlacementTeam(1);
            rmPlacePlayersLine(0.75-extraSpawnLen, 0.35, 0.85+extraSpawnLen, 0.60, 0, 0);
            rmSetPlacementTeam(0);
            rmPlacePlayersLine(0.35, 0.75-extraSpawnLen, 0.60, 0.85+extraSpawnLen, 0, 0);
         }
      }else{
         rmSetPlacementSection(.25, .98);
         rmPlacePlayersCircular(0.3, 0.3, 0.02);
      }
   }
   chooseMercs();

   int continent2 = rmCreateArea("continent");
   rmSetAreaSize(continent2, 1.0, 1.0);
   rmSetAreaLocation(continent2, 0.5, 0.5);
   rmSetAreaTerrainType(continent2, "araucania\ground_dirt4_ara");
   rmSetAreaMix(continent2, "araucania_grass_b");
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

   rmSetStatusText("",0.2);

   int straightLake=rmCreateArea("straightLake");
   rmSetAreaLocation(straightLake, 0.2, 0.2);
   rmAddAreaInfluenceSegment(straightLake, 0.0, 0.35, 0.35, 0.0);
   rmSetAreaSize(straightLake, 0.3, 0.3);      
   rmSetAreaWaterType(straightLake, "South Africa Coast");
   rmSetAreaBaseHeight(straightLake, 10.0);
   rmSetAreaCoherence(straightLake, .80);
   rmSetAreaObeyWorldCircleConstraint(straightLake, false);
   rmBuildArea(straightLake);

   rmSetStatusText("",0.3);

      
   int tradeRouteID = rmCreateTradeRoute();
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmSetObjectDefMinDistance(socketID, 10.0);
   rmSetObjectDefMaxDistance(socketID, 60.0);
   rmAddObjectDefConstraint(socketID, avoidWaterShort);
   rmAddObjectDefConstraint(socketID, hugWater);
   rmAddObjectDefConstraint(socketID, avoidAll);
   rmAddObjectDefConstraint(socketID, socketAvoidSocket);
   
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

      rmAddTradeRouteWaypoint(tradeRouteID, 0.00, 0.59); 
      rmAddTradeRouteWaypoint(tradeRouteID, 0.20, 0.50);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.30, 0.40);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.11, 0.19);
      
   rmBuildTradeRoute(tradeRouteID, "naval");
   
   vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, -1);//this just defines socketLoc1, doesn't use this value

   if(cNumberNonGaiaPlayers < 4){
      socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.10);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
      socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.30);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
   }else{
      socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.05);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
      socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.20);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
      socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.40);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
   }
   
   //tr2 (right side)
   
   int tradeRouteID2 = rmCreateTradeRoute();
   int socketID2=rmCreateObjectDef("sockets to dock Trade Posts2");
   rmAddObjectDefItem(socketID2, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID2, true);
   rmSetObjectDefMinDistance(socketID2, 10.0);
   rmSetObjectDefMaxDistance(socketID2, 60.0);
   rmAddObjectDefConstraint(socketID2, avoidWaterShort);
   rmAddObjectDefConstraint(socketID2, hugWater);
   rmAddObjectDefConstraint(socketID2, avoidAll);
   rmAddObjectDefConstraint(socketID2, socketAvoidSocket);

   rmSetObjectDefTradeRouteID(socketID2, tradeRouteID2);

      rmAddTradeRouteWaypoint(tradeRouteID2, 0.59, 0.00); 
      rmAddTradeRouteWaypoint(tradeRouteID2, 0.50, 0.20);
      rmAddTradeRouteWaypoint(tradeRouteID2, 0.40, 0.30);
      rmAddTradeRouteWaypoint(tradeRouteID2, 0.19, 0.11); 

   rmBuildTradeRoute(tradeRouteID2, "naval");

   
   vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, -1);//this just defines socketLoc2, doesn't use this value

   if(cNumberNonGaiaPlayers < 4){
      socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.10);
      rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
      socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.30);
      rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
   }else{
      socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.05);
      rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
      socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.20);
      rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
      socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.40);
      rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
   }
   
   rmSetStatusText("",0.4);
      
   //Natives
		
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Jesuit");
	subCiv1 = rmGetCivID("Jesuit");
	rmSetSubCiv(0, "Jesuit");
	rmSetSubCiv(1, "Jesuit");
	
   int nativeID0 = -1;
   int nativeID1 = -1;

   nativeID0 = rmCreateGrouping("Jesuit temple", "native jesuit mission america 0"+4);
   rmSetGroupingMinDistance(nativeID0, 0.00);
   rmSetGroupingMaxDistance(nativeID0, 0.00);
   rmAddGroupingToClass(nativeID0, rmClassID("natives"));
   rmPlaceGroupingAtLoc(nativeID0, 0, 0.7, 0.7);

   nativeID1 = rmCreateGrouping("Jesuit temple ", "native jesuit mission america 0"+5);
   rmSetGroupingMinDistance(nativeID1, 0.00);
   rmSetGroupingMaxDistance(nativeID1, 0.00);
   rmAddGroupingToClass(nativeID1, rmClassID("natives"));
   rmPlaceGroupingAtLoc(nativeID1, 0, 0.6, 0.6); 
	
   rmSetStatusText("",0.5);
   //starting objects

   int playerStart = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(playerStart, 7.0);
   rmSetObjectDefMaxDistance(playerStart, 12.0);

   int goldID = rmCreateObjectDef("starting gold");
   rmAddObjectDefItem(goldID, "mine", 1, 6.0);
   rmSetObjectDefMinDistance(goldID, 12.0);
   rmSetObjectDefMaxDistance(goldID, 14.0);

   int goldID2 = rmCreateObjectDef("starting gold 2");
   rmAddObjectDefItem(goldID2, "mine", 1, 16.0);
   rmSetObjectDefMinDistance(goldID2, 20.0);
   rmSetObjectDefMaxDistance(goldID2, 22.0);
   rmAddObjectDefConstraint(goldID2, avoidCoin);

   int berryID = rmCreateObjectDef("starting berries");
   rmAddObjectDefItem(berryID, "BerryBush", 5, 6.0);
   rmSetObjectDefMinDistance(berryID, 10.0);
   rmSetObjectDefMaxDistance(berryID, 12.0);
   rmAddObjectDefConstraint(berryID, avoidCoin);

   int treeID = rmCreateObjectDef("starting trees");
   rmAddObjectDefItem(treeID, "TreeTexas", rmRandInt(6,9), 10.0);
   rmSetObjectDefMinDistance(treeID, 12.0);
   rmSetObjectDefMaxDistance(treeID, 18.0);
   rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
   rmAddObjectDefConstraint(treeID, avoidCoin);

   int foodID = rmCreateObjectDef("starting hunt");
   rmAddObjectDefItem(foodID, "Okapi", 6, 8.0);
   rmSetObjectDefMinDistance(foodID, 10.0);
   rmSetObjectDefMaxDistance(foodID, 12.0);
   rmSetObjectDefCreateHerd(foodID, false);

   int foodID2 = rmCreateObjectDef("starting hunt 2");
   rmAddObjectDefItem(foodID2, "Okapi", 7, 8.0);
   rmSetObjectDefMinDistance(foodID2, 38.0);
   rmSetObjectDefMaxDistance(foodID2, 40.0);
   rmSetObjectDefCreateHerd(foodID2, true);

 	int nuggetstartID= rmCreateObjectDef("starting nugget"); 
	rmAddObjectDefItem(nuggetstartID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetstartID, 15.0); 
	rmSetObjectDefMaxDistance(nuggetstartID, 30.0); 
	rmAddObjectDefConstraint(nuggetstartID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetstartID, circleConstraint);
	rmAddObjectDefConstraint(nuggetstartID, avoidTownCenterSmall);
	rmAddObjectDefConstraint(nuggetstartID, avoidWaterShort);
	rmAddObjectDefConstraint(nuggetstartID, avoidAll);	 
	rmSetNuggetDifficulty(1, 1);
      
   int flagLand = rmCreateTerrainDistanceConstraint("flag land", "land", true, 9.0);

   float locSwitcher = 0.0;
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
      rmSetObjectDefMaxDistance(startID, 7.0);

      rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(nuggetstartID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      //rmPlaceObjectDefAtLoc(goldID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      
		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

      int waterFlag = rmCreateObjectDef("HC water flag "+i);
      rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 0.0);
      rmSetObjectDefMinDistance(waterFlag, 0);
      rmSetObjectDefMaxDistance(waterFlag, 20);
      /*if(cNumberNonGaiaPlayers > 5){
         rmSetObjectDefMaxDistance(waterFlag, 55);
      }else{
         rmSetObjectDefMaxDistance(waterFlag, 85);
      }*/
      //avoidshore
      //circleconstraint
      rmAddObjectDefConstraint(waterFlag, circleConstraint);
      rmAddObjectDefConstraint(waterFlag, flagLand);

   rmSetStatusText("",0.7);

      locSwitcher = rmPlayerLocXFraction(i);
      if(locSwitcher > rmPlayerLocZFraction(i)){
         rmPlaceObjectDefAtLoc(waterFlag, i, .4, .2, 1);
         locSwitcher = rmPlayerLocZFraction(i);
      }else{
         rmPlaceObjectDefAtLoc(waterFlag, i, .2, .4, 1);

      }
      /*locSwitcher = locSwitcher - .05;*/
      //rmPlaceObjectDefAtLoc(waterFlag, i, rmPlayerLocXFraction(i)-locSwitcher, rmPlayerLocZFraction(i)-locSwitcher, 1);
	}
	
	/*
	==================
	resource placement
	==================
	*/
	
	int bigBerryPatches = rmCreateObjectDef("bigBerryPatches");
	rmAddObjectDefItem(bigBerryPatches, "BerryBush", 8, 12.0);
	rmSetObjectDefMinDistance(bigBerryPatches, 0.0);
	rmSetObjectDefMaxDistance(bigBerryPatches, 10.0);
	rmPlaceObjectDefAtLoc(bigBerryPatches, 0, 0.75, 0.75, 1);
	rmPlaceObjectDefAtLoc(bigBerryPatches, 0, 0.45, 0.45, 1);

   int pronghornHunts = rmCreateObjectDef("pronghornHunts");
	rmAddObjectDefItem(pronghornHunts, "Zebra", rmRandInt(7,8), 14.0);
	rmSetObjectDefCreateHerd(pronghornHunts, true);
	rmSetObjectDefMinDistance(pronghornHunts, 0);
	rmSetObjectDefMaxDistance(pronghornHunts, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(pronghornHunts, circleConstraint);
	rmAddObjectDefConstraint(pronghornHunts, avoidTownCenterMore);
	rmAddObjectDefConstraint(pronghornHunts, avoidHunt);
	rmAddObjectDefConstraint(pronghornHunts, avoidWaterShort);	
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);

  	int mainMines = rmCreateObjectDef("mainland Mines");
	rmAddObjectDefItem(mainMines, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(mainMines, 0.0);
	rmSetObjectDefMaxDistance(mainMines, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(mainMines, avoidCoinMed);
	rmAddObjectDefConstraint(mainMines, avoidTownCenterMore);
	rmAddObjectDefConstraint(mainMines, avoidSocket);	
	rmAddObjectDefConstraint(mainMines, avoidWater);
	rmAddObjectDefConstraint(mainMines, forestConstraintShort);
	rmAddObjectDefConstraint(mainMines, circleConstraint);
	rmAddObjectDefConstraint(mainMines, nuggetbuffer);
	rmAddObjectDefConstraint(mainMines, huntBuffer);
	rmAddObjectDefConstraint(mainMines, herdBuffer);
	rmPlaceObjectDefAtLoc(mainMines, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
 
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
	rmAddObjectDefConstraint(nuggetID, avoidWater);
	rmAddObjectDefConstraint(nuggetID, goldBuffer);	
	rmAddObjectDefConstraint(nuggetID, huntBuffer);	
	rmAddObjectDefConstraint(nuggetID, herdBuffer);	   
	rmSetNuggetDifficulty(1, 2); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);   

   rmSetStatusText("",0.8);
	
   int mapTrees=rmCreateObjectDef("map trees");
   rmAddObjectDefItem(mapTrees, "TreeTexas", rmRandInt(11,13), rmRandFloat(10.0,14.0));
   rmAddObjectDefItem(mapTrees, "UnderbrushDeccan", rmRandInt(2,4), 8.0);
   rmAddObjectDefToClass(mapTrees, rmClassID("classForest")); 
   rmSetObjectDefMinDistance(mapTrees, 0);
   rmSetObjectDefMaxDistance(mapTrees, rmXFractionToMeters(0.45));
   rmAddObjectDefConstraint(mapTrees, avoidTradeRouteSmall);
   rmAddObjectDefConstraint(mapTrees, avoidSocket);
   rmAddObjectDefConstraint(mapTrees, circleConstraint);
   rmAddObjectDefConstraint(mapTrees, forestConstraint);
   rmAddObjectDefConstraint(mapTrees, avoidTownCenter);	
   rmAddObjectDefConstraint(mapTrees, avoidWater);	
   rmAddObjectDefConstraint(mapTrees, goldBuffer);	
   rmAddObjectDefConstraint(mapTrees, nuggetbuffer);	
   rmAddObjectDefConstraint(mapTrees, huntBuffer);	
   rmAddObjectDefConstraint(mapTrees, herdBuffer);	
   rmPlaceObjectDefAtLoc(mapTrees, 0, 0.5, 0.5, 30*cNumberNonGaiaPlayers);

   rmSetStatusText("",0.9);
		
   //fish and their constraints placed together at the end for ease of removal
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "ypFishCatfish", 20.0);
   int fishVsFishID2=rmCreateTypeDistanceConstraint("fish v fish", "ypSquid", 20.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);
   int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "HumpbackWhale", 50.0);
   int whaleLand = rmCreateTerrainDistanceConstraint("whale land", "land", true, 15.0);

   int fishID=rmCreateObjectDef("fish Mahi");
   rmAddObjectDefItem(fishID, "ypFishCatfish", 2, 0.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);

   int fish2ID=rmCreateObjectDef("fish Tarpon");
   rmAddObjectDefItem(fish2ID, "ypFishCarp", 2, 0.0);
   rmSetObjectDefMinDistance(fish2ID, 0.0);
   rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fish2ID, fishVsFishID2);
   rmAddObjectDefConstraint(fish2ID, fishLand);
   rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);

   int whaleID=rmCreateObjectDef("whale");
   rmAddObjectDefItem(whaleID, "HumpbackWhale", 1, 0.0);
   rmSetObjectDefMinDistance(whaleID, 0.0);
   rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
   rmAddObjectDefConstraint(whaleID, whaleLand);
   rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);


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

   
   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.75, .75, .05, 0);
   }
   

   rmSetStatusText("",0.99);

}
 
