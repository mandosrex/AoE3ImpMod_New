//setMethods

//==============================================================================
/*
 setForwardBaseLocation
 updatedOn 2022/07/20
 Finds a location to build the foward base for the fort
 
 How to use
 Call setForwardBaseLocation()
 
 Example
 vector gfowardBaseLocation = setForwardBaseLocation()
*/
//==============================================================================
vector setForwardBaseLocation(void)
{
	static vector lastLocaiton = cInvalidVector;
	if(gTownCenterNumber < 1) 
	{ //There is no TC do not make a foward base
		gfowardBaseLocation = cInvalidVector;
		return(cInvalidVector);
	} //end if
	if(gfowardBaseLocation != cInvalidVector) return(gfowardBaseLocation); //Already have a foward base location
		
	vector retVal = cInvalidVector;
	vector mainBaseVec = gMainBaseLocation;
	vector delta = cInvalidVector; // Scratch variable for intermediate calcs.
	vector v = cInvalidVector; // Scratch variable for intermediate calcs.
	float distanceMultiplier = 0.0;
	int enemyTC = -1;
	int mainAreaGroup = -1;
	bool siteFound = false;
	
	distanceMultiplier = (aiRandInt(3) + 3); //get a random number between 0 and 3 and add 3 to that
	distanceMultiplier = (distanceMultiplier * 0.1) - 0.05; // 0.25 - 0.45; used to determine how far out the fort will be placed
	enemyTC = getUnitByLocation(gTownCenter, cPlayerRelationEnemy, cUnitStateABQ, mainBaseVec, 500.0);
	if (enemyTC < 0)
	{
		retVal = gMapCenter; // Start with map center
		delta = (mainBaseVec - retVal) * 0.5;
		retVal = retVal + delta; // halfway between main base and map center
	}
	else 
	{ // enemy TC found
		v = kbUnitGetPosition(enemyTC) - mainBaseVec; // Vector from main base to enemy TC
		v = v * distanceMultiplier;
		retVal = mainBaseVec + v; // retval is point between main base and chosen enemy TC
	}
	// Now, make sure it's on the same areagroup, back up if it isn't.
	mainAreaGroup = kbAreaGroupGetIDByPosition(mainBaseVec);
	delta = (mainBaseVec - retVal) * 0.1;
	if (distance(mainBaseVec, retVal) > 0.0)
	{
		for (i = 0; < 9)
		{
			if (getUnitByLocation(cUnitTypeFortFrontier, cPlayerRelationEnemy, cUnitStateABQ, retVal, 60.0) >= 0) continue; // DO NOT build anywhere near an enemy fort!
			if (getUnitByLocation(gTownCenter, cPlayerRelationEnemy, cUnitStateABQ, retVal, 60.0) >= 0) continue; // Ditto enemy TCs.
			if (mainAreaGroup == kbAreaGroupGetIDByPosition(retVal))
			{ // DONE!
				siteFound = true;
				break;
			}
			retVal = retVal + delta; // Move 1/10 of way back to main base, try again.
		}
	}
	if (siteFound == false) retVal = mainBaseVec;
	if (gWorldDifficulty < cDifficultyModerate) retVal = mainBaseVec; // Easy and Sandbox will never forward build.
	gfowardBaseLocation = retVal;
	lastLocaiton = retVal;
	return (retVal);
}

//updatedOn 2019/05/14 By ageekhere    
void setFowardBuildings()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"setFowardBuildings") == false) return;
	lastRunTime = gCurrentGameTime;
	
	if (kbVPSiteQuery(cVPAll, cPlayerRelationAny, cVPStateAny) == -1) return;
	gBuildListArray = xsArrayCreateVector(kbVPSiteQuery(cVPAll, cPlayerRelationAny, cVPStateAny), cInvalidVector, "listOfsites");
	for (x = 0; < kbVPSiteQuery(cVPAll, cPlayerRelationAny, cVPStateAny))
	{
		xsArraySetVector(gBuildListArray, x, cInvalidVector);
	}
}
//==============================================================================
// setUnitTypes
/*
	Called when the initial units have disembarked.  Sets up initial economy.
*/
//==============================================================================

