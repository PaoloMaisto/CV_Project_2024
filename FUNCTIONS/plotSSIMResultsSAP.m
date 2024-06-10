function plotSSIMResultsSAP(degree, ssim_results)
    % Funzione per graficare i risultati SSIM per vari livelli di rumore
    figure();
    plot(degree, ssim_results(1,:), 'p-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'v', 'DisplayName', 'AMF'); hold on;
    plot(degree, ssim_results(2,:), 's-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'o', 'DisplayName', 'NAFSMF');
    plot(degree, ssim_results(3,:), 'd-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'x', 'DisplayName', 'AWMF');
    plot(degree, ssim_results(4,:), '^-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'd', 'DisplayName', 'BPDF');
    plot(degree, ssim_results(5,:), 'o-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 's', 'DisplayName', 'DAMF');
    plot(degree, ssim_results(6,:), '*-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', '^', 'DisplayName', 'NAMF');

    xlabel('Noise Level');
    ylabel('SSIM');
    title('Average SSIM of Different Methods at All SAP Noise Levels');
    legend('show');
    grid on;
    % Salvataggio del grafico come immagine
    % saveas(gcf, 'SSIM_Comparison.png');
end
