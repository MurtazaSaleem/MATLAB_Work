%% Draw axes for 3D plot.
h = animatedline;
xlabel('x');
ylabel('y');
zlabel('z');
%vec = linespace(-4*pi, 4*pi, 100); %vector of x or y val
[X, Y] = meshgrid(-2:.2:2);

R = sqrt(X.^2 +Y.^2) + eps; %calculate r = sqrt(x*x + y*y) st all mesh vert
%Z=sin(R)./R;
Z=X .* exp(-X.^2 - Y.^2);
surf(X,Y,Z);