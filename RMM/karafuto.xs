// New World Acropolis
// a random map for AOE3
// by RF_Gandalf

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{  
// Text
   rmSetStatusText("",0.01);

// Set up for variables
   string baseType = "";
   string pondType = "";
   string cliffType = "";
   string forestType = "";
   string treeType = "";
   string deerType = "";
   string deer2Type = "";
   string sheepType = "";
   string centerHerdType = "";
   string fishType = "";

// Set up for natives to appear on the map
   int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;
   int subCiv3=-1;
   int subCiv4=-1;
   int subCiv5=-1;
   int subCiv6=-1;
   int subCiv7=-1;
   int subCiv8=-1;
   int subCiv9=-1;
   int subCiv10=-1;
   int subCiv11=-1;

   if (rmAllocateSubCivs(12) == true)
   {
	subCiv0=rmGetCivID("Comanche");
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Comanche");

	subCiv1=rmGetCivID("Iroquois");
      if (subCiv1 >= 0)
         rmSetSubCiv(1, "Iroquois"); 

	subCiv2=rmGetCivID("Aztecs");
      if (subCiv2 >= 0)
         rmSetSubCiv(2, "Aztecs");

	subCiv3=rmGetCivID("Maya");
      if (subCiv3 >= 0)
         rmSetSubCiv(3, "Maya");

	subCiv4=rmGetCivID("Lakota");
      if (subCiv4 >= 0)
         rmSetSubCiv(4, "Lakota");

	subCiv5=rmGetCivID("Nootka");
      if (subCiv5 >= 0)
         rmSetSubCiv(5, "Nootka");

	subCiv6=rmGetCivID("Cherokee");
      if (subCiv6 >= 0)
         rmSetSubCiv(6, "Cherokee");

	subCiv7=rmGetCivID("Cree");
      if (subCiv7 >= 0)
         rmSetSubCiv(7, "Cree");

	subCiv8=rmGetCivID("Tupi");
      if (subCiv8 >= 0)
         rmSetSubCiv(8, "Tupi");

	subCiv9=rmGetCivID("Caribs");
      if (subCiv9 >= 0)
         rmSetSubCiv(9, "Caribs");

	subCiv10=rmGetCivID("Seminoles");
      if (subCiv10 >= 0)
         rmSetSubCiv(10, "Seminoles");

	subCiv11=rmGetCivID("Incas");
      if (subCiv11 >= 0)
         rmSetSubCiv(11, "Incas"); 
   }

// Pick pattern for trees, terrain, features, etc.
   int patternChance = rmRandInt(1,2);   
   int variantChance = rmRandInt(1,2);
   int lightingChance = rmRandInt(1,2);
   int trPattern = rmRandInt(1,7);
   int socketPattern = rmRandInt(1,2);   
   int nativeSetup = rmRandInt(0,8);
   if (cNumberNonGaiaPlayers < 5)
      nativeSetup = rmRandInt(0,10); 
   int nativePattern = -1;
   int nativeNumber = rmRandInt(2,6);
   int endPosition = rmRandInt(1,3);
   int sidePosition = rmRandInt(1,3);
   int sheepChance = rmRandInt(1,2);
   int featureChance = rmRandInt(1,10);
   int cliffChance = rmRandInt(1,10);
   int makeCliffs = -1; 
   int cliffVariety = rmRandInt(0,5);
   int makeLake = -1;
   int makePonds = -1;
   int makeIce = -1;
   int centerMt = -1;
   int forestMt = -1;
   int mtForest = -1;
   int makeCentralHighlands = -1;
   int makeCentralCanyon = -1;
   int vultures = -1;
   int eagles = -1;
   int plainsMap = -1;
   int hillTrees = -1;
   int placeBerries = 1;
   int baseHt = -1;
   int tropicalMap = -1;
   int reducedForest = -1;
   int mtPattern = rmRandInt(1,4);
   int makeCentralForestPatch = -1;
   int forestDist = rmRandInt(12,18);
   if (cNumberNonGaiaPlayers < 5)
	forestDist = rmRandInt(12,16);
   int circChance = rmRandInt(1,5);
   int placeCircular = 0;
   int twoChoice = rmRandInt(1,2);
   int axisChance = rmRandInt(1,2);
   int playerSide = rmRandInt(1,2);   
   int positionChance = rmRandInt(1,2);   
   int distChance = rmRandInt(4,8);
   int sectionChance = rmRandInt(1,3);
   int ffaChance = rmRandInt(1,4);
   int mineChance = rmRandInt(1,3);

// Picks the map size
   int playerTiles = 15000;
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=14000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=13000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=12000;

   int size=2.2*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

// Elevation
   rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);
   rmSetMapElevationHeightBlend(1.0);
   rmSetSeaLevel(0.0);
	
// Pick terrain patterns and features 

//  patternChance = 2;
//  featureChance = 2;
//  variantChance = 1;
//  cliffChance = 8;
  trPattern = 1;


   if (patternChance == 1) // yukon
   {
      rmSetSeaType("great lakes ice");
      rmSetMapType("siberia");
      rmSetMapType("grass");
      rmSetMapType("asia");

         rmSetLightingSet("yukon");

      baseHt = 1;
      baseType = "yukon grass";
	forestType = "yukon forest";
      cliffType = "rocky mountain2";
	treeType = "TreeYukonSnow";
      if (variantChance == 1)
	{
         deerType = "ypSerow";
         deer2Type = "ypSerow";
         centerHerdType = "SikaDeer";
	}
      else 
	{     
         deerType = "SikaDeer";
         deer2Type = "SikaDeer";
         centerHerdType = "ypSerow";   
	}
      if (sheepChance == 1)
         sheepType = "ypYak";
      else
         sheepType = "ypGoat";
      fishType = "FishSalmon";
      placeBerries = 0;
	nativePattern = 1;
      hillTrees = 1;

	   mtForest = 1;

   }
   else if (patternChance == 2) // rockies
   {
      rmSetSeaType("great lakes");
      rmSetMapType("Japan");
      rmSetMapType("grass");
      rmSetMapType("asia");

         rmSetLightingSet("rockies");

      baseHt = rmRandFloat(1,3);
      baseType = "rockies_grass";
	forestType = "rockies forest";
      cliffType = "New England Snow";
	treeType = "TreeRockies";
      if (variantChance == 1)
	{
         deerType = "ypSerow";
         deer2Type = "ypSerow";
         centerHerdType = "SikaDeer";
	}
      else 
	{     
         deerType = "SikaDeer";
         deer2Type = "SikaDeer";
         centerHerdType = "ypSerow";
	}   
      sheepChance = 0;
      fishType = "FishSalmon";
	nativePattern = 2;
      hillTrees = 0;
      placeBerries = 1;

	   mtForest = 1;

   }


   rmSetBaseTerrainMix(baseType);
   rmTerrainInitialize("yukon\ground1_yuk", 1);
   rmEnableLocalWater(false);
   rmSetMapType("land");

   rmSetWorldCircleConstraint(true);
   rmSetWindMagnitude(2.0);

// Precipitation
   if (patternChance == 1)
      rmSetGlobalSnow( 0.5 );

   
   chooseMercs();

// Define some classes.
   int classPlayer=rmDefineClass("player");
   int lakeClass=rmDefineClass("lake");
   rmDefineClass("classHill");
   rmDefineClass("classPatch");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
   rmDefineClass("classCliff");
   rmDefineClass("center");
   rmDefineClass("classNugget");
   rmDefineClass("socketClass");
   rmDefineClass("classIce");
   rmDefineClass("classMountain");
   int classHuntable=rmDefineClass("huntableFood");   
   int classHerdable=rmDefineClass("herdableFood"); 
   int canyon=rmDefineClass("canyon");

// Text
   rmSetStatusText("",0.10);

// -------------Define constraints
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
   int secondEdgeConstraint=rmCreateBoxConstraint("bison edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.485), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int circleConstraintMt=rmCreatePieConstraint("circle Constraint for mts", 0.5, 0.5, 0, rmZFractionToMeters(0.22), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // Center constraints
   int centerConstraint=rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), 30.0);
   int centerConstraintShort=rmCreateClassDistanceConstraint("stay away from center short", rmClassID("center"), 12.0);
   int centerConstraintFar=rmCreateClassDistanceConstraint("stay away from center far", rmClassID("center"), 70.0);
   int centerConstraintForest=rmCreateClassDistanceConstraint("stay away from center forest", rmClassID("center"), rmZFractionToMeters(0.24));
   int centerConstraintForest2=rmCreateClassDistanceConstraint("stay away from center forest 2", rmClassID("center"), rmZFractionToMeters(0.22));
   int centerConstraintForest3=rmCreateClassDistanceConstraint("stay away from center forest 3", rmClassID("center"), rmZFractionToMeters(0.22));
   int centerConstraintForest4=rmCreateClassDistanceConstraint("stay away from center forest 4", rmClassID("center"), rmZFractionToMeters(0.20));

   // Player constraints
   int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 15.0);
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 40.0);
   int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 25.0);
   int nuggetPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 60.0);
   int farPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players more", classPlayer, 75.0);
   int fartherPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players the most", classPlayer, 95.0);
   int enormousPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players for asymmetric starts", classPlayer, 130.0);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 70.0); 

   // Nature avoidance
   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int shortForestConstraint=rmCreateClassDistanceConstraint("patch vs. forest", rmClassID("classForest"), 15.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), forestDist);
   int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 20.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 10.0);
   int shortAvoidSilver=rmCreateTypeDistanceConstraint("short gold avoid gold", "Mine", 20.0);
   int coinAvoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 32.0);
   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   int avoidSheep=rmCreateClassDistanceConstraint("sheep avoids sheep etc", rmClassID("herdableFood"), 45.0);
   int huntableConstraint=rmCreateClassDistanceConstraint("huntable constraint", rmClassID("huntableFood"), 35.0);
   int longHuntableConstraint=rmCreateClassDistanceConstraint("long huntable constraint", rmClassID("huntableFood"), 55.0);
   int forestsAvoidBison=rmCreateClassDistanceConstraint("forest avoids bison", rmClassID("huntableFood"), 15.0);
   int avoidDucks=rmCreateTypeDistanceConstraint("avoids ducks", "DuckFamily", 50.0);

   // Avoid impassable land, certain features
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 18.0);
   int hillConstraint=rmCreateClassDistanceConstraint("hill vs. hill", rmClassID("classHill"), 15.0);
   int shortHillConstraint=rmCreateClassDistanceConstraint("patches vs. hill", rmClassID("classHill"), 5.0);
   int longHillConstraint=rmCreateClassDistanceConstraint("far from hill", rmClassID("classHill"), 35.0);
   int medHillConstraint=rmCreateClassDistanceConstraint("medium from hill", rmClassID("classHill"), 25.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 8.0);
   int avoidCliffs=rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 12.0);
   int avoidCliffsShort=rmCreateClassDistanceConstraint("stuff vs. cliff short", rmClassID("classCliff"), 7.0);
   int cliffsAvoidCliffs=rmCreateClassDistanceConstraint("cliffs vs. cliffs", rmClassID("classCliff"), 30.0);
   int avoidWater10 = rmCreateTerrainDistanceConstraint("avoid water mid-long", "Land", false, 10.0);
   int avoidWater15 = rmCreateTerrainDistanceConstraint("avoid water mid-longer", "Land", false, 15.0);
   int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water a little more", "Land", false, 20.0);
   int avoidWater30 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 30.0);
   int avoidCanyons=rmCreateClassDistanceConstraint("avoid canyons", rmClassID("canyon"), 35.0);
   int shortAvoidCanyons=rmCreateClassDistanceConstraint("short avoid canyons", rmClassID("canyon"), 15.0);
   int nearShore=rmCreateTerrainMaxDistanceConstraint("tree v. water", "land", true, 14.0);
   int rockVsLand = rmCreateTerrainDistanceConstraint("rock v. land", "land", true, 2.0);
   int avoidLakes=rmCreateClassDistanceConstraint("stuff vs.lakes", rmClassID("lake"), 12.0);
   int avoidLakesFar=rmCreateClassDistanceConstraint("stuff vs.lakes far", rmClassID("lake"), 55.0);
   int avoidIce=rmCreateClassDistanceConstraint("stuff vs.ice", rmClassID("classIce"), 12.0);
   int avoidMts = rmCreateClassDistanceConstraint("avoid mountains", rmClassID("classMountain"), 22.0);
  
   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 10.0);
   int avoidStartingUnitsLarge=rmCreateClassDistanceConstraint("objects avoid starting units large", rmClassID("startingUnit"), 50.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("things avoid each other", rmClassID("importantItem"), 10.0);
   int avoidImportantItemSmall=rmCreateClassDistanceConstraint("important item small avoidance", rmClassID("importantItem"), 7.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 60.0);
   int avoidNativesMed=rmCreateClassDistanceConstraint("stuff avoids natives medium", rmClassID("natives"), 35.0);
   int avoidNativesShort=rmCreateClassDistanceConstraint("stuff avoids natives shorter", rmClassID("natives"), 15.0);
   int avoidNugget=rmCreateClassDistanceConstraint("nugget vs. nugget", rmClassID("classNugget"), 42.0);
   int avoidNuggetMed=rmCreateClassDistanceConstraint("nugget vs. nugget med", rmClassID("classNugget"), 45.0);
   int avoidNuggetLong=rmCreateClassDistanceConstraint("nugget vs. nugget long", rmClassID("classNugget"), 55.0);
   int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 10.0);
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
   int avoidTradeRouteCliff = rmCreateTradeRouteDistanceConstraint("trade route cliff", 10.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);
   int avoidSocket=rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 8.0);

   // Cardinal Directions - "halves" of the map.
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(272), rmDegreesToRadians(88));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(92), rmDegreesToRadians(268));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(2), rmDegreesToRadians(178));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(182), rmDegreesToRadians(358));

// End of constraints 
// ---------------------------------------------------------------------------------------

// Text
   rmSetStatusText("",0.15);

// Set up of trade routes for special situations
   if ((makeLake == 1) || (makeIce == 1) || (makeCentralCanyon == 1) || (makeCentralHighlands == 1))
   {
	if (trPattern > 4)    
	{
         trPattern = rmRandInt(1,4);
	}
   }

   if ((centerMt == 1) || (forestMt == 1))
   {
      if (mtPattern == 1)
	{
	   if (trPattern > 4) 
	   {
	      trPattern = rmRandInt(1,4);
	   }
	}
   }

   if (cNumberTeams > 2)
   {
	if (trPattern == 5) 
	{
	   int sixChoice = rmRandInt(1,6);
	   if (sixChoice > 4)
		trPattern = rmRandInt(6,7);
	   else
		trPattern = rmRandInt(1,4);
	}
   }
	

// Set up player starting locations

