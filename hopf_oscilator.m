%state
clear
clc
%%
x0 = [1,1,2,2];
y0 = [0,0,0,0];
tf = 1;
[t,XY] = ode45(@hopf,[0,tf],[x0';y0']);
%%
figure(1)
plot(t,XY(:,1))
hold on
plot(t,XY(:,3))
%%
figure(2)
plot(XY(:,1),XY(:,5))