%%
clear;
clc;
rng(3);   % Random seed, change or remove this for different runs


N =2;
lambda = 4; %parts arrival rate per hour
mu = 0.2; %Mean TIME machine process for macine 1
mu2 = 0.2;  % Mean Time machine process for machine 2


flags = false(1,N);
Q = zeros(1,N);

% Timing variables
time = 0;          % Simulation clock (hours)
max_time = 3;      % Run the simulation for this many simulated hours
t_arrivalOfPart = expon(1/lambda);  % Time next part will arrive for machine 1
t_machine1 = inf; %Time machine 2 finishes part
t_machine2 = inf;
k = 1;             % Loop counter
color = ['r' 'g' 'b' 'k' 'w'];


for c=1:N
    st(c)=stairs(0,0);
    st(c).Color = color(randi(5,1,1));
    xlim([0 max_time]);  % Set x axis limits, y will be auto
    xlabel("Time (hours)");
    ylabel("Parts in line or being served");
    hold;
end



% Main simulation loop. Note the simulation won't stop exactly at max_time,
% it will always run a bit longer (until the next event).
while time < max_time

    % Save data (simulation outputs) and update plot
    
    for c=1: N
        t(k) = time;
        x(k) = Q(N) + flags(N);
        k= k+1;
        st(c).XData=t;
        st(c).YData=x;
    end
    
    times = [t_arrivalOfPart t_machine1 t_machine2];  % Next event times
    [t_min, index] = min(times);
    
    pause((t_min - time));  % Delay for real-time execution with speedup factor
    
    time = t_min;    % Advance simulation clock
    fprintf("%4.1f hrs\t", time);
    
    switch index   % Index tells use which type of event
      case 1
       % Customer arrives
        if flags(1)
            Q(1) = Q(1) + 1;    % Cashier is busy, increase queue length
            disp("Machine 1 is busy so create a q" + Q);
        else            
            flags(1) = true;  % Cashier immediately serves customer 
            t_machine1 = time + expon(mu);  % time when cashier will finish serving customer 
            disp("Customer arrives, cashier was idle so serves customer immediately");
        end
        t_arrivalOfPart = time + expon(1/lambda);   % time of next part arrival  
        
      case 2  %% t_machine1      
        if Q(1) > 0         % Customer waiting to be served?
            Q(1) = Q(1) - 1;    % Decrease queue length, cashier stays busy
            Q(2) = Q(2) + 1;
            disp("Part was sent to machine 2")
            t_machine2 = time + expon(mu2);  % time when cashier will finish serving customer 
            disp("Cashier finishes serving customer, takes next customer, queue length is now " + Q);
        else
            flags(1) = false;
            t_machine1 =inf;
            disp("Cashier finishes serving customer, now idle");
        end
         t_arrivalOfPart = time + expon(1/lambda);   % time of next part arrival  
        
      case 3        
        if Q(2) > 0          % Customer waiting to be served?
            Q(2) = Q(2) - 1;    % Decrease queue length, cashier stays busy
            t_machine2 = time + expon(mu2);  % time when cashier will finish serving customer 
            disp("Cashier finishes serving customer, takes next customer, queue length is now " + Q);
        else
            flags(2) = false;    % Not busy
            t_machine2 = inf;
            disp("Cashier finishes serving customer, now idle");
        end
        
    end  
        
end

% add last point
for c=1:N
    t(c) = time;
    x(c) = Q(N) + flags(N);
    st(c).XData=t;
    st(c).YData=x;
    xlim([0 time]);
end
% Returns a positive random number chosen from an exponential distribution
% with mean value 'mean'.
function e = expon(mean)
    e = -log(rand)*mean;
end
