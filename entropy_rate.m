% A function to calculate the entropy of a graph. 
% A - adjacency matrix. 
% Alpha - the power that biases the out-degree. f_j=x_j^alpha. 
% 
% ref: J. Gomez-Gardenes, V. Latora, Entropy rate of diffusion processes on
% complex networks, July 2008. 

function [h alpha] =entropy_rate(A,alpha)

for i=1:length(alpha)
    D_out = sum(A,2); % i->j the degree of j. 
    f=A*diag(D_out);
    f(f~=0)=f(f~=0).^alpha(i); % An NxN matrix with the degrees of the nodes that link to the source node. 
                            % i.e. f(2,3) is the degree^alpha of node 3 iff 2->3.
    f_local = D_out;
    f_local(f_local~=0)=f_local(f_local~=0).^alpha(i);
    C = sum(f,2); % Nx1 vector with just the sum of the properties wrt node i = c_i 
                  % Note the adjacency matrix is not required as f already
                  % contains this intrinsically. i.e. if a_i_j = 0 f_i_j = 0
                  % already. 
    % take the denominator first: sum(c_i*f_i) --> note c_i is the sum of
    % properties that i is going to and f_i is the property at node i. 
    denom = f_local'*C;
    
    % nominator
    % 1st part relates the product of the node we're at to the sum of the
    % entropies of nodes we're going to. 
    
   
    % g=log(f);       These two command take forever, faster way below. 
    % g(g==-Inf)=-999;    % There are some -infs to take care of. 
   
    g=f; 
    g(g~=0)=log(g(g~=0)); % take the log of just the non-zero elements and dump them back into the right place.
    
    T = A.*f.*g;        % T is an NxN matrix containing the elements used in the inner sum. a_ij*x_j^alpha*ln(x_j^alpha)
    T2 = diag(f_local)*T; % an NxN containing x_i^alpha *a_ij*x_jln(x_j^alpha). 
    T3 = sum(sum(T2)); % sum the lot. 
    
    % 2nd part should be similar. 
    a=log(C);
    a(a<-10000)=0;
    T4 = f_local.*C.*a;
    T4 = sum(T4);
    
    h(i) = -(T3-T4)/denom;
    length(alpha)-i
end

