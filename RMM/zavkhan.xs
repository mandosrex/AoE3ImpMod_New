/*
==============================
		 Zavkhan
          by dansil92
==============================
*/

// observer UI by Aizamk

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";
 

// Main entry point for random map script


void main(void) {


   // Picks the map size
	int playerTiles= 9000;
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=8500;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=7000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=6500;


	int size = 2.0 * sqrt(cNumberNonGaiaPlayers*playerTiles);

	if (cNumberTeams >= 3){
	size = 3 * sqrt(cNumberNonGaiaPlayers*playerTiles);
}


	rmSetMapSize(size, 1.4*size);

	rmSetMapType("land");
        rmSetMapType("desert");
	rmSetMapType("mongolia");
	rmSetMapType("asia");
	//rmSetMapType("tropical");
       	rmTerrainInitialize("grass");
	rmEnableLocalWater(true);
 //	  rmSetGlobalRain( 0.6 );
		rmSetWindMagnitude(4.0);

	rmSetWorldCircleConstraint(false);

		rmSetLightingSet("california");

        rmDefineClass("classForest");
		rmDefineClass("classPlateau");
	rmSetSeaLevel(0.0);
		rmSetSeaType("yucatan Coast");


		//Constraints
		int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 13.0);

        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.475), rmDegreesToRadians(0), rmDegreesToRadians(360));
       
		int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 23.0);
        int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
        
		int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 55.0);
		int avoidHuntSmall=rmCreateTypeDistanceConstraint("avoid hunts", "huntable", 20.0);

		int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 14.0);

        int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 60.0);

		int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "mineCopper", 10.0);

		int waterCoin=rmCreateTypeDistanceConstraint("avoid coin smallest", "mineCopper", 8.0);


        int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "mineCopper", 49.0);
        int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 8.0);





//this constraint determines how far the cliffs stay aways from the river. ffa has a much further distance to ensure adequate space for players


int playerFactor = 1.5*cNumberNonGaiaPlayers;

	if (cNumberNonGaiaPlayers >= 5){
	playerFactor = 1.8*cNumberNonGaiaPlayers;
}

	if (cNumberNonGaiaPlayers >= 5 && cNumberTeams >= 3){
	playerFactor = 45;
}
        int cliffWater = rmCreateTerrainDistanceConstraint("cliff avoids river", "Land", false, 25+playerFactor);




        int cliffWater2 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 1.5);
        int cliffWater3 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 2.5);


        int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 8.0);
        int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 25.0);
        
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 30.0);
        int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
        int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 55.0);  
       
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 48.0);


int avoidNuggetSmall =rmCreateTypeDistanceConstraint("avoid nuggs", "AbstractNugget", 10.0);

  int avoidBerries=rmCreateTypeDistanceConstraint("avoid berries", "berrybush", 20.0);
  int avoidBerriesSmall=rmCreateTypeDistanceConstraint("avoid berries smoll", "berrybush", 8.0);


int stayWest = rmCreatePieConstraint("Stay West",0.47,0.53, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(180),rmDegreesToRadians(0));

int stayEast = rmCreatePieConstraint("Stay East",0.53,0.47, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(180));

int avoidTemple=rmCreateTypeDistanceConstraint("avoid temples", "SPCAztecTemple", 12.0);

   


    
 	//========= Player placing========= 
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);


    float spawnSwitch = rmRandFloat(0,1.2);
