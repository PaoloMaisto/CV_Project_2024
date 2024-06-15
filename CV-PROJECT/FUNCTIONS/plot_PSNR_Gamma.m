function plot_PSNR_Gamma(variance, psnr_results)
    % Funzione per graficare i risultati PSNR per vari livelli di variance del rumore Gamma
    figure();
    plot(variance, psnr_results(1,:), 's-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'o', 'DisplayName', 'Gaussian');hold on;
    plot(variance, psnr_results(2,:), 'p-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'v', 'DisplayName', 'Median'); 
    plot(variance, psnr_results(3,:), 'd-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'x', 'DisplayName', 'Mean');

    xlabel('Noise Level');
    ylabel('PSNR (dB)');
    title('Average PSNR of Different Methods at All Gamma Noise Levels');
    legend('show');
    grid on;
    % Salvataggio del grafico come immagine, se necessario
    % saveas(gcf, 'PSNR_Comparison_Gamma.png');
end