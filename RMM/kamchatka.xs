// ESOC KAMCHATKA (1V1, TEAM, FFA)
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
	
	// Pick the season
	float season = -1;
	season = rmRandFloat(0.1, 1.0);
//	season = 0.6; // <-- TEST

	if (false) {
		season = 1;
	} else if (false) {
		season = 0.1;
	}
	
	// Pick the layout
	int Layoutvariation = -1;
//	Layoutvariation = rmRandInt(0,1);
	Layoutvariation = 0; // <-- TEST
	
	// Picks the map size
	int playerTiles=11000; //12000
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	rmSetMapElevationParameters(cElevTurbulence,  0.050, 3, 0.46, 4.0); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);
	
	// Picks a default water height
	if (season >= 0.5)
		rmSetSeaLevel(1.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.
	else
		rmSetSeaLevel(0.0);

	// Picks default terrain and water
	if (season >= 0.5)
	{
		rmSetBaseTerrainMix("patagonia_grass");
		rmTerrainInitialize("patagonia\ground_grass1_pat", 3.0); //dirt1
	}
	else
	{
		rmSetBaseTerrainMix("araucania_snow_a");
		rmTerrainInitialize("araucania\ground_snow1_ara", 3.0);
	}	
	rmSetMapType("siberia");
	rmSetMapType("grass");
	rmSetMapType("land");
	rmSetMapType("asia");
//	rmSetLightingSet("nwterritory");
	if (season >= 0.5)
		rmSetLightingSet("saguenay"); //california
	else
		rmSetLightingSet("rockies"); //great lakes winter
//	rmSetSeaType("NW Territory River"); non-functional type
	rmSetWindMagnitude(2.0);
	
	
	// Make the corners.
	rmSetWorldCircleConstraint(true);

	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);
	
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Klamath");
	subCiv1 = rmGetCivID("Nootka");
	rmSetSubCiv(0, "Klamath");
	rmSetSubCiv(1, "Nootka");
//	rmEchoInfo("subCiv0 is Klamath "+subCiv0);
//	rmEchoInfo("subCiv1 is Nootka "+subCiv1);
//	string nativeName0 = "native Klamath village";
//	string nativeName1 = "native Nootka village";
	

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("Player");
	int classPatch = rmDefineClass("patch");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int importantItem = rmDefineClass("importantItem");
	int classNative = rmDefineClass("natives");
	int classCliff = rmDefineClass("classCliff");
	int classHole = rmDefineClass("Hole");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	
	// ******************************************************************************************
	
	// Text
	rmSetStatusText("",0.20);
	
	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other
   
   
	// Cardinal Directions & Map placement
	int Southeastconstraint = rmCreatePieConstraint("southeastMapConstraint", 0.5, 0.5, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(90), rmDegreesToRadians(270));
	int Northwestconstraint = rmCreatePieConstraint("northwestMapConstraint", 0.5, 0.5, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(270), rmDegreesToRadians(90));
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.46), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayEdge = rmCreatePieConstraint("Stay Edge",0.5,0.5,rmXFractionToMeters(0.44), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.45,0.5,rmXFractionToMeters(0.30), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.45,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.16), rmDegreesToRadians(0),rmDegreesToRadians(360));
	
	int treasureeast = rmCreatePieConstraint("treasure stay east", 1.0, 0.5, rmZFractionToMeters(0.0), rmZFractionToMeters(0.20), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int treasuremiddle = rmCreatePieConstraint("treasure stay middle", 0.4, 0.5, rmZFractionToMeters(0.0), rmZFractionToMeters(0.18), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int treasurewest = rmCreatePieConstraint("treasure stay west", 0.0, 0.5, rmZFractionToMeters(0.0), rmZFractionToMeters(0.20), rmDegreesToRadians(0), rmDegreesToRadians(360));
	
	// Resource avoidance
//	int avoidForestFar=rmCreateClassDistanceConstraint("forest vs forest", rmClassID("Forest"), 35.0); //15.0
	int avoidForest = rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 29.0); //15.0
	int avoidForestShort = rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 26.0); //15.0
	int avoidForestMin = rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 8.0);
	int avoidCaribouFar = rmCreateTypeDistanceConstraint("avoid caribou far", "caribou", 44.0);
	int avoidCaribou = rmCreateTypeDistanceConstraint("avoid caribou", "caribou", 37.0);
	int avoidCaribouShort = rmCreateTypeDistanceConstraint("avoid caribou short", "caribou", 26.0);
	int avoidCaribouMin = rmCreateTypeDistanceConstraint("avoid caribou min", "caribou", 4.0);
	int avoidMuskdeerFar = rmCreateTypeDistanceConstraint("avoid muskdeer far", "Seal", 44.0);
	int avoidMuskdeer = rmCreateTypeDistanceConstraint("avoid muskdeer", "Seal", 37.0);
	int avoidMuskdeerShort = rmCreateTypeDistanceConstraint("avoid muskdeer short", "Seal", 26.0);
	int avoidMuskdeerMin = rmCreateTypeDistanceConstraint("avoid muskdeer min", "Seal", 4.0);
	int avoidElk = rmCreateTypeDistanceConstraint("avoid elk", "elk", 40.0);
	int avoidElkShort = rmCreateTypeDistanceConstraint("avoid elk short", "elk", 28.0);
	int avoidIbex = rmCreateTypeDistanceConstraint("avoid ibex", "ypibex", 40.0);
	int avoidIbexMin = rmCreateTypeDistanceConstraint("avoid ibex min", "ypibex", 5.0);
