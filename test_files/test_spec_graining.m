close all

A= round(rand(6)*1.2);
A=triu(A);
A=A +A';
A=A-diag(diag(A));
A =[

     0     0     1     0     0     0    0;
     0     0     1     0     0     0    0;
     1     1     0     1     1     1    0;
     0     0     1     0     1     0    1;
     0     0     1     1     0     0    1;
     0     0     1     0     0     0    0;
     0     0     0     1     1     0    0 ]

% we expect nodes 4 and 5 to join together first. 
[X,Y]=plot_graph(A);

[G] = spec_graining(A,3,2);
[G,W,row,X,Y] = spec_graining(A,3,2,X,Y);
[X,Y]=plot_graph(G,X,Y);

return
load test_adj 

% [X,Y]=plot_graph(test_A);
[G,W,row,X_g,Y_g] = spec_graining(test_A,70,3,X,Y);
plot_graph(G,X_g,Y_g);

[G,W,row,X_g,Y_g] = spec_graining(test_A,250,3,X,Y);
plot_graph(G,X_g,Y_g);