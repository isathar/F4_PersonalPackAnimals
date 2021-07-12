Scriptname PersonalPackAnimals:PPAPackAnimalManagerQuestScript extends Quest Conditional
{manager for pack animal list, taming, events}


;/ stores a captured and dismissed pack animals /;
Struct ProductionQueueSlot
	int 	iProdType = 			-1
	float 	fProdFinishedTime = 	0.0
	float 	fProdChance = 			100.0
EndStruct


;********		Properties

Group PackAnimalManagement
{basic pack animal management - keywords, avs}
	RefCollectionAlias Property 	pActivePackAnimalsRC 			auto const mandatory
	{collection for all active pack animals}
	RefCollectionAlias Property 	pTrackedPackAnimalsRC 			auto const mandatory
	{collection for tracked active pack animals}
	
	RefCollectionAlias Property 	pDeadPackAnimalsRC 				auto const mandatory
	{collection for dead pack animals}
	RefCollectionAlias Property 	pTrackedDeadPackAnimalsRC 		auto const mandatory
	{collection for tracked active pack animals}
	
	RefCollectionAlias Property 	pIdlePackAnimalsRC 				auto const mandatory
	{collection for idle pack animals}
	
	RefCollectionAlias Property 	pTrapperNPCsRC 					auto const mandatory
	{collection for trapper npcs}
	RefCollectionAlias Property 	pGuardNPCsRC 					auto const mandatory
	{collection for guard npcs}
	
	RefCollectionAlias Property 	pLuredAnimals					auto const mandatory
	{collection for animals attracted by a lure}
	
	ReferenceAlias Property 		pDialogueAlias 					auto Const mandatory
	{alias for dialogue target}
	
	Message Property 				pCreateMessage_Pos 				auto Const mandatory
	{shown on animal creation success}
	Message Property 				pCreateMessage_Neg 				auto Const mandatory
	{shown on animal creation failure}
	Message Property 				pPackInventoryPick				auto Const mandatory
	{pack choice message}
	
	GlobalVariable Property 		pCurNumPackAnimals 				auto Const mandatory
	{stores the number of active pack animals}
	GlobalVariable Property 		pMaxNumPackAnimals 				auto Const mandatory
	{stores the current max number of active pack animals}
	
	Holotape Property 				pConfigHolotape					auto Const mandatory
	{configuration holotape to add to player inventory}
	Keyword[] Property 				pTrackingModKeywords			auto Const mandatory
	{keywords to check for when toggling tracking}
	
	Container Property 				pPackInventoryContainer 		auto Const mandatory
	{container object for storage pack inventory}
	Container Property 				pPackInventoryContainer_Ammo	auto Const mandatory
	{container object for ammo pack inventory}
	Container Property				pPackInventoryContainer_Delivery auto Const mandatory
	{container object for delivery pack inventory}
	
	Keyword Property 				pGuardLinkKW 					auto Const mandatory
	
	Message Property 				pFoodMsg_Warning				auto Const mandatory
	Message Property 				pFoodMsg_Starving				auto Const mandatory
	Message Property 				pFoodMsg_Time					auto Const mandatory
	
	Message Property 				pStatusMsg_Offloading			auto Const mandatory
	Message Property 				pStatusMsg_Returning			auto Const mandatory
	Message Property 				pStatusMsg_CleanupDead			auto Const mandatory
	
	Message Property 				pBehaviorMsg_Aggressive			auto Const mandatory
	Message Property 				pBehaviorMsg_Defensive			auto Const mandatory
	Message Property 				pBehaviorMsg_Coward				auto Const mandatory
	
	Message Property 				pNPCProtectedMsg				auto Const mandatory
	Message Property 				pNPCMortalMsg					auto Const mandatory
	
	Message Property 				pInvCont_CapacityMsg			auto Const mandatory
	Message Property 				pInvCont_AmmoBagMsg				auto Const mandatory
EndGroup

Group PackAnimalLeveling
{pack animal leveling properties}
	Keyword[] Property				pPackAnimalLevelKWs				auto Const mandatory
	ObjectMod[] Property			pPackAnimalLevelMods			auto Const mandatory
	Message[] Property				fPackAnimalLevelMsgs			auto Const mandatory
	float[] Property				fPackAnimalLevelThresholds		auto Const mandatory
EndGroup

Group PackAnimalOptions
{global variables for options that affect the entire mod}
	GlobalVariable Property 		pDeadDeleteTime 				auto Const mandatory
	{days to wait before cleaning up dead}
	GlobalVariable Property 		pMaxWaitTime 					auto Const mandatory
	{days to wait before returning to home settlement when ordered to wait}
	GlobalVariable Property 		pPackAnimalSurvival				auto Const mandatory
	{toggle for survival tweaks}
	GlobalVariable Property 		pTrainingTimeMult 				auto Const mandatory
	{multiplier for all pack animal training times}
	GlobalVariable Property			pTrackingCheatToggle			auto Const mandatory
	{toggle for tracking without implants}
	GlobalVariable Property			pProtectedGuardsToggle			auto Const mandatory
	{toggle for protected guards}
	GlobalVariable Property			pPackCapacityCheat				auto Const mandatory
	{toggles capacity limit on/off}
	
EndGroup

