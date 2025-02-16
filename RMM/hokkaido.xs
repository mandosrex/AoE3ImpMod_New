/* Durokan's Zuta / El Dorado- September 13 2016 Version 1.0*/

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

	rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);
	rmSetMapElevationHeightBlend(1);

	rmSetSeaLevel(4.0);

	rmSetMapType("land");
        rmSetMapType("grass");
        rmSetMapType("Japan");
        rmSetMapType("asia");
       	rmTerrainInitialize("grass");

	rmSetWorldCircleConstraint(false);

		rmSetLightingSet("saguenay");


		rmSetStatusText("",0.01);


        rmDefineClass("classForest");
		rmDefineClass("classPlateau");
		
		//Constraints
		int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 12.0);

        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.49), rmDegreesToRadians(0), rmDegreesToRadians(360));
       
		int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
        int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
        
		int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 50.0);
		int avoidHuntRain=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 35.0);
		int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 10.0);

        int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 50.0);

		int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
        int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 60.0);
        int avoidCoinMedGold=rmCreateTypeDistanceConstraint("avoid coin medium 2", "mineGold", 60.0);
        int avoidCoinMedCopper=rmCreateTypeDistanceConstraint("avoid coin medium 2", "mineCopper", 60.0);
        int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 5.0);

        int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 8.0);
        int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 25.0);
        
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 35.0);
        int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
        int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 40.0);  
       
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 60.0);
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);

		rmSetStatusText("",0.10);

       
 	// Player placing  
    float spawnSwitch = rmRandFloat(0,1.2);

	if (cNumberTeams == 2){
		if (spawnSwitch <=0.6){
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.2, 0.35, 0.4, 0.15, 0, 0);
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.65, 0.8, 0.85, 0.6, 0, 0);
		}else if(spawnSwitch <=1.2){
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.65, 0.8, 0.85, 0.6, 0, 0);
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.2, 0.35, 0.4, 0.15, 0, 0);
		}
	}else{
		rmPlacePlayersCircular(0.38, 0.38, 0.02);
	}
	

		rmSetStatusText("",0.20);
	

        chooseMercs();
         
        int continent2 = rmCreateArea("continent");
        rmSetAreaSize(continent2, 1.0, 1.0);
        rmSetAreaLocation(continent2, 0.5, 0.5);
        rmSetAreaTerrainType(continent2, "coastal_japan\ground_dirt1_co_japan");
        rmSetAreaMix(continent2, "coastal_japan_b");
        rmSetAreaBaseHeight(continent2, 8);
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
        rmSetAreaObeyWorldCircleConstraint(continent2, false);
        rmBuildArea(continent2);    

		
		int classSnow = rmDefineClass("snowSection");
		int classGrass = rmDefineClass("grassSection");
		int classRain = rmDefineClass("rainSection");
		int avoidSnow = rmCreateClassDistanceConstraint("avoid snow", rmClassID("snowSection"), 12.0);
		int avoidGrass = rmCreateClassDistanceConstraint("avoid grass", rmClassID("grassSection"), 8.0);
		int avoidRain = rmCreateClassDistanceConstraint("avoid rain", rmClassID("rainSection"), 12.0);


		rmSetStatusText("",0.30);


		int snowContinent2 = rmCreateArea("snowContinent2");
		rmAddAreaToClass(snowContinent2, rmClassID("snowSection"));
        rmSetAreaSize(snowContinent2, .3, .3);
        rmSetAreaLocation(snowContinent2, 0.45, 1.0);
        rmSetAreaTerrainType(snowContinent2, "araucania\ground_snow3_ara");
        rmSetAreaMix(snowContinent2, "araucania_snow_a");
        rmSetAreaCoherence(snowContinent2, .7);
		rmAddAreaInfluenceSegment(snowContinent2, 0.45, 1.0, 0.0, 0.55);
		rmSetAreaObeyWorldCircleConstraint(snowContinent2, false);
        rmBuildArea(snowContinent2); 

		int snowContinent = rmCreateArea("snowContinent");
		rmAddAreaToClass(snowContinent, rmClassID("snowSection"));
        rmSetAreaSize(snowContinent, .15, .15);
        rmSetAreaLocation(snowContinent, 0.45, 1.0);
        rmSetAreaTerrainType(snowContinent, "araucania\ground_snow4_ara");
        rmSetAreaMix(snowContinent, "araucania_snow_a");
        rmSetAreaCoherence(snowContinent, .7);
		rmAddAreaInfluenceSegment(snowContinent, 0.45, 1.0, 0.0, 0.55);
		rmSetAreaObeyWorldCircleConstraint(snowContinent, false);
        rmBuildArea(snowContinent); 

		int rainContinent = rmCreateArea("rainContinent");
		rmAddAreaToClass(rainContinent, rmClassID("rainSection"));
        rmSetAreaSize(rainContinent, .22, .22);
        rmSetAreaLocation(rainContinent, 1.0, .35);
        rmSetAreaTerrainType(rainContinent, "coastal_japan\ground_grass1_co_japan");
        rmSetAreaMix(rainContinent, "coastal_japan_b");
        rmSetAreaCoherence(rainContinent, .7);
		rmAddAreaInfluenceSegment(rainContinent, 1.0, .35, 0.65, 0.0);
		rmSetAreaObeyWorldCircleConstraint(rainContinent, false);
        rmBuildArea(rainContinent);
		
		int grassContinent = rmCreateArea("grassContinent");
		rmAddAreaToClass(grassContinent, rmClassID("grassSection"));
        rmSetAreaSize(grassContinent, .42, .42);
        rmSetAreaLocation(grassContinent, 1.0, 1.0);
        rmSetAreaTerrainType(grassContinent, "coastal_japan\ground_grass2_co_japan");
        rmSetAreaMix(grassContinent, "coastal_japan_b");
        rmSetAreaCoherence(grassContinent, .8);
		rmAddAreaInfluenceSegment(grassContinent, 1.0, .95, .05, 0.0);
		rmSetAreaObeyWorldCircleConstraint(grassContinent, false);
        rmBuildArea(grassContinent); 	
	
	int topRiver = rmRiverCreate(-1, "Araucania Snow River", 5, 6, 6, 6);
	rmRiverAddWaypoint(topRiver, .7, 1.0);
	rmRiverAddWaypoint(topRiver, .0, 0.3);
	rmRiverSetShallowRadius(topRiver, 14);
    rmRiverAddShallow(topRiver, .2);
	rmRiverAddShallow(topRiver, .8);
	rmRiverAddShallow(topRiver, .5);
	rmRiverSetBankNoiseParams(topRiver, 0.07, 2, 1.5, 10.0, 0.667, 2.0);
	rmRiverBuild(topRiver);
    

	//Snow Nats are Cherokee, Center are Cheyenne, right are Inca

	int subCiv0 = -1;
	int subCiv1 = -1;

	subCiv0 = rmGetCivID("Zen");
	subCiv1 = rmGetCivID("Shaolin");
	
	rmSetSubCiv(0, "Zen");
	rmSetSubCiv(1, "Shaolin");

	int nativeID0 = -1;
    int nativeID1 = -1;

    int zenVillageType = rmRandInt(1,5);
	nativeID0 = rmCreateGrouping("Zen village", "native zen temple cj 0"+zenVillageType);
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 1.00);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.88, 0.32); 
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.68, 0.12); 
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.93, 0.47); 
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.53, 0.07); 
	
    int shaolinVillageType = rmRandInt(1,5);
	nativeID1 = rmCreateGrouping("Shaolin village", "native shaolin temple yr 0"+shaolinVillageType);
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 1.00);
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.32, 0.88); 
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.12, 0.68); 
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.47, 0.93); 
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.07, 0.53); 


		rmSetStatusText("",0.40);


	//starting objects
		
        int playerStart = rmCreateStartingUnitsObjectDef(5.0);
        rmSetObjectDefMinDistance(playerStart, 7.0);
        rmSetObjectDefMaxDistance(playerStart, 12.0);
       
        int goldID = rmCreateObjectDef("starting gold");
        rmAddObjectDefItem(goldID, "mine", 1, 8.0);
        rmSetObjectDefMinDistance(goldID, 12.0);
        rmSetObjectDefMaxDistance(goldID, 12.0);
       
        int goldID2 = rmCreateObjectDef("starting gold 2");
        rmAddObjectDefItem(goldID2, "mine", 1, 16.0);
        rmSetObjectDefMinDistance(goldID2, 12.0);
        rmSetObjectDefMaxDistance(goldID2, 12.0);
        rmAddObjectDefConstraint(goldID2, avoidCoin);
 
        int berryID = rmCreateObjectDef("starting berries");
        rmAddObjectDefItem(berryID, "BerryBush", 2, 6.0);
        rmSetObjectDefMinDistance(berryID, 8.0);
        rmSetObjectDefMaxDistance(berryID, 12.0);
        rmAddObjectDefConstraint(berryID, avoidCoin);
 
        int treeID = rmCreateObjectDef("starting trees");
        rmAddObjectDefItem(treeID, "TreeSaguenay", rmRandInt(6,9), 10.0);
	rmAddObjectDefItem(treeID, "UnderbrushCoastalJapan", rmRandInt(3,5), rmRandFloat(5.0,7.0));
        rmSetObjectDefMinDistance(treeID, 12.0);
        rmSetObjectDefMaxDistance(treeID, 18.0);
        rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
        rmAddObjectDefConstraint(treeID, avoidCoin);
 
        int foodID = rmCreateObjectDef("starting hunt");
        rmAddObjectDefItem(foodID, "ypSerow", 6, 8.0);
        rmSetObjectDefMinDistance(foodID, 10.0);
        rmSetObjectDefMaxDistance(foodID, 12.0);
        rmSetObjectDefCreateHerd(foodID, false);
 
        int foodID2 = rmCreateObjectDef("starting hunt 2");
        rmAddObjectDefItem(foodID2, "SikaDeer", 7, 8.0);
        rmSetObjectDefMinDistance(foodID2, 35.0);
        rmSetObjectDefMaxDistance(foodID2, 40.0);
        rmSetObjectDefCreateHerd(foodID2, true);
                       
		int foodID3 = rmCreateObjectDef("starting hunt 3");
        rmAddObjectDefItem(foodID3, "ypSerow", 8, 8.0);
        rmSetObjectDefMinDistance(foodID3, 60.0);
        rmSetObjectDefMaxDistance(foodID3, 65.0);
        rmSetObjectDefCreateHerd(foodID3, true);
               
    for(i=1; < cNumberNonGaiaPlayers + 1) {
		int id=rmCreateArea("Player"+i);
		rmSetPlayerArea(i, id);
		int startID = rmCreateObjectDef("object"+i);
	if (rmGetNomadStart())
	{
		rmAddObjectDefItem(startID, "CoveredWagon", 1, 5.0);
	}
	else
	{
	rmAddObjectDefItem(startID, "TownCenter", 1, 5.0);
	}
		rmSetObjectDefMinDistance(startID, 0.0);
		rmSetObjectDefMaxDistance(startID, 7.0);

		rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        //rmPlaceObjectDefAtLoc(foodID3, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

        rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(goldID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}


		rmSetStatusText("",0.50);


	//==================
	//resource placement
	//==================
	
	
	/*
    int pronghornHunts = rmCreateObjectDef("pronghornHunts");
	rmAddObjectDefItem(pronghornHunts, "SikaDeer", rmRandInt(7,8), 14.0);
	rmSetObjectDefCreateHerd(pronghornHunts, true);
	rmSetObjectDefMinDistance(pronghornHunts, 0);
	rmSetObjectDefMaxDistance(pronghornHunts, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(pronghornHunts, circleConstraint);
	rmAddObjectDefConstraint(pronghornHunts, avoidTownCenterMore);
	rmAddObjectDefConstraint(pronghornHunts, avoidHunt);
	rmAddObjectDefConstraint(pronghornHunts, avoidSocket);	
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);

  	int islandminesID = rmCreateObjectDef("island silver");
	rmAddObjectDefItem(islandminesID, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(islandminesID, 0.0);
	rmSetObjectDefMaxDistance(islandminesID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(islandminesID, avoidCoinMed);
	rmAddObjectDefConstraint(islandminesID, avoidTownCenterMore);
	rmAddObjectDefConstraint(islandminesID, avoidSocket);
	rmAddObjectDefConstraint(islandminesID, avoidWaterShort);
	rmAddObjectDefConstraint(islandminesID, forestConstraintShort);
	rmAddObjectDefConstraint(islandminesID, circleConstraint);
	rmPlaceObjectDefAtLoc(islandminesID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
 
 
 	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(nuggetID, avoidImpassableLand); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
	rmAddObjectDefConstraint(nuggetID, forestConstraintShort);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(nuggetID, avoidSocket); 
	rmSetNuggetDifficulty(1, 2); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);   
	*/	
		

		rmSetStatusText("",0.60);


	for (j=0; < (6*cNumberNonGaiaPlayers)) {   
		int snowTrees=rmCreateObjectDef("snow trees"+j);
		rmAddObjectDefItem(snowTrees, "ypTreeHimalayas", rmRandInt(8,10), rmRandFloat(14.0,20.0));
		rmAddObjectDefItem(snowTrees, "UnderbrushPatagoniaSnow", rmRandInt(4,5), rmRandFloat(7.0,10.0));
		rmAddObjectDefToClass(snowTrees, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(snowTrees, 0);
		rmSetObjectDefMaxDistance(snowTrees, rmXFractionToMeters(0.45));
	  	rmAddObjectDefConstraint(snowTrees, circleConstraint);
		rmAddObjectDefConstraint(snowTrees, forestConstraint);
		rmAddObjectDefConstraint(snowTrees, avoidTownCenter);	
		rmAddObjectDefConstraint(snowTrees, avoidWaterShort);	
		rmAddObjectDefConstraint(snowTrees, avoidSocket);	
		rmAddObjectDefConstraint(snowTrees, avoidGrass);
		rmAddObjectDefConstraint(snowTrees, avoidRain);
		rmPlaceObjectDefAtLoc(snowTrees, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
	}

		for (j=0; < (6*cNumberNonGaiaPlayers)) {   
		int grassTrees=rmCreateObjectDef("grass trees"+j);
		rmAddObjectDefItem(grassTrees, "TreeSaguenay", rmRandInt(15,20), rmRandFloat(10.0,15.0));
		rmAddObjectDefItem(grassTrees, "UnderbrushCoastalJapan", rmRandInt(7,8), rmRandFloat(5.0,7.0));
		rmAddObjectDefToClass(grassTrees, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(grassTrees, 0);
		rmSetObjectDefMaxDistance(grassTrees, rmXFractionToMeters(0.45));
	  	rmAddObjectDefConstraint(grassTrees, circleConstraint);
		rmAddObjectDefConstraint(grassTrees, forestConstraint);
		rmAddObjectDefConstraint(grassTrees, avoidTownCenter);	
		rmAddObjectDefConstraint(grassTrees, avoidSocket);	
		rmAddObjectDefConstraint(grassTrees, avoidWaterShort);	
		rmAddObjectDefConstraint(grassTrees, avoidSnow);
		rmAddObjectDefConstraint(grassTrees, avoidRain);
		rmPlaceObjectDefAtLoc(grassTrees, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
	}
	
	for (j=0; < (6*cNumberNonGaiaPlayers)) {   
		int rainTrees=rmCreateObjectDef("rain trees"+j);
		rmAddObjectDefItem(rainTrees, "TreeSaguenay", rmRandInt(14,16), rmRandFloat(15.0,21.0));
		rmAddObjectDefItem(rainTrees, "UnderbrushCoastalJapan", rmRandInt(7,10), rmRandFloat(7.0,10.0));
		rmAddObjectDefToClass(rainTrees, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(rainTrees, 0);
		rmSetObjectDefMaxDistance(rainTrees, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(rainTrees, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(rainTrees, avoidSocket);
	  	rmAddObjectDefConstraint(rainTrees, circleConstraint);
		rmAddObjectDefConstraint(rainTrees, forestConstraint);
		rmAddObjectDefConstraint(rainTrees, avoidTownCenter);	
		rmAddObjectDefConstraint(rainTrees, avoidSocket);	
		rmAddObjectDefConstraint(rainTrees, avoidWaterShort);	
		rmAddObjectDefConstraint(rainTrees, avoidGrass);
		rmAddObjectDefConstraint(rainTrees, avoidSnow);
		rmPlaceObjectDefAtLoc(rainTrees, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
	}	


		rmSetStatusText("",0.70);


	int grassHunts = rmCreateObjectDef("grassHunts");
	rmAddObjectDefItem(grassHunts, "ypSerow", rmRandInt(9,10), 14.0);
	rmSetObjectDefCreateHerd(grassHunts, true);
	rmSetObjectDefMinDistance(grassHunts, 0);
	rmSetObjectDefMaxDistance(grassHunts, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(grassHunts, circleConstraint);
	rmAddObjectDefConstraint(grassHunts, avoidTownCenterMore);
	rmAddObjectDefConstraint(grassHunts, avoidHunt);
	rmAddObjectDefConstraint(grassHunts, avoidSocket);	
	rmAddObjectDefConstraint(grassHunts, avoidSnow);
	rmAddObjectDefConstraint(grassHunts, avoidRain);
	rmPlaceObjectDefAtLoc(grassHunts, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

	int rainHunts = rmCreateObjectDef("rainHunts");
	rmAddObjectDefItem(rainHunts, "SikaDeer", rmRandInt(4,5), 6.0);
	rmSetObjectDefCreateHerd(rainHunts, true);
	rmSetObjectDefMinDistance(rainHunts, 0);
	rmSetObjectDefMaxDistance(rainHunts, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rainHunts, circleConstraint);
	rmAddObjectDefConstraint(rainHunts, avoidTownCenterMore);
	rmAddObjectDefConstraint(rainHunts, avoidHuntRain);
	rmAddObjectDefConstraint(rainHunts, avoidSocket);	
	rmAddObjectDefConstraint(rainHunts, avoidSnow);
	rmAddObjectDefConstraint(rainHunts, avoidGrass);
	rmPlaceObjectDefAtLoc(rainHunts, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);

	int snowHunts = rmCreateObjectDef("snowHunts");
	rmAddObjectDefItem(snowHunts, "ypSerow", rmRandInt(5,6), 14.0);
	rmSetObjectDefCreateHerd(snowHunts, true);
	rmSetObjectDefMinDistance(snowHunts, 0);
	rmSetObjectDefMaxDistance(snowHunts, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(snowHunts, circleConstraint);
	rmAddObjectDefConstraint(snowHunts, avoidTownCenterMore);
	rmAddObjectDefConstraint(snowHunts, avoidHunt);
	rmAddObjectDefConstraint(snowHunts, avoidSocket);	
	rmAddObjectDefConstraint(snowHunts, avoidGrass);
	rmAddObjectDefConstraint(snowHunts, avoidRain);
	rmPlaceObjectDefAtLoc(snowHunts, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);


		rmSetStatusText("",0.80);


	int snowNuggets = rmCreateObjectDef("snowNuggets"); 
	rmAddObjectDefItem(snowNuggets, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(snowNuggets, 0.0); 
	rmSetObjectDefMaxDistance(snowNuggets, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(snowNuggets, avoidImpassableLand); 
	rmAddObjectDefConstraint(snowNuggets, avoidNugget); 
	rmAddObjectDefConstraint(snowNuggets, circleConstraint);
	rmAddObjectDefConstraint(snowNuggets, avoidTownCenter);
	rmAddObjectDefConstraint(snowNuggets, forestConstraintShort);
	rmAddObjectDefConstraint(snowNuggets, avoidSocket);	
	rmAddObjectDefConstraint(snowNuggets, avoidGrass);
	rmAddObjectDefConstraint(snowNuggets, avoidRain);
	rmSetNuggetDifficulty(3, 3); 
	rmPlaceObjectDefAtLoc(snowNuggets, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);   

	int grassNuggets = rmCreateObjectDef("grassNuggets"); 
	rmAddObjectDefItem(grassNuggets, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(grassNuggets, 0.0); 
	rmSetObjectDefMaxDistance(grassNuggets, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(grassNuggets, avoidImpassableLand); 
	rmAddObjectDefConstraint(grassNuggets, avoidNugget); 
	rmAddObjectDefConstraint(grassNuggets, circleConstraint);
	rmAddObjectDefConstraint(grassNuggets, avoidTownCenter);
	rmAddObjectDefConstraint(grassNuggets, forestConstraintShort);
	rmAddObjectDefConstraint(grassNuggets, avoidSocket);	
	rmAddObjectDefConstraint(grassNuggets, avoidSnow);
	rmAddObjectDefConstraint(grassNuggets, avoidRain);
	rmSetNuggetDifficulty(1, 1); 
	rmPlaceObjectDefAtLoc(grassNuggets, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);   

	int rainNuggets = rmCreateObjectDef("rainNuggets"); 
	rmAddObjectDefItem(rainNuggets, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(rainNuggets, 0.0); 
	rmSetObjectDefMaxDistance(rainNuggets, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(rainNuggets, avoidImpassableLand); 
	rmAddObjectDefConstraint(rainNuggets, avoidNugget); 
	rmAddObjectDefConstraint(rainNuggets, circleConstraint);
	rmAddObjectDefConstraint(rainNuggets, avoidTownCenter);
	rmAddObjectDefConstraint(rainNuggets, forestConstraintShort);
	rmAddObjectDefConstraint(rainNuggets, avoidSocket);	
	rmAddObjectDefConstraint(rainNuggets, avoidGrass);
	rmAddObjectDefConstraint(rainNuggets, avoidSnow);
	rmSetNuggetDifficulty(2, 2); 
	rmPlaceObjectDefAtLoc(rainNuggets, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);   


		rmSetStatusText("",0.90);


  	int grassMines = rmCreateObjectDef("grassMines");
	rmAddObjectDefItem(grassMines, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(grassMines, 0.0);
	rmSetObjectDefMaxDistance(grassMines, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(grassMines, avoidCoinMed);
	rmAddObjectDefConstraint(grassMines, avoidTownCenterMore);
	rmAddObjectDefConstraint(grassMines, avoidSocket);
	rmAddObjectDefConstraint(grassMines, avoidWaterShort);
	rmAddObjectDefConstraint(grassMines, forestConstraintShort);
	rmAddObjectDefConstraint(grassMines, circleConstraint);
	rmAddObjectDefConstraint(grassMines, avoidRain);
	rmAddObjectDefConstraint(grassMines, avoidSnow);
	rmPlaceObjectDefAtLoc(grassMines, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

	int snowMines = rmCreateObjectDef("snowMines");
	rmAddObjectDefItem(snowMines, "mineGold", 1, 1.0);
	rmSetObjectDefMinDistance(snowMines, 0.0);
	rmSetObjectDefMaxDistance(snowMines, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(snowMines, avoidCoinMedGold);
	rmAddObjectDefConstraint(snowMines, avoidTownCenterMore);
	rmAddObjectDefConstraint(snowMines, avoidSocket);
	rmAddObjectDefConstraint(snowMines, forestConstraintShort);
	rmAddObjectDefConstraint(snowMines, circleConstraint);
	rmAddObjectDefConstraint(snowMines, avoidRain);
	rmAddObjectDefConstraint(snowMines, avoidGrass);
	rmPlaceObjectDefAtLoc(snowMines, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

	int rainMines = rmCreateObjectDef("rainMines");
	rmAddObjectDefItem(rainMines, "mineCopper", 1, 1.0);
	rmSetObjectDefMinDistance(rainMines, 0.0);
	rmSetObjectDefMaxDistance(rainMines, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rainMines, avoidCoinMedCopper);
	rmAddObjectDefConstraint(rainMines, avoidTownCenterMore);
	rmAddObjectDefConstraint(rainMines, avoidSocket);
	rmAddObjectDefConstraint(rainMines, forestConstraintShort);
	rmAddObjectDefConstraint(rainMines, circleConstraint);
	rmAddObjectDefConstraint(rainMines, avoidSnow);
	rmAddObjectDefConstraint(rainMines, avoidGrass);
	rmPlaceObjectDefAtLoc(rainMines, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);


   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .04, 0);
   }

		rmSetStatusText("",0.99);

	}
 
