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
		capitolArmy(cTechAge0Portuguese, cUnitTypeypConsulateArmyPortuguese11, cUnitTypeypConsulateArmyPortuguese22, cUnitTypeypConsulateArmyPortuguese33);
	}
	else if (kbTechGetStatus(cTechAge0Dutch) == cTechStatusActive)
	{
		capitolArmy(cTechAge0Dutch, cUnitTypeypConsulateArmyDutch11, cUnitTypeypConsulateArmyDutch22, cUnitTypeypConsulateArmyDutch22);
	}
	else if (kbTechGetStatus(cTechAge0Russian) == cTechStatusActive)
	{
		capitolArmy(cTechAge0Russian, cUnitTypeypConsulateArmyRussian11, cUnitTypeypConsulateArmyRussian22, cUnitTypeypConsulateArmyRussian33);
	}
	else if (kbTechGetStatus(cTechAge0Spanish) == cTechStatusActive)
	{
		capitolArmy(cTechAge0Spanish, cUnitTypeypConsulateArmySpanish11, cUnitTypeypConsulateArmySpanish22, cUnitTypeypConsulateArmySpanish33);
	}
	else if (kbTechGetStatus(cTechAge0British) == cTechStatusActive)
	{
		capitolArmy(cTechAge0British, cUnitTypeypConsulateArmyBritish11, cUnitTypeypConsulateArmyBritish22, cUnitTypeypConsulateArmyBritish33);
	}
	else if (kbTechGetStatus(cTechAge0French) == cTechStatusActive)
	{
		capitolArmy(cTechAge0French, cUnitTypeypConsulateArmyFrench11, cUnitTypeypConsulateArmyFrench22, cUnitTypeypConsulateArmyFrench33);
	}
	else if (kbTechGetStatus(cTechAge0German) == cTechStatusActive)
	{
		capitolArmy(cTechAge0German, cUnitTypeypConsulateArmyGerman11, cUnitTypeypConsulateArmyGerman22, cUnitTypeypConsulateArmyGerman33);
	}
	else if (kbTechGetStatus(cTechAge0Ottoman) == cTechStatusActive)
	{
		capitolArmy(cTechAge0Ottoman, cUnitTypeypConsulateArmyOttoman11, cUnitTypeypConsulateArmyOttoman22, cUnitTypeypConsulateArmyOttoman33);
	}
	else if (kbTechGetStatus(cTechAge0USA) == cTechStatusActive)
	{
		capitolArmy(cTechAge0USA, cUnitTypeUSColonialMarines2, cUnitTypeUSSaberSquad2, cUnitTypeUSGatlingGuns2);
	}
	else if (kbTechGetStatus(cTechAge0Italians) == cTechStatusActive)
	{
		capitolArmy(cTechAge0Italians, cUnitTypeypConsulateArmyItalians11, cUnitTypeypConsulateArmyItalians22, cUnitTypeypConsulateArmyItalians33);
	}
	else if (kbTechGetStatus(cTechAge0Swedish) == cTechStatusActive)
	{
		capitolArmy(cTechAge0Swedish, cUnitTypeSwedishArmy11, cUnitTypeSwedishArmy22, cUnitTypeSwedishArmy33);
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
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyPortuguese11, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyPortuguese22, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyPortuguese33, 0.6);
	}

	if (kbTechGetStatus(cTechAge0Dutch) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyDutch11, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyDutch22, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyDutch33, 0.6);
	}

	if (kbTechGetStatus(cTechAge0Russian) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyRussian11, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyRussian22, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyRussian33, 0.6);
	}

	if (kbTechGetStatus(cTechAge0Spanish) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmySpanish11, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmySpanish22, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmySpanish33, 0.6);
	}

	if (kbTechGetStatus(cTechAge0British) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyBritish11, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyBritish22, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyBritish33, 0.6);
	}

	if (kbTechGetStatus(cTechAge0French) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyFrench11, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyFrench22, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyFrench33, 0.6);
	}

	if (kbTechGetStatus(cTechAge0German) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyGerman11, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyGerman22, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyGerman33, 0.6);
	}

	if (kbTechGetStatus(cTechAge0Ottoman) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyOttoman11, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyOttoman22, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyOttoman33, 0.6);
	}

	if (kbTechGetStatus(cTechAge0USA) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeUSColonialMarines2, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeUSSaberSquad2, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeUSGatlingGuns2, 0.6);
	}

	if (kbTechGetStatus(cTechAge0Italians) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyItalians11, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyItalians22, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyItalians33, 0.6);
	}

	if (kbTechGetStatus(cTechAge0Swedish) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeSwedishArmy11, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeSwedishArmy22, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeSwedishArmy33, 0.6);
	}

}


void capMain()
{

}