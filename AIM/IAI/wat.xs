//waterManager
//==============================================================================
/*
 navyTarget
 updatedOn 2022/05/11
 targets a warship to a target
 
 How to use
 pass a unit, a target and the max dist range
 ..
  Example 
 navyTarget(myUnit, targetUnit, dist);
*/
//==============================================================================
void navyTarget(int myUnit = -1, int targetUnit = -1, float dist = -1.0)
{
	bool skipShip = false;
	int myQueryLength =  kbUnitQueryExecute(myUnit);
	int transportShipsArrayLength = xsArrayGetSize(gTransportShipsArray);
	for (i = 0; < myQueryLength)
	{
		skipShip = false;
		for (j = 0; < transportShipsArrayLength)
		{
			if (xsArrayGetInt(gTransportShipsArray, j) == kbUnitQueryGetResult(myUnit, i) || gCurrentShipTransport == kbUnitQueryGetResult(myUnit, i))
			{
				skipShip = true;
				break;
			}
		}
		if (skipShip == false)
		{
			for (k = kbUnitQueryExecute(targetUnit) - 1; > -1)
			{
				if (dist < distance(kbUnitGetPosition(kbUnitQueryGetResult(myUnit, i)), kbUnitGetPosition(kbUnitQueryGetResult(targetUnit, k))))
				{
					aiPlanDestroy(kbUnitGetPlanID(kbUnitQueryGetResult(myUnit, i)));
					aiTaskUnitWork(kbUnitQueryGetResult(myUnit, i), kbUnitQueryGetResult(targetUnit, k));
				}
			}
		}
	}
}

//==============================================================================
/*
 waterAttack
 updatedOn 2022/05/11
 Sets navy targets
 
 How to use
 waterAttack is auto called by main - mainRules
*/
//==============================================================================
void waterAttack()
{ //sends navy to targets
	if (gWaterMap == false) return; //return if no flag
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"waterAttack") == false) return;
	lastRunTime = gCurrentGameTime;
	
	bool skipShip = false;
	static int myNavy = -1; //query to get all my warships that are alive and are idle 
	if(myNavy == -1) 
	{
		myNavy = kbUnitQueryCreate("myNavy"+getQueryId());
		kbUnitQuerySetPlayerID(myNavy, cMyID,false);
		kbUnitQuerySetPlayerRelation(myNavy, -1);
		kbUnitQuerySetUnitType(myNavy, cUnitTypeAbstractWarShip);
		kbUnitQuerySetIgnoreKnockedOutUnits(myNavy, true);
		kbUnitQuerySetActionType(myNavy, 7);
		kbUnitQuerySetState(myNavy, cUnitStateAlive);
	}
	kbUnitQueryResetResults(myNavy);

	int myNavyNum = kbUnitQueryExecute(myNavy);
	if (myNavyNum == 0) return;
	
	static int enemyNavy = -1; //query to get all enemy warships that are alive
	if(enemyNavy == -1) 
	{
		enemyNavy = kbUnitQueryCreate("enemyNavy"+getQueryId());
		kbUnitQuerySetPlayerID(enemyNavy, -1, false);
		kbUnitQuerySetPlayerRelation(enemyNavy, cPlayerRelationEnemyNotGaia);
		kbUnitQuerySetUnitType(enemyNavy, cUnitTypeAbstractWarShip);	
		kbUnitQuerySetIgnoreKnockedOutUnits(enemyNavy, true);
		kbUnitQuerySetState(enemyNavy, cUnitStateAlive);
	}
	kbUnitQueryResetResults(enemyNavy);
	
	int enemyNavyNum = kbUnitQueryExecute(enemyNavy);
	
	static int enemyNavyDock = -1; //query to get all enemy docks that are alive
	if(enemyNavyDock == -1) 
	{
		enemyNavyDock = kbUnitQueryCreate("enemyNavyDock"+getQueryId());
		kbUnitQuerySetPlayerID(enemyNavyDock, -1, false);
		kbUnitQuerySetPlayerRelation(enemyNavyDock, cPlayerRelationEnemyNotGaia);
		kbUnitQuerySetUnitType(enemyNavyDock, cUnitTypeAbstractDock);
		kbUnitQuerySetIgnoreKnockedOutUnits(enemyNavyDock, true);
		kbUnitQuerySetState(enemyNavyDock, cUnitStateAlive);
		kbUnitQuerySetAscendingSort(enemyNavyDock, true);
	}
	kbUnitQueryResetResults(enemyNavyDock);
	kbUnitQuerySetPosition(enemyNavyDock, gMainBaseLocation); //set the location
	int enemyNavyDockNum = kbUnitQueryExecute(enemyNavyDock);
	
	static int enemyNavyFishing = -1; //query to get all enemy fishing boats that are alive
	if(enemyNavyFishing == -1) 
	{
		enemyNavyFishing = kbUnitQueryCreate("enemyNavyFishing"+getQueryId());
		kbUnitQuerySetPlayerID(enemyNavyFishing, -1, false);
		kbUnitQuerySetPlayerRelation(enemyNavyFishing, cPlayerRelationEnemyNotGaia);
		kbUnitQuerySetUnitType(enemyNavyFishing, cUnitTypeAbstractFishingBoat);
		kbUnitQuerySetIgnoreKnockedOutUnits(enemyNavyFishing, true);
		kbUnitQuerySetState(enemyNavyFishing, cUnitStateAlive);
	}
	kbUnitQueryResetResults(enemyNavyFishing);
	int enemyNavyFishingNum = kbUnitQueryExecute(enemyNavyFishing);

	static int guardianWater = -1; //query to get all Water Guardians that are alive
	if(guardianWater == -1) 
	{
		guardianWater = kbUnitQueryCreate("guardianWater"+getQueryId());
		kbUnitQuerySetPlayerID(guardianWater, -1, false);
		kbUnitQuerySetPlayerRelation(guardianWater, cPlayerRelationEnemy);
		kbUnitQuerySetUnitType(guardianWater, cUnitTypeWaterGuardian);	
		kbUnitQuerySetIgnoreKnockedOutUnits(guardianWater, true);
		kbUnitQuerySetState(guardianWater, cUnitStateAlive);
		kbUnitQuerySetAscendingSort(guardianWater, true);
	}
	kbUnitQueryResetResults(guardianWater);
	kbUnitQuerySetPosition(guardianWater, gMainBaseLocation); //set the location
	
	int guardianWaterNum = kbUnitQueryExecute(guardianWater); 
	
	static int nuggetWater = -1;  //query to get all Water Nugget that are alive
	if(nuggetWater == -1) 
	{
		nuggetWater = kbUnitQueryCreate("nuggetWater"+getQueryId());
		kbUnitQuerySetPlayerRelation(nuggetWater, cPlayerRelationEnemy);
		kbUnitQuerySetUnitType(nuggetWater, cUnitTypeAbstractNuggetWater);
		kbUnitQuerySetAscendingSort(nuggetWater, true);
		kbUnitQuerySetIgnoreKnockedOutUnits(nuggetWater, true);
		kbUnitQuerySetState(nuggetWater, cUnitStateAlive);
	}
	kbUnitQueryResetResults(nuggetWater);
	kbUnitQuerySetPosition(nuggetWater, gMainBaseLocation); //set the location
	
	static int nuggetNavy = -1; //navy for collecting nuggets
	if(nuggetNavy == -1) 
	{
		nuggetNavy = kbUnitQueryCreate("nuggetNavy"+getQueryId());
		kbUnitQuerySetPlayerID(nuggetNavy, cMyID,false);
		kbUnitQuerySetPlayerRelation(nuggetNavy, -1);
		kbUnitQuerySetUnitType(nuggetNavy, gFishingUnit);
		kbUnitQuerySetAscendingSort(nuggetNavy, true);
		kbUnitQuerySetIgnoreKnockedOutUnits(nuggetNavy, true);
		kbUnitQuerySetActionType(nuggetNavy, 7);
		kbUnitQuerySetState(nuggetNavy, cUnitStateAlive);
	}
	kbUnitQueryResetResults(nuggetNavy);
	kbUnitQuerySetPosition(nuggetNavy, gMainBaseLocation); //set the location

	for (j = 0; < myNavyNum)
	{ //sends idle warships to fish
		if (gCurrentShipTransport == kbUnitQueryGetResult(myNavy, j) || kbUnitIsType(kbUnitQueryGetResult(myNavy, j), cUnitTypeEconomic) == false) continue;
		aiTaskUnitWork(kbUnitQueryGetResult(myNavy, j), getUnit(cUnitTypeAbstractFish, 0, cUnitStateAlive) );
	}
	bool breakj = false;
	int enemyBuilding = -1;
	bool skipNugget = false;
	float dist = -1.0;
	//when ahead in navy, send navy to attack
	if (enemyNavyNum > 0 && myNavyNum > enemyNavyNum)
	{
		navyTarget(myNavy, enemyNavy, 100);
	}
	else if (guardianWaterNum > 0 && myNavyNum > 2)
	{ //look for water guardians
		navyTarget(myNavy, guardianWater, 100);
	}
	else if (gIslandLanded == true)
	{ //when enemy island is landed, go to that point
		for (j = 0; < myNavyNum)
		{
			aiTaskUnitMove(kbUnitQueryGetResult(myNavy, j), kbUnitGetPosition(gIslandLandedLocationUnit));
		}
	}
	else if (enemyNavyNum == 0 && enemyNavyDockNum > 0 && myNavyNum > 3)
	{ //attack the enemy Navy docks
		if(enemyNavyDockNum == 1) navyTarget(myNavy, enemyNavyDock, 30);
		if(enemyNavyDockNum == 2 && myNavyNum > 4) navyTarget(myNavy, enemyNavyDock, 30);
		if(enemyNavyDockNum == 3 && myNavyNum > 5) navyTarget(myNavy, enemyNavyDock, 30);
		if(enemyNavyDockNum > 4 && myNavyNum > 6) navyTarget(myNavy, enemyNavyDock, 30);
	}
	else if (enemyNavyFishingNum > 0)
	{ //attack enemy fishing boats
		navyTarget(myNavy, enemyNavyFishing, 30);
	}
	else if (myNavyNum > 4)
	{ //attack enemy buildings near shoreline
		breakj = false;
		enemyBuilding = -1;
		skipShip = false;
		for (i = 0; < xsArrayGetSize(gShorelineEnemyBuildingsArray))
		{
			enemyBuilding = xsArrayGetInt(gShorelineEnemyBuildingsArray, i);
			if (enemyBuilding == -1) break;
			if (kbUnitGetHealth(enemyBuilding) > 0.0)
			{
				breakj = true;
				for (j = 0; < myNavyNum)
				{
					if (gCurrentShipTransport == kbUnitQueryGetResult(myNavy, j)) continue;
					skipShip = false;
					for (k = 0; < xsArrayGetSize(gTransportShipsArray))
					{
						if (xsArrayGetInt(gTransportShipsArray, k) == kbUnitQueryGetResult(myNavy, j) || gCurrentShipTransport == kbUnitQueryGetResult(myNavy, j))
						{
							skipShip = true;
							break;
						}
					}
					if (skipShip == false) aiTaskUnitWork(kbUnitQueryGetResult(myNavy, j), enemyBuilding);
				}
			}
			if (breakj == true) break;
		}
	}
	if (kbUnitQueryExecute(nuggetWater) > 0)
	{ //get water nugget
		for (i = 0; < kbUnitQueryExecute(nuggetNavy))
		{
			if (gCurrentShipTransport == kbUnitQueryGetResult(nuggetNavy, i)) continue;
			skipShip = false;
			for (t = 0; < xsArrayGetSize(gTransportShipsArray))
			{
				if (xsArrayGetInt(gTransportShipsArray, t) == kbUnitQueryGetResult(nuggetNavy, i) || gCurrentShipTransport == kbUnitQueryGetResult(nuggetNavy, i) ||
				kbUnitGetActionType(xsArrayGetInt(gTransportShipsArray, t)) != 7)
				{
					skipShip = true;
					break;
				}
			}
			if (skipShip == false)
			{
				for (h = kbUnitQueryExecute(nuggetWater) - 1; > -1)
				{
					skipNugget = false;
					for (j = 0; < guardianWaterNum)
					{
						dist = distance(kbUnitGetPosition(kbUnitQueryGetResult(nuggetWater, h)), kbUnitGetPosition(kbUnitQueryGetResult(guardianWater, j)));
						if (dist < 10)
						{
							skipNugget = true;
							break;
						}
					}
					if (skipNugget == false)
					{
						aiTaskUnitWork(kbUnitQueryGetResult(nuggetNavy, i), kbUnitQueryGetResult(nuggetWater, h));
						break;
					}
				}
			}
		}
	}
}

