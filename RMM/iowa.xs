// Map made by Rikikipu - Feb 2017

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

//1-4 : X	5-8 : Z
float vexteriorPoint1=0.65; float vexteriorPoint2=0.25; float vexteriorPoint3=0.35; float vexteriorPoint4=0.75; 
float vexteriorPoint5=0.65; float vexteriorPoint6=0.75; float vexteriorPoint7=0.35; float vexteriorPoint8=0.25; 

float getexteriorPoint(int num=-1) {
	if(num==1) return(vexteriorPoint1); if(num==2) return(vexteriorPoint2); 
	if(num==3) return(vexteriorPoint3); if(num==4) return(vexteriorPoint4); 
	if(num==5) return(vexteriorPoint5); if(num==6) return(vexteriorPoint6); 
	if(num==7) return(vexteriorPoint7); if(num==8) return(vexteriorPoint8); 
	
	return(0);	// should never be reached
}
	
float setexteriorPoint(int num=-1, float val=0) {
if(num==1) vexteriorPoint1 = val; if(num==2) vexteriorPoint2 = val; 
	if(num==3) vexteriorPoint3 = val; if(num==4) vexteriorPoint4 = val; 
	if(num==5) vexteriorPoint5 = val; if(num==6) vexteriorPoint6 = val; 
	if(num==7) vexteriorPoint7 = val; if(num==8) vexteriorPoint8 = val; 
	
	return(0);	// should never be reached
}


//1-4 : X	5-8 : Z
float vIslandPoint1=0.5; float vIslandPoint2=0.4; float vIslandPoint3=0.5; float vIslandPoint4=0.6; 
float vIslandPoint5=0.5; float vIslandPoint6=0.6; float vIslandPoint7=0.5; float vIslandPoint8=0.4; 

float getIslandPoint(int num=-1) {
	if(num==1) return(vIslandPoint1); if(num==2) return(vIslandPoint2); 
	if(num==3) return(vIslandPoint3); if(num==4) return(vIslandPoint4); 
	if(num==5) return(vIslandPoint5); if(num==6) return(vIslandPoint6); 
	if(num==7) return(vIslandPoint7); if(num==8) return(vIslandPoint8); 
	
	return(0);	// should never be reached
}
	
float setIslandPoint(int num=-1, float val=0) {
if(num==1) vIslandPoint1 = val; if(num==2) vIslandPoint2 = val; 
	if(num==3) vIslandPoint3 = val; if(num==4) vIslandPoint4 = val; 
	if(num==5) vIslandPoint5 = val; if(num==6) vIslandPoint6 = val; 
	if(num==7) vIslandPoint7 = val; if(num==8) vIslandPoint8 = val; 
	
	return(0);	// should never be reached
}


