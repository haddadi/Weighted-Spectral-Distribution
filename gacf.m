function r=gacf(A,lag)
% give the assortativity autocorrelation function of a graph. 
% The correlation between the degrees of nodes at either end of paths of
% lengths 1 (normal assortativity), 2,3, ... lag. 

G=A;
for i=1:lag 
% calculate the assortativity. 
    D=sum(G,2);
    D2=sum(G);
    F1 = diag(D)*G;
    F2 = G*diag(D2);
    sift = (G)>0;
    X = F1(sift);
    Y = F2(sift);
    r_temp=corrcoef(X,Y);
    r(i)=r_temp(2,1);
% get the next power. 
    G = G*A;
    G=G-diag(diag(G));  % clear out the loops. 
    i
end
