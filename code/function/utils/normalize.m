function temp = normalize(temp)
    temp = (temp - min(temp(:))) ./ (max(temp(:)) - min(temp(:)));
end
