function plot3dmatrix(A, linespec)

    [x, y, z] = ind2sub(size(A), find(A));

    %     plot3(x, y, z, ...
    %          'Color', linespec, ...
    %          'Marker', '.');

    scatter3(x, y, z, 8, ...
        'MarkerEdgeColor', linespec, ...
        'Marker', '.', ...
        'MarkerFaceAlpha', .5, 'MarkerEdgeAlpha', .5);

    %     view(-60, 60);
    grid on; axis normal;
    xlabel('x');
    ylabel('y');
    zlabel('z');
end
