function [a,b] = Simulation(DataArray,Mu)
    %%Lets create our data from the inputs
    Data = DataArray;
    N = size(Mu,2);
    %%Initial Energy
    TIME_STEP = 1;      % one minute tume step
    EnergyExpenditure = 0;
    % Constants
    max_time = Data(1);    % Run the simulation for this many simulated minutes
    time = 0;
    t_r = max_time/N;  % time distributed for each machine
    t_s = t_r/Data(5); % average time of each set
    machines = size(Mu,2);
    mu = t_s*0.30;  % Mean time for resting
    g = Data(2);  % User energy
    h = Data(3);   % Weight
    a = 0;
    b = g;
    
    handle = animatedline;
    timeOfExercise = 0+t_s;
    timeFinished = timeOfExercise + expon(t_r);
    
    xlabel("Time (min)");
    ylabel("Energy Level");
    
    % it will always run a bit longer (until the next event).
    while time < max_time

        % Save data (simulation outputs) for plotting later

       if timeOfExercise < timeFinished
            if(time <= timeFinished)
                time = timeOfExercise;
                EnergyExpenditure = Mu(machines) * time*60 * h; %Calories spent
                timeFinished = time + t_s;
                g = g - EnergyExpenditure; 
            end 
            timeOfExercise = timeFinished;
       else % Cashier finished serving customer
            if(machines ~= 0)
                EnergyExpenditure = Mu(machines) * time*60 * h; %Calories spent
                timeFinished = time + timeFinished+ t_s;
                g = g - EnergyExpenditure;  
                machines = machines-1; %end of workout for one machine
                time = time +mu; %rest time
                %handle.Color = [rand(1) rand(1) rand(1)];
            else
                disp('Not enough time to finish workout');
            end
       end
 
       a = [a time];
       b = [b g];
       time = time + mu;
       addpoints(handle, time, g);
    end
    
    xlim([0 time]);  % Set x axis limits, y will be auto
    xlabel("Time (hours)");
    ylabel("Energy in Calories");
    % Returns a positive random number chosen from an exponential distribution
    % with mean value 'mean'.
    function e = expon(mean)
        e = -log(rand)*mean;
    end
end

