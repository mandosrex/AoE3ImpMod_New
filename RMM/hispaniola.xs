// New Hispaniola 
// edited by RF_Gandalf for the fan patch - central mountain shrunk, resources balanced, one native post disabled, slight upgrade of nuggets, tarpon re-added

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.01);

	// Define Carib Natives
	int subCiv0=-1;
	int subCiv1=-1;
	int subCiv2=-1;

    if (rmAllocateSubCivs(3) == true)
    {
		subCiv0=rmGetCivID("caribs");
		rmEchoInfo("subCiv0 is caribs "+subCiv0);
		if (subCiv0 >= 0)
		rmSetSubCiv(0, "caribs");

		subCiv1=rmGetCivID("caribs");
		rmEchoInfo("subCiv1 is caribs "+subCiv1);
		if (subCiv1 >= 0)
		rmSetSubCiv(1, "caribs");

		subCiv2=rmGetCivID("caribs");
		rmEchoInfo("subCiv2 is caribs "+subCiv2);
		if (subCiv2 >= 0)
		rmSetSubCiv(2, "caribs");
	}
// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.05);
	
	// Map variations: 
	// 1 - Three Caribs, one east of the big mountain and at the ends of the 2 long peninsulas. 
	// 2 - Four Caribs, at the ends of the 2 long peninsulas, and 2 on E end of island.
      // 3 - Five Caribs, one east of the mountain, 2 on the long peninsulas, and 2 on S end of island. 

	int whichVariation=-1;
	whichVariation = rmRandInt(1,3);
	// whichVariation = 3; 

	chooseMercs();

	if ( cNumberNonGaiaPlayers > 7 )	//If 8 player game, use only variation #2 so map builds more quickly.
	{
		whichVariation = 2;
	}
	
	// Set size of map
	int playerTiles=23000;
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=22000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=21000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=20000;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmSetMapSize(size, size);

	// Set up default water type.
	rmSetSeaLevel(1.0);          
	rmSetSeaType("caribbean coast");
	rmSetBaseTerrainMix("caribbean grass");
	rmSetMapType("caribbean");
	rmSetMapType("tropical");
	rmSetMapType("water");
	rmSetMapType("samerica");
	rmSetMapType("AIFishingUseful");
	rmSetLightingSet("caribbean");

	rmSetWorldCircleConstraint(true);

	// Initialize map.
	rmTerrainInitialize("water");

	// Misc variables for use later
	int numTries = -1;

	// Define some classes.
	int classPlayer=rmDefineClass("player");
	int classIsland=rmDefineClass("island");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("natives");
	rmDefineClass("classSocket");
	rmDefineClass("canyon");
      rmDefineClass("classFish");

   // -------------Define constraints----------------------------------------

    // Create an edge of map constraint.
	int playerEdgeConstraint=rmCreatePieConstraint("player edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.45), rmDegreesToRadians(0), rmDegreesToRadians(360));

	// Player area constraint.
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 25.0);
	int medPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players med", classPlayer, 40.0);
	int longPlayerConstraint=rmCreateClassDistanceConstraint("long stay away from players", classPlayer, 60.0);
	int longerPlayerConstraint=rmCreateClassDistanceConstraint("longer stay away from players", classPlayer, 70.0);
	int flagConstraint=rmCreateHCGPConstraint("flags avoid same", 20.0);
	int avoidTC=rmCreateTypeDistanceConstraint("stay away from TC", "TownCenter", 26.0);   
	int avoidTP=rmCreateTypeDistanceConstraint("stay away from Trading Post Sockets", "SocketTradeRoute", 14.0);  
	int avoidCW=rmCreateTypeDistanceConstraint("stay away from CW", "CoveredWagon", 24.0);

	// Resource constraints - Fish, whales, forest, mines, nuggets, and sheep
      int fishVsFishID=rmCreateClassDistanceConstraint("fish v fish", rmClassID("classFish"), rmRandInt(23,25));
      int fishVsFishTarponID=rmCreateClassDistanceConstraint("tarpon v fish", rmClassID("classFish"), 15);
	// int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fishMahi", 25.0);		// was 50.0
	// int fishVsFishTarponID=rmCreateTypeDistanceConstraint("fish v fish2", "fishTarpon", 20.0);  // was 40.0 
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);			
	int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "HumpbackWhale", 2.0);	//Was 8.0
	int fishVsWhaleID=rmCreateTypeDistanceConstraint("fish v whale", "HumpbackWhale", 40.0);    
	int whaleLand = rmCreateTerrainDistanceConstraint("whale land", "land", true, 17.0);  
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 40.0);
	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
	int avoidCoin=-1;
	// Drop coin constraint on bigger maps
	if ( cNumberNonGaiaPlayers > 5 )
	{
		avoidCoin = rmCreateTypeDistanceConstraint("avoid coin", "minegold", 67.0);  // was 75 RFG ================
	}
	else
	{
		avoidCoin = rmCreateTypeDistanceConstraint("avoid coin", "minegold", 72.0);	// was 85 RFG ================
	}
	int avoidCoinShort=rmCreateTypeDistanceConstraint("avoid coin short", "minegold", 20.0);
	int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin med", "minegold", 30.0);
	int avoidRandomBerries=rmCreateTypeDistanceConstraint("avoid random berries", "berrybush", 50.0);
	int avoidRandomTurkeys=rmCreateTypeDistanceConstraint("avoid random turkeys", "tortoise", 50.0);
	int avoidRandomTurkeysShort=rmCreateTypeDistanceConstraint("avoid random turkeys short", "tortoise", 20.0);
	int avoidRandomCrabs=rmCreateTypeDistanceConstraint("avoid random crabs", "crab", 50.0);
	int avoidRandomCrabsShort=rmCreateTypeDistanceConstraint("avoid random crabs short", "crab", 20.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "abstractNugget", 54.0); 
	int avoidSheep=rmCreateTypeDistanceConstraint("sheep avoids sheep", "sheep", 80.0); 

	// Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 5.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);

	// Constraint to avoid water.
	int avoidWater8 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 8.0);
	int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 20.0);

	// Constraints to avoid essentials
	int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 18.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 25);
	rmAddClosestPointConstraint(avoidWater8);  //was originally 8
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 6.0);
	int avoidSocket = rmCreateClassDistanceConstraint("avoid socket", rmClassID("classSocket"), 10.0);
	int avoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 50.0);
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 4.0);
      int avoidKOTH=rmCreateTypeDistanceConstraint("avoid KOTH", "ypKingsHill", 15.0);
	// The following is a Pie constraint, defined in a large "majority of the pie plate" area, to make sure Water spawn flags place inside it.  (It excludes the west bay, where I do not want the flags.)
	int circleConstraint=rmCreatePieConstraint("semi-circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(50), rmDegreesToRadians(290));  

// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.10);

	// Make one big island.  
	int bigIslandID=rmCreateArea("big lone island");
	rmSetAreaSize(bigIslandID, 0.35, 0.35);		
	rmSetAreaCoherence(bigIslandID, 0.7);		
	rmSetAreaBaseHeight(bigIslandID, 2.0);
	rmSetAreaSmoothDistance(bigIslandID, 20);
	rmSetAreaMix(bigIslandID, "caribbean grass");
	rmAddAreaToClass(bigIslandID, classIsland);
	rmSetAreaObeyWorldCircleConstraint(bigIslandID, false);
	rmSetAreaElevationType(bigIslandID, cElevTurbulence);
	rmSetAreaElevationVariation(bigIslandID, 4.0);
	rmSetAreaElevationMinFrequency(bigIslandID, 0.09);
	rmSetAreaElevationOctaves(bigIslandID, 3);
	rmSetAreaElevationPersistence(bigIslandID, 0.2);
	rmSetAreaElevationNoiseBias(bigIslandID, 1);
	rmAddAreaInfluenceSegment(bigIslandID, 0.72, 0.70, 0.80, 0.51);  //Segment 1 - short top, left, right. // .69, .68, .76, .51
	rmAddAreaInfluenceSegment(bigIslandID, 0.60, 0.80, 0.75, 0.30);  //Segment 2 - long top  // last # was .56, .78, .75, .285 // -- Changed 3-10-06
	rmAddAreaInfluenceSegment(bigIslandID, 0.21, 0.68, 0.58, 0.20);  //Segment 3 - long lower // last # was .22, .67, .58, .20 // -- Changed 3-10-06
	rmAddAreaInfluenceSegment(bigIslandID, 0.20, 0.44, 0.36, 0.21);  //Segment 4 - short lower bit // last was .20, .44, .36, .21
	    	
	rmSetAreaWarnFailure(bigIslandID, false);
	rmSetAreaLocation(bigIslandID, .5, .5);
	rmBuildArea(bigIslandID);

// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.15);
	
    // Set up player areas.  -- Each team always placed along a line.  One team in NE, other in SW.
	float teamStartLoc = rmRandFloat(0.0, 1.0); 
	if (cNumberTeams == 2 )
	{
		//Team 0 starts on top
		if (teamStartLoc > 0.5)
		{
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.28, 0.54, 0.35, 0.29, 0.0, 0.2); //Team 0 is in the south 
			
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.65, 0.64, 0.715, 0.36, 0.0, 0.2); //Team 1 is in the north
		}
		else
		{
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.65, 0.64, 0.715, 0.36, 0.0, 0.2); //Team 0 is in the north
						
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.28, 0.54, 0.35, 0.29, 0.0, 0.2); //Team 1 is in the south
		}
	}
	else
	{
  		rmSetPlacementSection(0.04, 0.82);
		rmPlacePlayersCircular(0.22, 0.23, 0.0);
	}

	float playerFraction=rmAreaTilesToFraction(100);
	for(i=1; <cNumberPlayers)
	{
      // Create the Player's area.
      int id=rmCreateArea("Player"+i);
      rmSetPlayerArea(i, id);
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmSetAreaLocPlayer(id, i);
      rmSetAreaWarnFailure(id, false);
	}

	// Build the areas. 
	rmBuildAllAreas();

