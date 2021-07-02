function [holo_shrink, pps_new] = holoResize(holo, pps, Ny_prime, pad_size)
    [Ny, Nx] = size(holo);

    holo_shrink = zeros(Ny_prime, Ny_prime);
    shrink_ratio = (Ny_prime - pad_size * 2) / Ny;
    holo_resize = imresize(holo, shrink_ratio, 'bilinear', 'Antialiasing', false);
%     holo_resize = imresize(holo, shrink_ratio, 'bilinear', 'Antialiasing', true);
    
    [Ny_resize, Nx_resize] = size(holo_resize);
    holo_shrink(pad_size + 1:pad_size + Ny_resize, pad_size + 1:pad_size + Nx_resize) = holo_resize;

    pps_new = pps / shrink_ratio;
end
