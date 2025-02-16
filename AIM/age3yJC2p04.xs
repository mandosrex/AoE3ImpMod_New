//==============================================================================
/* aiLoaderStandard.xs
   
   Create a new loader file for each personality.  Always specify loader
   file names (not the main or header files) in scenarios.
*/
//==============================================================================



include "aiHeaderCampaign.xs";     // Gets global vars, function forward declarations
include "aiMainCampaign.xs";       // The bulk of the AI



//==============================================================================
/*	preInit()

	This function is called in main() before any of the normal initialization 
	happens.  Use it to override default values of variables as needed for 
	personality or scenario effects.
	
	*/
//==============================================================================
void preInit(void)
{
   aiEcho("preInit() starting.");
   btRushBoom = 1.0;
   btOffenseDefense = 0.7;
   btBiasTrade = 0.7;
   cvOkToAllyNatives = false;
   cvMaxAge = cAge5;
   cvOkToBuildForts = false;
   cvOkToExplore = false;
   cvOkToGatherNuggets = false;
   
   cvOkToClaimTrade = false;
   cvOkToBuildConsulate = false;
   
   cvPrimaryArmyUnit = cUnitTypeypKensei;
   cvSecondaryArmyUnit = cUnitTypeypYumi;
   
   cvOkToAttack = false;
}



//==============================================================================
/*	postInit()

	This function is called in main() after the normal initialization is 
	complete.  Use it to override settings and decisions made by the startup logic.
*/
//==============================================================================
void postInit(void)
{
   aiEcho("postInit() starting.");
   
}




//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================