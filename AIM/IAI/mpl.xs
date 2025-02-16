//monopolyMethods
void monopolyEndHandler(int teamID = -1)
{
	//aiEcho("     ");
	//aiEcho("     ");
	///aiEcho("     ");
	//aiEcho("MonopolyEndHandler:  Team "+teamID);
	if (teamID < 0)
		return;
	// If this is my team, console partners, and send defiant message to enemies
	if (gPlayerTeam == teamID)
	{
		sendStatement(cPlayerRelationAlly, cAICommPromptToAllyEnemyDestroyedMonopoly, cInvalidVector);
		sendStatement(cPlayerRelationEnemyNotGaia, cAICommPromptToEnemyTheyDestroyedMonopoly, cInvalidVector);
	}
	else // Otherwise, gloat at enemies
	{
		sendStatement(cPlayerRelationEnemyNotGaia, cAICommPromptToEnemyIDestroyedMonopoly, cInvalidVector);
	}
	gIsMonopolyRunning = false;
	gMonopolyTeam = -1;
	gMonopolyEndTime = -1;
	xsDisableRule("monopolyTimer");
}

rule monopolyTimer
inactive
minInterval 5
{
	if ((gIsMonopolyRunning == false) || (gMonopolyEndTime < 0))
	{
		xsDisableSelf();
		return;
	}
	if (gCurrentGameTime > gMonopolyEndTime)
	{
		// If this is my team, congratulate teammates and taunt enemies
		if (gPlayerTeam == gMonopolyTeam)
		{
			sendStatement(cPlayerRelationAlly, cAICommPromptToAlly1MinuteLeftOurMonopoly, cInvalidVector);
			sendStatement(cPlayerRelationEnemyNotGaia, cAICommPromptToEnemy1MinuteLeftOurMonopoly, cInvalidVector);
		}
		else // Otherwise, snide comment to enemies and panic to partners
		{
			sendStatement(cPlayerRelationAlly, cAICommPromptToAlly1MinuteLeftEnemyMonopoly, cInvalidVector);
			sendStatement(cPlayerRelationEnemyNotGaia, cAICommPromptToEnemy1MinuteLeftEnemyMonopoly, cInvalidVector);
		}
		xsDisableSelf();
		return;
	}
}

void monopolyStartHandler(int teamID = -1)
{
	//aiEcho("     ");
	//aiEcho("     ");
	//aiEcho("     ");
	//aiEcho("MonopolyStartHandler:  Team "+teamID);
	if (teamID < 0)
		return;

	// If this is my team, congratulate teammates and taunt enemies
	if (gPlayerTeam == teamID)
	{
		sendStatement(cPlayerRelationAlly, cAICommPromptToAllyWhenWeGetMonopoly, cInvalidVector);
		sendStatement(cPlayerRelationEnemyNotGaia, cAICommPromptToEnemyWhenWeGetMonopoly, cInvalidVector);
	}
	else // Otherwise, snide comment to enemies and condolences to partners
	{
		sendStatement(cPlayerRelationAlly, cAICommPromptToAllyWhenEnemiesGetMonopoly, cInvalidVector);
		sendStatement(cPlayerRelationEnemyNotGaia, cAICommPromptToEnemyWhenTheyGetMonopoly, cInvalidVector);
	}
	gIsMonopolyRunning = true;
	gMonopolyTeam = teamID;
	gMonopolyEndTime = gCurrentGameTime + 5 * 60 * 1000;
	xsEnableRule("monopolyTimer");
}
void monopolyMain()
{

}