// ESOC ALASKA
// designed by Garja
// observer UI by Aizamk

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
	int playerTiles=14000; //11000
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(true);
	
	// Picks a default water height
	rmSetSeaLevel(2.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

//	rmSetMapElevationParameters(cElevTurbulence, 0.05, 2, 0.5, 4.0); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);
	
	
	// Picks default terrain and water
	rmSetSeaType("alaska coast");
	rmSetBaseTerrainMix("carolina_grass"); // 
	rmTerrainInitialize("water", 2.0); // 
	rmSetMapType("northwestTerritory"); 
	rmSetMapType("grass");
	rmSetMapType("water");
	rmSetMapType("namerica");
	rmSetMapType("AIFishingUseful");
	rmSetLightingSet("saguenay");
	rmSetWindMagnitude(2.0);
	
	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);
	
	// Set up Natives
	int subCiv0 = -1;
	subCiv0 = rmGetCivID("Nootka");
	rmSetSubCiv(0, "Nootka");
	

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	int classBay = rmDefineClass("Bay");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classPatch3 = rmDefineClass("patch3");
	int classPond = rmDefineClass("pond");
	int classRocks = rmDefineClass("rocks");
	int classGrass = rmDefineClass("grass");
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
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.46), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayNW = rmCreateBoxConstraint("stay NW", 0.00, 0.55, 1.00, 0.90, 0.00);	
	int staySE = rmCreatePieConstraint("Stay SE", 0.50, 0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(90),rmDegreesToRadians(270));
	int stayMiddle = rmCreateBoxConstraint("stay in the middle", 0.34-0.01*cNumberNonGaiaPlayers, 0.00, 0.66+0.01*cNumberNonGaiaPlayers, 1.00, 0.00);	
	int staySW = rmCreatePieConstraint("Stay SW", 0.40, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(225),rmDegreesToRadians(360));
	int stayNE = rmCreatePieConstraint("Stay NE", 0.60, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(360),rmDegreesToRadians(135));
	int staySouthHalf = rmCreatePieConstraint("Stay south half", 0.45, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(180),rmDegreesToRadians(360));
	int stayNorthHalf = rmCreatePieConstraint("Stay north half", 0.55, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(360),rmDegreesToRadians(180));
	int stayMiddleWater = rmCreatePieConstraint("Stay in middle of water", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(320),rmDegreesToRadians(40));
	int staySidesWater = rmCreatePieConstraint("Stay in water sides", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(20),rmDegreesToRadians(340));
	
	// Resource avoidance
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 27.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 21.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidElkFar = rmCreateTypeDistanceConstraint("avoid Elk far", "Seal", 60.0);
	int avoidElk = rmCreateTypeDistanceConstraint("avoid Elk", "Seal", 42.0);
	int avoidElkShort = rmCreateTypeDistanceConstraint("avoid Elk short", "Seal", 35.0);
	int avoidElkMin = rmCreateTypeDistanceConstraint("avoid Elk min", "Seal", 4.0);
	int avoidMooseFar = rmCreateTypeDistanceConstraint("avoid Moose far", "moose", 42.0);
	int avoidMoose = rmCreateTypeDistanceConstraint("avoid  Moose", "moose", 40.0);
	int avoidMooseShort = rmCreateTypeDistanceConstraint("avoid  Moose short", "moose", 35.0);
	int avoidMooseMin = rmCreateTypeDistanceConstraint("avoid Moose min", "moose", 5.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 25.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 8.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 35.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 50.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 12.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 40.0+0.67*cNumberNonGaiaPlayers);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 52.0+1*cNumberNonGaiaPlayers);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 66.0);
	int avoidBerriesMin = rmCreateTypeDistanceConstraint("avoid berries min ", "berrybush", 10.0);
	int avoidBerriesShort = rmCreateTypeDistanceConstraint("avoid berries short ", "berrybush", 12.0);
	int avoidBerries = rmCreateTypeDistanceConstraint("avoid berries ", "berrybush", 40.0);
	int avoidBerriesFar = rmCreateTypeDistanceConstraint("avoid berries far ", "berrybush", 52.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 15.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 45.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 52.0);
	int avoidTownCenterVeryFar = rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 85.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 50.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 48.0);
	int avoidTownCenterMed = rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 50.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 24.0);
	int avoidTownCenterMin = rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 18.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid natives short", rmClassID("natives"), 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 8.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("avoid natives far", rmClassID("natives"), 15.0);
	int avoidStartingResourcesFar = rmCreateClassDistanceConstraint("avoid starting resources far", rmClassID("startingResource"), 12.0);
	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 4.0);
	int avoidWhale=rmCreateTypeDistanceConstraint("avoid whale", "fish", 30.0);
	int avoidFish=rmCreateTypeDistanceConstraint("avoid fish", "fish", 26.0);
	int avoidColonyShip = rmCreateTypeDistanceConstraint("avoid colony ship", "HomeCityWaterSpawnFlag", 10.0);


	// Avoid impassable land
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("avoid impassable land min", "Land", false, 1.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("avoid impassable land short", "Land", false, 3.0);
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("avoid impassable land medium", "Land", false, 12.0);
	int avoidImpassableLandFar = rmCreateTerrainDistanceConstraint("avoid impassable land far", "Land", false, 20.0);
	int stayNearLand = rmCreateTerrainMaxDistanceConstraint("stay near land ", "Land", true, 5.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 10.0);
	int avoidLandFar = rmCreateTerrainDistanceConstraint("avoid land far ", "Land", true, 12.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 5.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 10);
	int avoidWaterFar = rmCreateTerrainDistanceConstraint("avoid water far", "water", true, 30.0);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 20.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 10.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 20.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 5.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", rmClassID("Cliffs"), 2.0);
	int avoidCliffFar = rmCreateClassDistanceConstraint("avoid cliff far", rmClassID("Cliffs"), 16+2*cNumberNonGaiaPlayers);
	
	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);	
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 5.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 8.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route socket short", "socketTradeRoute", 3.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 10.0);
   
	
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
					rmPlacePlayer(1, 0.78, 0.45);
					rmPlacePlayer(2, 0.22, 0.45);
				}
				else
				{
					rmPlacePlayer(2, 0.78, 0.45);
					rmPlacePlayer(1, 0.22, 0.45);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.18, 0.35, 0.28, 0.62, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.82, 0.35, 0.72, 0.62, 0.00, 0.20);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.20, 0.32, 0.30, 0.65, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.80, 0.32, 0.70, 0.65, 0.00, 0.20);
				}
			}
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.78, 0.45, 0.79, 0.45, 0.00, 0.20);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmPlacePlayersLine(0.18, 0.35, 0.28, 0.62, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.20, 0.32, 0.30, 0.65, 0.00, 0.20);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.22, 0.45, 0.21, 0.45, 0.00, 0.20);

						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmPlacePlayersLine(0.82, 0.35, 0.72, 0.62, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.80, 0.32, 0.70, 0.65, 0.00, 0.20);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.18, 0.35, 0.28, 0.62, 0.00, 0.20);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.80, 0.32, 0.70, 0.65, 0.00, 0.20);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.20, 0.32, 0.30, 0.65, 0.00, 0.20);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.82, 0.35, 0.72, 0.62, 0.00, 0.20);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.18, 0.26, 0.28, 0.70, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.82, 0.26, 0.72, 0.70, 0.00, 0.20);
				}
			}
		}
		else // FFA
		{
	//		rmSetTeamSpacingModifier(0.25);
			rmSetPlayerPlacementArea(0.08, 0.00 , 0.92, 0.64);
			rmSetPlacementSection(0.700, 0.300);
			rmPlacePlayersCircular(0.40+0.0025*cNumberNonGaiaPlayers, 0.40+0.0025*cNumberNonGaiaPlayers, 0.0);
		}

	

	// **************************************************************************************************
   
	// Text
	rmSetStatusText("",0.30);
	
	// ******************************************** MAP LAYOUT **************************************************
	
	//Bay Template
	int bayID = rmCreateArea("bay");
	rmSetAreaSize(bayID, 0.045, 0.045);
	rmSetAreaLocation(bayID, 0.50, 0.80);
	rmSetAreaObeyWorldCircleConstraint(bayID, false);
	rmAddAreaInfluenceSegment(bayID, 0.56, 0.90, 0.50, 0.75); 
	rmAddAreaInfluenceSegment(bayID, 0.44, 0.90, 0.50, 0.75); 
