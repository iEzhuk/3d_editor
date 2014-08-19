/*
 	Name: EDITOR_fnc_HandlerDisplay
 	
 	Author(s):
		Ezhuk
*/	
#include "defines.sqf"

PR(_event) = _this select 0;
PR(_arg)   = _this select 1;

switch (_event) do {
	case "init" : {
		EDITOR_keys = [];
		EDITOR_Buttons = [];
		EDITOR_Selecting = false;
		EDITOR_InView = false;
		PR(_display) = _arg select 0;
		uiNamespace setVariable ['EDITOR_Disaplay', _display];

		// -------------------- List of plurals --------------------
		PR(_ctrlPlural) = _display displayCtrl IDC_EDITOR_PLURAL;
		lbClear _ctrlPlural;
		{
			_ctrlPlural lbAdd format ["%1 (%2)", _x, count (EDITOR_Vehicles select _forEachIndex)];
		} foreach EDITOR_VehicleClasses;
		_ctrlPlural lbSetCurSel 0;

		// -------------------- Camera --------------------
		["create", []] call EDITOR_fnc_Camera;

		// -------------------- Handler --------------------
		EDITOR_handKeyDown 		   = _display displayAddEventHandler ["KeyDown"			, "['disp_keyDown',_this] call EDITOR_fnc_HandlerDisplay"];
		EDITOR_handKeyUp 		   = _display displayAddEventHandler ["KeyUp"			, "['disp_keyUp',_this] call EDITOR_fnc_HandlerDisplay"];
		EDITOR_handMouseMoving 	   = _display displayAddEventHandler ["MouseMoving"		, "['disp_mouseMovie',_this] call EDITOR_fnc_HandlerDisplay"];
		EDITOR_handMouseButtonDown = _display displayAddEventHandler ["MouseButtonDown"	, "['disp_mouseButtonDown',_this] call EDITOR_fnc_HandlerDisplay"];
		EDITOR_handMouseButtonUp   = _display displayAddEventHandler ["MouseButtonUp"	, "['disp_mouseButtonUp',_this] call EDITOR_fnc_HandlerDisplay"];

		//[] call EDITOR_fnc_ParserCfg;

		player allowDamage false;

		{_x enableSimulationGlobal false;} foreach EDITOR_Created;
	};
	case "close" : {
		// -------------------- Remove handler --------------------
		PR(_display) = uiNamespace getVariable 'EDITOR_Disaplay';
		_display displayRemoveEventHandler ["KeyDown"		 , EDITOR_handKeyDown];
		_display displayRemoveEventHandler ["KeyUp"			 , EDITOR_handKeyUp];
		_display displayRemoveEventHandler ["MouseMoving"	 , EDITOR_handMouseMoving];
		_display displayRemoveEventHandler ["MouseButtonDown", EDITOR_handMouseButtonDown];
		_display displayRemoveEventHandler ["MouseButtonUp"	 , EDITOR_handMouseButtonUp];

		player allowDamage true;
		player switchCamera "INTERNAL";

		//["destroy", []] call EDITOR_fnc_Camera;

		{_x enableSimulationGlobal true;} foreach EDITOR_Created;
	};
	case "disp_keyDown" : {	
		PR(_key)	= _arg select 1;
		PR(_shift)	= _arg select 2;
		PR(_ctrl)	= _arg select 3;
		PR(_alt)	= _arg select 4;

		// check ALT+TAB 
		if (_key == KEY_TAB && _alt) exitWith {
			systemChat "ALTTAB";
			EDITOR_keys = [];
		};

		if !(_key in EDITOR_keys) then {
			EDITOR_keys = EDITOR_keys + [_key];
		};
		
		["move",_arg] call EDITOR_fnc_Camera;

		_arg call EDITOR_fnc_ManipulateObjectByKeyboard;
	};
	case "disp_keyUp" : {
		PR(_key)	= _arg select 1;
		PR(_shift)	= _arg select 2;
		PR(_ctrl)	= _arg select 3;
		PR(_alt)	= _arg select 4;

		// check ALT+TAB 
		if (_key == KEY_TAB && _alt) exitWith {
			systemChat "ALTTAB";
			EDITOR_keys = [];
		};

		EDITOR_keys = EDITOR_keys - [_key];

		["stop",_arg] call EDITOR_fnc_Camera;

		switch (_key) do {
			//---------------- Set point to rotate
			case KEY_R : {
				if(EDITOR_InView) then {
					if !(_ctrl) then {
						PR(_wordPos) = screenToWorld EDITOR_MouseCur_Position;
						EDITOR_RotateCenter = _wordPos;
					} else {
						EDITOR_RotateCenter = [];
					};
				};
			};
			//---------------- Set point to rotate
			case KEY_DELETE : {
				[] call EDITOR_fnc_RemoveSelected;
			};
			//---------------- Set type of selected objects (Global\Local);
			case KEY_G : {
				for "_i" from 0 to (count EDITOR_Selected - 1) do 
				{
					PR(_obj) = EDITOR_Selected select _i;
					PR(_global) = _obj getVariable ["EDITOR_Global",false];

					_obj setVariable ["EDITOR_Global",_ctrl,true];
				};
			};
			//---------------- Set type of selected objects (Global\Local);
			case KEY_L : {
				for "_i" from 0 to (count EDITOR_Selected - 1) do 
				{
					PR(_obj) = EDITOR_Selected select _i;
					PR(_pos) = getPos _obj;
					if(_ctrl) then {
						_obj setVectorUp surfaceNormal _pos;
					} else {
						_obj setPos [_pos select 0,_pos select 1, 0];
					};
				};
			};
			//--------------- Save script ot clipboard
			case KEY_END : {
				systemChat "Saving...";
				[] call EDITOR_fnc_SaveToClipboard;
			};
		};
	};
	case "disp_mouseMovie" : {
		if(MOUSE_RIGHT in EDITOR_Buttons) then {
			["rotate",_arg] call EDITOR_fnc_Camera;
		};
	};
	case "disp_mouseButtonDown" : {
		PR(_button) = _arg select 1;
		PR(_pX) = _arg select 2;
		PR(_pY) = _arg select 3;
		
		if !(_button in EDITOR_Buttons) then {
			EDITOR_Buttons = EDITOR_Buttons + [_button];
		};
	};
	case "disp_mouseButtonUp" : {
		PR(_button) = _arg select 1;
		PR(_pX) = _arg select 2;
		PR(_pY) = _arg select 3;

		EDITOR_Buttons = EDITOR_Buttons - [_button];
	};
};
false