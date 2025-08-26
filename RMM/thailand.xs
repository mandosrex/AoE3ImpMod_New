/*
==============================
	      Thailand
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

	if (cNumberTeams >= 3){
 size = (size*1.4);
}

	rmSetMapType("land");
        rmSetMapType("grass");
	rmSetMapType("borneo");
	rmSetMapType("tropical");
	rmSetMapType("asia");

	//rmSetWorldCircleConstraint(true);

		rmSetLightingSet("california");

        rmDefineClass("classForest");
		rmDefineClass("classPlateau");
	rmSetSeaLevel(-1.0);
		rmSetSeaType("Lisbon");
       	rmTerrainInitialize("grass");
		rmSetWindMagnitude(4.0);


		//Constraints
		int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 24.0);

int avoidPlateauShort =rmCreateClassDistanceConstraint("stuff vs. cliffs smoll", rmClassID("classPlateau"), 8.0);


        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.9), rmDegreesToRadians(0), rmDegreesToRadians(360));
       
		int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 21.0);
        int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 6.0);
        
		int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 45.0);


		int avoidHuntSmall=rmCreateTypeDistanceConstraint("avoid hunts", "huntable", 20.0);

		int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 11.0);


        int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 67.0);

		int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 12.0);
		int avoidTree=rmCreateTypeDistanceConstraint("avoid trees", "Tree", 11.0);




		int waterCoin=rmCreateTypeDistanceConstraint("avoid coin smallest", "Mine", 14.0);


        int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 64);
        int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 19.0);
        int cliffWater = rmCreateTerrainDistanceConstraint("cliff avoids river", "Land", false, 7.0);



int playerFactor = 0;

	if (cNumberNonGaiaPlayers >= 5){
	playerFactor = 8;
}

	if (cNumberNonGaiaPlayers >= 5 && cNumberTeams >= 3){
	playerFactor = 12;
}


        int cliffWater2 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 28.0+playerFactor);


        int cliffWater3 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 4);


        int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 8.0);
        int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 25.0);
        
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 30.0);
        int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
        int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 80.0);  
       
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 55.0);

  int avoidBerries=rmCreateTypeDistanceConstraint("avoid berries", "berrybush", 20.0);
  int avoidBerriesSmall=rmCreateTypeDistanceConstraint("avoid berries smoll", "berrybush", 8.0);


int stayWest = rmCreatePieConstraint("Stay West",0.47,0.53, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(180),rmDegreesToRadians(0));

int stayEast = rmCreatePieConstraint("Stay East",0.53,0.47, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(180));

   



    
 // =============Player placement ======================= 


 	//========= Player placing========= 
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);


    float spawnSwitch = rmRandFloat(0,1.2);
//spawnSwitch = 0.1;


	if (cNumberTeams == 2){
		if (spawnSwitch <=0.6){

	if (cNumberNonGaiaPlayers == 2)
	{
			rmPlacePlayer(1, 0.65, 0.8);
			rmPlacePlayer(2, 0.65, 0.2);
	}



			rmSetPlacementTeam(0);
			rmSetPlacementSection(0.04, 0.14);
			rmPlacePlayersCircular(0.35, 0.35, 0.02);
			rmSetPlacementTeam(1);
			rmSetPlacementSection(0.36, 0.46);
			rmPlacePlayersCircular(0.35, 0.35, 0.02);


		}else if(spawnSwitch <=1.2){

	if (cNumberNonGaiaPlayers == 2)
	{
			rmPlacePlayer(2, 0.65, 0.8);
			rmPlacePlayer(1, 0.65, 0.2);
	}

			rmSetPlacementTeam(1);
			rmSetPlacementSection(0.04, 0.14);
			rmPlacePlayersCircular(0.35, 0.35, 0.02);
			rmSetPlacementTeam(0);
			rmSetPlacementSection(0.36, 0.46);
			rmPlacePlayersCircular(0.35, 0.35, 0.02);

		}
	}else{
	//*************ffa placement********

			rmSetPlacementSection(0.01, 0.49);
		rmPlacePlayersCircular(0.4, 0.4, 0.00);
	}

		
        chooseMercs();
        rmSetStatusText("",0.1); 

        int continent2 = rmCreateArea("continent");
        rmSetAreaSize(continent2, 1.0, 1.0);
        rmSetAreaLocation(continent2, 0.5, 0.5);
	   rmSetAreaMix(continent2, "borneo_grass_a");
   //     rmSetAreaTerrainType(continent2, "cave\cave_ground1");       
 	rmSetAreaBaseHeight(continent2, 8.0);
        rmSetAreaCoherence(continent2, 1.0);
        rmSetAreaSmoothDistance(continent2, 10);
   rmSetAreaEdgeFilling(continent2, 1.0);
        rmSetAreaHeightBlend(continent2, 2);
        rmSetAreaElevationNoiseBias(continent2, 0);
        rmSetAreaElevationEdgeFalloffDist(continent2, 6);
        rmSetAreaElevationVariation(continent2, 7);
        rmSetAreaElevationPersistence(continent2, .2);
        rmSetAreaElevationOctaves(continent2, 5);
        rmSetAreaElevationMinFrequency(continent2, 0.04);
        rmSetAreaElevationType(continent2, cElevTurbulence);  
	rmSetAreaObeyWorldCircleConstraint(continent2, false);
        rmBuildArea(continent2);    

		int classPatch = rmDefineClass("patch");
		int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 16.0);
		int classCenter = rmDefineClass("center");
		int avoidCenter = rmCreateClassDistanceConstraint("avoid center", rmClassID("center"), 36.0);
		int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.42), rmDegreesToRadians(0), rmDegreesToRadians(360));

       		for (i=0; < cNumberNonGaiaPlayers*125){
			int patchID = rmCreateArea("first patch"+i);
			rmSetAreaWarnFailure(patchID, false);
			rmSetAreaSize(patchID, rmAreaTilesToFraction(37), rmAreaTilesToFraction(42));
        rmSetAreaTerrainType(patchID, "borneo\ground_grass1_borneo");
	//		rmAddAreaToClass(patchID, rmClassID("patch"));
			rmSetAreaSmoothDistance(patchID, 3.0);
			rmBuildArea(patchID); 
	}

        
//===========trade route=================

int avoidTPSocket =rmCreateTypeDistanceConstraint("avoid trade socket", "SocketTradeRoute", 13.0);



		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 6.0);   
	rmAddObjectDefConstraint(socketID, avoidWaterShort);	
   
       
        int tradeRouteID = rmCreateTradeRoute();


        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

	rmAddTradeRouteWaypoint(tradeRouteID, 0.24, 0.99);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.42, 0.75);
 	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.6); 
 	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.4); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.42, 0.25); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.24, 0.01);

        rmBuildTradeRoute(tradeRouteID, "water");


        vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
            socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.39);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
            socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.61);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
            socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
       rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);



//======================================================


		rmSetStatusText("",0.2);




//define player areas

for(i=1; < cNumberNonGaiaPlayers + 1) {

    int PlayerArea1 = rmCreateArea("NeedLand1"+i);
        rmSetAreaSize(PlayerArea1, rmAreaTilesToFraction(470), rmAreaTilesToFraction(470));
	rmAddAreaToClass(PlayerArea1, rmClassID("classPlateau"));
	rmAddAreaToClass(PlayerArea1, rmClassID("center"));
       rmSetAreaHeightBlend(PlayerArea1, 1);
        rmSetAreaLocation(PlayerArea1, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmSetAreaMinBlobs(PlayerArea1, 2);
	rmSetAreaMaxBlobs(PlayerArea1, 4);
	rmSetAreaMinBlobDistance(PlayerArea1, 8);
	rmSetAreaMaxBlobDistance(PlayerArea1, 10);


        rmSetAreaCoherence(PlayerArea1, 0.93);
        rmBuildArea(PlayerArea1);

}




		rmSetStatusText("",0.3);



int avoidCree =rmCreateTypeDistanceConstraint("avoid cree socket", "SocketCree", 18.0);


	if (cNumberNonGaiaPlayers == 2)
{
  	int smollMines = rmCreateObjectDef("competitive gold");
	rmAddObjectDefItem(smollMines, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(smollMines, 0.0);
	rmSetObjectDefMaxDistance(smollMines, 0.0);
//middle mines
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.95, 0.5, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.08, 0.5, 1);	rmPlaceObjectDefAtLoc(smollMines, 0, 0.56, 0.5, 1);
//edge "anchor" mines
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.43, 0.92, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.43, 0.08, 1);
//2nd mines
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.78, 0.28, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.78, 0.72, 1);


}


// BUILD NATIVE SITES

	//Choose Natives
	int subCiv0=-1;
	int subCiv1=-1;
	int subCiv2=-1;
	int subCiv3=-1;

//Klamath are awesome


   if (rmAllocateSubCivs(4) == true)
   {
      subCiv0=rmGetCivID("Jesuit");
      rmEchoInfo("subCiv0 is Jesuit "+subCiv0);
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Jesuit");

		subCiv1=rmGetCivID("Jesuit");
      rmEchoInfo("subCiv1 is Jesuit "+subCiv1);
		if (subCiv1 >= 0)
			 rmSetSubCiv(1, "Jesuit");
	 
		subCiv2=rmGetCivID("Jesuit");
      rmEchoInfo("subCiv2 is Jesuit"+subCiv2);
      if (subCiv2 >= 0)
         rmSetSubCiv(2, "Jesuit");

		subCiv3=rmGetCivID("Jesuit");
      rmEchoInfo("subCiv3 is Jesuit"+subCiv3);
      if (subCiv3 >= 0)
         rmSetSubCiv(3, "Jesuit");
	}
	
	// Set up Natives	
	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
		
	nativeID0 = rmCreateGrouping("native site 1", "native jesuit mission borneo 03");
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 4.00);
	rmAddGroupingToClass(nativeID0, rmClassID("patch"));

	nativeID1 = rmCreateGrouping("native site 2", "native jesuit mission borneo 03");
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 4.00);
	rmAddGroupingToClass(nativeID1, rmClassID("patch"));

//========place=====
	if (cNumberNonGaiaPlayers == 2){
//sides
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.52, 0.1);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.52, 0.9);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.2, 0.5);

}else{
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.21, 0.27);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.21, 0.73);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.12, 0.5);

}





		rmSetStatusText("",0.4);


//==========random forests==============

	for (j=0; < (10*cNumberNonGaiaPlayers)) {   
			int ffaCliffs = rmCreateArea("ffaCliffs"+j);
        rmSetAreaSize(ffaCliffs, rmAreaTilesToFraction(300), rmAreaTilesToFraction(400));
		rmAddAreaToClass(ffaCliffs, rmClassID("classPlateau"));
	rmSetAreaObeyWorldCircleConstraint(ffaCliffs, false);
 	rmSetAreaBaseHeight(ffaCliffs, 7.0);
	rmSetAreaMinBlobs(ffaCliffs, 2);
	rmSetAreaMaxBlobs(ffaCliffs, 4);
	rmSetAreaMinBlobDistance(ffaCliffs, 10);
	rmSetAreaMaxBlobDistance(ffaCliffs, 12);
        rmSetAreaWaterType(ffaCliffs, "borneo pond");
	rmAddAreaConstraint(ffaCliffs, avoidCenter);
	rmAddAreaConstraint(ffaCliffs, avoidPatch);
	rmAddAreaConstraint(ffaCliffs, avoidPlateau);
	rmAddAreaConstraint(ffaCliffs, avoidTPSocket);
	rmAddAreaConstraint(ffaCliffs, cliffWater2);
	rmAddAreaConstraint(ffaCliffs, avoidCoin);
	rmAddAreaConstraint(ffaCliffs, avoidTradeRouteSmall);

	
if (j == 3){
	rmSetAreaLocation(ffaCliffs, 0.4, .5);
}
if (j == 2){
		rmSetAreaLocation(ffaCliffs, 0.2, .5);
}
if (j == 1){
		rmSetAreaLocation(ffaCliffs, .8, .5);
}

if (j == 0){
		rmSetAreaLocation(ffaCliffs, .6, .5);
}


//avoidTradeRouteSmall 
        rmSetAreaCoherence(ffaCliffs, .93);

        rmBuildArea(ffaCliffs);  
	}
			

	
	//==============starting objects=====================

		
        int playerStart = rmCreateStartingUnitsObjectDef(5.0);
        rmSetObjectDefMinDistance(playerStart, 7.0);
        rmSetObjectDefMaxDistance(playerStart, 12.0);
	rmAddObjectDefConstraint(playerStart, avoidWaterShort);

       
        int goldID = rmCreateObjectDef("starting gold");
        rmAddObjectDefItem(goldID, "mine", 1, 2.0);
        rmSetObjectDefMinDistance(goldID, 0.0);
        rmSetObjectDefMaxDistance(goldID, 0.0);
        rmAddObjectDefConstraint(goldID, avoidCoin);

        int goldID2 = rmCreateObjectDef("second gold");
        rmAddObjectDefItem(goldID2, "mine", 1, 2.0);
        rmSetObjectDefMinDistance(goldID2, 0.0);
        rmSetObjectDefMaxDistance(goldID2, 0.0);
        rmAddObjectDefConstraint(goldID2, avoidCoin);



        int berryID = rmCreateObjectDef("starting berries");
        rmAddObjectDefItem(berryID, "BerryBush", 4, 4.0);
        rmSetObjectDefMinDistance(berryID, 16.0);
        rmSetObjectDefMaxDistance(berryID, 17.0);
        rmAddObjectDefConstraint(berryID, avoidCoin);
        rmAddObjectDefConstraint(berryID, avoidTree);
 
        int treeID = rmCreateObjectDef("starting trees");
//        rmAddObjectDefItem(treeID, "UnderbrushBorneo", rmRandInt(1,2), 9.0);
        rmAddObjectDefItem(treeID, "ypTreeBorneo", rmRandInt(9,10), 6.0);
        rmSetObjectDefMinDistance(treeID, 2.0);
        rmSetObjectDefMaxDistance(treeID, 4.0);
        rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
        rmAddObjectDefConstraint(treeID, avoidCoin);
        rmAddObjectDefConstraint(treeID, avoidTree);


 
        int foodID = rmCreateObjectDef("starting hunt");
        rmAddObjectDefItem(foodID, "Peafowl", 9, 8.0);
        rmSetObjectDefMinDistance(foodID, 10.0);
        rmSetObjectDefMaxDistance(foodID, 12.0);
	rmAddObjectDefConstraint(foodID, avoidHuntSmall);	
        rmSetObjectDefCreateHerd(foodID, false);
 
        int foodID2 = rmCreateObjectDef("starting hunt 2");
        rmAddObjectDefItem(foodID2, "ypWildElephant", 3, 8.0);
        rmSetObjectDefMinDistance(foodID2, 26.0);
        rmSetObjectDefMaxDistance(foodID2, 30.0);
        rmSetObjectDefCreateHerd(foodID2, true);
	rmAddObjectDefConstraint(foodID2, avoidWaterShort);	
	rmAddObjectDefConstraint(foodID2, avoidHuntSmall);


                       
		int foodID3 = rmCreateObjectDef("starting hunt 3");
        rmAddObjectDefItem(foodID3, "Peafowl", 9, 6.0);
        rmSetObjectDefMinDistance(foodID3, 46.0);
        rmSetObjectDefMaxDistance(foodID3, 50.0);
	rmAddObjectDefConstraint(foodID3, avoidWaterShort);	
	rmAddObjectDefConstraint(foodID3, circleConstraint);
	rmAddObjectDefConstraint(foodID3, avoidHuntSmall);
        rmSetObjectDefCreateHerd(foodID3, true);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmSetNuggetDifficulty(1, 1); 
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 3.0);
    rmSetObjectDefMinDistance(playerNuggetID, 25.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 29.0);
    rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
    rmAddObjectDefConstraint(playerNuggetID, avoidTree);
    rmAddObjectDefConstraint(playerNuggetID, avoidCoin);




		int extraberrywagon=rmCreateObjectDef("JapAn cAnT hUnT");
  rmAddObjectDefItem(extraberrywagon, "ypBerryWagon1", 1, 0.0);
  rmSetObjectDefMinDistance(extraberrywagon, 6.0);
  rmSetObjectDefMaxDistance(extraberrywagon, 7.0);

	int flagLand = rmCreateTerrainDistanceConstraint("flags dont like land", "land", true, 7.0);



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

       	rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i)-rmXTilesToFraction(9), rmPlayerLocZFraction(i));

        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i)-rmXTilesToFraction(18), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i)+rmXTilesToFraction(12), rmPlayerLocZFraction(i)); 

        rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID3, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
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
	/*
	==================
	resource placement
	==================
	*/

  	int copperMine = rmCreateObjectDef("east mines");
	rmAddObjectDefItem(copperMine, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(copperMine, rmXFractionToMeters(0.0));
	rmSetObjectDefMaxDistance(copperMine, rmXFractionToMeters(0.41));
	rmAddObjectDefConstraint(copperMine, avoidCoinMed);
	rmAddObjectDefConstraint(copperMine, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(copperMine, avoidTPSocket);	
	rmAddObjectDefConstraint(copperMine, cliffWater);
	rmAddObjectDefConstraint(copperMine, avoidTownCenter);
	rmAddObjectDefConstraint(copperMine, avoidPlateauShort);
	rmPlaceObjectDefAtLoc(copperMine, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers);

    int muskHunts = rmCreateObjectDef("muskHunts");
	rmAddObjectDefItem(muskHunts, "ypWildElephant", rmRandInt(3,3), 7.0);
	rmSetObjectDefCreateHerd(muskHunts, true);
	rmSetObjectDefMinDistance(muskHunts, 0);
	rmSetObjectDefMaxDistance(muskHunts, 8);
//	rmAddObjectDefConstraint(muskHunts, avoidWaterShort);	

//centre hunts
	if (cNumberTeams == 2){
	rmPlaceObjectDefAtLoc(muskHunts, 0, 0.7, 0.5, 1);
}
	rmPlaceObjectDefAtLoc(muskHunts, 0, 0.27, 0.5, 1);
	rmPlaceObjectDefAtLoc(muskHunts, 0, 0.51, 0.5, 1);



    int pronghornHerd = rmCreateObjectDef("pronghornHerd");
	rmAddObjectDefItem(pronghornHerd, "Peafowl", 9, 8.0);
	rmSetObjectDefCreateHerd(pronghornHerd, true);
	rmSetObjectDefMinDistance(pronghornHerd, 0);
	rmSetObjectDefMaxDistance(pronghornHerd, rmXFractionToMeters(0.46));
	rmAddObjectDefConstraint(pronghornHerd, circleConstraint2);
	rmAddObjectDefConstraint(pronghornHerd, avoidTownCenter);
	rmAddObjectDefConstraint(pronghornHerd, avoidHunt);
	rmAddObjectDefConstraint(pronghornHerd, avoidPlateauShort);
	rmAddObjectDefConstraint(pronghornHerd, cliffWater);	
	rmAddObjectDefConstraint(pronghornHerd, avoidCoin);	
	rmPlaceObjectDefAtLoc(pronghornHerd, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers);



		rmSetStatusText("",0.7);



	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.44)); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetID, avoidPlateauShort);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenterMore);
	rmAddObjectDefConstraint(nuggetID, circleConstraint); 
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(nuggetID, cliffWater3);	
	rmAddObjectDefConstraint(nuggetID, avoidCoin);	
	rmSetNuggetDifficulty(2, 3); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 12*cNumberNonGaiaPlayers);   



	rmSetStatusText("",0.8);


		int lowlandTrees=rmCreateObjectDef("Lowland Trees");
	rmAddObjectDefItem(lowlandTrees, "ypTreeBamboo", rmRandInt(2,2), rmRandFloat(16.0,17.0));
	rmAddObjectDefItem(lowlandTrees, "ypTreeBorneo", rmRandInt(1,2), rmRandFloat(20.0,22.0));
		rmAddObjectDefToClass(lowlandTrees, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(lowlandTrees, 0);
		rmSetObjectDefMaxDistance(lowlandTrees, rmXFractionToMeters(0.46));
		rmAddObjectDefConstraint(lowlandTrees, forestConstraintShort);
		rmAddObjectDefConstraint(lowlandTrees, avoidTPSocket);	
	rmAddObjectDefConstraint(lowlandTrees, avoidCenter);
	rmAddObjectDefConstraint(lowlandTrees, avoidPatch);
	rmAddObjectDefConstraint(lowlandTrees, avoidCoin);
	rmAddObjectDefConstraint(lowlandTrees, waterHunt);

	rmPlaceObjectDefAtLoc(lowlandTrees, 0, 0.5, 0.5, 100*cNumberNonGaiaPlayers);   


	rmSetStatusText("",0.9);

		int bonusTrees=rmCreateObjectDef("bonusTrees");
		rmAddObjectDefItem(bonusTrees, "ypTreeBorneo", rmRandInt(2,3), rmRandFloat(8.0,9.0));
		rmAddObjectDefToClass(bonusTrees, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(bonusTrees, 0);
		rmSetObjectDefMaxDistance(bonusTrees, rmXFractionToMeters(0.45));
	  	rmAddObjectDefConstraint(bonusTrees, avoidTradeRouteSmall);
	  	rmAddObjectDefConstraint(bonusTrees, avoidCoin);
		rmAddObjectDefConstraint(bonusTrees, forestConstraint);
		rmAddObjectDefConstraint(bonusTrees, avoidTownCenter);	
	rmPlaceObjectDefAtLoc(bonusTrees, 0, 0.5, 0.5, 30*cNumberNonGaiaPlayers);  

	int propsHateProps =rmCreateTypeDistanceConstraint("fish v fish", "UnderbrushBorneo", 16.0);

       		for (i=0; < cNumberNonGaiaPlayers*45){
			int patchID2 = rmCreateArea("second patch"+i);
			rmSetAreaWarnFailure(patchID2, false);
			rmSetAreaSize(patchID2, rmAreaTilesToFraction(18), rmAreaTilesToFraction(20));
        rmSetAreaTerrainType(patchID2, "borneo\ground_forest_borneo");
	rmSetAreaObeyWorldCircleConstraint(patchID2, false);
	//		rmAddAreaToClass(patchID2, rmClassID("patch"));
			//rmSetAreaSmoothDistance(patchID2, 3.0);
			rmBuildArea(patchID2); 
		}

  	int LlamaTime = rmCreateObjectDef("TINA");
	rmAddObjectDefItem(LlamaTime, "ypWaterBuffalo", rmRandInt(1,1), 4.0);
	rmSetObjectDefMinDistance(LlamaTime, 0.0);
	rmSetObjectDefMaxDistance(LlamaTime, rmXFractionToMeters(0.39));
	rmAddObjectDefConstraint(LlamaTime, avoidHerd);
//	rmAddObjectDefConstraint(LlamaTime, avoidPlateau);	
	rmAddObjectDefConstraint(LlamaTime, circleConstraint2);
	rmAddObjectDefConstraint(LlamaTime, avoidTownCenterMore);
	rmAddObjectDefConstraint(LlamaTime, cliffWater3);	
	rmPlaceObjectDefAtLoc(LlamaTime, 0, 0.3, 0.3, 4*cNumberNonGaiaPlayers);



  // Water nuggets

  int avoidNuggetLand=rmCreateTerrainDistanceConstraint("nugget avoid land", "land", true, 15.0);
  int avoidNuggetWater=rmCreateTypeDistanceConstraint("nugget vs. nugget water", "AbstractNugget", 80.0);
  
  int nuggetW= rmCreateObjectDef("nugget water"); 
  rmAddObjectDefItem(nuggetW, "ypNuggetBoat", 1, 0.0);
  rmSetNuggetDifficulty(5, 5);
  rmSetObjectDefMinDistance(nuggetW, rmXFractionToMeters(0.0));
  rmSetObjectDefMaxDistance(nuggetW, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nuggetW, avoidNuggetLand);
  rmAddObjectDefConstraint(nuggetW, avoidNuggetWater);
  rmPlaceObjectDefAtLoc(nuggetW, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4);



   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.3, .5, .05, 0);
   }


	rmSetStatusText("",0.99);
	



	}
 
