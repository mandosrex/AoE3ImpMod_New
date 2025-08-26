// Hispaniola -- JSB
// March 2006
// Nov 06 - YP update
// Main entry point for random map script    

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{


	// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.10);
	string MixType = "yukon snow";

	
	// Set size of map
	int playerTiles=15000;
	if (cNumberNonGaiaPlayers >2)   
		playerTiles = 14000;		
	if (cNumberNonGaiaPlayers >4)	
		playerTiles = 13000;
	if (cNumberNonGaiaPlayers >6)	
		playerTiles = 12000;	
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmSetMapSize(size, size);

	// Set up default water type.
	rmSetSeaLevel(-10.0);          
	rmSetSeaType("North Pole");
	rmSetOceanReveal(true);
	rmSetWindMagnitude(5.0);
	rmSetMapType("Yukon");
	rmSetMapType("grass");
	rmSetMapType("water");
	rmSetLightingSet("Great Lakes Winter");

	rmSetWorldCircleConstraint(true);

	rmTerrainInitialize("water");

	int numTries = -1;
	int classPlayer=rmDefineClass("player");
	int classIsland=rmDefineClass("island");
	int classForest = rmDefineClass("classForest");
	int classImportantItem = rmDefineClass("importantItem");
	rmDefineClass("natives");
	int classSocket = rmDefineClass("classSocket");
	rmDefineClass("canyon");
	int classCliff = rmDefineClass("classCliff");
	int classStartingUnit = rmDefineClass("startingUnit");
	int classPatch = rmDefineClass("classPatch");

   // -------------Define constraints----------------------------------------


	// Player area constraint.
	int avoidTC=rmCreateTypeDistanceConstraint("stay away from TC", "TownCenter", 30.0);
	int avoidTCFar=rmCreateTypeDistanceConstraint("stay away from TC Far", "TownCenter", 60.0);
	int avoidTCFar1=rmCreateTypeDistanceConstraint("stay away from TC Far1", "TownCenter", 40.0);
	int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", classStartingUnit, 8.0);

	// Ressources Constraint
	int avoidCoin = rmCreateTypeDistanceConstraint("avoid coin", "MineShipRuins2", 50.0);
	int avoidCoinStart = rmCreateTypeDistanceConstraint("avoid coin 2", "MineShipRuins2", 20.0);
	int avoidRandomTurkeys=rmCreateTypeDistanceConstraint("avoid random turkeys", "turkey", 50.0);
	int forestRightConstraint=rmCreateClassDistanceConstraint("forest vs. forest right", classForest, 5.0);
	int forestID = -1;
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", classForest, 35.0);
	int avoidSeal = rmCreateTypeDistanceConstraint("avoid Seal", "Seal", 48.0);
	int avoidReindeer = rmCreateTypeDistanceConstraint("avoid Reindeer", "Reindeer", 18.0);
	int avoidPenguin = rmCreateTypeDistanceConstraint("avoid Penguin", "Penguin", 48.0);
	int avoidPenguinShort = rmCreateTypeDistanceConstraint("avoid Penguin short", "Penguin", 15.0);
	int avoidCoinShort=rmCreateTypeDistanceConstraint("avoids coin short", "gold", 8.0);

	// Generic Contraints
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 5.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land like Arkansas for tree", "Land", false, 3.0);
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 6.0);
	int avoidSocket = rmCreateClassDistanceConstraint("avoid socket", classSocket, 8.0);
	int avoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other", classImportantItem, 50.0);
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 4.0);
	int avoidCliffsShort=rmCreateClassDistanceConstraint("avoid Cliffs short", classCliff, 4.0);
	int avoidCliffs=rmCreateClassDistanceConstraint("avoid Cliffs", classCliff, 10.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 40.0);
	int avoidNuggetStart=rmCreateTypeDistanceConstraint("nugget avoid nugget start", "AbstractNugget", 20.0);
	int avoidGifts=rmCreateTypeDistanceConstraint("gifts avoid gifts", "AbstractResourceCrate", 35.0);
	int avoidNuggetsAvoidGifts=rmCreateTypeDistanceConstraint("gifts avoid gifts", "AbstractResourceCrate", 40.0);
	
	// Custom Contraints
	int Promontoir=rmCreatePieConstraint("promontoir", 0.5, 0.77, rmXFractionToMeters(0.04), rmXFractionToMeters(0.8), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int PromontoirHunts=rmCreatePieConstraint("eviter le petit promontoir", 0.5, 0.75, rmXFractionToMeters(0.06), rmXFractionToMeters(0.8), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int ContrePromontoir=rmCreatePieConstraint("contre promontoir", 0.5, 0.91, rmXFractionToMeters(0.08), rmXFractionToMeters(0.9), rmDegreesToRadians(0), rmDegreesToRadians(360));	
	int avoidPic = rmCreatePieConstraint("avoid Pic", 0.5, 0.15, rmXFractionToMeters(0.08), rmXFractionToMeters(0.5), rmDegreesToRadians(0), rmDegreesToRadians(360));
	
	chooseMercs();
	
// ----------------------------------------- Building the layout ------------------------------------------------------	
	float coeff = 1.6;
	
	int lePuit=rmCreateArea("le trou en haut");
	rmSetAreaLocation(lePuit, 0.38, 0.75);
	rmAddAreaInfluenceSegment(lePuit, 0.3, 0.75, 0.7, 0.75);
	rmSetAreaSize(lePuit, 0.02*coeff, 0.02*coeff);
	rmSetAreaCliffType(lePuit, "North Pole");
    rmSetAreaCliffEdge(lePuit, 1, 1.0);
    rmSetAreaCliffPainting(lePuit, true, true, true, 1.5, true);
    rmSetAreaCliffHeight(lePuit, -20, 0.0, 0.5);
    rmSetAreaHeightBlend(lePuit, 1);
    rmSetAreaSmoothDistance(lePuit, 40);
	rmAddAreaConstraint(lePuit, Promontoir);
    rmSetAreaCoherence(lePuit, 0.7);
	rmBuildArea(lePuit);
	
	int avanceeBasGauche=rmCreateArea("avancee en bas trou gauche");
	rmSetAreaLocation(avanceeBasGauche, 0.35, 0.11);
	rmAddAreaInfluenceSegment(avanceeBasGauche, 0.2, 0.11, 0.43, 0.11);
	rmSetAreaSize(avanceeBasGauche, 0.017*coeff, 0.017*coeff);
	rmSetAreaCliffType(avanceeBasGauche, "North Pole");
    rmSetAreaCliffEdge(avanceeBasGauche, 1, 1.0);
    rmSetAreaCliffPainting(avanceeBasGauche, true, true, true, 1.5, true);
    rmSetAreaCliffHeight(avanceeBasGauche, -25, 0.0, 0.5);
    rmSetAreaHeightBlend(avanceeBasGauche, 1);
    rmAddAreaToClass(avanceeBasGauche, classCliff);
    rmSetAreaSmoothDistance(avanceeBasGauche, 10);
    rmSetAreaCoherence(avanceeBasGauche, 0.8);
	rmBuildArea(avanceeBasGauche);
	
	int avanceeBasDroite=rmCreateArea("avancee en bas trou droit");
	rmSetAreaLocation(avanceeBasDroite, 0.65, 0.12);
	rmAddAreaInfluenceSegment(avanceeBasDroite, 0.57, 0.1, 0.8, 0.11);
	rmSetAreaSize(avanceeBasDroite, 0.017*coeff, 0.017*coeff);
	rmSetAreaCliffType(avanceeBasDroite, "North Pole");
    rmSetAreaCliffEdge(avanceeBasDroite, 1, 1.0);
    rmSetAreaCliffPainting(avanceeBasDroite, true, true, true, 1.5, true);
    rmSetAreaCliffHeight(avanceeBasDroite, -25, 0.0, 0.5);
    rmSetAreaHeightBlend(avanceeBasDroite, 1);
    rmAddAreaToClass(avanceeBasDroite, classCliff);
    rmSetAreaSmoothDistance(avanceeBasDroite, 10);
    rmSetAreaCoherence(avanceeBasDroite, 0.8);
	rmBuildArea(avanceeBasDroite);	
	
	
// ************* TradeRoute & Center Island **************************************	
   int tradeRouteID = rmCreateTradeRoute();
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, classSocket);
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 8.0);
   
   rmAddTradeRouteWaypoint(tradeRouteID, 0.15, 0.4);
   rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.3, 0.34, 4, 1);
   rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.25, 4, 1);
   rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.7, 0.34, 4, 1);
   rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.85, 0.4, 4, 1);

   bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");

	// Build The ISLAND
	int centerIsland=rmCreateArea("The Island");
	rmSetAreaLocation(centerIsland, 0.5, 0.5);
	rmSetAreaSize(centerIsland, 0.33*coeff, 0.33*coeff);
    rmSetAreaWarnFailure(centerIsland, false);
	rmSetAreaCliffType(centerIsland, "North Pole");
    rmSetAreaCliffEdge(centerIsland, 1, 1, 0, 0, 1);
	rmSetAreaMinBlobs(centerIsland, 2);
	rmAddAreaInfluenceSegment(centerIsland, 0.5, 0.47, 0.5, 0.53);
	rmSetAreaMix(centerIsland, MixType);
    rmSetAreaCliffPainting(centerIsland, true, true, true, 10, true);
    rmSetAreaCliffHeight(centerIsland, 15, 0.0, 0.5);
    rmSetAreaHeightBlend(centerIsland, 1);
    rmSetAreaSmoothDistance(centerIsland, 10);
    rmSetAreaCoherence(centerIsland, 0.88);
	rmBuildArea(centerIsland);

	int stayCenterIsland=rmCreateAreaConstraint("rester sur l'ile (ne pas aller dans l'eau)", centerIsland);		
	
		int NewPatch = rmCreateArea("new Patch for the map");
    rmSetAreaLocation(NewPatch, 0.5, 0.5); 
    rmSetAreaWarnFailure(NewPatch, false);
    rmSetAreaSize(NewPatch, 0.5*coeff, 0.5*coeff);
    rmSetAreaCoherence(NewPatch, 0.85);
    rmSetAreaSmoothDistance(NewPatch, 1);
    rmAddAreaToClass(NewPatch, classPatch);
	rmAddAreaConstraint(NewPatch, stayCenterIsland);
    rmSetAreaMix(NewPatch, MixType);	
    rmBuildArea(NewPatch);

	int icePatch = rmCreateArea("ice on the top ramp");
   rmSetAreaLocation(icePatch, 0.5, 0.82);
   rmAddAreaInfluenceSegment(icePatch, 0.7, 0.82, 0.3, 0.82);   
   rmSetAreaWarnFailure(icePatch, false);
   rmSetAreaSize(icePatch, 0.07*coeff, 0.07*coeff);
   rmSetAreaCoherence(icePatch, 0.95);
   rmSetAreaSmoothDistance(icePatch, 1);
   rmAddAreaToClass(icePatch, classPatch);
   rmSetAreaMix(icePatch, "great_lakes_ice");
   rmBuildArea(icePatch);
	
	int avoidIcePatch = rmCreateAreaDistanceConstraint("avoid icePatch", icePatch, 5);


	int snowOnIcePatch = rmCreateArea("snowOnTheIcePatch");
   rmSetAreaLocation(snowOnIcePatch, 0.5, 0.82);
   rmSetAreaWarnFailure(snowOnIcePatch, false);
   rmSetAreaSize(snowOnIcePatch, 0.014, 0.014);
   rmSetAreaCoherence(snowOnIcePatch, 0.85);
   rmSetAreaSmoothDistance(snowOnIcePatch, 1);
   rmAddAreaToClass(snowOnIcePatch, classPatch);
   rmSetAreaTerrainType(snowOnIcePatch, "yukon\ground1_yuk");
   rmBuildArea(snowOnIcePatch);

	
	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.1);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.9);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	
	
