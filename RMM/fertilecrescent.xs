// ESOC FERTILE CRESCENT (1v1, TEAM, FFA)
// original idea by Durokan
// designed by Durokan and Garja
// observer UI by Aizamk

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{

	bool isWinterSeason = false;
		
	// Text
	// These status text lines are used to manually animate the map generation progress bar
	rmSetStatusText("",0.01); 
	
	// ************************************** GENERAL FEATURES *****************************************
	
	// Picks the map size
	int playerTiles=10200;
	if (cNumberNonGaiaPlayers >= 4)
		playerTiles=10200;
	if (cNumberNonGaiaPlayers >= 6)
		playerTiles=10200;
	if (cNumberTeams > 2)
		playerTiles=10800;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(true);
	
	// Picks a default water height
	rmSetSeaLevel(3.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	rmSetMapElevationParameters(cElevTurbulence, 0.045, 2, 0.42, 5.0); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);
	
	// Picks default terrain and water
	if (isWinterSeason == true) {
		rmSetSeaType("Yukon River");
		rmSetBaseTerrainMix("rockies_grass_snowb");
		rmTerrainInitialize("yukon\ground8_yuk", 0.0);
		rmSetMapType("middleEast");
		rmSetMapType("desert");
		rmSetMapType("land");
		rmSetMapType("asia");
		rmSetLightingSet("Sonora");
		rmSetWindMagnitude(2.0);
		rmSetGlobalSnow( 0.1 );
	} else {
		rmSetSeaType("deccan plateau river"); //great lakes
	//	rmEnableLocalWater(false);
		rmSetBaseTerrainMix("africa_grass"); // deccan_grassy_dirt_a
		rmTerrainInitialize("africa\ground3_africa", 3.0); //
		rmSetMapType("deccan"); //silkroad2
		rmSetMapType("desert");
		rmSetMapType("land");
		rmSetLightingSet("deccan"); //
		rmSetWindMagnitude(2.0);
	}

	string riverType = "Africa River";
	string mainTreeType = "TreeNile";
	if (isWinterSeason == true) {
		riverType = "Yukon River";
		mainTreeType = "TreeYukonSnow";
	}

	// River shape and subsequent map layout
	int rivershape = -1;
	rivershape = rmRandInt(0,1);
	if (cNumberTeams > 2 || rmGetIsKOTH())
		rivershape = 2; 
		
	
//	rivershape = 2; // <--- TEST
	
	
	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);
	
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Sufi");
	subCiv1 = rmGetCivID("Saltpeter");
	rmSetSubCiv(0, "Sufi");
	rmSetSubCiv(1, "Saltpeter");
