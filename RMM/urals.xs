// Barrier Ridge TWC
// a random map for AOE3: The War Chiefs
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
   string cliffType = "";
   string forestType = "";
   string treeType = "";
   string deerType = "";
   string deer2Type = "";
   string sheepType = "";
   string centerHerdType = "";
   string native1Name = "";
   string native2Name = "";
   string patchMixType = "";
   string mineType = "";

// Pick pattern for trees, terrain, features, etc.
   int patternChance = rmRandInt(1,2);   
   int variantChance = rmRandInt(1,2);
   int trPattern = rmRandInt(1,5);
   int socketPattern = rmRandInt(1,2);   
   int nativeSetup = rmRandInt(7,17);
   if (cNumberNonGaiaPlayers > 4)
      nativeSetup = rmRandInt(9,17);	 
   int nativePattern = -1;
   int sheepChance = rmRandInt(1,2);
   int cliffChance = rmRandInt(1,10);
   int makeCliffs = -1; 
   int cliffVariety = rmRandInt(0,5);
   int hillTrees = -1;
   int placeBerries = 1;
   int forestDist = rmRandInt(12,18);
   int axisChance = rmRandInt(1,2);
   int playerSide = rmRandInt(1,2);
   int gapPattern = rmRandInt(1,3);
   int twoChoice = rmRandInt(1,2);
   int threeChoice = rmRandInt(1,3);
   int fourChoice = rmRandInt(1,2);
   int fiveChoice = rmRandInt(1,5);
   int sixChoice = rmRandInt(1,6);
   int placeGold = rmRandInt(1,5);

// Picks the map size
   int playerTiles = 15000;
   if (cNumberNonGaiaPlayers == 8)
	playerTiles = 11000;
   else if (cNumberNonGaiaPlayers == 7)
	playerTiles = 12000;
   else if (cNumberNonGaiaPlayers == 6)
	playerTiles = 13000;
   else if (cNumberNonGaiaPlayers == 5)
	playerTiles = 13500;
   else if (cNumberNonGaiaPlayers == 4)
	playerTiles = 4000;
   else if (cNumberNonGaiaPlayers == 3)
	playerTiles = 14500;

   int size=2*sqrt(cNumberNonGaiaPlayers*playerTiles);
   int longSide=1.6*size; 
   if (axisChance == 2) 
      rmSetMapSize(size, longSide);
   else if (axisChance == 1)    
      rmSetMapSize(longSide, size);
   
// Elevation
   rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);
   rmSetMapElevationHeightBlend(1.0);
   rmSetSeaLevel(0.0);
	
   // Text
   rmSetStatusText("",0.05);

// Terrain patterns and features 
/*  can use these in single player to select favorite features - 
    but restore map from the zip file for use in multiplayer 
    to ensure files are exactly the same  */ 

//  trPattern = 4;
//  variantChance = 2;
//  cliffChance = 8;
//  nativeSetup = 15;
//  gapPattern = 3;
//  patternChance = 28;

   if (patternChance == 1) // NE
   {  
      rmSetMapType("siberia");
      rmSetMapType("asia");
      rmSetMapType("grass");
	rmSetLightingSet("saguenay");
      baseType = "korea_a";
	forestType = "Urals Forest";
      cliffType = "Korea";
	treeType = "TreeSpruce";
         deerType = "SikaDeer";
         deer2Type = "Deer";
         centerHerdType = "Deer";        
         sheepType = "ypGoat";
	if (rmRandInt(1,2) == 1)
	   mineType = "mine";
	else
	   mineType = "MineTin";
      hillTrees = rmRandInt(0,1);

	if (cliffChance > 2)
         makeCliffs = 1;

	if (twoChoice == 1)
	   nativePattern = 1;
	else
	   nativePattern = 2;
   }
   else if (patternChance == 2) // araucania south 
   {
      rmSetMapType("siberia");
      rmSetMapType("asia");
      rmSetMapType("snow");
      rmSetLightingSet("Great Lakes Winter");  
	if (fourChoice == 1)
	{
   	   baseType = "araucania_snow_a";
         patchMixType = "araucania_snow_b";
	}
	else if (fourChoice == 2)
	{
   	   baseType = "araucania_snow_b";
         patchMixType = "araucania_snow_a";
	}
	forestType = "Patagonia Snow Forest";
      cliffType = "Araucania South";
	treeType = "TreePatagoniaSnow";
         deerType = "Deer";
         deer2Type = "SikaDeer";
         centerHerdType = "SikaDeer"; 
         sheepType = "sheep";
	if (rmRandInt(1,2) == 1)
	   mineType = "mine";
	else
	   mineType = "MineCopper";
      placeBerries = 0;
      hillTrees = rmRandInt(0,1);

	fourChoice = rmRandInt(1,4);
	if (fourChoice == 1)
	   nativePattern = 1;
	else if (fourChoice == 2)
	   nativePattern = 2;
   }


   rmSetBaseTerrainMix(baseType);
   rmTerrainInitialize("yukon\ground1_yuk", 1);
   rmEnableLocalWater(false);
   rmSetMapType("land");

   rmSetWorldCircleConstraint(true);
   rmSetWindMagnitude(2.0);

// Native patterns
  if (nativePattern == 1)
  {
      rmSetSubCiv(0, "Jesuit");
      native1Name = "native jesuit mission cj 0";
      rmSetSubCiv(1, "Jesuit");
      native2Name = "native jesuit mission cj 0";
  }
  else if (nativePattern == 2)
  {
      rmSetSubCiv(0, "Jesuit");
      native1Name = "native jesuit mission cj 0";
      rmSetSubCiv(1, "Jesuit");
      native2Name = "native jesuit mission cj 0";
  }

   
   chooseMercs();

// Define some classes.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classPatch");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
   rmDefineClass("classCliff");
   rmDefineClass("classBarrierRidge");
   rmDefineClass("center");
   rmDefineClass("classNugget");
   rmDefineClass("socketClass");
   rmDefineClass("classBase");
   int classHuntable=rmDefineClass("huntableFood");   
   int classHerdable=rmDefineClass("herdableFood"); 
   int canyon=rmDefineClass("canyon");

   // Text
   rmSetStatusText("",0.10);

// -------------Define constraints
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
   int secondEdgeConstraint=rmCreateBoxConstraint("avoid edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);

   // Center constraints
   int centerConstraintFar=rmCreateClassDistanceConstraint("stay away from center far", rmClassID("center"), 60.0);

   // Player constraints
   int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 15.0);
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 40.0);
   int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 25.0);
   int nuggetPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 60.0);
   int farPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players more", classPlayer, 85.0);
   int fartherPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players the most", classPlayer, 105.0);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 70.0); 

   // Nature avoidance
   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int shortForestConstraint=rmCreateClassDistanceConstraint("patch vs. forest", rmClassID("classForest"), 15.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), forestDist);
   int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 20.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 10.0);
   int shortAvoidSilver=rmCreateTypeDistanceConstraint("short gold avoid gold", "Mine", 20.0);
   int coinAvoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 45.0);
   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   int avoidSheep=rmCreateClassDistanceConstraint("sheep avoids sheep etc", rmClassID("herdableFood"), 45.0);
   int huntableConstraint=rmCreateClassDistanceConstraint("huntable constraint", rmClassID("huntableFood"), 35.0);
   int longHuntableConstraint=rmCreateClassDistanceConstraint("long huntable constraint", rmClassID("huntableFood"), 55.0);
   int forestsAvoidBison=rmCreateClassDistanceConstraint("forest avoids bison", rmClassID("huntableFood"), 15.0);

   // Avoid impassable land, certain features
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 18.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 8.0);
   int avoidCliffs=rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 12.0);
   int avoidCliff20=rmCreateClassDistanceConstraint("avoid cliffs 20", rmClassID("classCliff"), 20.0);
   int avoidCliff30=rmCreateClassDistanceConstraint("avoid cliffs 30", rmClassID("classCliff"), 30.0);
   int avoidCliffsShort=rmCreateClassDistanceConstraint("stuff vs. cliff short", rmClassID("classCliff"), 7.0);
   int cliffsAvoidCliffs=rmCreateClassDistanceConstraint("cliffs vs. cliffs", rmClassID("classCliff"), 30.0);
   int avoidBarrier=rmCreateClassDistanceConstraint("stuff vs. barrier", rmClassID("classBarrierRidge"), 10.0);
   int avoidBarrierFar=rmCreateClassDistanceConstraint("stuff vs. barrier far", rmClassID("classBarrierRidge"), 20.0);
   int avoidBase=rmCreateClassDistanceConstraint("stuff vs. base", rmClassID("classBase"), 1.0);
   int avoidCanyons=rmCreateClassDistanceConstraint("avoid canyons", rmClassID("canyon"), 35.0);
   int shortAvoidCanyons=rmCreateClassDistanceConstraint("short avoid canyons", rmClassID("canyon"), 15.0);
  
   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 10.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("things avoid each other", rmClassID("importantItem"), 10.0);
   int avoidImportantItemSmall=rmCreateClassDistanceConstraint("important item small avoidance", rmClassID("importantItem"), 7.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 60.0);
   int avoidNativesMed=rmCreateClassDistanceConstraint("stuff avoids natives medium", rmClassID("natives"), 35.0);
   int avoidNativesShort=rmCreateClassDistanceConstraint("stuff avoids natives shorter", rmClassID("natives"), 15.0);
   int avoidNugget=rmCreateClassDistanceConstraint("nugget vs. nugget", rmClassID("classNugget"), 42.0);
   int avoidNuggetMed=rmCreateClassDistanceConstraint("nugget vs. nugget med", rmClassID("classNugget"), 50.0);
   int avoidNuggetLong=rmCreateClassDistanceConstraint("nugget vs. nugget long", rmClassID("classNugget"), 70.0);
   int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 10.0);
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 12.0);
   int avoidTradeRouteCliff = rmCreateTradeRouteDistanceConstraint("trade route cliff", 10.0);
   int avoidSocket=rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 12.0);
