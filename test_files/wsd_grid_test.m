% first generate a BA model with 1000 nodes and random parameters: 

alpha = 0.3;
beta = 0.2;
X = [alpha beta];
N =500;
target = genab(X,N);
model = 'ab';

% make a grid for the BA model. 
i=1;
for alpha = [.0:0.1:.9]
    counter = [.0:0.1:.9];
    counter = counter(counter<=1-alpha);
    for beta = counter
         gryd(:,i) = [alpha; beta];
         i=i+1;
    end
end

nbin= 40;
iter_count = 2;
wsd_power = 4;
plot_flag = 'r--';
echo_flag = 0;

[results] = wsd_grid(model,target,gryd,nbin,iter_count, wsd_power, plot_flag,echo_flag);
