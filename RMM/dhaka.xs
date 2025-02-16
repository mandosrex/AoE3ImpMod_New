// vivid's Dhaka (Obs) v2
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
	if (cNumberNonGaiaPlayers >= 4){
		playerTiles = 11000;
	}
	else if (cNumberNonGaiaPlayers >= 6){
		playerTiles = 10000;
	}
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(true);
	
	// Picks a default water height
	rmSetSeaLevel(0.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	rmSetMapElevationParameters(cElevTurbulence, 0.1, 1, 0.0, 0.5); // type, frequency, octaves, persistence, variation 
	
	
	// Picks default terrain and water
	rmSetSeaType("Indochina Coast");
	rmSetBaseTerrainMix("borneo_grass_b"); 
	rmTerrainInitialize("water", 0.0); 
	rmSetMapType("ceylon"); 
	rmSetMapType("grass");
	rmSetMapType("water");
	rmSetMapType("asia");
	rmSetMapType("AIFishingUseful");
	rmSetLightingSet("deccan");

	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	rmDefineClass("classHill");
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
	int classBerry = rmDefineClass ("Berry");
	
	// Text
	rmSetStatusText("",0.20);
	
	// ____________________ Constraints ____________________
	// These are used to have objects and areas avoid each other
   
	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayN = rmCreatePieConstraint("Stay N", 0.70, 0.7,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(40),rmDegreesToRadians(140));
	int stayE = rmCreatePieConstraint("Stay E", 0.70, 0.3,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(320),rmDegreesToRadians(40));
	int stayMiddle = rmCreateBoxConstraint("stay in the middle", 0.40, 0.00, 0.60, 1.00, 0.00);	
	int stayS = rmCreatePieConstraint("Stay S", 0.3, 0.3,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(180),rmDegreesToRadians(360));
	int stayW = rmCreatePieConstraint("Stay W", 0.3, 0.7,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(140),rmDegreesToRadians(220));
	int staySouthHalf = rmCreatePieConstraint("Stay south half", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(180),rmDegreesToRadians(360));
	int stayNorthHalf = rmCreatePieConstraint("Stay north half", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(360),rmDegreesToRadians(180));
	int Wcorner = rmCreatePieConstraint("Stay west corner", 0.00, 1.00,rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int Ncorner = rmCreatePieConstraint("Stay north corner", 1.00, 1.00,rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	
	// Resource avoidance
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 30.0); //15.0
	int avoidForestMed=rmCreateClassDistanceConstraint("avoid forest medium", rmClassID("Forest"), 20.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 12.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidElephantFar = rmCreateTypeDistanceConstraint("avoid elephant far", "ypWildElephant", 45.0);
	int avoidElephant = rmCreateTypeDistanceConstraint("avoid elephant", "ypWildElephant", 40.0);
	int avoidElephantShort = rmCreateTypeDistanceConstraint("avoid elephant short", "ypWildElephant", 35.0);
	int avoidElephantMin = rmCreateTypeDistanceConstraint("avoid elephant min", "ypWildElephant", 5.0);
	int avoidMuskdeerFar = rmCreateTypeDistanceConstraint("avoid muskdeer far", "Peafowl", 54.0);
	int avoidMuskdeer = rmCreateTypeDistanceConstraint("avoid muskdeer ", "Peafowl", 30.0);
	int avoidMuskdeerShort = rmCreateTypeDistanceConstraint("avoid muskdeer short ", "Peafowl", 24.0);
	int avoidMuskdeerMin = rmCreateTypeDistanceConstraint("avoid muskdeer min ", "Peafowl", 8.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 8.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 18.0);
	int avoidGoldTypeMed = rmCreateTypeDistanceConstraint("coin avoids coin med ", "gold", 36.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 50.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 12.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold", rmClassID("Gold"), 30.0);
	int avoidGoldMed = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 42.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 54.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 68.0);
	int avoidBerry = rmCreateClassDistanceConstraint ("avoid berry", rmClassID("Berry"), 25.0);
	int avoidBerryFar = rmCreateClassDistanceConstraint ("avoid berry far", rmClassID("Berry"), 50.0);
	int avoidBerryShort = rmCreateClassDistanceConstraint ("avoid berry short", rmClassID("Berry"), 12.0);
	int avoidBerryMin = rmCreateClassDistanceConstraint ("avoid berry min", rmClassID("Berry"), 6.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 6.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 12.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 40.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 50.0);
	int avoidTownCenterVeryFar = rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 80.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 60.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 44.0);
	int avoidTownCenterMore = rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 48.0);
	int avoidTownCenterMed = rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 40.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 24.0);
	int avoidTownCenterMin = rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 18.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid natives short", rmClassID("natives"), 8.0);
	int avoidNatives = rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 12.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("avoid natives far", rmClassID("natives"), 20.0);
	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 4.0);
	int avoidWhale=rmCreateTypeDistanceConstraint("avoid whale", "HumpbackWhale", 34);
	int avoidWhaleMin=rmCreateTypeDistanceConstraint("avoid whale min", "HumpbackWhale", 4);
	int avoidFish=rmCreateTypeDistanceConstraint("avoid fish", "ypFishTuna", 18.0);
	int avoidYak=rmCreateTypeDistanceConstraint("avoid yak", "ypyak", 32.0);
	int avoidColonyShip = rmCreateTypeDistanceConstraint("avoid colony ship", "HomeCityWaterSpawnFlag", 6.0);
	int avoidKotH = rmCreateTypeDistanceConstraint("avoid KotH", "ypKingsHill", 20.0);

	// Avoid impassable land
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("avoid impassable land min", "Land", false, 1.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("avoid impassable land short", "Land", false, 3.0);
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("avoid impassable land medium", "Land", false, 15.0);
	int avoidImpassableLandFar = rmCreateTerrainDistanceConstraint("avoid impassable land far", "Land", false, 20.0);
	int stayNearLand = rmCreateTerrainMaxDistanceConstraint("stay near land ", "Land", true, 5.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 10.0);
	int avoidLandFar = rmCreateTerrainDistanceConstraint("avoid land far ", "Land", true, 16.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 8.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 15.0);
	int avoidWater2 = rmCreateTerrainDistanceConstraint("avoid water 2", "Land", false, 15.0);
	int avoidWaterFar = rmCreateTerrainDistanceConstraint("avoid water far", "water", true, 30.0);
	int hugWater = rmCreateTerrainMaxDistanceConstraint("hug water 2", "water", true, 15.0);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 24.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 12.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 12.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 5.0);
	
	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);	
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 8.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 20.0);
	int avoidTradeRouteSocketLong = rmCreateTypeDistanceConstraint("avoid trade route socket long", "socketTradeRoute", 40.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route socket short", "socketTradeRoute", 12.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 12.0);
	
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
					rmPlacePlayer(1, 0.65, 0.35);
					rmPlacePlayer(2, 0.35, 0.65);
				}
				else
				{
					rmPlacePlayer(2, 0.65, 0.35);
					rmPlacePlayer(1, 0.35, 0.65);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.65, 0.35, 0.75, 0.40, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.35, 0.65, 0.40, 0.75, 0.00, 0.20);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.50, 0.30, 0.85, 0.45, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.30, 0.50, 0.45, 0.85, 0.00, 0.20);
				}
			}
				else
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.50, 0.30, 0.85, 0.45, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.30, 0.50, 0.45, 0.85, 0.00, 0.20);
				}
		}
		else  //FFA
			{	
			rmPlacePlayer(1, .5, .3);
			rmPlacePlayer(2, .3, .5);
			rmPlacePlayer(3, .7, .2);
			rmPlacePlayer(4, .2, .7);
			rmPlacePlayer(5, .5, .9);
			rmPlacePlayer(6, .9, .5);
			rmPlacePlayer(7, .7, .4);
			rmPlacePlayer(8, .4, .7);
			}

   
	// Text
	rmSetStatusText("",0.30);
	
	// ____________________ Map Parameters ____________________
	// Main Land
	int mainlandID = rmCreateArea("main island");
	rmSetAreaSize(mainlandID, 0.72, 0.72);
	rmSetAreaLocation(mainlandID, 1.00, 1.00);
	rmSetAreaMix(mainlandID, "borneo_grass_b");
	rmSetAreaWarnFailure(mainlandID, false);
	rmSetAreaCoherence(mainlandID, 0.85); 
	rmSetAreaElevationType(mainlandID, cElevTurbulence);
	rmSetAreaElevationVariation(mainlandID, 5.0);
	rmSetAreaBaseHeight(mainlandID, 4.0);
	rmSetAreaElevationMinFrequency(mainlandID, 0.04);
	rmSetAreaElevationOctaves(mainlandID, 3);
	rmSetAreaElevationPersistence(mainlandID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(mainlandID, false);
	rmBuildArea(mainlandID);
	
	int avoidMainLand = rmCreateAreaDistanceConstraint("avoid main land", mainlandID, 25.0);
	int stayInMainLand = rmCreateAreaMaxDistanceConstraint("stay in main land", mainlandID, 0.0);

	// Delta
	int deltaID = rmCreateArea("delta");
	rmSetAreaSize(deltaID, 0.10, 0.10);
	rmSetAreaLocation(deltaID, 0.70, 1.00);
	rmAddAreaInfluenceSegment(deltaID, 0.60, 1.00, 0.60, 0.60);	
	rmAddAreaInfluenceSegment(deltaID, 0.60, 0.60, 1.00, 0.60);	
	rmAddAreaInfluenceSegment(deltaID, 0.60, 1.00, 1.00, 0.60);	
	rmAddAreaInfluenceSegment(deltaID, 0.70, 1.00, 1.00, 0.70);	
	rmAddAreaInfluenceSegment(deltaID, 0.65, 1.00, 1.00, 0.65);	
	rmAddAreaInfluenceSegment(deltaID, 0.65, 0.95, 0.95, 0.65);	
	rmAddAreaInfluenceSegment(deltaID, 0.65, 0.85, 0.85, 0.65);	
	rmAddAreaInfluenceSegment(deltaID, 0.65, 0.75, 0.75, 0.65);	
	rmSetAreaWarnFailure(deltaID, false);
	rmSetAreaCoherence(deltaID, 1.0); 
	rmSetAreaElevationType(deltaID, cElevTurbulence);
	rmSetAreaElevationVariation(deltaID, 5.0);
	rmSetAreaElevationMinFrequency(deltaID, 0.04);
	rmSetAreaElevationOctaves(deltaID, 3);
	rmSetAreaElevationPersistence(deltaID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(deltaID, false);
	rmBuildArea(deltaID);
	
	int avoidDelta = rmCreateAreaDistanceConstraint("avoid delta ", deltaID, 30.0);
	int stayInDelta = rmCreateAreaMaxDistanceConstraint("stay in ", deltaID, 0.0);

	//Sand patches
	for (i=0; < 32)
	{
		int patchID = rmCreateArea("sand patch"+i);
		rmSetAreaWarnFailure(patchID, false);
		rmSetAreaObeyWorldCircleConstraint(patchID, true);
		rmSetAreaSize(patchID, rmAreaTilesToFraction(123), rmAreaTilesToFraction(155));
		rmSetAreaTerrainType(patchID, "borneo\ground_sand3_borneo");
		rmAddAreaToClass(patchID, rmClassID("patch"));
		rmSetAreaMinBlobs(patchID, 1);
		rmSetAreaMaxBlobs(patchID, 5);
		rmSetAreaMinBlobDistance(patchID, 13.0);
		rmSetAreaMaxBlobDistance(patchID, 30.0);
		rmSetAreaCoherence(patchID, 0.0);
		rmAddAreaConstraint(patchID, avoidPatch);
		rmAddAreaConstraint(patchID, avoidDelta);
		rmBuildArea(patchID); 
	}

	for (i=0; < 42)
	{
		int patch2ID = rmCreateArea("second sand patch"+i);
		rmSetAreaWarnFailure(patch2ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch2ID, true);
		rmSetAreaSize(patch2ID, rmAreaTilesToFraction(30), rmAreaTilesToFraction(30));
		rmSetAreaTerrainType(patch2ID, "borneo\ground_grass2_borneo");
		rmAddAreaToClass(patch2ID, rmClassID("patch2"));
		rmSetAreaMinBlobs(patch2ID, 1);
		rmSetAreaMaxBlobs(patch2ID, 5);
		rmSetAreaMinBlobDistance(patch2ID, 13.0);
		rmSetAreaMaxBlobDistance(patch2ID, 30.0);
		rmSetAreaCoherence(patch2ID, 0.0);
		rmAddAreaConstraint(patch2ID, avoidPatch2);
		rmAddAreaConstraint(patch2ID, stayInDelta);
		rmBuildArea(patch2ID); 
	}

	// Gold Zone W
	int GoldZoneWID = rmCreateArea("gold zone SE");
	rmSetAreaSize(GoldZoneWID, 0.10, 0.10);	
	rmSetAreaLocation(GoldZoneWID, 0.20, 0.80);
	rmAddAreaInfluenceSegment(GoldZoneWID, 0.20, 0.80, 0.40, 0.90);	
	if (cNumberNonGaiaPlayers == 2)
		rmAddAreaInfluenceSegment(GoldZoneWID, 0.40, 0.90, 0.45, 0.75);		
	rmSetAreaWarnFailure(GoldZoneWID, false);
//	rmSetAreaMix(GoldZoneWID, "yellow_river_b");	// for testing
	rmSetAreaCoherence(GoldZoneWID, 1.0); 
	rmSetAreaElevationType(GoldZoneWID, cElevTurbulence);
	rmSetAreaElevationVariation(GoldZoneWID, 5.0);
	rmSetAreaElevationMinFrequency(GoldZoneWID, 0.04);
	rmSetAreaElevationOctaves(GoldZoneWID, 3);
	rmSetAreaElevationPersistence(GoldZoneWID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(GoldZoneWID, false);
	rmBuildArea(GoldZoneWID);	

	// Gold Zone E
	int GoldZoneEID = rmCreateArea("gold zone NW");
	rmSetAreaSize(GoldZoneEID, 0.10, 0.10);
	rmSetAreaLocation(GoldZoneEID, 0.80, 0.20);
	rmAddAreaInfluenceSegment(GoldZoneEID, 0.80, 0.20, 0.90, 0.40);	
	if (cNumberNonGaiaPlayers == 2)
		rmAddAreaInfluenceSegment(GoldZoneEID, 0.90, 0.40, 0.75, 0.45);	
	rmSetAreaWarnFailure(GoldZoneEID, false);
//	rmSetAreaMix(GoldZoneEID, "yellow_river_b");	// for testing
	rmSetAreaCoherence(GoldZoneEID, 1.0); 
	rmSetAreaElevationType(GoldZoneEID, cElevTurbulence);
	rmSetAreaElevationVariation(GoldZoneEID, 5.0);
	rmSetAreaElevationMinFrequency(GoldZoneEID, 0.04);
	rmSetAreaElevationOctaves(GoldZoneEID, 3);
	rmSetAreaElevationPersistence(GoldZoneEID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(GoldZoneEID, false);
	rmBuildArea(GoldZoneEID);	

	int avoidGoldZoneE = rmCreateAreaDistanceConstraint("avoid gold zone SE ", GoldZoneEID, 20.0);
	int avoidGoldZoneEShort = rmCreateAreaDistanceConstraint("avoid gold zone SE short ", GoldZoneEID, 12.0);
	int stayGoldZoneE = rmCreateAreaMaxDistanceConstraint("stay in gold zone SE ", GoldZoneEID, 0.0);	
	int avoidGoldZoneW = rmCreateAreaDistanceConstraint("avoid gold zone NW ", GoldZoneWID, 20.0);
	int avoidGoldZoneWShort = rmCreateAreaDistanceConstraint("avoid gold zone NW short ", GoldZoneWID, 12.0);
	int stayGoldZoneW = rmCreateAreaMaxDistanceConstraint("stay in gold zone NW ", GoldZoneWID, 0.0);

	// Players area
	for (i=1; < cNumberPlayers)
	{
	int playerareaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerareaID);
	rmSetAreaSize(playerareaID, 0.05, 0.05);
	rmSetAreaCoherence(playerareaID, 1.0);
	rmSetAreaWarnFailure(playerareaID, false);
	rmSetAreaLocPlayer(playerareaID, i);
	rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
	rmBuildArea(playerareaID);
	rmCreateAreaDistanceConstraint("avoid player area "+i, playerareaID, 3.0);
	rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerareaID, 0.0);
	}
	
	int avoidPlayerArea1 = rmConstraintID("avoid player area 1");
	int avoidPlayerArea2 = rmConstraintID("avoid player area 2");
	int stayInPlayerArea1 = rmConstraintID("stay in player area 1");
	int stayInPlayerArea2 = rmConstraintID("stay in player area 2");
	
	// Text
	rmSetStatusText("",0.40);

	
	//____________________ Rivers ____________________
	int river2ID = rmRiverCreate(-1, "Borneo Water", 5, 5, 6, 6);  
	rmRiverAddWaypoint(river2ID, rmRandFloat (0.59,0.61), rmRandFloat (0.98,1.00));
	rmRiverAddWaypoint(river2ID, rmRandFloat (0.58,0.62), rmRandFloat (0.88,0.92));
	rmRiverAddWaypoint(river2ID, rmRandFloat (0.58,0.62), rmRandFloat (0.78,0.82));
	rmRiverAddWaypoint(river2ID, rmRandFloat (0.58,0.62), rmRandFloat (0.68,0.72));
	rmRiverAddWaypoint(river2ID, rmRandFloat (0.60,0.60), rmRandFloat (0.60,0.60));
	rmRiverSetShallowRadius(river2ID, 5+cNumberNonGaiaPlayers);
	rmRiverAddShallow(river2ID, 0.30);
	rmRiverAddShallow(river2ID, 0.78);
	rmRiverBuild(river2ID);
	
	int river3ID = rmRiverCreate(-1, "Borneo Water", 5, 5, 6, 6);  
	rmRiverAddWaypoint(river3ID, rmRandFloat (0.98,1.00), rmRandFloat (0.59,0.61));
	rmRiverAddWaypoint(river3ID, rmRandFloat (0.88,0.92), rmRandFloat (0.58,0.62));
	rmRiverAddWaypoint(river3ID, rmRandFloat (0.78,0.82), rmRandFloat (0.58,0.62));
	rmRiverAddWaypoint(river3ID, rmRandFloat (0.68,0.72), rmRandFloat (0.58,0.62));
	rmRiverAddWaypoint(river3ID, rmRandFloat (0.53,0.57), rmRandFloat (0.58,0.62));
	rmRiverAddWaypoint(river3ID, rmRandFloat (0.65,0.65), rmRandFloat (0.60,0.60));
	rmRiverSetShallowRadius(river3ID, 5+cNumberNonGaiaPlayers);
	rmRiverAddShallow(river3ID, 0.30);
	rmRiverAddShallow(river3ID, 0.78);
	rmRiverBuild(river3ID);

	int river1ID = rmRiverCreate(-1, "Borneo Water", 5, 5, 8, 8);  
	rmRiverAddWaypoint(river1ID, rmRandFloat (0.60,0.60), rmRandFloat (0.60,0.60));
	rmRiverAddWaypoint(river1ID, rmRandFloat (0.53,0.57), rmRandFloat (0.53,0.57));
	rmRiverAddWaypoint(river1ID, rmRandFloat (0.48,0.52), rmRandFloat (0.48,0.52));
	rmRiverAddWaypoint(river1ID, rmRandFloat (0.43,0.47), rmRandFloat (0.43,0.47));
	rmRiverAddWaypoint(river1ID, rmRandFloat (0.38,0.42), rmRandFloat (0.38,0.42));
	rmRiverAddWaypoint(river1ID, rmRandFloat (0.33,0.37), rmRandFloat (0.33,0.37));
	rmRiverAddWaypoint(river1ID, rmRandFloat (0.29,0.31), rmRandFloat (0.29,0.31));
	rmRiverSetShallowRadius(river1ID, 6+2*cNumberNonGaiaPlayers);
	rmRiverAddShallow(river1ID, 0.00);
	rmRiverAddShallow(river1ID, 0.65);
	rmRiverBuild(river1ID);
	

	// ____________________ KOTH ____________________
	if (rmGetIsKOTH() == true) {
		int randLoc = rmRandInt(1,3);
		float xLoc = 0.65;
		float yLoc = 0.65;
		float walk = 0.01;

		ypKingsHillLandfill(xLoc, yLoc, 0.006, 1.0, "borneo_sand_a", 0);
		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
		}


	// ____________________ Trade Route ____________________
	if (cNumberTeams == 2) {
		int tradeRouteID = rmCreateTradeRoute();
		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
		rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socketID, true);
		rmSetObjectDefMinDistance(socketID, 10.0);
		rmSetObjectDefMaxDistance(socketID, 60.0);
		rmAddObjectDefConstraint(socketID, avoidWaterShort);
		rmAddObjectDefConstraint(socketID, hugWater);
		rmAddObjectDefConstraint(socketID, avoidKotH);
		rmAddObjectDefConstraint(socketID, avoidTradeRouteSocketLong);

		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

		rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.00); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.45, 0.10);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.25, 0.25);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.10, 0.45);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.00, 0.65);
		
		bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "navalasia");
		if(placedTradeRoute == false)
		rmEchoError("Failed to place trade route");
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

		vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.01);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

		if (cNumberNonGaiaPlayers > 4) {
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);	
			}

		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.3);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.7);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

		if (cNumberNonGaiaPlayers > 4) {
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);	
			}

		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.9);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);	
		}
	// Text
	rmSetStatusText("",0.45);
	
	// ____________________ Natives ____________________
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Bhakti");
	subCiv1 = rmGetCivID("Udasi");
	rmSetSubCiv(0, "Bhakti");
	rmSetSubCiv(1, "Udasi");

	// Place Natives
	int nativeID0 = -1;
	int nativeID1 = -1;

		nativeID0 = rmCreateGrouping("Bhakti temple A", "native bhakti village "+1);
		rmAddGroupingToClass(nativeID0, classNative);
		nativeID1 = rmCreateGrouping("Bhakti temple B", "native bhakti village "+1);
		rmAddGroupingToClass(nativeID1, classNative);

			rmPlaceGroupingAtLoc(nativeID0, 0, 0.81, 0.81);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.73, 0.73);

	// Text
	rmSetStatusText("",0.50);
	
	// ____________________ Starting Resources ____________________

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
	rmSetObjectDefMaxDistance(TCID, 5.0);
	
	// Starting mines
	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 16.0);
	rmSetObjectDefMaxDistance(playergoldID, 16.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 16.0); 
	rmSetObjectDefMaxDistance(playergold2ID, 16.0); 
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playergold2ID, avoidGold);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);

	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "ypTreeCeylon", rmRandInt(6,6), 5.0);
    rmSetObjectDefMinDistance(playerTreeID, 14);
    rmSetObjectDefMaxDistance(playerTreeID, 18);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidGoldShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);

	// Starting Berries
    int playerberryID = rmCreateObjectDef("starting berries");
    rmAddObjectDefItem(playerberryID, "BerryBush", 8, 4.0);
    rmSetObjectDefMinDistance(playerberryID, 12.0);
    rmSetObjectDefMaxDistance(playerberryID, 14.0);
	rmAddObjectDefToClass(playerberryID, classStartingResource);
	rmAddObjectDefConstraint(playerberryID, avoidStartingResources);

	// Starting herd
	int playeherdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playeherdID, "ypNilgai", rmRandInt(10,10), 7.0);
	rmSetObjectDefMinDistance(playeherdID, 13.0);
	rmSetObjectDefMaxDistance(playeherdID, 16.0);
	rmSetObjectDefCreateHerd(playeherdID, false);
	rmAddObjectDefToClass(playeherdID, classStartingResource);
	rmAddObjectDefConstraint(playeherdID, avoidStartingResources);
		
	// 2nd herd
	int player2ndherdID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(player2ndherdID, "ypWildElephant", rmRandInt(3,3), 5.0);
    rmSetObjectDefMinDistance(player2ndherdID, 24);
    rmSetObjectDefMaxDistance(player2ndherdID, 26);
	rmAddObjectDefToClass(player2ndherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player2ndherdID, true);
	rmAddObjectDefConstraint(player2ndherdID, avoidStartingResources);
	rmAddObjectDefConstraint(player2ndherdID, avoidWaterShort);
	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 24.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	int nugget0count = rmRandInt (1,2);  
	
	// dansil92's OP water flag code		
	float flagX = 0.0;
	float flagY = 0.0;
	float tempStoreX = 0.0;
	float averageBoi = 0.0;
	float flagValue = 0.0;
	
	for(i=1; < cNumberNonGaiaPlayers + 1) {
		flagValue = rmPlayerLocXFraction(i)-rmPlayerLocZFraction(i);
		tempStoreX = flagValue/2;
		flagX = 0.25+tempStoreX;
		flagY = 0.25-tempStoreX;
		
		int waterFlag = rmCreateObjectDef("HC water flag "+i);
			rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 0.0);
			rmSetObjectDefMinDistance(waterFlag, 0);
			rmSetObjectDefMaxDistance(waterFlag, 10);
			rmPlaceObjectDefAtLoc(waterFlag, i, flagX, flagY);
		}

	// Place Starting Objects	
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if (rmGetPlayerCiv(i) == rmGetCivID("Japanese") == false)
			rmPlaceObjectDefAtLoc(playerberryID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		rmPlaceObjectDefAtLoc(playeherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(player2ndherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if (nugget0count == 2)
			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
				
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}
	
	// Text
	rmSetStatusText("",0.60);
	
	// ____________________ Common Resources ____________________
	// Static Mines 
	int staticgold1ID = rmCreateObjectDef("staticgold1");
		rmAddObjectDefItem(staticgold1ID, "Minegold", 1, 2.0);
		rmSetObjectDefMinDistance(staticgold1ID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(staticgold1ID, rmXFractionToMeters(0.0));
		rmAddObjectDefToClass(staticgold1ID, classGold);
		rmAddObjectDefConstraint(staticgold1ID, avoidEdge);
		rmPlaceObjectDefAtLoc(staticgold1ID, 0, 0.9, 0.7);

	int staticgold2ID = rmCreateObjectDef("staticgold2");
		rmAddObjectDefItem(staticgold2ID, "Minegold", 1, 2.0);
		rmSetObjectDefMinDistance(staticgold2ID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(staticgold2ID, rmXFractionToMeters(0.0));
		rmAddObjectDefToClass(staticgold2ID, classGold);
		rmAddObjectDefConstraint(staticgold2ID, avoidEdge);
		rmPlaceObjectDefAtLoc(staticgold2ID, 0, 0.7, 0.9);

	// Common Mines 
	int goldcount = 1+cNumberNonGaiaPlayers; 

	for(i=0; < goldcount)
	{
		int goldID = rmCreateObjectDef("gold"+i);
		rmAddObjectDefItem(goldID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(goldID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.30));
		rmAddObjectDefToClass(goldID, classGold);
		rmAddObjectDefConstraint(goldID, avoidDelta);
		if (cNumberNonGaiaPlayers ==2)
			rmAddObjectDefConstraint(goldID, avoidGoldTypeMed);
		else
			rmAddObjectDefConstraint(goldID, avoidGold);
		rmAddObjectDefConstraint(goldID, avoidTownCenter);
		rmAddObjectDefConstraint(goldID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(goldID, avoidEdge);
		rmAddObjectDefConstraint(goldID, avoidWater);
		rmAddObjectDefConstraint(goldID, avoidCenter);
		rmAddObjectDefConstraint(goldID, stayGoldZoneE);
		rmPlaceObjectDefAtLoc(goldID, 0, 0.80, 0.20);
	}

	int gold2count = 1+cNumberNonGaiaPlayers; 

	for(i=0; < gold2count)
	{
		int gold2ID = rmCreateObjectDef("gold2 "+i);
		rmAddObjectDefItem(gold2ID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(gold2ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(gold2ID, rmXFractionToMeters(0.30));
		rmAddObjectDefToClass(gold2ID, classGold);
		rmAddObjectDefConstraint(gold2ID, avoidDelta);
		if (cNumberNonGaiaPlayers ==2)
			rmAddObjectDefConstraint(gold2ID, avoidGoldTypeMed);
		else
			rmAddObjectDefConstraint(gold2ID, avoidGold);		
		rmAddObjectDefConstraint(gold2ID, avoidTownCenter);
		rmAddObjectDefConstraint(gold2ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(gold2ID, avoidEdge);
		rmAddObjectDefConstraint(gold2ID, avoidWater);
		rmAddObjectDefConstraint(gold2ID, avoidCenter);
		rmAddObjectDefConstraint(gold2ID, stayGoldZoneW);
		rmPlaceObjectDefAtLoc(gold2ID, 0, 0.20, 0.80);
	}

	// Text
	rmSetStatusText("",0.70);
	
	// Main forest patches
	int mainforestcount = 10+1*cNumberNonGaiaPlayers;
	int stayInForestPatch = -1;
	int treeWater = rmCreateTerrainDistanceConstraint("trees avoid river", "Land", false, 6.0);

	for (i=0; < mainforestcount)
    {
        int forestpatchID = rmCreateArea("main forest patch"+i);
        rmSetAreaWarnFailure(forestpatchID, false);
		rmSetAreaObeyWorldCircleConstraint(forestpatchID, false);
        rmSetAreaSize(forestpatchID, rmAreaTilesToFraction(90), rmAreaTilesToFraction(70));
		rmSetAreaTerrainType(forestpatchID, "borneo\ground_forest_borneo");
        rmSetAreaMinBlobs(forestpatchID, 2);
        rmSetAreaMaxBlobs(forestpatchID, 3);
        rmSetAreaMinBlobDistance(forestpatchID, 10.0);
        rmSetAreaMaxBlobDistance(forestpatchID, 30.0);
        rmSetAreaCoherence(forestpatchID, 0.2);
		rmSetAreaSmoothDistance(forestpatchID, 5);
		rmAddAreaConstraint(forestpatchID, avoidTradeRouteSocket);
		rmAddAreaConstraint(forestpatchID, avoidForestMed);
		rmAddAreaConstraint(forestpatchID, avoidWater);
		rmAddAreaConstraint(forestpatchID, avoidTownCenterMed);
		rmAddAreaConstraint(forestpatchID, avoidGoldType);
		rmAddAreaConstraint(forestpatchID, avoidDelta);
		rmAddAreaConstraint(forestpatchID, stayInMainLand);        
		rmAddAreaConstraint(forestpatchID, treeWater);        
		rmBuildArea(forestpatchID);

		stayInForestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest patch"+i, forestpatchID, 0.0);

		for (j=0; < rmRandInt(8,9))
		{
			int foresttreeID = rmCreateObjectDef("forest trees"+i+j);
			rmAddObjectDefItem(foresttreeID, "ypTreeCeylon", rmRandInt(2,3), 8.0);
			rmAddObjectDefItem(foresttreeID, "ypTreeBorneoPalm", rmRandInt(0,1), 8.0);
			rmSetObjectDefMinDistance(foresttreeID, rmXFractionToMeters(0.05));
			rmSetObjectDefMaxDistance(foresttreeID, rmXFractionToMeters(0.50));
			rmAddObjectDefToClass(foresttreeID, classForest);
			rmAddObjectDefConstraint(foresttreeID, stayInForestPatch);
			rmPlaceObjectDefAtLoc(foresttreeID, 0, 0.50, 0.50);
		}
    }

	// Text
	rmSetStatusText("",0.80);
	
	// Secondary forest
	int secondforestcount = 8+1*cNumberNonGaiaPlayers;
	int stayIn2ndForest = -1;

	for (i=0; < secondforestcount)
	{
		int secondforestID = rmCreateArea("secondary forest"+i);
		rmSetAreaWarnFailure(secondforestID, false);
		rmSetAreaSize(secondforestID, rmAreaTilesToFraction(90), rmAreaTilesToFraction(70));
		rmSetAreaObeyWorldCircleConstraint(secondforestID, true);
		rmSetAreaTerrainType(secondforestID, "borneo\ground_forest_borneo");
		rmSetAreaMinBlobs(secondforestID, 2);
		rmSetAreaMaxBlobs(secondforestID, 3);
		rmSetAreaMinBlobDistance(secondforestID, 10.0);
		rmSetAreaMaxBlobDistance(secondforestID, 28.0);
		rmSetAreaCoherence(secondforestID, 0.2);
		rmSetAreaSmoothDistance(secondforestID, 4);
		rmAddAreaConstraint(secondforestID, avoidTownCenterMed);
		rmAddAreaConstraint(secondforestID, avoidForestMed);
		rmAddAreaConstraint(secondforestID, avoidGoldType);
		rmAddAreaConstraint(secondforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(secondforestID, avoidDelta);
		rmAddAreaConstraint(secondforestID, stayInMainLand);
		rmAddAreaConstraint(secondforestID, avoidWater);
		rmAddAreaConstraint(secondforestID, treeWater);
		rmBuildArea(secondforestID);

		stayIn2ndForest = rmCreateAreaMaxDistanceConstraint("stay in secondary forest"+i, secondforestID, 0);

		for (j=0; < rmRandInt(8,9))
		{
			int secondforesttreeID = rmCreateObjectDef("secondary forest trees"+i+j);
			rmAddObjectDefItem(secondforesttreeID, "ypTreeBorneoPalm", rmRandInt(1,2), 6.0);	 
			rmSetObjectDefMinDistance(secondforesttreeID, rmXFractionToMeters(0.05));
			rmSetObjectDefMaxDistance(secondforesttreeID, rmXFractionToMeters(0.50));
			rmAddObjectDefToClass(secondforesttreeID, classForest);
			rmAddObjectDefConstraint(secondforesttreeID, stayIn2ndForest);
			rmPlaceObjectDefAtLoc(secondforesttreeID, 0, 0.50, 0.50);
		}
	}

	// Hunts 
	int herdcount = 2+cNumberNonGaiaPlayers;
	
	for(i=0; < herdcount)
	{
		int commonhuntID = rmCreateObjectDef("common herd"+i);
		rmAddObjectDefItem(commonhuntID, "Peafowl", rmRandInt(7,8), 6.0);
		rmSetObjectDefMinDistance(commonhuntID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(commonhuntID, rmXFractionToMeters(0.28));
		rmSetObjectDefCreateHerd(commonhuntID, true);
		rmAddObjectDefConstraint(commonhuntID, avoidDelta);
		rmAddObjectDefConstraint(commonhuntID, avoidGoldShort);
		rmAddObjectDefConstraint(commonhuntID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(commonhuntID, avoidForestShort);
		rmAddObjectDefConstraint(commonhuntID, avoidTownCenter);
		rmAddObjectDefConstraint(commonhuntID, avoidMuskdeerShort);
		rmAddObjectDefConstraint(commonhuntID, avoidWaterShort);
		rmAddObjectDefConstraint(commonhuntID, avoidEdge);
		rmAddObjectDefConstraint(commonhuntID, treeWater);
		rmAddObjectDefConstraint(commonhuntID, stayGoldZoneW);
		rmPlaceObjectDefAtLoc(commonhuntID, 0, 0.20, 0.80);
	}

	int herd2count = 2+cNumberNonGaiaPlayers;
	
	for(i=0; < herd2count)
	{
		int commonhunt2ID = rmCreateObjectDef("common herd2 "+i);
		rmAddObjectDefItem(commonhunt2ID, "Peafowl", rmRandInt(7,8), 6.0);
		rmSetObjectDefMinDistance(commonhunt2ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(commonhunt2ID, rmXFractionToMeters(0.28));
		rmSetObjectDefCreateHerd(commonhunt2ID, true);
		rmAddObjectDefConstraint(commonhunt2ID, avoidDelta);
		rmAddObjectDefConstraint(commonhunt2ID, avoidGoldShort);
		rmAddObjectDefConstraint(commonhunt2ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(commonhunt2ID, avoidForestShort);
		rmAddObjectDefConstraint(commonhunt2ID, avoidTownCenter);
		rmAddObjectDefConstraint(commonhunt2ID, avoidMuskdeerShort);
		rmAddObjectDefConstraint(commonhunt2ID, avoidWaterShort);
		rmAddObjectDefConstraint(commonhunt2ID, avoidEdge);
		rmAddObjectDefConstraint(commonhunt2ID, treeWater);
		rmAddObjectDefConstraint(commonhunt2ID, stayGoldZoneE);
		rmPlaceObjectDefAtLoc(commonhunt2ID, 0, 0.80, 0.20);
	}

	// Berries 
	int berrybushcount = 4+1*cNumberNonGaiaPlayers;
	int berryWater = rmCreateTerrainDistanceConstraint("berries avoid river", "Land", false, 2.0);
	
	for (i=0; < berrybushcount)
	{
		int berrybushID = rmCreateObjectDef("berry bushes"+i);
		rmAddObjectDefItem(berrybushID, "BerryBush", rmRandInt(5,7), 4.0);
		rmSetObjectDefMinDistance(berrybushID, 0.00);
		rmSetObjectDefMaxDistance(berrybushID, rmXFractionToMeters(0.30));
		rmAddObjectDefToClass(berrybushID, classBerry);
		rmAddObjectDefConstraint(berrybushID, avoidGoldShort);
		rmAddObjectDefConstraint(berrybushID, avoidEdge); 
		rmAddObjectDefConstraint(berrybushID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(berrybushID, avoidBerry);
		rmAddObjectDefConstraint(berrybushID, avoidNativesShort);
		rmAddObjectDefConstraint(berrybushID, stayInDelta);
		rmAddObjectDefConstraint(berrybushID, berryWater);
		rmPlaceObjectDefAtLoc(berrybushID, 0, 0.80, 0.80);	
	}

	// Text
	rmSetStatusText("",0.90);

	// Random Trees
	for (i=0; < 6+1*cNumberNonGaiaPlayers)
	{
		int randomtreeID = rmCreateObjectDef("random tree"+i);
		rmAddObjectDefItem(randomtreeID, "ypTreeBorneoPalm", rmRandInt(4,5), 3.0);
		rmSetObjectDefMinDistance(randomtreeID,  rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(randomtreeID,  rmXFractionToMeters(0.30));
		rmAddObjectDefToClass(randomtreeID, classForest);
		rmAddObjectDefConstraint(randomtreeID, avoidForestShort);
		rmAddObjectDefConstraint(randomtreeID, avoidNativesShort);
		rmAddObjectDefConstraint(randomtreeID, avoidGoldMin);
		rmAddObjectDefConstraint(randomtreeID, avoidBerryMin);
		rmAddObjectDefConstraint(randomtreeID, avoidEdge);
		rmAddObjectDefConstraint(randomtreeID, stayInDelta);
		rmAddObjectDefConstraint(randomtreeID, berryWater);
		rmPlaceObjectDefAtLoc(randomtreeID, 0, 0.70, 0.70);
	}

	// Treasures 
	int treasure1count = 4+1*cNumberNonGaiaPlayers;
	int treasure2count = 2+1*cNumberNonGaiaPlayers;
	int treasure3count = 1*cNumberNonGaiaPlayers/2;
	int treasure4count = 1*cNumberNonGaiaPlayers/2;
	
	if (cNumberNonGaiaPlayers > 2) {
		// 	Treasures L3
		for (i=0; < treasure3count) {
			int Nugget3ID = rmCreateObjectDef("nugget L3 "+i); 
			rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
			rmSetObjectDefMinDistance(Nugget3ID, 0);
			rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.48));
			rmSetNuggetDifficulty(3,3);
			rmAddObjectDefConstraint(Nugget3ID, avoidNuggetShort);
			rmAddObjectDefConstraint(Nugget3ID, avoidNativesShort);
			rmAddObjectDefConstraint(Nugget3ID, avoidGoldMin);
			rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
			rmAddObjectDefConstraint(Nugget3ID, avoidEdge);
			rmAddObjectDefConstraint(Nugget3ID, stayInDelta);
			rmAddObjectDefConstraint(Nugget3ID, avoidBerryMin);
			rmAddObjectDefConstraint(Nugget3ID, berryWater);
			rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50);
			}
		}
	// Treasures L2	
	for (i=0; < treasure2count)
	{
		int Nugget2ID = rmCreateObjectDef("nugget L2 "+i); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.48));
		rmSetNuggetDifficulty(2,2);
		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget2ID, avoidMuskdeerMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget2ID, avoidDelta);
		rmAddObjectDefConstraint(Nugget2ID, avoidWater);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}
	
	// Treasures L1
	for (i=0; < treasure1count)
	{
		int Nugget1ID = rmCreateObjectDef("nugget L1 "+i); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, 0);
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.48));
		rmSetNuggetDifficulty(1,1);
		rmAddObjectDefConstraint(Nugget1ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget1ID, avoidNativesShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget1ID, avoidMuskdeerMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge);
		rmAddObjectDefConstraint(Nugget1ID, avoidDelta);
		rmAddObjectDefConstraint(Nugget1ID, avoidWater);
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);
	}

	int deltatreasurecount = 1*cNumberNonGaiaPlayers;

	// Treasures Delta L1
	for (i=0; < deltatreasurecount)
	{
		int DeltaNuggetID = rmCreateObjectDef("nugget delta L1 "+i); 
		rmAddObjectDefItem(DeltaNuggetID, "Nugget", 1, 0.00);
		rmSetObjectDefMinDistance(DeltaNuggetID, 0);
		rmSetObjectDefMaxDistance(DeltaNuggetID, rmXFractionToMeters(0.48));
		rmSetNuggetDifficulty(4,4);
		rmAddObjectDefConstraint(DeltaNuggetID, avoidNuggetShort);
		rmAddObjectDefConstraint(DeltaNuggetID, avoidNativesShort);
		rmAddObjectDefConstraint(DeltaNuggetID, avoidGoldMin);
		rmAddObjectDefConstraint(DeltaNuggetID, avoidForestMin);	
		rmAddObjectDefConstraint(DeltaNuggetID, avoidEdge);
		rmAddObjectDefConstraint(DeltaNuggetID, avoidBerryMin);
		rmAddObjectDefConstraint(DeltaNuggetID, stayInDelta);
		rmPlaceObjectDefAtLoc(DeltaNuggetID, 0, 0.50, 0.50);
	}
	
	// Text
	rmSetStatusText("",0.95);
	
	// Yaks 
	int yaksCount = 4+1*cNumberNonGaiaPlayers;
	
	for (i=0; < yaksCount)
	{
		int yakID=rmCreateObjectDef("yak"+i);
		rmAddObjectDefItem(yakID, "ypyak", 1, 1.0);
		rmSetObjectDefMinDistance(yakID, 0.0);
		rmSetObjectDefMaxDistance(yakID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(yakID, avoidYak);
		rmAddObjectDefConstraint(yakID, avoidBerryShort);
		rmAddObjectDefConstraint(yakID, avoidNativesShort);
		rmAddObjectDefConstraint(yakID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(yakID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(yakID, avoidGoldMin);
		rmAddObjectDefConstraint(yakID, stayInDelta);
		rmAddObjectDefConstraint(yakID, avoidForestMin);
		rmAddObjectDefConstraint(yakID, avoidNuggetShort);
		rmAddObjectDefConstraint(yakID, avoidEdge); 
		rmPlaceObjectDefAtLoc(yakID, 0, 0.50, 0.50);
	}
	
	// Sea Resources 
	int fishcount = -1;
	fishcount = 12+2*cNumberNonGaiaPlayers;
	int whalecount = 4+1*cNumberNonGaiaPlayers;
	
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
	rmAddObjectDefConstraint(whaleID, avoidEdge);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.20, 0.20);
	}
	
	//Fish
	for (i=0; < fishcount)
	{
		int fishID = rmCreateObjectDef("fish"+i);
		rmAddObjectDefItem(fishID, "ypFishTuna", rmRandInt(2,2), 4.0);
		rmSetObjectDefMinDistance(fishID, 0.0);
		rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.50));
		rmAddObjectDefConstraint(fishID, avoidFish);
		rmAddObjectDefConstraint(fishID, avoidWhaleMin);
		rmAddObjectDefConstraint(fishID, avoidLand);
		rmAddObjectDefConstraint(fishID, avoidColonyShip);
		rmAddObjectDefConstraint(fishID, avoidEdge);
		rmAddObjectDefConstraint(fishID, avoidTradeRouteShort);
		rmPlaceObjectDefAtLoc(fishID, 0, 0.20, 0.20);
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
	rmSetStatusText("", 1.00);

	
} //END