Group PackAnimalTaming
{capturing and taming-related variables}
	FormList Property 				pPackAnimalTypes 				auto Const mandatory
	{list of base actors for each type of pack animal}
	FormList Property 				pPackAnimalTypes_F 				auto Const mandatory
	{list of base actors for each type of pack animal}
	
	FormList Property 				pPackAnimalRaces 				auto Const mandatory
	{list of default races ordered by pPackanimalTypes}
	FormList Property 				pPackAnimalRacesCustom			auto Const mandatory
	{list of custom races ordered by pPackanimalTypes}
	
	float[] Property 				pTameAnimalChances 				auto Const mandatory
	{chances to tame each animal}
	Message Property 				pTamingMessagePos 				auto Const mandatory
	{taming success message}
	Message Property 				pTamingMessageJoin 				auto Const mandatory
	{taming success join/send to settlement message box}
	Message Property 				pTamingMessageInvalid 			auto Const mandatory
	{invalid target message}
	Message Property 				pTamingMessageNeg 				auto Const mandatory
	{taming failure message}
	
	FormList[] Property 			pValidDefaultSkins				auto Const mandatory
	int[] Property 					pMaxSkinsPerType				auto Const mandatory
	
	FormList Property 				pValidDefaultAnimalBases 		auto Const mandatory
	
	Message Property 				pOrderSuccessMsg_Trapper		auto const mandatory
	Message Property 				pOrderSuccessMsg_Institute		auto const mandatory
	Message Property 				pOrderFailedMsg_Trapper			auto const mandatory
	
	Perk[] Property 				pCaptureChancePerks				auto Const mandatory
	{perks that increase the chance of capturing animals}
EndGroup

Group PackAnimalStats
{stats menu display variables}
	Message Property 				pStatsMessage 					auto const mandatory
	GlobalVariable Property 		pStatsGlobal1 					auto Const mandatory
	GlobalVariable Property 		pStatsGlobal2 					auto Const mandatory
	GlobalVariable Property 		pStatsGlobal3 					auto Const mandatory
	GlobalVariable Property 		pStatsGlobal4	 				auto Const mandatory
	GlobalVariable Property 		pStatsGlobal5 					auto Const mandatory
	GlobalVariable Property 		pStatsGlobal6 					auto Const mandatory
EndGroup

Group PackAnimalAVs
{actor values used by scripts}
	ActorValue Property 			pHealthRegenAV 					auto Const mandatory
	{HealRate}
	ActorValue Property 			pCarryWeightAV 					auto Const mandatory
	{CarryWeight}
	ActorValue Property 			pSpeedMultAV 					auto Const mandatory
	{SpeedMult}
	ActorValue Property 			pDamageResistAV 				auto Const mandatory
	{DamageResistance}
EndGroup

Group PackAnimalTravel
{travel-related properties}
	Keyword Property 				pCurHomeLink 					auto Const mandatory
	{current home linked reference}
	Keyword Property 				pCurDestLink 					auto Const mandatory
	{current destination linked references}
	Keyword Property 				pTravelMenuKeyword 				auto Const mandatory
	{destination picker menu keyword}
EndGroup

Group DLCCheckProperties
{DLC + mod compatibility checks}
	GlobalVariable Property 		pHasWWDLC 						auto Const mandatory
	{Wasteland Workshop}
	GlobalVariable Property 		pHasFHDLC 						auto Const mandatory
	{Far Harbor}
	GlobalVariable Property 		pHasNWDLC 						auto Const mandatory
	{Nuka World}
	
	GlobalVariable Property 		pHasATMod						auto Const mandatory
	{AmmoTweaks}
	GlobalVariable Property 		pHasCSMod						auto Const mandatory
	{Classic Skills}
	
EndGroup

Group ErrorMessages
	Message Property				pErrorNoPackObject				auto Const mandatory
	Message Property				pErrorNoDestLink				auto Const mandatory
	
EndGroup


Message Property 					pModInstalledMessage 			auto Const mandatory
{mod installation message/prompt}

WorkshopParentScript Property 		WorkshopParent 					auto const mandatory
{link to WorkshopParentQuest}

;/trapper/institute production queues  				*saved /;
ProductionQueueSlot[] Property	 	ProductionQueue_Trappers		auto hidden
ProductionQueueSlot[] Property		ProductionQueue_Institute		auto hidden

;/beacon for returning pack animals  				*saved /;
ObjectReference Property 			PackAnimalBeaconRef				auto hidden


;********		Variables

;/timers/;
int 	iTimerIndex_Tick = 			7 			const
float 	fTimerInterval_Tick = 		0.5			const

;/cached objective indices/;
int 	iObjective_TrackActive = 	0			const
int 	iObjective_TrackDead = 		1			const
int 	iObjective_TrackIdle = 		2			const
int 	iObjective_TrackLiving = 	4			const

;/DLC names for compatibility checks/;
string 	sWWDLCName = 	"DLCworkshop01.esm" 	Const
string 	sFHDLCName = 	"DLCCoast.esm" 			Const
string 	sNWDLCName = 	"DLCNukaWorld.esm" 		Const

;/Mod names for compatibility checks/;
string 	sATModName = 	"AmmoTweaks.esm" 		Const
string 	sCSModName = 	"ClassicSkills.esm" 	Const


;/ Custom Event definitions /;
CustomEvent PackAnimalTickEvent
CustomEvent PackAnimalBeaconEvent
CustomEvent UpgradePackCapacityEvent


