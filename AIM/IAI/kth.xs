void KOTHVictoryStartHandler(int teamID = -1)
{
	int newOppID = -1;
	if (teamID < 0)
		return;
	gIsKOTHRunning = true;
	gKOTHTeam = teamID;
}

void KOTHVictoryEndHandler(int teamID = -1)
{
	if (teamID < 0)
		return;

	gIsKOTHRunning = false;
	gKOTHTeam = -1;
}