/* 
===========
Tuparro (Obs)
by dansil92
===========
*/


include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{
	
	// Text
	// These status text lines are used to manually animate the map generation progress bar
	rmSetStatusText("",0.01); 


   // Picks the map size
	int playerTiles=10000;
	if (cNumberNonGaiaPlayers > 4){
		playerTiles = 9000;
	}else if (cNumberNonGaiaPlayers > 6){
		playerTiles = 7500;
	}
	
	int size = 2.0 * sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmSetMapSize(1.4*size, 0.9*size);


	rmSetSeaType("bayou");
 	rmSetBaseTerrainMix("bayou_grass");
	rmSetMapType("amazonia");
	rmSetMapType("tropical");
	rmSetMapType("grass");
	rmSetMapType("samerica");
	rmSetWorldCircleConstraint(true);
//	rmSetOceanReveal(true);
		rmSetSeaLevel(-1.0);
		rmSetLightingSet("sonora");
	rmSetWindMagnitude(5);
   rmSetGlobalRain( 0.8);

   // Init map.
   rmTerrainInitialize("water");

//water as base, with continent placed at similar height creates the random water/land patches



        rmDefineClass("classForest");
		rmDefineClass("classPlateau");


		
		//Constraints
		int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 12.0);

        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.49), rmDegreesToRadians(0), rmDegreesToRadians(360));
       
		int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 34.0);
        int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
        
		int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 50.0);
		int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 10.0);

        int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 50.0);

		int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
        int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 75.0);
        int avoidCoinMed2=rmCreateTypeDistanceConstraint("avoid coin medium2", "Mine", 48.0);

        int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 5.0);

        int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 8.0);
        int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 25.0);
        
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "TownCenter", 35.0);
        int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "TownCenter", 15.0);
        int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "TownCenter", 40.0);  
       
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 60.0);
       
	int NWconstraint = rmCreateBoxConstraint("stay in NW portion", 0, 0.53, 1, 1);
	int SEconstraint = rmCreateBoxConstraint("stay in SE portion", 0, 0, 1, 0.47);


 	//========= Player placing========= 
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);

    float spawnSwitch = rmRandFloat(0,1.2);

	if (cNumberTeams == 2){
		if (spawnSwitch <=0.6){
	if (cNumberNonGaiaPlayers == 2)
	{
			rmPlacePlayer(1, 0.52, 0.18);
			rmPlacePlayer(2, 0.52, 0.82);
	}

			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.4, 0.15, 0.65, 0.15, 0, 0);
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.4, 0.85, 0.65, 0.85, 0, 0);
		}else if(spawnSwitch <=1.2){
	if (cNumberNonGaiaPlayers == 2)
	{
			rmPlacePlayer(2, 0.52, 0.18);
			rmPlacePlayer(1, 0.52, 0.82);
	}
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.4, 0.15, 0.65, 0.15, 0, 0);
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.4, 0.85, 0.65, 0.85, 0, 0);
		}
	}else{
//ffa placement; avoids plateau
	rmSetPlacementSection(0.95, 0.55);
		rmPlacePlayersCircular(0.4, 0.4, 0.02);
	}

	
        chooseMercs();
        rmSetStatusText("",0.1); 
       

	 int continent2 = rmCreateArea("continent");
        rmSetAreaSize(continent2, 1.0, 1.0);
        rmSetAreaLocation(continent2, 0.5, 0.5);
      rmSetAreaMix(continent2, "bayou_grass");
        rmSetAreaBaseHeight(continent2, 0.2);
        rmSetAreaCoherence(continent2, 1.0);
        rmSetAreaSmoothDistance(continent2, 10);
        rmSetAreaHeightBlend(continent2, 1);
        rmSetAreaElevationNoiseBias(continent2, 0);
        rmSetAreaElevationEdgeFalloffDist(continent2, 10);
        rmSetAreaElevationVariation(continent2, 4);
        rmSetAreaElevationPersistence(continent2, .25);
        rmSetAreaElevationOctaves(continent2, 5);
        rmSetAreaElevationMinFrequency(continent2, 0.04);
        rmSetAreaElevationType(continent2, cElevTurbulence);  
        rmBuildArea(continent2);    

		int classPatch = rmDefineClass("patch");
		int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 22.0);
		int classCenter = rmDefineClass("center");
		int avoidCenter = rmCreateClassDistanceConstraint("avoid center", rmClassID("center"), 3.0);
		int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.7), rmDegreesToRadians(0), rmDegreesToRadians(360));
        
		int center = rmCreateArea("center");
		rmAddAreaToClass(center, rmClassID("center"));
        rmSetAreaSize(center, .1, .1);
        rmSetAreaLocation(center, 0.5, 0.5);
        rmSetAreaCoherence(center, 1.0);
        rmBuildArea(center);   


		rmSetStatusText("",0.2);

	



