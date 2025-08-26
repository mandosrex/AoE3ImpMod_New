// ESOC BENGAL (1v1, TEAM, FFA)
// designed by Garja

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{
	
	// Text
	// These status text lines are used to manually animate the map generation progress bar
	rmSetStatusText("",0.01); 
	
	// ************************************** GENERAL FEATURES *****************************************
	
	// Picks the map size
	int playerTiles=14000; 
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=13000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=12000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=11000;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(true);
	
	// Picks a default water height
	rmSetSeaLevel(1.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

//	rmSetMapElevationParameters(cElevTurbulence, 0.05, 2, 0.5, 4.5); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);
	
	
	// Picks default terrain and water
	rmSetSeaType("bayou");
	rmSetBaseTerrainMix("bayou_grass"); // 
	rmTerrainInitialize("water", 0.0); // 
	rmSetMapType("deccan"); 
	rmSetMapType("grass");
	rmSetMapType("tropical");
	rmSetMapType("asia");
	rmSetLightingSet("bayou");

	// Choose Mercs
	chooseMercs();
	
	// Make it rain
	rmSetGlobalRain(0.9);
  
	// Text
	rmSetStatusText("",0.10);
	
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	int subCiv2 = -1;
	subCiv0 = rmGetCivID("Udasi");
	subCiv1 = rmGetCivID("Sufi");
	subCiv2 = rmGetCivID("Bhakti");
	rmSetSubCiv(0, "Udasi");
	rmSetSubCiv(1, "Sufi");
	rmSetSubCiv(2, "Bhakti");
	

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classPatch3 = rmDefineClass("patch3");
	int classPond = rmDefineClass("pond");
	int classRocks = rmDefineClass("rocks");
	int classGrass = rmDefineClass("grass");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int importantItem = rmDefineClass("importantItem");
	int classNative = rmDefineClass("natives");
	int classCliff = rmDefineClass("Cliffs");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	int classIsland=rmDefineClass("island");
	
	// ******************************************************************************************
	
	// Text
	rmSetStatusText("",0.20);
	
	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other
   
	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.38), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));

	int staySouthPart = rmCreatePieConstraint("Stay south part", 0.55, 0.55,rmXFractionToMeters(0.0), rmXFractionToMeters(0.60), rmDegreesToRadians(135),rmDegreesToRadians(315));
	int stayNorthHalf = rmCreatePieConstraint("Stay north half", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(360),rmDegreesToRadians(180));
		
	// Resource avoidance
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 26.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 15.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidNilgauFar = rmCreateTypeDistanceConstraint("avoid Nilgau far", "ypNilgai", 44.0); //48
	int avoidNilgau = rmCreateTypeDistanceConstraint("avoid Nilgau", "ypNilgai", 42.0);
	int avoidNilgauShort = rmCreateTypeDistanceConstraint("avoid Nilgau short", "ypNilgai", 25.0);
	int avoidNilgauMin = rmCreateTypeDistanceConstraint("avoid Nilgau min", "ypNilgai", 4.0);
	int avoidEleFar = rmCreateTypeDistanceConstraint("avoid Ele far", "ypWildElephant", 45.0);
	int avoidEle = rmCreateTypeDistanceConstraint("avoid Ele", "ypWildElephant", 40.0);
	int avoidEleShort = rmCreateTypeDistanceConstraint("avoid  Ele short", "ypWildElephant", 35.0);
	int avoidEleMin = rmCreateTypeDistanceConstraint("avoid Ele min", "ypWildElephant", 5.0);
	int avoidMuskdeerFar = rmCreateTypeDistanceConstraint("avoid muskdeer far", "Peafowl", 56.0);
	int avoidMuskdeer = rmCreateTypeDistanceConstraint("avoid muskdeer ", "Peafowl", 45.0);
	int avoidMuskdeerMin = rmCreateTypeDistanceConstraint("avoid muskdeer min ", "Peafowl", 4.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 25.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 8.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 45.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 52.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 15.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 30.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 52.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 66.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 40.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 50.0);
	int avoidTownCenterVeryFar = rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 85.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 70.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 48.0); //46
	int avoidTownCenterMed = rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 60.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 20.0);
	int avoidTownCenterMin = rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 18.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid natives short", rmClassID("natives"), 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 10.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("avoid natives far", rmClassID("natives"), 15.0);
	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 10.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 5.0);
	int avoidWhale=rmCreateTypeDistanceConstraint("avoid whale", "fish", 52.0);
	int avoidFish=rmCreateTypeDistanceConstraint("avoid fish", "fish", 24.0);
	int avoidBuffalo=rmCreateTypeDistanceConstraint("avoid water buffalo", "ypWaterBuffalo", 50.0);
	int avoidColonyShip = rmCreateTypeDistanceConstraint("avoid colony ship", "HomeCityWaterSpawnFlag", 30.0);
	int avoidColonyShipShort = rmCreateTypeDistanceConstraint("avoid colony ship short", "HomeCityWaterSpawnFlag", 15.0);

	// Avoid impassable land
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("avoid impassable land min", "Land", false, 1.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("avoid impassable land short", "Land", false, 6.0);
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("avoid impassable land medium", "Land", false, 12.0);
	int avoidImpassableLandFar = rmCreateTerrainDistanceConstraint("avoid impassable land far", "Land", false, 20.0);
	int stayNearLand = rmCreateTerrainMaxDistanceConstraint("stay near land ", "Land", true, 5.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 8.0);
	int avoidLandFar = rmCreateTerrainDistanceConstraint("avoid land far ", "Land", true, 15.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 3.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 10);
	int avoidWaterFar = rmCreateTerrainDistanceConstraint("avoid water far", "water", true, 30.0);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 20.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 5.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 20.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 5.0);
	int avoidIslandMin=rmCreateClassDistanceConstraint("avoid island min", classIsland, 8.0);
	int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 10.0+cNumberNonGaiaPlayers);
	int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 16.0);
	int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 32.0);
	int avoidCliffShort = rmCreateClassDistanceConstraint("avoid cliff short", classCliff, 3.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", classCliff, 7.0);
	
	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);	
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 4.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 8.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route socket short", "socketTradeRoute", 3.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 10.0);
   
	
	// ***********************************************************************************************
	
	// **************************************** PLACE PLAYERS ****************************************
	
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);

		teamZeroCount = cNumberNonGaiaPlayers/2;
		teamOneCount = cNumberNonGaiaPlayers/2;
	

		if (cNumberTeams <= 2) // 1v1 and TEAM
		{
			if (teamZeroCount == 1 && teamOneCount == 1) // 1v1
			{
				float OneVOnePlacement=rmRandFloat(0.0, 0.9);
				if ( OneVOnePlacement < 0.5)
				{
					rmPlacePlayer(1, 0.46, 0.88);
					rmPlacePlayer(2, 0.88, 0.45);
				}
				else
				{
					rmPlacePlayer(2, 0.46, 0.88);
					rmPlacePlayer(1, 0.88, 0.45);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.52, 0.88, 0.32, 0.82, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.88, 0.52, 0.82, 0.32, 0.00, 0.20);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.56, 0.92, 0.24, 0.80, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.92, 0.56, 0.80, 0.24, 0.00, 0.20);
				}
			}
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.46, 0.88, 0.20, 0.66, 0.00, 0.20);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmPlacePlayersLine(0.88, 0.52, 0.82, 0.32, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.92, 0.56, 0.80, 0.24, 0.00, 0.20);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.88, 0.45, 0.66, 0.20, 0.00, 0.20);

						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmPlacePlayersLine(0.52, 0.88, 0.32, 0.82, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.56, 0.92, 0.24, 0.80, 0.00, 0.20);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.52, 0.88, 0.32, 0.82, 0.00, 0.20);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.92, 0.56, 0.80, 0.24, 0.00, 0.20);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.56, 0.92, 0.24, 0.80, 0.00, 0.20);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.88, 0.51, 0.82, 0.32, 0.00, 0.20);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.56, 0.92, 0.24, 0.80, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.92, 0.56, 0.80, 0.24, 0.00, 0.20);
				}
			}
		}
		else // FFA
		{
			rmSetTeamSpacingModifier(0.25);
			rmSetPlacementSection(0.33, 0.92);
			rmPlacePlayersCircular(0.42, 0.42, 0.0);
		}


	// **************************************************************************************************
   
	// Text
	rmSetStatusText("",0.30);
	
	// ******************************************** MAP LAYOUT **************************************************
	
	
	//Cliff
	for (i=0; <2)
	{
		int hillID = rmCreateArea("hill"+i);
		if (i < 1)
		{
			rmSetAreaSize(hillID, 0.065, 0.065);
//			rmSetAreaMix(hillID, "deccan_grass_b");	
			rmSetAreaMix(hillID, "bayou_grass");
			rmAddAreaTerrainLayer(hillID, "bayou\ground6_bay", 0, 2);
//			rmAddAreaTerrainLayer(hillID, "bayou\ground6_bay", 0, 1);
			rmAddAreaInfluenceSegment(hillID, 0.85, 1.00, 0.56, 0.58);
			rmAddAreaInfluenceSegment(hillID, 1.00, 0.85, 0.58, 0.56);
			rmAddAreaInfluenceSegment(hillID, 1.00, 1.00, 0.57, 0.57);
			rmSetAreaElevationType(hillID, cElevTurbulence);
			rmSetAreaElevationVariation(hillID, 2.5);
			rmSetAreaBaseHeight(hillID, 3.0);
			rmSetAreaElevationMinFrequency(hillID, 0.09);
			rmSetAreaElevationOctaves(hillID, 3);
			rmSetAreaElevationPersistence(hillID, 0.4);
			rmSetAreaCoherence(hillID, 0.65);
			rmSetAreaSmoothDistance(hillID, 10);
		} 
		else
		{
			rmSetAreaSize(hillID, 0.024, 0.024);
			rmAddAreaInfluenceSegment(hillID, 1.00, 1.00, 0.60, 0.60);
			rmSetAreaCliffHeight(hillID, 7, 0.0, 0.8); 
			rmSetAreaCliffEdge(hillID, 1, 1.0, 0.0, 0.0, 1); 
//			rmSetAreaCliffType(hillID, "bayou"); 
			rmSetAreaCliffType(hillID, "bayou"); 
			rmSetAreaCliffPainting(hillID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
			rmAddAreaConstraint(hillID, avoidWaterShort);
			rmSetAreaCoherence(hillID, 0.75);
			rmSetAreaSmoothDistance(hillID, 6);
			rmAddAreaToClass(hillID, classCliff);
		}
		rmSetAreaWarnFailure(hillID, false);
		rmSetAreaObeyWorldCircleConstraint(hillID, false);
		rmAddAreaToClass(hillID, classIsland);
		rmSetAreaLocation(hillID, 1.0, 1.0);
		rmBuildArea(hillID);
	}
	
	
	//Player islands
	for(i=1; <3)
    {
		int playerislandID=rmCreateArea("player island"+i);
		rmSetAreaSize(playerislandID, 0.15, 0.15);
		if (i < 2)
			rmSetAreaLocation(playerislandID, 0.36, 1.00);
		else 
			rmSetAreaLocation(playerislandID, 1.00, 0.36);
		rmAddAreaTerrainLayer(playerislandID, "bayou\ground6_bay", 0, 5); 
//		rmAddAreaTerrainLayer(playerislandID, "bayou\ground6_bay", 0, 2); 
		rmSetAreaMix(playerislandID, "bayou_grass");
		rmSetAreaWarnFailure(playerislandID, false);
		rmAddAreaToClass(playerislandID, classIsland);
		rmSetAreaCoherence(playerislandID, 0.45);
		rmSetAreaSmoothDistance(playerislandID, 10);
		rmSetAreaElevationType(playerislandID, cElevTurbulence);
		rmSetAreaElevationVariation(playerislandID, 2.5);
		rmSetAreaBaseHeight(playerislandID, 3.0);
		rmSetAreaElevationMinFrequency(playerislandID, 0.09);
		rmSetAreaElevationOctaves(playerislandID, 3);
		rmSetAreaElevationPersistence(playerislandID, 0.4);      
	// 	rmAddConnectionArea(shallowsID, playerislandID);
		rmSetAreaObeyWorldCircleConstraint(playerislandID, false);
		rmAddAreaConstraint(playerislandID, avoidIslandShort);
		if (cNumberTeams <= 2)
			rmBuildArea(playerislandID);
		rmCreateAreaDistanceConstraint("avoid player island "+i, playerislandID, 5.0);
		rmCreateAreaMaxDistanceConstraint("stay in player island "+i, playerislandID, 0.0);
	}
	
	int avoidPlayerIsland1 = rmConstraintID("avoid player island 1");
	int avoidPlayerIsland2 = rmConstraintID("avoid player island 2");
	int stayInPlayerIsland1 = rmConstraintID("stay in player island 1");
	int stayInPlayerIsland2 = rmConstraintID("stay in player island 2");  


/*	//TP islands
	
	for (i=0; <3)
	{
		int TPislandID=rmCreateArea("TP island"+i);
		rmSetAreaSize(TPislandID, 0.025, 0.025);
		if (i < 1)
			rmSetAreaLocation(TPislandID, 0.18, 0.72);
		else if (i < 2)
			rmSetAreaLocation(TPislandID, 0.46, 0.46);
		else
			rmSetAreaLocation(TPislandID, 0.72, 0.18);	
//		rmAddAreaTerrainLayer(TPislandID, "bayou\ground6_bay", 2, 5);
//		rmAddAreaTerrainLayer(TPislandID, "bayou\ground6_bay", 0, 2);
		rmSetAreaMix(TPislandID, "bayou_grass");
		rmSetAreaWarnFailure(TPislandID, false);
		rmAddAreaToClass(TPislandID, classIsland);
		rmSetAreaCoherence(TPislandID, 0.30);
		rmSetAreaSmoothDistance(TPislandID, 10);
		rmSetAreaElevationType(TPislandID, cElevTurbulence);
		rmSetAreaElevationVariation(TPislandID, 2.0);
		rmSetAreaBaseHeight(TPislandID, 4.0);
		rmSetAreaElevationMinFrequency(TPislandID, 0.09);
		rmSetAreaElevationOctaves(TPislandID, 3);
		rmSetAreaElevationPersistence(TPislandID, 0.2);      
	// 	rmAddConnectionArea(shallowsID, TPislandID);
		rmSetAreaObeyWorldCircleConstraint(TPislandID, false);
//		rmAddAreaConstraint(TPislandID, avoidIslandMin);
		rmBuildArea(TPislandID);
	
	}
*/
	// Players area
	for (i=1; < cNumberPlayers)
	{
		int playerareaID = rmCreateArea("playerarea"+i);
		rmSetPlayerArea(i, playerareaID);
		if (cNumberNonGaiaPlayers <= 4)
			rmSetAreaSize(playerareaID, 0.042, 0.042);
		else if (cNumberNonGaiaPlayers == 5)
			rmSetAreaSize(playerareaID, 0.039, 0.039);
		else if (cNumberNonGaiaPlayers == 6)
			rmSetAreaSize(playerareaID, 0.035, 0.035);
		else
			rmSetAreaSize(playerareaID, 0.026, 0.026);
		rmSetAreaLocPlayer(playerareaID, i);
		rmAddAreaToClass(playerareaID, classIsland);
	//	rmAddAreaToClass(playerareaID, classIsland);
		rmSetAreaCoherence(playerareaID, 0.45);
		rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
		rmAddAreaTerrainLayer(playerareaID, "bayou\ground6_bay", 0, 5); 
		rmSetAreaMix(playerareaID, "bayou_grass");
		rmSetAreaWarnFailure(playerareaID, false);
		rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
		rmSetAreaSmoothDistance(playerareaID, 10);
		rmSetAreaElevationType(playerareaID, cElevTurbulence);
		rmSetAreaElevationVariation(playerareaID, 2.5);
		rmSetAreaBaseHeight(playerareaID, 3.0);
		rmSetAreaElevationMinFrequency(playerareaID, 0.09);
		rmSetAreaElevationOctaves(playerareaID, 3);
		rmSetAreaElevationPersistence(playerareaID, 0.4);    
		if (cNumberTeams > 2)
			rmBuildArea(playerareaID);
		rmCreateAreaDistanceConstraint("avoid player area "+i, playerareaID, 3.0);
		rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerareaID, 0.0);
	}
