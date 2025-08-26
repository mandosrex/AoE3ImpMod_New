// ESOC GRAN CHACO (1v1, TEAM, FFA)
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
	int playerTiles = 13000;
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=12000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=11000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=10000;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); 
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(true);
	
	// Picks a default water height
	rmSetSeaLevel(2.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	rmSetMapElevationParameters(cElevTurbulence, 0.0475, 4, 0.42, 3.5);  // type, frequency, octaves, persistence, variation 
	rmSetMapElevationHeightBlend(0.5); //
	
	// Picks default terrain and water
	
	rmSetBaseTerrainMix("andes_grass_a");
	rmTerrainInitialize("andes\ground09_and", 3.0);
//	rmTerrainInitialize("water");
	rmSetMapType("andes"); 
	rmSetMapType("grass");
	rmSetMapType("land");
	rmSetMapType("samerica");
	rmSetLightingSet("patagonia");
	rmSetWindMagnitude(2.0);
	
	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);
	
	// Set up Natives
	int subCiv0 = -1;
	subCiv0 = rmGetCivID("Tupi");
	rmSetSubCiv(0, "Tupi");


	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	int classPond = rmDefineClass("pond");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classPatch3 = rmDefineClass("patch3");
	int classPatch4 = rmDefineClass("patch4");
	int classForest = rmDefineClass("Forest");
	int classNative = rmDefineClass("natives");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	
	// ******************************************************************************************
	
	// Text
	rmSetStatusText("",0.20);
	
	// ************************************* CONTRAINTS *****************************************
   
	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.36), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.15), rmXFractionToMeters(0.50), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.50,0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int staySouth = rmCreatePieConstraint("Stay South half",0.3, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(180),rmDegreesToRadians(360));
	int stayNorth = rmCreatePieConstraint("Stay North half",0.6, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(0),rmDegreesToRadians(180));
	int pondSouth = rmCreatePieConstraint("pond stays south",0.5, 0.52, rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(80),rmDegreesToRadians(280));
	int pondNorth = rmCreatePieConstraint("pond stays north",0.5, 0.48, rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(260),rmDegreesToRadians(100));
		
	// Resource avoidance
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 26.0); //15.0
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 34.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 28.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 3.0);
	int avoidGuanacoFar = rmCreateTypeDistanceConstraint("avoid Guanaco far", "Guanaco", 50.0);
	int avoidGuanaco = rmCreateTypeDistanceConstraint("avoid Guanaco", "Guanaco", 45.0);
	int avoidGuanacoShort = rmCreateTypeDistanceConstraint("avoid Guanaco short", "Guanaco", 25.0);
	int avoidGuanacoMin = rmCreateTypeDistanceConstraint("avoid Guanaco min", "Guanaco", 5.0);
	int avoidRheaFar = rmCreateTypeDistanceConstraint("avoid Rhea far", "Rhea", 50.0);
	int avoidRhea = rmCreateTypeDistanceConstraint("avoid  Rhea", "Rhea", 45.0);
	int avoidRheaShort = rmCreateTypeDistanceConstraint("avoid  Rhea short", "Rhea", 30.0);
	int avoidRheaMin = rmCreateTypeDistanceConstraint("avoid Rhea min", "Rhea", 5.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 8.0);
	int avoidGoldTypeMed = rmCreateTypeDistanceConstraint("coin avoids coin med", "gold", 24.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 58.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far", "gold", 58.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 12.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 42.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 66.0); // 82
//	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very ", rmClassID("Gold"), 74.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 40.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 34.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 60.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 60.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 50.0);
	int avoidTownCenterMed=rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 48.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 28.0);
	int avoidTownCenterMin=rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 18.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint("resources avoid Town Center", "townCenter", 40.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid natives short", rmClassID("natives"), 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 6.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("avoid natives far", rmClassID("natives"), 32.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 4.0);
	int avoidLlama=rmCreateTypeDistanceConstraint("Llama avoids Llama", "Llama", 50.0);

	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 10.0);
	int avoidImpassableLandFar = rmCreateTerrainDistanceConstraint("avoid impassable land far", "Land", false, 20.0);
	int avoidImpassableLandMed = rmCreateTerrainDistanceConstraint("avoid impassable land med", "Land", false, 15.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("avoid impassable land short", "Land", false, 3.0);
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("avoid impassable land min", "Land", false, 1.0);
	int stayNearLand = rmCreateTerrainMaxDistanceConstraint("stay near land ", "Land", true, 5.0);
	int avoidLandMin = rmCreateTerrainDistanceConstraint("avoid land min", "Land", true, 1.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land", "Land", true, 9.0);
	int avoidLandFar = rmCreateTerrainDistanceConstraint("avoid land far", "Land", true, 18+2.0*cNumberNonGaiaPlayers);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 14.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 3.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 28.0);
	int avoidWaterFar = rmCreateTerrainDistanceConstraint("avoid water far", "water", true, 36.0);
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 5.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 10.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 10.0);
	int avoidPatch4 = rmCreateClassDistanceConstraint("avoid patch4", rmClassID("patch4"), 10.0);
	int avoidClassPlayer = rmCreateClassDistanceConstraint("avoid class player", rmClassID("player"), 32.0+4*cNumberNonGaiaPlayers);
	int avoidPond = rmCreateClassDistanceConstraint("avoid pond", rmClassID("pond"), 54.0+2*cNumberNonGaiaPlayers);
	int avoidpondArea = rmCreateClassDistanceConstraint("avoid pond area", rmClassID("pond"), 10.0+2*cNumberNonGaiaPlayers);

	// VP avoidance
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 8.0);
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 5.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 12.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route socket short", "socketTradeRoute", 4.0);

	// KotH avoidance
	int avoidKingsHill = rmCreateTypeDistanceConstraint("avoid kings hill", "ypKingsHill", 10.0);
   
	
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
					rmPlacePlayer(1, 0.60, 0.82);
					rmPlacePlayer(2, 0.40, 0.18);
				}
				else
				{
					rmPlacePlayer(2, 0.60, 0.82);
					rmPlacePlayer(1, 0.40, 0.18);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.000, 0.150); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.500, 0.650); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.000, 0.200); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.500, 0.700); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);
				}
			}
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.124, 0.126); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmSetPlacementSection(0.52, 0.73); //
						else
							rmSetPlacementSection(0.47, 0.78); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmSetPlacementSection(0.02, 0.23); //
						else
							rmSetPlacementSection(0.97, 0.28); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.624, 0.626); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.02, 0.23); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.47, 0.78); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.97, 0.28); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.52, 0.73); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.97, 0.28); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.47, 0.78); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);
				}
			}
		}
		else // FFA
		{
			rmSetTeamSpacingModifier(0.25);
			rmPlacePlayersCircular(0.39, 0.39, 0.0);
		}

	
	// **************************************************************************************************
   
	// Text
	rmSetStatusText("",0.30);
	
	// ******************************************** MAP LAYOUT **************************************************

	// andes08 patches
	for (i=0; < 10+10*cNumberNonGaiaPlayers)
    {
        int patch08ID = rmCreateArea("andes ground08 patch"+i);
		rmSetAreaObeyWorldCircleConstraint(patch08ID, false);
        rmSetAreaWarnFailure(patch08ID, false);
        rmSetAreaSize(patch08ID, rmAreaTilesToFraction(80), rmAreaTilesToFraction(90));
		rmSetAreaTerrainType(patch08ID, "andes\ground08_and"); //caribbean\ground6_crb
//		rmPaintAreaTerrain(patch08ID); // nonfunctional
        rmAddAreaToClass(patch08ID, rmClassID("patch"));
        rmSetAreaMinBlobs(patch08ID, 1);
        rmSetAreaMaxBlobs(patch08ID, 5);
        rmSetAreaMinBlobDistance(patch08ID, 16.0);
        rmSetAreaMaxBlobDistance(patch08ID, 30.0);
        rmSetAreaCoherence(patch08ID, 0.0);
		rmSetAreaSmoothDistance(patch08ID, 1);
		rmAddAreaConstraint(patch08ID, avoidPatch);
        rmBuildArea(patch08ID); 
    }
	
	
	// andes07 patches
	for (i=0; < 10+10*cNumberNonGaiaPlayers)
    {
        int patch07ID = rmCreateArea("andes ground07 patch"+i);
		rmSetAreaObeyWorldCircleConstraint(patch07ID, false);
        rmSetAreaWarnFailure(patch07ID, false);
        rmSetAreaSize(patch07ID, rmAreaTilesToFraction(80), rmAreaTilesToFraction(90));
		rmSetAreaTerrainType(patch07ID, "andes\ground08_and"); //caribbean\ground6_crb
//		rmPaintAreaTerrain(patch07ID); // nonfunctional
        rmAddAreaToClass(patch07ID, rmClassID("patch2"));
        rmSetAreaMinBlobs(patch07ID, 1);
        rmSetAreaMaxBlobs(patch07ID, 5);
        rmSetAreaMinBlobDistance(patch07ID, 16.0);
        rmSetAreaMaxBlobDistance(patch07ID, 30.0);
        rmSetAreaCoherence(patch07ID, 0.0);
		rmSetAreaSmoothDistance(patch07ID, 1);
		rmAddAreaConstraint(patch07ID, avoidPatch2);
        rmBuildArea(patch07ID); 
    }
	
	// araucania north grass patches
	for (i=0; < 10+10*cNumberNonGaiaPlayers)
    {
        int patchgrassID = rmCreateArea("araucania north grass patch"+i);
		rmSetAreaObeyWorldCircleConstraint(patchgrassID, false);
        rmSetAreaWarnFailure(patchgrassID, false);
        rmSetAreaSize(patchgrassID, rmAreaTilesToFraction(90), rmAreaTilesToFraction(100));
		rmSetAreaMix(patchgrassID, "andes_grass_b");
		rmAddAreaTerrainLayer(patchgrassID, "andes\ground08_and", 0, 1); //caribbean\ground6_crb
//		rmPaintAreaTerrain(patchgrassID); // nonfunctional
        rmAddAreaToClass(patchgrassID, rmClassID("patch3"));
        rmSetAreaMinBlobs(patchgrassID, 1);
        rmSetAreaMaxBlobs(patchgrassID, 5);
        rmSetAreaMinBlobDistance(patchgrassID, 16.0);
        rmSetAreaMaxBlobDistance(patchgrassID, 30.0);
        rmSetAreaCoherence(patchgrassID, 0.0);
		rmSetAreaSmoothDistance(patchgrassID, 1);
		rmAddAreaConstraint(patchgrassID, avoidPatch3);
        rmBuildArea(patchgrassID); 
    }
	
	
	// Players area
	for (i=1; < cNumberPlayers)
	{
		int playerareaID = rmCreateArea("playerarea"+i);
		rmSetPlayerArea(i, playerareaID);
		rmSetAreaSize(playerareaID,rmAreaTilesToFraction(500), rmAreaTilesToFraction(500));
		rmSetAreaCoherence(playerareaID, 1.0);
		rmSetAreaWarnFailure(playerareaID, false);
//		rmSetAreaTerrainType(playerareaID, "new_england\ground2_cliff_ne"); // for testing
		rmSetAreaLocPlayer(playerareaID, i);
		rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
		rmAddAreaToClass(playerareaID, rmClassID("player"));
		rmBuildArea(playerareaID);
		int avoidPlayerArea = rmCreateAreaDistanceConstraint("avoid player area "+i, playerareaID, 2.0);
		int stayPlayerArea = rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerareaID, 0.0);
	}
	
	int avoidPlayerArea1 = rmConstraintID("avoid player area 1");
	int avoidPlayerArea2 = rmConstraintID("avoid player area 2");
	int stayInPlayerArea1 = rmConstraintID("stay in player area 1");
	int stayInPlayerArea2 = rmConstraintID("stay in player area 2");	
	
	// ******************************************** NATIVES *************************************************
	
    int nativeID1 = -1;
	int nativeID2 = -1;
	int nativeID3 = -1;
   	int natArea1 = -1;
	int natArea2 = -1;
	int natArea3 = -1;
	
	int natvariation = rmRandInt(0,1);
	if (cNumberNonGaiaPlayers >= 4)
		natvariation = 2;
	if (cNumberNonGaiaPlayers >= 6)
		natvariation = 3;
