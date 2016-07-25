function percentile_contour(X,x_cords,y_cords,p)
% percentile_contour(X,x_cords,y_cords,p)
% produces a contour plot in which the colours are divided in the range of
% the percentiles of the data (very useful when a linear scale does not
% reveal the salient features).
% X - an NxM matrix with the values. 
% x-cords - the x co-ordinates (Nx1).
% y-cords - the x co-ordinates (Mx1).
% p - percentile splits. ex: [0:.1:1] will do each 10%. 

[row,col]=size(X);
temp=reshape(X,1,row*col);
temp=temp(temp>0);
a=quantile(temp ,p);

l=length(a);
L=X;
for i =1:l
    a(l+1)=inf;
    L(X>=a(i) & X<a(i+1)) = i;
end

contourf(x_cords,y_cords,L',1:l);
colorbar
labels = num2cell(p);
colorbar('YTickLabel',labels)