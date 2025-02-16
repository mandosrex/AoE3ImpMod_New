// ***************************************************************************************************************************************************
// ****************************************************** T H A R - D E S E R T **********************************************************************
// ***************************************************************************************************************************************************

// ------------------------------------------------------ Comentaries ---------------------------------------------------------------------------
// Trying to make a map that is 100% random but 100% fair (rotation symetry for hunts and mines)- Rikikipu (June 2016)

// ------------------------------------------------------ Initialization ------------------------------------------------------------------------


include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

float PI = 3.141592;

float _pow(float n = 0,int x = 0) {
    float r = n;
    for(i = 1; < x) {
        r = r * n;
    }
    return (r);
}
float _fact(float n = 0) {
    float r = 1;
    for(i = 1; <= n) {
        r = r * i;
    }
    return (r);
}
float _cos(float n = 0) {
    float r = 1;
    for(i = 1; < 100) {
        int j = i * 2;
        float k = _pow(n,j) / _fact(j);
        if(k == 0) break;
        if(i % 2 == 0) r = r + k;
        if(i % 2 == 1) r = r - k;
    }
    return (r);
}

float _sin(float n = 0) {
    float r = n;
    for(i = 1; < 100) {
        int j = i * 2 + 1;
        float k = _pow(n,j) / _fact(j);
        if(k == 0) break;
        if(i % 2 == 0) r = r + k;
        if(i % 2 == 1) r = r - k;
    }
    return (r);
}


// Main entry point for random map script
void main(void)
{

	if (false) {
		sqrt(1);
	}


   rmSetStatusText("",0.01);

   int playerTiles=11000;
   if (cNumberNonGaiaPlayers >2)
		playerTiles = 10500;
   if (cNumberNonGaiaPlayers >4)
      playerTiles = 9800;
   if (cNumberNonGaiaPlayers >6)
      playerTiles = 9300;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmSetMapSize(size, size);
	rmSetSeaLevel(0.0);
	rmSetMapElevationParameters(cElevTurbulence, 0.06, 1, 0.25, 8.0); // nombre sur la map , détail dans une hauteur , taille , hauteur
	//rmSetBaseTerrainMix("california_a");
	rmTerrainInitialize("oasis\ground_sand1_oasis", 3);
	rmSetLightingSet("Thar");
	rmSetMapType("silkroad2");
	rmSetMapType("desert");
	rmSetMapType("land");
	rmSetMapType("asia");
	rmSetWorldCircleConstraint(true);

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
   int avoidEdge = rmCreatePieConstraint("Avoid Edge1",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));

// X marks the spot
   // Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 10.0);
   int nuggetPlayerConstraint=rmCreateClassDistanceConstraint("nuggets stay away from players a lot", rmClassID("startingUnit"), 50.0);

   // Resource avoidance
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 25.0);
   int coinForestConstraint=rmCreateClassDistanceConstraint("coin vs. forest", rmClassID("classForest"), 15.0);
   int avoidDeer=rmCreateTypeDistanceConstraint("Deer avoids food", "ypGiantSalamander", 35.0);
   int avoidDeerShort=rmCreateTypeDistanceConstraint("Deer avoids food short", "ypGiantSalamander", 20.0);
   int avoidElk=rmCreateTypeDistanceConstraint("Elk avoids food", "ypWildElephant", 35.0);
   int avoidElkShort=rmCreateTypeDistanceConstraint("Elk avoids food short", "ypWildElephant", 20.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 45.0);
   int avoidCoinStart=rmCreateTypeDistanceConstraint("coin avoids start", "gold", 40.0);
   int avoidCoinPond=rmCreateTypeDistanceConstraint("pond avoids coin", "gold", 12.0);
   int avoidCoinShort=rmCreateTypeDistanceConstraint("avoids coin short", "gold", 8.0);
   int avoidStartingCoin=rmCreateTypeDistanceConstraint("starting coin avoids coin", "gold", 28.0);
   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 43.0);
   int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 6.0);
   int avoidNuggetSmall1=rmCreateTypeDistanceConstraint("avoid nuggets by a little1", "AbstractNugget", 8.0);
   int avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", 63);
   int avoidFastCoinTeam=rmCreateTypeDistanceConstraint("fast coin avoids coin team", "gold", 72);

   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);

   // Unit avoidance - for things that aren't in the starting resources.
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidStartingUnitsTree=rmCreateClassDistanceConstraint("objects avoid starting units1", rmClassID("startingUnit"), 10.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);
   int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 60.0);
   int avoidTownCenterFar1=rmCreateTypeDistanceConstraint("avoid Town Center Far 1", "townCenter", 42.0);
   int avoidTownCenterFar2=rmCreateTypeDistanceConstraint("avoid Town Center Far team", "townCenter", 58.0);
   int avoidGoldTCmin=rmCreateTypeDistanceConstraint("avoid Town Center Gold", "townCenter", 60.0);
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