// Main entry point for random map script
void main(void){

   rmSetStatusText("",0.01);


// ----------------------------------------------------- Constants -----------------------------------------------------
string hunt1 = "bison";
string hunt2 = "bison";
string mineType = "MineTin";
string forestType = "z32 Spanish Inland Forest"; // special forest only available on EP
// z32 Spanish Inland Forest
if (false == false)
{
	forestType = "great plains forest";
}
string oceanType = "great plains pond";
string groundType = "great_plains\ground5_gp";
string groundIsland = "great_plains\ground6_gp";
string lightsetType = "Great Plains";

int subCiv0=-1;
int subCiv1=-1;
int subCiv2=-1;
int subCiv3=-1;
if (rmAllocateSubCivs(2) == true)
{
	subCiv0=rmGetCivID("Cree");
	rmEchoInfo("subCiv0 is Cree "+subCiv0);
	if (subCiv0 >= 0)
		rmSetSubCiv(0, "Cree");

	subCiv1=rmGetCivID("Huron");
	rmEchoInfo("subCiv1 is Huron "+subCiv1);
	if (subCiv1 >= 0)
		rmSetSubCiv(1, "Huron");

	subCiv2=rmGetCivID("Huron");
	rmEchoInfo("subCiv2 is Huron "+subCiv2);
	if (subCiv2 >= 0)
		rmSetSubCiv(2, "Huron");
	
	subCiv3=rmGetCivID("Cree");
	rmEchoInfo("subCiv3 is Cree "+subCiv3);
	if (subCiv3 >= 0)
		rmSetSubCiv(3, "Cree");
}

// ----------------------------------------------------- Defining the map ----------------------------------------------
	int playerTiles = 13000;
	if (cNumberNonGaiaPlayers > 2)
		playerTiles=12000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles=11000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles=10000;

int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
rmSetMapSize(size, size);
//rmSetSeaLevel(2.0);

rmSetBaseTerrainMix("great plains drygrass");
rmTerrainInitialize("great_plains\ground6_gp", 3.0);

rmSetMapElevationParameters(cElevTurbulence, 0.07, 2, 0.1, 5.0);
rmTerrainInitialize(groundType, 2.0);
rmSetMapType("newEngland");
rmSetMapType("land");
rmSetMapType("grass");
rmSetMapType("namerica");
rmSetLightingSet(lightsetType);
rmSetWorldCircleConstraint(true);
rmSetWindMagnitude(2.0); 
// ----------------------------------------------------- Constraints ---------------------------------------------------
	int numTries = -1;
	int classPlayer=rmDefineClass("player");
	int classIsland=rmDefineClass("island");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("natives");
	rmDefineClass("classSocket");
	rmDefineClass("canyon");
	rmDefineClass("classCliff");
	rmDefineClass("startingUnit");
	rmDefineClass("pond");
	rmDefineClass("northCoin");
	rmDefineClass("southCoin");
	rmDefineClass("bisonFood");
	rmDefineClass("northFood");


   rmSetStatusText("",0.10);


   // -------------Define constraints----------------------------------------

// Player area constraint.
int avoidTCShort=rmCreateTypeDistanceConstraint("stay away from TC short", "TownCenter", 30.0);
int avoidTCMedium=rmCreateTypeDistanceConstraint("stay away from TC Medium", "TownCenter", 40.0);
int avoidTCFar=rmCreateTypeDistanceConstraint("stay away from TC Far", "TownCenter", 60.0);
int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 8.0);

// Ressources Constraint
int avoidCoin = rmCreateTypeDistanceConstraint("avoid coin", mineType, 60.0);
int avoidSouthCoin=rmCreateClassDistanceConstraint("avoid south coin", rmClassID("southCoin"), 55.0);
int avoidNorthCoin=rmCreateClassDistanceConstraint("avoid north coin", rmClassID("northCoin"), 55.0);
int avoidCoinStart = rmCreateTypeDistanceConstraint("avoid coin 2", mineType, 20.0);
int avoidRandomTurkeys=rmCreateTypeDistanceConstraint("avoid random turkeys", "turkey", 50.0);
int avoidforestshort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("classForest"), 8.0);
int forestID = -1;
int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 25.0);
int avoidBisonFood=rmCreateClassDistanceConstraint("avoid south food", rmClassID("bisonFood"), 50.0);
int avoidNorthFood=rmCreateClassDistanceConstraint("avoid north food", rmClassID("northFood"), 45.0);
int avoidHunt1Far = rmCreateTypeDistanceConstraint("avoid hunt1 far", hunt1, 50.0);
int avoidHunt1Short = rmCreateTypeDistanceConstraint("avoid hunt1 short", hunt1, 20.0);
int avoidHunt2Far = rmCreateTypeDistanceConstraint("avoid hunt2 far", hunt2, 50.0);
int avoidHunt2Short = rmCreateTypeDistanceConstraint("avoid hunt2 short", hunt2, 20.0);
int avoidCoinShort=rmCreateTypeDistanceConstraint("avoids coin short", "gold", 8.0);
int avoidCoinLong=rmCreateTypeDistanceConstraint("avoids coin long", "gold", 55.0);


// Generic Contraints
int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 5.0);
int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land like Arkansas for tree", "Land", false, 3.0);
int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 6.0);
int avoidSocket = rmCreateClassDistanceConstraint("avoid socket", rmClassID("classSocket"), 8.0);
int avoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 50.0);
int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 4.0);
int avoidCliffsShort=rmCreateClassDistanceConstraint("avoid Cliffs short", rmClassID("classCliff"), 4.0);
int avoidCliffs=rmCreateClassDistanceConstraint("avoid Cliffs", rmClassID("classCliff"), 10.0);
int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 55.0);
int avoidNuggetStart=rmCreateTypeDistanceConstraint("nugget avoid nugget start", "AbstractNugget", 20.0);

