%{
Simulate forward formation of a hologram from a 3D optical field

Inputs:
volume:3D estimated optical field, generally complex valued
params:Input parameters structure. Must contain the following
- Nx, Ny, nz:Size of the volume (in voxels) in x, y, and z
- z_list:List of reconstruction planes (um)
- pp_holo:Pixel size (um) of the image
- wavelength:Illumination wavelength (um)

Outputs:
holo:Ny - by - Nx 2D real hologram (estimated image)
%}
function holo = ForwardProjection(volume, otf)
    %     phz = exp(-1i * 2 * pi .* params.z / params.lambda).';
    %     volume = bsxfun(@times, permute(phz, [3 2 1]), volume);

    Fholo3d = FT2(volume) .* otf;
    Fholo = sum(Fholo3d, 3);
    holo = iFT2(Fholo);
end
