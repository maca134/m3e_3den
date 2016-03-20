#include "\m3e_3den\code\m3e\defines.inc"
disableSerialization;
params [
	['_term', '', ['']]
];
_term = toLower _term;
private _display = findDisplay IDD_DISPLAY3DEN;
private _tree = _display getVariable ['M3E_objectTree', controlNull];
tvClear _tree;
private _objects = _tree getVariable ['AllObjects', []];
private _i = 0;
{
	private _items = (_objects select 1) select _forEachIndex;
	_items = _items select {
		_term == '' || ((toLower _x) find _term) != -1 || ((toLower (getText(configFile >> 'CfgVehicles' >> _x >> 'displayName'))) find _term) != -1
	};
	if (count _items > 0) then {
		private _path = [_i];
		_i = _i + 1;
		_tree tvAdd [[], _x];
		{
			private _displayName = getText(configFile >> 'CfgVehicles' >> _x >> 'displayName');
			private _icon = getText(configFile >> 'CfgVehicles' >> _x >> 'icon');
			if (getText(configFile >> 'CfgVehicleIcons' >> _icon) != '') then {
				_icon = getText (configFile >> 'CfgVehicleIcons' >> _icon);
			};
			private _ipath = _path + [_forEachIndex];
			_tree tvAdd [_path, _displayName];
			_tree tvSetData [_ipath, _x];
			_tree tvSetTooltip [_ipath, format ['%1\n%2\nDouble click to add.', _displayName, _x]];
			_tree tvSetPicture [_ipath, _icon];
		} forEach _items;

		if (_term != '') then {
			_tree tvExpand _path;
		};
		_tree tvSort [_path, false];
	};
} forEach (_objects select 0);
_tree tvSort [[], false];
_tree ctrlCommit 0;