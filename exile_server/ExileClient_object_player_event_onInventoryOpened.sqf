/**
 * ExileClient_object_player_event_onInventoryOpened
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_cancelEvent", "_container", "_secondaryContainer"];
_cancelEvent = false;
_container = _this select 1;
_secondaryContainer = _this select 2; 
try 
{
	if (ExileIsPlayingRussianRoulette) then 
	{
		throw true;
	};
	if (ExileClientIsHandcuffed) then 
	{
		throw true;
	};
	if (ExileClientActionDelayShown) then 
	{
		throw true;
	};
	if (ExileClientIsInConstructionMode) then 
	{
		throw true;
	};
	if ((locked _container) isEqualTo 2) then
	{
		throw true;
	};
	if (_container getVariable ["ExileIsLocked", 1] isEqualTo -1) then 
	{
		throw true;
	};
	if (_container isKindOf "Exile_Container_OldChest") then
	{
		if ((_container animationSourcePhase 'OldChest_Source') < 0.5) then
		{
			throw true; 
		};
	};
	
	disableSerialization;

	_dialog = uiNameSpace getVariable ["RscDisplayInventory", displayNull];
	
	_button1 = _dialog ctrlCreate ["RscButtonMenu",44927];
	_button1 ctrlSetPosition [(6.5 + 17 + 1) * (0.03) + (-0.25),31 * (0.04) + (-0.25),8.5 * (0.03),1 * (0.04)];
	_button1 ctrlSetStructuredText parseText "<t size='1' align='center' font='RobotoCondensed'>Item benutzen</t>";
	_button1 ctrlAddEventHandler ["ButtonClick", "_this call plants_fnc_plantsUse"];
	_button1 ctrlCommit 0;
	
	ExileClientInventoryOpened = true;
	ExileClientCurrentInventoryContainer = _container;
	ExileClientCurrentInventorySecondaryContainer = _secondaryContainer;
}
catch 
{
	_cancelEvent = _exception;
};
_cancelEvent