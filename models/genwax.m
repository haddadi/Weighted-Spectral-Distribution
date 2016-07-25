function [adj_matr]=waxman(X,N,options) 
% function [adj_matr]=waxman(alpha,beta,N,options) 
% Produces a waxman model size N with P(a->b) = alpha*e(-beta d_a_b)
% where d_a_b is the normalised distance between a and b which are uniformly dist on a 2-D grid. 
% 
% options - (optional) 1 return the raw model (default). 
% 	  - 2 return only the largest component. 
%         - 3 connect disconnected components to the largest component at random. (may result in a core like topology not waxman at all).  
%     	  - 4 Connect largest and second largest at random - then 3rd largest to 1+2 and so on. 			
alpha = X(1);
beta = X(2);

if ~exist('options') 
	options = 1;
end


 domain = [0 10 0 10]; % define the 2-d plane
 xmin = domain(1); 
 xmax = domain(2);
 ymin = domain(3);
 ymax = domain(4);
 clear domain;
 
 % number of points is Poisson distributed 
 % with intensity proportional to the area
 area = (xmax-xmin)*(ymax-ymin); 
 npoints = N;
 
 % given the number of points, nodes are uniformly distributed
 nd_coord = rand(npoints, 2);
 disp(['Starting (alpha =' num2str(alpha) ', beta =' num2str(beta) ')' ]);
 temp = (pdist(nd_coord, 'euclidean'));
 disp('distances calcualted ');
 M =max(temp);

 temp2 = temp /beta*M;
 
 clear temp;

 temp2 = -temp2;

 prob = alpha*exp(temp2);

 clear temp2

 prob_matr = sparse(triu(squareform(prob)));

 clear prob

 [row,col]=size(prob_matr);			% Break matrix into [A B;C D] for memory reasons.
 A = prob_matr(1:row/2,1:col/2);
 B =  prob_matr(1:row/2,1+col/2:col);
 C =  prob_matr(1+row/2:row,1:col/2);
 D =  prob_matr(1+row/2:row,1+col/2:col);

 runi = sprand(A);
 %disp('stage 1');
 adj_matr_A = (runi>0) & (runi < A);
 runi = sprand(B);
 %disp('stage 2');
 adj_matr_B = (runi>0) & (runi < B);
 runi = sprand(C);
 %disp('stage 3');
 adj_matr_C = (runi>0) & (runi < C);
 runi = sprand(D);
 adj_matr_D = (runi>0) & (runi < D);

 adj_matr = [adj_matr_A adj_matr_B ;adj_matr_C adj_matr_D]; 
 disp('finished');
clear A B C D adj_matr_A adj_matr_B adj_matr_C adj_matr_D
 % generate the adjacency matrix
%  runi = sprand(prob_matr);
%  disp('hi1');
%  adj_matr = (runi>0) & (runi < prob_matr);
 adj_matr =adj_matr +adj_matr';

 if options >1
         [ci sizes] = components(adj_matr);
         [comp_size,comp_id]=sort(sizes,'descend');
 end
 switch options
     case 1
         return;
         
     case 2             % return only the largest component. 
         inds=find(ci==comp_id(1));
         adj_matr = adj_matr(inds,inds);    % the largest component. 
                  
     case 3             % Connect to largest component. 
         con_inds = find(ci==comp_id(1));
         L = length(con_inds);
         for j=2:length(comp_id)
             comp_inds = find(ci==comp_id(j));
             L2 = length(comp_inds);
             a = ceil(rand*L);      % A randomly chosen node in main component. 
             b = ceil(rand*L2);     % A randomly chosen node in sub component j. 
             adj_matr(con_inds(a), comp_inds(b))=1; % connect a--> b. 
         end
         
     case 4             % Connect iteratively. 
         for j=1:length(comp_id)
         end
 end
 
      
         
         
 end

