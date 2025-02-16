// vivid's Fraser River (Obs) v2
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
	int playerTiles=11000;
	if (cNumberNonGaiaPlayers >= 4){
		playerTiles = 10000;
	}
	else if (cNumberNonGaiaPlayers >= 6){
		playerTiles = 9000;
	}
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmSetMapSize(size, size);

	// Random Spawn
	float spawnChooser = rmRandFloat(0,1);	// > 0.30 is valley spawn, else is plateau spawn
	
	// Make the corners
	rmSetWorldCircleConstraint(true);
	
	// Picks a default water height
	if (spawnChooser > 0.00) {
		rmSetSeaLevel(-4.0);
		}
	else {
		rmSetSeaLevel(-4.0);
		}
	rmSetMapElevationParameters(cElevTurbulence, 0.5, 0.5, 0.5, 2.0); // type, frequency, octaves, persistence, variation

	// Picks default terrain and water
	rmSetBaseTerrainMix("nwt_grass1"); 
	rmTerrainInitialize("nwterritory\ground_grass1_nwt", -4.00); 
	rmSetMapType("northwestTerritory");
	rmSetMapType("grass");
	rmSetMapType("mountain");
	rmSetMapType("land");
	rmSetMapType("namerica");
    rmSetLightingSet("great plains");

	// Choose Mercs
	chooseMercs();
	
	// Make it snow
	rmSetGlobalSnow(0.75);  
	
	// Make it windy
	rmSetWindMagnitude(5.0);
	
	// Text
	rmSetStatusText("",0.10);

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	int classIsland=rmDefineClass("island");
	int classNative=rmDefineClass("natives");
	rmDefineClass("importantItem");
	rmDefineClass("classCliff");
	rmDefineClass("secrets");
	rmDefineClass("nuggets");
	rmDefineClass("center");
	rmDefineClass("tradeIslands");
    rmDefineClass("socketClass");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classPatch3 = rmDefineClass("patch3");
	int classCliff = rmDefineClass("Cliffs");
	
	// Text
	rmSetStatusText("",0.20);
	
	// ____________________ Constraints ____________________
	// These are used to have objects and areas avoid each other
   
	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.18), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenterMin = rmCreatePieConstraint("Avoid Center min",0.5,0.5,rmXFractionToMeters(0.1), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));

	int staySouthPart = rmCreatePieConstraint("Stay south part", 0.55, 0.55,rmXFractionToMeters(0.0), rmXFractionToMeters(0.60), rmDegreesToRadians(135),rmDegreesToRadians(315));
	int stayNorthHalf = rmCreatePieConstraint("Stay north half", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(360),rmDegreesToRadians(180));
		
	// Resource avoidance
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 26.0);
	int avoidForestMed=rmCreateClassDistanceConstraint("avoid forest med", rmClassID("Forest"), 20.0);
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 34.0);
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 15.0);
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 8.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("Forest"), 25.0);
	int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("Forest"), 20.0);
	int avoidMoose = rmCreateTypeDistanceConstraint("avoid Moose", "moose", 40.0);
	int avoidMooseShort = rmCreateTypeDistanceConstraint("avoid Moose short", "moose", 20.0);
	int avoidMooseMed = rmCreateTypeDistanceConstraint("avoid Moose med", "moose", 30.0);
	int avoidMooseFar = rmCreateTypeDistanceConstraint("avoid Moose far", "moose", 50.0);
	int avoidMooseVeryFar = rmCreateTypeDistanceConstraint("avoid Moosevery far", "moose", 65.0);
	int avoidElkFar = rmCreateTypeDistanceConstraint("avoid Elk far", "elk", 60.0);
	int avoidElk = rmCreateTypeDistanceConstraint("avoid Elk", "elk", 50.0);
	int avoidElkMed = rmCreateTypeDistanceConstraint("avoid Elk med", "elk", 35.0);
	int avoidSheepMed = rmCreateTypeDistanceConstraint("avoid Elk med", "bighornsheep", 35.0);
	int avoidElkShort = rmCreateTypeDistanceConstraint("avoid Elk short", "elk", 25.0);
	int avoidElkMin = rmCreateTypeDistanceConstraint("avoid Elk min", "elk", 10.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 35.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 20.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 45.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 52.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 15.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 30.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 54.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 72.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 20.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 30.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 40.0);
	int avoidTownCenterVeryFar = rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 70.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 60.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 40.0); 
	int avoidTownCenterMed = rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 50.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 30.0);
	int avoidTownCenterMin = rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 20.0);
	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 12.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 8.0);

	// Avoid impassable land
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 8.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 8.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 8.0);
	int avoidIslandMin=rmCreateClassDistanceConstraint("avoid island min", classIsland, 8.0);
	int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 12.0);
	int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 16.0);
	int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 32.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", rmClassID("Cliffs"), 12.0);
	int avoidCliffMed = rmCreateClassDistanceConstraint("avoid cliff medium", rmClassID("Cliffs"), 16.0);
	int avoidCliffFar = rmCreateClassDistanceConstraint("avoid cliff far", rmClassID("Cliffs"), 24.0);
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 12.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 8.0);
	int avoidTradeRouteSocketMin = rmCreateTradeRouteDistanceConstraint("trade route socket min", 6.0);
	int avoidTradeRouteSocketShort = rmCreateTradeRouteDistanceConstraint("trade route socket short", 12.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 20.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 12.0);
	int stayNatives = rmCreateClassDistanceConstraint("stuff stays near natives", rmClassID("natives"), 6.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", rmClassID("natives"), 18.0);
	int avoidNativesVeryFar = rmCreateClassDistanceConstraint("stuff avoids natives very far", rmClassID("natives"), 24.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 15.0);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "land", false, 10.0);
	int stayNearWaterFar = rmCreateTerrainMaxDistanceConstraint("stay near water far ", "land", false, 20.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 3.0);
	
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
						rmPlacePlayer(1, 0.85, 0.50);
						rmPlacePlayer(2, 0.15, 0.50);
				}
				else
				{
						rmPlacePlayer(2, 0.15, 0.50);
						rmPlacePlayer(1, 0.85, 0.50);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.20, 0.30); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.70, 0.80); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);	
				}
				else // 3v3, 4v4
				{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.17, 0.33); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.67, 0.83); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);	
				}
			}
			else
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.17, 0.33); 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.36, 0.36, 0);

				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.67, 0.83); 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.36, 0.36, 0);	
			}
		}
		else  //FFA
			{	
			if (cNumberNonGaiaPlayers == 4) {
				if (spawnChooser > 0.00) {
					rmSetPlacementSection(0.125, 0.1249);
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.40, 0.40, 0.0);
							}
				else {
					rmSetPlacementSection(0.125, 0.1249);
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.40, 0.40, 0.0);
					}			
				}
			else if (cNumberNonGaiaPlayers == 6 || cNumberNonGaiaPlayers == 8) {
				if (spawnChooser > 0.00) {
					rmSetPlacementSection(0.075, 0.0749);
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.40, 0.40, 0.0);
							}
				else {
					rmSetPlacementSection(0.075, 0.0749);
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.40, 0.40, 0.0);
					}
				}
			else if (cNumberNonGaiaPlayers == 3) {
				if (spawnChooser > 0.00) {
					rmSetPlacementSection(0.10, 0.099);
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.40, 0.40, 0.0);
							}
				else {
					rmSetPlacementSection(0.10, 0.099);
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.40, 0.40, 0.0);
					}
				}
			else {
				if (spawnChooser > 0.00) {
					rmSetPlacementSection(0.125, 0.1249);
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.40, 0.40, 0.0);
							}
				else {
					rmSetPlacementSection(0.125, 0.1249);
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.40, 0.40, 0.0);
					}
				}
			}


	// Text
	rmSetStatusText("",0.30);
	
	// ____________________ Map Parameters ____________________
	int centralvalleyID = rmCreateArea("central valley");
	rmSetAreaLocation(centralvalleyID, 0.5, 0.5);
	rmSetAreaWarnFailure(centralvalleyID, false);
	rmSetAreaSize(centralvalleyID,0.99, 0.99);
	rmSetAreaCoherence(centralvalleyID, 1.0);
	rmSetAreaObeyWorldCircleConstraint(centralvalleyID, false);
	rmSetAreaMix(centralvalleyID, "nwt_grass1"); // rockies_grass 
	rmBuildArea(centralvalleyID); 
	
	int stayValley = rmCreateAreaConstraint("stay in central valley", centralvalleyID);

	// ____________________ Resource Zones ____________________
	// Gold Zone SE
	int goldzoneSEID = rmCreateArea("gold zone SE");
	rmSetAreaSize(goldzoneSEID, 0.15, 0.15);
	rmSetAreaLocation(goldzoneSEID, 0.20, 0.10);
	rmAddAreaInfluenceSegment(goldzoneSEID, 0.20, 0.10, 0.40, 0.40);	
	rmAddAreaInfluenceSegment(goldzoneSEID, 0.30, 0.00, 0.40, 0.40);	
	rmAddAreaInfluenceSegment(goldzoneSEID, 0.40, 0.00, 0.40, 0.40);	
	rmAddAreaInfluenceSegment(goldzoneSEID, 0.50, 0.00, 0.40, 0.40);	
	rmSetAreaWarnFailure(goldzoneSEID, false);