//****************** La pente *************************************	
	int rightPart=rmCreateArea("la petite partie penchee en bas");
	rmSetAreaSize(rightPart, 0.23, 0.23);
	rmSetAreaLocation(rightPart, 0.5, 0.1);
	rmSetAreaCliffType(rightPart, "North Pole");
	rmAddAreaInfluenceSegment(rightPart, 0.1, 0.1, 0.9, 0.1);
    rmSetAreaCliffEdge(rightPart, 1, 0.0);
    rmSetAreaCliffPainting(rightPart, true, true, true, 10, true);
    rmSetAreaCliffHeight(rightPart, 0, 0.0, 1);
	rmSetAreaTerrainType(rightPart, "yukon\ground1_yuk");
	rmSetAreaMix(rightPart, "yukon snow");
 //   rmSetAreaHeightBlend(rightPart, 0);
    rmSetAreaSmoothDistance(rightPart, 5);
    rmSetAreaCoherence(rightPart, 0.9);
	rmBuildArea(rightPart);

	int stayRightPart=rmCreateAreaConstraint("rester sur la partie penchee", rightPart);


		int forest2=rmCreateArea("se forest ");
		rmSetAreaWarnFailure(forest2, false);
		rmSetAreaSize(forest2, 0.5, 0.5);
		rmSetAreaForestType(forest2, "yukon snow forest");
		rmAddAreaConstraint(forest2, stayRightPart);	
		rmAddAreaConstraint(forest2, avoidImpassableLandShort);
		rmAddAreaConstraint(forest2, avoidSocket);
		rmSetAreaForestDensity(forest2, 0.3);
		rmSetAreaForestClumpiness(forest2, 0.3);
		rmSetAreaForestUnderbrush(forest2, 0.5);	
		rmBuildArea(forest2);
	

	
