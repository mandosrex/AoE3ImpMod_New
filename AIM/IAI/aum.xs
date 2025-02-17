//ageUpMethods
//==============================================================================
// chooseEuropeanPolitician
// Selects a politician for European civs
// updatedOn 2022/02/16 By ageekhere
//==============================================================================

int chooseColombiansPolitician()
{
	//new chooseColombiansPolitician
	static int politician = -1;
	static int age = -1;
	//more logic can be used to decided the best Politician to use
	switch (gCurrentAge)
	{
		case cAge1:
		{
			if (kbBaseGetUnderAttack(cMyID, kbBaseGetMainID(cMyID)) == true)
			{	
				xsArraySetInt(gAge2ColombiansPoliticianList, 0, cTechPoliticianPanama2);
				xsArraySetInt(gAge2ColombiansPoliticianList, 1, cTechPoliticianVenezuela2);
				xsArraySetInt(gAge2ColombiansPoliticianList, 2, cTechPoliticianCundinamarca2 );
				xsArraySetInt(gAge2ColombiansPoliticianList, 3, cTechPoliticianEcuador2);
			}
			for (i = 0; < xsArrayGetSize(gAge2ColombiansPoliticianList))
			{
				if (kbTechGetStatus(xsArrayGetInt(gAge2ColombiansPoliticianList, i)) == cTechStatusObtainable)
				{
					politician = xsArrayGetInt(gAge2ColombiansPoliticianList, i);
					age = cAge2;
					break;
				}
			}
			break;
		}	
		case cAge2:
		{
			if (kbBaseGetUnderAttack(cMyID, kbBaseGetMainID(cMyID)) == true)
			{
				xsArraySetInt(gAge3ColombiansPoliticianList, 0, cTechPoliticianPanama3);
				xsArraySetInt(gAge3ColombiansPoliticianList, 1, cTechPoliticianVenezuela3);
				xsArraySetInt(gAge3ColombiansPoliticianList, 2, cTechPoliticianCundinamarca3);
				xsArraySetInt(gAge3ColombiansPoliticianList, 3, cTechPoliticianEcuador3);
			}
			for (i = 0; < xsArrayGetSize(gAge3ColombiansPoliticianList))
			{
				if (kbTechGetStatus(xsArrayGetInt(gAge3ColombiansPoliticianList, i)) == cTechStatusObtainable)
				{
					politician = xsArrayGetInt(gAge3ColombiansPoliticianList, i);
					age = cAge3;
					break;
				}
			}
			break;
		}
		
		case cAge3:
		{
			if (kbBaseGetUnderAttack(cMyID, kbBaseGetMainID(cMyID)) == true)
			{
				xsArraySetInt(gAge4ColombiansPoliticianList, 0, cTechPoliticianPanama4);
				xsArraySetInt(gAge4ColombiansPoliticianList, 1, cTechPoliticianVenezuela4);
				xsArraySetInt(gAge4ColombiansPoliticianList, 2, cTechPoliticianCundinamarca4);
				xsArraySetInt(gAge4ColombiansPoliticianList, 3, cTechPoliticianEcuador4);
			}
			for (i = 0; < xsArrayGetSize(gAge4ColombiansPoliticianList))
			{
				if (kbTechGetStatus(xsArrayGetInt(gAge4ColombiansPoliticianList, i)) == cTechStatusObtainable)
				{
					politician = xsArrayGetInt(gAge4ColombiansPoliticianList, i);
					age = cAge4;
					break;
				}
			}
			break;
		}
		
		case cAge4:
		{
			if (kbBaseGetUnderAttack(cMyID, kbBaseGetMainID(cMyID)) == true)
			{	
				xsArraySetInt(gAge5ColombiansPoliticianList, 0, cTechPoliticianPanama5);
				xsArraySetInt(gAge5ColombiansPoliticianList, 1, cTechPoliticianVenezuela5);
				xsArraySetInt(gAge5ColombiansPoliticianList, 2, cTechPoliticianCundinamarca5);
				xsArraySetInt(gAge5ColombiansPoliticianList, 3, cTechPoliticianEcuador5);
			}
			for (i = 0; < xsArrayGetSize(gAge5ColombiansPoliticianList))
			{
				if (kbTechGetStatus(xsArrayGetInt(gAge5ColombiansPoliticianList, i)) == cTechStatusObtainable)
				{
					politician = xsArrayGetInt(gAge5ColombiansPoliticianList, i);
					age = cAge5;
					break;
				}
			}
			break;
		}
		
	}
	aiSetPoliticianChoice(age, politician);
	return (politician);
}

