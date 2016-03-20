
#include "\a3\3DEN\UI\macroExecs.inc"
#include "\m3e_3den\code\m3e\defines.inc"

class CfgPatches 
{
	class m3e_3den 
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"3DEN", "exile_client"};
	};
};

class CfgFunctions 
{
	class M3E 
	{
		class Core 
		{
			file = "\m3e_3den\code\m3e";
			class start {};
			class getAllVehicles {};
			class loadObjectTree {};
			class saveObjects {};
			class saveRelative {};
			class saveAll {};
			class saveTraders {};

			class getObjects {};
			class getTraders {};
			class getRelativeObjects {};
		};
	};

	class 3DEN
	{
		tag = "BIS";
		project = "arma3";

		class Default
		{
			class 3DENInterface {
				file = "\m3e_3den\code\3DEN\fn_3DENInterface.sqf";
			};
		};
	};
};

class CfgVehicles 
{
	class B_Soldier_base_F;
	class Exile_Trader_Abstract : B_Soldier_base_F {
		class Attributes {
			class ExileTraderType
			{
				displayName = "Trader Type";
				tooltip = "Exile trader type";
				property = "ExileTraderType";
				control = "Edit";
				expression = "_this setVariable ['%s',_value];";
				defaultValue = "typeOf _this";
			};
		};
	};
};

class Cfg3DEN 
{
	class Object 
	{
		class AttributeCategories 
		{
			class Init 
			{
				collapsed = 1;
			};
			class Control 
			{
				collapsed = 1;
			};
			class Presence 
			{
				collapsed = 1;
			};
			class Transformation 
			{
				collapsed = 1;
			};
			class Inventory 
			{
				collapsed = 1;
			};
			class State 
			{
				collapsed = 1;
			};
			class StateSpecial 
			{
				collapsed = 1;
				class Attributes
				{
					class EnableSimulation
					{
						defaultValue = "false";
					};
					class AllowDamage
					{
						defaultValue = "false";
					};
				};
			};
			class Identity 
			{
				collapsed = 0;
			};
			class System 
			{
				collapsed = 1;
			};
		};
	};
};

class ctrlMenuStrip;
class ctrlControlsGroupNoScrollbars;
class CtrlToolbox;
class ctrlStatic;
class ctrlEdit;
class ctrlButtonSearch;
class ctrlTree;
class display3DEN
{
	class Controls
	{
		class MenuStrip: ctrlMenuStrip
		{
			class Items
			{
				items[] += {"M3Editor"};
				class M3Editor
				{
					text = "M3Editor";
					items[] = {"SaveObjects", "SaveTraders", "SaveAll", "Separator", "SaveRelative"};
				};
				class SaveObjects
				{
					text = "Export Objects";
					action = "call M3E_fnc_saveObjects";
				};
				class SaveTraders
				{
					text = "Export Traders";
					action = "call M3E_fnc_saveTraders";
				};
				class SaveAll
				{
					text = "Export All";
					action = "call M3E_fnc_saveAll";
				};
				class SaveRelative 
				{
					text = "Export Objects (Relative)";
					action = "call M3E_fnc_saveRelative";
				};
				class Separator {
					value = 0;
				};
			};
		};
		class PanelRight: ctrlControlsGroupNoScrollbars
		{
			class Controls 
			{
				class TabRightSections: CtrlToolbox
				{
					columns = 3;
					strings[] = {
						"M3Editor",
						$STR_3DEN_Display3DEN_Assets,
						$STR_3DEN_Display3DEN_History
					};
				};
				class PanelRightCreate: ctrlControlsGroupNoScrollbars
				{
					show = 0;
				};
				class PanelRightM3Editor: ctrlControlsGroupNoScrollbars
				{
					idc = 1341;
					x = 0;
					y = TAB_H * GRID_H;
					w = PANEL_W * GRID_W;
					h = safezoneH - (MENUBAR_H + TOOLBAR_H + PLAYBUTTON_H + TAB_H) * GRID_H;
					class Controls
					{
						class PanelRightM3EditorBackground: ctrlStatic
						{
							w = PANEL_W * GRID_W;
							h = 1 * GRID_H;
							colorBackground[] = {COLOR_BACKGROUND_RGBA};
						};
						class SearchM3E: ctrlEdit
						{
							idc = 1342;
							x = 1 * GRID_W;
							y = GRID_H;
							w = (PANEL_W - SIZE_M - 2) * GRID_W;
							h = SIZE_M * GRID_H;
						};
						class SearchM3EButton: ctrlButtonSearch
						{
							idc = 1343;
							x = (PANEL_W - SIZE_M - 1) * GRID_W;
							y = GRID_H;
							w = SIZE_M * GRID_W;
							h = SIZE_M * GRID_H;
						};
						class M3EObjects: ctrlTree
						{
							idc = 1344;
							x = 0;
							y = (SIZE_M + 2) * GRID_H;
							w = PANEL_W * GRID_W;
							h = safezoneH - (MENUBAR_H + TOOLBAR_H + TAB_H + STATUSBAR_H + SIZE_M + 2 + 1 + SIZE_M) * GRID_H; //--- Last +1 removes scrollbar
							defaultItem[] = {"Default"};
							sizeEx = "4.32 * (1 / (getResolution select 3)) * 1.25 * 4";
						};
					};
				};
			};
		};
	};
};