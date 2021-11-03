% Sinc function in 3D using a mesh plot.

% Create square polygon mesh.
% X, Y, and Z matrices contain coordinates of all mesh vertices. Rows (2nd index)
% are aligned with the x axis, columns (1st index) with the y axis. 
vec = linspace(-4*pi, 4*pi, 100); % Vector of x (or y) values from -4pi to 4pi (makes mesh dense)
[X, Y] = meshgrid(vec);
Z = zeros(length(vec));  % Z controls height of each mesh vertex

for x = 1:length(vec)
    for y = 1:length(vec)
        r = sqrt(vec(x)^2 + vec(y)^2) + eps; % Calculate r = sqrt(x*x + y*y). The 'eps' avoids divide by zero.
        Z(x,y) = sin(r)/r;  % Sinc function
    end
end

s1 = surf(X, Y, Z);              % Draw the mesh. For non-square Z may need to use Z' here.

s1.CData = rand(size(Z));% Set random vertex colour