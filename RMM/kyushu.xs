/* Durokan's  Ottawa - April 20 2016 Version 1.0*/

	include "mercenaries.xs";
	include "ypAsianInclude.xs";
	include "ypKOTHInclude.xs";

	void main(void) { 
		float playerTiles=20000;
		if (cNumberNonGaiaPlayers > 2)
			playerTiles=19000;
		if (cNumberNonGaiaPlayers > 4)
			playerTiles=18000;
		if (cNumberNonGaiaPlayers > 6)
			playerTiles=17000;

		int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);

		rmSetMapSize(size, size);
		rmSetSeaType("great lakes");
		rmSetSeaLevel(-7);
		rmSetMapType("land");
		rmSetMapType("grass");
		rmSetMapType("Japan");
		rmSetMapType("asia");
		rmTerrainInitialize("grass"); 
		rmSetLightingSet("Saguenay");

		rmSetWorldCircleConstraint(true);
		
		rmDefineClass("classForest");
		rmDefineClass("importantItem");
		rmSetStatusText("",0.01);

		int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
		int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 12.0);
		int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);	
		int avoidTree=rmCreateTypeDistanceConstraint("trees avoid trees", "tree", 45.0);
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
		int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 40.0);	
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0); 
		int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 15.0); 
		int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 4.0);
		int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
		int avoidCastle=rmCreateTypeDistanceConstraint("vs Regicide Castle", "ypCastleRegicide", 5.0);
		
		rmDefineClass("classPlateau");
		int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 5.0);
		rmDefineClass("classAntiTree");
		int avoidAntiTree=rmCreateClassDistanceConstraint("stuff vs. AntiTree", rmClassID("classAntiTree"), 5.0);
		rmDefineClass("classContinent");
		int avoidContinent=rmCreateClassDistanceConstraint("stuff vs. Continent", rmClassID("classContinent"), 5.0);
		
	float teamStartLoc = rmRandFloat(0.0, 1.0);  //This chooses a number randomly between 0 and 1, used to pick whether team 1 is on top or bottom.
  float teamStartRadius = 0.25;
    
  if(cNumberNonGaiaPlayers > 4)
    teamStartRadius = 0.35;

  if (cNumberTeams == 2 ) {
    if (cNumberNonGaiaPlayers == 2) {
      if (teamStartLoc > 0.5) {
        rmSetPlacementTeam(0);
        rmPlacePlayersLine(0.74, 0.74, 0.84, 0.84, 0.1, 0);
          
        rmSetPlacementTeam(1);
        rmPlacePlayersLine(0.26, 0.26, 0.16, 0.16, 0.1, 0);                
      }
      else {
        rmSetPlacementTeam(1);
        rmPlacePlayersLine(0.74, 0.74, 0.84, 0.84, 0.1, 0);    
          
        rmSetPlacementTeam(0);
        rmPlacePlayersLine(0.26, 0.26, 0.16, 0.16, 0.1, 0);                  
      }
    } 
    else {
      //Team 0 starts on top
      if (teamStartLoc > 0.5) {
        rmSetPlacementTeam(0);
        rmSetPlayerPlacementArea(0.5, 0.5, 0.86, 0.86);    
        rmPlacePlayersCircular(teamStartRadius, teamStartRadius, 0); 
      
        rmSetPlacementTeam(1);
        rmSetPlayerPlacementArea(0.5, 0.5, 0.14, 0.14);    
        rmPlacePlayersCircular(teamStartRadius, teamStartRadius, 0); 
      }
      else {
        rmSetPlacementTeam(0);
        rmSetPlayerPlacementArea(0.5, 0.5, 0.14, 0.14);    
        rmPlacePlayersCircular(teamStartRadius, teamStartRadius, 0); 
          
        rmSetPlacementTeam(1);
        rmSetPlayerPlacementArea(0.5, 0.5, 0.86, 0.86);    
        rmPlacePlayersCircular(teamStartRadius, teamStartRadius, 0); 
      }     
    }
  }

	// otherwise FFA
	else
	{
			rmPlacePlayersCircular(0.3, 0.3, 0.00);
	}

		chooseMercs();
		rmSetStatusText("",0.1);

		int continent = rmCreateArea("big huge continent");
		rmAddAreaToClass(continent, rmClassID("classContinent"));
		rmSetAreaSize(continent, 0.9, 0.9);
		rmSetAreaLocation(continent, 0.5, 0.5);
		rmSetAreaTerrainType(continent, "forest\ground_grass1_forest");
		rmSetAreaMix(continent, "korea_a");
		rmSetAreaBaseHeight(continent, 8);
		rmSetAreaCoherence(continent, 1.0);
		//rmAddAreaInfluenceSegment(continent, 0.0, 0.25, 1.0, 0.25); 
		rmSetAreaSmoothDistance(continent, 1);
		rmSetAreaElevationEdgeFalloffDist(continent, 10);
		rmSetAreaElevationVariation(continent, 5);
		rmSetAreaElevationPersistence(continent, 0.5);
		rmSetAreaElevationOctaves(continent, 5);
		rmSetAreaElevationMinFrequency(continent, 0.01);
		rmSetAreaElevationType(continent, cElevTurbulence);   
		rmSetAreaObeyWorldCircleConstraint(continent, false);
		rmBuildArea(continent);
		
		int blobsAntiTreeCount = 9;
				
		for(i=i; < blobsAntiTreeCount) { 
		int blobAntiTree = rmCreateArea("top left center basin left ramp"+i);
		rmAddAreaToClass(blobAntiTree, rmClassID("classAntiTree"));
		//rmSetAreaTerrainType(blobAntiTree, "forest\ground_grass1_forest");
		rmSetAreaSize(blobAntiTree, 0.0044, 0.0044);
		rmSetAreaCoherence(blobAntiTree, .75);
		if(i == 1){
		rmSetAreaSize(blobAntiTree, 0.1, 0.1);
		rmSetAreaLocation(blobAntiTree, 0.2, 0.2);
		}else if(i == 2){
		rmSetAreaSize(blobAntiTree, 0.1, 0.1);
		rmSetAreaLocation(blobAntiTree, 0.8, 0.8);
		}else if(i == 3){
		rmSetAreaSize(blobAntiTree, 0.17, 0.17);
		rmSetAreaLocation(blobAntiTree, 0.7, 0.7);
		}else if(i == 4){
		rmSetAreaSize(blobAntiTree, 0.17, 0.17);
		rmSetAreaLocation(blobAntiTree, 0.3, 0.3);
		}else if(i == 5){
		rmSetAreaSize(blobAntiTree, 0.1, 0.1);
		rmSetAreaLocation(blobAntiTree, 0.2, 0.2);
		rmAddAreaInfluenceSegment(blobAntiTree, 0.2, 0.2, .2, 0.8); 
		}else if(i == 6){
		rmSetAreaSize(blobAntiTree, 0.1, 0.1);
		rmSetAreaLocation(blobAntiTree, 0.8, 0.8);
		rmAddAreaInfluenceSegment(blobAntiTree, 0.8, 0.8, .2, 0.8); 
		}else if(i == 7){
		rmSetAreaSize(blobAntiTree, 0.1, 0.1);
		rmSetAreaLocation(blobAntiTree, 0.8, 0.8);
		rmAddAreaInfluenceSegment(blobAntiTree, 0.8, 0.8, .8, 0.2); 
		}else if(i == 8){
		rmSetAreaSize(blobAntiTree, 0.1, 0.1);
		rmSetAreaLocation(blobAntiTree, 0.2, 0.2);
		rmAddAreaInfluenceSegment(blobAntiTree, 0.2, 0.2, .8, 0.2); 
		}else{
		rmSetAreaSize(blobAntiTree, 0.1, 0.1);
		rmSetAreaLocation(blobAntiTree, 0.2, 0.2);
		rmAddAreaInfluenceSegment(blobAntiTree, 0.2, 0.2, .2, 0.8); 
		}
		rmBuildArea(blobAntiTree); 
		}

		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
		rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socketID, true);
		rmSetObjectDefMinDistance(socketID, 0.0);
		rmSetObjectDefMaxDistance(socketID, 6.0);

		int tradeRouteID = rmCreateTradeRoute();
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

		rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 1.0);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.5, 4, 5);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 1.0, 0.0, 4, 5);

		rmBuildTradeRoute(tradeRouteID, "water");

		vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.4);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.6);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

		rmSetStatusText("",0.3);

		int classPatch = rmDefineClass("patch");
		int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 22.0);
		int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));

				
		int cliffCount = 4;
				i = 0;
		for(i=i; < cliffCount) { 
		int cliffs = rmCreateArea("cliffs"+i);
		rmSetAreaSize(cliffs, 0.02, 0.02); 
		rmAddAreaToClass(cliffs, rmClassID("classPlateau"));
		//rmAddAreaTerrainReplacement(cliffs, "texas\ground4_tex", "california\ground9_cal");//idk why cali works, dont touch it
		rmSetAreaCliffType(cliffs, "Korea");
		rmSetAreaCliffEdge(cliffs, 2, .25, 0.0, 0.0, 2); //4,.25 looks cool too
		rmSetAreaCliffPainting(cliffs, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(cliffs, 3, 0.1, 0.5);
		rmSetAreaCoherence(cliffs, .92);
		if(i == 1){
		rmSetAreaLocation(cliffs, .35, .85);
		rmAddAreaInfluenceSegment(cliffs, 0.35, 0.85, 0.45, 0.75);
		}else if(i == 2){
		rmSetAreaLocation(cliffs, .15, .65);
		rmAddAreaInfluenceSegment(cliffs, 0.15, 0.65, 0.25, 0.55);
		}else if(i == 3){
		rmSetAreaLocation(cliffs, .85, .35);
		rmAddAreaInfluenceSegment(cliffs, 0.85, 0.35, 0.75, 0.45);
		}else{
		rmSetAreaLocation(cliffs, .65, .15);
		rmAddAreaInfluenceSegment(cliffs, 0.65, 0.15, 0.55, 0.25);
		}
		rmBuildArea(cliffs);	
		}
		
	int specialTowers = rmCreateObjectDef("ypOutpostAsian for Durokan");
	rmAddObjectDefItem(specialTowers, "ypOutpostAsianRM", 1, 1.0);
	rmSetObjectDefMinDistance(specialTowers, 0.0);
	rmSetObjectDefMaxDistance(specialTowers, 0.0);
	rmPlaceObjectDefAtLoc(specialTowers, 0, 0.4, 0.8);
	rmPlaceObjectDefAtLoc(specialTowers, 0, 0.2, 0.6);
	rmPlaceObjectDefAtLoc(specialTowers, 0, 0.8, 0.4);
	rmPlaceObjectDefAtLoc(specialTowers, 0, 0.6, 0.2);

	int startBannerID = rmCreateObjectDef("war banners");
	rmAddObjectDefItem(startBannerID, "ypPropsJapaneseBanner", 1, 1.0);
	rmSetObjectDefMinDistance(startBannerID, 3.0);
	rmSetObjectDefMaxDistance(startBannerID, 6.0);
	rmPlaceObjectDefAtLoc(startBannerID, 0, 0.4, 0.8);
	rmPlaceObjectDefAtLoc(startBannerID, 0, 0.2, 0.6);
	rmPlaceObjectDefAtLoc(startBannerID, 0, 0.8, 0.4);
	rmPlaceObjectDefAtLoc(startBannerID, 0, 0.6, 0.2);
		
/*
		int rampNumbers = 8;
				
		for(i=i; < rampNumbers) { 
		int rampLarge = rmCreateArea("top left center basin left ramp"+i);
		//rmAddAreaTerrainReplacement(rampLarge, "saguenay\ground3_sag", "amazon\river1_am");
		rmSetAreaSize(rampLarge, 0.0044, 0.0044);
		rmSetAreaBaseHeight(rampLarge, -3.6);
		rmSetAreaSmoothDistance(rampLarge, -8);
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
		}*/
						

		rmSetStatusText("",0.4);


		int playerStart = rmCreateStartingUnitsObjectDef(5.0);
		rmSetObjectDefMinDistance(playerStart, 7.0);
		rmSetObjectDefMaxDistance(playerStart, 12.0);
				
	rmSetStatusText("",0.5);

		int berryID = rmCreateObjectDef("starting berries"); 
		rmAddObjectDefItem(berryID, "BerryBush", 4, 6.0); 
		rmSetObjectDefMinDistance(berryID, 10.0); 
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

		int foodID = rmCreateObjectDef("starting hunt1"); 
		rmAddObjectDefItem(foodID, "SikaDeer", 7, 12.0); 
		rmSetObjectDefMinDistance(foodID, 10.0); 
		rmSetObjectDefMaxDistance(foodID, 14.0); 	
		rmAddObjectDefConstraint(foodID, circleConstraint);
		rmSetObjectDefCreateHerd(foodID, false);

		int foodID2 = rmCreateObjectDef("starting hunt2"); 
		rmAddObjectDefItem(foodID2, "SikaDeer", 7, 13.0); 
		rmSetObjectDefMinDistance(foodID2, 38.0); 
		rmSetObjectDefMaxDistance(foodID2, 40.0); 
		rmAddObjectDefConstraint(foodID2, circleConstraint);
		rmSetObjectDefCreateHerd(foodID2, true);
		

  int playerCastle=rmCreateObjectDef("Castle");
  rmAddObjectDefItem(playerCastle, "ypCastleRegicide", 1, 0.0);
  rmAddObjectDefConstraint(playerCastle, avoidAll);
  rmAddObjectDefConstraint(playerCastle, avoidImpassableLand);
	rmSetObjectDefMinDistance(playerCastle, 18.0);	
	rmSetObjectDefMaxDistance(playerCastle, 23.0);
  
  int playerWalls = rmCreateGrouping("regicide walls", "regicide_walls");
  rmAddGroupingToClass(playerWalls, rmClassID("importantItem"));
  rmSetGroupingMinDistance(playerWalls, 0.0);
  rmSetGroupingMaxDistance(playerWalls, 2.0);
  
  int playerDaimyo=rmCreateObjectDef("Daimyo"+i);
  rmAddObjectDefItem(playerDaimyo, "ypDaimyoRegicide", 1, 0.0);
  rmAddObjectDefConstraint(playerDaimyo, avoidAll);
  rmSetObjectDefMinDistance(playerDaimyo, 7.0);	
  rmSetObjectDefMaxDistance(playerDaimyo, 10.0);


		rmSetStatusText("",0.6);

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
		rmPlaceObjectDefAtLoc(playerDaimyo, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if (rmGetNomadStart() == false)
		{
		rmPlaceGroupingAtLoc(playerWalls, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		}

		rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	  }
	  	if (cNumberNonGaiaPlayers==2){
		int cornerMines = rmCreateObjectDef(" cornerMines");
		rmAddObjectDefItem(cornerMines, "mine", 1, 1.0);
		rmSetObjectDefMinDistance(cornerMines, 0.0);
		rmSetObjectDefMaxDistance(cornerMines, rmXFractionToMeters(0.01));
		rmAddObjectDefConstraint(cornerMines, circleConstraint);
		rmPlaceObjectDefAtLoc(cornerMines, 0, 0.4, 0.85, 1);   
		rmPlaceObjectDefAtLoc(cornerMines, 0, 0.6, 0.15, 1);   
		rmPlaceObjectDefAtLoc(cornerMines, 0, 0.25, 0.55, 1);   
		rmPlaceObjectDefAtLoc(cornerMines, 0, 0.75, 0.45, 1);   

		int elkHunts = rmCreateObjectDef("elkHunts");
		rmAddObjectDefItem(elkHunts, "ypSerow", rmRandInt(9,10), 10.0);
		rmSetObjectDefCreateHerd(elkHunts, true);
		rmSetObjectDefMinDistance(elkHunts, 0);
		rmSetObjectDefMaxDistance(elkHunts, rmXFractionToMeters(0.01));
		rmAddObjectDefConstraint(elkHunts, circleConstraint);	
		rmPlaceObjectDefAtLoc(elkHunts, 0, 0.475, 0.725, 1);   
		rmPlaceObjectDefAtLoc(elkHunts, 0, 0.525, 0.275, 1);   
		rmPlaceObjectDefAtLoc(elkHunts, 0, 0.15, 0.65, 1);
		rmPlaceObjectDefAtLoc(elkHunts, 0, 0.85, 0.35, 1);

		rmSetStatusText("",0.7);

		int cornerNugget= rmCreateObjectDef("corner nugs"); 
		rmAddObjectDefItem(cornerNugget, "Nugget", 1, 0.0); 
		rmSetObjectDefMinDistance(cornerNugget, 0.0); 
		rmSetObjectDefMaxDistance(cornerNugget, rmXFractionToMeters(0.01)); 
		rmAddObjectDefConstraint(cornerNugget, circleConstraint);
		rmAddObjectDefConstraint(cornerNugget, avoidSocket);
		rmSetNuggetDifficulty(3, 3); //level 3 nuggets go in the center
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.53, 0.53, 1);   
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.47, 0.47, 1);   
		rmSetNuggetDifficulty(2, 2); //level 2 nuggets go on the equator but far away from the center
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.35, 0.84, 1);   
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.65, 0.16, 1);   
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.19, 0.62, 1);   
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.81, 0.38, 1);   
		rmSetNuggetDifficulty(1, 1); //level 1 nuggets go around the tc in a triangle shape
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.83, 0.83, 1);   
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.17, 0.17, 1);   
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.25, 0.35, 1);   
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.65, 0.75, 1); 
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.35, 0.25, 1);   
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.75, 0.65, 1); 
		}else{
		int nuggetID= rmCreateObjectDef("nuggets"); 
		rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
		rmSetObjectDefMinDistance(nuggetID, 0.0); 
		rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5)); 
		rmAddObjectDefConstraint(nuggetID, avoidNugget); 
		rmAddObjectDefConstraint(nuggetID, circleConstraint);
		rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
		rmAddObjectDefConstraint(nuggetID, forestConstraintShort);
		rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(nuggetID, avoidSocket); 
		rmSetNuggetDifficulty(1, 2); 
		rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);   

		int islandminesID = rmCreateObjectDef("island silver");
		rmAddObjectDefItem(islandminesID, "mine", 1, 1.0);
		rmSetObjectDefMinDistance(islandminesID, 0.0);
		rmSetObjectDefMaxDistance(islandminesID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(islandminesID, avoidCoinMed);
		rmAddObjectDefConstraint(islandminesID, avoidTownCenterMore);
		rmAddObjectDefConstraint(islandminesID, avoidSocket);
		rmAddObjectDefConstraint(islandminesID, forestConstraintShort);
		rmAddObjectDefConstraint(islandminesID, circleConstraint);
		rmPlaceObjectDefAtLoc(islandminesID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);

		int pronghornHunts = rmCreateObjectDef("pronghornHunts");
		rmAddObjectDefItem(pronghornHunts, "ypSerow", rmRandInt(7,8), 14.0);
		rmSetObjectDefCreateHerd(pronghornHunts, true);
		rmSetObjectDefMinDistance(pronghornHunts, 0);
		rmSetObjectDefMaxDistance(pronghornHunts, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(pronghornHunts, circleConstraint);
		rmAddObjectDefConstraint(pronghornHunts, avoidTownCenterMore);
		rmAddObjectDefConstraint(pronghornHunts, avoidHunt);
		rmAddObjectDefConstraint(pronghornHunts, forestConstraintShort);
		rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);

		rmSetStatusText("",0.8);

		int randomTrees = rmCreateObjectDef("random Trees");
		rmAddObjectDefItem(randomTrees, "ypTreeCoastalJapan", rmRandInt(2,3), 3);
		rmSetObjectDefMinDistance(randomTrees, 0);
		rmSetObjectDefMaxDistance(randomTrees, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(randomTrees, circleConstraint);
		rmAddObjectDefConstraint(randomTrees, avoidTownCenterMore);
		rmAddObjectDefConstraint(randomTrees, avoidCoin);
		rmAddObjectDefConstraint(randomTrees, avoidSocket);
		rmAddObjectDefConstraint(randomTrees, avoidTree);
		rmAddObjectDefConstraint(randomTrees, forestConstraint);
		rmPlaceObjectDefAtLoc(randomTrees, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers);
		}

			for (j=0; < (4*cNumberNonGaiaPlayers)) {   
			int StartAreaTree2ID=rmCreateObjectDef("trees"+j);
			rmAddObjectDefItem(StartAreaTree2ID, "ypTreeCoastalJapan", rmRandInt(14,18), rmRandFloat(12.0,14.0));
			rmAddObjectDefItem(StartAreaTree2ID, "UnderbrushForest", rmRandInt(8,10), 12.0);
			rmAddObjectDefToClass(StartAreaTree2ID, rmClassID("classForest")); 
			rmSetObjectDefMinDistance(StartAreaTree2ID, 0);
			rmSetObjectDefMaxDistance(StartAreaTree2ID, rmXFractionToMeters(0.52));
			rmAddObjectDefConstraint(StartAreaTree2ID, forestConstraint);
			rmAddObjectDefConstraint(StartAreaTree2ID, avoidTradeRoute);
			rmAddObjectDefConstraint(StartAreaTree2ID, avoidNuggetSmall);
			rmAddObjectDefConstraint(StartAreaTree2ID, avoidAntiTree); 
			rmPlaceObjectDefAtLoc(StartAreaTree2ID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);

			int forestgroundS = rmCreateArea("forest ground south");
			rmAddAreaToClass(forestgroundS, rmClassID("classForest"));
			rmSetAreaSize(forestgroundS, 0.025, 0.025);
			rmSetAreaLocation(forestgroundS, 0.41, 0.41);
			rmSetAreaTerrainType(forestgroundS, "forest\ground_grass4_forest");
			rmSetAreaCoherence(forestgroundS, 0.7);
			rmSetAreaSmoothDistance(forestgroundS, 1);
			rmBuildArea(forestgroundS);

			int forestgroundN = rmCreateArea("forest ground north");
			rmAddAreaToClass(forestgroundN, rmClassID("classForest"));
			rmSetAreaSize(forestgroundN, 0.025, 0.025);
			rmSetAreaLocation(forestgroundN, 0.59, 0.59);
			rmSetAreaTerrainType(forestgroundN, "forest\ground_grass4_forest");
			rmSetAreaCoherence(forestgroundN, 0.7);
			rmSetAreaSmoothDistance(forestgroundN, 1);
			rmBuildArea(forestgroundN);
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
   

  // Regicide Triggers
	for(i=1; <= cNumberNonGaiaPlayers) {
    
    // Lose on Daimyo's death
    rmCreateTrigger("DaimyoDeath"+i);
    rmSwitchToTrigger(rmTriggerID("DaimyoDeath"+i));
    rmSetTriggerPriority(4); 
    rmSetTriggerActive(true);
    rmSetTriggerRunImmediately(true);
    rmSetTriggerLoop(false);
    
    rmAddTriggerCondition("Is Dead");
    rmSetTriggerConditionParamInt("SrcObject", rmGetUnitPlacedOfPlayer(playerDaimyo, i), false);
    
    rmAddTriggerEffect("Set Player Defeated");
    rmSetTriggerEffectParamInt("Player", i, false);
    
    // Setup Bastion
    //~ rmCreateTrigger("Bastion"+i);
    //~ rmSwitchToTrigger(rmTriggerID("Bastion"+i));
    //~ rmSetTriggerPriority(3); 
    //~ rmSetTriggerActive(true);
    //~ rmSetTriggerRunImmediately(true);
    //~ rmSetTriggerLoop(false);
    
    //~ rmAddTriggerCondition("Always");
    
    //~ rmAddTriggerEffect("Set Tech Status");
    //~ rmSetTriggerEffectParamInt("PlayerID", i, false);
    //~ rmSetTriggerEffectParam("TechID", "236", false);
    //~ rmSetTriggerEffectParam("Status", "2", false);
  }


   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .05, 0);
   }

		
		rmSetStatusText("", 0.99);

	}


	