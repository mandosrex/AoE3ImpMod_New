//chat

/*
	chatHeGathersNugget()
	
	Called from the nugget event handler.  Given the player ID, determine what
	type of nugget was just claimed, and return a specific appropriate chat ID, if any.
	
	If none apply, return the general 'got nugget' chat ID.
*/
int chatHeGathersNugget(int playerID = -1)
{
	int retVal = cAICommPromptToEnemyWhenHeGathersNugget;
	int type = aiGetLastCollectedNuggetType(playerID);
	int effect = aiGetLastCollectedNuggetEffect(playerID);

	switch (type)
	{
		case cNuggetTypeAdjustResource:
			{
				switch (effect)
				{
					case cResourceGold:
						{
							retVal = cAICommPromptToEnemyWhenHeGathersNuggetCoin;
							break;
						}
					case cResourceFood:
						{
							retVal = cAICommPromptToEnemyWhenHeGathersNuggetFood;
							break;
						}
					case cResourceWood:
						{
							retVal = cAICommPromptToEnemyWhenHeGathersNuggetWood;
							break;
						}
				}
				break;
			}
		case cNuggetTypeSpawnUnit:
			{
				if ((effect == cUnitTypeNatMedicineMan) || (effect == cUnitTypeNatClubman) || (effect == cUnitTypeNatRifleman) || (effect == cUnitTypeNatHuaminca) || (effect == cUnitTypeNatTomahawk) || (effect == cUnitTypeNativeScout) || (effect == cUnitTypeNatEagleWarrior))
				{
					retVal = cAICommPromptToEnemyWhenHeGathersNuggetNatives;
				}
				if ((effect == cUnitTypeSettler) || (effect == cUnitTypeCoureur) || (effect == cUnitTypeSettlerNative) || (effect == cUnitTypeSettlerDutch) || (effect == cUnitTypeSettlerOttoman) || (effect == cUnitTypeypSettlerAsian) || (effect == cUnitTypeypSettlerIndian))
					retVal = cAICommPromptToEnemyWhenHeGathersNuggetSettlers;
				break;
			}
		case cNuggetTypeGiveLOS:
			{
				break;
			}
		case cNuggetTypeAdjustSpeed:
			{
				break;
			}
		case cNuggetTypeAdjustHP:
			{
				break;
			}
		case cNuggetTypeConvertUnit:
			{
				if ((effect == cUnitTypeNatMedicineMan) || (effect == cUnitTypeNatClubman) || (effect == cUnitTypeNatRifleman) || (effect == cUnitTypeNatHuaminca) || (effect == cUnitTypeNatTomahawk) || (effect == cUnitTypeNativeScout) || (effect == cUnitTypeNatEagleWarrior))
				{
					retVal = cAICommPromptToEnemyWhenHeGathersNuggetNatives;
				}
				if ((effect == cUnitTypeSettler) || (effect == cUnitTypeCoureur) || (effect == cUnitTypeSettlerNative) || (effect == cUnitTypeSettlerDutch) || (effect == cUnitTypeSettlerOttoman) || (effect == cUnitTypeypSettlerAsian) || (effect == cUnitTypeypSettlerIndian))
					retVal = cAICommPromptToEnemyWhenHeGathersNuggetSettlers;
				break;
			}
	}


	return (retVal);
}

