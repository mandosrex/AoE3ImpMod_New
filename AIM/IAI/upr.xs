//unitPicker
//NOTE: The unit pick methods are being phased out, militaryTrainManager is the replacment. However the picker is used for new civs until they can be calibrated 

/* setUnitPickerPreference()
	
	Updates the unit picker biases, arbitrates between the potentially conflicting sources.  
	
	Priority order is:
	
	1)  If control is from a trigger, that wins.  The unit line specified in gCommandUnitLine gets a +.8, all others +.2
	2)  If control is ally command, ditto.  (Can only be one unit due to UI limits.
	3)  If we're not under command, but cvPrimaryArmyUnit (and optionally cvSecondaryArmyUnit, cvTertiaryArmy Unit) are set, they rule.
	If just primary, it gets 0.8, with 0.2 for other classes.  
	If primary and secondary, they get 1.0 and 0.5, others get 0.0.
	If primary, secondary and tertiary, they get 0.8, 0.4 and 0.2, others get 0.0.
	4)  If enough enemy units have been spotted, bias towards appropriate counters
	5)  If not under command, no cv's are set, and no units have been spotted, we go with the btBiasCav, btBiasInf and btBiasArt line settings.  
	
*/

void set_avoided_unit_pref(bool reset = false)
{
	// No matter what, ALWAYS avoid putting the following units in preference:
	if (reset)
		kbUnitPickResetAll(gLandUnitPicker);

	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeCoureur, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypexpWarrior, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypexpDogSoldier, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypexpMedicineManAztec, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypexpSkullKnight, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypexpRam, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypexpPetard, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeMortar, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypexpSpy, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeGoldMiner, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeNativeScout, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeEnvoy, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypMongolScout, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeMercenary, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypSowarMansabdar, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypRajputMansabdar, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypNatMercGurkhaJemadar, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypZamburakMansabdar, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypMercFlailiphantMansabdar, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypHowdahMansabdar, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypMahoutMansabdar, 0.0);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypSiegeElephantMansabdar, 0.0);
}

void clear_unit_pref(bool reset = false)
{
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractInfantry, 0.5);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractArtillery, 0.2);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractCavalry, 0.5);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractNativeWarrior, 0.2);
	kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeCoureur, 0.0);
	if (cMyCiv == cCivXPAztec)
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractLightInfantry, 0.5);
}