//spawnSwitch = 0.1;




	if (cNumberTeams == 2){
		if (spawnSwitch <=0.6){

	if (cNumberNonGaiaPlayers == 2)
	{
	rmPlacePlayer(1, 0.5, 0.9);
	rmPlacePlayer(2, 0.5, 0.1);	}

	if (cNumberNonGaiaPlayers == 4)
	{			
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.35, 0.92, 0.71, 0.9, 0, 0);
		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.65, 0.08, 0.29, 0.1, 0, 0);

	}

			rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.25, 0.89, 0.75, 0.89, 0, 0);
			rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.75, 0.11, 0.25, 0.11, 0, 0);

		}else if(spawnSwitch <=1.2){

	if (cNumberNonGaiaPlayers == 2)
	{
	rmPlacePlayer(2, 0.5, 0.9);
	rmPlacePlayer(1, 0.5, 0.1);	}

	if (cNumberNonGaiaPlayers == 4)
	{			
		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.35, 0.92, 0.65, 0.85, 0, 0);
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.65, 0.08, 0.35, 0.15, 0, 0);

	}

		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.35, 0.89, 0.75, 0.89, 0, 0);
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.65, 0.11, 0.25, 0.11, 0, 0);

		}
	}else{
//rmPlacePlayersRiver(riverID, 0.0, 0.0, 35);


	//*************ffa placement********
			rmPlacePlayer(1, 0.2, 0.2);
			rmPlacePlayer(2, 0.8, 0.8);
			rmPlacePlayer(3, 0.8, 0.31);
			rmPlacePlayer(4, 0.2, 0.69);

	if (cNumberNonGaiaPlayers == 5){
			rmPlacePlayer(5, 0.5, 0.75);
}
	if (cNumberNonGaiaPlayers == 6){
			rmPlacePlayer(5, 0.8, 0.5);
			rmPlacePlayer(6, 0.2, 0.5);
}
	if (cNumberNonGaiaPlayers == 7){
			rmPlacePlayer(5, 0.8, 0.5);
			rmPlacePlayer(6, 0.2, 0.5);
			rmPlacePlayer(7, 0.4, 0.91);

}
	if (cNumberNonGaiaPlayers == 8){

			rmPlacePlayer(5, 0.4, 0.91);
			rmPlacePlayer(6, 0.6, 0.09);
			rmPlacePlayer(7, 0.8, 0.5);
			rmPlacePlayer(8, 0.2, 0.5);
}

	}

		
        chooseMercs();

        rmSetStatusText("",0.1); 


        int continent2 = rmCreateArea("continent");
        rmSetAreaSize(continent2, 1.0, 1.0);
        rmSetAreaLocation(continent2, 0.5, 0.5);
	   rmSetAreaMix(continent2, "africa_grass");
    //    rmSetAreaTerrainType(continent2, "carolinas\groundforest_car");       
 rmSetAreaBaseHeight(continent2, 0.0);
        rmSetAreaCoherence(continent2, 1.0);
   //     rmSetAreaSmoothDistance(continent2, 6);
        rmSetAreaHeightBlend(continent2, 3);
		rmSetAreaEdgeFilling(continent2, 1.0);
        rmSetAreaElevationNoiseBias(continent2, 0);
        rmSetAreaElevationEdgeFalloffDist(continent2, 10);
        rmSetAreaElevationVariation(continent2, 3);
        rmSetAreaElevationPersistence(continent2, .2);
        rmSetAreaElevationOctaves(continent2, 5);
        rmSetAreaElevationMinFrequency(continent2, 0.04);
        rmSetAreaElevationType(continent2, cElevTurbulence);  
        rmBuildArea(continent2);    

		int classPatch = rmDefineClass("patch");
		int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 9.0);
		int classCenter = rmDefineClass("center");
		int avoidCenter = rmCreateClassDistanceConstraint("avoid center", rmClassID("center"), 20.0);
		int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
        

	rmSetStatusText("",0.2);


//===================River=====================

//	int cNumberTeams = cNumberTeams;
//	 cNumberPlayers = cNumberPlayers;
	string riverType = "Africa River";


	int riverID = rmRiverCreate(-5, riverType, 8, 8, 4+cNumberPlayers/2, 4.1+cNumberPlayers/2); 

  rmRiverAddWaypoint(riverID, 0.0, 1.17);
  rmRiverAddWaypoint(riverID, 0.5, 1.08);
  rmRiverAddWaypoint(riverID, 0.75, 0.93);
  rmRiverAddWaypoint(riverID, 0.7, 0.78);
 
 rmRiverAddWaypoint(riverID, 0.5, .7);

 rmRiverAddWaypoint(riverID, 0.3, .62);
 rmRiverAddWaypoint(riverID, 0.25, .47);

  rmRiverAddWaypoint(riverID, 0.5, .32);

  rmRiverAddWaypoint(riverID, 1.0, .23);

	rmRiverSetShallowRadius(riverID, 16);

		rmRiverAddShallow(riverID, 0.12);
		rmRiverAddShallow(riverID, 0.5);
		rmRiverAddShallow(riverID, 0.88);

	if (cNumberNonGaiaPlayers >= 3){
	rmRiverSetShallowRadius(riverID, 12);
		rmRiverAddShallow(riverID, 0.28);
		rmRiverAddShallow(riverID, 0.72);
	}

	rmRiverBuild(riverID);
	//rmRiverReveal(riverID, 2);



