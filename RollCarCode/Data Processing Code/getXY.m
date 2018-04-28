function [X,Y,T]=getXY(fileName)
% - fileName is a string that is the name of the .xlsx file that contains the
% data.
% - X is the x position of the roll car.
%       X=0 corresponds to the rightmost position of the right hill (hill
%       where the car was released).
% - Y is the y position of the roll car.
%       Y=0 corresponds to the bottom of the track plastic.
% - T is the time after release.
%
% All length units in cm.
% All time units in s.
%
% NOTE: X,Y, and T are only recorded when the car passes over a sensor
% (e.g. the time when the roll car is passing in between sensors is not
% recorded).  However, if desired, you can interpolate to obtain the values
% of X,Y, and T of the roll car as it passes in between sensors.

rawData=xlsread(fileName,'A24:R20000');
   % R20000 is set arbitrary large so that all the data can be taken.  No
   % need to change R20000 unless for some reason the xlsx file is so large
   % that there are more than 20000 rows.
   
   regular_expression='(\d+_\d+)_rg_(\d+_\d+)_mass_(\d+)_height_run(\d).xlsx';
   
   tokens=regexp(fileName,regular_expression,'tokens');
   str_data=strrep(tokens{1},'_','.');
        
   r=str2num(str_data{1});
   m=str2num(str_data{2});
   h=str2num(str_data{3});
   run=str2num(str_data{4});
   
   % Removes the time before the roll car is released.
   totalTime=rawData(:,1);
   releaseIndices=find(rawData(:,18));
   runTimeIndices=min(releaseIndices):length(totalTime);
   runTime=totalTime(runTimeIndices);
   runTimeData=rawData(runTimeIndices,:);
   
   % Calculates X,Y, and T
   threshold=5.; %V
   counter=2;
   
   T(1)=runTime(1);
   
   switch h
       case 1
%            X(1)=41.0;
%            Y(1)=23.3;
           
           X(1) = 55.0;
           Y(1) = 14.68;
       case 2
%            X(1)=37.6;
%            Y(1)=26.6;
           
           X(1) = 50.0;
           Y(1) = 17.48;
       case 3
%            X(1)=32.7;
%            Y(1)=29.9;
           % Interpolated not measured
           X(1) = 44.76;
           Y(1) = 20.75;
       case 4
%            X(1)=29.0;
%            Y(1)=33.5;
           
           X(1) = 40.8;
           Y(1) = 23.44;
       case 5
%            X(1)=25.0;
%            Y(1)=37.7;
           
           X(1) = 36.6;
           Y(1) = 26.51;
       case 6
%            X(1)=20.2;
%            Y(1)=41.3;
           
           X(1) = 32.2;
           Y(1) = 29.97;
       case 7
%            X(1)=17.7;
%            Y(1)=45.2;
           % interpolated not measured
           X(1) = 29.29;
           Y(1) = 32.40;
       case 8
%            X(1)=13.5;
%            Y(1)=48.7;
           
           X(1) = 24.4;
           Y(1) = 36.72;
       case 9
%            X(1)=9.9;
%            Y(1)=52.8;
           % interpolated not measured
           X(1) = 21.27;
           Y(1) = 39.64;
       case 10
%            X(1)=5.9;
%            Y(1)=55.9;
           
           X(1) = 17.8;
           Y(1) = 43.04;      
    end
   
   for m=1:length(runTime)
       sensorReadings=runTimeData(m,2:end);
       location=find(sensorReadings>threshold); % Sensor # where roll car is detected.
       
       if length(location)>1
            location=min(location); 
            % If for some reason two sensors detect the roll car, take the
            % lowest numbered sensor.  This choice is arbitrary.
       end
       
       if ~isempty(location)
           
       T(counter)=runTime(m);
       
       switch location
           case 1
               X(counter)=67.2;
               Y(counter)=9.1;
           case 2
               X(counter)=109.1;
               Y(counter)=1.1;
           case 3
               X(counter)=151.3;
               Y(counter)=1.1;
           case 4
               X(counter)=194.5;
               Y(counter)=1.1;
           case 5
               X(counter)=238.0;
               Y(counter)=1.1;
           case 6
               X(counter)=281.0;
               Y(counter)=1.1;
           case 7
               X(counter)=324.0;
               Y(counter)=6.0;
           case 8
               X(counter)=366.1;
               Y(counter)=10.0;
           case 9
               X(counter)=408.4;
               Y(counter)=1.0;
           case 10
               X(counter)=451.5;
               Y(counter)=1.0;
           case 11
               X(counter)=495.9;
               Y(counter)=1.0;
           case 12
               X(counter)=538.1;
               Y(counter)=1.0;
           case 13
               X(counter)=581.3;
               Y(counter)=1.0;
           case 14
               X(counter)=624.2;
               Y(counter)=1.0;
           case 15
               X(counter)=666.1;
               Y(counter)=8.2;
           case 16
               X(counter)=698.1;
               Y(counter)=37.0;
       end
       
       counter=counter+1;
       
       end
   end
   
   % Shifts the time so that T=0 corresponds to the time when the roll car
   % is released.
   
   T=T-T(1);
end