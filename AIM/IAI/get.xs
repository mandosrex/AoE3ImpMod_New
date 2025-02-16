//getMethods

//==============================================================================
/*
 checkExcludeSettler
 updatedOn 2022/04/19
 Checks to see if a settler is in the exclude list
 
 How to use
 call checkExcludeSettler and pass a settlerId, it will return true or false
 
 Example
 checkExcludeSettler(settlerId);
*/
//==============================================================================
bool checkExcludeSettler(int settlerId = -1)
{ //Checks to see if a settler is in the exclude list
	debugRule("bool checkExcludeSettler ",-1);
	static int forLength = -1;
	static int pArrayValue = -1;
	forLength = xsArrayGetSize(gExcludeSettlersArray);
	for (i = 0; < forLength)
	{ //loop through array
		pArrayValue = xsArrayGetInt(gExcludeSettlersArray, i);
		if(pArrayValue == -1)return(false);
		if (settlerId == xsArrayGetInt(gExcludeSettlersArray, i))
		{ //check for match
			debugRule("bool checkExcludeSettler - Settler is in the exclude array",1);
			return (true); //Found
		} //end if
	} //end for i
	

	forLength = xsArrayGetSize(gExcludeSettlersArray);
	for (i = 0; < forLength)
	{
		pArrayValue = xsArrayGetInt(gBringInHuntSettlers, i);
		if(pArrayValue == -1)return(false);
		if (settlerId == xsArrayGetInt(gBringInHuntSettlers, i))
		{ //check for match
			debugRule("bool checkExcludeSettler - Settler is in the exclude array",1);
			return (true); //Found
		} //end if
	}
	
	return (false); //Did not find settler
} //end checkExcludeSettler

//==============================================================================
/*
	getQueryId
	updatedOn 2023/06/13
	Gives a new ID for a Query name
	
	How to use
	When creating a new Query add getQueryId to the name of the Query
	
	Example int myQry = kbUnitQueryCreate("NAME OF Qry" + getQueryId() );
*/
//==============================================================================
int getQueryId()
{
	debugRule("getQueryId",-0);
	static int id = 0;
	id++;
	debugRule("getQueryId - id " + id, 0);
	return(id);
} //end getQueryId
//==============================================================================
/*
 getHumanOnTeam
 updatedOn 2022/06/21
 gets an alive human player on the AI team
 
 How to use
 Call getHumanOnTeam() to return a humanPlayer
 
 Example
 int humanPlayer = getHumanOnTeam()
*/
//==============================================================================
int getHumanOnTeam(void)
{
	debugRule("int getHumanOnTeam ",-0);
	//If the game time is the same return the saved value for that interval
	static int lastTimeCalled = -1;
	static int returnValue = -2;
	if(returnValue == -1) return(returnValue); //AI does not have a human on their team 
	if(lastTimeCalled == gCurrentGameTime) return(returnValue); 
	lastTimeCalled = gCurrentGameTime;
	
	static int playerCount = -1;
	if(playerCount == 1) return(-1);
	playerCount = 0; //reset 
	for (i = 1; < cNumberPlayers)
	{ //loop through players starting at player 1
		if (kbIsPlayerEnemy(i) == false && gPlayerTeam == kbGetPlayerTeam(i) && (i != cMyID) && kbHasPlayerLost(i) == false && xsArrayGetBool(gPlayerHumanStatusArray,i) )//kbIsPlayerHuman(i) == true) 
		{
			returnValue = i;
			return(returnValue);
		}
	} //end for
	returnValue = -1;
	return(returnValue);
} //end getHumanOnTeam


//==============================================================================
/*
 getAIOnTeam
 updatedOn 2022/06/21
 gets an alive AI player on the AI team
 
 How to use
 Call getAIOnTeam() to return an AI player
 
 Example
 int humanPlayer = getHumanOnTeam()
 
*/
//==============================================================================
int getAIOnTeam(void)
{
	debugRule("int getAIOnTeam ",-0);
	//If the game time is the same return the saved value for that interval
	static int lastTimeCalled = -1;
	static int returnValue = -2;
	if(returnValue == -1) return(returnValue);
	if(lastTimeCalled == gCurrentGameTime) return(returnValue); 
	lastTimeCalled = gCurrentGameTime;
	
	static int playerCount = 0;
	if(playerCount == 1) return(-1);
	for (i = 1; < cNumberPlayers)
	{ //loop through players starting at player 1
		if (kbIsPlayerEnemy(i) == false && gPlayerTeam == kbGetPlayerTeam(i) && (i != cMyID) && kbHasPlayerLost(i) == false && xsArrayGetBool(gPlayerHumanStatusArray,i) == false )//kbIsPlayerHuman(i) == false) 
		{
			returnValue = i;
			return(returnValue);
		}			
	} //end for
	returnValue = -1;
	return(returnValue);
} //getAIOnTeam

//==============================================================================
/*
 getNumTeamTownCenter
 updatedOn 2022/06/21
 get the total number of team Town Centers
 
 How to use
 Call getNumTeamTownCenter()
 
 Example
 int totalTeamTownCenter = getNumTeamTownCenter()
 
*/
//==============================================================================
int getNumTeamTownCenter(void)
{
	debugRule("int getNumTeamTownCenter ",-0);
	static int lastTimeCalled = -1;
	static int returnValue = -2;
	if(lastTimeCalled == gCurrentGameTime) return(returnValue); 
	lastTimeCalled = gCurrentGameTime;
	
	int townCenterCount = 0;
	for (i = 1; < cNumberPlayers)
	{ //loop through players starting at player 1
		if (gPlayerTeam == kbGetPlayerTeam(i) && kbHasPlayerLost(i) == false) townCenterCount = townCenterCount + kbUnitCount(i, gTownCenter, cUnitStateAlive );
	} //end for
	returnValue = townCenterCount;
	return(returnValue);
} //end getNumTeamTownCenter

//==============================================================================
/*
 getCivIsNative
 updatedOn 2022/06/21
 returns true if the AI civ is Natives
 
 How to use
 Call getCivIsNative()
 
 Example
 bool isMyCivNative = getCivIsNative()
*/
//==============================================================================
bool getCivIsNative(void)
{ //checks if a civ is native
	debugRule("bool getCivIsNative ",-0);
	static bool firstRun = true;
	static bool val = false; //saves the civ value
	if(firstRun)
	{ //only check once, then save results
		firstRun = false;
		if ((cMyCiv == cCivXPAztec) || (cMyCiv == cCivXPIroquois) || (cMyCiv == cCivXPSioux)) val = true;
	}
	return (val);
} //end getCivIsNative

//==============================================================================
/*
 getCivIsAsian
 updatedOn 2022/06/21
 returns true if the AI civ is Asian
 
 How to use
 Call getCivIsAsian()
 
 Example
 bool isMyCivAsian = getCivIsAsian()
*/
//==============================================================================
bool getCivIsAsian(void)
{ //checks if a civ is Asian
	debugRule("bool getCivIsAsian ",-0);
	static bool firstRun = true;
	static bool val = false; //saves the civ value
	if(firstRun)
	{ //only check once, then save results
		firstRun = false;
		if ((cMyCiv == cCivJapanese) || (cMyCiv == cCivChinese) || (cMyCiv == cCivIndians) ||
			(cMyCiv == cCivSPCIndians) || (cMyCiv == cCivSPCChinese) || (cMyCiv == cCivSPCJapanese) ||
			(cMyCiv == cCivSPCJapaneseEnemy))  val = true; 
	}
	return (val);
} //end getCivIsAsian

//==============================================================================
/*
 getCivIsJapan
 updatedOn 2022/09/02
 returns true if the AI civ is Japan
 
 How to use
 Call getCivIsJapan()
 
 Example
 bool isMyCivJapan = getCivIsJapan()
*/
//==============================================================================
bool getCivIsJapan(void)
{ //checks if a civ is Japan
	debugRule("bool getCivIsJapan ",-0);
	static bool firstRun = true;
	static bool val = false; //saves the civ value
	if(firstRun)
	{ //only check once, then save results
		firstRun = false;
		if ((cMyCiv == cCivJapanese) || (cMyCiv == cCivSPCJapanese) || (cMyCiv == cCivSPCJapaneseEnemy)) val = true; 
	}
	return (val);
} //end getCivIsJapan

 
bool getCivIsChinese(void)
{ //checks if a civ is Chinese
	debugRule("bool getCivIsChinese ",-0);
	static bool firstRun = true;
	static bool val = false; //saves the civ value
	if(firstRun)
	{ //only check once, then save results
		firstRun = false;
		if ((cMyCiv == cCivChinese) || (cMyCiv == cCivSPCChinese)) val = true; 
	}
	return (val);
} //end getCivIsChinese

bool getCivIsIndia(void)
{ //checks if a civ is India
	debugRule("bool getCivIsIndia ",-0);
	static bool firstRun = true;
	static bool val = false; //saves the civ value
	if(firstRun)
	{ //only check once, then save results
		firstRun = false;
		if ((cMyCiv == cCivIndians) || (cMyCiv == cCivSPCIndians)) val = true; 
	}
	return (val);
} //end getCivIsIndia

