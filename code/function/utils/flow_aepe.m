function EPE = flow_aepe(u_gt, u_com, bord)

    gr_u = u_gt(:, :, :, 1);
    gr_v = u_gt(:, :, :, 2);
    gr_w = u_gt(:, :, :, 3);

    u = u_com(:, :, :, 1);
    v = u_com(:, :, :, 2);
    w = u_com(:, :, :, 3);

    stu = gr_u(bord + 1:end - bord, bord + 1:end - bord, bord + 1:end - bord);
    stv = gr_v(bord + 1:end - bord, bord + 1:end - bord, bord + 1:end - bord);
    stw = gr_w(bord + 1:end - bord, bord + 1:end - bord, bord + 1:end - bord);

    su = u(bord + 1:end - bord, bord + 1:end - bord, bord + 1:end - bord);
    sv = v(bord + 1:end - bord, bord + 1:end - bord, bord + 1:end - bord);
    sw = w(bord + 1:end - bord, bord + 1:end - bord, bord + 1:end - bord);

    SSE = (stu - su).^2 + (stv - sv).^2 + (stw - sw).^2;
    EPE = sum(sqrt(SSE(:))) / numel(SSE);
end
