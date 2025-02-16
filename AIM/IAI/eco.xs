//economy

//==============================================================================
/* rule economyUpdate replaces build_plantation and build_mill
	Complete rewrite - updatedOn 2022/02/13 By ageekhere 
*/
//==============================================================================

//==============================================================================
/*
 economyUpdate
 updatedOn 2023/01/20
 Controls when the ai need to build a new farm or plantation unit
 
 How to use
 Auto called in mainRules
*/
//==============================================================================
void economyUpdate(int pEcoType = -1, int pBuildType = -1)
{ //Controls when the ai need to build a new farm or plantation unit
	static int pBuildingCount = 0; //saves the eco type building count "ABQ"
	static int pBuildingQry = -1; //The current number of eco buildings
	static int pCurrentGatherers = -1; //The current number of villagers currently gathering
	const int pMaxNumEcoBuildings = 10; //cap to max of 10 eco building of each type
	const int pNumOfWorkers = 7; //The number of workers on an eco building before making a new one

	if (checkBuildingPlan(pEcoType) == -1)
	{ //Check if a plan has not been created 
		pCurrentGatherers = 0; //reset count 
		if (pBuildingQry == -1) 
		{ //only create the qry once which values that are not going to change
			pBuildingQry = kbUnitQueryCreate("pBuildingQry"+ getQueryId()); //Creates a Query for counting eco buildings
			kbUnitQuerySetPlayerID(pBuildingQry, cMyID, false); //set player, id does not change
			kbUnitQuerySetPlayerRelation(pBuildingQry, -1);
			kbUnitQuerySetState(pBuildingQry, cUnitStateABQ); //set state, state does not change
		} //end if
		kbUnitQueryResetResults(pBuildingQry); //reset results
		kbUnitQuerySetUnitType(pBuildingQry, pEcoType); //set pEcoType buildings, change the pEcoType for qry
		pBuildingCount = kbUnitQueryExecute(pBuildingQry); //store the results
		if (pBuildingCount == 0)
		{ //if this is the first build of this type just make it
			buildingBluePrint(pEcoType,-1);
			return; //exit now
		} //end if
		for (i = 0; < pBuildingCount)
		{ //Loop through the AI's pEcoType buildings
			pCurrentGatherers = pCurrentGatherers + kbUnitGetNumberWorkers(kbUnitQueryGetResult(pBuildingQry, i)); //Count the total number of villiagers on pEcoType
		} //end for i
		if (pCurrentGatherers > (pNumOfWorkers * i) - 5 && kbUnitCount(cMyID, pEcoType, cUnitStateABQ) < pMaxNumEcoBuildings)
		{ //when pEcoType are all full
			buildingBluePrint(pEcoType,-1);
		} //end if
		if(gCurrentAge == cAge5 && gCurrentAliveSettlers > (kbUnitCount(cMyID, gFarmUnit, cUnitStateABQ) + kbUnitCount(cMyID, gPlantationUnit, cUnitStateABQ) * 10) && kbUnitCount(cMyID, pEcoType, cUnitStateABQ) < 5)
		{
			buildingBluePrint(pEcoType,-1);
		}
		pBuildingCount = 0; //reset the building count
	} //end if	
	
} //end economyUpdate

//==============================================================================
/*
	buildEconomy
	updatedOn 2023/01/12
	
	How to use
*/
//==============================================================================
void buildEconomy(void)
{ //controlls when the ai builds a new farm/plantation/rice paddy
	if (cvOkToBuild == false) return; //Check if the ai is allowed to build
	
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"buildEconomy") == false) return;
	lastRunTime = gCurrentGameTime;
	
	if(gTimeToFarm) economyUpdate(gFarmUnit,0); //Check if a new farm is needed
	if(gTimeForPlantations) economyUpdate(gPlantationUnit,1); //Check if a new plantation is needed
} //end build_economy


void ecoMain()
{

}