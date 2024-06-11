%% FILTERS FOR EXPONENTIAL NOISE REMOVAL
clc; clear; close all;
addpath('FILTERS\');
addpath('FUNCTIONS\')

%% QUAD.MAT
% load('PICTURES/data/img512/quad.mat');
% I = mask;

%% CAMERAMAN.MAT
% load('PICTURES/data/img256/cameraman.mat'); % quello originale
% I = cameraman;  % quello originale
% I = imread('PICTURES/data/img256/baboon256.bmp');  
% I = imread('PICTURES/data/img256/boat256.bmp');
% I = imread('PICTURES/data/img256/Couple.bmp');  
% I = imread('PICTURES/data/img256/Ceinstein.BMP');
% I = imread('PICTURES/data/img256/face.BMP');
% I = imread('PICTURES/data/img256/house256.bmp');
% I = imread('PICTURES/data/img256/straw.bmp');

%% LENA.MAT
load('PICTURES/data/img512/Lenna.mat');
I = double(lena)/255;
% I = imread('PICTURES/data/img512/Barbara.bmp'); % quello originale
% I = imread('PICTURES/data/img512/elaine512.png');
% I = imread('PICTURES/data/img512/goldhill.bmp');
% I = imread('PICTURES/data/img512/man.tiff');
% I = imread('PICTURES/data/img512/peppers.bpm');
% I = imread('PICTURES/data/img512/yacht.bpm');
% I = imread('PICTURES/data/img512/zelda.tif');

%% IMPLEMENTATION OF NOISE AND FILTERS
variance = 0.06:0.01:0.14;
[m,n] = size(variance);

JJ = I;

psnr_results = zeros(3,n);
ssim_results = zeros(3,n);

for i = 1:n
    % Aggiunta di rumore esponenziale
    noise           = -log(1-rand(size(I))) * variance(i);
    I_exponential   = I + noise;                                    % Aggiungiamo il rumore
    
    % Filtri per Rumore Esponenziale
    im_f_gaussian_exponential   = imgaussfilt(I_exponential, 2);    % Filtro Gaussiano con deviazione standard di 2
    im_f_median_exponential     = medfilt2(I_exponential, [3,3]);   % Filtro Mediano con finestra 3x3
    im_f_mean_exponential      = mean_filter(I_exponential);       % Filtro Medio

    % Calcolo PSNR e SSIM per ciascun filtro
    psnr_gaussian = calculate_psnr_exponential(JJ, im_f_gaussian_exponential);
    ssim_gaussian = calculate_ssim_exponential(JJ, im_f_gaussian_exponential);
    psnr_median   = calculate_psnr_exponential(JJ, im_f_median_exponential);
    ssim_median   = calculate_ssim_exponential(JJ, im_f_median_exponential);
    psnr_mean     = calculate_psnr_exponential(JJ, im_f_mean_exponential);
    ssim_mean     = calculate_ssim_exponential(JJ, im_f_mean_exponential);

    psnr_results(:,i) = [psnr_gaussian psnr_median psnr_mean]';
    ssim_results(:,i) = [ssim_gaussian ssim_median ssim_mean]';

    % Visualizza le immagini con Rumore Esponenziale
    figure();
    subplot(2,3,1); imshow(JJ); title('Original');
    subplot(2,3,2); imshow(I_exponential);              title(['Noisy Exponential, Degree = ', num2str(variance(i))]);
    subplot(2,3,4); imshow(im_f_gaussian_exponential);  title('Gaussian Filter'); title(['Gaussian Filter, PSNR: ', num2str(psnr_gaussian), ' dB, SSIM: ', num2str(ssim_gaussian)]);
    subplot(2,3,5); imshow(im_f_median_exponential);    title(['Median Filter, PSNR: ', num2str(psnr_median), ' dB, SSIM: ', num2str(ssim_median)]);
    subplot(2,3,6); imshow(im_f_mean_exponential);     title(['Mean Filter, PSNR: ', num2str(psnr_mean), ' dB, SSIM: ', num2str(ssim_mean)]);
   
    % Plots istogrammi
    subplot(2,3,1); imhist(JJ); title('Original');
    subplot(2,3,2); imhist(I_exponential);              title(['Noisy Exponential, Degree = ', num2str(variance(i))]);
    subplot(2,3,3); imhist(noise);                      title('Exponential Noise');
    subplot(2,3,4); imhist(im_f_gaussian_exponential);  title('Gaussian Filter');
    subplot(2,3,5); imhist(im_f_median_exponential);    title('Median Filter');
    subplot(2,3,6); imhist(im_f_mean_exponential);     title('Mean Filter');    figure();

end

figure();
imhist(noise);     
title('Exponential Noise Histogram');
saveas(gcf, ['Exponential_noise_Histogram','.pdf']);

plot_PSNR_Exponential(variance, psnr_results);

plot_SSIM_Exponential(variance, ssim_results);