;/ external access to script /;
PersonalPackAnimals:PPAPackAnimalManagerQuestScript Function GetScript() Global
	return Game.GetFormFromFile(7901, "PersonalPackAnimals.esp") as PersonalPackAnimals:PPAPackAnimalManagerQuestScript
EndFunction


;********		Events

;/ Tick /;
Event OnTimerGameTime(int aiTimerID)
	if aiTimerID == iTimerIndex_Tick
		SendPackAnimalTickEvent(true)
		ProductionTick()
		self.StartTimerGameTime(fTimerInterval_Tick, iTimerIndex_Tick)
	endIf
EndEvent


;********		Functions

;/init/;
Function InitPackAnimalsQuest()
	ProductionQueue_Trappers = new ProductionQueueSlot[0]
	ProductionQueue_Institute = new ProductionQueueSlot[0]
	
	self.UpdateCurrentInstanceGlobal(pCurNumPackAnimals)
	self.UpdateCurrentInstanceGlobal(pMaxNumPackAnimals)
	
	RunCompatibilityCheck()
	
	self.StartTimerGameTime(fTimerInterval_Tick, iTimerIndex_Tick)
	
	(Game.GetPlayer()).AddItem(pConfigHolotape, 1, true)
	
	utility.wait(2.0)
	
	pModInstalledMessage.Show()
EndFunction

;/update/;
Function UpdatePackAnimalQuest()
	
	self.CancelTimerGameTime(iTimerIndex_Tick)
	
	RunCompatibilityCheck()
	
	self.StartTimerGameTime(fTimerInterval_Tick, iTimerIndex_Tick)
EndFunction

;/reset/;
Function ResetPackAnimalQuest()
	self.CancelTimerGameTime(iTimerIndex_Tick)
	
	CleanUpPackAnimalRefs()
	
	ProductionQueue_Trappers = new ProductionQueueSlot[0]
	ProductionQueue_Institute = new ProductionQueueSlot[0]
	
	RunCompatibilityCheck()
	
	self.StartTimerGameTime(fTimerInterval_Tick, iTimerIndex_Tick)
EndFunction

;/cleanup/;
Function CleanupPackAnimalQuest()
	self.CancelTimerGameTime(iTimerIndex_Tick)
	
	
	ProductionQueue_Trappers.Clear()
	ProductionQueue_Institute.Clear()
	
	CleanUpPackAnimalRefs()
	
EndFunction


;/cleans all RefCollectionAliases + deletes pack animals /;
Function CleanUpPackAnimalRefs()
	int i = 0
	ObjectReference animalRef
	PersonalPackAnimals:PPAPackAnimalActorScript tempAnimalScript
	
	pTrackedPackAnimalsRC.RemoveAll()
	pTrackedDeadPackAnimalsRC.RemoveAll()
	
	while i < pActivePackAnimalsRC.GetCount()
		animalRef = pActivePackAnimalsRC.GetAt(i)
		tempAnimalScript = (animalRef as Actor) as PersonalPackAnimals:PPAPackAnimalActorScript
		if tempAnimalScript as bool
			tempAnimalScript.DestroyPackAnimal()
		endIf
		i += 1
	endWhile
	pActivePackAnimalsRC.RemoveAll()
	
	i = 0
	while i < pDeadPackAnimalsRC.GetCount()
		animalRef = pDeadPackAnimalsRC.GetAt(i)
		tempAnimalScript = (animalRef as Actor) as PersonalPackAnimals:PPAPackAnimalActorScript
		if tempAnimalScript as bool
			tempAnimalScript.DestroyPackAnimal()
		endIf
		i += 1
	endWhile
	pDeadPackAnimalsRC.RemoveAll()
	
	i = 0
	while i < pIdlePackAnimalsRC.GetCount()
		animalRef = pIdlePackAnimalsRC.GetAt(i)
		tempAnimalScript = (animalRef as Actor) as PersonalPackAnimals:PPAPackAnimalActorScript
		if tempAnimalScript as bool
			tempAnimalScript.DestroyPackAnimal()
		endIf
		i += 1
	endWhile
	pIdlePackAnimalsRC.RemoveAll()
	
EndFunction


;**** animal taming/production

Function AddToProductionQueue(int iOrderType, int iAnimalType, float fProdTime, float fSuccessChance)
	ProductionQueueSlot newProd = new ProductionQueueSlot
	newProd.iProdType = iAnimalType
	newProd.fProdFinishedTime = fProdTime
	newProd.fProdChance = fSuccessChance
	
	if iOrderType == 0
		ProductionQueue_Trappers.Add(newProd)
		debug.notification("new trapper queue count: " + ProductionQueue_Trappers.length)
	else
		ProductionQueue_Institute.Add(newProd)
		debug.notification("new institute queue count: " + ProductionQueue_Institute.length)
	endIf
	
EndFunction