// ------------------------------------------------------ Player Location and Specific Area ---------------------------------------------------------------------------
  int subCiv0=-1;
  int subCiv1=-1;
  int subCiv2=-1;

  if (rmAllocateSubCivs(3) == true) {
		subCiv0=rmGetCivID("Udasi");
		rmEchoInfo("subCiv0 is Udasi "+subCiv0);
		if (subCiv0 >= 0)
			rmSetSubCiv(0, "Udasi");

		subCiv1=rmGetCivID("Udasi");
		rmEchoInfo("subCiv1 is Udasi "+subCiv1);
		if (subCiv1 >= 0)
			rmSetSubCiv(1, "Udasi");
    
		subCiv2=rmGetCivID("Udasi");
		rmEchoInfo("subCiv1 is Udasi "+subCiv2);
		if (subCiv2 >= 0)
			rmSetSubCiv(2, "Udasi");
	}

  if (subCiv0 == rmGetCivID("Udasi")) {  
    int udasiVillageAID = -1;
    int udasiVillageType = rmRandInt(1,5);
    udasiVillageAID = rmCreateGrouping("Udasi village A", "native udasi village "+udasiVillageType);
    rmSetGroupingMinDistance(udasiVillageAID, 0.0);
    rmSetGroupingMaxDistance(udasiVillageAID, 10.0);
    rmAddGroupingToClass(udasiVillageAID, rmClassID("natives"));
	if (rmGetIsKOTH()) {
		rmPlaceGroupingAtLoc(udasiVillageAID, 0, 0.5, 0.45);
	} else {
		rmPlaceGroupingAtLoc(udasiVillageAID, 0, 0.5, 0.5);
	}
  }

  float angleT1 = rmRandFloat(0,2*PI);
