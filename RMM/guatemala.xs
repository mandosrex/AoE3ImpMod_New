/*
==============================
		Guatemala
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
	int playerTiles=13000;
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=12000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=11000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=10000;

	int size = 2.0 * sqrt(cNumberNonGaiaPlayers*playerTiles);

	rmSetMapSize(size, size);

	rmSetMapType("land");
        rmSetMapType("grass");
	rmSetMapType("amazonia");
	rmSetMapType("tropical");
	rmSetMapType("samerica");
	rmSetMapType("AIFishingUseful");
       	rmTerrainInitialize("grass");

	rmSetWorldCircleConstraint(false);

 	  rmSetGlobalRain( 0.6 );

		rmSetLightingSet("spc14abuffalo");

        rmDefineClass("classForest");
		rmDefineClass("classPlateau");
	rmSetSeaLevel(0.0);
		rmSetSeaType("guatemala");


		//Constraints
		int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 15.0);

        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.475), rmDegreesToRadians(0), rmDegreesToRadians(360));
       
		int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 16.0);
        int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
        
		int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 55.0);
		int avoidHuntSmall=rmCreateTypeDistanceConstraint("avoid hunts", "huntable", 20.0);

		int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 10.0);

        int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 24.0);

		int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);

		int waterCoin=rmCreateTypeDistanceConstraint("avoid coin smallest", "Mine", 8.0);


        int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 55.0);
        int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 10.0);
        int cliffWater = rmCreateTerrainDistanceConstraint("cliff avoids river", "Land", false, 0.01);
        int cliffWater2 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 1.5);
        int cliffWater3 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 2.5);


        int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 8.0);
        int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 25.0);
        
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 30.0);
        int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
        int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 60.0);  
       
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 48.0);


int avoidNuggetSmall =rmCreateTypeDistanceConstraint("avoid nuggs", "AbstractNugget", 10.0);

  int avoidBerries=rmCreateTypeDistanceConstraint("avoid berries", "berrybush", 20.0);
  int avoidBerriesSmall=rmCreateTypeDistanceConstraint("avoid berries smoll", "berrybush", 8.0);


int stayWest = rmCreatePieConstraint("Stay West",0.47,0.53, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(180),rmDegreesToRadians(0));

int stayEast = rmCreatePieConstraint("Stay East",0.53,0.47, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(180));


    
 // =============Player placement ======================= 



    float spawnSwitch = rmRandFloat(0,1.2);
//spawnSwitch = 0.1;


	if (cNumberTeams == 2){
		if (spawnSwitch <=0.6){

	if (cNumberNonGaiaPlayers == 2)
	{
	rmPlacePlayer(1, 0.3, 0.3);
	rmPlacePlayer(2, 0.7, 0.7);	}

			rmSetPlacementTeam(0);
		rmSetPlayerPlacementArea(0.05, 0.25, 0.3, 0.75);
			rmSetPlacementSection(0.05, 0.45);
			rmPlacePlayersCircular(0.4, 0.4, 0.0);
			rmSetPlacementTeam(1);
		rmSetPlayerPlacementArea(0.7, 0.25, 0.95, 0.75);
			rmSetPlacementSection(0.55, 0.95);
			rmPlacePlayersCircular(0.4, 0.4, 0.0);

		}else if(spawnSwitch <=1.2){

	if (cNumberNonGaiaPlayers == 2)
	{
		rmPlacePlayer(2, 0.3, 0.3);
		rmPlacePlayer(1, 0.7, 0.7);
	}

			rmSetPlacementTeam(1);
		rmSetPlayerPlacementArea(0.05, 0.25, 0.3, 0.75);
			rmSetPlacementSection(0.05, 0.45);
			rmPlacePlayersCircular(0.4, 0.4, 0.0);
			rmSetPlacementTeam(0);
		rmSetPlayerPlacementArea(0.7, 0.25, 0.95, 0.75);
			rmSetPlacementSection(0.55, 0.95);
			rmPlacePlayersCircular(0.4, 0.4, 0.0);

		}
	}else{
	//*************ffa placement********
			rmPlacePlayer(1, 0.22, 0.22);
			rmPlacePlayer(2, 0.78, 0.78);
			rmPlacePlayer(3, 0.78, 0.22);
			rmPlacePlayer(4, 0.22, 0.78);

	if (cNumberNonGaiaPlayers == 5){
			rmPlacePlayer(5, 0.5, 0.5);
}
	if (cNumberNonGaiaPlayers == 6){
			rmPlacePlayer(5, 0.5, 0.68);
			rmPlacePlayer(6, 0.5, 0.32);
}
	if (cNumberNonGaiaPlayers == 7){
			rmPlacePlayer(5, 0.5, 0.7);
			rmPlacePlayer(6, 0.5, 0.3);
			rmPlacePlayer(7, 0.3, 0.5);

}
	if (cNumberNonGaiaPlayers == 8){
			rmPlacePlayer(5, 0.5, 0.7);
			rmPlacePlayer(6, 0.5, 0.3);
			rmPlacePlayer(7, 0.7, 0.5);
			rmPlacePlayer(8, 0.3, 0.5);
}
	}

		
        chooseMercs();

        rmSetStatusText("",0.1); 


        int continent2 = rmCreateArea("continent");
        rmSetAreaSize(continent2, 1.0, 1.0);
        rmSetAreaLocation(continent2, 0.5, 0.5);
	   rmSetAreaMix(continent2, "amazon grass");
    //    rmSetAreaTerrainType(continent2, "carolinas\groundforest_car");       
 rmSetAreaBaseHeight(continent2, 0.0);
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

        
		rmSetStatusText("",0.2);


//define player areas

for(i=1; < cNumberNonGaiaPlayers + 1) {

    int PlayerArea1 = rmCreateArea("NeedLand1"+i);
        rmSetAreaSize(PlayerArea1, rmAreaTilesToFraction(500), rmAreaTilesToFraction(510));
		rmAddAreaToClass(PlayerArea1, rmClassID("classPlateau"));
		rmAddAreaToClass(PlayerArea1, rmClassID("patch"));
       rmSetAreaHeightBlend(PlayerArea1, 3);
        rmSetAreaLocation(PlayerArea1, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmSetAreaCoherence(PlayerArea1, 0.93);
        rmBuildArea(PlayerArea1);

}


//===========trade route=================
		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 6.0);      
       
        int tradeRouteID = rmCreateTradeRoute();

	if (cNumberTeams == 2){
        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.8); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.6, 0.55);
 	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.5); 
 	rmAddTradeRouteWaypoint(tradeRouteID, 0.4, 0.45); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.2); 
        rmBuildTradeRoute(tradeRouteID, "dirt");
 
        vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.25);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
            socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.75);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);


}else{

//ffa circular TP

        tradeRouteID = rmCreateTradeRoute();
        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
/*
	rmAddTradeRouteWaypoint(tradeRouteID, 0.8, 0.5); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 0.4);
 	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.5); 
 	rmAddTradeRouteWaypoint(tradeRouteID, 0.45, 0.6); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.2, 0.5); 
*/

	rmAddTradeRouteWaypoint(tradeRouteID, 0.22, 0.5); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 0.7); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.78); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.7, 0.7); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.78, 0.5); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.7, 0.3); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.22); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 0.3); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.22, 0.5); 
        rmBuildTradeRoute(tradeRouteID, "dirt");


	vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);
	socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID, 0.4);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);
	socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID, 0.65);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);
	socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID, 0.9);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);



}



		int oceanNW = rmCreateArea("flatland northwest");
		rmSetAreaSize(oceanNW, 0.05, 0.05); 
		rmSetAreaCoherence(oceanNW, .8);
		rmSetAreaLocation(oceanNW, .5, .98);	
		rmSetAreaBaseHeight(oceanNW, -1.0);
        rmSetAreaWaterType(oceanNW, "guatemala");
        rmSetAreaObeyWorldCircleConstraint(oceanNW, false);
		rmBuildArea(oceanNW);


		int oceanNE = rmCreateArea("flatland northeast");
		rmSetAreaSize(oceanNE, 0.05, 0.05); 
		rmSetAreaCoherence(oceanNE, .8);
		rmSetAreaLocation(oceanNE, .98, .5);	
		rmSetAreaBaseHeight(oceanNE, -1.0);
        rmSetAreaWaterType(oceanNE, "guatemala");
        rmSetAreaObeyWorldCircleConstraint(oceanNE, false);
		rmBuildArea(oceanNE);


		int oceanSW = rmCreateArea("flatland southwest");
		rmSetAreaSize(oceanSW, 0.05, 0.05); 
		rmSetAreaCoherence(oceanSW, .8);
		rmSetAreaLocation(oceanSW, .02, .5);	
		rmSetAreaBaseHeight(oceanSW, -1.0);
        rmSetAreaWaterType(oceanSW, "guatemala");
        rmSetAreaObeyWorldCircleConstraint(oceanSW, false);
		rmBuildArea(oceanSW);


		int oceanSE = rmCreateArea("flatland southeast");
		rmSetAreaSize(oceanSE, 0.05, 0.05); 
		rmSetAreaCoherence(oceanSE, .8);
		rmSetAreaLocation(oceanSE, .5, .02);	
		rmSetAreaBaseHeight(oceanSE, -1.0);
        rmSetAreaWaterType(oceanSE, "guatemala");
        rmSetAreaObeyWorldCircleConstraint(oceanSE, false);
		rmBuildArea(oceanSE);



		rmSetStatusText("",0.3);