//==============================================================================
/*
 dockBuildManager
 updatedOn 2022/05/11
 Manages dock building, controlls dock placement and number.
 
 How to use
 dockBuildManager is called by rule navyManager, no need to call directly 
*/
//==============================================================================
void dockBuildManager()
{	
	static int dockPlan = -1; //holds the dock plan
	static int shorelineCount = 0; //holds the current position in the shoreline array
	static int shorelineEnemy = -1; //query for checking enemy units near shoreline
	static int shorelineBuildings = -1; //query for checking building near the shoreline
	static int count = -1;
	static float dx = -1.0;
	static float dz = -1.0;
	static vector dockPointA = cInvalidVector; //Placement Point 0 for the dock
	static vector dockPointB = cInvalidVector; //Placement Point 1 for the dock
	static vector navyLocationCheck = cInvalidVector;
	
	if (gWaterMap == false) return;
	if (gTownCenterNumber == 0) return; //do not build any docks if no Town Center
	if (xsArrayGetVector(gShorelineArray, shorelineCount) == cInvalidVector) shorelineCount = 0; //check for invalid vector
	switch (gCurrentAge)
	{ //Set max docks per age
		case cAge1:{ gDockBuildNum = 1; break; }
		case cAge2:{ gDockBuildNum = 4; break; }
		case cAge3:{ gDockBuildNum = 6; break; }
		case cAge4:{ gDockBuildNum = 8; break; }
		case cAge5:{ gDockBuildNum = kbGetBuildLimit(cMyID, gDockUnit); break; }
	} //end switch
	if (gCurrentWood < 2000) gDockBuildNum = 6; //hard dock limit if under 2000 wood
	if (kbUnitCount(cMyID, gDockUnit, cUnitStateAlive) < gDockBuildNum && aiPlanGetState(dockPlan) != 3)
	{ //build a new dock if under build limit and plan state not 3 (this will build a dock one at a time)
		aiPlanDestroy(dockPlan); //kill the old plan, state can be 5 which means the ai cannot place the dock for the plan
		dockPlan = aiPlanCreate("military dock plan", cPlanBuild); //create a new dock plan
		aiPlanSetVariableInt(dockPlan, cBuildPlanBuildingTypeID, 0, gDockUnit); //set to make dock
		aiPlanSetDesiredPriority(dockPlan, 100); //set Priority
		aiPlanSetMilitary(dockPlan, true);
		aiPlanSetEconomy(dockPlan, false);
		aiPlanSetEscrowID(dockPlan, cMilitaryEscrowID);
		aiPlanSetNumberVariableValues(dockPlan, cBuildPlanDockPlacementPoint, 2, true); //set placement points
		if (kbUnitCount(cMyID, cUnitTypeYPDockWagon, cUnitStateAlive) > 0) aiPlanAddUnitType(dockPlan, cUnitTypeYPDockWagon, 1, 1, 1); //build dock with YPDockWagon
		else if (kbUnitCount(cMyID, cUnitTypeWagonDock, cUnitStateAlive) > 0) aiPlanAddUnitType(dockPlan, cUnitTypeWagonDock, 1, 1, 1); //build dock with WagonDock
		else aiPlanAddUnitType(dockPlan, gEconUnit, 2, 2, 2); //build dock with settler
		if (shorelineEnemy == -1) 
		{
			shorelineEnemy = kbUnitQueryCreate("shorelineEnemy"+getQueryId()); //counts enemy units near shoreline
			kbUnitQuerySetPlayerRelation(shorelineEnemy, cPlayerRelationEnemyNotGaia);
			kbUnitQuerySetUnitType(shorelineEnemy, cUnitTypeMilitary);
			kbUnitQuerySetMaximumDistance(shorelineEnemy, 20);
			kbUnitQuerySetIgnoreKnockedOutUnits(shorelineEnemy, true);
			kbUnitQuerySetState(shorelineEnemy, cUnitStateAlive);
		}
		kbUnitQueryResetResults(shorelineEnemy);
		
		if (shorelineBuildings == -1) shorelineBuildings = kbUnitQueryCreate("shorelineBuildings"+getQueryId()); //counts buildings near shoreline
		kbUnitQueryResetResults(shorelineBuildings);			
		kbUnitQuerySetPosition(shorelineBuildings, xsArrayGetVector(gShorelineArray, shorelineCount)); //set the location
		count = 0;
		while(true)
		{ //check for buildings or enemy units near dock build location
			count++;
			if(count > 1000) break; //exit the while if no shoreline is found  
			if (xsArrayGetVector(gShorelineArray, shorelineCount) == cInvalidVector) 
			{ //check for an invalid vector
				shorelineCount = 0;
				break;
			}								
			kbUnitQueryResetResults(shorelineEnemy);
			kbUnitQuerySetPosition(shorelineEnemy, xsArrayGetVector(gShorelineArray, shorelineCount)); //set the location
			if(kbUnitQueryExecute(shorelineEnemy) > 0)
			{ //check for enemy near dock placement
				shorelineCount++;
				continue;
			}
			kbUnitQueryResetResults(shorelineBuildings);			
			kbUnitQuerySetPosition(shorelineBuildings, xsArrayGetVector(gShorelineArray, shorelineCount)); //set the location
			if(kbUnitQueryExecute(shorelineBuildings) > 0)
			{ //check for buildings near dock placement
				shorelineCount++;
				continue;
			} //end if
			break;
		} //end while
		for (t = 0; < 8)
		{ //insted of using base to flag for cBuildPlanDockPlacementPoint, find land and water from the shoreline as cBuildPlanDockPlacementPoint
			dx = 10.0; //reset X
			dz = 10.0; //reset Z
			switch (t)
			{ //Search locations
				case 0:{ dx = -0.9 * dx; dz = 0.9 * dz; break; } //W
				case 1:{ dx = 0.0; break; } //NW
				case 2:{ dx = 0.9 * dx; dz = 0.9 * dz; break; } //N
				case 3:{ dz = 0.0; break; } //NE
				case 4:{ dx = 0.9 * dx; dz = -0.9 * dz; break; } //E	
				case 5:{ dx = 0.0; dz = -1.0 * dz; break; } //SE					
				case 6:{ dx = -0.9 * dx; dz = -0.9 * dz; break; } //S
				case 7:{ dx = -1.0 * dx; dz = 0;break; } //SW
			}
			navyLocationCheck = xsArrayGetVector(gShorelineArray, shorelineCount); //store the shoreline vector
			navyLocationCheck = xsVectorSetX(navyLocationCheck, xsVectorGetX(navyLocationCheck) + dx); //change the shoreline X vector to search in a ring
			navyLocationCheck = xsVectorSetZ(navyLocationCheck, xsVectorGetZ(navyLocationCheck) + dz); //change the shoreline Z vector to search in a ring
			if (kbAreaGetType(kbAreaGetIDByPosition(navyLocationCheck)) == 2) dockPointB = navyLocationCheck; //save the water point
			if (kbAreaGetType(kbAreaGetIDByPosition(navyLocationCheck)) != 2) dockPointA = navyLocationCheck; //save the land point	
		} //end for t
	if( kbUnitCount(cMyID, gDockUnit, cUnitStateAny) > 0)shorelineCount++;
	aiPlanSetVariableVector(dockPlan, cBuildPlanDockPlacementPoint, gDockPlacement0, dockPointA); // One point at main base 
	aiPlanSetVariableVector(dockPlan, cBuildPlanDockPlacementPoint, gDockPlacement1, dockPointB); // One point at water flag
	aiPlanSetActive(dockPlan);
	} //end if

} //end dockBuildManager

