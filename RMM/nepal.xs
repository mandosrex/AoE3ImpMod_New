// vivid's Nepal (Obs) v5
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
	float playerTiles=10000;
		if (cNumberNonGaiaPlayers>2)
			playerTiles = 9500;
		if (cNumberNonGaiaPlayers>4)
			playerTiles = 8500;				
		if (cNumberNonGaiaPlayers>6)
			playerTiles = 8000;			

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmSetMapSize(size, size);
	
	// Make the corners
	rmSetWorldCircleConstraint(true);
	
	// Picks a default water height
	rmSetSeaLevel(-4.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	// Picks default terrain and water
	rmSetBaseTerrainMix("himalayas_b");
	rmTerrainInitialize("himalayas\ground_dirt8_himal");
	rmSetMapType("himalayas"); 
	rmSetMapType("grass");
	rmSetMapType("land");
	rmSetMapType("asia");
	rmSetLightingSet("deccan");

	// Choose Mercs
	chooseMercs();
	
	// Make it snow
	rmSetGlobalSnow(0.9);

	// Make it windy
	rmSetWindMagnitude(10.0);
  
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
	int classCliff = rmDefineClass("Cliffs");
	int classNative = rmDefineClass("natives");
	
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
	int avoidForestMed=rmCreateClassDistanceConstraint("avoid forest med", rmClassID("Forest"), 26.0);
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 20.0);
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 34.0);
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 12.0);
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("Forest"), 25.0);
	int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("Forest"), 20.0);
	int avoidSheepFar = rmCreateTypeDistanceConstraint("avoid MPSheep far", "ypMarcoPoloSheep", 55.0);
	int avoidSheep = rmCreateTypeDistanceConstraint("avoid MPSheep", "ypMarcoPoloSheep", 46.0);
	int avoidSheepShort = rmCreateTypeDistanceConstraint("avoid MPSheep short", "ypMarcoPoloSheep", 35.0);
	int avoidSheepMin = rmCreateTypeDistanceConstraint("avoid MPSheep min", "ypMarcoPoloSheep", 10.0);	
	int avoidSaigaFar = rmCreateTypeDistanceConstraint("avoid Saiga far", "ypSaiga", 60.0);
	int avoidSaiga = rmCreateTypeDistanceConstraint("avoid Saiga", "ypSaiga", 50.0);
	int avoidSaigaShort = rmCreateTypeDistanceConstraint("avoid Saiga short", "ypSaiga", 35.0);
	int avoidSaigaMin = rmCreateTypeDistanceConstraint("avoid Saiga min", "ypSaiga", 10.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 30.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 20.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 36.0);
	int avoidGoldTypeMin = rmCreateTypeDistanceConstraint("coin avoids coin min ", "gold", 12.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 45.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 12.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 40.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 50.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 58.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 40.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 50.0);
	int avoidTownCenterVeryFar = rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 85.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 70.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 48.0); //46
	int avoidTownCenterMed = rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 60.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 20.0);
	int avoidTownCenterMin = rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 18.0);
	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 12.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 8.0);
	int avoidCliffMin = rmCreateClassDistanceConstraint("avoid cliff min", rmClassID("Cliffs"), 8.0);
	int avoidCliffShort = rmCreateClassDistanceConstraint("avoid cliff short", rmClassID("Cliffs"), 10.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", rmClassID("Cliffs"), 12.0);
	int avoidCliffMed = rmCreateClassDistanceConstraint("avoid cliff medium", rmClassID("Cliffs"), 18.0);
	int avoidCliffFar = rmCreateClassDistanceConstraint("avoid cliff far", rmClassID("Cliffs"), 26.0);
	int avoidCliffVeryFar = rmCreateClassDistanceConstraint("avoid cliff very far", rmClassID("Cliffs"), 30.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 12.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", rmClassID("natives"), 16.0);
	int avoidNativesVeryFar = rmCreateClassDistanceConstraint("stuff avoids natives very far", rmClassID("natives"), 20.0);
	
	// Avoid impassable land
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 20.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 20.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 8.0);
	int avoidIslandMin=rmCreateClassDistanceConstraint("avoid island min", classIsland, 4.0);
	int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 8.0);
	int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 12.0);
	int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 20.0);
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 20.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 8.0);
	int avoidTradeRouteMin = rmCreateTradeRouteDistanceConstraint("trade route min", 2.0);
	int avoidTradeRouteSocketMin = rmCreateTypeDistanceConstraint("trade route socket min", "socketTradeRoute", 4.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("trade route socket short", "socketTradeRoute", 8.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 20.0);
	int avoidSocket = rmCreateTypeDistanceConstraint("avoid socket", "NativeSocket", 20.0);
	
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
						rmPlacePlayer(1, 0.735, 0.735);
						rmPlacePlayer(2, 0.265, 0.265);
				}
				else
				{
						rmPlacePlayer(2, 0.735, 0.735);
						rmPlacePlayer(1, 0.265, 0.265);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.15, 0.25); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.50, 0.60); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);	
				}
				else // 3v3, 4v4
				{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.05, 0.25); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.50, 0.70); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);	
				}
			}
			else 
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.05, 0.30); 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.36, 0.36, 0);

				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.45, 0.70); 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.36, 0.36, 0);	
			}
		}
		else  //FFA
			{	
				rmSetPlacementSection(0.05, 0.70);
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.36, 0.36, 0.0);
			}


	// Text
	rmSetStatusText("",0.30);
	
	// ____________________ Map Parameters ____________________

	// Continent
	int continentID = rmCreateArea("continent");
	rmSetAreaLocation(continentID, 0.5, 0.5);
	rmSetAreaWarnFailure(continentID, false);
	rmSetAreaSize(continentID, 0.99, 0.99);
	rmSetAreaCoherence(continentID, 1.0);
	rmSetAreaBaseHeight(continentID, -4.0);
	rmSetAreaObeyWorldCircleConstraint(continentID, false);
	rmSetAreaMix(continentID, "himalayas_b");  
	rmBuildArea(continentID); 
	
	int stayValley = rmCreateAreaConstraint("stay in central valley", continentID);

	// Git Off Muh Lawn!
	int noreszone1ID = rmCreateArea("no res zone1 ");
	rmSetAreaSize(noreszone1ID, 0.125, 0.125);
	rmSetAreaLocation(noreszone1ID, 0.60, 1.00);
	rmAddAreaInfluencePoint(noreszone1ID, 0.70, 0.90);
	rmAddAreaInfluencePoint(noreszone1ID, 0.80, 0.90);
	rmAddAreaInfluencePoint(noreszone1ID, 0.90, 0.80);
	rmAddAreaInfluencePoint(noreszone1ID, 0.90, 0.70);
	rmAddAreaInfluencePoint(noreszone1ID, 1.00, 0.60);
	rmAddAreaInfluencePoint(noreszone1ID, 1.00, 0.50);
	rmSetAreaWarnFailure(noreszone1ID, false);
