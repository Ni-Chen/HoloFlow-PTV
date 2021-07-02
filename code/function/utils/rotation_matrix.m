function R = rotation_matrix(theta, axis)

    if nargin < 2
        axis = 'x';
    end

    Rx = [1 0 0;
        0 cos(theta) -sin(theta);
        0 sin(theta) cos(theta)];

    Ry = [cos(theta) 0 sin(theta);
        0 1 0;
        -sin(theta) 0 cos(theta)];

    Rz = [cos(theta) -sin(theta) 0;
        sin(theta) cos(theta) 0;
        0 0 1];

    switch axis
        case 'x'
            R = Rx;
        case 'y'
            R = Ry;
        case 'z'
            R = Rz;
        otherwise
            R = Rz * Ry * Rx;
    end

end
