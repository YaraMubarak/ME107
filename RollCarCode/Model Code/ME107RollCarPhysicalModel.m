clear all; close all;
%% file path things!
% implemented owners names = 'Patrick','Colin'
% put in your own and add your name to the list
ComputerOwner = 'Patrick';

ProjectFolder = 'RollCarCode';
DataFolder = strcat('Data',filesep,'2x2x2_test_matrix');
DataCodeFolder = 'Data Processing Code';
switch ComputerOwner
    case 'Patrick'
        GitRepositoryPath = 'C:\Users\pcarl\Documents\College Things\ME 107\Roll Car\Github Code Repository';
    case 'Colin'
        GitRepositoryPath = '';
    otherwise
        error('ME107RollCarPhysicsModel: ComputerOwner name %s not found in Possible options.Please add your options to the list',ComputerOwner) 
end

DataCodeFullPath = strcat(GitRepositoryPath,filesep,ProjectFolder,filesep,DataCodeFolder);
DataFullPath = strcat(GitRepositoryPath,filesep,ProjectFolder,filesep,DataFolder);

addpath(DataFullPath,DataCodeFullPath)
%% Some basic stuff from the beginning
nuair = 1.524e-6; % m^2/s (kinematic viscosity
vnom = 5; % m/s
rnom = .025; % m

Renom = vnom*rnom/nuair; % nominal reynolds number experienced by wheel
%% Make functions for the track
Trackxvals = (1/100)*[5.9,9.9,13.5,17.7,20.2,25,29,32.7,37.6,41,67.2,109.1,151.3,194.5,230.0,281,324,366.1,408.4,451.5,495.9,538.1,581.3,624.2,666.1,698.1];
Trackyvals = (1/100)*[55.9,52.8,48.7,45.2,41.3,37.7,33.5,29.9,26.6,23.3,9.1,1.1,1.1,1.1,1.1,1.1,6,10,1,1,1,1,1,1,8.2,37];
% make polynomial spline
PiecewisePolynomialSpline = spline(Trackxvals([1,10:end]),Trackyvals([1,10:end]));
PiecewisePolynomialSplineDerivative = PiecewisePolynomialSpline;
PiecewisePolynomialSpline2Derivative = PiecewisePolynomialSpline;
% perform matrix multiply derivation of cubic coeficients
PiecewisePolynomialSplineDerivative.coefs = PiecewisePolynomialSpline.coefs*diag([3,2,1],1);
PiecewisePolynomialSpline2Derivative.coefs = PiecewisePolynomialSplineDerivative.coefs*diag([3,2,1],1);
% make simpler ananymous functions
TrackPosition = @(xvals) ppval(PiecewisePolynomialSpline,xvals);
TrackSlope = @(xvals) ppval(PiecewisePolynomialSplineDerivative,xvals);
TrackConcavity = @(xvals) ppval(PiecewisePolynomialSpline2Derivative,xvals);
TrackCurvature = @(xvals) abs(TrackConcavity(xvals))./sqrt(1+TrackSlope(xvals).^2).^3;

integrand = @(x) sqrt(1+TrackSlope(x).^2);
numDeterminers = 100;
determiners = linspace(Trackxvals(1),Trackxvals(end),numDeterminers);
svals = zeros([numDeterminers,1]);
% Change to gauss quadrature for more accuracy and snazzle;
for guava = 2:numDeterminers
    svals(guava) = integral(integrand,determiners(guava-1),determiners(guava));
end
svals = cumsum(svals);

s_to_x = @(s) linterp(svals,determiners,s);
x_to_s = @(x) linterp(determiners,svals,x);

TrackPosition_s = @(s) TrackPosition(s_to_x(s));
TrackSlope_s = @(s) TrackSlope(s_to_x(s));
TrackCurvature_s = @(s) TrackCurvature(s_to_x(s));

% plotting to make sure all is well
interppoints = linspace(Trackxvals(1),Trackxvals(end),2000);

figure()
hold on
plot(Trackxvals,Trackyvals,'go')
plot(interppoints,TrackPosition(interppoints),'r')
title('Track function')
% axis('equal')

figure()
plot(interppoints,TrackSlope(interppoints))
title('Track slope as function of x')

figure()
plot(interppoints,atan(TrackSlope(interppoints)))
title('Track angle of slope')

figure()
plot(interppoints,TrackConcavity(interppoints))
title('Track Second derivative as function of x')

figure()
plot(interppoints,TrackCurvature(interppoints))
title('Track k value as function of x')
%% Make file pipeline in order to efficiently extract data (not implemented)
% configs = getConfigurationData(DataFullPath)
filename = '42_7592_rg_932_3_mass_1_height_run1.xlsx';
FullFilePath = strcat(DataFullPath,filesep,filename);
%% Get Comparison Data
[Xdata,Ydata,Tdata] = getXY(FullFilePath);
Tdata = Tdata; % get XY fails to account for actual release point
Xdata = Xdata/100;
Ydata = Ydata/100;

%% verify the final result with lots of graphs
TimeStep = 2e-3;
%TimeStep = .01;
m = 2.4582; % kg
rw = .1188; % m
rg = .04; % m (uncalculated guestimate)

CD_bounds = [0,3];
CL_bounds = [0,.1];
muk_bounds = [0,.5];
mus_times_bounds = [1,2];
sinit_bounds = [.5,1];
Random_bounds = [CD_bounds;CL_bounds;muk_bounds;mus_times_bounds;sinit_bounds];

TotalStates = 5;
StateVects = ME107RollCarMakeNChildren(TotalStates,Random_bounds);
StateVects = [StateVects;zeros([1,TotalStates])];
tic;
% go through the individual state vectors
for jujube = 1:TotalStates
    IndividualStateVector = StateVects(1:(end-1),jujube);
    OldMSE = StateVects(end,jujube); 
    if OldMSE ~= 0
        continue
    end
    MSE = ME107RollCarGetMSE(IndividualStateVector,Tdata,Xdata,Ydata,TimeStep,m,rw,rg,s_to_x,TrackPosition_s,TrackSlope_s,TrackCurvature_s);
    StateVects(end,jujube) = MSE;
end
fprintf('%d model runs',TotalStates)
toc;
fprintf('\n')
% sort in the fittest models through minimization
MSEColVect = StateVects(end,:);
[~,SortedIndices] = sort(MSEColVect);
disp(StateVects)
StateVects = StateVects(:,SortedIndices)

%% Check the winning configuration
WinVector = StateVects(1:(end-1),1);
WinnerMSE = StateVects(end,1);
fprintf('Winning Vector:\n')
disp(WinVector)
fprintf('Winning Configuration Mean Square Error: %d \n', WinnerMSE)

CD = WinVector(1);
CL = WinVector(2);
muk = WinVector(3);
mus = muk*WinVector(4);
sinit = WinVector(5);

RCDAF = GetRollCarDynamicsFunction(m,rw,rg,mus,muk,CD,CL,TrackPosition_s,TrackSlope_s,TrackCurvature_s);
[tsim,xvectsim] = RungeKutta4(RCDAF,[0,Tdata(end)],[sinit;0;0;0],TimeStep);
ssim = xvectsim(:,1);
% HYSTERISIS!
xsim = [];
for apple = 1:numel(ssim) 
xsim = [xsim; s_to_x(ssim(apple))];
end
% HYSTERISIS !
ysim = [];
for plum = 1:numel(xsim)
    ysim = [ysim; TrackPosition_s(ssim(plum))];
end
xfunction = @(xx) linterp(tsim,xsim,xx);
yfunction = @(xx) linterp(tsim,ysim,xx);

%MeanSquareError = mean(sqrt((xfunction(Tdata)-Xdata).^2 + (yfunction(Tdata)-Ydata).^2));

sdot = xvectsim(:,2);
thetadot = xvectsim(:,4);
KineticEnergy = .5*m*sdot.^2 + .5*m*rg^2*thetadot.^2;
PotentialEnergy = m*9.81*ysim;
TotalEnergy = KineticEnergy + PotentialEnergy;

% plot lots of figures to determine if simulation is physical or not

figure();
hold on;
plot(KineticEnergy,'r');
plot(PotentialEnergy,'g');
plot(TotalEnergy,'b')
title('Plots of Energy vs time for simulation')
legend('KE','PE','TE','Location','Best')

figure();
hold on
plot(Tdata,Xdata,'k-x');
plot(tsim,xsim,'r--');
xlabel('Time (s)');
ylabel('x (m)');
title('x vs t');
legend('Data  X Position','Simulation X Position','Location','best')
set(gca,'FontSize',14);

figure();
hold on
plot(Tdata,Ydata,'k-x');
plot(tsim,ysim,'r--')
xlabel('Time (s)');
ylabel('y (m)');
title('y vs t');
legend('Data Y Position','Simulation Y Position','Location','best')
set(gca,'FontSize',14);

% animation to ensure that results "look" right
pause(1)
% figure()
% for index = 1:numel(tsim)
%     plot(interppoints,TrackPosition(interppoints),'r')
%     hold on
%     plot(xsim(index),ysim(index),'go')
%     hold off
%     pause(.001)
% end
% disp('Graphics are done')







