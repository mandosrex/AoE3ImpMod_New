/* Durokan's  Jebel Musa - February 16 2020 Version 1.4.0*/

	include "mercenaries.xs";
	include "ypAsianInclude.xs";
	include "ypKOTHInclude.xs";

	void main(void) { 
		float playerTiles = 11000;
		int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
		rmSetMapSize(size, size);
		rmSetSeaType("hudson bay");
		rmSetSeaLevel(-2.5);
		rmSetMapType("land");
		rmSetMapType("water");
		rmSetMapType("grass");
		rmSetMapType("japan");
		rmSetMapType("asia");
		rmSetMapType("AIFishingUseful");
		rmTerrainInitialize("water"); 
		rmSetLightingSet("carolina");

		rmSetWorldCircleConstraint(false);
		
		rmDefineClass("classForest");
		rmSetStatusText("",0.01);
		
		int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
		int circleConstraintShorter=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.3), rmDegreesToRadians(0), rmDegreesToRadians(360));

		int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
		//int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);	
		int forestConstraintShort=rmCreateTypeDistanceConstraint("object vs. forest", "ypTreeCoastalJapan", 6.0);	

      int plateuaGoldAvoidTrees=rmCreateTypeDistanceConstraint("object vs. forest", "ypTreeCoastalJapan", 12.0);	
      int avoidWaterFlags=rmCreateTypeDistanceConstraint("flag avoid flag", "HomeCityWaterSpawnFlag", 25.0);
		int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 40.0);
		int avoidHuntBase=rmCreateTypeDistanceConstraint("stuff avoid hunts", "huntable", 4.0);
		int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
		int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 60.0);
		int avoidCoinMedPlateau=rmCreateTypeDistanceConstraint("avoid coin medium plateau", "Mine", 50.0);
		int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 6.0);
		int avoidWaterLong = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 20.0);
		int AvoidWaterShort2 = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 15.0);
		int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("objects avoid trade route", 12);
		int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("objects avoid trade route far", 30);
		int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 4.0);
		int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 5.0);
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 35.0);
		int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
		int avoidTownCenterMedium=rmCreateTypeDistanceConstraint("avoid Town Center medium", "townCenter", 21.0);
		int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 40.0);	
		int avoidTownCenterPlateauTrees=rmCreateTypeDistanceConstraint("avoid TC by 35", "townCenter", 35.0);	
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0); 
		
		int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fishTarpon", 20.0);
		int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);
		int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "HumpbackWhale", 40.0);
		int whaleLand = rmCreateTerrainDistanceConstraint("whale land", "land", true, 7.0);

		rmDefineClass("classPlateau");
		int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 4.0);
		rmDefineClass("classAnvil");
		int avoidAnvil=rmCreateClassDistanceConstraint("stuff vs. Anvil", rmClassID("classAnvil"), 5.0);
		rmDefineClass("classContinent");
		int avoidContinent=rmCreateClassDistanceConstraint("stuff vs. Continent", rmClassID("classContinent"), 5.0);
		
		int avoidAnvilFlag=rmCreateClassDistanceConstraint("stuff vs. Anvil", rmClassID("classAnvil"), 15.0);
		int avoidContinentFlag=rmCreateClassDistanceConstraint("flag vs. Continent", rmClassID("classContinent"), 15.0);

		int shoreTreesStayWater = rmCreateTerrainMaxDistanceConstraint("shore trees stays near the water", "Land", false, 10.0);
		int shoreTreesAvoidWater = rmCreateTerrainDistanceConstraint("shore trees avoid the water", "Land", false, 3.0);
		int shoreTreesAvoidPlateau=rmCreateClassDistanceConstraint("shore trees avoid plateaus", rmClassID("classPlateau"), 1.0);
		int shoreTreesAvoidCoin=rmCreateTypeDistanceConstraint("shore trees avoid coin", "Mine", 4.0);
		int shoreTreesAvoidNuggets=rmCreateTypeDistanceConstraint("shore trees avoid nuggets", "AbstractNugget", 4.0);
		int leftShoreTrees=rmCreateObjectDef("the left half of the shore trees");
		
      int treeCircleConstraint=rmCreatePieConstraint("tree rings Constraint", 0.5, 0.5, rmZFractionToMeters(0.48), rmZFractionToMeters(0.5), rmDegreesToRadians(102), rmDegreesToRadians(165));
		int circleTreesAvoidCoin=rmCreateTypeDistanceConstraint("circle trees avoid coin", "Mine", 4.0);
		int treeCircleConstraint2=rmCreatePieConstraint("tree rings Constraint2", 0.5, 0.5, rmZFractionToMeters(0.485), rmZFractionToMeters(0.5), rmDegreesToRadians(196), rmDegreesToRadians(270));
		int avoidGrass=rmCreateClassDistanceConstraint("tree vs. grasses", rmClassID("patch"), 1.0);

		float spawnSwitch = rmRandFloat(0,1.2);
	
		if(cNumberNonGaiaPlayers == 2){
			if (spawnSwitch<0.6) {	
			rmPlacePlayer(1, 0.2, 0.25);
			rmPlacePlayer(2, 0.8, 0.25);
			}else{
			rmPlacePlayer(1, 0.8, 0.25);
			rmPlacePlayer(2, 0.2, 0.25);
			}
		}else if (cNumberTeams == 2){
			if (spawnSwitch<0.6) {	
				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.2, 0.21, 0.2, 0.47, 0, 0);
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.8, 0.21, 0.8, 0.47, 0, 0);
			}else{
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.2, 0.21, 0.2, 0.47, 0, 0);
				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.8, 0.21, 0.8, 0.47, 0, 0);
			}

		}else{
			rmSetPlacementSection(0.22, 0.78);
			rmPlacePlayersCircular(0.4, 0.4, 0.02);
		}
		chooseMercs();
		rmSetStatusText("",0.1);
		
		int continent = rmCreateArea("big huge continent");
		rmAddAreaToClass(continent, rmClassID("classContinent"));
		rmSetAreaSize(continent, 0.64, 0.64);
		rmSetAreaLocation(continent, 0.5, 0.15);
		rmSetAreaMix(continent, "saguenay grass");
		rmSetAreaBaseHeight(continent, 0);
		rmSetAreaCoherence(continent, .7);
		rmAddAreaInfluenceSegment(continent, 0.0, 0.25, 1.0, 0.25); 
		rmSetAreaSmoothDistance(continent, 1);
		rmSetAreaElevationEdgeFalloffDist(continent, 10);
		rmSetAreaElevationVariation(continent, 5);
		rmSetAreaElevationPersistence(continent, 0.5);
		rmSetAreaElevationOctaves(continent, 5);
		rmSetAreaElevationMinFrequency(continent, 0.01);
		rmSetAreaElevationType(continent, cElevTurbulence);   
		rmBuildArea(continent);


	float zFlag = 0.8;
		float xDelta = 1.0/cNumberNonGaiaPlayers;
		float xFlag = xDelta/2;

		for(i=1; < cNumberPlayers) { 
         int waterFlag = rmCreateObjectDef("HC water flag "+i);
         rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 0.0);
         rmSetObjectDefMinDistance(waterFlag, 0);
         rmSetObjectDefMaxDistance(waterFlag, 40);
         
         rmAddObjectDefConstraint(waterFlag, avoidContinentFlag);
         rmAddObjectDefConstraint(waterFlag, circleConstraint);
         rmAddObjectDefConstraint(waterFlag, avoidWaterFlags);
         //rmPlaceObjectDefAtLoc(waterFlag, i, xFlag, zFlag, 1);
         rmPlaceObjectDefAtLoc(waterFlag, i, rmPlayerLocXFraction(i), zFlag, 1);
         //xFlag = xFlag + xDelta;
		}


		int tradeRouteID = rmCreateTradeRoute();
		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socketID, true);
		rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
		rmSetObjectDefMinDistance(socketID, 0.0);
		rmSetObjectDefMaxDistance(socketID, 6.0);

		rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.0);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.3, 4, 5);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.6, 4, 5);

		bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "water");
		vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		
		rmSetStatusText("",0.3);
		
		int fish2ID=rmCreateObjectDef("fish Tarpon");
		rmAddObjectDefItem(fish2ID, "FishTarpon", 1, 0.0);
		rmSetObjectDefMinDistance(fish2ID, 0.0);
		rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(fish2ID, fishVsFishID);
		rmAddObjectDefConstraint(fish2ID, fishLand);
		rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers);
		
		int whaleNum = 6;
		if(cNumberNonGaiaPlayers <3){
			whaleNum = 6;
		}else if(cNumberNonGaiaPlayers<5){
			whaleNum = 8;
		}else if(cNumberNonGaiaPlayers<7){ 
			whaleNum = 10;
		}else{
			whaleNum = 12;
		}
		

	  
		int rightWhale=rmCreateObjectDef("rightWhale");
		rmAddObjectDefItem(rightWhale, "HumpbackWhale", 1, 0.0);
		rmSetObjectDefMinDistance(rightWhale, 0.0);
		rmSetObjectDefMaxDistance(rightWhale, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(rightWhale, whaleVsWhaleID);
		rmAddObjectDefConstraint(rightWhale, whaleLand);
		rmPlaceObjectDefAtLoc(rightWhale, 0, 0.5, 0.5, whaleNum);

					
		int topRightShoreFix = rmCreateArea("fixes a water rendering bug on top right coast near cliff");
		rmSetAreaSize(topRightShoreFix, 0.019, 0.019);
		rmSetAreaLocation(topRightShoreFix, 0.95, 0.5);
		rmSetAreaTerrainType(topRightShoreFix, "saguenay\ground1_sag");
		rmSetAreaMix(topRightShoreFix, "saguenay grass");
		rmSetAreaBaseHeight(topRightShoreFix, 0);//was -4.5
		rmSetAreaCoherence(topRightShoreFix, 0.9);
		rmSetAreaElevationEdgeFalloffDist(topRightShoreFix, 10);
		rmSetAreaElevationVariation(topRightShoreFix, 5);
		rmSetAreaElevationPersistence(topRightShoreFix, 0.5);
		rmSetAreaElevationOctaves(topRightShoreFix, 5);
		rmSetAreaElevationMinFrequency(topRightShoreFix, 0.01);
		rmSetAreaElevationType(topRightShoreFix, cElevTurbulence);   
		rmBuildArea(topRightShoreFix); 

		int classPatch = rmDefineClass("patch");
		int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 22.0);
		int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
		
		int leftPlateau = rmCreateArea("plateau left");
		rmSetAreaSize(leftPlateau, 0.2, 0.2); 
		rmAddAreaToClass(leftPlateau, rmClassID("classPlateau"));
		rmAddAreaTerrainReplacement(leftPlateau, "texas\ground4_tex", "texas\ground2_tex");
		rmSetAreaCliffType(leftPlateau, "Saguenay");
		rmSetAreaCliffEdge(leftPlateau, 1, 1, 0.0, 0.0, 1); 
		rmSetAreaCliffPainting(leftPlateau, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(leftPlateau, 4, 0.1, 0.5);
		rmSetAreaCoherence(leftPlateau, .95);
		rmSetAreaLocation(leftPlateau, .05, .3);
		rmAddAreaInfluenceSegment(leftPlateau, 0.2, 0.0, 0.2, 0.4);
		rmBuildArea(leftPlateau);	
		
		int rightPlateau = rmCreateArea("plateau right");
		rmSetAreaSize(rightPlateau, 0.2, 0.2); 
		rmAddAreaToClass(rightPlateau, rmClassID("classPlateau"));
		rmAddAreaTerrainReplacement(rightPlateau, "texas\ground4_tex", "texas\ground2_tex");
		rmSetAreaCliffType(rightPlateau, "Saguenay");
		rmSetAreaCliffEdge(rightPlateau, 1, 1, 0.0, 0.0, 1); 
		rmSetAreaCliffPainting(rightPlateau, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(rightPlateau, 4, 0.1, 0.5);// was 3
		rmSetAreaCoherence(rightPlateau, .95);
		rmSetAreaLocation(rightPlateau, .85, .3);
		rmAddAreaInfluenceSegment(rightPlateau, 0.8, .0, 0.8, .4);
		rmBuildArea(rightPlateau);	
		
		int rampNumbers = 8;
				
		for(i=0; < rampNumbers) { 
		int rampLarge = rmCreateArea("top left center basin left ramp"+i);
		rmAddAreaTerrainReplacement(rampLarge, "saguenay\clifftop_sag", "saguenay\ground1_sag");
		rmSetAreaSize(rampLarge, 0.0044, 0.0044);
		rmSetAreaBaseHeight(rampLarge, 0.9);//was -3.6
		//rmSetAreaSmoothDistance(rampLarge, 4);
		rmSetAreaHeightBlend(rampLarge, 4);
		rmSetAreaCoherence(rampLarge, 1);
		if(i == 1){
		rmSetAreaLocation(rampLarge, 0.33, 0.5);
		}else if(i == 2){
		rmSetAreaLocation(rampLarge, 0.67, 0.5);
		}else if(i == 3){
		rmSetAreaLocation(rampLarge, 0.62, 0.12);
		}else if(i == 4){
		rmSetAreaLocation(rampLarge, 0.38, 0.12);
		}else if(i == 5){
		rmSetAreaLocation(rampLarge, 0.62, 0.35);
		}else if(i == 6){
		rmSetAreaLocation(rampLarge, 0.38, 0.35);
		}else if(i == 7){
		rmSetAreaLocation(rampLarge, 0.92, 0.525);
		}else{
		rmSetAreaLocation(rampLarge, 0.08, 0.525);
		}
		rmBuildArea(rampLarge); 
		}
		
		
		int playerStart = rmCreateStartingUnitsObjectDef(5.0);
		rmSetObjectDefMinDistance(playerStart, 7.0);
		rmSetObjectDefMaxDistance(playerStart, 12.0);
				
	
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Zen");
	subCiv1= rmGetCivID("Zen");
	rmSetSubCiv(0, "Zen");
	rmSetSubCiv(1, "Zen");
	
	int nativeID0 = -1;
   int nativeID2 = -1;
				
	nativeID0 = rmCreateGrouping("Zen village", "native zen temple cj 0"+4);
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));

	rmPlaceGroupingAtLoc(nativeID0, 0, 0.7, 0.35);
	

	nativeID2 = rmCreateGrouping("Zen village 2", "native zen temple cj 0"+5);
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));

	rmPlaceGroupingAtLoc(nativeID2, 0, 0.3, 0.35); 

   rmSetStatusText("",0.5);

		int berryID = rmCreateObjectDef("starting berries"); 
		rmAddObjectDefItem(berryID, "BerryBush", 4, 6.0); 
		rmSetObjectDefMinDistance(berryID, 8.0); 
		rmSetObjectDefMaxDistance(berryID, 12.0); 
		rmAddObjectDefConstraint(berryID, avoidCoin);

		int treeID = rmCreateObjectDef("starting trees"); 
		rmAddObjectDefItem(treeID, "ypTreeCoastalJapan", rmRandInt(6,9), 10.0); 
		rmAddObjectDefItem(treeID, "UnderbrushForest", rmRandInt(3,5), 8.0);
		rmSetObjectDefMinDistance(treeID, 20.0); 
		rmSetObjectDefMaxDistance(treeID, 25.0);
		rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
		rmAddObjectDefConstraint(treeID, avoidCoin);
		rmAddObjectDefConstraint(treeID, avoidHunt);
      
   rmSetStatusText("",0.55);
   
      int goldID = rmCreateObjectDef("starting gold");
      rmAddObjectDefItem(goldID, "mine", 1, 8.0);
      rmSetObjectDefMinDistance(goldID, 15.0);
      rmSetObjectDefMaxDistance(goldID, 15.0);
      rmAddObjectDefConstraint(goldID, forestConstraintShort);

      int gold2ID = rmCreateObjectDef("starting gold 2");
      rmAddObjectDefItem(gold2ID, "mine", 1, 8.0);
      rmSetObjectDefMinDistance(gold2ID, 25.0);
      rmSetObjectDefMaxDistance(gold2ID, 25.0);
      rmAddObjectDefConstraint(gold2ID, forestConstraintShort);
      rmAddObjectDefConstraint(gold2ID, avoidCoin);

      int foodID = rmCreateObjectDef("starting hunt1"); 
      rmAddObjectDefItem(foodID, "SikaDeer", 8, 12.0); 
      rmSetObjectDefMinDistance(foodID, 10.0); 
      rmSetObjectDefMaxDistance(foodID, 10.0); 	
      rmAddObjectDefConstraint(foodID, circleConstraint);
      rmAddObjectDefConstraint(foodID, avoidWaterLong);
      rmAddObjectDefConstraint(foodID, forestConstraintShort);
      rmSetObjectDefCreateHerd(foodID, true);

      int foodID2 = rmCreateObjectDef("starting hunt2"); 
      rmAddObjectDefItem(foodID2, "SikaDeer", 8, 13.0); 
      rmSetObjectDefMinDistance(foodID2, 40.0); 
      rmSetObjectDefMaxDistance(foodID2, 40.0); 
      rmAddObjectDefConstraint(foodID2, circleConstraint);
      rmAddObjectDefConstraint(foodID2, avoidWaterLong);
      rmAddObjectDefConstraint(foodID2, forestConstraintShort);
      rmSetObjectDefCreateHerd(foodID2, true);
		
		rmSetStatusText("",0.6);

		int foodID3 = rmCreateObjectDef("starting hunt3"); 
		rmAddObjectDefItem(foodID3, "SikaDeer", 8, 12.0); 
		rmSetObjectDefMinDistance(foodID3, 60.0); 
		rmSetObjectDefMaxDistance(foodID3, 60.0); 		
		rmAddObjectDefConstraint(foodID3, circleConstraint);
		rmAddObjectDefConstraint(foodID3, avoidWaterLong);
      rmAddObjectDefConstraint(foodID3, forestConstraintShort);
		rmSetObjectDefCreateHerd(foodID3, true);

		rmSetStatusText("",0.7);
      
      /*int waterFlag = rmCreateObjectDef("HC water flag ");
      rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 0.0);
      rmSetObjectDefMinDistance(waterFlag, 0);
      rmSetObjectDefMaxDistance(waterFlag, 80);*/

	    
		for(i=1; <cNumberPlayers) { 
		int id=rmCreateArea("Player"+i); 
		rmSetPlayerArea(i, id); 
		int startID = rmCreateObjectDef("object"+i); 
		if(rmGetNomadStart()){
			rmAddObjectDefItem(startID, "CoveredWagon", 1, 5.0);
		}else{
			rmAddObjectDefItem(startID, "TownCenter", 1, 5.0);
		}
		rmSetObjectDefMaxDistance(startID, 5.0);

		rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i)); 
      		rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      		rmPlaceObjectDefAtLoc(gold2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		/*
		if (cNumberNonGaiaPlayers>2){
		rmPlaceObjectDefAtLoc(foodID3, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		}
		*/
		rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	      

      		//rmPlaceObjectDefAtLoc(waterFlag, i, .5, 0.75, 1);

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	  }

		int cornerMines = rmCreateObjectDef(" cornerMines");
		rmAddObjectDefItem(cornerMines, "mine", 1, 1.0);
		rmSetObjectDefMinDistance(cornerMines, 0.0);
		rmSetObjectDefMaxDistance(cornerMines, rmXFractionToMeters(0.01));
		rmAddObjectDefConstraint(cornerMines, circleConstraint);
		rmPlaceObjectDefAtLoc(cornerMines, 0, 0.08, 0.605, 1);   
		rmPlaceObjectDefAtLoc(cornerMines, 0, 0.92, 0.605, 1);   

		int cornerHunts = rmCreateObjectDef("guarenteed corner hunts");
		rmAddObjectDefItem(cornerHunts, "SikaDeer", rmRandInt(8,8), 10.0);
		rmSetObjectDefCreateHerd(cornerHunts, true);
		rmSetObjectDefMinDistance(cornerHunts, 0);
		rmSetObjectDefMaxDistance(cornerHunts, rmXFractionToMeters(0.01));
		rmAddObjectDefConstraint(cornerHunts, circleConstraint);
		rmPlaceObjectDefAtLoc(cornerHunts, 0, 0.09, 0.605, 1);
		rmPlaceObjectDefAtLoc(cornerHunts, 0, 0.91, 0.605, 1);
		if (cNumberNonGaiaPlayers==2){
		rmPlaceObjectDefAtLoc(cornerHunts, 0, 0.25, 0.4, 1);
		rmPlaceObjectDefAtLoc(cornerHunts, 0, 0.75, 0.4, 1);
		}
		rmSetStatusText("",0.75);
		
		int cornerNugget= rmCreateObjectDef("corner nugs"); 
		rmAddObjectDefItem(cornerNugget, "Nugget", 1, 0.0); 
		rmSetObjectDefMinDistance(cornerNugget, 0.0); 
		rmSetObjectDefMaxDistance(cornerNugget, rmXFractionToMeters(0.01)); 
		rmAddObjectDefConstraint(cornerNugget, circleConstraint);
		rmSetNuggetDifficulty(3, 3); 
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.13, 0.606, 1);   
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.87, 0.606, 1);   
		
      
		int rheaxID = rmCreateObjectDef("ibex hunts");
		rmAddObjectDefItem(rheaxID, "SikaDeer", rmRandInt(8,8), 10.0);
		rmSetObjectDefCreateHerd(rheaxID, true);
		rmSetObjectDefMinDistance(rheaxID, 0);
		rmSetObjectDefMaxDistance(rheaxID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(rheaxID, circleConstraint);
		rmAddObjectDefConstraint(rheaxID, avoidTownCenterMedium);
		rmAddObjectDefConstraint(rheaxID, avoidHunt);
		rmAddObjectDefConstraint(rheaxID, AvoidWaterShort2); 
		rmAddObjectDefConstraint(rheaxID, avoidPlateau); 
      rmAddObjectDefConstraint(rheaxID, forestConstraintShort);
		rmPlaceObjectDefAtLoc(rheaxID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
		rmSetStatusText("",0.8); 
				
		int anvilNuggets = rmCreateObjectDef("nuggets on the anvil"); 
		rmAddObjectDefItem(anvilNuggets, "Nugget", 1, 0.0); 
		rmSetObjectDefMinDistance(anvilNuggets, 0.0); 
		rmSetObjectDefMaxDistance(anvilNuggets, rmXFractionToMeters(0.2)); 
		rmAddObjectDefConstraint(anvilNuggets, avoidNugget); 
		rmAddObjectDefConstraint(anvilNuggets, circleConstraint);
		rmAddObjectDefConstraint(anvilNuggets, avoidCoin); 
		rmAddObjectDefConstraint(anvilNuggets, forestConstraintShort);
		rmAddObjectDefConstraint(anvilNuggets, avoidWaterShort); 
		rmAddObjectDefConstraint(anvilNuggets, avoidTradeRoute);
		rmAddObjectDefConstraint(anvilNuggets, avoidSocket); 
		rmAddObjectDefConstraint(anvilNuggets, avoidPlateau); 
		rmSetNuggetDifficulty(2, 2); 
		rmPlaceObjectDefAtLoc(anvilNuggets, 0, 0.5, 0.8, 2*cNumberNonGaiaPlayers); 
		
		int anvilMines = rmCreateObjectDef("anvilMines gold");
		rmAddObjectDefItem(anvilMines, "mineGold", 1, 1.0);
		rmSetObjectDefMinDistance(anvilMines, 0.0);
		rmSetObjectDefMaxDistance(anvilMines, rmXFractionToMeters(0.09));
		rmAddObjectDefConstraint(anvilMines, avoidCoinMed);
		rmAddObjectDefConstraint(anvilMines, avoidSocket);
		rmAddObjectDefConstraint(anvilMines, AvoidWaterShort2);
		rmAddObjectDefConstraint(anvilMines, forestConstraintShort);
		rmAddObjectDefConstraint(anvilMines, circleConstraint);
		rmPlaceObjectDefAtLoc(anvilMines, 0, 0.5, 0.8, .5*cNumberNonGaiaPlayers);

	  	int mines = rmCreateObjectDef(" Mines");
		rmAddObjectDefItem(mines, "mine", 1, 1.0);
		rmSetObjectDefMinDistance(mines, 0.0);
		rmSetObjectDefMaxDistance(mines, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(mines, avoidCoinMed);
		rmAddObjectDefConstraint(mines, avoidTownCenterMore);
		rmAddObjectDefConstraint(mines, avoidSocket);
		rmAddObjectDefConstraint(mines, AvoidWaterShort2);
		rmAddObjectDefConstraint(mines, forestConstraintShort);
		rmAddObjectDefConstraint(mines, circleConstraint);
		rmAddObjectDefConstraint(mines, avoidPlateau);
		rmPlaceObjectDefAtLoc(mines, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
		      
		int leftMines = rmCreateObjectDef("leftMines");
		rmAddObjectDefItem(leftMines, "mine", 1, 1.0);
		rmSetObjectDefMinDistance(leftMines, 0.0);
		rmSetObjectDefMaxDistance(leftMines, rmXFractionToMeters(0.35));
		rmAddObjectDefConstraint(leftMines, avoidCoinMedPlateau);
		rmAddObjectDefConstraint(leftMines, avoidTownCenterMedium);
		rmAddObjectDefConstraint(leftMines, avoidSocket);
		rmAddObjectDefConstraint(leftMines, AvoidWaterShort2);
		rmAddObjectDefConstraint(leftMines, forestConstraintShort);
		rmAddObjectDefConstraint(leftMines, circleConstraint);
		rmAddObjectDefConstraint(leftMines, avoidTradeRouteFar);
      rmAddObjectDefConstraint(leftMines, plateuaGoldAvoidTrees);      
		rmPlaceObjectDefAtLoc(leftMines, 0, 0.25, 0.45, 1*(cNumberNonGaiaPlayers-1));

		int rightMines = rmCreateObjectDef("rightMines");
		rmAddObjectDefItem(rightMines, "mine", 1, 1.0);
		rmSetObjectDefMinDistance(rightMines, 0.0);
		rmSetObjectDefMaxDistance(rightMines, rmXFractionToMeters(0.35));
		rmAddObjectDefConstraint(rightMines, avoidCoinMedPlateau);
		rmAddObjectDefConstraint(rightMines, avoidTownCenterMedium);
		rmAddObjectDefConstraint(rightMines, avoidSocket);
		rmAddObjectDefConstraint(rightMines, AvoidWaterShort2);
		rmAddObjectDefConstraint(rightMines, forestConstraintShort);
		rmAddObjectDefConstraint(rightMines, circleConstraint);
		rmAddObjectDefConstraint(rightMines, avoidTradeRouteFar);
       rmAddObjectDefConstraint(rightMines, plateuaGoldAvoidTrees);
		rmPlaceObjectDefAtLoc(rightMines, 0, 0.75, 0.45, 1*(cNumberNonGaiaPlayers-1));

		int StartAreaTree2ID=rmCreateObjectDef("plateau trees");
		rmAddObjectDefItem(StartAreaTree2ID, "ypTreeCoastalJapan", rmRandInt(11,12), rmRandFloat(10.0,11.0));
		rmAddObjectDefItem(StartAreaTree2ID, "UnderbrushForest", rmRandInt(8,10), 12.0);
		rmAddObjectDefToClass(StartAreaTree2ID, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(StartAreaTree2ID, 0);
		rmSetObjectDefMaxDistance(StartAreaTree2ID, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(StartAreaTree2ID, avoidTradeRouteFar);
		rmAddObjectDefConstraint(StartAreaTree2ID, avoidSocket);
		rmAddObjectDefConstraint(StartAreaTree2ID, circleConstraint);
		rmAddObjectDefConstraint(StartAreaTree2ID, forestConstraint);
		rmAddObjectDefConstraint(StartAreaTree2ID, avoidTownCenterPlateauTrees);	
		rmAddObjectDefConstraint(StartAreaTree2ID, avoidWaterLong);	
		rmPlaceObjectDefAtLoc(StartAreaTree2ID, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers);
      
		int nuggetID= rmCreateObjectDef("nuggets small"); 
		rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
		rmSetObjectDefMinDistance(nuggetID, 0.0); 
		rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5)); 
		rmAddObjectDefConstraint(nuggetID, avoidNugget); 
		rmAddObjectDefConstraint(nuggetID, circleConstraint);
		rmAddObjectDefConstraint(nuggetID, avoidTownCenterSmall);
		rmAddObjectDefConstraint(nuggetID, avoidCoin); 
		rmAddObjectDefConstraint(nuggetID, forestConstraintShort);
		rmAddObjectDefConstraint(nuggetID, avoidWaterShort); 
		rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(nuggetID, avoidSocket); 
		rmSetNuggetDifficulty(1, 2); 
		rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 3*(cNumberNonGaiaPlayers + 1));   
		rmSetStatusText("",0.85);
			
		int rightShoreTrees=rmCreateObjectDef("the right half of the shore trees");
		rmAddObjectDefItem(rightShoreTrees, "ypTreeCoastalJapan", rmRandInt(11,12), rmRandFloat(10.0,11.0));
		rmAddObjectDefItem(StartAreaTree2ID, "UnderbrushForest", rmRandInt(8,10), 12.0);
		rmAddObjectDefToClass(rightShoreTrees, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(rightShoreTrees, 0);
		rmSetObjectDefMaxDistance(rightShoreTrees, rmXFractionToMeters(0.4));
		rmAddObjectDefConstraint(rightShoreTrees, forestConstraint);
		rmAddObjectDefConstraint(rightShoreTrees, shoreTreesAvoidWater);
		rmAddObjectDefConstraint(rightShoreTrees, shoreTreesAvoidCoin);
		rmAddObjectDefConstraint(rightShoreTrees, shoreTreesAvoidPlateau);
		rmAddObjectDefConstraint(rightShoreTrees, avoidSocket);
		rmAddObjectDefConstraint(rightShoreTrees, avoidTradeRoute);
		rmPlaceObjectDefAtLoc(rightShoreTrees, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers);

		
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


		rmSetStatusText("", 1.0);
		
	  // check for KOTH game mode
	  if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .6, .05, 0);
	  }

	}