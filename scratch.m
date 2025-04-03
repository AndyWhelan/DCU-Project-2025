%{
clear all
X = [3 9 27]; % my dependent vector of interest
t = [1 2 3]; % my independent vector
figure; % create new figure
plot(t,X);
title('Plot of Distance over Time'); % title
ylabel('Distance (m)'); % label for y axis
xlabel('Time (s)'); % label for x axis
%}
x = linspace(0,2*pi,100);
y = sin(x);
plot(x,y)