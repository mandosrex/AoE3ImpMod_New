//Create methods

//==============================================================================
/* createOpportunity(type, targetType, targetID, targetPlayerID, source)
	
	A wrapper function for aiCreateOpportunity(), to permit centralized tracking
	of the most recently created ally-generated and trigger-generated 
	opportunities.  This info is needed so that a cancel command can
	efficiently deactivate the previous (and possibly current) opportunity before
	creating the new one.
*/
//==============================================================================
int createOpportunity(int type = -1, int targetType = -1, int targetID = -1, int targetPlayerID = -1, int source = -1)
{
	int oppID = aiCreateOpportunity(type, targetType, targetID, targetPlayerID, source);
	if (source == cOpportunitySourceAllyRequest)
		gMostRecentAllyOpportunityID = oppID; // Remember which ally opp we're doing
	else if (source == cOpportunitySourceTrigger)
		gMostRecentTriggerOpportunityID = oppID;
	return (oppID);
}

//==============================================================================
// createSimpleAttackGoal
//==============================================================================
int createSimpleAttackGoal(string name = "BUG", int attackPlayerID = -1, int unitPickerID = -1, int repeat = -1, int minAge = -1, int maxAge = -1, int baseID = -1, bool allowRetreat = false)
{

	if (aiTreatyActive() == true) return (-1);
	//aiEcho("CreateSimpleAttackGoal:  Name="+name+", AttackPlayerID="+attackPlayerID+".");
	//aiEcho("  UnitPickerID="+unitPickerID+", Repeat="+repeat+", baseID="+baseID+".");
	//aiEcho("  MinAge="+minAge+", maxAge="+maxAge+", allowRetreat="+allowRetreat+".");
	//Create the goal.
	int goalID = aiPlanCreate(name, cPlanGoal);
	if (goalID < 0)
		return (-1);

	//Priority.
	aiPlanSetDesiredPriority(goalID, 90);
	//Attack player ID.
	if (attackPlayerID >= 0)
		aiPlanSetVariableInt(goalID, cGoalPlanAttackPlayerID, 0, attackPlayerID);
	else
		aiPlanSetVariableBool(goalID, cGoalPlanAutoUpdateAttackPlayerID, 0, true);
	//Base.
	if (baseID >= 0)
		aiPlanSetBaseID(goalID, baseID);
	else
		aiPlanSetVariableBool(goalID, cGoalPlanAutoUpdateBase, 0, true);
	//Attack.
	aiPlanSetAttack(goalID, true);
	aiPlanSetVariableInt(goalID, cGoalPlanGoalType, 0, cGoalPlanGoalTypeAttack);
	aiPlanSetVariableInt(goalID, cGoalPlanAttackStartFrequency, 0, 1);

	//Military.
	aiPlanSetMilitary(goalID, true);
	aiPlanSetEscrowID(goalID, cMilitaryEscrowID);
	//Ages.
	aiPlanSetVariableInt(goalID, cGoalPlanMinAge, 0, minAge);
	aiPlanSetVariableInt(goalID, cGoalPlanMaxAge, 0, maxAge);
	//Repeat.
	aiPlanSetVariableInt(goalID, cGoalPlanRepeat, 0, repeat);
	//Unit Picker.
	aiPlanSetVariableInt(goalID, cGoalPlanUnitPickerID, 0, unitPickerID);
	//Retreat.
	aiPlanSetVariableBool(goalID, cGoalPlanAllowRetreat, 0, allowRetreat);
	aiPlanSetVariableBool(goalID, cGoalPlanSetAreaGroups, 0, true);
	aiPlanSetVariableInt(goalID, cGoalPlanAttackRoutePatternType, 0, cAttackPlanAttackRoutePatternRandom);

	//Done.
	return (goalID);
}
//==============================================================================
// createSimpleResearchPlan
// updatedOn 2020/11/13 By ageekhere
//==============================================================================
int createSimpleResearchPlan(int techID = -1, int buildingID = -1, int escrowID = cRootEscrowID, int pri = 50)
{ //creates a research plan
	if (techID == -1) return (-1);
	debugRule("int createSimpleResearchPlan ",-1);
	
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 2000,"createSimpleResearchPlan") == false) return;
	lastRunTime = gCurrentGameTime;
	
	if(gCurrentWood < kbTechCostPerResource(techID, cResourceWood)) return(-1);
	if(gCurrentFood < kbTechCostPerResource(techID, cResourceFood)) return(-1);
	if(gCurrentCoin < kbTechCostPerResource(techID, cResourceGold)) return(-1);
	
	if(aiPlanGetNumber(cPlanResearch, -1, false) > 2)return(-1);

	
	//if (outOfOpening == true) return(-1);
	if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID) != -1) return (-1); //check if tech is already being researched
	if (kbTechGetStatus(techID) == cTechStatusActive || kbTechGetStatus(techID) != cTechStatusObtainable) return (-1); // Check if tech is obtainable
	int planID = aiPlanCreate("Research " + kbGetTechName(techID), cPlanResearch);
	aiPlanSetVariableInt(planID, cResearchPlanTechID, 0, techID);
	aiPlanSetVariableInt(planID, cResearchPlanBuildingID, 0, buildingID);
	aiPlanSetDesiredPriority(planID, pri);
	aiPlanSetEscrowID(planID, escrowID);
	aiPlanSetActive(planID);
	return (planID);
} //end createSimpleResearchPlan

//==============================================================================
// createSimpleMaintainPlan
// updatedOn 2020/11/15 By ageekhere
//==============================================================================
int createSimpleMaintainPlan(int puid = -1, int number = 1, bool economy = true, int baseID = -1, int batchSize = 1, int planIDsend = -1)
{ //Create a the plan name.
	if (puid == -1) return (-1);
	int planID = -1;

	debugRule("int createSimpleMaintainPlan",-1);
	//if (outOfOpening == true) return(-1);
	string planName = "Military";
	if (economy == true) planName = "Economy";

	planName = planName + kbGetProtoUnitName(puid) + "Maintain";
	planID = aiPlanCreate(planName, cPlanTrain);

	if (economy == true) aiPlanSetEconomy(planID, true); //Economy or Military.
	else aiPlanSetMilitary(planID, true);

	aiPlanSetVariableInt(planID, cTrainPlanUnitType, 0, puid); //Unit type.
	aiPlanSetVariableInt(planID, cTrainPlanNumberToMaintain, 0, number); //Number.
	aiPlanSetVariableInt(planID, cTrainPlanBatchSize, 0, batchSize); // Batch size
	aiPlanSetVariableInt(planID, cTrainPlanFrequency, 0, 5); // Frequency
	aiPlanSetVariableInt(planID, cTrainPlanMaxQueueSize, 0, 5); // MaxQueueSize
	aiPlanSetVariableInt(planID, cTrainPlanUseMultipleBuildings, 0, true); // Batch size
	//aiPlanSetDesiredPriority(planID, 100);
	
	if (baseID >= 0)
	{ //If we have a base ID, use it.
		aiPlanSetBaseID(planID, baseID);
		//if (economy == false) aiPlanSetVariableVector(planID, cTrainPlanGatherPoint, 0, kbBaseGetMilitaryGatherPoint(cMyID, baseID));
		if (economy == false) aiPlanSetVariableVector(planID, cTrainPlanGatherPoint, 0, gForwardBaseLocation);
	}
	//   aiPlanSetVariableBool(planID, cTrainPlanUseHomeCityShipments, 0, true);
	aiPlanSetActive(planID);
	return (planID);
}

