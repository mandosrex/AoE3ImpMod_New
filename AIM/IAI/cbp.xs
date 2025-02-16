
bool is_building_near_edge(int pLocationX = -1, int pLocationZ = -1, int building_size = -1, int map_radius = -1) 
{
    // Calculate the distance between the center of the building and the center of the map
    int dist = xsSqrt((pLocationX - map_radius) * (pLocationX - map_radius) + (pLocationZ - map_radius) * (pLocationZ - map_radius));
    // Check if the building is too close to the edge of the map
	
    if (dist > (map_radius - building_size)) 
	{
        return (true);
    }
    return (false);
}

bool mapEdgeCheck(float pLocX = -1.0, float pLocZ = -1.0 )
{
	float building_size = 2;
	float mapX = kbGetMapXSize();
	float mapZ = kbGetMapZSize();
	
	float map_radius = mapX /2; //xsSqrt(mapX * mapX + mapZ * mapZ) / 2;
	
	if (is_building_near_edge(pLocX, pLocZ, building_size, map_radius)) 
	{
		return(false);
	} 
	else 
	{
		 return(true);
	}
	return(false);
}


	
int buildingId = -1;
int builderWagon = -1;
int newBuildingID = -1;

string buildingType = "na";
const int maxHouseDefault = 20;
const int maxMill = 6;
const int maxPlantation = 6;

