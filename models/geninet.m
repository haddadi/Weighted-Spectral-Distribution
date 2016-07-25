function adj_matr = geninet(X,N)
% This is a function to generate an INET model. 
% the Inet C-code is required to be installed in ../../inet-3.0 
% 
% X - parameters with X(1) = alpha - % of nodes with degree 1. 
% N - size of the network. 
% 
% adj_matr - adjaceny matrix. 

global base_dir

if N < 3037 
    disp(['Error! the number of nodes must be no less than 3037!']);
    adj_matr = zeros(N);
    return
end

% change directory to the models directory. 
current_dir = pwd;
cd([base_dir '/tools/models']);

alpha=X(1);

seed = floor(rand*1000);

!rm inet_edges.txt

eval(['!../../inet-3.0/inet -n ' num2str(N) ' -p ' num2str(N-1) ' -d' num2str(alpha) ' -s ' num2str(seed) ' > Inet.txt']);
!awk 'NR > 1{print $1, $2}' Inet.txt  > inet_edges.txt
a=dir('inet_edges.txt');
while(isempty(a))
    a=dir('inet_edges.txt');
end
load inet_edges.txt
mapped_nodes = inet_edges+1; 

adj_matr =zeros(N,N);
L = ones(size([mapped_nodes(:,2); mapped_nodes(:,1)]));
adj_matr=sparse([mapped_nodes(:,1) ; mapped_nodes(:,2)],[mapped_nodes(:,2); mapped_nodes(:,1)],L,N,N);

cd(current_dir)