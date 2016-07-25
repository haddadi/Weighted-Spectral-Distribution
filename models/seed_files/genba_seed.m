function adj_matr = genba_seed(X,N)

global base_dir
load seed_counter
% Special version of genba to allow checking if the seed file is working. 

% adj_matr = genba(X,N)
% This is a function to generate a BA2 model 
% X - a vector with two parameters p,q. 
% N - size of the network. 
%
% adj_matr - the adjacency matrix. 
% NOTE: there is a problem with BRITE and the seed files. 
% the random number generators can fall into a loop. 
% for this reason a good seed file is chosen at random from the directory
% /seedfiles before executing. 
% this may cause problems when a truly random graph is required for
% generation. 

%
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

N
% Check q < 1-p
if q >= 1-p 
	q
	q = 1-p-.01;
	disp('resetting q');
	q
end

% change directory to the models directory. 
current_dir = pwd;
cd([base_dir '/tools/models/seed_files']);
% Execute the awk command that calls BRITE, write the output file and parses it for loading into matlab
!rm ba_edges.txt

eval(['!awk -f genba.awk ' num2str(p) ' ' num2str(q) ' ' num2str(N) ' &']); % run it in the backrgound. 
% count for a moment and then check if the output has been written, if not
% break.
tic
a=dir('ba_edges.txt');
while(isempty(a) ) % it worked.

    a=dir('ba_edges.txt');
    if toc>20    % give it 30 seconds to complete.
        [sta,proces]=unix('ps -a | grep cppgen');
        inds = regexp(proces,[' ']); % find the spaces. 
        disp('bad seed file killing');
        unix(['kill -9 ' proces(1:inds(1)) ]);
        adj_matr=0;
        return
    end
end

while a.bytes < 1 % fix error that occurs between file being created and written. \
        a=dir('ba_edges.txt');
end
    
% it got to here so it must be a good seed file. 
cmnd = ['!cp ba_good_seed seed' num2str(seed_counter) ];
eval(cmnd);
seed_counter = seed_counter +1;

load ba_edges.txt

mapped_nodes = ba_edges+1; 

adj_matr =zeros(N,N);
L = ones(size([mapped_nodes(:,2); mapped_nodes(:,1)]));
adj_matr=sparse([mapped_nodes(:,1) ; mapped_nodes(:,2)],[mapped_nodes(:,2); mapped_nodes(:,1)],L,N,N);

% change directory back 
cd(current_dir);
save seed_counter seed_counter

%figure
%spy(adj_matr)
%sum(sum(adj_matr))
