function x_ft = FT2(x)

   x_ft = ifftshift(fft2(fftshift(x)));
   
end