// *********** 2 Cliffs area *****************	
/*	int LeftClliff1=rmCreateArea("Left Cliff1");
	rmSetAreaLocation(LeftClliff1, 0.64, 0.65);
	rmSetAreaSize(LeftClliff1, 0.0025, 0.0025);
    rmSetAreaWarnFailure(LeftClliff1, false);
	rmSetAreaCliffType(LeftClliff1, "North Pole");
    rmSetAreaCliffEdge(LeftClliff1, 1, 1);
	rmAddAreaInfluenceSegment(LeftClliff1, 0.64, 0.65, 0.64, 0.7);
    rmSetAreaCliffPainting(LeftClliff1, false, true, true, 1.5, true);
    rmSetAreaCliffHeight(LeftClliff1, 8, 0.0, 0.5);
    rmSetAreaHeightBlend(LeftClliff1, 1);
    rmAddAreaToClass(LeftClliff1, classCliff);
    rmSetAreaSmoothDistance(LeftClliff1, 5);
    rmSetAreaCoherence(LeftClliff1, 0.5);
	rmAddAreaConstraint(LeftClliff1,stayCenterIsland);
	rmBuildArea(LeftClliff1);*/
	
	
	int LeftCliff1A=rmCreateArea("Left Cliff1A");
	rmSetAreaLocation(LeftCliff1A, 0.64, 0.52);
	rmSetAreaSize(LeftCliff1A, 0.0025, 0.0025);
    rmSetAreaWarnFailure(LeftCliff1A, false);
	rmSetAreaCliffType(LeftCliff1A, "North Pole");
    rmSetAreaCliffEdge(LeftCliff1A, 1, 1);
	rmAddAreaInfluenceSegment(LeftCliff1A, 0.64, 0.50, 0.64, 0.55);
    rmSetAreaCliffPainting(LeftCliff1A, false, true, true, 1.5, true);
    rmSetAreaCliffHeight(LeftCliff1A, 8, 0.0, 0.5);
    rmSetAreaHeightBlend(LeftCliff1A, 1);
    rmAddAreaToClass(LeftCliff1A, classCliff);
    rmSetAreaSmoothDistance(LeftCliff1A, 5);
    rmSetAreaCoherence(LeftCliff1A, 0.5);
	rmAddAreaConstraint(LeftCliff1A,stayCenterIsland);
	rmBuildArea(LeftCliff1A);
