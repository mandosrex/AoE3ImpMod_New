// Appalachians
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
   string cliffType = "";
   string forestType = "";
   string treeType = "";
   string deerType = "";
   string deer2Type = "";
   string sheepType = "";
   string centerHerdType = "";

// Set up for natives to appear on the map
   int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;
   int subCiv3=-1;

   if (rmAllocateSubCivs(4) == true)
   {
	subCiv0=rmGetCivID("Seminoles");
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Seminoles");

	subCiv1=rmGetCivID("Huron");
      if (subCiv1 >= 0)
         rmSetSubCiv(1, "Huron"); 

	subCiv2=rmGetCivID("Nootka");
      if (subCiv2 >= 0)
         rmSetSubCiv(2, "Nootka");

	subCiv3=rmGetCivID("Cherokee");
      if (subCiv3 >= 0)
         rmSetSubCiv(3, "Cherokee");
   }

// Pick pattern for trees, terrain, features, etc.
   int patternChance = rmRandInt(1,2);   
   int variantChance = rmRandInt(1,2);
   int lightingChance = rmRandInt(1,2);
   int axisChance = rmRandInt(1,2);
   int playerSide = rmRandInt(1,2);   
   int distChance = rmRandInt(1,3);
   int sectionChance = rmRandInt(1,3);
   int ffaChance = rmRandInt(1,2);
   int trPattern = 0;
   int socketPattern = rmRandInt(1,2);
   int socketPattern2 = rmRandInt(1,2);
   int nativeSetup = rmRandInt(1,9);
   int barrierPattern = rmRandInt(1,5);
   if (barrierPattern < 3)
	trPattern = 2;
   else
 	trPattern = 1;
   int segmentPattern = rmRandInt(1,4);
   int gapPattern = rmRandInt(1,3);
   int gapPattern2 = rmRandInt(1,3);
   int nativePattern = rmRandInt(1,6);
   int endPosition = rmRandInt(1,3);
   int sidePosition = 1;
   if (cNumberNonGaiaPlayers > 3)
	sidePosition = rmRandInt(1,3);	   
   int sheepChance = rmRandInt(1,2);
   int placeBerries = 1;
   int forestDist = rmRandInt(10,15);

// Picks the map size
   int playerTiles=18000;  
   if (cNumberNonGaiaPlayers > 2)
	playerTiles = 17000;  
   else if (cNumberNonGaiaPlayers > 4)
	playerTiles = 16000;  
   else if (cNumberNonGaiaPlayers > 6)
	playerTiles = 15000; 

   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

// Elevation
   rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);
   rmSetMapElevationHeightBlend(1.0);
   rmSetSeaLevel(0.0);
	
// Pick terrain patterns and features 
   if (patternChance == 1) // carolina
   {
      rmSetMapType("carolina");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("312b_washington");
	else
	   rmSetLightingSet("carolina");
      baseType = "carolina_grass";
	forestType = "Carolina Inland";
      cliffType = "Carolina Inland";
	treeType = "TreeRockies";
      if (variantChance == 1)
	{
         deerType = "deer";
         deer2Type = "turkey";
         centerHerdType = "deer";
	}
      else 
	{     
         deerType = "deer";
         deer2Type = "deer";
         centerHerdType = "turkey";        
	}   
      if (sheepChance == 1)
         sheepType = "cow";
      else
         sheepType = "sheep";
   }
   else if (patternChance == 2) // great lakes winter
   {
      rmSetMapType("greatlakes");
      rmSetMapType("snow");
	if (lightingChance == 1)
	   rmSetLightingSet("308b_caribbeanlight");
	else
         rmSetLightingSet("Great Lakes Winter");
      baseType = "greatlakes_snow";
	forestType = "great lakes forest snow";
      cliffType = "rocky mountain2";
	treeType = "TreeGreatLakesSnow";
      if (variantChance == 1)
	{
         deerType = "deer";
         deer2Type = "turkey";
         centerHerdType = "elk";
	}
      else 
	{     
         deerType = "deer";
         deer2Type = "elk";
         centerHerdType = "moose";       
	}      
      if (sheepChance == 1)
         sheepType = "cow";
      else
         sheepType = "sheep";
      placeBerries = 0;
   }

   rmSetBaseTerrainMix(baseType);
   rmTerrainInitialize("yukon\ground1_yuk", 1);
   rmEnableLocalWater(false);
   rmSetMapType("land");
   rmSetMapType("namerica");
   rmSetWorldCircleConstraint(true);
   rmSetWindMagnitude(2.0);

// Precipitation
   if (patternChance == 2) // great lakes winter
      rmSetGlobalSnow( 0.7 );
   
   chooseMercs();

// Define some classes.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classHill");
   rmDefineClass("classPatch");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
   rmDefineClass("center");
   rmDefineClass("classNugget");
   rmDefineClass("socketClass");
   int classCliff=rmDefineClass("classCliff");
   int classHuntable=rmDefineClass("huntableFood");   
   int classHerdable=rmDefineClass("herdableFood"); 

   // Text
   rmSetStatusText("",0.10);

// -------------Define constraints
   // Map edge constraints
   int tinyEdgeConstraint=rmCreateBoxConstraint("near the edge of map", rmXTilesToFraction(11), rmZTilesToFraction(11), 1.0-rmXTilesToFraction(11), 1.0-rmZTilesToFraction(11), 0.01);
   int tinyEdgeConstraint2=rmCreateBoxConstraint("near the edge of map", rmXTilesToFraction(22), rmZTilesToFraction(22), 1.0-rmXTilesToFraction(22), 1.0-rmZTilesToFraction(22), 0.01);
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int circleConstraintMt=rmCreatePieConstraint("circle Constraint for mts", 0.5, 0.5, 0, rmZFractionToMeters(0.2), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // Player constraints
   int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 15.0);
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 40.0);
   int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 25.0);
   int nuggetPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 60.0);
   int farPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players more", classPlayer, 85.0);
   int fartherPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players the most", classPlayer, 95.0);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 70.0); 

   // Nature avoidance
   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int shortForestConstraint=rmCreateClassDistanceConstraint("patch vs. forest", rmClassID("classForest"), 15.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), forestDist);
   int longForestConstraint=rmCreateClassDistanceConstraint("long forest vs. forest", rmClassID("classForest"), 26.0);
   int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 20.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 10.0);
   int shortAvoidSilver=rmCreateTypeDistanceConstraint("short gold avoid gold", "Mine", 20.0);
   int coinAvoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 35.0);
   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   int avoidSheep=rmCreateClassDistanceConstraint("sheep avoids sheep etc", rmClassID("herdableFood"), 45.0);
   int huntableConstraint=rmCreateClassDistanceConstraint("huntable constraint", rmClassID("huntableFood"), 35.0);
   int longHuntableConstraint=rmCreateClassDistanceConstraint("long huntable constraint", rmClassID("huntableFood"), 55.0);
   int forestsAvoidBison=rmCreateClassDistanceConstraint("forest avoids bison", rmClassID("huntableFood"), 15.0);

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
   int avoidCliff20=rmCreateClassDistanceConstraint("avoid cliffs 20", rmClassID("classCliff"), 20.0);
   int cliffsAvoidCliffs=rmCreateClassDistanceConstraint("cliffs vs. cliffs", rmClassID("classCliff"), 30.0);
  
   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 10.0);
   int avoidStartingUnitsLarge=rmCreateClassDistanceConstraint("objects avoid starting units large", rmClassID("startingUnit"), 50.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("things avoid each other", rmClassID("importantItem"), 10.0);
   int avoidImportantItemSmall=rmCreateClassDistanceConstraint("important item small avoidance", rmClassID("importantItem"), 7.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 60.0);
   int avoidNativesMed=rmCreateClassDistanceConstraint("stuff avoids natives medium", rmClassID("natives"), 40.0);
   int avoidNativesShort=rmCreateClassDistanceConstraint("stuff avoids natives shorter", rmClassID("natives"), 22.0);
   int avoidNugget=rmCreateClassDistanceConstraint("nugget vs. nugget", rmClassID("classNugget"), 45.0);
   int avoidNuggetMed=rmCreateClassDistanceConstraint("nugget vs. nugget med", rmClassID("classNugget"), 60.0);
   int avoidNuggetLong=rmCreateClassDistanceConstraint("nugget vs. nugget long", rmClassID("classNugget"), 80.0);
   int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 10.0);
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
   int avoidTradeRouteCliff = rmCreateTradeRouteDistanceConstraint("trade route cliff", 10.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);
   int avoidSocket=rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 13.0);

// End of constraints -----------------------------------

// Set up player starting locations

