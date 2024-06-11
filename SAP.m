%% FILTERS FOR SALT-AND-PEPPER NOISE REMOVAL
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
degree = 0.1 : 0.1 : 0.9;           % Questi valori rappresentano le diverse intensità del rumore "salt-and-pepper" che verranno applicate all'immagine.
[m,n]  = size(degree);

psnr_results = zeros(6,n);
ssim_results = zeros(6,n);

psnr_results_2 = zeros(3,n);
ssim_results_2 = zeros(3,n);

JJ = I;     % Salva l'immagine originale I nella variabile JJ per preservarla durante le modifiche successive nel ciclo. JJ sarà usata come riferimento di partenza per aggiungere il rumore in ogni iterazione del ciclo

for i = 1 : n

    % Aggiunge il rumore "salt-and-pepper" all'immagine originale JJ usando l'intensità specificata da degree(i). Il risultato viene salvato nuovamente in I. Quindi in ogni iterazione, I conterrà l'immagine originale con un livello di rumore differente.
    I_sap = imnoise(JJ, 'salt & pepper', degree(i));        
    noise = I_sap - JJ;

    % Filtri per Rumore salt-and-pepper SALT-AND-PEPPER
    im_f_AMF    = uint8(AMF(I_sap));
    im_f_NAFSMF = NAFSMF(I_sap);
    im_f_AWMF   = uint8(AWMF(I_sap));
    im_f_BPDF   = BPDF(I_sap);
    im_f_DAMF   = DAMF(I_sap);
    im_f_NAMF   = uint8(NAMF(I_sap));

    % Calcolo PSNR e SSIM per ciascun filtro
    psnr_AMF    = calculate_psnr_sap(JJ, im_f_AMF);
    ssim_AMF    = calculate_ssim_sap(JJ, im_f_AMF);
    psnr_NAFSMF = calculate_psnr_sap(JJ, im_f_NAFSMF);
    ssim_NAFSMF = calculate_ssim_sap(JJ, im_f_NAFSMF);
    psnr_AWMF   = calculate_psnr_sap(JJ, im_f_AWMF);
    ssim_AWMF   = calculate_ssim_sap(JJ, im_f_AWMF);
    psnr_BPDF   = calculate_psnr_sap(JJ, im_f_BPDF);
    ssim_BPDF   = calculate_ssim_sap(JJ, im_f_BPDF);
    psnr_DAMF   = calculate_psnr_sap(JJ, im_f_DAMF);
    ssim_DAMF   = calculate_ssim_sap(JJ, im_f_DAMF);
    psnr_NAMF   = calculate_psnr_sap(JJ, im_f_NAMF);
    ssim_NAMF   = calculate_ssim_sap(JJ, im_f_NAMF);
    
    psnr_results(:,i) = [psnr_AMF psnr_NAFSMF psnr_AWMF psnr_BPDF psnr_DAMF psnr_NAMF]';
    ssim_results(:,i) = [ssim_AMF ssim_NAFSMF ssim_AWMF ssim_BPDF ssim_DAMF ssim_NAMF]';

    figure;
    subplot(3,3,1);     imshow(JJ,[]);          title('Original');
    subplot(3,3,2);     imshow(I_sap,[]);       title(['Noisy, Density = ', num2str(degree(i))]);
    subplot(3,3,4);     imshow(im_f_AMF,[]);    title(['AMF, PSNR: ', num2str(psnr_AMF), ' dB, SSIM: ', num2str(ssim_AMF)]);
    subplot(3,3,5);     imshow(im_f_NAFSMF,[]); title(['NAFSMF, PSNR: ', num2str(psnr_NAFSMF), ' dB, SSIM: ', num2str(ssim_NAFSMF)]);
    subplot(3,3,6);     imshow(im_f_AWMF,[]);   title(['AWMF, PSNR: ', num2str(psnr_AWMF), ' dB, SSIM: ', num2str(ssim_AWMF)]);
    subplot(3,3,7);     imshow(im_f_BPDF,[]);   title(['BPDF, PSNR: ', num2str(psnr_BPDF), ' dB, SSIM: ', num2str(ssim_BPDF)]);
    subplot(3,3,8);     imshow(im_f_DAMF,[]);   title(['DAMF, PSNR: ', num2str(psnr_DAMF), ' dB,SSIM: ', num2str(ssim_DAMF)]);
    subplot(3,3,9);     imshow(im_f_NAMF,[]);   title(['NAMF, PSNR: ', num2str(psnr_NAMF), ' dB, SSIM: ', num2str(ssim_NAMF)]);

    % Plots istogrammi
    figure();
    subplot(3,3,1);     imhist(JJ);          title('Original');
    subplot(3,3,2);     imhist(I_sap);       title(['Noisy SAP, Degree = ', num2str(degree(i))]);
    subplot(3,3,4);     imhist(im_f_AMF);    title('AMF');
    subplot(3,3,5);     imhist(im_f_NAFSMF); title('NAFSMF');
    subplot(3,3,6);     imhist(im_f_AWMF);   title('AWMF');
    subplot(3,3,7);     imhist(im_f_BPDF);   title('BPDF');
    subplot(3,3,8);     imhist(im_f_DAMF);   title('DAMF');
    subplot(3,3,9);     imhist(im_f_NAMF);   title('NAMF');