// ---------------------------------------------------------------------------------------
   // Text
   rmSetStatusText("",0.15);

// Set up player starting locations
if (cNumberTeams == 2)
{
   if (cNumberNonGaiaPlayers == 2)
   {
      if (axisChance == 1)
	{
	   rmSetPlacementTeam(0);
	   if (playerSide == 1)
	   {
            rmSetPlacementSection(0.22, 0.23);
	   }
	   else
	   {
            rmSetPlacementSection(0.77, 0.78);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);

	   rmSetPlacementTeam(1);
	   if (playerSide == 2)
	   {
            rmSetPlacementSection(0.27, 0.28);
	   }
	   else
	   {
            rmSetPlacementSection(0.72, 0.73);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);
	}
	else if (axisChance == 2)
	{
	   rmSetPlacementTeam(0);
	   if (playerSide == 1)
	   {
            rmSetPlacementSection(0.02, 0.03);
	   }
	   else
	   {
	      rmSetPlacementSection(0.46, 0.47);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);

	   rmSetPlacementTeam(1);
	   if (playerSide == 2)
	   {
            rmSetPlacementSection(0.96, 0.97);
	   }
	   else
	   {
	      rmSetPlacementSection(0.52, 0.53);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);
	}
   }
   else if (cNumberNonGaiaPlayers < 5)
   {
      if (axisChance == 1)
	{
	   rmSetPlacementTeam(0);
	   if (playerSide == 1)
	   {
            rmSetPlacementSection(0.18, 0.32);
	   }
	   else
	   {
	      rmSetPlacementSection(0.68, 0.82);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);

	   rmSetPlacementTeam(1);
	   if (playerSide == 2)
	   {
            rmSetPlacementSection(0.18, 0.32);
	   }
	   else
	   {
	      rmSetPlacementSection(0.68, 0.82);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);
	}
	else if (axisChance == 2)
	{
	   rmSetPlacementTeam(0);
	   if (playerSide == 1)
	   {
            rmSetPlacementSection(0.93, 0.07);
	   }
	   else
	   {
	      rmSetPlacementSection(0.43, 0.57);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);

	   rmSetPlacementTeam(1);
	   if (playerSide == 2)
	   {
            rmSetPlacementSection(0.93, 0.07);
	   }
	   else
	   {
	      rmSetPlacementSection(0.43, 0.57);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);
	}
   }
   else if (cNumberNonGaiaPlayers < 7)
   {
      if (axisChance == 1)
	{
	   rmSetPlacementTeam(0);
	   if (playerSide == 1)
	   {
            rmSetPlacementSection(0.14, 0.36);
	   }
	   else
	   {
	      rmSetPlacementSection(0.64, 0.86);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);

	   rmSetPlacementTeam(1);
	   if (playerSide == 2)
	   {
            rmSetPlacementSection(0.14, 0.36);
	   }
	   else
	   {
	      rmSetPlacementSection(0.64, 0.86);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);
	}
	else if (axisChance == 2)
	{
	   rmSetPlacementTeam(0);
	   if (playerSide == 1)
	   {
            rmSetPlacementSection(0.89, 0.11);
	   }
	   else
	   {
	      rmSetPlacementSection(0.39, 0.61);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);

	   rmSetPlacementTeam(1);
	   if (playerSide == 2)
	   {
            rmSetPlacementSection(0.89, 0.11);
	   }
	   else
	   {
	      rmSetPlacementSection(0.39, 0.61);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);
	}
   }
   else
   {
      if (axisChance == 1)
	{
	   rmSetPlacementTeam(0);
	   if (playerSide == 1)
	   {
            rmSetPlacementSection(0.13, 0.37);
	   }
	   else
	   {
	      rmSetPlacementSection(0.63, 0.87);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);

	   rmSetPlacementTeam(1);
	   if (playerSide == 2)
	   {
            rmSetPlacementSection(0.13, 0.37);
	   }
	   else
	   {
	      rmSetPlacementSection(0.63, 0.87);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);
	}
	else if (axisChance == 2)
	{
	   rmSetPlacementTeam(0);
	   if (playerSide == 1)
	   {
            rmSetPlacementSection(0.88, 0.12);
	   }
	   else
	   {
	      rmSetPlacementSection(0.38, 0.62);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);

	   rmSetPlacementTeam(1);
	   if (playerSide == 2)
	   {
            rmSetPlacementSection(0.88, 0.12);
	   }
	   else
	   {
	      rmSetPlacementSection(0.38, 0.62);
	   }
	   rmPlacePlayersCircular(0.39, 0.4, 0.0);
	}
   }
}
else if (cNumberTeams > 2)
   rmPlacePlayersSquare(0.38, 0.0, 0.0);

   // Text
   rmSetStatusText("",0.20);
	
// Set up player areas.
   float playerFraction=rmAreaTilesToFraction(120);
   for(i=1; <cNumberPlayers)
   {
      int id=rmCreateArea("Player"+i);
      rmSetPlayerArea(i, id);
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmAddAreaConstraint(id, playerConstraint); 
      rmAddAreaConstraint(id, longAvoidImpassableLand);
      rmAddAreaConstraint(id, playerEdgeConstraint); 
      rmSetAreaLocPlayer(id, i);
      rmSetAreaMix(id, baseType);
      rmSetAreaWarnFailure(id, false);
   }
   rmBuildAllAreas();

   // Text
   rmSetStatusText("",0.25);

