/*
==============================
		Cerrado
         by dansil92
==============================
*/


include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script

 
void main(void) {
	rmSetStatusText("",0.01);


   // Picks the map size
	int playerTiles=12000;
	if (cNumberNonGaiaPlayers > 4){
		playerTiles = 11500;
	}else if (cNumberNonGaiaPlayers > 6){
		playerTiles = 10500;
	}

	

	int size = 2.0 * sqrt(cNumberNonGaiaPlayers*playerTiles);
	if (cNumberTeams >= 3){
	size = 2.2 * sqrt(cNumberNonGaiaPlayers*playerTiles);
}

	rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.5, 3.0);
	rmSetMapElevationHeightBlend(1);

	rmSetMapSize(size, size);

	rmSetMapType("land");
        rmSetMapType("desert");
        rmSetMapType("amazonia");
	rmSetMapType("tropical");
	rmSetMapType("samerica");
	rmSetBaseTerrainMix("pampass_grass");
       	rmTerrainInitialize("pampas\ground6_pam");
		rmSetLightingSet("pampas");

	rmSetWorldCircleConstraint(true);

        rmDefineClass("classForest");
		rmDefineClass("classPlateau");
	rmDefineClass("importantItem");
	rmSetSeaLevel(-3.0);
		rmSetSeaType("yucatan Coast");


		//Constraints
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);

		int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 16.0);

        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.45), rmDegreesToRadians(0), rmDegreesToRadians(360));
       
		int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 11.0);
        int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
        
		int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 55.0);
		int avoidHuntSmall=rmCreateTypeDistanceConstraint("avoid hunts", "huntable", 11.0);

		int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 10.0);

        int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 24.0);

		int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 12.0);
        int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 60.0);
        int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 19.0);
        int cliffWater = rmCreateTerrainDistanceConstraint("cliff avoids river", "Land", false, 0.01);
        int cliffWater2 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 1.5);
        int cliffWater3 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 2.5);


        int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 8.0);
        int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 25.0);
        
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 27.0);
        int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
        int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 52.0);  
       
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 54.0);

  int avoidBerries=rmCreateTypeDistanceConstraint("avoid berries", "berrybush", 50.0);
  int avoidBerriesSmall=rmCreateTypeDistanceConstraint("avoid berries smoll", "berrybush", 8.0);

int stayWest = rmCreatePieConstraint("Stay West",0.47,0.53, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(180),rmDegreesToRadians(0));

int stayEast = rmCreatePieConstraint("Stay East",0.53,0.47, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(180));

   

	
    
 	//========= Player placing========= 
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);


		teamZeroCount = cNumberNonGaiaPlayers/2;
		teamOneCount = cNumberNonGaiaPlayers/2;

    float spawnSwitch = rmRandFloat(0,1.2);


	if (cNumberTeams  == 2){
		if (spawnSwitch <=0.6){

	if (cNumberNonGaiaPlayers == 2)
	{
	rmPlacePlayer(1, 0.225, 0.6);
	rmPlacePlayer(2, 0.775, 0.4);	}

			rmSetPlacementTeam(0);
			rmSetPlacementSection(0.65, 0.9);
			rmPlacePlayersCircular(0.35, 0.35, 0.02);
			rmSetPlacementTeam(1);
			rmSetPlacementSection(0.15, 0.4);
			rmPlacePlayersCircular(0.35, 0.35, 0.02);
		}else if(spawnSwitch <=1.2){

	if (cNumberNonGaiaPlayers == 2)
	{
		rmPlacePlayer(2, 0.225, 0.6);
		rmPlacePlayer(1, 0.775, 0.4);
	}

			rmSetPlacementTeam(1);
			rmSetPlacementSection(0.65, 0.9);
			rmPlacePlayersCircular(0.35, 0.35, 0.02);
			rmSetPlacementTeam(0);
			rmSetPlacementSection(0.15, 0.4);
			rmPlacePlayersCircular(0.35, 0.35, 0.02);

		}
	}else{
	//*************ffa placement********
		rmPlacePlayersCircular(0.27, 0.27, 0.00);
	}

		
        chooseMercs();
        rmSetStatusText("",0.1); 
        int continent2 = rmCreateArea("continent");
        rmSetAreaSize(continent2, 1.0, 1.0);
        rmSetAreaLocation(continent2, 0.5, 0.5);
	   rmSetAreaMix(continent2, "pampass_grass");
        rmSetAreaCoherence(continent2, 1.0);
        rmSetAreaSmoothDistance(continent2, 6);
        rmSetAreaElevationNoiseBias(continent2, 0);
        rmSetAreaElevationEdgeFalloffDist(continent2, 10);
        rmSetAreaElevationVariation(continent2, 8);
        rmSetAreaElevationPersistence(continent2, .2);
        rmSetAreaElevationOctaves(continent2, 5);
        rmSetAreaElevationMinFrequency(continent2, 0.04);
        rmSetAreaElevationType(continent2, cElevTurbulence);  
        rmBuildArea(continent2);    

		int classPatch = rmDefineClass("patch");
		int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 22.0);
		int classCenter = rmDefineClass("center");
		int avoidCenter = rmCreateClassDistanceConstraint("avoid center", rmClassID("center"), 30.0);
		int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
        

