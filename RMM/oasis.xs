/* Durokan's  Oasis - April 28 2016 Version 1.0*/

	include "mercenaries.xs";
	include "ypAsianInclude.xs";
	include "ypKOTHInclude.xs";

	void main(void) { 
		float playerTiles=14000;
		if (cNumberNonGaiaPlayers > 2)
			playerTiles=13000;
		if (cNumberNonGaiaPlayers > 4)
			playerTiles=12000;
		if (cNumberNonGaiaPlayers > 6)
			playerTiles=11000;

		int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
		rmSetMapSize(size, size);
		rmSetSeaType("Oasis");
		rmSetSeaLevel(4);
		rmSetMapType("land");
		rmSetMapType("desert");
		rmSetMapType("asia");
		rmSetMapType("middleEast");
		rmTerrainInitialize("grass"); 
		rmSetLightingSet("Pampas");
		rmSetBaseTerrainMix("tigris1");

		rmSetWorldCircleConstraint(false);
		
		rmDefineClass("classForest");
		rmSetStatusText("",0.01);

		int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
		int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 40.0);
		int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 8.0);	
		int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 45.0);
		int avoidHuntBase=rmCreateTypeDistanceConstraint("stuff avoid hunts", "huntable", 4.0);
		int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
		int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 60.0);
		int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 6.0);
		int avoidWaterLong = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 20.0);
		int AvoidWaterShort2 = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 15.0);
		int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("objects avoid trade route", 12);
		int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("objects avoid trade route far", 30);
		int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 4.0);
		int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 5.0);
		int avoidSocketMore=rmCreateClassDistanceConstraint("bigger socket avoidance", rmClassID("socketClass"), 15.0);
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 35.0);
		int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
		int avoidTownCenterMedium=rmCreateTypeDistanceConstraint("avoid Town Center medium", "townCenter", 21.0);
		int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 70.0);	

	int avoidSocketMorey=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 25.0);

	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);

	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0);
		
		rmDefineClass("classPlateau");
		int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 5.0);
		rmDefineClass("classAntiTree");
		int avoidAntiTree=rmCreateClassDistanceConstraint("stuff vs. AntiTree", rmClassID("classAntiTree"), 5.0);
		rmDefineClass("classContinent");
		int avoidContinent=rmCreateClassDistanceConstraint("stuff vs. Continent", rmClassID("classContinent"), 5.0);

