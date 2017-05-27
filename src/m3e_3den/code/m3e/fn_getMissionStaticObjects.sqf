#include "\m3e_3den\code\m3e\defines.inc"
private _objects = all3DENEntities select 0;
_objects = _objects select {configName (inheritsFrom (configFile >> 'CfgVehicles' >> typeOf _x)) != 'Exile_Trader_Abstract'};
if (count _objects == 0) exitWith {''};
private _center_x = 0;
private _center_y = 0;
{
	private _position = getPos _x;
	_center_x = _center_x + (_position select 0);
	_center_y = _center_y + (_position select 1);
} forEach _objects;
private _center = [
	_center_x / (count _objects),
	_center_y / (count _objects),
	0
];
private _output = [
	'private _objects = ['		
];
private _output = [
	'['
];
{
	private _row = [];
	_row pushBack (typeOf _x);
	private _dir = (getPosASL _x);
	private _vector = getPosATL _x;
	_row pushBack [(_dir select 0),(_dir select 1), (_vector select 2) ];
	_row pushBack (getDir _x);
	_row pushBack [vectorDir _x, vectorUp _x];
	_row append (_x get3DENAttribute 'allowDamage');
	_output pushBack format['%1%2%3', '	', str _row, if (_forEachIndex < (count _objects - 1)) then {','} else {''}];
} forEach _objects;

/*
Static Builded for Bandit
{
	private _row = [];
	_row pushBack (typeOf _x);
	_row pushBack (_center vectorDiff (getPosATL _x));
	_row pushBack (getDir _x);
	_row pushBack [vectorDir _x, vectorUp _x];
	_row pushBack (_x get3DENAttribute 'allowDamage');
	_output pushBack format['%1%2%3', '	', str _row, if (_forEachIndex < (count _objects - 1)) then {','} else {''}];
} forEach _objects;
*/

_output append [
	'];'
];
_output = _output joinString toString[10];
_output
