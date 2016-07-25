function adj_matr = genglp(X,N)
% This is a function to generate a BA2 model 

% 1st it is using an awk set of commands. (in parfit_ba2.awk)
% The commands 1st write a configuration file. 
% Then they execute BRITE with this file. 
% The resulting file then has the header removed ans this results in
% the file: edges_
% this is then read by matlab. (2nd line of this program!) 
% This file is a list of adjacencies which is used to generate and
% adjaceny matrix. 
p=X(1);
q=X(2);

!rm glp_edges.txt

eval(['!awk -f genglp.awk ' num2str(p) ' ' num2str(q) ' ' num2str(N)]);
a=dir('glp_edges.txt');
while(isempty(a))
    a=dir('glp_edges.txt');
end
load glp_edges.txt
mapped_nodes = glp_edges+1; 

adj_matr =zeros(N,N);
L = ones(size([mapped_nodes(:,2); mapped_nodes(:,1)]));
adj_matr=sparse([mapped_nodes(:,1) ; mapped_nodes(:,2)],[mapped_nodes(:,2); mapped_nodes(:,1)],L,N,N);
%figure
%spy(adj_matr)
sum(sum(adj_matr))