// --------------- Make load bar move. -----------------------------------------------------------------------
	rmSetStatusText("",0.20);

	// Clear out constraints for good measure.
    rmClearClosestPointConstraints();  

	// *****************NATIVES****************************************************************************
  
	//-------- ALWAYS: 2 CARIB VILLAGES at ends of the 2 long peninsulas ------------------------------------------
		
	if (whichVariation == 1 || whichVariation == 2 || whichVariation == 3) 
	{
		if (subCiv1 == rmGetCivID("caribs"))
		{  
			int caribsVillageID = -1;
			int caribsVillageType = rmRandInt(1,5);
			if (caribsVillageType == 3)   
				caribsVillageType = rmRandInt(1,2);
			caribsVillageID = rmCreateGrouping("caribs city", "native carib village 0"+caribsVillageType);
			rmSetGroupingMinDistance(caribsVillageID, 0.0);
			rmSetGroupingMaxDistance(caribsVillageID, 10.0);
			rmAddGroupingConstraint(caribsVillageID, avoidImpassableLand);
			rmPlaceGroupingAtLoc(caribsVillageID, 0, 0.59, 0.80);	// JSB - end of north long peninsula.
		}	

		if (subCiv2 == rmGetCivID("caribs"))
		{  
			int caribs2VillageID = -1;
			int caribs2VillageType = rmRandInt(1,5);
			caribs2VillageID = rmCreateGrouping("caribs2 city", "native carib village 0"+caribs2VillageType);
			rmAddGroupingConstraint(caribs2VillageID, avoidImpassableLand);
			rmPlaceGroupingAtLoc(caribs2VillageID, 0, 0.22, 0.70);  // JSB - end of south long peninsula.
		} 
	}

	//-------- VARIATION 1 AND 3: 2 CARIB VILLAGES: left and right of the big mountain in center of island ---------

	if (whichVariation == 1 || whichVariation == 3)  
	{
		if (subCiv2 == rmGetCivID("caribs") && rmGetIsKOTH() == false)
		{  
			int caribs4VillageID = -1;
			int caribs4VillageType = rmRandInt(1,5);
			caribs4VillageID = rmCreateGrouping("caribs4 city", "native carib village 0"+caribs4VillageType);
			rmAddGroupingConstraint(caribs4VillageID, avoidImpassableLand);
			rmPlaceGroupingAtLoc(caribs4VillageID, 0, 0.57, 0.27);  // JSB - SE Village in SE-center, next to mtn.
		} 
	}

	//-------- VARIATION 2 AND 3: 2 CARIB VILLAGES at NE and SE ends of the island  -------------------------------
		
	if (whichVariation == 2 || whichVariation == 3) 
	{
		if (subCiv1 == rmGetCivID("caribs"))
		{  
			int caribs5VillageID = -1;
			int caribs5VillageType = rmRandInt(1,5);
			if (caribs5VillageType == 3)   
				caribs5VillageType = rmRandInt(1,2);
			caribs5VillageID = rmCreateGrouping("caribs5 city", "native carib village 0"+caribs5VillageType);
			rmSetGroupingMinDistance(caribs5VillageID, 0.0);
			rmSetGroupingMaxDistance(caribs5VillageID, 7.0);
			rmAddGroupingConstraint(caribs5VillageID, avoidImpassableLand);
			rmPlaceGroupingAtLoc(caribs5VillageID, 0, 0.73, 0.26);	// Place near NE end of island.  //.73, .25
		}	

		if (subCiv2 == rmGetCivID("caribs"))
		{  
			int caribs6VillageID = -1;
			int caribs6VillageType = rmRandInt(1,5);
			caribs6VillageID = rmCreateGrouping("caribs6 city", "native carib village 0"+caribs6VillageType);
			rmSetGroupingMinDistance(caribs6VillageID, 0.0);
			rmSetGroupingMaxDistance(caribs6VillageID, 7.0);
			rmAddGroupingConstraint(caribs6VillageID, avoidImpassableLand);
			rmPlaceGroupingAtLoc(caribs6VillageID, 0, 0.40, 0.21);  // Place near SE end of island.  .40, 18
		} 
	}

// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.25);

   // *****************MOUNTAIN IN CENTER**************************************

		int smallCliffHeight=rmRandInt(0,10);
		int smallMesaID=rmCreateArea("small mesa"+i);
		if ( cNumberNonGaiaPlayers < 4 )
		{
			rmSetAreaSize(smallMesaID, rmAreaTilesToFraction(500), rmAreaTilesToFraction(525)); 
		}
		else if ( cNumberNonGaiaPlayers < 6 )
		{
			rmSetAreaSize(smallMesaID, rmAreaTilesToFraction(600), rmAreaTilesToFraction(625)); 
		}
		else if ( cNumberNonGaiaPlayers < 8 )
		{
			rmSetAreaSize(smallMesaID, rmAreaTilesToFraction(700), rmAreaTilesToFraction(750));
		}
		else
		{
			rmSetAreaSize(smallMesaID, rmAreaTilesToFraction(800), rmAreaTilesToFraction(850)); 
		}
		rmSetAreaWarnFailure(smallMesaID, false);
		rmSetAreaCliffType(smallMesaID, "Caribbean");
		rmAddAreaToClass(smallMesaID, rmClassID("canyon"));	
		rmSetAreaCliffEdge(smallMesaID, 1, 1.0, 0.1, 1.0, 0);
		rmSetAreaCliffHeight(smallMesaID, rmRandInt(6, 7), 1.0, 1.0);  
		rmSetAreaCoherence(smallMesaID, 0.68);
		rmSetAreaLocation(smallMesaID, 0.55, 0.39); 
		rmAddAreaInfluenceSegment(smallMesaID, 0.48, 0.43, 0.5, 0.40);  //Bottom - Original segment
		rmAddAreaInfluenceSegment(smallMesaID, 0.46, 0.40, 0.53, 0.38); //Right
		rmAddAreaInfluenceSegment(smallMesaID, 0.53, 0.45, 0.53, 0.38); //Top - Original segment
		rmAddAreaInfluenceSegment(smallMesaID, 0.53, 0.45, 0.48, 0.43); //Left
		rmBuildArea(smallMesaID);

	// Special AREA CONSTRAINTS and use it to make resources avoid the mountain in center:
		int smallMesaConstraint = rmCreateAreaDistanceConstraint("avoid Small Mesa", smallMesaID, 4.0);


