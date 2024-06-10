function plot_PSNR_Exponential(variance, psnr_results)
    % Funzione per graficare i risultati PSNR per vari livelli di varianza del rumore Exponential
    figure();
    plot(variance, psnr_results(1,:), 'p-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'v', 'DisplayName', 'Gaussian'); hold on;
    plot(variance, psnr_results(2,:), 's-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'o', 'DisplayName', 'Median');
    plot(variance, psnr_results(3,:), 'd-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'x', 'DisplayName', 'Adaptive Median');

    xlabel('Noise Level');
    ylabel('PSNR (dB)');
    title('Average PSNR of Different Methods at All Exponential Noise Levels');
    legend('show');
    grid on;
    % Salvataggio del grafico come immagine, se necessario
    % saveas(gcf, 'PSNR_Comparison_Exponential.png');
end