if (cNumberNonGaiaPlayers == 2)
{
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

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.41, 0.42, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.4, 0.41, 0.0);

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

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.41, 0.42, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.4, 0.41, 0.0);
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

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.41, 0.42, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.4, 0.41, 0.0);

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

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.41, 0.42, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.4, 0.41, 0.0);
   }
}   
else 
{ 
   if (cNumberTeams == 2)
   {
      if (cNumberNonGaiaPlayers == 4) // 2 teams, 4 players 
      {
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
             rmSetPlacementSection(0.19, 0.31);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.18, 0.32);

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.44, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.43, 0.44, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);

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
             rmSetPlacementSection(0.69, 0.81);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.68, 0.82);   

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.44, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.43, 0.44, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
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
             rmSetPlacementSection(0.44, 0.56);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.43, 0.57);

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.44, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.43, 0.44, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);

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
             rmSetPlacementSection(0.94, 0.06);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.93, 0.07);

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.44, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.43, 0.44, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
        } 
      }
      else if (cNumberNonGaiaPlayers <7) // for 2 teams, for 3 or 5-6 players
      {
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

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.44, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.43, 0.44, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);

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

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.44, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.43, 0.44, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
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

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.44, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.43, 0.44, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);

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

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.44, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.43, 0.44, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
        }
      }
      else  // for 2 teams, for over 6 players
      {
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
             rmSetPlacementSection(0.12, 0.38);

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.44, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.43, 0.44, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);

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
             rmSetPlacementSection(0.62, 0.88);

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.44, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.43, 0.44, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
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
             rmSetPlacementSection(0.37, 0.63);

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.44, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.43, 0.44, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);

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
             rmSetPlacementSection(0.87, 0.13);

 	    if (distChance == 1)
	       rmPlacePlayersCircular(0.44, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.43, 0.44, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.42, 0.43, 0.0);
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
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.74, 0.75);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
		else if (ffaChance == 2)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.20, 0.21);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
	   }
	   else if (axisChance == 2)
	   {
		if (ffaChance == 1)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.00, 0.01);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
		else if (ffaChance == 2)
            { 
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.49, 0.50);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
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
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
		else if (ffaChance == 2)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
	   }
	   else if (axisChance == 2)
	   {
		if (ffaChance == 1)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
		else if (ffaChance == 2)
            { 
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
            }
	   }
      }
      else if (cNumberNonGaiaPlayers == 5) 
      {
	   if (axisChance == 1)
	   {
		if (ffaChance == 1)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.75, 0.76);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
		else if (ffaChance == 2)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.25, 0.26);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
	   }
	   else if (axisChance == 2)
	   {
		if (ffaChance == 1)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.50, 0.51);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
		else if (ffaChance == 2)
            { 
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.00, 0.01);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
            }
	   }
      }
      else if (cNumberNonGaiaPlayers == 6) 
      {
	   if (axisChance == 1)
	   {
		if (ffaChance == 1)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.75, 0.76);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(5);
		   rmSetPlacementSection(0.25, 0.26);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
		else if (ffaChance == 2)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.25, 0.26);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.75, 0.76);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(5);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
	   }
	   else if (axisChance == 2)
	   {
		if (ffaChance == 1)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.50, 0.51);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(5);
		   rmSetPlacementSection(0.00, 0.01);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
		else if (ffaChance == 2)
            { 
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.00, 0.01);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.50, 0.51);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(5);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
            }
	   }
      }
      else if (cNumberNonGaiaPlayers == 7) 
      {
	   if (axisChance == 1)
	   {
		if (ffaChance == 1)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.20, 0.21);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.29, 0.30);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(5);
		   rmSetPlacementSection(0.75, 0.76);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(6);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
		else if (ffaChance == 2)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.25, 0.26);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.79, 0.80);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(5);
		   rmSetPlacementSection(0.70, 0.71);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(6);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
	   }
	   else if (axisChance == 2)
	   {
		if (ffaChance == 1)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.95, 0.96);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.04, 0.05);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(5);
		   rmSetPlacementSection(0.50, 0.51);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(6);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
		else if (ffaChance == 2)
            { 
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.54, 0.55);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.45, 0.46);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(5);
		   rmSetPlacementSection(0.00, 0.01);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(6);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
            }
	   }
	}
      else if (cNumberNonGaiaPlayers == 8) 
      {
	   if (axisChance == 1)
	   {
		if (ffaChance == 1)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.70, 0.71);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.20, 0.21);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(5);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(6);
		   rmSetPlacementSection(0.79, 0.80);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(7);
		   rmSetPlacementSection(0.29, 0.30);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
		else if (ffaChance == 2)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.70, 0.71);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(5);
		   rmSetPlacementSection(0.29, 0.30);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(6);
		   rmSetPlacementSection(0.79, 0.80);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(7);
		   rmSetPlacementSection(0.20, 0.21);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
	   }
	   else if (axisChance == 2)
	   {
		if (ffaChance == 1)
		{
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.54, 0.55);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.45, 0.46);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(5);
		   rmSetPlacementSection(0.95, 0.96);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(6);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(7);
		   rmSetPlacementSection(0.04, 0.05);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
		}
		else if (ffaChance == 2)
            { 
   		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.04, 0.05);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.37, 0.38);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(2);
		   rmSetPlacementSection(0.12, 0.13);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(3);
		   rmSetPlacementSection(0.87, 0.88);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(4);
		   rmSetPlacementSection(0.54, 0.55);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(5);
		   rmSetPlacementSection(0.44, 0.45);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(6);
		   rmSetPlacementSection(0.95, 0.96);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);

   		   rmSetPlacementTeam(7);
		   rmSetPlacementSection(0.62, 0.63);
		   rmPlacePlayersCircular(0.43, 0.44, 0.0);
            }
	   }
      }
   }
}

   // Text
   rmSetStatusText("",0.20);
	
// Set up player areas.
   float playerFraction=rmAreaTilesToFraction(50);
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
   rmSetStatusText("",0.30);


// Trade Routes
if (trPattern == 2)  // two 'diagonal', for central range version
{
   int tradeRouteID4 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.68, 1.0);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.65, 0.65);
	if(variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.69, 0.55);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.69, 0.45);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.71, 0.54);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.71, 0.46);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.65, 0.35);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.68, 0.0);
   }
   else if (axisChance == 2)  
   {
	rmAddTradeRouteWaypoint(tradeRouteID4, 1.0, 0.68);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.65, 0.65);
	if(variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.54, 0.69);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.46, 0.69);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.56, 0.71);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.44, 0.71);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.35, 0.65);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.0, 0.68);
   }
   rmBuildTradeRoute(tradeRouteID4, "carolinas\trade_route");

   int tradeRouteID4A = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 1.0);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.35, 0.65);
	if(variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.31, 0.55);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.31, 0.45);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.29, 0.55);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.29, 0.45);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.35, 0.35);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 0.0);
   }
   else if (axisChance == 2) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID4A, 1.0, 0.33);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.65, 0.35);
	if(variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.55, 0.31);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.45, 0.31);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.55, 0.29);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.45, 0.29);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.35, 0.35);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.0, 0.33);
   }
   rmBuildTradeRoute(tradeRouteID4A, "dirt");
}
else if (trPattern == 1)  // one diagonal, for central valley version
{
   int tradeRouteID6 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.52, 0.0);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.48, 0.19);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.5, 0.35);
	if(variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID6, 0.48, 0.45);
	   rmAddTradeRouteWaypoint(tradeRouteID6, 0.48, 0.55);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID6, 0.52, 0.45);
	   rmAddTradeRouteWaypoint(tradeRouteID6, 0.52, 0.55);
	}
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.5, 0.65);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.52, 0.81);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.48, 1.0);
   }
   else
   {
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.0, 0.52);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.2, 0.48);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.35, 0.5);
	if(variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID6, 0.45, 0.52);
	   rmAddTradeRouteWaypoint(tradeRouteID6, 0.55, 0.52);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID6, 0.45, 0.48);
	   rmAddTradeRouteWaypoint(tradeRouteID6, 0.55, 0.48);
	}
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.65, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.8, 0.52);
	rmAddTradeRouteWaypoint(tradeRouteID6, 1.0, 0.48);
   }
   rmBuildTradeRoute(tradeRouteID6, "carolinas\trade_route");	
}

// Trade sockets
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 6.0);

if (trPattern == 2) //  2 diagonal, central mountain pattern
{
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID4);

   if (socketPattern == 1)
   {
	if(socketPattern2 == 1)
	{ 
         vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.12);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.5);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.88);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else
	{ 
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.23);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.5);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.77);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }
   else
   {
	if(socketPattern2 == 1)
	{	
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.17);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.83);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else
	{
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.31);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.69);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }

   // change the trade route for the new sockets
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID4A);
   if (socketPattern == 1)
   {
	if(socketPattern2 == 1)
	{
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.88);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.5);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
  
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.12);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else
	{
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.77);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.5);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
  
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.23);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}	
   }
   else
   {
	if(socketPattern2 == 1)
	{
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.83);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.17);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else
	{
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.69);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.31);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }
}
else if(trPattern == 1) // one diagonal
{
   if (socketPattern == 1)
   {
	if (socketPattern2 == 1)
	{
         rmSetObjectDefTradeRouteID(socketID, tradeRouteID6);
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.1);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.35);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.65);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.9);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else
	{
         rmSetObjectDefTradeRouteID(socketID, tradeRouteID6);
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.15);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.38);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.62);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.85);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }
   else if (socketPattern == 2)
   {
      if (cNumberNonGaiaPlayers > 4) 
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
	else
	{
	   if (socketPattern2 == 1)
	   {
   	      rmSetObjectDefTradeRouteID(socketID, tradeRouteID6);
            socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.16);
            rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

            socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.5);
            rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

            socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.84);
            rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	   }
	   else
	   {
   	      rmSetObjectDefTradeRouteID(socketID, tradeRouteID6);
            socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.24);
            rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

            socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.5);
            rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

            socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.76);
            rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	   }
	}
   }
}

   //Text
   rmSetStatusText("",0.35);

// Barrier mts 

