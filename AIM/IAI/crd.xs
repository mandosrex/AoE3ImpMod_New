//cards

int gCardNames = -1; // Array of strings, handy name for this card.
int gCardStates = -1; // Array of chars (strings), A = avail, N = Not avail, P = Purchased, D = in deck (and purchased)
int gCardPriorities = -1; // Array of ints, used for selecting cards into deck.  

const int maxCards = 150;
const int pointsForLevel2 = 5; // First five cards must be level 1
const int pointsForLevel3 = 25; // Cards 6..25 must be levels 1 or 2
int lastRemainingSP = 0;
int loopCount = 0;

int cardsInDeck = -1;
int cardsPriority = -1;
int cardsUnderAttack = -1;
int cardsUnderAttackPriority = -1;
int maxDeckSize = 30;

void bririshStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "TreasurySup");
	xsArraySetString(cardsInDeck, 1, "HCRobberBarons");             
	xsArraySetString(cardsInDeck, 2, "HCUnlockFactory"); 
	xsArraySetString(cardsInDeck, 3, "HCXPUnlockFort2"); 
	xsArraySetString(cardsInDeck, 4, "HCUnlockFort");   
	xsArraySetString(cardsInDeck, 5, "HCShipSettlers5");  	
	xsArraySetString(cardsInDeck, 6, "HCShipWoodCrates4");         
	xsArraySetString(cardsInDeck, 7, "HCShipFoodCrates4");         
	xsArraySetString(cardsInDeck, 8, "HCShipCoinCrates4");       
	xsArraySetString(cardsInDeck, 9, "HCShipCoveredWagons");           
	xsArraySetString(cardsInDeck, 10, "HCShipSettlers4");         
	xsArraySetString(cardsInDeck, 11, "HCShipWoodCrates3");          
	xsArraySetString(cardsInDeck, 12, "HCShipCoinCrates3");         
	xsArraySetString(cardsInDeck, 13, "HCTextileMills");         
	xsArraySetString(cardsInDeck, 14, "HCRefrigeration");               
	xsArraySetString(cardsInDeck, 15, "HCExtensiveFortifications");             
	xsArraySetString(cardsInDeck, 16, "HCFrontierDefenses");       
	xsArraySetString(cardsInDeck, 17, "HCShipSettlers3");        
	xsArraySetString(cardsInDeck, 18, "HCFencingSchool");  //      
	xsArraySetString(cardsInDeck, 19, "HCRidingSchool");             
	xsArraySetString(cardsInDeck, 20, "HCRoyalDecreeBritish");            
	xsArraySetString(cardsInDeck, 21, "HCRoyalMint");           
	xsArraySetString(cardsInDeck, 22, "HCMedicine"); 
	xsArraySetString(cardsInDeck, 23, "HCXPLandGrab");             
	xsArraySetString(cardsInDeck, 24, "HCXPRanching");         
	xsArraySetString(cardsInDeck, 25, "HCFullingMills");         
	xsArraySetString(cardsInDeck, 26, "HCShipLongbowmen4");         
	xsArraySetString(cardsInDeck, 27, "HCShipMusketeers1");         
	xsArraySetString(cardsInDeck, 28, "HCShipLongbowmen1");        
	xsArraySetString(cardsInDeck, 29, "HCShipWoodCrates1"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(3, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(3, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCShipLongbowmen4");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	xsArraySetString(cardsUnderAttack, 1, "HCShipMusketeers1");  xsArraySetInt(cardsUnderAttackPriority, 1, 2);
	xsArraySetString(cardsUnderAttack, 2, "HCShipLongbowmen1");  xsArraySetInt(cardsUnderAttackPriority, 2, 3);
}

void bririshStandardIslandDeck(void)
{
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	
	xsArraySetString(cardsInDeck, 0, "HCShipSettlers3");
	xsArraySetString(cardsInDeck, 1, "HCRobberBarons");         
	xsArraySetString(cardsInDeck, 2, "HCUnlockFactory"); 
	xsArraySetString(cardsInDeck, 3, "HCXPUnlockFort2");
	xsArraySetString(cardsInDeck, 4, "HCUnlockFort");
	xsArraySetString(cardsInDeck, 5, "HCShipWoodCrates4"); 
	xsArraySetString(cardsInDeck, 6, "HCShipWoodCrates3"); 	
	xsArraySetString(cardsInDeck, 7, "HCShipWoodCrates1");  
	xsArraySetString(cardsInDeck, 8, "HCCheapDocksTeam"); 
	xsArraySetString(cardsInDeck, 9, "HCImprovedBuildings");    
	xsArraySetString(cardsInDeck, 10, "HCNavalCombat");
	xsArraySetString(cardsInDeck, 11, "HCAdvancedDock");      
	xsArraySetString(cardsInDeck, 12, "HCFishMarket"); 	
	xsArraySetString(cardsInDeck, 13, "HCXPRanching");        
	xsArraySetString(cardsInDeck, 14, "HCSchooners");          
	xsArraySetString(cardsInDeck, 15, "HCXPWhaleOil");           
	xsArraySetString(cardsInDeck, 16, "HCXPLandGrab");    
	xsArraySetString(cardsInDeck, 17, "HCRenderingPlant");                  
	xsArraySetString(cardsInDeck, 18, "HCXPOffshoreSupport");            
	xsArraySetString(cardsInDeck, 19, "HCAdmirality");          
	xsArraySetString(cardsInDeck, 20, "HCShipFrigates");   
	xsArraySetString(cardsInDeck, 21, "HCNavalGunners");         
	xsArraySetString(cardsInDeck, 22, "HCMonitorCombatTeam");        
	xsArraySetString(cardsInDeck, 23, "HCPrivateers3");
	xsArraySetString(cardsInDeck, 24, "HCPrivateers2");
	xsArraySetString(cardsInDeck, 25, "HCPrivateers"); 
	xsArraySetString(cardsInDeck, 26, "HCShipCaravels2"); 
	xsArraySetString(cardsInDeck, 27, "HCShipCaravels1");       
	xsArraySetString(cardsInDeck, 28, "HCShipSchooners1"); 	
	xsArraySetString(cardsInDeck, 29, "HCShipMonitors2");    

	
	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}

	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(7, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(7, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCShipFrigates");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	xsArraySetString(cardsUnderAttack, 1, "HCPrivateers3");  xsArraySetInt(cardsUnderAttackPriority, 1, 2);
	xsArraySetString(cardsUnderAttack, 2, "HCPrivateers2");  xsArraySetInt(cardsUnderAttackPriority, 2, 3);
	xsArraySetString(cardsUnderAttack, 3, "HCPrivateers");  xsArraySetInt(cardsUnderAttackPriority, 4, 5);
	xsArraySetString(cardsUnderAttack, 4, "HCShipCaravels2");  xsArraySetInt(cardsUnderAttackPriority, 5, 6);
	xsArraySetString(cardsUnderAttack, 5, "HCShipCaravels1");  xsArraySetInt(cardsUnderAttackPriority, 6, 7);
	xsArraySetString(cardsUnderAttack, 6, "HCShipSchooners1");  xsArraySetInt(cardsUnderAttackPriority, 7, 8);
}

void japanStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "YPHCDojoGenbukan"); //1           
	xsArraySetString(cardsInDeck, 1, "YPHCDojoRenpeikan"); //2   
	xsArraySetString(cardsInDeck, 2, "YPHCShipSettlersAsian1");
	xsArraySetString(cardsInDeck, 3, "HCShipCoinCrates1");             
	xsArraySetString(cardsInDeck, 4, "YPHCIncreasedTribute"); 
	xsArraySetString(cardsInDeck, 5, "YPHCEnlistIrregulars"); 
	xsArraySetString(cardsInDeck, 6, "HCImprovedBuildings");   
	xsArraySetString(cardsInDeck, 7, "HCExoticHardwoods");  	
	xsArraySetString(cardsInDeck, 8, "YPHCShipBerryWagon1");         
	xsArraySetString(cardsInDeck, 9, "YPHCShipSettlersAsian2");         
	xsArraySetString(cardsInDeck, 10, "ypHCShipWoodCrates2");       
	xsArraySetString(cardsInDeck, 11, "YPHCShipShogunate");
	xsArraySetString(cardsInDeck, 12, "YPHCStoneCastles"); 
	xsArraySetString(cardsInDeck, 13, "YPHCYabusameAntiArtilleryDamage"); 	
	xsArraySetString(cardsInDeck, 14, "YPHCYabusameDamage");   
	xsArraySetString(cardsInDeck, 15, "YPHCNaginataHitpoints");  
	xsArraySetString(cardsInDeck, 16, "YPHCYumiRange");
	xsArraySetString(cardsInDeck, 17, "YPHCShipCoveredWagonsJapan");
	xsArraySetString(cardsInDeck, 18, "YPHCSmoothRelations");
	xsArraySetString(cardsInDeck, 19, "ypHCExtensiveFortificationsJapan");
	xsArraySetString(cardsInDeck, 20, "YPHCAshigaruDamage");
	xsArraySetString(cardsInDeck, 21, "YPHCShipYumi1");
	xsArraySetString(cardsInDeck, 22, "YPHCShipShrineWagon2");
	xsArraySetString(cardsInDeck, 23, "ypHCShipCoinCrates2");
	xsArraySetString(cardsInDeck, 24, "YPHCBerryGrove"); 
	xsArraySetString(cardsInDeck, 25, "YPHCShipNaginataRider2");         
	xsArraySetString(cardsInDeck, 26, "YPHCShipAshigaru4");         
	xsArraySetString(cardsInDeck, 27, "YPHCShipYumi3");         
	xsArraySetString(cardsInDeck, 28, "YPHCShipAshigaru2");        
	xsArraySetString(cardsInDeck, 29, "YPHCYumiDamage"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(5, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(5, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "YPHCShipNaginataRider2");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	xsArraySetString(cardsUnderAttack, 1, "YPHCShipAshigaru4");  xsArraySetInt(cardsUnderAttackPriority, 1, 2);
	xsArraySetString(cardsUnderAttack, 2, "YPHCShipYumi3");  xsArraySetInt(cardsUnderAttackPriority, 2, 3);
	xsArraySetString(cardsUnderAttack, 3, "YPHCShipYumi1"); xsArraySetInt(cardsUnderAttackPriority, 3, 4);
	xsArraySetString(cardsUnderAttack, 4, "YPHCShipAshigaru2"); xsArraySetInt(cardsUnderAttackPriority, 4, 5);
	
}

void japanStandardIslandDeck(void)
{
}
void spanishStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "TreasurySup");
	xsArraySetString(cardsInDeck, 1, "HCUnlockFort");             
	xsArraySetString(cardsInDeck, 2, "HCUnlockFactory"); 
	xsArraySetString(cardsInDeck, 3, "HCXPIndustrialRevolution"); 
	xsArraySetString(cardsInDeck, 4, "HCShipCoveredWagons");   
	xsArraySetString(cardsInDeck, 5, "HCShipSettlers3");  	
	xsArraySetString(cardsInDeck, 6, "HCXPEconomicTheory");         
	xsArraySetString(cardsInDeck, 7, "HCXPLandGrab");         
	xsArraySetString(cardsInDeck, 8, "HCXPRanchingLlama");       
	xsArraySetString(cardsInDeck, 9, "HCShipSettlers4");           
	xsArraySetString(cardsInDeck, 10, "HCShipWoodCrates4");         
	xsArraySetString(cardsInDeck, 11, "HCShipFoodCrates5");          
	xsArraySetString(cardsInDeck, 12, "HCShipFoodCrates4");         
	xsArraySetString(cardsInDeck, 13, "HCExtensiveFortifications");         
	xsArraySetString(cardsInDeck, 14, "HCFrontierDefenses2");               
	xsArraySetString(cardsInDeck, 15, "HCXPCapitalism");             
	xsArraySetString(cardsInDeck, 16, "HCRoyalDecreeSpanish");       
	xsArraySetString(cardsInDeck, 17, "HCHandCavalryCombatSpanish");        
	xsArraySetString(cardsInDeck, 18, "HCHandInfantryCombatSpanish");  
	xsArraySetString(cardsInDeck, 19, "HCRidingSchool");             
	xsArraySetString(cardsInDeck, 20, "HCFencingSchool");            
	xsArraySetString(cardsInDeck, 21, "HCHandCavalryHitpointsSpanish");           
	xsArraySetString(cardsInDeck, 22, "HCHandCavalryDamageSpanish"); 
	xsArraySetString(cardsInDeck, 23, "HCHandInfantryHitpointsSpanish");             
	xsArraySetString(cardsInDeck, 24, "HCHandInfantryDamageSpanishTeam");         
	xsArraySetString(cardsInDeck, 25, "HCShipFalconets2");         
	xsArraySetString(cardsInDeck, 26, "HCShipSpanishSquare");         
	xsArraySetString(cardsInDeck, 27, "HCShipRodeleros4");         
	xsArraySetString(cardsInDeck, 28, "HCShipRodeleros5");        
	xsArraySetString(cardsInDeck, 29, "HCShipCoinCrates1"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(4, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(4, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCShipSpanishSquare");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	xsArraySetString(cardsUnderAttack, 1, "HCShipRodeleros4");  xsArraySetInt(cardsUnderAttackPriority, 1, 2);
	xsArraySetString(cardsUnderAttack, 2, "HCShipRodeleros5");  xsArraySetInt(cardsUnderAttackPriority, 2, 3);
	xsArraySetString(cardsUnderAttack, 3, "HCShipFalconets2");  xsArraySetInt(cardsUnderAttackPriority, 3, 4);
}

void frenchStandardLandDeck(void)
{
	
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "TreasurySup");
	xsArraySetString(cardsInDeck, 1, "HCRobberBarons");             
	xsArraySetString(cardsInDeck, 2, "HCUnlockFactory"); 
	xsArraySetString(cardsInDeck, 3, "HCXPUnlockFort2"); 
	xsArraySetString(cardsInDeck, 4, "HCUnlockFort");   
	xsArraySetString(cardsInDeck, 5, "HCUnlockFortVauban");  	
	xsArraySetString(cardsInDeck, 6, "HCCavalryCombatFrench");         
	xsArraySetString(cardsInDeck, 7, "HCShipCoveredWagons");         
	xsArraySetString(cardsInDeck, 8, "HCShipCoinCrates4");       
	xsArraySetString(cardsInDeck, 9, "HCShipFoodCrates4");           
	xsArraySetString(cardsInDeck, 10, "HCShipWoodCrates4");         
	xsArraySetString(cardsInDeck, 11, "HCRoyalDecreeFrench");          
	xsArraySetString(cardsInDeck, 12, "HCXPRanching");         
	xsArraySetString(cardsInDeck, 13, "HCRidingSchool");         
	xsArraySetString(cardsInDeck, 14, "HCFencingSchool");               
	xsArraySetString(cardsInDeck, 15, "HCExtensiveFortifications");             
	xsArraySetString(cardsInDeck, 16, "HCXPLandGrab");       
	xsArraySetString(cardsInDeck, 17, "HCHandCavalryHitpointsFrench");        
	xsArraySetString(cardsInDeck, 18, "HCHandCavalryDamageFrenchTeam");  //      
	xsArraySetString(cardsInDeck, 19, "HCRangedInfantryHitpointsFrench");             
	xsArraySetString(cardsInDeck, 20, "HCShipWoodCrates3");            
	xsArraySetString(cardsInDeck, 21, "HCShipCoureurs3");           
	xsArraySetString(cardsInDeck, 22, "HCShipCoureurs2"); 
	xsArraySetString(cardsInDeck, 23, "HCXPEconomicTheory");             
	xsArraySetString(cardsInDeck, 24, "HCShipDragoons4");         
	xsArraySetString(cardsInDeck, 25, "HCShipSkirmishers3");         
	xsArraySetString(cardsInDeck, 26, "HCShipSkirmishers1");         
	xsArraySetString(cardsInDeck, 27, "HCShipCrossbowmen2");         
	xsArraySetString(cardsInDeck, 28, "HCShipHussars1");        
	xsArraySetString(cardsInDeck, 29, "HCShipCoinCrates1"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(5, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(5, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCShipDragoons4");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	xsArraySetString(cardsUnderAttack, 1, "HCShipSkirmishers3");  xsArraySetInt(cardsUnderAttackPriority, 1, 2);
	xsArraySetString(cardsUnderAttack, 2, "HCShipSkirmishers1");  xsArraySetInt(cardsUnderAttackPriority, 2, 3);
	xsArraySetString(cardsUnderAttack, 3, "HCShipCrossbowmen2");  xsArraySetInt(cardsUnderAttackPriority, 3, 4);
	xsArraySetString(cardsUnderAttack, 4, "HCShipHussars1");  xsArraySetInt(cardsUnderAttackPriority, 4, 5);
	
}

void portugueseStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "TreasurySup");
	xsArraySetString(cardsInDeck, 1, "HCMercsRonin");             
	xsArraySetString(cardsInDeck, 2, "HCUnlockFactory"); 
	xsArraySetString(cardsInDeck, 3, "HCXPUnlockFort2"); 
	xsArraySetString(cardsInDeck, 4, "HCUnlockFort");   
	xsArraySetString(cardsInDeck, 5, "HCDonatarios");  	
	xsArraySetString(cardsInDeck, 6, "HCShipOrganGuns1");         
	xsArraySetString(cardsInDeck, 7, "HCRangedInfantryHitpointsPortugueseTeam");         
	xsArraySetString(cardsInDeck, 8, "HCRangedInfantryCombatPortuguese");       
	xsArraySetString(cardsInDeck, 9, "HCXPGenitours");           
	xsArraySetString(cardsInDeck, 10, "HCArtilleryHitpointsPortugueseTeam");         
	xsArraySetString(cardsInDeck, 11, "HCRangedInfantryDamagePortuguese");          
	xsArraySetString(cardsInDeck, 12, "HCXPRanching");         
	xsArraySetString(cardsInDeck, 13, "HCRidingSchool");         
	xsArraySetString(cardsInDeck, 14, "HCFencingSchool");               
	xsArraySetString(cardsInDeck, 15, "HCShipCoinCrates4");             
	xsArraySetString(cardsInDeck, 16, "HCXPLandGrab");       
	xsArraySetString(cardsInDeck, 17, "HCShipWoodCrates4");        
	xsArraySetString(cardsInDeck, 18, "HCShipFoodCrates4");  //      
	xsArraySetString(cardsInDeck, 19, "HCRoyalDecreePortuguese");             
	xsArraySetString(cardsInDeck, 20, "HCEngineeringSchool");            
	xsArraySetString(cardsInDeck, 21, "HCShipCoinCrates3");           
	xsArraySetString(cardsInDeck, 22, "HCShipCoinCrates2"); 
	xsArraySetString(cardsInDeck, 23, "HCShipWoodCrates3");             
	xsArraySetString(cardsInDeck, 24, "HCShipWoodCrates2");         
	xsArraySetString(cardsInDeck, 25, "HCShipSettlers2");         
	xsArraySetString(cardsInDeck, 26, "HCXPEconomicTheory");         
	xsArraySetString(cardsInDeck, 27, "HCShipMusketeers1");         
	xsArraySetString(cardsInDeck, 28, "HCShipMusketeers4");        
	xsArraySetString(cardsInDeck, 29, "HCShipCoinCrates1"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(2, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(2, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCShipMusketeers1");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	xsArraySetString(cardsUnderAttack, 1, "HCShipMusketeers4");  xsArraySetInt(cardsUnderAttackPriority, 1, 2);
	
}

void dutchStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "TreasurySup");
	xsArraySetString(cardsInDeck, 1, "HCRobberBarons");             
	xsArraySetString(cardsInDeck, 2, "HCUnlockFactory"); 
	xsArraySetString(cardsInDeck, 3, "HCXPUnlockFort2"); 
	xsArraySetString(cardsInDeck, 4, "HCUnlockFort");   
	xsArraySetString(cardsInDeck, 5, "HCShipWoodCrates5");  	
	xsArraySetString(cardsInDeck, 6, "HCShipFoodCrates5");         
	xsArraySetString(cardsInDeck, 7, "HCFrontierDefenses2");         
	xsArraySetString(cardsInDeck, 8, "HCXPBankWagon");       
	xsArraySetString(cardsInDeck, 9, "HCBetterBanks");           
	xsArraySetString(cardsInDeck, 10, "HCCavalryCombatDutch");         
	xsArraySetString(cardsInDeck, 11, "HCInfantryCombatDutch");          
	xsArraySetString(cardsInDeck, 12, "HCInfantryHitpointsDutchTeam");         
	xsArraySetString(cardsInDeck, 13, "HCShipCoveredWagons");         
	xsArraySetString(cardsInDeck, 14, "HCShipCoinCrates4");               
	xsArraySetString(cardsInDeck, 15, "HCShipWoodCrates4");             
	xsArraySetString(cardsInDeck, 16, "HCRoyalDecreeDutch");       
	xsArraySetString(cardsInDeck, 17, "HCRidingSchool");        
	xsArraySetString(cardsInDeck, 18, "HCFencingSchool");  //      
	xsArraySetString(cardsInDeck, 19, "HCExtensiveFortifications");             
	xsArraySetString(cardsInDeck, 20, "HCBanks1");            
	xsArraySetString(cardsInDeck, 21, "HCBanks2");           
	xsArraySetString(cardsInDeck, 22, "HCInfantryDamageDutch"); 
	xsArraySetString(cardsInDeck, 23, "HCShipWoodCrates3");             
	xsArraySetString(cardsInDeck, 24, "HCShipSettlers2");         
	xsArraySetString(cardsInDeck, 25, "HCEngineeringSchool");         
	xsArraySetString(cardsInDeck, 26, "HCDutchEastIndiaCompany");         
	xsArraySetString(cardsInDeck, 27, "HCXPLandGrab");         
	xsArraySetString(cardsInDeck, 28, "HCXPRanching");        
	xsArraySetString(cardsInDeck, 29, "HCShipWoodCrates1"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCFrontierDefenses2");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	
}

void germansStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "TreasurySup");
	xsArraySetString(cardsInDeck, 1, "HCRobberBaronsGerman");             
	xsArraySetString(cardsInDeck, 2, "HCUnlockFactoryGerman"); 
	xsArraySetString(cardsInDeck, 3, "HCXPUnlockFort2German"); 
	xsArraySetString(cardsInDeck, 4, "HCUnlockFortGerman");   
	xsArraySetString(cardsInDeck, 5, "HCRidingSchoolGerman2");  	
	xsArraySetString(cardsInDeck, 6, "HCUhlanCombatGerman");         
	xsArraySetString(cardsInDeck, 7, "HCRangedInfantryHitpointsGerman");         
	xsArraySetString(cardsInDeck, 8, "HCCavalryCombatGerman");       
	xsArraySetString(cardsInDeck, 9, "HCHandInfantryCombatGerman");           
	xsArraySetString(cardsInDeck, 10, "HCShipCoveredWagonsGerman");         
	xsArraySetString(cardsInDeck, 11, "HCShipCoinCrates4German");          
	xsArraySetString(cardsInDeck, 12, "HCShipWoodCrates4German");         
	xsArraySetString(cardsInDeck, 13, "HCShipFoodCrates4German");         
	xsArraySetString(cardsInDeck, 14, "HCRoyalDecreeGerman");               
	xsArraySetString(cardsInDeck, 15, "HCRidingSchoolGerman");             
	xsArraySetString(cardsInDeck, 16, "HCFencingSchoolGerman");       
	xsArraySetString(cardsInDeck, 17, "HCExtensiveFortificationsGerman");        
	xsArraySetString(cardsInDeck, 18, "HCCavalryHitpointsGerman");  //      
	xsArraySetString(cardsInDeck, 19, "HCCavalryDamageGermanTeam");             
	xsArraySetString(cardsInDeck, 20, "HCHandInfantryHitpointsGerman");            
	xsArraySetString(cardsInDeck, 21, "HCHandInfantryDamageGerman");           
	xsArraySetString(cardsInDeck, 22, "HCShipSettlerWagons4"); 
	xsArraySetString(cardsInDeck, 23, "HCXPEconomicTheory");             
	xsArraySetString(cardsInDeck, 24, "HCXPLandGrab");         
	xsArraySetString(cardsInDeck, 25, "HCXPRanching");         
	xsArraySetString(cardsInDeck, 26, "HCShipSettlerWagons3");         
	xsArraySetString(cardsInDeck, 27, "HCShipUhlans4");         
	xsArraySetString(cardsInDeck, 28, "HCShipCrossbowmen3German");        
	xsArraySetString(cardsInDeck, 29, "HCShipCoinCrates1"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(2, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(2, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCShipUhlans4");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	xsArraySetString(cardsUnderAttack, 1, "HCShipCrossbowmen3German");  xsArraySetInt(cardsUnderAttackPriority, 1, 2);
	
}

void russianStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "HCXPNationalRedoubt");
	xsArraySetString(cardsInDeck, 1, "HCXPIndustrialRevolution");             
	xsArraySetString(cardsInDeck, 2, "HCUnlockFactory"); 
	xsArraySetString(cardsInDeck, 3, "HCXPUnlockFort2"); 
	xsArraySetString(cardsInDeck, 4, "HCShipCoinCrates5");   
	xsArraySetString(cardsInDeck, 5, "HCCavalryLOSTeam");  	
	xsArraySetString(cardsInDeck, 6, "TreasurySup");         
	xsArraySetString(cardsInDeck, 7, "HCDuelingSchoolTeam");         
	xsArraySetString(cardsInDeck, 8, "HCUnlockFort");       
	xsArraySetString(cardsInDeck, 9, "HCFrontierDefenses2");           
	xsArraySetString(cardsInDeck, 10, "HCCavalryCombatRussian");         
	xsArraySetString(cardsInDeck, 11, "HCBlockhouseCannon");          
	xsArraySetString(cardsInDeck, 12, "HCUniqueCombatRussian");         
	xsArraySetString(cardsInDeck, 13, "HCRansack");         
	xsArraySetString(cardsInDeck, 14, "HCStreletsCombatRussian");               
	xsArraySetString(cardsInDeck, 15, "HCShipCoveredWagons");             
	xsArraySetString(cardsInDeck, 16, "HCShipCoinCrates4");       
	xsArraySetString(cardsInDeck, 17, "HCRoyalDecreeRussian");        
	xsArraySetString(cardsInDeck, 18, "HCRidingSchool");  //      
	xsArraySetString(cardsInDeck, 19, "HCFencingSchool");             
	xsArraySetString(cardsInDeck, 20, "HCXPSevastopol");            
	xsArraySetString(cardsInDeck, 21, "HCBarracksHPTeam");           
	xsArraySetString(cardsInDeck, 22, "HCShipCoinCrates3"); 
	xsArraySetString(cardsInDeck, 23, "HCShipSettlers3");             
	xsArraySetString(cardsInDeck, 24, "HCExtensiveFortifications");         
	xsArraySetString(cardsInDeck, 25, "HCXPEconomicTheory");         
	xsArraySetString(cardsInDeck, 26, "HCXPLandGrab");         
	xsArraySetString(cardsInDeck, 27, "HCXPRanching");         
	xsArraySetString(cardsInDeck, 28, "HCShipStrelets1");        
	xsArraySetString(cardsInDeck, 29, "HCShipCoinCrates1"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCShipStrelets1");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	
}

void ottomansStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "HCRobberBarons");
	xsArraySetString(cardsInDeck, 1, "HCUnlockFactory");             
	xsArraySetString(cardsInDeck, 2, "HCXPUnlockFort2"); 
	xsArraySetString(cardsInDeck, 3, "HCUnlockFort"); 
	xsArraySetString(cardsInDeck, 4, "HCAdvancedArtillery");   
	xsArraySetString(cardsInDeck, 5, "HCJanissaryCost");  	
	xsArraySetString(cardsInDeck, 6, "HCShipCoveredWagons2");         
	xsArraySetString(cardsInDeck, 7, "HCFrontierDefenses2");         
	xsArraySetString(cardsInDeck, 8, "HCAdvancedArsenalOttoman");       
	xsArraySetString(cardsInDeck, 9, "HCCavalryCombatOttoman");           
	xsArraySetString(cardsInDeck, 10, "HCXPIrregulars");         
	xsArraySetString(cardsInDeck, 11, "HCJanissaryCombatOttoman");          
	xsArraySetString(cardsInDeck, 12, "HCShipCoveredWagons");         
	xsArraySetString(cardsInDeck, 13, "HCShipCoinCrates4");         
	xsArraySetString(cardsInDeck, 14, "HCShipWoodCrates4");               
	xsArraySetString(cardsInDeck, 15, "YPHCSmoothRelations");             
	xsArraySetString(cardsInDeck, 16, "HCXPDanceHallOt");       
	xsArraySetString(cardsInDeck, 17, "HCRoyalDecreeOttoman");        
	xsArraySetString(cardsInDeck, 18, "HCBattlefieldConstruction");  //      
	xsArraySetString(cardsInDeck, 19, "HCRidingSchool");             
	xsArraySetString(cardsInDeck, 20, "HCExtensiveFortifications");            
	xsArraySetString(cardsInDeck, 21, "HCFrontierDefenses");           
	xsArraySetString(cardsInDeck, 22, "HCLightArtilleryHitpointsOttoman"); 
	xsArraySetString(cardsInDeck, 23, "HCShipSettlers2");             
	xsArraySetString(cardsInDeck, 24, "HCXPEconomicTheory");         
	xsArraySetString(cardsInDeck, 25, "HCXPRanching");         
	xsArraySetString(cardsInDeck, 26, "HCXPLandGrab");         
	xsArraySetString(cardsInDeck, 27, "HCShipSettlers3");         
	xsArraySetString(cardsInDeck, 28, "HCShipJanissaries1");        
	xsArraySetString(cardsInDeck, 29, "HCShipCoinCrates1"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCShipJanissaries1");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	
}

void iroquoisStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "HCXPOldWaysIroquois");
	xsArraySetString(cardsInDeck, 1, "HCHeavyFortifications");             
	xsArraySetString(cardsInDeck, 2, "HCXPPioneers2"); 
	xsArraySetString(cardsInDeck, 3, "HCXPNationalUnity"); 
	xsArraySetString(cardsInDeck, 4, "HCXPShipTravois3");   
	xsArraySetString(cardsInDeck, 5, "HCXPKinshipTies");  	
	xsArraySetString(cardsInDeck, 6, "HCEngineeringSchool");         
	xsArraySetString(cardsInDeck, 7, "HCNativeCombat");         
	xsArraySetString(cardsInDeck, 8, "HCXPExtensiveFortifications2");       
	xsArraySetString(cardsInDeck, 9, "HCXPCavalryDamageIroquois");           
	xsArraySetString(cardsInDeck, 10, "HCXPCavalryHitpointsIroquois");         
	xsArraySetString(cardsInDeck, 11, "HCXPInfantryCombatIroquois");          
	xsArraySetString(cardsInDeck, 12, "HCShipCoveredWagonsIroquois");         
	xsArraySetString(cardsInDeck, 13, "HCXPMedicineTeam");         
	xsArraySetString(cardsInDeck, 14, "HCXPTownDance");               
	xsArraySetString(cardsInDeck, 15, "HCXPConservativeTactics");             
	xsArraySetString(cardsInDeck, 16, "HCXPBattlefieldConstructionIroquois");       
	xsArraySetString(cardsInDeck, 17, "HCXPWarHouses");        
	xsArraySetString(cardsInDeck, 18, "HCExtensiveFortifications");  //      
	xsArraySetString(cardsInDeck, 19, "HCXPNewWaysIroquois");             
	xsArraySetString(cardsInDeck, 20, "HCXPShipTravois2");            
	xsArraySetString(cardsInDeck, 21, "HCXPInfantryHitpointsIroquois");           
	xsArraySetString(cardsInDeck, 22, "HCXPInfantryDamageIroquois"); 
	xsArraySetString(cardsInDeck, 23, "HCXPShipVillagers3");             
	xsArraySetString(cardsInDeck, 24, "HCXPShipTravois1");         
	xsArraySetString(cardsInDeck, 25, "HCBerryHarvest");         
	xsArraySetString(cardsInDeck, 26, "HCXPLandGrab");         
	xsArraySetString(cardsInDeck, 27, "HCXPInfantryLOSTeam");         
	xsArraySetString(cardsInDeck, 28, "HCXPRanchingNative");        
	xsArraySetString(cardsInDeck, 29, "HCXPShipMixedCratesRepeat"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCXPWarHouses");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	
}

void siouxStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "HCHeavyFortificationsSx");
	xsArraySetString(cardsInDeck, 1, "HCConestogaWagonsTeam");             
	xsArraySetString(cardsInDeck, 2, "HCXPCommandSkill"); 
	xsArraySetString(cardsInDeck, 3, "HCShipFoodCrates5"); 
	xsArraySetString(cardsInDeck, 4, "HCXPSiouxTwoKettleSupport");   
	xsArraySetString(cardsInDeck, 5, "HCXPSiouxYanktonSupport");  	
	xsArraySetString(cardsInDeck, 6, "HCXPSiouxSanteeSupport");         
	xsArraySetString(cardsInDeck, 7, "HCXPSiouxDakotaSupport");         
	xsArraySetString(cardsInDeck, 8, "HCXPAdoption");       
	xsArraySetString(cardsInDeck, 9, "HCXPMustangs");           
	xsArraySetString(cardsInDeck, 10, "HCXPCavalryCombatSioux");         
	xsArraySetString(cardsInDeck, 11, "HCShipCoveredWagonsSioux");          
	xsArraySetString(cardsInDeck, 12, "HCXPMarauders");         
	xsArraySetString(cardsInDeck, 13, "HCResourcesBuff");         
	xsArraySetString(cardsInDeck, 14, "HCRidingSchool");               
	xsArraySetString(cardsInDeck, 15, "HCXPAggressivePolicy");             
	xsArraySetString(cardsInDeck, 16, "HCXPFriendlyTerritory");       
	xsArraySetString(cardsInDeck, 17, "HCXPNomadicExpansion");        
	xsArraySetString(cardsInDeck, 18, "HCXPShipWarHutTravois1");  //      
	xsArraySetString(cardsInDeck, 19, "HCExtensiveFortifications");             
	xsArraySetString(cardsInDeck, 20, "HCXPNewWaysSioux");            
	xsArraySetString(cardsInDeck, 21, "HCXPCavalryHitpointsSioux");           
	xsArraySetString(cardsInDeck, 22, "HCXPCavalryDamageSioux"); 
	xsArraySetString(cardsInDeck, 23, "HCXPShipVillagers2");             
	xsArraySetString(cardsInDeck, 24, "HCXPRanchingNative");         
	xsArraySetString(cardsInDeck, 25, "HCXPLandGrab");         
	xsArraySetString(cardsInDeck, 26, "HCXPTownDance");         
	xsArraySetString(cardsInDeck, 27, "HCXPShipVillagers3");         
	xsArraySetString(cardsInDeck, 28, "HCBerryHarvest");        
	xsArraySetString(cardsInDeck, 29, "HCShipWoodCrates1"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(4, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(4, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCXPSiouxTwoKettleSupport");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	xsArraySetString(cardsUnderAttack, 1, "HCXPSiouxYanktonSupport");  xsArraySetInt(cardsUnderAttackPriority, 1, 2);
	xsArraySetString(cardsUnderAttack, 2, "HCXPSiouxSanteeSupport");  xsArraySetInt(cardsUnderAttackPriority, 2, 3);
	xsArraySetString(cardsUnderAttack, 3, "HCXPSiouxDakotaSupport");  xsArraySetInt(cardsUnderAttackPriority, 3, 4);
	
}

void aztecStandardLandDeck(void)
{
	
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "HCXPGreatTempleQuetzalcoatl");
	xsArraySetString(cardsInDeck, 1, "HCXPGreatTempleHuitzilopochtli");             
	xsArraySetString(cardsInDeck, 2, "HCXPStoneTowers"); 
	xsArraySetString(cardsInDeck, 3, "HCHeavyFortifications"); 
	xsArraySetString(cardsInDeck, 4, "HCXPExtensiveFortificationsAztec");   
	xsArraySetString(cardsInDeck, 5, "HCXPShipNoblesHutTravois3");  	
	xsArraySetString(cardsInDeck, 6, "HCXPShipNoblesHutTravois2");         
	xsArraySetString(cardsInDeck, 7, "HCXPScorchedEarth");         
	xsArraySetString(cardsInDeck, 8, "HCXPCoinCratesAztec5");       
	xsArraySetString(cardsInDeck, 9, "HCXPTempleTlaloc");           
	xsArraySetString(cardsInDeck, 10, "HCXPTempleXochipilli");         
	xsArraySetString(cardsInDeck, 11, "HCXPTempleXipeTotec");          
	xsArraySetString(cardsInDeck, 12, "HCXPTempleCenteotl");         
	xsArraySetString(cardsInDeck, 13, "HCXPTempleCoatlicue");         
	xsArraySetString(cardsInDeck, 14, "HCXPKnightCombat");               
	xsArraySetString(cardsInDeck, 15, "HCXPKnightDamage");             
	xsArraySetString(cardsInDeck, 16, "HCXPKnightHitpoints");       
	xsArraySetString(cardsInDeck, 17, "HCXPRuthlessness");        
	xsArraySetString(cardsInDeck, 18, "HCShipCoveredWagonsAztec");     
	xsArraySetString(cardsInDeck, 19, "HCXPTownDance");             
	xsArraySetString(cardsInDeck, 20, "HCFencingSchool");            
	xsArraySetString(cardsInDeck, 21, "HCXPShipWarHutTravois1");           
	xsArraySetString(cardsInDeck, 22, "HCXPCheapWarHuts"); 
	xsArraySetString(cardsInDeck, 23, "HCXPWarHutTraining");             
	xsArraySetString(cardsInDeck, 24, "HCXPSilentStrike");         
	xsArraySetString(cardsInDeck, 25, "HCXPCoyoteCombat");         
	xsArraySetString(cardsInDeck, 26, "HCXPShipVillagers4");         
	xsArraySetString(cardsInDeck, 27, "HCXPLandGrab");         
	xsArraySetString(cardsInDeck, 28, "HCXPRanchingNative");        
	xsArraySetString(cardsInDeck, 29, "HCBerryHarvest"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(6, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(6, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCXPGreatTempleQuetzalcoatl");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	xsArraySetString(cardsUnderAttack, 1, "HCXPGreatTempleHuitzilopochtli");  xsArraySetInt(cardsUnderAttackPriority, 1, 2);
	xsArraySetString(cardsUnderAttack, 2, "HCXPTempleTlaloc");  xsArraySetInt(cardsUnderAttackPriority, 2, 3);
	xsArraySetString(cardsUnderAttack, 3, "HCXPTempleXipeTotec");  xsArraySetInt(cardsUnderAttackPriority, 3, 4);
	xsArraySetString(cardsUnderAttack, 4, "HCXPTempleCenteotl");  xsArraySetInt(cardsUnderAttackPriority, 4, 5);
	xsArraySetString(cardsUnderAttack, 5, "HCXPTempleCoatlicue");  xsArraySetInt(cardsUnderAttackPriority, 5, 6);
	
}

void chineseStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "YPHCWesternReforms");
	xsArraySetString(cardsInDeck, 1, "YPHCShipFlyingCrow1");             
	xsArraySetString(cardsInDeck, 2, "YPHCManchuCombat"); 
	xsArraySetString(cardsInDeck, 3, "YPHCOldHanArmyReforms"); 
	xsArraySetString(cardsInDeck, 4, "YPHCAccupuncture");   
	xsArraySetString(cardsInDeck, 5, "YPHCArtilleryCombatChinese");  	
	xsArraySetString(cardsInDeck, 6, "YPHCForbiddenArmyArmor");         
	xsArraySetString(cardsInDeck, 7, "YPHCHanAntiCavalryBonus");         
	xsArraySetString(cardsInDeck, 8, "YPHCTerritorialArmyCombat");       
	xsArraySetString(cardsInDeck, 9, "YPHCSpawnRefugees2");           
	xsArraySetString(cardsInDeck, 10, "YPHCAtonementChinese");         
	xsArraySetString(cardsInDeck, 11, "YPHCExtensiveFortifications");          
	xsArraySetString(cardsInDeck, 12, "YPHCEngineeringSchoolTeam");         
	xsArraySetString(cardsInDeck, 13, "YPHCBannerSchool");         
	xsArraySetString(cardsInDeck, 14, "YPHCArtilleryDamageChinese");               
	xsArraySetString(cardsInDeck, 15, "YPHCArtilleryHitpointsChinese");             
	xsArraySetString(cardsInDeck, 16, "YPHCMongolianScourge");       
	xsArraySetString(cardsInDeck, 17, "YPHCStandardArmyHitpoints");        
	xsArraySetString(cardsInDeck, 18, "HCShipCoinCrates3");     
	xsArraySetString(cardsInDeck, 19, "HCShipWoodCrates3");             
	xsArraySetString(cardsInDeck, 20, "HCFoodSilos");            
	xsArraySetString(cardsInDeck, 21, "HCXPLandGrab");           
	xsArraySetString(cardsInDeck, 22, "YPHCAdvancedWonders"); 
	xsArraySetString(cardsInDeck, 23, "YPHCAdvancedRicePaddy");             
	xsArraySetString(cardsInDeck, 24, "YPHCCheapWarAcademyTeam");         
	xsArraySetString(cardsInDeck, 25, "YPHCRanchingWaterBuffalo");         
	xsArraySetString(cardsInDeck, 26, "YPHCShipVillageWagon1");         
	xsArraySetString(cardsInDeck, 27, "YPHCSpawnRefugees1");         
	xsArraySetString(cardsInDeck, 28, "HCShipCoinCrates1");        
	xsArraySetString(cardsInDeck, 29, "YPHCShipKeshik4"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "YPHCShipKeshik4");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	
}

void indiansStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "YPHCElephantLimit");
	xsArraySetString(cardsInDeck, 1, "YPHCInfantrySpeedHitpointsTeam");             
	xsArraySetString(cardsInDeck, 2, "YPHCShipCoveredWagons2Indians"); 
	xsArraySetString(cardsInDeck, 3, "YPHCGurkhaAid"); 
	xsArraySetString(cardsInDeck, 4, "YPHCEastIndiaCompany");   
	xsArraySetString(cardsInDeck, 5, "YPHCElephantTrampling");  	
	xsArraySetString(cardsInDeck, 6, "YPHCElephantCombatIndians");         
	xsArraySetString(cardsInDeck, 7, "YPHCIndianMonkFrighten");         
	xsArraySetString(cardsInDeck, 8, "YPHCShipCoveredWagonsIndians");       
	xsArraySetString(cardsInDeck, 9, "YPHCShipCoinCrates4Indians");           
	xsArraySetString(cardsInDeck, 10, "YPHCShipWoodCrates4Indians");         
	xsArraySetString(cardsInDeck, 11, "YPHCShipFoodCrates4Indians");          
	xsArraySetString(cardsInDeck, 12, "YPHCAtonementIndians");         
	xsArraySetString(cardsInDeck, 13, "YPHCShipGroveWagonIndians2");         
	xsArraySetString(cardsInDeck, 14, "YPHCBattlefieldConstruction");               
	xsArraySetString(cardsInDeck, 15, "YPHCExtensiveFortificationsIndians");             
	xsArraySetString(cardsInDeck, 16, "YPHCRidingSchoolIndians");       
	xsArraySetString(cardsInDeck, 17, "YPHCFencingSchoolIndians");        
	xsArraySetString(cardsInDeck, 18, "YPHCCamelFrightening");     
	xsArraySetString(cardsInDeck, 19, "YPHCCamelDamageIndians");             
	xsArraySetString(cardsInDeck, 20, "YPHCMeleeDamageIndians");            
	xsArraySetString(cardsInDeck, 21, "YPHCShipCoinCrates2Indians");           
	xsArraySetString(cardsInDeck, 22, "YPHCFoodSilosIndians"); 
	xsArraySetString(cardsInDeck, 23, "YPHCAdvancedWondersIndians");             
	xsArraySetString(cardsInDeck, 24, "YPHCAdvancedRicePaddyIndians");         
	xsArraySetString(cardsInDeck, 25, "YPHCGrazing");         
	xsArraySetString(cardsInDeck, 26, "YPHCIndianMonkCombat");         
	xsArraySetString(cardsInDeck, 27, "HCXPRanchingIndians");         
	xsArraySetString(cardsInDeck, 28, "YPHCShipIndianRangedCavalry3");        
	xsArraySetString(cardsInDeck, 29, "YPHCShipWoodCratesInf4Indians"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "YPHCShipIndianRangedCavalry3");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	
}

void USAStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "HCXPIndustrialRevolution");
	xsArraySetString(cardsInDeck, 1, "HCUnlockFactory");             
	xsArraySetString(cardsInDeck, 2, "HCXPUnlockFort2"); 
	xsArraySetString(cardsInDeck, 3, "HCHeavyFortifications"); 
	xsArraySetString(cardsInDeck, 4, "HCRangedInfantryCombatUS");   
	xsArraySetString(cardsInDeck, 5, "HCRangedInfantryHitpointsPortugueseTeam");  	
	xsArraySetString(cardsInDeck, 6, "TreasurySup");         
	xsArraySetString(cardsInDeck, 7, "TeamOutpost");         
	xsArraySetString(cardsInDeck, 8, "HCUnlockFort");       
	xsArraySetString(cardsInDeck, 9, "HCCavalryCombatUSA");   
	xsArraySetString(cardsInDeck, 10, "HCRangedInfantryDamageUS");         
	xsArraySetString(cardsInDeck, 11, "HCShipCoveredWagons");          
	xsArraySetString(cardsInDeck, 12, "HCArtilleryDamageUSA");         
	xsArraySetString(cardsInDeck, 13, "USATraining");         
	xsArraySetString(cardsInDeck, 14, "MarineRange");               
	xsArraySetString(cardsInDeck, 15, "MilitiaInfantryAttack");             
	xsArraySetString(cardsInDeck, 16, "HCRoyalDecreeUS");       
	xsArraySetString(cardsInDeck, 17, "HCEngineeringSchool");        
	xsArraySetString(cardsInDeck, 18, "HCRidingSchool");     
	xsArraySetString(cardsInDeck, 19, "HCFencingSchool");             
	xsArraySetString(cardsInDeck, 20, "HCExtensiveFortifications");            
	xsArraySetString(cardsInDeck, 21, "HCCavalryHitpointsUSA");           
	xsArraySetString(cardsInDeck, 22, "HCCavalryDamageUSA"); 
	xsArraySetString(cardsInDeck, 23, "HCShipSettlers2");             
	xsArraySetString(cardsInDeck, 24, "HCEnableMiners");         
	xsArraySetString(cardsInDeck, 25, "HCBattlefieldConstructionUS");         
	xsArraySetString(cardsInDeck, 26, "HCXPLandGrab");         
	xsArraySetString(cardsInDeck, 27, "HCXPEconomicTheory");         
	xsArraySetString(cardsInDeck, 28, "HCXPCoinCratesAztec5");        
	xsArraySetString(cardsInDeck, 29, "HCMilitiaRepeatTeam"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCMilitiaRepeatTeam");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	
}

void swedishStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "TreasurySup");
	xsArraySetString(cardsInDeck, 1, "HCRobberBarons");             
	xsArraySetString(cardsInDeck, 2, "HCUnlockFactory"); 
	xsArraySetString(cardsInDeck, 3, "HCXPUnlockFort2"); 
	xsArraySetString(cardsInDeck, 4, "HCHeavyFortifications");   
	xsArraySetString(cardsInDeck, 5, "HCUnlockFort");  	
	xsArraySetString(cardsInDeck, 6, "HCShipCoveredWagons");         
	xsArraySetString(cardsInDeck, 7, "HCShipWoodCrates4");         
	xsArraySetString(cardsInDeck, 8, "HCShipFoodCrates4");       
	xsArraySetString(cardsInDeck, 9, "HCLumberCampTeam");   
	xsArraySetString(cardsInDeck, 10, "HCGrapeshot");         
	xsArraySetString(cardsInDeck, 11, "HCOneManArmy");          
	xsArraySetString(cardsInDeck, 12, "HCCombinedArms");         
	xsArraySetString(cardsInDeck, 13, "HCHandCavalryCombatSw");         
	xsArraySetString(cardsInDeck, 14, "HCRoyalDecreeSwedish");               
	xsArraySetString(cardsInDeck, 15, "HCRidingSchool");             
	xsArraySetString(cardsInDeck, 16, "HCFencingSchool");       
	xsArraySetString(cardsInDeck, 17, "HCShipCoinCrates3");        
	xsArraySetString(cardsInDeck, 18, "HCShipSettlers3Sw");     
	xsArraySetString(cardsInDeck, 19, "HCExtensiveFortifications");             
	xsArraySetString(cardsInDeck, 20, "HCLumberCamp");            
	xsArraySetString(cardsInDeck, 21, "HCHandCavalryHitpointsSw");           
	xsArraySetString(cardsInDeck, 22, "HCHandCavalryDamageSw"); 
	xsArraySetString(cardsInDeck, 23, "HCHandgonneCombat");             
	xsArraySetString(cardsInDeck, 24, "HCXPEconomicTheory");         
	xsArraySetString(cardsInDeck, 25, "HCXPRanching");         
	xsArraySetString(cardsInDeck, 26, "HCXPLandGrab");         
	xsArraySetString(cardsInDeck, 27, "HCShipSettlers1Sw");         
	xsArraySetString(cardsInDeck, 28, "HCShipCoinCrates1");        
	xsArraySetString(cardsInDeck, 29, "HCShipSkarp5"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCShipSkarp5");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	
}

void italiansStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "TreasurySup");
	xsArraySetString(cardsInDeck, 1, "HCRobberBarons");             
	xsArraySetString(cardsInDeck, 2, "HCUnlockFactory"); 
	xsArraySetString(cardsInDeck, 3, "HCHeavyFortifications"); 
	xsArraySetString(cardsInDeck, 4, "HCCondottieri");   
	xsArraySetString(cardsInDeck, 5, "HCUnlockFort");  	
	xsArraySetString(cardsInDeck, 6, "HCHandCavalryCombatIt");         
	xsArraySetString(cardsInDeck, 7, "HCShipCoveredWagons");         
	xsArraySetString(cardsInDeck, 8, "HCShipCoinCrates4");       
	xsArraySetString(cardsInDeck, 9, "PaviseShield");   
	xsArraySetString(cardsInDeck, 10, "HCCrossbowCombat");         
	xsArraySetString(cardsInDeck, 11, "ArtilleryCombat");          
	xsArraySetString(cardsInDeck, 12, "ArchaicInfantryCombat");         
	xsArraySetString(cardsInDeck, 13, "HCBuildingsArmor");         
	xsArraySetString(cardsInDeck, 14, "HCRoyalDecreeItalians");               
	xsArraySetString(cardsInDeck, 15, "HCRidingSchool");             
	xsArraySetString(cardsInDeck, 16, "HCFencingSchool");       
	xsArraySetString(cardsInDeck, 17, "HCExtensiveFortifications");        
	xsArraySetString(cardsInDeck, 18, "HCHandCavalryHitpointsIt");     
	xsArraySetString(cardsInDeck, 19, "HCEngineeringSchool");             
	xsArraySetString(cardsInDeck, 20, "ArchaicInfantryAttack");            
	xsArraySetString(cardsInDeck, 21, "ArchaicInfantryHitpoints");           
	xsArraySetString(cardsInDeck, 22, "HCSacraments"); 
	xsArraySetString(cardsInDeck, 23, "HCCavalryDamageGermanTeam");             
	xsArraySetString(cardsInDeck, 24, "HCXPRanching");         
	xsArraySetString(cardsInDeck, 25, "HCXPLandGrab");         
	xsArraySetString(cardsInDeck, 26, "HCXPEconomicTheory");         
	xsArraySetString(cardsInDeck, 27, "HCAdvancedMill");    
	xsArraySetString(cardsInDeck, 28, "HCShipCoinCrates1");        
	xsArraySetString(cardsInDeck, 29, "HCShipCrossbowInf"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCShipCrossbowInf");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	
}

void malteseStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "HCXPIndustrialRevolution");
	xsArraySetString(cardsInDeck, 1, "HCUnlockFactory");             
	xsArraySetString(cardsInDeck, 2, "HCHeavyFortifications"); 
	xsArraySetString(cardsInDeck, 3, "TreasurySup"); 
	xsArraySetString(cardsInDeck, 4, "HCColonialEstancias");   
	xsArraySetString(cardsInDeck, 5, "HCUnlockFort");  	
	xsArraySetString(cardsInDeck, 6, "HCCaballeros");         
	xsArraySetString(cardsInDeck, 7, "HCHandCavalryCombatSpanish");         
	xsArraySetString(cardsInDeck, 8, "HCHandInfantryCombatGerman");       
	xsArraySetString(cardsInDeck, 9, "HCXPTercioTactics");   
	xsArraySetString(cardsInDeck, 10, "HCShipCoveredWagons");         
	xsArraySetString(cardsInDeck, 11, "HCShipWoodCrates4");          
	xsArraySetString(cardsInDeck, 12, "HCInquisition");         
	xsArraySetString(cardsInDeck, 13, "HCRoyalDecreeSpanish");         
	xsArraySetString(cardsInDeck, 14, "HCRidingSchool");               
	xsArraySetString(cardsInDeck, 15, "HCFencingSchool");             
	xsArraySetString(cardsInDeck, 16, "HCExtensiveFortifications");       
	xsArraySetString(cardsInDeck, 17, "HCHandCavalryHitpointsSpanish");        
	xsArraySetString(cardsInDeck, 18, "HCHandCavalryDamageSpanish");  
	xsArraySetString(cardsInDeck, 19, "HCHandInfantryHitpointsGerman");             
	xsArraySetString(cardsInDeck, 20, "HCHandInfantryDamageSpanishTeam");            
	xsArraySetString(cardsInDeck, 21, "HCShipCoinCrates3");           
	xsArraySetString(cardsInDeck, 22, "HCXPLandGrab"); 
	xsArraySetString(cardsInDeck, 23, "HCXPRanching");             
	xsArraySetString(cardsInDeck, 24, "HCXPEconomicTheory");         
	xsArraySetString(cardsInDeck, 25, "HCAdvancedMillGerman");         
	xsArraySetString(cardsInDeck, 26, "HCArchaicTrainingTeam");         
	xsArraySetString(cardsInDeck, 27, "HCShipSettlers3");    
	xsArraySetString(cardsInDeck, 28, "HCShipCoinCrates1");        
	xsArraySetString(cardsInDeck, 29, "HCXPShipRedolerosRepeat"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCXPShipRedolerosRepeat");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	
}