bool getCivIsEuropean(void)
{ //checks if a civ is European
	debugRule("bool getCivIsEuropean ",-0);
	static bool firstRun = true;
	static bool val = false; //saves the civ value
	if(firstRun)
	{ //only check once, then save results
		firstRun = false;
		if(getCivIsNative() == false && getCivIsAsian() == false) val = true;
	}
	return (val);
} //end getCivIsEuropean

//==============================================================================
/*
 getAliveSettlersQuery
 updatedOn 2022/06/22
 return all alive settlers from cMyID
 Through out the code there are a lot of queries that get the number of settlers cMyID has. 
 To optimize this process a new global query is create and limits new query calls to every 1 
 second else return the saved results. So instead of this query being called multiple times 
 per Interval through out the script now it is called once. 
 
 How to use
 Call getPlayerAliveSettlers()
 
 Example
 int numOfSettlers = getPlayerAliveSettlers()
*/
//==============================================================================
extern int getAliveSettlersQuery = -1;
int getPlayerAliveSettlers(void)
{ //new query that finds all alive settlers
	debugRule("int getPlayerAliveSettlers",-0);
	static int lastTimeCalled = -1;
	static int returnValue = -2;
	if(lastTimeCalled == gCurrentGameTime) return(returnValue); 
	lastTimeCalled = gCurrentGameTime;
	
	if (getAliveSettlersQuery == -1) 
	{
		getAliveSettlersQuery = kbUnitQueryCreate("getAliveSettlersQuery"+getQueryId());
		kbUnitQuerySetPlayerID(getAliveSettlersQuery, cMyID, false);
		kbUnitQuerySetPlayerRelation(getAliveSettlersQuery, -1);
		kbUnitQuerySetState(getAliveSettlersQuery, cUnitStateAlive);
	}
	kbUnitQueryResetResults(getAliveSettlersQuery); //reset results
	kbUnitQuerySetUnitType(getAliveSettlersQuery, cUnitTypeAffectedByTownBell);
	returnValue = kbUnitQueryExecute(getAliveSettlersQuery); //record the results
	return(returnValue); //return the results
} //end getPlayerAliveSettlers

extern int getIdleSettlersQuery = -1;
int getPlayerIdleSettlers(void)
{ //new query that finds all idle settlers
	debugRule("int getIdleSettlersQuery",-0);
	static int lastTimeCalled = -1;
	static int returnValue = -2;
	if(lastTimeCalled == gCurrentGameTime) return(returnValue); 
	lastTimeCalled = gCurrentGameTime;
	if (getIdleSettlersQuery == -1) 
	{
		getIdleSettlersQuery = kbUnitQueryCreate("getIdleSettlersQuery"+getQueryId());
		kbUnitQuerySetPlayerID(getIdleSettlersQuery, cMyID, false);
		kbUnitQuerySetPlayerRelation(getIdleSettlersQuery, -1);
		kbUnitQuerySetState(getIdleSettlersQuery, cUnitStateAlive);
		kbUnitQuerySetUnitType(getIdleSettlersQuery, cUnitTypeAffectedByTownBell);
		kbUnitQuerySetActionType(getIdleSettlersQuery, 7);
	}
	kbUnitQueryResetResults(getIdleSettlersQuery); //reset results
	returnValue = kbUnitQueryExecute(getIdleSettlersQuery); //record the results
	return(returnValue); //return the results
} //end getIdleSettlersQuery


//==============================================================================
/*
 getSettlerShortfall
 updatedOn 2022/06/23
 returns the shortfall of settlers for the AI
 
 How to use
 Call getSettlerShortfall()
 
 Example
 int settlerShortFall = getSettlerShortfall()
*/
//==============================================================================
int getSettlerShortfall(void)
{ //How many more Settlers do we currently want?
	debugRule("int getSettlerShortfall ",-0);
	static int lastTimeCalled = -1;
	static int returnValue = -2;
	if(lastTimeCalled == gCurrentGameTime) return(returnValue); 
	lastTimeCalled = gCurrentGameTime;
	
	returnValue = xsArrayGetInt(gTargetSettlerCounts, gCurrentAge) - gCurrentAliveSettlers;
	return(returnValue); //the target settler count for the age - number of ALL settler unit kinds
} //end getSettlerShortfall



//==============================================================================
/*
 getMapIsIsland
 updatedOn 2022/06/23
 returns true if the map is an island, note hard coded untill a better method is found
 
 How to use
 Call getMapIsIsland()
 
 Example
 bool mapIsIsland = getMapIsIsland()
*/
//==============================================================================
bool getMapIsIsland(void)
{
	debugRule("bool mapIsIsland ",-0); 
	static bool firstRun = true;
	static bool val = false;
	if(firstRun)
	{
		firstRun = false;
        if ((cRandomMapName == "amazonia") || 
        (cRandomMapName == "caribbean") || 
        (cRandomMapName == "ceylon") || 
        (cRandomMapName == "bosphorus")|| 
        (cRandomMapName == "micronesia"))  val = true;
	} //end if
	return (val);
} //end getMapIsIsland

int getNearestUnitByLocation(int unitTypeID = -1, int playerRelationOrID = cMyID, int state = cUnitStateAlive, vector location = cInvalidVector, float radius = 20.0)
{ //Returns the nearest unit by location matching the parameters
	debugRule("int getNearestUnitByLocation ",-0);
	static int unitQueryID = -1;
	int numberFound = -1;
	if (unitQueryID == -1) 
	{
		unitQueryID = kbUnitQueryCreate("getNearestUnitByLocation"+getQueryId());
		kbUnitQuerySetIgnoreKnockedOutUnits(unitQueryID, true);
		kbUnitQuerySetAscendingSort(unitQueryID, true);
	}
	kbUnitQueryResetResults(unitQueryID);
	if (playerRelationOrID > 1000)
	{ // Too big for player ID number
		kbUnitQuerySetPlayerID(unitQueryID, -1,false);
		kbUnitQuerySetPlayerRelation(unitQueryID, playerRelationOrID);
	}
	else
	{
		kbUnitQuerySetPlayerRelation(unitQueryID, -1);
		kbUnitQuerySetPlayerID(unitQueryID, playerRelationOrID,false);
	}
	kbUnitQuerySetUnitType(unitQueryID, unitTypeID);
	kbUnitQuerySetState(unitQueryID, state);
	kbUnitQuerySetPosition(unitQueryID, location);
	kbUnitQuerySetMaximumDistance(unitQueryID, radius);
	numberFound = kbUnitQueryExecute(unitQueryID);
	if (numberFound > 0) return (kbUnitQueryGetResult(unitQueryID, 0)); // Return a random dude(tte)
	return (-1);
} //end getNearestUnitByLocation

//==============================================================================
/*
 getUnitByLocation
 updatedOn 2022/06/23
 returns a unitID at a given location
 
 How to use
 Call getUnitByLocation and pass the following values
 int unitTypeID
 int playerRelationOrID
 int state
 vector location
 float radius
 
 Example
 int unitId = getUnitByLocation(cUnitTypeMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, vectorValue, 20.0)
*/
//==============================================================================
int getUnitByLocation(int unitTypeID = -1, int playerRelationOrID = cMyID, int state = cUnitStateAlive, vector location = cInvalidVector, float radius = 20.0)
{ //Returns a random unit by location matching the parameters
	debugRule("int getUnitByLocation ",-0);
	static int unitQueryID = -1;
	int numberFound = -1;
	if (unitQueryID == -1) 
	{
		unitQueryID = kbUnitQueryCreate("getUnitByLocation"+getQueryId());
		kbUnitQuerySetIgnoreKnockedOutUnits(unitQueryID, true);
	}
	kbUnitQueryResetResults(unitQueryID);
	if (playerRelationOrID > 1000)
	{ // Too big for player ID number
		kbUnitQuerySetPlayerID(unitQueryID, -1,false);
		kbUnitQuerySetPlayerRelation(unitQueryID, playerRelationOrID);
	}
	else
	{
		kbUnitQuerySetPlayerRelation(unitQueryID, -1);
		kbUnitQuerySetPlayerID(unitQueryID, playerRelationOrID,false);
	}
	kbUnitQuerySetUnitType(unitQueryID, unitTypeID);
	kbUnitQuerySetState(unitQueryID, state);
	kbUnitQuerySetPosition(unitQueryID, location);
	kbUnitQuerySetMaximumDistance(unitQueryID, radius);
	numberFound = kbUnitQueryExecute(unitQueryID);
	if (numberFound > 0) return (kbUnitQueryGetResult(unitQueryID, aiRandInt(numberFound))); // Return a random dude(tte)
	return (-1);
} //end getUnitByLocation

