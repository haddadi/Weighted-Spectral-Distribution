function adj_matr = genab(X,N)
% adj_matr = genab(X,N)
% This is a function to generate an AB model 
% X - a vector with two parameters p,q. 
% N - size of the network. 
%
% adj_matr - the adjacency matrix. 
% NOTE: there is a problem with BRITE and the seed files. 
% the random number generators can fall into a loop. 
% for this reason a time out is applied and the process restarted if the algorithm dails to generate a graph in the specified time. 
% For large graphs this timeout might be too small. The default is 30
% seconds. To make this larger add a tiemout time as X(3). 
%
% 1st it is using an awk set of commands. (in parfit_ba2.awk)
% The commands 1st write a configuration file. 
% Then they execute BRITE with this file. 
% The resulting file then has the header removed ans this results in
% the file: edges_
% this is then read by matlab. (2nd line of this program!) 
% This file is a list of adjacencies which is used to generate and
% adjaceny matrix. 

global base_dir

p=X(1);
q=X(2);

if length(X)==3
    toc_time =X(3);
else 
    toc_time =30;   % default 30 seconds
end
    
% Check q < 1-p
if q >= 1-p 
	q
	q = 1-p-.01;
	disp('resetting q');
	q
end

% change directory to the models directory. 
current_dir = pwd;
cd([base_dir '/tools/models']);

% FIX: to deal with the bad seed files, good seed files have been stroed in
% /seeds, pick one at random. 
% load seed_files/seed_counter
% ran = ceil(rand*seed_counter);
% cmnd = ['!cp seed_files/seed' num2str(ran) ' ba_good_seed'];
% eval(cmnd);



% Execute the awk command that calls BRITE, write the output file and parses it for loading into matlab
!rm ab_edges.txt
!rm ab_finished.txt
make_ab_seed;

bad_seed_file = 1;
eval(['!awk -f genab.awk ' num2str(p) ' ' num2str(q) ' ' num2str(N) ' &']); % run it in the backrgound. 

tic
a=dir('ab_finished.txt');
failed_count = 0;
while(isempty(a) ) % it worked.

    a=dir('ab_finished.txt');
    if toc>toc_time    % give it 30 seconds to complete.
        unix('pkill awk');
        unix('pkill cppgen');
        disp(['bad seed file killing']);

        % try again! 
         !rm ab_edges.txt
        !rm ab_finished.txt
       make_ab_seed;
        tic
        eval(['!awk -f genab.awk ' num2str(p) ' ' num2str(q) ' ' num2str(N) ' &']); % run it in the backrgound. 
        !ps -a   
        failed_count= failed_count+1;
    end
    if failed_count == 3 
        % give the model longer to complete. 
        toc_time = toc_time+10;
        disp(['Brite timing out, increasing timeout time to ' num2str(toc_time)]);
        failed_count =0;
    end
    adj_matr=0;
end

adj_matr =zeros(N,N);

load ab_edges.txt

mapped_nodes = ab_edges+1; 
L = ones(size([mapped_nodes(:,2); mapped_nodes(:,1)]));
adj_matr=sparse([mapped_nodes(:,1) ; mapped_nodes(:,2)],[mapped_nodes(:,2); mapped_nodes(:,1)],L,N,N);

% change directory back 
cd(current_dir);

%figure
%spy(adj_matr)
%sum(sum(adj_matr))
