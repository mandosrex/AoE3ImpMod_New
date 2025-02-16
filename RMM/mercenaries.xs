// ECP code for making recorded games echo their version

void LFP(string xs=""){
	rmAddTriggerEffect("SetIdleProcessing");
	 rmSetTriggerEffectParam("IdleProc", "true);"+xs+"trSetUnitIdleProcessing(true");
}

void chooseMercs(void)
{
	if(rmGetIsKOTH() == true) {
		rmCreateTrigger("NXOUZKOTH");
		rmSwitchToTrigger(rmTriggerID("NXOUZKOTH"));
		rmSetTriggerRunImmediately(true);
		rmSetTriggerPriority(4); 
		rmSetTriggerActive(true);
		rmSetTriggerLoop(false);
        
		rmAddTriggerCondition("Player Unit Count");
		rmSetTriggerConditionParamInt("PlayerID", 0, false);
		rmSetTriggerConditionParam("ProtoUnit", "ypKingsHill", false);
		rmSetTriggerConditionParam("Op", "<=", false);
		rmSetTriggerConditionParam("Count", "0", false);
      
		rmAddTriggerEffect("Send Chat As String");
		rmSetTriggerEffectParam("PlayerID", "0", false);
		rmSetTriggerEffectParam("Message", "<font=MainMenuButtons 18><color=1,0,0>  KotH Monument failed to spawn; please restart the game", false);

		rmAddTriggerEffect("Win Message As String");
		rmSetTriggerEffectParam("Text", "KotH Monument failed to spawn; please restart the game", false);
		rmSetTriggerEffectParam("Sound", "default", false);
		rmSetTriggerEffectParam("IgnoreUserControls", "true", false);
		
		rmAddTriggerEffect("Reveal Map");
		rmAddTriggerEffect("End Game");
		
		// disable KotH check after 1s to prevent the trigger from running when a player takes over King's Hill
		rmCreateTrigger("NXOUZKOTHDISABLE");
		rmSwitchToTrigger(rmTriggerID("NXOUZKOTHDISABLE"));
		rmSetTriggerRunImmediately(true);
		rmSetTriggerPriority(4); 
		rmSetTriggerActive(true);
		rmSetTriggerLoop(false);
        
		rmAddTriggerCondition("Timer");
		rmSetTriggerConditionParamInt("Param1", 1, false);
		
		rmAddTriggerEffect("Disable Trigger");
		rmSetTriggerEffectParamInt("EventID", rmTriggerID("NXOUZKOTH"), false);
	}
}