int stayLow = rmCreateMaxHeightConstraint("patches stay low", 0.0);

       		for (i=0; < cNumberNonGaiaPlayers*200){
			int patchID = rmCreateArea("first patch"+i);
			rmSetAreaWarnFailure(patchID, false);
			rmSetAreaSize(patchID, rmAreaTilesToFraction(37), rmAreaTilesToFraction(42));
        rmSetAreaTerrainType(patchID, "pampas\ground4_pam");
			rmAddAreaToClass(patchID, rmClassID("patch"));
			rmSetAreaSmoothDistance(patchID, 1.0);
			rmBuildArea(patchID); 
		}

		for (i=0; < cNumberNonGaiaPlayers*125){
			int patchID2 = rmCreateArea("the second patch"+i);
			rmSetAreaWarnFailure(patchID2, false);
			rmSetAreaSize(patchID2, rmAreaTilesToFraction(26), rmAreaTilesToFraction(37));
        rmSetAreaTerrainType(patchID2, "pampas\ground5_pam");
			rmAddAreaToClass(patchID2, rmClassID("patch"));
			rmSetAreaSmoothDistance(patchID2, 1.0);
			rmBuildArea(patchID2); 
}
		rmSetStatusText("",0.2);


//===========trade route=================
		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 6.0);      
       
        int tradeRouteID = rmCreateTradeRoute();

	if (cNumberTeams  == 2){
        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, .01, .01);	    	     rmAddTradeRouteWaypoint(tradeRouteID, .4, .15);
		rmAddTradeRouteWaypoint(tradeRouteID, .5, .5);
		rmAddTradeRouteWaypoint(tradeRouteID, .6, .85);
		rmAddTradeRouteWaypoint(tradeRouteID, .99, .99);
        rmBuildTradeRoute(tradeRouteID, "dirt");
 
        vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.3);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
            socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.7);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

            socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);   


}else{

//ffa circular TP

        tradeRouteID = rmCreateTradeRoute();
        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.08, 0.55); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.20, 0.83); 	rmAddTradeRouteWaypoint(tradeRouteID, 0.45, 0.93); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.67, 0.89); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.78, 0.78); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.84, 0.70);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.86, 0.68);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.88, 0.40); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.81, 0.23); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.70, 0.10); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.08);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.30, 0.15); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.15, 0.23); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.08, 0.55); 
        rmBuildTradeRoute(tradeRouteID, "dirt");

	vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);
	socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID, 0.45);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);
	socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID, 0.7);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);
	socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID, 0.95);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);



}


		rmSetStatusText("",0.3);


// ******KEEP BUILDABLE LAND UNDER TCS ******

