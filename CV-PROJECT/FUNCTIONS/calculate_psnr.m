function psnr_value = calculate_psnr(U, V)
    U = double(U);
    V = double(V);
    mse = mean((U(:) - V(:)).^2,'all');
    max_pixel_value = 255;  % Massimo valore di pixel per immagini a 8 bit
    psnr_value = 10 * log10((max_pixel_value^2) / mse);
end

