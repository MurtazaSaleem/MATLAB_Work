Gravity = -1.622;
p = 500;
v = 60;
a = -7;

h = animatedline;
xlabel('X');
ylabel('lunar height (m)');
axis([-500 500 0 700]);
time_step = 0.1;

T = 0:time_step:10;

for t = T
    addpoints(h,dp,p);
    v = v + (Gravity + a) * time_step;
    p = p+v*time_step;
    dp = v*time_step;
    dv = a*time_step;
    pause(.1); %pause is not accurate
end
drawnow;