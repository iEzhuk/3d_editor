#include "defines.sqf"


//========================================================================================
//	Name:	EDITOR_fnc_DrawBox3D
//	Desc:	Draw 3d box around object 
//========================================================================================
EDITOR_fnc_DrawBox3D = {
	private ["_obj","_color","_boxBot","_boxTop","_xB","_xT","_yB","_yT","_zB","_zT"];
	_obj = _this select 0;
	_color = _this select 1;

	_boxBot = (boundingboxReal _obj) select 0;
	_boxTop = (boundingboxReal _obj) select 1;

	_xB = _boxBot select 0;	_xT = _boxTop select 0;
	_yB = _boxBot select 1;	_yT = _boxTop select 1;
	_zB = _boxBot select 2;	_zT = _boxTop select 2;

	// bottom
	drawLine3D [ _obj modeltoworld [_xB, _yB, _zB], _obj modeltoworld [_xT, _yB, _zB], _color];
	drawLine3D [ _obj modeltoworld [_xB, _yT, _zB], _obj modeltoworld [_xT, _yT, _zB], _color];
	drawLine3D [ _obj modeltoworld [_xB, _yB, _zB], _obj modeltoworld [_xB, _yT, _zB], _color];
	drawLine3D [ _obj modeltoworld [_xT, _yB, _zB], _obj modeltoworld [_xT, _yT, _zB], _color];

	// top
	drawLine3D [ _obj modeltoworld [_xB, _yB, _zT], _obj modeltoworld [_xT, _yB, _zT], _color];
	drawLine3D [ _obj modeltoworld [_xB, _yT, _zT], _obj modeltoworld [_xT, _yT, _zT], _color];
	drawLine3D [ _obj modeltoworld [_xB, _yB, _zT], _obj modeltoworld [_xB, _yT, _zT], _color];
	drawLine3D [ _obj modeltoworld [_xT, _yB, _zT], _obj modeltoworld [_xT, _yT, _zT], _color];

	// vertical
	drawLine3D [ _obj modeltoworld [_xB, _yB, _zB], _obj modeltoworld [_xB, _yB, _zT], _color];
	drawLine3D [ _obj modeltoworld [_xB, _yT, _zB], _obj modeltoworld [_xB, _yT, _zT], _color];
	drawLine3D [ _obj modeltoworld [_xT, _yB, _zB], _obj modeltoworld [_xT, _yB, _zT], _color];
	drawLine3D [ _obj modeltoworld [_xT, _yT, _zB], _obj modeltoworld [_xT, _yT, _zT], _color];
};

//========================================================================================
//	Name:	EDITOR_fnc_DrawIcon
//	Desc:	Draw icon pos 
//========================================================================================
EDITOR_fnc_DrawIcon = {
	private ["_obj","_color","_pos","_text","_size"];
	_obj = _this select 0;
	_color = _this select 1;
	_size = [_this, 2, 1.0] call BIS_fnc_param;

	_pos = getPos _obj;

	//drawIcon3D ["a3\ui_f\data\map\markers\military\box_CA.paa", _color, _pos, 1, 1, 2, "", 2, 0.05, "PuristaMedium"];
	drawIcon3D ["a3\ui_f\data\map\markers\military\box_CA.paa", _color, _pos, _size, _size, 2, "", 2, 0.05, "PuristaMedium"];
};

