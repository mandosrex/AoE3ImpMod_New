// vivid's Vietnam (Obs) v3
// designed by vividlyplain
// observer UI by Aizamk

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{

	
	// Text
	// These status text lines are used to manually animate the map generation progress bar
	rmSetStatusText("",0.01); 
	
	// ____________________ General ____________________
	
	// Picks the map size
		int playerTiles=12000;
		if (cNumberNonGaiaPlayers >= 4)
			playerTiles = 10000;
		int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); 
		rmEchoInfo("Map size="+size+"m x "+size+"m");
		rmSetMapSize(size, size);
		
	// Make the corners.
		rmSetWorldCircleConstraint(true);
			
	// Picks a default water height
		rmSetSeaLevel(0.0);	
		rmSetMapElevationParameters(cElevTurbulence, 0.05, 3, 0.4, 4.0); 
		
	// Picks default terrain and water
		rmSetSeaType("atlantic coast");
		rmSetBaseTerrainMix("carolina_grass");
		rmTerrainInitialize("water", 0.0);
		rmSetMapType("plymouth"); 
		rmSetMapType("grass");
		rmSetMapType("water");
		rmSetMapType("namerica");
		rmSetMapType("AIFishingUseful");
		rmSetLightingSet("201a"); 
		
	// Choose Mercs
		chooseMercs();
		
	// Text
		rmSetStatusText("",0.10);
		
	// Set up Natives
		int subCiv0 = -1;
		int subCiv1 = -1;
		subCiv0 = rmGetCivID("Huron");
		subCiv1 = rmGetCivID("Jesuit");
		rmSetSubCiv(0, "Huron");
		rmSetSubCiv(1, "Jesuit");
	
	//Define some classes. These are used later for constraints.
		int classPlayer = rmDefineClass("Players");
		int classPatch = rmDefineClass("patch");
		int classPatch2 = rmDefineClass("patch2");
		int classPatch3 = rmDefineClass("patch3");
		int classPatch4 = rmDefineClass("patch4");
		rmDefineClass("startingUnit");
		int classForest = rmDefineClass("Forest");
		int importantItem = rmDefineClass("importantItem");
		int classNative = rmDefineClass("natives");
		int classSwamp = rmDefineClass("Swamp");
		int classIsland = rmDefineClass("Island");
		int classGold = rmDefineClass("Gold");
		int classStartingResource = rmDefineClass("startingResource");
	
	// Text
		rmSetStatusText("",0.20);
		
		// ____________________ Constraints ____________________	
	
	// Cardinal Directions & Map placement
		int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(1.0), rmDegreesToRadians(0),rmDegreesToRadians(360));
		int stayCenter = rmCreatePieConstraint("Stay Center",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.25), rmDegreesToRadians(0),rmDegreesToRadians(360));
		int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
		int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));

	// Resource avoidance
		int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 40.0); 
		int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 26.0);  
		int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 18.0); 
		int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 8.0);
		int avoidForestZero=rmCreateClassDistanceConstraint("avoid forest zero", rmClassID("Forest"), 4.0);
		int avoidSaigaFar = rmCreateTypeDistanceConstraint("avoid Saiga far", "Deer", 60.0);
		int avoidSaiga = rmCreateTypeDistanceConstraint("avoid Saiga", "Deer", 45.0);
		int avoidSaigaShort = rmCreateTypeDistanceConstraint("avoid Saiga short", "Deer", 30.0);
		int avoidSaigaMin = rmCreateTypeDistanceConstraint("avoid Saiga min", "Deer", 5.0);
		int avoidBerriesFar = rmCreateTypeDistanceConstraint("avoid berries far", "berrybush", 56.0);
		int avoidBerriesMed = rmCreateTypeDistanceConstraint("avoid  berries med", "berrybush", 40.0);
		int avoidBerries = rmCreateTypeDistanceConstraint("avoid  berries", "berrybush", 30.0);
		int avoidBerriesShort = rmCreateTypeDistanceConstraint("avoid  berries short", "berrybush", 20.0);
		int avoidBerriesMin = rmCreateTypeDistanceConstraint("avoid berries min", "berrybush", 10.0);
		int avoidGoldTypeMin = rmCreateTypeDistanceConstraint("coin avoids coin min ", "gold", 12.0);
		int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 18.0);
		int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 26.0);
		int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 38.0);
		int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
		int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 32.0);
		int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 50.0);
		int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 60.0);
		int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 20.0);
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 45.0);
		int avoidFish=rmCreateTypeDistanceConstraint("avoid fish", "fish", 8.0);
		int avoidWhale=rmCreateTypeDistanceConstraint("avoid whale", "fish", 30);
		
		int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 82.0);
		int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 55.0);
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 40.0);
		int avoidTownCenterMed=rmCreateTypeDistanceConstraint(" avoid Town Center med", "townCenter", 30.0);
		int avoidTownCenterShort=rmCreateTypeDistanceConstraint(" avoid Town Center short", "townCenter", 20.0);
		int avoidTownCenterResources=rmCreateTypeDistanceConstraint(" avoid Town Center", "townCenter", 40.0);
		int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 8.0);
		int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", rmClassID("natives"), 16.0);
		int avoidStartingResources  = rmCreateClassDistanceConstraint("avoid starting resource", rmClassID("startingResource"), 8.0);
		int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("avoid starting resource short", rmClassID("startingResource"), 4.0);

	// Land and terrain constraints
		int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
		int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("far avoid impassable land", "Land", false, 10.0);
		int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 3.0);
		int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("min avoid impassable land", "Land", false, 1.0);
		int avoidImpassableLandZero=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 0.2);
		int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 35);
		int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "land", false, 12.0);
		int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
		int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 14.0);
		int avoidPatch = rmCreateClassDistanceConstraint("patch avoid patch", rmClassID("patch"), 24.0);
		int avoidPatch2 = rmCreateClassDistanceConstraint("patch avoid patch 2", rmClassID("patch2"), 40.0);
		int avoidPatch3 = rmCreateClassDistanceConstraint("patch avoid patch 3", rmClassID("patch3"), 24.0);
		int avoidPatch4 = rmCreateClassDistanceConstraint("patch avoid patch 4", rmClassID("patch4"), 24.0);
		int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 8.0);
		int avoidLandFar = rmCreateTerrainDistanceConstraint("avoid land far ", "Land", true, 18.0);
		int avoidLandShort = rmCreateTerrainDistanceConstraint("avoid land short ", "Land", true, 4.0);
		int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 8.0);
		int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 12.0);
		int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 20.0);
		
	// Unit avoidance
		int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);
		int avoidStartingUnitsSmall = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 5.0);
		int avoidColonyShip=rmCreateTypeDistanceConstraint("avoid colony ship", "HomeCityWaterSpawnFlag", 15.0);
		int avoidColonyShipShort = rmCreateTypeDistanceConstraint("avoid colony ship short", "HomeCityWaterSpawnFlag", 10.0);		

	// ____________________ Player Placement ____________________

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);


		if (cNumberTeams <= 2) // 1v1 and TEAM
		{
			if (teamZeroCount == 1 && teamOneCount == 1) // 1v1
			{
				float OneVOnePlacement=rmRandFloat(0.0, 0.9);
				if ( OneVOnePlacement < 0.5)
				{
					rmPlacePlayer(1, 0.4, 0.25);
					rmPlacePlayer(2, 0.4, 0.75);
				}
				else
				{
					rmPlacePlayer(2, 0.4, 0.25);
					rmPlacePlayer(1, 0.4, 0.75);
				}

			}
			else // TEAM
			{
				if (teamZeroCount == 2 && teamOneCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.35, 0.25, 0.60, 0.20, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.35, 0.75, 0.60, 0.80, 0.00, 0.20);
				}
				else // 3v3, 4v4, etc
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.30, 0.30, 0.625, 0.20, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.30, 0.70, 0.625, 0.80, 0.00, 0.20);
				}
			}
		}
	else // FFA
		{
			rmSetTeamSpacingModifier(0.25);
			rmPlacePlayersLine(0.5, 0.1, 0.5, 0.9, 0, 0);
		}

	
	// Text
		rmSetStatusText("",0.30);
	
	// ____________________ Map Parameters ____________________
	
	// Main Land
	int mainlandID = rmCreateArea("main island");
	rmSetAreaSize(mainlandID, 0.70, 0.70);
	rmSetAreaLocation(mainlandID, 0.00, 0.50);
	rmAddAreaInfluenceSegment(mainlandID, 0.60, 1.00, 0.60, 0.00);	
	rmAddAreaInfluenceSegment(mainlandID, 0.50, 1.00, 0.50, 0.00);	
	rmAddAreaInfluenceSegment(mainlandID, 0.40, 1.00, 0.40, 0.00);	
	rmAddAreaInfluenceSegment(mainlandID, 0.30, 1.00, 0.30, 0.00);	
	rmAddAreaInfluenceSegment(mainlandID, 0.20, 1.00, 0.20, 0.00);	
	rmAddAreaInfluenceSegment(mainlandID, 0.10, 1.00, 0.10, 0.00);	
	rmAddAreaInfluenceSegment(mainlandID, 0.00, 1.00, 0.00, 0.00);	
