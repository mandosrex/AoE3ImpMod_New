//capitol

//==============================================================================
// capitolArmy
// updatedOn 2020/11/15 By ageekhere
//==============================================================================
void capitolArmy(int techAgeCiv = -1, int tech1 = -1, int tech2 = -1, int tech3 = -1)
{ //trains capitol Army
	debugRule("void capitolArmy ",-1);
	int capID = getUnit(gCapitolUnit, cMyID, cUnitStateAlive); //get the Capitol id
	if (gCurrentFood > 4000 && gCurrentCoin > 4000)return; //make normal army
	
	if (kbTechGetStatus(techAgeCiv) == cTechStatusActive)
	{
		if (gCurrentFame > kbUnitCostPerResource(tech1, cResourceFame) && kbBaseGetUnderAttack(cMyID, 0) == false)
		{
			aiTaskUnitTrain(capID, tech1);
		}
		if (gCurrentFame > kbUnitCostPerResource(tech2, cResourceFame) && kbBaseGetUnderAttack(cMyID, 0) == false)
		{
			aiTaskUnitTrain(capID, tech2);
		}
		if (gCurrentFame > kbUnitCostPerResource(tech3, cResourceFame))
		{
			aiTaskUnitTrain(capID, tech3);
		}
	}
} //end capitolArmy

//==============================================================================
// capitolArmyManager
// updatedOn 2020/11/15 By ageekhere
//==============================================================================
void capitolArmyManager()
{ //managers capitol armies
	if(gHaveFameAgeUpCard == true && gCurrentAge != cAge5) return;
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"capitolArmyManager") == false) return;
	lastRunTime = gCurrentGameTime;
	
	if (kbUnitCount(cMyID, gCapitolUnit, cUnitStateAlive) < 1) return; //no Capitol
	debugRule("void capitolArmyManager ",-1);
	//checks the civ and sends the unit types to capitolArmy()
	if (kbTechGetStatus(cTechAge0Portuguese) == cTechStatusActive)
	{
		capitolArmy(cTechAge0Portuguese, cUnitTypeSavoyArmy, cUnitTypePapalArmy, cUnitTypeTrastamaraArmy);
	}
	else if (kbTechGetStatus(cTechAge0Dutch) == cTechStatusActive)
	{
		capitolArmy(cTechAge0Dutch, cUnitTypeStewartArmy, cUnitTypeWittelsbachArmy, cUnitTypeOldenburgArmy);
	}
	else if (kbTechGetStatus(cTechAge0Russian) == cTechStatusActive)
	{
		capitolArmy(cTechAge0Russian, cUnitTypeRomanovArmy, cUnitTypeHohenzollernArmy, cUnitTypeJagiellonArmy);
	}
	else if (kbTechGetStatus(cTechAge0Spanish) == cTechStatusActive)
	{
		capitolArmy(cTechAge0Spanish, cUnitTypeHabsburgArmy, cUnitTypeTrastamaraArmy, cUnitTypeBourbonArmy);
	}
	else if (kbTechGetStatus(cTechAge0British) == cTechStatusActive)
	{
		capitolArmy(cTechAge0British, cUnitTypeStewartArmy, cUnitTypeOldenburgArmy, cUnitTypeHabsburgArmy);
	}
	else if (kbTechGetStatus(cTechAge0French) == cTechStatusActive)
	{
		capitolArmy(cTechAge0French, cUnitTypeBourbonArmy, cUnitTypeHohenzollernArmy, cUnitTypeWittelsbachArmy);
	}
	else if (kbTechGetStatus(cTechAge0German) == cTechStatusActive)
	{
		capitolArmy(cTechAge0German, cUnitTypeHabsburgArmy, cUnitTypeHohenzollernArmy, cUnitTypeWittelsbachArmy);
	}
	else if (kbTechGetStatus(cTechAge0USA) == cTechStatusActive)
	{
		capitolArmy(cTechAge0USA, cUnitTypeMassachusettsArmy, cUnitTypePennsylvaniaArmy, cUnitTypeConnecticutArmy);
	}
	else if (kbTechGetStatus(cTechAge0Italians) == cTechStatusActive)
	{
		capitolArmy(cTechAge0Italians, cUnitTypePapalArmy, cUnitTypeSavoyArmy, cUnitTypeBourbonArmy);
	}
	else if (kbTechGetStatus(cTechAge0Swedish) == cTechStatusActive)
	{
		capitolArmy(cTechAge0Swedish, cUnitTypeRomanovArmy, cUnitTypeJagiellonArmy, cUnitTypeOldenburgArmy);
	}
} //end capitolArmyManager

void setCapitolArmyPreference()
{
	if (kbUnitCount(cMyID, gCapitolUnit, cUnitStateAlive) < 1)
	{
		return;
	}
	if (kbTechGetStatus(cTechAge0Portuguese) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeSavoyArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypePapalArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeTrastamaraArmy, 0.6);
	}

	if (kbTechGetStatus(cTechAge0Dutch) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeStewartArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeWittelsbachArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeOldenburgArmy, 0.6);
	}

	if (kbTechGetStatus(cTechAge0Russian) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeRomanovArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeHohenzollernArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeJagiellonArmy, 0.6);
	}

	if (kbTechGetStatus(cTechAge0Spanish) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeHabsburgArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeTrastamaraArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeBourbonArmy, 0.6);
	}

	if (kbTechGetStatus(cTechAge0British) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeStewartArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeOldenburgArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeHabsburgArmy, 0.6);
	}

	if (kbTechGetStatus(cTechAge0French) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeBourbonArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeHohenzollernArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeWittelsbachArmy, 0.6);
	}

	if (kbTechGetStatus(cTechAge0German) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeHabsburgArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeHohenzollernArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeWittelsbachArmy, 0.6);
	}

	if (kbTechGetStatus(cTechAge0USA) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeMassachusettsArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypePennsylvaniaArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeConnecticutArmy, 0.6);
	}

	if (kbTechGetStatus(cTechAge0Italians) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypePapalArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeSavoyArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeBourbonArmy, 0.6);
	}

	if (kbTechGetStatus(cTechAge0Swedish) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeRomanovArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeJagiellonArmy, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeOldenburgArmy, 0.6);
	}

}


void capMain()
{

}