//researchTechs

/*
void researchCheck(int rTech = -1, int pri = -1, int buildingId = -1, int escrowID = -1)
{ //Checks to see if a new Research Plan can be made
	if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, rTech) != -1) return; //Check if there is allready a research plan
	if (kbTechGetStatus(rTech) == cTechStatusActive || kbTechGetStatus(rTech) != cTechStatusObtainable) return; // Disable rule once upgraded or tech is unobtainable
	if (kbUnitCount(cMyID, buildingId, cUnitStateAlive) < 1) return;
	createSimpleResearchPlan(rTech, getUnit(buildingId), escrowID, pri);
}
*/
void researchCheck(int rTech = -1, int pri = -1, int buildingId = -1, int escrowID = -1)
{ //Checks to see if a new Research Plan can be made
	if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, rTech) != -1) return; //Check if there is allready a research plan
	if (kbTechGetStatus(rTech) == cTechStatusActive || kbTechGetStatus(rTech) != cTechStatusObtainable) return; // Disable rule once upgraded or tech is unobtainable
	if (kbUnitCount(cMyID, buildingId, cUnitStateAlive) < 1) return;

	/*
		get all buildings
		loop
			if (kbProtoUnitCanResearch(protoUnit, tech) == true) have building

	*/
	aiTaskUnitResearch(getUnit(buildingId) ,rTech );
	//createSimpleResearchPlan(rTech, getUnit(buildingId), escrowID, pri);
}



//civ techs
//british 
//
/*
arrayBritishTechs = xsArrayCreateInt(1000, -1, "British techs");
xsArraySetInt(arrayBritishTechs, 0, value);
for(i = 0;< 1000)
{
	if(pTech == xsArrayGetInt(arrayBritishTechs, i)) return(true)
}
*/
bool techStatus(int pTech = -1)
{

	if (kbTechGetStatus(pTech) != cTechStatusObtainable ||
	    kbTechGetStatus(pTech) == cTechStatusActive || 
        kbCanAffordTech(pTech,cEconomyEscrowID) == false ||
        aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, pTech) != -1)
		{		
			return(false);
		} 
		
	aiTaskUnitResearch(cUnitTypeBuilding ,pTech );
	return(true);
}
//techStatus(cTechHuntingDogs)
/*
age 1
cTechypSelectiveBreeding 	cUnitTypehouse
cTechHuntingDogs			cUnitTypeMarket
cTechGangsaw 				cUnitTypeMarket
cTechPlacerMines			cUnitTypeMarket
cTechFrontierTraining		cUnitTypeMarket
cTechGillNets					cUnitTypeDock



*/

