function [holo] = holoNorm(holo)
    %{
    Normalize amplitude and phase of hologram respectively according to the property of hologram.
    Amplitude is in (0, 1) and Phase is in (-pi, pi).
    %}
    A = abs(holo);
    %     A = (A-min(A(:)))/(max(A(:))-min(A(:)));
    A = A ./ max(A(:));
    %     A = zscore(A);

    P = angle(holo);
    %     P = ((P-min(P(:)))/(max(P(:))-min(P(:))));
    %     P = ((P-min(P(:)))/(max(P(:))-min(P(:))))*2*pi-pi;
    P = P / max(P(:)) * 2 * pi - pi;
    %     P = P./pi;

    holo = A .* exp(1i * P);
end
