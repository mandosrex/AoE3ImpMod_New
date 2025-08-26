// Team Archipelago Asian
// by RF_Gandalf
// A Random map script for AOE3: The Asian Dynasties

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
// Text
   rmSetStatusText("",0.01);

// Set up for variables
   string seaType = "";
   string baseType = "";
   string forestType = "";
   string treeType = "";
   string deerType = "";
   string deer2Type = "";
   string sheepType = "";
   string centerHerdType = "";
   string fishType = "";
   string fish2Type = "";
   string whaleType = "";
   string native1Name = "";
   string native2Name = "";
   string mineType = "";
   string propType = "";
   string brushType = "";
   string tradeRouteType = "";

// Pick pattern for trees, terrain, features, etc.
   int patternChance = rmRandInt(1,2);   
   int variantChance = rmRandInt(1,2);
   int axisChance = rmRandInt(1,2);
   int playerSide = rmRandInt(1,2);   
   int positionChance = rmRandInt(1,2);   
   int distChance = rmRandInt(1,6);
   int sectionChance = rmRandInt(1,12);
   int directionChance = rmRandInt(1,2);
   int nativePattern = -1;
   int sheepChance = rmRandInt(1,2);
   int tropical = 0;
   int arctic = 0;
   int placeBerries = 1;
   int noHeight = 0;
   int nativeChoice = rmRandInt(1,2);
   int baseHeight = rmRandInt(1,2);
   int twoChoice = rmRandInt(1,2);
   int fourChoice = rmRandInt(1,4);
   int fiveChoice = rmRandInt(1,5);
   int sixChoice = rmRandInt(1,6);
   int extraNativeIs = 0;
   int forestCoverUp = 0;
   int lowForest = 0;
   int cacheChance = rmRandInt(1,2);
   int cacheType = 0;
   int llamaCache = 0;
   int berryCache = 0;
   int campfireCache = 0;
   int centeredBigIsland = 0;
   int eBigIs = 0;
   int wBigIs = 0;
   int nBigIs = 0;
   int sBigIs = 0;
   int eEdgeIs = 0;
   int wEdgeIs = 0;
   int nEdgeIs = 0;
   int sEdgeIs = 0;
   int vultures = 0;
   int kingfishers = 0;
   int waterNuggets = 0;
   mineType = "mine";

// Text
   rmSetStatusText("",0.05);

// Picks the map size
   int playerTiles=34000;  
   if (cNumberNonGaiaPlayers == 8)
	playerTiles = 22000;
   else if (cNumberNonGaiaPlayers == 7)
	playerTiles = 24000;  
   else if (cNumberNonGaiaPlayers == 6)
	playerTiles = 26000;
   else if (cNumberNonGaiaPlayers == 5)
	playerTiles = 28000;  
   else if (cNumberNonGaiaPlayers == 4)
	playerTiles = 30000;
   else if (cNumberNonGaiaPlayers == 3)
	playerTiles = 32000; 

   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles/0.8);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   int mapDimension = rmRandInt(0,2);
   int longSide = size*1.1;

   if (mapDimension == 0)
      rmSetMapSize(size, size);
   else if (mapDimension == 1)
      rmSetMapSize(longSide, size);
   else if (mapDimension == 2)
      rmSetMapSize(size, longSide);

   rmSetSeaLevel(0.0);

// Select terrain pattern details
   if (patternChance == 1)
   {
      rmSetSeaType("Micronesia");
      rmSetMapType("micronesia");
      rmSetMapType("asia");
      rmSetMapType("water");
      rmSetMapType("tropical");
      rmSetMapType("AITransportRequired");
      rmSetMapType("AIFishingUseful");
      rmSetLightingSet("california");

      baseType = "micronesia_a";
	forestType = "Micronesia Forest";
	treeType = "ypTreeMicronesia";
      if (variantChance == 1)
	{
         deerType = "Crab";
         deer2Type = "Tortoise";
         centerHerdType = "Crab";         
	}
      else 
	{     
         deerType = "Tortoise";
         deer2Type = "Crab";
         centerHerdType = "Tortoise";        
	}
      sheepType = "ypGoat";
      fishType = "ypFishTuna";
      fish2Type = "FishCod";
      whaleType = "minkeWhale";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineCopper";
	lowForest = rmRandInt(0,1);
	cacheType = 6;  
      nativePattern = 1;
   }
   else if (patternChance == 2)
   {
      rmSetSeaType("Micronesia");
      rmSetMapType("micronesia");
      rmSetMapType("asia");
      rmSetMapType("water");
      rmSetMapType("tropical");
      rmSetMapType("AITransportRequired");
      rmSetMapType("AIFishingUseful");
      rmSetLightingSet("california");

      baseType = "micronesia_a";
	forestType = "Micronesia Forest";
	treeType = "ypTreeMicronesia";
      if (variantChance == 1)
	{
         deerType = "Tortoise";
         deer2Type = "Crab";
         centerHerdType = "Tortoise";         
	}
      else 
	{     
         deerType = "Crab";
         deer2Type = "Tortoise";
         centerHerdType = "Crab";        
	}
      sheepType = "ypGoat";
      fishType = "ypFishTuna";
      fish2Type = "FishCod";
      whaleType = "minkeWhale";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineCopper";
	lowForest = rmRandInt(0,1);
	cacheType = 6;  
      nativePattern = 2;
   }

   tradeRouteType = "water";

// Native patterns
  if (nativePattern == 1)
  {
      rmSetSubCiv(0, "zen");
      native1Name = "native zen temple ceylon 0";
      rmSetSubCiv(1, "shaolin");
      native2Name = "native shaolin temple yr 0";
  }
  else if (nativePattern == 2)
  {
      rmSetSubCiv(0, "shaolin");
      native1Name = "native shaolin temple yr 0";
      rmSetSubCiv(1, "zen");
      native2Name = "native zen temple ceylon 0";
  }


   rmTerrainInitialize("water");
   rmSetMapType("water");
   rmSetWorldCircleConstraint(true);
   rmSetWindMagnitude(2.0);
   chooseMercs();

// Define some classes.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
   rmDefineClass("nuggets");
   rmDefineClass("center");
   rmDefineClass("socketClass");
   rmDefineClass("classFish");
   int classHuntable=rmDefineClass("huntableFood");   
   int classHerdable=rmDefineClass("herdableFood"); 
   int classMines=rmDefineClass("all mines"); 
   int classCenterIsland=rmDefineClass("center island");
   int classBonusIsland=rmDefineClass("bonus island");
   int classSettlementIsland=rmDefineClass("settlement island");
   int classNativeIsland=rmDefineClass("native island");
   int classGoldIsland=rmDefineClass("gold island");
   int islandsX=rmDefineClass("islandsX");
   int islandsY=rmDefineClass("islandsY");
   int islandsZ=rmDefineClass("islandsZ");
   int teamClass=rmDefineClass("teamClass"); 

// Text
   rmSetStatusText("",0.10);

// -------------Define constraints
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(16), rmZTilesToFraction(16), 1.0-rmXTilesToFraction(16), 1.0-rmZTilesToFraction(16), 0.01);
   int teamEdgeConstraint=rmCreateBoxConstraint("team edge of map", rmXTilesToFraction(16), rmZTilesToFraction(16), 1.0-rmXTilesToFraction(16), 1.0-rmZTilesToFraction(16), 0.01);
   int shortEdgeConstraint=rmCreatePieConstraint("short axis edge of map", 0.5, 0.5, 0, size*0.48, rmDegreesToRadians(0), rmDegreesToRadians(360));
   int circleEdgeConstraint=rmCreatePieConstraint("circle edge Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.46), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int circleEdgeConstraint2=rmCreatePieConstraint("circle edge Constraint 2", 0.5, 0.5, 0, rmXFractionToMeters(0.46), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // Center constraints
   int centerConstraint=rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), 30.0);
   int centerConstraintShort=rmCreateClassDistanceConstraint("stay away from center short", rmClassID("center"), 12.0);
   int centerConstraintFar=rmCreateClassDistanceConstraint("stay away from center far", rmClassID("center"), 70.0);
   int centralExtraLandConstraint=rmCreatePieConstraint("circle Constraint for extra land", 0.5, 0.5, 0, rmZFractionToMeters(0.17), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int centralExtraLandConstraint2=rmCreatePieConstraint("2nd circle Constraint for extra land", 0.5, 0.5, 0, rmZFractionToMeters(0.13), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // Player constraints
   int playerConstraintShort=rmCreateClassDistanceConstraint("short stay away from players", classPlayer, 15.0);
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 45.0);
   int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 25.0);
   int nuggetPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 60.0);
   int farPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players more", classPlayer, 85.0);
   int fartherPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players the most", classPlayer, 105.0);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 75.0);
   int avoidTC=rmCreateTypeDistanceConstraint("stuff vs TC", "TownCenter", 40.0);

   float constraintChance = rmRandFloat(0,1);
   int constraintNum = 0;
   if(constraintChance < 0.25)
      constraintNum = 29;
   else if(constraintChance < 0.5)
      constraintNum = 30;
   else if(constraintChance < 0.75)
      constraintNum = 32;
   else 
      constraintNum = 34;
   int playerLandConstraint=rmCreateClassDistanceConstraint("players land stay away from players", classPlayer, constraintNum); 

   // Nature avoidance
   int forestConstraint2=rmCreateClassDistanceConstraint("forest v forest2", rmClassID("classForest"), 10.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 17.0);
   int avoidCoin=rmCreateClassDistanceConstraint("avoid coin", rmClassID("all mines"), 10.0);
   int coinAvoidCoin=rmCreateClassDistanceConstraint("coin avoids coin", rmClassID("all mines"), 35.0);
   int longAvoidCoin=rmCreateClassDistanceConstraint("long avoid coin", rmClassID("all mines"), 90.0);
   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   int avoidSheep=rmCreateClassDistanceConstraint("sheep avoids sheep etc", rmClassID("herdableFood"), 45.0);
   int huntableConstraint=rmCreateClassDistanceConstraint("huntable constraint", rmClassID("huntableFood"), 35.0);

   // Avoid impassable land, certain features
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 18.0);
   int avoidWater10 = rmCreateTerrainDistanceConstraint("avoid water mid-long", "Land", false, 10.0);
   int avoidWater15 = rmCreateTerrainDistanceConstraint("avoid water mid-longer", "Land", false, 15.0);
   int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water a little more", "Land", false, 20.0);
   int rockVsLand = rmCreateTerrainDistanceConstraint("rock v. land", "land", true, 2.0);
   int nearWater = rmCreateTerrainMaxDistanceConstraint("stay near Water", "Water", true, 5.0);
   int avoidLand4 = rmCreateTerrainDistanceConstraint("avoid land by 4", "land", true, 4.0);
   int avoidLand10 = rmCreateTerrainDistanceConstraint("avoid land by 10", "land", true, 10.0);
   int nearShore=rmCreateTerrainMaxDistanceConstraint("stay near shore", "land", true, 5.0);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 10.0);
   int avoidStartingUnitsLong=rmCreateClassDistanceConstraint("long avoid starting units", rmClassID("startingUnit"), 45.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("things avoid each other", rmClassID("importantItem"), 10.0);
   int avoidImportantItemSmall=rmCreateClassDistanceConstraint("important item small avoidance", rmClassID("importantItem"), 7.0);
   int avoidImportantItemMed=rmCreateClassDistanceConstraint("things avoid each other med", rmClassID("importantItem"), 35.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 60.0);
   int avoidNativesLong=rmCreateClassDistanceConstraint("stuff avoids natives longer", rmClassID("natives"), 90.0);
   int avoidNativesShort=rmCreateClassDistanceConstraint("stuff avoids natives shorter", rmClassID("natives"), 15.0);
   int avoidNugget=rmCreateClassDistanceConstraint("stuff avoids nuggets", rmClassID("nuggets"), 40.0);
   int avoidNuggetLong=rmCreateClassDistanceConstraint("avoids nuggets long", rmClassID("nuggets"), 70.0);
   int avoidNuggetSmall=rmCreateClassDistanceConstraint("avoids nuggets small", rmClassID("nuggets"), 10.0);
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
   int avoidKOTH=rmCreateTypeDistanceConstraint("avoid KOTH", "ypKingsHill", 8.0);

   // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
   int avoidSocket=rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 10.0);

   // Water spawn point avoidance.
   int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 5.0);
   int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 40);
   int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-30, rmGetMapXSize()-5, 0, 0, 0);

   // Center constraint
   int avoidCenter=rmCreateClassDistanceConstraint("avoid the center", rmClassID("center"), 30.0);
 
   // Island constraints
   float constraintChance2 = rmRandFloat(0,1);
   int constraintNum2 = 0;
   if(constraintChance2 < 0.33)
      constraintNum2 = 26;
   else if(constraintChance2 < 0.66)
      constraintNum2 = 29;
   else 
      constraintNum2 = 32;
   float constraintChance3 = rmRandFloat(0,1);
   int constraintNum3 = 0;
   if(constraintChance3 < 0.33)
      constraintNum3 = 27;
   else if(constraintChance3 < 0.66)
      constraintNum3 = 30;
   else
      constraintNum3 = 32;

   int settlementIslandConstraint=rmCreateClassDistanceConstraint("avoid settlement islands", classSettlementIsland, constraintNum3); 
   int centerIslandConstraint=rmCreateClassDistanceConstraint("avoid center island", classCenterIsland, constraintNum2);
   int nativeIslandConstraint=rmCreateClassDistanceConstraint("avoid native island", classNativeIsland, constraintNum3);
   int nativeIslandConstraintLarge=rmCreateClassDistanceConstraint("avoid native island large", classNativeIsland, rmXFractionToMeters(0.28));
   int islandsXvsY=rmCreateClassDistanceConstraint("island X avoids Y", islandsY, rmRandInt(27,32));
   int islandsYvsX=rmCreateClassDistanceConstraint("island Y avoids X", islandsX, rmRandInt(27,32));
   int islandsXYvsZ=rmCreateClassDistanceConstraint("islands Y and X avoid Z", islandsZ, rmRandInt(27,32));
   int islandsZvsX=rmCreateClassDistanceConstraint("island Z avoids X", islandsX, rmRandInt(27,32));
   int islandsZvsY=rmCreateClassDistanceConstraint("island Z avoids Y", islandsY, rmRandInt(27,32));

   // Team constraints
   int teamConstraint=rmCreateClassDistanceConstraint("team constraint", teamClass, 60.0);
   int avoidTeamLands=rmCreateClassDistanceConstraint("avoid team lands", rmClassID("teamClass"), 2.0);
   int landAvoidTeamLands=rmCreateClassDistanceConstraint("land avoids team lands", rmClassID("teamClass"), constraintNum);

   // Cardinal Directions - "quadrants" of the map.
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.75, 0, rmZFractionToMeters(0.22), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.25, 0, rmZFractionToMeters(0.22), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.75, 0.5, 0, rmZFractionToMeters(0.22), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.25, 0.5, 0, rmZFractionToMeters(0.22), rmDegreesToRadians(0), rmDegreesToRadians(360));

// ---------------------------------------------------------------------------------------End constraints

// Text
   rmSetStatusText("",0.15);

// NATIVES - defined
   // Village A 
   int villageAID = -1;
   int whichNative = rmRandInt(1,2);
   int villageType = rmRandInt(1,5);
   if (whichNative == 1)
	   villageAID = rmCreateGrouping("village A", native1Name+villageType);
   else if (whichNative == 2)
	   villageAID = rmCreateGrouping("village A", native2Name+villageType);
   rmAddGroupingToClass(villageAID, rmClassID("natives"));
   rmAddGroupingToClass(villageAID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageAID, 45.0);
   rmSetGroupingMaxDistance(villageAID, 75.0);
   rmAddGroupingConstraint(villageAID, avoidImpassableLand);
   rmAddGroupingConstraint(villageAID, avoidTradeRoute);
   rmAddGroupingConstraint(villageAID, avoidSocket);
   rmAddGroupingConstraint(villageAID, avoidWater15);
   rmAddGroupingConstraint(villageAID, avoidNatives);
   rmAddGroupingConstraint(villageAID, avoidTC);
   rmAddGroupingConstraint(villageAID, avoidKOTH);

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
   rmSetGroupingMaxDistance(villageDID, rmXFractionToMeters(0.05));
   rmAddGroupingConstraint(villageDID, avoidImpassableLand);
   rmAddGroupingConstraint(villageDID, avoidTradeRoute);
   rmAddGroupingConstraint(villageDID, avoidSocket);
   rmAddGroupingConstraint(villageDID, avoidWater15);
   rmAddGroupingConstraint(villageDID, avoidNativesLong);
   rmAddGroupingConstraint(villageDID, playerConstraint);
   rmAddGroupingConstraint(villageDID, avoidKOTH);

