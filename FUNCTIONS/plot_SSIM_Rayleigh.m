function plot_SSIM_Rayleigh(variance, ssim_results)
    % Funzione per graficare i risultati SSIM per vari livelli di variance del rumore Rayleigh
    figure();
    plot(variance, ssim_results(1,:), 's-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'o', 'DisplayName', 'Gaussian');hold on;
    plot(variance, ssim_results(2,:), 'p-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'v', 'DisplayName', 'Median'); 
    plot(variance, ssim_results(3,:), 'd-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'x', 'DisplayName', 'Mean');

    xlabel('Noise Level');
    ylabel('SSIM');
    title('Average SSIM of Different Methods at All Rayleigh Noise Levels');
    legend('show');
    grid on;
    % Salvataggio del grafico come immagine, se necessario
    % saveas(gcf, 'SSIM_Comparison_Rayleigh.png');
end