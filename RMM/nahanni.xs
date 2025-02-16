/*
==============================
		Nahanni
         by dansil92
==============================
*/

// observer UI by Aizamk

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";


// Main entry point for random map script


void main(void) {
	rmSetStatusText("",0.01);


   // Picks the map size
	int playerTiles=13000;
	if (cNumberNonGaiaPlayers > 4){
		playerTiles = 12000;
	}else if (cNumberNonGaiaPlayers > 6){
		playerTiles = 11000;
	}



	int size = 2.0 * sqrt(cNumberNonGaiaPlayers*playerTiles);

	if (cNumberTeams >= 3){
	size = 2.5 * sqrt(cNumberNonGaiaPlayers*playerTiles);
}

	rmSetMapSize(size, size);

	rmSetMapType("land");
        rmSetMapType("grass");
        rmSetMapType("namerica");
	rmSetMapType("northwestTerritory");
	rmSetMapType("AIFishingUseful");
       	rmTerrainInitialize("grass");

	//rmSetWorldCircleConstraint(true);

 	  rmSetGlobalRain( 0.6 );

		rmSetLightingSet("nwterritory");

        rmDefineClass("classForest");
		rmDefineClass("classPlateau");
	rmSetSeaLevel(-5.0);
		rmSetSeaType("New England Coast");


		//Constraints
		int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 16.0);
		int avoidPlateauMore =rmCreateClassDistanceConstraint("stuff vs. cliffs big", rmClassID("classPlateau"), 23.0);

		int avoidPlateauSmall=rmCreateClassDistanceConstraint("stuff vs. cliffs s", rmClassID("classPlateau"), 7.0);


        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.46), rmDegreesToRadians(0), rmDegreesToRadians(360));
       
		int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 27.0);
        int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
        
		int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 50.0);

		int avoidHuntSmall=rmCreateTypeDistanceConstraint("hunts avoid hunts small", "huntable", 30.0);


		int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 10.0);

        int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 24.0);

		int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
		int avoidGold=rmCreateTypeDistanceConstraint("avoid coin gold", "mineGold", 16.0);

		int waterCoin=rmCreateTypeDistanceConstraint("avoid coin smallest", "Mine", 8.0);


        int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 55.0);
        int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 19.0);
        int cliffWater = rmCreateTerrainDistanceConstraint("cliff avoids river", "Land", false, 0.01);
        int cliffWater2 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 1.5);
        int cliffWater3 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 2.5);


        int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 9.0);
        int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 25.0);
        
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 30.0);
        int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
        int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 60.0);  
       
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 60.0);

  int avoidBerries=rmCreateTypeDistanceConstraint("avoid berries", "berrybush", 20.0);
  int avoidBerriesSmall=rmCreateTypeDistanceConstraint("avoid berries smoll", "berrybush", 8.0);

	int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);


int stayWest = rmCreatePieConstraint("Stay West",0.47,0.53, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(180),rmDegreesToRadians(0));

int stayEast = rmCreatePieConstraint("Stay East",0.53,0.47, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(180));

int stayNorth = rmCreatePieConstraint("Stay North",0.30,0.30, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(90),rmDegreesToRadians(270));

int staySouth = rmCreatePieConstraint("Stay South",0.70,0.70, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(270),rmDegreesToRadians(90));
   

    
 // =============Player placement ======================= 



	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);


    float spawnSwitch = rmRandFloat(0,1.2);
