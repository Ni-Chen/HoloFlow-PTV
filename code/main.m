close all; clc; clear;

cd(fileparts(which(mfilename)))

% reproducible
rng('default');

% add path
addpath(genpath('./data/'));
addpath(genpath('./function/'));
% addpath(genpath('./PrimalDualFramework/'));
fista = [];

global out_dir obj_type obj_name isGPU my_export;

my_export = @(x) export_fig([x '.png'], '-transparent');

out_dir = './output/';
data_path = './data/';

%% data information
obj_name = 'sim_x';
isGPU = 0;

% ----- parameters -----
out_iter = 10;
num_frames = 2;

data_path = [data_path 'simulation/'];
obj_type = 'x'; mu = 0.5;
tau = 0.001; holo_max_iter = 10;

if isGPU
    warping_iters = [2 3 1]; alpha = 5e-4; beta = 5e-7; %gpu
else
    warping_iters = [2 3 1]; alpha = 1e-6; beta = 1e-8;
end

v_ratio = 1;

load([data_path 'particles-solid' '_rot-' obj_type '_holo_data.mat']);

ratio = params.dz / params.pps;
priors = [alpha alpha * ratio^1 beta beta * ratio^1];

data = data ./ max(abs(data(:)));


%% ----- parameters -----
% holo solver parameters
fasta.tol = 1e-8; % Use super strict tolerance
fasta.recordObjective = true; %  Record the objective function so we can plot it
fasta.verbose = 0;
fasta.stringHeader = ' '; % Append a tab to all text output from FISTA.  This option makes formatting look a bit nicer.
fasta.adaptive = true;
fasta.stopRule = 'iterations';
fasta.accelerate = false; % Turn on FISTA-type acceleration
fasta.TV_subproblem_its = 5;
% fasta.plot_steps = false;
fasta.ratio = ratio;
fasta.mu = mu;
fasta.maxIters = holo_max_iter;

% flow
flow.flow.warping_iters = warping_iters;
flow.flow.ratio = ratio;
flow.flow.priors = priors; %[1e-4 1e-4 1e-6 1e-6]
flow.cg.maxit = 1000;
flow.cg.tol = 1e-3;

% additional parameters
other.tau = tau;
other.maxit = out_iter;

% cat all parameters
opts.other = other;
opts.holo = params;
opts.fista = fista;
opts.fasta = fasta;
opts.flow = flow;

holos = data;

%% call solver
tTotal1 = tic;
[o, u] = holo_flow_solver(holos, opts, isGPU);
tTotal = toc(tTotal1);

disp(['Total holo-flow folover costs: ' num2str(tTotal) 'seconds']);

%%
save([out_dir obj_name '_o_holoflow.mat'], 'o');
save([out_dir obj_name '_u_holoflow.mat'], 'u');

%
% [xz_fwhm, xy_fwhm] = show_3d_plot(o)

% u = u * v_ratio;
%% show flow
bound_del = 0;

u_show = squeeze(u(1 + bound_del:end - bound_del, 1 + bound_del:end - bound_del, :, 1, :));
mean(u_show(:))

scale = 0.08;
figure('Name', '3D', 'Position', [100, 100, 400, 500]);
plot_flow(u_show, scale);
my_export([out_dir, obj_name, '_holo_flow']);

figure('Name', 'XYZ', 'Position', [100, 100, 400, 500]);
plot_flow_center(u_show, 'xyz', scale);
my_export([out_dir, obj_name, '_holo_flow_slice']);


for idx = 1:num_frames - 1
    u_ori = u * v_ratio;
    u_ori = squeeze(u_ori(:, :, :, idx, :));
    scale = [1 1 ratio]
    udims = ceil([size(u_ori, 1) * scale(1), size(u_ori, 2) * scale(2), round(size(u_ori, 3) * scale(3)), size(u_ori, 4)]);
    udims(end) = [];
    u_write = arrayfun(@(i) imresize3(u_ori(:, :, :, i), udims), 1:size(u_ori, ndims(u_ori)), 'un', 0);
    u_write = cat(4, u_write{:});

    to_paraview(u_write, 0.1, [out_dir obj_name '_u' num2str(idx) '.vtk'])
end

bound_del = 10;
u_part = squeeze(u(1 + bound_del:end - bound_del, 1 + bound_del:end - bound_del, 49:51, 1, :));
u_holo_length = sqrt(u_part(:, :, :, 1).^2 + u_part(:, :, :, 2).^2 + u_part(:, :, :, 3).^2);
mean(u_holo_length, 'all')
std(u_holo_length, 0, 'all')

sound(sin(linspace(0, 1 * 600 * 2 * pi, round(1 * 4000))), 4000);
