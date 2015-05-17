/*
 	Name: EDITOR_Precompile
 	
 	Author(s):
		Ezhuk

	Description:
		Parsing classes from cfgVehicle
		Run in preinit

	TODO:
		1. Blacklist
*/	
#include "defines.sqf"

//------------------------------------------------------
//			Compile Functions
//------------------------------------------------------
call compile preprocessFile "3d_editor\functions\fn_Common.sqf";

//------------------------------------------------------
//			Parsing cfgVehicle
//------------------------------------------------------
PR(_vehs) = configFile >> "CfgVehicles";
PR(_array_plural) = [];
PR(_array_class) = [];

PR(_blackList) = [	"NVG_TargetC",
					"NVG_TargetE",
					"NVG_TargetB",
					"NVG_TargetW",
					"FireSectorTarget",
					"CamoNet_BLUFOR_big_Curator_F",
					"CamoNet_INDP_big_Curator_F",
					"CamoNet_OPFOR_big_Curator_F",
					"CamoNet_BLUFOR_open_Curator_F",
					"CamoNet_INDP_open_Curator_F",
					"CamoNet_OPFOR_open_Curator_F",
					"CamoNet_BLUFOR_Curator_F",
					"CamoNet_INDP_Curator_F",
					"CamoNet_OPFOR_Curator_F",
					"Lightning1_F",
					"Lightning2_F",
					"ACamp_EP1",
					"AmmoCrate_NoInteractive_",
					"AmmoCrates_NoInteractive_Large",
					"AmmoCrates_NoInteractive_Small",
					"CampEast_EP1",
					"Fort_Barricade_EP1",
					"GraveCross2_EP1",
					"GraveCrossHelmet_EP1",
					"GunrackTK_EP1",
					"GunrackUS_EP1",
					"Gunrack2",
					"Hedgehog_EP1",
					"Lightning_F",
					"Lightning1_F",
					"Lightning2_F",
					"UserTexture_1x2_F",
					"UserTexture1m_F",
					"UserTexture10m_F",
					"Land_Bridge_01_PathLod_F",
					"Land_Bridge_Asphalt_PathLod_F",
					"Land_Bridge_Concrete_PathLod_F",
					"Land_Bridge_HighWay_PathLod_F",
					"Library_WeaponHolder",
					"Misc_Backpackheap_EP1",
					"Land_ClutterCutter_small_F",
					"Land_ClutterCutter_medium_F",
					"Land_ClutterCutter_large_F",
					"test_EmptyObjectForSmoke",
					"WeaponHolderSimulated",
					"TransparentWall",
					"HMMWVWreck",
					"Platform",
					"NVG_TargetG",
					"Laser_Target_C",
					"Laser_Target_CBase",
					"Laser_Target_E",
					"Laser_Target_EBase",
					"Laser_Target_W",
					"Laser_Target_WBase",
					"AmmoCrates_NoInteractive_Medium",
					"Pound_ACR",
					"USMC_WarfareBAircraftFactoryPreview",
					"USMC_WarfareBAntiAirRadarPreview",
					"USMC_WarfareBArtilleryRadarPreview",
					"USMC_WarfareBBarracksPreview",
					"USMC_WarfareBHeavyFactoryPreview",
					"USMC_WarfareBLightFactoryPreview",
					"USMC_WarfareBUAVterminalPreview",
					"USMC_WarfareBVehicleServicePointPreview",
					"TK_GUE_WarfareBAircraftFactory_Base_EP1",
					"TK_GUE_WarfareBAntiAirRadar_Base_EP1",
					"TK_GUE_WarfareBArtilleryRadar_Base_EP1",
					"TK_GUE_WarfareBBarracks_Base_EP1",
					"TK_GUE_WarfareBLightFactory_base_EP1",
					"TK_GUE_WarfareBUAVterminal_Base_EP1",
					"TK_GUE_WarfareBVehicleServicePoint_Base_EP1",
					"TK_WarfareBAircraftFactory_Base_EP1",
					"TK_WarfareBAntiAirRadar_Base_EP1",
					"TK_WarfareBArtilleryRadar_Base_EP1",
					"TK_WarfareBBarracks_Base_EP1",
					"TK_WarfareBLightFactory_base_EP1",
					"TK_WarfareBHeavyFactory_Base_EP1",
					"TK_WarfareBUAVterminal_Base_EP1",
					"TK_WarfareBVehicleServicePoint_Base_EP1",
					"TargetSector02_ACR",
					"TargetSector03_ACR",
					"TargetSector04_ACR",
					"TargetSector05_ACR",
					"TargetCenter_ACR",
					"StaticCannon_Preview",
					"ProtectionZone_Ep1",
					"MiniTripod_Preview",
					"US_WarfareBAntiAirRadar_Base_EP1",
					"US_WarfareBArtilleryRadar_Base_EP1",
					"US_WarfareBBarracks_Base_EP1",
					"US_WarfareBHeavyFactory_Base_EP1",
					"US_WarfareBLightFactory_base_EP1",
					"US_WarfareBUAVterminal_Base_EP1",
					"US_WarfareBVehicleServicePoint_Base_EP1",
					"Pond_ACR",
					"M1130_HQ_unfolded_EP1",
					"M1130_HQ_unfolded_Base_EP1",
					"LAV25_HQ_unfolded",
					"C130J_wreck_EP1",
					"C130J_static_EP1",
					"BMP2_HQ_CDF_unfolded",
					"BMP2_HQ_INS_unfolded",
					"BMP2_HQ_TK_unfolded_Base_EP1",
					"BMP2_HQ_TK_unfolded_EP1",
					"BRDM2_HQ_Gue_unfolded",
					"BRDM2_HQ_TK_GUE_unfolded_Base_EP1",
					"BRDM2_HQ_TK_GUE_unfolded_EP1",
					"BTR90_HQ_unfolded",
					"TK_WarfareBFieldhHospital_EP1",
					"",
					"",
					"",
					"",
					"",
					"",
					"",
					"",
					"",
					"",
					""
				];

