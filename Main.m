clear;
main();

function main()

    %%Create a workout simulator
    %%2020a version
    %%note position is [left bottom width height]


    %%Variables
    TOW = 0; %time of workout
    machines = [];
    Weight = 0; %lbs
    Calories = 0;
    Sets = 0;
    Reps = 0;
    mu = zeros(0,6);
    %Exercise activity mu
    

    %% lets create our figure
    fig = uifigure('Name', 'Gym Simulator');

    %% Create our panel for Main Input features
    p1 = uipanel(fig,'Title','Main Panel','FontSize',12,...
                 'BackgroundColor','white',...
                 'Position',[11 15 160 400],...
                 'AutoResizeChildren','on');
    %% panel for displayign graphs
    p2 = uipanel(fig,'Title','Graph Panel','FontSize',12,...
                 'BackgroundColor','white',...
                 'Position',[175 10 375 300]);
    %% panel for secondary input of machines         
    p3 = uipanel(fig,'Title','Secondary Panel','FontSize',12,...
                 'BackgroundColor','white',...
                 'Position',[175 315 375 100]);


    
    % Create a UI axes for plotting
    ax = uiaxes('Parent',p2,...
                'Units','pixels');   

         
    %% FIRST PANEL FOR INPUTS
    p1.Scrollable = 'on'; %enable scrolling if window size varies
    p1.BorderType = 'line';
    p1.BackgroundColor = [0.3 0.5 0.9];
    % Create a push button on the bottom of our panel
    btn = uibutton(p1,'push',...
                   'Text','Simulate',...
                   'Position',[11, 30, 140, 22],...
                   'ButtonPushedFcn', @(btn,event) plotButtonPushed(btn,ax));
    % Create input fields for variables
    lb1 = uilabel(p1,'Text','Workout Time (0.0)','Position',[11 320 140 22]);
    lb2 = uilabel(p1,'Text','Calorie count (000 Cal)','Position',[11 270 140 22]);
    lb3 = uilabel(p1,'Text','Weight (lbs)','Position',[11 220 140 22]);
    lb4 = uilabel(p1,'Text','Sets','Position',[11 170 140 22]);
    lb5 = uilabel(p1,'Text','Intensity','Position',[11 120 140 22]);
    ef1 = uieditfield(p1,'Text','Position',[11 350 140 22],'Value','Name');
    ef2 = uieditfield(p1,'numeric','Position',[11 300 140 22],'Value',0.0); %time of workout
    ef3 = uieditfield(p1,'numeric','Position',[11 250 140 22],'Value',000); %Initial Energy (Cal)
    ef4 = uieditfield(p1,'numeric','Position',[11 200 140 22],'Value',0.0); %Mass lbs
    dd1 = uidropdown(p1,'Position',[11 150 140 22],'Items',{'1','2','3','4','5'},'ItemsData',[1 2 3 4 5]);
    dd2 = uidropdown(p1,'Position',[11 100 140 22],'Items',{'Low','Medium','High'},'ItemsData',[10 15 20]); %%Low thus reps = 10, Medium thus reps = 15, High thus reps = 20
    cb1 = uicheckbox(p1,'Position',[11 75 140 22],'Text','Novice'); %regular counting
    cb2 = uicheckbox(p1,'Position',[100 75 140 22],'Text','Expert'); %probability of drop set 
    
    
    %% Secondary panel p3 input
    p3.BackgroundColor = [0.5 0.5 0.5];
    % Create checkbox for workouts [175 315 375 100]
    %%cb = repmat(uicheckbox,6,1);
    cb(1) = uicheckbox(p3, 'Text','Treadmill','UserData',[0.12 0.09 0.06],'Position',[20 20 100 15]);
    cb(2) = uicheckbox(p3, 'Text','Abs','UserData',[0.10 0.07 0.04],'Position',[20 50 100 15]);
    cb(3) = uicheckbox(p3, 'Text','Swimming','UserData',[0.08 0.06 0.04],'Position',[120 20 100 15]);
    cb(4) = uicheckbox(p3, 'Text','Upper body','UserData',[0.06 0.05 0.04],'Position',[120 50 100 15]);
    cb(5) = uicheckbox(p3, 'Text','Cycling','UserData',[0.09 0.08 0.06],'Position',[220 20 100 15]);
    cb(6) = uicheckbox(p3, 'Text','Lower body','UserData',[0.06 0.05 0.04],'Position',[220 50 100 15]);
    

    % Create the function for the ButtonPushedFcn callback
    function plotButtonPushed(btn,ax)
             %%Simulation starts here but lets create method of detection
             if (CheckInputs())
                DataArray = [TOW Calories Weight Sets Reps];
                %% Simulation function
                [x,y] = Simulation(DataArray, machines); %%start simulation
                plot(ax,x,y);
             else
                disp('PLease confrim you have entered all inputs');
             end
    end

    %%Value Inputs
    function m1 = CheckInputs()
        %%Check panel 1
        if ef2.Value > 0 || ef3.Value > 0 || ef4.Value > 0 
            TOW = ef2.Value;
            Calories = ef3.Value;
            Weight = ef4.Value;
            Sets = dd1.Value;
            Reps = (dd2.Value);
            m1 = true;
        else
            m1 = false;
        end
        
        if(Reps == 10)
            lvl = 1;
        elseif(Reps == 15)
            lvl= 2;
        else
            lvl= 3;
        end
        
        %%Check for panel 2
        c = 1; %counter
        n=0;
        for i = 1 : 6
            if(cb(i).Value == 0)
                disp(cb(i).Text);
            else
                machines(c) = cb(i).UserData(lvl);
                c = c+1;    
                n = n+1;
            end
            i=i+1;
        end
        if(n==0)
            m1=false;
        end
        
    end

end
