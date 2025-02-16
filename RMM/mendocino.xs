// ***********************************************************************************************************************************************
// ****************************************************** M E N D O C I N O **********************************************************************
// ***********************************************************************************************************************************************

// ------------------------------------------------------ Comentaries ---------------------------------------------------------------------------
// This was my firts map with triggers thanks for musketeer925 for having helped me a bit
// Work done by Rikikipu - October 2015
// Converted to winter by dicktator_ December 2018
// bwinner best otto player ever
// Thanks to Aizamk for sharing his OP UI

//------------------------------------------------------------------------------------------------------------------------------------------------

// ------------------------------------------------------ Initialization ------------------------------------------------------------------------

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{

	if (false) {
		sqrt(1);
	}

	bool isWinterSeason = false;


   rmSetStatusText("",0.01);

   int playerTiles=10850;
   if (cNumberNonGaiaPlayers >4)
		playerTiles = 9500;
   if (cNumberNonGaiaPlayers >6)
      playerTiles = 8500;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmSetMapSize(size, size);
	rmSetSeaLevel(0.0);
	rmSetMapElevationParameters(cElevTurbulence, 0.06, 2, 0.1, 5.0);
	if (isWinterSeason == true) {
		rmSetBaseTerrainMix("rockies_grass_snowa");
		rmTerrainInitialize("rockies\ground2_roc", 3.0);
		rmSetLightingSet("rockies");
	} else {
		rmSetBaseTerrainMix("flowers_grass");
		rmTerrainInitialize("great_lakes\ground_grass1_gl", 5);
		rmSetLightingSet("great plains");
	}
	rmSetMapType("california");
	rmSetMapType("land");
	rmSetWorldCircleConstraint(true);
	rmSetMapType("grass");
	rmSetMapType("namerica");

   int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;
   int subCiv3=-1;
   if (rmAllocateSubCivs(2) == true)
   {
		subCiv0=rmGetCivID("Mapuche");
		rmEchoInfo("subCiv0 is Mapuche "+subCiv0);
		if (subCiv0 >= 0)
			rmSetSubCiv(0, "Mapuche");

		subCiv1=rmGetCivID("Zapotec");
		rmEchoInfo("subCiv1 is Zapotec "+subCiv1);
		if (subCiv1 >= 0)
			rmSetSubCiv(1, "Zapotec");
                subCiv2=rmGetCivID("Zapotec");
		rmEchoInfo("subCiv2 is Zapotec "+subCiv2);
		if (subCiv2 >= 0)
			rmSetSubCiv(2, "Zapotec");
		
		subCiv3=rmGetCivID("Mapuche");
		rmEchoInfo("subCiv3 is Mapuche "+subCiv3);
		if (subCiv3 >= 0)
			rmSetSubCiv(3, "Mapuche");
   }
   int numTries = -1;
   int failCount = -1;

	chooseMercs();


// ------------------------------------------------------ Contraints ---------------------------------------------------------------------------
	int classPlayer=rmDefineClass("player");
	rmDefineClass("classPatch");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("secrets");
	rmDefineClass("natives");	
	rmDefineClass("socketClass");
	rmDefineClass("nuggets");
        rmDefineClass("classCliff");
	int pondClass=rmDefineClass("pond");

   
   // Map edge constraints
   int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5, rmXFractionToMeters(0.03),rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
   int avoidEdgeGold = rmCreatePieConstraint("Avoid Edge1",0.5,0.5, rmXFractionToMeters(0.23),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));

   // For Gold
   int stayNE = rmCreatePieConstraint("stay NE",0.5,0.5, rmXFractionToMeters(0.3),rmXFractionToMeters(0.47), rmDegreesToRadians(45),rmDegreesToRadians(145));
   int staySW = rmCreatePieConstraint("stay SW",0.5,0.5, rmXFractionToMeters(0.3),rmXFractionToMeters(0.47), rmDegreesToRadians(225),rmDegreesToRadians(325));
   int stayNE1 = rmCreatePieConstraint("stay NE1",0.5,0.5, rmXFractionToMeters(0.24),rmXFractionToMeters(0.48), rmDegreesToRadians(55),rmDegreesToRadians(140));
   int staySW1 = rmCreatePieConstraint("stay SW1",0.5,0.5, rmXFractionToMeters(0.24),rmXFractionToMeters(0.48), rmDegreesToRadians(235),rmDegreesToRadians(320));
// X marks the spot

   int avoidCenterGold3 = rmCreatePieConstraint("Avoid Center gold 3",0.5,0.5, rmXFractionToMeters(0.43),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
   // Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 10.0);
   int nuggetPlayerConstraint=rmCreateClassDistanceConstraint("nuggets stay away from players a lot", rmClassID("startingUnit"), 50.0);

   // Resource avoidance
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 25.0);
   int coinForestConstraint=rmCreateClassDistanceConstraint("coin vs. forest", rmClassID("classForest"), 15.0);
   int avoidDeer=rmCreateTypeDistanceConstraint("Deer avoids food", "bighornsheep", 50.0);
   int avoidDeerPond=rmCreateTypeDistanceConstraint("Deer avoids food1", "bighornsheep", 10.0);
   int avoidElk=rmCreateTypeDistanceConstraint("Elk avoids food", "Elk", 50.0);
   int avoidElkShort=rmCreateTypeDistanceConstraint("Elk avoids food short", "Elk", 15.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 35.0);
   int avoidCoinPond=rmCreateTypeDistanceConstraint("pond avoids coin", "gold", 12.0);
   int avoidCoinShort=rmCreateTypeDistanceConstraint("avoids coin short", "gold", 8.0);
   int avoidStartingCoin=rmCreateTypeDistanceConstraint("starting coin avoids coin", "gold", 28.0);
   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 43.0);
   int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 6.0);
   int avoidNuggetSmall1=rmCreateTypeDistanceConstraint("avoid nuggets by a little1", "AbstractNugget", 8.0);
   int avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", 63);
   int avoidFastCoinTeam=rmCreateTypeDistanceConstraint("fast coin avoids coin team", "gold", 72);
   int avoidDeerShort = rmCreateTypeDistanceConstraint("avoid Deer short", "bighornsheep", 15.0);

   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);

   // Unit avoidance - for things that aren't in the starting resources.
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidStartingUnitsTree=rmCreateClassDistanceConstraint("objects avoid starting units1", rmClassID("startingUnit"), 10.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);
   int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 50.0);
   int avoidTownCenterFar1=rmCreateTypeDistanceConstraint("avoid Town Center Far 1", "townCenter", 40.0);
   int avoidTownCenterFar2=rmCreateTypeDistanceConstraint("avoid Town Center Far team", "townCenter", 60.0);
   int avoidPondMine=rmCreateClassDistanceConstraint("mines avoid Pond", pondClass, 20.0);
   
   

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // VP avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 6.0);
   int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("trade route small", 4.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("important stuff avoids each other", rmClassID("importantItem"), 15.0);
   int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 6.0);
   int avoidSocketMore=rmCreateClassDistanceConstraint("bigger socket avoidance", rmClassID("socketClass"), 10.0);

   // Constraint to avoid water.
   int avoidWater = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 50.0);

   // Avoid the Cliffs.
   int avoidCliffs = rmCreateClassDistanceConstraint("avoid Cliffs", rmClassID("classCliff"), 10.0);
   int avoidCliffsFar = rmCreateClassDistanceConstraint("avoid Cliffs far", rmClassID("classCliff"), 15.0);
	
   // natives avoid natives
   int avoidNatives = rmCreateClassDistanceConstraint("avoid Natives", rmClassID("natives"), 10.0);
   int avoidNativesWood = rmCreateClassDistanceConstraint("avoid Natives wood", rmClassID("natives"), 6.0);
   int avoidNativesNuggets = rmCreateClassDistanceConstraint("nuggets avoid Natives", rmClassID("natives"), 20.0);

   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));


  									 rmSetStatusText("",0.10);

