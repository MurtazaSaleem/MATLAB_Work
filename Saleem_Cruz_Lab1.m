%%LAB 1 - Murtaza Saleem - Arceline Cruz
%% Sky diving simulator plot km/hr

h = animatedline;
h2 = animatedline;
xlabel('time (s)');
ylabel('sky diver height (m) / velocity (km/h)');

%%Constanst
WEIGHT = 85; %kg
g = 9.8; %m/s
k = 0.25; %air resistance proportial to v^2
time_step = 0.01;

%Variables
%a = dv/dt;
v = 0; %initial vertical velocity of 0 3.6
s = 0; %speed aaginst air
p = 2000; %initial position
%gravity and airresistance

%while p>0
T = 0:time_step:p;
for t = T
    addpoints(h,t,p);
    addpoints(h2,t,v*3.6);
    
    [time p v v*3.6]
    
    a = g - (k*v^2)/WEIGHT;
    dv = a * time_step;
    dp = -v*time_step;
    v = v+dv;
    p = p+dp;
    
    time = time + time_step;
    if p < 0
        break;
    end
    drawnow limitrate
  
end