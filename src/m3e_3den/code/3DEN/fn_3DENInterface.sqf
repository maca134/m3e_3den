#include "\a3\3DEN\UI\resincl.inc"
#define COMMIT_TIME	0.1

disableserialization;
_mode = param [0,"",[""]];
switch (tolower _mode) do {
	case "showinterface": {
		_display = finddisplay IDD_DISPLAY3DEN;
		_show = [_this,1,round ctrlfade (_display displayctrl IDC_DISPLAY3DEN_PLAY) > 0,[false]] call bis_fnc_param;//param [1,round ctrlfade (_display displayctrl IDC_DISPLAY3DEN_PLAY) > 0];
		_fade = [1,0] select _show;//(1 - round ctrlfade (_display displayctrl IDC_DISPLAY3DEN_PLAY));
		{
			_ctrl = _display displayctrl (_x select 0);
			_ctrl ctrlsetfade _fade;
			if (_x select 1) then {_ctrl ctrlenable _show;}; // Don't disable menu strip, key shortcut is tied to it
			_ctrl ctrlcommit COMMIT_TIME;
		} foreach [
			// IDC					Toggle enabled status
			[IDC_CANCEL,				true],
			[IDC_DISPLAY3DEN_SCROLLBLOCK_TOP,	true],
			[IDC_DISPLAY3DEN_SCROLLBLOCK_LEFT,	true],
			[IDC_DISPLAY3DEN_SCROLLBLOCK_RIGHT,	true],
			[IDC_DISPLAY3DEN_SCROLLBLOCK_BOTTOM,	true],
			[IDC_DISPLAY3DEN_MISSIONNAME,		false],
			[IDC_DISPLAY3DEN_MENUSTRIP,		false],
			[IDC_DISPLAY3DEN_TOOLBAR,		true],
			[IDC_DISPLAY3DEN_NOTIFICATION,		true],
			[IDC_DISPLAY3DEN_TABLEFT_TOGGLE,	true],
			[IDC_DISPLAY3DEN_TABRIGHT_TOGGLE,	true],
			[IDC_DISPLAY3DEN_PANELLEFT,		true],
			[IDC_DISPLAY3DEN_PANELRIGHT,		true],
			[IDC_DISPLAY3DEN_NAVIGATION_WIDGET,	true],
			[IDC_DISPLAY3DEN_CONTROLSHINT,		false],
			[IDC_DISPLAY3DEN_STATUSBAR,		true],
			[IDC_DISPLAY3DEN_PLAY,			false],
			[IDC_DISPLAY3DEN_WATERMARK,		false]
		];
		set3DENIconsVisible [_show,_show];
		set3DENLinesVisible [_show,_show];
		set3DENModelsVisible [_show,_show];
	};

	case "showpanelleft";
	case "showpanelright": {
		_display = finddisplay IDD_DISPLAY3DEN;
		_data = [
			[IDC_DISPLAY3DEN_PANELLEFT,IDC_DISPLAY3DEN_SCROLLBLOCK_LEFT,IDC_DISPLAY3DEN_TABLEFT_TOGGLE,"display3DEN_panelLeft",true],
			[IDC_DISPLAY3DEN_PANELRIGHT,IDC_DISPLAY3DEN_SCROLLBLOCK_RIGHT,IDC_DISPLAY3DEN_TABRIGHT_TOGGLE,"display3DEN_panelRight",false]
		] select (_mode == "showPanelRight");
		_ctrl = _display displayctrl (_data select 0);
		_pos = ctrlposition _ctrl;
		_posY = _pos select 1;
		_show = [_this,1,_posY > 5,[false]] call bis_fnc_param;//param [1,_posY > 5];
		if (_show) then {
			if (_posY > 5) then {_pos set [1,_posY - 10];};
		} else {
			if (_posY < 5) then {_pos set [1,_posY + 10];};
		};
		_ctrl ctrlenable _show;
		_ctrl ctrlsetposition _pos;
		_ctrl ctrlcommit 0;

		_ctrlScrollLock = _display displayctrl (_data select 1);
		_ctrlScrollLock ctrlsetposition _pos;
		_ctrlScrollLock ctrlcommit 0;

		_ctrlButtonToggle = _display displayctrl (_data select 2);
		_ctrlButtonToggle ctrlenable !_show;

		//--- Adjust navigation widget
		if (_data select 4) then {
			_ctrlNav = _display displayctrl IDC_DISPLAY3DEN_NAVIGATION_WIDGET;
			_ctrlNavPos = ctrlposition _ctrlNav;
			_offset = (_ctrlNavPos select 2) * 0.2;
			_ctrlNavPos set [0,if (_show) then {(_pos select 0) + (_pos select 2) + _offset} else {safezoneX + _offset}];
			_ctrlNav ctrlsetposition _CtrlNavPos;
			_ctrlNav ctrlcommit 0;
		};

		//--- Switch focus on close button

		profilenamespace setvariable [_data select 3,_show];
		saveprofilenamespace;
	};

	case "tableft": {
		_display = finddisplay IDD_DISPLAY3DEN;
		_id = [_this,1,0,[0]] call bis_fnc_param;
		["ShowPanelLeft",true] call bis_fnc_3DENINterface;
		{
			_ctrl = _display displayctrl _x;
			_ctrl ctrlshow (_foreachindex == _id);
		} foreach [IDC_DISPLAY3DEN_PANELLEFT_EDIT,IDC_DISPLAY3DEN_PANELLEFT_LOCATIONS];
	};
	case "tabright": {
		_display = finddisplay IDD_DISPLAY3DEN;
		_id = [_this,1,0,[0]] call bis_fnc_param;
		["ShowPanelRight",true] call bis_fnc_3DENINterface;
		{
			_ctrl = _display displayctrl _x;
			_ctrl ctrlshow (_foreachindex == _id);
		} foreach [1341,IDC_DISPLAY3DEN_PANELRIGHT_CREATE,IDC_DISPLAY3DEN_PANELRIGHT_HISTORY];

		//--- Refresh create tree (otherwise all of them would be selected)
		if (_id == 1) then {
			{
				if (get3DENActionState _x > 0) then {do3DENAction _x};
			} foreach ["SelectSubmode1","SelectSubmode2","SelectSubmode3","SelectSubmode4","SelectSubmode5"];
		};
	};
	case "buttonplay": {
		_ctrlPlay = _this param [1,finddisplay IDD_DISPLAY3DEN displayctrl IDC_DISPLAY3DEN_PLAY,[controlnull]];
		_isMission = false;
		_enable = true;

		_textSection = switch 1 do {
			case (get3denactionstate "MissionPartIntro"):		{localize "STR_3DEN_Display3DEN_Play_Phase_Intro"};
			case (get3denactionstate "MissionPartOutroWin"):	{localize "STR_3DEN_Display3DEN_Play_Phase_OutroWin"};
			case (get3denactionstate "MissionPartOutroLoose"):	{localize "STR_3DEN_Display3DEN_Play_Phase_OutroLose"};
			default							{_isMission = true; localize "STR_3DEN_Display3DEN_Play_Phase_Mission"};
		};
		_textMP = if (is3DENMultiplayer) then {
			_enable = _isMission;
			localize "STR_3DEN_Display3DEN_Play_Env_MP"
		} else {
			localize "STR_3DEN_Display3DEN_Play_Env_SP"
		};
		_emptyLine = "";
		_fontSize = 2;
		//--- Decrease the font size when the text is too long (e.g., German or Russian)
		if (count _textSection > 20) then {
			_emptyLine = "<t size='0.625'><img image='#(argb,8,8,3)color(0,0,0,0)' /><br /></t>";
			_fontSize = 1.25;
		};
		_ctrlPlay ctrlsetstructuredtext parsetext format ["%4<t size='%3' font='PuristaMedium'>%1</t><br />%2",toupper _textSection, toupper _textMP,_fontSize,_emptyLine];
		_ctrlPlay ctrlenable _enable; // ToDo: Base availability on get3DENActionState
	};
	case "mode": {
		//--- Highlight F-key helper
		_display = finddisplay IDD_DISPLAY3DEN;
		_id = -1;
		{
			if (get3denactionstate _x > 0) exitwith {_id = _foreachindex;};
		} foreach ["SelectObjectMode","SelectGroupMode","SelectTriggerMode","SelectWaypointMode","SelectModuleMode","SelectMarkerMode"];
		_ctrlModeLabels = _display displayctrl IDC_DISPLAY3DEN_MODELABELS;
		_ctrlModeLabels lbsetcursel _id;
	};
	case "submode": {
		_display = finddisplay IDD_DISPLAY3DEN;
		_ctrlWarning = _display displayctrl IDC_DISPLAY3DEN_CREATE_OBJECT_EMPTY_WARNING;

		//--- Show warning about vehicles no longer being in Props
		if (get3denactionstate "SelectObjectMode" > 0 && get3denactionstate "SelectSubmode5" > 0) then {
			if !(profilenamespace getvariable ["bis_fnc_3DENInterface_emptyVehicles",false]) then {
				_ctrlList = _display displayctrl IDC_DISPLAY3DEN_CREATE_OBJECT_EMPTY;
				_ctrlListRef = _display displayctrl IDC_DISPLAY3DEN_CREATE_OBJECT_WEST;
				_ctrlWarning ctrlshow true;
				_ctrlWarningPos = ctrlposition _ctrlWarning;
				_ctrlListPos = ctrlposition _ctrlListRef;
				_ctrlListPos set [1,(_ctrlListPos select 1) + (_ctrlWarningPos select 3)];
				_ctrlListPos set [3,(_ctrlListPos select 3) - (_ctrlWarningPos select 3)];
				_ctrlList ctrlsetposition _ctrlListPos;
				_ctrlList ctrlcommit 0;
			};
		} else {
			_ctrlWarning ctrlshow false;
		};
	};
	case "navigationwidget": {
		_display = finddisplay IDD_DISPLAY3DEN;
		_ctrlNav = _display displayctrl IDC_DISPLAY3DEN_NAVIGATION_WIDGET;
		_show = _this param [1,!ctrlshown _ctrlNav,[true]];
		_ctrlNav ctrlshow _show;

		profilenamespace setvariable ["display3DEN_navigationWidget",_show];
		saveprofilenamespace;
	};
	case "onterrainnew": {
		if (count (supportinfo "b:get3DENMissionAttribute*") > 0 && {call compile "'Preferences' get3DENMissionAttribute 'startMap'"}) then {
			//--- Show map and show the whole terrain
			if (get3DENActionState "togglemap" == 0) then {do3denaction "togglemap";};
			_display = finddisplay IDD_DISPLAY3DEN;
			_ctrlMap = _display displayctrl IDC_DISPLAY3DEN_MAP;
			_ctrlMap ctrlmapanimadd [0,1,[worldsize * 0.5,worldsize * 0.5,0]];
			ctrlmapanimcommit _ctrlMap;
		} else {
			//--- Hide map
			if (get3DENActionState "togglemap" == 1) then {do3denaction "togglemap";};
		};
	};
	case "warningemptyvehicles": {
		profilenamespace setvariable ["bis_fnc_3DENInterface_emptyVehicles",true];
		saveprofilenamespace;
		_display = finddisplay IDD_DISPLAY3DEN;
		_ctrlList = _display displayctrl IDC_DISPLAY3DEN_CREATE_OBJECT_EMPTY;
		_ctrlListRef = _display displayctrl IDC_DISPLAY3DEN_CREATE_OBJECT_WEST;
		_ctrlWarning = _display displayctrl IDC_DISPLAY3DEN_CREATE_OBJECT_EMPTY_WARNING;
		_ctrlWarning ctrlshow false;
		_ctrlWarning ctrlsetposition [-1,-1,0,0];
		_ctrlWarning ctrlcommit 0; //--- Move it out of bounds just in case
		_ctrlList ctrlsetposition ctrlposition _ctrlListRef;
		_ctrlList ctrlcommit 0;
	};
	case "showshortcut": {
		if (isnil {uinamespace getvariable "bis_fnc_3DENInterface_shortcuts"}) then {

			//--- Add keyboard shortcuts to all elements
			_controlData = _this param [2,[],[[]]];
			_control = _controlData param [0,controlnull,[controlnull]];
			_display = ctrlparent _control;//finddisplay IDD_DISPLAY3DEN;
			_ctrlMenuBar = _display displayctrl IDC_DISPLAY3DEN_MENUSTRIP;
			_shortcuts = [];

			//--- Index shortcuts for each menu data
			_fnc_menuBarExplore = {
				for "_i" from 0 to ((_ctrlMenuBar menuSize _this) - 1) do {
					_path = _this + [_i];
					_shortcutText = _ctrlMenuBar menushortcuttext _path;
					if (_shortcutText != "") then {
						_shortcuts pushback tolower (_ctrlMenuBar menudata _path);
						_shortcuts pushback _shortcutText;
					};
					_path call _fnc_menuBarExplore;
				};
			};
			[] call _fnc_menuBarExplore;
			uinamespace setvariable ["bis_fnc_3DENInterface_shortcuts",_shortcuts];
		};
		_shortcuts = uinamespace getvariable ["bis_fnc_3DENInterface_shortcuts",[]];
		_data = _this param [1,"",[""]];
		_index = _shortcuts find (tolower _data);
		if (_index >= 0) then {
			_controlData = _this param [2,[],[[]]];
			_control = _controlData param [0,controlnull,[controlnull]];
			_config = _controlData param [1,configfile,[configfile]];
			_control ctrlsettooltip format ["%1 (%2)",gettext (_config >> "tooltip"),_shortcuts select (_index + 1)];
		};
	};
	case "onmissionlistchange": {

		_display = uinamespace getvariable ["display3DENSave_display",displaynull];
		if !(isnull _display) then {

			//--- Init sorting control panel
			if (isnull (_display displayctrl 200)) then {
				_ctrlFilter = _display displayctrl IDC_DISPLAY3DENSAVE_FILTER;
				_ctrlFiles = _display displayctrl IDC_DISPLAY3DENSAVE_FILES;
				[_ctrlFilter,_ctrlFiles] call bis_fnc_initListNBoxSorting;
			};

			//--- Select filter item to refresh the list (behavior handled by BIS_fnc_initListNBoxSorting)
			(finddisplay IDD_DISPLAY3DENSAVE displayctrl IDC_DISPLAY3DENSAVE_FILTER) lbsetcursel 0;
		};
	};
	case "fadein": {
		disableserialization;
		_display = finddisplay IDD_DISPLAY3DEN;
		_ctrlBlack = _display displayctrl IDC_DISPLAY3DEN_BLACK;
		_ctrlBlack ctrlenable false;
		_ctrlBlack ctrlsetfade 0;
		_ctrlBlack ctrlcommit 0;
		sleep 0.01;
		_ctrlBlack ctrlsetfade 1;
		_ctrlBlack ctrlcommit 0.2;
		ctrlsetfocus (_display displayctrl IDC_DISPLAY3DEN_MOUSEAREA);
	};
	case "init": {
		["ShowInterface",true] call bis_fnc_3DENInterface;
		["ShowPanelLeft",profilenamespace getvariable ["display3DEN_panelLeft",true]] call bis_fnc_3DENInterface;
		["ShowPanelRight",profilenamespace getvariable ["display3DEN_panelRight",true]] call bis_fnc_3DENInterface;
		["NavigationWidget",profilenamespace getvariable ["display3DEN_navigationWidget",true]] call bis_fnc_3DENInterface;
		call M3E_fnc_start;
	};
};