// ESOC HIGH PLAINS (1V1, TEAM, FFA)
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
	int playerTiles=11000; //12000
	if (cNumberNonGaiaPlayers >= 4)
		playerTiles=10000;
	if (cNumberNonGaiaPlayers >= 6)
		playerTiles=9000;
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(true);
		
	// Picks a default water height
	rmSetSeaLevel(2.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	// Elevation noise
	rmSetMapElevationParameters(cElevTurbulence, 0.05, 3, 0.45, 4.0); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);
	
	// Picks default terrain and water
	rmSetBaseTerrainMix("great plains drygrass"); // 
	rmTerrainInitialize("great_plains\ground5_gp", 4.0); // texas\ground1_tex
	rmSetMapType("greatPlains"); //greatPlains
	rmSetMapType("land");
	rmSetMapType("grass");
	rmSetMapType("namerica");
	rmSetLightingSet("Great Plains"); // Sonora
	
	// Wind
//	rmSetWindMagnitude(2.0);

	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);
	
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Comanche");
	subCiv1 = rmGetCivID("Cheyenne");
	rmSetSubCiv(0, "Comanche");
	rmSetSubCiv(1, "Cheyenne");
//	rmEchoInfo("subCiv0 is Comanche "+subCiv0);
//	rmEchoInfo("subCiv1 is Cheyenne "+subCiv1);
//	string nativeName0 = "native Comanche village";
//	string nativeName1 = "native Cheyenne village";
	

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classGrass = rmDefineClass("grass");
	int classGeyser = rmDefineClass("geyser");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int importantItem = rmDefineClass("importantItem");
	int classNative = rmDefineClass("natives");
	int classCliff = rmDefineClass("Cliffs");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	
	// ******************************************************************************************
	
	// Text
	rmSetStatusText("",0.20);
	
	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other
   
	// Cardinal Directions & Map placement
	int Southeastconstraint = rmCreatePieConstraint("southeastMapConstraint", 0.5, 0.5, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(115), rmDegreesToRadians(290));
	int Northwestconstraint = rmCreatePieConstraint("northwestMapConstraint", 0.5, 0.5, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(295), rmDegreesToRadians(110));
	
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeFurther = rmCreatePieConstraint("Avoid Edge Further",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.40), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenterShort = rmCreatePieConstraint("Avoid Center Short",0.5,0.5,rmXFractionToMeters(0.20), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.30), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenterMore = rmCreatePieConstraint("Avoid Center More",0.5,0.5,rmXFractionToMeters(0.36), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center More",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.08), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayNEHalf = rmCreatePieConstraint("Stay NE half",0.55,0.55,rmXFractionToMeters(0.00), rmXFractionToMeters(0.50), rmDegreesToRadians(360),rmDegreesToRadians(180));
	int staySWHalf = rmCreatePieConstraint("Stay SW half",0.45,0.45,rmXFractionToMeters(0.00), rmXFractionToMeters(0.50), rmDegreesToRadians(180),rmDegreesToRadians(360));
	
		
	// Resource avoidance
//	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 38.0); //45.0
	int avoidForest = rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 32.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 18.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidForestGeyser=rmCreateClassDistanceConstraint("avoid forest geyser", rmClassID("Forest"), 12.0);
	int avoidPronghornFar = rmCreateTypeDistanceConstraint("avoid Pronghorn far", "Pronghorn", 48.0);
	int avoidPronghorn = rmCreateTypeDistanceConstraint("avoid  Pronghorn", "Pronghorn", 40.0);
	int avoidPronghornShort = rmCreateTypeDistanceConstraint("avoid  Pronghorn short", "Pronghorn", 20.0);
	int avoidPronghornMin = rmCreateTypeDistanceConstraint("avoid Pronghorn min", "Pronghorn", 8.0);
	int avoidBisonMin = rmCreateTypeDistanceConstraint("avoid bison min", "bison", 8.0);
	int avoidBisonShort = rmCreateTypeDistanceConstraint("avoid bison short", "bison", 20.0);
	int avoidBison = rmCreateTypeDistanceConstraint("avoid bison", "bison", 40.0);
	int avoidBisonFar = rmCreateTypeDistanceConstraint("avoid bison far", "bison", 48.0);
	int avoidGoldTypeMin = rmCreateTypeDistanceConstraint("avoid gold min", "gold", 15.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 10.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 30.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 45.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 10.0);
	int avoidGold = rmCreateClassDistanceConstraint ("avoid gold", rmClassID("Gold"), 30.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("avoid gold far", rmClassID("Gold"), 55.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("avoid gold very far ", rmClassID("Gold"), 70.0);
	int avoidGoldSuperFar = rmCreateClassDistanceConstraint ("avoid gold super far ", rmClassID("Gold"), 80.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("avoid nugget short", "AbstractNugget", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("avoid nugget", "AbstractNugget", 40.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("avoid nugget Far", "AbstractNugget", 48.0);
	int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center  Very Far", "townCenter", 72.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 66.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 40.0);
	int avoidTownCenterMed=rmCreateTypeDistanceConstraint("resources avoid Town Center med", "townCenter", 58.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("resources avoid Town Center short", "townCenter", 29.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint("resources avoid Town Center", "townCenter", 40.0);
	int avoidPlayerArea = rmCreateClassDistanceConstraint ("avoid player area", rmClassID("player"), 18.0);
	
	int avoidStartingResources  = rmCreateClassDistanceConstraint("start resources avoid each other", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("start resources avoid each other short", rmClassID("startingResource"), 4.0);
	int avoidCow = rmCreateTypeDistanceConstraint("avoid cow", "cow", 66.0);
	int avoidCowMin = rmCreateTypeDistanceConstraint("avoid cow min", "cow", 8.0);
	

	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandLong=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 25.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 3.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 12.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 10);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 25.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 3.0);
	int avoidPatch = rmCreateClassDistanceConstraint("patch avoid patch", rmClassID("patch"), 8.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("patch avoid patch2", rmClassID("patch2"), 8.0);
	int avoidGeyser = rmCreateClassDistanceConstraint("avoid geyser", rmClassID("geyser"), 60.0);
	int avoidGrass = rmCreateClassDistanceConstraint("grass avoid grass", rmClassID("grass"), 10.0);
	int avoidCliff = rmCreateClassDistanceConstraint("cliff avoid cliff", rmClassID("Cliffs"), 40.0);
	int avoidCliffShort = rmCreateClassDistanceConstraint("cliff avoid cliff short", rmClassID("Cliffs"), 10.0);

	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);
		
	
	// VP avoidance
//	int stayNearTradeRoute = rmCreateTradeRouteMaxDistanceConstraint("stay near trade route", 5.0);
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("avoid trade route", 8.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("avoid trade route short", 5.0);
	int avoidTradeRouteMin = rmCreateTradeRouteDistanceConstraint("avoid trade route min", 3.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route socket short", "socketTradeRoute", 4.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 10.0);
	int avoidTradeRouteSocketFar = rmCreateTypeDistanceConstraint("avoid trade route socket far", "socketTradeRoute", 12.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 10.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid natives short", rmClassID("natives"), 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 8.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("avoid natives far", rmClassID("natives"), 12.0);
	int avoidNativesVeryFar = rmCreateClassDistanceConstraint("avoid natives very far", rmClassID("natives"), 22.0);

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
					rmPlacePlayer(1, 0.18, 0.50);
					rmPlacePlayer(2, 0.82, 0.50);
				}
				else
				{
					rmPlacePlayer(2, 0.18, 0.50);
					rmPlacePlayer(1, 0.82, 0.50);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.688, 0.812); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.188, 0.312); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.655, 0.845); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.155, 0.345); //
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
						rmSetPlacementSection(0.249, 0.251); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmSetPlacementSection(0.688, 0.812); //
						else
							rmSetPlacementSection(0.655, 0.845); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmSetPlacementSection(0.188, 0.312); //
						else
							rmSetPlacementSection(0.155, 0.345); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.749, 0.751); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.688, 0.812); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.155, 0.345); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.655, 0.845); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.188, 0.312); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.155, 0.345); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.655, 0.845); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);
				}
			}
		}
		else // FFA
		{
			rmSetPlacementSection(0.220, 0.780);
			rmSetTeamSpacingModifier(0.25);
			rmPlacePlayersCircular(0.40, 0.40, 0.0);
		}

	
	// **************************************************************************************************

	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.5;
		float yLoc = 0.45;
		float walk = 0.03;

		if (randLoc == 2) {
			xLoc = 0.5;
			yLoc = 0.1;
		} else if (randLoc == 3) {
			xLoc = 0.5;
			yLoc = 0.66;
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

	int tpvariation = -1;
	tpvariation = rmRandInt(0,1);
//	int	tpvariation = 1; // <--- TEST
	if (cNumberTeams > 2 || rmGetIsKOTH())
		tpvariation = 2;
	
	if (tpvariation == 0)
	{
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 0.00); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 0.35); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 0.65); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 1.00); 
	}
	else if (tpvariation == 1)
	{
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 0.00); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 0.35); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 0.65); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 1.00); 
	}
	else
	{
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.15, 0.85); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.25, 0.75); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.55); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.75, 0.75); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.85, 0.85); 
	}
	
	bool placedTradeRouteA = rmBuildTradeRoute(tradeRouteID, "dirt");
