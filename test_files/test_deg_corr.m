% test file. 

close all
% Set up a simple graph 
A =[

     0     0     1     0     0     0    0;
     0     0     1     0     0     0    0;
     1     1     0     1     1     1    0;
     0     0     1     0     1     0    1;
     0     0     1     1     0     0    1;
     0     0     1     0     0     0    0;
     0     0     0     1     1     0    0 ]


[X,Y]=plot_graph(A);
% we expect the following edge connections. 

C=[2 2 3 3 3 1 1 1; 3 3 3 5 5 5 5 5]';
C=[C;C(:,2) C(:,1)];
% the assortativity
corrcoef(C)
% the joint degree distribution
for i=1:5
    sift1 = C(:,1)==i;
    s=sum(sift1);
    for j=1:5
        sift = C(sift1,2)==j;
        jdd_tst(i,j) = sum(sift)/s;
    end
end

plot_struct.label1 = ['joint_degree_dist'];
plot_struct.label2 = ['avg_deg_nearest_neigh'];
plot_struct.printy =0;

[jdd, ndd,r] = deg_corr(A,plot_struct);

jdd_tst 
jdd

ndd_tst=[];
for i=1:5
    sift = C(:,1)==i;
    ndd_tst(i,:)=mean(C(sift,2));
end
[ndd_tst ndd]


