//managerMethods
//==============================================================================
/*
	Tower manager
	
	Tries to maintain gNumTowers for the number of towers near the main base.
	
	If there are idle outpost wagons, use them.  If not, use villagers to build outposts.
	Russians use blockhouses via gTowerUnit. Natives build war huts (Iroquois), 
	nobles huts (Aztecs) and teepees (Sioux), and Asians build castles, again 
	selected via gTowerUnit.
	
	Placement algorithm is brain-dead simple.  Check a point that is mid-edge or a 
	corner of a square around the base center.  Look for a nearby tower.  If none, 
	do a tight build plan.  If there is one, try again.    If no luck, try a build
	plan that just avoids other towers.
	
*/
//==============================================================================

void outpostWagonManager()
{
	if(kbUnitCount(cMyID, cUnitTypeOutpostWagon, cUnitStateAlive) < 1) return;

	
	
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 5000, "outpostWagonManager") == false) return;
	lastRunTime = gCurrentGameTime;
	
	if(kbUnitCount(cMyID, cUnitTypeOutpostWagon, cUnitStateAlive) < 1) return;
	static int sendOutpost = -1;
	if(sendOutpost == -1) 
	{
		sendOutpost = kbUnitQueryCreate("sendOutpost"+getQueryId());
		kbUnitQuerySetPlayerID(sendOutpost, cMyID, false);
		kbUnitQuerySetPlayerRelation(sendOutpost, -1);
		kbUnitQuerySetUnitType(sendOutpost, cUnitTypeOutpostWagon);
		kbUnitQuerySetState(sendOutpost, cUnitStateAlive);
		kbUnitQuerySetActionType(sendOutpost, 7);
	}
	kbUnitQueryResetResults(sendOutpost);

	for (i = 0; < kbUnitQueryExecute(sendOutpost))
	{
		int outpostId = kbUnitQueryGetResult(sendOutpost, i);
		buildingBluePrint(gTowerUnit,outpostId);
		continue;








		int attempt = 0;
		vector testVec = cInvalidVector;
		float spacingDistance = 25.0; // Mid- and corner-spots on a square with 'radius' spacingDistance, i.e. each side is 2 * spacingDistance.
		float exclusionRadius = spacingDistance / 2.0;
		float dx = spacingDistance;
		float dz = spacingDistance;
		static int towerSearch = -1;
		bool success = false;

		for (attempt = 0; < 10) // Take ten tries to place it
		{
			/*
			if(kbUnitCount(cMyID, gTowerUnit, cUnitStateAlive) == 0)
			{
				testVec = gMainBaseLocation;
			}
			
			else if(gLosingDigin == false)
			{
				testVec = setForwardBaseLocation();
			}
			else
			{
				testVec = gMainBaseLocation; // Start with base location
			}
			*/
			testVec = gMainBaseLocation;
			switch (aiRandInt(8)) // 0..7
			{ // Use 0.9 * on corners to "round them" a bit
				case 0:
					{ // W
						dx = -0.9 * dx;
						dz = 0.9 * dz;
						//aiEcho("West...");
						break;
					}
				case 1:
					{ // NW
						dx = 0.0;
						//aiEcho("Northwest...");
						break;
					}
				case 2:
					{ // N
						dx = 0.9 * dx;
						dz = 0.9 * dz;
						//aiEcho("North...");
						break;
					}
				case 3:
					{ // NE
						dz = 0.0;
						//aiEcho("NorthEast...");
						break;
					}
				case 4:
					{ // E
						dx = 0.9 * dx;
						dz = -0.9 * dz;
						//aiEcho("East...");
						break;
					}
				case 5:
					{ // SE
						dx = 0.0;
						dz = -1.0 * dz;
						//aiEcho("SouthEast...");
						break;
					}
				case 6:
					{ // S
						dx = -0.9 * dx;
						dz = -0.9 * dz;
						//aiEcho("South...");
						break;
					}
				case 7:
					{ // SW
						dx = -1.0 * dx;
						dz = 0;
						//aiEcho("SouthWest...");
						break;
					}
			}
			testVec = xsVectorSetX(testVec, xsVectorGetX(testVec) + dx);
			testVec = xsVectorSetZ(testVec, xsVectorGetZ(testVec) + dz);
			// aiEcho("Testing tower location "+testVec);
			if (towerSearch == -1) 
			{
				towerSearch = kbUnitQueryCreate("Tower placement search"+getQueryId());
				kbUnitQuerySetPlayerID(towerSearch,-1,false);
				kbUnitQuerySetPlayerRelation(towerSearch, cPlayerRelationAny);
				kbUnitQuerySetState(towerSearch, cUnitStateABQ);
			}
			kbUnitQueryResetResults(towerSearch);
			kbUnitQuerySetUnitType(towerSearch, gTowerUnit);
			kbUnitQuerySetPosition(towerSearch, testVec);
			kbUnitQuerySetMaximumDistance(towerSearch, exclusionRadius);
			
			if (kbUnitQueryExecute(towerSearch) < 1)
			{ // Site is clear, use it
				if (kbAreaGroupGetIDByPosition(testVec) == kbAreaGroupGetIDByPosition(gMainBaseLocation))
				{ // Make sure it's in same areagroup.
					success = true;
					break;
				}
			}
		}
		// We have found a location (success == true) or we need to just do a brute force placement around the TC.
		if (success == false) testVec = gMainBaseLocation;
		int buildPlan = aiPlanCreate("Outpost wagon " + outpostId, cPlanBuild);
		// What to build
		aiPlanSetVariableInt(buildPlan, cBuildPlanBuildingTypeID, 0, gTowerUnit);
		// Priority.
		aiPlanSetDesiredPriority(buildPlan, 100);
		// Econ, because mil doesn't get enough wood.
		aiPlanSetMilitary(buildPlan, false);
		aiPlanSetEconomy(buildPlan, true);
		// Escrow.
		aiPlanSetEscrowID(buildPlan, cEconomyEscrowID);
		// Builders.
		aiPlanAddUnitType(buildPlan, cUnitTypeOutpostWagon, 1, 1, 1);
		aiPlanAddUnit(buildPlan, outpostId);

		// Instead of base ID or areas, use a center position and falloff.
		aiPlanSetVariableVector(buildPlan, cBuildPlanCenterPosition, 0, testVec);
		if (success == true)
			aiPlanSetVariableFloat(buildPlan, cBuildPlanCenterPositionDistance, 0, exclusionRadius);
		else
			aiPlanSetVariableFloat(buildPlan, cBuildPlanCenterPositionDistance, 0, 55.0);
		// Add position influence for nearby towers
		aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitTypeID, 0, gTowerUnit); // Russian's won't notice ally towers and vice versa...oh well.
		aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitDistance, 0, spacingDistance);
		aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitValue, 0, -20.0); // -20 points per tower
		aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitFalloff, 0, cBPIFalloffLinear); // Linear slope falloff
		// Weight it to stay very close to center point.
		aiPlanSetVariableVector(buildPlan, cBuildPlanInfluencePosition, 0, testVec); // Position influence for landing position
		aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluencePositionDistance, 0, exclusionRadius); // 100m range.
		aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluencePositionValue, 0, 10.0); // 10 points for center
		aiPlanSetVariableInt(buildPlan, cBuildPlanInfluencePositionFalloff, 0, cBPIFalloffLinear); // Linear slope falloff
		aiPlanSetActive(buildPlan);
	}
}

//rule towerManager
//inactive
//minInterval 10
void towerManager()
{
	if(gCurrentCiv == cCivRussians)return;

	static bool pOktoBuildTower = false;

	if(getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, gMainTownCenterLocation, 30.0) > 15 || gCurrentAge > cAge3)
	{
		pOktoBuildTower = true;
	}
	if(pOktoBuildTower == false) return;

	static bool pFirstAttack = false;
	if(gMainBaseUnderAttack == true && gCurrentAge > cAge1) pFirstAttack = true;
	if(pFirstAttack == false && gCurrentAge < cAge4 && kbUnitCount(cMyID, cUnitTypeOutpostWagon, cUnitStateAlive) == 0)return;
	
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"towerManager") == false) return;
	lastRunTime = gCurrentGameTime;
	

	//if (gCurrentAge < cAge3) return;
	if (gCurrentWood < 300)return;
		
	if (cvOkToFortify == false)
	{
		return; // Oops.  I shouldn't be running.
	}
	if (kbUnitCount(cMyID, gBarracksUnit, cUnitStateAlive) == 0) return;
/*	
return;
if(kbGetBuildLimit(cMyID, gTowerUnit) - kbUnitCount(cMyID, gTowerUnit, cUnitStateABQ) > 0)
{
	createLocationBuildPlan(gTowerUnit, 1, 100, false, cMilitaryEscrowID, kbUnitGetPosition(getUnit(gTownCenter, cMyID, cUnitStateABQ)) , 1,-1);
	return;
}
*/


	static int towerUpgradePlan = -1;
	int towerUpgrade1 = cTechFrontierOutpost;
	int towerUpgrade2 = cTechFortifiedOutpost;
	if (kbGetCiv() == cCivRussians)
	{
		towerUpgrade1 = cTechFrontierBlockhouse;
		towerUpgrade2 = cTechFortifiedBlockhouse;
	}
	if (kbGetCiv() == cCivXPIroquois)
	{
		towerUpgrade1 = cTechStrongWarHut;
		towerUpgrade2 = cTechMightyWarHut;
	}
	if (kbGetCiv() == cCivXPAztec)
	{
		towerUpgrade1 = cTechStrongNoblesHut;
		towerUpgrade2 = cTechMightyNoblesHut;
	}
	if (kbGetCiv() == cCivXPSioux)
	{
		towerUpgrade1 = cTechStrongWarHut;
		towerUpgrade2 = cTechMightyWarHut;
	}
	if (getCivIsAsian() == true)
	{
		towerUpgrade1 = cTechypFrontierCastle;
		towerUpgrade2 = cTechypFortifiedCastle;
	}

	if (towerUpgradePlan >= 0)
	{
		if ((aiPlanGetState(towerUpgradePlan) < 0) || (aiPlanGetVariableInt(towerUpgradePlan, cResearchPlanBuildingID, 0) < 0))
		{
			aiPlanDestroy(towerUpgradePlan);
			towerUpgradePlan = -1;
			aiEcho("Invalid tower upgrade plan destroyed.");
		}
	}

	if ((kbTechGetStatus(towerUpgrade1) == cTechStatusObtainable) && (towerUpgradePlan == -1)) // The first upgrade is available, and I'm not researching it. 
	{
		if (kbUnitCount(cMyID, gTowerUnit, cUnitStateABQ) >= 3)
		{ // I have at least 3 towers
			towerUpgradePlan = createSimpleResearchPlan(towerUpgrade1, -1, cMilitaryEscrowID, 75);
			aiEcho("Starting research plan for first tower upgrade in plan # " + towerUpgradePlan);
		}
	}

	if ((kbTechGetStatus(towerUpgrade2) == cTechStatusObtainable) && (towerUpgradePlan == -1)) // The second upgrade is available, and I'm not researching it. 
	{
		if (kbUnitCount(cMyID, gTowerUnit, cUnitStateABQ) >= 5)
		{ // I have at least 5 towers
			towerUpgradePlan = createSimpleResearchPlan(towerUpgrade2, -1, cMilitaryEscrowID, 75);
			aiEcho("Starting research plan for second tower upgrade in plan # " + towerUpgradePlan);
		}
	}

	if ((kbUnitCount(cMyID, gTowerUnit, cUnitStateABQ) >= gNumTowers) && (kbUnitCount(cMyID, cUnitTypeOutpostWagon, cUnitStateAlive) <= 0) && (kbUnitCount(cMyID, cUnitTypeYPCastleWagon, cUnitStateAlive) <= 0))
		return; // We have enough, thank you, and no idle outpost or castle wagons.


	if (checkBuildingPlan(gTowerUnit) >= 0)
		return; // We're already building one.

	if (getCivIsAsian() == false)
	{ //BHG: Asians have different outpost wagon types so it's ok to keep going
		if (checkBuildingPlan(cUnitTypeOutpost) >= 0)
			return; // We're already building one.  (Weird case of civs that don't usually make towers having an outpost wagon given to them.
	}

	// Need more, not currently building any.  Need to select a builder type (settler or outpostWagon) and a location.
	int builderType = -1;

	if ((getCivIsAsian() == false) && (kbUnitCount(cMyID, cUnitTypeOutpostWagon, cUnitStateAlive) > 0))
		builderType = cUnitTypeOutpostWagon;
	else if ((getCivIsAsian() == true) && (kbUnitCount(cMyID, cUnitTypeYPCastleWagon, cUnitStateAlive) > 0))
		builderType = cUnitTypeYPCastleWagon;
	else
		builderType = gEconUnit;
	
	if(gBlockhouseEngineeringEnabled == true && kbUnitCount(cMyID, cUnitTypeStrelet, cUnitStateAlive) > 0)
	{
		builderType = cUnitTypeStrelet;
	}
buildingBluePrint(gTowerUnit,-1);
return;

////////////////////
	int attempt = 0;
	vector testVec = cInvalidVector;
	float spacingDistance = 25.0; // Mid- and corner-spots on a square with 'radius' spacingDistance, i.e. each side is 2 * spacingDistance.
	float exclusionRadius = spacingDistance / 2.0;
	float dx = spacingDistance;
	float dz = spacingDistance;
	static int towerSearch = -1;
	bool success = false;

	for (attempt = 0; < 10) // Take ten tries to place it
	{
		testVec = gMainBaseLocation; // Start with base location

		switch (aiRandInt(8)) // 0..7
		{ // Use 0.9 * on corners to "round them" a bit
			case 0:
				{ // W
					dx = -0.9 * dx;
					dz = 0.9 * dz;
					aiEcho("West...");
					break;
				}
			case 1:
				{ // NW
					dx = 0.0;
					aiEcho("Northwest...");
					break;
				}
			case 2:
				{ // N
					dx = 0.9 * dx;
					dz = 0.9 * dz;
					aiEcho("North...");
					break;
				}
			case 3:
				{ // NE
					dz = 0.0;
					aiEcho("NorthEast...");
					break;
				}
			case 4:
				{ // E
					dx = 0.9 * dx;
					dz = -0.9 * dz;
					aiEcho("East...");
					break;
				}
			case 5:
				{ // SE
					dx = 0.0;
					dz = -1.0 * dz;
					aiEcho("SouthEast...");
					break;
				}
			case 6:
				{ // S
					dx = -0.9 * dx;
					dz = -0.9 * dz;
					aiEcho("South...");
					break;
				}
			case 7:
				{ // SW
					dx = -1.0 * dx;
					dz = 0;
					aiEcho("SouthWest...");
					break;
				}
		}
		testVec = xsVectorSetX(testVec, xsVectorGetX(testVec) + dx);
		testVec = xsVectorSetZ(testVec, xsVectorGetZ(testVec) + dz);
		aiEcho("Testing tower location " + testVec);
		if (towerSearch == -1) 
		{
			towerSearch = kbUnitQueryCreate("Tower placement search"+getQueryId());
			kbUnitQuerySetPlayerID(towerSearch,-1,false);
			kbUnitQuerySetPlayerRelation(towerSearch, cPlayerRelationAny);
			kbUnitQuerySetState(towerSearch, cUnitStateABQ);
		}
		kbUnitQueryResetResults(towerSearch);
		kbUnitQuerySetUnitType(towerSearch, gTowerUnit);
		kbUnitQuerySetPosition(towerSearch, testVec);
		kbUnitQuerySetMaximumDistance(towerSearch, exclusionRadius);
		
		if (kbUnitQueryExecute(towerSearch) < 1)
		{ // Site is clear, use it
			if (kbAreaGroupGetIDByPosition(testVec) == kbAreaGroupGetIDByPosition(gMainBaseLocation))
			{ // Make sure it's in same areagroup.
				success = true;
				break;
			}
		}
	}

	// We have found a location (success == true) or we need to just do a brute force placement around the TC.
	if (success == false)
		testVec = gMainBaseLocation;
	
	testVec = gForwardBaseLocation;




	int buildPlan = aiPlanCreate("Tower build plan ", cPlanBuild);
	// What to build
	if ((builderType == cUnitTypeOutpostWagon) && (getCivIsAsian() == false))
		aiPlanSetVariableInt(buildPlan, cBuildPlanBuildingTypeID, 0, cUnitTypeOutpost);
	else
		aiPlanSetVariableInt(buildPlan, cBuildPlanBuildingTypeID, 0, gTowerUnit);
	// Priority.
	aiPlanSetDesiredPriority(buildPlan, 85);
	// Econ, because mil doesn't get enough wood.
	aiPlanSetMilitary(buildPlan, false);
	aiPlanSetEconomy(buildPlan, true);
	// Escrow.
	aiPlanSetEscrowID(buildPlan, cEconomyEscrowID);
	// Builders.
	aiPlanAddUnitType(buildPlan, builderType, 1, 1, 1);

	// Instead of base ID or areas, use a center position and falloff.
	aiPlanSetVariableVector(buildPlan, cBuildPlanCenterPosition, 0, testVec);
	if (success == true)
		aiPlanSetVariableFloat(buildPlan, cBuildPlanCenterPositionDistance, 0, exclusionRadius);
	else
		aiPlanSetVariableFloat(buildPlan, cBuildPlanCenterPositionDistance, 0, 55.0);

	// Add position influence for nearby towers
	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitTypeID, 0, gTowerUnit); // Russian's won't notice ally towers and vice versa...oh well.
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitDistance, 0, spacingDistance);
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitValue, 0, -20.0); // -20 points per tower
	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitFalloff, 0, cBPIFalloffLinear); // Linear slope falloff

	// Weight it to stay very close to center point.
	aiPlanSetVariableVector(buildPlan, cBuildPlanInfluencePosition, 0, testVec); // Position influence for landing position
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluencePositionDistance, 0, exclusionRadius); // 100m range.
	aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluencePositionValue, 0, 10.0); // 10 points for center
	aiPlanSetVariableInt(buildPlan, cBuildPlanInfluencePositionFalloff, 0, cBPIFalloffLinear); // Linear slope falloff

	aiEcho("Starting building plan (" + buildPlan + ") for tower at location " + testVec);
	aiEcho("Cheapest tech for tower buildings is " + kbGetTechName(kbTechTreeGetCheapestUnitUpgrade(gTowerUnit)));
	aiEcho("Cheapest tech ID is " + kbTechTreeGetCheapestUnitUpgrade(gTowerUnit));
	aiPlanSetActive(buildPlan);
}

//NOTE needs a rewrite
void fowardBuildingManager()
{ //create a foward base
	return;
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 60000,"fowardBuildingManager") == false) return;
	lastRunTime = gCurrentGameTime;
	
	if (gCurrentAge < cAge4 || gBaseRelocateStatus == true || gCurrentAliveSettlers < 40) return; //wait untill age 3
	if (aiTreatyActive() == true) return;
	if (gWallMidPosition == cInvalidVector) gWallMidPosition = gMainBaseLocation;
	gBuildFrontLocation = kbVPSiteGetLocation(getfarthestVPSite(gWallMidPosition, cVPAll, cVPStateCompleted, cPlayerRelationSelf));
	if (gBuildFrontLocation == cInvalidVector)
	{ //if there is no VP Sites try and build in the middle of the map 
		gBuildFrontLocation = gMapCenter; //set base locaton for middle
	} //end if

	else
	{ //build small base at vp site
		for (i = 0; < kbVPSiteQuery(cVPAll, cPlayerRelationEnemy, cVPStateAny))
		{ //loop through all vp sites	
			for (j = 0; < xsArrayGetSize(gBuildListArray))
			{ //look through all own sites
				int vpList = kbVPSiteQuery(cVPAll, cPlayerRelationEnemy, cVPStateAny);
				int siteID = xsArrayGetInt(vpList, j);
				if (kbVPSiteGetLocation(siteID) == xsArrayGetVector(gBuildListArray, j) && kbVPSiteGetLocation(siteID) != cInvalidVector)
				{ //reset site exclude
					xsArraySetVector(gBuildListArray, j, cInvalidVector);
				} // end if
			} //end for	j				
		} //end for i

		for (x = 0; < xsArrayGetSize(gBuildListArray))
		{ //loop through our sites
			if (xsArrayGetVector(gBuildListArray, x) == gBuildFrontLocation)
			{ //have already built here exclude
				gBuildFrontLocation = gMapCenter;
				break;
			} //end if

		} //end for x	

		if (gBuildFrontLocation != gMapCenter)
		{ //exclude location
			for (x = 0; < xsArrayGetSize(gBuildListArray))
			{
				if (xsArrayGetVector(gBuildListArray, x) == vector(0, 0, 0) || xsArrayGetVector(gBuildListArray, x) == cInvalidVector)
				{
					xsArraySetVector(gBuildListArray, x, gBuildFrontLocation);
					break;
				}
			}
		} //end
	} //end else

	int unitbuiltCount = 0;
	int unitEnemyCount = 0;

	if (gBuildFrontLocation == gMapCenter)
	{
		if (getUnitByLocation(cUnitTypeBarracks, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeBarracks, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(cUnitTypeStable, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeStable, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(cUnitTypeArtilleryDepot, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeArtilleryDepot, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(cUnitTypeOutpost, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeOutpost, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(cUnitTypeBlockhouse, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeBlockhouse, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(cUnitTypeWarHut, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeWarHut, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(cUnitTypeypBarracksJapanese, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeypBarracksJapanese, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(cUnitTypeypWarAcademy, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeypWarAcademy, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(cUnitTypeYPBarracksIndian, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeYPBarracksIndian, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(cUnitTypeCorral, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeCorral, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(cUnitTypeypStableJapanese, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeypStableJapanese, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(cUnitTypeypCaravanserai, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeypCaravanserai, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(cUnitTypeypCastle, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeypCastle, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(cUnitTypeYPOutpostAsian, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeYPOutpostAsian, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(cUnitTypeLookout, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeLookout, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(cUnitTypeFortFrontier, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(cUnitTypeFortFrontier, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (getUnitByLocation(gTradingPostUnit, cPlayerRelationAny, cUnitStateABQ, gBuildFrontLocation, 40.0) != -1) unitbuiltCount++;
		if (getUnitByLocation(gTradingPostUnit, cPlayerRelationEnemy, cUnitStateAlive, gBuildFrontLocation, 40.0) != -1) unitEnemyCount++;

		if (unitbuiltCount > 2 || unitEnemyCount > 0) return;

	}
	if (gBuildFrontLocation == gMapCenter)
	{ //Try and build one of each for center

		if (checkBuildingPlan(cUnitTypeOutpost) == -1 &&
			getUnitByLocation(cUnitTypeOutpost, cPlayerRelationAny, cUnitStateAlive, gBuildFrontLocation, 40.0) == -1) createLocationBuildPlan(cUnitTypeOutpost, 1, 100, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);

		else if (checkBuildingPlan(cUnitTypeYPOutpostAsian) == -1) createLocationBuildPlan(cUnitTypeYPOutpostAsian, 1, 100, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeypCastle) == -1) createLocationBuildPlan(cUnitTypeypCastle, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeLookout) == -1 && getCivIsAsian() == true) createLocationBuildPlan(cUnitTypeLookout, 1, 100, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeBarracks) == -1) createLocationBuildPlan(cUnitTypeBarracks, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeWarHut) == -1) createLocationBuildPlan(cUnitTypeWarHut, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeYPBarracksIndian) == -1) createLocationBuildPlan(cUnitTypeYPBarracksIndian, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeBlockhouse) == -1) createLocationBuildPlan(cUnitTypeBlockhouse, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeypBarracksJapanese) == -1) createLocationBuildPlan(cUnitTypeypBarracksJapanese, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeStable) == -1) createLocationBuildPlan(cUnitTypeStable, 1, 98, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeCorral) == -1) createLocationBuildPlan(cUnitTypeCorral, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeypStableJapanese) == -1) createLocationBuildPlan(cUnitTypeypStableJapanese, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeArtilleryDepot) == -1) createLocationBuildPlan(cUnitTypeArtilleryDepot, 1, 99, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeypWarAcademy) == -1) createLocationBuildPlan(cUnitTypeypWarAcademy, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeypCaravanserai) == -1) createLocationBuildPlan(cUnitTypeypCaravanserai, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
	}

	int nearestPlayer = cMyID;
	int lowestDist = 9999999;
	int currentDist = 0;
	bool donotbuild = false;
	
	if (gBuildFrontLocation != gMapCenter && donotbuild == false)
	{
		if (checkBuildingPlan(cUnitTypeOutpost) == -1) createLocationBuildPlan(cUnitTypeOutpost, 1, 100, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeYPOutpostAsian) == -1) createLocationBuildPlan(cUnitTypeYPOutpostAsian, 1, 100, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeypCastle) == -1) createLocationBuildPlan(cUnitTypeypCastle, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeLookout) == -1 && getCivIsAsian() == true) createLocationBuildPlan(cUnitTypeLookout, 1, 100, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);

		else if (checkBuildingPlan(cUnitTypeBarracks) == -1) createLocationBuildPlan(cUnitTypeBarracks, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeWarHut)== -1) createLocationBuildPlan(cUnitTypeWarHut, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeYPBarracksIndian) == -1) createLocationBuildPlan(cUnitTypeYPBarracksIndian, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeBlockhouse) == -1) createLocationBuildPlan(cUnitTypeBlockhouse, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeypBarracksJapanese) == -1) createLocationBuildPlan(cUnitTypeypBarracksJapanese, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);

		else if (checkBuildingPlan(cUnitTypeStable) == -1) createLocationBuildPlan(cUnitTypeStable, 1, 98, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeCorral) == -1) createLocationBuildPlan(cUnitTypeCorral, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeypStableJapanese) == -1) createLocationBuildPlan(cUnitTypeypStableJapanese, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);

		else if (checkBuildingPlan(cUnitTypeypWarAcademy) == -1) createLocationBuildPlan(cUnitTypeypWarAcademy, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
		else if (checkBuildingPlan(cUnitTypeypCaravanserai) == -1) createLocationBuildPlan(cUnitTypeypCaravanserai, 1, 97, false, cMilitaryEscrowID, gBuildFrontLocation, 1,-1);
	}
} //end forwardBuildings
//---------------------------  

