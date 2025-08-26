// ESOC HUDSON BAY (1V1, TEAM, FFA)
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
	int playerTiles=14000; //11000
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=13000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=12000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=11000;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	// Make the corners.
	rmSetWorldCircleConstraint(true);

	// Picks a default water height
	rmSetSeaLevel(2.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	rmSetMapElevationParameters(cElevTurbulence, 0.05, 2, 0.5, 4.0); // type, frequency, octaves, persistence, variation
//	rmSetMapElevationHeightBlend(1);

	//Choose the map variation
	float randomfrozen = -1;
	randomfrozen = rmRandFloat(0.1,1.0); // 0.1-0.5 frozen
//	randomfrozen = 0.2; //<----- TEST

	if (false) {
		randomfrozen = 1;
	} else if (false) {
		randomfrozen = 0.1;
	}

	// Picks default terrain and water
	rmSetSeaType("hudson bay");
	if (randomfrozen >= 0.5)
	{
	rmSetBaseTerrainMix("saguenay tundra"); //
	rmTerrainInitialize("saguenay\ground6_sag", 5.0); //
	rmSetMapType("saguenay");
	rmSetMapType("grass");
	}
	else
	{
	rmSetBaseTerrainMix("yukon snow"); //
	rmTerrainInitialize("yukon\ground1_yuk", 5.0); //
	rmSetMapType("saguenay");
	rmSetMapType("snow");
	}
	rmSetMapType("water");
	rmSetMapType("namerica");
	rmSetMapType("AITransportUseful");
	rmSetMapType("AIFishingUseful");
	if (randomfrozen >= 0.5)
	rmSetLightingSet("carolina");
	else
	rmSetLightingSet("Great Lakes Winter"); // rockies

	// Choose Mercs
	chooseMercs();

	// Text
	rmSetStatusText("",0.10);

	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Cree");
	subCiv1 = rmGetCivID("Huron");
	rmSetSubCiv(0, "Cree");
	rmSetSubCiv(1, "Huron");
//	rmEchoInfo("subCiv0 is Cree "+subCiv0);
//	rmEchoInfo("subCiv1 is Huron "+subCiv1);
//	string nativeName0 = "native Cree village";
//	string nativeName1 = "native Huron village";


	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	rmDefineClass("classHill");
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
	int classIsland = rmDefineClass("Island");

	// ******************************************************************************************

	// Text
	rmSetStatusText("",0.20);

	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other

	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.475), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.38), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.4,0.4,rmXFractionToMeters(0.26), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.46,0.46,rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int staySouth = rmCreatePieConstraint("Stay South",0.30,0.30,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(135),rmDegreesToRadians(315));

	// Resource avoidance
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 28.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 24.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidMooseFar = rmCreateTypeDistanceConstraint("avoid moose far", "moose", 52.0);
	int avoidMoose = rmCreateTypeDistanceConstraint("avoid moose", "moose", 44.0);
	int avoidMooseShort = rmCreateTypeDistanceConstraint("avoid moose short", "moose", 25.0);
	int avoidMooseMin = rmCreateTypeDistanceConstraint("avoid moose min", "moose", 5.0);
	int avoidCaribouFar = rmCreateTypeDistanceConstraint("avoid caribou far", "caribou", 54.0);
	int avoidCaribou = rmCreateTypeDistanceConstraint("avoid  caribou", "caribou", 45.0);
	int avoidCaribouShort = rmCreateTypeDistanceConstraint("avoid  caribou short", "caribou", 30.0);
	int avoidCaribouMin = rmCreateTypeDistanceConstraint("avoid caribou min", "caribou", 5.0);
	int avoidSeal = rmCreateTypeDistanceConstraint("Seal avoids Seal", "Seal", 44.0);
	int avoidSealShort = rmCreateTypeDistanceConstraint("Seal avoids Seal short", "Seal", 28.0);
	int avoidSealMin = rmCreateTypeDistanceConstraint("Seal avoids Seal min", "Seal", 5.0);
	int avoidMuskOxFar = rmCreateTypeDistanceConstraint("avoid muskox far", "muskOx", 56.0);
	int avoidMuskOx = rmCreateTypeDistanceConstraint("avoid muskox ", "muskOx", 45.0);
	int avoidMuskOxMin = rmCreateTypeDistanceConstraint("avoid muskox min ", "muskOx", 5.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 25.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 8.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 12.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 50.0);
	int avoidGoldMin = rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 4.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 30.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 60.0);
//	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very ", rmClassID("Gold"), 74.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 38.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 48.0);
	int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center  Very Far", "townCenter", 74.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 64.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 31.0);
