function [otf] = ProjKernel(params)
    pph = params.pps;
    lambda = params.lambda;
    z_list = params.z;
    Ny = params.Ny;
    Nx = params.Nx;

    % Constant frequencies
    % write it this way to avoid fftshifts
    [X, Y] = meshgrid(0:(Nx - 1), 0:(Ny - 1));
    fx = (X - Nx / 2) / Nx;
    fy = (Y - Ny / 2) / Ny;

    term = (fx.^2 + fy.^2) * (lambda / pph)^2;

    %{ 
     rigorous:
        sqrt_input = 1 - term;
        sqrt_input(sqrt_input < 0) = 0;
        final_term = sqrt(sqrt_input);
    %}

    % Fresnel expansion
    final_term =- 1/2 * term - 1/8 * term.^2;

    % Make sure the sign is correct
    otf = arrayfun(@(idx) exp(1i * 2 * pi / lambda * z_list(idx) * final_term), 1:length(z_list), 'un', 0);
    otf = cat(3, otf{:});

end
