// ESOC GREAT BASIN
// designed by Garja
// observer UI by Aizamk

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
	int playerTiles=10800;
	if (cNumberNonGaiaPlayers >= 4)
		playerTiles=10800;
	if (cNumberNonGaiaPlayers >= 6)
		playerTiles=10800;
	if (cNumberTeams > 2)
		playerTiles=10800;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(true);
	
	// Picks a default water height
	rmSetSeaLevel(3.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	rmSetMapElevationParameters(cElevTurbulence, 0.040, 1, 0.42, 5.0); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);
	
	// Picks default terrain and water
//	rmEnableLocalWater(false);
	rmSetBaseTerrainMix("california_grassrocks"); //
	rmTerrainInitialize("california\ground9_cal", 6.0); // ground8_cal
	rmSetMapType("california"); //
	rmSetMapType("desert");
	rmSetMapType("land");
	rmSetMapType("namerica");
	rmSetLightingSet("california"); //
	rmSetWindMagnitude(1.0);

	
	
	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);
	
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Klamath");
	rmSetSubCiv(0, "Klamath");
	subCiv1 = rmGetCivID("Navajo");
	rmSetSubCiv(1, "Navajo");


	

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classGrass = rmDefineClass("grass");
	int classWaterstone = rmDefineClass("stonewater");
	rmDefineClass("starting settlement");
	int classStartingUnit = rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int classNative = rmDefineClass("natives");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	int classCliff = rmDefineClass("classCliff");
	
	// ******************************************************************************************
	
	// Text
	rmSetStatusText("",0.05);
	
	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other
   
   
	// Cardinal Directions & Map placement
	int stayNWhalf = rmCreatePieConstraint("stay NW half", 0.5, 0.55, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(270), rmDegreesToRadians(90));
	int staySEhalf  = rmCreatePieConstraint("stay SE half", 0.5, 0.45, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(90), rmDegreesToRadians(270));
	
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.38), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.20), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.16), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayEdge = rmCreatePieConstraint("Stay Edge",0.5,0.5,rmXFractionToMeters(0.42), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	
	
	// Resource avoidance
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", classForest, 40.0); //15.0
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", classForest, 24.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", classForest, 22.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", classForest, 3.0);
	int avoidElkVeryFar = rmCreateTypeDistanceConstraint("avoid Elk very far", "Elk", 60.0);
	int avoidElkFar = rmCreateTypeDistanceConstraint("avoid Elk far", "Elk", 45.0);
	int avoidElk = rmCreateTypeDistanceConstraint("avoid Elk", "Elk", 40.0);
	int avoidElkShort = rmCreateTypeDistanceConstraint("avoid Elk short", "Elk", 25.0);
	int avoidElkMin = rmCreateTypeDistanceConstraint("avoid Elk min", "Elk", 6.0);
	int avoidBighornFar = rmCreateTypeDistanceConstraint("avoid Bighorn far", "bighornsheep", 70.0);
	int avoidBighorn = rmCreateTypeDistanceConstraint("avoid Bighorn", "bighornsheep", 45.0);
	int avoidBighornShort = rmCreateTypeDistanceConstraint("avoid Bighorn short", "bighornsheep", 16.0);
	int avoidBighornMin = rmCreateTypeDistanceConstraint("avoid Bighorn min", "bighornsheep", 6.0);
	int avoidDeer = rmCreateTypeDistanceConstraint("avoid Deer", "deer", 45.0);
	int avoidDeerMin = rmCreateTypeDistanceConstraint("avoid Deer min", "deer", 6.0);
	int avoidBerriesFar = rmCreateTypeDistanceConstraint("avoid berries far", "berrybush", 64.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 14.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 8.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 40.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 45.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", classGold, 4.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", classGold, 46.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", classGold, 66.0); //70
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very ", classGold, 74.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 4.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 45.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 50.0);
	int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center  Very Far", "townCenter", 68.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 56.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 50.0);
	int avoidTownCenterMed=rmCreateTypeDistanceConstraint("resources avoid Town Center med", "townCenter", 38.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("resources avoid Town Center short", "townCenter", 26.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint("resources avoid Town Center", "townCenter", 40.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("stuff avoids natives short", classNative, 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", classNative, 10.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", classNative, 12.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("avoid start resources", classStartingResource, 8.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid start resources short", classStartingResource, 5.0);
	
	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("far avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 3.0);
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("min avoid impassable land", "Land", false, 0.2);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 5.0+2.0*cNumberNonGaiaPlayers);
	int avoidPatch = rmCreateClassDistanceConstraint("patch avoid patch", classPatch, 10.0+2*cNumberNonGaiaPlayers);
	int avoidPatch2 = rmCreateClassDistanceConstraint("patch avoid patch2", classPatch2, 2.0+2*cNumberNonGaiaPlayers);
	int avoidStone = rmCreateClassDistanceConstraint("stone avoid stone", classWaterstone, 20.0+2*cNumberNonGaiaPlayers);
	int avoidGrass = rmCreateClassDistanceConstraint("grass avoid grass", classGrass, 5.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 10.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", classCliff, 2.0);
	int avoidCliffShort = rmCreateClassDistanceConstraint("avoid cliff short", classCliff, 5.0);
	
	
	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", classStartingUnit, 35.0);
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 5.0+0.2*cNumberNonGaiaPlayers);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 4.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 7.0);
   
	
	// ***********************************************************************************************
	
	// **************************************** PLACE PLAYERS ****************************************

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);


		if (cNumberTeams <= 2) // 1v1 and TEAM
		{
			if (teamZeroCount == 1 && teamOneCount == 1) // 1v1
			{
				float OneVOnePlacement=rmRandFloat(0.0, 0.9);
				if ( OneVOnePlacement < 0.5)
				{
					rmPlacePlayer(1, 0.68, 0.82);
					rmPlacePlayer(2, 0.32, 0.20);
				}
				else
				{
					rmPlacePlayer(2, 0.68, 0.82);
					rmPlacePlayer(1, 0.32, 0.20);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.045, 0.130); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.42, 0.42, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.545, 0.630); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.42, 0.42, 0);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.030, 0.210); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.42, 0.42, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.530, 0.710); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.42, 0.42, 0);
				}
			}
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.68, 0.82, 0.69, 0.81, 0.00, 0.00);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmSetPlacementSection(0.545, 0.625); //
						else
							rmSetPlacementSection(0.530, 0.710); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.42, 0.42, 0);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmSetPlacementSection(0.045, 0.125); //
						else
							rmSetPlacementSection(0.030, 0.210); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.42, 0.42, 0);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.32, 0.20, 0.31, 0.19, 0.00, 0.00);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.045, 0.130); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.42, 0.42, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.530, 0.710); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.42, 0.42, 0);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.030, 0.210); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.42, 0.42, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.545, 0.630); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.42, 0.42, 0);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.030, 0.210); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.42, 0.42, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.530, 0.710); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.42, 0.42, 0);
				}
			}
		}
		else // FFA
		{
			rmSetPlacementSection(0.600, 0.150);
		//	rmSetTeamSpacingModifier(0.25);
			rmPlacePlayersCircular(0.42, 0.42, 0.0);
		}

	
	// **************************************************************************************************
   
	// Text
	rmSetStatusText("",0.10);
	
	// ********************************* MAP LAYOUT & NATURE DESIGN *************************************
	
	if (cNumberTeams <= 2)
	{
		//NE desert area
		int NEareaID = rmCreateArea("NE area");
		rmSetAreaWarnFailure(NEareaID, false);
		rmSetAreaSize(NEareaID, 0.15, 0.15);
		rmSetAreaCoherence(NEareaID, 0.85);
		rmSetAreaSmoothDistance(NEareaID, 3+1*cNumberNonGaiaPlayers);
		rmSetAreaHeightBlend(NEareaID, 1.2);
	//	rmSetAreaElevationType(NEareaID, cElevTurbulence);
		rmSetAreaElevationVariation(NEareaID, 2.0);
	//	rmSetAreaElevationMinFrequency(NEareaID, 0.035);
	//	rmSetAreaElevationOctaves(NEareaID, 3);
	//	rmSetAreaElevationPersistence(NEareaID, 0.4);
		rmSetAreaLocation(NEareaID, 0.86, 0.36);
		rmAddAreaInfluenceSegment(NEareaID, 0.80, 0.24, 0.74, 0.48);
		rmAddAreaInfluenceSegment(NEareaID, 0.80, 0.30, 1.00, 0.34);
		rmAddAreaInfluenceSegment(NEareaID, 0.78, 0.32, 1.00, 0.00);
		rmAddAreaInfluenceSegment(NEareaID, 0.78, 0.32, 1.00, 0.24);
		rmAddAreaInfluenceSegment(NEareaID, 0.78, 0.38, 1.00, 0.48);
		rmSetAreaCliffHeight(NEareaID, -6.0, 0.0, 0.5); 
		rmSetAreaCliffEdge(NEareaID, 1, 0.20-0.008*cNumberNonGaiaPlayers, 0.0, 0.0, 1); 
		rmSetAreaCliffType(NEareaID, "california2"); 
		rmSetAreaMix(NEareaID, "california_desert2");
		rmSetAreaTerrainType(NEareaID, "california\desert3_cal");	
		rmAddAreaTerrainLayer(NEareaID, "california\desert5_cal", 0, 2);
		rmAddAreaTerrainLayer(NEareaID, "california\desert4_cal", 3, 6);
		rmSetAreaCliffPainting(NEareaID, true, false, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaObeyWorldCircleConstraint(NEareaID, false);
		rmAddAreaConstraint (NEareaID, avoidImpassableLandMin);
	//	rmSetAreaTerrainType(NEareaID, "new_england\ground2_cliff_ne"); // for testing	
		rmBuildArea(NEareaID);
		
		int stayInNEarea = rmCreateAreaMaxDistanceConstraint("stay in NE area", NEareaID, 0.0);
		int stayNearNEarea = rmCreateAreaMaxDistanceConstraint("stay near NE area", NEareaID, 50.0);
		int avoidNEarea = rmCreateAreaDistanceConstraint("avoid NE area", NEareaID, 2.0);
		int avoidNEareaMed = rmCreateAreaDistanceConstraint("avoid NE area medium", NEareaID, 10.0);
		
		//SW desert area
		int SWareaID = rmCreateArea("SW area");
		rmSetAreaWarnFailure(SWareaID, false);
		rmSetAreaSize(SWareaID, 0.15, 0.15);
		rmSetAreaCoherence(SWareaID, 0.85);
		rmSetAreaSmoothDistance(SWareaID, 3+1*cNumberNonGaiaPlayers);
		rmSetAreaHeightBlend(SWareaID, 1.2);
	//	rmSetAreaElevationType(SWareaID, cElevTurbulence);
		rmSetAreaElevationVariation(SWareaID, 2.0);
	//	rmSetAreaElevationMinFrequency(SWareaID, 0.035);
	//	rmSetAreaElevationOctaves(SWareaID, 3);
	//	rmSetAreaElevationPersistence(SWareaID, 0.4);
		rmSetAreaLocation(SWareaID, 0.14, 0.64);
		rmAddAreaInfluenceSegment(SWareaID, 0.20, 0.76, 0.26, 0.52);
		rmAddAreaInfluenceSegment(SWareaID, 0.20, 0.70, 0.00, 0.66);
		rmAddAreaInfluenceSegment(SWareaID, 0.22, 0.68, 0.00, 1.00);
		rmAddAreaInfluenceSegment(SWareaID, 0.22, 0.68, 0.00, 0.76);
		rmAddAreaInfluenceSegment(SWareaID, 0.22, 0.62, 0.00, 0.52);
		rmSetAreaCliffHeight(SWareaID, -6.0, 0.0, 0.5); 
		rmSetAreaCliffEdge(SWareaID, 1, 0.20-0.008*cNumberNonGaiaPlayers, 0.0, 0.0, 1); 
		rmSetAreaCliffType(SWareaID, "california2"); 
		rmSetAreaMix(SWareaID, "california_desert3");
		rmSetAreaTerrainType(SWareaID, "california\desert3_cal");	
		rmAddAreaTerrainLayer(SWareaID, "california\desert5_cal", 0, 2);
		rmAddAreaTerrainLayer(SWareaID, "california\desert4_cal", 3, 6);
		rmSetAreaCliffPainting(SWareaID, true, false, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaObeyWorldCircleConstraint(SWareaID, false);
		rmAddAreaConstraint (SWareaID, avoidImpassableLandMin);
	//	rmSetAreaTerrainType(SWareaID, "new_england\ground2_cliff_ne"); // for testing	
		rmBuildArea(SWareaID);
		
		int stayInSWarea = rmCreateAreaMaxDistanceConstraint("stay in SW area", SWareaID, 0.0);
		int stayNearSWarea = rmCreateAreaMaxDistanceConstraint("stay near SW area", SWareaID, 50.0);
		int avoidSWarea = rmCreateAreaDistanceConstraint("avoid SW area", SWareaID, 2.0);
		int avoidSWareaMed = rmCreateAreaDistanceConstraint("avoid SW area medium", SWareaID, 10.0);
	}
	else
	{
		// FFA desert
		int FFAareaID = rmCreateArea("FFA area");
		rmSetAreaWarnFailure(FFAareaID, false);
		rmSetAreaSize(FFAareaID, 0.16, 0.16);
		rmSetAreaCoherence(FFAareaID, 0.55);
		rmSetAreaSmoothDistance(FFAareaID, 3+1*cNumberNonGaiaPlayers);
		rmSetAreaHeightBlend(FFAareaID, 1.2);
	//	rmSetAreaElevationType(FFAareaID, cElevTurbulence);
		rmSetAreaElevationVariation(FFAareaID, 2.0);
	//	rmSetAreaElevationMinFrequency(FFAareaID, 0.035);
	//	rmSetAreaElevationOctaves(FFAareaID, 3);
	//	rmSetAreaElevationPersistence(FFAareaID, 0.4);
		rmSetAreaLocation(FFAareaID, 1.00, 0.00);
		rmAddAreaInfluenceSegment(FFAareaID, 0.70, 0.30, 1.00, 0.00);
		rmAddAreaInfluenceSegment(FFAareaID, 0.75, 0.35, 1.00, 0.20);
		rmAddAreaInfluenceSegment(FFAareaID, 0.65, 0.25, 0.80, 0.00);
		rmSetAreaCliffHeight(FFAareaID, -6.0, 0.0, 0.5); 
		rmSetAreaCliffEdge(FFAareaID, 1, 0.26-0.008*cNumberNonGaiaPlayers, 0.0, 0.0, 1); 
		rmSetAreaCliffType(FFAareaID, "california2"); 
		rmSetAreaMix(FFAareaID, "california_desert3");
		rmSetAreaTerrainType(FFAareaID, "california\desert3_cal");	
		rmAddAreaTerrainLayer(FFAareaID, "california\desert5_cal", 0, 2);
		rmAddAreaTerrainLayer(FFAareaID, "california\desert4_cal", 3, 6);
		rmSetAreaCliffPainting(FFAareaID, true, false, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaObeyWorldCircleConstraint(FFAareaID, false);
		rmAddAreaConstraint (FFAareaID, avoidImpassableLandMin);
	//	rmSetAreaTerrainType(FFAareaID, "new_england\ground2_cliff_ne"); // for testing	
		rmBuildArea(FFAareaID);
		
		int stayInFFAarea = rmCreateAreaMaxDistanceConstraint("stay in FFA area", FFAareaID, 0.0);
		int stayNearFFAarea = rmCreateAreaMaxDistanceConstraint("stay near FFA area", FFAareaID, 50.0);
		int avoidFFAarea = rmCreateAreaDistanceConstraint("avoid FFA area", FFAareaID, 2.0);
		int avoidFFAareaMed = rmCreateAreaDistanceConstraint("avoid FFA area medium", FFAareaID, 10.0);
	}
	
	// Desert patches
	int desertpatchcount = 8+5*cNumberNonGaiaPlayers;
	if (cNumberTeams > 2)
		desertpatchcount = 8+2*cNumberNonGaiaPlayers;
	
	
	for (i=0; < desertpatchcount)
    {
        int patch2ID = rmCreateArea("patch desert "+i);
        rmSetAreaWarnFailure(patch2ID, false);
        rmSetAreaSize(patch2ID, rmAreaTilesToFraction(30), rmAreaTilesToFraction(40));
		rmSetAreaTerrainType(patch2ID, "california\desert2_cal");
//		rmAddAreaTerrainLayer(patch2ID, "yellow_river\grass2_yellow_riv", 0, 1);
        rmAddAreaToClass(patch2ID, classPatch2);
        rmSetAreaMinBlobs(patch2ID, 1);
        rmSetAreaMaxBlobs(patch2ID, 5);
        rmSetAreaMinBlobDistance(patch2ID, 16.0);
        rmSetAreaMaxBlobDistance(patch2ID, 40.0);
        rmSetAreaCoherence(patch2ID, 0.0);
//		rmAddAreaConstraint(patch2ID, avoidImpassableLandMin);
		if (cNumberTeams > 2)
			rmAddAreaConstraint(patch2ID, stayInFFAarea);
		else
		{
			if (i < desertpatchcount/2)
				rmAddAreaConstraint(patch2ID, stayInNEarea);
			else
				rmAddAreaConstraint(patch2ID, stayInSWarea);
		}
		rmAddAreaConstraint(patch2ID, avoidPatch2);
        rmBuildArea(patch2ID); 
    }
	
	
	
	// Rocky patches
	for (i=0; < 10+6*cNumberNonGaiaPlayers)
    {
        int patchID = rmCreateArea("patch rock "+i);
        rmSetAreaWarnFailure(patchID, false);
        rmSetAreaSize(patchID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(140));
		rmSetAreaTerrainType(patchID, "california\ground9_cal");
//		rmAddAreaTerrainLayer(patchID, "yellow_river\grass2_yellow_riv", 0, 1);
        rmAddAreaToClass(patchID, classPatch);
        rmSetAreaMinBlobs(patchID, 1);
        rmSetAreaMaxBlobs(patchID, 5);
        rmSetAreaMinBlobDistance(patchID, 16.0);
        rmSetAreaMaxBlobDistance(patchID, 40.0);
        rmSetAreaCoherence(patchID, 0.0);
//		rmAddAreaConstraint(patchID, avoidImpassableLandMin);
		if (cNumberTeams > 2)
		rmAddAreaConstraint(patchID, avoidFFAareaMed);
		else
		{
		rmAddAreaConstraint(patchID, avoidNEareaMed);
		rmAddAreaConstraint(patchID, avoidSWareaMed);
		}
		rmAddAreaConstraint(patchID, avoidPatch);
        rmBuildArea(patchID); 
    }
	
	
	// Cliff
	int cliffcount = 2;
	
//	if (cNumberTeams <=2)
//	{	
		
		
		for (i = 0;  < cliffcount)
		{
			int CliffID = rmCreateArea("cliff"+i);
			rmSetAreaSize(CliffID, 0.010-0.0005*cNumberNonGaiaPlayers, 0.010-0.0005*cNumberNonGaiaPlayers);
			rmSetAreaWarnFailure(CliffID, false);
			rmSetAreaObeyWorldCircleConstraint(CliffID, false);
			rmSetAreaCoherence(CliffID, 0.50);
			rmSetAreaSmoothDistance(CliffID, 3+1*cNumberNonGaiaPlayers);
			rmSetAreaCliffType(CliffID, "california");
			rmSetAreaTerrainType(CliffID, "california\ground9_cal");
			rmSetAreaCliffEdge(CliffID, 1, 1.0, 0.0, 0.0, 0);
			rmSetAreaCliffHeight(CliffID, 6.0, 0.0, 1.0);
			rmSetAreaCliffPainting(CliffID, true, false, true);
			rmAddAreaToClass(CliffID, classCliff);
			rmAddAreaConstraint(CliffID, avoidImpassableLand);
			if (cNumberTeams <= 2)
			{
				if (i == 0)
				{
					rmAddAreaInfluenceSegment(CliffID, 0.52, 0.00, 0.56, 0.07);
					rmAddAreaInfluenceSegment(CliffID, 0.60, 0.00, 0.56, 0.07);
					rmSetAreaLocation(CliffID, 0.56, 0.00);
				}
				else if (i == 1)
				{
					rmAddAreaInfluenceSegment(CliffID, 0.40, 1.00, 0.44, 0.93);
					rmAddAreaInfluenceSegment(CliffID, 0.48, 1.00, 0.44, 0.93);
					rmSetAreaLocation(CliffID, 0.44, 1.00);
				}
			}	
			else
			{
				if (i == 0)
				{
					rmAddAreaInfluenceSegment(CliffID, 0.44, 0.00, 0.48, 0.07);
					rmAddAreaInfluenceSegment(CliffID, 0.52, 0.00, 0.48, 0.07);
					rmSetAreaLocation(CliffID, 0.48, 0.00);
				}
				else if (i == 1)
				{
					rmAddAreaInfluenceSegment(CliffID, 1.00, 0.56, 0.93, 0.52);
					rmAddAreaInfluenceSegment(CliffID, 1.00, 0.48, 0.93, 0.52);
					rmSetAreaLocation(CliffID, 1.00, 0.52);
				}
			}
			rmBuildArea(CliffID);	
		}
		
	
	// Players area
	for (i=1; < cNumberPlayers)
	{
		int playerareaID = rmCreateArea("playerarea"+i);
		rmSetPlayerArea(i, playerareaID);
		rmSetAreaSize(playerareaID,rmAreaTilesToFraction(400), rmAreaTilesToFraction(400));
		rmSetAreaCoherence(playerareaID, 1.0);
		rmSetAreaWarnFailure(playerareaID, false);
//		rmSetAreaMix(playerareaID, "rockies_snow");
		rmSetAreaLocPlayer(playerareaID, i);
		rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
		rmAddAreaToClass(playerareaID, classPlayer);
		rmBuildArea(playerareaID);
		int stayPlayerArea = rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerareaID, 0.0);
	}
		
	// ******************************************************************************************************
	
	// Text
	rmSetStatusText("",0.20);

	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.85;
		float yLoc = 0.3;
		float walk = 0.03;

		if (randLoc == 2 && cNumberTeams <= 2) {
			xLoc = 0.15;
			yLoc = 0.7;
		} else if (cNumberTeams > 2) {
			xLoc = 0.8;
			yLoc = 0.2;
		}

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}

	// Text
	rmSetStatusText("",1.00);

	// ****************************************** TRADE ROUTE **********************************************
	
	int tradeRouteID = rmCreateTradeRoute();
	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 6.0);

	
	if (cNumberTeams <= 2) //1v1 and team
	{
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 1.00, 0.66);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.68, 0.72);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.58, 0.66);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.50);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.42, 0.34);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.32, 0.28);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.00, 0.34); 
	}
	else //FFA
	{
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 1.00, 0.64);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.70, 0.60);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 0.70);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.65);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.30, 0.45);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 0.30);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.36, 0.00);
	}
	
	bool placedTradeRouteA = rmBuildTradeRoute(tradeRouteID, "dirt");

	if (cNumberTeams <= 2) //1v1 and team
	{
		vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.42);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.62);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.88);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else //FFA
	{
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.26);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.42);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.58);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.74);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	// *************************************************************************************************************
	
	// ******************************************** NATIVES *************************************************
	
    int nativeID1 = -1;
	int nativeID2 = -1;

	int natArea1 = -1;
	int natArea2 = -1;
	
	
	nativeID1 = rmCreateGrouping("Klamath", "native klamath village "+4); // SW
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
//  rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
	rmAddGroupingToClass(nativeID1, classNative);
		
	nativeID2 = rmCreateGrouping("Navajo", "native navajo village "+4); // NE 
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
//  rmAddGroupingConstraint(nativeID2, avoidImpassableLand);
	rmAddGroupingToClass(nativeID2, classNative);
	

	
	natArea1 = rmCreateArea("native area 1");
	rmSetAreaSize(natArea1,rmAreaTilesToFraction(250), rmAreaTilesToFraction(250));
	rmSetAreaCoherence(natArea1, 0.75);
	rmSetAreaWarnFailure(natArea1, false);
	rmSetAreaTerrainType(natArea1, "california\desert3_cal");
	rmAddAreaTerrainLayer(natArea1, "california\desert3_cal", 0, 1);
	rmSetAreaObeyWorldCircleConstraint(natArea1, false);
	
	natArea2 = rmCreateArea("native area 2");
	rmSetAreaSize(natArea2,rmAreaTilesToFraction(250), rmAreaTilesToFraction(250));
	rmSetAreaCoherence(natArea2, 0.75);
	rmSetAreaWarnFailure(natArea2, false);
	rmSetAreaTerrainType(natArea2, "california\desert3_cal"); 
	rmAddAreaTerrainLayer(natArea2, "california\desert3_cal", 0, 1);
	rmSetAreaObeyWorldCircleConstraint(natArea2, false);
	
	if (cNumberTeams <= 2)
	{
		if (cNumberNonGaiaPlayers <= 4)
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.10, 0.60); // 
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.90, 0.40); // 
//			rmSetAreaLocation(natArea1, 0.42, 0.78);
//			rmBuildArea(natArea1);
//			rmSetAreaLocation(natArea2, 0.58, 0.22);
//			rmBuildArea(natArea2);
		}
		else 
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.10, 0.60); // 
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.20, 0.75); // 
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.90, 0.40); // 
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.80, 0.25); // 
//			rmSetAreaLocation(natArea1, 0.40, 0.46);
//			rmBuildArea(natArea1);
//			rmSetAreaLocation(natArea2, 0.60, 0.54);
//			rmBuildArea(natArea2);
		}
	}
	else
	{
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.90, 0.30); // 
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.70, 0.10); // 
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.58, 0.55); // 
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.45, 0.42); // 
//			rmSetAreaLocation(natArea1, 0.40, 0.46);
//			rmBuildArea(natArea1);
//			rmSetAreaLocation(natArea2, 0.60, 0.54);
//			rmBuildArea(natArea2);
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
	rmAddObjectDefConstraint(playergoldID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidGoldType);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
	rmAddObjectDefConstraint(playergoldID, avoidCenter);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 40.0); //58
	rmSetObjectDefMaxDistance(playergold2ID, 42.0); //62
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRouteSocket);
	
	if (cNumberNonGaiaPlayers <= 2)
		rmAddObjectDefConstraint(playergold2ID, avoidImpassableLandFar);
	else
		rmAddObjectDefConstraint(playergold2ID, avoidImpassableLandMed);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldType);
	rmAddObjectDefConstraint(playergold2ID, avoidTownCenterMed);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold2ID, avoidEdge);
	
	
	// Starting trees1
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "ypTreeMongolianFir", rmRandInt(4,5), 3.0); //
    rmSetObjectDefMinDistance(playerTreeID, 12);
    rmSetObjectDefMaxDistance(playerTreeID, 13);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	
	// Starting trees2
	int playerTree2ID = rmCreateObjectDef("player trees 2");
	rmAddObjectDefItem(playerTree2ID, "ypTreeMongolianFir", rmRandInt(8,9), 6.0); //
    rmSetObjectDefMinDistance(playerTree2ID, 16);
    rmSetObjectDefMaxDistance(playerTree2ID, 18);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
	rmAddObjectDefToClass(playerTree2ID, classForest);
	rmAddObjectDefConstraint(playerTree2ID, avoidForestShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTree2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResources);
	
	// Starting herd
	int playerHuntID = rmCreateObjectDef("starting hunt");
	rmAddObjectDefItem(playerHuntID, "Elk", rmRandInt(6,6), 3.0);
	rmSetObjectDefMinDistance(playerHuntID, 10.0);
	rmSetObjectDefMaxDistance(playerHuntID, 13.0);
	rmSetObjectDefCreateHerd(playerHuntID, false);
	rmAddObjectDefToClass(playerHuntID, classStartingResource);
	rmAddObjectDefConstraint(playerHuntID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerHuntID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerHuntID, avoidNatives);
	rmAddObjectDefConstraint(playerHuntID, avoidElkShort);
	rmAddObjectDefConstraint(playerHuntID, avoidStartingResources);
		
	// 2nd herd
	int playerHunt2ID = rmCreateObjectDef("player 2nd hunt");
    rmAddObjectDefItem(playerHunt2ID, "bighornsheep", rmRandInt(10,10), 7.0);
    rmSetObjectDefMinDistance(playerHunt2ID, 34);
    rmSetObjectDefMaxDistance(playerHunt2ID, 36);
	rmAddObjectDefToClass(playerHunt2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHunt2ID, true);
	rmAddObjectDefConstraint(playerHunt2ID, avoidElk); //Short