//==============================================================================
/*
 getUnitCountByLocation
 updatedOn 2022/06/24
 counts the number of units at a location
 
 How to use
 Call getUnitCountByLocation and pass the following values
 int unitTypeID
 int playerRelationOrID
 int state
 vector location
 float radius
 
 Example
 int numberOfUnits = getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, position, 30.0)
*/
//==============================================================================
int getUnitCountByLocation(int unitTypeID = -1, int playerRelationOrID = cMyID, int state = cUnitStateAlive, vector location = cInvalidVector, float radius = 20.0)
{
	debugRule("int getUnitCountByLocation ",-0);
	static int unitQueryID = -1;
	if (unitQueryID == -1)
	{		
		unitQueryID = kbUnitQueryCreate("getUnitCountByLocationQuery"+getQueryId());
		kbUnitQuerySetIgnoreKnockedOutUnits(unitQueryID, true);
	}
	kbUnitQueryResetResults(unitQueryID);
	if (playerRelationOrID > 1000) // Too big for player ID number
	{ 
		kbUnitQuerySetPlayerID(unitQueryID, -1,false);
		kbUnitQuerySetPlayerRelation(unitQueryID, playerRelationOrID);
	}
	else
	{
		kbUnitQuerySetPlayerRelation(unitQueryID, -1);
		kbUnitQuerySetPlayerID(unitQueryID, playerRelationOrID,false);
	}
	kbUnitQuerySetUnitType(unitQueryID, unitTypeID);
	kbUnitQuerySetState(unitQueryID, state);
	kbUnitQuerySetPosition(unitQueryID, location);
	kbUnitQuerySetMaximumDistance(unitQueryID, radius);
	return (kbUnitQueryExecute(unitQueryID));
} //end getUnitCountByLocation

//==============================================================================
/*
 getUnit
 updatedOn 2022/06/24
 get a random unit matching the parameters
 
 How to use
 Call getUnit and pass the following values
 int unitTypeID
 int playerRelationOrID 
 int state
 
 Example
 int unitId = getUnit(gTownCenter, cMyID, cUnitStateAlive);
*/
//==============================================================================
int getUnit(int unitTypeID = -1, int playerRelationOrID = cMyID, int state = cUnitStateAlive)
{
	static int unitQueryID = -1;
	int numberFound = -1;
	if (unitQueryID == -1) 
	{
		unitQueryID = kbUnitQueryCreate("getUnit"+getQueryId());
		kbUnitQuerySetIgnoreKnockedOutUnits(unitQueryID, true);
	}
	kbUnitQueryResetResults(unitQueryID);
	if (playerRelationOrID > 1000) // Too big for player ID number
	{
		kbUnitQuerySetPlayerID(unitQueryID, -1,false); // Clear the player ID, so playerRelation takes precedence.
		kbUnitQuerySetPlayerRelation(unitQueryID, playerRelationOrID);
	}
	else
	{
		kbUnitQuerySetPlayerRelation(unitQueryID, -1);
		kbUnitQuerySetPlayerID(unitQueryID, playerRelationOrID,false);
	}
	kbUnitQuerySetUnitType(unitQueryID, unitTypeID);
	kbUnitQuerySetState(unitQueryID, state);
	numberFound = kbUnitQueryExecute(unitQueryID);

	if (numberFound > 0) return (kbUnitQueryGetResult(unitQueryID, aiRandInt(numberFound))); // Return a random dude(tte)
	return (-1);
} //end getUnit


//==============================================================================
/*
	xsVectorLerp
	updatedOn 2024/02/02
	used in getEnemyUnitPathStatus to get jump vectors
	
	How to use
	call xsVectorLerp and a start vector, end vector and step value
	
	Example
	int checkPathCount = getEnemyUnitPathStatus(pUnitPosition,pLocation);
*/
//==============================================================================


vector xsVectorLerp(vector start = cInvalidVector, vector end = cInvalidVector, float t = -1.0)
{
	static vector result = cInvalidVector;
	result = cInvalidVector;
	result = xsVectorSetX(result,(xsVectorGetX(start) + t * (xsVectorGetX(end) - xsVectorGetX(start))));
	result = xsVectorSetZ(result,(xsVectorGetZ(start) + t * (xsVectorGetZ(end) - xsVectorGetZ(start))));
    return (result);		
}

//==============================================================================
/*
	getEnemyUnitPathStatus
	updatedOn 2024/02/02
	Checks in a straight line (as the bird flys) if there are any enemy units between 2 locations
	
	How to use
	call getEnemyUnitPathStatus and pass 2 vector values, it will return the number of enemy units found
	
	Example
	int num = getEnemyUnitPathStatus(positionA, positionB)
*/
//==============================================================================


int getEnemyUnitPathStatus(vector pUnitPosition = cInvalidVector, vector pLocation = cInvalidVector )
{
	
	const float interval = 10.0;
	static float pStep = -1.0;
	static float pCurrentJump = -1.0;
	static int pEnemyCount = -1;
 	pStep = 1.0 / (distance(pUnitPosition, pLocation) / interval);
	pCurrentJump = 0.0;
	pEnemyCount = 0;
	while (pCurrentJump <= 1.0)
    {
        pCurrentJump = pCurrentJump + pStep;
		pEnemyCount = pEnemyCount + getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, xsVectorLerp(pUnitPosition, pLocation, pCurrentJump), interval);
		pCurrentJump = pCurrentJump + pStep;
    }
	return(pEnemyCount);
}


//==============================================================================
/*
	getWaterPathStatus
	updatedOn 2024/02/02
	Checks in a straight line (as the bird flys) if there is any water between 2 locations
	
	How to use
	call getWaterPathStatus and pass 2 vector values, it will return true if water is found
	
	Example
	bool waterStatus = getWaterPathStatus(positionA, positionB)
*/
//==============================================================================

bool getWaterPathStatus(vector pUnitPosition = cInvalidVector, vector pLocation = cInvalidVector )
{
	const float interval = 10.0;
	static float pStep = -1.0;
	static float pCurrentJump = -1.0;
 	pStep = 1.0 / (distance(pUnitPosition, pLocation) / interval);
	pCurrentJump = 0.0;
	while (pCurrentJump <= 1.0)
    {
        pCurrentJump = pCurrentJump + pStep;
		if (kbAreaGetType(kbAreaGetIDByPosition(xsVectorLerp(pUnitPosition, pLocation, pCurrentJump))) == cAreaTypeWater) return(true);
		pCurrentJump = pCurrentJump + pStep;
    }
	return(false);
}

//==============================================================================
/*
 getPlayerArmyHPs
 updatedOn 2022/06/24
 Queries all land military units and gets the total hitpoints (ideal if considerHealth false, otherwise actual.)
 
 How to use
 Call getPlayerArmyHPs and pass the following values
 int playerID
 bool considerHealth 
 
 Example
 int unitId = getPlayerArmyHPs(1, true);
*/
//==============================================================================
float getPlayerArmyHPs(int playerID = -1, bool considerHealth = false)
{
	debugRule("int getPlayerArmyHPs ",-0);
	static int queryID = -1;
	if (playerID <= 0) return (-1.0);
	if(queryID == -1) 
	{
		queryID = kbUnitQueryCreate("getStrongestEnemyArmyHPs"+getQueryId());
		kbUnitQuerySetPlayerRelation(queryID,-1);
		kbUnitQuerySetIgnoreKnockedOutUnits(queryID, true);
		kbUnitQuerySetUnitType(queryID, cUnitTypeLogicalTypeLandMilitary);
		kbUnitQuerySetState(queryID, cUnitStateAlive);
	}
	kbUnitQueryResetResults(queryID);
	kbUnitQuerySetPlayerID(queryID, playerID, false);
	kbUnitQueryExecute(queryID);
	return (kbUnitQueryGetUnitHitpoints(queryID, considerHealth));
} //end if

//==============================================================================
/*
 getCivHuntAbility
 updatedOn 2022/06/24
 Checks if the civ is able to hunt, note civs are hard coded until a better method is found
 
 How to use
 Call getCivHuntAbility
 
 Example
 bool canMyCivHunt = getCivHuntAbility();
*/
//==============================================================================
bool getCivHuntAbility(void)
{
	debugRule("bool getCivHuntAbility ",-0);
	static bool civHuntAbility = true;
	static bool firstRun = true;	
	if(firstRun)
	{
		firstRun = false;
		if (gCurrentCiv == cCivJapanese || gCurrentCiv == cCivSPCJapanese || gCurrentCiv == cCivSPCJapaneseEnemy) civHuntAbility = false;
	}
	return(civHuntAbility);
} //end getCivHuntAbility

/*
 getCivSlaughterAbility
 updatedOn 2023/06/10
 Checks if the civ is able to slaughter herdables(sheep, cows), note civs are hard coded until a better method is found
 
 How to use
 Call getCivSlaughterAbility
 
 Example
 bool canMyCivSlaughter = getCivSlaughterAbility();
*/
//==============================================================================
bool getCivSlaughterAbility(void)
{
	debugRule("bool getCivSlaughterAbility ",-0);
	static bool pAbility = true;
	static bool firstRun = true;	
	if(firstRun)
	{
		firstRun = false;
		if (gCurrentCiv == cCivIndians) pAbility = false;
	}
	return(pAbility);
} //end getCivSlaughterAbility