int chooseUSAPolitician()
{
	//new chooseUSAPolitician
	static int politician = -1;
	static int age = -1;
	//more logic can be used to decided the best Politician to use
	switch (gCurrentAge)
	{
		case cAge1:
		{
			if (kbBaseGetUnderAttack(cMyID, kbBaseGetMainID(cMyID)) == true)
			{	
				xsArraySetInt(gAge2USAPoliticianList, 0, cTechPoliticianFlorida2);
				xsArraySetInt(gAge2USAPoliticianList, 1, cTechPoliticianCalifornia2);
				xsArraySetInt(gAge2USAPoliticianList, 2, cTechPoliticianVermont2 );
				xsArraySetInt(gAge2USAPoliticianList, 3, cTechPoliticianTexas2);
			}
			for (i = 0; < xsArrayGetSize(gAge2USAPoliticianList))
			{
				if (kbTechGetStatus(xsArrayGetInt(gAge2USAPoliticianList, i)) == cTechStatusObtainable)
				{
					politician = xsArrayGetInt(gAge2USAPoliticianList, i);
					age = cAge2;
					break;
				}
			}
			break;
		}	
		case cAge2:
		{
			if (kbBaseGetUnderAttack(cMyID, kbBaseGetMainID(cMyID)) == true)
			{
				xsArraySetInt(gAge3USAPoliticianList, 0, cTechPoliticianFlorida3);
				xsArraySetInt(gAge3USAPoliticianList, 1, cTechPoliticianCalifornia3);
				xsArraySetInt(gAge3USAPoliticianList, 2, cTechPoliticianVermont3);
				xsArraySetInt(gAge3USAPoliticianList, 3, cTechPoliticianTexas3);
			}
			for (i = 0; < xsArrayGetSize(gAge3USAPoliticianList))
			{
				if (kbTechGetStatus(xsArrayGetInt(gAge3USAPoliticianList, i)) == cTechStatusObtainable)
				{
					politician = xsArrayGetInt(gAge3USAPoliticianList, i);
					age = cAge3;
					break;
				}
			}
			break;
		}
		
		case cAge3:
		{
			if (kbBaseGetUnderAttack(cMyID, kbBaseGetMainID(cMyID)) == true)
			{
				xsArraySetInt(gAge4USAPoliticianList, 0, cTechPoliticianFlorida4);
				xsArraySetInt(gAge4USAPoliticianList, 1, cTechPoliticianCalifornia4);
				xsArraySetInt(gAge4USAPoliticianList, 2, cTechPoliticianVermont4);
				xsArraySetInt(gAge4USAPoliticianList, 3, cTechPoliticianTexas4);
			}
			for (i = 0; < xsArrayGetSize(gAge4USAPoliticianList))
			{
				if (kbTechGetStatus(xsArrayGetInt(gAge4USAPoliticianList, i)) == cTechStatusObtainable)
				{
					politician = xsArrayGetInt(gAge4USAPoliticianList, i);
					age = cAge4;
					break;
				}
			}
			break;
		}
		
		case cAge4:
		{
			if (kbBaseGetUnderAttack(cMyID, kbBaseGetMainID(cMyID)) == true)
			{	
				xsArraySetInt(gAge5USAPoliticianList, 0, cTechPoliticianFlorida5);
				xsArraySetInt(gAge5USAPoliticianList, 1, cTechPoliticianCalifornia5);
				xsArraySetInt(gAge5USAPoliticianList, 2, cTechPoliticianVermont5);
				xsArraySetInt(gAge5USAPoliticianList, 3, cTechPoliticianTexas5);
			}
			for (i = 0; < xsArrayGetSize(gAge5USAPoliticianList))
			{
				if (kbTechGetStatus(xsArrayGetInt(gAge5USAPoliticianList, i)) == cTechStatusObtainable)
				{
					politician = xsArrayGetInt(gAge5USAPoliticianList, i);
					age = cAge5;
					break;
				}
			}
			break;
		}
		
	}
	aiSetPoliticianChoice(age, politician);
	return (politician);
}