//	rmSetAreaMix(goldzoneSEID, "yellow_river_b");	// for testing
	rmSetAreaCoherence(goldzoneSEID, 1.0); 
	rmSetAreaElevationType(goldzoneSEID, cElevTurbulence);
	rmSetAreaElevationVariation(goldzoneSEID, 5.0);
	rmSetAreaElevationMinFrequency(goldzoneSEID, 0.04);
	rmSetAreaElevationOctaves(goldzoneSEID, 3);
	rmSetAreaElevationPersistence(goldzoneSEID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(goldzoneSEID, false);
	rmBuildArea(goldzoneSEID);	

	// Gold Zone NW
	int goldzoneNWID = rmCreateArea("gold zone NW");
	rmSetAreaSize(goldzoneNWID, 0.15, 0.15);
	rmSetAreaLocation(goldzoneNWID, 0.80, 0.90);
	rmAddAreaInfluenceSegment(goldzoneNWID, 0.80, 0.90, 0.60, 0.60);	
	rmAddAreaInfluenceSegment(goldzoneNWID, 0.70, 1.00, 0.60, 0.60);	
	rmAddAreaInfluenceSegment(goldzoneNWID, 0.60, 1.00, 0.60, 0.60);	
	rmAddAreaInfluenceSegment(goldzoneNWID, 0.50, 1.00, 0.60, 0.60);	
	rmSetAreaWarnFailure(goldzoneNWID, false);
//	rmSetAreaMix(goldzoneNWID, "yellow_river_b");	// for testing
	rmSetAreaCoherence(goldzoneNWID, 1.0); 
	rmSetAreaElevationType(goldzoneNWID, cElevTurbulence);
	rmSetAreaElevationVariation(goldzoneNWID, 5.0);
	rmSetAreaElevationMinFrequency(goldzoneNWID, 0.04);
	rmSetAreaElevationOctaves(goldzoneNWID, 3);
	rmSetAreaElevationPersistence(goldzoneNWID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(goldzoneNWID, false);
	rmBuildArea(goldzoneNWID);	
	
	int avoidGoldZoneSE = rmCreateAreaDistanceConstraint("avoid gold zone SE ", goldzoneSEID, 20.0);
	int avoidGoldZoneSEShort = rmCreateAreaDistanceConstraint("avoid gold zone SE short ", goldzoneSEID, 12.0);
	int stayGoldZoneSE = rmCreateAreaMaxDistanceConstraint("stay in gold zone SE ", goldzoneSEID, 0.0);	
	int avoidGoldZoneNW = rmCreateAreaDistanceConstraint("avoid gold zone NW ", goldzoneNWID, 20.0);
	int avoidGoldZoneNWShort = rmCreateAreaDistanceConstraint("avoid gold zone NW short ", goldzoneNWID, 12.0);
	int stayGoldZoneNW = rmCreateAreaMaxDistanceConstraint("stay in gold zone NW ", goldzoneNWID, 0.0);
	
	// ____________________ River ____________________
		int riverID = rmRiverCreate(-1, "Northwest Territory Water", 4+cNumberNonGaiaPlayers/2, 4+cNumberNonGaiaPlayers/2, 5, 5);  
		if (cNumberTeams <= 2) {
			rmRiverAddWaypoint(riverID, 0.20, 1.00);
			rmRiverAddWaypoint(riverID, 0.30, 0.90);
			rmRiverAddWaypoint(riverID, 0.375, 0.85);
			rmRiverAddWaypoint(riverID, 0.35, 0.75);
			rmRiverAddWaypoint(riverID, 0.40, 0.70);
			rmRiverAddWaypoint(riverID, 0.50, 0.65);
			rmRiverAddWaypoint(riverID, 0.425, 0.525);
			rmRiverAddWaypoint(riverID, 0.50, 0.50);
			rmRiverAddWaypoint(riverID, 0.575, 0.475);
			rmRiverAddWaypoint(riverID, 0.50, 0.35);
			rmRiverAddWaypoint(riverID, 0.60, 0.30);
			rmRiverAddWaypoint(riverID, 0.65, 0.25);
			rmRiverAddWaypoint(riverID, 0.60, 0.15);
			rmRiverAddWaypoint(riverID, 0.70, 0.10);
			rmRiverAddWaypoint(riverID, 0.80, 0.00);
			}
		else {
			rmRiverAddWaypoint(riverID, 0.50, 1.00);
			rmRiverAddWaypoint(riverID, 0.50, 0.90);
			rmRiverAddWaypoint(riverID, rmRandFloat(0.50,0.55), 0.80);
			rmRiverAddWaypoint(riverID, rmRandFloat(0.45,0.50), 0.70);
			rmRiverAddWaypoint(riverID, rmRandFloat(0.50,0.55), 0.60);
			rmRiverAddWaypoint(riverID, 0.50, 0.50);
			rmRiverAddWaypoint(riverID, rmRandFloat(0.45,0.50), 0.40);
			rmRiverAddWaypoint(riverID, rmRandFloat(0.50,0.55), 0.30);
			rmRiverAddWaypoint(riverID, rmRandFloat(0.45,0.50), 0.20);
			rmRiverAddWaypoint(riverID, 0.50, 0.10);
			rmRiverAddWaypoint(riverID, 0.50, 0.00);
			}
		rmRiverSetShallowRadius(riverID, 7+2*cNumberNonGaiaPlayers);
		if (cNumberTeams <= 2) {
			rmRiverAddShallow(riverID, 0.225);
			rmRiverAddShallow(riverID, 0.50);
			rmRiverAddShallow(riverID, 0.775);
			}
		else if (cNumberTeams > 2) {
				rmRiverAddShallow(riverID, 0.10);
				rmRiverAddShallow(riverID, 0.30);
				rmRiverAddShallow(riverID, 0.70);
				rmRiverAddShallow(riverID, 0.90);
			}

		int river2ID = rmRiverCreate(-1, "Northwest Territory Water", 5, 5, 5, 5);  
		if (cNumberTeams <= 2) {
			rmRiverAddWaypoint(river2ID, 0.20, 1.00);
			rmRiverAddWaypoint(river2ID, 0.30, 0.90);
			rmRiverAddWaypoint(river2ID, 0.375, 0.85);
			rmRiverAddWaypoint(river2ID, 0.35, 0.75);
			rmRiverAddWaypoint(river2ID, 0.40, 0.70);
			rmRiverAddWaypoint(river2ID, 0.50, 0.65);
			rmRiverAddWaypoint(river2ID, 0.425, 0.525);
			rmRiverAddWaypoint(river2ID, 0.50, 0.50);
			rmRiverAddWaypoint(river2ID, 0.575, 0.475);
			rmRiverAddWaypoint(river2ID, 0.50, 0.35);
			rmRiverAddWaypoint(river2ID, 0.60, 0.30);
			rmRiverAddWaypoint(river2ID, 0.65, 0.25);
			rmRiverAddWaypoint(river2ID, 0.60, 0.15);
			rmRiverAddWaypoint(river2ID, 0.70, 0.10);
			rmRiverAddWaypoint(river2ID, 0.80, 0.00);
			}
		else {
			rmRiverAddWaypoint(river2ID, 0.50, 1.00);
			rmRiverAddWaypoint(river2ID, 0.50, 0.90);
			rmRiverAddWaypoint(river2ID, rmRandFloat(0.50,0.55), 0.80);
			rmRiverAddWaypoint(river2ID, rmRandFloat(0.45,0.50), 0.70);
			rmRiverAddWaypoint(river2ID, rmRandFloat(0.50,0.55), 0.60);
			rmRiverAddWaypoint(river2ID, 0.50, 0.50);
			rmRiverAddWaypoint(river2ID, rmRandFloat(0.45,0.50), 0.40);
			rmRiverAddWaypoint(river2ID, rmRandFloat(0.50,0.55), 0.30);
			rmRiverAddWaypoint(river2ID, rmRandFloat(0.45,0.50), 0.20);
			rmRiverAddWaypoint(river2ID, 0.50, 0.10);
			rmRiverAddWaypoint(river2ID, 0.50, 0.00);
			}
		rmRiverSetShallowRadius(river2ID, 6+2*cNumberNonGaiaPlayers);
		if (cNumberTeams <= 2) {
			rmRiverAddShallow(river2ID, 0.25);
			rmRiverAddShallow(river2ID, 0.50);
			rmRiverAddShallow(river2ID, 0.75);
			}
		else if (cNumberTeams > 2) {
				rmRiverAddShallow(river2ID, 0.10);
				rmRiverAddShallow(river2ID, 0.30);
				rmRiverAddShallow(river2ID, 0.70);
				rmRiverAddShallow(river2ID, 0.90);
			}

		if (spawnChooser > 0.00)
			rmRiverBuild(riverID);	
		else
			rmRiverBuild(river2ID);	

	rmSetStatusText("",0.40);

	// ____________________ Trade Route ____________________
	if (cNumberTeams <= 2) {
	
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
		rmAddTradeRouteWaypoint(tradeRouteID, 0.70, 1.00);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.90);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 0.60);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 0.55);
       
        rmSetObjectDefTradeRouteID(socketID2, tradeRouteID2);
		rmAddTradeRouteWaypoint(tradeRouteID2, 0.30, 0.00);
		rmAddTradeRouteWaypoint(tradeRouteID2, 0.35, 0.10);
		rmAddTradeRouteWaypoint(tradeRouteID2, 0.40, 0.40);
		rmAddTradeRouteWaypoint(tradeRouteID2, 0.45, 0.45);
		
        rmBuildTradeRoute(tradeRouteID, "dirt");
        rmBuildTradeRoute(tradeRouteID2, "dirt");

        vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.20);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		if (cNumberNonGaiaPlayers > 5) {
			socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);		
		}
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.80);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		
        vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.20);
        rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
		if (cNumberNonGaiaPlayers > 5) {
			socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.50);
			rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
		}
		socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.80);
        rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
	}

	// ____________________ KOTH ____________________
	if (rmGetIsKOTH() == true) {
		
		// King's Island
		int kingislandID=rmCreateArea("King's Island");
		rmSetAreaSize(kingislandID, 0.01, 0.01);
		rmSetAreaLocation(kingislandID, 0.5, 0.5);
		rmSetAreaMix(kingislandID, "nwt_grass1"); // rockies_grass 
		rmAddAreaToClass(kingislandID, classIsland);
		rmSetAreaBaseHeight(kingislandID, -4.0);
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
	
	// ____________________ Natives ____________________
	// Native "Islands" to Avoid	
	int nativeisland1ID=rmCreateArea("first native island");
		rmSetAreaSize(nativeisland1ID, 0.001, 0.001);
	//	rmSetAreaBaseHeight(nativeisland1ID, -4.0);
		rmAddAreaToClass(nativeisland1ID, classIsland);
		rmSetAreaCoherence(nativeisland1ID, 1.0);
		if (cNumberTeams > 2)
			rmSetAreaLocation(nativeisland1ID, 0.70, 0.50);
		else 
			rmSetAreaLocation(nativeisland1ID, 0.50, 0.90);					
		rmBuildArea(nativeisland1ID); 	

	int nativeisland2ID=rmCreateArea("second native island");
		rmSetAreaSize(nativeisland2ID, 0.001, 0.001);
	//	rmSetAreaBaseHeight(nativeisland2ID, -4.00);
		rmAddAreaToClass(nativeisland2ID, classIsland);
		rmSetAreaCoherence(nativeisland2ID, 1.0);
		if (cNumberTeams > 2)
			rmSetAreaLocation(nativeisland2ID, 0.30, 0.50);
		else
			rmSetAreaLocation(nativeisland2ID, 0.50, 0.10);		
		rmBuildArea(nativeisland2ID); 	

	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	int subCiv2 = -1;
	subCiv0 = rmGetCivID("Nootka");
	subCiv1 = rmGetCivID("Cree");
	subCiv2 = rmGetCivID("Cheyenne");
	rmSetSubCiv(0, "Nootka");
	rmSetSubCiv(1, "Cree");
	rmSetSubCiv(2, "Cheyenne");

	// Place Natives
	int nativeID0 = -1;
	int nativeID1 = -1;

	int whichNative = rmRandInt(1,3);
	
	if (whichNative == 1) {
		nativeID0 = rmCreateGrouping("nootka A", "native nootka village "+4);
		rmAddGroupingToClass(nativeID0, classNative);
		nativeID1 = rmCreateGrouping("nootka B", "native nootka village "+2);
		rmAddGroupingToClass(nativeID1, classNative);
	}
	else if (whichNative == 2) {
		nativeID0 = rmCreateGrouping("cree A", "native cree village "+4);
		rmAddGroupingToClass(nativeID0, classNative);
		nativeID1 = rmCreateGrouping("cree B", "native cree village "+3);
		rmAddGroupingToClass(nativeID1, classNative);
	}	
	else {
		nativeID0 = rmCreateGrouping("cheyenne A", "native cheyenne village "+4);
		rmAddGroupingToClass(nativeID0, classNative);
		nativeID1 = rmCreateGrouping("cheyenne B", "native cheyenne village "+3);
		rmAddGroupingToClass(nativeID1, classNative);
	}
	if (cNumberTeams > 2) {
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.70, 0.50);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.30, 0.50);
		}
	else {
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.50, 0.90);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.10);		
		}
	
	if (spawnChooser > 0.00) {
		// Plateau 1
		int plateauID = rmCreateArea("plateau1");
		if (cNumberTeams <= 2)
			rmSetAreaSize(plateauID, 0.155, 0.155); 
		else
			rmSetAreaSize(plateauID, 0.31, 0.31); 
		rmSetAreaWarnFailure(plateauID, false);
		rmSetAreaObeyWorldCircleConstraint(plateauID, false);
		rmSetAreaCliffType(plateauID, "ozarks"); 
		rmSetAreaCliffPainting(plateauID, false, true, true, 0.4, true);
		rmSetAreaCliffHeight(plateauID, 6.0, 0.0, 0.8);
		rmSetAreaCliffEdge(plateauID, 6, 0.10, 0.0, 1.0, 1);
		rmSetAreaCoherence(plateauID, 0.75);
		rmSetAreaSmoothDistance(plateauID, 2);
		rmSetAreaLocation(plateauID, 0.00, 0.50);
		rmAddAreaConstraint(plateauID, avoidTradeRouteSocketShort);
		if (cNumberTeams <= 2) {
			rmAddAreaInfluenceSegment(plateauID, 0.90, 0.20, 0.90, 0.80);
			rmAddAreaInfluenceSegment(plateauID, 0.90, 0.40, 0.80, 0.20);
			rmAddAreaInfluenceSegment(plateauID, 0.90, 0.60, 0.80, 0.80);
			}
		else {
			rmAddAreaInfluencePoint(plateauID, 0.00, 0.25);
			rmAddAreaInfluencePoint(plateauID, 0.15, 0.15);
			rmAddAreaInfluencePoint(plateauID, 0.25, 0.05);
			rmAddAreaInfluencePoint(plateauID, 0.05, 0.75);
			rmAddAreaInfluencePoint(plateauID, 0.15, 0.85);
			rmAddAreaInfluencePoint(plateauID, 0.25, 0.95);
			}
		rmBuildArea(plateauID);
		
		int avoidPlateau1 = rmCreateAreaDistanceConstraint("avoid plateau1", plateauID, 8.0);
		int avoidPlateau1Far = rmCreateAreaDistanceConstraint("avoid plateau1 far", plateauID, 30.0);
		int stayPlateau1 = rmCreateAreaMaxDistanceConstraint("stay in plateau1", plateauID, 0);
		
		// Plateau 2
		int plateau2ID = rmCreateArea("plateau2");
		if (cNumberTeams <= 2)
			rmSetAreaSize(plateau2ID, 0.155, 0.155); 
		else
			rmSetAreaSize(plateau2ID, 0.31, 0.31); 	
		rmSetAreaWarnFailure(plateau2ID, false);
		rmSetAreaObeyWorldCircleConstraint(plateau2ID, false);
		rmSetAreaCliffType(plateau2ID, "ozarks"); 
		rmSetAreaCliffPainting(plateau2ID, false, true, true, 0.4, true);
		rmSetAreaCliffHeight(plateau2ID, 4.0, 0.0, 0.8);
		rmSetAreaCliffEdge(plateau2ID, 6, 0.10, 0.0, 1.0, 1);
		rmSetAreaCoherence(plateau2ID, 0.75);
		rmSetAreaSmoothDistance(plateau2ID, 2);
		rmSetAreaLocation(plateau2ID, 1.00, 0.50);
		rmAddAreaConstraint(plateau2ID, avoidTradeRouteSocketShort);
		if (cNumberTeams <= 2) {
			rmAddAreaInfluenceSegment(plateau2ID, 0.10, 0.20, 0.10, 0.80);
			rmAddAreaInfluenceSegment(plateau2ID, 0.10, 0.40, 0.20, 0.20);
			rmAddAreaInfluenceSegment(plateau2ID, 0.10, 0.60, 0.20, 0.80);
			}
		else {
			rmAddAreaInfluencePoint(plateau2ID, 0.95, 0.75);
			rmAddAreaInfluencePoint(plateau2ID, 0.85, 0.85);
			rmAddAreaInfluencePoint(plateau2ID, 0.75, 0.95);
			rmAddAreaInfluencePoint(plateau2ID, 0.95, 0.25);
			rmAddAreaInfluencePoint(plateau2ID, 0.85, 0.15);
			rmAddAreaInfluencePoint(plateau2ID, 0.75, 0.05);
			}
		rmBuildArea(plateau2ID);
	
		int avoidPlateau2 = rmCreateAreaDistanceConstraint("avoid plateau2", plateau2ID, 8.0);
		int avoidPlateau2Far = rmCreateAreaDistanceConstraint("avoid plateau2 far", plateau2ID, 30.0);
		int stayPlateau2 = rmCreateAreaMaxDistanceConstraint("stay in plateau2", plateau2ID, 0);
		
	}

	// Text
	rmSetStatusText("",0.50);

	// ____________________ Starting Resources ____________________
	// Town center & units
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 10.0);
	rmSetObjectDefMaxDistance(startingUnits, 15.0);

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
	rmSetObjectDefMaxDistance(TCID, 10.0);
	
	// Starting mines
	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "Mine", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 14.0);
	rmSetObjectDefMaxDistance(playergoldID, 16.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "Mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 22.0);
	rmSetObjectDefMaxDistance(playergold2ID, 24.0);
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidGold);
	rmAddObjectDefConstraint(playergold2ID, avoidEdge);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "TreeNorthwestTerritory", rmRandInt(6,7), 5.0);
    rmSetObjectDefMinDistance(playerTreeID, 16);
    rmSetObjectDefMaxDistance(playerTreeID, 20);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	
	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 2, 2.0);
	rmSetObjectDefMinDistance(playerberriesID, 12.0);
	rmSetObjectDefMaxDistance(playerberriesID, 14.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResourcesShort);
	
	// Starting herd
	int playeherdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playeherdID, "bighornsheep", rmRandInt(8,8), 4.0);
	rmSetObjectDefMinDistance(playeherdID, 14);
	rmSetObjectDefMaxDistance(playeherdID, 18);
	rmSetObjectDefCreateHerd(playeherdID, false);
	rmAddObjectDefToClass(playeherdID, classStartingResource);
	rmAddObjectDefConstraint(playeherdID, avoidStartingResourcesShort);
		
	// 2nd herd
	int player2ndherdID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(player2ndherdID, "bighornsheep", rmRandInt(8,8), 6.0);
    rmSetObjectDefMinDistance(player2ndherdID, 22);
    rmSetObjectDefMaxDistance(player2ndherdID, 24);
	rmAddObjectDefToClass(player2ndherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player2ndherdID, true);
	rmAddObjectDefConstraint(player2ndherdID, avoidEdge);
	rmAddObjectDefConstraint(player2ndherdID, avoidStartingResourcesShort);
		
	// 3nd herd
	int player3rdherdID = rmCreateObjectDef("player 3rd herd");
	rmAddObjectDefItem(player3rdherdID, "bighornsheep", rmRandInt(6,6), 6.0);
    rmSetObjectDefMinDistance(player3rdherdID, 32);
    rmSetObjectDefMaxDistance(player3rdherdID, 34);
	rmAddObjectDefToClass(player3rdherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player3rdherdID, true);
	rmAddObjectDefConstraint(player3rdherdID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(player3rdherdID, avoidEdge);
	rmAddObjectDefConstraint(player3rdherdID, avoidCliff);

	// Japan Extra Orchard Rickshaw
	int extraberrywagonID=rmCreateObjectDef("Starting Asian Outpost");
	rmAddObjectDefItem(extraberrywagonID, "ypBerryWagon1", 1, 0.0);
	rmSetObjectDefMinDistance(extraberrywagonID, 10.0);
	rmSetObjectDefMaxDistance(extraberrywagonID, 12.0);
	rmAddObjectDefToClass(extraberrywagonID, classStartingResource);
	rmAddObjectDefConstraint(extraberrywagonID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(extraberrywagonID, avoidEdge);
	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 30.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 34.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidEdgeMore);
	
	//  Place Starting Objects/Resources
	
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	//	rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playeherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(player2ndherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if (cNumberTeams > 2 || cNumberNonGaiaPlayers >= 4) {
			rmPlaceObjectDefAtLoc(player3rdherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			}

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

	// ____________________ Mines ____________________
	// Static Mines 
	int staticgold1ID = rmCreateObjectDef("staticgold1");
		rmAddObjectDefItem(staticgold1ID, "Mine", 1, 2.0);
		rmSetObjectDefMinDistance(staticgold1ID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(staticgold1ID, rmXFractionToMeters(0.0));
		rmAddObjectDefToClass(staticgold1ID, classGold);
		if (cNumberTeams <= 2)
			rmPlaceObjectDefAtLoc(staticgold1ID, 0, 0.25, 0.85);

	int staticgold2ID = rmCreateObjectDef("staticgold2");
		rmAddObjectDefItem(staticgold2ID, "Mine", 1, 2.0);
		rmSetObjectDefMinDistance(staticgold2ID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(staticgold2ID, rmXFractionToMeters(0.0));
		rmAddObjectDefToClass(staticgold2ID, classGold);
		if (cNumberTeams <= 2)
			rmPlaceObjectDefAtLoc(staticgold2ID, 0, 0.75, 0.15);

	if (cNumberNonGaiaPlayers > 4) {
		int staticgold3ID = rmCreateObjectDef("staticgold3");
			rmAddObjectDefItem(staticgold3ID, "Mine", 1, 2.0);
			rmSetObjectDefMinDistance(staticgold3ID, rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(staticgold3ID, rmXFractionToMeters(0.0));
			rmAddObjectDefToClass(staticgold3ID, classGold);
			if (cNumberTeams == 2)
				rmPlaceObjectDefAtLoc(staticgold3ID, 0, 0.325, 0.725);
	
		int staticgold4ID = rmCreateObjectDef("staticgold4");
			rmAddObjectDefItem(staticgold4ID, "Mine", 1, 2.0);
			rmSetObjectDefMinDistance(staticgold4ID, rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(staticgold4ID, rmXFractionToMeters(0.0));
			rmAddObjectDefToClass(staticgold4ID, classGold);
			if (cNumberTeams == 2)
				rmPlaceObjectDefAtLoc(staticgold4ID, 0, 0.675, 0.275);
	}
	// NW Mines 
	int goldcount = 2+1*cNumberNonGaiaPlayers;  
	
	for(i=0; < goldcount)
	{
		int NWgoldID = rmCreateObjectDef("nw mines"+i);
		rmAddObjectDefItem(NWgoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(NWgoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(NWgoldID, rmXFractionToMeters(0.45));
		rmAddObjectDefToClass(NWgoldID, classGold);
		rmAddObjectDefConstraint(NWgoldID, avoidIslandShort);
		rmAddObjectDefConstraint(NWgoldID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(NWgoldID, avoidGold);
		rmAddObjectDefConstraint(NWgoldID, avoidTownCenter);
		rmAddObjectDefConstraint(NWgoldID, avoidEdge);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(NWgoldID, stayGoldZoneNW);
		rmAddObjectDefConstraint(NWgoldID, avoidNatives);
		rmAddObjectDefConstraint(NWgoldID, avoidPlateau1Far);
		rmAddObjectDefConstraint(NWgoldID, avoidPlateau2Far);
		rmPlaceObjectDefAtLoc(NWgoldID, 0, 0.50, 0.50);
	}

	// SE Mines 
	int gold2count = 2+1*cNumberNonGaiaPlayers;  
	
	for(i=0; < gold2count)
	{
		int SEgoldID = rmCreateObjectDef("se mines"+i);
		rmAddObjectDefItem(SEgoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(SEgoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(SEgoldID, rmXFractionToMeters(0.45));
		rmAddObjectDefToClass(SEgoldID, classGold);
		rmAddObjectDefConstraint(SEgoldID, avoidIslandShort);
		rmAddObjectDefConstraint(SEgoldID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(SEgoldID, avoidGold);
		rmAddObjectDefConstraint(SEgoldID, avoidTownCenter);
		rmAddObjectDefConstraint(SEgoldID, avoidEdge);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(SEgoldID, stayGoldZoneSE);
		rmAddObjectDefConstraint(SEgoldID, avoidNatives);
		rmAddObjectDefConstraint(SEgoldID, avoidPlateau1Far);
		rmAddObjectDefConstraint(SEgoldID, avoidPlateau2Far);
		rmPlaceObjectDefAtLoc(SEgoldID, 0, 0.50, 0.50);
	}


	// Text
	rmSetStatusText("",0.70);


	if (spawnChooser < 0.00) {
		// Rocky border1
		int border1ID = rmCreateArea("border1");
		rmSetAreaSize(border1ID, 0.01, 0.01); 
		rmSetAreaWarnFailure(border1ID, false);
		rmSetAreaObeyWorldCircleConstraint(border1ID, false);
		rmSetAreaCliffType(border1ID, "ozarks"); 
		rmSetAreaTerrainType(border1ID, "nwterritory\ground_grass1_nwt");
		rmSetAreaCliffHeight(border1ID, 12, 0.0, 0.2);
		rmSetAreaCliffEdge(border1ID, 1, 1.0, 0.0, 0.0, 1);
		rmSetAreaCoherence(border1ID, 0.80);
		rmSetAreaSmoothDistance(border1ID, 6);
		rmAddAreaToClass(border1ID, rmClassID("Cliffs"));
		rmSetAreaLocation(border1ID, 1.00, 0.50);
		rmAddAreaInfluenceSegment(border1ID, 1.00, 0.50, 0.95, 0.25);
		rmAddAreaInfluenceSegment(border1ID, 1.00, 0.50, 0.95, 0.75);
	//	rmAddAreaConstraint(border1ID, avoidTownCenterMin);
		rmAddAreaConstraint(border1ID, avoidGoldType);
		if (cNumberTeams <= 2)
			rmBuildArea(border1ID);
	
		int avoidBorder1 = rmCreateAreaDistanceConstraint("avoid border1", border1ID, 10.0);
		int avoidBorder1Far = rmCreateAreaDistanceConstraint("avoid border1 far", border1ID, 16.0);
		int avoidBorder1VeryFar = rmCreateAreaDistanceConstraint("avoid border1 far", border1ID, 50.0);
		int stayInBorder1 = rmCreateAreaMaxDistanceConstraint("stay in border1", border1ID, 0);

		// Rocky border2
		int border2ID = rmCreateArea("border2");
		rmSetAreaSize(border2ID, 0.0125, 0.0125); 
		rmSetAreaWarnFailure(border2ID, false);
		rmSetAreaObeyWorldCircleConstraint(border2ID, false);
		rmSetAreaCliffType(border2ID, "ozarks"); 
		rmSetAreaTerrainType(border2ID, "nwterritory\ground_grass1_nwt");
		rmSetAreaCliffHeight(border2ID, 12, 0.0, 0.2);
		rmSetAreaCliffEdge(border2ID, 1, 1.0, 0.0, 0.0, 1);
		rmSetAreaCoherence(border2ID, 0.80);
		rmSetAreaSmoothDistance(border2ID, 6);
		rmAddAreaToClass(border2ID, rmClassID("Cliffs"));
		rmSetAreaLocation(border2ID, 0.00, 0.50);
		rmAddAreaInfluenceSegment(border2ID, 0.00, 0.50, 0.05, 0.25);
		rmAddAreaInfluenceSegment(border2ID, 0.00, 0.50, 0.05, 0.75);
	//	rmAddAreaConstraint(border2ID, avoidTownCenterMin);
		rmAddAreaConstraint(border2ID, avoidGoldType);
		if (cNumberTeams <= 2)
			rmBuildArea(border2ID);
	
		int avoidBorder2 = rmCreateAreaDistanceConstraint("avoid border1", border2ID, 10.0);
		int avoidBorder2Far = rmCreateAreaDistanceConstraint("avoid border1 far", border2ID, 16.0);
		int avoidBorder2VeryFar = rmCreateAreaDistanceConstraint("avoid border1 far", border2ID, 50.0);
		int stayInBorder2 = rmCreateAreaMaxDistanceConstraint("stay in border1", border2ID, 0);

		int cliffWater = rmCreateTerrainDistanceConstraint("cliff avoids river", "Land", false, 12.0);

		// Cliffs
		for (i=0; <10*cNumberNonGaiaPlayers)
		{
			int cliffID=rmCreateArea("cliff"+i);
			rmSetAreaSize(cliffID, 0.005, 0.005);
			rmSetAreaCliffType(cliffID, "ozarks");  
			rmSetAreaTerrainType(cliffID, "nwterritory\ground_grass1_nwt");
			rmSetAreaWarnFailure(cliffID, false);
			rmAddAreaToClass(cliffID, rmClassID("Cliffs"));
			rmSetAreaObeyWorldCircleConstraint(cliffID, false);
			rmSetAreaCliffHeight(cliffID, 8, 0.0, 0.4);
			rmSetAreaCliffEdge(cliffID, 1, 1.0, 0.0, 0.0, 1);
			rmSetAreaCoherence(cliffID, 0.55);
			rmSetAreaSmoothDistance(cliffID, 5);
			rmAddAreaConstraint(cliffID, avoidGoldTypeShort);
			rmAddAreaConstraint(cliffID, avoidTownCenterShort);
			rmAddAreaConstraint(cliffID, avoidStartingResources);
			rmAddAreaConstraint(cliffID, avoidWater);
			rmAddAreaConstraint(cliffID, avoidNativesVeryFar);
			rmAddAreaConstraint(cliffID, avoidCliffFar);
			rmAddAreaConstraint(cliffID, avoidIsland);
			rmAddAreaConstraint(cliffID, avoidCenterMin);
			rmAddAreaConstraint(cliffID, avoidTradeRouteSocketShort);
			rmAddAreaConstraint(cliffID, avoidTradeRouteShort);
			rmAddAreaConstraint(cliffID, cliffWater);
			rmBuildArea(cliffID);
		}
	}

	// Text
	rmSetStatusText("",0.80);

	// ____________________ Trees ____________________
	// Main Forest
	int mainforestcount = 4+4*cNumberNonGaiaPlayers;
	int stayInForestPatch = -1;
	int treeWater = rmCreateTerrainDistanceConstraint("trees avoid river", "Land", false, 6.0);

	for (i=0; < mainforestcount)
    {
        int forestpatchID = rmCreateArea("main forest patch"+i);
        rmSetAreaWarnFailure(forestpatchID, false);
		rmSetAreaObeyWorldCircleConstraint(forestpatchID, false);
        rmSetAreaSize(forestpatchID, rmAreaTilesToFraction(75), rmAreaTilesToFraction(75));
        rmSetAreaMinBlobs(forestpatchID, 2);
        rmSetAreaMaxBlobs(forestpatchID, 3);
        rmSetAreaMinBlobDistance(forestpatchID, 10.0);
        rmSetAreaMaxBlobDistance(forestpatchID, 30.0);
        rmSetAreaCoherence(forestpatchID, 0.2);
		rmSetAreaMix(forestpatchID, "nwt_forest");
		rmSetAreaSmoothDistance(forestpatchID, 5);
		rmAddAreaConstraint(forestpatchID, avoidTradeRouteSocket);
		rmAddAreaConstraint(forestpatchID, avoidTradeRouteShort);
		rmAddAreaConstraint(forestpatchID, avoidForest);
		rmAddAreaConstraint(forestpatchID, avoidWater);
		rmAddAreaConstraint(forestpatchID, avoidIsland);
		rmAddAreaConstraint(forestpatchID, avoidTownCenter);
		rmAddAreaConstraint(forestpatchID, avoidGoldShort);
		rmAddAreaConstraint(forestpatchID, avoidNativesFar); 
		rmAddAreaConstraint(forestpatchID, treeWater); 
		if (spawnChooser > 0.00) {
			rmAddAreaConstraint(forestpatchID, avoidPlateau1);
			rmAddAreaConstraint(forestpatchID, avoidPlateau2);
			}
		else {
			rmAddAreaConstraint(forestpatchID, avoidCliffMed);
			}
		rmAddAreaConstraint(forestpatchID, avoidEdge);        
		rmBuildArea(forestpatchID);

		stayInForestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest patch"+i, forestpatchID, 0.0);

		for (j=0; < rmRandInt(7,8))
		{
			int foresttreeID = rmCreateObjectDef("forest trees"+i+j);
			if (spawnChooser > 0.00) {
				rmAddObjectDefItem(foresttreeID, "TreeNorthwestTerritory", rmRandInt(2,3), 5.0);
				rmAddObjectDefItem(foresttreeID, "TreeBayou", rmRandInt(2,3), 5.0);
				}
			else {
				rmAddObjectDefItem(foresttreeID, "TreeNorthwestTerritory", rmRandInt(3,4), 3.0);
			}
			rmSetObjectDefMinDistance(foresttreeID, rmXFractionToMeters(0.05));
			rmSetObjectDefMaxDistance(foresttreeID, rmXFractionToMeters(0.50));
			rmAddObjectDefToClass(foresttreeID, classForest);
			rmAddObjectDefConstraint(foresttreeID, stayInForestPatch);
			rmPlaceObjectDefAtLoc(foresttreeID, 0, 0.50, 0.50);
		}
    }

	// Text
	rmSetStatusText("",0.90);
	
	// Random Trees
	for (i=0; < 10+1*cNumberNonGaiaPlayers)
	{
		int randomtreeID = rmCreateObjectDef("random tree "+i);
		rmAddObjectDefItem(randomtreeID, "TreeNorthwestTerritory", rmRandInt(3,6), 2.0);
		rmSetObjectDefMinDistance(randomtreeID,  rmXFractionToMeters(0.15));
		rmSetObjectDefMaxDistance(randomtreeID,  rmXFractionToMeters(0.48));
		rmAddObjectDefToClass(randomtreeID, classForest);
		rmAddObjectDefConstraint(randomtreeID, avoidForestShort);
		rmAddObjectDefConstraint(randomtreeID, avoidNativesFar);
		rmAddObjectDefConstraint(randomtreeID, avoidGoldShort);
		rmAddObjectDefConstraint(randomtreeID, avoidTownCenter);
		rmAddObjectDefConstraint(randomtreeID, avoidNatives);
		rmAddObjectDefConstraint(randomtreeID, treeWater);
		if (spawnChooser > 0.00)
			rmAddObjectDefConstraint(randomtreeID, stayPlateau1);
		else
			rmAddObjectDefConstraint(randomtreeID, avoidCliff);
		rmPlaceObjectDefAtLoc(randomtreeID, 0, 0.50, 0.50);
	}

	for (i=0; < 10+1*cNumberNonGaiaPlayers)
	{
		int randomtree2ID = rmCreateObjectDef("random tree2 "+i);
		rmAddObjectDefItem(randomtree2ID, "TreeNorthwestTerritory", rmRandInt(3,6), 2.0);
		rmSetObjectDefMinDistance(randomtree2ID,  rmXFractionToMeters(0.15));
		rmSetObjectDefMaxDistance(randomtree2ID,  rmXFractionToMeters(0.48));
		rmAddObjectDefToClass(randomtree2ID, classForest);
		rmAddObjectDefConstraint(randomtree2ID, avoidForestShort);
		rmAddObjectDefConstraint(randomtree2ID, avoidNativesFar);
		rmAddObjectDefConstraint(randomtree2ID, avoidGoldShort);
		rmAddObjectDefConstraint(randomtree2ID, avoidTownCenter);
		rmAddObjectDefConstraint(randomtree2ID, avoidNatives);
		rmAddObjectDefConstraint(randomtree2ID, treeWater);
		if (spawnChooser > 0.00)
			rmAddObjectDefConstraint(randomtree2ID, stayPlateau2);
		else
			rmAddObjectDefConstraint(randomtree2ID, avoidCliff);
		rmPlaceObjectDefAtLoc(randomtree2ID, 0, 0.50, 0.50);
	}

	// ____________________ Hunts ____________________	
	// Static Herd 
	int statichunt1ID = rmCreateObjectDef("statichunt1 ");
		rmAddObjectDefItem(statichunt1ID, "bighornsheep", rmRandInt(7,8), 4.0);
		rmSetObjectDefMinDistance(statichunt1ID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(statichunt1ID, rmXFractionToMeters(0.0));
		rmSetObjectDefCreateHerd(statichunt1ID, true);
		if (cNumberTeams <= 2)
			rmPlaceObjectDefAtLoc(statichunt1ID, 0, 0.35, 0.65);

	int statichunt2ID = rmCreateObjectDef("statichunt2 ");
		rmAddObjectDefItem(statichunt2ID, "bighornsheep", rmRandInt(7,8), 4.0);
		rmSetObjectDefMinDistance(statichunt2ID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(statichunt2ID, rmXFractionToMeters(0.0));
		rmSetObjectDefCreateHerd(statichunt2ID, true);
		if (cNumberTeams <= 2)
			rmPlaceObjectDefAtLoc(statichunt2ID, 0, 0.65, 0.35);

	if (cNumberNonGaiaPlayers > 4) {
	int statichunt3ID = rmCreateObjectDef("statichunt3 ");
		rmAddObjectDefItem(statichunt3ID, "bighornsheep", rmRandInt(7,8), 4.0);
		rmSetObjectDefMinDistance(statichunt3ID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(statichunt3ID, rmXFractionToMeters(0.0));
		rmSetObjectDefCreateHerd(statichunt3ID, true);
		if (cNumberTeams == 2)
			rmPlaceObjectDefAtLoc(statichunt3ID, 0, 0.30, 0.80);

	int statichunt4ID = rmCreateObjectDef("statichunt4 ");
		rmAddObjectDefItem(statichunt4ID, "bighornsheep", rmRandInt(7,8), 4.0);
		rmSetObjectDefMinDistance(statichunt4ID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(statichunt4ID, rmXFractionToMeters(0.0));
		rmSetObjectDefCreateHerd(statichunt4ID, true);
		if (cNumberTeams == 2)
			rmPlaceObjectDefAtLoc(statichunt4ID, 0, 0.70, 0.20);
	}
	
	// NW Herds
	int elkherdcount = 3+1*cNumberNonGaiaPlayers;
		
	for (i=0; < elkherdcount)
	{
		int NWherdID = rmCreateObjectDef("NW herd"+i);
		rmAddObjectDefItem(NWherdID, "elk", rmRandInt(7,8), 4.0);
		rmSetObjectDefMinDistance(NWherdID, rmXFractionToMeters(0.10));
		rmSetObjectDefMaxDistance(NWherdID, rmXFractionToMeters(0.48));
		rmSetObjectDefCreateHerd(NWherdID, true);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(NWherdID, stayGoldZoneNW);
		rmAddObjectDefConstraint(NWherdID, avoidPlateau1);
		rmAddObjectDefConstraint(NWherdID, avoidPlateau2);
		rmAddObjectDefConstraint(NWherdID, avoidForestMin);
		rmAddObjectDefConstraint(NWherdID, avoidGoldShort);
		rmAddObjectDefConstraint(NWherdID, avoidTownCenterFar); 
		rmAddObjectDefConstraint(NWherdID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(NWherdID, avoidEdge);
		rmAddObjectDefConstraint(NWherdID, avoidElkMed);
		rmAddObjectDefConstraint(NWherdID, avoidSheepMed);
		rmAddObjectDefConstraint(NWherdID, avoidCliff);
		rmAddObjectDefConstraint(NWherdID, avoidIslandShort);
		rmPlaceObjectDefAtLoc(NWherdID, 0, 0.50, 0.50);	
	}

	// SE Herds
	int elkherd2count = 3+1*cNumberNonGaiaPlayers;
		
	for (i=0; < elkherd2count)
	{
		int SEherdID = rmCreateObjectDef("SE herd"+i);
		rmAddObjectDefItem(SEherdID, "elk", rmRandInt(7,8), 4.0);
		rmSetObjectDefMinDistance(SEherdID, rmXFractionToMeters(0.10));
		rmSetObjectDefMaxDistance(SEherdID, rmXFractionToMeters(0.48));
		rmSetObjectDefCreateHerd(SEherdID, true);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(SEherdID, stayGoldZoneSE);
		rmAddObjectDefConstraint(SEherdID, avoidPlateau1);
		rmAddObjectDefConstraint(SEherdID, avoidPlateau2);
		rmAddObjectDefConstraint(SEherdID, avoidForestMin);
		rmAddObjectDefConstraint(SEherdID, avoidGoldShort);
		rmAddObjectDefConstraint(SEherdID, avoidTownCenterFar); 
		rmAddObjectDefConstraint(SEherdID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(SEherdID, avoidEdge);
		rmAddObjectDefConstraint(SEherdID, avoidElkMed);
		rmAddObjectDefConstraint(SEherdID, avoidSheepMed);
		rmAddObjectDefConstraint(SEherdID, avoidCliff);
		rmAddObjectDefConstraint(SEherdID, avoidIslandShort);
		rmPlaceObjectDefAtLoc(SEherdID, 0, 0.50, 0.50);	
	}

	// Random River Herds
	if (cNumberTeams > 2) {
		int elkherd3count = 8+2*cNumberNonGaiaPlayers;
		int huntwater = rmCreateTerrainDistanceConstraint("hunts avoid river", "Land", false, 6.0);
			
		for (i=0; < elkherd3count)
		{
			int lowgroundherdID = rmCreateObjectDef("lowgroundherd"+i);
			rmAddObjectDefItem(lowgroundherdID, "elk", rmRandInt(7,8), 3.0);
			rmSetObjectDefMinDistance(lowgroundherdID, 0.00);
			rmSetObjectDefMaxDistance(lowgroundherdID, rmXFractionToMeters(0.15));
			rmSetObjectDefCreateHerd(lowgroundherdID, true);
			rmAddObjectDefConstraint(lowgroundherdID, avoidForestMin);
			rmAddObjectDefConstraint(lowgroundherdID, avoidGoldShort);
			rmAddObjectDefConstraint(lowgroundherdID, avoidPlateau1); 
			rmAddObjectDefConstraint(lowgroundherdID, avoidPlateau2); 
			rmAddObjectDefConstraint(lowgroundherdID, avoidTradeRouteSocketMin);
			rmAddObjectDefConstraint(lowgroundherdID, avoidEdge);
			rmAddObjectDefConstraint(lowgroundherdID, avoidElkMed);
			rmAddObjectDefConstraint(lowgroundherdID, avoidSheepMed);
			rmAddObjectDefConstraint(lowgroundherdID, huntwater);
			rmAddObjectDefConstraint(lowgroundherdID, avoidCliff);
			rmAddObjectDefConstraint(lowgroundherdID, avoidIslandShort);
			rmAddObjectDefConstraint(lowgroundherdID, avoidGoldZoneNWShort);
			rmAddObjectDefConstraint(lowgroundherdID, avoidGoldZoneSEShort);
			rmPlaceObjectDefAtLoc(lowgroundherdID, 0, 0.50, 0.50);	
		}
	}
	
	// Text
	rmSetStatusText("",0.95);
		
	// ____________________ Treasures ____________________
	int treasure1count = 4+cNumberNonGaiaPlayers;
	int treasure2count = 2+cNumberNonGaiaPlayers;
	int nuggetWater = rmCreateTerrainDistanceConstraint("nuggets avoid river", "Land", false, 6.0);
	
	// Treasures L2	
	for (i=0; < treasure2count)
	{
		int Nugget2ID = rmCreateObjectDef("nugget lvl2 "+i); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.45));
		rmSetNuggetDifficulty(3,4);
		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget2ID, avoidCliff); 
		rmAddObjectDefConstraint(Nugget2ID, avoidIslandShort); 
		rmAddObjectDefConstraint(Nugget2ID, avoidPlateau1); 
		rmAddObjectDefConstraint(Nugget2ID, avoidPlateau2); 
		rmAddObjectDefConstraint(Nugget2ID, nuggetWater); 
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}
	
	// Treasures L1
	for (i=0; < treasure1count)
	{
		int Nugget1ID = rmCreateObjectDef("nugget lvl1 "+i); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, 0);
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.45));
		rmSetNuggetDifficulty(2,3);
		rmAddObjectDefConstraint(Nugget1ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget1ID, avoidIslandShort); 
		rmAddObjectDefConstraint(Nugget1ID, avoidCliff); 
		rmAddObjectDefConstraint(Nugget1ID, avoidPlateau1); 
		rmAddObjectDefConstraint(Nugget1ID, avoidPlateau2); 
		rmAddObjectDefConstraint(Nugget1ID, nuggetWater); 
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);
	}

	// Text
	rmSetStatusText("",1.00);

	
} //END
	
	