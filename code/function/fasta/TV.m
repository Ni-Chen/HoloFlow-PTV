% Evaluate total variation norm
function [tv] = TV(x)
    numdims = ndims(x);
    tv = 0;

    for d = 1:numdims
        shift = zeros(1, numdims);
        shift(d) = 1;
        delta = circshift(x, shift) - x;
        tv = tv + norm(delta(:), 1);
    end

end