//==============================================================================
// forwardBaseManager
// updatedOn 2020/03/09 By ageekhere
//==============================================================================
/*
	Forward base manager
	
	Handles the planning, construction, defense and maintenance of a forward military base.
	
	The steps involved:
	1)  Choose a location
	2)  Defend it and send a fort wagon to build a fort.
	3)  Define it as the military base, move defend plans there, move military production there.
	4)  Undo those settings if it needs to be abandoned.
	
*/
//==============================================================================
//rule forwardBaseManager
//inactive
//group tcComplete
//minInterval 30
void forwardBaseManager()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"forwardBaseManager") == false) return;
	lastRunTime = gCurrentGameTime;
	
	int fortWagon = getUnit(cUnitTypeFortWagon, cMyID, cUnitStateAlive);
	if(kbUnitGetActionType(fortWagon) != 7) return;
	if ((cvOkToBuild == false) || (cvOkToBuildForts == false) || (fortWagon == -1)) return;
	switch (gForwardBaseState)
	{
		case gForwardBaseStateNone:
			{
				// Check if we should go to state Building
				if (kbUnitCount(cMyID, cUnitTypeFortWagon, cUnitStateAlive) > 0)
				{ // Yes.
					// get the fort wagon, start a build plan, keep it defended
					gForwardBaseLocation = setForwardBaseLocation();
					if(gForwardBaseLocation == cInvalidVector) return; 
					gForwardBaseBuildPlan = aiPlanCreate("Fort build plan ", cPlanBuild);
					aiPlanSetVariableInt(gForwardBaseBuildPlan, cBuildPlanBuildingTypeID, 0, cUnitTypeFortFrontier);
					aiPlanSetDesiredPriority(gForwardBaseBuildPlan, 87);
					// Military
					aiPlanSetMilitary(gForwardBaseBuildPlan, true);
					aiPlanSetEconomy(gForwardBaseBuildPlan, false);
					aiPlanSetEscrowID(gForwardBaseBuildPlan, cMilitaryEscrowID);
					aiPlanAddUnitType(gForwardBaseBuildPlan, cUnitTypeFortWagon, 1, 1, 1);

					// Instead of base ID or areas, use a center position
					aiPlanSetVariableVector(gForwardBaseBuildPlan, cBuildPlanCenterPosition, 0, gForwardBaseLocation);
					aiPlanSetVariableFloat(gForwardBaseBuildPlan, cBuildPlanCenterPositionDistance, 0, 50.0);

					// Weight it to stay very close to center point.
					aiPlanSetVariableVector(gForwardBaseBuildPlan, cBuildPlanInfluencePosition, 0, gForwardBaseLocation); // Position influence for center
					aiPlanSetVariableFloat(gForwardBaseBuildPlan, cBuildPlanInfluencePositionDistance, 0, 50.0); // 100m range.
					aiPlanSetVariableFloat(gForwardBaseBuildPlan, cBuildPlanInfluencePositionValue, 0, 100.0); // 100 points for center
					aiPlanSetVariableInt(gForwardBaseBuildPlan, cBuildPlanInfluencePositionFalloff, 0, cBPIFalloffLinear); // Linear slope falloff

					// Add position influence for nearby towers
					aiPlanSetVariableInt(gForwardBaseBuildPlan, cBuildPlanInfluenceUnitTypeID, 0, cUnitTypeFortFrontier); // Don't build anywhere near another fort.
					aiPlanSetVariableFloat(gForwardBaseBuildPlan, cBuildPlanInfluenceUnitDistance, 0, 50.0);
					aiPlanSetVariableFloat(gForwardBaseBuildPlan, cBuildPlanInfluenceUnitValue, 0, -200.0); // -20 points per fort
					aiPlanSetVariableInt(gForwardBaseBuildPlan, cBuildPlanInfluenceUnitFalloff, 0, cBPIFalloffNone); // Cliff falloff


					aiPlanSetActive(gForwardBaseBuildPlan);

					// Chat to my allies
					sendStatement(cPlayerRelationAlly, cAICommPromptToAllyIWillBuildMilitaryBase, gForwardBaseLocation);

					gForwardBaseState = gForwardBaseStateBuilding;
					//aiEcho(" ");
					//aiEcho("    BUILDING FORWARD BASE, MOVING DEFEND PLANS TO COVER.");
					//aiEcho("    PLANNED LOCATION IS "+gForwardBaseLocation); 
					//aiEcho(" ");

					if (gDefenseReflex == false)
						endDefenseReflex(); // Causes it to move to the new location
				}
				break;
			}
		case gForwardBaseStateBuilding:
			{
				int fortUnitID = getUnitByLocation(cUnitTypeFortFrontier, cMyID, cUnitStateAlive, gForwardBaseLocation, 100.0);
				if (fortUnitID >= 0)
				{ // Building exists and is complete, go to state Active
					if (kbUnitGetBaseID(fortUnitID) >= 0)
					{ // Base has been created for it.
						gForwardBaseState = gForwardBaseStateActive;
						gForwardBaseID = kbUnitGetBaseID(fortUnitID);
						gForwardBaseLocation = kbUnitGetPosition(fortUnitID);
						//aiEcho("Forward base location is "+gForwardBaseLocation+", Base ID is "+gForwardBaseID+", Unit ID is "+fortUnitID);
						// Tell the attack goal where to go.
						aiPlanSetBaseID(gMainAttackGoal, gForwardBaseID);
						//aiEcho(" ");
						//iEcho("    FORWARD BASE COMPLETED, GOING TO STATE ACTIVE, MOVING ATTACK GOAL.");
						//aiEcho(" ");
					}
					else
					{
						aiEcho(" ");
						//aiEcho("    FORT COMPLETE, WAITING FOR FORWARD BASE ID.");
						//aiEcho(" ");
					}
				}
				else // Check if plan still exists. If not, go back to state 'none'.
				{
					if (aiPlanGetState(gForwardBaseBuildPlan) < 0)
					{ // It failed?
						gForwardBaseState = gForwardBaseStateNone;
						gForwardBaseLocation = cInvalidVector;
						gForwardBaseID = -1;
						gForwardBaseBuildPlan = -1;
						//aiEcho(" ");
						//aiEcho("    FORWARD BASE PLAN FAILED, RETURNING TO STATE NONE.");
						//aiEcho(" ");
					}
				}

				break;
			}
		case gForwardBaseStateActive:
			{ // Normal state.  If fort is destroyed and base overrun, bail.
				if (getUnitByLocation(cUnitTypeFortFrontier, cMyID, cUnitStateAlive, gForwardBaseLocation, 50.0) < 0)
				{
					// Fort is missing, is base still OK?  
					if (((gDefenseReflexBaseID == gForwardBaseID) && (gDefenseReflexPaused == true)) || (kbBaseGetNumberUnits(cMyID, gForwardBaseID, cPlayerRelationSelf, cUnitTypeBuilding) < 1)) // Forward base under attack and overwhelmed, or gone.
					{ // No, not OK.  Get outa Dodge.
						gForwardBaseState = gForwardBaseStateNone;
						gForwardBaseID = -1;
						gForwardBaseLocation = cInvalidVector;
						// Tell the attack goal to go back to the main base.
						aiPlanSetBaseID(gMainAttackGoal, gMainBase);
						endDefenseReflex();
						//aiEcho(" ");
						//aiEcho("    ABANDONING FORWARD BASE, RETREATING TO MAIN BASE.");
						//aiEcho(" ");
					}
				}
				break;
			}
	}
}

void nativeTrainManager(void)
{
		
	static int nativesArray = -1; 
	if (nativesArray == -1) nativesArray = xsArrayCreateInt(100, -1, "nativeTrainArray");
	
	static int nativesArrayAVA = -1;
	if (nativesArrayAVA == -1) nativesArrayAVA = xsArrayCreateInt(100, -1, "nativesArrayAVA");
	static bool firstRun = true;
	
	if(firstRun == true)
	{
		firstRun = false;
		int count = 0;
		for(i = 0; < 3000)
		{
			if(kbProtoUnitIsType(cMyID, i, cUnitTypeAbstractNativeWarrior) == true && 
			kbProtoUnitIsType(cMyID, i, cUnitTypeMercType1) == false &&
			kbProtoUnitIsType(cMyID, i, cUnitTypeMercType2) == false &&
			kbProtoUnitIsType(cMyID, i, cUnitTypeMercType3) == false &&
			kbProtoUnitIsType(cMyID, i, cUnitTypeMercType4) == false &&
			kbProtoUnitIsType(cMyID, i, cUnitTypeMercType5) == false) 
			{
				xsArraySetInt(nativesArray, count, i); 
				count++;
			}
		}	
	}
	for(i = 0; < xsArrayGetSize(nativesArray))
	{
		if(xsArrayGetInt(nativesArray,i) == -1)break;
		if(kbProtoUnitAvailable(xsArrayGetInt(nativesArray,i)) == true)
		{
			for(j = 0; < xsArrayGetSize(nativesArrayAVA))
			{
				if(xsArrayGetInt(nativesArrayAVA,j) == -1)
				{
					xsArraySetInt(nativesArrayAVA, j, xsArrayGetInt(nativesArray,i)); 
					break;
				}
			}
		}
	}
	for(i = 0; < xsArrayGetSize(nativesArrayAVA))
	{
		if(xsArrayGetInt(nativesArrayAVA,i) == -1) break;
		if (aiPlanGetIDByTypeAndVariableType(cPlanTrain, cTrainPlanUnitType, xsArrayGetInt(nativesArrayAVA,i)) == -1)
		{
			createSimpleMaintainPlan(xsArrayGetInt(nativesArrayAVA,i), 50, false, gMainBase, 5, -1);
		}	
	}	
}

void mercenaryTrainManager(void)
{
	if(gCurrentAge < cAge4) return;
	static int mercenaryArray = -1; 
	if (mercenaryArray == -1) mercenaryArray = xsArrayCreateInt(100, -1, "mercenaryTrainArray");
	
	static int mercenaryArrayAVA = -1;
	if (mercenaryArrayAVA == -1) mercenaryArrayAVA = xsArrayCreateInt(100, -1, "mercenaryArrayAVA");
	static bool firstRun = true;
	
	if(firstRun == true)
	{
		firstRun = false;
		int count = 0;
		for(i = 0; < 3000)
		{
			if(kbProtoUnitIsType(cMyID, i, cUnitTypeMercenary) == true || 
			kbProtoUnitIsType(cMyID, i, cUnitTypeMercType1) == true ||
			kbProtoUnitIsType(cMyID, i, cUnitTypeMercType2) == true ||
			kbProtoUnitIsType(cMyID, i, cUnitTypeMercType3) == true ||
			kbProtoUnitIsType(cMyID, i, cUnitTypeMercType4) == true ||
			kbProtoUnitIsType(cMyID, i, cUnitTypeMercType5) == true) 
			{
				xsArraySetInt(mercenaryArray, count, i); 
				count++;
			}
			
		}	
	}
	
	for(i = 0; < xsArrayGetSize(mercenaryArray))
	{
		if(xsArrayGetInt(mercenaryArray,i) == -1)break;
		if(kbProtoUnitAvailable(xsArrayGetInt(mercenaryArray,i)) == true)
		{
			for(j = 0; < xsArrayGetSize(mercenaryArrayAVA))
			{
				if(xsArrayGetInt(mercenaryArrayAVA,j) == -1)
				{
					xsArraySetInt(mercenaryArrayAVA, j, xsArrayGetInt(mercenaryArray,i)); 
					break;
				}
			}
		}
	}
	for(i = 0; < xsArrayGetSize(mercenaryArrayAVA))
	{
		if(xsArrayGetInt(mercenaryArrayAVA,i) == -1) break;
		if (aiPlanGetIDByTypeAndVariableType(cPlanTrain, cTrainPlanUnitType, xsArrayGetInt(mercenaryArrayAVA,i)) == -1)
		{
			createSimpleMaintainPlan(xsArrayGetInt(mercenaryArrayAVA,i), 5, false, gMainBase, 5, -1);
		}	
	}	
	
}

void pfmilitaryTrainManager_bufferCheck(int pPlanId = -1,int pAmount = -1, int unitType = -1)
{
	
	
	bool pCannotAfford = false;
	while(true)
	{
		if (pAmount < 1)return;
		pCannotAfford = false;
		if(gCurrentFood < kbUnitCostPerResource(unitType, cResourceFood) * pAmount) pCannotAfford = true;
		if(gCurrentWood < kbUnitCostPerResource(unitType, cResourceWood) * pAmount) pCannotAfford = true;
		if(gCurrentCoin < kbUnitCostPerResource(unitType, cResourceGold) * pAmount) pCannotAfford = true;
		if(pCannotAfford == true) 
		{
			pAmount--;
		}	
		else break;
		
	}
	
	pAmount = pAmount + kbUnitCount(cMyID, unitType, cUnitStateABQ);
	
	if(pAmount < 5)pAmount = 0;
	
	else if (pAmount > 5 && pAmount < 10)pAmount = 5;
	else if (pAmount > 10 && pAmount < 15)pAmount = 10;
	else if (pAmount > 15 && pAmount < 20)pAmount = 15;
	else if (pAmount > 20 && pAmount < 25)pAmount = 20;
	else if (pAmount > 25 && pAmount < 30)pAmount = 25;
	else if (pAmount > 30 && pAmount < 35)pAmount = 30;
	else if (pAmount > 35 && pAmount < 40)pAmount = 35;
	else if (pAmount > 40 && pAmount < 45)pAmount = 40;
	else if (pAmount > 45 && pAmount < 50)pAmount = 45;
	else if (pAmount > 50 && pAmount < 55)pAmount = 50;
	else if (pAmount > 55 && pAmount < 60)pAmount = 55;
	else if (pAmount > 60 && pAmount < 65)pAmount = 60;
	else if (pAmount > 65 && pAmount < 70)pAmount = 65;
	else if (pAmount > 70 && pAmount < 75)pAmount = 70;
	else if (pAmount > 75 && pAmount < 80)pAmount = 75;
	else if (pAmount > 80 && pAmount < 85)pAmount = 80;
	else if (pAmount > 85 && pAmount < 90)pAmount = 85;
	else if (pAmount > 90 && pAmount < 95)pAmount = 90;
	else if (pAmount > 95 && pAmount < 100)pAmount = 95;
	else if (pAmount > 100) pAmount = 100;
	
	//pAmount = xsMin(xsMax(5, round(pAmount/5)*5), 100);

//aiTaskUnitTrain(int unitID, int unitTypeID)
	
	aiPlanSetVariableInt(pPlanId, cTrainPlanNumberToMaintain, 0, pAmount);
	
}