int createSimpleTrainPlan(int puid = -1, int number = 1, bool economy = true, int baseID = -1, int batchSize = 1, int planIDsend = -1)
{ //Create a the plan name.
	if (puid == -1) return (-1);
	
	if(aiPlanGetIDByTypeAndVariableType(cPlanTrain, cTrainPlanTrainedUnitID, puid,true) > 0)return(-1);
	int planID = -1;

	debugRule("int createSimpleMaintainPlan",-1);
	//if (outOfOpening == true) return(-1);
	string planName = "Military train";
	if (economy == true) planName = "Economy";

	planName = planName + kbGetProtoUnitName(puid) + "Tain";
	planID = aiPlanCreate(planName, cPlanTrain);

	if (economy == true) aiPlanSetEconomy(planID, true); //Economy or Military.
	else aiPlanSetMilitary(planID, true);

	aiPlanSetVariableInt(planID, cTrainPlanUnitType, 0, puid); //Unit type.
	aiPlanSetVariableInt(planID, cTrainPlanNumberToTrain, 0, number); //Number.
	aiPlanSetVariableInt(planID, cTrainPlanBatchSize, 0, batchSize); // Batch size
	aiPlanSetVariableInt(planID, cTrainPlanMaxQueueSize, 0, 100); // MaxQueueSize
	aiPlanSetVariableInt(planID, cTrainPlanUseMultipleBuildings, 0, true); // Batch size
	//aiPlanSetDesiredPriority(planID, 100);
	
	if (baseID >= 0)
	{ //If we have a base ID, use it.
		aiPlanSetBaseID(planID, baseID);
		//if (economy == false) aiPlanSetVariableVector(planID, cTrainPlanGatherPoint, 0, kbBaseGetMilitaryGatherPoint(cMyID, baseID));
		if (economy == false) aiPlanSetVariableVector(planID, cTrainPlanGatherPoint, 0, gForwardBaseLocation);
	}
	//   aiPlanSetVariableBool(planID, cTrainPlanUseHomeCityShipments, 0, true);
	aiPlanSetActive(planID);
	return (planID);
}

