;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname PersonalPAckAnimals:Fragments:TIF_PackAnimalManager_Follow_1 Extends TopicInfo Hidden Const

;BEGIN FRAGMENT Fragment_End
Function Fragment_End(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN AUTOCAST TYPE PersonalPackAnimals:PPAPackAnimalManagerQuestScript
PersonalPackAnimals:PPAPackAnimalManagerQuestScript kmyQuest = GetOwningQuest() as PersonalPackAnimals:PPAPackAnimalManagerQuestScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.CommandPackanimal_Follow(akSpeaker.GetDialogueTarget())
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
