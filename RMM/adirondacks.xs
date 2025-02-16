// ESOC ADIRONDACKS  UI 2.2c
// designed by Garja
// observer UI by Aizmak

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
	int playerTiles=11000;
	if (cNumberNonGaiaPlayers >= 4)
		playerTiles=10500;
	if (cNumberNonGaiaPlayers >= 6)
		playerTiles=10000;
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(true);
	

	
	// Picks a default water height
	rmSetSeaLevel(-3.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	rmSetMapElevationParameters(cElevTurbulence, 0.04, 3, 0.45, 4.0); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);
	
	// Picks default terrain and water
	rmSetSeaType("Adirondacks Coast"); //great lakes
//	rmEnableLocalWater(false);
	rmSetBaseTerrainMix("newengland_grass"); // nwt_forest
	rmTerrainInitialize("new_england\ground1_ne", -1.0); // 
	rmSetMapType("greatlakes"); 
	rmSetMapType("grass");
	rmSetMapType("land");
	rmSetMapType("namerica");
	rmSetMapType("AIFishingUseful");
	rmSetLightingSet("saguenay"); //
	rmSetWindMagnitude(2.0);

	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);
	
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Huron");
	rmSetSubCiv(0, "Huron");
//	rmEchoInfo("subCiv0 is Huron "+subCiv0);

	

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
	int classValley = rmDefineClass("Valley");
	int classBay = rmDefineClass("Bay");
	int classCorner = rmDefineClass("Corner");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	
	// ******************************************************************************************
	
	// Text
	rmSetStatusText("",0.05);
	
	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other
   
   
	// Cardinal Directions & Map placement
	int staySE = rmCreatePieConstraint("stay SE", 0.5, 0.5, 0.25, rmZFractionToMeters(0.50), rmDegreesToRadians(110), rmDegreesToRadians(170));
	int staySW = rmCreatePieConstraint("stay SW", 0.5, 0.5, 0.25, rmZFractionToMeters(0.50), rmDegreesToRadians(280), rmDegreesToRadians(340));
	
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.4,0.4,rmXFractionToMeters(0.25), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.4,0.4,rmXFractionToMeters(0.0), rmXFractionToMeters(0.14), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayEastclose = rmCreatePieConstraint("Stay East Close", 0.5, 0.5, rmZFractionToMeters(0.38), rmZFractionToMeters(0.50), rmDegreesToRadians(45), rmDegreesToRadians(135));
	int stayEastveryclose = rmCreatePieConstraint("Stay East Closer", 0.9, 0.5, 0.0, rmZFractionToMeters(0.12), rmDegreesToRadians(180), rmDegreesToRadians(360));
	int stayEdge = rmCreatePieConstraint("Stay Edge",0.5,0.5,rmXFractionToMeters(0.42), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int northEdge = rmCreatePieConstraint("North Edge",0.70,0.70,rmXFractionToMeters(0.2), rmXFractionToMeters(0.30), rmDegreesToRadians(0),rmDegreesToRadians(90)); 
	
	
	// Resource avoidance
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", classForest, 40.0); //15.0
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", classForest, 28.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", classForest, 20.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", classForest, 5.0);
	int avoidDeerFar = rmCreateTypeDistanceConstraint("avoid deer far", "Deer", 45.0);
	int avoidDeer = rmCreateTypeDistanceConstraint("avoid deer", "Deer", 28.0);
	int avoidDeerShort = rmCreateTypeDistanceConstraint("avoid deer short", "Deer", 24.0);
	int avoidDeerMin = rmCreateTypeDistanceConstraint("avoid deer min", "Deer", 8.0);
	int avoidBerries = rmCreateTypeDistanceConstraint("avoid berries ", "berrybush", 72.0);
	int avoidBerriesMin = rmCreateTypeDistanceConstraint("avoid berries min ", "berrybush", 10.0);
	int avoidElkFar = rmCreateTypeDistanceConstraint("avoid Elk far", "Elk", 54.0);
	int avoidElk = rmCreateTypeDistanceConstraint("avoid  Elk", "Elk", 55.0);
	int avoidElkShort = rmCreateTypeDistanceConstraint("avoid  Elk short", "Elk", 40.0);
	int avoidElkMin = rmCreateTypeDistanceConstraint(" avoids Elk min", "Elk", 10.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 16.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 9.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 42.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 45.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", classGold, 4.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", classGold, 30.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", classGold, 66.0); //70
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very ", classGold, 76.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 4.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 40.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 48.0);
	int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center  Very Far", "townCenter", 68.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 50.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 48.0);
	//	int avoidTownCenterMed=rmCreateTypeDistanceConstraint("resources avoid Town Center med", "townCenter", 40.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("resources avoid Town Center short", "townCenter", 26.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint("resources avoid Town Center", "townCenter", 40.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("stuff avoids natives short", classNative, 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", classNative, 6.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", classNative, 12.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("avoid start resources", classStartingResource, 8.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid start resources short", classStartingResource, 5.0);
	int avoidFish = rmCreateTypeDistanceConstraint("avoid fish", "fish", 16.0);
	

	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int avoidImpassableLandLong=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 25.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 3.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 15.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 10);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 25.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 1.0);
	int avoidPatch = rmCreateClassDistanceConstraint("patch avoid patch", classPatch, 10.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("patch avoid patch2", classPatch2, 10.0);
	int avoidStone = rmCreateClassDistanceConstraint("stone avoid stone", classWaterStone, 20.0+2*cNumberNonGaiaPlayers);
	int avoidGrass = rmCreateClassDistanceConstraint("grass avoid grass", classGrass, 5.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 10.0);

	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);
	int avoidColonyShip=rmCreateTypeDistanceConstraint("avoid colony ship", "HomeCityWaterSpawnFlag", 30.0);
	int avoidColonyShipShort = rmCreateTypeDistanceConstraint("avoid colony ship short", "HomeCityWaterSpawnFlag", 14.0);	
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 3.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 8.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 10.0);

	// KotH avoidance
	int avoidKingsHill = rmCreateTypeDistanceConstraint("avoid kings hill", "ypKingsHill", 20.0);

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
					rmPlacePlayer(1, 0.16, 0.64);
					rmPlacePlayer(2, 0.64, 0.16);
				}
				else
				{
					rmPlacePlayer(2, 0.16, 0.64);
					rmPlacePlayer(1, 0.64, 0.16);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.10, 0.60, 0.35, 0.65, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.60, 0.10, 0.65, 0.35, 0.00, 0.20);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.60, 0.10, 0.65, 0.38, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.10, 0.60, 0.38, 0.65, 0.00, 0.20);
				}
			}
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.60, 0.14, 0.61, 0.15, 0.00, 0.20);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmPlacePlayersLine(0.10, 0.60, 0.35, 0.65, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.10, 0.60, 0.38, 0.65, 0.00, 0.20);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.14, 0.60, 0.15, 0.61, 0.00, 0.20);

						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmPlacePlayersLine(0.60, 0.10, 0.65, 0.35, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.60, 0.10, 0.65, 0.38, 0.00, 0.20);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.10, 0.60, 0.35, 0.65, 0.00, 0.20);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.60, 0.10, 0.65, 0.38, 0.00, 0.20);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.10, 0.60, 0.38, 0.65, 0.00, 0.20);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.60, 0.10, 0.65, 0.35, 0.00, 0.20);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.06, 0.60, 0.44, 0.65, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.60, 0.06, 0.65, 0.44, 0.00, 0.20);
				}
			}
		}
		else // FFA
		{
			if (cNumberNonGaiaPlayers <= 5)
			{
				rmSetTeamSpacingModifier(0.25);
				rmSetPlayerPlacementArea(0.00, 0.00, 0.80, 0.80);
				rmSetPlacementSection(0.850, 0.400);
				rmPlacePlayersCircular(0.38, 0.38, 0.0);
			}
			else if (cNumberNonGaiaPlayers <= 6)
			{
				rmSetTeamSpacingModifier(0.25);
				rmSetPlayerPlacementArea(0.00, 0.00, 0.80, 0.80);
				rmSetPlacementSection(0.725, 0.525);
				rmPlacePlayersCircular(0.41, 0.41, 0.0);

			}
			else
			{
				rmSetTeamSpacingModifier(0.25);
				rmSetPlayerPlacementArea(0.00, 0.00, 0.82, 0.82);
				rmSetPlacementSection(0.725, 0.525);
				rmPlacePlayersCircular(0.40, 0.40, 0.0);

			}
		}

	
	// **************************************************************************************************
   
	// Text
	rmSetStatusText("",0.10);
	
	// ********************************* MAP LAYOUT & NATURE DESIGN *************************************
	
	// Cliff template
	int clifftemplateID = rmCreateArea("cliff template");
	rmSetAreaWarnFailure(clifftemplateID, false);
	rmSetAreaObeyWorldCircleConstraint(clifftemplateID, false);
	rmSetAreaSize(clifftemplateID, (0.40+0.008*cNumberNonGaiaPlayers), (0.40+0.008*cNumberNonGaiaPlayers)); 
	rmSetAreaLocation (clifftemplateID, 0.50, 0.50);
	rmSetAreaCoherence(clifftemplateID, 0.75);
	rmSetAreaSmoothDistance(clifftemplateID, 18+2*cNumberNonGaiaPlayers);
