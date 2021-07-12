Scriptname PersonalPackAnimals:PPAPackAnimalBeaconScript extends ObjectReference
{used for lures}


float Property 		nTimeToLive = 		60.0 	auto Const
float Property 		nPulseTime = 		5.0 	auto Const
float Property 		nSuccessChance =	15.0	auto Const
int Property 		nMaxLured =			8		auto Const

int iTimerIndex = 1 Const
int iTimesPulsed = 0



Event OnInit()
	UpdateLuredAnimals()
	StartTimer(nPulseTime, iTimerIndex)
EndEvent


Event OnTimer(int aiTimerID)
	if aiTimerID == iTimerIndex
		iTimesPulsed += 1
		if iTimesPulsed < ((nTimeToLive / nPulseTime) as int)
			UpdateLuredAnimals()
			StartTimer(nPulseTime, iTimerIndex)
		else
			ClearLuredAnimals()
			utility.wait(2.0)
			Delete()
		endIf
	endIf
EndEvent


Function UpdateLuredAnimals()
	PersonalPackAnimals:PPAPackAnimalManagerQuestScript tempScript = PersonalPackAnimals:PPAPackAnimalManagerQuestScript.GetScript()
	if tempScript as bool
		tempScript.AddLuredAnimals(self as ObjectReference, nSuccessChance, nMaxLured)
	endIf
EndFunction

Function ClearLuredAnimals()
	PersonalPackAnimals:PPAPackAnimalManagerQuestScript tempScript = PersonalPackAnimals:PPAPackAnimalManagerQuestScript.GetScript()
	if tempScript as bool
		tempScript.ClearLuredAnimals()
	endIf
EndFunction
