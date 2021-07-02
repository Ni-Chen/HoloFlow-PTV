function flow = optical_flow(o, opt)
    % check options
    if nargin == 2
        % check option, if not existed, use defaults
        if ~isfield(opt, 'flow')
            opt.flow.warping_iters = [1 1];
            opt.flow.priors = [1e-4 1e-7 1e-4 1e-7];
            opt.flow.ratio = 1;
        end

        if ~isfield(opt, 'cg')
            opt.cg.maxit = 1000;
            opt.cg.tol = 1e-3;
        end

    else % defaults
        opt.flow.warping_iters = [1 1];
        opt.flow.priors = [1e-4 1e-7 1e-4 1e-7];
        opt.flow.ratio = 1;
        opt.cg.maxit = 1000;
        opt.cg.tol = 1e-3;
    end

    % parsing parameters
    pyramid_level = numel(opt.flow.warping_iters);

    % get dimensions (temporal; spatial)
    dim_x = size(o);
    T = dim_x(end);
    dim_x(end) = [];
    N = numel(dim_x);

    % ------------------
    % pyramid parameters
    % ------------------
    % define scale for all spatial dimensions
    scale = 2;

    % down-sampling gaussian kernel
    smooth_sigma = 0.8;

    if N == 2
        g_kern = fspecial('gaussian', 2 * round(1.5 * smooth_sigma) + 1, smooth_sigma);
    elseif N == 3
        %         g_kern = fspecial3('gaussian', 2 * round(1.5 * smooth_sigma) + 1, smooth_sigma);
        g_kern = fspecial3('gaussian', 2 * round(1.5 * smooth_sigma) + 1);
    end

    % ------------------
    % prepare volume pyramid
    o_pyramid = cell(pyramid_level, 1);

    for idx = 1:pyramid_level

        if idx == 1
            tmp = imfilter(o, g_kern, 'replicate');
        else
            tmp = imfilter(o_pyramid{idx - 1}, g_kern, 'replicate');
        end

        % resize original volume into pyramids
        current_size = round(dim_x ./ scale.^(idx - 1));

        if N == 2
            tmp = arrayfun(@(t) imresize(tmp(:, :, t), current_size, 'bicubic'), 1:T, 'un', 0);
        elseif N == 3

            if idx > 1
                tmp = arrayfun(@(t) imresize3(tmp(:, :, :, t), current_size, 'cubic'), 1:T, 'un', 0);
            else
                tmp = arrayfun(@(t) tmp(:, :, :, t), 1:T, 'un', 0);
            end

        end

        disp(sum(abs(tmp{1}(:)), 'all'))
        o_pyramid{idx} = cat(N + 1, tmp{:});
    end

    % initializae flow
    init_flow_size = size(o_pyramid{end});
    init_flow_size(end) = N;
    flow = zeros(init_flow_size);

    % pyramid-scheme
    for idx = pyramid_level:-1:1
        disp(['pyr ' num2str(idx) ':']);

        % get o
        o = o_pyramid{idx};

        % prepare meshgrid
        if N == 2
            [xx, yy] = meshgrid(1:size(o, 2), 1:size(o, 1));
        elseif N == 3
            [xx, yy, zz] = meshgrid(1:size(o, 2), 1:size(o, 1), 1:size(o, 3));
        end

        % warping-scheme
        for j = 1:opt.flow.warping_iters(idx)
            % warp original o
            if ~(idx == pyramid_level && j == 1)

                if N == 2
                    o_tmp = cat(N + 1, interp2(o(:, :, 1), ...
                        xx + flow(:, :, 2), yy + flow(:, :, 1), 'bicubic'), o(:, :, 2));
                elseif N == 3

                    o_tmp = cat(N + 1, ...
                        interp3(xx, yy, zz, o(:, :, :, 1), ...
                        xx + flow(:, :, :, 2), ...
                        yy + flow(:, :, :, 1), ...
                        zz + flow(:, :, :, 3) / opt.flow.ratio, 'cubic', 0), ...
                        o(:, :, :, 2));

                    o_tmp(isnan(o_tmp)) = 0;

                    % medfilt3 are NOT implemented in the GPU version yet!
                    med_kern = repmat(3, [1 N]);
                    o_tmp = cat(N + 1, medfilt3(o_tmp(:, :, :, 1), med_kern), medfilt3(o_tmp(:, :, :, 2), med_kern));
                end

            else
                o_tmp = o;
            end

            % solve for flow u
            flow_delta = solve_flow(o_tmp, opt.flow.priors, opt.cg.tol, opt.cg.maxit);

            % update flow u
            mean_delta_u = mean(abs(flow_delta(:)));
            disp(['-- warp ' num2str(j) ', mean(|\Delta flow|) = ' num2str(mean_delta_u)])

            if mean_delta_u > 0.00%0.05
                flow(:, :, :, 1:2) = flow(:, :, :, 1:2) + flow_delta(:, :, :, 1:2);
                flow(:, :, :, 3) = flow(:, :, :, 3) + flow_delta(:, :, :, 3) * opt.flow.ratio;
            else
                disp('Insignificant \Delta flow; reject adding to total flow')
                break;
            end

        end

        % up-sample flow u
        if idx > 1

            if N == 2
                flow = arrayfun(@(t) imresize(flow(:, :, t), round(dim_x ./ scale.^(idx - 2)), 'bilinear'), 1:N, 'un', 0);
            elseif N == 3
                flow = arrayfun(@(t) imresize3(flow(:, :, :, t), round(dim_x ./ scale.^(idx - 2)), 'cubic'), 1:N, 'un', 0);
            end

            flow = cat(N + 1, flow{:});
        end

    end

