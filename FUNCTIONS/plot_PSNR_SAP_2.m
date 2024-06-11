function plot_PSNR_SAP_2(degree, psnr_results)
    % Funzione per graficare i risultati PSNR per vari livelli di varianza del rumore Exponential
    figure();
    plot(degree, psnr_results(1,:), 'p-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'v', 'DisplayName', 'Gaussian'); hold on;
    plot(degree, psnr_results(2,:), 's-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'o', 'DisplayName', 'Median');
    plot(degree, psnr_results(3,:), 'd-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'x', 'DisplayName', 'Mean');

    xlabel('Noise Level');
    ylabel('PSNR (dB)');
    title('Average PSNR of Different Methods at All SAP Noise Levels');
    legend('show');
    grid on;
    % Salvataggio del grafico come immagine, se necessario
    % saveas(gcf, 'PSNR_Comparison_SAP.png');
end