diag_log format ["1: %1", count _vehs];
PR(_startTime) = diag_tickTime;
for "_i" from 0 to (count _vehs - 1) do 
{
	PR(_objCfg) = (configFile >> "CfgVehicles") select _i;
	if (isClass(_objCfg)) then 
	{
		PR(_className) = configName (_objCfg);
		if (getNumber (_objCfg >> "scope") > 0 && 
			{!(_className in _blackList)} && 
			{!(["preview",str(_className)] call BIS_fnc_inString)} 
			) then 
		{
			PR(_model) = getText (configFile >> "CfgVehicles" >> _className >> "model");
			if(_model != "" && _model != "\A3\Weapons_f\empty" && _model != "bmp") then 
			{
				if (!(_className isKindOf "Logic") && 
					!(_className isKindOf "Man") &&
					!(_className isKindOf "ReammoBox") && 
					!(_className isKindOf "ReammoBox_F") && 
					!(_className isKindOf "AllVehicles")) then 
				{
					if(getNumber(configFile >> "CfgVehicles" >> _className >> "isbackpack") == 0) then 
					{
						if ((getText (configFile >> "CfgVehicles" >> _className >> "vehicleClass")) != "mines") then 
						{
							PR(_vehPlural) = getText(configFile >> "CfgVehicles" >> _className >> "TextPlural");

							if !(_vehPlural in _array_plural) then 
							{
								_array_plural = _array_plural + [_vehPlural];
								_array_class  = _array_class  + [[]];
							};
							
							// Add class to plural array
							PR(_ind) = _array_plural find _vehPlural;
							PR(_tmp) = _array_class select _ind;
							_tmp = _tmp + [_className];
							_array_class set [_ind, _tmp];
						};
					};
				};
			};
		};
	};
};

//------------------------------------------------------
//			Write information in .rpt
//------------------------------------------------------
diag_log "================= EDITOR =====================";
diag_log format ["Parsing finished - %1", round (diag_tickTime - _startTime)];
for "_i" from 0 to (count _array_plural - 1) do 
{
	diag_log format ["%2   ---   %1", _array_plural select _i, count (_array_class select _i)];
};
diag_log "==============================================";

//------------------------------------------------------
//			Init variables 
//------------------------------------------------------
if (isNil "EDITOR_Created") then {
	EDITOR_Created = [];
};
EDITOR_VehicleClasses = _array_plural;
EDITOR_Vehicles = _array_class;
EDITOR_Selected = [];
EDITOR_RotateCenter = [];

EDITOR_Load_Last = false;
EDITOR_Last_Plural = 0;

//------------------------------------------------------
// 							Client part
//------------------------------------------------------
if(!isDedicated) then {
	[] spawn {
		sleep 0.01;

		waitUntil{!isNil {player}};
		waitUntil{local player};

		player addAction ["<t color='#0353f5'>Editor</t>", EDITOR_fnc_OpenDialog, [], 10, true, true, '', 'true'];
		player addEventHandler ["Respawn", {
			player addAction ["<t color='#0353f5'>Editor</t>", EDITOR_fnc_OpenDialog, [], 10, true, true, '', 'true'];
		}];

		Editor_DrawEvent = addMissionEventHandler ["Draw3D", "call EDITOR_fnc_Draw3D"];
	};
};










/*

?	2. Информация 
?	3. Избранные
!	5. выделенные классы

*/