//	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 30.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("avoid gold type short", "gold", 10.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("avoid gold type  ", "gold", 20.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("avoid gold type  far ", "gold", 34.0);
	int avoidGoldMin = rmCreateClassDistanceConstraint("avoid gold min", rmClassID("Gold"), 5.0);
	int avoidGold = rmCreateClassDistanceConstraint ("avoid gold", rmClassID("Gold"), 48.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("avoid gold far", rmClassID("Gold"), 65.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint(" avoid nugget min", "AbstractNugget", 4.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint(" avoid nugget short", "AbstractNugget", 36.0);
	int avoidNugget=rmCreateTypeDistanceConstraint(" avoid nugget", "AbstractNugget", 48.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 25.0); //28
	int avoidTownCenterMed=rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 40.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 55.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center far", "townCenter", 68.0);
	int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center  Very Far", "townCenter", 80.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint("resources avoid Town Center", "townCenter", 40.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 10.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("start resources avoid each other", rmClassID("startingResource"), 8.0);
	int avoidGoat = rmCreateTypeDistanceConstraint("goat avoid goat", "ypGoat", 60.0);

	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("avoid impassable land far", "Land", false, 10.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("avoid impassable land short", "Land", false, 3.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land", "land", true, 2.0);
	int avoidPatch = rmCreateClassDistanceConstraint("patch avoid patch", rmClassID("patch"), 10.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", rmClassID("classCliff"), 3.0);
	int avoidCliffShort = rmCreateClassDistanceConstraint("avoid cliff short", rmClassID("classCliff"), 5.0);
	int avoidHole = rmCreateClassDistanceConstraint("avoid hole", rmClassID("Hole"), 6.0+1*cNumberNonGaiaPlayers);
	
	
	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);
	int avoidPlayerArea =  rmCreateClassDistanceConstraint("avoid players area", rmClassID("Player"), 6.0-0.5*cNumberNonGaiaPlayers);
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 7.0);
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 5.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 12.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 10.0);
   	
	
	// ******************************************************************************************
	
	// ************************************* PLACE PLAYERS *************************************

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);


		if (cNumberTeams <= 2) // 1v1 and TEAM
		{
			if (teamZeroCount == 1 && teamOneCount == 1) // 1v1
			{
				float OneVOnePlacement=rmRandFloat(0.0, 0.9);
				if ( OneVOnePlacement < 0.5)
				{
					if (Layoutvariation == 0)
						rmPlacePlayer(1, 0.64, 0.16);
					else
						rmPlacePlayer(1, 0.60, 0.16);
					if (Layoutvariation == 0)
						rmPlacePlayer(2, 0.64, 0.84);
					else
						rmPlacePlayer(2, 0.60, 0.84);
				}
				else
				{
					if (Layoutvariation == 0)
						rmPlacePlayer(2, 0.64, 0.84);
					else
						rmPlacePlayer(2, 0.60, 0.84);
					if (Layoutvariation == 0)
						rmPlacePlayer(1, 0.64, 0.16);
					else
						rmPlacePlayer(1, 0.60, 0.16);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					if (Layoutvariation == 0)
						rmPlacePlayersLine(0.74, 0.22, 0.56, 0.16, 0.00, 0.25);
					else
						rmPlacePlayersLine(0.64, 0.18, 0.36, 0.18, 0.00, 0.25);

					rmSetPlacementTeam(1);
					if (Layoutvariation == 0)
						rmPlacePlayersLine(0.74, 0.78, 0.56, 0.84, 0.00, 0.25);
					else
						rmPlacePlayersLine(0.64, 0.82, 0.36, 0.82, 0.00, 0.25);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					if (Layoutvariation == 0)
						rmPlacePlayersLine(0.72, 0.22, 0.36, 0.16, 0.00, 0.25);
					else
						rmPlacePlayersLine(0.68, 0.18, 0.32, 0.18, 0.00, 0.25);

					rmSetPlacementTeam(1);
					if (Layoutvariation == 0)
						rmPlacePlayersLine(0.72, 0.78, 0.36, 0.84, 0.00, 0.25);
					else
						rmPlacePlayersLine(0.68, 0.82, 0.32, 0.82, 0.00, 0.25);
				}
			}
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						if (Layoutvariation == 0)
							rmPlacePlayersLine(0.63, 0.16, 0.64, 0.16, 0.00, 0.25);
						else
							rmPlacePlayersLine(0.63, 0.16, 0.64, 0.16, 0.00, 0.25);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
						{
							if (Layoutvariation == 0)
								rmPlacePlayersLine(0.74, 0.78, 0.56, 0.84, 0.00, 0.25);
							else
								rmPlacePlayersLine(0.62, 0.82, 0.36, 0.82, 0.00, 0.25);
						}
						else
						{
							if (Layoutvariation == 0)
								rmPlacePlayersLine(0.72, 0.78, 0.36, 0.84, 0.00, 0.25);
							else
								rmPlacePlayersLine(0.68, 0.82, 0.32, 0.82, 0.00, 0.25);
						}
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(1);
						if (Layoutvariation == 0)
							rmPlacePlayersLine(0.63, 0.84, 0.64, 0.84, 0.00, 0.25);
						else
							rmPlacePlayersLine(0.63, 0.84, 0.64, 0.84, 0.00, 0.25);

						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
						{
							if (Layoutvariation == 0)
								rmPlacePlayersLine(0.74, 0.22, 0.56, 0.16, 0.00, 0.25);
							else
								rmPlacePlayersLine(0.62, 0.18, 0.36, 0.18, 0.00, 0.25);
						}
						else
						{
							if (Layoutvariation == 0)
								rmPlacePlayersLine(0.72, 0.22, 0.36, 0.16, 0.00, 0.25);
							else
								rmPlacePlayersLine(0.68, 0.18, 0.32, 0.18, 0.00, 0.25);
						}
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						if (Layoutvariation == 0)
							rmPlacePlayersLine(0.74, 0.22, 0.56, 0.16, 0.00, 0.25);
						else
							rmPlacePlayersLine(0.64, 0.18, 0.36, 0.18, 0.00, 0.25);

						rmSetPlacementTeam(1);
						if (Layoutvariation == 0)
							rmPlacePlayersLine(0.72, 0.78, 0.36, 0.84, 0.00, 0.25);
						else
							rmPlacePlayersLine(0.68, 0.82, 0.32, 0.82, 0.00, 0.25);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						if (Layoutvariation == 0)
							rmPlacePlayersLine(0.72, 0.22, 0.36, 0.16, 0.00, 0.25);
						else
							rmPlacePlayersLine(0.68, 0.18, 0.32, 0.18, 0.00, 0.25);

						rmSetPlacementTeam(1);
						if (Layoutvariation == 0)
							rmPlacePlayersLine(0.74, 0.78, 0.56, 0.84, 0.00, 0.25);
						else
							rmPlacePlayersLine(0.64, 0.82, 0.36, 0.82, 0.00, 0.25);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					if (Layoutvariation == 0)
						rmPlacePlayersLine(0.72, 0.22, 0.36, 0.16, 0.00, 0.25);
					else
						rmPlacePlayersLine(0.68, 0.18, 0.32, 0.18, 0.00, 0.25);

					rmSetPlacementTeam(1);
					if (Layoutvariation == 0)
						rmPlacePlayersLine(0.72, 0.78, 0.36, 0.84, 0.00, 0.25);
					else
						rmPlacePlayersLine(0.68, 0.82, 0.32, 0.82, 0.00, 0.25);
				}
			}
		}
		else // FFA
		{
			rmSetTeamSpacingModifier(0.25);
			if (cNumberNonGaiaPlayers > 4)
				rmSetPlacementSection(0.350, 0.150);
			else if (cNumberNonGaiaPlayers == 4)
				rmSetPlacementSection(0.370, 0.130);
			else
				rmSetPlacementSection(0.375, 0.125);
			rmPlacePlayersCircular(0.41, 0.41, 0.0);
		}

	
	// *******************************************************************************************
   
	// Text
	rmSetStatusText("",0.30);
	
	// ***************************************** MAP LAYOUT *******************************************
	
	//Rivers
	if (season >= 0.5)
	{
		//river1
		int riverID1 = rmRiverCreate(-1, "Patagonia Water", 4, 6, 4+cNumberNonGaiaPlayers/2, 4+cNumberNonGaiaPlayers/2); //  (-1, "Patagonia Water", 4, 6, 5, 5)
		rmRiverAddWaypoint(riverID1, 1.0, 0.49); // 0.48
		rmRiverAddWaypoint(riverID1, 0.72, 0.49);
		rmRiverAddWaypoint(riverID1, 0.42, 0.3); // 0.3
		if (cNumberTeams <= 2)
		{	
			rmRiverAddWaypoint(riverID1, 0.15, 0.49);
			rmRiverAddWaypoint(riverID1, 0.0, 0.49);
		}
		else
		{	
			rmRiverAddWaypoint(riverID1, 0.20, 0.49);
		}
		
		//river2
		int riverID2 = rmRiverCreate(-1, "Patagonia Water", 4, 6, 4+cNumberNonGaiaPlayers/2, 4+cNumberNonGaiaPlayers/2); //  (-1, "Patagonia Water", 4, 6, 5, 5);
		rmRiverAddWaypoint(riverID2, 1.0, 0.51); // 0.52
		rmRiverAddWaypoint(riverID2, 0.72, 0.51);
		rmRiverAddWaypoint(riverID2, 0.42, 0.7); // 0.7
		if (cNumberTeams <= 2)
		{
			rmRiverAddWaypoint(riverID2, 0.15, 0.51);
			rmRiverAddWaypoint(riverID2, 0.0, 0.51);
		}
		else
		{	
			rmRiverAddWaypoint(riverID2, 0.20, 0.49);
		}
		
		
		//shallows
		rmRiverSetShallowRadius(riverID1, 8+cNumberNonGaiaPlayers/2);
		rmRiverSetShallowRadius(riverID2, 8+cNumberNonGaiaPlayers/2);
		if (cNumberTeams <= 2)
		{
			if (Layoutvariation == 0) 
			{
				rmRiverAddShallow(riverID1, 0.10);
				rmRiverAddShallow(riverID2, 0.10);
				rmRiverAddShallow(riverID1, 0.30); //30
				rmRiverAddShallow(riverID2, 0.30); //30		
				rmRiverAddShallow(riverID1, 0.55); //48
				rmRiverAddShallow(riverID2, 0.55); //49
				rmRiverAddShallow(riverID1, 0.84);
				rmRiverAddShallow(riverID2, 0.84);
			}
			else
			{
				rmRiverAddShallow(riverID1, 0.15);
				rmRiverAddShallow(riverID2, 0.15);
				rmRiverAddShallow(riverID1, 0.41); //30
				rmRiverAddShallow(riverID2, 0.41); //30		
				rmRiverAddShallow(riverID1, 0.69); //48
				rmRiverAddShallow(riverID2, 0.69); //49
				rmRiverAddShallow(riverID1, 0.92);
				rmRiverAddShallow(riverID2, 0.92);
			}
		}
		else
		{
			if (Layoutvariation == 0) 
			{
				rmRiverAddShallow(riverID1, 0.12);
				rmRiverAddShallow(riverID2, 0.12);
				rmRiverAddShallow(riverID1, 0.36);
				rmRiverAddShallow(riverID2, 0.36);
				rmRiverAddShallow(riverID1, 0.69); //48
				rmRiverAddShallow(riverID2, 0.69); //49
				rmRiverAddShallow(riverID1, 0.99);
				rmRiverAddShallow(riverID2, 0.99);
			}
			else
			{
				rmRiverAddShallow(riverID1, 0.15);
				rmRiverAddShallow(riverID2, 0.15);
				rmRiverAddShallow(riverID1, 0.48); //30
				rmRiverAddShallow(riverID2, 0.48); //30		
				rmRiverAddShallow(riverID1, 0.84); //48
				rmRiverAddShallow(riverID2, 0.84); //49
			}
		}
		rmRiverBuild(riverID1);
		rmRiverBuild(riverID2);
	}
	else
	{
		int frozenriver1ID = rmCreateArea("frozen river1");
		rmSetAreaLocation(frozenriver1ID, 1.00, 0.49);
		rmAddAreaInfluenceSegment(frozenriver1ID, 1.00, 0.49, 0.70, 0.49);
		rmAddAreaInfluenceSegment(frozenriver1ID, 0.70, 0.49, 0.40, 0.30);
		if (cNumberTeams <= 2)
		{
			rmAddAreaInfluenceSegment(frozenriver1ID, 0.40, 0.30, 0.15, 0.49); 
			rmAddAreaInfluenceSegment(frozenriver1ID, 0.15, 0.49, 0.00, 0.49);
		}
		else
			rmAddAreaInfluenceSegment(frozenriver1ID, 0.40, 0.30, 0.20, 0.49); 
		rmSetAreaSize(frozenriver1ID, 0.065, 0.065);
		rmSetAreaMix(frozenriver1ID, "great_lakes_ice");
		rmSetAreaBaseHeight(frozenriver1ID, 1.5); 
		rmSetAreaElevationVariation(frozenriver1ID, 0.0);
//		rmSetAreaTerrainType(frozenriver1ID, "great_lakes\ground_ice1_gl");
		rmSetAreaCoherence(frozenriver1ID, 0.8); 
		rmSetAreaSmoothDistance(frozenriver1ID, 8);
		rmSetAreaObeyWorldCircleConstraint(frozenriver1ID, false);
		rmBuildArea(frozenriver1ID); 
		
		int frozenriver2ID = rmCreateArea("frozen river2");
		rmSetAreaLocation(frozenriver2ID, 1.00, 0.51);
		rmAddAreaInfluenceSegment(frozenriver2ID, 1.00, 0.51, 0.70, 0.51);
		rmAddAreaInfluenceSegment(frozenriver2ID, 0.70, 0.51, 0.40, 0.70);
		if (cNumberTeams <= 2)
		{
			rmAddAreaInfluenceSegment(frozenriver2ID, 0.40, 0.70, 0.15, 0.51);
			rmAddAreaInfluenceSegment(frozenriver2ID, 0.15, 0.51, 0.00, 0.51);
		}	
		else
			rmAddAreaInfluenceSegment(frozenriver2ID, 0.40, 0.70, 0.20, 0.51);
		rmSetAreaSize(frozenriver2ID, 0.065, 0.065);
		rmSetAreaMix(frozenriver2ID, "great_lakes_ice");
		rmSetAreaBaseHeight(frozenriver2ID, 1.5); 
		rmSetAreaElevationVariation(frozenriver2ID, 0.0);
//		rmSetAreaTerrainType(frozenriver2ID, "great_lakes\ground_ice1_gl");
		rmSetAreaCoherence(frozenriver2ID, 0.8); 
		rmSetAreaSmoothDistance(frozenriver2ID, 8);
		rmSetAreaObeyWorldCircleConstraint(frozenriver2ID, false);
		rmBuildArea(frozenriver2ID); 
		
		int avoidFrozenRiver1 = rmCreateAreaDistanceConstraint("avoid frozen river 1", frozenriver1ID, 8);
		int avoidFrozenRiver2 = rmCreateAreaDistanceConstraint("avoid frozen river 2", frozenriver2ID, 8);
		int avoidFrozenRiver1Short = rmCreateAreaDistanceConstraint("avoid frozen river 1 short", frozenriver1ID, 3);
		int avoidFrozenRiver2Short = rmCreateAreaDistanceConstraint("avoid frozen river 2 short", frozenriver2ID, 3);
		int stayNearRiver1 = rmCreateAreaMaxDistanceConstraint("stay near frozen river 1", frozenriver1ID, 5);
		int stayNearRiver2 = rmCreateAreaMaxDistanceConstraint("stay near frozen river 2", frozenriver2ID, 5);
		int stayInRiver1 = rmCreateAreaMaxDistanceConstraint("stay in frozen river 1", frozenriver1ID, 0);
		int stayInRiver2 = rmCreateAreaMaxDistanceConstraint("stay in frozen river 2", frozenriver2ID, 0);
		
		//trade route passes
		int traderoutepass1ID = rmCreateArea("trade route pass 1");
		if (Layoutvariation == 0)
		{
			if (cNumberNonGaiaPlayers < 4)
			{
				rmSetAreaLocation(traderoutepass1ID, 0.40, 0.30);
				rmAddAreaInfluenceSegment(traderoutepass1ID, 0.40, 0.26, 0.40, 0.34);
			}
			else
			{
				rmSetAreaLocation(traderoutepass1ID, 0.43, 0.30);
				rmAddAreaInfluenceSegment(traderoutepass1ID, 0.45, 0.26, 0.41, 0.34);
			}
		}
		else
		{
			rmSetAreaLocation(traderoutepass1ID, 0.55, 0.39);
			rmAddAreaInfluenceSegment(traderoutepass1ID, 0.57, 0.37, 0.53, 0.41);
		}
		rmSetAreaSize(traderoutepass1ID, 0.01, 0.01);
		rmSetAreaCoherence(traderoutepass1ID, 1.0); 
		rmSetAreaBaseHeight(traderoutepass1ID, 3.0); 
		rmSetAreaMix(traderoutepass1ID, "araucania_snow_b");
		rmBuildArea(traderoutepass1ID); 
		
		int traderoutepass2ID = rmCreateArea("trade route pass 2");
		if (Layoutvariation == 0)
		{
			if (cNumberNonGaiaPlayers < 4)
			{
				rmSetAreaLocation(traderoutepass2ID, 0.40, 0.70);
				rmAddAreaInfluenceSegment(traderoutepass2ID, 0.40, 0.66, 0.40, 0.74);
			}
			else
			{
				rmSetAreaLocation(traderoutepass2ID, 0.43, 0.70);
				rmAddAreaInfluenceSegment(traderoutepass2ID, 0.41, 0.66, 0.45, 0.74);
			}
		}
		else
		{
			rmSetAreaLocation(traderoutepass2ID, 0.56, 0.60);
			rmAddAreaInfluenceSegment(traderoutepass2ID, 0.58, 0.62, 0.54, 0.58);
		}
		rmSetAreaSize(traderoutepass2ID, 0.01, 0.01);
		rmSetAreaCoherence(traderoutepass2ID, 1.0); 
		rmSetAreaBaseHeight(traderoutepass2ID, 3.0); 
		rmSetAreaMix(traderoutepass2ID, "araucania_snow_b");
		rmBuildArea(traderoutepass2ID); 
		
		int avoidTraderoutepass1 = rmCreateAreaDistanceConstraint("avoid trade route pass 1", traderoutepass1ID, 8);
		int avoidTraderoutepass2 = rmCreateAreaDistanceConstraint("avoid trade route pass 2", traderoutepass2ID, 8);
		
		
		int traderoutepass3ID = rmCreateArea("trade route pass 3");
		rmSetAreaSize(traderoutepass3ID, 0.01, 0.01);
		rmSetAreaLocation(traderoutepass3ID, 0.29, 0.63);
		rmAddAreaInfluenceSegment(traderoutepass3ID, 0.27, 0.65, 0.31, 0.61);
		rmSetAreaSize(traderoutepass3ID, 0.01, 0.01);
		rmSetAreaCoherence(traderoutepass3ID, 1.0); 
		rmSetAreaBaseHeight(traderoutepass3ID, 3.0); 
		rmSetAreaMix(traderoutepass3ID, "araucania_snow_b");
			
		int traderoutepass4ID = rmCreateArea("trade route pass 4");
		rmSetAreaSize(traderoutepass4ID, 0.01, 0.01);
		rmSetAreaLocation(traderoutepass4ID, 0.31, 0.37);
		rmAddAreaInfluenceSegment(traderoutepass4ID, 0.33, 0.39, 0.29, 0.35);
		rmSetAreaCoherence(traderoutepass4ID, 1.0); 
		rmSetAreaBaseHeight(traderoutepass4ID, 3.0); 
		rmSetAreaMix(traderoutepass4ID, "araucania_snow_b");
			
		if (Layoutvariation == 1)
		{
		rmBuildArea(traderoutepass3ID); 
		rmBuildArea(traderoutepass4ID); 
		}	
		
		int avoidTraderoutepass3 = rmCreateAreaDistanceConstraint("avoid trade route pass 3", traderoutepass3ID, 8);
		int avoidTraderoutepass4 = rmCreateAreaDistanceConstraint("avoid trade route pass 4", traderoutepass4ID, 8);
				
				
		//ice patches to fix river
		int icepatch1ID = rmCreateArea("ice patch 1");
		rmSetAreaLocation(icepatch1ID, 1.00, 0.50);
		rmSetAreaSize(icepatch1ID, 0.004, 0.004);
		rmSetAreaCoherence(icepatch1ID, 1.0); 
		rmSetAreaBaseHeight(icepatch1ID, 1.5); 
		rmSetAreaMix(icepatch1ID, "great_lakes_ice");
		rmSetAreaObeyWorldCircleConstraint(icepatch1ID, false);
		rmBuildArea(icepatch1ID); 
		
		int icepatch2ID = rmCreateArea("ice patch 2");
		rmSetAreaLocation(icepatch2ID, 0.00, 0.50);
		rmSetAreaSize(icepatch2ID, 0.004, 0.004);
		rmSetAreaCoherence(icepatch2ID, 1.0); 
		rmSetAreaBaseHeight(icepatch2ID, 1.5); 
		rmSetAreaMix(icepatch2ID, "great_lakes_ice");
		rmSetAreaObeyWorldCircleConstraint(icepatch2ID, false);
		if (cNumberTeams <= 2)
			rmBuildArea(icepatch2ID); 
		
		int holecount = rmRandInt(2,3)*cNumberNonGaiaPlayers;
		if (cNumberNonGaiaPlayers >= 4) 
			holecount = 2*cNumberNonGaiaPlayers;
			
		for(i=0; < holecount)	
		{
			int iceholeID = rmCreateArea("ice hole"+i);
			rmSetAreaWaterType(iceholeID, "great lakes ice"); 
			rmSetAreaSize(iceholeID, rmAreaTilesToFraction(72), rmAreaTilesToFraction(78)); // 0.0026, 0.0032
			rmAddAreaToClass(iceholeID, rmClassID("Hole"));
			rmSetAreaBaseHeight(iceholeID, 1.5); 
			rmSetAreaCoherence(iceholeID, 0.2); 
			rmSetAreaSmoothDistance(iceholeID, 0.5);
			if (i < (3*cNumberNonGaiaPlayers/2))
				rmAddAreaConstraint(iceholeID, stayInRiver1);
			else
				rmAddAreaConstraint(iceholeID, stayInRiver2);
			rmAddAreaConstraint(iceholeID, avoidTraderoutepass1);
			rmAddAreaConstraint(iceholeID, avoidTraderoutepass2);
			rmAddAreaConstraint(iceholeID, avoidTraderoutepass3);
			rmAddAreaConstraint(iceholeID, avoidTraderoutepass4);
			rmAddAreaConstraint(iceholeID, avoidHole);
			rmSetAreaWarnFailure(iceholeID, false);
			rmBuildArea(iceholeID); 
		}

	}
	
	// Cliffs
	
	int cliffcount = 4;
	if (cNumberTeams > 2)
		cliffcount = 0;
	
	for (i = 0;  < cliffcount)
	{
		int CliffID = rmCreateArea("cliff"+i);
		rmSetAreaSize(CliffID, 0.0045, 0.0046);
		rmSetAreaWarnFailure(CliffID, false);
		rmSetAreaObeyWorldCircleConstraint(CliffID, false);
		rmSetAreaCoherence(CliffID, 0.5);
		rmSetAreaSmoothDistance(CliffID, 4);
		if (season >= 0.5)
			rmSetAreaCliffType(CliffID, "patagonia"); 
		else
			rmSetAreaCliffType(CliffID, "rocky mountain2"); 
		rmSetAreaCliffEdge(CliffID, 1, 1.0, 0.0, 0.0, 0);
		rmSetAreaCliffHeight(CliffID, 5, 0.0, 1.0);
		rmSetAreaCliffPainting(CliffID, false, false, true);
		rmAddAreaToClass(CliffID, rmClassID("classCliff"));
		rmAddAreaConstraint(CliffID, avoidImpassableLand);
		if (Layoutvariation == 0)
		{
			if (i == 0)
			{
				if (cNumberNonGaiaPlayers < 4)
					rmSetAreaLocation(CliffID, 0.80, 0.32);
				else
					rmSetAreaLocation(CliffID, 0.85, 0.32);
			}
			else if (i == 1)
			{
				if (cNumberNonGaiaPlayers < 4)
					rmSetAreaLocation(CliffID, 0.80, 0.68);
				else
					rmSetAreaLocation(CliffID, 0.85, 0.68);
			}
			else if (i == 2)
				rmSetAreaLocation(CliffID, 0.22, 0.24);
			else
				rmSetAreaLocation(CliffID, 0.22, 0.76);
			rmBuildArea(CliffID);
		}
		else
		{
			if (i < cliffcount/2)
			{
				if (i == 0)
					rmSetAreaLocation(CliffID, 0.42, 0.035);
				else if (i == 1)
					rmSetAreaLocation(CliffID, 0.42, 0.965);
				rmBuildArea(CliffID);
			}
		}
		
	}
	
	// Players area
	for (i=1; < cNumberPlayers)
	{
	int playerareaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerareaID);
	rmAddAreaToClass(playerareaID, rmClassID("Player"));
	rmSetAreaSize(playerareaID, (0.084-0.0082*cNumberNonGaiaPlayers), (0.084-0.0082*cNumberNonGaiaPlayers));
	rmSetAreaCoherence(playerareaID, 1.0);
	rmSetAreaWarnFailure(playerareaID, false);