//	int avoidTownCenterMed=rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 40.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 27.0);
	int avoidTownCenterMin=rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 18.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint("resources avoid Town Center", "townCenter", 40.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid natives short", rmClassID("natives"), 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 7.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("avoid natives far", rmClassID("natives"), 12.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("start resources avoid each other", rmClassID("startingResource"), 8.0);
	int avoidWhale=rmCreateTypeDistanceConstraint("avoid whale", "fish", 28.0);
	int avoidFish=rmCreateTypeDistanceConstraint("avoid fish", "fish", 18.0);
	int avoidSheep=rmCreateTypeDistanceConstraint("sheep avoids sheep", "sheep", 61.0);
	int avoidColonyShip = rmCreateTypeDistanceConstraint("avoid colony ship", "HomeCityWaterSpawnFlag", 30.0);
	int avoidColonyShipShort = rmCreateTypeDistanceConstraint("avoid colony ship short", "HomeCityWaterSpawnFlag", 15.0);
	int avoidIsland = rmCreateClassDistanceConstraint ("avoid island", rmClassID("Island"), 40.0);

	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 9.0);
	int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("avoid impassable land far", "Land", false, 20.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 4.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 15.0);
	int stayNearLand = rmCreateTerrainMaxDistanceConstraint("stay near land ", "Land", true, 5.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 8.0);
	int avoidLandFar = rmCreateTerrainDistanceConstraint("avoid land far ", "Land", true, 12.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 10);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 2.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 3.0);
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 22.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 10.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 5.0);
	int avoidPond = rmCreateClassDistanceConstraint("avoid pond", rmClassID("pond"), 40.0);
	int avoidRock = rmCreateClassDistanceConstraint("rock avoids rock", rmClassID("rocks"), 10.0);
	int avoidRockFar = rmCreateClassDistanceConstraint("rock avoids rock far", rmClassID("rocks"), 25.0);
	int avoidGrass = rmCreateClassDistanceConstraint("grass avoid grass", rmClassID("grass"), 15.0);
	int rockVsLand = rmCreateTerrainDistanceConstraint("rock v. land", "land", true, 2.0);
	int rockVsWater=rmCreateTerrainMaxDistanceConstraint("rock v. water", "land", true, 5.0);

	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);

	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 6.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 8.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route socket short", "socketTradeRoute", 3.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 10.0);


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
					rmPlacePlayer(1, 0.23, 0.75);
					rmPlacePlayer(2, 0.75, 0.23);
				}
				else
				{
					rmPlacePlayer(2, 0.23, 0.75);
					rmPlacePlayer(1, 0.75, 0.23);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.350, 0.440); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.810, 0.900); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.350, 0.520); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.39, 0.39, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.730, 0.900); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.39, 0.39, 0);
				}
			}
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.879, 0.881); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmSetPlacementSection(0.350, 0.440); //
						else
							rmSetPlacementSection(0.350, 0.520); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmSetPlacementSection(0.810, 0.900); //
						else
							rmSetPlacementSection(0.730, 0.900); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.369, 0.371); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.350, 0.440); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.730, 0.900); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.350, 0.520); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.810, 0.900); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.350, 0.520); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.730, 0.900); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);
				}
			}
		}
		else // FFA
		{
			rmSetPlacementSection(0.350, 0.900);
			rmSetTeamSpacingModifier(0.25);
			rmPlacePlayersCircular(0.40, 0.40, 0.0);
		}


	// **************************************************************************************************

	// Text
	rmSetStatusText("",0.30);

	// ******************************************** MAP LAYOUT **************************************************

	//Bay
	if (randomfrozen >= 0.5)
	{
		int HudsonBayWaterID = rmCreateArea("Hudson Bay Water");
		rmSetAreaSize(HudsonBayWaterID, 0.21, 0.21);
		rmSetAreaLocation(HudsonBayWaterID, 0.9, 0.9);
		rmAddAreaInfluenceSegment(HudsonBayWaterID, 0.68, 1.0, 0.61, 0.71); // 0.62, 0.62
		rmAddAreaInfluenceSegment(HudsonBayWaterID, 1.0, 0.68, 0.71, 0.61);
		rmAddAreaInfluenceSegment(HudsonBayWaterID, 1.0, 1.0, 0.64, 0.64);
		rmSetAreaWaterType(HudsonBayWaterID, "Hudson Bay"); //yukon river
	//  rmSetAreaBaseHeight(HudsonBayWaterID, 3.0);
		rmSetAreaMinBlobs(HudsonBayWaterID, 8);
		rmSetAreaMaxBlobs(HudsonBayWaterID, 10);
		rmSetAreaMinBlobDistance(HudsonBayWaterID, 10);
		rmSetAreaMaxBlobDistance(HudsonBayWaterID, 20);
		rmSetAreaSmoothDistance(HudsonBayWaterID, 24);
		rmSetAreaCoherence(HudsonBayWaterID, 0.55);
		rmSetAreaHeightBlend(HudsonBayWaterID, 1.8);
		rmSetAreaObeyWorldCircleConstraint(HudsonBayWaterID, false);
		rmBuildArea(HudsonBayWaterID);

		int stayInBayWater = rmCreateAreaMaxDistanceConstraint("stay in bay water", HudsonBayWaterID, 0);
		int stayNearBayWater = rmCreateAreaMaxDistanceConstraint("stay near bay water", HudsonBayWaterID, 6);
		int stayCloseToBayWater = rmCreateAreaMaxDistanceConstraint("stay close to bay water", HudsonBayWaterID, 28);
		int avoidBayWater = rmCreateAreaDistanceConstraint("avoid bay water", HudsonBayWaterID, 2.01);
		int avoidBayWaterFar = rmCreateAreaDistanceConstraint("avoid bay water far", HudsonBayWaterID, 32);
	}
	else
	{
		int HudsonBayWaterIceID = rmCreateArea("Hudson Bay Water Ice");
		rmSetAreaSize(HudsonBayWaterIceID, 0.16, 0.16);
		rmSetAreaLocation(HudsonBayWaterIceID, 0.9, 0.9);
		rmAddAreaInfluenceSegment(HudsonBayWaterIceID, 0.70, 1.0, 0.62, 0.72); // 0.62, 0.62
		rmAddAreaInfluenceSegment(HudsonBayWaterIceID, 1.0, 0.70, 0.72, 0.62);
		rmAddAreaInfluenceSegment(HudsonBayWaterIceID, 1.0, 1.0, 0.67, 0.67);
		rmSetAreaWaterType(HudsonBayWaterIceID, "great lakes ice"); //yukon river
	//  rmSetAreaBaseHeight(HudsonBayWaterIceID, 3.0);
		rmSetAreaMinBlobs(HudsonBayWaterIceID, 8);
		rmSetAreaMaxBlobs(HudsonBayWaterIceID, 10);
		rmSetAreaMinBlobDistance(HudsonBayWaterIceID, 10);
		rmSetAreaMaxBlobDistance(HudsonBayWaterIceID, 20);
		rmSetAreaSmoothDistance(HudsonBayWaterIceID, 26);
		rmSetAreaCoherence(HudsonBayWaterIceID, 0.50);
		rmSetAreaHeightBlend(HudsonBayWaterIceID, 1.8);
		rmSetAreaObeyWorldCircleConstraint(HudsonBayWaterIceID, false);
		rmBuildArea(HudsonBayWaterIceID);

		int stayNearBayWaterIce = rmCreateAreaMaxDistanceConstraint("stay near bay water ice", HudsonBayWaterIceID, 20);
		int avoidBayWaterIce = rmCreateAreaDistanceConstraint("avoid bay water ice", HudsonBayWaterIceID, 2.01);
		int avoidBayWaterIceFar = rmCreateAreaDistanceConstraint("avoid bay water ice far", HudsonBayWaterIceID, 32);

	}

	// Coast
	if (randomfrozen >= 0.5)
	{
		int CoastareaID = rmCreateArea("Coast area");
		rmSetAreaSize(CoastareaID, 0.15, 0.15);
//		rmSetAreaTerrainType(CoastareaID, "new_england\ground2_cliff_ne");
		rmSetAreaCoherence(CoastareaID, 1.0);
		rmSetAreaSmoothDistance(CoastareaID, 2);
		rmAddAreaConstraint(CoastareaID, avoidBayWater);
		rmAddAreaConstraint(CoastareaID, stayNearBayWater);
		rmSetAreaObeyWorldCircleConstraint(CoastareaID, false);
		rmSetAreaWarnFailure(CoastareaID, false);
		rmBuildArea(CoastareaID);

		int stayInCoastArea = rmCreateAreaMaxDistanceConstraint("stay in coast area", CoastareaID, 0);
		int avoidCoastArea = rmCreateAreaDistanceConstraint("avoid coast area", CoastareaID, 20);
	}
	else
	{
		int IceareaID = rmCreateArea("ice area");
		rmSetAreaSize(IceareaID, 0.22, 0.22);
		rmSetAreaMix(IceareaID, "great_lakes_ice");
		rmSetAreaBaseHeight(IceareaID, 1.5);
//		rmSetAreaTerrainType(IceareaID, "great_lakes\ground_ice1_gl");
		rmSetAreaCoherence(IceareaID, 0.5);
		rmSetAreaSmoothDistance(IceareaID, 2);
		rmAddAreaConstraint(IceareaID, avoidBayWaterIce);
		rmAddAreaConstraint(IceareaID, stayNearBayWaterIce);
		rmSetAreaObeyWorldCircleConstraint(IceareaID, false);
		rmSetAreaWarnFailure(IceareaID, false);
		rmBuildArea(IceareaID);

		int avoidIceArea = rmCreateAreaDistanceConstraint("avoid ice area", IceareaID, 3.0);
		int avoidIceAreaFar = rmCreateAreaDistanceConstraint("avoid ice area far", IceareaID, 6);
		int avoidIceAreaVeryFar = rmCreateAreaDistanceConstraint("avoid ice area very far", IceareaID, 11);
		int stayNearIceArea = rmCreateAreaMaxDistanceConstraint("stay near ice area", IceareaID, 15);
	}


	// Terrain patches
	if (randomfrozen >= 0.5)
	{
		for (i=0; < 40)
		{
			int patch2ID = rmCreateArea("patch orange grass"+i);
			rmSetAreaWarnFailure(patch2ID, false);
			rmSetAreaSize(patch2ID, rmAreaTilesToFraction(30), rmAreaTilesToFraction(60));
			rmSetAreaTerrainType(patch2ID, "saguenay\ground6_sag");
			rmAddAreaToClass(patch2ID, rmClassID("patch2"));
			rmSetAreaMinBlobs(patch2ID, 1);
			rmSetAreaMaxBlobs(patch2ID, 5);
			rmSetAreaMinBlobDistance(patch2ID, 16.0);
			rmSetAreaMaxBlobDistance(patch2ID, 40.0);
			rmSetAreaCoherence(patch2ID, 0.0);
			rmAddAreaConstraint(patch2ID, avoidImpassableLand);
			rmAddAreaConstraint(patch2ID, avoidPatch2);
			rmBuildArea(patch2ID);
		}
	}
	else
	{
		for (i=0; < 15)
		{
			int patchID = rmCreateArea("patch snowgrass"+i);
			rmSetAreaWarnFailure(patchID, false);
			rmSetAreaSize(patchID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(200));
			rmSetAreaMix(patchID, "yukon grass"); //ground6_yuk
			rmAddAreaToClass(patchID, rmClassID("patch"));
			rmSetAreaMinBlobs(patchID, 1);
			rmSetAreaMaxBlobs(patchID, 5);
			rmSetAreaMinBlobDistance(patchID, 20.0);
			rmSetAreaMaxBlobDistance(patchID, 40.0);
			rmSetAreaCoherence(patchID, 0.0);
			rmSetAreaSmoothDistance(patchID, 1);
			rmAddAreaConstraint(patchID, avoidImpassableLand);
			rmAddAreaConstraint(patchID, avoidIceArea);
			rmAddAreaConstraint(patchID, avoidPatch);
			rmBuildArea(patchID);
		}
	}

	int distanceAvoidIsland = 4;
	if (rmGetIsKOTH()) {
		distanceAvoidIsland = 24;
	}

	//Islands
	if (randomfrozen >= 0.5)
	{
		int IslandgrassID = rmCreateArea("grass island 1");
		rmSetAreaSize(IslandgrassID, rmAreaTilesToFraction(60+20*cNumberNonGaiaPlayers), rmAreaTilesToFraction(160+20*cNumberNonGaiaPlayers));
		rmSetAreaLocation(IslandgrassID, rmRandFloat(0.63,0.67), rmRandFloat(0.77, 0.86));
		rmSetAreaMix(IslandgrassID, "saguenay tundra");
		rmSetAreaBaseHeight(IslandgrassID, 1.5);
//		rmSetAreaElevationType(IslandgrassID, cElevTurbulence);
//		rmSetAreaElevationVariation(IslandgrassID, 0.5);
		rmSetAreaMinBlobs(IslandgrassID, 3);
		rmSetAreaMaxBlobs(IslandgrassID, 5);
		rmSetAreaMinBlobDistance(IslandgrassID, 6);
		rmSetAreaMaxBlobDistance(IslandgrassID, 8);
		rmSetAreaSmoothDistance(IslandgrassID, 4);
		rmSetAreaCoherence(IslandgrassID, 0.40);
		rmAddAreaToClass(IslandgrassID, classIsland);
		rmBuildArea(IslandgrassID);

		int stayInIsland1 = rmCreateAreaMaxDistanceConstraint("stay in island 1", IslandgrassID, 0);
		int stayNearIsland1 = rmCreateAreaMaxDistanceConstraint("stay near island 1", IslandgrassID, 3);
		int avoidIsland1 = rmCreateAreaDistanceConstraint("avoid island 1", IslandgrassID, distanceAvoidIsland);

		int Islandgrass2ID = rmCreateArea("grass island 2");
		rmSetAreaSize(Islandgrass2ID, rmAreaTilesToFraction(60+20*cNumberNonGaiaPlayers), rmAreaTilesToFraction(160+20*cNumberNonGaiaPlayers));
		rmSetAreaLocation(Islandgrass2ID, rmRandFloat(0.77,0.86), rmRandFloat(0.63, 0.67));
		rmSetAreaMix(Islandgrass2ID, "saguenay tundra");
		rmSetAreaBaseHeight(Islandgrass2ID, 1.5);
//		rmSetAreaElevationType(Islandgrass2ID, cElevTurbulence);
//		rmSetAreaElevationVariation(Islandgrass2ID, 0.5);
		rmSetAreaMinBlobs(Islandgrass2ID, 3);
		rmSetAreaMaxBlobs(Islandgrass2ID, 5);
		rmSetAreaMinBlobDistance(Islandgrass2ID, 6);
		rmSetAreaMaxBlobDistance(Islandgrass2ID, 8);
		rmSetAreaSmoothDistance(Islandgrass2ID, 4);
		rmSetAreaCoherence(Islandgrass2ID, 0.40);
		rmAddAreaToClass(Islandgrass2ID, classIsland);
		rmBuildArea(Islandgrass2ID);

		int stayInIsland2 = rmCreateAreaMaxDistanceConstraint("stay in island 2", Islandgrass2ID, 0);
		int stayNearIsland2 = rmCreateAreaMaxDistanceConstraint("stay near island 2", Islandgrass2ID, 3);
		int avoidIsland2 = rmCreateAreaDistanceConstraint("avoid island 2", Islandgrass2ID, distanceAvoidIsland);


		int Islandgrass3ID = rmCreateArea("grass island extra");
		rmSetAreaObeyWorldCircleConstraint(Islandgrass3ID, true);
		rmSetAreaSize(Islandgrass3ID, rmAreaTilesToFraction(60+20*cNumberNonGaiaPlayers), rmAreaTilesToFraction(200+20*cNumberNonGaiaPlayers));
		rmSetAreaMix(Islandgrass3ID, "saguenay tundra");
		rmSetAreaBaseHeight(Islandgrass3ID, 1.5);
	//	rmSetAreaElevationType(Islandgrass3ID, cElevTurbulence);
	//	rmSetAreaElevationVariation(Islandgrass3ID, 0.5);
		rmSetAreaMinBlobs(Islandgrass3ID, 3);
		rmSetAreaMaxBlobs(Islandgrass3ID, 4);
		rmSetAreaMinBlobDistance(Islandgrass3ID, 6);
		rmSetAreaMaxBlobDistance(Islandgrass3ID, 8);
		rmSetAreaSmoothDistance(Islandgrass3ID, 4);
		rmSetAreaCoherence(Islandgrass3ID, 0.40);
		rmAddAreaToClass(Islandgrass3ID, classIsland);
		rmAddAreaConstraint(Islandgrass3ID, stayInBayWater);
		rmAddAreaConstraint(Islandgrass3ID, avoidIsland);
		rmAddAreaConstraint(Islandgrass3ID, avoidCoastArea);
		rmAddAreaConstraint(Islandgrass3ID, avoidEdge);
		if (cNumberNonGaiaPlayers >= 6)
			rmBuildArea(Islandgrass3ID);

		int stayInIsland3 = rmCreateAreaMaxDistanceConstraint("stay in island 3", Islandgrass3ID, 0);
		int stayNearIsland3 = rmCreateAreaMaxDistanceConstraint("stay near island 3", Islandgrass3ID, 3);
		int avoidIsland3 = rmCreateAreaDistanceConstraint("avoid island 3", Islandgrass3ID, distanceAvoidIsland);
	}
	else
	{
	/*
		int IslandSnowID = rmCreateArea("snow island 1");
		rmSetAreaSize(IslandSnowID, rmAreaTilesToFraction(210), rmAreaTilesToFraction(250));
		rmSetAreaLocation(IslandSnowID, rmRandFloat(0.70,0.88), rmRandFloat(0.70, 0.88));
		rmSetAreaBaseHeight(IslandSnowID, 0.0);
		rmSetAreaMix(IslandSnowID, "great_lakes_ice");
//		rmSetAreaTerrainType(IslandSnowID, "great_lakes\ground_snow2_gl");
//		rmSetAreaElevationType(IslandSnowID, cElevTurbulence);
//		rmSetAreaElevationVariation(IslandSnowID, 2.5);
		rmSetAreaMinBlobs(IslandSnowID, 3);
		rmSetAreaMaxBlobs(IslandSnowID, 5);
		rmSetAreaMinBlobDistance(IslandSnowID, 4);
		rmSetAreaMaxBlobDistance(IslandSnowID, 7);
		rmSetAreaSmoothDistance(IslandSnowID, 5);
		rmSetAreaCoherence(IslandSnowID, 0.4);
		rmBuildArea(IslandSnowID);
	*/
	}

	// Players area
	for (i=1; < cNumberPlayers)
	{
	int playerareaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerareaID);
	rmSetAreaSize(playerareaID, 0.1, 0.1);
	rmSetAreaCoherence(playerareaID, 1.0);
	rmSetAreaWarnFailure(playerareaID, false);
