function to_paraview(flow_ori, scale, file_name)
    udims = ceil(size(flow_ori) * scale);
    udims(end) = [];

    [x, y, z] = meshgrid(1:udims(2), 1:udims(1), 1:udims(3));
    flow = arrayfun(@(i) imresize3(flow_ori(:, :, :, i), udims), 1:size(flow_ori, ndims(flow_ori)), 'un', 0);

    u = flow{2};
    v = flow{1};
    w = flow{3};

    [cu, cv, cw] = curl(x, y, z, u, v, w);
    div = divergence(x, y, z, u, v, w);

    vtkwrite(file_name, 'structured_grid', x, y, z, ...
        'vectors', 'vector_field', u, v, w, 'vectors', ...
        'vorticity', cu, cv, cw, 'scalars', ...
        'divergence', div);

end
