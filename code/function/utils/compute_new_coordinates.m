function [Xq, Yq, Zq] = compute_new_coordinates(R, x, y, z)

    dim = size(x);
    tmp = permute(cat(4, x, y, z), [4 1 2 3]);
    new_coordinate = R * reshape(tmp, [3, numel(x)]);
    new_coordinate = reshape(new_coordinate, [3 dim]);
    new_coordinate = permute(new_coordinate, [2 3 4 1]);

    Xq = new_coordinate(:, :, :, 1);
    Yq = new_coordinate(:, :, :, 2);
    Zq = new_coordinate(:, :, :, 3);
end
