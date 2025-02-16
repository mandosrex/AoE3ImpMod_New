// vivid's Bering Strait (Obs) v3
// designed by vividlyplain
// Observer UI by Aizamk

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
	int playerTiles=10000;
	if (cNumberNonGaiaPlayers >= 4){
		playerTiles = 8000;
	}
	else if (cNumberNonGaiaPlayers >= 6){
		playerTiles = 7000;
	}
	
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmSetMapSize(size, size);
	
	// Make the corners
	rmSetWorldCircleConstraint(true);
	
	// Picks a default water height
	rmSetSeaLevel(0.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	// Picks default terrain and water
	rmSetSeaType("great lakes");
	rmSetBaseTerrainMix("rockies_grass_snowb");
	rmTerrainInitialize("yukon\ground8_yuk");
	rmSetMapType("siberia"); 
	rmSetMapType("yukon");
	rmSetMapType("snow");
	rmSetMapType("land");
	rmSetMapType("namerica");
	rmSetLightingSet("great lakes winter");

	// Choose Mercs
	chooseMercs();
	
	// Make it snow
	rmSetGlobalSnow(0.65);
  
	// Text
	rmSetStatusText("",0.10);

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classPatch3 = rmDefineClass("patch3");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	int classIsland=rmDefineClass("island");
	
	// Text
	rmSetStatusText("",0.20);
	
	// ____________________ Constraints ____________________
	// These are used to have objects and areas avoid each other
   
	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenterMin = rmCreatePieConstraint("Avoid Center min",0.5,0.5,rmXFractionToMeters(0.1), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));

	int staySouthPart = rmCreatePieConstraint("Stay south part", 0.55, 0.55,rmXFractionToMeters(0.0), rmXFractionToMeters(0.60), rmDegreesToRadians(135),rmDegreesToRadians(315));
	int stayNorthHalf = rmCreatePieConstraint("Stay north half", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(360),rmDegreesToRadians(180));
		
	// Resource avoidance
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 34.0);
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 30.0);
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 15.0);
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("Forest"), 25.0);
	int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("Forest"), 20.0);
	int avoidOx = rmCreateTypeDistanceConstraint("avoid Musk Ox", "MuskOx", 30.0);
	int avoidOxFar = rmCreateTypeDistanceConstraint("avoid Musk Ox far", "MuskOx", 40.0);
	int avoidOxShort = rmCreateTypeDistanceConstraint("avoid Musk Ox short", "MuskOx", 20.0);
	int avoidOxMin = rmCreateTypeDistanceConstraint("avoid Musk Ox min", "MuskOx", 10.0);
	int avoidMuskdeerFar = rmCreateTypeDistanceConstraint("avoid Muskdeer far", "Seal", 60.0);
	int avoidMuskdeer = rmCreateTypeDistanceConstraint("avoid Muskdeer", "Seal", 44.0);
	int avoidMuskdeerShort = rmCreateTypeDistanceConstraint("avoid Muskdeer short", "Seal", 30.0);
	int avoidMuskdeerMin = rmCreateTypeDistanceConstraint("avoid Muskdeer min", "Seal", 10.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 25.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 20.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 45.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 52.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 15.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 30.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 52.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 75.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 20.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 30.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 60.0);
	int avoidNuggetVeryFar = rmCreateTypeDistanceConstraint("nugget avoid nugget very far", "AbstractNugget", 80.0);
	int avoidTownCenterVeryFar = rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 85.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 60.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 48.0); //46
	int avoidTownCenterMed = rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 40.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 20.0);
	int avoidTownCenterMin = rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 18.0);
	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 12.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesMin = rmCreateClassDistanceConstraint("avoid starting resources min", rmClassID("startingResource"), 4.0);

	// Avoid impassable land
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 16.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 16.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 5.0);
	int avoidIslandMin=rmCreateClassDistanceConstraint("avoid island min", classIsland, 8.0);
	int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 10.0);
	int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 16.0);
	int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 32.0);
	int stayIsland=rmCreateClassDistanceConstraint("stay island", classIsland, 0.0);
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteSocketMin = rmCreateTradeRouteDistanceConstraint("trade route socket min", 4.0);
	int avoidTradeRouteSocketShort = rmCreateTradeRouteDistanceConstraint("trade route socket short", 12.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 20.0);
	int avoidTradeRouteSocketFar = rmCreateTypeDistanceConstraint("avoid trade route socket far", "socketTradeRoute", 30.0);
	
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
					rmPlacePlayer(1, 0.2, 0.6);
					rmPlacePlayer(2, 0.8, 0.4);
				}
				else
				{
					rmPlacePlayer(2, 0.2, 0.6);
					rmPlacePlayer(1, 0.8, 0.4);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.2, 0.6, 0.4, 0.9, 0, 0);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.8, 0.4, 0.6, 0.1, 0, 0);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.2, 0.6, 0.4, 0.9, 0, 0);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.8, 0.4, 0.6, 0.1, 0, 0);
				}
			}
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.8, 0.4, 0.6, 0.1, 0, 0);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmPlacePlayersLine(0.2, 0.6, 0.4, 0.9, 0, 0);
						else
							rmPlacePlayersLine(0.2, 0.6, 0.4, 0.9, 0, 0);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.2, 0.6, 0.4, 0.9, 0, 0);

						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmPlacePlayersLine(0.8, 0.4, 0.6, 0.1, 0, 0);
						else
							rmPlacePlayersLine(0.8, 0.4, 0.6, 0.1, 0, 0);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.2, 0.6, 0.4, 0.9, 0, 0);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.8, 0.4, 0.6, 0.1, 0, 0);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.2, 0.6, 0.4, 0.9, 0, 0);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.8, 0.4, 0.6, 0.1, 0, 0);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.2, 0.6, 0.4, 0.9, 0, 0);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.8, 0.4, 0.6, 0.1, 0, 0);
				}
			}
		}
		else // FFA
		{
		rmSetTeamSpacingModifier(0.25);
		rmSetPlacementSection(0.0, 1.0);
		rmPlacePlayersCircular(0.4, 0.4, 0.0);
		}


	// Text
	rmSetStatusText("",0.30);
	
	// ____________________ Map Parameters ____________________
	// Ice Sheet
	int iceID = rmCreateArea("ice sheet");
	rmSetAreaSize(iceID, 0.99, 0.99);
	rmSetAreaLocation(iceID, 0.50, 0.50);
	rmSetAreaMix(iceID, "great_lakes_ice");
	rmSetAreaWarnFailure(iceID, false);
	rmSetAreaCoherence(iceID, 1.0); 
	rmSetAreaBaseHeight(iceID, -1.0);
	rmSetAreaObeyWorldCircleConstraint(iceID, false);
	rmBuildArea(iceID);

	int avoidIce = rmCreateTerrainDistanceConstraint("stuff avoids ice", "Land", false, 0.0);

	// 1v1 and Team Spawn
	for(i=1; <3)
    {
		int playerislandID=rmCreateArea("player island"+i);
		rmSetAreaSize(playerislandID, 0.2655, 0.2655);
		if (i < 2) {
			rmSetAreaLocation(playerislandID, 0.0, 1.00);
			rmAddAreaInfluenceSegment(playerislandID, 0.0, 1.0, 0.2, 0.8);
			}
		else {
			rmSetAreaLocation(playerislandID, 1.00, 0.0);
			rmAddAreaInfluenceSegment(playerislandID, 1.0, 0.0, 0.8, 0.2);
			}
		rmSetAreaMix(playerislandID, "rockies_grass_snowb");
		rmSetAreaWarnFailure(playerislandID, false);
		rmAddAreaToClass(playerislandID, classIsland);
		rmSetAreaCoherence(playerislandID, 0.85);
		rmSetAreaSmoothDistance(playerislandID, 10);
		rmSetAreaElevationType(playerislandID, cElevTurbulence);
		rmSetAreaElevationVariation(playerislandID, 2.5);
		rmSetAreaBaseHeight(playerislandID, 0.0);
		rmSetAreaElevationMinFrequency(playerislandID, 0.09);
		rmSetAreaElevationOctaves(playerislandID, 3);
		rmSetAreaElevationPersistence(playerislandID, 0.4);      
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

	// FFA Spawn
	for (i=1; < cNumberPlayers)
	{
		int playerareaID = rmCreateArea("playerarea"+i);
		rmSetPlayerArea(i, playerareaID);
		if (cNumberNonGaiaPlayers <= 4)
			rmSetAreaSize(playerareaID, 0.09, 0.09);
		else if (cNumberNonGaiaPlayers == 5)
			rmSetAreaSize(playerareaID, 0.0755, 0.0755);
		else if (cNumberNonGaiaPlayers == 6)
			rmSetAreaSize(playerareaID, 0.0652, 0.0652);
		else
			rmSetAreaSize(playerareaID, 0.0525, 0.0525);
		rmSetAreaLocPlayer(playerareaID, i);
		rmAddAreaToClass(playerareaID, classIsland);
		rmSetAreaCoherence(playerareaID, 0.85);
		rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
		rmSetAreaMix(playerareaID, "rockies_grass_snowb");
		rmSetAreaWarnFailure(playerareaID, false);
		rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
		rmSetAreaSmoothDistance(playerareaID, 10);
		rmSetAreaElevationType(playerareaID, cElevTurbulence);
		rmSetAreaElevationVariation(playerareaID, 2.5);
		rmSetAreaBaseHeight(playerareaID, 0.0);
		rmSetAreaElevationMinFrequency(playerareaID, 0.09);
		rmSetAreaElevationOctaves(playerareaID, 3);
		rmSetAreaElevationPersistence(playerareaID, 0.4);    
		if (cNumberTeams > 2)
			rmBuildArea(playerareaID);
		rmCreateAreaDistanceConstraint("avoid player area "+i, playerareaID, 3.0);
		rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerareaID, 0.0);
	}

	//King's Island
	if (rmGetIsKOTH() == true) {
		int kingislandID=rmCreateArea("King's Island");
		rmSetAreaSize(kingislandID, 0.01, 0.01);
		rmSetAreaLocation(kingislandID, 0.5, 0.5);
		rmSetAreaMix(kingislandID, "rockies_grass_snowb");
		rmAddAreaToClass(kingislandID, classIsland);
		rmSetAreaBaseHeight(kingislandID, 1.0);
		rmSetAreaCoherence(kingislandID, 1.0);
		rmBuildArea(kingislandID); 
	
	// Place King's Hill
	float xLoc = 0.5;
	float yLoc = 0.5;
	float walk = 0.03;

	ypKingsHillPlacer(xLoc, yLoc, walk, 0);
	rmEchoInfo("XLOC = "+xLoc);
	rmEchoInfo("XLOC = "+yLoc);
	}

	int avoidKOTH = rmCreateAreaDistanceConstraint("avoid KOTH", kingislandID, 18.0);
	int stayKOTH = rmCreateAreaMaxDistanceConstraint("stay in KOTH", kingislandID, 0.0);
	
	//Ice islands
	for (i=0; <6*cNumberNonGaiaPlayers)
	{
		int iceislandID=rmCreateArea("ice island"+i);
		rmSetAreaSize(iceislandID, 0.02, 0.02);
		rmSetAreaMix(iceislandID, "rockies_grass_snowb");
		rmSetAreaWarnFailure(iceislandID, false);
		rmAddAreaToClass(iceislandID, classIsland);
		rmSetAreaCoherence(iceislandID, 0.85);
		rmSetAreaSmoothDistance(iceislandID, 5);
		rmSetAreaElevationType(iceislandID, cElevTurbulence);
		rmSetAreaElevationVariation(iceislandID, 2.0);
		rmSetAreaBaseHeight(iceislandID, 0.5);
		rmSetAreaElevationMinFrequency(iceislandID, 0.09);
		rmSetAreaElevationOctaves(iceislandID, 3);
		rmSetAreaElevationPersistence(iceislandID, 0.4);      
		rmSetAreaObeyWorldCircleConstraint(iceislandID, false);
		rmAddAreaConstraint(iceislandID, avoidIsland);
		rmBuildArea(iceislandID);
	}

	int avoidIceIsles = rmCreateAreaDistanceConstraint("avoid ice isles", iceislandID, 12.0);
	int stayIceIsles = rmCreateAreaMaxDistanceConstraint("stay in ice isles", iceislandID, 0.0);
	
	// Gold Zone W
	int GoldZoneWID = rmCreateArea("gold zone W");
	if (cNumberNonGaiaPlayers == 2) {
		rmSetAreaSize(GoldZoneWID, 0.06, 0.06);
		rmSetAreaLocation(GoldZoneWID, 0.40, 0.80);
		rmAddAreaInfluenceSegment(GoldZoneWID, 0.40, 0.80, 0.20, 0.85);	
		rmAddAreaInfluenceSegment(GoldZoneWID, 0.20, 0.85, 0.35, 0.85);	
		}
	else if (cNumberNonGaiaPlayers == 4) {
		rmSetAreaSize(GoldZoneWID, 0.02, 0.02);
		rmSetAreaLocation(GoldZoneWID, 0.25, 0.75);
		}
	else {
		rmSetAreaSize(GoldZoneWID, 0.03, 0.03);
		rmSetAreaLocation(GoldZoneWID, 0.30, 0.90);
		rmAddAreaInfluenceSegment(GoldZoneWID, 0.30, 0.90, 0.10, 0.70);	
		}
	rmSetAreaWarnFailure(GoldZoneWID, false);
