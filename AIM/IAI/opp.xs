//opportunityMethods

//==============================================================================
// Opportunities and Missions
//==============================================================================
void missionStartHandler(int missionID = -1)
{ // Track times for mission starts, so we can tell how long its been since
	// we had a mission of a given type.
	if (missionID < 0)
		return;

	int oppID = aiPlanGetVariableInt(missionID, cMissionPlanOpportunityID, 0);
	int oppType = aiGetOpportunityType(oppID);

	aiPlanSetVariableInt(missionID, cMissionPlanStartTime, 0, gCurrentGameTime); // Set the start time in ms.

	switch (oppType)
	{
		case cOpportunityTypeDestroy:
			{
				gLastAttackMissionTime = gCurrentGameTime;
				//aiEcho("-------- ATTACK MISSION ACTIVATION: Mission "+missionID+", Opp "+oppID);
				break;
			}
		case cOpportunityTypeDefend:
			{
				gLastDefendMissionTime = gCurrentGameTime;
				//aiEcho("-------- DEFEND MISSION ACTIVATION: Mission "+missionID+", Opp "+oppID);
				break;
			}
		case cOpportunityTypeClaim:
			{
				gLastClaimMissionTime = gCurrentGameTime;
				//aiEcho("-------- CLAIM MISSION ACTIVATION: Mission "+missionID+", Opp "+oppID);
				break;
			}
		default:
			{
				//aiEcho("-------- UNKNOWN MISSION ACTIVATION: Mission "+missionID+", Opp "+oppID);
				break;
			}
	}
}

void missionEndHandler(int missionID = -1)
{
	aiEcho("-------- MISSION TERMINATION:  Mission " + missionID + ", Opp " + aiGetOpportunityType(aiPlanGetVariableInt(missionID, cMissionPlanOpportunityID, 0)));
}

