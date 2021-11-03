[X1,   Y1,  Z1] = cylinder([0.1 0]); % Cylinder
[X2,   Y2,  Z2] = cylinder([0.2 0.2]); % Cylinder

h(1) = surface(X1, Y1, Z1)
h(2) = surface(X2, Y2, Z2)
...
t = hgtransform;
set(h, 'Parent', t);  % Apply transform to all surfaces in vector 'h'...
M = eye(4);
%order matters and coressponds to yaw.
M = M * makehgtform('translate', [transX transY transZ]);
M = M * makehgtform('zrotate', rot);  % Rotation angle in radians
set(t, 'Matrix', M);   % Update transformation matr