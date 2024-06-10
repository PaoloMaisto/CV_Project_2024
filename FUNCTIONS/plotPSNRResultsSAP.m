function plotPSNRResultsSAP(degree, psnr_results)
    % Funzione per graficare i risultati PSNR per vari livelli di rumore
    figure();
    plot(degree, psnr_results(1,:), 'p-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'v', 'DisplayName', 'AMF'); hold on;
    plot(degree, psnr_results(2,:), 's-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'o', 'DisplayName', 'NAFSMF');
    plot(degree, psnr_results(3,:), 'd-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'x', 'DisplayName', 'AWMF');
    plot(degree, psnr_results(4,:), '^-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 'd', 'DisplayName', 'BPDF');
    plot(degree, psnr_results(5,:), 'o-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', 's', 'DisplayName', 'DAMF');
    plot(degree, psnr_results(6,:), '*-', 'MarkerSize', 5, 'LineWidth', 1, 'Marker', '^', 'DisplayName', 'NAMF');

    xlabel('Noise Level');
    ylabel('PSNR (dB)');
    title('Average PSNR of Different Methods at All SAP Noise Levels');
    legend('show');
    grid on;
    % Salvataggio del grafico come immagine, se necessario
    % saveas(gcf, 'PSNR_Comparison.png');
end
