#include "\m3e_3den\code\m3e\defines.inc"

disableSerialization;
waitUntil {!isNull findDisplay IDD_DISPLAY3DEN};

private _display = findDisplay IDD_DISPLAY3DEN;
private _tree = (_display displayCtrl 1341) controlsGroupCtrl 1344;

_display setVariable ['M3E_objectTree', _tree];

_tree ctrlAddEventHandler ['TreeSelChanged', {
	params [
		['_ctrl', controlNull, [controlNull]],
		['_path', [], [[]]]
	];
	deleteVehicle (_ctrl getVariable ['PreviewObject', objNull]);
	private _classname = _ctrl tvData _path;
	if (_classname == '') exitWith {};
	private _previewObject = _classname createVehicle [0, 0, 0];
	_previewObject enableSimulation false;
	_previewObject setPos (positionCameraToWorld [0, 0, sizeOf _classname]);
	_ctrl setVariable ['PreviewObject', _previewObject];
}];

_tree ctrlAddEventHandler ['TreeMouseExit', {
	params [
		['_ctrl', controlNull, [controlNull]]
	];
	deleteVehicle (_ctrl getVariable ['PreviewObject', objNull]);
	systemChat str _this;
}];

_tree ctrlAddEventHandler ['TreeDblClick', {
	params [
		['_ctrl', controlNull, [controlNull]],
		['_path', [], [[]]]
	];
	deleteVehicle (_ctrl getVariable ['PreviewObject', objNull]);
	private _classname = _ctrl tvData _path;
	create3DENEntity ["Object", _classname, screenToWorld [0.5,0.5], true];
}];

private _searchinput = _display displayCtrl 1342;
_searchinput ctrlRemoveAllEventHandlers 'KeyDown';
_searchinput ctrlRemoveAllEventHandlers 'KeyUp';
_searchinput ctrlAddEventHandler ['KeyDown', {[ctrlText (_this select 0)] call M3E_fnc_loadObjectTree;}];

private _searchbtn = _display displayCtrl 1343;
_searchbtn ctrlRemoveAllEventHandlers 'MouseButtonClick';
_searchbtn ctrlRemoveAllEventHandlers 'MouseButtonUp';
_searchbtn ctrlRemoveAllEventHandlers 'MouseButtonDown';
_searchbtn ctrlAddEventHandler ['MouseButtonClick', {((findDisplay IDD_DISPLAY3DEN) displayCtrl 1342) ctrlSetText "";}];

private _mouseArea = _display displayCtrl IDC_DISPLAY3DEN_MOUSEAREA;
_mouseArea ctrlAddEventHandler ['MouseMoving', {
	(_this select 0) setVariable ['M3E_mouseposition', [_this select 1, _this select 2]];
}];
_mouseArea ctrlAddEventHandler ['MouseButtonDblClick', {
	_ins = lineIntersectsSurfaces [
		AGLToASL positionCameraToWorld [0,0,0], 
		AGLToASL screenToWorld ((_this select 0) getVariable ['M3E_mouseposition', [0.5, 0.5]]), 
		get3DENCamera,
		objNull,
		true,
		1,
		"GEOM",
		"VIEW"
	];
	if (count _ins == 0) exitWith {};
	private _object = (_ins select 0) select 2;
	if (_object in (all3DENEntities select 0)) exitWith {};
	private _eobject = create3DENEntity ["Object", typeOf _object, [0,0,0], true];
	_eobject set3DENAttribute ["position", getPos _object];
	_eobject setPos (getPos _object);
}];

[] spawn {
	disableSerialization;
	uiSleep 0.5;
	private _tree = ((findDisplay IDD_DISPLAY3DEN) displayCtrl 1341) controlsGroupCtrl 1344;
	if (count (_tree getVariable ['AllObjects', []]) == 0) then {
		_tree setVariable ['AllObjects', call M3E_fnc_getAllVehicles];
	};
	call M3E_fnc_loadObjectTree;
};