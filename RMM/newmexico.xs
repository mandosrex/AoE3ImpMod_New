/*
==============================
	    New Mexico
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
	int playerTiles=8000;
	if (cNumberNonGaiaPlayers > 4){
		playerTiles = 6800;
	}else if (cNumberNonGaiaPlayers > 6){
		playerTiles = 5800;
	}


	rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.5, 3.0);
	rmSetMapElevationHeightBlend(1);


	int size = 2.0 * sqrt(cNumberNonGaiaPlayers*playerTiles);

	rmSetMapSize(size*1.4, size);

	rmSetMapType("land");
	rmSetMapType("desert");
	rmSetMapType("namerica");
        rmSetMapType("Sonora");
       	rmTerrainInitialize("grass");
		rmSetLightingSet("Texas");

	rmSetWorldCircleConstraint(true);

        rmDefineClass("classForest");
		rmDefineClass("classPlateau");
	rmSetSeaLevel(0.0);
		rmSetSeaType("yucatan Coast");


		//Constraints
		int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 16.0);

        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.45), rmDegreesToRadians(0), rmDegreesToRadians(360));
       
		int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 24.0);
        int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 14.0);
        
		int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 62.0);
		int avoidHuntSmall=rmCreateTypeDistanceConstraint("avoid hunts", "huntable", 11.0);

		int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 8.0);

        int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 24.0);

		int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
        int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 64.0);
        int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 5.0);
        int cliffWater = rmCreateTerrainDistanceConstraint("cliff avoids river", "Land", false, 12.0);
        int cliffWater2 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 1.5);
        int cliffWater3 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 2.5);


        int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 8.0);

        int avoidTradeRouteLarge = rmCreateTradeRouteDistanceConstraint("objects avoid trade route", 14.0);



        int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 25.0);
        
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 27.0);
        int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
        int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 60.0);  
       
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 60.0);

  int avoidBerries=rmCreateTypeDistanceConstraint("avoid berries", "berrybush", 24.0);
  int avoidBerriesSmall=rmCreateTypeDistanceConstraint("avoid berries smoll", "berrybush", 8.0);

int stayWest = rmCreatePieConstraint("Stay West",0.47,0.53, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(180),rmDegreesToRadians(0));

int stayEast = rmCreatePieConstraint("Stay East",0.53,0.47, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(180));

   

    
 // =============Player placement ======================= 
    float spawnSwitch = rmRandFloat(0,1.2);
	//spawnSwitch = 0.2;

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);

	if (cNumberTeams == 2){
		if (spawnSwitch <=0.6){

	if (cNumberNonGaiaPlayers == 2)
	{
	rmPlacePlayer(1, 0.2, 0.67);
	rmPlacePlayer(2, 0.8, 0.33);	}

			rmSetPlacementTeam(0);
			rmSetPlacementSection(0.6, 0.8);
			rmPlacePlayersCircular(0.39, 0.38, 0.02);
			rmSetPlacementTeam(1);
			rmSetPlacementSection(0.10, 0.3);
			rmPlacePlayersCircular(0.39, 0.38, 0.02);
		}else if(spawnSwitch <=1.2){

	if (cNumberNonGaiaPlayers == 2)
	{
	rmPlacePlayer(2, 0.2, 0.67);
	rmPlacePlayer(1, 0.8, 0.33);	}

			rmSetPlacementTeam(1);
			rmSetPlacementSection(0.6, 0.8);
			rmPlacePlayersCircular(0.39, 0.38, 0.02);
			rmSetPlacementTeam(0);
			rmSetPlacementSection(0.10, 0.3);
			rmPlacePlayersCircular(0.39, 0.38, 0.02);

		}
	}else{
	//*************ffa placement********
		 rmPlacePlayersSquare(0.35, 0.4, 0.00);
	}

		
        chooseMercs();
        rmSetStatusText("",0.1); 
        int continent2 = rmCreateArea("continent");
        rmSetAreaSize(continent2, 1.0, 1.0);
        rmSetAreaLocation(continent2, 0.5, 0.5);
	   rmSetAreaMix(continent2, "texas_grass");
		rmSetAreaEdgeFilling(continent2, 6.0);
        rmSetAreaCoherence(continent2, 1.0);
        rmSetAreaSmoothDistance(continent2, 2);
        rmSetAreaElevationNoiseBias(continent2, 0);
        rmSetAreaElevationEdgeFalloffDist(continent2, 10);
        rmSetAreaElevationVariation(continent2, 5);
        rmSetAreaElevationPersistence(continent2, .2);
        rmSetAreaElevationOctaves(continent2, 5);
        rmSetAreaElevationMinFrequency(continent2, 0.04);
        rmSetAreaElevationType(continent2, cElevTurbulence);  
	rmSetAreaObeyWorldCircleConstraint(continent2, false);
        rmBuildArea(continent2);    

		int classPatch = rmDefineClass("patch");
		int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 4.0);
		int classCenter = rmDefineClass("center");
		int avoidCenter = rmCreateClassDistanceConstraint("avoid center", rmClassID("center"), 30.0);
		int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
        

	int stayLow = rmCreateMaxHeightConstraint("patches stay low", 0.0);





//===========================================================

       		for (i=0; < cNumberNonGaiaPlayers*200){
			int patchID = rmCreateArea("first patch"+i);
			rmSetAreaWarnFailure(patchID, false);
			rmSetAreaSize(patchID, rmAreaTilesToFraction(37), rmAreaTilesToFraction(42));
        rmSetAreaTerrainType(patchID, "texas\cliff_top_grass_tex");
	//		rmAddAreaToClass(patchID, rmClassID("patch"));
			rmSetAreaSmoothDistance(patchID, 1.0);
//			rmBuildArea(patchID); 
		}


		rmSetStatusText("",0.2);




/*
//==========hills==============

	for (j=0; < (4*cNumberNonGaiaPlayers)) {   
			int ffaCliffs = rmCreateArea("ffaCliffs"+j);
        rmSetAreaSize(ffaCliffs, rmAreaTilesToFraction(800), rmAreaTilesToFraction(900));
//		rmAddAreaToClass(ffaCliffs, rmClassID("classPlateau"));
		rmAddAreaToClass(ffaCliffs, rmClassID("center"));

        rmSetAreaBaseHeight(ffaCliffs, -1.0);
        rmSetAreaCoherence(ffaCliffs, 0.8);
        rmSetAreaSmoothDistance(ffaCliffs, 21);
        rmSetAreaHeightBlend(ffaCliffs, 2);
	   rmSetAreaMix(ffaCliffs, "texas_dirt");


	rmAddAreaConstraint(ffaCliffs, avoidCenter);
	rmAddAreaConstraint(ffaCliffs, avoidWaterShort);
	rmAddAreaConstraint(ffaCliffs, avoidPatch);
	rmAddAreaConstraint(ffaCliffs, avoidTradeRouteSmall);

        rmSetAreaCoherence(ffaCliffs, .89);

        rmBuildArea(ffaCliffs);  
	}

*/

		rmSetStatusText("",0.3);


