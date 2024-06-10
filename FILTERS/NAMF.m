function DenoisedImg= NAMF(x)
    T = 0.8; % Soglia
    Ds = 2;  % Dimensione della finestra non locale
    ds = 20; % Dimensione della finestra locale


    x = double(x); % x is the image to be processed, Converte l'immagine in input x nel formato double. Questo è necessario per eseguire calcoli numerici di precisione su pixel che possono originariamente essere in un formato come uint8 (valori da 0 a 255)
    M = x;         % Crea una copia M dell'immagine originale x. Questa copia sarà manipolata e aggiornata durante il processo di denoising.

    N = zeros(size(x));    % Crea una copia M dell'immagine originale x. Questa copia sarà manipolata e aggiornata durante il processo di denoising.
    N(x~=0 & x~=255) = 1;  % Marca tutti i pixel di N come 1 (non rumorosi) se i corrispondenti pixel in x non sono né completamente neri (0) né completamente bianchi (255). Questi valori rappresentano tipicamente il rumore "salt" (255) e "pepper" (0).
    f = zeros(size(x));    %  Questa matrice sarà utilizzata per identificare i pixel rumorosi.
    f(x==0 | x==255) = 1;  % Marca tutti i pixel in f come 1 (rumorosi) se i corrispondenti pixel in x sono 0 o 255, identificando così i pixel affetti da rumore "salt-and-pepper

    w_max = 3;                % che probabilmente definisce la dimensione massima di una finestra di ricerca usata più avanti nel processo per analizzare i pixel vicin
    [x_len, y_len] = size(x); % Estrae le dimensioni dell'immagine in x e y da x e le memorizza nelle variabili xlen (lunghezza in x) e ylen (lunghezza in y)

% Queste righe di codice preparano l'immagine e le strutture dati necessarie per un algoritmo di denoising che procederà con ulteriori operazioni 
% specifiche, probabilmente includendo la sostituzione dei pixel rumorosi con valori basati sui loro vicini non rumorosi, seguendo il principio del filtro mediano 
% o di un altro tipo di filtro adattivo o non locale.

    for i = 1:x_len         % itera attraverso tutte le righe dell'immagin
        for j = 1:y_len     % che itera attraverso tutte le colonne dell'immagine

            if N(i,j) == 0  % (i,j) è identificato come rumoroso nella matrice N. Se N(i,j) == 0, significa che il pixel è rumoroso

                w = 1;                                                        % Inizializza la variabile s, che rappresenta il raggio della finestra di ricerca attorno al pixel corrente, a 1.
                h = 1;
                g = N(max(i-w,1):min(i+w,x_len), max(j-w,1):min(j+w,y_len));  % Estrae una sotto-matrice g da N, centrata nel pixel  ((i,j) con il raggio s. Utilizza le funzioni max e min per assicurarsi che la finestra non vada fuori dai limiti dell'immagine.
                num = sum(g(:));                                              % Calcola il numero di pixel non rumorosi nella finestra g sommando tutti i valori (dove 1 rappresenta un pixel non rumoroso e 0 un pixel rumoroso).
                
                while num == 0 && w < w_max                                      % Un ciclo while che continua a eseguire fino a quando non sono trovati pixel non rumorosi (num == 0) e il raggio della finestra s è minore del massimo specificato s_max.
                    w = w + h;                                                   % Incrementa il raggio della finestra di ricerca
                    g = N(max(i-w,1):min(i+w,x_len), max(j-w,1):min(j+w,y_len)); % Aggiorna la finestra g con il nuovo raggio w, ricalcolando i pixel non rumorosi nella nuova finestra.
                    num = sum(g(:));                                             % Ricalcola il numero di pixel non rumorosi nella finestra aggiornata.
                end

                if w <= w_max && sum(g(:)>0)                                     % Verifica se il raggio della finestra w è ancora nel limite w_max e se ci sono pixel non rumorosi nella finestra g.
                    
                   tmp = x(max(i-w,1):min(i+w,x_len), max(j-w,1):min(j+w,y_len));    % Estrae i valori di pixel dall'immagine originale x utilizzando la stessa finestra g                 
                   Ws = 1 - f(max(i-w,1):min(i+w,x_len), max(j-w,1):min(j+w,y_len)); % Calcola i pesi Ws per l'operazione di media, dove i pixel rumorosi (marcati come 1 in f) hanno peso zero e quelli non rumorosi hanno peso 1.
                   M(i,j) = sum(sum(tmp.*Ws)) / sum(sum(Ws));                        % Calcola il nuovo valore del pixel (i,j) facendo la media pesata dei pixel nella finestra, usando i pesi Ws. Questo valore sostituisce il pixel rumoroso nell'immagine M

                else
                   
                   tmp = x(max(i-w,1):min(i+w,x_len), max(j-w,1):min(j+w,y_len));   % Estrae una finestra di pixel attorno al pixel corrente (i,j) dalla matrice dell'immagine x. La dimensione della finestra è determinata dalla variabile w e le coordinate sono limitate per assicurarsi che non si estenda oltre i bordi dell'immagine.
                   pd = length(find(tmp == x(i,j))) / length(tmp(:));               % Calcola la proporzione (pd) dei pixel nella finestra tmp che hanno lo stesso valore del pixel corrente x(i,j). Questo è un tentativo di misurare quanto sia comune il valore del pixel corrente nei suoi dintorni immediati, un modo per determinare se il pixel corrente possa essere un outlier (rumore) o no
                   
                   if pd > T        % Confronta la proporzione calcolata con un valore soglia B. Se pd è maggiore di B, significa che il valore del pixel corrente non è insolito nella sua vicinanza locale e quindi potrebbe non essere considerato rumore.
                      f(i, j) = 0;  % Se la condizione sopra è vera, imposta il corrispondente valore in f a 0, indicando che il pixel (i,j) non è considerato rumoroso.
                      continue      % Salta il resto delle istruzioni nel ciclo più interno e procede con la prossima iterazione, effettivamente ignorando il pixel corrente per ulteriori modifiche poiché è stato giudicato non rumoroso.
                   end                    
                   up = max(i - 1, 1); left = max(j - 1, 1);             % Calcola gli indici per il pixel sopra (up) e a sinistra (left) del pixel corrente, assicurandosi che non si superino i limiti dell'immagine (cioè, che non si vada al di sotto dell'indice 1).
                   M(i,j) = median([M(up, left), M(up, j), M(i, left)]); % Calcola il valore mediano tra il pixel corrente e i suoi vicini a sinistra e sopra, poi assegna questo valore mediano al pixel corrente nella matrice dell'immagine denoised M. Questo passo è fondamentale per il filtraggio mediano, che aiuta a rimuovere i pixel di rumore mantenendo i bordi e riducendo l'intensità del rumore.                 
                end
            end
        end
    end