for(i=1; < cNumberNonGaiaPlayers + 1) {

    int PlayerArea1 = rmCreateArea("NeedLand1"+i);
        rmSetAreaSize(PlayerArea1, .027, .028);
		rmAddAreaToClass(PlayerArea1, rmClassID("classCenter"));
        rmSetAreaLocation(PlayerArea1, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmSetAreaSmoothDistance(PlayerArea1, 6);
        rmSetAreaHeightBlend(PlayerArea1, 2);
        rmSetAreaCoherence(PlayerArea1, 0.8);
        rmBuildArea(PlayerArea1);
}

 

		rmSetStatusText("",0.4);
		//starting objects

	int flagLand = rmCreateTerrainDistanceConstraint("flags dont like land", "land", true, 3.0);


		
        int playerStart = rmCreateStartingUnitsObjectDef(5.0);
        rmSetObjectDefMinDistance(playerStart, 6.0);
        rmSetObjectDefMaxDistance(playerStart, 12.0);
	rmAddObjectDefConstraint(playerStart, avoidWaterShort);

       
        int goldID = rmCreateObjectDef("starting gold");
        rmAddObjectDefItem(goldID, "mine", 1, 3.0);
        rmSetObjectDefMinDistance(goldID, 20.0);
        rmSetObjectDefMaxDistance(goldID, 22.0);
        rmAddObjectDefConstraint(goldID, avoidCoin);

    
        int goldID2 = rmCreateObjectDef("starting gold 1v1");
        rmAddObjectDefItem(goldID2, "mine", 1, 1.0);
        rmSetObjectDefMinDistance(goldID2, 0.0);
        rmSetObjectDefMaxDistance(goldID2, 2.0);
   


        int berryID = rmCreateObjectDef("starting berries");
        rmAddObjectDefItem(berryID, "BerryBush", 5, 4.0);
        rmSetObjectDefMinDistance(berryID, 13.0);
        rmSetObjectDefMaxDistance(berryID, 15.0);
        rmAddObjectDefConstraint(berryID, avoidCoin);
 
        int treeID = rmCreateObjectDef("starting trees");
        rmAddObjectDefItem(treeID, "TreeTexas", rmRandInt(6,7), 7.0);
        rmSetObjectDefMinDistance(treeID, 19.0);
        rmSetObjectDefMaxDistance(treeID, 21.0);
        rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
        rmAddObjectDefConstraint(treeID, avoidCoin);
 
        int foodID = rmCreateObjectDef("starting hunt");
        rmAddObjectDefItem(foodID, "capybara", 8, 8.0);
        rmSetObjectDefMinDistance(foodID, 14.0);
        rmSetObjectDefMaxDistance(foodID, 16.0);
	rmAddObjectDefConstraint(foodID, avoidCoin);	
        rmSetObjectDefCreateHerd(foodID, false);
 
        int foodID2 = rmCreateObjectDef("starting hunt 2");
        rmAddObjectDefItem(foodID2, "tapir", 7, 8.0);
        rmSetObjectDefMinDistance(foodID2, 20.0);
        rmSetObjectDefMaxDistance(foodID2, 22.0);
	rmAddObjectDefConstraint(foodID2, avoidHuntSmall);	
        rmSetObjectDefCreateHerd(foodID2, true);
        rmAddObjectDefConstraint(foodID2, avoidCoin);

                       
		int foodID3 = rmCreateObjectDef("starting hunt 3");
        rmAddObjectDefItem(foodID3, "guanaco", 8, 8.0);
        rmSetObjectDefMinDistance(foodID3, 38.0);
        rmSetObjectDefMaxDistance(foodID3, 40.0);
	rmAddObjectDefConstraint(foodID3, avoidWaterShort);	
        rmSetObjectDefCreateHerd(foodID3, true);


  int playerCrateID=rmCreateObjectDef("bonus starting crates");
  rmAddObjectDefItem(playerCrateID, "crateOfFood", 1, 2.0);
  rmSetObjectDefMinDistance(playerCrateID, 10);
  rmSetObjectDefMaxDistance(playerCrateID, 12);
	rmAddObjectDefConstraint(playerCrateID, avoidCoin);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmSetNuggetDifficulty(1, 1); 
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 3.0);
    rmSetObjectDefMinDistance(playerNuggetID, 29.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 31.0);
rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
//rmAddObjectDefConstraint(playerNuggetID, avoidTree);
rmAddObjectDefConstraint(playerNuggetID, avoidCoin);


	if (cNumberNonGaiaPlayers == 2){

        rmPlaceObjectDefAtLoc(goldID2, 0, 0.17, 0.6, 1 );
        rmPlaceObjectDefAtLoc(goldID2, 0, 0.83, 0.4, 1 );

}


		rmSetStatusText("",0.5);  


  // Regicide objects
  int playerCastle=rmCreateObjectDef("Castle");
  rmAddObjectDefItem(playerCastle, "ypCastleRegicide", 1, 0.0);
  rmAddObjectDefConstraint(playerCastle, avoidAll);
  rmAddObjectDefConstraint(playerCastle, avoidImpassableLand);
  rmSetObjectDefMinDistance(playerCastle, 17.0);	
  rmSetObjectDefMaxDistance(playerCastle, 21.0);

  int playerWalls = rmCreateGrouping("regicide walls", "regicide_walls2");
  rmAddGroupingToClass(playerWalls, rmClassID("importantItem"));
  rmSetGroupingMinDistance(playerWalls, 0.0);
  rmSetGroupingMaxDistance(playerWalls, 3.0);

  int playerDaimyo=rmCreateObjectDef("Daimyo"+i);
  rmAddObjectDefItem(playerDaimyo, "ypDaimyoRegicide", 1, 0.0);
  rmAddObjectDefConstraint(playerDaimyo, avoidAll);
  rmSetObjectDefMinDistance(playerDaimyo, 7.0);	
  rmSetObjectDefMaxDistance(playerDaimyo, 10.0);

    
    for(i=1; < cNumberNonGaiaPlayers + 1) {
		int id=rmCreateArea("Player"+i);
		rmSetPlayerArea(i, id);
		int startID = rmCreateObjectDef("object"+i);
		if(rmGetNomadStart()){
			rmAddObjectDefItem(startID, "CoveredWagon", 1, 2.0);
		}else{
			rmAddObjectDefItem(startID, "TownCenter", 1, 2.0);
		}
		rmSetObjectDefMinDistance(startID, 0.0);
        rmSetObjectDefMaxDistance(startID, 5.0);
		rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

      rmPlaceObjectDefAtLoc(playerDaimyo, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceGroupingAtLoc(playerWalls, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(playerCastle, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

        rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	if (cNumberNonGaiaPlayers >= 3)
	{
        rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}
        rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(berryID , i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerCrateID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

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



  	int eastmine = rmCreateObjectDef("east mines");
	rmAddObjectDefItem(eastmine, "mine", 1, 1.0);
	rmAddObjectDefConstraint(eastmine, circleConstraint);
	rmAddObjectDefConstraint(eastmine, avoidWaterShort);

	if (cNumberNonGaiaPlayers == 2)
	{
	rmSetObjectDefMinDistance(eastmine, 0);
	rmSetObjectDefMaxDistance(eastmine, 3);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.25, 0.75, 1);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.5, 0.875, 1);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.75, 0.75, 1);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.875, 0.55, 1);

	rmPlaceObjectDefAtLoc(eastmine, 0, 0.125, 0.45, 1);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.25, 0.25, 1);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.5, 0.125, 1);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.75, 0.25, 1);


	rmPlaceObjectDefAtLoc(eastmine, 0, 0.4, 0.6, 1);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.6, 0.4, 1);

}else{

	rmSetObjectDefMinDistance(eastmine, rmXFractionToMeters(0.2));
	rmSetObjectDefMaxDistance(eastmine, rmXFractionToMeters(0.42));
	rmAddObjectDefConstraint(eastmine, avoidCoinMed);
	rmAddObjectDefConstraint(eastmine, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(eastmine, avoidPlateau);	
	rmAddObjectDefConstraint(eastmine, avoidTownCenter);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);
}
	
    int tapirsForDays = rmCreateObjectDef("tapirsForDays");
	rmAddObjectDefItem(tapirsForDays, "guanaco", rmRandInt(7,8), 7.0);
	rmSetObjectDefCreateHerd(tapirsForDays, true);
	rmSetObjectDefMinDistance(tapirsForDays, 0);
	rmSetObjectDefMaxDistance(tapirsForDays, rmXFractionToMeters(0.43));
	rmAddObjectDefConstraint(tapirsForDays, circleConstraint);
