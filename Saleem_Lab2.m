%%Muhammad Saleem
%%991384804

% INFO48874 Lab 2, Prof. Georg Feil, "Mystery Shape"
clear;
view(3);

% Define dimensions of the polygon mesh and initialize 80 by 30 vertex matrices
rows = 80;
cols = 30;
X = zeros(rows, cols); Y = X; Z = X;

% Read the entire file into cell array 'fields'
f = fopen('mesh_data.txt', 'rt');
if f == -1
    disp("Error opening file");
    return;
end
fields = textscan(f, '%f %f %f', 'Delimiter', ',');
fclose(f);

% Convert numeric data columns to regular vectors  
f1 = cell2mat(fields(1));
f2 = cell2mat(fields(2));
f3 = cell2mat(fields(3));

% Copy data to the matrices, assumes data values are in column-major order.
% Since Matlab stores matrices in column-major order we can pre-create the
% matrices with the correct dimensions then assign the element values with
% a single index like this: X(i) = value
for i = 1:rows*cols
    X(i) = f1(i);
    Y(i) = f2(i);
    Z(i) = f3(i);
end


% Your code goes here...
h = surf(X,Y,Z);
axis([-2 2 -2.5 2 -1 1]);% Create a transform
l = light;           % Add a light
set(l, 'Color', [.8 .8 .2], 'Position', [4 4 1]);  % Set light color (yellowish) and position
% Add a 2 light
l2 = light
set(l2,'Color', [.8 .8 .2], 'Position', [-4 -4 -1]);  % Set light color (yellowish) and position

%remove lines and smooth
lighting gouraud;    % Change from flat to Gouraud shading, 'gouraud' preferred for curved surfaces
shading flat;


tf = hgtransform;
set(h, 'Parent', tf);  % Apply transform to the sphere
% Move the sphere in a circular path using translation
r = 1.5;  % Radius
for t = 0:.01:2*pi  % Theta (radians)
    M = makehgtform('translate', [r*sin(t) r*sin(t) 0]);
    M = M * makehgtform('yrotate', r);  % Rotation angle in radians
    M = M * makehgtform('xrotate', r);  % Rotation angle in radians
    set(tf, 'Matrix', M);   % Update transformation matrix
    pause(.01);  
end