//	if(placedTradeRouteA == false)
//	rmEchoError("Failed to place trade route 1");
//	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.08);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.30); // 0.36
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50); // 0.36
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.70); // 0.66
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.92);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	
	
	// *************************************************************************************************************
   	
	// **************************************** NATURE DESIGN & AREAS **********************************************
	
	// Players area
	for (i=1; < cNumberPlayers)
	{
	int playerareaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerareaID);
	rmSetAreaSize(playerareaID, 0.06-0.005*cNumberNonGaiaPlayers, 0.06-0.005*cNumberNonGaiaPlayers);
	rmAddAreaToClass(playerareaID, rmClassID("player"));
	rmSetAreaCoherence(playerareaID, 1.0);
	rmSetAreaWarnFailure(playerareaID, false);
//	rmSetAreaTerrainType(playerareaID, "new_england\ground2_cliff_ne");
	rmSetAreaLocPlayer(playerareaID, i);
	rmBuildArea(playerareaID);
//	int avoidPlayerArea = rmCreateAreaDistanceConstraint("avoid player area "+i, playerareaID, 18.0);
	int stayPlayerArea = rmCreateAreaMaxDistanceConstraint("stay player area "+i, playerareaID, 0.0);
	}
	
//	int avoidPlayerArea1 = rmConstraintID("avoid player area 1");
//	int avoidPlayerArea2 = rmConstraintID("avoid player area 2");
	int stayPlayerArea1 = rmConstraintID("stay player area 1");
	int stayPlayerArea2 = rmConstraintID("stay player area 2");
	
	
	// Green hill zone  
	int hillNorthwestID=rmCreateArea("northwest hills");
	rmSetAreaSize(hillNorthwestID, 0.24, 0.24);
	rmSetAreaWarnFailure(hillNorthwestID, false);
	rmSetAreaMix(hillNorthwestID, "great plains grass");
//	rmSetAreaTerrainType(hillNorthwestID, "great_plains\ground8_gp");
	rmAddAreaTerrainLayer(hillNorthwestID, "great_plains\ground8_gp", 0, 3);
	rmAddAreaTerrainLayer(hillNorthwestID, "great_plains\ground1_gp", 3, 6);
	rmSetAreaElevationType(hillNorthwestID, cElevTurbulence);
	rmSetAreaElevationVariation(hillNorthwestID, 4.0);
	rmSetAreaBaseHeight(hillNorthwestID, 6);
	rmSetAreaElevationMinFrequency(hillNorthwestID, 0.05);
	rmSetAreaElevationOctaves(hillNorthwestID, 3);
	rmSetAreaElevationPersistence(hillNorthwestID, 0.5);      
//	rmSetAreaElevationNoiseBias(hillNorthwestID, 0.5);
//	rmSetAreaElevationEdgeFalloffDist(hillNorthwestID, 20.0);
	rmSetAreaCoherence(hillNorthwestID, 0.50);
	rmSetAreaSmoothDistance(hillNorthwestID, 8);
	rmSetAreaLocation(hillNorthwestID, 0.5, 0.88);
	rmSetAreaEdgeFilling(hillNorthwestID, 5);
	rmAddAreaInfluenceSegment(hillNorthwestID, 0.0, 0.85, 1.0, 0.85);
