function [X,C] = spline_min(x,cost,plot_flag,X0)
% This function approximates a cost grid with a tin plate spline function
% and then uses fminsearch on the approximated function to estimate the minimum
% value for the function. Note this does not 
% 
% x             - the grid values. 
% cost          - the cost at these values. 
% plot_flag     - (optional) set = 1 for a plot. (default - off).
% X0            - (optional) specify a starting point for the approximation -
%                otherwise the argmin(x)|cost is used. 
%
% X             - the minimum of the function. 
% C             - the cost at that minimum.

x=x';         % This function uses the column format :s
cost=cost';


if ~exist('plot_flag')
    plot_flag =0;
end
if ~exist('X0')
    [i,j]=min(cost);
    X0 = x(:,j)';
end
X0 =X0';

st = tpaps(x,cost);  % tin plate approximation. 

% use the optimisation on the spline curve. 
options = optimset('fminsearch');
options.MaxIter=500;
options.MaxFunEvals =500;
options.TolFun=0;

X = fminsearch(@(x) sp_opt(x,st),X0,options);
C = sp_opt(X,st);

if plot_flag ==1
    fnplt(st); hold on
    plot3(x(1,:),x(2,:),cost,'wo','markerfacecolor','k')
    % find the minimum value    
    plot3(X(1),X(2),C,'rv','markerfacecolor','r','MarkerSize',10,'HandleVisibility','off')
    h=line([X(1) X(1)],[X(2) X(2)],[C C*2]);
    set (h,'color',[.8 0 0]);
    colormap gray        
    f=colormap;          % invert the colormap so that it is light near the minimum - looks better 
    g=flipud(f);
    colormap(g);
end
