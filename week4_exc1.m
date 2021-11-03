%Lorenz,
time = 0;
time_step = .01;
x = -8;
y = -9;
z = 25;

%Does not change
sig = 10;
rho = 28;
beta = 8/3;

h =animatedline;
h.MaximumNumPoints = 100;
not_done = true;
while not_done
    %%Model
    dx = sig*(y -x) * time_step;
    dy = (rho*x -x*z - y) * time_step;
    dz = (x*y -beta*z) * time_step;
    z= z+dz;
    y = y +dy;
    x = x+dx;
    
    
    time = time + time_step;
    
    %visualization
    addpoints(h, x, y, z);
    
    drawnow limitrate;
end