void militaryTrainManager()
{
	if (aiTreatyActive() == true) return;
	nativeTrainManager();
	mercenaryTrainManager();
	static int mainCavPlan = -1;
	static int mainCavlowPlan = -1;
	static int antiCavPlan = -1;
	static int mainArtPlan = -1;
	static int mainArtlowPlan = -1;
	static int mainArtAntiPlan = -1;
	static int mainINFPlan = -1;
	static int mainINFlowPlan = -1;
	static int antiHIPlan = -1;
	static int antiHILowPlan = -1;
	static int antiLIPlan = -1;
	static int antiLIlowPlan = -1;
	static int antiLCPlan = -1;
	static int antiLClowPlan = -1;
	static int antiCAVINFPlan = -1;
	static int antiCAVlowPlan = -1;
	static int baseCavAntiPlan = -1;
	
	int mainCav = -1;
	int mainCavlow = -1;
	int antiCav = -1;
	int mainArt = -1;
	int mainArtlow = -1;
	int mainArtAnti = -1;
	int mainINF = -1;
	int mainINFlow = -1;
	int antiHI = -1;
	int antiHIlow = -1;
	int antiLI = -1;
	int antiLIlow = -1;
	int antiLC = -1;
	int antiLClow = -1;
	int antiCAVINF = -1;
	int antiCAVlow = -1;
	int baseCavAnti = -1;
	//int mainNativeWarrior = -1;
	int mainMercenary = -1;

	float mainCavValue = 0.2;
	float mainCavlowValue = 0.0;
	float antiCavValue = 0.0;
	float mainArtValue = 0.0;
	float mainArtlowValue = 0.0;
	float mainArtAntiValue = 0.0;
	float mainINFValue = 0.8;
	float mainINFlowValue = 0.0;
	float antiHIValue = 0.0;
	float antiHILowValue = 0.0;
	float antiLIValue = 0.0;
	float antiLIlowValue = 0.0;
	float antiLCValue = 0.0;
	float antiLClowValue = 0.0;
	float antiCAVINFValue = 0.0;
	float antiCAVlowValue = 0.0;
	float baseCavAntiValue = 0.0;
	
	static int millPop = 0;
	switch(gCurrentAge)
	{
		case cAge1 : 
		{
			millPop = 20;
			break;
		}
		case cAge2 : 
		{
			millPop = 30;
			break;
		}
		default:
		{
			millPop = 300;
		}
	}
	

	switch (kbGetCiv())
	{
		case cCivFrench:
			{
				mainCav = cUnitTypeHussar;
				mainCavlow = cUnitTypeHussar;
				antiCav = cUnitTypeDragoon;
				mainArt = cUnitTypexpHorseArtillery;
				mainArtlow = cUnitTypeFalconet;
				mainArtAnti = cUnitTypeCulverin;
				mainINF = cUnitTypeMusketeer;
				mainINFlow = cUnitTypeMusketeer;
				antiHI = cUnitTypeSkirmisher;
				antiHIlow = cUnitTypeCrossbowman;
				antiLI = cUnitTypePikeman;
				antiLIlow = cUnitTypeMusketeer;
				antiLC = cUnitTypeSkirmisher;
				antiLClow = cUnitTypeCrossbowman;
				antiCAVINF = cUnitTypePikeman;
				antiCAVlow = cUnitTypeMusketeer;
				baseCavAnti = cUnitTypePikeman;

				if (gCurrentAge > cAge3)
				{
					antiHIlow = cUnitTypeSkirmisher;
					antiLClow = cUnitTypeSkirmisher;
					mainCav = cUnitTypeCuirassier;
					mainINF = cUnitTypeMusketeer;
				}
				
				break;
			}
		case cCivJapanese:
			{
				mainCav = cUnitTypeypNaginataRider;
				mainCavlow = cUnitTypeypNaginataRider;
				antiCav = cUnitTypeypYabusame;
				mainArt = cUnitTypeypFlamingArrow;
				mainArtlow = cUnitTypeypFlamingArrow;
				mainArtAnti = cUnitTypeypFlamingArrow;
				mainINF = cUnitTypeypAshigaru;
				mainINFlow = cUnitTypeypAshigaru;
				antiHI = cUnitTypeypYumi;
				antiHIlow = cUnitTypeypYumi;
				antiLI = cUnitTypeSohei;
				antiLIlow = cUnitTypeSohei;
				antiLC = cUnitTypeypKensei;
				antiLClow = cUnitTypeypKensei;
				antiCAVINF = cUnitTypeypKensei;
				antiCAVlow = cUnitTypeypKensei;
				baseCavAnti = cUnitTypeypKensei;
				break;
			}
		case cCivSpanish:
			{
				mainCav = cUnitTypeLancer;
				mainCavlow = cUnitTypeHussar;
				antiCav = cUnitTypeDragoon;
				mainArt = cUnitTypexpHorseArtillery;
				mainArtlow = cUnitTypeFalconet;
				mainArtAnti = cUnitTypeCulverin;
				mainINF = cUnitTypeRodelero;
				mainINFlow = cUnitTypeMusketeer;
				antiHI = cUnitTypeSkirmisher;
				antiHIlow = cUnitTypeCrossbowman;
				antiLI = cUnitTypePikeman;
				antiLIlow = cUnitTypeMusketeer;
				antiLC = cUnitTypeSkirmisher;
				antiLClow = cUnitTypeCrossbowman;
				antiCAVINF = cUnitTypePikeman;
				antiCAVlow = cUnitTypeMusketeer;
				baseCavAnti = cUnitTypePikeman;

				if (gCurrentAge > cAge3)
				{
					antiHIlow = cUnitTypeSkirmisher;
					antiLClow = cUnitTypeSkirmisher;
				}
				if (gCurrentAge < cAge3)
				{
					mainINF = cUnitTypeMusketeer;
				}
				break;
			}
		case cCivBritish:
			{
				mainCav = cUnitTypeHussar;
				mainCavlow = cUnitTypeHussar;
				antiCav = cUnitTypeDragoon;
				mainArt = cUnitTypexpHorseArtillery;
				mainArtlow = cUnitTypeFalconet;
				mainArtAnti = cUnitTypeCulverin;
				mainINF = cUnitTypeMusketeer;
				mainINFlow = cUnitTypeHalberdier;
				antiHI = cUnitTypeGrenadier;
				antiHIlow = cUnitTypeLongbowman;
				antiLI = cUnitTypePikeman;
				antiLIlow = cUnitTypeGrenadier;
				antiLC = cUnitTypeLongbowman;
				antiLClow = cUnitTypeLongbowman;
				antiCAVINF = cUnitTypePikeman;
				antiCAVlow = cUnitTypeMusketeer;
				baseCavAnti = cUnitTypePikeman;

				if (gCurrentAge < cAge3)
				{
					mainINF = cUnitTypeMusketeer;
				}
				break;
			}
		case cCivPortuguese:
			{
				mainCav = cUnitTypeHussar;
				mainCavlow = cUnitTypeHussar;
				antiCav = cUnitTypeDragoon;
				mainArt = cUnitTypexpHorseArtillery;
				mainArtlow = cUnitTypeOrganGun;
				mainArtAnti = cUnitTypeCulverin;
				mainINF = cUnitTypeMusketeer;
				mainINFlow = cUnitTypeHalberdier;
				antiHI = cUnitTypeCacadore;
				antiHIlow = cUnitTypeCrossbowman;
				antiLI = cUnitTypePikeman;
				antiLIlow = cUnitTypeMusketeer;
				antiLC = cUnitTypeCacadore;
				antiLClow = cUnitTypeCrossbowman;
				antiCAVINF = cUnitTypePikeman;
				antiCAVlow = cUnitTypeMusketeer;
				baseCavAnti = cUnitTypePikeman;

				if (gCurrentAge > cAge3)
				{
					antiHIlow = cUnitTypeCacadore;
					antiLClow = cUnitTypeCacadore;
				}
				if (gCurrentAge < cAge3)
				{
					mainINF = cUnitTypeMusketeer;
				}
				break;
			}
		case cCivDutch:
			{
				mainCav = cUnitTypeHussar;
				mainCavlow = cUnitTypeHussar;
				antiCav = cUnitTypeRuyter;
				mainArt = cUnitTypexpHorseArtillery;
				mainArtlow = cUnitTypeFalconet;
				mainArtAnti = cUnitTypeCulverin;
				mainINF = cUnitTypeMusketeer; 
				mainINFlow = cUnitTypeHalberdier;
				antiHI = cUnitTypeGrenadier;
				antiHIlow = cUnitTypeSkirmisher;
				antiLI = cUnitTypePikeman;
				antiLIlow = cUnitTypeSchutze;
				antiLC = cUnitTypeSkirmisher;
				antiLClow = cUnitTypeSkirmisher;
				antiCAVINF = cUnitTypePikeman;
				antiCAVlow = cUnitTypeSchutze;
				baseCavAnti = cUnitTypePikeman;

				if (gCurrentAge < cAge3)
				{
					mainINF = cUnitTypeMusketeer;
				}
				break;
			}
		case cCivRussians:
			{
				mainCav = cUnitTypeOprichnik;
				mainCavlow = cUnitTypeCossack;
				antiCav = cUnitTypeCavalryArcher;
				mainArt = cUnitTypexpHorseArtillery;
				mainArtlow = cUnitTypeFalconet;
				mainArtAnti = cUnitTypeCulverin;
				mainINF = cUnitTypeMusketeer;
				mainINFlow = cUnitTypeHalberdier;
				antiHI = cUnitTypeGrenadier;
				antiHIlow = cUnitTypeStrelet;
				antiLI = cUnitTypePikeman;
				antiLIlow = cUnitTypeMusketeer;
				antiLC = cUnitTypeMusketeer;
				antiLClow = cUnitTypeStrelet;
				antiCAVINF = cUnitTypePikeman;
				antiCAVlow = cUnitTypeMusketeer;
				baseCavAnti = cUnitTypePikeman;
				if (gCurrentAge < cAge3)
				{
					mainINF = cUnitTypeMusketeer;
				}
				break;
			}
		case cCivGermans:
			{
				mainCav = cUnitTypeWarWagon;
				mainCavlow = cUnitTypeUhlan;
				antiCav = cUnitTypeWarWagon;
				mainArt = cUnitTypexpHorseArtillery;
				mainArtlow = cUnitTypeFalconet;
				mainArtAnti = cUnitTypeCulverin;
				mainINF = cUnitTypeDopplesoldner;
				mainINFlow = cUnitTypeDopplesoldner;
				antiHI = cUnitTypeSkirmisher;
				antiHIlow = cUnitTypeCrossbowman;
				antiLI = cUnitTypePikeman;
				antiLIlow = cUnitTypeDopplesoldner;
				antiLC = cUnitTypeSkirmisher;
				antiLClow = cUnitTypeCrossbowman;
				antiCAVINF = cUnitTypePikeman;
				antiCAVlow = cUnitTypeDopplesoldner;
				baseCavAnti = cUnitTypePikeman;

				if (gCurrentAge > cAge3)
				{
					antiHIlow = cUnitTypeSkirmisher;
					antiLClow = cUnitTypeSkirmisher;
				}
				break;
			}
		case cCivOttomans:
			{
				mainCav = cUnitTypeSpahi;
				mainCavlow = cUnitTypeHussar;
				antiCav = cUnitTypeCavalryArcher;
				mainArt = cUnitTypexpHorseArtillery;
				mainArtlow = cUnitTypeFalconet;
				mainArtAnti = cUnitTypeCulverin;
				mainINF = cUnitTypeAzap;
				mainINFlow = cUnitTypeJanissary;
				antiHI = cUnitTypeAbusGun;
				antiHIlow = cUnitTypeJanissary;
				antiLI = cUnitTypeGrenadier;
				antiLIlow = cUnitTypeJanissary;
				antiLC = cUnitTypeAbusGun;
				antiLClow = cUnitTypeJanissary;
				antiCAVINF = cUnitTypeJanissary;
				antiCAVlow = cUnitTypeGrenadier;
				baseCavAnti = cUnitTypeJanissary;
				break;
			}
		case cCivXPIroquois:
			{
				mainCav = cUnitTypexpHorseman;
				mainCavlow = cUnitTypexpHorseman;
				antiCav = cUnitTypexpMusketRider;
				mainArt = cUnitTypexpLightCannon;
				mainArtlow = cUnitTypexpLightCannon;
				mainArtAnti = cUnitTypexpLightCannon;
				mainINF = cUnitTypexpAenna;
				mainINFlow = cUnitTypexpMantlet;
				antiHI = cUnitTypexpMusketWarrior;
				antiHIlow = cUnitTypexpMantlet;
				antiLI = cUnitTypexpTomahawk;
				antiLIlow = cUnitTypexpMantlet;
				antiLC = cUnitTypexpMusketWarrior;
				antiLClow = cUnitTypexpMantlet;
				antiCAVINF = cUnitTypexpTomahawk;
				antiCAVlow = cUnitTypexpMantlet;
				baseCavAnti = cUnitTypexpTomahawk;
				break;
			}
		case cCivXPSioux:
			{
				mainCav = cUnitTypexpAxeRider;
				mainCavlow = cUnitTypexpBowRider;
				antiCav = cUnitTypexpRifleRider;
				mainArt = cUnitTypexpCoupRider;
				mainArtlow = cUnitTypexpCoupRider;
				mainArtAnti = cUnitTypexpAxeRider;
				mainINF = cUnitTypexpWarClub;
				mainINFlow = cUnitTypexpWarRifle;
				antiHI = cUnitTypexpWarRifle;
				antiHIlow = cUnitTypexpWarBow;
				antiLI = cUnitTypexpWarClub;
				antiLIlow = cUnitTypexpWarRifle;
				antiLC = cUnitTypexpWarRifle;
				antiLClow = cUnitTypexpWarBow;
				antiCAVINF = cUnitTypexpWarClub;
				antiCAVlow = cUnitTypexpWarRifle;
				baseCavAnti = cUnitTypexpWarClub;

				if (gCurrentAge < cAge3)
				{
					antiCav = cUnitTypexpBowRider;
					mainINFlow = cUnitTypexpWarBow;
					antiHI = cUnitTypexpWarRifle;
					antiLIlow = cUnitTypexpWarBow;
					antiLC = cUnitTypexpWarClub;
					antiCAVlow = cUnitTypexpWarClub;
				}

				break;
			}
		case cCivXPAztec:
			{
				mainCav = cUnitTypeNatHuaminca;
				mainCavlow = cUnitTypexpCoyoteMan;
				antiCav = cUnitTypexpEagleKnight;
				mainArt = cUnitTypexpJaguarKnight;
				mainArtlow = cUnitTypexpJaguarKnight;
				mainArtAnti = cUnitTypexpArrowKnight;
				mainINF = cUnitTypexpPumaMan;
				mainINFlow = cUnitTypexpJaguarKnight;
				antiHI = cUnitTypexpJaguarKnight;
				antiHIlow = cUnitTypexpMacehualtin;
				antiLI = cUnitTypexpCoyoteMan;
				antiLIlow = cUnitTypexpJaguarKnight;
				antiLC = cUnitTypexpJaguarKnight;
				antiLClow = cUnitTypexpMacehualtin;
				antiCAVINF = cUnitTypexpCoyoteMan;
				antiCAVlow = cUnitTypexpJaguarKnight;
				baseCavAnti = cUnitTypexpCoyoteMan;
				if (gCurrentAge > cAge3)
				{
					mainINF = cUnitTypexpJaguarKnight;
				}
				break;
			}
		case cCivUSA:
			{

				mainCav = cUnitTypeUSSaberSquad2;
				mainCavlow = cUnitTypeUSSaberSquad2;
				antiCav = cUnitTypeUSSaberSquad2;
				mainArt = cUnitTypexpHorseArtillery;
				mainArtlow = cUnitTypeFalconet;
				mainArtAnti = cUnitTypeCulverin;
				mainINF = cUnitTypeUSColonialMarines2;
				mainINFlow = cUnitTypeUSColonialMarines2;
				antiHI = cUnitTypeUSColonialMilitia;
				antiHIlow = cUnitTypeGrenadier;
				antiLI = cUnitTypeUSGatlingGuns2;
				antiLIlow = cUnitTypeUSColonialMarines2;
				antiLC = cUnitTypeRiflemanUS;
				antiLClow = cUnitTypeUSColonialMarines2;
				antiCAVINF = cUnitTypeUSColonialMarines2;
				antiCAVlow = cUnitTypeUSColonialMarines2;
				baseCavAnti = cUnitTypeUSColonialMarines2;
				if (gCurrentAge > cAge2)
				{
					antiCav = cUnitTypeRiflemanUS;
					antiHI = cUnitTypeRiflemanUS;
				}			
				
				break;
			}		
		case cCivSwedish:
			{
				mainCav = cUnitTypePistolS;
				mainCavlow = cUnitTypeHussar;
				antiCav = cUnitTypeDragoon;
				mainArt = cUnitTypexpHorseArtillery;
				mainArtlow = cUnitTypeFalconet;
				mainArtAnti = cUnitTypeCulverin;
				mainINF = cUnitTypeHandgonne;
				mainINFlow = cUnitTypeMusketeer;
				antiHI = cUnitTypeSharpshooterS;
				antiHIlow = cUnitTypeMusketeer;
				antiLI = cUnitTypePikeman;
				antiLIlow = cUnitTypeMusketeer;
				antiLC = cUnitTypeSharpshooterS;
				antiLClow = cUnitTypeMusketeer;
				antiCAVINF = cUnitTypePikeman;
				antiCAVlow = cUnitTypeMusketeer;
				baseCavAnti = cUnitTypePikeman;

				if (gCurrentAge > cAge3)
				{
					antiHIlow = cUnitTypeSharpshooterS;
					antiLClow = cUnitTypeSharpshooterS;
				}
				if (gCurrentAge < cAge3)
				{
					mainINF = cUnitTypeMusketeer;
				}
				break;
			}
		case cCivItalians:
			{
				mainCav = cUnitTypeHussar;
				mainCavlow = cUnitTypeHussar;
				antiCav = cUnitTypeMountedCrossbowman;
				mainArt = cUnitTypexpHorseArtillery;
				mainArtlow = cUnitTypeFalconet;
				mainArtAnti = cUnitTypeCulverin;
				mainINF = cUnitTypeMusketeer;
				mainINFlow = cUnitTypeMusketeer;
				antiHI = cUnitTypeSaker;
				antiHIlow = cUnitTypeFlatbowman;
				antiLI = cUnitTypePikeman;
				antiLIlow = cUnitTypeMusketeer;
				antiLC = cUnitTypeFlatbowman;
				antiLClow = cUnitTypeFlatbowman;
				antiCAVINF = cUnitTypePikeman;
				antiCAVlow = cUnitTypeMusketeer;
				baseCavAnti = cUnitTypePikeman;
				break;
			}
		case cCivIndians:
			{
				mainCav = cUnitTypeypSowar;
				mainCavlow = cUnitTypeypSowar;
				antiCav = cUnitTypeypZamburak;
				mainArt = cUnitTypeypMercFlailiphant;
				mainArtlow = cUnitTypeypMercFlailiphant;
				mainArtAnti = cUnitTypeypMercFlailiphant;
				mainINF = cUnitTypeypUrumi;
				mainINFlow = cUnitTypeypSepoy;
				antiHI = cUnitTypeypNatMercGurkha;
				antiHIlow = cUnitTypeypSepoy;
				antiLI = cUnitTypeypMahout;
				antiLIlow = cUnitTypeypMahout;
				antiLC = cUnitTypeypNatMercGurkha;
				antiLClow = cUnitTypeypSepoy;
				antiCAVINF = cUnitTypeypHowdah;
				antiCAVlow = cUnitTypeypHowdah;
				baseCavAnti = cUnitTypeypRajput;	
				break;
			}
		case cCivChinese:
			{
				mainCav = cUnitTypeypForbiddenArmy;
				mainCavlow = cUnitTypeypBlackFlagArmy;
				antiCav = cUnitTypeypMongolianArmy;
				mainArt = cUnitTypeypFlameThrower;
				mainArtlow = cUnitTypeypFlameThrower;
				mainArtAnti = cUnitTypeypHandMortar;
				mainINF = cUnitTypeypTerritorialArmy;
				mainINFlow = cUnitTypeypStandardArmySpawn;
				antiHI = cUnitTypeypImperialArmy;
				antiHIlow = cUnitTypeypOldHanArmy;
				antiLI = cUnitTypeypMingArmy;
				antiLIlow = cUnitTypeypStandardArmySpawn;
				antiLC = cUnitTypeypImperialArmy;
				antiLClow = cUnitTypeypOldHanArmy;
				antiCAVINF = cUnitTypeypMingArmy;
				antiCAVlow = cUnitTypeypStandardArmySpawn;
				baseCavAnti = cUnitTypeypMingArmy;

				if (gCurrentAge > cAge3)
				{
					mainINFlow = cUnitTypeypTerritorialArmy;
					antiHIlow = cUnitTypeypTerritorialArmy;
					antiLI = cUnitTypeypImperialArmy;
					antiLIlow = cUnitTypeypTerritorialArmy;
					antiLClow = cUnitTypeypTerritorialArmy;
					antiCAVINF = cUnitTypeypImperialArmy;
					antiCAVlow = cUnitTypeypTerritorialArmy;

				}
				break;
			}
			case cCivColombians:
			{
				
				mainCav = cUnitTypeHussar;
				mainCavlow = cUnitTypeHussar;
				antiCav = cUnitTypeDragoon;
				mainArt = cUnitTypexpHorseArtillery;
				mainArtlow = cUnitTypeFalconet;
				mainArtAnti = cUnitTypeCulverin;
				mainINF = cUnitTypeMusketeer;
				mainINFlow = cUnitTypeUSColonialMilitia;
				antiHI = cUnitTypeUSGatlingGun;
				antiHIlow = cUnitTypeCrossbowman;
				antiLI = cUnitTypePikeman;
				antiLIlow = cUnitTypeUSColonialMilitia;
				antiLC = cUnitTypeypConsulateGuerreiros;
				antiLClow = cUnitTypeCrossbowman;
				antiCAVINF = cUnitTypePikeman;
				antiCAVlow = cUnitTypeUSColonialMilitia;
				baseCavAnti = cUnitTypePikeman;

				if (gCurrentAge > cAge3)
				{
					antiHIlow = cUnitTypeypConsulateGuerreiros;
					antiLClow = cUnitTypeypConsulateGuerreiros;
				}
				
				break;
			}
			case cCivMaltese:
			{
				//cUnitTypeIGCSahin

				mainCav = cUnitTypeHussar;
				mainCavlow = cUnitTypeCavalaria;
				antiCav = cUnitTypeDragoon;
				mainArt = cUnitTypeFalconet;
				mainArtlow = cUnitTypeFalconet;
				mainArtAnti = cUnitTypeCulverin;

				mainINF = cUnitTypeMusketeer;
				mainINFlow = cUnitTypeMusketeer;
				antiHI = cUnitTypeMusketeer;
				antiHIlow = cUnitTypeCrossbowman;
				antiLI = cUnitTypeMusketeer;
				antiLIlow = cUnitTypeCrossbowman;
				antiLC = cUnitTypePikeman;
				antiLClow = cUnitTypeCrossbowman;
				antiCAVINF = cUnitTypePikeman;
				antiCAVlow = cUnitTypePikeman;
				baseCavAnti = cUnitTypePikeman;

				if (gCurrentAge > cAge1 && kbUnitCount(cMyID, cUnitTypeGeneralMorgan, cUnitStateABQ) < 1) aiTaskUnitTrain(getUnit(gBarracksUnit), cUnitTypeGeneralMorgan);
				if (gCurrentAge > cAge2 && kbUnitCount(cMyID, cUnitTypeGeneralAlain, cUnitStateABQ) < 1) aiTaskUnitTrain(getUnit(gStableUnit), cUnitTypeGeneralAlain);
				if (gCurrentAge > cAge3 && kbUnitCount(cMyID, cUnitTypeGeneralSahin, cUnitStateABQ) < 1) aiTaskUnitTrain(getUnit(gArtilleryDepotUnit), cUnitTypeGeneralSahin);
				
				break;
			}
			default:
			{
				mainCav = cUnitTypeLancer;
				mainCavlow = cUnitTypeHussar;
				antiCav = cUnitTypeDragoon;
				mainArt = cUnitTypexpHorseArtillery;
				mainArtlow = cUnitTypeFalconet;
				mainArtAnti = cUnitTypeCulverin;
				mainINF = cUnitTypeRodelero;
				mainINFlow = cUnitTypeMusketeer;
				antiHI = cUnitTypeSkirmisher;
				antiHIlow = cUnitTypeCrossbowman;
				antiLI = cUnitTypePikeman;
				antiLIlow = cUnitTypeMusketeer;
				antiLC = cUnitTypeSkirmisher;
				antiLClow = cUnitTypeCrossbowman;
				antiCAVINF = cUnitTypePikeman;
				antiCAVlow = cUnitTypeMusketeer;
				baseCavAnti = cUnitTypePikeman;

				if (gCurrentAge > cAge3)
				{
					antiHIlow = cUnitTypeSkirmisher;
					antiLClow = cUnitTypeSkirmisher;
				}
				if (gCurrentAge < cAge3)
				{
					mainINF = cUnitTypeMusketeer;
				}
				break;
			}

	}
					//Debug
	if(gDebugMessage == true)
	{
		
		if(kbProtoUnitAvailable(mainCav) == false) debugRule("militaryTrainManager - mainCav",0);
		if(kbProtoUnitAvailable(mainCavlow) == false) debugRule("militaryTrainManager - mainCavlow",0);
		if(kbProtoUnitAvailable(antiCav) == false) debugRule("militaryTrainManager - antiCav",0); 
		if(kbProtoUnitAvailable(mainArt) == false) debugRule("militaryTrainManager - mainArt",0);
		if(kbProtoUnitAvailable(mainArtlow) == false) debugRule("militaryTrainManager - mainArtlow",0);
		if(kbProtoUnitAvailable(mainArtAnti) == false) debugRule("militaryTrainManager - mainArtAnti",0);
		if(kbProtoUnitAvailable(mainINF) == false) debugRule("militaryTrainManager - mainINF",0);
		if(kbProtoUnitAvailable(mainINFlow) == false) debugRule("militaryTrainManager - mainINFlow",0);
		if(kbProtoUnitAvailable(antiHI) == false) debugRule("militaryTrainManager - antiHI",0);
		if(kbProtoUnitAvailable(antiHIlow) == false)debugRule("militaryTrainManager - antiHIlow",0);
		if(kbProtoUnitAvailable(antiLI) == false) debugRule("militaryTrainManager - antiLI",0);
		if(kbProtoUnitAvailable(antiLIlow) == false) debugRule("militaryTrainManager - antiLIlow",0); 
		if(kbProtoUnitAvailable(antiLC) == false) debugRule("militaryTrainManager - antiLC",0); 
		if(kbProtoUnitAvailable(antiLClow) == false) debugRule("militaryTrainManager - antiLClow",0);
		if(kbProtoUnitAvailable(antiCAVINF) == false) debugRule("militaryTrainManager - antiCAVINF",0);
		if(kbProtoUnitAvailable(antiCAVlow) == false) debugRule("militaryTrainManager - antiCAVlow",0);
		if(kbProtoUnitAvailable(baseCavAnti) == false) debugRule("militaryTrainManager - baseCavAnti",0);
	}
		
	
	if(baseCavAntiPlan == -1) 
	{
		baseCavAntiPlan = createSimpleMaintainPlan(baseCavAnti, 0, false, gMainBase, 10,baseCavAntiPlan);
		aiPlanSetActive(baseCavAntiPlan);
	}	
	
	if(antiHILowPlan == -1)
	{
		antiHILowPlan = createSimpleMaintainPlan(antiHIlow, 0, false, gMainBase, 10,antiHILowPlan);
		aiPlanSetActive(antiHILowPlan);
	}
		
	if(antiHIPlan == -1)
	{
		antiHIPlan = createSimpleMaintainPlan(antiHI, 0, false, gMainBase, 10,antiHIPlan);
		aiPlanSetActive(antiHIPlan);
	}
	if(antiLIlowPlan == -1)
	{
		antiLIlowPlan = createSimpleMaintainPlan(antiLIlow, 0, false, gMainBase, 10,antiLIlowPlan);
		aiPlanSetActive(antiLIlowPlan);
	}
	if(antiLIPlan == -1)
	{
		antiLIPlan = createSimpleMaintainPlan(antiLI, 0, false, gMainBase, 10,antiLIPlan);
		aiPlanSetActive(antiLIPlan);
	}
	if(antiLCPlan == -1)
	{
		antiLCPlan = createSimpleMaintainPlan(antiLC, 0, false, gMainBase, 10,antiLCPlan);
		aiPlanSetActive(antiLCPlan);
	}
	if(antiLClowPlan == -1)
	{
		antiLClowPlan = createSimpleMaintainPlan(antiLClow, 0, false, gMainBase, 10,antiLClowPlan);
		aiPlanSetActive(antiLClowPlan);
	}
	if(antiCavPlan == -1)
	{
		antiCavPlan = createSimpleMaintainPlan(antiCav, 0, false, gMainBase, 10,antiCavPlan);
		aiPlanSetActive(antiCavPlan);
	}
	if(mainCavlowPlan == -1)
	{
		mainCavlowPlan = createSimpleMaintainPlan(antiCAVlow, 0, false, gMainBase, 10,mainCavlowPlan);
		aiPlanSetActive(mainCavlowPlan);
	}
	if(antiCAVINFPlan == -1)
	{
		antiCAVINFPlan = createSimpleMaintainPlan(antiCAVINF, 0, false, gMainBase, 10,antiCAVINFPlan);
		aiPlanSetActive(antiCAVINFPlan);
	}
	if(mainArtAntiPlan == -1)
	{
		mainArtAntiPlan = createSimpleMaintainPlan(mainArtAnti, 0, false, gMainBase, 10,mainArtAntiPlan);
	}
	if(mainArtlowPlan == -1)
	{
		mainArtlowPlan = createSimpleMaintainPlan(mainArtlow, 0, false, gMainBase, 10,mainArtlowPlan);
		aiPlanSetActive(mainArtlowPlan);		
	}
	if(mainArtPlan == -1)
	{
		mainArtPlan = createSimpleMaintainPlan(mainArt, 0, false, gMainBase, 10,mainArtPlan);
		aiPlanSetActive(mainArtPlan);	
	}
	if(mainINFlowPlan == -1)
	{
		mainINFlowPlan = createSimpleMaintainPlan(mainINFlow, 0, false, gMainBase, 10,mainINFlowPlan);
		aiPlanSetActive(mainINFlowPlan);	
	}
	if(antiCAVlowPlan == -1)
	{
		antiCAVlowPlan = createSimpleMaintainPlan(mainCavlow, 0, false, gMainBase, 10,antiCAVlowPlan);
		aiPlanSetActive(antiCAVlowPlan);
	}
	if(mainINFPlan == -1)
	{
		mainINFPlan = createSimpleMaintainPlan(mainINF, 0, false, gMainBase, 10,mainINFPlan);
		aiPlanSetActive(mainINFPlan);
	}
	if(mainCavPlan == -1)
	{
		mainCavPlan = createSimpleMaintainPlan(mainCav, 0, false, gMainBase, 10,mainCavPlan);
		aiPlanSetActive(mainCavPlan);
	}
	
	int heavyInfantryCountEnemy = -1;
	int lightInfantryCountEnemy = -1;
	int lightCavalryCountEnemy = -1;
	int heavyCavalryCountEnemy = -1;
	int artilleryCountEnemy = -1;
	int totalEnemyCount = -1;
	int totalEnemyInfantryCount = -1;
	int totalCavEnemy = -1;
	int totalEnemyInfantry = -1;
	int enemyToCounter = -1;
	for (x = 1; < cNumberPlayers)
	{ //loop through players
		if (gPlayerTeam != kbGetPlayerTeam(x) && (x != cMyID) && kbHasPlayerLost(x) == false)
		{ //that are not on my team and is not me and are not dead
			enemyToCounter = x;
			heavyInfantryCountEnemy = heavyInfantryCountEnemy + kbUnitCount(enemyToCounter, cUnitTypeAbstractHeavyInfantry, cUnitStateAlive);
			lightInfantryCountEnemy = lightInfantryCountEnemy + kbUnitCount(enemyToCounter, cUnitTypeAbstractInfantry, cUnitStateAlive) - heavyInfantryCountEnemy;
			lightCavalryCountEnemy = lightCavalryCountEnemy + kbUnitCount(enemyToCounter, cUnitTypeAbstractLightCavalry, cUnitStateAlive) + kbUnitCount(enemyToCounter, cUnitTypexpEagleKnight, cUnitStateAlive); // Aztec eagle knights count as light cavalry
			heavyCavalryCountEnemy = heavyCavalryCountEnemy + kbUnitCount(enemyToCounter, cUnitTypeAbstractHeavyCavalry, cUnitStateAlive) + kbUnitCount(enemyToCounter, cUnitTypexpCoyoteMan, cUnitStateAlive); // Aztec coyote runners count as heavy cavalry
			artilleryCountEnemy = artilleryCountEnemy + kbUnitCount(enemyToCounter, cUnitTypeAbstractArtillery, cUnitStateAlive);
			totalEnemyCount = totalEnemyCount + lightInfantryCountEnemy + heavyInfantryCountEnemy + lightCavalryCountEnemy + heavyCavalryCountEnemy + artilleryCountEnemy;
			totalEnemyInfantryCount = totalEnemyInfantryCount + lightInfantryCountEnemy + heavyInfantryCountEnemy;
			totalCavEnemy = totalCavEnemy + lightCavalryCountEnemy + heavyCavalryCountEnemy;
			totalEnemyInfantry = totalEnemyInfantry + heavyInfantryCountEnemy + lightInfantryCountEnemy;
		}
	}
	int ratio = 1.0;
	int diff = 0;
	int unitCount = 0;
	float scoreLeft = 1.0;
	//cav
	
	static int enemyCavBase = -1;
	if(enemyCavBase == -1) 
	{
		enemyCavBase = kbUnitQueryCreate("enemyCavBase"+getQueryId());
		kbUnitQuerySetPlayerID(enemyCavBase,-1,false);
		kbUnitQuerySetPlayerRelation(enemyCavBase, cPlayerRelationEnemyNotGaia);
		kbUnitQuerySetUnitType(enemyCavBase, cUnitTypeAbstractCavalry);
		kbUnitQuerySetIgnoreKnockedOutUnits(enemyCavBase, true);
		kbUnitQuerySetState(enemyCavBase, cUnitStateAlive);
	}
	kbUnitQueryResetResults(enemyCavBase);
	kbUnitQuerySetPosition(enemyCavBase, gMainBaseLocation);
	kbUnitQuerySetMaximumDistance(enemyCavBase, 30.0);
	
	if (kbUnitQueryExecute(enemyCavBase) > 15)
	{ //defend the base with anti cav
		if (kbProtoUnitAvailable(baseCavAnti) == true && scoreLeft > 0)
		{
			baseCavAntiValue = 1.0;
			scoreLeft = 0.0;
		}
	}

	unitCount = kbUnitCount(cMyID, antiHI, cUnitStateABQ) + kbUnitCount(cMyID, antiHIlow, cUnitStateABQ);
	if (heavyInfantryCountEnemy > unitCount && kbUnitCount(cMyID, gBarracksUnit, cUnitStateAlive) != 0)
	{ //counter HI

		diff = heavyInfantryCountEnemy - unitCount;
		if (diff < 15)
		{ // use low couter
			if (kbProtoUnitAvailable(antiHIlow) == true && scoreLeft > 0.0) antiHILowValue = armyRatio(diff);


			if (antiHILowValue > scoreLeft) antiHILowValue = scoreLeft;
			scoreLeft = scoreLeft - antiHILowValue;
		}
		else
		{
			if (kbProtoUnitAvailable(antiHI) == true && scoreLeft > 0) antiHIValue = armyRatio(diff);
			if (antiHIValue > scoreLeft) antiHIValue = scoreLeft;
			scoreLeft = scoreLeft - antiHIValue;
		}

	}
	if(gNationalRedoubtEnabled == true && kbUnitCount(cMyID, cUnitTypeStrelet, cUnitStateAlive) == 0)
	{
		antiHIlow = 1.0; 
		scoreLeft = scoreLeft - antiHIlow;
	}
	

	unitCount = kbUnitCount(cMyID, antiCav, cUnitStateABQ);
	if (totalCavEnemy > unitCount && kbUnitCount(cMyID, gStableUnit, cUnitStateAlive) != 0)
	{
		diff = totalCavEnemy - unitCount;
		if (kbProtoUnitAvailable(antiCav) == true && scoreLeft > 0) antiCavValue = armyRatio(diff);
		if (antiCavValue > scoreLeft) antiCavValue = scoreLeft;
		scoreLeft = scoreLeft - antiCavValue;
	}

	unitCount = kbUnitCount(cMyID, mainCavlow, cUnitStateABQ);
	if (artilleryCountEnemy > unitCount && kbUnitCount(cMyID, gStableUnit, cUnitStateAlive) != 0)
	{
		diff = artilleryCountEnemy - unitCount;
		if (kbProtoUnitAvailable(mainCavlow) == true && scoreLeft > 0) mainCavlowValue = armyRatio(diff);
		if (mainCavlowValue > scoreLeft) mainCavlowValue = scoreLeft;
		scoreLeft = scoreLeft - mainCavlowValue;
	}

	unitCount = kbUnitCount(cMyID, antiLI, cUnitStateABQ) + kbUnitCount(cMyID, antiLIlow, cUnitStateABQ);
	if (lightInfantryCountEnemy > unitCount && kbUnitCount(cMyID, gBarracksUnit, cUnitStateAlive) != 0)
	{
		diff = heavyInfantryCountEnemy - unitCount;
		if (diff < 15)
		{
			if (kbProtoUnitAvailable(antiLIlow) == true && scoreLeft > 0) antiLIlowValue = armyRatio(diff);
			if (antiLIlowValue > scoreLeft) antiLIlowValue = scoreLeft;
			scoreLeft = scoreLeft - antiLIlowValue;
		}
		else
		{
			if (kbProtoUnitAvailable(antiLI) == true && scoreLeft > 0) antiLIValue = armyRatio(diff);
			if (antiLIValue > scoreLeft) antiLIValue = scoreLeft;
			scoreLeft = scoreLeft - antiLIValue;
		}

	}

	unitCount = kbUnitCount(cMyID, antiCAVINF, cUnitStateABQ) + kbUnitCount(cMyID, antiCAVlow, cUnitStateABQ);
	if (heavyCavalryCountEnemy > unitCount && kbUnitCount(cMyID, gStableUnit, cUnitStateAlive) != 0)
	{
		diff = heavyCavalryCountEnemy - unitCount;
		if (diff < 15)
		{
			if (kbProtoUnitAvailable(antiCAVlow) == true && scoreLeft > 0) antiCAVlowValue = armyRatio(diff);
			if (antiCAVlowValue > scoreLeft) antiCAVlowValue = scoreLeft;
			scoreLeft = scoreLeft - antiCAVlowValue;
		}
		else
		{
			if (kbProtoUnitAvailable(antiCAVINF) == true && scoreLeft > 0) antiCAVINFValue = armyRatio(diff);
			if (antiCAVINFValue > scoreLeft) antiCAVINFValue = scoreLeft;
			scoreLeft = scoreLeft - antiCAVINFValue;
		}
	}

	unitCount = kbUnitCount(cMyID, antiLC, cUnitStateABQ) + kbUnitCount(cMyID, antiLClow, cUnitStateABQ);
	if (lightCavalryCountEnemy > unitCount && kbUnitCount(cMyID, gStableUnit, cUnitStateAlive) != 0)
	{
		diff = heavyCavalryCountEnemy - unitCount;
		if (diff < 15)
		{
			if (kbProtoUnitAvailable(antiLClow) == true && scoreLeft > 0) antiLClowValue = armyRatio(diff);
			if (antiLClowValue > scoreLeft) antiLClowValue = scoreLeft;
			scoreLeft = scoreLeft - antiLClowValue;
		}
		else
		{
			if (kbProtoUnitAvailable(antiLC) == true && scoreLeft > 0) antiLCValue = armyRatio(diff);
			if (antiLCValue > scoreLeft) antiLCValue = scoreLeft;
			scoreLeft = scoreLeft - antiLCValue;
		}
	}

	unitCount = kbUnitCount(cMyID, mainArt, cUnitStateABQ);
	unitCount = unitCount * 3;
	if (totalEnemyInfantry > unitCount && kbUnitCount(cMyID, gArtilleryDepotUnit, cUnitStateAlive) != 0)
	{
		diff = totalEnemyInfantry - unitCount;
		//diff = diff / 2;
		if (kbProtoUnitAvailable(mainArt) == true && scoreLeft > 0)
		{
			mainArtValue = armyRatio(diff);
			if (mainArtValue > scoreLeft) mainArtValue = scoreLeft;
			scoreLeft = scoreLeft - mainArtValue;

		}
		else
		{
			if (kbProtoUnitAvailable(mainArtlowValue) == true && scoreLeft > 0) mainArtlowValue = armyRatio(diff);
			if (mainArtlowValue > scoreLeft) mainArtlowValue = scoreLeft;
			scoreLeft = scoreLeft - mainArtlowValue;

		}
	}

	unitCount = kbUnitCount(cMyID, mainArtAnti, cUnitStateABQ);
	if (artilleryCountEnemy > unitCount && kbUnitCount(cMyID, gArtilleryDepotUnit, cUnitStateAlive) != 0)
	{
		diff = artilleryCountEnemy - unitCount;
		if (kbProtoUnitAvailable(mainArtAnti) == true && scoreLeft > 0) mainArtAntiValue = armyRatio(diff);
		//if(mainArtAntiValue > 0.3) mainArtAntiValue = 0.3;
		if (mainArtAntiValue > scoreLeft) mainArtAntiValue = scoreLeft;
		scoreLeft = scoreLeft - mainArtAntiValue;
	}

	//inf
	unitCount = kbUnitCount(cMyID, mainINF, cUnitStateABQ);
	if (totalEnemyInfantryCount > unitCount && kbUnitCount(cMyID, gBarracksUnit, cUnitStateAlive) != 0)
	{
		diff = totalEnemyInfantryCount - unitCount;

		if (diff < 15)
		{
			if (kbProtoUnitAvailable(mainINFlow) == true && scoreLeft > 0) mainINFlowValue = armyRatio(diff);
			scoreLeft = scoreLeft - mainINFlowValue;
		}
		else if (kbProtoUnitAvailable(mainINF) == true && scoreLeft > 0)
		{
			if (kbProtoUnitAvailable(mainINF) == true && scoreLeft > 0) mainINFValue = armyRatio(diff);
			scoreLeft = scoreLeft - mainINFValue;

		}
	}

	if (kbProtoUnitAvailable(mainCav) == true && scoreLeft > 0 && kbUnitCount(cMyID, gStableUnit, cUnitStateAlive) != 0)
	{
		mainCavValue = scoreLeft;
		scoreLeft = 0.0;
	}
	else
	{
		if (kbProtoUnitAvailable(mainCavlow) == true && scoreLeft > 0 && kbUnitCount(cMyID, gStableUnit, cUnitStateAlive) != 0)
		{
			mainCavlowValue = scoreLeft;
			scoreLeft = 0.0;
		}
	}
	if ((gCurrentFood < 400 && kbGetCiv() != cCivDutch) || (gCurrentCoin < 200 && kbGetCiv() == cCivDutch) || (gCurrentWood < 400 && kbGetCiv() == cCivDutch))
	{
		mainCavValue = 0.0;
		mainCavlowValue = 0.0;
		antiCavValue = 0.0;
		mainArtValue = 0.0;
		mainArtlowValue = 0.0;
		mainArtAntiValue = 0.0;
		mainINFValue = 0.0;
		mainINFlowValue = 0.0;
		antiHIValue = 0.0;
		antiHILowValue = 0.0;
		antiLIValue = 0.0;
		antiLIlowValue = 0.0;
		antiLCValue = 0.0;
		antiLClowValue = 0.0;
		antiCAVINFValue = 0.0;
		antiCAVlowValue = 0.0;
		baseCavAntiValue = 0.0;
	}
	if (kbUnitCount(aiGetMostHatedPlayerID(), cUnitTypeAbstractArtillery, cUnitStateAlive) > 10 )
	{
		mainCavValue = 0.5;
		mainCavlowValue = 0.0;
		antiCavValue = 0.0;
		mainArtValue = 0.0;
		mainArtlowValue = 0.0;
		mainArtAntiValue = 0.5;
		mainINFValue = 0.0;
		mainINFlowValue = 0.0;
		antiHIValue = 0.0;
		antiHILowValue = 0.0;
		antiLIValue = 0.0;
		antiLIlowValue = 0.0;
		antiLCValue = 0.0;
		antiLClowValue = 0.0;
		antiCAVINFValue = 0.0;
		antiCAVlowValue = 0.0;
		baseCavAntiValue = 0.0;
	}



	if(	gCurrentAge < cAge4 && gCurrentGameTime > 900000 && kbBaseGetUnderAttack(cMyID,gMainBase) == false)
	{
		aiPlanSetVariableInt(baseCavAntiPlan, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(antiHILowPlan, cTrainPlanNumberToMaintain, 0,0);
		aiPlanSetVariableInt(antiHIPlan, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(antiLIlowPlan, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(antiLIPlan, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(antiLCPlan, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(antiLClowPlan, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(antiCavPlan, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(mainCavlowPlan, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(antiCAVINFPlan, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(mainArtAntiPlan, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(mainArtlowPlan, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(mainArtPlan, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(mainINFlowPlan, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(antiCAVlowPlan, cTrainPlanNumberToMaintain, 0,0);
		aiPlanSetVariableInt(mainINFPlan, cTrainPlanNumberToMaintain, 0, 0);
		aiPlanSetVariableInt(mainCavPlan, cTrainPlanNumberToMaintain, 0, 0);
		return;
	}
	
	
	static int rushForcast = -1;
	
	if(gOpeningStrategy == 1 && gCurrentGameTime < 1200000) //20 mins
	{
		aiPlanSetVariableInt(mainINFPlan, cTrainPlanNumberToMaintain, 0, 100);
		aiPlanSetVariableInt(mainCavPlan, cTrainPlanNumberToMaintain, 0, 5);
		if(rushForcast == -1)
		{
			rushForcast = 0;
		}
		return;
	}
	
	
	if(gOpeningStrategy == 2 && gCurrentAge < cAge3)
	{
		aiPlanSetVariableInt(mainINFPlan, cTrainPlanNumberToMaintain, 0, 5);
		aiPlanSetVariableInt(mainCavPlan, cTrainPlanNumberToMaintain, 0, 5);
		return;
	}
	
	if (gCurrentAge < cAge3)
	{
		aiPlanSetVariableInt(mainINFPlan, cTrainPlanNumberToMaintain, 0, 10);
		aiPlanSetVariableInt(mainCavPlan, cTrainPlanNumberToMaintain, 0, 5);
	}
	else
	{
		pfmilitaryTrainManager_bufferCheck(baseCavAntiPlan, (millPop * baseCavAntiValue), baseCavAnti);
		pfmilitaryTrainManager_bufferCheck(antiHILowPlan, (millPop * antiHILowValue), antiHIlow);	
		pfmilitaryTrainManager_bufferCheck(antiHIPlan, (millPop * antiHIValue), antiHI);
		pfmilitaryTrainManager_bufferCheck(antiLIlowPlan, (millPop * antiLIlowValue), antiLIlow);
		pfmilitaryTrainManager_bufferCheck(antiLIPlan, (millPop * antiLIValue), antiLI);
		pfmilitaryTrainManager_bufferCheck(antiLCPlan, (millPop * antiLCValue), antiLC);
		pfmilitaryTrainManager_bufferCheck(antiLClowPlan, (millPop * antiLClowValue), antiLClow);
		pfmilitaryTrainManager_bufferCheck(antiCavPlan, (millPop * antiCavValue), antiCav);
		pfmilitaryTrainManager_bufferCheck(mainCavlowPlan, (millPop * antiCAVlowValue), antiCAVlow);
		pfmilitaryTrainManager_bufferCheck(antiCAVINFPlan, (millPop * antiCAVINFValue), antiCAVINF);
		pfmilitaryTrainManager_bufferCheck(mainArtAntiPlan, (millPop * mainArtAntiValue), mainArtAnti);
		pfmilitaryTrainManager_bufferCheck(mainArtlowPlan, (millPop * mainArtlowValue), mainArtlow);
		pfmilitaryTrainManager_bufferCheck(mainArtPlan, (millPop * mainArtValue), mainArt);
		pfmilitaryTrainManager_bufferCheck(mainINFlowPlan, (millPop * mainINFlowValue), mainINFlow);
		pfmilitaryTrainManager_bufferCheck(antiCAVlowPlan, (millPop * mainCavlowValue), mainCavlow);
		pfmilitaryTrainManager_bufferCheck(mainINFPlan, (millPop * mainINFValue), mainINF);
		pfmilitaryTrainManager_bufferCheck(mainCavPlan, (millPop * mainCavValue ), mainCav);

		static int getbarracks = -1;
		if (getbarracks == -1) 
		{
			getbarracks = kbUnitQueryCreate("getbarracks"+getQueryId());
			kbUnitQuerySetPlayerID(getbarracks,cMyID,false);
			kbUnitQuerySetPlayerRelation(getbarracks, -1);
			kbUnitQuerySetUnitType(getbarracks, gBarracksUnit);
			kbUnitQuerySetIgnoreKnockedOutUnits(getbarracks, true);
			kbUnitQuerySetState(getbarracks, cUnitStateAlive);
		}	
		kbUnitQueryResetResults(getbarracks);
		int pNumBarracks = kbUnitQueryExecute(getbarracks);
		for (index = 0; < pNumBarracks)
		{
			int unitID = kbUnitQueryGetResult(getbarracks, index);
			aiTaskUnitTrain(unitID, mainINF);
			aiTaskUnitTrain(unitID, mainINF);
			aiTaskUnitTrain(unitID, mainINF);
			aiTaskUnitTrain(unitID, mainINF);
			aiTaskUnitTrain(unitID, mainINF);

	}

	return;
		
	}
}





//rule militaryManager
//active
//minInterval 30 //30
void militaryManager()
{
	static bool init = false; // Flag to indicate vars, plans are initialized
	int i = 0;
	int proto = 0;
	int planID = -1;
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 60000,"militaryManager") == false) return;
	lastRunTime = gCurrentGameTime;	
	

	if(gMainAttackGoal == -1)
	{
		gMainAttackGoal = createSimpleAttackGoal("AttackGoal", aiGetMostHatedPlayerID(), gLandUnitPicker, -1, cAge2, cAge5, gMainBase, false);
		aiPlanSetVariableInt(gMainAttackGoal, cGoalPlanReservePlanID, 0, gLandReservePlan);
	}
	


	militaryTrainManager();
	return;
	if (kbGetCiv() != cCivMaltese && kbGetCiv() != cCivColombians)
	{
		militaryTrainManager();
	}
	else
	{
		if (init == true)
		{
			// Need to initialize, if we're allowed to.
			if (cvOkToTrainArmy == true)
			{
				init = false;
				//if (cvNumArmyUnitTypes >= 0)
				//gNumArmyUnitTypes = cvNumArmyUnitTypes;
				//else
				gNumArmyUnitTypes = 19;
				gLandUnitPicker = initUnitPicker("Land military units", gNumArmyUnitTypes, 1, 60, -1, -1, 1, true);

				// now the goal
				// wmj -- hard coded for now, but this should most likely ramp up as the ages progress
				//aiSetMinArmySize(15);
				aiPlanDestroy(gMainAttackGoal);
				gMainAttackGoal = createSimpleAttackGoal("AttackGoal", aiGetMostHatedPlayerID(), gLandUnitPicker, -1, cAge2, -1, gMainBase, false);
				aiPlanSetVariableInt(gMainAttackGoal, cGoalPlanReservePlanID, 0, gLandReservePlan);
			}
		}
	}



	/*
		//static bool init = false;   // Flag to indicate vars, plans are initialized
		int i = 0;
		int proto = 0;
		int planID = -1;
		
		// if (init == false)
		//{  
		if (newAttackGoal == -1)
		{     
		//newAttackGoal = 0;
		aiPlanDestroyByName("AttackGoal");
		// Need to initialize, if we're allowed to.
		if (cvOkToTrainArmy == true)
		{
		
		
		//				init = true;
		if (cvNumArmyUnitTypes >= 0)
		gNumArmyUnitTypes = cvNumArmyUnitTypes;
		else
		gNumArmyUnitTypes = 19;
		
		gLandUnitPicker = initUnitPicker("Land military units", gNumArmyUnitTypes, 1, 60, -1, -1, 1, true); 
		
		
		// now the goal
		// wmj -- hard coded for now, but this should most likely ramp up as the ages progress
		//aiSetMinArmySize(15);
		
		gMainAttackGoal = createSimpleAttackGoal("AttackGoal", aiGetMostHatedPlayerID(), gLandUnitPicker, -1, cAge2, -1, gMainBase, false);
		aiPlanSetVariableInt(gMainAttackGoal, cGoalPlanReservePlanID, 0, gLandReservePlan);
		}
		}
		//}
	*/
	//updatedOn 2019/05/10 By ageekhere  
	//---------------------------
	if (gLandUnitPicker != -1)
	{
		setUnitPickerPreference(gLandUnitPicker); // Update preferences in case btBiasEtc vars have changed, or cvPrimaryArmyUnit has changed.

		if (gAiRevolted == true)
		{
			kbUnitPickSetMinimumNumberUnits(gLandUnitPicker, 10);
			kbUnitPickSetMaximumNumberUnits(gLandUnitPicker, 300);
		}
		else if (gCurrentAge == cAge2)
		{
			kbUnitPickSetMinimumNumberUnits(gLandUnitPicker, 20);
			kbUnitPickSetMaximumNumberUnits(gLandUnitPicker, 300);
		}
		else if (gCurrentAge == cAge3)
		{
			kbUnitPickSetMinimumNumberUnits(gLandUnitPicker, 60);
			kbUnitPickSetMaximumNumberUnits(gLandUnitPicker, 300);
		}
		else if (gCurrentAge == cAge4)
		{
			kbUnitPickSetMinimumNumberUnits(gLandUnitPicker, 80);
			kbUnitPickSetMaximumNumberUnits(gLandUnitPicker, 300);
		}
		else if (gCurrentAge == cAge5)
		{
			kbUnitPickSetMinimumNumberUnits(gLandUnitPicker, 100);
			kbUnitPickSetMaximumNumberUnits(gLandUnitPicker, 300);
			//kbUnitPickSetMaximumNumberUnits(gLandUnitPicker, 90);
		}
	}
	//---------------------------

	switch (gCurrentAge)
	{
		case cAge1:
			{
				break;
			}
		case cAge2:
			{
				aiSetMinArmySize(20); // Now irrelevant?  (Was used to determine when to launch attack, but attack goal and opp scoring now do this.)
				break;
			}
		case cAge3:
			{
				aiSetMinArmySize(60);
				break;
			}
		case cAge4:
			{
				aiSetMinArmySize(80); //25
				break;
			}
		case cAge5:
			{
				aiSetMinArmySize(100); //30
				break;
			}
	}
}

//==============================================================================
/*
 econManager
 updatedOn 2022/09/02
 Performs top-level economic analysis and direction.   Generally called
 by the econManagerRule, it can be called directly for special-event processing.
 econManagerRule calls it with default parameters, directing it to do a full
 reanalysis. 
 
 How to use
 Call econManager and pass mode and value

 Example
 econManager(mode, value );
*/
//==============================================================================
void econManager(int mode = -1, int value = -1)
{
	debugRule("econManager",-1);
	setResources(); // Monitor main base supply of food and gold, activate farming and plantations when resources run low
	setForecasts(); // Update forecasts for economic and military expenses.  Set resource
	debugRule("econManager",-0);
}
//rule monopolyManager
//minInterval 21
//inactive
//group tcComplete
void monopolyManager()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"monopolyManager") == false) return;
	lastRunTime = gCurrentGameTime;
	
	if (aiTreatyActive() == true)
	{
		//aiEcho("    Monopoly delayed because treaty is active.");
		return;
	}
	if (aiIsMonopolyAllowed() == false)
	{
		//aiEcho("    Monopoly not allowed, terminating rule.");
		//xsDisableSelf();
		return;
	}
	if (kbUnitCount(cMyID, gTradingPostUnit, cUnitStateAlive) < 1)
		return; // Not allowed to research without a building...

	if (aiReadyForTradeMonopoly() == true)
	{
		//aiEcho("      Trade monopoly is available.");
		if (gCurrentCoin >= kbTechCostPerResource(cTechTradeMonopoly, cResourceGold) &&
			gCurrentFood >= kbTechCostPerResource(cTechTradeMonopoly, cResourceFood) &&
			gCurrentWood >= kbTechCostPerResource(cTechTradeMonopoly, cResourceWood)
		)
		{
			//aiEcho("    Attempting trade monopoly");
			if (aiDoTradeMonopoly() == true)
				kbEscrowAllocateCurrentResources();
		}
		else
		{
			aiEcho("    ....but I can't afford it.");
		}
	}
}
//rule minorTribeTechMonitor
//inactive
//minInterval 90
void minorTribeTechMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 60000,"minorTribeTechMonitor") == false) return;
	lastRunTime = gCurrentGameTime;
	
	int techPlanID = -1;

	// Get techs from different minor tribes one at a time as they become available
	// Unavailable tribes and techs are simply ignored
	// Research plans are "blindly" tried at different trading posts as there is no way to 
	// identify specific trading posts in the AI script

	// Apache techs
	if (kbTechGetStatus(cTechNatXPApacheCactus) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPApacheCactus);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPApacheCactus, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatXPApacheRaiding) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPApacheRaiding);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPApacheRaiding, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatXPApacheEndurance) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPApacheEndurance);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPApacheEndurance, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}

	// Carib techs
	if ((kbTechGetStatus(cTechNatCeremonialFeast) == cTechStatusObtainable) &&
		(kbUnitCount(cMyID, cUnitTypeNatBlowgunWarrior, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatBlowgunAmbusher, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeNatMercBlowgunWarrior, cUnitStateAlive) >= 10))
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatCeremonialFeast);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatCeremonialFeast, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatKasiriBeer) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatKasiriBeer);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatKasiriBeer, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatCeremonialFeast) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatCeremonialFeast);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatCeremonialFeast, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}

	// Cherokee techs
	if (kbTechGetStatus(cTechNatBasketweaving) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatBasketweaving);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatBasketweaving, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatSequoyahSyllabary) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatSequoyahSyllabary);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatSequoyahSyllabary, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatWarDance) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatWarDance);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatWarDance, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}

	// Cheyenne techs
	if (kbTechGetStatus(cTechNatXPCheyenneHuntingGrounds) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPCheyenneHuntingGrounds);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPCheyenneHuntingGrounds, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatXPCheyenneHorseTrading) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPCheyenneHorseTrading);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPCheyenneHorseTrading, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatXPCheyenneFury) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPCheyenneFury);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPCheyenneFury, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}

	// Comanche techs
	if (kbTechGetStatus(cTechNatTradeLanguage) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatTradeLanguage);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatTradeLanguage, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatHorseBreeding) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatHorseBreeding);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatHorseBreeding, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatMustangs) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatMustangs);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatMustangs, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}

	// Cree techs
	if (kbTechGetStatus(cTechNatTextileCraftsmanship) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatTextileCraftsmanship);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatTextileCraftsmanship, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatTanning) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatTanning);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatTanning, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}

	// Huron techs
	if ((kbTechGetStatus(cTechNatXPHuronTradeMonopoly) == cTechStatusObtainable) &&
		(gCurrentGameTime > 20 * 60 * 1000)) // Use only after at least 20 minutes of game time (i.e. 10 units)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPHuronTradeMonopoly);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPHuronTradeMonopoly, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}

	// Inca techs
	if (kbTechGetStatus(cTechNatMetalworking) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatMetalworking);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatMetalworking, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatChasquisMessengers) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatChasquisMessengers);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatChasquisMessengers, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatRoadbuilding) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatRoadbuilding);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatRoadbuilding, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}

	// Klamath techs
	if (kbTechGetStatus(cTechNatXPKlamathWorkEthos) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPKlamathWorkEthos);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPKlamathWorkEthos, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatXPKlamathStrategy) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPKlamathStrategy);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPKlamathStrategy, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechNatXPKlamathHuckleberryFeast) == cTechStatusObtainable) &&
		(gCurrentGameTime > 21 * 60 * 1000)) // Use only after at least 21 minutes of game time (i.e. 7 crates)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPKlamathHuckleberryFeast);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPKlamathHuckleberryFeast, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}

	// Mapuche techs
	if (kbTechGetStatus(cTechNatXPMapucheTactics) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPMapucheTactics);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPMapucheTactics, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatXPMapucheAdMapu) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPMapucheAdMapu);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPMapucheAdMapu, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechNatXPMapucheTreatyOfQuillin) == cTechStatusObtainable) &&
		(gCurrentGameTime > 20 * 60 * 1000)) // Use only after at least 20 minutes of game time (i.e. 10 crates)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPMapucheTreatyOfQuillin);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPMapucheTreatyOfQuillin, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}

	// Maya techs
	if (kbTechGetStatus(cTechNatCalendar) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatCalendar);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatCalendar, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatCottonArmor) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatCottonArmor);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatCottonArmor, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}

	// Navajo techs
	if (kbTechGetStatus(cTechNatXPNavajoCraftsmanship) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPNavajoCraftsmanship);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPNavajoCraftsmanship, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}

	// Seminole techs
	if (kbTechGetStatus(cTechNatBowyery) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatBowyery);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatBowyery, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}

	// Tupi techs
	if (kbTechGetStatus(cTechNatPoisonArrowFrogs) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatPoisonArrowFrogs);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatPoisonArrowFrogs, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatForestBurning) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatForestBurning);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatForestBurning, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}

	// Zapotec techs
	if (kbTechGetStatus(cTechNatXPZapotecCultOfTheDead) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPZapotecCultOfTheDead);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPZapotecCultOfTheDead, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechNatXPZapotecFoodOfTheGods) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPZapotecFoodOfTheGods);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPZapotecFoodOfTheGods, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechNatXPZapotecCloudPeople) == cTechStatusObtainable) &&
		(gCurrentGameTime > 20 * 60 * 1000)) // Use only after at least 20 minutes of game time (i.e. 10 crates)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechNatXPZapotecCloudPeople);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechNatXPZapotecCloudPeople, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}
}

