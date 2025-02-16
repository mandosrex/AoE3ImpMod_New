// Shangri La
// a random map for AOE3: The Asian Dynasties
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
   string forestType = "";
   string treeType = "";
   string deerType = "";
   string deer2Type = "";
   string deer3Type = "";
   string sheepType = "";
   string centerHerdType = "";
   string native1Name = "";
   string native2Name = "";
   string patchMixType = "";
   string mineType = "";

// Pick pattern for trees, terrain, features, etc.
   int variantChance = rmRandInt(1,2);
   int socketPattern = rmRandInt(2,3);
   if (cNumberNonGaiaPlayers > 4)
	socketPattern = rmRandInt(1,2);
   int nativeSetup = rmRandInt(1,3);	 
   int nativePattern = rmRandInt(1,4);
   int sheepChance = rmRandInt(1,2);
   int cliffVariety = rmRandInt(1,3);
   int hillTrees = -1;
   int forestDist = rmRandInt(12,17);
   int axisChance = rmRandInt(1,2);
   int playerSide = rmRandInt(1,2);
   int twoChoice = rmRandInt(1,2);

// Define the map size
   int playerTiles = 14600;
   if (cNumberNonGaiaPlayers == 8)
	playerTiles = 9000;
   else if (cNumberNonGaiaPlayers == 7)
	playerTiles = 10000;
   else if (cNumberNonGaiaPlayers == 6)
	playerTiles = 11500;
   else if (cNumberNonGaiaPlayers == 5)
	playerTiles = 12250;
   else if (cNumberNonGaiaPlayers == 4)
	playerTiles = 13000;
   else if (cNumberNonGaiaPlayers == 3)
	playerTiles = 13750;

   int size=1.9*sqrt(cNumberNonGaiaPlayers*playerTiles);
   float playerFactor=(1.1 + cNumberNonGaiaPlayers*0.09);
   int longSide=playerFactor*size; 

// new sizes
	if (cNumberNonGaiaPlayers == 2)  
	{
	   size = 300;
	   longSide = 360;
	}
	else if (cNumberNonGaiaPlayers == 3) 
	{
	   size = 320;
	   longSide = 416;
	}				
	else if (cNumberNonGaiaPlayers == 4)   
	{
	   size = 350;
	   longSide = 490;
	}
	else if (cNumberNonGaiaPlayers == 5) 
	{
	   size = 380;
	   longSide = 570;
	}				
	else if (cNumberNonGaiaPlayers == 6)   
	{
	   size = 410;
	   longSide = 650;
	}
	else if (cNumberNonGaiaPlayers == 7) 
	{
	   size = 430;
	   longSide = 730;
	}				
	else if (cNumberNonGaiaPlayers == 8)   
	{
	   size = 450;
	   longSide = 820;
	}		

   rmSetMapSize(size,longSide);
   
// Elevation
   rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);
   rmSetMapElevationHeightBlend(1.0);
   rmSetSeaLevel(0.0);
	
   // Text
   rmSetStatusText("",0.05);

// Terrain patterns and features 
   rmSetMapType("himalayas");
   rmSetMapType("grass");
   rmSetMapType("asia");
   rmSetLightingSet("ceylon");
   baseType = "himalayas_a";
   forestType = "Himalayas Forest";
   treeType = "ypTreeHimalayas"; 
   if (variantChance == 1)
   {
      deerType = "ypIbex";
      deer2Type = "ypMarcoPoloSheep";
   }
   else if (variantChance == 2)
   {     
      deerType = "ypMarcoPoloSheep";
      deer2Type = "ypIbex";
   }
   variantChance = rmRandInt(1,2);
   if (variantChance == 1)
   {
      centerHerdType = "ypMuskDeer";
      deer3Type = "Peafowl";
   }
   else
   {
      centerHerdType = "Peafowl";
      deer3Type = "ypMuskDeer";
   }

   sheepType = "ypYak";

   mineType = "mine";
   hillTrees = rmRandInt(0,1);
   rmSetBaseTerrainMix(baseType);
   rmTerrainInitialize("rockies\groundsnow1_roc", 0);
   rmEnableLocalWater(false);
   rmSetMapType("land");
   rmSetWorldCircleConstraint(true);
   rmSetWindMagnitude(2.0);
   chooseMercs();

// Native patterns
// EASTERN NATIVE
  if (nativePattern == 1)
  {
      rmSetSubCiv(0, "zen");
      native1Name = "native zen temple YR 0";
  }
  else if (nativePattern == 2)
  {
      rmSetSubCiv(0, "udasi");
      native1Name = "native udasi village himal ";
  }
  else if (nativePattern == 3)
  {
      rmSetSubCiv(0, "bhakti");
      native1Name = "native bhakti village himal ";
  }
  else if (nativePattern == 4)
  {
      rmSetSubCiv(0, "shaolin");
      native1Name = "native shaolin temple mongol 0";
  } 
// WESTERN NATIVE
  nativePattern = rmRandInt(1,5);
  if (nativePattern == 1)
  {
      rmSetSubCiv(1, "shaolin");
      native2Name = "native shaolin temple YR 0";
  }
  else if (nativePattern == 2)
  {
      rmSetSubCiv(1, "bhakti");
      native2Name = "native bhakti village ";
  }
  else if (nativePattern == 3)
  {
      rmSetSubCiv(1, "udasi");
      native2Name = "native udasi village ";
  }
  else if (nativePattern == 4)
  {
      rmSetSubCiv(1, "sufi");
      native2Name = "native sufi mosque deccan ";
  }
  else if (nativePattern == 5)
  {
      rmSetSubCiv(1, "zen");
      native2Name = "native zen temple YR 0";
  }

// Define some classes.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classPatch");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
   rmDefineClass("classCliff");
   rmDefineClass("classMountain");
   rmDefineClass("classBarrierRidge");
   rmDefineClass("classNugget");
   rmDefineClass("socketClass");
   rmDefineClass("classBase");
   rmDefineClass("classClearing"); 
   int classHuntable=rmDefineClass("huntableFood");   
   int classHerdable=rmDefineClass("herdableFood"); 
   int snowPatch=rmDefineClass("snow patch");
   int eastPatch=rmDefineClass("east patch");
   int greenPatch=rmDefineClass("green patch");

   // Text
   rmSetStatusText("",0.10);