//	rmSetAreaHeightBlend(hillNorthwestID, 1.9);
	rmSetAreaObeyWorldCircleConstraint(hillNorthwestID, false);
	rmBuildArea(hillNorthwestID);
		
	int avoidNW = rmCreateAreaDistanceConstraint("avoid nw", hillNorthwestID, 3.0);
	int stayNW = rmCreateAreaMaxDistanceConstraint("stay nw", hillNorthwestID, 0.0);
	
	// ********************************************* NATIVES ************************************************

	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
	
	int natAreaA = rmCreateArea("nats area A");
	rmSetAreaWarnFailure(natAreaA, false);
	rmSetAreaSize(natAreaA, 0.045-0.005*cNumberNonGaiaPlayers, 0.045-0.005*cNumberNonGaiaPlayers);
	rmSetAreaCoherence(natAreaA, 0.7);
	rmSetAreaSmoothDistance(natAreaA, 4);
//	rmSetAreaTerrainType(natAreaA, "new_england\ground2_cliff_ne");
	
	int natAreaB = rmCreateArea("nats area B");
	rmSetAreaWarnFailure(natAreaB, false);
	rmSetAreaSize(natAreaB, 0.045-0.005*cNumberNonGaiaPlayers, 0.045-0.005*cNumberNonGaiaPlayers);
	rmSetAreaCoherence(natAreaB, 0.7);
	rmSetAreaSmoothDistance(natAreaB, 4);
//	rmSetAreaTerrainType(natAreaB, "new_england\ground2_cliff_ne");
	
	int natAreaC = rmCreateArea("nats area C");
	rmSetAreaWarnFailure(natAreaC, false);
	rmSetAreaSize(natAreaC, 0.045-0.005*cNumberNonGaiaPlayers, 0.045-0.005*cNumberNonGaiaPlayers);
	rmSetAreaCoherence(natAreaC, 0.7);
	rmSetAreaSmoothDistance(natAreaC, 4);
//	rmSetAreaTerrainType(natAreaC, "new_england\ground2_cliff_ne");
	
	int natAreaD = rmCreateArea("nats area D");
	rmSetAreaWarnFailure(natAreaD, false);
	rmSetAreaSize(natAreaD, 0.045-0.005*cNumberNonGaiaPlayers, 0.045-0.005*cNumberNonGaiaPlayers);
	rmSetAreaCoherence(natAreaD, 0.7);
	rmSetAreaSmoothDistance(natAreaD, 4);
