/*
===============================
 	   Mississippi
	   by dansil92 
===============================
*/


// observer UI by Aizamk


include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";


// Main entry point for random map script

 
void main(void) {
	rmSetStatusText("",0.01);


   // Picks the map size
//======================================
	int playerTiles=9800;
	if (cNumberNonGaiaPlayers > 4){
		playerTiles = 8600;
	}else if (cNumberNonGaiaPlayers > 6){
		playerTiles = 7000;
	}
	
	int size = 2.0 * sqrt(cNumberNonGaiaPlayers*playerTiles);

	if (cNumberTeams >= 3){
 size = (size*1.3);
}

	rmSetMapSize(size, size);
//======================================

int seasonPick = rmRandInt(1,2);
// 1 = winter, 2 = summer, 3 = spring
// frozen, crossings, flooded


	if (false) {
		seasonPick = 2;
	} else if (false) {
		seasonPick = 1;
	}


	rmSetMapType("land");
	rmSetMapType("namerica");
	rmSetSeaLevel(8.0);
	rmSetSeaType("Mississippi");
	string riverType = "Mississippi";
        rmDefineClass("classForest");
		rmDefineClass("classPlateau");
	string treeType = "";
    float flag1 = 0;

	rmSetWorldCircleConstraint(false);
   

if (seasonPick == 1){
     rmSetMapType("snow");
        rmSetMapType("saguenay");
       	rmTerrainInitialize("snow");
		rmSetLightingSet("rockies");
	   rmSetGlobalSnow( 1.0 );
	rmSetWindMagnitude(12.0);
	treeType = "TreeGreatLakesSnow";

}else{
        rmSetMapType("grass");
        rmSetMapType("greatlakes");
	rmSetMapType("AIFishingUseful");
       	rmTerrainInitialize("grass");
		rmSetLightingSet("greatplains");
	treeType = "treeGreatPlains";
}


//=======================================

		//Constraints
		int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 17.0);
        int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);

        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.44), rmDegreesToRadians(0), rmDegreesToRadians(360));
       
		int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 24.0);
        int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
        
		int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 47.0);	

	int avoidHuntShort=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 15.0);

		int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 10.0);

        int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 50.0);

		int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
        int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 45.0);
        int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 8.0);
        int avoidWater1 = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 20.0);

        int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 8.0);
        int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 25.0);
        
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 26.0);
        int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
        int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 36.0);  

        int avoidKingsHill=rmCreateTypeDistanceConstraint("avoid kings hill", "ypKingsHill", 15.0);

int treasureDist = 0;

if (seasonPick == 1){   
   treasureDist = 50;
}else{
	treasureDist = 60;
}
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", treasureDist);



int stayWest = rmCreatePieConstraint("Stay West",0.47,0.53, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(225),rmDegreesToRadians(45));
int stayEast = rmCreatePieConstraint("Stay East",0.53,0.47, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(45),rmDegreesToRadians(225));

   
 	//===== Player placing  ============

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);


    float spawnSwitch = rmRandFloat(0,1.2);
//for testing purposes
//spawnSwitch = (0.1);


	if (cNumberTeams == 2){
		if (spawnSwitch <=0.6){

	if (cNumberNonGaiaPlayers == 2)
	{
			rmPlacePlayer(1, 0.5, 0.8);
			rmPlacePlayer(2, 0.5, 0.2);
	}

	if (cNumberNonGaiaPlayers == 4)
	{			
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.45, 0.75, 0.25, 0.55, 0, 0);
		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.55, 0.25, 0.75, 0.45, 0, 0);

	}


			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.15, 0.45, 0.55, 0.85, 0, 0);
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.85, 0.55, 0.45, 0.15, 0, 0);
		}else if(spawnSwitch <=1.2){

	if (cNumberNonGaiaPlayers == 2)
	{
			rmPlacePlayer(2, 0.5, 0.8);
			rmPlacePlayer(1, 0.5, 0.2);
	}

	if (cNumberNonGaiaPlayers == 4)
	{			
		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.45, 0.75, 0.24, 0.54, 0, 0);
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.54, 0.24, 0.75, 0.45, 0, 0);

	}


			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.15, 0.45, 0.55, 0.85, 0, 0);
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.85, 0.55, 0.45, 0.15, 0, 0);
		}
	}else{
	
			rmPlacePlayer(1, 0.15, 0.45);
			rmPlacePlayer(2, 0.85, 0.55);
			rmPlacePlayer(3, 0.45, 0.15);
			rmPlacePlayer(4, 0.55, 0.85);

	if (cNumberNonGaiaPlayers == 5){
			rmPlacePlayer(5, 0.35, 0.65);
}
	if (cNumberNonGaiaPlayers == 6){
			rmPlacePlayer(5, 0.35, 0.65);
			rmPlacePlayer(6, 0.65, 0.35);
}
	if (cNumberNonGaiaPlayers == 7){
			rmPlacePlayer(5, 0.35, 0.65);
			rmPlacePlayer(6, 0.58, 0.28);
			rmPlacePlayer(7, 0.71, 0.41);

}
	if (cNumberNonGaiaPlayers == 8){
			rmPlacePlayer(5, 0.41, 0.71);
			rmPlacePlayer(6, 0.58, 0.28);
			rmPlacePlayer(7, 0.71, 0.41);
			rmPlacePlayer(8, 0.28, 0.58);
}
	}