end

% Solve optical flow (Horn-Schunck style)
% min  1/2*|| img0(x+u) - img1(x) ||^2 + ||\nabla^2 u ||^2 + \beta ||u||^2
%  u
% priors = (alpha_xy, alpha_z, beta_xy, beta_z)
function u = solve_flow(o, priors, tol, iter)
    % compute gradients
    [gt, gs] = partial_deriv(o);

    % add flow function struct to prior functions
    % f = [f_priors, fun_flow(weight_flow, gs, gt)];

    % call primal-dual solver
    % u = primaldual(f, size(gs), paras, 'ADMM');

    N = ndims(gs);

    if N == 3
        kern = fspecial('laplacian', 0);
    elseif N == 4
        kern = fspecial3('laplacian', 0);
    end

    % if isempty(priors(1))
    %     % matrix norm to decide spatial laplacian weight
    %     priors(1) = min(1e-5, max(abs(sum(gs,N)),[],'all') / min(abs(sum(gs,N)),[],'all'));
    % end
    % if isempty(priors(3))
    %     priors(3)  = 1e-3 * priors(3);
    % end

    % anisotropic parameters
    alpha_f = @(u) cat(4, priors(1) * u(:, :, :, 1:2), priors(2) * u(:, :, :, 3));
    beta_f = @(u) cat(4, priors(3) * u(:, :, :, 1:2), priors(4) * u(:, :, :, 3));

    % construct function handles
    nabla2 = @(x) imfilter(x, kern, 'replicate');
    A = @(u) bsxfun(@times, gs, sum(gs .* u, N)) - alpha_f(nabla2(u)) + beta_f(u); % broadcasting
    b = gs .* gt;

    % call pcg to solve the linear system
    u = pcg_ND(A, b, tol, iter);

    % crop flow to [-1 1]
    u = max(-1, min(u, 1));

    % median filtering on flow
    % (medfilt3 are NOT implemented in the GPU version yet!)
    med_kern = repmat(3, [1 N - 1]);

    if N == 3
        u = cat(N, medfilt2(u(:, :, 1), med_kern, 'symmetric'), medfilt2(u(:, :, 2), med_kern, 'symmetric'));
    elseif N == 4
        u = cat(N, medfilt3(u(:, :, :, 1), med_kern, 'replicate'), ...
            medfilt3(u(:, :, :, 2), med_kern, 'replicate'), ...
            medfilt3(u(:, :, :, 3), med_kern, 'replicate'));
    end

end

function [gt, gs] = partial_deriv(o)
    h = [1 -8 0 8 -1]' / 12;
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
