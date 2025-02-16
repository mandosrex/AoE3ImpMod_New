//tools
int unitGathererLimit(int unitID = -1)
{
	switch(unitID)
	{
		case cUnitTypeBeluga :{ return( 4 );break;}
		case cUnitTypeMill :{ return( 10 );break;}
		case cUnitTypeSheep :{ return( 8 );break;}
		case cUnitTypeBison :{ return( 8 );break;}
		case cUnitTypeHouse :{ return( 2 );break;}
		case cUnitTypeFishSalmon :{ return( 8 );break;}
		case cUnitTypeTreeCarolinaGrass :{ return( 8 );break;}
		case cUnitTypeElk :{ return( 8 );break;}
		case cUnitTypeTreeAmazon :{ return( 8 );break;}
		case cUnitTypeTapir :{ return( 8 );break;}
		case cUnitTypeCrateofFood :{ return( 8 );break;}
		case cUnitTypeCrateofWood :{ return( 8 );break;}
		case cUnitTypeCrateofCoin :{ return( 8 );break;}
		case cUnitTypePlantation :{ return( 10 );break;}
		case cUnitTypeCapybara :{ return( 8 );break;}
		case cUnitTypeDeer :{ return( 8 );break;}
		case cUnitTypeCaribou :{ return( 8 );break;}
		case cUnitTypeMoose :{ return( 8 );break;}
		case cUnitTypeMuskOx :{ return( 8 );break;}
		case cUnitTypeBighornSheep :{ return( 8 );break;}
		case cUnitTypeTurkey :{ return( 8 );break;}
		case cUnitTypeTreeYukon :{ return( 8 );break;}
		case cUnitTypeTreeYukonSnow :{ return( 8 );break;}
		case cUnitTypeCow :{ return( 8 );break;}
		case cUnitTypeTreeSaguenay :{ return( 8 );break;}
		case cUnitTypeMine :{ return( 20 );break;}
		case cUnitTypeFishCod :{ return( 8 );break;}
		case cUnitTypeLivestockPen :{ return( 10 );break;}
		case cUnitTypeTreeTexas :{ return( 8 );break;}
		case cUnitTypeTreeTexasDirt :{ return( 8 );break;}
		case cUnitTypeTreeGreatLakes :{ return( 8 );break;}
		case cUnitTypeTreeNewEngland :{ return( 8 );break;}
		case cUnitTypeTreeGreatPlains :{ return( 8 );break;}
		case cUnitTypeTreeBayou :{ return( 8 );break;}
		case cUnitTypeBerryBush :{ return( 8 );break;}
		case cUnitTypeManor :{ return( 2 );break;}
		case cUnitTypeCrateofXP :{ return( 8 );break;}
		case cUnitTypeCrateofFoodLarge :{ return( 8 );break;}
		case cUnitTypeCrateofWoodLarge :{ return( 8 );break;}
		case cUnitTypeCrateofCoinLarge :{ return( 8 );break;}
		case cUnitTypeTreePampas :{ return( 8 );break;}
		case cUnitTypeTreeRockies :{ return( 8 );break;}
		case cUnitTypeTreeRockiesSnow :{ return( 8 );break;}
		case cUnitTypeTreeCarolinaMarsh :{ return( 8 );break;}
		case cUnitTypeTreeYucatan :{ return( 8 );break;}
		case cUnitTypeTreeCaribbean :{ return( 8 );break;}
		case cUnitTypeTarget :{ return( 8 );break;}
		case cUnitTypeTreeBayouMarsh :{ return( 8 );break;}
		case cUnitTypeTreeGreatLakesSnow :{ return( 8 );break;}
		case cUnitTypeTreeSonora :{ return( 8 );break;}
		case cUnitTypeLlama :{ return( 8 );break;}
		case cUnitTypeMineGold :{ return( 20 );break;}
		case cUnitTypeTreePatagoniaDirt :{ return( 8 );break;}
		case cUnitTypeTreePatagoniaSnow :{ return( 8 );break;}
		case cUnitTypeHouseEast :{ return( 2 );break;}
		case cUnitTypeHouseMed :{ return( 2 );break;}
		case cUnitTypeMinkeWhale :{ return( 4 );break;}
		case cUnitTypeHumpbackWhale :{ return( 4 );break;}
		case cUnitTypeFishBass :{ return( 8 );break;}
		case cUnitTypeFishSardine :{ return( 8 );break;}
		case cUnitTypeFishTarpon :{ return( 8 );break;}
		case cUnitTypeFishMahi :{ return( 8 );break;}
		case cUnitTypeFishMoonBass :{ return( 8 );break;}
		case cUnitTypeGiftCoin :{ return( 8 );break;}
		case cUnitTypeGiftFood :{ return( 8 );break;}
		case cUnitTypeGiftWood :{ return( 8 );break;}
		case cUnitTypeReindeer :{ return( 8 );break;}
		case cUnitTypeTreeChristmas :{ return( 8 );break;}
		case cUnitTypeFarm :{ return( 10 );break;}
		case cUnitTypeTreeRedwood :{ return( 8 );break;}
		case cUnitTypeTreeMadrone :{ return( 8 );break;}
		case cUnitTypeTreePuya :{ return( 8 );break;}
		case cUnitTypeMineCopper :{ return( 20 );break;}
		case cUnitTypeSeal :{ return( 8 );break;}
		case cUnitTypeTreeKapok :{ return( 8 );break;}
		case cUnitTypeFirePit :{ return( 25 );break;}
		case cUnitTypeTreePolyepis :{ return( 8 );break;}
		case cUnitTypeTreeAndes :{ return( 8 );break;}
		case cUnitTypeTreeJuniper :{ return( 8 );break;}
		case cUnitTypeTreePonderosaPine :{ return( 8 );break;}
		case cUnitTypeTreePinonPine :{ return( 8 );break;}
		case cUnitTypeMineTin :{ return( 20 );break;}
		case cUnitTypeTreePaintedDesert :{ return( 8 );break;}
		case cUnitTypeGuanaco :{ return( 8 );break;}
		case cUnitTypeTreeNorthwestTerritory :{ return( 8 );break;}
		case cUnitTypeTreeNewEnglandSnow :{ return( 8 );break;}
		case cUnitTypeTreeAraucania :{ return( 8 );break;}
		case cUnitTypeHouseAztec :{ return( 1 );break;}
		case cUnitTypeCrateofTurkey :{ return( 8 );break;}
		case cUnitTypeCrateofTurkeyLarge :{ return( 8 );break;}
		case cUnitTypeCrateofSquash :{ return( 8 );break;}
		case cUnitTypeCrateofSquashLarge :{ return( 8 );break;}
		case cUnitTypeCrateofWheatBundle :{ return( 8 );break;}
		case cUnitTypeCrateofWheatBundleLarge :{ return( 8 );break;}
		case cUnitTypeypRicePaddy :{ return( 10 );break;}
		case cUnitTypeypSacredField :{ return( 10 );break;}
		case cUnitTypeypVillage :{ return( 5 );break;}
		case cUnitTypeYPLivestockPenAsian :{ return( 10 );break;}
		case cUnitTypeypShrineJapanese :{ return( 4 );break;}
		case cUnitTypeypWaterBuffalo :{ return( 8 );break;}
		case cUnitTypeypTreeAshoka :{ return( 8 );break;}
		case cUnitTypeypGoat :{ return( 8 );break;}
		case cUnitTypeypTreeEucalyptus :{ return( 8 );break;}
		case cUnitTypeypTreeDeccan :{ return( 8 );break;}
		case cUnitTypeypSaiga :{ return( 8 );break;}
		case cUnitTypeypNilgai :{ return( 8 );break;}
		case cUnitTypeypWildElephant :{ return( 8 );break;}
		case cUnitTypeypIbex :{ return( 8 );break;}
		case cUnitTypeypSerow :{ return( 8 );break;}
		case cUnitTypeypFishCatfish :{ return( 8 );break;}
		case cUnitTypeypFishCarp :{ return( 8 );break;}
		case cUnitTypeypYak :{ return( 8 );break;}
		case cUnitTypeypTreeGinkgo :{ return( 8 );break;}
		case cUnitTypeypTreeBamboo :{ return( 8 );break;}
		case cUnitTypeypTreeYellowRiver :{ return( 8 );break;}
		case cUnitTypeypPropsJapaneseGarden :{ return( 8 );break;}
		case cUnitTypeypTreeJapaneseMaple :{ return( 8 );break;}
		case cUnitTypeypTreeJapanesePine :{ return( 8 );break;}
		case cUnitTypeypTreeJapaneseMapleWinter :{ return( 8 );break;}
		case cUnitTypeypTreeJapanesePineWinter :{ return( 8 );break;}
		case cUnitTypeypSquid :{ return( 8 );break;}
		case cUnitTypeypGiantSalamander :{ return( 8 );break;}
		case cUnitTypeypSPCAztecFarm :{ return( 10 );break;}
		case cUnitTypeypWJToshoguShrine2 :{ return( 10 );break;}
		case cUnitTypeypWJToshoguShrine3 :{ return( 10 );break;}
		case cUnitTypeypWJToshoguShrine4 :{ return( 10 );break;}
		case cUnitTypeypWJToshoguShrine5 :{ return( 10 );break;}
		case cUnitTypeypIGCBird :{ return( 8 );break;}
		case cUnitTypeypSPCRockCrate :{ return( 4 );break;}
		case cUnitTypeypTreeCoastalJapan :{ return( 8 );break;}
		case cUnitTypeypFishMolaMola :{ return( 8 );break;}
		case cUnitTypeypFishTuna :{ return( 8 );break;}
		case cUnitTypeypBerryBuilding :{ return( 20 );break;}
		case cUnitTypeypTreeBorneo :{ return( 8 );break;}
		case cUnitTypeypTreeBorneoPalm :{ return( 8 );break;}
		case cUnitTypeypTreeBorneoCanopy :{ return( 8 );break;}
		case cUnitTypeypCrateofCoin :{ return( 8 );break;}
		case cUnitTypeypCrateofFood :{ return( 8 );break;}
		case cUnitTypeypCrateofWood :{ return( 8 );break;}
		case cUnitTypeypGroveBuilding :{ return( 20 );break;}
		case cUnitTypeypTreeHemlock :{ return( 8 );break;}
		case cUnitTypeypTreeSpruce :{ return( 8 );break;}
		case cUnitTypeypTreeSaxaul :{ return( 8 );break;}
		case cUnitTypeypTreeMongolianFir :{ return( 8 );break;}
		case cUnitTypeypTreeHimalayas :{ return( 8 );break;}
		case cUnitTypeypTreeMongolia :{ return( 8 );break;}
		case cUnitTypeypTreeCeylon :{ return( 8 );break;}
		case cUnitTypeypMuskDeer :{ return( 8 );break;}
		case cUnitTypeypCrateofCoin1 :{ return( 8 );break;}
		case cUnitTypeypCrateofFood1 :{ return( 8 );break;}
		case cUnitTypeypCrateofWood1 :{ return( 8 );break;}
		case cUnitTypeypGoatFat :{ return( 8 );break;}
		case cUnitTypeypSacredCow :{ return( 8 );break;}
		case cUnitTypeResourceWagon :{ return( 8 );break;}
		case cUnitTypeCoinWagon :{ return( 8 );break;}
		case cUnitTypeFoodWagon :{ return( 8 );break;}
		case cUnitTypeWoodWagon :{ return( 8 );break;}
		case cUnitTypeCrateFoodLarge :{ return( 8 );break;}
		case cUnitTypeCrateWoodLarge :{ return( 8 );break;}
		case cUnitTypeCrateCoinLarge :{ return( 8 );break;}
		case cUnitTypeTreasuryCoinCratesAztec :{ return( 8 );break;}
		case cUnitTypeHouseVilla :{ return( 2 );break;}
		case cUnitTypeTreeChristmas2 :{ return( 8 );break;}
		case cUnitTypeGiftCoin2 :{ return( 8 );break;}
		case cUnitTypeZebra :{ return( 8 );break;}
		case cUnitTypeTreePlymouth :{ return( 8 );break;}
		case cUnitTypeypTreeIndo :{ return( 8 );break;}
		case cUnitTypeTreeNile :{ return( 8 );break;}
		case cUnitTypeDromedary :{ return( 8 );break;}
		case cUnitTypeCrateofFame :{ return( 8 );break;}
		case cUnitTypeGazelle :{ return( 8 );break;}
		case cUnitTypeTreeBaobab :{ return( 4 );break;}
		case cUnitTypeOkapi :{ return( 8 );break;}
		case cUnitTypeBerryBushNative :{ return( 8 );break;}
		case cUnitTypePig :{ return( 8 );break;}
		case cUnitTypeWhiteBison :{ return( 8 );break;}
		case cUnitTypeTreeSpruce :{ return( 8 );break;}
		case cUnitTypeWombat :{ return( 8 );break;}
		case cUnitTypeMineGoldUS :{ return( 20 );break;}
		case cUnitTypeChristmasTree :{ return( 8 );break;}
		case cUnitTypeChicken :{ return( 8 );break;}
		case cUnitTypeChickenPen :{ return( 8 );break;}
		case cUnitTypeTreePalmetto :{ return( 8 );break;}
		case cUnitTypeCrateofCoinHouse :{ return( 8 );break;}
		case cUnitTypeCrateofFoodHouse :{ return( 8 );break;}
		case cUnitTypeHouseTorp :{ return( 2 );break;}
		case cUnitTypeCrateofWoodHouse :{ return( 8 );break;}
		case cUnitTypeMineShipRuins :{ return( 20 );break;}
		case cUnitTypeKangaroo :{ return( 8 );break;}
		case cUnitTypePeafowl :{ return( 8 );break;}
		case cUnitTypePenguin :{ return( 8 );break;}
		case cUnitTypeRabbit :{ return( 8 );break;}
		case cUnitTypePheasant :{ return( 8 );break;}
		case cUnitTypeBoar :{ return( 8 );break;}
		case cUnitTypeMineIron :{ return( 20 );break;}
		case cUnitTypeTreeStart :{ return( 8 );break;}
		case cUnitTypePronghorn :{ return( 8 );break;}
		case cUnitTypeRhea :{ return( 8 );break;}
		case cUnitTypeCrane :{ return( 8 );break;}
		case cUnitTypePeafowl :{ return( 8 );break;}
		case cUnitTypeHeron :{ return( 8 );break;}
		case cUnitTypeSPCMine :{ return( 20 );break;}
		case cUnitTypeSPCSpanishShipRuins :{ return( 20 );break;}
	}
	return(10);
}