// -------------Define constraints
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
   int secondEdgeConstraint=rmCreateBoxConstraint("avoid edge of map", rmXTilesToFraction(25), rmZTilesToFraction(25), 1.0-rmXTilesToFraction(25), 1.0-rmZTilesToFraction(25), 0.01);

   // Player constraints
   int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 15.0);
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 40.0);
   int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 25.0);
   int nuggetPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 57.0);
   int nativePlayerConstraint=rmCreateClassDistanceConstraint("natives stay away from players", classPlayer, 52.0);
   int farPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players more", classPlayer, 85.0);
   int fartherPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players the most", classPlayer, 100.0);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 65.0); 
   int TCconstraint=rmCreateTypeDistanceConstraint("TC avoid same", "TownCenter", 35.0);
   if ( rmGetNomadStart())
	TCconstraint=rmCreateTypeDistanceConstraint("TC avoid same", "CoveredWagon", 25.0);

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
   int avoidBarrier=rmCreateClassDistanceConstraint("stuff vs. barrier", rmClassID("classBarrierRidge"), 15.0);
   int avoidBarrierShort=rmCreateClassDistanceConstraint("stuff vs. barrier short", rmClassID("classBarrierRidge"), 1.0);
   int avoidBarrierMed=rmCreateClassDistanceConstraint("stuff vs. barrier med", rmClassID("classBarrierRidge"), 8.0);
   int avoidBase=rmCreateClassDistanceConstraint("stuff vs. base", rmClassID("classBase"), 15.0);
   int avoidBaseShort=rmCreateClassDistanceConstraint("stuff vs. base short", rmClassID("classBase"), 1.0);
   int avoidBaseMed=rmCreateClassDistanceConstraint("stuff vs. base med", rmClassID("classBase"), 7.0);
   int avoidBaseLong=rmCreateClassDistanceConstraint("stuff vs. base long", rmClassID("classBase"), 24.0);
   int avoidMts=rmCreateClassDistanceConstraint("stuff vs. mts", rmClassID("classMountain"), 15.0);
   int avoidMtsShort=rmCreateClassDistanceConstraint("stuff vs. mts short", rmClassID("classMountain"),5.0);
   int avoidClearing=rmCreateClassDistanceConstraint("avoid clearings", rmClassID("classClearing"), 5.0);
   int avoidClearingMt=rmCreateClassDistanceConstraint("mountains avoid clearings", rmClassID("classClearing"), 1.0);
   int avoidSnowPatch=rmCreateClassDistanceConstraint("avoid green", rmClassID("snow patch"), 2.0);    
   int avoidGreen=rmCreateClassDistanceConstraint("avoid green patch", rmClassID("green patch"), 4.0);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 10.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("things avoid each other", rmClassID("importantItem"), 10.0);
   int avoidImportantItemSmall=rmCreateClassDistanceConstraint("important item small avoidance", rmClassID("importantItem"), 7.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 50.0);
   int avoidNativesMed=rmCreateClassDistanceConstraint("stuff avoids natives medium", rmClassID("natives"), 35.0);
   int avoidNativesMed2=rmCreateClassDistanceConstraint("stuff avoids natives medium less", rmClassID("natives"), 30.0);
   int avoidNativesShort=rmCreateClassDistanceConstraint("stuff avoids natives shorter", rmClassID("natives"), 10.0);
   int avoidNugget=rmCreateClassDistanceConstraint("nugget vs. nugget", rmClassID("classNugget"), 42.0);
   int avoidNuggetMed=rmCreateClassDistanceConstraint("nugget vs. nugget med", rmClassID("classNugget"), 50.0);
   int avoidNuggetLong=rmCreateClassDistanceConstraint("nugget vs. nugget long", rmClassID("classNugget"), 65.0);
   int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 10.0);
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
   int avoidKOTH=rmCreateTypeDistanceConstraint("avoid KOTH", "ypKingsHill", 8.0);
   int avoidSnowTree=rmCreateTypeDistanceConstraint("avoid snow tree", "TreeYukonSnow", 15.0);

   // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
   int avoidTradeRouteCliff = rmCreateTradeRouteDistanceConstraint("trade route cliff", 10.0);
   int avoidSocket=rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 12.0);

   // Cardinal Directions - "quadrants" of the map.
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.53, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(5), rmDegreesToRadians(175));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.54, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(180), rmDegreesToRadians(360));
   int Eastmost=rmCreatePieConstraint("farEastMapConstraint", 0.6, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(0), rmDegreesToRadians(180));
   int WestMtTrees=rmCreatePieConstraint("westMtTreeConstraint", 0.56, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(180), rmDegreesToRadians(360));

// ---------------------------------------------------------------------------------------
   // Text
   rmSetStatusText("",0.15);

// Set up player starting locations
   if (cNumberTeams > 2)
   {
      if (cNumberNonGaiaPlayers == 3)
      {
         rmPlacePlayersLine(0.74, 0.19, 0.74, 0.81, 0.1, 0); 
      }
	else if (cNumberNonGaiaPlayers == 4)
      {
         rmPlacePlayersLine(0.75, 0.175, 0.75, 0.825, 0.1, 0); 
	}
      else
      {
         rmSetPlacementSection(0.1, 0.4);
         rmPlacePlayersCircular(0.395, 0.405, 0.0);
      }
   }
   else // IF # TEAMS = 2
   {   
	if (cNumberNonGaiaPlayers == 3)
      {
         rmPlacePlayersLine(0.74, 0.19, 0.74, 0.81, 0.1, 0); 
	   rmSetTeamSpacingModifier(0.8);

 //        rmSetPlacementSection(0.12, 0.38);
 //        rmPlacePlayersCircular(0.38, 0.39, 0.0);
      }
	else if (cNumberNonGaiaPlayers == 4)
      {
	   if (playerSide == 1)
		rmSetPlacementTeam(0);
	   else
		rmSetPlacementTeam(1);

         rmPlacePlayersLine(0.75, 0.18, 0.75, 0.35, 0.1, 0); 

	   if (playerSide == 1)
		rmSetPlacementTeam(1);
	   else
		rmSetPlacementTeam(0);

         rmPlacePlayersLine(0.75, 0.65, 0.75, 0.82, 0.1, 0); 

 //        rmSetPlacementSection(0.12, 0.38);
 //        rmPlacePlayersCircular(0.38, 0.39, 0.0);
      }

      else if (cNumberNonGaiaPlayers == 2)
      {
	   if (playerSide == 1)
		rmSetPlacementTeam(0);
	   else
		rmSetPlacementTeam(1);

         rmSetPlacementSection(0.13, 0.2);
         rmPlacePlayersCircular(0.395, 0.405, 0.0);

	   if (playerSide == 1)
		rmSetPlacementTeam(1);
	   else
		rmSetPlacementTeam(0);

         rmSetPlacementSection(0.37, 0.42);
         rmPlacePlayersCircular(0.395, 0.405, 0.0);
      }
      else if (cNumberNonGaiaPlayers < 7)
      {
	   if (playerSide == 1)
		rmSetPlacementTeam(0);
	   else
		rmSetPlacementTeam(1);
         rmSetPlacementSection(0.08, 0.20);
         rmPlacePlayersCircular(0.41, 0.42, 0.0);

	   if (playerSide == 1)
		rmSetPlacementTeam(1);
	   else
		rmSetPlacementTeam(0);
         rmSetPlacementSection(0.3, 0.42);
         rmPlacePlayersCircular(0.41, 0.42, 0.0);
      }
      else
      {
	   if (playerSide == 1)
		rmSetPlacementTeam(0);
	   else
		rmSetPlacementTeam(1);
         rmSetPlacementSection(0.07, 0.22);
         rmPlacePlayersCircular(0.415, 0.425, 0.0);

	   if (playerSide == 1)
		rmSetPlacementTeam(1);
	   else
		rmSetPlacementTeam(0);
         rmSetPlacementSection(0.28, 0.43);
         rmPlacePlayersCircular(0.415, 0.425, 0.0);
      }
   }
	
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
      rmAddAreaConstraint(id, secondEdgeConstraint); 
      rmSetAreaLocPlayer(id, i);
      rmSetAreaMix(id, baseType);
      rmSetAreaWarnFailure(id, false);
   }
   rmBuildAllAreas();

   // Text
   rmSetStatusText("",0.20);

