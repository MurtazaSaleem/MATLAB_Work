% Lorenz attractor
% Initialization – init state variables, e.g. time, pos x/y
time = 0;
time_step = .0001;
p = [-8 -9 25];
% Constants
sig = 10;
rho = 28;
beta = 8/3;

% Create the plot/figure/animatedline, label axes etc.
h = animatedline;

% Main loop
not_done = true;
while not_done
    % Perform model calculations & update state variables 
    dp(1) = sig*(p(2) - p(1)) * time_step;	
    dp(2) = (rho*p(1) - p(1)*p(3) - p(2)) * time_step;
    dp(3) = (p(1)*p(2) - beta*p(3)) * time_step;
    p = p + dp;

    time = time + time_step;

    % Draw visualization and control simulation speed
    addpoints(h, p(1), p(2) , p(3));
    drawnow limitrate;
    %pause(time_step);
end
