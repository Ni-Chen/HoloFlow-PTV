function set_ticks_2d(vol, x_tick, y_tick, tick_unit)

    xticks([1 size(vol, 2) / 2 size(vol, 2)]);
    yticks([1 size(vol, 1) / 2 size(vol, 1)]);

    x_ticks = {round(min(x_tick) * 10) / 10, 0, round(max(x_tick) * 10) / 10};
    set(gca, 'xticklabels', (x_ticks));
    y_ticks = {round(min(y_tick) * 10) / 10, 0, round(max(y_tick) * 10) / 10};
    set(gca, 'yticklabels', (y_ticks));

    xlabel(['x (', tick_unit, ')']);
    ylabel(['y (', tick_unit, ')']);

    xlim([1 size(vol, 2)]);
    ylim([1 size(vol, 1)]);
end
