function [p_centroid, p_size] = show_particle(vol, p_color, alpha)

    bw = bwconncomp(vol > 0.05, 6);
%     bw = bwconncomp(vol > 0.2, 6);
    props = regionprops3(bw, vol, 'WeightedCentroid', 'Volume', 'PrincipalAxisLength', 'Orientation');

    num_props = size(props, 1);

    p_centroid = cat(1, props.WeightedCentroid);
    p_size = props.PrincipalAxisLength;
    direc = props.Orientation;

    fprintf('Number of objects segmented: %d\n', num_props);

    
    for idx = 1:num_props
%         elli = [p_centroid(idx, :) [min(p_size(idx, :)) / 2 min(p_size(idx, :)) / 2 min(p_size(idx, :)) / 2] direc(idx, :)];
        elli = [p_centroid(idx, :) p_size(idx, :) / 2 direc(idx, :)];

        [X, Y, Z] = drawEllipsoid(elli, 'FaceColor', p_color);
        h = surf(X, Y, Z);
        set(h, 'FaceColor', p_color, 'FaceAlpha', alpha, 'FaceLighting', 'gouraud', 'EdgeColor', 'none');

        hold on;
    end

end