//	rmEchoInfo("subCiv0 is Huron "+subCiv0);

	

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classGrass = rmDefineClass("grass");
	rmDefineClass("starting settlement");
	int classStartingUnit = rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int classNative = rmDefineClass("natives");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	
	// ******************************************************************************************
	
	// Text
	rmSetStatusText("",0.05);
	
	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other
   
   
	// Cardinal Directions & Map placement
	int stayNW = rmCreatePieConstraint("stay NW", 0.5, 0.68, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(300), rmDegreesToRadians(60));
	int staySE = rmCreatePieConstraint("stay SE", 0.5, 0.32, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(120), rmDegreesToRadians(240));
	int stayNWhalf = rmCreatePieConstraint("stay NW half", 0.5, 0.55, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(270), rmDegreesToRadians(90));
	int staySEhalf  = rmCreatePieConstraint("stay SE half", 0.5, 0.45, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(90), rmDegreesToRadians(270));
	
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.26), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.20), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.16), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayEdge = rmCreatePieConstraint("Stay Edge",0.5,0.5,rmXFractionToMeters(0.42), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	
	
	// Resource avoidance
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", classForest, 40.0); //15.0
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", classForest, 26.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", classForest, 22.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", classForest, 3.0);
	int avoidIbexVeryFar = rmCreateTypeDistanceConstraint("avoid Ibex very far", "Gazelle", 60.0);
	int avoidIbexFar = rmCreateTypeDistanceConstraint("avoid Ibex far", "Gazelle", 57.0);
	int avoidIbex = rmCreateTypeDistanceConstraint("avoid Ibex", "Gazelle", 40.0);
	int avoidIbexShort = rmCreateTypeDistanceConstraint("avoid Ibex short", "Gazelle", 16.0);
	int avoidHeron = rmCreateTypeDistanceConstraint("avoid Heron", "Heron", 40.0);
	int avoidHeronShort = rmCreateTypeDistanceConstraint("avoid Heron short", "Heron", 16.0);
	int avoidIbexMin = rmCreateTypeDistanceConstraint("avoid Ibex min", "Gazelle", 6.0);
	int avoidBerriesFar = rmCreateTypeDistanceConstraint("avoid berries far", "berrybush", 64.0);
	int avoidBerries = rmCreateTypeDistanceConstraint("avoid  berries", "berrybush", 40.0);
	int avoidBerriesShort = rmCreateTypeDistanceConstraint("avoid  berries short", "berrybush", 10.0);
	int avoidBerriesMin = rmCreateTypeDistanceConstraint("avoid berries min", "berrybush", 10.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 14.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 8.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 40.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 45.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", classGold, 4.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", classGold, 48.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", classGold, 65.0); //70
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very ", classGold, 74.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 4.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 40.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 46.0);
	int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center  Very Far", "townCenter", 68.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 56.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 50.0);
	int avoidTownCenterMed=rmCreateTypeDistanceConstraint("resources avoid Town Center med", "townCenter", 40.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("resources avoid Town Center short", "townCenter", 28.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint("resources avoid Town Center", "townCenter", 40.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("stuff avoids natives short", classNative, 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", classNative, 10.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", classNative, 12.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("avoid start resources", classStartingResource, 8.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid start resources short", classStartingResource, 5.0);
	int avoidFish = rmCreateTypeDistanceConstraint("avoid fish", "fish", 20.0);

	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("far avoid impassable land", "Land", false, 10.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 3.0);
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("min avoid impassable land", "Land", false, 0.2);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 5.0+2.0*cNumberNonGaiaPlayers);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 10);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "land", false, 14.0+2*cNumberNonGaiaPlayers);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 1.0);
	int avoidPatch = rmCreateClassDistanceConstraint("patch avoid patch", classPatch, 2.0+0.5*cNumberNonGaiaPlayers);
	int avoidPatch2 = rmCreateClassDistanceConstraint("patch avoid patch2", classPatch2, 10.0);
	int avoidGrass = rmCreateClassDistanceConstraint("grass avoid grass", classGrass, 5.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 10.0);

	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", classStartingUnit, 35.0);
		
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 4.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 7.0);
   
	
	// ***********************************************************************************************
	
	// **************************************** PLACE PLAYERS ****************************************

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);

	teamZeroCount = cNumberNonGaiaPlayers/2;
	teamOneCount = cNumberNonGaiaPlayers/2;
	float OneVOnePlacement=rmRandFloat(0.0, 0.9);


		if (cNumberTeams <= 2) // 1v1 and TEAM
		{
			if (teamZeroCount == 1 && teamOneCount == 1) // 1v1
			{
				if (rivershape == 0)
				{
					if ( OneVOnePlacement < 0.5)
					{
						rmPlacePlayer(1, 0.40, 0.14);
						rmPlacePlayer(2, 0.60, 0.86);
					}
					else
					{
						rmPlacePlayer(2, 0.40, 0.14);
						rmPlacePlayer(1, 0.60, 0.86);
					}
				}
				else
				{
					if ( OneVOnePlacement < 0.5)
					{
						rmPlacePlayer(1, 0.45, 0.16);
						rmPlacePlayer(2, 0.55, 0.84);
					}
					else
					{
						rmPlacePlayer(2, 0.45, 0.16);
						rmPlacePlayer(1, 0.55, 0.84);
					}
				}
			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					if (rivershape == 0)
					{
					rmSetPlacementTeam(0);
					rmSetPlayerPlacementArea(0.22, 0.00, 0.78, 1.00);
					rmSetPlacementSection(0.900, 0.100); //
					rmPlacePlayersCircular(0.44, 0.44, 0);

					rmSetPlacementTeam(1);
					rmSetPlayerPlacementArea(0.22, 0.00, 0.78, 1.00);
					rmSetPlacementSection(0.400, 0.600); //
					rmPlacePlayersCircular(0.44, 0.44, 0);
					}
					else
					{
					rmSetPlacementTeam(0);
					rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 1.00);
					rmSetPlacementSection(0.900, 0.100); //
					rmPlacePlayersCircular(0.40, 0.40, 0);

					rmSetPlacementTeam(1);
					rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 1.00);
					rmSetPlacementSection(0.400, 0.600); //
					rmPlacePlayersCircular(0.40, 0.40, 0);
					}
				}
				else // 3v3, 4v4
				{
					if (rivershape == 0)
					{
					rmSetPlacementTeam(0);
					rmSetPlayerPlacementArea(0.26, 0.30, 0.74, 1.00);
					rmSetPlacementSection(0.850, 0.150); //
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlayerPlacementArea(0.26, 0.00, 0.74, 0.70);
					rmSetPlacementSection(0.350, 0.650); //
					rmPlacePlayersCircular(0.38, 0.38, 0);
					}
					else
					{
					rmSetPlacementTeam(0);
					rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 1.00);
					rmSetPlacementSection(0.850, 0.150); //
					rmPlacePlayersCircular(0.40, 0.40, 0);

					rmSetPlacementTeam(1);
					rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 1.00);
					rmSetPlacementSection(0.350, 0.650); //
					rmPlacePlayersCircular(0.40, 0.40, 0);
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
						if (rivershape == 0)
							rmPlacePlayersLine(0.38, 0.14, 0.39, 0.14, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.44, 0.14, 0.45, 0.14, 0.00, 0.20);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2) // 1v2
						{
							if (rivershape == 0)
							{
								rmSetPlayerPlacementArea(0.22, 0.00, 0.78, 1.00);
								rmSetPlacementSection(0.900, 0.100); //
								rmPlacePlayersCircular(0.44, 0.44, 0);
							}
							else
							{
								rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 1.00);
								rmSetPlacementSection(0.880, 0.120); //
								rmPlacePlayersCircular(0.40, 0.40, 0);
							}
						}
						else if (teamOneCount == 3) // 1v3
						{
							if (rivershape == 0)
							{
								rmSetPlayerPlacementArea(0.26, 0.30, 0.74, 1.00);
								rmSetPlacementSection(0.850, 0.150); //
								rmPlacePlayersCircular(0.38, 0.38, 0);
							}
							else
							{
								rmSetPlayerPlacementArea(0.30, 0.30, 0.70, 1.00);
								rmSetPlacementSection(0.800, 0.200); //
								rmPlacePlayersCircular(0.36, 0.36, 0);
							}
						}
						else // 1v4, etc.
						{
							if (rivershape == 0)
							{
								rmSetPlayerPlacementArea(0.26, 0.30, 0.74, 1.00);
								rmSetPlacementSection(0.850, 0.150); //
								rmPlacePlayersCircular(0.38, 0.38, 0);
							}
							else
							{
								rmSetPlayerPlacementArea(0.30, 0.30, 0.70, 1.00);
								rmSetPlacementSection(0.750, 0.250); //
								rmPlacePlayersCircular(0.38, 0.38, 0);
							}
						}
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(1);
						if (rivershape == 0)
							rmPlacePlayersLine(0.55, 0.86, 0.56, 0.86, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.61, 0.86, 0.62, 0.86, 0.00, 0.20);

						rmSetPlacementTeam(0);
						if (teamZeroCount == 2) // 2v1
						{
							if (rivershape == 0)
							{
								rmSetPlayerPlacementArea(0.22, 0.00, 0.78, 1.00);
								rmSetPlacementSection(0.400, 0.600); //
								rmPlacePlayersCircular(0.44, 0.44, 0);
							}
							else
							{
								rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 1.00);
								rmSetPlacementSection(0.380, 0.620); //
								rmPlacePlayersCircular(0.40, 0.40, 0);
							}
						}
						else if (teamZeroCount == 3) // 3v1
						{
							if (rivershape == 0)
							{
								rmSetPlayerPlacementArea(0.26, 0.00, 0.74, 0.70);
								rmSetPlacementSection(0.350, 0.650); //
								rmPlacePlayersCircular(0.38, 0.38, 0);
							}
							else
							{
								rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 0.70);
								rmSetPlacementSection(0.300, 0.700); //
								rmPlacePlayersCircular(0.36, 0.36, 0);
							}
						}
						else // 4v1, etc.
						{
							if (rivershape == 0)
							{
								rmSetPlayerPlacementArea(0.26, 0.00, 0.74, 0.70);
								rmSetPlacementSection(0.350, 0.650); //
								rmPlacePlayersCircular(0.38, 0.38, 0);
							}
							else
							{
								rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 0.70);
								rmSetPlacementSection(0.250, 0.750); //
								rmPlacePlayersCircular(0.38, 0.38, 0);
							}
						}
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						if (rivershape == 0)
						{
							rmSetPlayerPlacementArea(0.22, 0.00, 0.78, 1.00);
							rmSetPlacementSection(0.400, 0.600); //
							rmPlacePlayersCircular(0.44, 0.44, 0);
						}
						else
						{
							rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 1.00);
							rmSetPlacementSection(0.400, 0.600); //
							rmPlacePlayersCircular(0.40, 0.40, 0);
						}

						rmSetPlacementTeam(1);
						if (rivershape == 0)
						{
							rmSetPlayerPlacementArea(0.26, 0.30, 0.74, 1.00);
							rmSetPlacementSection(0.850, 0.150); //
							rmPlacePlayersCircular(0.38, 0.38, 0);
						}
						else
						{
							rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 1.00);
							rmSetPlacementSection(0.850, 0.150); //
							rmPlacePlayersCircular(0.40, 0.40, 0);
						}
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						if (rivershape == 0)
						{
							rmSetPlayerPlacementArea(0.26, 0.00, 0.74, 0.70);
							rmSetPlacementSection(0.350, 0.650); //
							rmPlacePlayersCircular(0.38, 0.38, 0);
						}
						else
						{
							rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 1.00);
							rmSetPlacementSection(0.350, 0.650); //
							rmPlacePlayersCircular(0.40, 0.40, 0);
						}

						rmSetPlacementTeam(1);
						if (rivershape == 0)
						{
							rmSetPlayerPlacementArea(0.22, 0.00, 0.78, 1.00);
							rmSetPlacementSection(0.900, 0.100); //
							rmPlacePlayersCircular(0.44, 0.44, 0);
						}
						else
						{
							rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 1.00);
							rmSetPlacementSection(0.900, 0.100); //
							rmPlacePlayersCircular(0.40, 0.40, 0);
						}
					}
				}
				else // 3v4, 4v3, etc.
				{
					if (teamZeroCount == 3) // 3v4, 3v5, etc.
					{
						rmSetPlacementTeam(0);
						if (rivershape == 0)
						{
							rmSetPlayerPlacementArea(0.26, 0.00, 0.74, 0.70);
							rmSetPlacementSection(0.350, 0.650); //
							rmPlacePlayersCircular(0.38, 0.38, 0);
						}
						else
						{
							rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 1.00);
							rmSetPlacementSection(0.350, 0.650); //
							rmPlacePlayersCircular(0.40, 0.40, 0);
						}

						rmSetPlacementTeam(1);
						if (rivershape == 0)
						{
							rmSetPlayerPlacementArea(0.26, 0.30, 0.74, 1.00);
							rmSetPlacementSection(0.850, 0.150); //
							rmPlacePlayersCircular(0.38, 0.38, 0);
						}
						else
						{
							rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 1.00);
							rmSetPlacementSection(0.800, 0.200); //
							rmPlacePlayersCircular(0.40, 0.40, 0);
						}
					}
					else // 4v3, 5v3, etc.
					{
						rmSetPlacementTeam(0);
						if (rivershape == 0)
						{
							rmSetPlayerPlacementArea(0.26, 0.30, 0.74, 1.00);
							rmSetPlacementSection(0.850, 0.150); //
							rmPlacePlayersCircular(0.38, 0.38, 0);
						}
						else
						{
							rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 1.00);
							rmSetPlacementSection(0.800, 0.200); //
							rmPlacePlayersCircular(0.40, 0.40, 0);
						}

						rmSetPlacementTeam(1);
						if (rivershape == 0)
						{
							rmSetPlayerPlacementArea(0.26, 0.00, 0.74, 0.70);
							rmSetPlacementSection(0.350, 0.650); //
							rmPlacePlayersCircular(0.38, 0.38, 0);
						}
						else
						{
							rmSetPlayerPlacementArea(0.30, 0.00, 0.70, 1.00);
							rmSetPlacementSection(0.350, 0.650); //
							rmPlacePlayersCircular(0.40, 0.40, 0);
						}
					}
				}
			}
		}
		else // FFA
		{
			if (cNumberNonGaiaPlayers <= 8)
			{
				rmSetPlayerPlacementArea(0.24, 0.00, 0.76, 1.00);
				rmPlacePlayersSquare(0.36, 0.36, 0.0);
			}
		}
	
	// **************************************************************************************************
   
	// Text
	rmSetStatusText("",0.10);
	
	// ********************************* MAP LAYOUT & NATURE DESIGN *************************************
	
	// Rivers
	if (rivershape == 0) //   )( shaped
	{
	int river1ID = rmRiverCreate(-1, riverType, 10, 5, 4+0.25*cNumberNonGaiaPlayers, 5+0.25*cNumberNonGaiaPlayers); //
	rmRiverAddWaypoint(river1ID, 0.11, 0.99); 
	rmRiverAddWaypoint(river1ID, 0.10, 0.88); 
	rmRiverAddWaypoint(river1ID, 0.32, 0.66); 
	rmRiverAddWaypoint(river1ID, 0.28, 0.50); 
	rmRiverAddWaypoint(river1ID, 0.32, 0.34); 
	rmRiverAddWaypoint(river1ID, 0.10, 0.12);
	rmRiverAddWaypoint(river1ID, 0.11, 0.01);
	rmRiverSetBankNoiseParams(river1ID, 0.00, 0, 0.0, 0.0, 0.0, 0.0);
	rmRiverSetShallowRadius(river1ID, 6+0.25*cNumberNonGaiaPlayers);
	rmRiverAddShallow(river1ID, 0.2);
	rmRiverAddShallow(river1ID, 0.38);
	rmRiverAddShallow(river1ID, 0.62);
	rmRiverAddShallow(river1ID, 0.8);
	rmRiverBuild(river1ID);
		
	int river2ID = rmRiverCreate(-1, riverType, 10, 5, 4+0.25*cNumberNonGaiaPlayers, 5+0.25*cNumberNonGaiaPlayers); //
	rmRiverAddWaypoint(river2ID, 0.89, 0.99); 
	rmRiverAddWaypoint(river2ID, 0.90, 0.88); 
	rmRiverAddWaypoint(river2ID, 0.68, 0.66); 
	rmRiverAddWaypoint(river2ID, 0.72, 0.50); 
	rmRiverAddWaypoint(river2ID, 0.68, 0.34); 
	rmRiverAddWaypoint(river2ID, 0.90, 0.12);
	rmRiverAddWaypoint(river2ID, 0.89, 0.01);
	rmRiverSetBankNoiseParams(river2ID, 0.00, 0, 0.0, 0.0, 0.0, 0.0);
	rmRiverSetShallowRadius(river2ID, 6+0.5*cNumberNonGaiaPlayers);
	rmRiverAddShallow(river2ID, 0.2);
	rmRiverAddShallow(river2ID, 0.38);
	rmRiverAddShallow(river2ID, 0.62);
	rmRiverAddShallow(river2ID, 0.8);
	rmRiverBuild(river2ID);
	}
	else if (rivershape == 1) //   () shaped
	{
	river1ID = rmRiverCreate(-1, riverType, 15, 6, 4+0.25*cNumberNonGaiaPlayers, 4+0.25*cNumberNonGaiaPlayers); //
	rmRiverAddWaypoint(river1ID, 0.32, 0.98); 
	rmRiverAddWaypoint(river1ID, 0.32, 0.87); 
	rmRiverAddWaypoint(river1ID, 0.20, 0.62); 
	rmRiverAddWaypoint(river1ID, 0.24, 0.50); 
	rmRiverAddWaypoint(river1ID, 0.20, 0.38); 
	rmRiverAddWaypoint(river1ID, 0.32, 0.13);
	rmRiverAddWaypoint(river1ID, 0.32, 0.02);
	rmRiverSetBankNoiseParams(river1ID, 0.00, 0, 0.0, 0.0, 0.0, 0.0);
	rmRiverSetShallowRadius(river1ID, 5+0.5*cNumberNonGaiaPlayers);
	rmRiverAddShallow(river1ID, 0.12);
	rmRiverAddShallow(river1ID, 0.32);
	rmRiverAddShallow(river1ID, 0.68);
	rmRiverAddShallow(river1ID, 0.88);
	rmRiverBuild(river1ID);
	
	river2ID = rmRiverCreate(-1, riverType, 15, 6, 4+0.25*cNumberNonGaiaPlayers, 4+0.25*cNumberNonGaiaPlayers); //
	rmRiverAddWaypoint(river2ID, 0.68, 0.98); 
	rmRiverAddWaypoint(river2ID, 0.68, 0.87); 
	rmRiverAddWaypoint(river2ID, 0.80, 0.62); 
	rmRiverAddWaypoint(river2ID, 0.76, 0.50); 
	rmRiverAddWaypoint(river2ID, 0.80, 0.38); 
	rmRiverAddWaypoint(river2ID, 0.68, 0.13);
	rmRiverAddWaypoint(river2ID, 0.68, 0.02);
	rmRiverSetBankNoiseParams(river2ID, 0.00, 0, 0.0, 0.0, 0.0, 0.0);
	rmRiverSetShallowRadius(river2ID, 5+0.5*cNumberNonGaiaPlayers);
	rmRiverAddShallow(river2ID, 0.12);
	rmRiverAddShallow(river2ID, 0.32);
	rmRiverAddShallow(river2ID, 0.68);
	rmRiverAddShallow(river2ID, 0.88);
	rmRiverBuild(river2ID);
	}
	else // || shaped for FFA
	{
	river1ID = rmRiverCreate(-1, riverType, 15, 6, 4+0.25*cNumberNonGaiaPlayers, 4+0.25*cNumberNonGaiaPlayers); //
	rmRiverAddWaypoint(river1ID, 0.22, 0.98); 
	rmRiverAddWaypoint(river1ID, 0.22, 0.87); 
	rmRiverAddWaypoint(river1ID, 0.22, 0.62); 
	rmRiverAddWaypoint(river1ID, 0.22, 0.50); 
	rmRiverAddWaypoint(river1ID, 0.22, 0.38); 
	rmRiverAddWaypoint(river1ID, 0.22, 0.13);
	rmRiverAddWaypoint(river1ID, 0.22, 0.02);
	rmRiverSetBankNoiseParams(river1ID, 0.00, 0, 0.0, 0.0, 0.0, 0.0);
	rmRiverSetShallowRadius(river1ID, 5+0.5*cNumberNonGaiaPlayers);
	rmRiverAddShallow(river1ID, 0.16);
	rmRiverAddShallow(river1ID, 0.34);
	rmRiverAddShallow(river1ID, 0.66);
	rmRiverAddShallow(river1ID, 0.84);
	rmRiverBuild(river1ID);
	
	river2ID = rmRiverCreate(-1, riverType, 15, 6, 4+0.25*cNumberNonGaiaPlayers, 4+0.25*cNumberNonGaiaPlayers); //
	rmRiverAddWaypoint(river2ID, 0.78, 0.98); 
	rmRiverAddWaypoint(river2ID, 0.78, 0.87); 
	rmRiverAddWaypoint(river2ID, 0.78, 0.62); 
	rmRiverAddWaypoint(river2ID, 0.78, 0.50); 
	rmRiverAddWaypoint(river2ID, 0.78, 0.38); 
	rmRiverAddWaypoint(river2ID, 0.78, 0.13);
	rmRiverAddWaypoint(river2ID, 0.78, 0.02);
	rmRiverSetBankNoiseParams(river2ID, 0.00, 0, 0.0, 0.0, 0.0, 0.0);
	rmRiverSetShallowRadius(river2ID, 5+0.5*cNumberNonGaiaPlayers);
	rmRiverAddShallow(river2ID, 0.16);
	rmRiverAddShallow(river2ID, 0.34);
	rmRiverAddShallow(river2ID, 0.66);
	rmRiverAddShallow(river2ID, 0.84);
	rmRiverBuild(river2ID);
	}
	
	
	//SW area
	int SWareaID = rmCreateArea("SW external area");
	rmSetAreaWarnFailure(SWareaID, false);
	rmSetAreaSize(SWareaID, 0.20, 0.20);
	rmSetAreaLocation(SWareaID, 0.00, 0.50);
	rmSetAreaObeyWorldCircleConstraint(SWareaID, true);
	rmAddAreaConstraint (SWareaID, avoidImpassableLandMin);
