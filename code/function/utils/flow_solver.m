function flow = flow_solver(x, f_priors, weight_flow, warping_iters, paras)

    % parsing parameters
    pyramid_level = numel(warping_iters);

    % define scale for all spatial dimensions
    scale = 2;

    % get dimensions
    dim_x = size(x);
    T = dim_x(end); % temporal dimension of volume
    dim_x(end) = [];
    N = numel(dim_x); % spatial dimension of volume

    % generate volume pyramid (multi-scale data)
    o_pyramid = cell(pyramid_level, 1);

    for ip = 1:pyramid_level
        % resize original volume into pyramids
        if N == 2
            tmp_volume = arrayfun(@(t) imresize(x(:, :, t), ...
                round(dim_x ./ scale.^(ip - 1)), 'bilinear'), 1:T, 'un', 0);
        elseif N == 3
            tmp_volume = arrayfun(@(t) imresize3(x(:, :, :, t), ...
                round(dim_x ./ scale.^(ip - 1)), 'linear'), 1:T, 'un', 0);
        end

        tmp_volume = cat(N + 1, tmp_volume{:});
        o_pyramid{ip} = tmp_volume;

        % pre-cache the interpolation coefficients
        %     c = cbanaln(tmp_volume(:,:,:,1));
    end

    % Update deformation field variables
    % From the coarsest scale to the finest
    for ip = pyramid_level:-1:1
        disp(['pyr ' num2str(ip) ':']);

        % get o
        o = o_pyramid{ip};

        % prepare meshgrid
        if N == 2
            [xx, yy] = meshgrid(1:size(o, 2), 1:size(o, 1));
        elseif N == 3
            [xx, yy, zz] = meshgrid(1:size(o, 2), 1:size(o, 1), 1:size(o, 3));
        end

        % warping-scheme
        for iw = 1:warping_iters(ip)
            % warp original o
            if ~(ip == pyramid_level && iw == 1)

                if N == 2
                    o_tmp = cat(N + 1, interp2(o(:, :, 1), xx + flow(:, :, 1), yy + flow(:, :, 2), 'linear', 0), o(:, :, 2));
                elseif N == 3
                    o_tmp = cat(N + 1, interp3(o(:, :, :, 1), xx + flow(:, :, :, 1), yy + flow(:, :, :, 2), zz + flow(:, :, :, 3), 'linear', 0), o(:, :, :, 2));
                end

            else
                o_tmp = o;
            end

            % solve for flow u
            flow_delta = solve_flow(o_tmp, f_priors, weight_flow, paras);

            % update flow u
            mean_delta_u = mean(abs(flow_delta(:)));
            disp(['-- warp ' num2str(iw) ', mean(|\Delta flow|) = ' num2str(mean_delta_u)])

            if ip == pyramid_level && iw == 1
                flow = flow_delta;
            else
                flow = flow + flow_delta;
            end

        end

        % up-sample flow u
        if ip > 1

            if N == 2
                flow = arrayfun(@(t) imresize(flow(:, :, t), round(dim_x ./ scale.^(ip - 2)), 'bilinear'), 1:N, 'un', 0);
            elseif N == 3
                flow = arrayfun(@(t) imresize3(flow(:, :, :, t), round(dim_x ./ scale.^(ip - 2)), 'linear'), 1:N, 'un', 0);
            end

            flow = cat(N + 1, flow{:}) / scale^(N * (ip - 1));
        end

    end

end

% Solve optical flow (Horn-Schunck style)
% min  1/2*|| img0(x+u) - img1(x) ||_2^2 + f_priors(u)
%  u
function u = solve_flow(o, f_priors, weight_flow, paras)
    % compute gradients
    [gt, gs] = partial_deriv(o);

    % add flow function struct to prior functions
    % f_priors(u) = lambda * |grad u|_1 + mu * || grad u||_2^2
    f = [f_priors, fun_flow(weight_flow, gs, gt)];

    % call primal-dual solver
    % [x, records] = primaldual(f, size_x, paras, 'ADMM');
    u = primaldual(f, size(gs), paras, 'ADMM');

    % median filtering on flow
    % N = ndims(o)-1;
    % med_kern = 3*ones([1 N]);
    % if N == 2
    %     u = cat(N+1, medfilt2(u(:,:,1), med_kern, 'symmetric'), ...
    %                  medfilt2(u(:,:,2), med_kern, 'symmetric'));
    % elseif N == 3
    %     u = cat(N+1, medfilt3(u(:,:,:,1), med_kern, 'replicate'), ...
    %                  medfilt3(u(:,:,:,2), med_kern, 'replicate'), ...
    %                  medfilt3(u(:,:,:,3), med_kern, 'replicate'));
    % end