//	rmSetAreaTerrainType(playerareaID, "new_england\ground2_cliff_ne"); // for testing
	rmSetAreaLocPlayer(playerareaID, i);
	rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
	rmBuildArea(playerareaID);
	int avoidPlayerArea = rmCreateAreaDistanceConstraint("avoid player area "+i, playerareaID, 3.0);
	int stayPlayerArea = rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerareaID, 0.0);
	}

	int avoidPlayerArea1 = rmConstraintID("avoid player area 1");
	int avoidPlayerArea2 = rmConstraintID("avoid player area 2");
	int stayInPlayerArea1 = rmConstraintID("stay in player area 1");
	int stayInPlayerArea2 = rmConstraintID("stay in player area 2");

	// *********************************************************************************************************

	// Text
	rmSetStatusText("",0.40);

		// ****************************************** TRADE ROUTE **********************************************
	float TPvariation = -1;
	TPvariation = rmRandFloat(0.1,1.0);
//	TPvariation = 0.6; // <--- TEST
	if (cNumberTeams >= 3)
		TPvariation = 2.0;

	if (TPvariation <= 0.5)
	{
		int tradeRoute2ID = rmCreateTradeRoute();
		int socket2ID=rmCreateObjectDef("sockets to dock Trade Posts 2");
		rmAddObjectDefItem(socket2ID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socket2ID, true);
		rmSetObjectDefMinDistance(socket2ID, 0.0);
		rmSetObjectDefMaxDistance(socket2ID, 6.0);

		if (randomfrozen >= 0.5)
		{
			rmSetObjectDefTradeRouteID(socket2ID, tradeRoute2ID);
			rmAddTradeRouteWaypoint(tradeRoute2ID, rmRandFloat(0.10,0.10), rmRandFloat(0.10,0.10));
			rmAddTradeRouteWaypoint(tradeRoute2ID, rmRandFloat(0.16,0.24), rmRandFloat(0.16,0.24));
			rmAddTradeRouteWaypoint(tradeRoute2ID, rmRandFloat(0.26,0.34), rmRandFloat(0.26,0.34));
			rmAddTradeRouteWaypoint(tradeRoute2ID, rmRandFloat(0.36,0.44), rmRandFloat(0.36,0.44));
			rmAddTradeRouteWaypoint(tradeRoute2ID, rmRandFloat(0.47,0.47), rmRandFloat(0.47,0.47));
		}
		else
		{
			rmSetObjectDefTradeRouteID(socket2ID, tradeRoute2ID);
			rmAddTradeRouteWaypoint(tradeRoute2ID, rmRandFloat(0.10,0.10), rmRandFloat(0.10,0.10));
			rmAddTradeRouteWaypoint(tradeRoute2ID, rmRandFloat(0.20,0.28), rmRandFloat(0.20,0.28));
			rmAddTradeRouteWaypoint(tradeRoute2ID, rmRandFloat(0.31,0.37), rmRandFloat(0.31,0.37));
			rmAddTradeRouteWaypoint(tradeRoute2ID, rmRandFloat(0.40,0.48), rmRandFloat(0.40,0.48));
			rmAddTradeRouteWaypoint(tradeRoute2ID, rmRandFloat(0.48,0.48), rmRandFloat(0.48,0.48));
		}

		bool placedTradeRoute2 = rmBuildTradeRoute(tradeRoute2ID, "dirt");
		rmSetObjectDefTradeRouteID(socket2ID, tradeRoute2ID);
		vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.25);
		rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);
		socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.60);
		rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);
		socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.95);
		rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);
	}
	else if (TPvariation <= 1.0)
	{
		int tradeRouteID = rmCreateTradeRoute();
		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
		rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socketID, true);
		rmSetObjectDefMinDistance(socketID, 0.0);
		rmSetObjectDefMaxDistance(socketID, 8.0);


		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, rmRandFloat(0.51,0.53), 0.01);
		rmAddTradeRouteWaypoint(tradeRouteID, rmRandFloat(0.52,0.58), rmRandFloat(0.08,0.12));
		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.36);
		rmAddTradeRouteWaypoint(tradeRouteID, rmRandFloat(0.43,0.46), rmRandFloat(0.43,0.46));
		rmAddTradeRouteWaypoint(tradeRouteID, 0.36, 0.50);
		rmAddTradeRouteWaypoint(tradeRouteID, rmRandFloat(0.08,0.12), rmRandFloat(0.52,0.58));
		rmAddTradeRouteWaypoint(tradeRouteID, 0.01, rmRandFloat(0.51,0.53));

		bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		if (cNumberNonGaiaPlayers < 6)
		{
			vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.05);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.35);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.65);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.95);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
		else
		{
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.05);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.28);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.72);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.95);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
	}
	else
	{
		int tradeRoute3ID = rmCreateTradeRoute();
		int socket3ID=rmCreateObjectDef("sockets to dock Trade Posts");
		rmAddObjectDefItem(socket3ID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socket3ID, true);
		rmSetObjectDefMinDistance(socket3ID, 0.0);
		rmSetObjectDefMaxDistance(socket3ID, 8.0);


		rmSetObjectDefTradeRouteID(socket3ID, tradeRoute3ID);
		rmAddTradeRouteWaypoint(tradeRoute3ID, 0.32, 0.68);
		rmAddTradeRouteWaypoint(tradeRoute3ID, 0.28, 0.41);
		rmAddTradeRouteWaypoint(tradeRoute3ID, 0.30, 0.30);
		rmAddTradeRouteWaypoint(tradeRoute3ID, 0.41, 0.28);
		rmAddTradeRouteWaypoint(tradeRoute3ID, 0.68, 0.32);

		bool placedTradeRoute3 = rmBuildTradeRoute(tradeRoute3ID, "dirt");
		rmSetObjectDefTradeRouteID(socket3ID, tradeRoute3ID);
		if (cNumberNonGaiaPlayers < 6)
		{
			vector socket3Loc = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.10);
			rmPlaceObjectDefAtPoint(socket3ID, 0, socket3Loc);
			socket3Loc = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.35);
			rmPlaceObjectDefAtPoint(socket3ID, 0, socket3Loc);
			socket3Loc = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.65);
			rmPlaceObjectDefAtPoint(socket3ID, 0, socket3Loc);
			socket3Loc = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.90);
			rmPlaceObjectDefAtPoint(socket3ID, 0, socket3Loc);
		}
		else
		{
			socket3Loc = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.10);
			rmPlaceObjectDefAtPoint(socket3ID, 0, socket3Loc);
			socket3Loc = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.30);
			rmPlaceObjectDefAtPoint(socket3ID, 0, socket3Loc);
			socket3Loc = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.50);
			rmPlaceObjectDefAtPoint(socket3ID, 0, socket3Loc);
			socket3Loc = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.70);
			rmPlaceObjectDefAtPoint(socket3ID, 0, socket3Loc);
			socket3Loc = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.90);
			rmPlaceObjectDefAtPoint(socket3ID, 0, socket3Loc);
		}
	}


	// *************************************************************************************************************

	// Text
	rmSetStatusText("",0.45);

	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.3;
		float yLoc = 0.3;
		float walk = 0.03;

		if (randLoc == 2 || TPvariation <= 1.0) {
			xLoc = 0.75;
			yLoc = 0.75;
			if (randomfrozen >= 0.5) {
				ypKingsHillLandfill(xLoc, yLoc, 0.01, 1.0, "saguenay tundra", 0);
			} else {
				ypKingsHillLandfill(xLoc, yLoc, 0.01, 1.0, "yukon grass", 0);
			}
		} else if (cNumberTeams > 2) {
			xLoc = 0.5;
			yLoc = 0.5;
		}

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}

	// ******************************************** NATIVES *************************************************

	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;

	nativeID0 = rmCreateGrouping("Cree village 4", "native cree village "+4);
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
//	rmAddGroupingConstraint(nativeID0, avoidImpassableLand);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
//  rmAddGroupingToClass(nativeID0, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID0, avoidNatives);
	if (TPvariation > 0.5)
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.36, 0.86);
	else
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.36, 0.86);

	nativeID2 = rmCreateGrouping("Cree village 1", "native cree village "+1);
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
//	rmAddGroupingConstraint(nativeID2, avoidImpassableLand);
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));
//  rmAddGroupingToClass(nativeID2, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID2, avoidNatives);
	if (TPvariation > 0.5)
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.86, 0.36);
	else
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.86, 0.36);

	nativeID1 = rmCreateGrouping("huron village 1", "native huron village "+5);
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
//  rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
//  rmAddGroupingToClass(nativeID1, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID1, avoidNatives);
	if (cNumberTeams >= 3)
	{
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.40, 0.58); //
	}
	else if (TPvariation > 0.5)
	{
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.15, 0.33); //
	}
	else
	{
		if (cNumberNonGaiaPlayers >= 4)
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.18, 0.41); //
		else
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.15, 0.44); //
	}

	nativeID3 = rmCreateGrouping("huron village 3", "native huron village "+5);
    rmSetGroupingMinDistance(nativeID3, 0.00);
    rmSetGroupingMaxDistance(nativeID3, 0.00);
