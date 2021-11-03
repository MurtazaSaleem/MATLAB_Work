% Closed 3D surface mesh (sphere) with animation
clear;
theta = 0:pi/40:pi;                   % polar angle
phi = 0:pi/20:2*pi;                   % azimuth angle

[phi,theta] = meshgrid(phi,theta);    % define the grid
degree = 6;
order = 1;
amplitude = 0.5;
radius = 5;

Ymn = legendre(degree,cos(theta(:,1)));
Ymn = Ymn(order+1,:)';
yy = Ymn;

for kk = 2: size(theta,1)
    yy = [yy Ymn];
end

yy = yy.*cos(order*phi);  

order = max(max(abs(yy)));
rho = radius + amplitude*yy/order;

r = rho.*sin(theta);    % convert to Cartesian coordinates
x = r.*cos(phi);
y = r.*sin(phi);
z = rho.*cos(theta);

h_fig = figure;
s = surf(x,y,z);     % Create mesh surface (filled polygons)

light;               % add a light
lighting gouraud;    % preferred lighting for a curved surface
axis off equal;      % set axis equal and remove axis
view(40,30);         % set viewpoint
camzoom(1.5);        % zoom into scene

scale = [linspace(0,1,20) linspace(1,-1,40) linspace(-1,0,20)];    % surface scaling (0 to 1 to -1 to 0)

while true
    for ii = 1:length(scale)

        rho = radius + scale(ii)*amplitude*yy/order;   

        r = rho.*sin(theta);
        x = r.*cos(phi);       
        y = r.*sin(phi);
        z = rho.*cos(theta);

        s.XData = x;    % replace surface x values
        s.YData = y;    % replace surface y values
        s.ZData = z;    % replace surface z values

        drawnow;
        pause(0.03);    % pause to control animation speed
        if ~ishghandle(h_fig)   % Quit if user closes the figure window
            return;
        end
    end
end