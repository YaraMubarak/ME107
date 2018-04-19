clear all; close all;clc;
%% Things Requiring changeing
% implemented owners names = 'Patrick','Colin','Jay'
% put in your own filepath and add your name to the list
ComputerOwner = 'Patrick';
ConfigPicks = [3,5,7,12,15];

PlotTrackThings = false;
MakeNewStartGuess = true;
TotalStates = 50;

TimeStep = 1e-3; % this fairly critical, if much larger will miss tol and oscilate never reaching no slip cond.

CD_bounds = [0,3];
CRF_bounds = [0,.05];
IDK_bounds = [0,.1];
muk_bounds = [.05,.25];
mus_times_bounds = [1,2];
sinit_bounds = [.1,.6];
DeltaS = .01;
Random_bounds = [CD_bounds;CRF_bounds;IDK_bounds;muk_bounds;mus_times_bounds;sinit_bounds];

StartGuess = [.47;.01;.01;.1;1.5;DeltaS]; % sinit to be changed to Scalc
%% file path things!
ProjectFolder = 'RollCarCode';
DataFolder = strcat('Data',filesep,'2x2x2_test_matrix');
DataCodeFolder = 'Data Processing Code';
SaveFolder = 'Saved Labels';
switch ComputerOwner
    case 'Patrick'
        GitRepositoryPath = 'C:\Users\pcarl\Documents\College Things\ME 107\Roll Car\Github Code Repository';
    case 'Colin'
        GitRepositoryPath = '/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107';
    case 'Jay'
        GitRepositoryPath = 'C:\Users\Jay\Documents\ME107';
    otherwise
        error('ME107RollCarPhysicsModel: ComputerOwner name %s not found in Possible options.Please add your options to the list',ComputerOwner) 
end

DataCodeFullPath = strcat(GitRepositoryPath,filesep,ProjectFolder,filesep,DataCodeFolder);
DataFullPath = strcat(GitRepositoryPath,filesep,ProjectFolder,filesep,DataFolder);

addpath(DataFullPath,DataCodeFullPath)
%% Make functions for the track
% I put phantom x and y values at end to make ramp taller to accept more
% runs without breaking
Trackxvals = (1/100)*[5.9,9.9,13.5,17.7,20.2,25,29,32.7,37.6,41,67.2,109.1,151.3,194.5,230.0,281,324,366.1,408.4,451.5,495.9,538.1,581.3,624.2,666.1,698.1,745];
Trackyvals = (1/100)*[55.9,52.8,48.7,45.2,41.3,37.7,33.5,29.9,26.6,23.3,9.1,1.1,1.1,1.1,1.1,1.1,6,10,1,1,1,1,1,1,8.2,37,100];
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

s_to_x = @(s) interp1(svals,determiners,s,'pchip');
x_to_s = @(x) interp1(determiners,svals,x,'pchip');

TrackPosition_s = @(s) TrackPosition(s_to_x(s));
TrackSlope_s = @(s) TrackSlope(s_to_x(s));
TrackConcavity_s = @(s) TrackConcavity(s_to_x(s));
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