//==============================================================================
/*
 waterFindShoreline
 updatedOn 2022/05/13
 does a grid search looking for the shorelines around the map. The shorelines are
 then sorted by distance.
 
 How to use
 waterFindShoreline is auto called by main - mainRules
 
 Note: To pervent lag the function is cut up to run in multipule runs.
*/
//==============================================================================
vector currentSearchLocation = cInvalidVector;
bool sendNavyForLanding = false;
extern int numberOfShoreLines = -1;
extern bool startShorelineSort = false;
void waterFindShoreline()
{
	static bool firstRun = true;
	if (gNavyFlagUnit == -1 || firstRun == false) return;
	 int mapSizeX = kbGetMapXSize(); //the map max X range
	 int mapSizeZ = kbGetMapZSize(); //the map max Z range
	if (currentSearchLocation == cInvalidVector)
	{ //set the start search location		
		currentSearchLocation = xsVectorSetX(currentSearchLocation, xsVectorGetX(currentSearchLocation) - mapSizeX);
		currentSearchLocation = xsVectorSetZ(currentSearchLocation, xsVectorGetZ(currentSearchLocation) - mapSizeZ);
	} //end if
	static bool lookDone = false;
	if(lookDone == false)
	{
		vector lookAtArea = cInvalidVector; //A location where a search is done to find land next to water
		static int count = 0;
		static int range = 20; //the search size
		static int pMaxLoops = 20;
		if(cRandomMapName == "ceylon") pMaxLoops = 1000;	
		int while1 = 0;
		int areaType = -1;
		while (xsVectorGetZ(currentSearchLocation) < mapSizeZ)
		{ //Z search
			while1++;
			while (xsVectorGetX(currentSearchLocation) < mapSizeX)
			{ //X search
				lookAtArea = currentSearchLocation; //update the lookAtArea location with the current search block
				areaType = kbAreaGetIDByPosition(currentSearchLocation); //get the current area type
				if (kbAreaGetType(areaType) == 2)
				{ //water type found
					for (i = 0; < 8)
					{ //area search at lookAtArea
						if (i == 0) lookAtArea = xsVectorSetX(lookAtArea, xsVectorGetX(lookAtArea) - range);
						else if (i == 1) lookAtArea = xsVectorSetZ(lookAtArea, xsVectorGetZ(lookAtArea) + range);
						else if (i == 2) lookAtArea = xsVectorSetX(lookAtArea, xsVectorGetX(lookAtArea) + range);
						else if (i == 3) lookAtArea = xsVectorSetX(lookAtArea, xsVectorGetX(lookAtArea) + range);
						else if (i == 4) lookAtArea = xsVectorSetZ(lookAtArea, xsVectorGetZ(lookAtArea) - range);
						else if (i == 5) lookAtArea = xsVectorSetZ(lookAtArea, xsVectorGetZ(lookAtArea) - range);
						else if (i == 6) lookAtArea = xsVectorSetX(lookAtArea, xsVectorGetX(lookAtArea) - range);
						else if (i == 7) lookAtArea = xsVectorSetX(lookAtArea, xsVectorGetX(lookAtArea) - range);
						areaType = kbAreaGetIDByPosition(lookAtArea); //get area type 
						if (mapEdgeCheck(xsVectorGetX(lookAtArea),xsVectorGetZ(lookAtArea)) && 
						kbAreaGetType(areaType) != 2 && 
						kbAreaGetType(areaType) != 3 && 
						xsVectorGetX(lookAtArea) > -1 && 
						xsVectorGetZ(lookAtArea) > -1)
						{ //found land
							xsArraySetVector(gShorelineArray, count, lookAtArea); //record locaiton
							count++;
						} //end if	
					} //end for i	
				} //end if
				currentSearchLocation = xsVectorSetX(currentSearchLocation, xsVectorGetX(currentSearchLocation) + range); //update currentSearchLocation with new X value
			} //end while						
			currentSearchLocation = xsVectorSetX(currentSearchLocation, xsVectorGetX(currentSearchLocation) - mapSizeX); //reset x location
			currentSearchLocation = xsVectorSetZ(currentSearchLocation, xsVectorGetZ(currentSearchLocation) + range); //move the z location
			if(while1 == pMaxLoops)return;
		} //end while
		numberOfShoreLines = count;
		lookDone = true;
		gWaterShorelineCheck = true;
	}
	//sort shoreline array
	static float key = 0.0;
	static vector keyVector = cInvalidVector;
	static int j = -1;
	static int n = -1;
	n = xsArrayGetSize(gShorelineArray);
	static int iat = 1;
    for (i = iat; < n) 
	{
		iat++;
		key = distance(gNavyFlagLocation, xsArrayGetVector(gShorelineArray,i)) ;	
		keyVector = xsArrayGetVector(gShorelineArray,i) ;	
		
		j = i - 1;
		while (j >= 0 && distance(gNavyFlagLocation, xsArrayGetVector(gShorelineArray,j)) > key) 
		{
		   xsArraySetVector(gShorelineArray, j + 1, xsArrayGetVector(gShorelineArray,j) ); //arr[j + 1] = arr[j];
           j = j - 1;
        }
		xsArraySetVector(gShorelineArray, j + 1, keyVector );
		if(iat == 250)return;
    }
	
	firstRun = false;
} //end areaFind

int Garrison(int buildID = -1, int unitType = -1, vector garrLocation = cInvalidVector)
{
	int planID = -1;
	int unitID = -1;
	vector v = garrLocation; //kbUnitGetPosition(buildID);//garrLocation;
	planID = aiPlanCreate("Garrison" + buildID, cPlanTransport);
	//planID = aiPlanCreate("Garrison"+buildID,cPlanTransport);
	aiPlanAddUnitType(planID, unitType, 1, 1, 1);
	aiPlanSetVariableInt(planID, cTransportPlanTransportID, 0, buildID);
	aiPlanSetVariableInt(planID, cTransportPlanTransportTypeID, 0, kbGetUnitBaseTypeID(buildID));
	aiPlanSetVariableInt(planID, cTransportPlanPathType, 0, cTransportPathTypePoints);
	aiPlanSetVariableBool(planID, cTransportPlanTakeMoreUnits, 0, false);
	aiPlanSetVariableBool(planID, cTransportPlanPathPlanned, 0, true);
	aiPlanSetVariableBool(planID, cTransportPlanPersistent, 0, true);
	aiPlanSetVariableBool(planID, cTransportPlanReturnWhenDone, 0, false); //no effect
	aiPlanSetVariableBool(planID, cTransportPlanMaximizeXportMovement, 0, false); //no effect
	aiPlanSetVariableVector(planID, cTransportPlanGatherPoint, 0, v);
	aiPlanSetVariableVector(planID, cTransportPlanTargetPoint, 0, cOriginVector);
	aiPlanSetEventHandler(planID, cPlanEventStateChange, "Goto");
	aiPlanSetActive(planID, true);
	return (planID);
}

void Goto(int parm = -1)
{
	if (aiPlanGetState(parm) != cPlanStateEnter) return;

	if (getUnitCountByLocation(cUnitTypeAbstractVillager, cMyID, cUnitStateAlive, aiPlanGetVariableVector(parm, cTransportPlanGatherPoint, 0), 5.0) >= aiPlanGetNumberUnits(parm) - 3)
	{
		aiPlanDestroy(parm);
	}

	if (getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cMyID, cUnitStateAlive, aiPlanGetVariableVector(parm, cTransportPlanGatherPoint, 0), 5.0) >= aiPlanGetNumberUnits(parm) - 3)
	{
		aiPlanDestroy(parm);
	}
	//if ( GetUnitCount(cUnitTypeAbstractVillager, cMyID, aiPlanGetVariableVector(parm, cTransportPlanGatherPoint, 0), 5.0) >= aiPlanGetNumberUnits(parm) - 3) aiPlanDestroy(parm);
}

