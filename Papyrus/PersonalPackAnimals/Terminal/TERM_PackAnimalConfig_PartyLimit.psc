;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname PersonalPackanimals:Terminal:TERM_PackAnimalConfig_PartyLimit Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
pMaxPackAnimals.SetValue(1.0)
pUpgradeSlots.SetValue(0.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
pMaxPackAnimals.SetValue(8.0)
pUpgradeSlots.SetValue(8.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
pMaxPackAnimals.SetValue(16.0)
pUpgradeSlots.SetValue(8.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_04
Function Fragment_Terminal_04(ObjectReference akTerminalRef)
;BEGIN CODE
pMaxPackAnimals.SetValue(32.0)
pUpgradeSlots.SetValue(8.0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property pMaxPackAnimals Auto Const
GlobalVariable Property pUpgradeSlots Auto Const