% Questa parte del codice continua a gestire il processo di denoising, entrando in una fase più sofisticata che sembra utilizzare un metodo 
% di filtraggio basato su patch (o blocco di immagine) non locale. Ecco una spiegazione dettagliata:


    y = M; % Assegna l'immagine denoised intermedia M a una nuova variabile y. Questo passaggio potrebbe essere usato per separare le diverse fasi di processing o per preparare l'immagine per ulteriori elaborazioni.

    beta_0 = 4.5595;
    beta_1 = 6.0314;
    beta_2 = 2.2186;

    noise = sum(sum(f))/(x_len*y_len);             % Calcola la proporzione di pixel considerati rumorosi (noise). Questo è fatto sommando tutti i valori in f (dove i pixel rumorosi sono marcati con 1) e dividendo per il numero totale di pixel nell'immagine. Questo dà una misura della densità del rumore nell'immagine.
    hs = beta_0 + beta_1*noise + beta_2*(noise^2); % Calcola un parametro hs basato sulla densità del rumore. Questo parametro è utilizzato per determinare il comportamento del filtro nella fase successiva, potenzialmente influenzando il grado di smoothing applicato.

    I = y;                                                        % Aggiorna I con l'immagine y che è stata processata finora.
    [m,n] = size(I);                                              % Ottiene le dimensioni dell'immagine I e le memorizza nelle variabili m e n.
    PaddedImg = padarray(I,[Ds+ds+1,Ds+ds+1],'symmetric','both'); % Crea un'immagine imbottita PaddedImg che è una versione di I estesa simmetricamente. L'imbottitura è utile per facilitare il calcolo delle medie locali senza incorrere in problemi ai bordi dell'immagine.
    PaddedV = padarray(I,[Ds,Ds],'symmetric','both');             % Similmente, crea un'altra versione imbottita PaddedV di I, ma con una dimensione di padding leggermente minore. Questa potrebbe essere utilizzata per un differente scopo nel calcolo del filtro.
    average = zeros(m,n);   % Inizializza una matrice average di zeri con le dimensioni di I. Questa matrice sarà usata per accumulare i valori medi calcolati.
    weight_max = average;   % Inizializza una matrice weight_max, copiata da average, che verrà usata per tracciare i massimi pesi utilizzati nel calcolo delle medie
    sum_weight = average;   % Inizializza una matrice sweight allo stesso modo, per tracciare la somma dei pesi applicati durante il calcolo della media.
    h2 = hs*hs;             % Calcola il quadrato di hs, memorizzato in h2, che sarà utilizzato per normalizzare i pesi nel calcolo delle medie basate sulla distanza.
    d = (2*ds+1)^2;         % Determina il fattore di normalizzazione d basato sulla dimensione della finestra locale
   
    for t1 =-Ds:Ds                    % Inizia un ciclo che itera attraverso un intervallo da -Ds a Ds, rappresentando gli offset della finestra di ricerca lungo l'asse delle righe.
        for t2 =-Ds:Ds                % Un ciclo annidato che itera attraverso lo stesso intervallo lungo l'asse delle colonne.
            if(t1 == 0 && t2 == 0)    % Salta l'iterazione corrente se entrambi gli offset sono zero. Questo evita di considerare il pixel centrale nel calcolo delle medie, concentrando l'attenzione sui pixel circostanti.
                continue;
            end

            Sd = integralImgSqDiff(PaddedImg,Ds,t1,t2);                                                                                        % Chiama la funzione integralImgSqDiff per calcolare la somma cumulativa delle differenze quadratiche tra l'immagine imbottita (PaddedImg) e la sua versione traslata di (t1, t2). Sd è l'immagine integrale delle differenze quadratiche, utilizzata per accelerare il calcolo delle distanze.
            SqDist2 = Sd(2*ds+2:end-1,2*ds+2:end-1)+Sd(1:end-2*ds-2,1:end-2*ds-2)-Sd(2*ds+2:end-1,1:end-2*ds-2)-Sd(1:end-2*ds-2,2*ds+2:end-1); % Calcola la distanza quadratica media SqDist2 utilizzando i valori dell'immagine integrale Sd. Questo calcolo ottimizza il processo sottraendo e sommando le aree appropriate dell'immagine integrale per ottenere la somma delle differenze quadratiche entro una finestra definita da ds
            SqDist2 = SqDist2/d;                              % Normalizza la distanza quadratica media dividendo per il numero di elementi nella finestra, definito da d = (2*ds+1)^2.
            weight = exp(-SqDist2/h2);                        % Calcola i pesi w per il filtro, usando una funzione esponenziale della distanza quadratica media normalizzata, con h2 che agisce come un parametro di smoothing.
            v = PaddedV(1+Ds+t1:end-Ds+t1,1+Ds+t2:end-Ds+t2); % Estrae una vista traslata di PaddedV basata su t1 e t2, utilizzata per il calcolo della media ponderata.
            average = average+weight.*v;                      % Aggiorna la matrice average aggiungendo il prodotto del peso w e il valore di pixel traslato v, accumulando così la somma ponderata per la media.
            weight_max = max(weight_max,weight);              % Aggiorna weight_max con il massimo tra il valore corrente e w, mantenendo traccia del peso massimo utilizzato.
            sum_weight = sum_weight+weight;                   % Accumula i pesi in sum_weight per normalizzare successivamente la media ponderata.
        end
    end
    average = average+0.*I;            
    average = average./(0+sum_weight); % Finalizza il calcolo della media ponderata normalizzando con la somma totale dei pesi
    DenoisedImg = average; % DenoisedImg is the restored image % Assegna la matrice average calcolata a DenoisedImg, che rappresenta l'immagine denoised finale.

    for i = 1:m
        for j = 1:n
            if f(i, j) == 0                  % Controlla se il pixel corrente è stato originariamente considerato non rumoroso
                DenoisedImg(i, j) = y(i, j); % Se il pixel è non rumoroso, riassegna il suo valore originale dalla matrice y a DenoisedImg, preservando i pixel non interessati dal rumore
            end
        end
    end
end

function Sd = integralImgSqDiff(PaddedImg,Ds,t1,t2)
Dist2=(PaddedImg(1+Ds:end-Ds,1+Ds:end-Ds)-PaddedImg(1+Ds+t1:end-Ds+t1,1+Ds+t2:end-Ds+t2)).^2; % Calcola il quadrato delle differenze tra l'immagine imbottita e la sua versione traslata, elemento per elemento.
Sd = cumsum(Dist2,1); % Calcola la somma cumulativa lungo le colonne.
Sd = cumsum(Sd,2);    % Calcola la somma cumulativa lungo le righe, completando così l'immagine integrale delle differenze quadratiche.
end

% Questo processo di filtraggio non locale è particolarmente efficace per ridurre il rumore mantenendo i dettagli dell'immagine, sfruttando le somiglianze locali e non locali tra i pixel.


