// Eden Object composition to SQF
// Export file
// Script by NeoArmageddon
// Call this script by [Position, Rotation] execVM "filename.sqf"

params ["_center", "_rotation", ["_static", objNull, [objNull]], ["_vehicle", objNull, [objNull]]];

[_center, 25] call a3e_fnc_cleanupTerrain;

private _fnc_createObject = {
	params["_className", "_centerPos", "_relativePos", "_rotateDir", "_relativeDir", ["_align", true]];
	private["_object", "_realPos"];
	_realPos = ([_centerPos, [(_centerPos select 0) + (_relativePos select 0), (_centerPos select 1) + (_relativePos select 1), (_relativePos select 2)], _rotateDir] call A3E_fnc_RotatePosition);
	_object = createVehicle [_className, _realPos, [], 0, "CAN_COLLIDE"];
	_object setDir (_relativeDir + _rotateDir);
	_object setPosATL _realPos;
	if (_align) then {
		_object setVectorUp surfaceNormal _realPos;
	};

	_object;
};

private _objects = [];
private _obj = objNull;

_obj = ["Land_BagBunker_Tower_F", _center, [7.04407, 4.81641, 0], _rotation, 2.53815] call _fnc_createObject;
_objects pushBack _obj;
_obj = ["Land_CncBarrier_F", _center, [-10.5725, 0.145996, 0], _rotation, 225.329] call _fnc_createObject;
_objects pushBack _obj;
_obj = ["Land_CncBarrier_F", _center, [-5.64978, -0.894531, 0], _rotation, 181.108] call _fnc_createObject;
_objects pushBack _obj;
_obj = ["Land_CncBarrier_F", _center, [-8.29041, -0.853516, 0], _rotation, 181.326] call _fnc_createObject;
_objects pushBack _obj;
_obj = ["Land_CncBarrier_F", _center, [5.24084, -1.40039, 0], _rotation, 181.409] call _fnc_createObject;
_objects pushBack _obj;
_obj = ["Land_CncBarrier_F", _center, [7.88147, -1.4375, 0], _rotation, 181.185] call _fnc_createObject;
_objects pushBack _obj;
_obj = ["Land_CncBarrier_F", _center, [-11.4365, 2.42993, 0], _rotation, 273.344] call _fnc_createObject;
_objects pushBack _obj;
_obj = ["Land_CncBarrier_F", _center, [10.1646, -0.57959, 0], _rotation, 138.856] call _fnc_createObject;
_objects pushBack _obj;
_obj = ["Land_CncBarrier_F", _center, [11.1783, 1.68823, 0], _rotation, 90.833] call _fnc_createObject;
_objects pushBack _obj;
_obj = ["RoadBarrier_F", _center, [-5.93274, -2.94666, 0.0200109], _rotation, 177.301] call _fnc_createObject;
_objects pushBack _obj;
_obj = ["RoadBarrier_F", _center, [5.47107, -3.26123, 0.0200105], _rotation, 184.49] call _fnc_createObject;
_objects pushBack _obj;

if (!(isNull _static)) then {
	private _pos = [_center, _center vectorAdd [6.4, 2.8, 2.7], _rotation] call A3E_FNC_RotatePosition;
	_static setDir ((getDir _static) + _rotation + 180);
	_static setVectorUp surfaceNormal _pos;
	_static setPosATL _pos;
};

if (!(isNull _vehicle)) then {
	private _pos = [_center, _center vectorAdd [-7.81958, 3.0061, 0.0331655], _rotation] call A3E_FNC_RotatePosition;
	_vehicle setDir (180.256 + _rotation);
	_vehicle setPosATL _pos;
};

// weapons
private ["_box", "_weaponCount"];

// Basic Weapon Box
private _weapons = [];
private _weaponMagazines = [];

// Launchers
for "_i" from 0 to (count a3e_arr_AmmoDepotLaunchers - 1) do {
	private ["_handGunItem", "_weaponClassName", "_probabilityOfPrecence", "_minCount", "_maxCount", "_magazines", "_magazinesPerWeapon"];

	_handGunItem = a3e_arr_AmmoDepotLaunchers select _i;

	_weaponClassName = _handGunItem select 0;
	_probabilityOfPrecence = _handGunItem select 1;
	_minCount = _handGunItem select 2;
	_maxCount = _handGunItem select 3;
	_magazines = _handGunItem select 4;
	_magazinesPerWeapon = _handGunItem select 5;

	    // Only include common launchers
	if (random 100 <= _probabilityOfPrecence && _probabilityOfPrecence > 50) then {
		_weaponCount = floor (_minCount + random (_maxCount - _minCount));
		_weapons pushBack [_weaponClassName, _weaponCount];

		for "_j" from 0 to (count _magazines) - 1 do {
			_weaponMagazines pushBack [_magazines select _j, _weaponCount * _magazinesPerWeapon];
		};
	};
};

if (count _weapons > 0 || count _weaponMagazines > 0) then {
	private _pos = [_center, _center vectorAdd [-5, 1, 0], _rotation] call A3E_fnc_rotatePosition;
	_box = createVehicle ["Box_East_Wps_F", _pos, [], 0, "CAN_COLLIDE"];
	clearWeaponCargoGlobal _box;
	clearMagazineCargoGlobal _box;
	clearItemCargoGlobal _box;
	clearBackpackCargoGlobal _box;

	{
		_box addWeaponCargoGlobal _x;
	} forEach _weapons;

	{
		_box addMagazineCargoGlobal _x;
	} forEach _weaponMagazines;
	_objects pushBack _box
};

_objects;