// Central barrier range
   // Define base size
   int radius = size * 0.5;
   int baseRidgeSize = radius * radius * 0.22;
   int midRidgeSize = radius * radius * 0.1;
   int innerRidgeSize = radius * radius * 0.04;
   int midRidgeSize2 = midRidgeSize * 0.65;
   int innerRidgeSize2 = innerRidgeSize * 0.65;

   // base
   int mountainBaseID = rmCreateArea("mountain base"); 
   rmAddAreaToClass(mountainBaseID, rmClassID("classBase"));
   rmSetAreaLocation(mountainBaseID, 0.5, 0.5); 
   if (axisChance == 1) 
      rmAddAreaInfluenceSegment(mountainBaseID, 0.5, 0.0, 0.5, 1.0); 
   else
      rmAddAreaInfluenceSegment(mountainBaseID, 0.0, 0.5, 1.0, 0.5); 
   rmSetAreaWarnFailure(mountainBaseID, false);
   rmSetAreaSize(mountainBaseID, rmAreaTilesToFraction(baseRidgeSize), rmAreaTilesToFraction(baseRidgeSize));
   rmSetAreaBaseHeight(mountainBaseID, 4.0);
   rmSetAreaElevationType(mountainBaseID, cElevTurbulence);
   rmSetAreaElevationVariation(mountainBaseID, rmRandInt(2,3));
   rmSetAreaHeightBlend(mountainBaseID, 1);
   rmSetAreaCoherence(mountainBaseID, rmRandFloat(0.7,0.8));
   rmSetAreaSmoothDistance(mountainBaseID, rmRandInt(8,12));
   rmBuildArea(mountainBaseID);

   // Center 2 part barrier range
   int barrier1ID=rmCreateArea("barrier 1"); // south mt
   rmSetAreaWarnFailure(barrier1ID, false); 
   rmSetAreaCliffType(barrier1ID, cliffType);
   rmAddAreaToClass(barrier1ID, rmClassID("classCliff"));
   rmAddAreaToClass(barrier1ID, rmClassID("classBarrierRidge"));
   rmAddAreaConstraint(barrier1ID, avoidCliff30);
   if (gapPattern == 1)
   {
      if (cNumberNonGaiaPlayers > 6) 
         rmSetAreaSize(barrier1ID, 0.031, 0.033);
	else  if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrier1ID, 0.037, 0.039);
      else
         rmSetAreaSize(barrier1ID, 0.036, 0.038);
      if (axisChance == 1)
      { 
         rmSetAreaLocation(barrier1ID, 0.5, 0.25);
         rmAddAreaInfluenceSegment(barrier1ID, 0.5, 0.0, 0.5, 0.43);
	}
	else
	{
         rmSetAreaLocation(barrier1ID, 0.25, 0.5);
         rmAddAreaInfluenceSegment(barrier1ID, 0.0, 0.5, 0.43, 0.5);
	}
      rmSetAreaCliffEdge(barrier1ID, 1, 1.0, 0.1, 1.0, 0);
   }
   else if (gapPattern == 2)
   {
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrier1ID, 0.024, 0.025);
	else
         rmSetAreaSize(barrier1ID, 0.021, 0.023);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrier1ID, 0.5, 0.16);
         rmAddAreaInfluenceSegment(barrier1ID, 0.5, 0.0, 0.5, 0.26);
	}
	else
	{
         rmSetAreaLocation(barrier1ID, 0.16, 0.5);
         rmAddAreaInfluenceSegment(barrier1ID, 0.0, 0.5, 0.26, 0.5);
	}
      rmSetAreaCliffEdge(barrier1ID, 1, 1.0, 0.1, 1.0, 0);
   }
   else if (gapPattern == 3)
   {
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrier1ID, 0.065, 0.065);
      else if (cNumberNonGaiaPlayers > 6) 
         rmSetAreaSize(barrier1ID, 0.055, 0.055); 
	else
         rmSetAreaSize(barrier1ID, 0.06, 0.06);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrier1ID, 0.5, 0.25);
         rmAddAreaInfluenceSegment(barrier1ID, 0.5, 0.0, 0.5, 0.71);
	}
	else
	{
         rmSetAreaLocation(barrier1ID, 0.25, 0.5);
         rmAddAreaInfluenceSegment(barrier1ID, 0.0, 0.5, 0.71, 0.5);
	}
      rmSetAreaCliffEdge(barrier1ID, 1, 1.0, 0.1, 1.0, 0);
   }
   rmSetAreaMinBlobs(barrier1ID, 2);
   rmSetAreaMaxBlobs(barrier1ID, 4);
   rmSetAreaMinBlobDistance(barrier1ID, 10.0);
   rmSetAreaMaxBlobDistance(barrier1ID, 14.0);
   rmSetAreaCliffHeight(barrier1ID, rmRandInt(8,9), 1.0, 1.0);
   rmSetAreaCoherence(barrier1ID, 0.9);
   rmSetAreaSmoothDistance(barrier1ID, 5);
   rmSetAreaHeightBlend(barrier1ID, 2);

   int barrier2ID=rmCreateArea("barrier 2"); // north mt
   rmSetAreaWarnFailure(barrier2ID, false); 
   rmSetAreaCliffType(barrier2ID, cliffType);
   rmAddAreaToClass(barrier2ID, rmClassID("classCliff"));
   rmAddAreaToClass(barrier2ID, rmClassID("classBarrierRidge"));
   rmAddAreaConstraint(barrier2ID, avoidCliff30);
   rmAddAreaConstraint(barrier2ID, avoidTradeRouteCliff);
   if (gapPattern == 1)
   {
      if (cNumberNonGaiaPlayers > 6) 
         rmSetAreaSize(barrier2ID, 0.031, 0.033);
	else if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrier2ID, 0.037, 0.039);
      else
         rmSetAreaSize(barrier2ID, 0.036, 0.038);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrier2ID, 0.5, 0.75);
         rmAddAreaInfluenceSegment(barrier2ID, 0.5, 1.0, 0.5, 0.57);
	}
	else
	{
         rmSetAreaLocation(barrier2ID, 0.75, 0.5);
         rmAddAreaInfluenceSegment(barrier2ID, 1.0, 0.5, 0.57, 0.5);
	}
      rmSetAreaCliffEdge(barrier2ID, 1, 1.0, 0.1, 1.0, 0);
   }
   else if (gapPattern == 2)
   {
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrier2ID, 0.06, 0.06);
      else if (cNumberNonGaiaPlayers > 6) 
         rmSetAreaSize(barrier2ID, 0.05, 0.05); 
	else
         rmSetAreaSize(barrier2ID, 0.055, 0.055);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrier2ID, 0.5, 0.75);
         rmAddAreaInfluenceSegment(barrier2ID, 0.5, 1.0, 0.5, 0.29);
	}
	else
	{
         rmSetAreaLocation(barrier2ID, 0.55, 0.5);
         rmAddAreaInfluenceSegment(barrier2ID, 1.0, 0.5, 0.29, 0.5);
	}
      rmSetAreaCliffEdge(barrier2ID, 1, 1.0, 0.1, 1.0, 0);
   }
   else if (gapPattern == 3)
   {
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrier2ID, 0.026, 0.027);
	else
         rmSetAreaSize(barrier2ID, 0.021, 0.023);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrier2ID, 0.5, 0.84);
         rmAddAreaInfluenceSegment(barrier2ID, 0.5, 1.0, 0.5, 0.72);
	}
	else
	{
         rmSetAreaLocation(barrier2ID, 0.84, 0.5);
         rmAddAreaInfluenceSegment(barrier2ID, 1.0, 0.5, 0.72, 0.5);
	}
      rmSetAreaCliffEdge(barrier2ID, 1, 1.0, 0.1, 1.0, 0);
   }
   rmSetAreaMinBlobs(barrier2ID, 2);
   rmSetAreaMaxBlobs(barrier2ID, 4);
   rmSetAreaMinBlobDistance(barrier2ID, 10.0);
   rmSetAreaMaxBlobDistance(barrier2ID, 14.0);
   rmSetAreaCliffHeight(barrier2ID, rmRandInt(7,8), 1.0, 1.0);
   rmSetAreaCoherence(barrier2ID, 0.9);
   rmSetAreaSmoothDistance(barrier2ID, 5);
   rmSetAreaHeightBlend(barrier2ID, 2);

   if (gapPattern == 3)
   {
      rmBuildArea(barrier2ID);
      rmBuildArea(barrier1ID);
   }
   else if (gapPattern == 2)
   {
      rmBuildArea(barrier1ID);
      rmBuildArea(barrier2ID);
   }
   else if (gapPattern == 1)
   {
      if (rmRandInt(1,2) == 1)
      {
         rmBuildArea(barrier2ID);
         rmBuildArea(barrier1ID);
      }
      else 
      {
         rmBuildArea(barrier1ID);
         rmBuildArea(barrier2ID);
      }
   }

   // Text
   rmSetStatusText("",0.30);

