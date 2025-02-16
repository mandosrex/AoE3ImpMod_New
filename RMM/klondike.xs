// ESOC KLONDIKE (1v1, TEAM, FFA)
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
	int playerTiles = 5500; //12000
	if (cNumberNonGaiaPlayers >= 4)
		playerTiles = 5200;
	if (cNumberNonGaiaPlayers >= 6)
		playerTiles = 4800;
	int size = 2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); //2.1
	int longside = 1.6*size;
	rmSetMapSize(longside, size);
//	rmEchoInfo("Map size="+longside+"m x "+size+"m");

	// Make the corners.
	rmSetWorldCircleConstraint(true);



	// Picks a default water height
	rmSetSeaLevel(0.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	rmSetMapElevationParameters(cElevTurbulence, 0.035, 2, 0.65, 5.0); // type, frequency, octaves, persistence, variation
//	rmSetMapElevationHeightBlend(1);

	// Picks default terrain and water
	rmSetSeaType("yukon river");
//	rmEnableLocalWater(false);
	rmSetBaseTerrainMix("yukon snow"); //
	rmTerrainInitialize("yukon\ground1_yuk", 2.0); // NWterritory\ground_grass5_nwt
	rmSetMapType("yukon");
	rmSetMapType("snow");
	rmSetMapType("land");
	rmSetMapType("namerica");
	rmSetLightingSet("yukon"); //


	// Choose Mercs
	chooseMercs();

	// Text
	rmSetStatusText("",0.10);

	// Set up Natives
	int subCiv0 = -1;
	subCiv0 = rmGetCivID("nootka");
	rmSetSubCiv(0, "Nootka");


	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	rmDefineClass("classHill");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classPatch3 = rmDefineClass("patch3");
	int classWaterStone = rmDefineClass("stonewater");
	int classGrass = rmDefineClass("grass");
	int classStartingUnit = rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int importantItem = rmDefineClass("importantItem");
	int classNative = rmDefineClass("natives");
	int classCliff = rmDefineClass("Cliffs");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");

	// ******************************************************************************************

	// Text
	rmSetStatusText("",0.05);

	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other


	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.4,0.4,rmXFractionToMeters(0.24), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.5,0.48,rmXFractionToMeters(0.0), rmXFractionToMeters(0.15), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayEdge = rmCreatePieConstraint("Stay Edge",0.5,0.5,rmXFractionToMeters(0.42), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int centralbox = rmCreateBoxConstraint("central box constraint", 0.38, 0.40, 0.62, 0.56);
	int stayForestCircle = rmCreatePieConstraint("stay forest circle", 0.50, 0.00, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int stayForestBox = rmCreateBoxConstraint("stay forest box", 0.15, 0.00, 0.85, 0.24);
	int stayNorth = rmCreatePieConstraint("stay north", 0.70, 0.50, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(0), rmDegreesToRadians(180));
	int staySouth = rmCreatePieConstraint("stay south", 0.30, 0.50, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(180), rmDegreesToRadians(360));

	// Resource avoidance
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", classForest, 40.0); //15.0
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", classForest, 30.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", classForest, 22.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", classForest, 5.0);
	int avoidTurkey = rmCreateTypeDistanceConstraint("food avoids food", "moose", 28.0);
	int avoidTurketShort = rmCreateTypeDistanceConstraint("food avoids food short", "moose", 24.0);
	int avoidBerries = rmCreateTypeDistanceConstraint("avoid berries ", "berrybush", 45.0);
	int avoidBerriesMin = rmCreateTypeDistanceConstraint("avoid berries min ", "berrybush", 6.0);
	int avoidCaribouFar = rmCreateTypeDistanceConstraint("avoid deer far", "caribou", 54.0);
	int avoidCaribou = rmCreateTypeDistanceConstraint("avoid  deer", "caribou", 36.0);
	int avoidCaribouShort = rmCreateTypeDistanceConstraint("avoid  deer short", "caribou", 34.0);
	int avoidCaribouMin = rmCreateTypeDistanceConstraint("avoid deer min", "caribou", 10.0);
	int avoidMoose = rmCreateTypeDistanceConstraint("moose avoids moose", "moose", 40.0);
	int avoidMooseShort = rmCreateTypeDistanceConstraint("moose avoids moose short", "moose", 28.0);
	int avoidMooseMin = rmCreateTypeDistanceConstraint("moose avoids moose min", "moose", 10.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 20.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 10.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 28.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 36.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", classGold, 4.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", classGold, 42);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", classGold, 56.0-4*cNumberNonGaiaPlayers); //70
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very ", classGold, 65.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 4.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 35.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 40.0);
	int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center  Very Far", "townCenter", 80.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 70.0-1*cNumberNonGaiaPlayers); // 92-5*cNumberNonGaiaPlayers
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 45.0);
	//	int avoidTownCenterMed=rmCreateTypeDistanceConstraint("resources avoid Town Center med", "townCenter", 40.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("resources avoid Town Center short", "townCenter", 24.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint("resources avoid Town Center", "townCenter", 40.0);
	int avoidNativesMin = rmCreateClassDistanceConstraint("stuff avoids natives min", classNative, 2.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("stuff avoids natives short", classNative, 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", classNative, 8.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", classNative, 12.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("avoid start resources", classStartingResource, 9.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid start resources short", classStartingResource, 5.0);


	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("far avoid impassable land", "Land", false, 20.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 4.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 10.0);
	int avoidPatch = rmCreateClassDistanceConstraint("patch avoid patch", classPatch, 10.0+2*cNumberNonGaiaPlayers);
	int avoidPatch2 = rmCreateClassDistanceConstraint("patch avoid patch 2", classPatch2, 10.0+2*cNumberNonGaiaPlayers);
	int avoidPatch3 = rmCreateClassDistanceConstraint("patch avoid patch 3", classPatch3, 5.0);
	int avoidStone = rmCreateClassDistanceConstraint("stone avoid stone", classWaterStone, 5.0);


	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", classStartingUnit, 35.0);


	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 5.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 8.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", importantItem, 10.0);


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
					rmPlacePlayer(1, 0.90, 0.66);
					rmPlacePlayer(2, 0.10, 0.66);
				}
				else
				{
					rmPlacePlayer(2, 0.90, 0.66);
					rmPlacePlayer(1, 0.10, 0.66);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.92, 0.58, 0.80, 0.74, 0.00, 0.18);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.08, 0.58, 0.20, 0.74, 0.00, 0.18);
				}
				else // 3v3, 4v4
				{
					if (teamZeroCount == 3)
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.94, 0.51, 0.78, 0.79, 0.00, 0.18);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.06, 0.51, 0.22, 0.79, 0.00, 0.18);
					}
					else
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.94, 0.49, 0.78, 0.81, 0.00, 0.18);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.06, 0.49, 0.22, 0.81, 0.00, 0.18);
					}
				}
			}
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.90, 0.66, 0.89, 0.66, 0.00, 0.18);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmPlacePlayersLine(0.08, 0.58, 0.20, 0.74, 0.00, 0.18);
						else
							rmPlacePlayersLine(0.06, 0.51, 0.22, 0.79, 0.00, 0.18);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.10, 0.66, 0.11, 0.66, 0.00, 0.18);

						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmPlacePlayersLine(0.92, 0.58, 0.80, 0.74, 0.00, 0.18);
						else
							rmPlacePlayersLine(0.94, 0.51, 0.78, 0.79, 0.00, 0.18);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.08, 0.58, 0.20, 0.74, 0.00, 0.18);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.94, 0.51, 0.78, 0.79, 0.00, 0.18);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.06, 0.51, 0.22, 0.79, 0.00, 0.18);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.92, 0.58, 0.80, 0.74, 0.00, 0.18);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.94, 0.51, 0.78, 0.79, 0.00, 0.18);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.06, 0.51, 0.22, 0.79, 0.00, 0.18);
				}
			}
		}
		else // FFA
		{
			rmPlacePlayer(1, 0.92, 0.60);
			rmPlacePlayer(2, 0.08, 0.60);
			rmPlacePlayer(3, 0.50, 0.26);
			rmPlacePlayer(4, 0.50, 0.66);
			rmPlacePlayer(5, 0.74, 0.76);
			rmPlacePlayer(6, 0.26, 0.76);
			rmPlacePlayer(7, 0.70, 0.10);
			rmPlacePlayer(8, 0.30, 0.10);
		}


	// **************************************************************************************************

	// Text
	rmSetStatusText("",0.10);

	// ******************************** MAP LAYOUT & NATURE DESIGN **************************************

	// Cliff
	int cliffID = rmCreateArea("cliff border");
	rmSetAreaWarnFailure(cliffID, false);
	rmSetAreaObeyWorldCircleConstraint(cliffID, false);
	if (cNumberNonGaiaPlayers >=4)
		rmSetAreaSize(cliffID, 0.080, 0.080);
	else
		rmSetAreaSize(cliffID, 0.084, 0.084);
	rmSetAreaLocation(cliffID, 0.50, 1.00);
	rmAddAreaInfluenceSegment(cliffID, 0.20, 1.00, 0.80, 1.00);
	rmAddAreaInfluenceSegment(cliffID, 0.50, 1.00, 0.50, 0.88);
	rmSetAreaCliffType(cliffID, "rocky mountain2"); //
	rmSetAreaTerrainType(cliffID, "rockies\groundsnow1_roc");
