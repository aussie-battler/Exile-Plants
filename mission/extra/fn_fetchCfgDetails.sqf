/*--------------------------------------------------------------------
	Author: nflug (ofpectag: ACRYL)
    File: fn_fetchCfgDetails.sqf
	Modified: Kuchenplatte
	<Acryl-Gaming.de>
    Written by nflug - modified and edited by Kuchenplatte
    You're not allowed to use this file without permission from the author!
--------------------------------------------------------------------*/

params [
	["_className", "", [""]],
	["_section", "", [""]]
];

if (_className isEqualTo "") exitWith {[]};

private _type       = -1;
private _accPointer = [];
private _accOptic   = [];
private _accMuzzle  = [];
private _classes    = [];
private _scope      = 0;
private _itemInfo   = -1;
private _muzzles    = [];
private _magazines  = [];

if (_section isEqualTo "") then {
    _section = switch (true) do {
        case (isClass(configFile >> "CfgMagazines" >> _className)): {"CfgMagazines"};
        case (isClass(configFile >> "CfgWeapons" >> _className)): {"CfgWeapons"};
        case (isClass(configFile >> "CfgVehicles" >> _className)): {"CfgVehicles"};
        case (isClass(configFile >> "CfgGlasses" >> _className)): {"CfgGlasses"};
    };
};

if (!(_section isEqualType "") || {!isClass(configFile >> _section >> _className)} || {_section isEqualTo ""}) exitWith {[_className, format["%1 (No config)", _className], "", _scope, _type, _itemInfo, _section, _magazines, _muzzles, "", _accPointer, _accOptic, _accMuzzle, "", _classes]};

private _config      = configFile >> _section >> _className;
private _displayName = getText(_config >> "displayName");

private _picture = [_config, "picture", "pictureNotFound"] call BIS_fnc_returnConfigEntry;
if(_picture isEqualTo "" || _picture isEqualTo "pictureNotFound" || _picture isEqualTo "pictureThing" || _picture isEqualTo "pictureStaticObject") then {
	_picture = [_config, "editorPreview", "pictureNotFound"] call BIS_fnc_returnConfigEntry;
	
	if(_picture isEqualTo "" || _picture isEqualTo "pictureNotFound" || _picture isEqualTo "pictureThing" || _picture isEqualTo "pictureStaticObject") then {
		_picture = [_config, "icon", "pictureNotFound"] call BIS_fnc_returnConfigEntry;
	};
};

private _desc = getText(_config >> "descriptionShort");
private _base = inheritsFrom _config;

_desc = [_desc, "<br/>", "\n"] call KRON_Replace;
_desc = [_desc, "<br />", "\n"] call KRON_Replace;

switch (_section) do
{
    case "CfgVehicles": {
        _type  = getText(_config >> "vehicleClass");
        _scope = getNumber(_config >> "scope");
    };

    case "CfgWeapons": {
        _scope = getNumber(_config >> "scope");
        _type  = getNumber(_config >> "type");
		
        if (isClass (_config >> "WeaponSlotsInfo")) then
        {
            _accPointer = getArray(_config >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleItems");
            _accOptic   = getArray(_config >> "WeaponSlotsInfo" >> "CowsSlot" >> "compatibleItems");
            _accMuzzle  = getArray(_config >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleItems");

            {    
                for "_i" from 0 to (count(_x) - 1) do {
                    private _thiscfgitem = _x select _i;
					
                    if (isClass _thiscfgitem) then {
                        if !((configName _thiscfgitem) in _classes) then {
                            _classes pushBack configName _thiscfgitem;
                        };
                    };
                };
            } forEach ([_config>>"WeaponSlotsInfo"] call bis_fnc_returnParents);
        };

        if (isClass (_config >> "ItemInfo")) then {
            _itemInfo = getNumber(_config >> "ItemInfo" >> "Type");
        };

        _muzzles   = getArray(_config >> "muzzles");
        _magazines = getArray(_config >> "magazines");
		
        if (!isNil "_muzzles") then {
            {
                if (_x != "this") then {
                    private _tmp = getArray(_base >> _x >> "magazines"); 
					
					{
                        _magazines pushBack _x;
                    } forEach (_tmp);
                };
            } forEach _muzzles;
        };
    };

    case "CfgMagazines": {
        _scope = getNumber(_config >> "scope");
    };
};

if (!isNil "_classes") then {
    _classes = _classes - ["MuzzleSlot"];
    _classes = _classes - ["CowsSlot"];
    _classes = _classes - ["PointerSlot"];
};

[_className,_displayName,_picture,_scope,_type,_itemInfo,_section,_magazines,_muzzles,_desc,_accPointer,_accOptic,_accMuzzle,_base,_classes];