% [s,f,group] = mat_freq(a)
% A sorting function specially written to sort an integer matrix and find
% out how many unique rows (ie classes) there are and where they are. 
% a - matrix. 
%
% s - unique rows. 
% f - frequency
% group - group label.

function [s,f,group] = mat_freq(a)
s=[];
f=[];
[row,col]=size(a);
i=1;
[temp,inds]=sortrows(a);
st=temp(1,:); freq=1; k=1; group=1;

for i=2:row
    if sum(temp(i,:)~=temp(i-1,:));
        s(k,:)=st;
        f(k,:)=freq;
        st = temp(i,:);
        freq = 1;
        k=k+1;
        group(i,:)=k;
    else
        freq=freq+1;
        group(i,:)=k;
    end
end
s(k,:)=st;
f(k,:)=freq;
d(inds)=group;
group =d';
%disp 'helo'