void setUnitPickerPreference(int upID = -1)
{
	if (gIslandLanded == true)
	{
		return;
	}

	// Add the main unit lines
	if (upID < 0)
		return;

	// First of all, AND IT'S REALLY IMPORTANT, check if a human ally told us to focus on a certain unit type only:
	if ((gUnitPickSource == cOpportunitySourceTrigger) || (gUnitPickSource == cOpportunitySourceAllyRequest))
	{
		// Yes, someone told us to focus on a certain unit type only.

		// So, first of all, clear all preferences:
		kbUnitPickResetAll(gLandUnitPicker);

		clear_unit_pref();
		set_avoided_unit_pref();

		// Now, let's focus on the unit type we are told to focus on:
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cvPrimaryArmyUnit, 0.85);

		return;
	}

	// IF we have not received any request from ally/trigger, then check for pre-assigned types in aiLoaderStandard.xs:
	if (cvPrimaryArmyUnit >= 0)
	{
		kbUnitPickResetAll(gLandUnitPicker);

		if (cvSecondaryArmyUnit == -1)
		{
			clear_unit_pref();
			set_avoided_unit_pref();

			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cvPrimaryArmyUnit, 0.85);
		}
		else if (cvTertiaryArmyUnit == -1)
		{
			clear_unit_pref();
			set_avoided_unit_pref();

			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cvPrimaryArmyUnit, 0.8);
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cvSecondaryArmyUnit, 0.2);
		}
		else
		{
			clear_unit_pref();
			set_avoided_unit_pref();

			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cvPrimaryArmyUnit, 0.6);
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cvSecondaryArmyUnit, 0.3);
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cvTertiaryArmyUnit, 0.1);
		}

		return;
	}


	// IF there are no pre-assigned types in aiLoaderStandard.xs, then go with normal preferences:

	// But first of all, check for units to counter:
	static bool counterUnitMode = false;

	float enemyToCounter = aiGetMostHatedPlayerID();
	float heavyInfantryCount = kbUnitCount(enemyToCounter, cUnitTypeAbstractHeavyInfantry, cUnitStateAlive);
	float lightInfantryCount = kbUnitCount(enemyToCounter, cUnitTypeAbstractInfantry, cUnitStateAlive) - heavyInfantryCount;
	float lightCavalryCount = kbUnitCount(enemyToCounter, cUnitTypeAbstractLightCavalry, cUnitStateAlive);
	lightCavalryCount = lightCavalryCount + kbUnitCount(enemyToCounter, cUnitTypexpEagleKnight, cUnitStateAlive); // Aztec eagle knights count as light cavalry
	float heavyCavalryCount = kbUnitCount(enemyToCounter, cUnitTypeAbstractHeavyCavalry, cUnitStateAlive);
	heavyCavalryCount = heavyCavalryCount + kbUnitCount(enemyToCounter, cUnitTypexpCoyoteMan, cUnitStateAlive); // Aztec coyote runners count as heavy cavalry
	float artilleryCount = kbUnitCount(enemyToCounter, cUnitTypeAbstractArtillery, cUnitStateAlive);
	float totalEnemyCount = lightInfantryCount + heavyInfantryCount + lightCavalryCount + heavyCavalryCount + artilleryCount;

	if (totalEnemyCount >= 1000)
	{
		counterUnitMode = true;

		// Calculate enemy's basic unit ratio and favor appropriate counters
		float lightInfantryFactor = lightInfantryCount / totalEnemyCount;
		float heavyInfantryFactor = heavyInfantryCount / totalEnemyCount;
		float lightCavalryFactor = lightCavalryCount / totalEnemyCount;
		float heavyCavalryFactor = heavyCavalryCount / totalEnemyCount;
		float artilleryFactor = artilleryCount / totalEnemyCount;

		kbUnitPickAddCombatEfficiencyType(upID, cUnitTypeSkirmisher, lightInfantryFactor); // Skirmisher representing light infantry
		kbUnitPickAddCombatEfficiencyType(upID, cUnitTypeMusketeer, heavyInfantryFactor); // Musketeer representing heavy infantry
		kbUnitPickAddCombatEfficiencyType(upID, cUnitTypeDragoon, lightCavalryFactor); // Dragoon representing light cavalry
		kbUnitPickAddCombatEfficiencyType(upID, cUnitTypeHussar, heavyCavalryFactor); // Hussar representing heavy cavalry
		kbUnitPickAddCombatEfficiencyType(upID, cUnitTypeFalconet, artilleryFactor); // Falconet representing artillery

		return;
	}

	// If we're not in counter mode, then go with normal preferences
	if (counterUnitMode == false)
	{
		kbUnitPickResetAll(gLandUnitPicker);

		clear_unit_pref();
		set_avoided_unit_pref();

		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractInfantry, 0.5 + (btBiasInf / 2.0)); // Range 0.0 to 1.0
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractArtillery, 0.5 + (btBiasArt / 2.0));
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractCavalry, 0.5 + (btBiasCav / 2.0));
		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractNativeWarrior, 0.5 + (btBiasNative / 2.0));

		kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypNatConquistador, 0.0);

		if (cMyCiv == cCivXPAztec)
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractLightInfantry, 0.5 + (btBiasCav / 2.0));

		if (cMyCiv == cCivBritish)
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeHalberdier, 0.1);

		if (cMyCiv == cCivFrench)
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeFlatbowman, 0.1);

		set_avoided_unit_pref();

		if ((kbGetCiv() == cCivChinese) || (kbGetCiv() == cCivSPCChinese))
		{
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractInfantry, 0.0);
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractCavalry, 0.0);

			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypStandardArmy, 0.4); // Range 0.0 to 1.0
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypMingArmy, 0.4); // Range 0.0 to 1.0
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypImperialArmy, 0.4); // Range 0.0 to 1.0
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypTerritorialArmy, 0.6); // Range 0.0 to 1.0
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypOldHanArmy, 0.5); // Range 0.0 to 1.0
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypForbiddenArmy, 0.6);
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypBlackFlagArmy, 0.3);
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeypMongolianArmy, 0.3);

			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractArtillery, 0.4);
		}

		if (getCivIsAsian() == true)
		{
			// Set preferences for consulate units
			setConsulateArmyPreference();
		}

		if (getCivIsAsian() == false)
		{
			// Set preferences for capitol units
			setCapitolArmyPreference();
		}

		if (getCivIsNative() == true)
		{
			// Natives and Europeans need to stop trying to build consulate and monastery units
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractConsulateSiegeFortress, 0.0);
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractConsulateSiegeIndustrial, 0.0);
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractConsulateUnit, 0.0);
			kbUnitPickSetPreferenceFactor(gLandUnitPicker, cUnitTypeAbstractConsulateUnitColonial, 0.0);
		}
	}
}