// Central barrier range
   // Define base, ridge sizes, clearing size
   int radius = size*0.5;
   int baseRidgeSize = radius*radius*0.235;
   float midRidgeSize = radius*radius*0.135;
   float innerRidgeSize = radius*radius*0.052;
   float midRidgeSize2 = 0;
   float innerRidgeSize2 = 0;
   int clearingSize1 = cNumberNonGaiaPlayers * 25 + 140;
   int clearingSize2 = cNumberNonGaiaPlayers * 30 + 190;
   float greenBaseSize = baseRidgeSize * 2.3;

   // Define locations for passses, ridges
   float yCentral = rmRandFloat(0.4,0.6);
   float nTotalFraction = (1 - yCentral);
   float ySouthPercent = rmRandFloat(0.3,0.65);
   float ySouth = (ySouthPercent*yCentral);
   float yNorth = rmRandFloat(0.7,0.85);
   
   float section1 = ySouth;
   float section2 = (yCentral - ySouth);
   float section3 = (yNorth - yCentral);
   float section4 = (1.0 - yNorth);

   float epicenter1 = ySouth*0.5;
   float epicenter2 = (section2*0.5 + ySouth); 
   float epicenter3 = (section3*0.5 + yCentral);
   float epicenter4 = (section4*0.5 + yNorth);
    
   // snow base for range
   int mountainBaseID = rmCreateArea("mountain base"); 
   rmAddAreaToClass(mountainBaseID, rmClassID("classBase"));
   rmSetAreaLocation(mountainBaseID, 0.56, 0.5); 
   rmAddAreaInfluenceSegment(mountainBaseID, 0.56, 0.0, 0.56, 1.0); 
   rmSetAreaWarnFailure(mountainBaseID, false);
   rmSetAreaSize(mountainBaseID, rmAreaTilesToFraction(baseRidgeSize), rmAreaTilesToFraction(baseRidgeSize));
   rmSetAreaBaseHeight(mountainBaseID, 4.0);
   rmSetAreaElevationType(mountainBaseID, cElevTurbulence);
   rmSetAreaElevationVariation(mountainBaseID, rmRandInt(2,3));
   rmSetAreaHeightBlend(mountainBaseID, 1);
   rmSetAreaCoherence(mountainBaseID, rmRandFloat(0.7,0.8));
   rmSetAreaSmoothDistance(mountainBaseID, rmRandInt(8,12));
   rmSetAreaTerrainType(mountainBaseID, "rockies\groundsnow1_roc");
   rmAddAreaTerrainLayer(mountainBaseID, "rockies\groundsnow8_roc", 0, 3);
   rmAddAreaTerrainLayer(mountainBaseID, "rockies\groundsnow7_roc", 3, 6);
   rmAddAreaTerrainLayer(mountainBaseID, "rockies\groundsnow6_roc", 6, 9);
   rmBuildArea(mountainBaseID);

   // 1st base for east side of range, cover terrain layers
   int eastBaseID = rmCreateArea("east base"); 
   rmAddAreaToClass(eastBaseID, rmClassID("east patch"));
   rmSetAreaWarnFailure(eastBaseID, false);

   rmSetAreaLocation(eastBaseID, 0.66, 0.5); 
   rmAddAreaInfluenceSegment(eastBaseID, 0.66, 0.0, 0.66, 1.0); 
   rmSetAreaSize(eastBaseID, 0.10, 0.10);
   rmSetAreaBaseHeight(eastBaseID, 3);
   rmSetAreaElevationType(eastBaseID, cElevTurbulence);
   rmSetAreaElevationVariation(eastBaseID, 2);
   rmSetAreaHeightBlend(eastBaseID, 1);
   rmSetAreaCoherence(eastBaseID, rmRandFloat(0.5,0.6));
   rmSetAreaSmoothDistance(eastBaseID, rmRandInt(8,12));
   rmSetAreaMix(eastBaseID, "himalayas_a");
   rmBuildArea(eastBaseID);

   // intermediate base for east side of range, cover terrain layers
   int intBaseID = rmCreateArea("intermediate base"); 
   rmAddAreaToClass(intBaseID, rmClassID("east patch"));
   rmSetAreaWarnFailure(intBaseID, false);

   rmSetAreaLocation(intBaseID, 0.64, 0.5); 
   rmAddAreaInfluenceSegment(intBaseID, 0.64, 0.0, 0.64, 1.0); 
   rmSetAreaSize(intBaseID, 0.07, 0.07);
   rmSetAreaBaseHeight(intBaseID, 3.5);
   rmSetAreaElevationType(intBaseID, cElevTurbulence);
   rmSetAreaElevationVariation(intBaseID, 2);
   rmSetAreaHeightBlend(intBaseID, 1);
   rmSetAreaCoherence(intBaseID, rmRandFloat(0.5,0.6));
   rmSetAreaSmoothDistance(intBaseID, rmRandInt(8,12));
   rmSetAreaTerrainType(intBaseID, "himalayas\ground_dirt8_himal");
   rmBuildArea(intBaseID);

   // snow base for east side of range, cover terrain layers
   int snowBase2ID = rmCreateArea("east snow base 2"); 
   rmAddAreaToClass(snowBase2ID, rmClassID("snow patch"));
   rmSetAreaWarnFailure(snowBase2ID, false);
   rmSetAreaLocation(snowBase2ID, 0.625, 0.5); 
   rmAddAreaInfluenceSegment(snowBase2ID, 0.625, 0.0, 0.625, 1.0); 
   rmSetAreaSize(snowBase2ID, 0.085, 0.085);
   rmSetAreaBaseHeight(snowBase2ID, 4.0);
   rmSetAreaElevationType(snowBase2ID, cElevTurbulence);
   rmSetAreaElevationVariation(snowBase2ID, 2);
   rmSetAreaHeightBlend(snowBase2ID, 1);
   rmSetAreaCoherence(snowBase2ID, rmRandFloat(0.6,0.75));
   rmSetAreaSmoothDistance(snowBase2ID, rmRandInt(7,10));
   rmSetAreaMix(snowBase2ID, "himalayas_a");
   rmBuildArea(snowBase2ID);

   int snowBaseID = rmCreateArea("east snow base"); 
   rmAddAreaToClass(snowBaseID, rmClassID("snow patch"));
   rmSetAreaWarnFailure(snowBaseID, false);
   rmSetAreaLocation(snowBaseID, 0.61, 0.5); 
   rmAddAreaInfluenceSegment(snowBaseID, 0.615, 0.0, 0.615, 1.0); 
   rmSetAreaSize(snowBaseID, 0.085, 0.085);
   rmSetAreaBaseHeight(snowBaseID, 4.0);
   rmSetAreaElevationType(snowBaseID, cElevTurbulence);
   rmSetAreaElevationVariation(snowBaseID, 2);
   rmSetAreaHeightBlend(snowBaseID, 1);
   rmSetAreaCoherence(snowBaseID, rmRandFloat(0.8,0.9));
   rmSetAreaSmoothDistance(snowBaseID, rmRandInt(8,12));
   rmSetAreaMix(snowBaseID, "rockies_grass_snowb");
   rmBuildArea(snowBaseID);

   // tree area on mt
   int mountainTreeID = rmCreateArea("mountain tree section");
   rmSetAreaSize(mountainTreeID, rmAreaTilesToFraction(midRidgeSize), rmAreaTilesToFraction(midRidgeSize));
   rmAddAreaToClass(mountainTreeID, rmClassID("classBarrierRidge"));
   rmSetAreaLocation(mountainTreeID, 0.56, 0.5);
   rmAddAreaInfluenceSegment(mountainTreeID, 0.56, 0.0, 0.56, 1.05);
   rmSetAreaCoherence(mountainTreeID, 0.8); 
   rmSetAreaBaseHeight(mountainTreeID, 8);
   rmSetAreaElevationType(mountainTreeID, cElevTurbulence);
   rmSetAreaElevationVariation(mountainTreeID, 4.0);
   rmSetAreaHeightBlend(mountainTreeID, 1.3);
   rmSetAreaWarnFailure(mountainTreeID, false);
   rmSetAreaTerrainType(mountainTreeID, "rockies\groundforestsnow_roc");
   rmBuildArea(mountainTreeID);

   // Passes
   int forestClearing=rmCreateArea("forest clearing");
   rmSetAreaWarnFailure(forestClearing, false);
   rmSetAreaSize(forestClearing, rmAreaTilesToFraction(clearingSize1), rmAreaTilesToFraction(clearingSize2));
   rmSetAreaLocation(forestClearing, 0.56, yCentral);
   rmAddAreaInfluenceSegment(forestClearing, 0.5, yCentral, 0.63, yCentral);
   rmAddAreaToClass(forestClearing, rmClassID("classClearing"));
   rmSetAreaCoherence(forestClearing, 0.9);
   rmSetAreaTerrainType(forestClearing, "rockies\groundsnow7_roc");
   rmSetAreaBaseHeight(forestClearing, 7);
   rmSetAreaElevationVariation(forestClearing, 2.0);
   rmSetAreaHeightBlend(forestClearing, 2);
   rmBuildArea(forestClearing); 

   int forestClearingS=rmCreateArea("forest clearing south"); 
   rmSetAreaWarnFailure(forestClearingS, false);
   rmSetAreaSize(forestClearingS, rmAreaTilesToFraction(clearingSize1), rmAreaTilesToFraction(clearingSize2));
   rmSetAreaLocation(forestClearingS, 0.56, ySouth);
   rmAddAreaInfluenceSegment(forestClearingS, 0.5, ySouth, 0.63, ySouth);
   rmAddAreaToClass(forestClearingS, rmClassID("classClearing"));
   rmSetAreaCoherence(forestClearingS, 0.9);
   rmSetAreaTerrainType(forestClearingS, "rockies\groundsnow7_roc");
   rmSetAreaBaseHeight(forestClearingS, 7);
   rmSetAreaElevationVariation(forestClearingS, 2.0);
   rmSetAreaHeightBlend(forestClearingS, 2);
   rmBuildArea(forestClearingS); 

   int forestClearingN=rmCreateArea("forest clearing north"); 
   rmSetAreaWarnFailure(forestClearingN, false);
   rmSetAreaSize(forestClearingN, rmAreaTilesToFraction(clearingSize1), rmAreaTilesToFraction(clearingSize2));
   rmSetAreaLocation(forestClearingN, 0.56, yNorth);
   rmAddAreaInfluenceSegment(forestClearingN, 0.5, yNorth, 0.63, yNorth);
   rmAddAreaToClass(forestClearingN, rmClassID("classClearing"));
   rmSetAreaCoherence(forestClearingN, 0.9);
   rmSetAreaTerrainType(forestClearingN, "rockies\groundsnow7_roc");
   rmSetAreaBaseHeight(forestClearingN, 7);
   rmSetAreaElevationVariation(forestClearingN, 2.0);
   rmSetAreaHeightBlend(forestClearingN, 2);
   rmBuildArea(forestClearingN);


   // peaks N mt
   innerRidgeSize2 = innerRidgeSize*section4;
   int mountainNPeaksID = rmCreateArea("mountain N peaks");
   rmSetAreaSize(mountainNPeaksID, rmAreaTilesToFraction(innerRidgeSize2), rmAreaTilesToFraction(innerRidgeSize2));
   rmAddAreaToClass(mountainNPeaksID, rmClassID("classMountain"));
   rmSetAreaLocation(mountainNPeaksID, 0.56, epicenter4);      
   rmAddAreaInfluenceSegment(mountainNPeaksID, 0.56, 0.94, 0.56, yNorth); 
   rmSetAreaCoherence(mountainNPeaksID, 0.8); 
   rmSetAreaSmoothDistance(mountainNPeaksID, 5);
   rmSetAreaCliffType(mountainNPeaksID, "ShangriLa"); //
   rmSetAreaCliffHeight(mountainNPeaksID, 7, 0.0, 0.5);
   rmSetAreaCliffEdge(mountainNPeaksID, 1, 1.0, 0.0, 0.0, 1);
   rmAddAreaConstraint(mountainNPeaksID, avoidClearingMt);
   rmSetAreaWarnFailure(mountainNPeaksID, false);
   rmBuildArea(mountainNPeaksID);


   // peaks S mt
   innerRidgeSize2 = innerRidgeSize * section1;
   int mountainSPeaksID = rmCreateArea("mountain S peaks");
   rmSetAreaSize(mountainSPeaksID, rmAreaTilesToFraction(innerRidgeSize2), rmAreaTilesToFraction(innerRidgeSize2));
   rmAddAreaToClass(mountainSPeaksID, rmClassID("classMountain"));
   rmSetAreaLocation(mountainSPeaksID, 0.56, epicenter1);
   rmAddAreaInfluenceSegment(mountainSPeaksID, 0.56, 0.06, 0.56, ySouth);
   rmSetAreaCoherence(mountainSPeaksID, 0.8); 
   rmSetAreaSmoothDistance(mountainSPeaksID, 5);
   rmSetAreaCliffType(mountainSPeaksID, "ShangriLa"); //
   rmSetAreaCliffHeight(mountainSPeaksID, 7, 0.0, 0.5);
   rmSetAreaCliffEdge(mountainSPeaksID, 1, 1.0, 0.0, 0.0, 1);
   rmAddAreaConstraint(mountainSPeaksID, avoidClearingMt);
   rmSetAreaWarnFailure(mountainSPeaksID, false);
   rmBuildArea(mountainSPeaksID);


   // peaks SCent mt
   innerRidgeSize2 = innerRidgeSize * section2;
   int mountainSCPeaksID = rmCreateArea("mountain SC peaks");
   rmSetAreaSize(mountainSCPeaksID, rmAreaTilesToFraction(innerRidgeSize2), rmAreaTilesToFraction(innerRidgeSize2));
   rmAddAreaToClass(mountainSCPeaksID, rmClassID("classMountain"));
   rmSetAreaLocation(mountainSCPeaksID, 0.56, epicenter2);
   rmAddAreaInfluenceSegment(mountainSCPeaksID, 0.56, ySouth, 0.56, yCentral);
   rmSetAreaCoherence(mountainSCPeaksID, 0.8); 
   rmSetAreaSmoothDistance(mountainSCPeaksID, 5);
   rmSetAreaCliffType(mountainSCPeaksID, "ShangriLa"); //
   rmSetAreaCliffHeight(mountainSCPeaksID, 7, 0.0, 0.5);
   rmSetAreaCliffEdge(mountainSCPeaksID, 1, 1.0, 0.0, 0.0, 1);
   rmAddAreaConstraint(mountainSCPeaksID, avoidClearingMt);
   rmSetAreaWarnFailure(mountainSCPeaksID, false);
   rmBuildArea(mountainSCPeaksID);


   // peaks NCent mt
   innerRidgeSize2 = innerRidgeSize * section3;
   int mountainNCPeaksID = rmCreateArea("mountain NC peaks");
   rmSetAreaSize(mountainNCPeaksID, rmAreaTilesToFraction(innerRidgeSize2), rmAreaTilesToFraction(innerRidgeSize2));
   rmAddAreaToClass(mountainNCPeaksID, rmClassID("classMountain"));
   rmSetAreaLocation(mountainNCPeaksID, 0.56, epicenter3);      
   rmAddAreaInfluenceSegment(mountainNCPeaksID, 0.56, yCentral, 0.56, yNorth); 
   rmSetAreaCoherence(mountainNCPeaksID, 0.8); 
   rmSetAreaSmoothDistance(mountainNCPeaksID, 5);
   rmSetAreaCliffType(mountainNCPeaksID, "ShangriLa"); //
   rmSetAreaCliffHeight(mountainNCPeaksID, 7, 0.0, 0.5);
   rmSetAreaCliffEdge(mountainNCPeaksID, 1, 1.0, 0.0, 0.0, 1);
   rmAddAreaConstraint(mountainNCPeaksID, avoidClearingMt);
   rmSetAreaWarnFailure(mountainNCPeaksID, false);
   rmBuildArea(mountainNCPeaksID);