//==============================================================================
/* setUnitTypes
	updatedOn 2019/11/06 By ageekhere 
*/
//==============================================================================
void setUnitTypes(void)
{
	//set defaults
	gEconUnit = cUnitTypeSettler;
	gHouseUnit = cUnitTypeHouse;
	gTowerUnit = cUnitTypeOutpost;
	gFarmUnit = cUnitTypeMill;
	gPlantationUnit = cUnitTypePlantation;
	gLivestockPenUnit = cUnitTypeHouse;
	gCoveredWagonUnit = cUnitTypeCoveredWagon;
	gMarketUnit = cUnitTypeMarket;
	gDockUnit = cUnitTypeDock;
	gSpecialUnit = cUnitTypeMusketeer;
	gTownCenter = cUnitTypeTownCenter;
	gBarracksUnit = cUnitTypeBarracks;
	gStableUnit = cUnitTypeStable;
	gArtilleryDepotUnit = cUnitTypeArtilleryDepot;
	gArsenalUnit = cUnitTypeArsenal;
	gChurchUnit = cUnitTypeChurch;
	gFishingUnit = cUnitTypeFishingBoat;
	gTransportUnit = cUnitTypeAbstractWarShip;
	gCaravelUnit = cUnitTypeCaravel;
	gGalleonUnit = cUnitTypeGalleon; 
	gFrigateUnit = cUnitTypeFrigate;
	gExplorerUnit = cUnitTypeExplorer;
	gTradingPostUnit = cUnitTypeTradingPost;
	gCapitolUnit = cUnitTypeCapitol;
	gFirePitUnit = -1;

	if (getCivIsNative() == true)
	{
		gCaravelUnit = cUnitTypeCanoe;
		gGalleonUnit = cUnitTypexpWarCanoe;
		gEconUnit = cUnitTypeSettlerNative;
		gFarmUnit = cUnitTypeFarm;
		gTowerUnit = cUnitTypeLookout;
		gBarracksUnit = cUnitTypeWarHut;
		gStableUnit = cUnitTypeCorral;
		cvOkToBuildForts = false;
		gChurchUnit = cUnitTypeNativeEmbassy;
		gFirePitUnit = cUnitTypeFirePit;
	}
	else if (getCivIsAsian() == true)
	{
		gEconUnit = cUnitTypeypSettlerAsian;
		gTowerUnit = cUnitTypeYPOutpostAsian;
		gFarmUnit = cUnitTypeypRicePaddy;
		gPlantationUnit = cUnitTypeypRicePaddy;
		gMarketUnit = cUnitTypeypTradeMarketAsian;
		gDockUnit = cUnitTypeYPDockAsian;
		gFishingUnit = cUnitTypeypFishingBoatAsian;
		cvOkToBuildForts = false;	
		gChurchUnit = cUnitTypeypMonastery;
	}

	switch (gCurrentCiv)
	{
		case cCivSPCAct3: 
		{
			gHouseUnit = cUnitTypeManor;
			gLivestockPenUnit = cUnitTypeManor;
			gNavyClass1 = cUnitTypeCaravel;
			gNavyClass2 = cUnitTypeSchooner;
			gNavyClass3 = cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		case cCivXPSPC: 
		{
			gHouseUnit = cUnitTypeManor;
			gLivestockPenUnit = cUnitTypeManor;
			gNavyClass1 = cUnitTypeCaravel;
			gNavyClass2 = cUnitTypeSchooner;
			gNavyClass3 = cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		case cCivBritish:
		{
			gHouseUnit = cUnitTypeManor;
			gLivestockPenUnit = cUnitTypeManor;
			gNavyClass1 = cUnitTypeCaravel;
			gNavyClass2 = cUnitTypeSchooner;
			gNavyClass3 = cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		case cCivChinese: 
		{
			gExplorerUnit = cUnitTypeypMonkChinese;
			gHouseUnit = cUnitTypeypVillage;
			gLivestockPenUnit = cUnitTypeypVillage;
			gSpecialUnit = cUnitTypeypOldHanArmy;
			gCaravelUnit = cUnitTypeypWarJunk;
			gGalleonUnit = cUnitTypeypFuchuan;
			gBarracksUnit = cUnitTypeypWarAcademy;
			gStableUnit = cUnitTypeypWarAcademy;
			gNavyClass1 = cUnitTypeypWarJunk;
			gNavyClass2 = cUnitTypeypFuchuan;
			gNavyClassS1 = cUnitTypeypFireship;
			gNavyClassS2 = cUnitTypeMonitor;
		}
		case cCivSPCChinese:
		{
			gExplorerUnit = cUnitTypeypMonkChinese;
			gHouseUnit = cUnitTypeypVillage;
			gLivestockPenUnit = cUnitTypeypVillage;
			gSpecialUnit = cUnitTypeypOldHanArmy;
			gCaravelUnit = cUnitTypeypWarJunk;
			gGalleonUnit = cUnitTypeypFuchuan;
			gBarracksUnit = cUnitTypeypWarAcademy;
			gStableUnit = cUnitTypeypWarAcademy;
			gNavyClass1 = cUnitTypeypWarJunk;
			gNavyClass2 = cUnitTypeypFuchuan;
			gNavyClassS1 = cUnitTypeypFireship;
			gNavyClassS2 = cUnitTypeMonitor;
			break;
		}
		case cCivColombians:
		{
			gExplorerUnit = cUnitTypeExplorerAmerican;
			gHouseUnit = cUnitTypeHouseMed;
			gLivestockPenUnit = cUnitTypeHouseMed;
			gGalleonUnit = cUnitTypeSteamShip;
			gEconUnit = cUnitTypeSettlerAmerican;
			gNavyClass1 = cUnitTypeCaravel;
			gNavyClass2 = cUnitTypeGalleon;
			gNavyClass3 = cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		case cCivDutch:
		{
			gHouseUnit = cUnitTypeHouse;
			gEconUnit = cUnitTypeSettlerDutch;
			gLivestockPenUnit = cUnitTypeHouse;
			gGalleonUnit = cUnitTypeFluyt;
			gSpecialUnit = cUnitTypeSchutze;
			gNavyClass1 = cUnitTypeCaravel;
			gNavyClass2 = cUnitTypeFluyt;
			gNavyClass3 = cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		case cCivFrench:
		{
			gHouseUnit = cUnitTypeHouse;
			gLivestockPenUnit = cUnitTypeHouse;
			gEconUnit = cUnitTypeCoureur;
			gSpecialUnit = cUnitTypeSkirmisher;
			gNavyClass1 = cUnitTypeCaravel;
			gNavyClass2 = cUnitTypeGalleon;
			gNavyClass3 = cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		case cCivGermans:
		{
			gExplorerUnit = cUnitTypeExplorerEast; //toEnableNextUpdate
			gHouseUnit = cUnitTypeHouseEast;
			gLivestockPenUnit = cUnitTypeHouseEast;
			gNavyClass1 = cUnitTypeCaravel;
			gNavyClass2 = cUnitTypeGalleon;
			gNavyClass3 = cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		case cCivIndians: 
		{
			gExplorerUnit = cUnitTypeypMonkIndian;
			gExplorerUnit2 = cUnitTypeypMonkIndian2;
			gEconUnit = cUnitTypeypSettlerIndian;
			gHouseUnit = cUnitTypeypHouseIndian;
			gLivestockPenUnit = cUnitTypeypSacredField;
			gSpecialUnit = cUnitTypeypSepoy;
			gCaravelUnit = cUnitTypeypWokouJunkI;
			gBarracksUnit = cUnitTypeYPBarracksIndian;
			gStableUnit = cUnitTypeypCaravanserai;
			gNavyClass1 =  cUnitTypeypWokouJunkI;
			gNavyClass2 =  cUnitTypeGalleon;
			gNavyClass3 =  cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypeMonitor;
		}
		case cCivSPCIndians:
		{
			gExplorerUnit = cUnitTypeypMonkIndian;
			gExplorerUnit2 = cUnitTypeypMonkIndian2;
			gEconUnit = cUnitTypeypSettlerIndian;
			gHouseUnit = cUnitTypeypHouseIndian;
			gLivestockPenUnit = cUnitTypeypSacredField;
			gSpecialUnit = cUnitTypeypSepoy;
			gCaravelUnit = cUnitTypeypWokouJunkI;
			gBarracksUnit = cUnitTypeYPBarracksIndian;
			gStableUnit = cUnitTypeypCaravanserai;
			gNavyClass1 =  cUnitTypeypWokouJunkI;
			gNavyClass2 =  cUnitTypeGalleon;
			gNavyClass3 =  cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		case cCivItalians:
		{
			gExplorerUnit = cUnitTypeExplorerMed; //toEnableNextUpdate
			gHouseUnit = cUnitTypeHouseVilla;
			gLivestockPenUnit = cUnitTypeHouseVilla;
			gSpecialUnit = cUnitTypeCrossbowman;
			gChurchUnit = cUnitTypeBasilicaIt;
			gNavyClass1 = cUnitTypeCaravel;
			gNavyClass2 = cUnitTypeGalleon;
			gNavyClass3 = cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		case cCivJapanese: 
		{
			gExplorerUnit = cUnitTypeypMonkJapanese;
			gExplorerUnit2 = cUnitTypeypMonkJapanese2;
			gEconUnit = cUnitTypeypSettlerJapanese;
			gHouseUnit = cUnitTypeypShrineJapanese;
			gLivestockPenUnit = cUnitTypeypShrineJapanese;
			gSpecialUnit = cUnitTypeypAshigaru;
			gCaravelUnit = cUnitTypeypFune;
			gGalleonUnit = cUnitTypeypAtakabune;
			gFrigateUnit = cUnitTypeypTekkousen;
			gBarracksUnit = cUnitTypeypBarracksJapanese;
			gStableUnit = cUnitTypeypStableJapanese;
			gNavyClass1 = cUnitTypeypFune;
			gNavyClass2 = cUnitTypeypAtakabune;
			gNavyClass3 = cUnitTypeypTekkousen;
			gNavyClassS1 = cUnitTypeMonitor;
		}
		case cCivSPCJapanese: 
		{
			gExplorerUnit = cUnitTypeypMonkJapanese;
			gExplorerUnit2 = cUnitTypeypMonkJapanese2;
			gEconUnit = cUnitTypeypSettlerJapanese;
			gHouseUnit = cUnitTypeypShrineJapanese;
			gLivestockPenUnit = cUnitTypeypShrineJapanese;
			gSpecialUnit = cUnitTypeypAshigaru;
			gCaravelUnit = cUnitTypeypFune;
			gGalleonUnit = cUnitTypeypAtakabune;
			gFrigateUnit = cUnitTypeypTekkousen;
			gBarracksUnit = cUnitTypeypBarracksJapanese;
			gStableUnit = cUnitTypeypStableJapanese;
			gNavyClass1 = cUnitTypeypFune;
			gNavyClass2 = cUnitTypeypAtakabune;
			gNavyClass3 = cUnitTypeypTekkousen;
			gNavyClassS1 = cUnitTypeMonitor;
		}
		case cCivSPCJapaneseEnemy:
		{
			gExplorerUnit = cUnitTypeypMonkJapanese;
			gExplorerUnit2 = cUnitTypeypMonkJapanese2;
			gEconUnit = cUnitTypeypSettlerJapanese;
			gHouseUnit = cUnitTypeypShrineJapanese;
			gLivestockPenUnit = cUnitTypeypShrineJapanese;
			gSpecialUnit = cUnitTypeypAshigaru;
			gCaravelUnit = cUnitTypeypFune;
			gGalleonUnit = cUnitTypeypAtakabune;
			gFrigateUnit = cUnitTypeypTekkousen;
			gBarracksUnit = cUnitTypeypBarracksJapanese;
			gStableUnit = cUnitTypeypStableJapanese;
			gNavyClass1 = cUnitTypeypFune;
			gNavyClass2 = cUnitTypeypAtakabune;
			gNavyClass3 = cUnitTypeypTekkousen;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		case cCivMaltese:
		{
			gExplorerUnit = cUnitTypeExplorerMed;
			gHouseUnit = cUnitTypeEncampment;
			gLivestockPenUnit = cUnitTypeHouseMed;
			gNavyClass1 = cUnitTypeCaravel;
			gNavyClass2 = cUnitTypeGalleon;
			gNavyClass3 = cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypeMonitor;

			break;
		}
		case cCivOttomans:
		{
			gExplorerUnit = cUnitTypeExplorerMed;
			gHouseUnit = cUnitTypeHouseMed;
			gLivestockPenUnit = cUnitTypeHouseMed;
			gCaravelUnit = cUnitTypeGalley;
			gSpecialUnit = cUnitTypeJanissary;
			gChurchUnit = cUnitTypeMosque;
			gEconUnit = cUnitTypeSettlerOttoman;
			gNavyClass1 = cUnitTypeGalley;
			gNavyClass2 = cUnitTypeGalleon;
			gNavyClass3 = cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		case cCivPortuguese:
		{
			gExplorerUnit = cUnitTypeExplorerMed;
			gHouseUnit = cUnitTypeHouseMed;
			gLivestockPenUnit = cUnitTypeHouseMed;
			gSpecialUnit = cUnitTypeCacadore;
			gNavyClass1 = cUnitTypeCaravel;
			gNavyClass2 = cUnitTypeGalleon;
			gNavyClass3 = cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypePopovka;
			break;
		}
		case cCivRussians:
		{
			gExplorerUnit = cUnitTypeExplorerEast;
			gHouseUnit = cUnitTypeHouseEast;
			gLivestockPenUnit = cUnitTypeHouseEast;
			gTowerUnit = cUnitTypeBlockhouse;
			gSpecialUnit = cUnitTypeStrelet;
			gBarracksUnit = cUnitTypeBlockhouse;
			gNavyClass1 = cUnitTypeCaravel;
			gNavyClass2 = cUnitTypeGalleon;
			gNavyClass3 = cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		case cCivSpanish:
		{
			gExplorerUnit = cUnitTypeExplorerMed; //toEnableNextUpdate
			gHouseUnit = cUnitTypeHouseMed;
			gLivestockPenUnit = cUnitTypeHouseMed;
			gNavyClass1 = cUnitTypeCaravel;
			gNavyClass2 = cUnitTypeGalleon;
			gNavyClass3 = cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		case cCivSwedish:
		{
			gExplorerUnit = cUnitTypeExplorerEast; //toEnableNextUpdate
			gHouseUnit = cUnitTypeHouseTorp;
			gLivestockPenUnit = cUnitTypeHouseTorp;
			gEconUnit = cUnitTypeSettler;
			gSpecialUnit = cUnitTypeSharpshooterS;
			break;
		}
		case cCivUSA:
		{
			gExplorerUnit = cUnitTypeExplorerAmerican; //toEnableNextUpdate
			gSpecialUnit = cUnitTypeMarine;
			gGalleonUnit = cUnitTypeSteamShip;
			gEconUnit = cUnitTypeSettlerAmerican;
			gNavyClass1 = cUnitTypeCorvette;
			gNavyClass2 = cUnitTypeSteamShip;
			gNavyClass3 = cUnitTypeFrigate;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		case cCivXPAztec:
		{
			gMarketUnit = cUnitTypeMarketNative; //toEnableNextUpdate
			gDockUnit = cUnitTypeDockNative; //toEnableNextUpdate
			gExplorerUnit = cUnitTypexpAztecWarchief;
			gHouseUnit = cUnitTypeHouseAztec;
			gSpecialUnit = cUnitTypexpMacehualtin;
			gFrigateUnit = cUnitTypexpTlalocCanoe;
			gLivestockPenUnit = gFarmUnit;
			gStableUnit = cUnitTypeNoblesHut;
			gArtilleryDepotUnit = cUnitTypeNoblesHut;
			gNavyClass1 = cUnitTypeCanoe;
			gNavyClass2 = cUnitTypexpWarCanoe;
			gNavyClass3 = cUnitTypexpTlalocCanoe;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		
		case cCivXPIroquois:
		{
			gArtilleryDepotUnit = cUnitTypeSiegeWorkshop; //toEnableNextUpdate
			gMarketUnit = cUnitTypeMarketNative; //toEnableNextUpdate
			gDockUnit = cUnitTypeDockNative; //toEnableNextUpdate
			gExplorerUnit = cUnitTypexpIroquoisWarChief;
			gHouseUnit = cUnitTypeLonghouse;
			gSpecialUnit = cUnitTypexpTomahawk;
			gNavyClass1 = cUnitTypeCanoe;
			gNavyClass2 = cUnitTypexpWarCanoe;
			gNavyClassS1 = cUnitTypeMonitor;
			break;
		}
		case cCivXPSioux:
		{
			gExplorerUnit = cUnitTypeExplorerAmerican; //toEnableNextUpdate
			gMarketUnit = cUnitTypeMarketNative; //toEnableNextUpdate
			gDockUnit = cUnitTypeDockNative; //toEnableNextUpdate
			gExplorerUnit = cUnitTypexpLakotaWarchief;
			gHouseUnit = cUnitTypeTeepee;
			gSpecialUnit = cUnitTypexpWarBow;
			gOkToMakeHouses = false;
			gNavyClass1 = cUnitTypeCanoe;
			gNavyClass2 = cUnitTypexpWarCanoe;
			gNavyClassS1 = cUnitTypeMonitor;
			gArtilleryDepotUnit = cUnitTypeEmbassy;
			break;
		}
		case cCivTheCircle:
		{
			gHouseUnit = cUnitTypeHouseEast;
			gLivestockPenUnit = cUnitTypeHouseEast;
			break;
		}
		default:
		{
			debugRule("setUnitTypes - Warning no civ found", 1);
			break;
		}
	}

	// Escrow initialization is now delayed until the TC is built, as
	// any escrow allocation prevents the AI from affording a TC.
	// For now, though, override the default and set econ/mil to 0
	kbEscrowSetPercentage(cEconomyEscrowID, cResourceFood, 0.0);
	kbEscrowSetPercentage(cEconomyEscrowID, cResourceWood, 0.0);
	kbEscrowSetPercentage(cEconomyEscrowID, cResourceGold, 0.0);
	kbEscrowSetPercentage(cEconomyEscrowID, cResourceFame, 0.0);

	kbEscrowSetPercentage(cMilitaryEscrowID, cResourceFood, 0.0);
	kbEscrowSetPercentage(cMilitaryEscrowID, cResourceWood, 0.0);
	kbEscrowSetPercentage(cMilitaryEscrowID, cResourceGold, 0.0);
	kbEscrowSetPercentage(cMilitaryEscrowID, cResourceFame, 0.0);

	kbEscrowAllocateCurrentResources();
	aiSetEconomyPercentage(1.0);
	aiSetMilitaryPercentage(1.0); // Priority balance neutral  
}

//==============================================================================
/*
 setCostWeight
 updatedOn 2022/09/10
 This function compares actual supply vs. forecast, updates AICost 
 values (internal resource prices), and buys/sells at the market as appropriate
 
 How to use
 call setCostWeight
 
 Example
 setCostWeight();
*/
//==============================================================================
void setCostWeight(void)
{
	const int pMinForecastAmount = 100;
	static float pLastGoldWeight = -1.0;
	static float pLastWoodWeight = -1.0;
	static float pLastFoodWeight = -1.0;
	float pForcastGold = xsArrayGetFloat(gForecasts, cResourceGold);
	float pForcastWood = xsArrayGetFloat(gForecasts, cResourceWood);
	float pForcastFood = xsArrayGetFloat(gForecasts, cResourceFood);
	if ((pForcastGold + pForcastWood + pForcastFood) < pMinForecastAmount) return;// check for valid forecasts, exit if not ready
	// Commentary on scale factor.  A factor of 1.0 compares inventory of resources against the full 3-minute forecast.  A scale of 10.0
	// compares inventory to 1/10th of the forecast.  A large scale makes prices more volatile, encourages faster and more frequent trading at lower threshholds, etc.
	float pScaleFactor = 3.0; // Higher values make prices more volatile
	float pGoldStatus = 0.0;
	float pWoodStatus = 0.0;
	float pFoodStatus = 0.0;
	float pMinForecast = 200.0 * (1 + gCurrentAge); // 200, 400, 600, 800 in ages 1-4, prevents small amount from looking large if forecast is very low

	if (pForcastGold > pMinForecast) pGoldStatus = pScaleFactor * gCurrentCoin / pForcastGold;
	else pGoldStatus = pScaleFactor * gCurrentCoin / pMinForecast;
	
	if (pForcastFood > pMinForecast) pFoodStatus = pScaleFactor * gCurrentFood / pForcastFood;
	else pFoodStatus = pScaleFactor * gCurrentFood / pMinForecast;
	
	if (pForcastWood > pMinForecast) pWoodStatus = pScaleFactor * gCurrentWood / pForcastWood;
	else pWoodStatus = pScaleFactor * gCurrentWood / pMinForecast;

	// Status now equals inventory/forecast
	// Calculate value rate of wood:gold and food:gold.  1.0 means they're of the same status, 2.0 means 
	// that the resource is one forecast more scarce, 0.5 means one forecast more plentiful, i.e. lower value.
	float pWoodRate = ((1.0 + pGoldStatus) / (1.0 + pWoodStatus)) * 1.2; //* 1.2 Because wood is more expensive to gather
	float pFoodRate = (1.0 + pGoldStatus) / (1.0 + pFoodStatus);
	float pCost = 0.0; // The rates are now the instantaneous price for each resource.  Set the long-term prices by averaging this in at a 5% weight.

	// wood
	pCost = kbGetAICostWeight(cResourceWood);
	pCost = (pCost * 0.95) + (pWoodRate * .05);
	if(pLastWoodWeight != pCost) 
	{
		kbSetAICostWeight(cResourceWood, pCost);
		pLastWoodWeight = pCost;
	}
	// food
	pCost = kbGetAICostWeight(cResourceFood);
	pCost = (pCost * 0.95) + (pFoodRate * .05);
	if(pLastFoodWeight != pCost) 
	{
		kbSetAICostWeight(cResourceFood, pCost);
		pLastFoodWeight = pCost;
	}
	// Gold
	pCost = 1.00;
	if(pLastGoldWeight != pCost) 
	{
		kbSetAICostWeight(cResourceGold, 1.00); // gold always 1.0, others relative to gold
		pLastGoldWeight = pCost;
	}
}
//==============================================================================
/*
 setTechToForecasts
 updatedOn 2022/09/10
 Add cost of this tech to the global forecast arrays
 
 How to use
 call setTechToForecasts with tech id
 
 Example
 setTechToForecasts(techID);
*/
//==============================================================================
void setTechToForecasts(int pTechID = -1)
{ 
	debugRule("void setTechToForecasts",-0);
	if (pTechID < 0) return;
	xsArraySetFloat(gForecasts, cResourceGold, xsArrayGetFloat(gForecasts, cResourceGold) + kbTechCostPerResource(pTechID, cResourceGold));
	xsArraySetFloat(gForecasts, cResourceWood, xsArrayGetFloat(gForecasts, cResourceWood) + kbTechCostPerResource(pTechID, cResourceWood));
	xsArraySetFloat(gForecasts, cResourceFood, xsArrayGetFloat(gForecasts, cResourceFood) + kbTechCostPerResource(pTechID, cResourceFood));
}

//==============================================================================
/*
 setUnitToForecasts
 updatedOn 2022/09/10
 Add cost of unit to the global forecast arrays
 
 How to use
 call setUnitToForecasts with tech id
 
 Example
 setUnitToForecasts(pProtoUnit, pQty);
*/
//==============================================================================
void setUnitToForecasts(int pProtoUnit = -1, int pQty = -1)
{ // Add pQty of item pProtoUnit to the global forecast arrays	
	debugRule("void setUnitToForecasts",-0);
	if (pProtoUnit < 0) return;
	if (pQty < 1) return;
	xsArraySetFloat(gForecasts, cResourceGold, xsArrayGetFloat(gForecasts, cResourceGold) + (kbUnitCostPerResource(pProtoUnit, cResourceGold) * pQty));
	xsArraySetFloat(gForecasts, cResourceWood, xsArrayGetFloat(gForecasts, cResourceWood) + (kbUnitCostPerResource(pProtoUnit, cResourceWood) * pQty));
	xsArraySetFloat(gForecasts, cResourceFood, xsArrayGetFloat(gForecasts, cResourceFood) + (kbUnitCostPerResource(pProtoUnit, cResourceFood) * pQty));
} //end setUnitToForecasts

//==============================================================================
/*
 setForecasts
 updatedOn 2022/09/06
 Create 3-minute forecast of resource needs for food, wood and gold
 setForecasts now finds currently active plans and forcasts for them rather than having predefined forecasts 
 
 How to use
 is auto called in econManager
*/
//==============================================================================
void setForecasts(void)
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 30000,"setForecasts") == false) return;
	lastRunTime = gCurrentGameTime;	
	//reset forcast
	xsArraySetFloat(gForecasts, 0, 0.0);
	xsArraySetFloat(gForecasts, 1, 0.0);
	xsArraySetFloat(gForecasts, 2, 0.0);

	int pPlanId = -1;
	int pResearchPlans = aiPlanGetNumber(cPlanResearch, -1, true); //get number of active research plans
	int pBuildPlans = aiPlanGetNumber(cPlanBuild, -1, true); //get number of active build plans
	
	for (i = 0; < pResearchPlans)
	{ //loop through all research plans
		setTechToForecasts(aiPlanGetVariableInt(aiPlanGetIDByIndex(cPlanResearch, -1, true, i), cResearchPlanTechID, 0));
		if(i > 5) break; //only forcast max 5 plans
	}

	for (i = 0; < pBuildPlans)
	{ //loop through all build plans
		pPlanId = aiPlanGetIDByIndex(cPlanBuild, -1, true, i);
		if(aiPlanGetState(pPlanId) != cPlanStateBuild) 
		{
			setUnitToForecasts(aiPlanGetVariableInt(pPlanId, cBuildPlanBuildingTypeID, 0), 1);
		}
		if(i > 5) break;
	}

	if(gCurrentAge != cAge5 && gAiRevolted == false)
	{
		if (getCivIsAsian() == false)
		{
			setTechToForecasts(aiGetPoliticianListByIndex(gCurrentAge + 1, 0));
		}
		else
		{
			setUnitToForecasts(xsArrayGetInt(gAsianWonders, gCurrentAge + 1), 1);
		}
	}

	if(pBuildPlans == 0 && pResearchPlans == 0)
	{
		xsArraySetFloat(gForecasts, cResourceGold, xsArrayGetFloat(gForecasts, cResourceGold) + 1000);
		xsArraySetFloat(gForecasts, cResourceFood, xsArrayGetFloat(gForecasts, cResourceFood) + 1000);
		xsArraySetFloat(gForecasts, cResourceWood, xsArrayGetFloat(gForecasts, cResourceWood) + 200);
	}
	setCostWeight();
	updateEscrowsGatherers(); // Set desired gatherer ratios.  Spread them out per base, set per-base 
}

//==============================================================================
/*
 setResources
 updatedOn 2022/09/03
 Checks the current food and gold around the main base and decides if it is time to make farms and plantations
 
 How to use
 is auto called in econManager
*/
//==============================================================================
void setResources()
{
	debugRule("void setResources ",-0);
	if (gMainBase < 0 || gCurrentGameTime < 5000 || (gTimeToFarm && gTimeForPlantations) ) return; //Do not run under these conditions
	
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"setResources") == false) return;
	lastRunTime = gCurrentGameTime;	

	const int pMinFoodPerGatherer = 200; // When our supply gets below this level, start farming/plantations.
	const int pMinGoldPerGatherer = 120; // When our supply gets below this level, start farming/plantations.
	const int pBaseRadius = 80; //The distance from the base the AI will include 
	int pFoodAmount = -1; //The amount of food around the base
	int pNumFoodGatherers = -1; //Number of food Gatherers
	int pFoodPerGatherer = -1; //
	int pGoldAmount = -1;
	int pNumGoldGatherers = -1;
	int pGoldPerGatherer = -1;
	
	if(gTimeToFarm == false)
	{ //check time to farm
		pFoodAmount = kbGetAmountValidResources(gMainBase, cResourceFood, cAIResourceSubTypeEasy, pBaseRadius);
		if (getCivIsJapan() == false) pFoodAmount = pFoodAmount + kbGetAmountValidResources(gMainBase, cResourceFood, cAIResourceSubTypeHunt, pBaseRadius);
		if (getCivIsJapan() == false && getCivIsIndia() == false) pFoodAmount = pFoodAmount + kbGetAmountValidResources(gMainBase, cResourceFood, cAIResourceSubTypeHerdable, pBaseRadius);
		pNumFoodGatherers = aiGetResourceGathererPercentage(cResourceFood, cRGPActual) * gCurrentAliveSettlers; //;
		if (pNumFoodGatherers < 1) pNumFoodGatherers = 1;
		pFoodPerGatherer = pFoodAmount / pNumFoodGatherers;
		if (pFoodPerGatherer < pMinFoodPerGatherer) gTimeToFarm = true;
	}
	
	if(gTimeForPlantations == false)
	{ //check time to plantation
		pGoldAmount = kbGetAmountValidResources(gMainBase, cResourceGold, cAIResourceSubTypeEasy, pBaseRadius);
		pNumGoldGatherers = aiGetResourceGathererPercentage(cResourceGold, cRGPActual) * gCurrentAliveSettlers; //;
		if (pNumGoldGatherers < 1) pNumGoldGatherers = 1;
		pGoldPerGatherer = pGoldAmount / pNumGoldGatherers;
		if (pGoldPerGatherer < pMinGoldPerGatherer) gTimeForPlantations = true;
	}
	
	if (gCurrentGameTime > 900000)
	{ //set after 40 mins
		gTimeToFarm = true;
		gTimeForPlantations = true;
		
	}
}


//==============================================================================
/* mostHatedEnemy
	updatedOn 2022/02/14 By ageekhere  
*/
//==============================================================================
void mostHatedEnemy()
{ //find the ai's most hated enemy
	//Check if there is an enemy army near your main base, if so that player becomes the most hated
	//static int lastRunTime = 0;
	//if(functionDelay(lastRunTime, 60000,"mostHatedEnemy") == false) return;
	//lastRunTime = gCurrentGameTime;
	int currentCount = -1;
	int lastCount = -1;
	int playerToCounter = -1;

	int currentScore = -1;
	int lastScore = -1;
	if (kbIsFFA() == true)
	{
		static int findPlayerTc = -1;
		if (findPlayerTc == -1) findPlayerTc = kbUnitQueryCreate("findPlayerTc"+getQueryId());
		kbUnitQueryResetResults(findPlayerTc);
		kbUnitQuerySetPlayerRelation(findPlayerTc, cPlayerRelationEnemyNotGaia);
		kbUnitQuerySetUnitType(findPlayerTc, gTownCenter);
		kbUnitQuerySetPosition(findPlayerTc, gMainBaseLocation); //set the location
		kbUnitQuerySetAscendingSort(findPlayerTc, true);
		kbUnitQuerySetState(findPlayerTc, cUnitStateAlive);
		
		if (kbUnitQueryExecute(findPlayerTc) > 0)
		{
			for(x = 0; < kbUnitQueryExecute(findPlayerTc))
			{
				if(kbGetCivForPlayer(kbUnitGetPlayerID(kbUnitQueryGetResult(findPlayerTc, x))) == cCivObserver) continue;
				aiSetMostHatedPlayerID(kbUnitGetPlayerID(kbUnitQueryGetResult(findPlayerTc, x)));
				return;
			}
		}
		else
		{
			static int findEnemyPlayer = -1;
			if (findEnemyPlayer == -1) findEnemyPlayer = kbUnitQueryCreate("findPlayerTc"+getQueryId());
			kbUnitQueryResetResults(findEnemyPlayer);
			kbUnitQuerySetPlayerRelation(findEnemyPlayer, cPlayerRelationEnemyNotGaia);
			kbUnitQuerySetUnitType(findEnemyPlayer, cUnitTypeLogicalTypeLandMilitary);
			kbUnitQuerySetPosition(findEnemyPlayer, gMainBaseLocation); //set the location
			kbUnitQuerySetAscendingSort(findEnemyPlayer, true);
			kbUnitQuerySetState(findEnemyPlayer, cUnitStateAlive);
			
			for(x = 0; < kbUnitQueryExecute(findEnemyPlayer))//if (kbUnitQueryExecute(findEnemyPlayer) > 0)
			{
				if(kbGetCivForPlayer(kbUnitGetPlayerID(kbUnitQueryGetResult(findEnemyPlayer, x))) == cCivObserver) continue;
				aiSetMostHatedPlayerID(kbUnitGetPlayerID(kbUnitQueryGetResult(findEnemyPlayer, x)));
				return;
			}
				
		}	
	}

	for (x = 1; < cNumberPlayers - 1)
	{ //loop through players
		if(kbGetCivForPlayer(x) == cCivObserver) continue;
		if (gPlayerTeam != kbGetPlayerTeam(x) && (x != cMyID) && kbHasPlayerLost(x) == false && kbIsPlayerResigned(x) == false)
		{ //that are not on my team and is not me and are not dead
			currentCount = getUnitCountByLocation(cUnitTypeMilitary, x, cUnitStateAlive, gMainBaseLocation, 1050.0); //count the number of units
			if (currentCount > lastCount)
			{ //check army size to get largest army
				playerToCounter = x;
				lastCount = currentCount;
			} //end if
		} //end if
	} //end for
	//aiSetMostHatedPlayerID(playerToCounter);

	if (lastCount > 6)
	{ //has to have a min of 6 units before changing most hated player

		aiSetMostHatedPlayerID(playerToCounter); //set the new most hated player and which ai to counter
		return;
	} //end if

	for (x = 1; < cNumberPlayers)
	{ //loop through players
		if(kbGetCivForPlayer(x) == cCivObserver) continue;
		if (gPlayerTeam != kbGetPlayerTeam(x) && (x != cMyID) && kbHasPlayerLost(x) == false)
		{ //that are not on my team and is not me and are not dead
			currentScore = aiGetScore(x);
			if (lastScore < currentScore)
			{ //check army size to get largest army
				playerToCounter = x;
				lastScore = currentScore;
			} //end if
		} //end if
	} //end for
	if (playerToCounter != -1)
	{
		aiSetMostHatedPlayerID(playerToCounter);
		return;
	}


/*
	//-- use old method if under 6 
	if ((cvPlayerToAttack > 0) && (kbHasPlayerLost(cvPlayerToAttack) == false))
	{
		//aiEcho("****  Changing most hated enemy from "+aiGetMostHatedPlayerID()+" to "+cvPlayerToAttack);
		aiSetMostHatedPlayerID(cvPlayerToAttack);
		return;
	}
	// For now, find your position in your team (i.e. 2nd of 3) and
	// target the corresponding player on the other team.  If the other
	// team is smaller, count through again.  (I.e. in a 5v2, player 5 on
	// one team will attack the 1st player on the other.)

	int ourTeamSize = 0;
	int theirTeamSize = 0;
	int myPosition = 0;
	int i = 0;

	for (i = 1; < cNumberPlayers)
	{
		if (kbHasPlayerLost(i) == false)
		{
			if (kbGetPlayerTeam(i) == kbGetPlayerTeam(cMyID))
			{ // Self or ally 
				ourTeamSize = ourTeamSize + 1;
				if (i == cMyID)
					myPosition = ourTeamSize;
			}
			else
			{
				theirTeamSize = theirTeamSize + 1;
			}
		}
	}
	//updatedOn 2019/03/29 By ageekhere  
	//---------------------------
	ourTeamSizeMain = ourTeamSize;
	//---------------------------
	int targetPlayerPosition = 0;

	if (myPosition > theirTeamSize)
	{
		targetPlayerPosition = myPosition - (theirTeamSize * (myPosition / theirTeamSize)); // myPosition modulo theirTeamSize
		if (targetPlayerPosition == 0)
			targetPlayerPosition = theirTeamSize; // Need to be in range 1...teamsize, not 0...(teamSize-1).
	}
	else
		targetPlayerPosition = myPosition;

	int playerCount = 0;
	// Find the corresponding enemy player
	for (i = 1; < cNumberPlayers)
	{
		if ((kbHasPlayerLost(i) == false) && (kbGetPlayerTeam(i) != kbGetPlayerTeam(cMyID)))
		{
			playerCount = playerCount + 1;
			if (playerCount == targetPlayerPosition)
			{
				if (aiGetMostHatedPlayerID() != i)
					aiEcho("****  Changing most hated enemy from " + aiGetMostHatedPlayerID() + " to " + i);
				aiSetMostHatedPlayerID(i);
				if (gLandUnitPicker >= 0)
					kbUnitPickSetEnemyPlayerID(gLandUnitPicker, i); // Update the unit picker
			}
		}
	}
	*/
}

void setMilPopLimit(int age1 = 10, int age2 = 40, int age3 = 80, int age4 = 120, int age5 = 140)
{
	int limit = 10;
	int age = gCurrentAge;
	if (age == cvMaxAge)
		age = cAge5; // If we're at the highest allowed age, go for our full mil pop.
	// This overrides the normal settings, so an SPC AI capped at age 3 can use his full
	// military pop.
	switch (age)
	{
		case cAge1:
			{
				limit = age1;
				break;
			}
		case cAge2:
			{
				limit = age2;
				break;
			}
		case cAge3:
			{
				limit = age3;
				break;
			}
		case cAge4:
			{
				limit = age4;
				break;
			}
		case cAge5:
			{
				limit = age5;
				break;
			}
	}
	if ((cvMaxArmyPop >= 0) && (cvMaxNavyPop >= 0) && (limit > (cvMaxArmyPop + cvMaxNavyPop)))
		limit = cvMaxArmyPop + cvMaxNavyPop; // Manual pop limits have been set

	if ((cvMaxNavyPop <= 0) && (cvMaxArmyPop < limit) && (cvMaxArmyPop >= 0)) // Only army pop set?
		limit = cvMaxArmyPop;

	aiSetMilitaryPop(limit);
}

//==============================================================================
/* setPersonality()
	
	A function to set defaults that need to be in place before the loader file's
	preInit() function is called.  
	
	NOTE: Being phased out
*/
//==============================================================================
void setPersonality(void)
{
	int civ = kbGetCiv();
	if (civ == cCivTheCircle) civ = cCivGermans;
	if (civ == cCivXPSPC) civ = cCivBritish;
	if (civ == cCivSPCAct3) civ = cCivBritish;
	// Set behavior traits
	//aiEcho("My civ is "+civ);
	switch (civ)
	{
		case cCivBritish: // Elizabeth:  Infantry oriented boomer, favors natives
			{
				btRushBoom = 0.0;
				btOffenseDefense = 0.0;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.5;
				btBiasTrade = 0.5;
				break;
			}
		case cCivFrench: // Napoleon:  Cav oriented, balanced, favors natives
			{
				btRushBoom = 0.0;
				btOffenseDefense = 0.5;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 1.0; //0.5;
				btBiasTrade = 1.0; //0.5;
				break;
			}
		case cCivSpanish: // Isabella:  Rusher, disdains trading posts
			{
				btRushBoom = 1.0;
				btOffenseDefense = 1.0;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.0;
				btBiasTrade = 0.5;
				break;
			}
		case cCivRussians: // Ivan:  Infantry oriented turtler
			{
				btRushBoom = 0.0; // Slight boomer, he needs the econ in age 2 to keep settlers training.
				btOffenseDefense = 0.0;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.5;
				btBiasTrade = 0.5;
				break;
			}
		case cCivGermans: // Cavalry oriented rusher
			{
				btRushBoom = 1.0;
				btOffenseDefense = 0.5;
				btBiasCav = 0.3;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.0;
				btBiasTrade = 0.5;
				break;
			}
		case cCivDutch: // Turtler, boomish, huge emphasis on trade
			{
				btRushBoom = 0.0;
				btOffenseDefense = 0.0;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.5;
				btBiasTrade = 0.5;
				break;
			}
		case cCivPortuguese: // Artillery oriented boomer, favors trade   
			{
				btRushBoom = 0.0;
				btOffenseDefense = 0.5;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.5;
				btBiasTrade = 0.5;
				break;
			}
		case cCivOttomans: // Artillery oriented, balanced
			{
				btRushBoom = 0.5;
				btOffenseDefense = 0.5;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.1;
				btBiasNative = 0.5;
				btBiasTrade = 0.5;
				break;
			}
		case cCivXPSioux: // Extreme rush, ignores trade routes
			{
				btRushBoom = 1.0;
				btOffenseDefense = 0.0;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.0;
				btBiasTrade = 0.5;
				break;
			}
		case cCivXPIroquois: // Balanced, trade and native bias.
			{
				btRushBoom = 0.0;
				btOffenseDefense = 0.0;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.5;
				btBiasTrade = 0.5;
				break;
			}
		case cCivXPAztec: // Randomized, but usually light boom, defensive.
			{
				btRushBoom = 0.0;
				btOffenseDefense = 1.0;
				btBiasCav = 0.0;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.5;
				btBiasTrade = 0.5;
				break;
			}
		case cCivChinese: // Kangxi:  Infantry oriented turtler
			{
				btRushBoom = 0.0;
				btOffenseDefense = 0.0;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.5;
				btBiasTrade = 0.5;
				break;
			}
		case cCivJapanese: // Extreme rush, ignores trade routes
			{
				btRushBoom = 1.0;
				btOffenseDefense = 1.0;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.0;
				btBiasTrade = 0.5;
				break;
			}
		case cCivIndians: // Cavalry oriented, balanced
			{
				btRushBoom = 1.0;
				btOffenseDefense = 0.0;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.5;
				btBiasTrade = 0.5;
				break;
			}
		case cCivUSA: // Washington
			{
				btRushBoom = 0.5;
				btOffenseDefense = 0.0;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.0;
				btBiasTrade = 0.5;
				break;
			}
		case cCivItalians: // Pope
			{
				btRushBoom = 0.0;
				btOffenseDefense = 0.0;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.5;
				btBiasTrade = 0.5;
				break;
			}
		case cCivSwedish: // Christina
			{
				btRushBoom = 0.5;
				btOffenseDefense = 0.5;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.0;
				btBiasTrade = 0.5;
				break;
			}
		case cCivMaltese: // Alain
			{
				btRushBoom = 0.5;
				btOffenseDefense = 0.5;
				btBiasCav = 0.3;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.0;
				btBiasTrade = 0.5;
				break;
			}
		case cCivColombians: // Bolivar
			{
				btRushBoom = 0.0;
				btOffenseDefense = 0.0;
				btBiasCav = 0.2;
				btBiasInf = 0.5;
				btBiasArt = 0.0;
				btBiasNative = 0.0;
				btBiasTrade = 0.5;
				break;
			}

	}
	btBiasNative = 1.0;
	btBiasTrade = 1.0;

	/*
		if (gSPC == false)
		btBiasCav = btBiasCav - 0.30; // Adjust cav-heavy choices across the board.  This will reduce the pref by .15, equivalent to a combat efficiency change of .075
	*/

	// Set default politician choices
	aiSetPoliticianChoice(cAge2, aiGetPoliticianListByIndex(cAge2, 0)); // Just grab the first available
	aiSetPoliticianChoice(cAge3, aiGetPoliticianListByIndex(cAge3, 0));
	aiSetPoliticianChoice(cAge4, aiGetPoliticianListByIndex(cAge4, 0));
	aiSetPoliticianChoice(cAge5, aiGetPoliticianListByIndex(cAge5, 0));



	//-- See who we are playing against.  If we have played against these players before, seed out unitpicker data, and then chat some.
	//XS_HELP("float aiPersonalityGetGameResource(int playerHistoryIndex, int gameIndex, int resourceID): Returns the given resource from the gameIndex game. If gameIndex is -1, this will return the avg of all games played.")
	//XS_HELP("int aiPersonalityGetGameUnitCount(int playerHistoryIndex, int gameIndex, int unitType): Returns the unit count from the gameIndex game. If gameIndex is -1, this will return the avg of all games played.")
	// To understand my opponent's unit biases, I'll have to do the following:
	//          1)  Store the opponents civ each game
	//          2)  On game start, look up his civ from last game
	//          3)  Based on his civ, look up how many units he made of each class (inf, cav, art), compare to 'normal'.
	//          4)  Set unitPicker biases to counter what he's likely to send.  

	int numPlayerHistories = aiPersonalityGetNumberPlayerHistories();
	//aiEcho("PlayerHistories: "+numPlayerHistories);
	for (pid = 1; < cNumberPlayers)
	{
		//-- Skip ourself.
		if (pid == cMyID)
			continue;

		//-- get player name
		string playerName = kbGetPlayerName(pid);
		//aiEcho("PlayerName: "+playerName);

		//-- have we played against them before.
		int playerHistoryID = aiPersonalityGetPlayerHistoryIndex(playerName);
		if (playerHistoryID == -1)
		{
			//aiEcho("PlayerName: Never played against");
			//-- Lets make a new player history.
			playerHistoryID = aiPersonalityCreatePlayerHistory(playerName);
			if (kbIsPlayerAlly(pid) == true)
				sendStatement(pid, cAICommPromptToAllyIntro);
			else
				sendStatement(pid, cAICommPromptToEnemyIntro);
			if (playerHistoryID == -1)
			{
				//aiEcho("PlayerName: Failed to create player history for "+playerName);
				continue;
			}
			//aiEcho("PlayerName: Created new history for "+playerName);
		}
		else
		{
			//-- get how many times we have played against them.
			float totalGames = aiPersonalityGetPlayerGamesPlayed(playerHistoryID, cPlayerRelationAny);
			float numberGamePlayedAgainst = aiPersonalityGetPlayerGamesPlayed(playerHistoryID, cPlayerRelationEnemy);
			float numberGamesTheyWon = aiPersonalityGetTotalGameWins(playerHistoryID, cPlayerRelationEnemy);
			float myWinLossRatio = 1.0 - (numberGamesTheyWon / numberGamePlayedAgainst);
			//aiEcho("PlayedAgainst: "+numberGamePlayedAgainst);
			//aiEcho("TimesTheyWon: "+numberGamesTheyWon);
			//aiEcho("MyWinLossRatio: "+myWinLossRatio);

			bool iWonOurLastGameAgainstEachOther = aiPersonalityGetDidIWinLastGameVS(playerHistoryID);
			//bool weWonOurLastGameTogether; <-- cant do yet.


			//-- get how fast they like to attack
			// Minus one game index gives an average.
			int avgFirstAttackTime = aiPersonalityGetGameFirstAttackTime(playerHistoryID, -1);
			//aiEcho("Player's Avg first Attack time: "+avgFirstAttackTime);

			int lastFirstAttackTime = aiPersonalityGetGameFirstAttackTime(playerHistoryID, totalGames - 1);
			//aiEcho("Player's Last game first Attack time: "+lastFirstAttackTime);

			//-- save some info.
			aiPersonalitySetPlayerUserVar(playerHistoryID, "myWinLossPercentage", myWinLossRatio);
			//-- test, get the value back out
			float tempFloat = aiPersonalityGetPlayerUserVar(playerHistoryID, "myWinLossPercentage");

			// Consider chats based on player history...
			// First, combinations of "was ally last time" and "am ally this time"
			bool wasAllyLastTime = true;
			bool isAllyThisTime = true;
			if (aiPersonalityGetPlayerUserVar(playerHistoryID, "wasMyAllyLastGame") == 0.0)
				wasAllyLastTime = false;
			if (kbIsPlayerAlly(pid) == false)
				isAllyThisTime = false;
			bool difficultyIsHigher = false;
			bool difficultyIsLower = false;
			float lastDifficulty = aiPersonalityGetPlayerUserVar(playerHistoryID, "lastGameDifficulty");
			if (lastDifficulty >= 0.0)
			{
				if (lastDifficulty > gWorldDifficulty)
					difficultyIsLower = true;
				if (lastDifficulty < gWorldDifficulty)
					difficultyIsHigher = true;
			}
			bool iBeatHimLastTime = false;
			bool heBeatMeLastTime = false;
			bool iCarriedHimLastTime = false;
			bool heCarriedMeLastTime = false;

			if (aiPersonalityGetPlayerUserVar(playerHistoryID, "heBeatMeLastTime") == 1.0) // STORE ME
				heBeatMeLastTime = true;
			if (aiPersonalityGetPlayerUserVar(playerHistoryID, "iBeatHimLastTime") == 1.0) // STORE ME
				iBeatHimLastTime = true;
			if (aiPersonalityGetPlayerUserVar(playerHistoryID, "iCarriedHimLastTime") == 1.0) // STORE ME
				iCarriedHimLastTime = true;
			if (aiPersonalityGetPlayerUserVar(playerHistoryID, "heCarriedMeLastTime") == 1.0) // STORE ME
				heCarriedMeLastTime = true;


			if (wasAllyLastTime == false)
			{
				if (aiPersonalityGetPlayerUserVar(playerHistoryID, "iBeatHimLastTime") == 1.0) // STORE ME
					iBeatHimLastTime = true;
				if (aiPersonalityGetPlayerUserVar(playerHistoryID, "heBeatMeLastTime") == 1.0) // STORE ME
					heBeatMeLastTime = true;
			}

			bool iWonLastGame = false;
			if (aiPersonalityGetPlayerUserVar(playerHistoryID, "iWonLastGame") == 1.0) // STORE ME
				iWonLastGame = true;


			if (isAllyThisTime)
			{ // We are allies
				if (difficultyIsHigher == true)
					sendStatement(pid, cAICommPromptToAllyIntroWhenDifficultyHigher);
				if (difficultyIsLower == true)
					sendStatement(pid, cAICommPromptToAllyIntroWhenDifficultyLower);
				if (iCarriedHimLastTime == true)
					sendStatement(pid, cAICommPromptToAllyIntroWhenICarriedHimLastGame);
				if (heCarriedMeLastTime == true)
					sendStatement(pid, cAICommPromptToAllyIntroWhenHeCarriedMeLastGame);
				if (iBeatHimLastTime == true)
					sendStatement(pid, cAICommPromptToAllyIntroWhenIBeatHimLastGame);
				if (heBeatMeLastTime == true)
					sendStatement(pid, cAICommPromptToAllyIntroWhenHeBeatMeLastGame);

				//aiEcho("Last map ID was "+aiPersonalityGetPlayerUserVar(playerHistoryID, "lastMapID"));
				if ((getMapID() >= 0) && (getMapID() == aiPersonalityGetPlayerUserVar(playerHistoryID, "lastMapID")))
				{
					sendStatement(pid, cAICommPromptToAllyIntroWhenMapRepeats);
					//aiEcho("Last map ID was "+aiPersonalityGetPlayerUserVar(playerHistoryID, "lastMapID"));
				}
				if (wasAllyLastTime)
				{
					//aiEcho(playerName + " was my ally last game and is my ally this game.");
					if (iWonLastGame == false)
						sendStatement(pid, cAICommPromptToAllyIntroWhenWeLostLastGame);
					else
						sendStatement(pid, cAICommPromptToAllyIntroWhenWeWonLastGame);
				}
				else
				{
					aiEcho(playerName + " was my enemy last game and is my ally this game.");
				}
			}
			else
			{ // We are enemies
				if (difficultyIsHigher == true)
					sendStatement(pid, cAICommPromptToEnemyIntroWhenDifficultyHigher);
				if (difficultyIsLower == true)
					sendStatement(pid, cAICommPromptToEnemyIntroWhenDifficultyLower);
				if ((getMapID() >= 0) && (getMapID() == aiPersonalityGetPlayerUserVar(playerHistoryID, "lastMapID")))
					sendStatement(pid, cAICommPromptToEnemyIntroWhenMapRepeats);
				if (wasAllyLastTime)
				{
					aiEcho(playerName + " was my ally last game and is my enemy this game.");
				}
				else
				{
					//aiEcho(playerName + " was my enemy last game and is my enemy this game.");
					// Check if he changed the odds
					// First, see if enemyCount is the same, but ally count is down
					int enemyCount = aiPersonalityGetPlayerUserVar(playerHistoryID, "myEnemyCount");
					int allyCount = aiPersonalityGetPlayerUserVar(playerHistoryID, "myAllyCount");
					if (enemyCount == getEnemyCount())
					{
						if (allyCount > getAllyCount()) // I have fewer allies now
							sendStatement(pid, cAICommPromptToEnemyIntroWhenTeamOddsEasier); // He wimped out
						if (allyCount < getAllyCount()) // I have more allies now
							sendStatement(pid, cAICommPromptToEnemyIntroWhenTeamOddsHarder); // He upped the difficulty
					}
					// Next, see if allyCount is the same, but enemyCount is smaller
					if (allyCount == getAllyCount())
					{
						if (enemyCount > getEnemyCount()) // I have fewer enemies now
							sendStatement(pid, cAICommPromptToEnemyIntroWhenTeamOddsHarder); // He upped the difficulty
						if (enemyCount < getEnemyCount()) // I have more enemies now
							sendStatement(pid, cAICommPromptToEnemyIntroWhenTeamOddsEasier); // He wimped out
					}
				}
			}
		}

		// Save info about this game
		aiPersonalitySetPlayerUserVar(playerHistoryID, "lastGameDifficulty", gWorldDifficulty);
		int wasAlly = 0;
		if (kbIsPlayerAlly(pid) == true)
			wasAlly = 1;
		else
		{ // He is an enemy, remember the odds (i.e. 1v3, 2v2, etc.)
			aiPersonalitySetPlayerUserVar(playerHistoryID, "myAllyCount", getAllyCount());
			aiPersonalitySetPlayerUserVar(playerHistoryID, "myEnemyCount", getEnemyCount());
		}
		aiPersonalitySetPlayerUserVar(playerHistoryID, "wasMyAllyLastGame", wasAlly);
		aiPersonalitySetPlayerUserVar(playerHistoryID, "lastMapID", getMapID());

	}
}
//==============================================================================
/*
	setBaseFrontBack
	updatedOn 2023/06/29
	sets the base front and back. Eco building are built at the back of the base
	
	How to use
	setBaseFrontBack is auto called by mainRules
*/
//==============================================================================
void setBaseFrontBack(void)
{
	debugRule("setBaseFrontBack", -1);
	static vector pBaseLocation = cInvalidVector;
	if (pBaseLocation != gMainBaseLocation && gMainBaseLocation != cInvalidVector)
	{ //only update the front and back of base if gMainBaseLocation changes and is not invalid
		debugRule("setBaseFrontBack - set new pBaseLocation", 2);
		pBaseLocation = gMainBaseLocation;
	} //end if
	else
	{
		debugRule("setBaseFrontBack - end", 0);
		return;
	} //end else

	vector pBackLocation = cInvalidVector;
	vector pFrontLocation = cInvalidVector;
	vector pBackLocationCheck = gMainBaseLocation;
	vector pFrontLocationCheck = gMainBaseLocation;
	float pBackFarthestDist = 0;
	float pFrontFarthestDist = 99999999;
	float pBackDistCheck = 0;
	float pFrontDistCheck = 0;
	float pDx = 5;
	float pDz = 5;
	for (t = 0; < 8)
	{
		debugRule("setBaseFrontBack - for t " + t, 0);
		pDx = 5;
		pDz = 5;
		switch (t)
		{
			case 0:{ pDx = -0.9 * pDx; pDz = 0.9 * pDz; break;} // W
			case 1:{ pDx = 0.0; break;}// NW
			case 2:{ pDx = 0.9 * pDx; pDz = 0.9 * pDz; break;}// N
			case 3:{ pDz = 0.0; break;}// NE
			case 4:{ pDx = 0.9 * pDx; pDz = -0.9 * pDz; break;}// E	
			case 5:{ pDx = 0.0; pDz = -1.0 * pDz; break;}// SE
			case 6:{ pDx = -0.9 * pDx; pDz = -0.9 * pDz; break;}// S
			case 7:{ pDx = -1.0 * pDx; pDz = 0; break;}// SW
		}
		pBackLocationCheck = gMainBaseLocation;
		pBackLocationCheck = xsVectorSetX(pBackLocationCheck, xsVectorGetX(pBackLocationCheck) + pDx);
		pBackLocationCheck = xsVectorSetZ(pBackLocationCheck, xsVectorGetZ(pBackLocationCheck) + pDz);
		pBackDistCheck = distance(pBackLocationCheck, gMapCenter);
		if (pBackDistCheck > pBackFarthestDist)
		{
			pBackLocation = pBackLocationCheck;
			pBackFarthestDist = pBackDistCheck;
		}
		pFrontLocationCheck = gMainBaseLocation;
		pFrontLocationCheck = xsVectorSetX(pFrontLocationCheck, xsVectorGetX(pFrontLocationCheck) + pDx);
		pFrontLocationCheck = xsVectorSetZ(pFrontLocationCheck, xsVectorGetZ(pFrontLocationCheck) + pDz);
		pFrontDistCheck = distance(pFrontLocationCheck, gMapCenter);
		if (pFrontDistCheck < pFrontFarthestDist)
		{
			pFrontLocation = pFrontLocationCheck;
			pFrontFarthestDist = pFrontDistCheck;
		}
	}
	gFrontBaseLocation = pFrontLocation;
	gBackBaseLocation = pBackLocation;
	debugRule("setBaseFrontBack - set front and back", 1);
	debugRule("setBaseFrontBack - end", 0);
} //end setBaseFrontBack

void setIntArrayToDefaults(int pArrayId = -1)
{
	debugRule("void setIntArrayToDefaults ",-0);
	static int pArraySize = -1;
	pArraySize = xsArrayGetSize(pArrayId);
	for(i = 0; < pArraySize)
	{
		debugRule("void setIntArrayToDefaults - for(i = 0; < pArrayId) " + i,1);
		if(xsArrayGetInt(pArrayId,i) == -1 )return;
		xsArraySetInt(pArrayId,i,-1);
	}
}

void setFloatArrayToDefaults(int pArrayId = -1)
{
	static int pArraySize = -1;
	pArraySize = xsArrayGetSize(pArrayId);
	for(i = 0; < pArraySize)
	{
		if(xsArrayGetFloat(pArrayId,i) == -1.0 )return;
		xsArraySetFloat(pArrayId,i,-1.0);
	}
}

void setBoolArrayToDefaults(int pArrayId = -1)
{
	static int pArraySize = -1;
	pArraySize = xsArrayGetSize(pArrayId);
	for(i = 0; < pArraySize)
	{
		xsArraySetBool(pArrayId,i,false);
	}
}
void setStringArrayToDefaults(int pArrayId = -1)
{
	static int pArraySize = -1;
	pArraySize = xsArrayGetSize(pArrayId);
	for(i = 0; < pArraySize)
	{
		if(xsArrayGetString(pArrayId,i) == "" )return;
		xsArraySetString(pArrayId,i,"");
	}
}

void setUnitIdle(int pUnitId = -1)
{
	aiTaskUnitMove(pUnitId,kbUnitGetPosition(pUnitId));
	//aiPlanDestroy(kbUnitGetPlanID(pUnitId));
}


void setMain()
{

}