//===========trade route=================

        int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 20.0);   
	rmAddObjectDefConstraint(socketID, avoidWater8);
	rmAddObjectDefConstraint(socketID, avoidAll);	
   
       
        int tradeRouteID = rmCreateTradeRoute();


        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

	rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 1.0);
 	rmAddTradeRouteWaypoint(tradeRouteID, 0.44, 0.66);

        rmBuildTradeRoute(tradeRouteID, "naval");

	rmPlaceObjectDefAtLoc(socketID, 0, 0.44, 0.6);


//====================================================
		
// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.30);

	//***************** PLAYER STARTING STUFF **********************************
	//Place player TCs and starting Gold Mines. 

	int TCID = rmCreateObjectDef("player TC");
	if ( rmGetNomadStart())
		rmAddObjectDefItem(TCID, "coveredWagon", 1, 0);
	else
		rmAddObjectDefItem(TCID, "townCenter", 1, 0);

	//Prepare to place TCs
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 12.0);  
	rmAddObjectDefConstraint(TCID, avoidImpassableLand);
	rmAddObjectDefConstraint(TCID, avoidTC);
	rmAddObjectDefConstraint(TCID, avoidCW);
    	
	//Prepare to place Explorers, Explorer's dog, Explorer's Taun Taun, etc.
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 6.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);
	rmAddObjectDefConstraint(startingUnits, avoidImpassableLand);

	//Prepare to place player starting Mines 
	int playerGoldID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(playerGoldID, "minegold", 1, 0);
	rmSetObjectDefMinDistance(playerGoldID, 15.0);
	rmSetObjectDefMaxDistance(playerGoldID, 20.0);
	rmAddObjectDefConstraint(playerGoldID, avoidAll);
      rmAddObjectDefConstraint(playerGoldID, avoidImpassableLand);

	//Prepare to place player starting Crates (mostly food)
	int playerCrateID=rmCreateObjectDef("starting crates");
	rmAddObjectDefItem(playerCrateID, "crateOfFood", rmRandInt(4,4), 4.0);
	rmAddObjectDefItem(playerCrateID, "crateOfWood", 1, 6.0);
	rmAddObjectDefItem(playerCrateID, "crateOfCoin", 1, 7.0);
	rmSetObjectDefMinDistance(playerCrateID, 6);
	rmSetObjectDefMaxDistance(playerCrateID, 10);
	rmAddObjectDefConstraint(playerCrateID, avoidAll);
	rmAddObjectDefConstraint(playerCrateID, shortAvoidImpassableLand);

	//Prepare to place player starting Berries
	int playerBerriesID=rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerBerriesID, "berrybush", rmRandInt(4,4), 4.0);	
      rmSetObjectDefMinDistance(playerBerriesID, 10);
      rmSetObjectDefMaxDistance(playerBerriesID, 14);		
	rmAddObjectDefConstraint(playerBerriesID, avoidAll);
      rmAddObjectDefConstraint(playerBerriesID, avoidImpassableLand);

	//Prepare to place player starting Turkeys
	int playerTurkeyID=rmCreateObjectDef("player turkeys");
      rmAddObjectDefItem(playerTurkeyID, "crab", rmRandInt(7,7), 4.0);	
      rmSetObjectDefMinDistance(playerTurkeyID, 12);
	rmSetObjectDefMaxDistance(playerTurkeyID, 16);	
	rmAddObjectDefConstraint(playerTurkeyID, avoidAll);
      rmAddObjectDefConstraint(playerTurkeyID, avoidImpassableLand);
      rmSetObjectDefCreateHerd(playerTurkeyID, false);

	//Prepare to place player starting trees
	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeCaribbean", 1, 0.0);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidAll);   
	rmSetObjectDefMinDistance(StartAreaTreeID, 13.0);	
	rmSetObjectDefMaxDistance(StartAreaTreeID, 18.0);	

	int waterSpawnPointID = 0;

