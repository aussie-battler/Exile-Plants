/*--------------------------------------------------------------------
	Author: nflug (ofpectag: ACRYL)
    File: fn_plantsCreate.sqf
	Modified: Kuchenplatte
	<Acryl-Gaming.de>
    Written by nflug - modified and edited by Kuchenplatte
    You're not allowed to use this file without permission from the author!
--------------------------------------------------------------------*/

private _player    = _this select 0;
private _position  = _this select 1;
private _item      = _this select 2;
private _plantName = _this select 3;

private _itemInfo  = missionConfigFile >> "CfgPlants" >> _item;
private _itemGet   = getArray(_itemInfo >> "itemGet");
private _phases    = getArray(_itemInfo >> "phases");
private _time      = getArray(_itemInfo >> "phase_time");
private _plantTime = getNumber(missionConfigFile >> "CfgPlants" >> "plant_time");

{  
    _x setDamage 1.0;
	_x hideObjectGlobal true;
    deleteVehicle _x; 
} forEach nearestTerrainObjects [_position, ["TREE", "SMALL TREE", "BUSH", "FOREST"], getNumber(missionConfigFile >> "CfgPlants" >> "plants_nearby")];  

create_plant = {
	private _phase = _this select 0;
	private _pos = _this select 1;
	private _name = _this select 2;
	private _owner = _this select 3;
	private _p = _this select 4;
	_pflanze = createVehicle [_phase, _pos, [], 0, "CAN_COLLIDE"];
	_pflanze allowDamage false;
	_pflanze enableSimulation false;
	_pflanze setVariable ["life_plant",true,true];
	_pflanze setVariable ["life_plant_name",_name,true];
	_pflanze setVariable ["life_plant_owner",_owner,true];
	_pflanze setVariable ["life_plant_phase",[_p,0],true];
	_pflanze setVariable ["life_plant_end",false,true];
	_pflanze setVariable ["life_plant_endTime",getNumber(missionConfigFile >> "CfgPlants" >> "plant_time"),true];
	_pflanze;
};

private _pflanze = [(_phases select 0), _position, _plantName, [getPlayerUID _player, name _player], 1] call create_plant;

[_pflanze, ["Pflanze entfernen", {[_this select 0, _this select 1] remoteExec ["plants_fnc_plants_remove", 2]}]] remoteExec ["addAction", -2, _pflanze];

for "_i" from 0 to (_time select 0) step 1 do {
	sleep 1;
	_pflanze setVariable ["life_plant_phase",[1,round(_i / (_time select 0) * 100)],true];
	if(_i == (_time select 0)) exitWith {};
	if(!(_player in allPlayers)) exitWith {}; 
	if(isNull _pflanze) exitWith {};
};

if(isNull _pflanze) exitWith {};
if(!(_player in allPlayers)) exitWith {[_pflanze, _player] call plants_fnc_plants_remove;};

deleteVehicle _pflanze;
private _pflanze = [(_phases select 1), _position, _plantName, [getPlayerUID _player, name _player], 2] call create_plant;

[_pflanze, ["Pflanze entfernen", {[_this select 0, _this select 1] remoteExec ["plants_fnc_plants_remove", 2]}]] remoteExec ["addAction", -2, _pflanze];

for "_i" from 0 to (_time select 1) step 1 do {
	sleep 1;
	_pflanze setVariable ["life_plant_phase",[2,round(_i / (_time select 1) * 100)],true];
	if(_i == (_time select 1)) exitWith {};
	if(!(_player in allPlayers)) exitWith {}; 
	if(isNull _pflanze) exitWith {};
};

if(isNull _pflanze) exitWith {};
if(!(_player in allPlayers)) exitWith {[_pflanze, _player] call plants_fnc_plants_remove;};

deleteVehicle _pflanze;
private _pflanze = [(_phases select 2), _position, _plantName, [getPlayerUID _player, name _player], 3] call create_plant;

removeAllActions _pflanze;
[_pflanze, ["Pflanze ernten", plants_fnc_plantsGet]] remoteExec ["addAction", -2, _pflanze];

_pflanze setVariable ["life_plant_end",true,true];

for "_i" from 0 to _plantTime step 1 do {
	sleep 1;
	_pflanze setVariable ["life_plant_endTime",(_pflanze getVariable "life_plant_endTime") - 1,true];
	if(_i == _plantTime) exitWith {};
	if(!(_player in allPlayers)) exitWith {}; 
	if(isNull _pflanze) exitWith {};
};

if(isNull _pflanze) exitWith {};

[_pflanze, _player] call plants_fnc_plants_remove;