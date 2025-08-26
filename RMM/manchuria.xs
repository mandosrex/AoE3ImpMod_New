// ESOC MANCHURIA
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
	int playerTiles = 15000;
	if (cNumberNonGaiaPlayers >2)
		playerTiles = 14000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 13000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 12000;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(true);
	
	// Picks a default water height
	rmSetSeaLevel(5.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	rmSetMapElevationParameters(cElevTurbulence, 0.05, 2, 0.5, 4.0); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);
	
	
	// Picks default terrain and water
	rmSetSeaType("Coastal Mongolia");
	rmTerrainInitialize("Mongolia\ground_grass4_mongol", 4.0); // 
	rmSetBaseTerrainMix("mongolia_grass_b"); // 
	rmSetMapType("Japan"); 
	rmSetMapType("desert");
	rmSetMapType("water");
	rmSetMapType("asia");
	rmSetMapType("AIFishingUseful");
	rmSetLightingSet("mongolia");

	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);
	
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Shaolin");
	subCiv1 = rmGetCivID("Zen");
	rmSetSubCiv(0, "Shaolin");
	rmSetSubCiv(1, "Zen");
	

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
	
	// ******************************************************************************************
	
	// Text
	rmSetStatusText("",0.20);
	
	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other
   
	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.38), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayNW = rmCreatePieConstraint("Stay NW", 0.50, 0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(270),rmDegreesToRadians(90));
	int staySE = rmCreatePieConstraint("Stay SE", 0.50, 0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(90),rmDegreesToRadians(270));
	int stayMiddle = rmCreateBoxConstraint("stay in the middle", 0.40, 0.00, 0.60, 1.00, 0.00);	
	int staySW = rmCreatePieConstraint("Stay SW", 0.34, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(225),rmDegreesToRadians(360));
	int stayNE = rmCreatePieConstraint("Stay NE", 0.66, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(360),rmDegreesToRadians(135));
	int staySouthHalf = rmCreatePieConstraint("Stay south half", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(180),rmDegreesToRadians(360));
	int stayNorthHalf = rmCreatePieConstraint("Stay north half", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(360),rmDegreesToRadians(180));
	int Wcorner = rmCreatePieConstraint("Stay west corner", 0.00, 1.00,rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int Ncorner = rmCreatePieConstraint("Stay north corner", 1.00, 1.00,rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	
	// Resource avoidance
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 30.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 24.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidSerowFar = rmCreateTypeDistanceConstraint("avoid Serow far", "ypSaiga", 48.0);
	int avoidSerow = rmCreateTypeDistanceConstraint("avoid Serow", "ypSaiga", 45.0);
	int avoidSerowShort = rmCreateTypeDistanceConstraint("avoid Serow short", "ypSaiga", 25.0);
	int avoidSerowMin = rmCreateTypeDistanceConstraint("avoid Serow min", "ypSaiga", 4.0);
	int avoidSheepFar = rmCreateTypeDistanceConstraint("avoid Sheep far", "ypMarcoPoloSheep", 45.0);
	int avoidSheep = rmCreateTypeDistanceConstraint("avoid  Sheep", "ypMarcoPoloSheep", 40.0);
	int avoidSheepShort = rmCreateTypeDistanceConstraint("avoid  Sheep short", "ypMarcoPoloSheep", 35.0);
	int avoidSheepMin = rmCreateTypeDistanceConstraint("avoid Sheep min", "ypMarcoPoloSheep", 5.0);
	int avoidMuskdeerFar = rmCreateTypeDistanceConstraint("avoid muskdeer far", "ypmuskdeer", 54.0);
	int avoidMuskdeer = rmCreateTypeDistanceConstraint("avoid muskdeer ", "ypmuskdeer", 45.0);
	int avoidMuskdeerMin = rmCreateTypeDistanceConstraint("avoid muskdeer min ", "ypmuskdeer", 4.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 8.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 32.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 50.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 12.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold", rmClassID("Gold"), 30.0);
	int avoidGoldMed = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 42.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 62.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 68.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 15.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 45.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 50.0);
	int avoidTownCenterVeryFar = rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 85.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 66.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 44.0);
	int avoidTownCenterMed = rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 40.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 24.0);
	int avoidTownCenterMin = rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 18.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid natives short", rmClassID("natives"), 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 6.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("avoid natives far", rmClassID("natives"), 15.0);
	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 4.0);
	int avoidWhale=rmCreateTypeDistanceConstraint("avoid whale", "fish", 28.0+1*cNumberNonGaiaPlayers);
	int avoidFish=rmCreateTypeDistanceConstraint("avoid fish", "fish", 12.0);
	int avoidYak=rmCreateTypeDistanceConstraint("avoid yak", "ypyak", 58.0);
	int avoidColonyShip = rmCreateTypeDistanceConstraint("avoid colony ship", "HomeCityWaterSpawnFlag", 10.0);


	// Avoid impassable land
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("avoid impassable land min", "Land", false, 1.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("avoid impassable land short", "Land", false, 3.0);
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("avoid impassable land medium", "Land", false, 15.0);
	int avoidImpassableLandFar = rmCreateTerrainDistanceConstraint("avoid impassable land far", "Land", false, 20.0);
	int stayNearLand = rmCreateTerrainMaxDistanceConstraint("stay near land ", "Land", true, 5.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 8.0);
	int avoidLandFar = rmCreateTerrainDistanceConstraint("avoid land far ", "Land", true, 14.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 3.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 10);
	int avoidWaterFar = rmCreateTerrainDistanceConstraint("avoid water far", "water", true, 30.0);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 24.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 5.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 20.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 5.0);
	
	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);	
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 5.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 6.0);
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
					rmPlacePlayer(1, 0.16, 0.48);
					rmPlacePlayer(2, 0.84, 0.48);
				}
				else
				{
					rmPlacePlayer(2, 0.16, 0.48);
					rmPlacePlayer(1, 0.84, 0.48);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.13, 0.42, 0.23, 0.66, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.87, 0.42, 0.77, 0.66, 0.00, 0.20);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.13, 0.38, 0.25, 0.72, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.87, 0.38, 0.75, 0.72, 0.00, 0.20);
				}
			}
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.18, 0.48, 0.19, 0.48, 0.00, 0.20);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmPlacePlayersLine(0.87, 0.42, 0.77, 0.66, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.87, 0.38, 0.75, 0.72, 0.00, 0.20);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.82, 0.48, 0.81, 0.48, 0.00, 0.20);

						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmPlacePlayersLine(0.13, 0.42, 0.23, 0.66, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.13, 0.38, 0.25, 0.72, 0.00, 0.20);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.13, 0.42, 0.23, 0.66, 0.00, 0.20);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.87, 0.38, 0.75, 0.72, 0.00, 0.20);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.13, 0.38, 0.25, 0.72, 0.00, 0.20);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.87, 0.42, 0.77, 0.66, 0.00, 0.20);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.13, 0.38, 0.25, 0.72, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.87, 0.38, 0.75, 0.72, 0.00, 0.20);
				}
			}
		}
		else // FFA
		{
	//		rmSetTeamSpacingModifier(0.25);
			rmSetPlacementSection(0.700, 0.300);
			rmPlacePlayersCircular(0.38, 0.38, 0.0);
		}

	
	

	// **************************************************************************************************
   
	// Text
	rmSetStatusText("",0.30);
	
	// ******************************************** MAP LAYOUT **************************************************
	
	
	//High ground 
	int highgroundID = rmCreateArea("high ground");
    rmSetAreaWarnFailure(highgroundID, false);
	rmSetAreaObeyWorldCircleConstraint(highgroundID, false);
    rmSetAreaSize(highgroundID, 0.28, 0.28);
	rmSetAreaLocation(highgroundID, 0.5, 0.84);
	rmAddAreaInfluenceSegment(highgroundID, 1.00, 0.92, 0.00, 0.92);
	rmSetAreaMix(highgroundID, "mongolia_grass_b");
