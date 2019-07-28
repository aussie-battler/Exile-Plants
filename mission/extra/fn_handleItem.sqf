/*--------------------------------------------------------------------
	Author: nflug (ofpectag: ACRYL)
    File: fn_handleItem.sqf
	Modified: Kuchenplatte
	<Acryl-Gaming.de>
    Written by nflug - modified and edited by Kuchenplatte
    You're not allowed to use this file without permission from the author!
--------------------------------------------------------------------*/

params [
	["_item", "", [""]],
	["_bool", false, [false]],
	["_ispack", false, [false]],
	["_ongun", false, [false]],
	["_override", false, [false]],
	["_toUniform", false, [false]],
	["_toVest", false, [false]],
	["_preview", false, [false]]
];

if (_item isEqualTo "") exitWith {};

private _isgun   = false;
private _details = [_item] call plants_fnc_fetchCfgDetails;
private _items   = [];

if (count _details isEqualTo 0) exitWith {};

if _bool then {
    switch (_details select 6) do {
	
        case "CfgGlasses": {
            if _toUniform exitWith {player addItemToUniform _item;};
            if _toVest exitWith {player addItemToVest _item;};

            if _ispack then {
                player addItemToBackpack _item;
            } else {
                if _override then {
                    player addItem _item;
                } else {
                    if (!(goggles player isEqualTo "")) then {
                        removeGoggles player;
                    };
                    player addGoggles _item;
                };
            };
        };

        case "CfgVehicles": {
            if (!(backpack player isEqualTo "")) then {
                _items = (backpackItems player);
                removeBackpack player;
            };

            player addBackpack _item;
            clearAllItemsFromBackpack player;

            if (!isNil "_items") then {
                {[_x,true,true,false,true] call plants_fnc_handleItem; } forEach _items;
            };
        };

        case "CfgMagazines": {
            if _toUniform exitWith {player addItemToUniform _item;};
            if _toVest exitWith {player addItemToVest _item;};
            if _ispack exitWith {player addItemToBackpack _item;};

            player addMagazine _item;
        };

        case "CfgWeapons": {
            if _toUniform exitWith {player addItemToUniform _item;};
            if _toVest exitWith {player addItemToVest _item;};
            if _ispack exitWith {player addItemToBackpack _item;};

            if ((_details select 4) in [1,2,4,5,4096]) then {
                if ((_details select 4) isEqualTo 4096) then {
                    if ((_details select 5) isEqualTo -1) then {
                        _isgun = true;
                    };
                } else {
                    _isgun = true;
                };
            };

            if _isgun then {
                if (!_ispack && _override) exitWith {};
				
                if (_item isEqualTo "MineDetector") then {
                    player addItem _item;
                } else {
                    player addWeapon _item;
                };
            } else {
                switch (_details select 5) do {
                    case 0:  {
                        if _ispack then {
                            player addItemToBackpack _item;
                        } else {
                            if _override then {
                                player addItem _item;
                            } else {
                                if (_item in (assignedItems  player)) then {
                                    player addItem _item;
                                } else {
                                    player linkItem _item;
                                };
                            };
                        };
                    };

                    case 605: {
                        if _ispack then{
                            player addItemToBackpack _item;
                        } else {
                            if _override then {
                                player addItem _item;
                            } else {
                                if (headgear player isEqualTo _item && {!_preview}) then {
                                    player addItem _item;
                                } else {
                                    if (!(headgear player isEqualTo "")) then {removeHeadGear player;};
                                    player addHeadGear _item;
                                };
                            };
                        };
                    };

                    case 801: {
                        if _ispack then {
                            player addItemToBackpack _item;
                        } else {
                            if _override then {
                                player addItem _item;
                            } else {
                                if (player isKindOf "Civilian") then {
                                    if (uniform player isEqualTo _item && {!_preview}) then {
                                        player addItem _item;
                                    } else {
                                        if (!(uniform player isEqualTo "")) then {
                                            _items = uniformItems player;
                                            removeUniform player;
                                        };

                                        player addUniform _item;
										
                                        if (!isNil "_items") then {
                                            {player addItemToUniform _x} forEach _items;
                                        };
                                    };
                                } else {
                                    if (!(uniform player isEqualTo "")) then {
                                        _items = uniformItems player;
                                        removeUniform player;
                                    };

                                    if (!(player isUniformAllowed _item)) then {
                                        player forceAddUniform _item;
                                    } else {
                                        player addUniform _item;
                                    };
									
                                    if (!isNil "_items") then {
                                        {player addItemToUniform _x} forEach _items;
                                    };
                                };
                            };
                        };
                    };

                    case 701: {
                        if _ispack then {
                            player addItemToBackpack _item;
                        } else {
                            if _override then{
                                player addItem _item;
                            } else {
                                if (vest player isEqualTo _item && {!_preview}) then {
                                    player addItem _item;
                                } else {
                                    if (!(vest player isEqualTo "")) then {
                                        _items = vestItems player;
                                        removeVest player;
                                    };

                                    player addVest _item;

                                    if (!isNil "_items") then {
                                        {[_x,true,false,false,true] spawn plants_fnc_handleItem;} forEach _items;
                                    };
                                };
                            };
                        };
                    };

                    case 201: {
                        if _ispack then {
                            player addItemToBackpack _item;
                        } else {
                            private _type = [_item,201] call plants_fnc_accType;
							
                            if _ongun then {
                                switch _type do {
                                    case 1: { player addPrimaryWeaponItem _item; };
                                    case 2: { player addSecondaryWeaponItem _item; };
                                    case 3: { player addHandgunItem _item; };
                                };
                            } else {
                                if _override then {
                                    player addItem _item;
                                } else {
                                    private _wepItems  = switch _type do {case 1:{primaryWeaponItems player}; case 2:{secondaryWeaponItems player}; case 3:{handgunItems player}; default {["","",""]};};
                                    private _slotTaken = false;

                                    if (!((_wepItems select 2) isEqualTo "")) then {_slotTaken = true;};

                                    if _slotTaken then {
                                        private _action = ["Möchtest du den Aufsatz zu deiner Waffe oder deinem Inventar hinzufügen? Wenn du es zur Waffe hinzufügst, geht der vorhandene Aufsatz verloren!","Aufsatz Platz belegt!","Waffe","Inventar"] call BIS_fnc_guiMessage;
                                       
									   if _action then {
                                            switch _type do {
                                                case 1: {player addPrimaryWeaponItem _item;};
                                                case 2: {player addSecondaryWeaponItem _item;};
                                                case 3: {player addHandgunItem _item;};
                                                default {player addItem _item;};
                                            };
                                        } else {
                                            player addItem _item;
                                        };
                                    } else {
                                        switch _type do {
                                            case 1: {player addPrimaryWeaponItem _item;};
                                            case 2: {player addSecondaryWeaponItem _item;};
                                            case 3: {player addHandgunItem _item;};
                                            default {player addItem _item;};
                                        };
                                    };
                                };
                            };
                        };
                    };

                    case 301: {
                        if _ispack then {
                            player addItemToBackpack _item;
                        } else {
                            private _type = [_item,301] call plants_fnc_accType;

                            if _ongun then {
                                switch _type do {
                                    case 1: { player addPrimaryWeaponItem _item; };
                                    case 2: { player addSecondaryWeaponItem _item; };
                                    case 3: { player addHandgunItem _item; };
                                };
                            } else {
                                if _override then {
                                    player addItem _item;
                                } else {
                                    private _wepItems  = switch _type do {case 1:{primaryWeaponItems player}; case 2:{secondaryWeaponItems player}; case 3:{handgunItems player}; default {["","",""]};};
                                    private _slotTaken = false;

                                    if (!((_wepItems select 1) isEqualTo "")) then {_slotTaken = true;};

                                    if _slotTaken then {
                                        private _action = ["Möchtest du den Aufsatz zu deiner Waffe oder deinem Inventar hinzufügen? Wenn du es zur Waffe hinzufügst, geht der vorhandene Aufsatz verloren!","Aufsatz Platz belegt!","Waffe","Inventar"] call BIS_fnc_guiMessage;
                                        
										if _action then {
                                            switch _type do {
                                                case 1: {player addPrimaryWeaponItem _item;};
                                                case 2: {player addSecondaryWeaponItem _item;};
                                                case 3: {player addHandgunItem _item;};
                                                default {player addItem _item;};
                                            };
                                        } else {
                                            player addItem _item;
                                        };
                                    } else {
                                        switch _type do {
                                            case 1: {player addPrimaryWeaponItem _item;};
                                            case 2: {player addSecondaryWeaponItem _item;};
                                            case 3: {player addHandgunItem _item;};
                                            default {player addItem _item;};
                                        };
                                    };
                                };
                            };
                        };
                    };

                    case 101:{
                        if _ispack then {
                            player addItemToBackpack _item;
                        } else {
                            private _type = [_item,101] call plants_fnc_accType;

                            if _ongun then {
                                switch _type do {
                                    case 1: { player addPrimaryWeaponItem _item; };
                                    case 2: { player addSecondaryWeaponItem _item; };
                                    case 3: { player addHandgunItem _item; };
                                };
                            } else {
                                if _override then {
                                    player addItem _item;
                                } else {
                                    private _wepItems  = switch _type do {case 1:{primaryWeaponItems player}; case 2:{secondaryWeaponItems player}; case 3:{handgunItems player}; default {["","",""]};};
                                    private _slotTaken = false;

                                    if (!((_wepItems select 0) isEqualTo "")) then {_slotTaken = true;};

                                    if _slotTaken then {
                                        private _action = ["Möchtest du den Aufsatz zu deiner Waffe oder deinem Inventar hinzufügen? Wenn du es zur Waffe hinzufügst, geht der vorhandene Aufsatz verloren!","Aufsatz Platz belegt!","Waffe","Inventar"] call BIS_fnc_guiMessage;
                                       
									   if _action then {
                                            switch _type do {
                                                case 1: {player addPrimaryWeaponItem _item;};
                                                case 2: {player addSecondaryWeaponItem _item;};
                                                case 3: {player addHandgunItem _item;};
                                                default {player addItem _item;};
                                            };
                                        } else {
                                            player addItem _item;
                                        };
                                    } else {
                                        switch _type do {
                                            case 1: {player addPrimaryWeaponItem _item;};
                                            case 2: {player addSecondaryWeaponItem _item;};
                                            case 3: {player addHandgunItem _item;};
                                            default {player addItem _item;};
                                        };
                                    };
                                };
                            };
                        };
                    };

                    case 621: {
                        if _ispack then {
                            player addItemToBackpack _item;
                        } else {
                            if _override then {
                                player addItem _item;
                            } else {
                                player linkItem _item;
                            };
                        };
                    };

                    case 616: {
                        if _ispack then {
                            player addItemToBackpack _item;
                        } else {
                            if _override then {
                                player addItem _item;
                            } else {
                                player linkItem _item;
                            };
                        };
                    };

                    default {
                        if _ispack then {
                            player addItemToBackpack _item;
                        } else {
                            player addItem _item;
                        };
                    };
                };
            };
        };
    };
} else {
    switch (_details select 6) do {
        case "CfgVehicles": {
            removeBackpack player;
        };

        case "CfgMagazines": {
            player removeMagazine _item;
        };

        case "CfgGlasses": {
            if (_item isEqualTo goggles player) then {
                removeGoggles player;
            } else {
                player removeItem _item;
            };
        };

        case "CfgWeapons": {
            if ((_details select 4) in [1,2,4,5,4096]) then {
                if ((_details select 4) isEqualTo 4096) then {
                    if ((_details select 5) isEqualTo 1) then {
                        _isgun = true;
                    };
                } else {
                    _isgun = true;
                };
            };

            if _isgun then {
                switch true do {
                    case (primaryWeapon player isEqualTo _item) : {_ispack = false;};
                    case (secondaryWeapon player isEqualTo _item) : {_ispack = false;};
                    case (handgunWeapon player isEqualTo _item) : {_ispack = false;};
                    case (_item in assignedItems player) : {_ispack = false;};
                    default {_ispack = true;};
                };

                if (_item isEqualTo "MineDetector") then {
                    player removeItem _item;
                } else {

                    private _tmpfunction = {
                        switch true do {
                            case (_this in (uniformItems player)): {
                                private _tWeapons     = (getWeaponCargo (uniformContainer player)) select 0;
                                private _tWeaponCount = (getWeaponCargo (uniformContainer  player)) select 1;

                                clearWeaponCargo (uniformContainer player);
                                {
                                    private _numVestWeps = _tWeaponCount select _forEachIndex;
                                    if (_x isEqualTo _this) then {
                                        _numVestWeps = _numVestWeps - 1;
                                    };
                                    (uniformContainer player) addWeaponCargo [ _x,_numVestWeps];
                                } forEach _tWeapons;
                            };

                            case (_this in (vestItems player)): {
                                private _tWeapons     = (getWeaponCargo (vestContainer player)) select 0;
                                private _tWeaponCount = (getWeaponCargo (vestContainer  player)) select 1;
								
                                clearWeaponCargo (vestContainer player);
                                {
                                    private _numVestWeps = _tWeaponCount select _forEachIndex;
                                    if (_x isEqualTo _this) then {
                                        _numVestWeps = _numVestWeps - 1;
                                    };
                                    (vestContainer player) addWeaponCargo [ _x,_numVestWeps];
                                } forEach _tWeapons;
                            };

                            case (_this in (backpackItems player)): {
                                private _tWeapons     = (getWeaponCargo (backpackContainer player)) select 0;
                                private _tWeaponCount = (getWeaponCargo (backpackContainer  player)) select 1;

                                clearWeaponCargo (backpackContainer player);
                                {
                                    private _numVestWeps = _tWeaponCount select _forEachIndex;
                                    if (_x isEqualTo _this) then {
                                        _numVestWeps = _numVestWeps - 1;
                                    };
                                    (backpackContainer player) addWeaponCargo [ _x,_numVestWeps];
                                } forEach _tWeapons;
                            };
                        };
                    };

                    if _ispack then {
                        _item call _tmpfunction;
                    } else {
                        switch true do {
                            case (_item in (uniformItems player)): {_item call _tmpfunction;};
                            case (_item in (vestItems player)) : {_item call _tmpfunction;};
                            case (_item in (backpackItems player)) : {_item call _tmpfunction;};
                            default {player removeWeapon _item;};
                        };
                    };
                };
            } else {
                switch (_details select 5) do {
                    case 0: {player unassignItem _item; player removeItem _item;};
                    case 605: {if (headgear player isEqualTo _item) then {removeHeadgear player} else {player removeItem _item};};
                    case 801: {if (uniform player isEqualTo _item) then {removeUniform player} else {player removeItem _item};};
                    case 701: {if (vest player isEqualTo _item) then {removeVest player} else {player removeItem _item};};
                    case 621: {player unassignItem _item; player removeItem _item;};
                    case 616: {player unassignItem _item; player removeItem _item;};
                    default {
                        switch true do {
                            case (_item in primaryWeaponItems player) : {player removePrimaryWeaponItem _item;};
                            case (_item in handgunItems player) : {player removeHandgunItem _item;};
                            default {player removeItem _item;};
                        };
                    };
                };
            };
        };
    };
};