//	rmSetAreaWaterType(bayID, "atlantic coast"); 
//	rmSetAreaMinBlobs(bayID, 8);
//	rmSetAreaMaxBlobs(bayID, 10);
//	rmSetAreaMinBlobDistance(bayID, 10);
//	rmSetAreaMaxBlobDistance(bayID, 20);
	rmSetAreaCoherence(bayID, 0.50);
	rmSetAreaSmoothDistance(bayID, 4+2*cNumberNonGaiaPlayers);
	rmBuildArea(bayID);
	
	int stayNearbay = rmCreateAreaMaxDistanceConstraint("stay near bay", bayID, 25);
	int stayClosebay = rmCreateAreaMaxDistanceConstraint("stay close to bay", bayID, 15);
	int avoidbay = rmCreateAreaDistanceConstraint("avoid bay", bayID, 1.0);
	int avoidbayMed = rmCreateAreaDistanceConstraint("avoid bay med", bayID, 15);
	int avoidbayFar = rmCreateAreaDistanceConstraint("avoid bay far", bayID, 30);
	
	//Corner top 
	int cornertopID = rmCreateArea("corner top");
    rmSetAreaWarnFailure(cornertopID, false);
	rmSetAreaObeyWorldCircleConstraint(cornertopID, false);
    rmSetAreaSize(cornertopID, 0.07, 0.07);
	rmSetAreaLocation(cornertopID, 0.90, 0.22);
	rmAddAreaInfluenceSegment(cornertopID, 1.00, 0.12, 0.80, 0.32); 
	rmSetAreaMix(cornertopID, "carolina_grass");
	rmSetAreaElevationType(cornertopID, cElevTurbulence);
	rmSetAreaBaseHeight(cornertopID, 4.0);
	rmSetAreaElevationVariation(cornertopID, 4.0);
	rmSetAreaElevationMinFrequency(cornertopID, 0.045);
	rmSetAreaElevationOctaves(cornertopID, 2);
	rmSetAreaElevationPersistence(cornertopID, 0.44);     
    rmSetAreaCoherence(cornertopID, 0.9);
	rmSetAreaSmoothDistance(cornertopID, 8+2*cNumberNonGaiaPlayers);
    rmBuildArea(cornertopID); 
	
	int stayInCornertop = rmCreateAreaMaxDistanceConstraint("stay in corner top", cornertopID, 0.0);
	
	//Corner bottom 
	int cornerbottomID = rmCreateArea("corner bottom");
    rmSetAreaWarnFailure(cornerbottomID, false);
	rmSetAreaObeyWorldCircleConstraint(cornerbottomID, false);
    rmSetAreaSize(cornerbottomID, 0.07, 0.07);
	rmSetAreaLocation(cornerbottomID, 0.10, 0.22);
	rmAddAreaInfluenceSegment(cornerbottomID, 0.00, 0.12, 0.20, 0.32); 
	rmSetAreaMix(cornerbottomID, "carolina_grass");
	rmSetAreaElevationType(cornerbottomID, cElevTurbulence);
	rmSetAreaBaseHeight(cornerbottomID, 4.0);
	rmSetAreaElevationVariation(cornerbottomID, 4.0);
	rmSetAreaElevationMinFrequency(cornerbottomID, 0.045);
	rmSetAreaElevationOctaves(cornerbottomID, 2);
	rmSetAreaElevationPersistence(cornerbottomID, 0.44);     
    rmSetAreaCoherence(cornerbottomID, 0.9);
	rmSetAreaSmoothDistance(cornerbottomID, 8+2*cNumberNonGaiaPlayers);
    rmBuildArea(cornerbottomID); 
	
	int stayInCornerbottom = rmCreateAreaMaxDistanceConstraint("stay in corner bottom", cornerbottomID, 0.0);
	
	//Main Land 
	int landID = rmCreateArea("main land");
    rmSetAreaWarnFailure(landID, false);
	rmSetAreaObeyWorldCircleConstraint(landID, false);
    rmSetAreaSize(landID, 0.53, 0.53);
	rmSetAreaLocation(landID, 0.50, 0.22);
	rmAddAreaInfluenceSegment(landID, 0.50, 0.18, 0.50, 0.40);
	rmSetAreaMix(landID, "carolina_grass");
	rmSetAreaElevationType(landID, cElevTurbulence);
	rmSetAreaBaseHeight(landID, 4.0);
	rmSetAreaElevationVariation(landID, 4.0);
	rmSetAreaElevationMinFrequency(landID, 0.045);
	rmSetAreaElevationOctaves(landID, 2);
	rmSetAreaElevationPersistence(landID, 0.44);     
    rmSetAreaCoherence(landID, 0.80);
	rmSetAreaSmoothDistance(landID, 8+2*cNumberNonGaiaPlayers);
	rmAddAreaConstraint(landID, avoidbay);
    rmBuildArea(landID); 
	
	//Spur top 
	int spurtopID = rmCreateArea("spur top");
    rmSetAreaWarnFailure(spurtopID, false);
	rmSetAreaObeyWorldCircleConstraint(spurtopID, false);
    rmSetAreaSize(spurtopID, 0.045, 0.045);
	rmSetAreaLocation(spurtopID, 0.66, 0.70);
//	rmAddAreaInfluenceSegment(spurtopID, 0.50, 0.08, 0.50, 0.40);
	rmSetAreaMix(spurtopID, "carolina_grass");
//	rmSetAreaTerrainType(spurtopID, "new_england\ground2_cliff_ne"); // for testing
	rmSetAreaElevationType(spurtopID, cElevTurbulence);
	rmSetAreaBaseHeight(spurtopID, 4.0);
	rmSetAreaElevationVariation(spurtopID, 3.5);
	rmSetAreaElevationMinFrequency(spurtopID, 0.045);
	rmSetAreaElevationOctaves(spurtopID, 2);
	rmSetAreaElevationPersistence(spurtopID, 0.44);     
    rmSetAreaCoherence(spurtopID, 0.70);
	rmSetAreaSmoothDistance(spurtopID, 6+2*cNumberNonGaiaPlayers);
	rmAddAreaConstraint(spurtopID, avoidbay);
    rmBuildArea(spurtopID); 
	
	int stayInSpurtop = rmCreateAreaMaxDistanceConstraint("stay in spur top", spurtopID, 0.0);
	
	//Spur bottom 
	int spurbottomID = rmCreateArea("spur bottom");
    rmSetAreaWarnFailure(spurbottomID, false);
	rmSetAreaObeyWorldCircleConstraint(spurbottomID, false);
    rmSetAreaSize(spurbottomID, 0.045, 0.045);
	rmSetAreaLocation(spurbottomID, 0.34, 0.70);
//	rmAddAreaInfluenceSegment(spurbottomID, 0.50, 0.08, 0.50, 0.40);
	rmSetAreaMix(spurbottomID, "carolina_grass");