if (cNumberNonGaiaPlayers == 2)
{
   if (trPattern > 5)
   {
      sectionChance = rmRandInt(1,9);
	distChance = rmRandInt(5,8);
   }
   else if (trPattern == 4)
   {
      sectionChance = rmRandInt(1,5);
	distChance = rmRandInt(5,6);
   }
   else if (trPattern == 5)
   {
      sectionChance = rmRandInt(1,3);
	distChance = rmRandInt(4,6);
   }
   else
   {
      sectionChance = rmRandInt(1,3);
	distChance = rmRandInt(4,5);
   }

   if (axisChance == 1)
   {
      if (playerSide == 1)
      {
	     rmSetPlacementTeam(0);
      }
      else if (playerSide == 2)
      {
		rmSetPlacementTeam(1);
      }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.24, 0.26);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.29, 0.31);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.19, 0.21);
	    else if (sectionChance == 8)
             rmSetPlacementSection(0.14, 0.16);
	    else if (sectionChance == 9)
             rmSetPlacementSection(0.34, 0.36);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.34, 0.36);
	    else if (sectionChance == 7)
             rmSetPlacementSection(0.14, 0.16);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.29, 0.31);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.19, 0.21);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.30, 0.31, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.74, 0.76);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.79, 0.81);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.69, 0.71);
	    else if (sectionChance == 8)
             rmSetPlacementSection(0.64, 0.66);
	    else if (sectionChance == 9)
             rmSetPlacementSection(0.84, 0.86);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.64, 0.66);
	    else if (sectionChance == 7)
             rmSetPlacementSection(0.84, 0.86);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.69, 0.71);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.79, 0.81);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.30, 0.31, 0.0);
   }
   else if (axisChance == 2)
   {
	    if (playerSide == 1)
          {
		rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.49, 0.51);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.44, 0.46);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.54, 0.56);
	    else if (sectionChance == 8)
             rmSetPlacementSection(0.39, 0.41);
	    else if (sectionChance == 9)
             rmSetPlacementSection(0.59, 0.61);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.89, 0.91);
	    else if (sectionChance == 7)
             rmSetPlacementSection(0.09, 0.11);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.54, 0.56);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.44, 0.46);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.30, 0.31, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.99, 0.01);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.94, 0.96);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.04, 0.06);
	    else if (sectionChance == 8)
             rmSetPlacementSection(0.89, 0.91);
	    else if (sectionChance == 9)
             rmSetPlacementSection(0.09, 0.11);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.59, 0.61);
	    else if (sectionChance == 7)
             rmSetPlacementSection(0.39, 0.41);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.94, 0.96);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.04, 0.06);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.30, 0.31, 0.0);
   }
}   
else 
{ 
   if (cNumberTeams == 2)
   {
      if (cNumberNonGaiaPlayers == 4) // 2 teams, 4 players 
      {
         sectionChance = rmRandInt(1,6);
         if (trPattern > 5)
         {
	      distChance = rmRandInt(4,8);
         }
         else if (trPattern == 1)
         {
	      distChance = rmRandInt(4,5);
         }
         else
         {
   		distChance = rmRandInt(4,6);
         }

        if (axisChance == 1)
        {
          if (playerSide == 1)
          {
	  	rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.20, 0.30);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.18, 0.32);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.17, 0.33);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.16, 0.34);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.17, 0.30);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.20, 0.33);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.30, 0.31, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.70, 0.80);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.68, 0.82);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.67, 0.83);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.66, 0.84);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.67, 0.80);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.70, 0.83);          

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.30, 0.31, 0.0);
        }
        else if (axisChance == 2)
        {
	    if (playerSide == 1)
          {
		rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.45, 0.55);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.43, 0.57);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.42, 0.58);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.41, 0.59);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.42, 0.55);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.45, 0.58);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.30, 0.31, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.95, 0.05);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.93, 0.07);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.92, 0.08);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.91, 0.09);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.92, 0.05);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.95, 0.08);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.30, 0.31, 0.0);
         } 
      }
      else if (cNumberNonGaiaPlayers == 3) // for 2 teams, for 3 players
      {
         sectionChance = rmRandInt(1,3);
         if (trPattern > 5)
         {
	      distChance = rmRandInt(5,8);
         }
         else if (trPattern == 4)
         {
		if (sectionChance == 3)
	         distChance = rmRandInt(5,6);	
		else 
	         distChance = rmRandInt(5,8);		
         }
         else if (trPattern == 1)
         {
		if (sectionChance == 1)
	         distChance = rmRandInt(5,6);	
		else 
	         distChance = 5;	
         }
         else
         {
		sectionChance = rmRandInt(1,2);
   		distChance = 5;
         }

        if (axisChance == 1)
        {
          if (playerSide == 1)
          {
	  	rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.18, 0.32);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.16, 0.34);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.14, 0.36);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.68, 0.82);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.66, 0.84);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.64, 0.86);

  	    if (distChance == 4)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
        }
        else if (axisChance == 2)
        {
	    if (playerSide == 1)
          {
		rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.43, 0.57);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.41, 0.59);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.39, 0.61);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.93, 0.07);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.91, 0.09);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.89, 0.11);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
        }
      }
      else if (cNumberNonGaiaPlayers <7) // for 2 teams, for 5-6 players
      {
         sectionChance = rmRandInt(1,3);
         if (trPattern > 5)
         {
	      distChance = rmRandInt(4,8);
         }
         else if (trPattern == 5)
         {
		if (sectionChance == 3)
	         distChance = rmRandInt(4,5);		
		else
	         distChance = rmRandInt(4,7);
         }
         else if (trPattern == 1)
         {
	      distChance = rmRandInt(4,5);
         }
         else
         {
   		distChance = rmRandInt(4,6);
         }

        if (axisChance == 1)
        {
          if (playerSide == 1)
          {
	  	rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.17, 0.33);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.15, 0.35);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.13, 0.37);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.67, 0.83);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.65, 0.85);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.63, 0.87);

  	    if (distChance == 4)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
        }
        else if (axisChance == 2)
        {
	    if (playerSide == 1)
          {
		rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.42, 0.58);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.40, 0.60);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.38, 0.62);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.92, 0.08);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.90, 0.10);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.88, 0.12);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
        }
      }
      else  // for 2 teams, for over 6 players
      {
         sectionChance = rmRandInt(1,3);
         if (trPattern > 5)
         {
	      distChance = rmRandInt(4,8);
         }
         else if (trPattern == 4)
         {
		if (sectionChance == 3)
	         distChance = rmRandInt(4,5);		
		else
	         distChance = rmRandInt(4,6);
         }
         else if (trPattern == 5)
         {
		sectionChance = rmRandInt(1,2);
		if (sectionChance == 2)
	         distChance = rmRandInt(4,5);		
		else
	         distChance = rmRandInt(4,6);
         }
         else
         {
		sectionChance = rmRandInt(1,2);
   		distChance = rmRandInt(4,5);
         }

        if (axisChance == 1)
        {
          if (playerSide == 1)
          {
	  	rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.15, 0.35);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.13, 0.37);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.11, 0.39);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.65, 0.85);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.63, 0.87);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.61, 0.89);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);
        }
        else if (axisChance == 2)
        {
	    if (playerSide == 1)
          {
		rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.40, 0.60);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.38, 0.62);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.36, 0.64);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.90, 0.10);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.88, 0.12);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.86, 0.14);

 	    if (distChance == 4)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.38, 0.39, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
	    else if (distChance == 7)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
	    else if (distChance == 8)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);
        }
      }
   }
   else  // for FFA or over 2 teams
   {
      if (cNumberNonGaiaPlayers == 3) 
      {
        if (axisChance == 1)
        {
		if (ffaChance == 1)
		{
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.11, 0.12);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.38, 0.39);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.75, 0.76);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		}
		else if (ffaChance == 2)
		{
		rmSetPlacementTeam(0);
            rmSetPlacementSection(0.75, 0.76);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.11, 0.12);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.38, 0.39);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		}		
		else if (ffaChance == 3) 
		{
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.11, 0.12);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(1);
            rmSetPlacementSection(0.38, 0.39);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(2);
            rmSetPlacementSection(0.75, 0.76);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		}
		else
            { 
		rmSetPlacementTeam(0);
            rmSetPlacementSection(0.25, 0.26);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.61, 0.62);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.88, 0.89);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
            }
	  }
        else if (axisChance == 2)
        {
		if (ffaChance == 1)
		{
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.36, 0.37);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.63, 0.64);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.0, 0.01);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		}
		else if (ffaChance == 2)
		{
	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.36, 0.37);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.63, 0.64);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(0);
            rmSetPlacementSection(0.0, 0.01);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		}		
		else if (ffaChance == 3) 
		{
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.36, 0.37);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(1);
            rmSetPlacementSection(0.63, 0.64);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(2);
            rmSetPlacementSection(0.0, 0.01);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		}
		else
            { 
		rmSetPlacementTeam(0);
            rmSetPlacementSection(0.50, 0.51);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(2);
            rmSetPlacementSection(0.86, 0.87);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(1);
            rmSetPlacementSection(0.13, 0.14);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
            }
	  }
      }
      else if (cNumberNonGaiaPlayers == 4) 
      {
        if (axisChance == 1)
        {
		if (ffaChance == 1)
		{
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.11, 0.12);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.38, 0.39);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.61, 0.62);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(3);
            rmSetPlacementSection(0.88, 0.89);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		}
		else if (ffaChance == 2)
		{
	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.11, 0.12);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.38, 0.39);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(3);
            rmSetPlacementSection(0.61, 0.62);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(0);
            rmSetPlacementSection(0.88, 0.89);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		}		
		else if (ffaChance == 3) 
		{
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.11, 0.12);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(1);
            rmSetPlacementSection(0.38, 0.39);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(2);
            rmSetPlacementSection(0.61, 0.62);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(3);
            rmSetPlacementSection(0.88, 0.89);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		}
		else
            { 
	  	rmSetPlacementTeam(3);
            rmSetPlacementSection(0.11, 0.12);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.38, 0.39);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.61, 0.62);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(1);
            rmSetPlacementSection(0.88, 0.89);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
            }
	  }
        else if (axisChance == 2)
        {
		if (ffaChance == 1)
		{
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.36, 0.37);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.63, 0.64);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.86, 0.87);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(3);
            rmSetPlacementSection(0.13, 0.14);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		}
		else if (ffaChance == 2)
		{
	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.36, 0.37);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.63, 0.64);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(3);
            rmSetPlacementSection(0.86, 0.87);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(0);
            rmSetPlacementSection(0.13, 0.14);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		}		
		else if (ffaChance == 3) 
		{
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.36, 0.37);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(1);
            rmSetPlacementSection(0.63, 0.64);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(2);
            rmSetPlacementSection(0.86, 0.87);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(3);
            rmSetPlacementSection(0.13, 0.14);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		}
		else
            { 
	  	rmSetPlacementTeam(3);
            rmSetPlacementSection(0.36, 0.37);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.63, 0.64);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.86, 0.87);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(1);
            rmSetPlacementSection(0.13, 0.14);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
            }
	  }
	}
      else if (cNumberNonGaiaPlayers == 5) 
      {
        if (axisChance == 1)
        {
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.11, 0.12);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.38, 0.39);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(4);
            rmSetPlacementSection(0.25, 0.26);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);

	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.61, 0.62);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(3);
            rmSetPlacementSection(0.88, 0.89);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  }
	  else if (axisChance == 2)
        {
	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.36, 0.37);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(3);
            rmSetPlacementSection(0.50, 0.51);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);

	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.86, 0.87);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.13, 0.14);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(4);
            rmSetPlacementSection(0.00, 0.01);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  }
      }
      else if (cNumberNonGaiaPlayers == 6) 
      {
        if (axisChance == 1)
        {
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.11, 0.12);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.38, 0.39);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(4);
            rmSetPlacementSection(0.25, 0.26);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);

	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.61, 0.62);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(3);
            rmSetPlacementSection(0.88, 0.89);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(5);
            rmSetPlacementSection(0.75, 0.76);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  }
	  else if (axisChance == 2)
        {
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.36, 0.37);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.63, 0.64);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(4);
            rmSetPlacementSection(0.50, 0.51);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);

	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.86, 0.87);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(3);
            rmSetPlacementSection(0.13, 0.14);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(5);
            rmSetPlacementSection(0.00, 0.01);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  }
      }
      else if (cNumberNonGaiaPlayers == 7) 
      {
        if (axisChance == 1)
        {
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.11, 0.12);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.38, 0.39);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(4);
            rmSetPlacementSection(0.20, 0.21);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(6);
            rmSetPlacementSection(0.29, 0.30);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);

	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.61, 0.62);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(3);
            rmSetPlacementSection(0.88, 0.89);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(5);
            rmSetPlacementSection(0.75, 0.76);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  }
	  else if (axisChance == 2)
        {
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.36, 0.37);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.63, 0.64);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(4);
            rmSetPlacementSection(0.45, 0.46);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(6);
            rmSetPlacementSection(0.54, 0.55);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);

	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.86, 0.87);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(3);
            rmSetPlacementSection(0.13, 0.14);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(5);
            rmSetPlacementSection(0.00, 0.01);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  }
      }
      else if (cNumberNonGaiaPlayers == 8) 
      {
        if (axisChance == 1)
        {
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.11, 0.12);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.38, 0.39);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(4);
            rmSetPlacementSection(0.20, 0.21);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(6);
            rmSetPlacementSection(0.29, 0.30);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);

	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.61, 0.62);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(3);
            rmSetPlacementSection(0.88, 0.89);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(5);
            rmSetPlacementSection(0.70, 0.71);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(7);
            rmSetPlacementSection(0.79, 0.80);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  }
	  else if (axisChance == 2)
        {
	  	rmSetPlacementTeam(0);
            rmSetPlacementSection(0.36, 0.37);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(2);
            rmSetPlacementSection(0.63, 0.64);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(4);
            rmSetPlacementSection(0.45, 0.46);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(6);
            rmSetPlacementSection(0.54, 0.55);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);

	  	rmSetPlacementTeam(1);
            rmSetPlacementSection(0.86, 0.87);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(3);
            rmSetPlacementSection(0.13, 0.14);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  	rmSetPlacementTeam(5);
            rmSetPlacementSection(0.95, 0.96);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
		rmSetPlacementTeam(7);
            rmSetPlacementSection(0.04, 0.05);
	      rmPlacePlayersCircular(0.40, 0.41, 0.0);
	  }
      }
   }
}

// Text
   rmSetStatusText("",0.20);

// Trade Routes
if (trPattern == 2) // 2 opposite inner semicircular routes
{
   // first route
   int tradeRouteID = rmCreateTradeRoute();
   if (axisChance == 1) 
   {	
	rmAddTradeRouteWaypoint(tradeRouteID, 0.54, 0.81);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.67, 0.55);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.685, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.67, 0.45);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.54, 0.19);
   }
   else 
   {	
	rmAddTradeRouteWaypoint(tradeRouteID, 0.19, 0.54);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 0.67);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.685);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 0.69);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.81, 0.54);
   }
   rmBuildTradeRoute(tradeRouteID, "dirt");

   // second route
   int tradeRouteID2 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.46, 0.19);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.33, 0.45);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.315, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.33, 0.55);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.46, 0.81);
   }
   else
   {
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.19, 0.46);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.40, 0.33);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.5, 0.315);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.60, 0.33);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.81, 0.46);
   }
   rmBuildTradeRoute(tradeRouteID2, "carolinas\trade_route");	
}
else if (trPattern == 3)  // one 'circular' inner route
{
   int tradeRouteID3 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {	
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.51, 0.8);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.66, 0.55);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.68, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.66, 0.45);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.5, 0.2);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.34, 0.45);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.32, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.34, 0.55);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.495, 0.8);
   }
   else 
   {	
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.2, 0.51);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.40, 0.66);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.5, 0.68);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.60, 0.66);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.8, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.60, 0.34);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.5, 0.32);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.40, 0.34);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.2, 0.49);
   }
   rmBuildTradeRoute(tradeRouteID3, "dirt");
}
else if (trPattern == 4)  // two 'diagonal'
{
   int tradeRouteID4 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.67, 1.0);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.6, 0.62);
	if(variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.67, 0.55);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.67, 0.45);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.63, 0.55);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.63, 0.45);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.6, 0.38);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.67, 0.0);
   }
   else if (axisChance == 2) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID4, 1.0, 0.67);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.62, 0.6);
	if(variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.55, 0.67);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.45, 0.67);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.55, 0.63);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.45, 0.63);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.38, 0.6);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.0, 0.67);
   }
   rmBuildTradeRoute(tradeRouteID4, "carolinas\trade_route");

   int tradeRouteID4A = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
     rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 1.0);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.4, 0.62);
	if(variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 0.55);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 0.45);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.37, 0.55);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.37, 0.45);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.4, 0.38);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 0.0);
   }
   else if (axisChance == 2) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID4A, 1.0, 0.33);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.62, 0.4);
	if(variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.55, 0.33);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.45, 0.33);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.55, 0.37);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.45, 0.37);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.38, 0.4);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.0, 0.33);
   }
   rmBuildTradeRoute(tradeRouteID4A, "dirt");
}
else if (trPattern == 5)  // two parabolas concave toward players
{
   int tradeRouteID5 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.69, 1.0);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.68, 0.85);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.6, 0.62);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.55, 0.51);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.55, 0.49);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.6, 0.38);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.68, 0.15);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.69, 0.0);
   }
   else if (axisChance == 2) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID5, 1.0, 0.69);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.85, 0.68);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.62, 0.6);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.51, 0.55);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.49, 0.55);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.38, 0.6);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.15, 0.68);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.0, 0.69);
   }
   rmBuildTradeRoute(tradeRouteID5, "carolinas\trade_route");

   int tradeRouteID5A = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.31, 1.0);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.32, 0.85);
	rmAddTradeRouteWaypoint(tradeRouteID5A, 0.4, 0.62);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.45, 0.51);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.45, 0.49);
	rmAddTradeRouteWaypoint(tradeRouteID5A, 0.4, 0.38);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.32, 0.15);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.31, 0.0);
   }
   else if (axisChance == 2) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID5A, 1.0, 0.31);
	rmAddTradeRouteWaypoint(tradeRouteID5A, 0.85, 0.32);
	rmAddTradeRouteWaypoint(tradeRouteID5A, 0.62, 0.4);
	rmAddTradeRouteWaypoint(tradeRouteID5A, 0.51, 0.45);
	rmAddTradeRouteWaypoint(tradeRouteID5A, 0.49, 0.45);
	rmAddTradeRouteWaypoint(tradeRouteID5A, 0.38, 0.4);
	rmAddTradeRouteWaypoint(tradeRouteID5A, 0.15, 0.32);
	rmAddTradeRouteWaypoint(tradeRouteID5A, 0.0, 0.31);
   }
   rmBuildTradeRoute(tradeRouteID5A, "dirt");
}
else if (trPattern > 5)  // one diagonal
{
   int tradeRouteID6 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.5, 0.0);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.48, 0.2);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.52, 0.35);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.5, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.48, 0.55);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.52, 0.8);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.5, 1.0);
   }
   else
   {
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.0, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.2, 0.48);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.35, 0.52);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.5, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.65, 0.48);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.8, 0.52);
	rmAddTradeRouteWaypoint(tradeRouteID6, 1.0, 0.5);
   }
   rmBuildTradeRoute(tradeRouteID6, "carolinas\trade_route");	
}
else if (trPattern == 1) // two parabolas convex toward players
{
   // first route
   int tradeRouteID7 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.5, 1.0);	
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.59, 0.82);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.68, 0.55);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.7, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.68, 0.45);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.59, 0.18);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.5, 0.0);
   }
   else 
   {	
	rmAddTradeRouteWaypoint(tradeRouteID7, 1.0, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.82, 0.59);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.60, 0.68);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.5, 0.7);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.40, 0.68);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.18, 0.59);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.0, 0.5);
   }
   rmBuildTradeRoute(tradeRouteID7, "dirt");

   // second route
   int tradeRouteID7A = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.5, 0.0);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.41, 0.18);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.32, 0.45);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.3, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.32, 0.55);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.41, 0.82);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.5, 1.0);
   }
   else
   {
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.0, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.18, 0.41);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.40, 0.32);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.5, 0.3);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.60, 0.32);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.82, 0.41);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 1.0, 0.5);
   }
   rmBuildTradeRoute(tradeRouteID7A, "carolinas\trade_route");	
}

