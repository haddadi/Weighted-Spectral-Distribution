% A wrapper file to test the entropy rate of a diffusion process on a
% graph.

A = [0 1 0 0 0; 1 0 1 1 0; 0 1 0  0 1; 0 1 0 0 1; 0 0 1 1 0]; 


load A26.mat
j=max(size(A));
A(j,j)=0;
%[h,alpha] = entropy_rate(A,[-.5:.2:2]);
[h,alpha] = entropy_rate(A,[-.5:.2:2]);
%[h,alpha] = entropy_rate(A,[.]);

plot(alpha,h);
xlabel('\alpha');
ylabel('h');
grid on;