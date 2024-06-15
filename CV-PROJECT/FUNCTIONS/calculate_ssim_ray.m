function ssim_value = calculate_ssim_ray(U, V)
    U = double(U);
    V = double(V);
    [ssim_value, ~] = ssim(U, V,"DynamicRange",1);
end