int chooseEuropeanPolitician()
{
	//new chooseEuropeanPolitician
	static int politician = -1;
	static int age = -1;
	//more logic can be used to decided the best Politician to use
	switch (gCurrentAge)
	{
		case cAge1:
		{
			if (kbBaseGetUnderAttack(cMyID, kbBaseGetMainID(cMyID)) == true)
			{	
				xsArraySetInt(gAge2PoliticianList, 0, cTechPoliticianGovernor);
				xsArraySetInt(gAge2PoliticianList, 1, cTechPoliticianBishop);
				xsArraySetInt(gAge2PoliticianList, 2, cTechPoliticianQuartermaster );
				xsArraySetInt(gAge2PoliticianList, 3, cTechPoliticianPhilosopherPrince);
				xsArraySetInt(gAge2PoliticianList, 4, cTechPoliticianNaturalist);	
				xsArraySetInt(gAge2PoliticianList, 5, cTechPoliticianDiplomat);
				xsArraySetInt(gAge2PoliticianList, 6, cTechPoliticianArtist); 
			}
			for (i = 0; < xsArrayGetSize(gAge2PoliticianList))
			{
				if (kbTechGetStatus(xsArrayGetInt(gAge2PoliticianList, i)) == cTechStatusObtainable)
				{
					politician = xsArrayGetInt(gAge2PoliticianList, i);
					age = cAge2;
					break;
				}
			}
			break;
		}	
		case cAge2:
		{
			if (kbBaseGetUnderAttack(cMyID, kbBaseGetMainID(cMyID)) == true)
			{
				xsArraySetInt(gAge3PoliticianList, 0, cTechPoliticianMarksman);
				xsArraySetInt(gAge3PoliticianList, 1, cTechPoliticianSergeant);
				xsArraySetInt(gAge3PoliticianList, 2, cTechPoliticianAdventurer);
				xsArraySetInt(gAge3PoliticianList, 3, cTechPoliticianPirate);
				xsArraySetInt(gAge3PoliticianList, 4, cTechPoliticianScout);
				xsArraySetInt(gAge3PoliticianList, 5, cTechPoliticianMohawk);
				xsArraySetInt(gAge3PoliticianList, 6, cTechPoliticianExiledPrince);
				xsArraySetInt(gAge3PoliticianList, 7, cTechPoliticianAdmiral);
			}
			for (i = 0; < xsArrayGetSize(gAge3PoliticianList))
			{
				if (kbTechGetStatus(xsArrayGetInt(gAge3PoliticianList, i)) == cTechStatusObtainable)
				{
					politician = xsArrayGetInt(gAge3PoliticianList, i);
					age = cAge3;
					break;
				}
			}
			break;
		}
		
		case cAge3:
		{
			if (kbBaseGetUnderAttack(cMyID, kbBaseGetMainID(cMyID)) == true)
			{
				xsArraySetInt(gAge4PoliticianList, 0, cTechPoliticianMusketeer);
				xsArraySetInt(gAge4PoliticianList, 1, cTechPoliticianGrandVizier);
				xsArraySetInt(gAge4PoliticianList, 2, cTechPoliticianEngineer);
				xsArraySetInt(gAge4PoliticianList, 3, cTechPoliticianCavalier);
				xsArraySetInt(gAge4PoliticianList, 4, cTechPoliticianWarMinister);
				xsArraySetInt(gAge4PoliticianList, 5, cTechPoliticianViceroy);
				xsArraySetInt(gAge4PoliticianList, 6, cTechPoliticianMercenary);
				xsArraySetInt(gAge4PoliticianList, 7, cTechPoliticianTycoon);
			}
			for (i = 0; < xsArrayGetSize(gAge4PoliticianList))
			{
				if (kbTechGetStatus(xsArrayGetInt(gAge4PoliticianList, i)) == cTechStatusObtainable)
				{
					politician = xsArrayGetInt(gAge4PoliticianList, i);
					age = cAge4;
					break;
				}
			}
			break;
		}
		
		case cAge4:
		{
			if (kbBaseGetUnderAttack(cMyID, kbBaseGetMainID(cMyID)) == true)
			{	
				xsArraySetInt(gAge5PoliticianList, 0, cTechPoliticianGeneralUSA);
				xsArraySetInt(gAge5PoliticianList, 1, cTechPoliticianPresidente);
				xsArraySetInt(gAge5PoliticianList, 2, cTechPoliticianPresidenteEU);
				xsArraySetInt(gAge5PoliticianList, 3, cTechPoliticianGeneral);
			}
			for (i = 0; < xsArrayGetSize(gAge5PoliticianList))
			{
				if (kbTechGetStatus(xsArrayGetInt(gAge5PoliticianList, i)) == cTechStatusObtainable)
				{
					politician = xsArrayGetInt(gAge5PoliticianList, i);
					age = cAge5;
					break;
				}
			}
			break;
		}
		
	}
	aiSetPoliticianChoice(age, politician);
	return (politician);
}