//rule minorAsianTribeTechMonitor
//inactive
//minInterval 90
void minorAsianTribeTechMonitor()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 60000,"minorAsianTribeTechMonitor") == false) return;
	lastRunTime = gCurrentGameTime;
	
	int techPlanID = -1;

	// Get techs from different minor Asian tribes one at a time as they become available
	// Unavailable tribes and techs are simply ignored
	// Research plans are "blindly" tried at different trading posts as there is no way to 
	// identify specific trading posts in the AI script

	// Bhakti techs
	if (kbTechGetStatus(cTechYPNatBhaktiYoga) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechYPNatBhaktiYoga);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechYPNatBhaktiYoga, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechYPNatBhaktiReinforcedGuantlets) == cTechStatusObtainable) && (gCurrentAge > cAge3) && (kbUnitCount(cMyID, cUnitTypeypNatTigerClaw, cUnitStateAlive) >= 10))
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechYPNatBhaktiReinforcedGuantlets);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechYPNatBhaktiReinforcedGuantlets, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}

	// Jesuit techs
	if (kbTechGetStatus(cTechYPNatJesuitSmokelessPowder) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechYPNatJesuitSmokelessPowder);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechYPNatJesuitSmokelessPowder, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechYPNatJesuitFlyingButtress) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechYPNatJesuitFlyingButtress);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechYPNatJesuitFlyingButtress, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}

	// Shaolin techs
	if (kbTechGetStatus(cTechYPNatShaolinWoodClearing) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechYPNatShaolinWoodClearing);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechYPNatShaolinWoodClearing, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechYPNatShaolinClenchedFist) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechYPNatShaolinClenchedFist);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechYPNatShaolinClenchedFist, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechYPNatShaolinDimMak) == cTechStatusObtainable) && (gCurrentAge > cAge3) && (kbUnitCount(cMyID, cUnitTypeypNatRattanShield, cUnitStateAlive) >= 10))
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechYPNatShaolinDimMak);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechYPNatShaolinDimMak, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}

	// Sufi techs
	if (kbTechGetStatus(cTechYPNatSufiFasting) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechYPNatSufiFasting);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechYPNatSufiFasting, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}

	// Udasi techs
	if (kbTechGetStatus(cTechYPNatUdasiNewYear) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechYPNatUdasiNewYear);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechYPNatUdasiNewYear, getUnit(gTradingPostUnit), cEconomyEscrowID, 50);
		return;
	}
	if (kbTechGetStatus(cTechYPNatUdasiGurus) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechYPNatUdasiGurus);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechYPNatUdasiGurus, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
	if ((kbTechGetStatus(cTechYPNatUdasiArmyOfThePure) == cTechStatusObtainable) && (gCurrentAge > cAge3) && (kbUnitCount(cMyID, cUnitTypeypNatChakram, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypeypNatMercChakram, cUnitStateAlive) >= 10))
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechYPNatUdasiArmyOfThePure);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechYPNatUdasiArmyOfThePure, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}

	// Zen techs
	if (kbTechGetStatus(cTechYPNatZenMasterLessons) == cTechStatusObtainable)
	{
		techPlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechYPNatZenMasterLessons);
		if (techPlanID >= 0)
			aiPlanDestroy(techPlanID);
		createSimpleResearchPlan(cTechYPNatZenMasterLessons, getUnit(gTradingPostUnit), cMilitaryEscrowID, 50);
		return;
	}
}