//==============================================================================
// nuggetHandler
//==============================================================================
void nuggetHandler(int playerID = -1)
{
	//return;
	if (gCurrentAge > cAge2)
		return; // Do not send these chats (or even bother keeping count) after age 2 ends.
	//aiEcho("***************** Nugget handler running with playerID"+playerID);   
	static int nuggetCounts = -1; // Array handle.  nuggetCounts[i] will track how many nuggets each player has claimed
	static int totalNuggets = 0;
	const int cNuggetRange = 100; // Nuggets within this many meters of a TC are "owned".
	int defaultChatID = chatHeGathersNugget(playerID);

	if ((playerID < 1) || (playerID > cNumberPlayers))
		return;

	// Initialize the array if we haven't done this before.
	if (nuggetCounts < 0)
	{
		nuggetCounts = xsArrayCreateInt(cNumberPlayers, 0, "Nugget Counts");
	}

	// Score this nugget
	totalNuggets = totalNuggets + 1;
	xsArraySetInt(nuggetCounts, playerID, xsArrayGetInt(nuggetCounts, playerID) + 1);

	// Check to see if one of the special-case chats might be appropriate.
	// If so, use it, otherwise, fall through to the generic ones.
	// First, some bookkeeping
	int i = 0;
	int count = 0;
	int lowestPlayer = -1;
	int lowestCount = 100000; // Insanely high start value, first pass will reset it.
	int totalCount = 0;
	int averageCount = 0;
	int highestPlayer = -1;
	int highestCount = 0;
	for (i = 1; < cNumberPlayers)
	{
		count = xsArrayGetInt(nuggetCounts, i, ); // How many nuggets has player i gathered?
		if (count < lowestCount)
		{
			lowestCount = count;
			lowestPlayer = i;
		}
		if (count > highestCount)
		{
			highestCount = count;
			highestPlayer = i;
		}
		totalCount = totalCount + count;
	}
	averageCount = totalCount / (cNumberPlayers - 1);

	if (totalCount == 1) // This is the first nugget in the game
	{
		if (playerID != cMyID)
		{
			if (kbIsPlayerAlly(playerID) == true)
			{
				sendStatement(playerID, cAICommPromptToAllyWhenHeGathersFirstNugget);
				return;
			}
			else
			{
				sendStatement(playerID, cAICommPromptToEnemyWhenHeGathersFirstNugget);
				return;
			}
		}
	}

	int playersCount = 0;
	int myCount = 0;
	myCount = xsArrayGetInt(nuggetCounts, cMyID);
	playersCount = xsArrayGetInt(nuggetCounts, playerID);
	// Check if this player is way ahead of me, i.e. 2x my total and ahead by at least 2
	if (((playersCount - myCount) >= 2) && (playersCount >= (myCount * 2)))
	{
		if (kbIsPlayerAlly(playerID) == true)
		{
			sendStatement(playerID, cAICommPromptToAllyWhenHeGathersNuggetHeIsAhead);
			return;
		}
		else
		{
			sendStatement(playerID, cAICommPromptToEnemyWhenHeGathersNuggetHeIsAhead);
			return;
		}
	}

	// Check if I'm way ahead of any other players
	int player = 0; // Loop counter...who might I send a message to
	bool messageSent = false;
	if (playerID == cMyID)
	{
		for (player = 1; < cNumberPlayers)
		{
			playersCount = xsArrayGetInt(nuggetCounts, player);
			if (((myCount - playersCount) >= 2) && (myCount >= (playersCount * 2)))
			{
				if (kbIsPlayerAlly(player) == true)
				{
					sendStatement(player, cAICommPromptToAllyWhenIGatherNuggetIAmAhead);
					messageSent = true;
				}
				else
				{
					sendStatement(player, cAICommPromptToEnemyWhenIGatherNuggetIAmAhead);
					messageSent = true;
				}
			}
		}
	}
	if (messageSent == true)
		return;

	// Check to see if the nugget was gathered near a main base.  
	// For now, check playerID's explorer location, assume nugget was gathered there.
	// Later, we may add location info to the event handler.
	vector explorerPos = cInvalidVector;
	int explorerID = -1;
	int tcID = -1;

	explorerID = getUnit(gExplorerUnit, playerID, cUnitStateAlive);
	if (explorerID < 0) explorerID = getUnit(gExplorerUnit2, playerID, cUnitStateAlive);

	if (explorerID < 0)
		explorerID = getUnit(cUnitTypexpAztecWarchief, playerID, cUnitStateAlive);
	if (explorerID < 0)
		explorerID = getUnit(cUnitTypexpIroquoisWarChief, playerID, cUnitStateAlive);
	if (explorerID < 0)
		explorerID = getUnit(cUnitTypexpLakotaWarchief, playerID, cUnitStateAlive);
	if (explorerID < 0)
		explorerID = getUnit(cUnitTypeypMonkChinese, playerID, cUnitStateAlive);
	if (explorerID < 0)
		explorerID = getUnit(cUnitTypeypMonkIndian, playerID, cUnitStateAlive);
	if (explorerID < 0)
		explorerID = getUnit(cUnitTypeypMonkIndian2, playerID, cUnitStateAlive);
	if (explorerID < 0)
		explorerID = getUnit(cUnitTypeypMonkJapanese, playerID, cUnitStateAlive);
	if (explorerID < 0)
		explorerID = getUnit(cUnitTypeypMonkJapanese2, playerID, cUnitStateAlive);
	if (explorerID >= 0) // We know of an explorer, war chief or Asian monk for this player
	{
		if (kbUnitVisible(explorerID) == true)
		{ // And we can see him.
			explorerPos = kbUnitGetPosition(explorerID);
			if (playerID == cMyID)
			{ // I gathered the nugget
				// Get nearest ally TC distance
				tcID = getUnitByLocation(gTownCenter, cPlayerRelationAlly, cUnitStateAlive, explorerPos, cNuggetRange);
				if ((tcID > 0) && (kbUnitGetPlayerID(tcID) != cMyID))
				{ // A TC is near, owned by an ally, and it's not mine...
					sendStatement(kbUnitGetPlayerID(tcID), cAICommPromptToAllyWhenIGatherNuggetHisBase); // I got a nugget near his TC
					return;
				}
				// Get nearest enemy TC distance
				tcID = getUnitByLocation(gTownCenter, cPlayerRelationEnemy, cUnitStateAlive, explorerPos, cNuggetRange);
				if (tcID > 0)
				{ // A TC is near, owned by an enemy...
					sendStatement(kbUnitGetPlayerID(tcID), cAICommPromptToEnemyWhenIGatherNuggetHisBase); // I got a nugget near his TC
					return;
				}
			}
			else
			{
				if (kbIsPlayerAlly(playerID) == true)
				{ // An ally has found a nugget, see if it's close to my TC
					tcID = getUnitByLocation(gTownCenter, cMyID, cUnitStateAlive, explorerPos, cNuggetRange);
					if (tcID > 0)
					{ // That jerk took my nugget!
						sendStatement(playerID, cAICommPromptToAllyWhenHeGathersNuggetMyBase); // He got one in my zone
						return;
					}
				}
				else
				{ // An enemy has found a nugget, see if it's in my zone
					tcID = getUnitByLocation(gTownCenter, cMyID, cUnitStateAlive, explorerPos, cNuggetRange);
					if (tcID > 0)
					{ // That jerk took my nugget!
						sendStatement(playerID, cAICommPromptToEnemyWhenHeGathersNuggetMyBase); // He got one in my zone
						return;
					}
				}
			} // if me else
		} // If explorer is visible to me
	} // If explorer known

	// No special events fired, so go with generic messages
	// defaultChatID has the appropriate chat if an enemy gathered the nugget...send it.
	// Otherwise, convert to the appropriate case.
	if (playerID != cMyID)
	{
		if (kbIsPlayerEnemy(playerID) == true)
		{
			sendStatement(playerID, defaultChatID);
		}
		else
		{ // Find out what was returned, send the equivalent ally version
			switch (defaultChatID)
			{
				case cAICommPromptToEnemyWhenHeGathersNugget:
					{
						sendStatement(playerID, cAICommPromptToAllyWhenHeGathersNugget);
						break;
					}
				case cAICommPromptToEnemyWhenHeGathersNuggetCoin:
					{
						sendStatement(playerID, cAICommPromptToAllyWhenHeGathersNuggetCoin);
						break;
					}
				case cAICommPromptToEnemyWhenHeGathersNuggetFood:
					{
						sendStatement(playerID, cAICommPromptToAllyWhenHeGathersNuggetFood);
						break;
					}
				case cAICommPromptToEnemyWhenHeGathersNuggetWood:
					{
						sendStatement(playerID, cAICommPromptToAllyWhenHeGathersNuggetWood);
						break;
					}
				case cAICommPromptToEnemyWhenHeGathersNuggetNatives:
					{
						sendStatement(playerID, cAICommPromptToAllyWhenHeGathersNuggetNatives);
						break;
					}
				case cAICommPromptToEnemyWhenHeGathersNuggetSettlers:
					{
						sendStatement(playerID, cAICommPromptToAllyWhenHeGathersNuggetSettlers);
						break;
					}
			}
		}
	}
	else
	{
		//-- I gathered the nugget.  Figure out what kind it is based on the defaultChatID enemy version.
		// Substitute appropriate ally and enemy chats.
		switch (defaultChatID)
		{
			case cAICommPromptToEnemyWhenHeGathersNugget:
				{
					sendStatement(cPlayerRelationAlly, cAICommPromptToAllyWhenIGatherNugget);
					sendStatement(cPlayerRelationEnemy, cAICommPromptToEnemyWhenIGatherNugget);
					break;
				}
			case cAICommPromptToEnemyWhenHeGathersNuggetCoin:
				{
					sendStatement(cPlayerRelationAlly, cAICommPromptToAllyWhenIGatherNuggetCoin);
					sendStatement(cPlayerRelationEnemy, cAICommPromptToEnemyWhenIGatherNuggetCoin);
					break;
				}
			case cAICommPromptToEnemyWhenHeGathersNuggetFood:
				{
					sendStatement(cPlayerRelationAlly, cAICommPromptToAllyWhenIGatherNuggetFood);
					sendStatement(cPlayerRelationEnemy, cAICommPromptToEnemyWhenIGatherNuggetFood);
					break;
				}
			case cAICommPromptToEnemyWhenHeGathersNuggetWood:
				{
					sendStatement(cPlayerRelationAlly, cAICommPromptToAllyWhenIGatherNuggetWood);
					sendStatement(cPlayerRelationEnemy, cAICommPromptToEnemyWhenIGatherNuggetWood);
					break;
				}
			case cAICommPromptToEnemyWhenHeGathersNuggetNatives:
				{
					sendStatement(cPlayerRelationAlly, cAICommPromptToAllyWhenIGatherNuggetNatives);
					sendStatement(cPlayerRelationEnemy, cAICommPromptToEnemyWhenIGatherNuggetNatives);
					break;
				}
			case cAICommPromptToEnemyWhenHeGathersNuggetSettlers:
				{
					sendStatement(cPlayerRelationAlly, cAICommPromptToAllyWhenIGatherNuggetSettlers);
					sendStatement(cPlayerRelationEnemy, cAICommPromptToEnemyWhenIGatherNuggetSettlers);
					break;
				}
		}
	}

	return;
}