// --------------- Make load bar move. -------------------------------------------------------------------------`
	rmSetStatusText("",0.35);
   
   for(i=1; <cNumberPlayers)
   {
	    // Place TC and starting units
	rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
    
    	rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(playerGoldID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));   
	rmPlaceObjectDefAtLoc(playerBerriesID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc))); 
	rmPlaceObjectDefAtLoc(playerTurkeyID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));  										
	rmPlaceObjectDefAtLoc(playerCrateID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

    	if(ypIsAsian(i) && rmGetNomadStart() == false)
     	   rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

	// Place player starting trees
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

	// Place water spawn points for the players
	waterSpawnPointID=rmCreateObjectDef("colony ship "+i);
	rmAddObjectDefItem(waterSpawnPointID, "HomeCityWaterSpawnFlag", 1, 10.0); 
	rmAddClosestPointConstraint(flagVsFlag);
	rmAddClosestPointConstraint(flagLand);
	rmAddClosestPointConstraint(circleConstraint);

	vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));

	rmPlaceObjectDefAtLoc(waterSpawnPointID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));

	rmClearClosestPointConstraints();

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

   }
	
// --------------- Make load bar move. -------------------------------------------------------------------------
	rmSetStatusText("",0.40);

	//rmClearClosestPointConstraints();