//	rmSetAreaTerrainType(natAreaD, "new_england\ground2_cliff_ne");
	
	
		
	nativeID0 = rmCreateGrouping("Comanche village A", "native Comanche village "+5);
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.4);
	rmAddGroupingConstraint(nativeID0, avoidImpassableLandMed);
	rmAddGroupingConstraint(nativeID0, avoidTradeRouteShort);
	rmAddGroupingConstraint(nativeID0, avoidTradeRouteSocket);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	if (tpvariation == 0)
	{
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.65, 0.30);
		rmSetAreaLocation(natAreaA, 0.65, 0.30);
	}
	else if (tpvariation == 1)
	{
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.35, 0.25);
		rmSetAreaLocation(natAreaA, 0.35, 0.25);
	}
	else 
	{
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.35, 0.35);
		rmSetAreaLocation(natAreaA, 0.35, 0.35);
	}
		
	nativeID2 = rmCreateGrouping("Comanche village B", "native Comanche village "+1);  // +1
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.4);
	rmAddGroupingConstraint(nativeID2, avoidImpassableLandMed);
	rmAddGroupingConstraint(nativeID2, avoidTradeRouteShort);
	rmAddGroupingConstraint(nativeID2, avoidTradeRouteSocket);
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));
	if (tpvariation == 0)
	{
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.35, 0.75);
		rmSetAreaLocation(natAreaB, 0.35, 0.75);
	}
	else if (tpvariation == 1)
	{
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.65, 0.75);
		rmSetAreaLocation(natAreaB, 0.65, 0.75);
	}
	else 
	{
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.65, 0.35);
		rmSetAreaLocation(natAreaB, 0.65, 0.35);
	}
	
	nativeID1 = rmCreateGrouping("Cheyenne village A ", "native Cheyenne village "+5); // +3
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.4);
	rmAddGroupingConstraint(nativeID1, avoidImpassableLandMed);
	rmAddGroupingConstraint(nativeID1, avoidTradeRouteShort);
	rmAddGroupingConstraint(nativeID1, avoidTradeRouteSocket);
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
	if (tpvariation == 0)
	{
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.30, 0.20);
		rmSetAreaLocation(natAreaC, 0.30, 0.20);
	}
	else if (tpvariation == 1)
	{
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.72, 0.20);
		rmSetAreaLocation(natAreaC, 0.72, 0.20);
	}
	else 
	{
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.60, 0.85);
		rmSetAreaLocation(natAreaC, 0.60, 0.85);
	}
	
	nativeID3 = rmCreateGrouping("Cheyenne village B", "native Cheyenne village "+1);
    rmSetGroupingMinDistance(nativeID3, 0.00);
    rmSetGroupingMaxDistance(nativeID3, 0.4);
	rmAddGroupingConstraint(nativeID3, avoidImpassableLandMed);
	rmAddGroupingConstraint(nativeID3, avoidTradeRouteShort);
	rmAddGroupingConstraint(nativeID3, avoidTradeRouteSocket);
	rmAddGroupingToClass(nativeID3, rmClassID("natives"));
	if (tpvariation == 0)
	{
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.70, 0.85);
		rmSetAreaLocation(natAreaD, 0.70, 0.85);
	}
	else if (tpvariation == 1)
	{
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.30, 0.85);
		rmSetAreaLocation(natAreaD, 0.30, 0.85);
	}
	else
	{
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.40, 0.85);
		rmSetAreaLocation(natAreaD, 0.40, 0.85);
	}
	
	rmBuildArea(natAreaA);
	rmBuildArea(natAreaB);
	rmBuildArea(natAreaC);
	rmBuildArea(natAreaD);
	
	int stayInAreaA = rmCreateAreaMaxDistanceConstraint("stay in nat area A", natAreaA, 0.0);
	int stayInAreaB = rmCreateAreaMaxDistanceConstraint("stay in nat area B", natAreaB, 0.0);
	int stayInAreaC = rmCreateAreaMaxDistanceConstraint("stay in nat area C", natAreaC, 0.0);
	int stayInAreaD = rmCreateAreaMaxDistanceConstraint("stay in nat area D", natAreaD, 0.0);
	
	int avoidAreaA = rmCreateAreaDistanceConstraint("avoid nat area A", natAreaA, 2.0);
	int avoidAreaB = rmCreateAreaDistanceConstraint("avoid nat area B", natAreaB, 2.0);
	int avoidAreaC = rmCreateAreaDistanceConstraint("avoid nat area C", natAreaC, 2.0);
	int avoidAreaD = rmCreateAreaDistanceConstraint("avoid nat area D", natAreaD, 2.0);
	
	// ******************************************************************************************************
	
	
	// Cliffs
	int cliffcount = 4+0.5*cNumberNonGaiaPlayers; 
	
	for (i= 0; < cliffcount)
	{
		int cliffID = rmCreateArea("cliff"+i);
		rmAddAreaToClass(cliffID, rmClassID("Cliffs"));
		rmSetAreaSize(cliffID, rmAreaTilesToFraction(360), rmAreaTilesToFraction(360));  
		rmSetAreaMinBlobs(cliffID, 1);
		rmSetAreaMaxBlobs(cliffID, 1);
//		rmSetAreaMinBlobDistance(cliffID, 4.0);
//		rmSetAreaMaxBlobDistance(cliffID, 4.0);
		rmSetAreaWarnFailure(cliffID, true);
		rmSetAreaObeyWorldCircleConstraint(cliffID, false);
		rmSetAreaCliffType(cliffID, "Great Plains"); // new england inland grass
		rmSetAreaCliffPainting(cliffID, false, false, true, 0.1 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	//	rmSetAreaTerrainType(cliffID, "pampas\groundforest_pam", 0, 0);
		rmSetAreaCliffEdge(cliffID, 1, rmRandFloat(0.28, 0.28) , 0.0, 0.0, 1); // rmRandFloat(0.24, 0.28)
		rmSetAreaCliffHeight(cliffID, 3.5, 0.2, 0.4); 
		rmSetAreaHeightBlend(cliffID, 2);
		rmSetAreaCoherence(cliffID, 0.8);
		rmSetAreaSmoothDistance(cliffID, 10);
		rmAddAreaConstraint (cliffID, avoidCliff);
		rmAddAreaConstraint (cliffID, avoidEdge);	
//		rmAddAreaConstraint(cliffID, avoidNativesFar);
		rmAddAreaConstraint(cliffID, avoidTradeRouteSocket);
		rmAddAreaConstraint(cliffID, avoidTradeRouteShort);
		rmAddAreaConstraint (cliffID, avoidPlayerArea);
		rmAddAreaConstraint (cliffID, avoidNW);
//		rmAddAreaConstraint (cliffID, avoidSE);
		rmAddAreaConstraint (cliffID, avoidAreaA);
		rmAddAreaConstraint (cliffID, avoidAreaB);
		rmAddAreaConstraint (cliffID, avoidAreaC);
		rmAddAreaConstraint (cliffID, avoidAreaD);
		rmSetAreaWarnFailure(cliffID, false);
		rmBuildArea(cliffID);		
	}


	// Terrain patch1
	for (i=0; < 10+4*cNumberNonGaiaPlayers)
      {
        int patchID = rmCreateArea("first patch "+i);
        rmSetAreaWarnFailure(patchID, false);
        rmSetAreaSize(patchID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(50));
		rmAddAreaToClass(patchID, classPatch);
//		rmSetAreaMix(patchID, "pampas_grass"); //pampas_grass
        rmSetAreaTerrainType(patchID, "great_plains\ground8_gp");
        rmSetAreaMinBlobs(patchID, 4);
        rmSetAreaMaxBlobs(patchID, 5);
        rmSetAreaMinBlobDistance(patchID, 16.0);
        rmSetAreaMaxBlobDistance(patchID, 40.0);
        rmSetAreaCoherence(patchID, 0.0);
		rmAddAreaConstraint(patchID, avoidImpassableLandShort);
		rmAddAreaConstraint(patchID, avoidPatch);
		rmAddAreaConstraint (patchID, avoidNW);
        rmBuildArea(patchID); 
    }

	
	// Terrain patch NW
	for (i=0; < 8+4*cNumberNonGaiaPlayers)
      {
        int NWpatchID = rmCreateArea("NW patch "+i);
        rmSetAreaWarnFailure(NWpatchID, false);
		rmSetAreaObeyWorldCircleConstraint(NWpatchID, false);
        rmSetAreaSize(NWpatchID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(60));
		rmAddAreaToClass(NWpatchID, classPatch2);
//		rmSetAreaMix(NWpatchID, "pampas_grass"); //pampas_grass
        rmSetAreaTerrainType(NWpatchID, "great_plains\ground5_gp");
        rmSetAreaMinBlobs(NWpatchID, 3);
        rmSetAreaMaxBlobs(NWpatchID, 5);
        rmSetAreaMinBlobDistance(NWpatchID, 16.0);
        rmSetAreaMaxBlobDistance(NWpatchID, 40.0);
        rmSetAreaCoherence(NWpatchID, 0.0);
//		rmAddAreaConstraint(NWpatchID, avoidImpassableLandShort);
		rmAddAreaConstraint(NWpatchID, avoidPatch2);
		rmAddAreaConstraint (NWpatchID, stayNW);
        rmBuildArea(NWpatchID); 
    }
	
	

	// *****************************************************************************************************	
	
	// Text
	rmSetStatusText("",0.30);
	
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
	rmSetObjectDefMinDistance(playergoldID, 16.0);
	rmSetObjectDefMaxDistance(playergoldID, 18.0);
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
	rmSetObjectDefMinDistance(playergold2ID, 18.0); //58
	rmSetObjectDefMaxDistance(playergold2ID, 20.0); //62
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergold2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldType);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	
	// 3nd mine
	int playergold3ID = rmCreateObjectDef("player third mine");
	rmAddObjectDefItem(playergold3ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold3ID, 58.0); //58
	rmSetObjectDefMaxDistance(playergold3ID, 60.0); //62
	rmAddObjectDefToClass(playergold3ID, classStartingResource);
	rmAddObjectDefToClass(playergold3ID, classGold);
	rmAddObjectDefConstraint(playergold3ID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(playergold3ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playergold3ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergold3ID, avoidNatives);
	rmAddObjectDefConstraint(playergold3ID, avoidGoldTypeFar);
	rmAddObjectDefConstraint(playergold3ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold3ID, avoidEdgeMore);
	rmAddObjectDefConstraint(playergold3ID, avoidCenterMore);
	
	// Starting trees1
	int playerTree1ID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTree1ID, "TreeTexasDirt", rmRandInt(1,1), 1.0); //TreeGreatPlains
    rmSetObjectDefMinDistance(playerTree1ID, 10);
    rmSetObjectDefMaxDistance(playerTree1ID, 16);
	rmAddObjectDefToClass(playerTree1ID, classStartingResource);
