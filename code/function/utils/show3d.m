function show3d(obj_vol, alpham)
    %     obj_vol = permute(obj_vol, [2 3 1]);  % Complex images
    [Ny, Nx, Nz] = size(obj_vol);

    axes('fontsize', 16, 'xtick', 1:floor(Nx / 4):Nx, 'ytick', 1:floor(Ny / 4):Ny, 'ztick', 1:floor(Nz / 4):Nz);
    vol3d('CData', obj_vol, 'texture', '3D');
    %     view(-195, 18);
    view(-37.5, 30);

    colormap('hot');
    colormap(1 - colormap);
%     h = colorbar('northoutside');
%     set(h, 'Position', [h.Position(1) * 1.6, h.Position(2), h.Position(3) * 0.9, h.Position(4) / 1.5])

    h = colorbar('eastoutside');
    set(h, 'Position', [h.Position(1)*1.05, h.Position(2)*2.2, h.Position(3), h.Position(4) / 1.8])

    t = get(h, 'Limits');
    set(h, 'Ticks', [ceil(t(1) * 100) / 100, round((t(1) + (t(2) - t(1)) / 2) * 100) / 100, floor(t(2) * 100) / 100]);
    %     set(h,'Ticks', [t(1),(t(1)+ (t(2)-t(1))/2),  t(2)]);

    xlabel('x', 'fontsize', 16);
    ylabel('y', 'fontsize', 16);
    zlabel('z', 'fontsize', 16);

    box on,
    ax = gca;
    ax.BoxStyle = 'full';

    %     grid on;
    alphamap('decrease', alpham);

    xlim([1 Nx])
    ylim([1 Ny])
    zlim([1 Nz])
end
