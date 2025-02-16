// ESOC ARIZONA
// designed by Garja
// observer UI by Aizamk

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void) 
{

	// Text
	rmSetStatusText("",0.10);

	// Picks the map size
	int playerTiles = 10500;
	if (cNumberNonGaiaPlayers >= 4)
		playerTiles = 10000;
	if (cNumberNonGaiaPlayers >= 6)
		playerTiles = 9500;
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.5, 3.0);  // original
	rmSetMapElevationParameters(cElevTurbulence,  0.06, 2, 0.45, 3.5); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);

	// Picks a default water height
	rmSetSeaLevel(4.0);


//	rmSetBaseTerrainMix("painteddesert_groundmix_4"); //
	rmTerrainInitialize("texas\ground3_tex", 2.0); //painteddesert\pd_ground_diffuse_i
	rmSetMapType("arizona");
	rmSetMapType("desert");
	rmSetMapType("land");
	rmSetMapType("namerica");
	rmSetLightingSet("pampas");
	
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Navajo");
	subCiv1 = rmGetCivID("Apache");
	rmSetSubCiv(0, "Navajo");
	rmSetSubCiv(1, "Apache");

	// Choose mercs.
	chooseMercs();

	// Corner constraint.
	rmSetWorldCircleConstraint(true);
	
	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	int classEmbellishment = rmDefineClass("Embellishment");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int classForestBig = rmDefineClass("ForestBig");
	int importantItem = rmDefineClass("importantItem");
	int classNative = rmDefineClass("natives");
	int classCliff = rmDefineClass("Cliffs");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");

	
	// ************************************ CONSTRAINTS *****************************************
	
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint(" avoid trade route", 10.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 3.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "ypTradingPostCapture", 10.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route socket short", "ypTradingPostCapture", 4.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", importantItem, 10.0);
	int mesaavoidTradeRoute = rmCreateTradeRouteDistanceConstraint("mesa avoid trade route", 1+0.5*cNumberNonGaiaPlayers);
	int mesaavoidTradeRouteSocket = rmCreateTypeDistanceConstraint("mesa avoid trade route socket", "ypTradingPostCapture", 7.0);

	// Coordinates and directions constraints
	int stayNorthHalf = rmCreatePieConstraint("NorthHalfConstraint", 0.50, 0.50, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(315), rmDegreesToRadians(135));
	int staySouthHalf = rmCreatePieConstraint("SouthHalfConstraint", 0.50, 0.50, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(135), rmDegreesToRadians(315));
	int stayWestHalf = rmCreatePieConstraint("WestHalfConstraint", 0.50, 0.50, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(240), rmDegreesToRadians(30));
	int stayEastHalf = rmCreatePieConstraint("EastHalfConstraint", 0.50, 0.50, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(60), rmDegreesToRadians(210));
	
	int avoidCenter = rmCreatePieConstraint("Avoid Center", 0.50, 0.50, rmZFractionToMeters(0.35), rmZFractionToMeters(0.50), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int avoidEdge = rmCreatePieConstraint("Avoid Edge", 0.50, 0.50, 0.0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
	
	// Resource avoidance
	int avoidForestBig=rmCreateClassDistanceConstraint("avoid forest big", classForestBig, 50.0+2*cNumberNonGaiaPlayers); //15.0
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", classForest, 42.0); //15.0
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", classForest, 42.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest  short", classForest, 24.0); //15.0
	int avoidForestVeryShort=rmCreateClassDistanceConstraint("avoid forest very short", classForest, 10.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", classForest, 4.0);
//	int cliffConstraint=rmCreateClassDistanceConstraint("cliff vs. cliff", classCliff, 35.0);
	int avoidCliff = rmCreateClassDistanceConstraint("stuff vs. cliff", classCliff, 6.0);
//	int shortAvoidCliff=rmCreateClassDistanceConstraint("short stuff vs. cliff", classCliff, 8.0);
	int avoidPronghornFar = rmCreateTypeDistanceConstraint("avoid food far", "pronghorn", 50.0);
	int avoidPronghorn = rmCreateTypeDistanceConstraint("avoid food", "pronghorn", 40.0);
	int avoidPronghornMed = rmCreateTypeDistanceConstraint("avoid food med", "pronghorn", 30.0);
	int avoidPronghornMin = rmCreateTypeDistanceConstraint("avoid food min", "pronghorn", 8.0);
	int avoidBisonFar = rmCreateTypeDistanceConstraint("avoid bison far", "bison", (55.0-2*cNumberNonGaiaPlayers));
	int avoidBison = rmCreateTypeDistanceConstraint("avoid bison", "bison", 48.0);
	int avoidBisonShort = rmCreateTypeDistanceConstraint("avoid bison short", "bison", 28.0);
	int avoidBisonMin = rmCreateTypeDistanceConstraint("avoid bison min", "bison", 10.0);
//	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 30.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 10.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 35.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 60.0);
	int avoidGoldMed = rmCreateClassDistanceConstraint ("avoid gold med", classGold, 14.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("avoid gold far", classGold, (66.0-2*cNumberNonGaiaPlayers));
	int avoidGoldShort = rmCreateClassDistanceConstraint ("avoid gold short", classGold, 8.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", (60.0-1*cNumberNonGaiaPlayers));
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 40.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 58.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 26.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 60.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("avoid natives far", classNative, 18.0);
	int avoidNatives = rmCreateClassDistanceConstraint("avoid natives", classNative, 8.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid natives short", classNative, 5.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint(" avoid starting resources", classStartingResource, 8.0);
	int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("avoid starting resources short", classStartingResource, 3.0);
	int avoidEmbellishment = rmCreateClassDistanceConstraint("avoid embellishment", classEmbellishment, 5.0);
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", classPatch, 40.0+2*cNumberNonGaiaPlayers);
	int avoidPatchShort = rmCreateClassDistanceConstraint(" avoid patch short", classPatch, 12.0);
	int avoidPatchMin = rmCreateClassDistanceConstraint(" avoid patch min", classPatch, 5.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch 2", classPatch2, 10.0+2*cNumberNonGaiaPlayers);

	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 5.0);
	int avoidImpassableLandLong=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 25.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 3.0);
	int mediumAvoidImpassableLand=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 15.0);
	int mediumShortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("mediumshort avoid impassable land", "Land", false, 10.0);
	int buildMesaNorth = rmCreatePieConstraint("NorthMesaConstraint", 0.52, 0.52, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(315), rmDegreesToRadians(135));
	int buildMesaSouth = rmCreatePieConstraint("SouthMesaConstraint", 0.48, 0.48, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(135), rmDegreesToRadians(315));

	// *****************************************************************************************
	
	// Text
	rmSetStatusText("",0.20);

	// ************************************* PLACE PLAYERS *************************************

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
					rmPlacePlayer(1, 0.26, 0.26);
					rmPlacePlayer(2, 0.74, 0.74);
				}
				else
				{
					rmPlacePlayer(2, 0.26, 0.26);
					rmPlacePlayer(1, 0.74, 0.74);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.02, 0.23); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.52, 0.73); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);
				}
				else // 3v3, 4v4
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

	
	// *******************************************************************************************
   
	// Text
	rmSetStatusText("",0.30);
	
	// ************************************** TRADE ROUTE ****************************************
		
		int traderoutevariation = -1;
		traderoutevariation = rmRandInt (0,1);
	
		int tradeRouteID = rmCreateTradeRoute();
		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
		rmAddObjectDefItem(socketID, "ypTradingPostCapture", 1, 0.0);
		rmSetObjectDefAllowOverlap(socketID, true);
		rmSetObjectDefMinDistance(socketID, 0.0);
		rmSetObjectDefMaxDistance(socketID, 8.0);
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		
	if (cNumberTeams <3 && rmGetIsKOTH() == false) // TEAM
	{	
			rmAddTradeRouteWaypoint(tradeRouteID, 0.90, 0.08); 
			if (traderoutevariation == 0)
			{
				rmAddTradeRouteWaypoint(tradeRouteID, 0.80, 0.08);
				rmAddTradeRouteWaypoint(tradeRouteID, rmRandFloat(0.64,0.66), rmRandFloat(0.43,0.45));
				rmAddTradeRouteWaypoint(tradeRouteID, rmRandFloat(0.34,0.36), rmRandFloat(0.55,0.57));
				rmAddTradeRouteWaypoint(tradeRouteID, 0.18, 0.90);
			}
			else
			{
				rmAddTradeRouteWaypoint(tradeRouteID, 0.90, 0.18);
				rmAddTradeRouteWaypoint(tradeRouteID, rmRandFloat(0.55,0.57), rmRandFloat(0.34,0.36)); // 0.55,0.57 0.34,0.36
				rmAddTradeRouteWaypoint(tradeRouteID, rmRandFloat(0.43,0.45), rmRandFloat(0.64,0.66)); // 0.43,0.45 0.64,0.66
				rmAddTradeRouteWaypoint(tradeRouteID, 0.08, 0.80);
			}
			rmAddTradeRouteWaypoint(tradeRouteID, 0.08, 0.90); 

		
		bool placedTradeRouteA = rmBuildTradeRoute(tradeRouteID, "dirt");
	//	if(placedTradeRouteA == false)
	//	rmEchoError("Failed to place trade route 1");
	//	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		
		
		vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.14);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		if (cNumberNonGaiaPlayers >= 6)
		{
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.26);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.37);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.63);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		if (cNumberNonGaiaPlayers >= 6)
		{
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.74);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.86);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		
	
	}
	else // FFA
	{	
		float TPspacing = 0.17;
		float TPa = rmRandFloat(0.01,0.10);
		float TPb = TPa+TPspacing;
		float TPc = TPb+TPspacing;
		float TPd = TPc+TPspacing;
		float TPe = TPd+TPspacing;
		float TPf = TPe+TPspacing;
		
		rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.65); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.70, 0.50);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.35);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.30);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.35); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.30, 0.50);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.65);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.70);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.65); 

		rmBuildTradeRoute(tradeRouteID, "dirt");
		if (cNumberNonGaiaPlayers < 5)
		{
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.01);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.25);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.75);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
		else
		{
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, TPa);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, TPb);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, TPc);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, TPd);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, TPe);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, TPf);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			
		}
	}
	
	
	// ******************************** LAYOUT AND DESIGN *************************************
	


	//Diffused grass 
	int grassareaID = rmCreateArea("grass area");
	rmSetAreaSize(grassareaID, 1.00, 1.00);
	rmSetAreaLocation(grassareaID, 0.50, 0.50);
	rmSetAreaObeyWorldCircleConstraint(grassareaID, false);
	rmSetAreaMix(grassareaID, "texas_dirt");
