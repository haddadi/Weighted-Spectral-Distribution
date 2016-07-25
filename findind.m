% Find index i,j such that b(i,j) is the nearest value in b to a.
% function [i j] = findind(a,b)
function [i,j] = findind(a,b)
small=abs(a-b(1));
i=1;j=1;
[row,col]=size(b);
for n=1:row
   for m=1:col
	if(abs(a-b(n,m)) < small)
	small=abs(a-b(n,m));	
	i=n;j=m;	
   end   
end
end