//=======================================================
		
        chooseMercs();
        rmSetStatusText("",0.1); 

//=======================================================

// Begin Map


        int continent2 = rmCreateArea("continent");
        rmSetAreaSize(continent2, 1.0, 1.0);
        rmSetAreaLocation(continent2, 0.5, 0.5);

if (seasonPick == 1){
		rmSetAreaMix(continent2, "rockies_grass_snowb");
}else{
        rmSetAreaMix(continent2, "great plains grass");
}
        rmSetAreaBaseHeight(continent2, 8.0);
        rmSetAreaCoherence(continent2, 1.0);
        rmSetAreaSmoothDistance(continent2, 10);
        rmSetAreaHeightBlend(continent2, 1);
        rmSetAreaElevationNoiseBias(continent2, 0);
        rmSetAreaElevationEdgeFalloffDist(continent2, 10);
        rmSetAreaElevationVariation(continent2, 5);
        rmSetAreaElevationPersistence(continent2, .2);
        rmSetAreaElevationOctaves(continent2, 5);
        rmSetAreaElevationMinFrequency(continent2, 0.04);
        rmSetAreaElevationType(continent2, cElevTurbulence);  
	rmSetAreaObeyWorldCircleConstraint(continent2, false);
        rmBuildArea(continent2);  
  
//===================================================

		int classPatch = rmDefineClass("patch");
		int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 22.0);
		int classCenter = rmDefineClass("center");
		int avoidCenter = rmCreateClassDistanceConstraint("avoid center", rmClassID("center"), 3.0);
		int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));


//get that centre section the right version

        int forest = rmCreateArea("TreeStripe");

