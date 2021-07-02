function o_out = AT_all(b, AT)
    o_out = arrayfun(@(i) AT(b(:, :, i)), 1:size(b, 3), 'un', 0);
    o_out = cat(4, o_out{:});
end