// Center area
   int centerArea=rmCreateArea("TheCenter");
   rmSetAreaSize(centerArea, 0.08, 0.1);
   rmSetAreaLocation(centerArea, 0.5, 0.5);
   rmAddAreaToClass(centerArea, rmClassID("center")); 

// Text
   rmSetStatusText("",0.20);

// Set up player starting locations
   int fiveChance = rmRandInt(1,5);
   int threeChance = rmRandInt(1,3);
   int twoChance = rmRandInt(1,2);

   if (cNumberNonGaiaPlayers == 2)
   {   
	 sectionChance = rmRandInt(1,21);  
	 distChance = rmRandInt(1,3);
	 if (sectionChance == 1) // opposite, across axis 1
	 {
	    axisChance = 2;
          rmSetPlacementSection(0.0, 0.5);
	    if (fiveChance == 1)
		 eBigIs = 1;
	    else if (fiveChance == 2)
	 	 wBigIs = 1;
	    else if (fiveChance == 3)
	 	 eEdgeIs = 1;
	    else if (fiveChance == 4)
	 	 wEdgeIs = 1;
	    else if (fiveChance == 5)
	    {
		 if (rmRandInt(1,3) == 1)
		    directionChance = 0;
		 else
	       { 
		    if (rmRandInt(1,2) == 1)
		       directionChance = 1;
		    else
                   directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 2) // opposite, across axis 2
	 {
	    axisChance = 1;
          rmSetPlacementSection(0.25, 0.75);
	    if (fiveChance == 1)
		 nBigIs = 1;
	    else if (fiveChance == 2)
	 	 sBigIs = 1;
	    else if (fiveChance == 3)
	 	 nEdgeIs = 1;
	    else if (fiveChance == 4)
	 	 sEdgeIs = 1;
	    else if (fiveChance == 5)
	    {
		 if (rmRandInt(1,3) == 1)
		    directionChance = 0;
		 else
	       { 
		    if (rmRandInt(1,2) == 1)
		       directionChance = 1;
		    else
                   directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance < 5) // 3,4 East side of map
	 {
	    if (sectionChance == 3)
             rmSetPlacementSection(0.1, 0.4);
	    if (sectionChance == 4)
             rmSetPlacementSection(0.15, 0.35);
	    if (threeChance == 1)
		 wBigIs = 1;
	    else if (threeChance == 2)
	 	 wEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    directionChance = 0;
		    axisChance = 1;
		 }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 1;
		    else
                   directionChance = 0;
		 }
	    }
	 }
	 else if (sectionChance < 7) // 5,6 W side of map
	 {
	    if (sectionChance == 5)
             rmSetPlacementSection(0.6, 0.9);
	    if (sectionChance == 6)
             rmSetPlacementSection(0.65, 0.85);
	    if (threeChance == 1)
		 eBigIs = 1;
	    else if (threeChance == 2)
	 	 eEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    directionChance = 0;
		    axisChance = 1;
		 }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 2;
		    else
                   directionChance = 0;
		 }
	    }
	 }
	 else if (sectionChance < 9) // 7,8 S side of map
	 {
	    if (sectionChance == 7)
             rmSetPlacementSection(0.35, 0.65);
	    if (sectionChance == 8)
             rmSetPlacementSection(0.4, 0.6);
	    if (threeChance == 1)
		 nBigIs = 1;
	    else if (threeChance == 2)
	 	 nEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    directionChance = 0;
		    axisChance = 2;
		 }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 2;
		    else
                   directionChance = 0;
		 }
	    }
	 }
	 else if (sectionChance < 11) // 9,10 N side of map
	 {
	    if (sectionChance == 9)
             rmSetPlacementSection(0.85, 0.15);
	    if (sectionChance == 10)
             rmSetPlacementSection(0.9, 0.1);
	    if (threeChance == 1)
		 sBigIs = 1;
	    else if (threeChance == 2)
	 	 sEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    directionChance = 0;
		    axisChance = 2;
		 }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 1;
		    else
                   directionChance = 0;
		 }
	    }
	 }
	 else if (sectionChance == 11) // next 4 same side, 0.4 of map
	 {
          rmSetPlacementSection(0.05, 0.45); // E
	    if (threeChance == 1)
		 wBigIs = 1;
	    else if (threeChance == 2)
	 	 wEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,2) == 1)
		 {
		    directionChance = 0;
		    axisChance = 2;
		 }
		 else
		 {
		    axisChance = 2;
		    directionChance = 1;
		 }
	    }
	 }
	 else if (sectionChance == 12)
	 {
          rmSetPlacementSection(0.55, 0.95); // W
	    if (threeChance == 1)
		 eBigIs = 1;
	    else if (threeChance == 2)
	 	 eEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,2) == 1)
		 {
		    directionChance = 0;
		    axisChance = 2;
		 }
		 else
		 {
		    axisChance = 2;
  	          directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 13)
	 {
          rmSetPlacementSection(0.3, 0.7); // S
	    if (threeChance == 1)
		 nBigIs = 1;
	    else if (threeChance == 2)
	 	 nEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,2) == 1)
		 {
		    directionChance = 0;
		    axisChance = 1;
		 }
		 else
		 {
		    axisChance = 1;
		    directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 14)
	 {
          rmSetPlacementSection(0.8, 0.2); // N
	    if (threeChance == 1)
		 sBigIs = 1;
	    else if (threeChance == 2)
	 	 sEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,2) == 1)
		 {
		    directionChance = 0;
		    axisChance = 1;
		 }
		 else
		 {
		    axisChance = 1;
		    directionChance = 1;
		 }
          }
	 }
	 else if (sectionChance == 15) // opposite, not on axis
	 {
             rmSetPlacementSection(0.1, 0.6);
		 if (rmRandInt(1,4) == 1)
		 {
		    directionChance = 0;
		    axisChance = 1;
		 }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,3) == 1)
		       directionChance = 0;
		    else
		    {
		       if (rmRandInt(1,2) == 1)
		          directionChance = 1;
		       else
                      directionChance = 2;
		    }
		 }
	 }
	 else if (sectionChance == 16) // opposite, not on axis
	 {
             rmSetPlacementSection(0.4, 0.9);
		 if (rmRandInt(1,4) == 1)
		 {
		    directionChance = 0;
		    axisChance = 1;
		 }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,3) == 1)
		       directionChance = 0;
		    else
		    {
		       if (rmRandInt(1,2) == 1)
		          directionChance = 1;
		       else
                      directionChance = 2;
		    }
		 }
	 }
	 else if (sectionChance == 17) // opposite, not on axis
	 {
             rmSetPlacementSection(0.15, 0.65);
		 if (rmRandInt(1,4) == 1)
		 {
		    directionChance = 0;
		    axisChance = 2;
		 }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,3) == 1)
		       directionChance = 0;
		    else
		    {
		       if (rmRandInt(1,2) == 1)
		          directionChance = 1;
		       else
                      directionChance = 2;
		    }
		 }
	 }
	 else if (sectionChance == 18) // opposite, not on axis
	 {
             rmSetPlacementSection(0.35, 0.85);
		 if (rmRandInt(1,4) == 1)
		 {
		    directionChance = 0;
		    axisChance = 2;
		 }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,3) == 1)
		       directionChance = 0;
		    else
		    {
		       if (rmRandInt(1,2) == 1)
		          directionChance = 1;
		       else
                      directionChance = 2;
		    }
		 }
	 }
	 else if (sectionChance == 19) // asymmetric
	 {
          rmSetPlacementSection(0.2, 0.4);
	    if (threeChance == 1)
		 wBigIs = 1;
	    else if (threeChance == 2)
	 	 wEdgeIs = 1;
	    else if (threeChance == 3)
	    {
  	       directionChance = 1;
		 axisChance = 2;
	    }
	 }
	 else if (sectionChance == 20) // asymmetric
	 {
          rmSetPlacementSection(0.6, 0.8);
	    if (threeChance == 1)
		 eBigIs = 1;
	    else if (threeChance == 2)
	 	 eEdgeIs = 1;
	    else if (threeChance == 3)
	    {
  	       directionChance = 2;
		 axisChance = 2;
	    }
	 }
	 else if (sectionChance == 21) // asymmetric
	 {
             rmSetPlacementSection(0.0, 0.7);
		 axisChance = 2;
		 if (rmRandInt(1,2) == 1)
		 {
		    directionChance = 0;
		 }
		 else
		 {
		    directionChance = 1;
		 }
	 }
	    if (distChance == 1)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.33, 0.34, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
   }
   else if (cNumberTeams == 3)  
   {
	 sectionChance = rmRandInt(1,15);
	 if (sectionChance == 1) // east - next 4 0.5 circ
	 {
          rmSetPlacementSection(0.0, 0.5);
	    if (threeChance == 1)
		 wBigIs = 1;
	    else if (threeChance == 2)
	 	 wEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 1;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 1;
		 }
	    }
	 }
	 else if (sectionChance == 2) // south 
	 {
          rmSetPlacementSection(0.25, 0.75);
	    if (threeChance == 1)
		 nBigIs = 1;
	    else if (threeChance == 2)
	 	 nEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 2;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 3) // west
	 {
          rmSetPlacementSection(0.5, 0.0);
	    if (threeChance == 1)
		 eBigIs = 1;
	    else if (threeChance == 2)
	 	 eEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 1;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 4) // north
	 {
          rmSetPlacementSection(0.75, 0.25);
	    if (threeChance == 1)
		 sBigIs = 1;
	    else if (threeChance == 2)
	 	 sEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 2;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 1;
		 }
	    }
	 }
	 else if (sectionChance == 5) // east - next 4 0.6 circ 
	 {
          rmSetPlacementSection(0.95, 0.55);
	    if (threeChance == 1)
		 wBigIs = 1;
	    else if (threeChance == 2)
	 	 wEdgeIs = 1;
	    else if (threeChance == 3)
	    {		
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 1;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 1;
		 }
	    }
	 }
	 else if (sectionChance == 6) // south 
	 {
          rmSetPlacementSection(0.15, 0.85);
	    if (threeChance == 1)
		 nBigIs = 1;
	    else if (threeChance == 2)
	 	 nEdgeIs = 1;
	    else if (threeChance == 3)
	    {	
             if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 2;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 7) // west
	 {
          rmSetPlacementSection(0.4, 0.1);
	    if (threeChance == 1)
		 eBigIs = 1;
	    else if (threeChance == 2)
	 	 eEdgeIs = 1;
	    else if (threeChance == 3)
	    {	
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 1;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 8) // north
	 {
          rmSetPlacementSection(0.65, 0.35);
	    if (threeChance == 1)
		 sBigIs = 1;
	    else if (threeChance == 2)
	 	 sEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 2;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 1;
		 }
	    }
	 }
	 else if (sectionChance == 9) // east - next 4 0.6 circ, not on axis
	 {
          rmSetPlacementSection(0.00, 0.60);
	    if (twoChance == 1)
		 wBigIs = 1;
	    else if (twoChance == 2)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 1;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 1;
		 }
	    }
	 }
	 else if (sectionChance == 10) // south 
	 {
          rmSetPlacementSection(0.25, 0.85);
	    if (twoChance == 1)
		 nBigIs = 1;
	    else if (twoChance == 2)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 2;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 11) // west
	 {
          rmSetPlacementSection(0.50, 0.10);
	    if (twoChance == 1)
		 eBigIs = 1;
	    else if (twoChance == 2)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 1;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 12) // north
	 {
          rmSetPlacementSection(0.75, 0.35);
	    if (twoChance == 1)
		 sBigIs = 1;
	    else if (twoChance == 2)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 2;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 1;
		 }
	    }
	 }
	 else   // chance 13, 14, 15 whole circular
	 {
	    directionChance = 0;	
	 }
	    if (distChance == 1)
	       rmPlacePlayersCircular(0.31, 0.32, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.33, 0.34, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.35, 0.36, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
   }    
   else 
   {
      if (cNumberTeams == 2)
      {
        if (cNumberNonGaiaPlayers < 5) // 2 teams, 3 or 4 players   
        {
	    directionChance = 0;
          if (axisChance == 1)
          {
	      if (sectionChance == 9)
	      {
		    sBigIs = 1;
	      }
	      if (sectionChance == 10)
	      {
		    sEdgeIs = 1;
	      }
	      if (sectionChance == 11)
	      {
		    nBigIs = 1;
	      }
	      if (sectionChance == 12)
	      {
		    nEdgeIs = 1;
	      }

           if (playerSide == 1)
	  	  rmSetPlacementTeam(0);
           else if (playerSide == 2)
	        rmSetPlacementTeam(1);

	     if (sectionChance == 1)
	       rmSetPlacementSection(0.21, 0.29);
	     else if (sectionChance == 2)
             rmSetPlacementSection(0.18, 0.32);
	     else if (sectionChance == 3)
             rmSetPlacementSection(0.19, 0.31);
	     else if (sectionChance == 4)
             rmSetPlacementSection(0.2, 0.3);
	     else if (sectionChance == 5)
             rmSetPlacementSection(0.1, 0.23); // toward CC
	     else if (sectionChance == 6)
             rmSetPlacementSection(0.11, 0.21); // toward CC
	     else if (sectionChance == 7)
             rmSetPlacementSection(0.31, 0.4); // toward C
	     else if (sectionChance == 8)
             rmSetPlacementSection(0.27, 0.39); // toward C
	     else if (sectionChance == 9)
             rmSetPlacementSection(0.12, 0.26); // toward N
	     else if (sectionChance == 10)
		 rmSetPlacementSection(0.10, 0.22); // toward N
	     else if (sectionChance == 11)
		 rmSetPlacementSection(0.28, 0.38); // toward S
	     else if (sectionChance == 12)
             rmSetPlacementSection(0.27, 0.40); // toward S

 	     if (distChance == 1)
  	        rmPlacePlayersCircular(0.31, 0.32, 0.0);
  	     else if (distChance == 2)
      	  rmPlacePlayersCircular(0.32, 0.33, 0.0);
 	     else if (distChance == 3)
              rmPlacePlayersCircular(0.33, 0.34, 0.0);
	     else if (distChance == 4)
	        rmPlacePlayersCircular(0.34, 0.35, 0.0);
           else if (distChance == 5)
              rmPlacePlayersCircular(0.35, 0.36, 0.0);
	     else if (distChance == 6)
	        rmPlacePlayersCircular(0.36, 0.37, 0.0);

	     if (playerSide == 1) 
		  rmSetPlacementTeam(1);
  	     else if (playerSide == 2)
	        rmSetPlacementTeam(0);
	     
	     if (sectionChance == 1)
             rmSetPlacementSection(0.71, 0.79);
	     else if (sectionChance == 2)
             rmSetPlacementSection(0.68, 0.82);
	     else if (sectionChance == 3)
             rmSetPlacementSection(0.69, 0.81);
	     else if (sectionChance == 4)
             rmSetPlacementSection(0.7, 0.8);
	     else if (sectionChance == 5)
             rmSetPlacementSection(0.60, 0.73); // cc
	     else if (sectionChance == 6)
             rmSetPlacementSection(0.61, 0.71); // cc
	     else if (sectionChance == 7)
             rmSetPlacementSection(0.81, 0.90); // c
	     else if (sectionChance == 8)
             rmSetPlacementSection(0.77, 0.89); // c
	     else if (sectionChance == 9)
             rmSetPlacementSection(0.74, 0.88); // n
	     else if (sectionChance == 10)
             rmSetPlacementSection(0.78, 0.90); // n
	     else if (sectionChance == 11)
             rmSetPlacementSection(0.62, 0.72); // s
	     else if (sectionChance == 12)
             rmSetPlacementSection(0.60, 0.73); // s

 	     if (distChance == 1)
  	        rmPlacePlayersCircular(0.31, 0.32, 0.0);
  	     else if (distChance == 2)
      	  rmPlacePlayersCircular(0.32, 0.33, 0.0);
 	     else if (distChance == 3)
              rmPlacePlayersCircular(0.33, 0.34, 0.0);
	     else if (distChance == 4)
	        rmPlacePlayersCircular(0.34, 0.35, 0.0);
           else if (distChance == 5)
              rmPlacePlayersCircular(0.35, 0.36, 0.0);
	     else if (distChance == 6)
	        rmPlacePlayersCircular(0.36, 0.37, 0.0);
         }
         else if (axisChance == 2)
         {
	      if (sectionChance == 9)
	      {
		    wBigIs = 1;
	      }
	      if (sectionChance == 10)
	      {
		    wEdgeIs = 1;
	      }
	      if (sectionChance == 11)
	      {
		    eBigIs = 1;
	      }
	      if (sectionChance == 12)
	      {
		    eEdgeIs = 1;
	      }

	    if (playerSide == 1)
		 rmSetPlacementTeam(0);
          else if (playerSide == 2)
		 rmSetPlacementTeam(1);

	    if (sectionChance == 1)
             rmSetPlacementSection(0.46, 0.54);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.43, 0.57);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.44, 0.56);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.45, 0.55);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.35, 0.48); // toward CC
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.36, 0.46); // toward CC
	    else if (sectionChance == 7)
             rmSetPlacementSection(0.56, 0.65); // toward C
	    else if (sectionChance == 8)
             rmSetPlacementSection(0.52, 0.64); // toward C
	    else if (sectionChance == 9)
             rmSetPlacementSection(0.37, 0.51); // toward E
	    else if (sectionChance == 10)
             rmSetPlacementSection(0.40, 0.52); // toward E
	    else if (sectionChance == 11)
             rmSetPlacementSection(0.52, 0.62); // toward W
	    else if (sectionChance == 12)
             rmSetPlacementSection(0.52, 0.65); // toward W

 	     if (distChance == 1)
  	        rmPlacePlayersCircular(0.31, 0.32, 0.0);
  	     else if (distChance == 2)
      	  rmPlacePlayersCircular(0.32, 0.33, 0.0);
 	     else if (distChance == 3)
              rmPlacePlayersCircular(0.33, 0.34, 0.0);
	     else if (distChance == 4)
	        rmPlacePlayersCircular(0.34, 0.35, 0.0);
           else if (distChance == 5)
              rmPlacePlayersCircular(0.35, 0.36, 0.0);
	     else if (distChance == 6)
	        rmPlacePlayersCircular(0.36, 0.37, 0.0);

	    if (playerSide == 1)
		 rmSetPlacementTeam(1);
          else if (playerSide == 2)
		 rmSetPlacementTeam(0);
	    
	    if (sectionChance == 1)
             rmSetPlacementSection(0.96, 0.04);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.93, 0.07);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.94, 0.06);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.95, 0.05);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.85, 0.98); // toward CC
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.86, 0.96); // toward CC
	    else if (sectionChance == 7)
             rmSetPlacementSection(0.06, 0.15); // toward C
	    else if (sectionChance == 8)
             rmSetPlacementSection(0.02, 0.14); // toward C
	    else if (sectionChance == 9)
             rmSetPlacementSection(0.99, 0.13); // toward E
	    else if (sectionChance == 10)
             rmSetPlacementSection(0.98, 0.10); // toward E
	    else if (sectionChance == 11)
             rmSetPlacementSection(0.88, 0.98); // toward W
	    else if (sectionChance == 12)
             rmSetPlacementSection(0.85, 0.98); // toward W

 	     if (distChance == 1)
  	        rmPlacePlayersCircular(0.31, 0.32, 0.0);
  	     else if (distChance == 2)
      	  rmPlacePlayersCircular(0.32, 0.33, 0.0);
 	     else if (distChance == 3)
              rmPlacePlayersCircular(0.33, 0.34, 0.0);
	     else if (distChance == 4)
	        rmPlacePlayersCircular(0.34, 0.35, 0.0);
           else if (distChance == 5)
              rmPlacePlayersCircular(0.35, 0.36, 0.0);
	     else if (distChance == 6)
	        rmPlacePlayersCircular(0.36, 0.37, 0.0);
         }	  
        }
        else if (cNumberNonGaiaPlayers < 7) // for 2 teams, for 5-6 players  
        {
	       directionChance = 0;
             if (axisChance == 1)
             { 
	        if (sectionChance == 9)
	        {
	          if (twoChance == 1)
		     sBigIs = 1;
	          else if (twoChance == 2)
	 	     sEdgeIs = 1;
	        }
	        if (sectionChance == 10)
	        {
	          if (twoChance == 1)
		     sBigIs = 1;
	          else if (twoChance == 2)
	 	     sEdgeIs = 1;
	        }
	        if (sectionChance == 11)
	        {
	          if (twoChance == 1)
		     nBigIs = 1;
	          else if (twoChance == 2)
	 	     nEdgeIs = 1;
	        }
	        if (sectionChance == 12)
	        {
	          if (twoChance == 1)
		     nBigIs = 1;
	          else if (twoChance == 2)
	 	     nEdgeIs = 1;
	        }
 
             if (playerSide == 1)
	  	    rmSetPlacementTeam(0);
             else if (playerSide == 2)
		    rmSetPlacementTeam(1);

	       if (sectionChance == 1)
                rmSetPlacementSection(0.16, 0.35);
	       else if (sectionChance == 2)
                rmSetPlacementSection(0.17, 0.33);
	       else if (sectionChance == 3)
                rmSetPlacementSection(0.15, 0.35);
	       else if (sectionChance == 4)
                rmSetPlacementSection(0.16, 0.34);
	       else if (sectionChance == 5)
                rmSetPlacementSection(0.09, 0.24); // toward CC
	       else if (sectionChance == 6)
                rmSetPlacementSection(0.09, 0.27); // toward CC
	       else if (sectionChance == 7)
                rmSetPlacementSection(0.16, 0.34); // toward C
	       else if (sectionChance == 8)
                rmSetPlacementSection(0.21, 0.41); // toward C
	       else if (sectionChance == 9)
                rmSetPlacementSection(0.12, 0.32); // toward N
	       else if (sectionChance == 10)
	  	    rmSetPlacementSection(0.09, 0.25); // toward N
	       else if (sectionChance == 11)
                rmSetPlacementSection(0.18, 0.38); // toward S
	       else if (sectionChance == 12)
                rmSetPlacementSection(0.25, 0.42); // toward S

             if (distChance == 1)
                rmPlacePlayersCircular(0.31, 0.32, 0.0);
             else if (distChance == 2)
                rmPlacePlayersCircular(0.32, 0.33, 0.0);
        	 else if (distChance == 3)
         	    rmPlacePlayersCircular(0.33, 0.34, 0.0);
		 else if (distChance == 4)
	          rmPlacePlayersCircular(0.35, 0.36, 0.0);
      	 else if (distChance == 5)
	   	    rmPlacePlayersCircular(0.36, 0.37, 0.0);
		 else if (distChance == 6)
	          rmPlacePlayersCircular(0.37, 0.38, 0.0);

	       if (playerSide == 1)
		    rmSetPlacementTeam(1);
             else if (playerSide == 2)
		    rmSetPlacementTeam(0);

	       if (sectionChance == 1)
                rmSetPlacementSection(0.66, 0.85);
	       else if (sectionChance == 2)
                rmSetPlacementSection(0.67, 0.83);
	       else if (sectionChance == 3)
                rmSetPlacementSection(0.65, 0.85);
	       else if (sectionChance == 4)
                rmSetPlacementSection(0.66, 0.84);
	       else if (sectionChance == 5)
                rmSetPlacementSection(0.59, 0.74); // cc
	       else if (sectionChance == 6)
                rmSetPlacementSection(0.59, 0.77); // cc
	       else if (sectionChance == 7)
                rmSetPlacementSection(0.66, 0.84); // c
	       else if (sectionChance == 8)
                rmSetPlacementSection(0.71, 0.91); // c
	       else if (sectionChance == 9)
                rmSetPlacementSection(0.68, 0.88); // n
	       else if (sectionChance == 10)
                rmSetPlacementSection(0.75, 0.91); // n
	       else if (sectionChance == 11)
                rmSetPlacementSection(0.62, 0.82); // s
	       else if (sectionChance == 12)
                rmSetPlacementSection(0.58, 0.75); // s

             if (distChance == 1)
                rmPlacePlayersCircular(0.31, 0.32, 0.0);
             else if (distChance == 2)
                rmPlacePlayersCircular(0.32, 0.33, 0.0);
        	 else if (distChance == 3)
         	    rmPlacePlayersCircular(0.33, 0.34, 0.0);
		 else if (distChance == 4)
	          rmPlacePlayersCircular(0.35, 0.36, 0.0);
      	 else if (distChance == 5)
	   	    rmPlacePlayersCircular(0.36, 0.37, 0.0);
		 else if (distChance == 6)
	          rmPlacePlayersCircular(0.37, 0.38, 0.0);
             }
             else if (axisChance == 2)
             {
	        if (sectionChance == 9)
	        {
	          if (twoChance == 1)
		     wBigIs = 1;
	          else if (twoChance == 2)
	 	     wEdgeIs = 1;
	        }
	        if (sectionChance == 10)
	        {
	          if (twoChance == 1)
		     wBigIs = 1;
	          else if (twoChance == 2)
	 	     wEdgeIs = 1;
	        }
	        if (sectionChance == 11)
	        {
	          if (twoChance == 1)
		     eBigIs = 1;
	          else if (twoChance == 2)
	 	     eEdgeIs = 1;
	        }
	        if (sectionChance == 12)
	        {
	          if (twoChance == 1)
		     eBigIs = 1;
	          else if (twoChance == 2)
	 	     eEdgeIs = 1;
	        }

	       if (playerSide == 1)
		    rmSetPlacementTeam(0);
             else if (playerSide == 2)
		    rmSetPlacementTeam(1);

	       if (sectionChance == 1)
                rmSetPlacementSection(0.41, 0.60);
	       else if (sectionChance == 2)
                rmSetPlacementSection(0.42, 0.58);
	       else if (sectionChance == 3)
                rmSetPlacementSection(0.40, 0.60);
	       else if (sectionChance == 4)
                rmSetPlacementSection(0.41, 0.59);
	       else if (sectionChance == 5)
                rmSetPlacementSection(0.35, 0.54); // toward CC
	       else if (sectionChance == 6)
                rmSetPlacementSection(0.36, 0.52); // toward CC
	       else if (sectionChance == 7)
                rmSetPlacementSection(0.44, 0.63); // toward C
	       else if (sectionChance == 8)
                rmSetPlacementSection(0.46, 0.66); // toward C
	       else if (sectionChance == 9)
                rmSetPlacementSection(0.36, 0.57); // toward E
	       else if (sectionChance == 10)
                rmSetPlacementSection(0.33, 0.48); // toward E
	       else if (sectionChance == 11)
                rmSetPlacementSection(0.43, 0.63); // toward W
	       else if (sectionChance == 12)
                rmSetPlacementSection(0.49, 0.65); // toward W

             if (distChance == 1)
                rmPlacePlayersCircular(0.31, 0.32, 0.0);
             else if (distChance == 2)
                rmPlacePlayersCircular(0.32, 0.33, 0.0);
        	 else if (distChance == 3)
         	    rmPlacePlayersCircular(0.33, 0.34, 0.0);
		 else if (distChance == 4)
	          rmPlacePlayersCircular(0.35, 0.36, 0.0);
      	 else if (distChance == 5)
	   	    rmPlacePlayersCircular(0.36, 0.37, 0.0);
		 else if (distChance == 6)
	          rmPlacePlayersCircular(0.37, 0.38, 0.0);
   
	       if (playerSide == 1)
	   	    rmSetPlacementTeam(1);
             else if (playerSide == 2)
		    rmSetPlacementTeam(0);

	       if (sectionChance == 1)
                rmSetPlacementSection(0.91, 0.10);
	       else if (sectionChance == 2)
                rmSetPlacementSection(0.92, 0.08);
	       else if (sectionChance == 3)
                rmSetPlacementSection(0.90, 0.10);
   	       else if (sectionChance == 4)
                rmSetPlacementSection(0.91, 0.09);
	       else if (sectionChance == 5)
                rmSetPlacementSection(0.85, 0.04); // toward CC
	       else if (sectionChance == 6)
                rmSetPlacementSection(0.86, 0.02); // toward CC
	       else if (sectionChance == 7)
                rmSetPlacementSection(0.94, 0.15); // toward C
	       else if (sectionChance == 8)
                rmSetPlacementSection(0.96, 0.16); // toward C
	       else if (sectionChance == 9)
                rmSetPlacementSection(0.93, 0.14); // toward E
	       else if (sectionChance == 10)
                rmSetPlacementSection(0.02, 0.17); // toward E
	       else if (sectionChance == 11)
                rmSetPlacementSection(0.87, 0.07); // toward W
	       else if (sectionChance == 12)
                rmSetPlacementSection(0.85, 0.01); // toward W

             if (distChance == 1)
                rmPlacePlayersCircular(0.31, 0.32, 0.0);
             else if (distChance == 2)
                rmPlacePlayersCircular(0.32, 0.33, 0.0);
        	 else if (distChance == 3)
         	    rmPlacePlayersCircular(0.33, 0.34, 0.0);
		 else if (distChance == 4)
	          rmPlacePlayersCircular(0.35, 0.36, 0.0);
      	 else if (distChance == 5)
	   	    rmPlacePlayersCircular(0.36, 0.37, 0.0);
		 else if (distChance == 6)
	          rmPlacePlayersCircular(0.37, 0.38, 0.0);
	       } 
        }
        else  // for 2 teams, for 7-8 players 	
        {
		 distChance = rmRandInt(1,7); 
             directionChance = 0;
             if (axisChance == 1)
             { 
	        if (sectionChance == 9)
	        {
	          if (twoChance == 1)
		     sBigIs = 1;
	          else if (twoChance == 2)
	 	     sEdgeIs = 1;
	        }
	        if (sectionChance == 10)
	        {
	          if (twoChance == 1)
		     sBigIs = 1;
	          else if (twoChance == 2)
	 	     sEdgeIs = 1;
	        }
	        if (sectionChance == 11)
	        {
	          if (twoChance == 1)
		     nBigIs = 1;
	          else if (twoChance == 2)
	 	     nEdgeIs = 1;
	        }
	        if (sectionChance == 12)
	        {
	          if (twoChance == 1)
		     nBigIs = 1;
	          else if (twoChance == 2)
	 	     nEdgeIs = 1;
	        }
 
             if (playerSide == 1)
	  	    rmSetPlacementTeam(0);
             else if (playerSide == 2)
		    rmSetPlacementTeam(1);

	       if (sectionChance == 1)
                rmSetPlacementSection(0.13, 0.37);
	       else if (sectionChance == 2)
                rmSetPlacementSection(0.14, 0.36);
	       else if (sectionChance == 3)
                rmSetPlacementSection(0.14, 0.35);
	       else if (sectionChance == 4)
                rmSetPlacementSection(0.16, 0.34);
	       else if (sectionChance == 5)
                rmSetPlacementSection(0.1, 0.30); // toward CC
	       else if (sectionChance == 6)
                rmSetPlacementSection(0.09, 0.31); // toward CC
	       else if (sectionChance == 7)
                rmSetPlacementSection(0.17, 0.4); // toward C
	       else if (sectionChance == 8)
                rmSetPlacementSection(0.22, 0.41); // toward C
	       else if (sectionChance == 9)
                rmSetPlacementSection(0.11, 0.29); // toward N
	       else if (sectionChance == 10)
	  	    rmSetPlacementSection(0.09, 0.29); // toward N
	       else if (sectionChance == 11)
                rmSetPlacementSection(0.20, 0.40); // toward S
	       else if (sectionChance == 12)
                rmSetPlacementSection(0.24, 0.42); // toward S

             if (distChance == 1)
                rmPlacePlayersCircular(0.31, 0.32, 0.0);
             else if (distChance == 2)
                rmPlacePlayersCircular(0.32, 0.33, 0.0);
        	 else if (distChance == 3)
         	    rmPlacePlayersCircular(0.33, 0.34, 0.0);
		 else if (distChance == 4)
	          rmPlacePlayersCircular(0.34, 0.35, 0.0);
      	 else if (distChance == 5)
	   	    rmPlacePlayersCircular(0.36, 0.37, 0.0);
		 else if (distChance == 6)
	          rmPlacePlayersCircular(0.37, 0.38, 0.0);
	       else if (distChance == 7)
         	    rmPlacePlayersCircular(0.38, 0.39, 0.0);

	       if (playerSide == 1)
		    rmSetPlacementTeam(1);
             else if (playerSide == 2)
		    rmSetPlacementTeam(0);

	       if (sectionChance == 1)
                rmSetPlacementSection(0.63, 0.87);
	       else if (sectionChance == 2)
                rmSetPlacementSection(0.64, 0.86);
	       else if (sectionChance == 3)
                rmSetPlacementSection(0.64, 0.85);
	       else if (sectionChance == 4)
                rmSetPlacementSection(0.66, 0.84);
	       else if (sectionChance == 5)
                rmSetPlacementSection(0.60, 0.80); // cc
	       else if (sectionChance == 6)
                rmSetPlacementSection(0.59, 0.81); // cc
	       else if (sectionChance == 7)
                rmSetPlacementSection(0.67, 0.90); // c
	       else if (sectionChance == 8)
                rmSetPlacementSection(0.72, 0.91); // c
	       else if (sectionChance == 9)
                rmSetPlacementSection(0.71, 0.89); // n
	       else if (sectionChance == 10)
                rmSetPlacementSection(0.71, 0.91); // n
	       else if (sectionChance == 11)
                rmSetPlacementSection(0.60, 0.80); // s
	       else if (sectionChance == 12)
                rmSetPlacementSection(0.58, 0.76); // s

             if (distChance == 1)
                rmPlacePlayersCircular(0.31, 0.32, 0.0);
             else if (distChance == 2)
                rmPlacePlayersCircular(0.32, 0.33, 0.0);
        	 else if (distChance == 3)
         	    rmPlacePlayersCircular(0.33, 0.34, 0.0);
		 else if (distChance == 4)
	          rmPlacePlayersCircular(0.34, 0.35, 0.0);
      	 else if (distChance == 5)
	   	    rmPlacePlayersCircular(0.36, 0.37, 0.0);
		 else if (distChance == 6)
	          rmPlacePlayersCircular(0.37, 0.38, 0.0);
	       else if (distChance == 7)
         	    rmPlacePlayersCircular(0.38, 0.39, 0.0);
             }
             else if (axisChance == 2)
             {
	        if (sectionChance == 9)
	        {
	          if (twoChance == 1)
		     wBigIs = 1;
	          else if (twoChance == 2)
	 	     wEdgeIs = 1;
	        }
	        if (sectionChance == 10)
	        {
	          if (twoChance == 1)
		     wBigIs = 1;
	          else if (twoChance == 2)
	 	     wEdgeIs = 1;
	        }
	        if (sectionChance == 11)
	        {
	          if (twoChance == 1)
		     eBigIs = 1;
	          else if (twoChance == 2)
	 	     eEdgeIs = 1;
	        }
	        if (sectionChance == 12)
	        {
	          if (twoChance == 1)
		     eBigIs = 1;
	          else if (twoChance == 2)
	 	     eEdgeIs = 1;
	        }

	       if (playerSide == 1)
		    rmSetPlacementTeam(0);
             else if (playerSide == 2)
		    rmSetPlacementTeam(1);

	       if (sectionChance == 1)
                rmSetPlacementSection(0.38, 0.62);
	       else if (sectionChance == 2)
                rmSetPlacementSection(0.39, 0.62);
	       else if (sectionChance == 3)
                rmSetPlacementSection(0.40, 0.60);
	       else if (sectionChance == 4)
                rmSetPlacementSection(0.41, 0.59);
	       else if (sectionChance == 5)
                rmSetPlacementSection(0.35, 0.54); // toward CC
	       else if (sectionChance == 6)
                rmSetPlacementSection(0.34, 0.56); // toward CC
	       else if (sectionChance == 7)
                rmSetPlacementSection(0.42, 0.65); // toward C
	       else if (sectionChance == 8)
                rmSetPlacementSection(0.46, 0.66); // toward C
	       else if (sectionChance == 9)
                rmSetPlacementSection(0.36, 0.57); // toward E
	       else if (sectionChance == 10)
                rmSetPlacementSection(0.33, 0.51); // toward E
	       else if (sectionChance == 11)
                rmSetPlacementSection(0.44, 0.62); // toward W
	       else if (sectionChance == 12)
                rmSetPlacementSection(0.42, 0.65); // toward W

             if (distChance == 1)
                rmPlacePlayersCircular(0.31, 0.32, 0.0);
             else if (distChance == 2)
                rmPlacePlayersCircular(0.32, 0.33, 0.0);
        	 else if (distChance == 3)
         	    rmPlacePlayersCircular(0.33, 0.34, 0.0);
		 else if (distChance == 4)
	          rmPlacePlayersCircular(0.34, 0.35, 0.0);
      	 else if (distChance == 5)
	   	    rmPlacePlayersCircular(0.36, 0.37, 0.0);
		 else if (distChance == 6)
	          rmPlacePlayersCircular(0.37, 0.38, 0.0);
	       else if (distChance == 7)
         	    rmPlacePlayersCircular(0.38, 0.39, 0.0);
   
	       if (playerSide == 1)
	   	    rmSetPlacementTeam(1);
             else if (playerSide == 2)
		    rmSetPlacementTeam(0);

	       if (sectionChance == 1)
                rmSetPlacementSection(0.88, 0.12);
	       else if (sectionChance == 2)
                rmSetPlacementSection(0.89, 0.12);
	       else if (sectionChance == 3)
                rmSetPlacementSection(0.90, 0.10);
   	       else if (sectionChance == 4)
                rmSetPlacementSection(0.91, 0.09);
	       else if (sectionChance == 5)
                rmSetPlacementSection(0.85, 0.04); // toward CC
	       else if (sectionChance == 6)
                rmSetPlacementSection(0.84, 0.06); // toward CC
	       else if (sectionChance == 7)
                rmSetPlacementSection(0.92, 0.15); // toward C
	       else if (sectionChance == 8)
                rmSetPlacementSection(0.96, 0.16); // toward C
	       else if (sectionChance == 9)
                rmSetPlacementSection(0.93, 0.14); // toward E
	       else if (sectionChance == 10)
                rmSetPlacementSection(0.99, 0.17); // toward E
	       else if (sectionChance == 11)
                rmSetPlacementSection(0.88, 0.06); // toward W
	       else if (sectionChance == 12)
                rmSetPlacementSection(0.85, 0.08); // toward W

             if (distChance == 1)
                rmPlacePlayersCircular(0.31, 0.32, 0.0);
             else if (distChance == 2)
                rmPlacePlayersCircular(0.32, 0.33, 0.0);
        	 else if (distChance == 3)
         	    rmPlacePlayersCircular(0.33, 0.34, 0.0);
		 else if (distChance == 4)
	          rmPlacePlayersCircular(0.34, 0.35, 0.0);
      	 else if (distChance == 5)
	   	    rmPlacePlayersCircular(0.36, 0.37, 0.0);
		 else if (distChance == 6)
	          rmPlacePlayersCircular(0.37, 0.38, 0.0);
	       else if (distChance == 7)
         	    rmPlacePlayersCircular(0.38, 0.39, 0.0);
	       } 
        }
	}
      else  // for FFA for over 3 teams
      {
	   sectionChance = rmRandInt(1,5);
	   if (sectionChance > 4) // another chance at circular placement
	   {
            directionChance = 0;
            if (cNumberNonGaiaPlayers < 6) //FFA 4 or 5 pl
            {
               if (distChance == 1)
                  rmPlacePlayersCircular(0.31, 0.32, 0.0);
      	   else if (distChance == 2)
                  rmPlacePlayersCircular(0.32, 0.33, 0.0);
		   else if (distChance == 3)
         	      rmPlacePlayersCircular(0.33, 0.34, 0.0);
      	   else if (distChance == 4)
	            rmPlacePlayersCircular(0.34, 0.35, 0.0);
		   else if (distChance == 5)
	   	      rmPlacePlayersCircular(0.36, 0.37, 0.0);
               else if (distChance == 6)
	            rmPlacePlayersCircular(0.37, 0.38, 0.0);
            }
            else  // over 5 FFA 
            { 
 	         if (distChance == 1)
                  rmPlacePlayersCircular(0.31, 0.32, 0.0);
	         else if (distChance == 2)
	            rmPlacePlayersCircular(0.32, 0.33, 0.0);
	         else if (distChance == 3)
	            rmPlacePlayersCircular(0.34, 0.35, 0.0);
	         else if (distChance == 4)
	            rmPlacePlayersCircular(0.36, 0.37, 0.0);
	         else if (distChance == 5)
	            rmPlacePlayersCircular(0.38, 0.39, 0.0);
	         else if (distChance == 6)
	            rmPlacePlayersCircular(0.39, 0.40, 0.0);
            }
	   }
         else 
         {
	      if (sectionChance == 1) // 0.7 of map, gap to E	
		{
		    if (threeChance == 1)
			eBigIs = 1;
		    else if (threeChance == 2)
		    {
		       axisChance = 1;
		       directionChance = 0;
		    }
		    else
	          {
		       axisChance = 2;		     
		       if (rmRandInt(1,3) == 1)
		          directionChance = 0;
		       else
                      directionChance = 2;
		    }
                rmSetPlacementSection(0.39, 0.11);
		}
	      else if (sectionChance == 2) // 0.7 of map, gap to W
            {
		    if (threeChance == 1)
			wBigIs = 1;
		    else if (threeChance == 2)
		   {
		      axisChance = 1;
		      directionChance = 0;
		   }
		   else
	         {
		      axisChance = 2;		     
		      if (rmRandInt(1,3) == 1)
		         directionChance = 0;
		      else
                     directionChance = 1;
		   }
               rmSetPlacementSection(0.89, 0.61);
		}
            else if (sectionChance == 3) // 0.7 of map, gap to S
            {	
		    if (threeChance == 1)
			sBigIs = 1;
		    else if (threeChance == 2)
		   {
		      axisChance = 2;
		      directionChance = 0;
		   }
		   else
	         {
		      axisChance = 1;		     
		      if (rmRandInt(1,3) == 1)
		         directionChance = 0;
		      else
                     directionChance = 1;
		   }
               rmSetPlacementSection(0.64, 0.36);
            }
            else if (sectionChance == 4) // 0.7 of map, gap to N
            {	
		    if (threeChance == 1)
			nBigIs = 1;
		    else if (threeChance == 2)
		   {
		      axisChance = 2;
		      directionChance = 0;
		   }
		   else
	         {
		      axisChance = 1;		     
		      if (rmRandInt(1,3) == 1)
		         directionChance = 0;
		      else
                     directionChance = 2;
               }
               rmSetPlacementSection(0.14, 0.86);
            }  
		if (cNumberNonGaiaPlayers < 6)
		{
               if (distChance == 1)
                  rmPlacePlayersCircular(0.31, 0.32, 0.0);
      	   else if (distChance == 2)
                  rmPlacePlayersCircular(0.32, 0.33, 0.0);
		   else if (distChance == 3)
         	      rmPlacePlayersCircular(0.33, 0.34, 0.0);
      	   else if (distChance == 4)
	            rmPlacePlayersCircular(0.34, 0.35, 0.0);
		   else if (distChance == 5)
	   	      rmPlacePlayersCircular(0.36, 0.37, 0.0);
               else if (distChance == 6)
	            rmPlacePlayersCircular(0.37, 0.38, 0.0);
		}
		else
		{
 	         if (distChance == 1)
                  rmPlacePlayersCircular(0.32, 0.33, 0.0);
	         else if (distChance == 2)
	            rmPlacePlayersCircular(0.33, 0.34, 0.0);
	         else if (distChance == 3)
	            rmPlacePlayersCircular(0.34, 0.35, 0.0);
	         else if (distChance == 4)
	            rmPlacePlayersCircular(0.36, 0.37, 0.0);
	         else if (distChance == 5)
	            rmPlacePlayersCircular(0.38, 0.39, 0.0);
	         else if (distChance == 6)
	            rmPlacePlayersCircular(0.40, 0.41, 0.0);
		}
         }
      }
   }

