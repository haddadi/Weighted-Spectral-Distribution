% A function to construct a simple graph using graphviz and drawdot. 
% plot_graph(A,X,Y,weights)
% 
% A - Adjacency matrix. 
% X,Y - vertex co-ordinates - provide empty matrices to prompt a call to graphviz to estimate suitable co-ordinates. 
% weights - (optional) a column with the weights to be assigned to each node in the graph. \
% Default: weights are assigned using the percentiles of the node degrees. 
%
% ref: http://people.csail.mit.edu/pesha/Public/K0D/README
%      http://www.graphviz.org/

function [X,Y]=plot_graph(A,X,Y,varargin)
if sum(sum(A)==0>0) | sum(sum(A,2)==0>0)
    disp('warning Adjacency matrix contains isolated nodes - removing');
    sift = sum(A)>0;
    A = A(:,sift);
    sift = sum(A,2)>0;
    A = A(sift,:);  
end
if ~exist('X') | ~exist('Y')
	[X, Y, labels] =draw_dot(A);
    X =X';
    Y=Y';
    %close 
end
figure
% first find all the connections.
[i,j]=find(triu(A)==1);
[i j];
line ([X(i) X(j)]',[Y(i) Y(j)]','LineWidth',1,'Color',[1 .78 .3])
hold on
% find the top 10% most central nodes
deg = full(sum(A));
soart=sort(deg,'descend');

p=[0:.1:1];
a=quantile(deg,p);

if nargin < 4
    for i=1:9
        ind=find(deg >= a(i) & deg < a(i+1));
        plot(X(ind),Y(ind),'bo','MarkerSize',i/1.5,'MarkerFaceColor','g');
        ind=find(deg >= a(10));
        plot(X(ind),Y(ind),'ro','MarkerSize',7,'MarkerFaceColor','r');
    end
elseif nargin ==4
    weights = varargin{1};
    a = quantile(weights,p);
    deg=weights;
    for i=1:9
        ind=find(deg >= a(i) & deg < a(i+1));
        plot(X(ind),Y(ind),'bo','MarkerSize',i/1.5,'MarkerFaceColor','g');
        ind=find(deg >= a(10));
        plot(X(ind),Y(ind),'ro','MarkerSize',7,'MarkerFaceColor','r');
    end
else
    cols = flipud(colormap('hot'));
    colormap(cols)
    colorbar('YTickLabel','');
    for i=1:length(X)
        plot(X(i),Y(i),'bo','MarkerSize',varargin{1}(i),'MarkerFaceColor', cols(varargin{2}(i),:));
    end
end


hold off

axis([0 1 0 1]);
