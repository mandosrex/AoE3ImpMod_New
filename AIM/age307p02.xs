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
   btOffenseDefense = 1.0;
   btBiasArt = 0.0;
   btBiasInf = 0.5;
   btBiasCav = 0.5;
   cvOkToBuildForts = false;

   cvMaxAge = cAge3;
   cvOkToGatherNuggets = false;
   cvDefenseReflexRadiusActive = 60.0;
   cvDefenseReflexRadiusPassive = 60.0;
   cvDefenseReflexSearchRadius = 80.0;
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