//	rmSetAreaTerrainType(spurbottomID, "new_england\ground2_cliff_ne"); // for testing
	rmSetAreaElevationType(spurbottomID, cElevTurbulence);
	rmSetAreaBaseHeight(spurbottomID, 4.0);
	rmSetAreaElevationVariation(spurbottomID, 3.5);
	rmSetAreaElevationMinFrequency(spurbottomID, 0.045);
	rmSetAreaElevationOctaves(spurbottomID, 2);
	rmSetAreaElevationPersistence(spurbottomID, 0.44);     
    rmSetAreaCoherence(spurbottomID, 0.70);
	rmSetAreaSmoothDistance(spurbottomID, 6+2*cNumberNonGaiaPlayers);
	rmAddAreaConstraint(spurbottomID, avoidbay);
    rmBuildArea(spurbottomID); 
	
	int stayInSpurbottom = rmCreateAreaMaxDistanceConstraint("stay in spur bottom", spurbottomID, 0.0);

	//Cliff1
	int stayInCliff = -1;
	int stayNearCliff = -1;
	
	for (i=0; < 2)
	{
		int cliffID = rmCreateArea("cliff "+i);
		if (i == 0)
		{
			rmSetAreaSize(cliffID, 0.052, 0.052);
			rmAddAreaInfluenceSegment(cliffID, 0.38, 0.00, 0.26, 0.16);
			rmAddAreaInfluenceSegment(cliffID, 0.18, 0.00, 0.26, 0.16);
			rmSetAreaTerrainType(cliffID, "rockies\groundsnow2_roc");
			rmAddAreaTerrainLayer(cliffID, "carolinas\ground_grass4_car", 0, 3+0.34*cNumberNonGaiaPlayers);
			rmAddAreaTerrainLayer(cliffID, "araucania\ground_snow1_ara", 3+0.34*cNumberNonGaiaPlayers, 5+0.34*cNumberNonGaiaPlayers);
			rmAddAreaTerrainLayer(cliffID, "araucania\ground_snow2_ara", 5+0.34*cNumberNonGaiaPlayers, 6+0.34*cNumberNonGaiaPlayers);
			rmAddAreaTerrainLayer(cliffID, "araucania\ground_snow3_ara", 6+0.34*cNumberNonGaiaPlayers, 8+0.34*cNumberNonGaiaPlayers);
			rmSetAreaBaseHeight(cliffID, 5.5);
			rmSetAreaHeightBlend(cliffID, 1.6);
		}	
		else
		{
			rmSetAreaSize(cliffID, 0.016, 0.016);
			rmAddAreaInfluenceSegment(cliffID, 0.36, 0.00, 0.26, 0.15);
			rmAddAreaInfluenceSegment(cliffID, 0.24, 0.00, 0.26, 0.15);
			rmAddAreaInfluenceSegment(cliffID, 0.30, 0.00, 0.26, 0.15);
			rmAddAreaInfluenceSegment(cliffID, 0.19, 0.00, 0.26, 0.15);
			rmSetAreaCliffHeight(cliffID, 6, 0.0, 0.8); 
			rmSetAreaCliffEdge(cliffID, 1, 1.0, 0.0, 0.0, 1); 
			rmSetAreaCliffType(cliffID, "Araucania South"); 
			rmSetAreaTerrainType(cliffID, "araucania\ground_snow4_ara");
			rmAddAreaToClass(cliffID, rmClassID("Cliffs"));
	//		rmSetAreaCliffPainting(cliffID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
			
			stayNearCliff = rmCreateAreaMaxDistanceConstraint("stay near cliff", cliffID, 12.0);
			stayInCliff = rmCreateAreaMaxDistanceConstraint("stay in cliff", cliffID, 8.0);
		}
		rmSetAreaWarnFailure(cliffID, false);
		rmSetAreaObeyWorldCircleConstraint(cliffID, false);
		rmSetAreaCoherence(cliffID, 0.75);
		rmSetAreaSmoothDistance(cliffID, 3);
		rmSetAreaLocation(cliffID, 0.26, 0.00);
	//	rmAddAreaConstraint(cliffID, avoidImpassableLandMin);
		if (cNumberTeams <= 2)
		rmBuildArea(cliffID);
	}
	
	//Cliff2
	int stayInCliff2 = -1;
	int stayNearCliff2 = -1;
	
	for (i=0; < 2)
	{
		int cliff2ID = rmCreateArea("cliff 2 "+i);
		if (i == 0)
		{
			rmSetAreaSize(cliff2ID, 0.052, 0.052);
			rmAddAreaInfluenceSegment(cliff2ID, 0.62, 0.00, 0.74, 0.16);
			rmAddAreaInfluenceSegment(cliff2ID, 0.82, 0.00, 0.74, 0.16);
			rmSetAreaTerrainType(cliff2ID, "araucania\ground_snow4_ara");
			rmAddAreaTerrainLayer(cliff2ID, "carolinas\ground_grass4_car", 0, 3+0.34*cNumberNonGaiaPlayers);
			rmAddAreaTerrainLayer(cliff2ID, "araucania\ground_snow1_ara", 3+0.34*cNumberNonGaiaPlayers, 5+0.34*cNumberNonGaiaPlayers);
			rmAddAreaTerrainLayer(cliff2ID, "araucania\ground_snow2_ara", 5+0.34*cNumberNonGaiaPlayers, 6+0.34*cNumberNonGaiaPlayers);
			rmAddAreaTerrainLayer(cliff2ID, "araucania\ground_snow3_ara", 6+0.34*cNumberNonGaiaPlayers, 8+0.34*cNumberNonGaiaPlayers);
			rmSetAreaBaseHeight(cliff2ID, 5.5);
			rmSetAreaHeightBlend(cliff2ID, 1.6);	
		}	
		else
		{
			rmSetAreaSize(cliff2ID, 0.016, 0.016);
			rmAddAreaInfluenceSegment(cliff2ID, 0.64, 0.00, 0.74, 0.15);
			rmAddAreaInfluenceSegment(cliff2ID, 0.70, 0.00, 0.74, 0.15);
			rmAddAreaInfluenceSegment(cliff2ID, 0.76, 0.00, 0.74, 0.15);
			rmAddAreaInfluenceSegment(cliff2ID, 0.81, 0.00, 0.74, 0.15);
			rmSetAreaCliffHeight(cliff2ID, 6, 0.0, 0.8); 
			rmSetAreaCliffEdge(cliff2ID, 1, 1.0, 0.0, 0.0, 1); 
			rmSetAreaCliffType(cliff2ID, "Araucania South"); 
			rmSetAreaTerrainType(cliff2ID, "araucania\ground_snow4_ara");
			rmAddAreaToClass(cliff2ID, rmClassID("Cliffs"));
	//		rmSetAreaCliff2Painting(cliff2ID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
			
			stayNearCliff2 = rmCreateAreaMaxDistanceConstraint("stay near cliff2", cliff2ID, 12.0);
			stayInCliff2 = rmCreateAreaMaxDistanceConstraint("stay in cliff2", cliff2ID, 8.0);
		}
		rmSetAreaWarnFailure(cliff2ID, false);
		rmSetAreaObeyWorldCircleConstraint(cliff2ID, false);
		rmSetAreaCoherence(cliff2ID, 0.75);
		rmSetAreaSmoothDistance(cliff2ID, 3);
		rmSetAreaLocation(cliff2ID, 0.74, 0.00);
	//	rmAddAreaConstraint(cliff2ID, avoidImpassableLandMin);
		if (cNumberTeams <= 2)
		rmBuildArea(cliff2ID);
	}
	
	//cliff3
	int stayInCliff3 = -1;
	int stayNearCliff3 = -1;
	
	for (i=0; < 2)
	{
		int cliff3ID = rmCreateArea("cliff 3 "+i);
		if (i == 0)
		{
			rmSetAreaSize(cliff3ID, 0.052, 0.052);
			rmAddAreaInfluenceSegment(cliff3ID, 0.58, 0.00, 0.50, 0.18);
			rmAddAreaInfluenceSegment(cliff3ID, 0.42, 0.00, 0.50, 0.18);
			rmSetAreaTerrainType(cliff3ID, "araucania\ground_snow4_ara");
			rmAddAreaTerrainLayer(cliff3ID, "carolinas\ground_grass4_car", 0, 3+0.34*cNumberNonGaiaPlayers);
			rmAddAreaTerrainLayer(cliff3ID, "araucania\ground_snow1_ara", 3+0.34*cNumberNonGaiaPlayers, 5+0.34*cNumberNonGaiaPlayers);
			rmAddAreaTerrainLayer(cliff3ID, "araucania\ground_snow2_ara", 5+0.34*cNumberNonGaiaPlayers, 6+0.34*cNumberNonGaiaPlayers);
			rmAddAreaTerrainLayer(cliff3ID, "araucania\ground_snow3_ara", 6+0.34*cNumberNonGaiaPlayers, 8+0.34*cNumberNonGaiaPlayers);
			rmSetAreaBaseHeight(cliff3ID, 5.5);
			rmSetAreaHeightBlend(cliff3ID, 1.6);	
		}	
		else
		{
			rmSetAreaSize(cliff3ID, 0.016, 0.016);
			rmAddAreaInfluenceSegment(cliff3ID, 0.56, 0.00, 0.50, 0.17);
			rmAddAreaInfluenceSegment(cliff3ID, 0.44, 0.00, 0.50, 0.17);
			rmAddAreaInfluenceSegment(cliff3ID, 0.50, 0.00, 0.50, 0.17);
			rmSetAreaCliffHeight(cliff3ID, 6, 0.0, 0.8); 
			rmSetAreaCliffEdge(cliff3ID, 1, 1.0, 0.0, 0.0, 1); 
			rmSetAreaCliffType(cliff3ID, "Araucania South"); 
			rmSetAreaTerrainType(cliff3ID, "araucania\ground_snow4_ara");
			rmAddAreaToClass(cliff3ID, rmClassID("Cliffs"));
	//		rmSetAreacliff3Painting(cliff3ID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
			
			stayNearCliff3 = rmCreateAreaMaxDistanceConstraint("stay near cliff3", cliff3ID, 12.0);
			stayInCliff3 = rmCreateAreaMaxDistanceConstraint("stay in cliff3", cliff3ID, 8.0);
		}
		rmSetAreaWarnFailure(cliff3ID, false);
		rmSetAreaObeyWorldCircleConstraint(cliff3ID, false);
		rmSetAreaCoherence(cliff3ID, 0.75);
		rmSetAreaSmoothDistance(cliff3ID, 3);
		rmSetAreaLocation(cliff3ID, 0.50, 0.00);
	//	rmAddAreaConstraint(cliff3ID, avoidImpassableLandMin);
		if (cNumberTeams > 2)
		rmBuildArea(cliff3ID);
	}
	
	
	// Dark grass patches
	for (i=0; < 10+10*cNumberNonGaiaPlayers)
	{
		int patchID = rmCreateArea("patch coastal"+i);
		rmSetAreaWarnFailure(patchID, false);
		rmSetAreaObeyWorldCircleConstraint(patchID, false);
		rmSetAreaSize(patchID, rmAreaTilesToFraction(60), rmAreaTilesToFraction(80));
		rmSetAreaTerrainType(patchID, "carolinas\ground_grass1_car");
		rmAddAreaToClass(patchID, rmClassID("patch"));
		rmSetAreaMinBlobs(patchID, 1);
		rmSetAreaMaxBlobs(patchID, 4);
		rmSetAreaMinBlobDistance(patchID, 12.0);
		rmSetAreaMaxBlobDistance(patchID, 30.0);
		rmSetAreaCoherence(patchID, 0.0);
		rmAddAreaConstraint(patchID, avoidCliffFar);
		rmAddAreaConstraint(patchID, avoidPatch);
		rmAddAreaConstraint(patchID, avoidImpassableLandShort);
		rmBuildArea(patchID); 
	}
		
	// Players area
	for (i=1; < cNumberPlayers)
	{
	int playerareaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerareaID);
	rmSetAreaSize(playerareaID, 0.03, 0.03);
	rmSetAreaCoherence(playerareaID, 1.0);
	rmSetAreaWarnFailure(playerareaID, false);