//spawnSwitch = 0.1;


	if (cNumberTeams == 2){
		if (spawnSwitch <=0.6){

	if (cNumberNonGaiaPlayers == 2)
	{
	rmPlacePlayer(1, 0.25, 0.75);
	rmPlacePlayer(2, 0.75, 0.25);	}

			rmSetPlacementTeam(0);
		rmSetPlayerPlacementArea(0.1, 0.6, 0.4, 0.9);
			rmPlacePlayersCircular(0.3, 0.3, 0.0);
			rmSetPlacementTeam(1);
		rmSetPlayerPlacementArea(0.6, 0.1, 0.9, 0.4);
			rmPlacePlayersCircular(0.3, 0.3, 0.0);

		}else if(spawnSwitch <=1.2){

	if (cNumberNonGaiaPlayers == 2)
	{
		rmPlacePlayer(2, 0.25, 0.75);
		rmPlacePlayer(1, 0.75, 0.25);
	}

			rmSetPlacementTeam(1);
		rmSetPlayerPlacementArea(0.1, 0.6, 0.4, 0.9);
			rmPlacePlayersCircular(0.3, 0.3, 0.0);
			rmSetPlacementTeam(0);
		rmSetPlayerPlacementArea(0.6, 0.1, 0.9, 0.4);
			rmPlacePlayersCircular(0.3, 0.3, 0.0);
		}
	}else{
	//*************ffa placement********
		rmPlacePlayersCircular(0.42, 0.42, 0.00);
	}



        chooseMercs();

        rmSetStatusText("",0.1); 

        int continent2 = rmCreateArea("continent");
        rmSetAreaSize(continent2, 1.0, 1.0);
        rmSetAreaLocation(continent2, 0.5, 0.5);
	   rmSetAreaMix(continent2, "nwt_grass1");
        rmSetAreaBaseHeight(continent2, -5.0);
        rmSetAreaCoherence(continent2, 1.0);
        rmSetAreaSmoothDistance(continent2, 6);
        rmSetAreaHeightBlend(continent2, 1);
        rmSetAreaElevationNoiseBias(continent2, 0);
        rmSetAreaElevationEdgeFalloffDist(continent2, 10);
        rmSetAreaElevationVariation(continent2, 4);
        rmSetAreaElevationPersistence(continent2, .2);
        rmSetAreaElevationOctaves(continent2, 5);
        rmSetAreaElevationMinFrequency(continent2, 0.04);
        rmSetAreaElevationType(continent2, cElevTurbulence);  
	rmSetAreaObeyWorldCircleConstraint(continent2, false);
        rmBuildArea(continent2);    

		int classPatch = rmDefineClass("patch");
		int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 22.0);
		int classCenter = rmDefineClass("center");
		int avoidCenter = rmCreateClassDistanceConstraint("avoid center", rmClassID("center"), 27.0);
		int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
        



		rmSetStatusText("",0.2);

		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 6.0);      


