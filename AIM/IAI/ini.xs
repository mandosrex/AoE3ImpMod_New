//init

//==============================================================================
/* transportArrive()
	NOTE: Do not rename as it is used in Campaign files
	This function is called when it is time for the AI to come to life.
	
	In Scenario/Campaign games, it means the aiStart object has been placed.
	
	In RM/GC games, it means that the player has all the starting units.  This may
	mean that the initial boat has been unloaded, or the player has started
	with a TC and units, or the player has initial units and a covered wagon
	and must choose a TC location.  
	
	This function activates "initRule" if everything is OK for a start...
*/
//==============================================================================
void transportArrive(int parm = -1) // Event handler
{
	static bool firstTime = true;
	if (firstTime == false) return;
	if (gSPC == true)
	{
		// Verify aiStart object, return if it isn't there
		if (kbUnitCount(cMyID, cUnitTypeAIStart, cUnitStateAlive) < 1)
		{
			xsEnableRule("waitForStartup");
			return ();
		}
	}

	if (firstTime == true)
	{
		// Do init processing
		//aiEcho("The transport has arrived.");
		firstTime = false;
		// No need for it, we're running
		xsDisableRule("initializeAIFailsafe");
		xsEnableRule("initRule");
	}
}


rule initializeAIFailsafe
inactive
minInterval 30
{ // This rule is normally killed when initializeAI runs the first time.
	transportArrive(-1); // Call it if we're still running at 30 seconds, make sure the AI starts.
}

void initializeMain()
{

}