/*	
	int LeftCliff2=rmCreateArea("Left Cliff2");
	rmSetAreaLocation(LeftCliff2, 0.36, 0.65);
	rmSetAreaSize(LeftCliff2, 0.0025, 0.0025);
    rmSetAreaWarnFailure(LeftCliff2, false);
	rmSetAreaCliffType(LeftCliff2, "North Pole");
    rmSetAreaCliffEdge(LeftCliff2, 1, 1);
	rmAddAreaInfluenceSegment(LeftCliff2, 0.36, 0.65, 0.36, 0.7);
    rmSetAreaCliffPainting(LeftCliff2, false, true, true, 1.5, true);
    rmSetAreaCliffHeight(LeftCliff2, 8, 0.0, 0.5);
    rmSetAreaHeightBlend(LeftCliff2, 1);
    rmAddAreaToClass(LeftCliff2, classCliff);
    rmSetAreaSmoothDistance(LeftCliff2, 5);
    rmSetAreaCoherence(LeftCliff2, 0.5);
	rmAddAreaConstraint(LeftCliff2,stayCenterIsland);
	rmBuildArea(LeftCliff2);*/
	
	
	int LeftCliff2A=rmCreateArea("Left Cliff2A");
	rmSetAreaLocation(LeftCliff2A, 0.36, 0.52);
	rmSetAreaSize(LeftCliff2A, 0.0025, 0.0025);
    rmSetAreaWarnFailure(LeftCliff2A, false);
	rmSetAreaCliffType(LeftCliff2A, "North Pole");
    rmSetAreaCliffEdge(LeftCliff2A, 1, 1);
	rmAddAreaInfluenceSegment(LeftCliff2A, 0.36, 0.5, 0.36, 0.55);
    rmSetAreaCliffPainting(LeftCliff2A, false, true, true, 1.5, true);
    rmSetAreaCliffHeight(LeftCliff2A, 8, 0.0, 0.5);
    rmSetAreaHeightBlend(LeftCliff2A, 1);
    rmAddAreaToClass(LeftCliff2A, classCliff);
    rmSetAreaSmoothDistance(LeftCliff2A, 5);
    rmSetAreaCoherence(LeftCliff2A, 0.5);
	rmAddAreaConstraint(LeftCliff2A,stayCenterIsland);
	rmBuildArea(LeftCliff2A);
 
 	   int betweenCliffPatch = rmCreateArea("patch between the two cliffs");
   rmSetAreaLocation(betweenCliffPatch, 0.5, 0.69);
   rmAddAreaInfluenceSegment(betweenCliffPatch, 0.36, 0.69, 0.64, 0.69);   
   rmSetAreaWarnFailure(betweenCliffPatch, false);
   rmSetAreaSize(betweenCliffPatch, 0.008*coeff, 0.008*coeff);
   rmSetAreaCoherence(betweenCliffPatch, 0.85);
   rmSetAreaSmoothDistance(betweenCliffPatch, 1);
   rmAddAreaToClass(betweenCliffPatch, classPatch);
   rmAddAreaConstraint(betweenCliffPatch, avoidCliffsShort);
  // rmSetAreaMix(betweenCliffPatch, "greatlakes_snow");	
   rmBuildArea(betweenCliffPatch);
 
 
     int inuksukObject = rmCreateObjectDef("Secret Workshop");
	rmAddObjectDefItem(inuksukObject, "SecretWorkshop", 1, 1.0);
	rmSetObjectDefMinDistance(inuksukObject, 0);
	rmSetObjectDefMaxDistance(inuksukObject, 0);
	rmSetObjectDefForceFullRotation(inuksukObject, true);
	rmPlaceObjectDefAtLoc(inuksukObject, 0, 0.5, 0.82);

	