// ------------------------------------------------------ KOTH for noobs ---------------------------------------------------------------------

  if (rmGetIsKOTH()) {

    int randLoc = rmRandInt(1,3);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.03;

    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }
	
// ------------------------------------------------------ Trade Route ---------------------------------------------------------------------------
   int tradeRouteID = rmCreateTradeRoute();
   int tradeRouteID1 = rmCreateTradeRoute();

   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
   int socketIDB=rmCreateObjectDef("sockets to dock Trade Posts B");
   rmSetObjectDefTradeRouteID(socketIDB, tradeRouteID);
   int socketID1=rmCreateObjectDef("sockets to dock Trade Posts1");
   rmSetObjectDefTradeRouteID(socketID1, tradeRouteID1);
   int socketID1B=rmCreateObjectDef("sockets to dock Trade Posts1 B");
   rmSetObjectDefTradeRouteID(socketID1B, tradeRouteID1);



   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 6.0);

   rmAddObjectDefItem(socketIDB, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketIDB, true);
   rmAddObjectDefToClass(socketIDB, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketIDB, 0.0);
   rmSetObjectDefMaxDistance(socketIDB, 6.0);

   rmAddObjectDefItem(socketID1, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID1, true);
   rmAddObjectDefToClass(socketID1, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketID1, 0.0);
   rmSetObjectDefMaxDistance(socketID1, 6.0);

   rmAddObjectDefItem(socketID1B, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID1B, true);
   rmAddObjectDefToClass(socketID1B, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketID1B, 0.0);
   rmSetObjectDefMaxDistance(socketID1B, 6.0);

if (cNumberNonGaiaPlayers <3)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.15, 0.85);
   rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.42, 0.52, 2, 4);
   rmAddTradeRouteWaypoint(tradeRouteID1, 0.85, 0.15);
   rmAddRandomTradeRouteWaypoints(tradeRouteID1, 0.58, 0.48, 2, 4);
}
else
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.15, 0.85);
   rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.42, 0.58, 2, 4);
   rmAddTradeRouteWaypoint(tradeRouteID1, 0.85, 0.15);
   rmAddRandomTradeRouteWaypoints(tradeRouteID1, 0.58, 0.42, 2, 4);
}


   bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
   bool placedTradeRoute1 = rmBuildTradeRoute(tradeRouteID1, "dirt");


    vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.85);
    rmPlaceObjectDefAtPoint(socketIDB, 0, socketLoc);

     socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.15);
     rmPlaceObjectDefAtPoint(socketID1, 0, socketLoc);
     socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.85);
     rmPlaceObjectDefAtPoint(socketID1B, 0, socketLoc);

   								rmSetStatusText("",0.20);

// ------------------------------------------------------ Player Location and Specific Area ---------------------------------------------------------------------------

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);


		teamZeroCount = cNumberNonGaiaPlayers/2;
		teamOneCount = cNumberNonGaiaPlayers/2;

		if (cNumberTeams ==2)
		{
			if (cNumberNonGaiaPlayers ==2){
			if (rmRandFloat(0,1)<0.5)
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.02, 0.24);
				rmPlacePlayersCircular(0.35, 0.36, 0);

				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.52, 0.74);
				rmPlacePlayersCircular(0.35, 0.36, 0);
			}
			else
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.02, 0.24);
				rmPlacePlayersCircular(0.35, 0.36, 0);

				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.52, 0.74);
				rmPlacePlayersCircular(0.35, 0.36, 0);
		   }
		   }
		   else {
			   	rmSetPlacementTeam(0);
				rmSetPlacementSection(0.05, 0.21);
				rmPlacePlayersCircular(0.35, 0.36, 0);

				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.55, 0.71);
				rmPlacePlayersCircular(0.35, 0.36, 0);
		   }
		 }
		else
		{
			rmSetTeamSpacingModifier(0.25);
			rmPlacePlayersCircular(0.38, 0.40, 0.0);
		}

   
   for(i=0; <cNumberNonGaiaPlayers*3)
   {
   int newGrass = rmCreateArea("new grass"+i);
   rmSetAreaLocation(newGrass, rmRandFloat(0.05,0.95), rmRandFloat(0.05,0.95)); 
   rmSetAreaWarnFailure(newGrass, false);
   rmSetAreaSize(newGrass,rmXMetersToFraction(6), rmXMetersToFraction(6));
   rmSetAreaCoherence(newGrass, 0);
   rmSetAreaSmoothDistance(newGrass, 1);
   rmAddAreaConstraint(newGrass, avoidCliffs);
   rmSetAreaObeyWorldCircleConstraint(newGrass, false);
   rmAddAreaToClass(newGrass, rmClassID("classPatch"));
   if (isWinterSeason == true) {
		rmSetAreaTerrainType(newGrass, "rockies\ground2_roc");
		rmSetAreaMix(newGrass, "rockies_grass_snowa");
   } else {
		rmSetAreaTerrainType(newGrass, "great_lakes\ground_grass1_gl");
		rmSetAreaMix(newGrass, "flowers_grass");
   }
   rmBuildArea(newGrass);
   }


      // Changing grass
   for(i=0; <cNumberNonGaiaPlayers*5)
   {
   int newGrass2 = rmCreateArea("new grass2"+i);
   rmSetAreaLocation(newGrass2, rmRandFloat(0.05,0.95), rmRandFloat(0.05,0.95)); 
   rmSetAreaWarnFailure(newGrass2, false);
   rmSetAreaSize(newGrass2, rmXMetersToFraction(6), rmXMetersToFraction(6));
   rmSetAreaCoherence(newGrass2, 0);
   rmSetAreaSmoothDistance(newGrass2, 1);
   rmAddAreaConstraint(newGrass2, avoidCliffs);
   rmAddAreaConstraint(newGrass2, patchConstraint);
   rmSetAreaObeyWorldCircleConstraint(newGrass2, false);
   rmAddAreaToClass(newGrass2, rmClassID("classPatch"));
   if (isWinterSeason == true) {
		rmSetAreaTerrainType(newGrass2, "rockies\ground2_roc");
		rmSetAreaMix(newGrass2, "rockies_grass_snowa");
   } else {
		rmSetAreaTerrainType(newGrass2, "great_lakes\ground_grass2_gl");
		rmSetAreaMix(newGrass2, "flowers_grass");
   }
   rmBuildArea(newGrass2);
   }
   
      // Changing grass
   for(i=0; <cNumberNonGaiaPlayers*4)
   {
   int newGrass3 = rmCreateArea("new grass3"+i);
   rmSetAreaLocation(newGrass3, rmRandFloat(0.05,0.95), rmRandFloat(0.05,0.95)); 
   rmSetAreaWarnFailure(newGrass3, false);
   rmSetAreaSize(newGrass3, rmXMetersToFraction(8), rmXMetersToFraction(8));
   rmSetAreaCoherence(newGrass3, 0);
   rmSetAreaSmoothDistance(newGrass3, 1);
   rmAddAreaConstraint(newGrass3, avoidCliffs);
   rmAddAreaConstraint(newGrass3, patchConstraint);
   rmSetAreaObeyWorldCircleConstraint(newGrass3, false);
   rmAddAreaToClass(newGrass3, rmClassID("classPatch"));
   if (isWinterSeason == true) {
		rmSetAreaTerrainType(newGrass3, "rockies\ground2_roc");
		rmSetAreaMix(newGrass3, "rockies_grass_snowa");
   } else {
		rmSetAreaTerrainType(newGrass3, "great_lakes\ground_grass3_gl");
		rmSetAreaMix(newGrass3, "flowers_grass");
   }
   rmBuildArea(newGrass3);
   }
  
  
   
   
