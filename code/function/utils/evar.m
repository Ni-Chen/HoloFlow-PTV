function noisevar = evar(y)
    %EVAR   Noise variance estimation.
    %   Assuming that the deterministic function Y has additive Gaussian noise,
    %   EVAR(Y) returns an estimated variance of this noise.
    %
    %   Note:
    %   ----
    %   A thin-plate smoothing spline model is used to smooth Y. It is assumed
    %   that the model whose generalized cross-validation (GCV) score is
    %   minimal can provide the variance of the additive noise. EVAR
    %   theoretically works better if Y is differentiable. A few tests,
    %   however, showed that EVAR works very well even if some singularities
    %   are present.
    %
    %   Reference
    %   ---------
    %   Garcia D, Robust smoothing of gridded data in one and higher
    %   dimensions with missing values. Computational Statistics & Data
    %   Analysis, 2010;54:1167-1178.
    %   <a
    %   href="matlab:web('http://www.biomecardio.com/publis/csda10.pdf')">download PDF</a>
    %
    %   Examples:
    %   --------
    %   <a
    %   href="matlab:web('http://www.biomecardio.com/matlab/evar_doc.html')">Reference page</a>
    %
    %   %-- 1D signal
    %   n = 1e6; x = linspace(0,100,n);
    %   y = cos(x/10)+(x/50);
    %   var0 = 0.02; % noise variance
    %   yn = y + sqrt(var0)*randn(size(y));
    %   evar(yn) % estimated variance
    %
    %   %-- 2D function
    %   [x,y] = meshgrid(0:.01:1);
    %   f = exp(x+y) + sin((x-2*y)*3);
    %   var0 = 0.04; % noise variance
    %   fn = f + sqrt(var0)*randn(size(f));
    %   evar(fn) % estimated variance
    %
    %   %-- 3D function
    %   [x,y,z] = meshgrid(-2:.05:2);
    %   f = x.*exp(-x.^2-y.^2-z.^2);
    %   var0 = 0.6; % noise variance
    %   fn = f + sqrt(var0)*randn(size(f));
    %   evar(fn) % estimated variance
    %
    %   %-- Actual versus estimated variance
    %   % Create a deterministic signal with 1000 data points
    %   % Add Gaussian noise whose variance ranges between 0 and 0.5
    %   n = 1e3;
    %   x = linspace(0,25,n);
    %   y = round(sin(x));
    %   sig2 = linspace(0,0.5,50);
    %   % Example with a variance of 0.2
    %   yn = y + sqrt(0.2)*randn(1,n);
    %   plot(x,yn,'r',x,y,'k')
    %   % Estimate the variance of the additive noise by using EVAR
    %   sig2_est = zeros(1,50);
    %   for i = 1:50
    %       yn = y + sqrt(sig2(i))*randn(1,n);
    %       sig2_est(i) = evar(yn);
    %   end
    %   % Compare the estimated variance (sig2_est) with the true variance (sig2)
    %   plot(sig2_est,sig2,'o',[0 0.5],[0 0.5],'k')
    %   axis([-0.05 0.55 -0.05 0.55])
    %   axis square
    %   xlabel('Estimated variance')
    %   ylabel('True variance')
    %
    %   Note:
    %   ----
    %   EVAR is only adapted to evenly-gridded 1-D to N-D data.
    %
    %   See also VAR, SMOOTHN
    %
    %   -- Damien Garcia -- 2008/04, last update 2017/08
    %   website: <a
    %   href="matlab:web('http://www.biomecardio.com/en')">www.BiomeCardio.com</a>
    narginchk(1, 1);
    d = ndims(y);
    siz = size(y);
    S = zeros(siz);

    for i = 1:d
        siz0 = ones(1, d);
        siz0(i) = siz(i);
        S = bsxfun(@plus, S, cos(pi * (reshape(1:siz(i), siz0) - 1) / siz(i)));
    end

    S = 2 * (d - S(:));
    % N-D Discrete Cosine Transform of Y
    y = dctn(y);
    y = y(:);
    % Squares
    S = S.^2; y = y.^2;
    % Upper and lower bounds for the smoothness parameter
    N = sum(siz ~= 1); % tensor rank of the y-array
    hMin = 1e-6; hMax = 0.99;
    sMinBnd = (((1 + sqrt(1 + 8 * hMax.^(2 / N))) / 4 ./ hMax.^(2 / N)).^2 - 1) / 16;
    sMaxBnd = (((1 + sqrt(1 + 8 * hMin.^(2 / N))) / 4 ./ hMin.^(2 / N)).^2 - 1) / 16;
    % Minimization of the GCV score
    fminbnd(@func, log10(sMinBnd), log10(sMaxBnd), optimset('TolX', .1));

    function score = func(L)
        % Generalized cross validation score
        M = 1 - 1 ./ (1 + 10^L * S);
        noisevar = mean(y .* M.^2);
        score = noisevar / mean(M)^2;
    end

end

%% DCTN
function y = dctn(y)
    %DCTN N-D discrete cosine transform.
    %   Y = DCTN(X) returns the discrete cosine transform of X. The array Y is
    %   the same size as X and contains the discrete cosine transform
    %   coefficients. This transform can be inverted using IDCTN.
    %
    %   Reference
    %   ---------
    %   Narasimha M. et al, On the computation of the discrete cosine
    %   transform, IEEE Trans Comm, 26, 6, 1978, pp 934-936.
    %
    %   Example
    %   -------
    %       RGB = imread('autumn.tif');
    %       I = rgb2gray(RGB);
    %       J = dctn(I);
    %       imshow(log(abs(J)),[]), colormap(jet), colorbar
    %
    %   The commands below set values less than magnitude 10 in the DCT matrix
    %   to zero, then reconstruct the image using the inverse DCT.
    %
    %       J(abs(J)<10) = 0;
    %       K = idctn(J);
    %       figure, imshow(I)
    %       figure, imshow(K,[0 255])
    %
    %   -- Damien Garcia -- 2008/06, revised 2011/11
    %   -- www.BiomeCardio.com --
    y = double(y);
    sizy = size(y);
    y = squeeze(y);
    dimy = ndims(y);
    % Some modifications are required if Y is a vector
    if isvector(y)
        dimy = 1;
        if size(y, 1) == 1, y = y.'; end
    end

    % Weighting vectors
    w = cell(1, dimy);

    for dim = 1:dimy
        n = (dimy == 1) * numel(y) + (dimy > 1) * sizy(dim);
        w{dim} = exp(1i * (0:n - 1)' * pi / 2 / n);
    end

    % --- DCT algorithm ---
    if ~isreal(y)
        y = complex(dctn(real(y)), dctn(imag(y)));
    else

        for dim = 1:dimy
            siz = size(y);
            n = siz(1);
            y = y([1:2:n 2 * floor(n / 2):-2:2], :);
            y = reshape(y, n, []);
            y = y * sqrt(2 * n);
            y = ifft(y, [], 1);
            y = bsxfun(@times, y, w{dim});
            y = real(y);
            y(1, :) = y(1, :) / sqrt(2);
            y = reshape(y, siz);
            y = shiftdim(y, 1);
        end

    end

    y = reshape(y, sizy);
end