if (barrierPattern == 1)  // Center 1 part barrier range
{
   int barrierCID=rmCreateArea("barrier center single"); 
   rmSetAreaWarnFailure(barrierCID, false);
   rmSetAreaCliffType(barrierCID, cliffType);
   rmAddAreaToClass(barrierCID, rmClassID("classCliff"));
   rmAddAreaConstraint(barrierCID, mediumPlayerConstraint); 
   rmAddAreaConstraint(barrierCID, avoidCliff20);
   rmAddAreaConstraint(barrierCID, avoidTradeRouteCliff);
   rmAddAreaConstraint(barrierCID, tinyEdgeConstraint);
   if (cNumberNonGaiaPlayers > 6) 
      rmSetAreaSize(barrierCID, 0.085, 0.09);
   else if (cNumberNonGaiaPlayers > 3) 
      rmSetAreaSize(barrierCID, 0.092, 0.1);
   else
      rmSetAreaSize(barrierCID, 0.11, 0.115);
   rmSetAreaLocation(barrierCID, 0.5, 0.5);
   if (axisChance == 1) 
      rmAddAreaInfluenceSegment(barrierCID, 0.5, 0.08, 0.5, 0.92); 
   else
      rmAddAreaInfluenceSegment(barrierCID, 0.08, 0.5, 0.92, 0.5); 
   if (rmRandInt(1,2) == 1)
      rmSetAreaCliffEdge(barrierCID, 4, 0.235, 0.05, 0.6, 0);
   else
      rmSetAreaCliffEdge(barrierCID, 5, 0.19, 0.05, 0.6, 0);
   rmSetAreaMinBlobs(barrierCID, 5);
   rmSetAreaMaxBlobs(barrierCID, 7);
   rmSetAreaMinBlobDistance(barrierCID, 20.0);
   rmSetAreaMaxBlobDistance(barrierCID, 30.0);
   rmSetAreaCliffPainting(barrierCID, false, true, true, 1.5, true);
   rmSetAreaCliffHeight(barrierCID, rmRandInt(7,8), 1.0, 1.0);
   rmSetAreaCoherence(barrierCID, 0.8);
   rmSetAreaSmoothDistance(barrierCID, 5);
   rmSetAreaHeightBlend(barrierCID, 2);
   rmBuildArea(barrierCID);
}
else if (barrierPattern == 2)   // Center 2 part barrier range 
{
   int barrier1ID=rmCreateArea("barrier 1"); // south mt
   rmSetAreaWarnFailure(barrier1ID, false); 
   rmSetAreaCliffType(barrier1ID, cliffType);
   rmAddAreaToClass(barrier1ID, rmClassID("classCliff"));
   rmAddAreaConstraint(barrier1ID, mediumPlayerConstraint); 
   rmAddAreaConstraint(barrier1ID, avoidCliff20);
   rmAddAreaConstraint(barrier1ID, avoidTradeRouteCliff);
   rmAddAreaConstraint(barrier1ID, tinyEdgeConstraint);
   if (gapPattern == 1)
   {
      if (cNumberNonGaiaPlayers > 6) 
         rmSetAreaSize(barrier1ID, 0.039, 0.041);
	else  if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrier1ID, 0.05, 0.055);
      else
         rmSetAreaSize(barrier1ID, 0.042, 0.045);
      if (axisChance == 1)
      { 
         rmSetAreaLocation(barrier1ID, 0.5, 0.25);
         rmAddAreaInfluenceSegment(barrier1ID, 0.5, 0.09, 0.5, 0.51);
	}
	else
	{
         rmSetAreaLocation(barrier1ID, 0.25, 0.5);
         rmAddAreaInfluenceSegment(barrier1ID, 0.09, 0.5, 0.51, 0.5);
	}
      rmSetAreaCliffEdge(barrier1ID, 3, 0.325, 0.05, 1.0, 0); 
   }
   else if (gapPattern == 2)
   {
	endPosition = rmRandInt(2,3);
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrier1ID, 0.03, 0.033);
	else
         rmSetAreaSize(barrier1ID, 0.026, 0.028);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrier1ID, 0.5, 0.16);
         rmAddAreaInfluenceSegment(barrier1ID, 0.5, 0.09, 0.5, 0.26);
	}
	else
	{
         rmSetAreaLocation(barrier1ID, 0.16, 0.5);
         rmAddAreaInfluenceSegment(barrier1ID, 0.09, 0.5, 0.26, 0.5);
	}
      rmSetAreaCliffEdge(barrier1ID, 2, 0.47, 0.05, 1.0, 1); 
   }
   else if (gapPattern == 3)
   {
	endPosition = rmRandInt(2,3);
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrier1ID, 0.092, 0.096);
      else if (cNumberNonGaiaPlayers > 6) 
         rmSetAreaSize(barrier1ID, 0.075, 0.079); 
	else
         rmSetAreaSize(barrier1ID, 0.082, 0.086);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrier1ID, 0.5, 0.25);
         rmAddAreaInfluenceSegment(barrier1ID, 0.5, 0.09, 0.5, 0.71);
	}
	else
	{
         rmSetAreaLocation(barrier1ID, 0.25, 0.5);
         rmAddAreaInfluenceSegment(barrier1ID, 0.09, 0.5, 0.71, 0.5);
	}
	if (rmRandInt(1,2) == 1)
         rmSetAreaCliffEdge(barrier1ID, 4, 0.235, 0.05, 1.0, 0);
	else
         rmSetAreaCliffEdge(barrier1ID, 3, 0.325, 0.05, 1.0, 0); 
   }
   rmSetAreaMinBlobs(barrier1ID, 3);
   rmSetAreaMaxBlobs(barrier1ID, 5);
   rmSetAreaMinBlobDistance(barrier1ID, 10.0);
   rmSetAreaMaxBlobDistance(barrier1ID, 14.0);
   rmSetAreaCliffPainting(barrier1ID, false, true, true, 1.5, true);
   rmSetAreaCliffHeight(barrier1ID, rmRandInt(7,8), 1.0, 1.0);
   rmSetAreaCoherence(barrier1ID, 0.9);
   rmSetAreaSmoothDistance(barrier1ID, 5);
   rmSetAreaHeightBlend(barrier1ID, 2);

   int barrier2ID=rmCreateArea("barrier 2"); // north mt
   rmSetAreaWarnFailure(barrier2ID, false); 
   rmSetAreaCliffType(barrier2ID, cliffType);
   rmAddAreaToClass(barrier2ID, rmClassID("classCliff"));
   rmAddAreaConstraint(barrier2ID, mediumPlayerConstraint); 
   rmAddAreaConstraint(barrier2ID, avoidCliff20);
   rmAddAreaConstraint(barrier2ID, avoidTradeRouteCliff);
   rmAddAreaConstraint(barrier2ID, tinyEdgeConstraint);
   if (gapPattern == 1)
   {
      if (cNumberNonGaiaPlayers > 6) 
         rmSetAreaSize(barrier2ID, 0.038, 0.04);
	else  if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrier2ID, 0.05, 0.055);
      else
         rmSetAreaSize(barrier2ID, 0.042, 0.045);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrier2ID, 0.5, 0.75);
         rmAddAreaInfluenceSegment(barrier2ID, 0.5, 0.91, 0.5, 0.49);
	}
	else
	{
         rmSetAreaLocation(barrier2ID, 0.75, 0.5);
         rmAddAreaInfluenceSegment(barrier2ID, 0.91, 0.5, 0.49, 0.5);
	}
      rmSetAreaCliffEdge(barrier2ID, 3, 0.325, 0.05, 0.6, 0); 
   }
   else if (gapPattern == 2)
   {
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrier2ID, 0.092, 0.096);
      else if (cNumberNonGaiaPlayers > 6) 
         rmSetAreaSize(barrier2ID, 0.075, 0.079); 
	else
         rmSetAreaSize(barrier2ID, 0.082, 0.086);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrier2ID, 0.5, 0.75);
         rmAddAreaInfluenceSegment(barrier2ID, 0.5, 0.91, 0.5, 0.29);
	}
	else
	{
         rmSetAreaLocation(barrier2ID, 0.55, 0.5);
         rmAddAreaInfluenceSegment(barrier2ID, 0.91, 0.5, 0.29, 0.5);
	}
	if (rmRandInt(1,2) == 1)
         rmSetAreaCliffEdge(barrier2ID, 4, 0.235, 0.05, 1.0, 0);
	else
         rmSetAreaCliffEdge(barrier2ID, 3, 0.325, 0.05, 0.6, 0); 
   }
   else if (gapPattern == 3)
   {
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrier2ID, 0.032, 0.035);
	else
         rmSetAreaSize(barrier2ID, 0.026, 0.029);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrier2ID, 0.5, 0.84);
         rmAddAreaInfluenceSegment(barrier2ID, 0.5, 0.91, 0.5, 0.72);
	}
	else
	{
         rmSetAreaLocation(barrier2ID, 0.84, 0.5);
         rmAddAreaInfluenceSegment(barrier2ID, 0.91, 0.5, 0.72, 0.5);
	}
      rmSetAreaCliffEdge(barrier2ID, 2, 0.47, 0.05, 1.0, 1); 
   }
   rmSetAreaMinBlobs(barrier2ID, 4);
   rmSetAreaMaxBlobs(barrier2ID, 8);
   rmSetAreaMinBlobDistance(barrier2ID, 10.0);
   rmSetAreaMaxBlobDistance(barrier2ID, 14.0);
   rmSetAreaCliffPainting(barrier2ID, false, true, true, 1.5, true);
   rmSetAreaCliffHeight(barrier2ID, rmRandInt(7,8), 0.5, 1.0);
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
}
else if (barrierPattern > 3)  // East and West 2-section barrier ranges
{
   int barrierS1ID=rmCreateArea("barrier south 1"); // E south
   rmSetAreaWarnFailure(barrierS1ID, false); 
   rmSetAreaCliffType(barrierS1ID, cliffType);
   rmAddAreaToClass(barrierS1ID, rmClassID("classCliff"));
   rmAddAreaConstraint(barrierS1ID, mediumPlayerConstraint); 
   rmAddAreaConstraint(barrierS1ID, avoidCliffs);
   rmAddAreaConstraint(barrierS1ID, avoidTradeRouteCliff);
   rmAddAreaConstraint(barrierS1ID, tinyEdgeConstraint2);
   if (gapPattern == 1)
   {
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrierS1ID, 0.052, 0.055);
	else
         rmSetAreaSize(barrierS1ID, 0.05, 0.05);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrierS1ID, 0.32, 0.25);
         rmAddAreaInfluenceSegment(barrierS1ID, 0.32, 0.15, 0.32, 0.5);
      }
	  else
      {
         rmSetAreaLocation(barrierS1ID, 0.25, 0.32);
         rmAddAreaInfluenceSegment(barrierS1ID, 0.15, 0.32, 0.5, 0.32);
      }
      rmSetAreaCliffEdge(barrierS1ID, 3, 0.325, 0.05, 1.0, 0); 
   }
   else if (gapPattern == 2)
   {
	endPosition = rmRandInt(2,3);
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrierS1ID, 0.03, 0.033);
	  else
         rmSetAreaSize(barrierS1ID, 0.026, 0.028);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrierS1ID, 0.32, 0.16);
         rmAddAreaInfluenceSegment(barrierS1ID, 0.32, 0.16, 0.32, 0.26);
      }
      else
      {
         rmSetAreaLocation(barrierS1ID, 0.16, 0.32);
         rmAddAreaInfluenceSegment(barrierS1ID, 0.16, 0.32, 0.26, 0.32);
      }
      rmSetAreaCliffEdge(barrierS1ID, 2, 0.47, 0.05, 1.0, 1); 
   }
   else if (gapPattern == 3)
   {
      endPosition = rmRandInt(2,3);
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrierS1ID, 0.09, 0.094);
      else if (cNumberNonGaiaPlayers > 6) 
         rmSetAreaSize(barrierS1ID, 0.075, 0.079); 
      else
         rmSetAreaSize(barrierS1ID, 0.082, 0.086);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrierS1ID, 0.32, 0.35);
         rmAddAreaInfluenceSegment(barrierS1ID, 0.32, 0.16, 0.32, 0.69);
      }
      else
      {
         rmSetAreaLocation(barrierS1ID, 0.35, 0.32);
         rmAddAreaInfluenceSegment(barrierS1ID, 0.16, 0.32, 0.69, 0.32);
      }
      if (rmRandInt(1,2) == 1)
         rmSetAreaCliffEdge(barrierS1ID, 4, 0.235, 0.05, 1.0, 0);
      else
         rmSetAreaCliffEdge(barrierS1ID, 3, 0.325, 0.05, 1.0, 0); 
   }
   rmSetAreaMinBlobs(barrierS1ID, 3);
   rmSetAreaMaxBlobs(barrierS1ID, 5);
   rmSetAreaMinBlobDistance(barrierS1ID, 10.0);
   rmSetAreaMaxBlobDistance(barrierS1ID, 14.0);
   rmSetAreaCliffPainting(barrierS1ID, false, true, true, 1.5, true);
   rmSetAreaCliffHeight(barrierS1ID, rmRandInt(7,8), 1.0, 1.0);
   rmSetAreaCoherence(barrierS1ID, 0.8);
   rmSetAreaSmoothDistance(barrierS1ID, 5);
   rmSetAreaHeightBlend(barrierS1ID, 2);
 
   int barrierN1ID=rmCreateArea("barrier north 1"); // E north
   rmSetAreaWarnFailure(barrierN1ID, false); 
   rmSetAreaCliffType(barrierN1ID, cliffType);
   rmAddAreaToClass(barrierN1ID, rmClassID("classCliff"));
   rmAddAreaConstraint(barrierN1ID, tinyEdgeConstraint2);
   rmAddAreaConstraint(barrierN1ID, mediumPlayerConstraint); 
   rmAddAreaConstraint(barrierN1ID, avoidCliff20);
   rmAddAreaConstraint(barrierN1ID, avoidTradeRouteCliff);
   if (gapPattern == 1)
   {
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrierN1ID, 0.052, 0.055);
      else
         rmSetAreaSize(barrierN1ID, 0.05, 0.05);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrierN1ID, 0.32, 0.75);
         rmAddAreaInfluenceSegment(barrierN1ID, 0.32, 0.84, 0.32, 0.5);
      }
	else
	{
         rmSetAreaLocation(barrierN1ID, 0.75, 0.32);
         rmAddAreaInfluenceSegment(barrierN1ID, 0.84, 0.32, 0.5, 0.32);
	}
      rmSetAreaCliffEdge(barrierN1ID, 3, 0.325, 0.05, 0.6, 0); 
   }
   else if (gapPattern == 2)
   {
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrierN1ID, 0.09, 0.094);
      else if (cNumberNonGaiaPlayers > 6) 
         rmSetAreaSize(barrierN1ID, 0.075, 0.079); 
	else
         rmSetAreaSize(barrierN1ID, 0.082, 0.086);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrierN1ID, 0.32, 0.7);
         rmAddAreaInfluenceSegment(barrierN1ID, 0.32, 0.84, 0.32, 0.29);
	}
	else
	{
         rmSetAreaLocation(barrierN1ID, 0.7, 0.32);
         rmAddAreaInfluenceSegment(barrierN1ID, 0.84, 0.32, 0.29, 0.32);
	}
	if (rmRandInt(1,2) == 1)
         rmSetAreaCliffEdge(barrierN1ID, 4, 0.235, 0.05, 1.0, 0);
	else
         rmSetAreaCliffEdge(barrierN1ID, 3, 0.325, 0.05, 0.6, 0); 
   }
   else if (gapPattern == 3)
   {
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrierN1ID, 0.03, 0.033);
	else
         rmSetAreaSize(barrierN1ID, 0.026, 0.029);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrierN1ID, 0.32, 0.84);
         rmAddAreaInfluenceSegment(barrierN1ID, 0.32, 0.84, 0.32, 0.74);
	}
	else
	{
         rmSetAreaLocation(barrierN1ID, 0.84, 0.32);
         rmAddAreaInfluenceSegment(barrierN1ID, 0.84, 0.32, 0.74, 0.32);
	}
      rmSetAreaCliffEdge(barrierN1ID, 2, 0.47, 0.05, 1.0, 1); 
   }
   rmSetAreaMinBlobs(barrierN1ID, 4);
   rmSetAreaMaxBlobs(barrierN1ID, 8);
   rmSetAreaMinBlobDistance(barrierN1ID, 10.0);
   rmSetAreaMaxBlobDistance(barrierN1ID, 14.0);
   rmSetAreaCliffPainting(barrierN1ID, false, true, true, 1.5, true);
   rmSetAreaCliffHeight(barrierN1ID, rmRandInt(7,8), 0.5, 1.0);
   rmSetAreaCoherence(barrierN1ID, 0.9);
   rmSetAreaSmoothDistance(barrierN1ID, 5);
   rmSetAreaHeightBlend(barrierN1ID, 2);
   if (gapPattern == 3)
   {
      rmBuildArea(barrierN1ID);
      rmBuildArea(barrierS1ID);
   }
   else if (gapPattern == 2)
   {
      rmBuildArea(barrierS1ID);
      rmBuildArea(barrierN1ID);
   }
   else if (gapPattern == 1)
   {
      if (rmRandInt(1,2) == 1)
      {
         rmBuildArea(barrierN1ID);
         rmBuildArea(barrierS1ID);
      }
      else 
      {
         rmBuildArea(barrierS1ID);
         rmBuildArea(barrierN1ID);
      }
   }

   // Second mt
   int barrierS2ID=rmCreateArea("barrier south 2"); // south
   rmSetAreaWarnFailure(barrierS2ID, false); 
   rmSetAreaCliffType(barrierS2ID, cliffType);
   rmAddAreaToClass(barrierS2ID, rmClassID("classCliff"));
   rmAddAreaConstraint(barrierS2ID, tinyEdgeConstraint2);
   rmAddAreaConstraint(barrierS2ID, mediumPlayerConstraint); 
   rmAddAreaConstraint(barrierS2ID, avoidCliffs);
   rmAddAreaConstraint(barrierS2ID, avoidTradeRouteCliff);
   if (gapPattern2 == 1)
   {
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrierS2ID, 0.052, 0.055);
	else
         rmSetAreaSize(barrierS2ID, 0.05, 0.05);
      if (axisChance == 1)
      {			
         rmSetAreaLocation(barrierS2ID, 0.68, 0.26);
         rmAddAreaInfluenceSegment(barrierS2ID, 0.68, 0.16, 0.68, 0.5);
	}
	else
	{
         rmSetAreaLocation(barrierS2ID, 0.26, 0.68);
         rmAddAreaInfluenceSegment(barrierS2ID, 0.16, 0.68, 0.5, 0.68);
	}
      rmSetAreaCliffEdge(barrierS2ID, 3, 0.325, 0.05, 1.0, 0); 
   }
   else if (gapPattern2 == 2)
   {
	endPosition = rmRandInt(2,3);
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrierS2ID, 0.032, 0.034);
	else
         rmSetAreaSize(barrierS2ID, 0.026, 0.028);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrierS2ID, 0.68, 0.16);
         rmAddAreaInfluenceSegment(barrierS2ID, 0.68, 0.16, 0.68, 0.26);
	}
	else
	{
         rmSetAreaLocation(barrierS2ID, 0.16, 0.68);
         rmAddAreaInfluenceSegment(barrierS2ID, 0.16, 0.68, 0.26, 0.68);
	}
      rmSetAreaCliffEdge(barrierS2ID, 2, 0.47, 0.05, 1.0, 1); 
   }
   else if (gapPattern2 == 3)
   {
	endPosition = rmRandInt(2,3);
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrierS2ID, 0.09, 0.094);
      else if (cNumberNonGaiaPlayers > 6) 
         rmSetAreaSize(barrierS2ID, 0.075, 0.079); 
	else
         rmSetAreaSize(barrierS2ID, 0.082, 0.086);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrierS2ID, 0.68, 0.35);
         rmAddAreaInfluenceSegment(barrierS2ID, 0.68, 0.16, 0.68, 0.71);
	}
	else
	{
         rmSetAreaLocation(barrierS2ID, 0.35, 0.68);
         rmAddAreaInfluenceSegment(barrierS2ID, 0.16, 0.68, 0.71, 0.68);
	}
	if (rmRandInt(1,2) == 1)
         rmSetAreaCliffEdge(barrierS2ID, 4, 0.235, 0.05, 1.0, 0);
	else
         rmSetAreaCliffEdge(barrierS2ID, 3, 0.325, 0.05, 1.0, 0); 
   }
   rmSetAreaMinBlobs(barrierS2ID, 3);
   rmSetAreaMaxBlobs(barrierS2ID, 5);
   rmSetAreaMinBlobDistance(barrierS2ID, 10.0);
   rmSetAreaMaxBlobDistance(barrierS2ID, 14.0);
   rmSetAreaCliffPainting(barrierS2ID, false, true, true, 1.5, true);
   rmSetAreaCliffHeight(barrierS2ID, rmRandInt(7,8), 1.0, 1.0);
   rmSetAreaCoherence(barrierS2ID, 0.9);
   rmSetAreaSmoothDistance(barrierS2ID, 5);
   rmSetAreaHeightBlend(barrierS2ID, 2);

   int barrierN2ID=rmCreateArea("barrier north 2"); // north
   rmSetAreaWarnFailure(barrierN2ID, false); 
   rmSetAreaCliffType(barrierN2ID, cliffType);
   rmAddAreaToClass(barrierN2ID, rmClassID("classCliff"));
   rmAddAreaConstraint(barrierN2ID, mediumPlayerConstraint); 
   rmAddAreaConstraint(barrierN2ID, avoidCliff20);
   rmAddAreaConstraint(barrierN2ID, avoidTradeRouteCliff);
   rmAddAreaConstraint(barrierN2ID, tinyEdgeConstraint2);
   if (gapPattern2 == 1)
   {
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrierN2ID, 0.052, 0.055);
	else
         rmSetAreaSize(barrierN2ID, 0.05, 0.05);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrierN2ID, 0.68, 0.75);
         rmAddAreaInfluenceSegment(barrierN2ID, 0.68, 0.84, 0.68, 0.5);
	}
	else
	{
         rmSetAreaLocation(barrierN2ID, 0.75, 0.68);
         rmAddAreaInfluenceSegment(barrierN2ID, 0.84, 0.68, 0.5, 0.68);
	}
      rmSetAreaCliffEdge(barrierN2ID, 3, 0.325, 0.05, 0.6, 0); 
   }
   else if (gapPattern2 == 2)
   {
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrierN2ID, 0.09, 0.094);
      else if (cNumberNonGaiaPlayers > 6) 
         rmSetAreaSize(barrierN2ID, 0.075, 0.079); 
	else
         rmSetAreaSize(barrierN2ID, 0.082, 0.086);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrierN2ID, 0.68, 0.7);
         rmAddAreaInfluenceSegment(barrierN2ID, 0.68, 0.84, 0.68, 0.29);
	}
	else
	{
         rmSetAreaLocation(barrierN2ID, 0.7, 0.68);
         rmAddAreaInfluenceSegment(barrierN2ID, 0.84, 0.68, 0.29, 0.68);
	}
	if (rmRandInt(1,2) == 1)
         rmSetAreaCliffEdge(barrierN2ID, 4, 0.235, 0.05, 0.5, 0);
	else
         rmSetAreaCliffEdge(barrierN2ID, 3, 0.325, 0.05, 0.6, 0); 
   }
   else if (gapPattern2 == 3)
   {
      if (cNumberNonGaiaPlayers < 4)
         rmSetAreaSize(barrierN2ID, 0.03, 0.032);
	else
         rmSetAreaSize(barrierN2ID, 0.026, 0.029);
      if (axisChance == 1)
      {
         rmSetAreaLocation(barrierN2ID, 0.68, 0.84);
         rmAddAreaInfluenceSegment(barrierN2ID, 0.68, 0.84, 0.68, 0.72);
	}
	else
	{
         rmSetAreaLocation(barrierN2ID, 0.84, 0.68);
         rmAddAreaInfluenceSegment(barrierN2ID, 0.84, 0.68, 0.72, 0.68);
	}
      rmSetAreaCliffEdge(barrierN2ID, 2, 0.47, 0.05, 1.0, 1); 
   }
   rmSetAreaMinBlobs(barrierN2ID, 4);
   rmSetAreaMaxBlobs(barrierN2ID, 8);
   rmSetAreaMinBlobDistance(barrierN2ID, 10.0);
   rmSetAreaMaxBlobDistance(barrierN2ID, 14.0);
   rmSetAreaCliffPainting(barrierN2ID, false, true, true, 1.5, true);
   rmSetAreaCliffHeight(barrierN2ID, rmRandInt(7,8), 0.5, 1.0);
   rmSetAreaCoherence(barrierN2ID, 0.9);
   rmSetAreaSmoothDistance(barrierN2ID, 5);
   rmSetAreaHeightBlend(barrierN2ID, 2);

   if (gapPattern2 == 2)
   {
      rmBuildArea(barrierS2ID);
      rmBuildArea(barrierN2ID);
   }
   else if (gapPattern2 == 3)
   {
      rmBuildArea(barrierN2ID);
      rmBuildArea(barrierS2ID);
   }
   else if (gapPattern2 == 1)
   {
      if (rmRandInt(1,2) == 1)
      {
         rmBuildArea(barrierN2ID);
         rmBuildArea(barrierS2ID);
      }
      else 
      {
         rmBuildArea(barrierS2ID);
         rmBuildArea(barrierN2ID);
      }
   }
}
else if (barrierPattern == 3) // 2 single parallel barrier ranges
{
   int barrierEID=rmCreateArea("barrier east"); 
   rmSetAreaWarnFailure(barrierEID, false); 
   rmSetAreaCliffType(barrierEID, cliffType);
   rmAddAreaToClass(barrierEID, rmClassID("classCliff"));
   rmAddAreaConstraint(barrierEID, mediumPlayerConstraint); 
   rmAddAreaConstraint(barrierEID, avoidCliff20);
   rmAddAreaConstraint(barrierEID, avoidTradeRouteCliff);
   rmAddAreaConstraint(barrierEID, tinyEdgeConstraint2);
   if (cNumberNonGaiaPlayers > 6) 
      rmSetAreaSize(barrierEID, 0.078, 0.082);
   else if (cNumberNonGaiaPlayers > 3) 
      rmSetAreaSize(barrierEID, 0.085, 0.09);
   else
      rmSetAreaSize(barrierEID, 0.1, 0.105);
   if (axisChance == 1)
   {
      rmSetAreaLocation(barrierEID, 0.32, 0.5);
      rmAddAreaInfluenceSegment(barrierEID, 0.32, 0.15, 0.32, 0.85);
   }
   else
   {
      rmSetAreaLocation(barrierEID, 0.5, 0.32);
      rmAddAreaInfluenceSegment(barrierEID, 0.15, 0.32, 0.85, 0.32);
   }
   if (rmRandInt(1,2) == 1) 
      rmSetAreaCliffEdge(barrierEID, 4, 0.23, 0.05, 1.0, 0);
   else
      rmSetAreaCliffEdge(barrierEID, 5, 0.19, 0.05, 1.0, 0);
   rmSetAreaMinBlobs(barrierEID, 10);
   rmSetAreaMaxBlobs(barrierEID, 15);
   rmSetAreaMinBlobDistance(barrierEID, 8.0);
   rmSetAreaMaxBlobDistance(barrierEID, 12.0);
   rmSetAreaCliffPainting(barrierEID, false, true, true, 1.5, true);
   rmSetAreaCliffHeight(barrierEID, rmRandInt(7,8), 1.0, 1.0);
   rmSetAreaCoherence(barrierEID, 0.8);
   rmSetAreaSmoothDistance(barrierEID, 5);
   rmSetAreaHeightBlend(barrierEID, 2);
   rmBuildArea(barrierEID);

   int barrierWID=rmCreateArea("barrier west"); 
   rmSetAreaWarnFailure(barrierWID, false);
   rmSetAreaCliffType(barrierWID, cliffType);
   rmAddAreaToClass(barrierWID, rmClassID("classCliff"));
   rmAddAreaConstraint(barrierWID, mediumPlayerConstraint); 
   rmAddAreaConstraint(barrierWID, avoidCliff20);
   rmAddAreaConstraint(barrierWID, avoidTradeRouteCliff);
   rmAddAreaConstraint(barrierWID, tinyEdgeConstraint2);
   if (cNumberNonGaiaPlayers > 6) 
      rmSetAreaSize(barrierWID, 0.078, 0.082);
   else if (cNumberNonGaiaPlayers > 3) 
      rmSetAreaSize(barrierWID, 0.085, 0.09);
   else
      rmSetAreaSize(barrierWID, 0.1, 0.105);
   if (axisChance == 1)
   {
      rmSetAreaLocation(barrierWID, 0.68, 0.5);
      rmAddAreaInfluenceSegment(barrierWID, 0.68, 0.15, 0.68, 0.85);
   }
   else
   {
      rmSetAreaLocation(barrierWID, 0.5, 0.68);
      rmAddAreaInfluenceSegment(barrierWID, 0.15, 0.68, 0.85, 0.68);
   } 
   if (rmRandInt(1,2) == 1)
      rmSetAreaCliffEdge(barrierWID, 4, 0.23, 0.05, 1.0, 0);
   else
      rmSetAreaCliffEdge(barrierWID, 5, 0.19, 0.05, 1.0, 0);
   rmSetAreaMinBlobs(barrierWID, 10);
   rmSetAreaMaxBlobs(barrierWID, 15);
   rmSetAreaMinBlobDistance(barrierWID, 8.0);
   rmSetAreaMaxBlobDistance(barrierWID, 15.0);
   rmSetAreaCliffPainting(barrierWID, false, true, true, 1.5, true);
   rmSetAreaCliffHeight(barrierWID, rmRandInt(7,8), 1.0, 1.0);
   rmSetAreaCoherence(barrierWID, 0.9);
   rmSetAreaSmoothDistance(barrierWID, 5);
   rmSetAreaHeightBlend(barrierWID, 2);
   rmBuildArea(barrierWID);
}