// ******KEEP BUILDABLE LAND UNDER TCS ******

for(i=1; < cNumberNonGaiaPlayers + 1) {

    int PlayerArea1 = rmCreateArea("NeedLand1"+i);
        rmSetAreaSize(PlayerArea1, .04, .041);
//		rmAddAreaToClass(PlayerArea1, rmClassID("classCenter"));
        rmSetAreaLocation(PlayerArea1, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmSetAreaSmoothDistance(PlayerArea1, 6);

        rmSetAreaCoherence(PlayerArea1, 0.86);
        rmBuildArea(PlayerArea1);
}

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
      rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 0.8);
       rmAddTradeRouteWaypoint(tradeRouteID, 0.2, 0.8);
       rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 0.75);

       rmAddTradeRouteWaypoint(tradeRouteID, 0.4, 0.7);
       rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.5);
       rmAddTradeRouteWaypoint(tradeRouteID, 0.6, 0.3);

     rmAddTradeRouteWaypoint(tradeRouteID, 0.7, 0.25);
     rmAddTradeRouteWaypoint(tradeRouteID, 0.8, 0.2);
       rmAddTradeRouteWaypoint(tradeRouteID, 1.0, 0.2);

        rmBuildTradeRoute(tradeRouteID, "dirt");
 
        vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.24);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.75);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

	if (cNumberNonGaiaPlayers == 2){

	rmPlaceObjectDefAtLoc(socketID, 0, 0.5, 0.5, 1);

}else{
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.42);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.58);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
}

