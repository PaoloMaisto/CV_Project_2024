function outputImage = mean_filter(I)

    % Converte l'immagine in input in double per elaborazione
    I = double(I);
    % Ottiene le dimensioni dell'immagine
    [rows, columns] = size(I);
    % Prealloca l'immagine di output
    outputImage = zeros(size(I));
    % Itera su ogni pixel dell'immagine

    for i = 1:rows
        for j = 1:columns

            rmin = max(1, i-1);
            rmax = min(rows, i+1);
            cmin = max(1, j-1);
            cmax = min(columns, j+1);

            temp = I(rmin:rmax,cmin:cmax);

            outputImage(i,j) = mean(temp(:));
        end
    end
    