// Cliff

   numTries=1;
   failCount=0;
   for(i=0; <numTries)
   {
      int cliffID=rmCreateArea("cliff"+i);
	rmSetAreaLocation(cliffID, 0.62, 0.62);
	  rmSetAreaSize(cliffID, rmAreaTilesToFraction(110+cNumberNonGaiaPlayers*110), rmAreaTilesToFraction(110+cNumberNonGaiaPlayers*110));
      rmSetAreaWarnFailure(cliffID, false);
      rmSetAreaCliffEdge(cliffID, 1, 1);
	  if (isWinterSeason == true) {
			rmSetAreaCliffType(cliffID, "rocky mountain2");
			rmSetAreaTerrainType(cliffID, "rockies\groundforestsnow_roc");
	  } else {
			rmSetAreaCliffType(cliffID, "mendocino");
			rmSetAreaTerrainType(cliffID, "great_lakes\ground_shoreline3_gl");
			rmSetAreaCliffPainting(cliffID, true, true, true, 1.5, true);
	  }
      rmSetAreaCliffHeight(cliffID, -8, 1.0, 0.5);
      rmSetAreaHeightBlend(cliffID, 1);
      rmAddAreaToClass(cliffID, rmClassID("classCliff")); 
      rmSetAreaSmoothDistance(cliffID, 0);
      rmSetAreaCoherence(cliffID, 0.60);

      if(rmBuildArea(cliffID)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==6)
            break;
      }
      else
         failCount=0;
   }

   numTries=1;
   failCount=0;
   for(i=0; <numTries)
   {
      int cliffID1=rmCreateArea("cliff1"+i);
	rmSetAreaLocation(cliffID1, 0.38, 0.38);
	  rmSetAreaSize(cliffID1, rmAreaTilesToFraction(110+cNumberNonGaiaPlayers*110), rmAreaTilesToFraction(110+cNumberNonGaiaPlayers*110));
      rmSetAreaWarnFailure(cliffID1, false);
      rmSetAreaCliffEdge(cliffID1, 1, 1);
	  if (isWinterSeason == true) {
			rmSetAreaCliffType(cliffID1, "rocky mountain2");
			rmSetAreaTerrainType(cliffID1, "rockies\groundforestsnow_roc");
	  } else {
			rmSetAreaCliffType(cliffID1, "mendocino");
			rmSetAreaTerrainType(cliffID1, "great_lakes\ground_shoreline3_gl");
			rmSetAreaCliffPainting(cliffID1, true, true, true, 1.5, true);
	  }
      rmSetAreaCliffHeight(cliffID1, -8, 1.0, 0.5);
      rmSetAreaHeightBlend(cliffID1, 1);
      rmAddAreaToClass(cliffID1, rmClassID("classCliff")); 
      rmSetAreaSmoothDistance(cliffID1, 0);
      rmSetAreaCoherence(cliffID1, 0.60);

      if(rmBuildArea(cliffID1)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==6)
            break;
      }
      else
         failCount=0;
   }
   
   	int gunFloor = rmCreateObjectDef("gunFloor 1");
	rmAddObjectDefItem(gunFloor, "CrateofXP", 1, 1.0);
	rmSetObjectDefMinDistance(gunFloor, 0.0);
	rmSetObjectDefMaxDistance(gunFloor, 0.0);
//	rmPlaceObjectDefAtLoc(gunFloor, 0, 0.62, 0.62);

	
	   	int gunFloor1 = rmCreateObjectDef("gunFloor");
	rmAddObjectDefItem(gunFloor1, "CrateofXP", 1, 1.0);
	rmSetObjectDefMinDistance(gunFloor1, 0.0);
	rmSetObjectDefMaxDistance(gunFloor1, 0.0);
//	rmPlaceObjectDefAtLoc(gunFloor1, 0, 0.38, 0.38);
	
  								 rmSetStatusText("",0.30);


   if (subCiv0 == rmGetCivID("Mapuche"))
   {  
      int MapucheVillageAID = -1;
      MapucheVillageAID = rmCreateGrouping("mapuche village A", "native mapuche village "+rmRandInt(1,4));
      rmSetGroupingMinDistance(MapucheVillageAID, 0.00);
      rmSetGroupingMaxDistance(MapucheVillageAID, 0.00);
      rmAddGroupingConstraint(MapucheVillageAID, avoidImpassableLand);
      rmAddGroupingToClass(MapucheVillageAID, rmClassID("natives"));
      rmPlaceGroupingAtLoc(MapucheVillageAID, 0, 0.2, 0.65);
	}

   if (subCiv1 == rmGetCivID("Zapotec"))
   {   
      int ZapotecVillageAID = -1;
      ZapotecVillageAID = rmCreateGrouping("Zapotec village A", "native Zapotec village "+rmRandInt(1,4));
      rmSetGroupingMinDistance(ZapotecVillageAID, 0.0);
     rmSetGroupingMaxDistance(ZapotecVillageAID, 0.00);
      rmAddGroupingConstraint(ZapotecVillageAID, avoidImpassableLand);
      rmAddGroupingToClass(ZapotecVillageAID, rmClassID("natives"));
      rmPlaceGroupingAtLoc(ZapotecVillageAID, 0, 0.65, 0.2); 
	}
	if(subCiv2 == rmGetCivID("Zapotec"))
   {   
      int ZapotecVillageID = -1;
      ZapotecVillageID = rmCreateGrouping("Zapotec village", "native Zapotec village "+rmRandInt(1,4));
      rmSetGroupingMinDistance(ZapotecVillageID, 0.0);
      rmSetGroupingMaxDistance(ZapotecVillageID, 4);
      rmAddGroupingConstraint(ZapotecVillageID, avoidImpassableLand);
      rmAddGroupingToClass(ZapotecVillageID, rmClassID("natives"));
      rmPlaceGroupingAtLoc(ZapotecVillageID, 0, 0.35, 0.8);
   }

	if(subCiv3 == rmGetCivID("Mapuche"))
   {   
      int MapucheVillageBID = -1;
      MapucheVillageBID = rmCreateGrouping("mapuche village ", "native mapuche village "+rmRandInt(1,4));
      rmSetGroupingMinDistance(MapucheVillageBID, 0.0);
      rmSetGroupingMaxDistance(MapucheVillageBID, 4);
      rmAddGroupingConstraint(MapucheVillageBID, avoidImpassableLand);
      rmAddGroupingToClass(MapucheVillageBID, rmClassID("natives"));
      rmPlaceGroupingAtLoc(MapucheVillageBID, 0, 0.8, 0.35);
   }




