function vol = pos2scatter(pos, dims)

    pos = round(pos);
    vol = zeros(dims);

    for ip = 1:size(pos, 1)
        vol(pos(ip, 1), pos(ip, 2), pos(ip, 3)) = 1;
    end

end