//==============================================================================
// initUnitPicker
//==============================================================================
int initUnitPicker(string name = "BUG", int numberTypes = 1, int minUnits = 10,
	int maxUnits = 20, int minPop = -1, int maxPop = -1, int numberBuildings = 1,
	bool guessEnemyUnitType = false)
{
	//Create it.
	int upID = kbUnitPickCreate(name);
	if (upID < 0)
		return (-1);

	//Default init.
	kbUnitPickResetAll(upID);

	kbUnitPickSetPreferenceWeight(upID, 1.0);
	if (gSPC == false)
		kbUnitPickSetCombatEfficiencyWeight(upID, 2.0); // Changed from 1.0 to dilute the power of the preference weight.
	else
		kbUnitPickSetCombatEfficiencyWeight(upID, 1.0); // Leave it at 1.0 to avoid messing up SPC balance

	kbUnitPickSetCostWeight(upID, 0.0);
	//Desired number units types, buildings.
	kbUnitPickSetDesiredNumberUnitTypes(upID, numberTypes, numberBuildings, true);
	//Min/Max units and Min/Max pop.
	kbUnitPickSetMinimumNumberUnits(upID, minUnits); // Sets "need" level on attack plans
	kbUnitPickSetMaximumNumberUnits(upID, maxUnits); // Sets "max" level on attack plans, sets "numberToMaintain" on train plans for primary unit,
	// half that for secondary, 1/4 for tertiary, etc.
	kbUnitPickSetMinimumPop(upID, minPop); // Not sure what this does...
	kbUnitPickSetMaximumPop(upID, maxPop); // If set, overrides maxNumberUnits for how many of the primary unit to maintain.

	//Default to land units.
	kbUnitPickSetEnemyPlayerID(upID, aiGetMostHatedPlayerID());
	kbUnitPickSetAttackUnitType(upID, cUnitTypeLogicalTypeLandMilitary);
	kbUnitPickSetGoalCombatEfficiencyType(upID, cUnitTypeLogicalTypeLandMilitary);

	// Set the default target types and weights, for use until we've seen enough actual units.
	//   kbUnitPickAddCombatEfficiencyType(upID, cUnitTypeLogicalTypeLandMilitary, 1.0);


	kbUnitPickAddCombatEfficiencyType(upID, cUnitTypeSettler, 0.2); // We need to build units that can kill settlers efficiently.
	kbUnitPickAddCombatEfficiencyType(upID, cUnitTypeHussar, 0.2); // Major component
	kbUnitPickAddCombatEfficiencyType(upID, cUnitTypeMusketeer, 0.4); // Bigger component  
	kbUnitPickAddCombatEfficiencyType(upID, cUnitTypePikeman, 0.1); // Minor component
	kbUnitPickAddCombatEfficiencyType(upID, cUnitTypeCrossbowman, 0.1); // Minor component
	kbUnitPickAddCombatEfficiencyType(upID, cUnitTypeGoldMiner, 0.0); // Minor component


	setUnitPickerPreference(upID); // Set generic preferences for this civ


	//Done.
	return (upID);
}

void unitPickerMain()
{

}