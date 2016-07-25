% expect a disconnected waxman model. 
A=wax(.1,.1,500,1); 
spy(A)
% expect a waxman model with about 200 nodes. 
A=wax(.1,.1,500,2); 
spy(A)
[ci,i]=components(A);
i % should be a single number.
% expect a waxman model with 500 nodes. Should look a bit 'coreish'
A=wax(.1,.1,500,3); 
spy(A)
[ci,i]=components(A);
i % should be a single number.


