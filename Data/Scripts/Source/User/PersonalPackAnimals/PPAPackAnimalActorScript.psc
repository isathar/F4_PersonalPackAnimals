scriptname PersonalPackanimals:PPAPackAnimalActorScript extends Actor
{handles individual pack animals}


;******** 		Properties

Group PackAnimalStats
	int Property 				iPackAnimalType = 		0 		auto Const
	{index of this animal's type}
	FormList Property 			pPossibleSkins					auto Const mandatory
	{list of possible skin items for this animal}
	
EndGroup

Group PackAnimalFood
	FormList Property 			pValidFoods_LowQual				auto Const mandatory
	{food that increases time until next feeding by 3 hours}
	FormList Property			pValidFoods_HighQual			auto Const mandatory
	{food that increases time until next feeding by 6 hours}
	Keyword Property			pBuffFoodKeyword				auto Const mandatory
	{keyword to detect buff food items}
	float Property 				fFeedingInterval = 		6.0		auto Const
	{time in hours without food before this pack animal gets uncomfortable}
	float property 				fTurnOnMasterChance = 	8.0		auto Const
	{chance increase per hour of becoming aggressive when not fed}
EndGroup

PersonalPackanimals:PPAPackAnimalManagerQuestScript Property pManagerQuest auto Const mandatory
{link to pack animal manager quest}


;/containers for pack parts  										*saved /;
PersonalPackAnimals:PPAPackAnimalContainerScript Property PackContainer_Storage 	auto hidden
PersonalPackAnimals:PPAPackAnimalContainerScript Property PackContainer_Ammo 		auto hidden
PersonalPackAnimals:PPAPackAnimalContainerScript Property PackContainer_Delivery 	auto hidden

;/time this pack animal was created - for leveling					*saved /;
float Property					fAnimalTimeStarted = 	-1.0	auto hidden

;/the next time this animal has to be fed by						*saved /;
float Property					fNextFeedingTime = 		-1.0	auto hidden
;/time this pack animal started waiting								*saved /;
float Property					fStartWaitTime =		-1.0	auto hidden

;/the index of the current skin										*saved /;
int Property 					iPackAnimalSkin = 		0		auto hidden

;/this pack animals current level									*saved /;
int Property 					iPackAnimalLevel = 		0		auto hidden


;********		Variables

int iTimerIndex_Tick = 		1 			Const
float fTimerTime_Tick = 	1.0 		Const

float fHourMultiplier = 	0.04167 	Const


;********		Events

Event OnInit()
	;/init follower status/;
	IgnoreFriendlyHits()
	AllowPCDialogue(true)
	SetPlayerTeammate(true, true, false)
	SetLinkedRef(Game.GetPlayer() as ObjectReference, pManagerQuest.pCurDestLink)
	
	;/Init pack containers:/;
	;/ storage pack /;
	ObjectReference tempContainer = PlaceAtMe(pManagerQuest.pPackInventoryContainer, abForcePersist = true, abDeleteWhenAble = false)
	if tempContainer
		PackContainer_Storage = tempContainer as PersonalPackAnimals:PPAPackAnimalContainerScript
		PackContainer_Storage.AttachTo(self as ObjectReference)
		PackContainer_Storage.AddInventoryEventFilter(none)
	else
		pManagerQuest.pErrorNoPackObject.Show()
	endIf
	;/ ammo pack /;
	ObjectReference tempContainer2 = PlaceAtMe(pManagerQuest.pPackInventoryContainer_Ammo, abForcePersist = true, abDeleteWhenAble = false)
	if tempContainer2
		PackContainer_Ammo = tempContainer2 as PersonalPackAnimals:PPAPackAnimalContainerScript
		PackContainer_Ammo.AttachTo(self as ObjectReference)
		PackContainer_Ammo.AddInventoryEventFilter(none)
	else
		pManagerQuest.pErrorNoPackObject.Show()
	endIf
	;/ delivery pack /;
	ObjectReference tempContainer3 = PlaceAtMe(pManagerQuest.pPackInventoryContainer_Delivery, abForcePersist = true, abDeleteWhenAble = false)
	if tempContainer3
		PackContainer_Delivery = tempContainer3 as PersonalPackAnimals:PPAPackAnimalContainerScript
		PackContainer_Delivery.AttachTo(self as ObjectReference)
		PackContainer_Delivery.AddInventoryEventFilter(none)
	else
		pManagerQuest.pErrorNoPackObject.Show()
	endIf
	
	;/feeding time/;
	if fNextFeedingTime < 0.0
		fNextFeedingTime = Utility.GetCurrentGameTime() + (fFeedingInterval * fHourMultiplier)
	endIf
	;/wait time/;
	if fAnimalTimeStarted < 0.0
		fAnimalTimeStarted = Utility.GetCurrentGameTime()
	endIf
	
	;/register custom event listeners/;
	RegisterForCustomEvent(pManagerQuest, "PackAnimalTickEvent")
	RegisterForCustomEvent(pManagerQuest, "UpgradePackCapacityEvent")
	
	;debug.notification("Pack animal initialized")
EndEvent

;/add inventory filter/;
Event OnLoad()
	if pManagerQuest.pPackAnimalSurvival.GetValue() > 0.0
		AddInventoryEventFilter(none)
	endIf
EndEvent

;/remove inventory filter/;
Event OnUnload()
	if pManagerQuest.pPackAnimalSurvival.GetValue() > 0.0
		RemoveInventoryEventFilter(none)
	endIf
EndEvent

;/inventory filter listener/;
Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	if akSourceContainer == (Game.GetPlayer() as ObjectReference)
		if pValidFoods_LowQual.Find(akBaseItem) > -1
			FeedPackAnimal(0)
			RemoveItem(akBaseItem, 1, true)
		elseif pValidFoods_HighQual.Find(akBaseItem) > -1
			FeedPackAnimal(0)
			RemoveItem(akBaseItem, 1, true)
		elseif akBaseItem.HasKeyword(pBuffFoodKeyword)
			EquipItem(akBaseItem)
		endIf
	endIf
EndEvent

;/ init cleanup, add quest tracking if needed /;
Event OnDeath(Actor akKiller)
	;/clean up containers/;
	PackContainer_Storage.RemoveAllItems(self)
	PackContainer_Storage.Delete()
	PackContainer_Storage = none
	PackContainer_Ammo.RemoveAllItems(self)
	PackContainer_Ammo.Delete()
	PackContainer_Ammo = none
	PackContainer_Delivery.RemoveAllItems(self)
	PackContainer_Delivery.Delete()
	PackContainer_Delivery = none
	;/clear linked refs/;
	SetLinkedRef(none, pManagerQuest.pCurDestLink)
	SetLinkedRef(none, pManagerQuest.pCurHomeLink)
	
	ObjectReference tempGuard = GetLinkedRef(pManagerQuest.pGuardLinkKW)
	if tempGuard as bool
		pManagerQuest.UnassignAnimalGuard(tempGuard)
		SetLinkedRef(none, pManagerQuest.pGuardLinkKW)
		pManagerQuest.UpdateGuardAliases()
	endIf
	
	SetPlayerTeammate(false, false, false)
	
	fStartWaitTime = utility.GetCurrentGameTime()
	
	AddToActiveList(false)
	AddToIdleList(false)
	AddToDeadList(true)
EndEvent

;/ enables dialogue when this animal is activated /;
Event OnActivate(ObjectReference akActionRef)
	if akActionRef == Game.GetPlayer() as ObjectReference
		pManagerQuest.AddDialogueTarget(self as ObjectReference)
	endIf
EndEvent


;********		Custom Events

;/ Tick Event /;
Event PersonalPackAnimals:PPAPackAnimalManagerQuestScript.PackAnimalTickEvent(PersonalPackAnimals:PPAPackAnimalManagerQuestScript akSender, Var[] args)
	if IsDead()
		Tick_Dead()
	else
		ActorValue tempVal = Game.GetCommonProperties().FollowerState
		float fCurCommand = GetValue(tempVal)
		if fCurCommand < 1.0
			Tick_Wait()
		elseif fCurCommand < 2.0
			Tick_Active()
			if pManagerQuest.pPackAnimalSurvival.GetValue() > 0.0
				Tick_Hunger()
			endIf
		elseif fCurCommand < 3.0
			Tick_Travel(false)
		elseif fCurCommand < 4.0
			Tick_Travel(true)
		endIf
	endIf
EndEvent

;/ custom event for pack upgrades /;
Event PersonalPackanimals:PPAPackAnimalManagerQuestScript.UpgradePackCapacityEvent(PersonalPackAnimals:PPAPackAnimalManagerQuestScript akSender, Var[] args)
	ObjectReference tempRef = args[0] as ObjectReference
	if tempRef == self as ObjectReference
		int iPackBase = args[1] as int
		int iPackAmmo = args[2] as int
		bool bTrack = args[3] as bool
		SetNewContainerWeight(iPackBase, iPackAmmo)
		AddToTrackedList(bTrack)
	endIf
EndEvent



;********		Functions

;****  Ticks

Function Tick_Hunger()
	float tempFedTime = Utility.GetCurrentGameTime() - fNextFeedingTime
	if (tempFedTime / fHourMultiplier) >= fFeedingInterval
		if Utility.RandomFloat(0.0, 100.0) <= (fTurnOnMasterChance * (tempFedTime - fFeedingInterval))
			PackAnimalTurnOnMaster()
			pManagerQuest.pFoodMsg_Starving.Show()
		else
			pManagerQuest.pFoodMsg_Warning.Show()
		endIf
	else
		if (tempFedTime / fHourMultiplier) >= (fFeedingInterval * 0.25)
			pManagerQuest.pStatsGlobal1.SetValue(-(tempFedTime / fHourMultiplier))
			pManagerQuest.UpdateCurrentInstanceGlobal(pManagerQuest.pStatsGlobal1)
			pManagerQuest.pFoodMsg_Time.Show()
		endIf
	endIf
EndFunction

Function Tick_Active()
	pManagerQuest.CheckPackAnimalLevelUp(self as Actor, (Utility.GetCurrentGameTime() - fAnimalTimeStarted))
EndFunction

Function Tick_Travel(bool bOffLoadGoods)
	ActorValue tempVal = Game.GetCommonProperties().FollowerState
	ObjectReference tempLinkedRef = GetLinkedRef(pManagerQuest.pCurDestLink)
	if tempLinkedRef as bool
		if GetDistance(tempLinkedRef) <= 1024.0
			if bOffLoadGoods
				if PackContainer_Delivery as bool
					PackContainer_Delivery.RemoveAllItems(tempLinkedRef)
					pManagerQuest.pStatusMsg_Offloading.Show()
				else
					pManagerQuest.pErrorNoPackObject.Show()
				endIf
				ObjectReference tempBeacon = pManagerQuest.GetBeaconRef()
				if tempBeacon as bool
					SetLinkedRef(tempBeacon, pManagerQuest.pCurDestLink)
					SetValue(tempVal, 5.0)
				else
					SetLinkedRef(Game.GetPlayer() as ObjectReference, pManagerQuest.pCurDestLink)
					SetValue(tempVal, 1.0)
				endIf
				
				EvaluatePackage(true)
			else
				SetValue(tempVal, 0.0)
				SetLinkedRef(none, pManagerQuest.pCurDestLink)
				EvaluatePackage(true)
			endIf
		endIf
	else
		SetValue(tempVal, 1.0)
		SetLinkedRef(Game.GetPlayer() as ObjectReference, pManagerQuest.pCurDestLink)
		EvaluatePackage(true)
		pManagerQuest.pErrorNoDestLink.Show()
	endIf
EndFunction

Function Tick_Wait()
	if (Utility.GetCurrentGameTime() - fStartWaitTime) >= pManagerQuest.pMaxWaitTime.GetValue()
		ActorValue tempVal = Game.GetCommonProperties().FollowerState
		SetValue(tempVal, 4.0)
		EvaluatePackage(true)
		pManagerQuest.pStatusMsg_Returning.Show()
	endIf
EndFunction


Function Tick_Dead()
	if (Utility.GetCurrentGameTime() - fStartWaitTime) >= pManagerQuest.pDeadDeleteTime.GetValue()
		pManagerQuest.pStatusMsg_CleanupDead.Show()
		AddToDeadList(false)
		UnregisterForAllCustomEvents()
		Delete()
	endIf
EndFunction


;**** Commands

Function OrderFollowing()
	ActorValue tempVal = Game.GetCommonProperties().FollowerState
	ObjectReference PlayerRef = Game.GetPlayer() as ObjectReference
	if GetLinkedRef(pManagerQuest.pCurDestLink) != PlayerRef
		SetLinkedRef(PlayerRef, pManagerQuest.pCurDestLink)
	endIf
	fStartWaitTime = -1.0
	SetValue(tempVal, 1.0)
	AddToIdleList(false)
	AddToActiveList(true)
	EvaluatePackage(true)
EndFunction

Function OrderWaiting()
	ActorValue tempVal = Game.GetCommonProperties().FollowerState
	fStartWaitTime = utility.GetCurrentGameTime()
	SetValue(tempVal, 0.0)
	EvaluatePackage(true)
EndFunction

Function OrderDismiss()
	ActorValue tempVal = Game.GetCommonProperties().FollowerState
	fStartWaitTime = -1.0
	SetValue(tempVal, 4.0)
	AddToActiveList(false)
	AddToIdleList(true)
	EvaluatePackage(true)
EndFunction

Function OrderTravelTo(bool bOffloadGoods)
	ActorValue tempVal = Game.GetCommonProperties().FollowerState
	Location tempLoc = OpenWorkshopSettlementMenu(pManagerQuest.pTravelMenuKeyword, None, None)
	utility.wait(0.1)
	ObjectReference tempRef = pManagerQuest.WorkshopParent.GetWorkshopFromLocation(tempLoc) as ObjectReference
	if tempRef as bool
		SetLinkedRef(tempRef, pManagerQuest.pCurDestLink)
		fStartWaitTime = -1.0
		if bOffloadGoods
			SetValue(tempVal, 3.0)
		else
			SetValue(tempVal, 2.0)
		endIf
		EvaluatePackage(true)
	endIf
EndFunction

Function SetHomeSettlement()
	Location tempLoc = OpenWorkshopSettlementMenu(pManagerQuest.pTravelMenuKeyword, None, None)
	utility.wait(0.1)
	ObjectReference tempRef = pManagerQuest.WorkshopParent.GetWorkshopFromLocation(tempLoc) as ObjectReference
	if tempRef as bool
		SetLinkedRef(tempRef, pManagerQuest.pCurHomeLink)
	endIf
EndFunction


;****  List Management

;/returns this animal type's index/;
int function GetPackAnimalType()
	return iPackAnimalType
EndFunction

;/add this animal to active list/;
Function AddToActiveList(bool bAdd = true)
	if bAdd
		pManagerQuest.AddPackAnimal(self as ObjectReference)
	else
		pManagerQuest.RemovePackAnimal(self as ObjectReference)
	endIf
EndFunction

;/add this animal to dead list/;
Function AddToDeadList(bool bAdd = true)
	if bAdd
		pManagerQuest.AddDeadPackAnimal(self as ObjectReference)
	else
		pManagerQuest.RemoveDeadPackAnimal(self as ObjectReference)
	endIf
EndFunction

;/add this animal to tracked active list/;
Function AddToTrackedList(bool bAdd = true)
	if bAdd
		pManagerQuest.AddToTrackedActive(self as Actor)
	else
		pManagerQuest.AddToTrackedActive(self as Actor)
	endIf
EndFunction

;/add this animal to idle list/;
Function AddToIdleList(bool bAdd = true)
	if bAdd
		pManagerQuest.AddToTrackedIdle(self as Actor)
	else
		pManagerQuest.RemoveFromTrackedIdle(self as Actor)
	endIf
EndFunction


;****  Behavior

Function ToggleAggressionLevel()
	float fCurAggro = GetValue(Game.GetAggressionAV())
	if fCurAggro < 1.0
		SetValue(Game.GetConfidenceAV(), 1.0)
		SetValue(Game.GetAggressionAV(), 1.0)
		pManagerQuest.pBehaviorMsg_Defensive.Show()
	elseif fCurAggro < 2.0
		SetValue(Game.GetConfidenceAV(), 2.0)
		SetValue(Game.GetAggressionAV(), 2.0)
		pManagerQuest.pBehaviorMsg_Aggressive.Show()
	else
		SetValue(Game.GetConfidenceAV(), 0.0)
		SetValue(Game.GetAggressionAV(), 0.0)
		pManagerQuest.pBehaviorMsg_Coward.Show()
	endIf
EndFunction

Function PackAnimalTurnOnMaster()
	SetLinkedRef(none, pManagerQuest.pCurDestLink)
	SetLinkedRef(none, pManagerQuest.pCurHomeLink)
	SetPlayerTeammate(false, false, false)
	AddToActiveList(false)
	SetValue(Game.GetConfidenceAV(), 4.0)
	SetValue(Game.GetAggressionAV(), 3.0)
EndFunction


Function ToggleProtectedStatus()
	ActorBase tempAB = GetBaseObject() as ActorBase
	bool bNewVal = !(tempAB.IsProtected())
	SetProtected(bNewVal)
	if bNewVal
		pManagerQuest.pNPCProtectedMsg.Show()
	else
		pManagerQuest.pNPCMortalMsg.Show()
	endIf
EndFunction


Function ToggleFollowDistance()
	ActorValue tempVal = Game.GetCommonProperties().FollowerDistance
	if GetValue(tempVal) > 0.0
		SetValue(tempVal, 0.0)
		debug.notification("near")
	else
		SetValue(tempVal, 1.0)
		debug.notification("far")
	endIf
EndFunction


;****	Inventory	

;/ opens this pack animals standard inventory /;
Function OpenEquipment()
	OpenInventory(true)
EndFunction

;/ opens this pack animal's pack inventory /;
Function OpenPackInventory(int menuVar)
	if menuVar == 0
		if PackContainer_Storage as bool
			if PackContainer_Storage.GetCurCapacity() > 0
				PackContainer_Storage.Activate(Game.GetPlayer())
			else
				debug.notification("no pack of this type")
			endIf
		endIf
	elseif menuVar == 1
		if PackContainer_Ammo as bool
			if PackContainer_Ammo.GetCurCapacity() > 0
				PackContainer_Ammo.Activate(Game.GetPlayer())
			else
				debug.notification("no pack of this type")
			endIf
		endIf
	elseif menuVar == 2
		if PackContainer_Delivery as bool
			if PackContainer_Delivery.GetCurCapacity() > 0
				PackContainer_Delivery.Activate(Game.GetPlayer())
			else
				debug.notification("no pack of this type")
			endIf
		endIf
	endIf
EndFunction


;/ updates attached containers' capacities /;
Function SetNewContainerWeight(int iPackBase, int iPackAmmo)
	;/base pack addition/;
	if PackContainer_Storage as bool
		PackContainer_Storage.SetNewMaxItems(iPackBase)
	endIf
	;/pack addon addition/;
	if PackContainer_Delivery as bool
		PackContainer_Delivery.SetNewMaxItems(iPackBase)
	endIf
	;/ammo bag addition/;
	if PackContainer_Ammo as bool
		PackContainer_Ammo.SetNewMaxItems(iPackAmmo)
	endIf
EndFunction


Function FeedPackAnimal(int iFoodType = 0)
	float fFoodVal = 3.0
	float fCurTime = Utility.GetCurrentGameTime()
	if iFoodType == 1
		fFoodVal = 6.0
	endIf
	fNextFeedingTime = fCurTime + (fFoodVal * fHourMultiplier)
	if fCurTime - fNextFeedingTime >= fFeedingInterval
		debug.notification("Your pack animal is still hungry")
	else
		debug.notification("Your pack animal is full")
	endIf
EndFunction


;****		Misc

;/ stats display menu /;
Function ShowStatsMenu()
	float val1 = GetLevel() as float
	float val2 = GetValue(Game.GetHealthAV())
	float val3 = GetValue(pManagerQuest.pDamageResistAV)
	float val4 = GetValue(pManagerQuest.pSpeedMultAV)
	float val5 = GetValue(pManagerQuest.pCarryWeightAV)
	float val6 = GetInventoryValue()
	pManagerQuest.ShowStatsMenu(self as Actor, val1, val2, val3, val4, val5, val6)
EndFunction


Function DestroyPackAnimal()
	;/clean up containers/;
	PackContainer_Storage.RemoveAllItems(self)
	PackContainer_Storage.Delete()
	PackContainer_Storage = none
	PackContainer_Ammo.RemoveAllItems(self)
	PackContainer_Ammo.Delete()
	PackContainer_Ammo = none
	PackContainer_Delivery.RemoveAllItems(self)
	PackContainer_Delivery.Delete()
	PackContainer_Delivery = none
	
	;/clear linked refs/;
	SetLinkedRef(none, pManagerQuest.pCurDestLink)
	SetLinkedRef(none, pManagerQuest.pCurHomeLink)
	
	SetPlayerTeammate(false, false, false)
	
	UnregisterForAllCustomEvents()
	Delete()
EndFunction


Function SetPackAnimalSkin(int iIndex)
	Armor tempArmor = pPossibleSkins.GetAt(iIndex) as Armor
	AddItem(tempArmor, 1, true)
	EquipItem(tempArmor, false, true)
	iPackAnimalSkin = iIndex
EndFunction