// Trade Routes
variantChance = rmRandInt(1,2);
if (trPattern == 2) // 2 opposite inner semicircular routes
{
   // first route
   int tradeRouteID = rmCreateTradeRoute();
   if (axisChance == 1) 
   {	
	rmAddTradeRouteWaypoint(tradeRouteID, 0.6, 1.0);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.7, 0.65);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.75, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.7, 0.35);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.6, 0.0);
   }
   else 
   {	
	rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 0.6);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.7);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.75);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.7);
	rmAddTradeRouteWaypoint(tradeRouteID, 1.0, 0.6);
   }
   rmBuildTradeRoute(tradeRouteID, "dirt");

   // second route
   int tradeRouteID2 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.4, 0.0);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.3, 0.35);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.25, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.3, 0.65);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.4, 1.0);
   }
   else
   {
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.0, 0.4);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.35, 0.3);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.5, 0.25);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.65, 0.3);
	rmAddTradeRouteWaypoint(tradeRouteID2, 1.0, 0.4);
   }
   rmBuildTradeRoute(tradeRouteID2, "carolinas\trade_route");	
}
else if (trPattern == 4)  // two side-to-side
{
   int tradeRouteID4 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.67, 1.0);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.62, 0.78);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.62, 0.7);
	if (variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.67, 0.55);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.67, 0.45);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.64, 0.55);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.64, 0.45);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.62, 0.3);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.62, 0.22);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.67, 0.0);
   }
   else if (axisChance == 2) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID4, 1.0, 0.67);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.78, 0.63);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.7, 0.62);
	if (variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.53, 0.67);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.47, 0.67);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.55, 0.65);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.45, 0.65);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.3, 0.62);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.22, 0.63);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.0, 0.67);
   }
   rmBuildTradeRoute(tradeRouteID4, "carolinas\trade_route");

   int tradeRouteID4A = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 1.0);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.38, 0.78);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.38, 0.7);
	if (variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 0.55);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 0.45);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.36, 0.55);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.36, 0.45);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.38, 0.3);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.38, 0.22);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 0.0);
   }
   else if (axisChance == 2) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID4A, 1.0, 0.33);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.78, 0.37);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.7, 0.38);
	if (variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.53, 0.33);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.47, 0.33);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.55, 0.35);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.45, 0.35);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.3, 0.38);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.22, 0.37);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.0, 0.33);
   }
   rmBuildTradeRoute(tradeRouteID4A, "dirt");
}
else if (trPattern == 3)  // two opposite parabolas
{
   int tradeRouteID3 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	if (variantChance == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID3, 0.75, 1.0);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID3, 0.85, 1.0);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.7, 0.88);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.65, 0.62);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.62, 0.51);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.62, 0.49);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.65, 0.38);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.7, 0.11);
	if (variantChance == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID3, 0.75, 0.0);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID3, 0.85, 0.0);
   }
   else if (axisChance == 2) 
   {
	if (variantChance == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID3, 1.0, 0.75);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID3, 1.0, 0.85);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.88, 0.7);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.62, 0.65);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.51, 0.62);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.49, 0.62);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.38, 0.65);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.12, 0.7);
	if (variantChance == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID3, 0.0, 0.75);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID3, 0.0, 0.85);
   }
   rmBuildTradeRoute(tradeRouteID3, "carolinas\trade_route");

   int tradeRouteID3A = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	if (variantChance == 1)
         rmAddTradeRouteWaypoint(tradeRouteID3A, 0.25, 1.0);
	else
         rmAddTradeRouteWaypoint(tradeRouteID3A, 0.15, 1.0);
      rmAddTradeRouteWaypoint(tradeRouteID3A, 0.3, 0.88);
	rmAddTradeRouteWaypoint(tradeRouteID3A, 0.35, 0.62);
      rmAddTradeRouteWaypoint(tradeRouteID3A, 0.38, 0.51);
      rmAddTradeRouteWaypoint(tradeRouteID3A, 0.38, 0.49);
	rmAddTradeRouteWaypoint(tradeRouteID3A, 0.35, 0.38);
      rmAddTradeRouteWaypoint(tradeRouteID3A, 0.3, 0.12);
	if (variantChance == 1)
         rmAddTradeRouteWaypoint(tradeRouteID3A, 0.25, 0.0);
	else
         rmAddTradeRouteWaypoint(tradeRouteID3A, 0.15, 0.0);
   }
   else if (axisChance == 2) 
   {
	if (variantChance == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID3A, 1.0, 0.25);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID3A, 1.0, 0.15);
	rmAddTradeRouteWaypoint(tradeRouteID3A, 0.88, 0.3);
	rmAddTradeRouteWaypoint(tradeRouteID3A, 0.62, 0.35);
	rmAddTradeRouteWaypoint(tradeRouteID3A, 0.51, 0.38);
	rmAddTradeRouteWaypoint(tradeRouteID3A, 0.49, 0.38);
	rmAddTradeRouteWaypoint(tradeRouteID3A, 0.38, 0.35);
	rmAddTradeRouteWaypoint(tradeRouteID3A, 0.12, 0.3);
	if (variantChance == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID3A, 0.0, 0.25);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID3A, 0.0, 0.15);
   }
   rmBuildTradeRoute(tradeRouteID3A, "dirt");
}
else if (trPattern == 1)  // 2 'semicircular' middle routes
{
   int tradeRouteID1 = rmCreateTradeRoute();
   int tradeRouteID1A = rmCreateTradeRoute();
   if (axisChance == 2)
   {
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.0, 0.62);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.2, 0.72);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.25, 0.76);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.5, 0.8);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.75, 0.76);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.8, 0.72);
      rmAddTradeRouteWaypoint(tradeRouteID1, 1.0, 0.62);
      rmBuildTradeRoute(tradeRouteID1, "carolinas\trade_route");	

      rmAddTradeRouteWaypoint(tradeRouteID1A, 1.0, 0.38);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.8, 0.28);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.75, 0.24);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.5, 0.2);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.25, 0.24);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.2, 0.28);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.0, 0.38);
      rmBuildTradeRoute(tradeRouteID1A, "dirt");
   }
   else if (axisChance == 1)
   {	
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.62, 1.0);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.72, 0.8);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.76, 0.75);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.8, 0.5);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.76, 0.25);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.72, 0.2);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.62, 0.0);
      rmBuildTradeRoute(tradeRouteID1, "carolinas\trade_route");	

      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.38, 0.0);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.28, 0.2);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.24, 0.25);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.2, 0.5);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.28, 0.8);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.38, 1.0);
      rmBuildTradeRoute(tradeRouteID1A, "dirt");
   }
}
else if (trPattern == 5)  // 2 diagonal routes
{
   int tradeRouteID5 = rmCreateTradeRoute();
   int tradeRouteID5A = rmCreateTradeRoute();
   if (axisChance == 2)
   {
      rmAddTradeRouteWaypoint(tradeRouteID5, 0.0, 0.62);
      rmAddTradeRouteWaypoint(tradeRouteID5, 0.15, 0.66);
      rmAddTradeRouteWaypoint(tradeRouteID5, 0.25, 0.7);
      rmAddTradeRouteWaypoint(tradeRouteID5, 0.5, 0.74);
      rmAddTradeRouteWaypoint(tradeRouteID5, 0.75, 0.78);
      rmAddTradeRouteWaypoint(tradeRouteID5, 0.85, 0.82);
      rmAddTradeRouteWaypoint(tradeRouteID5, 1.0, 0.86);
      rmBuildTradeRoute(tradeRouteID5, "carolinas\trade_route");	

      rmAddTradeRouteWaypoint(tradeRouteID5A, 1.0, 0.38);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.85, 0.34);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.75, 0.3);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.5, 0.26);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.25, 0.22);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.15, 0.18);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.0, 0.14);
      rmBuildTradeRoute(tradeRouteID5A, "dirt");
   }
   else if (axisChance == 1)
   {	
      rmAddTradeRouteWaypoint(tradeRouteID5, 0.62, 1.0);
      rmAddTradeRouteWaypoint(tradeRouteID5, 0.66, 0.8);
      rmAddTradeRouteWaypoint(tradeRouteID5, 0.7, 0.75);
      rmAddTradeRouteWaypoint(tradeRouteID5, 0.74, 0.5);
      rmAddTradeRouteWaypoint(tradeRouteID5, 0.78, 0.25);
      rmAddTradeRouteWaypoint(tradeRouteID5, 0.82, 0.2);
      rmAddTradeRouteWaypoint(tradeRouteID5, 0.86, 0.0);
      rmBuildTradeRoute(tradeRouteID5, "carolinas\trade_route");	

      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.38, 0.0);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.34, 0.15);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.3, 0.25);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.26, 0.5);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.22, 0.75);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.18, 0.85);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.14, 1.0);
      rmBuildTradeRoute(tradeRouteID5A, "dirt");
   }
}

   // Text
   rmSetStatusText("",0.35);

