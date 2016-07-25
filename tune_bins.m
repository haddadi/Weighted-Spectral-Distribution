function [bins] = tune_bins(bins,NL)
% A function to find the optimal distribution of bins for a 4-cycle WSD.
% bins -initial bin guess - min and max will stay the same. 
% NL the norm laplacian of the graph. 

bin_new=bins;
nbins = length(bins);
bins(1) = -.00000001;
bins(nbins) = 2.00000001;
figure
for iter=1:1
[pdf,cdf,index] = getspec2(NL,bin_new);
weighted = quaternion(pdf,index,1);
plot(index,weighted)
hold on

% Now there should be the same amount of weight in each bin at the optimal
% distribution - mu. 
% We must ignore the eignevalues at 1 and 2 exactly otherwsie the algorithm
% will try 

mu = mean(weighted);
numbers = cumsum(weighted/mu); % the number of new bins that should be in the old bins. 
delta(:,1) =[1:length(numbers)]/10000;
centres=(bin_new(1:nbins-1)+diff(bin_new)/2)';
bin_new =interp1([0;numbers+delta],[0 bin_new(2:nbins-1) 2],[0:nbins-1])
bin_new = [bins(1) bin_new(2:nbins-1) bins(nbins)];




% Based on this assign the new bins. 

% % calculate the cdf of the WSD.
% cdf = [0; cumsum(weighted)];
% % use a simple interpolation to estimate the new bin points
% for i=1:length(bin_new)-1
%     j=max(find(cdf<i*mu));
%     % simple interpolation
%     y1 = cdf(j);
%     x1 = bin_new(j);
%     y2 = cdf(j+1);
%     x2 = bin_new(j+1);
%     m=(y1-y2)/(x1-x2);
%     c=y1-m*x1;
%     x_star(i) = ((i*mu)-c)/m;
% end
% bin_new=[bins(1) x_star];
end

bins = bin_new;
[pdf,cdf,index] = getspec2(NL,bin_new);
weighted = quaternion(pdf,index,1);
plot(index,weighted,'k-x')