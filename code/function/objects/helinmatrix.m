close all;
clc;
clear;

% a = 3;
% c = 5.0;
% t = 0.2:0.01:20;
% x = a*cosint(t);
% y = a*sinint(t);
% z = t/c;
% figure
% plot3(x, y, z);
% xlabel('x'); ylabel('y'); title('SiCi spiral');
%
%
% N = 64*2;
% Nz = 80;
% H = zeros(N,N,Nz);
%
% ix = 0.1;
% iy = ix;
% iz = ix;
%
% xx = round(a.*cosint(t)/ix) + 1;
% yy = round(a.*sinint(t)/iy) + 1;
% zz = round(t/(c)/iz) + 1;
%
% xyz = sub2ind(size(H),xx,yy,zz);
%
% H(xyz) = 1;
%
% figure;
% temp = abs(permute((H), [2 3 1]));
% show3d(temp, 0.01);
%
%
% %%
% a = 1.5;
% c = 1;
% t = 0:0.05:10*pi;
% x = a*sin(t);
% y = a*cos(t);
% z = t/(2*pi*c);
%
% figure;
% plot3(x, y, z);
% xlabel('x'); ylabel('y');
%
%
% N = 64;
% Nz = 80;
% H = zeros(N,N,Nz);
%
% ix = 0.1;
% iy = 0.1;
% iz = 0.1;
%
% xx = round(a.*sin(t)/ix) + N/2;
% yy = round(a.*cos(t)/iy) + N/2;
% zz = round(t/(2*pi*c)/iz) + Nz/4;
%
% xyz = sub2ind(size(H),xx,yy,zz);
%
% H(xyz) = 1;
%
% figure;
% temp = abs(permute((H), [2 3 1]));
% show3d(temp, 0.01);
%
%%
a = 0.2;
c = 0.6;
t = 0:0.005:8 * pi;
x = (a * t / 2 * pi * c) .* sin(t);
y = (a * t / 2 * pi * c) .* cos(t);
z = t / (2 * pi * c);

figure;
plot3(x, y, z);
xlabel('x'); ylabel('y'); title('Circula helix');

%%
Nx = 64 * 2;
Ny = Nx;
Nz = 200;
H = zeros(Ny, Nx, Nz);

ix = 0.025;
iy = ix;
iz = 0.035;

xx = round(a * t .* sin(t) / (2 * pi * c) / ix) + Nx / 2;
yy = round(a * t .* cos(t) / (2 * pi * c) / iy) + Ny / 2;
zz = round(t / (2 * pi * c) / iz) + 1;

xyz = sub2ind(size(H), xx, yy, zz);

H(xyz) = 1;

figure;
temp = abs(permute((H), [2 3 1]));
show3d(temp, 0.01);