// ******KEEP BUILDABLE LAND UNDER TCS ******

for(i=1; < cNumberNonGaiaPlayers + 1) {

    int PlayerArea1 = rmCreateArea("NeedLand1"+i);
        rmSetAreaSize(PlayerArea1, .02, .021);
        rmSetAreaBaseHeight(PlayerArea1, 0.3);
        rmSetAreaLocation(PlayerArea1, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmSetAreaCoherence(PlayerArea1, 0.7);
        rmBuildArea(PlayerArea1);
}

//**End Player Land


//**Andes build start**

		int andesBase = rmCreateArea("west andesBase");
		rmSetAreaSize(andesBase, 0.16, 0.17); 
		rmAddAreaToClass(andesBase, rmClassID("classPlateau"));
		rmSetAreaCliffType(andesBase, "bayou");
		rmSetAreaCliffEdge(andesBase, 8, 0.1, 0.0, 0.0, 1); //4,.225 looks cool too
		rmSetAreaCliffPainting(andesBase, false, true, true, 0.4, true);
		rmSetAreaCliffHeight(andesBase, 6, 0.1, 0.5);
	//	rmAddAreaConstraint(andesBase, avoidTradeRouteSmall);
      rmSetAreaMix(andesBase, "bayou_grass");
		rmSetAreaCoherence(andesBase, .84);
		rmSetAreaLocation(andesBase, .08, .5);	
        rmAddAreaInfluenceSegment(andesBase, 0.04, 0.1, 0.04, 0.9);
		rmBuildArea(andesBase);



//=====carib tp islands=====

	if (cNumberTeams == 2){

		int socketland= rmCreateArea("tradepost island");
        rmSetAreaSize(socketland, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
        rmSetAreaBaseHeight(socketland, 1.0);
        rmSetAreaHeightBlend(socketland, 1);
        rmSetAreaLocation(socketland, .85, .64);
        rmSetAreaCoherence(socketland, 0.8);
        rmBuildArea(socketland);

        int socketland2= rmCreateArea("tradepost island2");
        rmSetAreaSize(socketland2, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
        rmSetAreaBaseHeight(socketland2, 1.0);
  rmSetAreaHeightBlend(socketland2, 1);
        rmSetAreaLocation(socketland2, .85, .36);
        rmSetAreaCoherence(socketland2, 0.8);
        rmBuildArea(socketland2);

}
else{
		socketland2= rmCreateArea("tradepost island");
        rmSetAreaSize(socketland2, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
        rmSetAreaBaseHeight(socketland2, 1.0);
  rmSetAreaHeightBlend(socketland2, 1);
        rmSetAreaLocation(socketland2, .6, .5);
        rmSetAreaCoherence(socketland2, 0.8);
        rmBuildArea(socketland2);
		
	socketland= rmCreateArea("tradepost island2");
        rmSetAreaSize(socketland, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
        rmSetAreaBaseHeight(socketland, 1.0);
        rmSetAreaHeightBlend(socketland, 1);
        rmSetAreaLocation(socketland, .4, .5);
        rmSetAreaCoherence(socketland, 0.8);
        rmBuildArea(socketland);

}


	//==============trade routes=================


int tradeSwitcher = rmRandInt(0,1);
//	tradeSwitcher = 1;
	if (cNumberTeams >= 3){
	tradeSwitcher = 2;
}

/*
	0 for single long trade route accross map
	1 for two parallel trade routes
	2 for FFA trade route, loops back on itself
*/


//define socket id and trade route id before placing

		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
		int socketID2=rmCreateObjectDef("sockets to dock Trade Posts2");
        int tradeRouteID = rmCreateTradeRoute();
        int tradeRouteID2 = rmCreateTradeRoute();


if (tradeSwitcher == 0){

//single trade route spawn: create islands for sockets

int	socketland3= rmCreateArea("tradepost island3");
        rmSetAreaSize(socketland3, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
        rmSetAreaBaseHeight(socketland3, 1.0);
  rmSetAreaHeightBlend(socketland3, 1);
        rmSetAreaLocation(socketland3, .35, .5);
        rmSetAreaCoherence(socketland3, 0.8);
        rmBuildArea(socketland3);
		
int	socketland4= rmCreateArea("tradepost island4");
        rmSetAreaSize(socketland4, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
        rmSetAreaBaseHeight(socketland4, 1.0);
        rmSetAreaHeightBlend(socketland4, 1);
        rmSetAreaLocation(socketland4, .6, .5);
        rmSetAreaCoherence(socketland4, 0.8);
        rmBuildArea(socketland4);

		
int	socketland5= rmCreateArea("tradepost island5");
        rmSetAreaSize(socketland5, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
        rmSetAreaBaseHeight(socketland5, 1.0);
        rmSetAreaHeightBlend(socketland5, 1);
        rmSetAreaLocation(socketland5, .8, .5);
        rmSetAreaCoherence(socketland5, 0.8);
        rmBuildArea(socketland5);


//build trade route***

        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 6.0);      
       
        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, .0, .5);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, .4, .55, 4, 2);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, .6, .45, 4, 2);
		rmAddTradeRouteWaypoint(tradeRouteID, 1.0, .5);

       rmBuildTradeRoute(tradeRouteID, "dirt");
 
        vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.35);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.12);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.6);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

}

if (tradeSwitcher == 1){


//two parallel routes, build islands for first route

	socketland3= rmCreateArea("tradepost island3");
        rmSetAreaSize(socketland3, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
        rmSetAreaBaseHeight(socketland3, 1.0);
  rmSetAreaHeightBlend(socketland3, 1);
        rmSetAreaLocation(socketland3, .78, .15);
        rmSetAreaCoherence(socketland3, 0.8);
        rmBuildArea(socketland3);
		
	socketland4= rmCreateArea("tradepost island4");
        rmSetAreaSize(socketland4, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
        rmSetAreaBaseHeight(socketland4, 1.0);
        rmSetAreaHeightBlend(socketland4, 1);
        rmSetAreaLocation(socketland4, .78, .85);
        rmSetAreaCoherence(socketland4, 0.8);
        rmBuildArea(socketland4);

		
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 6.0);      
       
        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, .78, .02);
		rmAddTradeRouteWaypoint(tradeRouteID, .7, .5);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.78, .98);

       rmBuildTradeRoute(tradeRouteID, "dirt");
 
         socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.85);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

	if (cNumberNonGaiaPlayers >= 3)
{

//***team games, add centre island and socket***
		
	socketland5= rmCreateArea("tradepost island5");
        rmSetAreaSize(socketland5, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
        rmSetAreaBaseHeight(socketland5, 1.0);
        rmSetAreaHeightBlend(socketland5, 1);
        rmSetAreaLocation(socketland5, .7, .5);
        rmSetAreaCoherence(socketland5, 0.8);
        rmBuildArea(socketland5);

		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
}


		//TR 2

//***build islands for second trade route

int	socketland6= rmCreateArea("tradepost island6");
        rmSetAreaSize(socketland6, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
        rmSetAreaBaseHeight(socketland6, 1.0);
  rmSetAreaHeightBlend(socketland6, 1);
        rmSetAreaLocation(socketland6, .28, .15);
        rmSetAreaCoherence(socketland6, 0.8);
        rmBuildArea(socketland6);
		
int	socketland7= rmCreateArea("tradepost island7");
        rmSetAreaSize(socketland7, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
        rmSetAreaBaseHeight(socketland7, 1.0);
        rmSetAreaHeightBlend(socketland7, 1);
        rmSetAreaLocation(socketland7, .28, .85);
        rmSetAreaCoherence(socketland7, 0.8);
        rmBuildArea(socketland7);


//build trade route

        rmAddObjectDefItem(socketID2, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID2, true);
        rmSetObjectDefMinDistance(socketID2, 0.0);
        rmSetObjectDefMaxDistance(socketID2, 6.0);      
       
        rmSetObjectDefTradeRouteID(socketID2, tradeRouteID2);
		rmAddTradeRouteWaypoint(tradeRouteID2, .28, .98);
		rmAddTradeRouteWaypoint(tradeRouteID2, .32, .5);
		rmAddTradeRouteWaypoint(tradeRouteID2, 0.28, .02);

        rmBuildTradeRoute(tradeRouteID2, "dirt");
 
		vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.15);
        rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
       
        socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.85);
        rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);

 	if (cNumberNonGaiaPlayers >= 3)
{  

//***build island and socket for team games
  
int	socketland8= rmCreateArea("tradepost island8");
        rmSetAreaSize(socketland8, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
        rmSetAreaBaseHeight(socketland8, 1.0);
        rmSetAreaHeightBlend(socketland8, 1);
        rmSetAreaLocation(socketland8, .325, .5);
        rmSetAreaCoherence(socketland8, 0.8);
        rmBuildArea(socketland8);


        socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.5);
        rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
}
}


