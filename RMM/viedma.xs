/*
==============================
		Viedma
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
	int playerTiles=14000;
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=13000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=12000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=11000;


	int size = 2.0 * sqrt(cNumberNonGaiaPlayers*playerTiles);

	if (cNumberTeams >= 3){
	size = 2.25 * sqrt(cNumberNonGaiaPlayers*playerTiles);
}

	rmSetMapSize(size, size);

	rmSetSeaType("Araucania Central Coast");
	rmSetMapType("patagonia");
	rmSetMapType("samerica");
	rmSetMapType("land");
	rmSetMapType("water");
	rmSetMapType("AIFishingUseful");
	rmSetWorldCircleConstraint(true);
//	rmSetOceanReveal(true);
//	rmSetLightingSet("seville morning");
		rmSetLightingSet("3x01a_carolina");
//		rmSetLightingSet("amsterdam evening");
//		rmSetLightingSet("lisbon storm");
		rmSetSeaLevel(0.0);
		rmSetWindMagnitude(6.0);



   // Init map.
   rmTerrainInitialize("water");

 	  rmSetGlobalRain( 0.6 );

//		rmSetLightingSet("st_louis");

        rmDefineClass("classForest");
		rmDefineClass("classPlateau");



		//Constraints
		int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 12.0);

		int avoidPlateauSmall=rmCreateClassDistanceConstraint("stuff vs. cliffs s", rmClassID("classPlateau"), 7.0);


        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
       
		int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 22.0);
        int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
        
		int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 48.0);

		int avoidHuntSmall=rmCreateTypeDistanceConstraint("hunts avoid hunts small", "huntable", 30.0);


		int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 10.0);

        int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 24.0);

		int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
		int avoidCoinSPC=rmCreateTypeDistanceConstraint("avoid special coin", "SPCMine", 12.0);

		int avoidGold=rmCreateTypeDistanceConstraint("avoid coin gold", "mineGold", 16.0);

		int waterCoin=rmCreateTypeDistanceConstraint("avoid coin smallest", "Mine", 8.0);


        int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 42.0);
        int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 9.0);
        int cliffWater = rmCreateTerrainDistanceConstraint("cliff avoids river", "Land", false, 0.01);
        int cliffWater2 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 5.0);
        int cliffWater3 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 14.0);


        int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 9.0);
        int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 25.0);
        
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 38.0);
        int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 26.0);
        int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 60.0);  
       
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 35.0);

		int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid teh nuggs", "AbstractNugget", 10.0);



  int avoidBerries=rmCreateTypeDistanceConstraint("avoid berries", "berrybush", 20.0);
  int avoidBerriesSmall=rmCreateTypeDistanceConstraint("avoid berries smoll", "berrybush", 8.0);


  int stayWest = rmCreatePieConstraint("Stay West",0.47,0.53, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(180),rmDegreesToRadians(0));

  int stayEast = rmCreatePieConstraint("Stay East",0.53,0.47, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(180));

   



    
 // =============Player placement ======================= 
    float spawnSwitch = rmRandFloat(0,1.2);
//spawnSwitch = 0.1;

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);


	if (cNumberTeams == 2){
		if (spawnSwitch <=0.6){

	if (cNumberNonGaiaPlayers == 2)
	{
	rmPlacePlayer(1, 0.3, 0.7);
	rmPlacePlayer(2, 0.7, 0.3);	
}

		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.4, 0.8, 0.2, 0.6, 0, 0);
		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.6, 0.2, 0.8, 0.4, 0, 0);


		}else if(spawnSwitch <=1.2){

	if (cNumberNonGaiaPlayers == 2)
	{
	rmPlacePlayer(1, 0.3, 0.7);
	rmPlacePlayer(2, 0.7, 0.3);	
	}

		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.4, 0.8, 0.2, 0.6, 0, 0);
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.6, 0.2, 0.8, 0.4, 0, 0);

		}
	}else{
	//*************ffa placement********
		rmPlacePlayersCircular(0.34, 0.34, 0.00);
	}

		
        chooseMercs();
        rmSetStatusText("",0.1); 


        int continent2 = rmCreateArea("continent");
        rmSetAreaSize(continent2, 0.5, 0.5);
        rmSetAreaLocation(continent2, 0.5, 0.5);
	//   rmSetAreaMix(continent2, "araucania_dirt_b");
	   rmSetAreaMix(continent2, "araucania_grass_a");

        rmSetAreaBaseHeight(continent2, 3.0);
        rmSetAreaCoherence(continent2, 0.86);
        rmSetAreaSmoothDistance(continent2, 11);
        rmSetAreaHeightBlend(continent2, 3);
        rmSetAreaElevationNoiseBias(continent2, 0);
        rmSetAreaElevationEdgeFalloffDist(continent2, 10);
        rmSetAreaElevationVariation(continent2, 5);
        rmSetAreaElevationPersistence(continent2, .2);
        rmSetAreaElevationOctaves(continent2, 5);
        rmSetAreaElevationMinFrequency(continent2, 0.04);
        rmSetAreaElevationType(continent2, cElevTurbulence);  
        rmBuildArea(continent2);    

		int classPatch = rmDefineClass("patch");
		int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 35.0);
		int classCenter = rmDefineClass("center");
		int avoidCenter = rmCreateClassDistanceConstraint("avoid center", rmClassID("center"), 27.0);

		int avoidCenterShort = rmCreateClassDistanceConstraint("avoid center small", rmClassID("center"), 2.0);

		int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.4), rmDegreesToRadians(0), rmDegreesToRadians(360));
        
//=======================================================

       		for (i=0; < cNumberNonGaiaPlayers*60){
			int patchID = rmCreateArea("first patch"+i);
			rmSetAreaWarnFailure(patchID, false);
			rmSetAreaSize(patchID, rmAreaTilesToFraction(20), rmAreaTilesToFraction(25));
        rmSetAreaTerrainType(patchID, "araucania\ground_dirt4_ara");
	//		rmAddAreaToClass(patchID, rmClassID("patch"));
			rmSetAreaSmoothDistance(patchID, 1.0);
			rmBuildArea(patchID); 
		}
//=====================================================


for(i=1; < cNumberNonGaiaPlayers + 1) {

    int PlayerArea1 = rmCreateArea("NeedLand1"+i);
        rmSetAreaSize(PlayerArea1, rmAreaTilesToFraction(1800), rmAreaTilesToFraction(1800));
		rmAddAreaToClass(PlayerArea1, rmClassID("center"));
		rmAddAreaToClass(PlayerArea1, rmClassID("patch"));

//       rmSetAreaHeightBlend(PlayerArea1, 2);
        rmSetAreaBaseHeight(PlayerArea1, 2.25);
        rmSetAreaLocation(PlayerArea1, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	   rmSetAreaMix(PlayerArea1, "araucania_dirt_b");

        rmSetAreaCoherence(PlayerArea1, 0.85);
//   rmSetAreaEdgeFilling(PlayerArea1, 1.0);
        rmBuildArea(PlayerArea1);

}



		rmSetStatusText("",0.2);





		int glacierN = rmCreateArea("cliffs north");
		rmSetAreaSize(glacierN, 0.16, 0.16); 
		rmSetAreaCoherence(glacierN, .98);
		rmSetAreaLocation(glacierN, .8, .2);	
        rmSetAreaBaseHeight(glacierN, 4.0);
	   rmSetAreaMix(glacierN, "araucania_dirt_b");
       rmAddAreaInfluenceSegment(glacierN, 0.9, 0.1, 1.0, 0.35);
       rmAddAreaInfluenceSegment(glacierN, 0.9, 0.1, 0.65, 0.0);
	rmSetAreaObeyWorldCircleConstraint(glacierN, false);
        rmSetAreaSmoothDistance(glacierN, 8);
        rmSetAreaHeightBlend(glacierN, 2);
		rmBuildArea(glacierN);

		int glacierS = rmCreateArea("cliffs south");
		rmSetAreaSize(glacierS, 0.16, 0.16); 
		rmSetAreaCoherence(glacierS, .98);
		rmSetAreaLocation(glacierS, .2, .8);	
        rmSetAreaBaseHeight(glacierS, 4.0);
	   rmSetAreaMix(glacierS, "araucania_dirt_b");
       rmAddAreaInfluenceSegment(glacierS, 0.1, 0.9, 0.0, 0.65);
       rmAddAreaInfluenceSegment(glacierS, 0.1, 0.9, 0.35, 1.0);
	rmSetAreaObeyWorldCircleConstraint(glacierS, false);
        rmSetAreaSmoothDistance(glacierS, 8);
        rmSetAreaHeightBlend(glacierS, 2);
		rmBuildArea(glacierS);



	int NWconstraint = rmCreateBoxConstraint("stay in NW portion", 0, 0.6, 0.4, 1);
	int NEconstraint = rmCreateBoxConstraint("stay in NE portion", 0.6, 0.0, 1.0, 0.4);



		int glacierBaseNW = rmCreateArea("flatland northwest");
		rmSetAreaSize(glacierBaseNW, 0.48, 0.48); 
		rmSetAreaCoherence(glacierBaseNW, .92);
		rmSetAreaLocation(glacierBaseNW, .5, .5);	
	rmAddAreaToClass(glacierBaseNW, rmClassID("center"));
		rmBuildArea(glacierBaseNW);


		int cliffs = rmCreateArea("cliffs west");
		rmSetAreaSize(cliffs, 0.5, 0.5); 
		rmAddAreaToClass(cliffs, rmClassID("classPlateau"));
		rmSetAreaCliffType(cliffs, "Araucania Southern Coast");
        rmSetAreaHeightBlend(cliffs, 2);
		rmSetAreaCliffEdge(cliffs, 1, 1.0, 0.0, 0.0, 2); //4,.225 looks cool too
		rmSetAreaCliffPainting(cliffs, true, true, true, 0.4, true);
		rmSetAreaCliffHeight(cliffs, 8, 0.1, 0.5);
      rmSetAreaBaseHeight(cliffs, 3.0);
     rmSetAreaSmoothDistance(cliffs, 5);
	rmSetAreaCoherence(cliffs, .94);
	rmSetAreaLocation(cliffs, .18, .82);	
      rmAddAreaInfluenceSegment(cliffs, 0.0, 1.0, 0.0, 0.7);
      rmAddAreaInfluenceSegment(cliffs, 0.0, 1.0, 0.3, 1.0);
	rmAddAreaConstraint(cliffs, avoidCenterShort);
	rmAddAreaConstraint(cliffs, NWconstraint);
	rmSetAreaObeyWorldCircleConstraint(cliffs, false);
	rmBuildArea(cliffs);


		int cliffs2 = rmCreateArea("cliffs east");
		rmSetAreaSize(cliffs2, 0.5, 0.5); 
		rmAddAreaToClass(cliffs2, rmClassID("classPlateau"));
		rmSetAreaCliffType(cliffs2, "Araucania Southern Coast");
        rmSetAreaHeightBlend(cliffs2, 2);
		rmSetAreaCliffEdge(cliffs2, 1, 1.0, 0.0, 0.0, 2); //4,.225 looks cool too
		rmSetAreaCliffPainting(cliffs2 , true, true, true, 0.4, true);
		rmSetAreaCliffHeight(cliffs2, 8, 0.1, 0.5);
        rmSetAreaBaseHeight(cliffs2, 3.0);
        rmSetAreaSmoothDistance(cliffs2, 5);
		rmSetAreaCoherence(cliffs2, .94);
		rmSetAreaLocation(cliffs2, .82, .18);	
        rmAddAreaInfluenceSegment(cliffs2, 1.0, 0.0, 1.0, 0.7);
        rmAddAreaInfluenceSegment(cliffs2, 1.0, 0.0, 0.7, 0.0);
	rmAddAreaConstraint(cliffs2, avoidCenterShort);
	rmAddAreaConstraint(cliffs2, NEconstraint);
	rmSetAreaObeyWorldCircleConstraint(cliffs2, false);
	rmBuildArea(cliffs2);






//===================================================
	//build trade routes



		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 6.0);      

//trade route (west)

       
        int tradeRouteID = rmCreateTradeRoute();
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
 
        vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.07);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.57);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

	if (cNumberNonGaiaPlayers >= 3){
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.32);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.82);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);



}




//========================================================





		rmSetStatusText("",0.3);


//==========hills==============

	for (j=0; < (1.5*cNumberNonGaiaPlayers)) {   
			int ffaCliffs = rmCreateArea("ffaCliffs"+j);
        rmSetAreaSize(ffaCliffs, rmAreaTilesToFraction(680), rmAreaTilesToFraction(950));
//		rmAddAreaToClass(ffaCliffs, rmClassID("classPlateau"));
		rmAddAreaToClass(ffaCliffs, rmClassID("patch"));
		rmSetAreaCliffType(ffaCliffs, "Araucania Central");
      rmSetAreaCliffEdge(ffaCliffs, 2, 0.3, 0.1, 1.0, 0);
//4,.225 looks cool too
		rmSetAreaCliffPainting(ffaCliffs, false, false, true, 1.5, true);
		rmSetAreaCliffHeight(ffaCliffs, -4, 1, 0.5);
		rmSetAreaCoherence(ffaCliffs, .94);
	rmAddAreaConstraint(ffaCliffs, avoidWaterShort);
	rmAddAreaConstraint(ffaCliffs, avoidPlateau);
	rmAddAreaConstraint(ffaCliffs, avoidPatch);
	rmAddAreaConstraint(ffaCliffs, avoidTradeRouteSmall);
	rmAddAreaConstraint(ffaCliffs, circleConstraint2);
        rmSetAreaSmoothDistance(ffaCliffs, 11);
        rmSetAreaHeightBlend(ffaCliffs, 3);
        rmSetAreaCoherence(ffaCliffs, .89);

        rmBuildArea(ffaCliffs);  
	}




//	if (cNumberNonGaiaPlayers == 2)
//{
//=========2 player fixed mines============

  	int smollMines = rmCreateObjectDef("competitive gold");
	rmAddObjectDefItem(smollMines, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(smollMines, 0.0);
	rmSetObjectDefMaxDistance(smollMines, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.44, 0.94, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.56, 0.08, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.08, 0.43, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.94, 0.45, 1);



	if (cNumberNonGaiaPlayers == 2)
{
//starting mines
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.25, 0.73, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.75, 0.27, 1);
//proper spacing
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.41, 0.8, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.8, 0.41, 1);

	rmPlaceObjectDefAtLoc(smollMines, 0, 0.22, 0.6, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.6, 0.22, 1);

}
				


		rmSetStatusText("",0.4);
		//starting objects

		
        int playerStart = rmCreateStartingUnitsObjectDef(5.0);
        rmSetObjectDefMinDistance(playerStart, 7.0);
        rmSetObjectDefMaxDistance(playerStart, 12.0);
	rmAddObjectDefConstraint(playerStart, avoidWaterShort);

       
        int goldID = rmCreateObjectDef("starting gold");
        rmAddObjectDefItem(goldID, "SPCMine", 1, 3.0);
        rmSetObjectDefMinDistance(goldID, 12.0);
        rmSetObjectDefMaxDistance(goldID, 14.0);
 //       rmAddObjectDefConstraint(goldID, avoidCoinMed);



        int berryID = rmCreateObjectDef("starting berries");
        rmAddObjectDefItem(berryID, "BerryBush", 5, 4.0);
        rmSetObjectDefMinDistance(berryID, 15.0);
        rmSetObjectDefMaxDistance(berryID, 17.0);
        rmAddObjectDefConstraint(berryID, avoidCoin);
 
        int treeID = rmCreateObjectDef("starting trees");
        rmAddObjectDefItem(treeID, "TreeAraucania", rmRandInt(6,7), 5.0);
        rmSetObjectDefMinDistance(treeID, 19.0);
        rmSetObjectDefMaxDistance(treeID, 21.0);
        rmAddObjectDefConstraint(treeID, avoidPlateau);
        rmAddObjectDefConstraint(treeID, avoidCoinSPC);
		rmAddObjectDefToClass(treeID, rmClassID("classForest")); 

 
        int foodID = rmCreateObjectDef("starting hunt");
        rmAddObjectDefItem(foodID, "rhea", 8, 8.0);
        rmSetObjectDefMinDistance(foodID, 11.0);
        rmSetObjectDefMaxDistance(foodID, 13.0);
	rmAddObjectDefConstraint(foodID, avoidWaterShort);	
        rmSetObjectDefCreateHerd(foodID, false);
 
        int foodID2 = rmCreateObjectDef("starting hunt 2");
        rmAddObjectDefItem(foodID2, "guanaco", 9, 6.0);
        rmSetObjectDefMinDistance(foodID2, 28.0);
        rmSetObjectDefMaxDistance(foodID2, 30.0);
        rmSetObjectDefCreateHerd(foodID2, true);
	rmAddObjectDefConstraint(foodID2, avoidWaterShort);	
	rmAddObjectDefConstraint(foodID2, circleConstraint);
	rmAddObjectDefConstraint(foodID2, avoidCoinSPC);



                       
		int foodID3 = rmCreateObjectDef("starting hunt 3");
        rmAddObjectDefItem(foodID3, "rhea", 9, 8.0);
        rmSetObjectDefMinDistance(foodID3, 38.0);
        rmSetObjectDefMaxDistance(foodID3, 40.0);
	rmAddObjectDefConstraint(foodID3, avoidPlateau);	
	rmAddObjectDefConstraint(foodID3, circleConstraint);
	rmAddObjectDefConstraint(foodID3, avoidHunt);
        rmSetObjectDefCreateHerd(foodID3, true);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmSetNuggetDifficulty(1, 1); 
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 3.0);
    rmSetObjectDefMinDistance(playerNuggetID, 27.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 29.0);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);

		int extraberrywagon=rmCreateObjectDef("JapAn cAnT hUnT");
  rmAddObjectDefItem(extraberrywagon, "ypBerryWagon1", 1, 0.0);
  rmSetObjectDefMinDistance(extraberrywagon, 8.0);
  rmSetObjectDefMaxDistance(extraberrywagon, 10.0);


		rmSetStatusText("",0.5);  
    
    for(i=1; < cNumberNonGaiaPlayers + 1) {
		int id=rmCreateArea("Player"+i);
		rmSetPlayerArea(i, id);
		int startID = rmCreateObjectDef("object"+i);
	if ( rmGetNomadStart())
	{
		rmAddObjectDefItem(startID, "CoveredWagon", 1, 2.0);
	}
	else
	{
		rmAddObjectDefItem(startID, "TownCenter", 1, 2.0);
	}
		rmSetObjectDefMinDistance(startID, 0.0);
		rmSetObjectDefMaxDistance(startID, 5.0);

		rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));


	if (cNumberNonGaiaPlayers >= 3){
        rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}

        rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID3, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
  	//rmPlaceObjectDefAtLoc(berryID , i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

        rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

	if (rmGetPlayerCiv(i) == rmGetCivID("Japanese")) {
        rmPlaceObjectDefAtLoc(extraberrywagon, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        }

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}

	rmSetStatusText("",0.6);




	if (rmGetIsKOTH()) {
		float xLoc = 0.5;
		float yLoc = 0.5;
		float walk = 0.02;

		ypKingsHillLandfill(xLoc, yLoc, 0.01, 3.5, "araucania\ground_dirt4_ara", 0);

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
	}




	/*
	==================
	resource placement
	==================
	*/




  	int eastmine = rmCreateObjectDef("east mines");
	rmAddObjectDefItem(eastmine, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(eastmine, rmXFractionToMeters(0.0));
	rmSetObjectDefMaxDistance(eastmine, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(eastmine, avoidCoinMed);
	rmAddObjectDefConstraint(eastmine, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(eastmine, cliffWater2);
	rmAddObjectDefConstraint(eastmine, avoidTownCenter);
	rmAddObjectDefConstraint(eastmine, circleConstraint);
	rmAddObjectDefConstraint(eastmine, avoidPlateau);	
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers);

	
    int muskHunts = rmCreateObjectDef("muskHunts");
	rmAddObjectDefItem(muskHunts, "guanaco", rmRandInt(12,13), 10.0);
	rmSetObjectDefCreateHerd(muskHunts, true);
	rmSetObjectDefMinDistance(muskHunts, 0);
	rmSetObjectDefMaxDistance(muskHunts, 10);
//	rmAddObjectDefConstraint(muskHunts, avoidWaterShort);	

//centre hunts
	rmPlaceObjectDefAtLoc(muskHunts, 0, 0.7, 0.7, 1);
	rmPlaceObjectDefAtLoc(muskHunts, 0, 0.3, 0.3, 1);
	if (cNumberNonGaiaPlayers >= 3)
{
	rmPlaceObjectDefAtLoc(muskHunts, 0, 0.5, 0.5, 1);
}


    int elkHunts = rmCreateObjectDef("elkHunts");
	rmAddObjectDefItem(elkHunts, "rhea", rmRandInt(9,9), 10.0);
	rmSetObjectDefCreateHerd(elkHunts, true);
	rmSetObjectDefMinDistance(elkHunts, 0);
	rmSetObjectDefMaxDistance(elkHunts, rmXFractionToMeters(0.47));
	rmAddObjectDefConstraint(elkHunts, circleConstraint);
	rmAddObjectDefConstraint(elkHunts, avoidTownCenter);
	rmAddObjectDefConstraint(elkHunts, avoidHunt);		rmAddObjectDefConstraint(elkHunts, avoidBerries);
	rmAddObjectDefConstraint(elkHunts, avoidPlateau);
	rmAddObjectDefConstraint(elkHunts, avoidWaterShort);	
//	rmAddObjectDefConstraint(elkHunts, avoidCoin);	
	rmPlaceObjectDefAtLoc(elkHunts, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);




	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.02)); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