vector loadLastLocation = cInvalidVector;
int shipLoadWaitTime = 0;
int shipLoadWaitSettlerTime = 0;
int currentLoadingShip = -1;
int offloadtry = 0;
bool skipSettler = false;
int loadSettlerPlan = -1;
int loadArmyPlan = -1;
int sentSettler = -1;
int ruleNavyTransportTime = 0;
/*
void settlerTransport()
{
	int settlerId = getUnit(gEconUnit, cMyID, cUnitStateAlive);
	int transportShipId = getUnit(gFishingUnit, cMyID, cUnitStateAlive);
	//xsArrayGetVector(gShorelineArray, 0);

xsArrayGetVector(gShorelineArray, 0)

gNavyFlagLocation
	 
}
*/
void navyTransport()
{ //transports units accross water
	static int lastRunTime = 0;
	//if(functionDelay(lastRunTime, 30000,"navyTransport") == false) return;
	//lastRunTime = gCurrentGameTime;
	if (gMapTypeIsland != true || gNavyFlagUnit == -1 || kbUnitCount(cMyID, gNavyClass1, cUnitStateAlive) == 0) return; //do not transport on non island maps
	static bool loadSettler = true;
	float dist = -1;
	float mapDistToEndMap = 0.0;
	float mapDistToshoreline = 0.0;
	float mapMaxDist = 0.0;
	vector mapEndLocation = cInvalidVector;
	float halfSize = kbGetMapXSize() * 0.5;
	mapEndLocation = xsVectorSet(halfSize, 0, 0);
	int trainsportShipLimit = 2;
	int addEnemyBuildingCount = 0;
	static int buildingCheck = -1;
	static int enemyBuildingCheck = -1;
	static int transportShip = -1;
	static int settlerIsland = -1;
	static int myTransport = -1;
	static int pTradePostSocket = -1;

	static int socketQuery = -1;
	if (socketQuery == -1) 
	{
		socketQuery = kbUnitQueryCreate("socketQuery"+getQueryId()); //Create a new TradePost Socket unit Query
		kbUnitQuerySetPlayerID(socketQuery, 0,false); //set player to 0
		kbUnitQuerySetPlayerRelation(socketQuery, -1);
		kbUnitQuerySetUnitType(socketQuery, cUnitTypeTradePostSocket); //find unit
		kbUnitQuerySetState(socketQuery, cUnitStateAny); //set state
	
		for (j = 0; < kbUnitQueryExecute(socketQuery))
		{ //Loop through all the sockets	
			//socketID = kbUnitQueryGetResult(socketQuery, j); //get socket ID
			if (kbGetProtoUnitName(kbUnitGetProtoUnitID(kbUnitQueryGetResult(socketQuery, j))) == "SocketTradeRoute") pTradePostSocket = kbUnitQueryGetResult(socketQuery, j); //Check if the socket has a name of SocketTradeRoute and update the socket count
		} //end for j
	}
	//if(pTradePostSocket == -1) pTradePostSocket = gWaterIslandTradeSocket;
	
	if (gNavyLoadLocation == cInvalidVector || gNavyTransportLocation == cInvalidVector)
	{
		float lastLoadDistance = 999999999;
		float lastUnLoadDistance = 999999999;
		float lastDockDistance = 999999999;
		vector checkLoc = cInvalidVector;
		int shorelineCount = 0;
		for (i = 0; < xsArrayGetSize(gShorelineArray))
		{
			if (xsArrayGetVector(gShorelineArray, i) == cInvalidVector) break; //end of gShorelineArray	

			mapDistToshoreline = distance(xsArrayGetVector(gShorelineArray, i), gMapCenter);
			mapDistToEndMap = distance(mapEndLocation, gMapCenter);
			mapMaxDist = mapDistToEndMap - 100;
			if (mapDistToshoreline > mapMaxDist) continue;

			dist = distance(xsArrayGetVector(gShorelineArray, i), gMainBaseLocation);
			checkLoc = xsArrayGetVector(gShorelineArray, i);

			if(buildingCheck == -1) 
			{
				buildingCheck = kbUnitQueryCreate("buildingCheck"+getQueryId());
				kbUnitQuerySetPlayerID(buildingCheck, cMyID,false);
				kbUnitQuerySetPlayerRelation(buildingCheck, -1);
				kbUnitQuerySetUnitType(buildingCheck, cUnitTypeBuildingClass);
				kbUnitQuerySetMaximumDistance(buildingCheck, 15);
				kbUnitQuerySetIgnoreKnockedOutUnits(buildingCheck, true);
				kbUnitQuerySetState(buildingCheck, cUnitStateABQ);
			
			}
			kbUnitQueryResetResults(buildingCheck);
			kbUnitQuerySetPosition(buildingCheck, checkLoc); //set the location

			if(enemyBuildingCheck == -1) 
			{
				enemyBuildingCheck = kbUnitQueryCreate("enemyBuildingCheck"+getQueryId());
				kbUnitQuerySetPlayerID(enemyBuildingCheck, -1, false);
				kbUnitQuerySetPlayerRelation(enemyBuildingCheck, cPlayerRelationEnemyNotGaia);
				kbUnitQuerySetUnitType(enemyBuildingCheck, cUnitTypeBuildingClass);
				kbUnitQuerySetMaximumDistance(enemyBuildingCheck, 16);
				kbUnitQuerySetIgnoreKnockedOutUnits(enemyBuildingCheck, true);
				kbUnitQuerySetState(enemyBuildingCheck, cUnitStateAlive);
			}
			kbUnitQueryResetResults(enemyBuildingCheck);
			kbUnitQuerySetPosition(enemyBuildingCheck, checkLoc); //set the location

			for (j = 0; < kbUnitQueryExecute(enemyBuildingCheck))
			{
				bool donotAdd = false;
				for (t = 0; < xsArrayGetSize(gShorelineEnemyBuildingsArray))
				{
					if (xsArrayGetInt(gShorelineEnemyBuildingsArray, t) == kbUnitQueryGetResult(enemyBuildingCheck, j))
					{
						donotAdd = true;
						break;
					}
				}
				if (donotAdd == false)
				{
					xsArraySetInt(gShorelineEnemyBuildingsArray, addEnemyBuildingCount, kbUnitQueryGetResult(enemyBuildingCheck, j));
					addEnemyBuildingCount++;
				}
			}

			if (getUnit(gEconUnit, cMyID, cUnitStateAlive) != -1 && kbCanPath2(gMainBaseLocation, gNavyLoadLocation, kbUnitGetProtoUnitID(getUnit(gEconUnit, cMyID, cUnitStateAlive)), 1000) == false)
			{
				continue;
			}

			if (dist < lastLoadDistance && kbUnitQueryExecute(buildingCheck) == 0 && loadLastLocation != checkLoc)
			{
				lastLoadDistance = dist;
				gNavyLoadLocation = checkLoc;
				loadLastLocation = checkLoc;
				shorelineCount++;
			}
			

			int enemyTowncenterId = getUnit(gTownCenter, aiGetMostHatedPlayerID(), cUnitStateAlive);
			if (kbUnitCount(cMyID, gTradingPostUnit, cUnitStateAlive) == 0)
			{
				gNavyTransportLocation = kbUnitGetPosition(pTradePostSocket);
				//dist = distance(xsArrayGetVector(gShorelineArray, i), kbUnitGetPosition(pTradePostSocket));
			}
			else if (enemyTowncenterId == -1)
			{
				dist = distance(xsArrayGetVector(gShorelineArray, i), kbBaseGetLocation(aiGetMostHatedPlayerID(), kbBaseGetMainID(aiGetMostHatedPlayerID())));
			}
			else
			{
				dist = distance(xsArrayGetVector(gShorelineArray, i), kbUnitGetPosition(enemyTowncenterId));
			}

			checkLoc = xsArrayGetVector(gShorelineArray, i);
			
		
			if (dist < lastUnLoadDistance &&
				getUnitByLocation(cUnitTypeMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, checkLoc, 20.0) == -1 &&
				getUnitByLocation(cUnitTypeAbstractFort, cPlayerRelationEnemyNotGaia, cUnitStateAlive, checkLoc, 20.0) == -1 &&
				dist > 20 && dist < 100 && gNavyTransportLocation == cInvalidVector) //debug
			{
				lastUnLoadDistance = dist;
				gNavyTransportLocation = checkLoc;
			}
		}
	}



	if (gNavyTransportLocation == cInvalidVector) return;
	if (gNavyLoadLocation == cInvalidVector) return;
	int transportShipId = currentLoadingShip;
	int currentlyTransportNumber = 0;
	for (j = 0; < xsArrayGetSize(gTransportShipsArray))
	{
		int shipCountId = xsArrayGetInt(gTransportShipsArray, j);
		if (shipCountId != -1)
		{
			currentlyTransportNumber++;
		}
	}
	if (currentlyTransportNumber < trainsportShipLimit && transportShipId == -1 && gCurrentShipTransport == -1)
	{
		int transportLastDist = 999999999;
		if(transportShip == -1) 
		{
			transportShip = kbUnitQueryCreate("transportShip"+getQueryId());
			kbUnitQuerySetPlayerID(transportShip, cMyID,false);
			kbUnitQuerySetPlayerRelation(transportShip, -1);
			kbUnitQuerySetUnitType(transportShip, cUnitTypeTransport);
			kbUnitQuerySetAscendingSort(transportShip, true);
			kbUnitQuerySetState(transportShip, cUnitStateAlive);
			kbUnitQuerySetActionType(transportShip, 7);
		}
		kbUnitQueryResetResults(transportShip);
		kbUnitQuerySetPosition(transportShip, gNavyLoadLocation);
		int shipId = -1;
		bool skipShip = false;

		for (i = 0; < kbUnitQueryExecute(transportShip))
		{ //scan all ships that are under cap
			shipId = kbUnitQueryGetResult(transportShip, i);
			skipShip = false;
			for (j = 0; < xsArrayGetSize(gTransportShipsArray))
			{
				if (xsArrayGetInt(gTransportShipsArray, j) == shipId && kbUnitGetHealth(xsArrayGetInt(gTransportShipsArray, j)) > 0)
				{
					skipShip = true;
					break;
				}
			}
			if (skipShip == true) continue;

			if (skipShip == false && kbUnitGetNumberContained(shipId) < 20 && shipId != currentLoadingShip) //&& dist < transportLastDist
			{
				transportShipId = shipId;
				gCurrentShipTransport = shipId;
			}
			else if (currentLoadingShip == shipId)
			{
				transportShipId = currentLoadingShip;
				break;
			}
		}
	}
	if (transportShipId != -1 && gNavyLoadLocation != cInvalidVector)
	{
		if (currentLoadingShip == -1) currentLoadingShip = transportShipId;
		if (shipLoadWaitTime == 0) shipLoadWaitTime = xsGetTime();

		dist = distance(gNavyLoadLocation, kbUnitGetPosition(transportShipId));
		if (dist > 50)
		{
			aiPlanDestroy(kbUnitGetPlanID(transportShipId));
			aiTaskUnitMove(transportShipId, gNavyLoadLocation);
		}
		int gameTime = xsGetTime();
		if ((gameTime - shipLoadWaitTime) > 300000)
		{
			shipLoadWaitTime = 0;
			gNavyLoadLocation = cInvalidVector;
		}
	}

	if (aiPlanGetNumberUnits(loadSettlerPlan, gEconUnit) == 0)
	{
		loadSettler = true;
		
		if(checkExcludeSettler(sentSettler) == true)
		{
			removeExcludeSettler(sentSettler);
		}
	}

	if (transportShipId != -1 && kbUnitGetActionType(transportShipId) == 7 && kbUnitGetNumberContained(transportShipId) == 0 && loadSettler == true) // && distance( gNavyLoadLocation,kbUnitGetPosition(transportShipId) ) < 20)
	{

		//if(loadSettlerPlan == -1 && loadArmyPlan == -1) //&& sentSettler == -1)
		//{
		if(settlerIsland == -1) 
		{
			settlerIsland = kbUnitQueryCreate("settlerIsland"+getQueryId());
			kbUnitQuerySetPlayerID(settlerIsland, cMyID,false);
			kbUnitQuerySetPlayerRelation(settlerIsland, -1);
			kbUnitQuerySetUnitType(settlerIsland, cUnitTypeAffectedByTownBell);
			//kbUnitQuerySetPosition(settlerIsland, gNavyLoadLocation ); //set the location
			kbUnitQuerySetAscendingSort(settlerIsland, true);
			kbUnitQuerySetState(settlerIsland, cUnitStateAlive);
		}
		kbUnitQueryResetResults(settlerIsland);
		int settlerID = -1;
		bool doNotSendVills = false;
		for (i = 0; < kbUnitQueryExecute(settlerIsland))
		{
			settlerID = kbUnitQueryGetResult(settlerIsland, i);
			doNotSendVills = false;
			for (j = 0; < xsArrayGetSize(gExcludeSettlersArray))
			{
				int xsettlerID = xsArrayGetInt(gExcludeSettlersArray, j);
				//if(xsArrayGetInt(gExcludeSettlersArray,j) == -1) break;

				if (xsettlerID == settlerID)
				{
					doNotSendVills = true;
					break;
				}
			}

			if (doNotSendVills == false)
			{
				if(checkExcludeSettler(settlerID) == false)
				{
					addExcludeSettler(settlerID);
				}

				aiPlanDestroy(kbUnitGetPlanID(settlerID));
				loadSettlerPlan = Garrison(transportShipId, gEconUnit, gNavyLoadLocation);
				aiPlanAddUnitType(loadSettlerPlan, gEconUnit, 1, 1, 1);
				aiPlanAddUnit(loadSettlerPlan, settlerID);
				sentSettler = settlerID;
				loadSettler = false;

				if (shipLoadWaitSettlerTime == 0) shipLoadWaitSettlerTime = xsGetTime();
				int settgameTime = xsGetTime();
				if ((settgameTime - shipLoadWaitSettlerTime) > 300000) skipSettler = true;
				break;
			}
			if(checkExcludeSettler(settlerID) == true)
			{
				removeExcludeSettler(settlerID);
			}
			/*if (i == 50)
			{
				for (j = 0; < xsArrayGetSize(gExcludeSettlersArray))
				{
					xsArraySetInt(gExcludeSettlersArray, j, -1);
				}
				break;
			}
			*/
		}
	}

	if (transportShipId != -1 && kbUnitGetNumberContained(transportShipId) < 20 && (kbUnitGetNumberContained(transportShipId) != 0 || skipSettler == true) && kbUnitGetActionType(transportShipId) == 7 &&
		aiPlanGetNumberUnits(loadArmyPlan, cUnitTypeLogicalTypeLandMilitary) == 0) //distance( gNavyLoadLocation,kbUnitGetPosition(transportShipId) ) < 20)
	{
		gNavyLoadLocation = kbUnitGetPosition(transportShipId);
		aiPlanDestroy(loadSettlerPlan);
		loadSettlerPlan = -1;

		if(myTransport == -1) 
		{
			myTransport = kbUnitQueryCreate("myTransport"+getQueryId());
			kbUnitQuerySetPlayerID(myTransport, cMyID,false);
			kbUnitQuerySetPlayerRelation(myTransport, -1);
			kbUnitQuerySetUnitType(myTransport, cUnitTypeLogicalTypeLandMilitary);
			kbUnitQuerySetMaximumDistance(myTransport, 1500);
			kbUnitQuerySetAscendingSort(myTransport, true);
			kbUnitQuerySetIgnoreKnockedOutUnits(myTransport, true);
			kbUnitQuerySetState(myTransport, cUnitStateAlive);
		}
		kbUnitQueryResetResults(myTransport);
		kbUnitQuerySetPosition(myTransport, gNavyLoadLocation); //set the location

		int unitId = -1;
		loadArmyPlan = Garrison(transportShipId, cUnitTypeLogicalTypeLandMilitary, gNavyLoadLocation);
		for (i = 0; < kbUnitQueryExecute(myTransport))
		{
			unitId = kbUnitQueryGetResult(myTransport, i);
			aiPlanDestroy(kbUnitGetPlanID(unitId));
			aiPlanAddUnit(loadArmyPlan, unitId);
			if (i == 25) break;
		}
	}
	if (transportShipId != -1 && kbUnitGetNumberContained(transportShipId) > 19 && gNavyTransportLocation != cInvalidVector)
	{
		aiPlanDestroy(loadArmyPlan);
		loadArmyPlan = -1;
		currentLoadingShip = -1;
		aiPlanDestroy(loadSettlerPlan);
		loadSettlerPlan = -1;
		loadSettler = true;

		aiPlanDestroy(kbUnitGetPlanID(transportShipId));
		aiTaskUnitMove(transportShipId, gNavyTransportLocation);
		gNavyTransportLocation = cInvalidVector;
		sendNavyForLanding = true;
		bool excludeShip = false;
		skipSettler = false;
		gCurrentShipTransport = -1;
		//	sentSettler = -1;

		for (i = 0; < xsArrayGetSize(gTransportShipsArray))
		{
			if (xsArrayGetInt(gTransportShipsArray, i) == transportShipId)
			{
				excludeShip = true;
				break;
			}
		}
		if (excludeShip == false)
		{
			for (i = 0; < xsArrayGetSize(gTransportShipsArray))
			{
				if (xsArrayGetInt(gTransportShipsArray, i) == -1)
					xsArraySetInt(gTransportShipsArray, i, transportShipId);
				break;
			}
		}
	}

	for (j = 0; < xsArrayGetSize(gTransportShipsArray))
	{
		int shipToSend = xsArrayGetInt(gTransportShipsArray, j);
		if (kbUnitGetHealth(shipToSend) == 0 && shipToSend != -1) xsArraySetInt(gTransportShipsArray, j, -1);
		if (shipToSend != -1 && gNavyTransportLocation != cInvalidVector)
		{
			aiTaskUnitMove(shipToSend, gNavyTransportLocation);
		}
	}

	for (j = 0; < xsArrayGetSize(gTransportShipsArray))
	{
		int shipToUnload = xsArrayGetInt(gTransportShipsArray, j);
		if (kbUnitGetHealth(shipToUnload) == 0) xsArraySetInt(gTransportShipsArray, j, -1);

		if (shipToUnload != -1)
		{
			float currentUnLoadDist = distance(gNavyTransportLocation, kbUnitGetPosition(shipToUnload));
			if (currentUnLoadDist < 150 && kbUnitGetActionType(shipToUnload) == 7)
			{
				aiTaskUnitEject(shipToUnload);
				offloadtry++;
				if (kbUnitGetNumberContained(shipToUnload) == 0)
				{
					offloadtry = 0;
					xsArraySetInt(gTransportShipsArray, j, -1);
					gNavyTransportLocation = cInvalidVector;
					aiTaskUnitMove(shipToUnload, gNavyLoadLocation);
					xsEnableRule("transportBaseBuild");
					newAttack();
				}
				if (offloadtry == 3) gNavyTransportLocation = cInvalidVector;
			}
		}
	}

}

