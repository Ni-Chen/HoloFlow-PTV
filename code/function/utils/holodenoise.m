function holoout = holodenoise(holoin)

    if ~(isreal(holoin))

        sigma = evar(real(holoin));
        sigma = sqrt(sigma);
        gausFilter = fspecial('gaussian', [3, 3], sigma);
        holo_re = imfilter(real(holoin), gausFilter, 'replicate');

        sigma = evar(imag(holoin));
        sigma = sqrt(sigma);
        gausFilter = fspecial('gaussian', [3, 3], sigma);
        holo_im = imfilter(imag(holoin), gausFilter, 'replicate');

        holoout = holo_re + 1i * holo_im;
    else
        sigma = evar(holoin);
        gausFilter = fspecial('gaussian', [3, 3], sigma);
        holoout = imfilter(holoin, gausFilter, 'replicate');
    end

end