//===========trade route=================

		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 8.0);   
	//rmAddObjectDefConstraint(socketID, avoidWaterShort);	
   
       
        int tradeRouteID = rmCreateTradeRoute();


        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

	rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 0.73);
 	rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.71); 
 	rmAddTradeRouteWaypoint(tradeRouteID, 0.4, 0.70); 

	rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 0.65);

 	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.55); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.5); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.45); 

 	rmAddTradeRouteWaypoint(tradeRouteID, 0.45, 0.35); 

 	rmAddTradeRouteWaypoint(tradeRouteID, 0.6, 0.30); 
 	rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.29); 
 	rmAddTradeRouteWaypoint(tradeRouteID, 1.0, 0.27); 

        rmBuildTradeRoute(tradeRouteID, "water");



//====================================================



	if (cNumberNonGaiaPlayers == 2){
	rmPlaceObjectDefAtLoc(socketID, 0, 0.47, 0.68);
	rmPlaceObjectDefAtLoc(socketID, 0, 0.53, 0.32);

}else{
        vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.28);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
            socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.72);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
	if (cNumberNonGaiaPlayers >= 4)
	{
            socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.12);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
            socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.88);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
}
	
	if (cNumberNonGaiaPlayers >= 7)
	{
            socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.44);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
            socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.56);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);


}
}
//====================================================
	rmSetStatusText("",0.3);
//===================================================

//define player areas

for(i=1; < cNumberNonGaiaPlayers + 1) {

    int PlayerArea1 = rmCreateArea("NeedLand1"+i);
        rmSetAreaSize(PlayerArea1, rmAreaTilesToFraction(1300), rmAreaTilesToFraction(1300));
//		rmAddAreaToClass(PlayerArea1, rmClassID("classPlateau"));
		rmAddAreaToClass(PlayerArea1, rmClassID("patch"));
       rmSetAreaHeightBlend(PlayerArea1, 3);
        rmSetAreaLocation(PlayerArea1, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmSetAreaCoherence(PlayerArea1, 0.93);
        rmBuildArea(PlayerArea1);

}

	if (cNumberTeams == 2){


		int oceanNW = rmCreateArea("northwest");
		rmSetAreaSize(oceanNW, 0.07, 0.07); 
		rmSetAreaCoherence(oceanNW, .92);
		rmSetAreaLocation(oceanNW, .5, .95);	
	rmAddAreaToClass(oceanNW, rmClassID("patch"));
  //      rmSetAreaTerrainType(oceanNW, "great_plains\ground5_gp");
        rmAddAreaInfluenceSegment(oceanNW, 0.65, 0.9, 0.4, 0.9);

		rmBuildArea(oceanNW);

		int oceanNE = rmCreateArea("flatland northeast");
		rmSetAreaSize(oceanNE, 0.07, 0.07); 
		rmSetAreaCoherence(oceanNE, .92);
		rmSetAreaLocation(oceanNE, .5, .05);	
	rmAddAreaToClass(oceanNE, rmClassID("patch"));
        rmAddAreaInfluenceSegment(oceanNE, 0.6, 0.1, 0.35, 0.1);
		rmBuildArea(oceanNE);

}


		rmSetStatusText("",0.4);
//=========================================

	if (cNumberNonGaiaPlayers == 2)
{
//=========2 player fixed mines============

  	int smollMines = rmCreateObjectDef("competitive gold");
	rmAddObjectDefItem(smollMines, "mineCopper", 1, 1.0);
	rmSetObjectDefMinDistance(smollMines, 0.0);
	rmSetObjectDefMaxDistance(smollMines, 3.0);

//centre map
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.45, 0.62, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.55, 0.38, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.73, 0.48, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.27, 0.52, 1);

//behind base
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.3, 0.07);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.7, 0.93);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.8, 0.11);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.2, 0.89);
//starting
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.42, 0.885);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.58, 0.115);
//awkward tp spot
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.09, 0.715);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.91, 0.285);

}