Function ProductionTick()
	float startTime = Utility.GetCurrentGameTime()
	;/trappers/;
	if ProductionQueue_Trappers.length > 0
		if ProductionQueue_Trappers[0].fProdFinishedTime <= startTime
			float fChance = Math.Min(85.0, ((GetTrapperAliasCount() as float) / 100.0) + ProductionQueue_Trappers[0].fProdChance)
			if fChance <= Utility.RandomFloat(0.0,1.0)
				pOrderSuccessMsg_Trapper.Show()
				CreateAnimalFromData(ProductionQueue_Trappers[0].iProdType, Utility.RandomInt(0,1), Utility.RandomInt(0, (pMaxSkinsPerType[ProductionQueue_Trappers[0].iProdType] - 1)), Game.GetPlayer() as ObjectReference)
			else
				pOrderFailedMsg_Trapper.Show()
			endIf
			ProductionQueue_Trappers.Remove(0)
			debug.notification("new queue count: " + ProductionQueue_Trappers.length)
		endIf
	endIf
	;/institute/;
	if ProductionQueue_Institute.length > 0
		if ProductionQueue_Institute[0].fProdFinishedTime <= startTime
			pOrderSuccessMsg_Institute.Show()
			CreateAnimalFromData(ProductionQueue_Institute[0].iProdType, Utility.RandomInt(0,1), Utility.RandomInt(0, (pMaxSkinsPerType[ProductionQueue_Trappers[0].iProdType] - 1)), Game.GetPlayer() as ObjectReference)
			ProductionQueue_Institute.Remove(0)
			debug.notification("new queue count: " + ProductionQueue_Trappers.length)
		endIf
	endIf
EndFunction


;**** animal creation/taming

;/creates a pack animal from inputs/;
bool Function CreateAnimalFromData(int iAnimalType, int iAnimalSex, int iAnimalSkin, ObjectReference PlacementRef = none)
	bool bRetVal = false
	if PlacementRef as bool
		ActorBase tempActorBase
		if iAnimalSex == 0
			tempActorBase = pPackAnimalTypes.GetAt(iAnimalType) as ActorBase
		else
			tempActorBase = pPackAnimalTypes_F.GetAt(iAnimalType) as ActorBase
		endIf
		ObjectReference PackAnimalRef = PlacementRef.PlaceAtMe(tempActorBase, abForcePersist = true, abDeleteWhenAble = false)
		if PackAnimalRef as bool
			Actor tempActor = PackAnimalRef as Actor
			
			if tempActor as bool
				ActorValue tempVal = Game.GetCommonProperties().FollowerState
				PersonalPackanimals:PPAPackAnimalActorScript tempPA = tempActor as PersonalPackanimals:PPAPackAnimalActorScript
				
				if tempPA as bool
					tempPA.SetPackAnimalSkin(iAnimalSkin)
					
					int menuVar = pTamingMessageJoin.Show()
					utility.wait(0.1)
					if (menuVar == 0)
						AddPackAnimal(PackAnimalRef)
						tempActor.SetValue(tempVal, 1.0)
					else
						Location tempLoc = tempActor.OpenWorkshopSettlementMenu(pTravelMenuKeyword, None, None)
						utility.wait(0.1)
						ObjectReference tempRef = WorkshopParent.GetWorkshopFromLocation(tempLoc) as ObjectReference
						if tempRef as bool
							tempActor.SetLinkedRef(tempRef, pCurHomeLink)
						endIf
						tempActor.SetValue(tempVal, 4.0)
						AddToTrackedIdle(tempActor)
					endIf
					
					bRetVal = true
					
					tempActor.EvaluatePackage(true)
				endIf
			endIf
		endIf
	endIf
	return bRetVal
EndFunction

;/creates a new randomized pack animal of type iIndex/;
Function CreateNewPackAnimal(int iIndex)
	if (iIndex > -1) && (iIndex < pPackAnimalTypes.GetSize())
		if CreateAnimalFromData(iIndex, Utility.RandomInt(0,1), Utility.RandomInt(0, (pMaxSkinsPerType[iIndex] - 1)), (Game.GetPlayer() as ObjectReference))
			pCreateMessage_Pos.Show()
		else
			pCreateMessage_Neg.Show()
		endIf
	else
		pCreateMessage_Neg.Show()
	endIf
EndFunction

;/main entry point for externally creating animals/;
bool Function TryToTameAnimal(Actor animalRef, int tempIndex, float nCaptureChanceMod = 100.0)
	bool retVal = false
	if tempIndex > -1
		float fRand = nCaptureChanceMod * pTameAnimalChances[tempIndex]
		int i = 0
		Actor PlayerActor = Game.GetPlayer()
		while i < pCaptureChancePerks.length
			if PlayerActor.HasPerk(pCaptureChancePerks[i])
				fRand += 2.0
			endIf
			i += 1
		endWhile
		fRand += PlayerActor.GetValue(Game.GetLuckAV())
		
		if utility.RandomFloat(0.0, 100.0) <= fRand
			if CreateAnimalFromData(tempIndex, (animalRef.GetBaseObject() as ActorBase).GetSex(), GetEquippedSkinIndex(animalRef, tempIndex), animalRef as ObjectReference)
				pTamingMessagePos.Show()
			else
				pTamingMessageInvalid.Show()
			endIf
			
			retVal = true
		else
			pTamingMessageNeg.Show()
		endIf
	else
		pTamingMessageInvalid.Show()
	endIf
	return retVal
EndFunction


;/returns the index of the skin currently equipped by the default animal animalRef/;
int Function GetEquippedSkinIndex(Actor animalRef, int tempIndex)
	int i = 0
	int iRetVal = 0
	int iMax = pValidDefaultSkins[tempIndex].GetSize()
	while i < iMax
		if animalRef.IsEquipped(pValidDefaultSkins[tempIndex].GetAt(i))
			iRetVal = i
			i = iMax
		endIf
		i += 1
	endWhile
	return iRetVal