int aiPlanIslandTrain(int proto_unit = -1, int num_to_maintain = 200, int batch_size = 5, int train_from = -1, int pri = 100)
{
	int plan_train = -1;
	//if(plan_train != -1) return(-1);
	plan_train = aiPlanCreate("Maintain " + kbGetProtoUnitName(proto_unit), cPlanTrain);
	aiPlanSetDesiredPriority(plan_train, pri);
	aiPlanSetEscrowID(plan_train, cRootEscrowID);
	aiPlanSetVariableInt(plan_train, cTrainPlanFrequency, 0, 1);
	aiPlanSetVariableInt(plan_train, cTrainPlanBuildingID, 0, train_from);
	aiPlanSetVariableInt(plan_train, cTrainPlanUnitType, 0, proto_unit);
	aiPlanSetVariableInt(plan_train, cTrainPlanNumberToMaintain, 0, num_to_maintain);
	aiPlanSetVariableBool(plan_train, cTrainPlanUseMultipleBuildings, 0, false);
	// aiPlanSetVariableInt( plan_train, cTrainPlanMaxQueueSize, 0, 5 );
	aiPlanSetVariableInt(plan_train, cTrainPlanBatchSize, 0, batch_size);
	aiPlanSetActive(plan_train, true);
	return (plan_train);

}