//=====================================================

		int desertNW=rmCreateArea("desert NW");
        rmSetAreaLocation(desertNW, 0.6, 0.9);
        rmAddAreaInfluenceSegment(desertNW, 0.3, 0.9, 0.6, 0.8);
        rmSetAreaSize(desertNW, .15, .15);  
	rmAddAreaToClass(desertNW, rmClassID("center"));
	rmSetAreaMix(desertNW, "texas_dirt");
	rmAddAreaConstraint(desertNW, avoidTradeRouteLarge);
        rmSetAreaCoherence(desertNW, .86);
        rmBuildArea(desertNW);




		int desertSW=rmCreateArea("desert SW");
        rmSetAreaLocation(desertSW, 0.4, 0.1);
        rmAddAreaInfluenceSegment(desertSW, 0.7, 0.1, 0.4, 0.2);
        rmSetAreaSize(desertSW, .15, .15);  
	rmAddAreaToClass(desertSW, rmClassID("center"));
	rmSetAreaMix(desertSW, "texas_dirt");
	rmAddAreaConstraint(desertSW, avoidTradeRouteLarge);
        rmSetAreaCoherence(desertSW, .86);
        rmBuildArea(desertSW);




//============================================

		int pondSW =rmCreateArea("small Lake 1");
        rmSetAreaLocation(pondSW, 0.31, 0.38);
        rmSetAreaSize(pondSW, .02, .022);      
        rmSetAreaWaterType(pondSW, "Texas Pond");
        rmSetAreaBaseHeight(pondSW, 8.0);
        rmSetAreaCoherence(pondSW, .83);
	rmSetAreaMinBlobs(pondSW, 2);
	rmSetAreaMaxBlobs(pondSW, 4);
	rmSetAreaMinBlobDistance(pondSW, 6);
	rmSetAreaMaxBlobDistance(pondSW, 8);
        rmSetAreaSmoothDistance(pondSW, 2);
        rmBuildArea(pondSW);


		int pondNE =rmCreateArea("small Lake 2");
        rmSetAreaLocation(pondNE, 0.69, 0.62);
        rmSetAreaSize(pondNE, .02, .022);      
        rmSetAreaWaterType(pondNE, "Texas Pond");
        rmSetAreaBaseHeight(pondNE, 8.0);
        rmSetAreaCoherence(pondNE, .83);
	rmSetAreaMinBlobs(pondNE, 2);
	rmSetAreaMaxBlobs(pondNE, 4);
	rmSetAreaMinBlobDistance(pondNE, 6);
	rmSetAreaMaxBlobDistance(pondNE, 8);
        rmSetAreaSmoothDistance(pondNE, 2);
        rmBuildArea(pondNE);


 
//=============================================================

// BUILD NATIVE SITES

//yeah its always cheyenne

	//Choose Natives
	int subCiv0=-1;
	int subCiv1=-1;
	int subCiv2=-1;
	int subCiv3=-1;

   if (rmAllocateSubCivs(4) == true)
   {
      subCiv0=rmGetCivID("Comanche");
      rmEchoInfo("subCiv0 is Comanche "+subCiv0);
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Comanche");

		subCiv1=rmGetCivID("Comanche");
      rmEchoInfo("subCiv1 is Comanche "+subCiv1);
		if (subCiv1 >= 0)
			 rmSetSubCiv(1, "Comanche");
	 
		subCiv2=rmGetCivID("navajo");
      rmEchoInfo("subCiv2 is navajo "+subCiv2);
      if (subCiv2 >= 0)
         rmSetSubCiv(2, "navajo");

		subCiv3=rmGetCivID("navajo");
      rmEchoInfo("subCiv3 is navajo"+subCiv3);
      if (subCiv3 >= 0)
         rmSetSubCiv(3, "navajo");
	}
	
	// Set up Natives	
	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
		
	nativeID0 = rmCreateGrouping("comanche village A", "native comanche village 3");
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
	rmAddGroupingToClass(nativeID0, rmClassID("classPlateau"));
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.12, 0.3);

	nativeID1 = rmCreateGrouping("comanche village B", "native comanche village 4");
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.88, 0.7);