//==============================================================================
// Called for each opportunity that needs to be scored.
//==============================================================================
extern int defendOppId = -1;
void scoreOpportunity(int oppID = -1)
{
	//return;
	/*
		
		Sets all the scoring components for the opportunity, and a final score.  The scoring
		components and their meanings are:
		
		int PERMISSION  What level of permission is needed to do this?  
		cOpportunitySourceAutoGenerated is the lowest...go ahead and do it.
		cOpportunitySourceAllyRequest...the AI may not do it on its own, i.e. it may be against the rules for this difficulty.
		cOpportunitySourceTrigger...even ally requests are denied, as when prevented by control variables, but a trigger (gaia request) may do it.
		cOpportunitySourceTrigger+1...not allowed at all.
		
		float AFFORDABLE  Do I have what it takes to do this?  This includes appropriate army sizes, resources to pay for things (like trading posts)
		and required units like explorers.  0.80 indicates a neutral, good-to-go position.  1.0 means overstock, i.e. an army of 20 would be good, 
		and I have 35 units available.  0.5 means extreme shortfall, like the minimum you could possibly imagine.  0.0 means you simply can't do it,
		like no units at all.  Budget issues like amount of wood should never score below 0.5, scores below 0.5 mean deep, profound problems.
		
		int SOURCE  Who asked for this mission?  Uses the cOpportunitySource... constants above.
		
		float CLASS  How much do we want to do this type of mission?   Based on personality, how long it's been since the last mission of this type, etc.
		0.8 is a neutral, "this is a good mission" rating.  1.0 is extremely good, I really, really want to do this next.  0.5 is a poor score.  0.0 means 
		I just flat can't do it.  This class score will creep up over time for most classes, to make sure they get done once in a while.
		
		float INSTANCE  How good is this particular target?  Includes asset value (is it important to attack or defend this?) and distance.  Defense values
		are incorporated in the AFFORDABLE calculation above.  0.0 is no value, this target can't be attacked.  0.8 is a good solid target.  1.0 is a dream target.
		
		float TOTAL  Incorporates AFFORDABLE, CLASS and INSTANCE by multiplying them together, so a zero in any one sets total to zero.  Source is added as an int
		IF AND ONLY IF SOURCE >= PERMISSION.  If SOURCE < PERMISSION, the total is set to -1.  Otherwise, all ally source opportunities will outrank all self generated
		opportunities, and all trigger-generated opportunities will outrank both of those.  Since AFFORDABLE, CLASS and INSTANCE all aim for 0.8 as a good, solid
		par value, a total score of .5 is rougly "pretty good".  A score of 1.0 is nearly impossible and should be quite rare...a high-value target, weakly defended,
		while I have a huge army and the target is close to me and we haven't done one of those for a long, long time.  
		
		Total of 0.0 is an opportunity that should not be serviced.  >0 up to 1 indicates a self-generated opportunity, with 0.5 being decent, 1.0 a dream, and 0.2 kind
		of marginal.  Ally commands are in the range 1.0 to 2.0 (unless illegal), and triggers score 2.0 to 3.0.
		
	*/

	// Interim values for the scoring components:
	int permission = 0;
	float instance = 0.0;
	float classRating = 0.0;
	float total = 0.0;
	float affordable = 0.0;
	float score = 0.0;

	// Info about this opportunity
	int source = aiGetOpportunitySourceType(oppID);
	if (source < 0)
		source = cOpportunitySourceAutoGenerated;
	if (source > cOpportunitySourceTrigger)
		source = cOpportunitySourceTrigger;
	int target = aiGetOpportunityTargetID(oppID);
	int targetType = aiGetOpportunityTargetType(oppID);
	int oppType = aiGetOpportunityType(oppID);
	int targetPlayer = aiGetOpportunityTargetPlayerID(oppID);
	vector location = aiGetOpportunityLocation(oppID);
	float radius = aiGetOpportunityRadius(oppID);
	if (radius < 40.0)
		radius = 40.0;
	int baseOwner = -1;
	float baseEnemyPower = 0.0; // Used to measure troop and building strength.  Units roughly equal to unit count of army.
	float baseAllyPower = 0.0; // Strength of allied buildings and units, roughly equal to unit count.
	float netEnemyPower = 0.0; // Basically enemy minus ally, but the ally effect can, at most, cut 80% of enemy strength
	float baseAssets = 0.0; // Rough estimate of base value, in aiCost.  
	float affordRatio = 0.0;
	bool errorFound = false; // Set true if we can't do a good score.  Ends up setting score to -1.

	// Variables for available number of units and plan to kill if any
	float armySizeAuto = 0.0; // For source cOpportunitySourceAutoGenerated
	float armySizeAlly = 0.0; // For ally-generated commands, how many units could we scrounge up?
	int missionToKillAlly = -1; // Mission to cancel in order to provide the armySizeAlly number of units.  
	float armySizeTrigger = 0.0; // For trigger-generated commands, how many units could we scrounge up?
	int missionToKillTrigger = -1; // Mission to cancel in order to provide the armySizeTrigger number of units.
	float armySize = 0.0; // The actual army size we'll use for calcs, depending on how big the target is.
	float missionToKill = -1; // The actual mission to kill based on the army size we've selected.

	float oppDistance = 0.0; // Distance to target location or base.
	bool sameAreaGroup = true; // Set false if opp is on another areagroup.

	bool defendingMonopoly = false;
	bool attackingMonopoly = false;
	int tradePostID = -1; // Set to trade post ID if this is a base target, and a trade post is nearby.

	bool defendingKOTH = false;
	bool attackingKOTH = false;
	int KOTHID = -1; // Set to the hill ID if this is a base target, and the hill is nearby.

	if (gIsMonopolyRunning == true)
	{
		if (gMonopolyTeam == gPlayerTeam)
			defendingMonopoly = true; // We're defending, let's not go launching any attacks
		else
			attackingMonopoly = true; // We're attacking, focus on trade posts
	}

	if (gIsKOTHRunning == true)
	{
		if (gKOTHTeam == gPlayerTeam)
			defendingKOTH = true; // We're defending, let's not go launching any attacks
		else
			attackingKOTH = true; // We're attacking, focus on the hill
	}

	//-- get the number of units in our reserve.
	armySizeAuto = aiPlanGetNumberUnits(gLandReservePlan, cUnitTypeLogicalTypeLandMilitary);
	armySizeAlly = armySizeAuto;
	armySizeTrigger = armySizeAlly;

	//   aiEcho(" ");
	//   aiEcho("Scoring opportunity "+oppID+", targetID "+target+", location "+location);

	// Get target info
	switch (targetType)
	{
		case cOpportunityTargetTypeBase:
			{
				location = kbBaseGetLocation(kbBaseGetOwner(target), target);
				tradePostID = getUnitByLocation(gTradingPostUnit, kbBaseGetOwner(target), cUnitStateAlive, location, 40.0);
				KOTHID = getUnitByLocation(cUnitTypeypKingsHill, kbBaseGetOwner(target), cUnitStateAlive); //, location, 40.0);   
				radius = 50.0;
				baseOwner = kbBaseGetOwner(target);
				baseEnemyPower = getBaseEnemyStrength(target); // Calculate "defenses" as enemy units present
				baseAllyPower = getPointAllyStrength(kbBaseGetLocation(kbBaseGetOwner(target), target));
				if ((baseEnemyPower * 0.8) > baseAllyPower)
					netEnemyPower = baseEnemyPower - baseAllyPower; // Ally power is less than 80% of enemy
				else
					netEnemyPower = baseEnemyPower * 0.2; // Ally power is more then 80%, but leave a token enemy rating anyway.

				baseAssets = getBaseValue(target); //  Rough value of target
				if ((gIsMonopolyRunning == true) && (tradePostID >= 0))
					baseAssets = baseAssets + 10000; // Huge bump if this is a trade post (enemy or ally) and a monopoly is running            
				if ((gIsKOTHRunning == true) && (KOTHID >= 0))
					baseAssets = baseAssets + 10000; // Huge bump if this is the hill (enemy or ally) and a timer is running             
				break;
			}
		case cOpportunityTargetTypePointRadius:
			{
				baseEnemyPower = getPointEnemyStrength(location);
				baseAllyPower = getPointAllyStrength(location);
				if ((baseEnemyPower * 0.8) > baseAllyPower)
					netEnemyPower = baseEnemyPower - baseAllyPower; // Ally power is less than 80% of enemy
				else
					netEnemyPower = baseEnemyPower * 0.2; // Ally power is more then 80%, but leave a token enemy rating anyway.

				baseAssets = getPointValue(location,cPlayerRelationEnemyNotGaia); //  Rough value of target
				break;
			}
		case cOpportunityTargetTypeVPSite: // This is only for CLAIM missions.  A VP site that is owned will be a 
			// defend or destroy opportunity.
			{
				location = kbVPSiteGetLocation(target);
				radius = 50.0;

				baseEnemyPower = getPointEnemyStrength(location);
				baseAllyPower = getPointAllyStrength(location);
				if ((baseEnemyPower * 0.8) > baseAllyPower)
					netEnemyPower = baseEnemyPower - baseAllyPower; // Ally power is less than 80% of enemy
				else
					netEnemyPower = baseEnemyPower * 0.2; // Ally power is more then 80%, but leave a token enemy rating anyway.

				baseAssets = 2000.0; // Arbitrary...consider a claimable VP Site as worth 2000 resources.
				break;
			}
	}

	if (netEnemyPower < 1.0)
		netEnemyPower = 1.0; // Avoid div 0

	oppDistance = distance(location, gMainBaseLocation);
	if (oppDistance <= 0.0)
		oppDistance = 1.0;
	if (kbAreaGroupGetIDByPosition(location) != kbAreaGroupGetIDByPosition(gMainBaseLocation))
		sameAreaGroup = false;


	// Figure which armySize to use.  This currently is a placeholder, we may not need to mess with it.
	armySize = armySizeAuto; // Default

	//   aiEcho("    EnemyPower "+baseEnemyPower+", AllyPower "+baseAllyPower+", NetEnemyPower "+netEnemyPower);
	//   aiEcho("    BaseAssets "+baseAssets+", myArmySize "+armySize);

	switch (oppType)
	{
		case cOpportunityTypeDestroy:
			{
				// Check permissions required.
				if (cvOkToAttack == false)
					permission = cOpportunitySourceTrigger; // Only triggers can make us attack.

				if (gDelayAttacks == true)
					permission = cOpportunitySourceTrigger; // Only triggers can override this difficulty setting.

				// Check affordability

				if (netEnemyPower < 0.0)
				{
					errorFound = true;
					affordable = 0.0;
				}
				else
				{
					// Set affordability.  Roughly armySize / baseEnemyPower, but broken into ranges.
					// 0.0 is no-can-do, i.e. no troops.  0.8 is "good", i.e. armySize is double baseEnemyPower.  
					// Above a 2.0 ratio, to 5.0, scale this into the 0.8 to 1.0 range.
					// Above 5.0, score it 1.0
					affordRatio = armySize / netEnemyPower;
					if (affordRatio < 2.0)
						affordable = affordRatio / 2.5; // 0 -> 0.0,  2.0 -> 0.8
					else
						affordable = 0.8 + ((affordRatio - 2.0) / 15.0); // 2.0 -> 0.8 and 5.0 -> 1.0
					if (affordable > 1.0)
						affordable = 1.0;
				} // Affordability is done

				// Check target value, calculate INSTANCE score.
				if (baseAssets < 0.0)
				{
					errorFound = true;
				}
				// Clip base value to range of 100 to 10K for scoring
				if (baseAssets < 100.0)
					baseAssets = 100.0;
				if (baseAssets > 10000.0)
					baseAssets = 10000.0;
				// Start with an "instance" score of 0 to .8 for bases under 2K value.
				instance = (0.8 * baseAssets) / 2000.0;
				// Over 2000, adjust so 2K = 0.8, 30K = 1.0
				if (baseAssets > 2000.0)
					instance = 0.8 + ((0.2 * (baseAssets - 2000.0)) / 8000.0);

				// Instance is now 0..1, adjust for distance. If < 100m, leave as is.  Over 100m to 400m, penalize 10% per 100m.
				float penalty = 0.0;
				if (oppDistance > 100.0)
					penalty = (0.1 * (oppDistance - 100.0)) / 100.0;
				if (penalty > 0.6)
					penalty = 0.6;
				instance = instance * (1.0 - penalty); // Apply distance penalty, INSTANCE score is done.
				if (sameAreaGroup = false)
					instance = instance / 2.0;
				if (targetType == cOpportunityTargetTypeBase)
					if (kbHasPlayerLost(baseOwner) == true)
						instance = -1.0;
					// Illegal if it's over water, i.e. a lone dock
				if (kbAreaGetType(kbAreaGetIDByPosition(location)) == cAreaTypeWater)
					instance = -1.0;

				// Check for weak target blocks, which means the content designer is telling us that this target needs its instance score bumped up
				int weakBlockCount = 0;
				int strongBlockCount = 0;
				if (targetType == cOpportunityTargetTypeBase)
				{
					weakBlockCount = getUnitCountByLocation(cUnitTypeAITargetBlockWeak, cMyID, cUnitStateAlive, kbBaseGetLocation(baseOwner, target), 40.0);
					strongBlockCount = getUnitCountByLocation(cUnitTypeAITargetBlockStrong, cMyID, cUnitStateAlive, kbBaseGetLocation(baseOwner, target), 40.0);
				}
				if ((targetType == cOpportunityTargetTypeBase) && (weakBlockCount > 0) && (instance >= 0.0))
				{ // We have a valid instance score, and there is at least one weak block in the area.  For each weak block, move the instance score halfway to 1.0.
					while (weakBlockCount > 0)
					{
						instance = instance + ((1.0 - instance) / 2.0); // halfway up to 1.0
						weakBlockCount--;
					}
				}

				classRating = getClassRating(cOpportunityTypeDestroy); // 0 to 1.0 depending on how long it's been.
				if ((gIsMonopolyRunning == true) && (tradePostID < 0)) // Monopoly, and this is not a trade post site
					classRating = 0.0;

				if (defendingMonopoly == true)
					classRating = 0.0; // If defending, don't attack other targets

				if ((attackingMonopoly == true) && (tradePostID >= 0)) // We're attacking, and this is an enemy trade post...go get it
					classRating = 1.0;

				if ((gIsKOTHRunning == true) && (KOTHID < 0)) // KOTH, and this is the hill
					classRating = 0.0;

				if (defendingKOTH == true)
					classRating = 0.0; // If defending, don't attack other targets

				if ((attackingKOTH == true) && (KOTHID >= 0)) // We're attacking, and this is an enemy hill...go get it
					classRating = 1.0;

				if ((targetType == cOpportunityTargetTypeBase) && (strongBlockCount > 0) && (classRating >= 0.0))
				{ // We have a valid instance score, and there is at least one strong block in the area.  For each weak block, move the classRating score halfway to 1.0.
					while (strongBlockCount > 0)
					{
						classRating = classRating + ((1.0 - classRating) / 2.0); // halfway up to 1.0
						strongBlockCount--;
					}
				}

				if (aiTreatyActive() == true)
					classRating = 0.0; // Do not attack anything if under treaty

				break;
			}
		case cOpportunityTypeClaim:
			{
				// Check permissions required.
				if ((cvOkToClaimTrade == false) && (kbVPSiteGetType(target) == cVPTrade))
					permission = cOpportunitySourceTrigger; // Only triggers can let us override this.
				if ((cvOkToAllyNatives == false) && (kbVPSiteGetType(target) == cVPNative))
					permission = cOpportunitySourceTrigger; // Only triggers can let us override this.
				if (gDelayAttacks == true) // Taking trade sites and natives is sort of aggressive, turn it off on easy/sandbox.
					permission = cOpportunitySourceTrigger; // Only triggers can override this difficulty setting.

				// Check affordability.  50-50 weight on military affordability and econ affordability
				float milAfford = 0.0;
				float econAfford = 0.0;
				affordRatio = armySize / netEnemyPower;
				if (affordRatio < 2.0)
					milAfford = affordRatio / 2.5; // 0 -> 0.0,  2.0 -> 0.8
				else
					milAfford = 0.8 + ((affordRatio - 2.0) / 15.0); // 2.0 -> 0.8 and 5.0 -> 1.0
				if (milAfford > 1.0)
					milAfford = 1.0;
				affordRatio = (kbEscrowGetAmount(cRootEscrowID, cResourceWood) + kbEscrowGetAmount(cEconomyEscrowID, cResourceWood)) / (1.0 + kbUnitCostPerResource(gTradingPostUnit, cResourceWood));
				if (affordRatio < 1.0)
					econAfford = affordRatio;
				else
					econAfford = 1.0;
				if (econAfford > 1.0)
					econAfford = 1.0;
				if (econAfford < 0.0)
					econAfford = 0.0;
				affordable = (econAfford + milAfford) / 2.0; // Simple average

				// Instance
				instance = 0.8; // Same for all, unless I prefer to do one type over other (personality)
				penalty = 0.0;
				if (oppDistance > 100.0)
					penalty = (0.1 * (oppDistance - 100.0)) / 100.0;
				if (penalty > 0.6)
					penalty = 0.6;
				instance = instance * (1.0 - penalty); // Apply distance penalty, INSTANCE score is done.         
				if (sameAreaGroup = false)
					instance = instance / 2.0;
				classRating = getClassRating(cOpportunityTypeClaim, target); // 0 to 1.0 depending on how long it's been.
				break;
			}
		case cOpportunityTypeRaid:
			{
				break;
			}
		case cOpportunityTypeDefend:
			{
				// Check affordability

				if (netEnemyPower < 0.0)
				{
					errorFound = true;
					affordable = 0.0;
				}
				else
				{
					defendOppId = oppID;
					// Set affordability.  Roughly armySize / netEnemyPower, but broken into ranges.
					// Very different than attack calculations.  Score high affordability if the ally is really 
					// in trouble, especially if my army is large.  Basically...does he need help?  Can I help?
					if (baseAllyPower < 1.0)
						baseAllyPower = 1.0;
					float enemyRatio = baseEnemyPower / baseAllyPower;
					float enemySurplus = baseEnemyPower - baseAllyPower;
					if (enemyRatio < 0.5) // Enemy very weak, not a good opp.
					{
						affordRatio = enemyRatio; // Low score, 0 to .5
						if (enemyRatio < 0.2)
							affordRatio = 0.0;
					}
					else
						affordRatio = 0.5 + ((enemyRatio - 0.5) / 5.0); // ratio 0.5 scores 0.5, ratio 3.0 scores 1.0
					if ((affordRatio * 10.0) > enemySurplus)
						affordRatio = enemySurplus / 10.0; // Cap the afford ratio at 1/10 the enemy surplus, i.e. don't respond if he's just outnumbered 6:5 or something trivial.
					if (enemySurplus < 0)
						affordRatio = 0.0;
					if (affordRatio > 1.0)
						affordRatio = 1.0;
					// AffordRatio now represents how badly I'm needed...now, can I make a difference
					if (armySize < enemySurplus) // I'm gonna get my butt handed to me
						affordRatio = affordRatio * (armySize / enemySurplus); // If I'm outnumbered 3:1, divide by 3.
					// otherwise, leave it alone.

					affordable = affordRatio;
				} // Affordability is done

				// Check target value, calculate INSTANCE score.
				if (baseAssets < 0.0)
				{
					errorFound = true;
				}
				// Clip base value to range of 100 to 30K for scoring
				if (baseAssets < 100.0)
					baseAssets = 100.0;
				if (baseAssets > 30000.0)
					baseAssets = 30000.0;
				// Start with an "instance" score of 0 to .8 for bases under 2K value.
				instance = (0.8 * baseAssets) / 1000.0;
				// Over 1000, adjust so 1K = 0.8, 30K = 1.0
				if (baseAssets > 1000.0)
					instance = 0.8 + ((0.2 * (baseAssets - 1000.0)) / 29000.0);

				// Instance is now 0..1, adjust for distance. If < 200m, leave as is.  Over 200m to 400m, penalize 10% per 100m.
				penalty = 0.0;
				if (oppDistance > 200.0)
					penalty = (0.1 * (oppDistance - 200.0)) / 100.0;
				if (penalty > 0.6)
					penalty = 0.6;
				instance = instance * (1.0 - penalty); // Apply distance penalty, INSTANCE score is done.
				if (sameAreaGroup == false)
					instance = 0.0;
				if (targetType == cOpportunityTargetTypeBase)
					if (kbHasPlayerLost(baseOwner) == true)
						instance = -1.0;

				if ((defendingMonopoly == true) && (tradePostID >= 0) && (instance > 0.0))
					instance = instance + ((1.0 - instance) / 1.2); // Bump it almost up to 1.0 if we're defending monopoly and this is a trade site.
				if ((defendingKOTH == true) && (KOTHID >= 0) && (instance > 0.0))
					instance = instance + ((1.0 - instance) / 1.2); // Bump it almost up to 1.0 if we're defending the hill
				classRating = getClassRating(cOpportunityTypeDefend); // 0 to 1.0 depending on how long it's been.
				if ((defendingMonopoly == true) && (tradePostID >= 0))
					classRating = 1.0; // No time delay for 2nd defend mission if we're defending trading posts during monopoly.
				if (attackingMonopoly == true)
					classRating = 0.0; // Don't defend anything if we should be attacking a monopoly!
				if ((defendingKOTH == true) && (KOTHID >= 0))
					classRating = 1.0; // No time delay for 2nd defend mission if we're defending the hill.
				if (attackingKOTH == true)
					classRating = 0.0; // Don't defend anything if we should be attacking the hill!
				break;
			}
		case cOpportunityTypeRescueExplorer:
			{
				break;
			}
		default:
			{
				//aiEcho("ERROR ERROR ERROR ERROR");
				//aiEcho("scoreOpportunity() failed on opportunity "+oppID);
				//aiEcho("Opportunity Type is "+oppType+" (invalid)");
				break;
			}
	}

	score = classRating * instance * affordable;
	//   aiEcho("    Class "+classRating+", Instance "+instance+", affordable "+affordable);
	//   aiEcho("    Final Score: "+score);

	switch (oppType)
	{
		case cOpportunityTypeDestroy: // Aggressive AIs attack more often
			{
				score = score + (0.2 * btOffenseDefense); // If -0.5 -> score - 0.1. If -1.0 -> score - 0.2. If 0.5 -> score + 0.1. If 1.0 -> score + 0.2
			}
	}
	switch (oppType)
	{
		case cOpportunityTypeDefend: // Defensive AIs defend ally bases
			{
				score = score + (0.2 * btOffenseDefense); // If -0.5 -> score + 0.1. If -1.0 -> score + 0.2. If 0.5 -> score - 0.1. If 1.0 -> score - 0.2
			}
	}
	switch (oppType)
	{
		case cOpportunityTypeClaim: // Claiming AIs build more Trading Posts
			{
				if (kbVPSiteGetType(target) == cVPTrade)
				{
					score = score + (0.2 * btBiasTrade); // If -0.5 -> score - 0.1. If -1.0 -> score - 0.2. If 0.5 -> score + 0.1. If 1.0 -> score + 0.2
				}
				if (kbVPSiteGetType(target) == cVPNative)
				{
					score = score + (0.2 * btBiasNative); // If -0.5 -> score - 0.1. If -1.0 -> score - 0.2. If 0.5 -> score + 0.1. If 1.0 -> score + 0.2
				}
			}
	}

	if (score > 1.0)
		score = 1.0;
	if (score < 0.0)
		score = 0.0;

	score = score + source; // Add 1 if from ally, 2 if from trigger.

	if (permission > source)
		score = -1.0;
	if (errorFound == true)
		score = -1.0;
	if (cvOkToSelectMissions == false)
		score = -1.0;

	//updatedOn 2019/05/06 By ageekhere  
	//---------------------------
	//Do not build a cVPTrade or cVPNative untill you have 2 towncenters
	/*
		if ((kbVPSiteGetType(target) == cVPTrade || kbVPSiteGetType(target) == cVPNative) && kbUnitCount(cMyID, gTownCenter, cUnitStateAlive) < 2) score = -1.0;
		if ((kbVPSiteGetType(target) == cVPTrade || kbVPSiteGetType(target) == cVPNative) && gCurrentAge >= cAge4) 
		{
		score = 1.0;
		permission = 0;
		}
		//check for enemy before building a VP
		if (kbVPSiteGetType(target) == cVPTrade || kbVPSiteGetType(target) == cVPNative)
		{
		int enemyUnit = kbUnitQueryCreate("enemyUnit");
		kbUnitQuerySetPlayerRelation(enemyUnit,cPlayerRelationEnemyNotGaia);
		kbUnitQuerySetUnitType(enemyUnit, cUnitTypeMilitary);
		kbUnitQuerySetPosition(enemyUnit, kbVPSiteGetLocation(target) ); //set the location
		kbUnitQuerySetMaximumDistance(enemyUnit, 25);
		kbUnitQuerySetIgnoreKnockedOutUnits(enemyUnit, true);
		kbUnitQuerySetState(enemyUnit, cUnitStateAlive);
		
		int enemyBuilding = kbUnitQueryCreate("enemyBuilding");
		kbUnitQuerySetPlayerRelation(enemyBuilding,cPlayerRelationEnemyNotGaia);
		kbUnitQuerySetUnitType(enemyBuilding, cUnitTypeBuilding);
		kbUnitQuerySetPosition(enemyBuilding, kbVPSiteGetLocation(target) ); //set the location
		kbUnitQuerySetMaximumDistance(enemyBuilding, 25);
		kbUnitQuerySetIgnoreKnockedOutUnits(enemyBuilding, true);
		kbUnitQuerySetState(enemyBuilding, cUnitStateAlive);
		
		if(kbUnitQueryExecute(enemyUnit) > 5 || kbUnitQueryExecute(enemyBuilding) > 0) 
		{
		score = -1.0;//return;
		}
		
		
		}
	*/
	//---------------------------
	aiSetOpportunityScore(oppID, permission, affordable, classRating, instance, score);
}

void oppMain()
{

}