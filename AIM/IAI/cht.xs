//aiCheats

void AI_AutoRepair()
{ //Gives hard and expert ai auto repair cheat
	//if (gWorldDifficulty < cDifficultyHard)
	//{ //check Difficulty level
	//	xsDisableSelf(); //disable rule
	//	return;
	//} //end if
	static bool turnOff = false;
	if(turnOff == true)return;
	
	if (gTownCenterNumber < 1) return; //check for town center
	turnOff = true;
	aiTaskUnitResearch(getUnit(gTownCenter), cTechAIAutoRepair); //give ai auto repair cheat 
	if (kbTechGetStatus(cTechAIAutoRepair) == cTechStatusActive) return; //disable rule when ai has tech
} //end AI_AutoRepair

void AI_EarlyCheats()
{ //Gives hard and expert ai AICheats
	static bool turnOff = false;
	if(turnOff == true)return;
	if (gCurrentAge < cAge2) return;
	if (gWorldDifficulty < cDifficultyHard)
	{ //check Difficulty level
		return;
	} //end if
	if (gTownCenterNumber < 1) return; //check for town center
	turnOff = true;
	aiTaskUnitResearch(getUnit(gTownCenter), cTechAICheats); //give ai cheats 
	if (kbTechGetStatus(cTechAICheats) == cTechStatusActive) return; //disable rule when ai has tech
	
} //end AI_EarlyCheats

//==============================================================================
/* rule AI_LateCheats
	updatedOn 2019/10/08 By ageekhere  
*/
//==============================================================================
void AI_LateCheats()
{ //Gives an expert ai AICheatsAge4
	static bool turnOff = false;
	if(turnOff == true)return;
	if (gCurrentAge < cAge3) return;
	if (gWorldDifficulty < cDifficultyHard)
	{ //check Difficulty level 
		return;
	} //end if
	if (gTownCenterNumber < 1) return; //check for town center
	turnOff = true;
	aiTaskUnitResearch(getUnit(gTownCenter), cTechAICheatsAge4); //give ai age 4 cheats 
	if (kbTechGetStatus(cTechAICheatsAge4) == cTechStatusActive) return; //disable rule when ai has tech
	
} //end AI_LateCheats

void cheatsMain()
{

}

