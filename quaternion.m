function dis = quaternion(pdff,index,N,pl)

% this function calculate a weighted spectrum, given the spectrum

gain = index';
gain = gain-1;
gain = abs(gain.^N);
dis = pdff.*gain;

if ischar(pl) 
    plot(index,dis,pl,'LineWidth',3);
end