%% Get Comparison Data
load configurations_04_12_untrimmed;
for ConfigPick = ConfigPicks
    fprintf('Begining Configuration number: %i \n',ConfigPick)
    config = averagedConfigurations_04_12(ConfigPick);
    Xdata = config.x{1}/100;
    Ydata = config.y{1}/100;
    Tdata = config.t{1};
    m = config.m/1000;
    rg = config.r/1000;
    rw = .11882; % from solid works model
    Passes = config.passes;
    DropHeight = config.h;

    switch DropHeight
        case 1
            SinitCalc = x_to_s(.55);
        case 2
            SinitCalc = x_to_s(.50);
        case 4
            SinitCalc = x_to_s(.408);
        case 5
            SinitCalc = x_to_s(.366);
        case 6
            SinitCalc = x_to_s(.322);
        case 8
            SinitCalc = x_to_s(.244);
        case 10
            SinitCalc = x_to_s(.178);
        otherwise
            error('Drop Height %d Not in list of options. calculate the offset',DropHeight)
    end

    Random_bounds(6,:) = [SinitCalc-DeltaS,SinitCalc+DeltaS];
    %% Random sweep to get starting vector
    if MakeNewStartGuess
        StateVects = ME107RollCarMakeNChildren(TotalStates,Random_bounds);
        StateVects = [StateVects;zeros([1,TotalStates])];

        tic;
        % go through the individual state vectors
        ModelRuns = TotalStates;
        for jujube = 1:TotalStates
            IndividualStateVector = StateVects(1:(end-1),jujube);
            OldMSE = StateVects(end,jujube); 
            MSE = ME107RollCarGetMSE(IndividualStateVector,Tdata,Xdata,Ydata,TimeStep,m,rw,rg,s_to_x,TrackPosition_s,TrackSlope_s,TrackConcavity_s,TrackCurvature_s,Passes);
            StateVects(end,jujube) = MSE;
        end
        endtime = toc;
        fprintf('%d model runs elapsed time: %.3f Seconds \n',ModelRuns,endtime)
        fprintf('Average time per run: %.2f Seconds \n',endtime/ModelRuns)
        % sort in the fittest models through minimization
        MSEColVect = StateVects(end,:);
        [~,SortedIndices] = sort(MSEColVect);
        StateVects = StateVects(:,SortedIndices);

        StartGuess = StateVects(1:(end-1),1);
    end


    %% Optimize the crap out of things
    OptFunc = @(vector) ME107RollCarMLOptMSE(vector,Tdata,Xdata,Ydata,TimeStep,m,rw,rg,s_to_x,TrackPosition_s,TrackSlope_s,TrackConcavity_s,TrackCurvature_s,Passes);
    tic;
    [WinVector,resnorm] = lsqnonlin(OptFunc,StartGuess,Random_bounds(:,1),Random_bounds(:,2));
    fprintf('Matlab Optimization')
    toc;

    Survivors = [WinVector;resnorm];


    %% Save the winning Configuration Data
    thingname = sprintf('Survivors_m_%.4f_rg_%.6f_h_%d.mat',m,rg,DropHeight);
    Savepath = strcat(GitRepositoryPath,filesep,ProjectFolder,filesep,SaveFolder,filesep,thingname);
    save(Savepath,'Survivors')
    %% Check the winning configuration
    WinnerMSE = resnorm;
    fprintf('Winning Vector:\n CD:\t %.4f \n CRF:\t %.5f \n IDK:\t %.5f \n muk:\t %.4f \n musF:\t %.4f \n sinit:\t %.4f \n',WinVector)
    fprintf('Winning Configuration Mean Square Error: %.6f \n', WinnerMSE)

    CD = WinVector(1);
    CRF = WinVector(2);
    IDK = WinVector(3)*.5;
    muk = WinVector(4);
    mus = muk*WinVector(5);
    sinit = WinVector(6);

    RCDAF = GetRollCarDynamicsFunction(m,rw,rg,mus,muk,CD,CRF,IDK,TrackPosition_s,TrackSlope_s,TrackConcavity_s,TrackCurvature_s);
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
    xfunction = @(xx) interp1(tsim,xsim,xx,'pchip');
    yfunction = @(xx) interp1(tsim,ysim,xx,'pchip');

    sddot = zeros([numel(ssim),1]);
    thetaddot = zeros([numel(ssim),1]);
    for jackfruit = 1:size(xvectsim,1)
        dotvec = RCDAF(tsim(jackfruit),xvectsim(jackfruit,:)');
        sddot(jackfruit) = dotvec(2);
        thetaddot(jackfruit) = dotvec(4);
    end
    MeanSquareError = mean(sqrt((xfunction(Tdata)-Xdata).^2 + (yfunction(Tdata)-Ydata).^2));
    fprintf('Full Run MSE: %.6f \n',MeanSquareError)

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
    titstr = sprintf('Plots of Energy vs time for simulation for ConfigPick num: %i',ConfigPick);
    title(titstr)
    xlabel('Time [s]')
    ylabel('Energy [joules]')
    legend('KE','PE','TE','Location','Best')

    figure();
    hold on
    plot(Tdata,Xdata,'k-x');
    plot(tsim,xsim,'r--');
    xlabel('Time [s]');
    ylabel('x [m]');
    titstr = sprintf('x vs t Data vs Simulation Config number: %i',ConfigPick);
    title(titstr);
    legend('Data  X Position','Simulation X Position','Location','best')
    set(gca,'FontSize',14);

    figure();
    hold on
    plot(Tdata,Ydata,'k-x');
    plot(tsim,ysim,'r--')
    xlabel('Time [s]');
    ylabel('y [m]');
    titstr = sprintf('y vs t Data vs Simulation Config number: %i',ConfigPick);
    title(titstr);
    legend('Data Y Position','Simulation Y Position','Location','best')
    set(gca,'FontSize',14);

    figure();
    hold on;
    plot(tsim,sdot,'m');
    plot(tsim,rw*thetadot,'c');
    plot(tsim,sdot-rw*thetadot,'k')
    plot(tsim,KineticEnergy,'r.');
    plot(tsim,PotentialEnergy,'g.');
    plot(tsim,TotalEnergy,'b.')
    plot(tsim,sddot,'r')
    plot(tsim,thetaddot*rw,'b')
    xlabel('Time [s]');
    ylabel('Different Things');
    titstr = sprintf('Config num: %i Lots of stuff graph',ConfigPick);
    title(titstr);
    legend('sdot','thetadot*rw','vp','KE','PE','TE','sddot','thetaddot','Location','best')
    set(gca,'FontSize',14);
end

% % % animation to ensure that results "look" right
% % pause(1)
% % figure()
% % interppoints = linspace(Trackxvals(1),Trackxvals(end),2000);
% % for index = 1:10:numel(tsim)
% %     plot(interppoints,TrackPosition(interppoints),'r')
% %     hold on
% %     plot(xsim(index),ysim(index),'go')
% %     hold off
% %     pause(.001)
% % end
% % disp('Graphics are done')







