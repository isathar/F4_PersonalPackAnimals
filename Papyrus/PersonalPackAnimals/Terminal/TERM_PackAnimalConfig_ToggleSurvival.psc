;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname PersonalPackanimals:Terminal:TERM_PackAnimalConfig_ToggleSurvival Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
pToggleGlobal.SetValue(1.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
pToggleGlobal.SetValue(0.0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property pToggleGlobal Auto Const Mandatory
