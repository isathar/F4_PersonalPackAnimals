Scriptname PersonalPackAnimals:PPAPackAnimalOrderScript extends ObjectReference Const
{adds ordered pack animals to production queue}


Group ProductionVars
	int Property 		iAnimalType = 		-1 			auto Const
	{animal type index}
	int Property 		iOrderType = 		0 			auto Const
	{0=trapper,1=synth}
	float Property 		fProductionTime = 	1.0 		auto Const
	{time in days to create animal}
	float Property 		fSuccessChance = 	1.0 		auto Const
	{chance that a pack animal will be produced}
EndGroup


Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	if akNewContainer == Game.GetPlayer() as ObjectReference
		PersonalPackAnimals:PPAPackAnimalManagerQuestScript tempScript = PersonalPackAnimals:PPAPackAnimalManagerQuestScript.GetScript()
		if tempScript as bool
			tempScript.AddToProductionQueue(iOrderType, iAnimalType, (Utility.GetCurrentGametime() + fProductionTime), fSuccessChance)
		endIf
		akNewContainer.RemoveItem(self, 1, true)
	else
		akNewContainer.RemoveItem(self, 1, true)
	endIf
EndEvent