//==============================================================================
// commHandler
//==============================================================================
void commHandler(int chatID = -1)
{
	// Set up our parameters in a convenient format...
	int fromID = aiCommsGetSendingPlayer(chatID); // Which player sent this?
	int verb = aiCommsGetChatVerb(chatID); // Verb, like cPlayerChatVerbAttack or cPlayerChatVerbDefend
	int targetType = aiCommsGetChatTargetType(chatID); // Target type, like cPlayerChatTargetTypePlayers or cPlayerChatTargetTypeLocation
	int targetCount = aiCommsGetTargetListCount(chatID); // How many targets?
	static int targets = -1; // Array handle for target array.
	vector location = aiCommsGetTargetLocation(chatID); // Target location
	int firstTarget = -1;
	static int targetList = -1;
	int opportunitySource = cOpportunitySourceAllyRequest; // Assume it's from a player unless we find out it's player 0, Gaia, indicating a trigger
	int newOppID = -1;

	if (fromID == 0) // Gaia sent this 
		opportunitySource = cOpportunitySourceTrigger;

	if (fromID == cMyID)
		return; // DO NOT react to echoes of my own commands/requests.

	if ((kbIsPlayerEnemy(fromID) == true) && (fromID != 0))
		return; // DO NOT accept messages from enemies.

	if (targets < 0)
	{
		//aiEcho("Creating comm handler target array.");
		targets = xsArrayCreateInt(30, -1, "Chat targets");
		//aiEcho("Create array int returns "+targets);
	}

	// Clear, then fill targets array
	int i = 0;
	for (i = 0; < 30)
		xsArraySetInt(targets, i, -1);

	if (targetCount > 30)
		targetCount = 30; // Stay within array bounds
	for (i = 0; < targetCount)
		xsArraySetInt(targets, i, aiCommsGetTargetListItem(chatID, i));

	if (targetCount > 0)
		firstTarget = xsArrayGetInt(targets, 0);

	// Spew
	//aiEcho(" ");
	//aiEcho(" ");
	//aiEcho("***** Incoming communication *****");
	//aiEcho("From: "+fromID+",  verb: "+verb+",  targetType: "+targetType+",  targetCount: "+targetCount);
	//for (i=0; <targetCount)
	//aiEcho("        "+xsArrayGetInt(targets, i));
	//aiEcho("Vector: "+location);
	//aiEcho(" ");
	//aiEcho("***** End of communication *****");

	switch (verb) // Parse this message starting with the verb
	{
		case cPlayerChatVerbAttack:
			{ // "Attack" from an ally player could mean attack enemy base, defend my base, or claim empty VP Site.  
				// Attack from a trigger means attack unit list.
				// Permission checks need to be done inside the inner switch statement, as cvOkToAttack only affects true attack commands.
				int militaryAvail = unitCountFromCancelledMission(opportunitySource);
				int reserveAvail = aiPlanGetNumberUnits(gLandReservePlan, cUnitTypeLogicalTypeLandMilitary);
				int totalAvail = militaryAvail + reserveAvail;
				//aiEcho("Plan units available: "+militaryAvail+", reserve ="+reserveAvail+", good army size is "+gGoodArmyPop); 
				if (opportunitySource == cOpportunitySourceAllyRequest)
				{ // Don't mess with triggers this late in development
					if (totalAvail < 3)
					{
						//aiEcho("Sorry, no units available.");
						// chat "no units" and bail
						sendStatement(fromID, cAICommPromptToAllyDeclineNoArmy);
						return;
					}
					if (aiTreatyActive() == true)
					{
						//aiEcho("Can't attack under treaty.");
						sendStatement(fromID, cAICommPromptToAllyDeclineProhibited);
						return;
					}
					else
					{
						if (totalAvail < (gGoodArmyPop / 2))
						{
							//aiEcho("Sorry, not enough units.");
							// chat "not enough army units" and bail
							sendStatement(fromID, cAICommPromptToAllyDeclineSmallArmy);
							return;
						}
					}
					// If we get here, it's not a trigger, but we do have enough units to go ahead.
					// See if cancelling an active mission is really necessary.
					if ((reserveAvail > gGoodArmyPop) || (gMissionToCancel < 0))
					{
						aiEcho("Plenty in reserve, no need to cancel...or no mission to cancel.");
					}
					else
					{
						//aiEcho("Not enough military units, need to destroy mission "+gMissionToCancel);
						aiPlanDestroy(gMissionToCancel); // Cancel the active mission.
					}
				}
				switch (targetType)
				{
					case cPlayerChatTargetTypeLocation:
						{
							//-- Figure out what is in the this area, and do the correct thing.
							//-- Find nearest base and vpSite, and attack/defend/claim as appropriate.
							int closestBaseID = kbFindClosestBase(cPlayerRelationAny, location); // If base is ally, attack point/radius to help out
							int closestVPSite = getClosestVPSite(location, cVPAll, cVPStateAny, -1);

							if ((closestVPSite >= 0) && (distance(location, kbVPSiteGetLocation(closestVPSite)) < 20.0))
							{ // Near a VP site...this is a claim opportunity
								newOppID = createOpportunity(cOpportunityTypeClaim, cOpportunityTargetTypeVPSite, closestVPSite, -1, opportunitySource);
								sendStatement(fromID, cAICommPromptToAllyConfirm);
								aiActivateOpportunity(newOppID, true);
								break; // We've created an Opp, we're done.
							}
							if ((closestBaseID != -1) && (distance(location, kbBaseGetLocation(kbBaseGetOwner(closestBaseID), closestBaseID)) < 50.0))
							{ // Command is inside a base.  If enemy, base attack.  If ally, point/radius attack.
								if (kbIsPlayerAlly(kbBaseGetOwner(closestBaseID)) == false)
								{ // This is an enemy base, create a base attack opportunity
									if ((cvOkToAttack == false) && (opportunitySource == cOpportunitySourceAllyRequest)) // Attacks prohibited unless it's a trigger
									{
										// bail out, we're not allowed to do this.
										sendStatement(fromID, cAICommPromptToAllyDeclineProhibited);
										//aiEcho("ERROR:  We're not allowed to attack.");
										return ();
										break;
									}
									newOppID = createOpportunity(cOpportunityTypeDestroy, cOpportunityTargetTypeBase, closestBaseID, kbBaseGetOwner(closestBaseID), opportunitySource);
									sendStatement(fromID, cAICommPromptToAllyConfirm, kbBaseGetLocation(kbBaseGetOwner(closestBaseID), closestBaseID));
								}
								else
								{ // Ally base, so do attack point/radius here.
									newOppID = createOpportunity(cOpportunityTypeDefend, cOpportunityTargetTypeBase, closestBaseID, kbBaseGetOwner(closestBaseID), opportunitySource);
									aiSetOpportunityLocation(newOppID, kbBaseGetLocation(kbBaseGetOwner(closestBaseID), closestBaseID));
									aiSetOpportunityRadius(newOppID, 50.0);
									sendStatement(fromID, cAICommPromptToAllyIWillHelpDefend, location);
									//createOpportunity(int type, int targettype, int targetID, int targetPlayerID, int source ): 
								}
								aiActivateOpportunity(newOppID, true);
								break; // We've created an Opp, we're done.
							}

							// If we're here, it's not a VP site, and not an enemy or ally base - basically open map.
							// Create a point/radius destroy opportunity.
							newOppID = createOpportunity(cOpportunityTypeDestroy, cOpportunityTargetTypePointRadius, -1, chooseAttackPlayerID(location, 50.0), opportunitySource);
							aiSetOpportunityLocation(newOppID, location);
							aiSetOpportunityRadius(newOppID, 50.0);
							aiActivateOpportunity(newOppID, true);
							sendStatement(fromID, cAICommPromptToAllyConfirm);
							break;
						} // case targetType location
					case cPlayerChatTargetTypeUnits:
						{ // This is a trigger command to attack a unit list.
							newOppID = createOpportunity(cOpportunityTypeDestroy, cOpportunityTargetTypeUnitList, targets, chooseAttackPlayerID(location, 50.0), opportunitySource);
							aiSetOpportunityLocation(newOppID, location);
							aiSetOpportunityRadius(newOppID, 50.0);
							aiActivateOpportunity(newOppID, true);
							sendStatement(fromID, cAICommPromptToAllyConfirm);
							break;
						}
					default:
						{ // Not recognized
							sendStatement(fromID, cAICommPromptToAllyDeclineGeneral);
							//aiEcho("ERROR!  Target type "+targetType+" not recognized.");
							return (); // Don't risk sending another chat...
							break;
						}
				} // end switch targetType
				break;
			} // end verb attack

		case cPlayerChatVerbTribute:
			{
				if (opportunitySource == cOpportunitySourceAllyRequest)
				{
					//aiEcho("    Command was to tribute to player "+fromID+".  Resource list:");
					bool alreadyChatted = false;
					for (i = 0; < targetCount)
					{
						float amountAvailable = 0.0;
						if (xsArrayGetInt(targets, i) == cResourceGold)
						{
							kbEscrowFlush(cEconomyEscrowID, cResourceGold, false);
							kbEscrowFlush(cMilitaryEscrowID, cResourceGold, false);
							amountAvailable = kbEscrowGetAmount(cRootEscrowID, cResourceGold) * .85; // Leave room for tribute penalty
							if (aiResourceIsLocked(cResourceGold) == true)
								amountAvailable = 0.0;
							if ((amountAvailable > 100.0) && (gCurrentAge >= cAge2))
							{ // We will tribute something
								if (alreadyChatted == false)
								{
									sendStatement(fromID, cAICommPromptToAllyITributedCoin);
									alreadyChatted = true;
								}
								gLastTribSentTime = gCurrentGameTime;
								if (amountAvailable > 1000.0)
									amountAvailable = 1000;
								if (amountAvailable > 200.0)
									aiTribute(fromID, cResourceGold, amountAvailable / 2);
								else
									aiTribute(fromID, cResourceGold, 100.0);
							}
							else
							{
								if (alreadyChatted == false)
								{
									sendStatement(fromID, cAICommPromptToAllyDeclineCantAfford);
									alreadyChatted = true;
								}
							}
							//aiEcho("        Tribute gold");
						}
						if (xsArrayGetInt(targets, i) == cResourceFood)
						{
							kbEscrowFlush(cEconomyEscrowID, cResourceFood, false);
							kbEscrowFlush(cMilitaryEscrowID, cResourceFood, false);
							amountAvailable = kbEscrowGetAmount(cRootEscrowID, cResourceFood) * .85; // Leave room for tribute penalty
							if (aiResourceIsLocked(cResourceFood) == true)
								amountAvailable = 0.0;
							if ((amountAvailable > 100.0) && (gCurrentAge >= cAge2))
							{ // We will tribute something
								if (alreadyChatted == false)
								{
									sendStatement(fromID, cAICommPromptToAllyITributedFood);
									alreadyChatted = true;
								}
								gLastTribSentTime = gCurrentGameTime;
								if (amountAvailable > 1000.0)
									amountAvailable = 1000;
								if (amountAvailable > 200.0)
									aiTribute(fromID, cResourceFood, amountAvailable / 2);
								else
									aiTribute(fromID, cResourceFood, 100.0);
							}
							else
							{
								if (alreadyChatted == false)
								{
									sendStatement(fromID, cAICommPromptToAllyDeclineCantAfford);
									alreadyChatted = true;
								}
							}
							//aiEcho("        Tribute food");
						}
						if (xsArrayGetInt(targets, i) == cResourceWood)
						{
							kbEscrowFlush(cEconomyEscrowID, cResourceWood, false);
							kbEscrowFlush(cMilitaryEscrowID, cResourceWood, false);
							amountAvailable = kbEscrowGetAmount(cRootEscrowID, cResourceWood) * .85; // Leave room for tribute penalty
							if (aiResourceIsLocked(cResourceWood) == true)
								amountAvailable = 0.0;
							if ((amountAvailable > 100.0) && (gCurrentAge >= cAge2))
							{ // We will tribute something
								if (alreadyChatted == false)
								{
									sendStatement(fromID, cAICommPromptToAllyITributedWood);
									alreadyChatted = true;
								}
								gLastTribSentTime = gCurrentGameTime;
								if (amountAvailable > 1000.0)
									amountAvailable = 1000;
								if (amountAvailable > 200.0)
									aiTribute(fromID, cResourceWood, amountAvailable / 2);
								else
									aiTribute(fromID, cResourceWood, 100.0);
								kbEscrowAllocateCurrentResources();
							}
							else
							{
								if (alreadyChatted == false)
								{
									sendStatement(fromID, cAICommPromptToAllyDeclineCantAfford);
									alreadyChatted = true;
								}
							}
							//aiEcho("        Tribute wood");
						}
					}
				} // end source allyRequest
				else
				{ // Tribute trigger...send it to player 1
					//aiEcho("    Command was a trigger to tribute to player 1.  Resource list:");
					for (i = 0; <= 2) // Target[x] is the amount of resource type X to send
					{
						float avail = kbEscrowGetAmount(cRootEscrowID, i) * .85;
						int qty = xsArrayGetInt(targets, i);
						if (qty > 0)
						{
							//aiEcho("        Resource # "+i+", amount: "+qty+" requested.");
							if (avail >= qty) // we can afford it
							{
								aiTribute(1, i, qty);
								//aiEcho("            Sending full amount.");
							}
							else
							{
								aiTribute(1, i, avail); // Can't afford it, send what we have.
								//aiEcho("            Sending all I have, "+avail+".");
							}
						}
					}
				}
				break;
			} // End verb tribute

		case cPlayerChatVerbFeed: // Ongoing tribute.  Once a minute, send whatever you have in root.
			{
				//aiEcho("    Command was to feed resources to a player.");
				alreadyChatted = false;
				for (i = 0; < targetCount)
				{
					switch (xsArrayGetInt(targets, i))
					{
						case cResourceGold:
							{
								gFeedGoldTo = fromID;
								if (xsIsRuleEnabled("monitorFeeding") == false)
								{
									xsEnableRule("monitorFeeding");
									monitorFeeding();
								}
								if (alreadyChatted == false)
								{
									sendStatement(fromID, cAICommPromptToAllyIWillFeedCoin);
									alreadyChatted = true;
								}
								break;
							}
						case cResourceWood:
							{
								gFeedWoodTo = fromID;
								if (xsIsRuleEnabled("monitorFeeding") == false)
								{
									xsEnableRule("monitorFeeding");
									monitorFeeding();
								}
								if (alreadyChatted == false)
								{
									sendStatement(fromID, cAICommPromptToAllyIWillFeedWood);
									alreadyChatted = true;
								}
								break;
							}
						case cResourceFood:
							{
								gFeedFoodTo = fromID;
								if (xsIsRuleEnabled("monitorFeeding") == false)
								{
									xsEnableRule("monitorFeeding");
									monitorFeeding();
								}
								if (alreadyChatted == false)
								{
									sendStatement(fromID, cAICommPromptToAllyIWillFeedFood);
									alreadyChatted = true;
								}
								break;
							}
					}
				}
				break;
			} // End verb feed

		case cPlayerChatVerbTrain:
			{
				//aiEcho("    Command was to train units starting with "+firstTarget+", unit type "+kbGetProtoUnitName(firstTarget));
				// See if we have authority to change the settings
				bool okToChange = false;
				if (opportunitySource == cOpportunitySourceTrigger)
					okToChange = true; // Triggers always rule
				if (opportunitySource == cOpportunitySourceAllyRequest)
				{
					if ((gUnitPickSource == cOpportunitySourceAllyRequest) || (gUnitPickSource == cOpportunitySourceAutoGenerated))
						okToChange = true;
				}
				if (okToChange == true)
				{
					//aiEcho("    Permission granted, changing units.");
					gUnitPickSource = opportunitySource; // Record who made this change
					gUnitPickPlayerID = fromID;

					cvPrimaryArmyUnit = firstTarget;
					cvSecondaryArmyUnit = -1;
					//aiEcho("        Primary unit is "+firstTarget+" "+kbGetProtoUnitName(firstTarget));
					setUnitPickerPreference(gLandUnitPicker);

					if (gUnitPickSource == cOpportunitySourceAllyRequest)
						sendStatement(fromID, cAICommPromptToAllyConfirm);
				}
				else
				{
					sendStatement(fromID, cAICommPromptToAllyDeclineProhibited);
					//aiEcho("    Cannot override existing settings.");
				}
				break;
			}
		case cPlayerChatVerbDefend:
			{ // Currently, defend is only available via the aiCommsDefend trigger, it is not in the UI.
				// An "implicit" defend can be done when a human player issues an attack command on a location
				// that does not have enemy units nearby.  
				// Currently, all defend verbs will be point/radius
				newOppID = createOpportunity(cOpportunityTypeDefend, cOpportunityTargetTypePointRadius, -1, chooseAttackPlayerID(location, 50.0), opportunitySource);
				aiSetOpportunityLocation(newOppID, location);
				aiSetOpportunityRadius(newOppID, 50.0);
				aiActivateOpportunity(newOppID, true);
				break;
			}
		case cPlayerChatVerbClaim:
			{ // Available only from trigger, sends a vector.  Humans can send implicit claim commands
				// by sending "attack" with a point that is near an unclaimed VP site.
				closestVPSite = getClosestVPSite(location, cVPAll, cVPStateAny, -1);
				bool permitted = true;
				if ((cvOkToClaimTrade == false) && (kbVPSiteGetType(closestVPSite) == cVPTrade))
					permitted = false;
				if ((cvOkToAllyNatives == false) && (kbVPSiteGetType(closestVPSite) == cVPNative))
					permitted = false;

				if (permitted = false)
				{
					sendStatement(fromID, cAICommPromptToAllyDeclineProhibited);
					//aiEcho("    Not allowed to claim this type of site.");            
				}
				else
				{
					newOppID = createOpportunity(cOpportunityTypeClaim, cOpportunityTargetTypeVPSite, closestVPSite, -1, opportunitySource);
					aiActivateOpportunity(newOppID, true);
				}
				break;
			}
		case cPlayerChatVerbStrategy:
			{
				if (xsArrayGetInt(targets, 0) == cPlayerChatTargetStrategyRush)
				{
					btRushBoom = 1.0;
					//xsEnableRule("turtleUp");
					gPrevNumTowers = gNumTowers;
					gNumTowers = 0;
				}
				else if (xsArrayGetInt(targets, 0) == cPlayerChatTargetStrategyBoom)
				{
					btRushBoom = -1.0;
				}
				else if (xsArrayGetInt(targets, 0) == cPlayerChatTargetStrategyTurtle)
				{

					btOffenseDefense = -1.0;
					//xsEnableRule("turtleUp");
					gPrevNumTowers = gNumTowers;
					if (getCivIsAsian() == false)
					{
						gNumTowers = 7;
					}
					else
					{
						gNumTowers = 5;
					}
				}
				sendStatement(fromID, cAICommPromptToAllyConfirm);
				break;
			}
		case cPlayerChatVerbCancel:
			{
				// Clear training (unit line bias) settings
				if ((gUnitPickSource == cOpportunitySourceAllyRequest) || (opportunitySource == cOpportunitySourceTrigger))
				{ // We have an ally-generated unit line choice, destroy it
					gUnitPickSource = cOpportunitySourceAutoGenerated;
					gUnitPickPlayerID = -1;
					cvPrimaryArmyUnit = -1;
					cvSecondaryArmyUnit = -1;
					setUnitPickerPreference(gLandUnitPicker);
				}

				// Clear Feeding (ongoing tribute) settings
				gFeedGoldTo = -1;
				gFeedWoodTo = -1;
				gFeedFoodTo = -1;

				// Cancel any active attack, defend or claim missions from allies or triggers
				if ((opportunitySource == cOpportunitySourceTrigger) || (opportunitySource == cOpportunitySourceAllyRequest))
				{
					if (gMostRecentAllyOpportunityID >= 0)
					{
						aiDestroyOpportunity(gMostRecentAllyOpportunityID);
						//aiEcho("Destroying opportunity "+gMostRecentAllyOpportunityID+" because of cancel command.");
						gMostRecentAllyOpportunityID = -1;
					}
				}
				if (opportunitySource == cOpportunitySourceTrigger)
				{
					if (gMostRecentTriggerOpportunityID >= 0)
					{
						aiDestroyOpportunity(gMostRecentTriggerOpportunityID);
						//aiEcho("Destroying opportunity "+gMostRecentTriggerOpportunityID+" because of cancel command.");
						gMostRecentTriggerOpportunityID = -1;
					}
					// Also, a trigger cancel must kill any active auto-generated attack or defend plans
					int numPlans = aiPlanGetNumber(cPlanMission, -1, true);
					int index = 0;
					int plan = -1;
					int planOpp = -1;
					for (index = 0; < numPlans)
					{
						plan = aiPlanGetIDByIndex(cPlanMission, -1, true, index);
						planOpp = aiPlanGetVariableInt(plan, cMissionPlanOpportunityID, 0);
						if (planOpp >= 0)
						{
							if (aiGetOpportunitySourceType(planOpp) == cOpportunitySourceAutoGenerated)
							{
								//aiEcho("--------DESTROYING MISSION "+plan+" "+aiPlanGetName(plan));
								aiPlanDestroy(plan);
							}
						}
					}
				}
				// Reset number of towers
				if (gPrevNumTowers >= 0)
					gNumTowers = gPrevNumTowers;
				break;
			}
		default:
			{
				//aiEcho("    Command verb not found, verb value is: "+verb);
				break;
			}
	}
	//aiEcho("********************************************");   
}