//=============KOTH================

   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .05, 0);
   }



// BUILD NATIVE SITES

	//Choose Natives
	int subCiv0=-1;
	int subCiv1=-1;
	int subCiv2=-1;
	int subCiv3=-1;

//Aztecs are awesome

   if (rmAllocateSubCivs(2) == true)
   {
      subCiv0=rmGetCivID("Maya");
      rmEchoInfo("subCiv0 is Maya "+subCiv0);
      if (subCiv0 >= 0)
      rmSetSubCiv(0, "Maya");

	subCiv1=rmGetCivID("Maya");
	rmEchoInfo("subCiv1 is Maya"+subCiv1);
	if (subCiv1 >= 0)
	rmSetSubCiv(1, "Maya");
	}
	
	// Set up Natives	
	int nativeID0 = -1;
    int nativeID1 = -1;

	nativeID0 = rmCreateGrouping("Maya village 1", "native Maya village 4");
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 5.00);
	rmAddGroupingToClass(nativeID0, rmClassID("classPlateau"));

	nativeID1 = rmCreateGrouping("Maya village 2", "native Maya village 5");
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 5.00);
	rmAddGroupingToClass(nativeID1, rmClassID("classPlateau"));

//========place=====

	if (cNumberTeams == 2){
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.3, 0.8);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.7, 0.2);
	if (cNumberNonGaiaPlayers >= 7)
{
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.43, 0.63);
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.57, 0.37);
}
}else{
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.6, 0.6);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.4, 0.4);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.6, 0.4);
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.4, 0.6);

}





	if (cNumberNonGaiaPlayers == 2)
{
//=========2 player fixed mines============

  	int smollMines = rmCreateObjectDef("competitive gold");
	rmAddObjectDefItem(smollMines, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(smollMines, 0.0);
	rmSetObjectDefMaxDistance(smollMines, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.2, 0.3, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.3, 0.2, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.8, 0.7, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.7, 0.8, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.47, 0.6, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.53, 0.4, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.7, 0.5, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.3, 0.5, 1);


}


				


		rmSetStatusText("",0.4);
		//starting objects

	int flagLand = rmCreateTerrainDistanceConstraint("flags dont like land", "land", true, 18.0);


		
        int playerStart = rmCreateStartingUnitsObjectDef(5.0);
        rmSetObjectDefMinDistance(playerStart, 7.0);
        rmSetObjectDefMaxDistance(playerStart, 12.0);
	rmAddObjectDefConstraint(playerStart, avoidWaterShort);

       
        int goldID = rmCreateObjectDef("starting gold");
        rmAddObjectDefItem(goldID, "mine", 1, 3.0);
        rmSetObjectDefMinDistance(goldID, 16.0);
        rmSetObjectDefMaxDistance(goldID, 16.0);
        rmAddObjectDefConstraint(goldID, avoidCoin);
	rmAddObjectDefConstraint(goldID, avoidWaterShort);



        int berryID = rmCreateObjectDef("starting berries");
        rmAddObjectDefItem(berryID, "BerryBush", 5, 4.0);
        rmSetObjectDefMinDistance(berryID, 16.0);
        rmSetObjectDefMaxDistance(berryID, 17.0);
        rmAddObjectDefConstraint(berryID, avoidCoin);

        int treeID = rmCreateObjectDef("starting trees");
        rmAddObjectDefItem(treeID, "treeamazon", rmRandInt(6,7), 7.0);
        rmSetObjectDefMinDistance(treeID, 19.0);
        rmSetObjectDefMaxDistance(treeID, 21.0);
        rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
        rmAddObjectDefConstraint(treeID, avoidCoin);
	rmAddObjectDefConstraint(treeID, avoidWaterShort);

 
        int foodID = rmCreateObjectDef("starting hunt");
        rmAddObjectDefItem(foodID, "tapir", 8, 8.0);
        rmSetObjectDefMinDistance(foodID, 10.0);
        rmSetObjectDefMaxDistance(foodID, 12.0);
	rmAddObjectDefConstraint(foodID, avoidWaterShort);	
        rmSetObjectDefCreateHerd(foodID, false);

        int foodID2 = rmCreateObjectDef("starting hunt 2");
        rmAddObjectDefItem(foodID2, "capybara", 7, 8.0);
        rmSetObjectDefMinDistance(foodID2, 28.0);
        rmSetObjectDefMaxDistance(foodID2, 30.0);
        rmSetObjectDefCreateHerd(foodID2, true);
	rmAddObjectDefConstraint(foodID2, avoidWaterShort);	
	rmAddObjectDefConstraint(foodID2, circleConstraint);
  	rmAddObjectDefConstraint(foodID2, avoidHuntSmall);
	rmAddObjectDefConstraint(foodID2, avoidTradeRouteSmall);



		int foodID3 = rmCreateObjectDef("starting hunt 3");
        rmAddObjectDefItem(foodID3, "anteater", 8, 8.0);
        rmSetObjectDefMinDistance(foodID3, 57.0);
        rmSetObjectDefMaxDistance(foodID3, 59.0);
	rmAddObjectDefConstraint(foodID3, avoidWaterShort);	
	rmAddObjectDefConstraint(foodID3, circleConstraint);
        rmSetObjectDefCreateHerd(foodID3, true);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmSetNuggetDifficulty(1, 1); 
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 3.0);
    rmSetObjectDefMinDistance(playerNuggetID, 28.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 35.0);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
	rmAddObjectDefConstraint(playerNuggetID, avoidWaterShort);

	int extraberrywagon=rmCreateObjectDef("JapAn cAnT hUnT");
  rmAddObjectDefItem(extraberrywagon, "ypBerryWagon1", 1, 0.0);
  rmSetObjectDefMinDistance(extraberrywagon, 6.0);
  rmSetObjectDefMaxDistance(extraberrywagon, 7.0);



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
}
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
//        rmPlaceObjectDefAtLoc(foodID3, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
 //       rmPlaceObjectDefAtLoc(berryID , i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