void colombiansStandardLandDeck(void)
{
	gHaveFameAgeUpCard = true;
	if(cardsInDeck == -1) cardsInDeck = xsArrayCreateString(30, "", "cardsInDeck");
	if(cardsPriority == -1) cardsPriority = xsArrayCreateInt(30, -1, "cardsPriority");
	xsArraySetString(cardsInDeck, 0, "HCXPIndustrialRevolution");
	xsArraySetString(cardsInDeck, 1, "HCUnlockFactory");             
	xsArraySetString(cardsInDeck, 2, "HCHeavyFortifications"); 
	xsArraySetString(cardsInDeck, 3, "TreasurySup"); 
	xsArraySetString(cardsInDeck, 4, "HCColonialEstancias");   
	xsArraySetString(cardsInDeck, 5, "HCUnlockFort");  	
	xsArraySetString(cardsInDeck, 6, "HCCaballeros");         
	xsArraySetString(cardsInDeck, 7, "HCHandCavalryCombatSpanish");         
	xsArraySetString(cardsInDeck, 8, "HCHandInfantryCombatGerman");       
	xsArraySetString(cardsInDeck, 9, "HCXPTercioTactics");   
	xsArraySetString(cardsInDeck, 10, "HCShipCoveredWagons");         
	xsArraySetString(cardsInDeck, 11, "HCShipWoodCrates4");          
	xsArraySetString(cardsInDeck, 12, "HCInquisition");         
	xsArraySetString(cardsInDeck, 13, "HCRoyalDecreeSpanish");         
	xsArraySetString(cardsInDeck, 14, "HCRidingSchool");               
	xsArraySetString(cardsInDeck, 15, "HCFencingSchool");             
	xsArraySetString(cardsInDeck, 16, "HCExtensiveFortifications");       
	xsArraySetString(cardsInDeck, 17, "HCHandCavalryHitpointsSpanish");        
	xsArraySetString(cardsInDeck, 18, "HCHandCavalryDamageSpanish");  
	xsArraySetString(cardsInDeck, 19, "HCHandInfantryHitpointsGerman");             
	xsArraySetString(cardsInDeck, 20, "HCHandInfantryDamageSpanishTeam");            
	xsArraySetString(cardsInDeck, 21, "HCShipCoinCrates3");           
	xsArraySetString(cardsInDeck, 22, "HCXPLandGrab"); 
	xsArraySetString(cardsInDeck, 23, "HCXPRanching");             
	xsArraySetString(cardsInDeck, 24, "HCXPEconomicTheory");         
	xsArraySetString(cardsInDeck, 25, "HCAdvancedMillGerman");         
	xsArraySetString(cardsInDeck, 26, "HCArchaicTrainingTeam");         
	xsArraySetString(cardsInDeck, 27, "HCShipSettlers3");    
	xsArraySetString(cardsInDeck, 28, "HCShipCoinCrates1");        
	xsArraySetString(cardsInDeck, 29, "HCXPShipRedolerosRepeat"); 

	int j = 1;
	for (i = 0; < 30)
	{
		xsArraySetInt(cardsPriority, i, j);
		j++;
	}
	
	if(cardsUnderAttack == -1) cardsUnderAttack = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	if(cardsUnderAttackPriority == -1) cardsUnderAttackPriority = xsArrayCreateInt(1, -1, "cardsUnderAttack");
	xsArraySetString(cardsUnderAttack, 0, "HCXPShipRedolerosRepeat");  xsArraySetInt(cardsUnderAttackPriority, 0, 1);
	
}
//==============================================================================
/*
 rule buyCards
 updatedOn 2023/01/27
 Have the AI buy cards and add them to their deck, note now pre made decks are used
 cuttent deck types are
 - StandardLandDeck
 - StandardWaterDeck
 
 How to use
 auto called at the start of the game
*/
//==============================================================================
void pfbuyCards_setDeck(int pCiv = -1, int deckType = 0)
{
	
	switch(deckType)
	{ //deck types
		case 0: 
		{
			if(pCiv == cCivBritish) bririshStandardLandDeck();
			else if(getCivIsJapan() == true) japanStandardLandDeck();
			else if(pCiv == cCivSpanish) spanishStandardLandDeck();
			else if(pCiv == cCivFrench) frenchStandardLandDeck();
			else if(pCiv == cCivPortuguese) portugueseStandardLandDeck();
			else if(pCiv == cCivDutch) dutchStandardLandDeck();
			else if(pCiv == cCivGermans) germansStandardLandDeck();
			else if(pCiv == cCivRussians) russianStandardLandDeck();
			else if(pCiv == cCivOttomans) ottomansStandardLandDeck();
			else if(pCiv == cCivXPIroquois) iroquoisStandardLandDeck();
			else if(pCiv == cCivXPSioux) siouxStandardLandDeck();
			else if(pCiv == cCivXPAztec) aztecStandardLandDeck();
			else if(pCiv == cCivChinese) chineseStandardLandDeck();
			else if(pCiv == cCivIndians) indiansStandardLandDeck();
			else if(pCiv == cCivUSA) USAStandardLandDeck();
			else if(pCiv == cCivSwedish) swedishStandardLandDeck();
			else if(pCiv == cCivItalians) italiansStandardLandDeck();
			else if(pCiv == cCivMaltese) malteseStandardLandDeck();
			else if(pCiv == cCivColombians) colombiansStandardLandDeck();
			break;	
		}
		case 1: 
		{
			if(pCiv == cCivBritish) bririshStandardLandDeck();
			else if(getCivIsJapan() == true) japanStandardLandDeck();
			else if(pCiv == cCivSpanish) japanStandardLandDeck();
			else if(pCiv == cCivFrench) frenchStandardLandDeck();
			else if(pCiv == cCivPortuguese) portugueseStandardLandDeck();
			else if(pCiv == cCivDutch) dutchStandardLandDeck();
			else if(pCiv == cCivGermans) germansStandardLandDeck();
			else if(pCiv == cCivRussians) russianStandardLandDeck();
			else if(pCiv == cCivOttomans) ottomansStandardLandDeck();
			else if(pCiv == cCivXPIroquois) iroquoisStandardLandDeck();
			else if(pCiv == cCivXPSioux) siouxStandardLandDeck();
			else if(pCiv == cCivXPAztec) aztecStandardLandDeck();
			else if(pCiv == cCivChinese) chineseStandardLandDeck();
			else if(pCiv == cCivUSA) USAStandardLandDeck();
			else if(pCiv == cCivSwedish) swedishStandardLandDeck();
			else if(pCiv == cCivItalians) italiansStandardLandDeck();
			else if(pCiv == cCivMaltese) malteseStandardLandDeck();
			else if(pCiv == cCivColombians) colombiansStandardLandDeck();
			break;
		}
	} //end switch
	
} //end pfbuyCards_setDeck