/*	
	int avoidPlayerArea1 = rmConstraintID("avoid player area 1");
	int avoidPlayerArea2 = rmConstraintID("avoid player area 2");
	int stayInPlayerArea1 = rmConstraintID("stay in player area 1");
	int stayInPlayerArea2 = rmConstraintID("stay in player area 2");
*/
	
	//Big islands
	for (i=0; <6*cNumberNonGaiaPlayers)
	{
		int BigislandID=rmCreateArea("Big island"+i);
		rmSetAreaSize(BigislandID, rmAreaTilesToFraction(450), rmAreaTilesToFraction(470)); //0.019, 0.021 rmAreaTilesToFraction(380), rmAreaTilesToFraction(420)
		rmAddAreaTerrainLayer(BigislandID, "bayou\ground6_bay", 0, 1);
//		rmAddAreaTerrainLayer(BigislandID, "bayou\ground6_bay", 0, 2);
		rmSetAreaMix(BigislandID, "bayou_grass");
		rmSetAreaWarnFailure(BigislandID, false);
		rmAddAreaToClass(BigislandID, classIsland);
		rmSetAreaCoherence(BigislandID, 0.25);
		rmSetAreaSmoothDistance(BigislandID, 5);
		rmSetAreaElevationType(BigislandID, cElevTurbulence);
		rmSetAreaElevationVariation(BigislandID, 2.0);
		rmSetAreaBaseHeight(BigislandID, 3.0);
		rmSetAreaElevationMinFrequency(BigislandID, 0.09);
		rmSetAreaElevationOctaves(BigislandID, 3);
		rmSetAreaElevationPersistence(BigislandID, 0.4);      
	// 	rmAddConnectionArea(shallowsID, BigislandID);
		rmSetAreaObeyWorldCircleConstraint(BigislandID, false);
		rmAddAreaConstraint(BigislandID, avoidIslandShort);
		rmBuildArea(BigislandID);
	
	}

	// *********************************************************************************************************
	
	// Text
	rmSetStatusText("",0.40);
	
	// ******************************************** NATIVES *************************************************
	
	