//==============================================================================
// createSimpleBuildPlan
// updatedOn 2020/11/27 By ageekhere
//==============================================================================
int createSimpleBuildPlan(int puid = -1, int number = 1, int pri = 100, bool economy = true, int escrowID = -1, int baseID = -1, int numberBuilders = 1)
{ //will create a build plan in the given base, Note: Can have an issue with running out of space to place a building 
	//if(gCurrentGameTime > 300000)return(-1);
	
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 2000,"createSimpleBuildPlan") == false) return;
	lastRunTime = gCurrentGameTime;

	if(gCurrentWood < kbUnitCostPerResource(puid, cResourceWood)) return(-1);
	if(gCurrentFood < kbUnitCostPerResource(puid, cResourceFood)) return(-1);
	if(gCurrentCoin < kbUnitCostPerResource(puid, cResourceGold)) return(-1);

	if(aiPlanGetNumber(cPlanBuild, -1, false) > 2)return(-1);
	if( aiPlanGetNumber(cPlanBuild, -1, true) > 3)return(-1);
	
	if (puid == -1) return (-1);
	debugRule("int createSimpleBuildPlan ",-1);
	if (cvOkToBuild == false) return (-1);
	if(getUnit(gTownCenter, cMyID, cUnitStateABQ) == -1 && puid != gTownCenter) return (-1);
	//if (outOfOpening == false) return(-1);

	if (checkBuildingPlan(puid) != -1) return (-1); //Check if the ai already has a building of the type passed in que

	bool buildPass = true;
	if (gCurrentAge < cAge5)
	{
		if (puid == cUnitTypeBarracks ||
			puid == cUnitTypeStable ||
			puid == cUnitTypeArtilleryDepot ||
			puid == cUnitTypeBlockhouse ||
			puid == cUnitTypeWarHut ||
			puid == cUnitTypeNoblesHut ||
			puid == cUnitTypeypBarracksJapanese ||
			puid == cUnitTypeypWarAcademy ||
			puid == cUnitTypeYPBarracksIndian ||
			puid == cUnitTypeypStableJapanese ||
			puid == cUnitTypeypCaravanserai ||
			puid == cUnitTypeypCastle ||
			puid == gDockUnit ||
			puid == cUnitTypeCorral)
		{
			buildPass = true;
			if (gCurrentAge < cAge4 && (kbUnitCount(cMyID, puid, cUnitStateABQ) > 0 || kbUnitCount(cMyID, puid, cUnitStateAlive) > 0)) buildPass = false;
			if (gTownCenterNumber > 2) buildPass = true;
		}
	}

	if (buildPass == false) //&& kbResourceGet(cResourceWood) < 1500) 
	{
		return (-1);
	}

	//---------------------------

	static int builderType = -1;
	builderType = gEconUnit;
	//Create the right number of plans.
	for (i = 0; < number)
	{
		int planID = aiPlanCreate("Simple Build Plan, " + number + " " + kbGetUnitTypeName(puid), cPlanBuild);
		if (planID < 0)
			return (-1);

		// What to build
		aiPlanSetVariableInt(planID, cBuildPlanBuildingTypeID, 0, puid);

		// 3 meter separation
		aiPlanSetVariableFloat(planID, cBuildPlanBuildingBufferSpace, 0, 5.0);
		if (puid == gFarmUnit) aiPlanSetVariableFloat(planID, cBuildPlanBuildingBufferSpace, 0, 8.0);
		//if (puid == gHouseUnit) aiPlanSetVariableFloat(planID, cBuildPlanBuildingBufferSpace, 0, 3.0);  	

		//Priority.
		aiPlanSetDesiredPriority(planID, pri);
		//Mil vs. Econ.
		if (economy == true)
			aiPlanSetMilitary(planID, false);
		else
			aiPlanSetMilitary(planID, true);
		aiPlanSetEconomy(planID, economy);
		//Escrow.
		aiPlanSetEscrowID(planID, escrowID);
		//Builders.
		if (getCivIsAsian() == true)
		{
			if (puid == gFarmUnit)
			{
				if (kbUnitCount(cMyID, cUnitTypeYPRicePaddyWagon, cUnitStateAlive) > 0)
					builderType = cUnitTypeYPRicePaddyWagon;
			}
			if (puid == gMarketUnit)
			{
				if (kbUnitCount(cMyID, cUnitTypeypMarketWagon, cUnitStateAlive) > 0)
					builderType = cUnitTypeypMarketWagon;
			}
			if (puid == cUnitTypeypShrineJapanese)
			{
				if (kbUnitCount(cMyID, cUnitTypeypShrineWagon, cUnitStateAlive) > 0)
					builderType = cUnitTypeypShrineWagon;
			}
			if (puid == cUnitTypeypMonastery)
			{
				if (kbUnitCount(cMyID, cUnitTypeYPMonasteryWagon, cUnitStateAlive) > 0)
					builderType = cUnitTypeYPMonasteryWagon;
			}
			if (puid == cUnitTypeypBerryBuilding)
			{
				builderType = cUnitTypeYPBerryWagon1;
			}
			if (puid == gTradingPostUnit)
			{
				if (kbUnitCount(cMyID, cUnitTypeypTradingPostWagon, cUnitStateAlive) > 0)
					builderType = cUnitTypeypTradingPostWagon;
			}
			if (puid == cUnitTypeypBarracksJapanese)
			{
				if (kbUnitCount(cMyID, cUnitTypeYPMilitaryRickshaw, cUnitStateAlive) > 0)
					builderType = cUnitTypeYPMilitaryRickshaw;
			}
			if (puid == cUnitTypeypStableJapanese)
			{
				if (kbUnitCount(cMyID, cUnitTypeYPMilitaryRickshaw, cUnitStateAlive) > 0)
					builderType = cUnitTypeYPMilitaryRickshaw;
			}
			if (puid == cUnitTypeypDojo)
			{
				if (kbUnitCount(cMyID, cUnitTypeYPDojoWagon, cUnitStateAlive) > 0)
					builderType = cUnitTypeYPDojoWagon;
			}
			if (puid == cUnitTypeypTradeMarketAsian)
			{
				if (kbUnitCount(cMyID, cUnitTypeypMarketWagon, cUnitStateAlive) > 0)
					builderType = cUnitTypeypMarketWagon;
			}
			if (puid == cUnitTypeypSacredField)
			{
				if (kbUnitCount(cMyID, cUnitTypeYPSacredFieldWagon, cUnitStateAlive) > 0)
					builderType = cUnitTypeYPSacredFieldWagon;
			}
		}
		if (puid == gDockUnit)
		{
			if (kbUnitCount(cMyID, cUnitTypeYPDockWagon, cUnitStateAlive) > 0)
				builderType = cUnitTypeYPDockWagon;
		}
		// Dutch can use bank wagon
		/*
			if ((kbGetCiv() == cCivDutch) && (puid == cUnitTypeBank))
			{
			if (kbUnitCount(cMyID, cUnitTypeBankWagon, cUnitStateAlive) > 0)
			builderType = cUnitTypeBankWagon;
			}
		*/
		// Explorers, war chiefs and monks build town centers
		if (puid == gTownCenter)
		{
			//updatedOn 2020/03/09 By ageekhere  
			//---------------------------
			int wantVill = gCurrentAliveSettlers;
			if (gTownCenterNumber < 1 && kbUnitCount(cMyID, cUnitTypeSettlerWagon, cUnitStateABQ) == 0)
			{
				wantVill = getUnit(gEconUnit, cMyID, cUnitStateAlive);
			}
			if (wantVill < 2)
			{
				switch (kbGetCiv())
				{
					case cCivXPAztec:
						{
							aiPlanAddUnitType(planID, cUnitTypexpAztecWarchief, wantVill, wantVill, wantVill);
							break;
						}
					case cCivXPIroquois:
						{
							aiPlanAddUnitType(planID, cUnitTypexpIroquoisWarChief, wantVill, wantVill, wantVill);
							break;
						}
					case cCivXPSioux:
						{
							aiPlanAddUnitType(planID, cUnitTypexpLakotaWarchief, wantVill, wantVill, wantVill);
							break;
						}
					case cCivChinese:
						{
							aiPlanAddUnitType(planID, cUnitTypeypMonkChinese, wantVill, wantVill, wantVill);
							break;
						}
					case cCivIndians:
						{
							aiPlanAddUnitType(planID, cUnitTypeypMonkIndian, wantVill, wantVill, wantVill);
							aiPlanAddUnitType(planID, cUnitTypeypMonkIndian2, wantVill, wantVill, wantVill);
							break;
						}
					case cCivJapanese:
						{
							aiPlanAddUnitType(planID, cUnitTypeypMonkJapanese, wantVill, wantVill, wantVill);
							aiPlanAddUnitType(planID, cUnitTypeypMonkJapanese2, wantVill, wantVill, wantVill);
							break;
						}
					default:
						{
							aiPlanAddUnitType(planID, gExplorerUnit, wantVill, wantVill, wantVill);
							break;
						}

				}
			}
			else
			{
				aiPlanAddUnitType(planID, builderType, numberBuilders, numberBuilders, numberBuilders);
			}
			//---------------------------
		}
		if (puid == cUnitTypeFactory)
		{
			aiPlanAddUnitType(planID, cUnitTypeFactoryWagon, 1, 1, 1);
		}
		else
		{
			// Germans use settler wagons if there are no settlers or builder wagons available
			int settlerCount = -1;
			if ((kbGetCiv() == cCivGermans) && (gCurrentAliveSettlers < 1) && (builderType == gEconUnit))
			{
				aiPlanAddUnitType(planID, cUnitTypeSettlerWagon, numberBuilders, numberBuilders, numberBuilders);
			}
			else
			{
				aiPlanAddUnitType(planID, builderType, numberBuilders, numberBuilders, numberBuilders);
			}
		}
		//Base ID.
		aiPlanSetBaseID(planID, baseID);


		aiPlanSetNumberVariableValues(planID, cBuildPlanInfluenceUnitTypeID, 2, true);
		aiPlanSetNumberVariableValues(planID, cBuildPlanInfluenceUnitDistance, 2, true);
		aiPlanSetNumberVariableValues(planID, cBuildPlanInfluenceUnitValue, 2, true);
		aiPlanSetNumberVariableValues(planID, cBuildPlanInfluenceUnitFalloff, 2, true);

		aiPlanSetVariableInt(planID, cBuildPlanInfluenceUnitTypeID, 0, cUnitTypeHomeCityWaterSpawnFlag);
		aiPlanSetVariableFloat(planID, cBuildPlanInfluenceUnitDistance, 0, 50);
		aiPlanSetVariableFloat(planID, cBuildPlanInfluenceUnitValue, 0, -500);
		aiPlanSetVariableInt(planID, cBuildPlanInfluenceUnitFalloff, 0, cBPIFalloffLinearInverse);

		if (kbGetCiv() != cCivXPSioux)
		{
			aiPlanSetVariableInt(planID, cBuildPlanInfluenceUnitTypeID, 1, gTownCenter);
			aiPlanSetVariableFloat(planID, cBuildPlanInfluenceUnitDistance, 1, 30);
			aiPlanSetVariableFloat(planID, cBuildPlanInfluenceUnitValue, 1, -500);
			aiPlanSetVariableInt(planID, cBuildPlanInfluenceUnitFalloff, 1, cBPIFalloffLinearInverse);
		}
		//Go.
		aiPlanSetActive(planID);
	}
	gBuildPlanSettlerOveride = false;
	return (planID); // Only really useful if number == 1, otherwise returns last value.
}
//==============================================================================
//createLocationBuildPlan
//==============================================================================
int createLocationBuildPlan(int puid = -1, int number = 1, int pri = 100, bool economy = true, int escrowID = -1, vector position = cInvalidVector, int numberBuilders = 1, int pWagonBuild = -1)
{
	//if(gCurrentGameTime > 300000)return(-1);
	debugRule("createLocationBuildPlan " + puid + " pWagonBuild " + pWagonBuild,2);

	if(cvOkToBuild == false || puid == -1) return (-1);
	debugRule("createLocationBuildPlan " + puid + "pass 1",2);
	if(getUnit(gTownCenter, cMyID, cUnitStateABQ) == -1 && puid != gTownCenter) return (-1);
	debugRule("createLocationBuildPlan " + puid + "pass 2",2);
	if(checkBuildingPlan(puid) != -1 && gBuildPlanSettlerOveride == false && pWagonBuild == -1) return (-1);
	//aiLog("lb pass3 ");
	debugRule("createLocationBuildPlan " + puid + "pass 3",2);

	//static int lastRunTime = 0;
	//if(functionDelay(lastRunTime, 2000,"createLocationBuildPlan") == false) return;
	//lastRunTime = gCurrentGameTime;
	
	//aiLog("lb pass4 ");
	bool usingWagon = false;
	
	if(position == gMainBaseLocation && puid != gHouseUnit)
	{
		position = gFrontBaseLocation; 
	}
	
	for (i = 0; < number)
	{
		int planID = aiPlanCreate("Location Build Plan, " + number + " " + kbGetUnitTypeName(puid), cPlanBuild);
		//if (planID < 0) return (-1);
		// What to build
		aiPlanSetVariableInt(planID, cBuildPlanBuildingTypeID, 0, puid);
		aiPlanSetVariableVector(planID, cBuildPlanCenterPosition, 0, position);
		aiPlanSetVariableFloat(planID, cBuildPlanCenterPositionDistance, 0, 300.0);//300

		// 3 meter separation
		aiPlanSetVariableFloat(planID, cBuildPlanBuildingBufferSpace, 0, 3.0);
		if (puid == gFarmUnit)
			aiPlanSetVariableFloat(planID, cBuildPlanBuildingBufferSpace, 0, 1.0);

		//Priority.
		aiPlanSetDesiredPriority(planID, pri);
		//Mil vs. Econ.
		if (economy == true)
			aiPlanSetMilitary(planID, false);
		else
			aiPlanSetMilitary(planID, true);
		aiPlanSetEconomy(planID, economy);
		//Escrow.
		aiPlanSetEscrowID(planID, escrowID);
		//Builders.


		if (puid == cUnitTypeMineGoldUS)
		{
			aiPlanAddUnitType(planID, cUnitTypeGoldMiner, 1, 5, 5);
		}
		else if(pWagonBuild != -1)
		{
			debugRule("createLocationBuildPlan unit type wagon",2);
			aiPlanAddUnitType(planID, cUnitTypeAbstractWagon, 1, 1, 1);
			aiPlanAddUnit(planID,pWagonBuild);
		}
		/*
		else if (puid == cUnitTypeFactory)
		{
			aiPlanAddUnitType(planID, cUnitTypeFactoryWagon, 1, 1, 1);
			usingWagon = true;
		}
		else if (puid == cUnitTypeFortFrontier)
		{
			if(gNationalRedoubtEnabled == true && kbUnitCount(cMyID, cUnitTypeFortWagon, cUnitStateAlive) == 0) 
			{
				aiPlanAddUnitType(planID, cUnitTypeStrelet, 1, 10, 20);
			}
			else
			{
				aiPlanAddUnitType(planID, cUnitTypeFortWagon, 1, 1, 1);
				usingWagon = true;
			}
		}
		else if (puid == gTowerUnit && kbUnitCount(cMyID, cUnitTypeOutpostWagon, cUnitStateAlive) > 0)
		{
			aiPlanAddUnitType(planID, cUnitTypeOutpostWagon, 1, 1, 1);
			usingWagon = true;
		}
		else if (puid == cUnitTypeBank && kbUnitCount(cMyID, cUnitTypeBankWagon, cUnitStateAlive) > 0)
		{
			aiPlanAddUnitType(planID, cUnitTypeBankWagon, 1, 1, 1);
			usingWagon = true;
		}
		else if (puid == cUnitTypeypBankAsian && kbUnitCount(cMyID, cUnitTypeypBankWagon, cUnitStateAlive) > 0)
		{
			aiPlanAddUnitType(planID, cUnitTypeypBankWagon, 1, 1, 1);
			usingWagon = true;
		}
		else if (puid == gTownCenter && kbUnitCount(cMyID, gCoveredWagonUnit, cUnitStateAlive) > 0)
		{
			aiPlanAddUnitType(planID, gCoveredWagonUnit, 1, 1, 1);
			usingWagon = true;
		}
		
		
		else if(kbUnitCount(cMyID, cUnitTypexpBuilderWar, cUnitStateAlive) > 0)
		{
			if(puid == gDockUnit || puid == gTowerUnit || puid == gBarracksUnit || puid == gStableUnit || puid == gArtilleryDepotUnit)
			{
				aiPlanAddUnitType(planID, cUnitTypexpBuilderWar, 1, 1, 1);
				usingWagon = true;
			}
		}
		else if (puid == cUnitTypeypDojo)
		{
			if (kbUnitCount(cMyID, cUnitTypeYPDojoWagon, cUnitStateAlive) > 0) 
			{
				aiPlanAddUnitType(planID, cUnitTypeYPDojoWagon, 1, 1, 1);
				usingWagon = true;
			}
		}
		
		else if (puid == cUnitTypeypBarracksJapanese)
		{
			if (kbUnitCount(cMyID, cUnitTypeYPMilitaryRickshaw, cUnitStateAlive) > 0)
			{
					aiPlanAddUnitType(planID, cUnitTypeYPMilitaryRickshaw, 1, 1, 1);
					usingWagon = true;
			}
		}
		
		else if (puid == cUnitTypeypStableJapanese)
		{
			if (kbUnitCount(cMyID, cUnitTypeYPMilitaryRickshaw, cUnitStateAlive) > 0)
			{
					aiPlanAddUnitType(planID, cUnitTypeYPMilitaryRickshaw, 1, 1, 1);
					usingWagon = true;
			}
		}
		*/
		/*
		else if(kbUnitCount(cMyID, cUnitTypexpBuilder, cUnitStateAlive) > 0)
		{
			if(puid == cUnitTypeEconomic)
			{
				aiPlanAddUnitType(planID, cUnitTypexpBuilder, 1, 1, 1);
			}
		}
		*/
		
		

		else if(puid == cUnitTypeBlockhouse && gBlockhouseEngineeringEnabled == true && kbUnitCount(cMyID, cUnitTypeStrelet, cUnitStateAlive) > 0)
		{
			aiPlanAddUnitType(planID, cUnitTypeStrelet, 1, 5, 20);
		}

		else if(gBuildPlanSettlerOveride == false)
		{
			int settlerCount = -1;
			if ((kbGetCiv() == cCivGermans) && (gCurrentAliveSettlers < 1))
			{
				aiPlanAddUnitType(planID, cUnitTypeSettlerWagon, numberBuilders, numberBuilders, numberBuilders);
			}

		else if(kbUnitCount(cMyID, gEconUnit, cUnitStateAlive) == 0)
		{
			aiPlanAddUnitType(planID, gExplorerUnit, 1, 1, 1);
		}	
		else
			{
				debugRule("createLocationBuildPlan unit type settler",2);
				aiPlanAddUnitType(planID, gEconUnit, numberBuilders, numberBuilders, numberBuilders);
				
			}
		}

		aiPlanSetVariableVector(planID, cBuildPlanInfluencePosition, 0, position); // Influence toward position
		aiPlanSetVariableFloat(planID, cBuildPlanInfluencePositionDistance, 0, 70.0); // 100m range.
		aiPlanSetVariableFloat(planID, cBuildPlanInfluencePositionValue, 0, 200.0); // 200 points max
		aiPlanSetVariableInt(planID, cBuildPlanInfluencePositionFalloff, 0, cBPIFalloffLinearInverse); // Linear slope falloff
		
		if (distance(position, gMainBaseLocation) < 31 && puid != gHouseUnit && kbGetCiv() != cCivXPSioux)
		{
			aiPlanSetVariableInt(planID, cBuildPlanInfluenceUnitTypeID, 0, gTownCenter);
			aiPlanSetVariableFloat(planID, cBuildPlanInfluenceUnitDistance, 0, 30); // 30m range.
			aiPlanSetVariableFloat(planID, cBuildPlanInfluenceUnitValue, 0, -500);
			aiPlanSetVariableInt(planID, cBuildPlanInfluenceUnitFalloff, 0, cBPIFalloffLinearInverse); // cBPIFalloffLinear

		}

		if (distance(position, gNavyFlagLocation) < 50 && puid != gHouseUnit)
		{
			aiPlanSetVariableInt(planID, cBuildPlanInfluenceUnitTypeID, 0, cUnitTypeHomeCityWaterSpawnFlag);
			aiPlanSetVariableFloat(planID, cBuildPlanInfluenceUnitDistance, 0, 60);
			aiPlanSetVariableFloat(planID, cBuildPlanInfluenceUnitValue, 0, -500);
			aiPlanSetVariableInt(planID, cBuildPlanInfluenceUnitFalloff, 0, cBPIFalloffLinearInverse);
		}

		aiPlanAddUserVariableInt(planID, 0, "Time Added", 1);
		aiPlanSetUserVariableInt(planID, 0, 0, gCurrentGameTime);
		aiPlanSetActive(planID);
		debugRule("createLocationBuildPlan" + puid + " active ",2);
		
	}
	gBuildPlanSettlerOveride = false;
	return (planID); // Only really useful if number == 1, otherwise returns last value.
}

