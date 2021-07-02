function zx_line = selectline(data, rx, rz)

    [Ny, Nx, Nz] = size(data);

    data_zx = squeeze(data(Ny, :, :));

    if rx ~= 0
        lk = rx / rz;
        %     figure;
        zx_line = zeros(Nz);

        for iz = 1:Nz
            ix = round(lk * (iz - round(Nz / 2)) + Nx / 2);

            if (ix < 1 || ix > Nx)
                continue;
            end

            zx_line(iz) = data_zx(ix, iz);

            %         obj_xz(ix, iz) = 1;
            %         imshow(obj_xz);
        end

    else
        zx_line = squeeze(data(Ny, Nx / 2, :));
    end

    %     figure;
    %     plot(zx_line);
end
