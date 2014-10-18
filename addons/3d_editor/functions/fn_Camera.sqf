/*
 	Name: EDITOR_fnc_Camera
 	
 	Author(s):
		Ezhuk
*/	
#include "defines.sqf"

PR(_event) = _this select 0;
PR(_arg)   = _this select 1;

switch (_event) do {
	case "create" : {
		PR(_pos) = getPosASL player;
		PR(_dir) = getDir player;
		PR(_camPos) = [
			(_pos select 0) + sin(_dir+180)*7,
			(_pos select 1) + cos(_dir+180)*7,
			(_pos select 2) + 3
		];

		_camPos = ASLtoATL _camPos;

		EDITOR_Camera = "camera" camCreate _camPos;
		EDITOR_Camera setDir _dir;
		EDITOR_Camera setPos _camPos;
		EDITOR_Camera_AngV = -10;

		[EDITOR_Camera, EDITOR_Camera_AngV, 0] call bis_fnc_setpitchbank;

		EDITOR_Camera cameraEffect ["internal","top"];
		EDITOR_Camera camCommitPrepared 0;	

		showcinemaborder false;
		cameraEffectEnableHUD true;

	};
	case "destroy" : {
		systemChat "camClose";
		player cameraEffect ["terminate","back"];
		camDestroy EDITOR_Camera;

	};
	case "move" : {
		PR(_dist) = 7; PR(_distZ) = 4;

		if(KEY_LCONTROL in EDITOR_keys) then {_dist = 1;   _distZ = 1;};
		if(KEY_LMENU 	in EDITOR_keys) then {_dist = 57;   _distZ = 37;};
		if(KEY_LSHIFT   in EDITOR_keys) then {_dist = 101; _distZ = 57;};
		if(KEY_LSHIFT   in EDITOR_keys && KEY_LMENU in EDITOR_keys) then {_dist = 577; _distZ = 173;};

		PR(_curDir) = direction EDITOR_Camera;
		PR(_newPos) = getPosAsl EDITOR_Camera;

		if(KEY_W in EDITOR_keys) then {_newPos=[0  , _dist, 0, _newPos, _curDir] call EDITOR_fnc_CalculatePosition;};
		if(KEY_S in EDITOR_keys) then {_newPos=[180, _dist, 0, _newPos, _curDir] call EDITOR_fnc_CalculatePosition;};
		if(KEY_A in EDITOR_keys) then {_newPos=[-90, _dist, 0, _newPos, _curDir] call EDITOR_fnc_CalculatePosition;};
		if(KEY_D in EDITOR_keys) then {_newPos=[90 , _dist, 0, _newPos, _curDir] call EDITOR_fnc_CalculatePosition;};

		if(KEY_Q in EDITOR_keys) then {_newPos=[0, 0,  _distZ, _newPos, _curDir] call EDITOR_fnc_CalculatePosition;};
		if(KEY_Z in EDITOR_keys) then {_newPos=[0, 0, -_distZ, _newPos, _curDir] call EDITOR_fnc_CalculatePosition;};

		// check terrein height
		_newPos set [2,(_newPos select 2) max (getterrainheightasl _newPos)];

		if(surfaceIsWater _newPos)then{
			EDITOR_Camera camSetPos _newPos;
		}else{
			EDITOR_Camera camSetPos (ASLtoATL _newPos);
		};

		EDITOR_Camera camCommitPrepared 0.5;
	};
	case "rotate" : {
		PR(_dH) = _arg select 1;
		PR(_dV) = _arg select 2;

		EDITOR_Camera_AngV = (EDITOR_Camera_AngV - _dV) max -89.9 min 89.9;
		EDITOR_Camera setDir (getDir EDITOR_Camera + _dH);
		[EDITOR_Camera, EDITOR_Camera_AngV, 0] call bis_fnc_setpitchbank;
		EDITOR_Camera camCommitPrepared 0;
	};
	case "stop" : {
		if ({_x in [KEY_W,KEY_A,KEY_S,KEY_D,KEY_Q,KEY_Z]} count EDITOR_keys == 0) then {
			PR(_tpos) = getPosATL EDITOR_Camera;
			PR(_pos) = if(surfaceIsWater _tpos)then{getPosASL EDITOR_Camera}else{getPosATL EDITOR_Camera};
			EDITOR_Camera camSetPos _pos;
			EDITOR_Camera camCommitPrepared 0;
		};
	};
};