//	rmSetAreaTerrainType(playerareaID, "new_england\ground2_cliff_ne"); // for testing
	rmSetAreaLocPlayer(playerareaID, i);
	rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
	rmBuildArea(playerareaID);
	rmCreateAreaDistanceConstraint("avoid player area "+i, playerareaID, 3.0);
	rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerareaID, 0.0);
	}
	
	int avoidPlayerArea1 = rmConstraintID("avoid player area 1");
	int avoidPlayerArea2 = rmConstraintID("avoid player area 2");
	int stayInPlayerArea1 = rmConstraintID("stay in player area 1");
	int stayInPlayerArea2 = rmConstraintID("stay in player area 2");

	// *********************************************************************************************************
	
	// Text
	rmSetStatusText("",0.40);



//===========trade route=================

        int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 10.0);   
	rmAddObjectDefConstraint(socketID, avoidWaterShort);	
   
       
        int tradeRouteID = rmCreateTradeRoute();


        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

	rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 0.75);
 	rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 0.87); 
 	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.85);
 	rmAddTradeRouteWaypoint(tradeRouteID, 0.7, 0.87); 
	rmAddTradeRouteWaypoint(tradeRouteID, 1.0, 0.75);

        rmBuildTradeRoute(tradeRouteID, "naval");

	rmPlaceObjectDefAtLoc(socketID, 0, 0.3, 0.8);
	rmPlaceObjectDefAtLoc(socketID, 0, 0.7, 0.8);


//====================================================


	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.5;
		float yLoc = 0.215;
		float walk = 0.03;

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}
	
	// ******************************************** NATIVES *************************************************
	
	float Natsplacement = -1;
	Natsplacement = rmRandFloat(0.1,1.0); // > 0.3 horizontal, < 0.3 vertical
//	Natsplacement = 0.2; // <--- TEST
	
	float Natsvariation = -1;
	Natsvariation = rmRandFloat(0.1,1.0); // > 0.5 near cliffs, < 0.5 near coast