//	float Natsvariation = -1;
//	Natsvariation = rmRandFloat(0.0,1.0); // > 0.66 udasi, > 0.33 bhatki, else sufi
//	Natsvariation = 0.5; // <--- TEST
	  
	int nativeID0 = rmCreateGrouping("Bhatki village A", "native bhakti village "+1);
	int nativeID1 = rmCreateGrouping("Bhatki village B", "native bhakti village "+2);
	int nativeID2 = rmCreateGrouping("Bhatki village C", "native bhakti village "+1);
	int nativeID3 = rmCreateGrouping("Bhatki village D", "native bhakti village "+2);
	
//	rmSetGroupingMinDistance(nativeID0, 0.00);
//	rmSetGroupingMaxDistance(nativeID0, 0.00);
//	rmSetGroupingMinDistance(nativeID1, 0.00);
//	rmSetGroupingMaxDistance(nativeID1, 0.00);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
	
	if (cNumberTeams <= 2) // 1v1 and TEAM
	{
		if (cNumberNonGaiaPlayers == 2)
		{
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.31, 0.77);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.77, 0.31);
		}
		else
		{
			for (i=0; < 2)
			{
				int nativeareaID = rmCreateArea("native area"+i);
				if (cNumberNonGaiaPlayers <= 4)
					rmSetAreaSize(nativeareaID, 0.024, 0.024);
				else if (cNumberNonGaiaPlayers == 5)
					rmSetAreaSize(nativeareaID, 0.018, 0.018);
				else if (cNumberNonGaiaPlayers == 6)
					rmSetAreaSize(nativeareaID, 0.014, 0.014);
				else
					rmSetAreaSize(nativeareaID, 0.010, 0.010);
				if (i < 1)
					rmSetAreaLocation(nativeareaID,  0.20, 0.68);
				else 
					rmSetAreaLocation(nativeareaID,  0.68, 0.20);
				rmAddAreaToClass(nativeareaID, classIsland);
			//	rmAddAreaToClass(nativeareaID, classIsland);
				rmSetAreaCoherence(nativeareaID, 0.45);
				rmSetAreaObeyWorldCircleConstraint(nativeareaID, false);
				rmSetAreaMix(nativeareaID, "bayou_grass");
				rmAddAreaTerrainLayer(nativeareaID, "bayou\ground2_bay", 0, 5); 
				rmSetAreaWarnFailure(nativeareaID, false);
				rmSetAreaObeyWorldCircleConstraint(nativeareaID, false);
				rmSetAreaSmoothDistance(nativeareaID, 10);
				rmSetAreaElevationType(nativeareaID, cElevTurbulence);
				rmSetAreaElevationVariation(nativeareaID, 2.5);
				rmSetAreaBaseHeight(nativeareaID, 3.0);
				rmSetAreaElevationMinFrequency(nativeareaID, 0.09);
				rmSetAreaElevationOctaves(nativeareaID, 3);
				rmSetAreaElevationPersistence(nativeareaID, 0.4);    
				rmBuildArea(nativeareaID);
			}
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.20, 0.68);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.68, 0.20);
		}
		
		if (cNumberNonGaiaPlayers >= 4)	
		{
			for (i=0; < 2)
			{
				int nativeareasouthID = rmCreateArea("native area south"+i);
				if (cNumberNonGaiaPlayers == 6)
					rmSetAreaSize(nativeareasouthID, 0.014, 0.014);
				else
					rmSetAreaSize(nativeareasouthID, 0.010, 0.010);
				if (i < 1)
					rmSetAreaLocation(nativeareasouthID, 0.12, 0.32);
				else 
					rmSetAreaLocation(nativeareasouthID, 0.32, 0.12);
				rmAddAreaToClass(nativeareasouthID, classIsland);
			//	rmAddAreaToClass(nativeareasouthID, classIsland);
				rmSetAreaCoherence(nativeareasouthID, 0.45);
				rmSetAreaObeyWorldCircleConstraint(nativeareasouthID, false);
				rmSetAreaMix(nativeareasouthID, "bayou_grass");
				rmAddAreaTerrainLayer(nativeareasouthID, "bayou\ground2_bay", 0, 5); 
				rmSetAreaWarnFailure(nativeareasouthID, false);
				rmSetAreaObeyWorldCircleConstraint(nativeareasouthID, false);
				rmSetAreaSmoothDistance(nativeareasouthID, 10);
				rmSetAreaElevationType(nativeareasouthID, cElevTurbulence);
				rmSetAreaElevationVariation(nativeareasouthID, 2.5);
				rmSetAreaBaseHeight(nativeareasouthID, 3.0);
				rmSetAreaElevationMinFrequency(nativeareasouthID, 0.09);
				rmSetAreaElevationOctaves(nativeareasouthID, 3);
				rmSetAreaElevationPersistence(nativeareasouthID, 0.4);    
				rmBuildArea(nativeareasouthID);
			}
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.12, 0.32);
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.32, 0.12);
		}	
	}
	else // FFA
	{
		for (i=0; < 2)
		{
			int nativeareamiddleID = rmCreateArea("native area middle"+i);
			if (cNumberNonGaiaPlayers <= 4)
				rmSetAreaSize(nativeareamiddleID, 0.024, 0.024);
			else if (cNumberNonGaiaPlayers == 5)
				rmSetAreaSize(nativeareamiddleID, 0.018, 0.018);
			else if (cNumberNonGaiaPlayers == 6)
				rmSetAreaSize(nativeareamiddleID, 0.016, 0.016);
			else
				rmSetAreaSize(nativeareamiddleID, 0.010, 0.010);
			if (i < 1)
				rmSetAreaLocation(nativeareamiddleID,  0.55, 0.35);
			else 
				rmSetAreaLocation(nativeareamiddleID,  0.35, 0.55);
			rmAddAreaToClass(nativeareamiddleID, classIsland);
		//	rmAddAreaToClass(nativeareamiddleID, classIsland);
			rmSetAreaCoherence(nativeareamiddleID, 0.45);
			rmSetAreaObeyWorldCircleConstraint(nativeareamiddleID, false);
			rmSetAreaMix(nativeareamiddleID, "bayou_grass");
			rmAddAreaTerrainLayer(nativeareamiddleID, "bayou\ground2_bay", 0, 5); 
			rmSetAreaWarnFailure(nativeareamiddleID, false);
			rmSetAreaObeyWorldCircleConstraint(nativeareamiddleID, false);
			rmSetAreaSmoothDistance(nativeareamiddleID, 10);
			rmSetAreaElevationType(nativeareamiddleID, cElevTurbulence);
			rmSetAreaElevationVariation(nativeareamiddleID, 2.5);
			rmSetAreaBaseHeight(nativeareamiddleID, 3.0);
			rmSetAreaElevationMinFrequency(nativeareamiddleID, 0.09);
			rmSetAreaElevationOctaves(nativeareamiddleID, 3);
			rmSetAreaElevationPersistence(nativeareamiddleID, 0.4);    
			rmBuildArea(nativeareamiddleID);
		}
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.55, 0.35);
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.35, 0.55);
	
		if (cNumberNonGaiaPlayers >= 6)	
		{
			for (i=0; < 2)
			{
				int nativeareanorthID = rmCreateArea("native area north"+i);
				if (cNumberNonGaiaPlayers == 6)
					rmSetAreaSize(nativeareanorthID, 0.014, 0.014);
				else
					rmSetAreaSize(nativeareanorthID, 0.010, 0.010);
				if (i < 1)
					rmSetAreaLocation(nativeareanorthID, 0.62, 0.92);
				else 
					rmSetAreaLocation(nativeareanorthID, 0.92, 0.62);
				rmAddAreaToClass(nativeareanorthID, classIsland);
			//	rmAddAreaToClass(nativeareanorthID, classIsland);
				rmSetAreaCoherence(nativeareanorthID, 0.45);
				rmSetAreaObeyWorldCircleConstraint(nativeareanorthID, false);
				rmSetAreaMix(nativeareanorthID, "bayou_grass");
				rmAddAreaTerrainLayer(nativeareanorthID, "bayou\ground2_bay", 0, 5); 
				rmSetAreaWarnFailure(nativeareanorthID, false);
				rmSetAreaObeyWorldCircleConstraint(nativeareanorthID, false);
				rmSetAreaSmoothDistance(nativeareanorthID, 10);
				rmSetAreaElevationType(nativeareanorthID, cElevTurbulence);
				rmSetAreaElevationVariation(nativeareanorthID, 2.5);
				rmSetAreaBaseHeight(nativeareanorthID, 3.0);
				rmSetAreaElevationMinFrequency(nativeareanorthID, 0.09);
				rmSetAreaElevationOctaves(nativeareanorthID, 3);
				rmSetAreaElevationPersistence(nativeareanorthID, 0.4);    
				rmBuildArea(nativeareanorthID);
			}
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.62, 0.92);
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.92, 0.62);
		}	
	}
	
	
	// ******************************************************************************************************
	
	// Text
	rmSetStatusText("",0.50);
	
	// ************************************ PLAYER STARTING RESOURCES ***************************************

	// ******** Define ********

	// Town center & units
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 10.0);

	int TCID = rmCreateObjectDef("player TC");
	if (rmGetNomadStart())
	{
		rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
	rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);
	rmAddObjectDefToClass(TCID, classStartingResource);
	}
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 10.0);
	
	// Starting mines
	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "Mine", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 16.0);
	rmSetObjectDefMaxDistance(playergoldID, 18.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
//	rmAddObjectDefConstraint(playergoldID, avoidEdge);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "Mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 44.0); //58
	rmSetObjectDefMaxDistance(playergold2ID, 58.0); //62
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
//	rmAddObjectDefConstraint(playergold2ID, avoidTradeRouteShort);
//	rmAddObjectDefConstraint(playergold2ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playergold2ID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldType);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
//	rmAddObjectDefConstraint(playergold2ID, avoidCenter);
	rmAddObjectDefConstraint(playergold2ID, avoidEdge);
	
	// 3rd mine
	int playergold3ID = rmCreateObjectDef("player third mine");
	rmAddObjectDefItem(playergold3ID, "Mine", 1, 0);
	rmSetObjectDefMinDistance(playergold3ID, 46.0); //58
	rmSetObjectDefMaxDistance(playergold3ID, 60.0); //62
	rmAddObjectDefToClass(playergold3ID, classStartingResource);
	rmAddObjectDefToClass(playergold3ID, classGold);
//	rmAddObjectDefConstraint(playergold3ID, avoidTradeRouteShort);
//	rmAddObjectDefConstraint(playergold3ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playergold3ID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playergold3ID, avoidNatives);
	rmAddObjectDefConstraint(playergold3ID, avoidGoldType);
	rmAddObjectDefConstraint(playergold3ID, avoidStartingResources);
//	rmAddObjectDefConstraint(playergold3ID, avoidCenter);
	rmAddObjectDefConstraint(playergold3ID, avoidEdge);
	
	
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "ypTreeBorneoCanopy", rmRandInt(5,5), 5.0);
    rmSetObjectDefMinDistance(playerTreeID, 12);
    rmSetObjectDefMaxDistance(playerTreeID, 16);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