//========================================================================================
//	Name:	EDITOR_fnc_CreateObject
//	Desc:	Draw icon pos 
//========================================================================================
EDITOR_fnc_CreateObject = {
	PR(_pos) = _this select 0;
	PR(_class) = _this select 1;

	PR(_newObj) = createVehicle [ [_vehClass] call BIS_fnc_filterString, _pos, [], 0, "CAN_COLLIDE"];

	if(!(isNull _newObj)) then 
	{
		_newObj setVariable ["EDITOR_Global",false];
		_newObj setVariable ["EDITOR_Marker",false];
		_newObj setVariable ["EDITOR_Pitch",[_h,_v]];
		_newObj allowdamage false;
		_newObj enableSimulationGlobal false;

		if (count EDITOR_Selected == 1) then {
			PR(_tObj) = EDITOR_Selected select 0;
			PR(_posASL) = _tObj call EDITOR_getPos;

			_newObj setDir (getDir _tObj);
			_newObj setVectorUp (vectorUp _tObj);
			_newObj setVariable ["EDITOR_Global", (_tObj getVariable ["EDITOR_Global",false]) ];
			_newObj setVariable ["EDITOR_Marker", (_tObj getVariable ["EDITOR_Marker",false]) ];

			_pos set [2, _posASL select 2];
			[_newObj,_pos] call EDITOR_setPos;
		};

		EDITOR_Created set [count EDITOR_Created, _newObj];
		EDITOR_Selected = [_newObj];
	};

	[] call EDITOR_fnc_UpdateCreatedClasses;

	PR(_br) = toString [13, 10];
	PR(_text) = "";

	PR(_base) 		 = configName (inheritsFrom (configFile >> "CfgVehicles" >> _class));
	PR(_plural) 	 = getText(configFile >> "CfgVehicles" >> _class >> "textPlural");
	PR(_displayName) = getText(configFile >> "CfgVehicles" >> _class >> "displayName");


	_text = _text + (format ["class %1 : %2 {"			 , _class, _base]) + _br;
	_text = _text + (format ["    textPlural = ""%1"";"  , _plural ]) + _br;
	_text = _text + (format ["    displayName = ""%1"";" , _displayName ]) + _br;
	_text = _text + "};" + _br;


	copyToClipboard _text;
};

//========================================================================================
//	Name:	Create object
//	Desc:	Draw rectagle 
//========================================================================================
EDITOR_fnc_CoordToRectanle = {
	PR(_pos1) = _this select 0;
	PR(_pos2) = _this select 1;

	PR(_x) = (_pos1 select 0) min (_pos2 select 0);
	PR(_y) = (_pos1 select 1) min (_pos2 select 1);
	PR(_w) = ((_pos1 select 0) max (_pos2 select 0)) - _x;
	PR(_h) = ((_pos1 select 1) max (_pos2 select 1)) - _y;

	[_x, _y, _w, _h]
};

//========================================================================================
//	Name:	EDITOR_fnc_CheckPositionInRectangle
//	Desc:	Draw rectagle 
//========================================================================================
EDITOR_fnc_CheckPositionInRectangle = {
	PR(_pos) = _this select 0;
	PR(_rect) = _this select 1;

	PR(_pX) = _pos select 0;
	PR(_pY) = _pos select 1;

	PR(_x) = _rect select 0; 
	PR(_y) = _rect select 1;
	PR(_w) = _rect select 2;
	PR(_h) = _rect select 3;

	(_pX > _x) && (_pX < _x+_w) && (_pY > _y) && (_pY < _y+_h)
};

//========================================================================================
//	Name:	EDITOR_fnc_CalculatePosition
//	Desc:	Calculate new position
//========================================================================================
EDITOR_fnc_CalculatePosition = {
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
};

//========================================================================================
//	Name:	EDITOR_fnc_SelectedRectagle
//	Desc:	Draw rectagle 
//========================================================================================
EDITOR_fnc_SelectedRectagle = {
	PR(_pos1) = _this select 0;
	PR(_pos2) = _this select 1;

	PR(_display) = uiNamespace getVariable 'EDITOR_Disaplay';
	PR(_control) = _display displayCtrl IDC_EDITOR_SELECT;	

	_control ctrlSetPosition ([_pos1,_pos2] call EDITOR_fnc_CoordToRectanle);
	_control ctrlCommit 0;
};

//========================================================================================
//	Name:	EDITOR_fnc_SelectObjectsInRectagle
//	Desc:	Draw rectagle 
//========================================================================================
EDITOR_fnc_SelectObjectsInRectagle = {
	PR(_rect) = [_this select 0,_this select 1] call EDITOR_fnc_CoordToRectanle;

	// If ctrl is no pushed then clean selected objects
	if !(KEY_LCONTROL in EDITOR_keys) then {
		EDITOR_Selected = [];
	};

	PR(_count) = count EDITOR_Created;
	for "_i" from 0 to (_count-1) do 
	{
		PR(_obj) = EDITOR_Created select _i;
		PR(_screenPos) = worldToScreen (getPos _obj);

		if(count _screenPos == 2) then {
			if([_screenPos,_rect] call EDITOR_fnc_CheckPositionInRectangle) then {
				if(_obj in EDITOR_Selected) then {
					EDITOR_Selected = EDITOR_Selected - [_obj];
				} else {
					EDITOR_Selected set [count EDITOR_Selected, _obj];
				};
			};
		};
	};
};

