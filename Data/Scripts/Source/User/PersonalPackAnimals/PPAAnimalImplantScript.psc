scriptname PersonalPackAnimals:PPAAnimalImplantScript extends ObjectReference
{tracking implant mods}


PersonalPackAnimals:PPAPackAnimalManagerQuestScript Property pManagerQuest auto Const mandatory


;**** Events

Event OnEquipped(Actor akActor)
	if pManagerQuest.pTrackingCheatToggle.GetValue() < 1.0
		PersonalPackAnimals:PPAPackAnimalActorScript tempAnimalScript = akActor as PersonalPackAnimals:PPAPackAnimalActorScript
		if tempAnimalScript as bool
			tempAnimalScript.AddToTrackedList(true)
		endIf
	endIf
EndEvent

Event OnUnequipped(Actor akActor)
	if pManagerQuest.pTrackingCheatToggle.GetValue() < 1.0
		PersonalPackAnimals:PPAPackAnimalActorScript tempAnimalScript = akActor as PersonalPackAnimals:PPAPackAnimalActorScript
		if tempAnimalScript as bool
			tempAnimalScript.AddToTrackedList(false)
		endIf
	endIf
EndEvent