//==============================================================================
/*
	autoSaveManager
	updatedOn 2023/01/12
	Creates an auto save for the current game
	
	How to use
	is auto called in mainRules
*/
//==============================================================================
void autoSaveManager(void)
{
	if (gAutoSaveStatus == false || cvDoAutoSaves == false) return; //Note: Because the user can turn on/off auto save in options we must check the value every time
	static int pAiSaver = -1; //The AI to do the save
	static int pSaveCount = 0; //The auto save id
	
	if(pAiSaver != -1 && getIsPlayerAlive(pAiSaver) == true && cMyID != pAiSaver) return; //if an AI has been found, is still in the game and current ai is not the found ai return

	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 300000,"autoSaveManager") == false) return; //save every 5 mins 300000
	lastRunTime = gCurrentGameTime;
	
	if(pAiSaver == -1 || getIsPlayerAlive(pAiSaver) == false)
	{ //Find an AI to do the save, happens when either ai is dead or on first run
		for (i = 1; <= cNumberPlayers)
		{ //start from player 1 to max players 8
			//if (kbIsPlayerHuman(i) || getIsPlayerAlive(i) == false ) continue; //skip humans and dead players
			if (xsArrayGetBool(gPlayerHumanStatusArray,i) || getIsPlayerAlive(i) == false ) continue; //skip humans and dead players
			
			pAiSaver = i; //save the found ai
			break;
		} //end for
	} //end if
	if(cMyID != pAiSaver) return; //an ai saver is found but it is not this ai, this check is needed for the first run or else all ai will make a save
	aiQueueAutoSavegame(pSaveCount);
	pSaveCount++;
} //end autoSaveManager

void autoSaveManagerold(void)
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 300000,"autoSaveManager") == false) return;
	lastRunTime = gCurrentGameTime;
	
	int interval = 2; // Interval in minutes
	static int nextTime = 0;

	// First, do an auto save game if needed
	//Dont save if we are told not to.
	if (gAutoSaveStatus == true)
	{
		int firstCPPlayerID = -1;
		for (i = 1; < cNumberPlayers)
		{
			//if (kbIsPlayerHuman(i) == true) continue;
			if (xsArrayGetBool(gPlayerHumanStatusArray,i) ) continue;
			firstCPPlayerID = i;
		}
		if ((cMyID == firstCPPlayerID) && (gCurrentGameTime >= nextTime) && (cvDoAutoSaves == true))
		{ // We're the first CP, it's our job to do the save, and it's time to do it.
			//Create the savegame name.
			static int psCount = 0;
			//Save it.
			if (cvDoAutoSaves == true)
			{
				aiQueueAutoSavegame(psCount);
				//Inc our count.
				psCount = psCount + interval; // Count roughly matches game time in minutes
				while (psCount < (gCurrentGameTime / 60000))
					psCount = psCount + interval; // Handle reloading of save games from machines that had saves off...
				nextTime = psCount * 60 * 1000;
			}
		}
	}
}
//==============================================================================
// tradeRouteFinder
/*
Stores all the trade post socket sites into there correct trade roots	
*/
// updatedOn 2022/02/09 By ageekhere
//==============================================================================
extern int tradeRoot1 = -1; //Trade Root 1 Array
extern int tradeRoot2 = -1; //Trade Root 2 Array
extern int tradeRoomCheckNumber = 2; //Trade Root 2 Array
extern int tradeRootArrayLength = 11; //Trade Root 2 Array
extern bool tradeRouteFinderDone = false; //Finder done
rule tradeRouteManager
active
minInterval 2
{ //Finds all the trade post sockets
	static bool lookatMap = true;
	if(lookatMap == true)
	{
		kbLookAtAllUnitsOnMap(); //Needed for seeing all the trade post sockets
		lookatMap = false;
	}
	if (cRandomMapName == "silkroad")
	{
		xsDisableSelf();
		return;
	}
	if (kbUnitCount(0, cUnitTypeTravois, cUnitStateAlive) == 0)
	{ //Check if the map has any Travois
		xsDisableSelf();
		return;
	} //end if
	static bool inarray = false; //A check to see if VP site is in an array
	static int numberFound = -1; //Number of Travois found
	static int travoisQuery = -1; //The id holder for Travois
	static int travoisID = -1; //The Trade Query ID
	static int tradeRootNum = -1; //Current trade root
	static int socketCount = 0; //Count number of trade root sockets
	static int VPadded = 0; //Couting Added VP sites
	static int socketQuery = -1; //socket Query
	static int socketID = -1; //VP id 	
	if (tradeRoot1 == -1)
	{ //Create a new Array for holding all the VP sites for each root
		tradeRoot1 = xsArrayCreateInt(tradeRootArrayLength, -1, "Trade root 1 sockets"); //Trade root 1
		tradeRoot2 = xsArrayCreateInt(tradeRootArrayLength, -1, "Trade root 2 sockets"); //Trade root 2
	} //end if
	if (socketQuery == -1) 
	{
		socketQuery = kbUnitQueryCreate("socketQuery"+getQueryId()); //Create a new TradePost Socket unit Query
		kbUnitQuerySetPlayerID(socketQuery, 0,false); //set player to 0
		kbUnitQuerySetPlayerRelation(socketQuery, -1);
		kbUnitQuerySetUnitType(socketQuery, cUnitTypeTradePostSocket); //find unit
		kbUnitQuerySetState(socketQuery, cUnitStateAny); //set state
	}
	kbUnitQueryResetResults(socketQuery);
	
	for (j = 0; < kbUnitQueryExecute(socketQuery))
	{ //Loop through all the sockets	
		//socketID = kbUnitQueryGetResult(socketQuery, j); //get socket ID
		if (kbGetProtoUnitName(kbUnitGetProtoUnitID(kbUnitQueryGetResult(socketQuery, j))) == "SocketTradeRoute") socketCount++; //Check if the socket has a name of SocketTradeRoute and update the socket count
	} //end for j

	if (travoisQuery == -1) 
	{
		travoisQuery = kbUnitQueryCreate("travoisQuery"+getQueryId()); //Create a new Travois unit Query
		kbUnitQuerySetPlayerID(travoisQuery, 0,false); //set player to 0
		kbUnitQuerySetPlayerRelation(travoisQuery, -1);
		kbUnitQuerySetUnitType(travoisQuery, cUnitTypeTravois); //find unit
		kbUnitQuerySetState(travoisQuery, cUnitStateAny); //set state
	}
	kbUnitQueryResetResults(travoisQuery); //reset the results

	numberFound = kbUnitQueryExecute(travoisQuery); //store the number found, each unit should be a new root
	for (i = 0; < kbUnitQueryExecute(travoisQuery))
	{ //Loop through all the found Travois 		
		travoisID = kbUnitQueryGetResult(travoisQuery, i); //get the id of the Travois
		if (kbUnitGetPosition(travoisID) == cInvalidVector) continue; //Check if the Travois has a vaild location		
		for (j = 0; < kbUnitQueryExecute(socketQuery))
		{ //Loop through all the socket sites	
			inarray = false; //Set the inarray flag
			socketID = kbUnitQueryGetResult(socketQuery, j); //get the id of the socket
			if (kbGetProtoUnitName(kbUnitGetProtoUnitID(socketID)) != "SocketTradeRoute") continue; //Check if the socket has a name of SocketTradeRoute
			if (distance(kbUnitGetPosition(travoisID), kbUnitGetPosition(socketID)) < 30)
			{ //Check if the distance of the travois and socket is less then 30
				for (k = 0; < numberFound)
				{ //Loop through all the Travois
					if (k == 0) tradeRootNum = tradeRoot1; //Socket site will be added to root 1
					if (k == 1) tradeRootNum = tradeRoot2; //Socket site will be added to root 2
					if (i == k)
					{ //Assign root
						for (l = 0; < xsArrayGetSize(tradeRootNum))
						{ //Loop through the trade root array
							if (xsArrayGetInt(tradeRootNum, l) == socketID)
							{ //Check if the socket site is allready in the Array 
								inarray = true; //Yes it is in the array
								break;
							} //end if	
						} //end for
						if (inarray == false)
						{ //Check to see if the socket site should be added to the array
							for (m = 0; < xsArrayGetSize(tradeRootNum))
							{ //Loop through the trade root array
								if (xsArrayGetInt(tradeRootNum, m) == -1)
								{ //Check for a blank spot
									xsArraySetInt(tradeRootNum, m, socketID); //add socket id to trade root array
									VPadded++; //Up the add counter
									break;
								} //end if
							} //end for k
						} //end if
					} //end if
				} //end for m
			} //end if			
		} //enf for j	
	} //end for i		
	if (VPadded == socketCount || gCurrentGameTime > 600000)
	{ //Check if all sockets have been added to the array, there is a timer if something goes wrong
		tradeRouteFinderDone = true; //Done
		xsDisableSelf(); //Disable the rule when the added count is == to the number of VP sites
	} //end if
} //end tradeRouteFinder


//rule defendBaseManager
//inactive
//group tcComplete
//minInterval 60
void defendBaseManager()
{
	//return;
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 30000,"defendBaseManager") == false) return;
	lastRunTime = gCurrentGameTime;
	
	
	static int baseDefendPlan = -1;
	int baseDefensePop = 0;
	int ownMilitaryCount = 0;
	
	if (gCurrentAge == cAge5)
	{
		aiPlanDestroy(baseDefendPlan);
		baseDefendPlan = -1;
		return;
	}

	if(kbBaseGetUnderAttack(cMyID,gMainBase) == false && baseDefendPlan != -1)
	{
		aiPlanDestroy(baseDefendPlan);
		baseDefendPlan = -1;
		return;
	}
	if(kbBaseGetUnderAttack(cMyID,gMainBase) == false)return;
	
	

	// Number of units for base defend plan, 25% of army
	ownMilitaryCount = kbUnitCount(cMyID, cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive);
	if (ownMilitaryCount > 0)
	{
		baseDefensePop = ownMilitaryCount / 4;
	}
	else
	{
		baseDefensePop = 0;
	}

	switch (gForwardBaseState)
	{
		case gForwardBaseStateNone:
			{
				if (baseDefendPlan >= 0)
				{
					aiPlanDestroy(baseDefendPlan);
					baseDefendPlan = 0;
					//aiEcho("Forward base destroyed, additional defend plan deleted");
				}
				else
				{
					aiEcho("No forward base found, no additional defend plan for main base");
				}
				break;
			}
		case gForwardBaseStateActive:
			{
				if (baseDefendPlan < 0)
				{
					baseDefendPlan = aiPlanCreate("Base Defend", cPlanDefend);
					aiPlanAddUnitType(baseDefendPlan, cUnitTypeLogicalTypeLandMilitary, baseDefensePop, baseDefensePop, baseDefensePop);

					aiPlanSetVariableVector(baseDefendPlan, cDefendPlanDefendPoint, 0, kbBaseGetMilitaryGatherPoint(cMyID, gMainBase));
					aiPlanSetVariableFloat(baseDefendPlan, cDefendPlanEngageRange, 0, cvDefenseReflexRadiusActive);
					aiPlanSetVariableFloat(baseDefendPlan, cDefendPlanGatherDistance, 0, cvDefenseReflexRadiusActive - 10.0);
					aiPlanSetVariableBool(baseDefendPlan, cDefendPlanPatrol, 0, false);
					aiPlanSetVariableFloat(baseDefendPlan, cDefendPlanGatherDistance, 0, 20.0);
					aiPlanSetInitialPosition(baseDefendPlan, gMainBaseLocation);
					aiPlanSetUnitStance(baseDefendPlan, cUnitStanceDefensive);
					aiPlanSetVariableInt(baseDefendPlan, cDefendPlanRefreshFrequency, 0, 5);
					aiPlanSetVariableInt(baseDefendPlan, cDefendPlanAttackTypeID, 0, cUnitTypeUnit);
					aiPlanSetDesiredPriority(baseDefendPlan, 95); // High priority to keep units from being drafted into attack plans
					aiPlanSetActive(baseDefendPlan);
					//aiEcho("Creating base defend plan, "+baseDefensePop+" units assigned");
				}
				else
				{
					aiPlanAddUnitType(baseDefendPlan, cUnitTypeLogicalTypeLandMilitary, baseDefensePop, baseDefensePop, baseDefensePop);
					//aiEcho("Updating base defend plan, "+baseDefensePop+" units assigned");
				}
				break;
			}
		default: // gForwardBaseStateBuilding
			{
				//aiEcho("Forward base being built, wait with additional defend plan for main base");
				break;
			}
	}

	//xsEnableRule("call_levies");
}
void nuggetGatheringManager()
{
	if(kbUnitCount(cMyID, gTownCenter, cUnitStateAlive) < 1) return;
	if(kbUnitCount(0, cUnitTypeHerdable, cUnitStateAlive) == 0 && kbUnitCount(cMyID, gTownCenter, cUnitStateAlive) >= 1)
	{
		
		static int pNuggetQry = -1;
		if(pNuggetQry == -1) 
		{
			pNuggetQry = kbUnitQueryCreate("pNuggetQry"+getQueryId());
			kbUnitQueryResetResults(pNuggetQry);
			kbUnitQuerySetPlayerRelation(pNuggetQry, cPlayerRelationAny);
			kbUnitQuerySetUnitType(pNuggetQry, cUnitTypeAbstractNuggetLand);	
			kbUnitQuerySetIgnoreKnockedOutUnits(pNuggetQry, true);
			kbUnitQuerySetState(pNuggetQry, cUnitStateAlive);
			kbUnitQuerySetMaximumDistance(pNuggetQry,200);
			kbUnitQuerySetAscendingSort(pNuggetQry, true);
		}
		kbUnitQuerySetPosition(pNuggetQry, gMainBaseLocation); //set the location
		kbUnitQueryResetResults(pNuggetQry);
		int nuggetNum = kbUnitQueryExecute(pNuggetQry); 
		for(i = 0; < nuggetNum)
		{
			if(getUnitCountByLocation(cUnitTypeGuardian, cPlayerRelationAny, cUnitStateAlive, kbUnitGetPosition(kbUnitQueryGetResult(pNuggetQry, i)), 10.0) > 0) continue;
			aiTaskUnitWork(getUnit(cUnitTypeHero, cMyID, cUnitStateAlive),kbUnitQueryGetResult(pNuggetQry, i));
			return; //break
		}
		int pSendHero = getUnit(gExplorerUnit, cMyID, cUnitStateAlive);
		if(kbUnitGetHealth(pSendHero) < 0.4 ) return;

		static int pGardQry = -1;
		if(pGardQry == -1) 
		{
			pGardQry = kbUnitQueryCreate("pGardQry"+getQueryId());
			kbUnitQueryResetResults(pGardQry);
			kbUnitQuerySetPlayerRelation(pGardQry, cPlayerRelationAny);
			kbUnitQuerySetUnitType(pGardQry, cUnitTypeGuardian);	
			kbUnitQuerySetIgnoreKnockedOutUnits(pGardQry, true);
			kbUnitQuerySetState(pGardQry, cUnitStateAlive);	
			kbUnitQuerySetAscendingSort(pGardQry, true);
		}
		kbUnitQuerySetPosition(pGardQry, gMainBaseLocation); //set the location
		kbUnitQueryResetResults(pGardQry);
		int guardianNum = kbUnitQueryExecute(pGardQry); 
		for(i = 0; < guardianNum)
		{
			if (kbUnitIsType(kbUnitQueryGetResult(pGardQry, i), cUnitTypeWaterGuardian)) continue;

			if(kbUnitCount(cMyID, cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive) >= 10)
			{
				for(j = 0; < 10)
				{
					aiTaskUnitWork(getUnit(cUnitTypeLogicalTypeLandMilitary, cMyID, cUnitStateAlive),kbUnitQueryGetResult(pGardQry, i));
				}
				return;
			}
			
			if (getUnitCountByLocation(cUnitTypeGuardian, cPlayerRelationAny, cUnitStateAlive, kbUnitGetPosition(kbUnitQueryGetResult(pGardQry, i)), 10) == 1) 
			{
				if(distance(kbUnitGetPosition(pSendHero), kbUnitGetPosition(kbUnitQueryGetResult(pGardQry, i))) > 5 ) aiTaskUnitMove(pSendHero, kbUnitGetPosition(kbUnitQueryGetResult(pGardQry, i)));
				aiTaskUnitWork(pSendHero,kbUnitQueryGetResult(pGardQry, i));
				return;
			}
			
		}	
	}
	else 
	{
		return;
	}
	
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 30000,"nuggetGatheringManager") == false) return;
	lastRunTime = gCurrentGameTime;	
	/*
	//NOTE DISABLED UNTIL REWRITE
	if(gCurrentGameTime < 900000)
	{
		static int guardianLand = -1;
		if(guardianLand == -1) guardianLand = kbUnitQueryCreate("guardianLand"+getQueryId());
		kbUnitQueryResetResults(guardianLand);
		kbUnitQuerySetPlayerRelation(guardianLand, cPlayerRelationEnemy);
		kbUnitQuerySetUnitType(guardianLand, cUnitTypeGuardian);	
		kbUnitQuerySetIgnoreKnockedOutUnits(guardianLand, true);
		kbUnitQuerySetState(guardianLand, cUnitStateAlive);
		kbUnitQuerySetPosition(guardianLand, gMainBaseLocation); //set the location
		kbUnitQuerySetAscendingSort(guardianLand, true);
		int guardianNum = kbUnitQueryExecute(guardianLand); 
		
		static int nuggetLand = -1;  //query to get all Water Nugget that are alive
		if(nuggetLand == -1) nuggetLand = kbUnitQueryCreate("nuggetLand"+getQueryId());
		kbUnitQueryResetResults(nuggetLand);
		kbUnitQuerySetPlayerRelation(nuggetLand, cPlayerRelationAny);
		kbUnitQuerySetUnitType(nuggetLand, cUnitTypeAbstractNugget);
		kbUnitQuerySetPosition(nuggetLand, gMainBaseLocation); //set the location
		kbUnitQuerySetAscendingSort(nuggetLand, true);
		kbUnitQuerySetIgnoreKnockedOutUnits(nuggetLand, true);
		kbUnitQuerySetState(nuggetLand, cUnitStateAlive);
		int nuggetNum = kbUnitQueryExecute(nuggetLand); 
		
		int dist = 0;
		bool skipNugget = false;
		if (kbUnitQueryExecute(nuggetLand) > 0)
		{
			for (h = kbUnitQueryExecute(nuggetLand) - 1; > -1)
			{
				if( kbCanSimPath(gMainBaseLocation, kbUnitGetPosition(kbUnitQueryGetResult(nuggetLand, h)), kbUnitGetProtoUnitID(getUnit(gEconUnit, cMyID, cUnitStateAlive)), 100.0) == false)continue;				
				if (kbUnitIsType(kbUnitQueryGetResult(nuggetLand, h), cUnitTypeAbstractNuggetWater) == true) continue;
				
				skipNugget = false;
				
				for (j = 0; < guardianNum)
				{
					dist = distance(kbUnitGetPosition(kbUnitQueryGetResult(nuggetLand, h)), kbUnitGetPosition(kbUnitQueryGetResult(guardianLand, j)));
					if (dist < 10)
					{
						skipNugget = true;
						break;
					}
				}
				
				
				if (skipNugget == false)
				{
				
					if(resourceEnemyCheck(kbUnitQueryGetResult(nuggetLand, h)) == true) aiTaskUnitWork(getUnit(cUnitTypeHero, cMyID, cUnitStateAlive), kbUnitQueryGetResult(nuggetLand, h));
					break;	
				}
				
			}
		}
	}
	*/

	
	static int localNuggetPlanStartTime = 0;
	if (localNuggetPlanStartTime == 0)
	{
		localNuggetPlanStartTime = gCurrentGameTime; // set time and quit when rule is called for the first time
		return;
	}

	static int localNuggetPlan = -1;
	vector homeBaseVec = cInvalidVector;

	if (gTownCenterNumber > 0)
	{
		homeBaseVec = kbUnitGetPosition(getUnit(gTownCenter, cMyID)); // use random own TC position as basis for plans
	}
	else
	{
		return; // quit if there is no TC
	}
	// If there already is a plan destroy it, re-initialize explorer control plan, and wait for next call
	/*
	if (localNuggetPlan >= 0)
	{
		aiPlanDestroy(localNuggetPlan);
		localNuggetPlan = -1;

		// Re-initialize explorer control plan
		if (gExplorerControlPlan < 0)
		{
			gExplorerControlPlan = aiPlanCreate("Explorer control plan", cPlanDefend);
			switch (kbGetCiv())
			{
				case cCivXPAztec:
					{
						aiPlanAddUnitType(gExplorerControlPlan, cUnitTypexpAztecWarchief, 1, 1, 1);
						break;
					}
				case cCivXPIroquois:
					{
						aiPlanAddUnitType(gExplorerControlPlan, cUnitTypexpIroquoisWarChief, 1, 1, 1);
						break;
					}
				case cCivXPSioux:
					{
						aiPlanAddUnitType(gExplorerControlPlan, cUnitTypexpLakotaWarchief, 1, 1, 1);
						break;
					}
				case cCivChinese:
					{
						aiPlanAddUnitType(gExplorerControlPlan, cUnitTypeypMonkChinese, 1, 1, 1);
						break;
					}
				case cCivIndians:
					{
						aiPlanAddUnitType(gExplorerControlPlan, cUnitTypeypMonkIndian, 1, 1, 1);
						aiPlanAddUnitType(gExplorerControlPlan, cUnitTypeypMonkIndian2, 1, 1, 1);
						break;
					}
				case cCivJapanese:
					{
						aiPlanAddUnitType(gExplorerControlPlan, cUnitTypeypMonkJapanese, 1, 1, 1);
						aiPlanAddUnitType(gExplorerControlPlan, cUnitTypeypMonkJapanese2, 1, 1, 1);
						break;
					}
				default:
					{
						aiPlanAddUnitType(gExplorerControlPlan, gExplorerUnit, 1, 1, 1);
						break;
					}
			}
			aiPlanSetVariableVector(gExplorerControlPlan, cDefendPlanDefendPoint, 0, homeBaseVec);
			aiPlanSetVariableFloat(gExplorerControlPlan, cDefendPlanEngageRange, 0, 20.0); // Tight
			aiPlanSetVariableBool(gExplorerControlPlan, cDefendPlanPatrol, 0, false);
			aiPlanSetVariableFloat(gExplorerControlPlan, cDefendPlanGatherDistance, 0, 20.0);
			aiPlanSetInitialPosition(gExplorerControlPlan, homeBaseVec);
			aiPlanSetUnitStance(gExplorerControlPlan, cUnitStanceDefensive);
			aiPlanSetVariableInt(gExplorerControlPlan, cDefendPlanRefreshFrequency, 0, 30);
			aiPlanSetVariableInt(gExplorerControlPlan, cDefendPlanAttackTypeID, 0, cUnitTypeUnit); // Only units
			aiPlanSetDesiredPriority(gExplorerControlPlan, 90); // Quite high, don't suck him into routine attack plans, etc.
			//aiPlanSetActive(gExplorerControlPlan);

		}
		return;
	}
	*/

	// Quit if no local nuggets are around, if nugget gathering is not allowed, if explorer is ko, 
	// or if the last plan was created less than 3 minutes ago
	int localNuggetCount = getUnitCountByLocation(cUnitTypeAbstractNuggetLand, cPlayerRelationAny, cUnitStateABQ, homeBaseVec, 75.0);

	if ((localNuggetCount == 0) ||
		(cvOkToGatherNuggets == false) ||
		(aiGetFallenExplorerID() >= 0) ||
		(gCurrentGameTime - localNuggetPlanStartTime < 30000))
	{
		return;
	}
	else
	{
		if (getCivIsNative() && kbUnitCount(cMyID, cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive) < 5) return;
		// Destroy explorer control plan
		aiPlanDestroy(gExplorerControlPlan);
		gExplorerControlPlan = -1;

		// Find a random local nugget
		int localNugget = getUnitByLocation(cUnitTypeAbstractNuggetLand, cPlayerRelationAny, cUnitStateABQ, homeBaseVec, 75.0);
		vector localNuggetVec = kbUnitGetPosition(localNugget);

		// Create temporary explore plan to gather local nuggets
		localNuggetPlan = aiPlanCreate("Local Nuggets", cPlanGatherNuggets);
		aiPlanSetDesiredPriority(localNuggetPlan, 75);
		aiPlanSetInitialPosition(localNuggetPlan, localNuggetVec);
		switch (kbGetCiv())
		{
			case cCivXPAztec:
				{
					aiPlanAddUnitType(localNuggetPlan, cUnitTypexpAztecWarchief, 1, 1, 1);
					break;
				}
			case cCivXPIroquois:
				{
					aiPlanAddUnitType(localNuggetPlan, cUnitTypexpIroquoisWarChief, 1, 1, 1);
					break;
				}
			case cCivXPSioux:
				{
					aiPlanAddUnitType(localNuggetPlan, cUnitTypexpLakotaWarchief, 1, 1, 1);
					break;
				}
			case cCivChinese:
				{
					aiPlanAddUnitType(localNuggetPlan, cUnitTypeypMonkChinese, 1, 1, 1);
					break;
				}
			case cCivIndians:
				{
					aiPlanAddUnitType(localNuggetPlan, cUnitTypeypMonkIndian, 1, 1, 1);
					aiPlanAddUnitType(localNuggetPlan, cUnitTypeypMonkIndian2, 1, 1, 1);
					break;
				}
			case cCivJapanese:
				{
					aiPlanAddUnitType(localNuggetPlan, cUnitTypeypMonkJapanese, 1, 1, 1);
					aiPlanAddUnitType(localNuggetPlan, cUnitTypeypMonkJapanese2, 1, 1, 1);
					break;
				}
			default:
				{
					aiPlanAddUnitType(localNuggetPlan, gExplorerUnit, 1, 1, 1);
					break;
				}
		}
		if (getCivIsNative()) aiPlanAddUnitType(localNuggetPlan, cUnitTypeLogicalTypeLandMilitary, 5, 5, 5);

		aiPlanSetUnitStance(localNuggetPlan, cUnitStanceDefensive);
		aiPlanSetVariableBool(localNuggetPlan, cExplorePlanOkToGatherNuggets, 0, true);
		aiPlanSetEscrowID(localNuggetPlan, cMilitaryEscrowID);
		aiPlanSetBaseID(localNuggetPlan, gMainBase);
		aiPlanSetVariableBool(localNuggetPlan, cExplorePlanDoLoops, 0, false);
		aiPlanSetNoMoreUnits(localNuggetPlan,true);
		aiPlanSetActive(localNuggetPlan);

		// Set start time
		localNuggetPlanStartTime = gCurrentGameTime;
	}
}


