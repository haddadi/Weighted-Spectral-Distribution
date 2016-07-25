function [G,W,row,X,Y] = spec_graining(A,n,p,X,Y)
% A function to coarse grain a network using spectral coarse graining.
% A - original network.
% n - no of intervals for eigenvector splitting. Or feed in a vector with 2 entries:
%           [n, 0] - where n is the number of clusters to use with k-means
%           clustering.
% p - dimension of the reduced eigenvector space - (default 3).
% X,Y - (optional) specify the X-Y co-ords of the source node.
%
% G - reduced network.
% W- walk Laplacian of the new network (combined  adjacency matrix – including loops).
% X,Y - combined X-Y co-ords of dest nodes.
% row - re-labelling vector row(i)= ith node in A -> row(i) node in G.
% Writen by Damien Fay
% Ref: D. Gfeller, P. De Los Rios, Spectral Coarse Graining of complex networks, Physical review letters, 99, 038701, 2007

% Get the first p eigenvectors of the walk Laplacian

if ~exist('p')
    p=3;
end

D = sum(A,2);
D = sparse(diag(1./D));

W = A *D;
[V_r,e] = eigs(W,p+1);
[V_l,l]= eigs(W',p+1);
e=diag(e);  % right evals
l=diag(l);  % left evals (complex conj of right)

% Test insert 1 (see bottom - old code - ignore).

R=[];
if length(n) ==1    % using fixed bandwidth.
    for i=1:p
        maxy = max(V_l(:,i+1));
        miny = min(V_l(:,i+1));
        
        groups = miny:(maxy-miny)/n:maxy;
        % Assign an indicator matrix for each node.
        for g_ind = 1:n
            f(:,g_ind) = V_l(:,i+1)<=groups(g_ind+1);
        end
        
        temp = [f(:,1)'; diff(f')];
        R=[R;temp];
    end
    % take the R's and combine as if they are binary labels and convert to
    % decimal.
    %labels = bin2dec(num2str(R'));
    %classes = histc(labels,[0:max(labels)]); % count the number of classes (including nodes not grouped).
    [i,j,group]=mat_freq(R'); % find out how many of them there are.
    % look_up=zeros(max(i),1);
    C = length(j);  % the number of groups
    % look_up(i)=1:C;
    % row = look_up(labels); % assign group number to each label. a row in R is
    % a group.
    row = group;
    col = 1:length(row);
    R=sparse(row,col,1);
else % we're using kmeans
    idx = kmeans(V_l(:,2:p+1),n(1));
    row = idx;
    col = 1:length(row);
    R=sparse(row,col,1);
    C = max(idx);
end

K=repmat(V_r(:,1),1,C); % set to the eigenvector. p_i (with C dimensions).

K=K.*R';    % mask with R - delta_C_i
K=K*diag(1./sum(K)); % normalise.
G=R*W*K;

if exist('X') && exist ('Y') % transform the co-ordinates for a plot. (if the originals are supplied)
    
    X=R*X./sum(R,2);
    Y=R*Y./sum(R,2);
else
    X = [];
    Y = [];
end

W=G;
G(G>0)=1;
G=G-diag(diag(G));

% test insert 1.
% % test to see if they're correct.
% [W*V(:,3) e(3)*V(:,3)]
%
% [V,l] = eigs(W');
% l=diag(l);
% [V(:,1)'*W ; l(1)*V(:,1)']
% [V(:,2)'*W ; l(2)*V(:,2)']
% [V(:,3)'*W ; l(3)*V(:,3)']
% [V(:,4)'*W ; l(4)*V(:,4)']
% [V(:,5)'*W ; l(5)*V(:,5)']
%


