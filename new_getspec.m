function [v,pdf,cdf,index] = getspec(NL,nbin,echo_flag)
% function [v,pdf,cdf,index] = getspec(NL,nbin)
% NL - normalised laplacian matrix -sparse
% nbin - number of bins - make odd to ensure 0 at centre
% v - number of eigenvalues in each bin. 
% pdf, cdf - densities. 
% index - index for the bins. 

n = length(NL);

lmax = 2.01;
lmin = -0.01;


binsize = (lmax - lmin)/nbin;

% Upperbound of the bins.
shift = [lmin+binsize:binsize:lmax];

% Cummulative number of eigenvalues in a bin is stored in v2.
% The second coefficient correspond to the number of eigenvalues that is
% smaller than lmin+binsize, the third coeeficient to the numbers of eigenvalues
% smaller than lmin+2binsize, etc. v2(1) = 0 to be able to use the function 
% diff to compute the number of eigenvalues in a bin.
v2 = zeros(nbin+1,1);
I = speye(n,n);

% Eigenvalue count based on Sylvester's law of Inertia.
p = symamd(NL);
for i = 1:nbin
   thresh = 0;
   B = NL(p,p) - shift(i)*I;
   spparms('piv_tol',0);
   if echo_flag
   disp(['spectrum bin ' num2str(i) ' of ' num2str(nbin)]);
   end
   [LL, U, P] = lu(B,thresh);
   pivots = diag(U);
   v2(i+1,:) = sum( pivots < 0 );
end
% v(i) gives the number of eigenvalues in bin i.
% This should be the correct number, not an approximation.
v = diff(v2);
pdf = v/(v2(nbin+1)*binsize);

% Generation of the CDF.
temp = cumsum(pdf);
cdf = temp/temp(nbin);
size(cdf);

%Generation of the x-axes.
x = lmin+(binsize/2):binsize:lmax-binsize+(binsize/2);
size(x);
index =x;
pdf = v/sum(v);
cdf = cumsum(pdf);


