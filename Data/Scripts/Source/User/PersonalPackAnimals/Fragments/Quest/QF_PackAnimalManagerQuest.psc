;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname PersonalPAckAnimals:Fragments:Quest:QF_PackAnimalManagerQuest Extends Quest Hidden Const

;BEGIN FRAGMENT Fragment_Stage_0000_Item_00
Function Fragment_Stage_0000_Item_00()
;BEGIN AUTOCAST TYPE PersonalPackAnimals:PPAPackAnimalManagerQuestScript
Quest __temp = self as Quest
PersonalPackAnimals:PPAPackAnimalManagerQuestScript kmyQuest = __temp as PersonalPackAnimals:PPAPackAnimalManagerQuestScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.InitPackAnimalsQuest()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Stage_0020_Item_00
Function Fragment_Stage_0020_Item_00()
;BEGIN AUTOCAST TYPE PersonalPackAnimals:PPAPackAnimalManagerQuestScript
Quest __temp = self as Quest
PersonalPackAnimals:PPAPackAnimalManagerQuestScript kmyQuest = __temp as PersonalPackAnimals:PPAPackAnimalManagerQuestScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.ResetPackAnimalQuest()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Stage_0030_Item_00
Function Fragment_Stage_0030_Item_00()
;BEGIN AUTOCAST TYPE PersonalPackAnimals:PPAPackAnimalManagerQuestScript
Quest __temp = self as Quest
PersonalPackAnimals:PPAPackAnimalManagerQuestScript kmyQuest = __temp as PersonalPackAnimals:PPAPackAnimalManagerQuestScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.CleanupPackAnimalQuest()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
