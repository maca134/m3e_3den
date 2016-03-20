#include "\m3e_3den\code\m3e\defines.inc"
disableSerialization;
uinamespace setvariable ['Display3DENCopy_data',['M3Editor Save All', (call M3E_fnc_getObjects) + toString[10] + toString[10] + (call M3E_fnc_getTraders)]];
(finddisplay IDD_DISPLAY3DEN) createdisplay 'Display3DENCopy';