//==============================================================================
/* rule marketManager
	updatedOn 2019/11/18 By ageekhere  
*/
//==============================================================================
//rule marketManager
//inactive
//minInterval 5
//group startup

void marketManager()
{
	if (kbUnitCount(cMyID, gMarketUnit, cUnitStateAlive) == 0) return;

	//if (gCurrentAge < cAge3) return;
	if(gCurrentWood < 1000 && getUnit(gTownCenter, cMyID, cUnitStateABQ) == -1)
	{
		aiBuyResourceOnMarket(cResourceWood);
		aiSellResourceOnMarket(cResourceFood);
		return;
	}
	if(kbGetCiv() == cCivDutch && gCurrentCoin < 150) aiSellResourceOnMarket(cResourceFood);
	
	if(gCurrentAge > cAge2 && gCurrentWood < 150)aiBuyResourceOnMarket(cResourceWood);
	if(gCurrentFood < 150 && kbGetCiv() != cCivDutch) aiBuyResourceOnMarket(cResourceFood);
	
	if(gCurrentWood > 2000 && aiGetMarketBuyCost(cResourceWood) > 30 && gCurrentAge > cAge3) aiSellResourceOnMarket(cResourceWood);
	if(gCurrentFood > 2000 && aiGetMarketBuyCost(gCurrentFood) > 30) aiSellResourceOnMarket(cResourceFood);
	
	
	if(gCurrentFood > gCurrentCoin + 1000 && aiGetMarketBuyCost(cResourceFood) > 31) aiSellResourceOnMarket(cResourceFood);
	if(gCurrentCoin > gCurrentFood + 1000 && aiGetMarketBuyCost(cResourceFood) < 250 && gCurrentFood < 5000) aiBuyResourceOnMarket(cResourceFood);
	
	if(gCurrentAge > cAge3 && gCurrentWood < 450 && aiGetMarketBuyCost(cResourceWood) < 250) aiBuyResourceOnMarket(cResourceWood);
	
	if(gCurrentFood > 5000 && aiGetMarketBuyCost(cResourceFood) > 30) aiSellResourceOnMarket(cResourceFood);
	/*
	float inv_gold = gCurrentCoin;
	float inv_wood = gCurrentWood;
	float inv_food = gCurrentFood;

	float lowest = MIN(inv_food, MIN(inv_wood, inv_gold));
	float highest = MAX(inv_food, MAX(inv_wood, inv_gold));

	int tobuy = cResourceFood;
	int tosell = cResourceWood;

	if (lowest == inv_food)
		tobuy = cResourceFood;
	else if (lowest == inv_wood)
		tobuy = cResourceWood;

	if (highest == inv_food)
		tosell = cResourceFood;
	else if (highest == inv_wood)
		tosell = cResourceWood;

	if (highest == inv_gold)
	{
		//xsSetRuleMinIntervalSelf(1); // Fast mode interval
		if (inv_gold > (aiGetMarketBuyCost(tobuy) * 10))
		{
			aiBuyResourceOnMarket(tobuy);
		}
		return;
	}
	else if (lowest == inv_gold)
	{
		// Hmm... To be decided
	}

	if (lowest * 5.0 < highest)
	{
		//xsSetRuleMinIntervalSelf(1); // Fast mode interval
		if (aiGetMarketSellCost(tosell) != 30)
		{
			aiSellResourceOnMarket(tosell);
			aiSellResourceOnMarket(tosell);
			aiSellResourceOnMarket(tosell);
		}
		aiBuyResourceOnMarket(tobuy);
	}
*/
	//if (gCurrentAge < cAge5 && gCurrentWood > 700 && aiGetMarketBuyCost(cResourceWood) > 30)
/*	
if (gCurrentWood > 2000 && aiGetMarketBuyCost(cResourceWood) > 30)
	{
		aiSellResourceOnMarket(cResourceWood);
	}
	*/
}
//==============================================================================
/*
gathererManager	
updatedOn 2022/06/09 By ageekhere
Allocates settlers to resources, uses aiTaskUnitWork instead of plans
*/
//==============================================================================

int gOutsideSafeRange = 0;
int gOutsideSafeRangeMax = 25;
int pChickenCount = 0;
int gBerryCount = 0;
int gLivestock = 0;

int pf_gathererManager_decideResource(int pResourceArray = -1, int settlerId = -1, int resourceType = -1, int resourceFWG = -1, int pAddedThisRoundIdArray = -1, int pAddedThisRoundNumArray = -1)
{
	static int pResouceID = -1;
	static float pUnitDist = -1.0;
	static float pNearestResourceDist = -1;
	static int pNearestResourceId = -1;
	static bool pFoundDead = false;
	pNearestResourceDist = 9999999.0;
	pNearestResourceId = -1;
	pFoundDead = false;
	static int pAssignedValue = -1;
	static bool pSkip = false;
	for (i = 0; < 1001)
	{
		pResouceID = xsArrayGetInt(pResourceArray, i);
		if (pResouceID == -1) break;
		
		if (getEnemyUnitPathStatus(kbUnitGetPosition(settlerId),kbUnitGetPosition(pResouceID)) > 1)continue;

		if( checkResourceAssignment( pResouceID , unitGathererLimit(kbUnitGetProtoUnitID(pResouceID)) ) ) continue;
		if(kbUnitIsType(pResouceID, cUnitTypeChickenPen) && pChickenCount > 4)return (-1);
		else if(kbUnitIsType(pResouceID, cUnitTypeBerryBush) && gBerryCount > 8)return (-1);
		else if(kbUnitIsType(pResouceID, cUnitTypeHerdable) && gLivestock > 8)return (-1);
		pSkip = false;
		if(kbCanPath2(kbUnitGetPosition(settlerId), kbUnitGetPosition(pResouceID),kbUnitGetProtoUnitID(settlerId),500.0) == false)  continue;
		for (j = 0; < 1000)
		{
			pAssignedValue = xsArrayGetInt(pAddedThisRoundIdArray, j);
			if (pAssignedValue == -1) break;
			else if (pAssignedValue == pResouceID)
			{
				if (xsArrayGetInt(pAddedThisRoundNumArray, j) >= unitGathererLimit(kbUnitGetProtoUnitID(pResouceID))) pSkip = true;
				if( checkResourceAssignment( xsArrayGetInt(pAddedThisRoundNumArray, j) , unitGathererLimit(kbUnitGetProtoUnitID(pResouceID)) ) ) pSkip = true;
				if (kbUnitGetNumberWorkersIfSeeable(pResouceID) >= unitGathererLimit(kbUnitGetProtoUnitID(pResouceID))) pSkip = true;
				break;
			}
		}
		if (pSkip == true) continue;
		if (getIsAnimalGathered(pResouceID) == true) continue;
		if (resourceType == cUnitTypeHuntable && getCivHuntAbility() == false) continue;	
		if (resourceType == cUnitTypeHerdable && getCivSlaughterAbility() == false) continue;	

		for (k = 0; < 1000)
		{
			if (xsArrayGetInt(gBlockedResourceArray, k) == -1) break;
			if (xsArrayGetInt(gBlockedResourceArray, k) == pResouceID)
			{
				pSkip = true;
				break;
			}
		}
		if (pSkip == true) continue;
		pNearestResourceId = pResouceID;
		if (pFoundDead == false)
		{
			if ((resourceType == cUnitTypeHerdable || resourceType == cUnitTypeHuntable) && kbUnitGetHealth(pResouceID) == 0.0 && kbUnitGetCurrentInventory(pResouceID, cUnitTypeFood) > 50)
			{
				pNearestResourceDist = 9999999.0;
				pNearestResourceId = -1;
				pFoundDead = true;
			}
		}
		if (resourceType == cUnitTypeHerdable && kbUnitIsInventoryFull(pResouceID) == false && kbUnitGetHealth(pResouceID) == 1.0) continue;
		//pUnitDist = distance(kbUnitGetPosition(settlerId), kbUnitGetPosition(pResouceID));
		pUnitDist = distance(gMainTownCenterLocation, kbUnitGetPosition(pResouceID));
		
		if (pFoundDead == true)
		{
			if (pUnitDist < pNearestResourceDist && kbUnitGetHealth(pResouceID) == 0.0)
			{
				pNearestResourceDist = pUnitDist;
				pNearestResourceId = pResouceID;
			}
		}
		else
		{
			if (pUnitDist < pNearestResourceDist)
			{
				pNearestResourceDist = pUnitDist;
				pNearestResourceId = pResouceID;
			}
		}
		return (pNearestResourceId);
	}
	return (-1);
}

