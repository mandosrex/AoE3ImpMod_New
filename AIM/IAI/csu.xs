//consulate

//==============================================================================
//chooseConsulateFlag
//==============================================================================
void chooseConsulateFlag()
{
	int consulatePlanID = -1;
	int randomizer = aiRandInt(100); // 0-99
	int flag_button_id = -1;

	// Chinese options: British, Russians, French (HC level >= 25) & Germans (HC level >= 40)
	// Choice biased towards Russians
	if ((kbGetCiv() == cCivChinese) || (kbGetCiv() == cCivSPCChinese))
	{
		if (kbGetHCLevel(cMyID) < 25)
		{
			if (randomizer < 70) // 70 % probability
			{
				flag_button_id = cTechypBigConsulateRussians;
				cvOkToBuildForts = true;
			}
			else // 30 % probability
			{
				flag_button_id = cTechypBigConsulateBritish;
			}
		}
		else if (kbGetHCLevel(cMyID) < 40)
		{
			if (randomizer < 60) // 60 % probability
			{
				flag_button_id = cTechypBigConsulateRussians;
				cvOkToBuildForts = true;
			}
			else if (randomizer < 80) // 20 % probability
			{
				flag_button_id = cTechypBigConsulateBritish;
			}
			else // 20 % probability
			{
				flag_button_id = cTechypBigConsulateFrench;
			}
		}
		else // HC level >= 40
		{
			if (randomizer < 52) // 52 % probability
			{
				flag_button_id = cTechypBigConsulateRussians;
				cvOkToBuildForts = true;
			}
			else if (randomizer < 68) // 16 % probability
			{
				flag_button_id = cTechypBigConsulateBritish;
			}
			else if (randomizer < 84) // 16 % probability
			{
				flag_button_id = cTechypBigConsulateFrench;
			}
			else // 16 % probability
			{
				flag_button_id = cTechypBigConsulateGermans;
			}
		}
	}

	// Indian options: British, Portuguese, French (HC level >= 25) & Ottomans (HC level >= 40)
	// Choice biased towards Portuguese, especially on water maps
	if ((kbGetCiv() == cCivIndians) || (kbGetCiv() == cCivSPCIndians))
	{
		if (gNavyFlagUnit > 0)
		{
			if (kbGetHCLevel(cMyID) < 25)
			{
				if (randomizer < 80) // 80 % probability
				{
					flag_button_id = cTechypBigConsulatePortuguese;
				}
				else // 20 % probability
				{
					flag_button_id = cTechypBigConsulateBritish;
				}
			}
			else if (kbGetHCLevel(cMyID) < 40)
			{
				if (randomizer < 60) // 60 % probability
				{
					flag_button_id = cTechypBigConsulatePortuguese;
				}
				else if (randomizer < 80) // 20 % probability
				{
					flag_button_id = cTechypBigConsulateBritish;
				}
				else // 20 % probability
				{
					flag_button_id = cTechypBigConsulateFrench;
				}
			}
			else // HC level >= 40
			{
				if (randomizer < 52) // 52 % probability
				{
					flag_button_id = cTechypBigConsulatePortuguese;
				}
				else if (randomizer < 68) // 16 % probability
				{
					flag_button_id = cTechypBigConsulateBritish;
				}
				else if (randomizer < 84) // 16 % probability
				{
					flag_button_id = cTechypBigConsulateFrench;
				}
				else // 16 % probability
				{
					flag_button_id = cTechypBigConsulateOttomans;
				}
			}
		}
		else // land map
		{
			if (kbGetHCLevel(cMyID) < 25)
			{
				if (randomizer < 60) // 60 % probability
				{
					flag_button_id = cTechypBigConsulatePortuguese;
				}
				else // 40 % probability
				{
					flag_button_id = cTechypBigConsulateBritish;
				}
			}
			else if (kbGetHCLevel(cMyID) < 40)
			{
				if (randomizer < 40) // 40 % probability
				{
					flag_button_id = cTechypBigConsulatePortuguese;
				}
				else if (randomizer < 70) // 30 % probability
				{
					flag_button_id = cTechypBigConsulateBritish;
				}
				else // 30 % probability
				{
					flag_button_id = cTechypBigConsulateFrench;
				}
			}
			else // HC level >= 40
			{
				if (randomizer < 40) // 40 % probability
				{
					flag_button_id = cTechypBigConsulatePortuguese;
				}
				else if (randomizer < 60) // 20 % probability
				{
					flag_button_id = cTechypBigConsulateBritish;
				}
				else if (randomizer < 80) // 20 % probability
				{
					flag_button_id = cTechypBigConsulateFrench;
				}
				else // 20 % probability
				{
					flag_button_id = cTechypBigConsulateOttomans;
					//xsEnableRule("consulateLevy");
				}
			}
		}
	}

	// Japanese options: Isolation, Portuguese, Dutch (HC level >= 25) & Spanish (HC level >= 40)
	// Choice biased towards Portuguese on water maps, towards Dutch on land maps
	if ((kbGetCiv() == cCivJapanese) || (kbGetCiv() == cCivSPCJapanese) || (kbGetCiv() == cCivSPCJapanese))
	{
		if (gNavyFlagUnit > 0)
		{
			if (kbGetHCLevel(cMyID) < 25)
			{
				if (randomizer < 80) // 80 % probability
				{
					flag_button_id = cTechypBigConsulatePortuguese;
				}
				else // 20 % probability
				{
					flag_button_id = cTechypBigConsulateJapanese;
				}
			}
			else if (kbGetHCLevel(cMyID) < 40)
			{
				if (randomizer < 60) // 60 % probability
				{
					flag_button_id = cTechypBigConsulatePortuguese;
				}
				else if (randomizer < 80) // 20 % probability
				{
					flag_button_id = cTechypBigConsulateJapanese;
				}
				else // 20 % probability
				{
					flag_button_id = cTechypBigConsulateDutch;
				}
			}
			else // HC level >= 40
			{
				if (randomizer < 50) // 50 % probability
				{
					flag_button_id = cTechypBigConsulatePortuguese;
				}
				else if (randomizer < 65) // 15 % probability
				{
					flag_button_id = cTechypBigConsulateJapanese;
				}
				else if (randomizer < 85) // 20 % probability
				{
					flag_button_id = cTechypBigConsulateDutch;
				}
				else // 15 % probability
				{
					flag_button_id = cTechypBigConsulateSpanish;
				}
			}
		}
		else // land map
		{
			if (kbGetHCLevel(cMyID) < 25)
			{
				if (randomizer < 30) // 30 % probability
				{
					flag_button_id = cTechypBigConsulatePortuguese;
				}
				else // 70 % probability
				{
					flag_button_id = cTechypBigConsulateJapanese;
				}
			}
			else if (kbGetHCLevel(cMyID) < 40)
			{
				if (randomizer < 20) // 20 % probability
				{
					flag_button_id = cTechypBigConsulatePortuguese;
				}
				else if (randomizer < 40) // 20 % probability
				{
					flag_button_id = cTechypBigConsulateJapanese;
				}
				else // 60 % probability
				{
					flag_button_id = cTechypBigConsulateDutch;
				}
			}
			else // HC level >= 40
			{
				if (randomizer < 10) // 10 % probability
				{
					flag_button_id = cTechypBigConsulatePortuguese;
				}
				else if (randomizer < 30) // 20 % probability
				{
					flag_button_id = cTechypBigConsulateJapanese;
				}
				else if (randomizer < 80) // 50 % probability
				{
					flag_button_id = cTechypBigConsulateDutch;
				}
				else // 20 % probability
				{
					flag_button_id = cTechypBigConsulateSpanish;
				}
			}
		}
	}

	if (kbTechGetStatus(flag_button_id) == cTechStatusObtainable)
	{
		consulatePlanID = aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, flag_button_id);
		if (consulatePlanID < 0)
		{
			//aiEcho("************Consulate Flag************");
			//aiEcho("Our Consulate flag is: "+kbGetTechName(flag_button_id));
			//aiEcho("Randomizer value: "+randomizer);
			createSimpleResearchPlan(flag_button_id, getUnit(cUnitTypeypConsulate), cEconomyEscrowID, 40);
			gChosenConsulateFlag = true;
		}
	}
}