float Player1X = 0.5+0.33*_cos(angleT1);
float Player1Z = 0.5+0.33*_sin(angleT1);
float Player2X = 0.5+0.33*_cos(angleT1+PI/3);
float Player2Z = 0.5+0.33*_sin(angleT1+PI/3);
float Player3X = 0.5+0.33*_cos(angleT1+PI/6);
float Player3Z = 0.5+0.33*_sin(angleT1+PI/6);

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);

		if (cNumberTeams ==2)
		{
			float teamPlacement1 = rmRandFloat(0,1);
			float teamPlacement2=0;
			float teamPlacement2end=0;
			if  (teamPlacement1>0.5)
			{
				teamPlacement2=teamPlacement1-0.5;
				teamPlacement2end=teamPlacement2+0.2;
			}
			else if (teamPlacement1<0.3)
			{
				teamPlacement2=teamPlacement1+0.5;
				teamPlacement2end=teamPlacement2+0.2;
			}
			else
			{
				teamPlacement2=teamPlacement1+0.5;
				teamPlacement2end=teamPlacement2+0.2-1;
			}
		   rmSetPlacementTeam(0);
		   rmSetPlacementSection(teamPlacement1, teamPlacement1+0.2);
		   rmPlacePlayersCircular(0.33, 0.34, 0);

		   rmSetPlacementTeam(1);
		   rmSetPlacementSection(teamPlacement2, teamPlacement2end);
		   rmPlacePlayersCircular(0.33, 0.34, 0);

		 }
		else
		{
			rmSetTeamSpacingModifier(0.25);
			rmPlacePlayersCircular(0.38, 0.40, 0.0);
		}
   
      for(i=1; <cNumberPlayers)
   {
		// Create the area.
		int id=rmCreateArea("Player"+i);
		// Assign to the player.
		rmSetPlayerArea(i, id);
			// Set the size.
		rmSetAreaSize(id, rmAreaTilesToFraction(50), rmAreaTilesToFraction(50));
		rmAddAreaToClass(id, classPlayer);
		rmSetAreaMinBlobs(id, 1);
		rmSetAreaMaxBlobs(id, 1);
		rmSetAreaLocPlayer(id, i);
		rmSetAreaCoherence(id, 1.0);
		rmSetAreaTerrainType(id, "oasis\ground_sand1_oasis");
		rmSetAreaWarnFailure(id, false);
		rmBuildArea(id);
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
	rmAddObjectDefItem(StartAreaTreeID, "ypTreeSaxaul", rmRandInt(3,4), 5);
	rmAddObjectDefToClass(StartAreaTreeID, rmClassID("startingUnit"));
	rmSetObjectDefMinDistance(StartAreaTreeID, 10.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 18.0);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);
	
	int StartAreaTreeID1=rmCreateObjectDef("starting trees1");
	rmAddObjectDefItem(StartAreaTreeID1, "TreePolyepis", rmRandInt(6,8), 8.0);
	rmAddObjectDefToClass(StartAreaTreeID1, rmClassID("startingUnit"));
	rmSetObjectDefMinDistance(StartAreaTreeID1, 20.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID1, 30.0);
	rmAddObjectDefConstraint(StartAreaTreeID1, avoidStartingUnitsSmall);

	int StartDeerID1=rmCreateObjectDef("starting Deer");
	rmAddObjectDefItem(StartDeerID1, "Heron",rmRandInt(6,6), 9.0);
	rmSetObjectDefMinDistance(StartDeerID1, 10.0);
	rmSetObjectDefMaxDistance(StartDeerID1, 12.0);
	rmSetObjectDefCreateHerd(StartDeerID1, false);
	rmAddObjectDefConstraint(StartDeerID1, avoidStartingUnitsSmall);
	
	int StartDeerID11=rmCreateObjectDef("starting Deer1");
	rmAddObjectDefItem(StartDeerID11, "Heron",rmRandInt(11,11), 9.0);
	rmSetObjectDefMinDistance(StartDeerID11, 38.0);
	rmSetObjectDefMaxDistance(StartDeerID11, 40.0);
	rmSetObjectDefCreateHerd(StartDeerID11, true);
	rmAddObjectDefConstraint(StartDeerID11, avoidDeerShort);
	rmAddObjectDefConstraint(StartDeerID11, avoidElkShort);


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
		rmAddObjectDefItem(playerGoldID, "MineCopper", 1, 0.0);
		rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(playerGoldID, avoidStartingCoin);
		rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
		rmSetObjectDefMinDistance(playerGoldID, 13.0);
		rmSetObjectDefMaxDistance(playerGoldID, 15.0);

		// Placing starting trees...
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID1, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if (rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

	}


							   rmSetStatusText("",0.60);


// ------------------------------------------------------ Natives & Nuggets & Design ---------------------------------------------------------------------------



// ------------------------------------------------------ Others Ressources ---------------------------------------------------------------------------


int minGoldTC = rmCreateAreaDistanceConstraint("min gold TC", id, 40);
int maxGoldTC = rmCreateAreaMaxDistanceConstraint("max gold TC", id, 45);

	int silverIDSA = -1;
	silverIDSA = rmCreateObjectDef("silver STARTA");
	rmAddObjectDefItem(silverIDSA, "MineCopper", 1, 0.0);
	rmSetObjectDefMinDistance(silverIDSA, 0.0);
	rmSetObjectDefMaxDistance(silverIDSA, 0.0);
	rmAddObjectDefConstraint(silverIDSA, minGoldTC);
	rmAddObjectDefConstraint(silverIDSA, maxGoldTC);
	rmAddObjectDefConstraint(silverIDSA, avoidEdge);
	rmAddObjectDefConstraint(silverIDSA, avoidCoinStart);
	
	int silverIDSB = -1;
	silverIDSB = rmCreateObjectDef("silver STARTB");
	rmAddObjectDefItem(silverIDSB, "MineCopper", 1, 0.0);
	rmSetObjectDefMinDistance(silverIDSB, 0.0);
	rmSetObjectDefMaxDistance(silverIDSB, 0.0);
	
	int minePlacement=0;
	float minePositionX=-1;
	float minePositionZ=-1;
	int result=0;
	int leaveWhile=0;
