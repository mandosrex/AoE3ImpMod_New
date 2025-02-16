/*
==============================
	      Manitoba
          by dansil92
==============================
*/
include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// observer UI by Aizamk

int TeamNum = cNumberTeams;
int PlayerNum = cNumberNonGaiaPlayers;
int numPlayer = cNumberPlayers;


// Main entry point for random map script


 
void main(void) {
	rmSetStatusText("",0.01);

	bool isObserverMode=false;
	if (rmIsObserverMode() == true) {
		isObserverMode=true;
	}

	if (isObserverMode == true) {
		//Decides if it is 1v1, 2v2 or 3v3 obs
		if (rmGetIsFFA() == true || PlayerNum == 2)
		{
			PlayerNum = 2;
			numPlayer = 3;
		}
		else if(rmGetPlayerTeam(2)!=rmGetPlayerTeam(3))
		{
			PlayerNum = 4;
			numPlayer = 5;
		}
		else if(rmGetPlayerTeam(3)!=rmGetPlayerTeam(4))
		{
			PlayerNum = 6;
			numPlayer = 7;
		}
		TeamNum = 2;
	}

   // Picks the map size
	int playerTiles=12000;
	if (PlayerNum > 4){
		playerTiles = 10000;
	}else if (PlayerNum > 6){
		playerTiles = 9000;
	}



	int size = 2.0 * sqrt(PlayerNum*playerTiles);

	rmSetMapSize(size, size);

	rmSetMapType("land");
        rmSetMapType("grass");
	rmSetMapType("greatlakes");
	rmSetMapType("namerica");
	rmSetMapType("AIFishingUseful");

	rmSetWorldCircleConstraint(true);


		rmSetLightingSet("301a_malta");

        rmDefineClass("classForest");
		rmDefineClass("classPlateau");
	rmSetSeaLevel(-1.0);
		rmSetSeaType("Lisbon");
       	rmTerrainInitialize("grass");
		rmSetWindMagnitude(4.0);


		//Constraints
		int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 24.0);

int avoidPlateauShort =rmCreateClassDistanceConstraint("stuff vs. cliffs smoll", rmClassID("classPlateau"), 8.0);


        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.46), rmDegreesToRadians(0), rmDegreesToRadians(360));
       
		int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 21.0);
        int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
        
		int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 49.0);


		int avoidHuntSmall=rmCreateTypeDistanceConstraint("avoid hunts", "huntable", 24.0);

		int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 10.0);


        int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 24.0);

		int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
		int avoidTree=rmCreateTypeDistanceConstraint("avoid trees", "TreeSaguenay", 11.0);




		int waterCoin=rmCreateTypeDistanceConstraint("avoid coin smallest", "Mine", 14.0);


        int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 55.0);
        int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 19.0);
        int cliffWater = rmCreateTerrainDistanceConstraint("cliff avoids river", "Land", false, 7.0);



int playerFactor = 0;

	if (PlayerNum >= 5){
	playerFactor = 8;
}

	if (PlayerNum >= 5 && TeamNum >= 3){
	playerFactor = 12;
}


        int cliffWater2 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 28.0+playerFactor);


        int cliffWater3 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 2.5);


        int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 8.0);
        int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 25.0);
        
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 30.0);
        int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
        int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 90.0);  
       
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 46.0);

  int avoidBerries=rmCreateTypeDistanceConstraint("avoid berries", "berrybush", 20.0);
  int avoidBerriesSmall=rmCreateTypeDistanceConstraint("avoid berries smoll", "berrybush", 8.0);


int stayWest = rmCreatePieConstraint("Stay West",0.47,0.53, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(180),rmDegreesToRadians(0));

int stayEast = rmCreatePieConstraint("Stay East",0.53,0.47, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(180));

   



    
 // =============Player placement ======================= 
    float spawnSwitch = rmRandFloat(0,1.2);