//	rmSetAreaTerrainType(clifftemplateID, "new_england\ground2_cliff_ne"); // TEST
	rmBuildArea(clifftemplateID);
	
	int avoidCliffTemplate = rmCreateAreaDistanceConstraint("avoid cliff template", clifftemplateID, 2.0);
	int stayInCliffTemplate = rmCreateAreaMaxDistanceConstraint("stay in cliff template", clifftemplateID, 0.0);

		
	//River
	int riverID = rmCreateArea("river");
	rmSetAreaObeyWorldCircleConstraint(riverID, false);
	rmSetAreaSize(riverID, 0.20, 0.20);
	rmSetAreaLocation(riverID, 1.00, 1.00);
	rmSetAreaWaterType(riverID, "Adirondacks Coast"); 
	rmSetAreaCoherence(riverID, 1.00);
	rmAddAreaConstraint (riverID, avoidCliffTemplate);	
	rmBuildArea(riverID);
	
	int riverturn1ID = rmCreateArea("river turn 1");
	rmSetAreaObeyWorldCircleConstraint(riverturn1ID, false);
	rmSetAreaSize(riverturn1ID, 0.05, 0.05);
	rmSetAreaLocation(riverturn1ID, 0.30, 0.90);
	rmSetAreaWaterType(riverturn1ID, "Adirondacks Coast"); 
	rmSetAreaCoherence(riverturn1ID, 0.90);
	rmAddAreaInfluenceSegment(riverturn1ID, 0.24, 0.90, 0.06, 0.96);
	rmBuildArea(riverturn1ID);
	
	int riverturn2ID = rmCreateArea("river turn 2");
	rmSetAreaObeyWorldCircleConstraint(riverturn2ID, false);
	rmSetAreaSize(riverturn2ID, 0.05, 0.05);
	rmSetAreaLocation(riverturn2ID, 0.90, 0.30);
	rmSetAreaWaterType(riverturn2ID, "Adirondacks Coast"); 
	rmSetAreaCoherence(riverturn2ID, 0.90);
	rmAddAreaInfluenceSegment(riverturn2ID, 0.90, 0.24, 0.96, 0.06);
	rmBuildArea(riverturn2ID);

	
	//Valley template
	int valleytemplateID = rmCreateArea("valley template");
	rmSetAreaWarnFailure(valleytemplateID, false);
	rmSetAreaObeyWorldCircleConstraint(valleytemplateID, false);
	rmAddAreaToClass(valleytemplateID, rmClassID("Valley"));
	rmAddAreaToClass(valleytemplateID, rmClassID("Bay"));
	rmSetAreaSize(valleytemplateID, (0.37+0.008*cNumberNonGaiaPlayers), (0.37+0.008*cNumberNonGaiaPlayers)); 
	rmSetAreaLocation (valleytemplateID, 0.00, 0.00);
	rmSetAreaCoherence(valleytemplateID, 0.85);
	rmSetAreaSmoothDistance(valleytemplateID, 18+2*cNumberNonGaiaPlayers);
