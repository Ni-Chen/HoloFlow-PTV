function show3d_exp(obj_vol, alpham)
    %     obj_vol = permute(obj_vol, [2 3 1]);  % Complex images
    [Ny, Nx, Nz] = size(obj_vol);

    axes('fontsize', 16, 'xtick', 1:floor(Nx / 4):Nx, 'ytick', 1:floor(Ny / 4):Ny, 'ztick', 1:floor(Nz / 4):Nz);
    vol3d('CData', obj_vol, 'texture', '3D');
    %     view(-195, 18);
    view(-37.5, 30);
    %     view(3);
    %     camup([0 1 0]);

    colormap('hot');
    colormap(1 - colormap);
    alphamap('decrease', alpham);
    h = colorbar('Location', 'north', 'AxisLocation', 'out');
    set(h, 'position', [0.23, 0.856, 0.66, 0.025])
    t = get(h, 'Limits');
    set(h, 'Ticks', [t(1), t(1) + (t(2) - t(1)) / 2, t(2)]);

    xlabel('x', 'fontsize', 14);
    ylabel('y', 'fontsize', 14);
    zlabel('z', 'fontsize', 14);

    box on,
    ax = gca;
    ax.BoxStyle = 'full';
    grid on;

    xticks([1 Ny / 2 Ny]);
    yticks([1 Nx / 2 Nx]);
    zticks([1 Nz / 2 Nz]);

    x_tick = 1:Ny;
    y_tick = 1:Nx;
    z_tick = 1:Nz;

    x_ticks = {min(x_tick), floor(min(x_tick) + (max(x_tick) - min(x_tick)) / 2), max(x_tick)};
    set(gca, 'xticklabels', (x_ticks));
    y_ticks = {min(y_tick), floor(min(y_tick) + (max(y_tick) - min(y_tick)) / 2), max(y_tick)};
    set(gca, 'yticklabels', (y_ticks));
    z_ticks = {min(z_tick), floor(min(z_tick) + (max(z_tick) - min(z_tick)) / 2), max(z_tick)};
    set(gca, 'zticklabels', (z_ticks));

    xlim([1 Ny])
    ylim([1 Nx])
    zlim([1 Nz])

end
