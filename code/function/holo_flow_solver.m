function [o, u] = holo_flow_solver(b, opts, isGPU, is_verbose)
    %{
    opts:
        .other
            .tau
            .maxit
        .holo
            .fasta
            .flow
    %}
    if nargin < 3
        isGPU = false;
        is_verbose = true;
    elseif nargin < 4
        is_verbose = true;
    end

    global out_dir obj_name my_export;

    % parse options
    params = opts.holo;
    ratio = opts.flow.flow.ratio;

    % create function handles
    otf = ProjKernel(params);
    A = @(volume) real(ForwardProjection(volume, otf));
    AT = @(plane) real(BackwardProjection(plane, otf));

    % initialize o and u
    num_frames = size(b, 3);
    o = zeros(params.Ny, params.Nx, params.Nz, num_frames);
    u = zeros([size(o) 3]);

    % initialize o with backpropagation results
    o = abs(AT_all(b, AT));

    tHolo = 0;
    tFlow = 0;
    for idx = 1:opts.other.maxit
        % Solver of:
        % min ||Ao - b||_2^2 +  1/2*||ot(x+u) - ot(x)||_2^2 + \lambda ||o||_1
        %  o
                
        disp('Particle reconstruction...');

        % o update
        if idx == 1
            tau_holo = 0;
        else
            tau_holo = opts.other.tau;
        end

        tHolo1 = tic;
        [o, outs, opts_tmp] = holo_solver(A, AT, b, o, tau_holo, ratio, opts.fasta, u);
         tHolo = tHolo + toc(tHolo1);
         
        opts_tmp.stopRule = 'iterations';
        opts.fasta = opts_tmp;

        o = normalize(o);

        % Solver of:
        % min 1/2*||o0(x+u) - o1(x)||_2^2 + \lambda ||\nabla u||_1 + \mu ||\nabla u||_2^2
        %  u
        disp('Flow reconstruction...');

        o_temp = o;

        if isGPU
            for t = 1:num_frames - 1
                u(:, :, :, t, :) = -optical_flow_gpu_wrapper(o_temp(:, :, :, t:t + 1), opts.flow);
            end
        else
            for t = 1:num_frames - 1
                u(:, :, :, t, :) = -optical_flow(o_temp(:, :, :, t:t + 1), opts.flow);
            end
        end
        
        % show intermediate figures
        if is_verbose            
            for t = 1:num_frames
                figure('Name', ['o at frame ' num2str(t) ', iter = ' num2str(idx)], 'Position', [100, 100, 400, 500]);
                show3d(o(:, :, :, t), 0); axis equal;
                my_export([out_dir, obj_name, '_holo_flow_recon' num2str(t) '_iter', num2str(idx)]);
            end
            
            for t = 1:num_frames - 1
                u_show = squeeze(u(:, :, :, t, :));
                figure('Name', ['u at frame ' num2str(t) ', iter = ' num2str(idx)], 'Position', [100, 100, 400, 500]);
                plot_flow(u_show, 0.08);
                my_export([out_dir, obj_name, '_holo_flow' num2str(t) '_iter', num2str(idx)]);
            end
                        
            save([out_dir obj_name, '_u_holoflow_iter', num2str(idx), '.mat'], 'u');
            save([out_dir obj_name, '_o_holoflow_iter', num2str(idx), '.mat'], 'o');            
        end
        
    end
    
    disp(['Time cost for the holo-solver is: ' num2str(tHolo) 's'] );
    disp(['Time cost for the flow-solver is: ' num2str(tFlow) 'ms'] );
    disp(['Total Time cost is: ' num2str(tHolo+tFlow/1000) 'ms'] );
end