//==============================================================================
// createMainBase
//==============================================================================
int createMainBase(vector mainVec = cInvalidVector)
{
	//aiEcho("Creating main base at "+mainVec);
	if (mainVec == cInvalidVector)
		return (-1);
	int oldMainID = kbBaseGetMainID(cMyID);
	int i = 0;

	int count = -1;
	static int unitQueryID = -1;
	int buildingID = -1;
	string buildingName = "";
	if (unitQueryID == -1) 
	{
		unitQueryID = kbUnitQueryCreate("NewMainBaseBuildingQuery"+ getQueryId());
		kbUnitQuerySetPlayerID(unitQueryID, cMyID,false);
		kbUnitQuerySetPlayerRelation(unitQueryID, -1);
		kbUnitQuerySetIgnoreKnockedOutUnits(unitQueryID, true);	
	}
	kbUnitQueryResetResults(unitQueryID);
	kbUnitQuerySetUnitType(unitQueryID, cUnitTypeBuilding);
	kbUnitQuerySetState(unitQueryID, cUnitStateABQ);
	kbUnitQuerySetPosition(unitQueryID, mainVec); // Checking new base vector
	kbUnitQuerySetMaximumDistance(unitQueryID, 55.0);
	count = kbUnitQueryExecute(unitQueryID);

	while (oldMainID >= 0)
	{
		//aiEcho("Old main base was "+oldMainID+" at "+kbBaseGetLocation(cMyID, oldMainID));
		kbUnitQuerySetPosition(unitQueryID, kbBaseGetLocation(cMyID, oldMainID)); // Checking old base location
		//kbUnitQueryResetResults(unitQueryID);
		count = kbUnitQueryExecute(unitQueryID);
		int unitID = -1;


		// Remove old base's resource breakdowns
		aiRemoveResourceBreakdown(cResourceFood, cAIResourceSubTypeEasy, oldMainID);
		aiRemoveResourceBreakdown(cResourceFood, cAIResourceSubTypeHunt, oldMainID);
		aiRemoveResourceBreakdown(cResourceFood, cAIResourceSubTypeHerdable, oldMainID);
		aiRemoveResourceBreakdown(cResourceFood, cAIResourceSubTypeFish, oldMainID);
		aiRemoveResourceBreakdown(cResourceFood, cAIResourceSubTypeFarm, oldMainID);
		aiRemoveResourceBreakdown(cResourceWood, cAIResourceSubTypeEasy, oldMainID);
		aiRemoveResourceBreakdown(cResourceGold, cAIResourceSubTypeEasy, oldMainID);

		kbBaseDestroy(cMyID, oldMainID);
		oldMainID = kbBaseGetMainID(cMyID);
	}


	int newBaseID = kbBaseCreate(cMyID, "Base" + kbBaseGetNextID(), mainVec, 50.0);


	//kbBaseCreate(cMyID, "Base"+kbBaseGetNextID(), gMapCenter-mainVec, 50.0);


	/*
		bool kbBaseSetFrontVector( int playerID/n int baseID/n vector frontVector ): Sets the front (and back) of the base.
		bool kbBaseSetActive( int playerID/n int baseID/n bool active ): Sets the active flag of the base.
		bool kbBaseSetMain( int playerID/n int baseID/n bool main ): Sets the main flag of the base.
		bool kbBaseSetForward( int playerID/n int baseID/n bool forward ): Sets the forward flag of the base.
		bool kbBaseSetMilitary( int playerID/n int baseID/n bool military ): Sets the military flag of the base.
		bool kbBaseSetMilitaryGatherPoint( int playerID/n int baseID/n vector gatherPoint ): Sets the military gather point of the base.
		bool kbBaseSetEconomy( int playerID/n int baseID/n bool Economy ): Sets the economy flag of the base.
		void kbBaseSetMaximumResourceDistance( int playerID/n int baseID/n float distance ): Sets the maximum resource distance of the base.
	*/

	//aiEcho("New main base ID is "+newBaseID);
	if (newBaseID > -1)
	{
		//Figure out the front vector.
		vector baseFront = xsVectorNormalize(gMapCenter - mainVec);
		kbBaseSetFrontVector(cMyID, newBaseID, baseFront);
		//aiEcho("Setting front vector to "+baseFront);
		//Military gather point.
		float milDist = 40.0;
		while (kbAreaGroupGetIDByPosition(mainVec + (baseFront * milDist)) != kbAreaGroupGetIDByPosition(mainVec))
		{
			milDist = milDist - 5.0;
			if (milDist < 6.0)
				break;
		}
		vector militaryGatherPoint = mainVec + (baseFront * milDist);

		kbBaseSetMilitaryGatherPoint(cMyID, newBaseID, militaryGatherPoint);
		//Set the other flags.
		kbBaseSetMilitary(cMyID, newBaseID, true);
		kbBaseSetEconomy(cMyID, newBaseID, true);
		//Set the resource distance limit.


		// 200m x 200m map, assume I'm 25 meters in, I'm 150m from enemy base.  This sets the range at 80m.
		//(cMyID, newBaseID, (kbGetMapXSize() + kbGetMapZSize())/5);   // 40% of average of map x and z dimensions.
		kbBaseSetMaximumResourceDistance(cMyID, newBaseID, 150.0); // 100 led to age-2 gold starvation
		kbBaseSetSettlement(cMyID, newBaseID, true);
		//Set the main-ness of the base.
		kbBaseSetMain(cMyID, newBaseID, true);

		// Add the TC, if any.

		if (getUnit(gTownCenter, cMyID, cUnitStateABQ) >= 0)
			kbBaseAddUnit(cMyID, newBaseID, getUnit(gTownCenter, cMyID, cUnitStateABQ));
	}


	// Move the defend plan and reserve plan
	xsEnableRule("endDefenseReflexDelay"); // Delay so that new base ID will exist

	//   xsEnableRule("populateMainBase");   // Can't add units yet, they still appear to be owned by deleted base.  This rule adds a slight delay.


	return (newBaseID);
}