//	rmAddObjectDefConstraint(playerTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	
	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 2, 3.0);
	rmSetObjectDefMinDistance(playerberriesID, 12.0);
	rmSetObjectDefMaxDistance(playerberriesID, 14.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerberriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerberriesID, avoidNatives);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResources);
	
	// Starting herd
	int playeherdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playeherdID, "ypWildElephant", rmRandInt(2,2), 4.0);
	rmSetObjectDefMinDistance(playeherdID, 13.0);
	rmSetObjectDefMaxDistance(playeherdID, 16.0);
	rmSetObjectDefCreateHerd(playeherdID, false);
	rmAddObjectDefToClass(playeherdID, classStartingResource);
//	rmAddObjectDefConstraint(playeherdID, avoidTradeRoute);
//	rmAddObjectDefConstraint(playeherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(playeherdID, avoidNatives);
	rmAddObjectDefConstraint(playeherdID, avoidStartingResources);
		
	// 2nd herd
	int player2ndherdID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(player2ndherdID, "Peafowl", rmRandInt(8,8), 6.0);
    rmSetObjectDefMinDistance(player2ndherdID, 28);
    rmSetObjectDefMaxDistance(player2ndherdID, 32);
	rmAddObjectDefToClass(player2ndherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player2ndherdID, true);
	rmAddObjectDefConstraint(player2ndherdID, avoidStartingResources);
	rmAddObjectDefConstraint(player2ndherdID, avoidEleShort); 