//==============================================================================
// Personality and chats
//==============================================================================
rule introChat // Send a greeting to allies and enemies
inactive
group startup
minInterval 10
{
	xsDisableSelf();
	sendStatement(cPlayerRelationAlly, cAICommPromptToAllyIntro);
	sendStatement(cPlayerRelationEnemy, cAICommPromptToEnemyIntro);
}
rule IKnowWhereYouLive // Send a menacing chat when we discover the enemy player's location
inactive
group startup
minInterval 5
{
	if (gCurrentGameTime < 300000) return;
	static int targetPlayer = -1;

	if (targetPlayer < 0)
	{
		targetPlayer = getEnemyPlayerByTeamPosition(getTeamPosition(cMyID)); // Corresponding player on other team
		if (targetPlayer < 0)
		{
			xsDisableSelf();
			//aiEcho("No corresponding player on other team, IKnowWhereYouLive is deactivating.");
			//aiEcho("    My team position is "+getTeamPosition(cMyID));
			return;
		}
		//aiEcho("Rule IKnowWhereYouLive will threaten player #"+targetPlayer); 
	}

	if (kbUnitCount(targetPlayer, gTownCenter, cUnitStateAlive) > 0)
	{ // We see his TC for the first time
		int tc = getUnit(gTownCenter, targetPlayer, cUnitStateAlive);
		if (tc >= 0)
		{
			if (getUnitByLocation(cUnitTypeUnit, cMyID, cUnitStateAlive, kbUnitGetPosition(tc), 50.0) >= 0)
			{ // I have a unit nearby, presumably I have LOS.
				sendStatement(targetPlayer, cAICommPromptToEnemyISpotHisTC, kbUnitGetPosition(tc));
				//aiEcho("Rule IKnowWhereYouLive is threatening player #"+targetPlayer);
			}
		}
		xsDisableSelf();
	}
}