bool stopBuild = false;
rule transportBaseBuild
inactive
minInterval 10
{
	int barracksType = cUnitTypeAbstractBarracks2;
	int stableType = cUnitTypeAbstractStables;
	int artDepotType = cUnitTypeAbstractFoundry;

	int artDepotUnit = cUnitTypeFalconet;
	int stableUnit = cUnitTypeHussar;
	int barracksUnit = cUnitTypePikeman;
	static int islandBase = -1;
	static int deleteOutpost = -1;
	static int islandArmy = -1;

	switch (kbGetCiv())
	{
		case cCivBritish:
			{
				barracksUnit = cUnitTypePikeman;
				stableUnit = cUnitTypeHussar;
				artDepotUnit = cUnitTypeFalconet;
				break;
			}

		case cCivFrench:
			{
				barracksUnit = cUnitTypePikeman;
				stableUnit = cUnitTypeCuirassier;
				artDepotUnit = cUnitTypeFalconet;
				break;
			}
		case cCivJapanese:
			{
				barracksUnit = cUnitTypeypKensei;
				stableUnit = cUnitTypeypNaginataRider;
				artDepotUnit = cUnitTypeypFlamingArrow;
				break;
			}
		case cCivSpanish:
			{
				barracksUnit = cUnitTypePikeman;
				stableUnit = cUnitTypeLancer;
				artDepotUnit = cUnitTypeFalconet;
				break;
			}

		case cCivPortuguese:
			{
				barracksUnit = cUnitTypePikeman;
				stableUnit = cUnitTypeCavalaria;
				artDepotUnit = cUnitTypeOrganGun;
				break;
			}

		case cCivDutch:
			{
				barracksUnit = cUnitTypePikeman;
				stableUnit = cUnitTypeHussar;
				artDepotUnit = cUnitTypeFalconet;
				break;
			}

		case cCivRussians:
			{
				barracksUnit = cUnitTypePikeman;
				stableUnit = cUnitTypeOprichnik;
				artDepotUnit = cUnitTypeFalconet;
				break;
			}

		case cCivGermans:
			{
				barracksUnit = cUnitTypePikeman;
				stableUnit = cUnitTypeWarWagon;
				artDepotUnit = cUnitTypeFalconet;
				break;
			}

		case cCivOttomans:
			{
				barracksUnit = cUnitTypeJanissary;
				stableUnit = cUnitTypeSpahi;
				artDepotUnit = cUnitTypeFalconet;
				break;
			}

		case cCivXPIroquois:
			{
				barracksUnit = cUnitTypexpTomahawk;
				stableUnit = cUnitTypexpHorseman;
				artDepotUnit = cUnitTypexpLightCannon;
				break;
			}

		case cCivXPSioux:
			{
				barracksUnit = cUnitTypexpWarClub;
				stableUnit = cUnitTypexpAxeRider;
				artDepotUnit = cUnitTypexpCoupRider;
				break;
			}

		case cCivXPAztec:
			{
				barracksUnit = cTechEliteCoyotemen;
				stableUnit = cUnitTypeNatHuaminca;
				artDepotUnit = cUnitTypexpCoupRider;
				break;
			}
		case cCivUSA:
			{
				barracksUnit = cUnitTypeUSColonialMarines;
				stableUnit = cUnitTypeSaber;
				artDepotUnit = cUnitTypeFalconet;
				break;
			}

		case cCivSwedish:
			{
				barracksUnit = cUnitTypePikeman;
				stableUnit = cUnitTypePistolS;
				artDepotUnit = cUnitTypeFalconet;
				break;
			}

		case cCivItalians:
			{
				barracksUnit = cUnitTypePikeman;
				stableUnit = cUnitTypeHussar;
				artDepotUnit = cUnitTypeSaker;
				break;
			}

		case cCivIndians:
			{
				barracksUnit = cUnitTypeypRajput;
				stableUnit = cUnitTypeypMahoutMansabdar;
				artDepotUnit = cUnitTypeypMercFlailiphantMansabdar;
				break;
			}

		case cCivChinese:
			{
				barracksUnit = cUnitTypeypMingArmy;
				stableUnit = cUnitTypeypForbiddenArmy;
				artDepotUnit = cUnitTypeypFlameThrower;
				break;
			}
	}
	int unitId = -1;

	if( islandBase == -1) 
	{
		islandBase = kbUnitQueryCreate("islandBase"+getQueryId());
		kbUnitQuerySetPlayerID(islandBase, cMyID,false);
		kbUnitQuerySetPlayerRelation(islandBase, -1);
		kbUnitQuerySetUnitType(islandBase, cUnitTypeMilitaryBuilding);
		kbUnitQuerySetMaximumDistance(islandBase, 25);
		kbUnitQuerySetIgnoreKnockedOutUnits(islandBase, true);
		kbUnitQuerySetState(islandBase, cUnitStateAlive);
	}
	kbUnitQueryResetResults(islandBase);
	kbUnitQuerySetPosition(islandBase, gNavyTransportLocation); //set the location

	int countBarracks = 0;
	int countStable = 0;
	int countArtDepot = 0;

	for (i = 0; < kbUnitQueryExecute(islandBase))
	{
		unitId = kbUnitQueryGetResult(islandBase, i);
		if (kbUnitIsType(unitId, gBarracksUnit) == true)
		{
			aiTaskUnitTrain(unitId, barracksUnit);
			aiTaskUnitTrain(unitId, barracksUnit);
			aiTaskUnitTrain(unitId, barracksUnit);
			aiTaskUnitTrain(unitId, barracksUnit);
			aiTaskUnitTrain(unitId, barracksUnit);
			if (kbUnitGetPlanID(unitId) == -1) aiPlanIslandTrain(barracksUnit, 200, 10, unitId, 100);
			countBarracks++;
		}

		if (kbUnitIsType(unitId, gStableUnit) == true)
		{
			aiTaskUnitTrain(unitId, stableUnit);
			aiTaskUnitTrain(unitId, stableUnit);
			aiTaskUnitTrain(unitId, stableUnit);
			aiTaskUnitTrain(unitId, stableUnit);
			aiTaskUnitTrain(unitId, stableUnit);
			if (kbUnitGetPlanID(unitId) == -1) aiPlanIslandTrain(stableUnit, 200, 20, unitId, 100);
			countStable++;
		}
		if (kbUnitIsType(unitId, gArtilleryDepotUnit) == true)
		{
			aiTaskUnitTrain(unitId, artDepotUnit);
			aiTaskUnitTrain(unitId, artDepotUnit);
			aiTaskUnitTrain(unitId, artDepotUnit);
			aiTaskUnitTrain(unitId, artDepotUnit);
			aiTaskUnitTrain(unitId, artDepotUnit);
			if (kbUnitGetPlanID(unitId) == -1) aiPlanIslandTrain(artDepotUnit, 200, 10, unitId, 100);
			countArtDepot++;
		}
	}

	int totalBuildings = countBarracks + countStable + countArtDepot;
	if (totalBuildings > 0)
	{
		gIslandLanded = true;
		gIslandLandedLocationUnit = unitId;
	}
	if (totalBuildings == 0) gIslandLanded = false;

	if (countBarracks < 3) createLocationBuildPlan(gBarracksUnit, 1, 97, false, cMilitaryEscrowID, gNavyTransportLocation, 1,-1);
	if (countStable < 3) createLocationBuildPlan(gStableUnit, 1, 97, false, cMilitaryEscrowID, gNavyTransportLocation, 1,-1);
	if (countArtDepot < 3) createLocationBuildPlan(gArtilleryDepotUnit, 1, 97, false, cMilitaryEscrowID, gNavyTransportLocation, 1,-1);


	if (kbUnitQueryExecute(islandBase) > 0)
	{
		if (kbUnitCount(cMyID, gTowerUnit) != kbGetBuildLimit(cMyID, gTowerUnit))
		{
			createLocationBuildPlan(gTowerUnit, 2, 97, false, cMilitaryEscrowID, gNavyTransportLocation, 1,-1);
		}
	}


	if (gCurrentWood > 1500 &&
		kbBaseGetUnderAttack(cMyID, kbBaseGetMainID(cMyID)) == false &&
		kbUnitCount(cMyID, gTowerUnit, cUnitStateAlive) == kbGetBuildLimit(cMyID, gTowerUnit) &&
		kbUnitQueryExecute(islandBase) > 2)
	{
		if( deleteOutpost == -1) 
		{
			deleteOutpost = kbUnitQueryCreate("deleteOutpost"+getQueryId());
			kbUnitQuerySetPlayerID(deleteOutpost, cMyID, false);
			kbUnitQuerySetPlayerRelation(deleteOutpost, -1);
			kbUnitQuerySetUnitType(deleteOutpost, gTowerUnit);
			kbUnitQuerySetMaximumDistance(deleteOutpost, 100);
			kbUnitQuerySetIgnoreKnockedOutUnits(deleteOutpost, true);
			kbUnitQuerySetState(deleteOutpost, cUnitStateAlive);
		}
		kbUnitQueryResetResults(deleteOutpost);
		kbUnitQuerySetPosition(deleteOutpost, gMainBaseLocation); //set the location

		int outpostId = -1;
		for (i = 0; < kbUnitQueryExecute(deleteOutpost))
		{
			outpostId = kbUnitQueryGetResult(deleteOutpost, i);
			aiTaskUnitDelete(outpostId);
		}
	}


	vector attackLocation = cInvalidVector;
	if (getUnit(gTownCenter, aiGetMostHatedPlayerID(), cUnitStateAlive) != -1)
	{
		attackLocation = kbUnitGetPosition(getUnit(gTownCenter, aiGetMostHatedPlayerID(), cUnitStateAlive));
	}
	else
	{
		attackLocation = kbUnitGetPosition(getUnit(cUnitTypeBuildingClass, aiGetMostHatedPlayerID(), cUnitStateAlive));
	}
	if( islandArmy == -1) 
	{
		islandArmy = kbUnitQueryCreate("islandArmy"+getQueryId());
		kbUnitQuerySetPlayerID(islandArmy, cMyID, false);
		kbUnitQuerySetPlayerRelation(islandArmy, -1);
		kbUnitQuerySetUnitType(islandArmy, cUnitTypeLogicalTypeLandMilitary);
		kbUnitQuerySetMaximumDistance(islandArmy, 30);
		kbUnitQuerySetIgnoreKnockedOutUnits(islandArmy, true);
		kbUnitQuerySetState(islandArmy, cUnitStateAlive);
	}
	kbUnitQueryResetResults(islandArmy);
	kbUnitQuerySetPosition(islandArmy, gNavyTransportLocation); //set the location

	unitId = -1;
	if (kbUnitQueryExecute(islandArmy) > 15)
	{
		for (i = 0; < kbUnitQueryExecute(islandArmy))
		{
			unitId = kbUnitQueryGetResult(islandArmy, i);
			aiTaskUnitMove(unitId, attackLocation);
		}

	}

	///}

/*
	for (i = 0; < xsArrayGetSize(gExcludeSettlersArray))
	{
		int excludeId = xsArrayGetInt(gExcludeSettlersArray, i);
		bool foundVill = false;

		for (j = 0; < gCurrentAliveSettlers)
		{
			unitId = kbUnitQueryGetResult(getAliveSettlersQuery , j);
			if (excludeId == unitId)
			{
				foundVill = true;
				break;
			}
		}

		if (foundVill == false)
		{
			xsArraySetInt(gExcludeSettlersArray, i, -1);
		}

	}
	*/

}