rule BuildBluePrint
inactive
minInterval 0
{ 
	debugRule("BuildBluePrint",-1);
	static int pSlot = 0;
	static vector pLocation = cInvalidVector;
	static float pXvalue = -1;
	static float pZvalue = -1;
	static int pStartNum = -1;
	static int pUnitCount = -1;
	static int pBuilder = -1;
	static int pSlotMax = -1;
	//FailedAttempt
	static int houseDefaultFailedAttempts = 0;
	static int millFailedAttempts = 0;
	static int farmFailedAttempts = 0;
	static int plantationFailedAttempts = 0;
	static int outpostFailedAttempts = 0;
	static int firepitFailedAttempts = 0;
	static int buildingFailedAttempts = 0;
	static int wonderFailedAttempts = 0;
	//DefaultPositions
	static bool pResetHouseDefaultPositions = true;
	static bool pResetOutpostPositions = true;
	static bool pResetMillPositions = true;
	static bool pResetFarmPositions = true;
	static bool pPlantPositions = true;
	static bool pBuildingPositions = true;
	static bool pJapanWonderPositions = true;
	//Layout arrays 
	static int pOutpostLocationArray = -1;
	static int pHouseDefaultLocationArray = -1;
	static int pMillLocationArray = -1;
	static int pFarmLocationArray = -1;
	static int pPlantLocationArray = -1;
	static int pBuildingLocationArray = -1;
	static int pJapanWonderLocationArray = -1;
	static bool pUseLocationPlan = false;
	const int pMaxFails = 1;

	static int pBuildPlan = -1;



	//Create arrays for vector
	if(pOutpostLocationArray == -1) pOutpostLocationArray = xsArrayCreateVector(16, cInvalidVector, "pOutpostLocationArray");
	if(pHouseDefaultLocationArray == -1) pHouseDefaultLocationArray = xsArrayCreateVector(20, cInvalidVector, "pHouseDefaultLocationArray");
	if(pMillLocationArray == -1) pMillLocationArray = xsArrayCreateVector(6, cInvalidVector, "pMillLocationArray");
	if(pPlantLocationArray == -1) pPlantLocationArray = xsArrayCreateVector(6, cInvalidVector, "pPlantPositions");
	if(pBuildingLocationArray == -1) pBuildingLocationArray = xsArrayCreateVector(20, cInvalidVector, "pBuildingLocationArray");
	if(pFarmLocationArray == -1) pFarmLocationArray = xsArrayCreateVector(6, cInvalidVector, "pFarmLocationArray");
	if(pJapanWonderLocationArray == -1) pJapanWonderLocationArray = xsArrayCreateVector(4, cInvalidVector, "pJapanWonderLocationArray");

	if(pResetOutpostPositions == true)
	{
		pLocation = xsVectorSetX(gMainTownCenterLocation,xsVectorGetX(gMainTownCenterLocation) + 30);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 25); xsArraySetVector(pOutpostLocationArray,0,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 6);  xsArraySetVector(pOutpostLocationArray,1,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 6);  xsArraySetVector(pOutpostLocationArray,2,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 6);  xsArraySetVector(pOutpostLocationArray,3,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 52); xsArraySetVector(pOutpostLocationArray,4,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 6);  xsArraySetVector(pOutpostLocationArray,5,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 6);  xsArraySetVector(pOutpostLocationArray,6,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 6);  xsArraySetVector(pOutpostLocationArray,7,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 54); xsArraySetVector(pOutpostLocationArray,8,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 6);  xsArraySetVector(pOutpostLocationArray,9,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 6);  xsArraySetVector(pOutpostLocationArray,10,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 6);  xsArraySetVector(pOutpostLocationArray,11,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 56); xsArraySetVector(pOutpostLocationArray,12,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 6);  xsArraySetVector(pOutpostLocationArray,13,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 6);  xsArraySetVector(pOutpostLocationArray,14,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 6);  xsArraySetVector(pOutpostLocationArray,15,pLocation);
		vectorSortCenter(pOutpostLocationArray,gMapCenter,"nearest");
		pLocation = cInvalidVector;
		pResetOutpostPositions = false;
	}

	if(pResetHouseDefaultPositions == true)
	{
		pLocation = gMainTownCenterLocation;
		pLocation = xsVectorSetZ(gMainTownCenterLocation,xsVectorGetZ(gMainTownCenterLocation) - 3);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(gMainTownCenterLocation) + 15);
		if(gCurrentCiv == cCivChinese) pLocation = xsVectorSetX(pLocation,xsVectorGetX(gMainTownCenterLocation) + 14);
		xsArraySetVector(pHouseDefaultLocationArray,0,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 6);  xsArraySetVector(pHouseDefaultLocationArray,1,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 6);  xsArraySetVector(pHouseDefaultLocationArray,2,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 6);  xsArraySetVector(pHouseDefaultLocationArray,3,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 6);  xsArraySetVector(pHouseDefaultLocationArray,4,pLocation);
		if(gCurrentCiv == cCivChinese) pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 5);
		                                                                  xsArraySetVector(pHouseDefaultLocationArray,4,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 6);  xsArraySetVector(pHouseDefaultLocationArray,5,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 6);  xsArraySetVector(pHouseDefaultLocationArray,6,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 6);  xsArraySetVector(pHouseDefaultLocationArray,7,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 6);  xsArraySetVector(pHouseDefaultLocationArray,8,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 6);  xsArraySetVector(pHouseDefaultLocationArray,9,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 6);  xsArraySetVector(pHouseDefaultLocationArray,10,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 6);  xsArraySetVector(pHouseDefaultLocationArray,11,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 6);  xsArraySetVector(pHouseDefaultLocationArray,12,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 6);  xsArraySetVector(pHouseDefaultLocationArray,13,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 6);  xsArraySetVector(pHouseDefaultLocationArray,14,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 6);  xsArraySetVector(pHouseDefaultLocationArray,15,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 6);  xsArraySetVector(pHouseDefaultLocationArray,16,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 6);  xsArraySetVector(pHouseDefaultLocationArray,17,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 6);  xsArraySetVector(pHouseDefaultLocationArray,18,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 6);  xsArraySetVector(pHouseDefaultLocationArray,19,pLocation);
		vectorSortCenter(pHouseDefaultLocationArray,gMapCenter,"farthest");
		pLocation = cInvalidVector;
		pResetHouseDefaultPositions = false;
	}
	
	if(pResetMillPositions == true)
	{
		pLocation = xsVectorSetZ(gMainTownCenterLocation,xsVectorGetZ(gMainTownCenterLocation) - 13);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 26);  xsArraySetVector(pMillLocationArray,0,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 15);  xsArraySetVector(pMillLocationArray,1,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 15);  xsArraySetVector(pMillLocationArray,2,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 53);  xsArraySetVector(pMillLocationArray,3,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 14);  xsArraySetVector(pMillLocationArray,4,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 15);  xsArraySetVector(pMillLocationArray,5,pLocation);
		vectorSortCenter(pMillLocationArray,gMapCenter,"farthest");
		pLocation = cInvalidVector;
		pResetMillPositions = false;
	}

	if(pResetFarmPositions == true)
	{
		pLocation = xsVectorSetZ(gMainTownCenterLocation,xsVectorGetZ(gMainTownCenterLocation) - 13);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 28);  xsArraySetVector(pFarmLocationArray,0,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 15);  xsArraySetVector(pFarmLocationArray,1,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 15);  xsArraySetVector(pFarmLocationArray,2,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 55);  xsArraySetVector(pFarmLocationArray,3,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 14);  xsArraySetVector(pFarmLocationArray,4,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 15);  xsArraySetVector(pFarmLocationArray,5,pLocation);
		vectorSortCenter(pFarmLocationArray,gMapCenter,"farthest");
		pLocation = cInvalidVector;
		pResetFarmPositions = false;
	}

	if(pPlantPositions == true)
	{
		pLocation = xsVectorSetX(gMainTownCenterLocation,xsVectorGetX(gMainTownCenterLocation) + 14);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 28);  xsArraySetVector(pPlantLocationArray,0,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 14);  xsArraySetVector(pPlantLocationArray,1,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 14);  xsArraySetVector(pPlantLocationArray,2,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 56);  xsArraySetVector(pPlantLocationArray,3,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 14);  xsArraySetVector(pPlantLocationArray,4,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 14);  xsArraySetVector(pPlantLocationArray,5,pLocation);
		vectorSortCenter(pPlantLocationArray,gMapCenter,"farthest");
		pLocation = cInvalidVector;
		pPlantPositions = false;
	}

	if(pBuildingPositions == true)
	{
		if(getCivIsNative())
		{
			pLocation = xsVectorSetZ(gMainTownCenterLocation,xsVectorGetZ(gMainTownCenterLocation) - 13);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 43);  xsArraySetVector(pBuildingLocationArray,0,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,1,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,2,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,3,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 8);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,4,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,5,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,6,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,7,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,8,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 6);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,9,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,10,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,11,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,12,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,13,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 6); 
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,14,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,15,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,16,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,17,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,18,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 6); 
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,19,pLocation);
		}
		else
		{
			pLocation = xsVectorSetZ(gMainTownCenterLocation,xsVectorGetZ(gMainTownCenterLocation) - 13);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 40);  xsArraySetVector(pBuildingLocationArray,0,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,1,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,2,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,3,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 8);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,4,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,5,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,6,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,7,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,8,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) - 6);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,9,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,10,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,11,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,12,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 15);  xsArraySetVector(pBuildingLocationArray,13,pLocation);
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 6); 
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,14,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,15,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,16,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,17,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,18,pLocation);
			pLocation = xsVectorSetX(pLocation,xsVectorGetX(pLocation) + 6); 
			pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) + 15);  xsArraySetVector(pBuildingLocationArray,19,pLocation);
		}
		vectorSortCenter(pBuildingLocationArray,gMapCenter,"farthest");
		pLocation = cInvalidVector;
		pBuildingPositions = false;
	}
	
	if(pJapanWonderPositions == true)
	{
		pLocation = gMainTownCenterLocation;
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(gMainTownCenterLocation) + 27);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(gMainTownCenterLocation) + 10);  xsArraySetVector(pJapanWonderLocationArray,0,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(gMainTownCenterLocation) - 10);  xsArraySetVector(pJapanWonderLocationArray,1,pLocation);
		pLocation = xsVectorSetZ(pLocation,xsVectorGetZ(pLocation) - 54);  xsArraySetVector(pJapanWonderLocationArray,2,pLocation);
		pLocation = xsVectorSetX(pLocation,xsVectorGetX(gMainTownCenterLocation) + 10);  xsArraySetVector(pJapanWonderLocationArray,3,pLocation);
		if (kbProtoUnitIsType(cMyID, buildingId, cUnitTypeAbstractFort)) vectorSortCenter(pJapanWonderLocationArray,gMapCenter,"nearest");
		else vectorSortCenter(pJapanWonderLocationArray,gMapCenter,"farthest");
		pLocation = cInvalidVector;
		pJapanWonderPositions = false;
	}
	debugRule("BuildBluePrint - set up locations done ",0);
	
	pUnitCount = kbUnitCount(cMyID, buildingId, cUnitStateABQ); //Count the state ABQ to see if a build was successful
	if(pStartNum == -1) pStartNum = pUnitCount; //Save the number of building from buildingId with the ABQ state
	//Set the max number of build positions
	if(buildingType == "houseDefault" || buildingType == "building") pSlotMax = 20;
	else if(buildingType == "outpost") pSlotMax = 16;
	else if(buildingType == "mill" || buildingType == "farm" || buildingType == "plantation") pSlotMax = 6;
	else if(buildingType == "wonder") pSlotMax = 4;
	else if(buildingType == "firepit") pSlotMax = 1;


