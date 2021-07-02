function x0 = initializationLineSearch(g, A, AT)

    x0 = AT(g);
    estholo = A(x0);

    % %% Quick search for visualization only
    % scale_list = -1e-2:1e-4:3e-2;
    % objective = zeros(size(scale_list));
    % for i = 1:length(scale_list)
    %     scale = scale_list(i);
    %     esttest = estholo*scale;
    %     objective(i) = norm(esttest(:)-g(:),2)^2;
    % end
    %
    % figure;
    % plot(scale_list, objective);
    % xlabel('Scale');
    % ylabel('Norm of Error');
    % title('Objectives');
    % hold all;

    %% Initial search to set bounds
    % Pick riddiculous limits
    maxlim = 10;
    minlim = -10;
    num_points = 10;

    while true
        scale_list = linspace(minlim, maxlim, num_points);
        objective = zeros(size(scale_list));

        for i = 1:length(scale_list)
            scale = scale_list(i);
            esttest = estholo * scale;
            objective(i) = norm(esttest(:) - g(:), 2)^2;
        end

        [~, id] = min(objective);

        if (id > 1) && (id < num_points)
            % Minimum must lie within these bounds
            break;
        else
            maxlim = maxlim * 2;
            minlim = minlim * 2;
        end

    end

    figure;
    plot(scale_list, objective);
    xlabel('Scale');
    ylabel('Norm of Error');
    title('Objectives');
    hold all;

    f = @(s) norm(s * estholo(:) - g(:), 2)^2;
    tol = 1e-6;
    scale = gss(f, minlim, maxlim, tol);
    fprintf('Scale = %f\n', scale);

    plot(scale, f(scale), 'rx');

    x0 = x0 * scale;

end

function val = gss(f, a, b, tol)
    % see wikipedia.org/wiki/Golden-section_search
    gr = (sqrt(5) + 1) / 2;
    c = b - (b - a) / gr;
    d = a + (b - a) / gr;

    while abs(c - d) > tol

        if f(c) < f(d)
            b = d;
        else
            a = c;
        end

        c = b - (b - a) / gr;
        d = a + (b - a) / gr;
    end

    val = (b + a) / 2;
end
