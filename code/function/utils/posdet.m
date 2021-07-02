function err = posdet(holo, deltaX, deltaY, deltaZ, Nz, holo_type)
    %POSDET     Position detection.
    %   POSDET(holo) detects edges on the imaginary part of the convolution
    %   between FZPs of input hologram holo and object intensity in matrix form,
    %   and refers to the total number of edge pixels as the edge amount.
    %
    %   err = POSDET(holo) returns the edge amount corresponding to
    %   different depth distances. The local minima in the curve suggest where
    %   sections in the hologram contain the correct depth for reconstruction.
    %
    %   Class support for input holo:
    %       float: double.
    %
    %   This function is developed by Tristan X. Zhang.

    [Ny, Nx] = size(holo);

    [otf3d, psf3d, pupil3d] = OTF3D(Ny, Nx, Nz, lambda, deltaX, deltaY, deltaZ, offsetZ, sensor_size);

    %% Make Fresnel zone pattern
    % Ny = size(holo,1);
    % Nx = size(holo,2);
    deltay = 2 / (Ny - 1); deltax = 2 / (Nx - 1);
    [x y] = meshgrid(-.5:deltay / 2:.5, -.5:deltax / 2:.5); %-0.5<x<0.5, -0.5<y<0.5

    for i = 1:1:34
        k00 = 480 + i * 10; %k001 = 776 and k002 = 555 in our example
        hz00 = -1i * k00 / pi * exp(1i * k00 * (x.^2 + y.^2)) .* exp((x.^2 + y.^2) * -32);
        HZ00 = fftshift(fft2(hz00)); %Fourier transform with the zero-frequency
        %component in the middle of the spectrum
        %% Reconstruction hologram
        FI = fft2(holo); %Fourier transform for the input hologram
        FI = fftshift(FI); %zero-frequency component in the mid of the spectrum
        FHI = FI .* conj(HZ00);

        HI = fftshift(ifft2(FHI));
        max1 = max(HI);
        max2 = max(max1); %find the max. element in HI
        scale = 1.0 / max2;

        HI = HI .* scale;
        [BW t] = edge((imag(HI)), 'prewitt'); %edge detection with prewitt operator
        err02(i) = sum(sum(BW));
        pause(1);
    end

    err = filter([2 .5], 1, [err02(1) err02 err02(end)]); %edge reconstruction

    % as indicated in the figure, i = 8 and i = 30 correspond to the two
    % sections. k01 = 560, k02 = 780.