void createTCBuildPlan(vector location = cInvalidVector)
{
	if (cvOkToBuild == false)
		return;
	//aiEcho("Creating a TC build plan.");
	// Make a town center, pri 100, econ, main base, 1 builder.
	int buildPlan = aiPlanCreate("TC Build plan ", cPlanBuild);
	// What to build
	aiPlanSetVariableInt(buildPlan, cBuildPlanBuildingTypeID, 0, gTownCenter);
	// Priority.
	aiPlanSetDesiredPriority(buildPlan, 100);
	// Mil vs. Econ.
	aiPlanSetMilitary(buildPlan, false);
	aiPlanSetEconomy(buildPlan, true);
	// Escrow.
	aiPlanSetEscrowID(buildPlan, cEconomyEscrowID);
	// Builders.
	int villcount = 1;
	if (getUnit(gTownCenter, cMyID, cUnitStateABQ) < 1) villcount = gCurrentAliveSettlers;
	aiPlanAddUnitType(buildPlan, gCoveredWagonUnit, villcount, villcount, villcount);

	// Instead of base ID or areas, use a center position and falloff.
	aiPlanSetVariableVector(buildPlan, cBuildPlanCenterPosition, 0, location);
	aiPlanSetVariableFloat(buildPlan, cBuildPlanCenterPositionDistance, 0, 50.00);

	// Add position influences for trees, gold, TCs.
	aiPlanSetNumberVariableValues(buildPlan, cBuildPlanInfluenceUnitTypeID, 4, true);
	aiPlanSetNumberVariableValues(buildPlan, cBuildPlanInfluenceUnitDistance, 4, true);
	aiPlanSetNumberVariableValues(buildPlan, cBuildPlanInfluenceUnitValue, 4, true);
	aiPlanSetNumberVariableValues(buildPlan, cBuildPlanInfluenceUnitFalloff, 4, true);

	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitTypeID, 0, cUnitTypeWood);
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitDistance, 0, 30.0); // 30m range.
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitValue, 0, 10.0); // 10 points per tree
	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitFalloff, 0, cBPIFalloffLinear); // Linear slope falloff

	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitTypeID, 1, cUnitTypeMine);
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitDistance, 1, 40.0); // 40 meter range for gold
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitValue, 1, 300.0); // 300 points each
	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitFalloff, 1, cBPIFalloffLinear); // Linear slope falloff

	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitTypeID, 2, cUnitTypeMine);
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitDistance, 2, 10.0); // 10 meter inhibition to keep some space
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitValue, 2, -300.0); // -300 points each
	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitFalloff, 2, cBPIFalloffNone); // Cliff falloff

	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitTypeID, 3, gTownCenter);
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitDistance, 3, 40.0); // 40 meter inhibition around TCs.
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitValue, 3, -500.0); // -500 points each
	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitFalloff, 3, cBPIFalloffNone); // Cliff falloff


	// Weight it to prefer the general starting neighborhood
	aiPlanSetVariableVector(buildPlan, cBuildPlanInfluencePosition, 0, location); // Position influence for landing position
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluencePositionDistance, 0, 100.0); // 100m range.
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluencePositionValue, 0, 300.0); // 300 points max
	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluencePositionFalloff, 0, cBPIFalloffLinear); // Linear slope falloff



	aiPlanSetActive(buildPlan);
	aiPlanSetEventHandler(buildPlan, cPlanEventStateChange, "tcPlacedEventHandler");
	gTCBuildPlanID = buildPlan; // Save in a global var so the rule can access it.


}

