// ESOC BAJA CALIFORNIA (1v1, TEAM, FFA)
// designed by Garja

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void){
	
	if (false) {
		sqrt(1);
	}


	// Text
	// These status text lines are used to manually animate the map generation progress bar
	rmSetStatusText("",0.01);

	// ************************************** GENERAL FEATURES *****************************************


	// Picks the map size
	int	playerTiles = 13000;
	if (cNumberNonGaiaPlayers > 2)
		playerTiles = 12000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles = 11000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles = 10000;
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); //2.1
	int longside = 1.55*size;
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(longside, size);

	// Make the corners.
	rmSetWorldCircleConstraint(true);

	// Picks a default water height
	rmSetSeaLevel(0.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

//	rmSetMapElevationParameters(cElevTurbulence, 0.4, 4, 0.4, 4.0);
	rmSetMapElevationParameters(cElevTurbulence, 0.06, 4, 0.4, 3.0);  // type, frequency, octaves, persistence, variation
//	rmSetMapElevationHeightBlend(0.3); //

	// Picks default terrain and water
	rmSetSeaType("california coast2"); // california coast
	rmSetBaseTerrainMix("california_desert1");
	rmTerrainInitialize("california\desert5_cal", 3.5);
//	rmTerrainInitialize("water"); //
	rmSetMapType("california");
	rmSetMapType("desert");
	rmSetMapType("grass");
	rmSetMapType("water");
	rmSetMapType("namerica");
	rmSetMapType("AIFishingUseful");
	rmSetLightingSet("sonora");
	rmSetWindMagnitude(2.0);

	// Choose Mercs
	chooseMercs();

	// Text
	rmSetStatusText("",0.10);

	// Set up Natives
	int subCiv0 = -1;
	subCiv0 = rmGetCivID("Apache");
	rmSetSubCiv(0, "Apache");
	int subCiv1 = -1;
	subCiv1 = rmGetCivID("Navajo");
	rmSetSubCiv(1, "Navajo");
	int subCiv2 = -1;
	subCiv2 = rmGetCivID("Maya");
	rmSetSubCiv(2, "Maya");

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
	int classCliff = rmDefineClass("cliffs");
	int classPasses = rmDefineClass("passes");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");

	// ******************************************************************************************

	// Text
	rmSetStatusText("",0.20);

	// ************************************* CONTRAINTS *****************************************

	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.38), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.26), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.50,0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayWestHalf = rmCreatePieConstraint("Stay West half",0.45,0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(180),rmDegreesToRadians(360));
	int stayEastHalf = rmCreatePieConstraint("Stay East half",0.55,0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(0),rmDegreesToRadians(180));


	// Resource avoidance
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 26.0); //15.0
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 22.0+cNumberNonGaiaPlayers); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 17.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 3.0);
	int avoidPronghornFar = rmCreateTypeDistanceConstraint("avoid pronghorn far", "pronghorn", 50.0);
	int avoidPronghorn = rmCreateTypeDistanceConstraint("avoid pronghorn", "pronghorn", 36.0);
	int avoidPronghornShort = rmCreateTypeDistanceConstraint("avoid pronghorn short", "pronghorn", 25.0);
	int avoidPronghornMin = rmCreateTypeDistanceConstraint("avoid pronghorn min", "pronghorn", 5.0);
	int avoidBighornFar = rmCreateTypeDistanceConstraint("avoid bighorn far", "bighornsheep", 52.0);
	int avoidBighorn = rmCreateTypeDistanceConstraint("avoid  bighorn", "bighornsheep", 46.0);
	int avoidBighornShort = rmCreateTypeDistanceConstraint("avoid  bighorn short", "bighornsheep", 30.0);
	int avoidBighornMin = rmCreateTypeDistanceConstraint("avoid bighorn min", "bighornsheep", 5.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 6.0);
	int avoidGoldTypeMed = rmCreateTypeDistanceConstraint("coin avoids coin med", "gold", 10.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 45.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far", "gold", 58.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 20.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 30.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 50.0); // 82
//	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very ", rmClassID("Gold"), 74.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 44.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 50.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 64.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 54.0);
	int avoidTownCenterMed=rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 58.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 26.0);
	int avoidTownCenterMin=rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 18.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint("resources avoid Town Center", "townCenter", 46.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid natives short", rmClassID("natives"), 3.0);
	int avoidNatives = rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 7.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("avoid natives far", rmClassID("natives"), 12.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 4.0);
	int avoidWhale=rmCreateTypeDistanceConstraint("avoid whale", "fish", 35.0-cNumberNonGaiaPlayers/2);
	int avoidFish=rmCreateTypeDistanceConstraint("avoid fish", "fish", 16.0);
	int avoidSheep=rmCreateTypeDistanceConstraint("sheep avoids sheep", "sheep", 61.0);
	int avoidColonyShip=rmCreateTypeDistanceConstraint("avoid colony ship", "HomeCityWaterSpawnFlag", 30.0);
	int avoidColonyShipShort = rmCreateTypeDistanceConstraint("avoid colony ship short", "HomeCityWaterSpawnFlag", 16.0);

	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 12.0);
	int avoidImpassableLandFar = rmCreateTerrainDistanceConstraint("avoid impassable land far", "Land", false, 22.0);
	int avoidImpassableLandMed = rmCreateTerrainDistanceConstraint("avoid impassable land med", "Land", false, 16.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("avoid impassable land short", "Land", false, 6.0);
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("avoid impassable land min", "Land", false, 2.0);
	int stayNearLand = rmCreateTerrainMaxDistanceConstraint("stay near land ", "Land", true, 5.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 10.0+1*cNumberNonGaiaPlayers);
	int avoidLandFar = rmCreateTerrainDistanceConstraint("avoid land far ", "Land", true, 16.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 20.0);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 2.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 3.0);
	int avoidWaterFar = rmCreateTerrainDistanceConstraint("avoid water far", "water", true, 35.0);
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 30.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 10.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 5.0);
	int avoidPond = rmCreateClassDistanceConstraint("avoid pond", rmClassID("pond"), 40.0);
	int avoidRock = rmCreateClassDistanceConstraint("rock avoids rock", rmClassID("rocks"), 10.0);
	int avoidRockFar = rmCreateClassDistanceConstraint("rock avoids rock far", rmClassID("rocks"), 25.0);
	int avoidGrass = rmCreateClassDistanceConstraint("grass avoid grass", rmClassID("grass"), 40.0);
	int avoidGrassShort = rmCreateClassDistanceConstraint("grass avoid grass short", rmClassID("grass"), 5.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", rmClassID("cliffs"), 2.0);
	int avoidPass = rmCreateClassDistanceConstraint("avoid pass", rmClassID("passes"), 16.0);


	// VP avoidance
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", (8.0+cNumberNonGaiaPlayers));
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 7.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 5.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 12.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route socket short", "socketTradeRoute", 3.0);


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
					rmPlacePlayer(1, 0.32, 0.83);
					rmPlacePlayer(2, 0.68, 0.17);
				}
				else
				{
					rmPlacePlayer(2, 0.32, 0.83);
					rmPlacePlayer(1, 0.68, 0.17);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.36, 0.88, 0.22, 0.45, 0.00, 0.25);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.64, 0.12, 0.78, 0.55, 0.00, 0.25);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.36, 0.88, 0.20, 0.45, 0.00, 0.25);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.80, 0.55, 0.64, 0.12, 0.00, 0.25);
				}
			}
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.32, 0.83, 0.31, 0.82, 0.00, 0.20);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmPlacePlayersLine(0.64, 0.12, 0.78, 0.55, 0.00, 0.25);
						else
							rmPlacePlayersLine(0.80, 0.55, 0.64, 0.12, 0.00, 0.25);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.68, 0.17, 0.69, 0.18, 0.00, 0.20);

						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmPlacePlayersLine(0.36, 0.88, 0.22, 0.45, 0.00, 0.25);
						else
							rmPlacePlayersLine(0.36, 0.88, 0.20, 0.45, 0.00, 0.25);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.36, 0.88, 0.22, 0.45, 0.00, 0.25);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.80, 0.55, 0.64, 0.12, 0.00, 0.25);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.36, 0.88, 0.20, 0.45, 0.00, 0.25);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.64, 0.12, 0.78, 0.55, 0.00, 0.25);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.25, 0.60, 0.35, 0.90, 0.00, 0.25);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.80, 0.55, 0.64, 0.12, 0.00, 0.25);
				}
			}
		}
		else // FFA
		{
			if (cNumberNonGaiaPlayers <= 4)
			{
				rmPlacePlayer(1, 0.32, 0.83);
				rmPlacePlayer(2, 0.68, 0.17);
				rmPlacePlayer(3, 0.72, 0.82);
				rmPlacePlayer(4, 0.28, 0.18);
			}
			else if (cNumberNonGaiaPlayers <= 6)
			{
			rmPlacePlayer(1, 0.34, 0.84);
			rmPlacePlayer(2, 0.66, 0.16);
			rmPlacePlayer(3, 0.74, 0.86);
			rmPlacePlayer(4, 0.26, 0.14);
			rmPlacePlayer(5, 0.76, 0.54);
			rmPlacePlayer(6, 0.24, 0.46);
			}
			else
			{
			rmPlacePlayer(1, 0.20, 0.80);
			rmPlacePlayer(2, 0.80, 0.20);
			rmPlacePlayer(3, 0.74, 0.88);
			rmPlacePlayer(4, 0.26, 0.12);
			rmPlacePlayer(5, 0.82, 0.58);
			rmPlacePlayer(6, 0.18, 0.42);
			rmPlacePlayer(7, 0.38, 0.88);
			rmPlacePlayer(8, 0.62, 0.12);
			}
		}


	// **************************************************************************************************

	// Text
	rmSetStatusText("",0.30);

	// ******************************************** MAP LAYOUT **************************************************


	//Sea stripe west
	int SeaWestID = rmRiverCreate(-1, "california coast2", 14, 7, 16+cNumberNonGaiaPlayers/2, 17+cNumberNonGaiaPlayers/2);
	rmRiverAddWaypoint(SeaWestID, 0.03, 1.00);
	rmRiverAddWaypoint(SeaWestID, 0.03, 0.00);
	rmRiverBuild(SeaWestID);

	//Sea stripe east
	int SeaEastID = rmRiverCreate(-1, "california coast2", 14, 7, 16+cNumberNonGaiaPlayers/2, 17+cNumberNonGaiaPlayers/2);
	rmRiverAddWaypoint(SeaEastID, 0.97, 1.00);
	rmRiverAddWaypoint(SeaEastID, 0.97, 0.00);
	rmRiverBuild(SeaEastID);

	//Sea holes
	float holesizemin = 0.044-(0.0036*cNumberNonGaiaPlayers);
	float holesizemax = 0.044-(0.0036*cNumberNonGaiaPlayers);

	for (i=0; < 6)
	{
		int SeaHoleID = rmCreateArea("Sea hole "+i);
		rmSetAreaSize(SeaHoleID, holesizemin, holesizemax);
		if (i < 1)
			rmSetAreaLocation(SeaHoleID, 0.10, rmRandFloat(0.64, 0.66));
		else if (i < 2)
			rmSetAreaLocation(SeaHoleID, 0.10, rmRandFloat(0.21, 0.23));
		else if (i < 3)
			rmSetAreaLocation(SeaHoleID, 0.90, rmRandFloat(0.34, 0.36));
		else if (i < 4)
			rmSetAreaLocation(SeaHoleID, 0.90, rmRandFloat(0.77, 0.79));
		else if (i < 5)
			rmSetAreaLocation(SeaHoleID, 0.10, 0.99);
		else
			rmSetAreaLocation(SeaHoleID, 0.90, 0.01);

		rmSetAreaObeyWorldCircleConstraint(SeaHoleID, true);
		rmSetAreaWaterType(SeaHoleID, "california coast2");
		rmSetAreaCoherence(SeaHoleID, 0.6);
		rmSetAreaSmoothDistance(SeaHoleID, 8+cNumberNonGaiaPlayers*2);
		rmBuildArea(SeaHoleID);
	}

	// Continent
	int ContinentAreaID = rmCreateArea("Continent area");
	rmSetAreaSize(ContinentAreaID, 0.80, 0.80);
	rmSetAreaMix(ContinentAreaID,"california_desert1");