//  rmAddGroupingConstraint(nativeID3, avoidImpassableLand);
	rmAddGroupingToClass(nativeID3, rmClassID("natives"));
//  rmAddGroupingToClass(nativeID3, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID3, avoidNatives);
	if (cNumberTeams >= 3)
	{
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.58, 0.40); //
	}
	else if (TPvariation > 0.5)
	{
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.33, 0.15); //
	}
	else
	{
		if (cNumberNonGaiaPlayers >= 4)
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.41, 0.18); //
		else
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.44, 0.15); //
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
	rmSetObjectDefMaxDistance(playergoldID, 17.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);

	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 38.0); //58
	rmSetObjectDefMaxDistance(playergold2ID, 40.0); //62
//	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidTownCenter);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergold2ID, avoidImpassableLandFar);
	rmAddObjectDefConstraint(playergold2ID, avoidNativesFar);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldTypeFar);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold2ID, avoidCenter);
	if (randomfrozen < 0.5)
	rmAddObjectDefConstraint(playergold2ID, avoidIceArea);
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
	if (randomfrozen >= 0.5)
		rmAddObjectDefItem(playerTreeID, "TreeSaguenay", rmRandInt(2,2), 2.0);
	else
		rmAddObjectDefItem(playerTreeID, "TreeGreatLakesSnow", rmRandInt(2,2), 2.0);
    rmSetObjectDefMinDistance(playerTreeID, 12);
    rmSetObjectDefMaxDistance(playerTreeID, 16);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