//==============================================================================
// createSimpleWallPlanRing
/*
*/
// updatedOn 2022/02/23 By ageekhere
//==============================================================================
int createWallPlanRing(int planID = -1, string planName = "", int numOfBuilders = -1, vector position = cInvalidVector, int wallRingSize = -1, int numOfGates = -1)
{
	planID = aiPlanCreate(planName, cPlanBuildWall); // new wall plan
	aiPlanSetVariableInt(planID, cBuildWallPlanWallType, 0, cBuildWallPlanWallTypeRing); //set to use the ring wall method
	aiPlanAddUnitType(planID, gEconUnit, numOfBuilders, numOfBuilders, numOfBuilders); //set how many settlers will build the wall
	aiPlanSetVariableVector(planID, cBuildWallPlanWallRingCenterPoint, 0, position); //the wall Position
	aiPlanSetVariableFloat(planID, cBuildWallPlanWallRingRadius, 0, wallRingSize); //the ring size
	aiPlanSetVariableInt(planID, cBuildWallPlanNumberOfGates, 0, numOfGates); //number of gates in the wall
	aiPlanSetVariableInt(planID, cBuildWallPlanEdgeOfMapBuffer, 0, 10); //set a buffer so that the ai will not wall off the edge of the map
	aiPlanSetDesiredPriority(planID, 95); //set Priority
	aiPlanSetActive(planID, true); //stat the plan
	return(planID);
}