//========================================================================================
//	Name:	EDITOR_fnc_MoveObjects
//	Desc:	Draw rectagle 
//========================================================================================
EDITOR_fnc_MoveObjects = {
	private ["_delta","_count","_pos","_newPos","_obj","_pitchBank","_vectorUp"];

	_objs  = _this select 0;
	_delta = _this select 1;
	_count = count _objs;

	for "_i" from 0 to (_count-1) do 
	{
		_obj = _objs select _i;
		// _pitchBank = _obj call BIS_fnc_getPitchBank;
		_vectorUp = vectorUp _obj;
		_obj setvectorup [0,0,1];
		_pos = _obj call EDITOR_getPos;

		_newPos = 	[
						(_pos select 0) + (_delta select 0),
						(_pos select 1) + (_delta select 1),
						(_pos select 2) + (_delta select 2)
					];

		[_obj,_newPos] call EDITOR_setPos;
		_obj setVectorUp _vectorUp;
		// [_obj, _pitchBank select 0, _pitchBank select 1] call BIS_fnc_setPitchBank;
	};
};

//========================================================================================
//	Name:	EDITOR_fnc_RotatePoint
//	Desc:	Ratate point around center 
//========================================================================================
EDITOR_fnc_RotatePoint = {
	private ["_pX0", "_pY0","_cX", "_cY","_a","_pX1", "_pY1"];
	_pX0 = _this select 0;
	_pY0 = _this select 1;
	_cX  = _this select 2;
	_cY  = _this select 3;
	_a   = _this select 4;

	_pX1 = _cX + (_pX0 - _cX)*cos(_a) - (_pY0 - _cY)*sin(_a);
	_pY1 = _cY + (_pY0 - _cY)*cos(_a) + (_pX0 - _cX)*sin(_a);
	
	[_pX1,_pY1]
};

//========================================================================================
//	Name:	EDITOR_fnc_RotateObjects
//	Desc:	Draw rectagle 
//========================================================================================
EDITOR_fnc_RotateObjects = {
	private ["_delta","_count","_pos","_dir","_newPos","_obj","_pitchBank","_vectorUp","_pitch"];

	_objs  = _this select 0;
	_delta = _this select 1;
	_count = count _objs;

	for "_i" from 0 to (_count-1) do 
	{
		_obj = _objs select _i;
		// _pitchBank = _obj call BIS_fnc_getPitchBank;
		_vectorUp = vectorUp _obj;
		_obj setvectorup [0,0,1];
		_dir = getdir _obj;

		_obj setDir _dir+_delta;

		if(count EDITOR_RotateCenter == 3) then {
			private ["_x","_y","_nx","_ny"];
			_pos = _obj call EDITOR_getPos;

			_nPos = [_pos select 0, _pos select 1, EDITOR_RotateCenter select 0, EDITOR_RotateCenter select 1, -_delta] call EDITOR_fnc_RotatePoint;
			_nPos set [2, _pos select 2];

			[_obj,_nPos] call EDITOR_setPos;
		};

		//_obj setVectorUp _vectorUp;

		_pitch = _obj getVariable ["EDITOR_Pitch",[0,0]];
		[_obj, _pitch select 0, _pitch select 1] call BIS_fnc_setPitchBank;
	};
};


//========================================================================================
//	Name:	EDITOR_fnc_RemoveSelected
//	Desc:	Remove selected objects
//========================================================================================
EDITOR_fnc_RemoveSelected = {
	EDITOR_Created = EDITOR_Created - EDITOR_Selected;

	for "_i" from 0 to (count EDITOR_Selected - 1) do 
	{
		deleteVehicle (EDITOR_Selected select _i);
	};

	EDITOR_Selected = [];
	EDITOR_RotateCenter = [];

	[] call EDITOR_fnc_UpdateCreatedClasses;
};