/*
=============================
	two team spawn
=============================
*/


	if (cNumberTeams == 2){

		int cliffs = rmCreateArea("cliffs west");
		rmSetAreaSize(cliffs, 0.17, 0.17); 
		rmAddAreaToClass(cliffs, rmClassID("center"));
		rmSetAreaCliffType(cliffs, "ozarks");
//        rmSetAreaHeightBlend(cliffs, 1);
		rmSetAreaCliffEdge(cliffs, 1, 1.0, 0.0, 0.0, 2); //4,.225 looks cool too
		rmSetAreaCliffPainting(cliffs, false, true, true, 0.4, true);
		rmSetAreaCliffHeight(cliffs, 8, 0.1, 0.5);
		rmSetAreaCoherence(cliffs, .95);
		rmSetAreaLocation(cliffs, .2, .8);	
		rmSetAreaObeyWorldCircleConstraint(cliffs, false);
		rmBuildArea(cliffs);


		int cliffs2 = rmCreateArea("cliffs east");
		rmSetAreaSize(cliffs2, 0.17, 0.17); 
		rmAddAreaToClass(cliffs2, rmClassID("center"));
		rmSetAreaCliffType(cliffs2, "ozarks");
//        rmSetAreaHeightBlend(cliffs2, 1);
		rmSetAreaCliffEdge(cliffs2, 1, 1.0, 0.0, 0.0, 2); //4,.225 looks cool too
		rmSetAreaCliffPainting(cliffs2, false, true, true, 0.4, true);
		rmSetAreaCliffHeight(cliffs2, 8, 0.1, 0.5);
		rmSetAreaCoherence(cliffs2, .95);
		rmSetAreaLocation(cliffs2, .8, .2);	
		rmSetAreaObeyWorldCircleConstraint(cliffs2, false);
		rmBuildArea(cliffs2);


		int lakeN = rmCreateArea("lakeN");
        	rmSetAreaSize(lakeN, 0.07, 0.07);
		rmAddAreaToClass(lakeN, rmClassID("classPlateau"));
		rmAddAreaToClass(lakeN, rmClassID("center"));
        	rmSetAreaWaterType(lakeN, "Northwest Territory Water");
        	rmSetAreaHeightBlend(lakeN, 1);
        	rmSetAreaSmoothDistance(lakeN, 3);
		rmSetAreaLocation(lakeN, .85, .85);
        	rmSetAreaBaseHeight(lakeN, -5);
        	rmSetAreaCoherence(lakeN, .83);
		rmSetAreaObeyWorldCircleConstraint(lakeN, false);
		rmBuildArea(lakeN);

		int lakeS = rmCreateArea("lakeS");
        	rmSetAreaSize(lakeS, 0.07, 0.07);
		rmAddAreaToClass(lakeS, rmClassID("classPlateau"));
		rmAddAreaToClass(lakeS, rmClassID("center"));
        	rmSetAreaWaterType(lakeS, "Northwest Territory Water");
        	rmSetAreaHeightBlend(lakeS, 1);
        	rmSetAreaSmoothDistance(lakeS, 3);
		rmSetAreaLocation(lakeS, .15, .15);
        	rmSetAreaBaseHeight(lakeS, -5);
        	rmSetAreaCoherence(lakeS, .83);
		rmSetAreaObeyWorldCircleConstraint(lakeS, false);
		rmBuildArea(lakeS);


		int glacierBaseNW = rmCreateArea("flatland northwest");
		rmSetAreaSize(glacierBaseNW, 0.1, 0.1); 
		rmSetAreaCoherence(glacierBaseNW, .92);
		rmSetAreaLocation(glacierBaseNW, .5, .9);	
	rmAddAreaConstraint(glacierBaseNW, avoidPlateau);
	rmAddAreaToClass(glacierBaseNW, rmClassID("center"));
	   rmSetAreaMix(glacierBaseNW, "nwt_grass1");
        rmSetAreaSmoothDistance(glacierBaseNW, 25);
        rmSetAreaHeightBlend(glacierBaseNW, 2);
	rmAddAreaTerrainReplacement(glacierBaseNW, "nwterritory\ground_cliff1_nwt", "nwterritory\ground_grass5_nwt");
        rmSetAreaBaseHeight(glacierBaseNW, 1.0);
        rmAddAreaInfluenceSegment(glacierBaseNW, 0.15, 0.9, 0.85, 0.9);
	rmSetAreaObeyWorldCircleConstraint(glacierBaseNW, false);
		rmBuildArea(glacierBaseNW);


		int glacierBaseNE = rmCreateArea("flatland northeast");
		rmSetAreaSize(glacierBaseNE, 0.1, 0.1); 
		rmSetAreaCoherence(glacierBaseNE, .92);
		rmSetAreaLocation(glacierBaseNE, .9, .5);	
	rmAddAreaConstraint(glacierBaseNE, avoidPlateau);
	rmAddAreaToClass(glacierBaseNE, rmClassID("center"));
	   rmSetAreaMix(glacierBaseNE, "nwt_grass1");
        rmSetAreaSmoothDistance(glacierBaseNE, 25);
        rmSetAreaHeightBlend(glacierBaseNE, 2);
	rmAddAreaTerrainReplacement(glacierBaseNE, "nwterritory\ground_cliff1_nwt", "nwterritory\ground_grass5_nwt");
       rmSetAreaBaseHeight(glacierBaseNE, 1.0);
        rmAddAreaInfluenceSegment(glacierBaseNE, 0.9, 0.15, 0.9, 0.85);
	rmSetAreaObeyWorldCircleConstraint(glacierBaseNE, false);
		rmBuildArea(glacierBaseNE);


		int glacierBaseSW = rmCreateArea("flatland southwest");
		rmSetAreaSize(glacierBaseSW, 0.1, 0.1); 
		rmSetAreaCoherence(glacierBaseSW, .92);
		rmSetAreaLocation(glacierBaseSW, .1, .5);	
	rmAddAreaConstraint(glacierBaseSW, avoidPlateau);
	rmAddAreaToClass(glacierBaseSW, rmClassID("center"));
	   rmSetAreaMix(glacierBaseSW, "nwt_grass1");
        rmSetAreaSmoothDistance(glacierBaseSW, 25);
        rmSetAreaHeightBlend(glacierBaseSW, 2);
	rmAddAreaTerrainReplacement(glacierBaseSW, "nwterritory\ground_cliff1_nwt", "nwterritory\ground_grass5_nwt");
        rmSetAreaBaseHeight(glacierBaseSW, 1.0);
        rmAddAreaInfluenceSegment(glacierBaseSW, 0.1, 0.15, 0.1, 0.85);
	rmSetAreaObeyWorldCircleConstraint(glacierBaseSW, false);
		rmBuildArea(glacierBaseSW);


		int glacierBaseSE = rmCreateArea("flatland southeast");
		rmSetAreaSize(glacierBaseSE, 0.1, 0.1); 
		rmSetAreaCoherence(glacierBaseSE, .92);
		rmSetAreaLocation(glacierBaseSE, .5, .1);	
	rmAddAreaConstraint(glacierBaseSE, avoidPlateau);
	rmAddAreaToClass(glacierBaseSE, rmClassID("center"));
	   rmSetAreaMix(glacierBaseSE, "nwt_grass1");
        rmSetAreaSmoothDistance(glacierBaseSE, 25);
        rmSetAreaHeightBlend(glacierBaseSE, 2);
	rmAddAreaTerrainReplacement(glacierBaseSE, "nwterritory\ground_cliff1_nwt", "nwterritory\ground_grass5_nwt");
        rmSetAreaBaseHeight(glacierBaseSE, 1.0);
        rmAddAreaInfluenceSegment(glacierBaseSE, 0.15, 0.1, 0.85, 0.1);
	rmSetAreaObeyWorldCircleConstraint(glacierBaseSE, false);
		rmBuildArea(glacierBaseSE);



	//build trade routes

//trade route (south)

       
        int tradeRouteID = rmCreateTradeRoute();
        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, .0, .45);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, .2, .45, 4, 2);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, .45, .2, 4, 2);
		rmAddTradeRouteWaypoint(tradeRouteID, .45, .0);
        rmBuildTradeRoute(tradeRouteID, "dirt");
 
        vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.85);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);



		
		//trade route(north)

		int socketID2=rmCreateObjectDef("sockets to dock Trade Posts2");
        rmAddObjectDefItem(socketID2, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID2, true);
        rmSetObjectDefMinDistance(socketID2, 0.0);
        rmSetObjectDefMaxDistance(socketID2, 6.0);      
       
        int tradeRouteID2 = rmCreateTradeRoute();
        rmSetObjectDefTradeRouteID(socketID2, tradeRouteID2);
		rmAddTradeRouteWaypoint(tradeRouteID2, 1.0, .55);
		rmAddRandomTradeRouteWaypoints(tradeRouteID2, .8, .55, 4, 2);
		rmAddRandomTradeRouteWaypoints(tradeRouteID2, .55, .8, 4, 2);
		rmAddTradeRouteWaypoint(tradeRouteID2, .55, 1.0);

        rmBuildTradeRoute(tradeRouteID2, "dirt");
 
		vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.15);
        rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);       
        socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.85);
        rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
        socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.50);
        rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);



}




		rmSetStatusText("",0.3);

	if (cNumberTeams >= 3){

		int center = rmCreateArea("center");
		rmAddAreaToClass(center, rmClassID("patch"));
        rmSetAreaSize(center, .11, .18);
        rmSetAreaLocation(center, 0.5, 0.5);
        rmSetAreaCoherence(center, 1.0);
        rmBuildArea(center);   



for(i=1; < cNumberNonGaiaPlayers + 1) {

    int PlayerArea1 = rmCreateArea("NeedLand1"+i);
        rmSetAreaSize(PlayerArea1, rmAreaTilesToFraction(2600), rmAreaTilesToFraction(2600));
		rmAddAreaToClass(PlayerArea1, rmClassID("classPlateau"));
		rmAddAreaToClass(PlayerArea1, rmClassID("center"));
       rmSetAreaHeightBlend(PlayerArea1, 2);
        rmSetAreaLocation(PlayerArea1, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmSetAreaCoherence(PlayerArea1, 0.85);
        rmBuildArea(PlayerArea1);

}

//ffa circular TP

        tradeRouteID = rmCreateTradeRoute();
        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.65);
       rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.7);
     rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.65);
       rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 0.5);
	  rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.35);
       rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.3);
	  rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.35);
       rmAddTradeRouteWaypoint(tradeRouteID, 0.7, 0.5);
	  rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.65);
        rmBuildTradeRoute(tradeRouteID, "dirt");

	vector socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc3 );
	socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID, 0.45);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc3 );
	socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID, 0.7);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc3 );
	socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID, 0.95);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc3 );