// Trade sockets
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 7.0);
   variantChance = rmRandInt(1,2);

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
else if (trPattern == 4) //  2 side-to-side
{
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID4);
   if (socketPattern == 1) // 3 sockets per route
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.12);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.88);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else  // 2 sockets per route
   {
	if (variantChance == 1)
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.23);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.77);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.32);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.68);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }

   // change the trade route for the new sockets
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID4A);
   if (socketPattern == 1)  // 3 sockets per route
   {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.88);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
  
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.12);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else  // 2 sockets per route
   {
	if (variantChance == 1)
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.23);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.77);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.68);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.32);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }
}
else if (trPattern == 3) //  2 parabolas
{
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID3);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.17);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.83);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // change the trade route for the new sockets
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID3A);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3A, 0.83);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3A, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3A, 0.17);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
}
else if (trPattern == 1) //  2 middle semicircles
{
   if (socketPattern == 1) // 3 per route
   { 
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID1);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.1);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.9);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      // change the trade route for the new sockets
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID1A);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.1);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.9);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   if (socketPattern == 2)  
   { 
	if (variantChance == 1) // 4 per route
	{
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID1);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.1);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.35);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.6);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.85);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      // change the trade route for the new sockets
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID1A);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.1);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.35);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.6);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.85);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else  // 2 per route
	{
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID1);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.28);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.72);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      // change the trade route for the new sockets
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID1A);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.28);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.72);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }
}
else if (trPattern == 5) //  2 diagonals
{
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID5);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5, 0.21);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5, 0.79);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // change the trade route for the new sockets
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID5A);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5A, 0.79);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5A, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5A, 0.21);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
}

   //Text
   rmSetStatusText("",0.40);

// Starting TCs and units 	
   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 5.0);
   rmSetObjectDefMaxDistance(startingUnits, 10.0);
   rmAddObjectDefConstraint(startingUnits, avoidAll);
   rmAddObjectDefConstraint(startingUnits, avoidBase);

   int startingTCID= rmCreateObjectDef("startingTC");
   rmSetObjectDefMaxDistance(startingTCID, 18.0);
   rmAddObjectDefConstraint(startingTCID, avoidAll);
   rmAddObjectDefConstraint(startingTCID, avoidTradeRoute);
   rmAddObjectDefConstraint(startingTCID, avoidBase);                
   if ( rmGetNomadStart())
   {
	rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
   }
   else
   {
      rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
   }

   for(i=1; <cNumberPlayers)
   {	
      rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

   }
   
// Central features & patches, per map or variant
   // Center area
   int centerArea=rmCreateArea("TheCenter");
   rmSetAreaSize(centerArea, 0.2, 0.2);
   rmSetAreaLocation(centerArea, 0.5, 0.5);
   rmAddAreaToClass(centerArea, rmClassID("center")); 


   // Text
   rmSetStatusText("",0.45);

// NATIVE AMERICANS
   // Village A 
   int villageAID = -1;
   int whichNative = rmRandInt(1,2);
   int villageType = rmRandInt(1,5);

   if (whichNative == 1)
	   villageAID = rmCreateGrouping("village A", native1Name+villageType);
   else if (whichNative == 2)
	   villageAID = rmCreateGrouping("village A", native2Name+villageType);   rmAddGroupingToClass(villageAID, rmClassID("natives"));

   rmAddGroupingToClass(villageAID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageAID, 0.0);
   rmSetGroupingMaxDistance(villageAID, size*0.1);
   rmAddGroupingConstraint(villageAID, avoidImpassableLand);
   rmAddGroupingConstraint(villageAID, avoidTradeRouteFar);
   rmAddGroupingConstraint(villageAID, avoidNativesMed);
   rmAddGroupingConstraint(villageAID, nuggetPlayerConstraint);
   rmAddGroupingConstraint(villageAID, avoidBarrierFar);
   rmAddGroupingConstraint(villageAID, avoidSocket);

   // Village D - opposite type from A 
   int villageDID = -1;
   villageType = rmRandInt(1,5);

   if (whichNative == 2)
	   villageDID = rmCreateGrouping("village D", native1Name+villageType);
   else if (whichNative == 1)
	   villageDID = rmCreateGrouping("village D", native2Name+villageType);

   rmAddGroupingToClass(villageDID, rmClassID("natives"));
   rmAddGroupingToClass(villageDID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageDID, 0.0);
   rmSetGroupingMaxDistance(villageDID, size*0.1);
   rmAddGroupingConstraint(villageDID, avoidImpassableLand);
   rmAddGroupingConstraint(villageDID, avoidTradeRouteFar);
   rmAddGroupingConstraint(villageDID, avoidNativesMed);
   rmAddGroupingConstraint(villageDID, nuggetPlayerConstraint);
   rmAddGroupingConstraint(villageDID, avoidBarrierFar);
   rmAddGroupingConstraint(villageDID, avoidSocket);

   // Village B - randomly same or opposite village A
   int villageBID = -1;	
   villageType = rmRandInt(1,5);
   whichNative = rmRandInt(1,2);

   if (whichNative == 1)
	   villageBID = rmCreateGrouping("village B", native1Name+villageType);
   else if (whichNative == 2)
	   villageBID = rmCreateGrouping("village B", native2Name+villageType);

   rmAddGroupingToClass(villageBID, rmClassID("importantItem"));
   rmAddGroupingToClass(villageBID, rmClassID("natives"));
   rmSetGroupingMinDistance(villageBID, 0.0);
   rmSetGroupingMaxDistance(villageBID, size*0.14);
   rmAddGroupingConstraint(villageBID, avoidImpassableLand);
   rmAddGroupingConstraint(villageBID, avoidTradeRouteFar);
   rmAddGroupingConstraint(villageBID, avoidNatives);
   rmAddGroupingConstraint(villageBID, nuggetPlayerConstraint);
   rmAddGroupingConstraint(villageBID, avoidBarrierFar);
   rmAddGroupingConstraint(villageBID, avoidSocket);

// Placement of Native Americans
   if ((nativeSetup == 10) || (nativeSetup == 13))  
   {
      if (axisChance == 2)
	{
  	      if (variantChance == 1)
	      {  	
		rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.39);
		rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.61);
	      }
	      else
	      {
		rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.34);
		rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.66);
	      }
      }
	else if (axisChance == 1)
	{
	      if (variantChance == 1)
	      {  
		rmPlaceGroupingAtLoc(villageDID, 0, 0.34, 0.5);
		rmPlaceGroupingAtLoc(villageDID, 0, 0.66, 0.5);
	      }
	      else
	      {
		rmPlaceGroupingAtLoc(villageDID, 0, 0.39, 0.5);
		rmPlaceGroupingAtLoc(villageDID, 0, 0.61, 0.5);
	      }	   
	}
   } 
   else if (nativeSetup > 14) // 15 AND 16
   {
	if (nativeSetup == 15)
	{
	   if (axisChance == 1)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.38, 0.51);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.62, 0.49);

         }
   	   else
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.51, 0.62);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.49, 0.38);
	   }
	}
   } 
   else 
   {
	if (nativeSetup == 10)
	{
   	   rmSetGroupingMaxDistance(villageDID, size*0.1);
	   if (axisChance == 1)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.39, 0.5);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.61, 0.5);
         }
	   else
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.39);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.61);
	   }
	}
	if (nativeSetup == 11)
	{
	   if (axisChance == 1)
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.39, 0.5);
            rmPlaceGroupingAtLoc(villageAID, 0, 0.61, 0.5);
         }
	   else
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.39);
            rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.61);
	   }
	}
   }

   // Text
   rmSetStatusText("",0.50);

// Player Nuggets
   int playerNuggetID=rmCreateObjectDef("player nugget");
   rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
   rmAddObjectDefToClass(playerNuggetID, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(playerNuggetID, 25.0);
   rmSetObjectDefMaxDistance(playerNuggetID, 35.0);
   rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerNuggetID, avoidSocket);
   rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
   for(i=1; <cNumberPlayers)
   {
 	rmSetNuggetDifficulty(1, 1);
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
   }

   // Text
   rmSetStatusText("",0.55);