rule tcChats
inactive
group tcComplete
minInterval 10
{ // Send chats about enemy TC placement
	static int tcID1 = -1; // First enemy TC
	static int tcID2 = -1; // Second
	static int enemy1 = -1; // ID of owner of first enemy TC.
	static int enemy2 = -1; // Second.
	static int secondTCQuery = -1;

	if (tcID1 < 0)
	{ // Look for first enemy TC
		tcID1 = getUnit(gTownCenter, cPlayerRelationEnemy, cUnitStateAlive);
		if (tcID1 >= 0)
			enemy1 = kbUnitGetPlayerID(tcID1);
		return; // Done for now
	}

	// If we get here, we already know about one enemy TC.  Now, find the next closest enemy TC.
	if (secondTCQuery == -1) 
	{
		secondTCQuery = kbUnitQueryCreate("Second enemy TC"+ getQueryId());
		kbUnitQuerySetPlayerID(secondTCQuery,-1,false);
		kbUnitQuerySetPlayerRelation(secondTCQuery, cPlayerRelationEnemy);
		kbUnitQuerySetState(secondTCQuery, cUnitStateAlive);
	}
	//init - find all enemy TC's within 200 meters of first one.	
	kbUnitQueryResetResults(secondTCQuery);
	kbUnitQuerySetUnitType(secondTCQuery, gTownCenter);
	kbUnitQuerySetPosition(secondTCQuery, kbUnitGetPosition(tcID1));
	kbUnitQuerySetMaximumDistance(secondTCQuery, 500.0);

	int tcCount = kbUnitQueryExecute(secondTCQuery);
	if (tcCount > 1) // Found another enemy TC
	{
		tcID2 = kbUnitQueryGetResult(secondTCQuery, 1); // Second unit in list
		enemy2 = kbUnitGetPlayerID(tcID2);
	}

	if (tcID2 < 0)
		return;

	// We have two TCs.  See if we have a unit in range.  If so, send a taunt if appropriate.  Either way, shut the rule off.
	xsDisableSelf();

	if (enemy1 == enemy2)
		return; // Makes no sense to taunt if the same player owns both...

	bool haveLOS = false;
	if (getUnitByLocation(cUnitTypeUnit, cMyID, cUnitStateAlive, kbUnitGetPosition(tcID1), 50.0) >= 0)
		haveLOS = true;
	if (getUnitByLocation(cUnitTypeUnit, cMyID, cUnitStateAlive, kbUnitGetPosition(tcID2), 50.0) >= 0)
		haveLOS = true;

	if (haveLOS == true)
	{
		float d = distance(kbUnitGetPosition(tcID1), kbUnitGetPosition(tcID2));
		if (d < 100.0)
		{ // Close together.  Taunt the two, flaring the other's bases.
			//aiEcho("Enemy TCs are "+d+" meters apart.  Taunting for closeness.");
			sendStatement(enemy1, cAICommPromptToEnemyHisTCNearAlly, kbUnitGetPosition(tcID2)); // Taunt enemy 1 about enemy 2's TC
			sendStatement(enemy2, cAICommPromptToEnemyHisTCNearAlly, kbUnitGetPosition(tcID1)); // Taunt enemy 2 about enemy 1's TC
		}
		if (d > 200.0)
		{ // Far apart.  Taunt.
			//aiEcho("Enemy TCs are "+d+" meters apart.  Taunting for isolation.");
			sendStatement(enemy1, cAICommPromptToEnemyHisTCIsolated, kbUnitGetPosition(tcID2)); // Taunt enemy 1 about enemy 2's TC
			sendStatement(enemy2, cAICommPromptToEnemyHisTCIsolated, kbUnitGetPosition(tcID1)); // Taunt enemy 2 about enemy 1's TC         
		}
		//aiEcho("Enemy TCs are "+d+" meters apart.");
	} // Otherwise, rule is turned off, we missed our chance.   
	else
	{
		aiEcho("Had no LOS to enemy TCs");
	}
}