//==============================================================================
/*
 getAllyCount
 updatedOn 2022/06/24
 gets the number of alive allies a player has
 
 How to use
 Call getAllyCount to return the number of alive allies
 
 Example
 int allyCount = getAllyCount()
*/
//==============================================================================
int getAllyCount(void)
{
	debugRule("int getAllyCount",-0);
	
	static int lastTimeCalled = -1;
	static int returnValue = -2;
	if(lastTimeCalled == gCurrentGameTime) return(returnValue); 
	lastTimeCalled = gCurrentGameTime;
	
	if(returnValue == 0) return(returnValue);
	returnValue = 0;
	for (i = 1; < cNumberPlayers)
	{
		if (kbIsPlayerAlly(i) == true && i != cMyID && kbHasPlayerLost(i) == true) returnValue++;
	}
	return (returnValue);
} //end getAllyCount

//==============================================================================
/*
 getCurrentTeamSize
 updatedOn 2022/06/21
 gets the size of the team (only counts alive players)
 
 How to use
 Call getCurrentTeamSize to return the team size
 
 Example
 int teamSize = getCurrentTeamSize()
 
*/
//==============================================================================
int getCurrentTeamSize(void)
{
	debugRule("int getCurrentTeamSize",-0);
	static int lastTimeCalled = -1;
	static int returnValue = -2;
	if(lastTimeCalled == gCurrentGameTime) return(returnValue); 
	lastTimeCalled = gCurrentGameTime;
	
	if(returnValue == 1) return(1); //Check if last returnValue was 1, if so do not check for players on team
	returnValue = 0; //reset 
	for (i = 1; < cNumberPlayers)
	{ //loop through players starting at player 1
		if (gPlayerTeam == kbGetPlayerTeam(i) && kbHasPlayerLost(i) == false) returnValue++;
	} //end for i
	return(returnValue); //return the team size
} //end getCurrentTeamSize


//==============================================================================
/*
 getEnemyCount
 updatedOn 2022/06/24
 gets the number of alive enemies a player has
 
 How to use
 Call getEnemyCount to return the number of alive enemies
 
 Example
 int enemyCount = getEnemyCount()
*/
//==============================================================================
int getEnemyCount(void)
{
	debugRule("int getEnemyCount",-0);
	static int lastTimeCalled = -1;
	static int returnValue = -2;
	if(lastTimeCalled == gCurrentGameTime) return(returnValue); 
	lastTimeCalled = gCurrentGameTime;
	
	if(returnValue == 1) return(1);
	returnValue = 0; //reset 
	for (i = 1; < cNumberPlayers)
	{
		if (kbIsPlayerEnemy(i) == true && kbHasPlayerLost(i) == false && i != cMyID) returnValue++;
	}
	return(returnValue); //return the team size
} //end getEnemyCount

//==============================================================================
/*
 getRandomPlayerByRelation
 updatedOn 2022/06/29
 returns a random player by relocaiton
 
 How to use
 Call getRandomPlayerByRelation and pass a relation type
 
 cPlayerRelationAny: return any alive player except self and nature
 cPlayerRelationSelf: return self player number
 cPlayerRelationEnemy: return any alive enemy including nature
 cPlayerRelationAlly: return ally player
 cPlayerRelationEnemyNotGaia: return enemy not nature
 
 Example
 int player = getRandomPlayerByRelation(cPlayerRelationAny);
*/
//==============================================================================
int getRandomPlayerByRelation(int playerRelation = -1)
{
	debugRule("int getRandomPlayerByRelation",-0);
	static int pArray = -1;
	if(pArray == -1) pArray = xsArrayCreateInt(7, 0, "playerRelationArray");
	int pArrayCount = 0;
	
	switch(playerRelation)
	{
		case cPlayerRelationAny :
		{
			for (i = 1; < cNumberPlayers)
			{
				if (kbHasPlayerLost(i) == false && i != cMyID) 
				{
					xsArraySetInt(pArray, pArrayCount, i);
					pArrayCount++;
				}
			}
			break;
		}
		case cPlayerRelationSelf :
		{
			for (i = 1; < cNumberPlayers)
			{
				if (i == cMyID) 
				{
					return(i);
				}
			}
			break;
		}
		case cPlayerRelationEnemy :
		{
			for (i = 0; < cNumberPlayers)
			{
				if (kbIsPlayerEnemy(i) == true && kbHasPlayerLost(i) == false && i != cMyID) 
				{
					xsArraySetInt(pArray, pArrayCount, i);
					pArrayCount++;
				}
			}
			break;
		}
		case cPlayerRelationAlly :
		{
			for (i = 1; < cNumberPlayers)
			{
				if (kbIsPlayerAlly(i) == true && kbHasPlayerLost(i) == false && i == cMyID) 
				{
					xsArraySetInt(pArray, pArrayCount, i);
					pArrayCount++;
				}
			}
			break;
		}
		case cPlayerRelationEnemyNotGaia :
		{
			for (i = 1; < cNumberPlayers)
			{
				if (kbIsPlayerEnemy(i) == true && kbHasPlayerLost(i) == false && i != cMyID) 
				{
					xsArraySetInt(pArray, pArrayCount, i);
					pArrayCount++;
				}
			}
			break;
		}	
	}
	if(pArrayCount == 0) return(-1);
	return(xsArrayGetInt(pArray, aiRandInt(pArrayCount)));
}

//==============================================================================
/*
	getTeamPosition
	updatedOn 2022/06/30
	Returns a player's current team position Excluding resighed players
	
	How to use
	Call getTeamPosition and pass a playerID
	
	Example
	int playerPosition = getTeamPosition(cMyID));
*/
//==============================================================================
int getTeamPosition(int playerID = -1)
{
	debugRule("int getTeamPosition",-0);
	static int position = -1;
	if(position == 1) return(1);
	position = 1;
	for (i = 1; < cNumberPlayers)
	{
		if (i == playerID) return (position);
		if ((kbHasPlayerLost(i) == false) && (kbGetPlayerTeam(playerID) == kbGetPlayerTeam(i))) position++;
	}
	return (-1);
} //end getTeamPosition
//==============================================================================

//==============================================================================
/*
	getEnemyPlayerByTeamPosition
	updatedOn 2022/07/01
	returns an enemy player by team position
	
	How to use
	Call getEnemyPlayerByTeamPosition and pass team position
	
	Example
	int enemyPlayerPosition = getEnemyPlayerByTeamPosition(1));
*/
//==============================================================================
int getEnemyPlayerByTeamPosition(int position = -1)
{
	debugRule("int getEnemyPlayerByTeamPosition",-0);
	int matchCount = 0;
	int playerToGet = -1; // i.e. get the 2nd matching playe
	for (i = 1; < cNumberPlayers)
	{ // Traverse list of players, return when we find the matching player
		if ((kbHasPlayerLost(i) == false) && (gPlayerTeam != kbGetPlayerTeam(i)))
			matchCount = matchCount + 1; // Enemy player, add to the count

		if (matchCount == position) return (i);
	}
	return (-1);
} //end getEnemyPlayerByTeamPosition

//==============================================================================
/*
	getClosestVPSite
	updatedOn 2022/07/03
	
	Returns the VPSiteID of the closest VP Site that matches the parms.
	-1 means don't care, everything matches.
	To get the closest site that has been claimed (building or complete) by an enemy,
	use cVPStateAny with playerRelationOrID set to cPlayerRelationEnemy.  (Unbuilt ones have gaia ownership)

	How to use
	Call getClosestVPSite() and pass the following parms
	vector location 
	int type
	int state 
	int playerRelationOrID
	
	Example
	int closestVPSite = getClosestVPSite(location, cVPAll, cVPStateAny, -1);
*/
//==============================================================================
int getClosestVPSite(vector location = cInvalidVector, int type = cVPAll, int state = cVPStateAny, int playerRelationOrID = -1)
{
	debugRule("int closestVPSite ",-0);
	int closestVPSite = -1;
	vector siteLocation = cInvalidVector;
	int vpList = kbVPSiteQuery(type, playerRelationOrID, state);
	int siteID = -1;
	float dist = 0.0;
	float minDist = 100000.0;
	int count = xsArrayGetSize(vpList);
	for (i = 0; < count)
	{
		siteID = xsArrayGetInt(vpList, i);
		siteLocation = kbVPSiteGetLocation(siteID);
		dist = distance(location, siteLocation);
		if (dist < minDist)
		{
			closestVPSite = siteID; // Remember this one.
			minDist = dist;
		}
	}
	return (closestVPSite);
} //end getClosestVPSite

//==============================================================================
/*
	getfarthestVPSite
	updatedOn 2022/07/03
	
	Returns the VPSiteID of the farthest VP Site that matches the parms.
	-1 means don't care, everything matches.
	To get the closest site that has been claimed (building or complete) by an enemy,
	use cVPStateAny with playerRelationOrID set to cPlayerRelationEnemy.  (Unbuilt ones have gaia ownership)

	How to use
	Call getfarthestVPSite() and pass the following parms
	vector location 
	int type
	int state 
	int playerRelationOrID
	
	Example
	int farthestVPSite = getClosestVPSite(location, cVPAll, cVPStateAny, -1);
*/
//==============================================================================
int getfarthestVPSite(vector location = cInvalidVector, int type = cVPAll, int state = cVPStateAny, int playerRelationOrID = -1)
{
	debugRule("int getfarthestVPSite ",-0);
	int farthestVPSite = -1;
	vector siteLocation = cInvalidVector;
	int vpList = kbVPSiteQuery(type, playerRelationOrID, state);
	int siteID = -1;
	float dist = 0.0;
	float minDist = 100000.0;
	int count = xsArrayGetSize(vpList);
	for (i = 0; < count)
	{
		siteID = xsArrayGetInt(vpList, i);
		siteLocation = kbVPSiteGetLocation(siteID);
		dist = distance(location, siteLocation);
		if (dist > minDist)
		{
			farthestVPSite = siteID; // Remember this one.
			minDist = dist;
		}
	}
	return (farthestVPSite);
} //end getfarthestVPSite

