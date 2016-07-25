function spwrite(filenam,A)

[i,j]= find(A==1);

t=[i j];
dlmwrite(filenam,t);