if (tradeSwitcher == 2){
//ffa placement

//***place islands for sockets***

	socketland3= rmCreateArea("tradepost island3");
        rmSetAreaSize(socketland3, rmAreaTilesToFraction(700), rmAreaTilesToFraction(700));
        rmSetAreaBaseHeight(socketland3, 1.0);
  rmSetAreaHeightBlend(socketland3, 1);
        rmSetAreaLocation(socketland3, .33, .695);
        rmSetAreaCoherence(socketland3, 0.8);
        rmBuildArea(socketland3);
		
	socketland4= rmCreateArea("tradepost island4");
        rmSetAreaSize(socketland4, rmAreaTilesToFraction(700), rmAreaTilesToFraction(700));
        rmSetAreaBaseHeight(socketland4, 1.0);
        rmSetAreaHeightBlend(socketland4, 1);
        rmSetAreaLocation(socketland4, .33, .305);
        rmSetAreaCoherence(socketland4, 0.8);
        rmBuildArea(socketland4);

		
	socketland5= rmCreateArea("tradepost island5");
        rmSetAreaSize(socketland5, rmAreaTilesToFraction(700), rmAreaTilesToFraction(700));
        rmSetAreaBaseHeight(socketland5, 1.0);
        rmSetAreaHeightBlend(socketland5, 1);
        rmSetAreaLocation(socketland5, .66, .69);
        rmSetAreaCoherence(socketland5, 0.8);
        rmBuildArea(socketland5);

int	socketland10= rmCreateArea("tradepost island10");
        rmSetAreaSize(socketland10, rmAreaTilesToFraction(700), rmAreaTilesToFraction(700));
        rmSetAreaBaseHeight(socketland10, 1.0);
        rmSetAreaHeightBlend(socketland10, 1);
        rmSetAreaLocation(socketland10, .66, .31);
        rmSetAreaCoherence(socketland10, 0.8);
        rmBuildArea(socketland10);


//build trade route. look at all those waypoints

        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 6.0);      
       
        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, .02, .6);
		rmAddTradeRouteWaypoint(tradeRouteID, .2, .65);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.4, .75);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.5, .73);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.7, .67);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.78, .5);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.7, .33);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.5, .27);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.4, .25);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.2, .35);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.02, .4);

       rmBuildTradeRoute(tradeRouteID, "dirt");
 
         socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.4);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.6);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);


}

		//end tr 2		



 		rmSetStatusText("",0.3);