//	rmSetAreaMix(playerareaID, "araucania_snow_a");
	rmSetAreaLocPlayer(playerareaID, i);
	rmBuildArea(playerareaID);
	}


	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.5;
		float yLoc = 0.5;
		float walk = 0.03;

		if (randLoc == 2 && cNumberTeams <= 2) {
			xLoc = 0.3;
			yLoc = 0.5;
		}

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}
	
	// ****************************************** TRADE ROUTE **********************************************
	
	if (Layoutvariation == 0)
	{
		int tradeRouteID = rmCreateTradeRoute();
		if (cNumberTeams <= 2)
		{
			rmAddTradeRouteWaypoint(tradeRouteID, 0.52, 0.00); //
			rmAddTradeRouteWaypoint(tradeRouteID, 0.45, 0.11); // 
		}
		else
			rmAddTradeRouteWaypoint(tradeRouteID, 0.43, 0.15); // 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.43, 0.20); //0.54, 0.20
		rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 0.50); //0.45, 0.50
		rmAddTradeRouteWaypoint(tradeRouteID, 0.43, 0.80); 
		if (cNumberTeams <= 2)
		{
			rmAddTradeRouteWaypoint(tradeRouteID, 0.45, 0.89); // 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.52, 1.00); // 
		}	
		else
			rmAddTradeRouteWaypoint(tradeRouteID, 0.43, 0.85); // 
		
		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
		rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socketID, true);
		rmSetObjectDefMinDistance(socketID, 0.0);
		rmSetObjectDefMaxDistance(socketID, 8.0);
		rmAddObjectDefConstraint(socketID, avoidPlayerArea);
	
		
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		bool placedTradeRouteA = rmBuildTradeRoute(tradeRouteID, "water");
		vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.10);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		if (cNumberNonGaiaPlayers < 6)
		{
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.41);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.57);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
		else
		{
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.41);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.57);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.90);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else
	{
		int tradeRoute2ID = rmCreateTradeRoute();
		if (cNumberTeams <= 2)
			rmAddTradeRouteWaypoint(tradeRoute2ID, 1.00, 0.10); //
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.80, 0.20); //
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.54, 0.42); //
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.54, 0.58); //
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.80, 0.80); // 
		if (cNumberTeams <= 2)
			rmAddTradeRouteWaypoint(tradeRoute2ID, 1.00, 0.90); // 
			
		int socket2ID=rmCreateObjectDef("sockets to dock Trade Posts 2");
		rmAddObjectDefItem(socket2ID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socket2ID, true);
		rmSetObjectDefMinDistance(socket2ID, 0.0);
		rmSetObjectDefMaxDistance(socket2ID, 8.0);
		rmAddObjectDefConstraint(socket2ID, avoidPlayerArea);
		
		rmSetObjectDefTradeRouteID(socket2ID, tradeRoute2ID);
		bool placedTradeRouteB = rmBuildTradeRoute(tradeRoute2ID, "water");
		vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.22);
		rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);
		if (cNumberNonGaiaPlayers >= 6)
		{
			socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.50);
			rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);
		}
		socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.78);
		rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);
		
		
		int tradeRoute3ID = rmCreateTradeRoute();
		if (cNumberTeams <= 2)
			rmAddTradeRouteWaypoint(tradeRoute3ID, 0.00, 0.00); //
		rmAddTradeRouteWaypoint(tradeRoute3ID, 0.20, 0.20); //
		rmAddTradeRouteWaypoint(tradeRoute3ID, 0.34, 0.42); //
		rmAddTradeRouteWaypoint(tradeRoute3ID, 0.34, 0.58); //
		rmAddTradeRouteWaypoint(tradeRoute3ID, 0.20, 0.80); // 
		if (cNumberTeams <= 2)
			rmAddTradeRouteWaypoint(tradeRoute3ID, 0.00, 1.00); // 
			
		int socket3ID=rmCreateObjectDef("sockets to dock Trade Posts 3");
		rmAddObjectDefItem(socket3ID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socket3ID, true);
		rmSetObjectDefMinDistance(socket3ID, 0.0);
		rmSetObjectDefMaxDistance(socket3ID, 8.0);
		rmAddObjectDefConstraint(socket3ID, avoidPlayerArea);
		
		rmSetObjectDefTradeRouteID(socket3ID, tradeRoute3ID);
		bool placedTradeRouteC = rmBuildTradeRoute(tradeRoute3ID, "water");
		vector socketLoc3 = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.25);
		rmPlaceObjectDefAtPoint(socket3ID, 0, socketLoc3);
		if (cNumberNonGaiaPlayers >= 6)
		{
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.50);
			rmPlaceObjectDefAtPoint(socket3ID, 0, socketLoc3);
		}
		socketLoc3 = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.75);
		rmPlaceObjectDefAtPoint(socket3ID, 0, socketLoc3);
	}

	
	// ******************************************************************************************************
	
	// Text
	rmSetStatusText("",0.50);
	
	// ************************************ PLAYER STARTING RESOURCES ***************************************

	// ***** Define *****
	
	// Town center & units
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 10.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);

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
	rmSetObjectDefMaxDistance(playergoldID, 20.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidGoldTypeFar);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
		
	// Starting herd
	int playerbighornID = rmCreateObjectDef("starting bighorn sheep");
	rmAddObjectDefItem(playerbighornID, "Seal", 3, 2.0);
	rmSetObjectDefMinDistance(playerbighornID, 12.0);
	rmSetObjectDefMaxDistance(playerbighornID, 16.0);
	rmSetObjectDefCreateHerd(playerbighornID, false);
	rmAddObjectDefToClass(playerbighornID, classStartingResource);
	rmAddObjectDefConstraint(playerbighornID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerbighornID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerbighornID, avoidNatives);
	rmAddObjectDefConstraint(playerbighornID, avoidStartingResources);
	
	// Closest tree
	int playercloseTreeID = rmCreateObjectDef("player tree close");
	if (season >= 0.5)
		rmAddObjectDefItem(playercloseTreeID, "TreeNorthwestTerritory", rmRandInt(4,4), 4.0);
	else
		rmAddObjectDefItem(playercloseTreeID, "TreeGreatLakesSnow", rmRandInt(4,4), 4.0);
    rmSetObjectDefMinDistance(playercloseTreeID, 14);
    rmSetObjectDefMaxDistance(playercloseTreeID, 15);
	rmAddObjectDefToClass(playercloseTreeID, classStartingResource);
	rmAddObjectDefToClass(playercloseTreeID, classForest);
	rmAddObjectDefConstraint(playercloseTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playercloseTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playercloseTreeID, avoidStartingResources);
	
	
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	if (season >= 0.5)
		rmAddObjectDefItem(playerTreeID, "TreeNorthwestTerritory", rmRandInt(12,15), 9.0);
	else
		rmAddObjectDefItem(playerTreeID, "TreeGreatLakesSnow", rmRandInt(12,15), 9.0);
    rmSetObjectDefMinDistance(playerTreeID, 24);
    rmSetObjectDefMaxDistance(playerTreeID, 26);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForest);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	
	// 2nd herd
	int playerCaribouID = rmCreateObjectDef("player caribou");
	if (season >= 0.5)
		rmAddObjectDefItem(playerCaribouID, "caribou", rmRandInt(7,7), 6.0);
	else
		rmAddObjectDefItem(playerCaribouID, "Seal", rmRandInt(7,7), 6.0);
    rmSetObjectDefMinDistance(playerCaribouID, 24);
    rmSetObjectDefMaxDistance(playerCaribouID, 26);
	rmAddObjectDefToClass(playerCaribouID, classStartingResource);
	rmSetObjectDefCreateHerd(playerCaribouID, true);
	rmAddObjectDefConstraint(playerCaribouID, avoidCaribou); //Short
	rmAddObjectDefConstraint(playerCaribouID, avoidMuskdeer);
	rmAddObjectDefConstraint(playerCaribouID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerCaribouID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerCaribouID, avoidStartingResources);
	if (season < 0.5)
	{
		rmAddObjectDefConstraint(playerCaribouID, avoidFrozenRiver1);
		rmAddObjectDefConstraint(playerCaribouID, avoidFrozenRiver2);
	}
	
	// 3rd herd
	int CaribouID5= rmCreateObjectDef("caribou 3rd");
    if (season >= 0.5)
		rmAddObjectDefItem(CaribouID5, "caribou", rmRandInt(7,7), 6.0);
	else
		rmAddObjectDefItem(CaribouID5, "Seal", rmRandInt(7,7), 6.0);
	rmSetObjectDefMinDistance(CaribouID5, 42);
    rmSetObjectDefMaxDistance(CaribouID5, 44);
	rmSetObjectDefCreateHerd(CaribouID5, true);
	rmAddObjectDefConstraint(CaribouID5, avoidCaribou); //Short
	rmAddObjectDefConstraint(CaribouID5, avoidMuskdeer);