//	rmSetAreaTerrainType(SWareaID, "new_england\ground2_cliff_ne"); // for testing	
	rmBuildArea(SWareaID);
	
	int stayInSWarea = rmCreateAreaMaxDistanceConstraint("stay in SW area", SWareaID, 0.0);
	int stayNearSWarea = rmCreateAreaMaxDistanceConstraint("stay near SW area", SWareaID, 50.0);
	int avoidSWarea = rmCreateAreaDistanceConstraint("avoid SW area", SWareaID, 2.0);
	
	
	//NE area
	int NEareaID = rmCreateArea("NE external area");
	rmSetAreaWarnFailure(NEareaID, false);
	rmSetAreaSize(NEareaID, 0.20, 0.20);
	rmSetAreaLocation(NEareaID, 1.00, 0.50);
	rmSetAreaObeyWorldCircleConstraint(NEareaID, true);
	rmAddAreaConstraint (NEareaID, avoidImpassableLandMin);
//	rmSetAreaTerrainType(NEareaID, "new_england\ground2_cliff_ne"); // for testing
	rmBuildArea(NEareaID);
	
	int stayInNEarea = rmCreateAreaMaxDistanceConstraint("stay in NE area", NEareaID, 0.0);
	int stayNearNEarea = rmCreateAreaMaxDistanceConstraint("stay near NE area", NEareaID, 50.0);
	int avoidNEarea = rmCreateAreaDistanceConstraint("avoid NE area", NEareaID, 2.0);
	
	//Central area
	int centralareaID = rmCreateArea("Central area");
	rmSetAreaWarnFailure(centralareaID, false);
	rmSetAreaSize(centralareaID, 0.35, 0.35);
	rmSetAreaLocation(centralareaID, 0.50, 0.50);
	rmSetAreaObeyWorldCircleConstraint(centralareaID, true);
