 % Cashier queue system. Customers arrive as a Poisson process with rate lambda.
% The cashier serves customers one at a time (if any are waiting). The time
% to serve a customer is exponentially distributed with mean mu (hours).
% Written by Georg Feil for INFO48874, Sheridan College.

clear;

% Constants
lambda = 10;  % Customer arrival rate (per hour)
mu = 5/60;    % Mean time for cashier to serve a customer (hours)

% State variables
q = 0;         % Queue length, initially 0
busy = false;  % Cashier busy flag, initially false
rng(2);
aveQ = 0;

%%create Q
Q = [];
item = [];

% Timing variables
time = 0;          % Simulation clock (hours)
max_time = 1;      % Run the simulation for this many simulated hours
t_cust = expon(1/lambda);  % Time next customer will arrive
t_cashier = inf;   % Time cashier will finish serving customer, inf means unknown (no customer)
k = 1;             % Loop counter

% Main simulation loop. Note the simulation won't stop exactly at max_time,
% it will always run a bit longer (until the next event).
while time < max_time
          
    % Save data (simulation outputs) for plotting later
    t(k) = time;
    x(k) = q + busy;
    k = k + 1;
    
    
    if t_cust < t_cashier % New customer arrives
        
        aveQ = aveQ + q*(time - t_cust);
        
        items = getItems();
        
        time = t_cust; % Move clock
        
        if busy
            q = q + 1;    % Cashier is busy, increase queue lengt
        else            
            busy = true;  % Cashier immediately serves customer 
            t_cashier = time + expon(mu);  % time when cashier will finish serving customer 
        end
        
        
        t_cust = time + expon(1/lambda);   % time of next customer arrival
        
    else % Cashier finished serving customer
        
        aveQ = aveQ + q*(time - t_cashier);
        time = t_cashier; % Move clock
        
        if q > 0          % Customer waiting to be served?
            q = q - 1;    % Decrease queue length, cashier stays busy
            t_cashier = time + expon(mu);  % time when cashier will finish serving customer 
        else
            busy = false;    % Not busy
            t_cashier = inf; % No customer
        end
        
    end
    
    
end

% Plot x vs t as a stairstep graph
t(k) = time;  % add last point
x(k) = q + busy; %system state
stairs(t, x);
xlim([0 time]);  % Set x axis limits, y will be auto
xlabel("Time (hours)");
ylabel("Customers in line or being served");

aveQ/time

% Returns a positive random number chosen from an exponential distribution
% with mean value 'mean'.
function e = expon(mean)
    e = -log(rand)*mean;
end

function items = getItems()
    s = 8;
    mean = 20;
    ans = randn * s + mean;
    round(ans);
    items = ans;
end
