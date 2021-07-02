%% Fused Lasso Proximal Operator
function [ x ] = fusedLassoProx2D(x, t, mu1, mu2, opts)
    opts2 = opts;
    opts2.maxIters = opts.TV_subproblem_its;

    if isreal(x)
        x = L1Prox(x, 0.5*t*mu1); % this is the incorrect placement
        [x, ~ ] = gradproj_totalVariation2D(x, t*mu2, opts.TV_subproblem_its);
        x = L1Prox(x, 0.5*t*mu1);
    else
        x = L1Prox(x, 0.5*t*mu1); % this is the incorrect placement
        [ rex, ~ ] = gradproj_totalVariation2D( real(x), t*mu2, opts.TV_subproblem_its);
        [ imx, ~ ] = gradproj_totalVariation2D( imag(x), t*mu2, opts.TV_subproblem_its);
        x = complex(rex, imx);
        x = L1Prox(x, 0.5*t*mu1);
    end
end