//==========hills==============

	for (j=0; < (9*cNumberNonGaiaPlayers)) {   
			int ffaCliffs = rmCreateArea("ffaCliffs"+j);
        rmSetAreaSize(ffaCliffs, rmAreaTilesToFraction(300), rmAreaTilesToFraction(400));
		rmAddAreaToClass(ffaCliffs, rmClassID("classPlateau"));
		rmAddAreaToClass(ffaCliffs, rmClassID("center"));
		rmSetAreaCliffType(ffaCliffs, "ozarks");
		rmSetAreaCliffEdge(ffaCliffs, 1, 1, 0.0, 0.0, 2); //4,.225 looks cool too
		rmSetAreaCliffPainting(ffaCliffs, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(ffaCliffs, 8, 1, 0.5);
		rmAddAreaConstraint(ffaCliffs, avoidCenter);
		rmAddAreaConstraint(ffaCliffs, avoidPlateau);
		rmAddAreaConstraint(ffaCliffs, avoidPatch);
		rmAddAreaConstraint(ffaCliffs, avoidTradeRouteSmall);
		rmSetAreaObeyWorldCircleConstraint(ffaCliffs, false);

//avoidPatch
        rmSetAreaCoherence(ffaCliffs, .89);

        rmBuildArea(ffaCliffs);  
	}


}


	if (cNumberNonGaiaPlayers == 2)
{

//=========2 player fixed mines============

  	int smollMines = rmCreateObjectDef("competitive gold");
	rmAddObjectDefItem(smollMines, "mineGold", 1, 1.0);
	rmSetObjectDefMinDistance(smollMines, 0.0);
	rmSetObjectDefMaxDistance(smollMines, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.15, 0.4, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.4, 0.15, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.48, 0.83, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.83, 0.48, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.5, 0.5, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.93, 0.93, 1);


  	int smollMines2 = rmCreateObjectDef("second mine");
	rmAddObjectDefItem(smollMines2, "mine", 1, 1.0);
	rmPlaceObjectDefAtLoc(smollMines2, 0, 0.12, 0.65, 1);
	rmPlaceObjectDefAtLoc(smollMines2, 0, 0.65, 0.12, 1);


}



	int fishID=rmCreateObjectDef("fish");
	rmAddObjectDefItem(fishID, "FishSalmon", 3, 4.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, fishVsFishID);
	rmAddObjectDefConstraint(fishID, fishLand);
	rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);