// Text
   rmSetStatusText("",0.25);

// Build team areas.
   int teamZeroCount = rmGetNumberPlayersOnTeam(0);
   int teamOneCount = rmGetNumberPlayersOnTeam(1);
   float islandFraction=0.18/cNumberTeams;  // for teams > 2 
   float landFraction = rmRandFloat(0.12,0.14);  // for teams = 2
   if (cNumberTeams == 2)
   {
      if (cNumberNonGaiaPlayers == 3)
	   landFraction=rmRandFloat(0.12,0.14);
      if (cNumberNonGaiaPlayers == 4)
	   landFraction=rmRandFloat(0.13,0.16);
      if (cNumberNonGaiaPlayers == 5)
	   landFraction=rmRandFloat(0.13,0.16);
      if (cNumberNonGaiaPlayers == 6)  
	   landFraction=rmRandFloat(0.14,0.16);
      if (cNumberNonGaiaPlayers > 6)
	   landFraction=rmRandFloat(0.17,0.19);

	islandFraction=landFraction/cNumberTeams;
   }
 
   for(i=0; <cNumberTeams)  
   {
      int teamID=rmCreateArea("team"+i);
      rmSetAreaSize(teamID, islandFraction, islandFraction);
      rmSetAreaWarnFailure(teamID, false);
      rmSetAreaMix(teamID, baseType);
      rmSetAreaSmoothDistance(teamID, 15);
	rmSetAreaCoherence(teamID, 0.9);
      rmSetAreaElevationVariation(teamID, 1.0);
      rmSetAreaElevationMinFrequency(teamID, 0.09);
      rmSetAreaElevationOctaves(teamID, 3);
      rmSetAreaElevationPersistence(teamID, 0.2);
	rmSetAreaElevationNoiseBias(teamID, 1); 
      rmAddAreaToClass(teamID, teamClass);
	rmSetAreaElevationEdgeFalloffDist(teamID, 15.0); 
	if (noHeight == 1)
         rmSetAreaBaseHeight(teamID, 1.0);
	else
         rmSetAreaBaseHeight(teamID, baseHeight);
      rmSetAreaHeightBlend(teamID, 2);
      rmAddAreaConstraint(teamID, avoidCenter);
      rmAddAreaConstraint(teamID, teamConstraint);
      rmAddAreaConstraint(teamID, teamEdgeConstraint);  
      rmAddAreaConstraint(teamID, shortEdgeConstraint);   
      rmSetAreaLocTeam(teamID, i);
   }