// Custom Contraints
int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.46), rmDegreesToRadians(0),rmDegreesToRadians(360));
int staySouth = rmCreatePieConstraint("Stay South",0.47,0.47, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(135),rmDegreesToRadians(315));
int stayNorth = rmCreatePieConstraint("Stay North",0.53,0.53, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(315),rmDegreesToRadians(135));

// Choose Mercs
chooseMercs();


   rmSetStatusText("",0.20);


// ----------------------------------------------------- Designing the map ---------------------------------------------

int centralPond=rmCreateArea("central pond");
rmSetAreaSize(centralPond, 0.02, 0.02);
rmSetAreaLocation(centralPond, 0.5, 0.5);
rmAddAreaInfluenceSegment(centralPond, 0.44, 0.65, 0.65, 0.44);
rmSetAreaWaterType(centralPond, oceanType);
rmSetAreaCoherence(centralPond, 0.65);
rmSetAreaSmoothDistance(centralPond, 7);
rmAddAreaToClass(centralPond, rmClassID("pond"));
rmBuildArea(centralPond);

int centralPond2=rmCreateArea("central pond 2");
rmSetAreaSize(centralPond2, 0.02, 0.02);
rmSetAreaLocation(centralPond2, 0.5, 0.5);
rmAddAreaInfluenceSegment(centralPond2, 0.34, 0.55, 0.55, 0.34);
rmSetAreaWaterType(centralPond2, oceanType);
rmSetAreaCoherence(centralPond2, 0.65);
rmSetAreaSmoothDistance(centralPond2, 7);
rmAddAreaToClass(centralPond2, rmClassID("pond"));
rmBuildArea(centralPond2);

int island_do_not_touch_pond = rmCreateEdgeDistanceConstraint("constraint for island not touching pound edge", centralPond, 22);
int island_do_not_touch_pond2 = rmCreateEdgeDistanceConstraint("constraint for island not touching pound edge 2", centralPond2, 22);
int avoid_pond =rmCreateClassDistanceConstraint("avoid center pond", rmClassID("pond"), 6.0);

int centralIsland=rmCreateArea("central island");
rmSetAreaSize(centralIsland, 0.08, 0.08);
rmSetAreaLocation(centralIsland, 0.5, 0.5);
rmSetAreaSmoothDistance(centralIsland, 5);
rmSetAreaBaseHeight(centralIsland, 0);
rmSetAreaTerrainType(centralIsland, groundIsland);
rmAddAreaConstraint(centralIsland, island_do_not_touch_pond);
rmAddAreaConstraint(centralIsland, island_do_not_touch_pond2);
rmSetAreaWarnFailure(centralIsland, false);
//rmBuildArea(centralIsland);


   rmSetStatusText("",0.30);


for (i=1;<5)
{
	int mapWithoutPond = rmCreateArea("all map without pond"+i);
	rmSetAreaSize(mapWithoutPond, 0.01, 0.01);
	rmSetAreaLocation(mapWithoutPond, getexteriorPoint(i),getexteriorPoint(i+4));
	rmAddAreaConstraint(mapWithoutPond, avoid_pond);
	rmBuildArea(mapWithoutPond);
	
	int islandPoint = rmCreateArea("islandPoint"+i);
	rmSetAreaSize(islandPoint, 0.01, 0.01);
	rmSetAreaLocation(islandPoint, getIslandPoint(i),getIslandPoint(i+4));
	rmAddAreaConstraint(islandPoint, avoid_pond);
	rmSetAreaWarnFailure(islandPoint, false);
	rmBuildArea(islandPoint);

	int connectionTest = rmCreateConnection("connection test"+i);
	rmSetConnectionType(connectionTest, cConnectAreas, true, 0.5);
	rmAddConnectionArea(connectionTest, mapWithoutPond);
	rmAddConnectionArea(connectionTest, islandPoint);
	rmSetConnectionCoherence(connectionTest, 0.3);
	rmSetConnectionSmoothDistance(connectionTest, 3);
	rmSetConnectionWidth(connectionTest, 10, 1);
	rmAddConnectionTerrainReplacement(connectionTest, "carolinas\ground_shoreline1_car", groundIsland);
	rmSetConnectionBaseHeight(connectionTest, 0);
	rmBuildConnection(connectionTest);
}