//3&4

	nativeID2 = rmCreateGrouping("navajo village B", "native navajo village 3");
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
	rmAddGroupingToClass(nativeID2, rmClassID("classPlateau"));
	rmPlaceGroupingAtLoc(nativeID2, 0, 0.55, 0.92);


	nativeID3 = rmCreateGrouping("navajo village A", "native navajo village 4");
    rmSetGroupingMinDistance(nativeID3, 0.00);
    rmSetGroupingMaxDistance(nativeID3, 0.00);
	rmAddGroupingToClass(nativeID3, rmClassID("natives"));
	rmPlaceGroupingAtLoc(nativeID3, 0, 0.45, 0.08);


	
//=======================================================

				


		rmSetStatusText("",0.4);
		//starting objects

	int flagLand = rmCreateTerrainDistanceConstraint("flags dont like land", "land", true, 3.0);


		
        int playerStart = rmCreateStartingUnitsObjectDef(5.0);
        rmSetObjectDefMinDistance(playerStart, 7.0);
        rmSetObjectDefMaxDistance(playerStart, 12.0);
	rmAddObjectDefConstraint(playerStart, avoidWaterShort);

       
        int goldID = rmCreateObjectDef("starting gold");
        rmAddObjectDefItem(goldID, "mine", 1, 3.0);
        rmSetObjectDefMinDistance(goldID, 18.0);
        rmSetObjectDefMaxDistance(goldID, 18.0);
        rmAddObjectDefConstraint(goldID, avoidCoin);
	rmAddObjectDefConstraint(goldID, avoidTradeRouteSmall);


    
        int goldID2 = rmCreateObjectDef("starting gold 1v1");
        rmAddObjectDefItem(goldID2, "mine", 1, 1.0);
        rmSetObjectDefMinDistance(goldID2, 0.0);
        rmSetObjectDefMaxDistance(goldID2, 2.0);
   


        int berryID = rmCreateObjectDef("starting berries");
        rmAddObjectDefItem(berryID, "BerryBush", 4, 2.0);
        rmSetObjectDefMinDistance(berryID, 13.0);
        rmSetObjectDefMaxDistance(berryID, 15.0);
        rmAddObjectDefConstraint(berryID, avoidCoin);
 
        int treeID = rmCreateObjectDef("starting trees");
        rmAddObjectDefItem(treeID, "TreeTexasDirt", rmRandInt(6,7), 7.0);
        rmSetObjectDefMinDistance(treeID, 18.0);
        rmSetObjectDefMaxDistance(treeID, 21.0);
        rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
        rmAddObjectDefConstraint(treeID, avoidCoin);
	rmAddObjectDefConstraint(treeID, avoidTradeRouteSmall);

 
        int foodID = rmCreateObjectDef("starting hunt");
        rmAddObjectDefItem(foodID, "bison", 11, 8.0);
        rmSetObjectDefMinDistance(foodID, 12.0);
        rmSetObjectDefMaxDistance(foodID, 14.0);
	rmAddObjectDefConstraint(foodID, avoidCoin);	
        rmSetObjectDefCreateHerd(foodID, false);
 
        int foodID2 = rmCreateObjectDef("starting hunt 2");
        rmAddObjectDefItem(foodID2, "deer", 9, 8.0);
        rmSetObjectDefMinDistance(foodID2, 31.0);
        rmSetObjectDefMaxDistance(foodID2, 32.0);
	rmAddObjectDefConstraint(foodID2, avoidHuntSmall);	
        rmSetObjectDefCreateHerd(foodID2, true);
        rmAddObjectDefConstraint(foodID2, avoidCoin);

                       
		int foodID3 = rmCreateObjectDef("starting hunt 3");
        rmAddObjectDefItem(foodID3, "bison", 8, 8.0);
        rmSetObjectDefMinDistance(foodID3, 40.0);
        rmSetObjectDefMaxDistance(foodID3, 40.0);
	rmAddObjectDefConstraint(foodID3, avoidWaterShort);	
        rmSetObjectDefCreateHerd(foodID3, true);


  int playerCrateID=rmCreateObjectDef("bonus starting crates");
  rmAddObjectDefItem(playerCrateID, "crateOfCoin", 1, 2.0);
  rmSetObjectDefMinDistance(playerCrateID, 10);
  rmSetObjectDefMaxDistance(playerCrateID, 10);
	rmAddObjectDefConstraint(playerCrateID, avoidCoin);

	int extraberrywagon=rmCreateObjectDef("JapAn cAnT hUnT");
  rmAddObjectDefItem(extraberrywagon, "ypBerryWagon1", 1, 0.0);
  rmSetObjectDefMinDistance(extraberrywagon, 6.0);
  rmSetObjectDefMaxDistance(extraberrywagon, 7.0);



		rmSetStatusText("",0.5);  

  	int eastmine = rmCreateObjectDef("east mines");
	rmAddObjectDefItem(eastmine, "mine", 1, 1.0);
	rmAddObjectDefConstraint(eastmine, avoidWaterShort);

	rmSetObjectDefMinDistance(eastmine, 0);
	rmSetObjectDefMaxDistance(eastmine, 2);