%% APPLICAZIONE FILTRI STUDIATI DURANTE I CORSI: GAUSSIAN MEDIAN, MEAN
    % Filtri per Rumore Esponenziale
    im_f_gaussian_sap   = imgaussfilt(I_sap, 2);    % Filtro Gaussiano con deviazione standard di 2
    im_f_median_sap     = medfilt2(I_sap, [3,3]);   % Filtro Mediano con finestra 3x3
    im_f_mean_sap       = uint8(mean_filter(I_sap));       % Filtro Medio

    % Calcolo PSNR e SSIM per ciascun filtro
    psnr_gaussian = calculate_psnr_sap(JJ, im_f_gaussian_sap);
    ssim_gaussian = calculate_ssim_sap(JJ, im_f_gaussian_sap);
    psnr_median   = calculate_psnr_sap(JJ, im_f_median_sap);
    ssim_median   = calculate_ssim_sap(JJ, im_f_median_sap);
    psnr_mean     = calculate_psnr_sap(JJ, im_f_mean_sap);
    ssim_mean     = calculate_ssim_sap(JJ, im_f_mean_sap);

    psnr_results_2(:,i) = [psnr_gaussian psnr_median psnr_mean]';
    ssim_results_2(:,i) = [ssim_gaussian ssim_median ssim_mean]';

    % Visualizza le immagini con Rumore Esponenziale
    figure();
    subplot(2,3,1); imshow(JJ); title('Original');
    subplot(2,3,2); imshow(I_sap);              title(['Noisy sap, Degree = ', num2str(degree(i))]);
    subplot(2,3,4); imshow(im_f_gaussian_sap);  title('Gaussian Filter'); title(['Gaussian Filter, PSNR: ', num2str(psnr_gaussian), ' dB, SSIM: ', num2str(ssim_gaussian)]);
    subplot(2,3,5); imshow(im_f_median_sap);    title(['Median Filter, PSNR: ', num2str(psnr_median), ' dB, SSIM: ', num2str(ssim_median)]);
    subplot(2,3,6); imshow(im_f_mean_sap);      title(['Mean Filter, PSNR: ', num2str(psnr_mean), ' dB, SSIM: ', num2str(ssim_mean)]);
   
    % Plots istogrammi
    figure();
    subplot(2,3,1);     imhist(JJ);                 title('Original');
    subplot(2,3,2);     imhist(I_sap);              title(['Noisy SAP, Degree = ', num2str(degree(i))]);
    subplot(2,3,3);     imhist(noise);              title('SAP Noise');
    subplot(2,3,4);     imhist(im_f_gaussian_sap);  title('Gaussian Filter');
    subplot(2,3,5);     imhist(im_f_median_sap);    title('Median Filter');
    subplot(2,3,6);     imhist(im_f_mean_sap);      title('Mean Filter');

end

figure();
imhist(noise);     
title('SALT-AND-PEPPER Noise Histogram');
saveas(gcf, ['SAP_noise_Histogram','.pdf']);

plot_PSNR_SAP(degree, psnr_results);
plot_SSIM_SAP(degree, ssim_results);

plot_PSNR_SAP_2(degree, psnr_results_2);
plot_SSIM_SAP_2(degree, ssim_results_2);