// ----------------------------------------------------- Trade Route -----------------------------------------------------
int tradeRouteID = rmCreateTradeRoute();
int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
rmSetObjectDefAllowOverlap(socketID, true);
rmAddObjectDefToClass(socketID, rmClassID("classSocket"));
rmSetObjectDefMinDistance(socketID, 0.0);
rmSetObjectDefMaxDistance(socketID, 7.0);
rmAddTradeRouteWaypoint(tradeRouteID, 0.9, 0.1);
if (rmGetIsKOTH()) {
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.55, 0.45);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.455, 0.455);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.45, 0.55);
} else {
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.70, 0.30,5,5);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.50);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.30, 0.70,5,5);
}
rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.1, 0.9,5,5);

bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");



vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
if (rmGetIsKOTH()) {
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.55);
} else {
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
}
rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.85);
rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

for(i=0; <cNumberNonGaiaPlayers*5)
{
int newGrass = rmCreateArea("new grass"+i);
rmSetAreaLocation(newGrass, rmRandFloat(0.05,0.95), rmRandFloat(0.05,0.95)); 
rmSetAreaWarnFailure(newGrass, false);
rmSetAreaSize(newGrass,0.01, 0.01);
rmSetAreaCoherence(newGrass, 0);
rmSetAreaSmoothDistance(newGrass, 1);
rmSetAreaObeyWorldCircleConstraint(newGrass, false);
//rmAddAreaToClass(newGrass, rmClassID("classPatch")); // nonfunctional
rmSetAreaTerrainType(newGrass, "great_plains\ground8_gp");
rmSetAreaMix(newGrass, "great plains drygrass");
rmAddAreaConstraint(newGrass, avoid_pond);
rmBuildArea(newGrass);
}


   rmSetStatusText("",0.40);


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

// ----------------------------------------------------- Natives ---------------------------------------------
if (subCiv0 == rmGetCivID("Cree"))
{  
  int IncasVillageAID = -1;
  IncasVillageAID = rmCreateGrouping("cree1 village", "native cree village "+2);
  rmSetGroupingMinDistance(IncasVillageAID, 0.00);
  rmSetGroupingMaxDistance(IncasVillageAID, 0.00);
  rmAddGroupingConstraint(IncasVillageAID, avoidImpassableLand);
  rmAddGroupingToClass(IncasVillageAID, rmClassID("natives"));
  rmPlaceGroupingAtLoc(IncasVillageAID, 0, 0.2, 0.58);
}

if (subCiv1 == rmGetCivID("Huron"))
{   
  int LakotaVillageAID = -1;
  LakotaVillageAID = rmCreateGrouping("huron1 village", "native huron village "+2);
  rmSetGroupingMinDistance(LakotaVillageAID, 0.0);
 rmSetGroupingMaxDistance(LakotaVillageAID, 0.00);
  rmAddGroupingConstraint(LakotaVillageAID, avoidImpassableLand);
  rmAddGroupingToClass(LakotaVillageAID, rmClassID("natives"));
  rmPlaceGroupingAtLoc(LakotaVillageAID, 0, 0.58, 0.2); 
}
if(subCiv2 == rmGetCivID("Huron"))
{   
  int LakotaVillageID = -1;
  LakotaVillageID = rmCreateGrouping("huron2 village", "native huron village "+2);
  rmSetGroupingMinDistance(LakotaVillageID, 0.0);
  rmSetGroupingMaxDistance(LakotaVillageID, 4);
  rmAddGroupingConstraint(LakotaVillageID, avoidImpassableLand);
  rmAddGroupingToClass(LakotaVillageID, rmClassID("natives"));
  rmPlaceGroupingAtLoc(LakotaVillageID, 0, 0.42, 0.8);
}

