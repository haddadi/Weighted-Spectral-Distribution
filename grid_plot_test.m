% A script to test grid_plot.m

% Generate a grid that should have two regions one centred around 1,2 and the other around 5,6

close all

xcords = [rand(3,1)+.5; rand(3,1)+4.5];
ycords = [rand(3,1)-15.5; rand(3,1)+25.5];

cost = [100 120 130 5 4 6]';
grid_plot([xcords ycords],cost)
hold on
plot(1,-15,'x');
plot(5,25,'rx');

[xcords ycords cost]