//if(pUnitCount > pStartNum) debugRule("hit 1",0);
//if(pSlot == pSlotMax) debugRule("hit 2",0);
//if(getBuildable(buildingId) == false && builderWagon == -1) debugRule("hit 3",0);




	if(pUnitCount > pStartNum || pSlot == pSlotMax || (getBuildable(buildingId) == false && builderWagon == -1))
	{ //End the rule when Build is successful, found no clear slots, getBuildable is flase or the bulding state of buildingid is building  
		debugRule("BuildBluePrint - ending  - pSlot " + pSlot ,1);

		if(pSlot == pSlotMax) // && getBuildable(buildingId) == true) 
		{ //A free slot was unable to be found, when there are 5 failed attemps make a build plan
			pUseLocationPlan = false;

			debugRule("BuildBluePrint - ending  - buildingType " + buildingType ,2);
			if(buildingType == "houseDefault")
			{
				debugRule("BuildBluePrint - ending  - failed house" ,2);
				houseDefaultFailedAttempts++; 
				if(houseDefaultFailedAttempts > pMaxFails){ houseDefaultFailedAttempts = 0; pUseLocationPlan = true; }
			}
			else if(buildingType == "mill")
			{
				debugRule("BuildBluePrint - ending  - failed mill" ,2);
				millFailedAttempts++; 
				if(millFailedAttempts > pMaxFails){ millFailedAttempts = 0; pUseLocationPlan = true; }
			}
			else if(buildingType == "farm")
			{
				debugRule("BuildBluePrint - ending  - failed farm" ,2);
				farmFailedAttempts++; 
				if(farmFailedAttempts > pMaxFails){ farmFailedAttempts = 0; pUseLocationPlan = true; }
			}
			else if(buildingType == "plantation")
			{
				debugRule("BuildBluePrint - ending  - failed plant" ,2);
				plantationFailedAttempts++; 
				if(plantationFailedAttempts > pMaxFails){ plantationFailedAttempts = 0; pUseLocationPlan = true; }
			}
			else if(buildingType == "outpost") 
			{
				debugRule("BuildBluePrint - ending  - failed outpost" ,2);
				outpostFailedAttempts++; 
				if(outpostFailedAttempts > pMaxFails){ outpostFailedAttempts = 0; pUseLocationPlan = true; }	
			}
			else if(buildingType == "firepit")
			{
				debugRule("BuildBluePrint - ending  - failed firepit" ,2);
				firepitFailedAttempts++; 
				if(firepitFailedAttempts > pMaxFails){ firepitFailedAttempts = 0; pUseLocationPlan = true; }
			}
			else if(buildingType == "building")
			{
				debugRule("BuildBluePrint - ending  - buildingFailedAttempts " + buildingFailedAttempts ,2);
				buildingFailedAttempts++; 
				if(buildingFailedAttempts > pMaxFails){ buildingFailedAttempts = 0; pUseLocationPlan = true; }
			}
			else if(buildingType == "wonder") 
			{
				debugRule("BuildBluePrint - ending  - failed wonder" ,2);
				wonderFailedAttempts++; 
				if(wonderFailedAttempts > pMaxFails){ wonderFailedAttempts = 0; pUseLocationPlan = true; }
			}
			else
			{
				debugRule("BuildBluePrint - ending - use Build locaiton " + " wagon " + builderWagon ,2);
				if(builderWagon == -1) createLocationBuildPlan(buildingId, 1, 100, true, cEconomyEscrowID, gMainTownCenterLocation, 1,-1);
				else pBuildPlan = createLocationBuildPlan(buildingId, 1, 100, true, cEconomyEscrowID, gMainTownCenterLocation, 1,builderWagon);
				
			}
			
			if(pUseLocationPlan == true) 
			{
				debugRule("BuildBluePrint - ending - use Build locaiton " + " wagon " + builderWagon + " buildingId " + buildingId,2);
				if(builderWagon == -1) createLocationBuildPlan(buildingId, 1, 100, true, cEconomyEscrowID, gMainTownCenterLocation, 1, -1);
				else pBuildPlan = createLocationBuildPlan(buildingId, 1, 100, true, cEconomyEscrowID, gMainTownCenterLocation, 1,builderWagon);

			}
			
		}
		else
		{
			debugRule("BuildBluePrint - failed attempt ",1);
			if(buildingType == "houseDefault") houseDefaultFailedAttempts = 0;
			else if (buildingType =="mill") millFailedAttempts = 0;
			else if (buildingType =="farm") farmFailedAttempts = 0;
			else if (buildingType =="plantation") plantationFailedAttempts = 0;
			else if (buildingType =="outpost") outpostFailedAttempts = 0;
			else if (buildingType =="firepit") firepitFailedAttempts = 0;
			else if (buildingType =="building") buildingFailedAttempts = 0;
			else if (buildingType =="wonder") wonderFailedAttempts = 0;	
		}
		//reset the vars
		
		if(pUnitCount > pStartNum && builderWagon != -1)
		{
			aiQVSet("" + pLocation + "loc", 1);
			for(i = 0; < xsArrayGetSize(gWagonBuildLocationId))
			{
				if(xsArrayGetInt(gWagonBuildLocationId,i) == -1)
				{
					xsArraySetInt(gWagonBuildLocationId,i,builderWagon);
					xsArraySetVector(gWagonBuildLocation,i,pLocation);
					break;
				}
			}
		}
		
		pSlot = 0;
		pLocation = cInvalidVector;
		pXvalue = -1;
		pZvalue = -1;
		pStartNum = -1;
		pUnitCount = -1;
		pBuilder = -1;
		builderWagon = -1;
		newBuildingID = -1;
		buildingType = "na";
		pSlotMax = -1;
		xsDisableSelf();
		debugRule("BuildBluePrint - end ",1);
		return;
	}
	debugRule("BuildBluePrint - try a build position ",0);
	if(pLocation == cInvalidVector)
	{
		pLocation = gMainTownCenterLocation;
		pXvalue = xsVectorGetX(gMainTownCenterLocation);
		pZvalue = xsVectorGetZ(gMainTownCenterLocation);
		if(buildingType == "houseDefault")
		{
			pLocation = xsVectorSetZ(pLocation,pZvalue - 3);
		}
		else if(buildingType == "mill")
		{
			pLocation = xsVectorSetZ(pLocation,pZvalue - 13);
		}
		else if(buildingType == "farm")
		{
			pLocation = xsVectorSetZ(pLocation,pZvalue - 13);
		}
		else if(buildingType == "plantation")
		{
			pLocation = xsVectorSetZ(pLocation,pZvalue - 13);
			pLocation = xsVectorSetX(pLocation,pXvalue + 14);
		}
		else if(buildingType == "outpost")
		{
			pLocation = xsVectorSetX(pLocation,pXvalue + 30);
		}
		else if(buildingType == "firepit")
		{
			pLocation = xsVectorSetX(pLocation,pXvalue + 10);
			pLocation = xsVectorSetZ(pLocation,pZvalue + 12);
		}
		else
		{
			pLocation = xsVectorSetZ(pLocation,pZvalue - 13);
		}
	}

	if(gCurrentCiv == cCivRussians || gCurrentCiv == cCivXPIroquois || gCurrentCiv == cCivXPSioux || gCurrentCiv == cCivXPAztec)
	{
		if (kbProtoUnitIsType(cMyID, buildingId, cUnitTypeMilitaryBuilding)) vectorSortCenter(pBuildingLocationArray,gMapCenter,"nearest");
		else vectorSortCenter(pBuildingLocationArray,gMapCenter,"farthest");
	}
	if(buildingType == "houseDefault")
	{
		pLocation = xsArrayGetVector(pHouseDefaultLocationArray, pSlot);
	}
	else if(buildingType == "mill")
	{
		pLocation = xsArrayGetVector(pMillLocationArray, pSlot);
	}
	else if(buildingType == "farm")
	{
		pLocation = xsArrayGetVector(pFarmLocationArray, pSlot);
	}
	else if(buildingType == "plantation")
	{
		pLocation = xsArrayGetVector(pPlantLocationArray, pSlot);
	}
	else if(buildingType == "outpost")
	{
		pLocation = xsArrayGetVector(pOutpostLocationArray, pSlot); //pSlot
	}
	else if(buildingType == "firepit")
	{
		pLocation = xsVectorSetX(pLocation,pXvalue + 10);
		pLocation = xsVectorSetZ(pLocation,pZvalue + 12);
	}
	else if(buildingType == "wonder")
	{
		pLocation = xsArrayGetVector(pJapanWonderLocationArray, pSlot);
	}
	else
	{
		if(kbProtoUnitIsType(cMyID, buildingId, cUnitTypeEconomic) ) vectorSortCenter(pBuildingLocationArray,gMapCenter,"farthest");
		else if(kbProtoUnitIsType(cMyID, buildingId, cUnitTypeMilitaryBuilding) ) vectorSortCenter(pBuildingLocationArray,gMapCenter,"nearest");
		else vectorSortCenter(pBuildingLocationArray,gMapCenter,"farthest");
		pLocation = xsArrayGetVector(pBuildingLocationArray, pSlot);
	}

	if(builderWagon == -1) 
	{
		debugRule("BuildBluePrint - builder is settler ",1);
		pBuilder = getNearestSettler(pLocation);
		//addExcludeSettler(pBuilder);
	}
	else
	{
		debugRule("BuildBluePrint - builder is wagon ",1);
		pBuilder = builderWagon;
	}
	
	if (kbProtoUnitIsType(cMyID, buildingId, cUnitTypeAbstractFirePit) && gCurrentCiv == cCivXPAztec) 
	{
		pSlot++;
		return;
	}
	debugRule("BuildBluePrint - Try build "+ " slot " + pSlot,0);
	aiTaskUnitBuild(pBuilder, buildingId, pLocation);
	newBuildingID = buildingId;
	pSlot++;
}

