function [D, h, m,x,y_n]=deg_dist(A,plot_flag)
% [D, h, m,x,y_n]=deg_dist(A,plot_flag)
% A - adjacency matrix
% plot_flag = 1 if you want a figure.
% 
% D - degree array. 
% h - degree index. 
% p - degree distribution (empirical).
% m - power law coefficient
% x - log scale for degree probabilities
% y_n log scale for distribution

D = sum(A);
%D = D/mean(D);
h=hist(D,[1:full(max(D))]);
h=h/sum(h);


x = log([1:full(max(D))]);
y = log(h);
% ignore -inf points (where there was no degree observed).
sift = y ~=-Inf;
y=y(sift)';
x=x(sift)';
X = [x ]; % ones(size(x))];
theta = inv(X'*X)*X'*y;
m=theta(1);

x = log([1:full(max(D))]);
y_n = exp(m*x);

if plot_flag 
	figure
	loglog([1:full(max(D))],h);
	xlabel('\it{k}');
	ylabel('it{p}');
	grid on
	hold on
	loglog([1:full(max(D))],y_n,'r--');
	legend('Data',['Best fit (\alpha=' num2str(m,2) ')']);
end