// Trade sockets
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 6.0);

if (trPattern == 2) // 2 opposite inner semicircular routes
{
   // add the meeting poles along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.17);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.83);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // change the trade route for the new sockets
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID2);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.83);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.17);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
}
else if (trPattern == 3) // inner circle
{
   if (socketPattern == 1)
   {
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID3);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.09);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.25);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.41);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.59);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.75);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.91);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else if (socketPattern == 2)
   {
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID3);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.15);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.35);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.65);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.85);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
}
else if (trPattern == 4) //  2 diagonal
{
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID4);

   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.12);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
      if (cNumberNonGaiaPlayers > 3)
	{
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.5);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.88);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else
   {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.17);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.83);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }

   // change the trade route for the new sockets
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID4A);
   if (socketPattern == 1)
   {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.88);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
      if (cNumberNonGaiaPlayers > 3)
	{
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.5);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
      }
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.12);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else
   {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.83);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.17);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
}
else if (trPattern == 5) //  two parabolas concave toward players
{
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID5);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5, 0.17);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5, 0.83);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // change the trade route for the new sockets
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID5A);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5A, 0.83);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5A, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5A, 0.17);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
}
else if(trPattern == 6) // one diagonal, more sockets
{
   if (socketPattern == 1)
   {
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID6);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.09);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.25);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.41);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.59);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.75);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.91);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else if (socketPattern == 2)
   {
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID6);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.12);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.31);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.69);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.88);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
}
else if(trPattern == 7) // one diagonal, fewer sockets
{
   if (socketPattern == 1)
   {
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID6);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.25);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.41);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.59);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.75);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else if (socketPattern == 2)
   {
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID6);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.16);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.84);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
}
else if (trPattern == 1) // two parabolas convex toward players
{
   // add the meeting poles along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID7);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID7, 0.21);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID7, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID7, 0.79);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // change the trade route for the new sockets
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID7A);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID7A, 0.79);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID7A, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID7A, 0.21);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
}

// Text
   rmSetStatusText("",0.25);
	
// Set up player areas.
   float playerFraction=rmAreaTilesToFraction(1800);
   for(i=1; <cNumberPlayers)
   {
      int id=rmCreateArea("Player"+i);
      rmSetPlayerArea(i, id);
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmAddAreaToClass(id, rmClassID("classCliff"));
      rmAddAreaToClass(id, rmClassID("classMountain"));
      rmAddAreaConstraint(id, avoidMts);
      rmAddAreaConstraint(id, playerEdgeConstraint);
      rmAddAreaConstraint(id, circleConstraint);
	rmAddAreaConstraint(id, avoidTradeRoute);
	rmAddAreaConstraint(id, avoidSocket);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmSetAreaCoherence(id, 0.8);
      rmSetAreaSmoothDistance(id, 7);
      rmSetAreaCliffType(id, cliffType);
      rmSetAreaCliffEdge(id, 2, 0.45, 0.1, 1.0, 1);
      rmSetAreaCliffPainting(id, false, true, true, 1.5, true);
      rmSetAreaMix(id, baseType);
      rmSetAreaCliffHeight(id, 6, 1.0, 0.5);
      rmSetAreaLocPlayer(id, i);
      rmSetAreaWarnFailure(id, false);
   }
   rmBuildAllAreas();

// player area patch for snowy start areas
if ((patternChance == 8) || (patternChance == 19)) 
{
   for(i=1; <cNumberPlayers)
   {
      int idSub=rmCreateArea("Player patch"+i, rmAreaID("Player"+i));
      rmSetAreaSize(idSub, playerFraction, playerFraction);
      rmSetAreaCoherence(idSub, 0.9);
	if (patternChance == 19)
	{
		rmSetAreaTerrainType(idSub, "rockies\groundsnow1_roc");
            rmAddAreaTerrainLayer(idSub, "patagonia\ground_snow1_pat", 0, 6);
            rmAddAreaTerrainLayer(idSub, "patagonia\ground_snow2_pat", 6, 10);
	}
	else if (patternChance == 8)
	{
            rmSetAreaTerrainType(idSub, "rockies\groundsnow1_roc");
            rmAddAreaTerrainLayer(idSub, "rockies\groundsnow8_roc", 0, 4);
            rmAddAreaTerrainLayer(idSub, "rockies\groundsnow7_roc", 4, 7);
            rmAddAreaTerrainLayer(idSub, "rockies\groundsnow6_roc", 7, 10);
	}
      rmSetAreaWarnFailure(idSub, false);
   }
   rmBuildAllAreas();
}

   //Text
   rmSetStatusText("",0.30);