if (seasonPick == 1){
        rmSetAreaLocation(forest, 0.5, 0.5);
        rmSetAreaTerrainType(forest, "yukon\groundforestsnow_yuk");
  	rmSetAreaMix(forest, "rockies_snow");
       rmAddAreaInfluenceSegment(forest, 0.0, 0.0, 1.0, 1.0);
        rmSetAreaSize(forest, .31, .33);      
        rmSetAreaBaseHeight(forest, 8.0);
        rmSetAreaCoherence(forest, 0.79);
        rmSetAreaSmoothDistance(forest, 10);
        rmSetAreaHeightBlend(forest, 1);
	rmSetAreaObeyWorldCircleConstraint(forest, false);
        rmBuildArea(forest);    
}
if (seasonPick == 2){
        rmSetAreaLocation(forest, 0.5, 0.5);
        rmSetAreaTerrainType(forest, "great_plains\groundforest_gp");
  	rmSetAreaMix(forest, "great plains grass");
       rmAddAreaInfluenceSegment(forest, 0.0, 0.0, 1.0, 1.0);
        rmSetAreaSize(forest, .39, .46);      
        rmSetAreaBaseHeight(forest, 8.0);
        rmSetAreaCoherence(forest, 0.79);
        rmSetAreaSmoothDistance(forest, 10);
        rmSetAreaHeightBlend(forest, 1);
	rmSetAreaObeyWorldCircleConstraint(forest, false);
        rmBuildArea(forest);    
}
if (seasonPick == 3){
        rmSetAreaLocation(forest, 0.5, 0.5);
        rmSetAreaTerrainType(forest, "great_plains\groundforest_gp");
  	rmSetAreaMix(forest, "great plains grass");
       rmAddAreaInfluenceSegment(forest, 0.0, 0.0, 1.0, 1.0);
        rmSetAreaSize(forest, .31, .33);      
        rmSetAreaBaseHeight(forest, 8.0);
        rmSetAreaCoherence(forest, 0.79);
        rmSetAreaSmoothDistance(forest, 10);
        rmSetAreaHeightBlend(forest, 1);
	rmSetAreaObeyWorldCircleConstraint(forest, false);
        rmBuildArea(forest);    
}


		rmSetStatusText("",0.2);



	//==============trade routes===================


		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 6.0);      
       
        int tradeRouteID = rmCreateTradeRoute();
        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 0.5);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 0.7);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 1.0);

        rmBuildTradeRoute(tradeRouteID, "dirt");
 
        vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.25);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.75);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

	if (cNumberNonGaiaPlayers >= 6)
	{

		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
}		
		//===========TR 2=================

		int socketID2=rmCreateObjectDef("sockets to dock Trade Posts2");
        rmAddObjectDefItem(socketID2, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID2, true);
        rmSetObjectDefMinDistance(socketID2, 0.0);
        rmSetObjectDefMaxDistance(socketID2, 6.0);      
       
        int tradeRouteID2 = rmCreateTradeRoute();
        rmSetObjectDefTradeRouteID(socketID2, tradeRouteID2);
		rmAddTradeRouteWaypoint(tradeRouteID2, 1.0, 0.55);
		rmAddTradeRouteWaypoint(tradeRouteID2, 0.7, 0.3);
		rmAddTradeRouteWaypoint(tradeRouteID2, 0.5, 0.0);

        rmBuildTradeRoute(tradeRouteID2, "dirt");
 
		vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.25);
        rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
	if (cNumberNonGaiaPlayers >= 6)
	{
            socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.50);
        rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
   }    
        socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.75);
        rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
       		
	//====================end tr 2================		 

//=======================THE RIVER==========================
				
if (seasonPick == 1){
//dat frozen river

		int frozenRiver=rmCreateArea("frozenRiver");
        rmSetAreaLocation(frozenRiver, 0.5, 0.5);
        rmAddAreaInfluenceSegment(frozenRiver, 0.0, 0.0, 1.0, 1.0);
        rmSetAreaSize(frozenRiver, .18, .21);  
		rmAddAreaToClass(frozenRiver, rmClassID("classPlateau"));
	rmSetAreaMix(frozenRiver, "great_lakes_ice");
        rmSetAreaBaseHeight(frozenRiver, 7.0);
        rmSetAreaCoherence(frozenRiver, .96);
	rmSetAreaObeyWorldCircleConstraint(frozenRiver, false);
        rmBuildArea(frozenRiver);

   int stayIce = rmCreateAreaConstraint("river constraint", frozenRiver);



//thawed spots
	for (j=0; < (5*cNumberNonGaiaPlayers)) {   

  //  float Thawed1 = rmRandFloat(0.1,0.9);



	int puddleOne=rmCreateArea("first thawed spot"+j);
     //   rmSetAreaLocation(puddleOne, Thawed1, Thawed1);
        rmSetAreaSize(puddleOne, rmAreaTilesToFraction(92), rmAreaTilesToFraction(107));      
        rmSetAreaWaterType(puddleOne, "great lakes ice");
	rmAddAreaConstraint(puddleOne, avoidWater1);
	rmAddAreaConstraint(puddleOne, stayIce);
        rmSetAreaBaseHeight(puddleOne, 7.0);
        rmSetAreaCoherence(puddleOne, .84);
        rmBuildArea(puddleOne);
}

}


