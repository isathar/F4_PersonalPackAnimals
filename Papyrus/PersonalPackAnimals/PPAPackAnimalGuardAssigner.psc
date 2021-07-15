Scriptname PersonalPackAnimals:PPAPackAnimalGuardAssigner extends WorkshopObjectScript
{temp guard assignment object}


;/TBD: move to pack animal actor/;



Keyword Property pAnimalLinkKW auto const mandatory
Keyword Property pGuardLinkKW auto Const mandatory
Message Property pAnimalAssignMsg auto const mandatory


;/ update recipe display globals when activated /;
Event OnActivate(ObjectReference akActionRef)
	if akActionRef == Game.GetPlayer() as ObjectReference
		
	endIf
EndEvent

;/overriden to force assigned settler into trapper alias/;
function AssignActorCustom(WorkshopNPCScript newActor)
	PersonalPackAnimals:PPAPackAnimalManagerQuestScript tempScript = PersonalPackAnimals:PPAPackAnimalManagerQuestScript.GetScript()
	if tempScript as bool
		tempScript.UpdateGuardAliases()
		int iActiveCount = tempScript.GetAnimalCount_Active()
		int i = 0
		int iMsgOut = -1
		ObjectReference tempRef
		
		while i < iActiveCount
			tempRef = tempScript.TempSetDialogueTarget(i)
			if tempRef as bool
				tempScript.AddDialogueTarget(tempRef)
				utility.wait(0.1)
				iMsgOut = pAnimalAssignMsg.Show()
				utility.wait(0.1)
				
				if iMsgOut == 0
					i = iActiveCount
					newActor.SetLinkedRef(tempRef, pAnimalLinkKW)
					if tempRef.GetLinkedRef(pGuardLinkKW) == none
						tempRef.SetLinkedRef(newActor as ObjectReference, pGuardLinkKW)
						tempScript.AssignPackAnimalGuard(newActor as ObjectReference)
					endIf
				elseif iMsgOut == 2
					if i > 0
						i -= 1
					endIf
				elseif iMsgOut == 3
					i = iActiveCount
				else
					i += 1
				endIf
				tempScript.ClearDialogueTarget()
			else
				i += 1
			endIf	
		endWhile
	endIf
	
	utility.wait(2.0)
	;WorkshopParent.UnassignActor(newActor)
	WorkshopParent.UnassignActorFromObject(newActor, self as WorkshopObjectScript)
endFunction
