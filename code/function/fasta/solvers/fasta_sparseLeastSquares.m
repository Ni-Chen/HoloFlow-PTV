%   Solve the L1 penalized least-squares problem
%           min  mu|x|+.5||Ax-b||^2
%   using the solver FASTA.  
%
%  Inputs:
%    A   : A matrix or function handle
%    At  : The adjoint/transpose of A
%    b   : A column vector of measurements
%    mu  : Scalar regularization parameter
%    x0  : Initial guess of solution, often just a vector of zeros
%    opts: Optional inputs to FASTA
%
%   For this code to run, the solver "fasta.m" must be in your path.
%
%   For more details, see the FASTA user guide, or the paper "A field guide
%   to forward-backward splitting with a FASTA implementation."
%
%   Copyright: Tom Goldstein, 2014.

function [ solution, outs ] = fasta_sparseLeastSquares( A,At,b,mu,x0,opts )

    %%  Check whether we have function handles or matrices
    if ~isnumeric(A)
        assert(~isnumeric(At),'If A is a function handle, then At must be a handle as well.')
    end
    %  If we have matrices, create handles just to keep things uniform below
    if isnumeric(A)
        At = @(x)A'*x;
        A = @(x) A*x;
    end

    %  Check for 'opts'  struct
    if ~exist('opts','var') % if user didn't pass this arg, then create it
        opts = [];
    end


    %%  Define ingredients for FASTA
    % norm = @(x, p) nthroot(sum(abs(x(:))).^p, p);
    %  Note: fasta solves min f(Ax) + g(x).    
    %  f(z) = .5 ||z - b||^2
    f    = @(z) .5*norm(z(:)-b(:))^2;  
    grad = @(z) z - b;
    

    % g(z) = mu*|z|
    g = @(x) norm(x(:),1)*mu;
    
    
    % proxg(z, t) = argmin t*mu*|x|+.5||x-z||^2
    prox_input = @(x,t) shrink(x, t*mu);

    %% Call solver
    [solution, outs] = fasta(A, At, f, grad, g, prox_input, x0, opts);
end



%%  The vector shrink operator
function [x] = shrink(x, tau)
% prox_g(u) = min_x tau g(x) + 0.5 || x - u ||_2^2 

    if isreal(x)
        x = sign(x).*max(abs(x) - tau, 0);
        x = max(x, 0);


        % Energy conservation
%         mag = abs(x);
%         ph = angle(x);
%         absorp = -log(mag);
% 
%         absorp(absorp<0) = 0;
%         ph(absorp<0) = 0;
%         mag = exp(-absorp);
%         x = mag.*exp(1i*ph);

    else
        mag = abs(x);
        
        % Energy conservation
%         mag = abs(x);
%         ph = angle(x);
%         absorp = -log(mag);
% 
%         absorp(absorp<0) = 0;
%         ph(absorp<0) = 0;
%         mag = exp(-absorp);
%         x = mag.*exp(1i*ph);
        

        % x = a + bi
        a = real(x);
        
%         a = max(a, 0);
        
        b = imag(x);

        a2 = (1 - tau./mag).*a;
        b2 = (1 - tau./mag).*b;

        idx = mag > tau;
        %     mag = sqrt(a2.^2 + b2.^2);
        %     idx = (mag >= tau) & (mag <= tau + 1);
%         a2( a2<0 ) = 0;

        x(idx) = complex(a2(idx), b2(idx));
        
        x(~idx) = 0;
    end
        
end


% function [ x ] = shrink( x, tau )
%     S = @(x) sign(x).*max(x - tau,0);
% 
% %     x = real(x);
% 
%     % Energy conservation
%     mag = abs(x);
%     ph = angle(x);
%     absorp = -log(mag);
%     
%     absorp(absorp<0) = 0;
%     ph(absorp<0) = 0;
%     mag = exp(-absorp);
%     
%     x = mag.*exp(1i*ph);
% 
%     % L1 norm for sparsity
%     re = real(x);
%     im = imag(x);
%     re = S(re);
%     im = S(im);
% 
%     % real(x) is in [0 1]
%     re = max(re, 0);
%     re = min(re, 1);
%     
%     x = complex(re, im);    
% %     x = re;
% end





