	/* Durokan's acropolis - Feb 11 2016 1.0 -- --*/
	include "mercenaries.xs";
	include "ypAsianInclude.xs";
	include "ypKOTHInclude.xs";
 
	void main(void) {
	
   rmSetStatusText("",0.01);

	int playerTiles = 20000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 18000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 16000;			

  int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
  rmEchoInfo("Map size="+size+"m x "+size+"m");
  rmSetMapSize(size, size);
  
        rmSetMapType("land");
        rmSetMapType("desert");
        rmSetMapType("deccan");
        rmSetMapType("samerica");
        rmTerrainInitialize("grass");
		rmSetMapElevationParameters(cElevTurbulence, 0.06, 1, 0.4, 3.0);
		rmSetMapElevationHeightBlend(0.6);
		rmSetLightingSet("yucatan");

	rmSetWorldCircleConstraint(true);

  // Init map.
	rmSetBaseTerrainMix("deccan_grass_b");
  rmTerrainInitialize("deccan\ground_grass1_deccan", -4);


    // Paint continent
  int continent=rmCreateArea("continent");
  rmSetAreaSize(continent, 1.0, 1.0);
  rmSetAreaLocation(continent, .5, .5);
  rmSetAreaSmoothDistance(continent, 10);
  rmSetAreaCoherence(continent, 1.0);
  rmSetAreaTerrainType(continent, "deccan\ground_grass1_deccan");
  rmSetAreaMix(continent, "deccan_grass_b");
  rmBuildArea(continent);


    rmDefineClass("classForest");
   int whichVersion = 2;

        int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
        int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.405), rmDegreesToRadians(0), rmDegreesToRadians(360));
        int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
        int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 1.5);
		int forestConstraintHunt=rmCreateClassDistanceConstraint("river hunts vs. forest", rmClassID("classForest"), 15.0);
        int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 50.0);
		int avoidHuntShort=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 10.0);
        int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 8.0);
        int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 60.0);
        int avoidCoinLong=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 75.0);
        int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 6.0);
        int avoidWaterReallyShort = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 1.0);
        int AvoidWaterShort2 = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 15.0);
        int AvoidWaterLong = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 22.0);
        int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("objects avoid trade route", 6);
        int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 4.0);
        int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 5.0);
        int avoidSocketMore=rmCreateClassDistanceConstraint("bigger socket avoidance", rmClassID("socketClass"), 15.0);
        int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 35.0);
        int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
        int avoidTownCenterMedium=rmCreateTypeDistanceConstraint("avoid Town Center medium", "townCenter", 18.0);
        int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 40.0);  
        int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 60.0);
        int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 10.0);
		int AvoidHerdables = rmCreateTerrainDistanceConstraint("avoid herds by something", "herdables", false, 45.0);
		int avoidRush=rmCreateTypeDistanceConstraint("avoid rush by a lot", "AbstractMountain", 75.0);
	
		rmDefineClass("classBase");
		int avoidBase=rmCreateClassDistanceConstraint("stuff vs. base", rmClassID("classBase"), 25.0);
		int avoidBaseLong=rmCreateClassDistanceConstraint("stuff vs. base", rmClassID("classBase"), 125.0);
		
		rmDefineClass("classRoads");
		int avoidRoads=rmCreateClassDistanceConstraint("stuff vs. roads", rmClassID("classRoads"), 11.0);

		rmDefineClass("classCenter");
		int avoidCenter=rmCreateClassDistanceConstraint("stuff vs. center", rmClassID("classCenter"), 5.0);

   rmSetStatusText("",0.20);

        chooseMercs();
		
		  // Player placing  
  
  int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
  
	float spawnSwitch = rmRandFloat(0,1.2);
	
	if (cNumberTeams == 2)	{
	if (spawnSwitch<0.6) {	
		if (cNumberNonGaiaPlayers==2){ 
			rmPlacePlayer(1, 0.75, 0.75); 
			rmPlacePlayer(2, 0.25, 0.25);
		}
		else{
		
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.22, 0.73, 0.7, 0.8, 0, 0); 
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.22, 0.27, 0.7, 0.2, 0, 0);
		}
		  
	}
	else {
		if (cNumberNonGaiaPlayers==2){ 
			rmPlacePlayer(2, 0.75, 0.75); 
			rmPlacePlayer(1, 0.25, 0.25);
		}
		else{		
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.22, 0.73, 0.7, 0.8, 0, 0); 
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.22, 0.27, 0.7, 0.2, 0, 0);
		}
	}
}  else {
    rmPlacePlayersCircular(0.35, 0.35, 0.0);
  }

  // Text
   rmSetStatusText("",0.40);

		 //
 //ground_riverbed_nwt, ground_riverbed2_nwt, cave_ground1, cave_ground2, cave_ground3
