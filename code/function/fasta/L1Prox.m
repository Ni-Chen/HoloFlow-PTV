%%  The vector L1Prox operator
function [x] = L1Prox(x, tau)
    % prox_g(u) = min_x tau g(x) + 0.5 || x - u ||_2^2

    if isreal(x)
        x = sign(x) .* max(abs(x) - tau, 0);
        x = max(x, 0);

    else
        mag = abs(x);

        % x = a + bi
        a = real(x);
        b = imag(x);

        a2 = (1 - tau ./ mag) .* a;
        b2 = (1 - tau ./ mag) .* b;

        a2 = max(a2, 0);

        idx = mag > tau;
        %     mag = sqrt(a2.^2 + b2.^2);
        %     idx = (mag >= tau) & (mag <= tau + 1);
        %         a2( a2<0 ) = 0;

        x(idx) = complex(a2(idx), b2(idx));

        x(~idx) = 0;
    end

end
