clear;
close all;
main();
function main()
    %Constants and global
    global dif;
    XMAX = 100;
    SPEED = 25;
    TIME_STEP = 0.01; %delta t
    X = (1:XMAX);
    
    %variables
    p=zeros(1,XMAX);
    a=zeros(1,XMAX);
    v=zeros(1,XMAX);
    run = true;
   
    %figure
    h_fig = figure('Name', 'Assignment1-Vectorization');
    set(h_fig, 'KeyPressFcn', @keypress_callback);
    view(-32, 7);   % Set viewpoint azimuth and a low elevation to judge height better
    daspect manual; % Prevent aspect ratio from changing when resizing window
    handle = plot(X,p);
    
    % Label the x, y, z axes
    xlabel('XMAX Range', 'Color', 'r');      % red
    ylabel('P values', 'Color', [0 .6 0]); % dark green
    ylim([-30 30]);
    startTime = datetime;  % For measuring time (this is not the simulation clock)
    tic; %start system clock

    %%main loop
    while run
        toc; %display time elapsed in seconds
        dif = datetime - startTime; %set timer when run begins
        %%Model
        updateModel(); %update model here
        
        if ~ishandle(h_fig)
            run=false;
            break;
        end
        handle.YData = p;  %%Change P value
        pause(TIME_STEP);  %%pause by 0.01
    end


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Functions for model equations
    function updateModel()
        %%Model
        % Compute acceleration
        x = 1:XMAX-1;
        a(x) = (p (x) - p(x+1)) * SPEED;  
        
        % Compute velocities
        x = 1:XMAX;
        v(x) = v(x) + a(x) * TIME_STEP;
        
        % Compute pressures
        x = 2:XMAX-1;
        p(x) = p(x) + (v(x-1) - v(x)) * SPEED * TIME_STEP;
        
        % Apply damping factor to make the waves die down
        p(x) = p(x) * (1 - 20/XMAX*TIME_STEP);

    end

    function makeWave()
        %%Print the time when the wave is initialized using diff
        waveStart = dif;
        disp(waveStart);
        
        %%WAve Initialization to bend the string 
        x = 2:XMAX;
        d = abs(x - XMAX/20);
        %% get the vector whihc matches the condition from our model
        d = d(d<XMAX/20);
        %getting size of d, which is the index to our p value at 2.
        i = 2:size(d,2)+1;
        
        %change index to value
        p(i) = p(i) + cos(d * 10 * pi / XMAX) * 25.0;
    end
    
     
    %%Key Press callback functions
    function keypress_callback(~, event)
        %disp("Key press: " + event.Key);

        if event.Key == "space"
            makeWave();
        elseif event.Key == "c"   % Ctrl-C, also works without ctrl
            fprintf(2, "Stopping simulation\n");
            run = false;
        end
   end

end