//	rmSetAreaMix(highgroundID, "rockies_snow");
    rmSetAreaCoherence(highgroundID, 0.70);
	rmSetAreaSmoothDistance(highgroundID, 5);
    rmBuildArea(highgroundID); 
	
	int avoidHighground = rmCreateAreaDistanceConstraint("avoid high ground", highgroundID, 0.5);
	int avoidHighgroundFar = rmCreateAreaDistanceConstraint("avoid high ground far", highgroundID, 10);
	
	
	//Low ground 
	int lowgroundID = rmCreateArea("low ground");
    rmSetAreaWarnFailure(lowgroundID, false);
	rmSetAreaObeyWorldCircleConstraint(lowgroundID, false);
    rmSetAreaSize(lowgroundID, 0.8, 0.8);
	rmSetAreaLocation(lowgroundID, 0.5, 0.0);
	rmSetAreaTerrainType(lowgroundID, "mongolia\ground_grass4_mongol");
	rmSetAreaMix(lowgroundID, "mongolia_grass_b");
    rmSetAreaCoherence(lowgroundID, 0.75);
	rmSetAreaSmoothDistance(lowgroundID, 8);
	rmAddAreaConstraint(lowgroundID, avoidHighground);
    rmBuildArea(lowgroundID); 
	
	int avoidLowground = rmCreateAreaDistanceConstraint("avoid low ground", lowgroundID, 0.5);
	int avoidLowgroundFar = rmCreateAreaDistanceConstraint("avoid low ground far", lowgroundID, 5.0);
	
	//Sea
	int SeaID = rmCreateArea("Sea");
	rmSetAreaSize(SeaID, 0.21, 0.21);
	rmSetAreaLocation(SeaID, 0.50, 0.10);
	rmSetAreaObeyWorldCircleConstraint(SeaID, false);
	rmAddAreaInfluenceSegment(SeaID, 0.90, 0.00, 0.65, 0.10); 
	rmAddAreaInfluenceSegment(SeaID, 0.65, 0.10, 0.35, 0.10);
	rmAddAreaInfluenceSegment(SeaID, 0.35, 0.10, 0.10, 0.00);
	rmSetAreaWaterType(SeaID, "Coastal Mongolia"); 
//	rmAddAreaTerrainLayer(SeaID, "coastal_japan\ground_grass1_co_japan", 0, 2);
	rmSetAreaMinBlobs(SeaID, 8);
	rmSetAreaMaxBlobs(SeaID, 10);
//	rmSetAreaMinBlobDistance(SeaID, 10);
//	rmSetAreaMaxBlobDistance(SeaID, 20);
	rmSetAreaCoherence(SeaID, 0.7);
	rmSetAreaSmoothDistance(SeaID, 18);
	rmBuildArea(SeaID);
	
	int stayNearSea = rmCreateAreaMaxDistanceConstraint("stay near sea", SeaID, 25);
	int stayCloseSea = rmCreateAreaMaxDistanceConstraint("stay close to sea", SeaID, 15);
	int avoidSea = rmCreateAreaDistanceConstraint("avoid sea", SeaID, 1.0);
	int avoidSeaMed = rmCreateAreaDistanceConstraint("avoid sea med", SeaID, 15);
	int avoidSeaFar = rmCreateAreaDistanceConstraint("avoid sea far", SeaID, 30);
	

	
	// Coastal patches
	for (i=0; < 10*cNumberNonGaiaPlayers)
	{
		int patchID = rmCreateArea("patch coastal"+i);
		rmSetAreaWarnFailure(patchID, false);
		rmSetAreaObeyWorldCircleConstraint(patchID, false);
		rmSetAreaSize(patchID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(75));
		rmSetAreaTerrainType(patchID, "mongolia\ground_grass4_mongol");
		rmSetAreaMix(patchID, "mongolia_grass");
		rmAddAreaToClass(patchID, rmClassID("patch"));
		rmSetAreaMinBlobs(patchID, 1);
		rmSetAreaMaxBlobs(patchID, 5);
		rmSetAreaMinBlobDistance(patchID, 12.0);
		rmSetAreaMaxBlobDistance(patchID, 30.0);
		rmSetAreaCoherence(patchID, 0.0);
//		if (i < 20)
			rmAddAreaConstraint(patchID, stayNearWater);
//		else
//			rmAddAreaConstraint(patchID, stayCloseSea);
		rmAddAreaConstraint(patchID, avoidPatch);
		rmAddAreaConstraint(patchID, avoidImpassableLandMin);
		rmBuildArea(patchID); 
	}
	
	// Low ground patches
	for (i=0; < 10*cNumberNonGaiaPlayers)
	{
		int patch2ID = rmCreateArea("patch low ground"+i);
		rmSetAreaWarnFailure(patch2ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch2ID, false);
		rmSetAreaSize(patch2ID, rmAreaTilesToFraction(40), rmAreaTilesToFraction(70));
		rmSetAreaTerrainType(patch2ID, "mongolia\ground_grass3_mongol");
		rmSetAreaMix(patch2ID, "mongolia_grass");
		rmAddAreaToClass(patch2ID, rmClassID("patch2"));
		rmSetAreaMinBlobs(patch2ID, 1);
		rmSetAreaMaxBlobs(patch2ID, 5);
		rmSetAreaMinBlobDistance(patch2ID, 12.0);
		rmSetAreaMaxBlobDistance(patch2ID, 30.0);
		rmSetAreaCoherence(patch2ID, 0.0);
		rmAddAreaConstraint(patch2ID, avoidSeaFar);
		rmAddAreaConstraint(patch2ID, avoidPatch2);
		rmAddAreaConstraint(patch2ID, avoidHighground);
		rmBuildArea(patch2ID); 
	}
	
	//Hill
	for (i=0; < 3)
	{
	int hillID = rmCreateArea("hill"+i);
	if (i == 0)
	{
		rmSetAreaSize(hillID, 0.040, 0.040);
		rmAddAreaInfluenceSegment(hillID, 0.50, 1.00, 0.50, 0.94);
		rmSetAreaMix(hillID, "mongolia_grass");	
//		rmAddAreaTerrainLayer(hillID, "mongolia\ground_grass1_co_japan", 0, 2);
	}	
	else if (i == 1)
	{
		rmSetAreaSize(hillID, 0.027, 0.027);
		rmAddAreaInfluenceSegment(hillID, 0.50, 1.00, 0.50, 0.96);
		rmSetAreaCliffHeight(hillID, 4, 0.0, 0.8); 
		rmSetAreaCliffEdge(hillID, 1, 1.0, 0.0, 0.0, 1); 
		rmSetAreaCliffType(hillID, "mongolia"); 
		rmSetAreaCliffPainting(hillID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	}
	else
	{
		rmSetAreaSize(hillID, 0.008, 0.008);
		rmAddAreaInfluenceSegment(hillID, 0.50, 1.00, 0.50, 0.97);
		rmSetAreaCliffHeight(hillID, 4, 0.0, 0.8); 
		rmSetAreaCliffEdge(hillID, 1, 1.0, 0.0, 0.0, 1); 
		rmSetAreaCliffType(hillID, "mongolia"); 
		rmAddAreaToClass(hillID, rmClassID("Cliffs"));
		rmSetAreaCliffPainting(hillID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	}
	rmSetAreaWarnFailure(hillID, false);
	rmSetAreaObeyWorldCircleConstraint(hillID, false);
	rmSetAreaCoherence(hillID, 0.65);
	rmSetAreaSmoothDistance(hillID, 8);
	
	rmSetAreaLocation(hillID, 0.5, 1.0);
//	rmAddAreaConstraint(hillID, avoidImpassableLandMin);
	if (cNumberTeams <= 2)
		rmBuildArea(hillID);
	rmCreateAreaDistanceConstraint("avoid hill "+i, hillID, 1.0);
	}
	
	int avoidHill = rmConstraintID("avoid hill 0");
	

	// Players area
	for (i=1; < cNumberPlayers)
	{
	int playerareaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerareaID);
	rmSetAreaSize(playerareaID, 0.05, 0.05);
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

	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------


   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .05, 0);
   }

	
		// ****************************************** TRADE ROUTE **********************************************
		
	float TPvariation = -1;
	TPvariation = rmRandFloat(0.1,1.0);