//limit the number of settlers that can gather outsize of 100 range
//record resource danager level by recording the last time an enemy was seen there
void gathererManager(int idleArray = -1, int settlersAdded = 0)
{
	static int settlerId = -1;
	static float pPercentOnWood = 0.0;
	static float pPercentOnGold = 0.0;
	static float pPercentOnFood = 0.0;
	static float pForcastGold = -1.0;
	static float pForcastWood = -1.0;
	static float pForcastFood = -1.0;
	static float pTotalForcast = -1.0;
	static float pForcastGoldPercent = -1.0;
	static float pForcastWoodPercent = -1.0;
	static float pForcastFoodPercent = -1.0;
	static int pGatherRange = 80;
	static int pWoodGatherRange = 80;
	const int pWoodGatherRangeMax = 300;
	static int pFoodGatherRange = 80;
	const int  pFoodGatherRangeMax = 300;
	static int pGoldGatherRange = 80;
	const int  pGoldGatherRangeMax = 300;
	static int pResourcesNum = -1;
	static int pWoodNum = -1;
	static int pFoodNum = -1;
	static int pGoldNum = -1;
	static int pResourceQry = -1;
	static int pWoodQry = -1;
	static int pGoldQry = -1;
	static int pFoodQry = -1;

	static int thisRoundAssigned = -1;
	static int w_i = -1;
	static float pFcount = -1.0;
	static float pWcount = -1.0;
	static float pGcount = -1.0;
	static float pIdlecount = -1.0;
	static int pTargetUnitId = -1;
	static int pCrateArray = -1;
	static int pHuntableArray = -1;
	static int pHerdableArray = -1;
	static int pFruitArray = -1;
	static int pFarmArray = -1;
	static int pFoodArray = -1;
	static int pMinedResourceArray = -1;
	static int pPlantationArray = -1;
	static int pCoinArray = -1;
	static int pWoodArray = -1;
	static int pAddedThisRoundIdArray = -1;
	static int pAddedThisRoundNumArray = -1;
	static int pCrateArrayLP = -1;
	static int pHuntableArrayLP = -1;
	static int pHerdableArrayLP = -1;
	static int pFruitArrayLP = -1;
	static int pFarmArrayLP = -1;
	static int pFoodArrayLP = -1;

	static int pMinedResourceArrayLP = -1;
	static int pPlantationArrayLP = -1;
	static int pCoinArrayLP = -1;
	static int pWoodArrayLP = -1;
	static int pResourceUnit = -1;
	static bool pIsMiner = false;
	static int lastRunTimeReset = 0;
	static bool pNeedFood = false;
	static bool pNeedGold = false;
	static bool pNeedWood = false;
	static float pNearestResourceDist = 9999999.0;
	static int pNearestResourceId = -1;
	static int pResouceID = -1;
	static int decideResourceValue = -1;
	static int pResourceValue = -1;
	static float pFoodRemoveCount = 1.0;
	static float pGoldRemoveCount = 1.0;
	static float pPercentOnWoodChange = -1.0;
	static float pPercentOnFoodChange = -1.0;
	static float pPercentOnGoldChange = -1.0;
	static float pWcountChange = -1.0;
	static float pFcountChange = -1.0;
	static float pGcountChange = -1.0;

	static bool pFlag = true;
	static int pAssignedValue = 0;
	static bool skip = false;
	static float pResourceDist = -1.0;
	static int pPlayerId = -1;
	static bool pResetAddedArray = false;
	static float pPercentDiff = -1.0;
	static int arrayVale = -1;
	
	static int lastRunTime2 = 0;
	if(functionDelay(lastRunTime2, 1000,"gathererManager") == false) return;
	lastRunTime2 = gCurrentGameTime;

	debugRule("void gathererManager ",0);
	setResources(); // Monitor main base supply of food and gold, activate farming and plantations when resources run low
	setForecasts(); // Update forecasts for economic and military expenses.  Set resource

	pFcount = 0.0;
	pWcount = 0.0;
	pGcount = 0.0;
	pIdlecount = 0.0;
	pTargetUnitId = 0;
	gOutsideSafeRange = 0;
	w_i = 0;
	pResourceUnit = -1;
	pIsMiner = false;
	pCrateArrayLP = 0;
	pHuntableArrayLP = 0;
	pHerdableArrayLP = 0;
	pFruitArrayLP = 0;
	pFarmArrayLP = 0;
	pFoodArrayLP = 0;
	pMinedResourceArrayLP = 0;
	pPlantationArrayLP = 0;
	pCoinArrayLP = 0;
	pWoodArrayLP = 0;
	pNeedFood = false;
	pNeedGold = false;
	pNeedWood = false;
	pNearestResourceDist = 9999999.0;
	pNearestResourceId = -1;
	pResouceID = -1;
	decideResourceValue = -1;
	pResourceValue = -1;
	pFoodRemoveCount = 1.0;
	pGoldRemoveCount = 1.0;
	pPercentOnWoodChange = -1.0;
	pPercentOnFoodChange = -1.0;
	pPercentOnGoldChange = -1.0;
	pResetAddedArray = false;
	pChickenCount = 0;
	gBerryCount = 0;
	gLivestock = 0;

	//Arrays to hold each resource type
	if (pCrateArray == -1) pCrateArray = xsArrayCreateInt(1000, -1, "pCrateArray_gathererManager");
	if (pHuntableArray == -1) pHuntableArray = xsArrayCreateInt(1000, -1, "pHuntableArray_gathererManager");
	if (pHerdableArray == -1) pHerdableArray = xsArrayCreateInt(1000, -1, "pHerdableArray_gathererManager");
	if (pFruitArray == -1) pFruitArray = xsArrayCreateInt(1000, -1, "pFruitArray_gathererManager");
	if (pFarmArray == -1) pFarmArray = xsArrayCreateInt(1000, -1, "pFarmArray_gathererManager");
	if (pFoodArray == -1) pFoodArray = xsArrayCreateInt(1000, -1, "pFoodArray_gathererManager");
	if (pMinedResourceArray == -1) pMinedResourceArray = xsArrayCreateInt(1000, -1, "pMinedResourceArray_gathererManager");
	if (pPlantationArray == -1) pPlantationArray = xsArrayCreateInt(1000, -1, "pPlantationArray_gathererManager");
	if (pCoinArray == -1) pCoinArray = xsArrayCreateInt(1000, -1, "pCoinArray_gathererManager");
	if (pWoodArray == -1) pWoodArray = xsArrayCreateInt(1000, -1, "pWoodArray_gathererManager");
	if (pAddedThisRoundIdArray == -1) pAddedThisRoundIdArray = xsArrayCreateInt(1000, -1, "pAddedThisRoundIdArray");
	if (pAddedThisRoundNumArray == -1) pAddedThisRoundNumArray = xsArrayCreateInt(1000, -1, "pAddedThisRoundNumArray");
	if (functionDelay(lastRunTimeReset, 300000, "gathererManager - arrayUpdate") || lastRunTimeReset == 0)
	{ //delay the reset of the pAddedThisRoundIdArray pAddedThisRoundNumArray
		debugRule("void gathererManager - pResetAddedArray true ",0);
		lastRunTimeReset = gCurrentGameTime;
		pResetAddedArray = true;
	}
	for (i = 0; < 1000)
	{ //reset array back to default values, Note we do not use setIntArrayToDefaults here because the following is faster in this case
		pFlag = true;
		if (xsArrayGetInt(pCrateArray, i) != -1) { xsArraySetInt(pCrateArray, i, -1); pFlag = false; }
		if (xsArrayGetInt(pHuntableArray, i) != -1) { xsArraySetInt(pHuntableArray, i, -1); pFlag = false; }
		if (xsArrayGetInt(pHerdableArray, i) != -1) { xsArraySetInt(pHerdableArray, i, -1); pFlag = false; }
		if (xsArrayGetInt(pFruitArray, i) != -1) { xsArraySetInt(pFruitArray, i, -1); pFlag = false; }
		if (xsArrayGetInt(pFarmArray, i) != -1) { xsArraySetInt(pFarmArray, i, -1); pFlag = false; }
		if (xsArrayGetInt(pFoodArray, i) != -1) { xsArraySetInt(pFoodArray, i, -1); pFlag = false; }
		if (xsArrayGetInt(pMinedResourceArray, i) != -1) { xsArraySetInt(pMinedResourceArray, i, -1); pFlag = false; }
		if (xsArrayGetInt(pPlantationArray, i) != -1) { xsArraySetInt(pPlantationArray, i, -1); pFlag = false; }
		if (xsArrayGetInt(pCoinArray, i) != -1) { xsArraySetInt(pCoinArray, i, -1); pFlag = false; }
		if (xsArrayGetInt(pWoodArray, i) != -1) { xsArraySetInt(pWoodArray, i, -1); pFlag = false; }
		if (xsArrayGetInt(pAddedThisRoundIdArray, i) != -1) { xsArraySetInt(pAddedThisRoundIdArray, i, -1); pFlag = false; }
		if (xsArrayGetInt(pAddedThisRoundNumArray, i) != -1) { xsArraySetInt(pAddedThisRoundNumArray, i, -1); pFlag = false; }
		
		if (pFlag) break;
	} //end for

	for (i = 0; < gCurrentAliveSettlers)
	{ //loop through all player settlers and count each target they are on also how many are outside of safe range
		settlerId = kbUnitQueryGetResult(getAliveSettlersQuery, i);
		if (settlerId == -1) break;
		pTargetUnitId = kbUnitGetTargetUnitID(settlerId);

		//if (distance(gMainBaseLocation, kbUnitGetPosition(settlerId)) > 500.0) 
		//{
		//	gOutsideSafeRange++; //how many are outside of the safe range
		//	if(gOutsideSafeRange > gOutsideSafeRangeMax)
		//	{
		//		aiTaskUnitMove(settlerId,gMainTownCenterLocation);
		//	}
		//}
		
		if (pTargetUnitId == -1) continue;
		
		if(kbUnitIsType(pTargetUnitId, cUnitTypeChickenPen)) pChickenCount++;
		if(kbUnitIsType(pTargetUnitId, cUnitTypeBerryBush)) gBerryCount++;
		if(kbUnitIsType(pTargetUnitId, cUnitTypeHerdable)) gLivestock++;
		
		if (kbUnitIsType(pTargetUnitId, cUnitTypeGold)) pGcount++; //how many are on gold
		else if (kbUnitIsType(pTargetUnitId, cUnitTypeFood)) pFcount++; //how many areon food
		else if (kbUnitIsType(pTargetUnitId, cUnitTypeWood)) pWcount++; //how many are on Wood
		else pIdlecount++;
	} //end for

	pPercentOnGold = (pGcount * 100.0) / gCurrentAliveSettlers;
	pPercentOnFood = (pFcount * 100.0) / gCurrentAliveSettlers;
	pPercentOnWood = (pWcount * 100.0) / gCurrentAliveSettlers;

	pForcastGold = xsArrayGetFloat(gForecasts, cResourceGold);
	pForcastFood = xsArrayGetFloat(gForecasts, cResourceFood);
	pForcastWood = xsArrayGetFloat(gForecasts, cResourceWood);
	pTotalForcast = pForcastGold + pForcastFood + pForcastWood;

	pForcastGoldPercent = (pForcastGold * 100.0) / pTotalForcast;
	pForcastFoodPercent = (pForcastFood * 100.0) / pTotalForcast;
	pForcastWoodPercent = (pForcastWood * 100.0) / pTotalForcast;
	
	if (pTotalForcast == 0 || gCurrentAge == cAge1)
	{ //start of game check if no Forcast
		pForcastFoodPercent = 70.0;
		pForcastGoldPercent = 10.0;
		pForcastWoodPercent = 20.0;
		if(gCurrentCiv == cCivMaltese)
		{
			pForcastFoodPercent = 50.0;
			pForcastGoldPercent = 10.0;
			pForcastWoodPercent = 40.0;
		}
	}
	else if (gCurrentAge == cAge2)
	{ //start of game check if no Forcast

		pForcastFoodPercent = 50.0;
		pForcastGoldPercent = 30.0;
		pForcastWoodPercent = 20.0;
		if(gOpeningStrategy == 2)
		{
			pForcastFoodPercent = 60.0;
			pForcastGoldPercent = 30.0;
			pForcastWoodPercent = 10.0;
		}
		if(gCurrentCiv == cCivMaltese && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) < 2)
		{
			pForcastFoodPercent = 40.0;
			pForcastGoldPercent = 20.0;
			pForcastWoodPercent = 40.0;
		}
	}
	else if (gCurrentAge > cAge3)
	{
		if(gCurrentCiv == cCivMaltese && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) < 3)
		{
			pForcastFoodPercent = 50.0;
			pForcastGoldPercent = 20.0;
			pForcastWoodPercent = 30.0;
		}
		pForcastFoodPercent = 50.0;
		pForcastGoldPercent = 30.0;
		pForcastWoodPercent = 20.0;
	}
	else if (gCurrentAge > cAge4)
	{ //cap wood Forcast, also have a min food and gold 
		if (pForcastGold < 1000) pForcastGold = 1000.0;
		if (pForcastFood < 1000) pForcastFood = 1000.0;
		if (pForcastWood > 5000) pForcastWood = 0.0;
		if(gCurrentCiv == cCivMaltese && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) < 4)
		{
			pForcastFoodPercent = 20.0;
			pForcastGoldPercent = 20.0;
			pForcastWoodPercent = 60.0;
		}
	}
	if(getCivIsNative() && gCurrentAge == cAge1 && getAgingUp() == false)
	{
		pForcastFoodPercent = 80.0;
		pForcastGoldPercent = 10.0;
		pForcastWoodPercent = 10.0;
	}
	if(getAgingUp() && gCurrentAge < cAge3)
	{
		pForcastFoodPercent = 30.0;
		pForcastGoldPercent = 30.0;
		pForcastWoodPercent = 40.0;
	}
	if (pGoldQry == -1) pGoldQry = kbUnitQueryCreate("pGoldQry" + getQueryId());
	
	kbUnitQueryResetData(pGoldQry);
	kbUnitQuerySetPlayerID(pGoldQry, 0, true);
	kbUnitQuerySetPosition(pGoldQry, gMainTownCenterLocation);
	kbUnitQuerySetMaximumDistance(pGoldQry, pGoldGatherRange);
	kbUnitQuerySetPlayerRelation(pGoldQry, -1);
	kbUnitQuerySetUnitType(pGoldQry, cUnitTypeGold);
	kbUnitQuerySetState(pGoldQry, cUnitStateAny);
	kbUnitQuerySetAscendingSort(pGoldQry, true);
	kbUnitQueryExecute(pGoldQry);

	kbUnitQuerySetPlayerID(pGoldQry, cMyID, false);
	kbUnitQuerySetPosition(pGoldQry, gMainTownCenterLocation);
	kbUnitQuerySetMaximumDistance(pGoldQry, pGoldGatherRange);
	kbUnitQuerySetPlayerRelation(pGoldQry, -1);
	kbUnitQuerySetUnitType(pGoldQry, cUnitTypeGold);
	kbUnitQuerySetState(pGoldQry, cUnitStateAny);
	kbUnitQuerySetAscendingSort(pGoldQry, true);
	
	pGoldNum = kbUnitQueryExecute(pGoldQry);
	if (pGoldNum < 30 && pGoldGatherRange < pGoldGatherRangeMax) pGoldGatherRange = pGoldGatherRange + 10;

	if (pFoodQry == -1) pFoodQry = kbUnitQueryCreate("pFoodQry" + getQueryId());
	kbUnitQueryResetResults(pFoodQry);
	kbUnitQuerySetPlayerID(pFoodQry, 0, true);
	kbUnitQuerySetPosition(pFoodQry, gMainTownCenterLocation);
	kbUnitQuerySetMaximumDistance(pFoodQry, pFoodGatherRange);
	kbUnitQuerySetPlayerRelation(pFoodQry, -1);
	kbUnitQuerySetUnitType(pFoodQry, cUnitTypeFood);
	kbUnitQuerySetState(pFoodQry, cUnitStateAny);
	kbUnitQuerySetAscendingSort(pFoodQry, true);

	kbUnitQueryExecute(pFoodQry);

	kbUnitQuerySetPlayerID(pFoodQry, cMyID, false);
	kbUnitQuerySetPosition(pFoodQry, gMainTownCenterLocation);
	kbUnitQuerySetMaximumDistance(pFoodQry, pFoodGatherRange);
	kbUnitQuerySetPlayerRelation(pFoodQry, -1);
	kbUnitQuerySetUnitType(pFoodQry, cUnitTypeFood);
	kbUnitQuerySetState(pFoodQry, cUnitStateAny);
	kbUnitQuerySetAscendingSort(pFoodQry, true);
	pFoodNum = kbUnitQueryExecute(pFoodQry);
	if (pFoodNum < 30 && pFoodGatherRange < pFoodGatherRangeMax) pFoodGatherRange = pFoodGatherRange + 10;
	
	if (pResetAddedArray == true)
	{ //only update the ResourceQry at x amount of time
		if (pWoodQry == -1) pWoodQry = kbUnitQueryCreate("pWoodQry" + getQueryId());
		kbUnitQueryResetResults(pWoodQry);
		kbUnitQuerySetPlayerID(pWoodQry, 0, true);
		kbUnitQuerySetPosition(pWoodQry, gMainTownCenterLocation);
		kbUnitQuerySetMaximumDistance(pWoodQry, pWoodGatherRange);
		kbUnitQuerySetPlayerRelation(pWoodQry, -1);
		kbUnitQuerySetUnitType(pWoodQry, cUnitTypeWood);
		kbUnitQuerySetState(pWoodQry, cUnitStateAny);
		kbUnitQuerySetAscendingSort(pWoodQry, true);
		kbUnitQueryExecute(pWoodQry);

		kbUnitQuerySetPlayerID(pWoodQry, cMyID, false);
		kbUnitQuerySetPosition(pWoodQry, gMainTownCenterLocation);
		kbUnitQuerySetMaximumDistance(pWoodQry, pWoodGatherRange);
		kbUnitQuerySetPlayerRelation(pWoodQry, -1);
		kbUnitQuerySetUnitType(pWoodQry, cUnitTypeWood);
		kbUnitQuerySetState(pWoodQry, cUnitStateAny);
		kbUnitQuerySetAscendingSort(pWoodQry, true);
		kbUnitQueryExecute(pWoodQry);
		pWoodNum = kbUnitQueryExecute(pWoodQry);
		if (pWoodNum < 10 && pWoodGatherRange < pWoodGatherRangeMax) pWoodGatherRange = pWoodGatherRange + 10;
		lastRunTimeReset = gCurrentGameTime;
	}

	//Loop through all found resources and separate each resource type into arrays which will be 
	//used for priority for each settler. Note that we cap the number of priority resources.
	for (i = 0; < pWoodNum)
	{
		pResourceUnit = kbUnitQueryGetResult(pWoodQry, i);
		if (kbUnitVisible(pResourceUnit) == false) continue;
		pPlayerId = kbUnitGetPlayerID(pResourceUnit);
		if (pPlayerId != cMyID && pPlayerId != 0) continue;
		pResourceDist = distance(gMainTownCenterLocation, kbUnitGetPosition(pResourceUnit));
		if (pResourceDist > 100 && gOutsideSafeRange > gOutsideSafeRangeMax) continue;
		if (kbUnitIsType(pResourceUnit, cUnitTypeAbstractResourceCrate))
		{
			if (pCrateArrayLP < 10) { xsArraySetInt(pCrateArray, pCrateArrayLP, pResourceUnit); pCrateArrayLP++; }
			continue;
		}
		if (pWoodArrayLP < 30)
		{
			xsArraySetInt(pWoodArray, pWoodArrayLP, pResourceUnit);
			pWoodArrayLP++;
			continue;
		}
	}
	for (i = 0; < pFoodNum)
	{
		pResourceUnit = kbUnitQueryGetResult(pFoodQry, i);
		if (kbUnitVisible(pResourceUnit) == false) continue;
		if (kbUnitIsType(pResourceUnit, cUnitTypeFish)) continue;
		pPlayerId = kbUnitGetPlayerID(pResourceUnit);
		if (pPlayerId != cMyID && pPlayerId != 0) continue;
		pResourceDist = distance(gMainTownCenterLocation, kbUnitGetPosition(pResourceUnit));
		if (pResourceDist > 100 && gOutsideSafeRange > gOutsideSafeRangeMax) continue;
		if (kbUnitIsType(pResourceUnit, cUnitTypeAbstractResourceCrate))
		{
			if (pCrateArrayLP < 10) { xsArraySetInt(pCrateArray, pCrateArrayLP, pResourceUnit); pCrateArrayLP++; }
			continue;
		}
		if (kbUnitIsType(pResourceUnit, cUnitTypeHerdable))
		{
			if (pHerdableArrayLP < 10) { xsArraySetInt(pHerdableArray, pHerdableArrayLP, pResourceUnit); pHerdableArrayLP++; }
			continue;
		}
		if (kbUnitIsType(pResourceUnit, cUnitTypeHuntable))
		{
			if (pHuntableArrayLP < 30) { xsArraySetInt(pHuntableArray, pHuntableArrayLP, pResourceUnit); pHuntableArrayLP++; }
			continue;
		}
		if (kbUnitIsType(pResourceUnit, cUnitTypeAbstractFruit))
		{
			if (pFruitArrayLP < 10) { xsArraySetInt(pFruitArray, pFruitArrayLP, pResourceUnit); pFruitArrayLP++; }
			continue;
		}
		if (kbUnitIsType(pResourceUnit, cUnitTypeAbstractFarm))
		{
			if (pFarmArrayLP < 10) { xsArraySetInt(pFarmArray, pFarmArrayLP, pResourceUnit); pFarmArrayLP++; }
			continue;
		}
		if (kbUnitIsType(pResourceUnit, cUnitTypeFood))
		{
			if (pFoodArrayLP < 10) { xsArraySetInt(pFoodArray, pFoodArrayLP, pResourceUnit); pFoodArrayLP++; }
			continue;
		}
	}

	for (i = 0; < pGoldNum)
	{
		pResourceUnit = kbUnitQueryGetResult(pGoldQry, i);
		
		if (kbUnitIsType(pResourceUnit, cUnitTypeFish)) continue;
		pPlayerId = kbUnitGetPlayerID(pResourceUnit);
		if (pPlayerId != cMyID && pPlayerId != 0) continue;
		if (kbUnitVisible(pResourceUnit) == false) continue;
		
		pResourceDist = distance(gMainTownCenterLocation, kbUnitGetPosition(pResourceUnit));
		if (pResourceDist > 100 && gOutsideSafeRange > gOutsideSafeRangeMax) continue;
		
		if (kbUnitIsType(pResourceUnit, cUnitTypeAbstractResourceCrate))
		{
			if (pCrateArrayLP < 10) { xsArraySetInt(pCrateArray, pCrateArrayLP, pResourceUnit); pCrateArrayLP++; }
			continue;
		}

		if (kbUnitIsType(pResourceUnit, cUnitTypeMinedResource))
		{
			xsArraySetInt(pMinedResourceArray, pMinedResourceArrayLP, pResourceUnit); pMinedResourceArrayLP++; 
			continue;
		}

		if (kbUnitIsType(pResourceUnit, gPlantationUnit))
		{
			if (pPlantationArrayLP < 20) { xsArraySetInt(pPlantationArray, pPlantationArrayLP, pResourceUnit); pPlantationArrayLP++; }
			continue;
		}

		if (kbUnitIsType(pResourceUnit, cUnitTypeGold))
		{
			if (pCoinArrayLP < 20) { xsArraySetInt(pCoinArray, pCoinArrayLP, pResourceUnit); pCoinArrayLP++; }
			continue;
		}
	}

	if ((pMinedResourceArrayLP + pPlantationArrayLP + pCoinArrayLP) == 0 && pGoldGatherRange < pGoldGatherRangeMax) pGoldGatherRange = pGoldGatherRange + 10;
	if ((pHerdableArrayLP + pHuntableArrayLP + pFruitArrayLP) == 0 && pFoodGatherRange < pFoodGatherRangeMax) pFoodGatherRange = pFoodGatherRange + 10;
	if (pWoodArrayLP == 0 && pWoodGatherRange < pWoodGatherRangeMax) pWoodGatherRange = pWoodGatherRange + 10;

	if (pCrateArrayLP + pHerdableArrayLP + pHuntableArrayLP + pFruitArrayLP + pFarmArrayLP + pFoodArrayLP +
		pMinedResourceArrayLP + pPlantationArrayLP + pCoinArrayLP + pWoodArrayLP == 0)
	{
		return;
	}
	pWcountChange = pWcount;
	pFcountChange = pFcount;
	pGcountChange = pGcount;
	pPercentOnFoodChange = ((pFcount - pFoodRemoveCount) / gCurrentAliveSettlers) * 100.0;
	pPercentOnGoldChange = ((pGcount - pGoldRemoveCount) / gCurrentAliveSettlers) * 100.0;

	if (pPercentOnFood > pForcastFoodPercent || pPercentOnGold > pForcastGoldPercent || pPercentOnWood > pForcastWoodPercent)
	{
		for (i = 0; < gCurrentAliveSettlers + 1)
		{
			settlerId = kbUnitQueryGetResult(getAliveSettlersQuery, i);
			if (settlerId == -1) break;
			if (kbUnitGetActionType(settlerId) == 9) continue;
			if(checkExcludeSettler(settlerId)) continue;
			if (pPercentOnWood > pForcastWoodPercent)
			{
				pPercentDiff = pPercentOnWood - pForcastWoodPercent;
				if (pPercentDiff > 20)
				{
					if (kbUnitIsType(kbUnitGetTargetUnitID(settlerId), cUnitTypeWood) == true &&
						kbUnitIsType(kbUnitGetTargetUnitID(settlerId), cUnitTypeAbstractResourceCrate) == false)
					{
						pWcountChange--;
						pPercentOnWoodChange = (pWcountChange / gCurrentAliveSettlers) * 100.0;
						if (pPercentOnWoodChange > pForcastWoodPercent)
						{
							pPercentOnWood = pPercentOnWoodChange;
							aiTaskUnitMove(settlerId, kbUnitGetPosition(settlerId));
							continue;
						}
					}
				}
			}
			if (pPercentOnFood > pForcastFoodPercent)
			{
				pPercentDiff = pPercentOnFood - pForcastFoodPercent;

				if (pPercentDiff > 20)
				{
					if (kbUnitIsType(kbUnitGetTargetUnitID(settlerId), cUnitTypeFood) == true &&
						kbUnitIsType(kbUnitGetTargetUnitID(settlerId), cUnitTypeAbstractResourceCrate) == false)
					{
						pFcountChange--;
						pPercentOnFoodChange = (pFcountChange / gCurrentAliveSettlers) * 100.0;
						if (pPercentOnFoodChange > pForcastFoodPercent)
						{
							pPercentOnFood = pPercentOnFoodChange;
							aiTaskUnitMove(settlerId, kbUnitGetPosition(settlerId));
							continue;
						}
					}
				}
			}
			if (pPercentOnGold > pForcastGoldPercent)
			{
				pPercentDiff = pPercentOnGold - pForcastGoldPercent;

				if (pPercentDiff > 20)
				{
					if (kbUnitIsType(kbUnitGetTargetUnitID(settlerId), cUnitTypeGold) == true &&
						kbUnitIsType(kbUnitGetTargetUnitID(settlerId), cUnitTypeAbstractResourceCrate) == false)
					{
						pGcountChange--;
						pPercentOnGoldChange = (pGcountChange / gCurrentAliveSettlers) * 100.0;
						if (pPercentOnGoldChange > pForcastGoldPercent)
						{
							pPercentOnGold = pPercentOnGoldChange;
							aiTaskUnitMove(settlerId, kbUnitGetPosition(settlerId));
							continue;
						}
					}
				}
			}
		}
	}
	if (pPercentOnFood < pForcastFoodPercent) pNeedFood = true;
	if (pPercentOnGold < pForcastGoldPercent) pNeedGold = true;
	if (pPercentOnWood < pForcastWoodPercent) pNeedWood = true;


	for (i = 0; < xsArrayGetSize(idleArray))
	{
		settlerId = xsArrayGetInt(idleArray, i);
		if (settlerId == -1) break;
		if(kbUnitGetActionType(settlerId) != 7) continue; 
		if (kbUnitGetActionType(settlerId) == 9) continue; 
		if (checkExcludeSettler(settlerId) == true) continue; 
		
		for(j = 0; < 500)
		{
			if(kbUnitQueryGetResult(pWoodQry, j) == -1) break;

			if(kbUnitIsInventoryFull(kbUnitQueryGetResult(pWoodQry, j)))
			{
				if (getEnemyUnitPathStatus(kbUnitGetPosition(settlerId),kbUnitGetPosition(kbUnitQueryGetResult(pWoodQry, j))) > 1)continue;
				aiTaskUnitWork(settlerId, kbUnitQueryGetResult(pWoodQry, j));
				break;
			}
		}
		xsArraySetInt(idleArray, i, -1);
		pNearestResourceDist = 9999999.0;
		pNearestResourceId = -1;
		decideResourceValue = -1;

		if (pPercentOnFood > pForcastFoodPercent) pNeedFood = false;
		if (pPercentOnGold > pForcastGoldPercent) pNeedGold = false;
		if (pPercentOnWood > pForcastWoodPercent) pNeedWood = false;

		if (kbUnitIsType(settlerId, cUnitTypeGoldMiner))
		{
			pNeedFood = false;
			pNeedGold = true;
			pNeedWood = false;
		}

		if (pNeedFood == false && pNeedGold == false && pNeedWood == false)
		{
			pNeedFood = true;
			pNeedGold = true;
			pNeedWood = true;
		}
		if(gCurrentWood > 5000)pNeedWood = false;

		if (pNeedWood == true)
		{
			pResourceValue = pf_gathererManager_decideResource(pCrateArray, settlerId, cUnitTypeAbstractResourceCrate, cResourceWood, pAddedThisRoundIdArray, pAddedThisRoundNumArray);
			if (pResourceValue != -1) decideResourceValue = pResourceValue;
			if (decideResourceValue == -1) decideResourceValue = pf_gathererManager_decideResource(pWoodArray, settlerId, cUnitTypeWood, cResourceWood, pAddedThisRoundIdArray, pAddedThisRoundNumArray);
			if (decideResourceValue != -1)
			{
				pWcount++;
				pPercentOnWood = (pWcount / gCurrentAliveSettlers) * 100.0;
			}
		}

		static int pCrateTimer = 0;
		bool pSendtoCrate = true;
		if(functionDelay(pCrateTimer, 1000,"pSendtoCrate") == false) 
		{
			pSendtoCrate = false;
		}
		else
		{
			pCrateTimer = gCurrentGameTime;
		}

		if (pNeedFood == true && decideResourceValue == -1)
		{
			pResourceValue = pf_gathererManager_decideResource(pCrateArray, settlerId, cUnitTypeAbstractResourceCrate, cResourceFood, pAddedThisRoundIdArray, pAddedThisRoundNumArray);
			if (pSendtoCrate && pResourceValue != -1) decideResourceValue = pResourceValue;
			
			if(getCivSlaughterAbility())
			{
				static int pLiveStockTime = 0;
				bool pSendtoLiveStock = true;
				if(functionDelay(pLiveStockTime, 1000,"pLiveStockTime") == false) 
				{
					pSendtoLiveStock = false;
				}
				else
				{
					pLiveStockTime = gCurrentGameTime;
				}

				if (pSendtoLiveStock == true && decideResourceValue == -1 && kbUnitCount(cMyID, cUnitTypeHerdable, cUnitStateDead) == 0) decideResourceValue = pf_gathererManager_decideResource(pHerdableArray, settlerId, cUnitTypeHerdable, cResourceFood, pAddedThisRoundIdArray, pAddedThisRoundNumArray);
			}
			if (decideResourceValue == -1) decideResourceValue = pf_gathererManager_decideResource(pHuntableArray, settlerId, cUnitTypeHuntable, cResourceFood, pAddedThisRoundIdArray, pAddedThisRoundNumArray);
			
			if (getCivHuntAbility())
			{
				if (decideResourceValue == -1 && kbUnitCount(cMyID, cUnitTypeAnimalPrey, cUnitStateDead) == 0 && getUnitCountByLocation(cUnitTypeAnimalPrey, cPlayerRelationAny, cUnitStateAlive, gMainTownCenterLocation, 15.0) < 3) decideResourceValue = pf_gathererManager_decideResource(pFruitArray, settlerId, cUnitTypeAbstractFruit, cResourceFood, pAddedThisRoundIdArray, pAddedThisRoundNumArray);
			}
			if (decideResourceValue == -1) decideResourceValue = pf_gathererManager_decideResource(pFruitArray, settlerId, cUnitTypeAbstractFruit, cResourceFood, pAddedThisRoundIdArray, pAddedThisRoundNumArray);

			if (decideResourceValue == -1) decideResourceValue = pf_gathererManager_decideResource(pFarmArray, settlerId, cUnitTypeAbstractFarm, cResourceFood, pAddedThisRoundIdArray, pAddedThisRoundNumArray);
			
			if (decideResourceValue == -1) decideResourceValue = pf_gathererManager_decideResource(pFoodArray, settlerId, cUnitTypeFood, cResourceFood, pAddedThisRoundIdArray, pAddedThisRoundNumArray);
			if (decideResourceValue != -1)
			{
				pFcount++;
				pPercentOnFood = (pFcount / gCurrentAliveSettlers) * 100.0;
			}
		}
		if (pNeedGold == true && decideResourceValue == -1)
		{
			pResourceValue = pf_gathererManager_decideResource(pCrateArray, settlerId, cUnitTypeAbstractResourceCrate, cResourceGold, pAddedThisRoundIdArray, pAddedThisRoundNumArray);
			if (pSendtoCrate && pResourceValue != -1) decideResourceValue = pResourceValue;
			if (decideResourceValue == -1) decideResourceValue = pf_gathererManager_decideResource(pMinedResourceArray, settlerId, cUnitTypeMinedResource, cResourceGold, pAddedThisRoundIdArray, pAddedThisRoundNumArray);
			if (decideResourceValue == -1) decideResourceValue = pf_gathererManager_decideResource(pPlantationArray, settlerId, gPlantationUnit, cResourceGold, pAddedThisRoundIdArray, pAddedThisRoundNumArray);
			if (decideResourceValue == -1) decideResourceValue = pf_gathererManager_decideResource(pCoinArray, settlerId, cUnitTypeGold, cResourceGold, pAddedThisRoundIdArray, pAddedThisRoundNumArray);
			if (decideResourceValue != -1)
			{
				pGcount++;
				pPercentOnGold = (pGcount / gCurrentAliveSettlers) * 100.0;
			}
		}

			
		if (decideResourceValue != -1 && checkResourceAssignment( decideResourceValue , unitGathererLimit(kbUnitGetProtoUnitID(decideResourceValue)) ) == false )
		{
			for (j = 0; < 1000)
			{
				pAssignedValue = xsArrayGetInt(pAddedThisRoundIdArray, j);
				if (pAssignedValue == -1)
				{
					xsArraySetInt(pAddedThisRoundIdArray, j, decideResourceValue);
					xsArraySetInt(pAddedThisRoundNumArray, j, 1);
					break;
				}
				else if (pAssignedValue == decideResourceValue)
				{

					arrayVale = xsArrayGetInt(pAddedThisRoundNumArray, j);
					arrayVale++;
					xsArraySetInt(pAddedThisRoundNumArray, j, arrayVale);
					break;
				}
			}

			aiTaskUnitWork(settlerId, decideResourceValue);
			if(kbUnitIsType(decideResourceValue, cUnitTypeChickenPen)) pChickenCount++;
			else if(kbUnitIsType(decideResourceValue, cUnitTypeBerryBush))gBerryCount++;
			else if(kbUnitIsType(decideResourceValue, cUnitTypeHerdable))gLivestock++;
			
		}
		else
		{
			decideResourceValue = pf_gathererManager_decideResource(pFarmArray, settlerId, gFarmUnit, cResourceFood, pAddedThisRoundIdArray, pAddedThisRoundNumArray);
			if (decideResourceValue == -1) decideResourceValue = pf_gathererManager_decideResource(pPlantationArray, settlerId, cUnitTypeGold, cResourceGold, pAddedThisRoundIdArray, pAddedThisRoundNumArray);
			
			if (decideResourceValue != -1) 
			{
				decideResourceValue = getUnitByLocation(gFarmUnit, cPlayerRelationSelf, cUnitStateAlive, gMainTownCenterLocation, 1000);
				if (decideResourceValue == -1) decideResourceValue = getUnitByLocation(gPlantationUnit, cPlayerRelationSelf, cUnitStateAlive, gMainTownCenterLocation, 1000);
				if (decideResourceValue == -1) decideResourceValue = pf_gathererManager_decideResource(pWoodArray, settlerId, cUnitTypeWood, cResourceWood, pAddedThisRoundIdArray, pAddedThisRoundNumArray);
				if (decideResourceValue != -1) aiTaskUnitWork(settlerId,decideResourceValue);
			}
			
		}
	}
}