//	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteShort);
//	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteSocket);
//	rmAddObjectDefConstraint(player2ndherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(player2ndherdID, avoidEdge);
	rmAddObjectDefConstraint(player2ndherdID, avoidNativesShort);
		
	// 3nd herd
	int player3rdherdID = rmCreateObjectDef("player 3rd herd");
	rmAddObjectDefItem(player3rdherdID, "ypNilgai", rmRandInt(6,6), 6.0);
    rmSetObjectDefMinDistance(player3rdherdID, 46);
    rmSetObjectDefMaxDistance(player3rdherdID, 50);
	rmAddObjectDefToClass(player3rdherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player3rdherdID, true);
	rmAddObjectDefConstraint(player3rdherdID, avoidStartingResources);
	rmAddObjectDefConstraint(player3rdherdID, avoidEleShort); 
	rmAddObjectDefConstraint(player3rdherdID, avoidNilgau); 
//	rmAddObjectDefConstraint(player3rdherdID, avoidTradeRouteShort);
//	rmAddObjectDefConstraint(player3rdherdID, avoidTradeRouteSocket);
//	rmAddObjectDefConstraint(player3rdherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(player3rdherdID, avoidEdge);
	rmAddObjectDefConstraint(player3rdherdID, avoidNatives);

	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 18.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 28.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