//========================================================================================
//	Name:	EDITOR_fnc_SetPitch
//	Desc:	Change vetorup by angles 
//========================================================================================
EDITOR_fnc_SetPitch = {
	private ["_obj","_h","_v","_x","_y","_z"];

	_obj = _this select 0;
	_v = _this select 1;
	_h = _this select 2;
	_v = -180 max (180 min _v);
	_h = -180 max (180 min _h);

	[_obj, _v, _h] call BIS_fnc_setPitchBank;

	_obj setVariable ["EDITOR_Pitch", [_v, _h]];
};

//========================================================================================
//	Name:	EDITOR_fnc_ChangePitch
//	Desc:	Change vetorup by angles 
//========================================================================================
EDITOR_fnc_ChangePitch = {
	switch (count _this) do {
		case 2: {
			PR(_dY) = _this select 0;
			PR(_dX) = _this select 1;
			for "_i" from 0 to (count EDITOR_Selected - 1) do 
			{
				PR(_obj) = EDITOR_Selected select _i;
				PR(_pitch) = _obj getVariable ["EDITOR_Pitch",[0,0]];

				[_obj, (_pitch select 0)+_dX, (_pitch select 1)+_dY] call EDITOR_fnc_SetPitch;
			};
		};
		default {
			for "_i" from 0 to (count EDITOR_Selected - 1) do 
			{
				PR(_obj) = EDITOR_Selected select _i;
				[_obj, 0, 0] call EDITOR_fnc_SetPitch;
			};
		};
	};
};

//========================================================================================
//	Name:	EDITOR_fnc_ManipulateObjectByKeyboard
//	Desc:	Change pitch of objects
//========================================================================================
EDITOR_fnc_ManipulateObjectByKeyboard = {
	PR(_key)	= _this select 1;
	PR(_shift)	= _this select 2;
	PR(_ctrl)	= _this select 3;
	PR(_alt)	= _this select 4;

	switch (_key) do {
		case KEY_NUMPAD8:{
			[1,0] call EDITOR_fnc_ChangePitch;
		};
		case KEY_NUMPAD2:{
			[-1,0] call EDITOR_fnc_ChangePitch;
		};
		case KEY_NUMPAD4:{
			[0,1] call EDITOR_fnc_ChangePitch;
		};
		case KEY_NUMPAD6:{
			[0,-1] call EDITOR_fnc_ChangePitch;
		};
		case KEY_NUMPAD5:{
			[] call EDITOR_fnc_ChangePitch;
		};
	};
};

//========================================================================================
//	Name:	EDITOR_fnc_Save
//	Desc:	Save object to copy
//========================================================================================
EDITOR_fnc_Save = {
	EDITOR_Saved = [];
	
	systemChat format ["EDITOR_fnc_Save: %1",EDITOR_Selected];

	switch (true) do {
		case (count EDITOR_Selected > 1) : 
		{
			PR(_mousePos) = screenToWorld EDITOR_MouseCur_Position;

			for "_i" from 0 to ((count EDITOR_Selected)-1) do {
				PR(_obj) = EDITOR_Selected select _i;
				PR(_pos) = _obj call EDITOR_getPos; 
				PR(_delPos) = [
						(_pos select 0) - (_mousePos select 0),
						(_pos select 1) - (_mousePos select 1),
						(_pos select 2)
					];
				PR(_tmp) = [
						/*0*/ 	typeOf _obj,
						/*1*/	_delPos,
						/*2*/	vectorUp _obj,
						/*3*/	_obj getVariable ["EDITOR_Pitch",[0,0]],
						/*4*/	_obj getVariable ["EDITOR_Global",false],
						/*5*/	getDir _obj
					];
				EDITOR_Saved set [count EDITOR_Saved, _tmp];
			};

		};

		case (count EDITOR_Selected == 1) : 
		{
			PR(_obj) = EDITOR_Selected select 0;
			PR(_pos) = _obj call EDITOR_getPos; 
			PR(_tmp) = [
					/*0*/ 	typeOf _obj,
					/*1*/	[0,0,_pos select 2],
					/*2*/	vectorUp _obj,
					/*3*/	_obj getVariable ["EDITOR_Pitch",[0,0]],
					/*4*/	_obj getVariable ["EDITOR_Global",false],
					/*5*/	getDir _obj,
					/*6*/   _obj getVariable ["EDITOR_Marker",false]
				];
			EDITOR_Saved = [_tmp];
		};

	};
};

