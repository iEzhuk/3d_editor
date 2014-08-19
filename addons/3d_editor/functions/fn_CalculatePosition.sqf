/*
 	Name: EDITOR_fnc_CalculatePosition
 	Author(s):
		Ezhuk
*/	
#include "defines.sqf"

PR(_angl) = _this select 0;
PR(_dist) = _this select 1;
PR(_dZ) = _this select 2;
PR(_pos) = _this select 3;
PR(_dir) = _this select 4;

PR(_newPos) = [
	(_pos select 0) + ((sin (_dir+_angl)) * _dist),
	(_pos select 1) + ((cos (_dir+_angl)) * _dist),
	(_pos select 2) + _dZ
];

_newPos