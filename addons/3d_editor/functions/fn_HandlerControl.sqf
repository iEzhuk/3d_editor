/*
 	Name: EDITOR_fnc_HandlerControl
 	
 	Author(s):
		Ezhuk
*/	
#include "defines.sqf"

PR(_event) = _this select 0;
PR(_arg)   = _this select 1;

switch (_event) do {
	case "Plural_lb_changed" : {
		PR(_ind) = _arg select 1;
		PR(_display) = uiNamespace getVariable 'EDITOR_Disaplay';
		PR(_control) = _display displayCtrl IDC_EDITOR_CLASSES;
		lbClear _control;
		{
			_control lbAdd format ["%1 || %2", getText(configFile >> "CfgVehicles" >> _x >> "displayName"), _x];
			_control lbSetData [_forEachIndex, _x];
		} foreach (EDITOR_Vehicles select _ind);
		lbSort _control;
	};
	case "view_lbDrop" : {
		PR(_wordPos) = screenToWorld [_arg select 1, _arg select 2];
		PR(_vehClass) = ((_arg select 4) select 0) select 2;
		systemChat str(_vehClass);
		systemChat str(_wordPos);

		[_wordPos, _vehClass] call EDITOR_fnc_CreateObject;
	};
	case "view_mouseMoving" : {
		//"["view_mouseMoving",[Control #88804,0.434524,0.73545,true]]"
		PR(_mousePos) = [_arg select 1, _arg select 2];

		switch (true) do {
			// Selecting
			case (MOUSE_RIGHT in EDITOR_Buttons) : {	};
			// Selecting objects
			case (EDITOR_Selecting) : {
				[EDITOR_MouseDown_Position,EDITOR_MouseCur_Position] call EDITOR_fnc_SelectedRectagle;
			};
			// Move objects
			case (EDITOR_InView && (KEY_SPACE in EDITOR_keys)) : {
				PR(_oldPos) = screenToWorld EDITOR_MouseCur_Position;
				PR(_newPos) = screenToWorld _mousePos;

				PR(_speed) = if(KEY_LCONTROL in EDITOR_keys)then{0.1}else{1};

				PR(_dPos) = [
					((_newPos select 0) - (_oldPos select 0))*_speed,
					((_newPos select 1) - (_oldPos select 1))*_speed,
					0
				];

				[EDITOR_Selected, _dPos] call EDITOR_fnc_MoveObjects;
			};
			// Change height 
			case (EDITOR_InView && (KEY_LMENU in EDITOR_keys)) : {
				PR(_mult) = if(KEY_LCONTROL in EDITOR_keys)then{10}else{100};
				PR(_delta) = ((EDITOR_MouseCur_Position select 1) - (_mousePos select 1)) * _mult;

				PR(_dPos) = [0, 0, _delta];

				[EDITOR_Selected, _dPos] call EDITOR_fnc_MoveObjects;
			};
			// Change direction
			case (EDITOR_InView && (KEY_LSHIFT in EDITOR_keys)) : {
				PR(_mult) = if(KEY_LCONTROL in EDITOR_keys)then{10}else{360};
				PR(_delta) = ((EDITOR_MouseCur_Position select 0) - (_mousePos select 0)) * _mult;

				[EDITOR_Selected, _delta] call EDITOR_fnc_RotateObjects;
			};
		};

		EDITOR_MouseCur_Position = _mousePos;
		EDITOR_InView = _arg select 3;
	};
	case "view_mouseButtonDown" : {
		//"["view_mouseButtonDown",[Control #88804,1,0.433532,0.734127,false,false,false]]"
		EDITOR_MouseDown_Position = [_arg select 2, _arg select 3];

		switch (true) do {
			case (MOUSE_LEFT in EDITOR_Buttons) : {
				EDITOR_Selecting = true;
			};
		};

	};
	case "view_mouseButtonUp" : {
		//["view_mouseButtonUp",[Control #88804,0,0.433532,0.734127,false,false,false]]"
		EDITOR_MouseUp_Position = [_arg select 2, _arg select 3];

		[[0,0],[0,0]] call EDITOR_fnc_SelectedRectagle;

		if(EDITOR_Selecting) then {
			// Select objects in rectangle
			[EDITOR_MouseDown_Position,EDITOR_MouseUp_Position] call EDITOR_fnc_SelectObjectsInRectagle; 

			EDITOR_Selecting = false;
		};
	};
};