//	rmSetAreaMix(mainlandID, "araucania_grass_a");		// bayou_grass		// borneo_grass_a
	rmSetAreaWarnFailure(mainlandID, false);
	rmSetAreaCoherence(mainlandID, 0.80); 
	rmSetAreaElevationType(mainlandID, cElevTurbulence);
	rmSetAreaElevationVariation(mainlandID, 0.25);
	rmSetAreaBaseHeight(mainlandID, 1.0);
	rmSetAreaElevationMinFrequency(mainlandID, 0.04);
	rmSetAreaElevationOctaves(mainlandID, 3);
	rmSetAreaElevationPersistence(mainlandID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(mainlandID, false);
	rmBuildArea(mainlandID);
	
	int avoidMainLand = rmCreateAreaDistanceConstraint("avoid main land", mainlandID, 25.0);
	int stayInMainLand = rmCreateAreaMaxDistanceConstraint("stay in main land", mainlandID, 0.0);

	// Paint the land
	int paintlandID = rmCreateArea("paint land");
	rmSetAreaSize(paintlandID, 0.60, 0.60);
	rmSetAreaLocation(paintlandID, 0.50, 0.50);
	rmAddAreaInfluenceSegment(paintlandID, 0.70, 1.00, 0.70, 0.00);	
	rmAddAreaInfluenceSegment(paintlandID, 0.60, 1.00, 0.60, 0.00);	
	rmAddAreaInfluenceSegment(paintlandID, 0.50, 1.00, 0.50, 0.00);	
	rmAddAreaInfluenceSegment(paintlandID, 0.40, 1.00, 0.40, 0.00);	
	rmAddAreaInfluenceSegment(paintlandID, 0.30, 1.00, 0.30, 0.00);	
	rmAddAreaInfluenceSegment(paintlandID, 0.23, 1.00, 0.23, 0.00);	
	rmSetAreaMix(paintlandID, "carolina_grass");
	rmSetAreaWarnFailure(paintlandID, false);
	rmSetAreaCoherence(paintlandID, 1.00); 
	rmSetAreaObeyWorldCircleConstraint(paintlandID, false);
	rmBuildArea(paintlandID);
	
	// Players area
	for (i=1; < cNumberPlayers)
	{
	int playerareaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerareaID);
	rmSetAreaSize(playerareaID, 0.08, 0.08);
//	rmSetAreaMix(playerareaID, "testmix");
	rmSetAreaCoherence(playerareaID, 0.99);
	rmSetAreaWarnFailure(playerareaID, false);
	rmSetAreaLocPlayer(playerareaID, i);
	rmBuildArea(playerareaID);
	
	int avoidPlayerArea = rmCreateAreaDistanceConstraint("avoid player area "+i, playerareaID, 20.0);
	int stayInPlayerArea = rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerareaID, 0.0);
	}

	// Berry Zone SE
	int berryzoneSEID = rmCreateArea("berry zone SE");
	rmSetAreaSize(berryzoneSEID, 0.085, 0.085);
	rmSetAreaLocation(berryzoneSEID, 0.70, 0.05);
	rmAddAreaInfluenceSegment(berryzoneSEID, 0.70, 0.05, 0.20, 0.05);	
	rmAddAreaInfluenceSegment(berryzoneSEID, 0.70, 0.00, 0.30, 0.00);	
	rmAddAreaInfluenceSegment(berryzoneSEID, 0.30, 0.10, 0.20, 0.15);	
	rmSetAreaWarnFailure(berryzoneSEID, false);
