function b = A_all(o, A)
    b = zeros(size(o, 1), size(o, 2), size(o, 4));

    for t = 1:size(o, 4)
        b(:, :, t) = A(o(:, :, :, t));
    end

end