void setConsulateArmyPreference()
{
	if (kbUnitCount(cMyID, cUnitTypeypConsulate, cUnitStateAlive) < 1)
	{
		return;
	}
	if (kbTechGetStatus(cTechypBigConsulatePortuguese) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyPortuguese1, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyPortuguese2, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyPortuguese3, 0.6);
	}

	if (kbTechGetStatus(cTechypBigConsulateDutch) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyDutch1, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyDutch2, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyDutch3, 0.6);
	}

	if (kbTechGetStatus(cTechypBigConsulateRussians) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyRussian1, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyRussian2, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyRussian3, 0.6);
	}

	if (kbTechGetStatus(cTechypBigConsulateSpanish) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmySpanish1, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmySpanish2, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmySpanish3, 0.6);
	}

	if (kbTechGetStatus(cTechypBigConsulateBritish) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyBritish1, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyBritish2, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyBritish3, 0.6);
	}

	if (kbTechGetStatus(cTechypBigConsulateFrench) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyFrench1, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyFrench2, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyFrench3, 0.6);
	}

	if (kbTechGetStatus(cTechypBigConsulateGermans) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyGerman1, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyGerman2, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyGerman3, 0.6);
	}

	if (kbTechGetStatus(cTechypBigConsulateOttomans) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyOttoman1, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyOttoman2, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyOttoman3, 0.6);
	}

	if (kbTechGetStatus(cTechypBigConsulateJapanese) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeUSColonialMarines, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeUSSaberSquad, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeUSGatlingGuns, 0.6);
	}

	if (kbTechGetStatus(cTechypBigConsulateSPCChina) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyItalians1, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyItalians2, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypConsulateArmyItalians3, 0.6);
	}

	if (kbTechGetStatus(cTechypBigConsulateSPCIndia) == cTechStatusActive)
	{
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeSwedishArmy1, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeSwedishArmy2, 0.6);
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeSwedishArmy3, 0.6);
	}

}

void conMain()
{

}