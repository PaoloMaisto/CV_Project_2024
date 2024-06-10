function outputImage = AMF(inputImage)
    ds = 20; % Dimensione della finestra locale

    % Converte l'immagine in input in double per elaborazione
    inputImage = double(inputImage);
    % Ottiene le dimensioni dell'immagine
    [rows, columns] = size(inputImage);
    % Prealloca l'immagine di output
    outputImage = zeros(size(inputImage));
    % Itera su ogni pixel dell'immagine
    for i = 1:rows
        for j = 1:columns
            % Inizia con la finestra di dimensione 3x3
            windowSize = 3;
            while true
                % Estrae la sottomatrice intorno al pixel (i, j)
                rowMin = max(1, i - (windowSize - 1) / 2);
                rowMax = min(rows, i + (windowSize - 1) / 2);
                colMin = max(1, j - (windowSize - 1) / 2);
                colMax = min(columns, j + (windowSize - 1) / 2);
                window = inputImage(rowMin:rowMax, colMin:colMax);
                % Calcola mediana e valori di minimo e massimo nella finestra
                med = median(window(:));
                minVal = min(window(:));
                maxVal = max(window(:));
                % Controlla se la mediana è diversa dai valori estremi
                if (med > minVal) && (med < maxVal)
                    % Se il valore del pixel corrente è rumore
                    if (inputImage(i, j) == minVal) || (inputImage(i, j) == maxVal)
                        outputImage(i, j) = med;
                    else
                        outputImage(i, j) = inputImage(i, j);
                    end
                    break;
                else
                    % Aumenta la dimensione della finestra
                    windowSize = windowSize + 2;
                    % Ferma se la dimensione massima della finestra è raggiunta
                    if windowSize > ds
                        outputImage(i, j) = med;
                        break;
                    end
                end
            end
        end
    end
    % Converte l'immagine di output in uint8 se l'immagine originale era uint8
    if isinteger(inputImage)
        outputImage = uint8(outputImage);
    end
end
