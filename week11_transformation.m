% Set up axes
axis equal;
axis([-2 2 -2 2   -2 2]);
view(3);
% Draw a cone and get a handle for its surface mesh
[x,y,z] = cylinder([0 0.7]);
s = surface(x, y, z, 'FaceColor', 'cyan');
% Create an hgtransform to transform the cone 
shading interp;
t = hgtransform;
set(s, 'Parent', t);
M = eye(4);   
% Start with 4x4 identity matrix
for i = 1:50
    M = M * makehgtform('xrotate', pi/40);
    % Rotate about y
    set(t, 'Matrix', M);   
    % Update transformation matrix
    pause(.1);     
end