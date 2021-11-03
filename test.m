% Cashier queue system running at (multiple of) real time. 
% Customers arrive as a Poisson process with rate lambda.
% The cashier serves customers one at a time (if any are waiting). The time
% to serve a customer is exponentially distributed with mean mu (hours).
% Written by Georg Feil for INFO48874, Sheridan College.

clear;
clc;
rng(3);   % Random seed, change or remove this for different runs

% Constants
lambda = 10;  % Customer arrival rate (per hour)
mu = 5/60;    % Mean time for cashier to serve a customer (hours)
speedup = 100;  % Time speedup factor, use 1 for real time

% State variables
q = 0;         % Queue length, initially 0
busy = false;  % Cashier busy flag, initially false

% Timing variables
time = 0;          % Simulation clock (hours)
max_time = 3;      % Run the simulation for this many simulated hours
t_cust = expon(1/lambda);  % Time next customer will arrive
t_cashier = inf;   % Time cashier will finish serving customer, inf means unknown (no customer)
k = 1;             % Loop counter

% Initialize empty starstep plot
st = stairs(0, 0);
xlim([0 max_time]);  % Set x axis limits, y will be auto
xlabel("Time (hours)");
ylabel("Customers in line or being served");

% Main simulation loop. Note the simulation won't stop exactly at max_time,
% it will always run a bit longer (until the next event).
while time < max_time

    % Save data (simulation outputs) and update plot
    t(k) = time;
    x(k) = q + busy;
    k = k + 1;
    st.XData=t;
    st.YData=x;
    
    times = [t_cust t_cashier];  % Next event times
    [t_min, index] = min(times);
    
    pause((t_min - time));  % Delay for real-time execution with speedup factor
    
    time = t_min;    % Advance simulation clock
    fprintf("%4.1f hrs\t", time);
    
    switch index   % Index tells use which type of event
      case 1
        % Customer arrives
        if busy
            q = q + 1;    % Cashier is busy, increase queue length
            disp("Customer arrives, cashier is busy, queue length is now " + q);
        else            
            busy = true;  % Cashier immediately serves customer 
            t_cashier = time + expon(mu);  % time when cashier will finish serving customer 
            disp("Customer arrives, cashier was idle so serves customer immediately");
        end
        
        t_cust = time + expon(1/lambda);   % time of next customer arrival
        
      case 2        
        if q > 0          % Customer waiting to be served?
            q = q - 1;    % Decrease queue length, cashier stays busy
            t_cashier = time + expon(mu);  % time when cashier will finish serving customer 
            disp("Cashier finishes serving customer, takes next customer, queue length is now " + q);
        else
            busy = false;    % Not busy
            t_cashier = inf; % No customer
            disp("Cashier finishes serving customer, now idle");
        end
        
    end
        
end

% add last point
t(k) = time;
x(k) = q + busy;
st.XData=t;
st.YData=x;
xlim([0 time]);

% Returns a positive random number chosen from an exponential distribution
% with mean value 'mean'.
function e = expon(mean)
    e = -log(rand)*mean;
end