EndFunction


;**** list management

;/all active pack animals list/;
Function AddPackAnimal(ObjectReference tempRef)
	bool bTrack = false
	if pActivePackAnimalsRC.Find(tempRef) < 0
		pActivePackAnimalsRC.AddRef(tempRef)
	endIf
	
	if pTrackingCheatToggle.GetValue() > 0.0
		bTrack = true
	else
		int i = 0
		while i < pTrackingModKeywords.length
			if (tempRef as Actor).WornHasKeyword(pTrackingModKeywords[i])
				bTrack = true
				i = pTrackingModKeywords.length
			endIf
			i += 1
		endWhile
	endIf
	
	if bTrack
		if pTrackedPackAnimalsRC.Find(tempRef) < 0
			pTrackedPackAnimalsRC.AddRef(tempRef)
		endIf
		if !IsObjectiveDisplayed(iObjective_TrackActive)
			SetObjectiveDisplayed(iObjective_TrackActive, True, True)
		endIf
	endIf
	
	int tempCount = pActivePackAnimalsRC.GetCount()
	pCurNumPackAnimals.SetValue(tempCount as float)
	self.UpdateCurrentInstanceGlobal(pCurNumPackAnimals)
	debug.notification("active count: " + pActivePackAnimalsRC.GetCount())
	
EndFunction

Function RemovePackAnimal(ObjectReference tempRef, bool bDelete = false)
	if pTrackedPackAnimalsRC.Find(tempRef) > -1
		pTrackedPackAnimalsRC.RemoveRef(tempRef)
	endIf
	if pTrackedPackAnimalsRC.GetCount() < 1
		if IsObjectiveDisplayed(iObjective_TrackActive)
			SetObjectiveDisplayed(iObjective_TrackActive, False, True)
		endIf
	endIf
	
	if pActivePackAnimalsRC.Find(tempRef) > -1
		pActivePackAnimalsRC.RemoveRef(tempRef)
	endIf
	
	int tempCount = pActivePackAnimalsRC.GetCount()
	pCurNumPackAnimals.SetValue(tempCount as float)
	self.UpdateCurrentInstanceGlobal(pCurNumPackAnimals)
	debug.notification("active count: " + tempCount)
	
	ObjectReference guardRef = tempRef.GetLinkedRef(pGuardLinkKW)
	if guardRef as bool
		UnassignAnimalGuard(guardRef)
	endIf
	tempRef.SetLinkedRef(none, pGuardLinkKW)
	
	if bDelete
		PersonalPackAnimals:PPAPackAnimalActorScript tempAnimalScript = (tempRef as Actor) as PersonalPackAnimals:PPAPackAnimalActorScript
		if tempAnimalScript as bool
			tempAnimalScript.DestroyPackAnimal()
		endIf
	endIf
EndFunction

int Function GetAnimalCount_Active()
	return pActivePackAnimalsRC.GetCount()
EndFunction


int[] Function GetPackAnimalCountOfType(int iIndex)
	int iMax = pActivePackAnimalsRC.GetCount()
	int[] iRetVal = new int[0]
	iRetVal.Add(0)
	if iMax > 0
		Actor tempActor
		Race tempRace
		int i = 0
		while i < iMax
			tempActor = pActivePackAnimalsRC.GetAt(i) as Actor
			tempRace = pPackAnimalRacesCustom.GetAt(iIndex) as Race
			if tempRace == tempActor.GetRace()
				iRetVal[0] += 1
				iRetVal.Add(i)
			endIf
			i += 1
		endWhile
	endIf
	return iRetVal
EndFunction


;/tracked dead pack animals list/;
Function AddDeadPackAnimal(ObjectReference tempRef)
	bool bTrack = false
	
	if pTrackingCheatToggle.GetValue() > 0.0
		bTrack = true
	else
		int i = 0
		while i < pTrackingModKeywords.length
			if (tempRef as Actor).WornHasKeyword(pTrackingModKeywords[i])
				bTrack = true
				i = pTrackingModKeywords.length
			endIf
			i += 1
		endWhile
	endIf
	
	if pDeadPackAnimalsRC.Find(tempRef) < 0
		pDeadPackAnimalsRC.AddRef(tempRef)
	endIf
	
	if bTrack
		if pTrackedDeadPackAnimalsRC.Find(tempRef) < 0
			pTrackedDeadPackAnimalsRC.AddRef(tempRef)
		endIf
		if !IsObjectiveDisplayed(iObjective_TrackDead)
			SetObjectiveDisplayed(iObjective_TrackDead, True, True)
		endIf
	endIf
	
	debug.notification("dead count: " + pDeadPackAnimalsRC.GetCount())
EndFunction

Function RemoveDeadPackAnimal(ObjectReference tempRef)
	if pDeadPackAnimalsRC.Find(tempRef) > -1
		pDeadPackAnimalsRC.RemoveRef(tempRef)
	endIf
	
	if pTrackedDeadPackAnimalsRC.Find(tempRef) > -1
		pTrackedDeadPackAnimalsRC.RemoveRef(tempRef)
	endIf
	if pDeadPackAnimalsRC.GetCount() < 1
		if IsObjectiveDisplayed(iObjective_TrackDead)
			SetObjectiveDisplayed(iObjective_TrackDead, False, True)
		endIf
	endIf
	debug.notification("dead count: " + pDeadPackAnimalsRC.GetCount())