//	rmSetAreaTerrainType(ContinentAreaID,"california\ground5_cal",4.0);
	rmSetAreaElevationType(ContinentAreaID, cElevTurbulence);
	rmSetAreaElevationVariation(ContinentAreaID, 3.0);
//  rmSetAreaBaseHeight(ContinentAreaID, 4.0);
    rmSetAreaElevationMinFrequency(ContinentAreaID, 0.042);
    rmSetAreaElevationOctaves(ContinentAreaID, 3);
	rmSetAreaElevationPersistence(ContinentAreaID, 0.44);
	rmAddAreaConstraint(ContinentAreaID, avoidImpassableLand);
	rmSetAreaObeyWorldCircleConstraint(ContinentAreaID, false);
	rmSetAreaWarnFailure(ContinentAreaID, false);
	rmBuildArea(ContinentAreaID);


	//Central area
	int CentralAreaID = rmCreateArea("Central area");
	rmSetAreaSize(CentralAreaID, 0.24, 0.24);
	rmAddAreaInfluenceSegment(CentralAreaID, 0.58, 1.0, 0.55, 0.6);
	rmAddAreaInfluenceSegment(CentralAreaID, 0.55, 0.6, 0.45, 0.4);
	rmAddAreaInfluenceSegment(CentralAreaID, 0.45, 0.4, 0.42, 0.0);
	rmSetAreaMix(CentralAreaID,"california_grassrocks"); // california_grassrocks
	rmAddAreaTerrainLayer(CentralAreaID, "california\desert5_cal", 0, 3);
