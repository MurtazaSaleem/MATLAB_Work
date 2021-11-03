%reading a csv file
f =    fopen('StudentList.txt', 'rt');
if f == -1
    disp("Error opening file");
    return;
end% Read the file one line at a time.% The feof function returns true if the end of file has% been reached. 

fields = textscan(f, '%s %s %f %f', 'Delimiter', ',');

fclose(f);

G  =  cell2mat(fields(4));

%histogram(G,0:0.1:4);
plot(G)