//==============================================================================
/*
 xs2DArrayCreate
 updatedOn 2022/04/16
 Creates a new float 2d array
 
 How to use
 Call xs2DArrayCreate to create a new float 2d Array, save the id of the array.
 Use myArrayName to get or set the 2d array
 
 Example
 int myArrayName = xs2DArrayCreate();
*/
//==============================================================================
int xs2DArrayCreate() 
{ //Creates a new float 2d array
	debugRule("int xs2DArrayCreate ",-1);
	static int index = -1; //stores the ID of the Array
	index++; //Update the ID count of every new 2d Array created
	xsQVSet("2DArray"+index, 1); //Set the array
	return(index); //return of ID
} //end xs2DArrayCreate

//==============================================================================
/*
 xs2DArraySetFloat
 updatedOn 2022/04/16
 Updates a float 2d Array
 
 How to use
 call xs2DArraySetFloat and pass the arrayID, coloum, row and value
 
 Example
 xs2DArrayCreateFloat(myArrayName, 0,0,1.0);
*/
//==============================================================================
void xs2DArraySetFloat(int arrayID = -1, int column = 0, int row = 0,  float value = 0.0) 
{ //Updates a float 2d Array
	debugRule("void xs2DArraySetFloat ",-1);
	if (xsQVGet("2DArray"+arrayID) != 1) 
	{ //Check if the 2d array exists
		debugRule("void xs2DArraySetFloat - ERROR no match ",1); //send debug if not, need debug level at 1
		return;
	} //end if
	xsQVSet("2DArray"+arrayID+"column"+column+"row"+row, value); //set the 2d array
} //end xs2DArraySetFloat


