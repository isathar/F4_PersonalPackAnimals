Scriptname PersonalPackAnimals:PPATamingPerkUpgradeScript extends ObjectReference Const
{adds the pack animal taming perk to the player}


Perk Property pTamingPerk auto Const mandatory


Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	Actor PlayerActor = Game.GetPlayer()
	if akNewContainer == PlayerActor as ObjectReference
		PlayerActor.AddPerk(pTamingPerk, true)
	endIf
	utility.wait(0.1)
	akNewContainer.RemoveItem(self as ObjectReference, 1, true)
EndEvent