void buyCards()
{
	static int pBuyLoops = 0; //Counts the number of loops happen before the ai buy all their cards
	static int pDeckType = 0; //Choose which deck to use
	static int pNumOfHCcards = -1;
	static int pMaxLoops = 20; //Max loops to try to buy cards
	static int pMaxLoopsBeforeBuyAny = 10; //Max loops before the ai will buy any card to fill their deck
	//static int pMaxDeckSize = 30; //max deck size
	
	if(pNumOfHCcards == -1) pNumOfHCcards = aiHCCardsGetTotal(); //get the total amount of cards once
	if (cvOkToBuildDeck == false || aiHCDeckGetNumberCards(gDefaultDeck) == maxDeckSize || pBuyLoops > pMaxLoops) return;
	pBuyLoops++;
	for (i = 0; <= pNumOfHCcards)
	{ //Buy all cards that are not already bought, Note: This has to run every loop as the ai cannot buy all cards on the first go 
		if(aiHCCardsIsCardBought(i) == false) aiHCCardsBuyCard(i); //check if card is bought
		if(pBuyLoops > pMaxLoopsBeforeBuyAny) aiHCDeckAddCardToDeck(gDefaultDeck, i); //The ai has tried pMaxLoopsBeforeBuyAny times, however has not brought all their cards, so just buy anything now
	} //end for
	
	if(cardsInDeck == -1) 
	{//Select new cards to add to the ai deck
		//deck types
		if(gMapTypeIsland == true)
		{//island
			pDeckType = 1;
		}
		else
		{
			pDeckType = 0;
		}
		pfbuyCards_setDeck(gCurrentCiv,pDeckType); //set a card set to buy
	} //end if
	for (i = 0; <= pNumOfHCcards)
	{ //loop through number of cards
		for (j = 0; < maxDeckSize)
		{ //loop through deck cards that was set in pfbuyCards_setDeck			
			if (kbGetTechName(aiHCCardsGetCardTechID(i)) == xsArrayGetString(cardsInDeck, j) ) 
			{ //check for match			
				aiHCDeckAddCardToDeck(gDefaultDeck, i); //add match card
				break;
			} //end if
		} //end for j
	} //end for i
	
} //end buyCards