void xs2DArraySetInt(int arrayID = -1, int column = 0, int row = 0,  int value = 0) 
{ //Updates a int 2d Array
	debugRule("void xs2DArraySetInt ",-1);
	if (xsQVGet("2DArray"+arrayID) != 1) 
	{ //Check if the 2d array exists
		debugRule("void xs2DArraySetInt - ERROR no match ",1); //send debug if not, need debug level at 1
		return;
	} //end if
	xsQVSet("2DArray"+arrayID+"column"+column+"row"+row, value); //set the 2d array
} //end xs2DArraySetInt



//==============================================================================
/*
 xs2DArrayGetFloat
 updatedOn 2022/04/16
 Gets values from a float 2d Array
 
 How to use
 call xs2DArrayGetFloat and pass the arrayID, coloum and row
 
 Example
 xs2DArrayGetFloat(myArrayName, 0,0);
*/
//==============================================================================
float xs2DArrayGetFloat(int arrayID = -1, int column = 0, int row = 0) 
{ //Gets values from a float 2d Array
  debugRule("void xs2DArrayGetFloat ",-1);
  return(xsQVGet("2DArray"+arrayID+"column"+column+"row"+row)); //returns the values from the float array
} //end xs2DArrayGetFloat

int xs2DArrayGetInt(int arrayID = -1, int column = 0, int row = 0) 
{ //Gets values from a float 2d Array
  debugRule("void xs2DArrayGetInt ",-1);
  return(xsQVGet("2DArray"+arrayID+"column"+column+"row"+row)); //returns the values from the float array
} //end xs2DArrayGetInt