if (cNumberNonGaiaPlayers<4)
{	
		while (minePlacement<2)
	{
		minePositionX=rmRandFloat(0.02,0.98);
		minePositionZ=rmRandFloat(0.02,0.98);
		rmSetObjectDefForceFullRotation(silverIDSA, true);
		result=rmPlaceObjectDefAtLoc(silverIDSA, 0, minePositionX, minePositionZ);
		if (result==1)
		{
			rmSetObjectDefForceFullRotation(silverIDSB, true);
			rmPlaceObjectDefAtLoc(silverIDSB, 0, 1.0-minePositionX, 1.0-minePositionZ);
			minePlacement++;
			leaveWhile=0;
		}
		else
		{
			leaveWhile++;
		}
		if (leaveWhile==300)
			break;

	}
}
	int silverIDA = -1;
	silverIDA = rmCreateObjectDef("silver half partA");
	rmAddObjectDefItem(silverIDA, "MineCopper", 1, 0.0);
	rmSetObjectDefMinDistance(silverIDA, 0.0);
	rmSetObjectDefMaxDistance(silverIDA, 0.0);
	rmAddObjectDefConstraint(silverIDA, avoidTownCenterFar2);
	rmAddObjectDefConstraint(silverIDA, avoidCoin);
	rmAddObjectDefConstraint(silverIDA, avoidEdge);
	
	int silverIDB = -1;
	silverIDB = rmCreateObjectDef("silver bottom partB");
	rmAddObjectDefItem(silverIDB, "MineCopper", 1, 0.0);
	rmSetObjectDefMinDistance(silverIDB, 0.0);
	rmSetObjectDefMaxDistance(silverIDB, 0.0);
	

	int numberOfMines=cNumberNonGaiaPlayers*2;
