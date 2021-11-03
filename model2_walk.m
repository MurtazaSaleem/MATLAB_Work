h = animatedline;
xlabel('steps');
ylabel('distance');
p = 0; % Initial position
total_steps = 100; % How many steps to take
for x = 0:total_steps
    addpoints(h, x, p);
    randNum = randi(2);
    if randNum == 1
    p = p + 1;
    else
    p = p - 1;
    end
    drawnow; %limitrate limits redraws to 20 /second
end