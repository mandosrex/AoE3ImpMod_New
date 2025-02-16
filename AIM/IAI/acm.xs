//aiCommunication
//==============================================================================
// sendChatToAllies
// updatedOn 2020/10/15 By ageekhere
//==============================================================================
void sendChatToAllies(string text = "")
{ //send chat message to Allies
	debugRule("void sendChatToAllies " + text,0);
	for (i = 1; < cNumberPlayers)
	{ //loop through all players starting from player 1
		if ((i != cMyID) && (kbIsPlayerAlly(i) == true)) aiChat(i, text); //if the current player "i" is not me and is my Ally send chat 
	} //end for
} //end sendChatToAllies

//==============================================================================
/* sendStatement(player, commPromptID, vector)
	
	Sends a chat statement, but first checks the control variables and updates the
	"ok to chat" state.   This is a gateway for routine "ambience" personality chats.
	Another function will be written as a gateway for strategic communications, i.e.
	requests for defence, tribute, joint operations, etc.  That one will be controlled by 
	the cvOkToChat variable.
	
	If vector is not cInvalidVector, it will be added as a flare
*/
//==============================================================================
bool sendStatement(int playerIDorRelation = -1, int commPromptID = -1, vector vec = cInvalidVector)
{
	//aiEcho("<<<<<SEND STATEMENT to player "+playerIDorRelation+", commPromptID = "+commPromptID+", vector "+vec+">>>>>");
	// Routine "ambience" chats are not allowed
	if (cvOkToTaunt == false)
	{
		// Failed, no chat sent
		// Make sure the C++ side knows about it
		aiCommsAllowChat(false);
		return (false);
	}
//cAICommPromptToEnemyWhenIGatherNuggetSettlers
	// If we got this far, it's OK.
	aiCommsAllowChat(true);
	// It's a player ID, not a relation.
	if (playerIDorRelation < 100)
	{
		int playerID = playerIDorRelation;
		if (vec == cInvalidVector)
			aiCommsSendStatement(playerID, commPromptID);
		else
			aiCommsSendStatementWithVector(playerID, commPromptID, vec);
	}
	else // Then it's a player relation
	{
		int player = -1;
		for (player = 1; < cNumberPlayers)
		{
			bool send = false;
			switch (playerIDorRelation)
			{
				case cPlayerRelationAny:
					{
						send = true;
						break;
					}
				case cPlayerRelationSelf:
					{
						if (player == cMyID)
							send = true;
						break;
					}
				case cPlayerRelationAlly:
					{
						send = kbIsPlayerAlly(player);

						// Don't talk to myself, even though I am my ally.
						if (player == cMyID)
							send = false;
						break;
					}
				case cPlayerRelationEnemy:
					{
						send = kbIsPlayerEnemy(player);
						break;
					}
				case cPlayerRelationEnemyNotGaia:
					{
						send = kbIsPlayerEnemy(player);
						break;
					}
			}
			if (send == true)
			{				//aiEcho("<<<<<Sending chat prompt "+commPromptID+" to player "+player+" with vector "+vec+">>>>>");
				if (vec == cInvalidVector)
					aiCommsSendStatement(player, commPromptID);
				else
					aiCommsSendStatementWithVector(player, commPromptID, vec);
			}
		}
	}
	return (true);
}


//==============================================================================
// Plan Chat functions
//
//==============================================================================

// Set the attack plan to trigger a message and optional flare when the plan reaches the specified state.
// See the event handler below.
bool setPlanChat(int plan = -1, int state = -1, int prompt = -1, int player = -1, vector flare = cInvalidVector)
{

	// State -1 could be valid for action on plan termination
	if ((plan < 0) || (prompt < 0) || (player < 0))
		return (false);

	aiPlanSetEventHandler(plan, cPlanEventStateChange, "planStateEventHandler");

	aiPlanAddUserVariableInt(plan, 0, "Key State", 1);
	aiPlanAddUserVariableInt(plan, 1, "Prompt ID", 1);
	aiPlanAddUserVariableInt(plan, 2, "Send To", 1);
	aiPlanAddUserVariableVector(plan, 3, "Flare Vector", 1);

	aiPlanSetUserVariableInt(plan, 0, 0, state);
	aiPlanSetUserVariableInt(plan, 1, 0, prompt);
	aiPlanSetUserVariableInt(plan, 2, 0, player);
	aiPlanSetUserVariableVector(plan, 3, 0, flare);

	return (true);
}

void planStateEventHandler(int planID = -1)
{
	//aiEcho("    Plan "+aiPlanGetName(planID)+" is now in state "+aiPlanGetState(planID));

	// Plan planID has changed states.  Get its state, compare to target, issue chat if it matches
	int state = aiPlanGetUserVariableInt(planID, 0, 0);
	int prompt = aiPlanGetUserVariableInt(planID, 1, 0);
	int player = aiPlanGetUserVariableInt(planID, 2, 0);
	vector flare = aiPlanGetUserVariableVector(planID, 3, 0);

	if (aiPlanGetState(planID) == state)
	{
		// We have a winner, send the chat statement
		sendStatement(player, prompt, flare);
		//clearPlanChat(index);
	}
}

void tcPlacedEventHandler(int planID = -1)
{
	// Check the state of the TC build plan.
	// Fire an ally chat if the state is "build"
	if (aiPlanGetState(planID) == cPlanStateBuild)
	{
		vector loc = kbBuildingPlacementGetResultPosition(aiPlanGetVariableInt(planID, cBuildPlanBuildingPlacementID, 0));
		sendStatement(cPlayerRelationAlly, cAICommPromptToAllyIWillBuildTC, loc);
		//aiEcho("Sending TC placement chat at location "+loc);
	}
}

//==============================================================================
// rule lateInAge
//==============================================================================
extern int gLateInAgePlayerID = -1;
extern int gLateInAgeAge = -1;
rule lateInAge
minInterval 120
inactive
{
	// This rule is used to taunt a player who is behind in the age race, but only if
	// he is still in the previous age some time (see minInterval) after the other
	// players have all advanced.  Before activating this rule, the calling function
	// (ageUpHandler) must set the global variables for playerID and age, 
	// gLateInAgePlayerID and gLateInAgeAge.  When the rule finally fires minInterval 
	// seconds later, it checks to see if that player is still behind, and taunts accordingly.
	if (gLateInAgePlayerID < 0)
		return;

	if (kbGetAgeForPlayer(gLateInAgePlayerID) == gLateInAgeAge)
	{
		if (gLateInAgeAge == cAge1)
		{
			if ((kbIsPlayerAlly(gLateInAgePlayerID) == true) && (gLateInAgePlayerID != cMyID))
				sendStatement(gLateInAgePlayerID, cAICommPromptToAllyHeIsAge1Late);
			if ((kbIsPlayerEnemy(gLateInAgePlayerID) == true))
				sendStatement(gLateInAgePlayerID, cAICommPromptToEnemyHeIsAge1Late);
		}
		else
		{
			if ((kbIsPlayerAlly(gLateInAgePlayerID) == true) && (gLateInAgePlayerID != cMyID))
				sendStatement(gLateInAgePlayerID, cAICommPromptToAllyHeIsStillAgeBehind);
			if ((kbIsPlayerEnemy(gLateInAgePlayerID) == true))
				sendStatement(gLateInAgePlayerID, cAICommPromptToEnemyHeIsStillAgeBehind);
		}
	}
	gLateInAgePlayerID = -1;
	gLateInAgeAge = -1;
	xsDisableSelf();
}

void comMain()
{

}