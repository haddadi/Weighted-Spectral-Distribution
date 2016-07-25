function [jdd,dnn,r] = deg_corr(A,plot_struct)

% [jdd, ndd,r] = deg_corr(A,plot_struct);
% Example: 
% A - adjacency matrix. 
% plot_struct - a structure with name fields and flags:
% plot_struct.label1 = ['joint_degree_dist'];
% plot_struct.label2 = ['avg_deg_nearest_neigh'];
% plot_struct.printy =1;
% 
% jdd - joint degree distribution
% dnn - average degree of nearest neighbours
% r - assortativity

jdd =0;
dnn =0;
% A function to calculate the joint degree dist given an adjacency matrix. 
B = A;
Din =full(sum(A)); % degree's of the nodes. 
Dout=full(sum(A,2)); % degree the other way. 
% marginal dists
Pk = hist(Din,1:max(Din))';
Pk = Pk/sum(Pk);

L =full(max(sum(A))); % the largest degree.
e=sum(sum(A));

jdd = zeros(L);
for i= 1:L
        % 1. Find p(d'/d) 
         % find all nodes with neighbours of degree i
        sift1 = Din == i;   % 
        siftr=B(:,sift1'); % a non square matrix with the columns where Din ==i;
        dnn(i,1)=mean(Din*siftr./sum(siftr));

        sift1 = Din == i;
        C = B(sift1,:);
        e=sum(sum(C));  % total number of links with start degree i. 
    for j=1:L
        % find links with end degree j
        sift2 = Din == j;
        m=sum(sum(C(:,sift2')));
        % of those nodes find those with degree j;
        jdd(i,j) = m/e;
    end

end

if isstruct(plot_struct)
    [row,col]=size(jdd);
    figure
    mesh(jdd);
    axis([1  row  1 col 0 1.1*max(max(jdd))]);
    h=gca;
    %set(h,'CameraPosition',[370.559 256.257 0.111527]); % a better view
    xlabel('d_1','fontsize',12);
    ylabel('d_2','fontsize',12);
    zlabel('P(d_1,d_2)','fontsize',12);

    if (plot_struct.printy == 1)
        print('-r600', '-depsc',plot_struct.label1);
    end
    figure
    s=sum(dnn(dnn==dnn));
    loglog(1:L,dnn/s,'x')
    xlabel('d','fontsize',12);
    ylabel('Normalised d_{nn}(d)','fontsize',12);
        if (plot_struct.printy == 1)
        print('-r600', '-depsc',plot_struct.label1);
    end
end

% assortativity
G=A;
D=sum(G,2);
D2=sum(G);
F1 = diag(D)*G;
F2 = G*diag(D2);
sift = (G)>0;
X = F1(sift);
Y = F2(sift);
r=corrcoef(X,Y);
r=r(2,1);


