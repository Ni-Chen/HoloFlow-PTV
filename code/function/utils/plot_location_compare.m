function [gt_num] = plot_location_compare(gt, pred, params)

    figure('Name', 'Particles', 'Position', [100, 100, 440, 450]);

    [idxy1, idxx1, idxz1] = ind2sub(size(gt),find(gt==1));
    gt_num = size(idxy1,1);
    scatter3(idxy1, idxx1, idxz1, 10, 'ro');  hold on;

    [idxy2, idxx2, idxz2] = ind2sub(size(pred),find(pred ==1));
    col = [0 0.5 0.5];
    scatter3(idxy2, idxx2, idxz2,  10, 'o', 'MarkerEdgeColor', col, 'MarkerFaceColor', col); hold on;

    vol_tmp = gt;
    xticks([1 size(vol_tmp, 2) / 2 size(vol_tmp, 2)]);
    yticks([1 size(vol_tmp, 1) / 2 size(vol_tmp, 1)]);
    zticks([1 size(vol_tmp, 3) / 2 size(vol_tmp, 3)]);
    set_ticks(vol_tmp, ((1:params.Nx) - round(params.Nx / 2)) * params.pps * 1e3, ((1:params.Ny) - round(params.Ny / 2)) * params.pps * 1e3, params.z * 1e3, 'mm');

    campos([238.677881518248 158.100587977718 130.758955310304]);
    camup([-0.188773777160094 0.975230048830831 -0.115285787997162]);
    camva(100);
        

    [lgd, icons]= legend({'First frame', 'Second frame'},'FontSize',16,'Orientation','vertical');
    legend boxoff;
    set(lgd, 'position', [0.05,0.05,0.6,0.15]);
    

    
    axis image;
    set_ticks(vol_tmp, ((1:params.Nx) - round(params.Nx / 2)) * params.pps * 1e3, ((1:params.Ny) - round(params.Ny / 2)) * params.pps * 1e3, params.z * 1e3, 'mm');
    xlabel('x (mm)', 'Rotation', -30, 'Position', [-7.435,254.90,-79.24]);
    ylabel('y (mm)', 'Rotation',90, 'Position', [81.57,71.9,-133.42]);
    zlabel('z (mm)', 'Rotation', 9, 'Position', [67,-81,-41.814]);
    set(gca, 'FontSize', 16); box on, ax = gca; ax.BoxStyle = 'full';
end