EndFunction

int Function GetAnimalCount_Dead()
	return pDeadPackAnimalsRC.GetCount()
EndFunction


;/tracked active pack animals list/;
Function AddToTrackedActive(Actor tempRef)
	bool bTrack = false
	if pTrackingCheatToggle.GetValue() > 0.0
		bTrack = true
	else
		int i = 0
		while i < pTrackingModKeywords.length
			if tempRef.WornHasKeyword(pTrackingModKeywords[i])
				bTrack = true
				i = pTrackingModKeywords.length
			endIf
			i += 1
		endWhile
	endIf
	
	if bTrack
		if pTrackedPackAnimalsRC.Find(tempRef) < 0
			pTrackedPackAnimalsRC.AddRef(tempRef)
		endIf
		if !IsObjectiveDisplayed(iObjective_TrackActive)
			SetObjectiveDisplayed(iObjective_TrackActive, True, True)
		endIf
	else
		if pTrackedPackAnimalsRC.Find(tempRef) > -1
			pTrackedPackAnimalsRC.RemoveRef(tempRef)
		endIf
		if pTrackedPackAnimalsRC.GetCount() < 1
			if IsObjectiveDisplayed(iObjective_TrackActive)
				SetObjectiveDisplayed(iObjective_TrackActive, False, True)
			endIf
		endIf
	endIf
	
	int tempCount = pTrackedPackAnimalsRC.GetCount()
	debug.notification("tracked count: " + pTrackedPackAnimalsRC.GetCount())
EndFunction

Function RemoveFromTrackedActive(Actor tempRef)
	if pTrackedPackAnimalsRC.Find(tempRef) > -1
		pTrackedPackAnimalsRC.RemoveRef(tempRef)
	endIf
	if pTrackedPackAnimalsRC.GetCount() < 1
		if IsObjectiveDisplayed(iObjective_TrackActive)
			SetObjectiveDisplayed(iObjective_TrackActive, False, True)
		endIf
	endIf
	
	int tempCount = pTrackedPackAnimalsRC.GetCount()
	debug.notification("tracked count: " + pTrackedPackAnimalsRC.GetCount())
EndFunction

int Function GetAnimalCount_Tracked()
	return pTrackedPackAnimalsRC.GetCount()
EndFunction


;/Idle pack animals list/;
Function AddToTrackedIdle(Actor tempRef)
	if pIdlePackAnimalsRC.Find(tempRef) < 0
		pIdlePackAnimalsRC.AddRef(tempRef)
	endIf
	debug.notification("idle count: " + pIdlePackAnimalsRC.GetCount())
EndFunction

Function RemoveFromTrackedIdle(Actor tempRef)
	if pIdlePackAnimalsRC.Find(tempRef) > -1
		pIdlePackAnimalsRC.RemoveRef(tempRef)
	endIf
	debug.notification("idle count: " + pIdlePackAnimalsRC.GetCount())
EndFunction

int Function GetAnimalCount_Idle()
	return pIdlePackAnimalsRC.GetCount()
EndFunction


;/ Pack animal dialogue alias management /;
Function AddDialogueTarget(ObjectReference tempRef)
	ObjectReference checkRef = pDialogueAlias.GetRef()
	if tempRef != checkRef
		if checkRef as bool
			pDialogueAlias.Clear()
		endIf
		pDialogueAlias.ForceRefTo(tempRef)
		tempRef.Activate(Game.GetPlayer() as ObjectReference, true)
	endIf
EndFunction

Function ClearDialogueTarget()
	if pDialogueAlias.GetRef()
		pDialogueAlias.Clear()
	endIf
EndFunction


ObjectReference Function TempSetDialogueTarget(int iIndex)
	return pActivePackAnimalsRC.GetAt(iIndex)
EndFunction


;**** Commands/Actions

;/Main/;
Function CommandPackanimal_Follow(Actor tempAnimal)
	PersonalPackanimals:PPAPackAnimalActorScript tempPA = tempAnimal as PersonalPackanimals:PPAPackAnimalActorScript
	if tempPA as bool
		tempPA.OrderFollowing()
	endIf
	ClearDialogueTarget()
EndFunction

Function CommandPackAnimal_WaitHere(Actor tempAnimal)
	PersonalPackanimals:PPAPackAnimalActorScript tempPA = tempAnimal as PersonalPackanimals:PPAPackAnimalActorScript
	if tempPA as bool
		tempPA.OrderWaiting()
	endIf
	ClearDialogueTarget()
EndFunction

Function CommandPackanimal_Dismiss(Actor tempAnimal)
	PersonalPackanimals:PPAPackAnimalActorScript tempPA = tempAnimal as PersonalPackanimals:PPAPackAnimalActorScript
	if tempPA as bool
		tempPA.OrderDismiss()
	endIf
	ClearDialogueTarget()
EndFunction


;/travel/;
Function CommandPackAnimal_WaitAt(Actor tempAnimal)
	PersonalPackanimals:PPAPackAnimalActorScript tempPA = tempAnimal as PersonalPackanimals:PPAPackAnimalActorScript
	if tempPA as bool
		tempPA.OrderTravelTo(false)
	endIf
	ClearDialogueTarget()
EndFunction

