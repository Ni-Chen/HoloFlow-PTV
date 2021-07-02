%   Solve the fused lasso regularization problem
%           min  mu1|x|+mu2*TV(x)+.5||Ax-b||^2
%   using the solver FASTA.
%
%  Inputs:
%    A   : A matrix or function handle
%    At  : The adjoint/transpose of A
%    b   : A column vector of measurements
%    mu1 : Scalar L1 regularization parameter
%    mu2 : Scalar total variation regularization parameter
%    x0  : Initial guess of solution, often just a vector of zeros
%    opts: Optional inputs to FASTA
%
%   For this code to run, the solver "fasta.m" must be in your path.
%
%   For more details, see the FASTA user guide, or the paper "A field guide
%   to forward-backward splitting with a FASTA implementation."
%
%   This solution is combination of totalVariation and sparseLeastSquares
%
%   Copyright: Tom Goldstein, 2014 and Kevin Mallery, 2018

function [solution, outs] = fasta_fusedLasso(A, At, b, mu1, mu2, x0, opts)

    %%  Check whether we have function handles or matrices
    if ~isnumeric(A)
        assert(~isnumeric(At), 'If A is a function handle, then At must be a handle as well.')
    end

    %  If we have matrices, create handles just to keep things uniform below
    if isnumeric(A)
        At = @(x)A' * x;
        A = @(x) A * x;
    end

    %  Check for 'opts'  struct
    if ~exist('opts', 'var')% if user didn't pass this arg, then create it
        opts = [];
    end

    %%  Define ingredients for FASTA
    %  Note: fasta solves min f(Ax)+g(x).
    %  f(z) = .5 ||z - b||^2
    f = @(z) .5 * norm(z - b, 'fro')^2;
    grad = @(z) z - b;
    % f    = @(z) .5*norm(b-z,'fro')^2;
    % grad = @(z) b-z;
    % g(z) = mu1*|z| + mu2*TV(z)
    % g = @(x) norm([real(x(:)); imag(x(:))],1)*mu;
    % g = @(x) evaluateNorms(x, mu1, mu2);%norm(x(:),1)*mu1 + TV(x)*mu2;
    g = @(x) norm(x(:), 1) * mu1 + TV(x) * mu2;
    % proxg(z,t) = argmin t*mu*|x|+.5||x-z||^2
    prox = @(x, t) fusedLassoProx(x, t, mu1, mu2, opts);

    %% Call solver
    % [solution, outs] = fasta(A,At,f,grad,g,prox,x0,opts);
    [solution, outs] = fasta_outputing(A, At, f, grad, g, prox, x0, opts);

end

%%  The vector L1Prox operator
function [x] = L1Prox(x, tau)
% prox_g(u) = min_x tau g(x) + 0.5 || x - u ||_2^2 

    if isreal(x)
        x = sign(x).*max(abs(x) - tau, 0);
        x = max(x, 0);
    else
        re = real(x);
        im = imag(x);
        re = sign(re) .* max(abs(re) - tau, 0);
        im = sign(im) .* max(abs(im) - tau, 0);
        % x = sign(x).*max(abs(x) - tau,0);
        x = complex(re, im);
    end
        
end

%% Total variation (first order differential)
% function [ tv ] = TV(x)
%     numdims = ndims(x);
%     tv = 0;
% 
%     for d = 1:numdims
%         shift = zeros(1, numdims);
%         shift(d) = 1;
%         delta = circshift(x, shift) - x;
%         tv = tv + norm(delta(:), 1);
%     end
% 
% end

%% Fused Lasso Proximal Operator
function [ x ] = fusedLassoProx(x, t, mu1, mu2, opts)
    opts2 = opts;
    opts2.maxIters = opts.TV_subproblem_its;
    
    if isreal(x)
        x = L1Prox(x, 0.5*t*mu1); % this is the incorrect placement
        [x, ~ ] = gradproj_totalVariation(x, t*mu2, opts.TV_subproblem_its);
        x = L1Prox(x, 0.5*t*mu1);
    else
        x = L1Prox(x, 0.5 * t * mu1); % this is the incorrect placement
        [rex, ~] = gradproj_totalVariation(real(x), t * mu2, opts.TV_subproblem_its);
        [imx, ~] = gradproj_totalVariation(imag(x), t * mu2, opts.TV_subproblem_its);
        x = complex(rex, imx);
        % [ x, ~ ] = gradproj_totalVariation( x, mu2);
        x = L1Prox(x, 0.5 * t * mu1); % this is the incorrect placement
    end

end


%% Evaluate and save norms
function g = evaluateNorms(x, mu1, mu2)
    L1_norm = norm(x(:), 1) * mu1;
    TV_norm = TV(x) * mu2;

    fid = fopen('norms.csv', 'a');
    fprintf(fid, '%f, %f\n', L1_norm, TV_norm);
    fclose(fid);

    g = L1_norm + TV_norm;
end