// ------------------------------------------------------ Starting Ressources ---------------------------------------------------------------------------


	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 10.0);

	int startingTCID = rmCreateObjectDef("startingTC");
	if ( rmGetNomadStart())
	{
		rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
	}
	rmAddObjectDefToClass(startingTCID, rmClassID("startingUnit"));
	rmSetObjectDefMinDistance(startingTCID, 0.0);
	rmSetObjectDefMaxDistance(startingTCID, 5.0);

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	if (isWinterSeason == true) {
		rmAddObjectDefItem(StartAreaTreeID, "TreeRockiesSnow", 1, 0.0);
	} else {
		rmAddObjectDefItem(StartAreaTreeID, "TreeRockies", 1, 0.0);
	}
	rmSetObjectDefMinDistance(StartAreaTreeID, 12.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 25.0);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);

	int StartDeerID1=rmCreateObjectDef("starting Deer");
	rmAddObjectDefItem(StartDeerID1, "bighornsheep", 5, 5.0);
	rmSetObjectDefMinDistance(StartDeerID1, 12.0);
	rmSetObjectDefMaxDistance(StartDeerID1, 14.0);
	rmSetObjectDefCreateHerd(StartDeerID1, false);
	rmAddObjectDefConstraint(StartDeerID1, avoidStartingUnitsSmall);

	int StartDeerID11=rmCreateObjectDef("starting Deer1");
	rmAddObjectDefItem(StartDeerID11, "bighornsheep", rmRandInt(13,13), 7.0);
	rmSetObjectDefMinDistance(StartDeerID11, 36.0);
	rmSetObjectDefMaxDistance(StartDeerID11, 38.0);
	rmSetObjectDefCreateHerd(StartDeerID11, true);
	rmAddObjectDefConstraint(StartDeerID11, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(StartDeerID11, avoidNatives);
	rmAddObjectDefConstraint(StartDeerID11, avoidCliffs);

	int StartElkID1=rmCreateObjectDef("starting elk");
	rmAddObjectDefItem(StartElkID1, "Elk", rmRandInt(9,9), 7.0);
	rmSetObjectDefMinDistance(StartElkID1, 46.0);
	rmSetObjectDefMaxDistance(StartElkID1, 48.0);
	rmSetObjectDefCreateHerd(StartElkID1, true);
	rmAddObjectDefConstraint(StartElkID1, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(StartElkID1, avoidNatives);
	rmAddObjectDefConstraint(StartElkID1, avoidCliffs);
	rmAddObjectDefConstraint(StartElkID1, avoidDeer);


	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
	rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
	rmAddObjectDefToClass(playerNuggetID, rmClassID("startingUnit"));
    rmSetObjectDefMinDistance(playerNuggetID, 23.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 32.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
	rmAddObjectDefConstraint(playerNuggetID, avoidNativesNuggets);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
	// rmAddObjectDefConstraint(playerNuggetID, avoidImportantItem);

	
	int silverType = -1;
	int playerGoldID = -1;

 	for(i=1; <=cNumberNonGaiaPlayers)
	{
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
    		if(ypIsAsian(i) && rmGetNomadStart() == false)
      		rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Everyone gets two ore ObjectDefs, one pretty close, the other a little further away.

		silverType = rmRandInt(1,10);
		playerGoldID = rmCreateObjectDef("player silver closer "+i);
		rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
		rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(playerGoldID, avoidStartingCoin);
		rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
		rmSetObjectDefMinDistance(playerGoldID, 15.0);
		rmSetObjectDefMaxDistance(playerGoldID, 16.0);

		int startSilver3ID = rmCreateObjectDef("player farther silver"+i);
		rmAddObjectDefItem(startSilver3ID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(startSilver3ID, 65.0);
		rmSetObjectDefMaxDistance(startSilver3ID, 70.0);
		rmAddObjectDefConstraint(startSilver3ID, avoidAll);
		rmAddObjectDefConstraint(startSilver3ID, avoidFastCoin);
		rmAddObjectDefConstraint(startSilver3ID, avoidCliffs);
		rmAddObjectDefConstraint(startSilver3ID, avoidCenterGold3);


		// Place  gold mines

	if (cNumberNonGaiaPlayers ==2)
	{
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}

	if (cNumberNonGaiaPlayers >2)
	{
		rmPlaceObjectDefAtLoc(startSilver3ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}


		// Placing starting trees...
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	    	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		rmPlaceObjectDefAtLoc(StartDeerID1, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartDeerID11, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartElkID1, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}
	if (cNumberNonGaiaPlayers>2)
	{
	int mineb=rmAddFairLoc("TownCenter", false, false, 18, 19, 12, 5); 
	rmAddObjectDefConstraint(mineb, avoidStartingCoin);
	rmAddObjectDefConstraint(mineb, avoidStartingUnitsSmall);

	if(rmPlaceFairLocs())
	{
	mineb=rmCreateObjectDef("mine behind");
	rmAddObjectDefItem(mineb, "mine", 1, 0.0);
	for(i=1; <cNumberNonGaiaPlayers+1)
		{
	for(j=0; <rmGetNumberFairLocs(i))
			{
	rmPlaceObjectDefAtLoc(mineb, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
			}
		}
	}
	else // fallback, mainly for observer mode where fairloc always fails
	{
		for(i=1; <=cNumberNonGaiaPlayers)
		{
			rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		}
	}

	int minef=rmAddFairLoc("TownCenter", true, true, 18, 19, 12, 5);
	rmAddObjectDefConstraint(minef, avoidStartingCoin);
	rmAddObjectDefConstraint(minef, avoidStartingUnitsSmall);


	if(rmPlaceFairLocs())
	{
	minef=rmCreateObjectDef("forward mine");
	rmAddObjectDefItem(minef, "mine", 1, 0.0);
	for(i=1; <cNumberNonGaiaPlayers+1)
	{
	for(j=1; <rmGetNumberFairLocs(i))
	{
	rmPlaceObjectDefAtLoc(minef, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
	}
	}
	}
	else // fallback, mainly for observer mode where fairloc always fails
	{
		for(i=1; <=cNumberNonGaiaPlayers)
		{
			rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		}
	}
	}

							   rmSetStatusText("",0.60);


// ------------------------------------------------------ Natives & Nuggets & Design ---------------------------------------------------------------------------

 

	// Ponds o' Fun
   int pondConstraint=rmCreateClassDistanceConstraint("ponds avoid ponds", rmClassID("pond"), 50.0);
	
   int numPonds=cNumberNonGaiaPlayers+2;
 
if(cNumberNonGaiaPlayers ==2)
{
         int smallPondID=rmCreateArea("small pond");
      rmSetAreaSize(smallPondID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(140));
	  rmSetAreaLocation(smallPondID, 0.13, 0.37);
	  if (isWinterSeason == true) {
		  rmSetAreaWaterType(smallPondID, "great lakes ice");
	  } else {
		  rmSetAreaWaterType(smallPondID, "rockies water");
	  }
      rmSetAreaBaseHeight(smallPondID, 4);
      rmSetAreaMinBlobs(smallPondID, 1);
      rmSetAreaMaxBlobs(smallPondID, 2);
      rmSetAreaMinBlobDistance(smallPondID, 0.0);
      rmSetAreaMaxBlobDistance(smallPondID, 2.0);
      rmAddAreaToClass(smallPondID, pondClass);
      rmSetAreaCoherence(smallPondID, 0.2);
      rmSetAreaSmoothDistance(smallPondID, 5);
      rmBuildArea(smallPondID);
   
   
   
      int smallPondID2=rmCreateArea("small pond2");
      rmSetAreaSize(smallPondID2, rmAreaTilesToFraction(100), rmAreaTilesToFraction(140));
	  rmSetAreaLocation(smallPondID2, 0.87, 0.63);
	  if (isWinterSeason == true) {
		  rmSetAreaWaterType(smallPondID2, "great lakes ice");
	  } else {
		  rmSetAreaWaterType(smallPondID2, "rockies water");
	  }
      rmSetAreaBaseHeight(smallPondID2, 4);
      rmSetAreaMinBlobs(smallPondID2, 1);
      rmSetAreaMaxBlobs(smallPondID2, 2);
      rmSetAreaMinBlobDistance(smallPondID2, 0.0);
      rmSetAreaMaxBlobDistance(smallPondID2, 2.0);
      rmAddAreaToClass(smallPondID2, pondClass);
      rmSetAreaCoherence(smallPondID2, 0.2);
      rmSetAreaSmoothDistance(smallPondID2, 5);
      rmBuildArea(smallPondID2);
}

							   rmSetStatusText("",0.80);



// ------------------------------------------------------ Others Ressources ---------------------------------------------------------------------------


	int silverID = -1;
	int silverID1 = -1;
	int silverID2 = -1;
	int silverCount = cNumberNonGaiaPlayers*2; 
	int silverID3 = -1;

		silverType = rmRandInt(1,10);
if (cNumberNonGaiaPlayers==2)	
{	
	for(i=0; < 3)
	{
		silverType = rmRandInt(1,10);
		silverID = rmCreateObjectDef("silver "+i);
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverID, avoidFastCoin);
		rmAddObjectDefConstraint(silverID, avoidAll);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(silverID, avoidSocketMore);
		rmAddObjectDefConstraint(silverID, avoidCliffs);
		rmAddObjectDefConstraint(silverID, avoidPondMine);
        rmAddObjectDefConstraint(silverID, stayNE);		
		int result1 = rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
		if(result1 == 0)
			break;
		
   	}
	
		for(i=0; < 3)
	{

		silverID2 = rmCreateObjectDef("silver 1"+i);
		rmAddObjectDefItem(silverID2, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID2, 0.0);
		rmSetObjectDefMaxDistance(silverID2, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverID2, avoidFastCoin);
		rmAddObjectDefConstraint(silverID2, avoidAll);
		rmAddObjectDefConstraint(silverID2, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID2, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(silverID2, avoidSocketMore);
		rmAddObjectDefConstraint(silverID2, avoidCliffs);
		rmAddObjectDefConstraint(silverID2, avoidPondMine);
        rmAddObjectDefConstraint(silverID2, staySW);		
		int result2 = rmPlaceObjectDefAtLoc(silverID2, 0, 0.5, 0.5);
		if(result2 == 0)
			break;
		
   	}
}
else
{
	for(i=0; < silverCount)
	{
		silverID3 = rmCreateObjectDef("silver for team "+i);
		rmAddObjectDefItem(silverID3, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID3, 0.0);
		rmSetObjectDefMaxDistance(silverID3, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverID3, avoidFastCoinTeam);
		rmAddObjectDefConstraint(silverID3, avoidAll);
		rmAddObjectDefConstraint(silverID3, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID3, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(silverID3, avoidSocketMore);
		rmAddObjectDefConstraint(silverID3, avoidCliffs);
		rmAddObjectDefConstraint(silverID3, avoidPondMine);	
		int result3 = rmPlaceObjectDefAtLoc(silverID3, 0, 0.5, 0.5);
		if(result3 == 0)
			break;
		
   	}
}	
	
// Small ponds for team	
if (cNumberNonGaiaPlayers >2)
{
   for(i=0; <cNumberNonGaiaPlayers*2)
   {		
	      int smallPondID3=rmCreateArea("small pond3"+i);
      rmSetAreaSize(smallPondID3, rmAreaTilesToFraction(70), rmAreaTilesToFraction(90));
      rmSetAreaWaterType(smallPondID3, "rockies water");
      rmSetAreaBaseHeight(smallPondID3, 4);
      rmSetAreaMinBlobs(smallPondID3, 1);
      rmSetAreaMaxBlobs(smallPondID3, 2);
      rmSetAreaMinBlobDistance(smallPondID3, 0.0);
      rmSetAreaMaxBlobDistance(smallPondID3, 2.0);
      rmAddAreaToClass(smallPondID3, pondClass);
      rmSetAreaCoherence(smallPondID3, 0.05);
      rmSetAreaSmoothDistance(smallPondID3, 5);
	  rmAddAreaConstraint(smallPondID3, pondConstraint);
      rmAddAreaConstraint(smallPondID3, avoidTradeRoute);
      rmAddAreaConstraint(smallPondID3, avoidSocket);
      rmAddAreaConstraint(smallPondID3, avoidCliffsFar);
      rmAddAreaConstraint(smallPondID3, avoidStartingUnits);
      rmAddAreaConstraint(smallPondID3, avoidNativesWood);
      rmAddAreaConstraint(smallPondID3, avoidCoinShort);
      rmBuildArea(smallPondID3);	
   }	
		
}	
		


  // RANDOM TREES
   numTries=8*cNumberNonGaiaPlayers;
   failCount=0;
   for (i=0; <numTries)
   {   
		int forest=rmCreateArea("forest "+i);
		rmSetAreaWarnFailure(forest, false);
		rmSetAreaSize(forest, rmAreaTilesToFraction(100), rmAreaTilesToFraction(140));
		if (isWinterSeason == true) {
			rmSetAreaForestType(forest, "rockies snow forest");
		} else {
			rmSetAreaForestType(forest, "mendocino Forest");
		}
		rmSetAreaForestDensity(forest, 0.8);
		rmSetAreaForestClumpiness(forest, 0.1);
		rmSetAreaForestUnderbrush(forest, 0.5);
		rmSetAreaCoherence(forest, 0.5);
		rmAddAreaToClass(forest, rmClassID("classForest")); 
		rmAddAreaConstraint(forest, forestConstraint);
		rmAddAreaConstraint(forest, avoidTownCenterFar1);
		rmAddAreaConstraint(forest, avoidImportantItem);
		rmAddAreaConstraint(forest, avoidImpassableLand);
		rmAddAreaConstraint(forest, avoidCliffs);
	    rmAddAreaConstraint(forest, avoidTradeRoute);
		rmAddAreaConstraint(forest, avoidSocket);
		rmAddAreaConstraint(forest, avoidNuggetSmall);
		rmAddAreaConstraint(forest, avoidStartingUnitsTree);
		rmAddAreaConstraint(forest, avoidNatives);
                rmAddAreaConstraint(forest, avoidCoinShort);
		rmAddAreaConstraint(forest, avoidAll);
		rmAddAreaConstraint(forest, avoidCenter);
		if(rmBuildArea(forest)==false)
		{
			// Stop trying once we fail 10 times in a row.
			failCount++;
			if(failCount==10)
			break;
		}
		else
			failCount=0; 
   }


   numTries=10;
   failCount=0;
   for (i=0; <numTries)
   {   
		int forest2=rmCreateArea("near "+i);
		rmSetAreaWarnFailure(forest2, false);
		rmSetAreaSize(forest2, rmAreaTilesToFraction(60), rmAreaTilesToFraction(80));
		if (isWinterSeason == true) {
			rmSetAreaForestType(forest2, "rockies snow forest");
		} else {
			rmSetAreaForestType(forest2, "mendocino forest");
		}
		rmSetAreaForestDensity(forest2, 0.8);
		rmSetAreaForestClumpiness(forest2, 0.1);
		rmSetAreaForestUnderbrush(forest2, 0.9);
		rmSetAreaCoherence(forest2, 0.5);
		rmAddAreaToClass(forest2, rmClassID("classForest")); 
		rmAddAreaConstraint(forest2, forestConstraint);
		rmAddAreaConstraint(forest2, playerConstraint);
		rmAddAreaConstraint(forest2, avoidTownCenterFar1);
		rmAddAreaConstraint(forest2, avoidImportantItem);
		rmAddAreaConstraint(forest2, avoidImpassableLand);
		rmAddAreaConstraint(forest2, avoidCliffs);
		rmAddAreaConstraint(forest2, avoidTradeRoute);
		rmAddAreaConstraint(forest2, avoidSocket);
		rmAddAreaConstraint(forest2, avoidNuggetSmall);
		rmAddAreaConstraint(forest2, avoidStartingUnitsTree);
                rmAddAreaConstraint(forest2, avoidCoinShort);
                rmAddAreaConstraint(forest2, avoidNatives);
		rmAddAreaConstraint(forest2, avoidAll);
		if(rmBuildArea(forest2)==false)
		{
			// Stop trying once we fail 10 times in a row.
			failCount++;
			if(failCount==10)
			break;
		}
		else
			failCount=0; 
   }

   if (cNumberNonGaiaPlayers==2)
   {
  	// Elk	
   int ElkID=rmCreateObjectDef("Elk herd");
   rmAddObjectDefItem(ElkID, "Elk", rmRandInt(7,10), 8.0);
   rmSetObjectDefMinDistance(ElkID, 0.0);
   rmSetObjectDefMaxDistance(ElkID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(ElkID, avoidDeer);
   rmAddObjectDefConstraint(ElkID, avoidElk);
	rmAddObjectDefConstraint(ElkID, avoidAll);
   rmAddObjectDefConstraint(ElkID, avoidImpassableLand);
	//rmAddObjectDefConstraint(ElkID, avoidTradeRoute);
	rmAddObjectDefConstraint(ElkID, avoidSocket);
	rmAddObjectDefConstraint(ElkID, avoidTownCenterFar);
	rmAddObjectDefConstraint(ElkID, avoidCliffs);
	rmAddObjectDefConstraint(ElkID, avoidCoinShort);
	rmAddObjectDefConstraint(ElkID, avoidNatives);
	rmAddObjectDefConstraint(ElkID, staySW1);
   rmSetObjectDefCreateHerd(ElkID, true);
	rmPlaceObjectDefAtLoc(ElkID, 0, 0.5, 0.5, 1); 
   
   
   

	// Elk	
   int ElkID1=rmCreateObjectDef("Elk herd1");
   rmAddObjectDefItem(ElkID1, "Elk", rmRandInt(7,10), 8.0);
   rmSetObjectDefMinDistance(ElkID1, 0.0);
   rmSetObjectDefMaxDistance(ElkID1, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(ElkID1, avoidDeer);
   rmAddObjectDefConstraint(ElkID1, avoidElk);
	rmAddObjectDefConstraint(ElkID1, avoidAll);
   rmAddObjectDefConstraint(ElkID1, avoidImpassableLand);
	//rmAddObjectDefConstraint(ElkID1, avoidTradeRoute);
	rmAddObjectDefConstraint(ElkID1, avoidSocket);
	rmAddObjectDefConstraint(ElkID1, avoidTownCenterFar);
	rmAddObjectDefConstraint(ElkID1, avoidCliffs);
	rmAddObjectDefConstraint(ElkID1, avoidCoinShort);
	rmAddObjectDefConstraint(ElkID1, avoidNatives);
	rmAddObjectDefConstraint(ElkID1, stayNE1);
   rmSetObjectDefCreateHerd(ElkID1, true);
	rmPlaceObjectDefAtLoc(ElkID1, 0, 0.5, 0.5, 1);
	
	
		// Deer	
   int DeerID=rmCreateObjectDef("Deer herd");
   rmAddObjectDefItem(DeerID, "bighornsheep", rmRandInt(9,12), 8.0);
   rmSetObjectDefMinDistance(DeerID, 0.0);
   rmSetObjectDefMaxDistance(DeerID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(DeerID, avoidDeer);
   rmAddObjectDefConstraint(DeerID, avoidElk);
	rmAddObjectDefConstraint(DeerID, avoidAll);
   rmAddObjectDefConstraint(DeerID, avoidImpassableLand);
	rmAddObjectDefConstraint(DeerID, avoidSocket);
	rmAddObjectDefConstraint(DeerID, avoidStartingUnits);
	rmAddObjectDefConstraint(DeerID, avoidCliffs);
	rmAddObjectDefConstraint(DeerID, avoidTownCenterFar);
	rmAddObjectDefConstraint(DeerID, avoidCoinShort);
	rmAddObjectDefConstraint(DeerID, avoidNatives);
	rmAddObjectDefConstraint(DeerID, staySW1);
    rmSetObjectDefCreateHerd(DeerID, true);
	rmPlaceObjectDefAtLoc(DeerID, 0, 0.5, 0.5, 2);	
	
	
	// Deer	
   int DeerID1=rmCreateObjectDef("Deer herd1");
   rmAddObjectDefItem(DeerID1, "bighornsheep", rmRandInt(9,12), 8.0);
   rmSetObjectDefMinDistance(DeerID1, 0.0);
   rmSetObjectDefMaxDistance(DeerID1, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(DeerID1, avoidDeer);
   rmAddObjectDefConstraint(DeerID1, avoidElk);
	rmAddObjectDefConstraint(DeerID1, avoidAll);
   rmAddObjectDefConstraint(DeerID1, avoidImpassableLand);
	rmAddObjectDefConstraint(DeerID1, avoidSocket);
	rmAddObjectDefConstraint(DeerID1, avoidStartingUnits);
	rmAddObjectDefConstraint(DeerID1, avoidCliffs);
	rmAddObjectDefConstraint(DeerID1, avoidTownCenterFar);
	rmAddObjectDefConstraint(DeerID1, avoidCoinShort);
	rmAddObjectDefConstraint(DeerID1, avoidNatives);
	rmAddObjectDefConstraint(DeerID1, stayNE1);
    rmSetObjectDefCreateHerd(DeerID1, true);
	rmPlaceObjectDefAtLoc(DeerID1, 0, 0.5, 0.5, 2);	
	
	
   int ElkID2=rmCreateObjectDef("Elk herd2");
   rmAddObjectDefItem(ElkID2, "Elk", 5, 6.0);
   rmSetObjectDefMinDistance(ElkID2, 0.0);
   rmSetObjectDefMaxDistance(ElkID2, 5.0);
   rmAddObjectDefConstraint(ElkID2, avoidAll);
   rmAddObjectDefConstraint(ElkID2, avoidImpassableLand);
   rmSetObjectDefCreateHerd(ElkID2, true);
   rmPlaceObjectDefAtLoc(ElkID2, 0, 0.5, 0.5, 1);
   }
   else
   {
		// Elk	
   int ElkID4=rmCreateObjectDef("Elk herd team");
   rmAddObjectDefItem(ElkID4, "Elk", rmRandInt(7,10), 8.0);
   rmSetObjectDefMinDistance(ElkID4, 0.0);
   rmSetObjectDefMaxDistance(ElkID4, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(ElkID4, avoidDeer);
   rmAddObjectDefConstraint(ElkID4, avoidElk);
	rmAddObjectDefConstraint(ElkID4, avoidAll);
   rmAddObjectDefConstraint(ElkID4, avoidImpassableLand);
	rmAddObjectDefConstraint(ElkID4, avoidSocket);
	rmAddObjectDefConstraint(ElkID4, avoidTownCenterFar2);
	rmAddObjectDefConstraint(ElkID4, avoidCliffs);
	rmAddObjectDefConstraint(ElkID4, avoidCoinShort);
	rmAddObjectDefConstraint(ElkID4, avoidNatives);
   rmSetObjectDefCreateHerd(ElkID4, true);
	rmPlaceObjectDefAtLoc(ElkID4, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);
	
	
		// Deer	
   int DeerID4=rmCreateObjectDef("Deer herd team");
   rmAddObjectDefItem(DeerID4, "bighornsheep", rmRandInt(9,12), 8.0);
   rmSetObjectDefMinDistance(DeerID4, 0.0);
   rmSetObjectDefMaxDistance(DeerID4, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(DeerID4, avoidDeer);
   rmAddObjectDefConstraint(DeerID4, avoidElk);
	rmAddObjectDefConstraint(DeerID4, avoidAll);
   rmAddObjectDefConstraint(DeerID4, avoidImpassableLand);
	rmAddObjectDefConstraint(DeerID4, avoidSocket);
	rmAddObjectDefConstraint(DeerID4, avoidStartingUnits);
	rmAddObjectDefConstraint(DeerID4, avoidCliffs);
	rmAddObjectDefConstraint(DeerID4, avoidTownCenterFar2);
	rmAddObjectDefConstraint(DeerID4, avoidCoinShort);
	rmAddObjectDefConstraint(DeerID4, avoidNatives);
    rmSetObjectDefCreateHerd(DeerID4, true);
	rmPlaceObjectDefAtLoc(DeerID4, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);	   
   }
// Sometimes one hunt doesn't spawn, maybe this is the case when one of the two starting hunts spawn close to trade route. 
// Maybe add an edge constraints to starting hunts so.   
	if (cNumberNonGaiaPlayers==2)
	{
	silverID1 = rmCreateObjectDef("silver middle");
	rmAddObjectDefItem(silverID1, "minegold", 1, 5.0);
	rmSetObjectDefMinDistance(silverID1, 0.0);
	rmSetObjectDefMaxDistance(silverID1, 0.0);
	if (rmGetIsKOTH()) {
		rmPlaceObjectDefAtLoc(silverID1, 0, 0.45, 0.493);
	} else {
		rmPlaceObjectDefAtLoc(silverID1, 0, 0.5, 0.5);
	}
	}


							   rmSetStatusText("",0.90);
							   
							   
//	---------------------------------------------------- Nuggets ----------------------------------------------------------------------------------------


	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID, shortAvoidImpassableLand);
  	rmAddObjectDefConstraint(nuggetID, avoidNugget);
	rmAddObjectDefConstraint(nuggetID, nuggetPlayerConstraint);
  	rmAddObjectDefConstraint(nuggetID, playerConstraint);
  	rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetID, avoidSocketMore);
	rmAddObjectDefConstraint(nuggetID, avoidCliffs);
	rmAddObjectDefConstraint(nuggetID, avoidNativesNuggets);
	rmAddObjectDefConstraint(nuggetID, avoidCoinShort);
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
  	rmAddObjectDefConstraint(nuggetID, avoidAll);
	rmSetNuggetDifficulty(2, 3);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4);						   
							   
							   
							   
							   


// ------------------------------------------------------ TRIGGER and OP TAPIR---------------------------------------------------------------------------

// OMG THAT WAS HARD !!!!

/*
int triggerCounter=0;
for(i=1; <=cNumberNonGaiaPlayers)
 {
      rmCreateTrigger("Stagecoach1"+i);
      rmSwitchToTrigger(rmTriggerID("Stagecoach1"+i));
      rmSetTriggerPriority(3);
      rmSetTriggerActive(true);
      rmSetTriggerRunImmediately(true);
      rmSetTriggerLoop(false);   
      rmAddTriggerCondition("Units In Area");
      rmSetTriggerConditionParamInt("DstObject", rmGetUnitPlaced(socketID, triggerCounter));
      rmSetTriggerConditionParamInt("Player", 0);
      rmSetTriggerConditionParam("UnitType", "Stagecoach");
      rmSetTriggerConditionParamInt("Dist", 30);
      rmSetTriggerConditionParam("Op", "==");
      rmSetTriggerConditionParamInt("Count", 1);
      rmAddTriggerCondition("Units In Area");
      rmSetTriggerConditionParamInt("DstObject", rmGetUnitPlaced(socketID1, triggerCounter));
      rmSetTriggerConditionParamInt("Player", i);
      rmSetTriggerConditionParam("UnitType", "TradingPost");
      rmSetTriggerConditionParamInt("Dist", 30);
      rmSetTriggerConditionParam("Op", "==");
      rmSetTriggerConditionParamInt("Count", 1);       
      rmAddTriggerEffect("Trade Route Set Level");
      rmSetTriggerEffectParamInt("TradeRoute", 2);
      rmSetTriggerEffectParamInt("Level", 1);

      rmCreateTrigger("Stagecoach1B"+i);
      rmSwitchToTrigger(rmTriggerID("Stagecoach1B"+i));
      rmSetTriggerPriority(3);
      rmSetTriggerActive(true);
      rmSetTriggerRunImmediately(true);
      rmSetTriggerLoop(false);   
      rmAddTriggerCondition("Units In Area");
      rmSetTriggerConditionParamInt("DstObject", rmGetUnitPlaced(socketID, triggerCounter));
      rmSetTriggerConditionParamInt("Player", 0);
      rmSetTriggerConditionParam("UnitType", "Stagecoach");
      rmSetTriggerConditionParamInt("Dist", 30);
      rmSetTriggerConditionParam("Op", "==");
      rmSetTriggerConditionParamInt("Count", 1);
      rmAddTriggerCondition("Units In Area");
      rmSetTriggerConditionParamInt("DstObject", rmGetUnitPlaced(socketID1B, triggerCounter));
      rmSetTriggerConditionParamInt("Player", i);
      rmSetTriggerConditionParam("UnitType", "TradingPost");
      rmSetTriggerConditionParamInt("Dist", 30);
      rmSetTriggerConditionParam("Op", "==");
      rmSetTriggerConditionParamInt("Count", 1);       
      rmAddTriggerEffect("Trade Route Set Level");
      rmSetTriggerEffectParamInt("TradeRoute", 2);
      rmSetTriggerEffectParamInt("Level", 1);


      rmCreateTrigger("Stagecoach2"+i);
      rmSwitchToTrigger(rmTriggerID("Stagecoach2"+i));
      rmSetTriggerPriority(3);
      rmSetTriggerActive(true);
      rmSetTriggerRunImmediately(true);
      rmSetTriggerLoop(false);   
      rmAddTriggerCondition("Units In Area");
      rmSetTriggerConditionParamInt("DstObject", rmGetUnitPlaced(socketID1, triggerCounter));
      rmSetTriggerConditionParamInt("Player", 0);
      rmSetTriggerConditionParam("UnitType", "Stagecoach");
      rmSetTriggerConditionParamInt("Dist", 30);
      rmSetTriggerConditionParam("Op", "==");
      rmSetTriggerConditionParamInt("Count", 1);
      rmAddTriggerCondition("Units In Area");
      rmSetTriggerConditionParamInt("DstObject", rmGetUnitPlaced(socketID, triggerCounter));
      rmSetTriggerConditionParamInt("Player", i);
      rmSetTriggerConditionParam("UnitType", "TradingPost");
      rmSetTriggerConditionParamInt("Dist", 30);
      rmSetTriggerConditionParam("Op", "==");
      rmSetTriggerConditionParamInt("Count", 1);     
      rmAddTriggerEffect("Trade Route Set Level");
      rmSetTriggerEffectParamInt("TradeRoute", 1);
      rmSetTriggerEffectParamInt("Level", 1);

      rmCreateTrigger("Stagecoach2B"+i);
      rmSwitchToTrigger(rmTriggerID("Stagecoach2B"+i));
      rmSetTriggerPriority(3);
      rmSetTriggerActive(true);
      rmSetTriggerRunImmediately(true);
      rmSetTriggerLoop(false);   
      rmAddTriggerCondition("Units In Area");
      rmSetTriggerConditionParamInt("DstObject", rmGetUnitPlaced(socketID1, triggerCounter));
      rmSetTriggerConditionParamInt("Player", 0);
      rmSetTriggerConditionParam("UnitType", "Stagecoach");
      rmSetTriggerConditionParamInt("Dist", 30);
      rmSetTriggerConditionParam("Op", "==");
      rmSetTriggerConditionParamInt("Count", 1);
      rmAddTriggerCondition("Units In Area");
      rmSetTriggerConditionParamInt("DstObject", rmGetUnitPlaced(socketIDB, triggerCounter));
      rmSetTriggerConditionParamInt("Player", i);
      rmSetTriggerConditionParam("UnitType", "TradingPost");
      rmSetTriggerConditionParamInt("Dist", 30);
      rmSetTriggerConditionParam("Op", "==");
      rmSetTriggerConditionParamInt("Count", 1);     
      rmAddTriggerEffect("Trade Route Set Level");
      rmSetTriggerEffectParamInt("TradeRoute", 1);
      rmSetTriggerEffectParamInt("Level", 1);
 }


      rmCreateTrigger("Train1");
      rmSwitchToTrigger(rmTriggerID("Train1"));
      rmSetTriggerPriority(3);
      rmSetTriggerActive(true);
      rmSetTriggerRunImmediately(true);
      rmSetTriggerLoop(false);   
      rmAddTriggerCondition("Units In Area");
      rmSetTriggerConditionParamInt("DstObject", rmGetUnitPlaced(socketID, triggerCounter));
      rmSetTriggerConditionParamInt("Player", 0);
      rmSetTriggerConditionParam("UnitType", "TrainCar");
      rmSetTriggerConditionParamInt("Dist", 30);
      rmSetTriggerConditionParam("Op", "==");
      rmSetTriggerConditionParamInt("Count", 1);    
      rmAddTriggerEffect("Trade Route Set Level");
      rmSetTriggerEffectParamInt("TradeRoute", 2);
      rmSetTriggerEffectParamInt("Level", 2);

      rmCreateTrigger("Train2");
      rmSwitchToTrigger(rmTriggerID("Train2"));
      rmSetTriggerPriority(3);
      rmSetTriggerActive(true);
      rmSetTriggerRunImmediately(true);
      rmSetTriggerLoop(false);   
      rmAddTriggerCondition("Units In Area");
      rmSetTriggerConditionParamInt("DstObject", rmGetUnitPlaced(socketID1, triggerCounter));
      rmSetTriggerConditionParamInt("Player", 0);
      rmSetTriggerConditionParam("UnitType", "TrainCar");
      rmSetTriggerConditionParamInt("Dist", 30);
      rmSetTriggerConditionParam("Op", "==");
      rmSetTriggerConditionParamInt("Count", 1);    
      rmAddTriggerEffect("Trade Route Set Level");
      rmSetTriggerEffectParamInt("TradeRoute", 1);
      rmSetTriggerEffectParamInt("Level", 2);
      */

// ------------------------------------------------------ Finishing the OP UI ---------------------------------------------------------------------------


	rmSetStatusText("",1.0);
							 
}  


// ***********************************************************************************************************************************************
// ****************************************************** E N D **********************************************************************************
// ***********************************************************************************************************************************************