//========================================================================================
//	Name:	EDITOR_fnc_Paste
//	Desc:	
//========================================================================================
EDITOR_fnc_Paste = {
	PR(_created) = [];
	PR(_mousePos) = screenToWorld EDITOR_MouseCur_Position;

	
	//systemChat format ["EDITOR_fnc_Paste: %1",EDITOR_Saved];

	for "_i" from 0 to ((count EDITOR_Saved)-1) do {
		PR(_objTMP) = EDITOR_Saved select _i;

		PR(_vehClass)   = _objTMP select 0;
		PR(_dPos) 		= _objTMP select 1;
		PR(_vectorUp)   = _objTMP select 2;
		PR(_pitch)      = _objTMP select 3;
		PR(_global)		= _objTMP select 4;
		PR(_dir)		= _objTMP select 5;
		PR(_marker)		= _objTMP select 6;

		PR(_pos) = [
				(_mousePos select 0) + (_dPos select 0),
				(_mousePos select 1) + (_dPos select 1),
				_dPos select 2
			];

		PR(_newObj) = createVehicle [ [_vehClass] call BIS_fnc_filterString, _pos, [], 0, "CAN_COLLIDE"];

		if(!(isNull _newObj)) then 
		{
			[_newObj, _pos] call EDITOR_setPos;
			_newObj setVectorUp _vectorUp;
			_newObj setDir _dir;

			_newObj setVariable ["EDITOR_Global",_global];
			_newObj setVariable ["EDITOR_Marker",_marker];
			_newObj setVariable ["EDITOR_Pitch",_pitch];
			_newObj allowdamage false;
			_newObj enableSimulationGlobal false;

			_created = _created + [_newObj];

			EDITOR_Created set [count EDITOR_Created, _newObj];
		};

	};


	EDITOR_Selected = _created;
};

//========================================================================================
//	Name:	EDITOR_fnc_PrepareScriptToCreateObject_Local
//	Desc:	Create script to create object 
//========================================================================================
EDITOR_fnc_PrepareScriptToCreateObject_Local = {
	PR(_obj) = _this select 0;
	PR(_objType) = typeOf _obj;
	PR(_vectorUp) = vectorUp _obj;
	PR(_pitch) = _obj call BIS_fnc_getPitchBank;
	_obj setvectorup [0,0,1];
	PR(_pos) = getPosWorld _obj;
	PR(_dir) = getDir _obj;
	_obj setVectorUp _vectorUp;
	PR(_txt) = "";

	_txt = _txt + format ["_obj = ""%1"" createVehiclelocal %2;",_objType,_pos] + _br;
	_txt = _txt + format ["_obj setPosWorld %1;",_pos] + _br;
	_txt = _txt + format ["_obj setDir %1;",_dir] + _br;
	//_txt = _txt + format ["_obj setVectorUp %1;",_vectorUp] + _br;
	_txt = _txt + format ["[_obj, %1, %2] call BIS_fnc_setPitchBank;",_pitch select 0 , _pitch select 1] + _br;
	// if(_obj isKindOf "Building") then {
	// 	_txt = _txt + "_obj call BIS_fnc_boundingBoxMarker;" + _br;
	// };
	_txt = _txt + format ["_obj setVariable [""EDITOR_Marker"",%1];",_obj getVariable ["EDITOR_Marker",false]] + _br;
	_txt = _txt + "_obj allowdamage false;" + _br;
	_txt = _txt + "_obj enableSimulationGlobal false;" + _br;
	_txt = _txt + "EDITOR_Created set [count EDITOR_Created, _obj];" + _br;

	_txt = _txt + _br;
	_txt
};