//	rmSetAreaTerrainType(CentralAreaID,"california\ground5_cal",4.0);
//	rmSetAreaElevationType(CentralAreaID, cElevTurbulence);
	rmSetAreaElevationVariation(CentralAreaID, 4.0);
//	rmSetAreaBaseHeight(CentralAreaID, 3.0);
	rmSetAreaElevationMinFrequency(CentralAreaID, 0.045);
	rmSetAreaElevationOctaves(CentralAreaID, 4);
	rmSetAreaElevationPersistence(CentralAreaID, 0.52);
	rmSetAreaHeightBlend(CentralAreaID, 2.0);
	rmSetAreaCoherence(CentralAreaID,0.70);
	rmSetAreaSmoothDistance(CentralAreaID, 12);
	rmAddAreaConstraint(CentralAreaID, avoidImpassableLand);
//	rmAddAreaConstraint(CentralAreaID, avoidWaterFar);
	rmSetAreaObeyWorldCircleConstraint(CentralAreaID, false);
	rmSetAreaLocation(CentralAreaID, 0.50, 0.50);
	rmBuildArea(CentralAreaID);

	int avoidCentralArea = rmCreateAreaDistanceConstraint("avoid central area", CentralAreaID, 3.0);
	int avoidCentralAreaMin = rmCreateAreaDistanceConstraint("avoid central area min", CentralAreaID, 0.5);
	int stayInCentralArea = rmCreateAreaMaxDistanceConstraint("stay in central area", CentralAreaID, 0.0);


	// Cliff imprint
	int CliffImprintID = rmCreateArea("Cliff imprint");
	rmSetAreaSize(CliffImprintID, 0.12, 0.12);
	rmAddAreaInfluenceSegment(CliffImprintID, 0.42, 0.00, 0.42, 0.30);
	rmAddAreaInfluenceSegment(CliffImprintID, 0.42, 0.30, 0.58, 0.70);
	rmAddAreaInfluenceSegment(CliffImprintID, 0.58, 0.70, 0.58, 1.00);
	rmSetAreaTerrainType(CliffImprintID,"california\groundforest_cal"); // california_grassrocks
	rmSetAreaMix(CliffImprintID,"california_grass");
//	rmAddAreaTerrainLayer(CliffImprintID, "california\groundforest_cal", 0, 1);
//	rmSetAreaTerrainType(CliffImprintID,"california\ground5_cal",4.0);
//	rmSetAreaElevationType(CliffImprintID, cElevTurbulence);
//	rmSetAreaElevationVariation(CliffImprintID, 4.0);
//	rmSetAreaBaseHeight(CliffImprintID, 4.0);
//  rmSetAreaElevationMinFrequency(CliffImprintID, 0.08);
//	rmSetAreaElevationOctaves(CliffImprintID, 3);
//	rmSetAreaElevationPersistence(CliffImprintID, 0.3);
//	rmSetAreaBaseHeight(CliffImprintID, 8.0);
	rmSetAreaHeightBlend(CliffImprintID, 2.0);
	rmSetAreaCoherence(CliffImprintID,0.70);
	rmSetAreaSmoothDistance(CliffImprintID, 7);
//	rmAddAreaConstraint(CliffImprintID, avoidImpassableLandFar);
//	rmAddAreaConstraint(CliffImprintID, avoidWaterFar);
	rmSetAreaObeyWorldCircleConstraint(CliffImprintID, false);
	rmSetAreaLocation(CliffImprintID, 0.50, 0.50);
	rmBuildArea(CliffImprintID);


	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.49;
		float yLoc = 0.465;
		float walk = 0.03;

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}

	// ****************************************** TRADE ROUTE **********************************************

	int tradeRouteID = rmCreateTradeRoute();
	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
//	rmAddObjectDefConstraint(socketID, avoidImpassableLandShort);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);

	if (cNumberTeams <= 2 && rmGetIsKOTH() == false)
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.72, 1.00);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.68, 0.90);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.72, 0.80);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.68, 0.70);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.72, 0.60);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.70, 0.50);

		rmAddTradeRouteWaypoint(tradeRouteID, 0.62, 0.44);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.38, 0.55);

		rmAddTradeRouteWaypoint(tradeRouteID, 0.30, 0.50);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.28, 0.40);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.32, 0.30);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.28, 0.20);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.32, 0.10);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.28, 0.00);
	}
	else
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.76, 0.40);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.66, 0.32);
		if (rmGetIsKOTH()) {
			rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.55);
		} else {
			rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.50);
		}
		rmAddTradeRouteWaypoint(tradeRouteID, 0.34, 0.68);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.24, 0.60);
	}

	bool placedTradeRoute =	rmBuildTradeRoute(tradeRouteID, "dirt");
	if(placedTradeRoute == false)
	rmEchoError("Failed to place trade route");
	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

//	if (cNumberTeams <= 2)
//	{
		vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.08);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		if (cNumberNonGaiaPlayers >= 5)
		{
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.29);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
		if (cNumberNonGaiaPlayers <= 2)
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
		else
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		if (cNumberNonGaiaPlayers >= 5)
		{
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.71);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.92);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
//	}


	// *************************************************************************************************************

	// Text
	rmSetStatusText("",0.40);

	// *************************************************************************************************************

	//Cliffs
	int cliffnorthID = -1;
	int cliffsouthID = -1;
	int pass1ID = -1;
	int pass2ID = -1;
	int pass3ID = -1;
	int pass4ID = -1;
	int passterrain1ID = -1;
	int passterrain2ID = -1;
	int passterrain3ID = -1;
	int passterrain4ID = -1;

	cliffnorthID = rmCreateArea("cliff north");
	rmAddAreaToClass(cliffnorthID, rmClassID("cliffs"));
	rmSetAreaSize(cliffnorthID, 0.018, 0.018);
	rmSetAreaCoherence(cliffnorthID, 0.74);
	rmSetAreaSmoothDistance(cliffnorthID, 5);
	rmAddAreaInfluenceSegment(cliffnorthID, 0.58, 1.02, 0.58, 0.70);
	rmAddAreaInfluenceSegment(cliffnorthID, 0.58, 0.70, 0.52, 0.60);
	rmSetAreaWarnFailure(cliffnorthID, false);
	rmSetAreaCliffType(cliffnorthID, "california"); //
	rmSetAreaCliffHeight(cliffnorthID, 5, 0.0, 0.5);
	rmSetAreaCliffEdge(cliffnorthID, 1, 1.0, 0.0, 0.0, 1);
	rmSetAreaTerrainType(cliffnorthID, "california\groundforest_cal");