if(subCiv3 == rmGetCivID("Cree"))
{   
  int IncasVillageBID = -1;
  IncasVillageBID = rmCreateGrouping("cree2 village", "native cree village "+2);
  rmSetGroupingMinDistance(IncasVillageBID, 0.0);
  rmSetGroupingMaxDistance(IncasVillageBID, 4);
  rmAddGroupingConstraint(IncasVillageBID, avoidImpassableLand);
  rmAddGroupingToClass(IncasVillageBID, rmClassID("natives"));
  rmPlaceGroupingAtLoc(IncasVillageBID, 0, 0.8, 0.42);
}


   rmSetStatusText("",0.50);


// ----------------------------------------------------- Players ---------------------------------------------
int teamZeroCount = rmGetNumberPlayersOnTeam(0);
int teamOneCount = rmGetNumberPlayersOnTeam(1);


	if(cNumberTeams > 2)
	{	
	   rmSetTeamSpacingModifier(0.7);
	   rmPlacePlayersCircular(0.36, 0.36, 0.0);
	}

	if(cNumberTeams == 2)
	{
	if (cNumberNonGaiaPlayers==2)
	{	
		rmPlacePlayer(1,0.75,0.75);
		rmPlacePlayer(2,0.25,0.25);
	}
	else
	{
	   rmSetPlacementTeam(0);
	   rmSetPlacementSection(0.05, 0.21);
	   rmPlacePlayersCircular(0.37, 0.38, 0);

	   rmSetPlacementTeam(1);
	   rmSetPlacementSection(0.55, 0.71);
	   rmPlacePlayersCircular(0.37, 0.38, 0);
	}
	}
	
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


   rmSetStatusText("",0.60);


int StartCaribou=rmCreateObjectDef("starting caribou");
rmAddObjectDefItem(StartCaribou, hunt1, 5, 6.0);
rmSetObjectDefMinDistance(StartCaribou, 10.0);
rmSetObjectDefMaxDistance(StartCaribou, 14.0);
rmSetObjectDefCreateHerd(StartCaribou, false);
rmAddObjectDefConstraint(StartCaribou, avoidImpassableLand);
rmAddObjectDefConstraint(StartCaribou, avoidStartingUnits);
rmAddObjectDefConstraint(StartCaribou, avoidSocket);

int StartMoose=rmCreateObjectDef("starting moose");
rmAddObjectDefItem(StartMoose, hunt2, rmRandInt(9,9), 9.0);
rmAddObjectDefToClass(StartMoose, rmClassID("startingUnit"));
rmSetObjectDefMinDistance(StartMoose, 22.0);
rmSetObjectDefMaxDistance(StartMoose, 26.0);
rmSetObjectDefCreateHerd(StartMoose, true);
rmAddObjectDefConstraint(StartMoose, avoidImpassableLand);
rmAddObjectDefConstraint(StartMoose, avoidStartingUnits);
rmAddObjectDefConstraint(StartMoose, avoidHunt1Short);
rmAddObjectDefConstraint(StartMoose, avoidSocket);

int startSilverID = rmCreateObjectDef("first mine");
rmAddObjectDefItem(startSilverID, mineType, 1, 5.0);
rmAddObjectDefToClass(startSilverID, rmClassID("startingUnit"));
rmSetObjectDefMinDistance(startSilverID, 14.0);
rmSetObjectDefMaxDistance(startSilverID, 16.0);

int startsilvermid = rmCreateObjectDef("first mine2");
rmAddObjectDefItem(startsilvermid, mineType, 1, 5.0);
rmAddObjectDefToClass(startsilvermid, rmClassID("startingUnit"));
rmAddObjectDefConstraint(startsilvermid, avoidCoinStart);
rmSetObjectDefMinDistance(startsilvermid, 22.0);
rmSetObjectDefMaxDistance(startsilvermid, 23.0);


int StartAreaTreeID=rmCreateObjectDef("starting trees");
rmAddObjectDefItem(StartAreaTreeID, "TreeGreatPlains", 2, 4.0);
rmSetObjectDefMinDistance(StartAreaTreeID, 11);
rmSetObjectDefMaxDistance(StartAreaTreeID, 18);
rmAddObjectDefToClass(StartAreaTreeID, rmClassID("startingUnit"));
rmAddObjectDefConstraint(StartAreaTreeID, avoidImpassableLand);
rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnits);
rmAddObjectDefConstraint(StartAreaTreeID, avoidSocket);

