function [a,b] = Simulation(DataArray,Mu)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    Data = DataArray;
    N = size(Mu,2);
    %%Initial Energy
    TIME_STEP = 1;      % one minute tume step
    run = true;
    EnergyExpenditure = 0;
    
    % Constants
    max_time = Data(1)*60;    % Run the simulation for this many simulated minutes
    time = 0;
    t_r = max_time/N;  % time distributed for each machine
    t_s = t_r/Data(5); % average time of each set
    machines = size(Mu,2);
    mu = t_s*0.30;  % Mean time for resting
    g = Data(2);  % User energy
    h = Data(3);   % Weight
    k = 1;
    
    timeOfExercise = expon(1/t_r);
    timeFinished = timeOfExercise + t_r;
    
    handle = animatedline;
    xlabel("Time (min)");
    ylabel("Energy Level");
    
    % it will always run a bit longer (until the next event).
    while time < max_time

        % Save data (simulation outputs) for plotting later
        a(k) = time;
        b(k) = g;
        k = k + 1;

       if timeOfExercise < timeFinished
            time = timeOfExercise;
            EnergyExpenditure = Mu(machines) * time * h; %Calories spent
            timeFinished = time + mu;
            g = g - EnergyExpenditure;  
        else % Cashier finished serving customer
            time = timeFinished; % Move clock
            machines = machines-1; %end of workout
            time = time +mu; %rest time
            handle.Color = [rand(1) rand(1) rand(1)];

       end
        
       
       addpoints(handle, time, g);
    end



    % Returns a positive random number chosen from an exponential distribution
    % with mean value 'mean'.
    function e = expon(mean)
        e = -log(rand)*mean;
    end
end
