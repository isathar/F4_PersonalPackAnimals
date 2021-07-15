Scriptname PersonalPackAnimals:PPAPackAnimalWSConvertScript extends ObjectReference Const
{converts pack animals to default workshop animals}


Group SpawnedAnimalBase
	int Property 				nPackAnimalType 			auto Const mandatory
	{index of the type of pack animal to convert}
	int Property	 			nWSAnimalBase 				auto Const mandatory
	{FormID of the animal's base actor converted to int}
	string Property 			sWSAnimalSource				auto Const mandatory
	{plugin to search for nWSAnimalBase}
EndGroup

Message Property pPickerMessage auto Const mandatory
Message Property pFailedMessage auto Const mandatory

WorkshopParentScript Property 	WorkshopParent 				auto Const mandatory
{workshop link}

bool bShowDebug = true Const


Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	if akNewContainer == (Game.GetPlayer() as ObjectReference)
		if Game.IsPluginInstalled(sWSAnimalSource)
			PersonalPackAnimals:PPAPackAnimalManagerQuestScript tempScript = PersonalPackAnimals:PPAPackAnimalManagerQuestScript.GetScript()
			if tempScript as bool
				int[] iCount = tempScript.GetPackAnimalCountOfType(nPackAnimalType)
				if iCount[0] > 0
					int i = 1
					ObjectReference tempAnimal
					while i <= iCount[0]
						tempAnimal = tempScript.TempSetDialogueTarget(iCount[i])
						tempScript.AddDialogueTarget(tempAnimal)
						utility.wait(0.1)
						int menuVar = pPickerMessage.Show()
						utility.wait(0.1)
						if menuVar == 0
							i = iCount[0] + 1
							tempScript.ClearDialogueTarget()
							WorkshopScript workshopRef = WorkshopParent.GetWorkshopFromLocation(akNewContainer.GetCurrentLocation())
							ActorBase tempAB = Game.GetFormFromFile(nWSAnimalBase, sWSAnimalSource) as ActorBase
							Actor newAnimal = tempAnimal.PlaceAtMe(tempAB, abDeleteWhenAble = false) as Actor
							WorkshopParent.AddActorToWorkshopPUBLIC(newAnimal as WorkshopNPCScript, workshopRef, bResetMode = true)
							tempScript.RemovePackAnimal(tempAnimal, true)
						else
							i += 1
						endIf
					endWhile
				endIf
			endIf
		else
			pFailedMessage.Show()
		endIf
	endIf
	akNewContainer.RemoveItem(self.GetBaseObject(), 1, true)
EndEvent
