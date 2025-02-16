//aiLearning
void gameOverHandler(int nothing = 0)
{
	bool iWon = false;
	if (kbHasPlayerLost(cMyID) == false)
		iWon = true;

	//aiEcho("Game is over.");
	//aiEcho("Have I lost returns "+kbHasPlayerLost(cMyID));
	if (iWon == false)
		aiEcho("I lost.");
	else
		aiEcho("I won.");

	for (pid = 1; < cNumberPlayers)
	{
		//-- Skip ourself.
		if (pid == cMyID)
			continue;

		//-- get player name
		string playerName = kbGetPlayerName(pid);
		//aiEcho("PlayerName: "+playerName);

		//-- Does a record exist?
		int playerHistoryID = aiPersonalityGetPlayerHistoryIndex(playerName);
		if (playerHistoryID == -1)
		{
			//aiEcho("PlayerName: Never played against");
			//-- Lets make a new player history.
			playerHistoryID = aiPersonalityCreatePlayerHistory(playerName);
		}


		/* Store the following user vars:
			heBeatMeLastTime
			iBeatHimLastTime
			iCarriedHimLastTime
			heCarriedMeLastTime
			iWonLastGame
		*/
		if (iWon == true)
		{ // I won
			aiPersonalitySetPlayerUserVar(playerHistoryID, "iWonLastGame", 1.0);
			if (kbIsPlayerEnemy(pid) == true)
			{
				aiPersonalitySetPlayerUserVar(playerHistoryID, "iBeatHimLastTime", 1.0);
				aiPersonalitySetPlayerUserVar(playerHistoryID, "heBeatMeLastTime", 0.0);
				//aiEcho("This player was my enemy.");
			}
		}
		else
		{ // I lost
			aiPersonalitySetPlayerUserVar(playerHistoryID, "iWonLastGame", 0.0);
			if (kbIsPlayerEnemy(pid) == true)
			{
				aiPersonalitySetPlayerUserVar(playerHistoryID, "iBeatHimLastTime", 0.0);
				aiPersonalitySetPlayerUserVar(playerHistoryID, "heBeatMeLastTime", 1.0);
				//aiEcho("This player was my enemy.");
			}
		}
		if (kbIsPlayerAlly(pid) == true)
		{ // Was my ally
			if (aiGetScore(cMyID) > (2 * aiGetScore(pid)))
			{ // I outscored him badly
				aiPersonalitySetPlayerUserVar(playerHistoryID, "iCarriedHimLastTime", 1.0);
				//aiEcho("I carried my ally.");
			}
			else
				aiPersonalitySetPlayerUserVar(playerHistoryID, "iCarriedHimLastTime", 0.0);
			if (aiGetScore(pid) > (2 * aiGetScore(cMyID)))
			{ // My ally carried me.
				//aiEcho("My ally carried me.");
				aiPersonalitySetPlayerUserVar(playerHistoryID, "heCarriedMeLastTime", 1.0);
			}
			else
				aiPersonalitySetPlayerUserVar(playerHistoryID, "heCarriedMeLastTime", 0.0);
		}
		else
		{
			aiPersonalitySetPlayerUserVar(playerHistoryID, "iCarriedHimLastTime", 0.0);
			aiPersonalitySetPlayerUserVar(playerHistoryID, "heCarriedMeLastTime", 0.0);
		}
	}
}

void learningMain()
{

}