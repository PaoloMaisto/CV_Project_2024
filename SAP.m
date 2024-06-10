%% FILTERS FOR SALT-AND-PEPPER NOISE REMOVAL
clc; clear; close all;
addpath('FILTERS\');
addpath('FUNCTIONS\');

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


%% IMPLEMENTAZIONE DEL RUMORE E DEI FILTRI
degree = 0.1 : 0.1 : 0.9; % Questi valori rappresentano le diverse intensità del rumore "salt-and-pepper" che verranno applicate all'immagine.
[m,n] = size(degree);

psnr_results = zeros(6,n);
ssim_results = zeros(6,n);

JJ = I; % Salva l'immagine originale I nella variabile JJ per preservarla durante le modifiche successive nel ciclo. JJ sarà usata come riferimento di partenza per aggiungere il rumore in ogni iterazione del ciclo

for i = 1 : n % Ciclo per ogni livello di intensità di rumore
    I = imnoise(JJ, 'salt & pepper', degree(i)); % Aggiunge il rumore "salt-and-pepper" all'immagine originale JJ usando l'intensità specificata da degree(i). Il risultato viene salvato nuovamente in I. Quindi in ogni iterazione, I conterrà l'immagine originale con un livello di rumore differente.

    % Applicazione dei filtri
    im_f_AMF = AMF(I);
    im_f_NAFSMF = NAFSMF(I);
    im_f_AWMF = AWMF(I);
    im_f_BPDF = BPDF(I);
    im_f_DAMF = DAMF(I);
    im_f_NAMF = NAMF(I);

    % Calcolo PSNR e SSIM per ciascun filtro
    psnr_AMF = calculate_psnr(JJ, im_f_AMF);
    ssim_AMF = calculate_ssim(JJ, im_f_AMF);
    psnr_NAFSMF = calculate_psnr(JJ, im_f_NAFSMF);
    ssim_NAFSMF = calculate_ssim(JJ, im_f_NAFSMF);
    psnr_AWMF = calculate_psnr(JJ, im_f_AWMF);
    ssim_AWMF = calculate_ssim(JJ, im_f_AWMF);
    psnr_BPDF = calculate_psnr(JJ, im_f_BPDF);
    ssim_BPDF = calculate_ssim(JJ, im_f_BPDF);
    psnr_DAMF = calculate_psnr(JJ, im_f_DAMF);
    ssim_DAMF = calculate_ssim(JJ, im_f_DAMF);
    psnr_NAMF = calculate_psnr(JJ, im_f_NAMF);
    ssim_NAMF = calculate_ssim(JJ, im_f_NAMF);
    
    psnr_results(:,i) = [psnr_AMF psnr_NAFSMF psnr_AWMF psnr_BPDF psnr_DAMF psnr_NAMF]';
    ssim_results(:,i) = [ssim_AMF ssim_NAFSMF ssim_AWMF ssim_BPDF ssim_DAMF ssim_NAMF]';

    figure;
    subplot(3,3,1); imshow(JJ,[]); title('Original');
    subplot(3,3,3); imshow(I,[]); title(['Noisy, Density = ', num2str(degree(i))]);
    subplot(3,3,4); imshow(im_f_AMF,[]); title(['AMF, PSNR: ', num2str(psnr_AMF), ' dB, SSIM: ', num2str(ssim_AMF)]);
    subplot(3,3,5); imshow(im_f_NAFSMF,[]); title(['NAFSMF, PSNR: ', num2str(psnr_NAFSMF), ' dB, SSIM: ', num2str(ssim_NAFSMF)]);
    subplot(3,3,6); imshow(im_f_AWMF,[]); title(['AWMF, PSNR: ', num2str(psnr_AWMF), ' dB, SSIM: ', num2str(ssim_AWMF)]);
    subplot(3,3,7); imshow(im_f_BPDF,[]); title(['BPDF, PSNR: ', num2str(psnr_BPDF), ' dB, SSIM: ', num2str(ssim_BPDF)]);
    subplot(3,3,8); imshow(im_f_DAMF,[]); title(['DAMF, PSNR: ', num2str(psnr_DAMF), ' dB,SSIM: ', num2str(ssim_DAMF)]);
    subplot(3,3,9); imshow(im_f_NAMF,[]); title(['NAMF, PSNR: ', num2str(psnr_NAMF), ' dB, SSIM: ', num2str(ssim_NAMF)]);

end

plotPSNRResultsSAP(degree, psnr_results);

plotSSIMResultsSAP(degree, ssim_results);