int playerNuggetID=rmCreateObjectDef("player nugget");
rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
rmAddObjectDefToClass(playerNuggetID, rmClassID("startingUnit"));
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
	rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(startSilverID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(startsilvermid, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartCaribou, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartMoose, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	
	rmPlaceObjectDefAtLoc(StartAreaTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmSetNuggetDifficulty(1,1);
	rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));	

		if ( rmGetNomadStart())
		{
			rmAddPlayerResource(i, "ships", 1);
		}

}


   rmSetStatusText("",0.70);


// -------------------------------------------- Resources ------------------------------------------------


numTries=20*cNumberNonGaiaPlayers;
int failCount=0;


	int bisoncount = 4*cNumberNonGaiaPlayers/2;
	int pronghorncount = 1*cNumberNonGaiaPlayers/2;
	int BisonPlacement=0;
	float BisonPositionX=-1;
	float BisonPositionZ=-1;
	int leaveWhile=0;
	int result=0;
	int minePlacement=0;
	float minePositionX=-1;
	float minePositionZ=-1;
	int goldCount = 4*cNumberNonGaiaPlayers/2;  // 3,3 

	int gold = rmCreateObjectDef("south gold");
	rmAddObjectDefItem(gold, "MineTin", 1, 0.0);
	rmSetObjectDefMinDistance(gold, 0.0);
	rmSetObjectDefMaxDistance(gold, 0.0);
	rmAddObjectDefConstraint(gold, avoidSocket);
	rmAddObjectDefConstraint(gold, avoidTradeRoute);
	rmAddObjectDefConstraint(gold, avoidImpassableLand);
	rmAddObjectDefConstraint(gold, avoidAll);
	rmAddObjectDefConstraint(gold, avoidCoinLong);
	rmAddObjectDefConstraint(gold, avoidTCFar);
	rmAddObjectDefConstraint(gold, avoidEdge);

		int silverIDB = -1;
	silverIDB = rmCreateObjectDef("silver bottom partB");
	rmAddObjectDefItem(silverIDB, "MineTin", 1, 0.0);
	rmSetObjectDefMinDistance(silverIDB, 0.0);
	rmSetObjectDefMaxDistance(silverIDB, 0.0);

	
	while (minePlacement<goldCount)
	{
		minePositionX=rmRandFloat(0.03,0.98);
		minePositionZ=rmRandFloat(0.55,0.98);
		rmSetObjectDefForceFullRotation(gold, true);
		result=rmPlaceObjectDefAtLoc(gold, 0, minePositionX, minePositionZ);
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
		if (leaveWhile==300)
			break;

	}

	result=0;
	leaveWhile=0;
	int bisonSize = 9;
	int BisonHunts = rmCreateObjectDef("south bison"+i);
	rmAddObjectDefItem(BisonHunts, hunt1, bisonSize, 8.0);
	rmAddObjectDefToClass(BisonHunts, rmClassID("bisonFood"));	
	rmSetObjectDefMinDistance(BisonHunts,0);
	rmSetObjectDefMaxDistance(BisonHunts,0);
	rmSetObjectDefCreateHerd(BisonHunts, true);
	rmAddObjectDefConstraint(BisonHunts, avoidImpassableLandShort);
	rmAddObjectDefConstraint(BisonHunts, avoidAll);
	rmAddObjectDefConstraint(BisonHunts, avoidSocket);
	rmAddObjectDefConstraint(BisonHunts, avoidCoinShort);
	rmAddObjectDefConstraint(BisonHunts, avoidforestshort);
	rmAddObjectDefConstraint(BisonHunts, avoidTCFar);
	rmAddObjectDefConstraint(BisonHunts, avoidBisonFood);  	
	rmAddObjectDefConstraint(BisonHunts, avoidEdge); 

	int BisonHuntMirror=rmCreateObjectDef("Second bison");
   rmAddObjectDefItem(BisonHuntMirror, hunt1,  bisonSize, 8.0);
   rmAddObjectDefToClass(BisonHuntMirror, rmClassID("bisonFood"));	
   rmSetObjectDefMinDistance(BisonHuntMirror, 0.0);
   rmSetObjectDefMaxDistance(BisonHuntMirror, 0.0);
   rmSetObjectDefCreateHerd(BisonHuntMirror, true);

	while (BisonPlacement<bisoncount)
	{   
		BisonPositionX=rmRandFloat(0.03,0.97);
		BisonPositionZ=rmRandFloat(0.53,0.97);
		result=rmPlaceObjectDefAtLoc(BisonHunts, 0, BisonPositionX, BisonPositionZ,1);
		if (result!=0)
		{
			rmPlaceObjectDefAtLoc(BisonHuntMirror, 0, 1.0-BisonPositionX, 1.0-BisonPositionZ,1);
			BisonPlacement++;
			leaveWhile=0;
		}
		else
		{
			leaveWhile++;
		}
		if (leaveWhile==60)
			break;
	}


   rmSetStatusText("",0.80);