// Starting TCs and units 		
   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 10.0);
   rmSetObjectDefMaxDistance(startingUnits, 15.0);
   rmAddObjectDefConstraint(startingUnits, avoidAll);

   int startingTCID= rmCreateObjectDef("startingTC");
   rmSetObjectDefMinDistance(startingTCID, 0.0);
   rmSetObjectDefMaxDistance(startingTCID, 10.0);
   rmAddObjectDefConstraint(startingTCID, avoidAll);
   rmAddObjectDefConstraint(startingTCID, longAvoidImpassableLand );               
   if ( rmGetNomadStart())
   {
	rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
   }
   else
   {
      rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
   }

   // mines
   int silverType = -1;
   silverType = rmRandInt(1,10);
   int playerSilverID = rmCreateObjectDef("player silver");
   rmAddObjectDefItem(playerSilverID, "mine", 1, 0);
   rmSetObjectDefMinDistance(playerSilverID, 18.0);
   rmSetObjectDefMaxDistance(playerSilverID, 22.0);
   rmAddObjectDefConstraint(playerSilverID, avoidAll);
   rmAddObjectDefConstraint(playerSilverID, shortAvoidImpassableLand);

   silverType = rmRandInt(1,10);
   int GoldMediumID=rmCreateObjectDef("player silver med");
   if (mineChance == 3)
      rmAddObjectDefItem(GoldMediumID, "minegold", 1, 0);
   else
      rmAddObjectDefItem(GoldMediumID, "mine", 1, 0);
   rmAddObjectDefConstraint(GoldMediumID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldMediumID, avoidSocket);
   rmAddObjectDefConstraint(GoldMediumID, coinAvoidCoin);
   rmAddObjectDefConstraint(GoldMediumID, mediumPlayerConstraint);
   rmAddObjectDefConstraint(GoldMediumID, circleConstraint);
   rmAddObjectDefConstraint(GoldMediumID, avoidAll);
   rmSetObjectDefMinDistance(GoldMediumID, 50.0);
   rmSetObjectDefMaxDistance(GoldMediumID, 70.0);

   // Player Nuggets
   int playerNuggetID=rmCreateObjectDef("player nugget");
   rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
   rmAddObjectDefToClass(playerNuggetID, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(playerNuggetID, 32.0);
   rmSetObjectDefMaxDistance(playerNuggetID, 38.0);
   rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerNuggetID, avoidSocket);
   rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
   rmAddObjectDefConstraint(playerNuggetID, avoidWater10);

   // berry bushes
   int berryNum = rmRandInt(3,5);
   int StartBerryBushID=rmCreateObjectDef("starting berry bush");
   rmAddObjectDefItem(StartBerryBushID, "BerryBush", berryNum, 4.0);
   rmSetObjectDefMinDistance(StartBerryBushID, 10.0);
   rmSetObjectDefMaxDistance(StartBerryBushID, 16.0);
   rmAddObjectDefConstraint(StartBerryBushID, avoidStartingUnitsSmall);

   // start area huntable
   int deerNum = rmRandInt(5, 8);
   int startPronghornID=rmCreateObjectDef("starting pronghorn");
   rmAddObjectDefItem(startPronghornID, deerType, deerNum, 5.0);
   rmAddObjectDefToClass(startPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(startPronghornID, 16);
   rmSetObjectDefMaxDistance(startPronghornID, 22);
   rmAddObjectDefConstraint(startPronghornID, avoidStartResource);
   rmAddObjectDefConstraint(startPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(startPronghornID, avoidAll);
   rmSetObjectDefCreateHerd(startPronghornID, true);

   // starting outpost wagons
   int startingOutpostID = rmCreateObjectDef("initial outpost wagon");
   rmAddObjectDefItem(startingOutpostID, "OutpostWagon", 2, 2.0);
   rmSetObjectDefMinDistance(startingOutpostID, 5.0);
   rmSetObjectDefMaxDistance(startingOutpostID, 10.0);
   rmAddObjectDefConstraint(startingOutpostID, avoidAll);

  int playerCastle=rmCreateObjectDef("Castle");
  rmAddObjectDefItem(playerCastle, "ypCastleRegicide", 1, 0.0);
  rmAddObjectDefConstraint(playerCastle, avoidAll);
  rmAddObjectDefConstraint(playerCastle, avoidImpassableLand);
	rmSetObjectDefMinDistance(playerCastle, 15.0);	
	rmSetObjectDefMaxDistance(playerCastle, 20.0);
  
  int playerDaimyo=rmCreateObjectDef("Daimyo"+i);
  rmAddObjectDefItem(playerDaimyo, "ypDaimyoRegicide", 1, 0.0);
  rmAddObjectDefConstraint(playerDaimyo, avoidAll);
  rmSetObjectDefMinDistance(playerDaimyo, 7.0);	
  rmSetObjectDefMaxDistance(playerDaimyo, 10.0);

   for(i=1; <cNumberPlayers)
   {	
      rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(playerDaimyo, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if (rmGetNomadStart() == false)
		{
      		rmPlaceObjectDefAtLoc(playerCastle, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		}

      rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(playerSilverID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(playerSilverID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(GoldMediumID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(startPronghornID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
 	rmSetNuggetDifficulty(1, 1);
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      if (placeBerries == 1)
	{
	   rmPlaceObjectDefInArea(StartBerryBushID, 0, rmAreaID("player"+i), 1);
	}
   }

// Text
   rmSetStatusText("",0.35);

// Central features & patches, per map or variant
   // Center area
   int centerArea=rmCreateArea("TheCenter");
   rmSetAreaSize(centerArea, 0.2, 0.2);
   rmSetAreaLocation(centerArea, 0.5, 0.5);
   rmAddAreaToClass(centerArea, rmClassID("center")); 

   // Center Highland or Canyon
   int makeCentralCliffArea = -1;
   if (makeCentralHighlands == 1)
	makeCentralCliffArea = 1;
   if (makeCentralCanyon == 1)
 	makeCentralCliffArea = 1;

   if (makeCentralCliffArea == 1)
   {
      int edgeChance = rmRandInt(1,3);
      reducedForest = 1;
      int centerHighlandsID=rmCreateArea("center highlands");
      rmSetAreaLocation(centerHighlandsID, 0.5, 0.5);
      rmSetAreaSize(centerHighlandsID, 0.05, 0.05);
      rmAddAreaToClass(centerHighlandsID, rmClassID("classCliff"));
      if (patternChance == 12)
         rmSetAreaMix(centerHighlandsID, "texas_dirt");
      else if (patternChance == 8)
	   rmSetAreaTerrainType(centerHighlandsID, "rockies\groundsnow1_roc");
	else 
         rmSetAreaMix(centerHighlandsID, baseType);
      rmSetAreaCliffType(centerHighlandsID, cliffType);
      rmSetAreaCliffPainting(centerHighlandsID, false, true, true, 1.5, true);
	if (edgeChance == 1)
         rmSetAreaCliffEdge(centerHighlandsID, 3, 0.29, 0.1, 0.5, 0);
	else if (edgeChance == 2)
         rmSetAreaCliffEdge(centerHighlandsID, 4, 0.21, 0.1, 0.5, 0);
	else if (edgeChance == 3)
         rmSetAreaCliffEdge(centerHighlandsID, 2, 0.45, 0.1, 0.5, 0);

	if (makeCentralHighlands == 1)
	   rmSetAreaCliffHeight(centerHighlandsID, rmRandInt(5,6), 1.0, 0.5);
	else if (makeCentralCanyon == 1)
	   rmSetAreaCliffHeight(centerHighlandsID, -5, 1.0, 0.5);
      rmSetAreaSmoothDistance(centerHighlandsID, 12);
      rmSetAreaCoherence(centerHighlandsID, 0.5);
	rmSetAreaHeightBlend(centerHighlandsID, 1.0);
      rmAddAreaConstraint(centerHighlandsID, avoidTradeRoute);
      rmAddAreaConstraint(centerHighlandsID, avoidSocket);
      rmBuildArea(centerHighlandsID);
      makeLake = 0;
   }

   // Center mountains
   int numMt = -1;
   if (mtPattern == 1)
 	numMt = 1;
   else if (mtPattern == 2)
 	numMt = 2;	   
   else
 	numMt = rmRandInt(4,7);

   if (centerMt == 1)
   {
      reducedForest = 1;

	for (i=0; <numMt)   
      { 
         int mtPatchID = rmCreateArea("mt patch"+i); 
         rmAddAreaToClass(mtPatchID, rmClassID("classHill"));
         rmAddAreaToClass(mtPatchID, rmClassID("classPatch"));
 	   if (patternChance == 8) // Rockies
	   {
            rmSetAreaTerrainType(mtPatchID, "rockies\groundsnow1_roc");
            rmAddAreaTerrainLayer(mtPatchID, "rockies\groundsnow8_roc", 0, 3);
            rmAddAreaTerrainLayer(mtPatchID, "rockies\groundsnow7_roc", 3, 5);
            rmAddAreaTerrainLayer(mtPatchID, "rockies\groundsnow6_roc", 5, 7);
	   }
	   if (patternChance == 17)  // Yukon Tundra
	   {
            rmSetAreaTerrainType(mtPatchID, "yukon\ground1_yuk");
            rmAddAreaTerrainLayer(mtPatchID, "yukon\ground5_yuk", 0, 2);
            rmAddAreaTerrainLayer(mtPatchID, "yukon\ground4_yuk", 2, 4);
            rmAddAreaTerrainLayer(mtPatchID, "yukon\ground8_yuk", 4, 6);
	   }
	   if (patternChance == 19) // Andes
	   {
            rmSetAreaTerrainType(mtPatchID, "rockies\groundsnow1_roc");
            rmAddAreaTerrainLayer(mtPatchID, "patagonia\ground_snow1_pat", 0, 4);
            rmAddAreaTerrainLayer(mtPatchID, "patagonia\ground_snow2_pat", 4, 7);
            rmAddAreaTerrainLayer(mtPatchID, "patagonia\ground_snow2_pat", 7, 10);
	   }
 	   if (patternChance == 7) // Yukon
	   {
            rmSetAreaTerrainType(mtPatchID, "rockies\groundsnow1_roc");
	   }
         rmSetAreaWarnFailure(mtPatchID, false);

 	   if (mtPattern == 1)
	   {
            rmSetAreaSize(mtPatchID, 0.035, 0.045);
            rmSetAreaLocation(mtPatchID, 0.5, 0.5);
		if (variantChance == 1)
		{
               rmSetAreaMinBlobs(mtPatchID, 6);
               rmSetAreaMaxBlobs(mtPatchID, 14);
               rmSetAreaMinBlobDistance(mtPatchID, 30.0);
               rmSetAreaMaxBlobDistance(mtPatchID, 45.0);
		}
	   }
 	   if (mtPattern == 2)
	   {
            rmSetAreaSize(mtPatchID, 0.018, 0.023);
		if (variantChance == 1)
		{
               rmSetAreaMinBlobs(mtPatchID, 6);
               rmSetAreaMaxBlobs(mtPatchID, 12);
               rmSetAreaMinBlobDistance(mtPatchID, 26.0);
               rmSetAreaMaxBlobDistance(mtPatchID, 40.0);
		}
	   }
	   else if (mtPattern == 3)
	   {
            rmSetAreaMinBlobs(mtPatchID, 4);
            rmSetAreaMaxBlobs(mtPatchID, 6);
            rmSetAreaMinBlobDistance(mtPatchID, 15.0);
            rmSetAreaMaxBlobDistance(mtPatchID, 20.0);
            rmSetAreaSize(mtPatchID, rmAreaTilesToFraction(600), rmAreaTilesToFraction(1100));
	   }
	   else if (mtPattern == 4)
	   {
            rmSetAreaMinBlobs(mtPatchID, 1);
            rmSetAreaMaxBlobs(mtPatchID, 3);
            rmSetAreaMinBlobDistance(mtPatchID, 30.0);
            rmSetAreaMaxBlobDistance(mtPatchID, 40.0);
            rmSetAreaSize(mtPatchID, rmAreaTilesToFraction(600), rmAreaTilesToFraction(1100));
	   }
         rmSetAreaElevationType(mtPatchID, cElevTurbulence);
	   rmSetAreaElevationVariation(mtPatchID, rmRandInt(2, 3));
	   rmSetAreaCoherence(mtPatchID, rmRandFloat(0.4, 0.8));
	   rmSetAreaBaseHeight(mtPatchID, rmRandInt(8, 10));
	   rmSetAreaElevationPersistence(mtPatchID, rmRandFloat(0.5, 0.8));
	   if (rmRandInt(1,3) == 3)
            rmSetAreaSmoothDistance(mtPatchID, rmRandInt(8, 20));
         rmAddAreaConstraint(mtPatchID, avoidTradeRoute);
         rmAddAreaConstraint(mtPatchID, avoidSocket);
         rmAddAreaConstraint(mtPatchID, medHillConstraint);
         rmAddAreaConstraint(mtPatchID, circleConstraintMt);
         rmAddAreaConstraint(mtPatchID, mediumPlayerConstraint);
         rmBuildArea(mtPatchID);
      }
   }
  
   if (forestMt == 1) // green hill forest
   {
      reducedForest = 1;
	for (i=0; <numMt)   
      { 	
         int hillPatchID = rmCreateArea("green hill"+i); 
         rmAddAreaToClass(hillPatchID, rmClassID("classHill"));
         rmAddAreaToClass(hillPatchID, rmClassID("classPatch"));
         rmSetAreaWarnFailure(hillPatchID, false);
         rmSetAreaForestType(hillPatchID, forestType);
         rmSetAreaForestDensity(hillPatchID, rmRandFloat(0.3, 0.5));
         rmSetAreaForestClumpiness(hillPatchID, rmRandFloat(0.5, 0.8));
         rmSetAreaForestUnderbrush(hillPatchID, rmRandFloat(0.0, 0.3));
 	   if (mtPattern == 1)
	   {
            rmSetAreaSize(hillPatchID, 0.035, 0.045);
            rmSetAreaLocation(hillPatchID, 0.5, 0.5);
		if (variantChance == 1)
		{
               rmSetAreaMinBlobs(hillPatchID, 6);
               rmSetAreaMaxBlobs(hillPatchID, 12);
               rmSetAreaMinBlobDistance(hillPatchID, 32.0);
               rmSetAreaMaxBlobDistance(hillPatchID, 45.0);
		}
	   }
 	   else if (mtPattern == 2)
	   {
            rmSetAreaSize(hillPatchID, 0.018, 0.023);
		if (variantChance == 1)
		{
               rmSetAreaMinBlobs(hillPatchID, 6);
               rmSetAreaMaxBlobs(hillPatchID, 14);
               rmSetAreaMinBlobDistance(hillPatchID, 26.0);
               rmSetAreaMaxBlobDistance(hillPatchID, 40.0);
		}
	   }
	   else if (mtPattern == 3)
	   {
            rmSetAreaMinBlobs(hillPatchID, 4);
            rmSetAreaMaxBlobs(hillPatchID, 6);
            rmSetAreaMinBlobDistance(hillPatchID, 15.0);
            rmSetAreaMaxBlobDistance(hillPatchID, 20.0);
            rmSetAreaSize(hillPatchID, rmAreaTilesToFraction(500), rmAreaTilesToFraction(1100));
	   }
	   else if (mtPattern == 4)
	   {
            rmSetAreaMinBlobs(hillPatchID, 1);
            rmSetAreaMaxBlobs(hillPatchID, 3);
            rmSetAreaMinBlobDistance(hillPatchID, 30.0);
            rmSetAreaMaxBlobDistance(hillPatchID, 40.0);
            rmSetAreaSize(hillPatchID, rmAreaTilesToFraction(500), rmAreaTilesToFraction(1100));
	   }
         rmSetAreaElevationType(hillPatchID, cElevTurbulence);
         rmSetAreaElevationVariation(hillPatchID, rmRandInt(2, 3));
	   rmSetAreaElevationPersistence(hillPatchID, rmRandFloat(0.5, 0.8));
         rmSetAreaCoherence(hillPatchID, rmRandFloat(0.4, 0.8));
         rmSetAreaBaseHeight(hillPatchID, rmRandInt(8,10));
	   if (rmRandInt(1,3) == 3)
            rmSetAreaSmoothDistance(hillPatchID, rmRandInt(10, 20));
         rmAddAreaConstraint(hillPatchID, avoidTradeRoute);
         rmAddAreaConstraint(hillPatchID, avoidSocket);
         rmAddAreaConstraint(hillPatchID, longHillConstraint);
         rmAddAreaConstraint(hillPatchID, circleConstraintMt);
         rmAddAreaConstraint(hillPatchID, mediumPlayerConstraint);
         rmBuildArea(hillPatchID);
	}  
   }

   // Snow patch for Rockies, central highlands
   if (patternChance == 8)  // Rockies
   {
	if (makeCentralCliffArea == 1)
	{
         int snowPatch2ID = rmCreateArea("snow patch 2"); 
         rmAddAreaToClass(snowPatch2ID, rmClassID("classHill"));
         rmAddAreaToClass(snowPatch2ID, rmClassID("classPatch"));
         rmSetAreaLocation(snowPatch2ID, 0.5, 0.5); 
         rmSetAreaWarnFailure(snowPatch2ID, false);
         rmSetAreaSize(snowPatch2ID, 0.048, 0.049);
         rmSetAreaElevationType(snowPatch2ID, cElevTurbulence);
	   rmSetAreaElevationVariation(snowPatch2ID, rmRandInt(2, 3));
	   rmSetAreaCoherence(snowPatch2ID, rmRandFloat(0.4, 0.8));
	   if (rmRandInt(1,3) == 3)
            rmSetAreaSmoothDistance(snowPatch2ID, rmRandInt(8, 20));
         rmSetAreaTerrainType(snowPatch2ID, "rockies\groundsnow1_roc");
         rmAddAreaTerrainLayer(snowPatch2ID, "rockies\groundsnow8_roc", 0, 5);
         rmAddAreaTerrainLayer(snowPatch2ID, "rockies\groundsnow7_roc", 5, 9);
         rmAddAreaTerrainLayer(snowPatch2ID, "rockies\groundsnow6_roc", 9, 13);
         rmAddAreaConstraint(snowPatch2ID, avoidTradeRoute);
         rmAddAreaConstraint(snowPatch2ID, avoidSocket);
         rmBuildArea(snowPatch2ID); 
	}
   }

   // Ice patch - Great Lakes Winter, Yukon or Yukon Tundra
   if (makeIce == 1)
   {
      nativeNumber = 2;
      int icePatchID = rmCreateArea("ice patch"); 
      rmAddAreaToClass(icePatchID, rmClassID("classIce"));
      rmAddAreaToClass(icePatchID, rmClassID("center"));
	if (variantChance == 2)
	   rmAddAreaToClass(icePatchID, rmClassID("classHill"));
      rmSetAreaLocation(icePatchID, 0.5, 0.5); 
      rmSetAreaWarnFailure(icePatchID, false);
      rmSetAreaSize(icePatchID, 0.035, 0.05);
      rmSetAreaCoherence(icePatchID, rmRandFloat(0.6,0.9));
      rmSetAreaMix(icePatchID, "great_lakes_ice");
      rmSetAreaBaseHeight(icePatchID, 1.0);
      rmSetAreaElevationVariation(icePatchID, 0.0);
      rmAddAreaConstraint(icePatchID, avoidTradeRoute);
      rmAddAreaConstraint(icePatchID, avoidSocket);
      rmBuildArea(icePatchID); 
	
	int iceHole = rmRandInt(1,2); 
	if (iceHole == 1)
	{
         int waterPatchID = rmCreateArea("water patch", rmAreaID("ice patch")); 
         rmAddAreaToClass(waterPatchID, rmClassID("classPatch"));
         rmSetAreaWarnFailure(waterPatchID, false);
         rmSetAreaSize(waterPatchID, 0.009, 0.024);
         rmSetAreaCoherence(waterPatchID, rmRandFloat(0.2,0.8));
         rmSetAreaWaterType(waterPatchID, "great lakes ice");
         rmSetAreaBaseHeight(waterPatchID, 1.0);
         rmBuildArea(waterPatchID); 
	}
   }

   // Center lake      
   if (makeLake == 1)
   {
	int lakePattern = rmRandInt(1,3);
      nativeNumber = 2;
	int smalllakeID=rmCreateArea("small lake");
      rmSetAreaLocation(smalllakeID, 0.5, 0.5);
      rmSetAreaWaterType(smalllakeID, pondType);
      rmSetAreaBaseHeight(smalllakeID, baseHt);
	if (lakePattern == 1)
	{
	   if (patternChance == 3)
            rmSetAreaSize(smalllakeID, rmAreaTilesToFraction(1300), rmAreaTilesToFraction(2000));
	   else
            rmSetAreaSize(smalllakeID, rmAreaTilesToFraction(1000), rmAreaTilesToFraction(1500));
         rmSetAreaMinBlobs(smalllakeID, 1);
         rmSetAreaMaxBlobs(smalllakeID, 3);
         rmSetAreaMinBlobDistance(smalllakeID, 12.0);
         rmSetAreaMaxBlobDistance(smalllakeID, 18.0);
         rmSetAreaCoherence(smalllakeID, rmRandFloat(0.4,0.8));
	}
	else if (lakePattern == 2)
	{
	   if (patternChance == 3)
            rmSetAreaSize(smalllakeID, rmAreaTilesToFraction(1300), rmAreaTilesToFraction(2000));
	   else
            rmSetAreaSize(smalllakeID, rmAreaTilesToFraction(1000), rmAreaTilesToFraction(1500));
         rmSetAreaMinBlobs(smalllakeID, 5);
         rmSetAreaMaxBlobs(smalllakeID, 12);
         rmSetAreaMinBlobDistance(smalllakeID, 25.0);
         rmSetAreaMaxBlobDistance(smalllakeID, 35.0);
         rmSetAreaCoherence(smalllakeID, rmRandFloat(0.2,0.5));
	}
	else if (lakePattern == 3)
	{
	   if (patternChance == 3)
            rmSetAreaSize(smalllakeID, rmAreaTilesToFraction(1300), rmAreaTilesToFraction(2000));
	   else
            rmSetAreaSize(smalllakeID, rmAreaTilesToFraction(1000), rmAreaTilesToFraction(1500));
         rmSetAreaMinBlobs(smalllakeID, 3);
         rmSetAreaMaxBlobs(smalllakeID, 8);
         rmSetAreaMinBlobDistance(smalllakeID, 28.0);
         rmSetAreaMaxBlobDistance(smalllakeID, 40.0);
         rmSetAreaCoherence(smalllakeID, rmRandFloat(0.2,0.3));
	}
      rmAddAreaToClass(smalllakeID, lakeClass);
      rmAddAreaConstraint(smalllakeID, mediumPlayerConstraint);
      rmAddAreaConstraint(smalllakeID, avoidTradeRoute);
      rmAddAreaConstraint(smalllakeID, avoidSocket);
      rmSetAreaWarnFailure(smalllakeID, false);
      rmBuildArea(smalllakeID);
   }

   // Dirt patches for Sonora
   if (patternChance == 13)
   {
	for (i=0; <cNumberNonGaiaPlayers*5)   
      {
		int dirtPatch=rmCreateArea("open dirt patch "+i);
		rmSetAreaWarnFailure(dirtPatch, false);
		rmSetAreaSize(dirtPatch, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
		rmSetAreaTerrainType(dirtPatch, "sonora\ground7_son");
		rmAddAreaToClass(dirtPatch, rmClassID("classPatch"));
		rmSetAreaMinBlobs(dirtPatch, 1);
		rmSetAreaMaxBlobs(dirtPatch, 5);
		rmSetAreaMinBlobDistance(dirtPatch, 16.0);
		rmSetAreaMaxBlobDistance(dirtPatch, 40.0);
		rmSetAreaCoherence(dirtPatch, 0.0);
		rmSetAreaSmoothDistance(dirtPatch, 10);
		rmAddAreaConstraint(dirtPatch, shortAvoidImpassableLand);
		rmAddAreaConstraint(dirtPatch, patchConstraint);
		rmBuildArea(dirtPatch); 
      }
   }

   // Snow patches for Yukon Tundra
   if (patternChance == 17)
   { 
      for(i=1; <cNumberPlayers*4)
      {
      int patchAID=rmCreateArea("PatchA"+i);
      rmSetAreaSize(patchAID, rmAreaTilesToFraction(175), rmAreaTilesToFraction(250));
      rmAddAreaToClass(patchAID, rmClassID("classPatch"));
      rmSetAreaTerrainType(patchAID, "yukon\ground1_yuk");
      rmAddAreaTerrainLayer(patchAID, "yukon\ground5_yuk", 0, 2);
      rmAddAreaTerrainLayer(patchAID, "yukon\ground4_yuk", 2, 3);
      rmAddAreaTerrainLayer(patchAID, "yukon\ground8_yuk", 3, 4);
      rmSetAreaWarnFailure(patchAID, false);
      rmSetAreaMinBlobs(patchAID, 2);
      rmSetAreaMaxBlobs(patchAID, 3);
      rmSetAreaMinBlobDistance(patchAID, 10.0);
      rmSetAreaMaxBlobDistance(patchAID, 20.0);
      rmSetAreaCoherence(patchAID, 0.3);
      rmAddAreaConstraint(patchAID, mediumPlayerConstraint);
      rmAddAreaConstraint(patchAID, shortAvoidImpassableLand);
      rmAddAreaConstraint(patchAID, patchConstraint);
      rmSetAreaWarnFailure(patchAID, false);
      rmBuildArea(patchAID);
      }
   }

// Text
   rmSetStatusText("",0.40);

// NATIVE AMERICANS
   // Village A 
   int villageAID = -1;
   int whichNative = rmRandInt(1,2);
   int villageType = rmRandInt(1,5);

   if (nativePattern == 1)
   {
      if (whichNative == 1)
      {
	villageAID = rmCreateGrouping("village A", "native zen temple cj 0"+villageType);
      }
      else if (whichNative == 2)
      {
	villageAID = rmCreateGrouping("village A", "native jesuit mission cj 0"+villageType);
      }
   }

   if (nativePattern == 2)
   {
      if (whichNative == 1)
      {
	villageAID = rmCreateGrouping("village A", "native jesuit mission cj 0"+villageType);
      }
      else if (whichNative == 2)
      {
	villageAID = rmCreateGrouping("village A", "native zen temple cj 0"+villageType);
      }
   }
   rmAddGroupingToClass(villageAID, rmClassID("natives"));
   rmAddGroupingToClass(villageAID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageAID, 0.0);
   rmSetGroupingMaxDistance(villageAID, rmXFractionToMeters(0.14));
   rmAddGroupingConstraint(villageAID, avoidImpassableLand);
   rmAddGroupingConstraint(villageAID, avoidTradeRoute);
   rmAddGroupingConstraint(villageAID, avoidSocket);
   rmAddGroupingConstraint(villageAID, avoidWater10);
   rmAddGroupingConstraint(villageAID, avoidNativesMed);
   rmAddGroupingConstraint(villageAID, mediumPlayerConstraint);
   rmAddGroupingConstraint(villageAID, avoidIce);

   // Village D - opposite type from A 
   int villageDID = -1;
   villageType = rmRandInt(1,5);

   if (nativePattern == 1)
   {
      if (whichNative == 2)
      {
	villageDID = rmCreateGrouping("village D", "native jesuit mission cj 0"+villageType);
      }
      else if (whichNative == 1)
      {
	villageDID = rmCreateGrouping("village D", "native zen temple cj 0"+villageType);
      }
   }

   if (nativePattern == 2)
   {
      if (whichNative == 2)
      {
	villageDID = rmCreateGrouping("village D", "native zen temple cj 0"+villageType);
      }
      else if (whichNative == 1)
      {
	villageDID = rmCreateGrouping("village D", "native jesuit mission cj 0"+villageType);
      }
   }
   rmAddGroupingToClass(villageDID, rmClassID("natives"));
   rmAddGroupingToClass(villageDID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageDID, 0.0);
   rmSetGroupingMaxDistance(villageDID, rmXFractionToMeters(0.14));
   rmAddGroupingConstraint(villageDID, avoidImpassableLand);
   rmAddGroupingConstraint(villageDID, avoidTradeRoute);
   rmAddGroupingConstraint(villageDID, avoidSocket);
   rmAddGroupingConstraint(villageDID, avoidWater10);
   rmAddGroupingConstraint(villageDID, avoidNativesMed);
   rmAddGroupingConstraint(villageDID, mediumPlayerConstraint);
   rmAddGroupingConstraint(villageDID, avoidIce);
   if (mtPattern > 2)
      rmAddGroupingConstraint(villageDID, shortHillConstraint);

   // Village B - randomly same or opposite village A
   int villageBID = -1;	
   villageType = rmRandInt(1,5);
   whichNative = rmRandInt(1,2);

   if (nativePattern == 1)
   {
      if (whichNative == 1)
      {
	villageBID = rmCreateGrouping("village B", "native jesuit mission cj 0"+villageType);
      }
      else if (whichNative == 2)
      {
	villageBID = rmCreateGrouping("village B", "native zen temple cj 0"+villageType);
      }
   }

   if (nativePattern == 2)
   {
      if (whichNative == 1)
      {
	villageBID = rmCreateGrouping("village B", "native zen temple cj 0"+villageType);
      }
      else if (whichNative == 2)
      {
	villageBID = rmCreateGrouping("village B", "native jesuit mission cj 0"+villageType);
      }
   }
   rmAddGroupingToClass(villageBID, rmClassID("importantItem"));
   rmAddGroupingToClass(villageBID, rmClassID("natives"));
   rmSetGroupingMinDistance(villageBID, 0.0);
   rmSetGroupingMaxDistance(villageBID, rmXFractionToMeters(0.14));
   rmAddGroupingConstraint(villageBID, avoidImpassableLand);
   rmAddGroupingConstraint(villageBID, avoidTradeRoute);
   rmAddGroupingConstraint(villageBID, avoidSocket);
   rmAddGroupingConstraint(villageBID, avoidWater15);
   rmAddGroupingConstraint(villageBID, avoidNatives);
   rmAddGroupingConstraint(villageBID, mediumPlayerConstraint);

   // Village C // appears in center, variable, randomly same or opposite A and B
   int villageCID = -1;	
   villageType = rmRandInt(1,5);
   whichNative = rmRandInt(1,2);

   if (nativePattern == 1)
   {
      if (whichNative == 1)
      {
	villageCID = rmCreateGrouping("village C", "native zen temple cj 0"+villageType);
      }
      else if (whichNative == 2)
      {
	villageCID = rmCreateGrouping("village C", "native jesuit mission cj 0"+villageType);
      }
   }

   if (nativePattern == 2)
   {
      if (whichNative == 1)
      {
	villageCID = rmCreateGrouping("village C", "native jesuit mission cj 0"+villageType);
      }
      else if (whichNative == 2)
      {
	villageCID = rmCreateGrouping("village C", "native zen temple cj 0"+villageType);
      }
   }
   rmAddGroupingToClass(villageCID, rmClassID("importantItem"));
   rmAddGroupingToClass(villageCID, rmClassID("natives"));
   rmSetGroupingMinDistance(villageCID, 0.0);
   rmSetGroupingMaxDistance(villageCID, rmXFractionToMeters(0.12));
   rmAddGroupingConstraint(villageCID, avoidImpassableLand);
   rmAddGroupingConstraint(villageCID, avoidWater10);
   rmAddGroupingConstraint(villageCID, avoidTradeRoute);
   rmAddGroupingConstraint(villageCID, avoidSocket);
   rmAddGroupingConstraint(villageCID, avoidNatives);
   rmAddGroupingConstraint(villageCID, mediumPlayerConstraint);
   if (mtPattern > 2)
      rmAddGroupingConstraint(villageCID, shortHillConstraint);

   // Placement of Native Americans
   if (trPattern == 2)
	endPosition = rmRandInt(2,3);
   if (trPattern == 3)
	endPosition = rmRandInt(2,3);
   if (nativeSetup < 4)
   {
      if (axisChance == 1)
	{
	   if (endPosition == 1)
            rmPlaceGroupingAtLoc(villageAID, 0, 0.505, 0.73);
	   else if (endPosition == 2)
            rmPlaceGroupingAtLoc(villageAID, 0, 0.495, 0.82);
	   else
            rmPlaceGroupingAtLoc(villageAID, 0, 0.505, 0.91);
	}	 
      else
	{
	   if (endPosition == 1)
            rmPlaceGroupingAtLoc(villageAID, 0, 0.73, 0.505);
	   else if (endPosition == 2)
            rmPlaceGroupingAtLoc(villageAID, 0, 0.82, 0.495);
	   else
            rmPlaceGroupingAtLoc(villageAID, 0, 0.91, 0.505);
	}
         
      if (axisChance == 1)
	{
	   if (endPosition == 1)
            rmPlaceGroupingAtLoc(villageBID, 0, 0.495, 0.27);
	   else if (endPosition == 2)
            rmPlaceGroupingAtLoc(villageBID, 0, 0.505, 0.18);
	   else
            rmPlaceGroupingAtLoc(villageBID, 0, 0.495, 0.10);
	}
      else
	{
	   if (endPosition == 1)
            rmPlaceGroupingAtLoc(villageBID, 0, 0.27, 0.495);
	   else if (endPosition == 2)
            rmPlaceGroupingAtLoc(villageBID, 0, 0.18, 0.505);
	   else
            rmPlaceGroupingAtLoc(villageBID, 0, 0.10, 0.495);
	}
         

	if (nativeSetup < 2)
	{
         if (nativeNumber > 2)
            rmPlaceGroupingAtLoc(villageCID, 0, 0.5, 0.5);
	}
	else 
	{
	   rmSetGroupingMaxDistance(villageCID, rmXFractionToMeters(0.085));
         if (nativeNumber > 2)
	   {
		if (axisChance == 1)
		{
               rmPlaceGroupingAtLoc(villageCID, 0, 0.485, 0.51);
               rmPlaceGroupingAtLoc(villageCID, 0, 0.515, 0.49);
	      }
		else
		{
               rmPlaceGroupingAtLoc(villageCID, 0, 0.51, 0.515);
               rmPlaceGroupingAtLoc(villageCID, 0, 0.49, 0.485);
	      }
	   }
	}
   }
   else if (nativeSetup > 5)
   {
	if (nativeSetup == 7)
	{
         if (axisChance == 1)
	   {
	      if (endPosition == 1)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.495, 0.75); 
	      else if (endPosition == 2)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.505, 0.84); 
	      else
               rmPlaceGroupingAtLoc(villageDID, 0, 0.495, 0.93); 
	   }
         else
	   {
	      if (endPosition == 1)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.75, 0.495);
	      else if (endPosition == 2)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.84, 0.505);
	      else
              rmPlaceGroupingAtLoc(villageDID, 0, 0.93, 0.495);
	   }
            

         if (axisChance == 1)
	   {
	      if (endPosition == 1)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.505, 0.25);
	      else if (endPosition == 2)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.495, 0.16);
	      else
               rmPlaceGroupingAtLoc(villageDID, 0, 0.055, 0.08);
	   }            
         else
	   {
	      if (endPosition == 1)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.25, 0.505);
	      else if (endPosition == 2)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.16, 0.495);
	      else
               rmPlaceGroupingAtLoc(villageDID, 0, 0.08, 0.505);
	   }
            
	}
	if (nativeSetup == 8)
	{
	   rmSetGroupingMaxDistance(villageDID, rmXFractionToMeters(0.065));
         if (nativeNumber > 2)
	   {
		if (axisChance == 1)
		{
               rmPlaceGroupingAtLoc(villageDID, 0, 0.485, 0.49);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.515, 0.51);
	      }
		else
		{
               rmPlaceGroupingAtLoc(villageDID, 0, 0.49, 0.515);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.51, 0.485);
	      }
	   }
	}

      for(i=1; <cNumberPlayers) 
      {
         rmSetGroupingMinDistance(villageAID, 55.0);
         rmSetGroupingMaxDistance(villageAID, 80.0);           
	   rmPlaceGroupingAtLoc(villageAID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	   if (nativeSetup == 9)
	   {
            rmSetGroupingMinDistance(villageDID, 55.0);
            rmSetGroupingMaxDistance(villageDID, 80.0);      
		rmPlaceGroupingAtLoc(villageDID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	   }
	   if (nativeSetup == 10)
		rmPlaceGroupingAtLoc(villageAID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      }
   }
   else if (nativeSetup > 3) // setup 4 and 5
   {
      if (axisChance == 1)
	{
	   if (endPosition == 1)
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.75);
		rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.25);
	   }
	   else if (endPosition == 2)
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.84);
            rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.16);
	   }
	   else
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.93);
		rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.08);
	   }
	}          
      else
	{
	   if (endPosition == 1)
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.75, 0.5);
	      rmPlaceGroupingAtLoc(villageAID, 0, 0.25, 0.5);
	   }
	   else if (endPosition == 2)
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.84, 0.5);
		rmPlaceGroupingAtLoc(villageAID, 0, 0.16, 0.5);
	   }
	   else
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.93, 0.5);
		rmPlaceGroupingAtLoc(villageAID, 0, 0.08, 0.5);
	   }
	}       
         
	if (nativeSetup == 4)
	{
	   if (axisChance == 1)
	   {

            rmPlaceGroupingAtLoc(villageDID, 0, 0.485, 0.51);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.515, 0.49);
         }
   	   else
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.51, 0.515);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.49, 0.485);
	   }
	}
   	rmSetGroupingMaxDistance(villageDID, rmXFractionToMeters(0.085));
      if (axisChance == 1)
	{
         if (sidePosition == 1)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.75, 0.5);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.25, 0.5);
	   }
	   else if (sidePosition == 2)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.84, 0.5);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.16, 0.5);
	   }
	   else
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.91, 0.5);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.09, 0.5);
	   }
      }
	else
	{
         if (sidePosition == 1)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.75);
		rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.25);
	   }	   
	   else if (sidePosition == 2)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.84);
		rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.16);
	   }
	   else
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.91);
		rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.09); 
         }
	}  
   }