if (seasonPick == 2){
	//dat river

	int riverID = rmRiverCreate(-5, riverType, 8, 8, (11+cNumberNonGaiaPlayers/2), (13+cNumberNonGaiaPlayers/2)); //
	rmRiverAddWaypoint(riverID, 0.0, 0.0);
	rmRiverAddWaypoint(riverID, 0.5, 0.5);
	rmRiverAddWaypoint(riverID, 1.0, 1.0);
//	rmRiverAddWaypoint(riverID, 0.7, 0.3);
//	rmRiverAddWaypoint(riverID, 1.0, 0.0);
	rmRiverSetBankNoiseParams(riverID, 0.07, 2, 15.0, 15.0, 0.667, 1.8);
	rmRiverSetShallowRadius(riverID, 11+cNumberNonGaiaPlayers*1.3);
	if (cNumberNonGaiaPlayers >= 6)
	{
		rmRiverAddShallow(riverID, 0.2);
		rmRiverAddShallow(riverID, 0.4);
		rmRiverAddShallow(riverID, 0.6);
		rmRiverAddShallow(riverID, 0.8);
	}
	else
	{
		rmRiverAddShallow(riverID, rmRandFloat(0.25,0.3));
		rmRiverAddShallow(riverID, rmRandFloat(0.49,0.51));
		rmRiverAddShallow(riverID, rmRandFloat(0.7,0.75));
	}
	rmRiverBuild(riverID);


       		for (i=0; < cNumberNonGaiaPlayers*35){
			int patchID = rmCreateArea("first patch"+i);
			rmSetAreaWarnFailure(patchID, false);
			rmSetAreaSize(patchID, rmAreaTilesToFraction(55), rmAreaTilesToFraction(68));
        		rmSetAreaTerrainType(patchID, "great_plains\ground6_gp");
	//		rmAddAreaToClass(patchID, rmClassID("patch"));
			rmSetAreaSmoothDistance(patchID, 1.0);
			rmBuildArea(patchID); 
		}



}

if (seasonPick == 3){
//dat flooded river

		int straightLake=rmCreateArea("straightLake");
        rmSetAreaLocation(straightLake, 0.5, 0.5);
        rmAddAreaInfluenceSegment(straightLake, 0.0, 0.0, 1.0, 1.0);
        rmSetAreaSize(straightLake, .21, .22);      
        rmSetAreaWaterType(straightLake, "Mississippi");
        rmSetAreaBaseHeight(straightLake, 8.0);
        rmSetAreaCoherence(straightLake, .83);
	rmSetAreaObeyWorldCircleConstraint(straightLake, false);
        rmBuildArea(straightLake);
}
	

//=============KOTH================

	if (rmGetIsKOTH()) {
		float xLoc = 0.5;
		float yLoc = 0.5;
		float walk = 0.02;

if (seasonPick == 1){
		ypKingsHillLandfill(xLoc, yLoc, 0.0054, 8, "yukon snow", 0);

}else{
		ypKingsHillLandfill(xLoc, yLoc, 0.0054, 8, "great plains drygrass", 0);
}
		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
	}



	
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
      subCiv0=rmGetCivID("Cheyenne");
      rmEchoInfo("subCiv0 is Cheyenne "+subCiv0);
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Cheyenne");

		subCiv1=rmGetCivID("Cheyenne");
      rmEchoInfo("subCiv1 is Cheyenne "+subCiv1);
		if (subCiv1 >= 0)
			 rmSetSubCiv(1, "Cheyenne");
	 
		subCiv2=rmGetCivID("Cheyenne");
      rmEchoInfo("subCiv2 is Cheyenne "+subCiv2);
      if (subCiv2 >= 0)
         rmSetSubCiv(2, "Cheyenne");

		subCiv3=rmGetCivID("Cheyenne");
      rmEchoInfo("subCiv3 is Cheyenne "+subCiv3);
      if (subCiv3 >= 0)
         rmSetSubCiv(3, "Cheyenne");
	}
	
	// Set up Natives	
	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
		
	nativeID0 = rmCreateGrouping("Cheyenne village A", "native cheyenne village "+2);
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.2, 0.8);

	nativeID1 = rmCreateGrouping("Cheyenne village B", "native cheyenne village "+5);
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.8, 0.2);
	
//=======================================================

		rmSetStatusText("",0.4);

