function writeVol2Tif(vol, filename, colormap)

    if isempty(colormap)
        imwrite(squeeze(vol(:, :, 1)), filename);

        for k = 2:size(vol, 3)
            imwrite(squeeze(vol(:, :, k)), filename, 'WriteMode', 'append');
        end

    else
        img = im2double(squeeze(vol(:, :, 1)));
        img = uint8(255 * mat2gray(img));
        rgbImage = ind2rgb(img, colormap);
        imwrite(rgbImage, filename);

        for k = 2:size(vol, 3)
            img = im2double(squeeze(vol(:, :, k)));
            img = uint8(255 * mat2gray(img));
            rgbImage = ind2rgb(img, colormap);
            imwrite(rgbImage, filename, 'WriteMode', 'append');

        end

    end

end
