function plot_flow_exp(u_ori, scale, c_lim, map)

    if nargin < 3
        scale = 1;
        map = jet(256);
    elseif nargin < 4
        map = jet(256);
    end

    udims = ceil([size(u_ori, 1) * scale(1), size(u_ori, 2) * scale(2), size(u_ori, 3) * scale(3), size(u_ori, 4)]);

    udims(end) = [];

    [x, y, z] = meshgrid(1:udims(2), 1:udims(1), 1:udims(3));
    uscale = 1;

    u = arrayfun(@(i) imresize3(u_ori(:, :, :, i), udims), 1:size(u_ori, ndims(u_ori)), 'un', 0);

    q = quiver3(x, y, z, u{2}, u{1}, u{3}, uscale, 'linewidth', 2);

    mags = sqrt(sum(cat(2, q.UData(:), q.VData(:), reshape(q.WData, numel(q.UData), [])).^2, 2));

    %// Get the current colormap
    currentColormap = colormap(map);

    %// Now determine the color to make each arrow using a colormap
    [~, ~, ind] = histcounts(mags, size(currentColormap, 1));

    %// Now map this to a colormap to get RGB
    cmap = uint8(ind2rgb(ind(:), currentColormap) * 255);
    cmap(:, :, 4) = 255;
    cmap = permute(repmat(cmap, [1 3 1]), [2 1 3]);

    %// We repeat each color 3 times (using 1:3 below) because each arrow has 3 vertices
    set(q.Head, 'ColorBinding', 'interpolated', 'ColorData', reshape(cmap(1:3, :, :), [], 4).');

    %// We repeat each color 2 times (using 1:2 below) because each tail has 2 vertices
    set(q.Tail, 'ColorBinding', 'interpolated', 'ColorData', reshape(cmap(1:2, :, :), [], 4).');

    set(q, 'AutoScale', 'on', 'AutoScaleFactor', 1.5);

    axis image;
    set(gca, 'FontSize', 16);
    xlabel('x (pixel)', 'Rotation', 20);
    ylabel('y (pixel)', 'Rotation', -40);
    zlabel('z (pixel)');

    box on,
    ax = gca;
    ax.BoxStyle = 'full';

    h = colorbar('Location', 'east', 'AxisLocation', 'out');
    %     h = colorbar('Location','north', 'AxisLocation','out');
    %     h.Label.String = 'Norm of velocity (pixel / time unit)';
    set(get(h, 'label'), 'string', 'Norm of velocity (pixel / time unit)', 'FontSize', 18);
    %     set(gca, 'CLim', [min(mags), max(mags)]);
    set(gca, 'CLim', c_lim);
    t = get(h, 'Limits');
    set(h, 'Ticks', [t(1), t(1) + (t(2) - t(1)) / 2, t(2)], ...
        'TickLabels', {floor(t(1) * 100) / 100, round((t(1) + (t(2) - t(1)) / 2) * 100) / 100, round(t(2) * 100) / 100});

    set(h, 'position', [0.85, 0.27, 0.042666666666667, 0.47])
    %     set(h,'position',[0.299333333333333,0.819000000000001,0.5,0.042666666666667])
    %     axis image;

    xticks([1 udims(2) / 2 udims(2)]);
    yticks([1 udims(1) / 2 udims(1)]);
    zticks([1 udims(3) / 2 udims(3)]);

    udims_ori = ceil(size(u_ori));
    udims_ori(end) = [];
    x_tick = 1:udims_ori(2);
    y_tick = 1:udims_ori(1);
    z_tick = 1:udims_ori(3);

    x_ticks = {min(x_tick), floor(min(x_tick) + (max(x_tick) - min(x_tick)) / 2), max(x_tick)};
    set(gca, 'xticklabels', (x_ticks));
    y_ticks = {min(y_tick), floor(min(y_tick) + (max(y_tick) - min(y_tick)) / 2), max(y_tick)};
    set(gca, 'yticklabels', (y_ticks));
    z_ticks = {min(z_tick), floor(min(z_tick) + (max(z_tick) - min(z_tick)) / 2), max(z_tick)};
    set(gca, 'zticklabels', (z_ticks));

    xlim([1 udims(2)])
    ylim([1 udims(1)])
    zlim([1 udims(3)])
    
    
%     campos([51.3762210345164 27.2208719731299 35.5061587157123])
%     camup([-0.313910735661509 0.927104210994165 -0.204787284745264])
%     camva(11.1975163738532)
%     
%     xlabel(['x (', 'pixel', ')'], 'Rotation', -28, 'Position', [4.014338501951813,9.707903295302247,0.482713213813469]);
%     ylabel(['y (', 'pixel', ')'], 'Rotation', 90, 'Position', [8.580201447460299,4.603861100317403,0.046722203337026]);
%     zlabel(['z (', 'pixel', ')'], 'Rotation', 10, 'Position', [8.360396071111724,-0.361887386187163,4.953111907259513]);


%     campos([73.7027169502625 34.9705424825407 54.4253994062526])
%     camup([-0.256605651244063 0.948657254680968 -0.184940403619054])
%     camva(10.8652830631584)
%     
%     xlabel(['x (', 'pixel', ')'], 'Rotation', -28, 'Position', [6.691597379761278,15.020689892250932,0.294095049001157]);
%     ylabel(['y (', 'pixel', ')'], 'Rotation', 90, 'Position', [14.037579749228872,7.053466769490152,-0.388400162583679]);
%     zlabel(['z (', 'pixel', ')'], 'Rotation', 10, 'Position', [13.216975928054598,-0.509063616671057,4.044648326045377]);

end

function mat_rs = resize(varargin)
    %RESIZE     Resize a matrix.

    % DESCRIPTION:
    %       Resize a matrix to a given size using interp2 (2D) or interp3
    %       (3D).
    %       Use interpolation to redivide the [0,1] interval into Nx, Ny, Nz
    %       voxels, where 0 is the center of first voxel, and 1 is the center
    %       of the last one.
    %
    % USAGE:
    %       mat_rs = resize(mat, new_size)
    %       mat_rs = resize(mat, new_size, interp_mode)
    %
    % INPUTS:
    %       mat         - matrix to resize
    %       new_size    - desired matrix size in elements given by [Nx, Ny] in
    %                     2D and [Nx, Ny, Nz] in 3D. Here Nx is the number of
    %                     elements in the row direction, Ny is the number of
    %                     elements in the column direction, and Nz is the
    %                     number of elements in the depth direction.
    %
    % OPTIONAL INPUTS:
    %       interp_mode - interpolation mode used by interp2 and interp3
    %                     (default = '*linear')
    %
    % OUTPUTS:
    %       mat_rs      - resized matrix

    % check the inputs for release B.0.2 compatability
    if length(varargin{2}) == 1 && nargin >= 3 && length(varargin{3}) == 1

        % display warning message
        disp('WARNING: input usage deprecated, please see documentation.');
        disp('In future releases this usage will no longer be functional.');

        % recursively call resize with the correct inputs
        if nargin == 3
            mat_rs = resize(varargin{1}, [varargin{2}, varargin{3}]);
        else
            mat_rs = resize(varargin{1}, [varargin{2}, varargin{3}], varargin{4});
        end

        return

    end

    % % update command line status
    % disp('Resizing matrix...');

    % assign the matrix input
    mat = varargin{1};

    % check for interpolation mode input
    if nargin == 2
        interp_mode = '*linear';
    elseif nargin ~= 3
        error('incorrect number of inputs');
    else
        interp_mode = varargin{3};
    end

    % check inputs
    if ndims(mat) ~= length(varargin{2})
        error('resolution input must have the same number of elements as data dimensions');
    end

    switch ndims(mat)
        case 2
            % extract the original number of pixels from the size of the matrix
            [Nx_input, Ny_input] = size(mat);

            % extract the desired number of pixels
            Nx_output = varargin{2}(1);
            Ny_output = varargin{2}(2);

            % update command line status
            disp(['  input grid size: ' num2str(Nx_input) ' by ' num2str(Ny_input) ' elements']);
            disp(['  output grid size: ' num2str(Nx_output) ' by ' num2str(Ny_output) ' elements']);

            % check the size is different to the input size
            if Nx_input ~= Nx_output || Ny_input ~= Ny_output

                % resize the input matrix to the desired number of pixels
                mat_rs = interp2(0:1 / (Ny_input - 1):1, (0:1 / (Nx_input - 1):1)', mat, 0:1 / (Ny_output - 1):1, (0:1 / (Nx_output - 1):1)', interp_mode);

            else
                mat_rs = mat;
            end

        case 3

            % extract the original number of pixels from the size of the matrix
            [Nx_input, Ny_input, Nz_input] = size(mat);

            % extract the desired number of pixels
            Nx_output = varargin{2}(1);
            Ny_output = varargin{2}(2);
            Nz_output = varargin{2}(3);

            %     % update command line status
            %     disp(['  input grid size: ' num2str(Nx_input) ' by ' num2str(Ny_input) ' by ' num2str(Nz_input) ' elements']);
            %     disp(['  output grid size: ' num2str(Nx_output) ' by ' num2str(Ny_output) ' by ' num2str(Nz_output) ' elements']);

            % create normalised plaid grids of current discretisation
            [x_mat, y_mat, z_mat] = ndgrid((0:Nx_input - 1) / (Nx_input - 1), (0:Ny_input - 1) / (Ny_input - 1), (0:Nz_input - 1) / (Nz_input - 1));

            % create plaid grids of desired discretisation
            [x_mat_interp, y_mat_interp, z_mat_interp] = ndgrid((0:Nx_output - 1) / (Nx_output - 1), (0:Ny_output - 1) / (Ny_output - 1), (0:Nz_output - 1) / (Nz_output - 1));

            % compute interpolation; for a matrix indexed as [M, N, P], the
            % axis variables must be given in the order N, M, P
            mat_rs = interp3(y_mat, x_mat, z_mat, mat, y_mat_interp, x_mat_interp, z_mat_interp);

        otherwise
            error('input matrix must be 2 or 3 dimensional');
    end

end
