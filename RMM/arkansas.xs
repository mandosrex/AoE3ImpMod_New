// ESOC ARKANSAS (1v1, TEAM, FFA)
// designed by Garja

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{

	if (false) {
		sqrt(1);
	}

	
	// Text
	// These status text lines are used to manually animate the map generation progress bar
	rmSetStatusText("",0.01); 
	
	// ************************************** GENERAL FEATURES *****************************************
	
	// Picks the map size
	int playerTiles=13000; //12000
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=12000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=11000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=10000;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	
	// Picks a default water height
	rmSetSeaLevel(1.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	rmSetMapElevationParameters(cElevTurbulence, 0.05, 4, 0.5, 4.5); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);
	
	// Picks default terrain and water
	rmSetSeaType("bayou");
//	rmEnableLocalWater(false);
	rmSetBaseTerrainMix("newengland_grass"); // nwt_forest
	rmTerrainInitialize("new_england\ground1_ne", 3.0); // NWterritory\ground_grass5_nwt
	rmSetMapType("newEngland"); 
	rmSetMapType("grass");
	rmSetMapType("land");
	rmSetMapType("namerica");
	rmSetLightingSet("carolina"); //

	// Make the corners.
	rmSetWorldCircleConstraint(true);
	
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Cherokee");
	subCiv1 = rmGetCivID("Seminoles");
	rmSetSubCiv(0, "Cherokee");
	rmSetSubCiv(1, "Seminoles");
//	rmEchoInfo("subCiv0 is Cherokee "+subCiv0);
//	rmEchoInfo("subCiv1 is Seminoles "+subCiv1);
//	string nativeName0 = "native Cherokee village";
//	string nativeName1 = "native Seminoles village";
	

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	rmDefineClass("classHill");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classWaterStone = rmDefineClass("stonewater");
	int classGrass = rmDefineClass("grass");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int importantItem = rmDefineClass("importantItem");
	int classNative = rmDefineClass("natives");
	int classCliff = rmDefineClass("Cliffs");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	
	// ******************************************************************************************

	// Choose Mercs
	chooseMercs();

	// Text
	rmSetStatusText("",0.10);
	
	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other
   
   
	// Cardinal Directions & Map placement
	int Southeastconstraint = rmCreatePieConstraint("southeastMapConstraint", 0.5, 0.5, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(90), rmDegreesToRadians(180));
	int Northwestconstraint = rmCreatePieConstraint("northwestMapConstraint", 0.5, 0.5, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(270), rmDegreesToRadians(360));
	int Southwestconstraint = rmCreatePieConstraint("southwestMapConstraint", 0.5, 0.5, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(180), rmDegreesToRadians(270));
	int Northeastconstraint = rmCreatePieConstraint("northeastMapConstraint", 0.39, 0.39, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(0), rmDegreesToRadians(90));
	int Southnarrowconstraint = rmCreatePieConstraint("SouthstripConstraint", 0.5, 0.5, rmZFractionToMeters(0.15), rmZFractionToMeters(0.50), rmDegreesToRadians(160), rmDegreesToRadians(195));
	int Northnarrowconstraint = rmCreatePieConstraint("NorthstripConstraint", 0.5, 0.5, rmZFractionToMeters(0.15), rmZFractionToMeters(0.50), rmDegreesToRadians(355), rmDegreesToRadians(20));
	
	int Southeastsideconstraint = rmCreatePieConstraint("southeastsideConstraint", 0.5, 0.5, rmXFractionToMeters(0.32), rmXFractionToMeters(0.50), rmDegreesToRadians(90), rmDegreesToRadians(180));
	int Northwestsideconstraint = rmCreatePieConstraint("northwestsideConstraint", 0.5, 0.5, rmXFractionToMeters(0.32), rmXFractionToMeters(0.50), rmDegreesToRadians(270), rmDegreesToRadians(360));
	int Southwestsideconstraint = rmCreatePieConstraint("southwestsideConstraint", 0.5, 0.5, rmXFractionToMeters(0.32), rmXFractionToMeters(0.50), rmDegreesToRadians(180), rmDegreesToRadians(270));
	int Northeastsideconstraint = rmCreatePieConstraint("northeastsideConstraint", 0.5, 0.5, rmXFractionToMeters(0.32), rmXFractionToMeters(0.50), rmDegreesToRadians(0), rmDegreesToRadians(90));
	
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.46), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.4,0.4,rmXFractionToMeters(0.24), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.4,0.4,rmXFractionToMeters(0.0), rmXFractionToMeters(0.14), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayEastclose = rmCreatePieConstraint("Stay East Close", 0.5, 0.5, rmZFractionToMeters(0.38), rmZFractionToMeters(0.50), rmDegreesToRadians(45), rmDegreesToRadians(135));
	int stayEastveryclose = rmCreatePieConstraint("Stay East Closer", 0.9, 0.5, 0.0, rmZFractionToMeters(0.12), rmDegreesToRadians(180), rmDegreesToRadians(360));
	int stayEdge = rmCreatePieConstraint("Stay Edge",0.5,0.5,rmXFractionToMeters(0.42), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int northEdge = rmCreatePieConstraint("North Edge",0.70,0.70,rmXFractionToMeters(0.2), rmXFractionToMeters(0.30), rmDegreesToRadians(0),rmDegreesToRadians(90)); 
//	int avoidWesthalf = rmCreateAreaDistanceConstraint("avoid west", WestID, 185.0); 
	int staySouthHalf = rmCreatePieConstraint("SouthHalfConstraint", 0.59, 0.59, 0.0, rmZFractionToMeters(0.60), rmDegreesToRadians(135), rmDegreesToRadians(315));
	int stayNorthHalf = rmCreatePieConstraint("NorthHalfConstraint", 0.61, 0.61, 0.0, rmZFractionToMeters(0.60), rmDegreesToRadians(315), rmDegreesToRadians(135));
	int staySouthWest = rmCreatePieConstraint("SouthWestConstraint", 0.37, 0.37, 0.0, rmZFractionToMeters(0.60), rmDegreesToRadians(235), rmDegreesToRadians(30));
	int staySouthEast = rmCreatePieConstraint("SouthEastConstraint", 0.37, 0.37, 0.0, rmZFractionToMeters(0.60), rmDegreesToRadians(60), rmDegreesToRadians(215));
	int stayNorthWest = rmCreatePieConstraint("NorthWestConstraint", 0.50, 0.50, 0.0, rmZFractionToMeters(0.60), rmDegreesToRadians(315), rmDegreesToRadians(5));
	int stayNorthEast = rmCreatePieConstraint("NorthEastConstraint", 0.50, 0.50, 0.0, rmZFractionToMeters(0.60), rmDegreesToRadians(85), rmDegreesToRadians(135));
	int stayNorthMiddle = rmCreatePieConstraint("NorthMiddleConstraint", 0.50, 0.50, 0.0, rmZFractionToMeters(0.60), rmDegreesToRadians(22), rmDegreesToRadians(68));
	
	
	// Resource avoidance
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", classForest, 40.0); //15.0
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", classForest, 30.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", classForest, 22.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", classForest, 5.0);
	int avoidTurkey = rmCreateTypeDistanceConstraint("food avoids food", "turkey", 28.0);
	int avoidTurketShort = rmCreateTypeDistanceConstraint("food avoids food short", "turkey", 24.0);
	int avoidBerries = rmCreateTypeDistanceConstraint("avoid berries ", "berrybush", 72.0);
	int avoidBerriesMin = rmCreateTypeDistanceConstraint("avoid berries min ", "berrybush", 10.0);
	int avoidDeerFar = rmCreateTypeDistanceConstraint("avoid deer far", "deer", 54.0);
	int avoidDeer = rmCreateTypeDistanceConstraint("avoid  deer", "deer", 52.0);
	int avoidDeerShort = rmCreateTypeDistanceConstraint("avoid  deer short", "deer", 40.0);
	int avoidDeerMin = rmCreateTypeDistanceConstraint("avoid deer min", "deer", 10.0);
	int avoidElk = rmCreateTypeDistanceConstraint("elk avoids elk", "elk", 65.0);
	int avoidElkShort = rmCreateTypeDistanceConstraint("elk avoids elk short", "elk", 28.0);
	int avoidElkMin = rmCreateTypeDistanceConstraint("elk avoids elk min", "elk", 10.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 10.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 15.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far", "gold", 36.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("avoid gold min", classGold, 4.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("avoid gold med", "gold", 10.0);
	int avoidGold = rmCreateClassDistanceConstraint ("avoid gold", classGold, 30.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("avoid gold far", classGold, 66.0); //70
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very ", classGold, 68.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 4.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 42.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 45.0);
	int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center  Very Far", "townCenter", 68.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 50.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 44.0);
	//	int avoidTownCenterMed=rmCreateTypeDistanceConstraint("resources avoid Town Center med", "townCenter", 40.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("resources avoid Town Center short", "townCenter", 24.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint("resources avoid Town Center", "townCenter", 40.0);
	int avoidNativesMin = rmCreateClassDistanceConstraint("stuff avoids natives min", classNative, 2.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("stuff avoids natives short", classNative, 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", classNative, 8.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", classNative, 12.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("avoid start resources", classStartingResource, 8.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid start resources short", classStartingResource, 5.0);
	

	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int avoidImpassableLandLong=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 25.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 3.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 10.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 10);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 25.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 3.0);
	int avoidPatch = rmCreateClassDistanceConstraint("patch avoid patch", rmClassID("patch"), 5.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("patch avoid patch2", rmClassID("patch2"), 5.0);
	int avoidStone = rmCreateClassDistanceConstraint("stone avoid stone", rmClassID("stonewater"), 5.0);
	int avoidGrass = rmCreateClassDistanceConstraint("grass avoid grass", rmClassID("grass"), 5.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid class cliff", rmClassID("Cliffs"), 7.0);
	int avoidCliffFar = rmCreateClassDistanceConstraint("avoid class cliff far", rmClassID("Cliffs"), 12.0);

	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);
		
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 6.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 8.0);
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
					rmPlacePlayer(1, 0.66, 0.20);
					rmPlacePlayer(2, 0.20, 0.66);
				}
				else
				{
					rmPlacePlayer(2, 0.66, 0.20);
					rmPlacePlayer(1, 0.20, 0.66);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.23, 0.75, 0.14, 0.58, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.75, 0.23, 0.58, 0.14, 0.00, 0.20);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.25, 0.78, 0.10, 0.52, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.78, 0.25, 0.52, 0.10, 0.00, 0.20);
				}
			}
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.21, 0.67, 0.20, 0.66, 0.00, 0.20);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmPlacePlayersLine(0.75, 0.23, 0.58, 0.14, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.78, 0.25, 0.52, 0.10, 0.00, 0.20);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.67, 0.21, 0.66, 0.20, 0.00, 0.20);

						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmPlacePlayersLine(0.23, 0.75, 0.14, 0.58, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.25, 0.78, 0.10, 0.52, 0.00, 0.20);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.23, 0.75, 0.14, 0.58, 0.00, 0.20);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.78, 0.25, 0.52, 0.10, 0.00, 0.20);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.25, 0.78, 0.10, 0.52, 0.00, 0.20);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.75, 0.23, 0.58, 0.14, 0.00, 0.20);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.25, 0.78, 0.10, 0.52, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.78, 0.25, 0.52, 0.10, 0.00, 0.20);
				}
			}
		}
		else // FFA
		{
			rmSetTeamSpacingModifier(0.25);
			rmSetPlacementSection(0.375, 0.875);
			rmPlacePlayersCircular(0.40, 0.40, 0.0);
		}


	// *************************************************************************************************************
	
	// Text
	rmSetStatusText("",0.20);
	
	// ******************************************** NATURE DESIGN **************************************************
	
	// Plateau
	int plateauID = rmCreateArea("plateau");
	rmSetAreaSize(plateauID, 0.50, 0.50); // rmAreaTilesToFraction(5000), rmAreaTilesToFraction(5000));  
	rmSetAreaWarnFailure(plateauID, false);
	rmSetAreaObeyWorldCircleConstraint(plateauID, false);
	rmSetAreaCoherence(plateauID, 1.0);
	rmSetAreaLocation (plateauID, 0.75, 0.75);
	rmSetAreaBaseHeight(plateauID, 1.0);