// Starting TCs and units 		
   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 5.0);
   rmSetObjectDefMaxDistance(startingUnits, 10.0);
   rmAddObjectDefConstraint(startingUnits, avoidAll);

   int startingTCID= rmCreateObjectDef("startingTC");
   rmSetObjectDefMaxDistance(startingTCID, 6.0);
   rmAddObjectDefConstraint(startingTCID, avoidAll);
   rmAddObjectDefConstraint(startingTCID, avoidTradeRoute);
   rmAddObjectDefConstraint(startingTCID, longAvoidImpassableLand );                
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

		if ( rmGetNomadStart())
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
   rmSetStatusText("",0.40);

// NATIVE AMERICANS
   // Village A 
   int villageAID = -1;
   int whichNative = rmRandInt(1,2);
   int villageType = rmRandInt(1,5);

   if (nativePattern == 1)
   {
      if (whichNative == 2)
      {
	villageAID = rmCreateGrouping("village A", "native cherokee village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageAID = rmCreateGrouping("village A", "native huron village "+villageType);
      }
   }

   if (nativePattern == 2)
   {
      if (whichNative == 2)
      {
	villageAID = rmCreateGrouping("village A", "native nootka village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageAID = rmCreateGrouping("village A", "native huron village "+villageType);
      }
   }

   if (nativePattern == 3)
   {
      if (whichNative == 2)
      {
	villageAID = rmCreateGrouping("village A", "native cherokee village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageAID = rmCreateGrouping("village A", "native seminole village "+villageType);
      }
   }

   if (nativePattern == 4)
   {
      if (whichNative == 2)
      {
	villageAID = rmCreateGrouping("village A", "native huron village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageAID = rmCreateGrouping("village A", "native seminole village "+villageType);
      }
   }

   if (nativePattern == 5)
   {
      if (whichNative == 2)
      {
	villageAID = rmCreateGrouping("village A", "native seminole village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageAID = rmCreateGrouping("village A", "native nootka village "+villageType);
      }
   }

   if (nativePattern == 6)
   {
      if (whichNative == 2)
      {
	villageAID = rmCreateGrouping("village A", "native nootka village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageAID = rmCreateGrouping("village A", "native cherokee village "+villageType);
      }
   }
   rmAddGroupingToClass(villageAID, rmClassID("natives"));
   rmAddGroupingToClass(villageAID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageAID, 0.0);
   rmSetGroupingMaxDistance(villageAID, rmXFractionToMeters(0.1));
   rmAddGroupingConstraint(villageAID, avoidImpassableLand);
   rmAddGroupingConstraint(villageAID, avoidTradeRoute);
   rmAddGroupingConstraint(villageAID, avoidNativesShort);
   rmAddGroupingConstraint(villageAID, playerConstraint);

   // Village D - opposite type from A 
   int villageDID = -1;
   villageType = rmRandInt(1,5);

   if (nativePattern == 1)
   {
      if (whichNative == 1)
      {
	villageDID = rmCreateGrouping("village D", "native cherokee village "+villageType);
      }
      else if (whichNative == 2)
      {
	villageDID = rmCreateGrouping("village D", "native huron village "+villageType);
      }
   }

   if (nativePattern == 2)
   {
      if (whichNative == 1)
      {
	villageDID = rmCreateGrouping("village D", "native nootka village "+villageType);
      }
      else if (whichNative == 2)
      {
	villageDID = rmCreateGrouping("village D", "native huron village "+villageType);
      }
   }

   if (nativePattern == 3)
   {
      if (whichNative == 1)
      {
	villageDID = rmCreateGrouping("village D", "native cherokee village "+villageType);
      }
      else if (whichNative == 2)
      {
	villageDID = rmCreateGrouping("village D", "native seminole village "+villageType);
      }
   }

   if (nativePattern == 4)
   {
      if (whichNative == 1)
      {
	villageDID = rmCreateGrouping("village D", "native huron village "+villageType);
      }
      else if (whichNative == 2)
      {
	villageDID = rmCreateGrouping("village D", "native seminole village "+villageType);
      }
   }

   if (nativePattern == 5)
   {
      if (whichNative == 1)
      {
	villageDID = rmCreateGrouping("village D", "native seminole village "+villageType);
      }
      else if (whichNative == 2)
      {
	villageDID = rmCreateGrouping("village D", "native nootka village "+villageType);
      }
   }

   if (nativePattern == 6)
   {
      if (whichNative == 1)
      {
	villageDID = rmCreateGrouping("village D", "native nootka village "+villageType);
      }
      else if (whichNative == 2)
      {
	villageDID = rmCreateGrouping("village D", "native cherokee village "+villageType);
      }
   }
   rmAddGroupingToClass(villageDID, rmClassID("natives"));
   rmAddGroupingToClass(villageDID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageDID, 0.0);
   rmSetGroupingMaxDistance(villageDID, rmXFractionToMeters(0.1));
   rmAddGroupingConstraint(villageDID, avoidImpassableLand);
   rmAddGroupingConstraint(villageDID, avoidTradeRoute);
   rmAddGroupingConstraint(villageDID, avoidNativesShort);
   rmAddGroupingConstraint(villageDID, playerConstraint);

   // Village B - randomly same or opposite village A
   int villageBID = -1;	
   villageType = rmRandInt(1,5);
   whichNative = rmRandInt(1,2);

   if (nativePattern == 1)
   {
      if (whichNative == 2)
      {
	villageBID = rmCreateGrouping("village B", "native cherokee village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageBID = rmCreateGrouping("village B", "native huron village "+villageType);
      }
   }
   if (nativePattern == 2)
   {
      if (whichNative == 2)
      {
	villageBID = rmCreateGrouping("village B", "native nootka village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageBID = rmCreateGrouping("village B", "native huron village "+villageType);
      }
   }
   if (nativePattern == 3)
   {
      if (whichNative == 2)
      {
	villageBID = rmCreateGrouping("village B", "native cherokee village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageBID = rmCreateGrouping("village B", "native seminole village "+villageType);
      }
   }
   if (nativePattern == 4)
   {
      if (whichNative == 2)
      {
	villageBID = rmCreateGrouping("village B", "native huron village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageBID = rmCreateGrouping("village B", "native seminole village "+villageType);
      }
   }
   if (nativePattern == 5)
   {
      if (whichNative == 2)
      {
	villageBID = rmCreateGrouping("village B", "native seminole village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageBID = rmCreateGrouping("village B", "native nootka village "+villageType);
      }
   }
   if (nativePattern == 6)
   {
      if (whichNative == 2)
      {
	villageBID = rmCreateGrouping("village B", "native nootka village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageBID = rmCreateGrouping("village B", "native cherokee village "+villageType);
      }
   }
   rmAddGroupingToClass(villageBID, rmClassID("importantItem"));
   rmAddGroupingToClass(villageBID, rmClassID("natives"));
   rmSetGroupingMinDistance(villageBID, 0.0);
   rmSetGroupingMaxDistance(villageBID, rmXFractionToMeters(0.09));
   rmAddGroupingConstraint(villageBID, avoidImpassableLand);
   rmAddGroupingConstraint(villageBID, avoidTradeRoute);
   rmAddGroupingConstraint(villageBID, avoidNatives);
   rmAddGroupingConstraint(villageBID, playerConstraint);

   // Village C // appears in center, variable, randomly same or opposite A and B
   int villageCID = -1;	
   villageType = rmRandInt(1,5);
   whichNative = rmRandInt(1,2);

   if (nativePattern == 1)
   {
      if (whichNative == 2)
      {
	villageCID = rmCreateGrouping("village C", "native cherokee village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageCID = rmCreateGrouping("village C", "native huron village "+villageType);
      }
   }
   if (nativePattern == 2)
   {
      if (whichNative == 2)
      {
	villageCID = rmCreateGrouping("village C", "native nootka village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageCID = rmCreateGrouping("village C", "native huron village "+villageType);
      }
   }
   if (nativePattern == 3)
   {
      if (whichNative == 2)
      {
	villageCID = rmCreateGrouping("village C", "native cherokee village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageCID = rmCreateGrouping("village C", "native seminole village "+villageType);
      }
   }
   if (nativePattern == 4)
   {
      if (whichNative == 2)
      {
	villageCID = rmCreateGrouping("village C", "native huron village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageCID = rmCreateGrouping("village C", "native seminole village "+villageType);
      }
   }
   if (nativePattern == 5)
   {
      if (whichNative == 2)
      {
	villageCID = rmCreateGrouping("village C", "native seminole village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageCID = rmCreateGrouping("village C", "native nootka village "+villageType);
      }
   }
   if (nativePattern == 6)
   {
      if (whichNative == 2)
      {
	villageCID = rmCreateGrouping("village C", "native nootka village "+villageType);
      }
      else if (whichNative == 1)
      {
	villageCID = rmCreateGrouping("village C", "native cherokee village "+villageType);
      }
   }
   rmAddGroupingToClass(villageCID, rmClassID("importantItem"));
   rmAddGroupingToClass(villageCID, rmClassID("natives"));
   rmSetGroupingMinDistance(villageCID, 0.0);
   rmSetGroupingMaxDistance(villageCID, rmXFractionToMeters(0.09));
   rmAddGroupingConstraint(villageCID, avoidImpassableLand);
   rmAddGroupingConstraint(villageCID, avoidTradeRoute);
   rmAddGroupingConstraint(villageCID, avoidNatives);
   rmAddGroupingConstraint(villageCID, playerConstraint);

   // Placement of Native Americans

   if (nativeSetup < 3)  // setup 1 and 2
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
            rmPlaceGroupingAtLoc(villageBID, 0, 0.495, 0.09);
	}
      else
	{
	   if (endPosition == 1)
            rmPlaceGroupingAtLoc(villageBID, 0, 0.27, 0.495);
	   else if (endPosition == 2)
            rmPlaceGroupingAtLoc(villageBID, 0, 0.18, 0.505);
	   else
            rmPlaceGroupingAtLoc(villageBID, 0, 0.09, 0.495);
	}
         
	if (nativeSetup == 2)
	{
         rmPlaceGroupingAtLoc(villageCID, 0, 0.5, 0.5);
	}
   }            
   else if (nativeSetup == 6)
   {
      if (axisChance == 1)
	{
	   if (trPattern == 1)
	   {
		if (gapPattern == 1)
		{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.32, 0.35);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.32, 0.65);
		}
		else
		{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.32, 0.22);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.32, 0.78);
		}
		if (gapPattern2 == 1)
		{
               rmPlaceGroupingAtLoc(villageDID, 0, 0.68, 0.35);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.68, 0.65);
		}
		else
		{
               rmPlaceGroupingAtLoc(villageDID, 0, 0.68, 0.22);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.68, 0.78);
		}
	   }
	   else
	   {
               rmPlaceGroupingAtLoc(villageAID, 0, 0.3, 0.25);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.3, 0.75);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.7, 0.25);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.7, 0.75);
	   }
	}
	else if (axisChance == 2)
	{
	   if (trPattern == 1)
	   {
		if (gapPattern == 1)
		{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.35, 0.32);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.65, 0.32);
		}
		else
		{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.22, 0.32);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.78, 0.32);
		}		
		if (gapPattern2 == 1)
		{		
               rmPlaceGroupingAtLoc(villageDID, 0, 0.35, 0.68);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.65, 0.68);
		}
		else
		{
               rmPlaceGroupingAtLoc(villageDID, 0, 0.22, 0.68);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.78, 0.68);
		}
	   }
	   else
	   {
               rmPlaceGroupingAtLoc(villageAID, 0, 0.25, 0.3);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.75, 0.3);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.25, 0.7);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.75, 0.7);
	   }
	}
   }
   else if (nativeSetup > 6)
   {
      if (axisChance == 1)
	{
	   if (trPattern == 1)
	   {
		if (gapPattern == 1)
		{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.32, 0.35);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.32, 0.65);
		}
		else
		{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.32, 0.22);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.32, 0.78);
		}
		if (gapPattern2 == 1)
		{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.68, 0.35);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.68, 0.65);
		}
		else
		{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.68, 0.22);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.68, 0.78);
		}
	   }
	   else
	   {
               rmPlaceGroupingAtLoc(villageAID, 0, 0.3, 0.25);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.3, 0.75);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.7, 0.25);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.7, 0.75);
	   }
	}
	else if (axisChance == 2)
	{
	   if (trPattern == 1)
	   {
		if (gapPattern == 1)
		{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.35, 0.32);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.65, 0.32);
		}
		else
		{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.22, 0.32);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.78, 0.32);
		}		
		if (gapPattern2 == 1)
		{		
               rmPlaceGroupingAtLoc(villageAID, 0, 0.35, 0.68);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.65, 0.68);
		}
		else
		{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.22, 0.68);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.78, 0.68);
		}
	   }
	   else
	   {
               rmPlaceGroupingAtLoc(villageAID, 0, 0.25, 0.3);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.75, 0.3);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.25, 0.7);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.75, 0.7);
	   }
	}

	if (nativeSetup == 8) 
	{
  	      if (cNumberNonGaiaPlayers < 5)
		{
               rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.5);
		}
		else
		{
		   if (axisChance == 1)
		   {
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.495, 0.465);
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.505, 0.535);
	         }
		   else
		   {
           	      rmPlaceGroupingAtLoc(villageDID, 0, 0.465, 0.505);
           	      rmPlaceGroupingAtLoc(villageDID, 0, 0.535, 0.495);
	         }
		}
	}

      if (nativeSetup == 9) 
      {
         if (axisChance == 1)
         {
            if (endPosition == 1)
   	      {
               rmPlaceGroupingAtLoc(villageDID, 0, 0.495, 0.75);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.505, 0.25);
		} 
   	      else if (endPosition == 2)
		{
               rmPlaceGroupingAtLoc(villageDID, 0, 0.505, 0.84);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.495, 0.16);
		} 
	      else
		{
               rmPlaceGroupingAtLoc(villageDID, 0, 0.505, 0.07);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.495, 0.93);
		} 
	   }
         else
	   {
	      if (endPosition == 1)
	      {
               rmPlaceGroupingAtLoc(villageDID, 0, 0.745, 0.495);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.25, 0.505);
		}
	      else if (endPosition == 2)
		{
               rmPlaceGroupingAtLoc(villageDID, 0, 0.84, 0.505);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.16, 0.495);
		}
	      else
		{
               rmPlaceGroupingAtLoc(villageDID, 0, 0.93, 0.495);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.07, 0.505);
		}
	   }                
	}
   }
   else if (nativeSetup > 2) // setup 3, 4 and 5
   {
      if (axisChance == 1)
	{
	   if (endPosition == 1)
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.78);
		rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.22);
	   }
	   else if (endPosition == 2)
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.85);
            rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.15);
	   }
	   else
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.93);
		rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.07);
	   }
	}          
      else
	{
	   if (endPosition == 1)
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.78, 0.5);
	      rmPlaceGroupingAtLoc(villageAID, 0, 0.22, 0.5);
	   }
	   else if (endPosition == 2)
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.85, 0.5);
		rmPlaceGroupingAtLoc(villageAID, 0, 0.15, 0.5);
	   }
	   else
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.93, 0.5);
		rmPlaceGroupingAtLoc(villageAID, 0, 0.07, 0.5);
	   }
	}              
	if (nativeSetup < 5) // 3 and 4 center village or 2
	{
  	      if (cNumberNonGaiaPlayers < 5)
		{
               rmPlaceGroupingAtLoc(villageBID, 0, 0.5, 0.5);
		}
		else
		{
		   if (axisChance == 1)
		   {
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.495, 0.465);
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.505, 0.535);
	         }
		   else
		   {
           	      rmPlaceGroupingAtLoc(villageDID, 0, 0.465, 0.505);
           	      rmPlaceGroupingAtLoc(villageDID, 0, 0.535, 0.495);
	         }
		}
	}
	if (nativeSetup > 3) // 4 and 5 end villages
	{
       if (axisChance == 1)
	 {
         if (sidePosition == 1)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.68, 0.5);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.32, 0.5);
	   }
	   else if (sidePosition == 2)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.68, 0.35);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.32, 0.65);
	   }
	   else
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.68, 0.65);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.32, 0.35);
	   }
      }
	else
	{
         if (sidePosition == 1)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.68);
		rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.32);
	   }	   
	   else if (sidePosition == 2)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.35, 0.68);
		rmPlaceGroupingAtLoc(villageDID, 0, 0.65, 0.32);
	   }
	   else
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.65, 0.68);
		rmPlaceGroupingAtLoc(villageDID, 0, 0.35, 0.32); 
         }
	}
     }  
   }

   // Text
   rmSetStatusText("",0.50);