//==============================================================================
/* createDefendPlan
	
	Create a defend plan, protect the main base.
*/
//==============================================================================
void createDefendPlan()
{

	//if (gCurrentAge == cAge5)
	//{
	//	aiPlanDestroy(gLandDefendPlan0);
	//	gLandDefendPlan0 = -1;
	//	return;
	//}
	if(aiPlanGetNumber(cPlanDefend, -1, true) != 0)return;
	
	if(kbBaseGetUnderAttack(cMyID,gMainBase) == false && gLandDefendPlan0 != -1)
	{
		aiPlanDestroy(gLandDefendPlan0);
		gLandDefendPlan0 = -1;
		return;
	}
	if(kbBaseGetUnderAttack(cMyID,gMainBase) == false)return;
	

	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 60000,"createDefendPlan") == false) return;
	lastRunTime = gCurrentGameTime;
	
	if(kbBaseGetUnderAttack(cMyID,gMainBase) == false)return;
	if (gLandDefendPlan0 < 0)
	{
		gLandDefendPlan0 = aiPlanCreate("Primary Land Defend", cPlanDefend);
		aiPlanAddUnitType(gLandDefendPlan0, cUnitTypeLogicalTypeLandMilitary, 0, 0, 1); // Small, until defense reflex

		aiPlanSetVariableVector(gLandDefendPlan0, cDefendPlanDefendPoint, 0, kbBaseGetMilitaryGatherPoint(cMyID, kbBaseGetMainID(cMyID)));
		aiPlanSetVariableFloat(gLandDefendPlan0, cDefendPlanEngageRange, 0, cvDefenseReflexRadiusActive);
		aiPlanSetVariableFloat(gLandDefendPlan0, cDefendPlanGatherDistance, 0, cvDefenseReflexRadiusActive - 10.0);
		aiPlanSetVariableBool(gLandDefendPlan0, cDefendPlanPatrol, 0, false);
		aiPlanSetVariableFloat(gLandDefendPlan0, cDefendPlanGatherDistance, 0, 20.0);
		aiPlanSetInitialPosition(gLandDefendPlan0, gMainBaseLocation);
		aiPlanSetUnitStance(gLandDefendPlan0, cUnitStanceDefensive);
		aiPlanSetVariableInt(gLandDefendPlan0, cDefendPlanRefreshFrequency, 0, 5);
		aiPlanSetVariableInt(gLandDefendPlan0, cDefendPlanAttackTypeID, 0, cUnitTypeUnit); // Only units
		aiPlanSetDesiredPriority(gLandDefendPlan0, 10); // Very low priority, don't steal from attack plans
		aiPlanSetActive(gLandDefendPlan0);
		//aiEcho("Creating primary land defend plan");

		gLandReservePlan = aiPlanCreate("Land Reserve Units", cPlanDefend);
		aiPlanAddUnitType(gLandReservePlan, cUnitTypeLogicalTypeLandMilitary, 0, 5, 200); // All mil units, high MAX value to suck up all excess

		aiPlanSetVariableVector(gLandReservePlan, cDefendPlanDefendPoint, 0, kbBaseGetMilitaryGatherPoint(cMyID, kbBaseGetMainID(cMyID)));
		if (kbBaseGetMilitaryGatherPoint(cMyID, kbBaseGetMainID(cMyID)) == cInvalidVector)
			if (getUnit(cUnitTypeAIStart, cMyID) >= 0) // If no mil gather point, but there is a start block, use it.
				aiPlanSetVariableVector(gLandReservePlan, cDefendPlanDefendPoint, 0, kbUnitGetPosition(getUnit(cUnitTypeAIStart, cMyID)));
		if (aiPlanGetVariableVector(gLandReservePlan, cDefendPlanDefendPoint, 0) == cInvalidVector) // If all else failed, use main base location.
			aiPlanSetVariableVector(gLandReservePlan, cDefendPlanDefendPoint, 0, kbBaseGetLocation(kbBaseGetMainID(cMyID)));
		aiPlanSetVariableFloat(gLandReservePlan, cDefendPlanEngageRange, 0, 60.0); // Loose
		aiPlanSetVariableBool(gLandReservePlan, cDefendPlanPatrol, 0, false);
		aiPlanSetVariableFloat(gLandReservePlan, cDefendPlanGatherDistance, 0, 20.0);
		aiPlanSetInitialPosition(gLandReservePlan, gMainBaseLocation);
		aiPlanSetUnitStance(gLandReservePlan, cUnitStanceDefensive);
		aiPlanSetVariableInt(gLandReservePlan, cDefendPlanRefreshFrequency, 0, 5);
		aiPlanSetVariableInt(gLandReservePlan, cDefendPlanAttackTypeID, 0, cUnitTypeUnit); // Only units
		aiPlanSetDesiredPriority(gLandReservePlan, 5); // Very very low priority, gather unused units.
		aiPlanSetActive(gLandReservePlan);
		if (gMainAttackGoal >= 0)
			aiPlanSetVariableInt(gMainAttackGoal, cGoalPlanReservePlanID, 0, gLandReservePlan);
		//aiEcho("Creating reserve plan");
		xsEnableRule("endDefenseReflexDelay"); // Reset to relaxed stances after plans have a second to be created.
	}
}