// Text
   rmSetStatusText("",0.50);

// More Ponds for Bayou      
   if (patternChance == 3)
   {
	for (i=0; <cNumberNonGaiaPlayers*3)   
      {
	   int smallPond2ID=rmCreateArea("bigger small pond"+i);
	   rmSetAreaSize(smallPond2ID, rmAreaTilesToFraction(340), rmAreaTilesToFraction(460));
         rmSetAreaWaterType(smallPond2ID, pondType);
         rmSetAreaBaseHeight(smallPond2ID, baseHt);
         rmSetAreaMinBlobs(smallPond2ID, 5);
         rmSetAreaMaxBlobs(smallPond2ID, 7);
         rmSetAreaMinBlobDistance(smallPond2ID, 24.0);
         rmSetAreaMaxBlobDistance(smallPond2ID, 36.0);
         rmAddAreaToClass(smallPond2ID, lakeClass);
         rmAddAreaConstraint(smallPond2ID, avoidLakes);
         rmAddAreaConstraint(smallPond2ID, avoidNativesShort);
         rmAddAreaConstraint(smallPond2ID, playerConstraint);
         rmAddAreaConstraint(smallPond2ID, avoidTradeRoute);
         rmAddAreaConstraint(smallPond2ID, avoidSocket);
         rmAddAreaConstraint(smallPond2ID, avoidAll);
         rmAddAreaConstraint(smallPond2ID, centerConstraintFar);
         rmSetAreaCoherence(smallPond2ID, 0.1);
         rmSetAreaWarnFailure(smallPond2ID, false);
         rmBuildArea(smallPond2ID);
      }
	for (i=0; <cNumberNonGaiaPlayers*6)   
      {
	   int smallPondID=rmCreateArea("small pond"+i);
	   rmSetAreaSize(smallPondID, rmAreaTilesToFraction(180), rmAreaTilesToFraction(240));
         rmSetAreaWaterType(smallPondID, pondType);
         rmSetAreaBaseHeight(smallPondID, baseHt);
         rmSetAreaMinBlobs(smallPondID, 2);
         rmSetAreaMaxBlobs(smallPondID, 4);
         rmSetAreaMinBlobDistance(smallPondID, 6.0);
         rmSetAreaMaxBlobDistance(smallPondID, 12.0);
         rmAddAreaToClass(smallPondID, lakeClass);
         rmAddAreaConstraint(smallPondID, avoidLakes);
         rmAddAreaConstraint(smallPondID, avoidNativesShort);
         rmAddAreaConstraint(smallPondID, mediumPlayerConstraint);
         rmAddAreaConstraint(smallPondID, avoidTradeRoute);
         rmAddAreaConstraint(smallPondID, avoidSocket);
         rmAddAreaConstraint(smallPondID, avoidAll);
         rmAddAreaConstraint(smallPondID, centerConstraintFar);
         rmSetAreaCoherence(smallPondID, rmRandFloat(0.2,0.8));
         rmSetAreaWarnFailure(smallPondID, false);
         rmBuildArea(smallPondID);
      }
   }