//	rmSetAreaCliffPainting(cliffID, true, true, true, 0.5 , false); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaCliffEdge(cliffID, 5, 0.0816, 0.0, 0.30, 1); //0.30
	rmSetAreaCliffHeight(cliffID, 7, 0.0, 1.0);
	rmSetAreaCoherence(cliffID, 0.72);
	rmSetAreaSmoothDistance(cliffID, 6+cNumberNonGaiaPlayers);
	rmAddAreaToClass(cliffID, classCliff);
	rmBuildArea(cliffID);

	int avoidCliff = rmCreateAreaDistanceConstraint("avoid cliff", cliffID, 2.0);
	int stayInCliff = rmCreateAreaMaxDistanceConstraint("stay in cliff", cliffID, 0.0);
	int avoidRamp = rmCreateCliffRampDistanceConstraint("avoid ramp", cliffID, 12.0);
	int avoidRampShort = rmCreateCliffRampDistanceConstraint("avoid ramp short", cliffID, 3.0);


	//Inuksuk sculpture
	int inusksukID =  rmCreateObjectDef("inuksuk sculpture");
	rmAddObjectDefItem(inusksukID, "inuksuk", 1, 1.0);
//	rmSetObjectDefMinDistance(inusksukID, 0);
//	rmSetObjectDefMaxDistance(inusksukID, rmXFractionToMeters(0.0));
	rmPlaceObjectDefAtLoc(inusksukID, 0, 0.50, 0.88);

	int inuksukareaID = rmCreateArea("inuksuk area");
	rmSetAreaSize(inuksukareaID, 0.006, 0.006); // rmAreaTilesToFraction(5000), rmAreaTilesToFraction(5000));
	rmSetAreaWarnFailure(inuksukareaID, false);
	rmSetAreaObeyWorldCircleConstraint(inuksukareaID, false);
