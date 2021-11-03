%%Assignment Timer.
%%Structured similar to Lunar lander timer
clear; %remove anything
main(); %start main

function main()
    global dif; %get global variable for datetime
    %Constants
    XMAX = 100;
    SPEED = 25;
    TIME_STEP = 0.01; %delta t
    X = (1:XMAX); %X values are always between 1-XMAX
  
    
    %Variables
    p=zeros(1,XMAX);
    a=zeros(1,XMAX);
    v=zeros(1,XMAX);
    startTime = datetime;  % For measuring time (this is not the simulation clock)

    %Figure
    close all;
    h_fig = figure('Name', 'Assignment1 - Using Timer');
    set(h_fig, 'KeyPressFcn', @keypress_callback);

    %%plot figure
    handle = plot(X,p); %plot
    ylim([-30 30]);
    % Label the x, y axes
    xlabel('XMAX', 'Color', 'r');      % red
    ylabel('p - position', 'Color', [0 .6 0]); % dark green
    
    %%Set timer
    t = timer;
    set(t, 'Period', TIME_STEP, 'ExecutionMode', 'fixedRate', 'BusyMode', 'queue', 'TimerFcn', @timer_callback);
    tic; %start clock
    startTime = datetime;  % For measuring time (this is not the simulation clock)
    start(t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Functions for model equations
    function updateModel()
        %%Model
        %Vectorization has been applied
        % Compute acceleration
        x = 1:XMAX-1; %the range based of the initial model
        a(x) = (p(x) - p(x+1)) * SPEED;  
        
        % Compute velocities
        x = 1:XMAX; %the range based of the initial model
        v(x) = v(x) + a(x) * TIME_STEP;
        
        % Compute pressures
        x = 2:XMAX-1; %the range based of the initial model
        p(x) = p(x) + (v(x-1) - v(x)) * SPEED * TIME_STEP;
        
        % Apply damping factor to make the waves die down
        p(x) = p(x) * (1 - 20/XMAX*TIME_STEP);

        handle.YData = p;  
    end

    function makeWave()
        %%get time when wave hits
        waveStart = dif;
        disp(waveStart);
        
        %%WAve Initialization to bend the string 
        x = 2:XMAX;
        d = abs(x - XMAX/20);
        d = d(d<XMAX/20);
        
        %getting size of d, which is the index to our p value at 2.
        i = 2:size(d,2)+1;
        %change index to value
        p(i) = p(i) + cos(d * 10 * pi / XMAX) * 25.0;
    end
    
    %%Functions for keypress and timer
    function keypress_callback(~, event) 
        %disp("Key press: " + event.Key);

        if event.Key == "space"
            makeWave(); %create Wave
        elseif event.Key == "c"   % Ctrl-C, also works without ctrl
            fprintf(2, "Stopping simulation\n");
            close(h_fig);
        end
    end


    function timer_callback(~,~)
        dif = datetime - startTime;
        toc;
        updateModel(); %%Update values of our a,p,v
    end
end