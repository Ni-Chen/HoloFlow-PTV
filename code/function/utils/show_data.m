function show_data(data, figpos, titlename)
    %     temp = normalize(abs(data));
    temp = (abs(data));

    subplot(figpos); imagesc(plotdatacube(temp)); title(titlename);

    colormap(hot); colorbar; axis image off;
end
