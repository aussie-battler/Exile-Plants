
/*--------------------------------------------------------------------
	Author: nflug (ofpectag: ACRYL)
    File: fn_checkItemWeight.sqf
	Modified: Kuchenplatte
	<Acryl-Gaming.de>
    Written by nflug - modified and edited by Kuchenplatte
    You're not allowed to use this file without permission from the author!
--------------------------------------------------------------------*/

params [
	["_nitem", "", [""]],
	["_amount", 0, [0]]
];

private _can         = false;
private _newItem     = _nitem;
private _newItemMass = 0;

if (isClass (configFile >> "CfgWeapons" >> _newItem)) then {
	if (isClass (configFile >> "CfgWeapons" >> _newItem >> "weaponSlotsInfo")) then {
		_newItemMass = getNumber (configFile >> "CfgWeapons" >> _newItem >> "weaponSlotsInfo" >> "mass");
	} else {
		_newItemMass = getNumber (configFile >> "CfgWeapons" >> _newItem >> "itemInfo" >> "mass")
	};
} else {
	if (isClass (configFile >> "CfgMagazines" >> _newItem)) then {
		_newItemMass = getNumber (configFile >> "CfgMagazines" >> _newItem >> "mass");
	} else {
		_newItemMass = getNumber (configFile >> "CfgVehicles" >> _newItem >> "mass");
	};
};

_newItemMass = (_newItemMass * _amount);

private _storageItems      = [];
private _totalStorageItems = 0;
private _storage           = [];
private _totalCargoSpace   = 0;

if(backpack player != "") then {
	_storage pushBack backpack player;
	_storageItems = _storageItems + backPackItems player;
};

if(uniform player != "") then {
	_storage pushBack uniform player;
	_storageItems = _storageItems + uniformItems player;
};

if(vest player != "") then {
	_storage pushBack vest player;
	_storageItems = _storageItems + vestItems player;
};

if(count _storage != 0) then {
	{
		private _item  = _x;
		private _cargo = 0;
		private _array = [];

		if (isClass (configFile >> "CfgVehicles" >> _item)) then {
			_cargo = getNumber (configFile >> "CfgVehicles" >> _item >> "maximumLoad");
		} else {
			_array = toArray getText (configFile >> "CfgWeapons" >> _item >> "iteminfo" >> "containerClass");
			
			for "_i" from 6 to (count _array -1) do {
				_cargo = _cargo + 10 ^ (count _array - 1 - _i) * ((_array select _i) - 48);
			};
		};
		_totalCargoSpace = _totalCargoSpace + _cargo;
	} forEach _storage;
};


if (count _storageItems != 0) then {
	{
		private _sitem = _x;
		private _mass  = 0;

		if (isClass (configFile >> "CfgWeapons" >> _sitem)) then {
			if (isClass (configFile >> "CfgWeapons" >> _sitem >> "weaponSlotsInfo")) then {
				_mass = getNumber (configFile >> "CfgWeapons" >> _sitem >> "weaponSlotsInfo" >> "mass");
			} else {
				_mass = getNumber (configFile >> "CfgWeapons" >> _sitem >> "itemInfo" >> "mass")
			};
		} else {
			if (isClass (configFile >> "CfgMagazines" >> _sitem)) then {
				_mass = getNumber (configFile >> "CfgMagazines" >> _sitem >> "mass");
			} else {
				_mass = getNumber (configFile >> "CfgVehicles" >> _sitem >> "mass");
			};
		};
		
	_totalStorageItems = _totalStorageItems + _mass;
	
	} forEach _storageItems
};

_totalCargoSpace = _totalCargoSpace - _totalStorageItems;
_totalCargoSpace = _totalCargoSpace - _newItemMass;

if(_totalCargoSpace > _newItemMass) then {_can = true};

_can;