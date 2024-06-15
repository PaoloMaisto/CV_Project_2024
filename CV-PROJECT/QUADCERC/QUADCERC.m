% Dimensione dell'immagine
rows = 512;
cols = 512;

% Creare un'immagine nera
mask = zeros(rows, cols);

% Centrare il cerchio
center = [rows / 2, cols / 2];
radius = 100;

% Creare il cerchio bianco al centro
[xx, yy] = ndgrid((1:rows) - center(1), (1:cols) - center(2));
circle_mask = (xx.^2 + yy.^2) < radius^2;
mask(circle_mask) = 0.85; % Bianco per il cerchio

% Creare il quadrato grigio attorno al cerchio
% Aumentare la dimensione del lato del quadrato
square_side = 3.8 * radius;
half_square_side = square_side / 2;
square_mask = abs(xx) <= half_square_side & abs(yy) <= half_square_side;
mask(square_mask & ~circle_mask) = 0.5; % Grigio per il quadrato

% Visualizzare l'immagine
imshow(mask, []);

% Salvare l'immagine in formato .mat
save('quad.mat', 'mask');