//	rmAddObjectDefConstraint(playerHunt2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerHunt2ID, avoidImpassableLandFar);
	rmAddObjectDefConstraint(playerHunt2ID, avoidNatives);
	rmAddObjectDefConstraint(playerHunt2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerHunt2ID, avoidEdge);
		
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
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHunt2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHuntID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if (nugget0count == 2)
			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
				
		if(ypIsAsian(i) && rmGetNomadStart() == false)
		rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i,1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

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
	
		int goldmineCount = 1*cNumberNonGaiaPlayers;  // 3,3 		
		int silvermineCount = 1+2*cNumberNonGaiaPlayers;  // 3,3 
		
	
	//Gold mines
	for(i=0; < goldmineCount)
	{
		int goldmineID = rmCreateObjectDef("gold mine"+i);
		rmAddObjectDefItem(goldmineID, "Minegold", 1, 0.0);
		rmSetObjectDefMinDistance(goldmineID, rmXFractionToMeters(0.01));
		if (cNumberTeams <= 2)
			rmSetObjectDefMaxDistance(goldmineID, rmXFractionToMeters(0.0175*cNumberNonGaiaPlayers));
		else
			rmSetObjectDefMaxDistance(goldmineID, rmXFractionToMeters(0.0250*cNumberNonGaiaPlayers));
		rmAddObjectDefToClass(goldmineID, classGold);
		rmAddObjectDefConstraint(goldmineID, avoidTradeRoute);
		rmAddObjectDefConstraint(goldmineID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(goldmineID, avoidNatives);
		rmAddObjectDefConstraint(goldmineID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(goldmineID, avoidGold);
		rmAddObjectDefConstraint(goldmineID, avoidTownCenter);
		rmAddObjectDefConstraint(goldmineID, avoidEdge);
		if (cNumberTeams <= 2)
		{
			if (i < goldmineCount/2)
			{
				rmAddObjectDefConstraint(goldmineID, stayInNEarea);
				rmPlaceObjectDefAtLoc(goldmineID, 0, 0.74, 0.42 );
			}
			else
			{
				rmAddObjectDefConstraint(goldmineID, stayInSWarea);
				rmPlaceObjectDefAtLoc(goldmineID, 0, 0.26, 0.58 );
			}
		}	
		else
		{
			rmAddObjectDefConstraint(goldmineID, stayInFFAarea);
			rmPlaceObjectDefAtLoc(goldmineID, 0, 0.70, 0.30 );
		}
	}
	

	//Silver mines
	for(i=0; < silvermineCount)
	{
		int silvermine2ID = rmCreateObjectDef("silver mine "+i);
		rmAddObjectDefItem(silvermine2ID, "Mine", 1, 0.0);
		if (i < 1)
			rmSetObjectDefMinDistance(silvermine2ID, rmXFractionToMeters(0.04));
		else
			rmSetObjectDefMinDistance(silvermine2ID, rmXFractionToMeters(0.00));
		if (i < 1)
			rmSetObjectDefMaxDistance(silvermine2ID, rmXFractionToMeters(0.08));
		else
			rmSetObjectDefMaxDistance(silvermine2ID, rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(silvermine2ID, classGold);
		rmAddObjectDefConstraint(silvermine2ID, avoidTradeRoute);
		rmAddObjectDefConstraint(silvermine2ID, avoidImpassableLand);
		rmAddObjectDefConstraint(silvermine2ID, avoidNatives);
		rmAddObjectDefConstraint(silvermine2ID, avoidTradeRouteSocket);
		if (i < 1)
			rmAddObjectDefConstraint(silvermine2ID, avoidGold);
		else	
			rmAddObjectDefConstraint(silvermine2ID, avoidGoldFar);
		rmAddObjectDefConstraint(silvermine2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(silvermine2ID, avoidCliff);
		rmAddObjectDefConstraint(silvermine2ID, avoidEdge);
		if (cNumberTeams > 2)
		rmAddObjectDefConstraint(silvermine2ID, avoidFFAarea);
		rmPlaceObjectDefAtLoc(silvermine2ID, 0, 0.50, 0.50);
	}
	
	

			
	// ****************************
	
	// Text
	rmSetStatusText("",0.60);
	
	// ********** Forest **********
	
	// Forest
	int forestcount = 4+7*cNumberNonGaiaPlayers; // 14*cNumberNonGaiaPlayers/2
	int stayInForest = -1;
	
	for (i=0; < forestcount)
	{
		int forestID = rmCreateArea("south forest"+i);
		rmSetAreaWarnFailure(forestID, false);
		rmSetAreaObeyWorldCircleConstraint(forestID, true);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(180), rmAreaTilesToFraction(220));
		rmSetAreaMix(forestID, "california_forestground");
//		rmAddAreaTerrainLayer(forestID, "yellow_river\grass2_yellow_riv", 0, 1);
		rmSetAreaMinBlobs(forestID, 2);
		rmSetAreaMaxBlobs(forestID, 5);
		rmSetAreaMinBlobDistance(forestID, 14.0);
		rmSetAreaMaxBlobDistance(forestID, 30.0);
		rmSetAreaCoherence(forestID, 0.0);
		rmSetAreaSmoothDistance(forestID, 5);
//		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidForest);
		rmAddAreaConstraint(forestID, avoidTradeRouteShort);
		rmAddAreaConstraint(forestID, avoidImpassableLandShort);
		rmAddAreaConstraint(forestID, avoidNatives);
		rmAddAreaConstraint(forestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(forestID, avoidGoldTypeShort);
//		rmAddAreaConstraint(forestID, avoidEdge);
		rmAddAreaConstraint(forestID, avoidTownCenterShort);
		rmAddAreaConstraint(forestID, avoidStartingResourcesShort);
		rmAddAreaConstraint(forestID, avoidElkMin); 
		rmAddAreaConstraint(forestID, avoidNuggetMin); 
		if (cNumberTeams <= 2)
		{
			rmAddAreaConstraint(forestID, avoidNEarea); 
			rmAddAreaConstraint(forestID, avoidSWarea); 
		}
		else
		{
			rmAddAreaConstraint(forestID, avoidFFAarea);
		}
		rmAddAreaConstraint(forestID, avoidCliff); 
		rmBuildArea(forestID);
	
		stayInForest = rmCreateAreaMaxDistanceConstraint("stay in south forest"+i, forestID, 0.0);
	
		for (j=0; < rmRandInt(6,7)+cNumberNonGaiaPlayers) //11,12
		{
			int foresttreeID = rmCreateObjectDef("south tree"+i+" "+j);
			rmAddObjectDefItem(foresttreeID, "UnderbrushDeccan", rmRandInt(2,3), 5.0);
			rmAddObjectDefItem(foresttreeID, "ypTreeMongolianFir", rmRandInt(1,1), 3.0); // 1,2
			rmAddObjectDefItem(foresttreeID, "TreeGreatLakes", rmRandInt(1,2), 4.0); // 1,2 
			rmAddObjectDefItem(foresttreeID, "ypTreeMongolianFir", rmRandInt(1,2), 4.0); // 1,2
			rmSetObjectDefMinDistance(foresttreeID, 0);
			rmSetObjectDefMaxDistance(foresttreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(foresttreeID, classForest);
			rmAddObjectDefConstraint(foresttreeID, stayInForest);	
			rmAddObjectDefConstraint(foresttreeID, avoidImpassableLandShort);	
			rmAddObjectDefConstraint(foresttreeID, avoidGoldTypeShort);
			rmPlaceObjectDefAtLoc(foresttreeID, 0, 0.50, 0.50);
		}
		
	}
	
	
	// Random trees
	int randomforestcount = 3+6*cNumberNonGaiaPlayers; 
	
	for (i=0; < randomforestcount)
	{	
		int RandomtreeID = rmCreateObjectDef("random trees"+i);
		rmAddObjectDefItem(RandomtreeID, "TreeSonora", rmRandInt(1,2), 3.0); // 4,5
		rmAddObjectDefItem(RandomtreeID, "TreeSonora", rmRandInt(1,3), 5.0); // 4,5
//		rmAddObjectDefItem(RandomtreeID, "UnderbrushDeccan", rmRandInt(1,2), 4.0);
		rmSetObjectDefMinDistance(RandomtreeID, 0);
		rmSetObjectDefMaxDistance(RandomtreeID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(RandomtreeID, classForest);
		rmAddObjectDefConstraint(RandomtreeID, avoidNatives);
		rmAddObjectDefConstraint(RandomtreeID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(RandomtreeID, avoidImpassableLand);
		rmAddObjectDefConstraint(RandomtreeID, avoidTownCenterResources);
		rmAddObjectDefConstraint(RandomtreeID, avoidStartingResources);
		rmAddObjectDefConstraint(RandomtreeID, avoidElkMin); 
		rmAddObjectDefConstraint(RandomtreeID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidForestShort);	
		if (cNumberTeams <= 2)
		{
			if (i < randomforestcount/2)
				rmAddObjectDefConstraint(RandomtreeID, stayInNEarea); 
			else	
				rmAddObjectDefConstraint(RandomtreeID, stayInSWarea); 
		}
		else
		{
			rmAddObjectDefConstraint(RandomtreeID, stayInFFAarea);
		}			
//		rmAddObjectDefConstraint(RandomtreeID, avoidEdge);
		rmPlaceObjectDefAtLoc(RandomtreeID, 0, 0.5, 0.5);
	}
	
	// ********************************	
	
	// Text
	rmSetStatusText("",0.70);

	// ********** Herds ***********

	//Bighorn hunts
	int Bighorncount = 1+1*cNumberNonGaiaPlayers;
	
	for(i=0; < Bighorncount)
	{
		int BighornID = rmCreateObjectDef("Bighorn hunt"+i);
		rmAddObjectDefItem(BighornID, "bighornsheep", rmRandInt(10,11), 8.0);
		rmSetObjectDefMinDistance(BighornID, 0.0);
		rmSetObjectDefMaxDistance(BighornID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(BighornID, true);
		rmAddObjectDefConstraint(BighornID, avoidImpassableLand);
		rmAddObjectDefConstraint(BighornID, avoidNativesShort);
		rmAddObjectDefConstraint(BighornID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(BighornID, avoidGoldMed);
		rmAddObjectDefConstraint(BighornID, avoidTownCenterFar);
		rmAddObjectDefConstraint(BighornID, avoidForestMin);
		rmAddObjectDefConstraint(BighornID, avoidBighornFar);
		rmAddObjectDefConstraint(BighornID, avoidEdge);	
		rmAddObjectDefConstraint(BighornID, avoidCliff); 
		if (cNumberTeams <= 2)
		{
			rmAddObjectDefConstraint(BighornID, avoidNEarea); 
			rmAddObjectDefConstraint(BighornID, avoidSWarea); 
		}
		else
		{
			rmAddObjectDefConstraint(BighornID, avoidFFAarea);
		}
		rmPlaceObjectDefAtLoc(BighornID, 0, 0.5, 0.5);
	}
	
	
	//Elk hunts
	int Elkcount = 1+3*cNumberNonGaiaPlayers;
	
	for(i=0; < Elkcount)
	{
		int ElkID = rmCreateObjectDef("Elk hunt"+i);
		rmAddObjectDefItem(ElkID, "Elk", rmRandInt(5,6), 4.0);
		rmSetObjectDefMinDistance(ElkID, 0.0);
		rmSetObjectDefMaxDistance(ElkID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(ElkID, true);
		rmAddObjectDefConstraint(ElkID, avoidImpassableLand);
		rmAddObjectDefConstraint(ElkID, avoidNativesShort);
		rmAddObjectDefConstraint(ElkID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(ElkID, avoidGoldMed);
		rmAddObjectDefConstraint(ElkID, avoidTownCenterFar);
		rmAddObjectDefConstraint(ElkID, avoidForestMin);
		rmAddObjectDefConstraint(ElkID, avoidBighorn);
		rmAddObjectDefConstraint(ElkID, avoidElkFar);
		rmAddObjectDefConstraint(ElkID, avoidCliff); 
		if (cNumberTeams <= 2)
		{
				rmAddObjectDefConstraint(ElkID, avoidNEarea); 	
				rmAddObjectDefConstraint(ElkID, avoidSWarea); 
		}	
		else
		{
			rmAddObjectDefConstraint(ElkID, avoidFFAarea);
		}			
		rmAddObjectDefConstraint(ElkID, avoidEdge);	
		rmPlaceObjectDefAtLoc(ElkID, 0, 0.5, 0.5);
	}
	
	
	//Deer hunts
	int Deercount = 2*cNumberNonGaiaPlayers;
	
	for(i=0; < Deercount)
	{
		int DeerID = rmCreateObjectDef("Deer hunt"+i);
		rmAddObjectDefItem(DeerID, "deer", rmRandInt(7,8), 5.0);
		rmSetObjectDefMinDistance(DeerID, 0.0);
		rmSetObjectDefMaxDistance(DeerID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(DeerID, true);
		rmAddObjectDefConstraint(DeerID, avoidImpassableLand);
		rmAddObjectDefConstraint(DeerID, avoidNativesShort);
		rmAddObjectDefConstraint(DeerID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(DeerID, avoidGoldMed);
		rmAddObjectDefConstraint(DeerID, avoidTownCenterFar);
		rmAddObjectDefConstraint(DeerID, avoidForestMin);
		rmAddObjectDefConstraint(DeerID, avoidBighorn);
		rmAddObjectDefConstraint(DeerID, avoidElk);
		rmAddObjectDefConstraint(DeerID, avoidDeer);
		rmAddObjectDefConstraint(DeerID, avoidCliff); 
		if (cNumberTeams <= 2)
		{
			if (i < Deercount/2)
				rmAddObjectDefConstraint(DeerID, stayInNEarea); 
			else
				rmAddObjectDefConstraint(DeerID, stayInSWarea); 
		}	
		else
		{
			rmAddObjectDefConstraint(DeerID, stayInFFAarea);
		}
		rmAddObjectDefConstraint(DeerID, avoidEdge);	
		rmPlaceObjectDefAtLoc(DeerID, 0, 0.5, 0.5);
	}
	
	
	
	// ********************************
	
	// Text
	rmSetStatusText("",0.80);
	
	// ********** Treasures ***********
	
	
	int nugget1count = 4+0.5*cNumberNonGaiaPlayers-nugget0count;
	int nugget2count = 3+0.5*cNumberNonGaiaPlayers; 
	int nugget3count = 1+0.5*cNumberNonGaiaPlayers; 
	int nugget4count = 0.34*cNumberNonGaiaPlayers; 
	
	// Treasures 4	
	
	for (i=0; < nugget4count)
	{
		int Nugget4ID = rmCreateObjectDef("nugget 4 "+i); 
		rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 1.0);
		rmSetObjectDefMinDistance(Nugget4ID, 0);
		rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.22));
		rmAddObjectDefConstraint(Nugget4ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidElkMin); 
		rmAddObjectDefConstraint(Nugget4ID, avoidBighornMin); 
		rmAddObjectDefConstraint(Nugget4ID, avoidDeerMin); 
		rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget4ID, avoidEdge); 
		if (cNumberTeams <= 2)
		{
				rmAddObjectDefConstraint(Nugget4ID, avoidNEarea); 
				rmAddObjectDefConstraint(Nugget4ID, avoidSWarea); 
		}	
		else
		{
			rmAddObjectDefConstraint(Nugget4ID, avoidFFAarea);
		}			
		rmAddObjectDefConstraint(Nugget4ID, avoidCliff); 
		rmSetNuggetDifficulty(4,4);
		if (cNumberNonGaiaPlayers >= 4)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.50, 0.50);
	}
	
	
	// Treasures 2	
	for (i=0; < nugget2count)
	{
		int Nugget2ID = rmCreateObjectDef("nugget 2 "+i); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidElkMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidBighornMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidDeerMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge); 
		if (cNumberTeams <= 2)
		{	
				rmAddObjectDefConstraint(Nugget2ID, avoidNEarea); 	
				rmAddObjectDefConstraint(Nugget2ID, avoidSWarea); 
		}	
		else
		{
			rmAddObjectDefConstraint(Nugget2ID, avoidFFAarea);
		}		
		rmAddObjectDefConstraint(Nugget2ID, avoidCliff); 		
		rmSetNuggetDifficulty(2,2);
		if (i == 0)
			rmAddObjectDefConstraint(Nugget2ID, stayNWhalf);
		else if (i == 1)
			rmAddObjectDefConstraint(Nugget2ID, staySEhalf);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}
	
	
	// Treasures 1	
	for (i=0; < nugget1count)
	{
		int Nugget1ID = rmCreateObjectDef("nugget 1 "+i); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, 0);
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(Nugget1ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget1ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget1ID, avoidElkMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidBighornMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidDeerMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge); 
/*		if (cNumberTeams <= 2)
		{	
				rmAddObjectDefConstraint(Nugget1ID, avoidNEarea); 
				rmAddObjectDefConstraint(Nugget1ID, avoidSWarea); 
		}	
		else
		{
			rmAddObjectDefConstraint(Nugget1ID, avoidFFAarea);
		}		
*/		rmAddObjectDefConstraint(Nugget1ID, avoidCliff); 
		rmSetNuggetDifficulty(1,1);
		if (i == 0)
			rmAddObjectDefConstraint(Nugget1ID, stayNWhalf);
		else if (i == 1)
			rmAddObjectDefConstraint(Nugget1ID, staySEhalf);
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);
	}
	
	// Treasures 3
	for (i=0; < nugget3count)
	{
		int Nugget3ID = rmCreateObjectDef("nugget 3 "+i); 
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, 0);
		rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.6));
		rmAddObjectDefConstraint(Nugget3ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidElkMin); 
		rmAddObjectDefConstraint(Nugget3ID, avoidBighornMin); 
		rmAddObjectDefConstraint(Nugget3ID, avoidDeerMin); 
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget3ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget3ID, avoidCliff); 
		rmSetNuggetDifficulty(3,3);
		if (cNumberTeams <= 2)
		{
			if (i < nugget3count/2 )
				rmAddObjectDefConstraint(Nugget3ID, stayInNEarea);
			else 
				rmAddObjectDefConstraint(Nugget3ID, stayInSWarea);
		}	
		else
		{
			rmAddObjectDefConstraint(Nugget3ID, stayInFFAarea);
		}
		rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50);
	}
	
	// ********************************
		
	// Text
	rmSetStatusText("",0.90);
	
	// ****************************************


	
} //END
	
	