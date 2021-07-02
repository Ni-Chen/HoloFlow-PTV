function set_ticks(vol, x_tick, y_tick, z_tick, tick_unit)

    xticks([1 size(vol, 2) / 2 size(vol, 2)]);
    yticks([1 size(vol, 1) / 2 size(vol, 1)]);
    zticks([1 size(vol, 3) / 2 size(vol, 3)]);

    x_ticks = {round(min(x_tick) * 10) / 10, 0, round(max(x_tick) * 10) / 10};
    set(gca, 'xticklabels', (x_ticks));
    y_ticks = {round(min(y_tick) * 10) / 10, 0, round(max(y_tick) * 10) / 10};
    set(gca, 'yticklabels', (y_ticks));
    z_ticks = {floor(min(z_tick)), floor((min(z_tick) + (max(z_tick) - min(z_tick)) / 2) * 10) / 10, floor(max(z_tick) * 10) / 10};
    set(gca, 'zticklabels', (z_ticks));

    xlabel(['x (', tick_unit, ')'], 'Rotation', 20);
    ylabel(['y (', tick_unit, ')'], 'Rotation', -33);
    zlabel(['z (', tick_unit, ')']);

    xlim([1 size(vol, 2)])
    ylim([1 size(vol, 1)])
    zlim([1 size(vol, 3)])
end