//	rmAddObjectDefConstraint(tapirsForDays, avoidTownCenterMore);
	rmAddObjectDefConstraint(tapirsForDays, avoidHunt);
//	rmAddObjectDefConstraint(tapirsForDays, avoidBerries);
//	rmAddObjectDefConstraint(tapirsForDays, stayLow);
	rmAddObjectDefConstraint(tapirsForDays, avoidWaterShort);	
	rmAddObjectDefConstraint(tapirsForDays, avoidCoin);	
	rmPlaceObjectDefAtLoc(tapirsForDays, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);


  	int berryspam = rmCreateObjectDef("so many berries");
	rmAddObjectDefItem(berryspam, "BerryBush", rmRandInt(5,5), 4.0);
	rmSetObjectDefMinDistance(berryspam, 0.0);
	rmSetObjectDefMaxDistance(berryspam, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(berryspam, avoidHuntSmall);	
	rmAddObjectDefConstraint(berryspam, circleConstraint);
	rmAddObjectDefConstraint(berryspam, avoidTownCenter);
	rmAddObjectDefConstraint(berryspam, avoidBerries);
	rmAddObjectDefConstraint(berryspam, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(berryspam, avoidCoin);	
	rmPlaceObjectDefAtLoc(berryspam, 0, 0.5, 0.5, 18*cNumberNonGaiaPlayers);



	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenterMore);
	rmAddObjectDefConstraint(nuggetID, forestConstraintShort);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(nuggetID, avoidBerriesSmall); 
	rmAddObjectDefConstraint(nuggetID, avoidPlateau);
	rmAddObjectDefConstraint(nuggetID, avoidWaterShort);	
	rmAddObjectDefConstraint(nuggetID, avoidCoin);	
	rmSetNuggetDifficulty(2, 3); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);   


	rmSetStatusText("",0.7);



//==========hills==============

	for (j=0; < (9*cNumberNonGaiaPlayers)) {   
			int islandW = rmCreateArea("islandW"+j);
        rmSetAreaSize(islandW, rmAreaTilesToFraction(300), rmAreaTilesToFraction(700));
		rmAddAreaToClass(islandW, rmClassID("classCenter"));
	rmAddAreaConstraint(islandW, avoidCenter);
	rmAddAreaConstraint(islandW, avoidTradeRouteSmall);
	rmAddAreaConstraint(islandW, avoidTownCenter);
	rmAddAreaConstraint(islandW, avoidCoin);
        rmSetAreaSmoothDistance(islandW, 8);
        rmSetAreaCoherence(islandW, .75);
        rmBuildArea(islandW);  
	}



	//removes loop for faster loading times
	//for (j=0; < (6*cNumberNonGaiaPlayers)) {   
		int mapTrees=rmCreateObjectDef("map trees");
		rmAddObjectDefItem(mapTrees, "TreePampas", rmRandInt(2,2), rmRandFloat(5.0,6.0));
        rmAddObjectDefItem(mapTrees, "TreeTexas", rmRandInt(1,2), 4.0);
		rmAddObjectDefToClass(mapTrees, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(mapTrees, 0);
		rmSetObjectDefMaxDistance(mapTrees, rmXFractionToMeters(0.47));
		rmAddObjectDefConstraint(mapTrees, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(mapTrees, avoidSocket);
	  	rmAddObjectDefConstraint(mapTrees, avoidCoin);
		rmAddObjectDefConstraint(mapTrees, forestConstraint);
		rmAddObjectDefConstraint(mapTrees, avoidTownCenter);	
		rmAddObjectDefConstraint(mapTrees, avoidPlateau);	
		rmAddObjectDefConstraint(mapTrees, avoidWaterShort);
//	rmAddObjectDefConstraint(mapTrees, circleConstraint);
		rmPlaceObjectDefAtLoc(mapTrees, 0, 0.5, 0.5, 45*cNumberNonGaiaPlayers);
	//}
		rmSetStatusText("",0.8);


	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.5;
		float yLoc = 0.5;
		float walk = 0.05;

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}


// Regicide Trigger
for(i=1; <= cNumberNonGaiaPlayers)
{   
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
    
}


	rmSetStatusText("",0.9);


	}
 
