;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname PersonalPAckAnimals:Fragments:TIF_PackAnimalManager_SetAggressive Extends TopicInfo Hidden Const

;BEGIN FRAGMENT Fragment_End
Function Fragment_End(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN AUTOCAST TYPE PersonalPackAnimals:PPAPackAnimalManagerQuestScript
PersonalPackAnimals:PPAPackAnimalManagerQuestScript kmyQuest = GetOwningQuest() as PersonalPackAnimals:PPAPackAnimalManagerQuestScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.PackAnimalAction_SetAggressive(akSpeaker.GetDialogueTarget())
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