//========================================================================================
//	Name:	EDITOR_fnc_PrepareScriptToCreateObject_Global
//	Desc:	Create script to create object 
//========================================================================================
EDITOR_fnc_PrepareScriptToCreateObject_Global = {
	PR(_obj) = _this select 0;
	PR(_objType) = typeOf _obj;
	PR(_vectorUp) = vectorUp _obj;
	PR(_pitch) = _obj call BIS_fnc_getPitchBank;
	_obj setvectorup [0,0,1];
	PR(_pos) = getPosWorld _obj;
	PR(_dir) = getDir _obj;
	_obj setVectorUp _vectorUp;
	PR(_txt) = "";

	_txt = _txt + format ["_obj = createVehicle [""%1"", %2, [], 0, ""CAN_COLLIDE""];",_objType,_pos] + _br;
	_txt = _txt + format ["_obj setPosWorld %1;",_pos] + _br;
	_txt = _txt + format ["_obj setDir %1;",_dir] + _br;

	//_txt = _txt + format ["_obj setVectorUp %1;",_vectorUp] + _br;

	_txt = _txt + format ["[_obj, %1, %2] call BIS_fnc_setPitchBank;",_pitch select 0 , _pitch select 1] + _br;
	_txt = _txt + format ["_obj setVariable [""EDITOR_Marker"",%1];",_obj getVariable ["EDITOR_Marker",false]] + _br;

	_txt = _txt + "_obj setVariable [""EDITOR_Global"", true];" + _br;
	_txt = _txt + "EDITOR_Created set [count EDITOR_Created, _obj];" + _br;

	_txt = _txt + _br;
	_txt
};

//========================================================================================
//	Name:	EDITOR_PrepareScriptForMarkers
//	Desc:	Create script to draw marker 
//========================================================================================
EDITOR_PrepareScriptForMarkers = {
	private ["_obj","_id","_logic","_bbox","_b1","_b2","_bbx","_bby","_marker","_text"];

	_obj   = _this select 0;
	_color = [_this, 1, "ColorBlack"] call BIS_fnc_param;
	_alpha = [_this, 2, 1.0] call BIS_fnc_param;

	_pos 	= position _obj;
	_dir 	= direction _obj;
	_bbox 	= boundingboxreal _obj;
	_b1 	= _bbox select 0;
	_b2 	= _bbox select 1;
	_bbx 	= (abs(_b1 select 0) + abs(_b2 select 0));
	_bby 	= (abs(_b1 select 1) + abs(_b2 select 1));

	format ["[%1, %2, %3, %4] call EDITOR_BoundingBoxMarker_Local;",_pos, _dir, _bbx, _bby]
};