//	rmSetAreaTerrainType(valleytemplateID, "rockies\groundsnow1_roc"); // TEST
	rmAddAreaConstraint(valleytemplateID, avoidWaterShort);
	rmBuildArea(valleytemplateID);
	
	//Bay template
	int baytemplateID = rmCreateArea("bay template");
	rmSetAreaWarnFailure(baytemplateID, false);
	rmSetAreaObeyWorldCircleConstraint(baytemplateID, false);
	rmAddAreaToClass(baytemplateID, rmClassID("Bay"));
	rmSetAreaSize(baytemplateID, 0.020+0.0015*cNumberNonGaiaPlayers, 0.020+0.0015*cNumberNonGaiaPlayers); 
	rmSetAreaLocation (baytemplateID, 0.72, 0.72);
	rmSetAreaCoherence(baytemplateID, 0.85);
	rmSetAreaSmoothDistance(baytemplateID, 18+2*cNumberNonGaiaPlayers);
//	rmSetAreaTerrainType(baytemplateID, "rockies\groundsnow1_roc"); // TEST
//	rmAddAreaConstraint(baytemplateID, avoidWaterShort);
	rmBuildArea(baytemplateID);
	
	
	// Cliff
	int cliffID = rmCreateArea("cliff");
//	rmSetAreaSize(cliffID, 0.13, 0.13); // rmAreaTilesToFraction(5000), rmAreaTilesToFraction(5000));  
	rmSetAreaSize(cliffID, 0.36, 0.36);
	rmSetAreaWarnFailure(cliffID, false);
	rmSetAreaObeyWorldCircleConstraint(cliffID, false);
	rmSetAreaCliffType(cliffID, "new england"); // new england inland grass
	rmSetAreaCliffPainting(cliffID, false, true, true, 0.5 , false); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaCliffHeight(cliffID, 5, 0.0, 0.2); 
	rmSetAreaCliffEdge(cliffID, 1, 1.00, 0.0, 0.00, 2); //0.30
	rmSetAreaCoherence(cliffID, 0.90);
	rmSetAreaSmoothDistance(cliffID, 2);
	rmAddAreaToClass(cliffID, classCliff);
	rmAddAreaConstraint(cliffID, avoidWaterShort);
