% Simple lighting and shading examples, Georg Feil, Sheridan College, 2018.
% Written for INFO48874.
clear;
clc;
msg = " (press any key to continue)\n\n";

% Draw a sphere, automatically generates polygon mesh and draws using 'surf'
sphere(500);

axis equal;          % Set equal axis scaling for consistent aspect ratio

fprintf("Lighting/shading not enabled" + msg);
pause

l = light;           % Add a light
set(l, 'Color', [.8 .8 .2], 'Position', [1 1 9]);  % Set light color (yellowish) and position

fprintf("One light source created, lighting/shading at default settings (flat shading with grid lines)" + msg);
pause

lighting gouraud;    % Change from flat to Gouraud shading, 'gouraud' preferred for curved surfaces

fprintf("Changed to Gouraud shading" + msg);
pause

shading flat;       % Controls colour blending (faceted, flat or interp)

fprintf("Removed grid lines using 'shading flat' -- shading is still Gouraud!" + msg);
pause

shading interp;

fprintf("Now interpolating colours across faces with 'shading interp'" + msg);
pause

material metal;   % Set material properties

fprintf("Made material very shiny (increased alpha value)" + msg);
pause

set(l, 'Position', [1 -5 0.5]);
material default;

fprintf("Moved the light, made material less shiny" + msg);
pause

set(l, 'Color', [0.9 .3 .3]);

fprintf("Changed light colour to reddish" + msg);


