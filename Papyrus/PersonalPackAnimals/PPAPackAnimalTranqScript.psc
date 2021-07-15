Scriptname PersonalPackAnimals:PPAPackAnimalTranqScript extends ActiveMagicEffect Const
{tranquilizer dart effect}


float Property 					nCaptureChanceMod = 	1.0 	auto const
{multiplier applied to base capture/tame chance}
FormList Property 				pPackAnimalRaces 				auto Const mandatory
{main animal factions supported for capturing}
Message Property pFailedMessage auto Const mandatory


Event OnEffectStart(Actor akTarget, Actor akCaster)
	Form tempRace = akTarget.GetRace() as Form
	int tempIndex = pPackAnimalRaces.Find(tempRace)
	bool bCapture = !(akTarget as WorkshopNPCScript)
	
	if bCapture
		if tempIndex > -1
			PersonalPackAnimals:PPAPackAnimalManagerQuestScript tempScript = PersonalPackAnimals:PPAPackAnimalManagerQuestScript.GetScript()
			if tempScript as bool
				if tempScript.TryToTameAnimal(aktarget, tempIndex, nCaptureChanceMod)
					akTarget.sendAssaultAlarm()
					akTarget.stopCombat()
					akTarget.enableAI(False)
					akTarget.Disable()
					akTarget.Delete()
				endIf
			endIf
		else
			pFailedMessage.Show()
		endIf
	else
		pFailedMessage.Show()
	endIf
EndEvent