Function CommandPackanimal_OffloadAt(Actor tempAnimal)
	PersonalPackanimals:PPAPackAnimalActorScript tempPA = tempAnimal as PersonalPackanimals:PPAPackAnimalActorScript
	if tempPA as bool
		tempPA.OrderTravelTo(true)
	endIf
	ClearDialogueTarget()
EndFunction

Function PackAnimalAction_SetHome(Actor tempAnimal)
	PersonalPackanimals:PPAPackAnimalActorScript tempPA = tempAnimal as PersonalPackanimals:PPAPackAnimalActorScript
	if tempPA as bool
		tempPA.SetHomeSettlement()
	endIf
	ClearDialogueTarget()
EndFunction


;/equipment/;
Function PlacePackAnimalEquipBench(Actor tempAnimal)
	PersonalPackanimals:PPAPackAnimalActorScript tempPA = tempAnimal as PersonalPackanimals:PPAPackAnimalActorScript
	if tempPA as bool
		tempPA.OpenEquipment()
	endIf
	ClearDialogueTarget()
EndFunction

Function PackAnimalAction_Feed(Actor tempAnimal)
	
	ClearDialogueTarget()
EndFunction

Function PackAnimalAction_Trade(Actor tempAnimal)
	PersonalPackanimals:PPAPackAnimalActorScript tempPA = tempAnimal as PersonalPackanimals:PPAPackAnimalActorScript
	if tempPA as bool
		int menuVar = pPackInventoryPick.Show()
		tempPA.OpenPackInventory(menuVar)
	endIf
	ClearDialogueTarget()
EndFunction


;/behavior/;
Function PackAnimalAction_SetAggressive(Actor tempAnimal)
	PersonalPackanimals:PPAPackAnimalActorScript tempPA = tempAnimal as PersonalPackanimals:PPAPackAnimalActorScript
	if tempPA as bool
		tempPA.ToggleAggressionLevel()
	endIf
	ClearDialogueTarget()
EndFunction

Function PackAnimalAction_SetProtected(Actor tempAnimal)
	PersonalPackanimals:PPAPackAnimalActorScript tempPA = tempAnimal as PersonalPackanimals:PPAPackAnimalActorScript
	if tempPA as bool
		tempPA.ToggleProtectedStatus()
	endIf
	ClearDialogueTarget()
EndFunction

Function PackAnimalAction_SetFollowDistance(Actor tempAnimal)
	PersonalPackanimals:PPAPackAnimalActorScript tempPA = tempAnimal as PersonalPackanimals:PPAPackAnimalActorScript
	if tempPA as bool
		tempPA.ToggleFollowDistance()
	endIf
	ClearDialogueTarget()
EndFunction

;/misc/;
Function PackAnimalAction_ShowStats(Actor tempAnimal)
	PersonalPackanimals:PPAPackAnimalActorScript tempPA = tempAnimal as PersonalPackanimals:PPAPackAnimalActorScript
	if tempPA as bool
		tempPA.ShowStatsMenu()
	endIf
	ClearDialogueTarget()
EndFunction



;/			Misc functions			/;

;/ animal stats display menu /;
Function ShowStatsMenu(Actor animalRef, float val1, float val2, float val3, float val4, float val5, float val6)
	pStatsGlobal1.SetValue(val1)
	UpdateCurrentInstanceGlobal(pStatsGlobal1)
	pStatsGlobal2.SetValue(val2)
	UpdateCurrentInstanceGlobal(pStatsGlobal2)
	pStatsGlobal3.SetValue(val3)
	UpdateCurrentInstanceGlobal(pStatsGlobal3)
	pStatsGlobal4.SetValue(val4)
	UpdateCurrentInstanceGlobal(pStatsGlobal4)
	pStatsGlobal5.SetValue(val5)
	UpdateCurrentInstanceGlobal(pStatsGlobal5)
	pStatsGlobal5.SetValue(val6)
	UpdateCurrentInstanceGlobal(pStatsGlobal6)
	pStatsMessage.Show()
	utility.wait(0.5)
EndFunction


;/ toggle tracking cheat /;
Function ToggleTrackingMode(bool trackingBool)
	if trackingBool
		Self.SetObjectiveDisplayed(iObjective_TrackActive, False, True)
		Self.SetObjectiveDisplayed(iObjective_TrackLiving, True, True)
	else
		Self.SetObjectiveDisplayed(iObjective_TrackLiving, False, True)
		Self.SetObjectiveDisplayed(iObjective_TrackActive, True, True)
	endIf
EndFunction


Function CheckPackAnimalLevelUp(Actor tempAnimal, float fCurtimeAlive)
	int i = 0
	while i < fPackAnimalLevelThresholds.length
		if fCurtimeAlive >= fPackAnimalLevelThresholds[i]
			if !(tempAnimal.HasKeyword(pPackAnimalLevelKWs[i]))
				if tempAnimal.AttachMod(pPackAnimalLevelMods[i])
					fPackanimalLevelMsgs[i].Show()
					i = fPackAnimalLevelThresholds.length
				endIf
			endIf
		endIf
		i += 1
	endWhile
EndFunction


Function UpdateCapturedGlobals()
	pCurNumPackAnimals.SetValue(GetAnimalCount_Active() as float)
	self.UpdateCurrentInstanceGlobal(pCurNumPackAnimals)
EndFunction