//==============================================================================
/*
 addExcludeSettler
 updatedOn 2022/04/19
 Adds a settler to the exclude array
 
 How to use
 call addExcludeSettler and pass a settlerId
 
 Example
 addExcludeSettler(settlerId);
*/
//==============================================================================
void addExcludeSettler(int settlerId = -1)
{ //Adds a settler to the exclude array at
	debugRule("void addExcludeSettler ",-1);
	static int forLength = -1;
	forLength = xsArrayGetSize(gExcludeSettlersArray);
	for (i = 0; < forLength)
	{ //loop through array
		if (xsArrayGetInt(gExcludeSettlersArray, i) == -1)
		{ //check for free spot
			debugRule("void addExcludeSettler - adding settler to exclude array",1);
			xsArraySetInt(gExcludeSettlersArray, i, settlerId); //add the settler
			return;
		} //end if
	} //end for
} //end addExcludeSettler

//==============================================================================
/*
 removeExcludeSettler
 updatedOn 2022/04/19
 Remove a settler from the exclude array, checkExcludeSettler should be called first to
 check if the settler is in the array
 
 How to use
 call removeExcludeSettler and pass a settlerId
 
 Example
 removeExcludeSettler(settlerId);
*/
//==============================================================================
void removeExcludeSettler(int settlerId = -1)
{ //Remove a settler from the exclude array
	debugRule("void removeExcludeSettler ",-1);
	static int forLength = -1;
	forLength = xsArrayGetSize(gExcludeSettlersArray);
	for (i = 0; < forLength)
	{ //loop through array
		if (xsArrayGetInt(gExcludeSettlersArray, i) == settlerId)
		{ //check for match
			debugRule("void removeExcludeSettler - removing settler from exclude array",1);
			xsArraySetInt(gExcludeSettlersArray, i, -1); //remove the settler
			return;
		} //end if
	} //end for
} //end removeExcludeSettler

//==============================================================================
/*
 intInsertionSort
 updatedOn 2022/04/21
 Sorts a int array in a ascending order.
 
 How to use
 call intInsertionSort and pass a int array id. Store the sorted returned value.
 
 Example
 int arrayID = intInsertionSort(arrayID);
*/
//==============================================================================
int intInsertionSort(int arraySort = -1)
{ //Sorts a int array in a ascending order.
	debugRule("int intInsertionSort ",-1);
	static int temp = -1;
	static int j = -1;
	static int forLength = -1;
	forLength = xsArrayGetSize(arraySort);
    for (i = 1; < forLength) 
	{
		temp = xsArrayGetInt(arraySort,i);
        j = i - 1;
        while (j >= 0 && xsArrayGetInt(arraySort,j) > temp) 
		{
            xsArraySetInt(arraySort, j + 1, xsArrayGetInt(arraySort,j) ); //arr[j + 1] = arr[j];
            j = j - 1;
        }
		xsArraySetInt(arraySort, j + 1, temp );
    }
	return(arraySort);
}

//==============================================================================
/*
 floatInsertionSort
 updatedOn 2022/04/21
 Sorts a float array in a ascending order.
 
 How to use
 call floatInsertionSort and pass a float array id. Store the sorted returned value.
 
 Example
 float arrayID = floatInsertionSort(arrayID);
*/
//==============================================================================
int floatInsertionSort(int arraySort = -1)
{
	debugRule("int floatInsertionSort ",-1);
	static int temp = -1;
	static int j = -1;
	static int forLength = -1;
	forLength = xsArrayGetSize(arraySort);
    for (i = 1; < forLength) 
	{
		temp = xsArrayGetFloat(arraySort,i);
        j = i - 1;
        while (j >= 0 && xsArrayGetFloat(arraySort,j) > temp) 
		{
            xsArraySetFloat(arraySort, j + 1, xsArrayGetFloat(arraySort,j) ); //arr[j + 1] = arr[j];
            j = j - 1;
        }
		xsArraySetFloat(arraySort, j + 1, temp );
    }
	return(arraySort);
}

void vectorSortCenter(int arraySort = -1, vector pPosition = cInvalidVector, string pSortBy = "")
{
    debugRule("int vectorSort ",-1);
    static vector temp = cInvalidVector;
    static vector temp2 = cInvalidVector;
    static int j = -1;
    static int forLength = -1;
    static float pDist = -1.0; 
    static float pNextDist = -1.0; 
    forLength = xsArrayGetSize(arraySort);
    for (i = 1; < forLength) 
    {
        temp = xsArrayGetVector(arraySort, i);
        pDist = distance(temp, pPosition);
        j = i - 1;
        while (j >= 0) 
        {
            temp2 = xsArrayGetVector(arraySort, j);
            pNextDist = distance(temp2, pPosition);
			if ((pSortBy == "nearest" && pNextDist < pDist) || (pSortBy != "nearest" && pNextDist > pDist)) break;
            xsArraySetVector(arraySort, j + 1, temp2);
            j--;
        }
        xsArraySetVector(arraySort, j + 1, temp);
    }
}


