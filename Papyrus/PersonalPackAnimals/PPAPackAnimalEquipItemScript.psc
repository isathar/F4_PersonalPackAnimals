Scriptname PersonalPackAnimals:PPAPackAnimalEquipItemScript extends ObjectReference
{upgrade dummy that adds equipment object mods to pack animals}


Group PackAnimalMod
	ObjectMod Property 			pModToAdd 						auto Const mandatory
	{object mod}
	Keyword Property 			pModToAddKeyword 				auto Const mandatory
	{keyword for this object mod}
	Keyword Property 			pNullModKeyword 				auto Const mandatory
	{null keyword for this attachment slot}
	ObjectMod Property 			pNullMod 						auto Const mandatory
	{null mod for this attachment slot}
EndGroup

Group ModStats
	int Property 				iContainerType = 		0 		auto const
	{0=no pack, 1=pack, 2=ammobag, 3=toppack}
	int Property 				iContainerMaxItems = 	0		auto Const
	{pack capacity, if applicable}
	Race Property 				pRequiredRace 					auto Const mandatory
	{race this mod is for}
	Keyword Property			pPackAnimalKeyword				auto Const mandatory
	{keyword to check if actor is a pack animal}
EndGroup

Message Property pFailedMessage auto Const mandatory



Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	if akOldContainer as bool
		if akOldContainer == Game.GetPlayer() as ObjectReference
			;/ equip /;
			if akNewContainer as Actor
				if (akNewContainer as Actor).GetRace() == pRequiredRace
					if !(akNewContainer.HasKeyword(pModToAddKeyword))
						Actor animalActor = akNewContainer as Actor
						if animalActor.AttachMod(pModToAdd)
							if iContainerType > 0
								PersonalPackAnimals:PPAPackAnimalManagerQuestScript tempScript = PersonalPackAnimals:PPAPackAnimalManagerQuestScript.GetScript()
								if tempScript as bool
									tempScript.SendUpgradePackCapacityEvent(akNewContainer, iContainerType, iContainerMaxItems)
								endIf
							endIf
						endIf
					endIf
				else
					pFailedMessage.Show()
				endIf
			endIf
		else
			if akNewContainer == Game.GetPlayer() as ObjectReference
				Actor containerActor = akOldContainer as Actor
				if containerActor as bool
					if containerActor.IsDead()
						if containerActor.GetRace() == pRequiredRace
							if !(akNewContainer.HasKeyword(pNullModKeyword))
								Actor animalActor = akNewContainer as Actor
								animalActor.AttachMod(pNullMod)
							endIf
						else
							pFailedMessage.Show()
						endIf
					endIf
				endIf
			endIf
		endIf
	endIf
EndEvent