// Set up player areas.
   float playerFraction=rmAreaTilesToFraction(7000 + cNumberNonGaiaPlayers*150);
   float randomIslandChance=rmRandFloat(0,1);

   for(i=1; <cNumberPlayers)
   {
      int id=rmCreateArea("Player"+i);
      rmSetPlayerArea(i, id);
      rmSetAreaSize(id, 0.97*playerFraction, 1.03*playerFraction);
      rmAddAreaToClass(id, classPlayer);
	if (noHeight == 1)
         rmSetAreaBaseHeight(id, 1.0);
	else
         rmSetAreaBaseHeight(id, baseHeight);
      rmSetAreaHeightBlend(id, 2);
      rmSetAreaSmoothDistance(id, 20);
	rmSetAreaCoherence(id, 0.9);
      rmSetAreaElevationVariation(id, 1.0);
      rmSetAreaElevationMinFrequency(id, 0.09);
      rmSetAreaElevationOctaves(id, 3);
      rmSetAreaElevationPersistence(id, 0.2);
	rmSetAreaElevationNoiseBias(id, 1);
      if (cNumberTeams > 2)
         rmAddAreaConstraint(id, playerLandConstraint);
	rmAddAreaConstraint(id, playerEdgeConstraint);
      rmAddAreaConstraint(id, shortEdgeConstraint);   
      rmSetAreaLocPlayer(id, i);
      rmSetAreaMix(id, baseType);
   }

