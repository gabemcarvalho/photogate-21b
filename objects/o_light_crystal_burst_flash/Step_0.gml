image_xscale += scale_spd;
image_yscale = image_xscale;
scale_spd = max(scale_spd - scale_fric, 0);

image_alpha = max(image_alpha-fade_spd, 0);

if image_alpha <= 0 instance_destroy();