if (cNumberNonGaiaPlayers>2)
	numberOfMines=cNumberNonGaiaPlayers*3;

	minePlacement=0;
	minePositionX=-1;
	minePositionZ=-1;
	result=0;
	leaveWhile=0;
	
	while (minePlacement<numberOfMines)
	{
		minePositionX=rmRandFloat(0.02,0.98);
		minePositionZ=rmRandFloat(0.55,0.98);
		rmSetObjectDefForceFullRotation(silverIDA, true);
		result=rmPlaceObjectDefAtLoc(silverIDA, 0, minePositionX, minePositionZ);
		if (result==1)
		{
			rmSetObjectDefForceFullRotation(silverIDB, true);
			rmPlaceObjectDefAtLoc(silverIDB, 0, 1.0-minePositionX, 1.0-minePositionZ);
			minePlacement++;
			leaveWhile=0;
		}
		else
		{
			leaveWhile++;
		}
		if (leaveWhile==100)
			break;

	}
	
	int numberOfHunts=cNumberNonGaiaPlayers*1;
	int IbexPlacement=0;
	float IbexPositionX=-1;
	float IbexPositionZ=-1;
	result=0;
	leaveWhile=0;
	
	int IbexSize = rmRandInt(8,11);
   int IbexID=rmCreateObjectDef("Ibex herd");
   rmAddObjectDefItem(IbexID, "ypGiantSalamander", IbexSize, 8.0);
   rmSetObjectDefMinDistance(IbexID, 0.0);
   rmSetObjectDefMaxDistance(IbexID, rmXFractionToMeters(0.0));
   rmAddObjectDefConstraint(IbexID, avoidDeer);
   rmAddObjectDefConstraint(IbexID, avoidElk);
   rmAddObjectDefConstraint(IbexID, avoidTownCenterFar);
   rmAddObjectDefConstraint(IbexID, avoidCoinShort);
   rmAddObjectDefConstraint(IbexID, avoidEdge);
   rmSetObjectDefCreateHerd(IbexID, true);


   int IbexID1=rmCreateObjectDef("Ibex herd bottom");
   rmAddObjectDefItem(IbexID1, "ypGiantSalamander", IbexSize, 8.0);
   rmSetObjectDefMinDistance(IbexID1, 0.0);
   rmSetObjectDefMaxDistance(IbexID1, 0.0);
   rmSetObjectDefCreateHerd(IbexID1, true);


	while (IbexPlacement<numberOfHunts)
	{   
		IbexPositionX=rmRandFloat(0.02,0.98);
		IbexPositionZ=rmRandFloat(0.53,0.98);
		result=rmPlaceObjectDefAtLoc(IbexID, 0, IbexPositionX, IbexPositionZ,1);
		if (result!=0)
		{
			rmPlaceObjectDefAtLoc(IbexID1, 0, 1.0-IbexPositionX, 1.0-IbexPositionZ,1);
			IbexPlacement++;
			leaveWhile=0;
		}
		else
		{
			leaveWhile++;
		}
		if (leaveWhile==60)
			break;
	}
	
	
    numberOfHunts=cNumberNonGaiaPlayers*1;
	int ElifentPlacement=0;
	float ElifentPositionX=-1;
	float ElifentPositionZ=-1;
	result=0;
	leaveWhile=0;
	
	int ElifentSize = rmRandInt(3,4);
   int ElifentID=rmCreateObjectDef("Elephant herd");
   rmAddObjectDefItem(ElifentID, "ypWildElephant", ElifentSize, 8.0);
   rmSetObjectDefMinDistance(ElifentID, 0.0);
   rmSetObjectDefMaxDistance(ElifentID, rmXFractionToMeters(0.0));
   rmAddObjectDefConstraint(ElifentID, avoidDeer);
   rmAddObjectDefConstraint(ElifentID, avoidElk);
	rmAddObjectDefConstraint(ElifentID, avoidTownCenterFar);
	rmAddObjectDefConstraint(ElifentID, avoidCoinShort);
	rmAddObjectDefConstraint(ElifentID, avoidEdge);
    rmSetObjectDefCreateHerd(ElifentID, true);


   int ElifentID1=rmCreateObjectDef("Elephant herd bottom");
   rmAddObjectDefItem(ElifentID1, "ypWildElephant", ElifentSize, 8.0);
   rmSetObjectDefMinDistance(ElifentID1, 0.0);
   rmSetObjectDefMaxDistance(ElifentID1, 0.0);
   rmSetObjectDefCreateHerd(ElifentID1, true);


	while (ElifentPlacement<numberOfHunts)
	{   
		ElifentPositionX=rmRandFloat(0.02,0.98);
		ElifentPositionZ=rmRandFloat(0.53,0.98);
		result=rmPlaceObjectDefAtLoc(ElifentID, 0, ElifentPositionX, ElifentPositionZ,1);
		if (result!=0)
		{
			rmPlaceObjectDefAtLoc(ElifentID1, 0, 1.0-ElifentPositionX, 1.0-ElifentPositionZ,1);
			ElifentPlacement++;
			leaveWhile=0;
		}
		else
		{
			leaveWhile++;
		}
		if (leaveWhile==60)
			break;
	}
	
	   int failCont=0;

	int northforestcount = cNumberNonGaiaPlayers*10; // 6
	int stayInNorthForest = -1;
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land like Arkansas", "Land", false, 3.0);

	for (i=0; < northforestcount)
	{
		int YellowForest = rmCreateArea("north forest"+i);
		rmSetAreaWarnFailure(YellowForest, false);
		rmSetAreaSize(YellowForest, rmAreaTilesToFraction(80), rmAreaTilesToFraction(120));
		rmSetAreaTerrainType(YellowForest, "oasis\ground_dirt2_oasis");
		rmSetAreaBaseHeight(YellowForest, 2.0);
		rmSetAreaMinBlobs(YellowForest, 1);
		rmSetAreaMaxBlobs(YellowForest, 4);
		rmSetAreaMinBlobDistance(YellowForest, 14.0);
		rmSetAreaMaxBlobDistance(YellowForest, 30.0);
		rmSetAreaCoherence(YellowForest, 0.4);
		rmSetAreaSmoothDistance(YellowForest, 5);
		rmAddAreaToClass(YellowForest, rmClassID("classForest"));
         rmAddAreaConstraint(YellowForest, forestConstraint);
         rmAddAreaConstraint(YellowForest, avoidAll);
		 rmAddAreaConstraint(YellowForest, avoidCoinShort);
         rmAddAreaConstraint(YellowForest, shortAvoidImpassableLand);
         rmAddAreaConstraint(YellowForest, avoidTownCenterFar1);	
		 rmBuildArea(YellowForest);
			 
		stayInNorthForest = rmCreateAreaMaxDistanceConstraint("stay in north forest"+i, YellowForest, 0);
	
	
		for (j=0; < rmRandInt(2,3)) //18,20
		{
			int northtreeID = rmCreateObjectDef("north tree"+i+j);
			rmAddObjectDefItem(northtreeID, "TreePolyepis", rmRandInt(1,2), 4.0); // 1,2
			rmSetObjectDefMinDistance(northtreeID, 0);
			rmSetObjectDefMaxDistance(northtreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(northtreeID, rmClassID("classForest"));
			rmAddObjectDefConstraint(northtreeID, stayInNorthForest);	
			rmAddObjectDefConstraint(northtreeID, avoidImpassableLandShort);	
			rmPlaceObjectDefAtLoc(northtreeID, 0, 0.50, 0.50);
		}
				for (j=0; < rmRandInt(4,5)) //18,20
		{
			int northtreeID1 = rmCreateObjectDef("north tree rockies"+i+j);
			rmAddObjectDefItem(northtreeID1, "ypTreeSaxaul", rmRandInt(1,2), 4.0); // 1,2
			rmSetObjectDefMinDistance(northtreeID1, 0);
			rmSetObjectDefMaxDistance(northtreeID1, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(northtreeID1, rmClassID("classForest"));
			rmAddObjectDefConstraint(northtreeID1, stayInNorthForest);	
			rmAddObjectDefConstraint(northtreeID1, avoidImpassableLandShort);	
			rmPlaceObjectDefAtLoc(northtreeID1, 0, 0.50, 0.50);
		}
		
					for (j=0; < rmRandInt(5,6)) //18,20
		{
			int underbrushID = rmCreateObjectDef("underbrush"+i+j);
			rmAddObjectDefItem(underbrushID, "UnderbrushMongolia", rmRandInt(1,2), 4.0); // 1,2
			rmSetObjectDefMinDistance(underbrushID, 0);
			rmSetObjectDefMaxDistance(underbrushID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(underbrushID, rmClassID("classForest"));
			rmAddObjectDefConstraint(underbrushID, stayInNorthForest);	
			rmAddObjectDefConstraint(underbrushID, avoidImpassableLandShort);	
			rmPlaceObjectDefAtLoc(underbrushID, 0, 0.50, 0.50);
		}
	}


 	for(i=1; <=cNumberNonGaiaPlayers)
	{
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartDeerID1, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartDeerID11, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
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
	rmAddObjectDefConstraint(nuggetID, avoidNativesNuggets);
	rmAddObjectDefConstraint(nuggetID, avoidCoinShort);
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
  	rmAddObjectDefConstraint(nuggetID, avoidAll);
	rmSetNuggetDifficulty(2, 3);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3+2);						   
							   


	int RiceAID = rmCreateObjectDef("riceA");
	rmAddObjectDefItem(RiceAID, "UnderbrushMongolia", rmRandInt(1,1), 1.0); 
	rmSetObjectDefMinDistance(RiceAID, 0);
	rmSetObjectDefMaxDistance(RiceAID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(RiceAID, avoidAll);
	rmPlaceObjectDefAtLoc(RiceAID, 0, 0.5, 0.5, 20*cNumberNonGaiaPlayers);


// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

  if (rmGetIsKOTH()) {

    int randLoc = rmRandInt(1,3);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.03;

    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }


rmSetStatusText("",1.00);

	
 //END
}  


// ***********************************************************************************************************************************************
// ****************************************************** E N D **********************************************************************************
// ***********************************************************************************************************************************************