//	natvariation = 0; // <--- TEST
	
	nativeID1 = rmCreateGrouping("Tupi village A", "native tupi village "+3); // 3
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
//	rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
		
	nativeID2 = rmCreateGrouping("Tupi village B", "native tupi village "+4); // 3
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
//	rmAddGroupingConstraint(nativeID2, avoidImpassableLand);
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));
	
	nativeID3 = rmCreateGrouping("Tupi village C", "native tupi village "+2); // 3
    rmSetGroupingMinDistance(nativeID3, 0.00);
    rmSetGroupingMaxDistance(nativeID3, 0.00);
//	rmAddGroupingConstraint(nativeID3, avoidImpassableLand);
	rmAddGroupingToClass(nativeID3, rmClassID("natives"));
	
	
	natArea1 = rmCreateArea("native area 1");
	rmSetAreaSize(natArea1,rmAreaTilesToFraction(230), rmAreaTilesToFraction(230));
	rmSetAreaCoherence(natArea1, 0.70);
	rmSetAreaWarnFailure(natArea1, false);
	rmSetAreaMix(natArea1, "andes_grass_a");
	rmAddAreaTerrainLayer(natArea1, "andes\ground08_and", 0, 1);
	rmSetAreaObeyWorldCircleConstraint(natArea1, false);
	
	natArea2 = rmCreateArea("native area 2");
	rmSetAreaSize(natArea2,rmAreaTilesToFraction(230), rmAreaTilesToFraction(230));
	rmSetAreaCoherence(natArea2, 0.70);
	rmSetAreaWarnFailure(natArea2, false);
	rmSetAreaMix(natArea2, "andes_grass_a");
	rmAddAreaTerrainLayer(natArea2, "andes\ground08_and", 0, 1);
	rmSetAreaObeyWorldCircleConstraint(natArea2, false);
	
	natArea3 = rmCreateArea("native area 3");
	rmSetAreaSize(natArea3,rmAreaTilesToFraction(230), rmAreaTilesToFraction(230));
	rmSetAreaCoherence(natArea3, 0.70);
	rmSetAreaWarnFailure(natArea3, false);
	rmSetAreaMix(natArea3, "andes_grass_a");
	rmAddAreaTerrainLayer(natArea3, "andes\ground08_and", 0, 1);
	rmSetAreaObeyWorldCircleConstraint(natArea3, false);
	
		
	if (cNumberTeams <= 2)
	{
		if (natvariation == 0)
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.75, 0.55);
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.25, 0.45);
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.50, 0.50);
			rmSetAreaLocation(natArea1,  0.75, 0.55);
			rmBuildArea(natArea1);
			rmSetAreaLocation(natArea2,  0.25, 0.45);
			rmBuildArea(natArea2);
			rmSetAreaLocation(natArea3,  0.50, 0.50);
			rmBuildArea(natArea3);
		}
		else if (natvariation == 1)
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.70, 0.30); // 70 30
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.30, 0.70); // 30 70
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.50, 0.50);
			rmSetAreaLocation(natArea1,  0.70, 0.30);
			rmBuildArea(natArea1);
			rmSetAreaLocation(natArea2,  0.30, 0.70);
			rmBuildArea(natArea2);
			rmSetAreaLocation(natArea3,  0.50, 0.50);
			rmBuildArea(natArea3);
		}
		else if (natvariation == 2)
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.80, 0.50);
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.20, 0.50);
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.50, 0.50);
			rmSetAreaLocation(natArea1,  0.80, 0.50);
			rmBuildArea(natArea1);
			rmSetAreaLocation(natArea2,  0.20, 0.50);
			rmBuildArea(natArea2);
			rmSetAreaLocation(natArea3,  0.50, 0.50);
			rmBuildArea(natArea3);
		}
		else
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.70, 0.30); // 70 30
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.30, 0.70); // 30 70
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.50, 0.50);
			rmSetAreaLocation(natArea1,  0.70, 0.30);
			rmBuildArea(natArea1);
			rmSetAreaLocation(natArea2,  0.30, 0.70);
			rmBuildArea(natArea2);
			rmSetAreaLocation(natArea3,  0.50, 0.50);
			rmBuildArea(natArea3);
		}	
	}	
	else
	{
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.50, 0.50); // 30 70
			rmSetAreaLocation(natArea3,  0.50, 0.50);	
			rmBuildArea(natArea3);
	}
	

	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.5;
		float yLoc = 0.5;
		float walk = 0.05;

		if (randLoc == 2 && cNumberTeams <= 2) {
			xLoc = 0.2;
			yLoc = 0.7;
		} else if (randLoc == 3 && cNumberTeams <= 2) {
			xLoc = 0.8;
			yLoc = 0.3;
		}

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}


	// ******************************************************************************************************
	
	// Ponds & Lamas
	int stayNearpondArea = -1;
	int stayInpondArea = -1;
	
	for (i=0; < cNumberNonGaiaPlayers)
	{
		for (j=0; < 2)
		{
			if (j == 0)
			{
				int pondAreaID = rmCreateArea("pond"+i+j);
				rmSetAreaCoherence(pondAreaID, 0.30);
				rmSetAreaSmoothDistance(pondAreaID, 1);
				rmSetAreaSize(pondAreaID,  rmAreaTilesToFraction(220+4*cNumberNonGaiaPlayers), rmAreaTilesToFraction(240+4*cNumberNonGaiaPlayers));
				rmSetAreaWaterType(pondAreaID, "andes pond"); 
				rmAddAreaToClass(pondAreaID, rmClassID("pond"));
				if (cNumberTeams <= 2 && cNumberNonGaiaPlayers <=2)
					rmAddAreaConstraint(pondAreaID, avoidCenter);
				rmAddAreaConstraint(pondAreaID, avoidEdgeMore);
				rmAddAreaConstraint(pondAreaID, avoidClassPlayer);
				rmAddAreaConstraint(pondAreaID, avoidPond);
				rmAddAreaConstraint(pondAreaID, avoidNativesFar);
				rmAddAreaConstraint(pondAreaID, avoidKingsHill);
//				if (i < 1)
//					rmAddAreaConstraint(pondAreaID, pondNorth);
//				else if (i < 2)
//					rmAddAreaConstraint(pondAreaID, pondSouth);
				rmBuildArea(pondAreaID);	
				
				stayNearpondArea = rmCreateAreaMaxDistanceConstraint("stay near pond area"+i, pondAreaID, 14.0);
				
			}
			else
			{
				pondAreaID = rmCreateArea("pond"+i+j);
				rmSetAreaObeyWorldCircleConstraint(pondAreaID, false);
				rmSetAreaSize(pondAreaID, rmAreaTilesToFraction(450+5*cNumberNonGaiaPlayers), rmAreaTilesToFraction(450+5*cNumberNonGaiaPlayers));
//				rmSetAreaCoherence(pondAreaID, 0.20);
//				rmSetAreaSmoothDistance(pondAreaID, 3+1*cNumberNonGaiaPlayers);
				rmSetAreaMix(pondAreaID, "andes_grass_b");
				rmAddAreaTerrainLayer(pondAreaID, "andes\ground08_and", 0, 2);
				rmAddAreaConstraint(pondAreaID, stayNearpondArea);
				rmBuildArea(pondAreaID);
				
				stayInpondArea = rmCreateAreaMaxDistanceConstraint("stay in pond area"+i, pondAreaID, 0.0);
				
				int pondtreeAID = rmCreateObjectDef("pond treeA"+i+j);
				rmAddObjectDefItem(pondtreeAID, "TreeAraucania", rmRandInt(1,2), 2.0);
				rmAddObjectDefConstraint(pondtreeAID, avoidImpassableLandShort);
				rmPlaceObjectDefInArea(pondtreeAID, 0, pondAreaID);
				
				int pondtreeBID = rmCreateObjectDef("pond treeB"+i+j);
				rmAddObjectDefItem(pondtreeBID, "TreeAndes", rmRandInt(2,3), 2.0);
				rmAddObjectDefConstraint(pondtreeBID, avoidImpassableLandShort);
				rmPlaceObjectDefInArea(pondtreeBID, 0, pondAreaID);
				
				int LlamaID=rmCreateObjectDef("Llama"+i);
				rmAddObjectDefItem(LlamaID, "Llama", 2, 3.0);
				rmSetObjectDefMinDistance(LlamaID, 0.0);
				rmSetObjectDefMaxDistance(LlamaID, rmXFractionToMeters(0.5));
				rmAddObjectDefConstraint(LlamaID, avoidLlama);
				rmAddObjectDefConstraint(LlamaID, avoidForestMin);
//				rmAddObjectDefConstraint(LlamaID, avoidTownCenterFar);
				rmAddObjectDefConstraint(LlamaID, stayInpondArea);
				rmAddObjectDefConstraint(LlamaID, avoidImpassableLandShort);
				rmAddObjectDefConstraint(LlamaID, avoidEdge);
				rmPlaceObjectDefAtLoc(LlamaID, 0, 0.50, 0.50);
				rmPlaceObjectDefAtLoc(LlamaID, 0, 0.50, 0.50);
				
			}
		}			
	}
	
	
	// *****************************************************************************************************
	
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
	
	// Starting mine
	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 16.0);
	rmSetObjectDefMaxDistance(playergoldID, 17.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidGoldTypeMed);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "minetin", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 38.0); //58
	rmSetObjectDefMaxDistance(playergold2ID, 40.0); //62
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidImpassableLandMed);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldType);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold2ID, avoidEdge);
	
		
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "TreeAndes", rmRandInt(1,1), 2.0);
    rmSetObjectDefMinDistance(playerTreeID, 12);
    rmSetObjectDefMaxDistance(playerTreeID, 14);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