//	rmSetAreaCliffPainting(cliffnorthID, true, false, true, 1.5 , true);
	rmSetAreaLocation(cliffnorthID, 0.58, 0.68);
	rmSetAreaObeyWorldCircleConstraint(cliffnorthID, false);
	rmAddAreaConstraint(cliffnorthID, avoidTradeRouteFar);
	rmBuildArea(cliffnorthID);

	cliffsouthID = rmCreateArea("cliff south");
	rmAddAreaToClass(cliffsouthID, rmClassID("cliffs"));
	rmSetAreaSize(cliffsouthID, 0.018, 0.018);
	rmSetAreaCoherence(cliffsouthID, 0.74);
	rmSetAreaSmoothDistance(cliffsouthID, 5);
	rmAddAreaInfluenceSegment(cliffsouthID, 0.42, 0.00, 0.42, 0.30);
	rmAddAreaInfluenceSegment(cliffsouthID, 0.42, 0.30, 0.48, 0.40);
	rmSetAreaWarnFailure(cliffsouthID, false);
	rmSetAreaCliffType(cliffsouthID, "california"); //
	rmSetAreaCliffHeight(cliffsouthID, 5, 0.0, 0.5);
	rmSetAreaCliffEdge(cliffsouthID, 1, 1.0, 0.0, 0.0, 1);
	rmSetAreaTerrainType(cliffsouthID, "california\groundforest_cal");
//	rmSetAreaCliffPainting(cliffsouthID, true, false, true, 1.5 , true);
	rmSetAreaLocation(cliffsouthID, 0.42, 0.32);
	rmSetAreaObeyWorldCircleConstraint(cliffsouthID, false);
	rmAddAreaConstraint(cliffsouthID, avoidTradeRouteFar);
	rmBuildArea(cliffsouthID);

	int avoidCliffNorth = rmCreateAreaDistanceConstraint("avoid cliff north", cliffnorthID, 1.0);
	int avoidCliffSouth = rmCreateAreaDistanceConstraint("avoid cliff south", cliffsouthID, 1.0);
	int stayCliffNorth = rmCreateAreaMaxDistanceConstraint("stay cliff north", cliffnorthID, 0.0);
	int stayCliffSouth = rmCreateAreaMaxDistanceConstraint("stay cliff south", cliffsouthID, 0.0);


	// pass 1
	pass1ID = rmCreateArea("pass 1");
	rmAddAreaToClass(pass1ID, rmClassID("Passes"));
	rmSetAreaSize(pass1ID, 0.0044, 0.0044); // 0.008, 0.008
	rmSetAreaCoherence(pass1ID, 0.90);
	rmSetAreaSmoothDistance(pass1ID, 1);
	rmAddAreaInfluenceSegment(pass1ID, 0.55, 0.88, 0.61, 0.88);
	rmSetAreaWarnFailure(pass1ID, false);
	rmSetAreaCliffType(pass1ID, "california"); //
	rmSetAreaCliffHeight(pass1ID, -5, 0.0, 0.5);
	rmSetAreaCliffEdge(pass1ID, 1, 1.0, 0.0, 0.0, 1);
//	rmSetAreaCliffPainting(pass1ID, true, true, true, 0.1 , false); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaTerrainType(pass1ID, "california\ground5_cal");
	rmSetAreaLocation(pass1ID, 0.58, 0.88);
	rmSetAreaObeyWorldCircleConstraint(pass1ID, false);
	rmAddAreaConstraint(pass1ID, stayCliffNorth);
	rmBuildArea(pass1ID);

	passterrain1ID = rmCreateArea("pass terrain 1");
	rmSetAreaSize(passterrain1ID, 0.0060, 0.0060); // 0.008, 0.008
	rmSetAreaLocation(passterrain1ID, 0.58, 0.88);
	rmAddAreaInfluenceSegment(passterrain1ID, 0.55, 0.88, 0.61, 0.88);
	rmSetAreaCoherence(passterrain1ID, 1.00);
	rmSetAreaTerrainType(passterrain1ID, "california\ground5_cal");
	rmBuildArea(passterrain1ID);


	// pass 2
	pass2ID = rmCreateArea("pass ");
	rmAddAreaToClass(pass2ID, rmClassID("Passes"));
	rmSetAreaSize(pass2ID, 0.0032, 0.0032);
	rmSetAreaCoherence(pass2ID, 0.95);
	rmSetAreaSmoothDistance(pass2ID, 1);
	rmAddAreaInfluenceSegment(pass2ID, 0.55, 0.73, 0.61, 0.67);
	rmSetAreaWarnFailure(pass2ID, false);
	rmSetAreaCliffType(pass2ID, "california"); //
	rmSetAreaCliffHeight(pass2ID, -5, 0.0, 0.5);
	rmSetAreaCliffEdge(pass2ID, 1, 1.0, 0.0, 0.0, 1);
	rmSetAreaTerrainType(pass2ID, "california\ground5_cal");
//	rmSetAreaCliffPainting(pass2ID, true, false, true, 1.5 , true);
	rmSetAreaLocation(pass2ID, 0.58, 0.70);
	rmSetAreaObeyWorldCircleConstraint(pass2ID, false);
	rmAddAreaConstraint(pass2ID, stayCliffNorth);
	rmBuildArea(pass2ID);

	passterrain2ID = rmCreateArea("pass terrain 2");
	rmSetAreaSize(passterrain2ID, 0.0040, 0.0040);
	rmSetAreaSmoothDistance(passterrain2ID, 1);
	rmSetAreaLocation(passterrain2ID, 0.58, 0.70);
	rmAddAreaInfluenceSegment(passterrain2ID, 0.55, 0.73, 0.61, 0.67);
	rmSetAreaCoherence(passterrain2ID, 1.00);
	rmSetAreaTerrainType(passterrain2ID, "california\ground5_cal");
	rmBuildArea(passterrain2ID);


	// pass 3
	pass3ID = rmCreateArea("pass 3");
	rmAddAreaToClass(pass3ID, rmClassID("Passes"));
	rmSetAreaSize(pass3ID, 0.0032, 0.0032);
	rmSetAreaCoherence(pass3ID, 0.95);
	rmSetAreaSmoothDistance(pass3ID, 1);
	rmAddAreaInfluenceSegment(pass3ID, 0.39, 0.33, 0.45, 0.27);
	rmSetAreaWarnFailure(pass3ID, false);
	rmSetAreaCliffType(pass3ID, "california"); //
	rmSetAreaCliffHeight(pass3ID, -5, 0.0, 0.5);
	rmSetAreaCliffEdge(pass3ID, 1, 1.0, 0.0, 0.0, 1);
	rmSetAreaTerrainType(pass3ID, "california\ground5_cal");