//	rmSetAreaTerrainType(inuksukareaID, "yukon\ground4_yuk");
	rmSetAreaCoherence(inuksukareaID, 1.0);
	rmSetAreaLocation (inuksukareaID, 0.50, 0.88);
	rmBuildArea(inuksukareaID);

	int avoidInuksuk = rmCreateAreaDistanceConstraint("avoid inuksuk", inuksukareaID, 12.0);

	// Embankment
	int embankmentID = rmCreateArea("embankment");
	rmSetAreaSize(embankmentID, 0.07, 0.07); // rmAreaTilesToFraction(5000), rmAreaTilesToFraction(5000));
	rmSetAreaWarnFailure(embankmentID, false);
	rmSetAreaObeyWorldCircleConstraint(embankmentID, false);
	rmSetAreaCoherence(embankmentID, 1.0);
	rmSetAreaLocation (embankmentID, 0.50, 1.00);
	rmSetAreaBaseHeight(embankmentID, 7.0);
	rmSetAreaElevationType(embankmentID, cElevTurbulence);
	rmSetAreaElevationMinFrequency(embankmentID, 0.035);
	rmSetAreaElevationOctaves(embankmentID, 2);
	rmSetAreaElevationPersistence(embankmentID, 0.6);
	rmSetAreaElevationVariation(embankmentID, 4.0);
	rmSetAreaHeightBlend(embankmentID, 2.0);
	rmAddAreaConstraint (embankmentID, stayInCliff);
	rmAddAreaConstraint (embankmentID, avoidImpassableLandMed);
	rmBuildArea(embankmentID);


	//River
	int riverID = rmRiverCreate(-1, "yukon river", 8, 8, 6+0.25*cNumberNonGaiaPlayers, 6+0.25*cNumberNonGaiaPlayers); //  (-1, "yukon river", 6, 8, 5+0.5*cNumberNonGaiaPlayers, 5+0.5*cNumberNonGaiaPlayers
	rmRiverAddWaypoint(riverID, 0.00, 0.15);
	rmRiverAddWaypoint(riverID, 0.25, 0.34);
//	rmRiverAddWaypoint(riverID, 0.50, 0.34);
	rmRiverAddWaypoint(riverID, 0.50, 0.28);
	rmRiverAddWaypoint(riverID, 0.75, 0.34);
	rmRiverAddWaypoint(riverID, 1.00, 0.15);
//	rmRiverSetBankNoiseParams(riverID, 0.00, 0, 0.0, 0.0, 0.0, 0.0);
	rmRiverSetShallowRadius(riverID, 9+2*cNumberNonGaiaPlayers);
/*
	rmRiverAddShallow(riverID, 0.12);
	rmRiverAddShallow(riverID, 0.30);
	rmRiverAddShallow(riverID, 0.44);	// old shallow pattern
	rmRiverAddShallow(riverID, 0.56);
	rmRiverAddShallow(riverID, 0.70);
	rmRiverAddShallow(riverID, 0.88);
*/
	rmRiverAddShallow(riverID, 0.20);
	rmRiverAddShallow(riverID, 0.30);
	rmRiverAddShallow(riverID, 0.38);
	rmRiverAddShallow(riverID, 0.50);
	rmRiverAddShallow(riverID, 0.62);
	rmRiverAddShallow(riverID, 0.70);
	rmRiverAddShallow(riverID, 0.80);
	rmRiverBuild(riverID);

	// Forest area
	int forestareaID = rmCreateArea("forest area");
	rmSetAreaSize(forestareaID, 0.23, 0.23); // rmAreaTilesToFraction(5000), rmAreaTilesToFraction(5000));
	rmSetAreaWarnFailure(forestareaID, false);
	rmSetAreaObeyWorldCircleConstraint(forestareaID, false);
	rmSetAreaMix(forestareaID, "yukon grass");
	rmAddAreaTerrainLayer(forestareaID, "yukon\ground5_yuk", 0, 2);
