function [m,rg] = CalculateMandRg(x)
%x is a cell, with strings denoting the configuration
% % example : 
% x ={'Holy Wheel 1','Holy Wheel 2', 'Plastic', 'Steel Axel'}
% will get the cells, update a mass and an inertia scalar. divide the two
% and then square root to get a radius of gyration and such
% need to find how to get index for a certain string ina cell...
n = length(x);
I = 0; %total inertia
M = 0; %total mass

%mass is coloumn 1, radius of gyration is coloumn 2
%units are meter and kg
C = {{'Steel Connector',.980,0.046862965173238};...
    {'Thick Aluminum',.4138,0.046286801907863};...
    {'Thin Aluminum',.141,0.048595824053809};...
    {'Plastic',.1523,0.047415833858486};...
    {'Aluminum Axel',.0202,0.004758355461456};...
    {'Steel Axel',.0761,0.004576892527193};...
    {'Holy Wheel 1',.2787,0.044962999954604};...
    {'Holy Wheel 2',.2758,0.044962999954604};...
    {'Unholy Wheel 1',.7003,0.042898938931919};...
    {'Unholy Wheel 2',.7018,0.042898938931919};...
    {'Mega Nut',.2882,0.011358101469995}};


for i = 1:n
        for j = 1:length(C)
            if strcmp(C{j,1}{1,1},x{1,i})==1 %to determine the index of the certain piece
                in = j; 
            end
        end
    I = C{in,1}{1,2}.*C{in,1}{1,3}.^2+I;
    M = C{in,1}{1,2}+M;
end
    m = M
    rg = sqrt(I./M)
end