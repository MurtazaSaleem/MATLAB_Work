h = animatedline;
xlabel('time (s)');
ylabel('ball height (m)');
axis([0 6 0 60]);

p = 0; %height
v = 28; %ball velocity
a =-9.8; %gravity acceleration
time_step = 0.1;

T = 0:time_step:6;
for t = T
    addpoints(h,t,p);
    p = p+v*time_step;
    v = v+a*time_step;
    pause(.1); %pause is not accurate
end
drawnow;