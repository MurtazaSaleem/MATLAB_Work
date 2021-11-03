%%Muhammad Saleem Assignment 2
clear;

%Imp constants
N =2;
lambda = 3.2; %parts arrival rate per hour
mu = 0.3; %Mean TIME machine process for macine 1
mu2 = 0.4;  % Mean Time machine process for machine 2

%Data variable
flag = [false, false];
Q = zeros(1,N);
p = [0 0]; %for average processed part 
averageQueue = [0 0];
averageProcess = [0 0];
% Timing variables
time = 0;          % Simulation clock (hours)
departure = inf;
max_time = 5;      % Run the simulation for this many simulated hours
arrival = expon(1/lambda); %time next part arrives
t_machine1 = inf;   % Time cashier will finish serving customer, inf means unknown (no customer)
t_machine2 = inf;
k = 1;             % Loop counter

t_machine1Vector = [];
t_machine2Vector = [];
% Initialize empty starstep plot
st = stairs(0, 0);
hold on;
st2 = stairs(0, 0);
xlim([0 max_time]);  % Set x axis limits, y will be auto
xlabel("Time (hours)");
ylabel("Parts in line or being served");

% Main simulation loop. Note the simulation won't stop exactly at max_time,
% it will always run a bit longer (until the next event).
while time < max_time

    % Save data (simulation outputs) and update plot for both stairs
    t(k) = time;
    x(k) = Q(1) + flag(1);
    k = k + 1;
    st.XData=t;
    st.YData=x;    
    x2(k) = Q(2)+flag(2);
    st2.XData = t;
    st2.YData = x2;
    
    
    times = [arrival t_machine1 t_machine2 departure];  % Next event times
    [t_min, index] = min(times);
    
    pause((t_min - time));  % Delay for real-time execution with speedup factor
    
    time = t_min;    % Advance simulation clock
    fprintf("%4.1f hrs\t", time);
    
    switch index   % Index tells use which type of event
      case 1
        % Part arrives to machine one
        if flag(1)
            Q(1) = Q(1) + 1;    % Machine 1 is busy, increase queue length
            disp("Part is waiting in q to go to machine " + Q(1));
        else            
            flag(1) = true;  % Machine 1 is busy now
            disp("Machine 1 is busy now" + Q(1));
            p(1) = p(1)+1;
            t_machine1 = time + expon(mu);  % time when machine 1 part finish processing       
            t_machine1Vector = [t_machine1Vector t_machine1];
        
        end
        arrival = time + expon(1/lambda);
      case 2   
         
          % parts finish at machine one and go to machine 2
        if Q(1) > 0          % Customer waiting to be served?
            Q(1) = Q(1) - 1;    % Decrease queue length, stays busy
            t_machine1 = time + expon(mu);  % time when machine will finish processing 
            t_machine1Vector = [t_machine1Vector t_machine1];
            disp("Machine 1 accepts process part " + Q(1));
        else
            flag(1) =false; %no parts
            t_machine1Vector = [t_machine1Vector t_machine1];
            t_machine1 = inf; % No customer
            p(1) = p(1)+1;
            disp("Machine 1 finishes processed parts " + Q(1));
        end
        t_machine2 = time;
      case 3
         if flag(2)
            t_machine2Vector = [t_machine2Vector time];
            disp("Part is in que for machine 2 " +Q(2))
            Q(2) = Q(2) +1;
            t_machine2 = t_machine1;   % time of next machine arrival is istant
          else
            flag(2) = true;  % Machine 2 is busy now
            disp("Part is accepted by machine 2" + Q(2));  
            p(2) = p(2) +1;
            departure = time + expon(mu2);   % time of machine 2 processing        
            t_machine2Vector = [t_machine2Vector departure];
         end
         
    case 4
        
         % parts finish at machine one and go to machine 2
        if Q(2) > 0          %waiting to be served?
            Q(2) = Q(2) - 1;    % Decrease queue length, cashier stays busy
            disp("Machine 2 accepts process part " + Q(2));
        else
            flag(2) = false; %no parts
            p(2) = p(2) +1;
            departure = t_machine2; % No customer
            t_machine2Vector = [t_machine2Vector departure];
        
            disp("Machine 2 finishes processed parts " + Q(2));
        end   
        
     end
      
end

disp(averageQueue);
hold off;
% add last points
t(k) = time;
x(k) = Q(1) + flag(1);
st.XData=t;
st.YData=x;
x2(k) = Q(2)+flag(2);
st2.XData = t;
st2.YData = x2;
xlim([0 time]);

%%Here is where i compute the vectors however i cant seem to get
%%the correct number of time sequences excluding infinity
%%QUe time finally got it
diffT = x.*(t-time);
diffT2 = x2.*(t-time);
diffT3 = (x+flag(1)).*(t-time);
diffT4 = (x2+flag(2)).*(t-time);
aveQueueMach1 = sum(diffT)/time;
aveQueueMach2 = sum(diffT2)/time;
avePartsMach1 = sum(diffT3)/time;
avePartsMach2 = sum(diffT4)/time;

disp("Average Queue Length- machine 1 " + aveQueueMach1 + " machine 2: " + aveQueueMach2);
disp("Average Parts Processed- machine 1 " + avePartsMach1 + " machine 2: " + avePartsMach2);
% Returns a positive random number chosen from an exponential distribution
% with mean value 'mean'.
function e = expon(mean)
    e = -log(rand)*mean;
end