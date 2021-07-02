function [o, outs, opts_tmp] = holo_solver(A, AT, holoFrame, o_in, tau, ratio, opts, u)
    %{
    Solve the L1 penalized least - squares problem
    min mu | x |+ .5 || Ax - b || ^2
    using the solver FASTA.

    Inputs:
    A:A matrix or function handle
    At:The adjoint / transpose of A
    b:A column vector of measurements
    mu:Scalar regularization parameter
    x0:Initial guess of solution, often just a vector of zeros
    opts:Optional inputs to FASTA
    %}

    %%  Define ingredients for FASTA
    % norm = @(x, p) nthroot(sum(abs(x(:))).^p, p);
    % Note: fasta solves min f(Ax) + g(x).
    % f(z) = .5 ||z - b||^2
    f = @(z) .5 * (sum(abs(squeeze(z(:, :, 1, :)) - holoFrame).^2, 'all') ...
             + tau * sum(abs(z(:, :, 2:end, :)).^2, 'all'));
    grad = @(z) cat(3, z(:, :, 1, :) - permute(holoFrame, [1 2 4 3]), z(:, :, 2:end, :));

    % g(z) = mu*|z|
    g = @(x) norm(x(:), 1) * opts.mu;

    % proxg(z, t) = argmin t*mu*|x|+.5||x-z||^2
    prox_input = @(x, t) L1Prox(x, t * opts.mu);

    %% Call solver
    [o, outs, opts_tmp] = fasta(@(x) A_new(x, A, u, tau, ratio), ...
                                @(x) AT_new(x, AT, u, tau, ratio), ...
                                f, grad, g, prox_input, o_in, opts);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = A_new(o, A, u, tau, ratio)
    Bo = cat(4, B(o, u, ratio), zeros(size(o(:, :, :, 1))));
    res = cat(3, permute(A_all(o, A), [1 2 4 3]), sqrt(tau) * Bo);
end

function res = AT_new(b, AT, u, tau, ratio)
    res = AT_all(squeeze(b(:, :, 1, :)), AT) + sqrt(tau) * BT(b(:, :, 2:end, :), u, ratio);
end

function res = BT(o, u, ratio)
    res = zeros(size(o, 1), size(o, 2), size(o, 3), size(o, 4) - 1);

    for t = 1:size(o, 4)
        ut = squeeze(u(:, :, :, t, :));

        if t == 1
            res(:, :, :, t) = Bwarp(o(:, :, :, t), -ut, ratio);
        elseif t == size(o, 4)
            res(:, :, :, t) = -o(:, :, :, t - 1);
        else
            res(:, :, :, t) = Bwarp(o(:, :, :, t), -ut, ratio) - o(:, :, :, t - 1);
        end

    end

end

function res = B(o, u, ratio)
    res = zeros(size(o, 1), size(o, 2), size(o, 3), size(o, 4) - 1);

    for t = 1:size(o, 4) - 1
        ut = squeeze(u(:, :, :, t, :));
        res(:, :, :, t) = Bwarp(o(:, :, :, t), ut, ratio) - o(:, :, :, t + 1);
    end

end

function Bo = Bwarp(o, u, ratio)
    [xx, yy, zz] = meshgrid(1:size(o, 2), 1:size(o, 1), 1:size(o, 3));
    Bo = interp3(xx, yy, zz, o, xx - u(:, :, :, 2), ...
                 yy - u(:, :, :, 1), zz - u(:, :, :, 3) / ratio, 'linear', 0);
end
