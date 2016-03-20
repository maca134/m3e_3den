#include "\m3e_3den\code\m3e\defines.inc"
private _traders = all3DENEntities select 0;
_traders = _traders select {configName (inheritsFrom (configFile >> 'CfgVehicles' >> typeOf _x)) == 'Exile_Trader_Abstract'};
if (count _traders == 0) exitWith {''};
private _output = [
	'private _traders = ['
];
{
	private _row = [];
	_row pushBack (typeOf _x);
	_row pushBack (getPosATL _x);
	_row pushBack (getDir _x);
	_row pushBack ((_x get3DENAttribute 'ExileTraderType') select 0);
	_row pushBack ((_x get3DENAttribute 'face') select 0);
	_output pushBack format [
		"%1%2%3",
		'	',
		str _row, 
		if (_forEachIndex < (count _traders - 1)) then {','} else {''}
	];
} forEach _traders;

_output append [
	'];',
	'{',
	'	private _trader = [',
	'		_x select 0,',
	'		_x select 4,',
	'		["HubStanding_idle1"],',
	'		_x select 1,',
	'		_x select 2',
	'	] call ExileClient_object_trader_create;',
	'	_trader setVariable ["ExileTraderType", _x select 3];',
	'} forEach _traders;'
];
_output = _output joinString toString[10];
_output