void fishingMonitor(int fishingQuery = -1, int fqSize = -1, int maxAssign = -1, int resource = -1,int fishingBoatQuery = -1)
{
	static int enemyNavy = -1; //query to get all enemy warships that are alive
	static int enemyNavyAtFish = -1; //query to get all enemy warships that are alive
	for(i = 0; < kbUnitQueryExecute(fishingBoatQuery))
	{
		if(enemyNavy == -1) 
		{
			enemyNavy = kbUnitQueryCreate("enemyNavy"+getQueryId());
			kbUnitQuerySetPlayerID(enemyNavy, -1, false);
			kbUnitQuerySetPlayerRelation(enemyNavy, cPlayerRelationEnemyNotGaia);
			kbUnitQuerySetUnitType(enemyNavy, cUnitTypeAbstractWarShip);	
			kbUnitQuerySetIgnoreKnockedOutUnits(enemyNavy, true);
			kbUnitQuerySetState(enemyNavy, cUnitStateAlive);
		}
		
		kbUnitQueryResetResults(enemyNavy);
		kbUnitQuerySetPosition(enemyNavy,kbUnitGetPosition(kbUnitQueryGetResult(fishingBoatQuery, i)));
		kbUnitQuerySetMaximumDistance(enemyNavy, 30);
		
		//enemy near fishing boat
		if(kbUnitQueryExecute(enemyNavy) > 0)
		{
			if(kbUnitGetActionType(kbUnitQueryGetResult(fishingBoatQuery, i)) == 9) continue;
			//if(distance(kbUnitGetPosition(kbUnitQueryGetResult(fishingBoatQuery, i)), kbUnitGetPosition(getUnit(cUnitTypeHomeCityWaterSpawnFlag, cMyID))) > 50) 
			//	aiTaskUnitMove( kbUnitQueryGetResult(fishingBoatQuery, i), kbUnitGetPosition(getUnit(cUnitTypeHomeCityWaterSpawnFlag, cMyID)) );
			//else
			//{
				for(j = 0; < fqSize)
				{
					//find new fishing spot that does not have navy near them
					if(enemyNavyAtFish == -1) 
					{
						enemyNavyAtFish = kbUnitQueryCreate("enemyNavyAtFish"+getQueryId());
						kbUnitQuerySetPlayerRelation(enemyNavyAtFish, cPlayerRelationEnemyNotGaia);
						kbUnitQuerySetUnitType(enemyNavyAtFish, cUnitTypeAbstractWarShip);	
						kbUnitQuerySetIgnoreKnockedOutUnits(enemyNavyAtFish, true);
						kbUnitQuerySetState(enemyNavyAtFish, cUnitStateAlive);
						kbUnitQuerySetMaximumDistance(enemyNavyAtFish, 50);
					}
					kbUnitQueryResetResults(enemyNavyAtFish);
					kbUnitQuerySetPosition(enemyNavyAtFish,kbUnitGetPosition(kbUnitQueryGetResult(fishingQuery, j)));

					if(kbUnitQueryExecute(enemyNavyAtFish) == 0) 
					{
						aiTaskUnitWork( kbUnitQueryGetResult(fishingBoatQuery, i), kbUnitQueryGetResult(fishingQuery, j) );
						break;
					}
				}
			//}
			
			//else if(kbUnitGetActionType(kbUnitQueryGetResult(fishingBoatQuery, i)) != 9)
				//aiTaskUnitMove( kbUnitQueryGetResult(fishingBoatQuery, i), aiRandLocation() );
			continue;
		}
		
		for(j = 0; < fqSize)
		{
			if(enemyNavyAtFish == -1) 
			{
				enemyNavyAtFish = kbUnitQueryCreate("enemyNavyAtFish"+getQueryId());
				kbUnitQuerySetPlayerID(enemyNavyAtFish, -1, false);
				kbUnitQuerySetPlayerRelation(enemyNavyAtFish, cPlayerRelationEnemyNotGaia);
				kbUnitQuerySetUnitType(enemyNavyAtFish, cUnitTypeAbstractWarShip);	
				kbUnitQuerySetIgnoreKnockedOutUnits(enemyNavyAtFish, true);
				kbUnitQuerySetState(enemyNavyAtFish, cUnitStateAlive);
				kbUnitQuerySetMaximumDistance(enemyNavyAtFish, 30);
			}
			
			kbUnitQueryResetResults(enemyNavyAtFish);
			kbUnitQuerySetPosition(enemyNavyAtFish,kbUnitGetPosition(kbUnitQueryGetResult(fishingQuery, j)));
			
			if(kbUnitQueryExecute(enemyNavyAtFish) > 0) continue;
			if(checkResourceAssignment(kbUnitQueryGetResult(fishingQuery, j), unitGathererLimit(kbUnitGetProtoUnitID(kbUnitQueryGetResult(fishingQuery, j)))) == true ) continue;
			if(kbUnitGetActionType(kbUnitQueryGetResult(fishingBoatQuery, i)) != 7) continue;
			if( kbUnitGetCurrentInventory(kbUnitQueryGetResult(fishingQuery, j), resource) > 0 )
			{
				aiTaskUnitWork( kbUnitQueryGetResult(fishingBoatQuery, i), kbUnitQueryGetResult(fishingQuery, j) );
				break;
			}
		}
		if(fqSize == 0)
		{
			aiTaskUnitMove( kbUnitQueryGetResult(fishingBoatQuery, i), aiRandLocation() );
		}
		
	}	
} //end getPlayerAliveSettlers

	

//==============================================================================
/*
 fishingShipManager
 updatedOn 2022/05/09
 Managers fishing ships
 
 How to use
 fishingShipManager is auto called by main - mainRules
*/
//==============================================================================
void fishingShipManager()
{
	static int fishMaintain = -1; //train fishing boats
	static int fishingQuery = -1; //get fishing locations
	static int whaleQuery = -1; //get whale locations
	static int swap = 0; //swap between fish and whales
	static int fishingBoatQuery = -1;
	bool navyBehind = false; //checks if the ai is behind on navy
	int fishingBoats = 25; //default fishing boats
	int fqSize = -1; //num of fish
	int wqSize = -1; //num of whales
	int fishingBoatNum = -1; //hold the number of fishing boats
	if (gCurrentAge < cAge3) swap = 0; //only fish for food in age 1, 2
	
	//query for all alive fishing boats
	if (fishingBoatQuery == -1) 
	{
		fishingBoatQuery = kbUnitQueryCreate("fishingBoatQuery query"+getQueryId());
		kbUnitQuerySetIgnoreKnockedOutUnits(fishingBoatQuery, true);
		kbUnitQuerySetPlayerID(fishingBoatQuery, cMyID,false);
		kbUnitQuerySetPlayerRelation(fishingBoatQuery, -1);
		kbUnitQuerySetUnitType(fishingBoatQuery, gFishingUnit);
		kbUnitQuerySetState(fishingBoatQuery, cUnitStateAlive);
	}
	kbUnitQueryResetResults(fishingBoatQuery);
	fishingBoatNum = kbUnitQueryExecute(fishingBoatQuery);
	
	//query for all alive AbstractFish
	if (fishingQuery == -1) 
	{
		fishingQuery = kbUnitQueryCreate("fish query"+getQueryId()); //find fish
		kbUnitQuerySetIgnoreKnockedOutUnits(fishingQuery, true);
		kbUnitQuerySetPlayerID(fishingQuery, 0,false);
		kbUnitQuerySetPlayerRelation(fishingQuery, -1);
		kbUnitQuerySetUnitType(fishingQuery, cUnitTypeAbstractFish);
		kbUnitQuerySetState(fishingQuery, cUnitStateAlive);
		kbUnitQuerySetAscendingSort(fishingQuery, true);
	}
	kbUnitQueryResetResults(fishingQuery); //reset
	kbUnitQuerySetPosition(fishingQuery, gNavyFlagLocation);
	kbUnitQuerySetMaximumDistance(fishingQuery, 10000.0);
	
	fqSize = kbUnitQueryExecute(fishingQuery);
	if(swap == 0)
	{ //fish for food
		swap = 1;
		if (fqSize > 0) fishingMonitor(fishingQuery,fqSize, 6,cResourceFood,fishingBoatQuery); 
	} //end if
	else
	{ //fish for coin
		swap = 0;
		if (whaleQuery == -1) 
		{
			whaleQuery = kbUnitQueryCreate("whale query"+getQueryId());
			kbUnitQuerySetIgnoreKnockedOutUnits(whaleQuery, true);
			kbUnitQuerySetPlayerID(whaleQuery, 0,false);
			kbUnitQuerySetPlayerRelation(whaleQuery, -1);
			kbUnitQuerySetUnitType(whaleQuery, cUnitTypeAbstractWhale);
			kbUnitQuerySetState(whaleQuery, cUnitStateAlive);
			kbUnitQuerySetAscendingSort(whaleQuery, true);
		}
		kbUnitQueryResetResults(whaleQuery);
		kbUnitQuerySetPosition(whaleQuery, gNavyFlagLocation);
		kbUnitQuerySetMaximumDistance(whaleQuery, 10000.0);
		
		wqSize = kbUnitQueryExecute(whaleQuery);
		if (wqSize > 0) fishingMonitor(whaleQuery,wqSize,3,cResourceGold,fishingBoatQuery);
	}
	if (kbUnitCount(cMyID, gDockUnit, cUnitStateABQ) < 1) return; //no dock, exit
	if (kbUnitCount(cPlayerRelationEnemyNotGaia, cUnitTypeAbstractWarShip, cUnitStateAlive) >= kbUnitCount(cMyID, cUnitTypeAbstractWarShip, cUnitStateAlive) && 
	kbUnitCount(cPlayerRelationEnemyNotGaia, cUnitTypeAbstractWarShip, cUnitStateAlive) != 0) navyBehind = true; //when behind on navy and navy not 0, set to behind
	if ( fishMaintain == -1  || aiPlanGetState(fishMaintain) == cPlanStateNone ) fishMaintain = createSimpleMaintainPlan(gFishingUnit, 0, true, kbBaseGetMainID(cMyID), 1,fishMaintain);	//create a new fishing boat maintain plan
	if(kbUnitCount(cMyID, gFishingUnit) < kbGetBuildLimit(cMyID, gFishingUnit) && 
	navyBehind == false)
	{ //control fishing boat numbers
		if(fishingBoatNum == 0) 
		{
			aiPlanSetVariableInt(fishMaintain, cTrainPlanNumberToMaintain, 0, 1);
			return;
		}
		if(kbUnitCount(cMyID, cUnitTypeAbstractWarShip, cUnitStateAlive) < 2 && gCurrentAge > cAge2)
		{
			aiPlanSetVariableInt(fishMaintain, cTrainPlanNumberToMaintain, 0, 1);
			return;
		}
		
		int trainNum = gFishingUnitNum + kbUnitCount(cMyID, gDockUnit, cUnitStateAlive); //count alive fishing boats and add 1 per alive dock
		if(trainNum > 25) trainNum = 25; //set a max of 25 fishing boats
		if(((fqSize * 10) / fishingBoatNum) > 25) 
		{ //works out of a new fishing boat should be trained
			aiPlanSetVariableInt(fishMaintain, cTrainPlanNumberToMaintain, 0, trainNum);
		} //end if
		else
		{ //set training to 1	
			aiPlanSetVariableInt(fishMaintain, cTrainPlanNumberToMaintain, 0, 1);
		} //end else
	} //end if
} //end fishingShipManager