//	rmAddObjectDefToClass(playerTreeID, classForest);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResourcesShort);
	
	// Starting trees2
	int playerTree2ID = rmCreateObjectDef("player trees 2");
	rmAddObjectDefItem(playerTree2ID, "TreeAndes", rmRandInt(2,2), 2.0);
    rmSetObjectDefMinDistance(playerTree2ID, 14);
    rmSetObjectDefMaxDistance(playerTree2ID, 16);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
//	rmAddObjectDefToClass(playerTree2ID, classForest);
    rmAddObjectDefConstraint(playerTree2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResourcesShort);
	
	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 3, 3.0);
	rmSetObjectDefMinDistance(playerberriesID, 13.0);
	rmSetObjectDefMaxDistance(playerberriesID, 15.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerberriesID, avoidNatives);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResources);
	
	// Starting herd
	int playerherdID = rmCreateObjectDef("starting Guanaco");
	rmAddObjectDefItem(playerherdID, "Guanaco", rmRandInt(14,14), 9.0);
	rmSetObjectDefMinDistance(playerherdID, 14.0);
	rmSetObjectDefMaxDistance(playerherdID, 18.0);
	rmSetObjectDefCreateHerd(playerherdID, false);
	rmAddObjectDefToClass(playerherdID, classStartingResource);
	rmAddObjectDefConstraint(playerherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerherdID, avoidNatives);
	rmAddObjectDefConstraint(playerherdID, avoidStartingResourcesShort);
		
	// 2nd herd
	int player2ndherdID = rmCreateObjectDef("second Rhea");
	rmAddObjectDefItem(player2ndherdID, "Rhea", rmRandInt(6,6), 5.0);
    rmSetObjectDefMinDistance(player2ndherdID, 36);
    rmSetObjectDefMaxDistance(player2ndherdID, 38);
	rmAddObjectDefToClass(player2ndherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player2ndherdID, true);
	rmAddObjectDefConstraint(player2ndherdID, avoidStartingResources);
	rmAddObjectDefConstraint(player2ndherdID, avoidGuanaco); 
	rmAddObjectDefConstraint(player2ndherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(player2ndherdID, avoidNatives);
	rmAddObjectDefConstraint(player2ndherdID, avoidEdgeMore);
		
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 24.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 28.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLandMed);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetShort); //Short
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	int bonusnugget = rmRandInt (0,1); 
		
	// ******** Place ********
	
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));	
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(player2ndherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if (bonusnugget == 1)
			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));	

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}

	// ************************************************************************************************
	
	// Text
	rmSetStatusText("",0.50);
	
	// ************************************** COMMON RESOURCES ****************************************
     
	// ************* Mines **************
		
	// Silver mines
	int silverminecount = 1+3*cNumberNonGaiaPlayers; 
	
	for(i=0; < silverminecount)
	{
		int silvermineID = rmCreateObjectDef("silver mine"+i);
		rmAddObjectDefItem(silvermineID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silvermineID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(silvermineID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(silvermineID, classGold);
		rmAddObjectDefConstraint(silvermineID, avoidImpassableLandMed);
//		rmAddObjectDefConstraint(silvermineID, avoidpondArea);
		rmAddObjectDefConstraint(silvermineID, avoidNatives);
		rmAddObjectDefConstraint(silvermineID, avoidGoldFar);
		rmAddObjectDefConstraint(silvermineID, avoidTownCenterFar);
		rmAddObjectDefConstraint(silvermineID, avoidStartingResourcesShort);
		rmAddObjectDefConstraint(silvermineID, avoidEdge);
//		if (cNumberTeams <= 2 && teamZeroCount == teamOneCount)
//		{
//			if (i < 1)
//				rmAddObjectDefConstraint(silvermineID, stayNorth);
//			else if (i < 2)
//				rmAddObjectDefConstraint(silvermineID, staySouth);
//		}		
		rmPlaceObjectDefAtLoc(silvermineID, 0, 0.50, 0.50);
	}

		
	// *********************************
		
	// Text
	rmSetStatusText("",0.65);	
		
	// ************ Forests *************
	
	// main forest
	int mainforestcount = 4+4*cNumberNonGaiaPlayers;
	int stayInmainForest = -1;
	
	for (i=0; < mainforestcount)
	{
		int mainforestID = rmCreateArea("main forest"+i);
		rmSetAreaWarnFailure(mainforestID, false);
		rmSetAreaObeyWorldCircleConstraint(mainforestID, false);
		rmSetAreaSize(mainforestID, rmAreaTilesToFraction(280), rmAreaTilesToFraction(300));
		rmSetAreaMix(mainforestID, "andes_grass_b");
		rmAddAreaTerrainLayer(mainforestID, "andes\ground09_and", 0, 1);
		rmAddAreaTerrainLayer(mainforestID, "andes\ground10_and", 1, 2);
//		rmSetAreaMinBlobs(mainforestID, 2);
//		rmSetAreaMaxBlobs(mainforestID, 4);
//		rmSetAreaMinBlobDistance(mainforestID, 10.0);
//		rmSetAreaMaxBlobDistance(mainforestID, 30.0);
		rmSetAreaCoherence(mainforestID, 0.2);
		rmSetAreaSmoothDistance(mainforestID, 5);
//		rmAddAreaToClass(mainforestID, classForest);
		rmAddAreaConstraint(mainforestID, avoidImpassableLand);
		rmAddAreaConstraint(mainforestID, avoidGoldTypeShort);
		rmAddAreaConstraint(mainforestID, avoidForest);
		rmAddAreaConstraint(mainforestID, avoidTradeRouteShort);
		rmAddAreaConstraint(mainforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(mainforestID, avoidNatives);
		rmAddAreaConstraint(mainforestID, avoidTownCenterShort);
		rmAddAreaConstraint(mainforestID, avoidStartingResourcesShort);
		rmBuildArea(mainforestID);
		
		stayInmainForest = rmCreateAreaMaxDistanceConstraint("stay in main forest"+i, mainforestID, 0);
	
		for (j=0; < rmRandInt(15,17)) 
		{
			int maintreeID = rmCreateObjectDef("main tree"+i+" "+j);
			
			rmAddObjectDefItem(maintreeID, "TreeAraucania", rmRandInt(1,2), 2.0); // 1,2
			rmSetObjectDefMinDistance(maintreeID, 0);
			rmSetObjectDefMaxDistance(maintreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(maintreeID, classForest);
			rmAddObjectDefConstraint(maintreeID, stayInmainForest);	
		//	rmAddObjectDefConstraint(maintreeID, avoidImpassableLandShort);	
			rmPlaceObjectDefAtLoc(maintreeID, 0, 0.50, 0.50);
		}
	}
	
	// Secondary forest
	int secondaryforestcount = 2+2*cNumberNonGaiaPlayers;
	int stayInsecondaryforest = -1;
	
	for (i=0; < secondaryforestcount)
	{
		int secondaryforestID = rmCreateArea("secondary forest"+i);
		rmSetAreaWarnFailure(secondaryforestID, false);
//		rmSetAreaObeyWorldCircleConstraint(secondaryforestID, false);
		rmSetAreaSize(secondaryforestID, rmAreaTilesToFraction(140), rmAreaTilesToFraction(160));
		rmSetAreaMix(secondaryforestID, "andes_grass_b");
		rmAddAreaTerrainLayer(secondaryforestID, "andes\ground09_and", 0, 1);
		rmAddAreaTerrainLayer(secondaryforestID, "andes\ground10_and", 1, 2);
//		rmSetAreaMinBlobs(secondaryforestID, 2);
//		rmSetAreaMaxBlobs(secondaryforestID, 4);
//		rmSetAreaMinBlobDistance(secondaryforestID, 10.0);
//		rmSetAreaMaxBlobDistance(secondaryforestID, 30.0);
		rmSetAreaCoherence(secondaryforestID, 0.2);
		rmSetAreaSmoothDistance(secondaryforestID, 5);
//		rmAddAreaToClass(secondaryforestID, classForest);
		rmAddAreaConstraint(secondaryforestID, avoidImpassableLand);
		rmAddAreaConstraint(secondaryforestID, avoidGoldTypeShort);
		rmAddAreaConstraint(secondaryforestID, avoidForestShort);
		rmAddAreaConstraint(secondaryforestID, avoidTradeRouteShort);
		rmAddAreaConstraint(secondaryforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(secondaryforestID, avoidNatives);
		rmAddAreaConstraint(secondaryforestID, avoidTownCenterShort);
		rmAddAreaConstraint(secondaryforestID, avoidStartingResourcesShort);
		rmBuildArea(secondaryforestID);
		
		stayInsecondaryforest = rmCreateAreaMaxDistanceConstraint("stay in secondary forest"+i, secondaryforestID, 0);
	
		for (j=0; < rmRandInt(5,6)) 
		{
			int secondarytreeID = rmCreateObjectDef("secondary tree"+i+j);
			rmAddObjectDefItem(secondarytreeID, "TreeAndes", rmRandInt(1,2), 2.0); // 1,2
			rmSetObjectDefMinDistance(secondarytreeID, 0);
			rmSetObjectDefMaxDistance(secondarytreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(secondarytreeID, classForest);
			rmAddObjectDefConstraint(secondarytreeID, stayInsecondaryforest);	
		//	rmAddObjectDefConstraint(secondarytreeID, avoidImpassableLandShort);	
			rmPlaceObjectDefAtLoc(secondarytreeID, 0, 0.50, 0.50);
		}
	}
		
	
	// ********************************
	
	// Text
	rmSetStatusText("",0.75);

	// ************ Herds *************
	
	//Rhea herds
	int Rheacount = 2+2*cNumberNonGaiaPlayers;
	
	for (i=0; < Rheacount)
	{
		int RheaherdID = rmCreateObjectDef("Rhea herd"+i);
		rmAddObjectDefItem(RheaherdID, "Rhea", rmRandInt(6,7), 5.0);
		rmSetObjectDefMinDistance(RheaherdID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(RheaherdID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(RheaherdID, true);
		rmAddObjectDefConstraint(RheaherdID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(RheaherdID, avoidEdgeMore);
		rmAddObjectDefConstraint(RheaherdID, avoidNatives);
		rmAddObjectDefConstraint(RheaherdID, avoidForestMin);
		rmAddObjectDefConstraint(RheaherdID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(RheaherdID, avoidGuanaco);
		rmAddObjectDefConstraint(RheaherdID, avoidRheaFar);
		rmAddObjectDefConstraint(RheaherdID, avoidTownCenter);
		rmAddObjectDefConstraint(RheaherdID, avoidEdge);
//		if (cNumberTeams <= 2 && teamZeroCount == teamOneCount)
//		{
//			if (i < 2)
//				rmAddObjectDefConstraint(silvermineID, stayNorth);
//			else if (i < 4)
//				rmAddObjectDefConstraint(silvermineID, staySouth);
//		}
		rmPlaceObjectDefAtLoc(RheaherdID, 0, 0.50, 0.50);
	}

	//Guanaco herds
	int Guanacocount = 2+2*cNumberNonGaiaPlayers;
	
	for (i=0; < Guanacocount)
	{
		int GuanacoherdID = rmCreateObjectDef("Guanaco herd"+i);
		rmAddObjectDefItem(GuanacoherdID, "Guanaco", rmRandInt(8,9), 6.0);
		rmSetObjectDefMinDistance(GuanacoherdID, 0.0);
		rmSetObjectDefMaxDistance(GuanacoherdID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(GuanacoherdID, true);
//		rmAddObjectDefConstraint(GuanacoherdID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(GuanacoherdID, avoidCenter);
		rmAddObjectDefConstraint(GuanacoherdID, avoidNatives);
		rmAddObjectDefConstraint(GuanacoherdID, avoidForestMin);
		rmAddObjectDefConstraint(GuanacoherdID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(GuanacoherdID, avoidGuanacoFar);
		rmAddObjectDefConstraint(GuanacoherdID, avoidRhea);
		rmAddObjectDefConstraint(GuanacoherdID, avoidTownCenter);
		rmAddObjectDefConstraint(GuanacoherdID, avoidEdge);
		rmPlaceObjectDefAtLoc(GuanacoherdID, 0, 0.50, 0.50);
	}
		
	// ************************************
	
	// Text
	rmSetStatusText("",0.80);
		
	// ************** Treasures ***************
	
	int treasure4count = 1*cNumberTeams;
	int treasure3count = cNumberNonGaiaPlayers/cNumberTeams;
	int treasure2count = 3+1*cNumberNonGaiaPlayers;
	int treasure1count = 2+1*cNumberNonGaiaPlayers-bonusnugget*cNumberNonGaiaPlayers;
		
	// Treasures lvl 2	
	for (i=1; < treasure2count+1)
	{
		int Nugget2ID = rmCreateObjectDef("nugget lvl2 "+i); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(2,2);
		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidGuanacoMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidRheaMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge); 
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}
	
	// Treasures lvl 1	
	for (i=1; < treasure1count+1)
	{
		int Nugget1ID = rmCreateObjectDef("nugget lvl1 "+i); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, 0);
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(1,1);
		rmAddObjectDefConstraint(Nugget1ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget1ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget1ID, avoidGuanacoMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidRheaMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge); 
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);
	}
	
	// Treasures lvl 3	
	for (i=1; < treasure3count+1)
	{
		int Nugget3ID = rmCreateObjectDef("nugget lvl3 "+i); 
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, 0);
		rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(3,3);
		rmAddObjectDefConstraint(Nugget3ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRoute);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidGuanacoMin); 
		rmAddObjectDefConstraint(Nugget3ID, avoidRheaMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidEdge); 
		if (cNumberNonGaiaPlayers >= 3)
			rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50);
	}
	
	// Treasures lvl 4	
	for (i=1; < treasure4count+1)
	{
		int Nugget4ID = rmCreateObjectDef("nugget lvl4 "+i); 
		rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget4ID, 0);
		rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(4,4);
		rmAddObjectDefConstraint(Nugget4ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRoute);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidGuanacoMin); 
		rmAddObjectDefConstraint(Nugget4ID, avoidRheaMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidEdge); 
		if (cNumberTeams <= 2 && cNumberNonGaiaPlayers >= 4)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.50, 0.50);
	}
		
	// ****************************************
		
	// Text
	rmSetStatusText("",0.90);
	
/*	// **************** Llamas *****************
	
	int Llamacount = 2*cNumberNonGaiaPlayers;
	
	for (i=0; < Llamacount)
	{
		
	}
 */


	// Text
	rmSetStatusText("",1.00);

	
 //END
} // END
	
	