%% FILTERS FOR UNIFORM NOISE REMOVAL
clc; clear; close all;
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

%% IMPLEMENTATION OF NOISE AND FILTERS
degree = 0.1:0.1:0.9;          
varianza = 0.01:0.01:0.09;

JJ = I;                         % Salva l'immagine originale I nella variabile JJ per preservarla durante le modifiche successive nel ciclo. JJ sarà usata come riferimento di partenza per aggiungere il rumore in ogni iterazione del ciclo

for i = 1:9  % ciclo che eseguirà 9 iterazioni, una per ogni valore nel vettore degree.
   
    % Aggiunta di rumore Uniforme con intensità variabile
    [I_uniform, noise] = uniformnoise(JJ, degree(i));  % Get both noise and noisy image
    
    % Filtri per Rumore Uniforme
    im_f_median_uniform = medfilt2(I_uniform, [5, 5]);              % Filtro Mediano con finestra 5x5
    im_f_wiener_uniform = wiener2(I_uniform, [5, 5]);               % Filtro Wiener con finestra 5x5
    im_f_nlm_uniform = imnlmfilt(I_uniform);                        % Filtro Non-Local Means
    
    % Visualizza le immagini con Rumore Uniforme
    figure;
    subplot(2,3,1); imshow(JJ,[]); title('Original');
    subplot(2,3,2); imshow(I_uniform,[]); title(['Noisy Uniform, Degree = ', num2str(degree(i))]);
    subplot(2,3,4); imshow(im_f_median_uniform,[]); title('Median Filter');
    subplot(2,3,5); imshow(im_f_wiener_uniform,[]); title('Wiener Filter');
    subplot(2,3,6); imshow(im_f_nlm_uniform,[]); title('Non-Local Means Filter');
    
    % Plots istogrammi
    figure;
    subplot(2,4,1); imhist(JJ); title('Original');
    subplot(2,4,2); imhist(I_uniform); title(['Noisy Uniform, Degree = ', num2str(degree(i))]);
    subplot(2,4,3); imhist(noise); title('Noise');
    subplot(2,4,4); imhist(im_f_median_uniform); title('Median Filter');
    subplot(2,4,5); imhist(im_f_wiener_uniform); title('Wiener Filter');
    subplot(2,4,6); imhist(im_f_nlm_uniform); title('Non-Local Means Filter');
    
end
