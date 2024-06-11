function plot_SSIM_SAP_2(degree, ssim_results)
    % Funzione per graficare i risultati SSIM per vari livelli di varianza del rumore Exponential
    figure();
    plot(degree, ssim_results(1,:), 'p-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'v', 'DisplayName', 'Gaussian'); hold on;
    plot(degree, ssim_results(2,:), 's-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'o', 'DisplayName', 'Median');
    plot(degree, ssim_results(3,:), 'd-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'x', 'DisplayName', 'Mean');

    xlabel('Noise Level');
    ylabel('SSIM');
    title('Average SSIM of Different Methods at All SAP Noise Levels');
    legend('show');
    grid on;
    % Salvataggio del grafico come immagine, se necessario
    % saveas(gcf, 'SSIM_Comparison_SAP.png');
end