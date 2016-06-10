#include "\m3e_3den\code\m3e\defines.inc"
private "_fnc"; 
_fnc = { 
    if (_this < 0) then { 
        str ceil _this + (str (_this - ceil _this) select [2]) 
    } else { 
        str floor _this + (str (_this - floor _this) select [1]) 
    }; 
}; 
format [ 
    "[""%1"",[%2,%3,%4],%5,%6]", 
     _this select 0, 
    _this select 1 select 0 call _fnc, 
    _this select 1 select 1 call _fnc, 
    _this select 1 select 2 call _fnc, 
    _this select 2, 
    _this select 3 
]; 