//	rmAddAreaConstraint(grassareaID, avoidTradeRouteShort);
	rmBuildArea(grassareaID);
		
	// Players area
	for (i=1; < cNumberPlayers)
	{
	int playerareaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerareaID);
	rmSetAreaSize(playerareaID, 0.06-0.005*cNumberNonGaiaPlayers, 0.06-0.005*cNumberNonGaiaPlayers);
	rmAddAreaToClass(playerareaID, classPlayer);
	rmSetAreaCoherence(playerareaID, 1.0);
	rmSetAreaWarnFailure(playerareaID, false);
//	rmSetAreaTerrainType(playerareaID, "new_england\ground2_cliff_ne");
	rmSetAreaLocPlayer(playerareaID, i);
	rmBuildArea(playerareaID);
	int stayPlayerArea = rmCreateAreaMaxDistanceConstraint("stay player area "+i, playerareaID, 0.0);
	}
	
	int avoidPlayerArea = rmCreateClassDistanceConstraint ("avoid player area", classPlayer, 24.0+2*cNumberNonGaiaPlayers);
	int stayPlayerArea1 = rmConstraintID("stay player area 1");
	int stayPlayerArea2 = rmConstraintID("stay player area 2");
	
	
	//Mesas
	int mesasurfaceID = rmCreateArea("mesa surface");
	rmSetAreaSize(mesasurfaceID, rmAreaTilesToFraction(220*cNumberPlayers), rmAreaTilesToFraction(220*cNumberPlayers));  
	rmSetAreaWarnFailure(mesasurfaceID, false);
	rmSetAreaMix(mesasurfaceID, "texas_dirt");