//==========ponds==============

 int pondNumber = 4;

	if (cNumberNonGaiaPlayers >= 3){
	pondNumber = 4*cNumberNonGaiaPlayers;
}
	for (j=0; < (pondNumber)) { 
  
			int islandW = rmCreateArea("islandW"+j);
        rmSetAreaSize(islandW, rmAreaTilesToFraction(130), rmAreaTilesToFraction(260));
//		rmAddAreaToClass(islandW, rmClassID("classPlateau"));
        rmSetAreaWaterType(islandW, "Northwest Territory Water");
        rmSetAreaBaseHeight(islandW, -5);
        rmSetAreaCoherence(islandW, .93);
        rmSetAreaHeightBlend(islandW, 1);
        rmSetAreaSmoothDistance(islandW, 3);
	rmAddAreaConstraint(islandW, avoidPlateauMore);
	rmAddAreaConstraint(islandW, avoidCenter);
	rmAddAreaConstraint(islandW, avoidGold);
	rmAddAreaConstraint(islandW, avoidTradeRouteSmall);
	rmAddAreaConstraint(islandW, avoidWaterShort);
	rmSetAreaObeyWorldCircleConstraint(islandW, false);

	if (cNumberNonGaiaPlayers == 2){

if (j == 0){
		rmSetAreaLocation(islandW, .65, .55);	
}
if (j == 1){
		rmSetAreaLocation(islandW, .35, .45);	
}

}
        rmBuildArea(islandW);  
	}


		rmSetStatusText("",0.4);
		//starting objects

		
        int playerStart = rmCreateStartingUnitsObjectDef(5.0);
        rmSetObjectDefMinDistance(playerStart, 7.0);
        rmSetObjectDefMaxDistance(playerStart, 12.0);
	rmAddObjectDefConstraint(playerStart, avoidWaterShort);

       
        int goldID = rmCreateObjectDef("starting gold");
        rmAddObjectDefItem(goldID, "mine", 1, 3.0);
        rmSetObjectDefMinDistance(goldID, 16.0);
        rmSetObjectDefMaxDistance(goldID, 16.0);
        rmAddObjectDefConstraint(goldID, avoidCoinMed);



        int berryID = rmCreateObjectDef("starting berries");
        rmAddObjectDefItem(berryID, "BerryBush", 5, 4.0);
        rmSetObjectDefMinDistance(berryID, 16.0);
        rmSetObjectDefMaxDistance(berryID, 17.0);
        rmAddObjectDefConstraint(berryID, avoidCoin);
 
        int treeID = rmCreateObjectDef("starting trees");
        rmAddObjectDefItem(treeID, "TreeNorthwestTerritory", rmRandInt(6,7), 5.0);
        rmSetObjectDefMinDistance(treeID, 19.0);
        rmSetObjectDefMaxDistance(treeID, 21.0);
        rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
        rmAddObjectDefConstraint(treeID, avoidCoin);
		rmAddObjectDefToClass(treeID, rmClassID("classForest")); 

 
        int foodID = rmCreateObjectDef("starting hunt");
        rmAddObjectDefItem(foodID, "caribou", 8, 8.0);
        rmSetObjectDefMinDistance(foodID, 10.0);
        rmSetObjectDefMaxDistance(foodID, 12.0);
	rmAddObjectDefConstraint(foodID, avoidWaterShort);	
        rmSetObjectDefCreateHerd(foodID, false);
 
        int foodID2 = rmCreateObjectDef("starting hunt 2");
        rmAddObjectDefItem(foodID2, "moose", 7, 8.0);
        rmSetObjectDefMinDistance(foodID2, 28.0);
        rmSetObjectDefMaxDistance(foodID2, 30.0);
        rmSetObjectDefCreateHerd(foodID2, true);
	rmAddObjectDefConstraint(foodID2, avoidWaterShort);	
	rmAddObjectDefConstraint(foodID2, circleConstraint);


                       
		int foodID3 = rmCreateObjectDef("starting hunt 3");
        rmAddObjectDefItem(foodID3, "caribou", 8, 8.0);
        rmSetObjectDefMinDistance(foodID3, 48.0);
        rmSetObjectDefMaxDistance(foodID3, 50.0);
	rmAddObjectDefConstraint(foodID3, avoidWaterShort);	
	rmAddObjectDefConstraint(foodID3, circleConstraint);
        rmSetObjectDefCreateHerd(foodID3, true);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmSetNuggetDifficulty(1, 1); 
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 3.0);
    rmSetObjectDefMinDistance(playerNuggetID, 28.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 35.0);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);



		rmSetStatusText("",0.5);  
    
    		for(i=1; < cNumberNonGaiaPlayers + 1) {
		int id=rmCreateArea("Player"+i);
		rmSetPlayerArea(i, id);
		int startID = rmCreateObjectDef("object"+i);
		if(rmGetNomadStart()){
			rmAddObjectDefItem(startID, "CoveredWagon", 1, 3.0);
		}else{
			rmAddObjectDefItem(startID, "TownCenter", 1, 3.0);
		}
		rmSetObjectDefMinDistance(startID, 0.0);
        	rmSetObjectDefMaxDistance(startID, 5.0);
		rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID3, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(berryID , i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

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


	if (cNumberNonGaiaPlayers >= 3)
{
  	int eastmine = rmCreateObjectDef("east mines");
	rmAddObjectDefItem(eastmine, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(eastmine, rmXFractionToMeters(0.0));
	rmSetObjectDefMaxDistance(eastmine, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(eastmine, avoidCoinMed);
	rmAddObjectDefConstraint(eastmine, avoidTradeRouteSmall);
//	rmAddObjectDefConstraint(eastmine, avoidWaterShort);
	rmAddObjectDefConstraint(eastmine, avoidTownCenterMore);
//rmAddObjectDefConstraint(eastmine, stayEast);
	rmAddObjectDefConstraint(eastmine, circleConstraint);

	if (cNumberTeams == 2){
	rmAddObjectDefConstraint(eastmine, avoidPlateau);	
}else{
	rmAddObjectDefConstraint(eastmine, avoidPlateauSmall);	
}
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
}
	
    int mooseHunts = rmCreateObjectDef("mooseHunts");
	rmAddObjectDefItem(mooseHunts, "moose", rmRandInt(4,5), 7.0);
	rmSetObjectDefCreateHerd(mooseHunts, true);
	rmSetObjectDefMinDistance(mooseHunts, 0);
	rmSetObjectDefMaxDistance(mooseHunts, rmXFractionToMeters(0.43));
	rmAddObjectDefConstraint(mooseHunts, circleConstraint);
	rmAddObjectDefConstraint(mooseHunts, avoidTownCenterMore);
	rmAddObjectDefConstraint(mooseHunts, avoidHuntSmall);
		rmAddObjectDefConstraint(mooseHunts, avoidCenter);
	rmAddObjectDefConstraint(mooseHunts, waterHunt);	
	rmAddObjectDefConstraint(mooseHunts, avoidCoin);	
	rmPlaceObjectDefAtLoc(mooseHunts, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);


    int elkHunts = rmCreateObjectDef("elkHunts");
	rmAddObjectDefItem(elkHunts, "elk", rmRandInt(6,7), 12.0);
	rmSetObjectDefCreateHerd(elkHunts, true);
	rmSetObjectDefMinDistance(elkHunts, 0);
	rmSetObjectDefMaxDistance(elkHunts, rmXFractionToMeters(0.43));
	rmAddObjectDefConstraint(elkHunts, circleConstraint);
	//rmAddObjectDefConstraint(elkHunts, avoidTownCenterMore);
	rmAddObjectDefConstraint(elkHunts, avoidHunt);
	rmAddObjectDefConstraint(elkHunts, avoidBerries);
	rmAddObjectDefConstraint(elkHunts, avoidPlateau);
	rmAddObjectDefConstraint(elkHunts, avoidWaterShort);	
	rmAddObjectDefConstraint(elkHunts, avoidCoin);	
	rmPlaceObjectDefAtLoc(elkHunts, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);


    int berries = rmCreateObjectDef("berries");
	rmAddObjectDefItem(berries, "BerryBush", rmRandInt(3,4), 4.0);
	rmSetObjectDefMinDistance(berries, 0);
	rmSetObjectDefMaxDistance(berries, rmXFractionToMeters(0.43));
	rmAddObjectDefConstraint(berries, circleConstraint);
	rmAddObjectDefConstraint(berries, avoidTownCenter);
	rmAddObjectDefConstraint(berries, avoidHunt);
	rmAddObjectDefConstraint(berries, avoidBerries);
	rmAddObjectDefConstraint(berries, avoidPlateau);
	rmAddObjectDefConstraint(berries, avoidWaterShort);	
	rmAddObjectDefConstraint(berries, avoidCoin);	
	rmPlaceObjectDefAtLoc(berries, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);



	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
	rmAddObjectDefConstraint(nuggetID, forestConstraintShort);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenterMore); 
	rmAddObjectDefConstraint(nuggetID, avoidPlateau);
	rmAddObjectDefConstraint(nuggetID, avoidWaterShort);	
	rmAddObjectDefConstraint(nuggetID, avoidCoin);	
	rmSetNuggetDifficulty(2, 3); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);   
	rmSetStatusText("",0.7);

	//removes loop for faster loading times
	//for (j=0; < (6*cNumberNonGaiaPlayers)) {   
		int mapTrees=rmCreateObjectDef("map trees");
		rmAddObjectDefItem(mapTrees, "TreeNorthwestTerritory", rmRandInt(14,16), rmRandFloat(15.0,16.0));
		rmAddObjectDefToClass(mapTrees, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(mapTrees, 0);
		rmSetObjectDefMaxDistance(mapTrees, rmXFractionToMeters(0.47));
		rmAddObjectDefConstraint(mapTrees, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(mapTrees, avoidGold);
	  	rmAddObjectDefConstraint(mapTrees, avoidCoin);
		rmAddObjectDefConstraint(mapTrees, forestConstraint);
		rmAddObjectDefConstraint(mapTrees, avoidTownCenterSmall);	
		rmAddObjectDefConstraint(mapTrees, avoidPlateau);	
//		rmAddObjectDefConstraint(mapTrees, avoidWaterShort);
		rmAddObjectDefConstraint(mapTrees, circleConstraint);
		rmPlaceObjectDefAtLoc(mapTrees, 0, 0.5, 0.5, 45*cNumberNonGaiaPlayers);
	//}

		rmSetStatusText("",0.8);



   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .05, 0);
   }

	rmSetStatusText("",0.9);


	}
 
