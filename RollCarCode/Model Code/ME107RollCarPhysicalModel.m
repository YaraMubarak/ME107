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
%% Things Requiring changeing
PlotTrackThings = false;
MakeNewStateVects = false;

TimeStep = 2e-3;

Iterations = 1;
TotalStates = 20;
Survivors = 3;
ChilderenPerCouple = 2;
RemainingRandomOffspring = TotalStates - Survivors - ChilderenPerCouple*(Survivors-1)*Survivors/2;
if RemainingRandomOffspring < 1
    error('To many survivors for Total number of states')
end

CD_bounds = [0,3];
CL_bounds = [0,.1];
muk_bounds = [0,.5];
mus_times_bounds = [1,2];
sinit_bounds = [.4,1];
Random_bounds = [CD_bounds;CL_bounds;muk_bounds;mus_times_bounds;sinit_bounds];

nuair = 1.524e-6; % m^2/s (kinematic viscosity
vnom = 2; % m/s
rnom = .025; % m

Renom = vnom*rnom/nuair; % nominal reynolds number experienced by wheel
%% Make functions for the track
% I put phantom x and y values at end to make ramp taller to accept more
% runs without breaking
Trackxvals = (1/100)*[5.9,9.9,13.5,17.7,20.2,25,29,32.7,37.6,41,67.2,109.1,151.3,194.5,230.0,281,324,366.1,408.4,451.5,495.9,538.1,581.3,624.2,666.1,698.1,715];
Trackyvals = (1/100)*[55.9,52.8,48.7,45.2,41.3,37.7,33.5,29.9,26.6,23.3,9.1,1.1,1.1,1.1,1.1,1.1,6,10,1,1,1,1,1,1,8.2,37,60];
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

if PlotTrackThings
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
end
%% Make file pipeline in order to efficiently extract data (not implemented)
% configs = getConfigurationData(DataFullPath)
filename = '42_7592_rg_932_3_mass_1_height_run1.xlsx';
FullFilePath = strcat(DataFullPath,filesep,filename);
%% Get Comparison Data
[Xdata,Ydata,Tdata] = getXY(FullFilePath);
Xdata = Xdata/100;
Ydata = Ydata/100;

%% verify the final result with lots of graphs
m = .9323; % kg
rw = .1188; % m
rg = .0427592; % m (uncalculated guestimate)

% MakeNewStateVects = false;
if MakeNewStateVects
    StateVects = ME107RollCarMakeNChildren(TotalStates,Random_bounds);
    StateVects = [StateVects;zeros([1,TotalStates])];
end

MSETrackingVect = zeros([Iterations,1]);
for tomatoe = 1:Iterations
    tic;
    % go through the individual state vectors
    ModelRuns = TotalStates;
    for jujube = 1:TotalStates
        IndividualStateVector = StateVects(1:(end-1),jujube);
        OldMSE = StateVects(end,jujube); 
        if OldMSE ~= 0
            ModelRuns = ModelRuns-1;
            continue
        end
        MSE = ME107RollCarGetMSE(IndividualStateVector,Tdata,Xdata,Ydata,TimeStep,m,rw,rg,s_to_x,TrackPosition_s,TrackSlope_s,TrackCurvature_s);
        StateVects(end,jujube) = MSE;
    end
    fprintf('%d model runs ',ModelRuns)
    toc;
    % sort in the fittest models through minimization
    MSEColVect = StateVects(end,:);
    [~,SortedIndices] = sort(MSEColVect);
    StateVects = StateVects(:,SortedIndices);
    ProducedChildren = [];
    for orange = 1:Survivors
        for cherry = 1:(orange-1)
            Parent1 = StateVects(1:(end-1),orange);
            Parent2 = StateVects(1:(end-1),cherry);
            NewChildren = ME107RollCarMakeNChildren(ChilderenPerCouple,[Parent1,Parent2]);
            appender = zeros([1,ChilderenPerCouple]);
            ProducedChildren = [ProducedChildren,[NewChildren;appender]];
         end
    end
    RandomChildren = ME107RollCarMakeNChildren(RemainingRandomOffspring,Random_bounds);
    RandomChildren = [RandomChildren;zeros(1,RemainingRandomOffspring)];
    ProducedChildren = [ProducedChildren,RandomChildren];
    StateVects(:,(Survivors+1):end) = ProducedChildren;
    WinnerMSE = StateVects(end,1);
    fprintf('Completed iteration number: %d out of %d \n',tomatoe,Iterations)
    fprintf('Best Error for this iteration: %.6f \n',WinnerMSE)
    MSETrackingVect(tomatoe) = WinnerMSE;
end

%% Check the winning configuration
WinVector = StateVects(1:(end-1),1);
WinVector = [1.5;.05;.1;1.2;0];
WinnerMSE = StateVects(end,1);
fprintf('Winning Vector:\n CD: %.4f \n CL: %.4f \n muk: %.4f \n mus: %.4f \n sinit: %.4f \n',WinVector)
fprintf('Winning Configuration Mean Square Error: %.6f \n', WinnerMSE)

figure()
plot(MSETrackingVect,'r.')
title('Best Error vs iteration Number')
xlabel('Iteration Number')
ylabel('Mean Square Error')


CD = WinVector(1);
CL = WinVector(2);
muk = WinVector(3);
mus = muk*WinVector(4);
sinit = WinVector(5);

RCDAF = GetRollCarDynamicsFunction(m,rw,rg,mus,muk,CD,CL,TrackPosition_s,TrackSlope_s,TrackCurvature_s);
[tsim,xvectsim] = RungeKutta4(RCDAF,[0,Tdata(end)],[sinit;0;0;0],TimeStep);
ssim = xvectsim(:,1);
% HYSTERISIS!
xsim = zeros([numel(ssim),1]);
for apple = 1:numel(ssim) 
    xsim(apple) = s_to_x(ssim(apple));
end
% HYSTERISIS !
ysim = zeros([numel(ssim),1]);
for plum = 1:numel(xsim)
    ysim(plum) = TrackPosition_s(ssim(plum));
end
xfunction = @(xx) linterp(tsim,xsim,xx);
yfunction = @(xx) linterp(tsim,ysim,xx);

% MeanSquareError = mean(sqrt((xfunction(Tdata)-Xdata).^2 + (yfunction(Tdata)-Ydata).^2));

sdot = xvectsim(:,2);
thetadot = xvectsim(:,4);
KineticEnergy = .5*m*sdot.^2 + .5*m*rg^2*thetadot.^2;
PotentialEnergy = m*9.81*ysim;
TotalEnergy = KineticEnergy + PotentialEnergy;

% plot lots of figures to determine if simulation is physical or not
figure();
hold on;
plot(tsim,KineticEnergy,'r');
plot(tsim,PotentialEnergy,'g');
plot(tsim,TotalEnergy,'b')
title('Plots of Energy vs time for simulation')
xlabel('Time [s]')
ylabel('Energy [joules]')
legend('KE','PE','TE','Location','Best')

figure();
hold on
plot(Tdata,Xdata,'k-x');
plot(tsim,xsim,'r--');
xlabel('Time [s]');
ylabel('x [m]');
title('x vs t Data vs Simulation');
legend('Data  X Position','Simulation X Position','Location','best')
set(gca,'FontSize',14);

figure();
hold on
plot(Tdata,Ydata,'k-x');
plot(tsim,ysim,'r--')
xlabel('Time [s]');
ylabel('y [m]');
title('y vs t Data vs Simulation');
legend('Data Y Position','Simulation Y Position','Location','best')
set(gca,'FontSize',14);

figure();
hold on;
plot(tsim,sdot,'r--');
plot(tsim,rw*thetadot,'g--');
plot(tsim,KineticEnergy,'r');
plot(tsim,PotentialEnergy,'g');
plot(tsim,TotalEnergy,'b')
xlabel('Time [s]');
ylabel('velocity [m/s]');
title('v vs t Simulation');
legend('Simulation Velocity','Location','best')
set(gca,'FontSize',14);

figure();
hold on;
plot(tsim,thetadot,'r--');
xlabel('Time [s]');
ylabel('thetadot [rad/s]');
title('thetadot vs t Simulation');
legend('Simulation thetadot','Location','best')
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