//	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);

	// Starting herd
	int playermooseID = rmCreateObjectDef("starting moose");
	if (randomfrozen >= 0.5)
		rmAddObjectDefItem(playermooseID, "moose", rmRandInt(2,2), 5.0);
	else
		rmAddObjectDefItem(playermooseID, "muskOx", rmRandInt(2,2), 5.0);
	rmSetObjectDefMinDistance(playermooseID, 10.0);
	rmSetObjectDefMaxDistance(playermooseID, 12.0);
	rmSetObjectDefCreateHerd(playermooseID, false);
	rmAddObjectDefToClass(playermooseID, classStartingResource);
	rmAddObjectDefConstraint(playermooseID, avoidTradeRoute);
	rmAddObjectDefConstraint(playermooseID, avoidImpassableLand);
	rmAddObjectDefConstraint(playermooseID, avoidNatives);
//	rmAddObjectDefConstraint(playermooseID, avoidStartingResources);

	// 2nd herd
	int player2ndherdID = rmCreateObjectDef("player 2nd herd");
	if (randomfrozen >= 0.5)
		rmAddObjectDefItem(player2ndherdID, "Seal", rmRandInt(9,9), 7.0);
	else
		rmAddObjectDefItem(player2ndherdID, "caribou", rmRandInt(10,10), 7.0);
    rmSetObjectDefMinDistance(player2ndherdID, 26);
    rmSetObjectDefMaxDistance(player2ndherdID, 30);
	rmAddObjectDefToClass(player2ndherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player2ndherdID, true);
	rmAddObjectDefConstraint(player2ndherdID, avoidStartingResources);
	rmAddObjectDefConstraint(player2ndherdID, avoidMooseShort);
//	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(player2ndherdID, avoidImpassableLandFar);
	rmAddObjectDefConstraint(player2ndherdID, avoidNatives);

	// 3rd herd
	int player3rdherdID = rmCreateObjectDef("player 3rd herd");
	if (randomfrozen >= 0.5)
		rmAddObjectDefItem(player3rdherdID, "moose", rmRandInt(5,5), 6.0);
	else
		rmAddObjectDefItem(player3rdherdID, "muskOx", rmRandInt(6,6), 6.0);
    rmSetObjectDefMinDistance(player3rdherdID, 34);
    rmSetObjectDefMaxDistance(player3rdherdID, 36);
	rmAddObjectDefToClass(player3rdherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player3rdherdID, true);
	rmAddObjectDefConstraint(player3rdherdID, avoidStartingResources);
	rmAddObjectDefConstraint(player3rdherdID, avoidGoldType);
	rmAddObjectDefConstraint(player3rdherdID, avoidCaribou);
	rmAddObjectDefConstraint(player3rdherdID, avoidSeal);
	rmAddObjectDefConstraint(player3rdherdID, avoidMooseShort);