numTries=15*cNumberNonGaiaPlayers;
failCount=0;
for (i=0; <numTries)
{   
	int grassyArea=rmCreateArea("grassyArea"+i);
	rmSetAreaWarnFailure(grassyArea, false);
	rmSetAreaSize(grassyArea, rmAreaTilesToFraction(100), rmAreaTilesToFraction(150));
	rmSetAreaForestType(grassyArea, "Great Plains grass");
	rmSetAreaForestDensity(grassyArea, 0.3);
	rmAddAreaConstraint(grassyArea, avoidTradeRoute);
	rmAddAreaConstraint(grassyArea, avoidSocket);
	rmAddAreaConstraint(grassyArea, avoidAll);
	rmAddAreaConstraint(grassyArea, avoidTCShort);
	if(rmBuildArea(grassyArea)==false)
	{
		// Stop trying once we fail 5 times in a row.
		failCount++;
		if(failCount==5)
			break;
	}
	else
		failCount=0; 
}

for (i=0; <numTries)
{   
	int forest=rmCreateArea("forest "+i);
	rmSetAreaWarnFailure(forest, false);
	rmSetAreaSize(forest, rmAreaTilesToFraction(100), rmAreaTilesToFraction(150));
	rmSetAreaForestType(forest, forestType);
	rmSetAreaTerrainType(forest, "great_plains\ground3_gp");
	rmSetAreaMix(forest, "great plains drygrass");
	rmSetAreaForestDensity(forest, 0.8);
	rmSetAreaForestClumpiness(forest, 0.1);
	rmSetAreaForestUnderbrush(forest, 0.5);
	rmSetAreaCoherence(forest, 0.5);
	rmAddAreaToClass(forest, rmClassID("classForest")); 
	rmAddAreaConstraint(forest, forestConstraint);
	rmAddAreaConstraint(forest, avoidTCMedium);
	rmAddAreaConstraint(forest, avoidImportantItem);
	rmAddAreaConstraint(forest, avoidImpassableLand);
	rmAddAreaConstraint(forest, avoidTradeRoute);
	rmAddAreaConstraint(forest, avoidSocket);
	rmAddAreaConstraint(forest, avoidCoinShort);
	rmAddAreaConstraint(forest, avoidAll);
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



int nuggetID1= rmCreateObjectDef("nugget1"); 
rmAddObjectDefItem(nuggetID1, "Nugget", 1, 0.0);
rmSetObjectDefMinDistance(nuggetID1, 0.0);
rmSetObjectDefMaxDistance(nuggetID1, rmXFractionToMeters(0.5));
rmAddObjectDefConstraint(nuggetID1, avoidImpassableLandShort);
rmAddObjectDefConstraint(nuggetID1, avoidTradeRoute);
rmAddObjectDefConstraint(nuggetID1, avoidSocket);
rmAddObjectDefConstraint(nuggetID1, avoidTCFar);
rmAddObjectDefConstraint(nuggetID1, avoidCoinShort);
rmAddObjectDefConstraint(nuggetID1, avoidAll);
rmAddObjectDefConstraint(nuggetID1, avoidNugget);	
rmSetNuggetDifficulty(2, 3);
rmPlaceObjectDefAtLoc(nuggetID1, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4);

rmSetStatusText("",0.99);

	
 //END
}