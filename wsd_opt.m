function [cost]=wsd_opt(X) 

global wsd_opt_results wsd_opt_params % a structure to carry the specifics of the optimisation.
target      = wsd_opt_params.target;
Nodes       = wsd_opt_params.Nodes;
model       = wsd_opt_params.model;
nbin        = wsd_opt_params.nbin;
plot_flag   = wsd_opt_params.plot_flag;
echo_flag   = wsd_opt_params.echo_flag;
iter_count  = wsd_opt_params.iter_count;
wsd_power   = wsd_opt_params.wsd_power;
w_target    = wsd_opt_params.w_target;
count_log = wsd_opt_results.count_log;


%global cdf_skitter pdf_skitter Nodes count_log
%Nodes = 9204;

% Generate iter_count number of models. 
for count =1:iter_count
 eval(['A = gen' model '(X,Nodes);']);
 [w,index] = wsd(A,wsd_power,nbin,plot_flag,echo_flag);
 temp(:,count)=w;
end

w = mean(temp,2);
cost = mean((w_target-w).^2);    % calc mean squared error between target and topology. 

% wsd_opt_results.w(count_log).w=temp;
% wsd_opt_results.mean_w = w;
wsd_opt_results.X(count_log,:)=X;
wsd_opt_results.cost(count_log,:) = cost;
wsd_opt_results.A(count_log).G = A;
wsd_opt_results.wsd(count_log).w = w;

% Estimate the cost function. Distance from the optimum deviation. 
   
count_log=count_log+1;
wsd_opt_results.count_log=count_log;

disp('X ; cost');
X
cost