// ********* The little Way ***************************	
   	int middleForest = rmCreateArea("middle forest");
	rmSetAreaLocation(middleForest, 0.5, 0.4);
	rmAddAreaInfluenceSegment(middleForest, 0.55, 0.4, 0.45, 0.4); 
	rmSetAreaWarnFailure(middleForest, false);
	rmSetAreaSize(middleForest, 0.011*coeff, 0.011*coeff);
	rmSetAreaBaseHeight(middleForest, 2.0);
	rmSetAreaMinBlobDistance(middleForest, 14.0);
	rmSetAreaMaxBlobDistance(middleForest, 30.0);
	rmSetAreaCoherence(middleForest, 0.9);
	rmSetAreaSmoothDistance(middleForest, 5);
	rmSetAreaHeightBlend(middleForest, 2);
	rmSetAreaTerrainType(middleForest, "yukon\groundforestsnow_yuk");
	//rmAddAreaToClass(middleForest, classForest);
	rmBuildArea(middleForest);
      
	int littleGap = rmCreateArea("middle gap");
	rmSetAreaLocation(littleGap, 0.5, 0.4);
	rmAddAreaInfluenceSegment(littleGap, 0.62, 0.4, 0.38, 0.4); 
	rmSetAreaWarnFailure(littleGap, false);
	rmSetAreaSize(littleGap, 0.006*coeff, 0.006*coeff);
	rmSetAreaTerrainType(littleGap, "yukon\ground3x_yuk");
	rmAddAreaTerrainLayer(littleGap, "yukon\ground1_yuk", 0, 1);
	rmSetAreaBaseHeight(littleGap, 2.0);
	rmSetAreaMinBlobDistance(littleGap, 14.0);
	rmSetAreaMaxBlobDistance(littleGap, 30.0);
	rmSetAreaCoherence(littleGap, 0.9);
	rmSetAreaSmoothDistance(littleGap, 5);
	rmSetAreaHeightBlend(littleGap, 0);
	rmBuildArea(littleGap);
   
   
    int stayInMiddleForest =  rmCreateAreaConstraint("stay in middle forest", middleForest);
	int avoidMiddleRoad = rmCreateAreaDistanceConstraint("avoid the little way", littleGap, 5);
   
   	for (j=0; < rmRandInt(cNumberNonGaiaPlayers*25,cNumberNonGaiaPlayers*26)) //X marks the spot
	{
		int middleTree = rmCreateObjectDef("middle tree"+j);
		rmAddObjectDefItem(middleTree, "TreeChristmas", rmRandInt(1,2), 4.0); // 1,2
		rmSetObjectDefMinDistance(middleTree, 0);
		rmSetObjectDefMaxDistance(middleTree, rmXFractionToMeters(0.5));
		//rmAddObjectDefToClass(middleTree, classForest);
		rmAddObjectDefConstraint(middleTree, stayInMiddleForest);
		rmAddObjectDefConstraint(middleTree, avoidMiddleRoad);		
		rmAddObjectDefConstraint(middleTree, avoidImpassableLandShort);	
		rmPlaceObjectDefAtLoc(middleTree, 0, 0.50, 0.50);
	}
   
   rmSetStatusText("",0.40);
   
// --------------------------------------------- Starting Ressources --------------------------  
   
    int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);


		if (cNumberNonGaiaPlayers==2)
		{
			if (rmRandFloat(0,1)<0.5)
			{
		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.2, 0.28);
		   rmPlacePlayersCircular(0.3, 0.3, 0);

		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.8, 0.78);
		   rmPlacePlayersCircular(0.3, 0.3, 0);
			}
			else
			{
		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.2, 0.28);
		   rmPlacePlayersCircular(0.3, 0.3, 0);

		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.8, 0.78);
		   rmPlacePlayersCircular(0.3, 0.3, 0);
			}
		}
		else
		{
		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(0.16, 0.27);
		   rmPlacePlayersCircular(0.3, 0.3, 0);

		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(0.73, 0.84);
		   rmPlacePlayersCircular(0.3, 0.3, 0);

		}


 
   	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 6.0);
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
	rmAddObjectDefToClass(startingTCID, classStartingUnit);
	rmSetObjectDefMinDistance(startingTCID, 0.0);
	rmSetObjectDefMaxDistance(startingTCID, 6.0);
	
	int StartPenguin=rmCreateObjectDef("starting Penguin");
	rmAddObjectDefItem(StartPenguin, "Penguin", rmRandInt(8,8), 6.0);
	rmSetObjectDefMinDistance(StartPenguin, 10.0);
	rmSetObjectDefMaxDistance(StartPenguin, 12.0);
	rmSetObjectDefCreateHerd(StartPenguin, false);
	rmAddObjectDefConstraint(StartPenguin, avoidImpassableLand);
	rmAddObjectDefConstraint(StartPenguin, avoidStartingUnits);
	rmAddObjectDefConstraint(StartPenguin, avoidSocket);
	
	int StartReindeer=rmCreateObjectDef("starting Reindeer");
	rmAddObjectDefItem(StartReindeer, "Reindeer", rmRandInt(8,8), 9.0);
	rmAddObjectDefToClass(StartReindeer, classStartingUnit);
	rmSetObjectDefMinDistance(StartReindeer, 26.0);
	rmSetObjectDefMaxDistance(StartReindeer, 28.0);
	rmSetObjectDefCreateHerd(StartReindeer, true);
	rmAddObjectDefConstraint(StartReindeer, avoidImpassableLand);
	rmAddObjectDefConstraint(StartReindeer, avoidStartingUnits);
	rmAddObjectDefConstraint(StartReindeer, avoidPenguinShort);
	rmAddObjectDefConstraint(StartReindeer, avoidSocket);
	
	int startSilverID = rmCreateObjectDef("first mine");
	rmAddObjectDefItem(startSilverID, "MineShipRuins2", 1, 5.0);
	rmAddObjectDefToClass(startSilverID, classStartingUnit);
	rmSetObjectDefMinDistance(startSilverID, 13.0);
	rmSetObjectDefMaxDistance(startSilverID, 15.0);
	
		int startSilverID2 = rmCreateObjectDef("first mine2");
	rmAddObjectDefItem(startSilverID2, "MineShipRuins2", 1, 5.0);
	rmAddObjectDefToClass(startSilverID2, classStartingUnit);
	rmAddObjectDefConstraint(startSilverID2, avoidCoinStart);
	rmSetObjectDefMinDistance(startSilverID2, 22.0);
	rmSetObjectDefMaxDistance(startSilverID2, 23.0);
	
	
	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeChristmas", 2, 4.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 11);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 18);
	rmAddObjectDefToClass(StartAreaTreeID, classStartingUnit);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnits);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidSocket);
	
	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingUnit);
    rmSetObjectDefMinDistance(playerNuggetID, 23.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 28.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetStart);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidSocket);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnits);
	rmAddObjectDefConstraint(playerNuggetID, avoidAll);
	
	 	for(i=1; <=cNumberNonGaiaPlayers)
	{
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if(ypIsAsian(i) && rmGetNomadStart() == false)
      		rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startSilverID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startSilverID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartPenguin, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartReindeer, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
		rmPlaceObjectDefAtLoc(StartAreaTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		rmSetNuggetDifficulty(1,1);
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}

	 rmSetStatusText("",0.60);

// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.5;
		float yLoc = 0.5;
		float walk = 0.02;

		if (randLoc == 2) {
			xLoc = 0.5;
			yLoc = 0.18;
		}

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}

