function obj3d = randomScatter(Nxy, Nz, Np, sr, N_pad)
    %{
    ------------------------------------------------
    Generates randomly distributed particle volume

    Inputs:
    sr - > radius of one single scatter

    Example:
    im = randomScatter(128, 128, 20, 1);

    Copyright (C) 2019, Ni Chen, nichen@snu.ac.kr
    ------------------------------------------------
    %}

    obj3d = zeros(Nxy, Nxy, Nz);

    Nxy_pad = Nxy - 2 * N_pad;

    for ip = 1:Np
        ix = ceil(rand(1) * Nxy_pad);
        iy = ceil(rand(1) * Nxy_pad);
        iz = ceil(rand(1) * Nz);

        ix_range = ix:ix + sr;
        iy_range = iy:iy + sr;
        %         iz_range = iz:iz+sr;
        iz_range = iz;

        ix_range(ix_range > Nxy_pad) = Nxy_pad;
        iy_range(iy_range > Nxy_pad) = Nxy_pad;
        iz_range(iz_range > Nz) = Nz;

        ix_range = ix_range + N_pad;
        iy_range = iy_range + N_pad;

        obj3d(iy_range, ix_range, iz_range) = 1; % rand(1)
    end

end