//	rmAddObjectDefToClass(playerTree1ID, classForest);
//	rmAddObjectDefConstraint(playerTree1ID, avoidForestMin);
	rmAddObjectDefConstraint(playerTree1ID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTree1ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTree1ID, avoidStartingResources);
	
	// Starting trees2
	int playerTree2ID = rmCreateObjectDef("player trees2");
	rmAddObjectDefItem(playerTree2ID, "TreeTexasDirt", rmRandInt(2,2), 2.0); //TreeGreatPlains
    rmSetObjectDefMinDistance(playerTree2ID, 12);
    rmSetObjectDefMaxDistance(playerTree2ID, 18);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
//	rmAddObjectDefToClass(playerTree2ID, classForest);
//	rmAddObjectDefConstraint(playerTree2ID, avoidForestMin);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTree2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResources);
	
	// Starting herd
	int playerherdID = rmCreateObjectDef("starting herd");
//	rmAddObjectDefItem(playerherdID, "bison", rmRandInt(2,2), 3.0);
	rmAddObjectDefItem(playerherdID, "bison", rmRandInt(4,4), 4.0);
	rmSetObjectDefMinDistance(playerherdID, 10.0);
	rmSetObjectDefMaxDistance(playerherdID, 14.0);
	rmSetObjectDefCreateHerd(playerherdID, false);
	rmAddObjectDefToClass(playerherdID, classStartingResource);
	rmAddObjectDefConstraint(playerherdID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerherdID, avoidNatives);
	rmAddObjectDefConstraint(playerherdID, avoidStartingResourcesShort);
		
	// 2nd herd
	int playerbisonID = rmCreateObjectDef("player bison");
    rmAddObjectDefItem(playerbisonID, "bison", rmRandInt(12,12), 10.0);
    rmSetObjectDefMinDistance(playerbisonID, 37);
    rmSetObjectDefMaxDistance(playerbisonID, 39);
	rmSetObjectDefCreateHerd(playerbisonID, true);
	rmAddObjectDefConstraint(playerbisonID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playerbisonID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerbisonID, avoidNativesShort);
//	rmAddObjectDefConstraint(playerbisonID, avoidStartingResources);
	rmAddObjectDefConstraint(playerbisonID, avoidBison); 
	rmAddObjectDefConstraint(playerbisonID, avoidPronghornShort);
//	rmAddObjectDefConstraint(playerbisonID, avoidCenterMore);
	rmAddObjectDefConstraint(playerbisonID, avoidEdge);
	
	// 3rd herd
	int playerPronghornID = rmCreateObjectDef("player pronghorn");
    rmAddObjectDefItem(playerPronghornID, "Pronghorn", rmRandInt(9,9), 8.0);
    rmSetObjectDefMinDistance(playerPronghornID, 45);
    rmSetObjectDefMaxDistance(playerPronghornID, 47);
	rmSetObjectDefCreateHerd(playerPronghornID, true);
	rmAddObjectDefConstraint(playerPronghornID, avoidBison); 
	rmAddObjectDefConstraint(playerPronghornID, avoidPronghorn);
