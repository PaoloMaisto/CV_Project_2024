function plot_SSIM_Exponential(variance, ssim_results)
    % Funzione per graficare i risultati SSIM per vari livelli di varianza del rumore Exponential
    figure();
    plot(variance, ssim_results(1,:), 'p-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'v', 'DisplayName', 'Gaussian'); hold on;
    plot(variance, ssim_results(2,:), 's-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'o', 'DisplayName', 'Median');
    plot(variance, ssim_results(3,:), 'd-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'x', 'DisplayName', 'Adaptive Median');

    xlabel('Noise Level');
    ylabel('SSIM');
    title('Average SSIM of Different Methods at All Exponential Noise Levels');
    legend('show');
    grid on;
    % Salvataggio del grafico come immagine, se necessario
    % saveas(gcf, 'SSIM_Comparison_Exponential.png');
end