//	Natsvariation = 0.6; // <--- TEST
	
    int nativeID1 = -1;
	int nativeID2 = -1;
	int nativeID3 = -1;
  
	
	if (Natsplacement > 0.5)
	{
		if (Natsvariation > 0.5)
		{
			nativeID1 = rmCreateGrouping("Nootka village A", "native nootka village "+2);
			rmSetGroupingMinDistance(nativeID1, 0.00);
			rmSetGroupingMaxDistance(nativeID1, 0.00);
		//	rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
			rmAddGroupingToClass(nativeID1, rmClassID("natives"));
			if (cNumberTeams <= 2)
				rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.12);
			else 
				rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.12);
			
			nativeID2 = rmCreateGrouping("Nootka village B", "native nootka village "+3);
			rmSetGroupingMinDistance(nativeID2, 0.00);
			rmSetGroupingMaxDistance(nativeID2, 0.00);
		//	rmAddGroupingConstraint(nativeID2, avoidImpassableLand);
			rmAddGroupingToClass(nativeID2, rmClassID("natives"));
			if (cNumberTeams <= 2)
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.50, 0.38);
			else 
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.50, 0.38);
				
			nativeID3 = rmCreateGrouping("Nootka village C", "native nootka village "+3);
			rmSetGroupingMinDistance(nativeID3, 0.00);
			rmSetGroupingMaxDistance(nativeID3, 0.00);
		//	rmAddGroupingConstraint(nativeID3, avoidImpassableLand);
			rmAddGroupingToClass(nativeID2, rmClassID("natives"));
			if (cNumberNonGaiaPlayers >= 4)
			{
				if (cNumberTeams <= 2)
					rmPlaceGroupingAtLoc(nativeID3, 0, 0.50, 0.54);
				else 
					rmPlaceGroupingAtLoc(nativeID3, 0, 0.50, 0.54);	
			}	
		}
		else
		{
			nativeID1 = rmCreateGrouping("Nootka village A", "native nootka village "+2);
			rmSetGroupingMinDistance(nativeID1, 0.00);
			rmSetGroupingMaxDistance(nativeID1, 0.00);
		//	rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
			rmAddGroupingToClass(nativeID1, rmClassID("natives"));
			if (cNumberTeams <= 2)
				rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.28);
			else 
				rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.28);
			
			nativeID2 = rmCreateGrouping("Nootka village B", "native nootka village "+3);
			rmSetGroupingMinDistance(nativeID2, 0.00);
			rmSetGroupingMaxDistance(nativeID2, 0.00);
		//	rmAddGroupingConstraint(nativeID2, avoidImpassableLand);
			rmAddGroupingToClass(nativeID2, rmClassID("natives"));
			if (cNumberTeams <= 2)
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.50, 0.52);
			else 
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.50, 0.52);	
				
			nativeID3 = rmCreateGrouping("Nootka village C", "native nootka village "+3);
			rmSetGroupingMinDistance(nativeID3, 0.00);
			rmSetGroupingMaxDistance(nativeID3, 0.00);
		//	rmAddGroupingConstraint(nativeID3, avoidImpassableLand);
			rmAddGroupingToClass(nativeID2, rmClassID("natives"));
			if (cNumberNonGaiaPlayers >= 4)
			{
				if (cNumberTeams <= 2)
					rmPlaceGroupingAtLoc(nativeID3, 0, 0.50, 0.14);
				else 
					rmPlaceGroupingAtLoc(nativeID3, 0, 0.50, 0.14);	
			}						
		}
	}
	else
	{
		nativeID1 = rmCreateGrouping("Nootka village A", "native nootka village "+5);
		rmSetGroupingMinDistance(nativeID1, 0.00);
		rmSetGroupingMaxDistance(nativeID1, 0.00);
	//	rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
		rmAddGroupingToClass(nativeID1, rmClassID("natives"));
		if (cNumberTeams <= 2)
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.38, 0.26);
		else 
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.38, 0.26);
			
		nativeID2 = rmCreateGrouping("Nootka village B", "native nootka village "+5);
		rmSetGroupingMinDistance(nativeID2, 0.00);
		rmSetGroupingMaxDistance(nativeID2, 0.00);
	//	rmAddGroupingConstraint(nativeID2, avoidImpassableLand);
		rmAddGroupingToClass(nativeID2, rmClassID("natives"));
		if (cNumberTeams <= 2)
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.62, 0.26);
		else 
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.62, 0.26);	
			
		nativeID3 = rmCreateGrouping("Nootka village C", "native nootka village "+3);
		rmSetGroupingMinDistance(nativeID3, 0.00);
		rmSetGroupingMaxDistance(nativeID3, 0.00);
	//	rmAddGroupingConstraint(nativeID3, avoidImpassableLand);
		rmAddGroupingToClass(nativeID3, rmClassID("natives"));
		if (cNumberNonGaiaPlayers >= 4)
		{
			if (cNumberTeams <= 2)
				rmPlaceGroupingAtLoc(nativeID3, 0, 0.50, 0.50);
			else 
				rmPlaceGroupingAtLoc(nativeID3, 0, 0.50, 0.40);	
		}	
	}
	
	
	// ******************************************************************************************************
	
	// Text
	rmSetStatusText("",0.50);
	
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
	rmSetObjectDefMinDistance(playergoldID, 15.0);
	rmSetObjectDefMaxDistance(playergoldID, 16.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLandMed);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResourcesShort);
//	rmAddObjectDefConstraint(playergoldID, avoidEdge);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 18.0); //58
	rmSetObjectDefMaxDistance(playergold2ID, 20.0); //62
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playergold2ID, avoidImpassableLandFar);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldType);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
//	rmAddObjectDefConstraint(playergold2ID, avoidCenter);
	rmAddObjectDefConstraint(playergold2ID, avoidEdge);
	
/*	// 3nd mine
	int playergold3ID = rmCreateObjectDef("player third mine");
	rmAddObjectDefItem(playergold3ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold3ID, 66.0); //58
	rmSetObjectDefMaxDistance(playergold3ID, 70.0); //62
//	rmAddObjectDefToClass(playergold3ID, classStartingResource);
	rmAddObjectDefToClass(playergold3ID, classGold);
	rmAddObjectDefConstraint(playergold3ID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergold3ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergold3ID, avoidNatives);
	rmAddObjectDefConstraint(playergold3ID, avoidGoldTypeFar);
	rmAddObjectDefConstraint(playergold3ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold3ID, avoidCenter);
	rmAddObjectDefConstraint(playergold3ID, avoidIceArea);
	rmAddObjectDefConstraint(playergold3ID, avoidEdge);
*/
	
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "ypTreeMongolianFir", rmRandInt(6,7), 7.0);
	rmAddObjectDefItem(playerTreeID, "TreeRockies", rmRandInt(5,6), 8.0);
    rmSetObjectDefMinDistance(playerTreeID, 15);
    rmSetObjectDefMaxDistance(playerTreeID, 15);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResourcesFar);
	
	// Starting herd
	int playeherdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playeherdID, "Moose", rmRandInt(4,4), 2.0);
	rmSetObjectDefMinDistance(playeherdID, 14);
	rmSetObjectDefMaxDistance(playeherdID, 16);
	rmSetObjectDefCreateHerd(playeherdID, false);
	rmAddObjectDefToClass(playeherdID, classStartingResource);
	rmAddObjectDefConstraint(playeherdID, avoidTradeRoute);
	rmAddObjectDefConstraint(playeherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(playeherdID, avoidNatives);
	rmAddObjectDefConstraint(playeherdID, avoidStartingResources);
	
	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 4, 4.0);
	rmSetObjectDefMinDistance(playerberriesID, 14.0);
	rmSetObjectDefMaxDistance(playerberriesID, 14.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerberriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerberriesID, avoidNatives);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResources);
	
	// 2nd herd
	int player2ndherdID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(player2ndherdID, "Seal", rmRandInt(7,8), 6.0);
    rmSetObjectDefMinDistance(player2ndherdID, 29);
    rmSetObjectDefMaxDistance(player2ndherdID, 30);
	rmAddObjectDefToClass(player2ndherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player2ndherdID, true);
	rmAddObjectDefConstraint(player2ndherdID, avoidStartingResources);
	rmAddObjectDefConstraint(player2ndherdID, avoidMooseShort); 
//	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(player2ndherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(player2ndherdID, avoidEdge);
	rmAddObjectDefConstraint(player2ndherdID, avoidNatives);
		
	// 3rd herd
	int player3rdherdID = rmCreateObjectDef("player 3rd herd");
	rmAddObjectDefItem(player3rdherdID, "Moose", rmRandInt(5,6), 4.0);
    rmSetObjectDefMinDistance(player3rdherdID, 46);
    rmSetObjectDefMaxDistance(player3rdherdID, 48);
	rmAddObjectDefToClass(player3rdherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player3rdherdID, true);
	rmAddObjectDefConstraint(player3rdherdID, avoidStartingResources);
	rmAddObjectDefConstraint(player3rdherdID, avoidGoldType);
	rmAddObjectDefConstraint(player3rdherdID, avoidMooseShort);
	rmAddObjectDefConstraint(player3rdherdID, avoidElkShort);