//ground_shoreline4_nwt,
//river_shoreline3_pam, wall_deccan
		

		int acropolisMid = rmCreateArea("base plateau mid");
		rmSetAreaSize(acropolisMid, 0.010, 0.010); 
		rmAddAreaToClass(acropolisMid, rmClassID("classBase"));
		rmSetAreaCliffType(acropolisMid, "Deccan Plateau");
		rmSetAreaCliffEdge(acropolisMid, 4, .2, 0.0, 0.0, 4); 
		rmSetAreaCliffPainting(acropolisMid, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(acropolisMid, 4, 0.1, 0.5);
		rmSetAreaCoherence(acropolisMid, .88);
		rmSetAreaLocation(acropolisMid, 0.5, 0.5);
		rmBuildArea(acropolisMid);	

		int fixedGun = rmCreateGrouping("fixed gun", "fixedgun");
		rmSetGroupingMinDistance(fixedGun, 0.0);
		rmSetGroupingMaxDistance(fixedGun, 0.0);
		rmPlaceGroupingAtLoc(fixedGun, 0, 0.495, 0.495);


		int classPatch = rmDefineClass("patch");
		int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 22.0);
		int avoidGrass=rmCreateClassDistanceConstraint("tree vs. grasses", rmClassID("patch"), 1.0);
				
					
        int playerStart = rmCreateStartingUnitsObjectDef(5.0);
        rmSetObjectDefMinDistance(playerStart, 7.0);
        rmSetObjectDefMaxDistance(playerStart, 12.0);
       
        int goldID = rmCreateObjectDef("starting gold");
        rmAddObjectDefItem(goldID, "mine", 1, 3.0);
        rmSetObjectDefMinDistance(goldID, 6.0);
        rmSetObjectDefMaxDistance(goldID, 6.0);

        int goldID2 = rmCreateObjectDef("starting gold2");
        rmAddObjectDefItem(goldID2, "mine", 1, 3.0);
        rmSetObjectDefMinDistance(goldID2, 16.0);
        rmSetObjectDefMaxDistance(goldID2, 16.0);
        
        int berryID = rmCreateObjectDef("starting berries");
        rmAddObjectDefItem(berryID, "BerryBush", 4, 6.0);
        rmSetObjectDefMinDistance(berryID, 8.0);
        rmSetObjectDefMaxDistance(berryID, 12.0);
        rmAddObjectDefConstraint(berryID, avoidCoin);
 
        int treeID = rmCreateObjectDef("starting trees");
        rmAddObjectDefItem(treeID, "ypTreeDeccan", rmRandInt(14,14), 20.0);
        rmSetObjectDefMinDistance(treeID, 12.0);
        rmSetObjectDefMaxDistance(treeID, 18.0);
        rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
        rmAddObjectDefConstraint(treeID, avoidCoin);
        rmAddObjectDefConstraint(treeID, avoidGrass);
 
        int foodID = rmCreateObjectDef("starting hunt");
        rmAddObjectDefItem(foodID, "ypIbex", 8, 8.0);
        rmSetObjectDefMinDistance(foodID, 13.0);
        rmSetObjectDefMaxDistance(foodID, 17.0);
		rmAddObjectDefConstraint(foodID, circleConstraint2);
        rmSetObjectDefCreateHerd(foodID, false);
 
        int foodID2 = rmCreateObjectDef("starting hunt 2");
        rmAddObjectDefItem(foodID2, "ypIbex", 7, 8.0);
        rmSetObjectDefMinDistance(foodID2, 32.0);
        rmSetObjectDefMaxDistance(foodID2, 36.0);
		rmAddObjectDefConstraint(foodID2, circleConstraint2);
        rmSetObjectDefCreateHerd(foodID2, true);

 	int startnuggetID= rmCreateObjectDef("starting nugget"); 
	rmAddObjectDefItem(startnuggetID, "Nugget", 1, 0.0); 
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(startnuggetID, 20.0);
	rmSetObjectDefMaxDistance(startnuggetID, 25.0);
	rmAddObjectDefConstraint(startnuggetID, avoidNuggetSmall); 
	rmAddObjectDefConstraint(startnuggetID, avoidAll);


   rmSetStatusText("",0.60);

        for(i=1; < cNumberNonGaiaPlayers + 1) {
    int id=rmCreateArea("Player"+i);
    rmSetPlayerArea(i, id);
    int startID = rmCreateObjectDef("object"+i);
        rmSetObjectDefMinDistance(startID, 0.0);
        rmSetObjectDefMaxDistance(startID, 2.0);
		if(rmGetNomadStart()){
			rmAddObjectDefItem(startID, "CoveredWagon", 1, 5.0);
		}else{
			rmAddObjectDefItem(startID, "TownCenter", 1, 5.0);
		}
	
    rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(goldID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startnuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
				
		int acropolis = rmCreateArea("base plateau"+i);
		rmSetAreaSize(acropolis, 0.025, 0.025); 
		rmAddAreaToClass(acropolis, rmClassID("classBase"));
		rmSetAreaCliffType(acropolis, "Deccan Plateau");
		rmSetAreaCliffEdge(acropolis, 4, .2, 0.0, 0.0, 4); 
		rmSetAreaCliffPainting(acropolis, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(acropolis, 4, 1.0, 1.0);
		rmSetAreaCoherence(acropolis, .88);
		rmSetAreaLocation(acropolis, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmBuildArea(acropolis);	

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

  }
    	int islandminesID = rmCreateObjectDef("island silver");
	rmAddObjectDefItem(islandminesID, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(islandminesID, 0.0);
	rmSetObjectDefMaxDistance(islandminesID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(islandminesID, avoidCoinMed);
	//rmAddObjectDefConstraint(islandminesID, avoidNatives);
	rmAddObjectDefConstraint(islandminesID, avoidTownCenterMore);
	rmAddObjectDefConstraint(islandminesID, avoidSocket);
	rmAddObjectDefConstraint(islandminesID, avoidBase);
	rmAddObjectDefConstraint(islandminesID, forestConstraintShort);
	rmAddObjectDefConstraint(islandminesID, circleConstraint);
	rmPlaceObjectDefAtLoc(islandminesID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
	
		for (j=0; < (6*cNumberNonGaiaPlayers)) {   
		int StartAreaTree2ID=rmCreateObjectDef("starting trees dirt"+j);
		rmAddObjectDefItem(StartAreaTree2ID, "ypTreeDeccan", rmRandInt(8,10), rmRandFloat(8.0,16.0));
		rmAddObjectDefItem(StartAreaTree2ID, "UnderbrushDeccan", rmRandInt(6,8), 10.0);
		rmSetObjectDefMinDistance(StartAreaTree2ID, 0);
		rmSetObjectDefMaxDistance(StartAreaTree2ID, rmXFractionToMeters(0.45));
	  	rmAddObjectDefConstraint(StartAreaTree2ID, circleConstraint);
		rmAddObjectDefConstraint(StartAreaTree2ID, forestConstraint);
		rmAddObjectDefConstraint(StartAreaTree2ID, avoidBase);
		rmAddObjectDefConstraint(StartAreaTree2ID, avoidTownCenter);	
		rmPlaceObjectDefAtLoc(StartAreaTree2ID, 0, 0.5, 0.5, 5);
	}
		

		int nuggetRows = 0;
		float nuggetX = 0.5;
		float nuggetZ = 0.0;
		float nuggetZmod = 0.1;

		for (nuggetRows = 0; < (5)) {  
		int treasures=rmCreateObjectDef("treasures"+nuggetRows);
        rmAddObjectDefItem(treasures, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(treasures, 0);
		rmSetObjectDefMaxDistance(treasures, 0);
		rmSetNuggetDifficulty(2, 3);

		rmPlaceObjectDefAtLoc(treasures, 0, .1, nuggetZ, 1);
		rmPlaceObjectDefAtLoc(treasures, 0, .5, nuggetZ, 1);
		rmPlaceObjectDefAtLoc(treasures, 0, .9, nuggetZ, 1);
		
		rmPlaceObjectDefAtLoc(treasures, 0, .3, nuggetZmod, 1);
		rmPlaceObjectDefAtLoc(treasures, 0, .7, nuggetZmod, 1);
		nuggetZ = nuggetZ + .25;
		nuggetZmod = nuggetZmod + .25;
		}	

		
   rmSetStatusText("",0.80);

  	int rheaxID = rmCreateObjectDef("ibex hunts");
	rmAddObjectDefItem(rheaxID, "ypNilgai", rmRandInt(7,9), 10.0);
	rmSetObjectDefCreateHerd(rheaxID, true);
	rmSetObjectDefMinDistance(rheaxID, 0);
	rmSetObjectDefMaxDistance(rheaxID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rheaxID, circleConstraint);
	rmAddObjectDefConstraint(rheaxID, avoidTownCenterMedium);
	rmAddObjectDefConstraint(rheaxID, avoidHunt);
	rmAddObjectDefConstraint(rheaxID, avoidBase);
	rmPlaceObjectDefAtLoc(rheaxID, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);

        /*
        int herdableID=rmCreateObjectDef("cows");
        rmAddObjectDefItem(herdableID, "cow", 2, 4.0);
        rmSetObjectDefMinDistance(herdableID, 0.0);
        rmSetObjectDefMaxDistance(herdableID, rmXFractionToMeters(0.225));
		rmAddObjectDefConstraint(herdableID, AvoidHerdables);
        rmAddObjectDefConstraint(herdableID, circleConstraint);
        rmAddObjectDefConstraint(herdableID, avoidTownCenterMedium);
        rmAddObjectDefConstraint(herdableID, avoidHunt);
        rmPlaceObjectDefAtLoc(herdableID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);*/
	

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.1;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }
	
   rmSetStatusText("",0.99);

}