// ----------------------------------------------------- Ressources ------------------------------------------------------------------	
// ************************ Mines *********************************
	
	int silverID = rmCreateObjectDef("mines with high variation");
	rmAddObjectDefItem(silverID, "MineShipRuins2", 1, 0);
	rmSetObjectDefMinDistance(silverID, 0.0);
	rmSetObjectDefMaxDistance(silverID, 12);
	rmAddObjectDefConstraint(silverID, avoidCliffsShort);
	rmAddObjectDefConstraint(silverID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(silverID, avoidSocket);
	rmAddObjectDefConstraint(silverID, avoidTradeRoute); 	
	

   float mineVariation = rmRandFloat(0,1);
   float mineBonus = rmRandFloat(0,1);
   
if (cNumberNonGaiaPlayers==2)
{		
	rmSetObjectDefForceFullRotation(silverID, true);
	rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.11);	// sur la jetee au sud
	
	rmSetObjectDefForceFullRotation(silverID, true);
	rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.71); // entre les deux falaises
	
	rmSetObjectDefForceFullRotation(silverID, true);
	rmPlaceObjectDefAtLoc(silverID, 0, 0.7, 0.25); // sur la partie basse
	rmSetObjectDefForceFullRotation(silverID, true);
	rmPlaceObjectDefAtLoc(silverID, 0, 0.3, 0.25); 
	rmSetObjectDefForceFullRotation(silverID, true);
	rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5); // entre les deux falaises
	
	rmSetObjectDefForceFullRotation(silverID, true);
	rmPlaceObjectDefAtLoc(silverID, 0, 0.37, 0.8); // sur la petite partie gelee
	rmSetObjectDefForceFullRotation(silverID, true);
	rmPlaceObjectDefAtLoc(silverID, 0, 0.63, 0.8);

		if (mineBonus<0)
		{
	rmSetObjectDefForceFullRotation(silverID, true);
	rmPlaceObjectDefAtLoc(silverID, 0, 0.77, 0.77);
	rmSetObjectDefForceFullRotation(silverID, true);
	rmPlaceObjectDefAtLoc(silverID, 0, 0.23, 0.77);
		}
		else if (mineBonus<0)
		{
	rmSetObjectDefForceFullRotation(silverID, true);
	rmPlaceObjectDefAtLoc(silverID, 0, 0.67, 0.47);
	rmSetObjectDefForceFullRotation(silverID, true);
	rmPlaceObjectDefAtLoc(silverID, 0, 0.33, 0.47);			
		}
		else
		{
	rmSetObjectDefForceFullRotation(silverID, true);
	rmPlaceObjectDefAtLoc(silverID, 0, 0.81, 0.42);
	rmSetObjectDefForceFullRotation(silverID, true);
	rmPlaceObjectDefAtLoc(silverID, 0, 0.19, 0.42);			
		}
}
else
{
	   for (i=0; <cNumberNonGaiaPlayers*4)
      { 
   	int silverIDT = rmCreateObjectDef("mines for 1V1"+i);
	rmAddObjectDefItem(silverIDT, "MineShipRuins2", 1, 0);
	rmSetObjectDefMinDistance(silverIDT, 0.0);
	rmSetObjectDefMaxDistance(silverIDT, rmZFractionToMeters(0.45));
	rmAddObjectDefConstraint(silverIDT, avoidTradeRoute);
	rmAddObjectDefConstraint(silverIDT, avoidCliffsShort);
	rmAddObjectDefConstraint(silverIDT, avoidTCFar1);
	rmAddObjectDefConstraint(silverIDT, avoidSocket);
    rmAddObjectDefConstraint(silverIDT, avoidImpassableLandShort);
	rmAddObjectDefConstraint(silverIDT, avoidCoin);
	rmAddObjectDefConstraint(silverIDT, stayCenterIsland);
	rmSetObjectDefForceFullRotation(silverIDT, true);
	rmPlaceObjectDefAtLoc(silverIDT, 0, 0.5, 0.5); 	
      } 	
}	
	
// ******************** Forests *****************************

