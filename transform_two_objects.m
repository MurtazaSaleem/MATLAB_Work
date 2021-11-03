% Demo script showing how to draw two polygon-based objects, each with
% their own transformation (translation, rotation).
% Written by Georg Feil for INFO48874, Sheridan College.
clear;
main();

function main
    ang1 = 0;       % Rotation angle of the large cube in radians
    tr1 = 1;        % x translation of the large cube
    ang2 = 0;       % Rotation angle of the small cube in radians

    % Create figure window with keyboard callback
    h_fig = figure('Name', 'Transform Two Objects');
    set(h_fig,'KeyPressFcn',@keypress_callback);

    % Set up dark colour scheme
    gray = [0.6 0.6 0.6];
    dark = [0.1 0.1 0.1];
    set(h_fig, 'Color', dark);
    set(h_fig,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{gray, gray, gray})
    h_ax = axes;
    set(h_ax, 'Color', dark);
    set(h_ax, 'Clipping', 'off');
    axis equal;
    axis([-2 2 -2 2 -2 2]);
    
    view(-15, 9);   % Set viewpoint azimuth and elevation
    camproj('perspective');  % Use perspective projection, looks a bit more realistic

    % Label the x, y, z axes
    xlabel('x', 'Color', [1.0 0 0]);   % red
    ylabel('y', 'Color', [0 0.7 0]);   % green
    zlabel('z', 'Color', [0 0.5 1]);   % blue
    title("\color{gray}Keys: l, s, t, r");

    % Define a transform per object and create the objects
    t1 = hgtransform;      % Transform to use for the first (large) cube
    p1 = drawWireCube(1, 'white');
    set(p1, 'Parent', t1); 
    
    t2 = hgtransform;      % Transform to use for the second (small) cube
    p2 = drawWireCube(0.25, [.2 .8 .2]);
    set(p2, 'Parent', t2); 

    % Continuously update the transformations to animate the objects
    while true
        M = eye(4);

        % Transform the large cube
        M = M * makehgtform('yrotate', ang1);
        M = M * makehgtform('translate', [tr1 0 0]);
        set(t1, 'Matrix', M);
        
        % Transform the small cube relative to the large cube
        M = M * makehgtform('yrotate', ang2);
        set(t2, 'Matrix', M);

        pause(0.02);     
    end

    
    % Draw a wire cube centered at the origin using 6 square polygons (bottom, top, sides).
    % To make it wire frame we set alpha (opacity) of all faces to zero.
    % 'size' is the size of the cube, i.e. length of each edge.
    % 'edgecolor' is the colour to use to draw the edges of the cube.
    % Returns a vector of all patches (polygons) used in the cube, for use with hgtransform.
    function p = drawWireCube(size, edgeColor)
        X = [-.5  .5  .5 -.5] * size;
        Y = [-.5 -.5  .5  .5] * size;
        Z = [-.5 -.5 -.5 -.5] * size;
        p(1) = patch(X,Y,Z,'black', 'EdgeColor', edgeColor, 'FaceAlpha',0);

        X = [-.5  .5  .5 -.5] * size;
        Y = [-.5 -.5  .5  .5] * size;
        Z = [ .5  .5  .5  .5] * size;
        p(2) = patch(X,Y,Z,'black', 'EdgeColor', edgeColor, 'FaceAlpha',0);

        X = [-.5  .5  .5 -.5] * size;
        Y = [-.5 -.5 -.5 -.5] * size;
        Z = [-.5 -.5  .5  .5] * size;
        p(3) = patch(X,Y,Z,'black', 'EdgeColor', edgeColor, 'FaceAlpha',0);

        X = [ .5  .5  .5  .5] * size;
        Y = [-.5  .5  .5 -.5] * size;
        Z = [-.5 -.5  .5  .5] * size;
        p(4) = patch(X,Y,Z,'black', 'EdgeColor', edgeColor, 'FaceAlpha',0);

        X = [ .5 -.5 -.5  .5] * size;
        Y = [ .5  .5  .5  .5] * size;
        Z = [-.5 -.5  .5  .5] * size;
        p(5) = patch(X,Y,Z,'black', 'EdgeColor', edgeColor, 'FaceAlpha',0);

        X = [-.5 -.5 -.5 -.5] * size;
        Y = [-.5 -.5  .5  .5] * size;
        Z = [-.5  .5  .5 -.5] * size;
        p(6) = patch(X,Y,Z,'black', 'EdgeColor', edgeColor, 'FaceAlpha',0);
    end

    function keypress_callback(~, event)
        if event.Key == "l"
            ang1 = ang1 + .05;      % Increase large cube rotation angle
        elseif event.Key == "s"
            ang2 = ang2 + .05;      % Increase small cube rotation angle
        elseif event.Key == "t"
            tr1 = tr1 + .05;        % Increase large cube translation
        elseif event.Key == "r"
            tr1 = tr1 - .05;        % Decrease large cube translation
        end
    end

end % End of main