end

function [gt, gs] = partial_deriv(o)
    % spatial gradient kernel
    h = [-1 0 1]';

    N = ndims(o) - 1;

    if N == 2
        % "temporal" gradient
        gt = o(:, :, 2) - o(:, :, 1);

        % spatial gradient
        img1 = o(:, :, 1);
        gx = imfilter(img1, h, 'replicate');
        gy = imfilter(img1, h', 'replicate');
        gs = cat(N + 1, gx, gy);

    elseif N == 3
        % "temporal" gradient
        gt = o(:, :, :, 2) - o(:, :, :, 1);

        % spatial gradient
        img1 = o(:, :, :, 1);
        gx = imfilter(img1, h, 'replicate');
        gy = imfilter(img1, h', 'replicate');
        gz = imfilter(img1, permute(h, [3 2 1]), 'replicate');
        gs = cat(N + 1, gx, gy, gz);
    end

end

function out = cbinterp(c, r)

    % calculate movements
    pr = floor(r);
    fr = r - floor(x);

    % define 1D device functions
    w0 = @(a) (1/6) * (a .* (a .* (-a + 3) - 3) + 1);
    w1 = @(a) (1/6) * (a .* a .* (3 * a - 6) + 4);
    w2 = @(a) (1/6) * (a .* (a .* (-3 * a + 3) + 3) + 1);
    w3 = @(a) (1/6) * (a .* a .* a);
    r = @(x, c0, c1, c2, c3) c0 .* w0(x) + c1 .* w1(x) + c2 .* w2(x) + c3 .* w3(x);

    % define texture function
    % tex = @(y,x) interp2(c,x,y,'nearest',0);
    tex = @(z, y, x) interp3(c, x, y, z, 'nearest', 0);

    % elementwise lookup
    % for ip = 1:3
    %     out = r(out);
    % end
    out = r(fy, ...
        r(fx, tex(px - 1, py - 1), tex(px, py - 1), tex(px + 1, py - 1), tex(px + 2, py - 1)), ...
        r(fx, tex(px - 1, py), tex(px, py), tex(px + 1, py), tex(px + 2, py)), ...
        r(fx, tex(px - 1, py + 1), tex(px, py + 1), tex(px + 1, py + 1), tex(px + 2, py + 1)), ...
        r(fx, tex(px - 1, py + 2), tex(px, py + 2), tex(px + 1, py + 2), tex(px + 2, py + 2)));

end

function c = cbanal(x)

    % A = toeplitz([4 1 zeros(1,m-2)]) / 6;

    c = zeros(size(x));

    for ip = 1:size(x, ndims(x))
        %     c(:,ip) = A \ y(:,ip);
        c(:, :, ip) = 6 * tridisolve(x(:, :, ip));
    end

end

function c = cbanaln(x)
    c = x;

    for ip = [3 2 1]
        c = permute(cbanal(c), [3 1 2]);
    end

end

function x = tridisolve(d)

    % initialize
    x = d;

    % get length
    m = length(x);

    % define a, b and c
    b = 4 * ones(m, 1);

    % forward
    for iw = 1:m - 1
        mu = 1 / b(iw);
        b(iw + 1) = b(iw + 1) - mu;
        x(iw + 1) = x(iw + 1) - mu * x(iw);
    end

    % backward
    x(m) = x(m) / b(m);

    for iw = m - 1:-1:1
        x(iw) = (x(iw) - x(iw + 1)) / b(iw);
    end

end