//==============================================================================
/*
	getAgingUp
	updatedOn 2022/07/04
	returns true when AI is in the process of aging up

	How to use
	call getAgingUp() true is aging
	
	Example
	bool isAging = getAgingUp();
*/
//==============================================================================
bool getAgingUp(void)
{ //checks if the ai is aging up
	debugRule("bool getAgingUp ",-0);
	//If the game time is the same return the saved value for that interval
	static int lastTimeCalled = -1;
	static bool returnValue = false;
	if(lastTimeCalled == gCurrentGameTime) return(returnValue); 
	lastTimeCalled = gCurrentGameTime;
	if (aiPlanGetState(gAgeUpResearchPlan) == cPlanStateResearch) 
	{
		returnValue = true;
		return (returnValue); //check plan Status of gAgeUpResearchPlan
	}
	returnValue = false;
	return (returnValue);
} //end getAgingUp

//==============================================================================
/*
	getBaseBuildingCount
	updatedOn 2022/07/04
	returns the number of building of type buildingType for player relocation

	How to use
	call getBaseBuildingCount() and pass the following prams
	int baseID 
	int playerRelation (cPlayerRelationAny,cPlayerRelationSelf,cPlayerRelationEnemy,cPlayerRelationAlly,cPlayerRelationEnemyNotGaia)
	int buildingType 
	
	Example
	int numberOfBuildings = getBaseBuildingCount(gMainBase,cPlayerRelationSelf,cUnitTypeBuilding);
*/
//==============================================================================
int getBaseBuildingCount(int baseID = -1, int playerRelation = -1, int buildingType = -1)
{
	debugRule("int getBaseBuildingCount ",-0);
	int retVal = -1;
	if (baseID < 0) return(retVal)
	retVal = kbBaseGetNumberUnits(kbBaseGetOwner(baseID), baseID, playerRelation, buildingType);
	return (retVal);
} //end getBaseBuildingCount

//==============================================================================
/*
	getMapID
	updatedOn 2022/07/06
	returns the mapID for the current game
	
	How to use
	call getMapID to return the map id
	
	Example
	int mapID = getMapID();
*/
//==============================================================================
int getMapID(void)
{
	debugRule("int getMapID ",-0);
	static int mapIndex = -1;
	if(mapIndex != -1) return(mapIndex); //mapID has been found, return saved value
	for (mapIndex = 0; < xsArrayGetSize(gMapNames))
	{ //find the map ID
		if (xsArrayGetString(gMapNames, mapIndex) == cRandomMapName) return (mapIndex);
	}
	return (-1);
} //end getMapID

//==============================================================================
/*
	getClassRating
	updatedOn 2022/07/18
	Get a class rating, 0.0 to 1.0, for this type of opportunity.
	Scores zero when an opportunity of this type was just launched.
	Scores 1.0 when it has been 'gXXXMissionInterval' time since the last one.
	
	How to use
	call getClassRating and pass the following prams
	int oppType - The OpportunityType
	int target - aiGetOpportunityTargetID(oppID)
	
	Example
	float classRating = getClassRating(cOpportunityTypeClaim, aiGetOpportunityTargetID(oppID));
*/
//==============================================================================
float getClassRating(int oppType = -1, int target = -1)
{
	debugRule("float getClassRating ",-0);
	float retVal = 1.0;
	float timeElapsed = 0.0;
	switch (oppType)
	{
		case cOpportunityTypeDestroy:
		{
			timeElapsed = gCurrentGameTime - gLastAttackMissionTime;
			retVal = 1.0 * (timeElapsed / gAttackMissionInterval);
			break;
		}
		case cOpportunityTypeDefend:
		{
			timeElapsed = gCurrentGameTime - gLastDefendMissionTime;
			retVal = 1.0 * (timeElapsed / gDefendMissionInterval);
			break;
		}
		case cOpportunityTypeClaim:
		{
			timeElapsed = gCurrentGameTime - gLastClaimMissionTime;
			if (kbVPSiteGetType(target) == cVPTrade)
			{
				if (btBiasTrade > 0.0)
					timeElapsed = timeElapsed * (1.0 + btBiasTrade); // Multiply by at least one, up to 2, i.e. btBiasTrade of 1.0 will double elapsed time.
				else
					timeElapsed = timeElapsed / ((-1.0 * btBiasTrade) + 1.0); // Divide by 1.00 up to 2.00, i.e. cut it in half if btBiasTrade = -1.0
				retVal = 1.0 * (timeElapsed / gClaimMissionInterval);
			}
			else // VPNative
			{
				if (btBiasNative > 0.0)
					timeElapsed = timeElapsed * (1.0 + btBiasNative); // Multiply by at least one, up to 2, i.e. btBiasNative of 1.0 will double elapsed time.
				else
					timeElapsed = timeElapsed / ((-1.0 * btBiasNative) + 1.0); // Divide by 1.00 up to 2.00, i.e. cut it in half if btBiasNative = -1.0
				retVal = 1.0 * (timeElapsed / gClaimMissionInterval);
			}
			break;
		}
	}
	if (retVal > 1.0) retVal = 1.0;
	if (retVal < 0.0) retVal = 0.0;
	return (retVal);
} //getClassRating

//==============================================================================
/*
	getBaseEnemyStrength
	updatedOn 2022/07/18
	Calculate an approximate rating for enemy strength in/near this base.
	
	How to use
	call getBaseEnemyStrength and pass the following prams
	int baseID
	
	Example
	float baseStrength = getBaseEnemyStrength(baseID);
*/
//==============================================================================
float getBaseEnemyStrength(int baseID = -1)
{
	debugRule("float getBaseEnemyStrength ",-0);
	if (baseID < 0) return (-1.0);
	int owner = kbBaseGetOwner(baseID);
	if (owner <= 0) return (-1.0);
	
	float retVal = 0.0;
	static int allyBaseQuery = -1;
	if (allyBaseQuery != -1) 
	{
		allyBaseQuery = kbUnitQueryCreate("Ally Base query"+getQueryId());
		kbUnitQuerySetIgnoreKnockedOutUnits(allyBaseQuery, true);
		kbUnitQuerySetPlayerID(allyBaseQuery,-1,false);
		kbUnitQuerySetPlayerRelation(allyBaseQuery, cPlayerRelationEnemyNotGaia);
		kbUnitQuerySetState(allyBaseQuery, cUnitStateABQ);
		kbUnitQuerySetUnitType(allyBaseQuery, cUnitTypeLogicalTypeLandMilitary);
	}
	kbUnitQueryResetResults(allyBaseQuery);

	if (kbIsPlayerEnemy(owner) == true)
	{ // Enemy base, add up military factors normally
		retVal = retVal + (0.1 * kbBaseGetNumberUnits(owner, baseID, cPlayerRelationEnemyNotGaia, cUnitTypeAbstractWall)); // 0.1 wall
		retVal = retVal + (0.5 * kbBaseGetNumberUnits(owner, baseID, cPlayerRelationEnemyNotGaia, cUnitTypeLogicalTypeLandMilitary)); // 0.5 point per soldier
		retVal = retVal + (3.0 * kbBaseGetNumberUnits(owner, baseID, cPlayerRelationEnemyNotGaia, gTowerUnit)); // 3 points per towerUnit
		retVal = retVal + (5.0 * kbBaseGetNumberUnits(owner, baseID, cPlayerRelationEnemyNotGaia, gTownCenter)); // 5 points per TC
		retVal = retVal + (5.0 * kbBaseGetNumberUnits(owner, baseID, cPlayerRelationEnemyNotGaia, gBarracksUnit)); // 5 points
		retVal = retVal + (5.0 * kbBaseGetNumberUnits(owner, baseID, cPlayerRelationEnemyNotGaia, gStableUnit)); // 5 points
		retVal = retVal + (5.0 * kbBaseGetNumberUnits(owner, baseID, cPlayerRelationEnemyNotGaia, gArtilleryDepotUnit)); // 5 points
		retVal = retVal + (5.0 * kbBaseGetNumberUnits(owner, baseID, cPlayerRelationEnemyNotGaia, cUnitTypeypWIAgraFort2)); // 5 points per agra fort
		retVal = retVal + (5.0 * kbBaseGetNumberUnits(owner, baseID, cPlayerRelationEnemyNotGaia, cUnitTypeypWIAgraFort3));
		retVal = retVal + (5.0 * kbBaseGetNumberUnits(owner, baseID, cPlayerRelationEnemyNotGaia, cUnitTypeypWIAgraFort4));
		retVal = retVal + (5.0 * kbBaseGetNumberUnits(owner, baseID, cPlayerRelationEnemyNotGaia, cUnitTypeypWIAgraFort5));
		retVal = retVal + (5.0 * kbBaseGetNumberUnits(owner, baseID, cPlayerRelationEnemyNotGaia, gTradingPostUnit)); // 5 points per trading post (Advanced TP suspected!)
		retVal = retVal + (10.0 * kbBaseGetNumberUnits(owner, baseID, cPlayerRelationEnemy, cUnitTypeFortFrontier)); // 10 points per fort
	}
	else
	{ // Ally base, we're considering defending.  Count enemy units present
		kbUnitQuerySetPosition(allyBaseQuery, kbBaseGetLocation(owner, baseID));
		kbUnitQuerySetMaximumDistance(allyBaseQuery, 55.0);
		retVal = kbUnitQueryExecute(allyBaseQuery);
	}
	if (retVal < 1.0) retVal = 1.0; // Return at least 1.
	return (retVal);
} //getBaseEnemyStrength