;**** Trappers

;/assigns/unassigns a trapper to its alias/;
Function AssignTrapper(ObjectReference newTrapper)
	if pTrapperNPCsRC.Find(newTrapper) < 0
		pTrapperNPCsRC.AddRef(newTrapper)
	endIf
	debug.notification("trapper count: " + pTrapperNPCsRC.GetCount())
EndFunction

Function UnassignTrapper(ObjectReference oldTrapper)
	if pTrapperNPCsRC.Find(oldTrapper) > -1
		pTrapperNPCsRC.RemoveRef(oldTrapper)
	endIf
	debug.notification("trapper count: " + pTrapperNPCsRC.GetCount())
EndFunction

int Function GetTrapperAliasCount()
	return pTrapperNPCsRC.GetCount()
EndFunction

;/cleans up the trapper alias list/;
Function UpdateTrapperAliases()
	int i = pTrapperNPCsRC.GetCount() - 1
	ObjectReference tempRef
	while i > -1
		tempRef = pTrapperNPCsRC.GetAt(i)
		if (tempRef.GetLinkedRef(pCurHomeLink) == none)
			pTrapperNPCsRC.RemoveRef(tempRef)
		endIf
		i -= 1
	endWhile
EndFunction


;**** Guards

Function AssignPackAnimalGuard(ObjectReference tempGuard)
	if pGuardNPCsRC.Find(tempGuard) < 0
		pGuardNPCsRC.AddRef(tempGuard)
	endIf
	debug.notification("guard count: " + pGuardNPCsRC.GetCount())
EndFunction

Function UnassignAnimalGuard(ObjectReference tempGuard)
	if pGuardNPCsRC.Find(tempGuard) > -1
		pGuardNPCsRC.RemoveRef(tempGuard)
	endIf
	debug.notification("guard count: " + pGuardNPCsRC.GetCount())
EndFunction

int Function GetAnimalGuardCount()
	return pGuardNPCsRC.GetCount()
EndFunction

;/cleans up the trapper alias list/;
Function UpdateGuardAliases()
	int i = pGuardNPCsRC.GetCount() - 1
	ObjectReference tempRef
	while i > -1
		tempRef = pGuardNPCsRC.GetAt(i)
		if (tempRef.GetLinkedRef(pCurDestLink) == none)
			pGuardNPCsRC.RemoveRef(tempRef)
		endIf
		i -= 1
	endWhile
EndFunction


;**** Lured Animals

;pLuredAnimals

Function AddLuredAnimals(ObjectReference lureRef, float fLureChance, int iMaxLured)
	ObjectReference[] tempRefs = lureRef.FindAllReferencesOfType(pValidDefaultAnimalBases, 512.0)
	if tempRefs.length > 0
		int i = 0
		int iAdded = 0
		while i < tempRefs.length
			if fLureChance <= Utility.RandomFloat(0.0,1.0)
				if tempRefs[i] as Actor
					if pLuredAnimals.Find(tempRefs[i]) < 0
						pLuredAnimals.AddRef(tempRefs[i])
						tempRefs[i].SetLinkedRef(lureRef, pCurDestLink)
						if pLuredAnimals.GetCount() >= iMaxLured
							i = tempRefs.length
						endIf
					endIf
				endIf
			endIf
			i += 1
		endWhile
	endIf
	debug.notification("lured count: " + pLuredAnimals.GetCount())
EndFunction

Function ClearLuredAnimals()
	if pLuredAnimals.GetCount() > 0
		int i = 0
		ObjectReference tempRef
		while i < pLuredAnimals.GetCount()
			tempRef = pLuredAnimals.GetAt(i)
			if tempRef as bool
				tempRef.SetLinkedRef(none, pCurDestLink)
			endIf
			i += 1
		endWhile
		utility.wait(1.0)
		pLuredAnimals.RemoveAll()
	endIf
EndFunction

int Function GetLuredCount()
	return pLuredAnimals.GetCount()
EndFunction


Function RunCompatibilityCheck()
	if Game.IsPluginInstalled(sWWDLCName)
		pHasWWDLC.SetValue(1.0)
	else
		pHasWWDLC.SetValue(0.0)
	endIf
	
	if Game.IsPluginInstalled(sFHDLCName)
		pHasFHDLC.SetValue(1.0)
	else
		pHasFHDLC.SetValue(0.0)
	endIf
	
	if Game.IsPluginInstalled(sNWDLCName)
		pHasNWDLC.SetValue(1.0)
	else
		pHasNWDLC.SetValue(0.0)
	endIf
	
EndFunction



;********		Custom Event Calls

;/ tick custom event /;
Function SendPackAnimalTickEvent(bool trackingBool)
	var[] args = New Var[1]
	args[0] = trackingBool
	self.SendCustomEvent("PackAnimalTickEvent", args)
EndFunction

;/ pack upgrade event /;
Function SendUpgradePackCapacityEvent(ObjectReference tempRef=none, int packCap_Base=0, int packCap_Ammo=0, bool bTrack=false)
	var[] args = New Var[4]
	args[0] = tempRef
	args[1] = packCap_Base
	args[2] = packCap_Ammo
	args[3] = bTrack
	self.SendCustomEvent("UpgradePackCapacityEvent", args)
EndFunction


ObjectReference Function GetBeaconRef()
	return PackAnimalBeaconRef
EndFunction