// More green terrain west of mountains
   int WestGreenBaseAID = rmCreateArea("west green base A"); 
   rmAddAreaToClass(WestGreenBaseAID, rmClassID("green patch"));
   rmSetAreaLocation(WestGreenBaseAID, 0.05, 0.5); 
//   rmAddAreaInfluenceSegment(WestGreenBaseAID, 0.24, 0.0, 0.24, 1.0); 
   rmAddAreaInfluenceSegment(WestGreenBaseAID, 0.0, 0.0, 0.0, 1.0); 
   rmSetAreaWarnFailure(WestGreenBaseAID, false);
   rmSetAreaSize(WestGreenBaseAID, 0.10, 0.10);
   rmSetAreaCoherence(WestGreenBaseAID, 0.99);
   rmAddAreaConstraint(WestGreenBaseAID, avoidBaseShort);
   rmSetAreaMix(WestGreenBaseAID, "borneo_grass_d");
   rmBuildArea(WestGreenBaseAID);

   int WestGreenBaseID = rmCreateArea("west green base"); 
   rmAddAreaToClass(WestGreenBaseID, rmClassID("green patch"));
   rmSetAreaLocation(WestGreenBaseID, 0.3, 0.5); 
   rmAddAreaInfluenceSegment(WestGreenBaseID, 0.3, 0.0, 0.3, 1.0); 
   rmAddAreaInfluenceSegment(WestGreenBaseID, 0.0, 0.0, 0.0, 1.0); 
   rmSetAreaWarnFailure(WestGreenBaseID, false);
   rmSetAreaSize(WestGreenBaseID, 0.485, 0.485);
   rmSetAreaCoherence(WestGreenBaseID, 0.99);
   rmSetAreaSmoothDistance(WestGreenBaseID, rmRandInt(8,12));
   rmAddAreaConstraint(WestGreenBaseID, avoidBaseShort);
   rmSetAreaMix(WestGreenBaseID, "borneo_grass_d");
   rmBuildArea(WestGreenBaseID);

   // Text
   rmSetStatusText("",0.25);

// Trade Routes
   variantChance = rmRandInt(1,2);
   int tradeRouteID4A = rmCreateTradeRoute();
   if (variantChance == 1)
   {
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.16, 0.95);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.24, 0.8);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.29, 0.7);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 0.55);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 0.5);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 0.45);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.29, 0.3);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.24, 0.22);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.16, 0.05);
   }
   else
   {
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.2, 0.95);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.26, 0.8);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.28, 0.7);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.23, 0.55);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.26, 0.5);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.23, 0.45);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.28, 0.3);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.26, 0.22);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.2, 0.05);
   }

   rmBuildTradeRoute(tradeRouteID4A, "water");

   // Text
   rmSetStatusText("",0.30);