//	rmAddAreaTerrainLayer(forestareaID, "yukon\ground5_yuk", 0, 5);
	rmSetAreaCoherence(forestareaID, 0.45);
	rmSetAreaSmoothDistance(forestareaID, 4+1*cNumberNonGaiaPlayers);
	rmSetAreaLocation (forestareaID, 0.50, 0.00);
	rmAddAreaInfluenceSegment(forestareaID, 0.00, 0.00, 1.00, 0.00);
	rmSetAreaBaseHeight(forestareaID, 1.0);
	rmSetAreaElevationType(forestareaID, cElevTurbulence);
	rmSetAreaElevationMinFrequency(forestareaID, 0.035);
	rmSetAreaElevationOctaves(forestareaID, 3);
	rmSetAreaElevationPersistence(forestareaID, 0.65);
	rmSetAreaElevationVariation(forestareaID, 4.0);
	rmAddAreaConstraint (forestareaID, avoidImpassableLand);
	rmBuildArea(forestareaID);

	int avoidForestArea = rmCreateAreaDistanceConstraint("avoid forest area", forestareaID, 3.0);
	int avoidForestAreaMed = rmCreateAreaDistanceConstraint("avoid forest area med", forestareaID, 8.0);
	int avoidForestAreaFar = rmCreateAreaDistanceConstraint("avoid forest area far", forestareaID, 30.0);
	int stayInForestArea = rmCreateAreaMaxDistanceConstraint("stay in forest area", forestareaID, 0.0);

	// Terrain patch1
	for (i=0; < rmRandInt(4,5)+rmRandInt(1,2)*cNumberNonGaiaPlayers)
    {
        int patchID = rmCreateArea("patch grass snow"+i);
        rmSetAreaWarnFailure(patchID, false);
        rmSetAreaSize(patchID, rmAreaTilesToFraction(140), rmAreaTilesToFraction(180)); // 40 80
		rmSetAreaTerrainType(patchID, "yukon\ground4_yuk");
		rmAddAreaTerrainLayer(patchID, "yukon\ground9_yuk", 0, 1);
        rmAddAreaToClass(patchID, classPatch);
        rmSetAreaMinBlobs(patchID, 1);
        rmSetAreaMaxBlobs(patchID, 4);
        rmSetAreaMinBlobDistance(patchID, 16.0);
        rmSetAreaMaxBlobDistance(patchID, 36.0);
        rmSetAreaCoherence(patchID, 0.0);
		rmSetAreaSmoothDistance(patchID, 2+1*cNumberNonGaiaPlayers);
		rmAddAreaConstraint(patchID, avoidImpassableLand);
		rmAddAreaConstraint(patchID, avoidPatch);
		rmAddAreaConstraint(patchID, avoidForestAreaFar);
		rmAddAreaConstraint(patchID, avoidCliff);
        rmBuildArea(patchID);
    }


	// *****************************************************************************************************

	// Text
	rmSetStatusText("",0.20);

	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.5;
		float yLoc = 0.96;
		float walk = 0.03;

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}

	// ****************************************** TRADE ROUTE **********************************************

	int tradeRouteID = rmCreateTradeRoute();
	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);
	rmAddObjectDefConstraint(socketID, avoidImpassableLand);

	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.10, 0.00);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.28, 0.26);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.42, 0.14);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.08);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.58, 0.14);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.72, 0.26);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.90, 0.00);

	bool placedTradeRouteA = rmBuildTradeRoute(tradeRouteID, "dirt");

	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.08);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.28);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.72);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.92);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	// *************************************************************************************************************

	// Text
	rmSetStatusText("",0.30);

	// ******************************************** NATIVES *************************************************

	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;

	nativeID0 = rmCreateGrouping("Nootka village 1", "native nootka village "+4); // NW
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
	rmAddGroupingToClass(nativeID0, classNative);
	if (cNumberTeams <= 2)
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.65, 0.76); // NW
	else
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.72, 0.40); // NW

	nativeID1 = rmCreateGrouping("Nootka village 2", "native nootka village "+4); // SW
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
	rmAddGroupingToClass(nativeID1, classNative);
	if (cNumberTeams <= 2)
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.35, 0.76); // SW
	else
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.28, 0.40); // SW

	// ******************************************************************************************************

	// Text
	rmSetStatusText("",0.40);

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
	rmSetObjectDefMaxDistance(TCID, 5.0);


	// Starting mines
	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "minetin", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 16.0);
	rmSetObjectDefMaxDistance(playergoldID, 18.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidGoldType);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);


	// Starting trees1
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "TreeYukonSnow", rmRandInt(2,2), 4.0); //6,6 5.0
    rmSetObjectDefMinDistance(playerTreeID, 10);
    rmSetObjectDefMaxDistance(playerTreeID, 12);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);

	// Starting trees2
	int playerTree2ID = rmCreateObjectDef("player trees 2");