//==============================================================================
/*
 unitCountFromCancelledMission
 updatedOn 2022/04/22
 Returns total units from cancelled mission
 
 How to use
 call unitCountFromCancelledMission and pass a cOpportunitySource

 Example
 int number = unitCountFromCancelledMission(cOpportunitySourceAllyRequest);
*/
//==============================================================================
int unitCountFromCancelledMission(int oppSource = cOpportunitySourceAllyRequest)
{ //Returns total units from cancelled mission
	debugRule("int unitCountFromCancelledMission ",-1);
	static int retVal = -1; // Number of military units available
	static int planCount = -1; //holds the plan number count
	static int plan = -1; //holds the plan
	static int childPlan = -1; //holds the child plan
	static int oppID = -1; //holds the plan opportunity
	static int pri = -1; //holds the opportunity tource type
	if (oppSource == cOpportunitySourceTrigger) return (0); // DO NOT mess with scenario triggers
	gMissionToCancel = -1;
	retVal = 0;
	plan = -1;
	childPlan = -1;
	oppID = -1;
	pri = -1;
	planCount = aiPlanGetNumber(cPlanMission, cPlanStateWorking, true);
	for (i = 0; < planCount)
	{ //loop through plan count
		plan = aiPlanGetIDByIndex(cPlanMission, cPlanStateWorking, true, i);
		if (plan < 0) continue;
		childPlan = aiPlanGetVariableInt(plan, cMissionPlanPlanID, 0);
		oppID = aiPlanGetVariableInt(plan, cMissionPlanOpportunityID, 0);
		pri = aiGetOpportunitySourceType(oppID);
		if ((pri > cOpportunitySourceAutoGenerated) && (pri <= oppSource)) 
		{ // This isn't an auto-generated opp, and the incoming command has sufficient rank.
			gMissionToCancel = plan; // Store this so commHandler can kill it.
			retVal = aiPlanGetNumberUnits(childPlan, cUnitTypeLogicalTypeLandMilitary);
		} //end if
		else retVal = 0;
	}
	debugRule("int unitCountFromCancelledMission - for (i  " + i, 1);
	debugRule("int unitCountFromCancelledMission - retVal " + retVal, 1);
	return (retVal);
} //end unitCountFromCancelledMission

//==============================================================================
/*
 functionDelay
 updatedOn 2022/04/22
 Checks if a set amount of time has pass before allowing the function to run.
 
 How to use
 call functionDelay and pass a the last time the funcation was call, the delay amount and some extra random time

 Example
 if(functionDelay(lastRunTime, 10000) == false) return;
*/
//==============================================================================

bool functionDelay(int lastRunTime = -1, int delay = -1, string calledFunction = "")
{
	//if(gCurrentGameTime < 1000) return(false);
	if(gCurrentGameTime < lastRunTime + delay)return (false); //+ (aiRandInt(3) * 1000)
	return(true);
}
	


/*
bool functionDelay WIP(int lastRunTime = -1, int delay = -1, string calledFunction = "")
{
	
	static int count = 0;
	static int last = 0;
	const int maxPerTick = 5;
	
	if (queArray == -1) queArray = xsArrayCreateString(120, "BLANK", "queArray");
	
	int c = 0;
	for(i = 0; < xsArrayGetSize(queArray) )
	{
		if(xsArrayGetString(queArray, i) != "BLANK") c++;	
	}
		
		
	//if(count < maxPerTick)
	//{		
		for(i = 0; < xsArrayGetSize(queArray) )
		{
			if(xsArrayGetString(queArray, i) == calledFunction)
			{
				xsArraySetString(queArray,i,"BLANK");
//				count++;
				break;
		//		return(true);
			}
		}
	//}
	
//	if(gCurrentGameTime < lastRunTime + delay)return (false); //+ (aiRandInt(3) * 1000)


	if(gCurrentGameTime == last)
	{
		count++;
	}
	else 
	{
		count = 0;
	}
	
	
	if(count > maxPerTick) 
	{
		
		for(i = 0; < xsArrayGetSize(queArray) )
		{
			if(xsArrayGetString(queArray, i) == "BLANK" || xsArrayGetString(queArray, i) == calledFunction)
			{
				xsArraySetString(queArray,i,calledFunction);
				break;
			}
		}
		return (false);
	}
	
	
	last = gCurrentGameTime;
	return(true);
}
*/


// can be replaced or removed
int FIND(int utID = -1, int prID = cMyID, int pos = -1, int state = cUnitStateAlive)
{
	if (gQ_FIND == -1)
	{
		gQ_FIND = kbUnitQueryCreate("FIND"+getQueryId());
		kbUnitQuerySetIgnoreKnockedOutUnits(gQ_FIND, true);
	}

	int found = 0;
	if (pos <= 0)
	{
		kbUnitQueryResetResults(gQ_FIND);
		if (prID < 1000)
		{
			kbUnitQuerySetPlayerRelation(gQ_FIND, -1);
			kbUnitQuerySetPlayerID(gQ_FIND, prID, false);
		}
		else
		{
			kbUnitQuerySetPlayerID(gQ_FIND, -1, false);
			kbUnitQuerySetPlayerRelation(gQ_FIND, prID);
		}
		kbUnitQuerySetUnitType(gQ_FIND, utID);
		kbUnitQuerySetState(gQ_FIND, state);
		found = kbUnitQueryExecute(gQ_FIND);
		if (pos < 0)
			return (kbUnitQueryGetResult(gQ_FIND, aiRandInt(found)));
	}
	return (kbUnitQueryGetResult(gQ_FIND, pos));
}

int FINDAT(int utID = -1, int prID = cMyID, vector loc = cInvalidVector, float radius = 30.0, int pos = -1, int state = cUnitStateAlive)
{
	if (gQ_FINDAT == -1)
	{
		gQ_FINDAT = kbUnitQueryCreate("FINDAT"+getQueryId());
		kbUnitQuerySetIgnoreKnockedOutUnits(gQ_FINDAT, true);
		kbUnitQuerySetAscendingSort(gQ_FINDAT, true);
	}

	int found = 0;
	if (pos <= 0)
	{
		kbUnitQueryResetResults(gQ_FINDAT);
		if (prID < 1000)
		{
			kbUnitQuerySetPlayerRelation(gQ_FINDAT, -1);
			kbUnitQuerySetPlayerID(gQ_FINDAT, prID, false);
		}
		else
		{
			kbUnitQuerySetPlayerID(gQ_FINDAT, -1, false);
			kbUnitQuerySetPlayerRelation(gQ_FINDAT, prID);
		}
		kbUnitQuerySetUnitType(gQ_FINDAT, utID);
		kbUnitQuerySetState(gQ_FINDAT, state);
		kbUnitQuerySetPosition(gQ_FINDAT, loc);
		kbUnitQuerySetMaximumDistance(gQ_FINDAT, radius);
		found = kbUnitQueryExecute(gQ_FINDAT);
		if (pos < 0)
			return (kbUnitQueryGetResult(gQ_FINDAT, aiRandInt(found)));
	}
	return (kbUnitQueryGetResult(gQ_FINDAT, pos));
}

