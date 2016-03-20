private _types = ['Exile Traders'];
private _traders = "((configName _x) find 'Exile_Trader') != -1 && configName _x != 'Exile_Trader_Abstract'" configClasses (configFile >> 'CfgVehicles');
private _classes = [
	_traders apply {configName _x}
];
private _cfgvehicles = configFile >> 'cfgVehicles';
for '_j' from 0 to (count _cfgvehicles)-1 do
{
	private ['_vehicle', '_class', '_type', '_index', '_arr', '_vehicleClass'];
	_vehicle = _cfgvehicles select _j;
	try {
		if !(isClass _vehicle) then {throw format['%1 is not a class', _vehicle];};
		_class = configName _vehicle;
		_vehicleClass = getText (_vehicle >> 'vehicleClass');
		_type = getText (configFile >> 'CfgVehicleClasses' >> _vehicleClass >> 'displayName');

		if (_class in ['Logic']) then {throw format['%1 is ignored class', _class];};
		if (_type in [
			'',
			'Mines', 
			'Locations', 
			'Ammo', 
			'Intel', 
			'Misc', 
			'Respawn',
			'Sides',
			'Backpacks',
			'Emitters'
		]) then {throw format['%1 is ignored type', _type];};

		if (getText (_vehicle >> 'model') == '') then {throw format['%1 has no model', _class];};
		if (getText (_vehicle >> 'picture') == '') then {throw format['%1 has no picture', _class];};
		if (getText (_vehicle >> 'displayName') == '') then {throw format['%1 has no displayname', _class];};
		
		{
			if (_class find _x > -1) then {throw format['%1 is a %2', _class, _x];};
		} foreach [
			'base', 
			'Base', 
			'Logic', 
			'Internal',
			'Base'
		];

		{
			if ((getText (_vehicle >> 'displayName')) find _x > -1) then {throw format['%1 is a %2', _class, _x];};
		} foreach [
			'Unknown', 
			'Parachute'
		];
		
		{
			if (_type find _x > -1) then {throw format['%1 is a %2', _class, _x];};
		} foreach [
			'Men', 
			'Items', 
			'Weapon'
		];

		_index = _types find _type;
		if (_index == -1) then {
			_index = count _types;
			_types pushBack _type;
			_classes pushBack [];
		};
		_arr = _classes select _index;
		_arr pushBack _class;
		_classes set [_index, _arr];
	} catch {/*diag_log _exception;*/};
};
[_types, _classes]