//spawnSwitch = 0.1;

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);


	if (TeamNum == 2){
		if (spawnSwitch <=0.6){

	if (PlayerNum == 2)
	{
			rmPlacePlayer(1, 0.225, 0.71);
			rmPlacePlayer(2, 0.775, 0.29);
	}



	if (PlayerNum == 4)
	{			
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.25, 0.71, 0.25, 0.45, 0, 0);
		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.75, 0.29, 0.75, 0.55, 0, 0);

	}


			rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.25, 0.72, 0.25, 0.35, 0, 0);
			rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.75, 0.28, 0.75, 0.65, 0, 0);


		}else if(spawnSwitch <=1.2){

	if (PlayerNum == 2)
	{
			rmPlacePlayer(2, 0.225, 0.71);
			rmPlacePlayer(1, 0.775, 0.29);
	}



	if (PlayerNum == 4)
	{			
		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.25, 0.71, 0.25, 0.45, 0, 0);
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.75, 0.29, 0.75, 0.55, 0, 0);

	}


			rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.25, 0.72, 0.25, 0.35, 0, 0);
			rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.75, 0.28, 0.75, 0.65, 0, 0);

		}
	}else{
	//*************ffa placement********
		rmPlacePlayersCircular(0.4, 0.4, 0.00);
	}

		
        chooseMercs();
        rmSetStatusText("",0.1); 
        int continent2 = rmCreateArea("continent");
        rmSetAreaSize(continent2, 1.0, 1.0);
        rmSetAreaLocation(continent2, 0.5, 0.5);
	   rmSetAreaMix(continent2, "saguenay grass");
   //     rmSetAreaTerrainType(continent2, "cave\cave_ground1");       
	rmSetAreaBaseHeight(continent2, 6.0);
        rmSetAreaCoherence(continent2, 1.0);
        rmSetAreaSmoothDistance(continent2, 6);
	rmSetAreaEdgeFilling(continent2, 1.0);
        rmSetAreaHeightBlend(continent2, 2);
        rmSetAreaElevationNoiseBias(continent2, 0);
        rmSetAreaElevationEdgeFalloffDist(continent2, 6);
        rmSetAreaElevationVariation(continent2, 4);
        rmSetAreaElevationPersistence(continent2, .2);
        rmSetAreaElevationOctaves(continent2, 5);
        rmSetAreaElevationMinFrequency(continent2, 0.04);
        rmSetAreaElevationType(continent2, cElevTurbulence);  
	rmSetAreaObeyWorldCircleConstraint(continent2, false);
        rmBuildArea(continent2);    

		int classPatch = rmDefineClass("patch");
		int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 36.0);
		int classCenter = rmDefineClass("center");
		int avoidCenter = rmCreateClassDistanceConstraint("avoid center", rmClassID("center"), 36.0);
		int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.44), rmDegreesToRadians(0), rmDegreesToRadians(360));
        


		rmSetStatusText("",0.2);



//define player areas

for(i=1; < PlayerNum + 1) {

    int PlayerArea1 = rmCreateArea("NeedLand1"+i);
        rmSetAreaSize(PlayerArea1, rmAreaTilesToFraction(360), rmAreaTilesToFraction(360));
		rmAddAreaToClass(PlayerArea1, rmClassID("classPlateau"));
		rmAddAreaToClass(PlayerArea1, rmClassID("center"));
       rmSetAreaHeightBlend(PlayerArea1, 1);
        rmSetAreaLocation(PlayerArea1, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmSetAreaCoherence(PlayerArea1, 0.93);
        rmBuildArea(PlayerArea1);

}





//==========native island placement===============

		int lakeWest = rmCreateArea("west lake");
		rmSetAreaSize(lakeWest, 0.002, 0.002); 
		rmSetAreaCoherence(lakeWest, .92);
	if (TeamNum == 2){
		rmSetAreaLocation(lakeWest, .18, .3);
}else{
		rmSetAreaLocation(lakeWest, .30, .62);
}	
		rmAddAreaToClass(lakeWest, rmClassID("patch"));
        rmSetAreaSmoothDistance(lakeWest, 8);
        rmSetAreaTerrainType(lakeWest, "saguenay\ground4_sag");
	rmSetAreaObeyWorldCircleConstraint(lakeWest, false);
		rmBuildArea(lakeWest);


		int lakeEast = rmCreateArea("east lake");
		rmSetAreaSize(lakeEast, 0.002, 0.002); 
		rmSetAreaCoherence(lakeEast, .92);
	if (TeamNum == 2){
		rmSetAreaLocation(lakeEast, .82, .7);	
}else{
		rmSetAreaLocation(lakeEast, .7, .38);	
}
		rmAddAreaToClass(lakeEast, rmClassID("patch"));
        rmSetAreaSmoothDistance(lakeEast, 8);
        rmSetAreaTerrainType(lakeEast, "saguenay\ground4_sag");
	rmSetAreaObeyWorldCircleConstraint(lakeEast, false);
		rmBuildArea(lakeEast);

	if (PlayerNum >= 4)
{
		int lakeSE = rmCreateArea("southeast lake");
		rmSetAreaSize(lakeSE, 0.002, 0.002); 
		rmSetAreaCoherence(lakeSE, .92);

	if (TeamNum == 2){
		rmSetAreaLocation(lakeSE, .45, .10);
}else{
		rmSetAreaLocation(lakeSE, .75, .6);
}

		rmAddAreaToClass(lakeSE, rmClassID("patch"));	
        rmSetAreaSmoothDistance(lakeSE, 8);
        rmSetAreaTerrainType(lakeSE, "saguenay\ground4_sag");
	rmSetAreaObeyWorldCircleConstraint(lakeSE, false);
		rmBuildArea(lakeSE);


		int lakeSW = rmCreateArea("southwest lake");
		rmSetAreaSize(lakeSW, 0.002, 0.002); 
		rmSetAreaCoherence(lakeSW, .92);

	if (TeamNum == 2){
		rmSetAreaLocation(lakeSW, .55, .9);	
}else{
		rmSetAreaLocation(lakeSW, .25, .4);	
}

		rmAddAreaToClass(lakeSW, rmClassID("patch"));
        rmSetAreaSmoothDistance(lakeSW, 8);
        rmSetAreaTerrainType(lakeSW, "saguenay\ground4_sag");
	rmSetAreaObeyWorldCircleConstraint(lakeSW, false);
		rmBuildArea(lakeSW);
}




//===========trade route=================

		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 10.0);   
	rmAddObjectDefConstraint(socketID, avoidWaterShort);	
   
       
        int tradeRouteID = rmCreateTradeRoute();


        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

	rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 0.9);


	rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 0.75);
 	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.6); 
 	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.4); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.45, 0.25); 


	rmAddTradeRouteWaypoint(tradeRouteID, 1.0, 0.1);

        rmBuildTradeRoute(tradeRouteID, "dirt");



