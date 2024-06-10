%% FILTERS FOR GAUSSIAN NOISE REMOVAL
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
mu = 0; % media
mean = 0;
JJ = I; % Salva l'immagine originale I nella variabile JJ per preservarla durante le modifiche successive nel ciclo. JJ sarà usata come riferimento di partenza per aggiungere il rumore in ogni iterazione del ciclo

psnr_results = zeros(3,n);
ssim_results = zeros(3,n);

for i = 1 : n % inizia un ciclo for che eseguirà 9 iterazioni, una per ogni valore nel vettore degree.

    % Aggiungi rumore Gaussiano
    I_gaussian = imnoise(JJ, 'gaussian', mu, variance(i)); % Aggiunge il rumore gaussiano all'immagine originale JJ usando l'intensità specificata da degree(i).

    %  noise = I_gaussian - JJ;  % NON FUNZIONA serve per l'istogramma del rumore

    % Clipping per mantenere i valori dei pixel nell'intervallo corretto
    I_gaussian = max(min(I_gaussian, 255), 0);

    % Filtri per Rumore Gaussiano
    im_f_gaussian = uint8(imgaussfilt(I_gaussian, 2));     % Filtro Gaussiano con deviazione standard di 2
    im_f_median   = uint8(medfilt2(I_gaussian));           % Filtro Mediano con finestra 5x5
    im_f_amf      = uint8(AMF(I_gaussian));                % Filtro AMF con finestra 5x5

    % Calcolo PSNR e SSIM per ciascun filtro
    psnr_gaussian = calculate_psnr(JJ, im_f_gaussian);
    ssim_gaussian = calculate_ssim(JJ, im_f_gaussian);

    psnr_median = calculate_psnr(JJ, im_f_median);
    ssim_median = calculate_ssim(JJ, im_f_median);

    psnr_amf = calculate_psnr(JJ, im_f_amf);
    ssim_amf = calculate_ssim(JJ, im_f_amf);

    psnr_results(:,i) = [psnr_gaussian psnr_median psnr_amf];
    ssim_results(:,i) = [ssim_gaussian ssim_median ssim_amf];

    figure();
    subplot(2,3,1); imshow(JJ,[]); title('Original');
    subplot(2,3,2); imshow(I_gaussian,[]); title(['Noisy Gaussian, \sigma = ', num2str(variance(i))]);
    subplot(2,3,3); imshow(im_f_gaussian,[]); title(['Gaussian Filter, PSNR: ', num2str(psnr_gaussian), ' dB, SSIM: ', num2str(ssim_gaussian)]);
    subplot(2,3,4); imshow(im_f_median,[]); title(['Median Filter, PSNR: ', num2str(psnr_median), ' dB, SSIM: ', num2str(ssim_median)]);
    subplot(2,3,5); imshow(im_f_amf,[]); title(['Adaptive Median Filter, PSNR: ', num2str(psnr_amf), ' dB, SSIM: ', num2str(ssim_amf)]);

    % Plots istogrammi
    figure();
    subplot(2,3,1); imhist(JJ); title('Original');
    subplot(2,3,2); imhist(I_gaussian); title(['Noisy Gaussian, Variance = ', num2str(variance(i))]);
   %subplot(2,3,3); imhist(noise); title('Gaussian Noise'); %% NON FUNZIONA
    subplot(2,3,4); imhist(im_f_gaussian); title('Gaussian Filter');
    subplot(2,3,5); imhist(im_f_median); title('Median Filter');
    subplot(2,3,6); imhist(im_f_amf); title('Adaptive Median Filter');
end

plot_PSNR_Gaussian(variance, psnr_results);

plot_SSIM_Gaussian(variance, ssim_results);