void researchNew()
{
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"researchTech") == false) return;
	lastRunTime = gCurrentGameTime;
	
	//techStatus(cTechHuntingDogs);
	//techStatus(cTechSteelTraps);
	//techStatus(cTechypMarketGangsaw);
	
	
	/*
	int britishEArray = xsArrayCreateInt(100,-1, "britishEArray");
	xsArraySetInt(britishEArray, 0, tech1);
	xsArraySetInt(britishEArray, 0, tech2);

	int britishMArray = xsArrayCreateInt(100,-1, "britishMArray");
	xsArraySetInt(britishMArray, 0, tech1);

	int techE2dArray = xs2DArrayCreate();
	int techM2dArray = xs2DArrayCreate();


	for(i =0; < 100)
	{
		xs2DArraySetInt(techE2dArray, 0,i,xsArrayGetInt(britishEArray,i) );
		xs2DArraySetInt(techE2dArray, 1,i,0);

		xs2DArraySetInt(techM2dArray, 0,i,xsArrayGetInt(britishMArray,i));
		xs2DArraySetInt(techM2dArray, 1,i,0);
	}

	for(i =0; < 100)
	{
		 int value = xs2DArrayGetInt(techE2dArray, 1,i);
		 if(value == -1)return;
		 if(xs2DArrayGetInt(techE2dArray, 1,i) == 1) continue;
		 int techID = xs2DArrayGetInt(techE2dArray, 1,i);
		 techStatus(cTechHuntingDogs);
		 
	}


	*/


}
void researchTech()
{
	//static int lastRunTime = 0;
	//if(functionDelay(lastRunTime, 10000,"researchTech") == false) return;
	//lastRunTime = gCurrentGameTime;
	
	//int countPlans = aiPlanGetNumber(cPlanResearch, -1, true);
	
	//if(countPlans > 1) return;
	if(	gCurrentAge < cAge4 && gCurrentGameTime > 900000 )return;

	static int natArraySize = -1;
	if(natArraySize == -1) natArraySize = xsArrayGetSize(gNatTechs);
	for(i = 0; < natArraySize)
	{
		if(gCurrentAge < cAge3) break;
		if (kbUnitCount(cMyID, cUnitTypeTradingPost, cUnitStateAlive) == 0 && 
		kbUnitCount(cMyID, cUnitTypeypTradingPostCapture, cUnitStateAlive) == 0 &&
		kbUnitCount(cMyID, cUnitTypeypSPCNoblesHut, cUnitStateAlive) == 0 &&
		kbUnitCount(cMyID, cUnitTypeypTradingPostAsian, cUnitStateAlive) == 0
		) break;
		
		int value = xs2DArrayGetInt(gNatTech2dArray, 0,i);
		if(value == -1) continue;
		if(xs2DArrayGetInt(gNatTech2dArray, 1,i) == 1) continue;
		int techID = xs2DArrayGetInt(gNatTech2dArray, 0,i);
		if(kbTechGetStatus(techID) == cTechStatusActive)
		{
			xs2DArraySetInt(gNatTech2dArray, 1, i, 1);
			continue;
		}
		researchCheck(techID, 50, cUnitTypeTradingPost, cEconomyEscrowID); //techStatus(techID);
		researchCheck(techID, 50, cUnitTypeypTradingPostCapture, cEconomyEscrowID);
		researchCheck(techID, 50, cUnitTypeypSPCNoblesHut, cEconomyEscrowID);
		researchCheck(techID, 50, cUnitTypeypTradingPostAsian, cEconomyEscrowID);
	}
	
	researchCheck(cTechHuntingDogs, 100, cUnitTypeMarket, cEconomyEscrowID);
	researchCheck(cTechypMarketBerryDogs, 100, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
	researchCheck(cTechypMarketHuntingDogs, 100, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
	
	
	//if (gCurrentAge < cAge3) return;
	if (kbGetAge() > cAge4)
	{
		researchCheck(cTechFrontierTraining, 50, cUnitTypeMarket, cEconomyEscrowID);
		researchCheck(cTechSpiritMedicine, 50, cUnitTypeMarket, cEconomyEscrowID);
		researchCheck(cTechypMarketSpiritMedicine, 50, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
	}

	if (kbUnitCount(cMyID, cUnitTypeHerdable, cUnitStateAlive) >= 10) researchCheck(cTechSelectiveBreeding, 50, gFarmUnit, cEconomyEscrowID);
	if (kbUnitCount(cMyID, cUnitTypeHerdable, cUnitStateAlive) >= 10) researchCheck(cTechSelectiveBreeding, 50, gHouseUnit, cEconomyEscrowID);
	if (kbUnitCount(cMyID, cUnitTypeypGoat, cUnitStateAlive) >= 10) researchCheck(cTechSelectiveBreeding, 50, gHouseUnit, cEconomyEscrowID);
	if (kbUnitCount(cMyID, cUnitTypeypGoat, cUnitStateAlive) >= 10) researchCheck(cTechSelectiveBreeding, 50, gHouseUnit, cEconomyEscrowID);
	if (gFishingUnitNum >= 7) researchCheck(cTechGillNets, 50, gDockUnit, cEconomyEscrowID);
	if (xsGetTime() > 1800000) researchCheck(cTechBigLonghouseWoodlandDwellers, 50, gHouseUnit, cEconomyEscrowID);
	if (xsGetTime() > 1800000) researchCheck(cTechBigFarmStrawberry, 50, gFarmUnit, cEconomyEscrowID);
	if (kbUnitCount(cMyID, cUnitTypeAbstractCavalry, cUnitStateAlive) >= 10) researchCheck(cTechBigFarmHorsemanship, 50, gFarmUnit, cEconomyEscrowID);
	researchCheck(cTechGreatFeast, 50, gFarmUnit, cEconomyEscrowID);

	researchCheck(cTechypLivestockHoliness, 50, cUnitTypeypSacredField, cEconomyEscrowID);
	researchCheck(cTechypMonasteryPetAura, 50, cUnitTypeypMonastery, cEconomyEscrowID);
	researchCheck(cTechypMonasteryDiscipleAura, 50, cUnitTypeypMonastery, cEconomyEscrowID);
	
	if (gCurrentAge >= cAge2)
	{
		researchCheck(cTechEnableLongbowmen, 50, gBarracksUnit, cMilitaryEscrowID);
		researchCheck(cTechSteelTraps, 100, cUnitTypeMarket, cEconomyEscrowID);
		researchCheck(cTechLogFlume, 50, cUnitTypeMarket, cEconomyEscrowID);
		researchCheck(cTechAmalgamation, 50, cUnitTypeMarket, cEconomyEscrowID);
		researchCheck(cTechForestPeopleCeremony, 50, cUnitTypeMarket, cEconomyEscrowID);
		researchCheck(cTechNativeMarketGold, 50, cUnitTypeMarket, cEconomyEscrowID);
		researchCheck(cTechForestPeopleCeremony, 50, cUnitTypeMarket, cEconomyEscrowID);
		researchCheck(cTechNativeMarketGold, 50, cUnitTypeMarket, cEconomyEscrowID);
		researchCheck(cTechypMarketCircularSaw, 50, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
		researchCheck(cTechypMarketSteelTraps, 50, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
		researchCheck(cTechypMarketWheelbarrow2, 50, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
		researchCheck(cTechypMarketAmalgamation, 50, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
		researchCheck(cTechypMarketBerryTraps, 50, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
		researchCheck(cTechypMarketLogFlume, 50, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
		researchCheck(cTechSeedDrill, 50, cUnitTypeMill, cEconomyEscrowID);
		researchCheck(cTechHarvestCeremony, 50, gFarmUnit, cEconomyEscrowID);
		researchCheck(cTechEarthCeremony, 50, cUnitTypePlantation, cEconomyEscrowID);
		researchCheck(cTechEarthGiftCeremony, 50, cUnitTypePlantation, cEconomyEscrowID);
		researchCheck(cTechEarthCeremony, 50, cUnitTypePlantation, cEconomyEscrowID);
		researchCheck(cTechBigPlantationGunTrade, 50, cUnitTypePlantation, cEconomyEscrowID);
		if (xsGetTime() > 1800000) researchCheck(cTechBigPlantationMapleFestival, 50, cUnitTypePlantation, cEconomyEscrowID);
		researchCheck(cTechypCultivateWasteland, 50, cUnitTypeypRicePaddy, cEconomyEscrowID);
		researchCheck(cTechypCropMarket, 50, cUnitTypeypRicePaddy, cEconomyEscrowID);
		if ((kbUnitCount(cMyID, cUnitTypexpWarRifle, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypexpRifleRider, cUnitStateAlive)) > 12) researchCheck(cTechBigPlantationGunTrade, 50, cUnitTypePlantation, cEconomyEscrowID);
		if (xsGetTime() > 1800000) researchCheck(cTechBigDeer, 50, gLivestockPenUnit, cEconomyEscrowID);
		if (xsGetTime() > 1800000) researchCheck(cTechBigBisons, 50, gLivestockPenUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMissionary, cUnitStateAlive) > 4) researchCheck(cTechChurchMissionFervor, 50, gChurchUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypePriest, cUnitStateAlive) > 4) researchCheck(cTechChurchMissionFervor, 50, gChurchUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeImam, cUnitStateAlive) > 4) researchCheck(cTechChurchMissionFervor, 50, gChurchUnit, cEconomyEscrowID);
		
		if (gCurrentPop > 100) researchCheck(cTechChurchGasLighting, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchMilletSystem, 100, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchKopruluViziers, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchAbbassidMarket, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchGalataTowerDistrict, 100, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechypMonasteryImprovedHealing, 50, cUnitTypeypMonastery, cEconomyEscrowID);
		researchCheck(cTechypMonasteryShaolinWarrior, 50, cUnitTypeypMonastery, cEconomyEscrowID);
		researchCheck(cTechypMonasteryJapaneseHealing, 50, cUnitTypeypMonastery, cEconomyEscrowID);
		researchCheck(cTechypMonasteryJapaneseCombat, 50, cUnitTypeypMonastery, cEconomyEscrowID);
		researchCheck(cTechGreatCoatUS, 50, cUnitTypeSPCFortCenter, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractInfantry, cUnitStateAlive) >= 50) researchCheck(cTechBigWarHutLacrosse, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (xsGetTime() > 1800000) researchCheck(cTechBigWarHutBarometz, 50, cUnitTypeWarHut, cEconomyEscrowID);
		if ((kbUnitCount(cMyID, cUnitTypexpMusketRider, cUnitStateAlive) + kbUnitCount(cMyID, cUnitTypexpHorseman, cUnitStateAlive)) >= 25) researchCheck(cTechBigCorralHorseSecrets, 50, cUnitTypeCorral, cMilitaryEscrowID);
		//researchCheck(BigFirepitSecretSociety, 50, cUnitTypeFirePit, cMilitaryEscrowID);

		researchCheck(cTechHarvestCeremony, 50, gFarmUnit, cEconomyEscrowID);
		researchCheck(cTechBigFirepitFounder, 50, cUnitTypeFirePit, cEconomyEscrowID);
		if (xsGetTime() > 1800000) researchCheck(cTechBigHouseCoatlicue, 50, gHouseUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractWall, cUnitStateAlive) >= 20) researchCheck(cTechBastion, 50, cUnitTypeAbstractWall, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractWarShip, cUnitStateAlive) >= 5) researchCheck(cTechBigDockRawhideCovers, 50, gDockUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractWarShip, cUnitStateAlive) >= 5) researchCheck(cTechBigDockFlamingArrows, 50, gDockUnit, cEconomyEscrowID);
		if (gFishingUnitNum >= 14) researchCheck(cTechLongLines, 50, gDockUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractWarShip, cUnitStateAlive) >= 5) researchCheck(cTechArmorPlating, 50, gDockUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMonitor, cUnitStateAlive) >= 5) researchCheck(cTechShipHowitzers, 50, gDockUnit, cMilitaryEscrowID);
		
		if (kbUnitCount(cMyID, cUnitTypeAbstractWarShip, cUnitStateAlive) >= 5) researchCheck(cTechCarronade, 50, gDockUnit, cMilitaryEscrowID);
		if (gFishingUnitNum >= 14) researchCheck(cTechLongLines, 50, gDockUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractWarShip, cUnitStateAlive) >= 5) researchCheck(cTechBigDockRawhideCovers, 50, gDockUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractWarShip, cUnitStateAlive) >= 5) researchCheck(cTechBigDockFlamingArrows, 50, gDockUnit, cEconomyEscrowID);
		if (xsGetTime() > 1800000) researchCheck(cTechBigSiouxDogSoldiers, 50, gTownCenter, cEconomyEscrowID);

		if (kbUnitCount(cMyID, cUnitTypeTeepee, cUnitStateAlive) == kbGetBuildLimit(cMyID, cUnitTypeTeepee)) researchCheck(cTechBigWarrior, 50, cUnitTypeTeepee, cEconomyEscrowID);
		researchCheck(cTechypVillagePopCapIncrease, 50, cUnitTypeypVillage, cEconomyEscrowID);
	}

	if (gCurrentAge >= cAge3)
	{
		researchCheck(cTechGangsaw, 50, cUnitTypeMarket, cEconomyEscrowID);
		researchCheck(cTechypMarketGangsaw, 50, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
		researchCheck(cTechLumberCeremony, 50, cUnitTypeMarket, cEconomyEscrowID);
		researchCheck(cTechPlacerMines, 50, cUnitTypeMarket, cEconomyEscrowID);
		researchCheck(cTechypMarketPlacerMines, 50, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
		researchCheck(cTechypMarketWheelbarrow, 50, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeLongbowman, cUnitStateAlive) >= 12) researchCheck(cTechVeteranLongbowmen, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeOutpost, cUnitStateAlive) > kbGetBuildLimit(cMyID, gTowerUnit) / 2) researchCheck(cTechFrontierOutpost, 50, gTowerUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMissionary, cUnitStateAlive) > 4) researchCheck(cTechChurchStateReligion, 50, gChurchUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeFlatbowman, cUnitStateAlive) >= 12) researchCheck(cTechVeteranFlatbowman, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMusketeer, cUnitStateAlive) >= 5) researchCheck(cTechVeteranMusketeers, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCavalaria, cUnitStateAlive) >= 8) researchCheck(cTechVeteranDrabants, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeSchutze, cUnitStateAlive) >= 12) researchCheck(cTechVeteranSchutze, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, gTowerUnit, cUnitStateAlive) > kbGetBuildLimit(cMyID, gTowerUnit) / 2) researchCheck(cTechFrontierBlockhouse, 50, gTowerUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeStrelet, cUnitStateAlive) >= 12) researchCheck(cTechVeteranStrelets, 50, cUnitTypeBlockhouse, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypePikeman, cUnitStateAlive) >= 12) researchCheck(cTechVeteranPikemen, 50, cUnitTypeBlockhouse, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMusketeer, cUnitStateAlive) >= 5) researchCheck(cTechVeteranMusketeers, 50, cUnitTypeBlockhouse, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCossack, cUnitStateAlive) >= 8) researchCheck(cTechVeteranCossacks, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, gTowerUnit, cUnitStateAlive) > kbGetBuildLimit(cMyID, gTowerUnit) / 2) researchCheck(cTechFrontierOutpost, 50, gTowerUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypePriest, cUnitStateAlive) > 4) researchCheck(cTechChurchStateReligion, 50, gChurchUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCrossbowman, cUnitStateAlive) >= 12) researchCheck(cTechVeteranCrossbowmen, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypePikeman, cUnitStateAlive) >= 12) researchCheck(cTechVeteranPikemen, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeRodelero, cUnitStateAlive) >= 12) researchCheck(cTechVeteranRodeleros, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeDopplesoldner, cUnitStateAlive) >= 12) researchCheck(cTechVeteranDopplesoldners, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeUhlan, cUnitStateAlive) >= 8) researchCheck(cTechVeteranUhlans, 50, cUnitTypeStable, cMilitaryEscrowID);
		researchCheck(cTechChurchTopkapi, 100, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechCircularSaw, 50, cUnitTypeMarket, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMill, cUnitStateAlive) >= 3) researchCheck(cTechArtificialFertilizer, 50, cUnitTypeMill, cEconomyEscrowID);

		if (kbUnitCount(cMyID, cUnitTypePlantation, cUnitStateAlive) >= 1) researchCheck(cTechBookkeeping, 50, cUnitTypePlantation, cEconomyEscrowID);

		if (kbUnitCount(cMyID, cUnitTypeOutpost, cUnitStateAlive) > kbGetBuildLimit(cMyID, cUnitTypeOutpost) / 2) researchCheck(cTechFrontierOutpost, 50, cUnitTypeOutpost, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeImam, cUnitStateAlive) > 4) researchCheck(cTechChurchStateReligion, 50, gChurchUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeJanissary, cUnitStateAlive) >= 12) researchCheck(cTechVeteranJanissaries, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHussar, cUnitStateAlive) >= 8) researchCheck(cTechVeteranHussars, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbusGun, cUnitStateAlive) >= 8) researchCheck(cTechVeteranAbusGuns, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeGrenadier, cUnitStateAlive) >= 8) researchCheck(cTechVeteranGrenadiers, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);

		if (kbUnitCount(cMyID, cUnitTypeMarine, cUnitStateAlive) >= 12) researchCheck(cTechVeteranMusketeersUS, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeSaber, cUnitStateAlive) >= 8) researchCheck(cTechVeteranSabers, 50, cUnitTypeStable, cMilitaryEscrowID);

		if (kbUnitCount(cMyID, cUnitTypeAbstractInfantry, cUnitStateAlive) >= 12) researchCheck(cTechRifling, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractInfantry, cUnitStateAlive) >= 12) researchCheck(cTechInfantryBreastplate, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractInfantry, cUnitStateAlive) >= 12) researchCheck(cTechBayonet, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractHeavyCavalry, cUnitStateAlive) >= 12) researchCheck(cTechCavalryCuirass, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractLightCavalry, cUnitStateAlive) >= 12) researchCheck(cTechCaracole, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeRanged, cUnitStateAlive) >= 12) researchCheck(cTechImprovedBows, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractWarShip, cUnitStateAlive) >= 5) researchCheck(cTechHeatedShot, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractArtillery, cUnitStateAlive) >= 12) researchCheck(cTechGunnersQuadrant, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeGrenadier, cUnitStateAlive) >= 12) researchCheck(cTechIncendiaryGrenades, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		researchCheck(cTechImpPeerage, 50, cUnitTypeSPCFortCenter, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpAenna, cUnitStateAlive) >= 12) researchCheck(cTechEliteAennas, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpTomahawk, cUnitStateAlive) >= 12) researchCheck(cTechEliteTomahawks, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpHorseman, cUnitStateAlive) >= 8) researchCheck(cTechEliteHorsemen, 50, cUnitTypeCorral, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpRam, cUnitStateAlive) >= 5) researchCheck(cTechBigSiegeshopSiegeDrill, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpMantlet, cUnitStateAlive) >= 5) researchCheck(cTechBigSiegeshopSiegeDrill, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpLightCannon, cUnitStateAlive) >= 5) researchCheck(cTechBigSiegeshopSiegeDrill, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		researchCheck(cTechypMonasteryIndianSpeed, 50, cUnitTypeypMonastery, cEconomyEscrowID);
		researchCheck(cTechypMonasteryCompunction, 50, cUnitTypeypMonastery, cEconomyEscrowID);
		researchCheck(cTechypMonasteryCriticalUpgrade, 50, cUnitTypeypMonastery, cEconomyEscrowID);
		researchCheck(cTechypMonasteryAttackSpeed, 50, cUnitTypeypMonastery, cEconomyEscrowID);
		researchCheck(cTechypMarketCircularSaw, 50, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractRajput, cUnitStateAlive) >= 12) researchCheck(cTechYPDisciplinedRajput, 50, cUnitTypeYPBarracksIndian, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractUrumi, cUnitStateAlive) >= 12) researchCheck(cTechYPDisciplinedUrumi, 50, cUnitTypeYPBarracksIndian, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractSepoy, cUnitStateAlive) >= 12) researchCheck(cTechYPDisciplinedSepoy, 50, cUnitTypeYPBarracksIndian, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractGurkha, cUnitStateAlive) >= 12) researchCheck(cTechYPDisciplinedGurkha, 50, cUnitTypeYPBarracksIndian, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractSowar, cUnitStateAlive) >= 8) researchCheck(cTechYPDisciplinedCamel, 50, cUnitTypeypCaravanserai, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractZamburak, cUnitStateAlive) >= 8) researchCheck(cTechYPDisciplinedCamelGun, 50, cUnitTypeypCaravanserai, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractMercFlailiphant, cUnitStateAlive) >= 5) researchCheck(cTechYPDisciplinedFlailElephant, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypFlameThrower, cUnitStateAlive) >= 5) researchCheck(cTechYPDisciplinedFlameThrower, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypChuKoNu, cUnitStateAlive) >= 12) researchCheck(cTechYPDisciplinedChuKoNu, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypQiangPikeman, cUnitStateAlive) >= 12) researchCheck(cTechYPDisciplinedQiangPikeman, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypSteppeRider, cUnitStateAlive) >= 12) researchCheck(cTechYPDisciplinedSteppeRider, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypKeshik, cUnitStateAlive) >= 12) researchCheck(cTechYPDisciplinedKeshik, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		researchCheck(cTechypWaterConservancy, 50, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
		researchCheck(cTechypSharecropping, 50, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
		researchCheck(cTechypIrrigationSystems, 50, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
		researchCheck(cTechypMonasteryKillingBlowUpgrade, 50, cUnitTypeypMonastery, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeYPOutpostAsian, cUnitStateAlive) > kbGetBuildLimit(cMyID, cUnitTypeYPOutpostAsian) / 2) researchCheck(cTechTownGuard, 50, cUnitTypeYPOutpostAsian, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractWarShip, cUnitStateAlive) >= 5) researchCheck(cTechPercussionLocks, 50, gDockUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypYumi, cUnitStateAlive) >= 12) researchCheck(cTechYPDisciplinedYumi, 50, cUnitTypeypBarracksJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypAshigaru, cUnitStateAlive) >= 12) researchCheck(cTechYPDisciplinedAshigaru, 50, cUnitTypeypBarracksJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypKensei, cUnitStateAlive) >= 8) researchCheck(cTechYPDisciplinedSamurai, 50, cUnitTypeypBarracksJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypNaginataRider, cUnitStateAlive) >= 8) researchCheck(cTechYPDisciplinedNaginataRider, 50, cUnitTypeypStableJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypCastle, cUnitStateAlive) > kbGetBuildLimit(cMyID, cUnitTypeypCastle) / 2) researchCheck(cTechypFrontierCastle, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		researchCheck(cTechTreasuryCrateAmount, 50, cUnitTypeSPCIncaTemple, cEconomyEscrowID);
		if (xsGetTime() > 1800000) researchCheck(cTechBigFarmCinteotl, 50, gFarmUnit, cEconomyEscrowID);
		if (xsGetTime() > 1800000) researchCheck(cTechBigPlantationTezcatlipoca, 50, cUnitTypePlantation, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpCoyoteMan, cUnitStateAlive) >= 12) researchCheck(cTechEliteCoyotemen, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpMacehualtin, cUnitStateAlive) >= 12) researchCheck(cTechEliteMacehualtins, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpPumaMan, cUnitStateAlive) >= 12) researchCheck(cTechElitePumaMen, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeNoblesHut, cUnitStateAlive) > kbGetBuildLimit(cMyID, cUnitTypeNoblesHut) / 2) researchCheck(cTechStrongNoblesHut, 50, cUnitTypeNoblesHut, cMilitaryEscrowID);
		if (xsGetTime() > 1800000) researchCheck(cTechBigNoblesHutWarSong, 50, cUnitTypeNoblesHut, cMilitaryEscrowID);
		researchCheck(cTechForestSpiritCeremony, 50, cUnitTypeMarket, cEconomyEscrowID);
		researchCheck(cTechBigMarketNewYear, 50, cUnitTypeMarket, cEconomyEscrowID);
		researchCheck(cTechGreenCornCeremony, 50, gFarmUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractCavalry, cUnitStateAlive) >= 10) researchCheck(cTechBigCorralBonepipeArmor, 50, cUnitTypeCorral, cEconomyEscrowID);
		researchCheck(cTechBigWarHutWarDrums, 50, cUnitTypeWarHut, cEconomyEscrowID);
		researchCheck(cTechEarthGiftCeremony, 50, cUnitTypePlantation, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeWarHut, cUnitStateAlive) > kbGetBuildLimit(cMyID, cUnitTypeWarHut) / 2) researchCheck(cTechStrongWarHut, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpWarBow, cUnitStateAlive) >= 12) researchCheck(cTechEliteWarBows, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpWarClub, cUnitStateAlive) >= 12) researchCheck(cTechEliteWarClubs, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpAxeRider, cUnitStateAlive) >= 10) researchCheck(cTechEliteAxeRiders, 50, cUnitTypeCorral, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpBowRider, cUnitStateAlive) >= 10) researchCheck(cTechEliteBowRider, 50, cUnitTypeCorral, cEconomyEscrowID);
		researchCheck(cTechypVillagePopCapIncrease2, 50, cUnitTypeypVillage, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeGrenadier, cUnitStateAlive) >= 8) researchCheck(cTechVeteranGrenadiersUS, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		researchCheck(cTechChurchTownWatch, 50, gChurchUnit, cEconomyEscrowID);
	}

	if (gCurrentAge >= cAge4)
	{	
		if (kbUnitCount(cMyID, cUnitTypeSaber, cUnitStateAlive) >= 8) researchCheck(cTechGuardSabers, 50, cUnitTypeStable, cMilitaryEscrowID);
		researchCheck(cTechChurchMercantilism, 50, cUnitTypeMarket, cEconomyEscrowID); //age 2 tech
		if (kbUnitCount(cMyID, cUnitTypeOutpost, cUnitStateAlive) > kbGetBuildLimit(cMyID, cUnitTypeOutpost) / 2) researchCheck(cTechFortifiedOutpost, 50, cUnitTypeOutpost, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHussar, cUnitStateAlive) >= 8) researchCheck(cTechRGLifeGuardHussars, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeLongbowman, cUnitStateAlive) >= 12) researchCheck(cTechGuardLongbowmen, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMusketeer, cUnitStateAlive) >= 5) researchCheck(cTechRGRedcoats, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		researchCheck(cTechChurchBlackWatch, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchThinRedLine, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchRogersRangers, 50, gChurchUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeLancer, cUnitStateAlive) >= 8) researchCheck(cTechRGGarrochista, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypePikeman, cUnitStateAlive) >= 12) researchCheck(cTechRGTercio, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeRodelero, cUnitStateAlive) >= 12) researchCheck(cTechRGEspadachins, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		researchCheck(cTechChurchCorsolet, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchQuatrefage, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchWildGeeseSpanish, 50, gChurchUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHussar, cUnitStateAlive) >= 8) researchCheck(cTechImperialLifeGuard, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeDragoon, cUnitStateAlive) >= 8) researchCheck(cTechGuardDragoons, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCuirassier, cUnitStateAlive) >= 8) researchCheck(cTechRGGendarmes, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeFlatbowman, cUnitStateAlive) >= 12) researchCheck(cTechGuardFlatbowman, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMusketeer, cUnitStateAlive) >= 5) researchCheck(cTechGuardMusketeers, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeSkirmisher, cUnitStateAlive) >= 12) researchCheck(cTechRGVoltigeur, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeFalconet, cUnitStateAlive) >= 4) researchCheck(cTechImperialFieldGunNew, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeFalconet, cUnitStateAlive) >= 4) researchCheck(cTechFieldGunUS, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCulverin, cUnitStateAlive) >= 4) researchCheck(cTechGrapeShotUS, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMortar, cUnitStateAlive) >= 4) researchCheck(cTechHowitzerUS, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpHorseArtillery, cUnitStateAlive) >= 4) researchCheck(cTechHeavyHorseArtilleryUS, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		researchCheck(cTechChurchCodeNapoleon, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchGardeImperial1, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchGardeImperial2, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchGardeImperial3, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchTies, 50, gChurchUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCavalaria, cUnitStateAlive) >= 8) researchCheck(cTechGuardDrabants, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeDragoon, cUnitStateAlive) >= 8) researchCheck(cTechRGJinetes, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHalberdier, cUnitStateAlive) >= 12) researchCheck(cTechGuardHalberdiers, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMusketeer, cUnitStateAlive) >= 5) researchCheck(cTechRGGuerreiros, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCacadore, cUnitStateAlive) >= 12) researchCheck(cTechGuardCacadores, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeOrganGun, cUnitStateAlive) >= 4) researchCheck(cTechRabauld, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCulverin, cUnitStateAlive) >= 4) researchCheck(cTechGrapeShotNew, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		researchCheck(cTechChurchEconmediaManor, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchBestieros, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchTowerAndSword, 50, gChurchUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHussar, cUnitStateAlive) >= 8) researchCheck(cTechRGRoyalHussar, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeRuyter, cUnitStateAlive) >= 8) researchCheck(cTechRGCarabineer, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHalberdier, cUnitStateAlive) >= 12) researchCheck(cTechRGNassausLinearTactics, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeSchutze, cUnitStateAlive) >= 12) researchCheck(cTechGuardSchutzens, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeSkirmisher, cUnitStateAlive) >= 12) researchCheck(cTechGuardSkirmishers, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeGrenadier, cUnitStateAlive) >= 8) researchCheck(cTechGuardGrenadiers, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeGrenadier, cUnitStateAlive) >= 8) researchCheck(cTechGuardGrenadiersUS, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (gBankNum > 6) researchCheck(cTechChurchCoffeeTrade, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchWaardgelders, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchStadholders, 50, gChurchUnit, cEconomyEscrowID);
		if (gBankNum == kbGetBuildLimit(cMyID, cUnitTypeBank)) researchCheck(cTechImpExcessiveTaxationD, 50, cUnitTypeBank, cEconomyEscrowID);
		researchCheck(cTechChurchMercantilism, 50, cUnitTypeMarket, cEconomyEscrowID); //age 2 tech				
		if (kbUnitCount(cMyID, gTowerUnit, cUnitStateAlive) > kbGetBuildLimit(cMyID, gTowerUnit) / 2) researchCheck(cTechFortifiedBlockhouse, 50, gTowerUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCossack, cUnitStateAlive) >= 8) researchCheck(cTechGuardCossacks, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeOprichnik, cUnitStateAlive) >= 8) researchCheck(cTechGuardOprichniks, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCavalryArcher, cUnitStateAlive) >= 8) researchCheck(cTechRGTartarLoyalists, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeStrelet, cUnitStateAlive) >= 12) researchCheck(cTechGuardStrelets, 50, cUnitTypeBlockhouse, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypePikeman, cUnitStateAlive) >= 12) researchCheck(cTechGuardPikemen, 50, cUnitTypeBlockhouse, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMusketeer, cUnitStateAlive) >= 5) researchCheck(cTechGuardMusketeers, 50, cUnitTypeBlockhouse, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHalberdier, cUnitStateAlive) >= 12) researchCheck(cTechGuardHalberdiers, 50, cUnitTypeBlockhouse, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeGrenadier, cUnitStateAlive) >= 8) researchCheck(cTechVeteranGrenadiers, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeGrenadier, cUnitStateAlive) >= 8) researchCheck(cTechRGPavlovGrenadiers, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpHorseArtillery, cUnitStateAlive) >= 4) researchCheck(cTechHeavyHorseArtilleryNew, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		researchCheck(cTechChurchWesternization, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchKalmucks, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchBashkirPonies, 50, gChurchUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeUhlan, cUnitStateAlive) >= 8) researchCheck(cTechRGCzapkaUhlans, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeWarWagon, cUnitStateAlive) >= 8) researchCheck(cTechGuardWarWagons, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCrossbowman, cUnitStateAlive) >= 12) researchCheck(cTechGuardCrossbowmen, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypePikeman, cUnitStateAlive) >= 12) researchCheck(cTechGuardPikemen, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeDopplesoldner, cUnitStateAlive) >= 12) researchCheck(cTechGuardDopplesoldners, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeSkirmisher, cUnitStateAlive) >= 12) researchCheck(cTechRGPrussianNeedleGun, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMortar, cUnitStateAlive) >= 4) researchCheck(cTechHowitzerNew, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		researchCheck(cTechChurchTillysDiscipline, 50, gChurchUnit, cEconomyEscrowID);
		//researchCheck(cTechChurchWallensteinsContracts, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchZweihander, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchTanzimat, 100, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchMercantilism, 50, cUnitTypeMarket, cEconomyEscrowID); //age 2 tech			
		if (kbUnitCount(cMyID, cUnitTypeOutpost, cUnitStateAlive) > kbGetBuildLimit(cMyID, gTowerUnit) / 2) researchCheck(cTechFortifiedOutpost, 50, gTowerUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeFortFrontier, cUnitStateAlive) > 0) researchCheck(cTechRevetment, 50, cUnitTypeFortFrontier, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeFortFrontier, cUnitStateAlive) > 0) researchCheck(cTechStarFort, 50, cUnitTypeFortFrontier, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypePlantation, cUnitStateAlive) >= 2) researchCheck(cTechHomesteading, 50, cUnitTypePlantation, cEconomyEscrowID);
		researchCheck(cTechChurchStandingArmy, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchMassCavalry, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechSaloonWildWest, 50, cUnitTypeSPCFortCenter, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypePlantation, cUnitStateAlive) >= 2) researchCheck(cTechOreRefining, 50, cUnitTypePlantation, cEconomyEscrowID);
		researchCheck(cTechImpKnighthood, 50, cUnitTypeSPCFortCenter, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHussar, cUnitStateAlive) >= 8) researchCheck(cTechRGGardener, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeSpahi, cUnitStateAlive) >= 8) researchCheck(cTechGuardSpahi, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHussar, cUnitStateAlive) >= 8) researchCheck(cTechGuardHussars, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCavalryArcher, cUnitStateAlive) >= 8) researchCheck(cTechGuardCavalryArchers, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeJanissary, cUnitStateAlive) >= 12) researchCheck(cTechGuardJanissaries, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAzap, cUnitStateAlive) >= 12) researchCheck(cTechGuardAzaps, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeRiflemanUS, cUnitStateAlive) >= 12) researchCheck(cTechGuardRiflemenUS, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMarine, cUnitStateAlive) >= 12) researchCheck(cTechGuardMusketeersUS, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMountedRifleman, cUnitStateAlive) >= 8) researchCheck(cTechGuardMountedRiflemen, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbusGun, cUnitStateAlive) >= 8) researchCheck(cTechGuardAbusGuns, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeGrenadier, cUnitStateAlive) >= 8) researchCheck(cTechRGBaratcuCorps, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeFalconet, cUnitStateAlive) >= 4) researchCheck(cTechFieldGun, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCulverin, cUnitStateAlive) >= 4) researchCheck(cTechGrapeShot, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMortar, cUnitStateAlive) >= 4) researchCheck(cTechHowitzer, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpHorseArtillery, cUnitStateAlive) >= 4) researchCheck(cTechHeavyHorseArtillery, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (gFactoryNum > 0) researchCheck(cTechFactoryCannery, 50, cUnitTypeFactory, cMilitaryEscrowID);
		if (gFactoryNum > 0) researchCheck(cTechFactoryWaterPower, 50, cUnitTypeFactory, cMilitaryEscrowID);
		if (gFactoryNum > 0) researchCheck(cTechFactorySteamPower, 50, cUnitTypeFactory, cMilitaryEscrowID);
		if (gFactoryNum > 0) researchCheck(cTechFactoryMassProduction, 50, cUnitTypeFactory, cMilitaryEscrowID);
		if (gCurrentPop > 150) researchCheck(cTechChurchCannonPop, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchHussars, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchTufanciCorps, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchTopcuCorps, 50, gChurchUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpAenna, cUnitStateAlive) >= 12) researchCheck(cTechChampionAennas, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpTomahawk, cUnitStateAlive) >= 12) researchCheck(cTechChampionTomahawk, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpMusketWarrior, cUnitStateAlive) >= 12) researchCheck(cTechChampionMusketWarriors, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpHorseman, cUnitStateAlive) >= 8) researchCheck(cTechChampionHorsemen, 50, cUnitTypeCorral, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpMusketRider, cUnitStateAlive) >= 8) researchCheck(cTechChampionMusketRiders, 50, cUnitTypeCorral, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpRam, cUnitStateAlive) >= 5) researchCheck(cTechChampionRams, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpMantlet, cUnitStateAlive) >= 5) researchCheck(cTechChampionMantlets, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpLightCannon, cUnitStateAlive) >= 5) researchCheck(cTechFieldCannon, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		researchCheck(cTechBigFirepitBattleAnger, 50, cUnitTypeFirePit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpWarBow, cUnitStateAlive) >= 12) researchCheck(cTechChampionWarBows, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpWarClub, cUnitStateAlive) >= 12) researchCheck(cTechChampionWarClubs, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		
		if (kbUnitCount(cMyID, cTechChampionCoupRiders, cUnitStateAlive) >= 12) researchCheck(cTechChampionWarRifles, 50, cUnitTypeCorral, cMilitaryEscrowID);
		
		if (kbUnitCount(cMyID, cUnitTypexpWarRifle, cUnitStateAlive) >= 12) researchCheck(cTechChampionWarRifles, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpAxeRider, cUnitStateAlive) >= 10) researchCheck(cTechChampionAxeRiders, 50, cUnitTypeCorral, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpBowRider, cUnitStateAlive) >= 10) researchCheck(cTechChampionBowRider, 50, cUnitTypeCorral, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpRifleRider, cUnitStateAlive) >= 10) researchCheck(cTechChampionRifleRiders, 50, cUnitTypeCorral, cEconomyEscrowID);
		researchCheck(cTechSaloonWildWest, 50, cUnitTypeNativeEmbassy, cMilitaryEscrowID);
		researchCheck(cTechConSupport, 50, cUnitTypeNativeEmbassy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeWarHut, cUnitStateAlive) > kbGetBuildLimit(cMyID, cUnitTypeWarHut) / 2) researchCheck(cTechMightyWarHut, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpCoyoteMan, cUnitStateAlive) >= 12) researchCheck(cTechChampionCoyotemen, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpMacehualtin, cUnitStateAlive) >= 12) researchCheck(cTechChampionMacehualtins, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpPumaMan, cUnitStateAlive) >= 12) researchCheck(cTechChampionPumaMen, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpArrowKnight, cUnitStateAlive) >= 12) researchCheck(cTechChampionArrowKnight, 50, cUnitTypeNoblesHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpEagleKnight, cUnitStateAlive) >= 12) researchCheck(cTechChampionEagleKnight, 50, cUnitTypeNoblesHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpJaguarKnight, cUnitStateAlive) >= 12) researchCheck(cTechChampionJaguarKnight, 50, cUnitTypeNoblesHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeNoblesHut, cUnitStateAlive) > kbGetBuildLimit(cMyID, cUnitTypeNoblesHut) / 2) researchCheck(cTechMightyNoblesHut, 50, cUnitTypeNoblesHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractWarShip, cUnitStateAlive) >= 5) researchCheck(cTechBigDockCipactli, 50, gDockUnit, cMilitaryEscrowID);
		researchCheck(cTechypShrineFortressUpgrade, 50, cUnitTypeypShrineJapanese, cEconomyEscrowID);
		researchCheck(cTechypMonasteryRangedSplash, 50, cUnitTypeypMonastery, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypYumi, cUnitStateAlive) >= 12) researchCheck(cTechYPHonoredYumi, 50, cUnitTypeypBarracksJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypAshigaru, cUnitStateAlive) >= 12) researchCheck(cTechYPHonoredAshigaru, 50, cUnitTypeypBarracksJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypKensei, cUnitStateAlive) >= 8) researchCheck(cTechYPHonoredSamurai, 50, cUnitTypeypBarracksJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeSohei, cUnitStateAlive) >= 8) researchCheck(cTechYPHonoredSohei, 50, cUnitTypeypBarracksJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypNaginataRider, cUnitStateAlive) >= 8) researchCheck(cTechYPHonoredNaginataRider, 50, cUnitTypeypStableJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypYabusame, cUnitStateAlive) >= 8) researchCheck(cTechYPHonoredYabusame, 50, cUnitTypeypStableJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypFlamingArrow, cUnitStateAlive) >= 5) researchCheck(cTechYPHonoredFlamingArrow, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypMorutaru, cUnitStateAlive) >= 5) researchCheck(cTechYPHonoredMorutaru, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypHandMortar, cUnitStateAlive) >= 5) researchCheck(cTechYPHonoredHandMortar, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypFlameThrower, cUnitStateAlive) >= 5) researchCheck(cTechYPHonoredFlameThrower, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypIronFlail, cUnitStateAlive) >= 12) researchCheck(cTechYPHonoredIronFlail, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypMeteorHammer, cUnitStateAlive) >= 12) researchCheck(cTechYPHonoredMeteorHammer, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypChuKoNu, cUnitStateAlive) >= 12) researchCheck(cTechYPHonoredChuKoNu, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypQiangPikeman, cUnitStateAlive) >= 12) researchCheck(cTechYPHonoredQiangPikeman, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypSteppeRider, cUnitStateAlive) >= 12) researchCheck(cTechYPHonoredSteppeRider, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypKeshik, cUnitStateAlive) >= 12) researchCheck(cTechYPHonoredKeshik, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractGunpowderTrooper, cUnitStateAlive) >= 12) researchCheck(cTechFlintlock, 50, cUnitTypeypWJGoldenPavillion3, cMilitaryEscrowID);
		

		if (kbUnitCount(cMyID, cUnitTypeAbstractGunpowderTrooper, cUnitStateAlive) >= 12) researchCheck(cTechPaperCartridge, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractGunpowderTrooper, cUnitStateAlive) >= 12) researchCheck(cTechFlintlock, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractGunpowderTrooper, cUnitStateAlive) >= 12) researchCheck(cTechMilitaryDrummers, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractArtillery, cUnitStateAlive) >= 6) researchCheck(cTechProfessionalGunners, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractArtillery, cUnitStateAlive) >= 6) researchCheck(cTechTrunion, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractHeavyCavalry, cUnitStateAlive) >= 8) researchCheck(cTechPillage, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeGrenadier, cUnitStateAlive) >= 12) researchCheck(cTechIncendiaryGrenades, 50, cUnitTypeArsenal, cMilitaryEscrowID);
		
		if (kbUnitCount(cMyID, cUnitTypeAbstractHeavyCavalry, cUnitStateAlive) >= 8) researchCheck(cTechPillage, 50, cUnitTypeypWJGoldenPavillion3, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractArtillery, cUnitStateAlive) >= 5) researchCheck(cTechProfessionalGunners, 50, cUnitTypeypWJGoldenPavillion3, cMilitaryEscrowID);
		researchCheck(cTechypLandRedistribution, 50, cUnitTypeypRicePaddy, cEconomyEscrowID);
		researchCheck(cTechypCooperative, 50, cUnitTypeypRicePaddy, cEconomyEscrowID);
		researchCheck(cTechypMonasteryCompunction, 50, cUnitTypeypMonastery, cEconomyEscrowID);
		researchCheck(cTechypMonasteryStompUpgrade, 50, cUnitTypeypMonastery, cEconomyEscrowID);
		researchCheck(cTechypFrontierAgra, 50, cUnitTypeypWIAgraFort2, cEconomyEscrowID);
		researchCheck(cTechypFrontierAgra, 50, cUnitTypeypWIAgraFort3, cEconomyEscrowID);
		researchCheck(cTechypFrontierAgra, 50, cUnitTypeypWIAgraFort4, cEconomyEscrowID);
		researchCheck(cTechypFrontierAgra, 50, cUnitTypeypWIAgraFort5, cEconomyEscrowID);
		researchCheck(cTechypFortifiedAgra, 50, cUnitTypeypWIAgraFort2, cEconomyEscrowID);
		researchCheck(cTechypFortifiedAgra, 50, cUnitTypeypWIAgraFort3, cEconomyEscrowID);
		researchCheck(cTechypFortifiedAgra, 50, cUnitTypeypWIAgraFort4, cEconomyEscrowID);
		researchCheck(cTechypFortifiedAgra, 50, cUnitTypeypWIAgraFort5, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractRajput, cUnitStateAlive) >= 12) researchCheck(cTechYPHonoredRajput, 50, cUnitTypeYPBarracksIndian, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractUrumi, cUnitStateAlive) >= 12) researchCheck(cTechYPHonoredUrumi, 50, cUnitTypeYPBarracksIndian, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractSepoy, cUnitStateAlive) >= 12) researchCheck(cTechYPHonoredSepoy, 50, cUnitTypeYPBarracksIndian, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractGurkha, cUnitStateAlive) >= 12) researchCheck(cTechYPHonoredGurkha, 50, cUnitTypeYPBarracksIndian, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractSowar, cUnitStateAlive) >= 8) researchCheck(cTechYPHonoredCamel, 50, cUnitTypeypCaravanserai, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractZamburak, cUnitStateAlive) >= 8) researchCheck(cTechYPHonoredCamelGun, 50, cUnitTypeypCaravanserai, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractMahout, cUnitStateAlive) >= 8) researchCheck(cTechYPHonoredMahout, 50, cUnitTypeypCaravanserai, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractHowdah, cUnitStateAlive) >= 8) researchCheck(cTechYPHonoredHowdah, 50, cUnitTypeypCaravanserai, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractMercFlailiphant, cUnitStateAlive) >= 5) researchCheck(cTechYPHonoredFlailElephant, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractSiegeElephant, cUnitStateAlive) >= 5) researchCheck(cTechYPHonoredSiegeElephant, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypCastle, cUnitStateAlive) > kbGetBuildLimit(cMyID, cUnitTypeypCastle) / 2) researchCheck(cTechypFortifiedCastle, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		researchCheck(cTechypVillagePopCapIncrease3, 50, cUnitTypeypVillage, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypArquebusier, cUnitStateAlive) >= 10) researchCheck(cTechYPHonoredArquebusier, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		if (kbUnitCount(cUnitTypeypChangdao) >= 10) researchCheck(cTechYPHonoredChangdao, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		researchCheck(cTechChurchPetrineReforms, 50, gChurchUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypDojo, cUnitStateAlive) > 0) researchCheck(cTechypDojoUpgrade1, 50, cUnitTypeypDojo, cMilitaryEscrowID);
	}

	if (gCurrentAge == cAge5)
	{
		if (kbUnitCount(cMyID, cUnitTypeSaber, cUnitStateAlive) >= 8) researchCheck(cTechImperialSabers, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMountedRifleman, cUnitStateAlive) >= 8) researchCheck(cTechImperialMountedRiflemen, 50, cUnitTypeStable, cMilitaryEscrowID);
			
		if (kbUnitCount(cMyID, cUnitTypeLongbowman, cUnitStateAlive) >= 12) researchCheck(cTechImperialLongbowmen, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMusketeer, cUnitStateAlive) >= 5) researchCheck(cTechImperialRedcoat, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHussar, cUnitStateAlive) >= 8) researchCheck(cTechImperialLifeGuard, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMonitor, cUnitStateAlive) > 0) researchCheck(cTechImperialMonitorsNew, 50, gDockUnit, cMilitaryEscrowID);
	
		if (kbUnitCount(cMyID, cUnitTypeFrigate, cUnitStateAlive) > 0) researchCheck(cTechImperialManOWarNew, 50, gDockUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypePikeman, cUnitStateAlive) >= 12) researchCheck(cTechImperialTercio, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeRodelero, cUnitStateAlive) >= 12) researchCheck(cTechImperialEspada, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeLancer, cUnitStateAlive) >= 8) researchCheck(cTechImperialGarrochistas, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeFlatbowman, cUnitStateAlive) >= 12) researchCheck(cTechImperialFlatbowman, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMusketeer, cUnitStateAlive) >= 5) researchCheck(cTechImperialMusketeers, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeSkirmisher, cUnitStateAlive) >= 12) researchCheck(cTechImperialVoltigeur, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHussar, cUnitStateAlive) >= 8) researchCheck(cTechImperialHussars, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeDragoon, cUnitStateAlive) >= 8) researchCheck(cTechImperialDragoons, 50, cUnitTypeStable, cMilitaryEscrowID);
			
		if (kbUnitCount(cMyID, cUnitTypeCuirassier, cUnitStateAlive) >= 8) researchCheck(cTechImperialGendarme, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCulverin, cUnitStateAlive) >= 4) researchCheck(cTechImperialCulverinNew, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHalberdier, cUnitStateAlive) >= 12) researchCheck(cTechImperialHalberdiers, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMusketeer, cUnitStateAlive) >= 5) researchCheck(cTechImperialGuerreiros, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCacadore, cUnitStateAlive) >= 12) researchCheck(cTechImperialCacadores, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCavalaria, cUnitStateAlive) >= 8) researchCheck(cTechImperialDrabants, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeDragoon, cUnitStateAlive) >= 8) researchCheck(cTechImperialJinetes, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeOrganGun, cUnitStateAlive) >= 4) researchCheck(cTechImperialRabaulds, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (gFactoryNum > 0) researchCheck(cTechImperialRocket, 50, cUnitTypeFactory, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypePlantation, cUnitStateAlive) >= 2) researchCheck(cTechImpExcessiveTaxationD3, 50, cUnitTypePlantation, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHalberdier, cUnitStateAlive) >= 12) researchCheck(cTechImperialNassauers, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeSchutze, cUnitStateAlive) >= 12) researchCheck(cTechImperialSchutzens, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeSkirmisher, cUnitStateAlive) >= 12) researchCheck(cTechImperialSkirmishers, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMarine, cUnitStateAlive) >= 12) researchCheck(cTechImperialMusketeersUS, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeRiflemanUS, cUnitStateAlive) >= 12) researchCheck(cTechImperialRiflemenUS, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHussar, cUnitStateAlive) >= 8) researchCheck(cTechImperialRoyalHussar, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeDragoon, cUnitStateAlive) >= 8) researchCheck(cTechImperialCarabineer, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeGrenadier, cUnitStateAlive) >= 8) researchCheck(cTechImperialGrenadiers, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeGrenadier, cUnitStateAlive) >= 8) researchCheck(cTechImperialGrenadiersUS, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeFalconet, cUnitStateAlive) >= 4) researchCheck(cTechImperialFieldGunUS, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCulverin, cUnitStateAlive) >= 4) researchCheck(cTechImperialCulverinUS, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMortar, cUnitStateAlive) >= 4) researchCheck(cTechImperialHowitzerUS, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpHorseArtillery, cUnitStateAlive) >= 4) researchCheck(cTechImperialHorseArtilleryUS, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		
		researchCheck(cTechImpExcessiveTaxationD2, 50, cUnitTypeBank, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeStrelet, cUnitStateAlive) >= 12) researchCheck(cTechImperialStrelets, 50, cUnitTypeBlockhouse, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypePikeman, cUnitStateAlive) >= 12) researchCheck(cTechImperialPikemen, 50, cUnitTypeBlockhouse, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHalberdier, cUnitStateAlive) >= 12) researchCheck(cTechImperialHalberdiers, 50, cUnitTypeBlockhouse, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMusketeer, cUnitStateAlive) >= 5) researchCheck(cTechImperialMusketeers, 50, cUnitTypeBlockhouse, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCossack, cUnitStateAlive) >= 8) researchCheck(cTechImperialCossack, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeOprichnik, cUnitStateAlive) >= 8) researchCheck(cTechImperialOprichniks, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCavalryArcher, cUnitStateAlive) >= 8) researchCheck(cTechImperialTartarLoyalist, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeGrenadier, cUnitStateAlive) >= 8) researchCheck(cTechImperialPavlovs, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpHorseArtillery, cUnitStateAlive) >= 4) researchCheck(cTechImperialHorseArtilleryNew, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (gFactoryNum > 0) researchCheck(cTechImperialGreatCannon, 50, cUnitTypeFactory, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCrossbowman, cUnitStateAlive) >= 12) researchCheck(cTechImperialCrossbowmen, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypePikeman, cUnitStateAlive) >= 12) researchCheck(cTechImperialPikemen, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeDopplesoldner, cUnitStateAlive) >= 12) researchCheck(cTechImperialDopplesoldner, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeSkirmisher, cUnitStateAlive) >= 12) researchCheck(cTechImperialNeedleGun, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeUhlan, cUnitStateAlive) >= 8) researchCheck(cTechImperialCzapkaUhlans, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeWarWagon, cUnitStateAlive) >= 8) researchCheck(cTechImperialWarWagons, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMortar, cUnitStateAlive) >= 4) researchCheck(cTechImperialHowitzerNew, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (gFactoryNum > 0) researchCheck(cTechImperialCannon, 50, cUnitTypeFactory, cMilitaryEscrowID);
	
		if (gFactoryNum > 0) researchCheck(cTechImperialCannonUS, 50, cUnitTypeFactory, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeFrigate, cUnitStateAlive) > 0) researchCheck(cTechImperialManOWar, 50, gDockUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMonitor, cUnitStateAlive) > 0) researchCheck(cTechImperialMonitors, 50, gDockUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMill, cUnitStateAlive) >= 3) researchCheck(cTechImpLargeScaleAgriculture, 50, cUnitTypeMill, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypePlantation, cUnitStateAlive) >= 2) researchCheck(cTechImpExcessiveTaxation, 50, cUnitTypePlantation, cEconomyEscrowID);
		researchCheck(cTechImpDeforestation, 50, cUnitTypeMarket, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeHussar, cUnitStateAlive) >= 8) researchCheck(cTechImperialGardener, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeSpahi, cUnitStateAlive) >= 8) researchCheck(cTechImperialSpahi, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCavalryArcher, cUnitStateAlive) >= 8) researchCheck(cTechImperialCavalryArchers, 50, cUnitTypeStable, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeJanissary, cUnitStateAlive) >= 12) researchCheck(cTechImperialJanissaries, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAzap, cUnitStateAlive) >= 12) researchCheck(cTechImperialAzaps, 50, cUnitTypeBarracks, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbusGun, cUnitStateAlive) >= 8) researchCheck(cTechImperialAbusGun, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeGrenadier, cUnitStateAlive) >= 8) researchCheck(cTechImperialBaratcu, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeFalconet, cUnitStateAlive) >= 4) researchCheck(cTechImperialFieldGun, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeCulverin, cUnitStateAlive) >= 4) researchCheck(cTechImperialCulverin, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMortar, cUnitStateAlive) >= 4) researchCheck(cTechImperialHowitzer, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpHorseArtillery, cUnitStateAlive) >= 4) researchCheck(cTechImperialHorseArtillery, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractNativeWarrior, cUnitStateAlive) > 10) researchCheck(cTechImpLegendaryNatives, 50, gTownCenter, cMilitaryEscrowID);
		if (gFactoryNum > 0) researchCheck(cTechImperialBombard, 50, cUnitTypeFactory, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpAenna, cUnitStateAlive) >= 12) researchCheck(cTechImpLegendaryAennas, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpTomahawk, cUnitStateAlive) >= 12) researchCheck(cTechImpLegendaryTomahawks, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpMusketWarrior, cUnitStateAlive) >= 12) researchCheck(cTechImpLegendaryMusketWarriors, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpHorseman, cUnitStateAlive) >= 8) researchCheck(cTechImpLegendaryHorsemen, 50, cUnitTypeCorral, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpMusketRider, cUnitStateAlive) >= 8) researchCheck(cTechImpLegendaryMusketRiders, 50, cUnitTypeCorral, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpRam, cUnitStateAlive) >= 5) researchCheck(cTechImpLegendaryRams, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpMantlet, cUnitStateAlive) >= 5) researchCheck(cTechImpLegendaryMantlets, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpLightCannon, cUnitStateAlive) >= 5) researchCheck(cTechImpLegendaryLightCannon, 50, cUnitTypeArtilleryDepot, cMilitaryEscrowID);
		researchCheck(cTechypConsulateFrenchBrigadeN, 50, cUnitTypeNativeEmbassy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpWarBow, cUnitStateAlive) >= 12) researchCheck(cTechImpLegendaryWarBows, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpWarClub, cUnitStateAlive) >= 12) researchCheck(cTechImpLegendaryWarClubs, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpWarRifle, cUnitStateAlive) >= 12) researchCheck(cTechImpLegendaryWarRifles, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpAxeRider, cUnitStateAlive) >= 10) researchCheck(cTechImpLegendaryAxeRiders, 50, cUnitTypeCorral, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpBowRider, cUnitStateAlive) >= 10) researchCheck(cTechImpLegendaryBowRider, 50, cUnitTypeCorral, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpRifleRider, cUnitStateAlive) >= 10) researchCheck(cTechImpLegendaryRifleRiders, 50, cUnitTypeCorral, cEconomyEscrowID);
		researchCheck(cTechypConsulateBritishBrigadeN, 50, cUnitTypeNativeEmbassy, cMilitaryEscrowID);
		researchCheck(cTechImpDeforestationNative, 50, cUnitTypeMarket, cEconomyEscrowID);
		researchCheck(cTechImpLargeScaleGathering, 50, gFarmUnit, cEconomyEscrowID);
		researchCheck(cTechImpExcessiveTributeNative, 50, gFarmUnit, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpCoyoteMan, cUnitStateAlive) >= 12) researchCheck(cTechImpLegendaryCoyoteMen, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpMacehualtin, cUnitStateAlive) >= 12) researchCheck(cTechImpLegendaryMacehualtins, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpPumaMan, cUnitStateAlive) >= 12) researchCheck(cTechImpLegendaryPumaMen, 50, cUnitTypeWarHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpArrowKnight, cUnitStateAlive) >= 12) researchCheck(cTechImpLegendaryArrowKnights, 50, cUnitTypeNoblesHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpEagleKnight, cUnitStateAlive) >= 12) researchCheck(cTechImpLegendaryEagleKnights, 50, cUnitTypeNoblesHut, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypexpJaguarKnight, cUnitStateAlive) >= 12) researchCheck(cTechImpLegendaryJaguarKnights, 50, cUnitTypeNoblesHut, cMilitaryEscrowID);
		if (gTownCenterNumber > 0) researchCheck(cTechImpImmigrantsNative, 50, gTownCenter, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractNativeWarrior, cUnitStateAlive) > 10) researchCheck(cTechImpLegendaryNativesNatives, 50, gTownCenter, cMilitaryEscrowID);
		researchCheck(cTechypConsulateSpanishBrigadeN, 50, cUnitTypeNativeEmbassy, cMilitaryEscrowID);
		researchCheck(cTechBigDockCipactli2, 50, gDockUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypYumi, cUnitStateAlive) >= 12) researchCheck(cTechYPExaltedYumi, 50, cUnitTypeypBarracksJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypAshigaru, cUnitStateAlive) >= 12) researchCheck(cTechYPExaltedAshigaru, 50, cUnitTypeypBarracksJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypKensei, cUnitStateAlive) >= 8) researchCheck(cTechYPExaltedSamurai, 50, cUnitTypeypBarracksJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeSohei, cUnitStateAlive) >= 8) researchCheck(cTechYPExaltedSohei, 50, cUnitTypeypBarracksJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypNaginataRider, cUnitStateAlive) >= 8) researchCheck(cTechYPExaltedNaginataRider, 50, cUnitTypeypStableJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypYabusame, cUnitStateAlive) >= 8) researchCheck(cTechYPExaltedYabusame, 50, cUnitTypeypStableJapanese, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypFlamingArrow, cUnitStateAlive) >= 5) researchCheck(cTechYPExaltedFlamingArrow, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypMorutaru, cUnitStateAlive) >= 5) researchCheck(cTechYPExaltedMorutaru, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypTekkousen, cUnitStateAlive) >= 1) researchCheck(cTechYPExaltedTekkousen, 50, gDockUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypHandMortar, cUnitStateAlive) >= 5) researchCheck(cTechYPExaltedHandMortar, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypFlameThrower, cUnitStateAlive) >= 5) researchCheck(cTechYPExaltedFlameThrower, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypIronFlail, cUnitStateAlive) >= 12) researchCheck(cTechYPExaltedIronFlail, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypMeteorHammer, cUnitStateAlive) >= 12) researchCheck(cTechYPExaltedMeteorHammer, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypChuKoNu, cUnitStateAlive) >= 12) researchCheck(cTechYPExaltedChuKoNu, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypQiangPikeman, cUnitStateAlive) >= 12) researchCheck(cTechYPExaltedQiangPikeman, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypSteppeRider, cUnitStateAlive) >= 12) researchCheck(cTechYPExaltedSteppeRider, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypKeshik, cUnitStateAlive) >= 12) researchCheck(cTechYPExaltedKeshik, 50, cUnitTypeypWarAcademy, cMilitaryEscrowID);
		researchCheck(cTechypImpDeforestationAsian, 50, cUnitTypeypTradeMarketAsian, cEconomyEscrowID);
		researchCheck(cTechypImpLargeScaleAgricultureAsian, 50, cUnitTypeypRicePaddy, cEconomyEscrowID);
		researchCheck(cTechypImpExcessiveTributeAsian, 50, cUnitTypeypRicePaddy, cEconomyEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractRajput, cUnitStateAlive) >= 12) researchCheck(cTechYPExaltedRajput, 50, cUnitTypeYPBarracksIndian, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractUrumi, cUnitStateAlive) >= 12) researchCheck(cTechYPExaltedUrumi, 50, cUnitTypeYPBarracksIndian, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractSepoy, cUnitStateAlive) >= 12) researchCheck(cTechYPExaltedSepoy, 50, cUnitTypeYPBarracksIndian, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractGurkha, cUnitStateAlive) >= 12) researchCheck(cTechYPExaltedGurkha, 50, cUnitTypeYPBarracksIndian, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractSowar, cUnitStateAlive) >= 8) researchCheck(cTechYPExaltedCamel, 50, cUnitTypeypCaravanserai, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractZamburak, cUnitStateAlive) >= 8) researchCheck(cTechYPExaltedCamelGun, 50, cUnitTypeypCaravanserai, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractMahout, cUnitStateAlive) >= 8) researchCheck(cTechYPExaltedMahout, 50, cUnitTypeypCaravanserai, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractHowdah, cUnitStateAlive) >= 8) researchCheck(cTechYPExaltedHowdah, 50, cUnitTypeypCaravanserai, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractMercFlailiphant, cUnitStateAlive) >= 5) researchCheck(cTechYPExaltedFlailElephant, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractSiegeElephant, cUnitStateAlive) >= 5) researchCheck(cTechYPExaltedSiegeElephant, 50, cUnitTypeypCastle, cMilitaryEscrowID);
		if (gTownCenterNumber > 0) researchCheck(cTechImpImmigrants, 50, gTownCenter, cMilitaryEscrowID);
		if (gTownCenterNumber > 0) researchCheck(cTechImpImmigrantsAsian, 50, gTownCenter, cMilitaryEscrowID);
		
		//if (gTownCenterNumber > 0 && kbGetTechAICost(cTechSpies) < 8000) researchCheck(cTechSpies, 50, gTownCenter, cMilitaryEscrowID);
		//if (gTownCenterNumber > 0 && kbGetTechAICost(cTechSpies) < 8000) researchCheck(cTechSpies, 50, gTownCenter, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeAbstractNativeWarrior, cUnitStateAlive) > 10) researchCheck(cTechypImpLegendaryNatives2, 50, gTownCenter, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeFrigate, cUnitStateAlive) > 0) researchCheck(cTechypImperialManOWar, 50, gDockUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeFrigate, cUnitStateAlive) > 0) researchCheck(cTechImperialManOWarUS, 50, gDockUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMonitor, cUnitStateAlive) > 0) researchCheck(cTechImperialMonitorsUS, 50, gDockUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeMonitor, cUnitStateAlive) > 0) researchCheck(cTechypImperialMonitors, 50, gDockUnit, cMilitaryEscrowID);
		if (kbUnitCount(cMyID, cUnitTypeypFuchuan, cUnitStateAlive) > 0) researchCheck(cTechYPExaltedFuchuan, 50, gDockUnit, cMilitaryEscrowID);
		researchCheck(cTechypVillagePopCapIncrease4, 50, cUnitTypeypVillage, cEconomyEscrowID);
		researchCheck(cTechUniqueUSTradingPosts, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechUniqueSPCCustomizedMercWeaponsUS, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechHCPatriots, 50, gChurchUnit, cEconomyEscrowID);

		researchCheck(cTechChurchArtillery, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchRedBrickWall, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchBlackWatchXP, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchVenetianGothic, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchFameArmies, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchSacredDecree, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchFortifiedWalls, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchLumberCamp, 50, gChurchUnit, cEconomyEscrowID);
		researchCheck(cTechChurchAxe, 50, gChurchUnit, cEconomyEscrowID);
		

		
		
		if (gTownCenterNumber > 0 && kbTechCostPerResource(cTechHCBlockade, cResourceGold) < 4000) researchCheck(cTechHCBlockade, 50, gTownCenter, cMilitaryEscrowID);
	}
	
}