int COUNTAT(int utID = -1, int prID = cMyID, vector loc = cInvalidVector, float radius = 30.0, int state = cUnitStateAlive)
{
	if (gQ_COUNTAT == -1)
	{
		gQ_COUNTAT = kbUnitQueryCreate("COUNTAT"+getQueryId());
		kbUnitQuerySetIgnoreKnockedOutUnits(gQ_COUNTAT, true);
	}

	kbUnitQueryResetResults(gQ_COUNTAT);
	if (prID < 1000)
	{
		kbUnitQuerySetPlayerRelation(gQ_COUNTAT, -1);
		kbUnitQuerySetPlayerID(gQ_COUNTAT, prID, false);
	}
	else
	{
		kbUnitQuerySetPlayerID(gQ_COUNTAT, -1, false);
		kbUnitQuerySetPlayerRelation(gQ_COUNTAT, prID);
	}
	kbUnitQuerySetUnitType(gQ_COUNTAT, utID);
	kbUnitQuerySetState(gQ_COUNTAT, state);
	kbUnitQuerySetPosition(gQ_COUNTAT, loc);
	kbUnitQuerySetMaximumDistance(gQ_COUNTAT, radius);
	return (kbUnitQueryExecute(gQ_COUNTAT));
}

int DOUBLEQUERY(int queryID = -1, int utID = -1, vector loc = cInvalidVector, float radius = 200.0, int pos = -1)
{
	if (gQ_DOUBLE == -1)
	{
		gQ_DOUBLE = kbUnitQueryCreate("DOUBLE"+getQueryId());
		kbUnitQuerySetAscendingSort(gQ_DOUBLE, true);
	}

	int found = 0;
	if (pos <= 0)
	{
		kbUnitQueryResetResults(gQ_DOUBLE);
		kbUnitQuerySetUnitType(gQ_DOUBLE, utID);
		kbUnitQuerySetPosition(gQ_DOUBLE, loc);
		kbUnitQuerySetMaximumDistance(gQ_DOUBLE, radius);
		found = kbUnitQueryExecuteOnQuery(gQ_DOUBLE, queryID);
		if (pos < 0)
			return (kbUnitQueryGetResult(gQ_DOUBLE, aiRandInt(found)));
	}
	return (kbUnitQueryGetResult(gQ_DOUBLE, pos));
}

int FINDBYACTION(int unit_type = -1, int action = -1, int pos = 0)
{
	if (gQ_ACTION == -1)
	{
		gQ_ACTION = kbUnitQueryCreate("ACTION"+getQueryId());
		kbUnitQuerySetAscendingSort(gQ_ACTION, true);
	}

	if (pos == 0)
	{
		kbUnitQueryResetResults(gQ_ACTION);
		kbUnitQuerySetActionType(gQ_ACTION, action);
		kbUnitQuerySetUnitType(gQ_ACTION, unit_type);
		kbUnitQueryExecute(gQ_ACTION);
	}
	return (kbUnitQueryGetResult(gQ_ACTION, pos));
}

//==============================================================================
/*
 checkResourceAssignment
 updatedOn 2022/04/24
 Checks to see if a resource has move settlers than the assign number
 
 How to use
 call checkResourceAssignment and pass a the queryId and the number max settler assignment

 Example
 bool ableToAssign = checkResourceAssignment(queryId, number); 
*/
//==============================================================================
bool checkResourceAssignment(int lookId = -1, int numberAssigned = -1)
{
	debugRule("bool checkResourceAssignment ",-1);
	static int count = -1;
	static bool pSkip = false;
	if(lookId == -1)return(true);

	count = kbUnitGetNumberTargeters(lookId) + kbUnitGetNumberWorkersIfSeeable(lookId); // + kbUnitGetNumberWorkers(lookId)
	if (count != 0 ) debugRule("bool checkResourceAssignment - count " + count, 1);
	if (count == 0 ) 
	{
		/*
		pSkip = false;
		for(i = 0; < 200)
		{
			if(xsArrayGetInt(gOrphanBuildingWagonCheckArray,i) == lookId)
			{
				pSkip = true;
				if(kbUnitGetCurrentHitpoints(lookId) != 0)
				{
					if(kbUnitGetCurrentHitpoints(lookId) == xsArrayGetFloat(gOrphanBuildingWagonHealthArray,i)) 
					{
						//xsArraySetInt(gOrphanBuildingWagonCheckArray,i,-1);
						//xsArraySetInt(gOrphanBuildingWagonHealthArray,i,-1);
						return(false);
					}
					else
					{
						//xsArraySetInt(gOrphanBuildingWagonCheckArray,i,-1);
						//xsArraySetInt(gOrphanBuildingWagonHealthArray,i,-1);
						return(true);
					}
				}
				return(true);
			}

			if(xsArrayGetInt(gOrphanBuildingWagonCheckArray,i) == -1 && pSkip == false)
			{
				xsArraySetInt(gOrphanBuildingWagonCheckArray,i,lookId);
				xsArraySetInt(gOrphanBuildingWagonHealthArray,i,kbUnitGetCurrentHitpoints(lookId));
				return(true);
			}
		}
		*/
		


		return(false);
	} 
	if (count >= numberAssigned) return(true);
	return(false);
} //end checkResourceAssignment