//	rmSetAreaTerrainType(mesasurfaceID, "texas\ground5_tex");
	rmSetAreaBaseHeight(mesasurfaceID, 6.0);
	rmSetAreaHeightBlend(mesasurfaceID, 2.0);
	if (cNumberTeams <3)
		rmSetAreaLocation (mesasurfaceID, 0.51, 0.51);
	else
		rmSetAreaLocation (mesasurfaceID, 0.50, 0.50);
	rmSetAreaCoherence(mesasurfaceID, 0.75);
	rmSetAreaSmoothDistance(mesasurfaceID, 2+cNumberNonGaiaPlayers);
	rmBuildArea(mesasurfaceID);
	int stayInMesasurface = rmCreateAreaMaxDistanceConstraint("stay in mesa surface", mesasurfaceID, 0.0);
	int avoidMesasurface = rmCreateAreaDistanceConstraint("avoid mesa surface", mesasurfaceID, 20.0+2*cNumberNonGaiaPlayers);
	int avoidMesasurfaceShort = rmCreateAreaDistanceConstraint("avoid mesa surface short", mesasurfaceID, 8.0);
	int avoidMesasurfaceMin = rmCreateAreaDistanceConstraint("avoid mesa surface min", mesasurfaceID, 3.0);
	
	if (cNumberTeams <3)
	{	
		//1
		int mesaID = rmCreateArea("mesa");
		if (rmGetIsKOTH())
		{
			rmSetAreaSize(mesaID, rmAreaTilesToFraction(125), rmAreaTilesToFraction(125));
		} else {
			rmSetAreaSize(mesaID, rmAreaTilesToFraction(160*cNumberNonGaiaPlayers/2), rmAreaTilesToFraction(160*cNumberNonGaiaPlayers/2));
		}
		rmSetAreaWarnFailure(mesaID, false);
		rmSetAreaCliffType(mesaID, "texas");
		rmSetAreaCliffPainting(mesaID, true, true, true, , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaCliffHeight(mesaID, rmRandInt(6,6), 0.0, 1.0); 
		if (traderoutevariation == 0)
			rmSetAreaLocation (mesaID, 0.53, 0.56);
		else 
			rmSetAreaLocation (mesaID, 0.56, 0.53);
		rmSetAreaCliffEdge(mesaID, 1, 1.0, 0.1, 1.0, 0);
	//	rmAddAreaConstraint (mesaID, buildMesaNorth);
		rmAddAreaConstraint (mesaID, stayInMesasurface);
		rmAddAreaConstraint (mesaID, mesaavoidTradeRoute);
		rmAddAreaConstraint (mesaID, mesaavoidTradeRouteSocket);
		if (rmGetIsKOTH())
		{
			rmSetAreaCoherence(mesaID, 0.89);
		} else {
			rmSetAreaCoherence(mesaID, 0.55);
		}
		rmSetAreaSmoothDistance(mesaID, 1+0.5*cNumberNonGaiaPlayers);
		int avoidMesa = rmCreateAreaDistanceConstraint("avoid mesa", mesaID, 6.0);
		int avoidMesaFar = rmCreateAreaDistanceConstraint("avoid mesa far", mesaID, 20.0);
		rmBuildArea(mesaID);	
		
		//2
		int mesa2ID = rmCreateArea("mesa2");
		if (rmGetIsKOTH())
		{
			rmSetAreaSize(mesa2ID, rmAreaTilesToFraction(125), rmAreaTilesToFraction(125));
		} else {
			rmSetAreaSize(mesa2ID, rmAreaTilesToFraction(160*cNumberNonGaiaPlayers/2), rmAreaTilesToFraction(160*cNumberNonGaiaPlayers/2));
		}
		rmSetAreaWarnFailure(mesa2ID, false);
		rmSetAreaCliffType(mesa2ID, "texas");
		rmSetAreaCliffPainting(mesa2ID, true, true, true, , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaCliffHeight(mesa2ID, rmRandInt(6,6), 0.0, 1.0);  
		if (traderoutevariation == 0)
			rmSetAreaLocation (mesa2ID, 0.47, 0.45);
		else
			rmSetAreaLocation (mesa2ID, 0.45, 0.47);
		rmSetAreaCliffEdge(mesa2ID, 1, 1.0, 0.1, 1.0, 0);
	//	rmAddAreaConstraint (mesa2ID, buildMesaSouth);
		rmAddAreaConstraint (mesa2ID, stayInMesasurface);
		rmAddAreaConstraint (mesa2ID, mesaavoidTradeRoute);
		rmAddAreaConstraint (mesa2ID, mesaavoidTradeRouteSocket);
		if (rmGetIsKOTH())
		{
			rmSetAreaCoherence(mesa2ID, 0.89);
		} else {
			rmSetAreaCoherence(mesa2ID, 0.55);
		}
		rmSetAreaSmoothDistance(mesa2ID, 1+0.5*cNumberNonGaiaPlayers);
		int avoidMesa2 = rmCreateAreaDistanceConstraint("avoid mesa2", mesa2ID, 6.0);
		int avoidMesa2Far = rmCreateAreaDistanceConstraint("avoid mesa2 far", mesa2ID, 20.0);
		rmBuildArea(mesa2ID);
	}
	else
	{
		//3
		int mesa3ID = rmCreateArea("mesa3");
		if (rmGetIsKOTH()) 
		{
			// smaller mesa
			rmSetAreaSize(mesa3ID, rmAreaTilesToFraction(125), rmAreaTilesToFraction(125));
		}
		else 
			rmSetAreaSize(mesa3ID, rmAreaTilesToFraction(160*cNumberNonGaiaPlayers), rmAreaTilesToFraction(160*cNumberNonGaiaPlayers));  
		rmSetAreaWarnFailure(mesa3ID, false);
		rmSetAreaCliffType(mesa3ID, "texas");
		rmSetAreaCliffPainting(mesa3ID, true, true, true, , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaCliffHeight(mesa3ID, rmRandInt(6,6), 0.0, 1.0);  
		rmSetAreaLocation (mesa3ID, 0.50, 0.50);
		rmSetAreaCliffEdge(mesa3ID, 1, 1.0, 0.1, 1.0, 0);
		rmAddAreaConstraint (mesa3ID, stayInMesasurface);
		rmAddAreaConstraint (mesa3ID, mesaavoidTradeRoute);
		if (rmGetIsKOTH())
		{
			rmSetAreaCoherence(mesa3ID, 0.89);
		} else {
			rmSetAreaCoherence(mesa3ID, 0.55);
		}
		rmSetAreaSmoothDistance(mesa3ID, 1+0.5*cNumberNonGaiaPlayers);
		int avoidMesa3 = rmCreateAreaDistanceConstraint("avoid mesa3", mesa3ID, 6.0);
		int avoidMesa3Far = rmCreateAreaDistanceConstraint("avoid mesa3 far", mesa3ID, 20.0);
		rmBuildArea(mesa3ID);
	}
	
	// **************************************************************************************

	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.5;
		float yLoc = 0.5;
		float walk = 0.04;

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}
	
		// Text
	rmSetStatusText("",0.40);
	

	// ************************************ NATIVES *****************************************

	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
		
	nativeID0 = rmCreateGrouping("navajo village A", "native navajo village "+1); //SW
    rmSetGroupingMinDistance(nativeID0, 0.0);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
	rmAddGroupingToClass(nativeID0, classNative);
    rmAddGroupingToClass(nativeID0, importantItem);
	if (cNumberTeams == 2)
	{
		if (cNumberNonGaiaPlayers == 2)
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.14, 0.56);
		else if (teamZeroCount < 3 && teamOneCount < 3)
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.16, 0.62);
		else
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.23, 0.48);
	}	
	else
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.21, 0.50);
	
	nativeID2 = rmCreateGrouping("navajo village B", "native navajo village "+4); // NE
    rmSetGroupingMinDistance(nativeID2, 0.0);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
	rmAddGroupingToClass(nativeID2, classNative);
    rmAddGroupingToClass(nativeID2, importantItem);
	if (cNumberTeams <= 2)
	{
		if (cNumberNonGaiaPlayers == 2)
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.82, 0.42);
		else if (teamZeroCount < 3 && teamOneCount < 3)
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.81, 0.37);
		else
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.76, 0.50);
	}	
	else
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.78, 0.50);
	
	nativeID1 = rmCreateGrouping("apache village A", "native apache village "+1); // NW
    rmSetGroupingMinDistance(nativeID1, 0.0);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
	rmAddGroupingToClass(nativeID1, classNative);
    rmAddGroupingToClass(nativeID1, importantItem);
	if (cNumberTeams <= 2)
	{
		if (cNumberNonGaiaPlayers == 2)
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.42, 0.84); 
		else if (teamZeroCount < 3 && teamOneCount < 3)
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.37, 0.83); 
		else
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.78); 
	}	
	else
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.80); 
	
	nativeID3 = rmCreateGrouping("apache village B", "native apache village "+5); // SE
    rmSetGroupingMinDistance(nativeID3, 0.0);
    rmSetGroupingMaxDistance(nativeID3, 0.00);
	rmAddGroupingToClass(nativeID3, classNative);
    rmAddGroupingToClass(nativeID3, importantItem);
	if (cNumberTeams <= 2)
	{
		if (cNumberNonGaiaPlayers == 2)
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.56, 0.16); 
		else if (teamZeroCount < 3 && teamOneCount < 3)
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.62, 0.18);
		else
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.48, 0.23);
	}
	else
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.48, 0.21);
		
	// *************************************************************************************
	
	// Text
	rmSetStatusText("",0.50);

	// ****************************** MORE TERRAINS ****************************************
		
		// Terrain patch1
	for (i=0; < 30+10*cNumberNonGaiaPlayers)
    {
        int patch2ID = rmCreateArea("patch grass mix "+i);
        rmSetAreaWarnFailure(patch2ID, false);
        rmSetAreaSize(patch2ID, rmAreaTilesToFraction(90), rmAreaTilesToFraction(100));
		rmSetAreaTerrainType(patch2ID, "texas\ground2_tex");
		rmAddAreaTerrainLayer(patch2ID, "texas\ground3_tex", 0, 1);
//		rmSetAreaMix(patch2ID, "texas_grass");
        rmAddAreaToClass(patch2ID, classPatch2);
        rmSetAreaMinBlobs(patch2ID, 2);
        rmSetAreaMaxBlobs(patch2ID, 5);
        rmSetAreaMinBlobDistance(patch2ID, 16.0);
        rmSetAreaMaxBlobDistance(patch2ID, 40.0);
        rmSetAreaCoherence(patch2ID, 0.1);
		rmAddAreaConstraint(patch2ID, avoidPatch2);
		rmAddAreaConstraint(patch2ID, avoidMesasurfaceShort);
        rmBuildArea(patch2ID); 
    }
	
	
	//Desert patches
	int desertpatchcount = 1*cNumberNonGaiaPlayers;
	int stayInDesertpatch = -1;
	
	for (i=0; < desertpatchcount)
    {
        int patchID = rmCreateArea("desert patch "+i);
        rmSetAreaWarnFailure(patchID, false);
		rmSetAreaObeyWorldCircleConstraint(patchID, false);
        rmSetAreaSize(patchID, rmAreaTilesToFraction(280+10*cNumberNonGaiaPlayers), rmAreaTilesToFraction(320+10*cNumberNonGaiaPlayers));
		rmSetAreaMix(patchID, "texas_dirt");
		rmSetAreaBaseHeight(patchID, -3.0);
		rmSetAreaHeightBlend(patchID, 2.0);
        rmAddAreaToClass(patchID, classPatch);
        rmSetAreaMinBlobs(patchID, 1);
        rmSetAreaMaxBlobs(patchID, 3);
        rmSetAreaMinBlobDistance(patchID, 16.0);
        rmSetAreaMaxBlobDistance(patchID, 30.0);
        rmSetAreaCoherence(patchID, 0.2);
		rmSetAreaSmoothDistance(patchID, 6+1*cNumberNonGaiaPlayers);
		rmAddAreaConstraint(patchID, avoidImpassableLand);
		rmAddAreaConstraint(patchID, avoidTradeRouteShort);
		rmAddAreaConstraint(patchID, avoidTradeRouteSocket);
		rmAddAreaConstraint(patchID, avoidPatch);
		rmAddAreaConstraint(patchID, avoidPlayerArea);
		rmAddAreaConstraint(patchID, avoidMesasurface);
		rmAddAreaConstraint(patchID, avoidNatives);
//		rmAddAreaConstraint(patchID, avoidEdge);
		if (i < desertpatchcount/2)
			rmAddAreaConstraint(patchID, staySouthHalf);
		else
			rmAddAreaConstraint(patchID, stayNorthHalf);
        rmBuildArea(patchID); 
	
	stayInDesertpatch = rmCreateAreaMaxDistanceConstraint("stay in desert patch "+i, patchID, 0.0);
	
	for (j=0; < 1)
	int internalpatch = rmCreateArea("desert patch "+i+j);
	rmSetAreaSize(internalpatch, rmAreaTilesToFraction(300+10*cNumberNonGaiaPlayers), rmAreaTilesToFraction(300+10*cNumberNonGaiaPlayers));	
	rmSetAreaObeyWorldCircleConstraint(internalpatch, false);
	rmSetAreaTerrainType(internalpatch, "texas\ground5_tex"); //borneo\shoreline1_borneo
//	rmAddAreaTerrainLayer(internalpatch, "texas\ground4_tex", 0, 1);
	rmSetAreaSmoothDistance(internalpatch, 4+1*cNumberNonGaiaPlayers);
	rmAddAreaConstraint(internalpatch, stayInDesertpatch);
	rmSetAreaWarnFailure(internalpatch, false);
	rmBuildArea(internalpatch); 
    }
		
	
	// *************************** PLAYER STARTING RESOURCES *******************************

	// ***** Define *****
	
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
	rmAddObjectDefItem(playergoldID, "MineCopper", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 17.0);
	rmSetObjectDefMaxDistance(playergoldID, 17.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidGoldType);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "MineCopper", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 42.0); //68
	rmSetObjectDefMaxDistance(playergold2ID, 44.0); //70
