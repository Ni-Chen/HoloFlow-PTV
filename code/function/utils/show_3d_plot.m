function [xz_fwhm, xy_fwhm] = show_3d_plot(vol)
    [Ny, Nx, Nz] = size(vol);
    cmbxy = max(vol, [], 3);
    cmbxz = max(vol, [], 1);
    cmbxz = rot90(flipud(squeeze(cmbxz)), -1);

    cmbxz_slice = squeeze(max(squeeze(cmbxz), [], 2));
    xz_fwhm = fwhm(1:Nx, cmbxz_slice);
    figure('Name', ['x-z, fwhm ' num2str(xz_fwhm)], 'Position', [100, 100, 400, 500]); plot(1:Nx, (cmbxz_slice));

    cmbxy_slice = squeeze(max(squeeze(cmbxy), [], 2));
    xy_fwhm = fwhm(1:Nx, cmbxy_slice);
    figure('Name', ['x-y, fwhm ' num2str(xy_fwhm)], 'Position', [100, 100, 400, 500]); plot(1:Nx, (cmbxy_slice));

end
