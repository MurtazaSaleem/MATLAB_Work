% Demo program showing how to visualize aircraft flight data.
% Original script by Doug Hull of Mathworks, modified by Georg Feil.
clear;

% Set up axes
axis equal;
axis([-2 2 -2 11 -1.5 1.5]);
grid on;
view(3);

% Draw simple airplane made of cones and cylinders
[xc, yc, zc] = cylinder([0.1 0]);   % Cone
[x,   y,  z] = cylinder([0.2 0.2]); % Cylinder

h(1) = surface(xc,         zc,     -yc, 'FaceColor', 'red');
h(2) = surface(z,           y,   0.5*x, 'FaceColor', 'cyan');
h(3) = surface(-z,          y,   0.5*x, 'FaceColor', 'yellow');
h(4) = surface(x,      -1.5*z,   0.5*y, 'FaceColor', 'red');
h(5) = surface(xc, 1.5*yc-1.3,       z, 'FaceColor', 'red');

% Create a homogeneous transform to animate the airplane 
t = hgtransform;
set(h, 'Parent', t);  % Apply the transform to all surfaces in vector 'h'

% Define the aircraft trajectory. In a real application this data could come from a file.
longitude = [0  1   2  3  4   5  6  7   8  9 10]; %orig data
latitude  = [0  1   1  1  0   0  0 -1  -1 -1 -1]; %10 moves
bearing   = [0 -0.5 0  0  0.5 0  0  0.5 0  0  0]; %angle in radiant

% Interpolate trajectory data to smooth the motion
points = 150;       % Number of points after interpolation
len = length(longitude);
%build a new matrix interprets the points from the original 
longitude = interp1(1:len, longitude, linspace(1,len,points));
latitude = interp1(1:len, latitude, linspace(1,len,points));
bearing = interp1(1:len, bearing, linspace(1,len,points));

pause(3);

% Loop through the points updating the transform to animate the airplane
for i = 1:points
    M = eye(4);
    M = M * makehgtform('translate', [latitude(i) longitude(i) 0]);
    M = M * makehgtform('zrotate', bearing(i));
    set(t, 'Matrix', M);   % Update transformation matrix

    pause(0.05);     
end