//	TPvariation = 0.2; // <--- TEST

	if (cNumberTeams > 2)
		TPvariation = 1.2;

	
	if (TPvariation > 0.5 && TPvariation <= 1.0) // 1 route
	{
		int tradeRouteID = rmCreateTradeRoute();
		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
		rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socketID, true);
		rmSetObjectDefMinDistance(socketID, 0.0);
		rmSetObjectDefMaxDistance(socketID, 6.0);

		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.95, 0.98); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.78);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.72);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.78);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.05, 0.98);
		
		bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "water");
		if(placedTradeRoute == false)
		rmEchoError("Failed to place trade route");
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.24);
		if (cNumberNonGaiaPlayers < 6)
		{
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.49);
		}	
		else
		{
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.41);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.57);
		}
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.76);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);	
	}
	else if (TPvariation <= 0.5) // 2 routes
	{
		int tradeRoute2ID = rmCreateTradeRoute();
		int socket2ID=rmCreateObjectDef("sockets to dock Trade Posts 2");
		rmAddObjectDefItem(socket2ID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socket2ID, true);
		rmSetObjectDefMinDistance(socket2ID, 0.0);
		rmSetObjectDefMaxDistance(socket2ID, 6.0);

		rmSetObjectDefTradeRouteID(socket2ID, tradeRoute2ID);
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.96, 0.52);
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.80, 0.75);
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.74, 0.95); 
		
		bool placedTradeRoute2 = rmBuildTradeRoute(tradeRoute2ID, "water");
		if(placedTradeRoute2 == false)
		rmEchoError("Failed to place trade route 2");
		rmSetObjectDefTradeRouteID(socket2ID, tradeRoute2ID);
		vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.18);
		rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);
		if (cNumberNonGaiaPlayers < 6)
		{
			socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.74);
			rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);
		}
		else
		{
			socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.46);
			rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);
			socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.80);
			rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);
		}
		
		int tradeRoute3ID = rmCreateTradeRoute();
		int socket3ID=rmCreateObjectDef("sockets to dock Trade Posts 3");
		rmAddObjectDefItem(socket3ID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socket3ID, true);
		rmSetObjectDefMinDistance(socket3ID, 0.0);
		rmSetObjectDefMaxDistance(socket3ID, 6.0);

		rmSetObjectDefTradeRouteID(socket3ID, tradeRoute3ID);
		rmAddTradeRouteWaypoint(tradeRoute3ID, 0.04, 0.52);
		rmAddTradeRouteWaypoint(tradeRoute3ID, 0.20, 0.75);
		rmAddTradeRouteWaypoint(tradeRoute3ID, 0.26, 0.95); 
		
		bool placedTradeRoute3 = rmBuildTradeRoute(tradeRoute3ID, "water");
		if(placedTradeRoute3 == false)
		rmEchoError("Failed to place trade route 3");
		rmSetObjectDefTradeRouteID(socket3ID, tradeRoute3ID);
		vector socketLoc3 = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.12);
		rmPlaceObjectDefAtPoint(socket3ID, 0, socketLoc3);
		if (cNumberNonGaiaPlayers < 6)
		{
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.70);
			rmPlaceObjectDefAtPoint(socket3ID, 0, socketLoc3);	
		}
		else
		{
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.42);
			rmPlaceObjectDefAtPoint(socket3ID, 0, socketLoc3);
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.76);
			rmPlaceObjectDefAtPoint(socket3ID, 0, socketLoc3);
		}
	}
	else //FFA
	{
		int tradeRoute4ID = rmCreateTradeRoute();
		int socket4ID =rmCreateObjectDef("sockets to dock Trade Posts 4");
		rmAddObjectDefItem(socket4ID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socket4ID, true);
		rmSetObjectDefMinDistance(socket4ID, 0.0);
		rmSetObjectDefMaxDistance(socket4ID, 8.0);

		rmSetObjectDefTradeRouteID(socket4ID, tradeRoute4ID);
		rmAddTradeRouteWaypoint(tradeRoute4ID, 0.75, 0.65); 
		rmAddTradeRouteWaypoint(tradeRoute4ID, 0.65, 0.50);
		rmAddTradeRouteWaypoint(tradeRoute4ID, 0.50, 0.35);
		rmAddTradeRouteWaypoint(tradeRoute4ID, 0.35, 0.50);
		rmAddTradeRouteWaypoint(tradeRoute4ID, 0.25, 0.65);
		
		bool placedTradeRoute4 = rmBuildTradeRoute(tradeRoute4ID, "water");
		if(placedTradeRoute4 == false)
		rmEchoError("Failed to place trade route");
		rmSetObjectDefTradeRouteID(socket4ID, tradeRoute4ID);
		vector socketLoc4 = rmGetTradeRouteWayPoint(tradeRoute4ID, 0.08);
		if (cNumberNonGaiaPlayers < 6)
		{
			rmPlaceObjectDefAtPoint(socket4ID, 0, socketLoc4);
			socketLoc4 = rmGetTradeRouteWayPoint(tradeRoute4ID, 0.49);
		}	
		else
		{
			rmPlaceObjectDefAtPoint(socket4ID, 0, socketLoc4);
			socketLoc4 = rmGetTradeRouteWayPoint(tradeRoute4ID, 0.28);
			rmPlaceObjectDefAtPoint(socket4ID, 0, socketLoc4);
			socketLoc4 = rmGetTradeRouteWayPoint(tradeRoute4ID, 0.48);
			rmPlaceObjectDefAtPoint(socket4ID, 0, socketLoc4);
			socketLoc4 = rmGetTradeRouteWayPoint(tradeRoute4ID, 0.70);
		}
		rmPlaceObjectDefAtPoint(socket4ID, 0, socketLoc4);
		socketLoc4 = rmGetTradeRouteWayPoint(tradeRoute4ID, 0.92);
		rmPlaceObjectDefAtPoint(socket4ID, 0, socketLoc4);	
	}
	
	// *************************************************************************************************************
		
	// Text
	rmSetStatusText("",0.45);
	
	// ******************************************** NATIVES *************************************************
	
	float Natsplacement = -1;
	Natsplacement = rmRandFloat(0.1,1.0); // > 0.3 horizontal, < 0.3 vertical