int spawnSwitch = rmRandFloat(0,1.2);
	
		if(cNumberNonGaiaPlayers == 2){
			if (spawnSwitch<0.6) {	
			rmPlacePlayer(1, 0.8, 0.8);
			rmPlacePlayer(2, 0.2, 0.2);
			}else{
			rmPlacePlayer(1, 0.2, 0.2);
			rmPlacePlayer(2, 0.8, 0.8);
			}
		}else if (cNumberTeams == 2){
			if (spawnSwitch<0.6) {	
				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.7, 0.87, 0.91, 0.63, 0, 0);
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.3, 0.12, 0.08, 0.37, 0, 0);
			}else{
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.7, 0.87, 0.91, 0.63, 0, 0);
				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.3, 0.12, 0.08, 0.37, 0, 0);
			}

		}else{
		if(cNumberNonGaiaPlayers == 3){
			rmPlacePlayer(1, 0.2, 0.2);
			rmPlacePlayer(2, 0.8, 0.8);
			rmPlacePlayer(3, 0.2, 0.8);
		}else if(cNumberNonGaiaPlayers == 4){
			rmPlacePlayer(1, 0.2, 0.2);
			rmPlacePlayer(2, 0.8, 0.8);
			rmPlacePlayer(3, 0.2, 0.8);
			rmPlacePlayer(4, 0.8, 0.2);
		}else if(cNumberNonGaiaPlayers == 5){
			rmPlacePlayer(1, 0.3, 0.1);
			rmPlacePlayer(2, 0.8, 0.8);
			rmPlacePlayer(3, 0.2, 0.8);
			rmPlacePlayer(4, 0.8, 0.2);
			rmPlacePlayer(5, 0.1, 0.3);
		}else if(cNumberNonGaiaPlayers == 6){
			rmPlacePlayer(1, 0.3, 0.1);
			rmPlacePlayer(2, 0.9, 0.7);
			rmPlacePlayer(3, 0.2, 0.8);
			rmPlacePlayer(4, 0.8, 0.2);
			rmPlacePlayer(5, 0.1, 0.3);
			rmPlacePlayer(6, 0.7, 0.9);
		}else if(cNumberNonGaiaPlayers == 7){
			rmPlacePlayer(1, 0.3, 0.1);
			rmPlacePlayer(6, 0.7, 0.9);
			rmPlacePlayer(2, 0.9, 0.7);
			rmPlacePlayer(7, 0.3, .9);
			rmPlacePlayer(4, 0.7, 0.1);
			rmPlacePlayer(5, 0.1, 0.3);
			rmPlacePlayer(3, 0.1, 0.7);
		}else if(cNumberNonGaiaPlayers == 8){
			rmPlacePlayer(1, 0.3, 0.1);
			rmPlacePlayer(6, 0.7, 0.9);
			rmPlacePlayer(2, 0.9, 0.7);
			rmPlacePlayer(7, 0.3, .9);
			rmPlacePlayer(4, 0.7, 0.1);
			rmPlacePlayer(5, 0.1, 0.3);
			rmPlacePlayer(3, 0.1, 0.7);
			rmPlacePlayer(8, .9, 0.3);
			}
		}
		chooseMercs();
		rmSetStatusText("",0.2);

		int continent = rmCreateArea("big huge continent");
		rmAddAreaToClass(continent, rmClassID("classContinent"));
		rmSetAreaSize(continent, 0.9, 0.9);
		rmSetAreaLocation(continent, 0.5, 0.5);