//	rmSetAreaTerrainType(centralareaID, "new_england\ground2_cliff_ne"); // for testing
	rmAddAreaConstraint (centralareaID, avoidImpassableLandMin);
	rmBuildArea(centralareaID);
	
	int stayInCentralarea = rmCreateAreaMaxDistanceConstraint("stay in central area", centralareaID, 0.0);
	int stayNearCentralarea = rmCreateAreaMaxDistanceConstraint("stay near central area", centralareaID, 50.0);
	int avoidCentralarea = rmCreateAreaDistanceConstraint("avoid central area", centralareaID, 2.0);
			
	//SW fertile strips
	for (i=0; <2)
	{
		int SWstripID = rmCreateArea("SW strip"+i);
		rmSetAreaWarnFailure(SWstripID, false);
		rmSetAreaObeyWorldCircleConstraint(SWstripID, false);
		if (i <1)
			rmSetAreaSize(SWstripID, 0.048, 0.048);
		else
			rmSetAreaSize(SWstripID, 0.068, 0.068);
		rmSetAreaCoherence(SWstripID, 0.00);
		if (isWinterSeason == false) {
			rmSetAreaTerrainType(SWstripID, "africa\ground4_africa");
			rmSetAreaMix(SWstripID, "africa_grass");
		}
		rmAddAreaConstraint (SWstripID, avoidImpassableLandMin);
		rmAddAreaConstraint (SWstripID, stayNearWater);
		rmAddAreaConstraint (SWstripID, stayNearSWarea);
		if (i <1)
			rmAddAreaConstraint (SWstripID, stayInSWarea);
		else
			rmAddAreaConstraint (SWstripID, avoidSWarea);
		rmBuildArea(SWstripID);
	}
		
	//NE fertile strips
	for (i=0; <2)
	{
		int NEstripID = rmCreateArea("NE strip"+i);
		rmSetAreaWarnFailure(NEstripID, false);
		rmSetAreaObeyWorldCircleConstraint(NEstripID, false);
		if (i <1)
			rmSetAreaSize(NEstripID, 0.048, 0.048);
		else
			rmSetAreaSize(NEstripID, 0.068, 0.068);
		rmSetAreaCoherence(NEstripID, 0.00);
		if (isWinterSeason == false) {
			rmSetAreaTerrainType(NEstripID, "africa\ground4_africa");
			rmSetAreaMix(NEstripID, "africa_grass");
		}
		rmAddAreaConstraint (NEstripID, avoidImpassableLandMin);
		rmAddAreaConstraint (NEstripID, stayNearWater);
		rmAddAreaConstraint (NEstripID, stayNearNEarea);
		if (i <1)
			rmAddAreaConstraint (NEstripID, stayInNEarea);
		else
			rmAddAreaConstraint (NEstripID, avoidNEarea);
		rmBuildArea(NEstripID);
	}
		
	// Terrain patch1
	for (i=0; < 20+10*cNumberNonGaiaPlayers)
    {
        int patchID = rmCreateArea("patch grass light "+i);
        rmSetAreaWarnFailure(patchID, false);
        rmSetAreaSize(patchID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(140));
		if (isWinterSeason == false) {
			rmSetAreaTerrainType(patchID, "africa\ground1_africa");
			rmAddAreaTerrainLayer(patchID, "africa\ground1_africa", 0, 1);
			rmSetAreaMix(patchID, "africa_dirt");
		}
        rmAddAreaToClass(patchID, classPatch);
        rmSetAreaMinBlobs(patchID, 1);
        rmSetAreaMaxBlobs(patchID, 5);
        rmSetAreaMinBlobDistance(patchID, 16.0);
        rmSetAreaMaxBlobDistance(patchID, 40.0);
        rmSetAreaCoherence(patchID, 0.0);
		rmAddAreaConstraint(patchID, avoidImpassableLandMin);
		rmAddAreaConstraint(patchID, avoidPatch);
		rmAddAreaConstraint(patchID, stayNearWater);
		if (i < (20+10*cNumberNonGaiaPlayers)/2)
			rmAddAreaConstraint(patchID, stayNearSWarea);
		else
			rmAddAreaConstraint(patchID, stayNearNEarea);
        rmBuildArea(patchID); 
    }
	
	// Players area
	for (i=1; < cNumberPlayers)
	{
		int playerareaID = rmCreateArea("playerarea"+i);
		rmSetPlayerArea(i, playerareaID);
		rmSetAreaSize(playerareaID,rmAreaTilesToFraction(400), rmAreaTilesToFraction(400));
		rmSetAreaCoherence(playerareaID, 1.0);
		rmSetAreaWarnFailure(playerareaID, false);
//		rmSetAreaTerrainType(playerareaID, "africa\ground1_africa"); // for testing
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
		float xLoc = 0.5;
		float yLoc = 0.5;
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
//	rmAddObjectDefConstraint(socketID, avoidImpassableLandMed);
	
	int tradeRoute2ID = rmCreateTradeRoute();
	int socket2ID=rmCreateObjectDef("sockets to dock Trade Posts 2");
	rmAddObjectDefItem(socket2ID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socket2ID, true);
	rmSetObjectDefMinDistance(socket2ID, 0.0);
	rmSetObjectDefMaxDistance(socket2ID, 8.0);
//	rmAddObjectDefConstraint(socket2ID, avoidImpassableLandMed);
	
	if (cNumberTeams <= 2 && rmGetIsKOTH() == false) 
	{
		if (rivershape == 0)
		{
				rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
				rmAddTradeRouteWaypoint(tradeRouteID, 0.00, 0.58);
				rmAddTradeRouteWaypoint(tradeRouteID, 0.15, 0.64);
				rmAddTradeRouteWaypoint(tradeRouteID, 0.30, 0.64); 
				rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.68);
				rmAddTradeRouteWaypoint(tradeRouteID, 0.70, 0.64); 
				rmAddTradeRouteWaypoint(tradeRouteID, 0.85, 0.64);
				rmAddTradeRouteWaypoint(tradeRouteID, 1.00, 0.58);
				
				rmAddTradeRouteWaypoint(tradeRoute2ID, 0.00, 0.42);
				rmAddTradeRouteWaypoint(tradeRoute2ID, 0.15, 0.36);
				rmAddTradeRouteWaypoint(tradeRoute2ID, 0.30, 0.36);
				rmAddTradeRouteWaypoint(tradeRoute2ID, 0.50, 0.32);
				rmAddTradeRouteWaypoint(tradeRoute2ID, 0.70, 0.36);
				rmAddTradeRouteWaypoint(tradeRoute2ID, 0.85, 0.36);
				rmAddTradeRouteWaypoint(tradeRoute2ID, 1.00, 0.42);			
			}
		else
			{
				rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
				rmAddTradeRouteWaypoint(tradeRouteID, 0.00, 0.76);
				rmAddTradeRouteWaypoint(tradeRouteID, 1.00, 0.24);
				
				rmAddTradeRouteWaypoint(tradeRoute2ID, 0.00, 0.24);
				rmAddTradeRouteWaypoint(tradeRoute2ID, 1.00, 0.76);
		}
	}
	else
	{
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.10, 0.20);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.10, 0.40); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.10, 0.50);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.10, 0.60); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.10, 0.80);
	
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.90, 0.80);
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.90, 0.60);
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.90, 0.50);
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.90, 0.40);
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.90, 0.20);
		
	}
	
	bool placedTradeRouteA = rmBuildTradeRoute(tradeRouteID, "water");
	bool placedTradeRouteB = rmBuildTradeRoute(tradeRoute2ID, "water");
	
	if (cNumberTeams <= 2 && rmGetIsKOTH() == false)
	{
		vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.12);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.88);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		vector socket2Loc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.12);
		rmPlaceObjectDefAtPoint(socket2ID, 0, socket2Loc);
		socket2Loc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.88);
		rmPlaceObjectDefAtPoint(socket2ID, 0, socket2Loc);
		if (cNumberNonGaiaPlayers > 4)
		{
			if (rivershape == 0)
			{	
				socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
				rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
				socket2Loc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.50);
				rmPlaceObjectDefAtPoint(socket2ID, 0, socket2Loc);
			}
			else
			{	
				socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.46);
				rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
				socket2Loc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.54);
				rmPlaceObjectDefAtPoint(socket2ID, 0, socket2Loc);
			}
		}
	}
	else
	{
		 socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.20);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.80);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		 socket2Loc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.20);
		rmPlaceObjectDefAtPoint(socket2ID, 0, socket2Loc);
		socket2Loc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.80);
		rmPlaceObjectDefAtPoint(socket2ID, 0, socket2Loc);
		if (cNumberNonGaiaPlayers >= 6)
		{
				socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
				rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
				socket2Loc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.50);
				rmPlaceObjectDefAtPoint(socket2ID, 0, socket2Loc);
		}
	}
	
	// *************************************************************************************************************
	
	// ******************************************** NATIVES *************************************************
	
    int nativeID1 = -1;
	int nativeID2 = -1;
	int nativeID3 = -1;
	int natArea1 = -1;
	int natArea2 = -1;
	int natArea3 = -1;
	
	nativeID1 = rmCreateGrouping("Sufi 1", "native sufi mosque deccan "+3); // NW
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
//  rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
	rmAddGroupingToClass(nativeID1, classNative);
		
	nativeID2 = rmCreateGrouping("Sufi 2", "native sufi mosque deccan "+4); // SE 
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
//  rmAddGroupingConstraint(nativeID2, avoidImpassableLand);
	rmAddGroupingToClass(nativeID2, classNative);
	
	nativeID3 = rmCreateGrouping("Saltpeter", "saltpeter_0"+2); // M 
    rmSetGroupingMinDistance(nativeID3, 0.00);
    rmSetGroupingMaxDistance(nativeID3, 0.00);
