function [dis,coef] = spec_clus_coef(pdff,index,pl)

gain = index';
gain = gain-1;
gain = abs(gain.^3);
dis = pdff.*gain;
%dis = dis /sum(dis);
if pl ~= 1
    plot(index,dis,pl,'LineWidth',3);
end
coef = sum(dis);