//==============================================================================
/*
 popManager
 updatedOn 2022/09/01
 Updates 
 - Settler pop and maintain plan
 - MilitaryPop
 - Deletes settlers when in age 5 if they have large amounts of resources
 
 How to use
 popManager();
*/
//==============================================================================
void popManager()
{
	debugRule("popManager", -1);
	static bool pFirstRun = true;
	static int pLastSettlerBuildLimit = -1;
	static bool pSettlerUpdate = true;
	static bool pUpdateMilitaryPop = true;
	static int pLastAgeSettlerUpdate = -1;
	
	static int pLastRunTime = 0;
	if(functionDelay(pLastRunTime, 5000,"popManager") == false) return;
	pLastRunTime = gCurrentGameTime;
	
	if(pFirstRun)
	{ //only run once
		pFirstRun = false;
		switch (gWorldDifficulty)
		{ //sets the Economy and military caps per difficulty level
			case cDifficultySandbox:
				{ // Sandbox
					aiSetEconomyPop(20);
					aiSetMilitaryPop(5);
					setMilPopLimit(5, 5, 5, 5, 5); //cap military per age 
					break;
				} //end case
			default:
				{ // All other difficulty levels
					aiSetEconomyPop(gMaxVillPop); //The villiage train pop cap, use max
					aiSetMilitaryPop(200);
					setMilPopLimit(0, 20, 200, 200, 200); //cap military per age 
					break;
				} //end default
		} //end switch
		xsArraySetInt(gTargetSettlerCounts, cAge1, 16); //16
		xsArraySetInt(gTargetSettlerCounts, cAge2, 32); //32
		xsArraySetInt(gTargetSettlerCounts, cAge3, gMaxVillPop);
		xsArraySetInt(gTargetSettlerCounts, cAge4, gMaxVillPop);
		xsArraySetInt(gTargetSettlerCounts, cAge5, gMaxVillPop);		
	} //end if
	
	if (gCurrentCiv != cCivOttomans) 
	{ //skip if Ottomans
		if(gSettlerMaintainPlan == -1) gSettlerMaintainPlan = createSimpleMaintainPlan(gEconUnit, gMaxVillPop, true, gMainBase, 2,gSettlerMaintainPlan); //create settler maintain plan
		if(pLastAgeSettlerUpdate != gCurrentAge)
		{ //check if there is an age change
			aiPlanSetVariableInt(gSettlerMaintainPlan, cTrainPlanNumberToMaintain, 0, xsArrayGetInt(gTargetSettlerCounts, gCurrentAge)); //update maintain number
			aiPlanSetBaseID(gSettlerMaintainPlan, gMainBase); //update base
			pLastAgeSettlerUpdate = gCurrentAge; //update last age change
		} //end if
	} //end if
	
	if(pUpdateMilitaryPop && gWorldDifficulty != cDifficultySandbox)
	{ //skip if sanbox and pUpdateMilitaryPop is true
		switch(gCurrentAge)
		{ //Set Military Pop based on age
			case cAge1:
			{
				if(gGoodArmyPop != 0) aiSetMilitaryPop(0);
				break;
			}
			case cAge2:
			{
				if(gGoodArmyPop != 20) aiSetMilitaryPop(20);
				break;
			}
			default:
			{
				aiSetMilitaryPop(200);
				pUpdateMilitaryPop = false;
				break;
			}	
		} //end switch
	} //end if

	if(gCurrentCiv == cCivItalians)
	{
		static int pPilgrimPlan = -1;
		static int pPilgrimNum = -1;
		pPilgrimNum = kbGetBuildLimit(cMyID,cUnitTypePilgrim);

		if (pPilgrimPlan == -1 && kbUnitCount(cMyID, gChurchUnit, cUnitStateAlive) > 0)
		{
			pPilgrimPlan = createSimpleMaintainPlan(cUnitTypePilgrim, pPilgrimNum , false, kbBaseGetMainID(cMyID), pPilgrimNum,pPilgrimPlan);
		}
	}
	debugRule("popManager - end", 0);
} //end popManager

void tradePostManager()
{ //Controls when the ai builds VP sites
	static int lastRunTime = 0;
	static int timeRan = 0; //add some extra random time
	if(gCurrentGameTime < lastRunTime + 10000 + timeRan )return;
	lastRunTime = gCurrentGameTime;
	timeRan = aiRandInt(10);
	timeRan = timeRan * 1000;
	
	if (gCurrentGameTime - gTradePostManagerTime < 60000) return;
	gTradePostManagerTime = gCurrentGameTime;
	if (gCurrentAge == cAge1) return;
	if (kbUnitCount(cMyID, gStableUnit, cUnitStateAlive) + kbUnitCount(cMyID, gBarracksUnit, cUnitStateAlive) == 0) return;
	if (gCurrentAge == cAge2 && kbUnitCount(cMyID, cUnitTypeVictoryPointBuilding, cUnitStateABQ) > 1) return;

	static int vpSiteArray = -1;
	int tradepostQuery = -1;
	//search for VP sites
	if (tradepostQuery == -1) 
	{
		tradepostQuery = kbUnitQueryCreate("tradepostQuery"+getQueryId());
		kbUnitQuerySetPlayerID(tradepostQuery, 0,false);
		kbUnitQuerySetPlayerRelation(tradepostQuery, -1);
		kbUnitQuerySetUnitType(tradepostQuery, cUnitTypeSocket);
		kbUnitQuerySetState(tradepostQuery, cUnitStateAlive);
		kbUnitQuerySetAscendingSort(tradepostQuery, true);
	}
	kbUnitQueryResetResults(tradepostQuery);
	kbUnitQuerySetPosition(tradepostQuery, gMainTownCenterLocation);
	
	int vpList = kbUnitQueryExecute(tradepostQuery);
	int siteID = -1;
	int tradepostPlan = -1;
	if (vpSiteArray == -1) vpSiteArray = xsArrayCreateInt(vpList, -1, "VPsites");
	for (i = 0; < kbUnitQueryExecute(tradepostQuery))
	{
		if (i == 1 && gCurrentAge == cAge2) return;
		if (i == 2 && gCurrentAge == cAge3) return;
		if (aiPlanGetState(xsArrayGetInt(vpSiteArray, i)) != -1) continue;
		siteID = kbUnitQueryGetResult(tradepostQuery, i);
		if (aiTreatyActive() == true && distance(gMainTownCenterLocation, kbUnitGetPosition(siteID)) > 20) continue;
		//check for free VP site
		static int availableVPCheck = -1;
		if (availableVPCheck == -1) 
		{
			availableVPCheck = kbUnitQueryCreate("availableVPCheck"+getQueryId());
			kbUnitQuerySetPlayerID(availableVPCheck,-1,false);
			kbUnitQuerySetPlayerRelation(availableVPCheck, cPlayerRelationAny);
			kbUnitQuerySetIgnoreKnockedOutUnits(availableVPCheck, true);
			kbUnitQuerySetState(availableVPCheck, cUnitStateABQ);
		}
		kbUnitQueryResetResults(availableVPCheck);
		kbUnitQuerySetUnitType(availableVPCheck, cUnitTypeVictoryPointBuilding); //cUnitTypeLogicalTypeLandMilitary
		kbUnitQuerySetPosition(availableVPCheck, kbUnitGetPosition(siteID));
		kbUnitQuerySetMaximumDistance(availableVPCheck, 5);

		if (kbUnitQueryExecute(availableVPCheck) > 0) continue;
		//check for enemy
		static int enemyCheck = -1;
		if (enemyCheck == -1) 
		{
			enemyCheck = kbUnitQueryCreate("enemyCheck"+getQueryId());
			kbUnitQuerySetPlayerID(enemyCheck,-1,false);
			kbUnitQuerySetPlayerRelation(enemyCheck, cPlayerRelationEnemyNotGaia);
			kbUnitQuerySetUnitType(enemyCheck, cUnitTypeLogicalTypeLandMilitary); //
			kbUnitQuerySetState(enemyCheck, cUnitStateABQ);
		}
		kbUnitQueryResetResults(enemyCheck);
		kbUnitQuerySetPosition(enemyCheck, kbUnitGetPosition(siteID));
		kbUnitQuerySetMaximumDistance(enemyCheck, 20);
		kbUnitQuerySetIgnoreKnockedOutUnits(enemyCheck, true);
		
		if (kbUnitQueryExecute(enemyCheck) > 1) continue;
		//make a new build plan
		aiPlanDestroy(aiPlanGetState(xsArrayGetInt(vpSiteArray, i)));
		tradepostPlan = aiPlanCreate("tradepostPlan " + i, cPlanBuild);
		aiPlanSetVariableInt(tradepostPlan, cBuildPlanBuildingTypeID, 0, gTradingPostUnit);
		aiPlanSetDesiredPriority(tradepostPlan, 100); //80
		aiPlanSetMilitary(tradepostPlan, false);
		aiPlanSetEconomy(tradepostPlan, true);
		aiPlanSetEscrowID(tradepostPlan, cEconomyEscrowID);
		aiPlanAddUnitType(tradepostPlan, gEconUnit, 1, 1, 1);
		aiPlanSetVariableInt(tradepostPlan, cBuildPlanSocketID, 0, siteID);
		aiPlanSetActive(tradepostPlan);
		xsArraySetInt(vpSiteArray, i, tradepostPlan);
	}
}
//==============================================================================
/*
bringInhuntManager	
updatedOn 2021/11/09 By ageekhere
A method for using settlers to herd huntables towards their town center
*/
//==============================================================================
void bringInhuntManager(int settlerID = -1, int timeFromLastShot = -1, int hunterNum = 0, vector settlerTarget = cInvalidVector)
{
	//static int TC = -1;

	int huntableNum = 0;
	bool targetPassed = false;
	int time = 0;
	static int huntDistFromTc = 30; //how far from the TC does the huntable need to be before herding
	static int tcMinDist = 22;
	static int huntableId = -1;
	bool break_huntableLook = true;
	static int invalidCount = 3;
	static int huntDist = 2;
	static int huntAddTime = 30000;
	
	vector movePoint3 = cInvalidVector; //location to move the settler to
	float huntHealth = 0.9;
	if(kbUnitGetActionType(settlerID) == 9) return;


	//if (TC == -1 || kbUnitGetHealth(TC) <= 0.0) TC = getUnit(gTownCenter, cMyID, cUnitStateAlive); //Find a TC to herd to
	//search for huntables from a settler with a max distance
	static int huntableLook = -1;
	
	if (huntableLook == -1) 
	{
		huntableLook = kbUnitQueryCreate("bringInhunthuntableLook"+getQueryId());
		kbUnitQuerySetPlayerID(huntableLook, 0, false);
		kbUnitQuerySetPlayerRelation(huntableLook,-1);
		kbUnitQuerySetUnitType(huntableLook, cUnitTypeHuntable);
		kbUnitQuerySetState(huntableLook, cUnitStateAlive);
		kbUnitQuerySetAscendingSort(huntableLook, true);
		kbUnitQuerySetMaximumDistance(huntableLook, 60);
	}
	kbUnitQueryResetResults(huntableLook);
	kbUnitQuerySetPosition(huntableLook, kbUnitGetPosition(settlerID));
	
	
	huntableNum = kbUnitQueryExecute(huntableLook);
	for (i = 0; < kbUnitQueryExecute(huntableLook))
	{ //loop through the found hunts
		if(resourceEnemyCheck(kbUnitQueryGetResult(huntableLook, i)) == true) continue;	
		if (distance(kbUnitGetPosition(kbUnitQueryGetResult(huntableLook, i)), gMainTownCenterLocation) < tcMinDist || 
		kbUnitGetHealth(kbUnitQueryGetResult(huntableLook, i)) <= huntHealth) continue; //check distance
		targetPassed = true; //found target
		break;
	} //end for i
	
	if (targetPassed == false)
	{ //target not found
		//incress search distance
		kbUnitQueryResetResults(huntableLook);
		kbUnitQuerySetPlayerID(huntableLook, 0, false);
		kbUnitQuerySetUnitType(huntableLook, cUnitTypeHuntable);
		kbUnitQuerySetState(huntableLook, cUnitStateAlive);
		kbUnitQuerySetPosition(huntableLook, gMainTownCenterLocation);
		kbUnitQuerySetAscendingSort(huntableLook, true);
		kbUnitQuerySetMaximumDistance(huntableLook, 400);
		
		huntableNum = kbUnitQueryExecute(huntableLook);
	}
	if (huntableNum == 0) return; 
	
	
	if (kbUnitGetPlanID(settlerID) != -1)
	{
		for (k = 0; < xsArrayGetSize(gBringInHuntSettlers))
		{ //loop through the bring in hunt array
			if (xsArrayGetInt(gBringInHuntSettlers, k) == settlerID)
			{ //Find settler spot
				xsArraySetInt(gBringInHuntSettlers, k, -1); //remove the settler
				break;
			} //end if
		} //end for k
		
		if(checkExcludeSettler(settlerID) == true)
		{
			removeExcludeSettler(settlerID);
		}
		/*
		for (l = 0; < xsArrayGetSize(gExcludeSettlersArray))
		{ // add settler to the exclude array
			if (xsArrayGetInt(gExcludeSettlersArray, l) == settlerID)
			{ //find a free spot
				xsArraySetInt(gExcludeSettlersArray, l, -1);
				break;
			} //end if
		} //end for l
		*/
		return;
	}
	//aiPlanDestroy(kbUnitGetPlanID(settlerID)); //NOTE: issue with plans being addedd to settlers
		static int deadPray = -1;
		
	if (deadPray == -1) 
	{
		deadPray = kbUnitQueryCreate("bringInhuntDead"+getQueryId());
		kbUnitQuerySetPlayerID(deadPray, 0, false);
		kbUnitQuerySetUnitType(deadPray, cUnitTypeHuntable);
		kbUnitQuerySetState(deadPray, cUnitStateDead);
		kbUnitQuerySetAscendingSort(deadPray, true);
		kbUnitQuerySetMaximumDistance(deadPray, 30);
	}
	//search for dead hunts
	kbUnitQueryResetResults(deadPray);
	kbUnitQuerySetPosition(deadPray, kbUnitGetPosition(settlerID));
	kbUnitQueryExecute(deadPray);
	
	if(kbUnitGetActionType(settlerID) != 9)
	{
		for (i = 0; < kbUnitQueryExecute(deadPray))
		{ //check if dead huntable still has food
			if(resourceEnemyCheck(kbUnitQueryGetResult(deadPray, i)) == true) continue;	
			
			if(distance(gMainTownCenterLocation, kbUnitGetPosition(kbUnitQueryGetResult(deadPray, i))) < 30) continue;
			if (kbUnitGetCurrentInventory(kbUnitQueryGetResult(deadPray, i), cResourceFood) > 1 &&
				kbUnitQueryGetResult(deadPray, i) != -1)
			{
				aiTaskUnitWork(settlerID, kbUnitQueryGetResult(deadPray, i)); //temporary assign settler to a dead hunt 
				break;
			}
		}
	}
	
	
	
	time = gCurrentGameTime - timeFromLastShot; //get the time passed from settler last shot at hunt

	kbUnitQueryResetResults(deadPray);
	kbUnitQuerySetPlayerID(deadPray, 0, false);
	kbUnitQuerySetUnitType(deadPray, cUnitTypeHuntable);
	kbUnitQuerySetState(deadPray, cUnitStateDead);
	kbUnitQuerySetPosition(deadPray, kbUnitGetPosition(settlerID));
	kbUnitQuerySetAscendingSort(deadPray, true);
	kbUnitQuerySetMaximumDistance(deadPray, 30);

	kbUnitQueryExecute(deadPray);
	int huntableHasFood = -1;
	int huntableCount = 0;
	for (i = 0; < kbUnitQueryExecute(deadPray))
	{
		if(resourceEnemyCheck(kbUnitQueryGetResult(deadPray, i)) == true) continue;	
		if (kbUnitGetCurrentInventory(kbUnitQueryGetResult(deadPray, i), cResourceFood) > 0)
		{
			huntableHasFood = i;
			huntableCount++;
		}
	}

	if (xsArrayGetInt(gBringInHuntSettlerLastHunt, hunterNum) != -1 &&
		kbUnitGetHealth(xsArrayGetInt(gBringInHuntSettlerLastHunt, hunterNum)) > huntHealth)
	{ //check if the last hunt the settler has been assigned to is not -1 or health lower than 0.5
		huntableId = xsArrayGetInt(gBringInHuntSettlerLastHunt, hunterNum); //Assign settler to last target
	}
	else if (huntableCount > 1 && distance(kbUnitGetPosition(settlerID), gMainTownCenterLocation) > tcMinDist &&
	kbUnitGetHealth(xsArrayGetInt(gBringInHuntSettlerLastHunt, hunterNum)) > huntHealth)
	{
		if (kbUnitGetCurrentInventory(xsArrayGetInt(gBringInHuntSettlerLastHunt, hunterNum), cResourceFood) > 0)
		{
			huntableId = xsArrayGetInt(gBringInHuntSettlerLastHunt, hunterNum);
		}
		else
		{
			huntableId = kbUnitQueryGetResult(deadPray, huntableHasFood);
			aiTaskUnitWork(settlerID, huntableId);
		}
	}
	else
	{ //find a new target
		bool prayNearCheck = false;
		int lastHuntId = 0;
 		for (i = 0; < kbUnitQueryExecute(huntableLook))
		{ //loop through huntables
			if(resourceEnemyCheck(kbUnitQueryGetResult(huntableLook, i)) == true) continue;	
			for(j = 0; < xsArrayGetSize(gBringInHuntSettlerLastHunt) )
			{
				lastHuntId = xsArrayGetInt(gBringInHuntSettlerLastHunt, j);
				if(lastHuntId == huntableId) continue;
				if(lastHuntId == -1)break; 
				if( distance(kbUnitGetPosition(lastHuntId),kbUnitGetPosition(kbUnitQueryGetResult(huntableLook, i))) < 10 &&
					distance(kbUnitGetPosition(settlerID),kbUnitGetPosition(kbUnitQueryGetResult(huntableLook, i))) > 30)
				{
					prayNearCheck = true;
					break;
				}
			}
			//if(prayNearCheck == true) continue;
			if (kbUnitGetPosition(kbUnitQueryGetResult(huntableLook, i)) == cInvalidVector ||
				distance(kbUnitGetPosition(kbUnitQueryGetResult(huntableLook, i)), gMainTownCenterLocation) < tcMinDist) continue; //check for valid position
			
			if( kbCanPath2( kbUnitGetPosition(kbUnitQueryGetResult(huntableLook, i)), gMainTownCenterLocation, gEconUnit, 500) == false)continue;
			if(gIslandLanded && getWaterPathStatus(kbUnitGetPosition(kbUnitQueryGetResult(huntableLook, i)), gMainTownCenterLocation))continue;
			break_huntableLook = true; //set flag

			//Do not herd huntables 30m from any player's base (exclude self and dead players)
			for (x = 1; < cNumberPlayers)
			{ //loop through players
				if (cMyID != x)
				{ //x is not me	
					if (distance(kbUnitGetPosition(kbUnitQueryGetResult(huntableLook, i)), kbBaseGetLocation(x, kbBaseGetMainID(x))) < 30 && kbHasPlayerLost(x) == false)
					{ //check if hunt is 90m away
						break_huntableLook = false;
						break;
					} //end if
				} //end if
			} //end for x
			if (break_huntableLook == false) continue; //skip huntable

			for (y = 0; < gCurrentAliveSettlers)
			{
				if (kbUnitQueryGetResult(getAliveSettlersQuery, y) == settlerID) continue;

				if (distance(kbUnitGetPosition(kbUnitQueryGetResult(getAliveSettlersQuery, y)), kbUnitGetPosition(kbUnitQueryGetResult(huntableLook, i))) < 30)
				{
					break_huntableLook = false;
					break;
				}
			}

			if(getIsAnimalGathered(kbUnitQueryGetResult(huntableLook, i)) == true) continue; 

			//Check if a huntable is near a shrine
			/*
			static int shrinesAll = -1;
			
			if (shrinesAll == -1) 
			{
				shrinesAll = kbUnitQueryCreate("shrinesAll"+getQueryId());
				kbUnitQuerySetPlayerID(shrinesAll, -1,false);
				kbUnitQuerySetPlayerRelation(shrinesAll, cPlayerRelationAny);
				kbUnitQuerySetUnitType(shrinesAll, cUnitTypeShrine);
				kbUnitQuerySetState(shrinesAll, cUnitStateAlive);
			}
			kbUnitQueryResetResults(shrinesAll);
			
			for(y = 0; < kbUnitQueryExecute(shrinesAll))
			{
				if (distance(kbUnitGetPosition(kbUnitQueryGetResult(shrinesAll, y)), kbUnitGetPosition(kbUnitQueryGetResult(huntableLook, i))) < 5)
				{
					break_huntableLook = false;
					break;
				}
			}
			*/
			
			if (break_huntableLook == false) continue;
			//Check if hunt is not to close to your TC and that the health is not to low to avoid killing the hunt
			if (distance(kbUnitGetPosition(kbUnitQueryGetResult(huntableLook, i)), gMainTownCenterLocation) > huntDistFromTc &&
				kbUnitGetHealth(kbUnitQueryGetResult(huntableLook, i)) > huntHealth)
			{
				for (j = 0; < xsArrayGetSize(gBringInHuntSettlerTarget))
				{ //loop through the targets
					if (xsArrayGetVector(gBringInHuntSettlerTarget, j) == cInvalidVector) continue; //skip invaild positions

					if (distance(kbUnitGetPosition(kbUnitQueryGetResult(huntableLook, i)), xsArrayGetVector(gBringInHuntSettlerTarget, j)) < tcMinDist)
					{ //check distance		

						if (xsArrayGetInt(gBringInHuntSettlers, j) == settlerID)
						{ //check for a settler match
							break;
						}
						else
						{
							break_huntableLook = false;
							break;
						}
					} //end if	
				} //end for
				if (break_huntableLook == true)
				{
					huntableId = kbUnitQueryGetResult(huntableLook, i);
					xsArraySetInt(gBringInHuntSettlerLastHunt, hunterNum, huntableId);
					break;
				}
			}

		}
	}
	if(huntableId == -1)return;
	
	float timeWalk = distance(kbUnitGetPosition(huntableId), kbUnitGetPosition(settlerID)) /4.0;
	timeWalk = timeWalk * 1000;
	float totalTime = 15500 - time - timeWalk;
	
	
	if(totalTime > 0) return;
	if (kbUnitGetPosition(huntableId) == cInvalidVector) return; //check to make sure the huntable has a vaild position
	
	//Move the settler so it is inline with the hunt to the tc so when the setter shoots the huntable they will run towards the TC
	float tcX = xsVectorGetX(gMainTownCenterLocation); //the TC x Value
	float tcZ = xsVectorGetZ(gMainTownCenterLocation); //the TC z Value
	float huntableX = xsVectorGetX(kbUnitGetPosition(huntableId)); //The huntable x Value
	float huntableZ = xsVectorGetZ(kbUnitGetPosition(huntableId)); //The huntable z Value
	float tringleAopposite = 0; //(Right angle tringle) opposite value from TC to huntable
	float tringleAhypotenuse = distance(gMainTownCenterLocation, kbUnitGetPosition(huntableId)); //(Right angle tringle) hypotenuse value from TC to huntable
	float tringleAbetaAngle = 0; //(Right angle tringle) beta angle value from TC to huntable
	float tringleBopposite = 0; //(Right angle tringle) opposite value from huntable to herd location
	float tringleBadjacent = 0; //(Right angle tringle) adjacent value from huntable to herd location
	float herdDist = 5; //The distance from the huntable the settler will herd from

	tringleAopposite = tcX - huntableX; //(Right angle tringle from TC to huntable) Find the opposite Value
	if (tringleAopposite < 0) tringleAopposite = tringleAopposite * -1; //If the value is negative flip to positive
	tringleAbetaAngle = xsACos((tringleAopposite / tringleAhypotenuse)); //(Right angle tringle from TC to huntable) Find the Beta Angle Value
	tringleAbetaAngle = tringleAbetaAngle * 180 / gPiValue; //Convert tringleAbetaAngle to a degree value 
	tringleBopposite = xsSin(tringleAbetaAngle * gPiValue / 180) * herdDist; //(Right angle tringle from huntable to hunt locaiton) Find the opposite Value
	tringleBadjacent = xsCos(tringleAbetaAngle * gPiValue / 180) * herdDist; //(Right angle tringle from huntable to hunt locaiton) Find the adjacent Value

	//Find movePoint3 
	if (huntableX < tcX)
		movePoint3 = xsVectorSetX(movePoint3, huntableX - tringleBadjacent);
	else
		movePoint3 = xsVectorSetX(movePoint3, huntableX + tringleBadjacent);

	if (huntableZ < tcZ)
		movePoint3 = xsVectorSetZ(movePoint3, huntableZ - tringleBopposite);
	else
		movePoint3 = xsVectorSetZ(movePoint3, huntableZ + tringleBopposite);
	
	aiTaskUnitMove(settlerID, movePoint3); //move settler to location
	xsArraySetVector(gBringInHuntSettlerTarget, hunterNum, kbUnitGetPosition(huntableId)); //set the settler location

	//Check if settler is in position
	time = gCurrentGameTime - timeFromLastShot;
	if (distance(kbUnitGetPosition(settlerID), movePoint3) < huntDist)
	{
		aiTaskUnitWork(settlerID, huntableId);
		xsArraySetInt(gBringInHuntSettlerTime, hunterNum, gCurrentGameTime);
	}
	else if (time > 60000 && time < 70000 && distance(kbUnitGetPosition(settlerID), movePoint3) < 6)
	{
		aiTaskUnitWork(settlerID, huntableId);
		xsArraySetInt(gBringInHuntSettlerTime, hunterNum, gCurrentGameTime);
	}
	else if (time >= 70000 && distance(kbUnitGetPosition(settlerID), movePoint3) < 8)
	{
		aiTaskUnitWork(settlerID, huntableId);
		xsArraySetInt(gBringInHuntSettlerTime, hunterNum, gCurrentGameTime);
	}

	if (kbAreaGetType(kbAreaGetIDByPosition(movePoint3)) == cAreaTypeWater ||
		kbAreaGetType(kbAreaGetIDByPosition(movePoint3)) == cAreaTypeForest ||
		kbAreaGetType(kbAreaGetIDByPosition(movePoint3)) == cAreaTypeImpassableLand ||
		kbAreaGetType(kbAreaGetIDByPosition(movePoint3)) == cAreaTypeVPSite)
	{
		if (distance(kbUnitGetPosition(settlerID), movePoint3) < invalidCount)
		{
			invalidCount = 3;
			aiTaskUnitWork(settlerID, huntableId);
			xsArraySetInt(gBringInHuntSettlerTime, hunterNum, gCurrentGameTime);
		}
		else
		{
			invalidCount = invalidCount + 1;
		}
	}
}



void managerMain()
{

}