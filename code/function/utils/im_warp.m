function J = im_warp(I, wx, wy)

    % coordinates
    dim = size(I);
    [x, y] = meshgrid(1:dim(2), 1:dim(1));

    % pre-cache cubic spline coefficients
    c = cbanal(cbanal(I.')).';

    % image warping
    x_new = -(wx) + x;
    y_new = -(wy) + y;
    J = cbinterp(c, y_new, x_new);

    % % cubic spline interpolation function (backward: coeffcient -> image)
    %     function out = cbinterp(c,x,y)
    %
    %         % calculate movements
    %         px = floor(x);
    %         fx = x - px;
    %         py = floor(y);
    %         fy = y - py;
    %
    %         % define device functions
    %         w0 = @(a) (1/6)*(a.*(a.*(-a + 3) - 3) + 1);
    %         w1 = @(a) (1/6)*(a.*a.*(3*a - 6) + 4);
    %         w2 = @(a) (1/6)*(a.*(a.*(-3*a + 3) + 3) + 1);
    %         w3 = @(a) (1/6)*(a.*a.*a);
    %         r  = @(x,c0,c1,c2,c3) c0.*w0(x) + c1.*w1(x) + c2.*w2(x) + c3.*w3(x);
    %
    %         % define texture function
    %         tex = @(x,y) interp2(c,y,x,'nearest',0);
    %
    %         % elementwise lookup
    %         out = r(fy, ...
    %             r(fx, tex(px-1,py-1), tex(px,py-1), tex(px+1,py-1), tex(px+2,py-1)), ...
    %             r(fx, tex(px-1,py  ), tex(px,py  ), tex(px+1,py  ), tex(px+2,py  )), ...
    %             r(fx, tex(px-1,py+1), tex(px,py+1), tex(px+1,py+1), tex(px+2,py+1)), ...
    %             r(fx, tex(px-1,py+2), tex(px,py+2), tex(px+1,py+2), tex(px+2,py+2)));
    %     end
    %
    %
    % % cubic spline interpolation function (forward: image -> coeffcient)
    %     function c = cbanal(img)
    %
    %         [m,n] = size(img);
    %
    %         % A = toeplitz([4 1 zeros(1,m-2)]) / 6;
    %
    %         c = zeros(m,n);
    %         for i = 1:n
    %             %     c(:,i) = A \ y(:,i);
    %             c(:,i) = 6 * tridisolve(img(:,i));
    %         end
    %
    %     end
    %
    %
    % % triangular linear solver
    %     function x = tridisolve(d)
    %
    %         % initialize
    %         x = d;
    %
    %         % get length
    %         m = length(x);
    %
    %         % define a, b and c
    %         b = 4*ones(m,1);
    %
    %         % forward
    %         for j = 1:m-1
    %             mu = 1/b(j);
    %             b(j+1) = b(j+1) - mu;
    %             x(j+1) = x(j+1) - mu*x(j);
    %         end
    %
    %         % backward
    %         x(m) = x(m)/b(m);
    %         for j = m-1:-1:1
    %             x(j) = (x(j)-x(j+1))/b(j);
    %         end
    %
    %     end

end
