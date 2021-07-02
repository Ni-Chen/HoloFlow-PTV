%{
Propagate 2D real field to 3D volume

Inputs:
holo:ny - by - nx 2D real data (often the residual hologram)
params:Input parameters structure. Must contain the following
nx, ny, nz:Size of the volume (in voxels) in x, y, and z
z_list:List of reconstruction planes (um)
pps:Pixel size (um) of the image
wavelength:Illumination wavelength (um)

Outputs:
volume:3D estimated optical field, complex valued

%}

function volume = BackwardProjection(holo, otf)
    %     holo = real(holo);   % For adjoint check
    %     [ii,jj] = meshgrid(1:N,1:N);
    %     phz = exp(1i * pi .* (ii+jj));
    volume = iFT2(FT2((holo)) .* conj(otf)); % broadcasting

    %     phz = exp(1i * 2 * pi .* params.z / params.lambda).'; % conjugate phz
    %     volume = bsxfun(@times, permute(phz, [3 2 1]), volume);

end
