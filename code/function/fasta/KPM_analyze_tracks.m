function XYZUVW = KPM_analyze_tracks(tracks, fps)

    if nargin < 2
        fps = 9 * zeros(max(tracks(:, 4)), 1);
    end

    dt = 1 ./ fps;
    time = [0; cumsum(dt)];

    nPositions = size(tracks, 1);
    velocities = nan(size(tracks));
    velocities(:, 4:5) = tracks(:, 4:5);

    x = tracks(:, 1);
    y = tracks(:, 2);
    z = tracks(:, 3);
    t = time(tracks(:, 4));
    particleID = tracks(:, 5);

    for thisPosition = 2:nPositions
        lastPosition = thisPosition - 1;
        thisParticleID = particleID(thisPosition);
        lastParticleID = particleID(lastPosition);

        if thisParticleID == lastParticleID
            dx = x(thisPosition) - x(lastPosition);
            dy = y(thisPosition) - y(lastPosition);
            dz = z(thisPosition) - z(lastPosition);
            dt = t(thisPosition) - t(lastPosition); % (sec)

            u = dx / dt;
            v = dy / dt;
            w = dz / dt;

            velocities(thisPosition, 1) = u;
            velocities(thisPosition, 2) = v;
            velocities(thisPosition, 3) = w;
        end

    end

    velocities = velocities(~isnan(velocities(:, 1)), :);
    tracks = tracks(~isnan(velocities(:, 1)), :);

    X = tracks(:, 1);
    Y = tracks(:, 2);
    Z = tracks(:, 3);

    U = velocities(:, 1);
    V = velocities(:, 2);
    W = velocities(:, 3);

    %     figure;
    plot3(U, V, W, '.');
    xlabel('U (um/sec)');
    ylabel('V (um/sec)');
    zlabel('W (um/sec)');

    XYZUVW = [X, Y, Z, U, V, W];

end