int avoidTPSocket =rmCreateTypeDistanceConstraint("avoid trade socket", "SocketTradeRoute", 11.0);



		int cliffSouthWest = rmCreateArea("cliffs southwest");
		rmSetAreaSize(cliffSouthWest, 0.35, 0.35); 
	rmAddAreaToClass(cliffSouthWest, rmClassID("classPlateau"));
	rmAddAreaToClass(cliffSouthWest, rmClassID("center"));
		rmSetAreaCliffType(cliffSouthWest, "Africa2");
        rmSetAreaHeightBlend(cliffSouthWest, 4);
		rmSetAreaCliffEdge(cliffSouthWest, 1, 1.0, 0.0, 0.0, 2); //4,.225 looks cool too
		rmSetAreaCliffPainting(cliffSouthWest, true, true, true, 0.4, true);
		rmSetAreaCliffHeight(cliffSouthWest, 8, 0.1, 0.5);
	   rmSetAreaMix(cliffSouthWest, "cave_top");
        rmSetAreaTerrainType(cliffSouthWest, "cave\cave_top");
		rmSetAreaCoherence(cliffSouthWest, .93);
		rmSetAreaLocation(cliffSouthWest, .05, .6);	
	rmAddAreaConstraint(cliffSouthWest, cliffWater);
	rmAddAreaConstraint(cliffSouthWest, avoidPlateau);
	rmAddAreaConstraint(cliffSouthWest, avoidTradeRouteSmall);
	rmAddAreaConstraint(cliffSouthWest, avoidPatch);
	rmAddAreaConstraint(cliffSouthWest, avoidCoin);
	rmAddAreaConstraint(cliffSouthWest, avoidTPSocket);
 //       rmAddAreaInfluenceSegment(cliffSouthWest, 0.05, 0.15, 0.15, 0.05);
		rmBuildArea(cliffSouthWest);


		int cliffNorthEast = rmCreateArea("cliffs northeast");
		rmSetAreaSize(cliffNorthEast, 0.35, 0.35); 
	rmAddAreaToClass(cliffNorthEast, rmClassID("classPlateau"));
	rmAddAreaToClass(cliffNorthEast, rmClassID("center"));
		rmSetAreaCliffType(cliffNorthEast, "Africa2");
        rmSetAreaHeightBlend(cliffNorthEast, 4);
		rmSetAreaCliffEdge(cliffNorthEast, 1, 1.0, 0.0, 0.0, 2); //4,.225 looks cool too
		rmSetAreaCliffPainting(cliffNorthEast, true, true, true, 0.4, true);
		rmSetAreaCliffHeight(cliffNorthEast, 8, 0.1, 0.5);
	   rmSetAreaMix(cliffNorthEast, "cave_top");
        rmSetAreaTerrainType(cliffNorthEast, "cave\cave_top");
		rmSetAreaCoherence(cliffNorthEast, .93);
		rmSetAreaLocation(cliffNorthEast, .95, .4);	
	rmAddAreaConstraint(cliffNorthEast, cliffWater);
	rmAddAreaConstraint(cliffNorthEast, avoidPlateau);
	rmAddAreaConstraint(cliffNorthEast, avoidTradeRouteSmall);
	rmAddAreaConstraint(cliffNorthEast, avoidPatch);
	rmAddAreaConstraint(cliffNorthEast, avoidCoin);
	rmAddAreaConstraint(cliffNorthEast, avoidTPSocket);
 //       rmAddAreaInfluenceSegment(cliffNorthEast, 0.05, 0.15, 0.15, 0.05);
		rmBuildArea(cliffNorthEast);



		rmSetStatusText("",0.45);
		//starting objects


		
        int playerStart = rmCreateStartingUnitsObjectDef(5.0);
        rmSetObjectDefMinDistance(playerStart, 6.0);
        rmSetObjectDefMaxDistance(playerStart, 12.0);
	rmAddObjectDefConstraint(playerStart, avoidWaterShort);
	rmAddObjectDefConstraint(playerStart, avoidTemple);

       
        int goldID = rmCreateObjectDef("starting gold");
        rmAddObjectDefItem(goldID, "mineCopper", 1, 3.0);
        rmSetObjectDefMinDistance(goldID, 14.0);
        rmSetObjectDefMaxDistance(goldID, 16.0);
        rmAddObjectDefConstraint(goldID, avoidCoin);
	rmAddObjectDefConstraint(goldID, avoidWaterShort);
	rmAddObjectDefConstraint(goldID, avoidTemple);


        int berryID = rmCreateObjectDef("starting berries");
        rmAddObjectDefItem(berryID, "BerryBush", 4, 4.0);
        rmSetObjectDefMinDistance(berryID, 15.0);
        rmSetObjectDefMaxDistance(berryID, 17.0);
        rmAddObjectDefConstraint(berryID, avoidCoin);
 	rmAddObjectDefConstraint(berryID, avoidTemple);

        int treeID = rmCreateObjectDef("starting trees");
        rmAddObjectDefItem(treeID, "ypTreeMongolia", rmRandInt(6,7), 7.0);
        rmSetObjectDefMinDistance(treeID, 19.0);
        rmSetObjectDefMaxDistance(treeID, 21.0);
        rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
        rmAddObjectDefConstraint(treeID, avoidCoin);
	rmAddObjectDefConstraint(treeID, avoidWaterShort);
 	rmAddObjectDefConstraint(treeID, avoidTemple);

 
        int scoutID = rmCreateObjectDef("starting scout");
        rmAddObjectDefItem(scoutID, "ypMongolScout", 1, 2.0);
        rmSetObjectDefMinDistance(scoutID, 12.0);
        rmSetObjectDefMaxDistance(scoutID, 14.0);
        rmAddObjectDefConstraint(scoutID, avoidTownCenterSmall);
        rmAddObjectDefConstraint(scoutID, avoidCoin);
	rmAddObjectDefConstraint(scoutID, avoidWaterShort);
 	rmAddObjectDefConstraint(scoutID, avoidTemple);


        int foodID = rmCreateObjectDef("starting hunt");
        rmAddObjectDefItem(foodID, "ypMarcoPoloSheep", 8, 6.0);
        rmSetObjectDefMinDistance(foodID, 10.0);
        rmSetObjectDefMaxDistance(foodID, 12.0);
	rmAddObjectDefConstraint(foodID, avoidCoin);	
        rmSetObjectDefCreateHerd(foodID, false);
  	rmAddObjectDefConstraint(foodID, avoidTemple);

        int foodID2 = rmCreateObjectDef("starting hunt 2");
        rmAddObjectDefItem(foodID2, "ypNilgai", 7, 8.0);
        rmSetObjectDefMinDistance(foodID2, 28.0);
        rmSetObjectDefMaxDistance(foodID2, 30.0);
        rmSetObjectDefCreateHerd(foodID2, true);
	rmAddObjectDefConstraint(foodID2, avoidWaterShort);	
	rmAddObjectDefConstraint(foodID2, avoidPlateau);
  	rmAddObjectDefConstraint(foodID2, avoidTemple);
  	rmAddObjectDefConstraint(foodID2, avoidHuntSmall);
	rmAddObjectDefConstraint(foodID2, avoidTradeRouteSmall);

                       
		int foodID3 = rmCreateObjectDef("starting hunt 3");
        rmAddObjectDefItem(foodID3, "ypMarcoPoloSheep", 8, 8.0);
        rmSetObjectDefMinDistance(foodID3, 57.0);
        rmSetObjectDefMaxDistance(foodID3, 59.0);
	rmAddObjectDefConstraint(foodID3, avoidWaterShort);	
	rmAddObjectDefConstraint(foodID3, avoidPlateau);
        rmSetObjectDefCreateHerd(foodID3, true);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmSetNuggetDifficulty(1, 1); 
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 3.0);
    rmSetObjectDefMinDistance(playerNuggetID, 27.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 29.0);