//	Natsplacement = 0.2; // <--- TEST
	
	float Natsvariation = -1;
	Natsvariation = rmRandFloat(0.1,1.0); // > 0.5 shaolin (near hill), < 0.5 zen (near coast)
//	Natsvariation = 0.2; // <--- TEST
	
	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
	int nativeID4 = -1;
	int nativeID5 = -1;
	
	if (Natsplacement > 0.3)
	{
		if (Natsvariation > 0.5)
		{
			nativeID0 = rmCreateGrouping("Shaolin temple A", "native shaolin temple mongol 0"+1);
			rmSetGroupingMinDistance(nativeID0, 0.00);
			rmSetGroupingMaxDistance(nativeID0, 0.00);
		//	rmAddGroupingConstraint(nativeID0, avoidImpassableLand);
			rmAddGroupingToClass(nativeID0, rmClassID("natives"));
		//  rmAddGroupingToClass(nativeID0, rmClassID("importantItem"));
		//	rmAddGroupingConstraint(nativeID0, avoidNatives);
			if (TPvariation > 0.5 && TPvariation <= 1.0)
				rmPlaceGroupingAtLoc(nativeID0, 0, 0.40, 0.60);
			else if (TPvariation <= 0.5)
				rmPlaceGroupingAtLoc(nativeID0, 0, 0.40, 0.65);
			else
				rmPlaceGroupingAtLoc(nativeID0, 0, 0.40, 0.70);
			
			nativeID2 = rmCreateGrouping("Shaolin temple B", "native shaolin temple mongol 0"+2);
			rmSetGroupingMinDistance(nativeID2, 0.00);
			rmSetGroupingMaxDistance(nativeID2, 0.00);
		//	rmAddGroupingConstraint(nativeID2, avoidImpassableLand);
			rmAddGroupingToClass(nativeID2, rmClassID("natives"));
		//  rmAddGroupingToClass(nativeID2, rmClassID("importantItem"));
		//	rmAddGroupingConstraint(nativeID2, avoidNatives);
			if (TPvariation > 0.5 && TPvariation <= 1.0)
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.62, 0.60);
			else if (TPvariation <= 0.5)
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.62, 0.65);	
			else
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.62, 0.70);	
		}
		else
		{
			nativeID1 = rmCreateGrouping("Zen temple A", "native zen temple YR 0"+1);
			rmSetGroupingMinDistance(nativeID1, 0.00);
			rmSetGroupingMaxDistance(nativeID1, 0.00);
		//  rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
			rmAddGroupingToClass(nativeID1, rmClassID("natives"));
		//  rmAddGroupingToClass(nativeID1, rmClassID("importantItem"));
		//	rmAddGroupingConstraint(nativeID1, avoidNatives);
			if (TPvariation <= 1.0)
				rmPlaceGroupingAtLoc(nativeID1, 0, 0.42, 0.40); // 
			else
				rmPlaceGroupingAtLoc(nativeID1, 0, 0.42, 0.70); // 

			nativeID3 = rmCreateGrouping("Zen temple B", "native zen temple YR 0"+2);
			rmSetGroupingMinDistance(nativeID3, 0.00);
			rmSetGroupingMaxDistance(nativeID3, 0.00);
		//  rmAddGroupingConstraint(nativeID3, avoidImpassableLand);
			rmAddGroupingToClass(nativeID3, rmClassID("natives"));
		//  rmAddGroupingToClass(nativeID3, rmClassID("importantItem"));
		//	rmAddGroupingConstraint(nativeID3, avoidNatives);
			if (TPvariation <= 1.0)
				rmPlaceGroupingAtLoc(nativeID3, 0, 0.62, 0.40); // 
			else
				rmPlaceGroupingAtLoc(nativeID3, 0, 0.62, 0.70); // 
		}
	}
	else
	{
		nativeID4 = rmCreateGrouping("Shaolin temple C", "native shaolin temple mongol 0"+1);
		rmSetGroupingMinDistance(nativeID4, 0.00);
		rmSetGroupingMaxDistance(nativeID4, 0.00);
	//	rmAddGroupingConstraint(nativeID4, avoidImpassableLand);
		rmAddGroupingToClass(nativeID4, rmClassID("natives"));
	//  rmAddGroupingToClass(nativeID4, rmClassID("importantItem"));
	//	rmAddGroupingConstraint(nativeID4, avoidNatives);
		if (TPvariation > 0.5 && TPvariation <= 1.0)
			rmPlaceGroupingAtLoc(nativeID4, 0, 0.52, 0.60);
		else if (TPvariation <= 0.5)
			rmPlaceGroupingAtLoc(nativeID4, 0, 0.52, 0.65);	
		else 
			rmPlaceGroupingAtLoc(nativeID4, 0, 0.52, 0.70);	
			
		nativeID5 = rmCreateGrouping("Zen temple C", "native zen temple YR 0"+2);
		rmSetGroupingMinDistance(nativeID5, 0.00);
		rmSetGroupingMaxDistance(nativeID5, 0.00);
	//  rmAddGroupingConstraint(nativeID5, avoidImpassableLand);
		rmAddGroupingToClass(nativeID5, rmClassID("natives"));
	//  rmAddGroupingToClass(nativeID5, rmClassID("importantItem"));
	//	rmAddGroupingConstraint(nativeID5, avoidNatives);
		if (TPvariation <= 1.0)
			rmPlaceGroupingAtLoc(nativeID5, 0, 0.52, 0.40); // 
		else
			rmPlaceGroupingAtLoc(nativeID5, 0, 0.52, 0.50); // 
		
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
	int minevariation= -1;
	minevariation = rmRandInt (1,7); // | 1=side+north gold | 2=north gold | 3=middle gold | 4=side+south gold | 5=south gold | 6=side gold | 7=no gold |
//	minevariation = 5; // <--- TEST	
	
	int playergoldID = rmCreateObjectDef("player mine");
	if (minevariation == 7)
		rmAddObjectDefItem(playergoldID, "Minegold", 1, 0);
	else
		rmAddObjectDefItem(playergoldID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 15.0);
	rmSetObjectDefMaxDistance(playergoldID, 16.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
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
	rmSetObjectDefMinDistance(playergold3ID, 56.0); //58
	rmSetObjectDefMaxDistance(playergold3ID, 60.0); //62
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
	rmAddObjectDefItem(playerTreeID, "ypTreeMongolianFir", rmRandInt(6,6), 5.0);
    rmSetObjectDefMinDistance(playerTreeID, 12);
    rmSetObjectDefMaxDistance(playerTreeID, 16);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	
	// Starting herd
	int playeherdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playeherdID, "ypMarcoPoloSheep", rmRandInt(5,5), 3.0);
	rmSetObjectDefMinDistance(playeherdID, 14.0);
	rmSetObjectDefMaxDistance(playeherdID, 18.0);
	rmSetObjectDefCreateHerd(playeherdID, false);
	rmAddObjectDefToClass(playeherdID, classStartingResource);
	rmAddObjectDefConstraint(playeherdID, avoidTradeRoute);
	rmAddObjectDefConstraint(playeherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(playeherdID, avoidNatives);
	rmAddObjectDefConstraint(playeherdID, avoidStartingResources);
		
	// 2nd herd
	int player2ndherdID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(player2ndherdID, "ypSaiga", rmRandInt(10,10), 7.0);
    rmSetObjectDefMinDistance(player2ndherdID, 28);
    rmSetObjectDefMaxDistance(player2ndherdID, 30);
	rmAddObjectDefToClass(player2ndherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player2ndherdID, true);
	rmAddObjectDefConstraint(player2ndherdID, avoidStartingResources);
	rmAddObjectDefConstraint(player2ndherdID, avoidSheepShort); 
//	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(player2ndherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(player2ndherdID, avoidEdge);
	rmAddObjectDefConstraint(player2ndherdID, avoidNatives);
		
/*	// 3rd herd
	int player3rdherdID = rmCreateObjectDef("player 3rd herd");
	rmAddObjectDefItem(player3rdherdID, "ypSaiga", rmRandInt(7,7), 6.0);
    rmSetObjectDefMinDistance(player3rdherdID, 48);
    rmSetObjectDefMaxDistance(player3rdherdID, 50);
	rmAddObjectDefToClass(player3rdherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player3rdherdID, true);
	rmAddObjectDefConstraint(player3rdherdID, avoidStartingResources);
	rmAddObjectDefConstraint(player3rdherdID, avoidGoldType);
	rmAddObjectDefConstraint(player3rdherdID, avoidCaribou);
//	rmAddObjectDefConstraint(player3rdherdID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(player3rdherdID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(player3rdherdID, avoidImpassableLandFar);
	rmAddObjectDefConstraint(player3rdherdID, avoidNativesFar);
	rmAddObjectDefConstraint(player3rdherdID, avoidEdge);
	rmAddObjectDefConstraint(player3rdherdID, avoidCenter);
*/	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 26.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget); //Short
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	int nugget0count = rmRandInt (1,2); // 1,2
	
	int colonyShipID = 0;
	for(i=1; < cNumberPlayers)
	{
		colonyShipID=rmCreateObjectDef("colony ship "+i);
	 	rmAddObjectDefItem(colonyShipID, "HomeCityWaterSpawnFlag", 1, 1.0);
		rmSetObjectDefMinDistance(colonyShipID, 0.0);
		rmSetObjectDefMaxDistance(colonyShipID, rmXFractionToMeters(0.20));
		rmAddObjectDefConstraint(colonyShipID, avoidColonyShip);
		rmAddObjectDefConstraint(colonyShipID, avoidLandFar);
		rmAddObjectDefConstraint(colonyShipID, avoidEdgeMore);
      	rmPlaceObjectDefAtLoc(colonyShipID, i, 0.50, 0.10);
	}   
		
	// ******** Place ********
	
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if (minevariation != 7)
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playergold3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playeherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(player2ndherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(player3rdherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

//		if (nugget0count == 2)
//			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
				
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			
//		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
//		rmPlaceObjectDefAtLoc(colonyShipID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));

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
/*		
	int goldswitch = -1;	
	goldswitch = rmRandInt (1,2);
	if (goldswitch == 1)
		minevariation = 3;
	else
		minevariation = 6;	
*/	
	int sidegoldcount = 1*cNumberNonGaiaPlayers;  
	if (minevariation == 1 || minevariation == 4 || minevariation == 6)
		sidegoldcount = 1*cNumberTeams; 
		
	int northgoldcount = 1+0.35*cNumberNonGaiaPlayers;
	int southgoldcount = 1+0.35*cNumberNonGaiaPlayers;
	if (minevariation == 7)
	{
		northgoldcount = 1*cNumberNonGaiaPlayers;
		southgoldcount = 1*cNumberNonGaiaPlayers;
	}
	
	// South mines
	for(i=0; < southgoldcount)
	{
		int southgoldID = rmCreateObjectDef("south mines"+i);
		if (minevariation >= 3 && minevariation < 6)
			rmAddObjectDefItem(southgoldID, "Minegold", 1, 0.0);
		else
			rmAddObjectDefItem(southgoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(southgoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(southgoldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(southgoldID, classGold);
		rmAddObjectDefConstraint(southgoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(southgoldID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(southgoldID, avoidNatives);
		rmAddObjectDefConstraint(southgoldID, avoidTradeRouteSocket);
		if (minevariation == 7)
			rmAddObjectDefConstraint(southgoldID, avoidGoldMed);
		else
			rmAddObjectDefConstraint(southgoldID, avoidGoldVeryFar);
		rmAddObjectDefConstraint(southgoldID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(southgoldID, avoidEdge);
		rmAddObjectDefConstraint(southgoldID, stayMiddle);	
		rmAddObjectDefConstraint(southgoldID, staySE);	
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(southgoldID, avoidHill);
		rmPlaceObjectDefAtLoc(southgoldID, 0, 0.50, 0.50);
	}
	
	// North mines
	for(i=0; < northgoldcount)
	{
		int northgoldID = rmCreateObjectDef("north mines"+i);
		if (minevariation <= 3)
			rmAddObjectDefItem(northgoldID, "Minegold", 1, 0.0);
		else
			rmAddObjectDefItem(northgoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(northgoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(northgoldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(northgoldID, classGold);
		rmAddObjectDefConstraint(northgoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(northgoldID, avoidImpassableLandMed);
		rmAddObjectDefConstraint(northgoldID, avoidNatives);
		rmAddObjectDefConstraint(northgoldID, avoidTradeRouteSocket);
		if (minevariation == 7)
			rmAddObjectDefConstraint(northgoldID, avoidGoldMed);
		else
			rmAddObjectDefConstraint(northgoldID, avoidGoldVeryFar);
		rmAddObjectDefConstraint(northgoldID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(northgoldID, avoidEdge);
		rmAddObjectDefConstraint(northgoldID, stayMiddle);	
		rmAddObjectDefConstraint(northgoldID, stayNW);		
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(northgoldID, avoidHill);
		rmPlaceObjectDefAtLoc(northgoldID, 0, 0.50, 0.50);
	}
	
	// Side mines
	for(i=1; < sidegoldcount+1)
	{
		int sidegoldID = rmCreateObjectDef("side mines"+i);
		if (minevariation == 1 || minevariation == 4 || minevariation == 6)
			rmAddObjectDefItem(sidegoldID, "Minegold", 1, 0.0);
		else
			rmAddObjectDefItem(sidegoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(sidegoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(sidegoldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(sidegoldID, classGold);
		rmAddObjectDefConstraint(sidegoldID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(sidegoldID, avoidImpassableLandMed);
		rmAddObjectDefConstraint(sidegoldID, avoidNatives);
		rmAddObjectDefConstraint(sidegoldID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(sidegoldID, avoidGoldFar);
		rmAddObjectDefConstraint(sidegoldID, avoidTownCenterFar);
		rmAddObjectDefConstraint(sidegoldID, avoidEdge);
		rmAddObjectDefConstraint(sidegoldID, stayNW);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(sidegoldID, avoidHill);
		if (i%2 == 1.00)
			rmAddObjectDefConstraint(sidegoldID, staySW);
		else
			rmAddObjectDefConstraint(sidegoldID, stayNE);
		if (cNumberNonGaiaPlayers <= 2)
		{
			if (i%2 == 1.00)
				rmAddObjectDefConstraint(sidegoldID, Wcorner);
			else
				rmAddObjectDefConstraint(sidegoldID, Ncorner);
		}
		rmPlaceObjectDefAtLoc(sidegoldID, 0, 0.50, 0.65);
	}
	
	
		
	// *********************************
	
	// Text
	rmSetStatusText("",0.70);
	
	// ************ Forest *************
	
	// Lowground forest
	int forestlowcount = 6*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 4)
		forestlowcount = 5*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 6)
		forestlowcount = 4*cNumberNonGaiaPlayers;
		
	int stayInForestLowPatch = -1;
	
	for (i=0; < forestlowcount)
	{
		int forestlowID = rmCreateArea("forest lowground "+i);
		rmSetAreaWarnFailure(forestlowID, false);
		rmSetAreaSize(forestlowID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(140));
		rmSetAreaTerrainType(forestlowID, "mongolia\ground_forest_mongol");
		rmSetAreaMix(forestlowID, "mongolia_forest");
		rmSetAreaObeyWorldCircleConstraint(forestlowID, false);
//		rmSetAreaForestDensity(forestlowID, 0.8);
//		rmSetAreaForestClumpiness(forestlowID, 0.15);
//		rmSetAreaForestUnderbrush(forestlowID, 0.2);
		rmSetAreaMinBlobs(forestlowID, 2);
		rmSetAreaMaxBlobs(forestlowID, 4);
		rmSetAreaMinBlobDistance(forestlowID, 14.0);
		rmSetAreaMaxBlobDistance(forestlowID, 30.0);
		rmSetAreaCoherence(forestlowID, 0.65);
		rmSetAreaSmoothDistance(forestlowID, 6);
		rmAddAreaToClass(forestlowID, classForest);
		rmAddAreaConstraint(forestlowID, avoidForest);
		rmAddAreaConstraint(forestlowID, avoidGoldMin);
		rmAddAreaConstraint(forestlowID, avoidSerowMin); 
		rmAddAreaConstraint(forestlowID, avoidSheepMin); 
		rmAddAreaConstraint(forestlowID, avoidTownCenterShort); 
		rmAddAreaConstraint(forestlowID, avoidNatives);
		rmAddAreaConstraint(forestlowID, avoidTradeRouteShort);
		rmAddAreaConstraint(forestlowID, avoidTradeRouteSocket);
		rmAddAreaConstraint(forestlowID, avoidImpassableLandShort);
		rmAddAreaConstraint(forestlowID, avoidHighground);
		if (cNumberTeams <= 2)
			rmAddAreaConstraint(forestlowID, avoidHill);
//		rmAddAreaConstraint(forestlowID, avoidEdge);
		rmBuildArea(forestlowID);
		
		stayInForestLowPatch = rmCreateAreaMaxDistanceConstraint("stay in forest low patch"+i, forestlowID, 0.0);
		
		for (j=0; < rmRandInt(15,17))
		{
			int forestlowtreeID = rmCreateObjectDef("forest lowground trees"+i+" "+j);
			rmAddObjectDefItem(forestlowtreeID, "ypTreeMongolianFir", rmRandInt(1,3), 3.0);
			rmSetObjectDefMinDistance(forestlowtreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(forestlowtreeID,  rmXFractionToMeters(0.5));
		//	rmAddObjectDefToClass(forestlowtreeID, classForest);
		//	rmAddObjectDefConstraint(forestlowtreeID, avoidForestShort);
			rmAddObjectDefConstraint(forestlowtreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(forestlowtreeID, stayInForestLowPatch);	
			rmPlaceObjectDefAtLoc(forestlowtreeID, 0, 0.50, 0.50);
		}
	}

	// Highground forest
	int foresthighcount = 2*cNumberNonGaiaPlayers;
	
	int stayInForestHighPatch = -1;
	
	for (i=0; < foresthighcount)
	{
		int foresthighID = rmCreateArea("forest highground "+i);
		rmSetAreaWarnFailure(foresthighID, false);
		rmSetAreaSize(foresthighID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(140));
		rmSetAreaTerrainType(foresthighID, "mongolia\ground_forest_mongol");
		rmSetAreaMix(foresthighID, "mongolia_forest");
		rmSetAreaObeyWorldCircleConstraint(foresthighID, false);
//		rmSetAreaForestDensity(foresthighID, 0.8);
//		rmSetAreaForestClumpiness(foresthighID, 0.15);
//		rmSetAreaForestUnderbrush(foresthighID, 0.2);
		rmSetAreaMinBlobs(foresthighID, 2);
		rmSetAreaMaxBlobs(foresthighID, 4);
		rmSetAreaMinBlobDistance(foresthighID, 12.0);
		rmSetAreaMaxBlobDistance(foresthighID, 30.0);
		rmSetAreaCoherence(foresthighID, 0.65);
		rmSetAreaSmoothDistance(foresthighID, 6);
		rmAddAreaToClass(foresthighID, classForest);
		rmAddAreaConstraint(foresthighID, avoidForestShort);
		rmAddAreaConstraint(foresthighID, avoidGoldMin);
		rmAddAreaConstraint(foresthighID, avoidSerowMin); 
		rmAddAreaConstraint(foresthighID, avoidSheepMin); 
		rmAddAreaConstraint(foresthighID, avoidTownCenterShort); 
		rmAddAreaConstraint(foresthighID, avoidNatives);
		rmAddAreaConstraint(foresthighID, avoidTradeRouteShort);
		rmAddAreaConstraint(foresthighID, avoidTradeRouteSocket);
		rmAddAreaConstraint(foresthighID, avoidImpassableLandShort);
		rmAddAreaConstraint(foresthighID, avoidLowground);
		if (cNumberTeams <= 2)
			rmAddAreaConstraint(foresthighID, avoidHill);
//		rmAddAreaConstraint(foresthighID, avoidEdge);
		rmBuildArea(foresthighID);
		
		stayInForestHighPatch = rmCreateAreaMaxDistanceConstraint("stay in forest high patch"+i, foresthighID, 0.0);
		
		for (j=0; < rmRandInt(14,16))
		{
			int foresthightreeID = rmCreateObjectDef("forest highground trees"+i+j);
			rmAddObjectDefItem(foresthightreeID, "ypTreeMongolia", rmRandInt(1,2), 2.0);
			rmSetObjectDefMinDistance(foresthightreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(foresthightreeID,  rmXFractionToMeters(0.5));
		//	rmAddObjectDefToClass(foresthightreeID, classForest);
		//	rmAddObjectDefConstraint(foresthightreeID, avoidForestShort);
			rmAddObjectDefConstraint(foresthightreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(foresthightreeID, stayInForestHighPatch);	
			rmPlaceObjectDefAtLoc(foresthightreeID, 0, 0.50, 0.50);
		}
	}
	
		// Random trees in the lowground
	int treelowcount = 4*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 4)
		treelowcount = 3*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 6)
		treelowcount = 2.5*cNumberNonGaiaPlayers;

	for (i=0; < treelowcount)
	{
		int randomlowtreeID = rmCreateObjectDef("random trees low ground "+i);
		rmAddObjectDefItem(randomlowtreeID, "ypTreeMongolianFir", rmRandInt(3,6), 5.0);
		rmSetObjectDefMinDistance(randomlowtreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(randomlowtreeID,  rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(randomlowtreeID, classForest);
		rmAddObjectDefConstraint(randomlowtreeID, avoidForestShort);
		rmAddObjectDefConstraint(randomlowtreeID, avoidGoldMin);
		rmAddObjectDefConstraint(randomlowtreeID, avoidSerowMin); 
		rmAddObjectDefConstraint(randomlowtreeID, avoidSheepMin); 
		rmAddObjectDefConstraint(randomlowtreeID, avoidTownCenterShort); 
		rmAddObjectDefConstraint(randomlowtreeID, avoidNatives);
		rmAddObjectDefConstraint(randomlowtreeID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(randomlowtreeID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(randomlowtreeID, avoidImpassableLand);
		rmAddObjectDefConstraint(randomlowtreeID, avoidHighground);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(randomlowtreeID, avoidHill);
		rmAddObjectDefConstraint(randomlowtreeID, avoidStartingResources);
		rmPlaceObjectDefAtLoc(randomlowtreeID, 0, 0.50, 0.50);
	}
	
	// Random trees in the highground
		int treehighcount = 2+4*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 4)
		treehighcount = 3*cNumberNonGaiaPlayers;
	if (cNumberNonGaiaPlayers >= 6)
		treehighcount = 2.5*cNumberNonGaiaPlayers;
	
	for (i=0; < treehighcount)
	{
		int randomhightreeID = rmCreateObjectDef("random trees highground "+i);
		rmAddObjectDefItem(randomhightreeID, "ypTreeSaxaul", rmRandInt(3,6), 5.0);
		rmSetObjectDefMinDistance(randomhightreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(randomhightreeID,  rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(randomhightreeID, classForest);
		rmAddObjectDefConstraint(randomhightreeID, avoidForestShort);
		rmAddObjectDefConstraint(randomhightreeID, avoidGoldMin);
		rmAddObjectDefConstraint(randomhightreeID, avoidSerowMin); 
		rmAddObjectDefConstraint(randomhightreeID, avoidSheepMin); 
		rmAddObjectDefConstraint(randomhightreeID, avoidTownCenterShort); 
		rmAddObjectDefConstraint(randomhightreeID, avoidNatives);
		rmAddObjectDefConstraint(randomhightreeID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(randomhightreeID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(randomhightreeID, avoidImpassableLand);
		rmAddObjectDefConstraint(randomhightreeID, avoidLowground);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(randomhightreeID, avoidHill);
		rmAddObjectDefConstraint(randomhightreeID, avoidStartingResources);
		rmPlaceObjectDefAtLoc(randomhightreeID, 0, 0.50, 0.50);
	}
	
	// ********************************
	
	// Text
	rmSetStatusText("",0.80);
	
	// ************ Herds *************
	
	int lowgroundherdcount = 3.5*cNumberNonGaiaPlayers;
	int highgroundherdcount = 1+cNumberNonGaiaPlayers;
	
		
	//Lowground herds
	for (i=0; < lowgroundherdcount)
	{
		int lowgroundherdID = rmCreateObjectDef("lowground herd"+i);
		rmAddObjectDefItem(lowgroundherdID, "ypSaiga", rmRandInt(6,7), 7.0);
		rmSetObjectDefMinDistance(lowgroundherdID, 0.0);
		rmSetObjectDefMaxDistance(lowgroundherdID, rmXFractionToMeters(0.6));
		rmSetObjectDefCreateHerd(lowgroundherdID, true);
		rmAddObjectDefConstraint(lowgroundherdID, avoidForestMin);
		rmAddObjectDefConstraint(lowgroundherdID, avoidGoldShort);
		rmAddObjectDefConstraint(lowgroundherdID, avoidSerowFar); 
		rmAddObjectDefConstraint(lowgroundherdID, avoidSheepFar); 
		rmAddObjectDefConstraint(lowgroundherdID, avoidTownCenter); 
		rmAddObjectDefConstraint(lowgroundherdID, avoidNatives);
//		rmAddObjectDefConstraint(lowgroundherdID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(lowgroundherdID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(lowgroundherdID, avoidImpassableLand);
		rmAddObjectDefConstraint(lowgroundherdID, avoidHighground);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(lowgroundherdID, avoidHill);
		rmAddObjectDefConstraint(lowgroundherdID, avoidEdge);
		if (i < 1)
			rmAddObjectDefConstraint(lowgroundherdID, staySW);
		else if (i < 2)
			rmAddObjectDefConstraint(lowgroundherdID, stayNE);
		rmPlaceObjectDefAtLoc(lowgroundherdID, 0, 0.50, 0.50);	
	}
	
	//Highground herds
	for (i=0; < highgroundherdcount)
	{
		int highgroundherdID = rmCreateObjectDef("highground herd"+i);
		rmAddObjectDefItem(highgroundherdID, "ypMuskdeer", rmRandInt(7,8), 7.0);
		rmSetObjectDefMinDistance(highgroundherdID, 0.0);
		rmSetObjectDefMaxDistance(highgroundherdID, rmXFractionToMeters(0.6));
		rmSetObjectDefCreateHerd(highgroundherdID, true);
		rmAddObjectDefConstraint(highgroundherdID, avoidForestMin);
		rmAddObjectDefConstraint(highgroundherdID, avoidGoldShort);
		rmAddObjectDefConstraint(highgroundherdID, avoidSerow); 
		rmAddObjectDefConstraint(highgroundherdID, avoidMuskdeerFar);  
		rmAddObjectDefConstraint(highgroundherdID, avoidNatives);
		rmAddObjectDefConstraint(highgroundherdID, avoidTownCenterMed); 
//		rmAddObjectDefConstraint(highgroundherdID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(highgroundherdID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(highgroundherdID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(highgroundherdID, avoidLowground);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(highgroundherdID, avoidHill);
		rmAddObjectDefConstraint(highgroundherdID, avoidEdge);
//		if (i < 1)
//			rmAddObjectDefConstraint(highgroundherdID, staySW);
//		else if (i < 2)
//			rmAddObjectDefConstraint(highgroundherdID, stayNE);
		rmPlaceObjectDefAtLoc(highgroundherdID, 0, 0.50, 0.50);	
	}
	
	// ************************************
	
	// Text
	rmSetStatusText("",0.90);
		
	// ************** Treasures ***************
	
	int treasure1count = 4+0.5*cNumberNonGaiaPlayers;
	int treasure2count = 4+0.5*cNumberNonGaiaPlayers;
	int treasure3count = 1+0.5*cNumberNonGaiaPlayers;
	int treasure4count = 0.5*cNumberNonGaiaPlayers;
	
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
		rmAddObjectDefConstraint(Nugget4ID, avoidSerowMin); 
		rmAddObjectDefConstraint(Nugget4ID, avoidMuskdeerMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget4ID, avoidEdge);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(Nugget4ID, avoidHill);
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
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidSerowMin); 
		rmAddObjectDefConstraint(Nugget3ID, avoidMuskdeerMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget3ID, avoidEdge);
		rmAddObjectDefConstraint(Nugget3ID, stayMiddle);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(Nugget3ID, avoidHill);
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
		rmAddObjectDefConstraint(Nugget2ID, avoidSerowMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidMuskdeerMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget2ID, avoidSeaMed);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(Nugget2ID, avoidHill);
		if (i < 2)
			rmAddObjectDefConstraint(Nugget2ID, staySouthHalf); 
		else if (i < 4)
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
		rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget1ID, avoidSerowMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidMuskdeerMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge);
		rmAddObjectDefConstraint(Nugget1ID, avoidSeaMed);
		if (cNumberTeams <= 2)
			rmAddObjectDefConstraint(Nugget1ID, avoidHill);
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);
	}
	
	// ****************************************
	
	// Text
	rmSetStatusText("",0.95);
	
	// **************** Yaks *****************
	
	int yaksCount = 1+4*cNumberNonGaiaPlayers;
	
	for (i=0; < yaksCount)
	{
		int yakID=rmCreateObjectDef("yak"+i);
		if (i < 1+cNumberNonGaiaPlayers)
			rmAddObjectDefItem(yakID, "ypyak", 2, 4.0);
		else
			rmAddObjectDefItem(yakID, "ypyak", 1, 1.0);
		rmSetObjectDefMinDistance(yakID, 0.0);
		rmSetObjectDefMaxDistance(yakID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(yakID, avoidYak);
		rmAddObjectDefConstraint(yakID, avoidNatives);
		rmAddObjectDefConstraint(yakID, avoidTradeRouteSocket);
		if (i < 1+cNumberNonGaiaPlayers)
			rmAddObjectDefConstraint(yakID, avoidImpassableLandShort);
		else
			rmAddObjectDefConstraint(yakID, avoidImpassableLandMed);
		rmAddObjectDefConstraint(yakID, avoidGoldMin);
		rmAddObjectDefConstraint(yakID, avoidTownCenter);
		rmAddObjectDefConstraint(yakID, avoidSerowMin); 
		rmAddObjectDefConstraint(yakID, avoidMuskdeerMin);
		rmAddObjectDefConstraint(yakID, avoidForestMin);
		rmAddObjectDefConstraint(yakID, avoidNuggetShort);
		rmAddObjectDefConstraint(yakID, avoidEdge); 
			if (cNumberTeams <= 2)
		rmAddObjectDefConstraint(yakID, avoidHill);
		
		if (i < 1+cNumberNonGaiaPlayers)
			rmAddObjectDefConstraint(yakID, stayMiddle); // avoidLowgroundFar
//		else
//			rmAddObjectDefConstraint(yakID, avoidHighground); // avoidHighground
		rmPlaceObjectDefAtLoc(yakID, 0, 0.50, 0.50);
	}
	// ****************************************
	
	// ************ Sea resources *************
	
	int fishcount = -1;
	fishcount = 4+4*cNumberNonGaiaPlayers;
	int whalecount = 3+cNumberNonGaiaPlayers;
	
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
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.50, 0.10);
	
	}
	
	//Fish
	for (i=0; < fishcount)
	{
		int fishID = rmCreateObjectDef("fish"+i);
		rmAddObjectDefItem(fishID, "ypFishTuna", rmRandInt(2,2), 8.0);
		rmSetObjectDefMinDistance(fishID, 0.0);
		rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.49));
		rmAddObjectDefConstraint(fishID, avoidFish);
		rmAddObjectDefConstraint(fishID, avoidLand);
		rmAddObjectDefConstraint(fishID, avoidColonyShip);
		rmAddObjectDefConstraint(fishID, avoidEdge);
		rmPlaceObjectDefAtLoc(fishID, 0, 0.50, 0.15);
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

	// ****************************************
	
	// Text
	rmSetStatusText("", 1.00);


	
} //END