//	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldTypeFar);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergold2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	if (cNumberTeams <3)
	{
	rmAddObjectDefConstraint(playergold2ID, avoidMesaFar);
	rmAddObjectDefConstraint(playergold2ID, avoidMesa2Far);
	}
	else
	rmAddObjectDefConstraint(playergold2ID, avoidMesa3Far);
	rmAddObjectDefConstraint(playergold2ID, avoidEdge);
//	rmAddObjectDefConstraint(playergold2ID, avoidCenter);
	

	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 3, 3.0);
	rmSetObjectDefMinDistance(playerberriesID, 13.0);
	rmSetObjectDefMaxDistance(playerberriesID, 15.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerberriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerberriesID, avoidNatives);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResources);
	
	// Starting herd
	int playerbisonID = rmCreateObjectDef("starting bisons");
	rmAddObjectDefItem(playerbisonID, "bison", 4, 3.0);
	rmSetObjectDefMinDistance(playerbisonID, 12.0);
	rmSetObjectDefMaxDistance(playerbisonID, 15.0);
	rmSetObjectDefCreateHerd(playerbisonID, false);
	rmAddObjectDefToClass(playerbisonID, classStartingResource);
	rmAddObjectDefConstraint(playerbisonID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerbisonID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerbisonID, avoidNatives);
	rmAddObjectDefConstraint(playerbisonID, avoidStartingResourcesShort);
	
	// Starting trees 
	int playerTreeID = rmCreateObjectDef("player trees");
    rmAddObjectDefItem(playerTreeID, "TreeSonora", rmRandInt(4,4), 4.0);
    rmSetObjectDefMinDistance(playerTreeID, 14);
    rmSetObjectDefMaxDistance(playerTreeID, 16);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestVeryShort);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	
	// 2nd herd
	int playerPronghornID = rmCreateObjectDef("player pronghorn");
    rmAddObjectDefItem(playerPronghornID, "pronghorn", rmRandInt(9,9), 7.0);
    rmSetObjectDefMinDistance(playerPronghornID, 30);
    rmSetObjectDefMaxDistance(playerPronghornID, 34);
	rmAddObjectDefToClass(playerPronghornID, classStartingResource);
	rmSetObjectDefCreateHerd(playerPronghornID, true);
	rmAddObjectDefConstraint(playerPronghornID, avoidPronghorn);
	rmAddObjectDefConstraint(playerPronghornID, avoidBisonShort); 
	rmAddObjectDefConstraint(playerPronghornID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerPronghornID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerPronghornID, avoidNatives);
	rmAddObjectDefConstraint(playerPronghornID, avoidStartingResources);
	rmAddObjectDefConstraint(playerPronghornID, avoidMesasurface);
	rmAddObjectDefConstraint(playerPronghornID, avoidCenter);
	rmAddObjectDefConstraint(playerPronghornID, avoidEdge);
	
	// 3rd herd
	int playerPronghorn2ID = rmCreateObjectDef("player pronghorn2");
    rmAddObjectDefItem(playerPronghorn2ID, "pronghorn", rmRandInt(9,9), 7.0);
    rmSetObjectDefMinDistance(playerPronghorn2ID, 36);
    rmSetObjectDefMaxDistance(playerPronghorn2ID, 40);
	rmAddObjectDefToClass(playerPronghorn2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerPronghorn2ID, true);
	rmAddObjectDefConstraint(playerPronghorn2ID, avoidPronghornFar); 
	rmAddObjectDefConstraint(playerPronghorn2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerPronghorn2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerPronghorn2ID, avoidNatives);
	rmAddObjectDefConstraint(playerPronghorn2ID, avoidStartingResources);
	if (cNumberTeams <3)
	{
	rmAddObjectDefConstraint(playerPronghorn2ID, avoidMesaFar);
	rmAddObjectDefConstraint(playerPronghorn2ID, avoidMesa2Far);
	}
	else
	rmAddObjectDefConstraint(playerPronghorn2ID, avoidMesa3Far);
	rmAddObjectDefConstraint(playerPronghorn2ID, avoidEdge);
	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 25.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
	int nugget0count = rmRandInt (2,2); //1,2
	
	// ***** Place *****
	
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playercloseTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerbisonID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerPronghornID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerPronghorn2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (nugget0count == 2)
			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		
		if(ypIsAsian(i) && rmGetNomadStart() == false)
		rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i,1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		
		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}	

	}
	
	// **************************************************************************************
	
	// Text
	rmSetStatusText("",0.60);
	
	// ********************************* COMMON RESOURCES ***********************************
   
   
	// ******** Mines *********
		
	int copperCount = 3*cNumberNonGaiaPlayers;  // 3,3 
	
	//Extra mines
	for(i=1; < copperCount+1)
	{
		int coppermineID = rmCreateObjectDef("copper mine"+i);
		rmAddObjectDefItem(coppermineID, "MineCopper", 1, 0.0);
		rmSetObjectDefMinDistance(coppermineID, 0.0);
		rmSetObjectDefMaxDistance(coppermineID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(coppermineID, classGold);
		rmAddObjectDefConstraint(coppermineID, avoidTradeRoute);
		rmAddObjectDefConstraint(coppermineID, avoidImpassableLand);
		rmAddObjectDefConstraint(coppermineID, avoidNativesFar);
		rmAddObjectDefConstraint(coppermineID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(coppermineID, avoidGoldFar);
		rmAddObjectDefConstraint(coppermineID, avoidTownCenterFar);
		rmAddObjectDefConstraint(coppermineID, avoidMesasurface);
		rmAddObjectDefConstraint(coppermineID, avoidPatchMin);
		rmAddObjectDefConstraint(coppermineID, avoidEdge);
//		if (i != copperCount)
//		{
			if (cNumberNonGaiaPlayers == 2)
			{
				if (i%2 == 1.00)
					rmAddObjectDefConstraint(coppermineID, staySouthHalf);
				else
					rmAddObjectDefConstraint(coppermineID, stayNorthHalf);
			}
//		}
		rmPlaceObjectDefAtLoc(coppermineID, 0, 0.50, 0.50);
	}

	// ************************
	
	// Text
	rmSetStatusText("",0.70);
	
	// ******* Forests ********
	
	//Forest
	int bigforestcount = 4+4*cNumberNonGaiaPlayers;
	int stayInBigforestPatch = -1;
		
	for (i=0; < bigforestcount)
	{
		int bigforestID = rmCreateArea("forest big "+i);
		rmSetAreaWarnFailure(bigforestID, false);
		rmSetAreaSize(bigforestID, rmAreaTilesToFraction(190), rmAreaTilesToFraction(210));
		rmSetAreaTerrainType(bigforestID, "texas\groundforest_tex");
		rmSetAreaObeyWorldCircleConstraint(bigforestID, false);
//		rmSetAreaForestDensity(bigforestID, 0.8);
//		rmSetAreaForestClumpiness(bigforestID, 0.15);
//		rmSetAreaForestUnderbrush(bigforestID, 0.2);
		rmSetAreaMinBlobs(bigforestID, 2);
		rmSetAreaMaxBlobs(bigforestID, 4);
		rmSetAreaMinBlobDistance(bigforestID, 14.0);
		rmSetAreaMaxBlobDistance(bigforestID, 30.0);
		rmSetAreaCoherence(bigforestID, 0.65);
		rmSetAreaSmoothDistance(bigforestID, 6);
//		rmAddAreaToClass(bigforestID, classForest);
		rmAddAreaConstraint(bigforestID, avoidForestBig);
		rmAddAreaConstraint(bigforestID, avoidForestShort);
		rmAddAreaConstraint(bigforestID, avoidGoldShort);
		rmAddAreaConstraint(bigforestID, avoidPronghornMin); 
		rmAddAreaConstraint(bigforestID, avoidBisonMin); 
		rmAddAreaConstraint(bigforestID, avoidTownCenterShort); 
		rmAddAreaConstraint(bigforestID, avoidNativesShort);
		rmAddAreaConstraint(bigforestID, avoidTradeRouteShort);
		rmAddAreaConstraint(bigforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(bigforestID, avoidImpassableLandShort);
		rmAddAreaConstraint(bigforestID, avoidStartingResourcesShort);
		rmAddAreaConstraint(bigforestID, avoidMesasurface);
		rmAddAreaConstraint(bigforestID, avoidPatchShort);
		if (i < cNumberNonGaiaPlayers)
			rmAddAreaConstraint(bigforestID, staySouthHalf);
		else if (i < cNumberNonGaiaPlayers*2)
			rmAddAreaConstraint(bigforestID, stayNorthHalf);
		rmBuildArea(bigforestID);
		
		stayInBigforestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest big patch"+i, bigforestID, 0.0);
		
		for (j=0; < rmRandInt(8,9))
		{
			int bigforesttreeID = rmCreateObjectDef("forest lowground trees"+i+j);
			rmAddObjectDefItem(bigforesttreeID, "TreeJuniper", rmRandInt(1,3), 5.0);
			rmAddObjectDefItem(bigforesttreeID, "TreePaintedDesert", rmRandInt(1,1), 5.0);
			rmAddObjectDefItem(bigforesttreeID, "UnderbrushTexas", rmRandInt(1,1), 3.0);
			rmSetObjectDefMinDistance(bigforesttreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(bigforesttreeID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(bigforesttreeID, classForest);
			rmAddObjectDefToClass(bigforesttreeID, classForestBig);
		//	rmAddObjectDefConstraint(bigforesttreeID, avoidForestShort);
			rmAddObjectDefConstraint(bigforesttreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(bigforesttreeID, stayInBigforestPatch);	
			rmPlaceObjectDefAtLoc(bigforesttreeID, 0, 0.50, 0.50);
		}
	}

	// Random trees 
	int treesmallcount = 6+8*cNumberNonGaiaPlayers;

	for (i=0; < treesmallcount)
	{
		int randomsmalltreeID = rmCreateObjectDef("random trees small "+i);
		rmAddObjectDefItem(randomsmalltreeID, "TreeSonora", rmRandInt(4,7), 5.0);
		rmAddObjectDefItem(randomsmalltreeID, "UnderbrushTexas", rmRandInt(1,3), 5.0);
		rmSetObjectDefMinDistance(randomsmalltreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(randomsmalltreeID,  rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(randomsmalltreeID, classForest);
		rmAddObjectDefConstraint(randomsmalltreeID, avoidForestShort);
		rmAddObjectDefConstraint(randomsmalltreeID, avoidGoldShort);
		rmAddObjectDefConstraint(randomsmalltreeID, avoidBisonMin); 
		rmAddObjectDefConstraint(randomsmalltreeID, avoidPronghornMin); 
		rmAddObjectDefConstraint(randomsmalltreeID, avoidTownCenterShort); 
		rmAddObjectDefConstraint(randomsmalltreeID, avoidNativesShort);
		rmAddObjectDefConstraint(randomsmalltreeID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(randomsmalltreeID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(randomsmalltreeID, avoidImpassableLand);
		rmAddObjectDefConstraint(randomsmalltreeID, avoidMesasurfaceShort);
		rmAddObjectDefConstraint(randomsmalltreeID, avoidPatchShort);
		rmAddObjectDefConstraint(randomsmalltreeID, avoidStartingResources);
		rmPlaceObjectDefAtLoc(randomsmalltreeID, 0, 0.50, 0.50);
	}
	
	
	// ******** Herds *********
		
	int bisonCount = cNumberNonGaiaPlayers;  
	
	//Bisons
	for(i=1; < bisonCount+1)
	{
		int bisonID = rmCreateObjectDef("bisons"+i);
		rmAddObjectDefItem(bisonID, "bison", rmRandInt(8,9), 8.0);
		rmSetObjectDefMinDistance(bisonID, rmXFractionToMeters(0.13));
		rmSetObjectDefMaxDistance(bisonID, rmXFractionToMeters(0.17));
		rmSetObjectDefCreateHerd(bisonID, true);
//		rmAddObjectDefConstraint(bisonID, avoidTradeRoute);
		rmAddObjectDefConstraint(bisonID, avoidImpassableLand);
		rmAddObjectDefConstraint(bisonID, avoidNatives);
		rmAddObjectDefConstraint(bisonID, avoidTradeRoute);
		rmAddObjectDefConstraint(bisonID, avoidGoldShort);		
		rmAddObjectDefConstraint(bisonID, avoidTownCenter);
		if (cNumberTeams <3)
		{
			rmAddObjectDefConstraint(bisonID, avoidMesa);
			rmAddObjectDefConstraint(bisonID, avoidMesa2);
		}
		else
			rmAddObjectDefConstraint(bisonID, avoidMesa3);
		rmAddObjectDefConstraint(bisonID, avoidPronghorn); 
		rmAddObjectDefConstraint(bisonID, avoidBisonFar); 
		rmAddObjectDefConstraint(bisonID, avoidPatchMin);
		if (cNumberTeams <3)
		{
			if (i%2 == 1.00)
				rmAddObjectDefConstraint(bisonID, staySouthHalf);
			else
				rmAddObjectDefConstraint(bisonID, stayNorthHalf);
		}
		rmPlaceObjectDefAtLoc(bisonID, 0, 0.50, 0.50);
		
	}
	
	
	//Pronghorns
	int pronghornCount = 3*cNumberNonGaiaPlayers;  
	
	for(i=1; < pronghornCount+1)
	{
		int pronghornID = rmCreateObjectDef("pronghorn"+i);
		rmAddObjectDefItem(pronghornID, "pronghorn", rmRandInt(9,10), 7.0);
		rmSetObjectDefMinDistance(pronghornID, 0.0);
		rmSetObjectDefMaxDistance(pronghornID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(pronghornID, true);
		rmAddObjectDefConstraint(pronghornID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(pronghornID, avoidImpassableLand);
		rmAddObjectDefConstraint(pronghornID, avoidNativesShort);
		rmAddObjectDefConstraint(pronghornID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(pronghornID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(pronghornID, avoidTownCenter);
		rmAddObjectDefConstraint(pronghornID, avoidEdge);
		if (cNumberTeams <3)
		{
			rmAddObjectDefConstraint(pronghornID, avoidMesaFar);
			rmAddObjectDefConstraint(pronghornID, avoidMesa2Far);
		}
		else
			rmAddObjectDefConstraint(pronghornID, avoidMesa3Far);
		rmAddObjectDefConstraint(pronghornID, avoidPronghornFar); 
		rmAddObjectDefConstraint(pronghornID, avoidBison); 
		rmAddObjectDefConstraint(pronghornID, avoidForestMin); 
		rmAddObjectDefConstraint(pronghornID, avoidPatchMin);
		if (cNumberNonGaiaPlayers == 2)
		{
			if (i%2 == 1.00)
				rmAddObjectDefConstraint(pronghornID, staySouthHalf);
			else
				rmAddObjectDefConstraint(pronghornID, stayNorthHalf);
		}
		rmPlaceObjectDefAtLoc(pronghornID, 0, 0.50, 0.50);
	}

	// *************************
	
	// Text
	rmSetStatusText("",0.90);
	
	// ****** Treasures *******
	
	int	nugget2count = 4+cNumberNonGaiaPlayers; 
	int	nugget3count = cNumberNonGaiaPlayers; 
	int	nugget4count = -1;
	if (cNumberTeams <= 2)
		nugget4count = cNumberTeams+(cNumberNonGaiaPlayers/cNumberTeams); 
	else
		nugget4count = cNumberNonGaiaPlayers/2;
	
	// lvl 2
	for (i=0; < nugget2count+0)
	{
		int Nugget2ID = rmCreateObjectDef("nugget lvl 2"+i); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(2, 2);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget2ID, avoidImportantItem);
		rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin); 
		if (cNumberTeams <= 2 && teamZeroCount == teamOneCount)
		{
			if (i < nugget2count/2 )
				rmAddObjectDefConstraint(Nugget2ID, staySouthHalf);
			else
				rmAddObjectDefConstraint(Nugget2ID, stayNorthHalf);
		}
		if (cNumberTeams <3)
		{
			rmAddObjectDefConstraint(Nugget2ID, avoidMesa);
			rmAddObjectDefConstraint(Nugget2ID, avoidMesa2);
		}
		else
			rmAddObjectDefConstraint(Nugget2ID, avoidMesa3Far);
		rmAddObjectDefConstraint(Nugget2ID, avoidPronghornMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidBisonMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge); 
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.5, 0.5);
	}
	

	// lvl 3
	for (i=0; < nugget3count)
	{
		int Nugget3ID = rmCreateObjectDef("nugget lvl 3"+i); 
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(3, 3);
		rmSetObjectDefMinDistance(Nugget3ID, 0);
		rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget3ID, avoidImportantItem);
		rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin); 
		
		if (cNumberTeams <= 2 && teamZeroCount == teamOneCount)
		{
			if (i < nugget3count/2 )
				rmAddObjectDefConstraint(Nugget3ID, stayNorthHalf);
			else
				rmAddObjectDefConstraint(Nugget3ID, staySouthHalf);
		}
		
		if (cNumberTeams <3)
		{
			rmAddObjectDefConstraint(Nugget3ID, avoidMesa);
			rmAddObjectDefConstraint(Nugget3ID, avoidMesa2);
		}
		else
			rmAddObjectDefConstraint(Nugget3ID, avoidMesa3Far);
		rmAddObjectDefConstraint(Nugget3ID, avoidPronghornMin); 
		rmAddObjectDefConstraint(Nugget3ID, avoidBisonMin); 
		rmAddObjectDefConstraint(Nugget3ID, avoidEdge); 
//		if (cNumberNonGaiaPlayers >= 4)		
		rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.5, 0.5);
	}
	
	
	// lvl 4
	for (i=0; < nugget4count)
	{
		int Nugget4ID = rmCreateObjectDef("nugget lvl 4"+i); 
		rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(4, 4);
		rmSetObjectDefMinDistance(Nugget4ID, 0);
		rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(Nugget4ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget4ID, avoidImportantItem);
		rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidForestMin); 
		
		if (cNumberTeams <= 2 && teamZeroCount == teamOneCount)
		{
			if (i < nugget4count/2 )
				rmAddObjectDefConstraint(Nugget4ID, staySouthHalf);
			else
				rmAddObjectDefConstraint(Nugget4ID, stayNorthHalf);
		}
		
		if (cNumberTeams <3)
		{
			rmAddObjectDefConstraint(Nugget4ID, avoidMesa);
			rmAddObjectDefConstraint(Nugget4ID, avoidMesa2);
		}
		else
			rmAddObjectDefConstraint(Nugget4ID, avoidMesa3Far);
		rmAddObjectDefConstraint(Nugget4ID, avoidPronghornMin); 
		rmAddObjectDefConstraint(Nugget4ID, avoidBisonMin); 
		rmAddObjectDefConstraint(Nugget4ID, avoidEdge); 
		if (cNumberNonGaiaPlayers >= 4)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.5, 0.5);
	}
	
	// ***********************


      rmCreateTrigger("Train");
      rmSwitchToTrigger(rmTriggerID("Train"));
      rmSetTriggerPriority(3);
      rmSetTriggerActive(true);
      rmSetTriggerRunImmediately(true);
      rmSetTriggerLoop(false);
      rmAddTriggerCondition("Always");
      rmAddTriggerEffect("Trade Route Set Level");
      rmSetTriggerEffectParamInt("TradeRoute", 1);
      rmSetTriggerEffectParamInt("Level", 2);

		
	// Text
	rmSetStatusText("",1.00);

	
} // END