// Big or Center Island
   int bigIslandID=rmCreateArea("big island");
   rmSetAreaSize(bigIslandID, rmAreaTilesToFraction(5000 + cNumberNonGaiaPlayers*700), rmAreaTilesToFraction(5500 + cNumberNonGaiaPlayers*800));
   if (wBigIs == 1)
   {
      rmSetAreaLocation(bigIslandID, 0.28, 0.5);
      rmAddAreaInfluenceSegment(bigIslandID, 0.12, 0.5, 0.44, 0.5);
   }
   else if (wEdgeIs == 1)
   {
      rmSetAreaLocation(bigIslandID, 0.2, 0.5);
      rmAddAreaInfluenceSegment(bigIslandID, 0.19, 0.5, 0.28, 0.69);
      rmAddAreaInfluenceSegment(bigIslandID, 0.19, 0.5, 0.28, 0.31);
   }
   else if (eBigIs == 1)
   {
      rmSetAreaLocation(bigIslandID, 0.72, 0.5);
      rmAddAreaInfluenceSegment(bigIslandID, 0.56, 0.5, 0.88, 0.5);
   } 
   else if (eEdgeIs == 1)
   {
      rmSetAreaLocation(bigIslandID, 0.81, 0.5);
      rmAddAreaInfluenceSegment(bigIslandID, 0.82, 0.5, 0.72, 0.69);
      rmAddAreaInfluenceSegment(bigIslandID, 0.82, 0.5, 0.72, 0.31);
   } 
   else if (sBigIs == 1)
   {
      rmSetAreaLocation(bigIslandID, 0.5, 0.28);
      rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.12, 0.5, 0.44);
   }
   else if (sEdgeIs == 1)
   {
      rmSetAreaLocation(bigIslandID, 0.5, 0.2);
      rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.19, 0.69, 0.28);
      rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.19, 0.31, 0.28);
   }
   else if (nBigIs == 1)
   {
      rmSetAreaLocation(bigIslandID, 0.5, 0.72);
      rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.88, 0.5, 0.56);
   }
   else if (nEdgeIs == 1)
   {
      rmSetAreaLocation(bigIslandID, 0.5, 0.8);
      rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.81, 0.69, 0.72);
      rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.81, 0.31, 0.72);
   } 
   else
   {
      centeredBigIsland = 1;
      rmSetAreaLocation(bigIslandID, 0.5, 0.5);
      if (axisChance == 1)
      {
	   if (directionChance == 1)
           rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.28, 0.5, 0.55);           
	   else if (directionChance == 2)
           rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.72, 0.5, 0.45);
	   else if (directionChance == 0)
           rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.38, 0.5, 0.62);
	   if (variantChance == 1)
           rmAddAreaInfluenceSegment(bigIslandID, 0.45, 0.5, 0.5, 0.5);  
	   else
           rmAddAreaInfluenceSegment(bigIslandID, 0.55, 0.5, 0.5, 0.5);  
      }
      else if (axisChance == 2)
      {
	   if (directionChance == 1)
           rmAddAreaInfluenceSegment(bigIslandID, 0.55, 0.5, 0.28, 0.5);
	   else if (directionChance == 2)
           rmAddAreaInfluenceSegment(bigIslandID, 0.45, 0.5, 0.72, 0.5);
	   else if (directionChance == 0)
           rmAddAreaInfluenceSegment(bigIslandID, 0.38, 0.5, 0.62, 0.5);
	   if (variantChance == 1)
           rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.45, 0.5, 0.5);  
	   else
           rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.55, 0.5, 0.5);  
      }
   }
   rmSetAreaMix(bigIslandID, baseType);
   rmSetAreaWarnFailure(bigIslandID, false);
   rmAddAreaConstraint(bigIslandID, playerConstraint);
   rmAddAreaConstraint(bigIslandID, landAvoidTeamLands);  
   rmAddAreaToClass(bigIslandID, classSettlementIsland);
   rmAddAreaToClass(bigIslandID, classCenterIsland);
   rmAddAreaToClass(bigIslandID, classGoldIsland);
   rmSetAreaCoherence(bigIslandID, 0.5);
   rmSetAreaSmoothDistance(bigIslandID, 12);
   rmSetAreaHeightBlend(bigIslandID, 2);
   rmSetAreaBaseHeight(bigIslandID, baseHeight);

   rmBuildAllAreas();

// Extra Big Island Land
   int extraCount=cNumberNonGaiaPlayers + 2;  // num players plus some extra
   if (cNumberNonGaiaPlayers > 6)
      extraCount=cNumberNonGaiaPlayers + 1;
  
   for(i=0; <extraCount)
   {
      int extraLandID=rmCreateArea("extraland"+i);
      rmSetAreaSize(extraLandID, rmAreaTilesToFraction(500 + cNumberNonGaiaPlayers*100), rmAreaTilesToFraction(600 + cNumberNonGaiaPlayers*120));
      rmSetAreaMix(extraLandID, baseType);
      rmSetAreaWarnFailure(extraLandID, false);
	if ((eBigIs == 1) || (eEdgeIs == 1))
  	   rmAddAreaConstraint(extraLandID, Eastward);
	else if ((wBigIs == 1) || (wEdgeIs == 1))
  	   rmAddAreaConstraint(extraLandID, Westward);
	else if ((nBigIs == 1) || (nEdgeIs == 1))
  	   rmAddAreaConstraint(extraLandID, Northward);
	else if ((sBigIs == 1) || (sEdgeIs == 1))
  	   rmAddAreaConstraint(extraLandID, Southward);
	else
	{
      if (cNumberNonGaiaPlayers > 5)
         rmAddAreaConstraint(extraLandID, centralExtraLandConstraint2);
	else	
         rmAddAreaConstraint(extraLandID, centralExtraLandConstraint);
	}
      rmAddAreaConstraint(extraLandID, playerConstraint); 
      rmAddAreaConstraint(extraLandID, landAvoidTeamLands);
      rmAddAreaConstraint(extraLandID, playerEdgeConstraint);  
      rmAddAreaToClass(extraLandID, classCenterIsland);
      rmAddAreaToClass(extraLandID, classGoldIsland);
      rmSetAreaCoherence(extraLandID, 0.55);
      rmSetAreaSmoothDistance(extraLandID, 20);
      rmSetAreaHeightBlend(extraLandID, 2);
      rmSetAreaBaseHeight(extraLandID, baseHeight);
      rmBuildArea(extraLandID);
   }

// Text
   rmSetStatusText("",0.30);

// Trade Route
int tradeRouteID = rmCreateTradeRoute();
if (wBigIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.13, 0.5);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.24, 0.525);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.34, 0.475);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.43, 0.5);
}
else if (eBigIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.85, 0.5);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.76, 0.525);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.66, 0.475);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.57, 0.5);
}
else if (wEdgeIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.27, 0.68);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.2, 0.53);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.2, 0.47);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.27, 0.32);
}
else if (eEdgeIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.73, 0.68);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.81, 0.53);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.81, 0.47);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.73, 0.32);
}
else if (sBigIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.13);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.52, 0.24);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.48, 0.34);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.43);
}
else if (nBigIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.87);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.52, 0.76);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.48, 0.66);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.57);
}
else if (sEdgeIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.68, 0.27);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.53, 0.2);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.47, 0.2);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.32, 0.27);
}
else if (nEdgeIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.68, 0.73);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.53, 0.81);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.47, 0.81);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.32, 0.73);
}
else
{
   if (axisChance == 1) 
   {
	if (directionChance == 1)
	{
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.53);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.475, 0.48);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.525, 0.35);
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.3);
	}
	else if (directionChance == 2)
	{
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.47);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.475, 0.52);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.525, 0.65);
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.7);
	}
	else if (directionChance == 0)
	{
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.39);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.525, 0.44);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.475, 0.56);
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.61);
	}
   }
   else if (axisChance == 2) 
   {
	if (directionChance == 1)
	{
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.53, 0.5);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.48, 0.525);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.475);
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 0.5);
	}
	else if (directionChance == 2)
	{
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.47, 0.5);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.52, 0.475);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.525);
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.7, 0.5);
	}
	else if (directionChance == 0)
	{
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.39, 0.5);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.44, 0.475);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.56, 0.525);
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.61, 0.5);
	}
   }
}
rmBuildTradeRoute(tradeRouteID, tradeRouteType);	

// Trade sockets
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 6.0);

   // add the meeting poles along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.1);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   if(cNumberNonGaiaPlayers > 4)
   {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.9);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

// KOTH game mode - on the center Big Island
  int myKingsHillAvoidImpassableLand=rmCreateTerrainDistanceConstraint("my kings hill avoids impassable land", "Land", false, 4.0);
  int myKingsHillAvoidAll=rmCreateTypeDistanceConstraint("my kings hill avoids all", "all", 4.0);
  int myKingsHillAvoidTradeRouteSocket = rmCreateTypeDistanceConstraint("my kings hill avoids trade route socket", "socketTradeRoute", 5.0);
  int myKingsHillAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("my kings hill avoids trade route", 6.0);

   if(rmGetIsKOTH())
   {
      int myKingsHillID = rmCreateObjectDef("MyKingsHill");
      rmAddObjectDefItem(myKingsHillID, "ypKingsHill", 1, 0);
      rmAddObjectDefToClass(myKingsHillID, rmClassID("importantItem"));
      rmSetObjectDefMinDistance(myKingsHillID, 0.0);
      rmSetObjectDefMaxDistance(myKingsHillID, 10);
      rmAddObjectDefConstraint(myKingsHillID, myKingsHillAvoidImpassableLand);
      rmAddObjectDefConstraint(myKingsHillID, myKingsHillAvoidAll);
      rmAddObjectDefConstraint(myKingsHillID, myKingsHillAvoidTradeRouteSocket);
      rmAddObjectDefConstraint(myKingsHillID, myKingsHillAvoidTradeRoute);
      rmAddObjectDefConstraint(myKingsHillID, avoidWater10);
	if (cNumberNonGaiaPlayers == 2)
         rmAddObjectDefConstraint(myKingsHillID, farPlayerConstraint);
	else
         rmAddObjectDefConstraint(myKingsHillID, fartherPlayerConstraint);
      // Place on big island
      rmPlaceObjectDefInArea(myKingsHillID, 0, rmAreaID("big island"), 1);
   }

// Starting TCs and units 		
   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));
   rmAddObjectDefToClass(startingUnits, rmClassID("importantItem"));
   rmSetObjectDefMinDistance(startingUnits, 5.0);
   rmSetObjectDefMaxDistance(startingUnits, 10.0);
   rmAddObjectDefConstraint(startingUnits, avoidAll);

   int startingTCID= rmCreateObjectDef("startingTC");
   rmAddObjectDefToClass(startingTCID, rmClassID("startingUnit"));
   rmAddObjectDefToClass(startingTCID, rmClassID("importantItem"));
   rmSetObjectDefMaxDistance(startingTCID, 10.0);
   rmAddObjectDefConstraint(startingTCID, avoidAll);
   rmAddObjectDefConstraint(startingTCID, longAvoidImpassableLand);               
   if ( rmGetNomadStart())
   {
	rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
   }
   else
   {
      rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
   }

   int startingWood= rmCreateObjectDef("startingWood");
   rmAddObjectDefToClass(startingWood, rmClassID("importantItem"));
   rmSetObjectDefMinDistance(startingWood, 8.0);
   rmSetObjectDefMaxDistance(startingWood, 10.0);
   rmAddObjectDefConstraint(startingWood, avoidAll);
   rmAddObjectDefItem(startingWood, "CrateOfWood", 2, 0.0);


   for(i=1; <cNumberPlayers)
   {	
      rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingWood, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

	vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));

      if(ypIsAsian(i) && rmGetNomadStart() == false)
        rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

   }


// Text
   rmSetStatusText("",0.35);

// Player Mines
   int silverType = -1;
   silverType = rmRandInt(1,10);
   int playerGoldID=rmCreateObjectDef("player silver closer");
   rmAddObjectDefItem(playerGoldID, mineType, 1, 0.0);
   rmAddObjectDefToClass(playerGoldID, rmClassID("all mines"));
   rmAddObjectDefToClass(playerGoldID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerGoldID, avoidSocket); 
   rmAddObjectDefConstraint(playerGoldID, coinAvoidCoin);
   rmAddObjectDefConstraint(playerGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(playerGoldID, avoidAll);
   rmAddObjectDefConstraint(playerGoldID, avoidWater10);
   rmSetObjectDefMinDistance(playerGoldID, 12.0);
   rmSetObjectDefMaxDistance(playerGoldID, 24.0);
   rmPlaceObjectDefPerPlayer(playerGoldID, false, 1);

   silverType = rmRandInt(1,10);
   int GoldMediumID=rmCreateObjectDef("player silver med");
   rmAddObjectDefItem(GoldMediumID, mineType, 1, 0.0);
   rmAddObjectDefToClass(GoldMediumID, rmClassID("all mines"));
   rmAddObjectDefToClass(GoldMediumID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(GoldMediumID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldMediumID, avoidSocket);
   rmAddObjectDefConstraint(GoldMediumID, coinAvoidCoin);
   rmAddObjectDefConstraint(GoldMediumID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(GoldMediumID, avoidTC);
   rmAddObjectDefConstraint(GoldMediumID, avoidAll);
   rmAddObjectDefConstraint(GoldMediumID, avoidWater10);
   rmSetObjectDefMinDistance(GoldMediumID, 45.0);
   rmSetObjectDefMaxDistance(GoldMediumID, 70.0);
   rmPlaceObjectDefPerPlayer(GoldMediumID, false, 1);

// Player Nuggets
   int playerNuggetID=rmCreateObjectDef("player nugget");
   rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
   rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
   rmAddObjectDefToClass(playerNuggetID, rmClassID("importantItem"));
   rmSetObjectDefMinDistance(playerNuggetID, 35.0);
   rmSetObjectDefMaxDistance(playerNuggetID, 55.0);
   rmAddObjectDefConstraint(playerNuggetID, avoidAll);
   rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerNuggetID, avoidSocket);
   rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
   rmAddObjectDefConstraint(playerNuggetID, avoidNativesShort);
   rmAddObjectDefConstraint(playerNuggetID, avoidWater10);

   for(i=1; <cNumberPlayers)
   {
 	rmSetNuggetDifficulty(1, 1);
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
 	rmSetNuggetDifficulty(2, 2);
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
 	rmSetNuggetDifficulty(3, 3);
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceGroupingAtLoc(villageAID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
   }

// Random Nuggets
   int nuggetID= rmCreateObjectDef("nugget"); 
   rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
   rmAddObjectDefToClass(nuggetID, rmClassID("nuggets"));
   rmAddObjectDefToClass(nuggetID, rmClassID("importantItem"));
   rmSetObjectDefMinDistance(nuggetID, 0.0);
   rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.1));
   rmAddObjectDefConstraint(nuggetID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nuggetID, avoidNugget);
   rmAddObjectDefConstraint(nuggetID, avoidStartingUnits);
   rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
   rmAddObjectDefConstraint(nuggetID, avoidSocket);
   rmAddObjectDefConstraint(nuggetID, avoidAll);
   rmAddObjectDefConstraint(nuggetID, farPlayerConstraint);
   rmAddObjectDefConstraint(nuggetID, avoidWater10);

// Start area trees 
   int StartAreaTreeID=rmCreateObjectDef("starting trees");
   rmAddObjectDefItem(StartAreaTreeID, treeType, 1, 0.0);
   rmSetObjectDefMinDistance(StartAreaTreeID, 8);
   rmSetObjectDefMaxDistance(StartAreaTreeID, 12);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidAll);
   rmPlaceObjectDefPerPlayer(StartAreaTreeID, false, 4);

