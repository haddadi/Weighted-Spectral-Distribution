% first generate a BA model with 1000 nodes and random parameters: 

alpha = 0.3;
beta = 0.2;
X = [alpha beta];
N =500;
target = genab(X,N);
model = 'ab';
X0 = [0.4 0.1];
nbin= 40;
iter_count = 2;
wsd_power = 4;
plot_flag = 'r--';
echo_flag = 0;

[results] = wsd_tune(model,target,X0,nbin,iter_count, wsd_power, plot_flag,echo_flag);