//	rmSetAreaMix(GoldZoneWID, "yellow_river_b");	// for testing
	rmSetAreaCoherence(GoldZoneWID, 1.0); 
	rmSetAreaElevationType(GoldZoneWID, cElevTurbulence);
	rmSetAreaElevationVariation(GoldZoneWID, 5.0);
	rmSetAreaElevationMinFrequency(GoldZoneWID, 0.04);
	rmSetAreaElevationOctaves(GoldZoneWID, 3);
	rmSetAreaElevationPersistence(GoldZoneWID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(GoldZoneWID, false);
	if (cNumberTeams == 2)
		rmBuildArea(GoldZoneWID);	

	// Gold Zone E
	int GoldZoneEID = rmCreateArea("gold zone E");
	if (cNumberNonGaiaPlayers == 2) {
		rmSetAreaSize(GoldZoneEID, 0.06, 0.06);
		rmSetAreaLocation(GoldZoneEID, 0.60, 0.20);
		rmAddAreaInfluenceSegment(GoldZoneEID, 0.60, 0.20, 0.80, 0.15);	
		rmAddAreaInfluenceSegment(GoldZoneEID, 0.80, 0.15, 0.65, 0.15);	
		}
	else if (cNumberNonGaiaPlayers == 4) {
		rmSetAreaSize(GoldZoneEID, 0.02, 0.02);
		rmSetAreaLocation(GoldZoneEID, 0.75, 0.25);
		}
	else {
		rmSetAreaSize(GoldZoneEID, 0.03, 0.03);
		rmSetAreaLocation(GoldZoneEID, 0.70, 0.10);
		rmAddAreaInfluenceSegment(GoldZoneEID, 0.70, 0.10, 0.90, 0.30);	
		}
	rmSetAreaWarnFailure(GoldZoneEID, false);
//	rmSetAreaMix(GoldZoneEID, "yellow_river_b");	// for testing
	rmSetAreaCoherence(GoldZoneEID, 1.0); 
	rmSetAreaElevationType(GoldZoneEID, cElevTurbulence);
	rmSetAreaElevationVariation(GoldZoneEID, 5.0);
	rmSetAreaElevationMinFrequency(GoldZoneEID, 0.04);
	rmSetAreaElevationOctaves(GoldZoneEID, 3);
	rmSetAreaElevationPersistence(GoldZoneEID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(GoldZoneEID, false);
	if (cNumberTeams == 2)
		rmBuildArea(GoldZoneEID);	

	int avoidGoldZoneE = rmCreateAreaDistanceConstraint("avoid gold zone E ", GoldZoneEID, 20.0);
	int avoidGoldZoneEShort = rmCreateAreaDistanceConstraint("avoid gold zone E short ", GoldZoneEID, 12.0);
	int stayGoldZoneE = rmCreateAreaMaxDistanceConstraint("stay in gold zone E ", GoldZoneEID, 0.0);	
	int avoidGoldZoneW = rmCreateAreaDistanceConstraint("avoid gold zone W ", GoldZoneWID, 20.0);
	int avoidGoldZoneWShort = rmCreateAreaDistanceConstraint("avoid gold zone W short ", GoldZoneWID, 12.0);
	int stayGoldZoneW = rmCreateAreaMaxDistanceConstraint("stay in gold zone W ", GoldZoneWID, 0.0);
	
	// Patch1
	for (i=0; < 12*cNumberNonGaiaPlayers)
    {
        int patch1ID = rmCreateArea("patch1"+i);
        rmSetAreaWarnFailure(patch1ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch1ID, false);
        rmSetAreaSize(patch1ID, rmAreaTilesToFraction(01), rmAreaTilesToFraction(01));
		rmSetAreaTerrainType(patch1ID, "rockies\ground1_roc");
        rmAddAreaToClass(patch1ID, rmClassID("patch"));
        rmSetAreaMinBlobs(patch1ID, 1);
        rmSetAreaMaxBlobs(patch1ID, 5);
        rmSetAreaMinBlobDistance(patch1ID, 16.0);
        rmSetAreaMaxBlobDistance(patch1ID, 16.0);
        rmSetAreaCoherence(patch1ID, 0.0);
		rmAddAreaConstraint(patch1ID, avoidPatch);
		rmAddAreaConstraint(patch1ID, stayInPlayerIsland1);
        rmBuildArea(patch1ID); 
    }

	// Patch2
	for (i=0; < 12*cNumberNonGaiaPlayers)
    {
        int patch2ID = rmCreateArea("patch2"+i);
        rmSetAreaWarnFailure(patch2ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch2ID, false);
        rmSetAreaSize(patch2ID, rmAreaTilesToFraction(01), rmAreaTilesToFraction(01));
		rmSetAreaTerrainType(patch2ID, "rockies\ground1_roc");
        rmAddAreaToClass(patch2ID, rmClassID("patch2"));
        rmSetAreaMinBlobs(patch2ID, 1);
        rmSetAreaMaxBlobs(patch2ID, 5);
        rmSetAreaMinBlobDistance(patch2ID, 16.0);
        rmSetAreaMaxBlobDistance(patch2ID, 16.0);
        rmSetAreaCoherence(patch2ID, 0.0);
		rmAddAreaConstraint(patch2ID, avoidPatch2);
		rmAddAreaConstraint(patch2ID, stayInPlayerIsland2);
        rmBuildArea(patch2ID); 
    }

	// Text
	rmSetStatusText("",0.40);

	// Trade Route
	if (cNumberTeams == 2) {
	
	if (rmGetIsKOTH() == true) {
		int tradeRouteID = rmCreateTradeRoute();
        int tradeRouteID2 = rmCreateTradeRoute();

		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 6.0);      

		int socketID2=rmCreateObjectDef("sockets to dock Trade Posts2");
        rmAddObjectDefItem(socketID2, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID2, true);
        rmSetObjectDefMinDistance(socketID2, 0.0);
        rmSetObjectDefMaxDistance(socketID2, 6.0);      
		
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 1.00, .40);
		rmAddTradeRouteWaypoint(tradeRouteID, .95, .35);
		rmAddTradeRouteWaypoint(tradeRouteID, .875, .25);
		rmAddTradeRouteWaypoint(tradeRouteID, .775, .15);
		rmAddTradeRouteWaypoint(tradeRouteID, .65, .05);
		rmAddTradeRouteWaypoint(tradeRouteID, .70, .00);
       
        rmSetObjectDefTradeRouteID(socketID2, tradeRouteID2);
		rmAddTradeRouteWaypoint(tradeRouteID2, .00, .60);
		rmAddTradeRouteWaypoint(tradeRouteID2, .05, .65);
		rmAddTradeRouteWaypoint(tradeRouteID2, .15, .775);
		rmAddTradeRouteWaypoint(tradeRouteID2, .25, .875);
		rmAddTradeRouteWaypoint(tradeRouteID2, .35, .95);
		rmAddTradeRouteWaypoint(tradeRouteID2, .30, 1.00);
		
        rmBuildTradeRoute(tradeRouteID, "water");
        rmBuildTradeRoute(tradeRouteID2, "water");

        vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.35);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.74);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		
        vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.35);
        rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
		socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.74);
        rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
		}
		
	else {
		int socketID3=rmCreateObjectDef("sockets to dock Trade Posts3");
        rmAddObjectDefItem(socketID3, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID3, true);
        rmSetObjectDefMinDistance(socketID3, 0.0);
        rmSetObjectDefMaxDistance(socketID3, 6.0);      
       
        int tradeRouteID3 = rmCreateTradeRoute();
        rmSetObjectDefTradeRouteID(socketID3, tradeRouteID3);
			rmAddTradeRouteWaypoint(tradeRouteID3, 0.95, 0.50);
			rmAddTradeRouteWaypoint(tradeRouteID3, 0.70, 0.50);
			rmAddTradeRouteWaypoint(tradeRouteID3, 0.55, 0.45);
			rmAddTradeRouteWaypoint(tradeRouteID3, 0.45, 0.55);
			rmAddTradeRouteWaypoint(tradeRouteID3, 0.30, 0.50);
			rmAddTradeRouteWaypoint(tradeRouteID3, 0.05, 0.50);
        rmBuildTradeRoute(tradeRouteID3, "water");
 
        vector socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.07);
        rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
        If (cNumberNonGaiaPlayers > 2) { 
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.35);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
		
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.65);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
			}
        socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.93);
        rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
		}
	}

	// ____________________ Static Resources ____________________
	// Static Mines 
	int staticgold1ID = rmCreateObjectDef("staticgold1");
		rmAddObjectDefItem(staticgold1ID, "Minegold", 1, 2.0);
		rmSetObjectDefMinDistance(staticgold1ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticgold1ID, rmXFractionToMeters(0.00));
		rmAddObjectDefToClass(staticgold1ID, classGold);
		if (cNumberNonGaiaPlayers == 2)
			rmPlaceObjectDefAtLoc(staticgold1ID, 0, 0.70, 0.90);

	int staticgold2ID = rmCreateObjectDef("staticgold2");
		rmAddObjectDefItem(staticgold2ID, "Minegold", 1, 2.0);
		rmSetObjectDefMinDistance(staticgold2ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticgold2ID, rmXFractionToMeters(0.00));
		rmAddObjectDefToClass(staticgold2ID, classGold);
		if (cNumberNonGaiaPlayers == 2)
			rmPlaceObjectDefAtLoc(staticgold2ID, 0, 0.30, 0.10);

	// Static Herds 
		int staticherdID = rmCreateObjectDef("static herd");
		rmAddObjectDefItem(staticherdID, "MuskOx", rmRandInt(5,5), 4.0);
		rmSetObjectDefMinDistance(staticherdID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticherdID, rmXFractionToMeters(0.00));
		rmSetObjectDefCreateHerd(staticherdID, true);
		if (cNumberNonGaiaPlayers == 2)
			rmPlaceObjectDefAtLoc(staticherdID, 0, 0.65, 0.35);

		int staticherd2ID = rmCreateObjectDef("static herd2");
		rmAddObjectDefItem(staticherd2ID, "MuskOx", rmRandInt(5,5), 4.0);
		rmSetObjectDefMinDistance(staticherd2ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticherd2ID, rmXFractionToMeters(0.00));
		rmSetObjectDefCreateHerd(staticherd2ID, true);
		if (cNumberNonGaiaPlayers == 2)
			rmPlaceObjectDefAtLoc(staticherd2ID, 0, 0.35, 0.65);
			
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
	rmAddObjectDefConstraint(playergoldID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playergoldID, avoidGold);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 24.0);
	rmSetObjectDefMaxDistance(playergold2ID, 24.0);
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidGold);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRouteSocket);
	
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "treeyukonsnow", rmRandInt(6,6), 5.0);
    rmSetObjectDefMinDistance(playerTreeID, 18);
    rmSetObjectDefMaxDistance(playerTreeID, 18);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	
	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 1, 1.0);
	rmSetObjectDefMinDistance(playerberriesID, 14.0);
	rmSetObjectDefMaxDistance(playerberriesID, 14.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResourcesShort);
	
	// Starting herd
	int playeherdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playeherdID, "Seal", rmRandInt(8,8), 4.0);
	rmSetObjectDefMinDistance(playeherdID, 13);
	rmSetObjectDefMaxDistance(playeherdID, 16);
	rmSetObjectDefCreateHerd(playeherdID, false);
	rmAddObjectDefToClass(playeherdID, classStartingResource);
	rmAddObjectDefConstraint(playeherdID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playeherdID, avoidTradeRouteSocketShort);
		
	// 2nd herd
	int player2ndherdID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(player2ndherdID, "Seal", rmRandInt(8,8), 4.0);
    rmSetObjectDefMinDistance(player2ndherdID, 28);
    rmSetObjectDefMaxDistance(player2ndherdID, 32);
	rmAddObjectDefToClass(player2ndherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player2ndherdID, true);
	rmAddObjectDefConstraint(player2ndherdID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(player2ndherdID, avoidEdge);
	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(player2ndherdID, avoidOx);

	// Japan Extra Orchard Rickshaw
	int extraberrywagonID=rmCreateObjectDef("Japan Extra Orchard Rickshaw");
	rmAddObjectDefItem(extraberrywagonID, "ypBerryWagon1", 1, 0.0);
	rmSetObjectDefMinDistance(extraberrywagonID, 16.0);
	rmSetObjectDefMaxDistance(extraberrywagonID, 16.0);
	rmAddObjectDefToClass(extraberrywagonID, classStartingResource);
	rmAddObjectDefConstraint(extraberrywagonID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(extraberrywagonID, avoidEdge);
	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 30.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 30.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteSocketMin);
	
	//  Place Starting Objects/Resources
	
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (cNumberNonGaiaPlayers > 2)
			rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (cNumberTeams > 2)
			rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	//	rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playeherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(player2ndherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (rmGetPlayerCiv(i) == rmGetCivID("Japanese")) {
			rmPlaceObjectDefAtLoc(extraberrywagonID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			}
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}
	
	// Text
	rmSetStatusText("",0.60);
	
	// ____________________ Common Resources ____________________
	if (cNumberTeams > 2 || cNumberNonGaiaPlayers > 2) {
		// Common Mines 
		int goldcount = 2+2*cNumberNonGaiaPlayers;  
		
		for(i=0; < goldcount) {
			int commongoldID = rmCreateObjectDef("common mines"+i);
			rmAddObjectDefItem(commongoldID, "Mine", 1, 0.0);
			rmSetObjectDefMinDistance(commongoldID, rmXFractionToMeters(0.00));
			rmSetObjectDefMaxDistance(commongoldID, rmXFractionToMeters(0.45));
			rmAddObjectDefToClass(commongoldID, classGold);
			rmAddObjectDefConstraint(commongoldID, avoidTradeRoute);
			rmAddObjectDefConstraint(commongoldID, avoidGoldTypeFar);
			rmAddObjectDefConstraint(commongoldID, avoidIce);
			rmAddObjectDefConstraint(commongoldID, avoidPlayerIsland1);
			rmAddObjectDefConstraint(commongoldID, avoidPlayerIsland2);
			rmPlaceObjectDefAtLoc(commongoldID, 0, 0.50, 0.50);
			}
		}
	else {
		// Team 1 Mines 
		int gold1count = 1+1*cNumberNonGaiaPlayers;  
		
		for(i=0; < gold1count) {
			int team1goldID = rmCreateObjectDef("common mines 1"+i);
			rmAddObjectDefItem(team1goldID, "Mine", 1, 0.0);
			rmSetObjectDefMinDistance(team1goldID, rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(team1goldID, rmXFractionToMeters(0.48));
			rmAddObjectDefToClass(team1goldID, classGold);
			rmAddObjectDefConstraint(team1goldID, avoidTradeRouteSocketMin);			
			rmAddObjectDefConstraint(team1goldID, avoidGold);
			rmAddObjectDefConstraint(team1goldID, avoidEdge);
			rmAddObjectDefConstraint(team1goldID, avoidCenter);
			rmAddObjectDefConstraint(team1goldID, avoidTownCenter);
			rmAddObjectDefConstraint(team1goldID, avoidOxShort);
			if (cNumberNonGaiaPlayers == 2)
				rmAddObjectDefConstraint(team1goldID, stayGoldZoneE);
			rmPlaceObjectDefAtLoc(team1goldID, 0, 0.50, 0.50);
			}
	
		// Team 2 Mines 
		int gold2count = 1+1*cNumberNonGaiaPlayers;  
		
		for(i=0; < gold2count) {
			int team2goldID = rmCreateObjectDef("common mines 2"+i);
			rmAddObjectDefItem(team2goldID, "Mine", 1, 0.0);
			rmSetObjectDefMinDistance(team2goldID, rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(team2goldID, rmXFractionToMeters(0.48));
			rmAddObjectDefToClass(team2goldID, classGold);
			rmAddObjectDefConstraint(team2goldID, avoidTradeRouteSocketMin);
			rmAddObjectDefConstraint(team2goldID, avoidGold);
			rmAddObjectDefConstraint(team2goldID, avoidEdge);
			rmAddObjectDefConstraint(team2goldID, avoidIce);
			rmAddObjectDefConstraint(team2goldID, avoidTownCenter);
			rmAddObjectDefConstraint(team2goldID, avoidOxShort);
			if (cNumberNonGaiaPlayers == 2)
				rmAddObjectDefConstraint(team2goldID, stayGoldZoneW);
			rmPlaceObjectDefAtLoc(team2goldID, 0, 0.50, 0.50);
			}
		}
		
	// Text
	rmSetStatusText("",0.70);

	// Team 1 Trees
	for (j=0; < (2+1*cNumberNonGaiaPlayers)) {   
		int Trees1ID=rmCreateObjectDef("team 1 trees"+j);
		rmAddObjectDefItem(Trees1ID, "treeyukonsnow", rmRandInt(18,20), rmRandFloat(10.0,12.0));
		rmAddObjectDefToClass(Trees1ID, rmClassID("Forest")); 
		rmSetObjectDefMinDistance(Trees1ID, 0);
		rmSetObjectDefMaxDistance(Trees1ID, rmXFractionToMeters(0.48));
		rmAddObjectDefConstraint(Trees1ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Trees1ID, forestConstraint);
		rmAddObjectDefConstraint(Trees1ID, avoidTownCenter);	
		rmAddObjectDefConstraint(Trees1ID, avoidGoldShort);	
		rmAddObjectDefConstraint(Trees1ID, avoidIce);	
		rmAddObjectDefConstraint(Trees1ID, stayInPlayerIsland1);
		rmAddObjectDefConstraint(Trees1ID, avoidOxShort);
		rmPlaceObjectDefAtLoc(Trees1ID, 0, 0.5, 0.5, 2+1*cNumberNonGaiaPlayers);
	}

	// Team 2 Trees
	for (j=0; < (2+1*cNumberNonGaiaPlayers)) {   
		int Trees2ID=rmCreateObjectDef("team 2 trees"+j);
		rmAddObjectDefItem(Trees2ID, "treeyukonsnow", rmRandInt(18,20), rmRandFloat(10.0,12.0));
		rmAddObjectDefToClass(Trees2ID, rmClassID("Forest")); 
		rmSetObjectDefMinDistance(Trees2ID, 0);
		rmSetObjectDefMaxDistance(Trees2ID, rmXFractionToMeters(0.48));
		rmAddObjectDefConstraint(Trees2ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Trees2ID, forestConstraint);
		rmAddObjectDefConstraint(Trees2ID, avoidTownCenter);	
		rmAddObjectDefConstraint(Trees2ID, avoidGoldShort);	
		rmAddObjectDefConstraint(Trees2ID, stayInPlayerIsland2);	
		rmAddObjectDefConstraint(Trees2ID, avoidOxShort);	
		rmPlaceObjectDefAtLoc(Trees2ID, 0, 0.5, 0.5, 2+1*cNumberNonGaiaPlayers);
	}
	
	// Random Trees
	for (i=0; < 4+1*cNumberNonGaiaPlayers)
	{
		int randomtreeID = rmCreateObjectDef("random tree"+i);
		rmAddObjectDefItem(randomtreeID, "treeyukonsnow", rmRandInt(3,5), 4.0);
		rmSetObjectDefMinDistance(randomtreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(randomtreeID,  rmXFractionToMeters(0.48));
		rmAddObjectDefToClass(randomtreeID, classForest);
		rmAddObjectDefConstraint(randomtreeID, avoidForest);
		rmAddObjectDefConstraint(randomtreeID, avoidTownCenter);
		rmAddObjectDefConstraint(randomtreeID, avoidGoldShort);
		rmAddObjectDefConstraint(randomtreeID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(randomtreeID, avoidIce);
		rmAddObjectDefConstraint(randomtreeID, avoidPlayerIsland1);
		rmAddObjectDefConstraint(randomtreeID, avoidPlayerIsland2);
		rmPlaceObjectDefAtLoc(randomtreeID, 0, 0.50, 0.50, 4+1*cNumberNonGaiaPlayers);
	}

	// Text
	rmSetStatusText("",0.80);

	// Central Herds 
	int muskdeerherdcount = 4+2*cNumberNonGaiaPlayers;
		
	for (i=0; < muskdeerherdcount) {
		int centralherdID = rmCreateObjectDef("central herd"+i);
		rmAddObjectDefItem(centralherdID, "Seal", rmRandInt(7,8), 6.0);
		rmSetObjectDefMinDistance(centralherdID, rmXFractionToMeters(0.12));
		rmSetObjectDefMaxDistance(centralherdID, rmXFractionToMeters(0.48));
		rmSetObjectDefCreateHerd(centralherdID, true);
		rmAddObjectDefConstraint(centralherdID, avoidForestMin);
		rmAddObjectDefConstraint(centralherdID, avoidGoldShort);
		rmAddObjectDefConstraint(centralherdID, avoidTownCenter); 
		rmAddObjectDefConstraint(centralherdID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(centralherdID, avoidEdge);
		rmAddObjectDefConstraint(centralherdID, avoidMuskdeer);
		rmAddObjectDefConstraint(centralherdID, avoidPlayerIsland1);
		rmAddObjectDefConstraint(centralherdID, avoidPlayerIsland2);
		rmPlaceObjectDefAtLoc(centralherdID, 0, 0.50, 0.50);	
		}

	// Team 1 Herds 
	int muskdeerherd2count = cNumberNonGaiaPlayers/2;
		
	for (i=0; < muskdeerherd2count) {
		int team1herdID = rmCreateObjectDef("team 1 herd"+i);
		if (cNumberNonGaiaPlayers == 2)
			rmAddObjectDefItem(team1herdID, "Seal", rmRandInt(7,8), 6.0);
		else
			rmAddObjectDefItem(team1herdID, "MuskOx", rmRandInt(7,8), 6.0);		
		rmSetObjectDefMinDistance(team1herdID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(team1herdID, rmXFractionToMeters(0.48));
		rmSetObjectDefCreateHerd(team1herdID, true);
		rmAddObjectDefConstraint(team1herdID, avoidForestMin);
		rmAddObjectDefConstraint(team1herdID, avoidGoldShort);
		rmAddObjectDefConstraint(team1herdID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(team1herdID, avoidEdge);
		rmAddObjectDefConstraint(team1herdID, avoidMuskdeerShort);
		rmAddObjectDefConstraint(team1herdID, avoidOx);
		rmAddObjectDefConstraint(team1herdID, avoidIce);
		rmAddObjectDefConstraint(team1herdID, stayGoldZoneE);
		rmPlaceObjectDefAtLoc(team1herdID, 0, 0.50, 0.50);	
		}

	// Team 2 Herds 
	int muskdeerherd3count = cNumberNonGaiaPlayers/2;
		
	for (i=0; < muskdeerherd3count) {
		int team2herdID = rmCreateObjectDef("team 2 herd"+i);
		if (cNumberNonGaiaPlayers == 2)
			rmAddObjectDefItem(team2herdID, "Seal", rmRandInt(7,8), 6.0);
		else
			rmAddObjectDefItem(team2herdID, "MuskOx", rmRandInt(7,8), 6.0);
		rmSetObjectDefMinDistance(team2herdID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(team2herdID, rmXFractionToMeters(0.48));
		rmSetObjectDefCreateHerd(team2herdID, true);
		rmAddObjectDefConstraint(team2herdID, avoidForestMin);
		rmAddObjectDefConstraint(team2herdID, avoidGoldShort);
		rmAddObjectDefConstraint(team2herdID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(team2herdID, avoidEdge);
		rmAddObjectDefConstraint(team2herdID, avoidMuskdeerShort);
		rmAddObjectDefConstraint(team2herdID, avoidOx);
		rmAddObjectDefConstraint(team2herdID, avoidIce);
		rmAddObjectDefConstraint(team2herdID, stayGoldZoneW);
		rmPlaceObjectDefAtLoc(team2herdID, 0, 0.50, 0.50);	
		}
		
	// Text
	rmSetStatusText("",0.90);
		
	// Treasures 
	int treasure2count = 2+cNumberNonGaiaPlayers;

	// Treasures L2	
	for (i=0; < treasure2count)
	{
		int Nugget2ID = rmCreateObjectDef("nugget lvl2 "+i); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0.0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.48));
		rmSetNuggetDifficulty(3,4);
		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetVeryFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget2ID, avoidIce); 
		rmAddObjectDefConstraint(Nugget2ID, avoidOxMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidMuskdeerMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidPlayerIsland1); 
		rmAddObjectDefConstraint(Nugget2ID, avoidPlayerIsland2); 
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}

	int treasure1count = 4+cNumberNonGaiaPlayers;
	
	// Treasures L1
	for (i=0; < treasure1count)
	{
		int Nugget1ID = rmCreateObjectDef("nugget lvl1 "+i); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, 0);
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(2,3);
		rmAddObjectDefConstraint(Nugget1ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget1ID, avoidIce); 
		rmAddObjectDefConstraint(Nugget1ID, avoidOxMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidMuskdeerMin); 
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);
	}

	// Text
	rmSetStatusText("",1.00);

	
} //END
	
	