//==============================================================================
/*
 countResourceAssignment
 updatedOn 2022/04/23
 Counts settlers on or have been assigned to a resource.
 kbUnitGetNumberWorkersIfSeeable counts settlers at a resource
 kbUnitGetNumberTargeters counts settlers that have been assigned to a resource but not at the resource
 
 How to use
 call countResourceAssignment and pass a the queryId and queryNum

 Example
 int number = countResourceAssignment(queryId, kbUnitQueryExecute(queryId)); 
*/
//==============================================================================
int countResourceAssignment(int queryId = 0, int queryNum = 0)
{
	debugRule("int countResourceAssignment ",-1);
	static int numOfSettlers = -1; //holds the count of settlers assigned to a resource
	static int unitID = 0; //holds the settler id
	numOfSettlers = 0; //reset
	for (i = 0; < queryNum)
	{ //loop through the units
		unitID = kbUnitQueryGetResult(queryId, i); //holds the resourceID
		if(kbUnitGetCurrentInventory(unitID) == -1) continue; //When query has state set to cUnitStateAny to include dead resources with food left in it, it will also include dead resources with no food left, skip no food 
		numOfSettlers = numOfSettlers + kbUnitGetNumberWorkersIfSeeable(unitID); //counts settlers that are on and at a resource
		numOfSettlers = numOfSettlers + kbUnitGetNumberTargeters( kbUnitQueryGetResult ( queryId, i ) ); //counts settlers that are have been assigned to a resource but are not at the resource yet
	} //end for
	debugRule("int countResourceAssignment - for (i  " + i, 1);
	debugRule("int countResourceAssignment - numOfSettlers " + numOfSettlers, 1);
	return (numOfSettlers);
} //end countResourceAssignment

int checkPlanIsActive(int planId = -1)
{
	if(planId == -1) return(-1);
	else if(aiPlanGetActive(planId) == false) 
	{
		aiPlanDestroy(planId);
		return(-1);
	}
	return(planId);
}

bool resourceEnemyCheck(int resourceId = -1)
{
	int maxDist = -1;
	
	
	for (i = 1; < cNumberPlayers)
	{
		if (cMyID != i)
		{
			maxDist = 80;
			if(kbIsPlayerAlly(i) == true )maxDist = 25;
				
			if ( distance( kbUnitGetPosition(resourceId), kbBaseGetLocation(i, kbBaseGetMainID(i)) ) < maxDist )
			{
				return(true);
			}
		}
	} //end for i
	
	return(false);
}

//==============================================================================
/*
 checkBuildingPlan
 updatedOn 2022/09/29
 returns the id of a building plan
 
 How to use
 call checkBuildingPlan and pass a unitType and it will return the building plan id

 Example
 int planID = checkBuildingPlan(cUnitTypeBank);
 
 NOTE: if there is no plan it will return -1;
*/
//==============================================================================
int checkBuildingPlan(int pUnitType = -1)
{	
	return (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, pUnitType,true));
}

//==============================================================================
/*
 checkBuildingLimit
 updatedOn 2022/09/29
 checks if at build limit
 
 How to use
 call checkBuildingLimit and pass a unitType and it will return true if at or over build limit

 Example
 bool atBuildLimit = checkBuildingLimit(cUnitTypeBank);
*/
//==============================================================================
bool checkBuildingLimit(int pUnitType = -1)
{	

	if(kbGetBuildLimit(cMyID, pUnitType) != -1 && kbUnitCount(cMyID, pUnitType, cUnitStateABQ) >= kbGetBuildLimit(cMyID, pUnitType)) return(true);
	return(false);
}

	


//==============================================================================
/*
 closestNumber
 updatedOn 2022/08/10
 function to find the number closest to n  and divisible by m
 
 How to use
 call closestNumber and pass the n and m value

 Example
 int number = closestNumber(13,4);
 returns 12
*/
//==============================================================================
/*
int closestNumber(int n = -1, int m = -1)
{
    int q = n / m; // find the quotient
    int n1 = m * q; // 1st possible closest number 
	int n2 = -1; // 2nd possible closest number
	if((n * m) > 0)
	{
		n2 = (m * (q + 1));
	}
    else 
	{
        n2 = (m * (q - 1));
	}
	if (xsAbs(n - n1) < xsAbs(n - n2)) return (n1);  // if true, then n1 is the required closest number
    return (n2); // else n2 is the required closest number
} //end closestNumber
*/

