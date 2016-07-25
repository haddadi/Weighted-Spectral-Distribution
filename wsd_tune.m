function [results] = wsd_tune(model,target,X0,nbin,iter_count, wsd_power, plot_flag,echo_flag)
% model - a character with the name of the model.
%   This model must be in /tools/models and called model.m
%   current models: ba, glp, inet, wax, wit
% target - the adjacency matrix of the target graph. 
% X0 - initial starting point. 
% nbin - (optional, default 50) - number of bins in the WSD or a vector defining the bins. 
% plot_flag - (optional, default 0) - supply a character for plotting ex: 'r--' for red dashes. 
% echo_flag - (optional, default set) - echo each bin in WSD as it's being calculated. 
% iter_count - the number of topologies to be generated at each iteration
% (the results will be averaged - optional - default 5). 
% wsd_power - the power to take the weighted spectrum to (optional -
% default 4).
%
% results - a structure with the following fields:
% 

if ~exist('nbin')
    nbin = 50;
end

if ~exist('iter_count')
    iter_count = 5;
end

if ~exist('wsd_power')
    wsd_power = 4;
end

if ~exist('plot_flag')
    plot_flag = 0;
end

if ~exist('echo_flag')
    echo_flag = 1;
end

[row,col] = size(target);
if row ~= col
    disp('Target adjacency matrix is not square');
    return
end

disp('warning: this may take several days depending on the size of the network!');

% reset the random number generator to the clock. 
RandStream.setDefaultStream(RandStream('mt19937ar','seed',sum(100*clock)));

Nodes = length(target);
count_log = 1;

global wsd_opt_params wsd_opt_results % a structure to carry the specifics of the optimisation.

wsd_opt_params.target       = target;   
wsd_opt_params.Nodes        = Nodes;
wsd_opt_params.count_log    = count_log;
wsd_opt_params.model        = model;
wsd_opt_params.nbin         = nbin;
wsd_opt_params.plot_flag    = plot_flag;
wsd_opt_params.echo_flag    = echo_flag;
wsd_opt_params.iter_count   =iter_count;
wsd_opt_params.wsd_power    = wsd_power;

% get the wsd for the target. 
[w,index] = wsd(target,wsd_power,nbin,plot_flag,echo_flag);
wsd_opt_params.w_target = w;

options = optimset('fminsearch');
options.MaxIter=500;
options.MaxFunEvals =500;
options.TolFun=0;
X = fminsearch('wsd_opt',X0,options);

results = wsd_opt_results;