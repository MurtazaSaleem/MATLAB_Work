h = animatedline;
h2 = animatedline('Color', 'red');
% Create more than one animatedline
xlabel('time (s)');
ylabel('ball height (m), \color{red}ball velocity (m/s)');
axis([0 6 -30 60])fo 
p = 0;            % Ball position (height in m), initially zero
v = 28;           % Ball velocity (m/s), going up initially 
a = -9.8;         % Acceleration (m/s/s), constant
time_step = .1;  % Delta t (sec)
T = 0:time_step:6;   % Vector of time points along x (time) axis
for t = T
    addpoints(h, t, p);
    addpoints(h2, t, v);
    p = p + v * time_step;
    % Update height and velocity for next step
    v = v + a * time_step;
    pause(time_step);
end