//        rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));


if (rmGetPlayerCiv(i) == rmGetCivID("Japanese")) {
        rmPlaceObjectDefAtLoc(extraberrywagon, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        }

    int flag1 = rmFindCloserArea(rmPlayerLocXFraction(i), rmPlayerLocZFraction(i), oceanSW, oceanNE);


		int waterFlag = rmCreateObjectDef("HC water flag "+i);
         rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 5.0);
         rmSetObjectDefMinDistance(waterFlag, 16);
         rmSetObjectDefMaxDistance(waterFlag, 18);
	rmAddObjectDefConstraint(waterFlag, flagLand);
       rmPlaceObjectDefAtAreaLoc(waterFlag, i, flag1, 1);

		if ( rmGetNomadStart())
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


//	if (cNumberNonGaiaPlayers >= 3)
//{
  	int eastmine = rmCreateObjectDef("east mines");
	rmAddObjectDefItem(eastmine, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(eastmine, rmXFractionToMeters(0.0));
	rmSetObjectDefMaxDistance(eastmine, rmXFractionToMeters(0.43));
	rmAddObjectDefConstraint(eastmine, avoidCoinMed);
	rmAddObjectDefConstraint(eastmine, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(eastmine, avoidPlateau);	
	rmAddObjectDefConstraint(eastmine, avoidWaterShort);
	rmAddObjectDefConstraint(eastmine, avoidTownCenter);
//rmAddObjectDefConstraint(eastmine, stayEast);
	rmAddObjectDefConstraint(eastmine, circleConstraint);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
//}
	


    int capybaraWater = rmCreateObjectDef("capybaraWater");
	rmAddObjectDefItem(capybaraWater, "capybara", rmRandInt(5,6), 12.0);
	rmSetObjectDefCreateHerd(capybaraWater, true);
	rmSetObjectDefMinDistance(capybaraWater, 0);
	rmSetObjectDefMaxDistance(capybaraWater, rmXFractionToMeters(0.43));
	rmAddObjectDefConstraint(capybaraWater, circleConstraint);
//	rmAddObjectDefConstraint(capybaraWater, avoidTownCenter);
	rmAddObjectDefConstraint(capybaraWater, avoidHunt);
//	rmAddObjectDefConstraint(capybaraWater, waterHunt);
	rmAddObjectDefConstraint(capybaraWater, avoidPlateau);
//	rmAddObjectDefConstraint(capybaraWater, avoidWaterShort);	
	rmAddObjectDefConstraint(capybaraWater, avoidCoin);	
	rmPlaceObjectDefAtLoc(capybaraWater, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);


    int elkHunts = rmCreateObjectDef("elkHunts");
	rmAddObjectDefItem(elkHunts, "anteater", rmRandInt(6,7), 8.0);
	rmSetObjectDefCreateHerd(elkHunts, true);
	rmSetObjectDefMinDistance(elkHunts, 0);
	rmSetObjectDefMaxDistance(elkHunts, rmXFractionToMeters(0.43));
	rmAddObjectDefConstraint(elkHunts, circleConstraint);
	rmAddObjectDefConstraint(elkHunts, avoidTownCenter);
	rmAddObjectDefConstraint(elkHunts, avoidHunt);
	//rmAddObjectDefConstraint(elkHunts, waterHunt);
	//rmAddObjectDefConstraint(elkHunts, avoidPlateau);
	rmAddObjectDefConstraint(elkHunts, avoidWaterShort);	
	rmAddObjectDefConstraint(elkHunts, avoidCoin);	
	rmPlaceObjectDefAtLoc(elkHunts, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);


	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.15)); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
