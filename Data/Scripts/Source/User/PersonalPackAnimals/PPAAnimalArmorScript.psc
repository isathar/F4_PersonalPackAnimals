scriptname PersonalPackAnimals:PPAAnimalArmorScript extends ObjectReference
{handles attaching mods based on addons}


;**** Properties

Group PackObjectMods
{actor object mods that are attached as pack pieces}
	ObjectMod[] Property 	pModsBasePack 			auto Const mandatory
	ObjectMod[] Property 	pModsTopPack 			auto Const mandatory
	ObjectMod[] Property 	pModsAmmoBag 			auto Const mandatory
	ObjectMod[] Property 	pModsPackLamps 			auto Const mandatory
EndGroup

Group PackKeywords
{keywords for actor object mods}
	Keyword[] Property 		pKeywordsBasePack 		auto Const mandatory
	Keyword[] Property 		pKeywordsTopPack 		auto Const mandatory
	Keyword[] Property 		pKeywordsAmmoBag 		auto Const mandatory
	Keyword[] Property 		pKeywordsPackLamps 		auto Const mandatory
	Keyword Property 		pKeywordPackTracker 	auto Const mandatory
EndGroup

Group PackCapacities
{custom inventory capacity values}
	int[] Property 			pCapacityBasePacks 		auto Const mandatory
	int[] Property 			pCapacityTopPacks 		auto Const mandatory
	int[] Property 			pCapacityAmmoBags 		auto Const mandatory
	GlobalVariable Property pCapacityCheatToggle 	auto const mandatory
EndGroup


;**** Events

Event OnEquipped(Actor akActor)
	int iCurCapacity_Base = 0
	int iCurCapacity_Addon = 0
	int iCurCapacity_Ammo = 0
	
	bool bTrack = HasKeyword(pKeywordPackTracker)
	int i = 0
	int iMax = pKeywordsBasePack.length
	while i < pKeywordsBasePack.length
		if HasKeyword(pKeywordsBasePack[i])
			akActor.AttachMod(pModsBasePack[i])
			iCurCapacity_Base = pCapacityBasePacks[i]
			i = iMax
		endIf
		i += 1
	endWhile
	i = 0
	iMax = pKeywordsTopPack.length
	while i < pKeywordsTopPack.length
		if HasKeyword(pKeywordsTopPack[i])
			akActor.AttachMod(pModsTopPack[i])
			iCurCapacity_Addon = pCapacityTopPacks[i]
			i = iMax
		endIf
		i += 1
	endWhile
	i = 0
	iMax = pKeywordsAmmoBag.length
	while i < pKeywordsAmmoBag.length
		if HasKeyword(pKeywordsAmmoBag[i])
			akActor.AttachMod(pModsAmmoBag[i])
			iCurCapacity_Ammo = pCapacityAmmoBags[i]
			i = iMax
		endIf
		i += 1
	endWhile
	i = 0
	iMax = pKeywordsPackLamps.length
	while i < pKeywordsPackLamps.length
		if HasKeyword(pKeywordsPackLamps[i])
			akActor.AttachMod(pModsPackLamps[i])
			i = iMax
		endIf
		i += 1
	endWhile
	
	if pCapacityCheatToggle.GetValue() < 1.0
		int iTotal = iCurCapacity_Base + iCurCapacity_Addon
		PersonalPackAnimals:PPAPackAnimalManagerQuestScript tempScript = PersonalPackAnimals:PPAPackAnimalManagerQuestScript.GetScript()
		if tempScript as bool
			tempScript.SendUpgradePackCapacityEvent(akActor as ObjectReference, iTotal, iCurCapacity_Ammo, bTrack)
		endIf
	endIf
EndEvent

Event OnUnequipped(Actor akActor)
	akActor.AttachMod(pModsAmmoBag[0])
	akActor.AttachMod(pModsTopPack[0])
	akActor.AttachMod(pModsBasePack[0])
	
	if pCapacityCheatToggle.GetValue() < 1.0
		PersonalPackAnimals:PPAPackAnimalManagerQuestScript tempScript = PersonalPackAnimals:PPAPackAnimalManagerQuestScript.GetScript()
		if tempScript as bool
			tempScript.SendUpgradePackCapacityEvent(akActor as ObjectReference, 0, 0, false)
		endIf
	endIf
EndEvent