//==============================================================================
// chooseNativeCouncilMember()
// Chooses age-up council members for native civilizations
//==============================================================================
int chooseNativeCouncilMember()
{
	int randomizer = -1;
	int numChoices = -1;
	int politician = -1;
	int bestChoice = 0;
	int bestScore = 0;

	for (i = 0; < 6)
		xsArraySetInt(gNatCouncilScores, i, 0); // reset array

	switch (gCurrentAge)
	{
		case cAge1:
			{ // Aztec chief and wise woman to be avoided
				numChoices = aiGetPoliticianListCount(cAge2);
				for (i = 0; < numChoices)
				{
					politician = aiGetPoliticianListByIndex(cAge2, i);
					if ((politician == cTechTribalAztecChief2) ||
						(politician == cTechTribalAztecWisewoman2))
					{
						xsArraySetInt(gNatCouncilScores, i, xsArrayGetInt(gNatCouncilScores, i) - 10);
					}
				}
				randomizer = aiRandInt(numChoices);
				xsArraySetInt(gNatCouncilScores, randomizer, xsArrayGetInt(gNatCouncilScores, randomizer) + 5);
				for (i = 0; < numChoices)
				{
					if (xsArrayGetInt(gNatCouncilScores, i) >= bestScore)
					{
						bestScore = xsArrayGetInt(gNatCouncilScores, i);
						bestChoice = i;
					}
				}
				politician = aiGetPoliticianListByIndex(cAge2, bestChoice);
				break;
			}
		case cAge2:
			{ // Aztec chief to be avoided
				numChoices = aiGetPoliticianListCount(cAge3);
				for (i = 0; < numChoices)
				{
					politician = aiGetPoliticianListByIndex(cAge3, i);
					if (politician == cTechTribalAztecChief3)
					{
						xsArraySetInt(gNatCouncilScores, i, xsArrayGetInt(gNatCouncilScores, i) - 10);
					}
					if (kbTechGetStatus(politician) != cTechStatusObtainable)
					{
						xsArraySetInt(gNatCouncilScores, i, xsArrayGetInt(gNatCouncilScores, i) - 50);
					}
					xsArraySetInt(gNatCouncilScores, i, xsArrayGetInt(gNatCouncilScores, i) + aiRandInt(10));
				}
				for (i = 0; < numChoices)
				{
					if (xsArrayGetInt(gNatCouncilScores, i) >= bestScore)
					{
						bestScore = xsArrayGetInt(gNatCouncilScores, i);
						bestChoice = i;
					}
				}
				politician = aiGetPoliticianListByIndex(cAge3, bestChoice);
				break;
			}
		case cAge3:
			{ // Aztec chief, Iroquois shaman, Sioux wise woman and all messengers to be avoided if possible
				numChoices = aiGetPoliticianListCount(cAge4);
				for (i = 0; < numChoices)
				{
					politician = aiGetPoliticianListByIndex(cAge4, i);
					if ((politician == cTechTribalAztecChief4) ||
						(politician == cTechTribalIroquoisShaman4) ||
						(politician == cTechTribalSiouxWisewoman4) ||
						(politician == cTechTribalAztecYouth4) ||
						(politician == cTechTribalIroquoisYouth4) ||
						(politician == cTechTribalSiouxYouth4))
					{
						xsArraySetInt(gNatCouncilScores, i, xsArrayGetInt(gNatCouncilScores, i) - 10);
					}
					if (kbTechGetStatus(politician) != cTechStatusObtainable)
					{
						xsArraySetInt(gNatCouncilScores, i, xsArrayGetInt(gNatCouncilScores, i) - 50);
					}
					xsArraySetInt(gNatCouncilScores, i, xsArrayGetInt(gNatCouncilScores, i) + aiRandInt(10));
				}
				for (i = 0; < numChoices)
				{
					if (xsArrayGetInt(gNatCouncilScores, i) >= bestScore)
					{
						bestScore = xsArrayGetInt(gNatCouncilScores, i);
						bestChoice = i;
					}
				}
				politician = aiGetPoliticianListByIndex(cAge4, bestChoice);
				break;
			}
		case cAge4:
			{ // Aztec chief, Iroquois shaman, Sioux wise woman and all messengers to be avoided if possible
				numChoices = aiGetPoliticianListCount(cAge5);
				for (i = 0; < numChoices)
				{
					politician = aiGetPoliticianListByIndex(cAge5, i);
					if ((politician == cTechTribalAztecChief5) ||
						(politician == cTechTribalIroquoisShaman5) ||
						(politician == cTechTribalSiouxWisewoman5) ||
						(politician == cTechTribalAztecYouth5) ||
						(politician == cTechTribalIroquoisYouth5) ||
						(politician == cTechTribalSiouxYouth5))
					{
						xsArraySetInt(gNatCouncilScores, i, xsArrayGetInt(gNatCouncilScores, i) - 10);
					}
					if (kbTechGetStatus(politician) != cTechStatusObtainable)
					{
						xsArraySetInt(gNatCouncilScores, i, xsArrayGetInt(gNatCouncilScores, i) - 50);
					}
					xsArraySetInt(gNatCouncilScores, i, xsArrayGetInt(gNatCouncilScores, i) + aiRandInt(10));
				}
				for (i = 0; < numChoices)
				{
					if (xsArrayGetInt(gNatCouncilScores, i) >= bestScore)
					{
						bestScore = xsArrayGetInt(gNatCouncilScores, i);
						bestChoice = i;
					}
				}
				politician = aiGetPoliticianListByIndex(cAge5, bestChoice);
				break;
			}
	}
	return (politician);
}