//	rmAddAreaConstraint(cliffID, stayInCliffTemplate);
//	if (cNumberTeams > 2)
		rmAddAreaCliffEdgeAvoidClass(cliffID, classBay, 1.0);
//	else
		rmAddAreaCliffEdgeAvoidClass(cliffID, classValley, 1.0);
	rmSetAreaLocation(cliffID, 0.60, 0.60);
	rmBuildArea(cliffID);

	int avoidCliffShort = rmCreateAreaDistanceConstraint("avoid cliff short", cliffID, 2.0);
	int stayInCliff = rmCreateAreaMaxDistanceConstraint("stay in cliff", cliffID, 0.0);
	int avoidRamp = rmCreateCliffRampDistanceConstraint("avoid ramp", cliffID, 18.0);
	int avoidRampShort = rmCreateCliffRampDistanceConstraint("avoid ramp short", cliffID, 10.0);

	
	// Grass terrain
	int grassterrainID = rmCreateArea("grass terrain");
	rmSetAreaSize(grassterrainID, 0.70, 0.70); 
	rmSetAreaTerrainType(grassterrainID, "new_england\ground1_ne"); //new_england\ground1_ne
	rmSetAreaWarnFailure(grassterrainID, false);
	rmSetAreaObeyWorldCircleConstraint(grassterrainID, false);
	rmSetAreaCoherence(grassterrainID, 1.0);
	rmSetAreaLocation (grassterrainID, 0.00, 0.00);
	rmAddAreaConstraint (grassterrainID, avoidImpassableLandShort);
	rmBuildArea(grassterrainID);

	
	// Terrain patch1
	for (i=0; < 50+20*cNumberNonGaiaPlayers)
    {
        int patchID = rmCreateArea("patch grass light "+i);
        rmSetAreaWarnFailure(patchID, false);
        rmSetAreaSize(patchID, rmAreaTilesToFraction(30), rmAreaTilesToFraction(50));
		rmSetAreaTerrainType(patchID, "new_england\ground2_ne");
        rmAddAreaToClass(patchID, classPatch);
        rmSetAreaMinBlobs(patchID, 1);
        rmSetAreaMaxBlobs(patchID, 5);
        rmSetAreaMinBlobDistance(patchID, 16.0);
        rmSetAreaMaxBlobDistance(patchID, 40.0);
        rmSetAreaCoherence(patchID, 0.0);
		rmAddAreaConstraint(patchID, avoidImpassableLandShort);
//		rmAddAreaConstraint(patchID, avoidCliffShort);
		rmAddAreaConstraint(patchID, avoidPatch);
        rmBuildArea(patchID); 
    }
	
	// Terrain patch2
	for (i=0; < 50+20*cNumberNonGaiaPlayers)
    {
        int patch2ID = rmCreateArea("patch grass dark "+i);
        rmSetAreaWarnFailure(patch2ID, false);
        rmSetAreaSize(patch2ID, rmAreaTilesToFraction(30), rmAreaTilesToFraction(50));
		rmSetAreaTerrainType(patch2ID, "new_england\ground2_ne");
        rmAddAreaToClass(patch2ID, classPatch2);
        rmSetAreaMinBlobs(patch2ID, 1);
        rmSetAreaMaxBlobs(patch2ID, 5);
        rmSetAreaMinBlobDistance(patch2ID, 16.0);
        rmSetAreaMaxBlobDistance(patch2ID, 40.0);
        rmSetAreaCoherence(patch2ID, 0.0);
		rmAddAreaConstraint(patch2ID, avoidImpassableLandShort);
//		rmAddAreaConstraint(patch2ID, stayInCliff);
		rmAddAreaConstraint(patch2ID, avoidPatch2);
        rmBuildArea(patch2ID); 
    }
	
	
	//Corner areas
	for (i=0; < 2)
	{
		int cornerID = rmCreateArea("corner area" +i);
		rmSetAreaWarnFailure(cornerID, false);
		rmSetAreaObeyWorldCircleConstraint(cornerID, false);
		rmAddAreaToClass(cornerID, classCorner);
		rmSetAreaSize(cornerID, 0.011+0.0010*cNumberNonGaiaPlayers, 0.011+0.0010*cNumberNonGaiaPlayers); 
		if (i < 1)
			rmSetAreaLocation (cornerID, 0.80, 0.16);
		else
			rmSetAreaLocation (cornerID, 0.16, 0.80);
		rmSetAreaCoherence(cornerID, 1.00);
		
//		rmSetAreaTerrainType(cornerID, "rockies\groundsnow1_roc"); // TEST
		rmBuildArea(cornerID);
	}
	
	int avoidCorner=rmCreateClassDistanceConstraint("avoid corners", classCorner, 2.0);

	// ******************************************************************************************************
	
	// Text
	rmSetStatusText("",0.20);
	
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
		rmAddTradeRouteWaypoint(tradeRouteID, 0.00, 0.50);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 0.40); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.00);
	}
	else
	{
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.00, 0.50);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 0.40); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.00);
	}
	
	bool placedTradeRouteA = rmBuildTradeRoute(tradeRouteID, "dirt");

	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.08);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	if (cNumberNonGaiaPlayers > 4)
	{
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.30);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	if (cNumberNonGaiaPlayers > 4)
	{
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.70);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.92);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	
	
	// ******************************************** NATIVES *************************************************
	
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
	int nativeID4 = -1;
	
	nativeID1 = rmCreateGrouping("Huron village 1", "native Huron village "+3); // S
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
//  rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
	rmAddGroupingToClass(nativeID1, classNative);
