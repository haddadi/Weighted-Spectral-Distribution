% [s,f] = str_freq(a)
% Given a vector of strings a
% this function returns the
% repeating strings and their frequencies.

function [s,f] = str_freq(a)
s=[];
f=[];
[row,col]=size(a);
i=1;
temp=sort(a);
st=temp(1);freq=1; k=1;

for i=2:row
    if temp(i)>temp(i-1);
        s(k,:)=st;
        f(k,:)=freq;
        st = temp(i);
        freq = 1;
        k=k+1;
    else
        freq=freq+1;
    end
end
s(k,:)=st;
f(k,:)=freq;
%disp 'helo'