//	rmAddObjectDefConstraint(player3rdherdID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(player3rdherdID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(player3rdherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(player3rdherdID, avoidNatives);
	rmAddObjectDefConstraint(player3rdherdID, avoidEdge);
	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 21.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 24.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLandMed);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget); //Short
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	int nugget0count = rmRandInt (1,2); // 1,2
	
	int colonyShipID=rmCreateObjectDef("colony ship");
 	rmAddObjectDefItem(colonyShipID, "HomeCityWaterSpawnFlag", 1, 1.0);
	rmSetObjectDefMinDistance(colonyShipID, 0.0);
	rmSetObjectDefMaxDistance(colonyShipID, rmXFractionToMeters(0.20));
	rmAddObjectDefConstraint(colonyShipID, avoidColonyShip);
	rmAddObjectDefConstraint(colonyShipID, avoidLandFar);
	rmAddObjectDefConstraint(colonyShipID, avoidEdgeMore);
      	   
		
	// ******** Place ********
	
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playergold3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playeherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(player2ndherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(player3rdherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		if (nugget0count == 2)
//			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
				
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
		rmPlaceObjectDefAtLoc(colonyShipID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}


	// ************************************************************************************************
	
	// Text
	rmSetStatusText("",0.60);
	
	// ************************************** COMMON RESOURCES ****************************************
  
   
	// ************* Mines **************
		
	int goldcount = 1*cNumberNonGaiaPlayers;  
	if (cNumberNonGaiaPlayers >= 4)
		goldcount = cNumberNonGaiaPlayers-2-cNumberNonGaiaPlayers%2;
	int silvercount = 1+3*cNumberNonGaiaPlayers;
	
	// Gold mines
	for (i=1; < goldcount+1)
	{
		int goldID = rmCreateObjectDef("gold mine"+i);
		rmAddObjectDefItem(goldID, "Minegold", 1, 0.0);
		rmSetObjectDefMinDistance(goldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(goldID, classGold);
		rmAddObjectDefConstraint(goldID, avoidTradeRoute);
		rmAddObjectDefConstraint(goldID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(goldID, avoidNatives);
		rmAddObjectDefConstraint(goldID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(goldID, avoidGold);
//		rmAddObjectDefConstraint(goldID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(goldID, avoidEdge);
		rmAddObjectDefConstraint(goldID, avoidCliff);	
		rmAddObjectDefConstraint(goldID, stayMiddle);
		if (cNumberTeams <= 2)
		{
			if (i % 2 == 1)
				rmAddObjectDefConstraint(goldID, stayInCliff);
			else
				rmAddObjectDefConstraint(goldID, stayInCliff2);
		}
		else
		{
			rmAddObjectDefConstraint(goldID, stayInCliff3);
			if (i % 2 == 1)
				rmAddObjectDefConstraint(goldID, staySouthHalf);
			else
				rmAddObjectDefConstraint(goldID, stayNorthHalf);
		}		
		rmPlaceObjectDefAtLoc(goldID, 0, 0.50, 0.50);
	}
	
	// Silver mines
	for(i=0; < silvercount)
	{
		int silvermineID = rmCreateObjectDef("silver mine"+i);
		rmAddObjectDefItem(silvermineID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(silvermineID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(silvermineID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(silvermineID, classGold);
		rmAddObjectDefConstraint(silvermineID, avoidTradeRoute);
		rmAddObjectDefConstraint(silvermineID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(silvermineID, avoidNatives);
		rmAddObjectDefConstraint(silvermineID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(silvermineID, avoidGoldFar);
		rmAddObjectDefConstraint(silvermineID, avoidTownCenterFar);
		rmAddObjectDefConstraint(silvermineID, avoidEdge);
		rmAddObjectDefConstraint(silvermineID, avoidCliffFar);	
		if (i == 0)
			rmAddObjectDefConstraint(silvermineID, stayInSpurtop);
		else if (i == 1)
			rmAddObjectDefConstraint(silvermineID, stayInSpurbottom);
		else if (i == 2)
			rmAddObjectDefConstraint(silvermineID, stayInCornertop);	
		else if (i == 3)
			rmAddObjectDefConstraint(silvermineID, stayInCornerbottom);	
		rmPlaceObjectDefAtLoc(silvermineID, 0, 0.50, 0.50);
	}
		
	// *********************************
	
	// Text
	rmSetStatusText("",0.70);
	
	// ************ Forest *************
	
	// Mountain forest
	int mountainforestcount = 2*cNumberNonGaiaPlayers;
		
	int stayInMountainforestPatch = -1;
	
	for (i=0; < mountainforestcount)
	{
		int mforestID = rmCreateArea("mountain forest "+i);
		rmSetAreaWarnFailure(mforestID, false);
		rmSetAreaSize(mforestID, rmAreaTilesToFraction(90), rmAreaTilesToFraction(120));
//		rmSetAreaTerrainType(mforestID, "mongolia\ground_grass3_mongol");
		rmSetAreaObeyWorldCircleConstraint(mforestID, true);
		rmSetAreaMinBlobs(mforestID, 2);
		rmSetAreaMaxBlobs(mforestID, 5);
		rmSetAreaMinBlobDistance(mforestID, 14.0);
		rmSetAreaMaxBlobDistance(mforestID, 30.0);
		rmSetAreaCoherence(mforestID, 0.1);
		rmSetAreaSmoothDistance(mforestID, 5);
		rmAddAreaToClass(mforestID, classForest);
		rmAddAreaConstraint(mforestID, avoidForest);
		rmAddAreaConstraint(mforestID, avoidGoldMin);
		rmAddAreaConstraint(mforestID, avoidElkMin); 
		rmAddAreaConstraint(mforestID, avoidMooseMin); 
		rmAddAreaConstraint(mforestID, avoidTownCenterShort); 
		rmAddAreaConstraint(mforestID, avoidNatives);
		rmAddAreaConstraint(mforestID, avoidTradeRouteShort);
		rmAddAreaConstraint(mforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(mforestID, avoidImpassableLandMin);
		rmAddAreaConstraint(mforestID, avoidCliff);
		if (cNumberTeams <= 2)
		{
			if (i < mountainforestcount/2)
				rmAddAreaConstraint(mforestID, stayNearCliff);
			else
				rmAddAreaConstraint(mforestID, stayNearCliff2);
		}
		else
		{
			rmAddAreaConstraint(mforestID, stayNearCliff3);
		}
//		rmAddAreaConstraint(mforestID, avoidEdge);
		rmBuildArea(mforestID);
		
		stayInMountainforestPatch = rmCreateAreaMaxDistanceConstraint("stay in mountain forest patch"+i, mforestID, 0.0);
		
		for (j=0; < rmRandInt(13,14))
		{
			int mforesttreeID = rmCreateObjectDef("mountain forest trees"+i+" "+j);
			rmAddObjectDefItem(mforesttreeID, "ypTreeHimalayas", rmRandInt(1,3), 3.0);
			rmSetObjectDefMinDistance(mforesttreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(mforesttreeID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(mforesttreeID, classForest);
		//	rmAddObjectDefConstraint(mforesttreeID, avoidForestShort);
			rmAddObjectDefConstraint(mforesttreeID, avoidImpassableLandMin);
			rmAddObjectDefConstraint(mforesttreeID, stayInMountainforestPatch);	
			rmPlaceObjectDefAtLoc(mforesttreeID, 0, 0.50, 0.50);
		}
	}
	
	// Valley forest
	int valleyforestcount = 4+6*cNumberNonGaiaPlayers;
		
	int stayInValleyforestPatch = -1;
	
	for (i=1; < valleyforestcount+1)
	{
		int vforestID = rmCreateArea("valley forest "+i);
		rmSetAreaWarnFailure(vforestID, false);
		rmSetAreaSize(vforestID, rmAreaTilesToFraction(115), rmAreaTilesToFraction(165));
		rmSetAreaTerrainType(vforestID, "carolinas\groundforest_car");
		rmSetAreaObeyWorldCircleConstraint(vforestID, false);
		rmSetAreaMinBlobs(vforestID, 2);
		rmSetAreaMaxBlobs(vforestID, 5);
		rmSetAreaMinBlobDistance(vforestID, 15.0);
		rmSetAreaMaxBlobDistance(vforestID, 32.0);
		rmSetAreaCoherence(vforestID, 0.1);
		rmSetAreaSmoothDistance(vforestID, 5);
		rmAddAreaToClass(vforestID, classForest);
		rmAddAreaConstraint(vforestID, avoidForest);
		rmAddAreaConstraint(vforestID, avoidGoldMin);
		rmAddAreaConstraint(vforestID, avoidElkMin); 
		rmAddAreaConstraint(vforestID, avoidMooseMin); 
		rmAddAreaConstraint(vforestID, avoidTownCenterShort); 
		rmAddAreaConstraint(vforestID, avoidNatives);
		rmAddAreaConstraint(vforestID, avoidTradeRouteShort);
		rmAddAreaConstraint(vforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(vforestID, avoidImpassableLandShort);
		rmAddAreaConstraint(vforestID, avoidCliffFar);
//		rmAddAreaConstraint(vforestID, avoidEdge);
		rmBuildArea(vforestID);
		
		stayInValleyforestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest valley patch"+i, vforestID, 0.0);
		
		for (j=0; < rmRandInt(8,9))
		{
			int vforesttreeID = rmCreateObjectDef("forest valley trees"+i+" "+j);
			rmAddObjectDefItem(vforesttreeID, "ypTreeMongolianFir", rmRandInt(1,2), 2.0);
			rmAddObjectDefItem(vforesttreeID, "TreeRockies", rmRandInt(1,3), 4.0);
			rmSetObjectDefMinDistance(vforesttreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(vforesttreeID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(vforesttreeID, classForest);
		//	rmAddObjectDefConstraint(vforesttreeID, avoidForestShort);
			rmAddObjectDefConstraint(vforesttreeID, avoidImpassableLandMin);
			rmAddObjectDefConstraint(vforesttreeID, stayInValleyforestPatch);	
			rmPlaceObjectDefAtLoc(vforesttreeID, 0, 0.50, 0.50);
		}
	}

	// Random mountain trees 
	int treeMcount = 2*cNumberNonGaiaPlayers;
	
	for (i=0; < treeMcount)
	{
		int randomMtreeID = rmCreateObjectDef("random mountain tree "+i);
		rmAddObjectDefItem(randomMtreeID, "ypTreeHimalayas", rmRandInt(2,4), 3.0);
		rmSetObjectDefMinDistance(randomMtreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(randomMtreeID,  rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(randomMtreeID, classForest);
		rmAddObjectDefConstraint(randomMtreeID, avoidForestShort);
		rmAddObjectDefConstraint(randomMtreeID, avoidGoldMin);
		rmAddObjectDefConstraint(randomMtreeID, avoidElkMin); 
		rmAddObjectDefConstraint(randomMtreeID, avoidMooseMin); 
		rmAddObjectDefConstraint(randomMtreeID, avoidTownCenter); 
		rmAddObjectDefConstraint(randomMtreeID, avoidNatives);
		rmAddObjectDefConstraint(randomMtreeID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(randomMtreeID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(randomMtreeID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(randomMtreeID, avoidCliff);
		if (cNumberTeams <= 2)
		{
			if (i < treeMcount/2)
				rmAddObjectDefConstraint(randomMtreeID, stayNearCliff);
			else
				rmAddObjectDefConstraint(randomMtreeID, stayNearCliff2);
		}
		else
		{
			rmAddObjectDefConstraint(randomMtreeID, stayNearCliff3);
		}
		rmPlaceObjectDefAtLoc(randomMtreeID, 0, 0.50, 0.50);
	}
	
		// Random valley trees 
	int treeVcount = 2+4*cNumberNonGaiaPlayers;
	
	for (i=0; < treeVcount)
	{
		int randomVtreeID = rmCreateObjectDef("random valley tree "+i);
		rmAddObjectDefItem(randomVtreeID, "ypTreeMongolianFir", rmRandInt(2,3), 4.0);
		rmAddObjectDefItem(randomVtreeID, "TreeRockies", rmRandInt(1,2), 3.0);
		rmSetObjectDefMinDistance(randomVtreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(randomVtreeID,  rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(randomVtreeID, classForest);
		rmAddObjectDefConstraint(randomVtreeID, avoidForestShort);
		rmAddObjectDefConstraint(randomVtreeID, avoidGoldMin);
		rmAddObjectDefConstraint(randomVtreeID, avoidElkMin); 
		rmAddObjectDefConstraint(randomVtreeID, avoidMooseMin); 
		rmAddObjectDefConstraint(randomVtreeID, avoidTownCenter); 
		rmAddObjectDefConstraint(randomVtreeID, avoidNatives);
		rmAddObjectDefConstraint(randomVtreeID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(randomVtreeID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(randomVtreeID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(randomVtreeID, avoidCliffFar);
		rmPlaceObjectDefAtLoc(randomVtreeID, 0, 0.50, 0.50);
	}
	
	// ********************************
	
	// Text
	rmSetStatusText("",0.80);
	
	// *********** Berries ************

	int berriescount = 2+2*cNumberNonGaiaPlayers;
	int stayInBerriesArea = -1;
	
	for (i=0; < berriescount)
	{
		int berriesareaID = rmCreateArea("berries area"+i);
		rmSetAreaWarnFailure(berriesareaID, false);
		rmSetAreaObeyWorldCircleConstraint(berriesareaID, false);
		rmSetAreaSize(berriesareaID, rmAreaTilesToFraction(40), rmAreaTilesToFraction(50));
//		rmSetAreaTerrainType(berriesareaID, "carolinas\groundforest_car");
//		rmAddAreaTerrainLayer(berriesareaID, "yellow_river\grass2_yellow_riv", 0, 1);
//		rmSetAreaMinBlobs(berriesareaID, 2);
//		rmSetAreaMaxBlobs(berriesareaID, 3);
//		rmSetAreaMinBlobDistance(berriesareaID, 14.0);
//		rmSetAreaMaxBlobDistance(berriesareaID, 24.0);
		rmSetAreaCoherence(berriesareaID, 0.90);
//		rmSetAreaSmoothDistance(berriesareaID, 2);
		rmAddAreaConstraint(berriesareaID, avoidForestMin);
		rmAddAreaConstraint(berriesareaID, avoidElkShort);
		rmAddAreaConstraint(berriesareaID, avoidMooseShort);
		rmAddAreaConstraint(berriesareaID, avoidTradeRouteShort);
		rmAddAreaConstraint(berriesareaID, avoidTradeRouteSocket);
		rmAddAreaConstraint(berriesareaID, avoidImpassableLand);
		rmAddAreaConstraint(berriesareaID, avoidNatives);
		rmAddAreaConstraint(berriesareaID, avoidTownCenterMed);
		rmAddAreaConstraint(berriesareaID, avoidGoldTypeShort);
		rmAddAreaConstraint(berriesareaID, avoidEdge);
		rmAddAreaConstraint(berriesareaID, avoidStartingResources);
		rmAddAreaConstraint(berriesareaID, avoidBerriesFar);
		rmAddAreaConstraint(berriesareaID, avoidCliffFar);
		if (i <= berriescount/2)
			rmAddAreaConstraint(berriesareaID, stayNW);
		else
			rmAddAreaConstraint(berriesareaID, stayMiddle);
		rmBuildArea(berriesareaID);
	
		stayInBerriesArea = rmCreateAreaMaxDistanceConstraint("stay in berries area"+i, berriesareaID, 0.0);
	
//		for(i=0; < berriescount)
//		{
			int berriesID = rmCreateObjectDef("berries"+i);
			rmAddObjectDefItem(berriesID, "berrybush", rmRandInt(4,4), 4.0);
			rmSetObjectDefMinDistance(berriesID, rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(berriesID, rmXFractionToMeters(0.5));
			rmAddObjectDefConstraint(berriesID, avoidImpassableLand);
			rmAddObjectDefConstraint(berriesID, avoidNatives);
			rmAddObjectDefConstraint(berriesID, avoidTradeRoute);
			rmAddObjectDefConstraint(berriesID, avoidTradeRouteSocket);
			rmAddObjectDefConstraint(berriesID, avoidGoldTypeShort);
			rmAddObjectDefConstraint(berriesID, avoidForestMin);
//			rmAddObjectDefConstraint(berriesID, avoidTownCenterFar);
			rmAddObjectDefConstraint(berriesID, avoidElkShort);
			rmAddObjectDefConstraint(berriesID, avoidMooseShort);
			rmAddObjectDefConstraint(berriesID, avoidBerriesFar);
			rmAddObjectDefConstraint(berriesID, avoidEdge);
			rmAddObjectDefConstraint(berriesID, stayInBerriesArea);
			rmPlaceObjectDefAtLoc(berriesID, 0, 0.50, 0.50);
//		}
	}
	
	// ************ Herds *************
	
	int elkcount = 1+2*cNumberNonGaiaPlayers;
	int moosecount = 1+2*cNumberNonGaiaPlayers;
	
		
	//Elk herds
	for (i=0; < elkcount)
	{
		int elkherdID = rmCreateObjectDef("elk herd"+i);
		rmAddObjectDefItem(elkherdID, "Seal", rmRandInt(7,8), 6.0);
		rmSetObjectDefMinDistance(elkherdID, 0.0);
		rmSetObjectDefMaxDistance(elkherdID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(elkherdID, true);
		rmAddObjectDefConstraint(elkherdID, avoidForestMin);
		rmAddObjectDefConstraint(elkherdID, avoidGoldShort);
		rmAddObjectDefConstraint(elkherdID, avoidBerriesShort);
		rmAddObjectDefConstraint(elkherdID, avoidElkFar); 
		rmAddObjectDefConstraint(elkherdID, avoidMooseFar); 
		rmAddObjectDefConstraint(elkherdID, avoidTownCenter); 
		rmAddObjectDefConstraint(elkherdID, avoidNatives);
		rmAddObjectDefConstraint(elkherdID, avoidImpassableLand);
		rmAddObjectDefConstraint(elkherdID, avoidCliff);
		rmAddObjectDefConstraint(elkherdID, avoidEdge);
		if (i == 0)
			rmAddObjectDefConstraint(elkherdID, staySW);
		else if (i == 1)
			rmAddObjectDefConstraint(elkherdID, stayNE);
		rmPlaceObjectDefAtLoc(elkherdID, 0, 0.50, 0.50);	
	}
	
	//Moose herds
	for (i=0; < moosecount)
	{
		int mooseherdID = rmCreateObjectDef("moose herd"+i);
		rmAddObjectDefItem(mooseherdID, "moose", rmRandInt(4,5), 4.0);
		rmSetObjectDefMinDistance(mooseherdID, 0.0);
		rmSetObjectDefMaxDistance(mooseherdID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(mooseherdID, true);
		rmAddObjectDefConstraint(mooseherdID, avoidForestMin);
		rmAddObjectDefConstraint(mooseherdID, avoidGoldShort);
		rmAddObjectDefConstraint(mooseherdID, avoidBerriesShort);
		rmAddObjectDefConstraint(mooseherdID, avoidElk); 
		rmAddObjectDefConstraint(mooseherdID, avoidMooseFar); 
		rmAddObjectDefConstraint(mooseherdID, avoidTownCenter); 
		rmAddObjectDefConstraint(mooseherdID, avoidNatives);
		rmAddObjectDefConstraint(mooseherdID, avoidImpassableLand);
		rmAddObjectDefConstraint(mooseherdID, avoidCliff);
		rmAddObjectDefConstraint(mooseherdID, avoidEdge);
//		if (i < 2)
//			rmAddObjectDefConstraint(mooseherdID, staySW);
//		else if (i < 4)
//			rmAddObjectDefConstraint(mooseherdID, stayNE);
		rmPlaceObjectDefAtLoc(mooseherdID, 0, 0.50, 0.50);	
	}
	
	// ************************************
	
	// Text
	rmSetStatusText("",0.90);
		
	// ************** Treasures ***************
	
	int treasure1count = 2+0.5*cNumberNonGaiaPlayers;
	int treasure2count = 5+0.5*cNumberNonGaiaPlayers;
	int treasure3count = 0.5*cNumberNonGaiaPlayers;
	int treasure4count = 0.34*cNumberNonGaiaPlayers;
	
	// Treasures lvl4
	for (i=0; < treasure4count)
	{
		int Nugget4ID = rmCreateObjectDef("nugget lvl4 "+i); 
		rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget4ID, 0);
		rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(4,4);
		rmAddObjectDefConstraint(Nugget4ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLandMed);
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidElkMin); 
		rmAddObjectDefConstraint(Nugget4ID, avoidMooseMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidBerriesMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget4ID, avoidEdge);
		rmAddObjectDefConstraint(Nugget4ID, avoidCliffFar);
		rmAddObjectDefConstraint(Nugget4ID, stayMiddle);
		if (cNumberNonGaiaPlayers >= 4)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.50, 0.50);
	}
	
	// 	Treasures lvl3
	for (i=0; < treasure3count)
	{
		int Nugget3ID = rmCreateObjectDef("nugget lvl3 "+i); 
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, 0);
		rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(3,3);
		rmAddObjectDefConstraint(Nugget3ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLandMed);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidElkMin); 
		rmAddObjectDefConstraint(Nugget3ID, avoidMooseMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidBerriesMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget3ID, avoidEdge);
		rmAddObjectDefConstraint(Nugget3ID, stayMiddle);
		rmAddObjectDefConstraint(Nugget3ID, avoidCliffFar);
//		if (cNumberNonGaiaPlayers >= 4)
		rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50);
	}

	
	// Treasures lvl2	
	for (i=0; < treasure2count)
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
		rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidElkMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidMooseMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidBerriesMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget2ID, avoidCliffFar);
		if (i < 1)
			rmAddObjectDefConstraint(Nugget2ID, staySouthHalf); 
		else if (i < 2)
			rmAddObjectDefConstraint(Nugget2ID, stayNorthHalf); 
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}
	
	// Treasures lvl1
	for (i=0; < treasure1count)
	{
		int Nugget1ID = rmCreateObjectDef("nugget lvl1 "+i); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, 0);
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(1,1);
		rmAddObjectDefConstraint(Nugget1ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget1ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget1ID, avoidElkMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidMooseMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidBerriesMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge);
		rmAddObjectDefConstraint(Nugget1ID, avoidCliffFar);
//		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);
	}
	
	// ****************************************
	
	// Text
	rmSetStatusText("",0.95);
	
	
	// ************ Sea resources *************
	
	int fishcount = 4+3*cNumberNonGaiaPlayers;
	int whalecount = 2+1.5*cNumberNonGaiaPlayers;
	
	//Whales
	for (i=0; < whalecount)
	{
	int whaleID=rmCreateObjectDef("whale"+i);
	rmAddObjectDefItem(whaleID, "HumpbackWhale", 1, 2.0);
	rmSetObjectDefMinDistance(whaleID, 20);
	rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(whaleID, avoidWhale);
	rmAddObjectDefConstraint(whaleID, avoidLandFar);
	rmAddObjectDefConstraint(whaleID, avoidColonyShip);
	rmAddObjectDefConstraint(whaleID, stayMiddleWater);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.50, 0.50);
	}
	
	//Fish
	for (i=0; < fishcount)
	{
		int fishID = rmCreateObjectDef("fish"+i);
		rmAddObjectDefItem(fishID, "FishSalmon", rmRandInt(2,3), 13.0);
		rmSetObjectDefMinDistance(fishID, 0.0);
		rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.50));
		rmAddObjectDefConstraint(fishID, avoidFish);
		rmAddObjectDefConstraint(fishID, avoidLand);
		rmAddObjectDefConstraint(fishID, avoidColonyShip);
		rmAddObjectDefConstraint(fishID, avoidEdge);
//		rmAddObjectDefConstraint(fishID, staySidesWater);
		if (i < fishcount/2)
			rmAddObjectDefConstraint(fishID, staySouthHalf);
		else
			rmAddObjectDefConstraint(fishID, stayNorthHalf);
		rmPlaceObjectDefAtLoc(fishID, 0, 0.50, 0.50);
	}

	// ****************************************
	

  // Water nuggets

  int avoidNuggetLand=rmCreateTerrainDistanceConstraint("nugget avoid land", "land", true, 15.0);
  int avoidNuggetWater=rmCreateTypeDistanceConstraint("nugget vs. nugget water", "AbstractNugget", 80.0);
  
  int nuggetW= rmCreateObjectDef("nugget water"); 
  rmAddObjectDefItem(nuggetW, "ypNuggetBoat", 1, 0.0);
  rmSetNuggetDifficulty(5, 5);
  rmSetObjectDefMinDistance(nuggetW, rmXFractionToMeters(0.0));
  rmSetObjectDefMaxDistance(nuggetW, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nuggetW, avoidNuggetLand);
  rmAddObjectDefConstraint(nuggetW, avoidNuggetWater);
  rmPlaceObjectDefAtLoc(nuggetW, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4);


	// Text
	rmSetStatusText("", 1.00);


} //END