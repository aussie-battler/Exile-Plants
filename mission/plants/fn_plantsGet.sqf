/*--------------------------------------------------------------------
	Author: nflug (ofpectag: ACRYL)
    File: fn_plantsget.sqf
	Modified: Kuchenplatte
	<Acryl-Gaming.de>
    Written by nflug - modified and edited by Kuchenplatte
    You're not allowed to use this file without permission from the author!
--------------------------------------------------------------------*/

private["_object", "_item", "_itemGet", "_itemName"];

_object = _this select 0;

_owner    = (_object getVariable ["life_plant_owner",["",""]]);
_item     = ((_object getVariable ["life_plant_name",""]) splitString "-") select 0;
_itemGet  = getArray(missionConfigFile >> "CfgPlants" >> _item >> "itemGet");
_itemName = ([_itemGet select 0] call plants_fnc_fetchCfgDetails) select 1;

if((_owner select 0) != getPlayerUID player) exitWith {hint format["Die Pflanze gehört %1!",_owner select 1];};

private _iCheck = _itemGet call plants_fnc_checkItemWeight;
if !_iCheck exitWith {hint "Dein Inventar ist voll!";};

for "_i" from 0 to (_itemGet select 1) - 1 do {
	[true, _itemGet select 0] call plants_fnc_handleItem;
};

titleText [format["<t color='#139822' size='1.2'>Item erhalten</t><br/>Du hast %2x %1 erhalten!",_itemName, _itemGet select 1], "PLAIN DOWN", -1, true, true];
[_object, player] remoteExec ["plants_fnc_plants_remove", 2];