/*	rmSetAreaElevationType(plateauID, cElevTurbulence);
	rmSetAreaElevationVariation(plateauID, 5.0);
	rmSetAreaElevationMinFrequency(plateauID, 0.05);
	rmSetAreaElevationOctaves(plateauID, 4);
	rmSetAreaElevationPersistence(plateauID, 0.8);
	rmSetAreaHeightBlend(plateauID, 1.0);
*/	rmAddAreaConstraint (plateauID, avoidWater);
//	rmAddAreaToClass(cliffID, rmClassID("Cliffs"));
	rmBuildArea(plateauID);


	//River
	int riverID = rmRiverCreate(-1, "new england lake", 11+0.5*cNumberNonGaiaPlayers, 14, 4+cNumberNonGaiaPlayers/2, 4+cNumberNonGaiaPlayers/2); //  (-1, "new england lake", 18, 14, 5, 5)
	rmRiverAddWaypoint(riverID, 0.15, 1.00); 
	rmRiverAddWaypoint(riverID, 0.62, 0.62); 
	rmRiverAddWaypoint(riverID, 1.00, 0.15);
	rmRiverSetBankNoiseParams(riverID, 0.00, 0, 0.0, 0.0, 0.0, 0.0);
	rmRiverSetShallowRadius(riverID, 38);
	rmRiverAddShallow(riverID, 0.0);
	rmRiverAddShallow(riverID, 0.2);
	rmRiverAddShallow(riverID, 0.4);
	rmRiverAddShallow(riverID, 0.6);
	rmRiverAddShallow(riverID, 0.8);
	rmRiverAddShallow(riverID, 1.0);
	rmRiverBuild(riverID);

	
	// Cliff
	int cliffID = rmCreateArea("cliff");
