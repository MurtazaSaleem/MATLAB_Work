% life.m - Conway's Game of Life
%
% From http://exolete.com/life/ (Iain Haslam)

clear;
rng(2);   % Seed, change this (or remove) for different initial conditions
h_fig = figure;
len=50;
GRID=int8(rand(len,len)-.4);
up=[2:len 1];
down=[len 1:len-1];

for i=1:100000
    neighbours=GRID(up,:)+GRID(down,:)+GRID(:,up)+GRID(:,down)+...
        GRID(up,up)+GRID(up,down)+GRID(down,up)+GRID(down,down);
    GRID = neighbours==3 | GRID & neighbours==2;
    image(GRID*2,'CDataMapping','scaled');
    
    pause(0.5);
    if ~ishghandle(h_fig)   % Quit if user closes the figure window
        break;
    end
end