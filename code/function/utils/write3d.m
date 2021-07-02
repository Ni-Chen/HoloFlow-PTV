function write3d(data, Z, outdir, filename)
    [~, ~, Nz] = size(data);

    for iz = 1:Nz
        %         temp = squeeze(data(:, :, iz));
        temp = data(:, :, iz);
        temp = mat2gray(temp);
        imwrite(temp, [outdir, filename, '_', num2str(Z(iz)), 'mm.png']);
    end

end
