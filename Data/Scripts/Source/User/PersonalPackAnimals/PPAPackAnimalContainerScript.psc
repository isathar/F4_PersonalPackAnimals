Scriptname PersonalPackAnimals:PPAPackAnimalContainerScript extends ObjectReference
{handles pack containers}


Group PackVars
	bool Property 				bIsAmmoPack = 			false 	auto Const
	{true=allow only ammo}
	
	;/ capacity added by base pack /;
	int Property 				iMaxitems = 			0 		auto hidden
EndGroup

Group PackFilter
	FormList Property 			pHeavyItemsList 				auto Const mandatory
	{items counted as 2 slots}
	FormList Property 			pVeryHeavyItemsList 			auto Const mandatory
	{items counted as 4 slots}
EndGroup

PersonalPackAnimals:PPAPackAnimalManagerQuestScript Property pManagerQuest auto Const mandatory



Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	int iNewItemCount = 0
	
	if akBaseItem as Ammo
		if pManagerQuest.pPackCapacityCheat.GetValue() < 1.0
			iNewItemCount = GetCurInvCount()
			if iNewItemCount <= (iMaxItems)
				ShowCapacityMsg(iNewItemCount as float, iMaxItems as  float)
			else
				RemoveItem(akBaseItem, aiItemCount, true, akSourceContainer)
				ShowCapacityMsg(iNewItemCount as float, iMaxItems as  float)
			endIf
		endIf
	else
		if bIsAmmoPack
			RemoveItem(akBaseItem, aiItemCount, true, akSourceContainer)
			pManagerQuest.pInvCont_AmmoBagMsg.Show()
		else
			if pManagerQuest.pPackCapacityCheat.GetValue() < 1.0
				iNewItemCount = GetCurInvCount()
				if iNewItemCount <= (iMaxItems)
					ShowCapacityMsg(iNewItemCount as float, iMaxItems as  float)
				else
					RemoveItem(akBaseItem, aiItemCount, true, akSourceContainer)
					ShowCapacityMsg(iNewItemCount as float, iMaxItems as  float)
				endIf
			endIf
		endIf
	endIf
EndEvent


int Function GetCurInvCount()
	int ifullCount = GetItemCount()
	int iheavyCount = GetItemCount(pHeavyItemsList)
	int iveryheavyCount = GetItemCount(pVeryHeavyItemsList)
	return (ifullCount - (iheavyCount + iveryheavyCount)) + (iheavyCount * 2) + (iveryheavyCount * 3)
EndFunction

int Function GetCurCapacity()
	return iMaxItems
EndFunction

Function ShowCapacityMsg(float fCurCap=0.0, float fMaxCap=0.0)
	pManagerQuest.pStatsGlobal1.SetValue(fCurCap)
	pManagerQuest.UpdateCurrentInstanceGlobal(pManagerQuest.pStatsGlobal1)
	pManagerQuest.pStatsGlobal2.SetValue(fMaxCap)
	pManagerQuest.UpdateCurrentInstanceGlobal(pManagerQuest.pStatsGlobal2)
	pManagerQuest.pinvCont_CapacityMsg.Show()
EndFunction


;/ link to edit capacity /;
Function SetNewMaxItems(int iNewVal)
	iMaxitems = iNewVal
	ShowCapacityMsg(GetCurInvCount() as float, iMaxItems as  float)
EndFunction
