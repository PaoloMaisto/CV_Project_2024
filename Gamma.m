%% FILTERS FOR GAMMA NOISE REMOVAL
clc; clear; close all;
addpath('FILTERS\');
addpath('FUNCTIONS\');

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
I = lena;
% I = imread('PICTURES/data/img512/Barbara.bmp'); % quello originale
% I = imread('PICTURES/data/img512/elaine512.png');
% I = imread('PICTURES/data/img512/goldhill.bmp');
% I = imread('PICTURES/data/img512/man.tiff');
% I = imread('PICTURES/data/img512/peppers.bpm');
% I = imread('PICTURES/data/img512/yacht.bpm');
% I = imread('PICTURES/data/img512/zelda.tif');

%% IMPLEMENTATION OF NOISE AND FILTERS
variance = 0.01:0.01:0.09;
[m,n] = size(variance);

JJ = I;  % Salva l'immagine originale I nella variabile JJ per preservarla durante le modifiche successive nel ciclo. JJ sarà usata come riferimento di partenza per aggiungere il rumore in ogni iterazione del ciclo

psnr_results = zeros(3,n);
ssim_results = zeros(3,n);

for i = 1:n                                               
    % Rumore Gamma
    noise = gamrnd(2, variance(i), size(JJ));
    I_gamma = im2double(JJ) + noise;  % Aggiunge il rumore gamma
    
    % Filtri per Rumore Gamma
    im_f_median_gamma = medfilt2(I_gamma, [5, 5]);            
    im_f_gaussian_gamma = imgaussfilt(I_gamma, [5, 5]);       
    im_f_amf_gamma = AMF(I_gamma);                            
    
    % Calcolo PSNR e SSIM per ciascun filtro
    psnr_median   = calculate_psnr(JJ, im_f_median_gamma);
    ssim_median   = calculate_ssim(JJ, im_f_median_gamma);
    psnr_gaussian = calculate_psnr(JJ, im_f_gaussian_gamma);
    ssim_gaussian = calculate_ssim(JJ, im_f_gaussian_gamma);
    psnr_amf      = calculate_psnr(JJ, im_f_amf_gamma);
    ssim_amf      = calculate_ssim(JJ, im_f_amf_gamma);

    psnr_results(:,i) = [psnr_median psnr_gaussian psnr_amf]';
    ssim_results(:,i) = [ssim_median ssim_gaussian ssim_amf]';

    % Visualizza le immagini con Rumore Gamma
    figure();
    subplot(2,3,1); imshow(JJ); title('Original');
    subplot(2,3,2); imshow(I_gamma); title(['Noisy Exponential, Degree = ', num2str(variance(i))]);
    subplot(2,3,4); imshow(I_gamma); title('Gaussian Filter'); title(['Gaussian Filter, PSNR: ', num2str(psnr_gaussian), ' dB, SSIM: ', num2str(ssim_gaussian)]);
    subplot(2,3,5); imshow(I_gamma); title(['Median Filter, PSNR: ', num2str(psnr_median), ' dB, SSIM: ', num2str(ssim_median)]);
    subplot(2,3,6); imshow(I_gamma); title(['Adaptive Median Filter, PSNR: ', num2str(psnr_amf), ' dB, SSIM: ', num2str(ssim_amf)]);
    
    % Plots istogrammi
    figure();
    subplot(2,3,1); imhist(JJ); title('Original');
    subplot(2,3,2); imhist(I_gamma); title(['Noisy Gamma, Variance = ', num2str(variance(i))]);
    subplot(2,3,3); imhist(noise); title('Gamma Noise');  % Visualizza l'istogramma del solo rumore
    subplot(2,3,4); imhist(im_f_median_gamma); title('Median Filter');
    subplot(2,3,5); imhist(im_f_gaussian_gamma); title('Gaussian Filter');
    subplot(2,3,6); imhist(im_f_amf_gamma); title('Adaptive Median Filter');
end

plot_PSNR_Gamma(variance, psnr_results);
plot_SSIM_Gamma(variance, ssim_results);