% Lunar lander simulation.
% Try to land without crashing, and use as little fuel as possible!
% Press space bar to thrust.
% Record fuel left after landing by Adam, age 11: 42.7%
% Written by Georg Feil for INFO48874, Sheridan College.

clear;
main();

function main()
    % Constants, do not change these later in the code
    GRAVITY = -1.622;           % The acceleration due to gravity on the moon in meters per second per second (m/s/s), negative means down
    THRUST_STRENGTH = 5.0;      % The strength of the lander's rocket in meters per second per second (m/s/s)
    INITIAL_HEIGHT = 500;       % The initial height in meters (m). The real Apollo 11 lunar module started powered descent at height 11853 m.
    INITIAL_VEL = 0;            % The initial velocity in m/s. The real Apollo 11 lunar module was moving at 6000 km/h horizontally!
    SAFE_LANDING_SPEED = 5.0;   % The safe landing speed below which we don't crash in meters per second (m/s)
    TIME_STEP = 0.1;            % The size of each step in the simulation, in seconds (s)

    % Initialize variables used by more than one nested function. These will be initialized again if needed.
    height = 0;
    fuel = 0;
    vel = 0;
    time = 0;  % The simulation clock
    run = true;
    spacePressed = false;  % True while space bar is being held down

    % Create figure window with keyboard callbacks, closing any old windows
    close all;
    h_fig = figure('Name', 'Lunar Lander');
    set(h_fig,'KeyPressFcn',@keypress_callback);
    set(h_fig,'KeyReleaseFcn',@keyrelease_callback);

    % Draw surface mesh
    [X,Y] = meshgrid(-8:.15:8,-8:.15:8); 
    Z = peaks(X,Y)*5;
    mesh(X,Y,Z);

    % Create an animated line
    h = animatedline;
    axis([-2 2  -2 2  -35 INITIAL_HEIGHT*1.5]);
    set(h, 'LineWidth', 3);

    % Label the x, y, z axes
    xlabel('x', 'Color', 'r');      % red
    ylabel('y', 'Color', [0 .6 0]); % dark green
    zlabel('z', 'Color', 'b');      % blue

    view(-32, 7);   % Set viewpoint azimuth and a low elevation to judge height better
    daspect manual; % Prevent aspect ratio from changing when resizing window

    startSim();     % Start the simulation
    startTime = datetime;  % For measuring time (this is not the simulation clock)

    % Main loop, continues as long as 'run' is true
    while run
        thrust = 0;
        if spacePressed
            thrust = THRUST_STRENGTH;
        end
        landed = nextStep(thrust);    % Do model calculations
        dif = datetime - startTime;
        fprintf("%.3f s  \t%.3f s  \tHeight: %.2f m  \tVelocity: %.2f m/s   \tFuel: %.1f%%\n", seconds(dif), time, height, vel, fuel);

        addpoints(h, 0, 0, height);

        if landed            % Display results and quit when lander touches down
            if abs(vel) <= SAFE_LANDING_SPEED
                fprintf("\nCongratulations, you landed safely!\n");
            else
                fprintf(2, "\nOuch, you crashed at %g m/s\n", -vel);
            end
            run = false;
        end

        if ~ishghandle(h)   % Quit if user closes the figure window
            run = false;
        end

        drawnow limitrate;
        pause(TIME_STEP);
    end

    function startSim()
        time = 0;
        vel = INITIAL_VEL;
        fuel = 100;
        height = INITIAL_HEIGHT;
    end

    % Calculate the next step in the simulation, where each step represents TIME_STEP seconds.
    % Returns true the moment the lander touches the surface, false otherwise.
    function landed = nextStep(thrust)
        landed = false;
        if height <= 0   % Don't go below the surface (stops simulation after landing)
            return;
        end

        actualThrust = 0;
        if fuel > 0 && thrust > 0 
            actualThrust = thrust;
            fuel = fuel - thrust/7.5;    % Decrease the amount of fuel, engine is thrusting
            if (fuel < 0)
                fuel = 0;         % Make sure fuel amount doesn't go negative
            end
        end

        % Update the lunar lander's velocity and height. Also update the simulation clock (elapsed time).
        vel = vel + (GRAVITY + actualThrust) * TIME_STEP;
        height = height + vel * TIME_STEP;
        time = time + TIME_STEP;

        % Inform caller that the lander has landed when height becomes zero or negative
        if (height <= 0)
            height = 0;        % Make sure height does not go negative
            landed = true;
        end

    end

    function keypress_callback(~, event)
        %disp("Key press: " + event.Key);

        if event.Key == "space"
            spacePressed = true;
        elseif event.Key == "c"   % Ctrl-C, also works without ctrl
            fprintf(2, "Stopping simulation\n");
            run = false;
        end
    end

    function keyrelease_callback(~, event)
        %disp("Key release: " + event.Key);

        if event.Key == "space"
            spacePressed = false;
        end
    end

end  % End of main function 