// Cliffs
   int cliffHt = -1;
   int failCount=0;
   int numTries=cNumberNonGaiaPlayers*7;
   int anotherChance = -1;
   anotherChance = rmRandInt(0,1);

   if (makeCliffs == 2)
   {
     if (anotherChance == 1)
        makeCliffs = 1;
     else
        makeCliffs = 0;
   } 

   if (makeCliffs == 1)
   { 
	if (cliffVariety == 8) // for Sonora and Painted Desert only
	{
	   // bigger mesas
	   for(i=0; <numTries)
	   {
		int mesaID=rmCreateArea("mesa"+i);
		rmSetAreaSize(mesaID, rmAreaTilesToFraction(25), rmAreaTilesToFraction(160)); 
		rmSetAreaWarnFailure(mesaID, false);
		rmSetAreaCliffType(mesaID, cliffType);
		rmAddAreaToClass(mesaID, rmClassID("canyon"));
		rmAddAreaToClass(mesaID, rmClassID("classCliff"));	
		rmSetAreaCliffEdge(mesaID, 1, 1.0, 0.1, 1.0, 0);
  	      rmSetAreaCliffHeight(mesaID, rmRandInt(5,6), 1.0, 1.0);
		rmAddAreaConstraint(mesaID, avoidCanyons);
		rmAddAreaConstraint(mesaID, avoidCliffs);
		rmSetAreaMinBlobs(mesaID, 3);
		rmSetAreaMaxBlobs(mesaID, 5);
		rmSetAreaMinBlobDistance(mesaID, 3.0);
		rmSetAreaMaxBlobDistance(mesaID, 5.0);
		rmSetAreaCoherence(mesaID, 0.5);
		rmAddAreaConstraint(mesaID, playerConstraint); 
		rmAddAreaConstraint(mesaID, avoidSocket);
		rmAddAreaConstraint(mesaID, avoidNativesShort);
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
	   numTries=cNumberNonGaiaPlayers*12;

	   for(i=0; <numTries)
	   {
		int smallMesaID=rmCreateArea("small mesa"+i);
		rmSetAreaSize(smallMesaID, rmAreaTilesToFraction(4), rmAreaTilesToFraction(8));  
		rmSetAreaWarnFailure(smallMesaID, false);
		rmSetAreaCliffType(smallMesaID, cliffType);
		rmAddAreaToClass(smallMesaID, rmClassID("canyon"));
		rmAddAreaToClass(smallMesaID, rmClassID("classCliff"));	
		rmSetAreaCliffEdge(smallMesaID, 1, 1.0, 0.1, 1.0, 0);
		rmSetAreaCliffHeight(smallMesaID, rmRandInt(4,5), 1.0, 1.0);
		rmAddAreaConstraint(smallMesaID, shortAvoidCanyons);
		rmAddAreaConstraint(smallMesaID, avoidCliffs);
		rmSetAreaMinBlobs(smallMesaID, 3);
		rmSetAreaMaxBlobs(smallMesaID, 5);
		rmSetAreaMinBlobDistance(smallMesaID, 3.0);
		rmSetAreaMaxBlobDistance(smallMesaID, 5.0);
		rmSetAreaCoherence(smallMesaID, 0.3);
		rmAddAreaConstraint(smallMesaID, mediumPlayerConstraint); 
		rmAddAreaConstraint(smallMesaID, avoidNativesShort); 
		rmAddAreaConstraint(smallMesaID, avoidSocket);
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
	   int gorgeHt = rmRandInt(-7,-4);
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
	   rmAddAreaConstraint(gorgeID, avoidSocket);
	   rmAddAreaConstraint(gorgeID, avoidBarrier);
	   rmAddAreaConstraint(gorgeID, avoidStartingUnits);
	   rmAddAreaConstraint(gorgeID, fartherPlayerConstraint);
	   rmAddAreaConstraint(gorgeID, secondEdgeConstraint);
 	   rmBuildArea(gorgeID);
	   }
      }
      else // all other maps with cliffs
      {
         int numCliffs = cNumberNonGaiaPlayers + rmRandInt(2,6);

         for (i=0; <numCliffs)
         {
		cliffHt = rmRandInt(4,5);    
		int bigCliffID=rmCreateArea("big cliff" +i);
		rmSetAreaWarnFailure(bigCliffID, false);
		rmSetAreaCliffType(bigCliffID, cliffType);
		rmAddAreaToClass(bigCliffID, rmClassID("classCliff"));
		if (cliffVariety == 1) // like Patagonia
		{
   	         rmSetAreaSize(bigCliffID, rmAreaTilesToFraction(550), rmAreaTilesToFraction(750));
      	   rmSetAreaCliffEdge(bigCliffID, 2, 0.35, 0.1, 1.0, 0);
      	   rmSetAreaCliffPainting(bigCliffID, false, true, true, 1.5, true);
		   rmSetAreaCliffHeight(bigCliffID, 5, 2.0, 0.5);
		   rmSetAreaCoherence(bigCliffID, 0.5);
		   rmSetAreaSmoothDistance(bigCliffID, rmRandInt(5,10));
		   rmSetAreaHeightBlend(bigCliffID, 1.0);
		   rmSetAreaMinBlobs(bigCliffID, 4);
	  	   rmSetAreaMaxBlobs(bigCliffID, 6);
		   rmSetAreaMinBlobDistance(bigCliffID, 10.0);
		   rmSetAreaMaxBlobDistance(bigCliffID, 18.0);
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
		   rmSetAreaMinBlobs(bigCliffID, 1);
	  	   rmSetAreaMaxBlobs(bigCliffID, 3);
		   rmSetAreaMinBlobDistance(bigCliffID, 5.0);
		   rmSetAreaMaxBlobDistance(bigCliffID, 10);
		}
		else
		{
		   rmSetAreaSize(bigCliffID, rmAreaTilesToFraction(400), rmAreaTilesToFraction(700));
		   rmSetAreaCliffEdge(bigCliffID, 1, 0.6, 0.1, 1.0, 0);
		   rmSetAreaCliffPainting(bigCliffID, true, true, true, 1.5, true);
		   rmSetAreaCliffHeight(bigCliffID, cliffHt, 2.0, 1.0);
		   rmSetAreaCoherence(bigCliffID, rmRandFloat(0.4, 0.9));
		   rmSetAreaSmoothDistance(bigCliffID, 15);
		   rmSetAreaHeightBlend(bigCliffID, 1.0);
		   rmSetAreaMinBlobs(bigCliffID, 3);
		   rmSetAreaMaxBlobs(bigCliffID, 5);
		   rmSetAreaMinBlobDistance(bigCliffID, 10.0);
		   rmSetAreaMaxBlobDistance(bigCliffID, 18.0);
	      }
		rmAddAreaConstraint(bigCliffID, avoidImportantItem);
		rmAddAreaConstraint(bigCliffID, avoidTradeRoute);
            rmAddAreaConstraint(bigCliffID, avoidNatives);
	      rmAddAreaConstraint(bigCliffID, cliffsAvoidCliffs);
	      rmAddAreaConstraint(bigCliffID, avoidSocket);
	      rmAddAreaConstraint(bigCliffID, avoidStartingUnits);
	      rmAddAreaConstraint(bigCliffID, longPlayerConstraint);
		rmBuildArea(bigCliffID);
         }
      }
   }

   // Text
   rmSetStatusText("",0.60);

// Random Nuggets
   int nugget2= rmCreateObjectDef("nugget medium"); 
   rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(2, 2);
   rmAddObjectDefToClass(nugget2, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget2, 50.0);
   rmSetObjectDefMaxDistance(nugget2, size*0.3);
   rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget2, avoidSocket);
   rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget2, nuggetPlayerConstraint);
   rmAddObjectDefConstraint(nugget2, avoidNuggetMed);
   rmAddObjectDefConstraint(nugget2, playerEdgeConstraint);
   rmAddObjectDefConstraint(nugget2, avoidBarrier);
   rmAddObjectDefConstraint(nugget2, avoidAll);
   rmPlaceObjectDefPerPlayer(nugget2, false, 1);

   int nugget3= rmCreateObjectDef("nugget hard"); 
   rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(3, 3);
   rmAddObjectDefToClass(nugget3, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget3, 70.0);
   rmSetObjectDefMaxDistance(nugget3, size*0.35);
   rmAddObjectDefConstraint(nugget3, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget3, avoidSocket);
   rmAddObjectDefConstraint(nugget3, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget3, farPlayerConstraint);
   rmAddObjectDefConstraint(nugget3, avoidNuggetLong);
   rmAddObjectDefConstraint(nugget3, playerEdgeConstraint);
   rmAddObjectDefConstraint(nugget3, avoidBarrier);
   rmAddObjectDefConstraint(nugget3, avoidAll);
   rmPlaceObjectDefPerPlayer(nugget3, false, 1);

   rmAddObjectDefConstraint(nugget3, fartherPlayerConstraint);
   rmSetNuggetDifficulty(2, 3);
   rmPlaceObjectDefPerPlayer(nugget3, false, 1);

   int nugget4= rmCreateObjectDef("nugget nuts"); 
   rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(4, 4);
   rmAddObjectDefToClass(nugget4, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget4, 85.0);
   rmSetObjectDefMaxDistance(nugget4, size*0.38);
   rmAddObjectDefConstraint(nugget4, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget4, avoidSocket);
   rmAddObjectDefConstraint(nugget4, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget4, fartherPlayerConstraint);
   rmAddObjectDefConstraint(nugget4, avoidNuggetLong);
   rmAddObjectDefConstraint(nugget4, playerEdgeConstraint);
   rmAddObjectDefConstraint(nugget4, avoidBarrier);
   rmAddObjectDefConstraint(nugget4, avoidAll);
   rmPlaceObjectDefPerPlayer(nugget4, false, 1);