//  rmAddGroupingToClass(nativeID1, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID1, avoidNatives);

	nativeID4 = rmCreateGrouping("Huron village 4", "native Huron village "+4); // S2
    rmSetGroupingMinDistance(nativeID4, 0.00);
    rmSetGroupingMaxDistance(nativeID4, 0.00);
//  rmAddGroupingConstraint(nativeID4, avoidImpassableLand);
	rmAddGroupingToClass(nativeID4, classNative);
//  rmAddGroupingToClass(nativeID4, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID4, avoidNatives);
		
	nativeID2 = rmCreateGrouping("Huron village 2", "native Huron village "+1); // M
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
//  rmAddGroupingConstraint(nativeID2, avoidImpassableLand);
	rmAddGroupingToClass(nativeID2, classNative);
//  rmAddGroupingToClass(nativeID2, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID2, avoidNatives);

	nativeID3 = rmCreateGrouping("Huron village 3", "native Huron village "+1); // M2
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
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.25, 0.25); // S
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.62, 0.62); // M
		}
		else
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.25, 0.25); // S
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.52, 0.72); // M
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.72, 0.52); // M2
		}
	}
	else
	{
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.30, 0.30); // S
		rmPlaceGroupingAtLoc(nativeID4, 0, 0.20, 0.20); // S2
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.52, 0.52); // M
	}

	// ******************************************************************************************************
	
	// Text
	rmSetStatusText("",0.40);

	// *************************************************************************************************************
	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.18;
		float yLoc = 0.18;
		float walk = 0.03;

		if (randLoc == 2 && cNumberTeams <= 2) {
			xLoc = 0.5;
			yLoc = 0.5;
		} else if (randLoc == 3 && cNumberTeams <= 2) {
			xLoc = 0.73;
			yLoc = 0.73;
		}

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}

	
	// ************************************ PLAYER STARTING RESOURCES ***************************************

	// ******** Define ********

	// Town center & units
	int TCID = rmCreateObjectDef("player TC");
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 10.0);

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
	rmSetObjectDefMinDistance(playergoldID, 18.0);
	rmSetObjectDefMaxDistance(playergoldID, 20.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidGoldType);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 32.0); //58
	rmSetObjectDefMaxDistance(playergold2ID, 33.0); //62
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergold2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldType);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
//	rmAddObjectDefConstraint(playergold2ID, avoidCenter);
	rmAddObjectDefConstraint(playergold2ID, avoidEdge);
	
	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 3, 3.0);
	rmSetObjectDefMinDistance(playerberriesID, 12.0);
	rmSetObjectDefMaxDistance(playerberriesID, 14.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerberriesID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerberriesID, avoidNatives);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResources);
	
	// Starting trees1
	int playerTreeID = rmCreateObjectDef("player trees");
