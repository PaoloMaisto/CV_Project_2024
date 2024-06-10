function ssim_value = calculate_ssim_gamma(U, V)
    U = uint8(U);
    V = uint8(V);
    [ssim_value, ~] = ssim(U, V);
end