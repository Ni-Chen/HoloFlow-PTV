function writetxt(txtname, data)
    % Write complex data to txt file

    if ismatrix(data)
        N = [size(data) 1];
    elseif ndims(data) == 3
        N = size(data);
    else
        error('ndims(data) must be either 2 or 3!')
    end

    % get structured data
    R = real(data);
    I = imag(data);
    t = [R(:) I(:)]';

    fileID = fopen(txtname, 'w');
    fprintf(fileID, '%d %d %d\n', N);
    fprintf(fileID, '%f\n', t(:));
    fclose(fileID);
end