//	rmSetAreaSize(cliffID, 0.13, 0.13); // rmAreaTilesToFraction(5000), rmAreaTilesToFraction(5000));  
	rmSetAreaSize(cliffID, 0.28, 0.28);
	rmSetAreaWarnFailure(cliffID, false);
	rmSetAreaObeyWorldCircleConstraint(cliffID, false);
	rmSetAreaCliffType(cliffID, "New England Inland Grass"); // new england inland grass
	rmSetAreaCliffPainting(cliffID, true, true, true, 0.5 , false); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaCliffHeight(cliffID, 6, 0.0, 0.8); 
	if (cNumberNonGaiaPlayers > 4)
		rmSetAreaCliffEdge(cliffID, 7, 0.065, 0.0, 0.30, 1); //0.30
	else
		rmSetAreaCliffEdge(cliffID, 4, 0.11, 0.0, 0.30, 1); //0.30
//	rmSetAreaCliffEdge(cliffID, 1, 0.50, 0.0, 0.50, 2);
	rmSetAreaCoherence(cliffID, 1.0);
	rmAddAreaToClass(cliffID, rmClassID("Cliffs"));
	rmAddAreaConstraint(cliffID, avoidWaterShort);
//	rmAddAreaConstraint(cliffID, stayNearWater);
	rmSetAreaLocation(cliffID, 0.8, 0.8);