//==============================================================================
/* shipGrantedHandler()
	
	
	
	Update 02/10/2004:  New algorithm.
	1)  Clear the list
	2)  Get all the settlers you can.
	3)  If space remains, get the resource you're lowest on.
	
	Update on 04/22/2004:  New algorithm:
	1)  First year, get wood
	2)  Later years, get the resource that gives the largest bucket.
	3)  In a tie, coin > food > wood
	Note, in the early years, the resourceManager will sell food and buy wood as needed
	to drive early housing growth.
	
	Update on 4/27/2004:  Get wood for first TWO years.
	
	Scrapped on 5/12/2004.  Now, settlers have to be imported.  New logic:
	1)  Get settlers always, except:
	2)  If I can afford governor and I don't have him yet, get him
	3)  If I can afford viceroy and I don't have him yet and he's available, get him.
	4)  If settlers aren't available or less than 10 are available, get most needed resource.
	
	August:  Always get an age upgrade if you can.  Otherwise, compute the value for each bucket,
	and choose the best buy.  
	
	November:  Adding multiplier for econ/mil units based on rush/boom emphasis
*/
//==============================================================================
	
void shipGrantedHandler(int parm = -1) // Event handler
{
	if(kbResourceGet(cResourceShips) == 1)return; //check if there is a shipment ready
	static int lastRunTime = 0;
	if(functionDelay(lastRunTime, 10000,"shipGrantedHandler") == false) return;
	lastRunTime = gCurrentGameTime;	
	
	static int pBestCardToPlay = -1;
	static int pBestCardToPlayValue = -1;
	static int pCardsPlayedAge1 = 0;
	static int pCardsPlayedAge2 = 0;
	static int pMaxCardsForAge1 = 0;
	static int pMaxCardsForAge2 = 2;
	static int pCardArray = -1;
	static int pPriorityArray = -1;
	static int pNumOfCardsInDeck = -1;
	static int pPlayedCards = 0;
	
	pBestCardToPlay = -1;
	pBestCardToPlayValue = 99999;
	pCardArray = cardsInDeck;
	pPriorityArray = cardsPriority;
	pNumOfCardsInDeck = aiHCDeckGetNumberCards(gDefaultDeck);
	if(gMainBaseUnderAttack == true)
	{ //when under attack only play under attack cards
		pCardArray = cardsUnderAttack;
		pPriorityArray = cardsUnderAttackPriority;					
	} //end if

	for(i = 0; < pNumOfCardsInDeck)
	{ //loop through all cards in deck
		if(aiHCDeckCanPlayCard(i) == false || aiHCDeckGetCardAgePrereq(gDefaultDeck,i) > gCurrentAge) continue;
		if((gCurrentAge == 0 && pCardsPlayedAge1 > pMaxCardsForAge1) || (gCurrentAge == 1 && pCardsPlayedAge2 > pMaxCardsForAge2)) continue;
		for (j = 0; < maxDeckSize)
		{ //loop through cards
			if (kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == xsArrayGetString(pCardArray, j) && pBestCardToPlayValue > xsArrayGetInt(pPriorityArray, j)) 
			{ //check for a match
				if(xsArrayGetInt(pPriorityArray, j) > 20 && gCurrentAge < 3) continue;
				if(gTreatyActive && aiHCDeckGetCardUnitType(gDefaultDeck,i) == cHCCardTypeMilitary )continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "TreasurySup" && gCurrentFame < 2000) continue;
				if(kbUnitIsType(aiHCDeckGetCardUnitType(gDefaultDeck,i), cUnitTypeLogicalTypeTCBuildLimit))
				{
					if(kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter)) continue;
					if(kbUnitCount(cMyID, cUnitTypeCoveredWagon,cUnitStateABQ) > 0)continue;
				}
				
			
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCUnlockFactory" && kbUnitCount(cMyID, cUnitTypeFactory, cUnitStateABQ) == kbGetBuildLimit(cMyID, cUnitTypeFactory)) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCRobberBarons" && kbUnitCount(cMyID, cUnitTypeFactory, cUnitStateABQ) == kbGetBuildLimit(cMyID, cUnitTypeFactory)) continue;
				
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCRobberBarons" && kbUnitCount(cMyID, cUnitTypeFactoryWagon, cUnitStateABQ) > 0) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCUnlockFactory" && kbUnitCount(cMyID, cUnitTypeFactoryWagon, cUnitStateABQ) > 0) continue;
			
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCUnlockFort" && kbUnitCount(cMyID, cUnitTypeFortFrontier, cUnitStateABQ) == kbGetBuildLimit(cMyID, cUnitTypeFortFrontier)) continue;	
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCXPUnlockFort2" && kbUnitCount(cMyID, cUnitTypeFortFrontier, cUnitStateABQ) == kbGetBuildLimit(cMyID, cUnitTypeFortFrontier)) continue;	
				
				//if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCUnlockFort" && kbUnitCount(cMyID, cUnitTypeFortFrontier, cUnitStateABQ) > 0) continue;
				//if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCXPUnlockFort2" && kbUnitCount(cMyID, cUnitTypeFortFrontier, cUnitStateABQ) > 0) continue;

				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCShipCoveredWagons" && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter) ) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCShipCoveredWagons2" && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter) ) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCConestogaWagonsTeam" && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter) ) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCShipCoveredWagonsGerman" && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter) ) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCShipCoveredWagons3" && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter) ) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCXPIroquoisOneidaSupport" && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter) ) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "YPHCShipCoveredWagonsAsian" && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter) ) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "YPHCShipCoveredWagonsChina" && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter) ) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "YPHCShipCoveredWagonsIndians" && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter) ) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "YPHCShipCoveredWagons2Indians" && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter) ) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "YPHCShipCoveredWagonsJapan" && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter) ) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCShipCoveredWagonsAztec" && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter) ) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCShipCoveredWagonsSioux" && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter) ) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCShipCoveredWagonsIroquois" && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter) ) continue;
				if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,i)) == "HCREVCoveredWagon" && kbUnitCount(cMyID, gTownCenter, cUnitStateABQ) == kbGetBuildLimit(cMyID, gTownCenter) ) continue;
				pBestCardToPlay = i;
				pBestCardToPlayValue = xsArrayGetInt(pPriorityArray, j);
			}
		}
	}	




	if(pBestCardToPlay == -1) return;
	
	if(gCurrentAge == 0) pCardsPlayedAge1++;
	if(gCurrentAge == 1) pCardsPlayedAge2++;
	
	if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,pBestCardToPlay)) == "HCXPNationalRedoubt") gNationalRedoubtEnabled = true;
	if(kbGetTechName(aiHCDeckGetCardTechID(gDefaultDeck,pBestCardToPlay)) == "HCBlockhouseCannon") gBlockhouseEngineeringEnabled = true;
	aiHCDeckPlayCard(pBestCardToPlay);
	pPlayedCards++;	
}

void cardsMain()
{

}