// Trade sockets
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
   rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 8.0);
   variantChance = rmRandInt(1,2);

   rmSetObjectDefTradeRouteID(socketID, tradeRouteID4A);
   if (socketPattern == 1)  // 4 sockets per route
   {
      vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.87);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.66);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.34);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
  
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.13);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else if (socketPattern == 2)  // 3 sockets per route
   {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.87);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
  
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.13);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else  // 2 sockets per route
   {
	if (rmRandInt(1,2) == 1)
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

   //Text
   rmSetStatusText("",0.35);

// Starting TCs and units 	
   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 6.0);
   rmSetObjectDefMaxDistance(startingUnits, 12.0);
   rmAddObjectDefConstraint(startingUnits, avoidAll);
   rmAddObjectDefConstraint(startingUnits, avoidBase);

   int startingTCID= rmCreateObjectDef("startingTC");
   rmSetObjectDefMaxDistance(startingTCID, 15.0);
   rmAddObjectDefConstraint(startingTCID, avoidAll);
   rmAddObjectDefConstraint(startingTCID, avoidTradeRoute);
   rmAddObjectDefConstraint(startingTCID, avoidBaseLong);  
   rmAddObjectDefConstraint(startingTCID, TCconstraint);
   rmAddObjectDefConstraint(startingTCID, secondEdgeConstraint);                
   if ( rmGetNomadStart())
   {
	rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
   }
   else
   {
      rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
   }

   // start area huntable
   int deerNum = rmRandInt(5,6);
   int startPronghornID=rmCreateObjectDef("starting pronghorn");
   rmAddObjectDefItem(startPronghornID, deerType, deerNum, 5.0);
   rmAddObjectDefToClass(startPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(startPronghornID, 14);
   rmSetObjectDefMaxDistance(startPronghornID, 18);
   rmAddObjectDefConstraint(startPronghornID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(startPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(startPronghornID, avoidBarrier);
   rmAddObjectDefConstraint(startPronghornID, avoidAll);
   rmSetObjectDefCreateHerd(startPronghornID, false);

   // second huntable
   int deer2Num = rmRandInt(4,6);
   int farPronghornID=rmCreateObjectDef("far pronghorn");
   rmAddObjectDefItem(farPronghornID, deer2Type, deer2Num, 5.0);
   rmAddObjectDefToClass(farPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farPronghornID, 45.0);
   rmSetObjectDefMaxDistance(farPronghornID, 55.0);
   rmAddObjectDefConstraint(farPronghornID, avoidStartResource);
   rmAddObjectDefConstraint(farPronghornID, mediumPlayerConstraint);
   rmAddObjectDefConstraint(farPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(farPronghornID, avoidNativesShort);
   rmAddObjectDefConstraint(farPronghornID, huntableConstraint);
   rmAddObjectDefConstraint(farPronghornID, avoidBarrier);
   rmAddObjectDefConstraint(farPronghornID, avoidAll);
   rmAddObjectDefConstraint(farPronghornID, Eastward);
   rmSetObjectDefCreateHerd(farPronghornID, true);

   // start area trees 
   int StartAreaTreeID=rmCreateObjectDef("starting trees");
   rmAddObjectDefItem(StartAreaTreeID, treeType, 1, 0.0);
   rmSetObjectDefMinDistance(StartAreaTreeID, 10);
   rmSetObjectDefMaxDistance(StartAreaTreeID, 12);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidAll);

   // Silver mines - players
   int silverType = -1;
   silverType = rmRandInt(1,10);
   int playerGoldID=rmCreateObjectDef("player silver closer");
   rmAddObjectDefItem(playerGoldID, mineType, 1, 0.0);
   rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(playerGoldID, avoidAll);
   rmAddObjectDefConstraint(playerGoldID, avoidBarrier);
   rmSetObjectDefMinDistance(playerGoldID, 18.0);
   rmSetObjectDefMaxDistance(playerGoldID, 23.0);

   // berry bushes
   int StartBerryBushID=rmCreateObjectDef("starting berry bush");
   rmAddObjectDefItem(StartBerryBushID, "BerryBush", rmRandInt(3,3), 4.0);
   rmSetObjectDefMinDistance(StartBerryBushID, 10.0);
   rmSetObjectDefMaxDistance(StartBerryBushID, 16.0);
   rmAddObjectDefConstraint(StartBerryBushID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartBerryBushID, avoidAll);

   for(i=1; <cNumberPlayers)
   {	
      rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

	vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
	rmPlaceObjectDefAtLoc(startPronghornID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(playerGoldID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(StartBerryBushID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(farPronghornID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

      if(ypIsAsian(i) && rmGetNomadStart() == false)
        rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

   }
   
   // Text
   rmSetStatusText("",0.40);

// KOTH game mode 
   if(rmGetIsKOTH())
   {
      float xLoc = 0.18;
      float yLoc = 0.5;
      float walk = 0.2;
      ypKingsHillPlacer(xLoc, yLoc, walk, 0);
   }

// NATIVE VILLAGES
   // Village A - East of mts
   int villageAID = -1;
   int whichNative = rmRandInt(1,2);
   int villageType = rmRandInt(1,5);

   villageAID = rmCreateGrouping("village A", native1Name+villageType);
   rmAddGroupingToClass(villageAID, rmClassID("natives"));
   rmAddGroupingToClass(villageAID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageAID, 0.0);
   rmSetGroupingMaxDistance(villageAID, size*0.1);
   rmAddGroupingConstraint(villageAID, avoidImpassableLand);
   rmAddGroupingConstraint(villageAID, avoidTradeRoute);
   rmAddGroupingConstraint(villageAID, avoidSocket);
   if (cNumberNonGaiaPlayers < 4)
   {
      rmAddGroupingConstraint(villageAID, avoidNativesMed2);
      rmAddGroupingConstraint(villageAID, nuggetPlayerConstraint);
   }
   else
   {
      rmAddGroupingConstraint(villageAID, avoidNativesMed);
      rmAddGroupingConstraint(villageAID, longPlayerConstraint);
   }
   rmAddGroupingConstraint(villageAID, playerEdgeConstraint);
   rmAddGroupingConstraint(villageAID, avoidBarrier);

   // Village D - West of mts
   int villageDID = -1;
   villageType = rmRandInt(1,5);

   villageDID = rmCreateGrouping("village D", native2Name+villageType);
   rmAddGroupingToClass(villageDID, rmClassID("natives"));
   rmAddGroupingToClass(villageDID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageDID, 0.0);
   rmSetGroupingMaxDistance(villageDID, size*0.1);
   rmAddGroupingConstraint(villageDID, avoidKOTH);
   rmAddGroupingConstraint(villageDID, avoidImpassableLand);
   rmAddGroupingConstraint(villageDID, avoidTradeRoute);
   rmAddGroupingConstraint(villageDID, avoidNativesMed);
   rmAddGroupingConstraint(villageDID, playerEdgeConstraint);
   rmAddGroupingConstraint(villageDID, avoidBarrier);
   rmAddGroupingConstraint(villageDID, avoidSocket);

   // Text
   rmSetStatusText("",0.45);

// Placement of Natives
   // East
   if (cNumberNonGaiaPlayers == 2)
   {
	if (rmRandInt(1,2) == 1)
        rmPlaceGroupingAtLoc(villageAID, 0, 0.71, 0.5);
	else
        rmPlaceGroupingAtLoc(villageAID, 0, 0.89, 0.5);
   }
   else if (cNumberNonGaiaPlayers == 3)
   {
        rmPlaceGroupingAtLoc(villageAID, 0, 0.93, 0.35);
        rmPlaceGroupingAtLoc(villageAID, 0, 0.93, 0.65);
   }
   else if (cNumberNonGaiaPlayers == 4)
   {
        rmPlaceGroupingAtLoc(villageAID, 0, 0.91, 0.5);
   }
   else if (cNumberNonGaiaPlayers > 4)
   {
         rmPlaceGroupingAtLoc(villageAID, 0, 0.69, 0.62);
         rmPlaceGroupingAtLoc(villageAID, 0, 0.69, 0.38);
   }
   
   // West
   if (nativeSetup == 1)
   {
      rmPlaceGroupingAtLoc(villageDID, 0, 0.16, 0.62);
      rmPlaceGroupingAtLoc(villageDID, 0, 0.16, 0.38);
   }
   else if (nativeSetup == 2)
   {
      rmPlaceGroupingAtLoc(villageDID, 0, 0.2, 0.72);
      rmPlaceGroupingAtLoc(villageDID, 0, 0.2, 0.28);
   }
   else if (nativeSetup == 3)
   {
      rmPlaceGroupingAtLoc(villageDID, 0, 0.23, 0.78);
      rmPlaceGroupingAtLoc(villageDID, 0, 0.23, 0.22);
   }
   if (cNumberNonGaiaPlayers > 4)
	rmPlaceGroupingAtLoc(villageDID, 0, 0.3, 0.5);

   // Text
   rmSetStatusText("",0.50);

// Player Nuggets
   int playerNuggetID=rmCreateObjectDef("player nugget");
   rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
   rmAddObjectDefToClass(playerNuggetID, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(playerNuggetID, 35.0);
   rmSetObjectDefMaxDistance(playerNuggetID, 40.0);
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

// Random Nuggets
   int nugget2= rmCreateObjectDef("nugget medium"); 
   rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(2, 2);
   rmAddObjectDefToClass(nugget2, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget2, 75.0);
   rmSetObjectDefMaxDistance(nugget2, size*0.5);
   rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget2, avoidSocket);
   rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget2, nuggetPlayerConstraint);
   rmAddObjectDefConstraint(nugget2, avoidNuggetMed);
   rmAddObjectDefConstraint(nugget2, playerEdgeConstraint);
   rmAddObjectDefConstraint(nugget2, avoidBarrier);
   rmAddObjectDefConstraint(nugget2, avoidAll);
   rmAddObjectDefConstraint(nugget2, avoidKOTH);
   rmPlaceObjectDefPerPlayer(nugget2, false, 1);

   int nugget3= rmCreateObjectDef("nugget hard"); 
   rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(3, 3);
   rmAddObjectDefToClass(nugget3, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget3, 90.0);
   rmAddObjectDefConstraint(nugget3, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget3, avoidSocket);
   rmAddObjectDefConstraint(nugget3, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget3, avoidNuggetMed);
   rmAddObjectDefConstraint(nugget3, playerEdgeConstraint);
   rmAddObjectDefConstraint(nugget3, avoidBarrier);
   rmAddObjectDefConstraint(nugget3, Westward);
   rmAddObjectDefConstraint(nugget3, avoidAll);
   rmAddObjectDefConstraint(nugget3, avoidKOTH);
   if (cNumberNonGaiaPlayers < 7) 
      rmPlaceObjectDefInArea(nugget3, 0, rmAreaID("west green base"), cNumberNonGaiaPlayers);
   else
      rmPlaceObjectDefInArea(nugget3, 0, rmAreaID("west green base"), 6);

   int nugget4= rmCreateObjectDef("nugget nuts"); 
   rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(4, 4);
   rmAddObjectDefToClass(nugget4, rmClassID("classNugget"));
   rmAddObjectDefConstraint(nugget4, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget4, avoidSocket);
   rmAddObjectDefConstraint(nugget4, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget4, avoidNuggetMed);
   rmAddObjectDefConstraint(nugget4, playerEdgeConstraint);
   rmAddObjectDefConstraint(nugget4, avoidBarrier);
   rmAddObjectDefConstraint(nugget4, Westward);
   rmAddObjectDefConstraint(nugget4, avoidAll);
   rmAddObjectDefConstraint(nugget4, avoidKOTH);
   if (cNumberNonGaiaPlayers < 6) 
      rmPlaceObjectDefInArea(nugget4, 0, rmAreaID("west green base"), cNumberNonGaiaPlayers);
   else
      rmPlaceObjectDefInArea(nugget4, 0, rmAreaID("west green base"), 5);
   
   rmSetObjectDefMaxDistance(nugget2, size);
   rmAddObjectDefConstraint(nugget2, Westward);
   if (cNumberNonGaiaPlayers < 5) 
      rmPlaceObjectDefInArea(nugget2, 0, rmAreaID("west green base"), cNumberNonGaiaPlayers);
   else
      rmPlaceObjectDefInArea(nugget2, 0, rmAreaID("west green base"), 4);

   // Text
   rmSetStatusText("",0.60);

// west berry bushes
   int berryNum = (cNumberNonGaiaPlayers + rmRandInt(0,3));
   int westBerryBushID=rmCreateObjectDef("west berry bush");
   rmAddObjectDefItem(westBerryBushID, "BerryBush", rmRandInt(4,6), 4.0);
   rmAddObjectDefConstraint(westBerryBushID, Westward);
   rmAddObjectDefConstraint(westBerryBushID, avoidBarrier);
   rmAddObjectDefConstraint(westBerryBushID, avoidAll);
   rmAddObjectDefConstraint(westBerryBushID, avoidKOTH);
   rmPlaceObjectDefPerPlayer(westBerryBushID, false, 1);
   rmPlaceObjectDefInArea(westBerryBushID, 0, rmAreaID("west green base"), berryNum);

   // Text
   rmSetStatusText("",0.65);

// Extra tree clumps near players - to ensure fair access to wood
   int extraTreesID=rmCreateObjectDef("extra trees");
   rmAddObjectDefItem(extraTreesID, treeType, 4, 5.0);
   rmSetObjectDefMinDistance(extraTreesID, 14);
   rmSetObjectDefMaxDistance(extraTreesID, 18);
   rmAddObjectDefConstraint(extraTreesID, avoidAll);
   rmAddObjectDefConstraint(extraTreesID, avoidCoin);
   rmAddObjectDefConstraint(extraTreesID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraTreesID, avoidSnowPatch);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTreesID, 0, rmAreaID("player"+i), 1);

   int extraTrees2ID=rmCreateObjectDef("more extra trees");
   rmAddObjectDefItem(extraTrees2ID, treeType, 4, 6.0);
   rmSetObjectDefMinDistance(extraTrees2ID, 18);
   rmSetObjectDefMaxDistance(extraTrees2ID, 23);
   rmAddObjectDefConstraint(extraTrees2ID, avoidAll);
   rmAddObjectDefConstraint(extraTrees2ID, avoidCoin);
   rmAddObjectDefConstraint(extraTrees2ID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraTrees2ID, avoidSnowPatch);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTrees2ID, 0, rmAreaID("player"+i), 1);

   // Text
   rmSetStatusText("",0.70);

// Forests
   int failCount=0;
   int forestChance = -1;
   int numTries=4*cNumberNonGaiaPlayers;
   if (cNumberNonGaiaPlayers > 3)
      numTries=3.5*cNumberNonGaiaPlayers;  
   if (cNumberNonGaiaPlayers > 5)
      numTries=3*cNumberNonGaiaPlayers;  
   if (cNumberNonGaiaPlayers > 6)
      numTries=2*cNumberNonGaiaPlayers;   
   
   // East forest - Himalayas
   failCount=0;
   for (i=0; <numTries)
   {
      forestChance = rmRandInt(1,4);
      int forest=rmCreateArea("forest east "+i);
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(70), rmAreaTilesToFraction(120));
      rmSetAreaForestType(forest, forestType);
      rmSetAreaForestDensity(forest, rmRandFloat(0.4,0.6));
      rmSetAreaForestClumpiness(forest, rmRandFloat(0.5,0.6));
      rmSetAreaForestUnderbrush(forest, rmRandFloat(0.0,0.5));
      rmSetAreaCoherence(forest, rmRandFloat(0.4,0.6));
      rmSetAreaSmoothDistance(forest, rmRandInt(10,15));
      if (forestChance == 3)
      {
		rmSetAreaMinBlobs(forest, 1);
		rmSetAreaMaxBlobs(forest, 3);					
		rmSetAreaMinBlobDistance(forest, 10.0);
		rmSetAreaMaxBlobDistance(forest, 18.0);
	}
      if (forestChance == 4)
      {
		rmSetAreaMinBlobs(forest, 3);
		rmSetAreaMaxBlobs(forest, 5);					
		rmSetAreaMinBlobDistance(forest, 14.0);
		rmSetAreaMaxBlobDistance(forest, 24.0);
		rmSetAreaSmoothDistance(forest, 20);
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
	rmAddAreaConstraint(forest, Eastmost);
	rmAddAreaConstraint(forest, patchConstraint);
	rmAddAreaConstraint(forest, avoidNativesShort);

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

   // West forest - Shangri La
   numTries=6*cNumberNonGaiaPlayers;  
   if (cNumberNonGaiaPlayers > 3)
      numTries=5*cNumberNonGaiaPlayers;  
   if (cNumberNonGaiaPlayers > 5)
      numTries=4*cNumberNonGaiaPlayers;  
   if (cNumberNonGaiaPlayers > 6)
      numTries=3*cNumberNonGaiaPlayers; 

   failCount=0;
   for (i=0; <numTries)
   {
      forestChance = rmRandInt(1,4);
      int WestForest=rmCreateArea("forest west "+i);
      rmSetAreaWarnFailure(WestForest, false);
      rmSetAreaSize(WestForest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(280));
      rmSetAreaForestType(WestForest, "Borneo Canopy Forest");
      rmSetAreaForestDensity(WestForest, rmRandFloat(0.7,1.0));
      rmSetAreaForestClumpiness(WestForest, rmRandFloat(0.5,0.9));
      rmSetAreaForestUnderbrush(WestForest, rmRandFloat(0.0,0.5));
      rmSetAreaCoherence(WestForest, rmRandFloat(0.4,0.7));
      rmSetAreaSmoothDistance(WestForest, rmRandInt(10,20));
      if (forestChance == 3)
      {
		rmSetAreaMinBlobs(WestForest, 2);
		rmSetAreaMaxBlobs(WestForest, 3);					
		rmSetAreaMinBlobDistance(WestForest, 12.0);
		rmSetAreaMaxBlobDistance(WestForest, 24.0);
	}
      if (forestChance == 4)
      {
		rmSetAreaMinBlobs(WestForest, 3);
		rmSetAreaMaxBlobs(WestForest, 5);					
		rmSetAreaMinBlobDistance(WestForest, 16.0);
		rmSetAreaMaxBlobDistance(WestForest, 28.0);
		rmSetAreaSmoothDistance(WestForest, 20);
	}
      rmAddAreaToClass(WestForest, rmClassID("classForest")); 
      rmAddAreaConstraint(WestForest, forestConstraint);
      rmAddAreaConstraint(WestForest, avoidAll); 
      rmAddAreaConstraint(WestForest, avoidKOTH); 
	rmAddAreaConstraint(WestForest, avoidCoin);  
	rmAddAreaConstraint(WestForest, avoidBarrierMed);
	rmAddAreaConstraint(WestForest, avoidBaseMed);
      rmAddAreaConstraint(WestForest, avoidImpassableLand); 
      rmAddAreaConstraint(WestForest, avoidTradeRoute);
	rmAddAreaConstraint(WestForest, avoidSocket);
	rmAddAreaConstraint(WestForest, Westward);
	rmAddAreaConstraint(WestForest, patchConstraint);
	rmAddAreaConstraint(WestForest, avoidNativesShort);

      if(rmBuildArea(WestForest)==false)
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

// Extra gold mines - west of the mountains.
   silverType = rmRandInt(1,10);
   int extraGoldID = rmCreateObjectDef("extra gold "+i);
   rmAddObjectDefItem(extraGoldID, "minegold", 1, 0);
   rmAddObjectDefToClass(extraGoldID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(extraGoldID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraGoldID, avoidSocket);
   rmAddObjectDefConstraint(extraGoldID, coinAvoidCoin);
   rmAddObjectDefConstraint(extraGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(extraGoldID, avoidAll);
   rmAddObjectDefConstraint(extraGoldID, avoidKOTH);
   rmAddObjectDefConstraint(extraGoldID, avoidMtsShort);
   rmAddObjectDefConstraint(extraGoldID, Westward);
   rmSetObjectDefMinDistance(extraGoldID, 5.0);
   rmSetObjectDefMaxDistance(extraGoldID, 8.0);

   rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.505, epicenter1, 1);  
   rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.505, epicenter2, 1);
   rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.505, epicenter3, 1);
   rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.505, epicenter4, 1);

   rmAddObjectDefConstraint(extraGoldID, avoidBarrier);
   rmSetObjectDefMinDistance(extraGoldID, 25.0);
   rmSetObjectDefMaxDistance(extraGoldID, 100.0);

   rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.2, 0.2, 1);
   rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.3, 0.4, rmRandInt(1,2));
   rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.2, 0.6, rmRandInt(1,2));
   rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.3, 0.8, 1);
   if (cNumberNonGaiaPlayers > 2)
   {
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.15, 0.5, 1);
   }
   if (cNumberNonGaiaPlayers > 4)
   {
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.4, 0.3, 1);
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.4, 0.7, 1);
   }
   if (cNumberNonGaiaPlayers > 6)
   {
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.4, 0.1, 1);
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.4, 0.9, 1);
   }
   rmPlaceObjectDefInArea(extraGoldID, 0, rmAreaID("west green base"), cNumberNonGaiaPlayers);

   // Text
   rmSetStatusText("",0.85);