//==============================================================================
/*
 waterExploreManager
 updatedOn 2022/05/06
 Sends a fishing ship to explore
 
 How to use
 waterExploreManager is auto called waterManager - navyManager
*/
//==============================================================================
void waterExploreManager()
{
	static int gWaterExplorePlan = -1; // Plan ID for ocean exploration plan
	if (gWaterExplorePlan < 0)
	{
		vector location = cInvalidVector;
		if (getUnit(gFishingUnit, cMyID, cUnitStateAlive) >= 0)
			location = kbUnitGetPosition(getUnit(gFishingUnit, cMyID, cUnitStateAlive));
		else
			location = gNavyVec;
		gWaterExplorePlan = aiPlanCreate("Water Explore", cPlanExplore);
		aiPlanSetVariableBool(gWaterExplorePlan, cExplorePlanReExploreAreas, 0, false);
		aiPlanSetInitialPosition(gWaterExplorePlan, location);
		aiPlanSetDesiredPriority(gWaterExplorePlan, 45); // Low, so that transport plans can steal it as needed, but just above fishing plans.
		aiPlanAddUnitType(gWaterExplorePlan, gFishingUnit, 1, 1, 1);
		aiPlanSetEscrowID(gWaterExplorePlan, cEconomyEscrowID);
		aiPlanSetVariableBool(gWaterExplorePlan, cExplorePlanDoLoops, 0, true);
		aiPlanSetActive(gWaterExplorePlan);
	}	
	if (gWaterExploreMaintain < 0) gWaterExploreMaintain = createSimpleMaintainPlan(gFishingUnit, 1, true, kbBaseGetMainID(cMyID), 1,gWaterExploreMaintain);
}


//==============================================================================
/*
 navyTrainingMonitor
 updatedOn 2022/05/06
 create new navy warships
 
 How to use
 navyTrainingMonitor is auto called waterManager - navyManager
*/
//==============================================================================
void navyTrainingMonitor()
{
	static bool firstRun = true;
	static int shipClass1Maintain = -1;
	static int shipClass2Maintain = -1;
	static int shipClass3Maintain = -1;
	static int shipClassS1Maintain = -1;
	static int shipClassS2Maintain = -1;
	if(gCurrentAge == cAge1) return;
	bool navyBehind = false;
	int navySize = 2;
	if( kbUnitCount(cPlayerRelationEnemyNotGaia, cUnitTypeAbstractWarShip, cUnitStateAlive) >= kbUnitCount(cMyID, cUnitTypeAbstractWarShip, cUnitStateAlive) ) navyBehind = true;
	if(firstRun == true)
	{
		if(gNavyClass1 != -1) shipClass1Maintain = createSimpleMaintainPlan(gNavyClass1, 1, false, kbBaseGetMainID(cMyID), 1,shipClass1Maintain);
		if(gNavyClass2 != -1) shipClass2Maintain = createSimpleMaintainPlan(gNavyClass2, 1, false, kbBaseGetMainID(cMyID), 1,shipClass2Maintain);
		if(gNavyClass3 != -1) shipClass3Maintain = createSimpleMaintainPlan(gNavyClass3, 1, false, kbBaseGetMainID(cMyID), 1,shipClass3Maintain);	
		if(gNavyClassS1 != -1) shipClassS1Maintain = createSimpleMaintainPlan(gNavyClassS1, 1, false, kbBaseGetMainID(cMyID), 1,shipClassS1Maintain);	
		if(gNavyClassS2 != -1) shipClassS2Maintain = createSimpleMaintainPlan(gNavyClassS2, 1, false, kbBaseGetMainID(cMyID), 1,shipClassS2Maintain);	
		firstRun = false;
		aiPlanSetActive(shipClass1Maintain, true);
		aiPlanSetActive(shipClass2Maintain, true);
		aiPlanSetActive(shipClass3Maintain, true);
		aiPlanSetActive(shipClassS1Maintain, true);
		aiPlanSetActive(shipClassS2Maintain, true);
		gNavyMode = cNavyModeActive;
	}
	if(kbProtoUnitAvailable(gNavyClass3) == true && kbUnitCount(cMyID, gNavyClass3) < kbGetBuildLimit(cMyID, gNavyClass3) && gCurrentAge > cAge3)
	{
		if(navyBehind == true) navySize = kbGetBuildLimit(cMyID, gNavyClass3);
		if(gMapTypeIsland == true) navySize = kbGetBuildLimit(cMyID, gNavyClass3);
		aiPlanSetVariableInt(shipClass1Maintain, cTrainPlanNumberToMaintain, 0, 1);
		aiPlanSetVariableInt(shipClass2Maintain, cTrainPlanNumberToMaintain, 0, 1);
		aiPlanSetVariableInt(shipClass3Maintain, cTrainPlanNumberToMaintain, 0, navySize);
	}
	else if(kbProtoUnitAvailable(gNavyClass2) == true && kbUnitCount(cMyID, gNavyClass2) < kbGetBuildLimit(cMyID, gNavyClass2) && gCurrentAge > cAge2)
	{
		if(navyBehind == true) navySize = kbGetBuildLimit(cMyID, gNavyClass2);
		if(gMapTypeIsland == true) navySize = kbGetBuildLimit(cMyID, gNavyClass2);
		aiPlanSetVariableInt(shipClass1Maintain, cTrainPlanNumberToMaintain, 0, 1);
		aiPlanSetVariableInt(shipClass2Maintain, cTrainPlanNumberToMaintain, 0, navySize);
		aiPlanSetVariableInt(shipClass3Maintain, cTrainPlanNumberToMaintain, 0, 1);
	}
	else if(kbProtoUnitAvailable(gNavyClass1) == true && kbUnitCount(cMyID, gNavyClass1) < kbGetBuildLimit(cMyID, gNavyClass1))
	{
		if(navyBehind == true) navySize = kbGetBuildLimit(cMyID, gNavyClass1);
		if(gMapTypeIsland == true) navySize = kbGetBuildLimit(cMyID, gNavyClass1);
		aiPlanSetVariableInt(shipClass1Maintain, cTrainPlanNumberToMaintain, 0, navySize);
		aiPlanSetVariableInt(shipClass2Maintain, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(shipClass3Maintain, cTrainPlanNumberToMaintain, 0, 0);
	}
	else
	{
		aiPlanSetVariableInt(shipClass1Maintain, cTrainPlanNumberToMaintain, 0, 1);
		aiPlanSetVariableInt(shipClass2Maintain, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(shipClass3Maintain, cTrainPlanNumberToMaintain, 0, 0);
		return;
	}
}

//==============================================================================
/*
 navyManager
 updatedOn 2022/05/06
 Managers navy training, exploring and dock building 
 
 How to use
 navyManager is auto called main - mainRules
*/
//==============================================================================
void navyManager()
{ // Managers navy training, exploring and dock building 
	if (gNavyMap == false || cvOkToTrainNavy == false)
	{ //do not make navy if it is not a navy map or navy is turned off
		gNavyMode = cNavyModeOff; //set navy mode to off
		return;
	} //end if
	static bool firstRun = true;
	if(firstRun == true)
	{
		aiTaskUnitMove(getUnit(cUnitTypeMilitary, cMyID, cUnitStateAlive), gNavyFlagLocation);
		firstRun = false;
	}
	static int lastRunTime = 0;
	if (functionDelay(lastRunTime, 10000,"navyManager") == false) return;
	lastRunTime = gCurrentGameTime;
	dockBuildManager(); //dock manager
	if (kbUnitCount(cMyID, gDockUnit, cUnitStateABQ) < 1) return; //renturn if no docks are being made
	waterExploreManager(); //create explore plan
	if (aiTreatyActive() == true) return; //do not create war navy when in treaty
	navyTrainingMonitor(); //train navy
	
} //end navyManager

rule navyStartCheck
active
minInterval 1
{

	if(gWaterShorelineCheck == false) return;
	static int pSelfNavyQry = -1;
	static int pUnitId = -1;
	static vector pShoreId = cInvalidVector;
	static float pShoreDist = -1.0;
	static float pCurrentDist = -1.0;
	static int pexUnit = -1;
	pUnitId = -1;
	pShoreId = cInvalidVector;
	pShoreDist = 99999.0;
	pCurrentDist = -1.0;

	if(pSelfNavyQry == -1) 
	{
		pSelfNavyQry = kbUnitQueryCreate("pSelfNavyQry"+getQueryId());
		kbUnitQuerySetPlayerID(pSelfNavyQry,cMyID,false);
		kbUnitQuerySetPlayerRelation(pSelfNavyQry, -1);
		kbUnitQuerySetUnitType(pSelfNavyQry, cUnitTypeShip);
		kbUnitQuerySetIgnoreKnockedOutUnits(pSelfNavyQry, true);
		kbUnitQuerySetState(pSelfNavyQry, cUnitStateAlive);
	}
	kbUnitQueryResetResults(pSelfNavyQry);
	for(i = 0; < kbUnitQueryExecute(pSelfNavyQry))
	{
		pUnitId = kbUnitQueryGetResult(pSelfNavyQry, i);
		if(kbUnitGetNumberContained(pUnitId) > 0)
		{
			pShoreId = xsArrayGetVector(gShorelineArray, 0);
			if(distance(kbUnitGetPosition(pUnitId),pShoreId) < 25)
			{
				if(kbUnitGetActionType(pUnitId) == 7 )aiTaskUnitEject(pUnitId);
			}
			else
			{
				aiTaskUnitMove(pUnitId,pShoreId);
			}
		}
	}

	pexUnit = getUnit(gExplorerUnit, cMyID, cUnitStateAlive);
	aiPlanDestroy(pexUnit);
	if (kbUnitGetActionType(pexUnit) == 7 && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == 0)
	{ //move to center
		aiTaskUnitMove(pexUnit,gMapCenter);
	}
	else if (kbUnitGetActionType(pexUnit) != 9 && kbUnitCount(cMyID, gTownCenter, cUnitStateBuilding) == 1)
	{
		
		aiTaskUnitWork(pexUnit,getUnit(gTownCenter, cMyID, cUnitStateBuilding));
	}
	else if (kbUnitGetActionType(pexUnit) == 9)
	{ //build tc
		aiTaskUnitBuild(pexUnit, gTownCenter, kbUnitGetPosition(pexUnit));
	}
	else if (kbUnitCount(cMyID, gTownCenter, cUnitStateAlive) >= 1)
	{ //disable when building
		xsDisableSelf();
	}

}


void boatUnitTraining()
{
	//train pets and units from boats
}

