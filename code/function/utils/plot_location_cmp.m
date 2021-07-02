function plot_location_cmp(vol1, vol2)
    figure('Name', 'Particles', 'Position', [100, 100, 400, 500]);
    col = [0 0.5 0.5];

    scatter3(vol1(:, 1), vol1(:, 2), vol1(:, 3), 10, 'r'); hold on;

    scatter3(vol2(:, 1), vol2(:, 2), vol2(:, 3), 10, 'o', 'MarkerEdgeColor', col, 'MarkerFaceColor', col); hold on;

    xticks([1 size(vol1, 2) / 2 size(vol1, 2)]);
    yticks([1 size(vol1, 1) / 2 size(vol1, 1)]);
    zticks([1 size(vol1, 3) / 2 size(vol1, 3)]);

    set(gca, 'FontSize', 16);

    lgd = legend('First frame', 'Second frame', 'Error', 'Orientation', 'horizontal', 'Location', 'north');
    set(lgd, 'position', [0.36 0.86 0.435000006028584 0.047619048527309]);

    zlabel('z (mm)');

    set(gca, 'FontSize', 16);
    box on,
    ax = gca;
    ax.BoxStyle = 'full';

    xlabel('x (pixel)'); ylabel('y (pixel)'); zlabel('z (pixel)');
end