//======================================================

		rmSetStatusText("",0.3);

int avoidTPSocket =rmCreateTypeDistanceConstraint("avoid trade socket", "SocketTradeRoute", 14.0);


int avoidCree =rmCreateTypeDistanceConstraint("avoid cree socket", "SocketCree", 18.0);


	if (PlayerNum == 2)
{
  	int smollMines = rmCreateObjectDef("competitive gold");
	rmAddObjectDefItem(smollMines, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(smollMines, 0.0);
	rmSetObjectDefMaxDistance(smollMines, 0.0);
//back mines
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.35, 0.9, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.65, 0.1, 1);
//edge "anchor" mines
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.22, 0.5, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.78, 0.5, 1);

//tp line mines
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.45, 0.73, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.55, 0.27, 1);

}

		int avoidCoinSPC=rmCreateTypeDistanceConstraint("avoid coin special", "Mine", 17.0);

//==========random lakes==============

	for (j=0; < (9*PlayerNum)) {   
			int ffaCliffs = rmCreateArea("ffaCliffs"+j);
        rmSetAreaSize(ffaCliffs, rmAreaTilesToFraction(900), rmAreaTilesToFraction(1000));
		rmAddAreaToClass(ffaCliffs, rmClassID("classPlateau"));
        rmSetAreaWaterType(ffaCliffs, "Saguenay Lake");
        rmSetAreaSmoothDistance(ffaCliffs, 10);
        rmSetAreaHeightBlend(ffaCliffs, 3);
//	rmSetAreaObeyWorldCircleConstraint(ffaCliffs, false);

	rmAddAreaConstraint(ffaCliffs, avoidCenter);
	rmAddAreaConstraint(ffaCliffs, avoidPatch);
	rmAddAreaConstraint(ffaCliffs, avoidPlateau);
	rmAddAreaConstraint(ffaCliffs, avoidTPSocket);
	rmAddAreaConstraint(ffaCliffs, cliffWater2);
//	rmAddAreaRemoveType(ffaCliffs, "mine");
	rmAddAreaConstraint(ffaCliffs, avoidTradeRouteSmall);
	rmAddAreaConstraint(ffaCliffs, avoidCoinSPC);


	
if (j == 2){
	rmSetAreaLocation(ffaCliffs, .6, .55);
}
if (j == 3){
		rmSetAreaLocation(ffaCliffs, .4, .45);
}
if (j == 0){
		rmSetAreaLocation(ffaCliffs, .5, .9);
}

if (j == 1){
		rmSetAreaLocation(ffaCliffs, .5, .1);
}

if (j == 4){
		rmSetAreaLocation(ffaCliffs, .1, .5);
}

if (j == 5){
		rmSetAreaLocation(ffaCliffs, .9, .5);
}

//avoidTradeRouteSmall 
        rmSetAreaCoherence(ffaCliffs, .93);

        rmBuildArea(ffaCliffs);  
	}
			