//	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget); //Short
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	int nugget0count = rmRandInt (1,2); // 1,2
	
		
	// ******** Place ********
	
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (teamZeroCount == 1 && teamOneCount == 1 && cNumberTeams <= 2)
			rmPlaceObjectDefAtLoc(playergold3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		if (cNumberTeams <= 2 && rmGetNumberPlayersOnTeam(i-1) == 1)
//			rmPlaceObjectDefAtLoc(playergold3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playeherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(player2ndherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(player3rdherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		if (nugget0count == 2)
//			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
				
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}

	// ************************************************************************************************
	
	// Text
	rmSetStatusText("",0.60);
	
	// ************************************** COMMON RESOURCES ****************************************
  
   
	// ************* Mines **************
	
	int goldcount = (3*cNumberNonGaiaPlayers);  
	int goldshipcount = (cNumberNonGaiaPlayers);
	
	// Common mines
	for(i=0; < goldcount)
	{
		int commongoldID = rmCreateObjectDef("common mines"+i);
		rmAddObjectDefItem(commongoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(commongoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(commongoldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(commongoldID, classGold);
//		rmAddObjectDefConstraint(commongoldID, avoidTradeRoute);
//		rmAddObjectDefConstraint(commongoldID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(commongoldID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(commongoldID, avoidNatives);
		rmAddObjectDefConstraint(commongoldID, avoidGoldFar);
		rmAddObjectDefConstraint(commongoldID, avoidTownCenterFar);
		rmAddObjectDefConstraint(commongoldID, avoidEdge);
		rmAddObjectDefConstraint(commongoldID, avoidCliff);
		rmAddObjectDefConstraint(commongoldID, avoidCenter);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(commongoldID, staySouthPart);
		rmAddObjectDefConstraint(commongoldID, avoidPlayerIsland1);
		rmAddObjectDefConstraint(commongoldID, avoidPlayerIsland2);
		rmPlaceObjectDefAtLoc(commongoldID, 0, 0.50, 0.50);
	}

	// Ship mines
	for(i=0; < goldshipcount)
	{
		int commongold2ID = rmCreateObjectDef("common ships"+i);
		rmAddObjectDefItem(commongold2ID, "MineShipRuins", 1, 0.0);
		rmSetObjectDefMinDistance(commongold2ID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(commongold2ID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(commongold2ID, classGold);
//		rmAddObjectDefConstraint(commongold2ID, avoidTradeRoute);
//		rmAddObjectDefConstraint(commongold2ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(commongold2ID, avoidNatives);
		rmAddObjectDefConstraint(commongold2ID, avoidGoldFar);
		rmAddObjectDefConstraint(commongold2ID, avoidTownCenter);
		rmAddObjectDefConstraint(commongold2ID, avoidEdge);
		rmAddObjectDefConstraint(commongold2ID, avoidCliffShort);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(commongold2ID, staySouthPart);
		rmAddObjectDefConstraint(commongold2ID, avoidPlayerIsland1);
		rmAddObjectDefConstraint(commongold2ID, avoidPlayerIsland2);
		rmPlaceObjectDefAtLoc(commongold2ID, 0, 0.50, 0.50);
	}
		
	// *********************************
	
	// Text
	rmSetStatusText("",0.70);
	
	// ************ Forest *************


	// Inland forest
	int forestinlandcount = 10*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 4)
		forestinlandcount = 8*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 6)
		forestinlandcount = 6*cNumberNonGaiaPlayers;
	int stayInForestInlandPatch = -1;
	
	for (i=0; < forestinlandcount)
	{
		int forestinlandID = rmCreateArea("forest inland "+i);
		rmSetAreaWarnFailure(forestinlandID, false);
		rmSetAreaSize(forestinlandID, rmAreaTilesToFraction(110), rmAreaTilesToFraction(140));
		rmSetAreaMix(forestinlandID, "bayou_forest");
		rmSetAreaObeyWorldCircleConstraint(forestinlandID, false);
//		rmSetAreaForestDensity(forestinlandID, 0.8);
//		rmSetAreaForestClumpiness(forestinlandID, 0.15);
//		rmSetAreaForestUnderbrush(forestinlandID, 0.2);
		rmSetAreaMinBlobs(forestinlandID, 2);
		rmSetAreaMaxBlobs(forestinlandID, 4);
		rmSetAreaMinBlobDistance(forestinlandID, 12.0);
		rmSetAreaMaxBlobDistance(forestinlandID, 30.0);
		rmSetAreaCoherence(forestinlandID, 0.55);
		rmSetAreaSmoothDistance(forestinlandID, 6);
		rmAddAreaToClass(forestinlandID, classForest);
		rmAddAreaConstraint(forestinlandID, avoidForest);
		rmAddAreaConstraint(forestinlandID, avoidGoldMin);
		rmAddAreaConstraint(forestinlandID, avoidEleMin); 
		rmAddAreaConstraint(forestinlandID, avoidNilgauMin); 
		rmAddAreaConstraint(forestinlandID, avoidTownCenterShort); 
		rmAddAreaConstraint(forestinlandID, avoidNativesShort);
//		rmAddAreaConstraint(forestinlandID, avoidTradeRouteShort);
//		rmAddAreaConstraint(forestinlandID, avoidTradeRouteSocket);
		rmAddAreaConstraint(forestinlandID, avoidImpassableLandMin);
//		if (i <  4)
//			rmAddAreaConstraint(forestinlandID, stayInPlayerArea1);
//		else
//			rmAddAreaConstraint(forestinlandID, stayInPlayerArea2);
		rmAddAreaConstraint(forestinlandID, avoidCliffShort);
//		rmAddAreaConstraint(forestinlandID, avoidEdge);
		rmBuildArea(forestinlandID);
		
		stayInForestInlandPatch = rmCreateAreaMaxDistanceConstraint("stay in forest inland patch"+i, forestinlandID, 0.0);
		
		for (j=0; < rmRandInt(8,10)) //
		{
			int forestinlandtreeID = rmCreateObjectDef("forest inland trees"+i+j);
			rmAddObjectDefItem(forestinlandtreeID, "ypTreeBorneoCanopy", rmRandInt(1,2), 2.0);
			rmSetObjectDefMinDistance(forestinlandtreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(forestinlandtreeID,  rmXFractionToMeters(0.5));
		//	rmAddObjectDefToClass(forestinlandtreeID, classForest);
		//	rmAddObjectDefConstraint(forestinlandtreeID, avoidForestShort);
		//	rmAddObjectDefConstraint(forestinlandtreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(forestinlandtreeID, stayInForestInlandPatch);	
			rmPlaceObjectDefAtLoc(forestinlandtreeID, 0, 0.50, 0.50);
		}
	}
	

	// Marsh forest
	int forestimarshcount = 10*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 4)
		forestimarshcount = 8*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 6)
		forestimarshcount = 6*cNumberNonGaiaPlayers;
	int stayInForestMarshPatch = -1;
	
	for (i=0; < forestimarshcount)
	{
		int forestmarshID = rmCreateArea("forest marsh "+i);
		rmSetAreaWarnFailure(forestmarshID, false);
		rmSetAreaSize(forestmarshID, rmAreaTilesToFraction(110), rmAreaTilesToFraction(140));
		rmSetAreaMix(forestmarshID, "bayou_forest");
		rmSetAreaObeyWorldCircleConstraint(forestmarshID, false);
//		rmSetAreaForestDensity(forestmarshID, 0.8);
//		rmSetAreaForestClumpiness(forestmarshID, 0.15);
//		rmSetAreaForestUnderbrush(forestmarshID, 0.2);
		rmSetAreaMinBlobs(forestmarshID, 2);
		rmSetAreaMaxBlobs(forestmarshID, 4);
		rmSetAreaMinBlobDistance(forestmarshID, 12.0);
		rmSetAreaMaxBlobDistance(forestmarshID, 30.0);
		rmSetAreaCoherence(forestmarshID, 0.55);
		rmSetAreaSmoothDistance(forestmarshID, 6);
		rmAddAreaToClass(forestmarshID, classForest);
		rmAddAreaConstraint(forestmarshID, avoidForestShort);
		rmAddAreaConstraint(forestmarshID, avoidGoldMin);
		rmAddAreaConstraint(forestmarshID, avoidEleMin); 
		rmAddAreaConstraint(forestmarshID, avoidNilgauMin); 
		rmAddAreaConstraint(forestmarshID, avoidTownCenterShort); 
		rmAddAreaConstraint(forestmarshID, avoidNativesShort);
//		rmAddAreaConstraint(forestmarshID, avoidTradeRouteShort);
//		rmAddAreaConstraint(forestmarshID, avoidTradeRouteSocket);
//		rmAddAreaConstraint(forestmarshID, avoidImpassableLandMin);
//		if (i <  4)
//			rmAddAreaConstraint(forestmarshID, stayInPlayerArea1);
//		else
//			rmAddAreaConstraint(forestmarshID, stayInPlayerArea2);
		rmAddAreaConstraint(forestmarshID, avoidCliffShort);
//		rmAddAreaConstraint(forestmarshID, avoidEdge);
		rmBuildArea(forestmarshID);
		
		stayInForestMarshPatch = rmCreateAreaMaxDistanceConstraint("stay in forest marsh patch"+i, forestmarshID, 0.0);
		
		for (j=0; < rmRandInt(8,10))
		{
			int forestmarshtreeID = rmCreateObjectDef("forest marsh trees"+i+j);
			rmAddObjectDefItem(forestmarshtreeID, "TreeYucatan", rmRandInt(1,2), 2.0);
			rmSetObjectDefMinDistance(forestmarshtreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(forestmarshtreeID,  rmXFractionToMeters(0.5));
		//	rmAddObjectDefToClass(forestmarshtreeID, classForest);
		//	rmAddObjectDefConstraint(forestmarshtreeID, avoidForestShort);
//			rmAddObjectDefConstraint(forestmarshtreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(forestmarshtreeID, stayInForestMarshPatch);	
			rmPlaceObjectDefAtLoc(forestmarshtreeID, 0, 0.50, 0.50);
		}
	}
	
	
	// ********************************
	
	// Text
	rmSetStatusText("",0.80);
	
	// ************ Herds *************
	
	int nilgaiherdcount = 6*cNumberNonGaiaPlayers; //15
		
		
	//Nilgai herds
	for (i=0; < nilgaiherdcount)
	{
		int lowgroundherdID = rmCreateObjectDef("lowground herd"+i);
		rmAddObjectDefItem(lowgroundherdID, "ypNilgai", rmRandInt(6,7), 6.0);
		rmSetObjectDefMinDistance(lowgroundherdID, 0.0);
		rmSetObjectDefMaxDistance(lowgroundherdID, rmXFractionToMeters(0.6));
		rmSetObjectDefCreateHerd(lowgroundherdID, true);
		rmAddObjectDefConstraint(lowgroundherdID, avoidForestMin);
		rmAddObjectDefConstraint(lowgroundherdID, avoidGoldShort);
		rmAddObjectDefConstraint(lowgroundherdID, avoidNilgauFar); 
		rmAddObjectDefConstraint(lowgroundherdID, avoidEleFar); 
		rmAddObjectDefConstraint(lowgroundherdID, avoidTownCenter); 
		rmAddObjectDefConstraint(lowgroundherdID, avoidNatives);
//		rmAddObjectDefConstraint(lowgroundherdID, avoidTradeRouteShort);
//		rmAddObjectDefConstraint(lowgroundherdID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(lowgroundherdID, avoidCliff);
		rmAddObjectDefConstraint(lowgroundherdID, avoidEdge);
//		if (i < 2)
//			rmAddObjectDefConstraint(lowgroundherdID, staySW);
//		else if (i < 4)
//			rmAddObjectDefConstraint(lowgroundherdID, stayNE);
		rmPlaceObjectDefAtLoc(lowgroundherdID, 0, 0.50, 0.50);	
	}
	

	// ************************************
	
	// Text
	rmSetStatusText("",0.90);
		
	// ************** Treasures ***************
	
	int treasure1count = 5+cNumberNonGaiaPlayers;
	int treasure2count = 3+cNumberNonGaiaPlayers;
	int treasure34count = cNumberNonGaiaPlayers;

	
	// Treasures lvl3	
	for (i=0; < treasure34count)
	{
		int Nugget3ID = rmCreateObjectDef("nugget lvl3 "+i); 
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, 0);
		rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(3,4);
		rmAddObjectDefConstraint(Nugget3ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget3ID, avoidNatives);
//		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteShort);
//		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterMed);
		rmAddObjectDefConstraint(Nugget3ID, avoidNilgauMin); 
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget3ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget3ID, avoidCliff);
//		if (i < 2)
//			rmAddObjectDefConstraint(Nugget3ID, staySouthHalf); 
//		else if (i < 4)
//			rmAddObjectDefConstraint(Nugget3ID, stayNorthHalf); 
		if (cNumberNonGaiaPlayers >= 4 && cNumberTeams <= 2)
			rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50);
	}
	
		
	// Treasures lvl2	
	for (i=0; < treasure2count)
	{
		int Nugget2ID = rmCreateObjectDef("nugget lvl2 "+i); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(2,3);
		rmAddObjectDefConstraint(Nugget2ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget2ID, avoidNatives);
//		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteShort);
//		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterMed);
		rmAddObjectDefConstraint(Nugget2ID, avoidNilgauMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget2ID, avoidCliff);
//		if (i < 2)
//			rmAddObjectDefConstraint(Nugget2ID, staySouthHalf); 
//		else if (i < 4)
//			rmAddObjectDefConstraint(Nugget2ID, stayNorthHalf); 
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}
	
	// Treasures lvl1
	for (i=0; < treasure1count)
	{
		int Nugget1ID = rmCreateObjectDef("nugget lvl1 "+i); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, 0);
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(1,2);
		rmAddObjectDefConstraint(Nugget1ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget1ID, avoidNatives);
