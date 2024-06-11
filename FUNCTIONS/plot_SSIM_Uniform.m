function plot_SSIM_Uniform(degree, ssim_results)
    % Funzione per graficare i risultati SSIM per vari livelli di varianza del rumore Uniform
    figure();
    plot(degree, ssim_results(1,:), 's-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'o', 'DisplayName', 'Gaussian'); hold on;
    plot(degree, ssim_results(2,:), 'p-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'v', 'DisplayName', 'Median'); 
    plot(degree, ssim_results(3,:), 'd-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'x', 'DisplayName', 'Mean'); 

    xlabel('Noise Level');
    ylabel('SSIM');
    title('Average SSIM of Different Methods at All Uniform Noise Levels');
    legend('show');
    grid on;
    % Salvataggio del grafico come immagine, se necessario
    % saveas(gcf, 'SSIM_Comparison_Uniform.png');
end