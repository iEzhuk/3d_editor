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
		EDITOR_CreatedClasses = [];
		EDITOR_Selecting = false;
		EDITOR_ShowCreatedList = true;

		EDITOR_InView = false;
		EDITOR_InCreated = false;
		EDITOR_InClass = false;
		EDITOR_InPlural = false;

		EDITOR_PosType = POSTYPE_ATL;

		PR(_display) = _arg select 0;
		uiNamespace setVariable ['EDITOR_Disaplay', _display];

		// -------------------- List of plurals --------------------
		PR(_ctrlPlural) = _display displayCtrl IDC_EDITOR_PLURAL;
		lbClear _ctrlPlural;
		{
			_ctrlPlural lbAdd format ["%1 (%2)", _x, count (EDITOR_Vehicles select _forEachIndex)];
			_ctrlPlural lbSetData [_forEachIndex, _x];
		} foreach EDITOR_VehicleClasses;
		lbSort _ctrlPlural;
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

		GUISTATE_VIEW call EDITOR_chageGuiSate;
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
		//player switchCamera "INTERNAL";

		["destroy", []] call EDITOR_fnc_Camera;

		{_x enableSimulationGlobal true;} foreach EDITOR_Created;
	};
	case "disp_keyDown" : {	
		PR(_key)	= _arg select 1;
		PR(_shift)	= _arg select 2;
		PR(_ctrl)	= _arg select 3;
		PR(_alt)	= _arg select 4;


		switch (_key) do {
			// Copy
			case KEY_C : {
				systemChat format ["KEY: %1 %2 %3",_key,EDITOR_InView,EDITOR_keys];
				if (EDITOR_InView && !(KEY_C in EDITOR_keys)) then {
					[] call EDITOR_fnc_Save;
				};
			};
			// Paste
			case KEY_V : {
				systemChat format ["KEY: %1 %2 %3",_key,EDITOR_InView,EDITOR_keys];
				if (EDITOR_InView && !(KEY_V in EDITOR_keys)) then {
					[] call EDITOR_fnc_Paste;
				};
			};
			case KEY_M : {
				if(EDITOR_InView) then {
					PR(_mousePos) = screenToWorld EDITOR_MouseCur_Position;
					player setPos _mousePos;
				};
			};
			case KEY_1 : {
				if(EDITOR_InView) then {
					if (count EDITOR_Selected > 0) then {
						EDITOR_Selected = [EDITOR_Selected select 0];
					};
				};
			};
		};

		// check ALT+TAB 
		if (_key == KEY_TAB && _alt) exitWith {
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
			EDITOR_keys = [];
		};

		EDITOR_keys = EDITOR_keys - [_key];

		["stop",_arg] call EDITOR_fnc_Camera;

		switch (_key) do {
			//---------------- Set point to rotate
			case KEY_R : {
				if(EDITOR_InView) then {
					if (count EDITOR_RotateCenter == 0) then {
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
			case KEY_H : {
				PR(_display) = uiNamespace getVariable 'EDITOR_Disaplay';
				PR(_ctrCreated) = _display displayCtrl IDC_EDITOR_CREATED;

				if(EDITOR_ShowCreatedList) then {
					EDITOR_ShowCreatedList = false;
					_ctrCreated ctrlSetPosition [-0.2*safezoneW+safezoneX,0.0*safezoneH+safezoneY];
					_ctrCreated ctrlCommit 0;
				}else{
					EDITOR_ShowCreatedList = true;
					_ctrCreated ctrlSetPosition [0.0*safezoneW+safezoneX,0.0*safezoneH+safezoneY];
					_ctrCreated ctrlCommit 0;
				};
			};
			case KEY_P : {
				player switchCamera "INTERNAL";
			};
			case KEY_LBRACKET : {
				for "_i" from 0 to (count EDITOR_Selected - 1) do 
				{
					PR(_obj) = EDITOR_Selected select _i;
					_obj setVariable ["EDITOR_Marker",true,true];
				};
			};
			case KEY_RBRACKET : {
				for "_i" from 0 to (count EDITOR_Selected - 1) do 
				{
					PR(_obj) = EDITOR_Selected select _i;
					_obj setVariable ["EDITOR_Marker",false,true];
				};
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