// Cliffs
   int cliffHt = -1;
   int failCount=0;
   int numTries=cNumberNonGaiaPlayers*14;

   int anotherChance = -1;
   anotherChance = rmRandInt(0,1);

   if (makeCliffs == 2)
   {
     if (anotherChance == 1)
        makeCliffs = 1;
     else
        makeCliffs = 0;
   } 

   if (makeCentralCliffArea == 1)
   {
	numTries=cNumberNonGaiaPlayers*7;
	cliffVariety = rmRandInt(1,5);
   }

   if (makeCliffs == 1)
   { 
	if (patternChance == 13) // for Sonora only
	{
	   // bigger mesas
	   for(i=0; <numTries)
	   {
		int cliffHeight=rmRandInt(0,10);
		int mesaID=rmCreateArea("mesa"+i);
		rmSetAreaSize(mesaID, rmAreaTilesToFraction(25), rmAreaTilesToFraction(160)); 
		rmSetAreaWarnFailure(mesaID, false);
		rmSetAreaCliffType(mesaID, "Sonora");
		rmAddAreaToClass(mesaID, rmClassID("canyon"));
		rmAddAreaToClass(mesaID, rmClassID("classCliff"));	
		rmSetAreaCliffEdge(mesaID, 1, 1.0, 0.1, 1.0, 0);
		if (cliffHeight <= 7)
		  rmSetAreaCliffHeight(mesaID, rmRandInt(5,6), 1.0, 1.0);
		else
		  rmSetAreaCliffHeight(mesaID, -6, 1.0, 1.0);
		rmAddAreaConstraint(mesaID, avoidCanyons);
		rmSetAreaMinBlobs(mesaID, 3);
		rmSetAreaMaxBlobs(mesaID, 5);
		rmSetAreaMinBlobDistance(mesaID, 3.0);
		rmSetAreaMaxBlobDistance(mesaID, 5.0);
		rmSetAreaCoherence(mesaID, 0.5);
		rmAddAreaConstraint(mesaID, playerConstraint); 
		rmAddAreaConstraint(mesaID, avoidSocket);
		rmAddAreaConstraint(mesaID, avoidNativesShort);
		rmAddAreaConstraint(mesaID, avoidWater20);
		rmAddAreaConstraint(mesaID, avoidTradeRoute);
		rmAddAreaConstraint(mesaID, shortAvoidSilver);
		if(rmBuildArea(mesaID)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==2)
				break;
		}
		else
			failCount=0;
	   }
	// smaller mesas
      if (makeCentralCliffArea == 1)
	   numTries=cNumberNonGaiaPlayers*10;
      else
	   numTries=cNumberNonGaiaPlayers*14;

	   for(i=0; <numTries)
	   {
		int smallCliffHeight=rmRandInt(0,10);
		int smallMesaID=rmCreateArea("small mesa"+i);
		rmSetAreaSize(smallMesaID, rmAreaTilesToFraction(4), rmAreaTilesToFraction(8));  
		rmSetAreaWarnFailure(smallMesaID, false);
		rmSetAreaCliffType(smallMesaID, "Sonora");
		rmAddAreaToClass(smallMesaID, rmClassID("canyon"));
		rmAddAreaToClass(smallMesaID, rmClassID("classCliff"));	
		rmSetAreaCliffEdge(smallMesaID, 1, 1.0, 0.1, 1.0, 0);
		rmSetAreaCliffHeight(smallMesaID, rmRandInt(5,6), 1.0, 1.0);
		rmAddAreaConstraint(smallMesaID, shortAvoidCanyons);
		rmSetAreaMinBlobs(smallMesaID, 3);
		rmSetAreaMaxBlobs(smallMesaID, 5);
		rmSetAreaMinBlobDistance(smallMesaID, 3.0);
		rmSetAreaMaxBlobDistance(smallMesaID, 5.0);
		rmSetAreaCoherence(smallMesaID, 0.3);
		rmAddAreaConstraint(smallMesaID, mediumPlayerConstraint); 
		rmAddAreaConstraint(smallMesaID, avoidNativesShort); 
		rmAddAreaConstraint(smallMesaID, avoidSocket);
		rmAddAreaConstraint(smallMesaID, avoidWater10);
		rmAddAreaConstraint(smallMesaID, avoidTradeRoute);
		rmAddAreaConstraint(smallMesaID, shortAvoidSilver);
		if(rmBuildArea(smallMesaID)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==20)
				break;
		}
		else
			failCount=0;
	   }
	}
	else if (cliffVariety == 0) // a little like AOM Anatolia
	{
	   int gorgeHt=rmRandInt(-6,-5);
	   numTries = 2;
	   if (cNumberNonGaiaPlayers > 5)
	      numTries = 3;

	   for(i=0; <numTries)
	   {
	   int gorgeID=rmCreateArea("gorge"+i);
         rmSetAreaWarnFailure(gorgeID, false); 
	   rmSetAreaSize(gorgeID, rmAreaTilesToFraction(1500), rmAreaTilesToFraction(1800));
	   rmSetAreaCliffType(gorgeID, cliffType);
	   rmAddAreaToClass(gorgeID, rmClassID("classCliff"));
	   rmSetAreaMinBlobs(gorgeID, 4);
	   rmSetAreaMaxBlobs(gorgeID, 6);
	   if (rmRandInt(1,3) == 1)
	      rmSetAreaCliffEdge(gorgeID, 6, 0.10, 0.2, 1.0, 0);
	   else
	   {
		if (rmRandInt(1,2) == 1) 
	         rmSetAreaCliffEdge(gorgeID, 5, 0.15, 0.15, 1.0, 0);
		else
	         rmSetAreaCliffEdge(gorgeID, 4, 0.17, 0.15, 1.0, 0);
	   }		
	   rmSetAreaCliffPainting(gorgeID, false, true, true, 1.5);
	   rmSetAreaMinBlobDistance(gorgeID, 16.0);
	   rmSetAreaMaxBlobDistance(gorgeID, 20.0);
	   rmSetAreaCoherence(gorgeID, rmRandFloat(0.0,0.2));
	   rmSetAreaSmoothDistance(gorgeID, rmRandInt(10,20));
	   rmSetAreaCliffHeight(gorgeID, gorgeHt, 1.0, 1.0);
	   rmSetAreaHeightBlend(gorgeID, 2);
	   rmAddAreaConstraint(gorgeID, cliffsAvoidCliffs);
         rmAddAreaConstraint(gorgeID, avoidImportantItem);
	   rmAddAreaConstraint(gorgeID, avoidTradeRoute);
         rmAddAreaConstraint(gorgeID, avoidNatives);
	   rmAddAreaConstraint(gorgeID, avoidWater20);
	   rmAddAreaConstraint(gorgeID, avoidSocket);
	   rmAddAreaConstraint(gorgeID, avoidStartingUnits);
	   rmAddAreaConstraint(gorgeID, longPlayerConstraint);
	   rmAddAreaConstraint(gorgeID, secondEdgeConstraint);
	   rmAddAreaConstraint(gorgeID, longHillConstraint);
 	   rmBuildArea(gorgeID);
	   }
      }
      else // all other maps with cliffs
      {
         int numCliffs = rmRandInt(4,5);
	   if (cliffVariety == 2)
		if (makeCentralCliffArea == 1)
		   numCliffs = rmRandInt(3,4);
		else
		   numCliffs = rmRandInt(5,7);
	   else
 		if (makeCentralCliffArea == 1)
		   numCliffs = rmRandInt(3,4);

         for (i=0; <numCliffs)
         {
		cliffHt = rmRandInt(5,6);    
		int bigCliffID=rmCreateArea("big cliff" +i);
		rmSetAreaWarnFailure(bigCliffID, false);
		rmSetAreaCliffType(bigCliffID, cliffType);
		rmAddAreaToClass(bigCliffID, rmClassID("classCliff"));
		if (cliffVariety == 1) // like Patagonia
		{
   	         rmSetAreaSize(bigCliffID, rmAreaTilesToFraction(550), rmAreaTilesToFraction(750));
      	   rmSetAreaCliffEdge(bigCliffID, 2, 0.35, 0.1, 1.0, 0);
      	   rmSetAreaCliffPainting(bigCliffID, false, true, true, 1.5, true);
		   rmSetAreaCliffHeight(bigCliffID, 6, 2.0, 0.5);
		   rmSetAreaCoherence(bigCliffID, 0.5);
		   rmSetAreaSmoothDistance(bigCliffID, 5);
		   rmSetAreaHeightBlend(bigCliffID, 1.0);
		}
		else if (cliffVariety == 2) // smaller, kinda like in Sudden Death from AOM
		{
   	         rmSetAreaSize(bigCliffID, rmAreaTilesToFraction(280), rmAreaTilesToFraction(400));
		   rmSetAreaCliffEdge(bigCliffID, 1, 0.6, 0.1, 1.0, 0);
		   rmSetAreaCliffPainting(bigCliffID, true, true, true, 1.5, true);
		   rmSetAreaCliffHeight(bigCliffID, cliffHt, 1.0, 1.0);
		   rmSetAreaCoherence(bigCliffID, rmRandFloat(0.4, 0.9));
		   rmSetAreaSmoothDistance(bigCliffID, 10);
		   rmSetAreaHeightBlend(bigCliffID, 2.0);
		}
		else  // kinda random, kinda like Texas or NE
		{
   	         rmSetAreaSize(bigCliffID, rmAreaTilesToFraction(400), rmAreaTilesToFraction(700));
		   rmSetAreaCliffEdge(bigCliffID, 1, 0.6, 0.1, 1.0, 0);
		   rmSetAreaCliffPainting(bigCliffID, true, true, true, 1.5, true);
		   rmSetAreaCliffHeight(bigCliffID, cliffHt, 2.0, 1.0);
		   rmSetAreaCoherence(bigCliffID, rmRandFloat(0.4, 0.9));
		   rmSetAreaSmoothDistance(bigCliffID, 15);
		   rmSetAreaHeightBlend(bigCliffID, 1.0);
		}
		rmSetAreaMinBlobs(bigCliffID, 3);
		rmSetAreaMaxBlobs(bigCliffID, 5);
		rmSetAreaMinBlobDistance(bigCliffID, 5.0);
		rmSetAreaMaxBlobDistance(bigCliffID, 18.0);
		rmAddAreaConstraint(bigCliffID, avoidImportantItem);
		rmAddAreaConstraint(bigCliffID, avoidTradeRoute);
            rmAddAreaConstraint(bigCliffID, avoidNatives);
	      rmAddAreaConstraint(bigCliffID, avoidWater20);
	      rmAddAreaConstraint(bigCliffID, cliffsAvoidCliffs);
	      rmAddAreaConstraint(bigCliffID, avoidSocket);
	      rmAddAreaConstraint(bigCliffID, avoidStartingUnits);
	      rmAddAreaConstraint(bigCliffID, longPlayerConstraint);
	      rmAddAreaConstraint(bigCliffID, longHillConstraint);
		rmBuildArea(bigCliffID);
         }
      }
   }

   // Random ponds
   if (makePonds == 1)
   {
	for (i=0; <cNumberNonGaiaPlayers*2)   
      {
	   int pondID=rmCreateArea("random pond"+i);
	   rmSetAreaSize(pondID, rmAreaTilesToFraction(300), rmAreaTilesToFraction(550));
         rmSetAreaWaterType(pondID, pondType);
         rmSetAreaBaseHeight(pondID, baseHt);
         rmSetAreaMinBlobs(pondID, 1);
         rmSetAreaMaxBlobs(pondID, 6);
         rmSetAreaMinBlobDistance(pondID, 12.0);
         rmSetAreaMaxBlobDistance(pondID, 35.0);
         rmAddAreaToClass(pondID, lakeClass);
         rmAddAreaConstraint(pondID, avoidLakesFar);
         rmAddAreaConstraint(pondID, longPlayerConstraint);
         rmAddAreaConstraint(pondID, circleConstraint);
         rmAddAreaConstraint(pondID, avoidTradeRoute);
         rmAddAreaConstraint(pondID, avoidSocket);
         rmAddAreaConstraint(pondID, avoidCliffs);
         rmAddAreaConstraint(pondID, avoidAll);
         rmAddAreaConstraint(pondID, avoidNativesShort);
         rmAddAreaConstraint(pondID, medHillConstraint);
         rmSetAreaCoherence(pondID, rmRandFloat(0.1,0.7));
         rmSetAreaWarnFailure(pondID, false);
         rmBuildArea(pondID);
      }
   }

// Text
   rmSetStatusText("",0.60);

// Random Nuggets
   int nugget2= rmCreateObjectDef("nugget medium"); 
   rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(2, 2);
   rmAddObjectDefToClass(nugget2, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget2, 60.0);
   rmSetObjectDefMaxDistance(nugget2, 110.0);
   rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget2, avoidSocket);
   rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget2, nuggetPlayerConstraint);
   rmAddObjectDefConstraint(nugget2, avoidNuggetMed);
   rmAddObjectDefConstraint(nugget2, circleConstraint);
   rmAddObjectDefConstraint(nugget2, avoidWater10);
   rmAddObjectDefConstraint(nugget2, avoidAll);
   rmAddObjectDefConstraint(nugget2, avoidIce);
   rmPlaceObjectDefPerPlayer(nugget2, false, 1);

   int nugget3= rmCreateObjectDef("nugget hard"); 
   rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(3, 3);
   rmAddObjectDefToClass(nugget3, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget3, 80.0);
   rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.6));
   rmAddObjectDefConstraint(nugget3, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget3, avoidSocket);
   rmAddObjectDefConstraint(nugget3, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget3, longPlayerConstraint);
   rmAddObjectDefConstraint(nugget3, avoidNuggetMed);
   rmAddObjectDefConstraint(nugget3, circleConstraint);
   rmAddObjectDefConstraint(nugget3, avoidWater10);
   rmAddObjectDefConstraint(nugget3, avoidAll);
   rmAddObjectDefConstraint(nugget3, avoidIce);
   rmPlaceObjectDefPerPlayer(nugget3, false, 1);

   int nugget4= rmCreateObjectDef("nugget nuts"); 
   rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(4, 4);
   rmAddObjectDefToClass(nugget4, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget4, 85.0);
   rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(nugget4, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget4, avoidSocket);
   rmAddObjectDefConstraint(nugget4, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget4, farPlayerConstraint);
   rmAddObjectDefConstraint(nugget4, avoidNuggetLong);
   rmAddObjectDefConstraint(nugget4, circleConstraint);
   rmAddObjectDefConstraint(nugget4, avoidWater10);
   rmAddObjectDefConstraint(nugget4, avoidAll);
   rmAddObjectDefConstraint(nugget4, avoidIce);
   rmPlaceObjectDefPerPlayer(nugget4, false, 1);

   rmAddObjectDefConstraint(nugget3, fartherPlayerConstraint);
   rmSetNuggetDifficulty(2, 3);
   rmPlaceObjectDefPerPlayer(nugget3, false, 1);

// Text
   rmSetStatusText("",0.65);

// more resources
   // start area trees 
   int StartAreaTreeID=rmCreateObjectDef("starting trees");
   if (patternChance == 8) 
      rmAddObjectDefItem(StartAreaTreeID, "TreeRockiesSnow", 1, 0.0); 
   else if (patternChance == 19)  
     rmAddObjectDefItem(StartAreaTreeID, "TreePatagoniaSnow", 1, 0.0); 
   else
      rmAddObjectDefItem(StartAreaTreeID, treeType, 1, 0.0);
   rmSetObjectDefMinDistance(StartAreaTreeID, 8);
   rmSetObjectDefMaxDistance(StartAreaTreeID, 12);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidAll);
   rmPlaceObjectDefPerPlayer(StartAreaTreeID, false, 5);

   // second huntable
   int deer2Num = rmRandInt(4, 7);
   if ((plainsMap == 1) || (tropicalMap == 1) || (patternChance == 11))
      deer2Num = rmRandInt(6, 9);
   int farPronghornID=rmCreateObjectDef("far pronghorn");
   rmAddObjectDefItem(farPronghornID, deer2Type, deer2Num, 5.0);
   rmAddObjectDefToClass(farPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farPronghornID, 42.0);
   rmSetObjectDefMaxDistance(farPronghornID, 60.0);
   rmAddObjectDefConstraint(farPronghornID, avoidStartResource);
   rmAddObjectDefConstraint(farPronghornID, mediumPlayerConstraint);
   rmAddObjectDefConstraint(farPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(farPronghornID, avoidNativesShort);
   rmAddObjectDefConstraint(farPronghornID, huntableConstraint);
   rmAddObjectDefConstraint(farPronghornID, avoidAll);
   rmSetObjectDefCreateHerd(farPronghornID, true);
   if (sheepChance == 0)
      rmPlaceObjectDefPerPlayer(farPronghornID, false, 2);
   else
      rmPlaceObjectDefPerPlayer(farPronghornID, false, 1);

   // additional second huntable for low player numbers
   if (cNumberNonGaiaPlayers < 4)
   {
      rmAddObjectDefConstraint(farPronghornID, farPlayerConstraint);
      rmSetObjectDefMinDistance(farPronghornID, rmXFractionToMeters(0.25));
      rmSetObjectDefMaxDistance(farPronghornID, rmXFractionToMeters(0.35));
      rmPlaceObjectDefPerPlayer(farPronghornID, false, 1);
   }

// More coin
   rmAddObjectDefConstraint(GoldMediumID, playerConstraint);
   rmSetObjectDefMinDistance(GoldMediumID, 65.0);
   rmSetObjectDefMaxDistance(GoldMediumID, 80.0);
   if (axisChance == 2)
   {
      rmPlaceObjectDefAtLoc(GoldMediumID, 0, 0.5, 0.6, 1);
      rmPlaceObjectDefAtLoc(GoldMediumID, 0, 0.5, 0.4, 1);
   }
   else
   {
      rmPlaceObjectDefAtLoc(GoldMediumID, 0, 0.6, 0.5, 1);
      rmPlaceObjectDefAtLoc(GoldMediumID, 0, 0.4, 0.5, 1);
   }
   rmAddObjectDefConstraint(GoldMediumID, nuggetPlayerConstraint);
   rmPlaceObjectDefPerPlayer(GoldMediumID, false, 1);

// Extra tree clumps near players - to ensure fair access to wood
   int extraTreesID=rmCreateObjectDef("extra trees");
   if (patternChance == 8) 
      rmAddObjectDefItem(extraTreesID, "TreeRockiesSnow", 5, 5.0); 
   else if (patternChance == 19)  
     rmAddObjectDefItem(extraTreesID, "TreePatagoniaSnow", 5, 5.0);  
   else
      rmAddObjectDefItem(extraTreesID, treeType, 5, 5.0);
   rmSetObjectDefMinDistance(extraTreesID, 14);
   rmSetObjectDefMaxDistance(extraTreesID, 18);
   rmAddObjectDefConstraint(extraTreesID, avoidAll);
   rmAddObjectDefConstraint(extraTreesID, avoidCoin);
   rmAddObjectDefConstraint(extraTreesID, avoidSocket);
   rmAddObjectDefConstraint(extraTreesID, avoidTradeRoute);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTreesID, 0, rmAreaID("player"+i), 1);

   int extraTrees2ID=rmCreateObjectDef("more extra trees");
   if (patternChance == 8) 
      rmAddObjectDefItem(extraTrees2ID, "TreeRockiesSnow", 5, 5.0); 
   else if (patternChance == 19)  
     rmAddObjectDefItem(extraTrees2ID, "TreePatagoniaSnow", 5, 5.0);  
   else
      rmAddObjectDefItem(extraTrees2ID, treeType, 5, 5.0);
   rmSetObjectDefMinDistance(extraTrees2ID, 14);
   rmSetObjectDefMaxDistance(extraTrees2ID, 19);
   rmAddObjectDefConstraint(extraTrees2ID, avoidAll);
   rmAddObjectDefConstraint(extraTrees2ID, avoidCoin);
   rmAddObjectDefConstraint(extraTrees2ID, avoidSocket);
   rmAddObjectDefConstraint(extraTrees2ID, avoidTradeRoute);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTrees2ID, 0, rmAreaID("player"+i), 1);

