// Chattahoochee Large
// August 2010
// Main entry point for random map script


include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{

   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

   //Chooses which natives appear on the map
   int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;
   int subCiv3=-1;
   int subCiv4=-1;
   int subCiv5=-1;

	// Choose which variation to use.  1=southeast trade route, 2=northwest trade route
	int whichMap=rmRandInt(1,2);
	// int whichMap=2;

	// Are there extra meeting poles?
	int extraPoles=rmRandInt(1,2);
	extraPoles=1;
	// int extraPoles=2;

   if (rmAllocateSubCivs(6) == true)
   {
		subCiv0=rmGetCivID("Cree");
		rmEchoInfo("subCiv0 is Cree "+subCiv0);
		if (subCiv0 >= 0)
			rmSetSubCiv(0, "Cree");

		subCiv1=rmGetCivID("Cherokee");
		rmEchoInfo("subCiv1 is Cherokee "+subCiv1);
		if (subCiv1 >= 0)
			rmSetSubCiv(1, "Cherokee");

		subCiv2=rmGetCivID("Cherokee");
		rmEchoInfo("subCiv2 is Cherokee "+subCiv2);
		if (subCiv2 >= 0)
			rmSetSubCiv(2, "Cherokee");
		
		subCiv3=rmGetCivID("Cree");
		rmEchoInfo("subCiv3 is Cree "+subCiv3);
		if (subCiv3 >= 0)
			rmSetSubCiv(3, "Cree");
		
		subCiv4=rmGetCivID("Cree");
		rmEchoInfo("subCiv4 is Cree "+subCiv4);
		if (subCiv4 >= 0)
			rmSetSubCiv(4, "Cree");
		
		subCiv5=rmGetCivID("Cherokee");
		rmEchoInfo("subCiv5 is Cherokee "+subCiv5);
		if (subCiv5 >= 0)
			rmSetSubCiv(5, "Cherokee");
   }

   // Picks the map size
	int playerTiles= 10500;
   if (cNumberNonGaiaPlayers >4)
		playerTiles = 9500;
   if (cNumberNonGaiaPlayers >6)
      playerTiles = 8000;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	// Picks a default water height
	rmSetSeaLevel(0.0);

    // Picks default terrain
	rmSetBaseTerrainMix("newengland_grass");
	rmTerrainInitialize("new_england\ground2_ne", 1.0);
	rmSetLightingSet("carolina");
	rmSetMapType("rockies");
	rmSetMapType("namerica");
	rmSetMapType("land");
	rmSetWorldCircleConstraint(true);
	rmSetMapType("forest");

	chooseMercs();

	// Define some classes. These are used later for constraints.
	int classPlayer=rmDefineClass("player");
	rmDefineClass("classPatch");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	rmDefineClass("classForest");
	rmDefineClass("natives");	
	rmDefineClass("socketClass");
	rmDefineClass("nuggets");
	rmDefineClass("classCliff");
	rmDefineClass("center");
	int canyon=rmDefineClass("canyon");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
	int avoidCanyons=rmCreateClassDistanceConstraint("avoid canyons", rmClassID("canyon"), 20.0);
	int largeAvoidCanyons=rmCreateClassDistanceConstraint("large canyons avoid large canyons", rmClassID("canyon"), 30.0);
	int shortAvoidCanyons=rmCreateClassDistanceConstraint("short avoid canyons", rmClassID("canyon"), 12.0);
	int veryShortAvoidCanyons=rmCreateClassDistanceConstraint("very short avoid canyons", rmClassID("canyon"), 4.0);
   	int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 20.0);
   	int avoidCenter=rmCreateClassDistanceConstraint("avoid the center", rmClassID("center"), 40.0);

	// Map edge constraints
	int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);

	// Player constraints
	int playerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 10.0);
	int nuggetPlayerConstraint=rmCreateClassDistanceConstraint("nuggets stay away from players a lot", classPlayer, 40.0);

	// Resource avoidance
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 15.0);
	int avoidDeer=rmCreateTypeDistanceConstraint("deer avoids food", "deer", 40.0);
	int avoidPronghorn=rmCreateTypeDistanceConstraint("pronghorn avoids food", "pronghorn", 35.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 35.0);
	int forestAvoidCoin=rmCreateTypeDistanceConstraint("forest avoids coin", "gold", 5.0);
	int canyonsAvoidCoin=rmCreateTypeDistanceConstraint("canyons avoids coin", "gold", 3.0);
	int avoidStartingCoin=rmCreateTypeDistanceConstraint("starting coin avoids coin", "gold", 10.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 30.0);
	int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 10.0);

	int avoidFastCoin=-1;
	if (cNumberNonGaiaPlayers >6)
	{
		avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", rmXFractionToMeters(0.12));
	}
	else if (cNumberNonGaiaPlayers >4)
	{
		avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", rmXFractionToMeters(0.14));
	}
	else
	{
		avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", rmXFractionToMeters(0.16));
	}

	// Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);

	// Unit avoidance - for things that aren't in the starting resources.
	int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 40.0);
	int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);
	int avoidStartingUnitsForest=rmCreateClassDistanceConstraint("forest avoid starting units ", rmClassID("startingUnit"), 14.0);

	// Decoration avoidance
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 6.0);
	int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("trade route small", 4.0);
	int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 8.0);
	int avoidSocketMore=rmCreateClassDistanceConstraint("bigger socket avoidance", rmClassID("socketClass"), 15.0);
	
	// natives avoid natives
	int avoidNatives = rmCreateClassDistanceConstraint("avoid Natives", rmClassID("natives"), 40.0);
	int avoidNativesNuggets = rmCreateClassDistanceConstraint("nuggets avoid Natives", rmClassID("natives"), 20.0);
	int avoidNativesCanyons = rmCreateClassDistanceConstraint("canyons avoid Natives", rmClassID("natives"), 15.0);
	int shortAvoidNatives = rmCreateClassDistanceConstraint("short avoid Natives", rmClassID("natives"), 5.0);

	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

	// Center area
	int centerArea=rmCreateArea("Middle");
	rmSetAreaSize(centerArea, 0.1, 0.1);
	rmSetAreaLocation(centerArea, 0.5, 0.5);
	rmAddAreaToClass(centerArea, rmClassID("center"));

	// Text
	rmSetStatusText("",0.10);
	
	// TRADE ROUTE PLACEMENT
	int tradeRouteID = rmCreateTradeRoute();
	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);

	// Choose which variation to use.  1=southeast trade route, 2=northwest trade route

	if ( whichMap == 1 )
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.04, 0.35);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.15, 0.25, 10, 4);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.2, 10, 4);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.85, 0.25, 10, 4);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.96, 0.40, 20, 4);
	}
	else
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 0.55);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.15, 0.75, 10, 4);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.8, 10, 4);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.85, 0.75, 10, 4);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 1.0, 0.55, 20, 4);
	}



	bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
	if(placedTradeRoute == false)
		rmEchoError("Failed to place trade route"); 
  
	// add the sockets along the trade route.
	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.1);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.9);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	if ( extraPoles > 1 )
	{
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.35);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.65);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
      
	// DEFINE AREAS
	// Set up player starting locations.
	if ( whichMap == 1 )
	{
		rmSetPlacementSection(0.7, 0.3); // 0.5
	}
	else
	{
		rmSetPlacementSection(0.2, 0.8); // 0.5	   	
	}
	rmSetTeamSpacingModifier(0.5);
	rmPlacePlayersCircular(0.38, 0.38, 0);




   // Set up player areas.
	float playerFraction=rmAreaTilesToFraction(100);
	for(i=1; <cNumberPlayers)
	{
		// Create the area.
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
		rmAddAreaConstraint(id, avoidTradeRouteSmall); 
		rmAddAreaConstraint(id, avoidSocket);
		rmSetAreaLocPlayer(id, i);
		rmSetAreaWarnFailure(id, false);
   }

	int numTries = -1;
	int failCount = -1;

	// Text
	rmSetStatusText("",0.20);

	// Placement order of non-trade route stuff
	// Players -> Natives -> Canyons -> Nuggets -> Silver -> Deer -> Trees


    //STARTING UNITS and RESOURCES DEFS
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 7.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);

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
	rmSetObjectDefMaxDistance(startingTCID, 8.0);
	rmAddObjectDefConstraint(startingTCID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(startingTCID, avoidSocket);

	// Player bonus crates and scout

	int playerCrateID=rmCreateObjectDef("bonus starting crates");
	rmAddObjectDefItem(playerCrateID, "crateOfFood", rmRandInt(2,3), 4.0);
	rmAddObjectDefItem(playerCrateID, "crateOfWood", rmRandInt(1,3), 4.0);
	rmAddObjectDefItem(playerCrateID, "crateOfCoin", 1, 4.0);
	rmAddObjectDefToClass(playerCrateID, rmClassID("startingUnit"));
	rmSetObjectDefMinDistance(playerCrateID, 6);
	rmSetObjectDefMaxDistance(playerCrateID, 10);
	rmAddObjectDefConstraint(playerCrateID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(playerCrateID, avoidStartingUnitsSmall);
	
	int playerScoutID=rmCreateObjectDef("player scout");
	rmAddObjectDefItem(playerScoutID, "NativeScout", 2, 2.0);
	rmAddObjectDefToClass(playerScoutID, rmClassID("startingUnit"));
	rmSetObjectDefMinDistance(playerScoutID, 10);
	rmSetObjectDefMaxDistance(playerScoutID, 15);
	rmAddObjectDefConstraint(playerScoutID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(playerScoutID, avoidStartingUnitsSmall);

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeNewEngland", 4, 0.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 12.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 18.0);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);

	int StartDeerID=rmCreateObjectDef("starting deer");
	rmAddObjectDefItem(StartDeerID, "Deer", 7, 4.0);
	rmSetObjectDefMinDistance(StartDeerID, 10.0);
	rmSetObjectDefMaxDistance(StartDeerID, 13.0);
	rmSetObjectDefCreateHerd(StartDeerID, false);
	rmAddObjectDefConstraint(StartDeerID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartDeerID, avoidStartingUnitsSmall);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
	rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
	rmAddObjectDefToClass(playerNuggetID, rmClassID("startingUnit"));
    rmSetObjectDefMinDistance(playerNuggetID, 28.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 35.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
	rmAddObjectDefConstraint(playerNuggetID, avoidNativesNuggets);
	rmAddObjectDefConstraint(playerNuggetID, avoidCanyons);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
	rmAddObjectDefConstraint(playerNuggetID, shortAvoidImpassableLand);

	rmSetStatusText("",0.30);
	
	int silverType = -1;
	int playerGoldID = -1;

 	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Everyone gets two ore ObjectDefs, one pretty close, the other a little further away.
		silverType = rmRandInt(1,10);
		playerGoldID = rmCreateObjectDef("player silver closer "+i);
		rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
		rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(playerGoldID, avoidSocket);
		rmAddObjectDefConstraint(playerGoldID, avoidStartingCoin);
		rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
		rmSetObjectDefMinDistance(playerGoldID, 10.0);
		rmSetObjectDefMaxDistance(playerGoldID, 20.0);
		
		// Placing starting trees...
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
		// Place two gold mines
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Place extra crates, 2 scouts
		rmPlaceObjectDefAtLoc(playerCrateID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerScoutID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Place starting deer, nuggets
		rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}

	// Text
	rmSetStatusText("",0.40);

	// NATIVE AMERICANS
	float NativeVillageLoc = rmRandFloat(0,1);
	if (subCiv0 == rmGetCivID("Cree"))
	{  
		int creeVillageAID = -1;
		int creeVillageType = rmRandInt(1,5);
		creeVillageAID = rmCreateGrouping("cree village A", "native cree village "+creeVillageType);
		rmSetGroupingMinDistance(creeVillageAID, 0.0);
		rmSetGroupingMaxDistance(creeVillageAID, rmXFractionToMeters(0.1));
		rmAddGroupingConstraint(creeVillageAID, avoidImpassableLand);
		rmAddGroupingToClass(creeVillageAID, rmClassID("natives"));
		rmAddGroupingConstraint(creeVillageAID, avoidNatives);
		rmAddGroupingConstraint(creeVillageAID, avoidTradeRoute);
		rmAddGroupingConstraint(creeVillageAID, avoidStartingUnits);
		if ( whichMap == 1 )
		{
			rmPlaceGroupingAtLoc(creeVillageAID, 0, 0.5, 0.5);
		}
		else
		{
			rmPlaceGroupingAtLoc(creeVillageAID, 0, 0.35, 0.15);
		}
	}

	if (subCiv1 == rmGetCivID("Cherokee"))
	{   
		int cherokeeVillageAID = -1;
		int cherokeeVillageType = rmRandInt(1,5);
		cherokeeVillageAID = rmCreateGrouping("cherokee village A", "native cherokee village "+cherokeeVillageType);
		rmSetGroupingMinDistance(cherokeeVillageAID, 0.0);
		rmSetGroupingMaxDistance(cherokeeVillageAID, rmXFractionToMeters(0.1));
		rmAddGroupingConstraint(cherokeeVillageAID, avoidImpassableLand);
		rmAddGroupingToClass(cherokeeVillageAID, rmClassID("natives"));
		rmAddGroupingConstraint(cherokeeVillageAID, avoidNatives);
		rmAddGroupingConstraint(cherokeeVillageAID, avoidTradeRoute);
		rmAddGroupingConstraint(cherokeeVillageAID, avoidStartingUnits);
		if ( whichMap == 1 )
		{
			rmPlaceGroupingAtLoc(cherokeeVillageAID, 0, 0.7, 0.6); 
		}
		else
		{
			rmPlaceGroupingAtLoc(cherokeeVillageAID, 0, 0.65, 0.15); 
		}
	}

	// Text
	rmSetStatusText("",0.50);

	if(subCiv2 == rmGetCivID("Cherokee"))
	{   
		int cherokeeVillageID = -1;
		cherokeeVillageType = rmRandInt(1,5);
		cherokeeVillageID = rmCreateGrouping("cherokee village", "native cherokee village "+cherokeeVillageType);
		rmSetGroupingMinDistance(cherokeeVillageID, 0.0);
		rmSetGroupingMaxDistance(cherokeeVillageID, rmXFractionToMeters(0.1));
		rmAddGroupingConstraint(cherokeeVillageID, avoidImpassableLand);
		rmAddGroupingToClass(cherokeeVillageID, rmClassID("natives"));
		rmAddGroupingConstraint(cherokeeVillageID, avoidNatives);
		rmAddGroupingConstraint(cherokeeVillageID, avoidTradeRoute);
		rmAddGroupingConstraint(cherokeeVillageID, avoidStartingUnits);
		if ( extraPoles == 1 )
		{
			if ( whichMap == 1 )
			{
				rmPlaceGroupingAtLoc(cherokeeVillageID, 0, 0.2, 0.8);
			}
			else
			{
				rmPlaceGroupingAtLoc(cherokeeVillageID, 0, 0.2, 0.9);
			}
		}
	}

	if(subCiv3 == rmGetCivID("Cree"))
	{   
		int creeVillageBID = -1;
		creeVillageType = rmRandInt(1,5);
		creeVillageBID = rmCreateGrouping("cree village B", "native cree village "+creeVillageType);
		rmSetGroupingMinDistance(creeVillageBID, 0.0);
		rmSetGroupingMaxDistance(creeVillageBID, rmXFractionToMeters(0.1));
		rmAddGroupingConstraint(creeVillageBID, avoidImpassableLand);
		rmAddGroupingToClass(creeVillageBID, rmClassID("natives"));
		rmAddGroupingConstraint(creeVillageBID, avoidNatives);
		rmAddGroupingConstraint(creeVillageBID, avoidTradeRoute);
		rmAddGroupingConstraint(creeVillageBID, avoidStartingUnits);
		if ( whichMap == 1 )
		{
			rmPlaceGroupingAtLoc(creeVillageBID, 0, 0.3, 0.6);
		}
		else
		{
			rmPlaceGroupingAtLoc(creeVillageBID, 0, 0.35, 0.45);
		}
	}

	if(subCiv4 == rmGetCivID("Cree"))
	{
		int creeVillageID = -1;
		creeVillageType = rmRandInt(1,5);
		creeVillageID = rmCreateGrouping("cree village", "native cree village "+creeVillageType);
		rmSetGroupingMinDistance(creeVillageID, 0.0);
		rmSetGroupingMaxDistance(creeVillageID, rmXFractionToMeters(0.1));
		rmAddGroupingConstraint(creeVillageID, avoidImpassableLand);
		rmAddGroupingToClass(creeVillageID, rmClassID("natives"));
		rmAddGroupingConstraint(creeVillageID, avoidNatives);
		rmAddGroupingConstraint(creeVillageID, avoidTradeRoute);
		rmAddGroupingConstraint(creeVillageID, avoidStartingUnits);
		if ( extraPoles == 1 )
		{
			if ( whichMap == 1 )
			{
				rmPlaceGroupingAtLoc(creeVillageID, 0, 0.8, 0.8);
			}
			else
			{
				rmPlaceGroupingAtLoc(creeVillageID, 0, 0.75, 0.9);
			}
		}
	}

	if (subCiv5 == rmGetCivID("Cherokee"))
	{   
		int cherokeeVillageBID = -1;
		cherokeeVillageType = rmRandInt(1,5);
		cherokeeVillageBID = rmCreateGrouping("cherokee village B", "native cherokee village "+cherokeeVillageType);
		rmSetGroupingMinDistance(cherokeeVillageBID, 0.0);
		rmSetGroupingMaxDistance(cherokeeVillageBID, rmXFractionToMeters(0.1));
		rmAddGroupingConstraint(cherokeeVillageBID, avoidImpassableLand);
		rmAddGroupingToClass(cherokeeVillageBID, rmClassID("natives"));
		rmAddGroupingConstraint(cherokeeVillageBID, avoidNatives);
		rmAddGroupingConstraint(cherokeeVillageBID, avoidTradeRoute);
		rmAddGroupingConstraint(cherokeeVillageBID, avoidStartingUnits);

		if ( whichMap == 1 )
		{
			rmPlaceGroupingAtLoc(cherokeeVillageBID, 0, 0.5, 0.9);
		}
		else
		{
			rmPlaceGroupingAtLoc(cherokeeVillageBID, 0, 0.65, 0.45);
		}
	}

	// Text
	rmSetStatusText("",0.60);

	// Large Canyons

	int canyonConstraint=rmCreateClassDistanceConstraint("canyons start away from each other", canyon, 10.);
	failCount=0;
	numTries=cNumberNonGaiaPlayers*7;

	for(i=0; <numTries)
	{
		int cliffHeight=rmRandInt(0,7);
		int mesaID=rmCreateArea("mesa"+i);
		rmSetAreaSize(mesaID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(300));  // used to be 300
		rmSetAreaWarnFailure(mesaID, false);
		rmSetAreaCliffType(mesaID, "New England Inland Grass");
		rmSetAreaMix(mesaID, "new_england_forest");
		rmSetAreaCliffPainting(mesaID, false, true, true, 1.5, true);
		rmAddAreaToClass(mesaID, rmClassID("canyon"));	// Attempt to keep cliffs away from each other.
		rmSetAreaCliffEdge(mesaID, 2, 0.4, 0.0, 1.0, 0);
		if (cliffHeight <= 5)
			rmSetAreaCliffHeight(mesaID, rmRandInt(5,7), 1.0, 1.0);
		else
			rmSetAreaCliffHeight(mesaID, 7, 1.0, 1.0);
		rmAddAreaConstraint(mesaID, largeAvoidCanyons);
		rmAddAreaConstraint(mesaID, avoidNativesCanyons);
		rmSetAreaMinBlobs(mesaID, 3);
		rmSetAreaMaxBlobs(mesaID, 7);
		rmSetAreaMinBlobDistance(mesaID, 10.0);
		rmSetAreaMaxBlobDistance(mesaID, 15.0);
		rmSetAreaCoherence(mesaID, 0.5);
		rmAddAreaConstraint(mesaID, mediumPlayerConstraint); 
		rmAddAreaConstraint(mesaID, avoidStartingUnitsSmall); 
		rmAddAreaConstraint(mesaID, avoidSocketMore);
		rmAddAreaConstraint(mesaID, avoidTradeRoute);
		rmAddAreaConstraint(mesaID, avoidNugget);
		rmAddAreaConstraint(mesaID, canyonsAvoidCoin);
		if(rmBuildArea(mesaID)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}
	
	
	// Small cliffs
	for(i=0; <numTries)
	{
		int smallCliffHeight=rmRandInt(0,7);
		int smallMesaID=rmCreateArea("small mesa"+i);
		rmSetAreaSize(smallMesaID, rmAreaTilesToFraction(4), rmAreaTilesToFraction(8));  // used to be 300
		rmSetAreaWarnFailure(smallMesaID, false);
		rmSetAreaCliffType(smallMesaID, "New England Inland Grass");
		rmSetAreaMix(smallMesaID, "new_england_forest");
		rmSetAreaCliffPainting(smallMesaID, false, true, true, 1.5, true);
		rmAddAreaToClass(smallMesaID, rmClassID("canyon"));	// Attempt to keep cliffs away from each other.
		rmSetAreaCliffEdge(smallMesaID, 1, 1.0, 0.1, 1.0, 1);
		rmSetAreaCliffHeight(smallMesaID, rmRandInt(5,7), 1.0, 1.0);
		rmAddAreaConstraint(smallMesaID, shortAvoidCanyons);
		rmSetAreaMinBlobs(smallMesaID, 3);
		rmSetAreaMaxBlobs(smallMesaID, 5);
		rmSetAreaMinBlobDistance(smallMesaID, 3.0);
		rmSetAreaMaxBlobDistance(smallMesaID, 5.0);
		rmSetAreaCoherence(smallMesaID, 0.3);
		rmAddAreaConstraint(smallMesaID, mediumPlayerConstraint); 
		rmAddAreaConstraint(smallMesaID, avoidStartingUnitsSmall); 
		rmAddAreaConstraint(smallMesaID, avoidNativesCanyons); 
		rmAddAreaConstraint(smallMesaID, avoidSocketMore);
		rmAddAreaConstraint(smallMesaID, avoidTradeRoute);
		rmAddAreaConstraint(smallMesaID, avoidNugget);
		rmAddAreaConstraint(smallMesaID, canyonsAvoidCoin);
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

	// Define and place Nuggets
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
	rmAddAreaConstraint(nuggetID, avoidCanyons);
	rmAddObjectDefConstraint(nuggetID, avoidNativesNuggets);
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
  	rmAddObjectDefConstraint(nuggetID, avoidAll);
	rmSetNuggetDifficulty(2, 3);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*5);
   
	// Text
	rmSetStatusText("",0.70); 


	// Place resources
	// FAST COIN - three extra per player beyond starting resources.
	int silverID = -1;
	int silverCount = (cNumberNonGaiaPlayers*3);
	rmEchoInfo("silver count = "+silverCount);

	for(i=0; < silverCount)
	{
		silverType = rmRandInt(1,10);
		silverID = rmCreateObjectDef("silver "+i);
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverID, avoidFastCoin);
		rmAddObjectDefConstraint(silverID, shortAvoidNatives);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverID, avoidSocket);
		rmAddObjectDefConstraint(silverID, veryShortAvoidCanyons);
		rmAddObjectDefConstraint(silverID, avoidStartingUnits);
		rmAddObjectDefConstraint(silverID, avoidNuggetSmall);
		int result = rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
		if(result == 0)
			break;
   }

	// Text
	rmSetStatusText("",0.80);

	// deer	
	int deerID=rmCreateObjectDef("deer herd");
	rmAddObjectDefItem(deerID, "deer", rmRandInt(12,16), 12.0);
	rmSetObjectDefMinDistance(deerID, 0.0);
	rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(deerID, avoidDeer);
	rmAddObjectDefConstraint(deerID, avoidAll);
	rmAddObjectDefConstraint(deerID, avoidImpassableLand);
	rmAddObjectDefConstraint(deerID, avoidTradeRoute);
	rmAddObjectDefConstraint(deerID, avoidSocket);
	rmAddObjectDefConstraint(deerID, avoidStartingUnits);
	rmAddObjectDefConstraint(deerID, avoidNuggetSmall);
	rmSetObjectDefCreateHerd(deerID, true);
	rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);

	// pronghorn	
	int pronghornID=rmCreateObjectDef("pronghorn herd");
	rmAddObjectDefItem(pronghornID, "pronghorn", rmRandInt(6,9), 10.0);
	rmSetObjectDefMinDistance(pronghornID, 0.0);
	rmSetObjectDefMaxDistance(pronghornID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(pronghornID, avoidDeer);
	rmAddObjectDefConstraint(pronghornID, avoidPronghorn);
	rmAddObjectDefConstraint(pronghornID, avoidAll);
	rmAddObjectDefConstraint(pronghornID, avoidImpassableLand);
	rmAddObjectDefConstraint(pronghornID, avoidTradeRoute);
	rmAddObjectDefConstraint(pronghornID, avoidSocket);
	rmAddObjectDefConstraint(pronghornID, avoidStartingUnits);
	rmAddObjectDefConstraint(pronghornID, avoidNuggetSmall);
	rmSetObjectDefCreateHerd(pronghornID, true);
	rmPlaceObjectDefAtLoc(pronghornID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);

	// Text
	rmSetStatusText("",0.90);


	// Mini-forests near the players
	int forestTreeID = 0;
	numTries=7*cNumberNonGaiaPlayers;
	failCount=0;
	for (i=0; <numTries)
	{   
		int forest=rmCreateArea("center forest "+i);
		rmSetAreaWarnFailure(forest, false);
		rmSetAreaSize(forest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
		rmSetAreaForestType(forest, "new england forest");
		rmSetAreaForestDensity(forest, 1.);
		rmSetAreaForestClumpiness(forest, 0.);
		rmSetAreaForestUnderbrush(forest, 0.5);
		rmSetAreaCoherence(forest, 0.7);
		rmAddAreaToClass(forest, rmClassID("classForest")); 
		rmAddAreaConstraint(forest, forestConstraint);
		rmAddAreaConstraint(forest, playerConstraint);
		rmAddAreaConstraint(forest, avoidCenter); 
		rmAddAreaConstraint(forest, avoidCanyons); 
		rmAddAreaConstraint(forest, shortAvoidNatives);
		rmAddAreaConstraint(forest, avoidTradeRoute);
		rmAddAreaConstraint(forest, avoidSocket);
		rmAddAreaConstraint(forest, avoidNuggetSmall);
		rmAddAreaConstraint(forest, forestAvoidCoin);
		rmAddAreaConstraint(forest, avoidStartingUnitsForest);
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

	// Build forest areas everywhere else on trade-route side and canyons.
	numTries=7*cNumberNonGaiaPlayers;
	failCount=0;
	for (i=0; <numTries)
	{   
		int forestArea=rmCreateArea("forestArea"+i);
		rmSetAreaWarnFailure(forestArea, false);
		rmSetAreaSize(forestArea, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
		rmSetAreaForestType(forestArea, "new england forest");
		rmSetAreaForestDensity(forestArea, 0.9);
		rmSetAreaForestClumpiness(forestArea, 0.8);
      	rmSetAreaForestUnderbrush(forestArea, 0.0);
		rmSetAreaCoherence(forestArea, 0.5);
		rmAddAreaToClass(forestArea, rmClassID("classForest")); 
		rmAddAreaConstraint(forestArea, avoidTradeRoute);
		rmAddAreaConstraint(forestArea, avoidSocket);
		rmAddAreaConstraint(forestArea, shortAvoidNatives);
		rmAddAreaConstraint(forestArea, forestAvoidCoin);
		rmAddAreaConstraint(forestArea, avoidStartingUnits);
		rmAddAreaConstraint(forestArea, avoidNuggetSmall);
		rmAddAreaConstraint(forestArea, forestConstraint);
		if(rmBuildArea(forestArea)==false)
		{
			// Stop trying once we fail 7 times in a row.
			failCount++;
			if(failCount==7)
				break;
		}
		else
			failCount=0; 
	}


  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.03;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }

   // Text
   rmSetStatusText("",1.0);
}  

