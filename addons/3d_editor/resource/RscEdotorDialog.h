#define IDD_EDITOR_DISPLAY 88800
#define IDC_EDITOR_NOTICE  88801
#define IDC_EDITOR_PLURAL  88802
#define IDC_EDITOR_CLASSES 88803
#define IDC_EDITOR_VIEW    88804
#define IDC_EDITOR_SELECT  88805
#define IDC_EDITOR_CREATED 88806
#define IDC_EDITOR_POSTYPE 88807

class RscText;
class RscStructuredText;
class RscListbox;
class RscButton;

class RscEditor3D {
	idd 		= IDD_EDITOR_DISPLAY;
	onLoad 		= "['init',_this] call EDITOR_fnc_HandlerDisplay";
	onUnload 	= "['close',_this] call EDITOR_fnc_HandlerDisplay";
	class controls {
		class Info: RscText //unused h=0
		{
			idc = IDC_EDITOR_NOTICE;

			x 	= 0.20 * safezoneW + safezoneX;
			y 	= 0.00 * safezoneH + safezoneY;
			w 	= 0.60 * safezoneW;
			h 	= 0.00 * safezoneH;

			colorBackground[] = {0,0,0,0.1};
		};
		class Plural: RscListbox
		{
			idc = IDC_EDITOR_PLURAL;

			x = 0.85 * safeZoneW+safeZoneX;
			y = 0.00 * safeZoneH+safeZoneY;
			w = 0.15 * safeZoneW;
			h = 0.245 * safeZoneH;

			size 	= 0.025;
			sizeEx 	= 0.025;
			canDrag = 0;
			
			onLBSelChanged = "['Plural_lb_changed',_this] call EDITOR_fnc_HandlerControl;";
			onMouseMoving = "['Plural_mouseMoving', _this] call EDITOR_fnc_HandlerControl;";
		};
		class Classes: RscListbox
		{
			idc = IDC_EDITOR_CLASSES;

			x = 0.85 * safeZoneW+safeZoneX;
			y = 0.25 * safeZoneH+safeZoneY;
			w = 0.15 * safeZoneW;
			h = 0.75 * safeZoneH;

			size 	= 0.025;
			sizeEx 	= 0.025;
			canDrag = 1;
			
			onMouseMoving = "['classes_mouseMoving', _this] call EDITOR_fnc_HandlerControl;";
			// onLBSelChanged = "['objFiltered_LBSelChanged',_this] call EDITOR_fnc_HandlerControl;";
			// onKeyDown 	   = "['objFiltered_keyDown',_this] call EDITOR_fnc_HandlerControl;";
			// onKeyUp 	   = "['objFiltered_keyUp',_this] call EDITOR_fnc_HandlerControl;";
			// onLBDrag 	   = "['objFiltered_onLBDrag', _this] call EDITOR_fnc_HandlerControl;";
			// onLBDragging   = "['objFiltered_onLBDragging', _this] call EDITOR_fnc_HandlerControl;";
			// onLBDrop 	   = "['objFiltered_onLBDrop', _this] call EDITOR_fnc_HandlerControl;";
		};
		class View: RscListbox
		{
			idc = IDC_EDITOR_VIEW;

			x 	= 0.00 * safezoneW + safezoneX;
			y 	= 0.00 * safezoneH + safezoneY;
			w 	= 0.80 * safezoneW;
			h 	= 1.00 * safezoneH;

			colorBackground[] = {1,1,1,0};

			onLBDrop 		  = "['view_lbDrop', _this] call EDITOR_fnc_HandlerControl;";
			onMouseMoving 	  = "['view_mouseMoving', _this] call EDITOR_fnc_HandlerControl;";
			onMouseButtonDown = "['view_mouseButtonDown', _this] call EDITOR_fnc_HandlerControl;";
			onMouseButtonUp   = "['view_mouseButtonUp', _this] call EDITOR_fnc_HandlerControl;";
		};
		class Select: RscText //unused
		{
			idc = IDC_EDITOR_SELECT;

			x 	= 0.00;
			y 	= 0.00;
			w 	= 0.00;
			h 	= 0.00;

			colorBackground[] = {1,0.5,0.0,0.2};
		};
		class CreatedClasses: RscListbox
		{
			idc = IDC_EDITOR_CREATED;

			x = 0.00 * safeZoneW+safeZoneX;
			y = 0.05 * safeZoneH+safeZoneY;
			w = 0.15 * safeZoneW;
			h = 0.95 * safeZoneH;

			size 	= 0.025;
			sizeEx 	= 0.025;
			canDrag = 1;

			onMouseMoving 	  = "['Created_MouseMoving', _this] call EDITOR_fnc_HandlerControl;";

		};
		class ButtonPosType: RscButton
		{
			idc = IDC_EDITOR_POSTYPE;

			x = 0.00 * safeZoneW+safeZoneX;
			y = 0.01 * safeZoneH+safeZoneY;
			w = 0.15 * safeZoneW;
			h = 0.03 * safeZoneH;

			text = "ATL";

			colorBackground[] = {0,0,0,0};

			action = "['PosType_buttonType',_this] call EDITOR_fnc_HandlerControl;";
		};
	};
};