// Player Nuggets
   int playerNuggetID=rmCreateObjectDef("player nugget");
   rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
   rmAddObjectDefToClass(playerNuggetID, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(playerNuggetID, 35.0);
   rmSetObjectDefMaxDistance(playerNuggetID, 45.0);
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
   rmSetObjectDefMinDistance(nugget2, 60.0);
   rmSetObjectDefMaxDistance(nugget2, 110.0);
   rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget2, avoidSocket);
   rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget2, nuggetPlayerConstraint);
   rmAddObjectDefConstraint(nugget2, avoidNuggetMed);
   rmAddObjectDefConstraint(nugget2, avoidAll);
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
   rmAddObjectDefConstraint(nugget3, farPlayerConstraint);
   rmAddObjectDefConstraint(nugget3, avoidNuggetLong);
   rmAddObjectDefConstraint(nugget3, avoidAll);
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
   rmAddObjectDefConstraint(nugget4, avoidAll);
   rmPlaceObjectDefPerPlayer(nugget4, false, 1);

   // Text
   rmSetStatusText("",0.60);

// more resources
   // start area trees 
   int StartAreaTreeID=rmCreateObjectDef("starting trees");
   rmAddObjectDefItem(StartAreaTreeID, treeType, 1, 0.0);
   rmSetObjectDefMinDistance(StartAreaTreeID, 8);
   rmSetObjectDefMaxDistance(StartAreaTreeID, 12);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidAll);
   rmPlaceObjectDefPerPlayer(StartAreaTreeID, false, 3);

   // berry bushes
   int berryNum = rmRandInt(2,5);
   int StartBerryBushID=rmCreateObjectDef("starting berry bush");
   rmAddObjectDefItem(StartBerryBushID, "BerryBush", rmRandInt(2,4), 4.0);
   rmSetObjectDefMinDistance(StartBerryBushID, 10.0);
   rmSetObjectDefMaxDistance(StartBerryBushID, 14.0);
   rmAddObjectDefConstraint(StartBerryBushID, avoidStartingUnitsSmall);
   if (placeBerries == 1)
      rmPlaceObjectDefPerPlayer(StartBerryBushID, false, 1);

   // start area huntable
   int deerNum = rmRandInt(5, 8);
   int startPronghornID=rmCreateObjectDef("starting pronghorn");
   rmAddObjectDefItem(startPronghornID, deerType, deerNum, 5.0);
   rmAddObjectDefToClass(startPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(startPronghornID, 14);
   rmSetObjectDefMaxDistance(startPronghornID, 20);
   rmAddObjectDefConstraint(startPronghornID, avoidStartResource);
   rmAddObjectDefConstraint(startPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(startPronghornID, avoidAll);
   rmSetObjectDefCreateHerd(startPronghornID, false);
   rmPlaceObjectDefPerPlayer(startPronghornID, false, 1);

   // second huntable
   int deer2Num = rmRandInt(4, 8);
   int farPronghornID=rmCreateObjectDef("far pronghorn");
   rmAddObjectDefItem(farPronghornID, deer2Type, deer2Num, 5.0);
   rmAddObjectDefToClass(farPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farPronghornID, 42.0);
   rmSetObjectDefMaxDistance(farPronghornID, 65.0);
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

   // Text
   rmSetStatusText("",0.65);

// Silver mines - players
   int silverType = -1;
   silverType = rmRandInt(1,10);
   int playerGoldID=rmCreateObjectDef("player silver closer");
   rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
   rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerGoldID, avoidSocket);
   rmAddObjectDefConstraint(playerGoldID, coinAvoidCoin);
   rmAddObjectDefConstraint(playerGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(playerGoldID, circleConstraint);
   rmAddObjectDefConstraint(playerGoldID, avoidAll);
   rmSetObjectDefMinDistance(playerGoldID, 18.0);
   rmSetObjectDefMaxDistance(playerGoldID, 23.0);
   rmPlaceObjectDefPerPlayer(playerGoldID, false, 1);
   if (rmRandInt(1,4) == 1)
      rmPlaceObjectDefPerPlayer(playerGoldID, false, 1);

   silverType = rmRandInt(1,10);
   int GoldMediumID=rmCreateObjectDef("player silver med");
   rmAddObjectDefItem(GoldMediumID, "mine", 1, 0.0);
   rmAddObjectDefConstraint(GoldMediumID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldMediumID, avoidSocket);
   rmAddObjectDefConstraint(GoldMediumID, coinAvoidCoin);
   rmAddObjectDefConstraint(GoldMediumID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(GoldMediumID, playerConstraint);
   rmAddObjectDefConstraint(GoldMediumID, circleConstraint);
   rmAddObjectDefConstraint(GoldMediumID, avoidAll);
   rmSetObjectDefMinDistance(GoldMediumID, 40.0);
   rmSetObjectDefMaxDistance(GoldMediumID, 55.0);
   rmPlaceObjectDefPerPlayer(GoldMediumID, false, 1);

// Extra silver mines - distant, in the middle and near ends of axis.
   silverType = rmRandInt(1,10);
   int extraGoldID = rmCreateObjectDef("extra silver "+i);
   rmAddObjectDefItem(extraGoldID, "mine", 1, 0.0);
   rmAddObjectDefToClass(extraGoldID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(extraGoldID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraGoldID, avoidSocket);
   rmAddObjectDefConstraint(extraGoldID, coinAvoidCoin);
   rmAddObjectDefConstraint(extraGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(extraGoldID, avoidImpassableLand);
   rmAddObjectDefConstraint(extraGoldID, avoidAll);
   rmSetObjectDefMinDistance(extraGoldID, 0.0);
   rmSetObjectDefMaxDistance(extraGoldID, 60.0);
   rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.5, 0.5, rmRandInt(1, 3));
   if (cNumberNonGaiaPlayers > 4)
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.5, 0.5, 1);
   if (cNumberNonGaiaPlayers > 6)
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.5, 0.5, 1);
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

   silverType = rmRandInt(1,10);
   int GoldFarID=rmCreateObjectDef("player silver far");
   rmAddObjectDefItem(GoldFarID, "mine", 1, 0.0);
   rmAddObjectDefConstraint(GoldFarID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldFarID, avoidSocket);
   rmAddObjectDefConstraint(GoldFarID, coinAvoidCoin);
   rmAddObjectDefConstraint(GoldFarID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(GoldFarID, circleConstraint);
   rmAddObjectDefConstraint(GoldFarID, avoidImpassableLand);
   rmAddObjectDefConstraint(GoldFarID, avoidAll);
   rmAddObjectDefConstraint(GoldFarID, farPlayerConstraint);
   rmSetObjectDefMinDistance(GoldFarID, 75.0);
   rmSetObjectDefMaxDistance(GoldFarID, 90.0);
   rmPlaceObjectDefPerPlayer(GoldFarID, false, 1);

   silverType = rmRandInt(1,10);
   int GoldFartherID=rmCreateObjectDef("player silver farther");
   rmAddObjectDefItem(GoldFartherID, "mine", 1, 0.0);
   rmAddObjectDefConstraint(GoldFartherID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldFartherID, avoidSocket);
   rmAddObjectDefConstraint(GoldFartherID, coinAvoidCoin);
   rmAddObjectDefConstraint(GoldFartherID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(GoldFartherID, avoidImpassableLand);
   rmAddObjectDefConstraint(GoldFartherID, circleConstraint);
   rmAddObjectDefConstraint(GoldFartherID, avoidAll);
   rmSetObjectDefMinDistance(GoldFartherID, 90.0);
   rmSetObjectDefMaxDistance(GoldFartherID, 200.0);
   rmAddObjectDefConstraint(GoldFartherID, fartherPlayerConstraint);
   rmPlaceObjectDefPerPlayer(GoldFartherID, false, 1);

   // Text
   rmSetStatusText("",0.70);

// Extra tree clumps near players - to ensure fair access to wood
   int extraTreesID=rmCreateObjectDef("extra trees");
   rmAddObjectDefItem(extraTreesID, treeType, 5, 5.0);
   rmSetObjectDefMinDistance(extraTreesID, 14);
   rmSetObjectDefMaxDistance(extraTreesID, 18);
   rmAddObjectDefConstraint(extraTreesID, avoidAll);
   rmAddObjectDefConstraint(extraTreesID, avoidCoin);
   rmAddObjectDefConstraint(extraTreesID, avoidSocket);
   rmAddObjectDefConstraint(extraTreesID, avoidTradeRoute);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTreesID, 0, rmAreaID("player"+i), 2);

   int extraTrees2ID=rmCreateObjectDef("more extra trees");
   rmAddObjectDefItem(extraTrees2ID, treeType, 6, 6.0);
   rmSetObjectDefMinDistance(extraTrees2ID, 18);
   rmSetObjectDefMaxDistance(extraTrees2ID, 28);
   rmAddObjectDefConstraint(extraTrees2ID, avoidAll);
   rmAddObjectDefConstraint(extraTrees2ID, avoidCoin);
   rmAddObjectDefConstraint(extraTrees2ID, avoidSocket);
   rmAddObjectDefConstraint(extraTrees2ID, avoidTradeRoute);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTrees2ID, 0, rmAreaID("player"+i), 1);

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

      rmAddObjectDefConstraint(sheepID, nuggetPlayerConstraint);
      rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.45));	
      rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, cNumberNonGaiaPlayers); 
   }

   // Text
   rmSetStatusText("",0.75);