//  rmAddGroupingConstraint(nativeID3, avoidImpassableLand);
	rmAddGroupingToClass(nativeID3, classNative);
	
	natArea1 = rmCreateArea("native area 1");
	rmSetAreaSize(natArea1,rmAreaTilesToFraction(250), rmAreaTilesToFraction(250));
	rmSetAreaCoherence(natArea1, 0.75);
	rmSetAreaWarnFailure(natArea1, false);
	if (isWinterSeason == false) {
		rmSetAreaTerrainType(natArea1, "africa\dirt1_africa");
		rmAddAreaTerrainLayer(natArea1, "africa\dirt1_africa", 0, 1);
		rmSetAreaMix(natArea1, "africa_dirt");
	}
	rmSetAreaObeyWorldCircleConstraint(natArea1, false);
	
	natArea2 = rmCreateArea("native area 2");
	rmSetAreaSize(natArea2,rmAreaTilesToFraction(250), rmAreaTilesToFraction(250));
	rmSetAreaCoherence(natArea2, 0.75);
	rmSetAreaWarnFailure(natArea2, false);
	if (isWinterSeason == false) {
		rmSetAreaTerrainType(natArea2, "africa\dirt1_africa");
		rmAddAreaTerrainLayer(natArea2, "africa\dirt1_africa", 0, 1);
		rmSetAreaMix(natArea2, "africa_dirt");
	}
	rmSetAreaObeyWorldCircleConstraint(natArea2, false);
	
	natArea3 = rmCreateArea("native area 3");
	rmSetAreaSize(natArea3,rmAreaTilesToFraction(250), rmAreaTilesToFraction(250));
	rmSetAreaCoherence(natArea3, 0.75);
	rmSetAreaWarnFailure(natArea3, false);
	if (isWinterSeason == false) {
		rmSetAreaTerrainType(natArea3, "africa\dirt1_africa");
		rmAddAreaTerrainLayer(natArea3, "africa\dirt1_africa", 0, 1);
		rmSetAreaMix(natArea3, "africa_dirt");
	}
	rmSetAreaObeyWorldCircleConstraint(natArea3, false);
	
	if (rivershape == 0)
	{
		if (cNumberNonGaiaPlayers <= 2)
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.42, 0.78); // 
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.58, 0.22); // 
			rmSetAreaLocation(natArea1, 0.42, 0.78);
			rmBuildArea(natArea1);
			rmSetAreaLocation(natArea2, 0.58, 0.22);
			rmBuildArea(natArea2);
		}
		else if (cNumberNonGaiaPlayers <= 4)
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.74); // 
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.50, 0.26); // 
			rmSetAreaLocation(natArea1, 0.50, 0.74);
			rmBuildArea(natArea1);
			rmSetAreaLocation(natArea2, 0.50, 0.26);
			rmBuildArea(natArea2);
		}
		else 
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.40, 0.46); // 
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.60, 0.54); // 
			rmSetAreaLocation(natArea1, 0.40, 0.46);
			rmBuildArea(natArea1);
			rmSetAreaLocation(natArea2, 0.60, 0.54);
			rmBuildArea(natArea2);
		}
	}
	else if (rivershape == 1)
	{
		if (cNumberNonGaiaPlayers <= 2)
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.45, 0.68); // 
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.55, 0.34); // 
			rmSetAreaLocation(natArea1, 0.45, 0.68);
			rmBuildArea(natArea1);
			rmSetAreaLocation(natArea2, 0.55, 0.34);
			rmBuildArea(natArea2);
		}
		else if (cNumberNonGaiaPlayers <= 4)
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.65); // 
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.50, 0.35); // 
			rmSetAreaLocation(natArea1, 0.50, 0.65);
			rmBuildArea(natArea1);
			rmSetAreaLocation(natArea2, 0.50, 0.35);
			rmBuildArea(natArea2);
		}
		else 
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.65); // 
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.50, 0.35); // 
			rmSetAreaLocation(natArea1, 0.50, 0.65);
			rmBuildArea(natArea1);
			rmSetAreaLocation(natArea2, 0.50, 0.35);
			rmBuildArea(natArea2);
		}
	}
	else
	{
		if (cNumberNonGaiaPlayers <= 5)
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.68); // 
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.50, 0.34); // 
			rmSetAreaLocation(natArea1, 0.50, 0.68);
			rmBuildArea(natArea1);
			rmSetAreaLocation(natArea2, 0.50, 0.34);
			rmBuildArea(natArea2);
		}
		else 
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.70); // 
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.50, 0.30); // 
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.50, 0.50); //
			rmSetAreaLocation(natArea1, 0.50, 0.70);
			rmBuildArea(natArea1);
			rmSetAreaLocation(natArea2, 0.50, 0.30);
			rmBuildArea(natArea2);
			rmSetAreaLocation(natArea3, 0.50, 0.50);
			rmBuildArea(natArea3);	
		}
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
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "mine", 1, 0);
	if (rivershape == 0)
	{
		rmSetObjectDefMinDistance(playergold2ID, 46.0); //58
		rmSetObjectDefMaxDistance(playergold2ID, 48.0); //62
	}
	else
	{
		rmSetObjectDefMinDistance(playergold2ID, 44.0); //58
		rmSetObjectDefMaxDistance(playergold2ID, 47.0); //62
	}
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRoute);
	if (cNumberNonGaiaPlayers <= 2)
		rmAddObjectDefConstraint(playergold2ID, avoidImpassableLandFar);
	else
		rmAddObjectDefConstraint(playergold2ID, avoidImpassableLandMed);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldType);
	rmAddObjectDefConstraint(playergold2ID, avoidTownCenterMed);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold2ID, avoidCenter);
	rmAddObjectDefConstraint(playergold2ID, stayInCentralarea);
	rmAddObjectDefConstraint(playergold2ID, avoidEdgeMore);
	
	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 3, 3.0);
	rmSetObjectDefMinDistance(playerberriesID, 12.0);
	rmSetObjectDefMaxDistance(playerberriesID, 15.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerberriesID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerberriesID, avoidNatives);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResources);
	
	// Starting trees1
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, mainTreeType, rmRandInt(2,2), 3.0); //
    rmSetObjectDefMinDistance(playerTreeID, 13);
    rmSetObjectDefMaxDistance(playerTreeID, 16);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	
	// Starting trees2
	int playerTree2ID = rmCreateObjectDef("player trees 2");
	rmAddObjectDefItem(playerTree2ID, mainTreeType, rmRandInt(6,6), 5.0); //
    rmSetObjectDefMinDistance(playerTree2ID, 16);
    rmSetObjectDefMaxDistance(playerTree2ID, 18);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
	rmAddObjectDefToClass(playerTree2ID, classForest);
	rmAddObjectDefConstraint(playerTree2ID, avoidForestShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTree2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResources);
	
	// Starting herd
	int playerIbexID = rmCreateObjectDef("starting Ibex");
	rmAddObjectDefItem(playerIbexID, "Heron", rmRandInt(6,6), 3.0);
	rmSetObjectDefMinDistance(playerIbexID, 13.0);
	rmSetObjectDefMaxDistance(playerIbexID, 16.0);
	rmSetObjectDefCreateHerd(playerIbexID, false);
	rmAddObjectDefToClass(playerIbexID, classStartingResource);
	rmAddObjectDefConstraint(playerIbexID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerIbexID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerIbexID, avoidNatives);
	rmAddObjectDefConstraint(playerIbexID, avoidIbexShort);
	rmAddObjectDefConstraint(playerIbexID, avoidHeronShort);
	rmAddObjectDefConstraint(playerIbexID, avoidStartingResources);
		
	// 2nd herd
	int playerIbex2ID = rmCreateObjectDef("player 2nd Ibex");
    rmAddObjectDefItem(playerIbex2ID, "Heron", rmRandInt(12,12), 9.0);
    rmSetObjectDefMinDistance(playerIbex2ID, 35);
    rmSetObjectDefMaxDistance(playerIbex2ID, 40);
	rmAddObjectDefToClass(playerIbex2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerIbex2ID, true);
	rmAddObjectDefConstraint(playerIbex2ID, avoidIbex); //Short
	rmAddObjectDefConstraint(playerIbex2ID, avoidHeron);