//================ ISLAND TIME ========

for(j=0; < 4 ) {
   int centreIslands = rmCreateArea("centre islands"+j);
        rmSetAreaSize(centreIslands, .013, .014);
        rmSetAreaBaseHeight(centreIslands, 6.0);
//	   rmSetAreaMix(centreIslands, "borneo_grass_a");
        rmSetAreaCoherence(centreIslands, 0.9);
        rmSetAreaHeightBlend(centreIslands, 3);
	rmSetAreaObeyWorldCircleConstraint(centreIslands, false);


if (j == 0){
	rmSetAreaLocation(centreIslands, .28, .85);
}
if (j == 1){
		rmSetAreaLocation(centreIslands, .72, .15);
}
if (j == 2){
		rmSetAreaLocation(centreIslands, .52, .73);
}

if (j == 3){
		rmSetAreaLocation(centreIslands, .48, .27);
}

        rmBuildArea(centreIslands);
}

//====================================================
	rmPlaceObjectDefAtLoc(socketID, 0, 0.28, 0.85, 1);   
	rmPlaceObjectDefAtLoc(socketID, 0, 0.72, 0.15, 1);   
	rmPlaceObjectDefAtLoc(socketID, 0, 0.52, 0.73, 1);   
	rmPlaceObjectDefAtLoc(socketID, 0, 0.48, 0.27, 1);   
//====================================================




// BUILD NATIVE SITES

	//Choose Natives
	int subCiv0=-1;
	int subCiv1=-1;
	int subCiv2=-1;
	int subCiv3=-1;

//Cree are awesome


   if (rmAllocateSubCivs(4) == true)
   {
      subCiv0=rmGetCivID("Cree");
      rmEchoInfo("subCiv0 is Cree "+subCiv0);
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Cree");

		subCiv1=rmGetCivID("Cree");
      rmEchoInfo("subCiv1 is Cree"+subCiv1);
		if (subCiv1 >= 0)
			 rmSetSubCiv(1, "Cree");
	 
		subCiv2=rmGetCivID("Cree");
      rmEchoInfo("subCiv2 is Cree"+subCiv2);
      if (subCiv2 >= 0)
         rmSetSubCiv(2, "Cree");

		subCiv3=rmGetCivID("Cree");
      rmEchoInfo("subCiv3 is Cree"+subCiv3);
      if (subCiv3 >= 0)
         rmSetSubCiv(3, "Cree");
	}
	
	// Set up Natives	
	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
		
	nativeID0 = rmCreateGrouping("native site 1", "native cree village 1");
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
	rmAddGroupingToClass(nativeID0, rmClassID("patch"));

	nativeID1 = rmCreateGrouping("native site 2", "native cree village 5");
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
	rmAddGroupingToClass(nativeID1, rmClassID("patch"));