//	rmSetAreaMix(berryzoneSEID, "yellow_river_b");	// for testing
	rmSetAreaCoherence(berryzoneSEID, 1.0); 
	rmSetAreaElevationType(berryzoneSEID, cElevTurbulence);
	rmSetAreaElevationVariation(berryzoneSEID, 5.0);
	rmSetAreaElevationMinFrequency(berryzoneSEID, 0.04);
	rmSetAreaElevationOctaves(berryzoneSEID, 3);
	rmSetAreaElevationPersistence(berryzoneSEID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(berryzoneSEID, false);
	rmBuildArea(berryzoneSEID);	

	// Berry Zone NW
	int berryzoneNWID = rmCreateArea("berry zone NW");
	rmSetAreaSize(berryzoneNWID, 0.085, 0.085);
	rmSetAreaLocation(berryzoneNWID, 0.70, 0.95);
	rmAddAreaInfluenceSegment(berryzoneNWID, 0.70, 0.95, 0.20, 0.95);	
	rmAddAreaInfluenceSegment(berryzoneNWID, 0.70, 1.00, 0.30, 1.00);	
	rmAddAreaInfluenceSegment(berryzoneNWID, 0.30, 0.90, 0.20, 0.85);	
	rmSetAreaWarnFailure(berryzoneNWID, false);
//	rmSetAreaMix(berryzoneNWID, "yellow_river_b");	// for testing
	rmSetAreaCoherence(berryzoneNWID, 1.0); 
	rmSetAreaElevationType(berryzoneNWID, cElevTurbulence);
	rmSetAreaElevationVariation(berryzoneNWID, 5.0);
	rmSetAreaElevationMinFrequency(berryzoneNWID, 0.04);
	rmSetAreaElevationOctaves(berryzoneNWID, 3);
	rmSetAreaElevationPersistence(berryzoneNWID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(berryzoneNWID, false);
	rmBuildArea(berryzoneNWID);	
	
	int avoidberryzoneSE = rmCreateAreaDistanceConstraint("avoid berry zone SE ", berryzoneSEID, 20.0);
	int avoidberryzoneSEShort = rmCreateAreaDistanceConstraint("avoid berry zone SE short ", berryzoneSEID, 12.0);
	int stayberryzoneSE = rmCreateAreaMaxDistanceConstraint("stay in berry zone SE ", berryzoneSEID, 0.0);	
	int avoidberryzoneNW = rmCreateAreaDistanceConstraint("avoid berry zone NW ", berryzoneNWID, 20.0);
	int avoidberryzoneNWShort = rmCreateAreaDistanceConstraint("avoid berry zone NW short ", berryzoneNWID, 12.0);
	int stayberryzoneNW = rmCreateAreaMaxDistanceConstraint("stay in berry zone NW ", berryzoneNWID, 0.0);

	// Hunts Zone
	int huntszoneID = rmCreateArea("hunts zone");
	if (cNumberNonGaiaPlayers < 5)
		rmSetAreaSize(huntszoneID, 0.08, 0.08);
	else
		rmSetAreaSize(huntszoneID, 0.10, 0.10);
	rmSetAreaLocation(huntszoneID, 0.60, 0.50);
	rmAddAreaInfluenceSegment(huntszoneID, 0.60, 0.50, 0.40, 0.50);	
	rmSetAreaWarnFailure(huntszoneID, false);
//	rmSetAreaMix(huntszoneID, "yellow_river_b");	// for testing
	rmSetAreaCoherence(huntszoneID, 1.0); 
	rmSetAreaElevationType(huntszoneID, cElevTurbulence);
	rmSetAreaElevationVariation(huntszoneID, 5.0);
	rmSetAreaElevationMinFrequency(huntszoneID, 0.04);
	rmSetAreaElevationOctaves(huntszoneID, 3);
	rmSetAreaElevationPersistence(huntszoneID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(huntszoneID, false);
	rmBuildArea(huntszoneID);	
	
	int avoidHuntsZone = rmCreateAreaDistanceConstraint("avoid hunts zone ", huntszoneID, 20.0);
	int avoidHuntsZoneShort = rmCreateAreaDistanceConstraint("avoid hunts zone short ", huntszoneID, 12.0);
	int stayHuntsZone = rmCreateAreaMaxDistanceConstraint("stay in hunts zone ", huntszoneID, 0.0);

	// Native Zone 
	int nativezoneID = rmCreateArea("native zone");
	rmSetAreaSize(nativezoneID, 0.25, 0.25);
	rmSetAreaLocation(nativezoneID, 0.20, 0.00);
	rmAddAreaInfluenceSegment(nativezoneID, 0.20, 0.00, 0.20, 1.0);	
	rmAddAreaInfluenceSegment(nativezoneID, 0.10, 0.00, 0.10, 1.0);	
	rmAddAreaInfluenceSegment(nativezoneID, 0.00, 0.00, 0.00, 1.0);	
	rmSetAreaWarnFailure(nativezoneID, false);
//	rmSetAreaMix(nativezoneID, "testmix");	// for testing
	rmSetAreaCoherence(nativezoneID, 1.0); 
	rmSetAreaElevationType(nativezoneID, cElevTurbulence);
	rmSetAreaElevationVariation(nativezoneID, 5.0);
	rmSetAreaElevationMinFrequency(nativezoneID, 0.04);
	rmSetAreaElevationOctaves(nativezoneID, 3);
	rmSetAreaElevationPersistence(nativezoneID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(nativezoneID, false);
	rmBuildArea(nativezoneID);	

	int avoidnativezone = rmCreateAreaDistanceConstraint("avoid native zone  ", nativezoneID, 20.0);
	int avoidnativezoneShort = rmCreateAreaDistanceConstraint("avoid native zone  short ", nativezoneID, 12.0);
	int avoidnativezoneMin = rmCreateAreaDistanceConstraint("avoid native zone  min ", nativezoneID, 6.0);
	int staynativezone = rmCreateAreaMaxDistanceConstraint("stay in native zone  ", nativezoneID, 0.0);

	// Blackmap 
	int BlackmapID = rmCreateArea("Blackmap");
	rmSetAreaSize(BlackmapID, 0.175, 0.175);
	rmSetAreaLocation(BlackmapID, 0.15, 0.00);
	rmAddAreaInfluenceSegment(BlackmapID, 0.15, 0.00, 0.15, 1.0);	
	rmAddAreaInfluenceSegment(BlackmapID, 0.10, 0.00, 0.10, 1.0);	
	rmAddAreaInfluenceSegment(BlackmapID, 0.05, 0.00, 0.05, 1.0);	
	rmAddAreaInfluenceSegment(BlackmapID, 0.00, 0.00, 0.00, 1.0);	
	rmSetAreaWarnFailure(BlackmapID, false);
	rmSetAreaTerrainType(BlackmapID, "cave\cave_top");			
	rmSetAreaCoherence(BlackmapID, 1.0); 
	rmSetAreaObeyWorldCircleConstraint(BlackmapID, false);
	rmBuildArea(BlackmapID);	

	int avoidBlackmap = rmCreateAreaDistanceConstraint("avoid Blackmap zone  ", BlackmapID, 20.0);
	int avoidBlackmapShort = rmCreateAreaDistanceConstraint("avoid Blackmap zone  short ", BlackmapID, 12.0);
	int avoidBlackmapMin = rmCreateAreaDistanceConstraint("avoid Blackmap zone  min ", BlackmapID, 6.0);


	// Text
	rmSetStatusText("",0.40);

	// ____________________ KOTH ____________________
	//King's "Island"
	if (rmGetIsKOTH() == true) {
		int kingislandID=rmCreateArea("King's Island");
		rmSetAreaSize(kingislandID, 0.008, 0.008);
		rmSetAreaLocation(kingislandID, 0.90, 0.5);
		rmSetAreaMix(kingislandID, "carolina_grass");
		rmAddAreaToClass(kingislandID, classIsland);
		rmSetAreaBaseHeight(kingislandID, 1.0);
		rmSetAreaCoherence(kingislandID, 1.0);
		rmBuildArea(kingislandID); 
	
	// Place King's Hill
		float xLoc = 0.90;
		float yLoc = 0.5;
		float walk = 0.02;
	
		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
		}

		int avoidKOTH = rmCreateAreaDistanceConstraint("avoid KOTH", kingislandID, 24.0);
	
	// ____________________ Natives ____________________

	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
		
	nativeID0 = rmCreateGrouping("Jesuit temple A", "native jesuit mission america 0"+1); //+5
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.25, 0.8);
	
	nativeID2 = rmCreateGrouping("Huron temple B", "native huron village "+2); //+1
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));
	rmPlaceGroupingAtLoc(nativeID2, 0, 0.25, 0.6);
	
	nativeID1 = rmCreateGrouping("Huron temple C", "native huron village "+3);
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
	rmPlaceGroupingAtLoc(nativeID1, 0, 0.25, 0.4);  
	
	nativeID3 = rmCreateGrouping("Jesuit temple D", "native jesuit mission america 0"+2);
    rmSetGroupingMinDistance(nativeID3, 0.00);
    rmSetGroupingMaxDistance(nativeID3, 0.00);
	rmAddGroupingToClass(nativeID3, rmClassID("natives"));
	rmPlaceGroupingAtLoc(nativeID3, 0, 0.25, 0.2); 
	
	// Text
	rmSetStatusText("",0.50);
	
	// ____________________ Starting Resource ____________________

	// Town center & units
	int TCID = rmCreateObjectDef("player TC");
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 6.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);

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
	rmSetObjectDefMaxDistance(TCID, 6.0);
	
	// Starting mines
	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "minetin", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 16.0);
	rmSetObjectDefMaxDistance(playergoldID, 16.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
	rmAddObjectDefConstraint(playergoldID, avoidWater);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "minetin", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 14.0);
	rmSetObjectDefMaxDistance(playergold2ID, 16.0);
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldType);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold2ID, avoidWater);

	//Prepare to place player starting Crates (mostly food)
	int playerCrateID=rmCreateObjectDef("starting crates");
	rmAddObjectDefItem(playerCrateID, "crateOfFood", rmRandInt(3,3), 4.0);
	rmAddObjectDefItem(playerCrateID, "crateOfWood", rmRandInt(1,1), 4.0);
	rmAddObjectDefItem(playerCrateID, "crateOfCoin", rmRandInt(1,1), 4.0);
	rmSetObjectDefMinDistance(playerCrateID, 8);
	rmSetObjectDefMaxDistance(playerCrateID, 12);
	rmAddObjectDefConstraint(playerCrateID, avoidStartingResourcesShort);
	
	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 4, 2.0);
	rmSetObjectDefMinDistance(playerberriesID, 12.0);
	rmSetObjectDefMaxDistance(playerberriesID, 14.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidNatives);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerberriesID, avoidWater);
	
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "TreePlymouth", rmRandInt(5,5), 5.0);
    rmSetObjectDefMinDistance(playerTreeID, 16);
    rmSetObjectDefMaxDistance(playerTreeID, 18);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	rmAddObjectDefConstraint(playerTreeID, avoidGoldMin);
	rmAddObjectDefConstraint(playerTreeID, avoidNatives);
	rmAddObjectDefConstraint(playerTreeID, avoidWater);
			
	// Starting herd
	int playerherdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playerherdID, "Deer", rmRandInt(10,10), 7.0);
	rmSetObjectDefMinDistance(playerherdID, 14.0);
	rmSetObjectDefMaxDistance(playerherdID, 16.0);
	rmSetObjectDefCreateHerd(playerherdID, false);
	rmAddObjectDefToClass(playerherdID, classStartingResource);
	rmAddObjectDefConstraint(playerherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerherdID, avoidNatives);
	rmAddObjectDefConstraint(playerherdID, avoidStartingResources);
	rmAddObjectDefConstraint(playerherdID, avoidWaterShort);
		
	// 2nd herd
	int playerherd2ID = rmCreateObjectDef("2nd herd");
    rmAddObjectDefItem(playerherd2ID, "Turkey", rmRandInt(5,5), 6.0);
    rmSetObjectDefMinDistance(playerherd2ID, 25);
    rmSetObjectDefMaxDistance(playerherd2ID, 27);
	rmAddObjectDefToClass(playerherd2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerherd2ID, true);
	rmAddObjectDefConstraint(playerherd2ID, avoidNatives);
	rmAddObjectDefConstraint(playerherd2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerherd2ID, avoidWater);
	
	// 3nd herd
	int playerherd3ID = rmCreateObjectDef("3nd herd");
    rmAddObjectDefItem(playerherd3ID, "Turkey", rmRandInt(5,5), 5.0);
    rmSetObjectDefMinDistance(playerherd3ID, 33);
    rmSetObjectDefMaxDistance(playerherd3ID, 35);
	rmAddObjectDefToClass(playerherd3ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerherd3ID, true);
	rmAddObjectDefConstraint(playerherd3ID, avoidNatives);
	rmAddObjectDefConstraint(playerherd3ID, avoidStartingResources);

	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1,	0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 24.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 26.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
		
	// Water flag
	int colonyShipID = 0;
	colonyShipID=rmCreateObjectDef("colony ship "+i);
	rmAddObjectDefItem(colonyShipID, "HomeCityWaterSpawnFlag", 1, 0);
	rmSetObjectDefMinDistance(colonyShipID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(colonyShipID, rmXFractionToMeters(0.01));
	rmAddObjectDefConstraint(colonyShipID, avoidColonyShip);
	rmAddObjectDefConstraint(colonyShipID, avoidLand);
	rmAddObjectDefConstraint(colonyShipID, avoidEdge);	
	
	// Place Starting Resources and Objects	
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerCrateID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerherd2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (cNumberNonGaiaPlayers > 4)
			rmPlaceObjectDefAtLoc(playerherd2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
				
		if(ypIsAsian(i) && rmGetNomadStart() == false)
		rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
		rmPlaceObjectDefAtLoc(colonyShipID, i, 0.80, rmPlayerLocZFraction(i));

      		// Pilgrims
      		int pilgrimGroupType = rmRandInt(1,2);
      		int pilgrimGroup = 0;
      		pilgrimGroup = rmCreateGrouping("Pilgrim Group "+i, "Plymouth_PilgrimGroup "+pilgrimGroupType);
      		rmSetGroupingMinDistance(pilgrimGroup, 6.0);
      		rmSetGroupingMaxDistance(pilgrimGroup, 10.0);
      		rmAddGroupingToClass(pilgrimGroup, rmClassID("startingUnit"));
      		rmAddGroupingConstraint(pilgrimGroup, avoidNatives);
      		rmAddGroupingConstraint(pilgrimGroup, avoidStartingUnitsSmall);
      		rmPlaceGroupingAtLoc(pilgrimGroup, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}
	
	// Text
	rmSetStatusText("",0.60);
	
	// ____________________ Common Resources ____________________
	// No mines and trees plz
		int avoidisland1ID = rmCreateArea("avoid island 1");
		rmSetAreaSize(avoidisland1ID, 0.0025, 0.0025);
		rmSetAreaLocation(avoidisland1ID, 0.25, 0.70);
		rmSetAreaWarnFailure(avoidisland1ID, false);
//		rmSetAreaMix(avoidisland1ID, "yellow_river_b");	// for testing
		rmAddAreaToClass(avoidisland1ID, classIsland);
		rmSetAreaCoherence(avoidisland1ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(avoidisland1ID, false);
		rmBuildArea(avoidisland1ID);	
	
		int avoidisland2ID = rmCreateArea("avoid island 2");
		rmSetAreaSize(avoidisland2ID, 0.0025, 0.0025);
		rmSetAreaLocation(avoidisland2ID, 0.25, 0.50);
		rmSetAreaWarnFailure(avoidisland2ID, false);
//		rmSetAreaMix(avoidisland2ID, "yellow_river_b");	// for testing
		rmAddAreaToClass(avoidisland2ID, classIsland);
		rmSetAreaCoherence(avoidisland2ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(avoidisland2ID, false);
		rmBuildArea(avoidisland2ID);	

		int avoidisland3ID = rmCreateArea("avoid island 3");
		rmSetAreaSize(avoidisland3ID, 0.0025, 0.0025);
		rmSetAreaLocation(avoidisland3ID, 0.25, 0.30);
		rmSetAreaWarnFailure(avoidisland3ID, false);
//		rmSetAreaMix(avoidisland3ID, "yellow_river_b");	// for testing
		rmAddAreaToClass(avoidisland3ID, classIsland);
		rmSetAreaCoherence(avoidisland3ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(avoidisland3ID, false);
		rmBuildArea(avoidisland3ID);	
	
		int avoidisland4ID = rmCreateArea("avoid island 4");
		rmSetAreaSize(avoidisland4ID, 0.0025, 0.0025);
		rmSetAreaLocation(avoidisland4ID, 0.60, 0.90);
		rmSetAreaWarnFailure(avoidisland4ID, false);
//		rmSetAreaMix(avoidisland4ID, "yellow_river_b");	// for testing
		rmAddAreaToClass(avoidisland4ID, classIsland);
		rmSetAreaCoherence(avoidisland4ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(avoidisland4ID, false);
		rmBuildArea(avoidisland4ID);	

		int avoidisland5ID = rmCreateArea("avoid island 5");
		rmSetAreaSize(avoidisland5ID, 0.0025, 0.0025);
		rmSetAreaLocation(avoidisland5ID, 0.60, 0.10);
		rmSetAreaWarnFailure(avoidisland5ID, false);
//		rmSetAreaMix(avoidisland5ID, "yellow_river_b");	// for testing
		rmAddAreaToClass(avoidisland5ID, classIsland);
		rmSetAreaCoherence(avoidisland5ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(avoidisland5ID, false);
		rmBuildArea(avoidisland5ID);	
	
		int avoidisland6ID = rmCreateArea("avoid island 6");
		rmSetAreaSize(avoidisland6ID, 0.0025, 0.0025);
		rmSetAreaLocation(avoidisland6ID, 0.30, 0.10);
		rmSetAreaWarnFailure(avoidisland6ID, false);
//		rmSetAreaMix(avoidisland6ID, "yellow_river_b");	// for testing
		rmAddAreaToClass(avoidisland6ID, classIsland);
		rmSetAreaCoherence(avoidisland6ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(avoidisland6ID, false);
		rmBuildArea(avoidisland6ID);	

		int avoidisland7ID = rmCreateArea("avoid island 7");
		rmSetAreaSize(avoidisland7ID, 0.0025, 0.0025);
		rmSetAreaLocation(avoidisland7ID, 0.30, 0.90);
		rmSetAreaWarnFailure(avoidisland7ID, false);
//		rmSetAreaMix(avoidisland7ID, "yellow_river_b");	// for testing
		rmAddAreaToClass(avoidisland7ID, classIsland);
		rmSetAreaCoherence(avoidisland7ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(avoidisland7ID, false);
		rmBuildArea(avoidisland7ID);	

		int avoidisland8ID = rmCreateArea("avoid island 8");
		rmSetAreaSize(avoidisland8ID, 0.0025, 0.0025);
		rmSetAreaLocation(avoidisland8ID, 0.40, 0.50);
		rmSetAreaWarnFailure(avoidisland8ID, false);
//		rmSetAreaMix(avoidisland8ID, "yellow_river_b");	// for testing
		rmAddAreaToClass(avoidisland8ID, classIsland);
		rmSetAreaCoherence(avoidisland8ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(avoidisland8ID, false);
		rmBuildArea(avoidisland8ID);	

		int avoidisland9ID = rmCreateArea("avoid island 9");
		rmSetAreaSize(avoidisland9ID, 0.0025, 0.0025);
		rmSetAreaLocation(avoidisland9ID, 0.50, 0.50);
		rmSetAreaWarnFailure(avoidisland9ID, false);
//		rmSetAreaMix(avoidisland9ID, "yellow_river_b");	// for testing
		rmAddAreaToClass(avoidisland9ID, classIsland);
		rmSetAreaCoherence(avoidisland9ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(avoidisland9ID, false);
		rmBuildArea(avoidisland9ID);	
	
		int avoidisland10ID = rmCreateArea("avoid island 10");
		rmSetAreaSize(avoidisland10ID, 0.0025, 0.0025);
		rmSetAreaLocation(avoidisland10ID, 0.60, 0.60);
		rmSetAreaWarnFailure(avoidisland10ID, false);
//		rmSetAreaMix(avoidisland10ID, "yellow_river_b");	// for testing
		rmAddAreaToClass(avoidisland10ID, classIsland);
		rmSetAreaCoherence(avoidisland10ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(avoidisland10ID, false);
		rmBuildArea(avoidisland10ID);	

		int avoidisland11ID = rmCreateArea("avoid island 11");
		rmSetAreaSize(avoidisland11ID, 0.0025, 0.0025);
		rmSetAreaLocation(avoidisland11ID, 0.60, 0.40);
		rmSetAreaWarnFailure(avoidisland11ID, false);
//		rmSetAreaMix(avoidisland11ID, "yellow_river_b");	// for testing
		rmAddAreaToClass(avoidisland11ID, classIsland);
		rmSetAreaCoherence(avoidisland11ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(avoidisland11ID, false);
		rmBuildArea(avoidisland11ID);	
	
	// Mines 
	int goldcount = 2+2*cNumberNonGaiaPlayers; 

	for(i=0; < goldcount) {
		int goldID = rmCreateObjectDef("gold"+i);
		rmAddObjectDefItem(goldID, "Minetin", 1, 0.0);
		rmSetObjectDefMinDistance(goldID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.48));
		rmAddObjectDefToClass(goldID, classGold);
		rmAddObjectDefConstraint(goldID, avoidNatives);
		rmAddObjectDefConstraint(goldID, avoidGoldTypeFar);
		rmAddObjectDefConstraint(goldID, avoidTownCenterFar);
		rmAddObjectDefConstraint(goldID, avoidWater);
		rmAddObjectDefConstraint(goldID, avoidnativezoneMin);
		rmAddObjectDefConstraint(goldID, avoidberryzoneNW);
		rmAddObjectDefConstraint(goldID, avoidberryzoneSE);
		rmAddObjectDefConstraint(goldID, avoidIslandShort);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(goldID, avoidKOTH);
		rmPlaceObjectDefAtLoc(goldID, 0, 0.50, 0.50);
		}

	// Mines NW
	int gold2count = cNumberNonGaiaPlayers; 

	for(i=0; < gold2count) {
		int gold2ID = rmCreateObjectDef("gold2 "+i);
		rmAddObjectDefItem(gold2ID, "Minetin", 1, 0.0);
		rmSetObjectDefMinDistance(gold2ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(gold2ID, rmXFractionToMeters(0.48));
		rmAddObjectDefToClass(gold2ID, classGold);
		rmAddObjectDefConstraint(gold2ID, avoidNatives);
		rmAddObjectDefConstraint(gold2ID, avoidGoldType);
		rmAddObjectDefConstraint(gold2ID, avoidTownCenter);
		rmAddObjectDefConstraint(gold2ID, avoidWater);
		rmAddObjectDefConstraint(gold2ID, avoidnativezoneMin);
		rmAddObjectDefConstraint(gold2ID, stayberryzoneNW);
		rmAddObjectDefConstraint(gold2ID, avoidIslandShort);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(gold2ID, avoidKOTH);
		rmPlaceObjectDefAtLoc(gold2ID, 0, 0.50, 0.50);
		}

	// Mines SE
	int gold3count = cNumberNonGaiaPlayers; 

	for(i=0; < gold3count) {
		int gold3ID = rmCreateObjectDef("gold3 "+i);
		rmAddObjectDefItem(gold3ID, "Minetin", 1, 0.0);
		rmSetObjectDefMinDistance(gold3ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(gold3ID, rmXFractionToMeters(0.48));
		rmAddObjectDefToClass(gold3ID, classGold);
		rmAddObjectDefConstraint(gold3ID, avoidNatives);
		rmAddObjectDefConstraint(gold3ID, avoidGoldType);
		rmAddObjectDefConstraint(gold3ID, avoidTownCenter);
		rmAddObjectDefConstraint(gold3ID, avoidWater);
		rmAddObjectDefConstraint(gold3ID, avoidnativezoneMin);
		rmAddObjectDefConstraint(gold3ID, stayberryzoneSE);
		rmAddObjectDefConstraint(gold3ID, avoidIslandShort);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(gold3ID, avoidKOTH);
		rmPlaceObjectDefAtLoc(gold3ID, 0, 0.50, 0.50);
		}
		
	// Text
	rmSetStatusText("",0.70);

	// Main forest patches
	int mainforestcount = 12+2*cNumberNonGaiaPlayers;
	int stayInForestPatch = -1;

	for (i=0; < mainforestcount)
    {
        int forestpatchID = rmCreateArea("main forest patch"+i);
        rmSetAreaWarnFailure(forestpatchID, false);
		rmSetAreaObeyWorldCircleConstraint(forestpatchID, false);
        rmSetAreaSize(forestpatchID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(100));
        rmSetAreaTerrainType(forestpatchID, "carolinas\groundforest_car");
        rmSetAreaMinBlobs(forestpatchID, 2);
        rmSetAreaMaxBlobs(forestpatchID, 3);
        rmSetAreaMinBlobDistance(forestpatchID, 10.0);
        rmSetAreaMaxBlobDistance(forestpatchID, 30.0);
        rmSetAreaCoherence(forestpatchID, 0.2);
		rmSetAreaSmoothDistance(forestpatchID, 5);
		rmAddAreaConstraint(forestpatchID, avoidNatives);
		rmAddAreaConstraint(forestpatchID, avoidForestShort);
		rmAddAreaConstraint(forestpatchID, avoidTownCenterMed);
		rmAddAreaConstraint(forestpatchID, avoidGoldTypeMin);
		rmAddAreaConstraint(forestpatchID, avoidWater);
		rmAddAreaConstraint(forestpatchID, avoidBlackmapMin);
		rmAddAreaConstraint(forestpatchID, avoidnativezoneMin);
		rmAddAreaConstraint(forestpatchID, avoidIslandShort);
		if (rmGetIsKOTH() == true)
			rmAddAreaConstraint(forestpatchID, avoidKOTH);
		rmBuildArea(forestpatchID);

		stayInForestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest patch"+i, forestpatchID, 0.0);

		for (j=0; < rmRandInt(7,8))
		{
			int foresttreeID = rmCreateObjectDef("forest trees"+i+j);
			rmAddObjectDefItem(foresttreeID, "TreePlymouth", rmRandInt(1,2), 5.0);
			rmAddObjectDefItem(foresttreeID, "TreeCarolinaGrass", rmRandInt(0,1), 5.0);
			rmSetObjectDefMinDistance(foresttreeID, rmXFractionToMeters(0.00));
			rmSetObjectDefMaxDistance(foresttreeID, rmXFractionToMeters(0.48));
			rmAddObjectDefToClass(foresttreeID, classForest);
			rmAddObjectDefConstraint(foresttreeID, stayInForestPatch);
			rmPlaceObjectDefAtLoc(foresttreeID, 0, 0.50, 0.50);
		}
    }

	// Text
	rmSetStatusText("",0.80);

	// Secondary forest
	int secondforestcount = 20+2*cNumberNonGaiaPlayers;
	int stayIn2ndForest = -1;

	for (i=0; < secondforestcount)
	{
		int secondforestID = rmCreateArea("secondary forest"+i);
		rmSetAreaWarnFailure(secondforestID, false);
		rmSetAreaSize(secondforestID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(100));
		rmSetAreaObeyWorldCircleConstraint(secondforestID, true);
		rmSetAreaTerrainType(secondforestID, "carolinas\groundforest_car");
		rmSetAreaMinBlobs(secondforestID, 2);
		rmSetAreaMaxBlobs(secondforestID, 3);
		rmSetAreaMinBlobDistance(secondforestID, 10.0);
		rmSetAreaMaxBlobDistance(secondforestID, 28.0);
		rmSetAreaCoherence(secondforestID, 0.2);
		rmSetAreaSmoothDistance(secondforestID, 4);
		rmAddAreaConstraint(secondforestID, avoidTownCenterMed);
		rmAddAreaConstraint(secondforestID, avoidForestShort);
		rmAddAreaConstraint(secondforestID, avoidGoldTypeMin);
		rmAddAreaConstraint(secondforestID, avoidNatives);
		rmAddAreaConstraint(secondforestID, avoidWater);
		rmAddAreaConstraint(secondforestID, avoidBlackmapMin);
		rmAddAreaConstraint(secondforestID, avoidnativezoneMin);
		rmAddAreaConstraint(secondforestID, avoidIslandShort);
		if (rmGetIsKOTH() == true)
			rmAddAreaConstraint(secondforestID, avoidKOTH);
		rmBuildArea(secondforestID);

		stayIn2ndForest = rmCreateAreaMaxDistanceConstraint("stay in secondary forest"+i, secondforestID, 0);

		for (j=0; < rmRandInt(5,6))
		{
			int secondforesttreeID = rmCreateObjectDef("secondary forest trees"+i+j);
			rmAddObjectDefItem(secondforesttreeID, "TreePlymouth", rmRandInt(1,2), 5.0);
			rmAddObjectDefItem(secondforesttreeID, "TreeCarolinaGrass", rmRandInt(1,2), 5.0);
			rmSetObjectDefMinDistance(secondforesttreeID, rmXFractionToMeters(0.00));
			rmSetObjectDefMaxDistance(secondforesttreeID, rmXFractionToMeters(0.48));
			rmAddObjectDefToClass(secondforesttreeID, classForest);
			rmAddObjectDefConstraint(secondforesttreeID, stayIn2ndForest);
			rmPlaceObjectDefAtLoc(secondforesttreeID, 0, 0.50, 0.50);
		}
	}

	// Static Herds 
	int staticherdID = rmCreateObjectDef("static herd");
	rmAddObjectDefItem(staticherdID, "Deer", rmRandInt(8,10), 4.0);
	rmSetObjectDefMinDistance(staticherdID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherdID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherdID, true);
	rmPlaceObjectDefAtLoc(staticherdID, 0, 0.25, 0.70);

	int staticherd2ID = rmCreateObjectDef("static herd2");
	rmAddObjectDefItem(staticherd2ID, "Deer", rmRandInt(9,10), 4.0);
	rmSetObjectDefMinDistance(staticherd2ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd2ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd2ID, true);
	rmPlaceObjectDefAtLoc(staticherd2ID, 0, 0.25, 0.50);

	int staticherd3ID = rmCreateObjectDef("static herd3");
	rmAddObjectDefItem(staticherd3ID, "Deer", rmRandInt(8,10), 4.0);
	rmSetObjectDefMinDistance(staticherd3ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd3ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd3ID, true);
	rmPlaceObjectDefAtLoc(staticherd3ID, 0, 0.25, 0.30);
	
	int staticherd4ID = rmCreateObjectDef("static herd4");
	rmAddObjectDefItem(staticherd4ID, "Deer", rmRandInt(9,10), 4.0);
	rmSetObjectDefMinDistance(staticherd4ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd4ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd4ID, true);
	rmPlaceObjectDefAtLoc(staticherd4ID, 0, 0.60, 0.90);

	int staticherd5ID = rmCreateObjectDef("static herd5");
	rmAddObjectDefItem(staticherd5ID, "Deer", rmRandInt(8,10), 4.0);
	rmSetObjectDefMinDistance(staticherd5ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd5ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd5ID, true);
	rmPlaceObjectDefAtLoc(staticherd5ID, 0, 0.60, 0.10);

	int staticherd6ID = rmCreateObjectDef("static herd6");
	rmAddObjectDefItem(staticherd6ID, "Deer", rmRandInt(9,10), 4.0);
	rmSetObjectDefMinDistance(staticherd6ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd6ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd6ID, true);
	rmPlaceObjectDefAtLoc(staticherd6ID, 0, 0.30, 0.10);

	int staticherd7ID = rmCreateObjectDef("static herd7");
	rmAddObjectDefItem(staticherd7ID, "Deer", rmRandInt(8,10), 4.0);
	rmSetObjectDefMinDistance(staticherd7ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd7ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd7ID, true);
	rmPlaceObjectDefAtLoc(staticherd7ID, 0, 0.30, 0.90);

	int staticherd8ID = rmCreateObjectDef("static herd8");
	rmAddObjectDefItem(staticherd8ID, "Deer", rmRandInt(9,10), 4.0);
	rmSetObjectDefMinDistance(staticherd8ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd8ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd8ID, true);
	rmPlaceObjectDefAtLoc(staticherd8ID, 0, 0.40, 0.50);

	int staticherd9ID = rmCreateObjectDef("static herd9");
	rmAddObjectDefItem(staticherd9ID, "Deer", rmRandInt(8,10), 4.0);
	rmSetObjectDefMinDistance(staticherd9ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd9ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd9ID, true);
	rmPlaceObjectDefAtLoc(staticherd9ID, 0, 0.50, 0.50);

	int staticherd10ID = rmCreateObjectDef("static herd10");
	rmAddObjectDefItem(staticherd10ID, "Deer", rmRandInt(9,10), 4.0);
	rmSetObjectDefMinDistance(staticherd10ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd10ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd10ID, true);
	rmPlaceObjectDefAtLoc(staticherd10ID, 0, 0.60, 0.60);

	int staticherd11ID = rmCreateObjectDef("static herd11");
	rmAddObjectDefItem(staticherd11ID, "Deer", rmRandInt(8,10), 4.0);
	rmSetObjectDefMinDistance(staticherd11ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd11ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd11ID, true);
	rmPlaceObjectDefAtLoc(staticherd11ID, 0, 0.60, 0.40);

	if (cNumberNonGaiaPlayers > 2) {
		// Central Herds 
		int herdcount = 2*cNumberNonGaiaPlayers;
		
		for(i=0; < herdcount) {
			int saigaherdID = rmCreateObjectDef("saiga herd"+i);
			rmAddObjectDefItem(saigaherdID, "Deer", rmRandInt(9,10), 4.0);
			rmSetObjectDefMinDistance(saigaherdID, rmXFractionToMeters(0.00));
			rmSetObjectDefMaxDistance(saigaherdID, rmXFractionToMeters(0.50));
			rmSetObjectDefCreateHerd(saigaherdID, true);
			rmAddObjectDefConstraint(saigaherdID, avoidGoldMin);
			rmAddObjectDefConstraint(saigaherdID, avoidForestMin);
			rmAddObjectDefConstraint(saigaherdID, avoidSaigaShort);
			rmAddObjectDefConstraint(saigaherdID, avoidWaterShort);
			if (cNumberTeams == 2)
				rmAddObjectDefConstraint(saigaherdID, stayHuntsZone);
			if (rmGetIsKOTH() == true)
				rmAddObjectDefConstraint(saigaherdID, avoidKOTH);
			rmPlaceObjectDefAtLoc(saigaherdID, 0, 0.50, 0.50);
			}
		}
		
	// Berries 
	int NWberriescount = 2+1*cNumberNonGaiaPlayers/2;
	
	for(i=0; < NWberriescount) {
		int NWberriesID = rmCreateObjectDef("NWberries"+i);
		rmAddObjectDefItem(NWberriesID, "berrybush", rmRandInt(3,4), 3.0);
		rmSetObjectDefMinDistance(NWberriesID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(NWberriesID, rmXFractionToMeters(0.30));
		rmSetObjectDefCreateHerd(NWberriesID, true);
		rmAddObjectDefConstraint(NWberriesID, avoidNatives);
		rmAddObjectDefConstraint(NWberriesID, avoidGoldMin);
		rmAddObjectDefConstraint(NWberriesID, avoidForestMin);
		rmAddObjectDefConstraint(NWberriesID, avoidWater);
		rmAddObjectDefConstraint(NWberriesID, avoidBerries);
		rmAddObjectDefConstraint(NWberriesID, avoidTownCenter);
		rmAddObjectDefConstraint(NWberriesID, avoidSaigaMin);
		rmAddObjectDefConstraint(NWberriesID, stayberryzoneNW);
		rmPlaceObjectDefAtLoc(NWberriesID, 0, 0.50, 0.90);
		}	

	int SEberriescount = 2+1*cNumberNonGaiaPlayers/2;
	
	for(i=0; < SEberriescount) {
		int SEberriesID = rmCreateObjectDef("SEberries"+i);
		rmAddObjectDefItem(SEberriesID, "berrybush", rmRandInt(3,4), 3.0);
		rmSetObjectDefMinDistance(SEberriesID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(SEberriesID, rmXFractionToMeters(0.30));
		rmSetObjectDefCreateHerd(SEberriesID, true);
		rmAddObjectDefConstraint(SEberriesID, avoidNatives);
		rmAddObjectDefConstraint(SEberriesID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(SEberriesID, avoidForestMin);
		rmAddObjectDefConstraint(SEberriesID, avoidWater);
		rmAddObjectDefConstraint(SEberriesID, avoidBerries);
		rmAddObjectDefConstraint(SEberriesID, avoidTownCenter);
		rmAddObjectDefConstraint(SEberriesID, avoidSaigaMin);
		rmAddObjectDefConstraint(SEberriesID, stayberryzoneSE);
		rmPlaceObjectDefAtLoc(SEberriesID, 0, 0.50, 0.10);
		}	

	// Random Trees
	for (i=0; < 10+4*cNumberNonGaiaPlayers)
	{
		int randomtreeID = rmCreateObjectDef("random tree"+i);
		rmAddObjectDefItem(randomtreeID, "TreePlymouth", rmRandInt(1,2), 3.0);
		rmSetObjectDefMinDistance(randomtreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(randomtreeID,  rmXFractionToMeters(1.0));
		rmAddObjectDefToClass(randomtreeID, classForest);
		rmAddObjectDefConstraint(randomtreeID, avoidForestShort);
		rmAddObjectDefConstraint(randomtreeID, avoidNatives);
		rmAddObjectDefConstraint(randomtreeID, avoidGoldTypeMin);
		rmAddObjectDefConstraint(randomtreeID, avoidSaigaMin);
		rmAddObjectDefConstraint(randomtreeID, avoidBerriesMin);
		rmAddObjectDefConstraint(randomtreeID, avoidBlackmapMin);
		rmAddObjectDefConstraint(randomtreeID, avoidTownCenter);
		rmAddObjectDefConstraint(randomtreeID, avoidWater);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(randomtreeID, avoidKOTH);
		rmPlaceObjectDefAtLoc(randomtreeID, 0, 0.50, 0.50);
	}

	// Text
	rmSetStatusText("",0.90);

	// ____________________ Treasures ____________________

	// Treasures 2
		int Nugget2ID = rmCreateObjectDef("Nugget2"); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.48));
		rmSetNuggetDifficulty(2,3);
		rmAddObjectDefConstraint(Nugget2ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget2ID, avoidnativezoneMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidSaigaMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidBerriesMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget2ID, stayHuntsZone);
		rmAddObjectDefConstraint(Nugget2ID, avoidWater);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(Nugget2ID, avoidKOTH);
		
		int nugget2count = 2*cNumberNonGaiaPlayers;
		
		for (i=0; < nugget2count)
		{
			rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
		}

	// Treasures 1
		int NuggetID = rmCreateObjectDef("Nugget"); 
		rmAddObjectDefItem(NuggetID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(NuggetID, 0);
		rmSetObjectDefMaxDistance(NuggetID, rmXFractionToMeters(0.48));
		rmSetNuggetDifficulty(1,2);
		rmAddObjectDefConstraint(NuggetID, avoidNugget);
		rmAddObjectDefConstraint(NuggetID, avoidNatives);
		rmAddObjectDefConstraint(NuggetID, avoidGoldMin);
		rmAddObjectDefConstraint(NuggetID, avoidSaigaMin);
		rmAddObjectDefConstraint(NuggetID, avoidBerriesMin);	
		rmAddObjectDefConstraint(NuggetID, avoidForestMin);	
		rmAddObjectDefConstraint(NuggetID, avoidTownCenter);
		rmAddObjectDefConstraint(NuggetID, avoidWater);
		rmAddObjectDefConstraint(NuggetID, avoidBlackmapMin);
		rmAddObjectDefConstraint(NuggetID, avoidHuntsZoneShort);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(NuggetID, avoidKOTH);
		
		int nuggetcount = 4*cNumberNonGaiaPlayers;
		
		for (i=0; < nuggetcount)
		{
			rmPlaceObjectDefAtLoc(NuggetID, 0, 0.50, 0.50);
		}
		
	// ____________________ Fishes ____________________
	int fishcount = -1;
	fishcount = 10+4*cNumberNonGaiaPlayers;
	int whalecount = 4+cNumberNonGaiaPlayers;
	
	//Whales
	for (i=0; < whalecount)
	{
	int whaleID=rmCreateObjectDef("whale"+i);
	rmAddObjectDefItem(whaleID, "HumpbackWhale", 1, 2.0);
	rmSetObjectDefMinDistance(whaleID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.48));
	rmAddObjectDefConstraint(whaleID, avoidWhale);
	rmAddObjectDefConstraint(whaleID, avoidLandFar);
	rmAddObjectDefConstraint(whaleID, avoidColonyShip);
	if (rmGetIsKOTH() == true)
		rmAddObjectDefConstraint(whaleID, avoidKOTH);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.50, 0.50);
	}
	
	//Fish
	for (i=0; < fishcount)
	{
		int fishID = rmCreateObjectDef("fish"+i);
		rmAddObjectDefItem(fishID, "ypFishTuna", rmRandInt(2,2), 8.0);
	rmSetObjectDefMinDistance(fishID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.50));
		rmAddObjectDefConstraint(fishID, avoidFish);
		rmAddObjectDefConstraint(fishID, avoidLand);
		rmAddObjectDefConstraint(fishID, avoidColonyShip);
		rmAddObjectDefConstraint(fishID, avoidEdge);
	if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(fishID, avoidKOTH);		
		rmPlaceObjectDefAtLoc(fishID, 0, 0.50, 0.50);
	}


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


	// Text
	rmSetStatusText("",1.00);

	
} //END