// more resources
   // start area trees 
   int StartAreaTreeID=rmCreateObjectDef("starting trees");
   rmAddObjectDefItem(StartAreaTreeID, treeType, 2, 0.0);
   rmSetObjectDefMinDistance(StartAreaTreeID, 10);
   rmSetObjectDefMaxDistance(StartAreaTreeID, 12);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidAll);
   rmPlaceObjectDefPerPlayer(StartAreaTreeID, false, 3);

   // berry bushes
   int berryNum = rmRandInt(2,5);
   int StartBerryBushID=rmCreateObjectDef("starting berry bush");
   rmAddObjectDefItem(StartBerryBushID, "BerryBush", rmRandInt(4,4), 4.0);
   rmSetObjectDefMinDistance(StartBerryBushID, 11.0);
   rmSetObjectDefMaxDistance(StartBerryBushID, 16.0);
   rmAddObjectDefConstraint(StartBerryBushID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartBerryBushID, avoidBarrier);
   if (placeBerries == 1)
      rmPlaceObjectDefPerPlayer(StartBerryBushID, false, 1);

   // Text
   rmSetStatusText("",0.65);

   // start area huntable
   int deerNum = rmRandInt(5, 8);
   int startPronghornID=rmCreateObjectDef("starting pronghorn");
   rmAddObjectDefItem(startPronghornID, deerType, deerNum, 5.0);
   rmAddObjectDefToClass(startPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(startPronghornID, 14);
   rmSetObjectDefMaxDistance(startPronghornID, 18);
   rmAddObjectDefConstraint(startPronghornID, avoidStartResource);
   rmAddObjectDefConstraint(startPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(startPronghornID, avoidBarrier);
   rmAddObjectDefConstraint(startPronghornID, avoidAll);
   rmSetObjectDefCreateHerd(startPronghornID, false);
   rmPlaceObjectDefPerPlayer(startPronghornID, false, 1);

   // second huntable
   int deer2Num = rmRandInt(4, 8);
   int farPronghornID=rmCreateObjectDef("far pronghorn");
   rmAddObjectDefItem(farPronghornID, deer2Type, deer2Num, 6.0);
   rmAddObjectDefToClass(farPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farPronghornID, 42.0);
   rmSetObjectDefMaxDistance(farPronghornID, 60.0);
   rmAddObjectDefConstraint(farPronghornID, avoidStartResource);
   rmAddObjectDefConstraint(farPronghornID, mediumPlayerConstraint);
   rmAddObjectDefConstraint(farPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(farPronghornID, avoidNativesShort);
   rmAddObjectDefConstraint(farPronghornID, huntableConstraint);
   rmAddObjectDefConstraint(farPronghornID, avoidBarrier);
   rmAddObjectDefConstraint(farPronghornID, avoidAll);
   rmSetObjectDefCreateHerd(farPronghornID, true);
   if (sheepChance == 0)
      rmPlaceObjectDefPerPlayer(farPronghornID, false, 2);
   else
      rmPlaceObjectDefPerPlayer(farPronghornID, false, 1);

// Silver mines - players
   int silverType = -1;
   silverType = rmRandInt(1,10);
   int playerGoldID=rmCreateObjectDef("player silver closer");
   rmAddObjectDefItem(playerGoldID, mineType, 1, 0.0);
   rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerGoldID, avoidSocket);
   rmAddObjectDefConstraint(playerGoldID, coinAvoidCoin);
   rmAddObjectDefConstraint(playerGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(playerGoldID, avoidAll);
   rmAddObjectDefConstraint(playerGoldID, avoidBarrier);
   rmSetObjectDefMinDistance(playerGoldID, 18.0);
   rmSetObjectDefMaxDistance(playerGoldID, 23.0);
   rmPlaceObjectDefPerPlayer(playerGoldID, false, 1);

   rmAddObjectDefConstraint(playerGoldID, playerConstraint);
   rmSetObjectDefMinDistance(playerGoldID, 50.0);
   rmSetObjectDefMaxDistance(playerGoldID, 60.0);
   rmPlaceObjectDefPerPlayer(playerGoldID, false, 1);

   silverType = rmRandInt(1,10);
   int GoldMediumID=rmCreateObjectDef("player silver med");
   rmAddObjectDefItem(GoldMediumID, mineType, 1, 0.0);
   rmAddObjectDefConstraint(GoldMediumID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldMediumID, avoidSocket);
   rmAddObjectDefConstraint(GoldMediumID, coinAvoidCoin);
   rmAddObjectDefConstraint(GoldMediumID, shortAvoidCanyons);
   rmAddObjectDefConstraint(GoldMediumID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(GoldMediumID, farPlayerConstraint);
   rmAddObjectDefConstraint(GoldMediumID, avoidBarrier);
   rmAddObjectDefConstraint(GoldMediumID, avoidAll);
   rmSetObjectDefMinDistance(GoldMediumID, 85.0);
   rmSetObjectDefMaxDistance(GoldMediumID, 100.0);
   rmPlaceObjectDefPerPlayer(GoldMediumID, false, 1);

   // Text
   rmSetStatusText("",0.70);

// Extra tree clumps near players - to ensure fair access to wood
   int extraTreesID=rmCreateObjectDef("extra trees");
   rmAddObjectDefItem(extraTreesID, treeType, 4, 5.0);
   rmSetObjectDefMinDistance(extraTreesID, 14);
   rmSetObjectDefMaxDistance(extraTreesID, 18);
   rmAddObjectDefConstraint(extraTreesID, avoidAll);
   rmAddObjectDefConstraint(extraTreesID, avoidCoin);
   rmAddObjectDefConstraint(extraTreesID, avoidSocket);
   rmAddObjectDefConstraint(extraTreesID, avoidTradeRoute);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTreesID, 0, rmAreaID("player"+i), 1);

   int extraTrees2ID=rmCreateObjectDef("more extra trees");
   rmAddObjectDefItem(extraTrees2ID, treeType, 5, 6.0);
   rmSetObjectDefMinDistance(extraTrees2ID, 18);
   rmSetObjectDefMaxDistance(extraTrees2ID, 28);
   rmAddObjectDefConstraint(extraTrees2ID, avoidAll);
   rmAddObjectDefConstraint(extraTrees2ID, avoidCoin);
   rmAddObjectDefConstraint(extraTrees2ID, avoidSocket);
   rmAddObjectDefConstraint(extraTrees2ID, avoidTradeRoute);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTrees2ID, 0, rmAreaID("player"+i), 2);


   // Text
   rmSetStatusText("",0.75);

// Main forests
   int forestChance = -1;

      numTries=11*cNumberNonGaiaPlayers;
      if (cNumberNonGaiaPlayers == 3)
         numTries=10*cNumberNonGaiaPlayers; 
      if (cNumberNonGaiaPlayers > 3)
         numTries=9*cNumberNonGaiaPlayers;  
      if (cNumberNonGaiaPlayers > 5)
         numTries=8*cNumberNonGaiaPlayers;  
      if (cNumberNonGaiaPlayers > 7)
         numTries=7*cNumberNonGaiaPlayers;   

   failCount=0;
   for (i=0; <numTries)
   {
      forestChance = rmRandInt(1,4);
      int forest=rmCreateArea("forest "+i);
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(280));
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
	rmAddAreaConstraint(forest, mediumPlayerConstraint);
      rmAddAreaConstraint(forest, forestConstraint);
      rmAddAreaConstraint(forest, avoidAll); 
	rmAddAreaConstraint(forest, avoidCoin);  
	rmAddAreaConstraint(forest, avoidBarrier);
	rmAddAreaConstraint(forest, avoidBase);
      rmAddAreaConstraint(forest, avoidImpassableLand); 
      rmAddAreaConstraint(forest, avoidTradeRoute);
	rmAddAreaConstraint(forest, avoidStartingUnits);
	rmAddAreaConstraint(forest, avoidSocket);
	rmAddAreaConstraint(forest, avoidNativesShort);
	if (hillTrees == 1)
	{
	   if (rmRandInt(1,3) > 1)
            rmSetAreaBaseHeight(forest, rmRandFloat(1.5, 5.0));
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
   rmSetStatusText("",0.80);

// Extra silver mines - more central.
   silverType = rmRandInt(1,10);
   int extraGoldID = rmCreateObjectDef("extra silver "+i);
   if (placeGold == 5)
      rmAddObjectDefItem(extraGoldID, "minegold", 1, 0);
   else
      rmAddObjectDefItem(extraGoldID, mineType, 1, 0.0);
   rmAddObjectDefToClass(extraGoldID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(extraGoldID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraGoldID, avoidSocket);
   rmAddObjectDefConstraint(extraGoldID, coinAvoidCoin);
   rmAddObjectDefConstraint(extraGoldID, shortAvoidCanyons);
   rmAddObjectDefConstraint(extraGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(extraGoldID, avoidBarrier);
   rmAddObjectDefConstraint(extraGoldID, avoidAll);
   rmSetObjectDefMinDistance(extraGoldID, 0.0);
   rmSetObjectDefMaxDistance(extraGoldID, 90.0);
   rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.5, 0.5, rmRandInt(1,2));
   if (axisChance == 1)
   {
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.44, 0.78, 1);
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.56, 0.22, 1);
      if (cNumberNonGaiaPlayers > 4)
	{
         rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.44, 0.22, 1);
         rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.56, 0.78, 1);
	}
   }
   else
   {
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.8, 0.55, 1);
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.2, 0.45, 1);
      if (cNumberNonGaiaPlayers > 4)
	{
         rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.2, 0.55, 1);
         rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.8, 0.45, 1);
	}
   }

   silverType = rmRandInt(1,10);
   int GoldFarID=rmCreateObjectDef("player silver far");
   if (placeGold == 1)
      rmAddObjectDefItem(GoldFarID, "minegold", 1, 0);
   else
      rmAddObjectDefItem(GoldFarID, mineType, 1, 0.0);
   rmAddObjectDefConstraint(GoldFarID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldFarID, avoidSocket);
   rmAddObjectDefConstraint(GoldFarID, coinAvoidCoin);
   rmAddObjectDefConstraint(GoldFarID, shortAvoidCanyons);
   rmAddObjectDefConstraint(GoldFarID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(GoldFarID, avoidBarrier);
   rmAddObjectDefConstraint(GoldFarID, avoidAll);
   rmAddObjectDefConstraint(GoldFarID, fartherPlayerConstraint);
   rmAddObjectDefConstraint(GoldFarID, centerConstraintFar);
   rmSetObjectDefMinDistance(GoldFarID, 100.0);
   rmSetObjectDefMaxDistance(GoldFarID, 120.0);
   rmPlaceObjectDefPerPlayer(GoldFarID, false, 1);

// sheep etc
   if (sheepChance > 0)
   {
      int sheepID=rmCreateObjectDef("herdable animal");
      rmAddObjectDefItem(sheepID, sheepType, 2, 4.0);
      rmAddObjectDefToClass(sheepID, rmClassID("herdableFood"));
      rmSetObjectDefMinDistance(sheepID, 40.0);
      rmSetObjectDefMaxDistance(sheepID, 0.2*longSide);
      rmAddObjectDefConstraint(sheepID, avoidSheep);
      rmAddObjectDefConstraint(sheepID, avoidAll);
      rmAddObjectDefConstraint(sheepID, playerConstraint);
      rmAddObjectDefConstraint(sheepID, avoidCliffs);
      rmAddObjectDefConstraint(sheepID, avoidBarrier);
      rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
      rmPlaceObjectDefPerPlayer(sheepID, false, 2);
      rmAddObjectDefConstraint(sheepID, farPlayerConstraint);
      rmSetObjectDefMaxDistance(sheepID, 0.35*longSide);
      if (rmRandInt(1,2) == 1)
         rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);
      else 
         rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3); 
   }

   // Text
   rmSetStatusText("",0.85);