//=======================================================

		//starting objects


		
        int playerStart = rmCreateStartingUnitsObjectDef(5.0);
        rmSetObjectDefMinDistance(playerStart, 7.0);
        rmSetObjectDefMaxDistance(playerStart, 12.0);
	rmAddObjectDefConstraint(playerStart, avoidWaterShort);

       
        int goldID = rmCreateObjectDef("starting gold");
        rmAddObjectDefItem(goldID, "mine", 1, 3.0);
        rmSetObjectDefMinDistance(goldID, 12.0);
        rmSetObjectDefMaxDistance(goldID, 14.0);
       
        int goldID2 = rmCreateObjectDef("starting gold 2");
        rmAddObjectDefItem(goldID2, "mine", 1, 16.0);
        rmSetObjectDefMinDistance(goldID2, 12.0);
        rmSetObjectDefMaxDistance(goldID2, 12.0);
        rmAddObjectDefConstraint(goldID2, avoidCoin);
 
        int berryID = rmCreateObjectDef("starting berries");
        rmAddObjectDefItem(berryID, "BerryBush", 8, 6.0);
        rmSetObjectDefMinDistance(berryID, 10.0);
        rmSetObjectDefMaxDistance(berryID, 12.0);
        rmAddObjectDefConstraint(berryID, avoidCoin);
 
        int treeID = rmCreateObjectDef("starting trees");
        rmAddObjectDefItem(treeID, treeType, rmRandInt(6,9), 10.0);
        rmSetObjectDefMinDistance(treeID, 12.0);
        rmSetObjectDefMaxDistance(treeID, 18.0);
        rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
        rmAddObjectDefConstraint(treeID, avoidCoin);
 
        int foodID = rmCreateObjectDef("starting hunt");
        rmAddObjectDefItem(foodID, "bison", 8, 8.0);
        rmSetObjectDefMinDistance(foodID, 10.0);
        rmSetObjectDefMaxDistance(foodID, 13.0);
	rmAddObjectDefConstraint(foodID, avoidPlateau);	
	rmAddObjectDefConstraint(foodID, avoidWaterShort);	
        rmSetObjectDefCreateHerd(foodID, false);
 
        int foodID2 = rmCreateObjectDef("starting hunt 2");
        rmAddObjectDefItem(foodID2, "deer", 7, 5.0);
        rmSetObjectDefMinDistance(foodID2, 28.0);
        rmSetObjectDefMaxDistance(foodID2, 30.0);
	rmAddObjectDefConstraint(foodID2, avoidPlateau);
	rmAddObjectDefConstraint(foodID2, avoidWaterShort);		
        rmSetObjectDefCreateHerd(foodID2, true);
                       
		int foodID3 = rmCreateObjectDef("starting hunt 3");
        rmAddObjectDefItem(foodID3, "bison", 8, 8.0);
        rmSetObjectDefMinDistance(foodID3, 38.0);
        rmSetObjectDefMaxDistance(foodID3, 40.0);
	rmAddObjectDefConstraint(foodID3, avoidPlateau);
	rmAddObjectDefConstraint(foodID3, avoidWaterShort);
	rmAddObjectDefConstraint(foodID3, avoidHuntShort);	
        rmSetObjectDefCreateHerd(foodID3, true);

		int extraberrywagon=rmCreateObjectDef("JapAn cAnT hUnT");
  rmAddObjectDefItem(extraberrywagon, "ypBerryWagon1", 1, 0.0);
  rmSetObjectDefMinDistance(extraberrywagon, 8.0);
  rmSetObjectDefMaxDistance(extraberrywagon, 10.0);




		rmSetStatusText("",0.5); 