// West herds
   int centralHerdID=rmCreateObjectDef("central herd");  
   rmAddObjectDefItem(centralHerdID, centerHerdType, rmRandInt(7,9), 6.0);
   rmAddObjectDefToClass(centralHerdID, rmClassID("huntableFood"));
   rmSetObjectDefCreateHerd(centralHerdID, true);
   rmSetObjectDefMinDistance(centralHerdID, 0);
   rmSetObjectDefMaxDistance(centralHerdID, 12);
   rmAddObjectDefConstraint(centralHerdID, avoidBarrier);
   rmAddObjectDefConstraint(centralHerdID, Westward);
   // herds by passes
   rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.46, yCentral, 1);
   rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.46, yNorth, 1);
   rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.46, ySouth, 1);

   int farHuntableID=rmCreateObjectDef("far huntable");
   rmAddObjectDefItem(farHuntableID, deer3Type, rmRandInt(5,9), 6.0);
   rmAddObjectDefToClass(farHuntableID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farHuntableID, 0.3*size);
   rmSetObjectDefMaxDistance(farHuntableID, 0.8*size);
   rmAddObjectDefConstraint(farHuntableID, avoidTradeRoute);
   rmAddObjectDefConstraint(farHuntableID, avoidImportantItem);
   rmAddObjectDefConstraint(farHuntableID, fartherPlayerConstraint);
   rmAddObjectDefConstraint(farHuntableID, longHuntableConstraint);
   rmAddObjectDefConstraint(farHuntableID, avoidAll);
   rmAddObjectDefConstraint(farHuntableID, avoidKOTH);
   rmAddObjectDefConstraint(farHuntableID, avoidBarrier);
   rmAddObjectDefConstraint(farHuntableID, Westward);
   rmSetObjectDefCreateHerd(farHuntableID, true);
   rmPlaceObjectDefPerPlayer(farHuntableID, false, 1);

   // more central herds
   rmSetObjectDefMinDistance(centralHerdID, 20);
   rmSetObjectDefMaxDistance(centralHerdID, 0.25*size);
   rmAddObjectDefConstraint(centralHerdID, avoidTradeRoute);
   rmAddObjectDefConstraint(centralHerdID, avoidImportantItem);
   rmAddObjectDefConstraint(centralHerdID, farPlayerConstraint);
   rmAddObjectDefConstraint(centralHerdID, longHuntableConstraint);
   rmAddObjectDefConstraint(centralHerdID, avoidKOTH);
   rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.25, 0.25, cNumberNonGaiaPlayers);
   rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.25, 0.75, cNumberNonGaiaPlayers);

