% Matlab 3D wave simulation by Georg Feil.
% This version has been vectorized.
% Based on an OpenGL program by Jakob Thomsen [original (c) 2002].

clear;
main();

function main()

    % Constants -- do not change these values in the code. Try adjusting these to
    % see what happens. Note if DETAIL is big you may need to increase DRAW_SPEED_FACTOR.
    DETAIL = 50;                       % Controls the size of the mesh (DETAIL*2+1 vertices along each axis)
    DRAW_SPEED_FACTOR = 1;             % Factor to reduce the rate of calls to 'drawnow', increase if simulation runs too slow
    TIME_STEP = 0.01;                  % The size of each step in the simulation, in seconds (s)
    TIME_SPEEDUP = min(DETAIL,100)/2;  % Time speedup factor for simulation calculations
    
    fprintf("Press space to drop a stone.\n");
    
    % Create figure window with keyboard callback
    h_fig = figure('Name', 'Wave');
    pos = get(h_fig, 'Position');
    set(h_fig, 'Position', [pos(1)/1.5  pos(2)/5  pos(3)+pos(1)/1.5  pos(4)+(pos(1)/1.5 * 3/4)]);  % Enlarge
    set(h_fig, 'KeyPressFcn', @keypress_callback);

    % Create surface mesh
    XMAX = DETAIL; XMIN = -DETAIL; YMAX = DETAIL; YMIN = -DETAIL;
    xVec = XMIN:1:XMAX;    % Range of x values
    yVec = YMIN:1:YMAX;    % Range of y values
    xLen = length(xVec);
    yLen = length(yVec);
    
    % The following 6 vectors are needed in calc_grid, created once for efficiency
    x1 = mod(1:xLen, xLen) + 1;     % x indices plus 1 with wraparound 
    y1 = mod(1:yLen, yLen) + 1;     % y index plus 1 with wraparound 
    x2 = 2:xLen;
    y2 = 2:yLen;
    x2m1 = x2 - 1;
    y2m1 = y2 - 1;
    
    % Create surface mesh.
    % X, Y, and Z matrices contain coordinates of all mesh vertices. Rows (2nd index)
    % are aligned with the x axis, columns (1st index) with the y axis. 
    % Note this is transposed compared to model matrices 'p' etc.
    [X, Y] = meshgrid(xVec, yVec);  

    % Matrix of Z values controls the height of each mesh vertex, initially zero.
    Z = zeros(yLen, xLen);

    % Draw the mesh. We only call this function once, vertex Z values will
    % be updated later to animate the mesh.
    s = surf(X,Y,Z);

    % Label the x, y, z axes
    xlabel('x', 'Color', 'r');      % red
    ylabel('y', 'Color', [0 .6 0]); % dark green
    zlabel('z', 'Color', 'b');      % blue

    view(-38, 33);       % Set view azimuth and elevation

    axis equal off;      % Set equal axis scaling for consistent aspect ratio
    axis([-DETAIL DETAIL  -DETAIL DETAIL  -DETAIL DETAIL])
    camzoom(1.75);       % zoom into scene a bit
    l = light;           % Add a light
    set(l, 'Color', [.9 .9 .2], 'Position', [1 1 9]);  % Light color (yellowish) and position
    lighting gouraud;    % Use Gouraud shading, preferred for curved surfaces

    % Simulation model variables
    p = zeros(xLen, yLen);  % Wave pressure
    vx = zeros(xLen, yLen); vy = zeros(xLen, yLen);  % Wave velocity in x and y directions
    ax = zeros(xLen, yLen); ay = zeros(xLen, yLen);  % Wave acceleration in x and y directions
    count = 0;      % Main loop iteration count

    % Initialize simulation by "dropping" one stone
    init_grid();
    adjust_grid();

    % Repeat forever
    while true
     
        calc_grid();
        adjust_grid();

        s.ZData = Z;    % Replace mesh vertex z values to animate the mesh

        % If DRAW_SPEED_FACTOR > 1 reduce the rate of calls to 'drawnow' to control animation speed.
        if mod(count, DRAW_SPEED_FACTOR) == 0
            drawnow;
        end
        
        %pause(TIME_STEP);     % pause to control animation speed, use this if simulation runs too fast at DRAW_SPEED_FACTOR 1
        if ~ishghandle(h_fig)  % Quit if user closes the figure window
            return;
        end

        count = count + 1;
    end % End of main loop

    %========================================================================
    % Initialize grid
    %========================================================================
    function init_grid()
        % Create a mesh for vectorizing. 
        % Note: The following 2 lines could be done only once, but we leave
        % them here because this function is not called that often.
        [dx, dy] = meshgrid((1:yLen) - floor(yLen * 3/4), (1:xLen) - floor(xLen * 3/4));
        
        % Use a cosine peak to simulate a stone dropped in the middle of the mesh
        dist = sqrt(dx .* dx + dy .* dy);
        p = p - (dist < 0.1 .* floor(xLen / 2)) .* cos(dist .* 10 .* pi ./ xLen) * 100.0;
        vx = vx / 5.0;
        vy = vy / 5.0;
    end

    %========================================================================
    % Modify the height of each mesh vertex according to the wave pressure
    %========================================================================
    function adjust_grid()
        Z = p' * 0.25;  % Note: 'Z' is transposed compared to the model

        if count > 600
            % Damping factor to make the waves die down, activates after a delay
            p = p .* 0.998;
        end
    end

    %========================================================================
    % Calculate wave propagation
    %========================================================================
    function calc_grid()
        time_step = TIME_STEP * TIME_SPEEDUP;

        % Compute accelerations
        ax = p - p(x1, :);
        ay = p - p(:, y1);

        % Compute speeds
        vx = vx + ax * time_step;
        vy = vy + ay * time_step;

        % Compute pressure
        p(x2, y2) = p(x2, y2) + (vx(x2m1, y2) - vx(x2, y2) + vy(x2, y2m1) - vy(x2, y2)) * time_step;
    end

    function keypress_callback(~, event)
        if event.Key == "space"
            init_grid();
        end
    end

end  % End of main function
