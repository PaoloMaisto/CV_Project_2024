%% RAYLEIGH NOISE
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
%I = imread('PICTURES/data/img512/Barbara.bmp'); % quello originale
% I = imread('PICTURES/data/img512/elaine512.png');
% I = imread('PICTURES/data/img512/goldhill.bmp');
% I = imread('PICTURES/data/img512/man.tiff');
% I = imread('PICTURES/data/img512/peppers.bpm');
% I = imread('PICTURES/data/img512/yacht.bpm');
% I = imread('PICTURES/data/img512/zelda.tif');

%% Rumore di Rayleigh
JJ = I; % Salva l'immagine originale I nella variabile JJ per preservarla durante le modifiche successive nel ciclo. JJ sarà usata come riferimento di partenza per aggiungere il rumore in ogni iterazione del ciclo

varianza = 0.06:0.01:0.14;
[m,n] = size(varianza);

psnr_results = zeros(3,n);
ssim_results = zeros(3,n);

for i = 1:n  % Ciclo che eseguirà n iterazioni, una per ogni valore in varianza.

    % Aggiunta di rumore di Rayleigh
    noise = raylrnd(varianza(i), size(JJ));  % Calcola il rumore di Rayleigh
    I_rayleigh = im2double(JJ) + noise;     % Aggiunge il rumore di Rayleigh all'immagine

    % Filtri per Rumore di Rayleigh
    im_f_median_rayleigh = medfilt2(I_rayleigh); % Filtro Mediano
    im_f_gaussian_rayleigh = imgaussfilt(I_rayleigh, 2); % Filtro Gaussiano
    im_f_mean_rayleigh = mean_filter(I_rayleigh); % Mean Mediano

    % Calcolo PSNR e SSIM per ciascun filtro
    psnr_median = calculate_psnr_ray(JJ, im_f_median_rayleigh);
    ssim_median = calculate_ssim_ray(JJ, im_f_median_rayleigh);
    psnr_gaussian = calculate_psnr_ray(JJ, im_f_gaussian_rayleigh);
    ssim_gaussian = calculate_ssim_ray(JJ, im_f_gaussian_rayleigh);
    psnr_mean = calculate_psnr_ray(JJ, im_f_mean_rayleigh);
    ssim_mean = calculate_ssim_ray(JJ, im_f_mean_rayleigh);
    psnr_results(:,i) = [psnr_gaussian psnr_median psnr_mean];
    ssim_results(:,i) = [ssim_gaussian ssim_median ssim_mean];

    % Visualizza le immagini e gli istogrammi
    figure();
    subplot(2,3,1); imshow(JJ); title('Original');
    subplot(2,3,2); imshow(I_rayleigh); title(['Noisy Rayleigh, Variance = ', num2str(varianza(i))]);
    subplot(2,3,4); imshow(im_f_gaussian_rayleigh); title(['Gaussian Filter, PSNR: ', num2str(psnr_gaussian), ' dB, SSIM: ', num2str(ssim_gaussian)]);
    subplot(2,3,5); imshow(im_f_median_rayleigh);title(['Median Filter, PSNR: ', num2str(psnr_median), ' dB, SSIM: ', num2str(ssim_median)]);
    subplot(2,3,6); imshow(im_f_mean_rayleigh); title(['Mean Filter, PSNR: ', num2str(psnr_mean), ' dB, SSIM: ', num2str(ssim_mean)]);

    % Visualizza istogrammi, incluso quello del rumore
    figure();
    subplot(2,3,1); imhist(JJ); title('Original');
    subplot(2,3,2); imhist(I_rayleigh); title(['Noisy Rayleigh, Variance = ', num2str(varianza(i))]);
    subplot(2,3,3); imhist(noise); title(['Rayleigh Noise'])
    subplot(2,3,4); imhist(im_f_gaussian_rayleigh); title('Gaussian Filter');
    subplot(2,3,5); imhist(im_f_median_rayleigh); title('Median Filter');
    subplot(2,3,6); imhist(im_f_mean_rayleigh); title('Mean Filter');

    % figure();
    % imhist(noise);
    % title(['Rayleigh Noise Histogram']);
    % 
    % % Salva l'istogramma del rumore di Rayleigh in un file PDF
    % saveas(gcf, ['Rayleigh_Noise_Histogram','.pdf']);
   
end

plot_PSNR_Rayleigh(varianza, psnr_results);
plot_SSIM_Rayleigh(varianza, ssim_results);