//========place=====
	if (TeamNum == 2){
//sides
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.18, 0.3);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.82, 0.7);

	if (PlayerNum >= 4)
{
//top & bottom
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.45, 0.1);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.55, 0.9);
}
}else{
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.30, 0.62);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.70, 0.38);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.75, 0.6);
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.25, 0.40);

}



		rmSetStatusText("",0.4);
	
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
        rmAddObjectDefItem(berryID, "BerryBush", 5, 4.0);
        rmSetObjectDefMinDistance(berryID, 16.0);
        rmSetObjectDefMaxDistance(berryID, 17.0);
        rmAddObjectDefConstraint(berryID, avoidCoin);
 
        int treeID = rmCreateObjectDef("starting trees");
        rmAddObjectDefItem(treeID, "UnderbrushForest", rmRandInt(3,4), 9.0);
        rmAddObjectDefItem(treeID, "TreeSaguenay", rmRandInt(9,10), 6.0);
        rmSetObjectDefMinDistance(treeID, 20.0);
        rmSetObjectDefMaxDistance(treeID, 24.0);
        rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
        rmAddObjectDefConstraint(treeID, avoidCoin);
        rmAddObjectDefConstraint(treeID, avoidTree);


 
        int foodID = rmCreateObjectDef("starting hunt");
        rmAddObjectDefItem(foodID, "moose", 6, 8.0);
        rmSetObjectDefMinDistance(foodID, 10.0);
        rmSetObjectDefMaxDistance(foodID, 12.0);
	rmAddObjectDefConstraint(foodID, avoidWaterShort);	
        rmSetObjectDefCreateHerd(foodID, false);
 
        int foodID2 = rmCreateObjectDef("starting hunt 2");
        rmAddObjectDefItem(foodID2, "elk", 5, 6.0);
        rmSetObjectDefMinDistance(foodID2, 29.0);
        rmSetObjectDefMaxDistance(foodID2, 30.0);
        rmSetObjectDefCreateHerd(foodID2, true);
	rmAddObjectDefConstraint(foodID2, avoidWaterShort);	
	rmAddObjectDefConstraint(foodID2, circleConstraint);


                       
		int foodID3 = rmCreateObjectDef("starting hunt 3");
        rmAddObjectDefItem(foodID3, "elk", 9, 6.0);
        rmSetObjectDefMinDistance(foodID3, 39.0);
        rmSetObjectDefMaxDistance(foodID3, 39.0);
	rmAddObjectDefConstraint(foodID3, avoidWaterShort);	
	rmAddObjectDefConstraint(foodID3, circleConstraint);
	rmAddObjectDefConstraint(foodID3, avoidHuntSmall);
        rmSetObjectDefCreateHerd(foodID3, true);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmSetNuggetDifficulty(1, 1); 
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 3.0);
    rmSetObjectDefMinDistance(playerNuggetID, 29.0);
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
    
    for(i=1; < PlayerNum + 1) {
		int id=rmCreateArea("Player"+i);
		rmSetPlayerArea(i, id);
		int startID = rmCreateObjectDef("object"+i);
   	if ( rmGetNomadStart())
 		rmAddObjectDefItem(startID, "coveredWagon", 1, 3.0);
  	else
		rmAddObjectDefItem(startID, "townCenter", 1, 3.0);
		rmSetObjectDefMinDistance(startID, 0.0);
		rmSetObjectDefMaxDistance(startID, 5.0);

		rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i)+rmXTilesToFraction(12), rmPlayerLocZFraction(i));

	if (PlayerNum >= 3){
        rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID3, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
 }       



	rmPlaceObjectDefAtLoc(goldID2 , i, rmPlayerLocXFraction(i)-rmXTilesToFraction(12), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

        rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));


	if (rmGetPlayerCiv(i) == rmGetCivID("Japanese")) {
        rmPlaceObjectDefAtLoc(extraberrywagon, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        }

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

  	int copperMine = rmCreateObjectDef("east mines");
	rmAddObjectDefItem(copperMine, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(copperMine, rmXFractionToMeters(0.0));
	rmSetObjectDefMaxDistance(copperMine, rmXFractionToMeters(0.43));
	rmAddObjectDefConstraint(copperMine, avoidCoinMed);
	rmAddObjectDefConstraint(copperMine, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(copperMine, avoidTPSocket);	
	rmAddObjectDefConstraint(copperMine, cliffWater);
	rmAddObjectDefConstraint(copperMine, avoidTownCenter);
	rmAddObjectDefConstraint(copperMine, cliffWater3);
	rmPlaceObjectDefAtLoc(copperMine, 0, 0.5, 0.5, 10*PlayerNum);





    int pronghornHerd = rmCreateObjectDef("pronghornHerd");
	rmAddObjectDefItem(pronghornHerd, "elk", 9, 8.0);
	rmSetObjectDefCreateHerd(pronghornHerd, true);
	rmSetObjectDefMinDistance(pronghornHerd, 0);
	rmSetObjectDefMaxDistance(pronghornHerd, 5);


	if (PlayerNum == 2){	
//centre hunts
	rmPlaceObjectDefAtLoc(pronghornHerd, 0, 0.5, 0.78, 1);
	rmPlaceObjectDefAtLoc(pronghornHerd, 0, 0.5, 0.22, 1);
	rmPlaceObjectDefAtLoc(pronghornHerd, 0, 0.5, 0.5, 1);
//2nd hunt
	rmPlaceObjectDefAtLoc(pronghornHerd, 0, 0.11, 0.6, 1);
	rmPlaceObjectDefAtLoc(pronghornHerd, 0, 0.89, 0.4, 1);
//3rd hunt
	rmPlaceObjectDefAtLoc(pronghornHerd, 0, 0.25, 0.47, 1);
	rmPlaceObjectDefAtLoc(pronghornHerd, 0, 0.75, 0.53, 1);
//4th hunt
	rmPlaceObjectDefAtLoc(pronghornHerd, 0, 0.7, 0.16, 1);
	rmPlaceObjectDefAtLoc(pronghornHerd, 0, 0.3, 0.84, 1);


}else{	

	rmSetObjectDefMaxDistance(pronghornHerd, rmXFractionToMeters(0.41));
	rmAddObjectDefConstraint(pronghornHerd, circleConstraint2);
	rmAddObjectDefConstraint(pronghornHerd, avoidTownCenter);
	rmAddObjectDefConstraint(pronghornHerd, avoidHunt);
	rmAddObjectDefConstraint(pronghornHerd, avoidPlateauShort);
	rmAddObjectDefConstraint(pronghornHerd, cliffWater);	
	rmAddObjectDefConstraint(pronghornHerd, avoidCoin);	
	rmPlaceObjectDefAtLoc(pronghornHerd, 0, 0.5, 0.5, 7*PlayerNum);
}

	int avoidBighorn=rmCreateTypeDistanceConstraint("bighorn avoids food", "Moose", 65.0);

  	int cliffSheep = rmCreateObjectDef("water Moose");
	rmAddObjectDefItem(cliffSheep, "Moose", 5, 4.0);
	rmSetObjectDefMinDistance(cliffSheep, 0.0);
	rmSetObjectDefMaxDistance(cliffSheep, rmXFractionToMeters(0.42));
	//rmAddObjectDefConstraint(cliffSheep, waterHunt);
	rmAddObjectDefConstraint(cliffSheep, avoidTownCenterMore);	
	rmAddObjectDefConstraint(cliffSheep, avoidBighorn);	
	rmAddObjectDefConstraint(cliffSheep, avoidHunt);
	rmAddObjectDefConstraint(cliffSheep, circleConstraint2);
	rmPlaceObjectDefAtLoc(cliffSheep, 0, 0.5, 0.5, 3*PlayerNum);   


		rmSetStatusText("",0.7);



	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.42)); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetID, avoidTree);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
