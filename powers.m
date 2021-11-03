% Matlab tutorial exercise 2 solution, includes exercise 3(a). 
% Please complete your version of the exercise before looking at this one!
clear;

% Vector containing all 'x' values
X = -10:.1:10;

% Loop through the powers 0 to 9
for i = 0:9
    Y = X.^i;  % This is a vector calculation and we need the dot 
    if i == 0
        h = plot(X,Y);  % Create plot first time
        axis([-10 10 -1000 1000]);  % Set axis ranges, square brackets needed
    else
        h.YData = Y;    % Subsequently update the y-data
    end
    title("y = x^" + i);
    pause(1);  % Wait 1 sec
end