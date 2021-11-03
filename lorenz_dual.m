% Lorenz attractor simulation with two particles. Demonstrates differences
% in behaviour resulting from tiny changes of initial conditions.
% This is an example of the Lorenz "butterfly" (chaos) effect and is also
% an example of sensitivity analysis.
% Written by Georg Feil for INFO48874, Sheridan College.
time = 0;
time_step = 0.0001;
x = -8; y = -9; z = 25;             % Initial conditions for red line
x2 = -8.00000000000001; y2 = -9; z2 = 25; % Initial conditions for blue line

% Create two animated lines with different colours
h = animatedline;
set(h, 'Color', 'red');
h2 = animatedline;
set(h2, 'Color', 'blue');

axis([-20 20  -25 25  5 45]); % Set plot axis ranges
set(gca, 'Clipping', 'off');
p = get(gcf, 'Position');
set(gcf, 'Position', [p(1)/1.5  p(2)/3  p(3)+p(1)/1.5  p(4)+(p(1)/1.5 * 3/4)]);  % Enlarge
view(33, 10);        % Set camera viewpoint
camzoom(1.1);        % zoom into scene a bit

% Draw spheres as position markers
[X, Y, Z] = sphere(12);
X = X * 0.45; Y = Y * 0.45; Z = Z * 0.45; % Scale sphere
s = surface(X, Y, Z);
t = hgtransform;
set(s, 'Parent', t);

s2 = surface(X, Y, Z);
t2 = hgtransform;
set(s2, 'Parent', t2);

shading flat;   % Remove mesh lines on spheres and set colours
set(s, 'FaceColor', 'red');
set(s2, 'FaceColor', 'blue');

% Main loop
for step = 1:100000000
    [x, y, z] = update(x, y, z, time_step);
    [x2, y2, z2] = update(x2, y2, z2, time_step);
    
    if mod(step, 20) == 0 
        set(t, 'Matrix', makehgtform('translate', [x y z]));   % Update transformation matrix
        set(t2, 'Matrix', makehgtform('translate', [x2 y2 z2]));   % Update transformation matrix
        addpoints(h, x, y, z);
        addpoints(h2, x2, y2, z2);
    end
    
    if mod(step, 200) == 0 
        drawnow;
    end
end

% Calculate one step of the simulation.
function [xo, yo, zo] = update(x, y, z, time_step)
    dx = 10*(y - x) * time_step;	
    dy = (28*x - x*z - y) * time_step;
    dz = (x*y - 8/3*z) * time_step;
    xo = x + dx;
    yo = y + dy;
    zo = z + dz;
end
