/*--------------------------------------------------------------------
	Author: nflug (ofpectag: ACRYL)
    File: fn_plantsADD.sqf
	Modified: Kuchenplatte
	<Acryl-Gaming.de>
    Written by nflug - modified and edited by Kuchenplatte
    You're not allowed to use this file without permission from the author!
--------------------------------------------------------------------*/

private["_item", "_itemInfo", "_itemGet", "_phases", "_resourceZones", "_markerColor", "_markerType", "_zone", "_position", "_marker"];

_item = _this select 0;

if (vehicle player != player) exitWith {titleText ["<t color='#cc0000' size='1.2'>Achtung!</t><br/>Du kannst im Fahrzeug keine Pflanzen anbauen!", "PLAIN DOWN", -1, true, true];};
if (!(playerSide in [civilian,independent])) exitWith {titleText [">t color='#cc0000' size='1.2'>Achtung!</t><br/>Du kannst soetwas nicht anbauen!", "PLAIN DOWN", -1, true, true];};

_itemInfo = missionConfigFile >> "CfgPlants" >> _item;
_itemGet = getArray(_itemInfo >> "itemGet");
_phases = getArray(_itemInfo >> "phases");
_resourceZones = getArray(_itemInfo >> "zones");
_markerColor = getText(_itemInfo >> "marker_color");
_markerType = getText(_itemInfo >> "marker_type");
_zone = true;

{
	_zoneName = _x select 0;
	_zoneSize = _x select 1;
    if ((player distance (getMarkerPos _zoneName)) < _zoneSize) exitWith {_zone = false;};
} forEach _resourceZones;

if (_zone) exitWith {
	titleText [format["<t color='#cc0000' size='1.2'>Achtung!</t><br/>Du bist auf keinem %1 Feld!",([_itemGet select 0] call plants_fnc_fetchCfgDetails) select 1], "PLAIN DOWN", -1, true, true];
};
if !(count (player nearRoads getNumber(missionConfigFile >> "CfgPlants" >> "near_roads")) isEqualTo 0) exitWith {titleText ["<t color='#cc0000' size='1.2'>Achtung!</t><br/>Du kannst keine Pflanzen an einer Straße anbauen!", "PLAIN DOWN", -1, true, true];};
if (surfaceisWater (getPos vehicle player)) exitWith {titleText ["<t color='#cc0000' size='1.2'>Achtung!</t><br/>Du kannst keine Pflanzen im Wasser anbauen!", "PLAIN DOWN", -1, true, true];};

_plants = nearestObjects [player, _phases, getNumber(missionConfigFile >> "CfgPlants" >> "plants_nearby")];
_check = false;
{if(_x getVariable ["life_plant",false]) exitWith {_check = true;};} forEach _plants;
if(count _plants > 0 && _check) exitWith {
	titleText ["<t color='#cc0000' size='1.2'>Achtung!</t><br/>Es ist eine Pflanze in der Nähe!", "PLAIN DOWN", -1, true, true];
};

if(count nearestObjects [player, getArray(missionConfigFile >> "CfgPlants" >> "not_allowed_objects"), getNumber(missionConfigFile >> "CfgPlants" >> "not_allowed_objects_size")] > 0) exitWith {
	titleText ["<t color='#cc0000' size='1.2'>Achtung!</t><br/>Ein nicht erlaubtes Objekt ist in der Nähe!", "PLAIN DOWN", -1, true, true];
};

if(getNumber(missionConfigFile >> "CfgPlants" >> "plant_max") != -1 && life_plants_amount >= getNumber(missionConfigFile >> "CfgPlants" >> "plant_max")) exitWith {
	titleText [format["<t color='#cc0000' size='1.2'>Achtung!</t><br/>Du hast bereits %1 Pflanzen angepflanzt!", getNumber(missionConfigFile >> "CfgPlants" >> "plant_max")], "PLAIN DOWN", -1, true, true];
};

if(!([_item,false] call plants_fnc_handleItem)) exitWith {};
life_plants_amount = life_plants_amount + 1;

_position = getPosATL player;
_name = format["%1-%2",_item,round(random 9999)];
_marker = createMarkerLocal [_name, _position];
_marker setMarkerColorLocal _markerColor;
_marker setMarkerTypeLocal _markerType;
_marker setMarkerAlphaLocal 0.8;
_marker setMarkerTextLocal format["%1 Feld",([_item] call plants_fnc_fetchCfgDetails) select 1];

[player, _position, _item, _name] remoteExec ["plants_fnc_plants_create", 2];