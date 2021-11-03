h = animatedline;
figure;
x = -10:.1:10;
%x = linspace(-1000, 0, 1000);

ylabel("Y axis");
xlabel("X axis");
e = size(x);
tic;
for i= 0:9
    y = x.^i;
    plot(x,y);
    axis([-10 10 -10 10]);
    toc;
    drawnow;
    pause(0.5)
end