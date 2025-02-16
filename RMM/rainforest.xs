//==============================================================================
// Rainforest
// by Felix Hermansson, Tsunami Studios (hoodncloak@hotmail.com)
// 3 December 2006
//
// Random Map Script for Age of Empires III: The War Chiefs
//==============================================================================
// History:
// 31-12-05: Original release
// 01-01-06: Added missing herd definitions for huntables
// 11-11-06: Updated for TWC (Caribs replaced by Zapotec)
// 03-12-06: Huari strongholds added
//==============================================================================


//==============================================================================
// includes
//==============================================================================

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";


//==============================================================================
// function main 
// generates map
//==============================================================================

void main(void)
{
   // Map generation status bar
   rmSetStatusText("",0.01);

   // Define map size
   int playerTiles = 20000;
   if (cNumberNonGaiaPlayers >4)
   {
      playerTiles = 16000;
   }
   int size = 2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmSetMapSize(size, size);  

   // Set lighting
   rmSetLightingSet("caribbean");

   // Add wind and rain
   rmSetWindMagnitude(2.0);
   rmSetGlobalRain(0.9);

   // Pick default terrain
   rmSetSeaLevel(0.0);
   rmSetMapElevationParameters(cElevTurbulence, 0.09, 6, 0.2, 6.0);
   rmEnableLocalWater(false);
   rmSetBaseTerrainMix("amazon grass");   
   rmSetMapType("yucatan");
   rmSetMapType("tropical");
   rmSetMapType("water");
   rmSetMapType("samerica");
   rmSetWorldCircleConstraint(true);

   // Initialize map
   rmTerrainInitialize("amazon\ground2_am",6.0);

   // Create one land area to cover the whole map
   int landAreaID = rmCreateArea("land area");
   rmSetAreaSize(landAreaID, 1.0, 1.0);
   rmSetAreaWarnFailure(landAreaID, false);
   rmSetAreaMix(landAreaID, "amazon grass");
   rmSetAreaElevationType(landAreaID, cElevTurbulence);
   rmSetAreaElevationVariation(landAreaID, 2.0);
   rmSetAreaBaseHeight(landAreaID, 2.0);
   rmSetAreaElevationMinFrequency(landAreaID, 0.09);
   rmSetAreaElevationOctaves(landAreaID, 3);
   rmSetAreaElevationPersistence(landAreaID, 0.2);      
   rmSetAreaCoherence(landAreaID, 1.0);
   rmSetAreaLocation(landAreaID, 0.5, 0.5);
   rmSetAreaEdgeFilling(landAreaID, 5);
   rmSetAreaObeyWorldCircleConstraint(landAreaID, false);
   rmBuildArea(landAreaID);

   // Choose mercs
   chooseMercs();

   // Map generation status bar
   rmSetStatusText("",0.10);


   // Define constraints to have objects and areas avoid each other

   // Define classes
   int classPlayer = rmDefineClass("player");
   rmDefineClass("classCliff");
   rmDefineClass("classLake");
   rmDefineClass("classPatch");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
   rmDefineClass("nuggets");
   rmDefineClass("center");

   // Corner constraint
   rmSetWorldCircleConstraint(true);
   
   // Map edge constraints
   int playerEdgeConstraint = rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
   int longPlayerEdgeConstraint = rmCreateBoxConstraint("long avoid edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
   
   // Center constraints
   int centerConstraint = rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), rmXFractionToMeters(0.10));
   int centerConstraintFar = rmCreateClassDistanceConstraint("stay away from center far", rmClassID("center"), rmXFractionToMeters(0.23));
   int centerConstraintExtreme = rmCreateClassDistanceConstraint("stay away from center extremely far", rmClassID("center"), rmXFractionToMeters(0.50));

   // General circle constraint
   int circleConstraint = rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // Cardinal direction constraints
   int Northward = rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
   int Southward = rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
   int Eastward = rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
   int Westward = rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

   // Player constraints
   int extremePlayerConstraint = rmCreateClassDistanceConstraint("extreme distance player constraint", classPlayer, 100.0);
   int longPlayerConstraint = rmCreateClassDistanceConstraint("long distance player constraint", classPlayer, 70.0);
   int playerConstraint = rmCreateClassDistanceConstraint("standard distance player constraint", classPlayer, 45.0);
   int shortPlayerConstraint = rmCreateClassDistanceConstraint("short distance player constraint", classPlayer, 20.0);

   // Nature constraints (forests, mines & starting resources)
   int forestObjConstraint = rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int forestConstraint = rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 40.0);
   int avoidCoin = rmCreateTypeDistanceConstraint("avoid coin", "Mine", 40.0);
   int shortAvoidCoin = rmCreateTypeDistanceConstraint("short avoid coin", "gold", 10.0);
   int avoidResource = rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 20.0);
   int avoidStartResource = rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 10.0);

   // Impassable land constraints
   int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
   int shortAvoidImpassableLand = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand = rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);

   // Cliff constraints
   int avoidCliffs = rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 40.0);
   int avoidCliffsShort = rmCreateClassDistanceConstraint("short avoid cliff", rmClassID("classCliff"), 10.0);

   // Lake constraints
   int avoidLakes = rmCreateClassDistanceConstraint("lake vs. lake", rmClassID("classLake"), 150.0);
   int avoidLakesShort = rmCreateClassDistanceConstraint("short avoid lake", rmClassID("classLake"), 10.0);

   // Unit constraints
   int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 45.0);
   int shortAvoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units short", rmClassID("startingUnit"), 10.0);
   int avoidImportantItem = rmCreateClassDistanceConstraint("general items avoid each other", rmClassID("importantItem"), 10.0);
   int avoidNatives = rmCreateClassDistanceConstraint("objects avoid natives", rmClassID("natives"), 30.0);
   int avoidNativesLong = rmCreateClassDistanceConstraint("objects avoid natives long", rmClassID("natives"), 70.0);
   int avoidNativesExtreme = rmCreateClassDistanceConstraint("objects avoid natives extreme", rmClassID("natives"), 100.0);
   int avoidNuggets = rmCreateClassDistanceConstraint("objects avoid nuggets", rmClassID("nuggets"), 60.0);
   int shortNuggetConstraint = rmCreateTypeDistanceConstraint("avoid nugget objects", "AbstractNugget", 7.0);
   int tapirConstraint = rmCreateTypeDistanceConstraint("tapirs avoid tapirs", "tapir", 40.0);
   int capybaraConstraint = rmCreateTypeDistanceConstraint("capybaras avoid capybaras", "capybara", 40.0);

   // General constraint (used mostly for decoration objects)
   int avoidAll = rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // Map generation status bar
   rmSetStatusText("",0.20);


   // Place players

   // Place players in a rough circle on the outskirts of the map
   rmSetTeamSpacingModifier(0.7);
   rmPlacePlayersCircular(0.3, 0.45, rmDegreesToRadians(360/(cNumberNonGaiaPlayers*3)));

   // Create player areas
   float playerFraction = rmAreaTilesToFraction(100);
   for(i=1; <cNumberPlayers)
   {
      int id = rmCreateArea("Player"+i);
      rmSetPlayerArea(i, id);
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

   // Build all player areas
   rmBuildAllAreas();

   // Map generation status bar
   rmSetStatusText("",0.30);


   // Define and place starting units and resources

   // Define TC or covered wagon
   int startingTCID =  rmCreateObjectDef("startingTC");
   if (rmGetNomadStart())
   {
      rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 5.0);   
   }
   else
   {
      rmAddObjectDefItem(startingTCID, "townCenter", 1, 5.0);
   }
   rmSetObjectDefMaxDistance(startingTCID, 5.0);
   rmAddObjectDefConstraint(startingTCID, avoidImpassableLand);
   rmAddObjectDefToClass(startingTCID, rmClassID("player"));

   // Define starting units (explorer, envoy, native scout & war dog
   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 10.0);
   rmSetObjectDefMaxDistance(startingUnits, 12.0);
   rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));

   // Define starting mine close
   int startSilver1ID = rmCreateObjectDef("player silver close");
   rmAddObjectDefItem(startSilver1ID, "mine", 1, 5.0);
   rmSetObjectDefMinDistance(startSilver1ID, 12.0);
   rmSetObjectDefMaxDistance(startSilver1ID, 20.0);
   rmAddObjectDefConstraint(startSilver1ID, avoidStartResource);
   rmAddObjectDefConstraint(startSilver1ID, avoidImpassableLand);

   // Define starting mine medium
   int startSilver2ID = rmCreateObjectDef("player silver medium");
   rmAddObjectDefItem(startSilver2ID, "mine", 1, 5.0);
   rmSetObjectDefMinDistance(startSilver2ID, 45.0);
   rmSetObjectDefMaxDistance(startSilver2ID, 50.0);
   rmAddObjectDefConstraint(startSilver2ID, playerConstraint);
   rmAddObjectDefConstraint(startSilver2ID, avoidImpassableLand);

   // Define starting mine far
   int startSilver3ID = rmCreateObjectDef("player silver far");
   rmAddObjectDefItem(startSilver3ID, "mine", 1, 5.0);
   rmSetObjectDefMinDistance(startSilver3ID, 80.0);
   rmSetObjectDefMaxDistance(startSilver3ID, 100.0);
   rmAddObjectDefConstraint(startSilver3ID, longPlayerConstraint);
   rmAddObjectDefConstraint(startSilver3ID, avoidImpassableLand);

   // Define starting turkeys
   int startTurkeyID = rmCreateObjectDef("starting turkeys");
   rmAddObjectDefItem(startTurkeyID, "anteater", rmRandInt(7,8), 8.0);
   rmSetObjectDefMinDistance(startTurkeyID, 12);
   rmSetObjectDefMaxDistance(startTurkeyID, 16);
   rmAddObjectDefConstraint(startTurkeyID, avoidStartResource);
   rmAddObjectDefConstraint(startTurkeyID, shortAvoidImpassableLand);
   rmSetObjectDefCreateHerd(startTurkeyID, false);

   // Define starting capybaras
   int startCapybaraID = rmCreateObjectDef("starting capybaras");
   rmAddObjectDefItem(startCapybaraID, "capybara", rmRandInt(7,8), 8.0);
   rmSetObjectDefMinDistance(startCapybaraID, 24);
   rmSetObjectDefMaxDistance(startCapybaraID, 36);
   rmAddObjectDefConstraint(startCapybaraID, avoidStartResource);
   rmAddObjectDefConstraint(startCapybaraID, shortAvoidImpassableLand);
   rmSetObjectDefCreateHerd(startCapybaraID, true);

   // Define starting trees
   int startAreaTreeID = rmCreateObjectDef("starting trees");
   rmAddObjectDefItem(startAreaTreeID, "TreeAmazon", rmRandInt(7,8), 8.0);
   rmSetObjectDefMinDistance(startAreaTreeID, 10);
   rmSetObjectDefMaxDistance(startAreaTreeID, 16);
   rmAddObjectDefConstraint(startAreaTreeID, avoidStartResource);
   rmAddObjectDefConstraint(startAreaTreeID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(startAreaTreeID, shortAvoidStartingUnits);

   // Place starting units and resources for all payers 
   for(i=1; <cNumberPlayers)
   {
      rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startSilver1ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startSilver2ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startSilver3ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startTurkeyID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startCapybaraID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

   }

   // Map generation status bar
   rmSetStatusText("",0.40);


   // Define and place natives

   // Choose natives per village (Tupi or Zapotec)
   int subCiv0 = -1;
   int subCiv1 = -1;
   int subCiv2 = -1;
   int subCiv3 = -1;
   int subCiv4 = -1;
   int subCiv5 = -1;
   float nativeChooser = 0;
   if (rmAllocateSubCivs(6) == true)
   {
      // First village
      nativeChooser = rmRandFloat(0,1);
      if (nativeChooser <= 0.5)
      {
         subCiv0 = rmGetCivID("Tupi");
         if (subCiv0 >= 0)
         {
            rmSetSubCiv(0, "Tupi", true);
         }
      }
      else
      {
         subCiv0 = rmGetCivID("Zapotec");
         if (subCiv0 >= 0)
         {
            rmSetSubCiv(0, "Zapotec", true);
         }
      }
      // Second village
      nativeChooser = rmRandFloat(0,1);
      if (nativeChooser <= 0.5)
      {
         subCiv1 = rmGetCivID("Tupi");
         if (subCiv1 >= 0)
         {
            rmSetSubCiv(1, "Tupi", true);
         }
      }
      else
      {
         subCiv1 = rmGetCivID("Zapotec");
         if (subCiv1 >= 0)
         {
            rmSetSubCiv(1, "Zapotec", true);
         }
      }
      // Third village
      nativeChooser = rmRandFloat(0,1);
      if (nativeChooser <= 0.5)
      {
         subCiv2 = rmGetCivID("Tupi");
         if (subCiv2 >= 0)
         {
            rmSetSubCiv(2, "Tupi", true);
         }
      }
      else
      {
         subCiv2 = rmGetCivID("Zapotec");
         if (subCiv2 >= 0)
         {
            rmSetSubCiv(2, "Zapotec", true);
         }
      }
      // Fourth village
      nativeChooser = rmRandFloat(0,1);
      if (nativeChooser <= 0.5)
      {
         subCiv3 = rmGetCivID("Tupi");
         if (subCiv3 >= 0)
         {
            rmSetSubCiv(3, "Tupi", true);
         }
      }
      else
      {
         subCiv3 = rmGetCivID("Zapotec");
         if (subCiv3 >= 0)
         {
            rmSetSubCiv(3, "Zapotec", true);
         }
      }
      // Fifth village
      nativeChooser = rmRandFloat(0,1);
      if (nativeChooser <= 0.5)
      {
         subCiv4 = rmGetCivID("Tupi");
         if (subCiv4 >= 0)
         {
            rmSetSubCiv(4, "Tupi", true);
         }
      }
      else
      {
         subCiv4 = rmGetCivID("Zapotec");
         if (subCiv4 >= 0)
         {
            rmSetSubCiv(4, "Zapotec", true);
         }
      }
      // Sixth village
      nativeChooser = rmRandFloat(0,1);
      if (nativeChooser <= 0.5)
      {
         subCiv5 = rmGetCivID("Tupi");
         if (subCiv5 >= 0)
         {
            rmSetSubCiv(5, "Tupi", true);
         }
      }
      else
      {
         subCiv5 = rmGetCivID("Zapotec");
         if (subCiv5 >= 0)
         {
            rmSetSubCiv(5, "Zapotec", true);
         }
      }
   }

   // Define and place native villages
   int nativeVillage1ID = -1;
   int nativeVillage2ID = -1;
   int nativeVillage3ID = -1;
   int nativeVillage4ID = -1;
   int nativeVillage5ID = -1;
   int nativeVillage6ID = -1;
   if (subCiv0 == rmGetCivID("Tupi"))
   {
      // Tupi village 1
      int tupiVillage1Type = rmRandInt(1,5);
      nativeVillage1ID = rmCreateGrouping("native village 1", "native tupi village "+tupiVillage1Type);
      rmSetGroupingMinDistance(nativeVillage1ID, 0.0);
      rmSetGroupingMaxDistance(nativeVillage1ID, rmXFractionToMeters(0.35));
      rmAddGroupingConstraint(nativeVillage1ID, extremePlayerConstraint);
      rmAddGroupingConstraint(nativeVillage1ID, avoidNativesExtreme);
      rmAddGroupingToClass(nativeVillage1ID, rmClassID("natives"));
      rmAddGroupingToClass(nativeVillage1ID, rmClassID("importantItem"));
      rmPlaceGroupingAtLoc(nativeVillage1ID, 0, 0.5, 0.5);
   }
   else
   {
      // Zapotec village 1
      int zapotecVillage1Type = rmRandInt(1,5);
      nativeVillage1ID = rmCreateGrouping("native village 1", "native zapotec village "+zapotecVillage1Type);
      rmSetGroupingMinDistance(nativeVillage1ID, 0.0);
      rmSetGroupingMaxDistance(nativeVillage1ID, rmXFractionToMeters(0.35));
      rmAddGroupingConstraint(nativeVillage1ID, extremePlayerConstraint);
      rmAddGroupingConstraint(nativeVillage1ID, avoidNativesExtreme);
      rmAddGroupingToClass(nativeVillage1ID, rmClassID("natives"));
      rmAddGroupingToClass(nativeVillage1ID, rmClassID("importantItem"));
      rmPlaceGroupingAtLoc(nativeVillage1ID, 0, 0.5, 0.5);
   }
   if (subCiv1 == rmGetCivID("Tupi"))
   {
      // Tupi village 2
      int tupiVillage2Type = rmRandInt(1,5);
      nativeVillage2ID = rmCreateGrouping("native village 2", "native tupi village "+tupiVillage2Type);
      rmSetGroupingMinDistance(nativeVillage2ID, 0.0);
      rmSetGroupingMaxDistance(nativeVillage2ID, rmXFractionToMeters(0.35));
      rmAddGroupingConstraint(nativeVillage2ID, extremePlayerConstraint);
      rmAddGroupingConstraint(nativeVillage2ID, avoidNativesExtreme);
      rmAddGroupingToClass(nativeVillage2ID, rmClassID("natives"));
      rmAddGroupingToClass(nativeVillage2ID, rmClassID("importantItem"));
      rmPlaceGroupingAtLoc(nativeVillage2ID, 0, 0.5, 0.5);
   }
   else
   {
      // Zapotec village 2
      int zapotecVillage2Type = rmRandInt(1,5);
      nativeVillage2ID = rmCreateGrouping("native village 2", "native zapotec village "+zapotecVillage2Type);
      rmSetGroupingMinDistance(nativeVillage2ID, 0.0);
      rmSetGroupingMaxDistance(nativeVillage2ID, rmXFractionToMeters(0.35));
      rmAddGroupingConstraint(nativeVillage2ID, extremePlayerConstraint);
      rmAddGroupingConstraint(nativeVillage2ID, avoidNativesExtreme);
      rmAddGroupingToClass(nativeVillage2ID, rmClassID("natives"));
      rmAddGroupingToClass(nativeVillage2ID, rmClassID("importantItem"));
      rmPlaceGroupingAtLoc(nativeVillage2ID, 0, 0.5, 0.5);
   }
   if (subCiv2 == rmGetCivID("Tupi"))
   {
      // Tupi village 3
      int tupiVillage3Type = rmRandInt(1,5);
      nativeVillage3ID = rmCreateGrouping("native village 3", "native tupi village "+tupiVillage3Type);
      rmSetGroupingMinDistance(nativeVillage3ID, 0.0);
      rmSetGroupingMaxDistance(nativeVillage3ID, rmXFractionToMeters(0.35));
      rmAddGroupingConstraint(nativeVillage3ID, extremePlayerConstraint);
      rmAddGroupingConstraint(nativeVillage3ID, avoidNativesExtreme);
      rmAddGroupingToClass(nativeVillage3ID, rmClassID("natives"));
      rmAddGroupingToClass(nativeVillage3ID, rmClassID("importantItem"));
      rmPlaceGroupingAtLoc(nativeVillage3ID, 0, 0.5, 0.5);
   }
   else
   {
      // Zapotec village 3
      int zapotecVillage3Type = rmRandInt(1,5);
      nativeVillage3ID = rmCreateGrouping("native village 3", "native zapotec village "+zapotecVillage3Type);
      rmSetGroupingMinDistance(nativeVillage3ID, 0.0);
      rmSetGroupingMaxDistance(nativeVillage3ID, rmXFractionToMeters(0.35));
      rmAddGroupingConstraint(nativeVillage3ID, extremePlayerConstraint);
      rmAddGroupingConstraint(nativeVillage3ID, avoidNativesExtreme);
      rmAddGroupingToClass(nativeVillage3ID, rmClassID("natives"));
      rmAddGroupingToClass(nativeVillage3ID, rmClassID("importantItem"));
      rmPlaceGroupingAtLoc(nativeVillage3ID, 0, 0.5, 0.5);
   }
   if (subCiv3 == rmGetCivID("Tupi"))
   {
      // Tupi village 4
      int tupiVillage4Type = rmRandInt(1,5);
      nativeVillage4ID = rmCreateGrouping("native village 4", "native tupi village "+tupiVillage4Type);
      rmSetGroupingMinDistance(nativeVillage4ID, 0.0);
      rmSetGroupingMaxDistance(nativeVillage4ID, rmXFractionToMeters(0.35));
      rmAddGroupingConstraint(nativeVillage4ID, extremePlayerConstraint);
      rmAddGroupingConstraint(nativeVillage4ID, avoidNativesExtreme);
      rmAddGroupingToClass(nativeVillage4ID, rmClassID("natives"));
      rmAddGroupingToClass(nativeVillage4ID, rmClassID("importantItem"));
      rmPlaceGroupingAtLoc(nativeVillage4ID, 0, 0.5, 0.5);
   }
   else
   {
      // Zapotec village 4
      int zapotecVillage4Type = rmRandInt(1,5);
      nativeVillage4ID = rmCreateGrouping("native village 4", "native zapotec village "+zapotecVillage4Type);
      rmSetGroupingMinDistance(nativeVillage4ID, 0.0);
      rmSetGroupingMaxDistance(nativeVillage4ID, rmXFractionToMeters(0.35));
      rmAddGroupingConstraint(nativeVillage4ID, extremePlayerConstraint);
      rmAddGroupingConstraint(nativeVillage4ID, avoidNativesExtreme);
      rmAddGroupingToClass(nativeVillage4ID, rmClassID("natives"));
      rmAddGroupingToClass(nativeVillage4ID, rmClassID("importantItem"));
      rmPlaceGroupingAtLoc(nativeVillage4ID, 0, 0.5, 0.5);
   }
   if (cNumberNonGaiaPlayers > 3)
   {
      if (subCiv4 == rmGetCivID("Tupi"))
      {
         // Tupi village 5
         int tupiVillage5Type = rmRandInt(1,5);
         nativeVillage5ID = rmCreateGrouping("native village 5", "native tupi village "+tupiVillage5Type);
         rmSetGroupingMinDistance(nativeVillage5ID, 0.0);
         rmSetGroupingMaxDistance(nativeVillage5ID, rmXFractionToMeters(0.35));
         rmAddGroupingConstraint(nativeVillage5ID, extremePlayerConstraint);
         rmAddGroupingConstraint(nativeVillage5ID, avoidNativesExtreme);
         rmAddGroupingToClass(nativeVillage5ID, rmClassID("natives"));
         rmAddGroupingToClass(nativeVillage5ID, rmClassID("importantItem"));
         rmPlaceGroupingAtLoc(nativeVillage5ID, 0, 0.5, 0.5);
      }
      else
      {
         // Zapotec village 5
         int zapotecVillage5Type = rmRandInt(1,5);
         nativeVillage5ID = rmCreateGrouping("native village 5", "native zapotec village "+zapotecVillage5Type);
         rmSetGroupingMinDistance(nativeVillage5ID, 0.0);
         rmSetGroupingMaxDistance(nativeVillage5ID, rmXFractionToMeters(0.35));
         rmAddGroupingConstraint(nativeVillage5ID, extremePlayerConstraint);
         rmAddGroupingConstraint(nativeVillage5ID, avoidNativesExtreme);
         rmAddGroupingToClass(nativeVillage5ID, rmClassID("natives"));
         rmAddGroupingToClass(nativeVillage5ID, rmClassID("importantItem"));
         rmPlaceGroupingAtLoc(nativeVillage5ID, 0, 0.5, 0.5);
     }
     if (subCiv5 == rmGetCivID("Tupi"))
     {
         // Tupi village 6
         int tupiVillage6Type = rmRandInt(1,5);
         nativeVillage6ID = rmCreateGrouping("native village 6", "native tupi village "+tupiVillage6Type);
         rmSetGroupingMinDistance(nativeVillage6ID, 0.0);
         rmSetGroupingMaxDistance(nativeVillage6ID, rmXFractionToMeters(0.35));
         rmAddGroupingConstraint(nativeVillage6ID, extremePlayerConstraint);
         rmAddGroupingConstraint(nativeVillage6ID, avoidNativesExtreme);
         rmAddGroupingToClass(nativeVillage6ID, rmClassID("natives"));
         rmAddGroupingToClass(nativeVillage6ID, rmClassID("importantItem"));
         rmPlaceGroupingAtLoc(nativeVillage6ID, 0, 0.5, 0.5);
     }
     else
     {
         // Zapotec village 6
         int zapotecVillage6Type = rmRandInt(1,5);
         nativeVillage6ID = rmCreateGrouping("native village 6", "native zapotec village "+zapotecVillage6Type);
         rmSetGroupingMinDistance(nativeVillage6ID, 0.0);
         rmSetGroupingMaxDistance(nativeVillage6ID, rmXFractionToMeters(0.35));
         rmAddGroupingConstraint(nativeVillage6ID, extremePlayerConstraint);
         rmAddGroupingConstraint(nativeVillage6ID, avoidNativesExtreme);
         rmAddGroupingToClass(nativeVillage6ID, rmClassID("natives"));
         rmAddGroupingToClass(nativeVillage6ID, rmClassID("importantItem"));
         rmPlaceGroupingAtLoc(nativeVillage6ID, 0, 0.5, 0.5);
      }
   }

   // Map generation status bar
   rmSetStatusText("",0.50);


   // Place cliffs and lakes

   // Define and place cliffs
   int numCliffs = cNumberNonGaiaPlayers * 4;
   for (i=0; <numCliffs)
   {
      int cliffID = rmCreateArea("cliff"+i);
      rmSetAreaSize(cliffID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(700));
      rmSetAreaWarnFailure(cliffID, false);
      rmSetAreaCliffType(cliffID, "Amazon Inland");
      rmSetAreaCliffEdge(cliffID, 2, 0.3, 0.1, 1.0, 0);
      rmSetAreaCliffPainting(cliffID, false, true, true, 1.5, true);
      rmSetAreaCliffHeight(cliffID, 6, 2.0, 0.5);
      rmSetAreaHeightBlend(cliffID, 1);
      rmSetAreaObeyWorldCircleConstraint(cliffID, false);
      rmAddAreaToClass(cliffID, rmClassID("classCliff")); 
      rmAddAreaConstraint(cliffID, avoidImportantItem);
      rmAddAreaConstraint(cliffID, avoidImpassableLand);
      rmAddAreaConstraint(cliffID, avoidCliffs);
      rmAddAreaConstraint(cliffID, playerConstraint);
      rmAddAreaConstraint(cliffID, avoidStartingUnits);
      rmSetAreaMinBlobs(cliffID, 2);
      rmSetAreaMaxBlobs(cliffID, 4);
      rmSetAreaMinBlobDistance(cliffID, 10.0);
      rmSetAreaMaxBlobDistance(cliffID, 20.0);
      rmSetAreaSmoothDistance(cliffID, 10);
      rmSetAreaCoherence(cliffID, 0.10);
      rmBuildArea(cliffID);
   }

   // Define and place lakes
   int numLakes = rmRandInt(4, (cNumberNonGaiaPlayers + 2)); 
   for (i=0; <numLakes)
   {
      int lakeID = rmCreateArea("lake"+i);
      rmSetAreaSize(lakeID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(600));
      rmSetAreaWarnFailure(lakeID, false);
      rmSetAreaWaterType(lakeID, "amazon pond");
      rmSetAreaBaseHeight(lakeID, 1.0);
      rmSetAreaObeyWorldCircleConstraint(lakeID, false);
      rmAddAreaToClass(lakeID, rmClassID("classLake"));
      rmAddAreaConstraint(lakeID, avoidImportantItem);
      rmAddAreaConstraint(lakeID, avoidImpassableLand);
      rmAddAreaConstraint(lakeID, avoidCliffs);
      rmAddAreaConstraint(lakeID, avoidLakes);
      rmAddAreaConstraint(lakeID, playerConstraint);
      rmAddAreaConstraint(lakeID, avoidStartingUnits);
      rmSetAreaMinBlobs(lakeID, 2);
      rmSetAreaMaxBlobs(lakeID, 3);
      rmSetAreaMinBlobDistance(lakeID, 5.0);
      rmSetAreaMaxBlobDistance(lakeID, 20.0);
      rmSetAreaSmoothDistance(lakeID, 5);
      rmSetAreaCoherence(lakeID, 0.5);
      rmBuildArea(lakeID);
   }

   // Map generation status bar
   rmSetStatusText("",0.60);


   // Place forests and silver mines

   // Place additional silver mines
   int silverCount = cNumberNonGaiaPlayers*8;
   int silverMineID = rmCreateObjectDef("silver mines");
   rmAddObjectDefItem(silverMineID, "mine", 1, 0.0);
   rmSetObjectDefMinDistance(silverMineID, 0.0);
   rmSetObjectDefMaxDistance(silverMineID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(silverMineID, avoidImpassableLand);
   rmAddObjectDefConstraint(silverMineID, avoidCoin);
   rmAddObjectDefConstraint(silverMineID, longPlayerConstraint);
   rmAddObjectDefConstraint(silverMineID, avoidCliffsShort);
   rmAddObjectDefConstraint(silverMineID, avoidLakesShort);

   rmAddObjectDefConstraint(silverMineID, avoidAll);
   for(i=0; <silverCount)
   { 
      rmPlaceObjectDefAtLoc(silverMineID, 0, 0.5, 0.5);
   }

   // Place forests, lots of forests
   int forestCount = -1;
   int failCount = -1;
   int forestTreeID = 0;
   forestCount = size;
   failCount = 0;
   for (i=0; <forestCount)  // Northern forests
   {   
      int northForest=rmCreateArea("northforest"+i);
      rmSetAreaWarnFailure(northForest, false);
      rmSetAreaSize(northForest, rmAreaTilesToFraction(20), rmAreaTilesToFraction(100));
      rmSetAreaForestType(northForest, "amazon rain forest");
      rmSetAreaForestDensity(northForest, 1.0);
      rmAddAreaToClass(northForest, rmClassID("classForest"));
      rmSetAreaForestClumpiness(northForest, 0.0);
      rmSetAreaForestUnderbrush(northForest, 0.0);
      rmSetAreaBaseHeight(northForest, 2.0);
      rmSetAreaMinBlobs(northForest, 1);
      rmSetAreaMaxBlobs(northForest, 3);
      rmSetAreaMinBlobDistance(northForest, 16.0);
      rmSetAreaMaxBlobDistance(northForest, 30.0);
      rmSetAreaCoherence(northForest, 0.7);
      rmSetAreaSmoothDistance(northForest, 1);
      rmAddAreaConstraint(northForest, avoidImportantItem);
      rmAddAreaConstraint(northForest, avoidLakesShort);
      rmAddAreaConstraint(northForest, shortAvoidCoin);
      rmAddAreaConstraint(northForest, shortPlayerConstraint);
      rmAddAreaConstraint(northForest, Northward);
      if(rmBuildArea(northForest) == false)
      {
         // Stop placement once it fails 5 times in a row 
         failCount++;
         if(failCount == 5)
         {      
		break;
         }
      }
      else
      {
         failCount = 0;
      }
   }
   failCount = 0;
   for (i=0; <forestCount)  // Southern forests
   {   
      int southForest=rmCreateArea("southforest"+i);
      rmSetAreaWarnFailure(southForest, false);
      rmSetAreaSize(southForest, rmAreaTilesToFraction(20), rmAreaTilesToFraction(100));
      rmSetAreaForestType(southForest, "amazon rain forest");
      rmSetAreaForestDensity(southForest, 1.0);
      rmAddAreaToClass(southForest, rmClassID("classForest"));
      rmSetAreaForestClumpiness(southForest, 0.0);
      rmSetAreaForestUnderbrush(southForest, 0.0);
      rmSetAreaBaseHeight(southForest, 2.0);
      rmSetAreaMinBlobs(southForest, 1);
      rmSetAreaMaxBlobs(southForest, 3);
      rmSetAreaMinBlobDistance(southForest, 16.0);
      rmSetAreaMaxBlobDistance(southForest, 30.0);
      rmSetAreaCoherence(southForest, 0.7);
      rmSetAreaSmoothDistance(southForest, 1);
      rmAddAreaConstraint(southForest, avoidImportantItem);
      rmAddAreaConstraint(southForest, avoidLakesShort);
      rmAddAreaConstraint(southForest, shortAvoidCoin);
      rmAddAreaConstraint(southForest, shortPlayerConstraint);
      rmAddAreaConstraint(southForest, Southward);
      if(rmBuildArea(southForest)==false)
      {
         // Stop placement once it fails 5 times in a row 
         failCount++;
         if(failCount == 5)
         {      
		break;
         }
      }
      else
      {
         failCount = 0;
      }
   }

   // Map generation status bar
   rmSetStatusText("",0.70);


   // Place additional animals

   // Place tapirs
   int tapirCount = rmRandInt(3,5);
   int tapirHerdCount = 2*cNumberNonGaiaPlayers + rmRandInt(1,cNumberNonGaiaPlayers);
   int tapirNorthID = rmCreateObjectDef("tapir herd north");
   rmAddObjectDefItem(tapirNorthID, "tapir", tapirCount, 5.0);
   rmSetObjectDefMinDistance(tapirNorthID, 0.0);
   rmSetObjectDefMaxDistance(tapirNorthID, rmXFractionToMeters(0.50));
   rmAddObjectDefConstraint(tapirNorthID, avoidImpassableLand);
   rmAddObjectDefConstraint(tapirNorthID, shortAvoidCoin);
   rmAddObjectDefConstraint(tapirNorthID, playerConstraint);
   rmAddObjectDefConstraint(tapirNorthID, tapirConstraint);
   rmAddObjectDefConstraint(tapirNorthID, Northward);
   rmSetObjectDefCreateHerd(tapirNorthID, true);
   for(i=0; <tapirHerdCount)
   { 
      rmPlaceObjectDefAtLoc(tapirNorthID, 0, 0.5, 0.5); // northern half of the map
   }
   int tapirSouthID = rmCreateObjectDef("tapir herd south");
   rmAddObjectDefItem(tapirSouthID, "tapir", tapirCount, 5.0);
   rmSetObjectDefMinDistance(tapirSouthID, 0.0);
   rmSetObjectDefMaxDistance(tapirSouthID, rmXFractionToMeters(0.50));
   rmAddObjectDefConstraint(tapirSouthID, avoidImpassableLand);
   rmAddObjectDefConstraint(tapirSouthID, shortAvoidCoin);
   rmAddObjectDefConstraint(tapirSouthID, playerConstraint);
   rmAddObjectDefConstraint(tapirSouthID, tapirConstraint);
   rmAddObjectDefConstraint(tapirSouthID, Southward);
   rmSetObjectDefCreateHerd(tapirSouthID, true);
   for(i=0; <tapirHerdCount)
   { 
      rmPlaceObjectDefAtLoc(tapirSouthID, 0, 0.5, 0.5); // Southern half of the map
   }

   // Place capybaras
   int capybaraCount = rmRandInt(7,9);
   int capybaraHerdCount = 3*cNumberNonGaiaPlayers + rmRandInt(1,cNumberNonGaiaPlayers);
   int capybaraNorthID = rmCreateObjectDef("capybara herd north");
   rmAddObjectDefItem(capybaraNorthID, "capybara", capybaraCount, 5.0);
   rmSetObjectDefMinDistance(capybaraNorthID, 0.0);
   rmSetObjectDefMaxDistance(capybaraNorthID, rmXFractionToMeters(0.50));
   rmAddObjectDefConstraint(capybaraNorthID, avoidImpassableLand);
   rmAddObjectDefConstraint(capybaraNorthID, shortAvoidCoin);
   rmAddObjectDefConstraint(capybaraNorthID, playerConstraint);
   rmAddObjectDefConstraint(capybaraNorthID, tapirConstraint);
   rmAddObjectDefConstraint(capybaraNorthID, capybaraConstraint);
   rmAddObjectDefConstraint(capybaraNorthID, Northward);
   rmSetObjectDefCreateHerd(capybaraNorthID, true);
   for(i=0; <capybaraHerdCount)
   { 
      rmPlaceObjectDefAtLoc(capybaraNorthID, 0, 0.5, 0.5); // northern half of the map
   }
   int capybaraSouthID = rmCreateObjectDef("capybara herd south");
   rmAddObjectDefItem(capybaraSouthID, "capybara", capybaraCount, 5.0);
   rmSetObjectDefMinDistance(capybaraSouthID, 0.0);
   rmSetObjectDefMaxDistance(capybaraSouthID, rmXFractionToMeters(0.50));
   rmAddObjectDefConstraint(capybaraSouthID, avoidImpassableLand);
   rmAddObjectDefConstraint(capybaraSouthID, shortAvoidCoin);
   rmAddObjectDefConstraint(capybaraSouthID, playerConstraint);
   rmAddObjectDefConstraint(capybaraSouthID, tapirConstraint);
   rmAddObjectDefConstraint(capybaraSouthID, capybaraConstraint);
   rmAddObjectDefConstraint(capybaraSouthID, Southward);
   rmSetObjectDefCreateHerd(capybaraSouthID, true);
   for(i=0; <capybaraHerdCount)
   { 
      rmPlaceObjectDefAtLoc(capybaraSouthID, 0, 0.5, 0.5); // Southern half of the map
   }

   // Map generation status bar
   rmSetStatusText("",0.80);


   // Define and place Nuggets

   // Easy nuggets (3 per player, close to the TC)
   int nugget1= rmCreateObjectDef("nugget easy"); 
   rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(1, 1);
   rmAddObjectDefToClass(nugget1, rmClassID("nuggets"));
   rmAddObjectDefConstraint(nugget1, shortPlayerConstraint);
   rmAddObjectDefConstraint(nugget1, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget1, avoidNuggets);
   rmAddObjectDefConstraint(nugget1, avoidAll);
   rmAddObjectDefConstraint(nugget1, circleConstraint);
   rmSetObjectDefMinDistance(nugget1, 30.0);
   rmSetObjectDefMaxDistance(nugget1, 50.0);
   rmPlaceObjectDefPerPlayer(nugget1, false, 3);

   // Medium nuggets (4 per player, further from the TC)
   int nugget2= rmCreateObjectDef("nugget medium"); 
   rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(2, 2);
   rmAddObjectDefToClass(nugget2, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(nugget2, 0.0);
   rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(nugget2, shortPlayerConstraint);
   rmAddObjectDefConstraint(nugget2, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget2, avoidNuggets);
   rmAddObjectDefConstraint(nugget2, circleConstraint);
   rmAddObjectDefConstraint(nugget2, avoidAll);
   rmSetObjectDefMinDistance(nugget2, 75.0);
   rmSetObjectDefMaxDistance(nugget2, 125.0);
   rmPlaceObjectDefPerPlayer(nugget2, false, 4);

   // Hard nuggets (3 per player, central part of the map)
   int nugget3= rmCreateObjectDef("nugget hard"); 
   rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(3, 3);
   rmAddObjectDefToClass(nugget3, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(nugget3, 0.0);
   rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.30));
   rmAddObjectDefConstraint(nugget3, shortPlayerConstraint);
   rmAddObjectDefConstraint(nugget3, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget3, avoidNuggets);
   rmAddObjectDefConstraint(nugget3, circleConstraint);
   rmAddObjectDefConstraint(nugget3, avoidAll);
   rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

   // Very hard nuggets (3 per player, anywhere on the map)
   int nugget4= rmCreateObjectDef("nugget nuts"); 
   rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(4, 4);
   rmAddObjectDefToClass(nugget4, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(nugget4, 0.0);
   rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.50));
   rmAddObjectDefConstraint(nugget4, longPlayerConstraint);
   rmAddObjectDefConstraint(nugget4, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget4, avoidNuggets);
   rmAddObjectDefConstraint(nugget4, circleConstraint);
   rmAddObjectDefConstraint(nugget4, avoidAll);
   rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

   // Map generation status bar
   rmSetStatusText("",0.90);

   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .1, 0);
   }

   // Map generation status bar
   rmSetStatusText("",1.0);

}  