//  rmAddObjectDefItem(playerTreeID, "TreeNorthwestTerritory", rmRandInt(1,2), 4.0);
	rmAddObjectDefItem(playerTreeID, "TreeSaguenay", rmRandInt(11,13), 9.0); //6,6 5.0
    rmSetObjectDefMinDistance(playerTreeID, 16);
    rmSetObjectDefMaxDistance(playerTreeID, 18);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	
	
	// Starting herd
	int playerDeerID = rmCreateObjectDef("starting Deer");
	rmAddObjectDefItem(playerDeerID, "Deer", rmRandInt(5,5), 5.0);
	rmSetObjectDefMinDistance(playerDeerID, 14.0);
	rmSetObjectDefMaxDistance(playerDeerID, 16.0);
	rmSetObjectDefCreateHerd(playerDeerID, false);
	rmAddObjectDefToClass(playerDeerID, classStartingResource);
	rmAddObjectDefConstraint(playerDeerID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerDeerID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerDeerID, avoidNatives);
	rmAddObjectDefConstraint(playerDeerID, avoidStartingResources);
		
	// 2nd herd
	int playerElkID = rmCreateObjectDef("player Elk");
    rmAddObjectDefItem(playerElkID, "elk", rmRandInt(10,10), 7.0);
    rmSetObjectDefMinDistance(playerElkID, 30);
    rmSetObjectDefMaxDistance(playerElkID, 32);
	rmAddObjectDefToClass(playerElkID, classStartingResource);
	rmSetObjectDefCreateHerd(playerElkID, true);
	rmAddObjectDefConstraint(playerElkID, avoidDeer); //Short
	rmAddObjectDefConstraint(playerElkID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerElkID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerElkID, avoidNatives);
	rmAddObjectDefConstraint(playerElkID, avoidStartingResources);
	rmAddObjectDefConstraint(playerElkID, avoidEdge);
	rmAddObjectDefConstraint(playerElkID, avoidCorner);
	
