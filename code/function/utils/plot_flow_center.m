function plot_flow_center(u, direction, scale)
    udims = ceil(size(u) * scale);
    udims(end) = [];
    u = arrayfun(@(i) imresize3(u(:, :, :, i), udims), 1:size(u, ndims(u)), 'un', 0);
    u = cat(size(u, ndims(u)) + 1, u{:});

    Nu = size(u);
    u_slice = zeros(Nu);

    switch direction
        case 'xy'
            %             slice_num =  round(Nu(3)/4);
            %             u_slice(:, :, slice_num, 1) = u(:, :, slice_num, 1);
            %             u_slice(:, :, slice_num, 2) = u(:, :, slice_num, 2);

            slice_num = round(Nu(3) / 2);
            u_slice(:, :, slice_num, 1) = u(:, :, slice_num, 1);
            u_slice(:, :, slice_num, 2) = u(:, :, slice_num, 2);

            %             slice_num =  round(Nu(3)/4*3);
            %             u_slice(:, :, slice_num, 1) = u(:, :, slice_num, 1);
            %             u_slice(:, :, slice_num, 2) = u(:, :, slice_num, 2);
        case 'xz'
            slice_num = round(Nu(1) / 2);
            u_slice(slice_num, :, :, 2) = u(slice_num, :, :, 2);
            u_slice(slice_num, :, :, 3) = u(slice_num, :, :, 3);

            %             slice_num = round(Nu(1) / 4*3);
            %             u_slice(slice_num, :, :, 2) = u(slice_num, :, :, 2);
            %             u_slice(slice_num, :, :, 3) = u(slice_num, :, :, 3);
        case 'yz'
            slice_num = round(Nu(2) / 2);
            u_slice(:, slice_num, :, 1) = u(:, slice_num, :, 1);
            u_slice(:, slice_num, :, 3) = u(:, slice_num, :, 3);

            %             slice_num = round(Nu(2) / 4*3);
            %             u_slice(:, slice_num, :, 1) = u(:, slice_num, :, 1);
            %             u_slice(:, slice_num, :, 3) = u(:, slice_num, :, 3);
        case 'xyz'
            slice_num = round(Nu(3) / 2);
            u_slice(:, :, slice_num, 1) = u(:, :, slice_num, 1);
            u_slice(:, :, slice_num, 2) = u(:, :, slice_num, 2);

            slice_num = round(Nu(1) / 2);
            u_slice(slice_num, :, :, 2) = u(slice_num, :, :, 2);
            u_slice(slice_num, :, :, 3) = u(slice_num, :, :, 3);

            slice_num = round(Nu(2) / 2);
            u_slice(:, slice_num, :, 1) = u(:, slice_num, :, 1);
            u_slice(:, slice_num, :, 3) = u(:, slice_num, :, 3);
    end

    %     figure('units','normalized','outerposition',[0 0 0.4 0.6]);

    plot_flow((u_slice), 1); %axis equal;
    %view(-0,90);

end
