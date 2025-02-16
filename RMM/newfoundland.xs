// By AOE_Fan aka Aoe3_Badger
// RM script for VANILLA (Original) AOE3
// Ask permission to use this map in your own mods/maps! (PM to AOE_Fan in http://knightsandbarbarians.heavenforum.org/forum)

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
   // Text
   // Make the loading bar move
   rmSetStatusText("",0.01);


   // Picks the map size
   int playerTiles = 16000;
   if (cNumberNonGaiaPlayers == 2)
      playerTiles = 16000;
   if (cNumberNonGaiaPlayers >4)
      playerTiles = 14000;
   if (cNumberNonGaiaPlayers >6)
      playerTiles = 12000;		

   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);
	
   // Set map smoothness
   rmSetMapElevationHeightBlend(1);
	

   // Picks a default water height
   rmSetSeaLevel(0.0);

   
   // Chooses summer or winter 
   float seasonPicker = rmRandFloat(0,1); // 0 = summer, 1 = winter


   // The sea can be either frozen or unfrozen at winter
   float seaState = rmRandFloat(0,1); // 0 = unfrozen, 1 = frozen


   // Sets a float depending what "style" sea is - used when placing resources (for simplicity) to avoid sea if unfrozen or allow them to be placed over sea if frozen

   // If WINTER AND seaState OVER 0.75 - frozen (walkable) sea
   if (seasonPicker >= 0.5 && seaState >= 0.75)
      float seaWinterIce = rmRandFloat(1,1);

   // If WINTER and seaState UNDER 0.75 - winter-style sea
   if (seasonPicker >= 0.5 && seaState < 0.75)
      float seaWinterWater = rmRandFloat(2,2);

   // If SUMMER - normal water
   if (seasonPicker < 0.5)
      float seaSummerWater = rmRandFloat(3,3);
   

   // Chooses the side (east/west) where the water is, i.e. all water moves to other side (mirror image)
   float waterSide = rmRandFloat(0,1);


   // If number of players is 2,3,5 or 7, chooses the side or place where the "odd" player (3rd, 5th or 7th) starts (bad explanation, isn't it?).
   float playerPlace = rmRandFloat(0,1);


   // Lighting
   if (seasonPicker < 0.5)
      rmSetLightingSet("Great Lakes");
   else
      rmSetLightingSet("yukon");


   // Picks default terrain - summer/winter
   if (seasonPicker < 0.5)
   {
      rmSetMapElevationParameters(cElevTurbulence, 0.05, 4, 0.7, 4.0);
      rmSetSeaType("great lakes");
      rmEnableLocalWater(false);
      rmSetBaseTerrainMix("rockies_grass");
      rmTerrainInitialize("rockies\ground4_roc", 1.0);
      rmSetMapType("greatlakes");
      rmSetMapType("grass");
      rmSetMapType("water");
      rmSetMapType("namerica");
      rmSetMapType("AIFishingUseful");
   }
   else
   {
      rmSetMapElevationParameters(cElevTurbulence, 0.05, 4, 0.7, 4.0);
      rmSetSeaType("new england coast");
      rmEnableLocalWater(false);
      rmSetBaseTerrainMix("rockies_snow");
      rmTerrainInitialize("rockies\groundsnow1_roc", 1.0);
      rmSetMapType("yukon");
      rmSetMapType("snow");
      rmSetMapType("water");
      rmSetMapType("namerica");
      rmSetGlobalSnow( 1.0 );
   }

   chooseMercs();


   // Corner constraint.
   rmSetWorldCircleConstraint(true);

   // Define classes. These are used for constraints
   int classPlayer=rmDefineClass("player");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
   rmDefineClass("nuggets");
   rmDefineClass("center");
   int classLakes=rmDefineClass("lakes");
   int classSea=rmDefineClass("sea");
   int classAnimals=rmDefineClass("animals");

   // Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0- rmZTilesToFraction (10), 0.01);
   int longPlayerEdgeConstraint=rmCreateBoxConstraint("long avoid edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0- rmZTilesToFraction(20), 0.01);

   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // Cardinal Directions
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

   // Player constraints
   int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 20.0);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 70.0);  
   int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 40.0);  
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 45.0);
   int shortPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players short", classPlayer, 20.0);

   // Nature avoidance
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 40.0);
   int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 20.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 55.0);
   int shortAvoidCoin=rmCreateTypeDistanceConstraint("short avoid coin", "Mine", 10.0);
   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 10.0);

   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);

   // Unit and animal avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 45.0);
   int shortAvoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units short", rmClassID("startingUnit"), 10.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 10.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 30.0);
   int avoidNuggets=rmCreateClassDistanceConstraint("stuff avoids nuggets", rmClassID("nuggets"), 60.0);
   int animalConstraint=rmCreateClassDistanceConstraint("avoid all animals", classAnimals, 30.0);
   int avoidCow=rmCreateTypeDistanceConstraint("cow avoids cow", "cow", 40.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // Water objects avoidance
   int lakesConstraint=rmCreateClassDistanceConstraint("avoid the lakes", classLakes, 5.0);
   int farLakesConstraint=rmCreateClassDistanceConstraint("far avoid the lakes", classLakes, 20.0);
   int seaConstraint=rmCreateClassDistanceConstraint("avoid sea", classSea, 7.0);
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
   int HCspawnLand = rmCreateTerrainDistanceConstraint("flag away from land", "land", true, 12.0);
   int flagEdgeConstraint = rmCreatePieConstraint("flags away from edge of map", 0.5, 0.5, rmGetMapXSize()-100, rmGetMapXSize()-50, 0, 0, 0);
   int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid flag", "HomeCityWaterSpawnFlag", 30.0);


   // Text
   rmSetStatusText("",0.10);


   // Define and place 7 lakes, summer/frozen
        
   // Lake 1
   int lake1ID=rmCreateArea("Lake 1");
   if (seasonPicker < 0.5)
      rmSetAreaWaterType(lake1ID, "Yukon Water");
   else
      rmSetAreaTerrainType(lake1ID, "great_lakes\ground_ice1_gl");
   rmSetAreaSize(lake1ID, 0.008, 0.008);
   rmSetAreaCoherence(lake1ID, 0.6);
   rmSetAreaLocation(lake1ID, 0.55, 0.35);
   rmAddAreaToClass(lake1ID, classLakes);
   rmSetAreaBaseHeight(lake1ID, -1.0);
   rmSetAreaObeyWorldCircleConstraint(lake1ID, false);
   rmSetAreaMinBlobs(lake1ID, 5);
   rmSetAreaMaxBlobs(lake1ID, 12);
   rmSetAreaMinBlobDistance(lake1ID, 3);
   rmSetAreaMaxBlobDistance(lake1ID, 12);
   rmSetAreaSmoothDistance(lake1ID, 2);
   rmBuildArea(lake1ID);

   // Lake 2
   int lake2ID=rmCreateArea("Lake 2");
   if (seasonPicker < 0.5)
      rmSetAreaWaterType(lake2ID, "Yukon Water");
   else
      rmSetAreaTerrainType(lake2ID, "great_lakes\ground_ice1_gl");
   rmSetAreaSize(lake2ID, 0.008, 0.008);
   rmSetAreaCoherence(lake2ID, 0.6);
   rmSetAreaLocation(lake2ID, 0.35, 0.55);
   rmAddAreaToClass(lake2ID, classLakes);
   rmSetAreaBaseHeight(lake2ID, -1.0);
   rmSetAreaObeyWorldCircleConstraint(lake2ID, false);
   rmSetAreaMinBlobs(lake2ID, 5);
   rmSetAreaMaxBlobs(lake2ID, 12);
   rmSetAreaMinBlobDistance(lake2ID, 3);
   rmSetAreaMaxBlobDistance(lake2ID, 12);
   rmSetAreaSmoothDistance(lake2ID, 2);
   rmBuildArea(lake2ID);

   // Lake 3
   int lake3ID=rmCreateArea("Lake 3");
   if (seasonPicker < 0.5)
      rmSetAreaWaterType(lake3ID, "Yukon Water");
   else
      rmSetAreaTerrainType(lake3ID, "great_lakes\ground_ice1_gl");
   rmSetAreaSize(lake3ID, 0.008, 0.008);
   rmSetAreaCoherence(lake3ID, 0.6);
   rmSetAreaLocation(lake3ID, 0.65, 0.65);
   rmAddAreaToClass(lake3ID, classLakes);
   rmSetAreaBaseHeight(lake3ID, 0.0);
   rmSetAreaObeyWorldCircleConstraint(lake3ID, false);
   rmSetAreaMinBlobs(lake3ID, 5);
   rmSetAreaMaxBlobs(lake3ID, 12);
   rmSetAreaMinBlobDistance(lake3ID, 3);
   rmSetAreaMaxBlobDistance(lake3ID, 12);
   rmSetAreaSmoothDistance(lake3ID, 2);
   rmBuildArea(lake3ID);


   // Text
   rmSetStatusText("",0.20);


   // Lake 4
   int lake4ID=rmCreateArea("Lake 4");
   if (seasonPicker < 0.5)
      rmSetAreaWaterType(lake4ID, "Yukon Water");
   else
      rmSetAreaTerrainType(lake4ID, "great_lakes\ground_ice1_gl");
   rmSetAreaSize(lake4ID, 0.008, 0.008);
   rmSetAreaCoherence(lake4ID, 0.6);
   rmSetAreaLocation(lake4ID, 0.35, 0.35);
   rmAddAreaToClass(lake4ID, classLakes);
   rmSetAreaBaseHeight(lake4ID, 0.0);
   rmSetAreaObeyWorldCircleConstraint(lake4ID, false);
   rmSetAreaMinBlobs(lake4ID, 5);
   rmSetAreaMaxBlobs(lake4ID, 12);
   rmSetAreaMinBlobDistance(lake4ID, 3);
   rmSetAreaMaxBlobDistance(lake4ID, 12);
   rmSetAreaSmoothDistance(lake4ID, 2);
   rmBuildArea(lake4ID);

   // Lake 5
   int lake5ID=rmCreateArea("Lake 5");
   if (seasonPicker < 0.5)
      rmSetAreaWaterType(lake5ID, "Yukon Water");
   else
      rmSetAreaTerrainType(lake5ID, "great_lakes\ground_ice1_gl");
   rmSetAreaSize(lake5ID, 0.008, 0.008);
   rmSetAreaCoherence(lake5ID, 0.6);
   if (waterSide < 0.5)
      rmSetAreaLocation(lake5ID, 0.1, 0.4);
   else
      rmSetAreaLocation(lake5ID, 0.4, 0.1);
   rmAddAreaToClass(lake5ID, classLakes);
   rmSetAreaBaseHeight(lake5ID, 0.0);
   rmSetAreaObeyWorldCircleConstraint(lake5ID, false);
   rmSetAreaMinBlobs(lake5ID, 5);
   rmSetAreaMaxBlobs(lake5ID, 12);
   rmSetAreaMinBlobDistance(lake5ID, 3);
   rmSetAreaMaxBlobDistance(lake5ID, 12);
   rmSetAreaSmoothDistance(lake5ID, 2);
   rmBuildArea(lake5ID);


   // Lake 6
   int lake6ID=rmCreateArea("Lake 6");
   if (seasonPicker < 0.5)
      rmSetAreaWaterType(lake6ID, "Yukon Water");
   else
      rmSetAreaTerrainType(lake6ID, "great_lakes\ground_ice1_gl");
   rmSetAreaSize(lake6ID, 0.008, 0.008);
   rmSetAreaCoherence(lake6ID, 0.6);
   if (waterSide < 0.5)
      rmSetAreaLocation(lake6ID, 0.9, 0.6);
   else
      rmSetAreaLocation(lake6ID, 0.6, 0.9);
   rmAddAreaToClass(lake6ID, classLakes);
   rmSetAreaBaseHeight(lake6ID, -1.0);
   rmSetAreaObeyWorldCircleConstraint(lake6ID, false);
   rmSetAreaMinBlobs(lake6ID, 5);
   rmSetAreaMaxBlobs(lake6ID, 12);
   rmSetAreaMinBlobDistance(lake6ID, 3);
   rmSetAreaMaxBlobDistance(lake6ID, 12);
   rmSetAreaSmoothDistance(lake6ID, 2);
   rmBuildArea(lake6ID);


   // Text
   rmSetStatusText("",0.30);


   // Lake 7
   int lake7ID=rmCreateArea("Lake 7");
   if (seasonPicker < 0.5)
      rmSetAreaWaterType(lake7ID, "Yukon Water");
   else
      rmSetAreaTerrainType(lake7ID, "great_lakes\ground_ice1_gl");
   rmSetAreaSize(lake7ID, 0.008, 0.008);
   rmSetAreaCoherence(lake7ID, 0.6);
   if (waterSide < 0.5)
      rmSetAreaLocation(lake7ID, 0.35, 0.15);
   else
      rmSetAreaLocation(lake7ID, 0.15, 0.35);
   rmAddAreaToClass(lake7ID, classLakes);
   rmSetAreaBaseHeight(lake7ID, -1.0);
   rmSetAreaObeyWorldCircleConstraint(lake7ID, false);
   rmSetAreaMinBlobs(lake7ID, 5);
   rmSetAreaMaxBlobs(lake7ID, 12);
   rmSetAreaMinBlobDistance(lake7ID, 3);
   rmSetAreaMaxBlobDistance(lake7ID, 12);
   rmSetAreaSmoothDistance(lake7ID, 2);
   rmBuildArea(lake7ID);

   // Lake 8 IF UNDER 6 players
   if ( cNumberNonGaiaPlayers <= 6 )
   {
   int lake8ID=rmCreateArea("Lake 8");
   if (seasonPicker < 0.5)
      rmSetAreaWaterType(lake8ID, "Yukon Water");
   else
      rmSetAreaTerrainType(lake8ID, "great_lakes\ground_ice1_gl");
   rmSetAreaSize(lake8ID, 0.008, 0.008);
   rmSetAreaCoherence(lake8ID, 0.6);
   if (waterSide < 0.5)
      rmSetAreaLocation(lake8ID, 0.75, 0.25);
   else
      rmSetAreaLocation(lake8ID, 0.25, 0.75);
   rmAddAreaToClass(lake8ID, classLakes);
   rmSetAreaBaseHeight(lake8ID, 0.0);
   rmSetAreaObeyWorldCircleConstraint(lake8ID, false);
   rmSetAreaMinBlobs(lake8ID, 5);
   rmSetAreaMaxBlobs(lake8ID, 12);
   rmSetAreaMinBlobDistance(lake8ID, 3);
   rmSetAreaMaxBlobDistance(lake8ID, 12);
   rmSetAreaSmoothDistance(lake8ID, 2);
   rmBuildArea(lake8ID);
   }


   // Define and place sea to the west

   // If SUMMER - water, if WINTER AND seaState UNDER 0.75 - winter-style water, if WINTER AND seaState OVER 0.75 - walkable ice (frozen)
   int seaID=rmCreateArea("Sea");
   if (seasonPicker < 0.5)
      rmSetAreaWaterType(seaID, "Yukon Water");
   if (seasonPicker >= 0.5 && seaState < 0.75)
      rmSetAreaWaterType(seaID, "great lakes ice");
   if (seasonPicker >= 0.5 && seaState >= 0.75)
      rmSetAreaTerrainType(seaID, "great_lakes\ground_ice1_gl");
   rmSetAreaSize(seaID, 0.13, 0.13);
   rmSetAreaCoherence(seaID, 0.75);
   if (waterSide < 0.5)
      rmSetAreaLocation(seaID, 0.0, 1.0);
   else
      rmSetAreaLocation(seaID, 1.0, 0.0);
   rmAddAreaToClass(seaID, classSea);
   rmSetAreaBaseHeight(seaID, -2.0);
   rmSetAreaObeyWorldCircleConstraint(seaID, false);
   rmSetAreaMinBlobs(seaID, 10);
   rmSetAreaMaxBlobs(seaID, 10);
   rmSetAreaMinBlobDistance(seaID, 10);
   rmSetAreaMaxBlobDistance(seaID, 10);
   rmSetAreaSmoothDistance(seaID, 4);
   rmBuildArea(seaID);



	// ____________________ Natives ____________________
	// Set up Natives

	int subCiv0 = -1;
	int subCiv1 = -1;
	int subCiv2 = -1;
	subCiv0 = rmGetCivID("Nootka");
	subCiv1 = rmGetCivID("Nootka");
	subCiv2 = rmGetCivID("Nootka");
	rmSetSubCiv(0, "Nootka");
	rmSetSubCiv(1, "Nootka");
	rmSetSubCiv(2, "Nootka");

	// Place Natives
	int nativeID0 = -1;
	int nativeID1 = -1;
	int nativeID2 = -1;

		nativeID0 = rmCreateGrouping("Nootka village A", "native nootka village "+1);
		rmAddGroupingToClass(nativeID0, rmClassID("natives"));
		rmAddGroupingConstraint(nativeID0, avoidImpassableLand);
		rmSetGroupingMinDistance(nativeID0, 0);
		rmSetGroupingMaxDistance(nativeID0, 10);
		nativeID1 = rmCreateGrouping("Nootka village B", "native nootka village "+1);
		rmAddGroupingToClass(nativeID1, rmClassID("natives"));
		rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
		rmSetGroupingMinDistance(nativeID1, 0);
		rmSetGroupingMaxDistance(nativeID1, 10);
		nativeID2 = rmCreateGrouping("Nootka village C", "native nootka village "+1);
		rmAddGroupingToClass(nativeID2, rmClassID("natives"));
		rmAddGroupingConstraint(nativeID2, avoidImpassableLand);
		rmSetGroupingMinDistance(nativeID2, 0);
		rmSetGroupingMaxDistance(nativeID2, 10);

			rmPlaceGroupingAtLoc(nativeID0, 0, 0.75, 0.75);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.25, 0.25);


   // Text
   rmSetStatusText("",0.40);


   // Place players

   if ( cNumberNonGaiaPlayers == 2 )
   {
      if (playerPlace < 0.5)
            rmPlacePlayer(1, 0.2, 0.5);
      else
            rmPlacePlayer(1, 0.5, 0.2);
      if (playerPlace < 0.5)
            rmPlacePlayer(2, 0.8, 0.5);
      else
            rmPlacePlayer(2, 0.5, 0.8);
   }

   if ( cNumberNonGaiaPlayers == 3 )
   {
      rmPlacePlayer(1, 0.2, 0.5);
      rmPlacePlayer(2, 0.5, 0.2);
      if (playerPlace < 0.5)
            rmPlacePlayer(3, 0.8, 0.5);
      else
            rmPlacePlayer(3, 0.5, 0.8);
   }

   if ( cNumberNonGaiaPlayers == 4 )
   {
      rmPlacePlayer(1, 0.2, 0.5);
      rmPlacePlayer(2, 0.5, 0.2);
      rmPlacePlayer(3, 0.8, 0.5);
      rmPlacePlayer(4, 0.5, 0.8);
   }

   if ( cNumberNonGaiaPlayers == 5 )
   {
      rmPlacePlayer(1, 0.2, 0.5);
      rmPlacePlayer(2, 0.5, 0.2);
      rmPlacePlayer(3, 0.8, 0.5);
      rmPlacePlayer(4, 0.5, 0.8);
      if (playerPlace < 0.5)
            rmPlacePlayer(5, 0.2, 0.2);
      else
            rmPlacePlayer(5, 0.8, 0.8);
   }

   if ( cNumberNonGaiaPlayers == 6 )
   {
      rmPlacePlayer(1, 0.2, 0.5);
      rmPlacePlayer(2, 0.5, 0.2);
      rmPlacePlayer(3, 0.8, 0.5);
      rmPlacePlayer(4, 0.5, 0.8);
      rmPlacePlayer(5, 0.2, 0.2);
      rmPlacePlayer(6, 0.8, 0.8);
   }
   
   if ( cNumberNonGaiaPlayers == 7 )
   {
      rmPlacePlayer(1, 0.2, 0.5);
      rmPlacePlayer(2, 0.5, 0.2);
      rmPlacePlayer(3, 0.8, 0.5);
      rmPlacePlayer(4, 0.5, 0.8);
      rmPlacePlayer(5, 0.2, 0.2);
      rmPlacePlayer(6, 0.8, 0.8);
      if (playerPlace < 0.5)
            rmPlacePlayer(7, 0.5, 0.5);
      else if (waterSide < 0.5)
            rmPlacePlayer(7, 0.75, 0.25);
      else
            rmPlacePlayer(7, 0.25, 0.75);
   }

   if ( cNumberNonGaiaPlayers == 8 )
   {
      rmPlacePlayer(1, 0.2, 0.5);
      rmPlacePlayer(2, 0.5, 0.2);
      rmPlacePlayer(3, 0.8, 0.5);
      rmPlacePlayer(4, 0.5, 0.8);
      rmPlacePlayer(5, 0.2, 0.2);
      rmPlacePlayer(6, 0.8, 0.8);
      if (waterSide < 0.5)
            rmPlacePlayer(7, 0.75, 0.25);
      else
            rmPlacePlayer(7, 0.25, 0.75);
      rmPlacePlayer(8, 0.5, 0.5);
   }

   float playerFraction=rmAreaTilesToFraction(100);
   for(i=1; <cNumberPlayers)
   {
      // Create the player areas.
      int id=rmCreateArea("Player"+i);
      // Assign to the player.
      rmSetPlayerArea(i, id);
      // Set the size.
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmAddAreaConstraint(id, playerConstraint); 
      rmAddAreaConstraint(id, playerEdgeConstraint); 
      rmAddAreaConstraint(id, longAvoidImpassableLand);
      rmSetAreaLocPlayer(id, i);
      rmSetAreaWarnFailure(id, false);
   }

   // Build the areas.
   rmBuildAllAreas();


   // Text
   rmSetStatusText("",0.50);
		

   // Define starting objects and resources

   int startingTCID= rmCreateObjectDef("startingTC");
   if (rmGetNomadStart())
      rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 5.0);
   else
      rmAddObjectDefItem(startingTCID, "townCenter", 1, 5.0);
   rmSetObjectDefMinDistance(startingTCID, 0.0);
   rmSetObjectDefMaxDistance(startingTCID, 6.0);
   rmAddObjectDefConstraint(startingTCID, avoidImpassableLand);
   rmAddObjectDefToClass(startingTCID, rmClassID("player"));

   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 6.0);
   rmSetObjectDefMaxDistance(startingUnits, 12.0);
   rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));

   int StartAreaTreeID=rmCreateObjectDef("starting trees");
   if (seasonPicker < 0.5)
      rmAddObjectDefItem(StartAreaTreeID, "TreeRockies", 6, 4.0);
   else
      rmAddObjectDefItem(StartAreaTreeID, "TreeRockiesSnow", 6, 4.0);
   rmSetObjectDefMinDistance(StartAreaTreeID, 12);
   rmSetObjectDefMaxDistance(StartAreaTreeID, 16);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidStartResource);
   rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidNatives);
   rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidStartingUnits);

   int StartElkID=rmCreateObjectDef("starting moose/berry");
   if (seasonPicker < 0.5)
   {
      rmAddObjectDefItem(StartElkID, "elk", 3, 4.0);
      rmAddObjectDefItem(StartElkID, "berrybush", 4, 4.0);
   }
   else
   {
      rmAddObjectDefItem(StartElkID, "elk", 6, 4.0);
      rmAddObjectDefItem(StartElkID, "berrybush", 2, 4.0);
   }
   rmSetObjectDefCreateHerd(StartElkID, false);
   rmSetObjectDefMinDistance(StartElkID, 12);
   rmSetObjectDefMaxDistance(StartElkID, 16);
   rmAddObjectDefConstraint(StartElkID, avoidStartResource);
   rmAddObjectDefConstraint(StartElkID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(StartElkID, avoidNatives);

   int startGoldID = rmCreateObjectDef("player gold");
   rmAddObjectDefItem(startGoldID, "mineGold", 1, 5.0);
   rmAddObjectDefConstraint(startGoldID, lakesConstraint);
   rmSetObjectDefMinDistance(startGoldID, 12);
   rmSetObjectDefMaxDistance(startGoldID, 16);
   rmAddObjectDefConstraint(startGoldID, avoidStartResource);
   rmAddObjectDefConstraint(startGoldID, avoidImpassableLand);
   rmAddObjectDefConstraint(startGoldID, shortAvoidStartingUnits);


   for(i=1; <cNumberPlayers)
   {					
      // Place starting objects and resources
      rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(StartElkID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

   }


   // Text
   rmSetStatusText("",0.60);
   int numTries = -1;
   int failCount = -1;


   // Define and place silver mines for each 1/4 slice of map (for balance)

   // Silver - NE
   int silverNEID = -1;
   int silverNECount = (3*cNumberNonGaiaPlayers);

   for(i=0; < silverNECount)
   {
      silverNEID = rmCreateObjectDef("silver mine NE "+i);
      rmAddObjectDefItem(silverNEID, "mine", 1, 0.0);
      rmSetObjectDefMinDistance(silverNEID, 0.0);
      rmSetObjectDefMaxDistance(silverNEID, rmXFractionToMeters(0.50));
      rmAddObjectDefConstraint(silverNEID, avoidImpassableLand);
      rmAddObjectDefConstraint(silverNEID, avoidNatives);
      if (seasonPicker < 0.5)
            rmAddObjectDefConstraint(silverNEID, lakesConstraint);
      if (seaSummerWater == 3 || seaWinterWater == 2)
            rmAddObjectDefConstraint(silverNEID, seaConstraint);
      rmAddObjectDefConstraint(silverNEID, avoidCoin);
      rmAddObjectDefConstraint(silverNEID, playerConstraint);
      rmAddObjectDefConstraint(silverNEID, Northward);
      rmAddObjectDefConstraint(silverNEID, Eastward);
      rmPlaceObjectDefAtLoc(silverNEID, 0, 0.5, 0.5);
   }

   // Silver - NW
   int silverNWID = -1;
   int silverNWCount = (3*cNumberNonGaiaPlayers);

   for(i=0; < silverNWCount)
   {
      silverNWID = rmCreateObjectDef("silver mine NW "+i);
      rmAddObjectDefItem(silverNWID, "mine", 1, 0.0);
      rmSetObjectDefMinDistance(silverNWID, 0.0);
      rmSetObjectDefMaxDistance(silverNWID, rmXFractionToMeters(0.50));
      rmAddObjectDefConstraint(silverNWID, avoidImpassableLand);
      rmAddObjectDefConstraint(silverNWID, avoidNatives);
      if (seasonPicker < 0.5)
            rmAddObjectDefConstraint(silverNWID, lakesConstraint);
      if (seaSummerWater == 3 || seaWinterWater == 2)
            rmAddObjectDefConstraint(silverNWID, seaConstraint);
      rmAddObjectDefConstraint(silverNWID, avoidCoin);
      rmAddObjectDefConstraint(silverNWID, playerConstraint);
      rmAddObjectDefConstraint(silverNWID, Northward);
      rmAddObjectDefConstraint(silverNWID, Westward);
      rmPlaceObjectDefAtLoc(silverNWID, 0, 0.5, 0.5);
   }

   // Silver - SE
   int silverSEID = -1;
   int silverSECount = (3*cNumberNonGaiaPlayers);

   for(i=0; < silverSECount)
   {
      silverSEID = rmCreateObjectDef("silver mine SE "+i);
      rmAddObjectDefItem(silverSEID, "mine", 1, 0.0);
      rmSetObjectDefMinDistance(silverSEID, 0.0);
      rmSetObjectDefMaxDistance(silverSEID, rmXFractionToMeters(0.50));
      rmAddObjectDefConstraint(silverSEID, avoidImpassableLand);
      rmAddObjectDefConstraint(silverSEID, avoidNatives);
      if (seasonPicker < 0.5)
            rmAddObjectDefConstraint(silverSEID, lakesConstraint);
      if (seaSummerWater == 3 || seaWinterWater == 2)
            rmAddObjectDefConstraint(silverSEID, seaConstraint);
      rmAddObjectDefConstraint(silverSEID, avoidCoin);
      rmAddObjectDefConstraint(silverSEID, playerConstraint);
      rmAddObjectDefConstraint(silverSEID, Southward);
      rmAddObjectDefConstraint(silverSEID, Eastward);
      rmPlaceObjectDefAtLoc(silverSEID, 0, 0.5, 0.5);
   }

   // Silver - SW
   int silverSWID = -1;
   int silverSWCount = (3*cNumberNonGaiaPlayers);

   for(i=0; < silverSWCount)
   {
      silverSWID = rmCreateObjectDef("silver mine SW "+i);
      rmAddObjectDefItem(silverSWID, "mine", 1, 0.0);
      rmSetObjectDefMinDistance(silverSWID, 0.0);
      rmSetObjectDefMaxDistance(silverSWID, rmXFractionToMeters(0.50));
      rmAddObjectDefConstraint(silverSWID, avoidImpassableLand);
      rmAddObjectDefConstraint(silverSWID, avoidNatives);
      if (seasonPicker < 0.5)
            rmAddObjectDefConstraint(silverSWID, lakesConstraint);
      if (seaSummerWater == 3 || seaWinterWater == 2)
            rmAddObjectDefConstraint(silverSWID, seaConstraint);
      rmAddObjectDefConstraint(silverSWID, avoidCoin);
      rmAddObjectDefConstraint(silverSWID, playerConstraint);
      rmAddObjectDefConstraint(silverSWID, Southward);
      rmAddObjectDefConstraint(silverSWID, Westward);
      rmPlaceObjectDefAtLoc(silverSWID, 0, 0.5, 0.5);
   }


   // Text
   rmSetStatusText("",0.70);


   // Define and place forests - north
   int forestTreeID = 0;
	
   numTries=5*cNumberNonGaiaPlayers;
   failCount=0;
   for (i=0; <numTries)
   {   
      int northForest=rmCreateArea("northforest"+i);
      rmSetAreaWarnFailure(northForest, false);
      rmSetAreaSize(northForest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(400));
      if (seasonPicker < 0.5)
            rmSetAreaForestType(northForest, "Rockies Forest");
      else
            rmSetAreaForestType(northForest, "Rockies Snow Forest");
      rmSetAreaForestDensity(northForest, 1.0);
      rmAddAreaToClass(northForest, rmClassID("classForest"));
      rmSetAreaForestClumpiness(northForest, 0.0);
      rmSetAreaForestUnderbrush(northForest, 0.0);
      rmSetAreaBaseHeight(northForest, 0.0);
      rmSetAreaMinBlobs(northForest, 1);
      rmSetAreaMaxBlobs(northForest, 3);
      rmSetAreaMinBlobDistance(northForest, 16.0);
      rmSetAreaMaxBlobDistance(northForest, 30.0);
      rmSetAreaCoherence(northForest, 0.4);
      rmSetAreaSmoothDistance(northForest, 1);
      rmAddAreaConstraint(northForest, avoidImportantItem);
      rmAddAreaConstraint(northForest, avoidNatives);
      if (seasonPicker < 0.5)
            rmAddAreaConstraint(northForest, lakesConstraint);
      if (seaSummerWater == 3 || seaWinterWater == 2)
            rmAddAreaConstraint(northForest, seaConstraint);
      rmAddAreaConstraint(northForest, playerConstraintForest);
      rmAddAreaConstraint(northForest, forestConstraint);
      rmAddAreaConstraint(northForest, Northward);
      if(rmBuildArea(northForest)==false)
      {
            // Stop trying once we fail 5 times in a row.  
            failCount++;
            if(failCount==5)
                        break;
      }
      else
                        failCount=0; 
   }


   // Define and place forests - south

   numTries=5*cNumberNonGaiaPlayers;
   failCount=0;
   for (i=0; <numTries)
   {   
      int southForest=rmCreateArea("southforest"+i);
      rmSetAreaWarnFailure(southForest, false);
      rmSetAreaSize(southForest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
      if (seasonPicker < 0.5)
            rmSetAreaForestType(southForest, "Rockies Forest");
      else
            rmSetAreaForestType(southForest, "Rockies Snow Forest");
      rmSetAreaForestDensity(southForest, 1.0);
      rmAddAreaToClass(southForest, rmClassID("classForest"));
      rmSetAreaForestClumpiness(southForest, 0.0);
      rmSetAreaForestUnderbrush(southForest, 0.0);
      rmSetAreaBaseHeight(southForest, 0.0);
      rmSetAreaMinBlobs(southForest, 1);
      rmSetAreaMaxBlobs(southForest, 3);
      rmSetAreaMinBlobDistance(southForest, 16.0);
      rmSetAreaMaxBlobDistance(southForest, 30.0);
      rmSetAreaCoherence(southForest, 0.4);
      rmSetAreaSmoothDistance(southForest, 1);
      rmAddAreaConstraint(southForest, avoidImportantItem);
      rmAddAreaConstraint(southForest, avoidNatives);
      if (seasonPicker < 0.5)
            rmAddAreaConstraint(southForest, lakesConstraint);
      if (seaSummerWater == 3 || seaWinterWater == 2)
            rmAddAreaConstraint(southForest, seaConstraint);
      rmAddAreaConstraint(southForest, playerConstraintForest);
      rmAddAreaConstraint(southForest, forestConstraint);
      rmAddAreaConstraint(southForest, Southward);
      if(rmBuildArea(southForest)==false)
      {
            // Stop trying once we fail 5 times in a row.  
            failCount++;
            if(failCount==5)
                        break;
      }
      else
                        failCount=0; 
   } 


   // Text
   rmSetStatusText("",0.80);

   
   // Define and place deer herds

   int deerHerdID=rmCreateObjectDef("deer herd");
   rmAddObjectDefItem(deerHerdID, "deer", rmRandInt(5,7), 6.0);
   rmSetObjectDefCreateHerd(deerHerdID, true);
   rmSetObjectDefMinDistance(deerHerdID, 0.0);
   rmSetObjectDefMaxDistance(deerHerdID, rmXFractionToMeters(0.50));
   rmAddObjectDefToClass(deerHerdID, classAnimals);
   rmAddObjectDefConstraint(deerHerdID, shortAvoidCoin);
   rmAddObjectDefConstraint(deerHerdID, shortPlayerConstraint);
   if (seasonPicker < 0.5)
      rmAddObjectDefConstraint(deerHerdID, lakesConstraint);
   if (seaSummerWater == 3 || seaWinterWater == 2)
      rmAddObjectDefConstraint(deerHerdID, seaConstraint);
   rmAddObjectDefConstraint(deerHerdID, avoidAll);
   rmAddObjectDefConstraint(deerHerdID, avoidImpassableLand);
   rmAddObjectDefConstraint(deerHerdID, animalConstraint);
   rmAddObjectDefConstraint(deerHerdID, avoidNatives);
   numTries=4*cNumberNonGaiaPlayers;
   for (i=0; <numTries)
   {
      rmPlaceObjectDefAtLoc(deerHerdID, 0, 0.5, 0.5);
   }


   // Define and place caribou herds

   int caribouHerdID=rmCreateObjectDef("caribou herd");
   rmAddObjectDefItem(caribouHerdID, "caribou", rmRandInt(5,7), 6.0);
   rmSetObjectDefCreateHerd(caribouHerdID, true);
   rmSetObjectDefMinDistance(caribouHerdID, 0.0);
   rmSetObjectDefMaxDistance(caribouHerdID, rmXFractionToMeters(0.50));
   rmAddObjectDefToClass(caribouHerdID, classAnimals);
   rmAddObjectDefConstraint(caribouHerdID, shortAvoidCoin);
   rmAddObjectDefConstraint(caribouHerdID, shortPlayerConstraint);
   if (seasonPicker < 0.5)
      rmAddObjectDefConstraint(caribouHerdID, lakesConstraint);
   if (seaSummerWater == 3 || seaWinterWater == 2)
      rmAddObjectDefConstraint(caribouHerdID, seaConstraint);
   rmAddObjectDefConstraint(caribouHerdID, avoidAll);
   rmAddObjectDefConstraint(caribouHerdID, avoidImpassableLand);
   rmAddObjectDefConstraint(caribouHerdID, animalConstraint);
   rmAddObjectDefConstraint(caribouHerdID, avoidNatives);
   numTries=4*cNumberNonGaiaPlayers;
   for (i=0; <numTries)
   {
      rmPlaceObjectDefAtLoc(caribouHerdID, 0, 0.5, 0.5);
   }
	

   // Define and place moose herds. 
 
   int mooseHerdID=rmCreateObjectDef("moose herd");
   rmAddObjectDefItem(mooseHerdID, "moose", rmRandInt(4,6), 6.0);
   rmSetObjectDefCreateHerd(mooseHerdID, true);
   rmSetObjectDefMinDistance(mooseHerdID, 0.0);
   rmSetObjectDefMaxDistance(mooseHerdID, rmXFractionToMeters(0.5));
   rmAddObjectDefToClass(mooseHerdID, classAnimals);
   rmAddObjectDefConstraint(mooseHerdID, shortAvoidCoin);
   if (seasonPicker < 0.5)
      rmAddObjectDefConstraint(mooseHerdID, lakesConstraint);
   if (seaSummerWater == 3 || seaWinterWater == 2)
      rmAddObjectDefConstraint(mooseHerdID, seaConstraint);
   rmAddObjectDefConstraint(mooseHerdID, avoidAll);
   rmAddObjectDefConstraint(mooseHerdID, shortPlayerConstraint);   
   rmAddObjectDefConstraint(mooseHerdID, avoidImpassableLand);   
   rmAddObjectDefConstraint(mooseHerdID, animalConstraint);
   rmAddObjectDefConstraint(mooseHerdID, avoidNatives);
   numTries=4*cNumberNonGaiaPlayers;
   for (i=0; <numTries)
   {
      rmPlaceObjectDefAtLoc(mooseHerdID, 0, 0.5, 0.5);
   }


   // Text
   rmSetStatusText("",0.90);
	

   // Define and place fish - more if summer

   int fishID=rmCreateObjectDef("fish");
   rmAddObjectDefItem(fishID, "FishSalmon", 1, 4.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   if (seasonPicker < 0.5)
      rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);
   if (seaSummerWater == 3 || seaWinterWater == 2)
      rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);


   // Text
   rmSetStatusText("",0.99);


   // Define and place Nuggets

   // Easy nuggets
   int nugget1= rmCreateObjectDef("nugget easy"); 
   rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(1, 1);
   rmAddObjectDefToClass(nugget1, rmClassID("nuggets"));
   rmAddObjectDefConstraint(nugget1, shortPlayerConstraint);
   rmAddObjectDefConstraint(nugget1, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget1, avoidNuggets);
   rmAddObjectDefConstraint(nugget1, avoidNatives);
   rmAddObjectDefConstraint(nugget1, avoidAll);
   if (seasonPicker < 0.5)
      rmAddObjectDefConstraint(nugget1, lakesConstraint);
   if (seaSummerWater == 3 || seaWinterWater == 2)
      rmAddObjectDefConstraint(nugget1, seaConstraint);
   rmAddObjectDefConstraint(nugget1, circleConstraint);
   rmSetObjectDefMinDistance(nugget1, 40.0);
   rmSetObjectDefMaxDistance(nugget1, 60.0);
   rmPlaceObjectDefPerPlayer(nugget1, false, 2);

   // Medium nuggets
   int nugget2= rmCreateObjectDef("nugget medium"); 
   rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(2, 2);
   rmAddObjectDefToClass(nugget2, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(nugget2, 0.0);
   rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(nugget2, shortPlayerConstraint);
   rmAddObjectDefConstraint(nugget2, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget2, avoidNuggets);
   rmAddObjectDefConstraint(nugget2, avoidNatives);
   rmAddObjectDefConstraint(nugget2, circleConstraint);
   rmAddObjectDefConstraint(nugget2, avoidAll);
   if (seasonPicker < 0.5)
      rmAddObjectDefConstraint(nugget2, lakesConstraint);
   if (seaSummerWater == 3 || seaWinterWater == 2)
      rmAddObjectDefConstraint(nugget2, seaConstraint);
   rmSetObjectDefMinDistance(nugget2, 80.0);
   rmSetObjectDefMaxDistance(nugget2, 120.0);
   rmPlaceObjectDefPerPlayer(nugget2, false, 2);

   // Hard nuggets
   int nugget3= rmCreateObjectDef("nugget hard"); 
   rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(3, 3);
   rmAddObjectDefToClass(nugget3, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(nugget3, 0.15);
   rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.45));
   rmAddObjectDefConstraint(nugget3, shortPlayerConstraint);
   rmAddObjectDefConstraint(nugget3, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget3, avoidNuggets);
   rmAddObjectDefConstraint(nugget3, avoidNatives);
   rmAddObjectDefConstraint(nugget3, circleConstraint);
   rmAddObjectDefConstraint(nugget3, avoidAll);
   if (seasonPicker < 0.5)
      rmAddObjectDefConstraint(nugget3, lakesConstraint);
   if (seaSummerWater == 3 || seaWinterWater == 2)
      rmAddObjectDefConstraint(nugget3, seaConstraint);
   rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

   // Very hard nuggets
   int nugget4= rmCreateObjectDef("nugget nuts"); 
   rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(4, 4);
   rmAddObjectDefToClass(nugget4, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(nugget4, 0.15);
   rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(nugget4, longPlayerConstraint);
   rmAddObjectDefConstraint(nugget4, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget4, avoidNuggets);
   rmAddObjectDefConstraint(nugget4, avoidNatives);
   rmAddObjectDefConstraint(nugget4, circleConstraint);
   rmAddObjectDefConstraint(nugget4, avoidAll);
   if (seasonPicker < 0.5)
      rmAddObjectDefConstraint(nugget4, lakesConstraint);
   if (seaSummerWater == 3 || seaWinterWater == 2)
      rmAddObjectDefConstraint(nugget4, seaConstraint);
   rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, rmRandInt(2,3));


   // Define and place cow herds 

   int cowID=rmCreateObjectDef("cow");
   rmAddObjectDefItem(cowID, "cow", 2, 4.0);
   rmSetObjectDefMinDistance(cowID, 0.0);
   rmSetObjectDefMaxDistance(cowID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(cowID, avoidCow);
   rmAddObjectDefConstraint(cowID, avoidAll);
   rmAddObjectDefConstraint(cowID, playerConstraint);
   rmAddObjectDefConstraint(cowID, avoidImpassableLand);
   rmAddObjectDefConstraint(cowID, avoidNatives);
   if (seasonPicker < 0.5)
      rmAddObjectDefConstraint(cowID, lakesConstraint);
   if (seaSummerWater == 3 || seaWinterWater == 2)
      rmAddObjectDefConstraint(cowID, seaConstraint);
   rmPlaceObjectDefAtLoc(cowID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.1;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }

   // Text
   rmSetStatusText("",1.0);
   
	}  

}  
