Scriptname PersonalPackAnimals:PPAPackAnimalSpawnerScript extends ObjectReference Const
{creates pack animals from a crafted miscobject}


Group SpawnedAnimalBase
	Race Property 				pDefaultAnimalRace 			auto Const mandatory
	{default race corresponding to this pack animal's race}
	int Property 				nPackAnimalType 			auto Const mandatory
	{index of the type of pack animal to create}
	bool Property 				bFromWorkshop = 	false 	auto Const
	{convert a workshop actor to pack animal actor}
EndGroup

WorkshopParentScript Property 	WorkshopParent 				auto const mandatory
{workshop link}


Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	If akNewContainer == (Game.GetPlayer() as ObjectReference)
		if bFromWorkshop
			bool bFound = false
			WorkshopScript playerLocWorkshop = WorkshopParent.GetWorkshopFromLocation(Game.GetPlayer().GetCurrentLocation())
			Actor tempActor
			ActorBase tempAB
			ObjectReference[] WorkshopActors
			int iLastIndex = -1
			
			if playerLocWorkshop as bool
				WorkshopActors = playerLocWorkshop.GetWorkshopResourceObjects()
				int tempCount = WorkshopActors.length
				int i = 0
				if tempCount > 0
					while i < tempCount
						tempActor = (WorkshopActors[i] as Actor)
						if tempActor as bool
							if tempActor.GetRace() == pDefaultAnimalRace
								tempAB = tempActor.GetBaseObject() as ActorBase
								if !(tempAB.IsUnique()) && !(tempAB.IsEssential())
									iLastIndex = i
									i = tempCount
									bFound = true
								endIf
							endIf
						endIf
						i += 1
					endWhile
				endIf
				
				if !bFound
					WorkshopActors = WorkshopParent.GetWorkshopActors(playerLocWorkshop)
					tempCount = WorkshopActors.length
					if tempCount > 0
						i = 0
						while i < tempCount
							tempActor = (WorkshopActors[i] as Actor)
							if tempActor as bool
								if tempActor.GetRace() == pDefaultAnimalRace
									tempAB = tempActor.GetBaseObject() as ActorBase
									if !(tempAB.IsUnique()) && !(tempAB.IsEssential())
										iLastIndex = i
										i = tempCount
										bFound = true
									endIf
								endIf
							endIf
							i += 1
						endWhile
					endIf
				endIf
				
				if bFound
					PersonalPackAnimals:PPAPackAnimalManagerQuestScript tempScript = PersonalPackAnimals:PPAPackAnimalManagerQuestScript.GetScript()
					if tempScript as bool
						if tempScript.TryToTameAnimal(tempActor, nPackAnimalType, 100.0)
							if tempActor as bool
								WorkshopNPCScript tempWSNPC = tempActor as WorkshopNPCScript
								if tempWSNPC
									WorkshopParent.UnassignActor(tempWSNPC, true, true)
								endIf
								utility.wait(0.5)
								tempActor.Disable()
								utility.wait(0.5)
								tempActor.Delete()
							endIf
						endIf
					endIf
				endIf
			endIf
		else
			PersonalPackAnimals:PPAPackAnimalManagerQuestScript tempScript = PersonalPackAnimals:PPAPackAnimalManagerQuestScript.GetScript()
			if tempScript as bool
				tempScript.CreateNewPackAnimal(nPackAnimalType)
			endIf
		endIf
		akNewContainer.RemoveItem(self, 1, true)
	else
		akNewContainer.RemoveItem(self, 1, true)
	endIf
	
	
EndEvent
