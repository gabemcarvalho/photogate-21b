/// @description Clean up room
if surface_exists(wisp_trail) surface_free(wisp_trail);
if surface_exists(surf_preblur) surface_free(surf_preblur);
if surface_exists(surf_hblur) surface_free(surf_hblur);
if surface_exists(surf_vblur) surface_free(surf_vblur);
if surface_exists(surf_light) surface_free(surf_light);
if surface_exists(surf_block) surface_free(surf_block);
if surface_exists(surf_gui) surface_free(surf_gui);
if surface_exists(surf_hud) surface_free(surf_hud);
if surface_exists(surf_trans) surface_free(surf_trans);
if surface_exists(surf_shader) surface_free(surf_shader);
if surface_exists(surf_pixel_manipulation) surface_free(surf_pixel_manipulation);
if surface_exists(surf_lightgen_1) surface_free(surf_lightgen_1);
if surface_exists(surf_lightgen_2) surface_free(surf_lightgen_2);
if surface_exists(surf_outline) surface_free(surf_outline);

if instance_exists(o_asset_layers) {
	if surface_exists(surf_assets_light_front) surface_free(surf_assets_light_front);
	if surface_exists(surf_assets_light) surface_free(surf_assets_light);
	if surface_exists(surf_assets_light_back) surface_free(surf_assets_light_back);
	if surface_exists(surf_assets_dark) surface_free(surf_assets_dark);
	if surface_exists(surf_assets_dark_back) surface_free(surf_assets_dark_back);
}

part_particles_clear(global.p_sys);

ds_list_destroy(trail_list);
ds_list_destroy(flashing_mirrors);