int avoidMiddleForest = rmCreateAreaDistanceConstraint("avoid the center forest", middleForest, 25);
int avoidRightPart = rmCreateAreaDistanceConstraint("avoid the right Part", rightPart, 1);
int avoidRightPart1 = rmCreateAreaDistanceConstraint("avoid the right Part1", avanceeBasGauche, 0);

	for (i=0; < cNumberNonGaiaPlayers*8)
	{
		forestID = rmCreateArea("forest"+i);
		rmSetAreaWarnFailure(forestID, false);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(70));
		rmSetAreaMinBlobs(forestID, 1);
		rmSetAreaMaxBlobs(forestID, 1);
		rmSetAreaMinBlobDistance(forestID, 14.0);
		rmSetAreaMaxBlobDistance(forestID, 30.0);
		rmSetAreaCoherence(forestID, 0.1);
		rmSetAreaSmoothDistance(forestID, 5);
		rmSetAreaTerrainType(forestID, "yukon\groundforestsnow_yuk");
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidTC);
		rmAddAreaConstraint(forestID, forestConstraint);
		rmAddAreaConstraint(forestID, stayCenterIsland);
		rmAddAreaConstraint(forestID, avoidIcePatch);
		rmAddAreaConstraint(forestID, avoidTradeRoute);
		rmAddAreaConstraint(forestID, avoidMiddleForest);
		rmAddAreaConstraint(forestID, avoidRightPart);
		rmAddAreaConstraint(forestID, avoidImpassableLandShort);
		rmAddAreaConstraint(forestID, avoidCoinShort);
		rmBuildArea(forestID);
	
		int stayInNorthForest = rmCreateAreaMaxDistanceConstraint("stay in north forest"+i, forestID, 0);
	
		for (j=0; < rmRandInt(6,7))
		{
			int northtreeID = rmCreateObjectDef("forest tree"+i+j);
			rmAddObjectDefItem(northtreeID, "TreeChristmas", rmRandInt(1,2), 1.0); // cluster distance 9.0
			rmSetObjectDefMinDistance(northtreeID, 0);
			rmSetObjectDefMaxDistance(northtreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(northtreeID, classForest);
			rmAddObjectDefConstraint(northtreeID, stayInNorthForest);	
			rmAddObjectDefConstraint(northtreeID, avoidImpassableLandShort);	
			rmPlaceObjectDefAtLoc(northtreeID, 0, 0.40, 0.40);
		}
	}


		int forestTop = rmCreateObjectDef("forestTop");
		rmAddObjectDefItem(forestTop, "TreeChristmas", rmRandInt(5,6), 15); // 1,2
		rmSetObjectDefMinDistance(forestTop, 0);
		rmSetObjectDefMaxDistance(forestTop, 0);
		rmPlaceObjectDefAtLoc(forestTop, 0, 0.50, 0.85);
	

// **************************** Hunts*******************************
	int PenguinID=rmCreateObjectDef("cariou herd");
	rmAddObjectDefItem(PenguinID, "Penguin", rmRandInt(9,10), 10.0);
	rmSetObjectDefMinDistance(PenguinID, 0.0);
	rmSetObjectDefMaxDistance(PenguinID, rmXFractionToMeters(0.5));
    rmAddObjectDefConstraint(PenguinID, avoidAll);
    rmAddObjectDefConstraint(PenguinID, avoidCoinShort);
	rmAddObjectDefConstraint(PenguinID, avoidPenguin);	
	rmAddObjectDefConstraint(PenguinID, avoidSeal);
	rmAddObjectDefConstraint(PenguinID, avoidReindeer);	
	rmAddObjectDefConstraint(PenguinID, avoidSocket);
	rmAddObjectDefConstraint(PenguinID, avoidTCFar);
	rmAddObjectDefConstraint(PenguinID, avoidCliffs);
//	rmAddObjectDefConstraint(PenguinID, PromontoirHunts);
	rmAddObjectDefConstraint(PenguinID, stayCenterIsland);
	rmSetObjectDefCreateHerd(PenguinID, true);
	rmPlaceObjectDefAtLoc(PenguinID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);	

	int SealID=rmCreateObjectDef("musk Ox herd");
	rmAddObjectDefItem(SealID, "Seal", rmRandInt(9,10), 10.0);
	rmSetObjectDefMinDistance(SealID, 0.0);
	rmSetObjectDefMaxDistance(SealID, rmXFractionToMeters(0.5));
    rmAddObjectDefConstraint(SealID, avoidAll);
    rmAddObjectDefConstraint(SealID, avoidCoinShort);
	rmAddObjectDefConstraint(SealID, avoidPenguin);
	rmAddObjectDefConstraint(SealID, avoidReindeer);
	rmAddObjectDefConstraint(SealID, avoidSeal);	
	rmAddObjectDefConstraint(SealID, avoidSocket);
	rmAddObjectDefConstraint(SealID, avoidTCFar);
	//rmAddObjectDefConstraint(SealID, PromontoirHunts);
	rmAddObjectDefConstraint(SealID, avoidCliffs);
	rmAddObjectDefConstraint(SealID, stayCenterIsland);
	rmSetObjectDefCreateHerd(SealID, true);
	rmPlaceObjectDefAtLoc(SealID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);	

 rmSetStatusText("",0.90);