//		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteShort);
//		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget1ID, avoidNilgauMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget1ID, avoidCliff);
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);
	}
	
	// ****************************************

	// Text
	rmSetStatusText("",0.95);
	
	// ************ Water buffalos *************
	
	int buffalocount = 3+2*cNumberNonGaiaPlayers;
	
	
	for (i=0; < buffalocount)
	{
		int buffaloID=rmCreateObjectDef("water buffalo"+i);
		rmAddObjectDefItem(buffaloID, "ypWaterBuffalo", 1, 1.0);
		rmSetObjectDefMinDistance(buffaloID, 0.0);
		rmSetObjectDefMaxDistance(buffaloID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(buffaloID, avoidBuffalo);
		rmAddObjectDefConstraint(buffaloID, avoidForestMin);
		rmAddObjectDefConstraint(buffaloID, avoidTownCenterFar);
		rmAddObjectDefConstraint(buffaloID, avoidIslandMin);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(buffaloID, staySouthPart);
		rmAddObjectDefConstraint(buffaloID, avoidEdge);
		rmPlaceObjectDefAtLoc(buffaloID, 0, 0.50, 0.50);
	}
	
	// ******************************************
	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.5;
		float yLoc = 0.5;
		float walk = 0.04;

		ypKingsHillLandfill(xLoc, yLoc, 0.025, 1.0, "bayou_grass", 0);
		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}

	// Text
	rmSetStatusText("",1.00);

	
} //END
	
	