// Central forests for highlands, canyons
   if (makeCentralCliffArea == 1) // forest for central highlands or canyons
   {
      if (makeCentralForestPatch == 1)
      {  
          numTries=2*cNumberNonGaiaPlayers;
          for (i=0; <numTries)
          { 
             int forestPatchID = rmCreateArea("forest patch"+i, rmAreaID("center highlands"));
             rmAddAreaToClass(forestPatchID, rmClassID("classForest"));
             rmSetAreaWarnFailure(forestPatchID, false);
             rmSetAreaSize(forestPatchID, rmAreaTilesToFraction(80), rmAreaTilesToFraction(150));
             rmSetAreaCoherence(forestPatchID, 0.6);
        	 if (patternChance == 8)
	      	rmSetAreaForestType(forestPatchID, "rockies snow forest");
		 else 
      	      rmSetAreaForestType(forestPatchID, forestType);
             rmSetAreaForestDensity(forestPatchID, 0.6);
             rmSetAreaForestClumpiness(forestPatchID, 0.9);
             rmSetAreaForestUnderbrush(forestPatchID, 0.2);
             rmSetAreaCoherence(forestPatchID, 0.4);
             rmSetAreaSmoothDistance(forestPatchID, 10);
             rmAddAreaConstraint(forestPatchID, avoidAll);
             rmAddAreaConstraint(forestPatchID, avoidTradeRoute);
	       rmAddAreaConstraint(forestPatchID, avoidSocket);
	       rmAddAreaConstraint(forestPatchID, avoidNativesShort);
             rmBuildArea(forestPatchID);
	   }
      }       
   }
   else if (patternChance == 8) // for 1 central mt on Rockies
   {
	if (numMt == 1)
	{
         numTries=2*cNumberNonGaiaPlayers;
    	   if (cNumberNonGaiaPlayers > 4)
	       numTries=cNumberNonGaiaPlayers + 2;
         for (i=0; <numTries)
         { 
         int snowForestPatchID = rmCreateArea("snow forest patch"+i, rmAreaID("mt patch"+0));
         rmAddAreaToClass(snowForestPatchID, rmClassID("classForest"));
         rmSetAreaWarnFailure(snowForestPatchID, false);
         rmSetAreaSize(snowForestPatchID, rmAreaTilesToFraction(170), rmAreaTilesToFraction(220));
         rmSetAreaCoherence(snowForestPatchID, 0.6);
         rmSetAreaForestType(snowForestPatchID, "rockies snow forest");
         rmSetAreaForestDensity(snowForestPatchID, 1.0);
         rmSetAreaForestClumpiness(snowForestPatchID, 0.9);
         rmSetAreaForestUnderbrush(snowForestPatchID, 0.0);
         rmSetAreaCoherence(snowForestPatchID, 0.4);
         rmSetAreaSmoothDistance(snowForestPatchID, 10);
         rmAddAreaConstraint(snowForestPatchID, avoidAll);
         rmAddAreaConstraint(snowForestPatchID, avoidTradeRoute);
	   rmAddAreaConstraint(snowForestPatchID, avoidSocket);
	   rmAddAreaConstraint(snowForestPatchID, avoidNativesShort);
         rmBuildArea(snowForestPatchID);
         }
	}
   }

// Text
   rmSetStatusText("",0.70);

// Main forests
   int forestChance = -1;
   numTries=15*cNumberNonGaiaPlayers;
   if (cNumberNonGaiaPlayers > 3)
      numTries=14*cNumberNonGaiaPlayers;  
   if (cNumberNonGaiaPlayers > 5)
      numTries=13*cNumberNonGaiaPlayers;  
   if (cNumberNonGaiaPlayers > 7)
      numTries=12*cNumberNonGaiaPlayers; 

   failCount=0;

   for (i=0; <numTries)
   {
      forestChance = rmRandInt(1,4);
      int forest=rmCreateArea("forest "+i);
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(250));
      rmSetAreaForestType(forest, forestType);
      rmSetAreaForestDensity(forest, rmRandFloat(0.7, 1.0));
      rmSetAreaForestClumpiness(forest, rmRandFloat(0.5, 0.9));
      rmSetAreaForestUnderbrush(forest, rmRandFloat(0.0, 0.5));
      rmSetAreaCoherence(forest, rmRandFloat(0.4, 0.7));
      rmSetAreaSmoothDistance(forest, rmRandInt(10,20));
      if (forestChance == 3)
      {
		rmSetAreaMinBlobs(forest, 1);
		rmSetAreaMaxBlobs(forest, 3);					
		rmSetAreaMinBlobDistance(forest, 12.0);
		rmSetAreaMaxBlobDistance(forest, 24.0);
	}
      if (forestChance == 4)
      {
		rmSetAreaMinBlobs(forest, 3);
		rmSetAreaMaxBlobs(forest, 5);					
		rmSetAreaMinBlobDistance(forest, 16.0);
		rmSetAreaMaxBlobDistance(forest, 28.0);
		rmSetAreaSmoothDistance(forest, 120);
	}
      rmAddAreaToClass(forest, rmClassID("classForest")); 
	rmAddAreaConstraint(forest, playerConstraintForest);
      rmAddAreaConstraint(forest, forestConstraint);
      rmAddAreaConstraint(forest, avoidAll); 
	rmAddAreaConstraint(forest, avoidCoin);  
      rmAddAreaConstraint(forest, avoidImpassableLand); 
      rmAddAreaConstraint(forest, avoidTradeRoute);
	rmAddAreaConstraint(forest, avoidStartingUnits);
	rmAddAreaConstraint(forest, avoidSocket);
	rmAddAreaConstraint(forest, avoidNativesShort);
	rmAddAreaConstraint(forest, hillConstraint);
      if (makeCentralCliffArea == 1)
         rmAddAreaConstraint(forest, centerConstraintShort);
	if (hillTrees == 1)
	{
	   if (rmRandInt(1,3) > 1)
            rmSetAreaBaseHeight(forest, rmRandFloat(1.5, 2.0));
	}
      if(rmBuildArea(forest)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==5)
            break;
      }
      else
         failCount=0; 
   } 

// Text
   rmSetStatusText("",0.75);

// Extra mines - distant, in the middle and near ends of axis.
   silverType = rmRandInt(1,10);
   int extraGoldID = rmCreateObjectDef("extra mines");
   if (mineChance == 1)
      rmAddObjectDefItem(extraGoldID, "minegold", 1, 0);
   else
      rmAddObjectDefItem(extraGoldID, "mine", 1, 0);
   rmAddObjectDefToClass(extraGoldID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(extraGoldID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraGoldID, avoidSocket);
   rmAddObjectDefConstraint(extraGoldID, coinAvoidCoin);
   rmAddObjectDefConstraint(extraGoldID, shortAvoidCanyons);
   rmAddObjectDefConstraint(extraGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(extraGoldID, avoidWater10);
   rmAddObjectDefConstraint(extraGoldID, avoidAll);
   rmSetObjectDefMinDistance(extraGoldID, 0.0);
   if (makeIce == 1)
   {
      rmSetObjectDefMaxDistance(extraGoldID, 80.0);
      rmAddObjectDefConstraint(extraGoldID, avoidIce);
      rmAddObjectDefConstraint(extraGoldID, centerConstraintFar);
   }
   else if (makeLake == 1)
   {
      rmSetObjectDefMaxDistance(extraGoldID, 80.0);
	rmAddObjectDefConstraint(extraGoldID, centerConstraintFar);
   }
   else
      rmSetObjectDefMaxDistance(extraGoldID, 60.0);
   rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.5, 0.5, rmRandInt(1, 2));
   if (axisChance == 1)
   {
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.49, 0.78, 1);
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.51, 0.22, 1);
   }
   else
   {
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.78, 0.51, 1);
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.22, 0.49, 1);
   }
   if (cNumberNonGaiaPlayers > 4)
   {
      rmSetObjectDefMaxDistance(extraGoldID, 105.0);
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.5, 0.5, 2);
   }

// Far player mines
   silverType = rmRandInt(1,10);
   int GoldFarID=rmCreateObjectDef("player silver far");
   if (mineChance == 2)
      rmAddObjectDefItem(GoldFarID, "minegold", 1, 0);
   else
      rmAddObjectDefItem(GoldFarID, "mine", 1, 0.0);
   rmAddObjectDefConstraint(GoldFarID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldFarID, avoidSocket);
   rmAddObjectDefConstraint(GoldFarID, coinAvoidCoin);
   rmAddObjectDefConstraint(GoldFarID, shortAvoidCanyons);
   rmAddObjectDefConstraint(GoldFarID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(GoldFarID, circleConstraint);
   rmAddObjectDefConstraint(GoldFarID, avoidAll);
   rmAddObjectDefConstraint(GoldFarID, farPlayerConstraint);
   rmAddObjectDefConstraint(GoldFarID, avoidWater10);
   rmAddObjectDefConstraint(GoldFarID, avoidIce);
   rmSetObjectDefMinDistance(GoldFarID, 75.0);
   rmSetObjectDefMaxDistance(GoldFarID, 100.0);
   rmPlaceObjectDefPerPlayer(GoldFarID, false, 2);
 
// Text
   rmSetStatusText("",0.80);

// sheep etc
   if (sheepChance > 0)
   {
      int sheepID=rmCreateObjectDef("herdable animal");
      rmAddObjectDefItem(sheepID, sheepType, 2, 4.0);
      rmAddObjectDefToClass(sheepID, rmClassID("herdableFood"));
      rmSetObjectDefMinDistance(sheepID, 35.0);
      rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.3));
      rmAddObjectDefConstraint(sheepID, avoidSheep);
      rmAddObjectDefConstraint(sheepID, avoidAll);
      rmAddObjectDefConstraint(sheepID, playerConstraint);
      rmAddObjectDefConstraint(sheepID, avoidCliffs);
      rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
      if (rmRandInt(1,2) == 1)
         rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);
      else 
         rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3); 

      rmAddObjectDefConstraint(sheepID, farPlayerConstraint);
      rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.45));
      rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, cNumberNonGaiaPlayers); 
   }

// Central herds
   deer2Num = rmRandInt(5, 7);
   if ((plainsMap == 1) || (patternChance == 11))
      deer2Num = rmRandInt(7, 9);
   int centralHerdID=rmCreateObjectDef("central herd");  
   rmAddObjectDefItem(centralHerdID, centerHerdType, deer2Num, 6.0);
   rmAddObjectDefToClass(centralHerdID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(centralHerdID, rmXFractionToMeters(0.05));
   rmSetObjectDefMaxDistance(centralHerdID, rmXFractionToMeters(0.1));
   rmAddObjectDefConstraint(centralHerdID, avoidTradeRoute);
   rmAddObjectDefConstraint(centralHerdID, avoidImportantItem);
   rmAddObjectDefConstraint(centralHerdID, avoidWater10);
   rmAddObjectDefConstraint(centralHerdID, avoidIce);
   rmAddObjectDefConstraint(centralHerdID, farPlayerConstraint);
   rmAddObjectDefConstraint(centralHerdID, longHuntableConstraint);
   rmSetObjectDefCreateHerd(centralHerdID, true);
   if (axisChance == 1)
   {
      rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.5, 0.38, 1);
      rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.5, 0.62, 1);
   }
   else
   {
      rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.38, 0.5, 1);
      rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.62, 0.5, 1);
   }
   // additional of central herd type
   rmAddObjectDefConstraint(centralHerdID, fartherPlayerConstraint);
   rmSetObjectDefMinDistance(centralHerdID, rmXFractionToMeters(0.3));
   rmSetObjectDefMaxDistance(centralHerdID, rmXFractionToMeters(0.38));
   rmPlaceObjectDefPerPlayer(centralHerdID, false, 1);

// far huntable
   int deer3Num = rmRandInt(4, 6);
   if ((plainsMap == 1) || (patternChance == 11) || (tropicalMap == 1))
      deer3Num = rmRandInt(7, 9);
   int farHuntableID=rmCreateObjectDef("far huntable");
   rmAddObjectDefItem(farHuntableID, deerType, deer3Num, 6.0);
   rmAddObjectDefToClass(farHuntableID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farHuntableID, rmXFractionToMeters(0.33));
   rmSetObjectDefMaxDistance(farHuntableID, rmXFractionToMeters(0.45));
   rmAddObjectDefConstraint(farHuntableID, avoidTradeRoute);
   rmAddObjectDefConstraint(farHuntableID, avoidImportantItem);
   rmAddObjectDefConstraint(farHuntableID, avoidWater10);
   rmAddObjectDefConstraint(farHuntableID, fartherPlayerConstraint);
   rmAddObjectDefConstraint(farHuntableID, longHuntableConstraint);
   rmAddObjectDefConstraint(farHuntableID, avoidAll);
   rmAddObjectDefConstraint(farHuntableID, avoidIce);
   rmSetObjectDefCreateHerd(farHuntableID, true);
   rmPlaceObjectDefPerPlayer(farHuntableID, false, 1);
   if (tropicalMap == 1)
      rmPlaceObjectDefPerPlayer(farHuntableID, false, 1);
   if (plainsMap == 1)
      rmPlaceObjectDefPerPlayer(farHuntableID, false, 1);

// Text
   rmSetStatusText("",0.85);

// More berries
   rmSetObjectDefMinDistance(StartBerryBushID, 70.0);
   rmSetObjectDefMaxDistance(StartBerryBushID, 85.0);
   if ((tropicalMap == 1) || (patternChance == 3) || (patternChance == 19))
   {
      rmPlaceObjectDefPerPlayer(StartBerryBushID, false, 1);
	rmPlaceObjectDefAtLoc(StartBerryBushID, 0, 0.5, 0.5, 2); 
   }
   if ((patternChance == 2) || (patternChance == 6))
	rmPlaceObjectDefAtLoc(StartBerryBushID, 0, 0.5, 0.5, 2);   

// Random trees
   int StragglerTreeID=rmCreateObjectDef("stragglers");
   rmAddObjectDefItem(StragglerTreeID, treeType, 2, 0.0);
   rmAddObjectDefConstraint(StragglerTreeID, avoidAll);
   rmAddObjectDefConstraint(StragglerTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StragglerTreeID, hillConstraint);
   rmAddObjectDefConstraint(StragglerTreeID, playerConstraint);
   rmAddObjectDefConstraint(StragglerTreeID, avoidCoin);
   rmAddObjectDefConstraint(StragglerTreeID, patchConstraint);
   rmAddObjectDefConstraint(StragglerTreeID, avoidWater10);
   rmSetObjectDefMinDistance(StragglerTreeID, 10.0);
   rmSetObjectDefMaxDistance(StragglerTreeID, rmXFractionToMeters(0.5));
   for(i=0; <cNumberNonGaiaPlayers*15)
      rmPlaceObjectDefAtLoc(StragglerTreeID, 0, 0.5, 0.5);

// Fish
   int fishID=rmCreateObjectDef("fish");
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 26.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 7.0);
   rmAddObjectDefItem(fishID, fishType, 1, 0.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   if (cNumberNonGaiaPlayers < 4)
      rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, rmRandInt(3,5));
   else
	rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, rmRandInt(4,6));

// Text
   rmSetStatusText("",0.90);