//	rmSetAreaBaseHeight(cliffID, 6);
	rmSetAreaHeightBlend(cliffID, 1.0);
	int avoidCliffShort = rmCreateAreaDistanceConstraint("avoid cliff short", cliffID, 5.0);
	int avoidRamp = rmCreateCliffRampDistanceConstraint("avoid ramp", cliffID, 18.0);
	int avoidRampShort = rmCreateCliffRampDistanceConstraint("avoid ramp short", cliffID, 10.0);

	rmBuildArea(cliffID);
		

	// Terrain patch1
	for (i=0; < 30*cNumberNonGaiaPlayers)
    {
        int patchID = rmCreateArea("patch grass light "+i);
        rmSetAreaWarnFailure(patchID, false);
        rmSetAreaSize(patchID, rmAreaTilesToFraction(60), rmAreaTilesToFraction(100));
		rmSetAreaTerrainType(patchID, "new_england\ground2_cliff_ne");
//		rmPaintAreaTerrain(patchID);
//		rmAddAreaTerrainLayer(patchID, "carolinas\grass3", 0, 1);
        rmAddAreaToClass(patchID, rmClassID("patch"));
        rmSetAreaMinBlobs(patchID, 1);
        rmSetAreaMaxBlobs(patchID, 5);
        rmSetAreaMinBlobDistance(patchID, 16.0);
        rmSetAreaMaxBlobDistance(patchID, 40.0);
        rmSetAreaCoherence(patchID, 0.0);
		rmAddAreaConstraint(patchID, avoidImpassableLandShort);
		rmAddAreaConstraint(patchID, avoidPatch);
        rmBuildArea(patchID); 
    }
	
	// Water stones
	for (i=0; < 10*cNumberNonGaiaPlayers)
	{
		int StoneID = rmCreateObjectDef("water stone"+i);
		rmAddObjectDefItem(StoneID, "RiverPropsNWTerritory", rmRandInt(2,4), 4.0); 
		rmSetObjectDefMinDistance(StoneID, 0);
		rmSetObjectDefMaxDistance(StoneID, rmXFractionToMeters(0.35));
		rmAddObjectDefToClass(StoneID, rmClassID("stonewater"));
		rmAddObjectDefConstraint(StoneID, avoidStone);
		rmAddObjectDefConstraint(StoneID, stayInWater);
		rmPlaceObjectDefAtLoc(StoneID, 0, 0.60, 0.60);
	}
   
	// Grass
	for (i=0; < 50*cNumberNonGaiaPlayers)
	{
		int GrassID = rmCreateObjectDef("grass short"+i);
		rmAddObjectDefItem(GrassID, "PropGrassShort", rmRandInt(3,5), 7.0); 
		rmSetObjectDefMinDistance(GrassID, 0);
		rmSetObjectDefMaxDistance(GrassID, rmXFractionToMeters(0.6));
		rmAddObjectDefToClass(GrassID, rmClassID("grass"));
		rmAddObjectDefConstraint(GrassID, avoidGrass);
		rmAddObjectDefConstraint(GrassID, avoidImpassableLandShort);
		rmPlaceObjectDefAtLoc(GrassID, 0, 0.50, 0.50);
	}
	

	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.5;
		float yLoc = 0.5;
		float walk = 0.03;

		if (randLoc == 2) {
			xLoc = 0.75;
			yLoc = 0.75;
		}

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
	rmSetObjectDefMaxDistance(socketID, 6.0);

	
	if (cNumberTeams <= 2) 
	{
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.48, 0.00);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.24, 0.24);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.00, 0.48); 
	}
	else
	{
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.98, 0.50);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.74, 0.74);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.98); 
	}
	
	bool placedTradeRouteA = rmBuildTradeRoute(tradeRouteID, "dirt");
//	if(placedTradeRouteA == false)
//	rmEchoError("Failed to place trade route 1");
//	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.08);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	if (cNumberNonGaiaPlayers > 4)
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.28);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	if (cNumberNonGaiaPlayers > 4)
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.72);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.92);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);


	// ******************************************************************************************************
	
	// Text
	rmSetStatusText("",0.30);
	
	// ******************************************** NATIVES *************************************************
	
	
	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
		
	nativeID0 = rmCreateGrouping("Cherokee village", "native Cherokee village "+5); // NW
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
//	rmAddGroupingConstraint(nativeID0, avoidImpassableLand);
	rmAddGroupingToClass(nativeID0, classNative);
//  rmAddGroupingToClass(nativeID0, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID0, avoidNatives);
		
	nativeID2 = rmCreateGrouping("Cherokee village 2", "native Cherokee village "+2); // NE
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
//	rmAddGroupingConstraint(nativeID2, avoidImpassableLand);
	rmAddGroupingToClass(nativeID2, classNative);
//  rmAddGroupingToClass(nativeID2, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID2, avoidNatives);
	
	nativeID1 = rmCreateGrouping("Seminole village 4", "native seminole village "+4); // SW
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
//  rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
	rmAddGroupingToClass(nativeID1, classNative);
//  rmAddGroupingToClass(nativeID1, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID1, avoidNatives);
		
	nativeID3 = rmCreateGrouping("Seminole village", "native seminole village "+1); // SE
    rmSetGroupingMinDistance(nativeID3, 0.00);
    rmSetGroupingMaxDistance(nativeID3, 0.00);
//  rmAddGroupingConstraint(nativeID3, avoidImpassableLand);
	rmAddGroupingToClass(nativeID3, classNative);
//  rmAddGroupingToClass(nativeID3, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID3, avoidNatives);
		
	if (cNumberTeams <= 2) 
	{
		if (teamZeroCount < 2 && teamOneCount < 2)
		{
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.64, 0.86); // NW
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.86, 0.64); // NE
//			rmPlaceGroupingAtLoc(nativeID1, 0, 0.26, 0.42); // SW
//			rmPlaceGroupingAtLoc(nativeID3, 0, 0.42, 0.26); // SE
		}
		else
		{
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.64, 0.84); // NW
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.84, 0.64); // NE
//			rmPlaceGroupingAtLoc(nativeID1, 0, 0.26, 0.42); // SW
//			rmPlaceGroupingAtLoc(nativeID3, 0, 0.42, 0.26); // SE
		}
	}
	else
	{
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.40, 0.60); // NW
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.60, 0.40); // NE
//		rmPlaceGroupingAtLoc(nativeID1, 0, 0.26, 0.42); // SW
//		rmPlaceGroupingAtLoc(nativeID3, 0, 0.42, 0.26); // SE
	}

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
	rmAddObjectDefItem(playergoldID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 14.0);
	rmSetObjectDefMaxDistance(playergoldID, 16.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidGoldType);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 30.0); //58
	rmSetObjectDefMaxDistance(playergold2ID, 32.0); //62
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergold2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldTypeFar);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold2ID, avoidCenter);
	
	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 3, 3.0);
	rmSetObjectDefMinDistance(playerberriesID, 12.0);
	rmSetObjectDefMaxDistance(playerberriesID, 14.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerberriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerberriesID, avoidNatives);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResources);
	
	// Starting trees1
	int playerTreeID = rmCreateObjectDef("player trees");