//	rmAddObjectDefConstraint(CaribouID5, avoidTradeRouteShort);
	rmAddObjectDefConstraint(CaribouID5, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(CaribouID5, avoidImpassableLandShort);
	rmAddObjectDefConstraint(CaribouID5, avoidCliff);
	rmAddObjectDefConstraint(CaribouID5, avoidStartingResources);
//	rmAddObjectDefConstraint(CaribouID5, avoidTownCenterResources);
//	rmAddObjectDefConstraint(CaribouID5, avoidForestMin);
	if (season < 0.5)
	{
		rmAddObjectDefConstraint(CaribouID5, avoidFrozenRiver1);
		rmAddObjectDefConstraint(CaribouID5, avoidFrozenRiver2);
	}
	
	// 4th herd
	int CaribouID6= rmCreateObjectDef("caribou 4th");
    if (season >= 0.5)
		rmAddObjectDefItem(CaribouID6, "caribou", rmRandInt(7,7), 6.0);
	else
		rmAddObjectDefItem(CaribouID6, "Seal", rmRandInt(7,7), 6.0);
	rmSetObjectDefMinDistance(CaribouID6, 43);
    rmSetObjectDefMaxDistance(CaribouID6, 45);
	rmSetObjectDefCreateHerd(CaribouID6, true);
	rmAddObjectDefConstraint(CaribouID6, avoidCaribou); //Short
	rmAddObjectDefConstraint(CaribouID6, avoidMuskdeer);
//	rmAddObjectDefConstraint(CaribouID6, avoidTradeRouteShort);
	rmAddObjectDefConstraint(CaribouID6, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(CaribouID6, avoidImpassableLandShort);
	rmAddObjectDefConstraint(CaribouID6, avoidCliff);
	rmAddObjectDefConstraint(CaribouID6, avoidStartingResources);
//	rmAddObjectDefConstraint(CaribouID6, avoidTownCenterResources);
//	rmAddObjectDefConstraint(CaribouID6, avoidForestMin);
	if (season < 0.5)
	{
		rmAddObjectDefConstraint(CaribouID6, avoidFrozenRiver1);
		rmAddObjectDefConstraint(CaribouID6, avoidFrozenRiver2);
	}
	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 22.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 26.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	if (season < 0.5)
	{
		rmAddObjectDefConstraint(playerNuggetID, avoidFrozenRiver1);
		rmAddObjectDefConstraint(playerNuggetID, avoidFrozenRiver2);
	}
	int nugget0count = rmRandInt (1,2);
		
	// ***** Place *****
	
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playercloseTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerbighornID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerbighornID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerCaribouID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(CaribouID5, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(CaribouID6, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		
		if(ypIsAsian(i) && rmGetNomadStart() == false)
		rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}
	
	// ************************************************************************************************
	
	// Text
	rmSetStatusText("",0.60);
	
	// ************************************** COMMON RESOURCES ****************************************
   
   
	// ******** MINES *********
		
	int extragoldCount = 4*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 4)
		extragoldCount = 4*cNumberNonGaiaPlayers-cNumberNonGaiaPlayers/2;
	
	
	//Extra mines
	for(i=0; < extragoldCount)
	{
		int extragoldID = rmCreateObjectDef("extra gold"+i);
		rmAddObjectDefItem(extragoldID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(extragoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(extragoldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(extragoldID, classGold);
//		rmAddObjectDefConstraint(extragoldID, Southwestconstraint);
		rmAddObjectDefConstraint(extragoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(extragoldID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(extragoldID, avoidImpassableLand);
		rmAddObjectDefConstraint(extragoldID, avoidCliff);
		rmAddObjectDefConstraint(extragoldID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(extragoldID, avoidEdge);
//		rmAddObjectDefConstraint(extragoldID, avoidCenter);
		rmAddObjectDefConstraint(extragoldID, avoidGoldFar);
		if (season < 0.5)
		{
			rmAddObjectDefConstraint(extragoldID, avoidFrozenRiver1);
			rmAddObjectDefConstraint(extragoldID, avoidFrozenRiver2);
		}
		rmPlaceObjectDefAtLoc(extragoldID, 0, 0.50, 0.50);	
	}
	
	// ***********************
	
	// Text
	rmSetStatusText("",0.70);
	
   	// ******** FORESTS ********
	int mainforestcount = 8*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 4)
		mainforestcount = 5*cNumberNonGaiaPlayers;
	
	// Main forest
	int stayInMainForest = -1;
	
	for (i=0; < mainforestcount)
	{
		int mainforestID = rmCreateArea("main forest"+i);
		rmSetAreaSize(mainforestID, rmAreaTilesToFraction(70), rmAreaTilesToFraction(80)); // 65   80
		rmSetAreaWarnFailure(mainforestID, false);
		rmSetAreaObeyWorldCircleConstraint(mainforestID, true);
		if (season >= 0.5)
			rmSetAreaTerrainType(mainforestID, "patagonia\groundforest_pat");
		else
			rmSetAreaTerrainType(mainforestID, "araucania\ground_snow8_ara");
		rmSetAreaMinBlobs(mainforestID, 2);
		rmSetAreaMaxBlobs(mainforestID, 3);
		rmSetAreaMinBlobDistance(mainforestID, 10.0);
		rmSetAreaMaxBlobDistance(mainforestID, 28.0);
		rmSetAreaCoherence(mainforestID, 0.0);
		rmSetAreaSmoothDistance(mainforestID, 5);
		rmAddAreaToClass(mainforestID, classForest);
		rmAddAreaConstraint(mainforestID, avoidTradeRouteShort);
		rmAddAreaConstraint(mainforestID, avoidImpassableLandShort);
		rmAddAreaConstraint(mainforestID, avoidCliffShort);
//		rmAddAreaConstraint(mainforestID, avoidStartingResources);
		rmAddAreaConstraint(mainforestID, avoidCaribouMin);
		rmAddAreaConstraint(mainforestID, avoidMuskdeerMin);
		rmAddAreaConstraint(mainforestID, avoidGoldTypeShort);
		rmAddAreaConstraint(mainforestID, avoidTownCenterShort);
		rmAddAreaConstraint(mainforestID, avoidForest);
		if (season < 0.5)
		{
			rmAddAreaConstraint(mainforestID, avoidFrozenRiver1Short);
			rmAddAreaConstraint(mainforestID, avoidFrozenRiver2Short);
		}
		
		rmBuildArea(mainforestID);
		
		stayInMainForest = rmCreateAreaMaxDistanceConstraint("stay in main forest"+i, mainforestID, 0);
		
		for (j=0; < rmRandInt(11,12)) //14
		{
			int maintreeID = rmCreateObjectDef("main trees"+i+" "+j);
			if (season >= 0.5)
			{
				rmAddObjectDefItem(maintreeID, "TreeNorthwestTerritory", rmRandInt(1,1), 2.0); //9,10
				rmAddObjectDefItem(maintreeID, "TreeNorthwestTerritory", rmRandInt(0,1), 2.0); //9,10
			}
			else
			{
				rmAddObjectDefItem(maintreeID, "TreeGreatLakesSnow", rmRandInt(1,1), 3.0); //9,10
				rmAddObjectDefItem(maintreeID, "TreeGreatLakesSnow", rmRandInt(0,1), 3.0); //9,10
			}
			rmSetObjectDefMinDistance(maintreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(maintreeID,  rmXFractionToMeters(0.5));
//			rmAddObjectDefToClass(maintreeID, classForest);
			rmAddObjectDefConstraint(maintreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(maintreeID, avoidTradeRouteSocket);
			rmAddObjectDefConstraint(maintreeID, avoidCaribouMin);
			rmAddObjectDefConstraint(maintreeID, avoidMuskdeerMin);
			rmAddObjectDefConstraint(maintreeID, stayInMainForest);	
			rmPlaceObjectDefAtLoc(maintreeID, 0, 0.50, 0.50);
		}
		
	}
	
	// Random tree clumps
	
	int randomforestcount = 6*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 4)
		randomforestcount = 4*cNumberNonGaiaPlayers;
		
	
	for (i=0; < randomforestcount)
	{	
		int RandomtreeID = rmCreateObjectDef("random trees"+i);
		if (season >= 0.5)
			rmAddObjectDefItem(RandomtreeID, "TreeNorthwestTerritory", rmRandInt(4,6), 6.0); // 4,5
		else
			rmAddObjectDefItem(RandomtreeID, "TreeGreatLakesSnow", rmRandInt(4,6), 6.0); // 4,5	
		rmSetObjectDefMinDistance(RandomtreeID, rmXFractionToMeters(0));
		rmSetObjectDefMaxDistance(RandomtreeID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(RandomtreeID, classForest);
		rmAddObjectDefConstraint(RandomtreeID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(RandomtreeID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidCliff);
		rmAddObjectDefConstraint(RandomtreeID, avoidStartingResources);
		rmAddObjectDefConstraint(RandomtreeID, avoidCaribouMin);
		rmAddObjectDefConstraint(RandomtreeID, avoidMuskdeerMin);
		rmAddObjectDefConstraint(RandomtreeID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidForestShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidTownCenterMed);
		if (season < 0.5)
		{
			rmAddObjectDefConstraint(RandomtreeID, avoidFrozenRiver1);
			rmAddObjectDefConstraint(RandomtreeID, avoidFrozenRiver2);
		}
		rmPlaceObjectDefAtLoc(RandomtreeID, 0, 0.5, 0.5);
	}

	// ************************
	
	// Text
	rmSetStatusText("",0.80);
	
	// ******** HUNTS *********
	
	// Caribou herds
	int cariboucount = 3*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 4)
		cariboucount = 3*cNumberNonGaiaPlayers-cNumberNonGaiaPlayers/2;
	
	for (i=1; < cariboucount+1)
	{
		int CaribouID = rmCreateObjectDef("caribou herd"+i);
		if (season >= 0.5)
			rmAddObjectDefItem(CaribouID, "caribou", rmRandInt(7,8), 7.0);
		else
			rmAddObjectDefItem(CaribouID, "Seal", rmRandInt(7,8), 7.0);
		rmSetObjectDefMinDistance(CaribouID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(CaribouID,  rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(CaribouID, true);
		rmAddObjectDefConstraint(CaribouID, avoidCaribouFar);
		rmAddObjectDefConstraint(CaribouID, avoidMuskdeerFar);
	//	rmAddObjectDefConstraint(CaribouID, avoidTradeRoute);
		rmAddObjectDefConstraint(CaribouID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(CaribouID, avoidImpassableLand);
		rmAddObjectDefConstraint(CaribouID, avoidCliff);
		rmAddObjectDefConstraint(CaribouID, avoidStartingResources);
		rmAddObjectDefConstraint(CaribouID, avoidGoldMin);
		rmAddObjectDefConstraint(CaribouID, avoidTownCenterFar);
		rmAddObjectDefConstraint(CaribouID, avoidForestMin);
		rmAddObjectDefConstraint(CaribouID, avoidCenter);
		if (season < 0.5)
		{
			rmAddObjectDefConstraint(CaribouID, avoidFrozenRiver1);
			rmAddObjectDefConstraint(CaribouID, avoidFrozenRiver2);
		}
		if (i%2 == 1.00)
			rmAddObjectDefConstraint(CaribouID, Northwestconstraint);
		else
			rmAddObjectDefConstraint(CaribouID, Southeastconstraint);
		rmPlaceObjectDefAtLoc(CaribouID, 0, 0.5, 0.5);
	}
	
	// Elk herd
	int elkcount = 1*cNumberNonGaiaPlayers; 
	
	int elkID = rmCreateObjectDef("elk herd");
	if (season >= 0.5)
		rmAddObjectDefItem(elkID, "elk", rmRandInt(7,8), 8.0); // 10,12
	else
		 rmAddObjectDefItem(elkID, "ypibex", rmRandInt(8,9), 8.0); // 10,12
	rmSetObjectDefMinDistance(elkID,  10);
	rmSetObjectDefMaxDistance(elkID,  rmXFractionToMeters(0.5));
	rmSetObjectDefCreateHerd(elkID, true);
	rmAddObjectDefConstraint(elkID, avoidCaribou); 
	rmAddObjectDefConstraint(elkID, avoidElk);
	rmAddObjectDefConstraint(elkID, avoidIbex);
	rmAddObjectDefConstraint(elkID, avoidMuskdeer);
	rmAddObjectDefConstraint(elkID, stayCenter);
	rmAddObjectDefConstraint(elkID, avoidTradeRouteSocket);
    rmAddObjectDefConstraint(elkID, avoidImpassableLand);
	rmAddObjectDefConstraint(elkID, avoidStartingResources);
//	rmAddObjectDefConstraint(elkID, avoidGoldMin);
	rmAddObjectDefConstraint(elkID, avoidGoldTypeShort);
	rmAddObjectDefConstraint(elkID, avoidTownCenterFar);
	rmAddObjectDefConstraint(elkID, avoidForestMin);
	if (season < 0.5)
	{
		rmAddObjectDefConstraint(elkID, avoidFrozenRiver1);
		rmAddObjectDefConstraint(elkID, avoidFrozenRiver2);
	}

	for (i=0; < elkcount)
	{
		rmPlaceObjectDefAtLoc(elkID, 0, 0.5, 0.5);
	}
	
	// ****************************
	
	// River trees
	if (season < 0.5)
	{
		for (i=0; < 8*cNumberNonGaiaPlayers)
		{
			int RivertreeID = rmCreateObjectDef("river trees"+i);
			rmAddObjectDefItem(RivertreeID, "TreeGreatLakesSnow", rmRandInt(1,2), 3.0); // 1,3	
			rmSetObjectDefMinDistance(RivertreeID, 0);
			rmSetObjectDefMaxDistance(RivertreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(RivertreeID, classForest);
			rmAddObjectDefConstraint(RivertreeID, avoidTradeRouteShort);
			rmAddObjectDefConstraint(RivertreeID, avoidTradeRouteSocket);
			rmAddObjectDefConstraint(RivertreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(RivertreeID, avoidCliff);
			rmAddObjectDefConstraint(RivertreeID, avoidStartingResources);
			rmAddObjectDefConstraint(RivertreeID, avoidGoldTypeShort);
			rmAddObjectDefConstraint(RivertreeID, avoidForestMin);
			rmAddObjectDefConstraint(RivertreeID, avoidFrozenRiver1Short);
			rmAddObjectDefConstraint(RivertreeID, avoidFrozenRiver2Short);
			if (i < 8*cNumberNonGaiaPlayers/2)
				rmAddObjectDefConstraint(RivertreeID, stayNearRiver1);
			else
				rmAddObjectDefConstraint(RivertreeID, stayNearRiver2);
			rmPlaceObjectDefAtLoc(RivertreeID, 0, 0.5, 0.5);
		}
	}
	
	// ****************************
	
	// Text
	rmSetStatusText("",0.90);
	
	// ******** TREASURES *********
	
	int nugget1count = 4+cNumberNonGaiaPlayers/2; 
	int nugget2count = 2+0.5*cNumberNonGaiaPlayers;
	int nugget3count = 0.5*cNumberNonGaiaPlayers;
	int nugget4count = 0.34*cNumberNonGaiaPlayers;
	
	int treasurespot = -1;
	int bonusnugget4 = rmRandInt(0,1);
	int bonusnugget3 = rmRandInt(0,1);
	int bonusnugget2 = rmRandInt(0,1);
	int bonusnugget1 = rmRandInt(1,2)-bonusnugget2;
	
	// Treasure lvl4
	for (i=0; < nugget4count+bonusnugget4)
	{
		int Nugget4ID = rmCreateObjectDef("Nugget lvl4"+i); 
		rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget4ID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(Nugget4ID, avoidCaribouMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidMuskdeerMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget4ID, avoidCliff);
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidEdge);
		if (season < 0.5)
		{
			rmAddObjectDefConstraint(Nugget4ID, avoidFrozenRiver1);
			rmAddObjectDefConstraint(Nugget4ID, avoidFrozenRiver2);
		}
		treasurespot = rmRandInt(1,3);
		if (treasurespot == 1)
			rmAddObjectDefConstraint(Nugget4ID, treasuremiddle);
		else if (treasurespot == 2)
			rmAddObjectDefConstraint(Nugget4ID, treasurewest);
		else
			rmAddObjectDefConstraint(Nugget4ID, treasureeast);
		rmSetNuggetDifficulty(4, 4);
		if (cNumberNonGaiaPlayers >= 4)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.5, 0.5);
	}
	
	// Treasure lvl3
	for (i=0; < nugget3count+bonusnugget3)
	{
		int Nugget3ID = rmCreateObjectDef("Nugget lvl3"+i); 
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(Nugget3ID, avoidCaribouMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidMuskdeerMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget3ID, avoidCliff);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidEdge);
		if (season < 0.5)
		{
			rmAddObjectDefConstraint(Nugget3ID, avoidFrozenRiver1);
			rmAddObjectDefConstraint(Nugget3ID, avoidFrozenRiver2);
		}
		if (cNumberNonGaiaPlayers >= 3)
			treasurespot = rmRandInt(1,3);
		else
			treasurespot = rmRandInt(2,3);
		if (treasurespot == 1)
			rmAddObjectDefConstraint(Nugget3ID, treasuremiddle);
		else if (treasurespot == 2)
			rmAddObjectDefConstraint(Nugget3ID, treasurewest);
		else
			rmAddObjectDefConstraint(Nugget3ID, treasureeast);
		rmSetNuggetDifficulty(3, 3);
		if (cNumberNonGaiaPlayers >= 3)
			rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.5, 0.5);
	}

	// Treasure lvl2
	for (i=0; < nugget2count+bonusnugget2)
	{
		int Nugget2ID = rmCreateObjectDef("Nugget lvl2"+i); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(Nugget2ID, avoidCaribouMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidMuskdeerMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget2ID, avoidCliff);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge);
		if (season < 0.5)
		{
			rmAddObjectDefConstraint(Nugget2ID, avoidFrozenRiver1);
			rmAddObjectDefConstraint(Nugget2ID, avoidFrozenRiver2);
		}
		if (cNumberTeams <= 2)
		{
			if (treasurespot == 1)
				rmAddObjectDefConstraint(Nugget2ID, treasureeast);
			else if (treasurespot == 2)
				rmAddObjectDefConstraint(Nugget2ID, treasuremiddle);
			else
				rmAddObjectDefConstraint(Nugget2ID, treasurewest);
		}
		rmSetNuggetDifficulty(2, 2);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.5, 0.5);
		treasurespot = rmRandInt(1,3);
	}
	
	// Treasure lvl1
	for (i=0; < nugget1count+bonusnugget1)
	{
		int Nugget1ID = rmCreateObjectDef("Nugget lvl1"+i); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(Nugget1ID, avoidCaribouMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidMuskdeerMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget1ID, avoidCliff);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge);
		if (season < 0.5)
		{
			rmAddObjectDefConstraint(Nugget1ID, avoidFrozenRiver1);
			rmAddObjectDefConstraint(Nugget1ID, avoidFrozenRiver2);
		}
			
		rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.5, 0.5);
	}
	
	// ****************************
	
	
	// Goats
	int goatcount = 4*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 4)
		goatcount = 4*cNumberNonGaiaPlayers-cNumberNonGaiaPlayers/2;
	
	for (i=0; <goatcount)
	{
		int GoatID = rmCreateObjectDef("goat"+i);
		if (i < cNumberNonGaiaPlayers)
		{
			rmAddObjectDefItem(GoatID, "ypGoat", 2, 4.0);
			rmAddObjectDefConstraint(GoatID, stayCenter);
		}	
		else
			rmAddObjectDefItem(GoatID, "ypGoat", 1, 1.0);
		rmSetObjectDefMinDistance(GoatID, 10.0);
		rmSetObjectDefMaxDistance(GoatID, rmXFractionToMeters(0.6));
		rmAddObjectDefConstraint(GoatID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(GoatID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(GoatID, avoidCliff);
		rmAddObjectDefConstraint(GoatID, avoidNatives);
		rmAddObjectDefConstraint(GoatID, avoidImportantItem);
		rmAddObjectDefConstraint(GoatID, avoidEdge);
		rmAddObjectDefConstraint(GoatID, avoidGoat);
		rmAddObjectDefConstraint(GoatID, avoidTownCenter);
		rmAddObjectDefConstraint(GoatID, avoidForestMin);
		rmAddObjectDefConstraint(GoatID, avoidNuggetMin);
		rmPlaceObjectDefAtLoc(GoatID, 0, 0.4, 0.5);
	}
	
	// Text
	rmSetStatusText("",1.00);

	
} //END
	
	