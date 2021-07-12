Scriptname PersonalPackAnimals:PPAPackAnimalCraftingObject extends WorkshopObjectScript
{updates recipe globals, handles trapper assignment}


Globalvariable Property 	ppa_gl_AllowTrapperRecipes 		auto Const mandatory
{0.0=no trapper, 1.0=trapper assigned - recipe condition}

PersonalPackAnimals:PPAPackAnimalManagerQuestScript Property pManagerQuest auto Const mandatory


;/moved quest initialization here/;
Event OnInit()
	if !pManagerQuest.GetStageDone(0)
		pManagerQuest.SetStage(0)
	endIf
EndEvent


;/ update recipe display globals when activated /;
Event OnActivate(ObjectReference akActionRef)
	if akActionRef == Game.GetPlayer() as ObjectReference
		pManagerQuest.UpdateCapturedGlobals()
		bool tempCheck = GetAssignedActor() as bool
		if tempCheck
			ppa_gl_AllowTrapperRecipes.SetValue(1.0)
		else
			ppa_gl_AllowTrapperRecipes.SetValue(0.0)
		endIf
	endIf
EndEvent

;/overriden to force assigned settler into trapper alias/;
function AssignActorCustom(WorkshopNPCScript newActor)
	pManagerQuest.UpdateTrapperAliases()
	pManagerQuest.AssignTrapper(newActor as ObjectReference)
	RegisterForCustomEvent(WorkshopParent, "WorkshopActorUnassigned")
endFunction

;/clears old trapper alias/;
Event WorkshopParentScript.WorkshopActorUnassigned(WorkshopParentScript akSender, Var[] args)
	if (args[0] as WorkshopObjectScript) == (self as WorkshopObjectScript)
		utility.wait(2.0)
		pManagerQuest.UpdateTrapperAliases()
		UnRegisterForCustomEvent(WorkshopParent, "WorkshopActorUnassigned")
	endIf
EndEvent