//		rmSetAreaTerrainType(continent, "texas\ground5_tex");
		rmSetAreaMix(continent, "tigris1");
		rmSetAreaBaseHeight(continent, 5);
		rmSetAreaCoherence(continent, 1.0);
		rmSetAreaSmoothDistance(continent, 10);
		rmSetAreaHeightBlend(continent, 1);
		rmSetAreaObeyWorldCircleConstraint(continent, false);
		rmSetAreaElevationEdgeFalloffDist(continent, 10);
		rmSetAreaElevationVariation(continent, 5);
		rmSetAreaElevationPersistence(continent, 0.5);
		rmSetAreaElevationOctaves(continent, 5);
		rmSetAreaElevationMinFrequency(continent, 0.01);
		rmSetAreaElevationType(continent, cElevTurbulence);   
		rmBuildArea(continent);
				
		int centerLake=rmCreateArea("center lake");
        rmSetAreaLocation(centerLake, 0.5, 0.5);
        rmSetAreaSize(centerLake, .03, .03);
        rmSetAreaWaterType(centerLake, "Oasis");
        rmSetAreaBaseHeight(centerLake, 4.0);
        rmSetAreaCoherence(centerLake, .86);
        rmBuildArea(centerLake);

		int riverGrass = rmCreateTerrainMaxDistanceConstraint("riverGrass stays near the water", "land", false, 12.0);

		int grassPatch=rmCreateArea("fertile grass");
		rmSetAreaSize(grassPatch, .5, .5);
		rmSetAreaLocation(grassPatch, .5, .5);
		rmSetAreaWarnFailure(grassPatch, false);
		rmSetAreaSmoothDistance(grassPatch, 10);
		rmSetAreaCoherence(grassPatch, 1.0);
		rmSetAreaTerrainType(grassPatch, "oasis\ground_forest_oasis");
		rmAddAreaConstraint(grassPatch, riverGrass);
		rmBuildArea(grassPatch);
	
    int rivershallowsize = 12;
	if (cNumberNonGaiaPlayers > 2){
		rivershallowsize = 16;
	}
	if (cNumberNonGaiaPlayers > 4){
		rivershallowsize = 20;
	}
	if (cNumberNonGaiaPlayers > 6){
		rivershallowsize = 24;
	}
	
	int halfShallowSize = rivershallowsize/2;
	int originalShallowSize = rivershallowsize;
	int shortRivers = rmRandInt(0,1);
		int leftTopRiver = rmRiverCreate(-1, "Oasis", 5, 15, 6, 9);
		int leftBotRiver = rmRiverCreate(-1, "Oasis", 5, 15, 6, 9);
		int rightTopRiver = rmRiverCreate(-1, "Oasis", 5, 15, 6, 9);
		int rightBotRiver = rmRiverCreate(-1, "Oasis", 5, 15, 6, 9);
			shortRivers = rmRandInt(0,1);
			rmRiverAddWaypoint(leftTopRiver, 0.5, 0.8);
			if(shortRivers == 0){
			rmRiverAddWaypoint(leftTopRiver, 0.5, 1.0);
			}else{
			rmRiverAddWaypoint(leftTopRiver, 0.5, 0.9);
			}
			shortRivers = rmRandInt(0,1);
			rmRiverAddWaypoint(leftBotRiver, 0.2, 0.5);
			if(shortRivers == 0){
			rmRiverAddWaypoint(leftBotRiver, 0.0, 0.5);
			}else{
			rmRiverAddWaypoint(leftBotRiver, 0.1, 0.5);
			}
			shortRivers = rmRandInt(0,1);
			rmRiverAddWaypoint(rightTopRiver, 0.8, 0.5);
			if(shortRivers == 0){
			rmRiverAddWaypoint(rightTopRiver, 1.0, 0.5);
			}else{
			rmRiverAddWaypoint(rightTopRiver, 0.9, 0.5);
			}
			shortRivers = rmRandInt(0,1);
			rmRiverAddWaypoint(rightBotRiver, 0.5, 0.2);
			if(shortRivers == 0){
			rmRiverAddWaypoint(rightBotRiver, 0.5, 0.0);
			}else{
			rmRiverAddWaypoint(rightBotRiver, 0.5, 0.1);
			}
			
	rmRiverSetShallowRadius(leftTopRiver, 10);
	rmRiverAddShallow(leftTopRiver, rmRandFloat(0.6, 0.6));
	rmRiverSetBankNoiseParams(leftTopRiver, 0.07, 2, 1.5, 10.0, 0.667, 2.0);

	rmRiverSetShallowRadius(rightBotRiver, 10);
	rmRiverAddShallow(rightBotRiver, rmRandFloat(0.6, 0.6));
	rmRiverSetBankNoiseParams(rightBotRiver, 0.07, 2, 1.5, 10.0, 0.667, 2.0);

	rmRiverSetShallowRadius(leftBotRiver, 10);
	rmRiverAddShallow(leftBotRiver, rmRandFloat(0.6, 0.6));
	rmRiverSetBankNoiseParams(leftBotRiver, 0.07, 2, 1.5, 10.0, 0.667, 2.0);

	rmRiverSetShallowRadius(rightTopRiver, 10);
	rmRiverAddShallow(rightTopRiver, rmRandFloat(0.6, 0.6));
	rmRiverSetBankNoiseParams(rightTopRiver, 0.07, 2, 1.5, 10.0, 0.667, 2.0);

	rmRiverBuild(leftTopRiver);
	rmRiverBuild(leftBotRiver);
	rmRiverBuild(rightBotRiver);
	rmRiverBuild(rightTopRiver);

	int middleRiver = rmRiverCreate(-1, "Oasis", 5, 15, 6, 9);
	
			rmRiverAddWaypoint(middleRiver, .7, 0.7);
			rmRiverAddWaypoint(middleRiver, .8, 0.5);

			rmRiverAddWaypoint(middleRiver, .7, 0.3);
			rmRiverAddWaypoint(middleRiver, .5, 0.2);

			rmRiverAddWaypoint(middleRiver, 0.3, 0.3);
			rmRiverAddWaypoint(middleRiver, .2, 0.5);
			
			rmRiverAddWaypoint(middleRiver, 0.3, 0.7);
			rmRiverAddWaypoint(middleRiver, .5, 0.8);
			rmRiverAddWaypoint(middleRiver, 0.7, 0.7);
			rmRiverSetShallowRadius(middleRiver, 16);
	
	rmRiverAddShallow(middleRiver, rmRandFloat(0.0, 0.00));
	rmRiverAddShallow(middleRiver, rmRandFloat(0.24, 0.26));
	rmRiverAddShallow(middleRiver, rmRandFloat(0.5, 0.5));
	rmRiverAddShallow(middleRiver, rmRandFloat(0.74, 0.76));

	rmRiverSetBankNoiseParams(middleRiver, 0.07, 2, 1.5, 10.0, 0.667, 2.0);
	rmRiverBuild(middleRiver);
				
		int blobAntiTree = rmCreateArea("keep trees out of center");
		rmAddAreaToClass(blobAntiTree, rmClassID("classAntiTree"));
		//rmSetAreaTerrainType(blobAntiTree, "saguenay\underwater3_sag");
		rmSetAreaCoherence(blobAntiTree, .75);
		rmSetAreaSize(blobAntiTree, 0.24, 0.24);
		rmSetAreaLocation(blobAntiTree, 0.5, 0.5);
		rmBuildArea(blobAntiTree); 
		
		int classPatch = rmDefineClass("patch");
		int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 22.0);
		int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));

		
	//Natives

	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Sufi");
	subCiv1 = rmGetCivID("Saltpeter");
	rmSetSubCiv(0, "Sufi");
	rmSetSubCiv(1, "Saltpeter");
	
	int nativeID0 = -1;
    	int nativeID2 = -1;
				
	int sufiVillageType = rmRandInt(1,5);
	nativeID0 = rmCreateGrouping("Sufi villages", "native sufi mosque deccan "+sufiVillageType);
	rmSetGroupingMinDistance(nativeID0, 0.00);
	rmSetGroupingMaxDistance(nativeID0, 1.00);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.61, 0.89);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.39, 0.11);
	
	int saltpeterVillageType = rmRandInt(1,3);
	nativeID2 = rmCreateGrouping("Saltpeter villages", "saltpeter_0"+saltpeterVillageType);
 	rmSetGroupingMinDistance(nativeID2, 0.00);
	rmSetGroupingMaxDistance(nativeID2, 1.00);
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));
	rmPlaceGroupingAtLoc(nativeID2, 0, 0.11, 0.61);
	rmPlaceGroupingAtLoc(nativeID2, 0, 0.89, 0.39);


						
		rmSetStatusText("",0.4);

		int playerStart = rmCreateStartingUnitsObjectDef(5.0);
		rmSetObjectDefMinDistance(playerStart, 6.0);
		rmSetObjectDefMaxDistance(playerStart, 12.0);
				
		int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 10.0);
	
		int elephantswitch = rmRandInt(0,1);
	
		int elephantHunts = rmCreateObjectDef("elephants");
		rmAddObjectDefItem(elephantHunts, "crane", 7, 10.0);
		rmSetObjectDefCreateHerd(elephantHunts, true);
		rmSetObjectDefMinDistance(elephantHunts, 0);
		rmSetObjectDefMaxDistance(elephantHunts, rmXFractionToMeters(0.06));
		rmAddObjectDefConstraint(elephantHunts, circleConstraint);	
		rmAddObjectDefConstraint(elephantHunts, avoidHunt);
		if(elephantswitch == 1){
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.6, 0.6, 1);   
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.4, 0.6, 1);   
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.6, 0.4, 1);
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.4, 0.4, 1);
		}else{
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.5, 0.7, 1);   
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.5, 0.3, 1);   
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.6, 0.5, 1);
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.4, 0.5, 1);
		}

	rmSetStatusText("",0.5);

		int berryID = rmCreateObjectDef("starting berries"); 
		rmAddObjectDefItem(berryID, "BerryBush", 4, 6.0); 
		rmSetObjectDefMinDistance(berryID, 8.0); 
		rmSetObjectDefMaxDistance(berryID, 12.0); 
		rmAddObjectDefConstraint(berryID, avoidCoin);

		int treeID = rmCreateObjectDef("starting trees"); 
		rmAddObjectDefItem(treeID, "TreeNile", rmRandInt(6,9), 10.0); 
		rmAddObjectDefItem(treeID, "UnderbrushDeccan", rmRandInt(8,10), 12.0);
		rmSetObjectDefMinDistance(treeID, 20.0); 
		rmSetObjectDefMaxDistance(treeID, 25.0);
		rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
		rmAddObjectDefConstraint(treeID, avoidCoin);
		rmAddObjectDefConstraint(treeID, avoidHunt);

		int foodID = rmCreateObjectDef("starting hunt1"); 
		rmAddObjectDefItem(foodID, "heron", 7, 12.0); 
		rmSetObjectDefMinDistance(foodID, 10.0); 
		rmSetObjectDefMaxDistance(foodID, 12.0); 	
		rmAddObjectDefConstraint(foodID, circleConstraint);
		rmSetObjectDefCreateHerd(foodID, false);

		int foodID2 = rmCreateObjectDef("starting hunt2"); 
		rmAddObjectDefItem(foodID2, "crane", 7, 13.0); 
		rmSetObjectDefMinDistance(foodID2, 38.0); 
		rmSetObjectDefMaxDistance(foodID2, 40.0); 
		rmAddObjectDefConstraint(foodID2, circleConstraint);
		rmSetObjectDefCreateHerd(foodID2, true);
		
		rmSetStatusText("",0.6);

	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 28.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerNuggetID, avoidSocket);
	rmAddObjectDefConstraint(playerNuggetID, avoidAll);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
	rmAddObjectDefConstraint(playerNuggetID, avoidTownCenterSmall);
	int nugget0count = rmRandInt (1,2);

		rmSetStatusText("",0.7);

		for(i=1; <cNumberPlayers) { 
		int id=rmCreateArea("Player"+i); 
		rmSetPlayerArea(i, id); 

		int startID = rmCreateObjectDef("object"+i); 
		if(rmGetNomadStart()){
			rmAddObjectDefItem(startID, "CoveredWagon", 1, 5.0);
		}else{
			rmAddObjectDefItem(startID, "TownCenter", 1, 5.0);
		}	
		rmSetObjectDefMinDistance(startID, 0.0);
		rmSetObjectDefMaxDistance(startID, 5.0);

		rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i)); 
		rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	  }
	  
	int deerHunts = rmCreateObjectDef("deer");
	rmAddObjectDefItem(deerHunts, "heron", rmRandInt(6,7), 6.0);
	rmSetObjectDefCreateHerd(deerHunts, true);
	rmSetObjectDefMinDistance(deerHunts, 0);
	rmSetObjectDefMaxDistance(deerHunts, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(deerHunts, circleConstraint);
	rmAddObjectDefConstraint(deerHunts, avoidTownCenterMedium);
	rmAddObjectDefConstraint(deerHunts, avoidHunt);
	rmPlaceObjectDefAtLoc(deerHunts, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

	int pronghornHunts = rmCreateObjectDef("pronghornHunts");
	rmAddObjectDefItem(pronghornHunts, "crane", rmRandInt(6,7), 6.0);
	rmSetObjectDefCreateHerd(pronghornHunts, true);
	rmSetObjectDefMinDistance(pronghornHunts, 0);
	rmSetObjectDefMaxDistance(pronghornHunts, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(pronghornHunts, circleConstraint);
	rmAddObjectDefConstraint(pronghornHunts, avoidTownCenterMedium);
	rmAddObjectDefConstraint(pronghornHunts, avoidHunt);
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

	int islandminesID = rmCreateObjectDef("island silver");
	rmAddObjectDefItem(islandminesID, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(islandminesID, 0.0);
	rmSetObjectDefMaxDistance(islandminesID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(islandminesID, avoidCoinMed);
	rmAddObjectDefConstraint(islandminesID, avoidTownCenterMore);
	rmAddObjectDefConstraint(islandminesID, forestConstraintShort);
	rmAddObjectDefConstraint(islandminesID, avoidWaterShort);
	rmAddObjectDefConstraint(islandminesID, circleConstraint);
	rmPlaceObjectDefAtLoc(islandminesID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);


			for (j=0; < (4*cNumberNonGaiaPlayers)) {   
			int StartAreaTree2ID=rmCreateObjectDef("trees"+j);
			rmAddObjectDefItem(StartAreaTree2ID, "TreeNile", rmRandInt(8,10), rmRandFloat(10.0,12.0));
			rmAddObjectDefToClass(StartAreaTree2ID, rmClassID("classForest")); 
			rmSetObjectDefMinDistance(StartAreaTree2ID, 0);
			rmSetObjectDefMaxDistance(StartAreaTree2ID, rmXFractionToMeters(0.52));
			rmAddObjectDefConstraint(StartAreaTree2ID, forestConstraint);
			rmAddObjectDefConstraint(StartAreaTree2ID, avoidAntiTree); 
			rmAddObjectDefConstraint(StartAreaTree2ID, avoidWaterShort); 
			rmPlaceObjectDefAtLoc(StartAreaTree2ID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
		}
		    int riverHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 16.0);

			for (j=0; < (4*cNumberNonGaiaPlayers)) {   
			int oasisTrees=rmCreateObjectDef("oasis Trees"+j);
			rmAddObjectDefItem(oasisTrees, "TreeNile", rmRandInt(1,1), rmRandFloat(10.0,12.0));
			rmAddObjectDefToClass(oasisTrees, rmClassID("classForest")); 
			rmSetObjectDefMinDistance(oasisTrees, 0);
			rmSetObjectDefMaxDistance(oasisTrees, rmXFractionToMeters(0.12));
			rmAddObjectDefConstraint(oasisTrees, forestConstraintShort);
			rmAddObjectDefConstraint(oasisTrees, riverHunt);
			rmAddObjectDefConstraint(oasisTrees, avoidWaterShort);
			rmPlaceObjectDefAtLoc(oasisTrees, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);
		}

		
		
	  	int mineb=rmAddFairLoc("TownCenter", false, false, 18, 19, 12, 5); 

   if(rmPlaceFairLocs())
   {
   mineb=rmCreateObjectDef("mine behind");
   rmAddObjectDefItem(mineb, "mine", 1, 0.0);
   for(i=1; <cNumberNonGaiaPlayers+1)
      {
   for(j=0; <rmGetNumberFairLocs(i))
         {
   rmPlaceObjectDefAtLoc(mineb, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
         }
      }
   }

	int minef=rmAddFairLoc("TownCenter", true, true, 18, 19, 12, 5);

	if(rmPlaceFairLocs()){
		minef=rmCreateObjectDef("forward mine");
		rmAddObjectDefItem(minef, "mine", 1, 0.0);
			for(i=1; <cNumberNonGaiaPlayers+1){
				for(j=1; <rmGetNumberFairLocs(i)){
					rmPlaceObjectDefAtLoc(minef, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
				}
			}
	}
   

		rmSetStatusText("",0.8);

   		int island = rmCreateArea("center island");
		rmSetAreaSize(island, 0.005, 0.005);
		rmSetAreaLocation(island, 0.5, 0.5);
		rmSetAreaTerrainType(island, "oasis\ground_grass1_oasis");
		rmSetAreaBaseHeight(island, 5.0);
		rmSetAreaCoherence(island, .8);
		rmSetAreaSmoothDistance(island, 1);
		rmSetAreaElevationEdgeFalloffDist(island, 10);
		rmSetAreaElevationVariation(island, 5);
		rmSetAreaElevationPersistence(island, 0.5);
		rmSetAreaElevationOctaves(island, 5);
		rmSetAreaElevationMinFrequency(island, 0.01);
		rmSetAreaElevationType(island, cElevTurbulence);   
		rmBuildArea(island);

 	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
	rmAddObjectDefConstraint(nuggetID, avoidAll);
	rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(nuggetID, avoidSocketMorey);
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidAll);
	rmSetNuggetDifficulty(2, 3); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);  


   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .02, 0);
   }
 

		rmSetStatusText("", 0.99);

	}