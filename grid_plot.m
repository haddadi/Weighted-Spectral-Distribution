function grid_plot(gryd,cost)
% grid_plot(gryd,cost)
%  gryd - an N*2 matrix with [x cords y cords]
%  cost - an N*1 array with the value at each co-ordinate
% plot a percentile grid - filling in empty values.
x = unique(gryd(:,1));
y = unique(gryd(:,2));
L=length(cost);
C=zeros(length(x),length(y));
for i=1:L
    x_cord = find(x==gryd(i,1));
    y_cord = find(y==gryd(i,2));
    C(x_cord,y_cord) = cost(i);
end
p=[0:.1:.9 .93 .96 1];
percentile_contour(C,x,y,p)