// Central herds
   int centralHerdID=rmCreateObjectDef("central herd");  
   rmAddObjectDefItem(centralHerdID, centerHerdType, rmRandInt(8,9), 6.0);
   rmAddObjectDefToClass(centralHerdID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(centralHerdID, 0.15*size);
   rmSetObjectDefMaxDistance(centralHerdID, 0.22*size);
   rmAddObjectDefConstraint(centralHerdID, avoidTradeRoute);
   rmAddObjectDefConstraint(centralHerdID, avoidImportantItem);
   rmAddObjectDefConstraint(centralHerdID, farPlayerConstraint);
   rmAddObjectDefConstraint(centralHerdID, longHuntableConstraint);
   rmAddObjectDefConstraint(centralHerdID, avoidBarrier);
   rmSetObjectDefCreateHerd(centralHerdID, true);
   rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.5, 0.5, 2);

   // additional of central herd type per player
   rmAddObjectDefConstraint(centralHerdID, fartherPlayerConstraint);
   rmSetObjectDefMinDistance(centralHerdID, 0.25*size);
   rmSetObjectDefMaxDistance(centralHerdID, 0.35*size);
   rmPlaceObjectDefPerPlayer(centralHerdID, false, 1);

// Far huntable
   int farHuntableID=rmCreateObjectDef("far huntable");
   rmAddObjectDefItem(farHuntableID, deerType, rmRandInt(7,9), 6.0);
   rmAddObjectDefToClass(farHuntableID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farHuntableID, 0.22*size);
   rmSetObjectDefMaxDistance(farHuntableID, 0.35*size);
   rmAddObjectDefConstraint(farHuntableID, avoidTradeRoute);
   rmAddObjectDefConstraint(farHuntableID, avoidImportantItem);
   rmAddObjectDefConstraint(farHuntableID, fartherPlayerConstraint);
   rmAddObjectDefConstraint(farHuntableID, longHuntableConstraint);
   rmAddObjectDefConstraint(farHuntableID, avoidAll);
   rmAddObjectDefConstraint(farHuntableID, avoidBarrier);
   rmSetObjectDefCreateHerd(farHuntableID, true);
   rmPlaceObjectDefPerPlayer(farHuntableID, false, 1);

// Lone elk
   int loneElkID=rmCreateObjectDef("lone elk");
   threeChoice = rmRandInt(1,3);
   if (threeChoice == 1)
      rmAddObjectDefItem(loneElkID, centerHerdType, rmRandInt(4,4), 3.0);
   else if (threeChoice == 2)
      rmAddObjectDefItem(loneElkID, deer2Type, rmRandInt(4,4), 3.0);
   else
      rmAddObjectDefItem(loneElkID, deerType, rmRandInt(4,4), 3.0);
   rmAddObjectDefToClass(loneElkID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(loneElkID, 75.0);
   rmSetObjectDefMaxDistance(loneElkID, 0.4*size);
   rmAddObjectDefConstraint(loneElkID, longPlayerConstraint);
   rmAddObjectDefConstraint(loneElkID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(loneElkID, avoidNativesShort);
   rmAddObjectDefConstraint(loneElkID, huntableConstraint);
   rmAddObjectDefConstraint(loneElkID, avoidBarrier);
   rmAddObjectDefConstraint(loneElkID, avoidAll);
   rmSetObjectDefCreateHerd(loneElkID, true);
   rmPlaceObjectDefPerPlayer(loneElkID, false, 2);

   // Text
   rmSetStatusText("",0.90);

// Random trees
   int numTrees = cNumberNonGaiaPlayers*9;
   if (cNumberNonGaiaPlayers == 2)
	numTrees = cNumberNonGaiaPlayers*15;
   if (cNumberNonGaiaPlayers == 3)
	numTrees = cNumberNonGaiaPlayers*13;
   if (cNumberNonGaiaPlayers == 4)
	numTrees = cNumberNonGaiaPlayers*11;
   int StragglerTreeID=rmCreateObjectDef("stragglers");
   rmAddObjectDefItem(StragglerTreeID, treeType, 2, 0.0);
   rmAddObjectDefConstraint(StragglerTreeID, avoidAll);
   rmAddObjectDefConstraint(StragglerTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StragglerTreeID, avoidCoin);
   rmAddObjectDefConstraint(StragglerTreeID, patchConstraint);
   rmAddObjectDefConstraint(StragglerTreeID, avoidBarrier);
   rmSetObjectDefMinDistance(StragglerTreeID, 10.0);
   rmSetObjectDefMaxDistance(StragglerTreeID, rmXFractionToMeters(0.5));
   for(i=0; <numTrees)
      rmPlaceObjectDefAtLoc(StragglerTreeID, 0, 0.5, 0.5);



   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .15, avoidCliffs);
   }



   // Text
   rmSetStatusText("",0.99);
}  

  