//	rmSetAreaCliffPainting(pass3ID, true, false, true, 1.5 , true);
	rmSetAreaLocation(pass3ID, 0.42, 0.30);
	rmSetAreaObeyWorldCircleConstraint(pass3ID, false);
	rmAddAreaConstraint(pass3ID, stayCliffSouth);
	rmBuildArea(pass3ID);

	passterrain3ID = rmCreateArea("pass terrain 3");
	rmSetAreaSize(passterrain3ID, 0.0040, 0.0040);
	rmSetAreaSmoothDistance(passterrain3ID, 1);
	rmSetAreaLocation(passterrain3ID, 0.42, 0.30);
	rmAddAreaInfluenceSegment(passterrain3ID, 0.39, 0.33, 0.45, 0.27);
	rmSetAreaCoherence(passterrain3ID, 1.00);
	rmSetAreaTerrainType(passterrain3ID, "california\ground5_cal");
	rmBuildArea(passterrain3ID);


	// pass 4
	pass4ID = rmCreateArea("pass 4");
	rmAddAreaToClass(pass4ID, rmClassID("Passes"));
	rmSetAreaSize(pass4ID, 0.0044, 0.0044); // 0.008, 0.008
	rmSetAreaCoherence(pass4ID, 0.90);
	rmSetAreaSmoothDistance(pass4ID, 1);
	rmAddAreaInfluenceSegment(pass4ID, 0.39, 0.12, 0.45, 0.12);
	rmSetAreaWarnFailure(pass4ID, false);
	rmSetAreaCliffType(pass4ID, "california"); //
	rmSetAreaCliffHeight(pass4ID, -5, 0.0, 0.5);
	rmSetAreaCliffEdge(pass4ID, 1, 1.0, 0.0, 0.0, 1);
//	rmSetAreaCliffPainting(pass4ID, true, true, true, 0.1 , false); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaTerrainType(pass4ID, "california\ground5_cal");
	rmSetAreaLocation(pass4ID, 0.42, 0.12);
	rmSetAreaObeyWorldCircleConstraint(pass4ID, false);
	rmAddAreaConstraint(pass4ID, stayCliffSouth);
	rmBuildArea(pass4ID);

	passterrain4ID = rmCreateArea("pass terrain 4");
	rmSetAreaSize(passterrain4ID, 0.0060, 0.0060); // 0.008, 0.008
	rmSetAreaLocation(passterrain4ID, 0.42, 0.11);
	rmAddAreaInfluenceSegment(passterrain4ID, 0.39, 0.12, 0.45, 0.12);
	rmSetAreaCoherence(passterrain4ID, 1.00);
	rmSetAreaTerrainType(passterrain4ID, "california\ground5_cal");
	rmBuildArea(passterrain4ID);



	// Players area
	for (i=1; < cNumberPlayers)
	{
		int playerareaID = rmCreateArea("playerarea"+i);
		rmSetPlayerArea(i, playerareaID);
		rmSetAreaSize(playerareaID, 0.05, 0.05);
		rmSetAreaCoherence(playerareaID, 1.0);
		rmSetAreaWarnFailure(playerareaID, false);
//		rmSetAreaTerrainType(playerareaID, "new_england\ground2_cliff_ne"); // for testing
		rmSetAreaLocPlayer(playerareaID, i);
		rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
		rmBuildArea(playerareaID);
		int avoidPlayerArea = rmCreateAreaDistanceConstraint("avoid player area "+i, playerareaID, 3.0);
		int stayPlayerArea = rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerareaID, 0.0);
	}

	int avoidPlayerArea1 = rmConstraintID("avoid player area 1");
	int avoidPlayerArea2 = rmConstraintID("avoid player area 2");
	int stayInPlayerArea1 = rmConstraintID("stay in player area 1");
	int stayInPlayerArea2 = rmConstraintID("stay in player area 2");


	// *********************************************************************************************************

	// Text
	rmSetStatusText("",0.45);

	// ******************************************** NATIVES *************************************************

	int natsvariation = -1;
//	natsvariation = rmRandInt(0,1);
	natsvariation = 1; // <--- TEST

	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
	int nativeID4 = -1;

	if (natsvariation == 0)
		nativeID0 = rmCreateGrouping("apache village", "native apache village "+3);
	else
		nativeID0 = rmCreateGrouping("navajo village", "native navajo village "+4);
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
//	rmAddGroupingConstraint(nativeID0, avoidImpassableLand);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
//  rmAddGroupingToClass(nativeID0, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID0, avoidNatives);
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.47, 0.76);

	if (natsvariation == 0)
		nativeID1 = rmCreateGrouping("apache village2", "native apache village "+1);
	else
		nativeID1 = rmCreateGrouping("navajo village2", "native navajo village "+1);
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
//	rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
//  rmAddGroupingToClass(nativeID1, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID1, avoidNatives);
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.53, 0.24);

	// ******************************************************************************************************

	// Text
	rmSetStatusText("",0.50);

	// ************************************ PLAYER STARTING RESOURCES ***************************************

	// ******** Define ********

	// Town center & units
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 6.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);

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
	rmSetObjectDefMaxDistance(TCID, 6.0);

	// Starting mine
	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 16.0);
	rmSetObjectDefMaxDistance(playergoldID, 16.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
//	rmAddObjectDefConstraint(playergoldID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);

	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 62.0); //58
	rmSetObjectDefMaxDistance(playergold2ID, 66.0); //62
//	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergold2ID, avoidImpassableLandMed);
	rmAddObjectDefConstraint(playergold2ID, avoidWaterFar);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldType);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold2ID, avoidEdge);

	// 3nd mine
	int playergold3ID = rmCreateObjectDef("player third mine");
	rmAddObjectDefItem(playergold3ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold3ID, 37.0); //58
	rmSetObjectDefMaxDistance(playergold3ID, 38.0); //62
//	rmAddObjectDefToClass(playergold3ID, classStartingResource);
	rmAddObjectDefToClass(playergold3ID, classGold);
	rmAddObjectDefConstraint(playergold3ID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergold3ID, avoidImpassableLandMed);
//	rmAddObjectDefConstraint(playergold3ID, avoidWater);
	rmAddObjectDefConstraint(playergold3ID, avoidNatives);
	rmAddObjectDefConstraint(playergold3ID, avoidGoldType);
	rmAddObjectDefConstraint(playergold3ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold3ID, avoidEdge);
//	rmAddObjectDefConstraint(playergold3ID, avoidCenter);


	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "TreeSonora", rmRandInt(2,2), 2.0);
    rmSetObjectDefMinDistance(playerTreeID, 12);
    rmSetObjectDefMaxDistance(playerTreeID, 16);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
