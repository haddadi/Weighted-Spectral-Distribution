% clear all
% load data1
% A = sparse(double(master_graph));
% plabel='master';

function results = examine_graph(A,plabel)
% A function that produces plots and numbers for various graph properties. 
% results returned in a structure called results.
A=double(A);

close all
% Kill andy self loops in the matrix.
for i=1:min(size(A));
    A(i,i)=0;
end
printy =1;
results.A = A;

path(path,'/local/scratch/df276/spectral/matlab_bgl-3.0-beta');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Approx min degree permutation
p= amd(A);
spy(A(p,p));
if (printy == 1)
    print('-r600', '-depsc',['images\' plabel '_amd_adj'   ]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Degree distribution. 
D = sum(A);
h=hist(D,[1:full(max(D))]);
xlabel('\it{k}');
ylabel('it{p}');
figure
loglog([1:full(max(D))],h);
xlabel('\it{k}');
ylabel('Frequency');
grid on
x = log([1:full(max(D))]);
y = log(h);
% ignore -inf points (where there was no degree observed.
sift = y ~=-Inf; 
y=y(sift)';
x=x(sift)';
X = [x ones(size(x))];
theta = inv(X'*X)*X'*y;
m=theta(1);
c=theta(2);

x = log([1:full(max(D))]);
y_n = exp(m*x+c);
hold on
loglog([1:full(max(D))],y_n,'r--');
legend('Data',['Best fit (m=' num2str(m,2) '; c =' num2str(c,2) ')']);
if (printy == 1)
    print('-r600', '-depsc',['images\' plabel '_degree_dist'  ]);
end
results.D = D;
results.h = h;
results.scaleFreeExp.m = m;
results.scaleFreeExp.m = c;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Components and sizes
[ci sizes] = components(A);
disp(['No. of Components: ' num2str(length(sizes)) ]);
siz = sort(sizes,'descend');
j=min([length(siz) 10])
disp(['Largest Components: ' num2str(siz(1:j)') ]);
results.components.ci = ci;
results.components.sizes = sizes;

[i,j]=max(sizes);   % draw the largest component
path(path,'../graphviz');
sift = ci == j;
[x, y, labels] =draw_dot(A(sift,sift));
close
A_lar=A(sift,sift);
results.components(1).A = A_lar;
results.components(1).x_coef = x';
results.components(1).y_coef = y';

plot_graph(A(sift,sift),x',y')
if (printy == 1)
    print('-r600', '-depsc',['images\' plabel '_largest_component'  ]);
end

j=find(sizes==siz(2));
sift = ci == j;  % draw second largest component
[x, y, labels] =draw_dot(A(sift,sift));
[x, y, h] = graph_draw(A(sift,sift), 'X', x, 'Y', y);
close
plot_graph(A(sift,sift),x',y')

A_lar=A(sift,sift);
results.components(2).A = A_lar;
results.components(2).x_coef = x';
results.components(2).y_coef = y';

if (printy == 1)
    print('-r600', '-depsc',['images\' plabel '_2nd_largest_component' ]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clustering Coefficients
ccfs = clustering_coefficients(A);
figure
[h,index]=hist(ccfs,0:0.05:1);
bar(index,h);
axis tight
xlabel('\gamma') 
ylabel('Frequency') 
clus_coef = mean(ccfs);
disp(['Clustering Coefficient: ' num2str(clus_coef) ]);
if (printy == 1)
    print('-r600', '-depsc',['images\' plabel '_clustering_coeff_dist' ]);
end
results.clustering.ccfs = ccfs;
results.clustering.ccd = h;
results.clustering.index = index;
results.clustering.coef = clus_coef;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Betweeness. 
[bc,E] = betweenness_centrality(double(A));

% figure
% [h,index]=hist(bc,0:0.05:1);
% bar(index,h);
% axis tight
% xlabel('\gamma') 
% ylabel('Frequency') 
% clus_coef = mean(ccfs);
% disp(['Clustering Coefficient: ' num2str(clus_coef) ]);
% if (printy == 1)
%     print('-r600', '-depsc',['images\' plabel '_clustering_coeff_dist' ]);
% end
results.bc = bc;
results.ec = E;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adjacency matrix spectrum
[v,e,flag] = eigs(A,100,'LM');
ev = diag(e);
if sum(flag)>0
    disp([ num2str(sum(flag)) ' ev''s failed to converge']);
end
figure
plot(1:50,ev(1:50))
xlabel('Eigenvalue number');
ylabel('Value');
if (printy == 1)
    print('-r600', '-depsc',['images\' plabel '_adj_eigenvalue_scree'  ]);
end

% look at the eigenvalues for the largest component and see how it is
% distributed. 

[v,e,flag] = eigs(results.components(1).A,100,'LM');
[IDX,C,sumD,D] = kmeans(v(:,1:3), 5);
% plot the nodes involved in each cluster.

x=results.components(1).x_coef;
y=results.components(1).y_coef;

a = abs(v(:,1));
% scale to between 0 and 8
a=a/max(a)*8;
plot_graph(results.components(1).A,x,y,a,ceil(a*8))
if (printy == 1)
    print('-r600', '-depsc',['images\' plabel '_adj_1st_eigenvalue_heatmap' ]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normalised laplacian matrix spectrum
NL = norm_lap(A);
results.NL = NL;
NL_lar = norm_lap(results.components(1).A);
results.components(1).NL = NL_lar;
NL_lar = norm_lap(results.components(2).A);
results.components(2).NL = NL_lar;


[v,e,flag] = eigs(NL,length(NL),'BE');
ev = diag(e);
if sum(flag)>0
    disp([ num2str(sum(flag)) ' ev''s failed to converge']);
end
figure
plot(ev)
xlabel('Eigenvalue number');
ylabel('Value');
if (printy == 1)
    print('-r600', '-depsc',['images\' plabel '_NL_eigenvalue_scree'  ]);
end

% histogram of the eigenvalues
figure
[h,ind]=hist(ev,50);
h=h/length(results.NL);
plot(ind,h);
[v,pdf,cdf,index] = getspec(results.NL,51);
hold on
plot(index,pdf,'r--');
xlabel('\lambda');
ylabel('f_{\lambda}(\lambda)');
legend('Direct Method','Sylvesters Method');
if (printy == 1)
    print('-r600', '-depsc',['images\' plabel '_NL_eigenvalue_dist'  ]);

end
results.pdf= pdf;
results.cdf= cdf;
results.v= v;
results.index=index;

% look at the eigenvalues for the largest component and see how it is
% distributed. 

[v,e,flag] = eigs(results.components(1).NL,11,'SM');
ev = diag(e);

% plot the nodes involved in each cluster.
x=results.components.x_coef;
y=results.components.y_coef;

L=10;
for i=1:L
    a = abs(v(:,L+1-i));
    % scale to between 0 and 8
    a=a/max(a)*8;
    plot_graph(results.components(1).A,x,y,a,ceil(a*8))
    if (printy == 1)
        print('-r600', '-depsc',['images\' plabel '_NL_eigenvalue_heatmap' num2str(i)  ]);
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Weighted spectrum
wsd = quaternion(results.pdf,results.index,1);
results.wsd = wsd;

figure
plot(index,wsd,'k-');
xlabel('\lambda');
ylabel('f_{\lambda}(\lambda) (1-\lambda)^4');

[v,pdf,cdf,index] = getspec(results.components(1).NL,51);
results.components(1).pdf= pdf;
results.components(1).cdf= cdf;
results.components(1).v= v;
results.components(1).index=index;
wsd = quaternion(results.components(1).pdf,results.components(1).index,1);
results.components(1).wsd = wsd;
hold on
plot(index,wsd,'r--');

[v,pdf,cdf,index] = getspec(results.components(2).NL,51);
results.components(2).pdf= pdf;
results.components(2).cdf= cdf;
results.components(2).v= v;
results.components(2).index=index;
wsd = quaternion(results.components(2).pdf,results.components(2).index,1);
results.components(2).wsd = wsd;
hold on
plot(index,wsd,'g:');

legend('Full graph','Conn Comp 1','Conn Comp 2');

if (printy == 1)
    print('-r600', '-depsc',['images\' plabel '_NL_eigenvalue_wsd' ]);
end

[cn_bgl sizes] = core_numbers(results.A);
results.kcore = cn_bgl;
results.kcore_dist = sizes;

[cn_bgl sizes] = core_numbers(results.components(1).A);
results.components(1).kcore = cn_bgl;
results.components(1).kcore_dist = sizes;

[cn_bgl sizes] = core_numbers(results.components(2).A);
results.components(2).kcore = cn_bgl;
results.components(2).kcore_dist = sizes;

disp(['K-core sizes: 0 - ' num2str(length(sizes)-1) ]);
sizes'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% K-core 
[cn_bgl sizes] = core_numbers(results.A);
results.kcore = cn_bgl;
results.kcore_dist = sizes;

linespec ={'k-','c-','g-','b-','y-'};

disp(['K-core sizes: 0 - ' num2str(length(sizes)-1) ]);
sizes'

% look at the degree distribution as a fn of k-core
L=min(length(results.kcore_dist)-1,5);
A  = results.A;
figure
for i=1:L
    sift = results.kcore >= i;
    % calc the degree distribution
    deg_dist(A(sift,sift));

    [D, h, m,c,x,y_n]=deg_dist(A(sift,sift));
    xlabel('\it{k}');
    ylabel('it{p}');
    
    loglog([1:full(max(D))],h,linespec{i});
    xlabel('\it{k}');
    ylabel('Frequency');
    grid on

    hold on
    loglog([1:full(max(D))],y_n,'r--');
    legjend{i*2-1} = [ num2str(i) '- Shell'];
    legjend{i*2} =[ '(m=' num2str(m,2) '; c =' num2str(c,2) ')'];
end
legend(legjend)

if (printy == 1)
    print('-r600', '-depsc',['images\' plabel '_k_core_degree_dist']);
end

% component 1
[cn_bgl sizes] = core_numbers(results.components(1).A);
results.components(1).kcore = cn_bgl;
results.components(1).kcore_dist = sizes;
disp(['K-core sizes: 0 - ' num2str(length(sizes)-1) ]);
sizes'

linespec ={'k-','c-','g-','b-','y-'};

L=min(length(results.components(1).kcore_dist)-1,5);
A  = results.components(1).A;
figure
for i=1:L
    sift = results.components(1).kcore >= i;
    % calc the degree distribution
    deg_dist(A(sift,sift));

    [D, h, m,c,x,y_n]=deg_dist(A(sift,sift));
    xlabel('\it{k}');
    ylabel('it{p}');
    
    loglog([1:full(max(D))],h,linespec{i});
    xlabel('\it{k}');
    ylabel('Frequency');
    grid on

    hold on
    loglog([1:full(max(D))],y_n,'r--','MarkerFaceColor','k');
    legjend{i*2-1} = [ num2str(i) '- Shell'];
    legjend{i*2} =[ '(m=' num2str(m,2) '; c =' num2str(c,2) ')'];
end
legend(legjend)

if (printy == 1)
    print('-r600', '-depsc',['images\' plabel '_k_core_degree_dist_c1'  ]);
end

% component 2
[cn_bgl sizes] = core_numbers(results.components(2).A);
results.components(2).kcore = cn_bgl;
results.components(2).kcore_dist= sizes;

disp(['K-core sizes: 0 - ' num2str(length(sizes)-1) ]);
sizes'

L=min(length(results.components(2).kcore_dist)-1,5);
A  = results.components(2).A;
figure
for i=1:L-1
    sift = results.components(2).kcore >= i;
    % calc the degree distribution
    deg_dist(A(sift,sift));

    [D, h, m,c,x,y_n]=deg_dist(A(sift,sift));
    xlabel('\it{k}');
    ylabel('it{p}');
    
    loglog([1:full(max(D))],h,linespec{i});
    xlabel('\it{k}');
    ylabel('Frequency');
    grid on

    hold on
    loglog([1:full(max(D))],y_n,'r--');
    legjend{i*2-1} = [ num2str(i) '- Shell'];
    legjend{i*2} =[ '(m=' num2str(m,2) '; c =' num2str(c,2) ')'];
end
legend(legjend)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% degree correlations. 
plot_struct.label1 = ['images\' plabel '_joint_degree_dist'  ];
plot_struct.label2 = ['images\' plabel '_avg_deg_nearest_neigh' ];
plot_struct.printy =1;

[jdd, ndd,r] = deg_corr(results.A,plot_struct);

results.jdd = jdd;
results.ndd = ndd;
results.r = r;

[jdd, ndd,r] = deg_corr(results.components(1).A,plot_struct);

results.components(1).jdd = jdd;
results.components(1).ndd = ndd;
results.components(1).r = r;

[jdd, ndd,r] = deg_corr(results.components(2).A,plot_struct);

results.components(2).jdd = jdd;
results.components(2).ndd = ndd;
results.components(2).r = r;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% summary statistics
n = length(results.A);
e = sum(sum(results.A));
results.n = n;
results.edges = e;
results.mean_degree = mean(results.D);
results.max_degree = max(results.D);
results.max_kcore = max(results.kcore);

results.components(1).D = sum(results.components(1).A);
results.components(1).n = length(results.components(1).A);
results.components(1).edges = sum(sum(results.components(1).A));
results.components(1).mean_degree = mean(results.components(1).D);
results.components(1).max_degree = max(results.components(1).D);
results.components(1).max_kcore = max(results.components(1).kcore);

results.components(2).D = sum(results.components(2).A);
results.components(2).n = length(results.components(2).A);
results.components(2).edges = sum(sum(results.components(2).A));
results.components(2).mean_degree = mean(results.components(2).D);
results.components(2).max_degree = max(results.components(2).D);
results.components(2).max_kcore = max(results.components(2).kcore);

summarise(results)









