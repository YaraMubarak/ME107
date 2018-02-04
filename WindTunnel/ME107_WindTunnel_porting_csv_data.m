clear all; close all;
% Path name stuff
%root = 'C:\Users\pcarl\Documents\College Things\ME 107\Wind Tunnel';
filenameprop = 'WindspeedCalibrationProper.xlsx';
%fullpathprop = strcat(root,filenameprop);
FullData = xlsread(filenameprop,'A23:H259');


% Extract data into meaningful columns
Time = FullData(:,1);
AnemometerVelocity = FullData(:,2); % m/s
AnemomenterStandardDeviation = FullData(:,3);
FanSpeed = FullData(:,4); % RPM
FanSpeedStandardDeviation = FullData(:,5);
PressureTransducerVoltage = FullData(:,6); % V
PressureTransducerStandardDeviation = FullData(:,7);
MotorRPMSetpoint = FullData(:,8); %RPM

% Remove zero offset from presure transducer + edit out negative values
TransducerZeroOffset = mean(PressureTransducerVoltage(MotorRPMSetpoint == 0));
PressureTransducerVoltage = PressureTransducerVoltage - TransducerZeroOffset;
PressureTransducerVoltage = PressureTransducerVoltage.*(PressureTransducerVoltage >= 0);


% do non linear regression
SqrtPressureTransducerVoltage = sqrt(PressureTransducerVoltage);
PressureTransducerRegressionCoefs = polyfit(SqrtPressureTransducerVoltage,AnemometerVelocity,1);
VelocityRegression = @(PresVolt) polyval(PressureTransducerRegressionCoefs,sqrt(PresVolt));

%Get error 
std_from_fit = (1/length(PressureTransducerVoltage)).*sum(AnemometerVelocity - VelocityRegression(PressureTransducerVoltage)).^2;


% Plot Transducer to Velocity Regression
EquationString = sprintf('v = %.3f * sqrt(V) + %.3f',PressureTransducerRegressionCoefs);
ErrorString = sprintf('+/- %d  (95%%)', 2*std_from_fit) ;
figure()
hold on
plot(PressureTransducerVoltage,AnemometerVelocity,'b.')
plot(PressureTransducerVoltage,VelocityRegression(PressureTransducerVoltage),'k--','LineWidth',2)
text(.75,15,EquationString)
text(.85,13,ErrorString) 
xlabel('Pressure Transducer Voltage - zero offset [V]')
ylabel('Anemometer Velocity [m/s]')
legend('Data Points','Regression values','Location','NorthWest')



 