//	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResourcesShort);

	// Starting trees2
	int playerTree2ID = rmCreateObjectDef("player trees 2");
	rmAddObjectDefItem(playerTree2ID, "TreeSonora", rmRandInt(2,2), 2.0);
    rmSetObjectDefMinDistance(playerTree2ID, 12);
    rmSetObjectDefMaxDistance(playerTree2ID, 16);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
//	rmAddObjectDefToClass(playerTree2ID, classForest);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTree2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResourcesShort);

	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", rmRandInt(2,2), 2.0);
    rmSetObjectDefMinDistance(playerberriesID, 13);
    rmSetObjectDefMaxDistance(playerberriesID, 14);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
    rmAddObjectDefConstraint(playerberriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResources);

	// Starting herd
	int playerherdID = rmCreateObjectDef("starting moose");
	rmAddObjectDefItem(playerherdID, "pronghorn", rmRandInt(5,5), 3.0);
	rmSetObjectDefMinDistance(playerherdID, 13.0);
	rmSetObjectDefMaxDistance(playerherdID, 16.0);
	rmSetObjectDefCreateHerd(playerherdID, false);
	rmAddObjectDefToClass(playerherdID, classStartingResource);
	rmAddObjectDefConstraint(playerherdID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerherdID, avoidImpassableLandMed);
	rmAddObjectDefConstraint(playerherdID, avoidNatives);
//	rmAddObjectDefConstraint(playerherdID, avoidStartingResourcesShort);

	// 2nd herd
	int player2ndherdID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(player2ndherdID, "pronghorn", rmRandInt(10,10), 7.0);
    rmSetObjectDefMinDistance(player2ndherdID, 26);
    rmSetObjectDefMaxDistance(player2ndherdID, 30);
	rmAddObjectDefToClass(player2ndherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player2ndherdID, true);
	rmAddObjectDefConstraint(player2ndherdID, avoidStartingResources);
	rmAddObjectDefConstraint(player2ndherdID, avoidPronghorn);
//	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(player2ndherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(player2ndherdID, avoidNativesShort);

// 3nd herd
	int player3rdherdID = rmCreateObjectDef("player 3rd herd");
	rmAddObjectDefItem(player3rdherdID, "pronghorn", rmRandInt(6,6), 5.0);
    rmSetObjectDefMinDistance(player3rdherdID, 38);
    rmSetObjectDefMaxDistance(player3rdherdID, 42);
	rmAddObjectDefToClass(player3rdherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player3rdherdID, true);
	rmAddObjectDefConstraint(player3rdherdID, avoidStartingResources);
	rmAddObjectDefConstraint(player3rdherdID, avoidPronghorn);
//	rmAddObjectDefConstraint(player3rdherdID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(player3rdherdID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(player3rdherdID, avoidImpassableLandMed);
	rmAddObjectDefConstraint(player3rdherdID, avoidNatives);

	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 26.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLandMed);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetShort); //Short
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);

	// Water spawn flag
	int colonyShipID = 0;
	colonyShipID=rmCreateObjectDef("colony ship "+i);
	rmAddObjectDefItem(colonyShipID, "HomeCityWaterSpawnFlag", 1, 1.0);
	rmSetObjectDefMinDistance(colonyShipID, rmXFractionToMeters(0.1));
	rmSetObjectDefMaxDistance(colonyShipID, rmXFractionToMeters(0.28));
	rmAddObjectDefConstraint(colonyShipID, avoidColonyShip);
	rmAddObjectDefConstraint(colonyShipID, avoidLand);
	rmAddObjectDefConstraint(colonyShipID, avoidEdge);
