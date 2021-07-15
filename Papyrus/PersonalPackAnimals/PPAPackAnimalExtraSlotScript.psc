Scriptname PersonalPackAnimals:PPAPackAnimalExtraSlotScript extends ObjectReference Const
{upgrade dummy for more animal slots}


GlobalVariable Property 		pCurMaxAnimalCount 				auto Const mandatory
WorkshopParentScript Property 	WorkshopParent 					auto const mandatory

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	if akNewContainer == Game.GetPlayer() as ObjectReference
		pCurMaxAnimalCount.Mod(1.0)
		PersonalPackAnimals:PPAPackAnimalManagerQuestScript tempScript = PersonalPackAnimals:PPAPackAnimalManagerQuestScript.GetScript()
		if tempScript as bool
			tempScript.UpdateCurrentInstanceGlobal(pCurMaxAnimalCount)
		endIf
		
		WorkshopScript playerLocWorkshop = WorkshopParent.GetWorkshopFromLocation(Game.GetPlayer().GetCurrentLocation())
		playerLocWorkshop.RecalculateWorkshopResources()
		
		akNewContainer.RemoveItem(self, 1, true)
	else
		akNewContainer.RemoveItem(self, 1, true)
	endIf
EndEvent