// Central herds
   int centralHerdID=rmCreateObjectDef("central herd");  
   rmAddObjectDefItem(centralHerdID, centerHerdType, rmRandInt(7,9), 6.0);
   rmAddObjectDefToClass(centralHerdID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(centralHerdID, rmXFractionToMeters(0.05));
   rmSetObjectDefMaxDistance(centralHerdID, rmXFractionToMeters(0.1));
   rmAddObjectDefConstraint(centralHerdID, avoidTradeRoute);
   rmAddObjectDefConstraint(centralHerdID, avoidImportantItem);
   rmAddObjectDefConstraint(centralHerdID, nuggetPlayerConstraint);
   rmAddObjectDefConstraint(centralHerdID, longHuntableConstraint);
   rmSetObjectDefCreateHerd(centralHerdID, true);
   rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.5, 0.5, 1);
   // additional of central herd type
   rmAddObjectDefConstraint(centralHerdID, farPlayerConstraint);
   rmSetObjectDefMinDistance(centralHerdID, rmXFractionToMeters(0.3));
   rmSetObjectDefMaxDistance(centralHerdID, rmXFractionToMeters(0.38));
   rmPlaceObjectDefPerPlayer(centralHerdID, false, 1);

// far huntable
   int farHuntableID=rmCreateObjectDef("far huntable");
   rmAddObjectDefItem(farHuntableID, deerType, rmRandInt(6,9), 6.0);
   rmAddObjectDefToClass(farHuntableID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farHuntableID, rmXFractionToMeters(0.33));
   rmSetObjectDefMaxDistance(farHuntableID, rmXFractionToMeters(0.43));
   rmAddObjectDefConstraint(farHuntableID, avoidTradeRoute);
   rmAddObjectDefConstraint(farHuntableID, avoidImportantItem);
   rmAddObjectDefConstraint(farHuntableID, fartherPlayerConstraint);
   rmAddObjectDefConstraint(farHuntableID, longHuntableConstraint);
   rmAddObjectDefConstraint(farHuntableID, avoidAll);
   rmSetObjectDefCreateHerd(farHuntableID, true);
   rmPlaceObjectDefPerPlayer(farHuntableID, false, 1);

   // Text
   rmSetStatusText("",0.80);

