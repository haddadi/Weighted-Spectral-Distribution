function [results] = wsd_grid(model,target,gryd,nbin,iter_count, wsd_power, plot_flag,echo_flag)
% model - a character with the name of the model.
%   This model must be in /tools/models and called model.m
%   current models: ba, glp, inet, wax, wit
% target - the adjacency matrix of the target graph. 
% gryd - a 2xn array of values over which to evaluate the distance between the model and target. 
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

clear global wsd_opt_params 
clear global wsd_opt_results

global wsd_opt_params wsd_opt_results % a structure to carry the specifics of the optimisation.

wsd_opt_results.count_log   = 1;
wsd_opt_params.target       = target;   
wsd_opt_params.Nodes        = Nodes;
wsd_opt_params.model        = model;
wsd_opt_params.nbin         = nbin;
wsd_opt_params.plot_flag    = 0;
wsd_opt_params.echo_flag    = echo_flag;
wsd_opt_params.iter_count   = iter_count;
wsd_opt_params.wsd_power    = wsd_power;

% get the wsd for the target. 
[w,index] = wsd(target,wsd_power,nbin,plot_flag,echo_flag);
wsd_opt_params.w_target = w;

for i=1:length(gryd)
    X0 = gryd(:,i);
    cost(i)=wsd_opt(X0);
    save inter cost wsd_opt_results     % save data in case of a crash
end

results = wsd_opt_results;

if plot_flag
    % turn the points into a grid. 
    if min(size(gryd)) ==1
        return % this is for the special case when we try INET 1-D grid!
    end
    x = unique(gryd(1,:));
    y = unique(gryd(2,:));
    L=length(cost);
    C=zeros(length(x),length(y));
    for i=1:L
        x_cord = find(x==gryd(1,i));
        y_cord = find(y==gryd(2,i));
        C(x_cord,y_cord) = cost(i);
    end
    p=[0:.1:.9 .93 .96 1];
    percentile_contour(C,x,y,p)
end

    
    