// BUILD NATIVE SITES

	//Choose Natives
	int subCiv0=-1;
	int subCiv1=-1;
	int subCiv2=-1;
	int subCiv3=-1;

   if (rmAllocateSubCivs(4) == true)
   {
      subCiv0=rmGetCivID("Incas");
      rmEchoInfo("subCiv0 is Incas"+subCiv0);
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Incas");

		subCiv1=rmGetCivID("Incas");
      rmEchoInfo("subCiv1 is Incas"+subCiv1);
		if (subCiv1 >= 0)
			 rmSetSubCiv(1, "Incas");
	 
		subCiv2=rmGetCivID("caribs");
      rmEchoInfo("subCiv2 is caribs"+subCiv2);
      if (subCiv2 >= 0)
         rmSetSubCiv(2, "caribs");

		subCiv3=rmGetCivID("caribs");
      rmEchoInfo("subCiv3 is caribs"+subCiv3);
      if (subCiv3 >= 0)
         rmSetSubCiv(3, "caribs");
	}
	
	// Set up Natives	
	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
		
	nativeID0 = rmCreateGrouping("native site 1", "native carib village 1");
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 6.00);

	nativeID1 = rmCreateGrouping("native site 2", "native inca village 3");
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 6.00);

//place natives

	rmPlaceGroupingAtLoc(nativeID1, 0, 0.12, 0.75);
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.12, 0.25);

	if (cNumberTeams == 2){
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.85, 0.64);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.85, 0.36);
}
else{
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.4, 0.5);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.6, 0.5);
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.15, 0.5);


}


