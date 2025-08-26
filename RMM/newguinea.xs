// Sea to Sea
// for the AOE3 Trial
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
   string centerTerrain = "";
   string cliffType = "";
   string forestType = "";
   string treeType = "";
   string deerType = "";
   string centerHerdType = "";

   // Pick pattern for trees, terrain, etc.
   int patternChance = -1;
   patternChance = rmRandInt(1, 2);
   int variantChance = -1;
   variantChance = rmRandInt(1, 2);
   
   if (patternChance == 1)
   {
      baseType = "ceylon_grass_b";
      centerTerrain = "ceylon\ground_grass2_ceylon";
	forestType = "Ceylon Forest";
	treeType = "ypTreeBorneoCanopy";
      deerType = "Peafowl";
      centerHerdType = "ypSerow";
      cliffType = "ceylon";
   }
   else if (patternChance == 2)
   {
      baseType = "ceylon_grass_b";
	centerTerrain = "ceylon\ground_grass2_ceylon";
	forestType = "Ceylon Forest";
	treeType = "ypTreeBorneoCanopy";
      deerType = "Peafowl";
      centerHerdType = "ypSerow";
         cliffType = "ceylon";
   }

	chooseMercs();

   // Picks the map size
   	int playerTiles=20000;
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=19000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=18000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=17000;

   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

   // Elevation
   rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);
   rmSetMapElevationHeightBlend(1);
	
   // Pick default terrain, water, map types
   rmSetSeaLevel(0.0);
   rmSetLightingSet("ceylon");
   rmSetSeaType("ceylon coast2");
   rmTerrainInitialize("water");
   rmSetMapType("micronesia");
   rmSetMapType("asia");
   rmSetMapType("land");
   rmSetWorldCircleConstraint(true);
   rmSetWindMagnitude(2.0);
   rmSetMapType("grass");
   rmSetMapType("AIFishingUseful");

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
   rmDefineClass("nuggets");
   rmDefineClass("center");
   rmDefineClass("socketClass");

   // Text
   rmSetStatusText("",0.10);

   // -------------Define constraints
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
   int bisonEdgeConstraint=rmCreateBoxConstraint("bison edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 70.0);  
   int centerConstraint=rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), 30.0);
   int centerConstraintFar=rmCreateClassDistanceConstraint("stay away from center far", rmClassID("center"), 60.0);

   // Cardinal Directions
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));
   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // Player constraints
   int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 15.0);
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 45.0);
   int bigPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 100.0);

   // Nature avoidance
   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 20.0);
   int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 20.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 10.0);
   int coinAvoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 35.0);
   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   int avoidSheep=rmCreateTypeDistanceConstraint("sheep avoids sheep", "ypYak", 30.0);
   int avoidCow=rmCreateTypeDistanceConstraint("sheep avoids sheep", "ypWaterBuffalo", 30.0);
   int avoidBerries=rmCreateTypeDistanceConstraint("berries avoids berries", "BerryBush", 30.0);
   int forestsAvoidBison=rmCreateTypeDistanceConstraint("forest avoids bison", "ypSerow", 20.0);
   int bisonAvoidBison=rmCreateTypeDistanceConstraint("bison avoids bison", "ypSerow", 35.0);
   int deerAvoidDeer=rmCreateTypeDistanceConstraint("deer avoids deer", "Peafowl", 35.0);
   
   // Avoid impassable land, certain features
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
   int hillConstraint=rmCreateClassDistanceConstraint("hill vs. hill", rmClassID("classHill"), 10.0);
   int shortHillConstraint=rmCreateClassDistanceConstraint("patches vs. hill", rmClassID("classHill"), 5.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
   int avoidCliffs=rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 12.0);
   int cliffsAvoidCliffs=rmCreateClassDistanceConstraint("cliffs vs. cliffs", rmClassID("classCliff"), 30.0);
   int avoidWater10 = rmCreateTerrainDistanceConstraint("avoid water mid-long", "Land", false, 10.0);
   int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water a little more", "Land", false, 20.0);
   int avoidWater30 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 30.0);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);
   int avoidStartingUnitsLarge=rmCreateClassDistanceConstraint("objects avoid starting units large", rmClassID("startingUnit"), 50.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("things avoid each other", rmClassID("importantItem"), 10.0);
   int avoidImportantItemSmall=rmCreateClassDistanceConstraint("important item small avoidance", rmClassID("importantItem"), 10.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 60.0);
   int avoidNugget=rmCreateClassDistanceConstraint("stuff avoids nuggets", rmClassID("nuggets"), 40.0);
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
   int avoidTradeRouteCliff = rmCreateTradeRouteDistanceConstraint("trade route cliff", 10.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);
   int avoidSocket=rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 12.0);

   // New extra stuff for water spawn point avoidance.
   int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 10.0);
   int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 70);
   int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-20, rmGetMapXSize()-10, 0, 0, 0);

   // Build up big continent 
   int bigContinentID=rmCreateArea("big continent");
   rmSetAreaSize(bigContinentID, 0.39, 0.40);		
   rmSetAreaSmoothDistance(bigContinentID, 25);
   rmSetAreaMix(bigContinentID, baseType);
   rmSetAreaElevationType(bigContinentID, cElevTurbulence);
   rmSetAreaElevationVariation(bigContinentID, 2.0);
   rmSetAreaBaseHeight(bigContinentID, 1.0);
   rmSetAreaElevationMinFrequency(bigContinentID, 0.09);
   rmSetAreaElevationOctaves(bigContinentID, 2);
   rmSetAreaElevationPersistence(bigContinentID, 0.5); 
   rmSetAreaCoherence(bigContinentID, 0.65);
   rmSetAreaLocation(bigContinentID, 0.5, 0.5);
   rmBuildArea(bigContinentID);

   // Set up for axis and player side
   int axisChance = -1;
   axisChance = rmRandInt(1, 2);
   int playerSide = -1;
   playerSide = rmRandInt(1, 2);

   // Build up small continent spurs called "small continent spur 1 & 2"
   int smallContinent1ID=rmCreateArea("small continent spur 1");
   rmSetAreaSize(smallContinent1ID, 0.17, 0.17);
   rmSetAreaWarnFailure(smallContinent1ID, false);
   rmSetAreaSmoothDistance(smallContinent1ID, 25);
   rmSetAreaMix(smallContinent1ID, baseType);
   rmSetAreaElevationType(smallContinent1ID, cElevTurbulence);
   rmSetAreaElevationVariation(smallContinent1ID, 2.0);
   rmSetAreaBaseHeight(smallContinent1ID, 1.0);
   rmSetAreaElevationMinFrequency(smallContinent1ID, 0.09);
   rmSetAreaElevationOctaves(smallContinent1ID, 2);
   rmSetAreaElevationPersistence(smallContinent1ID, 0.2);      
   rmSetAreaCoherence(smallContinent1ID, 0.5);
   if (axisChance == 2)
      rmSetAreaLocation(smallContinent1ID, 0.1, 0.1);
   else
      rmSetAreaLocation(smallContinent1ID, 0.9, 0.1);
   if (axisChance == 2)
      rmSetAreaEdgeFilling(smallContinent1ID, 5);
   rmSetAreaObeyWorldCircleConstraint(smallContinent1ID, false);
   rmBuildArea(smallContinent1ID);

   int smallContinent2ID=rmCreateArea("small continent spur 2");
   rmSetAreaSize(smallContinent2ID, 0.17, 0.17);
   rmSetAreaWarnFailure(smallContinent2ID, false);
   rmSetAreaSmoothDistance(smallContinent2ID, 25);
   rmSetAreaMix(smallContinent2ID, baseType);
   rmSetAreaElevationType(smallContinent2ID, cElevTurbulence);
   rmSetAreaElevationVariation(smallContinent2ID, 2.0);
   rmSetAreaBaseHeight(smallContinent2ID, 1.0);
   rmSetAreaElevationMinFrequency(smallContinent2ID, 0.09);
   rmSetAreaElevationOctaves(smallContinent2ID, 2);
   rmSetAreaElevationPersistence(smallContinent2ID, 0.2);      
   rmSetAreaCoherence(smallContinent2ID, 0.5);
   if (axisChance == 2)
      rmSetAreaLocation(smallContinent2ID, 0.9, 0.9);
   else 
      rmSetAreaLocation(smallContinent2ID, 0.1, 0.9);
   if (axisChance == 2)
      rmSetAreaEdgeFilling(smallContinent2ID, 5);
   rmSetAreaObeyWorldCircleConstraint(smallContinent2ID, false);
   rmBuildArea(smallContinent2ID);

   // Set up player starting locations
   if ( cNumberTeams == 2)
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
         rmSetPlacementSection(0.10, 0.40);
	   if (cNumberNonGaiaPlayers >6)
	   {
		rmSetPlacementSection(0.13, 0.37);
         }
         rmPlacePlayersCircular(0.24, 0.25, 0.0);
	   if (playerSide == 1)
         {
		rmSetPlacementTeam(1);
	   }
         else if (playerSide == 2)
	   {
		rmSetPlacementTeam(0);
	   }
	   rmSetPlacementSection(0.60, 0.90);
	   if (cNumberNonGaiaPlayers >6)
	   {
		rmSetPlacementSection(0.63, 0.87);
         }
         rmPlacePlayersCircular(0.24, 0.25, 0.0);
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
	   rmSetPlacementSection(0.35, 0.65);
	   if (cNumberNonGaiaPlayers >6)
	   {
		rmSetPlacementSection(0.13, 0.37);
	   }
         rmPlacePlayersCircular(0.24, 0.25, 0.0);
	   if (playerSide == 1)
         {
		rmSetPlacementTeam(1);
	   }
         else if (playerSide == 2)
	   {
		rmSetPlacementTeam(0);
	   }
	   rmSetPlacementSection(0.85, 0.15);
	   if (cNumberNonGaiaPlayers >6)
	   {
		rmSetPlacementSection(0.63, 0.87);
	   }
         rmPlacePlayersCircular(0.24, 0.25, 0.0);
      }
   }
   else
   {
	  rmPlacePlayersCircular(0.24, 0.25, 0.0);
   }

   // Text
   rmSetStatusText("",0.20);
	
  // Set up player areas.
   float playerFraction=rmAreaTilesToFraction(200);
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

   // Central features
   int nativeNumber = -1;
   if (variantChance == 2)
      nativeNumber = rmRandInt(2,5);


   // Text
   rmSetStatusText("",0.30);

   // Trade Routes
   int tradeRouteID = rmCreateTradeRoute();
   if (axisChance == 1)
   {
      rmAddTradeRouteWaypoint(tradeRouteID, 0.1, 0.9);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.76);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.6, 0.6);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.76, 0.5);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.9, 0.1);
   }
   else if (axisChance == 2)
   {
      rmAddTradeRouteWaypoint(tradeRouteID, 0.1, 0.1);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.24, 0.5);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.4, 0.6);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.76);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.9, 0.9);
   }
   rmBuildTradeRoute(tradeRouteID, "water");

   int tradeRoute2ID = rmCreateTradeRoute();
   if (axisChance == 1)
   {
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.1, 0.9);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.24, 0.5);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.4, 0.4);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.5, 0.24);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.9, 0.1);
   }
   else if (axisChance == 2)
   {
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.1, 0.1);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.5, 0.24);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.6, 0.4);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.76, 0.5);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.9, 0.9);
   }
   rmBuildTradeRoute(tradeRoute2ID, "water");  

   // Trading post sockets
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 8.0);
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

   // sockets for 1st trade route
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.66);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // sockets for 2nd trade route
   rmSetObjectDefTradeRouteID(socketID, tradeRoute2ID);
   socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.34);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.85);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // Text
   rmSetStatusText("",0.40);

   // NATIVE ASIANS
   // enable for the map
   int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;

   subCiv0=rmGetCivID("Jesuit");
   rmSetSubCiv(0, "Jesuit", true);
 
   subCiv1=rmGetCivID("Bhakti");
   rmSetSubCiv(1, "Bhakti");

   subCiv2=rmGetCivID("Sufi");
   rmSetSubCiv(2, "Sufi");

   // Village A 
   int villageAID = -1;
   int villageType = rmRandInt(1,3);
   int whichNative = rmRandInt(1,3);

   if ( whichNative == 1 )
      {
	villageAID = rmCreateGrouping("jesuit village A", "native jesuit mission borneo 0"+villageType);
      }
   else if ( whichNative == 2 )
      {
	villageAID = rmCreateGrouping("sufi village A", "native sufi mosque borneo "+villageType);
      }
   else 
      {
	villageAID = rmCreateGrouping("bhakti village A", "native bhakti village ceylon "+villageType);
      }
   rmSetGroupingMinDistance(villageAID, 0.0);
   rmSetGroupingMaxDistance(villageAID, rmXFractionToMeters(0.07));
   rmAddGroupingConstraint(villageAID, avoidImpassableLand);
   rmAddGroupingToClass(villageAID, rmClassID("importantItem"));
   rmAddGroupingConstraint(villageAID, avoidTradeRoute);
   if (axisChance == 1)
      rmPlaceGroupingAtLoc(villageAID, 0, 0.75, 0.25); 
   else
      rmPlaceGroupingAtLoc(villageAID, 0, 0.25, 0.25);

   // Village B
   int villageBID = -1;	
   villageType = rmRandInt(1,3);
   whichNative = rmRandInt(1,3);
   if ( whichNative == 1 )
	{
	villageBID = rmCreateGrouping("jesuit village B", "native jesuit mission borneo 0"+villageType);
	}
   else if ( whichNative == 2 )
	{
	villageBID = rmCreateGrouping("sufi village B", "native sufi mosque borneo "+villageType);
	}
   else
	{
	villageBID = rmCreateGrouping("bhakti village B", "native bhakti village ceylon "+villageType);
	}
   rmSetGroupingMinDistance(villageBID, 0.0);
   rmSetGroupingMaxDistance(villageBID, rmXFractionToMeters(0.07));
   rmAddGroupingConstraint(villageBID, avoidImpassableLand);
   rmAddGroupingToClass(villageBID, rmClassID("importantItem"));
   rmAddGroupingConstraint(villageBID, avoidTradeRoute);
   if (axisChance == 1)
      rmPlaceGroupingAtLoc(villageBID, 0, 0.25, 0.75);
   else
      rmPlaceGroupingAtLoc(villageBID, 0, 0.75, 0.75);

   // Village C
   int villageCID = -1;	
   villageType = rmRandInt(1,3);
   whichNative = rmRandInt(1,3);
   if ( whichNative == 1 )
	{
	villageCID = rmCreateGrouping("cherokee village C", "native jesuit mission borneo 0"+villageType);
	}
   else if ( whichNative == 2 )
	{
	villageCID = rmCreateGrouping("iroquois village C", "native sufi mosque borneo "+villageType);
	}
   else
	{
	villageCID = rmCreateGrouping("bhakti village C", "native bhakti village ceylon "+villageType);
	}
   rmSetGroupingMinDistance(villageCID, 0.0);
   rmSetGroupingMaxDistance(villageCID, rmXFractionToMeters(0.07));
   rmAddGroupingConstraint(villageCID, avoidImpassableLand);
   rmAddGroupingToClass(villageCID, rmClassID("importantItem"));
   rmAddGroupingConstraint(villageCID, avoidTradeRoute);
   if (nativeNumber > 2)
      rmPlaceGroupingAtLoc(villageCID, 0, 0.5, 0.5);


   //Text
   rmSetStatusText("",0.50);

   // Starting TCs and units 		
   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 10.0);
   rmSetObjectDefMaxDistance(startingUnits, 15.0);
   rmAddObjectDefConstraint(startingUnits, avoidAll);

   int startingTCID= rmCreateObjectDef("startingTC");
   rmAddObjectDefConstraint(startingTCID, avoidAll);
   rmSetObjectDefMinDistance(startingTCID, 0.0);
   rmSetObjectDefMaxDistance(startingTCID, 10.0);             
   if ( rmGetNomadStart())
   {
	rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
   }
   else
   {
      rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
   }

   for(i=0; <cNumberPlayers)
   {	
      rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

   }


   // Water Flag
   int waterFlagID=-1;
   for(i=1; <cNumberPlayers)
   {
   rmClearClosestPointConstraints();
   waterFlagID=rmCreateObjectDef("HC water flag "+i);
   rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 0.0);
   rmAddClosestPointConstraint(flagEdgeConstraint);
   rmAddClosestPointConstraint(flagVsFlag);
   rmAddClosestPointConstraint(flagLand);
   vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
   vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));
   rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
   rmClearClosestPointConstraints();
   }


   // Text
   rmSetStatusText("",0.60);

   // Player Nuggets
   int playerNuggetID=rmCreateObjectDef("player nugget");
   rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
   rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(playerNuggetID, 33.0);
   rmSetObjectDefMaxDistance(playerNuggetID, 40.0);
   rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerNuggetID, avoidSocket);
   rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
   rmAddObjectDefConstraint(playerNuggetID, circleConstraint);

   for(i=0; <cNumberPlayers)
   {
 	rmSetNuggetDifficulty(1, 1);
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
   }

   // Cliffs
   int numCliffs = rmRandInt(3,4);
   for (i=0; <numCliffs)
   {    
		int bigCliffID=rmCreateArea("big cliff" +i);
	      rmSetAreaSize(bigCliffID, rmAreaTilesToFraction(380), rmAreaTilesToFraction(450));
		rmSetAreaWarnFailure(bigCliffID, false);
		rmSetAreaCliffType(bigCliffID, cliffType);
		rmAddAreaToClass(bigCliffID, rmClassID("classCliff"));	
		rmSetAreaCliffEdge(bigCliffID, 1, 0.5, 0.1, 1.0, 0);
		rmSetAreaCliffPainting(bigCliffID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(bigCliffID, 5, 1.0, 1.0);
		rmSetAreaHeightBlend(bigCliffID, 1.0);
		rmSetAreaMinBlobs(bigCliffID, 3);
		rmSetAreaMaxBlobs(bigCliffID, 5);
		rmSetAreaMinBlobDistance(bigCliffID, 12.0);
		rmSetAreaMaxBlobDistance(bigCliffID, 20.0);
		rmSetAreaSmoothDistance(bigCliffID, 15);
		rmSetAreaCoherence(bigCliffID, 0.4);
	 //     rmAddAreaConstraint(bigCliffID, avoidStartingUnits);
	      rmAddAreaConstraint(bigCliffID, bigPlayerConstraint);
		rmAddAreaConstraint(bigCliffID, avoidImportantItem);
		rmAddAreaConstraint(bigCliffID, avoidTradeRoute);
            rmAddAreaConstraint(bigCliffID, avoidNatives);
	      rmAddAreaConstraint(bigCliffID, avoidSocket);
	      rmAddAreaConstraint(bigCliffID, avoidWater20);
	      rmAddAreaConstraint(bigCliffID, cliffsAvoidCliffs);
		rmBuildArea(bigCliffID);
   }

   // Random Nuggets
   int nuggetID= rmCreateObjectDef("nugget"); 
   rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
   rmAddObjectDefToClass(nuggetID, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(nuggetID, 45.0);
   rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(nuggetID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nuggetID, avoidNugget);
   rmAddObjectDefConstraint(nuggetID, avoidStartingUnits);
   rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
   rmAddObjectDefConstraint(nuggetID, avoidSocket);
   rmAddObjectDefConstraint(nuggetID, avoidAll);
   rmAddObjectDefConstraint(nuggetID, circleConstraint);
   rmAddObjectDefConstraint(nuggetID, avoidWater10);

   for(i=1; <cNumberPlayers)
   {
      rmSetNuggetDifficulty(2, 2);
	rmPlaceObjectDefAtLoc(nuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(nuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmSetNuggetDifficulty(3, 3);
	rmPlaceObjectDefAtLoc(nuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
   }

   // Text
   rmSetStatusText("",0.65);

   // more resources 
   int StartAreaTreeID=rmCreateObjectDef("starting trees");
   rmAddObjectDefItem(StartAreaTreeID, treeType, 1, 0.0);
   rmSetObjectDefMinDistance(StartAreaTreeID, 8);
   rmSetObjectDefMaxDistance(StartAreaTreeID, 14);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidAll);
   rmPlaceObjectDefPerPlayer(StartAreaTreeID, false, 3);

   int startPronghornID=rmCreateObjectDef("starting pronghorn");
   rmAddObjectDefItem(startPronghornID, deerType, 7, 4.0);
   rmSetObjectDefMinDistance(startPronghornID, 11);
   rmSetObjectDefMaxDistance(startPronghornID, 15);
   rmAddObjectDefConstraint(startPronghornID, avoidStartResource);
   rmAddObjectDefConstraint(startPronghornID, bisonAvoidBison);
   rmAddObjectDefConstraint(startPronghornID, deerAvoidDeer);
   rmAddObjectDefConstraint(startPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(startPronghornID, avoidNatives);
   rmAddObjectDefConstraint(startPronghornID, avoidAll);
   rmSetObjectDefCreateHerd(startPronghornID, false);
   rmPlaceObjectDefPerPlayer(startPronghornID, false, 2);

   int farPronghornID=rmCreateObjectDef("far pronghorn");
   rmAddObjectDefItem(farPronghornID, deerType, 8, 4.0);
   rmSetObjectDefMinDistance(farPronghornID, 30);
   rmSetObjectDefMaxDistance(farPronghornID, 48);
   rmAddObjectDefConstraint(farPronghornID, avoidStartResource);
   rmAddObjectDefConstraint(farPronghornID, bisonAvoidBison);
   rmAddObjectDefConstraint(farPronghornID, deerAvoidDeer);
   rmAddObjectDefConstraint(farPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(farPronghornID, avoidNatives);
   rmAddObjectDefConstraint(farPronghornID, avoidAll);
   rmSetObjectDefCreateHerd(farPronghornID, true);
   rmPlaceObjectDefPerPlayer(farPronghornID, false, 2);

   int silverType = -1;
   silverType = rmRandInt(1,10);
   int playerGoldID=rmCreateObjectDef("player silver closer");
   rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
   rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerGoldID, coinAvoidCoin);
   rmAddObjectDefConstraint(playerGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(playerGoldID, circleConstraint);
   rmAddObjectDefConstraint(playerGoldID, avoidAll);
   rmSetObjectDefMinDistance(playerGoldID, 25.0);
   rmSetObjectDefMaxDistance(playerGoldID, 30.0);
   rmPlaceObjectDefPerPlayer(playerGoldID, false, 1);

   int playerCowID = rmCreateObjectDef("player animals");
   int animalChance = -1;
   animalChance = rmRandInt(1,2);
   if (animalChance == 1)
      rmAddObjectDefItem(playerCowID, "ypYak", 2 , 4.0);
   else
      rmAddObjectDefItem(playerCowID, "ypWaterBuffalo", 2 , 4.0);
   rmSetObjectDefMinDistance(playerCowID, 40.0);
   rmSetObjectDefMaxDistance(playerCowID, 70.0);
   rmAddObjectDefConstraint(playerCowID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerCowID, avoidImportantItem);
   rmAddObjectDefConstraint(playerCowID, circleConstraint);
   rmAddObjectDefConstraint(playerCowID, avoidAll);
   rmAddObjectDefConstraint(playerCowID, avoidSheep);
   rmAddObjectDefConstraint(playerCowID, avoidCow);
   rmAddObjectDefConstraint(playerCowID, avoidBerries);
   rmSetObjectDefCreateHerd(playerCowID, true);
   rmPlaceObjectDefPerPlayer(playerCowID, false, 2);

   int farCowID = rmCreateObjectDef("far animals");
   if (animalChance == 2)
      rmAddObjectDefItem(farCowID, "ypYak", 2 , 4.0);
   else
      rmAddObjectDefItem(farCowID, "ypWaterBuffalo", 2 , 4.0);
   rmSetObjectDefMinDistance(farCowID, 80.0);
   rmSetObjectDefMaxDistance(farCowID, 125.0);
   rmAddObjectDefConstraint(farCowID, avoidTradeRoute);
   rmAddObjectDefConstraint(farCowID, avoidImportantItem);
   rmAddObjectDefConstraint(farCowID, circleConstraint);
   rmAddObjectDefConstraint(farCowID, avoidAll);
   rmAddObjectDefConstraint(farCowID, avoidSheep);
   rmAddObjectDefConstraint(farCowID, avoidCow);
   rmAddObjectDefConstraint(farCowID, avoidBerries);
   rmSetObjectDefCreateHerd(farCowID, true);
   rmPlaceObjectDefPerPlayer(farCowID, false, 2);

   int farBerriesID=rmCreateObjectDef("berries");
   rmAddObjectDefItem(farBerriesID, "BerryBush", 2, 4.0);
   rmSetObjectDefMinDistance(farBerriesID, 20);
   rmSetObjectDefMaxDistance(farBerriesID, 100);
   rmAddObjectDefConstraint(farBerriesID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(farBerriesID, avoidNatives);
   rmAddObjectDefConstraint(farBerriesID, avoidAll);
   rmAddObjectDefConstraint(farBerriesID, avoidTradeRoute);
   rmAddObjectDefConstraint(farBerriesID, avoidImportantItem);
   rmAddObjectDefConstraint(farBerriesID, circleConstraint);
   rmAddObjectDefConstraint(farBerriesID, avoidSheep);
   rmAddObjectDefConstraint(farBerriesID, avoidCow);
   rmAddObjectDefConstraint(farBerriesID, avoidBerries);
   rmPlaceObjectDefPerPlayer(farBerriesID, false, 3);

   silverType = rmRandInt(1,10);
   int farthestMineID=rmCreateObjectDef("player silver farthest");
   rmAddObjectDefItem(farthestMineID, "mine", 1, 0.0);
   rmAddObjectDefConstraint(farthestMineID, avoidTradeRoute);
   rmAddObjectDefConstraint(farthestMineID, coinAvoidCoin);
   rmAddObjectDefConstraint(farthestMineID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(farthestMineID, avoidWater20);
   rmAddObjectDefConstraint(farthestMineID, avoidAll);
   rmSetObjectDefMinDistance(farthestMineID, 0.0);
   rmSetObjectDefMinDistance(farthestMineID, 10.0);
   rmPlaceObjectDefInArea(farthestMineID, 0, smallContinent1ID, 1);
   rmPlaceObjectDefInArea(farthestMineID, 0, smallContinent2ID, 1);

   silverType = rmRandInt(1,10);
   int GoldMediumID=rmCreateObjectDef("player silver med");
   rmAddObjectDefItem(GoldMediumID, "mine", 1, 0.0);
   rmAddObjectDefConstraint(GoldMediumID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldMediumID, coinAvoidCoin);
   rmAddObjectDefConstraint(GoldMediumID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(GoldMediumID, avoidWater20);
   rmAddObjectDefConstraint(GoldMediumID, circleConstraint);
   rmAddObjectDefConstraint(GoldMediumID, avoidAll);
   rmSetObjectDefMinDistance(GoldMediumID, 50.0);
   rmSetObjectDefMaxDistance(GoldMediumID, 70.0);
   rmPlaceObjectDefPerPlayer(GoldMediumID, false, 1);

   silverType = rmRandInt(1,10);
   int GoldFarID=rmCreateObjectDef("player silver far");
   rmAddObjectDefItem(GoldFarID, "mine", 1, 0.0);
   rmAddObjectDefConstraint(GoldFarID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldFarID, coinAvoidCoin);
   rmAddObjectDefConstraint(GoldFarID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(GoldFarID, avoidWater20);
   rmAddObjectDefConstraint(GoldFarID, circleConstraint);
   rmAddObjectDefConstraint(GoldFarID, avoidAll);
   rmSetObjectDefMinDistance(GoldFarID, 95.0);
   rmSetObjectDefMaxDistance(GoldFarID, 110.0);
   rmPlaceObjectDefPerPlayer(GoldFarID, false, 1);

   // Text
   rmSetStatusText("",0.70);

   // Central herds
   int centralHerdID=rmCreateObjectDef("central herd");  
   rmAddObjectDefItem(centralHerdID, centerHerdType, rmRandInt(9,10), 6.0);
   rmSetObjectDefMinDistance(centralHerdID, rmXFractionToMeters(0.25));
   rmSetObjectDefMaxDistance(centralHerdID, rmXFractionToMeters(0.28));
   rmAddObjectDefConstraint(centralHerdID, avoidTradeRoute);
   rmAddObjectDefConstraint(centralHerdID, avoidImportantItem);
   rmAddObjectDefConstraint(centralHerdID, avoidWater30);
   rmAddObjectDefConstraint(centralHerdID, bisonAvoidBison);
   rmSetObjectDefCreateHerd(centralHerdID, true);

   for(i=1; <cNumberPlayers)
   {
	rmPlaceObjectDefAtLoc(centralHerdID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
   }

   // forest
   int failCount = -1;
   int numTries=13*cNumberNonGaiaPlayers;  
   failCount=0;

   for (i=0; <numTries)
   {   
      int forest=rmCreateArea("forest "+i);
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
      rmSetAreaForestType(forest, forestType);
      rmSetAreaForestDensity(forest, 1.0);
      rmSetAreaForestClumpiness(forest, 0.9);
      rmSetAreaForestUnderbrush(forest, 0.0);
      rmSetAreaCoherence(forest, 0.4);
      rmSetAreaSmoothDistance(forest, 10);
      rmAddAreaToClass(forest, rmClassID("classForest")); 
      rmAddAreaConstraint(forest, forestConstraint);
      rmAddAreaConstraint(forest, avoidAll);
      rmAddAreaConstraint(forest, avoidImpassableLand); 
      rmAddAreaConstraint(forest, avoidTradeRoute);
	rmAddAreaConstraint(forest, avoidStartingUnits);
	rmAddAreaConstraint(forest, avoidSocket);
      rmAddAreaConstraint(forest, forestsAvoidBison); 
//	rmAddAreaConstraint(forest, playerConstraintForest);

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

   // trees
   int StragglerTreeID=rmCreateObjectDef("stragglers");
   rmAddObjectDefItem(StragglerTreeID, treeType, 1, 0.0);
   rmAddObjectDefConstraint(StragglerTreeID, avoidAll);
   rmAddObjectDefConstraint(StragglerTreeID, avoidStartingUnitsSmall);
   rmSetObjectDefMinDistance(StragglerTreeID, 10.0);
   rmSetObjectDefMaxDistance(StragglerTreeID, rmXFractionToMeters(0.5));
   for(i=0; <cNumberNonGaiaPlayers*9)
      rmPlaceObjectDefAtLoc(StragglerTreeID, 0, 0.5, 0.5);

   int extraTreesID=rmCreateObjectDef("extra trees");
   rmAddObjectDefItem(extraTreesID, treeType, 5, 5.0);
   rmSetObjectDefMinDistance(extraTreesID, 17);
   rmSetObjectDefMaxDistance(extraTreesID, 20);
   rmAddObjectDefConstraint(extraTreesID, avoidAll);
   rmAddObjectDefConstraint(extraTreesID, avoidResource);
   rmAddObjectDefConstraint(extraTreesID, avoidImpassableLand);
   rmAddObjectDefConstraint(extraTreesID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraTreesID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(extraTreesID, avoidNatives);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTreesID, 0, rmAreaID("player"+i), 2);

   // Text
   rmSetStatusText("",0.90);

   // Fish
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 20.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
   int fishID=rmCreateObjectDef("fish");
   rmAddObjectDefItem(fishID, "ypFishCarp", 2, 5.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*18);

   // Whales
   int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "HumpbackWhale", 30.0);
   int whaleLand = rmCreateTerrainDistanceConstraint("whale v. land", "land", true, 15.0);
   int whaleID=rmCreateObjectDef("whale");
   rmAddObjectDefItem(whaleID, "HumpbackWhale", 1, 9.0);
   rmSetObjectDefMinDistance(whaleID, 0.0);
   rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
   rmAddObjectDefConstraint(whaleID, whaleLand);
   rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);


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


   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.5, .5, .06, 0);
   }


   rmSetStatusText("",0.99);


}  