//	rmAddObjectDefConstraint(playerPronghornID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(playerPronghornID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerPronghornID, avoidNativesShort);
//	rmAddObjectDefConstraint(playerPronghornID, avoidCenterShort);
//	rmAddObjectDefConstraint(playerPronghornID, avoidStartingResources);
//	rmAddObjectDefConstraint(playerPronghornID, avoidEdge);

	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 30.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	int nugget0count = rmRandInt (2,2); // 1,2
	
	// ******** Place ********
	
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playergold3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree1ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree1ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree1ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		
		rmPlaceObjectDefAtLoc(playerbisonID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerPronghornID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if (nugget0count == 2)
			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
				
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
	rmSetStatusText("",0.40);
	
	// ************************************** COMMON RESOURCES ****************************************
  
   
	// ********** Mines ***********
	
	int goldCount = 4+2*cNumberNonGaiaPlayers;  // 3,3 
		
	//Mines
	for(i=0; < goldCount)
	{
		int goldID = rmCreateObjectDef("gold"+i);
		rmAddObjectDefItem(goldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(goldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(goldID, classGold);
		rmAddObjectDefConstraint(goldID, avoidTradeRouteSocketFar);
		rmAddObjectDefConstraint(goldID, avoidTradeRoute);
		rmAddObjectDefConstraint(goldID, avoidImpassableLand);
		rmAddObjectDefConstraint(goldID, avoidNatives);
		rmAddObjectDefConstraint(goldID, avoidGoldVeryFar);
//		rmAddObjectDefConstraint(goldID, Northwestconstraint);
		rmAddObjectDefConstraint(goldID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(goldID, avoidEdge);
		rmPlaceObjectDefAtLoc(goldID, 0, 0.50, 0.50);
	}
	
	// ****************************
	
	// Text
	rmSetStatusText("",0.60);
			
	// *********** Forests ************

	int dirtforestcount = 8+4*cNumberNonGaiaPlayers;
	int greenforestcount = 4+1*cNumberNonGaiaPlayers;
	int greenforestsmallcount = 3+1*cNumberNonGaiaPlayers;
	
	// Green forests big
	for (i=0; < greenforestcount)
	{
		int greenforestID = rmCreateArea("forest green"+i);
		rmSetAreaWarnFailure(greenforestID, false);
		rmSetAreaSize(greenforestID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(170));
		rmSetAreaForestType(greenforestID, "great plains forest");
//		rmSetAreaObeyWorldCircleConstraint(greenforestID, false);
		rmSetAreaTerrainType(greenforestID, "great_plains\groundforest_gp");
		rmSetAreaForestDensity(greenforestID, 0.85);
		rmSetAreaForestClumpiness(greenforestID, 0.25);
		rmSetAreaForestUnderbrush(greenforestID, 0.5);
		rmSetAreaMinBlobs(greenforestID, 2);
		rmSetAreaMaxBlobs(greenforestID, 4);
		rmSetAreaMinBlobDistance(greenforestID, 10.0);
		rmSetAreaMaxBlobDistance(greenforestID, 28.0);
		rmSetAreaCoherence(greenforestID, 0.8);
		rmSetAreaSmoothDistance(greenforestID, 6);
		rmAddAreaToClass(greenforestID, classForest);
		rmAddAreaConstraint(greenforestID, avoidTownCenterShort);
		rmAddAreaConstraint(greenforestID, avoidForest);
		rmAddAreaConstraint(greenforestID, avoidTradeRoute);
		rmAddAreaConstraint(greenforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(greenforestID, avoidImpassableLand);
		rmAddAreaConstraint(greenforestID, avoidNatives);	
		rmAddAreaConstraint(greenforestID, avoidGoldMin);
		rmAddAreaConstraint(greenforestID, avoidPronghornMin);
		rmAddAreaConstraint(greenforestID, avoidBisonMin);
		rmAddAreaConstraint(greenforestID, stayNW);
		rmBuildArea(greenforestID);
	}
	
	// Green forests small
	for (i=0; < greenforestsmallcount)
	{
		int greenforestsmallID = rmCreateArea("forest green small"+i);
		rmSetAreaWarnFailure(greenforestsmallID, false);
		rmSetAreaSize(greenforestsmallID, rmAreaTilesToFraction(70), rmAreaTilesToFraction(80));
		rmSetAreaForestType(greenforestsmallID, "great plains forest");
//		rmSetAreaObeyWorldCircleConstraint(greenforestsmallID, false);
		rmSetAreaForestDensity(greenforestsmallID, 0.70);
		rmSetAreaForestClumpiness(greenforestsmallID, 0.30);
		rmSetAreaForestUnderbrush(greenforestsmallID, 0.5);
		rmSetAreaMinBlobs(greenforestsmallID, 2);
		rmSetAreaMaxBlobs(greenforestsmallID, 4);
		rmSetAreaMinBlobDistance(greenforestsmallID, 10.0);
		rmSetAreaMaxBlobDistance(greenforestsmallID, 28.0);
		rmSetAreaCoherence(greenforestsmallID, 0.8);
		rmSetAreaSmoothDistance(greenforestsmallID, 6);
		rmAddAreaToClass(greenforestsmallID, classForest);
		rmAddAreaConstraint(greenforestsmallID, avoidTownCenterShort);
		rmAddAreaConstraint(greenforestsmallID, avoidForestShort);
		rmAddAreaConstraint(greenforestsmallID, avoidTradeRoute);
		rmAddAreaConstraint(greenforestsmallID, avoidTradeRouteSocket);
		rmAddAreaConstraint(greenforestsmallID, avoidImpassableLand);
		rmAddAreaConstraint(greenforestsmallID, avoidNatives);	
		rmAddAreaConstraint(greenforestsmallID, avoidGoldMin);
		rmAddAreaConstraint(greenforestsmallID, avoidPronghornMin);
		rmAddAreaConstraint(greenforestsmallID, avoidBisonMin);
		rmAddAreaConstraint(greenforestsmallID, stayNW);
		rmBuildArea(greenforestsmallID);
	}
			
	// Forests dirt
	int stayInDirtforest = -1;
	
	for (i=0; < dirtforestcount)
	{
		int dirtforestID = rmCreateArea("forest dirt"+i);
		rmSetAreaWarnFailure(dirtforestID, false);
		rmSetAreaSize(dirtforestID, rmAreaTilesToFraction(90), rmAreaTilesToFraction(100));
//		rmSetAreaObeyWorldCircleConstraint(dirtforestID, false);
		rmSetAreaMinBlobs(dirtforestID, 2);
		rmSetAreaMaxBlobs(dirtforestID, 4);
		rmSetAreaMinBlobDistance(dirtforestID, 10.0);
		rmSetAreaMaxBlobDistance(dirtforestID, 28.0);
		rmSetAreaCoherence(dirtforestID, 0.8);
		rmSetAreaSmoothDistance(dirtforestID, 6);
		rmSetAreaTerrainType(dirtforestID, "great_plains\ground3_gp");
		rmAddAreaToClass(dirtforestID, classForest);
		rmAddAreaConstraint(dirtforestID, avoidForest);
		rmAddAreaConstraint(dirtforestID, avoidTradeRoute);
		rmAddAreaConstraint(dirtforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(dirtforestID, avoidImpassableLand);
		rmAddAreaConstraint(dirtforestID, avoidNatives);	
		rmAddAreaConstraint(dirtforestID, avoidGoldMin);
		rmAddAreaConstraint(dirtforestID, avoidPronghornMin);
		rmAddAreaConstraint(dirtforestID, avoidBisonMin);
		rmAddAreaConstraint(dirtforestID, avoidNW);
		rmAddAreaConstraint(dirtforestID, avoidTownCenterShort);
		rmBuildArea(dirtforestID);
		
		stayInDirtforest = rmCreateAreaMaxDistanceConstraint("stay in dirt forest"+i, dirtforestID, 0);
		
		for (j=0; < rmRandInt(8,10))
		{
			int dirtforesttreeID = rmCreateObjectDef("dirt forest trees"+i+j);
			rmAddObjectDefItem(dirtforesttreeID, "TreeTexasDirt", rmRandInt(1,2), 2.0);
			rmSetObjectDefMinDistance(dirtforesttreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(dirtforesttreeID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(dirtforesttreeID, classForest);
		//	rmAddObjectDefConstraint(dirtforesttreeID, avoidForestShort);
			rmAddObjectDefConstraint(dirtforesttreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(dirtforesttreeID, stayInDirtforest);	
			rmPlaceObjectDefAtLoc(dirtforesttreeID, 0, 0.50, 0.50);
		}
	}
/*		
	//Tree clumps to fill the void 
	int voidtreeID = rmCreateObjectDef("void tree");
	rmAddObjectDefItem(voidtreeID, "TreeTexasDirt", rmRandInt(7,9), 7.0); //TreeGreatPlains
    rmSetObjectDefMinDistance(voidtreeID, 0);
    rmSetObjectDefMaxDistance(voidtreeID, 30);
	rmAddObjectDefToClass(voidtreeID, classForest);
	rmAddObjectDefConstraint(voidtreeID, avoidForestShort);
	rmAddObjectDefConstraint(voidtreeID, avoidTradeRoute);
	rmAddObjectDefConstraint(voidtreeID, avoidTradeRouteSocket);
    rmAddObjectDefConstraint(voidtreeID, avoidNatives);
	rmAddObjectDefConstraint(voidtreeID, avoidGoldMin);
	rmAddObjectDefConstraint(voidtreeID, avoidStartingResources);
	rmPlaceObjectDefAtLoc(voidtreeID, 0, 0.60, 0.60);
	rmPlaceObjectDefAtLoc(voidtreeID, 0, 0.40, 0.60);
*/	

	// ********************************
	
		// ********** Herds ***********
		
	int bisoncount = 1+2*cNumberNonGaiaPlayers;
	int pronghorncount = 1+1*cNumberNonGaiaPlayers;
	
	
	for(i=0; < bisoncount)
	{
	
		//Bisons
		int bisonID = rmCreateObjectDef("bison"+i);
		rmAddObjectDefItem(bisonID, "bison", rmRandInt(11,12), 10.0);
		rmSetObjectDefMinDistance(bisonID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(bisonID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(bisonID, true);
		rmAddObjectDefConstraint(bisonID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(bisonID, avoidNativesShort);
		rmAddObjectDefConstraint(bisonID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(bisonID, avoidGoldMin);
		rmAddObjectDefConstraint(bisonID, avoidForestMin); 
		rmAddObjectDefConstraint(bisonID, avoidTownCenterFar);
		rmAddObjectDefConstraint(bisonID, avoidPronghornFar); 
		rmAddObjectDefConstraint(bisonID, avoidBisonFar); 
	//	rmAddObjectDefConstraint(bisonID, avoidEdge);
		rmPlaceObjectDefAtLoc(bisonID, 0, 0.50, 0.50);
	}

		for(i=0; < pronghorncount)
	{
		//Pronghorns
		int pronghornID = rmCreateObjectDef("pronghorn"+i);
		rmAddObjectDefItem(pronghornID, "pronghorn", rmRandInt(8,9), 8.0);
		rmSetObjectDefMinDistance(pronghornID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(pronghornID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(pronghornID, true);
		rmAddObjectDefConstraint(pronghornID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(pronghornID, avoidNativesShort);
		rmAddObjectDefConstraint(pronghornID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(pronghornID, avoidGoldMin);
		rmAddObjectDefConstraint(pronghornID, avoidForestMin);
		rmAddObjectDefConstraint(pronghornID, avoidTownCenterFar);
		rmAddObjectDefConstraint(pronghornID, avoidPronghornFar); 
		rmAddObjectDefConstraint(pronghornID, avoidBisonFar); 
	//	rmAddObjectDefConstraint(pronghornID, avoidEdge);
		rmPlaceObjectDefAtLoc(pronghornID, 0, 0.50, 0.50);
	}
	
	// ********************************
		
		
	
	// Text
	rmSetStatusText("",0.70);
	
	// ********** Treasures ***********
	
	int nugget2count = 6+1*cNumberNonGaiaPlayers;
	int nugget3count = 1+0.5*cNumberNonGaiaPlayers;
	int nugget4count = 0.35*cNumberNonGaiaPlayers;
	
	// Treasures lvl4	
	int Nugget4ID = rmCreateObjectDef("nugget lvl4"); 
	rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget4ID, 0);
    rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.6));
	rmAddObjectDefConstraint(Nugget4ID, avoidNuggetFar);
	rmAddObjectDefConstraint(Nugget4ID, avoidNatives);
	rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLand);
	rmAddObjectDefConstraint(Nugget4ID, avoidGoldTypeMin);
	rmAddObjectDefConstraint(Nugget4ID, avoidTownCenterVeryFar);
	rmAddObjectDefConstraint(Nugget4ID, avoidPronghornMin); 
	rmAddObjectDefConstraint(Nugget4ID, avoidBisonMin);
	rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);	
	rmAddObjectDefConstraint(Nugget4ID, avoidEdgeMore);
	rmAddObjectDefConstraint(Nugget4ID, avoidKingsHill);
		
		for (i=0; < nugget4count)
	{
		rmSetNuggetDifficulty(4,4);
		if (cNumberNonGaiaPlayers >= 4)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.50, 0.50);
	}
	
	// Treasures lvl3	
	int Nugget3ID = rmCreateObjectDef("nugget lvl3"); 
	rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget3ID, 0);
    rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.6));
	rmAddObjectDefConstraint(Nugget3ID, avoidNuggetFar);
	rmAddObjectDefConstraint(Nugget3ID, avoidNatives);
	rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLand);
	rmAddObjectDefConstraint(Nugget3ID, avoidGoldTypeMin);
	rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterVeryFar);
	rmAddObjectDefConstraint(Nugget3ID, avoidPronghornMin); 
	rmAddObjectDefConstraint(Nugget3ID, avoidBisonMin);
	rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
	rmAddObjectDefConstraint(Nugget3ID, avoidEdgeMore);
	rmAddObjectDefConstraint(Nugget3ID, avoidKingsHill);
		
		for (i=0; < nugget3count)
	{
		rmSetNuggetDifficulty(3,3);
		rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50);
	}
	
	// Treasures lvl2	
	int Nugget2ID = rmCreateObjectDef("nugget lvl2"); 
	rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget2ID, 0);
    rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.6));
	rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
	rmAddObjectDefConstraint(Nugget2ID, avoidNatives);
	rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(Nugget2ID, avoidGoldTypeMin);
	rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
	rmAddObjectDefConstraint(Nugget2ID, avoidPronghornMin); 
	rmAddObjectDefConstraint(Nugget2ID, avoidBisonMin);
	rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
	rmAddObjectDefConstraint(Nugget2ID, avoidEdgeMore);
	rmAddObjectDefConstraint(Nugget2ID, avoidKingsHill);
		
		for (i=0; < nugget2count)
	{
		rmSetNuggetDifficulty(2,2);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}

	// ********************************
	
	// Text
	rmSetStatusText("",0.80);
	
/*	// ************ Cows *************
	
	int cowcount = 4;
	for (i=0; <cowcount)
	{
	int CowID = rmCreateObjectDef("cow"+i);
	rmAddObjectDefItem(CowID, "cow", 2, 4.0);
	rmSetObjectDefMinDistance(CowID, 0.0);
	rmSetObjectDefMaxDistance(CowID, rmXFractionToMeters(0.6));
	rmAddObjectDefConstraint(CowID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(CowID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(CowID, avoidNatives);
	rmAddObjectDefConstraint(CowID, avoidEdge);
	rmAddObjectDefConstraint(CowID, avoidNuggetMin);
//	rmAddObjectDefConstraint(CowID, avoidCow);
	rmAddObjectDefConstraint(CowID, avoidTownCenterMed);
	rmAddObjectDefConstraint(CowID, avoidForestMin);
	if (i==0)
		rmAddObjectDefConstraint(CowID, stayInAreaA);
	else if (i==1)
		rmAddObjectDefConstraint(CowID, stayInAreaB);
	else if (i==2)
		rmAddObjectDefConstraint(CowID, stayInAreaC);
	else
		rmAddObjectDefConstraint(CowID, stayInAreaD);
	rmPlaceObjectDefAtLoc(CowID, 0, 0.5, 0.5);
	}
	
*/	// ******** Embellishments ********
	
	// Skulls
	int skullID = rmCreateObjectDef("skull");
	rmAddObjectDefItem(skullID, "skulls", rmRandInt(1,2), 2.0);
	rmSetObjectDefMinDistance(skullID, 4);
	rmSetObjectDefMaxDistance(skullID, 6);
	rmAddObjectDefConstraint(skullID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(skullID, avoidForestMin);
	rmAddObjectDefConstraint(skullID, avoidGoldMin);
		
	vector skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.10, 0.15));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.20, 0.25));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.30, 0.35));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.40, 0.45));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.50, 0.55));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.60, 0.65));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.70, 0.75));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.80, 0.85));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.90, 0.95));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);
		
	
	//Geysers

		int geyserID=rmCreateGrouping("Geyser"+i, "prop_geyser");
		rmSetGroupingMinDistance(geyserID, 0.0);
		rmSetGroupingMaxDistance(geyserID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(geyserID, avoidTradeRouteSocketShort);
		rmAddGroupingConstraint(geyserID, avoidNuggetMin);
		rmAddGroupingConstraint(geyserID, avoidCowMin);
		rmAddGroupingConstraint(geyserID, avoidTradeRouteShort);
		rmAddGroupingConstraint(geyserID, avoidTradeRouteSocket);
		rmAddGroupingConstraint(geyserID, avoidNativesFar);
		rmAddGroupingConstraint(geyserID, avoidGoldTypeMin);
		rmAddGroupingConstraint(geyserID, avoidTownCenter);
		rmAddGroupingConstraint(geyserID, avoidPronghornMin); 
		rmAddGroupingConstraint(geyserID, avoidBisonMin);
		rmAddGroupingConstraint(geyserID, avoidForestGeyser);	
		rmAddGroupingConstraint(geyserID, avoidGeyser); 
		rmAddGroupingConstraint(geyserID, avoidImpassableLand); 
		rmAddGroupingConstraint(geyserID, stayNEHalf);
		rmAddGroupingConstraint(geyserID, avoidEdgeMore); 
		rmAddGroupingConstraint(geyserID, avoidNW);
		rmPlaceGroupingAtLoc(geyserID, 0, 0.5, 0.5, 2);	


		int geyser2ID=rmCreateGrouping("Geyser 2"+i, "prop_geyser");
		rmSetGroupingMinDistance(geyser2ID, 0.0);
		rmSetGroupingMaxDistance(geyser2ID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(geyser2ID, avoidTradeRouteSocketShort);
		rmAddGroupingConstraint(geyser2ID, avoidNuggetMin);
		rmAddGroupingConstraint(geyser2ID, avoidCowMin);
		rmAddGroupingConstraint(geyser2ID, avoidTradeRouteShort);
		rmAddGroupingConstraint(geyser2ID, avoidTradeRouteSocket);
		rmAddGroupingConstraint(geyser2ID, avoidNativesFar);
		rmAddGroupingConstraint(geyser2ID, avoidGoldTypeMin);
		rmAddGroupingConstraint(geyser2ID, avoidTownCenter);
		rmAddGroupingConstraint(geyser2ID, avoidPronghornMin); 
		rmAddGroupingConstraint(geyser2ID, avoidBisonMin);
		rmAddGroupingConstraint(geyser2ID, avoidForestGeyser);	
		rmAddGroupingConstraint(geyser2ID, avoidGeyser); 
		rmAddGroupingConstraint(geyser2ID, avoidImpassableLand); 
		rmAddGroupingConstraint(geyser2ID, staySWHalf);
		rmAddGroupingConstraint(geyser2ID, avoidEdgeMore); 
		rmAddGroupingConstraint(geyser2ID, avoidNW);
		rmPlaceGroupingAtLoc(geyser2ID, 0, 0.5, 0.5, 2);



	// Text
	rmSetStatusText("",0.99);

	
} //END
	
	