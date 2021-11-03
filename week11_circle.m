% Draw a sphere
[X, Y, Z] = sphere();
h = surf(X, Y, Z);% Set up axes
axis equal;
axis([-10 10 -10 10 -10 10]);% Create a transform
tf = hgtransform;
set(h, 'Parent', tf);  % Apply transform to the sphere
% Move the sphere in a circular path using translation
r = 8;  % Radius
for t = 0:.01:2*pi  % Theta (radians)
    M = makehgtform('translate', [0 r*sin(t) r*cos(t)]);
    set(tf, 'Matrix', M);   % Update transformation matrix
    pause(.01);  
end