//========================================================================================
//	Name:	EDITOR_fnc_SaveToClipboard
//	Desc:	Save script to criate object in mission 
//========================================================================================
EDITOR_fnc_SaveToClipboard = {
	PR(_br) = toString [13, 10];
	PR(_text) = "";

	_text = _text + "// Object count:"+_br;
	_text = _text + format ["//     Global - %1", {_obj getVariable ["EDITOR_Global",false]} count EDITOR_Created] + _br;
	_text = _text + format ["//     Local  - %1", {!(_obj getVariable ["EDITOR_Global",false])} count EDITOR_Created] + _br;
	_text = _text + "private [""_obj""];"+_br;
	_text = _text + 'if (isnil "EDITOR_Created") then {EDITOR_Created = [];};'+_br;

	_text = _text + _br;

	//------------------- Function to draw marker on buildings -------------------
	_text = _text + "EDITOR_BoundingBoxMarker_Local = {" + _br;
	_text = _text + "private [""_dir"",""_pos"",""_id"",""_logic"",""_bbox"",""_b1"",""_b2"",""_bbx"",""_bby"",""_marker""];" + _br;
	_text = _text + "_pos   = _this select 0;" + _br;
	_text = _text + "_dir   = _this select 1;" + _br;
	_text = _text + "_bbx   = _this select 2;" + _br;
	_text = _text + "_bby   = _this select 3;" + _br;
	_text = _text + "_color = ""ColorBlack"";" + _br;
	_text = _text + "_alpha = 1.0;" + _br;
	_text = _text + "if(!hasInterface)exitWith{};" + _br;
	_text = _text + "_logic = bis_functions_mainscope;" + _br;
	_text = _text + "_id    = if (isnil {_logic getvariable ""bundingBoxMarker_id""}) then {_logic setvariable [""bundingBoxMarker_id"",-1];-1} else {_logic getvariable ""bundingBoxMarker_id""};" + _br;
	_text = _text + "[_logic,""bundingBoxMarker_id"",1] call bis_fnc_variablespaceadd;" + _br;
	_text = _text + "_marker = createmarkerlocal [format [""EDITOR_BundingBoxMarker_%1"", _id], _pos];" + _br;
	_text = _text + "_marker setmarkerdir        _dir;" + _br;
	_text = _text + "_marker setmarkershapelocal ""rectangle"";" + _br;
	_text = _text + "_marker setmarkersizelocal  [_bbx/2,_bby/2];" + _br;
	_text = _text + "_marker setmarkercolor      _color;" + _br;
	_text = _text + "_marker setmarkeralphalocal _alpha;" + _br;
	_text = _text + "};" + _br;
	_text = _text + _br;


	//------------------- Global part -------------------
	_text = _text + "if (isserver) then {" + _br;
	for "_i" from 0 to ((count EDITOR_Created)-1) do {
		PR(_obj) = EDITOR_Created select _i;
		if(_obj getVariable ["EDITOR_Global",false]) then {
			_text = _text + ([_obj] call EDITOR_fnc_PrepareScriptToCreateObject_Global);
		};
	};
	_text = _text + "};" + _br;
	//---------------------------------------------------

	//------------------- Local part -------------------
	_text = _text + "if !(isdedicated) then {" + _br;
	for "_i" from 0 to ((count EDITOR_Created)-1) do {
		PR(_obj) = EDITOR_Created select _i;
		if !(_obj getVariable ["EDITOR_Global",false]) then {
			_text = _text + ([_obj] call EDITOR_fnc_PrepareScriptToCreateObject_Local);
		};
	};

	_text = _text + _br;
	_text = _text + "// Drawing markers" + _br;
	_text = _text + _br;
	
	for "_i" from 0 to ((count EDITOR_Created)-1) do {
		PR(_obj) = EDITOR_Created select _i;
		//if (_obj isKindOf "Building") then {
		if(_obj getVariable ["EDITOR_Marker",false]) then {
			_text = _text + ([_obj] call EDITOR_PrepareScriptForMarkers);
			_text = _text + _br;
		};
	};
	_text = _text + "};" + _br;
	//---------------------------------------------------

	systemChat format ["Data copied to Clipboard: %1 objects",count EDITOR_Created];
	// hint format ["Data copied to Clipboard: %1 objects",count EDITOR_Created];

	copyToClipboard _text;
};

//========================================================================================
//	Name:	EDITOR_fnc_UpdateCreatedClasses
//	Desc:	Show created classes
//========================================================================================
EDITOR_fnc_UpdateCreatedClasses = {
	PR(_display) = uiNamespace getVariable 'EDITOR_Disaplay';
	PR(_ctrCreated) = _display displayCtrl IDC_EDITOR_CREATED;

	// Find all created classes
	PR(_createdClasses) = [];
	PR(_indCC) = 0;

	for "_i" from 0 to ((count EDITOR_Created)-1) do {
		PR(_obj) = EDITOR_Created select _i;
		PR(_vehClass) = typeOf _obj;

		if !(_vehClass in _createdClasses) then {
			_createdClasses set [_indCC, _vehClass];
			_indCC = _indCC + 1;
		};
	};

	// Update control
	lbClear _ctrCreated;
	for "_i" from 0 to ((count _createdClasses)-1) do {
		PR(_vehClass) = _createdClasses select _i;

		_ctrCreated lbAdd format ["%1  ||  %2", getText (configFile >> "CfgVehicles" >> _vehClass >> "displayName"), _vehClass];
		_ctrCreated lbSetData [_i, _vehClass];
	};
	lbSort _ctrCreated;
};

