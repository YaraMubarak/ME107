clear all; close all; clc;
ComputerOwner = 'Patrick';
TimeStep = 5e-4;
ConfigPicks = 1:38;
%% The File things
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
load configurations_04_12_untrimmed;
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
%% For each Config pick now get the data
count = 0;
FinalLabelsStruct = struct();
for ConfigPick = ConfigPicks
    config = averagedConfigurations_04_12(ConfigPick);
    m = config.m/1000;
    rg = config.r/1000;
    rg = sqrt(2)*rg;
    DropHeight = config.h;
    
    Tdata = config.t{1};

    thingname = sprintf('Survivors_m_%.4f_rg_%.6f_h_%d.mat',m,rg,DropHeight);
    Loadpath = strcat(GitRepositoryPath,filesep,ProjectFolder,filesep,SaveFolder,filesep,thingname);
    try
        T = load(Loadpath);
    catch
        fprintf('Config # %i has not yet been ran. Skipping that configuration \n',ConfigPick)
        continue
    end
    count = count +1;
    fprintf('Config # %i was ran, adding to structure Count num: %i \n',ConfigPick,count)
    fnames = fieldnames(T);
    Something = T.(fnames{1});
    WinVector = Something(1:6,1);
    
    SquareError = Something(7,1);
    MSE = sqrt(SquareError/numel(Tdata));
    fprintf('Declared MSE: %.6f \n',MSE)
    
    
    CD = WinVector(1);
    CRF = WinVector(2);
    IDK = WinVector(3);
    muk = WinVector(4);
    mus = muk*WinVector(5);
    sinit = WinVector(6);

    %% Determine what calculated drop height was
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
    
    DeltaS = sinit - SinitCalc;
    
    FinalLabelsStruct(count).ConfigNum = ConfigPick;
    FinalLabelsStruct(count).m = m;
    FinalLabelsStruct(count).rg = rg;
    FinalLabelsStruct(count).h = s_to_x(SinitCalc);
    FinalLabelsStruct(count).CD = CD;
    FinalLabelsStruct(count).CRF = CRF;
    FinalLabelsStruct(count).IDK = IDK;
    FinalLabelsStruct(count).Muk = muk;
    FinalLabelsStruct(count).Mus = mus;
    FinalLabelsStruct(count).DeltaS = DeltaS;
    FinalLabelsStruct(count).MSE = MSE;
end
Savename = 'FinalLabelsStruct.mat';
Savepath = strcat(GitRepositoryPath,filesep,ProjectFolder,filesep,SaveFolder,filesep,Savename);
save(Savepath,'FinalLabelsStruct')
%     %% Checking which may or may not occur
%     CD = WinVector(1);
%     CRF = WinVector(2);
%     IDK = WinVector(3);
%     muk = WinVector(4);
%     mus = muk*WinVector(5);
%     sinit = WinVector(6);
% 
%     RCDAF = GetRollCarDynamicsFunction(m,rw,rg,mus,muk,CD,CRF,IDK,TrackPosition_s,TrackSlope_s,TrackConcavity_s,TrackCurvature_s);
%     [tsim,xvectsim] = RungeKutta4(RCDAF,[0,Tdata(end)],[sinit;0;0;0],TimeStep);
%     ssim = xvectsim(:,1);
%     % HYSTERISIS!
%     xsim = zeros([numel(ssim),1]);
%     for apple = 1:numel(ssim) 
%         xsim(apple) = s_to_x(ssim(apple));
%     end
%     % HYSTERISIS !
%     ysim = zeros([numel(ssim),1]);
%     for plum = 1:numel(xsim)
%         ysim(plum) = TrackPosition_s(ssim(plum));
%     end
%     xfunction = @(xx) interp1(tsim,xsim,xx,'pchip');
%     yfunction = @(xx) interp1(tsim,ysim,xx,'pchip');
% 
%     sddot = zeros([numel(ssim),1]);
%     thetaddot = zeros([numel(ssim),1]);
%     for jackfruit = 1:size(xvectsim,1)
%         dotvec = RCDAF(tsim(jackfruit),xvectsim(jackfruit,:)');
%         sddot(jackfruit) = dotvec(2);
%         thetaddot(jackfruit) = dotvec(4);
%     end
%     MeanSquareError = mean(sqrt((xfunction(Tdata)-Xdata).^2 + (yfunction(Tdata)-Ydata).^2));
%     fprintf('Full Run MSE: %.6f \n',MeanSquareError)
% 
%     sdot = xvectsim(:,2);
%     thetadot = xvectsim(:,4);
%     KineticEnergy = .5*m*sdot.^2 + .5*m*rg^2*thetadot.^2;
%     PotentialEnergy = m*9.81*ysim;
%     TotalEnergy = KineticEnergy + PotentialEnergy;









