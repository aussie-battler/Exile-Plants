/*--------------------------------------------------------------------
	Author: nflug (ofpectag: ACRYL)
    File: fn_plantsUse.sqf
	Modified: Kuchenplatte
	<Acryl-Gaming.de>
    Written by nflug - modified and edited by Kuchenplatte
    You're not allowed to use this file without permission from the author!
--------------------------------------------------------------------*/

private _index = -1;
private _menu  = "";

private _display = findDisplay 602;

private _uniformList  = _display displayCtrl 633;
private _vestList     = _display displayCtrl 638;
private _backpackList = _display displayCtrl 619;

switch true do {
	case ((lbCurSel _uniformList) != -1): {
		_menu  = "uniform";
		_index = lbCurSel _uniformList;
	};
	
	case ((lbCurSel _vestList) != -1): {
		_menu  = "vest";
		_index = lbCurSel _vestList;
	};
	
	case ((lbCurSel _backpackList) != -1): {
		_menu  = "backpack";
		_index = lbCurSel _backpackList;
	};
	
	default {};
};

if(_index isEqualTo -1 && _menu isEqualTo "") exitWith {hint "Du musst ein Item auswählen!";};

private _item = "";

switch _menu do {
	case "uniform": {
		_item = _uniformList lbData _index; 
	};
	
	case "vest": {
		_item = _vestList lbData _index; 
	};
	
	case "backpack": {
		_item = _backpackList lbData _index; 
	};
};

if(_item isEqualTo "") exitWith {hint "Kein Item mit diesem Namen gefunden!";};

private _itemList = [];

{
	_itemList pushBack (configName _x);
} forEach ("true" configClasses (missionConfigFile >> "CfgPlants"));

if (_item in _itemList) then {
	[_item] call plants_fnc_plantsAdd;
} else {
	hint "Dieses Item kann nicht angepflanzt werden!";
};