//	rmAddObjectDefConstraint(nuggetID, avoidTownCenterMore); 
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(nuggetID, cliffWater3);	
	rmAddObjectDefConstraint(nuggetID, avoidCoin);	
	rmSetNuggetDifficulty(1, 1); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 12*PlayerNum);   



	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 2.0);

	int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "FishBass", 9.0);


	int fishID=rmCreateObjectDef("fish Mahi");
	rmAddObjectDefItem(fishID, "FishBass", 1, 1.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.99));
	rmAddObjectDefConstraint(fishID, fishLand);
	rmAddObjectDefConstraint(fishID, fishVsFishID);

	rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 15*PlayerNum);   



		int bonusTrees=rmCreateObjectDef("bonusTrees");
		rmAddObjectDefItem(bonusTrees, "TreeSaguenay", rmRandInt(6,7), rmRandFloat(11.0,12.0));
	rmAddObjectDefItem(bonusTrees, "TreeSaguenay", rmRandInt(3,4), 10.0);
	rmAddObjectDefItem(bonusTrees, "UnderbrushForest", rmRandInt(6,7), 12.0);
		rmAddObjectDefToClass(bonusTrees, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(bonusTrees, 0);
		rmSetObjectDefMaxDistance(bonusTrees, rmXFractionToMeters(0.47));
	  	rmAddObjectDefConstraint(bonusTrees, avoidTradeRouteSmall);
	  	rmAddObjectDefConstraint(bonusTrees, avoidCoin);
		rmAddObjectDefConstraint(bonusTrees, forestConstraint);
		rmAddObjectDefConstraint(bonusTrees, avoidTownCenter);	
	  	rmAddObjectDefConstraint(bonusTrees, avoidCree);
	rmPlaceObjectDefAtLoc(bonusTrees, 0, 0.5, 0.5, 50*PlayerNum);   



// KOTH game mode 
   if(rmGetIsKOTH())
   {
      float xLoc = 0.5;
      float yLoc = 0.5;
      float walk = 0.1;
    
      ypKingsHillPlacer(xLoc, yLoc, walk, 0);
   }



	rmSetStatusText("",0.99);
	


	}
 