//	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
	rmAddObjectDefConstraint(playerNuggetID, avoidWaterShort);	
  	rmAddObjectDefConstraint(playerNuggetID, avoidTemple);

	int extraberrywagon=rmCreateObjectDef("JapAn cAnT hUnT");
  rmAddObjectDefItem(extraberrywagon, "ypBerryWagon1", 1, 0.0);
  rmSetObjectDefMinDistance(extraberrywagon, 8.0);
  rmSetObjectDefMaxDistance(extraberrywagon, 10.0);


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
        rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

	if (cNumberNonGaiaPlayers >= 3){
        rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID3, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}

        rmPlaceObjectDefAtLoc(scoutID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(berryID , i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
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


   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .1, 0);
   }


	/*
	==================
	resource placement
	==================
	*/


//	if (cNumberNonGaiaPlayers >= 3)
//{
  	int copperMine = rmCreateObjectDef("east mines");
	rmAddObjectDefItem(copperMine, "mineCopper", 1, 1.0);
	rmSetObjectDefMinDistance(copperMine, rmXFractionToMeters(0.0));
	rmSetObjectDefMaxDistance(copperMine, rmXFractionToMeters(0.8));
	rmAddObjectDefConstraint(copperMine, avoidCoinMed);
	rmAddObjectDefConstraint(copperMine, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(copperMine, avoidPlateau);	
	rmAddObjectDefConstraint(copperMine, avoidWaterShort);
	rmAddObjectDefConstraint(copperMine, avoidTownCenter);
//	rmAddObjectDefConstraint(copperMine, circleConstraint);
	rmPlaceObjectDefAtLoc(copperMine, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
//}
	


	rmSetStatusText("",0.7);


    int muskHunts = rmCreateObjectDef("muskHunts");
	rmAddObjectDefItem(muskHunts, "ypNilgai", rmRandInt(9,10), 9.0);
	rmSetObjectDefCreateHerd(muskHunts, true);
	rmSetObjectDefMinDistance(muskHunts, 0);
	rmSetObjectDefMaxDistance(muskHunts, 5);
//	rmAddObjectDefConstraint(muskHunts, circleConstraint);
	rmAddObjectDefConstraint(muskHunts, avoidWaterShort);	


	if (cNumberNonGaiaPlayers == 2){	
//centre hunts
	rmPlaceObjectDefAtLoc(muskHunts, 0, 0.5, 0.6, 1);
	rmPlaceObjectDefAtLoc(muskHunts, 0, 0.5, 0.4, 1);
//2nd hunt
	rmPlaceObjectDefAtLoc(muskHunts, 0, 0.57, 0.93, 1);
	rmPlaceObjectDefAtLoc(muskHunts, 0, 0.43, 0.07, 1);
//3rd hunt
	rmPlaceObjectDefAtLoc(muskHunts, 0, 0.13, 0.91, 1);
	rmPlaceObjectDefAtLoc(muskHunts, 0, 0.87, 0.09, 1);
//4th hunt
	rmPlaceObjectDefAtLoc(muskHunts, 0, 0.65, 0.8, 1);
	rmPlaceObjectDefAtLoc(muskHunts, 0, 0.35, 0.2, 1);


}else{	
	rmAddObjectDefConstraint(muskHunts, avoidTownCenter);
	rmAddObjectDefConstraint(muskHunts, avoidHunt);	//rmAddObjectDefConstraint(muskHunts, waterHunt);
	rmAddObjectDefConstraint(muskHunts, avoidPlateau);
	rmAddObjectDefConstraint(muskHunts, avoidCoin);	
	rmAddObjectDefConstraint(muskHunts, avoidTemple);
	rmSetObjectDefMaxDistance(muskHunts, rmXFractionToMeters(0.8));
	rmPlaceObjectDefAtLoc(muskHunts, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

}

    int waterSheep = rmCreateObjectDef("waterSheep");
	rmAddObjectDefItem(waterSheep, "ypMarcoPoloSheep", rmRandInt(8,9), 7.0);
	rmSetObjectDefCreateHerd(waterSheep, true);
	rmSetObjectDefMinDistance(waterSheep, 0);
	rmSetObjectDefMaxDistance(waterSheep, rmXFractionToMeters(0.8));
//	rmAddObjectDefConstraint(waterSheep, circleConstraint);
//	rmAddObjectDefConstraint(waterSheep, avoidTownCenter);
	rmAddObjectDefConstraint(waterSheep, avoidHunt);		rmAddObjectDefConstraint(waterSheep, waterHunt);
	rmAddObjectDefConstraint(waterSheep, avoidPlateau);
//	rmAddObjectDefConstraint(waterSheep, avoidWaterShort);	
	rmAddObjectDefConstraint(waterSheep, avoidCoin);
	rmAddObjectDefConstraint(waterSheep, avoidTemple);		
	rmPlaceObjectDefAtLoc(waterSheep, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);


  	int theGoat = rmCreateObjectDef("goats");
	rmAddObjectDefItem(theGoat, "ypGoat", rmRandInt(2,2), 4.0);
	rmSetObjectDefMinDistance(theGoat, 0.0);
	rmSetObjectDefMaxDistance(theGoat, 5.0);
	rmPlaceObjectDefAtLoc(theGoat, 0, 0.5, 0.5, 1);
	rmPlaceObjectDefAtLoc(theGoat, 0, 0.13, 0.74);
	rmPlaceObjectDefAtLoc(theGoat, 0, 0.87, 0.26);


	rmAddObjectDefConstraint(theGoat, avoidWaterShort);	

	if (cNumberNonGaiaPlayers == 2){	

	rmPlaceObjectDefAtLoc(theGoat, 0, 0.15, 0.3, 1);
	rmPlaceObjectDefAtLoc(theGoat, 0, 0.85, 0.7, 1);


}else{

	rmSetObjectDefMaxDistance(theGoat, rmXFractionToMeters(0.6));
	rmAddObjectDefConstraint(theGoat, avoidHerd);
	rmAddObjectDefConstraint(theGoat, avoidPlateau);	
	rmAddObjectDefConstraint(theGoat, avoidHuntSmall);
	rmAddObjectDefConstraint(theGoat, avoidTownCenter);

	rmPlaceObjectDefAtLoc(theGoat, 0, 0.5, 0.5, 2.5*cNumberNonGaiaPlayers);
}
		rmSetStatusText("",0.8);

	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.3)); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
//	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
	rmAddObjectDefConstraint(nuggetID, forestConstraintShort);
//	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
//	rmAddObjectDefConstraint(nuggetID, avoidTownCenterMore); 
	rmAddObjectDefConstraint(nuggetID, avoidPlateau);
	rmAddObjectDefConstraint(nuggetID, avoidWaterShort);	
	rmAddObjectDefConstraint(nuggetID, avoidCoin);	
	rmSetNuggetDifficulty(3, 3); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);   