rule createHomeBase
inactive
minInterval 0
{
	// First, create a query if needed, then use it to look for a completed town center
	static int townCenterQuery = -1;
	if (townCenterQuery == -1) 
	{
		townCenterQuery = kbUnitQueryCreate("Completed Town Center Query"+ getQueryId());
		kbUnitQuerySetPlayerID(townCenterQuery, cMyID,false);
		kbUnitQuerySetPlayerRelation(townCenterQuery, -1);
		kbUnitQuerySetIgnoreKnockedOutUnits(townCenterQuery, true);
		kbUnitQuerySetState(townCenterQuery, cUnitStateAlive);
	}
	kbUnitQueryResetResults(townCenterQuery);
	kbUnitQuerySetUnitType(townCenterQuery, gTownCenter);
	
	// Run the query
	int count = kbUnitQueryExecute(townCenterQuery);
	
	//-- If our startmode is one without a TC, wait until a TC is found.
	if ((count < 1) && (gStartMode != gStartModeScenarioNoTC)) return;
	
	
	int tcID = kbUnitQueryGetResult(townCenterQuery, 0);
	//aiEcho("New TC is "+tcID+" at "+kbUnitGetPosition(tcID));
	if (tcID >= 0)
	{
		int tcBase = kbUnitGetBaseID(tcID);
		gMainBase = kbBaseGetMainID(cMyID);
		
		//aiEcho(" TC base is "+tcBase+", main base is "+gMainBase);
		// We have a TC.  Make sure that the main base exists, and it includes the TC
		if (gMainBase < 0)
		{ // We have no main base, create one
			
			gMainBase = createMainBase(kbUnitGetPosition(tcID));
			//aiEcho(" We had no main base, so we created one: "+gMainBase);
		}
		tcBase = kbUnitGetBaseID(tcID); // in case base ID just changed

		if (tcBase != gMainBase)
		{
			//aiEcho(" TC "+tcID+" is not in the main base ("+gMainBase+".");
			//aiEcho(" Setting base "+gMainBase+" to non-main, setting base "+tcBase+" to main.");
			kbBaseSetMain(cMyID, gMainBase, false);
			aiRemoveResourceBreakdown(cResourceFood, cAIResourceSubTypeEasy, gMainBase);
			aiRemoveResourceBreakdown(cResourceFood, cAIResourceSubTypeHunt, gMainBase);
			aiRemoveResourceBreakdown(cResourceFood, cAIResourceSubTypeHerdable, gMainBase);
			aiRemoveResourceBreakdown(cResourceFood, cAIResourceSubTypeFish, gMainBase);
			aiRemoveResourceBreakdown(cResourceFood, cAIResourceSubTypeFarm, gMainBase);
			aiRemoveResourceBreakdown(cResourceWood, cAIResourceSubTypeEasy, gMainBase);
			aiRemoveResourceBreakdown(cResourceGold, cAIResourceSubTypeEasy, gMainBase);
			kbBaseSetMain(cMyID, tcBase, true);
			gMainBase = tcBase;
		}
	}
	else
	{
		aiEcho("No TC, leaving main base as it is.");

	}

	kbBaseSetMaximumResourceDistance(cMyID, kbBaseGetMainID(cMyID), 150.0);


	// Set up the escrows
	kbEscrowSetPercentage(cEconomyEscrowID, cResourceFood, .70);
	kbEscrowSetPercentage(cEconomyEscrowID, cResourceWood, .50);
	kbEscrowSetPercentage(cEconomyEscrowID, cResourceGold, .30);
	kbEscrowSetPercentage(cEconomyEscrowID, cResourceShips, 0.0);
	kbEscrowSetCap(cEconomyEscrowID, cResourceFood, 200);
	kbEscrowSetCap(cEconomyEscrowID, cResourceWood, 200);
	if (kbGetCiv() == cCivDutch)
	{
		kbEscrowSetCap(cEconomyEscrowID, cResourceFood, 350); // Needed for banks
		kbEscrowSetCap(cEconomyEscrowID, cResourceWood, 350);
	}
	kbEscrowSetCap(cEconomyEscrowID, cResourceGold, 200);


	kbEscrowSetPercentage(cMilitaryEscrowID, cResourceFood, .0);
	kbEscrowSetPercentage(cMilitaryEscrowID, cResourceWood, .0);
	kbEscrowSetPercentage(cMilitaryEscrowID, cResourceGold, .0);
	kbEscrowSetPercentage(cMilitaryEscrowID, cResourceShips, 0.0);
	kbEscrowSetCap(cMilitaryEscrowID, cResourceFood, 300);
	kbEscrowSetCap(cMilitaryEscrowID, cResourceWood, 300);
	kbEscrowSetCap(cMilitaryEscrowID, cResourceGold, 300);

	kbEscrowAllocateCurrentResources();



	// Town center found, start building the other buildings
	xsEnableRuleGroup("tcComplete");

	//if (kbGetCiv() == cCivOttomans)
	//	xsEnableRule("ottomanMonitor");

	if (aiGetGameMode() == cGameModeDeathmatch)
	{
		createLocationBuildPlan(gBarracksUnit, 10, 100, false, cMilitaryEscrowID, gMainBaseLocation, 1,-1);
		createLocationBuildPlan(gStableUnit, 10, 100, false, cMilitaryEscrowID, gMainBaseLocation, 1,-1);
		createLocationBuildPlan(gArtilleryDepotUnit, 10, 100, false, cMilitaryEscrowID, gMainBaseLocation, 1,-1);
		
		//deathMatchSetup(); // Add a bunch of custom stuff for a DM jump-start.
	}

	//if (kbUnitCount(cMyID, cUnitTypeypDaimyoRegicide, cUnitStateAlive) > 0)
		//xsEnableRule("regicideMonitor");

	//if (cRandomMapName == "honshu" || cRandomMapName == "regicidehonshu")
	//{
	//	createSimpleBuildPlan(gDockUnit, 1, 100, true, cEconomyEscrowID, kbBaseGetMainID(cMyID), 1);
	//}
	
	xsEnableRule("mainTimer");
	xsEnableRuleGroup("startup");
	econManager();
	
	debugRule("createHomeBase - done", 0);
	xsDisableSelf();
}

void createdock(int pBuilder = -1)
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

	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 30000,"createdock") == false) return;
	lastRunTime = gCurrentGameTime;	

	if(checkBuildingPlan(dockPlan) != -1) return;

	if (kbUnitCount(cMyID, gDockUnit, cUnitStateAlive) >= gDockBuildNum || aiPlanGetState(dockPlan) == 3)return;
	
		aiPlanDestroy(dockPlan); //kill the old plan, state can be 5 which means the ai cannot place the dock for the plan
		dockPlan = aiPlanCreate("military dock plan", cPlanBuild); //create a new dock plan
		aiPlanSetVariableInt(dockPlan, cBuildPlanBuildingTypeID, 0, gDockUnit); //set to make dock
		aiPlanSetDesiredPriority(dockPlan, 100); //set Priority
		aiPlanSetMilitary(dockPlan, true);
		aiPlanSetEconomy(dockPlan, false);
		aiPlanSetEscrowID(dockPlan, cMilitaryEscrowID);
		aiPlanSetNumberVariableValues(dockPlan, cBuildPlanDockPlacementPoint, 2, true); //set placement points

	aiPlanAddUnitType(dockPlan, pBuilder, 1, 1, 1); //build dock with YPDockWagon

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
}

void createTradingPost(int pSocket = -1, int pBuilderType = -1, int pPriority = -1)
{
	int tradepostPlan = aiPlanCreate("tradepostPlan ", cPlanBuild);
	aiPlanSetVariableInt(tradepostPlan, cBuildPlanBuildingTypeID, 0, gTradingPostUnit);
	aiPlanSetDesiredPriority(tradepostPlan, 100); //80
	aiPlanSetMilitary(tradepostPlan, false);
	aiPlanSetEconomy(tradepostPlan, true);	
	aiPlanSetEscrowID(tradepostPlan, cEconomyEscrowID);
	aiPlanAddUnitType(tradepostPlan, pBuilderType, 1, 1, 1);
	aiPlanSetVariableInt(tradepostPlan, cBuildPlanSocketID, 0, pSocket);
	aiPlanSetActive(tradepostPlan);
}

void createMain()
{

}