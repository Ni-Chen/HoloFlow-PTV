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