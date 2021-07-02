function [x, y, newz] = avefilter(x, y, z, filtersize)

    newx = x;
    newy = y;
    newz = z;

    N = length(x);
    buffer = ceil(filtersize / 2);
    buffx = [repmat(x(1), buffer, 1); x; repmat(x(end), buffer, 1)];
    buffy = [repmat(y(1), buffer, 1); y; repmat(y(end), buffer, 1)];
    buffz = [repmat(z(1), buffer, 1); z; repmat(z(end), buffer, 1)];

    % for n = buffer:(length(x)-buffer)
    %     newx(n) = mean(x((n-buffer+1):(n+buffer-1)));
    %     newy(n) = mean(y((n-buffer+1):(n+buffer-1)));
    %     newz(n) = mean(z((n-buffer+1):(n+buffer-1)));
    % end

    for n = 1:length(x)
        i = n + buffer;
        newx(n) = mean(buffx((i - buffer + 1):(i + buffer - 1)));
        newy(n) = mean(buffy((i - buffer + 1):(i + buffer - 1)));
        newz(n) = mean(buffz((i - buffer + 1):(i + buffer - 1)));
    end

end