// Sheep etc
   int sheepID=rmCreateObjectDef("herdable animal");
   rmAddObjectDefItem(sheepID, sheepType, 2, 4.0);
   rmAddObjectDefToClass(sheepID, rmClassID("herdableFood"));
   rmSetObjectDefMinDistance(sheepID, 40.0);
   rmSetObjectDefMaxDistance(sheepID, 0.2*longSide);
   rmAddObjectDefConstraint(sheepID, avoidSheep);
   rmAddObjectDefConstraint(sheepID, avoidAll);
   rmAddObjectDefConstraint(sheepID, playerConstraint);
   rmAddObjectDefConstraint(sheepID, avoidBarrier);
   rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
   rmAddObjectDefConstraint(sheepID, Eastward);
   rmPlaceObjectDefPerPlayer(sheepID, false, 2);

   int sheep2ID=rmCreateObjectDef("west herdable animal");
   if (sheepChance == 1)
      rmAddObjectDefItem(sheep2ID, "ypGoat", 2, 4.0);
   else 
      rmAddObjectDefItem(sheep2ID, "ypWaterBuffalo", 2, 4.0);
   rmAddObjectDefToClass(sheep2ID, rmClassID("herdableFood"));
   rmAddObjectDefConstraint(sheep2ID, avoidSheep);
   rmAddObjectDefConstraint(sheep2ID, avoidAll);
   rmAddObjectDefConstraint(sheep2ID, avoidKOTH);
   rmAddObjectDefConstraint(sheep2ID, playerConstraint);
   rmAddObjectDefConstraint(sheep2ID, avoidBarrier);
   rmAddObjectDefConstraint(sheep2ID, avoidImpassableLand);
   rmAddObjectDefConstraint(sheep2ID, Westward);
   rmPlaceObjectDefInArea(sheep2ID, 0, rmAreaID("west green base"), cNumberNonGaiaPlayers*2);
   if (cNumberNonGaiaPlayers < 4)
      rmPlaceObjectDefInArea(sheep2ID, 0, rmAreaID("west green base"), 2);

   // Text
   rmSetStatusText("",0.90);

