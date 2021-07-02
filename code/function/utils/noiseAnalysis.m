function [sigma, mu] = noiseAnalysis(holo)
    %     bin=256;
    holo = holo ./ max(max(abs(holo)));
    bin = 256;

    if ~(isreal(holo))
        I = real(holo);
        figure;
        NIC = imcrop(I);

        % stastic mean and variance
        [p, xvalue] = hist(double(I(:)), bin);
        p = p ./ length(NIC(:));

        u = sum(xvalue .* p);
        var = sum(bsxfun(@minus, xvalue, u).^2 .* p);
        pdf = gaussmf(xvalue, [sqrt(var), u]) .* ((2 * pi * var)^(-1/2));

        % compare histogram and Gaussian
        figure;
        subplot(2, 1, 1); bar(pdf); title('Gaussian');
        subplot(2, 1, 2); bar(p); title('Histogram');

        A = max(pdf);
        sigma_re = 1 / A^2 / (2 * pi);
        mu_re = find(pdf == A);

        %%
        I = imag(holo);
        figure;
        NIC = imcrop(I);

        % stastic mean and variance
        [p, xvalue] = hist(double(I(:)), bin); %#ok<HIST>
        p = p ./ length(NIC(:));

        u = sum(xvalue .* p);
        var = sum(bsxfun(@minus, xvalue, u).^2 .* p);
        pdf = gaussmf(xvalue, [sqrt(var), u]) .* ((2 * pi * var)^(-1/2));

        % compare histogram and Gaussian
        figure;
        subplot(2, 1, 1); bar(pdf); title('Gaussian');
        subplot(2, 1, 2); bar(p); title('Histogram');

        A = max(pdf);
        sigma_im = 1 / A^2 / (2 * pi);
        mu_im = find(pdf == A);

        sigma = [sigma_re sigma_im];
        mu = [mu_re mu_im];
    else
        I = holo;
        figure; NIC = imcrop(I);

        % stastic mean and variance
        [p, xvalue] = hist(double(I(:)), bin);
        p = p ./ length(NIC(:));

        u = sum(xvalue .* p);
        var = sum(bsxfun(@minus, xvalue, u).^2 .* p);
        pdf = gaussmf(xvalue, [sqrt(var), u]) .* ((2 * pi * var)^(-1/2));

        % compare histogram and Gaussian
        figure;
        subplot(2, 1, 1); bar(pdf); title('Gaussian');
        subplot(2, 1, 2); bar(p); title('Histogram');

        A = max(pdf);
        sigma = 1 / A^2 / (2 * pi);
        mu = find(pdf == A);
    end

end
