/*--------------------------------------------------------------------
	Author: nflug (ofpectag: ACRYL)
    File: Config_Plants.hpp
	Modified: Kuchenplatte
	<Acryl-Gaming.de>
    Written by nflug - modified and edited by Kuchenplatte
    You're not allowed to use this file without permission from the author!
--------------------------------------------------------------------*/

class CfgPlants {
	

	plants_nearby = 8;

	not_allowed_objects[] = { "House_F" };
	plant_max = 5;
	near_roads = 15;
	plant_time = 30;
	
	
	class ItemGPS {
		itemGet[] = { "ItemRadio", 2 };
		zones[] = { {"weed_1", 30} };
		phases[] = { "Land_TreeBin_F", "Land_Hedge_01_s_2m_F", "Land_Hedge_01_s_4m_F" };
		phase_time[] = { 20, 30 };
		marker_color = "ColorGreen";
		marker_type = "mil_dot";
	};
	
	
	
};
