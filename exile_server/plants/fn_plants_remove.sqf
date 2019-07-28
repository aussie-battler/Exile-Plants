/*--------------------------------------------------------------------
	Author: nflug (ofpectag: ACRYL)
    File: fn_removePlant.sqf
	Modified: Kuchenplatte
	<Acryl-Gaming.de>
    Written by nflug - modified and edited by Kuchenplatte
    You're not allowed to use this file without permission from the author!
--------------------------------------------------------------------*/


private _object = _this select 0;
private _player = _this select 1;

plant_remove = {
	life_plants_amount = life_plants_amount - 1;
	deleteMarkerLocal _this;
};
publicVariable "plant_remove";

plant_message = {
	hint _this;
};
publicVariable "plant_message";

private _name  = _object getVariable "life_plant_name";
private _owner = (_object getVariable ["life_plant_owner",["",""]]);

if((_owner select 0) != getPlayerUID _player) exitWith {
	format["Die Pflanze gehört %1!",_owner select 1] remoteExec ["plant_message", _player];
};

if(_player in allPlayers) then {
	_name remoteExec ["plant_remove", _player]; 
};

deleteVehicle _object;