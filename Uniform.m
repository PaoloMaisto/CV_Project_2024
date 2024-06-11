%% FILTERS FOR UNIFORM NOISE REMOVAL
clc; clear; close all;
addpath('FUNCTIONS\');
addpath('FILTERS\');

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
degree = 0.1:0.1:0.9;          
[m,n] = size(degree);

JJ = I; 

psnr_results = zeros(3,n);
ssim_results = zeros(3,n);

for i = 1:n  

   % Aggiunta di rumore Uniforme con intensità variabile
   [I_uniform, noise] = uniformnoise(JJ, degree(i));  % Get both noise and noisy image
    
    % Filtri per Rumore Uniforme
    im_f_gaussian_uniform = imgaussfilt(I_uniform, 2);  % Filtro Gaussiano
    im_f_median_uniform = medfilt2(I_uniform, [3, 3]);  % Filtro Mediano con finestra 3x3
    im_f_mean_uniform = mean_filter(I_uniform);         % Filtro Mean 

    % Calcolo PSNR e SSIM per ciascun filtro
    psnr_gaussian = calculate_psnr_uniform(JJ, im_f_gaussian_uniform);
    ssim_gaussian = calculate_ssim_uniform(JJ, im_f_gaussian_uniform);
    psnr_median   = calculate_psnr_uniform(JJ, im_f_median_uniform);
    ssim_median   = calculate_ssim_uniform(JJ, im_f_median_uniform);
    psnr_mean     = calculate_psnr_uniform(JJ, im_f_mean_uniform);
    ssim_mean     = calculate_ssim_uniform(JJ, im_f_mean_uniform);

    psnr_results(:,i) = [psnr_gaussian psnr_median psnr_mean]';  
    ssim_results(:,i) = [ssim_gaussian ssim_median ssim_mean]';  
    
    figure();
    subplot(2,3,1); imshow(JJ,[]); title('Original');
    subplot(2,3,2); imshow(I_uniform,[]); title(['Noisy Uniform, Degree = ', num2str(degree(i))]);
    subplot(2,3,4); imshow(im_f_gaussian_uniform,[]); title(['Gaussian Filter, PSNR: ', num2str(psnr_gaussian), ' dB, SSIM: ', num2str(ssim_gaussian)]);
    subplot(2,3,5); imshow(im_f_median_uniform,[]); title(['Median Filter, PSNR: ', num2str(psnr_median), ' dB, SSIM: ', num2str(ssim_median)]);
    subplot(2,3,6); imshow(im_f_mean_uniform,[]);  title(['Mean Filter, PSNR: ', num2str(psnr_mean), ' dB, SSIM: ', num2str(ssim_mean)]);

    % Plots istogrammi
    figure();
    subplot(2,3,1); imhist(JJ);        title('Original');
    subplot(2,3,2); imhist(I_uniform); title(['Noisy Uniform, Degree = ', num2str(degree(i))]);
    subplot(2,3,3); imhist(noise);     title('Noise');    
    subplot(2,3,4); imhist(im_f_gaussian_uniform); title('Gaussian Filter');
    subplot(2,3,5); imhist(im_f_median_uniform);   title('Median Filter');
    subplot(2,3,6); imhist(im_f_mean_uniform);     title('Mean Filter');
   
end

% figure();
% imhist(noise);     
% title('Uniform Noise Histogram');
% saveas(gcf, ['Uniform_Noise_Histogram','.pdf']);

plot_PSNR_Uniform(degree, psnr_results);

plot_SSIM_Uniform(degree, ssim_results);
