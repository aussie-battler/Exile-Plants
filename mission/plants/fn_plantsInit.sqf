
/*--------------------------------------------------------------------
	Author: nflug (ofpectag: ACRYL)
    File: fn_plantsInit.sqf
	Modified: Kuchenplatte
	<Acryl-Gaming.de>
    Written by nflug - modified and edited by Kuchenplatte
    You're not allowed to use this file without permission from the author!
--------------------------------------------------------------------*/

_missionObjects = nearestObjects[(visiblePosition player),[],15];
{
	_object = _x;
		
	if (!(lineIntersects [eyePos player, eyePos _object, player, _object])) then {
		_pos = [visiblePosition _object select 0, visiblePosition _object select 1, (getPosATL _object select 2) + 1.5];
		_sPos = worldToScreen _pos;
		_distance = _pos distance player;
			
        if (count _sPos > 1 && {_distance < 15}) then {
		
			if(_object getVariable ["life_plant",false]) then {
	
				_pos = getPosWorld _object;
				_var = _object getVariable ["life_plant_phase",[0,0]];
				_item = ((_object getVariable ["life_plant_name",""]) splitString "-") select 0;
				_itemName = ([_item] call plants_fnc_fetchCfgDetails) select 1;
				_time = _object getVariable ["life_plant_endTime",getNumber(missionConfigFile >> "CfgPlants" >> "plant_time")];
				_owner = (_object getVariable ["life_plant_owner",["",""]]) select 1;
				
				if(playerSide == civilian) then {
					if(_object getVariable ["life_plant_end",false]) then {
						_text = format["%1 Feld von %3 | Endet in: %2sek",_itemName,_time,_owner];
						drawIcon3D ["", [1,1,1,1], [(_pos select 0),(_pos select 1), 1], 0.8, 0.8, 0, _text, 1, 0.0315, "PuristaMedium"];
					} else {
						_text = format["%1 Feld von %5 | Phase: %2 - %3%4",_itemName,_var select 0, _var select 1,"%",_owner];
						drawIcon3D ["", [1,1,1,1], [(_pos select 0),(_pos select 1), 1], 0.8, 0.8, 0, _text, 1, 0.0315, "PuristaMedium"];
					};
				} else {
					_text = format["%1 Feld | Phase: %2",_itemName,_var select 0];
					drawIcon3D ["", [1,1,1,1], [(_pos select 0),(_pos select 1), 1], 0.8, 0.8, 0, _text, 1, 0.0315, "PuristaMedium"];
				};
			};
		};
	};
} forEach _missionObjects;