//==============================================================================
// chooseAsianWonder()
// Chooses age-up wonders for Asian civilizations
//==============================================================================
int chooseAsianWonder()
{
	int numChoices = -1;
	int politician = -1;
	int ageUpWonder = -1;
	int bestChoice = 0;
	int bestScore = 0;

	for (i = 0; < 6)
		xsArraySetInt(gAsianWonderScores, i, 0); // reset array

	switch (gCurrentAge)
	{
		case cAge1:
			{
				numChoices = aiGetPoliticianListCount(cAge2);
				for (i = 0; < numChoices)
				{
					politician = aiGetPoliticianListByIndex(cAge2, i);
					if (politician == cTechYPWonderChinesePorcelainTower2) // slight bias against porcelain tower
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 5);
					}
					if (politician == cTechYPWonderIndianAgra2) // slight bias towards agra fort
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + 5);
					}
					if (politician == cTechYPWonderIndianTajMahal2) // avoid Taj Mahal
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 10);
					}
					if (politician == cTechYPWonderJapaneseGiantBuddha2) // slight bias against giant buddha
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 5);
					}
					xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + aiRandInt(10));
				}
				for (i = 0; < numChoices)
				{
					if (xsArrayGetInt(gAsianWonderScores, i) >= bestScore)
					{
						bestScore = xsArrayGetInt(gAsianWonderScores, i);
						bestChoice = i;
					}
				}
				politician = aiGetPoliticianListByIndex(cAge2, bestChoice);
				//aiEcho("Chosen age-up wonder: "+kbGetTechName(politician));

				// Find building corresponding to chosen tech (i.e. "politician")
				for (i = 0; < 15)
				{
					if (xsArrayGetInt(gAge2WonderTechList, i) == politician)
					{
						ageUpWonder = xsArrayGetInt(gAge2WonderList, i);
					}
				}
				break;
			}
		case cAge2:
			{
				numChoices = aiGetPoliticianListCount(cAge3);
				for (i = 0; < numChoices)
				{
					politician = aiGetPoliticianListByIndex(cAge3, i);
					if (politician == cTechYPWonderChinesePorcelainTower3) // slight bias against porcelain tower
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 5);
					}
					if (politician == cTechYPWonderIndianAgra3) // slight bias towards agra fort
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + 5);
					}
					if (politician == cTechYPWonderIndianTajMahal3) // avoid Taj Mahal
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 10);
					}
					if (politician == cTechYPWonderJapaneseGiantBuddha3) // slight bias against giant buddha
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 5);
					}
					if (politician == cTechYPWonderJapaneseGoldenPavillion3) // slight bias towards golden pavillion
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + 5);
					}
					if (politician == cTechYPWonderJapaneseShogunate3) // slight bias towards shogunate
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + 5);
					}
					if (kbTechGetStatus(politician) != cTechStatusObtainable)
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 50);
					}
					xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + aiRandInt(10));
				}
				for (i = 0; < numChoices)
				{
					if (xsArrayGetInt(gAsianWonderScores, i) >= bestScore)
					{
						bestScore = xsArrayGetInt(gAsianWonderScores, i);
						bestChoice = i;
					}
				}
				politician = aiGetPoliticianListByIndex(cAge3, bestChoice);
				//aiEcho("Chosen age-up wonder: "+kbGetTechName(politician));

				// Find building corresponding to chosen tech (i.e. "politician")
				for (i = 0; < 15)
				{
					if (xsArrayGetInt(gAge3WonderTechList, i) == politician)
					{
						ageUpWonder = xsArrayGetInt(gAge3WonderList, i);
					}
				}
				break;
			}
		case cAge3:
			{
				numChoices = aiGetPoliticianListCount(cAge4);
				for (i = 0; < numChoices)
				{
					politician = aiGetPoliticianListByIndex(cAge4, i);
					if (politician == cTechYPWonderChinesePorcelainTower4) // strong bias towards porcelain tower
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + 10);
					}
					if (politician == cTechYPWonderChineseConfucianAcademy4) // strong bias towards confucian academy
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + 10);
					}
					if (politician == cTechYPWonderChineseWhitePagoda4) // slight bias against white pagoda
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 5);
					}
					if (politician == cTechYPWonderIndianCharminar4) // strong bias towards charminar gate
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + 10);
					}
					if (politician == cTechYPWonderIndianTajMahal4) // avoid Taj Mahal
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 10);
					}
					if (politician == cTechYPWonderJapaneseGiantBuddha4) // slight bias against giant buddha
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 5);
					}
					if (politician == cTechYPWonderJapaneseGoldenPavillion4) // strong bias towards golden pavillion
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + 10);
					}
					if (politician == cTechYPWonderJapaneseShogunate4) // strong bias towards shogunate
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + 10);
					}
					if (kbTechGetStatus(politician) != cTechStatusObtainable)
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 50);
					}
					xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + aiRandInt(10));
				}
				for (i = 0; < numChoices)
				{
					if (xsArrayGetInt(gAsianWonderScores, i) >= bestScore)
					{
						bestScore = xsArrayGetInt(gAsianWonderScores, i);
						bestChoice = i;
					}
				}
				politician = aiGetPoliticianListByIndex(cAge4, bestChoice);
				//aiEcho("Chosen age-up wonder: "+kbGetTechName(politician));

				// Find building corresponding to chosen tech (i.e. "politician")
				for (i = 0; < 15)
				{
					if (xsArrayGetInt(gAge4WonderTechList, i) == politician)
					{
						ageUpWonder = xsArrayGetInt(gAge4WonderList, i);
					}
				}
				break;
			}
		case cAge4:
			{
				numChoices = aiGetPoliticianListCount(cAge5);
				for (i = 0; < numChoices)
				{
					politician = aiGetPoliticianListByIndex(cAge5, i);
					if (politician == cTechYPWonderChinesePorcelainTower5) // strong bias towards porcelain tower
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + 10);
					}
					if (politician == cTechYPWonderChineseConfucianAcademy5) // strong bias towards confucian academy
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + 10);
					}
					if (politician == cTechYPWonderChineseTempleOfHeaven5) // avoid temple of heaven
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 10);
					}
					if (politician == cTechYPWonderChineseWhitePagoda5) // slight bias against white pagoda
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 5);
					}
					if (politician == cTechYPWonderIndianCharminar5) // strong bias towards charminar gate
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + 10);
					}
					if (politician == cTechYPWonderIndianTajMahal5) // avoid Taj Mahal
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 10);
					}
					if (politician == cTechYPWonderJapaneseGiantBuddha5) // slight bias against giant buddha
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 5);
					}
					if (politician == cTechYPWonderJapaneseGoldenPavillion5) // strong bias towards golden pavillion
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + 10);
					}
					if (politician == cTechYPWonderJapaneseShogunate5) // strong bias towards shogunate
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + 10);
					}
					if (kbTechGetStatus(politician) != cTechStatusObtainable)
					{
						xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) - 50);
					}
					xsArraySetInt(gAsianWonderScores, i, xsArrayGetInt(gAsianWonderScores, i) + aiRandInt(10));
				}
				for (i = 0; < numChoices)
				{
					if (xsArrayGetInt(gAsianWonderScores, i) >= bestScore)
					{
						bestScore = xsArrayGetInt(gAsianWonderScores, i);
						bestChoice = i;
					}
				}
				politician = aiGetPoliticianListByIndex(cAge5, bestChoice);
				//aiEcho("Chosen age-up wonder: "+kbGetTechName(politician));

				// Find building corresponding to chosen tech (i.e. "politician")
				for (i = 0; < 15)
				{
					if (xsArrayGetInt(gAge5WonderTechList, i) == politician)
					{
						ageUpWonder = xsArrayGetInt(gAge5WonderList, i);
					}
				}
				break;
			}

	}
	//aiEcho("Chosen age-up wonder: "+kbGetProtoUnitName(ageUpWonder));
	return (ageUpWonder);
}

void ageUpMain()
{

}