//	rmSetAreaMix(noreszone1ID, "patagonia_snow");	
	rmSetAreaCoherence(noreszone1ID, 1.0); 
	rmSetAreaElevationType(noreszone1ID, cElevTurbulence);
	rmSetAreaElevationVariation(noreszone1ID, 5.0);
	rmSetAreaElevationMinFrequency(noreszone1ID, 0.04);
	rmSetAreaElevationOctaves(noreszone1ID, 3);
	rmSetAreaElevationPersistence(noreszone1ID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(noreszone1ID, false);
	if (cNumberTeams == 2)
		rmBuildArea(noreszone1ID);	

	// Git Off Muh Lawn! 2
	int noreszone2ID = rmCreateArea("no res zone2 ");
	rmSetAreaSize(noreszone2ID, 0.125, 0.125);
	rmSetAreaLocation(noreszone2ID, 0.00, 0.40);
	rmAddAreaInfluencePoint(noreszone2ID, 0.10, 0.30);	
	rmAddAreaInfluencePoint(noreszone2ID, 0.10, 0.20);	
	rmAddAreaInfluencePoint(noreszone2ID, 0.20, 0.10);	
	rmAddAreaInfluencePoint(noreszone2ID, 0.30, 0.10);	
	rmAddAreaInfluencePoint(noreszone2ID, 0.40, 0.00);	
	rmAddAreaInfluencePoint(noreszone2ID, 0.50, 0.00);	
	rmSetAreaWarnFailure(noreszone2ID, false);
//	rmSetAreaMix(noreszone2ID, "patagonia_snow");	
	rmSetAreaCoherence(noreszone2ID, 1.0); 
	rmSetAreaElevationType(noreszone2ID, cElevTurbulence);
	rmSetAreaElevationVariation(noreszone2ID, 5.0);
	rmSetAreaElevationMinFrequency(noreszone2ID, 0.04);
	rmSetAreaElevationOctaves(noreszone2ID, 3);
	rmSetAreaElevationPersistence(noreszone2ID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(noreszone2ID, false);
	if (cNumberTeams == 2)
		rmBuildArea(noreszone2ID);	
		
	int avoidNoResZone1 = rmCreateAreaDistanceConstraint("avoid no res zone1 ", noreszone1ID, 20.0);
	int avoidNoResZone1Short = rmCreateAreaDistanceConstraint("avoid no res zone1 short ", noreszone1ID, 12.0);
	int stayNoResZone1 = rmCreateAreaMaxDistanceConstraint("stay in no res zone1 ", noreszone1ID, 0.0);	
	int avoidNoResZone2 = rmCreateAreaDistanceConstraint("avoid no res zone2 ", noreszone2ID, 20.0);
	int avoidNoResZone2Short = rmCreateAreaDistanceConstraint("avoid no res zone2 short ", noreszone2ID, 12.0);
	int stayNoResZone2 = rmCreateAreaMaxDistanceConstraint("stay in no res zone2 ", noreszone2ID, 0.0);		

	// Player Areas
	for (i=1; < cNumberPlayers)
	{
		int playerareaID = rmCreateArea("playerarea"+i);
		rmSetPlayerArea(i, playerareaID);
		if (cNumberNonGaiaPlayers < 4)
			rmSetAreaSize(playerareaID, 0.038, 0.038);
		else if (cNumberNonGaiaPlayers == 4)
			rmSetAreaSize(playerareaID, 0.029, 0.029);
		else if (cNumberNonGaiaPlayers > 4)
			rmSetAreaSize(playerareaID, 0.0225, 0.0225);
		rmSetAreaLocPlayer(playerareaID, i);
		rmAddAreaToClass(playerareaID, classIsland);
		rmSetAreaCoherence(playerareaID, 0.75);
		rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
		rmSetAreaWarnFailure(playerareaID, false);
		rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
		rmAddAreaToClass(playerareaID, classIsland);
//		rmSetAreaCliffType(playerareaID, "himalayas");
//		rmSetAreaTerrainType(playerareaID, "himalayas\ground_dirt8_himal");
//		rmSetAreaCliffEdge(playerareaID, 4, 0.15, 0.0, 1.0, 0); 
//		rmSetAreaCliffPainting(playerareaID, true, true, true, 1.5, true);
//		rmSetAreaCliffHeight(playerareaID, 8, 0.25, 0.5);		
		rmBuildArea(playerareaID);
	}

	// Trade Route

		int tradeRouteID = rmCreateTradeRoute();

		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 6.0);      

		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, .90, .10);
		rmAddTradeRouteWaypoint(tradeRouteID, .7555, .2555);
		rmAddTradeRouteWaypoint(tradeRouteID, .60, .30);
		rmAddTradeRouteWaypoint(tradeRouteID, .55, .45);
		rmAddTradeRouteWaypoint(tradeRouteID, .50, .60);
		rmAddTradeRouteWaypoint(tradeRouteID, .325, .625);
		rmAddTradeRouteWaypoint(tradeRouteID, .30, .70);
		
        rmBuildTradeRoute(tradeRouteID, "water");
		
		if (cNumberNonGaiaPlayers == 2) {
			vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
			
			socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.90);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);		
	
		}
		else {
			vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID, 0.35);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);
			
			socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID, 0.525);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);		
	
			socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID, 0.725);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);	
			
			socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID, 0.90);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);		
		}


	// Trade "Island"
	if (cNumberTeams <= 2) {
		int tradeislandID=rmCreateArea("Trade Island");
			rmSetAreaSize(tradeislandID, 0.03, 0.03);
		rmSetAreaLocation(tradeislandID, 0.35, 0.65);
			rmAddAreaInfluenceSegment(tradeislandID, 0.35, 0.65, 0.45, 0.625);
			rmAddAreaInfluenceSegment(tradeislandID, 0.45, 0.625, 0.55, 0.45);
			rmAddAreaInfluenceSegment(tradeislandID, 0.55, 0.45, 0.575, 0.325);
			rmAddAreaInfluenceSegment(tradeislandID, 0.575, 0.325, 0.7555, 0.2555);
			rmAddAreaInfluenceSegment(tradeislandID, 0.7555, 0.2555, 0.90, 0.10);
		rmAddAreaToClass(tradeislandID, classIsland);
		rmSetAreaCoherence(tradeislandID, 1.0);
		rmBuildArea(tradeislandID); 
		}

	int avoidTradeIslandMin = rmCreateAreaDistanceConstraint("avoid trade island min", tradeislandID, 4.0);
	int avoidTradeIslandShort = rmCreateAreaDistanceConstraint("avoid trade island short", tradeislandID, 8.0);
	int avoidTradeIsland = rmCreateAreaDistanceConstraint("avoid trade island", tradeislandID, 12.0);
	int avoidTradeIslandFar = rmCreateAreaDistanceConstraint("avoid trade island far", tradeislandID, 30.0);
	int stayTradeIsland = rmCreateAreaMaxDistanceConstraint("stay in trade island", tradeislandID, 0);

	// Natives

		// Set up Natives
		int subCiv0 = -1;
		subCiv0 = rmGetCivID("Bhakti");
		rmSetSubCiv(0, "Bhakti");
	
		// Place Natives
		int nativeID0 = -1;
		int nativeID1 = -1;
		int nativeID2 = -1;
		int nativeID3 = -1;
	
	if (cNumberTeams <= 2) {
		nativeID0 = rmCreateGrouping("Bhakti temple A", "native bhakti village "+1);
		rmAddGroupingToClass(nativeID0, classNative);
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.80, 0.30);
		
		nativeID1 = rmCreateGrouping("Bhakti temple B", "native bhakti village "+2);
		rmAddGroupingToClass(nativeID1, classNative);
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.70, 0.20);
		}
		else {
		nativeID2 = rmCreateGrouping("Bhakti temple C", "native bhakti village "+1);
		rmAddGroupingToClass(nativeID2, classNative);
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.45, 0.75);
		
		nativeID3 = rmCreateGrouping("Bhakti temple D", "native bhakti village "+2);
		rmAddGroupingToClass(nativeID3, classNative);
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.25, 0.55);
		}

	// Native "Island"
	if (cNumberTeams <= 2) {
		int nativeislandID=rmCreateArea("Native Island");
		rmSetAreaSize(nativeislandID, 0.011, 0.011);
		rmSetAreaLocation(nativeislandID, 0.80, 0.30);
		rmAddAreaInfluenceSegment(nativeislandID, 0.80, 0.30, 0.70, 0.20);
		rmAddAreaToClass(nativeislandID, classIsland);
		rmSetAreaCoherence(nativeislandID, 1.0);
		rmBuildArea(nativeislandID); 
		}
		else {
		int nativeislandID2=rmCreateArea("Native Island 2");
		rmSetAreaSize(nativeislandID2, 0.011, 0.011);
		rmSetAreaLocation(nativeislandID2, 0.40, 0.70);
		rmAddAreaInfluenceSegment(nativeislandID2, 0.80, 0.30, 0.70, 0.20);
		rmAddAreaToClass(nativeislandID2, classIsland);
		rmSetAreaCoherence(nativeislandID2, 1.0);
		rmBuildArea(nativeislandID2); 
		}

		
	// Mount Everest
	int foothillsID=rmCreateArea("Mount E Foothills");
		rmSetAreaSize(foothillsID, 0.125, 0.125);
	rmSetAreaLocation(foothillsID, 0.00, 1.00);
	rmAddAreaToClass(foothillsID, classIsland);
	rmSetAreaCoherence(foothillsID, 0.75);
	rmSetAreaElevationType(foothillsID, cElevTurbulence);
	rmSetAreaBaseHeight(foothillsID, 0);
	rmSetAreaMix(foothillsID, "himalayas_snow");
       rmSetAreaSmoothDistance(foothillsID, 10);
       rmSetAreaHeightBlend(foothillsID, 1);
       rmSetAreaElevationNoiseBias(foothillsID, 0);
       rmSetAreaElevationEdgeFalloffDist(foothillsID, 10);
       rmSetAreaElevationVariation(foothillsID, 7);
       rmSetAreaElevationPersistence(foothillsID, .3);
       rmSetAreaElevationOctaves(foothillsID, 8);
       rmSetAreaElevationMinFrequency(foothillsID, 0.1);	
	rmSetAreaObeyWorldCircleConstraint(foothillsID, false);
	rmBuildArea(foothillsID); 

	int avoidFoothills = rmCreateAreaDistanceConstraint("avoid avoid foothills", foothillsID, 12.0);
	int avoidFoothillsFar = rmCreateAreaDistanceConstraint("avoid foothills far", foothillsID, 30.0);
	int stayFoothills = rmCreateAreaMaxDistanceConstraint("stay near foothills", foothillsID, 0);
	
	int MountEbaseID = rmCreateArea("Mount E Base");
	rmSetAreaSize(MountEbaseID, 0.065, 0.065); 
	rmSetAreaWarnFailure(MountEbaseID, false);
	rmSetAreaObeyWorldCircleConstraint(MountEbaseID, false);
	rmSetAreaCliffType(MountEbaseID, "rocky mountain2"); 
	rmSetAreaTerrainType(MountEbaseID, "himalayas\ground_snow3"); // patagonia\ground_glacier_pat
	rmSetAreaCliffHeight(MountEbaseID, 8, 0.0, 0.2);
	rmSetAreaCliffEdge(MountEbaseID, 1, 1.0, 0.0, 0.0, 1);
	rmSetAreaCoherence(MountEbaseID, 0.80);
	rmSetAreaSmoothDistance(MountEbaseID, 6);
	rmAddAreaToClass(MountEbaseID, rmClassID("Cliffs"));
	rmSetAreaLocation(MountEbaseID, 0.0, 1.0);
	rmBuildArea(MountEbaseID);

	int avoidMountE = rmCreateAreaDistanceConstraint("avoid mount e", MountEbaseID, 12.0);
	int avoidMountEFar = rmCreateAreaDistanceConstraint("avoid mount e far", MountEbaseID, 30.0);
	int stayMountE = rmCreateAreaMaxDistanceConstraint("stay near mount e", MountEbaseID, 8.0);
	
	// Text
	rmSetStatusText("",0.40);
	

	
	int MountEsummitID = rmCreateArea("Mount E Summit");
	rmSetAreaSize(MountEsummitID, 0.049, 0.049); 
	rmSetAreaWarnFailure(MountEsummitID, false);
	rmSetAreaObeyWorldCircleConstraint(MountEsummitID, false);
	rmSetAreaCliffType(MountEsummitID, "rocky mountain2"); 
	rmSetAreaTerrainType(MountEsummitID, "himalayas\ground_snow3"); // patagonia\ground_glacier_pat
	rmSetAreaCliffHeight(MountEsummitID, 8, 0.0, 0.2);
	rmSetAreaCliffEdge(MountEsummitID, 1, 1.0, 0.0, 0.0, 1);
	rmSetAreaCoherence(MountEsummitID, 0.80);
	rmSetAreaSmoothDistance(MountEsummitID, 6);
	rmAddAreaToClass(MountEsummitID, rmClassID("Cliffs"));
	rmSetAreaLocation(MountEsummitID, 0.0, 1.0);
	rmBuildArea(MountEsummitID);

	int avoidMountESummit = rmCreateAreaDistanceConstraint("avoid mount e summit", MountEsummitID, 12.0);
	int avoidMountESummitFar = rmCreateAreaDistanceConstraint("avoid mount e summit far", MountEsummitID, 50.0);
	int stayMountESummit = rmCreateAreaMaxDistanceConstraint("stay near mount e summit", MountEsummitID, 8.0);

	//King's "Island"
	if (rmGetIsKOTH() == true) {
		int kingislandID=rmCreateArea("King's Island");
		if (cNumberNonGaiaPlayers > 4)
			rmSetAreaSize(kingislandID, 0.007, 0.007);
		else 
			rmSetAreaSize(kingislandID, 0.01, 0.01);
		rmSetAreaLocation(kingislandID, 0.30, 0.70);
		rmAddAreaToClass(kingislandID, classIsland);
		rmSetAreaBaseHeight(kingislandID, -4.0);
		rmSetAreaCoherence(kingislandID, 1.0);
		rmBuildArea(kingislandID); 
	
	// Place King's Hill
	float xLoc = 0.30;
	float yLoc = 0.70;
	float walk = 0.02;

	ypKingsHillPlacer(xLoc, yLoc, walk, 0);
	rmEchoInfo("XLOC = "+xLoc);
	rmEchoInfo("XLOC = "+yLoc);
	}

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
	rmSetObjectDefMinDistance(playergoldID, 14.0);
	rmSetObjectDefMaxDistance(playergoldID, 16.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 24.0);
	rmSetObjectDefMaxDistance(playergold2ID, 26.0);
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidGold);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResourcesShort);
	
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "ypTreeHimalayas", rmRandInt(8,8), 5.0);
    rmSetObjectDefMinDistance(playerTreeID, 14);
    rmSetObjectDefMaxDistance(playerTreeID, 16);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResourcesShort);
	
	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 4, 3.0);
	rmSetObjectDefMinDistance(playerberriesID, 14.0);
	rmSetObjectDefMaxDistance(playerberriesID, 16.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResourcesShort);
	
	// Starting herd
	int playeherdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playeherdID, "ypSaiga", rmRandInt(8,8), 4.0);
	rmSetObjectDefMinDistance(playeherdID, 13);
	rmSetObjectDefMaxDistance(playeherdID, 16);
	rmSetObjectDefCreateHerd(playeherdID, false);
	rmAddObjectDefToClass(playeherdID, classStartingResource);
	rmAddObjectDefConstraint(playeherdID, avoidStartingResourcesShort);
		
	// 2nd herd
	int player2ndherdID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(player2ndherdID, "ypMarcoPoloSheep", rmRandInt(8,8), 4.0);
    rmSetObjectDefMinDistance(player2ndherdID, 20);
    rmSetObjectDefMaxDistance(player2ndherdID, 22);
	rmAddObjectDefToClass(player2ndherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player2ndherdID, true);
	rmAddObjectDefConstraint(player2ndherdID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(player2ndherdID, avoidEdge);
		
	// 3nd herd
	int player3rdherdID = rmCreateObjectDef("player 3rd herd");
	rmAddObjectDefItem(player3rdherdID, "ypSaiga", rmRandInt(6,6), 4.0);
    rmSetObjectDefMinDistance(player3rdherdID, 32);
    rmSetObjectDefMaxDistance(player3rdherdID, 34);
	rmAddObjectDefToClass(player3rdherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player3rdherdID, true);
	rmAddObjectDefConstraint(player3rdherdID, avoidEdge);

	//Duber
	int DuberID = rmCreateObjectDef("Duber");
	rmAddObjectDefItem(DuberID, "ypPetSnowMonkey", 1, 1.0);	
	rmAddObjectDefToClass(DuberID, classStartingResource);
	rmSetObjectDefMinDistance(DuberID, 18.0);
	rmSetObjectDefMaxDistance(DuberID, 20.0);
	rmAddObjectDefConstraint(DuberID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(DuberID, avoidGoldMin); 		
	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 28.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 30.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	int nugget0count = rmRandInt (1,2);
	
	//  Place Starting Objects/Resources
	
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playeherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(player2ndherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if (cNumberNonGaiaPlayers > 2) {
			rmPlaceObjectDefAtLoc(player3rdherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		}

		rmPlaceObjectDefAtLoc(DuberID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if (nugget0count == 2) {
			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		}

		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}
	
	// Text
	rmSetStatusText("",0.60);
	
	// ____________________ Common Resources ____________________
	if (cNumberNonGaiaPlayers == 2) {
	// Static Mines 
		int staticgold1ID = rmCreateObjectDef("staticgold1");
			rmAddObjectDefItem(staticgold1ID, "Mine", 1, 2.0);
			rmSetObjectDefMinDistance(staticgold1ID, rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(staticgold1ID, rmXFractionToMeters(0.0));
			rmAddObjectDefToClass(staticgold1ID, classGold);
			rmAddObjectDefConstraint(staticgold1ID, avoidEdge);
			rmPlaceObjectDefAtLoc(staticgold1ID, 0, 0.50, 0.10);
	
		int staticgold2ID = rmCreateObjectDef("staticgold2");
			rmAddObjectDefItem(staticgold2ID, "Mine", 1, 2.0);
			rmSetObjectDefMinDistance(staticgold2ID, rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(staticgold2ID, rmXFractionToMeters(0.0));
			rmAddObjectDefToClass(staticgold2ID, classGold);
			rmAddObjectDefConstraint(staticgold2ID, avoidEdge);
			rmPlaceObjectDefAtLoc(staticgold2ID, 0, 0.90, 0.50);
	
		int staticgold3ID = rmCreateObjectDef("staticgold3");
			rmAddObjectDefItem(staticgold3ID, "Mine", 1, 2.0);
			rmSetObjectDefMinDistance(staticgold3ID, rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(staticgold3ID, rmXFractionToMeters(0.0));
			rmAddObjectDefToClass(staticgold3ID, classGold);
			rmAddObjectDefConstraint(staticgold3ID, avoidEdge);
			rmPlaceObjectDefAtLoc(staticgold3ID, 0, 0.15, 0.45);
	
		int staticgold4ID = rmCreateObjectDef("staticgold4");
			rmAddObjectDefItem(staticgold4ID, "Mine", 1, 2.0);
			rmSetObjectDefMinDistance(staticgold4ID, rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(staticgold4ID, rmXFractionToMeters(0.0));
			rmAddObjectDefToClass(staticgold4ID, classGold);
			rmAddObjectDefConstraint(staticgold4ID, avoidEdge);
			rmPlaceObjectDefAtLoc(staticgold4ID, 0, 0.55, 0.85);
		}
		
	// Foothill Mines 
	int gold3count = cNumberNonGaiaPlayers/2;  
	
	for(i=0; < gold3count)	{
		int commongold1ID = rmCreateObjectDef("common mines 1"+i);
		rmAddObjectDefItem(commongold1ID, "Minegold", 1, 0.0);
		rmSetObjectDefMinDistance(commongold1ID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(commongold1ID, rmXFractionToMeters(0.45));
		rmAddObjectDefToClass(commongold1ID, classGold);
		rmAddObjectDefConstraint(commongold1ID, avoidGoldType);
		rmAddObjectDefConstraint(commongold1ID, avoidEdge);
		rmAddObjectDefConstraint(commongold1ID, stayFoothills);
		rmAddObjectDefConstraint(commongold1ID, avoidMountE);
		rmAddObjectDefConstraint(commongold1ID, avoidMountESummit);
		if (cNumberNonGaiaPlayers > 2)
			rmPlaceObjectDefAtLoc(commongold1ID, 0, 0.50, 0.50);
		}

	// Gold Zone N
	int goldzoneNID = rmCreateArea("gold zone N");
	if (cNumberNonGaiaPlayers == 2) {
		rmSetAreaSize(goldzoneNID, 0.05, 0.05);
		rmSetAreaLocation(goldzoneNID, 0.50, 0.70);
		rmAddAreaInfluenceSegment(goldzoneNID, 0.50, 0.70, 0.65, 0.45);	
		}
	else {
		rmSetAreaSize(goldzoneNID, 0.08, 0.08);
		rmSetAreaLocation(goldzoneNID, 0.50, 0.70);
		rmAddAreaInfluenceSegment(goldzoneNID, 0.50, 0.70, 0.70, 0.50);	
		rmAddAreaInfluenceSegment(goldzoneNID, 0.50, 0.70, 0.50, 0.90);	
		}
	rmSetAreaWarnFailure(goldzoneNID, false);
	rmSetAreaCoherence(goldzoneNID, 1.0); 
	rmSetAreaObeyWorldCircleConstraint(goldzoneNID, false);
	rmBuildArea(goldzoneNID);	

	// Gold Zone S
	int goldzoneSID = rmCreateArea("gold zone S");
	if (cNumberNonGaiaPlayers == 2) {
		rmSetAreaSize(goldzoneSID, 0.05, 0.05);
		rmSetAreaLocation(goldzoneSID, 0.35, 0.55);
		rmAddAreaInfluenceSegment(goldzoneSID, 0.35, 0.55, 0.50, 0.30);	
		}
	else {
		rmSetAreaSize(goldzoneSID, 0.08, 0.08);
		rmSetAreaLocation(goldzoneSID, 0.30, 0.50);
		rmAddAreaInfluenceSegment(goldzoneSID, 0.30, 0.50, 0.50, 0.30);	
		rmAddAreaInfluenceSegment(goldzoneSID, 0.30, 0.50, 0.10, 0.50);	
		}
	rmSetAreaWarnFailure(goldzoneSID, false);
	rmSetAreaCoherence(goldzoneSID, 1.0); 
	rmSetAreaObeyWorldCircleConstraint(goldzoneSID, false);
	rmBuildArea(goldzoneSID);	
	
	int avoidGoldZoneN = rmCreateAreaDistanceConstraint("avoid gold zone N ", goldzoneNID, 20.0);
	int stayGoldZoneN = rmCreateAreaMaxDistanceConstraint("stay in gold zone N ", goldzoneNID, 0.0);	
	int avoidGoldZoneS = rmCreateAreaDistanceConstraint("avoid gold zone S ", goldzoneSID, 20.0);
	int stayGoldZoneS = rmCreateAreaMaxDistanceConstraint("stay in gold zone S ", goldzoneSID, 0.0);
	
	// South Mines 
	int gold1count = cNumberNonGaiaPlayers;  
	
	for(i=0; < gold1count) {
		int southgoldID = rmCreateObjectDef("south mines"+i);
		rmAddObjectDefItem(southgoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(southgoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(southgoldID, rmXFractionToMeters(0.40));
		rmAddObjectDefToClass(southgoldID, classGold);
		rmAddObjectDefConstraint(southgoldID, avoidIsland);
		rmAddObjectDefConstraint(southgoldID, avoidGold);
		rmAddObjectDefConstraint(southgoldID, avoidEdge);
	//	rmAddObjectDefConstraint(southgoldID, avoidNoResZone1);
	//	rmAddObjectDefConstraint(southgoldID, avoidNoResZone2);
		rmAddObjectDefConstraint(southgoldID, stayGoldZoneS);
		rmPlaceObjectDefAtLoc(southgoldID, 0, 0.50, 0.50);
		}

	// North Mines 
	int gold2count = cNumberNonGaiaPlayers;  
	
	for(i=0; < gold2count) {
		int northgoldID = rmCreateObjectDef("north mines"+i);
		rmAddObjectDefItem(northgoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(northgoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(northgoldID, rmXFractionToMeters(0.40));
		rmAddObjectDefToClass(northgoldID, classGold);
		rmAddObjectDefConstraint(northgoldID, avoidIsland);
		rmAddObjectDefConstraint(northgoldID, avoidGold);
		rmAddObjectDefConstraint(northgoldID, avoidEdge);
	//	rmAddObjectDefConstraint(northgoldID, avoidNoResZone1);
	//	rmAddObjectDefConstraint(northgoldID, avoidNoResZone2);
		rmAddObjectDefConstraint(northgoldID, stayGoldZoneN);
		rmPlaceObjectDefAtLoc(northgoldID, 0, 0.50, 0.50);
		}

	// No Cliffs Plz
		int nocliffs1ID = rmCreateArea("no cliffs plz 1");
		rmSetAreaSize(nocliffs1ID, 0.0025, 0.0025);
		if (cNumberNonGaiaPlayers == 2)
			rmSetAreaLocation(nocliffs1ID, 0.45, 0.10);
		rmSetAreaWarnFailure(nocliffs1ID, false);
		rmAddAreaToClass(nocliffs1ID, classIsland);
		rmSetAreaCoherence(nocliffs1ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(nocliffs1ID, false);
		rmBuildArea(nocliffs1ID);	
	
		int nocliffs2ID = rmCreateArea("no cliffs plz 2");
		rmSetAreaSize(nocliffs2ID, 0.0025, 0.0025);
		if (cNumberNonGaiaPlayers == 2)
			rmSetAreaLocation(nocliffs2ID, 0.90, 0.55);
		rmSetAreaWarnFailure(nocliffs2ID, false);
		rmAddAreaToClass(nocliffs2ID, classIsland);
		rmSetAreaCoherence(nocliffs2ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(nocliffs2ID, false);
		rmBuildArea(nocliffs2ID);	

		int nocliffs3ID = rmCreateArea("no cliffs plz 3");
		rmSetAreaSize(nocliffs3ID, 0.0025, 0.0025);
		if (cNumberNonGaiaPlayers == 2)
			rmSetAreaLocation(nocliffs3ID, 0.60, 0.90);
		else
			rmSetAreaLocation(nocliffs3ID, 0.35, 0.90);
		rmSetAreaWarnFailure(nocliffs3ID, false);
		rmAddAreaToClass(nocliffs3ID, classIsland);
		rmSetAreaCoherence(nocliffs3ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(nocliffs3ID, false);
		rmBuildArea(nocliffs3ID);	
	
		int nocliffs4ID = rmCreateArea("no cliffs plz 4");
		rmSetAreaSize(nocliffs4ID, 0.0025, 0.0025);
		if (cNumberNonGaiaPlayers == 2)
			rmSetAreaLocation(nocliffs4ID, 0.10, 0.40);
		else
			rmSetAreaLocation(nocliffs4ID, 0.10, 0.65);
		rmSetAreaWarnFailure(nocliffs4ID, false);
		rmAddAreaToClass(nocliffs4ID, classIsland);
		rmSetAreaCoherence(nocliffs4ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(nocliffs4ID, false);
		rmBuildArea(nocliffs4ID);	

		int nocliffs5ID = rmCreateArea("no cliffs plz 5");
		rmSetAreaSize(nocliffs5ID, 0.0025, 0.0025);
		rmSetAreaLocation(nocliffs5ID, 0.90, 0.30);
		rmSetAreaWarnFailure(nocliffs5ID, false);
		rmAddAreaToClass(nocliffs5ID, classIsland);
		rmSetAreaCoherence(nocliffs5ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(nocliffs5ID, false);
		rmBuildArea(nocliffs5ID);	
	
		int nocliffs6ID = rmCreateArea("no cliffs plz 6");
		rmSetAreaSize(nocliffs6ID, 0.0025, 0.0025);
		rmSetAreaLocation(nocliffs6ID, 0.70, 0.10);
		rmSetAreaWarnFailure(nocliffs6ID, false);
		rmAddAreaToClass(nocliffs6ID, classIsland);
		rmSetAreaCoherence(nocliffs6ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(nocliffs6ID, false);
		rmBuildArea(nocliffs6ID);	

		int nocliffs7ID = rmCreateArea("no cliffs plz 7");
		rmSetAreaSize(nocliffs7ID, 0.0025, 0.0025);
		rmSetAreaLocation(nocliffs7ID, 0.40, 0.80);
		rmSetAreaWarnFailure(nocliffs7ID, false);
		rmAddAreaToClass(nocliffs7ID, classIsland);
		rmSetAreaCoherence(nocliffs7ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(nocliffs7ID, false);
		rmBuildArea(nocliffs7ID);	
	
		int nocliffs8ID = rmCreateArea("no cliffs plz 8");
		rmSetAreaSize(nocliffs8ID, 0.0025, 0.0025);
		rmSetAreaLocation(nocliffs8ID, 0.20, 0.60);
		rmSetAreaWarnFailure(nocliffs8ID, false);
		rmAddAreaToClass(nocliffs8ID, classIsland);
		rmSetAreaCoherence(nocliffs8ID, 1.0); 
		rmSetAreaObeyWorldCircleConstraint(nocliffs8ID, false);
		rmBuildArea(nocliffs8ID);	
				
	// Mountains
	for (i=0; <20+3*cNumberNonGaiaPlayers)
	{
		int mountainID=rmCreateArea("mountain"+i);
		if (cNumberNonGaiaPlayers == 2)
			rmSetAreaSize(mountainID, 0.00225, 0.00225);
		else if (cNumberNonGaiaPlayers <= 4)
			rmSetAreaSize(mountainID, 0.00175, 0.00175);
		else
			rmSetAreaSize(mountainID, 0.001, 0.001);
		rmSetAreaWarnFailure(mountainID, false);
		rmSetAreaObeyWorldCircleConstraint(mountainID, false);
		rmAddAreaToClass(mountainID, rmClassID("Cliffs"));
		rmSetAreaCoherence(mountainID, 0.75);
		rmSetAreaCliffType(mountainID, "himalayas");  
		rmSetAreaMix(noreszone2ID, "himalayas_a");	
		rmSetAreaCliffHeight(mountainID, 6, 0.0, 0.4);
		rmSetAreaCliffEdge(mountainID, 1, 1.0, 0.0, 0.0, 1);
		rmAddAreaConstraint(mountainID, avoidIslandShort);
		rmAddAreaConstraint(mountainID, avoidGoldShort);
		rmAddAreaConstraint(mountainID, avoidCliffFar);
		rmAddAreaConstraint(mountainID, avoidTradeRouteShort);
		rmAddAreaConstraint(mountainID, avoidTradeRouteSocketShort);
		rmAddAreaConstraint(mountainID, avoidSocket);
		rmBuildArea(mountainID);
	}

	// Patch1
	for (i=0; < 12*cNumberNonGaiaPlayers)
    {
        int patch1ID = rmCreateArea("patch1"+i);
        rmSetAreaWarnFailure(patch1ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch1ID, false);
        rmSetAreaSize(patch1ID, rmAreaTilesToFraction(33), rmAreaTilesToFraction(33));
		rmSetAreaTerrainType(patch1ID, "himalayas\ground_snow5");
        rmAddAreaToClass(patch1ID, rmClassID("patch"));
        rmSetAreaMinBlobs(patch1ID, 1);
        rmSetAreaMaxBlobs(patch1ID, 5);
        rmSetAreaMinBlobDistance(patch1ID, 16.0);
        rmSetAreaMaxBlobDistance(patch1ID, 40.0);
        rmSetAreaCoherence(patch1ID, 0.0);
		rmAddAreaConstraint(patch1ID, avoidPatch);
		rmAddAreaConstraint(patch1ID, avoidCliff);
		rmAddAreaConstraint(patch1ID, avoidNoResZone1Short);
		rmAddAreaConstraint(patch1ID, avoidNoResZone2Short);
		rmAddAreaConstraint(patch1ID, avoidNatives);
        rmBuildArea(patch1ID); 
    }

	// Patch2
	for (i=0; < 12*cNumberNonGaiaPlayers) {
        int patch2ID = rmCreateArea("patch2"+i);
        rmSetAreaWarnFailure(patch2ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch2ID, false);
        rmSetAreaSize(patch2ID, rmAreaTilesToFraction(20), rmAreaTilesToFraction(20));
		rmSetAreaTerrainType(patch2ID, "himalayas\ground_snow4");
        rmAddAreaToClass(patch2ID, rmClassID("patch2"));
        rmSetAreaMinBlobs(patch2ID, 1);
        rmSetAreaMaxBlobs(patch2ID, 5);
        rmSetAreaMinBlobDistance(patch2ID, 16.0);
        rmSetAreaMaxBlobDistance(patch2ID, 40.0);
        rmSetAreaCoherence(patch2ID, 0.0);
		rmAddAreaConstraint(patch2ID, avoidPatch2);
		rmAddAreaConstraint(patch2ID, avoidCliff);
		rmAddAreaConstraint(patch2ID, avoidIslandShort);
		rmAddAreaConstraint(patch2ID, avoidNoResZone1Short);
		rmAddAreaConstraint(patch2ID, avoidNoResZone2Short);
		rmAddAreaConstraint(patch2ID, avoidNatives);
        rmBuildArea(patch2ID); 
		}

	// Patch3
	for (i=0; < 12+10*cNumberNonGaiaPlayers) {
        int patch3ID = rmCreateArea("patch3"+i);
        rmSetAreaWarnFailure(patch3ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch3ID, false);
        rmSetAreaSize(patch3ID, rmAreaTilesToFraction(43), rmAreaTilesToFraction(43));
		rmSetAreaTerrainType(patch3ID, "himalayas\ground_snow3");
        rmAddAreaToClass(patch3ID, rmClassID("patch3"));
        rmSetAreaMinBlobs(patch3ID, 1);
        rmSetAreaMaxBlobs(patch3ID, 5);
        rmSetAreaMinBlobDistance(patch3ID, 16.0);
        rmSetAreaMaxBlobDistance(patch3ID, 40.0);
        rmSetAreaCoherence(patch3ID, 0.0);
		rmAddAreaConstraint(patch3ID, avoidPatch3);
		rmAddAreaConstraint(patch3ID, avoidIslandMin);
		rmAddAreaConstraint(patch3ID, stayNoResZone1);
        rmBuildArea(patch3ID); 
		}

	// Patch4
	for (i=0; < 12+10*cNumberNonGaiaPlayers) {
        int patch4ID = rmCreateArea("patch4"+i);
        rmSetAreaWarnFailure(patch4ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch4ID, false);
        rmSetAreaSize(patch4ID, rmAreaTilesToFraction(43), rmAreaTilesToFraction(43));
		rmSetAreaTerrainType(patch4ID, "himalayas\ground_snow5");
        rmAddAreaToClass(patch4ID, rmClassID("patch3"));
        rmSetAreaMinBlobs(patch4ID, 1);
        rmSetAreaMaxBlobs(patch4ID, 5);
        rmSetAreaMinBlobDistance(patch4ID, 16.0);
        rmSetAreaMaxBlobDistance(patch4ID, 40.0);
        rmSetAreaCoherence(patch4ID, 0.0);
		rmAddAreaConstraint(patch4ID, avoidPatch3);
		rmAddAreaConstraint(patch4ID, avoidIslandMin);
		rmAddAreaConstraint(patch4ID, stayNoResZone2);
        rmBuildArea(patch4ID); 
		}
		
	// Text
	rmSetStatusText("",0.70);

	// Main Forest
	int mainforestcount = 14+4*cNumberNonGaiaPlayers;
	int stayInForestPatch = -1;

	for (i=0; < mainforestcount)
    {
        int forestpatchID = rmCreateArea("main forest patch"+i);
        rmSetAreaWarnFailure(forestpatchID, false);
		rmSetAreaObeyWorldCircleConstraint(forestpatchID, false);
        rmSetAreaSize(forestpatchID, rmAreaTilesToFraction(80), rmAreaTilesToFraction(80));
		rmSetAreaTerrainType(forestpatchID, "himalayas\ground_dirt5_himal");
        rmSetAreaMinBlobs(forestpatchID, 2);
        rmSetAreaMaxBlobs(forestpatchID, 3);
        rmSetAreaMinBlobDistance(forestpatchID, 10.0);
        rmSetAreaMaxBlobDistance(forestpatchID, 30.0);
        rmSetAreaCoherence(forestpatchID, 0.2);
		rmSetAreaSmoothDistance(forestpatchID, 5);
		rmAddAreaConstraint(forestpatchID, avoidForest);
		rmAddAreaConstraint(forestpatchID, avoidIslandMin);
		rmAddAreaConstraint(forestpatchID, avoidGoldShort);
		rmAddAreaConstraint(forestpatchID, avoidEdge);        
		rmAddAreaConstraint(forestpatchID, avoidCliff);        
		rmAddAreaConstraint(forestpatchID, avoidTradeRouteMin);        
		rmAddAreaConstraint(forestpatchID, avoidTradeRouteSocketShort);        
		rmAddAreaConstraint(forestpatchID, avoidNatives);        
		rmBuildArea(forestpatchID);

		stayInForestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest patch"+i, forestpatchID, 0.0);

		for (j=0; < rmRandInt(7,8))
		{
			int foresttreeID = rmCreateObjectDef("forest trees"+i+j);
			rmAddObjectDefItem(foresttreeID, "ypTreeHimalayas", rmRandInt(2,3), 4.0);
			rmSetObjectDefMinDistance(foresttreeID, rmXFractionToMeters(0.00));
			rmSetObjectDefMaxDistance(foresttreeID, rmXFractionToMeters(0.50));
			rmAddObjectDefToClass(foresttreeID, classForest);
			rmAddObjectDefConstraint(foresttreeID, stayInForestPatch);
			rmPlaceObjectDefAtLoc(foresttreeID, 0, 0.50, 0.50);
		}
    }
	
	// Random Trees
	for (i=0; < 6+2*cNumberNonGaiaPlayers)
	{
		int randomtreeID = rmCreateObjectDef("random tree "+i);
		rmAddObjectDefItem(randomtreeID, "TreeRockiesSnow", rmRandInt(2,3), 5.0);
		rmSetObjectDefMinDistance(randomtreeID,  rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(randomtreeID,  rmXFractionToMeters(0.45));
		rmAddObjectDefToClass(randomtreeID, classForest);
		rmAddObjectDefConstraint(randomtreeID, avoidForestShort);
		rmAddObjectDefConstraint(randomtreeID, stayFoothills);
		rmAddObjectDefConstraint(randomtreeID, avoidGoldShort);
		rmAddObjectDefConstraint(randomtreeID, avoidMountE);
		rmAddObjectDefConstraint(randomtreeID, avoidSheepMin);
		rmPlaceObjectDefAtLoc(randomtreeID, 0, 0.50, 0.50);
	}
	
	// Text
	rmSetStatusText("",0.80);

	// Static Herds 
	int staticherdID = rmCreateObjectDef("static herd");
	rmAddObjectDefItem(staticherdID, "ypMarcoPoloSheep", rmRandInt(7,8), 3.0);
	rmSetObjectDefMinDistance(staticherdID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherdID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherdID, true);
	if (cNumberNonGaiaPlayers == 2)
		rmPlaceObjectDefAtLoc(staticherdID, 0, 0.45, 0.10);

	int staticherd2ID = rmCreateObjectDef("static herd2");
	rmAddObjectDefItem(staticherd2ID, "ypMarcoPoloSheep", rmRandInt(7,8), 3.0);
	rmSetObjectDefMinDistance(staticherd2ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd2ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd2ID, true);
	if (cNumberNonGaiaPlayers == 2)
		rmPlaceObjectDefAtLoc(staticherd2ID, 0, 0.90, 0.55);

	int staticherd3ID = rmCreateObjectDef("static herd3");
	rmAddObjectDefItem(staticherd3ID, "ypMarcoPoloSheep", rmRandInt(7,8), 3.0);
	rmSetObjectDefMinDistance(staticherd3ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd3ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd3ID, true);
	if (cNumberNonGaiaPlayers == 2)
		rmPlaceObjectDefAtLoc(staticherd3ID, 0, 0.60, 0.90);
	else
		rmPlaceObjectDefAtLoc(staticherd3ID, 0, 0.35, 0.90);
	
	int staticherd4ID = rmCreateObjectDef("static herd4");
	rmAddObjectDefItem(staticherd4ID, "ypMarcoPoloSheep", rmRandInt(7,8), 3.0);
	rmSetObjectDefMinDistance(staticherd4ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd4ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd4ID, true);
	if (cNumberNonGaiaPlayers == 2)
		rmPlaceObjectDefAtLoc(staticherd4ID, 0, 0.10, 0.40);
	else
		rmPlaceObjectDefAtLoc(staticherd4ID, 0, 0.10, 0.65);

	int staticherd5ID = rmCreateObjectDef("static herd5");
	rmAddObjectDefItem(staticherd5ID, "ypMarcoPoloSheep", rmRandInt(7,8), 3.0);
	rmSetObjectDefMinDistance(staticherd5ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd5ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd5ID, true);
	rmPlaceObjectDefAtLoc(staticherd5ID, 0, 0.90, 0.30);

	int staticherd6ID = rmCreateObjectDef("static herd6");
	rmAddObjectDefItem(staticherd6ID, "ypMarcoPoloSheep", rmRandInt(7,8), 3.0);
	rmSetObjectDefMinDistance(staticherd6ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd6ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd6ID, true);
	rmPlaceObjectDefAtLoc(staticherd6ID, 0, 0.70, 0.10);

	int staticherd7ID = rmCreateObjectDef("static herd7");
	rmAddObjectDefItem(staticherd7ID, "ypMarcoPoloSheep", rmRandInt(7,8), 3.0);
	rmSetObjectDefMinDistance(staticherd7ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd7ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd7ID, true);
	rmPlaceObjectDefAtLoc(staticherd7ID, 0, 0.40, 0.80);
	
	int staticherd8ID = rmCreateObjectDef("static herd8");
	rmAddObjectDefItem(staticherd8ID, "ypMarcoPoloSheep", rmRandInt(7,8), 3.0);
	rmSetObjectDefMinDistance(staticherd8ID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(staticherd8ID, rmXFractionToMeters(0.00));
	rmSetObjectDefCreateHerd(staticherd8ID, true);
	rmPlaceObjectDefAtLoc(staticherd8ID, 0, 0.20, 0.60);
		
	// South Herds 
	int sheepherdcount = cNumberNonGaiaPlayers;
		
	for (i=0; < sheepherdcount) {
		int southherdID = rmCreateObjectDef("south herd"+i);
		rmAddObjectDefItem(southherdID, "ypMarcoPoloSheep", rmRandInt(7,8), 3.0);
		rmSetObjectDefMinDistance(southherdID, 0.0);
		rmSetObjectDefMaxDistance(southherdID, rmXFractionToMeters(0.42));
		rmSetObjectDefCreateHerd(southherdID, true);
		rmAddObjectDefConstraint(southherdID, avoidForestMin);
		rmAddObjectDefConstraint(southherdID, avoidGoldMin);
		rmAddObjectDefConstraint(southherdID, avoidCliffMin); 
		if (cNumberNonGaiaPlayers == 2) 
			rmAddObjectDefConstraint(southherdID, avoidSheepShort);
		else 
			rmAddObjectDefConstraint(southherdID, avoidSheep);
		rmAddObjectDefConstraint(southherdID, avoidTradeRouteSocketMin);
	//	if (cNumberNonGaiaPlayers == 2) {
	//		rmAddObjectDefConstraint(southherdID, avoidNoResZone1);
	//		rmAddObjectDefConstraint(southherdID, avoidNoResZone2);
	//		}
		rmAddObjectDefConstraint(southherdID, stayGoldZoneS);
		rmPlaceObjectDefAtLoc(southherdID, 0, 0.10, 0.10);	
		}

	// North Herds 
	int sheepherd2count = cNumberNonGaiaPlayers;
		
	for (i=0; < sheepherd2count) {
		int northherdID = rmCreateObjectDef("north herd"+i);
		rmAddObjectDefItem(northherdID, "ypMarcoPoloSheep", rmRandInt(7,8), 3.0);
		rmSetObjectDefMinDistance(northherdID, 0.0);
		rmSetObjectDefMaxDistance(northherdID, rmXFractionToMeters(0.42));
		rmSetObjectDefCreateHerd(northherdID, true);
		rmAddObjectDefConstraint(northherdID, avoidForestMin);
		rmAddObjectDefConstraint(northherdID, avoidGoldMin);
		rmAddObjectDefConstraint(northherdID, avoidCliffMin); 
		if (cNumberNonGaiaPlayers == 2) 
			rmAddObjectDefConstraint(northherdID, avoidSheepShort);
		else 
			rmAddObjectDefConstraint(northherdID, avoidSheep);
		rmAddObjectDefConstraint(northherdID, avoidTradeRouteSocketMin);
	//	if (cNumberNonGaiaPlayers == 2) {
	//		rmAddObjectDefConstraint(northherdID, avoidNoResZone1);
	//		rmAddObjectDefConstraint(northherdID, avoidNoResZone2);
	//		}
		rmAddObjectDefConstraint(northherdID, stayGoldZoneN);
		rmPlaceObjectDefAtLoc(northherdID, 0, 0.90, 0.90);	
		}
		
	int sheepherd3count = cNumberNonGaiaPlayers/2;
		
	for (i=0; < sheepherd3count)
	{
		int mountEherd1ID = rmCreateObjectDef("mountE herd"+i);
		rmAddObjectDefItem(mountEherd1ID, "ypMarcoPoloSheep", rmRandInt(6,7), 5.0);
		rmSetObjectDefMinDistance(mountEherd1ID, 0.0);
		rmSetObjectDefMaxDistance(mountEherd1ID, rmXFractionToMeters(0.30));
		rmSetObjectDefCreateHerd(mountEherd1ID, true);
		rmAddObjectDefConstraint(mountEherd1ID, avoidForestMin);
		rmAddObjectDefConstraint(mountEherd1ID, avoidGoldShort);
		rmAddObjectDefConstraint(mountEherd1ID, avoidSheepShort);
		rmAddObjectDefConstraint(mountEherd1ID, stayMountESummit);
		rmAddObjectDefConstraint(mountEherd1ID, avoidEdge);
		rmPlaceObjectDefAtLoc(mountEherd1ID, 0, 0.20, 0.80);	
	}

	int sheepherd4count = cNumberNonGaiaPlayers/2;
		
	for (i=0; < sheepherd4count)
	{
		int mountEherd2ID = rmCreateObjectDef("mountE herd2"+i);
		rmAddObjectDefItem(mountEherd2ID, "ypMarcoPoloSheep", rmRandInt(4,5), 5.0);
		rmSetObjectDefMinDistance(mountEherd2ID, 0.0);
		rmSetObjectDefMaxDistance(mountEherd2ID, rmXFractionToMeters(0.50));
		rmSetObjectDefCreateHerd(mountEherd2ID, true);
		rmAddObjectDefConstraint(mountEherd2ID, avoidForestMin);
		rmAddObjectDefConstraint(mountEherd2ID, avoidGoldShort);
		rmAddObjectDefConstraint(mountEherd2ID, avoidSheepShort);
		rmAddObjectDefConstraint(mountEherd2ID, stayMountE);
		rmAddObjectDefConstraint(mountEherd2ID, avoidEdge);
		rmPlaceObjectDefAtLoc(mountEherd2ID, 0, 0.20, 0.80);	
	}
	
	// Text
	rmSetStatusText("",0.90);
		
	// Treasures 
	int treasure1count = 6+cNumberNonGaiaPlayers;
	int treasure2count = 2+cNumberNonGaiaPlayers;
	int treasure3count = cNumberNonGaiaPlayers;
	
	// Treasures L3	
	for (i=0; < treasure3count)
	{
		int Nugget3ID = rmCreateObjectDef("nugget lvl3 "+i); 
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, 0);
		rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.45));
		rmSetNuggetDifficulty(3,4);
		rmAddObjectDefConstraint(Nugget3ID, avoidNuggetShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget3ID, stayFoothills);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget3ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget3ID, avoidMountE); 
		rmAddObjectDefConstraint(Nugget3ID, avoidCliff); 
		rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50);
	}
	
	// Treasures L2	
	for (i=0; < treasure2count)
	{
		int Nugget2ID = rmCreateObjectDef("nugget lvl2 "+i); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.45));
		rmSetNuggetDifficulty(2,3);
		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidIslandShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget2ID, avoidCliff); 
		rmAddObjectDefConstraint(Nugget2ID, avoidNatives); 
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}
	
	// Treasures L1
	for (i=0; < treasure1count)
	{
		int Nugget1ID = rmCreateObjectDef("nugget lvl1 "+i); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, 0);
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.48));
		rmSetNuggetDifficulty(1,2);
		rmAddObjectDefConstraint(Nugget1ID, avoidNuggetShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidIslandMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget1ID, avoidCliff); 
		rmAddObjectDefConstraint(Nugget1ID, avoidNatives); 
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);
	}
	
	// Text
	rmSetStatusText("",1.00);

	
} //END
	
	