// ------------------------------------ Nuggets ------------------------------------	
	int nuggetID1= rmCreateObjectDef("nugget1"); 
	rmAddObjectDefItem(nuggetID1, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID1, 0.0);
	rmSetObjectDefMaxDistance(nuggetID1, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID1, avoidImpassableLandShort);
 	rmAddObjectDefConstraint(nuggetID1, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetID1, avoidSocket);
	rmAddObjectDefConstraint(nuggetID1, avoidTCFar);
	rmAddObjectDefConstraint(nuggetID1, avoidCliffs);
	rmAddObjectDefConstraint(nuggetID1, stayCenterIsland);
	rmAddObjectDefConstraint(nuggetID1, avoidCoinShort);
  	rmAddObjectDefConstraint(nuggetID1, avoidAll);
  	rmAddObjectDefConstraint(nuggetID1, avoidNugget);	
	rmAddObjectDefConstraint(nuggetID1, avoidNuggetsAvoidGifts);
	rmSetNuggetDifficulty(1, 2);
	rmPlaceObjectDefAtLoc(nuggetID1, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
		rmSetNuggetDifficulty(1, 2);
	rmPlaceObjectDefAtLoc(nuggetID1, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

		int nugget2= rmCreateObjectDef("Gift Food"); 
		rmAddObjectDefItem(nugget2, "GiftFood", 1, 0.0);
		rmSetObjectDefMinDistance(nugget2, 0.15);
		rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(nugget2, avoidTC);
		rmAddObjectDefConstraint(nugget2, avoidImpassableLand);
		rmAddObjectDefConstraint(nugget2, avoidNugget);
		rmAddObjectDefConstraint(nugget2, avoidGifts);
		rmAddObjectDefConstraint(nugget2, avoidCliffs);
		rmAddObjectDefConstraint(nugget2, avoidSocket);
		rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
		rmAddObjectDefConstraint(nugget2, avoidAll);
		rmPlaceObjectDefAtLoc(nugget2, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);
		
		int nugget3= rmCreateObjectDef("Gift Wood"); 
		rmAddObjectDefItem(nugget3, "GiftWood", 1, 0.0);
		rmSetObjectDefMinDistance(nugget3, 0.15);
		rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(nugget3, avoidTC);
		rmAddObjectDefConstraint(nugget3, avoidImpassableLand);
		rmAddObjectDefConstraint(nugget3, avoidNugget);
		rmAddObjectDefConstraint(nugget3, avoidGifts);
		rmAddObjectDefConstraint(nugget3, avoidCliffs);
		rmAddObjectDefConstraint(nugget3, avoidSocket);
		rmAddObjectDefConstraint(nugget3, avoidTradeRoute);
		rmAddObjectDefConstraint(nugget3, avoidAll);
		rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);
		
		int nugget4= rmCreateObjectDef("Gift Coin"); 
		rmAddObjectDefItem(nugget4, "GiftCoin", 1, 0.0);
		rmSetObjectDefMinDistance(nugget4, 0.15);
		rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(nugget4, avoidTC);
		rmAddObjectDefConstraint(nugget4, avoidImpassableLand);
		rmAddObjectDefConstraint(nugget4, avoidNugget);
		rmAddObjectDefConstraint(nugget4, avoidGifts);
		rmAddObjectDefConstraint(nugget4, avoidCliffs);
		rmAddObjectDefConstraint(nugget4, avoidSocket);
		rmAddObjectDefConstraint(nugget4, avoidTradeRoute);
		rmAddObjectDefConstraint(nugget4, avoidAll);
		rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);


// ------------------------------------ Triggers ------------------------------------
	
for (i=0;<=cNumberNonGaiaPlayers){
	rmCreateTrigger("Forbid_Asian_Dock"+i);
	rmSwitchToTrigger(rmTriggerID("Forbid_Dock"+i));
	rmSetTriggerPriority(3);
	rmSetTriggerActive(true);
	rmSetTriggerRunImmediately(true);
	rmSetTriggerLoop(false);
	rmAddTriggerCondition("Always"); 
	rmAddTriggerEffect("Forbid and Disable Unit");
	rmSetTriggerEffectParamInt("PlayerID", i);
    rmSetTriggerEffectParam("ProtoUnit", "YPDockAsian");
	rmSetTriggerEffectParamInt("PlayerID", i);
    rmSetTriggerEffectParam("ProtoUnit", "YPDockAsian");

	rmCreateTrigger("Forbid_Native_Dock"+i);
	rmSwitchToTrigger(rmTriggerID("Forbid_Dock"+i));
	rmSetTriggerPriority(3);
	rmSetTriggerActive(true);
	rmSetTriggerRunImmediately(true);
	rmSetTriggerLoop(false);
	rmAddTriggerCondition("Always"); 
	rmAddTriggerEffect("Forbid and Disable Unit");
	rmSetTriggerEffectParamInt("PlayerID", i);
    rmSetTriggerEffectParam("ProtoUnit", "DockNative");
	rmSetTriggerEffectParamInt("PlayerID", i);
    rmSetTriggerEffectParam("ProtoUnit", "DockNative");

	rmCreateTrigger("Forbid_Dock"+i);
	rmSwitchToTrigger(rmTriggerID("Forbid_Dock"+i));
	rmSetTriggerPriority(3);
	rmSetTriggerActive(true);
	rmSetTriggerRunImmediately(true);
	rmSetTriggerLoop(false);
	rmAddTriggerCondition("Always"); 
	rmAddTriggerEffect("Forbid and Disable Unit");
	rmSetTriggerEffectParamInt("PlayerID", i);
    rmSetTriggerEffectParam("ProtoUnit", "Dock");
	rmSetTriggerEffectParamInt("PlayerID", i);
    rmSetTriggerEffectParam("ProtoUnit", "Dock");

	}



rmSetStatusText("",1.00);

	
 //END
}  