//weaker nuggets
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.68)); 
	rmSetNuggetDifficulty(1, 2); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);   



		int mapTrees=rmCreateObjectDef("map trees");
		rmAddObjectDefItem(mapTrees, "ypTreeMongolianFir", rmRandInt(8,9), rmRandFloat(13.0,14.0));
		rmAddObjectDefItem(mapTrees, "ypTreeMongolia", rmRandInt(4,5), rmRandFloat(18.0,19.0));
		rmAddObjectDefItem(mapTrees, "UnderbrushDeccan", rmRandInt(4,5), rmRandFloat(8.0,9.0));
		rmAddObjectDefToClass(mapTrees, rmClassID("classForest")); 

		rmPlaceObjectDefAtLoc(mapTrees, 0, 0.07, 0.76, 1);
		rmPlaceObjectDefAtLoc(mapTrees, 0, 0.93, 0.24, 1);

		rmSetObjectDefMinDistance(mapTrees, 0);
		rmSetObjectDefMaxDistance(mapTrees, rmXFractionToMeters(0.9));
		rmAddObjectDefConstraint(mapTrees, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(mapTrees, avoidNuggetSmall);
	  	rmAddObjectDefConstraint(mapTrees, avoidCoin);
		rmAddObjectDefConstraint(mapTrees, forestConstraint);
		rmAddObjectDefConstraint(mapTrees, avoidTownCenter);	
		rmAddObjectDefConstraint(mapTrees, avoidPlateau);	
		rmAddObjectDefConstraint(mapTrees, avoidWaterShort);
  //	rmAddObjectDefConstraint(mapTrees, avoidTemple);
	rmAddObjectDefConstraint(mapTrees, avoidTPSocket);
		rmPlaceObjectDefAtLoc(mapTrees, 0, 0.5, 0.5, 60*cNumberNonGaiaPlayers);
	

	rmSetStatusText("",0.9);




	}
 