//	rmAddObjectDefConstraint(nuggetID, avoidTownCenterMore); 
	rmAddObjectDefConstraint(nuggetID, avoidPlateau);
	rmAddObjectDefConstraint(nuggetID, cliffWater2);	
	rmAddObjectDefConstraint(nuggetID, avoidCoin);	
	rmSetNuggetDifficulty(3, 3); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 1);   

	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.22)); 
	rmSetNuggetDifficulty(2, 2); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.46)); 
	rmSetNuggetDifficulty(1, 1); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 9*cNumberNonGaiaPlayers);



	rmSetStatusText("",0.7);

int avoidTPSocket =rmCreateTypeDistanceConstraint("avoid trade socket", "SocketTradeRoute", 16.0);



	//removes loop for faster loading times
	//for (j=0; < (6*cNumberNonGaiaPlayers)) {   
		int mapTrees=rmCreateObjectDef("map trees");
		rmAddObjectDefItem(mapTrees, "TreeAraucania", rmRandInt(10,11), rmRandFloat(16.0,17.0));
		rmAddObjectDefItem(mapTrees, "UnderbrushPatagoniaDirt", rmRandInt(8,9), rmRandFloat(15.0,16.0));
		rmAddObjectDefToClass(mapTrees, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(mapTrees, 0);
		rmSetObjectDefMaxDistance(mapTrees, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(mapTrees, avoidTPSocket);
		rmAddObjectDefConstraint(mapTrees, avoidGold);
	  	rmAddObjectDefConstraint(mapTrees, avoidCoin);
		rmAddObjectDefConstraint(mapTrees, forestConstraint);
		rmAddObjectDefConstraint(mapTrees, avoidTownCenterSmall);	
		rmAddObjectDefConstraint(mapTrees, avoidNuggetSmall);	
		rmAddObjectDefConstraint(mapTrees, avoidWaterShort);
	//rmAddObjectDefConstraint(mapTrees, circleConstraint);
		rmPlaceObjectDefAtLoc(mapTrees, 0, 0.5, 0.5, 100*cNumberNonGaiaPlayers);
	//}
		rmSetStatusText("",0.8);



	rmSetStatusText("",0.9);


		int bonusTrees=rmCreateObjectDef("bonusTrees");
		rmAddObjectDefItem(bonusTrees, "TreeMadrone", rmRandInt(3,4), rmRandFloat(5.0,6.0));
	rmAddObjectDefToClass(bonusTrees, rmClassID("classForest")); 
	rmAddObjectDefConstraint(bonusTrees, forestConstraint);
	rmPlaceObjectDefInArea(bonusTrees, 0, cliffs, 6*cNumberNonGaiaPlayers);
	rmPlaceObjectDefInArea(bonusTrees, 0, cliffs2, 6*cNumberNonGaiaPlayers);



	int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "FishSardine", 12.0);
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);

	int fishID=rmCreateObjectDef("fish Mahi");
	rmAddObjectDefItem(fishID, "FishSardine", 1, 0.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, fishVsFishID);
	rmAddObjectDefConstraint(fishID, fishLand);
	rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 25*cNumberNonGaiaPlayers);




	rmSetStatusText("",0.99);


	}