// Additional player gold
	int medGoldID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(medGoldID, "minegold", 1, 0);
	rmSetObjectDefMinDistance(medGoldID, 40.0);
	rmSetObjectDefMaxDistance(medGoldID, 48.0);
	rmAddObjectDefConstraint(medGoldID, avoidAll);
      rmAddObjectDefConstraint(medGoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(medGoldID, medPlayerConstraint);
      rmAddObjectDefConstraint(medGoldID, avoidCoinShort);
      rmPlaceObjectDefPerPlayer(medGoldID, false, 1);

	int farGoldID = rmCreateObjectDef("player third mine");
	rmAddObjectDefItem(farGoldID, "minegold", 1, 0);
	rmSetObjectDefMinDistance(farGoldID, 60.0);
	rmSetObjectDefMaxDistance(farGoldID, 68.0);
	rmAddObjectDefConstraint(farGoldID, avoidAll);
      rmAddObjectDefConstraint(farGoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(farGoldID, longPlayerConstraint);
      rmAddObjectDefConstraint(farGoldID, avoidCoinMed);
      rmPlaceObjectDefPerPlayer(farGoldID, false, 1);

// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.45);

// check for KOTH game mode
   if(rmGetIsKOTH())
   {    
      int randLoc = rmRandInt(1,2);
      float xLoc = 0.55;
      float yLoc = 0.25;
      float walk = 0.035;
    
      if(randLoc == 1 || cNumberTeams > 2 || cNumberNonGaiaPlayers <= 3)
	{
         xLoc = .48;
         yLoc = .53;
      }
    
      ypKingsHillPlacer(xLoc, yLoc, walk, smallMesaConstraint);
      rmEchoInfo("XLOC = "+xLoc);
      rmEchoInfo("XLOC = "+yLoc);
   }

// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.50);

	// ***************** SCATTERED RESOURCES **************************************
	// Scattered MINES
	int goldID = rmCreateObjectDef("random gold");
	rmAddObjectDefItem(goldID, "minegold", 1, 0);
	rmSetObjectDefMinDistance(goldID, 0.0);
	rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(goldID, longerPlayerConstraint);
	rmAddObjectDefConstraint(goldID, avoidCW);
	rmAddObjectDefConstraint(goldID, avoidAll);
	rmAddObjectDefConstraint(goldID, avoidCoin);
      rmAddObjectDefConstraint(goldID, avoidImpassableLand);
      rmAddObjectDefConstraint(goldID, avoidTP);
	rmAddObjectDefConstraint(goldID, smallMesaConstraint);
	rmPlaceObjectDefInArea(goldID, 0, bigIslandID, cNumberNonGaiaPlayers*2);

// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.55);

	// Scattered FORESTS
   int forestTreeID = 0;
   numTries=10*cNumberNonGaiaPlayers;
   int failCount=0;
   for (i=0; <numTries)
      {   
         int forest=rmCreateArea("forest "+i);
         rmSetAreaWarnFailure(forest, false);
         rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(400));
         rmSetAreaForestType(forest, "caribbean palm forest");
         rmSetAreaForestDensity(forest, 0.6);
         rmSetAreaForestClumpiness(forest, 0.4);
         rmSetAreaForestUnderbrush(forest, 0.0);
         rmSetAreaMinBlobs(forest, 1);
         rmSetAreaMaxBlobs(forest, 5);
         rmSetAreaMinBlobDistance(forest, 16.0);
         rmSetAreaMaxBlobDistance(forest, 40.0);
         rmSetAreaCoherence(forest, 0.4);
         rmSetAreaSmoothDistance(forest, 10);
         rmAddAreaToClass(forest, rmClassID("classForest")); 
         rmAddAreaConstraint(forest, forestConstraint);
         rmAddAreaConstraint(forest, avoidAll);
         rmAddAreaConstraint(forest, shortAvoidImpassableLand); 
	   rmAddAreaConstraint(forest, smallMesaConstraint); 
	   rmAddAreaConstraint(forest, avoidTC);
	   rmAddAreaConstraint(forest, avoidCW);
	   rmAddAreaConstraint(forest, avoidTP);
         rmAddAreaConstraint(forest, avoidTradeRoute); 
         rmAddAreaConstraint(forest, avoidKOTH);
         if(rmBuildArea(forest)==false)
         {
            // Stop trying once we fail 3 times in a row.
            failCount++;
            if(failCount==5)
               break;
         }
         else
            failCount=0; 
      } 

// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.60);

	// More player turkeys
	int secondTurkeyID=rmCreateObjectDef("more player turkeys");
	rmAddObjectDefItem(secondTurkeyID, "tortoise", rmRandInt(5,6), 5.0); 
	rmSetObjectDefMinDistance(secondTurkeyID, 34.0);
	rmSetObjectDefMaxDistance(secondTurkeyID, 40.0);
	rmAddObjectDefConstraint(secondTurkeyID, avoidTC);
	rmAddObjectDefConstraint(secondTurkeyID, avoidCW);
      rmAddObjectDefConstraint(secondTurkeyID, avoidTP);
	rmAddObjectDefConstraint(secondTurkeyID, avoidRandomTurkeysShort);
	rmAddObjectDefConstraint(secondTurkeyID, avoidRandomCrabsShort);
	rmAddObjectDefConstraint(secondTurkeyID, avoidAll);
	rmAddObjectDefConstraint(secondTurkeyID, avoidImpassableLand);
	rmAddObjectDefConstraint(secondTurkeyID, smallMesaConstraint);
      rmPlaceObjectDefPerPlayer(secondTurkeyID, false, 1);
	rmSetObjectDefCreateHerd(secondTurkeyID, true);
	rmSetObjectDefMinDistance(secondTurkeyID, 45.0);
	rmSetObjectDefMaxDistance(secondTurkeyID, 50.0);
      rmPlaceObjectDefPerPlayer(secondTurkeyID, false, 1);

	// Scattered BERRRIES		
	int berriesID=rmCreateObjectDef("random berries");
	rmAddObjectDefItem(berriesID, "berrybush", rmRandInt(5,6), 6.0);  
	rmSetObjectDefMinDistance(berriesID, 0.0);
	rmSetObjectDefMaxDistance(berriesID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(berriesID, avoidTC);
	rmAddObjectDefConstraint(berriesID, avoidTP);  
	rmAddObjectDefConstraint(berriesID, avoidCW);
	rmAddObjectDefConstraint(berriesID, avoidAll);
	rmAddObjectDefConstraint(berriesID, avoidRandomBerries);
	rmAddObjectDefConstraint(berriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(berriesID, smallMesaConstraint);
	rmPlaceObjectDefInArea(berriesID, 0, bigIslandID, cNumberNonGaiaPlayers*4);   

	// Just a FEW scattered TURKEYS
	int turkeyID=rmCreateObjectDef("random turkeys");
	rmAddObjectDefItem(turkeyID, "crab", rmRandInt(4,5), 5.0); 
	rmSetObjectDefMinDistance(turkeyID, 0.0);
	rmSetObjectDefMaxDistance(turkeyID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(turkeyID, avoidCW);
	rmAddObjectDefConstraint(turkeyID, avoidTP);
	rmAddObjectDefConstraint(turkeyID, avoidAll);
	rmAddObjectDefConstraint(turkeyID, avoidImpassableLand);
	rmAddObjectDefConstraint(turkeyID, smallMesaConstraint);
	rmAddObjectDefConstraint(turkeyID, avoidRandomTurkeys);
	rmAddObjectDefConstraint(turkeyID, avoidRandomCrabs);
	rmAddObjectDefConstraint(turkeyID, longPlayerConstraint);
	rmSetObjectDefCreateHerd(turkeyID, true);
	rmPlaceObjectDefInArea(turkeyID, 0, bigIslandID, cNumberNonGaiaPlayers*3); 

// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.65); 

// Define and place Nuggets
  
	// Easier nuggets
	int nugget1= rmCreateObjectDef("nugget easy"); 
	rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nugget1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMaxDistance(nugget1, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nugget1, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nugget1, avoidNugget);
	rmAddObjectDefConstraint(nugget1, avoidTradeRoute);
	rmAddObjectDefConstraint(nugget1, avoidAll);
	rmAddObjectDefConstraint(nugget1, avoidTP);
	rmAddObjectDefConstraint(nugget1, avoidWater20);
	rmAddObjectDefConstraint(nugget1, smallMesaConstraint);
	rmAddObjectDefConstraint(nugget1, playerEdgeConstraint);
	rmPlaceObjectDefInArea(nugget1, 0, bigIslandID, cNumberNonGaiaPlayers*3);

// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.70);

	// Tougher nuggets
	int nugget2= rmCreateObjectDef("nugget hard"); 
	rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nugget2, 0.0);
	rmSetNuggetDifficulty(2, 2);
	rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nugget2, avoidNugget);
	rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
	rmAddObjectDefConstraint(nugget2, avoidTC);
	rmAddObjectDefConstraint(nugget2, avoidCW);
	rmAddObjectDefConstraint(nugget2, avoidTP);
	rmAddObjectDefConstraint(nugget2, avoidAll);
	rmAddObjectDefConstraint(nugget2, avoidWater20);
	rmAddObjectDefConstraint(nugget2, smallMesaConstraint);
	rmAddObjectDefConstraint(nugget2, playerEdgeConstraint);
	rmPlaceObjectDefInArea(nugget2, 0, bigIslandID, cNumberNonGaiaPlayers);

	rmSetNuggetDifficulty(3, 3);
	rmPlaceObjectDefInArea(nugget2, 0, bigIslandID, cNumberNonGaiaPlayers);

// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.75);

	//Place Sheep -- added Sheep 11-28-05
	int sheepID=rmCreateObjectDef("sheep");
	rmAddObjectDefItem(sheepID, "sheep", 2, 4.0);
	rmSetObjectDefMinDistance(sheepID, 0.0);
	rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(sheepID, avoidSheep);
	rmAddObjectDefConstraint(sheepID, avoidAll);
	rmAddObjectDefConstraint(sheepID, avoidSocket);
	rmAddObjectDefConstraint(sheepID, avoidTradeRoute);
	rmAddObjectDefConstraint(sheepID, avoidTC);
	rmAddObjectDefConstraint(sheepID, avoidCW);
	rmAddObjectDefConstraint(sheepID, avoidTP);
	rmAddObjectDefConstraint(sheepID, longPlayerConstraint);
	rmAddObjectDefConstraint(sheepID, smallMesaConstraint);
	rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(sheepID, 0, 0.46, 0.48, cNumberNonGaiaPlayers*2);

// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.80);

	//Place Whales as much in big west bay only as possible --------------------------------------------------------
	int whaleID=rmCreateObjectDef("whale");
	rmAddObjectDefItem(whaleID, "HumpbackWhale", 1, 0.0);
	rmSetObjectDefMinDistance(whaleID, 0.0);
	rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.28));
	rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
	rmAddObjectDefConstraint(whaleID, whaleLand);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.46, 0.60, cNumberNonGaiaPlayers*3 + rmRandInt(1,2)); 

// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.85);

// Place Random Fish everywhere, but restrained to avoid whales (tarpon restored)  -------------------------

	int fishID=rmCreateObjectDef("fish Mahi");
	rmAddObjectDefItem(fishID, "FishMahi", 1, 0.0);
      rmAddObjectDefToClass(fishID, rmClassID("classFish"));
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, fishVsFishID);
	rmAddObjectDefConstraint(fishID, fishVsWhaleID);
	rmAddObjectDefConstraint(fishID, fishLand);
	rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers); 

// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.90);

	int fish2ID=rmCreateObjectDef("fish Tarpon");
	rmAddObjectDefItem(fish2ID, "FishTarpon", 1, 0.0);
      rmAddObjectDefToClass(fish2ID, rmClassID("classFish"));
	rmSetObjectDefMinDistance(fish2ID, 0.0);
	rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fish2ID, fishVsFishTarponID);
	rmAddObjectDefConstraint(fish2ID, fishVsWhaleID);
	rmAddObjectDefConstraint(fish2ID, fishLand);
	rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);  

	if (cNumberNonGaiaPlayers <5)		// If less than 5 players, place extra fish.
	{
	   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
	   rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
	   if (cNumberNonGaiaPlayers == 2)		
	   {
		rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);		
	   }		
	}

// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.95);

	// RANDOM TREES
	int randomTreeID=rmCreateObjectDef("random tree");
	rmAddObjectDefItem(randomTreeID, "treeCaribbean", 1, 0.0);
	rmSetObjectDefMinDistance(randomTreeID, 0.0);
	rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(randomTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(randomTreeID, avoidTC);
	rmAddObjectDefConstraint(randomTreeID, avoidCW);
	rmAddObjectDefConstraint(randomTreeID, avoidTP);
	rmAddObjectDefConstraint(randomTreeID, avoidAll); 
	rmAddObjectDefConstraint(randomTreeID, smallMesaConstraint);
	rmPlaceObjectDefInArea(randomTreeID, 0, bigIslandID, 8*cNumberNonGaiaPlayers);  


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

// --------------- Make load bar move. -------------------------------------------------------------------------
	rmSetStatusText("",0.99); 

}