//  rmAddObjectDefItem(playerTreeID, "TreeNorthwestTerritory", rmRandInt(1,2), 4.0);
	rmAddObjectDefItem(playerTreeID, "TreeSaguenay", rmRandInt(8,8), 7.0); //6,6 5.0
    rmSetObjectDefMinDistance(playerTreeID, 18);
    rmSetObjectDefMaxDistance(playerTreeID, 20);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	
	// Starting trees2
	int playerTree2ID = rmCreateObjectDef("player trees 2");
//  rmAddObjectDefItem(playerTree2ID, "TreeNorthwestTerritory", rmRandInt(1,2), 4.0);
	rmAddObjectDefItem(playerTree2ID, "TreeSaguenay", rmRandInt(4,4), 4.0); //6,6 5.0
    rmSetObjectDefMinDistance(playerTree2ID, 12);
    rmSetObjectDefMaxDistance(playerTree2ID, 14);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
	rmAddObjectDefToClass(playerTree2ID, classForest);
	rmAddObjectDefConstraint(playerTree2ID, avoidForestShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTree2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResources);
	
	// Starting herd
	int playerturkeyID = rmCreateObjectDef("starting turkey");
	rmAddObjectDefItem(playerturkeyID, "turkey", rmRandInt(6,6), 5.0);
	rmSetObjectDefMinDistance(playerturkeyID, 14.0);
	rmSetObjectDefMaxDistance(playerturkeyID, 16.0);
	rmSetObjectDefCreateHerd(playerturkeyID, true);
	rmAddObjectDefToClass(playerturkeyID, classStartingResource);
	rmAddObjectDefConstraint(playerturkeyID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerturkeyID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerturkeyID, avoidNatives);
	rmAddObjectDefConstraint(playerturkeyID, avoidStartingResources);
		
	// 2nd herd
	int playerDeerID = rmCreateObjectDef("player deer");
    rmAddObjectDefItem(playerDeerID, "deer", rmRandInt(9,9), 7.0);
    rmSetObjectDefMinDistance(playerDeerID, 26);
    rmSetObjectDefMaxDistance(playerDeerID, 28);
	rmAddObjectDefToClass(playerDeerID, classStartingResource);
	rmSetObjectDefCreateHerd(playerDeerID, true);
	rmAddObjectDefConstraint(playerDeerID, avoidTurkey); //Short
	rmAddObjectDefConstraint(playerDeerID, avoidTradeRoute);
//	rmAddObjectDefConstraint(playerDeerID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerDeerID, avoidNatives);
	rmAddObjectDefConstraint(playerDeerID, avoidStartingResources);
	
