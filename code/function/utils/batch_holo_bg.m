%% calculate back-ground from a series of images
function B = batch_holo_bg(bg_dir)
    datapath = bg_dir;
    S = dir(fullfile(datapath, '*.tif')); % pattern to match filenames.
    B = zeros(size(double(imread(fullfile(datapath, S(1).name)))));

    for idata = 1:numel(S)
        disp(['Loading ' num2str(idata) '/' num2str(numel(S))])
        F = fullfile(datapath, S(idata).name);
        B_single = double(imread(F));

        B = B + B_single;
    end

    B = B ./ numel(S);
end
