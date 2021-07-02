function plot_flow2d(u, scale, map)

    if nargin < 2
        scale = 1;
        map = jet(256);
    elseif nargin < 3
        map = jet(256);
    end

    udims = round(size(u) * scale);
    [x, y] = meshgrid(1:udims(2), 1:udims(1));
    uscale = 2;

    q = quiver(x, y, resize(u(:, :, 2), size(x)), resize(u(:, :, 1), size(y)), uscale, 'linewidth', 2);

    mags = sqrt(sum(cat(2, q.UData(:), q.VData(:)).^2, 2));
    %     mags(mags<0.001) = 0;

    %// Get the current colormap
    currentColormap = colormap(map);

    %// Now determine the color to make each arrow using a colormap
    [~, ~, ind] = histcounts(mags, size(currentColormap, 1));

    %// Now map this to a colormap to get RGB
    cmap = uint8(ind2rgb(ind(:), currentColormap) * 255);
    cmap(:, :, 4) = 255;
    cmap = permute(repmat(cmap, [1 3 1]), [2 1 3]);

    %// We repeat each color 3 times (using 1:3 below) because each arrow has 3 vertices
    set(q.Head, 'ColorBinding', 'interpolated', 'ColorData', reshape(cmap(1:3, :, :), [], 4).');

    %// We repeat each color 2 times (using 1:2 below) because each tail has 2 vertices
    set(q.Tail, 'ColorBinding', 'interpolated', 'ColorData', reshape(cmap(1:2, :, :), [], 4).');

    colorbar();
    set(gca, 'CLim', [min(mags), max(mags)]);
    axis xy square tight;

end