/*	// 3rd herd
	int playerDeer2ID = rmCreateObjectDef("player deer2");
    rmAddObjectDefItem(playerDeer2ID, "deer", rmRandInt(8,8), 6.0);
    rmSetObjectDefMinDistance(playerDeer2ID, 28);
    rmSetObjectDefMaxDistance(playerDeer2ID, 34);
	rmAddObjectDefToClass(playerDeer2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerDeer2ID, true);
	rmAddObjectDefConstraint(playerDeer2ID, avoidTurkey); //Short
	rmAddObjectDefConstraint(playerDeer2ID, avoidDeerShort);
	rmAddObjectDefConstraint(playerDeer2ID, avoidCliffShort);
	rmAddObjectDefConstraint(playerDeer2ID, avoidTradeRouteShort);
//	rmAddObjectDefConstraint(playerDeer2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerDeer2ID, avoidNatives);
	rmAddObjectDefConstraint(playerDeer2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerDeer2ID, avoidEdge);
*/
	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 28.0);
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
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerturkeyID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerDeerID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playerDeer2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (nugget0count == 2)
			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
				
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
	
		int southgoldCount = 2+1*cNumberNonGaiaPlayers;  // 3,3 
		int northgoldCount = 1+1*cNumberNonGaiaPlayers;  // 3,3 
	
	//South mines
	for(i=0; < southgoldCount)
	{
		int southgoldID = rmCreateObjectDef("gold south half"+i);
		rmAddObjectDefItem(southgoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(southgoldID, rmXFractionToMeters(0.15));
		rmSetObjectDefMaxDistance(southgoldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(southgoldID, classGold);
		rmAddObjectDefConstraint(southgoldID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(southgoldID, avoidImpassableLand);
		rmAddObjectDefConstraint(southgoldID, avoidNatives);
		rmAddObjectDefConstraint(southgoldID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(southgoldID, avoidGoldVeryFar);
		rmAddObjectDefConstraint(southgoldID, staySouthHalf);
		rmAddObjectDefConstraint(southgoldID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(southgoldID, avoidEdge);
		rmAddObjectDefConstraint(southgoldID, avoidCliffFar);
		if (cNumberTeams <= 2 && teamZeroCount == 1 && teamOneCount == 1)
		{
			if (i == 0)
				rmAddObjectDefConstraint(southgoldID, staySouthWest);
			else if (i == 1)
				rmAddObjectDefConstraint(southgoldID, staySouthEast);
		}
		rmPlaceObjectDefAtLoc(southgoldID, 0, 0.28, 0.28);
	}
	
	//North mines
	for(i=0; < northgoldCount)
	{
		int northgoldID = rmCreateObjectDef("gold north half"+i);
		rmAddObjectDefItem(northgoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(northgoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(northgoldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(northgoldID, classGold);
		rmAddObjectDefConstraint(northgoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(northgoldID, avoidImpassableLandMed);
		rmAddObjectDefConstraint(northgoldID, avoidNatives);
		rmAddObjectDefConstraint(northgoldID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(northgoldID, avoidGoldFar);
		rmAddObjectDefConstraint(northgoldID, avoidWater);
//		rmAddObjectDefConstraint(northgoldID, avoidTownCenterFar);
		rmAddObjectDefConstraint(northgoldID, avoidRamp);
		rmAddObjectDefConstraint(northgoldID, avoidEdge);
		rmAddObjectDefConstraint(northgoldID, stayNorthHalf);
		if (cNumberTeams <= 2 && teamZeroCount == 1 && teamOneCount == 1)
		{
			if (i == 0)
				rmAddObjectDefConstraint(northgoldID, stayNorthWest);
			else if (i == 1)
				rmAddObjectDefConstraint(northgoldID, stayNorthEast);
			else
				rmAddObjectDefConstraint(northgoldID, stayNorthMiddle);
		}
		rmPlaceObjectDefAtLoc(northgoldID, 0, 0.66, 0.66);
	}
		
	// ****************************
	
	// Text
	rmSetStatusText("",0.60);
	
		// ********** Forest **********
	
	// South forest
	int southforestcount = 4+5*cNumberNonGaiaPlayers; // 14*cNumberNonGaiaPlayers/2
	int stayInSouthForest = -1;
	
	for (i=0; < southforestcount)
	{
		int southforestID = rmCreateArea("south forest"+i);
		rmSetAreaWarnFailure(southforestID, false);
//		rmSetAreaObeyWorldCircleConstraint(southforestID, false);
		rmSetAreaSize(southforestID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(130));
		rmSetAreaTerrainType(southforestID, "new_england\groundforest_ne");
		rmSetAreaMinBlobs(southforestID, 2);
		rmSetAreaMaxBlobs(southforestID, 5);
		rmSetAreaMinBlobDistance(southforestID, 14.0);
		rmSetAreaMaxBlobDistance(southforestID, 30.0);
		rmSetAreaCoherence(southforestID, 0.1);
		rmSetAreaSmoothDistance(southforestID, 5);
//		rmAddAreaToClass(southforestID, classForest);
		rmAddAreaConstraint(southforestID, avoidForest);
		rmAddAreaConstraint(southforestID, avoidTradeRouteShort);
		rmAddAreaConstraint(southforestID, avoidImpassableLandShort);
		rmAddAreaConstraint(southforestID, avoidNatives);
		rmAddAreaConstraint(southforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(southforestID, avoidGoldTypeShort);
		rmAddAreaConstraint(southforestID, staySouthHalf);
//		rmAddAreaConstraint(southforestID, avoidEdge);
		rmAddAreaConstraint(southforestID, avoidTownCenterShort);
		rmAddAreaConstraint(southforestID, avoidStartingResourcesShort);
		rmAddAreaConstraint(southforestID, avoidDeerMin); 
		rmAddAreaConstraint(southforestID, avoidNuggetMin);
		rmAddAreaConstraint(southforestID, avoidCliff);
		rmBuildArea(southforestID);
	
		stayInSouthForest = rmCreateAreaMaxDistanceConstraint("stay in south forest"+i, southforestID, 0);
	
		for (j=0; < rmRandInt(10,12)) //20,22
		{
			int southtreeID = rmCreateObjectDef("south tree"+i+" "+j);
			rmAddObjectDefItem(southtreeID, "TreeSaguenay", rmRandInt(2,3), 4.0); // 1,2
			rmSetObjectDefMinDistance(southtreeID, 0);
			rmSetObjectDefMaxDistance(southtreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(southtreeID, classForest);
			rmAddObjectDefConstraint(southtreeID, stayInSouthForest);	
			rmAddObjectDefConstraint(southtreeID, avoidImpassableLandShort);	
			rmPlaceObjectDefAtLoc(southtreeID, 0, 0.40, 0.40);
		}
		
	}
	
	// North forest
	int northforestcount = 4*cNumberNonGaiaPlayers*3/5; // 6
	int stayInNorthForest = -1;
	
	for (i=0; < northforestcount)
	{
		int northforestID = rmCreateArea("north forest"+i);
		rmSetAreaWarnFailure(northforestID, false);
//		rmSetAreaObeyWorldCircleConstraint(northforestID, false);
		rmSetAreaSize(northforestID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(110));
		rmSetAreaTerrainType(northforestID, "new_england\groundforest_ne");
		rmSetAreaMinBlobs(northforestID, 2);
		rmSetAreaMaxBlobs(northforestID, 5);
		rmSetAreaMinBlobDistance(northforestID, 14.0);
		rmSetAreaMaxBlobDistance(northforestID, 30.0);
		rmSetAreaCoherence(northforestID, 0.1);
		rmSetAreaSmoothDistance(northforestID, 5);
//		rmAddAreaToClass(northforestID, classForest);
		rmAddAreaConstraint(northforestID, avoidForest);
		rmAddAreaConstraint(northforestID, avoidTradeRouteShort);
		rmAddAreaConstraint(northforestID, avoidImpassableLandShort);
		rmAddAreaConstraint(northforestID, avoidNativesShort);
		rmAddAreaConstraint(northforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(northforestID, avoidGoldTypeShort);
		rmAddAreaConstraint(northforestID, stayNorthHalf);
		rmAddAreaConstraint(northforestID, avoidRamp); 
//		rmAddAreaConstraint(northforestID, avoidEdge);
		rmAddAreaConstraint(northforestID, avoidTownCenterShort);
		rmAddAreaConstraint(northforestID, avoidStartingResources);
		rmAddAreaConstraint(northforestID, avoidDeerMin); 
		rmBuildArea(northforestID);
	
		stayInNorthForest = rmCreateAreaMaxDistanceConstraint("stay in north forest"+i, northforestID, 0);
	
		for (j=0; < rmRandInt(8,10)) //18,20
		{
			int northtreeID = rmCreateObjectDef("north tree"+i+j);
			rmAddObjectDefItem(northtreeID, "TreeSaguenay", rmRandInt(2,3), 4.0); // 1,2
			rmSetObjectDefMinDistance(northtreeID, 0);
			rmSetObjectDefMaxDistance(northtreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(northtreeID, classForest);
			rmAddObjectDefConstraint(northtreeID, stayInNorthForest);	
			rmAddObjectDefConstraint(northtreeID, avoidImpassableLandShort);	
			rmPlaceObjectDefAtLoc(northtreeID, 0, 0.40, 0.40);
		}
		
	}
		
	// ********************************
	
	// Text
	rmSetStatusText("",0.70);
	
	// *********** Berries ************	
	
	//North berries
	int northberriescount = 2*cNumberNonGaiaPlayers/2;
	
	for(i=0; < northberriescount)
	{
		int northberryID = rmCreateObjectDef("north berry"+i);
		rmAddObjectDefItem(northberryID, "berrybush", rmRandInt(4,4), 4.0);
//		if (teamZeroCount == 1 && teamOneCount == 1)
			rmSetObjectDefMinDistance(northberryID, rmXFractionToMeters(0.18));
//		else
//			rmSetObjectDefMinDistance(northberryID, rmXFractionToMeters(0.10));
		rmSetObjectDefMaxDistance(northberryID, rmXFractionToMeters(0.7));
		rmAddObjectDefConstraint(northberryID, avoidImpassableLand);
		rmAddObjectDefConstraint(northberryID, avoidNatives);
		rmAddObjectDefConstraint(northberryID, avoidGoldType);
		rmAddObjectDefConstraint(northberryID, stayNorthHalf);
		rmAddObjectDefConstraint(northberryID, avoidForestMin);
//		rmAddObjectDefConstraint(northberryID, avoidElkMin); 
		rmAddObjectDefConstraint(northberryID, avoidBerries);
		rmAddObjectDefConstraint(northberryID, avoidRamp);
		rmAddObjectDefConstraint(northberryID, avoidEdge);
		rmPlaceObjectDefAtLoc(northberryID, 0, 0.75, 0.75);
	}	
	
	// ********************************
		
	// Text
	rmSetStatusText("",0.80);
	
	// ********** Random trees to fill **********
	
	// Random trees
	int randomforestcount = (8*cNumberNonGaiaPlayers/2-cNumberNonGaiaPlayers); 
	
	for (i=0; < randomforestcount)
	{	
		int RandomtreeID = rmCreateObjectDef("random trees"+i);
		rmAddObjectDefItem(RandomtreeID, "TreeSaguenay", rmRandInt(7,8), 6.0); // 4,5
		rmSetObjectDefMinDistance(RandomtreeID, 0);
		rmSetObjectDefMaxDistance(RandomtreeID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(RandomtreeID, classForest);
		rmAddObjectDefConstraint(RandomtreeID, avoidNatives);
		rmAddObjectDefConstraint(RandomtreeID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(RandomtreeID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidRamp);
		rmAddObjectDefConstraint(RandomtreeID, avoidTownCenterResources);
		rmAddObjectDefConstraint(RandomtreeID, avoidStartingResources);
		rmAddObjectDefConstraint(RandomtreeID, avoidDeerMin); 
		rmAddObjectDefConstraint(RandomtreeID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidElkMin);
		rmAddObjectDefConstraint(RandomtreeID, avoidBerriesMin);
		rmAddObjectDefConstraint(RandomtreeID, avoidForest);	
//		rmAddObjectDefConstraint(RandomtreeID, avoidCliff);
//		rmAddObjectDefConstraint(RandomtreeID, avoidEdge);
		rmPlaceObjectDefAtLoc(RandomtreeID, 0, 0.5, 0.5);
	}
	
	// ********************************

	// ********** Herds ***********

	//South deers
	int southdeercount = 4*cNumberNonGaiaPlayers;
	
	for(i=0; < southdeercount)
	{
		int southdeerID = rmCreateObjectDef("south deer"+i);
		rmAddObjectDefItem(southdeerID, "deer", rmRandInt(8,9), 7.0);
		rmSetObjectDefMinDistance(southdeerID, 0.0);
		rmSetObjectDefMaxDistance(southdeerID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(southdeerID, true);
//		rmAddObjectDefConstraint(southdeerID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(southdeerID, avoidNativesMin);
		rmAddObjectDefConstraint(southdeerID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(southdeerID, avoidGoldMed);
		rmAddObjectDefConstraint(southdeerID, staySouthHalf);
		rmAddObjectDefConstraint(southdeerID, avoidCliff);
		rmAddObjectDefConstraint(southdeerID, avoidCliffShort);
		rmAddObjectDefConstraint(southdeerID, avoidRampShort);
		rmAddObjectDefConstraint(southdeerID, avoidTownCenter);
		rmAddObjectDefConstraint(southdeerID, avoidForestMin);
		rmAddObjectDefConstraint(southdeerID, avoidDeer); 
		rmAddObjectDefConstraint(southdeerID, avoidEdgeMore);
		if (cNumberTeams <= 2 && teamZeroCount == 1 && teamOneCount == 1)
		{
			if (i == 0)
				rmAddObjectDefConstraint(southdeerID, staySouthWest);
			else if (i == 1)
				rmAddObjectDefConstraint(southdeerID, staySouthEast);
		}	
		rmPlaceObjectDefAtLoc(southdeerID, 0, 0.4, 0.4);
	}
	
	//North elks
	int northelkcount = (2*cNumberNonGaiaPlayers/2+cNumberNonGaiaPlayers/2);
	
	for(i=0; < northelkcount)
	{
		int northelkID = rmCreateObjectDef("north elk"+i);
		rmAddObjectDefItem(northelkID, "elk", rmRandInt(6,7), 7.0);
		rmSetObjectDefMinDistance(northelkID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(northelkID, rmXFractionToMeters(0.7));
		rmSetObjectDefCreateHerd(northelkID, true);
		rmAddObjectDefConstraint(northelkID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(northelkID, avoidNativesFar);
		rmAddObjectDefConstraint(northelkID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(northelkID, avoidTownCenterFar);
		rmAddObjectDefConstraint(northelkID, avoidForestMin);
		rmAddObjectDefConstraint(northelkID, avoidDeerShort); 
		rmAddObjectDefConstraint(northelkID, avoidElk); 
		rmAddObjectDefConstraint(northelkID, avoidEdge);
		rmAddObjectDefConstraint(northelkID, avoidRampShort);
		rmAddObjectDefConstraint(northelkID, stayNorthHalf);
		if (i == 0)
			rmAddObjectDefConstraint(northelkID, stayNorthWest);
		else if (i == 1)
			rmAddObjectDefConstraint(northelkID, stayNorthEast);
		rmPlaceObjectDefAtLoc(northelkID, 0, 0.85, 0.85);
	}	
	
	// ********************************
	
	// Text
	rmSetStatusText("",0.90);
	
	// ********** Treasures ***********
	
	// Treasures south	
	int NuggetsouthID = rmCreateObjectDef("South nugget"); 
	rmAddObjectDefItem(NuggetsouthID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(NuggetsouthID, 0);
    rmSetObjectDefMaxDistance(NuggetsouthID, rmXFractionToMeters(0.6));
	rmAddObjectDefConstraint(NuggetsouthID, avoidNuggetFar);
	rmAddObjectDefConstraint(NuggetsouthID, avoidNatives);
	rmAddObjectDefConstraint(NuggetsouthID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(NuggetsouthID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(NuggetsouthID, avoidImpassableLand);
	rmAddObjectDefConstraint(NuggetsouthID, avoidRamp);
	rmAddObjectDefConstraint(NuggetsouthID, avoidGoldTypeShort);
	rmAddObjectDefConstraint(NuggetsouthID, staySouthHalf);
	rmAddObjectDefConstraint(NuggetsouthID, avoidTownCenter);
	rmAddObjectDefConstraint(NuggetsouthID, avoidDeerMin); 
	rmAddObjectDefConstraint(NuggetsouthID, avoidBerriesMin);
	rmAddObjectDefConstraint(NuggetsouthID, avoidForestMin);
	rmAddObjectDefConstraint(NuggetsouthID, avoidEdge); 
	
	int nugget1count = -1;
	int	nugget2count = -1;
	
	if	(nugget0count == 1)
		nugget1count = 1+1*cNumberNonGaiaPlayers;
	else
		nugget1count = 1*cNumberNonGaiaPlayers;
	
	nugget2count = 3+1*cNumberNonGaiaPlayers; //2,2
	
	for (i=0; < nugget2count)
	{
		rmSetNuggetDifficulty(2,2);
		rmPlaceObjectDefAtLoc(NuggetsouthID, 0, 0.45, 0.45);
	}
	
	for (i=0; < nugget1count)
	{
		rmSetNuggetDifficulty(2,2);
		rmPlaceObjectDefAtLoc(NuggetsouthID, 0, 0.45, 0.45);
	}
	
	// Treasures north	
	int NuggetnorthID = rmCreateObjectDef("North nugget"); 
	rmAddObjectDefItem(NuggetnorthID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(NuggetnorthID, 0);
    rmSetObjectDefMaxDistance(NuggetnorthID, rmXFractionToMeters(0.6));
	rmAddObjectDefConstraint(NuggetnorthID, avoidNuggetFar);
	rmAddObjectDefConstraint(NuggetnorthID, avoidNatives);
	rmAddObjectDefConstraint(NuggetnorthID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(NuggetnorthID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(NuggetnorthID, avoidImpassableLand);
	rmAddObjectDefConstraint(NuggetnorthID, avoidGoldTypeShort);
	rmAddObjectDefConstraint(NuggetnorthID, stayNorthHalf);
	rmAddObjectDefConstraint(NuggetnorthID, avoidTownCenter);
	rmAddObjectDefConstraint(NuggetnorthID, avoidElkMin); 
	rmAddObjectDefConstraint(NuggetnorthID, avoidBerriesMin);
	rmAddObjectDefConstraint(NuggetnorthID, avoidForestMin);	
	rmAddObjectDefConstraint(NuggetnorthID, avoidRamp);
	rmAddObjectDefConstraint(NuggetsouthID, avoidCliff); 	
	rmAddObjectDefConstraint(NuggetnorthID, avoidEdge);

	int nugget3count = -1;
	nugget3count = rmRandInt(0,1)+0.5*cNumberNonGaiaPlayers;
	
	for (i=0; < nugget3count)
	{
		rmSetNuggetDifficulty(3,3);
		rmPlaceObjectDefAtLoc(NuggetnorthID, 0, 0.65, 0.65);
	}
	
	int nugget4count = -1;
	nugget4count = 1+0.5*cNumberNonGaiaPlayers;
	for (i=0; < nugget4count)
	{
		if (cNumberNonGaiaPlayers >= 4)
			rmSetNuggetDifficulty(3,4);
		else
			rmSetNuggetDifficulty(3,4);
		rmPlaceObjectDefAtLoc(NuggetnorthID, 0, 0.65, 0.65);
	}
	
	
	// ********************************

	// Text
	rmSetStatusText("",1.00);

	
} //END
	
	