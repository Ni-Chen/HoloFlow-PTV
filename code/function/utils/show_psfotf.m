function show_psfotf(data, figpos, titlename, Nz)
    %     temp = normalize(real(data));
    temp = real(data);
    subplot(figpos); imagesc(plotdatacube(temp(:, :, round(Nz / 2)))); title(titlename);
    colormap(hot); colorbar; axis image off;
end
