function [obj3d_seq] = flow3d(Nxy, Nz, Np, sr, nframe, total_degrees, opt, direction)
    % demo
    if nargin == 0
        rng('default');
        addpath(genpath('./function/'));
        disp('Generating multi-frame 2D particle images ...');

        % Parameters of the 3D object
        Nxy = 256; % lateral size, Nx=Ny
        Nz = 1; % axial size
        Np = 1; % number of particles
        point_size = 5; % pixel size of one random point (half radius)

        N_frame = 36; % number of frames
        total_degrees = 360;

        % Generate 3D volume frames
        flow_sample = flow3d(Nxy, Nz, Np, point_size, N_frame, total_degrees, 'gaussian', 'z');
        flow_sample = squeeze(flow_sample);
        figure; show3d(flow_sample, 0);
        zlabel('frames', 'fontsize', 14);
        disp('Done');
        return;
    end

    % randomly pick positions in the volume
    pad_size = round([4 4 10]);
    pos = bsxfun(@times, rand(Np, 3), [Nxy Nxy Nz] - 2 * pad_size);
    pos = round(pos + pad_size - [Nxy Nxy Nz] / 2);

    [pos, ~, ~] = unique(pos(:, 1:3), 'rows');

    % reject neighboring particles
    t = sum(squareform(pdist(pos)) < 2 * sr, 1) - 1;
    pos(logical(t(1:round(size(pos, 1) / 2))), :) = [];

    % rotation matrix
    % define angles theta [rad]
    theta = linspace(0, total_degrees / 180 * pi, nframe + 1);
    theta(end) = [];
    R_xyz = arrayfun(@(x) rotation_matrix(x, direction), theta, 'un', 0);

    % particle radius (units of [voxels]), rotation
    pos_new = cellfun(@(R) R * pos', R_xyz, 'un', 0);

    % generate volume with new coordinates
    obj3d_seq = zeros(Nxy, Nxy, Nz, nframe);

    for idx_f = 1:nframe
        obj3d_seq(:, :, :, idx_f) = particle_fun(pos_new{idx_f}, Nxy, Nxy, Nz, sr, opt);
    end

end

function vol = particle_fun(p, Nx, Ny, Nz, sr, type)
    vol = zeros(Nx, Ny, Nz);
    s = 1; % up-sampling factor

    [x, y, z] = meshgrid(linspace(0, Nx, Nx * s), linspace(0, Ny, Ny * s), linspace(0, Nz, Nz * s));
    x = x - mean(x(:));
    y = y - mean(y(:));
    z = z - mean(z(:));

    switch type
        case 'solid'
            to_volume = @(r2) solid(r2, sr);
        case 'gaussian'
            to_volume = @(r2) gaussian(r2, sr);
    end

    % Down sampling
    for ip = 1:size(p, 2)
        r2 = (x - p(1, ip)).^2 + (y - p(2, ip)).^2 + (z - p(3, ip)).^2;
        tmp = to_volume(r2);
        tmp = reshape(tmp, s, Nx, s, Ny, s, Nz);

        for dim = [5 3 1]
            tmp = sum(tmp, dim);
        end

        vol = vol + squeeze(tmp);
    end

    vol(vol > 1) = 1;
end

% actual particle functions
function vol = solid(r2, sr)
    vol = double(r2 <= sr^2);
end

function vol = gaussian(r2, sr)
    vol = exp(-r2 / sr);
end