//	rmAddObjectDefConstraint(playerIbex2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerIbex2ID, avoidImpassableLandFar);
	rmAddObjectDefConstraint(playerIbex2ID, avoidNatives);
	rmAddObjectDefConstraint(playerIbex2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerIbex2ID, stayInCentralarea);
	rmAddObjectDefConstraint(playerIbex2ID, avoidEdge);
		
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
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerIbex2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerIbexID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
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
	
		int goldmineCount = 1+0.17*cNumberNonGaiaPlayers;  // 3,3 
		int goldvariation = -1;
		float goldZ = -1;
		goldvariation = rmRandInt(0,1);
		if (goldvariation == 0)
		{
			if (rivershape == 0)
				goldZ = 0.42;
			else
				goldZ = 0.40;
		}		
		else
		{
			if (rivershape == 0)
				goldZ = 0.58;
			else
				goldZ = 0.60;
		}
		
		int centralmineCount = 1*cNumberNonGaiaPlayers+rivershape;  // 3,3 
		int sidemineCount = 1*cNumberNonGaiaPlayers;  // 3,3 
	
	//Gold mines
	for(i=0; < goldmineCount)
	{
		int goldmineID = rmCreateObjectDef("gold mine"+i);
		rmAddObjectDefItem(goldmineID, "Minegold", 1, 0.0);
		rmSetObjectDefMinDistance(goldmineID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(goldmineID, rmXFractionToMeters(0.02+0.01*cNumberNonGaiaPlayers));
		rmAddObjectDefToClass(goldmineID, classGold);
		rmAddObjectDefConstraint(goldmineID, avoidTradeRoute);
		rmAddObjectDefConstraint(goldmineID, avoidImpassableLand);
		rmAddObjectDefConstraint(goldmineID, avoidNatives);
		rmAddObjectDefConstraint(goldmineID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(goldmineID, avoidGold);
		rmAddObjectDefConstraint(goldmineID, avoidTownCenter);
		rmAddObjectDefConstraint(goldmineID, avoidEdge);
		rmPlaceObjectDefAtLoc(goldmineID, 0, 0.85, goldZ);
		rmPlaceObjectDefAtLoc(goldmineID, 0, 0.15, (1.0-goldZ));
	}
	
	//Side silver mines
	for(i=0; < sidemineCount)
	{
		int silvermine2ID = rmCreateObjectDef("silver mine sides"+i);
		rmAddObjectDefItem(silvermine2ID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(silvermine2ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(silvermine2ID, rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(silvermine2ID, classGold);
		rmAddObjectDefConstraint(silvermine2ID, avoidTradeRoute);
		rmAddObjectDefConstraint(silvermine2ID, avoidImpassableLand);
		rmAddObjectDefConstraint(silvermine2ID, avoidNatives);
		rmAddObjectDefConstraint(silvermine2ID, avoidTradeRouteSocket);
		if (rivershape == 0)
			rmAddObjectDefConstraint(silvermine2ID, avoidGoldFar);
		else
			rmAddObjectDefConstraint(silvermine2ID, avoidGoldVeryFar);
		rmAddObjectDefConstraint(silvermine2ID, avoidTownCenter);
		rmAddObjectDefConstraint(silvermine2ID, avoidCentralarea);
		rmAddObjectDefConstraint(silvermine2ID, avoidEdge);
		if (cNumberTeams <= 2 )
		{
			if (i < 1)
				rmAddObjectDefConstraint(silvermine2ID, stayInNEarea);
			else if (i < 2)
				rmAddObjectDefConstraint(silvermine2ID, stayInSWarea);
		}
		rmPlaceObjectDefAtLoc(silvermine2ID, 0, 0.50, 0.50);
	}
	
	
	//Central silver mines
	for(i=0; < centralmineCount)
	{
		int silvermineID = rmCreateObjectDef("silver mine center"+i);
		rmAddObjectDefItem(silvermineID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(silvermineID, rmXFractionToMeters(0.05));
		rmSetObjectDefMaxDistance(silvermineID, rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(silvermineID, classGold);
		rmAddObjectDefConstraint(silvermineID, avoidTradeRoute);
		rmAddObjectDefConstraint(silvermineID, avoidImpassableLand);
		rmAddObjectDefConstraint(silvermineID, avoidNatives);
		rmAddObjectDefConstraint(silvermineID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(silvermineID, avoidGold);
		rmAddObjectDefConstraint(silvermineID, avoidTownCenter);
		rmAddObjectDefConstraint(silvermineID, stayCenter);
		rmAddObjectDefConstraint(silvermineID, avoidEdge);
//		if (cNumberTeams <= 2 && cNumberNonGaiaPlayers == 2)
//		{
//			if (i < 1)
//				rmAddObjectDefConstraint(silvermineID, staySE);
//			else if (i < 2)
//				rmAddObjectDefConstraint(silvermineID, stayNW);
//		}
		rmPlaceObjectDefAtLoc(silvermineID, 0, 0.50, 0.50);
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
		rmSetAreaSize(forestID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(250));
		if (isWinterSeason == false) {
			rmSetAreaTerrainType(forestID, "africa\ground3_africa");
			rmAddAreaTerrainLayer(forestID, "africa\ground3_africa", 0, 1);
			rmSetAreaMix(forestID, "africa_forest");
		}
		rmSetAreaMinBlobs(forestID, 2);
		rmSetAreaMaxBlobs(forestID, 5);
		rmSetAreaMinBlobDistance(forestID, 14.0);
		rmSetAreaMaxBlobDistance(forestID, 30.0);
		rmSetAreaCoherence(forestID, 0.0);
		rmSetAreaSmoothDistance(forestID, 5);
//		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidForest);
		rmAddAreaConstraint(forestID, stayNearWater);
		rmAddAreaConstraint(forestID, avoidTradeRouteShort);
		rmAddAreaConstraint(forestID, avoidImpassableLandShort);
		rmAddAreaConstraint(forestID, avoidNatives);
		rmAddAreaConstraint(forestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(forestID, avoidGoldTypeShort);
//		rmAddAreaConstraint(forestID, avoidEdge);
		rmAddAreaConstraint(forestID, avoidTownCenterShort);
		rmAddAreaConstraint(forestID, avoidStartingResourcesShort);
		rmAddAreaConstraint(forestID, avoidIbexMin); 
		rmAddAreaConstraint(forestID, avoidNuggetMin); 
		rmBuildArea(forestID);
	
		stayInForest = rmCreateAreaMaxDistanceConstraint("stay in south forest"+i, forestID, 0.0);
	
		for (j=0; < rmRandInt(6,7)+cNumberNonGaiaPlayers) //11,12
		{
			int foresttreeID = rmCreateObjectDef("south tree"+i+" "+j);
			if (isWinterSeason == false) {
				rmAddObjectDefItem(foresttreeID, "UnderbrushDeccan", rmRandInt(2,3), 5.0);
			}
			rmAddObjectDefItem(foresttreeID, mainTreeType, rmRandInt(1,1), 3.0); // 1,2
			rmAddObjectDefItem(foresttreeID, mainTreeType, rmRandInt(1,2), 4.0); // 1,2
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
	int randomforestcount = 10+8*cNumberNonGaiaPlayers; 
	
	for (i=0; < randomforestcount)
	{	
		int RandomtreeID = rmCreateObjectDef("random trees"+i);
		rmAddObjectDefItem(RandomtreeID, mainTreeType, rmRandInt(1,2), 2.0); // 4,5
		rmAddObjectDefItem(RandomtreeID, mainTreeType, rmRandInt(1,3), 4.0); // 4,5
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
		rmAddObjectDefConstraint(RandomtreeID, avoidIbexMin); 
		rmAddObjectDefConstraint(RandomtreeID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidBerriesMin);
		rmAddObjectDefConstraint(RandomtreeID, avoidForestShort);	
//		rmAddObjectDefConstraint(RandomtreeID, avoidEdge);
		rmPlaceObjectDefAtLoc(RandomtreeID, 0, 0.5, 0.5);
	}
	
	// ********************************	
	
	// Text
	rmSetStatusText("",0.70);

	// ********** Herds ***********

	//Ibex hunts
	int ibexcount = 1+3*cNumberNonGaiaPlayers;
	
	for(i=0; < ibexcount)
	{
		int IbexID = rmCreateObjectDef("ibex hunt"+i);
		rmAddObjectDefItem(IbexID, "Gazelle", rmRandInt(11,12), 9.0);
		rmSetObjectDefMinDistance(IbexID, 0.0);
		rmSetObjectDefMaxDistance(IbexID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(IbexID, true);
		rmAddObjectDefConstraint(IbexID, avoidImpassableLand);
		rmAddObjectDefConstraint(IbexID, avoidNativesShort);
		rmAddObjectDefConstraint(IbexID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(IbexID, avoidGoldMed);
		rmAddObjectDefConstraint(IbexID, avoidTownCenter);
		rmAddObjectDefConstraint(IbexID, avoidForestMin);
		rmAddObjectDefConstraint(IbexID, avoidBerriesShort); 
//		if (rivershape == 0)
			rmAddObjectDefConstraint(IbexID, avoidIbexFar);
//		else
//			rmAddObjectDefConstraint(IbexID, avoidIbexVeryFar);
		rmAddObjectDefConstraint(IbexID, avoidEdge);	
		if (cNumberTeams <= 2)
		{
			if (i < 1)
				rmAddObjectDefConstraint(IbexID, stayNW);
			else if (i < 2)
				rmAddObjectDefConstraint(IbexID, staySE);
			else if (i < 3)
				rmAddObjectDefConstraint(IbexID, stayCenterMore);
			else if (i < 4)
				rmAddObjectDefConstraint(IbexID, stayNWhalf);
			else if (i < 5)
				rmAddObjectDefConstraint(IbexID, staySEhalf);
				

		}
		rmPlaceObjectDefAtLoc(IbexID, 0, 0.5, 0.5);
	}
	
	//Berries
	int berriescount = 2+2*cNumberNonGaiaPlayers;
	int stayInBerriesArea = -1;
	
	for (i=0; < berriescount)
	{
		int berriesareaID = rmCreateArea("berries area"+i);
		rmSetAreaWarnFailure(berriesareaID, false);
		rmSetAreaObeyWorldCircleConstraint(berriesareaID, false);
		rmSetAreaSize(berriesareaID, rmAreaTilesToFraction(70), rmAreaTilesToFraction(80));
		if (isWinterSeason == false) {
			rmSetAreaTerrainType(berriesareaID, "africa\ground3_africa");
			rmAddAreaTerrainLayer(berriesareaID, "africa\ground3_africa", 0, 1);
			rmSetAreaMix(berriesareaID, "africa_forest");
		}
//		rmSetAreaMinBlobs(berriesareaID, 2);
//		rmSetAreaMaxBlobs(berriesareaID, 3);
//		rmSetAreaMinBlobDistance(berriesareaID, 14.0);
//		rmSetAreaMaxBlobDistance(berriesareaID, 24.0);
		rmSetAreaCoherence(berriesareaID, 0.90);
//		rmSetAreaSmoothDistance(berriesareaID, 2);
		rmAddAreaConstraint(berriesareaID, avoidForestMin);
		rmAddAreaConstraint(berriesareaID, avoidIbexShort);
		rmAddAreaConstraint(berriesareaID, avoidTradeRouteShort);
		rmAddAreaConstraint(berriesareaID, avoidTradeRouteSocket);
		rmAddAreaConstraint(berriesareaID, avoidImpassableLand);
		rmAddAreaConstraint(berriesareaID, avoidNatives);
		rmAddAreaConstraint(berriesareaID, avoidTownCenter);
		rmAddAreaConstraint(berriesareaID, avoidGoldTypeShort);
		rmAddAreaConstraint(berriesareaID, avoidEdgeMore);
		rmAddAreaConstraint(berriesareaID, avoidStartingResources);
		rmAddAreaConstraint(berriesareaID, avoidBerriesFar);
		rmBuildArea(berriesareaID);
	
		stayInBerriesArea = rmCreateAreaMaxDistanceConstraint("stay in berries area"+i, berriesareaID, 0.0);
	
//		for(i=0; < berriescount)
//		{
			int berriesID = rmCreateObjectDef("berries"+i);
			rmAddObjectDefItem(berriesID, "berrybush", rmRandInt(3,3), 3.0);
			rmSetObjectDefMinDistance(berriesID, rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(berriesID, rmXFractionToMeters(0.5));
			rmAddObjectDefConstraint(berriesID, avoidImpassableLand);
			rmAddObjectDefConstraint(berriesID, avoidNatives);
			rmAddObjectDefConstraint(berriesID, avoidTradeRoute);
			rmAddObjectDefConstraint(berriesID, avoidTradeRouteSocket);
			rmAddObjectDefConstraint(berriesID, avoidGoldTypeShort);
			rmAddObjectDefConstraint(berriesID, avoidForestMin);
//			rmAddObjectDefConstraint(berriesID, avoidTownCenterFar);
			rmAddObjectDefConstraint(berriesID, avoidIbexShort);
			rmAddObjectDefConstraint(berriesID, avoidBerriesFar);
			rmAddObjectDefConstraint(berriesID, avoidEdgeMore);
			rmAddObjectDefConstraint(berriesID, stayInBerriesArea);
			rmPlaceObjectDefAtLoc(berriesID, 0, 0.50, 0.50);
//		}
	}
	
	// ********************************
	
	// Text
	rmSetStatusText("",0.80);
	
	// ********** Treasures ***********
	
	
	int nugget1count = 4+0.5*cNumberNonGaiaPlayers;
	int nugget2count = 4+0.5*cNumberNonGaiaPlayers; 
	int nugget3count = 1+0.5*cNumberNonGaiaPlayers; 
	int nugget4count = 0.34*cNumberNonGaiaPlayers; 
	
	// Treasures 4	
	
	for (i=0; < nugget4count)
	{
		int Nugget4ID = rmCreateObjectDef("nugget 4 "+i); 
		rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget4ID, 0);
		rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(Nugget4ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidIbexMin); 
		rmAddObjectDefConstraint(Nugget4ID, avoidBerriesMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget4ID, stayCenter); 
		rmAddObjectDefConstraint(Nugget4ID, avoidEdge); 
		rmSetNuggetDifficulty(4,4);
		if (cNumberNonGaiaPlayers >= 4)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.50, 0.50);
	}
	
	// Treasures 3
	for (i=0; < nugget3count)
	{
		int Nugget3ID = rmCreateObjectDef("nugget 3 "+i); 
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, 0);
		rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(Nugget3ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidIbexMin); 
		rmAddObjectDefConstraint(Nugget3ID, avoidBerriesMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget3ID, avoidEdge); 
		rmSetNuggetDifficulty(3,3);
		if (i == 0)
			rmAddObjectDefConstraint(Nugget3ID, stayNWhalf);
		else if (i == 1)
			rmAddObjectDefConstraint(Nugget3ID, staySEhalf);
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
		rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidIbexMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidBerriesMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge); 
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
		rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget1ID, avoidIbexMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidBerriesMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge); 
		rmSetNuggetDifficulty(1,1);
		if (i == 0)
			rmAddObjectDefConstraint(Nugget1ID, stayNWhalf);
		else if (i == 1)
			rmAddObjectDefConstraint(Nugget1ID, staySEhalf);
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);
	}
	
	// ********************************
		
	// Text
	rmSetStatusText("",0.90);
	
	// ****************************************
	
	// Text
	rmSetStatusText("",1.00);

	
} //END
	
	