//  vector colonyShipLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(colonyShipID, i));
//  rmSetHomeCityWaterSpawnPoint(i, colonyShipLocation);



	// ******** Place ********

	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (teamZeroCount < 2 && teamOneCount < 2)
			rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergold3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(player2ndherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
 		rmPlaceObjectDefAtLoc(player3rdherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
		rmPlaceObjectDefAtLoc(colonyShipID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));

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

	int minecount = 3*cNumberNonGaiaPlayers;

	for(i=0; < minecount)
	{
		int commongoldID = rmCreateObjectDef("common mines"+i);
		rmAddObjectDefItem(commongoldID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(commongoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(commongoldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(commongoldID, classGold);
		rmAddObjectDefConstraint(commongoldID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(commongoldID, avoidImpassableLand);
		rmAddObjectDefConstraint(commongoldID, avoidCliff);
		rmAddObjectDefConstraint(commongoldID, avoidWater);
		rmAddObjectDefConstraint(commongoldID, avoidNatives);
		rmAddObjectDefConstraint(commongoldID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(commongoldID, avoidGoldFar);
		rmAddObjectDefConstraint(commongoldID, avoidTownCenterFar);
		rmAddObjectDefConstraint(commongoldID, avoidEdge);
		if (cNumberTeams <= 2 && teamZeroCount == teamOneCount)
		{
			if (i < minecount/2)
				rmAddObjectDefConstraint(commongoldID, stayWestHalf);
			else
				rmAddObjectDefConstraint(commongoldID, stayEastHalf);
		}
		rmPlaceObjectDefAtLoc(commongoldID, 0, 0.50, 0.50);
	}

	// *********************************

	// ************ Forest *************

	// Desert forest

	int desertforestcount = 5*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 4)
		desertforestcount = 5*cNumberNonGaiaPlayers-cNumberNonGaiaPlayers;

	for (i=0; < desertforestcount)
	{
		int forestID = rmCreateArea("forest"+i);
		rmSetAreaWarnFailure(forestID, false);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(170), rmAreaTilesToFraction(190)); // 200, 210
		rmSetAreaForestType(forestID, "california desert forest");
//		rmSetAreaObeyWorldCircleConstraint(forestID, false);
		rmSetAreaForestDensity(forestID, 0.85);
		rmSetAreaForestClumpiness(forestID, 0.25);
		rmSetAreaForestUnderbrush(forestID, 0.3);
		rmSetAreaMinBlobs(forestID, 1);
		rmSetAreaMaxBlobs(forestID, 5);
		rmSetAreaMinBlobDistance(forestID, 10.0);
		rmSetAreaMaxBlobDistance(forestID, 30.0);
		rmSetAreaCoherence(forestID, 1.0);
		rmSetAreaSmoothDistance(forestID, 6);
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidForest);
		rmAddAreaConstraint(forestID, avoidStartingResourcesShort);
		rmAddAreaConstraint(forestID, avoidGoldTypeMed);
//		rmAddAreaConstraint(forestID, avoidPronghornMin);
		rmAddAreaConstraint(forestID, avoidTownCenterShort);
		rmAddAreaConstraint(forestID, avoidNatives);
		rmAddAreaConstraint(forestID, avoidTradeRouteShort);
		rmAddAreaConstraint(forestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(forestID, avoidImpassableLand);
//		rmAddAreaConstraint(forestID, avoidEdge);
		rmAddAreaConstraint(forestID, avoidCentralArea);
		rmBuildArea(forestID);
	}

	// Isolated trees

	int randomtreecount = 8*cNumberNonGaiaPlayers-cNumberNonGaiaPlayers;

	for (i=0; < randomtreecount)
	{
		int randomtreeID = rmCreateObjectDef("random tree"+i);
		rmAddObjectDefItem(randomtreeID, "TreeSonora", rmRandInt(1,2), 5.0);
		rmAddObjectDefItem(randomtreeID, "TreeSonora", rmRandInt(1,2), 3.0);
		rmSetObjectDefMinDistance(randomtreeID, 0);
		rmSetObjectDefMaxDistance(randomtreeID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(randomtreeID, classForest);
		rmAddObjectDefConstraint(randomtreeID, avoidForestShort);
		rmAddObjectDefConstraint(randomtreeID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(randomtreeID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(randomtreeID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(randomtreeID, avoidNatives);
		rmAddObjectDefConstraint(randomtreeID, avoidGoldTypeMed);
		rmAddObjectDefConstraint(randomtreeID, avoidTownCenterShort);
		rmAddObjectDefConstraint(randomtreeID, avoidStartingResources);
		rmAddObjectDefConstraint(randomtreeID, avoidPronghornMin);
		rmAddObjectDefConstraint(randomtreeID, avoidCentralArea);
		rmPlaceObjectDefAtLoc(randomtreeID, 0, 0.50, 0.50);
	}


	// Central ponderosa pine forest

	int centralforestcount = 2+3*cNumberNonGaiaPlayers;

	for (i=0; < centralforestcount)
	{
		int centraltreebigID = rmCreateObjectDef("central tree clump  big"+i);
		rmAddObjectDefItem(centraltreebigID, "TreeMadrone", rmRandInt(2,3), 8.0);
		rmAddObjectDefItem(centraltreebigID, "TreeMadrone", rmRandInt(2,4), 8.0);
		rmAddObjectDefItem(centraltreebigID, "TreeMadrone", rmRandInt(2,5), 9.0);
		rmAddObjectDefItem(centraltreebigID, "TreeMadrone", rmRandInt(1,3), 6.0);
		rmAddObjectDefItem(centraltreebigID, "TreeRedwood", rmRandInt(1,3), 6.0);
		rmSetObjectDefMinDistance(centraltreebigID, 0);
		rmSetObjectDefMaxDistance(centraltreebigID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(centraltreebigID, classForest);
		rmAddObjectDefConstraint(centraltreebigID, avoidForestShort);
		rmAddObjectDefConstraint(centraltreebigID, avoidTradeRoute);
		rmAddObjectDefConstraint(centraltreebigID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(centraltreebigID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(centraltreebigID, avoidNativesFar);
		rmAddObjectDefConstraint(centraltreebigID, avoidGoldTypeMed);
		rmAddObjectDefConstraint(centraltreebigID, avoidTownCenterShort);
		rmAddObjectDefConstraint(centraltreebigID, avoidStartingResources);
		rmAddObjectDefConstraint(centraltreebigID, avoidPronghornMin);
		rmAddObjectDefConstraint(centraltreebigID, stayInCentralArea);
		rmAddObjectDefConstraint(centraltreebigID, avoidCliff);
		rmAddObjectDefConstraint(centraltreebigID, avoidPass);
		rmPlaceObjectDefAtLoc(centraltreebigID, 0, 0.50, 0.50);
	}

	// Central ponderosa pine forest small
	for (i=0; < centralforestcount-cNumberNonGaiaPlayers)
	{
		int centraltreesmallID = rmCreateObjectDef("central tree clump  small"+i);
		rmAddObjectDefItem(centraltreesmallID, "TreeMadrone", rmRandInt(6,7), 5.0);
		rmAddObjectDefItem(centraltreesmallID, "TreeMadrone", rmRandInt(2,3), 5.0);
		rmSetObjectDefMinDistance(centraltreesmallID, 0);
		rmSetObjectDefMaxDistance(centraltreesmallID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(centraltreesmallID, classForest);
		rmAddObjectDefConstraint(centraltreesmallID, avoidForestShort);
		rmAddObjectDefConstraint(centraltreesmallID, avoidTradeRoute);
		rmAddObjectDefConstraint(centraltreesmallID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(centraltreesmallID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(centraltreesmallID, avoidNativesFar);
		rmAddObjectDefConstraint(centraltreesmallID, avoidGoldTypeMed);
		rmAddObjectDefConstraint(centraltreesmallID, avoidTownCenterShort);
		rmAddObjectDefConstraint(centraltreesmallID, avoidStartingResources);
		rmAddObjectDefConstraint(centraltreesmallID, avoidPronghornMin);
		rmAddObjectDefConstraint(centraltreesmallID, stayInCentralArea);
		rmAddObjectDefConstraint(centraltreesmallID, avoidCliffNorth);
		rmAddObjectDefConstraint(centraltreesmallID, avoidCliff);
		rmAddObjectDefConstraint(centraltreesmallID, avoidPass);
		rmPlaceObjectDefAtLoc(centraltreesmallID, 0, 0.50, 0.50);
	}

	// ********************************

	// Text
	rmSetStatusText("",0.70);

	// ************ Herds *************

	//Pronghorn herds
	int pronghorncount = 3*cNumberNonGaiaPlayers;

	for (i=0; < pronghorncount)
	{
		int pronghornherdID = rmCreateObjectDef("pronghorn herd"+i);
		rmAddObjectDefItem(pronghornherdID, "pronghorn", rmRandInt(6,7), 6.0);
		rmSetObjectDefMinDistance(pronghornherdID, 0.0);
		rmSetObjectDefMaxDistance(pronghornherdID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(pronghornherdID, true);
		rmAddObjectDefConstraint(pronghornherdID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(pronghornherdID, avoidNatives);
		rmAddObjectDefConstraint(pronghornherdID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(pronghornherdID, avoidForestMin);
		rmAddObjectDefConstraint(pronghornherdID, avoidGoldTypeMed);
		rmAddObjectDefConstraint(pronghornherdID, avoidPronghornFar);
		rmAddObjectDefConstraint(pronghornherdID, avoidTownCenterMed);
		rmAddObjectDefConstraint(pronghornherdID, avoidEdge);
		rmAddObjectDefConstraint(pronghornherdID, avoidCentralAreaMin);
		if (cNumberTeams <= 2 && teamZeroCount == teamOneCount)
		{
		if (i < pronghorncount/2)
			rmAddObjectDefConstraint(pronghornherdID, stayWestHalf);
		else
			rmAddObjectDefConstraint(pronghornherdID, stayEastHalf);
		}
		rmPlaceObjectDefAtLoc(pronghornherdID, 0, 0.50, 0.50);
	}

	//Bighorn herds
	int bighorncount = 3*cNumberNonGaiaPlayers;

	for (i=0; < bighorncount)
	{
		int bighornherdID = rmCreateObjectDef("bighorn herd"+i);
		rmAddObjectDefItem(bighornherdID, "bighornsheep", rmRandInt(6,7), 7.0);
		rmSetObjectDefMinDistance(bighornherdID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(bighornherdID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(bighornherdID, true);
		rmAddObjectDefConstraint(bighornherdID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(bighornherdID, avoidNativesShort);
		rmAddObjectDefConstraint(bighornherdID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(bighornherdID, avoidForestMin);
		rmAddObjectDefConstraint(bighornherdID, avoidGoldTypeMed);
		rmAddObjectDefConstraint(bighornherdID, avoidPronghorn);
		rmAddObjectDefConstraint(bighornherdID, avoidBighorn);
		rmAddObjectDefConstraint(bighornherdID, avoidTownCenter);
		rmAddObjectDefConstraint(bighornherdID, stayInCentralArea);
		rmAddObjectDefConstraint(bighornherdID, avoidCliff);
		rmAddObjectDefConstraint(bighornherdID, avoidEdge);
		rmPlaceObjectDefAtLoc(bighornherdID, 0, 0.50, 0.50);
	}

	// ************************************

	// Text
	rmSetStatusText("",0.80);

	// ************** Treasures ***************

	int treasure4count = cNumberNonGaiaPlayers/3;
	int treasure3count = cNumberNonGaiaPlayers/2;
	int treasure2count = -1;
	int treasure1count = -1;

//	int treasurerandom = rmRandInt(1,2);
//	if (treasurerandom == 1)
//	{
		treasure2count = 4;
		treasure1count = 2;
//	}
//	else
//	{
//		treasure2count = 2;
//		treasure1count = 4;
//	}

	// Treasures lvl 2
	for (i=1; < treasure2count+cNumberNonGaiaPlayers+1)
	{
		int Nugget2ID = rmCreateObjectDef("nugget lvl2 "+i);
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(2,3);
		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLandMed);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterResources);
		rmAddObjectDefConstraint(Nugget2ID, avoidPronghornMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidBighornMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidCliff);
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge);
		if (cNumberTeams <= 2 && teamZeroCount == teamOneCount)
		{
			if (i%2 == 1)
				rmAddObjectDefConstraint(Nugget2ID, stayWestHalf);
			else
				rmAddObjectDefConstraint(Nugget2ID, stayEastHalf);
		}
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}

	// Treasures lvl 1
	for (i=1; < treasure1count+cNumberNonGaiaPlayers+1)
	{
		int Nugget1ID = rmCreateObjectDef("nugget lvl1 "+i);
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, 0);
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(1,2);
		rmAddObjectDefConstraint(Nugget1ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget1ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLandMed);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenterResources);
		rmAddObjectDefConstraint(Nugget1ID, avoidPronghornMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidBighornMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidCliff);
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge);
		if (cNumberTeams <= 2 && teamZeroCount == teamOneCount)
		{
			if (i%2 == 1)
				rmAddObjectDefConstraint(Nugget1ID, stayWestHalf);
			else
				rmAddObjectDefConstraint(Nugget1ID, stayEastHalf);
		}
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);
	}

	// Treasures lvl 3
	for (i=1; < treasure3count+1)
	{
		int Nugget3ID = rmCreateObjectDef("nugget lvl3 "+i);
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, 0);
		rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(3,4);
		rmAddObjectDefConstraint(Nugget3ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget3ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget3ID, avoidPronghornMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidBighornMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidCliff);
		rmAddObjectDefConstraint(Nugget3ID, avoidEdge);
		if (cNumberTeams <= 2 && teamZeroCount == teamOneCount)
		{
			if (i%2 == 1.00)
				rmAddObjectDefConstraint(Nugget3ID, stayWestHalf);
			else
				rmAddObjectDefConstraint(Nugget3ID, stayEastHalf);
		}
		if (teamZeroCount >= 2 && teamOneCount >= 2)
			rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50);
	}
/*
	// Treasures lvl 4
	for (i=1; < treasure4count+1)
	{
		int Nugget4ID = rmCreateObjectDef("nugget lvl4 "+i);
		rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget4ID, 0);
		rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(4,4);
		rmAddObjectDefConstraint(Nugget4ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget4ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget4ID, avoidPronghornMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidBighornMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidCliff);
		rmAddObjectDefConstraint(Nugget4ID, avoidEdge);
		if (cNumberTeams <= 2 && teamZeroCount == teamOneCount)
		{
			if (i%2 == 1.00)
				rmAddObjectDefConstraint(Nugget4ID, stayeastHalf);
			else
				rmAddObjectDefConstraint(Nugget4ID, staywestHalf);
		}
		if (teamZeroCount >= 3 && teamOneCount >= 3)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.50, 0.50);
	}
*/

	// ****************************************


	// Text
	rmSetStatusText("",0.95);

	// ************ Sea resources *************


	int fishcount = 3+cNumberNonGaiaPlayers;
	int whalecount = 2+cNumberNonGaiaPlayers/2;
	if (cNumberNonGaiaPlayers >= 4)
		whalecount++;
	if (cNumberNonGaiaPlayers >= 6)
		whalecount++;
	if (cNumberNonGaiaPlayers == 8)
		whalecount++;

	int whaleID=rmCreateObjectDef("whale");
	rmAddObjectDefItem(whaleID, "HumpbackWhale", 1, 3.0);
	rmSetObjectDefMinDistance(whaleID, 0.0);
	rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.30));
	rmAddObjectDefConstraint(whaleID, avoidWhale);
	rmAddObjectDefConstraint(whaleID, avoidLandFar);
	rmAddObjectDefConstraint(whaleID, avoidColonyShipShort);
	rmAddObjectDefConstraint(whaleID, avoidEdge);
	for (i=0; < whalecount)
	{
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.10, 0.50);
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.90, 0.50);
	}

	int fishID = rmCreateObjectDef("fish");
	rmAddObjectDefItem(fishID, "Fishmahi", rmRandInt(2,3), 14.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, avoidFish);
	rmAddObjectDefConstraint(fishID, avoidLand);
	rmAddObjectDefConstraint(fishID, avoidColonyShipShort);
	rmAddObjectDefConstraint(fishID, avoidEdge);
	for (i=0; < fishcount)
	{
		rmPlaceObjectDefAtLoc(fishID, 0, 0.10, 0.50);
		rmPlaceObjectDefAtLoc(fishID, 0, 0.90, 0.50);
	}


	// ****************************************************


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


} // END