//==============================================================================
/*
	getPointEnemyStrength
	updatedOn 2022/07/18
	Calculate an approximate strength rating for the enemy units/buildings near this point.
	
	How to use
	call getBaseEnemyStrength and pass the following prams
	vector loc
	
	Example
	float pointStrength = getPointEnemyStrength(cInvalidVector);
*/
//==============================================================================
float getPointEnemyStrength(vector loc = cInvalidVector)
{
	float retVal = 0.0;
	static int enemyPointQuery = -1;

	if (enemyPointQuery != -1) 
	{
		enemyPointQuery = kbUnitQueryCreate("Enemy Point query"+getQueryId());
		kbUnitQuerySetIgnoreKnockedOutUnits(enemyPointQuery, true);
		kbUnitQuerySetPlayerID(enemyPointQuery,-1,false);
		kbUnitQuerySetPlayerRelation(enemyPointQuery, cPlayerRelationEnemyNotGaia);
		kbUnitQuerySetState(enemyPointQuery, cUnitStateABQ);
		kbUnitQuerySetUnitType(enemyPointQuery, cUnitTypeLogicalTypeLandMilitary);
	}
	kbUnitQueryResetResults(enemyPointQuery);

	kbUnitQuerySetPosition(enemyPointQuery, loc);
	kbUnitQuerySetMaximumDistance(enemyPointQuery, 50.0);
	retVal = retVal + 0.5 * kbUnitQueryExecute(enemyPointQuery);
	
	kbUnitQuerySetUnitType(enemyPointQuery, cUnitTypeAbstractWall);
	kbUnitQueryResetResults(enemyPointQuery);
	retVal = retVal + 0.1 * kbUnitQueryExecute(enemyPointQuery);

	kbUnitQuerySetUnitType(enemyPointQuery, gTowerUnit);
	kbUnitQueryResetResults(enemyPointQuery);
	retVal = retVal + 3.0 * kbUnitQueryExecute(enemyPointQuery);

	kbUnitQuerySetUnitType(enemyPointQuery, gTownCenter);
	kbUnitQueryResetResults(enemyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(enemyPointQuery);

	kbUnitQuerySetUnitType(enemyPointQuery, gBarracksUnit);
	kbUnitQueryResetResults(enemyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(enemyPointQuery);

	kbUnitQuerySetUnitType(enemyPointQuery, gStableUnit);
	kbUnitQueryResetResults(enemyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(enemyPointQuery);

	kbUnitQuerySetUnitType(enemyPointQuery, gArtilleryDepotUnit);
	kbUnitQueryResetResults(enemyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(enemyPointQuery);

	kbUnitQuerySetUnitType(enemyPointQuery, cUnitTypeypWIAgraFort2);
	kbUnitQueryResetResults(enemyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(enemyPointQuery); // An agra fort counts as 5 units 

	kbUnitQuerySetUnitType(enemyPointQuery, cUnitTypeypWIAgraFort3);
	kbUnitQueryResetResults(enemyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(enemyPointQuery); // An agra fort counts as 5 units 

	kbUnitQuerySetUnitType(enemyPointQuery, cUnitTypeypWIAgraFort4);
	kbUnitQueryResetResults(enemyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(enemyPointQuery); // An agra fort counts as 5 units 

	kbUnitQuerySetUnitType(enemyPointQuery, cUnitTypeypWIAgraFort5);
	kbUnitQueryResetResults(enemyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(enemyPointQuery); // An agra fort counts as 5 units 

	kbUnitQuerySetUnitType(enemyPointQuery, gTradingPostUnit);
	kbUnitQueryResetResults(enemyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(enemyPointQuery); // Each fort counts as 10 units

	kbUnitQuerySetUnitType(enemyPointQuery, gTradingPostUnit);
	kbUnitQueryResetResults(enemyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(enemyPointQuery); // Each fort counts as 10 units

	kbUnitQuerySetUnitType(enemyPointQuery, cUnitTypeFortFrontier);
	kbUnitQueryResetResults(enemyPointQuery);
	retVal = retVal + 10.0 * kbUnitQueryExecute(enemyPointQuery); // Each fort counts as 10 units

	if (retVal < 1.0) retVal = 1.0; // Return at least 1.
	return (retVal);
} //end getPointEnemyStrength


//==============================================================================
/*
	getPointAllyStrength
	updatedOn 2022/07/18
	Calculate an approximate strength rating for the allied units/buildings near this point.
	
	How to use
	call getPointAllyStrength and pass the following prams
	vector loc
	
	Example
	float pointAllyStrength = getPointAllyStrength(cInvalidVector);
*/
//==============================================================================
float getPointAllyStrength(vector loc = cInvalidVector)
{
	float retVal = 0.0;
	static int allyPointQuery = -1;

	if (allyPointQuery < 0) 
	{
		allyPointQuery = kbUnitQueryCreate("Ally Point query 2"+getQueryId());
		kbUnitQuerySetIgnoreKnockedOutUnits(allyPointQuery, true);
		kbUnitQuerySetPlayerID(allyPointQuery,-1,false);
		kbUnitQuerySetPlayerRelation(allyPointQuery, cPlayerRelationAlly);
		kbUnitQuerySetState(allyPointQuery, cUnitStateABQ);
		kbUnitQuerySetUnitType(allyPointQuery, cUnitTypeLogicalTypeLandMilitary);		
	}
	kbUnitQueryResetResults(allyPointQuery);

	kbUnitQuerySetPosition(allyPointQuery, loc);
	kbUnitQuerySetMaximumDistance(allyPointQuery, 50.0);
	retVal = kbUnitQueryExecute(allyPointQuery);

	kbUnitQuerySetUnitType(allyPointQuery, cUnitTypeAbstractWall);
	kbUnitQueryResetResults(allyPointQuery);
	retVal = retVal + 0.1 * kbUnitQueryExecute(allyPointQuery);

	kbUnitQuerySetUnitType(allyPointQuery, gTowerUnit);
	kbUnitQueryResetResults(allyPointQuery);
	retVal = retVal + 3.0 * kbUnitQueryExecute(allyPointQuery);

	kbUnitQuerySetUnitType(allyPointQuery, gTownCenter);
	kbUnitQueryResetResults(allyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(allyPointQuery);

	kbUnitQuerySetUnitType(allyPointQuery, gBarracksUnit);
	kbUnitQueryResetResults(allyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(allyPointQuery);

	kbUnitQuerySetUnitType(allyPointQuery, gStableUnit);
	kbUnitQueryResetResults(allyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(allyPointQuery);

	kbUnitQuerySetUnitType(allyPointQuery, gArtilleryDepotUnit);
	kbUnitQueryResetResults(allyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(allyPointQuery);

	kbUnitQuerySetUnitType(allyPointQuery, cUnitTypeypWIAgraFort2);
	kbUnitQueryResetResults(allyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(allyPointQuery); // An agra fort counts as 5 units 

	kbUnitQuerySetUnitType(allyPointQuery, cUnitTypeypWIAgraFort3);
	kbUnitQueryResetResults(allyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(allyPointQuery); // An agra fort counts as 5 units 

	kbUnitQuerySetUnitType(allyPointQuery, cUnitTypeypWIAgraFort4);
	kbUnitQueryResetResults(allyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(allyPointQuery); // An agra fort counts as 5 units 

	kbUnitQuerySetUnitType(allyPointQuery, cUnitTypeypWIAgraFort5);
	kbUnitQueryResetResults(allyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(allyPointQuery); // An agra fort counts as 5 units 

	kbUnitQuerySetUnitType(allyPointQuery, gTradingPostUnit);
	kbUnitQueryResetResults(allyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(allyPointQuery); // Each fort counts as 10 units

	kbUnitQuerySetUnitType(allyPointQuery, gTradingPostUnit);
	kbUnitQueryResetResults(allyPointQuery);
	retVal = retVal + 5.0 * kbUnitQueryExecute(allyPointQuery); // Each fort counts as 10 units

	kbUnitQuerySetUnitType(allyPointQuery, cUnitTypeFortFrontier);
	kbUnitQueryResetResults(allyPointQuery);
	retVal = retVal + 10.0 * kbUnitQueryExecute(allyPointQuery); // Each fort counts as 10 units
	
	if (retVal < 1.0) retVal = 1.0; // Return at least 1.
	return (retVal);
} //end getPointAllyStrength

//==============================================================================
/*
	getPointAllyStrength
	updatedOn 2022/07/19
	Calculate an approximate value for this base.
	
	How to use
	call getBaseValue and pass the following prams
	int baseID
	
	Example
	float beseValue = getBaseValue(baseID);
*/
//==============================================================================
float getBaseValue(int baseID = -1)
{
	float retVal = 0.0;
	int owner = kbBaseGetOwner(baseID);
	int relation = -1;
	if (baseID < 0) return (-1.0);
	if (owner <= 0) return (-1.0);

	if (kbIsPlayerAlly(owner) == true)
		relation = cPlayerRelationAlly;
	else
		relation = cPlayerRelationEnemyNotGaia;

	retVal = retVal + (200.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeLogicalTypeBuildingsNotWalls));
	retVal = retVal + (1000.0 * kbBaseGetNumberUnits(owner, baseID, relation, gTownCenter)); // 1000 points extra per TC
	retVal = retVal + (600.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypePlantation)); // 600 points extra per plantation
	retVal = retVal + (2000.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeFortFrontier)); // 2000 points extra per fort
	retVal = retVal + (150.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeLogicalTypeLandMilitary)); // 150 points per soldier
	retVal = retVal + (200.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeSettler)); // 200 points per settler
	retVal = retVal + (200.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeCoureur)); // 200 points per coureur
	retVal = retVal + (200.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeCoureurCree)); // 200 points per cree coureur
	retVal = retVal + (200.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeSettlerNative)); // 200 points per native settler
	retVal = retVal + (200.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeypSettlerAsian)); // 200 points per Asian settler
	retVal = retVal + (200.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeypSettlerIndian)); // 200 points per Indian settler
	retVal = retVal + (200.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeypSettlerJapanese)); // 200 points per Japanese settler
	retVal = retVal + (200.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeSettlerDutch)); // 200 points per Swedish settler
	retVal = retVal + (200.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeSettlerOttoman)); // 200 points per Swedish settler
	retVal = retVal + (200.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeSettlerWagon)); // 300 points per settler wagon
	retVal = retVal + (1000.0 * kbBaseGetNumberUnits(owner, baseID, relation, gTradingPostUnit)); // 1000 points per trading post
	retVal = retVal + (800.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeFactory)); // 800 points extra per factory
	retVal = retVal + (300.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeBank)); // 300 points extra per bank
	retVal = retVal + (200.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeMill)); // 200 points extra per mill
	retVal = retVal + (200.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeFarm)); // 200 points extra per farm
	retVal = retVal + (200.0 * kbBaseGetNumberUnits(owner, baseID, relation, cUnitTypeypRicePaddy)); // 200 points extra per rice paddy

	if (retVal < 1.0) retVal = 1.0; // Return at least 1.
	return (retVal);
} //end getBaseValue


//==============================================================================
/*
	getPointValue
	updatedOn 2022/07/19
	Calculate an approximate value for the playerRelation units/buildings near this point.
	I.e. if playerRelation is enemy, calculate strength of enemy units and buildings.
	
	How to use
	call getPointValue and pass the following prams
	vector loc	
	int relation
	
	Example
	float pointValue = getBaseValue(location, relation);
*/
//==============================================================================
float getPointValue(vector loc = cInvalidVector, int relation = cPlayerRelationEnemyNotGaia)
{
	float retVal = 0.0;
	static int allyQuery = -1;
	static int enemyQuery = -1;
	int queryID = -1; // Use either enemy or ally query as needed.

	if (allyQuery < 0)
	{
		allyQuery = kbUnitQueryCreate("Ally point value query"+getQueryId());
		kbUnitQuerySetIgnoreKnockedOutUnits(allyQuery, true);
		kbUnitQuerySetPlayerID(allyQuery,-1,false);
		kbUnitQuerySetPlayerRelation(allyQuery, cPlayerRelationAlly);
		kbUnitQuerySetState(allyQuery, cUnitStateABQ);
	}
	if (enemyQuery < 0)
	{
		enemyQuery = kbUnitQueryCreate("Enemy point value query"+getQueryId());
		kbUnitQuerySetIgnoreKnockedOutUnits(enemyQuery, true);
		kbUnitQuerySetPlayerID(enemyQuery,-1,false);
		kbUnitQuerySetPlayerRelation(enemyQuery, cPlayerRelationEnemyNotGaia);
		kbUnitQuerySetSeeableOnly(enemyQuery, true);
		kbUnitQuerySetState(enemyQuery, cUnitStateAlive);
	}
	if ((relation == cPlayerRelationEnemy) || (relation == cPlayerRelationEnemyNotGaia))
		queryID = enemyQuery;
	else
		queryID = allyQuery;

	kbUnitQueryResetResults(queryID);
	kbUnitQuerySetUnitType(queryID, cUnitTypeLogicalTypeBuildingsNotWalls);
	kbUnitQueryResetResults(queryID);
	retVal = 200.0 * kbUnitQueryExecute(queryID); // 200 points per building

	kbUnitQuerySetUnitType(queryID, gTownCenter);
	kbUnitQueryResetResults(queryID);
	retVal = retVal + 1000.0 * kbUnitQueryExecute(queryID); // Extra 1000 per TC

	kbUnitQuerySetUnitType(queryID, gTradingPostUnit);
	kbUnitQueryResetResults(queryID);
	retVal = retVal + 1000.0 * kbUnitQueryExecute(queryID); // Extra 1000 per trading post

	kbUnitQuerySetUnitType(queryID, cUnitTypeFactory);
	kbUnitQueryResetResults(queryID);
	retVal = retVal + 800.0 * kbUnitQueryExecute(queryID); // Extra 800 per factory

	kbUnitQuerySetUnitType(queryID, cUnitTypePlantation);
	kbUnitQueryResetResults(queryID);
	retVal = retVal + 600.0 * kbUnitQueryExecute(queryID); // Extra 600 per plantation

	kbUnitQuerySetUnitType(queryID, cUnitTypeBank);
	kbUnitQueryResetResults(queryID);
	retVal = retVal + 300.0 * kbUnitQueryExecute(queryID); // Extra 300 per bank

	kbUnitQuerySetUnitType(queryID, cUnitTypeMill);
	kbUnitQueryResetResults(queryID);
	retVal = retVal + 200.0 * kbUnitQueryExecute(queryID); // Extra 200 per mill

	kbUnitQuerySetUnitType(queryID, cUnitTypeFarm);
	kbUnitQueryResetResults(queryID);
	retVal = retVal + 200.0 * kbUnitQueryExecute(queryID); // Extra 200 per farm

	kbUnitQuerySetUnitType(queryID, cUnitTypeypRicePaddy);
	kbUnitQueryResetResults(queryID);
	retVal = retVal + 200.0 * kbUnitQueryExecute(queryID); // Extra 200 per rice paddy

	kbUnitQuerySetUnitType(queryID, cUnitTypeSPCXPMiningCamp);
	kbUnitQueryResetResults(queryID);
	retVal = retVal + 1000.0 * kbUnitQueryExecute(queryID); // Extra 1000 per SPC mining camp for XPack scenario

	kbUnitQuerySetUnitType(queryID, cUnitTypeUnit);
	kbUnitQueryResetResults(queryID);
	retVal = retVal + 200.0 * kbUnitQueryExecute(queryID); // 200 per unit.

	if (retVal < 1.0) retVal = 1.0;
	return (retVal);
} //end getPointValue

bool getIsPlayerAlive(int player = -1)
{
	static bool pPlayerOut = false;
	if(pPlayerOut == true) return(false);
	if(kbIsPlayerResigned(player) || kbHasPlayerLost(player)) 
	{
		pPlayerOut = true;
		return(false);
	}
	return(true);
}

/* REMOVED because not used
int kbUnitGetResourceType(int unitID = -1)
{
	if (kbUnitIsType(unitID, cUnitTypeGold) == true)
		return (cResourceGold);
	else if (kbUnitIsType(unitID, cUnitTypeMill) == true)
		return (cResourceFood);
	else if (kbUnitIsType(unitID, cUnitTypeFarm) == true)
		return (cResourceFood);
	else if (kbUnitIsType(unitID, cUnitTypeypRicePaddy) == true)
	{
		if (aiUnitGetTactic(unitID) == cTacticPaddyFood)
			return (cResourceFood);
		else
			return (cResourceGold);
	}
	else if (kbUnitIsType(unitID, cUnitTypeWood) == true)
		return (cResourceWood);
	if (kbUnitIsType(unitID, cUnitTypeHuntable) == true)
	{
		if (cMyCiv != cCivJapanese)
			return (cResourceFood);
		else
			return (-1);
	}
	else if (kbUnitIsType(unitID, cUnitTypeHerdable) == true)
	{
		if (cMyCiv == cCivIndians)
			return (-1);
		else if (cMyCiv == cCivJapanese)
			return (-1);
		return (cResourceFood);
	}
	else if (kbUnitIsType(unitID, cUnitTypeAbstractFruit) == true)
		return (cResourceFood);
	return (-1);
}
int kbUnitGetWorkerLimit(int resourceID = -1)
{
	if (kbUnitIsType(resourceID, cUnitTypeBuilding) == true)
		return (10 - kbUnitGetNumberWorkers(resourceID));

	vector v = kbUnitGetPosition(resourceID);

	if (kbUnitIsType(resourceID, cUnitTypeAbstractResourceCrate) == true)
		return (1 - COUNTAT(gEconUnit, cMyID, v, 4.0));

	else if (kbUnitIsType(resourceID, cUnitTypeTree) == true)
		return (8 - COUNTAT(gEconUnit, cPlayerRelationAny, v, 6.0));

	else if (kbUnitIsType(resourceID, cUnitTypeBerryBush) == true)
		return (8 - COUNTAT(gEconUnit, cPlayerRelationAny, v, 6.0));

	else if (kbUnitIsType(resourceID, cUnitTypeMinedResource) == true)
		return (20 - COUNTAT(gEconUnit, cPlayerRelationAny, v, 7.5));

	else if (kbUnitIsType(resourceID, cUnitTypeAnimalPrey) == true)
	{
		if (COUNTAT(cUnitTypeAbstractShrine, cPlayerRelationAny, v, 16.0) > 0)
			return (0);
		else
			return (8 - COUNTAT(gEconUnit, cPlayerRelationAny, v, 5.0));
	}

	return (1);
}
*/
bool getIsAnimalGathered(int pUnitId = -1)
{
	static int pPlayerId = -1;
	pPlayerId = cMyID;
	xsSetContextPlayer(0);
	if(kbUnitGetTargetUnitID(pUnitId) != -1) 
	{
		xsSetContextPlayer(pPlayerId);
		return(true);
	}
	xsSetContextPlayer(pPlayerId);
	return(false);
}

//==============================================================================
/*
	getUnitAtBuildLimit
	updatedOn 2023/03/18
	Checks if a unitType is at the build limit
	
	How to use
	call getUnitTypeAtBuildLimit and pass a unitType value, it will return true or false
	
	Example
	bool limit = getUnitTypeAtBuildLimit(cUnitTypeFactory);
*/
//==============================================================================
/*
bool getUnitTypeAtBuildLimit(int pUnitType = -1)
{
	
	static int pArrayVal = -1;
	pArrayVal = xsArrayGetInt(gBuildLimitArray,pUnitType);
	if(pArrayVal == -1) return(false);
	else if(pArrayVal == -2)
	{
		if(kbUnitCount(cMyID, pUnitType, cUnitStateABQ) >= kbGetBuildLimit(cMyID, pUnitType)) return(true);
	}
	else
	{
		if(kbUnitCount(cMyID, pUnitType, cUnitStateABQ) >= pArrayVal) return(true);
	}
	return(false);
	
}
*/
bool getUnitTypeAtBuildLimit(int pUnitType = -1)
{
	if(kbGetBuildLimit(cMyID, pUnitType) == -1)return(false);
	if(kbUnitCount(cMyID, pUnitType, cUnitStateABQ) >= kbGetBuildLimit(cMyID, pUnitType)) return(true);
	return(false);
}
   
bool getWagonBuildCheck(int pUnitType = -1, int pWagonType = -1)
{
    static int pUnitQry = -1;
    static int pUnitNum = -1;
    static int pUnitId = -1;

	if(getUnitTypeAtBuildLimit(pUnitType) == true) return(true);
    if (pUnitQry == -1) 
	{ //Qry to find all enemy land units
        pUnitQry = kbUnitQueryCreate("getWagonBuildCheck"+getQueryId());
		kbUnitQuerySetPlayerID(pUnitQry,cMyID,false);
		kbUnitQuerySetPlayerRelation(pUnitQry, -1);
		kbUnitQuerySetIgnoreKnockedOutUnits(pUnitQry, true);
		kbUnitQuerySetState(pUnitQry, cUnitStateAlive);
	} //end if
	kbUnitQueryResetResults(pUnitQry);
	kbUnitQuerySetUnitType(pUnitQry, pWagonType);
	pUnitNum = kbUnitQueryExecute(pUnitQry);

    for(i = 0; < pUnitNum)
    {
        pUnitId =  kbUnitQueryGetResult(pUnitQry, i);
        if(kbUnitGetActionType(pUnitId) != 7 || kbUnitGetPlanID(pUnitId) != -1) 
		{
			return(false);
		}
    }
	return(true);
	
}

bool getUnitAdequateResources(int pUnitId = -1)
{
	static int pWoodCost = -1;
	static int pGoldCost = -1;
	static int pFoodCost = -1;
	pWoodCost = kbUnitCostPerResource(pUnitId, cResourceWood);
	pGoldCost = kbUnitCostPerResource(pUnitId, cResourceFood);
	pFoodCost = kbUnitCostPerResource(pUnitId, cResourceGold);
	//aiLog("getUnitAdequateResources " + pUnitId);
	if(gCurrentWood < pWoodCost || 
	gCurrentFood < pGoldCost || 
	gCurrentCoin < pFoodCost)
	{
		//aiLog("getUnitAdequateResources cannot build " + pUnitId + " wood forcasted " +  xsArrayGetFloat(gForecasts, cResourceWood));
		if(xsArrayGetFloat(gForecasts, cResourceWood) < pWoodCost)
		{
			//aiLog("getUnitAdequateResources add wood Forecast");
			xsArraySetFloat(gForecasts, cResourceWood, xsArrayGetFloat(gForecasts, cResourceWood) + kbUnitCostPerResource(pUnitId, cResourceWood));
		}
		return(false);
	}
	//aiLog("getUnitAdequateResources can build " + pUnitId);
	return(true);
}

//==============================================================================
/*
	getBuildable
	updatedOn 2023/03/18
	Checks if a building is able to be built
	
	How to use
	call getBuildable and pass a unitType value, it will return true or false
	
	Example
	bool caniBuild = getBuildable(cUnitTypeOutpost);
*/
//==============================================================================
bool getBuildable(int pUnitId = -1)
{

	//("getBuildable " + pUnitId);
	if(getUnitTypeAtBuildLimit(pUnitId) == true) 
	{
		//aiLog("getBuildable getUnitTypeAtBuildLimit at limit");
		return(false);
	}
	if(kbProtoUnitAvailable(pUnitId) == false)
	{
		//aiLog("getBuildable kbProtoUnitAvailable failed");
		return(false);
	}
	if(getUnitAdequateResources(pUnitId) == false)
	{
		//aiLog("getBuildable getUnitAdequateResources failed");
		return(false);
	}
	//aiLog("getBuildable passed " + pUnitId);
	return(true);
}


//==============================================================================
/*
	getNearestSettler
	updatedOn 2024/02/02
	Finds a nearby settler
	
	How to use
	call getNearestSettler and pass a vector value, it will return a nearby settler
	
	Example
	int mySettler = getNearestSettler(pLocation);
*/
//==============================================================================
int getNearestSettler(vector pLocation = cInvalidVector)
{
	static int pSettlerId = -1;
	static float pSettlerDist = -1.0;
	static float pDist = 0.0;
	static int pNearestSettler = -1;
	pSettlerId = -1;
	pSettlerDist = -1.0;
	pDist = 0.0;
	pNearestSettler = -1;

	static int pSettlersQuery = -1;
	if (pSettlersQuery == -1) 
	{
		pSettlersQuery = kbUnitQueryCreate("pSettlersQuery"+getQueryId());
		kbUnitQuerySetPlayerID(pSettlersQuery, cMyID, false);
		kbUnitQuerySetPlayerRelation(pSettlersQuery, -1);
		kbUnitQuerySetState(pSettlersQuery, cUnitStateAlive);
		kbUnitQuerySetUnitType(pSettlersQuery, cUnitTypeAffectedByTownBell);
	}
	kbUnitQueryResetResults(pSettlersQuery); //reset results

	for(i = 0; < kbUnitQueryExecute(pSettlersQuery))
	{
		pSettlerId = kbUnitQueryGetResult(pSettlersQuery, i);
		if(kbUnitIsType(pSettlerId,cUnitTypeGoldMiner)) continue;
		
		if(kbUnitGetActionType(pSettlerId) == 0 )  continue;
		if(kbUnitGetActionType(pSettlerId) == 9 )  continue;
		if(kbUnitGetActionType(pSettlerId) == 15 )  continue;
		if(kbUnitGetActionType(pSettlerId) == 3 )  continue;
		if(getEnemyUnitPathStatus(kbUnitGetPosition(pSettlerId),pLocation) > 1) continue;
		if(checkExcludeSettler(pSettlerId))continue;
		
		pDist = distance(kbUnitGetPosition(pSettlerId),pLocation);
		if(pSettlerDist > pDist || pSettlerDist == -1.0)
		{
			pSettlerDist = pDist;
			pNearestSettler = pSettlerId;
		}
		
	}
	return(pNearestSettler);
}




void getMethodsMain(void)
{

}
