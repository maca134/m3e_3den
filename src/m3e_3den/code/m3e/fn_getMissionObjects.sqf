#include "\m3e_3den\code\m3e\defines.inc"
private _objects = all3DENEntities select 0;
_objects = _objects select {configName (inheritsFrom (configFile >> 'CfgVehicles' >> typeOf _x)) != 'Exile_Trader_Abstract'};
if (count _objects == 0) exitWith {''};
private _output = [
	'['
];
{
	private _row = [];
	_row pushBack typeOf _x;
		private _dir = (getPosASL _x);
	_row pushBack [(_dir select 0),(_dir select 1),((_dir select 2) -5)];

	_row pushBack (getDir _x);
	_output pushBack format['%1%2%3', '	', str _row, if (_forEachIndex < (count _objects - 1)) then {','} else {''}];
} forEach _objects;

_output append [
	'];'
];
_output = _output joinString toString[10];
_output