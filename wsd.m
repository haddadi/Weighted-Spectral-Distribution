% [w,index] = wsd(A,N,nbin,plot_flag,echo_flag)
% 
% A function to calculate the weighted spectral distribution.
% A - adjacency matrix. 
% N - power required, default 4.
% nbin - number of bins in which the distribution is estimated, default 50.
% plot_flag - (optional) place a string here for plotting ex: 'r--' 
% echo_flag - (optional) echo the number of bins remaining in the
% calculation.
%
% w - wsd
% index - index of bins. 
%
% [w,index] = wsd(A,N,nbin,plot_flag,echo_flag);
% 
% % ref: Weighted Spectral Distribution for Internet
% Topology Analysis: Theory and Applications,
% Damien Fay, Hamed Haddadi, Andrew G. Thomason, Andrew W. Moore, Richard Mortier, Almerima Jamakovic,
% Steve Uhlig, Miguel Rio

function [w,index] = wsd(A,N,nbin,plot_flag,echo_flag)

if nargin <5
    echo_flag = 1;
end
if nargin <4
    plot_flag = 1;
end
if nargin < 3 
    nbin = 50;
end
if nargin < 2 
    N = 4;
end

NL = norm_lap(A);
[v,pdf,cdf,index] = getspec(NL,nbin,echo_flag);
w = quaternion(pdf,index,N,plot_flag);