rule firstEnemyUnitSpotted
inactive
group startup
minInterval 5
{
	if (gCurrentGameTime < 300000) return;
	static int targetPlayer = -1;

	if (targetPlayer < 0)
	{
		targetPlayer = getEnemyPlayerByTeamPosition(getTeamPosition(cMyID)); // Corresponding player on other team
		if (targetPlayer < 0)
		{
			xsDisableSelf();
			//aiEcho("No corresponding player on other team, firstEnemyUnitSpotted is deactivating.");
			//aiEcho("    My team position is "+getTeamPosition(cMyID));
			return;
		}
		//aiEcho("Rule firstEnemyUnitSpotted will watch for player #"+targetPlayer); 
	}

	if (kbUnitCount(targetPlayer, cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive) > 0)
	{ // We see one of this player's units for the first time...let's do some analysis on it
		int unitID = getUnit(cUnitTypeLogicalTypeLandMilitary, targetPlayer, cUnitStateAlive); // Get the (or one of the) enemy units
		if (unitID < 0)
		{
			//aiEcho("kbUnitCount said there are enemies, but getUnit finds nothing.");
			return;
		}

		//aiEcho("Enemy unit spotted at "+kbUnitGetPosition(unitID));
		//aiEcho("My base is at "+gMainBaseLocation);
		//aiEcho("Distance is "+distance(gMainBaseLocation, kbUnitGetPosition(unitID)));
		//aiEcho("Unit ID is "+unitID);
		// Three tests in priority order....anything near my town, an explorer anywhere, or default.
		// In my town?
		if (distance(gMainBaseLocation, kbUnitGetPosition(unitID)) < 60.0)
		{
			sendStatement(targetPlayer, cAICommPromptToEnemyISeeHisFirstMilitaryMyTown, kbUnitGetPosition(unitID));
			//aiEcho("Spotted a unit near my town, so I'm threatening player #"+targetPlayer);
			xsDisableSelf();
			return;
		}
		// Is it an explorer?
		if (kbUnitIsType(unitID, gExplorerUnit) == true)
		{
			sendStatement(targetPlayer, cAICommPromptToEnemyISeeHisExplorerFirstTime, kbUnitGetPosition(unitID));
			//aiEcho("Spotted an enemy explorer, so I'm threatening player #"+targetPlayer);
			xsDisableSelf();
			return;
		}
		// Generic
		if (getUnitByLocation(gTownCenter, cPlayerRelationAny, cUnitStateAlive, kbUnitGetPosition(unitID), 70.0) < 0)
		{ // No TCs nearby
			sendStatement(targetPlayer, cAICommPromptToEnemyISeeHisFirstMilitary, kbUnitGetPosition(unitID));
			//aiEcho("Spotted an enemy military unit for the first time, so I'm threatening player #"+targetPlayer);
		}
		xsDisableSelf();
		return;
	}
}

void chatMain()
{

}