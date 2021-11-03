% Draw a unit cube with one corner at the origin using 6 square polygons.
% Written by Georg Feil for INFO48874, Sheridan College.
axis equal;
view(3)
axis([-2 2 -2 2 -2 2]);
grid

X = [0 1 1 0];
Y = [0 0 1 1];
Z = [0 0 0 0];
patch(X,Y,Z,'red');

X = [0 1 1 0];
Y = [0 0 1 1];
Z = [1 1 1 1];
patch(X,Y,Z,'green');

X = [0 1 1 0];
Y = [0 0 0 0];
Z = [0 0 1 1];
patch(X,Y,Z,'yellow');

X = [1 1 1 1];
Y = [0 1 1 0];
Z = [0 0 1 1];
patch(X,Y,Z,'cyan');

X = [1 0 0 1];
Y = [1 1 1 1];
Z = [0 0 1 1];
patch(X,Y,Z,'white');

X = [0 0 0 0];
Y = [0 0 1 1];
Z = [0 1 1 0];
patch(X,Y,Z,'blue');



l = light('flat');           % Add a light
set(l, 'Color', [.8 .8 .2], 'Position', [0.5 0.5 4]);  % Set light color (yellowish) and position
 