// Mountain trees - west slope
   int ridgeTree=rmCreateObjectDef("ridge trees");
   rmAddObjectDefConstraint(ridgeTree, avoidClearing);
   rmAddObjectDefConstraint(ridgeTree, avoidGreen);
   rmAddObjectDefConstraint(ridgeTree, avoidAll);
   rmAddObjectDefConstraint(ridgeTree, WestMtTrees);
   int numTrees = size/3;
   rmAddObjectDefItem(ridgeTree, "TreeRockiesSnow", 1, 0.0);
   rmAddObjectDefConstraint(ridgeTree, avoidMtsShort);
   rmPlaceObjectDefInArea(ridgeTree, 0, mountainBaseID, numTrees);
   numTrees = size/2.5;
   rmPlaceObjectDefInArea(ridgeTree, 0, mountainTreeID, numTrees);

// Random trees
   int StragglerTreeID=rmCreateObjectDef("stragglers in east");
   rmAddObjectDefItem(StragglerTreeID, treeType, 1, 0.0);
   rmAddObjectDefConstraint(StragglerTreeID, avoidAll);
   rmAddObjectDefConstraint(StragglerTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StragglerTreeID, avoidCoin);
   rmAddObjectDefConstraint(StragglerTreeID, avoidClearing);
   rmAddObjectDefConstraint(StragglerTreeID, Eastmost);
   rmAddObjectDefConstraint(StragglerTreeID, avoidBarrier);
   rmAddObjectDefConstraint(StragglerTreeID, avoidBase);
   rmPlaceObjectDefInArea(StragglerTreeID, 0, rmAreaID("intermediate base"), cNumberNonGaiaPlayers*4);

   rmAddObjectDefConstraint(StragglerTreeID, patchConstraint);
   rmSetObjectDefMinDistance(StragglerTreeID, 10.0);
   rmSetObjectDefMaxDistance(StragglerTreeID, longSide*0.5);
   for(i=0; <cNumberNonGaiaPlayers*6)
      rmPlaceObjectDefAtLoc(StragglerTreeID, 0, 0.85, 0.5);

   int ECStragglerTreeID=rmCreateObjectDef("stragglers in east center");
   rmAddObjectDefItem(ECStragglerTreeID, "TreeYukonSnow", 1, 0.0);
   rmAddObjectDefConstraint(ECStragglerTreeID, avoidAll);
   rmAddObjectDefConstraint(ECStragglerTreeID, avoidSnowTree);
   rmAddObjectDefConstraint(ECStragglerTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(ECStragglerTreeID, avoidCoin);
   rmAddObjectDefConstraint(ECStragglerTreeID, patchConstraint);
   rmAddObjectDefConstraint(ECStragglerTreeID, avoidMtsShort);
   rmAddObjectDefConstraint(ECStragglerTreeID, avoidClearing);
   rmAddObjectDefConstraint(ECStragglerTreeID, Eastward);
   rmSetObjectDefMinDistance(ECStragglerTreeID, 10.0);
   rmSetObjectDefMaxDistance(ECStragglerTreeID, longSide*0.5);
   rmPlaceObjectDefInArea(ECStragglerTreeID, 0, rmAreaID("east snow base"), cNumberNonGaiaPlayers*5);
   rmPlaceObjectDefInArea(ECStragglerTreeID, 0, rmAreaID("east snow base 2"), cNumberNonGaiaPlayers*5);

   int WestStragglerTreeID=rmCreateObjectDef("stragglers in west");
   rmAddObjectDefItem(WestStragglerTreeID, "TreeSpruce", 1, 0.0);
   rmAddObjectDefConstraint(WestStragglerTreeID, avoidAll);
   rmAddObjectDefConstraint(WestStragglerTreeID, avoidKOTH);
   rmAddObjectDefConstraint(WestStragglerTreeID, avoidCoin);
   rmAddObjectDefConstraint(WestStragglerTreeID, patchConstraint);
   rmAddObjectDefConstraint(WestStragglerTreeID, avoidBarrier);
   rmAddObjectDefConstraint(WestStragglerTreeID, avoidBaseMed);
   rmAddObjectDefConstraint(WestStragglerTreeID, avoidClearing);
   rmAddObjectDefConstraint(WestStragglerTreeID, Westward);
   rmPlaceObjectDefInArea(WestStragglerTreeID, 0, rmAreaID("west green base"), cNumberNonGaiaPlayers*5);

   // Text
   rmSetStatusText("",0.95);

// Deco
   int avoidEagles=rmCreateTypeDistanceConstraint("avoids Eagles", "EaglesNest", 50.0);
   int randomEagleTreeID=rmCreateObjectDef("random eagle tree");
   rmAddObjectDefItem(randomEagleTreeID, "EaglesNest", 1, 0.0);
   rmAddObjectDefConstraint(randomEagleTreeID, avoidAll);
   rmAddObjectDefConstraint(randomEagleTreeID, avoidKOTH);
   rmAddObjectDefConstraint(randomEagleTreeID, avoidMtsShort);
   rmAddObjectDefConstraint(randomEagleTreeID, avoidClearing);
   rmAddObjectDefConstraint(randomEagleTreeID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(randomEagleTreeID, avoidEagles);
   rmPlaceObjectDefInArea(randomEagleTreeID, 0, rmAreaID("east snow base"), 2);
   rmPlaceObjectDefInArea(randomEagleTreeID, 0, rmAreaID("mountain tree section"), rmRandInt(1,2));

   int avoidProp=rmCreateTypeDistanceConstraint("avoids prop", "PropKingfisher", 70.0);
   int specialPropID=rmCreateObjectDef("kingfisher prop");
   rmAddObjectDefItem(specialPropID, "PropKingfisher", 1, 0.0);
   rmAddObjectDefConstraint(specialPropID, avoidAll);
   rmAddObjectDefConstraint(specialPropID, avoidKOTH);
   rmAddObjectDefConstraint(specialPropID, avoidBaseMed);
   rmAddObjectDefConstraint(specialPropID, avoidProp);
   rmAddObjectDefConstraint(specialPropID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(specialPropID, avoidImportantItem);
   rmPlaceObjectDefInArea(specialPropID, 0, rmAreaID("west green base"), 2);

   int GiantBuddhaID=rmCreateObjectDef("GiantBuddha prop");
   rmAddObjectDefItem(GiantBuddhaID, "GiantBuddhaProp", 1, 0.0);
   rmAddObjectDefConstraint(GiantBuddhaID, avoidAll);
   rmAddObjectDefConstraint(GiantBuddhaID, avoidKOTH);
   rmAddObjectDefConstraint(GiantBuddhaID, avoidBaseMed);
   rmAddObjectDefConstraint(GiantBuddhaID, avoidProp);
   rmAddObjectDefConstraint(GiantBuddhaID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(GiantBuddhaID, avoidImportantItem);
   rmAddObjectDefConstraint(GiantBuddhaID, avoidTradeRoute);
   rmPlaceObjectDefInArea(GiantBuddhaID, 0, rmAreaID("west green base"), 1);



   // Text
   rmSetStatusText("",0.99);
} 