//  rmAddObjectDefItem(playerTree2ID, "TreeNorthwestTerritory", rmRandInt(1,2), 4.0);
	rmAddObjectDefItem(playerTree2ID, "TreeYukonSnow", rmRandInt(8,8), 9.0); //6,6 5.0
    rmSetObjectDefMinDistance(playerTree2ID, 18);
    rmSetObjectDefMaxDistance(playerTree2ID, 20);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
	rmAddObjectDefToClass(playerTree2ID, classForest);
	rmAddObjectDefConstraint(playerTree2ID, avoidForestShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTree2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResources);

	// Berry patches
	int berryPatchType = rmRandInt(1,2);

    int berryPatchID = rmCreateGrouping("Berry patch", "BerryPatch "+berryPatchType);
    rmSetGroupingMinDistance(berryPatchID, 11.0);
    rmSetGroupingMaxDistance(berryPatchID, 13.0);
	rmAddGroupingToClass(berryPatchID, classStartingResource);
	rmAddGroupingConstraint(berryPatchID, avoidTradeRoute);
	rmAddGroupingConstraint(berryPatchID, avoidImpassableLand);
    rmAddGroupingConstraint(berryPatchID, avoidStartingResources);
	rmAddGroupingConstraint(berryPatchID, avoidEdge);


	// Starting herd
	int playercaribouID = rmCreateObjectDef("starting caribou");
	rmAddObjectDefItem(playercaribouID, "caribou", rmRandInt(6,6), 5.0);
	rmSetObjectDefMinDistance(playercaribouID, 14.0);
	rmSetObjectDefMaxDistance(playercaribouID, 18.0);
	rmSetObjectDefCreateHerd(playercaribouID, false);
	rmAddObjectDefToClass(playercaribouID, classStartingResource);
	rmAddObjectDefConstraint(playercaribouID, avoidTradeRoute);
	rmAddObjectDefConstraint(playercaribouID, avoidImpassableLand);
	rmAddObjectDefConstraint(playercaribouID, avoidNativesShort);
	rmAddObjectDefConstraint(playercaribouID, avoidStartingResources);
	rmAddObjectDefConstraint(playercaribouID, avoidCliff);
	rmAddObjectDefConstraint(playercaribouID, avoidEdge);

	// 2nd herd
	int caribou2ID = rmCreateObjectDef("2nd caribou");
    rmAddObjectDefItem(caribou2ID, "caribou", rmRandInt(6,6), 5.0);
    rmSetObjectDefMinDistance(caribou2ID, 28);
    rmSetObjectDefMaxDistance(caribou2ID, 32);
	rmAddObjectDefToClass(caribou2ID, classStartingResource);
	rmSetObjectDefCreateHerd(caribou2ID, true);
	rmAddObjectDefConstraint(caribou2ID, avoidCaribou);
	rmAddObjectDefConstraint(caribou2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(caribou2ID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(caribou2ID, avoidNativesShort);
	rmAddObjectDefConstraint(caribou2ID, avoidStartingResources);
	rmAddObjectDefConstraint(caribou2ID, avoidCliff);
	rmAddObjectDefConstraint(caribou2ID, avoidEdge);

	// 3rd herd
	int caribou3ID = rmCreateObjectDef("3rd caribou");
    rmAddObjectDefItem(caribou3ID, "caribou", rmRandInt(6,6), 5.0);
    rmSetObjectDefMinDistance(caribou3ID, 32);
    rmSetObjectDefMaxDistance(caribou3ID, 38);
	rmAddObjectDefToClass(caribou3ID, classStartingResource);
	rmSetObjectDefCreateHerd(caribou3ID, true);
	rmAddObjectDefConstraint(caribou3ID, avoidTurkey); //Short
	rmAddObjectDefConstraint(caribou3ID, avoidCaribouShort);
	rmAddObjectDefConstraint(caribou3ID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(caribou3ID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(caribou3ID, avoidNativesShort);
	rmAddObjectDefConstraint(caribou3ID, avoidStartingResources);
	rmAddObjectDefConstraint(caribou3ID, avoidCliff);
	rmAddObjectDefConstraint(caribou3ID, avoidEdge);


	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 22.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 26.0);
//	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	int nugget0count = rmRandInt (1,2);


	// ******** Place ********

	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceGroupingAtLoc(berryPatchID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playercaribouID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(caribou2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(caribou3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
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
	rmSetStatusText("",0.50);

	// ************************************** COMMON RESOURCES ****************************************

	// ********** Mines ***********

		int middlegoldcount = 1+0.5*cNumberNonGaiaPlayers;
		int cliffsilvercount = 2+0.5*cNumberNonGaiaPlayers;
		int forestsilvercount = 2+1*cNumberNonGaiaPlayers;
		int FFAsilvercount = 3+1.5*cNumberNonGaiaPlayers;

	//Central gold mines
	for(i=0; < middlegoldcount)
	{
		int middlegoldID = rmCreateObjectDef("central gold mine"+i);
		rmAddObjectDefItem(middlegoldID, "Minegold", 1, 0.0);
		rmSetObjectDefMinDistance(middlegoldID, rmXFractionToMeters(0.04));
		rmSetObjectDefMaxDistance(middlegoldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(middlegoldID, classGold);
		rmAddObjectDefConstraint(middlegoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(middlegoldID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(middlegoldID, avoidNatives);
		rmAddObjectDefConstraint(middlegoldID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(middlegoldID, avoidGold);
		rmAddObjectDefConstraint(middlegoldID, avoidForestArea);
		rmAddObjectDefConstraint(middlegoldID, centralbox);
//		rmAddObjectDefConstraint(middlegoldID, avoidTownCenterVeryFar);
		rmPlaceObjectDefAtLoc(middlegoldID, 0, 0.50, 0.45);
	}

	if (cNumberTeams <= 2)
	{

		//Silver mines cliff
		for(i=0; < cliffsilvercount)
		{
			int cliffsilverID = rmCreateObjectDef("silver in the cliff"+i);
			rmAddObjectDefItem(cliffsilverID, "Mine", 1, 0.0);
			rmSetObjectDefMinDistance(cliffsilverID, rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(cliffsilverID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(cliffsilverID, classGold);
			rmAddObjectDefConstraint(cliffsilverID, avoidTradeRoute);
			rmAddObjectDefConstraint(cliffsilverID, avoidImpassableLand);
			rmAddObjectDefConstraint(cliffsilverID, avoidNatives);
			rmAddObjectDefConstraint(cliffsilverID, avoidTradeRouteSocket);
			rmAddObjectDefConstraint(cliffsilverID, avoidGoldFar);
			rmAddObjectDefConstraint(cliffsilverID, avoidTownCenterFar);
			rmAddObjectDefConstraint(cliffsilverID, avoidRamp);
	//		rmAddObjectDefConstraint(cliffsilverID, avoidEdge);
			rmAddObjectDefConstraint(cliffsilverID, avoidInuksuk);
			rmAddObjectDefConstraint(cliffsilverID, stayInCliff);
			if (cNumberTeams <= 2)
			{
				if (i <1)
					rmAddObjectDefConstraint(cliffsilverID, stayNorth);
				else if (i < 2)
					rmAddObjectDefConstraint(cliffsilverID, staySouth);
			}
			rmPlaceObjectDefAtLoc(cliffsilverID, 0, 0.50, 0.50);
		}

		//Silver mines forest
		for(i=0; < forestsilvercount)
		{
			int forestsilverID = rmCreateObjectDef("silver in the forest"+i);
			rmAddObjectDefItem(forestsilverID, "Mine", 1, 0.0);
			rmSetObjectDefMinDistance(forestsilverID, rmXFractionToMeters(0.05));
			rmSetObjectDefMaxDistance(forestsilverID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(forestsilverID, classGold);
			rmAddObjectDefConstraint(forestsilverID, avoidTradeRoute);
			rmAddObjectDefConstraint(forestsilverID, avoidImpassableLand);
			rmAddObjectDefConstraint(forestsilverID, avoidNatives);
			rmAddObjectDefConstraint(forestsilverID, avoidTradeRouteSocket);
			rmAddObjectDefConstraint(forestsilverID, avoidGoldFar);
	//		rmAddObjectDefConstraint(forestsilverID, avoidTownCenterVeryFar);
			rmAddObjectDefConstraint(forestsilverID, avoidEdge);
			rmAddObjectDefConstraint(forestsilverID, stayInForestArea);
			rmAddObjectDefConstraint(forestsilverID, stayForestBox);
			rmPlaceObjectDefAtLoc(forestsilverID, 0, 0.50, 0.00);
		}
	}
	else
	{
		//Silver mines FFA
		for(i=0; < FFAsilvercount)
		{
			int FFAsilverID = rmCreateObjectDef("silver for FFA"+i);
			rmAddObjectDefItem(FFAsilverID, "Mine", 1, 0.0);
			rmSetObjectDefMinDistance(FFAsilverID, rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(FFAsilverID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(FFAsilverID, classGold);
			rmAddObjectDefConstraint(FFAsilverID, avoidTradeRoute);
			rmAddObjectDefConstraint(FFAsilverID, avoidImpassableLand);
			rmAddObjectDefConstraint(FFAsilverID, avoidNatives);
			rmAddObjectDefConstraint(FFAsilverID, avoidTradeRouteSocket);
			rmAddObjectDefConstraint(FFAsilverID, avoidGoldFar);
			rmAddObjectDefConstraint(FFAsilverID, avoidTownCenterFar);
			rmAddObjectDefConstraint(FFAsilverID, avoidRamp);
	//		rmAddObjectDefConstraint(FFAsilverID, avoidEdge);
			rmAddObjectDefConstraint(FFAsilverID, avoidInuksuk);
			rmPlaceObjectDefAtLoc(FFAsilverID, 0, 0.50, 0.50);
		}
	}

	// ****************************

	// Text
	rmSetStatusText("",0.60);

	// ********** Forest **********

	// Snow forest
	int snowforestcount = 6+6*cNumberNonGaiaPlayers; // 14*cNumberNonGaiaPlayers/2
	int stayInSnowForest = -1;

	for (i=0; < snowforestcount)
	{
		int snowforestID = rmCreateArea("snow forest"+i);
		rmSetAreaWarnFailure(snowforestID, false);
//		rmSetAreaObeyWorldCircleConstraint(snowforestID, false);
		rmSetAreaSize(snowforestID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(150));
		rmSetAreaTerrainType(snowforestID, "yukon\groundforestsnow_yuk");
		rmSetAreaMinBlobs(snowforestID, 2);
		rmSetAreaMaxBlobs(snowforestID, 5);
		rmSetAreaMinBlobDistance(snowforestID, 14.0);
		rmSetAreaMaxBlobDistance(snowforestID, 30.0);
		rmSetAreaCoherence(snowforestID, 0.1);
		rmSetAreaSmoothDistance(snowforestID, 5);
//		rmAddAreaToClass(snowforestID, classForest);
		rmAddAreaConstraint(snowforestID, avoidForest);
		rmAddAreaConstraint(snowforestID, avoidTradeRouteShort);
		rmAddAreaConstraint(snowforestID, avoidImpassableLandShort);
		rmAddAreaConstraint(snowforestID, avoidNatives);
		rmAddAreaConstraint(snowforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(snowforestID, avoidGoldTypeShort);
		rmAddAreaConstraint(snowforestID, avoidForestArea);
		rmAddAreaConstraint(snowforestID, avoidCliff);
		rmAddAreaConstraint(snowforestID, avoidRamp);
//		rmAddAreaConstraint(snowforestID, avoidEdge);
		rmAddAreaConstraint(snowforestID, avoidTownCenterShort);
		rmAddAreaConstraint(snowforestID, avoidStartingResourcesShort);
		rmAddAreaConstraint(snowforestID, avoidCaribouMin);
		rmAddAreaConstraint(snowforestID, avoidNuggetMin);
		rmBuildArea(snowforestID);

		stayInSnowForest = rmCreateAreaMaxDistanceConstraint("stay in south forest"+i, snowforestID, 0);

		for (j=0; < rmRandInt(6,7)) //20,22
		{
			int snowtreeID = rmCreateObjectDef("snow tree"+i+" "+j);
			rmAddObjectDefItem(snowtreeID, "treeyukonsnow", rmRandInt(2,3), 6.0); // 1,2 nderbrushSnow
			rmAddObjectDefItem(snowtreeID, "underbrushSnow", rmRandInt(1,2), 6.0);
			rmSetObjectDefMinDistance(snowtreeID, 0);
			rmSetObjectDefMaxDistance(snowtreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(snowtreeID, classForest);
			rmAddObjectDefConstraint(snowtreeID, stayInSnowForest);
			rmAddObjectDefConstraint(snowtreeID, avoidImpassableLandShort);
			rmPlaceObjectDefAtLoc(snowtreeID, 0, 0.40, 0.40);
		}

	}

	// *********** Berries ************

	int berriescount = 2+1*cNumberNonGaiaPlayers;
	int stayInBerriesArea = -1;

	for (i=0; < berriescount)
	{
		int berriesareaID = rmCreateArea("berries area"+i);
		rmSetAreaWarnFailure(berriesareaID, false);
		rmSetAreaObeyWorldCircleConstraint(berriesareaID, false);
		rmSetAreaSize(berriesareaID, rmAreaTilesToFraction(90), rmAreaTilesToFraction(100));
		rmSetAreaTerrainType(berriesareaID, "yukon\ground6_yuk");
//		rmSetAreaMinBlobs(berriesareaID, 2);
//		rmSetAreaMaxBlobs(berriesareaID, 3);
//		rmSetAreaMinBlobDistance(berriesareaID, 14.0);
//		rmSetAreaMaxBlobDistance(berriesareaID, 24.0);
		rmSetAreaCoherence(berriesareaID, 0.70);
//		rmSetAreaSmoothDistance(berriesareaID, 2);
		rmAddAreaConstraint(berriesareaID, avoidForestMin);
		rmAddAreaConstraint(berriesareaID, avoidTradeRouteShort);
		rmAddAreaConstraint(berriesareaID, avoidTradeRouteSocket);
		rmAddAreaConstraint(berriesareaID, avoidImpassableLandFar);
		rmAddAreaConstraint(berriesareaID, avoidNatives);
		rmAddAreaConstraint(berriesareaID, avoidGoldTypeShort);
		rmAddAreaConstraint(berriesareaID, stayInForestArea);
		rmAddAreaConstraint(berriesareaID, avoidEdge);
		rmAddAreaConstraint(berriesareaID, avoidStartingResources);
		rmAddAreaConstraint(berriesareaID, avoidBerries);
		rmAddAreaConstraint(berriesareaID, avoidCaribouMin);
		rmBuildArea(berriesareaID);

		stayInBerriesArea = rmCreateAreaMaxDistanceConstraint("stay in berries area"+i, berriesareaID, 0);

//		for(j=0; < northberriescount)
//		{
			int berriesID = rmCreateObjectDef("forest berry"+i);
			rmAddObjectDefItem(berriesID, "berrybush", rmRandInt(7,7), 6.0);
	//		if (teamZeroCount == 1 && teamOneCount == 1)
			rmSetObjectDefMinDistance(berriesID, rmXFractionToMeters(0.00));
			rmSetObjectDefMaxDistance(berriesID, rmXFractionToMeters(0.50));
	//		rmAddObjectDefConstraint(berriesID, avoidImpassableLand);
	//		rmAddObjectDefConstraint(berriesID, avoidNatives);
	//		rmAddObjectDefConstraint(berriesID, avoidTradeRouteShort);
			rmAddObjectDefConstraint(berriesID, avoidTradeRouteSocket);
	//	//	rmAddObjectDefConstraint(berriesID, avoidGoldTypeShort);
	//		rmAddObjectDefConstraint(berriesID, avoidForestMin);
	//		rmAddObjectDefConstraint(berriesID, avoidMooseMin);
	//		rmAddObjectDefConstraint(berriesID, avoidBerries);
			rmAddObjectDefConstraint(berriesID, stayInBerriesArea);
	//		rmAddObjectDefConstraint(berriesID, avoidEdge);
			rmPlaceObjectDefAtLoc(berriesID, 0, 0.50, 0.50);
//		}
	}

	// ********************************

	// Text
	rmSetStatusText("",0.70);


	// ********************************

	// Grass forest
	int grassforestcount = 4+4*cNumberNonGaiaPlayers; // 6
	int stayInGrassForest = -1;

	for (i=0; < grassforestcount)
	{
		int grassforestID = rmCreateArea("grass forest"+i);
		rmSetAreaWarnFailure(grassforestID, false);
//		rmSetAreaObeyWorldCircleConstraint(grassforestID, false);
		rmSetAreaSize(grassforestID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(160));
		rmSetAreaTerrainType(grassforestID, "yukon\groundforest_yuk");
		rmSetAreaMinBlobs(grassforestID, 2);
		rmSetAreaMaxBlobs(grassforestID, 5);
		rmSetAreaMinBlobDistance(grassforestID, 14.0);
		rmSetAreaMaxBlobDistance(grassforestID, 30.0);
		rmSetAreaCoherence(grassforestID, 0.1);
		rmSetAreaSmoothDistance(grassforestID, 5);
//		rmAddAreaToClass(grassforestID, classForest);
		rmAddAreaConstraint(grassforestID, avoidForestShort);
		rmAddAreaConstraint(grassforestID, avoidTradeRouteShort);
		rmAddAreaConstraint(grassforestID, avoidImpassableLandShort);
		rmAddAreaConstraint(grassforestID, avoidNatives);
		rmAddAreaConstraint(grassforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(grassforestID, avoidGoldTypeShort);
		rmAddAreaConstraint(grassforestID, stayInForestArea);
//		rmAddAreaConstraint(grassforestID, avoidEdge);
		rmAddAreaConstraint(grassforestID, avoidStartingResources);
		rmAddAreaConstraint(grassforestID, avoidCaribouMin);
		rmAddAreaConstraint(grassforestID, avoidBerriesMin);
		rmBuildArea(grassforestID);

		stayInGrassForest = rmCreateAreaMaxDistanceConstraint("stay in north forest"+i, grassforestID, 0);

		for (j=0; < rmRandInt(6,7)) //18,20
		{
			int grasstreeID = rmCreateObjectDef("north tree"+i+" "+j);
			rmAddObjectDefItem(grasstreeID, "treeyukonsnow", rmRandInt(1,1), 3.0);
			rmAddObjectDefItem(grasstreeID, "treeyukon", rmRandInt(2,3), 4.0); // 1,2
			rmSetObjectDefMinDistance(grasstreeID, 0);
			rmSetObjectDefMaxDistance(grasstreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(grasstreeID, classForest);
			rmAddObjectDefConstraint(grasstreeID, stayInGrassForest);
			rmAddObjectDefConstraint(grasstreeID, avoidImpassableLandShort);
			rmPlaceObjectDefAtLoc(grasstreeID, 0, 0.40, 0.40);
		}

	}

	// ********** Random trees to fill **********

	// Random trees
	int randomforestcount = 4+3*cNumberNonGaiaPlayers;

	for (i=0; < randomforestcount)
	{
		int RandomtreeID = rmCreateObjectDef("random trees"+i);
		rmAddObjectDefItem(RandomtreeID, "treeyukonsnow", rmRandInt(1,3), 6.0); //
		rmSetObjectDefMinDistance(RandomtreeID, 0);
		rmSetObjectDefMaxDistance(RandomtreeID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(RandomtreeID, classForest);
		rmAddObjectDefConstraint(RandomtreeID, avoidNatives);
		rmAddObjectDefConstraint(RandomtreeID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(RandomtreeID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidRamp);
		rmAddObjectDefConstraint(RandomtreeID, avoidTownCenter);
		rmAddObjectDefConstraint(RandomtreeID, avoidStartingResources);
		rmAddObjectDefConstraint(RandomtreeID, avoidCaribouMin);
		rmAddObjectDefConstraint(RandomtreeID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidMooseMin);
		rmAddObjectDefConstraint(RandomtreeID, avoidBerriesMin);
		rmAddObjectDefConstraint(RandomtreeID, avoidForestShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidForestArea);
		rmPlaceObjectDefAtLoc(RandomtreeID, 0, 0.5, 0.5);
	}

	// ********************************

	// Text
	rmSetStatusText("",0.80);

	// ********** Herds ***********

	//Snow caribou
	int snowcariboucount = 5+3*cNumberNonGaiaPlayers;

	for(i=1; < snowcariboucount+1)
	{
		int snowcaribouID = rmCreateObjectDef("snow caribou"+i);
		rmAddObjectDefItem(snowcaribouID, "caribou", rmRandInt(5,6), 5.0);
		rmSetObjectDefMinDistance(snowcaribouID, 0.0);
		rmSetObjectDefMaxDistance(snowcaribouID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(snowcaribouID, true);
		rmAddObjectDefConstraint(snowcaribouID, avoidImpassableLand);
		rmAddObjectDefConstraint(snowcaribouID, avoidNativesMin);
		rmAddObjectDefConstraint(snowcaribouID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(snowcaribouID, avoidTradeRoute);
		rmAddObjectDefConstraint(snowcaribouID, avoidGoldMed);
		rmAddObjectDefConstraint(snowcaribouID, avoidForestAreaMed);
		rmAddObjectDefConstraint(snowcaribouID, avoidCliff);
		rmAddObjectDefConstraint(snowcaribouID, avoidRampShort);
		rmAddObjectDefConstraint(snowcaribouID, avoidTownCenter);
		rmAddObjectDefConstraint(snowcaribouID, avoidForestMin);
		rmAddObjectDefConstraint(snowcaribouID, avoidCaribou);
		rmAddObjectDefConstraint(snowcaribouID, avoidEdge);
		rmPlaceObjectDefAtLoc(snowcaribouID, 0, 0.5, 0.5);
	}

	//Grass mooses
	int grassmoosecount = 2+2*cNumberNonGaiaPlayers;

	for(i=0; < grassmoosecount)
	{
		int grassmooseID = rmCreateObjectDef("grass moose"+i);
		rmAddObjectDefItem(grassmooseID, "moose", rmRandInt(4,5), 7.0);
		rmSetObjectDefMinDistance(grassmooseID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(grassmooseID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(grassmooseID, true);
		rmAddObjectDefConstraint(grassmooseID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(grassmooseID, avoidNativesShort);
		rmAddObjectDefConstraint(grassmooseID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(grassmooseID, avoidTownCenterFar);
		rmAddObjectDefConstraint(grassmooseID, avoidForestMin);
		rmAddObjectDefConstraint(grassmooseID, avoidCaribouShort);
		rmAddObjectDefConstraint(grassmooseID, avoidMoose);
		rmAddObjectDefConstraint(grassmooseID, avoidBerriesMin);
		rmAddObjectDefConstraint(grassmooseID, avoidEdge);
		rmAddObjectDefConstraint(grassmooseID, stayInForestArea);
		rmPlaceObjectDefAtLoc(grassmooseID, 0, 0.50, 0.50);
	}

	// ********************************

	// Text
	rmSetStatusText("",0.90);

	// ********** Treasures ***********

	int nugget1count = 6+3*cNumberNonGaiaPlayers;
	int	nugget2count = -1;

	// Treasures snow
	int Nugget1ID = rmCreateObjectDef("nugget 1");
	rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget1ID, 0);
    rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.6));
	rmAddObjectDefConstraint(Nugget1ID, avoidNugget);
	rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(Nugget1ID, avoidNatives);
	rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLand);
	rmAddObjectDefConstraint(Nugget1ID, avoidCliff);
	rmAddObjectDefConstraint(Nugget1ID, avoidRamp);
	rmAddObjectDefConstraint(Nugget1ID, avoidGoldTypeShort);
//	rmAddObjectDefConstraint(Nugget1ID, avoidForestAreaFar);
	rmAddObjectDefConstraint(Nugget1ID, avoidTownCenter);
	rmAddObjectDefConstraint(Nugget1ID, avoidCaribouMin);
	rmAddObjectDefConstraint(Nugget1ID, avoidBerriesMin);
	rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);
	rmAddObjectDefConstraint(Nugget1ID, avoidEdge);
	for (i=0; < nugget1count)
	{
		rmSetNuggetDifficulty(2,3);
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);
	}
	// ********************************
	// Text
	rmSetStatusText("",1.00);



} //END

	