//========================================================================================
//	Name:	EDITOR_setCtrlPosition
//	Desc:	Set ctrl position in absolute coordinate
//========================================================================================
EDITOR_setCtrlPosition = {
	PR(_ctrl) = _this select 0;
	PR(_pos) = _this select 1;

	_pos set [0, (_pos select 0)*safeZoneW+safeZoneX];
	_pos set [1, (_pos select 1)*safeZoneH+safeZoneY];
	
	if(count _pos == 4) then {
		_pos set [2, (_pos select 2)*safeZoneW];
		_pos set [3, (_pos select 3)*safeZoneH];
	};

	_ctrl ctrlSetPosition _pos;
};

//========================================================================================
//	Name:	EDITOR_chageGuiSate
//	Desc:	Change gui sate to set size of controls 
//========================================================================================
EDITOR_chageGuiSate = {
	PR(_display) = uiNamespace getVariable 'EDITOR_Disaplay';
	PR(_ctrlView) = _display displayCtrl IDC_EDITOR_VIEW;
	PR(_ctrlCrt)  = _display displayCtrl IDC_EDITOR_CREATED;
	PR(_ctrlPlur) = _display displayCtrl IDC_EDITOR_PLURAL;
	PR(_ctrlClas) = _display displayCtrl IDC_EDITOR_CLASSES;
	PR(_ctrlType) = _display displayCtrl IDC_EDITOR_POSTYPE;

	switch (_this) do {
		case (GUISTATE_VIEW) : {
			[_ctrlType, [0.00, 0.00, 0.15, 0.03 ]] call EDITOR_setCtrlPosition;
			[_ctrlCrt , [0.00, 0.05, 0.15, 0.95 ]] call EDITOR_setCtrlPosition;
			[_ctrlView, [0.15, 0.00, 0.70, 1.00 ]] call EDITOR_setCtrlPosition;
			[_ctrlPlur, [0.85, 0.00, 0.15, 0.245]] call EDITOR_setCtrlPosition;
			[_ctrlClas, [0.85, 0.25, 0.15, 0.75 ]] call EDITOR_setCtrlPosition;
		};
		case (GUISTATE_RIGHT) : {
			[_ctrlType, [0.00, 0.00, 0.20, 0.03 ]] call EDITOR_setCtrlPosition;
			[_ctrlCrt , [0.00, 0.05, 0.20, 0.95 ]] call EDITOR_setCtrlPosition;
			[_ctrlView, [0.20, 0.00, 0.65, 1.00 ]] call EDITOR_setCtrlPosition;
			[_ctrlPlur, [0.85, 0.00, 0.15, 0.245]] call EDITOR_setCtrlPosition;
			[_ctrlClas, [0.85, 0.25, 0.15, 0.75 ]] call EDITOR_setCtrlPosition;
		};
		case (GUISTATE_LEFT) : {
			[_ctrlType, [0.00, 0.00, 0.15, 0.03 ]] call EDITOR_setCtrlPosition;
			[_ctrlCrt , [0.00, 0.05, 0.15, 0.95 ]] call EDITOR_setCtrlPosition;
			[_ctrlView, [0.15, 0.00, 0.65, 1.00 ]] call EDITOR_setCtrlPosition;
			[_ctrlPlur, [0.80, 0.00, 0.20, 0.245]] call EDITOR_setCtrlPosition;
			[_ctrlClas, [0.80, 0.25, 0.20, 0.75 ]] call EDITOR_setCtrlPosition;
		};
	};

	{_x ctrlCommit 0.25;} foreach [_ctrlView,_ctrlCrt,_ctrlPlur,_ctrlClas];
};




//========================================================================================
//	Name:	EDITOR_getPos
//========================================================================================
EDITOR_getPos = {
	switch (EDITOR_PosType) do {
		case POSTYPE_ATL : {
			getPosATL _this;
		};
		case POSTYPE_ASL : {
			getPosASL _this;
		};
	};
};

//========================================================================================
//	Name:	EDITOR_setPos
//========================================================================================
EDITOR_setPos = {
	switch (EDITOR_PosType) do {
		case POSTYPE_ATL : {
			(_this select 0) setPosATL (_this select 1);
		};
		case POSTYPE_ASL : {
			(_this select 0) setPosASL (_this select 1);
		};
	};
};