// Deco
   // Dirt patches for Carolina
   if (patternChance == 2)
   {
	if (variantChance == 2)
	{
	   for (i=0; <cNumberNonGaiaPlayers*5)   
         {
		int dirtPatchC=rmCreateArea("carolina dirt patch "+i);
		rmSetAreaWarnFailure(dirtPatchC, false);
		rmSetAreaSize(dirtPatchC, rmAreaTilesToFraction(190), rmAreaTilesToFraction(260));
		rmSetAreaTerrainType(dirtPatchC, "carolina\ground_grass4_car");
		rmAddAreaToClass(dirtPatchC, rmClassID("classPatch"));
		rmSetAreaMinBlobs(dirtPatchC, 3);
		rmSetAreaMaxBlobs(dirtPatchC, 5);
		rmSetAreaMinBlobDistance(dirtPatchC, 16.0);
		rmSetAreaMaxBlobDistance(dirtPatchC, 36.0);
		rmSetAreaCoherence(dirtPatchC, 0.0);
		rmSetAreaSmoothDistance(dirtPatchC, 10);
		rmAddAreaConstraint(dirtPatchC, shortAvoidImpassableLand);
		rmAddAreaConstraint(dirtPatchC, patchConstraint);
	      rmAddAreaConstraint(dirtPatchC, shortForestConstraint);
		rmBuildArea(dirtPatchC); 
	   }
      }
   }

   // Patches for Great Plains 1 - flowers or more dirt
   if (patternChance == 9)
   {
     if (rmRandInt(1,2) == 2)
     {
       for (i=0; <cNumberNonGaiaPlayers*10)   
       {
	   int gpPatch=rmCreateArea("GP patch "+i);
	   rmSetAreaWarnFailure(gpPatch, false);
	   rmSetAreaSize(gpPatch, rmAreaTilesToFraction(130), rmAreaTilesToFraction(200));
	   rmSetAreaTerrainType(gpPatch, "great_plains\ground6_gp");
	   rmAddAreaToClass(gpPatch, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(gpPatch, 1);
	   rmSetAreaMaxBlobs(gpPatch, 3);
	   rmSetAreaMinBlobDistance(gpPatch, 14.0);
	   rmSetAreaMaxBlobDistance(gpPatch, 28.0);
	   rmSetAreaCoherence(gpPatch, 0.3);
	   rmSetAreaSmoothDistance(gpPatch, 10);
	   rmAddAreaConstraint(gpPatch, shortAvoidImpassableLand);
	   rmAddAreaConstraint(gpPatch, patchConstraint);
	   rmBuildArea(gpPatch); 
       }
     }
     else
     {
       for (i=0; <cNumberNonGaiaPlayers*16)   
       {
	   int gpPatch2=rmCreateArea("GP patch "+i);
	   rmSetAreaWarnFailure(gpPatch2, false);
	   rmSetAreaSize(gpPatch2, rmAreaTilesToFraction(50), rmAreaTilesToFraction(90));
	   if (rmRandInt(1,2) == 1)
	      rmSetAreaTerrainType(gpPatch2, "great_lakes\ground_grass4_gl");
	   else
	      rmSetAreaTerrainType(gpPatch2, "great_lakes\ground_grass5_gl");
	   rmAddAreaToClass(gpPatch2, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(gpPatch2, 2);
	   rmSetAreaMaxBlobs(gpPatch2, 4);
	   rmSetAreaMinBlobDistance(gpPatch2, 12.0);
	   rmSetAreaMaxBlobDistance(gpPatch2, 18.0);
	   rmSetAreaCoherence(gpPatch2, 0.1);
	   rmSetAreaSmoothDistance(gpPatch2, 10);
	   rmAddAreaConstraint(gpPatch2, shortAvoidImpassableLand);
	   rmAddAreaConstraint(gpPatch2, patchConstraint);
	   rmBuildArea(gpPatch2); 
       }
     }
   }

   // Patches for Great Plains 2 - break up the lines!
   if (patternChance == 10)
   {
      for (i=0; <cNumberNonGaiaPlayers*15)   
      {
	   int gpPatchA=rmCreateArea("GP patch A"+i);
	   rmSetAreaWarnFailure(gpPatchA, false);
	   rmSetAreaSize(gpPatchA, rmAreaTilesToFraction(75), rmAreaTilesToFraction(140));
         rmSetAreaTerrainType(gpPatchA, "great_plains\ground2_gp");
	   rmAddAreaToClass(gpPatchA, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(gpPatchA, 2);
	   rmSetAreaMaxBlobs(gpPatchA, 4);
	   rmSetAreaMinBlobDistance(gpPatchA, 5.0);
	   rmSetAreaMaxBlobDistance(gpPatchA, 12.0);
	   rmSetAreaCoherence(gpPatchA, 0.3);
	   rmSetAreaSmoothDistance(gpPatchA, 10);
	   rmAddAreaConstraint(gpPatchA, shortAvoidImpassableLand);
	   rmAddAreaConstraint(gpPatchA, avoidCliffsShort);
	   rmAddAreaConstraint(gpPatchA, patchConstraint);
	   rmBuildArea(gpPatchA); 
      }
      for (i=0; <cNumberNonGaiaPlayers*12)   // little green patches
      {
	   int gpPatchC=rmCreateArea("GP patch C"+i);
	   rmSetAreaWarnFailure(gpPatchC, false);
	   rmSetAreaSize(gpPatchC, rmAreaTilesToFraction(15), rmAreaTilesToFraction(40));
         rmSetAreaTerrainType(gpPatchC, "great_plains\ground8_gp");
	   rmAddAreaToClass(gpPatchC, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(gpPatchC, 2);
	   rmSetAreaMaxBlobs(gpPatchC, 4);
	   rmSetAreaMinBlobDistance(gpPatchC, 5.0);
	   rmSetAreaMaxBlobDistance(gpPatchC, 10.0);
	   rmSetAreaCoherence(gpPatchC, 0.1);
	   rmSetAreaSmoothDistance(gpPatchC, 10);
	   rmAddAreaConstraint(gpPatchC, shortAvoidImpassableLand);
	   rmAddAreaConstraint(gpPatchC, avoidCliffsShort);
	   rmAddAreaConstraint(gpPatchC, patchConstraint);
	   rmBuildArea(gpPatchC); 
      }
      for (i=0; <cNumberNonGaiaPlayers*12)   
      {
	   int gpPatchD=rmCreateArea("GP patch D"+i);
	   rmSetAreaWarnFailure(gpPatchD, false);
	   rmSetAreaSize(gpPatchD, rmAreaTilesToFraction(50), rmAreaTilesToFraction(70));
         rmSetAreaTerrainType(gpPatchD, "great_plains\ground3_gp");
	   rmAddAreaToClass(gpPatchD, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(gpPatchD, 3);
	   rmSetAreaMaxBlobs(gpPatchD, 5);
	   rmSetAreaMinBlobDistance(gpPatchD, 12.0);
	   rmSetAreaMaxBlobDistance(gpPatchD, 20.0);
	   rmSetAreaCoherence(gpPatchD, 0.1);
	   rmSetAreaSmoothDistance(gpPatchD, 10);
	   rmAddAreaConstraint(gpPatchD, shortAvoidImpassableLand);
	   rmAddAreaConstraint(gpPatchD, avoidCliffsShort);
	   rmAddAreaConstraint(gpPatchD, patchConstraint);
	   rmBuildArea(gpPatchD); 
      }
   }

   if (patternChance == 3) // Bayou props
   {	
	int treeClumps = rmRandInt(4,8);
	for(i=1; < treeClumps)
	{
	   int randomWaterTreeID=rmCreateObjectDef("random tree in water"+i);	
   	   rmAddObjectDefItem(randomWaterTreeID, "treeBayouMarsh", rmRandInt(3,7), 3.0);
	   rmSetObjectDefMinDistance(randomWaterTreeID, 0.0);
	   rmSetObjectDefMaxDistance(randomWaterTreeID, rmXFractionToMeters(0.1));
	   rmPlaceObjectDefInArea(randomWaterTreeID, 0, smalllakeID, rmRandInt(1,2));
	} 

	int randomTurtlesID=rmCreateObjectDef("random turtles in water");
	rmAddObjectDefItem(randomTurtlesID, "propTurtles", 1, 3.0);
	rmSetObjectDefMinDistance(randomTurtlesID, 0.0);
	rmSetObjectDefMaxDistance(randomTurtlesID, rmXFractionToMeters(0.1));
	rmAddObjectDefConstraint(randomTurtlesID, nearShore);

	int randomWaterRocksID=rmCreateObjectDef("random rocks in water");
	rmAddObjectDefItem(randomWaterRocksID, "underbrushLake", rmRandInt(1,3), 3.0);
	rmSetObjectDefMinDistance(randomWaterRocksID, 0.0);
	rmSetObjectDefMaxDistance(randomWaterRocksID, rmXFractionToMeters(0.1));

	int randomDucksID=rmCreateObjectDef("random ducks in water");
	rmAddObjectDefItem(randomDucksID, "DuckFamily", 1, 0.0);
	rmSetObjectDefMinDistance(randomDucksID, 0.0);
	rmSetObjectDefMaxDistance(randomDucksID, rmXFractionToMeters(0.1));
	rmAddObjectDefConstraint(randomDucksID, avoidDucks);

	rmPlaceObjectDefInArea(randomTurtlesID, 0, smalllakeID, rmRandInt(1,2)); 
	rmPlaceObjectDefInArea(randomWaterRocksID, 0, smalllakeID, rmRandInt(1,2)); 
	rmPlaceObjectDefInArea(randomDucksID, 0, smalllakeID, rmRandInt(1,2)); 
   }

   if (patternChance == 12) // Texas desert props
   {
	int bigDecorationID=rmCreateObjectDef("Big Texas Things");
	int avoidBigDecoration=rmCreateTypeDistanceConstraint("avoid big decorations", "BigPropTexas", 45.0);
	rmAddObjectDefItem(bigDecorationID, "BigPropTexas", 1, 0.0);
	rmSetObjectDefMinDistance(bigDecorationID, 0.0);
	rmSetObjectDefMaxDistance(bigDecorationID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(bigDecorationID, avoidAll);
	rmAddObjectDefConstraint(bigDecorationID, avoidImportantItem);
	rmAddObjectDefConstraint(bigDecorationID, avoidCoin);
	rmAddObjectDefConstraint(bigDecorationID, avoidImpassableLand);
	rmAddObjectDefConstraint(bigDecorationID, avoidBigDecoration);
	rmAddObjectDefConstraint(bigDecorationID, avoidCliffs);
	rmAddObjectDefConstraint(bigDecorationID, longPlayerConstraint);
	rmPlaceObjectDefAtLoc(bigDecorationID, 0, 0.5, 0.5, rmRandInt(2,3));
   }

   if (plainsMap == 1) // plains props
   {
	int areThereBuffalo=rmRandInt(1, 2);
	int howManyBuffalo=rmRandInt(2, 3);
	if ( areThereBuffalo == 1 )
	{
		int bisonCarcass=rmCreateGrouping("Bison Carcass", "gp_carcass_bison");
		rmSetGroupingMinDistance(bisonCarcass, 0.0);
		rmSetGroupingMaxDistance(bisonCarcass, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(bisonCarcass, avoidImpassableLand);
		rmAddGroupingConstraint(bisonCarcass, playerConstraint);
		rmAddGroupingConstraint(bisonCarcass, avoidTradeRoute);
		rmAddGroupingConstraint(bisonCarcass, avoidSocket);
		rmAddGroupingConstraint(bisonCarcass, avoidStartingUnits);
		rmAddGroupingConstraint(bisonCarcass, avoidAll);
		rmAddGroupingConstraint(bisonCarcass, avoidNuggetSmall);
		rmPlaceGroupingAtLoc(bisonCarcass, 0, 0.5, 0.5, howManyBuffalo);
	}

	int grassPatchGroupType=-1;
	int grassPatchGroup=-1;

	for(i=1; <10*cNumberNonGaiaPlayers)
      {
		grassPatchGroupType=rmRandInt(1, 7);
		grassPatchGroup=rmCreateGrouping("Grass Patch Group"+i, "gp_grasspatch0"+grassPatchGroupType);
		rmSetGroupingMinDistance(grassPatchGroup, 0.0);
		rmSetGroupingMaxDistance(grassPatchGroup, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(grassPatchGroup, avoidImpassableLand);
		rmAddGroupingConstraint(grassPatchGroup, playerConstraint);
		rmAddGroupingConstraint(grassPatchGroup, avoidTradeRoute);
		rmAddGroupingConstraint(grassPatchGroup, avoidSocket);
		rmAddGroupingConstraint(grassPatchGroup, avoidNatives);
		rmAddGroupingConstraint(grassPatchGroup, avoidNuggetSmall);
		rmAddGroupingConstraint(grassPatchGroup, circleConstraint);
		rmAddGroupingConstraint(grassPatchGroup, avoidStartingUnits);
		rmAddGroupingConstraint(grassPatchGroup, avoidAll);
		rmAddGroupingConstraint(grassPatchGroup, avoidCliffs);
		rmPlaceGroupingAtLoc(grassPatchGroup, 0, 0.5, 0.5, 1);
	}

	int flowerPatchGroupType=-1;
	int flowerPatchGroup=-1;

	for(i=1; <8*cNumberNonGaiaPlayers)
      {
		flowerPatchGroupType=rmRandInt(1, 8);
		flowerPatchGroup=rmCreateGrouping("Flower Patch Group"+i, "gp_flower0"+flowerPatchGroupType);
		rmSetGroupingMinDistance(flowerPatchGroup, 0.0);
		rmSetGroupingMaxDistance(flowerPatchGroup, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(flowerPatchGroup, avoidImpassableLand);
		rmAddGroupingConstraint(flowerPatchGroup, playerConstraint);
		rmAddGroupingConstraint(flowerPatchGroup, avoidTradeRoute);
		rmAddGroupingConstraint(flowerPatchGroup, avoidSocket);
		rmAddGroupingConstraint(flowerPatchGroup, avoidNatives);
		rmAddGroupingConstraint(flowerPatchGroup, avoidNuggetSmall);
		rmAddGroupingConstraint(flowerPatchGroup, avoidAll);
		rmAddGroupingConstraint(flowerPatchGroup, avoidCliffs);
		rmAddGroupingConstraint(flowerPatchGroup, circleConstraint);
		rmAddGroupingConstraint(flowerPatchGroup, avoidStartingUnits);
		rmPlaceGroupingAtLoc(flowerPatchGroup, 0, 0.5, 0.5, 1);
	}
   }

   if (vultures == 1)
   { 
	int vultureID=rmCreateObjectDef("perching vultures");
	int avoidVultures=rmCreateTypeDistanceConstraint("avoid other vultures", "PropVulturePerching", 30.0);
	rmAddObjectDefItem(vultureID, "PropVulturePerching", 1, 0.0);
	rmSetObjectDefMinDistance(vultureID, 0.0);
	rmSetObjectDefMaxDistance(vultureID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(vultureID, avoidAll);
	rmAddObjectDefConstraint(vultureID, avoidImportantItem);
	rmAddObjectDefConstraint(vultureID, avoidCoin);
	rmAddObjectDefConstraint(vultureID, avoidImpassableLand);
	rmAddObjectDefConstraint(vultureID, avoidTradeRoute);
	rmAddObjectDefConstraint(vultureID, avoidCliffs);
	rmAddObjectDefConstraint(vultureID, avoidVultures);
	rmAddObjectDefConstraint(vultureID, avoidWater20);
	rmAddObjectDefConstraint(vultureID, longPlayerConstraint);
	rmPlaceObjectDefAtLoc(vultureID, 0, 0.5, 0.5, 2);
   }

   if (eagles == 1)
   {
	int avoidEagles=rmCreateTypeDistanceConstraint("avoids Eagles", "EaglesNest", 40.0);
	int randomEagleTreeID=rmCreateObjectDef("random eagle tree");
	rmAddObjectDefItem(randomEagleTreeID, "EaglesNest", 1, 0.0);
	rmSetObjectDefMinDistance(randomEagleTreeID, 0.0);
	rmSetObjectDefMaxDistance(randomEagleTreeID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(randomEagleTreeID, avoidAll);
	rmAddObjectDefConstraint(randomEagleTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(randomEagleTreeID, avoidEagles);
	rmAddObjectDefConstraint(randomEagleTreeID, playerConstraint);
	rmPlaceObjectDefAtLoc(randomEagleTreeID, 0, 0.5, 0.5, 2);
   }

   if ((patternChance == 13) || (patternChance == 12))  // Sonora and Texas desert
   {
	int buzzardFlockID=rmCreateObjectDef("buzzards");
	int avoidBuzzards=rmCreateTypeDistanceConstraint("buzzard avoid buzzard", "BuzzardFlock", 70.0);
	rmAddObjectDefItem(buzzardFlockID, "BuzzardFlock", 1, 3.0);
	rmSetObjectDefMinDistance(buzzardFlockID, 0.0);
	rmSetObjectDefMaxDistance(buzzardFlockID, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(buzzardFlockID, avoidBuzzards);
	rmAddObjectDefConstraint(buzzardFlockID, avoidSocket);
	rmAddObjectDefConstraint(buzzardFlockID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(buzzardFlockID, playerConstraint);
	rmPlaceObjectDefAtLoc(buzzardFlockID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
   }


  // Regicide Triggers
	for(i=1; <= cNumberNonGaiaPlayers) {
    
    // Lose on Daimyo's death
    rmCreateTrigger("DaimyoDeath"+i);
    rmSwitchToTrigger(rmTriggerID("DaimyoDeath"+i));
    rmSetTriggerPriority(4); 
    rmSetTriggerActive(true);
    rmSetTriggerRunImmediately(true);
    rmSetTriggerLoop(false);
    
    rmAddTriggerCondition("Is Dead");
    rmSetTriggerConditionParamInt("SrcObject", rmGetUnitPlacedOfPlayer(playerDaimyo, i), false);
    
    rmAddTriggerEffect("Set Player Defeated");
    rmSetTriggerEffectParamInt("Player", i, false);
    
  }


	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.5;
		float yLoc = 0.5;
		float walk = 0.03;

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}


// Text
   rmSetStatusText("",0.99);

}  

  