void buildingBluePrint(int pBuildingId = -1, int pWagon = -1)
{
	debugRule("buildingBluePrint - buildingType " + buildingType + 
	" newBuildingID " + newBuildingID + 
	" rule " + xsIsRuleEnabled("BuildBluePrint") +
	" pWagon " + pWagon,0);
	if(buildingType != "na" || 
	   newBuildingID != -1 || 
	   xsIsRuleEnabled("BuildBluePrint") || 
	   (pWagon == -1 && getBuildable(pBuildingId) == false) ||
	   getUnitTypeAtBuildLimit(pBuildingId) ||
	   (pWagon != -1 && kbUnitGetActionType(pWagon) != 7) // ||kbUnitCount(cMyID, pBuildingId, cUnitStateBuilding) > 
	) 
	{ 
		debugRule("buildingBluePrint - Return, does not meet conditions",1); 
		//if(pWagon != -1 && kbUnitGetActionType(pWagon) == 7 && kbUnitGetPlanID(pWagon) == -1) aiTaskUnitMove(pWagon,gMainTownCenterLocation);
		return;
	}

	if(pWagon != -1) 
	{
		debugRule("buildingBluePrint - is a wagon build",1);
		builderWagon = pWagon; // is a wagon build
	}
	
	debugRule("buildingBluePrint - Building type is " + pBuildingId,0);
	switch(pBuildingId)
	{
		case cUnitTypeMill: 
		{
			if(kbUnitCount(cMyID, cUnitTypeMill, cUnitStateABQ) > 5) {debugRule("buildingBluePrint - Return, at limit ",1); return;}
			buildingType = "mill";
			break; 
		}
		case cUnitTypeFarm: 
		{
			if(kbUnitCount(cMyID, cUnitTypeFarm, cUnitStateABQ) > 5) {debugRule("buildingBluePrint - Return, at limit ",1); return;}
			buildingType = "farm";
			break; 
		}
		case cUnitTypeypRicePaddy: 
		{
			if(kbUnitCount(cMyID, cUnitTypeypRicePaddy, cUnitStateABQ) > 5) {debugRule("buildingBluePrint - Return, at limit ",1); return;}
			buildingType = "mill";
			break; 
		}
		case cUnitTypePlantation: 
		{ 
			if(kbUnitCount(cMyID, cUnitTypePlantation, cUnitStateABQ) > 5) {debugRule("buildingBluePrint - Return, at limit ",1); return;}
			buildingType = "plantation"; 
			break;
		}
		case cUnitTypeOutpost: { buildingType = "outpost"; break; }
		case cUnitTypeLookout: { buildingType = "outpost"; break; }
		case cUnitTypeYPOutpostAsian: { buildingType = "outpost"; break; }
		default: { buildingType = "building"; }
	}

	if (kbProtoUnitIsType(cMyID, pBuildingId, cUnitTypeAbstractHouse)) buildingType = "houseDefault";
	else if (kbProtoUnitIsType(cMyID, pBuildingId, cUnitTypeAbstractWonder)) buildingType = "wonder";
	buildingId = pBuildingId;
	debugRule("buildingBluePrint - xsEnableRule",1);
	xsEnableRule("BuildBluePrint");
}

void createBluePrintMain()
{

}