//	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
	rmAddObjectDefConstraint(nuggetID, forestConstraintShort);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
	//rmAddObjectDefConstraint(nuggetID, avoidTownCenterMore); 
	rmAddObjectDefConstraint(nuggetID, avoidPlateau);
	rmAddObjectDefConstraint(nuggetID, avoidWaterShort);	
	rmAddObjectDefConstraint(nuggetID, avoidCoin);	
	rmSetNuggetDifficulty(3, 4); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);   
//weaker nuggets
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.40)); 
	rmSetNuggetDifficulty(2, 3); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);   


	rmSetStatusText("",0.7);

		int mapTrees=rmCreateObjectDef("map trees");
		rmAddObjectDefItem(mapTrees, "TreeYucatan", rmRandInt(7,8), rmRandFloat(10.0,12.0));
		rmAddObjectDefItem(mapTrees, "UnderbrushYucatan", rmRandInt(1,1), rmRandFloat(20.0,24.0));
		rmAddObjectDefToClass(mapTrees, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(mapTrees, 0);
		rmSetObjectDefMaxDistance(mapTrees, rmXFractionToMeters(0.48));
		rmAddObjectDefConstraint(mapTrees, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(mapTrees, avoidNuggetSmall);
	  	rmAddObjectDefConstraint(mapTrees, avoidCoin);
		rmAddObjectDefConstraint(mapTrees, forestConstraint);
		rmAddObjectDefConstraint(mapTrees, avoidTownCenter);	
		rmAddObjectDefConstraint(mapTrees, avoidPlateau);	
		rmAddObjectDefConstraint(mapTrees, avoidWaterShort);
		rmAddObjectDefConstraint(mapTrees, circleConstraint);
		rmPlaceObjectDefAtLoc(mapTrees, 0, 0.5, 0.5, 50*cNumberNonGaiaPlayers);
	


		rmSetStatusText("",0.8);



	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 5.0);

  int avoidFish =rmCreateTypeDistanceConstraint("avoid fish", "FishBass", 3.0);

	rmSetStatusText("",0.9);


	int whaleID=rmCreateObjectDef("whale");
	rmAddObjectDefItem(whaleID, "MinkeWhale", 1, 0.0);

	rmPlaceObjectDefAtLoc(whaleID, 0, 0.43, 0.93, 1);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.57, 0.93, 1);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.07, 0.43, 1);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.07, 0.57, 1);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.45, 0.07, 1);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.55, 0.07, 1);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.93, 0.45, 1);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.93, 0.55, 1);

if (cNumberNonGaiaPlayers >= 4)
	{
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.88, 1);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.12, 1);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.12, 0.5, 1);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.88, 0.5, 1);

	}


	int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "MinkeWhale", 3.0);




	int fishID=rmCreateObjectDef("fish Mahi");
	rmAddObjectDefItem(fishID, "FishBass", 1, 0.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
//	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, fishLand);
	rmAddObjectDefConstraint(fishID, whaleVsWhaleID);
	rmAddObjectDefConstraint(fishID, avoidFish);

rmPlaceObjectDefInArea(fishID, 0, oceanNW, 4*cNumberNonGaiaPlayers);
rmPlaceObjectDefInArea(fishID, 0, oceanSW, 4*cNumberNonGaiaPlayers);
rmPlaceObjectDefInArea(fishID, 0, oceanNE, 4*cNumberNonGaiaPlayers);
rmPlaceObjectDefInArea(fishID, 0, oceanSE, 4*cNumberNonGaiaPlayers);

	rmSetStatusText("",0.99);



}
 
