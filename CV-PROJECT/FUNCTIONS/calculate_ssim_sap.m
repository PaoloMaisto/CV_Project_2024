function ssim_value = calculate_ssim_sap(U, V)
    U = double(U);
    V = double(V);
    [ssim_value, ~] = ssim(U, V,"DynamicRange",250);
end