//	rmAddObjectDefConstraint(player3rdherdID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(player3rdherdID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(player3rdherdID, avoidImpassableLandFar);
	rmAddObjectDefConstraint(player3rdherdID, avoidNativesFar);
	rmAddObjectDefConstraint(player3rdherdID, avoidEdge);
	rmAddObjectDefConstraint(player3rdherdID, avoidCenter);

	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 28.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget); //Short
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	int nugget0count = rmRandInt (2,2); // 1,2

	int colonyShipID = 0;
   for(i=1; < cNumberPlayers)
   {
		colonyShipID=rmCreateObjectDef("colony ship "+i);
	 	rmAddObjectDefItem(colonyShipID, "HomeCityWaterSpawnFlag", 1, 1.0);
		rmSetObjectDefMinDistance(colonyShipID, 0.0);
		rmSetObjectDefMaxDistance(colonyShipID, rmXFractionToMeters(0.35));
		rmAddObjectDefConstraint(colonyShipID, avoidColonyShip);
		rmAddObjectDefConstraint(colonyShipID, avoidLandFar);
		rmAddObjectDefConstraint(colonyShipID, avoidEdgeMore);
	//  vector colonyShipLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(colonyShipID, i));
	//  rmSetHomeCityWaterSpawnPoint(i, colonyShipLocation);
		if (randomfrozen < 0.5)
			rmAddObjectDefConstraint(colonyShipID, avoidIceArea);
       	rmPlaceObjectDefAtLoc(colonyShipID, i, 0.75, 0.75);
	}

	// ******** Place ********

	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playergold3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playermooseID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playermooseID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playermooseID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playermooseID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(player2ndherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(player3rdherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if (nugget0count == 2)
			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}

	// ************************************************************************************************

	// Text
	rmSetStatusText("",0.60);

	// ************************************** COMMON RESOURCES ****************************************


	// ************* Mines **************

		int goldCount = 3+2*cNumberNonGaiaPlayers;  // 3,3
//		int northgoldCount = rmRandInt(3,3);  // 3,3

	//Mines
	for(i=0; < goldCount)
	{
		int commongoldID = rmCreateObjectDef("common mines"+i);
		rmAddObjectDefItem(commongoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(commongoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(commongoldID, rmXFractionToMeters(0.7));
		rmAddObjectDefToClass(commongoldID, classGold);
		rmAddObjectDefConstraint(commongoldID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(commongoldID, avoidImpassableLand);
		rmAddObjectDefConstraint(commongoldID, avoidNatives);
		rmAddObjectDefConstraint(commongoldID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(commongoldID, avoidGoldFar);
		rmAddObjectDefConstraint(commongoldID, avoidTownCenterFar);
		rmAddObjectDefConstraint(commongoldID, avoidEdge);
		if (randomfrozen < 0.5)
			rmAddObjectDefConstraint(commongoldID, avoidIceAreaFar);
		else
		{
			rmAddObjectDefConstraint(commongoldID, avoidIsland1);
			rmAddObjectDefConstraint(commongoldID, avoidIsland2);
			rmAddObjectDefConstraint(commongoldID, avoidIsland3);
		}
		rmPlaceObjectDefAtLoc(commongoldID, 0, 0.32, 0.32);
	}

	// *********************************

	// Text
	rmSetStatusText("",0.70);

	// ************ Forest *************

	// Main forest
	int forestcount = 6+5*cNumberNonGaiaPlayers;

	for (i=0; < forestcount)
	{
		int forestID = rmCreateArea("forest"+i);
		rmSetAreaWarnFailure(forestID, false);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(240), rmAreaTilesToFraction(260));
		if (randomfrozen >= 0.5)
			rmSetAreaForestType(forestID, "saguenay forest");
		else
			rmSetAreaForestType(forestID, "great lakes forest snow");
//		rmSetAreaObeyWorldCircleConstraint(forestID, false);
		rmSetAreaForestDensity(forestID, 1.0);
		rmSetAreaForestClumpiness(forestID, 1.0);
		rmSetAreaForestUnderbrush(forestID, 0.0);
		rmSetAreaMinBlobs(forestID, 1);
		rmSetAreaMaxBlobs(forestID, 5);
		rmSetAreaMinBlobDistance(forestID, 10.0);
		rmSetAreaMaxBlobDistance(forestID, 30.0);
		rmSetAreaCoherence(forestID, 1.0);
		rmSetAreaSmoothDistance(forestID, 6);
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidForest);
		rmAddAreaConstraint(forestID, avoidGoldType);
		rmAddAreaConstraint(forestID, avoidSealMin);
		rmAddAreaConstraint(forestID, avoidMooseMin);
		rmAddAreaConstraint(forestID, avoidCaribouMin);
		rmAddAreaConstraint(forestID, avoidMuskOxMin);
		rmAddAreaConstraint(forestID, avoidTownCenter);
		rmAddAreaConstraint(forestID, avoidNatives);
		rmAddAreaConstraint(forestID, avoidTradeRouteShort);
		rmAddAreaConstraint(forestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(forestID, avoidImpassableLandShort);
//		rmAddAreaConstraint(forestID, avoidEdge);
		if (randomfrozen >= 0.5)
		{
			rmAddAreaConstraint(forestID, avoidIsland1);
			rmAddAreaConstraint(forestID, avoidIsland2);
			rmAddAreaConstraint(forestID, avoidIsland3);
		}
		else
			rmAddAreaConstraint(forestID, avoidIceArea);
		if (rmGetIsKOTH()) {
			rmAddAreaConstraint(forestID, avoidWater);
		}
		rmBuildArea(forestID);
	}

	// Random tree clumps to fill blank spots
	int randomtreecount = 4+1*cNumberNonGaiaPlayers;

	for (i=0; < randomtreecount)
	{
		int randomtreenorthID = rmCreateObjectDef("random trees north"+i);
		if (randomfrozen >= 0.5)
			rmAddObjectDefItem(randomtreenorthID, "TreeSaguenay", rmRandInt(5,5), 7.0);
		else
			rmAddObjectDefItem(randomtreenorthID, "TreeGreatLakesSnow", rmRandInt(5,5), 7.0);
		rmSetObjectDefMinDistance(randomtreenorthID, 0);
		rmSetObjectDefMaxDistance(randomtreenorthID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(randomtreenorthID, classForest);
		rmAddObjectDefConstraint(randomtreenorthID, avoidForestShort);
		rmAddObjectDefConstraint(randomtreenorthID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(randomtreenorthID, avoidImpassableLand);
		rmAddObjectDefConstraint(randomtreenorthID, avoidNatives);
		rmAddObjectDefConstraint(randomtreenorthID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(randomtreenorthID, avoidGoldType);
		rmAddObjectDefConstraint(randomtreenorthID, avoidTownCenterShort);
		rmAddObjectDefConstraint(randomtreenorthID, avoidStartingResources);
		rmAddObjectDefConstraint(randomtreenorthID, avoidSealMin);
		rmAddObjectDefConstraint(randomtreenorthID, avoidMooseMin);
		rmAddObjectDefConstraint(randomtreenorthID, avoidCaribouMin);
		rmAddObjectDefConstraint(randomtreenorthID, avoidMuskOxMin);
		if (randomfrozen >= 0.5)
		{
			rmAddObjectDefConstraint(randomtreenorthID, avoidIsland1);
			rmAddObjectDefConstraint(randomtreenorthID, avoidIsland2);
			rmAddObjectDefConstraint(randomtreenorthID, avoidIsland3);
		}
		else
			rmAddObjectDefConstraint(randomtreenorthID, avoidIceArea);
		rmAddObjectDefConstraint(randomtreenorthID, avoidWater);
		rmPlaceObjectDefAtLoc(randomtreenorthID, 0, 0.50, 0.50);
	}

	// Island trees
	if (randomfrozen >= 0.5)
	{
		int island1treeID = rmCreateObjectDef("island1 trees");
		rmAddObjectDefItem(island1treeID, "TreeSaguenay", rmRandInt(1,2), 7.0);
		rmAddObjectDefItem(island1treeID, "TreeSaguenay", rmRandInt(1,3), 7.0);
		rmSetObjectDefMaxDistance(island1treeID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(island1treeID, stayInIsland1);
		rmAddObjectDefConstraint(island1treeID, avoidImpassableLandShort);
		rmPlaceObjectDefAtLoc(island1treeID, 0, 0.50, 0.50);

		int island2treeID = rmCreateObjectDef("island2 trees");
		rmAddObjectDefItem(island2treeID, "TreeSaguenay", rmRandInt(1,2), 7.0);
		rmAddObjectDefItem(island2treeID, "TreeSaguenay", rmRandInt(1,3), 7.0);
		rmSetObjectDefMaxDistance(island2treeID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(island2treeID, stayInIsland2);
		rmAddObjectDefConstraint(island2treeID, avoidImpassableLandShort);
		rmPlaceObjectDefAtLoc(island2treeID, 0, 0.50, 0.50);

		if (cNumberNonGaiaPlayers >= 6)
		{
			int island3treeID = rmCreateObjectDef("island3 trees");
			rmAddObjectDefItem(island3treeID, "TreeSaguenay", rmRandInt(1,2), 7.0);
			rmAddObjectDefItem(island3treeID, "TreeSaguenay", rmRandInt(1,3), 7.0);
			rmSetObjectDefMaxDistance(island3treeID, rmXFractionToMeters(0.5));
			rmAddObjectDefConstraint(island3treeID, stayInIsland3);
			rmAddObjectDefConstraint(island3treeID, avoidImpassableLandShort);
			rmPlaceObjectDefAtLoc(island3treeID, 0, 0.50, 0.50);
		}
	}


	// ************ Herds *************

	int northherdcount = 3+0.5*cNumberNonGaiaPlayers;
	int middleherdcount = 2+1*cNumberNonGaiaPlayers;
	int southherdcount = 2+1*cNumberNonGaiaPlayers;

	//North herds
	for (i=0; < northherdcount)
	{
		int northerdID = rmCreateObjectDef("north herd"+i);
		if (randomfrozen >= 0.5)
			rmAddObjectDefItem(northerdID, "moose", rmRandInt(5,6), 7.0);
		else
			rmAddObjectDefItem(northerdID, "muskOx", rmRandInt(5,6), 7.0);
		rmSetObjectDefMinDistance(northerdID, 0.0);
		rmSetObjectDefMaxDistance(northerdID, rmXFractionToMeters(0.6));
		rmSetObjectDefCreateHerd(northerdID, true);
		rmAddObjectDefConstraint(northerdID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(northerdID, avoidNatives);
//		rmAddObjectDefConstraint(northerdID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(northerdID, avoidForestMin);
		rmAddObjectDefConstraint(northerdID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(northerdID, avoidMooseFar);
		rmAddObjectDefConstraint(northerdID, avoidSeal);
		rmAddObjectDefConstraint(northerdID, avoidMuskOxFar);
		rmAddObjectDefConstraint(northerdID, avoidTownCenterFar);
		rmAddObjectDefConstraint(northerdID, avoidEdge);
		if (randomfrozen >= 0.5)
		{
			rmAddObjectDefConstraint(northerdID, stayCloseToBayWater); //stayNearBayWater
			rmAddObjectDefConstraint(northerdID, avoidIsland1);
			rmAddObjectDefConstraint(northerdID, avoidIsland2);
			rmAddObjectDefConstraint(northerdID, avoidIsland3);
		}
		else
		{
			rmAddObjectDefConstraint(northerdID, stayNearBayWaterIce);
		}
		rmPlaceObjectDefAtLoc(northerdID, 0, 0.50, 0.50);

	}

	//Middle herds
	for (i=0; < middleherdcount)
	{
		int middleherdID = rmCreateObjectDef("middle herd"+i);
		if (randomfrozen >= 0.5)
			rmAddObjectDefItem(middleherdID, "Seal", rmRandInt(7,8), 8.0);
		else
			rmAddObjectDefItem(middleherdID, "caribou", rmRandInt(8,9), 8.0);
		rmSetObjectDefMinDistance(middleherdID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(middleherdID, rmXFractionToMeters(0.6));
		rmSetObjectDefCreateHerd(middleherdID, true);
		rmAddObjectDefConstraint(middleherdID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(middleherdID, avoidNatives);
		rmAddObjectDefConstraint(middleherdID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(middleherdID, avoidForestMin);
		rmAddObjectDefConstraint(middleherdID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(middleherdID, avoidMoose);
		rmAddObjectDefConstraint(middleherdID, avoidSeal);
		rmAddObjectDefConstraint(middleherdID, avoidMuskOx);
		rmAddObjectDefConstraint(middleherdID, avoidCaribou);
		rmAddObjectDefConstraint(middleherdID, avoidTownCenterFar);
		if (randomfrozen >= 0.5)
			rmAddObjectDefConstraint(middleherdID, stayCenterMore);
		else
			rmAddObjectDefConstraint(middleherdID, stayCenter);
		if (randomfrozen >= 0.5)
		{
//			rmAddObjectDefConstraint(middleherdID, avoidBayWaterFar);
			rmAddObjectDefConstraint(middleherdID, avoidIsland1);
			rmAddObjectDefConstraint(middleherdID, avoidIsland2);
			rmAddObjectDefConstraint(middleherdID, avoidIsland3);
		}
		else
			rmAddObjectDefConstraint(middleherdID, avoidIceArea);
		rmPlaceObjectDefAtLoc(middleherdID, 0, 0.40, 0.40);
	}

	//South herds
	int mooseorSeal = rmRandInt (0,1);
	for (i=0; < southherdcount)
	{
		int southherdID = rmCreateObjectDef("south herd"+i);
		if (randomfrozen >= 0.5)
		{
			if (mooseorSeal == 0)
				rmAddObjectDefItem(southherdID, "moose", rmRandInt(5,6), 7.0);
			else
				rmAddObjectDefItem(southherdID, "Seal", rmRandInt(7,8), 8.0);
		}
		else
		{
			if (mooseorSeal == 0)
				rmAddObjectDefItem(southherdID, "muskOx", rmRandInt(5,6), 7.0);
			else
				rmAddObjectDefItem(southherdID, "caribou", rmRandInt(8,9), 8.0);
		}
		rmSetObjectDefMinDistance(southherdID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(southherdID, rmXFractionToMeters(0.4));
		rmSetObjectDefCreateHerd(southherdID, true);
		rmAddObjectDefConstraint(southherdID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(southherdID, avoidNatives);
		rmAddObjectDefConstraint(southherdID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(southherdID, avoidForestMin);
		rmAddObjectDefConstraint(southherdID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(southherdID, avoidMoose);
		rmAddObjectDefConstraint(southherdID, avoidSeal);
		rmAddObjectDefConstraint(southherdID, avoidMuskOx);
		rmAddObjectDefConstraint(southherdID, avoidCaribou);
		rmAddObjectDefConstraint(southherdID, avoidTownCenterFar);
		rmAddObjectDefConstraint(southherdID, staySouth);
		rmAddObjectDefConstraint(southherdID, avoidEdge);
		if (randomfrozen >= 0.5)
		{
			rmAddObjectDefConstraint(southherdID, avoidIsland1);
			rmAddObjectDefConstraint(southherdID, avoidIsland2);
			rmAddObjectDefConstraint(southherdID, avoidIsland3);
			rmAddObjectDefConstraint(southherdID, avoidBayWaterFar);
		}
		else
		{
			rmAddObjectDefConstraint(southherdID, avoidIceArea);
			rmAddObjectDefConstraint(southherdID, avoidBayWaterIceFar);
		}
		rmPlaceObjectDefAtLoc(southherdID, 0, 0.25, 0.25);
	}
	// ************************************

	// Text
	rmSetStatusText("",0.80);



	// ****************************************

	// Text
	rmSetStatusText("",0.95);

	// ************** Treasures ***************

	int treasure2count = -1;
	int treasure3count = -1;
	int treasure4count = -1;

	if (randomfrozen >= 0.5)
		treasure2count = 8+0.5*cNumberNonGaiaPlayers;
	else
		treasure2count = 7+0.5*cNumberNonGaiaPlayers;
		treasure3count = 1+0.5*cNumberNonGaiaPlayers;
		treasure4count = 1;
		if (cNumberNonGaiaPlayers >= 4)
			treasure4count = 0.5*cNumberNonGaiaPlayers;

	// Treasures lvl 4
	for (i=0; < treasure4count)
	{
		int Nugget4ID = rmCreateObjectDef("nugget lvl4 "+i);
		rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget4ID, 0);
		rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.6));
		rmSetNuggetDifficulty(4,4);
		if (randomfrozen >= 0.5)
			rmAddObjectDefConstraint(Nugget4ID, avoidNugget);
		else
			rmAddObjectDefConstraint(Nugget4ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidCaribouMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidSealMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidMooseMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidMuskOxMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidEdge);
		if (randomfrozen >= 0.5)
		{
			rmAddObjectDefConstraint(Nugget4ID, avoidIsland1);
			rmAddObjectDefConstraint(Nugget4ID, avoidIsland2);
			rmAddObjectDefConstraint(Nugget4ID, avoidIsland3);
		}
		else
			rmAddObjectDefConstraint(Nugget4ID, avoidIceArea);
		if (cNumberNonGaiaPlayers >= 4)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.50, 0.50);
	}

	// Treasures lvl 3
	for (i=0; < treasure3count)
	{
		int Nugget3ID = rmCreateObjectDef("nugget lvl3 "+i);
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, 0);
		rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.6));
		rmSetNuggetDifficulty(3,3);
		if (randomfrozen >= 0.5)
			rmAddObjectDefConstraint(Nugget3ID, avoidNugget);
		else
			rmAddObjectDefConstraint(Nugget3ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidCaribouMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidSealMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidMooseMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidMuskOxMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidEdge);
		if (randomfrozen >= 0.5)
		{
			rmAddObjectDefConstraint(Nugget3ID, avoidIsland1);
			rmAddObjectDefConstraint(Nugget3ID, avoidIsland2);
			rmAddObjectDefConstraint(Nugget3ID, avoidIsland3);
		}
		else
			rmAddObjectDefConstraint(Nugget3ID, avoidIceArea);
		if (cNumberNonGaiaPlayers >= 4)
			rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50);
	}

	// Treasures lvl 2
	for (i=0; < treasure2count)
	{
		int Nugget2ID = rmCreateObjectDef("nugget lvl2 "+i);
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.6));
		rmSetNuggetDifficulty(2,2);
		if (randomfrozen >= 0.5)
			rmAddObjectDefConstraint(Nugget2ID, avoidNugget);
		else
			rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidCaribouMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidSealMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidMooseMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidMuskOxMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge);
		if (randomfrozen >= 0.5)
		{
			rmAddObjectDefConstraint(Nugget2ID, avoidIsland1);
			rmAddObjectDefConstraint(Nugget2ID, avoidIsland2);
			rmAddObjectDefConstraint(Nugget2ID, avoidIsland3);
		}
		else
			rmAddObjectDefConstraint(Nugget2ID, avoidIceArea);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}

	// ****************************************

	// **************** Sheeps *****************

	int sheepcount = 2+3*cNumberNonGaiaPlayers;

	if (randomfrozen >= 0.5)
	{
		for (i=0; < sheepcount)
		{
			int sheepID=rmCreateObjectDef("sheep"+i);
			rmAddObjectDefItem(sheepID, "sheep", 1, 1.0);
			rmSetObjectDefMinDistance(sheepID, 0.0);
			rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.5));
			rmAddObjectDefConstraint(sheepID, avoidSheep);
			rmAddObjectDefConstraint(sheepID, avoidForestMin);
			rmAddObjectDefConstraint(sheepID, avoidTownCenterFar);
			rmAddObjectDefConstraint(sheepID, avoidIsland1);
			rmAddObjectDefConstraint(sheepID, avoidIsland2);
			rmAddObjectDefConstraint(sheepID, avoidIsland3);
			rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
			rmAddObjectDefConstraint(sheepID, avoidEdge);
			rmPlaceObjectDefAtLoc(sheepID, 0, 0.50, 0.50);
		}
	}
	// ****************************************

	// ************ Sea resources *************

	//Fish
	int fishcount = -1;
	if (randomfrozen >= 0.5)
	fishcount = 6+3*cNumberNonGaiaPlayers;
	else
	fishcount = 3+3*cNumberNonGaiaPlayers;
	int whalecount = 2+2*cNumberNonGaiaPlayers;

	for (i=0; < whalecount)
	{
	int whaleID=rmCreateObjectDef("whale"+i);
	rmAddObjectDefItem(whaleID, "beluga", 1, 2.0);
	rmSetObjectDefMinDistance(whaleID, 0.0);
	rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(whaleID, avoidWhale);
	rmAddObjectDefConstraint(whaleID, avoidLandFar);
	rmAddObjectDefConstraint(whaleID, avoidColonyShipShort);
	if (randomfrozen < 0.5)
		rmAddObjectDefConstraint(whaleID, avoidIceArea);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.75, 0.75);
	}

	for (i=0; < fishcount)
	{
		int fishID = rmCreateObjectDef("fish"+i);
		rmAddObjectDefItem(fishID, "FishSalmon", rmRandInt(2,2), 5.0);
		rmSetObjectDefMinDistance(fishID, 0.0);
		rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(fishID, avoidFish);
		rmAddObjectDefConstraint(fishID, avoidLand);
		rmAddObjectDefConstraint(fishID, avoidColonyShipShort);
		if (randomfrozen < 0.5)
			rmAddObjectDefConstraint(fishID, avoidIceArea);
		rmPlaceObjectDefAtLoc(fishID, 0, 0.75, 0.75);
	}



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


	// ****************************************************

	// Text
	rmSetStatusText("",1.00);



} //END

