function show_particle_2d(vol, p_color, lw, plane_name)
    [Ny, Nx, Nz] = size(vol);

    switch plane_name
        case 'xy'

            for ip = 1:Nz
                xy_plane = squeeze(vol(:, :, ip));
                bw = bwconncomp(xy_plane > 0.01, 4);
                props = regionprops('table', bw, xy_plane, 'WeightedCentroid', 'MajorAxisLength', 'MinorAxisLength');

                if ~isempty(props)
                    num_props = size(props, 1);
                    p_centroid = cat(1, props.WeightedCentroid);

                    for idx = 1:num_props
                        h = drawellipse('Center', [p_centroid(idx, 1), p_centroid(idx, 2)], ...
                            'SemiAxes', [props.MinorAxisLength(idx) / 2, props.MajorAxisLength(idx) / 2], ...
                            'Color', p_color, ...
                            'LineWidth', lw, ...
                            'MarkerSize', 0.0001, ...
                            'FaceAlpha', 0., ...
                            'FaceSelectable', false, ...
                            'HandleVisibility', 'off', ...
                            'InteractionsAllowed', 'none', ...
                            'StripeColor', p_color);

                        h.FaceAlpha = 0.;

                        hold on;
                    end

                end

            end

        case 'xz'

            for ip = 1:Ny
                xy_plane = squeeze(vol(ip, :, :));
                bw = bwconncomp(xy_plane > 0.01, 4);
                props = regionprops('table', bw, xy_plane, 'WeightedCentroid', 'MajorAxisLength', 'MinorAxisLength');

                if ~isempty(props)
                    num_props = size(props, 1);
                    p_centroid = cat(1, props.WeightedCentroid);

                    for idx = 1:num_props
                        h = drawellipse('Center', [p_centroid(idx, 2), p_centroid(idx, 1)], ...
                            'SemiAxes', [props.MinorAxisLength(idx) / 2, props.MajorAxisLength(idx) / 2], ...
                            'Color', p_color, ...
                            'LineWidth', 1, ...
                            'MarkerSize', 0.01, ...
                            'FaceAlpha', 0., ...
                            'FaceSelectable', false, ...
                            'HandleVisibility', 'off', ...
                            'InteractionsAllowed', 'none', ...
                            'StripeColor', p_color);

                        h.FaceAlpha = 0.;

                        hold on;
                    end

                end

            end

    end

end