//starting mines

	if (cNumberNonGaiaPlayers == 2)
	{

	rmPlaceObjectDefAtLoc(eastmine, 0, 0.14, 0.65, 1);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.86, 0.35, 1);
}

    
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

        rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	if (cNumberNonGaiaPlayers >= 3)
	{
        rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerCrateID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
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


	int rectangleStay = rmCreateBoxConstraint("stay away from edges", 0.1, 0.05, 0.9, 0.95);




	if (cNumberNonGaiaPlayers == 2)
{
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.29, 0.93, 1);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.71, 0.07, 1);

	rmPlaceObjectDefAtLoc(eastmine, 0, 0.1, 0.45, 1);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.9, 0.55, 1);

	rmPlaceObjectDefAtLoc(eastmine, 0, 0.23, 0.18, 1);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.77, 0.82, 1);

	rmPlaceObjectDefAtLoc(eastmine, 0, 0.36, 0.6, 1);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.64, 0.4, 1);



	rmPlaceObjectDefAtLoc(eastmine, 0, 0.46, 0.29, 1);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.54, 0.71, 1);


}else{

	rmSetObjectDefMinDistance(eastmine, rmXFractionToMeters(0.0));
	rmSetObjectDefMaxDistance(eastmine, rmXFractionToMeters(0.68));
	rmAddObjectDefConstraint(eastmine, avoidCoinMed);
	rmAddObjectDefConstraint(eastmine, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(eastmine, avoidPlateau);	
	rmAddObjectDefConstraint(eastmine, avoidTownCenterMore);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers);
}
	

//=========================================================

    int bisonBurgers = rmCreateObjectDef("bison Burgers");
	rmAddObjectDefItem(bisonBurgers, "bison", 12, 11.0);
	rmSetObjectDefCreateHerd(bisonBurgers, true);
	rmSetObjectDefMinDistance(bisonBurgers, 0);
	if (cNumberNonGaiaPlayers == 2)
{

	rmSetObjectDefMaxDistance(bisonBurgers, 8);

//centre hunts
	rmPlaceObjectDefAtLoc(bisonBurgers, 0, 0.42, 0.31, 1);
	rmPlaceObjectDefAtLoc(bisonBurgers, 0, 0.58, 0.69, 1);
//2nd hunt
	rmPlaceObjectDefAtLoc(bisonBurgers, 0, 0.2, 0.16, 1);
	rmPlaceObjectDefAtLoc(bisonBurgers, 0, 0.8, 0.84, 1);
//3rd hunt
	rmPlaceObjectDefAtLoc(bisonBurgers, 0, 0.34, 0.52, 1);
	rmPlaceObjectDefAtLoc(bisonBurgers, 0, 0.66, 0.48, 1);
//4th hunt
	rmPlaceObjectDefAtLoc(bisonBurgers, 0, 0.56, 0.11, 1);
	rmPlaceObjectDefAtLoc(bisonBurgers, 0, 0.44, 0.89, 1);

}else{

	rmAddObjectDefConstraint(bisonBurgers, rectangleStay);
	rmAddObjectDefConstraint(bisonBurgers, avoidTownCenterMore);
	rmAddObjectDefConstraint(bisonBurgers, avoidHunt);		//rmAddObjectDefConstraint(bisonBurgers, avoidBerries);
	rmAddObjectDefConstraint(bisonBurgers, avoidWaterShort);	
//	rmAddObjectDefConstraint(bisonBurgers, avoidCoin);


	rmSetObjectDefMaxDistance(bisonBurgers, rmXFractionToMeters(0.8));
	
	rmPlaceObjectDefAtLoc(bisonBurgers, 0, 0.5, 0.5, 9*cNumberNonGaiaPlayers);
}


    int pronghornHunts = rmCreateObjectDef("pronghornHunts");
	rmAddObjectDefItem(pronghornHunts, "pronghorn", rmRandInt(5,6), 5.0);
	rmSetObjectDefCreateHerd(pronghornHunts, true);
	rmSetObjectDefMinDistance(pronghornHunts, 0);
	rmSetObjectDefMaxDistance(pronghornHunts, 5);
	