// Main forests
   int forestChance = -1;

   int numTries=19*cNumberNonGaiaPlayers;
   if (cNumberNonGaiaPlayers > 6)
      numTries=11*cNumberNonGaiaPlayers;
   else if (cNumberNonGaiaPlayers == 6)
      numTries=12*cNumberNonGaiaPlayers;
   else if (cNumberNonGaiaPlayers > 3)
      numTries=14*cNumberNonGaiaPlayers;  
   else if (cNumberNonGaiaPlayers == 3)
      numTries=16*cNumberNonGaiaPlayers;  
 
   int failCount=0;

   for (i=0; <numTries)
   {
      forestChance = rmRandInt(1,4);
      int forest=rmCreateArea("forest "+i);
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(100), rmAreaTilesToFraction(250));
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
      rmAddAreaConstraint(forest, avoidImpassableLand); 
      rmAddAreaConstraint(forest, avoidTradeRoute);
	rmAddAreaConstraint(forest, avoidStartingUnits);
	rmAddAreaConstraint(forest, avoidSocket);
	rmAddAreaConstraint(forest, avoidNativesShort);
      rmAddAreaConstraint(forest, forestsAvoidBison); 
	rmAddAreaConstraint(forest, hillConstraint);
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
   rmSetStatusText("",0.85);

