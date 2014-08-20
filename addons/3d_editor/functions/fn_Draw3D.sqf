/*
 	Name: EDITOR_fnc_Draw3D
 	
 	Author(s):
		Ezhuk
*/	
#define COLOR_LOCAL  [0.0, 0.3, 0.6, 0.5]
#define COLOR_GLOBAL [1.0, 0.5, 0.0, 0.5]
#define COLOR_LOCAL_SELECTED  [0.0, 0.3, 0.6, 1.0]
#define COLOR_GLOBAL_SELECTED [1.0, 0.5, 0.0, 1.0]	
private ["_obj", "_count","_color","_arrayToDrawIcon","_x","_y"];

//---------- show position all objects -------------------
_count = count  EDITOR_Created;
for "_i" from 0 to (_count-1) do 
{
	_obj = EDITOR_Created select _i;
	_color = if(_obj getVariable ["EDITOR_Global",false])then{COLOR_GLOBAL}else{COLOR_LOCAL};
	[_obj,_color0,0.5] call EDITOR_fnc_DrawIcon;
};


//---------- show position selected objects --------------
_count = count  EDITOR_Selected;
for "_i" from 0 to (_count-1) do 
{
	_obj = EDITOR_Selected select _i;
	[_obj,[0,0,1,1]] call EDITOR_fnc_DrawBox3D;

	_color = if(_obj getVariable ["EDITOR_Global",false])then{COLOR_GLOBAL_SELECTED}else{COLOR_LOCAL_SELECTED};
	[_obj,_color] call EDITOR_fnc_DrawIcon;
};


//----------- draw rotate position 
if(count EDITOR_RotateCenter == 3) then {
	_x = EDITOR_RotateCenter select 0;
	_y = EDITOR_RotateCenter select 1;
	drawLine3D [ [_x, _y, 0], [_x, _y, 1000], [0,0.7,0,1]];
	drawLine3D [ [_x, _y, 0], [_x, _y, -1000], [0,0.7,0,1]];

	drawIcon3D ["a3\ui_f\data\map\VehicleIcons\iconexplosiveat_ca.paa", [0,0.7,0,1], [_x, _y, 0], 1, 1, 2, "", 2, 0.05, "PuristaMedium"];
};