//place those TCs
     
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
		//rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	//rmPlaceObjectDefAtLoc(goldID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	rmPlaceObjectDefAtLoc(foodID3, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));


	if (rmGetPlayerCiv(i) == rmGetCivID("Japanese")) {
        rmPlaceObjectDefAtLoc(extraberrywagon, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        }
	if (seasonPick == 3){
   	flag1 = (rmPlayerLocXFraction(i)+rmPlayerLocZFraction(i))/2;

		int waterFlag = rmCreateObjectDef("HC water flag "+i);
         rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 5.0);
         rmSetObjectDefMinDistance(waterFlag, 0);
         rmSetObjectDefMaxDistance(waterFlag, 20);
         rmPlaceObjectDefAtLoc(waterFlag, i, flag1, flag1, 1);

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

}

	}
	rmSetStatusText("",0.6);
	/*
	==================
	resource placement
	==================
	*/


	   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 15.0);

	if (cNumberNonGaiaPlayers == 2)
{
  	int smollMines = rmCreateObjectDef("competitive gold");
	rmAddObjectDefItem(smollMines, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(smollMines, 0.0);
	rmSetObjectDefMaxDistance(smollMines, 1);
	rmAddObjectDefConstraint(smollMines, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.4, 0.06, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.6, 0.94, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.64, 0.36, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.36, 0.64, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.16, 0.76, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.74, 0.14, 1);

}


    int pronghornHunts = rmCreateObjectDef("pronghornHunts");
	rmAddObjectDefItem(pronghornHunts, "bison", rmRandInt(9,10), 14.0);
	rmSetObjectDefCreateHerd(pronghornHunts, true);
	rmSetObjectDefMinDistance(pronghornHunts, 0);
	rmSetObjectDefMaxDistance(pronghornHunts, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(pronghornHunts, circleConstraint);
//	rmAddObjectDefConstraint(pronghornHunts, avoidTownCenterMore);
	rmAddObjectDefConstraint(pronghornHunts, avoidHunt);
	rmAddObjectDefConstraint(pronghornHunts, avoidKingsHill);
	rmAddObjectDefConstraint(pronghornHunts, avoidWaterShort);	
//	rmAddObjectDefConstraint(pronghornHunts, avoidPlateau);	
	rmAddObjectDefConstraint(pronghornHunts, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers);






  	int eastmine = rmCreateObjectDef("east mines");
	rmAddObjectDefItem(eastmine, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(eastmine, 0.0);
	rmSetObjectDefMaxDistance(eastmine, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(eastmine, avoidCoinMed);
	//rmAddObjectDefConstraint(eastmine, avoidTownCenterMore);
	rmAddObjectDefConstraint(eastmine, avoidSocket);
	rmAddObjectDefConstraint(eastmine, avoidPlateau);	
	rmAddObjectDefConstraint(eastmine, avoidWaterShort);
	rmAddObjectDefConstraint(eastmine, forestConstraintShort);
	rmAddObjectDefConstraint(eastmine, stayEast);
	rmAddObjectDefConstraint(eastmine, circleConstraint);
	rmAddObjectDefConstraint(eastmine, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(eastmine, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
 
  	int westmine = rmCreateObjectDef("west mines");
	rmAddObjectDefItem(westmine, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(westmine, 0.0);
	rmSetObjectDefMaxDistance(westmine, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(westmine, avoidCoinMed);
	//rmAddObjectDefConstraint(westmine, avoidTownCenterMore);
	rmAddObjectDefConstraint(westmine, avoidSocket);
	rmAddObjectDefConstraint(westmine, avoidPlateau);	
	rmAddObjectDefConstraint(westmine, avoidWaterShort);
	rmAddObjectDefConstraint(westmine, forestConstraintShort);
	rmAddObjectDefConstraint(westmine, stayWest);
	rmAddObjectDefConstraint(westmine, circleConstraint);
	rmAddObjectDefConstraint(westmine, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(westmine, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

	rmSetStatusText("",0.7);


//add winter stronk nuggs & sheep
if (seasonPick == 1){

	int westNuggs= rmCreateObjectDef("nuggets for west"); 
	rmAddObjectDefItem(westNuggs, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(westNuggs, 0.0); 
	rmSetObjectDefMaxDistance(westNuggs, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(westNuggs, avoidNugget); 
	rmAddObjectDefConstraint(westNuggs, circleConstraint);
	rmAddObjectDefConstraint(westNuggs, avoidTownCenter);
	rmAddObjectDefConstraint(westNuggs, forestConstraintShort);
	rmAddObjectDefConstraint(westNuggs, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(westNuggs, avoidPlateau); 
	rmAddObjectDefConstraint(westNuggs, stayWest);	
	rmAddObjectDefConstraint(westNuggs, avoidCoin);	
	rmAddObjectDefConstraint(westNuggs, avoidImpassableLand);
	rmSetNuggetDifficulty(3, 3); 
	rmPlaceObjectDefAtLoc(westNuggs, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);   

	int eastNuggs= rmCreateObjectDef("nuggets for east"); 
	rmAddObjectDefItem(eastNuggs, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(eastNuggs, 0.0); 
	rmSetObjectDefMaxDistance(eastNuggs, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(eastNuggs, avoidNugget); 
	rmAddObjectDefConstraint(eastNuggs, circleConstraint);
	rmAddObjectDefConstraint(eastNuggs, avoidTownCenter);
	rmAddObjectDefConstraint(eastNuggs, forestConstraintShort);
	rmAddObjectDefConstraint(eastNuggs, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(eastNuggs, avoidPlateau); 
	rmAddObjectDefConstraint(eastNuggs, stayEast);	
	rmAddObjectDefConstraint(eastNuggs, avoidCoin);	
	rmAddObjectDefConstraint(eastNuggs, avoidImpassableLand);
	rmSetNuggetDifficulty(3, 3); 
	rmPlaceObjectDefAtLoc(eastNuggs, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);   

}

  	int lostSheepers = rmCreateObjectDef("sad sheep");
	rmAddObjectDefItem(lostSheepers, "sheep", rmRandInt(1,1), 7.0);
	rmSetObjectDefMinDistance(lostSheepers, 0.0);
	rmSetObjectDefMaxDistance(lostSheepers, rmXFractionToMeters(0.5));
//	rmAddObjectDefConstraint(lostSheepers, avoidCoin);
	rmAddObjectDefConstraint(lostSheepers, avoidTownCenterMore);
	rmAddObjectDefConstraint(lostSheepers, avoidSocket);
	rmAddObjectDefConstraint(lostSheepers, avoidHerd);
//	rmAddObjectDefConstraint(lostSheepers, forestConstraintShort);
	rmAddObjectDefConstraint(lostSheepers, avoidPlateau);	
	rmAddObjectDefConstraint(lostSheepers, circleConstraint);
	rmAddObjectDefConstraint(lostSheepers, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(lostSheepers, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);



	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
	rmAddObjectDefConstraint(nuggetID, forestConstraintShort);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(nuggetID, avoidSocket); 
	rmAddObjectDefConstraint(nuggetID, avoidWaterShort);	
	rmAddObjectDefConstraint(nuggetID, avoidCoin);	
	rmAddObjectDefConstraint(nuggetID, avoidPlateau); 
	rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
	rmSetNuggetDifficulty(1, 2); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);   



	rmSetStatusText("",0.8);
	//removes loop for faster loading times
	//for (j=0; < (6*cNumberNonGaiaPlayers)) {   
		int mapTrees=rmCreateObjectDef("map trees");
		rmAddObjectDefItem(mapTrees, treeType, rmRandInt(12,15), rmRandFloat(12.0,13.0));
if (seasonPick >= 2){
		rmAddObjectDefItem(mapTrees, "UnderbrushCarolinas", rmRandInt(4,5), rmRandFloat(12.0,13.0));
}
		rmAddObjectDefToClass(mapTrees, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(mapTrees, 0);
		rmSetObjectDefMaxDistance(mapTrees, rmXFractionToMeters(0.47));
//		rmAddObjectDefConstraint(mapTrees, avoidTradeRouteSmall);
	//	rmAddObjectDefConstraint(mapTrees, avoidSocket);
	//  	rmAddObjectDefConstraint(mapTrees, circleConstraint);
		rmAddObjectDefConstraint(mapTrees, forestConstraint);
		rmAddObjectDefConstraint(mapTrees, avoidTownCenterMore);	
		rmAddObjectDefConstraint(mapTrees, avoidCoin);	
		rmAddObjectDefConstraint(mapTrees, avoidKingsHill);
		rmAddObjectDefConstraint(mapTrees, avoidPlateau);	
		rmAddObjectDefConstraint(mapTrees, avoidWaterShort);	
		rmAddObjectDefConstraint(mapTrees, avoidImpassableLand);
		rmPlaceObjectDefAtLoc(mapTrees, 0, 0.5, 0.5, 100*cNumberNonGaiaPlayers);
	//}
		rmSetStatusText("",0.9);


   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .05, 0);
   }


if (seasonPick >= 2){

	int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fishSalmon", 12.0);
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 5.0);
        int avoidShallows=rmCreateTypeDistanceConstraint("avoid shallows", "RiverShallowsPam", 10.0);

	int fishID=rmCreateObjectDef("fish Mahi");
	rmAddObjectDefItem(fishID, "fishSalmon", 1, 0.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, fishVsFishID);
	rmAddObjectDefConstraint(fishID, fishLand);
	rmAddObjectDefConstraint(fishID, avoidShallows);
	rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);
	}



	rmSetStatusText("",0.99);


}
 