/*
// A* algorithm function
// Calculate the heuristic distance between two nodes

// Define a constant for the grid size (assuming a square grid)
const int GRID_SIZE = 10;

// Define area types
const int unknown = -1;              // land
const int cAreaTypeForest = 1;       // no effect
const int cAreaTypeWater = 2;
const int cAreaTypeImpassableLand = 3;// cliffs
const int unknown_mines = 4;         // mines
const int cAreaTypeVPSite = 5;       // trading route posts
const int unknown_starting_TC = 6;   // starting TC's

// Define a function to calculate the Manhattan distance heuristic between two nodes
int calculateHeuristic(int current_x = -1, int current_y = -1, int goal_x = -1, int goal_y = -1)
{
    return (xsAbs(current_x - goal_x) + xsAbs(current_y - goal_y));
}

// Define the A* pathfinding function
void findPath(int start_x, int start_y, int goal_x, int goal_y, int &out path_x, int &out path_y, int &out path_length)
{
    // Pseudo-arrays to hold the open and closed lists of nodes
    int open_list[GRID_SIZE * GRID_SIZE];
    int closed_list[GRID_SIZE * GRID_SIZE];

    // Initialize the lists and set their sizes to 0
    int open_list_size = 0;
    int closed_list_size = 0;

    // Create a 1D array to hold the parent of each node
    int parent[GRID_SIZE * GRID_SIZE];
    for (int i = 0; i < GRID_SIZE * GRID_SIZE; i++)
    {
        parent[i] = -1; // Set all elements to -1 (indicating no parent)
    }

    // Array to hold the G cost of each node (initialized to a large value)
    int g_cost[GRID_SIZE * GRID_SIZE];
    for (int i = 0; i < GRID_SIZE * GRID_SIZE; i++)
    {
        g_cost[i] = 999999; // Set all elements to a large value
    }

    // Set the G cost of the starting node to 0
    int start_index = start_x * GRID_SIZE + start_y;
    g_cost[start_index] = 0;

    // Add the starting node to the open list
    open_list[open_list_size++] = start_index;

    // A* algorithm
    while (open_list_size > 0)
    {
        // Find the node with the lowest F cost in the open list
        int current_index = 0;
        int current_f = g_cost[open_list[0]] + calculateHeuristic(open_list[0] / GRID_SIZE, open_list[0] % GRID_SIZE, goal_x, goal_y);
        for (int i = 1; i < open_list_size; i++)
        {
            int node_x = open_list[i] / GRID_SIZE;
            int node_y = open_list[i] % GRID_SIZE;
            int node_f = g_cost[open_list[i]] + calculateHeuristic(node_x, node_y, goal_x, goal_y);
            if (node_f < current_f)
            {
                current_index = i;
                current_f = node_f;
            }
        }

        // Get the current node from the open list and remove it from the list
        int current_node = open_list[current_index];
        open_list[current_index] = open_list[--open_list_size];

        int current_x = current_node / GRID_SIZE;
        int current_y = current_node % GRID_SIZE;

        // Check if we have reached the goal
        if (current_x == goal_x && current_y == goal_y)
        {
            // Reconstruct the path from the goal to the start by following the parent pointers
            int path[GRID_SIZE * GRID_SIZE];
            int path_size = 0;
            int current = current_node;
            while (current != -1)
            {
                path[path_size++] = current;
                current = parent[current];
            }

            // Reverse the path array to get the correct order from start to goal
            path_length = path_size;
            for (int i = 0; i < path_size; i++)
            {
                path_x[i] = path[path_size - i - 1] / GRID_SIZE;
                path_y[i] = path[path_size - i - 1] % GRID_SIZE;
            }
            return;
        }

        // Move the current node from the open list to the closed list
        closed_list[closed_list_size++] = current_node;

        // Get neighbors of the current node
        int neighbors[][2] = {
            { current_x + 1, current_y },
            { current_x - 1, current_y },
            { current_x, current_y + 1 },
            { current_x, current_y - 1 }
        };

        for (int i = 0; i < 4; i++)
        {
            int neighbor_x = neighbors[i][0];
            int neighbor_y = neighbors[i][1];

            if (neighbor_x >= 0 && neighbor_x < GRID_SIZE && neighbor_y >= 0 && neighbor_y < GRID_SIZE)
            {
                // Check if the neighbor is passable (not an impassable area)
                int area_type = kbAreaGetType(neighbor_x, neighbor_y);
                if (area_type == unknown || area_type == cAreaTypeForest || area_type == cAreaTypeWater ||
                    area_type == unknown_mines || area_type == cAreaTypeVPSite || area_type == unknown_starting_TC)
                {
                    // Calculate the G cost for the neighbor
                    int neighbor_g = g_cost[current_node] + 1;

                    // Check if the neighbor is already in the closed list and has a lower G cost
                    int neighbor_index = neighbor_x * GRID_SIZE + neighbor_y;
                    int in_closed_list = 0;
                    for (int j = 0; j < closed_list_size; j++)
                    {
                        if (closed_list[j] == neighbor_index)
                        {
                            in_closed_list = 1;
                            break;
                        }
                    }

                    // Check if the neighbor is already in the open list and has a lower G cost
                    int in_open_list = 0;
                    if (!in_closed_list)
                    {
                        for (int j = 0; j < open_list_size; j++)
                        {
                            if (open_list[j] == neighbor_index)
                            {
                                in_open_list = 1;
                                break;
                            }
                        }
                    }

                    // If the neighbor is not in the open list or has a lower G cost, update its G cost and add it to the open list
                    if ((!in_closed_list && !in_open_list) || (in_open_list && neighbor_g < g_cost[neighbor_index]))
                    {
                        g_cost[neighbor_index] = neighbor_g;
                        parent[neighbor_index] = current_node;

                        if (!in_open_list)
                        {
                            open_list[open_list_size++] = neighbor_index;
                        }
                    }
                }
            }
        }
    }

    // If the open list is empty and we haven't found the goal, no path is available
    path_length = 0;
}
*/
/*
// Example usage
void main()
{
    // Example grid with area types
    int area_grid[GRID_SIZE][GRID_SIZE] = {
        { -1, -1, cAreaTypeImpassableLand, -1, -1, -1, -1, -1, -1, -1 },
        { -1, -1, cAreaTypeImpassableLand, -1, cAreaTypeImpassableLand, -1, -1, -1, -1, -1 },
        { -1, -1, cAreaTypeImpassableLand, -1, cAreaTypeImpassableLand, -1, -1, -1, -1, -1 },
        { -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 },
        { -1, -1, -1, -1, cAreaTypeImpassableLand, cAreaTypeImpassableLand, cAreaTypeImpassableLand, -1, -1, -1 },
        { -1, -1, -1, -1, cAreaTypeImpassableLand, -1, -1, -1, -1, -1 },
        { -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 },
        { -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 },
        { -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 },
        { -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 }
    };

    // Find path from (0, 0) to (9, 9) using the A* algorithm
    int start_x = 0;
    int start_y = 0;
    int goal_x = 9;
    int goal_y = 9;
    int path_x[GRID_SIZE * GRID_SIZE];
    int path_y[GRID_SIZE * GRID_SIZE];
    int path_length;

    findPath(start_x, start_y, goal_x, goal_y, path_x, path_y, path_length);
    
    // Output the path
    if (path_length > 0)
    {
        for (int i = 0; i < path_length; i++)
        {
            xsEcho("xsArraySetInt(myArray, " + i + ", " + path_x[i] + "); xsArraySetInt(myArray, " + (i + 1) + ", " + path_y[i] + "); ");
            i++;
        }
    }
    else
    {
        xsEcho("No path found.");
    }
}
*/


void toolsMain()
{
	
}