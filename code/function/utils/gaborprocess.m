%{
----------------------------------------------------------------------------------------------------
Name:Preprocess of Gabor hologram to eliminate the reference wave.

Author:Ni Chen (chenni@snu.ac.kr)
Date:
Modified:

Note:
Gabor hologram is:
I =| R | ^2 +| O | ^2 + R * O + RO *
I_prime = ift(ft(I) - ft(| R | ^2))
=| O | ^2 + R * O + RO *= 2 real(O) +| O | ^2 = 2 real(O) + err
----------------------------------------------------------------------------------------------------
%}

function holo = gaborprocess(hologram, background, debug)

    %     hologram = hologram./max(max(hologram));
    %     background = background./max(max(background));
    %     figure;imshow(hologram-background,[]);

    H_ft = ifftshift(fft2(fftshift(hologram)));
    B_ft = ifftshift(fft2(fftshift(background)));
    holo_ft = H_ft - B_ft;

    holo = ifftshift(ifft2(fftshift(holo_ft)));
    %     holo = abs(holo);

    %     figure;imshow(abs(holo),[]);

    if debug == 1
        figure, imshow(log(abs(H_ft)), []); title('Hologram spectrum');
        figure, imshow(log(abs(B_ft)), []); title('Background spectrum');
        figure, imshow(log(abs(holo_ft)), []); title('Substracted spectrum');
    end

end