/*	// 3rd herd
	int playerElk2ID = rmCreateObjectDef("player Elk2");
    rmAddObjectDefItem(playerElk2ID, "Elk", rmRandInt(8,8), 6.0);
    rmSetObjectDefMinDistance(playerElk2ID, 28);
    rmSetObjectDefMaxDistance(playerElk2ID, 34);
	rmAddObjectDefToClass(playerElk2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerElk2ID, true);
	rmAddObjectDefConstraint(playerElk2ID, avoidDeer); //Short
	rmAddObjectDefConstraint(playerElk2ID, avoidElkShort);
	rmAddObjectDefConstraint(playerElk2ID, avoidCliffShort);
	rmAddObjectDefConstraint(playerElk2ID, avoidTradeRouteShort);
//	rmAddObjectDefConstraint(playerElk2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerElk2ID, avoidNatives);
	rmAddObjectDefConstraint(playerElk2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerElk2ID, avoidEdge);
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
	
	// Water spawn flag
	int colonyShipID = 0;
	colonyShipID=rmCreateObjectDef("colony ship "+i);
	rmAddObjectDefItem(colonyShipID, "HomeCityWaterSpawnFlag", 1, 1.0);
	rmSetObjectDefMinDistance(colonyShipID, rmXFractionToMeters(0.1));
	rmSetObjectDefMaxDistance(colonyShipID, rmXFractionToMeters(0.30));
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
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerDeerID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerElkID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playerElk2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		if (nugget0count == 2)
			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
				
		if(ypIsAsian(i) && rmGetNomadStart() == false)
		rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
		rmPlaceObjectDefAtLoc(colonyShipID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));

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
	
		int silvermineCount = 2+2*cNumberNonGaiaPlayers;  // 3,3 
	
	//Silver mines
	for(i=0; < silvermineCount)
	{
		int silvermineID = rmCreateObjectDef("silver mine"+i);
		rmAddObjectDefItem(silvermineID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(silvermineID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(silvermineID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(silvermineID, classGold);
		rmAddObjectDefConstraint(silvermineID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(silvermineID, avoidImpassableLand);
		rmAddObjectDefConstraint(silvermineID, avoidNativesFar);
		rmAddObjectDefConstraint(silvermineID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(silvermineID, avoidGoldFar);
		rmAddObjectDefConstraint(silvermineID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(silvermineID, avoidEdge);
		rmAddObjectDefConstraint(silvermineID, avoidCorner);
		if (i < silvermineCount*2/3)
			rmAddObjectDefConstraint(silvermineID, stayInCliff);
		rmAddObjectDefConstraint(silvermineID, avoidKingsHill);
/*		if (cNumberTeams <= 2 && cNumberNonGaiaPlayers == 2)
		{
			if (i < 1)
				rmAddObjectDefConstraint(silvermineID, staySE);
			else if (i < 2)
				rmAddObjectDefConstraint(silvermineID, staySW);
		}
*/		rmPlaceObjectDefAtLoc(silvermineID, 0, 0.50, 0.50);
	}
	
	// ****************************
	
	// Text
	rmSetStatusText("",0.60);
	
		// ********** Forest **********
	
	// Forest
	int forestcount = 5+5*cNumberNonGaiaPlayers; // 14*cNumberNonGaiaPlayers/2
	int stayInForest = -1;
	
	for (i=0; < forestcount)
	{
		int forestID = rmCreateArea("south forest"+i);
		rmSetAreaWarnFailure(forestID, false);
//		rmSetAreaObeyWorldCircleConstraint(forestID, false);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(180), rmAreaTilesToFraction(200));
		rmSetAreaTerrainType(forestID, "new_england\groundforest_ne");
		rmSetAreaMinBlobs(forestID, 2);
		rmSetAreaMaxBlobs(forestID, 5);
		rmSetAreaMinBlobDistance(forestID, 14.0);
		rmSetAreaMaxBlobDistance(forestID, 30.0);
		rmSetAreaCoherence(forestID, 0.1);
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
		rmAddAreaConstraint(forestID, avoidStartingResources);
		rmAddAreaConstraint(forestID, avoidDeerMin); 
		rmAddAreaConstraint(forestID, avoidElkMin); 
		rmAddAreaConstraint(forestID, avoidNuggetMin);
		rmAddAreaConstraint(forestID, avoidKingsHill);
		rmBuildArea(forestID);
	
		stayInForest = rmCreateAreaMaxDistanceConstraint("stay in south forest"+i, forestID, 0);
	
		for (j=0; < rmRandInt(9,10)) //20,22
		{
			int foresttreeID = rmCreateObjectDef("south tree"+i+" "+j);
			rmAddObjectDefItem(foresttreeID, "UnderbrushForest", rmRandInt(2,3), 5.0);
			rmAddObjectDefItem(foresttreeID, "Treegreatlakes", rmRandInt(1,1), 3.0); // 1,2
			rmAddObjectDefItem(foresttreeID, "TreeSaguenay", rmRandInt(2,2), 4.0); // 1,2
			rmSetObjectDefMinDistance(foresttreeID, 0);
			rmSetObjectDefMaxDistance(foresttreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(foresttreeID, classForest);
			rmAddObjectDefConstraint(foresttreeID, stayInForest);	
			rmAddObjectDefConstraint(foresttreeID, avoidImpassableLandShort);	
			rmPlaceObjectDefAtLoc(foresttreeID, 0, 0.50, 0.50);
		}
		
	}
	
	// Random trees
	int randomforestcount = 4+4*cNumberNonGaiaPlayers; 
	
	for (i=0; < randomforestcount)
	{	
		int RandomtreeID = rmCreateObjectDef("random trees"+i);
		rmAddObjectDefItem(RandomtreeID, "Treegreatlakes", rmRandInt(3,4), 6.0); // 4,5
		rmAddObjectDefItem(RandomtreeID, "TreeSaguenay", rmRandInt(1,3), 5.0); // 4,5
		rmAddObjectDefItem(RandomtreeID, "UnderbrushForest", rmRandInt(1,2), 5.0);
		rmSetObjectDefMinDistance(RandomtreeID, 0);
		rmSetObjectDefMaxDistance(RandomtreeID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(RandomtreeID, classForest);
		rmAddObjectDefConstraint(RandomtreeID, avoidNatives);
		rmAddObjectDefConstraint(RandomtreeID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(RandomtreeID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidTownCenterResources);
		rmAddObjectDefConstraint(RandomtreeID, avoidStartingResources);
		rmAddObjectDefConstraint(RandomtreeID, avoidElkMin); 
		rmAddObjectDefConstraint(RandomtreeID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidBerriesMin);
		rmAddObjectDefConstraint(RandomtreeID, avoidForestShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidKingsHill);
//		rmAddObjectDefConstraint(RandomtreeID, avoidEdge);
		rmPlaceObjectDefAtLoc(RandomtreeID, 0, 0.5, 0.5);
	}
	
	// ********************************	
	
	// Text
	rmSetStatusText("",0.70);

	// ********** Herds ***********

	//South Elks
	int elkcount = 2+3*cNumberNonGaiaPlayers;
	
	for(i=0; < elkcount)
	{
		int elkID = rmCreateObjectDef("south Elk"+i);
		rmAddObjectDefItem(elkID, "Elk", rmRandInt(9,10), 7.0);
		rmSetObjectDefMinDistance(elkID, 0.0);
		rmSetObjectDefMaxDistance(elkID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(elkID, true);
		rmAddObjectDefConstraint(elkID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(elkID, avoidNativesShort);
		rmAddObjectDefConstraint(elkID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(elkID, avoidGoldMed);
		rmAddObjectDefConstraint(elkID, avoidTownCenter);
		rmAddObjectDefConstraint(elkID, avoidForestMin);
		rmAddObjectDefConstraint(elkID, avoidElk); 
		rmAddObjectDefConstraint(elkID, avoidDeerFar);
		rmAddObjectDefConstraint(elkID, avoidEdge);	
		rmAddObjectDefConstraint(elkID, avoidCorner);	
		if (cNumberTeams <= 2 && cNumberNonGaiaPlayers == 2)
		{
			if (i < 1)
				rmAddObjectDefConstraint(elkID, staySE);
			else if (i < 2)
				rmAddObjectDefConstraint(elkID, staySW);
		}
		rmPlaceObjectDefAtLoc(elkID, 0, 0.5, 0.5);
	}
	
	// ********************************
	
	// Text
	rmSetStatusText("",0.80);
	
	// ********** Treasures ***********
	
	
	int nugget2count = 6+0.5*cNumberNonGaiaPlayers; 
	int nugget3count = 1+0.5*cNumberNonGaiaPlayers; 
	int nugget4count = 0.34*cNumberNonGaiaPlayers; 
	
	// Treasures 2	
	int Nugget2ID = rmCreateObjectDef("nugget 2"); 
	rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget2ID, 0);
    rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
	rmAddObjectDefConstraint(Nugget2ID, avoidNatives);
	rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(Nugget2ID, avoidGoldTypeShort);
	rmAddObjectDefConstraint(Nugget2ID, avoidTownCenter);
	rmAddObjectDefConstraint(Nugget2ID, avoidElkMin); 
	rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
	rmAddObjectDefConstraint(Nugget2ID, avoidEdge);
	rmAddObjectDefConstraint(Nugget2ID, avoidKingsHill);
	
	for (i=0; < nugget4count)
	{
		rmSetNuggetDifficulty(4,4);
		if (cNumberNonGaiaPlayers >= 4)
			rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}
	
	for (i=0; < nugget3count)
	{
		rmSetNuggetDifficulty(3,3);
		if (cNumberNonGaiaPlayers >= 4)
			rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}
		
	for (i=0; < nugget2count)
	{
		rmSetNuggetDifficulty(2,2);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}
	
	// ********************************

	// ********************************
		
	// Text
	rmSetStatusText("",0.90);
	
	// ************ Sea resources *************
	
	int fishcount = -1;
	fishcount = 6+4*cNumberNonGaiaPlayers;
	
	//Fish
	for (i=0; < fishcount)
	{
		int fishID = rmCreateObjectDef("fish"+i);
		rmAddObjectDefItem(fishID, "Fishsalmon", rmRandInt(2,2), 4.0);
		rmSetObjectDefMinDistance(fishID, 0.0);
		rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.50));
		rmAddObjectDefConstraint(fishID, avoidFish);
		rmAddObjectDefConstraint(fishID, avoidLand);
		rmAddObjectDefConstraint(fishID, avoidColonyShipShort);
		rmAddObjectDefConstraint(fishID, avoidEdge);
		rmPlaceObjectDefAtLoc(fishID, 0, 0.50, 0.50);
	}

	// ****************************************
	

  // Water nuggets

  int avoidNuggetLand=rmCreateTerrainDistanceConstraint("nugget avoid land", "land", true, 10.0);
  int avoidNuggetWater=rmCreateTypeDistanceConstraint("nugget vs. nugget water", "AbstractNugget", 70.0);
  
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
	
	