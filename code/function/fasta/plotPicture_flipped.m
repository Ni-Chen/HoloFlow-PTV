function plotPicture_flipiped(data, N0, N, Tc, R3, zSchnitt, type, alpha3D)

    if (type == '3D')
        % 3D-Plot
        figure, axes('fontsize', 12, 'fontweight', 'b', 'xtick', 0:floor(N0 / 4):N0, 'ytick', 0:floor(N0 / 4):N0, 'ztick', 0:floor(N / 4):N);
        vol3d('CData', abs(permute(data, [2 3 1])), 'texture', '3D');
        view(-202, 18), axis tight
        colormap('gray'), colormap(1 - colormap), colorbar
        xlabel('z', 'fontsize', 16, 'fontweight', 'b')
        ylabel('x', 'fontsize', 16, 'fontweight', 'b')
        zlabel('y', 'fontsize', 16, 'fontweight', 'b')
        axis([0 N0 0 N0 0 N])
        box on, zoom(0.7)
        alphamap('decrease', alpha3D)% verringere Alphaskala f�r bessere Darstellung
    end

    if (type == 'xz')
        % xz-Ausschnitt
        xz_data = double(tformarray(data, Tc, R3, [3 2 1], [1 2], [N N0], [], 0));
        figure, imshow(abs(xz_data), [])
        set(gca, 'fontsize', 12, 'fontweight', 'b', 'xtick', 0:floor(N0 / 4):N0, 'ytick', 0:floor(N / 4):N, 'ydir', 'normal');
        axis([0 N0 0 N]), axis on
        colormap('gray'), colormap(1 - colormap), colorbar
        xlabel('x', 'fontsize', 16, 'fontweight', 'b')
        ylabel('z', 'fontsize', 16, 'fontweight', 'b')
    end

    if (type == 'xy')
        % xy-Ausschnitt
        xy_data = data(:, :, ceil(N / 2) + zSchnitt);
        figure, imshow(abs(xy_data), [])
        set(gca, 'fontsize', 12, 'fontweight', 'b', 'xtick', 0:floor(N0 / 4):N0, 'ytick', 0:floor(N0 / 4):N0, 'ydir', 'normal');
        axis([0 N0 0 N0]), axis on
        colormap('gray'), colormap(1 - colormap), colorbar
        xlabel('x', 'fontsize', 16, 'fontweight', 'b')
        ylabel('y', 'fontsize', 16, 'fontweight', 'b')
    end

    if (type == 'yz')
        % yz-Ausschnitt
        yz_data = double(tformarray(data, Tc, R3, [3 1 2], [1 2], [N N0], [], 0));
        figure, imshow(abs(yz_data), []);
        set(gca, 'fontsize', 12, 'fontweight', 'b', 'xtick', 0:floor(N0 / 4):N0, 'ytick', 0:floor(N0 / 4):N0, 'ydir', 'normal');
        axis([0 N0 0 N0]), axis on
        colormap('gray'), colormap(1 - colormap), colorbar
        xlabel('y', 'fontsize', 16, 'fontweight', 'b')
        ylabel('z', 'fontsize', 16, 'fontweight', 'b')
    end