// Ridgetop trees
   int b1num = 2;
   int b2num = 2; 
   int bS1num = 2;
   int bN1num = 2;
   int bS2num = 2;
   int bN2num = 2;
   if (gapPattern == 2)
   {
      b1num = 1;
	b2num = 3;
   }
   if (gapPattern == 3)
   {
      b1num = 3;
	b2num = 1;
   }
   if (gapPattern == 2)
   {
      bS1num = 1;
      bN1num = 3;
   }
   if (gapPattern == 3)
   {
      bS1num = 3;
      bN1num = 1;
   }
   if (gapPattern2 == 2)
   {
      bS2num = 1;
      bN2num = 3;
   }
   if (gapPattern2 == 3)
   {
      bS2num = 3;
      bN2num = 1;
   }
   int ridgeTreeNum = cNumberNonGaiaPlayers + 5;
   for(i=0; <ridgeTreeNum)
   {
      int ridgeTreeID=rmCreateObjectDef("trees on ridges "+i);
      rmAddObjectDefItem(ridgeTreeID, treeType, rmRandInt(2,5), 4.0);
      rmAddObjectDefConstraint(ridgeTreeID, avoidAll);
      rmSetObjectDefMinDistance(ridgeTreeID, 0.0);
      rmSetObjectDefMaxDistance(ridgeTreeID, 0.0);
	if (barrierPattern == 1)
         rmPlaceObjectDefInArea(ridgeTreeID, 0, barrierCID, 4);
      if (barrierPattern == 2)
	{
         rmPlaceObjectDefInArea(ridgeTreeID, 0, barrier1ID, b1num);
         rmPlaceObjectDefInArea(ridgeTreeID, 0, barrier2ID, b2num);
	}
      if (barrierPattern == 3)
	{
         rmPlaceObjectDefInArea(ridgeTreeID, 0, barrierEID, 4);
         rmPlaceObjectDefInArea(ridgeTreeID, 0, barrierWID, 4);
	}
      if (barrierPattern > 3)
	{
         rmPlaceObjectDefInArea(ridgeTreeID, 0, barrierS1ID, bS1num);
         rmPlaceObjectDefInArea(ridgeTreeID, 0, barrierN1ID, bN1num);
         rmPlaceObjectDefInArea(ridgeTreeID, 0, barrierS2ID, bS2num);
         rmPlaceObjectDefInArea(ridgeTreeID, 0, barrierN2ID, bN2num);
	} 
   }

// KOTH game mode
   if(rmGetIsKOTH())
   {
      float xLoc = 0.5;
      float yLoc = 0.5;
      float walk = 0.03;
      
      ypKingsHillPlacer(yLoc, yLoc, walk, 0);
      rmEchoInfo("XLOC = "+yLoc);
      rmEchoInfo("XLOC = "+yLoc);
   }


   // Text
   rmSetStatusText("",0.90);


// Random trees
   int StragglerTreeID=rmCreateObjectDef("stragglers");
   rmAddObjectDefItem(StragglerTreeID, treeType, 1, 0.0);
   rmAddObjectDefConstraint(StragglerTreeID, avoidAll);
   rmAddObjectDefConstraint(StragglerTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StragglerTreeID, avoidCoin);
   rmSetObjectDefMinDistance(StragglerTreeID, 10.0);
   rmSetObjectDefMaxDistance(StragglerTreeID, rmXFractionToMeters(0.5));
   for(i=0; <cNumberNonGaiaPlayers*15)
      rmPlaceObjectDefAtLoc(StragglerTreeID, 0, 0.5, 0.5);
 

   // Text
   rmSetStatusText("",0.99);
}