// Mines - other
   silverType = rmRandInt(1,10);
   int extraGoldID = rmCreateObjectDef("possible gold mines");
   if (rmRandInt(1,2) == 1)
      rmAddObjectDefItem(extraGoldID, "minegold", 1, 0.0);
   else
      rmAddObjectDefItem(extraGoldID, mineType, 1, 0.0);
   rmAddObjectDefToClass(extraGoldID, rmClassID("all mines"));
   rmAddObjectDefToClass(extraGoldID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(extraGoldID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraGoldID, avoidSocket);
   rmAddObjectDefConstraint(extraGoldID, longAvoidCoin);
   rmAddObjectDefConstraint(extraGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(extraGoldID, avoidWater15);
   rmAddObjectDefConstraint(extraGoldID, avoidAll);
   rmSetObjectDefMinDistance(extraGoldID, 10.0);
   rmSetObjectDefMaxDistance(extraGoldID, 75.0);

   silverType = rmRandInt(1,10);
   int extraSilverID = rmCreateObjectDef("extra silver mines");
   rmAddObjectDefItem(extraSilverID, mineType, 1, 0.0);
   rmAddObjectDefToClass(extraSilverID, rmClassID("all mines"));
   rmAddObjectDefToClass(extraSilverID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(extraSilverID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraSilverID, avoidSocket);
   rmAddObjectDefConstraint(extraSilverID, longAvoidCoin);
   rmAddObjectDefConstraint(extraSilverID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(extraSilverID, avoidWater10);
   rmAddObjectDefConstraint(extraSilverID, avoidAll);
   rmSetObjectDefMinDistance(extraSilverID, 10.0);
   rmSetObjectDefMaxDistance(extraSilverID, 75.0);

// Berries
   int berryNum = rmRandInt(2,5);
   int StartBerryBushID=rmCreateObjectDef("starting berry bush");
   rmAddObjectDefItem(StartBerryBushID, "BerryBush", rmRandInt(2,4), 4.0);
   rmSetObjectDefMinDistance(StartBerryBushID, 10.0);
   rmSetObjectDefMaxDistance(StartBerryBushID, 16.0);
   rmAddObjectDefConstraint(StartBerryBushID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartBerryBushID, avoidAll);
   if (placeBerries == 1)
      rmPlaceObjectDefPerPlayer(StartBerryBushID, false, 1);
   if (tropical == 1)
   {
      rmPlaceObjectDefPerPlayer(StartBerryBushID, false, 1);
      rmPlaceObjectDefInArea(StartBerryBushID, 0, rmAreaID("big island"), rmRandInt(1,3));
   }

// Start area huntable
   int deerNum = rmRandInt(4, 6);
   int startPronghornID=rmCreateObjectDef("starting pronghorn");
   rmAddObjectDefItem(startPronghornID, deerType, deerNum, 5.0);
   rmAddObjectDefToClass(startPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(startPronghornID, 14);
   rmSetObjectDefMaxDistance(startPronghornID, 18);
   rmAddObjectDefConstraint(startPronghornID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(startPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(startPronghornID, avoidAll);
   rmSetObjectDefCreateHerd(startPronghornID, false);
   rmPlaceObjectDefPerPlayer(startPronghornID, false, 1);

// Extra tree clumps near players - to ensure fair access to wood
   int extraTreesID=rmCreateObjectDef("extra trees");
   rmAddObjectDefItem(extraTreesID, treeType, 7, 7.0);
   rmSetObjectDefMinDistance(extraTreesID, 16);
   rmSetObjectDefMaxDistance(extraTreesID, 20);
   rmAddObjectDefConstraint(extraTreesID, avoidAll);
   rmAddObjectDefConstraint(extraTreesID, avoidImportantItem);
   rmAddObjectDefConstraint(extraTreesID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(extraTreesID, avoidCoin);
   rmAddObjectDefConstraint(extraTreesID, avoidSocket);
   rmAddObjectDefConstraint(extraTreesID, avoidTradeRoute);
   rmPlaceObjectDefPerPlayer(extraTreesID, false, 1);

// Second huntable
   int deer2Num = rmRandInt(4, 7);
   int farPronghornID=rmCreateObjectDef("far pronghorn");
   rmAddObjectDefItem(farPronghornID, deer2Type, deer2Num, 5.0);
   rmAddObjectDefToClass(farPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farPronghornID, 48.0);
   rmSetObjectDefMaxDistance(farPronghornID, 75.0);
   rmAddObjectDefConstraint(farPronghornID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(farPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(farPronghornID, avoidNativesShort);
   rmAddObjectDefConstraint(farPronghornID, huntableConstraint);
   rmAddObjectDefConstraint(farPronghornID, avoidAll);
   rmAddObjectDefConstraint(farPronghornID, avoidTC);
   rmSetObjectDefCreateHerd(farPronghornID, true);
   rmPlaceObjectDefPerPlayer(farPronghornID, false, 1);

   rmSetObjectDefMinDistance(farPronghornID, 75.0);
   rmSetObjectDefMaxDistance(farPronghornID, 95.0);
   rmPlaceObjectDefPerPlayer(farPronghornID, false, 1);

// Sheep etc
   int sheepID=rmCreateObjectDef("herdable animal");
   rmAddObjectDefItem(sheepID, sheepType, 2, 4.0);
   rmAddObjectDefToClass(sheepID, rmClassID("herdableFood"));
   rmAddObjectDefConstraint(sheepID, avoidSheep);
   rmAddObjectDefConstraint(sheepID, avoidAll);
   rmAddObjectDefConstraint(sheepID, avoidTC);
   rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
   if (sheepChance > 0)
   {
      for(i=1; <cNumberPlayers)
	{
         rmPlaceObjectDefInArea(sheepID, 0, rmAreaID("player"+i), rmRandInt(2,3));
	}
   }

// Big island huntable
   deer2Num = rmRandInt(4, 7);
   int huntableID=rmCreateObjectDef("huntable 1");
   rmAddObjectDefItem(huntableID, centerHerdType, deer2Num, 6.0);
   rmAddObjectDefToClass(huntableID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(huntableID, 42.0);
   rmSetObjectDefMaxDistance(huntableID, 65.0);
   rmAddObjectDefConstraint(huntableID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(huntableID, avoidNativesShort);
   rmAddObjectDefConstraint(huntableID, huntableConstraint);
   rmAddObjectDefConstraint(huntableID, avoidAll);
   rmSetObjectDefCreateHerd(huntableID, true);

// More island animals
   int centralHerdID=rmCreateObjectDef("central herd");  
   rmAddObjectDefItem(centralHerdID, deerType, rmRandInt(4,5), 4.0);
   rmAddObjectDefToClass(centralHerdID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(centralHerdID, 0);
   rmSetObjectDefMaxDistance(centralHerdID, rmXFractionToMeters(0.1));
   rmAddObjectDefConstraint(centralHerdID, avoidTradeRoute);
   rmAddObjectDefConstraint(centralHerdID, avoidImportantItem);
   rmAddObjectDefConstraint(centralHerdID, avoidWater10);
   rmAddObjectDefConstraint(centralHerdID, longPlayerConstraint);
   rmAddObjectDefConstraint(centralHerdID, huntableConstraint);

// Big island objects placement
   rmSetGroupingMinDistance(villageAID, 0.0);
   rmSetGroupingMaxDistance(villageAID, rmXFractionToMeters(0.05));
   if (cNumberNonGaiaPlayers > 4)
   {
	if (rmRandInt(1,2) == 1)
         rmPlaceGroupingInArea(villageDID, 0, rmAreaID("big island"), 1);
	else
         rmPlaceGroupingInArea(villageAID, 0, rmAreaID("big island"), 1);
	if (rmRandInt(1,2) == 1)
         rmPlaceGroupingInArea(villageDID, 0, rmAreaID("big island"), 1);
	else
         rmPlaceGroupingInArea(villageAID, 0, rmAreaID("big island"), 1);
   }
   else 
   {
	if (rmRandInt(1,2) == 1)
         rmPlaceGroupingInArea(villageDID, 0, rmAreaID("big island"), 1);
	else
         rmPlaceGroupingInArea(villageAID, 0, rmAreaID("big island"), 1);
   }
   rmPlaceObjectDefInArea(extraGoldID, 0, rmAreaID("big island"), 1);
   rmPlaceObjectDefInArea(huntableID, 0, rmAreaID("big island"), 2);
   rmSetNuggetDifficulty(3, 3);
   rmPlaceObjectDefInArea(nuggetID, 0, rmAreaID("big island"), 1);
   if (cNumberNonGaiaPlayers > 3)
      rmPlaceObjectDefInArea(nuggetID, 0, rmAreaID("big island"), 1);
   rmSetNuggetDifficulty(4, 4);
   rmPlaceObjectDefInArea(nuggetID, 0, rmAreaID("big island"), 1);
   rmPlaceObjectDefInArea(centralHerdID, 0, rmAreaID("big island"), 1);
   if (cNumberNonGaiaPlayers > 4)
      rmPlaceObjectDefInArea(centralHerdID, 0, rmAreaID("big island"), 1);
   if (cNumberNonGaiaPlayers > 4)
      rmPlaceObjectDefInArea(extraGoldID, 0, rmAreaID("big island"), 1);
   if (sheepChance > 0)
      rmPlaceObjectDefInArea(sheepID, 0, rmAreaID("big island"), cNumberNonGaiaPlayers);

// Text
   rmSetStatusText("",0.40);

// Native Islands 
   int chanceSetup = 0;
   int constraintChance4 = 0;
   if (cNumberNonGaiaPlayers > 5)
      extraNativeIs = 1;
   else if (cNumberNonGaiaPlayers == 5)
   {
	if (rmRandInt(1,2) > 1)
	   extraNativeIs = 1;
   }
   else if (cNumberNonGaiaPlayers == 4)
   {
	if (rmRandInt(1,3) > 1)
	   extraNativeIs = 1;
   }

   int nativeIsland1ID=rmCreateArea("native island 1");
   rmSetAreaSize(nativeIsland1ID, rmAreaTilesToFraction(2700 + cNumberNonGaiaPlayers*200), rmAreaTilesToFraction(3200 + cNumberNonGaiaPlayers*220));
   rmSetAreaMix(nativeIsland1ID, baseType);
   rmAddAreaConstraint(nativeIsland1ID, centerIslandConstraint);
   if (mapDimension == 1)
      rmAddAreaConstraint(nativeIsland1ID, circleEdgeConstraint);
   else
      rmAddAreaConstraint(nativeIsland1ID, circleEdgeConstraint2);
   rmAddAreaConstraint(nativeIsland1ID, playerConstraint);
   rmAddAreaConstraint(nativeIsland1ID, landAvoidTeamLands);
   if  (centeredBigIsland == 1) 
      rmAddAreaConstraint(nativeIsland1ID, nativeIslandConstraintLarge);
   else
      rmAddAreaConstraint(nativeIsland1ID, nativeIslandConstraint);
   rmAddAreaToClass(nativeIsland1ID, classSettlementIsland);
   rmAddAreaToClass(nativeIsland1ID, classNativeIsland);
   rmAddAreaToClass(nativeIsland1ID, classGoldIsland);
   rmSetAreaCoherence(nativeIsland1ID, 0.35);
   rmSetAreaSmoothDistance(nativeIsland1ID, 12);
   rmSetAreaHeightBlend(nativeIsland1ID, 2);
   rmSetAreaBaseHeight(nativeIsland1ID, baseHeight);
   rmBuildArea(nativeIsland1ID);

   int nativeIsland2ID=rmCreateArea("native island 2");
   rmSetAreaSize(nativeIsland2ID, rmAreaTilesToFraction(2700 + cNumberNonGaiaPlayers*150), rmAreaTilesToFraction(3200 + cNumberNonGaiaPlayers*200));
   rmSetAreaMix(nativeIsland2ID, baseType);
   rmAddAreaConstraint(nativeIsland2ID, settlementIslandConstraint);
   rmAddAreaConstraint(nativeIsland2ID, centerIslandConstraint);
   rmAddAreaConstraint(nativeIsland2ID, playerConstraint);
   rmAddAreaConstraint(nativeIsland2ID, landAvoidTeamLands);
   if  (centeredBigIsland == 1) 
      rmAddAreaConstraint(nativeIsland2ID, nativeIslandConstraintLarge);
   else
      rmAddAreaConstraint(nativeIsland2ID, nativeIslandConstraint);
   if (mapDimension == 1)
      rmAddAreaConstraint(nativeIsland2ID, circleEdgeConstraint);
   else
      rmAddAreaConstraint(nativeIsland2ID, circleEdgeConstraint2);
   rmAddAreaToClass(nativeIsland2ID, classSettlementIsland);
   rmAddAreaToClass(nativeIsland2ID, classNativeIsland);
   rmAddAreaToClass(nativeIsland2ID, classGoldIsland);
   rmSetAreaCoherence(nativeIsland2ID, 0.4);
   rmSetAreaSmoothDistance(nativeIsland2ID, 12);
   rmSetAreaHeightBlend(nativeIsland2ID, 2);
   rmSetAreaBaseHeight(nativeIsland2ID, baseHeight);
   rmBuildArea(nativeIsland2ID);

if (extraNativeIs == 1)
{
   int nativeIsland3ID=rmCreateArea("native island 3");
   rmSetAreaSize(nativeIsland3ID, rmAreaTilesToFraction(2600 + cNumberNonGaiaPlayers*150), rmAreaTilesToFraction(3000 + cNumberNonGaiaPlayers*200));
   rmSetAreaMix(nativeIsland3ID, baseType);
   rmAddAreaConstraint(nativeIsland3ID, settlementIslandConstraint);
   rmAddAreaConstraint(nativeIsland3ID, centerIslandConstraint);
   rmAddAreaConstraint(nativeIsland3ID, playerConstraint);
   rmAddAreaConstraint(nativeIsland3ID, landAvoidTeamLands);
   rmAddAreaConstraint(nativeIsland3ID, nativeIslandConstraint); 
   if (mapDimension == 1)
      rmAddAreaConstraint(nativeIsland3ID, circleEdgeConstraint);
   else
      rmAddAreaConstraint(nativeIsland3ID, circleEdgeConstraint2);
   rmAddAreaToClass(nativeIsland3ID, classSettlementIsland);
   rmAddAreaToClass(nativeIsland3ID, classNativeIsland);
   rmAddAreaToClass(nativeIsland3ID, classGoldIsland);
   rmSetAreaCoherence(nativeIsland3ID, 0.4);
   rmSetAreaSmoothDistance(nativeIsland3ID, 12);
   rmSetAreaHeightBlend(nativeIsland3ID, 2);
   rmSetAreaBaseHeight(nativeIsland3ID, baseHeight);
   rmBuildArea(nativeIsland3ID);
}

// Native Island Objects placement
   rmPlaceGroupingInArea(villageDID, 0, rmAreaID("native island 1"), 1);
   rmPlaceGroupingInArea(villageDID, 0, rmAreaID("native island 2"), 1);
   rmPlaceObjectDefInArea(centralHerdID, 0, rmAreaID("native island 1"), 1);
   rmPlaceObjectDefInArea(centralHerdID, 0, rmAreaID("native island 2"), 1);
   if (extraNativeIs == 1)
   {
	if (rmRandInt(1,2) == 1)
         rmPlaceGroupingInArea(villageDID, 0, rmAreaID("native island 3"), 1);
	else
         rmPlaceGroupingInArea(villageAID, 0, rmAreaID("native island 3"), 1);
      rmPlaceObjectDefInArea(centralHerdID, 0, rmAreaID("native island 3"), 1);
   }

// Text
   rmSetStatusText("",0.45);
     
// More Islands/land - may merge with big island or each other
   int numIslands = cNumberNonGaiaPlayers - 1;
   if (cNumberNonGaiaPlayers > 4)
      numIslands = cNumberNonGaiaPlayers - 2;
   if (cNumberNonGaiaPlayers > 6)
      numIslands = cNumberNonGaiaPlayers - 3;

   for(i=0; <numIslands)
   {
      int settlementIslandID=rmCreateArea("settlement island"+i);
      rmSetAreaSize(settlementIslandID, rmAreaTilesToFraction(2500 + cNumberNonGaiaPlayers*250), rmAreaTilesToFraction(3000 + cNumberNonGaiaPlayers*300));
      rmSetAreaMix(settlementIslandID, baseType); 
      rmSetAreaWarnFailure(settlementIslandID, false);
      constraintChance4 = rmRandFloat(0.0,1.0);
	if (cNumberNonGaiaPlayers < 5)
	{
         if (constraintChance4 > 0.5)
            rmAddAreaConstraint(settlementIslandID, settlementIslandConstraint);
	}
	else 	if (cNumberNonGaiaPlayers < 7)
	{
         if (constraintChance4 > 0.5)
            rmAddAreaConstraint(settlementIslandID, settlementIslandConstraint); 
	}
	else 	
	{
         if (constraintChance4 > 0.3)
            rmAddAreaConstraint(settlementIslandID, settlementIslandConstraint); 
	}

      chanceSetup = rmRandFloat(0.0,1.0);
	if (cNumberNonGaiaPlayers < 5)
	{
         if (chanceSetup < 0.4)
            rmAddAreaConstraint(settlementIslandID, centerIslandConstraint);
	}
	else if (cNumberNonGaiaPlayers < 7)
	{
         if (chanceSetup < 0.6)
            rmAddAreaConstraint(settlementIslandID, centerIslandConstraint);
	}
	else 
	{	
         if (chanceSetup < 0.7)
            rmAddAreaConstraint(settlementIslandID, centerIslandConstraint);
	}

      rmAddAreaConstraint(settlementIslandID, playerConstraint);
      rmAddAreaConstraint(settlementIslandID, landAvoidTeamLands); 
      if (mapDimension == 1)
         rmAddAreaConstraint(settlementIslandID, circleEdgeConstraint);
      else
         rmAddAreaConstraint(settlementIslandID, circleEdgeConstraint2);
	if (rmRandInt(1,3) > 1)
         rmAddAreaConstraint(settlementIslandID, nativeIslandConstraint);
      rmAddAreaToClass(settlementIslandID, classSettlementIsland);
      rmAddAreaToClass(settlementIslandID, classGoldIsland);
      rmSetAreaCoherence(settlementIslandID, 0.35);
      rmSetAreaSmoothDistance(settlementIslandID, 12);
      rmSetAreaHeightBlend(settlementIslandID, 2);
      rmSetAreaBaseHeight(settlementIslandID, baseHeight);
      rmBuildArea(settlementIslandID);
	
   // Settlement Island Objects placement
	if (cNumberNonGaiaPlayers == 4)
	{
         if (rmRandInt(1,5) == 5)
	   {
		if (rmRandInt(1,2) == 1)
               rmPlaceGroupingInArea(villageDID, 0, rmAreaID("settlement island"+i), 1);
		else
               rmPlaceGroupingInArea(villageAID, 0, rmAreaID("settlement island"+i), 1);
	   }
	}
	if (cNumberNonGaiaPlayers > 4)
	{
         if (rmRandInt(1,4) == 1)
	   {
		if (rmRandInt(1,2) == 1)
               rmPlaceGroupingInArea(villageDID, 0, rmAreaID("settlement island"+i), 1);
		else
               rmPlaceGroupingInArea(villageAID, 0, rmAreaID("settlement island"+i), 1);
	   }
	}
      rmSetNuggetDifficulty(3, 3);
      rmPlaceObjectDefInArea(nuggetID, 0, rmAreaID("settlement island"+i), 1);
      if (rmRandInt(1,4) > 1)
         rmPlaceObjectDefInArea(centralHerdID, 0, rmAreaID("settlement island"+i), 1);
   }

// Text
   rmSetStatusText("",0.50);

// Bonus Resource Islands - can merge with other extra islands.
   int bonusCount=cNumberNonGaiaPlayers + 1;  // num players plus some extra
   if (cNumberNonGaiaPlayers > 5)
      bonusCount=cNumberNonGaiaPlayers + 1;
  
   for(i=0; <bonusCount)
   {
      int bonusIslandID=rmCreateArea("bonus island"+i);
      rmSetAreaSize(bonusIslandID, rmAreaTilesToFraction(1700 + cNumberNonGaiaPlayers*150), rmAreaTilesToFraction(2100 + cNumberNonGaiaPlayers*200));
      rmSetAreaMix(bonusIslandID, baseType);
      rmSetAreaWarnFailure(bonusIslandID, false);
      if (mapDimension == 1)
         rmAddAreaConstraint(bonusIslandID, circleEdgeConstraint);
      else
         rmAddAreaConstraint(bonusIslandID, circleEdgeConstraint2);
      if (rmRandInt(1,3) == 1)
        rmAddAreaConstraint(bonusIslandID, settlementIslandConstraint); 
	if (cNumberNonGaiaPlayers > 5)
	{
         if (rmRandInt(1,10) > 4)
            rmAddAreaConstraint(bonusIslandID, centerIslandConstraint);
	}
	else
	{
         if (rmRandInt(1,2) > 1)
            rmAddAreaConstraint(bonusIslandID, centerIslandConstraint);
	}
      if (rmRandInt(1,2) == 1)
         rmAddAreaConstraint(bonusIslandID, nativeIslandConstraint);
      rmAddAreaConstraint(bonusIslandID, landAvoidTeamLands); 
      rmAddAreaConstraint(bonusIslandID, playerConstraint); 
      rmAddAreaToClass(bonusIslandID, classBonusIsland);
      rmAddAreaToClass(bonusIslandID, classGoldIsland);
      rmSetAreaCoherence(bonusIslandID, 0.55);
      rmSetAreaSmoothDistance(bonusIslandID, 20);
      rmSetAreaHeightBlend(bonusIslandID, 2);
      rmSetAreaBaseHeight(bonusIslandID, baseHeight);

      // Island avoidance determination
      randomIslandChance=rmRandFloat(0.0, 1.0);
      if(randomIslandChance < 0.33)
      {
         rmAddAreaToClass(bonusIslandID, islandsX);
         rmAddAreaConstraint(bonusIslandID, islandsXvsY);
         rmAddAreaConstraint(bonusIslandID, islandsXYvsZ);
      }
      else if(randomIslandChance < 0.66)        
      {
         rmAddAreaToClass(bonusIslandID, islandsY);
         rmAddAreaConstraint(bonusIslandID, islandsYvsX);
         rmAddAreaConstraint(bonusIslandID, islandsXYvsZ);
      }
      else
      {
         rmAddAreaToClass(bonusIslandID, islandsZ);
         rmAddAreaConstraint(bonusIslandID, islandsZvsX);
         rmAddAreaConstraint(bonusIslandID, islandsZvsY); 
      }
      rmBuildArea(bonusIslandID);

	// Bonus Island Objects
      rmPlaceObjectDefInArea(centralHerdID, 0, rmAreaID("bonus island"+i), 1);
      if (rmRandInt(1,2) == 1)
	{
         rmSetNuggetDifficulty(2, 3);
         rmPlaceObjectDefInArea(nuggetID, 0, rmAreaID("bonus island"+i), 1);
	}
   }

// Text
   rmSetStatusText("",0.55);

// Caches and bonus objects  
   // Campfire cache
   int campfireID=rmCreateObjectDef("campfire cache");
   if (rmRandInt(1,2) == 1)
      rmAddObjectDefItem(campfireID, "CrateOfWood", rmRandInt(2,3), 4.0);
   else
	rmAddObjectDefItem(campfireID, "CrateOfWoodLarge", 1, 4.0);
   rmAddObjectDefToClass(campfireID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(campfireID, avoidTradeRoute);
   rmAddObjectDefConstraint(campfireID, avoidImportantItemMed);
   rmAddObjectDefConstraint(campfireID, avoidWater10);
   rmAddObjectDefConstraint(campfireID, fartherPlayerConstraint);
   if (rmRandInt(1,5) < 5)
	campfireCache = 1;

   // House cache
   int cacheContents = rmRandInt(1,5);
   int houseCacheID=rmCreateObjectDef("house cache");

   if (cacheContents == 1) 	    
      rmAddObjectDefItem(houseCacheID, "CrateOfFood", 2, 5.0);
   else if (cacheContents == 2) 	    
	rmAddObjectDefItem(houseCacheID, "CrateOfFoodLarge", 1, 4.0);
   else if (cacheContents == 3) 	    
      rmAddObjectDefItem(houseCacheID, "CrateOfCoin", 2, 5.0);
   else if (cacheContents == 4) 	    
	rmAddObjectDefItem(houseCacheID, "CrateOfCoinLarge", 1, 4.0);
   else if (cacheContents == 5)
   { 	    
      rmAddObjectDefItem(houseCacheID, "CrateOfFood", 1, 5.0);
      rmAddObjectDefItem(houseCacheID, "CrateOfCoin", 1, 6.0);
   }
   rmAddObjectDefToClass(houseCacheID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(houseCacheID, avoidTradeRoute);
   rmAddObjectDefConstraint(houseCacheID, avoidImportantItemMed);
   rmAddObjectDefConstraint(houseCacheID, avoidWater10);
   rmAddObjectDefConstraint(houseCacheID, fartherPlayerConstraint);
   rmPlaceObjectDefInRandomAreaOfClass(houseCacheID, 0, classCenterIsland, rmRandInt(1,2)); 
   rmPlaceObjectDefInRandomAreaOfClass(houseCacheID, 0, classGoldIsland, 1);
   if (cNumberNonGaiaPlayers > 2)
      rmPlaceObjectDefInRandomAreaOfClass(houseCacheID, 0, classSettlementIsland, 1);
   if (cNumberNonGaiaPlayers > 3)
      rmPlaceObjectDefInRandomAreaOfClass(houseCacheID, 0, classSettlementIsland, 1);
   if (cNumberNonGaiaPlayers > 4)
      rmPlaceObjectDefInRandomAreaOfClass(houseCacheID, 0, classGoldIsland, 1);


   if (berryCache == 1) // Berry patches
   {
	   if (rmRandInt(1,5) < 4)
            campfireCache = 0;
         int berryPatchType = rmRandInt(1,4);
         int berryPatch = 0;
         berryPatch = rmCreateGrouping("Berry patch", "BerryPatch "+berryPatchType);
         rmSetGroupingMinDistance(berryPatch, 0.0);
         rmSetGroupingMaxDistance(berryPatch, 12.0);
         rmAddGroupingToClass(berryPatch, rmClassID("importantItem"));
         rmAddGroupingConstraint(berryPatch, avoidAll);
         rmAddGroupingConstraint(berryPatch, avoidWater10);
         rmAddGroupingConstraint(berryPatch, avoidImportantItemMed);

	      rmPlaceGroupingInArea(berryPatch, 0, rmAreaID("big island"), 1);
	      if (rmRandInt(1,3) == 1)
	         rmPlaceGroupingInArea(berryPatch, 0, rmAreaID("big island"), 1);
	      if (rmRandInt(1,2) == 1)
	         rmPlaceGroupingInArea(berryPatch, 0, rmAreaID("native island 2"), 1);
	      if (rmRandInt(1,2) == 1)
	         rmPlaceGroupingInArea(berryPatch, 0, rmAreaID("native island 1"), 1);
            for(i=0; <numIslands)
            {
	         if (rmRandInt(1,2) == 1)  
	            rmPlaceGroupingInArea(berryPatch, 0, rmAreaID("settlement island"+i), 1);
	      }
   }

   if (campfireCache == 1) 
   {
      rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classCenterIsland, 1);
	rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classSettlementIsland, 1);
      rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classBonusIsland, 1);
	if (rmRandInt(1,2) == 1)
	   rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classBonusIsland, 1);
	if (rmRandInt(1,2) == 1)
	   rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classSettlementIsland, 1);
      if (cNumberNonGaiaPlayers > 4)
      {
	   rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classCenterIsland, 1);
	   rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classSettlementIsland, 1);
	}
      if (cNumberNonGaiaPlayers > 6)
      {
	   rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classCenterIsland, 1);
	   rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classSettlementIsland, 1);
	}
   }

// Additional Island Mines
   rmPlaceObjectDefInRandomAreaOfClass(extraGoldID, 0, classSettlementIsland, 1);
   if (cNumberNonGaiaPlayers > 3)
      rmPlaceObjectDefInRandomAreaOfClass(extraGoldID, 0, classBonusIsland, 1);
   rmPlaceObjectDefInRandomAreaOfClass(extraGoldID, 0, classGoldIsland, 1);
   rmPlaceObjectDefInRandomAreaOfClass(extraGoldID, 0, classGoldIsland, 1);
   rmPlaceObjectDefInRandomAreaOfClass(extraSilverID, 0, classGoldIsland, 1);
   rmPlaceObjectDefInRandomAreaOfClass(extraSilverID, 0, classGoldIsland, 1);
   if (cNumberNonGaiaPlayers > 4)
   {
      rmPlaceObjectDefInRandomAreaOfClass(extraSilverID, 0, classGoldIsland, 1);
      rmPlaceObjectDefInRandomAreaOfClass(extraSilverID, 0, classBonusIsland, 1);
   }
   if (cNumberNonGaiaPlayers > 6)
   {
      rmPlaceObjectDefInRandomAreaOfClass(extraSilverID, 0, classGoldIsland, 1);
      rmPlaceObjectDefInRandomAreaOfClass(extraSilverID, 0, classBonusIsland, 1);
   }

// Forests
// Large player forests.
   int failCount = 0;
   int forestID = 0;
   for(i=1; <cNumberPlayers)
   {
      for(j=0; <4)      
      {
         failCount=0;
         forestID=rmCreateArea("player"+i+"forest"+j, rmAreaID("player"+i));
	   if (lowForest == 1)
            rmSetAreaSize(forestID, rmAreaTilesToFraction(180), rmAreaTilesToFraction(250));
	   else
            rmSetAreaSize(forestID, rmAreaTilesToFraction(300), rmAreaTilesToFraction(340));
         rmSetAreaWarnFailure(forestID, false);
         rmSetAreaForestType(forestID, forestType);
         rmSetAreaForestDensity(forestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(forestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(forestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(forestID, rmRandFloat(0.5, 0.8));
         rmAddAreaConstraint(forestID, avoidStartingUnits);
         rmAddAreaConstraint(forestID, avoidImportantItem);
         rmAddAreaConstraint(forestID, avoidNativesShort);
         rmAddAreaConstraint(forestID, avoidWater10);
         rmAddAreaConstraint(forestID, avoidAll);
         rmAddAreaConstraint(forestID, forestConstraint);
         rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
         rmAddAreaToClass(forestID, rmClassID("classForest")); 
         rmSetAreaMinBlobs(forestID, 1);
         rmSetAreaMaxBlobs(forestID, 3);
         rmSetAreaMinBlobDistance(forestID, 10.0);
         rmSetAreaMaxBlobDistance(forestID, 15.0);
         rmSetAreaSmoothDistance(forestID, rmRandInt(10,20));
         rmSetAreaBaseHeight(forestID, rmRandFloat(2.0, 4.0));
         rmSetAreaHeightBlend(forestID, 1);
         if(rmBuildArea(forestID)==false)
         {
         // Stop trying once we fail 3 times in a row.
            failCount++;
            if(failCount==3)
               break;
         }
         else
            failCount=0;
	}
   }

// Team forests
   int numForest = 1;
   if (cNumberTeams > 2)
      numForest = 6;
   else
   {
      for(j=0; <cNumberTeams)   
      {
	   if (j==0)
	      numForest = 6*teamZeroCount;
	   else if (j==1)
	      numForest = 6*teamOneCount;
	}
   }

   for(j=0; <cNumberTeams)  
   { 
      for(k=0; <numForest)
      {
         failCount=0;
         forestID=rmCreateArea(("first team"+j+"forest"+k), rmAreaID("team"+j));
	   if (lowForest == 1)
            rmSetAreaSize(forestID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(180));
	   else
            rmSetAreaSize(forestID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(230));
         rmSetAreaWarnFailure(forestID, false);
         rmSetAreaForestType(forestID, forestType);
         rmSetAreaForestDensity(forestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(forestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(forestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(forestID, rmRandFloat(0.4, 0.7));
         rmAddAreaConstraint(forestID, avoidStartingUnitsLong);
         rmAddAreaConstraint(forestID, avoidImportantItem);
         rmAddAreaConstraint(forestID, avoidNativesShort);
         rmAddAreaConstraint(forestID, avoidWater10);
         rmAddAreaConstraint(forestID, avoidAll);
         rmAddAreaConstraint(forestID, forestConstraint);
         rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
         rmAddAreaToClass(forestID, rmClassID("classForest")); 
         rmSetAreaMinBlobs(forestID, 1);
         rmSetAreaMaxBlobs(forestID, 4);
         rmSetAreaMinBlobDistance(forestID, 12.0);
         rmSetAreaMaxBlobDistance(forestID, 20.0);
         rmSetAreaSmoothDistance(forestID, rmRandInt(10,20));
         rmSetAreaBaseHeight(forestID, rmRandFloat(3.0, 4.0));
         rmSetAreaHeightBlend(forestID, 1);
         if(rmBuildArea(forestID)==false)
         {
            // Stop trying once we fail 3 times in a row.
            failCount++;
            if(failCount==3)
               break;
         }
         else
            failCount=0;
      }
   }

// Text
   rmSetStatusText("",0.60);

// Big island forests
   int forestNo = rmRandInt(5,6);
   if (cNumberNonGaiaPlayers > 5)
     forestNo = rmRandInt(7,8);
   else if (cNumberNonGaiaPlayers > 3)
     forestNo = rmRandInt(6,7);
   int forestCount=rmRandInt(7, 8);
   if (lowForest == 1)
   {
	if (cNumberNonGaiaPlayers > 5)
         forestCount=rmRandInt(4, 5);
	else
         forestCount=rmRandInt(3, 4);
   }

   for(i=0; < forestNo)
   {
         forestID=rmCreateArea("big island forest"+i, rmAreaID("big island"));
         rmAddAreaToClass(forestID, rmClassID("classForest"));
	   if (lowForest == 1)
            rmSetAreaSize(forestID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(160));
	   else 
            rmSetAreaSize(forestID, rmAreaTilesToFraction(145), rmAreaTilesToFraction(175));
         rmSetAreaWarnFailure(forestID, false);
         rmSetAreaForestType(forestID, forestType);
         rmSetAreaForestDensity(forestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(forestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(forestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(forestID, rmRandFloat(0.4, 0.7));
         rmAddAreaConstraint(forestID, avoidImportantItem);
         rmAddAreaConstraint(forestID, avoidAll);
         rmAddAreaConstraint(forestID, avoidWater10);
         rmAddAreaConstraint(forestID, forestConstraint2);
         rmAddAreaConstraint(forestID, avoidTradeRoute);
         rmAddAreaConstraint(forestID, avoidSocket);
         rmAddAreaConstraint(forestID, avoidNativesShort);
         rmAddAreaConstraint(forestID, shortAvoidImpassableLand); 
         if(rmRandFloat(0.0, 1.0)<0.4)
            rmSetAreaBaseHeight(forestID, rmRandFloat(3.0, 4.0)); 
         rmBuildArea(forestID);
   }

// Text
   rmSetStatusText("",0.65);

// Settlement island forests
   for(i=0; <numIslands)
   {
      forestCount=rmRandInt(3,4);
      if (lowForest == 1)
         forestCount=2;
      for(j=0; <forestCount)
      {
         forestID=rmCreateArea("settlement island"+i+"forest"+j, rmAreaID("settlement island"+i));
         rmAddAreaToClass(forestID, rmClassID("classForest")); 
         rmSetAreaSize(forestID, rmAreaTilesToFraction(140), rmAreaTilesToFraction(185));
         rmSetAreaWarnFailure(forestID, false);
         rmSetAreaForestType(forestID, forestType);
         rmSetAreaForestDensity(forestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(forestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(forestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(forestID, rmRandFloat(0.4, 0.7));
         rmAddAreaConstraint(forestID, avoidAll);
         rmAddAreaConstraint(forestID, avoidImportantItem);
         rmAddAreaConstraint(forestID, avoidWater10);
         rmAddAreaConstraint(forestID, forestConstraint2);
         rmAddAreaConstraint(forestID, avoidTradeRoute);
         rmAddAreaConstraint(forestID, avoidSocket);
         rmAddAreaConstraint(forestID, avoidNativesShort);
         rmAddAreaConstraint(forestID, shortAvoidImpassableLand); 
         rmBuildArea(forestID);
      }
   }

// Text
   rmSetStatusText("",0.70);

// Native island forests
   int natForest = rmRandInt(2,4);
   if (lowForest == 1)
      natForest=2;
   for(i=0; < natForest)
   {
         forestID=rmCreateArea("native island 1 forest"+i, rmAreaID("native island 1"));
         rmAddAreaToClass(forestID, rmClassID("classForest"));  
         rmSetAreaSize(forestID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(180));
         rmSetAreaWarnFailure(forestID, false);
         rmSetAreaForestType(forestID, forestType);
         rmSetAreaForestDensity(forestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(forestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(forestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(forestID, rmRandFloat(0.4, 0.7));
         rmAddAreaConstraint(forestID, avoidImportantItem);
         rmAddAreaConstraint(forestID, avoidNativesShort);
         rmAddAreaConstraint(forestID, avoidAll);
         rmAddAreaConstraint(forestID, avoidWater10);
         rmAddAreaConstraint(forestID, forestConstraint2);
         rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
         rmBuildArea(forestID);
   }

   natForest = rmRandInt(2,4);
   if (lowForest == 1)
      natForest=2;

   for(i=0; < natForest)
   {
         forestID=rmCreateArea("native island 2 forest"+i, rmAreaID("native island 2")); 
         rmAddAreaToClass(forestID, rmClassID("classForest")); 
         rmSetAreaSize(forestID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(180));
         rmSetAreaWarnFailure(forestID, false);
         rmSetAreaForestType(forestID, forestType);
         rmSetAreaForestDensity(forestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(forestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(forestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(forestID, rmRandFloat(0.4, 0.7));
         rmAddAreaConstraint(forestID, avoidImportantItem);
         rmAddAreaConstraint(forestID, avoidNativesShort);
         rmAddAreaConstraint(forestID, avoidAll);
         rmAddAreaConstraint(forestID, avoidWater10);
         rmAddAreaConstraint(forestID, forestConstraint2);
         rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
         rmBuildArea(forestID);
   }

   natForest = rmRandInt(2,4);
   if (lowForest == 1)
      natForest=2;

   if (extraNativeIs == 1)
   {
      for(i=1; < natForest)
      {
         forestID=rmCreateArea("native island 3 forest"+i, rmAreaID("native island 3")); 
         rmAddAreaToClass(forestID, rmClassID("classForest")); 
         rmSetAreaSize(forestID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(150));
         rmSetAreaWarnFailure(forestID, false);
         rmSetAreaForestType(forestID, forestType);
         rmSetAreaForestDensity(forestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(forestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(forestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(forestID, rmRandFloat(0.4, 0.7));
         rmAddAreaConstraint(forestID, avoidImportantItem);
         rmAddAreaConstraint(forestID, avoidNativesShort);
         rmAddAreaConstraint(forestID, avoidAll);
         rmAddAreaConstraint(forestID, avoidWater10);
         rmAddAreaConstraint(forestID, forestConstraint2);
         rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
         rmBuildArea(forestID);
      }
   }

// Text
   rmSetStatusText("",0.75);

// Bonus island forests.
   for(i=0; <bonusCount)
   {
      forestCount=rmRandInt(2, 3);
      if (lowForest == 1)
         forestCount=rmRandInt(1,2);
      for(j=0; <forestCount)
      {
         int bonusForestID=rmCreateArea("bonus"+i+"forest"+j, rmAreaID("bonus island"+i));
         rmAddAreaToClass(bonusForestID, rmClassID("classForest"));  
	   rmSetAreaSize(bonusForestID, rmAreaTilesToFraction(110), rmAreaTilesToFraction(140));
         rmSetAreaWarnFailure(bonusForestID, false);
         rmSetAreaForestType(bonusForestID, forestType);
         rmSetAreaForestDensity(bonusForestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(bonusForestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(bonusForestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(bonusForestID, rmRandFloat(0.4, 0.7));
         rmAddAreaConstraint(bonusForestID, avoidImportantItem);
         rmAddAreaConstraint(bonusForestID, avoidNativesShort);
         rmAddAreaConstraint(bonusForestID, avoidAll);
         rmAddAreaConstraint(bonusForestID, forestConstraint2);
         rmAddAreaConstraint(bonusForestID, avoidTradeRoute);
         rmAddAreaConstraint(bonusForestID, avoidSocket);
         rmAddAreaConstraint(bonusForestID, shortAvoidImpassableLand);
         rmBuildArea(bonusForestID);
      }
   }

// Text
   rmSetStatusText("",0.80);

// Trees
   int randomTreeID=rmCreateObjectDef("random tree");
   rmAddObjectDefItem(randomTreeID, treeType, 1, 0.0);
   rmSetObjectDefMinDistance(randomTreeID, 8);
   rmSetObjectDefMaxDistance(randomTreeID, 15);
   rmAddObjectDefConstraint(randomTreeID, avoidStartingUnits);
   rmAddObjectDefConstraint(randomTreeID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(randomTreeID, avoidTradeRoute);
   rmAddObjectDefConstraint(randomTreeID, avoidAll);
   rmAddObjectDefConstraint(randomTreeID, avoidWater10);
   if (cNumberTeams > 2)
   {
      for(i=0; <cNumberTeams)
         rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("team"+i), 15);
   }
   else
   {
      for(i=1; <cNumberPlayers)
         rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("Player"+i), 6);
   }
   rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("big island"), rmRandInt(6,10));
   for(i=0; <numIslands)
      rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("settlement island"+i), rmRandInt(2,4));
   for(i=0; <bonusCount)
      rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("bonus island"+i), rmRandInt(2,4));
   for(i=0; <extraCount)
      rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("extraland"+i), 2);
   rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("native island 1"), 3);
   rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("native island 2"), 3);
   if (extraNativeIs == 1)
      rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("native island 3"), 3);


// Text
   rmSetStatusText("",0.85);


   int avoidProp=rmCreateTypeDistanceConstraint("avoids prop", propType, 90.0);
   int specialPropID=rmCreateObjectDef("special prop");
   rmAddObjectDefItem(specialPropID, propType, 1, 0.0);
   rmSetObjectDefMinDistance(specialPropID, 0.0);
   rmSetObjectDefMaxDistance(specialPropID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(specialPropID, avoidAll);
   rmAddObjectDefConstraint(specialPropID, avoidSocket);
   rmAddObjectDefConstraint(specialPropID, avoidTradeRoute);
   rmAddObjectDefConstraint(specialPropID, avoidProp);
   rmAddObjectDefConstraint(specialPropID, shortAvoidImpassableLand);
   if (vultures == 1)  
	rmAddObjectDefConstraint(specialPropID, avoidWater20);
   else
	rmAddObjectDefConstraint(specialPropID, avoidWater10);
   rmAddObjectDefConstraint(specialPropID, avoidImportantItem);
   rmAddObjectDefConstraint(specialPropID, longPlayerConstraint);
   rmPlaceObjectDefAtLoc(specialPropID, 0, 0.5, 0.5, (cNumberNonGaiaPlayers + 1));

// Water Flag
   int waterFlagID=-1;
   for(i=1; <cNumberPlayers)
   {
      rmClearClosestPointConstraints();
      waterFlagID=rmCreateObjectDef("HC water flag "+i);
      rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 3.0);
      rmAddObjectDefItem(waterFlagID, fishType, 2, 3.0);
      rmAddClosestPointConstraint(flagEdgeConstraint);
      rmAddClosestPointConstraint(flagVsFlag);
      rmAddClosestPointConstraint(flagLand);
      vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
      vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));
      rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
      rmClearClosestPointConstraints();
   }

// Text
   rmSetStatusText("",0.90);

// Fish
   int fishVsFishID=rmCreateClassDistanceConstraint("fish v fish", rmClassID("classFish"), rmRandInt(23,27));
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 5.0);
   int fishID=rmCreateObjectDef("fish");
   rmAddObjectDefItem(fishID, fishType, 2, 5.0);
   rmAddObjectDefToClass(fishID, rmClassID("classFish"));
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   if (cNumberNonGaiaPlayers < 4)
      rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*12);
   else if (cNumberNonGaiaPlayers < 6)
      rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*10);
   else
      rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*9);

   int fishVsFish2ID=rmCreateClassDistanceConstraint("another fish v fish", rmClassID("classFish"), rmRandInt(18,22));
   int fish2ID=rmCreateObjectDef("second type fish");
   int fishLand2 = rmCreateTerrainDistanceConstraint("second fish land", "land", true, 3.0);
   rmAddObjectDefItem(fish2ID, fish2Type, 1, 5.0);
   rmAddObjectDefToClass(fish2ID, rmClassID("classFish"));
   rmSetObjectDefMinDistance(fish2ID, 0.0);
   rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fish2ID, fishVsFish2ID);
   rmAddObjectDefConstraint(fish2ID, fishLand2);
   if (cNumberNonGaiaPlayers < 4)
      rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*16);
   else if (cNumberNonGaiaPlayers < 6)
      rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*14);
   else if (cNumberNonGaiaPlayers == 6)
      rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*13);
   else
      rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*12);

// Text
   rmSetStatusText("",0.95);

// Whales
   int whaleID=rmCreateObjectDef("whale");
   int whaleLand = rmCreateTerrainDistanceConstraint("whale v. land", "land", true, 19.0);
   int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", whaleType, 65.0);
   rmAddObjectDefItem(whaleID, whaleType, 1, 5.0);
   rmSetObjectDefMinDistance(whaleID, 0.0);
   rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(1.0));
   rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
   rmAddObjectDefConstraint(whaleID, whaleLand);
   if (cNumberNonGaiaPlayers == 2)
      rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);
   else if (cNumberNonGaiaPlayers < 5)
      rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);
   else
      rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);


   int nuggetW= rmCreateObjectDef("nugget water"); 
   rmAddObjectDefItem(nuggetW, "ypNuggetBoat", 1, 0.0);
   rmAddObjectDefToClass(nuggetW, rmClassID("nuggets"));   
   rmSetNuggetDifficulty(5, 5);
   rmSetObjectDefMinDistance(nuggetW, 0.0);
   rmSetObjectDefMaxDistance(nuggetW, size*0.5);
   rmAddObjectDefConstraint(nuggetW, avoidLand10);
   rmAddObjectDefConstraint(nuggetW, avoidNuggetLong);
   rmAddObjectDefConstraint(nuggetW, flagVsFlag);
   rmPlaceObjectDefAtLoc(nuggetW, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);


// Text
   rmSetStatusText("",0.99);
}  
