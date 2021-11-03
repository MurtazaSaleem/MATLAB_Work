% Simple mountain formation simulation by Georg Feil, Sheridan College, 2018.
% Written for INFO48874.
clear;

% Constants. Try adjusting these.
MAX_HEIGHT = 5;    % Maximum mountain height
DETAILX = 16;      % Controls the size of the mesh in x direction (DETAILX*2+1 vertices)
DETAILY = 12;      % Controls the size of the mesh in y direction (DETAILY*2+1 vertices)

% Create figure window
h_fig = figure('Name', 'Mountains');
pos = get(h_fig, 'Position');
set(h_fig, 'Position', [pos(1)/1.5  pos(2)/5  pos(3)+pos(1)/1.5  pos(4)+(pos(1)/1.5 * 3/4)]);  % Enlarge

% Create rectangular polygon mesh.
% X, Y, and Z matrices contain coordinates of all mesh vertices. Rows (2nd index)
% are aligned with the x axis, columns (1st index) with the y axis. 
% Note this is transposed compared to matrix 'h'.
XMAX = DETAILX; XMIN = -DETAILX; YMAX = DETAILY; YMIN = -DETAILY;
xVec = XMIN:1:XMAX;     % Range of x values
yVec = YMIN:1:YMAX;     % Range of y values
xLen = length(xVec);    % Width of mesh in the x direction
yLen = length(yVec);    % Length of mesh in the y direction
[X, Y] = meshgrid(xVec, yVec);  % X and Y matrices contain x and y coordinates of all mesh vertices

% Initial Z values, all zeroes.
Z = zeros(yLen, xLen);

% Draw the mesh. We only call this function once, vertex Z values will
% be updated later to animate the mesh.
s = surf(X,Y,Z);

% Label the x, y, z axes
xlabel('x', 'Color', 'r');      % red
ylabel('y', 'Color', [0 .6 0]); % dark green
zlabel('z', 'Color', 'b');      % blue

axis equal;          % Set equal axis scaling for consistent aspect ratio
camzoom(1.4);        % zoom into scene a bit
l = light;           % Add a light
set(l, 'Color', [.8 .8 .2], 'Position', [1 1 9]);  % Light color (yellowish) and position
lighting gouraud;    % Use Gouraud shading, preferred for curved surfaces

% Simulation model variables
h = zeros(xLen, yLen);  % Terrain height matrix, controls the height of each mesh vertex
seed = randi(10000000); % Use a different seed each run, but same seed each main loop iteration

% Repeat to "grow" the terrain
for height = 0.001:.1:MAX_HEIGHT
    rng(seed);        % seed the generator so random terrain is the same each time around loop

    % Create a simple growing terrain by randomizing height values at (odd, odd) indices and
    % interpolating height values at other indices.
    for x = 1:2:xLen
        for y = 1:2:yLen
            h(x, y) = rand * height;   % Random number from 0 to 'height'
        end
    end
    for x = 2:2:xLen-1
        for y = 2:2:yLen-1
            h(x, y) = (h(x-1, y-1) + h(x-1, y+1) + h(x+1, y+1) + h(x+1, y-1))/4; 
        end
    end
    for x = 2:2:xLen-1
        for y = 3:2:yLen-2
            h(x, y) = (h(x, y-1) + h(x-1, y) + h(x, y+1) + h(x+1, y))/4; 
        end
    end
    for x = 3:2:xLen-2
        for y = 2:2:yLen-1
            h(x, y) = (h(x, y-1) + h(x-1, y) + h(x, y+1) + h(x+1, y))/4; 
        end
    end

    % Do the edges
    for x = 2:2:xLen-1
        h(x, 1) = (h(x-1, 1) + h(x+1, 1) + h(x, 2))/3; 
        h(x, yLen) = (h(x-1, yLen) + h(x+1, yLen) + h(x, yLen-1))/3; 
    end
    for y = 2:2:yLen-1
        h(1, y) = (h(1, y-1) + h(1, y+1) + h(2, y))/3; 
        h(xLen, y) = (h(xLen, y-1) + h(xLen, y+1) + h(xLen-1, y))/3; 
    end

    s.ZData = h';   % Replace surface z values to animate the mesh

    drawnow;
    pause(0.05);    % pause to control animation speed (simulation time is uncalibrated)
    if ~ishghandle(h_fig)   % Quit if user closes the figure window
        return;
    end

end
