%Murtaza Saleem
%991384804
%Assignment 3
clear;

% Set up axes
axis equal;
axis([-10 10 -10 10 -4 4]);% Create a transform
grid on;
view(3);



% Read the entire file into cell array 'fields'
f = fopen('driving_data.txt', 'rt');
if f == -1
    disp("Error opening file");
    return;
end
fields = textscan(f, '%f %f %f %f', 'Delimiter', ',');
fclose(f);

% Convert numeric data columns to regular vectors  
f1 = cell2mat(fields(1));
f2 = cell2mat(fields(2));
f3 = cell2mat(fields(3));
f4 = cell2mat(fields(4));

% Copy data to the matrices, assumes data values are in column-major order.
% Since Matlab stores matrices in column-major order we can pre-create the
% matrices with the correct dimensions then assign the element values with
% a single index like this: X(i) = value
for i = 1:size(f1)
    X(i) = f1(i);
    Y(i) = f2(i);
    Z(i) = f3(i);
    Heading(i) = f4(i);
end


%%Add light
l = light;           % Add a light
set(l, 'Color', [1 1 1], 'Position', [1 6 9]);  % Set light color (yellowish) and position


% Draw simple airplane made of cones and cylinders
[xc, yc, zc] = cylinder([0.1 0]);   % Cone
[x,   y,  z] = cylinder([0.2 0.2]); % Cylinder
[xs,   ys,  zs] = cylinder([0.5 0.5]); % Cylinder

% Define a transform per object and create the objects
t1 = hgtransform;      % Transform to use for the first (large) cube
%%Draw polygons
p = drawWireCube();
q = drawSecondCube();
s = drawSolarSurface();

%%Draw wheels
h(1) = surface(0.5*z-0.5,1+x,y, 'FaceColor', 'k'); 
h(2) = surface(0.5*z-0.5,x,y, 'FaceColor', 'k'); 
h(3) = surface(0.5*z+1,1+x,y, 'FaceColor', 'k');
h(4) = surface(0.5*z+1,x,y, 'FaceColor', 'k');
h(5) = surface(0.5*z+1,x-1,y, 'FaceColor', 'k');
h(6) = surface(0.5*z-0.5,x-1,y, 'FaceColor', 'k');

%h(5) = surface(zs,xs,ys, 'FaceColor', 'red');


V = [h p q s];
% Create a homogeneous transform to animate the airplane 
t = hgtransform;
set(V, 'Parent', t);  % Apply the transform to all surfaces in vector 'h'

l = light;           % Add a light
set(l, 'Color', [1 1 1], 'Position', [1 -5 0.5]);  % Set light color (yellowish) and position
material metal;

for i=1:size(h)
    h(i).LineStyle = 'none';
    h(i).FaceLighting = 'gouraud';
    h(i).AmbientStrength = 1;
end

% Define the aircraft trajectory. In a real application this data could come from a file.
longitude = X; %orig data
latitude  = Y; %10 moves
bearing   = Z; %angle in radiant

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
    M = M * makehgtform('translate', [latitude(i) longitude(i) bearing(i)]);
    %M = M * makehgtform('zrotate', bearing(i));
    M = M * makehgtform('zrotate', Heading(i));
    set(t, 'Matrix', M);   % Update transformation matrix

    pause(0.05);     
end


function p = drawWireCube()
    X = [0 1 1 0];
    Y = [0 0 1 1];
    Z = [0 0 0 0];
    p(1) = patch(X,Y,Z,[0.9290 0.6940 0.1250]);
    p(1).EdgeColor = [0 0.4470 0.7410];
    p(1).LineStyle = 'none';
        
    X = [0 1 1 0];
    Y = [0 0 1 1];
    Z = [1 1 1 1];
    p(2) = patch(X,Y,Z,[0 0.4470 0.7410]);
    p(2).EdgeColor = [0 0.4470 0.7410];
    p(2).LineStyle = 'none';
    
    X = [0 1 1 0];
    Y = [0 0 0 0];
    Z = [0 0 1 1];
    p(3) = patch(X,Y,Z,[0.9290 0.6940 0.1250]);
    p(3).EdgeColor = [0 0.4470 0.7410];
    p(3).LineStyle = 'none';
    
    X = [1 1 1 1];
    Y = [0 1 1 0];
    Z = [0 0 1 1];
    p(4) = patch(X,Y,Z,[0.9290 0.6940 0.1250]);
    p(4).EdgeColor = [0 0.4470 0.7410];
    p(4).LineStyle = 'none';
    
    X = [1 0 0 1];
    Y = [1 1 1 1];
    Z = [0 0 1 1];
    p(5) = patch(X,Y,Z,[0.9290 0.6940 0.1250]);
    p(5).EdgeColor = [0 0.4470 0.7410];
    p(5).LineStyle = 'none';
    
    X = [0 0 0 0];
    Y = [0 0 1 1];
    Z = [0 1 1 0];
    p(6) = patch(X,Y,Z,[0.9290 0.6940 0.1250]);
    p(6).EdgeColor = [0 0.4470 0.7410];
    p(6).LineStyle = 'none';
    
end


function q = drawSecondCube()
    X = [0 1 1 0];
    Y = [0 0 -1 -1];
    Z = [0 0 0 0];
    q(1) = patch(X,Y,Z,[0.9290 0.6940 0.1250]);
    q(1).EdgeColor = [0 0.4470 0.7410];
    q(1).LineStyle = 'none';
    
    X = [0 1 1 0];
    Y = [0 0 -1 -1];
    Z = [1 1 1 1];
    q(2) = patch(X,Y,Z,[0 0.4470 0.7410]);
    q(2).EdgeColor = [0 0.4470 0.7410];
    q(2).LineStyle = 'none';
    
    X = [0 1 1 0];
    Y = [0 0 0 0];
    Z = [0 0 1 1];
    q(3) = patch(X,Y,Z,[0.9290 0.6940 0.1250]);
    q(3).EdgeColor = [0 0.4470 0.7410];
    q(3).LineStyle = 'none';
    
    X = [1 1 1 1];
    Y = [0 -1 -1 0];
    Z = [0 0 1 1];
    q(4) = patch(X,Y,Z,[0.9290 0.6940 0.1250]);
    q(4).EdgeColor = [0 0.4470 0.7410];
    q(4).LineStyle = 'none';
    
    X = [1 0 0 1];
    Y = [-1 -1 -1 -1];
    Z = [0 0 1 1];
    q(5) = patch(X,Y,Z,[0.9290 0.6940 0.1250]);
    q(5).EdgeColor = [0 0.4470 0.7410];
    q(5).LineStyle = 'none';
    
    X = [0 0 0 0];
    Y = [0 0 -1 -1];
    Z = [0 1 1 0];
    q(6) = patch(X,Y,Z,[0.9290 0.6940 0.1250]);
    q(6).EdgeColor = [0 0.4470 0.7410];
    q(6).LineStyle = 'none';
    
end

function t = drawSolarSurface()
    X = [1.5 -0.5 -0.5 1.5];
    Y = [0.5 0.5 -1 -1];
    Z = [1 1 1 1];
    t = patch(X,Y,Z,[0 0.4470 0.7410]);
    t.EdgeColor = [0.9290 0.6940 0.1250];
    t.LineStyle = 'none';
    t.FaceLighting = 'gouraud';
end