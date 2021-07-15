scriptname PersonalPackanimals:PPAAnimalGuardAliasScript extends RefCollectionAlias
{handles animal guard dismissal}


Message Property pActivateMessage auto Const mandatory


Event OnActivate(ObjectReference akSenderRef, ObjectReference akActionRef)
	if akActionRef == (Game.GetPlayer() as ObjectReference)
		if pActivateMessage.Show() == 0
			;talk
			akSenderRef.Activate(akActionRef, true)
		else
			;dismiss
			PersonalPackAnimals:PPAPackAnimalManagerQuestScript tempScript = PersonalPackAnimals:PPAPackAnimalManagerQuestScript.GetScript()
			if tempScript as bool
				tempScript.UnassignAnimalGuard(akSenderRef)
			endIf
		endIf
	endIf
EndEvent


Event OnDeath(ObjectReference akSenderRef, Actor akKiller)
	PersonalPackAnimals:PPAPackAnimalManagerQuestScript tempScript = PersonalPackAnimals:PPAPackAnimalManagerQuestScript.GetScript()
	if tempScript as bool
		tempScript.UnassignAnimalGuard(akSenderRef)
	endIf
EndEvent
