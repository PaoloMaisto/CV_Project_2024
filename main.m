clc; clear; close all;
%% CV PROJECT
    disp('Select the script to run:');
    disp('1: SAP.m');
    disp('2: Gaussian.m');
    disp('3: Rayleigh.m');
    disp('4: Gamma.m');
    disp('5: Exponential.m');
    disp('6: Impulsive.m');
    disp('7: Uniform.m');
    choice = input('Enter the number of the script to run (1-7): ');
    
    % Associa ogni scelta a un file script
    switch choice
        case 1
            scriptName = 'SAP.m';
        case 2
            scriptName = 'Gaussian.m';
        case 3
            scriptName = 'Rayleigh.m';
        case 4
            scriptName = 'Gamma.m';
        case 5
            scriptName = 'Exponential.m';
        case 6
            scriptName = 'Impulsive.m';
        case 7
            scriptName = 'Uniform.m';
        otherwise
            fprintf('Invalid selection. Please enter a number between 1 and 7.\n');
            return;
    end
    
    % Esegui lo script selezionato
    try
        run(scriptName);
        disp('Executed successfully');
    catch e
        disp('Error');
    end

