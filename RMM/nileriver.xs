	/* Durokan's fertilebelt - Feb 21 2016 1.0 -- -- */

	include "mercenaries.xs";
	include "ypAsianInclude.xs";
	include "ypKOTHInclude.xs";
 
	void main(void) {
	
	int playerTiles = 20000;
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=19000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=18000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=17000;			

  int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
  rmEchoInfo("Map size="+size+"m x "+size+"m");
  rmSetMapSize(size, size);
  
        rmSetMapType("land");
        rmSetMapType("grass");
        rmSetMapType("asia");
        rmSetMapType("middleEast");
		rmSetMapElevationParameters(cElevTurbulence, 0.06, 1, 0.4, 3.0);
		rmSetMapElevationHeightBlend(0.6);
		rmSetLightingSet("301a_malta");

	rmSetWorldCircleConstraint(false);
		

	// Init map.
	rmSetBaseTerrainMix("tigris0");
	rmTerrainInitialize("oasis\ground_grass3_oasis", 0);
	rmSetSeaLevel(0.0);


		rmSetStatusText("",0.01);


    // Paint continent
  int continent=rmCreateArea("continent");
  rmSetAreaSize(continent, 1.0, 1.0);
  rmSetAreaBaseHeight(continent, 1.0);
  rmSetAreaLocation(continent, .5, .5);
  rmSetAreaSmoothDistance(continent, 10);
  rmSetAreaCoherence(continent, 1.0);
  rmSetAreaTerrainType(continent, "oasis\ground_grass3_oasis");
  rmSetAreaMix(continent, "tigris0");
  rmBuildArea(continent);


		rmSetStatusText("",0.10);


    rmDefineClass("classForest");

        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.49), rmDegreesToRadians(0), rmDegreesToRadians(360));
        int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
        int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
		int forestConstraintHunt=rmCreateClassDistanceConstraint("river hunts vs. forest", rmClassID("classForest"), 15.0);
        int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 50.0);
		int avoidHuntShort=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 25.0);
		int avoidHuntSparse=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 55.0);
		int avoidHerdSparse=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 55.0);
        int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
        int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 60.0);
        int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 9.0);
        int avoidWaterReallyShort = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 1.0);
        int AvoidWaterShort2 = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 15.0);
        int AvoidWaterLong = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 22.0);
        int dryAF = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 100.0);
        int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("objects avoid trade route", 6);
        int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 4.0);
        int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 5.0);
        int avoidSocketMore=rmCreateClassDistanceConstraint("bigger socket avoidance", rmClassID("socketClass"), 15.0);
        int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 35.0);
        int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
        int avoidTownCenterMedium=rmCreateTypeDistanceConstraint("avoid Town Center medium", "townCenter", 18.0);
        int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 40.0);  
        int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 68.0);
        int avoidNuggetMedium=rmCreateTypeDistanceConstraint("avoid nuggets", "AbstractNugget", 30.0);
        int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 10.0);
		int AvoidHerdables = rmCreateTerrainDistanceConstraint("avoid herds by something", "herdables", false, 45.0);
		int avoidRush=rmCreateTypeDistanceConstraint("avoid rush by a lot", "AbstractRush", 75.0);
        int riverGrass = rmCreateTerrainMaxDistanceConstraint("riverGrass stays near the water", "land", false, 24.0);
        int riverHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 12.0);
        int riverHuntMore = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water 2", "land", false, 24.0);
        int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
        int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);

	
        chooseMercs();
		
		  // Player placing  
  
  int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
  
  

	if (cNumberNonGaiaPlayers == 2)	{

		rmPlacePlayer(1, 0.15, 0.55);
		rmPlacePlayer(2, 0.55, 0.15);

	}

	else if (cNumberTeams == 2)	{
		
		rmSetPlacementTeam(0);
		rmSetPlacementSection(0.73, 0.83);
		rmPlacePlayersCircular(0.39, 0.39, .02);
            

		rmSetPlacementTeam(1);
		rmSetPlacementSection(0.43, 0.53);
		rmPlacePlayersCircular(0.39, 0.39, .02);
    
	}

	// FFA
	else {
	rmSetPlacementSection(0.35, 0.9);
	rmPlacePlayersCircular(0.4, 0.4, 0.02);
	}

	// Text
	// rmSetStatusText("",0.10);
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
	

		rmSetStatusText("",0.30);


	int halfShallowSize = rivershallowsize/2;
	int originalShallowSize = rivershallowsize;
	
	int middleRiver = rmRiverCreate(-1, "Nile", 5, 15, 9, 12);
	rmRiverAddWaypoint(middleRiver, 0.0, 0.0);
	rmRiverAddWaypoint(middleRiver, .6, .6);
	rmRiverSetBankNoiseParams(middleRiver, 0.07, 2, 1.5, 10.0, 0.667, 2.0);
	rmRiverBuild(middleRiver);

	int topRiver = rmRiverCreate(-1, "Nile", 5, 15, 6, 9);
	rmRiverAddWaypoint(topRiver, 1.0, 0.75);
	rmRiverAddWaypoint(topRiver, .6, .6);
	rmRiverAddWaypoint(topRiver, .75, 1.0);
	rmRiverSetShallowRadius(topRiver, halfShallowSize);
    rmRiverAddShallow(topRiver, rmRandFloat(0.0, 0.1));
    rmRiverAddShallow(topRiver, rmRandFloat(0.15, 0.25));
	rmRiverAddShallow(topRiver, rmRandFloat(0.3, 0.45));
	rmRiverAddShallow(topRiver, rmRandFloat(0.5, 0.5));
	rmRiverAddShallow(topRiver, rmRandFloat(0.75, 0.85));
	rmRiverAddShallow(topRiver, rmRandFloat(0.9, 1.00));
	rmRiverSetShallowRadius(topRiver, rivershallowsize);
    rmRiverAddShallow(topRiver, rmRandFloat(0.55, 0.7));
	rmRiverSetShallowRadius(topRiver, halfShallowSize);
	rmRiverSetBankNoiseParams(topRiver, 0.07, 2, 1.5, 10.0, 0.667, 2.0);
	rmRiverBuild(topRiver);

	int botRiver = rmRiverCreate(-1, "Nile", 5, 15, 6, 9);
	rmRiverAddWaypoint(botRiver, 1.0, 0.55);
	rmRiverAddWaypoint(botRiver, .4, .4);
	rmRiverAddWaypoint(botRiver, .55, 1.0);
	rmRiverSetShallowRadius(botRiver, rivershallowsize);
    rmRiverAddShallow(botRiver, rmRandFloat(0.0, 0.1));
    rmRiverAddShallow(botRiver, rmRandFloat(0.15, 0.25));
	rmRiverAddShallow(botRiver, rmRandFloat(0.3, 0.45));
	rmRiverAddShallow(botRiver, rmRandFloat(0.5, 0.5));
	rmRiverAddShallow(botRiver, rmRandFloat(0.75, 0.85));
	rmRiverAddShallow(botRiver, rmRandFloat(0.9, 1.00));
	rmRiverSetShallowRadius(botRiver, halfShallowSize);
    rmRiverAddShallow(botRiver, rmRandFloat(0.55, 0.7));
	rmRiverSetShallowRadius(botRiver, rivershallowsize);
	rmRiverSetBankNoiseParams(botRiver, 0.07, 2, 1.5, 10.0, 0.667, 2.0);
	rmRiverBuild(botRiver);

    // Paint some grass near the river
  int grassRiver=rmCreateArea("river grass");
  rmSetAreaSize(grassRiver, 1.0, 1.0);
  rmSetAreaLocation(grassRiver, .5, .5);
  rmSetAreaWarnFailure(grassRiver, false);
  rmSetAreaSmoothDistance(grassRiver, 10);
  rmSetAreaCoherence(grassRiver, 1.0);
	rmSetAreaTerrainType(grassRiver, "oasis\ground_forest_oasis");
  rmSetAreaMix(grassRiver, "tigris2");
  rmAddAreaConstraint(grassRiver, riverGrass);
  rmBuildArea(grassRiver);
  

		rmSetStatusText("",0.40);



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
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.4, 0.9);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.9, 0.4);
	
	int saltpeterVillageType = rmRandInt(1,3);
	nativeID2 = rmCreateGrouping("Saltpeter villages", "saltpeter_0"+saltpeterVillageType);
 	rmSetGroupingMinDistance(nativeID2, 0.00);
	rmSetGroupingMaxDistance(nativeID2, 1.00);
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));
	rmPlaceGroupingAtLoc(nativeID2, 0, 0.35, 0.7);
	rmPlaceGroupingAtLoc(nativeID2, 0, 0.7, 0.35);
	rmPlaceGroupingAtLoc(nativeID2, 0, 0.8, 0.8);



  /*
      // Paint some grass near the river
  int grassPatchBot=rmCreateArea("bot river grass");
  rmSetAreaSize(grassPatchBot, .5, .5);
  rmSetAreaLocation(grassPatchBot, .3, .5);
  rmSetAreaWarnFailure(grassPatchBot, false);
  rmSetAreaSmoothDistance(grassPatchBot, 10);
  rmSetAreaCoherence(grassPatchBot, 1.0);
  rmSetAreaMix(grassPatchBot, "tigris0");
  rmAddAreaConstraint(grassPatchBot, riverGrass);
  rmBuildArea(grassPatchBot);*/


		rmSetStatusText("",0.50);


        int playerStart = rmCreateStartingUnitsObjectDef(5.0);
        rmSetObjectDefMinDistance(playerStart, 7.0);
        rmSetObjectDefMaxDistance(playerStart, 12.0);
       
        int goldID = rmCreateObjectDef("starting gold");
        rmAddObjectDefItem(goldID, "minegold", 1, 8.0);
        rmSetObjectDefMinDistance(goldID, 15.0);
        rmSetObjectDefMaxDistance(goldID, 15.0);
        
        int berryID = rmCreateObjectDef("starting berries");
        rmAddObjectDefItem(berryID, "BerryBush", 4, 6.0);
        rmSetObjectDefMinDistance(berryID, 10.0);
        rmSetObjectDefMaxDistance(berryID, 12.0);
        rmAddObjectDefConstraint(berryID, avoidCoin);
 
        int treeID = rmCreateObjectDef("starting trees");
        rmAddObjectDefItem(treeID, "TreeSonora", rmRandInt(6,9), 10.0);
        rmAddObjectDefItem(treeID, "UnderbrushDeccan", rmRandInt(8,10), 12.0);
        rmSetObjectDefMinDistance(treeID, 12.0);
        rmSetObjectDefMaxDistance(treeID, 18.0);
        rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
        rmAddObjectDefConstraint(treeID, avoidCoin);
 
        int foodID = rmCreateObjectDef("starting hunt");
        rmAddObjectDefItem(foodID, "Dromedary", 6, 8.0);
        rmSetObjectDefMinDistance(foodID, 11.0);
        rmSetObjectDefMaxDistance(foodID, 15.0);
        rmSetObjectDefCreateHerd(foodID, false);
 
        int foodID2 = rmCreateObjectDef("starting hunt 2");
        rmAddObjectDefItem(foodID2, "ypWildElephant", 4, 8.0);
        rmSetObjectDefMinDistance(foodID2, 35.0);
        rmSetObjectDefMaxDistance(foodID2, 40.0);
        rmSetObjectDefCreateHerd(foodID2, true);

 	int startnuggetID= rmCreateObjectDef("starting nugget"); 
	rmAddObjectDefItem(startnuggetID, "Nugget", 1, 0.0); 
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(startnuggetID, 20.0);
	rmSetObjectDefMaxDistance(startnuggetID, 25.0);
	rmAddObjectDefConstraint(startnuggetID, avoidNuggetMedium); 
	rmAddObjectDefConstraint(startnuggetID, avoidAll);


		rmSetStatusText("",0.60);


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
		rmSetObjectDefMaxDistance(startID, 20.0);

    	rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(startnuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(startnuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

  }
  

   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.65, .65, .06, 0);
   }


		rmSetStatusText("",0.70);


		int wetHunts = rmCreateObjectDef("wetHunts");
        rmAddObjectDefItem(wetHunts, "ypWildElephant", rmRandInt(3,4), 10.0);
        rmSetObjectDefCreateHerd(wetHunts, true);
        rmSetObjectDefMinDistance(wetHunts, 0);
        rmSetObjectDefMaxDistance(wetHunts, rmXFractionToMeters(0.5));
        rmAddObjectDefConstraint(wetHunts, avoidHuntShort);
		rmAddObjectDefConstraint(wetHunts, riverHunt);
		rmAddObjectDefConstraint(wetHunts, avoidImpassableLand);
        rmPlaceObjectDefAtLoc(wetHunts, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);

		int rightmines = rmCreateObjectDef("right gold mines");
        rmAddObjectDefItem(rightmines, "mine", 1, 1.0);
        rmSetObjectDefMinDistance(rightmines, 0.0);
        rmSetObjectDefMaxDistance(rightmines, rmXFractionToMeters(0.3));
        rmAddObjectDefConstraint(rightmines, avoidCoinMed);
        rmAddObjectDefConstraint(rightmines, avoidTownCenterMore);
        rmAddObjectDefConstraint(rightmines, AvoidWaterShort2);
        rmAddObjectDefConstraint(rightmines, forestConstraintShort);
        rmAddObjectDefConstraint(rightmines, circleConstraint);
		rmAddObjectDefConstraint(rightmines, dryAF);
        rmPlaceObjectDefAtLoc(rightmines, 0, 0.5, 0.1, 1*cNumberNonGaiaPlayers + 1);

		int leftmines = rmCreateObjectDef("left gold mines");
        rmAddObjectDefItem(leftmines, "mine", 1, 1.0);
        rmSetObjectDefMinDistance(leftmines, 0.0);
        rmSetObjectDefMaxDistance(leftmines, rmXFractionToMeters(0.3));
        rmAddObjectDefConstraint(leftmines, avoidCoinMed);
        rmAddObjectDefConstraint(leftmines, avoidTownCenterMore);
        rmAddObjectDefConstraint(leftmines, AvoidWaterShort2);
        rmAddObjectDefConstraint(leftmines, forestConstraintShort);
        rmAddObjectDefConstraint(leftmines, circleConstraint);
		rmAddObjectDefConstraint(leftmines, dryAF);
        rmPlaceObjectDefAtLoc(leftmines, 0, 0.1, 0.5, 1*cNumberNonGaiaPlayers + 1);

		int nuggetID= rmCreateObjectDef("nugget"); 
		rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
		rmSetObjectDefMinDistance(nuggetID, 0.0); 
		rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.35)); 
		rmAddObjectDefConstraint(nuggetID, avoidNugget); 
		rmSetNuggetDifficulty(2, 3); 
		rmAddObjectDefConstraint(nuggetID, riverHuntMore);
		rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
		rmPlaceObjectDefAtLoc(nuggetID, 0, 0.7, 0.7, 2*(cNumberNonGaiaPlayers + 3));   
	
     for (j=0; < (12)) {  
                int wetForest=rmCreateObjectDef("wet trees"+j);
                rmAddObjectDefItem(wetForest, "TreeNile", rmRandInt(2,3), rmRandFloat(8.0,16.0));
                rmAddObjectDefItem(wetForest, "ypTreeBorneoPalm", rmRandInt(1,1), rmRandFloat(2.0,4.0));
                rmAddObjectDefToClass(wetForest, rmClassID("classForest"));
                rmSetObjectDefMinDistance(wetForest, 0);
                rmSetObjectDefMaxDistance(wetForest, rmXFractionToMeters(0.5));
                rmAddObjectDefConstraint(wetForest, forestConstraintShort);
                rmAddObjectDefConstraint(wetForest, riverHunt);       
		rmAddObjectDefConstraint(wetForest, avoidWaterShort);
		rmAddObjectDefConstraint(wetForest, avoidImpassableLand);
                rmPlaceObjectDefAtLoc(wetForest, 0, .5, 0.5, 5*cNumberNonGaiaPlayers);
				}
				
	
		rmSetStatusText("",0.90);

		
        for (j=0; < (12)) {  
			int dryForest=rmCreateObjectDef("dry Forest"+j);
			rmAddObjectDefItem(dryForest, "TreeSonora", rmRandInt(5,9), rmRandFloat(8.0,16.0));
			rmAddObjectDefToClass(dryForest, rmClassID("classForest"));
			rmSetObjectDefMinDistance(dryForest, 0);
			rmSetObjectDefMaxDistance(dryForest, rmXFractionToMeters(0.45));
			rmAddObjectDefConstraint(dryForest, avoidTradeRoute);
			rmAddObjectDefConstraint(dryForest, avoidSocket);
			rmAddObjectDefConstraint(dryForest, circleConstraint);
			rmAddObjectDefConstraint(dryForest, forestConstraint);
			rmAddObjectDefConstraint(dryForest, avoidTownCenter);  
			rmAddObjectDefConstraint(dryForest, AvoidWaterShort2);  
			rmAddObjectDefConstraint(dryForest, dryAF);
			rmPlaceObjectDefAtLoc(dryForest, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
        }
		

 		int dryHuntsL = rmCreateObjectDef("dryHuntsL");
        rmAddObjectDefItem(dryHuntsL, "ypWaterBuffalo", 2, 4.0);
        rmSetObjectDefMinDistance(dryHuntsL, 0);
        rmSetObjectDefMaxDistance(dryHuntsL, rmXFractionToMeters(0.5));
        rmAddObjectDefConstraint(dryHuntsL, avoidHerdSparse);
        rmAddObjectDefConstraint(dryHuntsL, avoidHuntSparse);
        rmAddObjectDefConstraint(dryHuntsL, avoidTownCenterMore);
        rmAddObjectDefConstraint(dryHuntsL, AvoidWaterLong);
        rmAddObjectDefConstraint(dryHuntsL, forestConstraintShort);
        rmAddObjectDefConstraint(dryHuntsL, circleConstraint);
		rmAddObjectDefConstraint(dryHuntsL, dryAF);
        rmPlaceObjectDefAtLoc(dryHuntsL, 0, 0.0, 0.5, 1*cNumberNonGaiaPlayers);

 		int dryHuntsR = rmCreateObjectDef("dryHuntsR");
        rmAddObjectDefItem(dryHuntsR, "ypWaterBuffalo", 2, 4.0);
        rmSetObjectDefMinDistance(dryHuntsR, 0);
        rmSetObjectDefMaxDistance(dryHuntsR, rmXFractionToMeters(0.5));
        rmAddObjectDefConstraint(dryHuntsR, avoidHerdSparse);
        rmAddObjectDefConstraint(dryHuntsR, avoidHuntSparse);
        rmAddObjectDefConstraint(dryHuntsR, avoidTownCenterMore);
        rmAddObjectDefConstraint(dryHuntsR, AvoidWaterLong);
        rmAddObjectDefConstraint(dryHuntsR, forestConstraintShort);
        rmAddObjectDefConstraint(dryHuntsR, circleConstraint);
		rmAddObjectDefConstraint(dryHuntsR, dryAF);
        rmPlaceObjectDefAtLoc(dryHuntsR, 0, 0.5, 0.0, 1*cNumberNonGaiaPlayers);


		rmSetStatusText("",0.99);

}
 