//end landforms & natives



		rmSetStatusText("",0.4);

		//starting objects
		
        int playerStart = rmCreateStartingUnitsObjectDef(5.0);
        rmSetObjectDefMinDistance(playerStart, 7.0);
        rmSetObjectDefMaxDistance(playerStart, 12.0);
       
        int goldID = rmCreateObjectDef("starting gold");
        rmAddObjectDefItem(goldID, "mine", 1, 1.0);
        rmSetObjectDefMinDistance(goldID, 12.0);
        rmSetObjectDefMaxDistance(goldID, 14.0);

       
        int goldID2 = rmCreateObjectDef("starting gold 2");
        rmAddObjectDefItem(goldID2, "mine", 1, 1.0);
        rmSetObjectDefMinDistance(goldID2, 25.0);
        rmSetObjectDefMaxDistance(goldID2, 27.0);
        rmAddObjectDefConstraint(goldID2, avoidCoin);
	rmAddObjectDefConstraint(goldID2, avoidWaterShort);
 
        int berryID = rmCreateObjectDef("starting berries");
        rmAddObjectDefItem(berryID, "BerryBush", 3, 6.0);
        rmSetObjectDefMinDistance(berryID, 10.0);
        rmSetObjectDefMaxDistance(berryID, 12.0);
        rmAddObjectDefConstraint(berryID, avoidCoin);
 
        int treeID = rmCreateObjectDef("starting trees");
        rmAddObjectDefItem(treeID, "treePuya", rmRandInt(6,9), 10.0);
        rmSetObjectDefMinDistance(treeID, 12.0);
        rmSetObjectDefMaxDistance(treeID, 18.0);
        rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
        rmAddObjectDefConstraint(treeID, avoidCoin);
 
        int foodID = rmCreateObjectDef("starting hunt");
        rmAddObjectDefItem(foodID, "anteater", 6, 4.0);
        rmSetObjectDefMinDistance(foodID, 12.0);
        rmSetObjectDefMaxDistance(foodID, 15.0);
        rmSetObjectDefCreateHerd(foodID, false);
 
        int foodID2 = rmCreateObjectDef("starting hunt 2");
        rmAddObjectDefItem(foodID2, "anteater", 7, 8.0);
        rmSetObjectDefMinDistance(foodID2, 30.0);
        rmSetObjectDefMaxDistance(foodID2, 35.0);
        rmSetObjectDefCreateHerd(foodID2, true);
                       
		int foodID3 = rmCreateObjectDef("starting hunt 3");
        rmAddObjectDefItem(foodID3, "anteater", 8, 8.0);
        rmSetObjectDefMinDistance(foodID3, 50.0);
        rmSetObjectDefMaxDistance(foodID3, 55.0);
        rmSetObjectDefCreateHerd(foodID3, true);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
    rmSetObjectDefMinDistance(playerNuggetID, 25.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 27.0);
	rmSetNuggetDifficulty(1, 1); 
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
        rmAddObjectDefConstraint(playerNuggetID, avoidCoin);


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
			rmAddObjectDefItem(startID, "CoveredWagon", 1, 1.0);
		}else{
			rmAddObjectDefItem(startID, "TownCenter", 1, 1.0);
		}
		rmSetObjectDefMinDistance(startID, 0.0);
        	rmSetObjectDefMaxDistance(startID, 5.0);
		rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	rmPlaceObjectDefAtLoc(goldID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	rmPlaceObjectDefAtLoc(foodID3, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        	rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

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
	
    int mapHunts = rmCreateObjectDef("mapHunts");
	rmAddObjectDefItem(mapHunts, "Capybara", rmRandInt(7,8), 11.0);
	rmSetObjectDefCreateHerd(mapHunts, true);
	rmSetObjectDefMinDistance(mapHunts, 0);
	rmSetObjectDefMaxDistance(mapHunts, rmXFractionToMeters(0.5));
//	rmAddObjectDefConstraint(mapHunts, circleConstraint);
	rmAddObjectDefConstraint(mapHunts, avoidTownCenterMore);
	rmAddObjectDefConstraint(mapHunts, avoidHunt);
	rmAddObjectDefConstraint(mapHunts, avoidPlateau);	
	rmPlaceObjectDefAtLoc(mapHunts, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);

//split map mines into NW and SE for equal distribution

  	int northMines = rmCreateObjectDef("northern mines");
	rmAddObjectDefItem(northMines, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(northMines, 0.0);
	rmSetObjectDefMaxDistance(northMines, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(northMines, avoidCoinMed);
	rmAddObjectDefConstraint(northMines, avoidTownCenterMore);
	rmAddObjectDefConstraint(northMines, avoidSocket);
	rmAddObjectDefConstraint(northMines, avoidPlateau);	
	rmAddObjectDefConstraint(northMines, avoidWaterShort);
	rmAddObjectDefConstraint(northMines, forestConstraintShort);
rmAddObjectDefConstraint(northMines, NWconstraint);
//	rmAddObjectDefConstraint(northMines, circleConstraint);
	rmPlaceObjectDefAtLoc(northMines, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
 


  	int southMines = rmCreateObjectDef("southern mines");
	rmAddObjectDefItem(southMines, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(southMines, 0.0);
	rmSetObjectDefMaxDistance(southMines, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(southMines, avoidCoinMed);
	rmAddObjectDefConstraint(southMines, avoidTownCenterMore);
	rmAddObjectDefConstraint(southMines, avoidSocket);
	rmAddObjectDefConstraint(southMines, avoidPlateau);	
	rmAddObjectDefConstraint(southMines, avoidWaterShort);
	rmAddObjectDefConstraint(southMines, forestConstraintShort);
rmAddObjectDefConstraint(southMines, SEconstraint);
//	rmAddObjectDefConstraint(southMines, circleConstraint);
	rmPlaceObjectDefAtLoc(southMines, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
 
	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetID, avoidWaterShort);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenterMore);
	rmAddObjectDefConstraint(nuggetID, forestConstraintShort);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(nuggetID, avoidCoin); 
//	rmAddObjectDefConstraint(nuggetID, avoidPlateau);	
	rmSetNuggetDifficulty(2,3); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);
   
	rmSetStatusText("",0.7);
		int mapTrees=rmCreateObjectDef("map trees");
		rmAddObjectDefItem(mapTrees, "treePuya", rmRandInt(14,18), rmRandFloat(12.0,16.0));
		rmAddObjectDefItem(mapTrees, "MarshPlantsBay", rmRandInt(8,11), rmRandFloat(20.0,24.0));
		rmAddObjectDefToClass(mapTrees, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(mapTrees, 0);
		rmSetObjectDefMaxDistance(mapTrees, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(mapTrees, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(mapTrees, avoidCoin);
//	  	rmAddObjectDefConstraint(mapTrees, circleConstraint);
		rmAddObjectDefConstraint(mapTrees, forestConstraint);
		rmAddObjectDefConstraint(mapTrees, avoidTownCenter);	
		rmAddObjectDefConstraint(mapTrees, avoidPlateau);	
//		rmAddObjectDefConstraint(mapTrees, avoidWaterShort);	
		rmPlaceObjectDefAtLoc(mapTrees, 0, 0.5, 0.5, 100*cNumberNonGaiaPlayers);


		rmSetStatusText("",0.8);

//coin mines for plateau. precisely placed for 1v1, random for teams

if (cNumberNonGaiaPlayers == 2)
{
  	int smollMines = rmCreateObjectDef("island gold");
	rmAddObjectDefItem(smollMines, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(smollMines, 0.0);
	rmSetObjectDefMaxDistance(smollMines, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.18, 0.4, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.18, 0.6, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.08, 0.3, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.08, 0.7, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.17, 0.85, 1);
	rmPlaceObjectDefAtLoc(smollMines, 0, 0.17, 0.15, 1);

}
else{
		int bonusMines=rmCreateObjectDef("plateau Mines NW");
		rmAddObjectDefItem(bonusMines, "mine", 1, 4);
		rmAddObjectDefConstraint(bonusMines, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(bonusMines, NWconstraint);
	rmAddObjectDefConstraint(bonusMines, avoidCoinMed2);
		rmAddObjectDefConstraint(bonusMines, avoidWaterShort);	
	rmPlaceObjectDefInArea(bonusMines, 0, andesBase, 1*cNumberNonGaiaPlayers);

		int bonusMines2=rmCreateObjectDef("plateau Mines SE");
		rmAddObjectDefItem(bonusMines2, "mine", 1, 4);
		rmAddObjectDefConstraint(bonusMines2, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(bonusMines2, SEconstraint);
		rmAddObjectDefConstraint(bonusMines2, avoidWaterShort);	
	rmAddObjectDefConstraint(bonusMines2, avoidCoinMed2);
	rmPlaceObjectDefInArea(bonusMines2, 0, andesBase, 1*cNumberNonGaiaPlayers);
}

//plateau trees

		int bonusTrees=rmCreateObjectDef("bonusTrees");
		rmAddObjectDefItem(bonusTrees, "treePuya", rmRandInt(8,9), rmRandFloat(8.0,11.0));
		rmAddObjectDefItem(bonusTrees, "Guanaco", rmRandInt(3,3), rmRandFloat(8.0,11.0));
		rmAddObjectDefToClass(bonusTrees, rmClassID("classForest")); 
	rmSetObjectDefCreateHerd(bonusTrees, true);
//		rmAddObjectDefConstraint(bonusTrees, avoidTradeRouteSmall);
//		rmAddObjectDefConstraint(bonusTrees, avoidCoin);
		rmAddObjectDefConstraint(bonusTrees, forestConstraint);
	rmPlaceObjectDefInArea(bonusTrees, 0, andesBase, 8*cNumberNonGaiaPlayers);


	rmSetStatusText("",0.9);

   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .05, 0);
   }

	rmSetStatusText("", 1.00);

	
} //END