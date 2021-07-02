%  Solve:
%                min_u  mu*TV(u)+1/2*||u-im||^2
%   where "im" is a noisy image or any dimension (1D, 2D, 3D, or higher),
%   and "TV" represents the total-variation seminorm.
%   This code uses the gradient projection algorithm of Beck & Teboulle:
%   Beck, A. & Teboulle, M. Fast gradient-based algorithms for
%       constrained total variation image denoising and deblurring
%       problems. IEEE Trans. Image Process. 18, 2419�2434 (2009).
%  Inputs:
%    im      : An N-D array with noisy image data
%    mu      : A scaling parameter that controls the strength of TV penalty

function [denoised, outs] = gradproj_totalVariation2D(im, mu, num_its)

    % num_its = 4;

    % Initial guess
    g = zeros([size(im), 2]);

    scale = 1 / (4 * 2 * mu);
    fprintf('Gradient projection iteration %04d', 0);

    for k = 1:num_its
        fprintf('\b\b\b\b');
        fprintf('%04d', k);
        g = projectIsotropic(g + scale * grad(im - mu * div(g)));
    end

    fprintf('\n');

    denoised = im - mu * div(g);

    outs = [];

end

function g = projectIsotropic(g)
    dims = size(g);
    %  Find the norm of the gradient at each point in space
    normalizer = sqrt(sum(g .* g, ndims(g)));
    %  Create a normalizer that will shrink the gradients to have magnitude at
    %  most 1
    normalizer = max(normalizer, 1);
    %  Make copies of this normalization so it can divide every entry in the
    %  gradient
    expander = ones(1, ndims(g));
    expander(end) = dims(end);
    normalizer = repmat(normalizer, expander);
    %  Perform the normalization
    g = g ./ normalizer;
end

%  The gradient of an N-dimensional array. The output array has size
%  [size(x) ndims(x)].  Note that this output array has one more dimension
%  that the input array. This array contains all of the partial derivatives
%  (i.e., forward first-order differences) of x.  The partial derivatives
%  are indexed by the last dimension of the returned array.  For example,
%  if x was 3 dimensional, the returned value of g has 4 dimensions.  The
%  x-derivative is stored in g(:,:,:,1), the y-derivative is g(:,:,:,2),
%  and the z-derivative is g(:,:,:,3).
%   Note:  This method uses circular boundary conditions for simplicity.
function [ g ] = grad(x)
    numdims = 2; %ndims(x);
    numEntries = numel(x);
    g = zeros(numEntries * numdims, 1);

    for d = 1:numdims
        shift = zeros(1, numdims);
        shift(d) = 1;
        delta = circshift(x, shift) - x;
        delta = gather(delta);
        g((d - 1) * numEntries + 1:d * numEntries) = delta(:);
    end

    g = reshape(g, [size(x), numdims]);
end

%  The divergence operator.  This method performs backward differences on
%  the input vector x.  It then sums these differences, and returns an
%  array with 1 dimension less than the input.  Note:  this operator is the
%  adjoint/transpose of "grad."
function [ out ] = div(x)
    s = size(x);
    dims = s(end);
    outdims = s(1:end - 1);
    out = zeros(outdims);
    x = x(:);
    block = numel(out);

    for d = 1:dims
        slice = reshape(x(block * (d - 1) + 1:block * d), outdims);
        shift = zeros(1, dims);
        shift(d) = -1;
        out = out + circshift(slice, shift) - slice;
    end

end

% Evaluate total variation norm
% function [ tv ] = TV(x)
%     numdims = 2; %ndims(x);
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