//centre hunt
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.5, 0.5, 1);
//2nd hunt
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.17, 0.55, 1);
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.83, 0.45, 1);
//3rd hunt
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.25, 0.88, 1);
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.75, 0.12, 1);
//back hunt
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.06, 0.4, 1);
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.94, 0.6, 1);
//desert hunt
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.65, 0.93, 1);
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.35, 0.07, 1);
//lake hunt
	if (cNumberNonGaiaPlayers == 2)
{
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.23, 0.35, 1);
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.77, 0.65, 1);
}



	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetID, rectangleStay);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(nuggetID, avoidPlateau);
	rmAddObjectDefConstraint(nuggetID, cliffWater);	
	rmAddObjectDefConstraint(nuggetID, avoidCoin);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
	
//stronk nuggs
	rmSetNuggetDifficulty(3, 3); 
	rmPlaceObjectDefInArea(nuggetID, 0, desertNW, 3);
	rmPlaceObjectDefInArea(nuggetID, 0, desertSW, 3);
//normie nuggs		
    rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.7)); 
	rmSetNuggetDifficulty(1, 2); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);   


	rmSetStatusText("",0.7);



int avoidTPSocket =rmCreateTypeDistanceConstraint("avoid trade socket", "SocketTradeRoute", 14.0);




		int mapTrees=rmCreateObjectDef("map trees");
		rmAddObjectDefItem(mapTrees, "TreeTexas", rmRandInt(5,5), rmRandFloat(5.0,6.0));
		rmAddObjectDefItem(mapTrees, "TreeTexasDirt", rmRandInt(3,3), rmRandFloat(5.0,7.0));
		rmAddObjectDefItem(mapTrees, "UnderbrushTexasGrass", rmRandInt(2,2), rmRandFloat(8.0,9.0));
		rmAddObjectDefToClass(mapTrees, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(mapTrees, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(mapTrees, rmXFractionToMeters(0.8));
		rmAddObjectDefConstraint(mapTrees, avoidTPSocket);
	  	rmAddObjectDefConstraint(mapTrees, avoidCoin);
		rmAddObjectDefConstraint(mapTrees, forestConstraint);
		rmAddObjectDefConstraint(mapTrees, avoidTownCenter);
		rmAddObjectDefConstraint(mapTrees, avoidPlateau);
		rmAddObjectDefConstraint(mapTrees, avoidCenter);
		rmAddObjectDefConstraint(mapTrees, cliffWater);
		rmPlaceObjectDefAtLoc(mapTrees, 0, 0.5, 0.5, 25*cNumberNonGaiaPlayers);




		rmSetStatusText("",0.8);


		int bonusTrees=rmCreateObjectDef("bonusTrees");
		rmAddObjectDefItem(bonusTrees, "UnderbrushTexas", rmRandInt(2,3), rmRandFloat(8.0,11.0));
		rmAddObjectDefItem(bonusTrees, "TreeTexas", rmRandInt(4,5), rmRandFloat(8.0,11.0));
		rmAddObjectDefToClass(bonusTrees, rmClassID("classForest")); 
//	  	rmAddObjectDefConstraint(bonusTrees, circleConstraint);
		rmAddObjectDefConstraint(bonusTrees, forestConstraintShort);
	rmAddObjectDefConstraint(bonusTrees, avoidTownCenter);

		rmAddObjectDefConstraint(bonusTrees, waterHunt);	
	rmPlaceObjectDefInArea(bonusTrees, 0, continent2, 10*cNumberNonGaiaPlayers);
	

		int desertTrees=rmCreateObjectDef("even more Trees");
		rmAddObjectDefItem(desertTrees, "TreeSonora", rmRandInt(4,6), rmRandFloat(8.0,11.0));
		rmAddObjectDefItem(desertTrees, "UnderbrushDesert", rmRandInt(4,5), rmRandFloat(8.0,11.0));
		rmAddObjectDefToClass(desertTrees, rmClassID("classForest")); 
	  	rmAddObjectDefConstraint(desertTrees, avoidPlateau);
		rmAddObjectDefConstraint(desertTrees, forestConstraint);
	rmAddObjectDefConstraint(desertTrees, avoidTownCenter);

	rmPlaceObjectDefInArea(desertTrees, 0, desertNW, 10*cNumberNonGaiaPlayers);
	rmPlaceObjectDefInArea(desertTrees, 0, desertSW, 10*cNumberNonGaiaPlayers);



  	int BigBoys = rmCreateObjectDef("large props");
	rmAddObjectDefItem(BigBoys, "BigPropTexas", 1, 1.0);
	rmAddObjectDefToClass(BigBoys, rmClassID("classForest")); 
	rmAddObjectDefConstraint(BigBoys, avoidCoin);
	rmAddObjectDefConstraint(BigBoys, avoidWaterShort);
	rmAddObjectDefConstraint(BigBoys, forestConstraintShort);
	rmAddObjectDefConstraint(BigBoys, avoidPlateau);
	rmAddObjectDefConstraint(BigBoys, avoidTownCenter);

	//rmPlaceObjectDefAtLoc(BigBoys, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
	rmPlaceObjectDefInArea(BigBoys, 0, desertNW, 1.5*cNumberNonGaiaPlayers);
	rmPlaceObjectDefInArea(BigBoys, 0, desertSW, 1.5*cNumberNonGaiaPlayers);

//desertNW


	rmSetStatusText("",0.9);

	int avoidVultures=rmCreateTypeDistanceConstraint("avoids Vultures", "PropVulturePerching", 40.0);
	int avoidBuzzards=rmCreateTypeDistanceConstraint("buzzard avoid buzzard", "BuzzardFlock", 80.0);
	int avoidProps=rmCreateTypeDistanceConstraint("props avoid props", "UnderbrushTexasGrass", 10.0);


	int randomVultureTreeID=rmCreateObjectDef("random vulture tree");
	rmAddObjectDefItem(randomVultureTreeID, "PropVulturePerching", 1, 2.0);
	rmSetObjectDefMinDistance(randomVultureTreeID, 0.0);
	rmSetObjectDefMaxDistance(randomVultureTreeID, rmXFractionToMeters(0.70));
    rmAddObjectDefConstraint(randomVultureTreeID, avoidPlateau);
	rmAddObjectDefConstraint(randomVultureTreeID, rectangleStay);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidTownCenter);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidVultures);
	rmAddObjectDefConstraint(randomVultureTreeID, cliffWater);	
	rmAddObjectDefConstraint(randomVultureTreeID, avoidCoin);
	rmPlaceObjectDefAtLoc(randomVultureTreeID, 0, 0.5, 0.5, 2.5*cNumberNonGaiaPlayers);

	int buzzardFlockID=rmCreateObjectDef("buzzards");
	rmAddObjectDefItem(buzzardFlockID, "BuzzardFlock", 1, 2.0);
	rmSetObjectDefMinDistance(buzzardFlockID, 0.0);
	rmSetObjectDefMaxDistance(buzzardFlockID, rmXFractionToMeters(0.7));
	rmAddObjectDefConstraint(buzzardFlockID, avoidBuzzards);
	rmAddObjectDefConstraint(buzzardFlockID, rectangleStay);
	rmPlaceObjectDefAtLoc(buzzardFlockID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);


	rmSetStatusText("",0.99);


   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .05, 0);
   }


	}
 
