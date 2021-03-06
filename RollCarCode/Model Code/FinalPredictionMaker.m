%% Do computations.
clear all; close all; clc;

tic;
TimeStep = 5e-4;

% from the day of
% m = 1.8987;
% DropHeight = 7;
% rg = .0417;
% rg = sqrt(2)*rg;
% rw = .11882; % from solid works model
% 
% CD = .67;
% CRF = .0028;
% IDK = .0023;
% muk = .095;
% mus = .12;
% DeltaS = .00365;
% Tend = 25;

m = 1.8987;
DropHeight = 7;
rg = .0417;
rg = sqrt(2)*rg;
rw = .11882; % from solid works model

CD = .67;
CRF = .0028;
IDK = .0023;
muk = .095;
mus = .12;
DeltaS = .00365;
Tend = 25;


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


switch DropHeight
    case 1
        SinitCalc = x_to_s(.55);
    case 2
        SinitCalc = x_to_s(.50);
    case 3
        SinitCalc = x_to_s(.4476); % interpolation not measured
    case 4
        SinitCalc = x_to_s(.408);
    case 5
        SinitCalc = x_to_s(.366);
    case 6
        SinitCalc = x_to_s(.322);
    case 7
        SinitCalc = x_to_s(.2929); % interpolation not measured
    case 8
        SinitCalc = x_to_s(.244);
    case 9
        SinitCalc = x_to_s(.2127); % interpolation not measured
    case 10
        SinitCalc = x_to_s(.178);
    otherwise
        error('Drop Height %d Not in list of options. calculate the offset',DropHeight)
end

sinit = SinitCalc + DeltaS;

RCDAF = GetRollCarDynamicsFunction(m,rw,rg,mus,muk,CD,CRF,IDK,TrackPosition_s,TrackSlope_s,TrackConcavity_s,TrackCurvature_s);
[tsim,xvectsim] = RungeKutta4(RCDAF,[0,Tend],[sinit;0;0;0],TimeStep);
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

sdot = xvectsim(:,2);
thetadot = xvectsim(:,4);
KineticEnergy = .5*m*sdot.^2 + .5*m*rg^2*thetadot.^2;
PotentialEnergy = m*9.81*ysim;
TotalEnergy = KineticEnergy + PotentialEnergy;
save('M_1898_7R_g41_7Height45_2');
%% Plot Results
saveFig=true;
load model_trimmed_v_and_a;
config=model_trimmed_v_and_a;

mass=config.m;
r=config.r;
h=45.2;

Xdata = config.x{1}/100;
Ydata = config.y{1}/100;
Speed_data = sqrt(config.vx{1}.^2+config.vy{1}.^2)/100;
Acceleration_data = sqrt(config.ax{1}.^2+config.ay{1}.^2)/100;
Tdata = config.t{1};
Terror = 0.1*ones(size(Xerror));
Xerror = config.xerr{1}/100;
Yerror = config.yerr{1}/100;
Speed_error = sqrt(config.vx_err{1}.^2+config.vy_err{1}.^2)/100;
Acceleration_error = sqrt(config.ax_err{1}.^2+config.ay_err{1}.^2)/100;

titleBase=['Mass ' num2str(mass) ' g, ' 'R_g ' ...
            num2str(r) ' mm, ' ' Height ' ...
            num2str(h) ' cm'];
load('model_trimmed_v_and_a.mat');

% plot lots of figures to determine if simulation is physical or not
figure(1);
hold on;
plot(tsim,KineticEnergy,'r');
plot(tsim,PotentialEnergy,'g');
plot(tsim,TotalEnergy,'b')
titstr = sprintf(['Simulation Energy for ' titleBase]);
title(titstr)
set(gca,'FontSize',14);
xlabel('Time [s]')
ylabel('Energy [joules]')
legend('KE','PE','TE','Location','Best')

if saveFig
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Model/' ...
        'Energy_M' strrep(num2str(mass),'.','_') 'R_g' ...
            strrep(num2str(r),'.','_') 'Height' ...
            strrep(num2str(h),'.','_')],'jpg');
end

figure(2);
hold on;
errorbar(Tdata,Xdata,Xerror,Xerror,Terror,Terror,'k')
plot(tsim,xsim,'r--');
xlabel('Time [s]');
ylabel('x [m]');
titstr = sprintf(['x vs t for ' titleBase]);
title(titstr);
legend('Data X Position','Simulation X Position','Location','Southeast')
set(gca,'FontSize',14);

if saveFig
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Model/' ...
        'X_M' strrep(num2str(mass),'.','_') 'R_g' ...
            strrep(num2str(r),'.','_') 'Height' ...
            strrep(num2str(h),'.','_')],'jpg');
end

figure(3);
hold on
errorbar(Tdata,Ydata,Yerror,Yerror,Terror,Terror,'k')
plot(tsim,ysim,'r--')
xlabel('Time [s]');
ylabel('y [m]');
titstr = sprintf(['y vs t for ' titleBase]);
title(titstr);
legend('Data Y Position','Simulation Y Position','Location','best')
set(gca,'FontSize',14);

if saveFig
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Model/' ...
        'Y_M' strrep(num2str(mass),'.','_') 'R_g' ...
            strrep(num2str(r),'.','_') 'Height' ...
            strrep(num2str(h),'.','_')],'jpg');
end

figure(4);
hold on
errorbar(Tdata,Speed_data,Speed_error,Speed_error,Terror,Terror,'k');
plot(tsim,abs(sdot),'r--')
xlabel('Time [s]');
ylabel('Speed [m/s]');
titstr = sprintf(['Speed vs t for ' titleBase]);
title(titstr);
legend('Data Speed Data','Simulation Speed','Location','best')
set(gca,'FontSize',14);

if saveFig
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Model/' ...
        'Speed_M' strrep(num2str(mass),'.','_') 'R_g' ...
            strrep(num2str(r),'.','_') 'Height' ...
            strrep(num2str(h),'.','_')],'jpg');
end

figure(5);
hold on
errorbar(Tdata,Acceleration_data,Acceleration_error,Acceleration_error,Terror,Terror,'k');
plot(tsim,abs(sddot),'r--')
xlabel('Time [s]');
ylabel('Acceleration [m/s^2]');
titstr = sprintf(['Acceleration vs t for ' titleBase]);
title(titstr);
legend('Data Acceleration Data','Simulation Acceleration','Location','best')
set(gca,'FontSize',14);

if saveFig
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Model/' ...
        'Acceleration_M' strrep(num2str(mass),'.','_') 'R_g' ...
            strrep(num2str(r),'.','_') 'Height' ...
            strrep(num2str(h),'.','_')],'jpg');
end

% figure();
% hold on;
% plot(tsim,sdot,'m');
% plot(tsim,rw*thetadot,'c');
% plot(tsim,sdot-rw*thetadot,'k')
% plot(tsim,KineticEnergy,'r.');
% plot(tsim,PotentialEnergy,'g.');
% plot(tsim,TotalEnergy,'b.')
% plot(tsim,sddot,'r')
% plot(tsim,thetaddot*rw,'b')
% xlabel('Time [s]');
% ylabel('Different Things');
% titstr = sprintf('Config num: %i Lots of stuff graph',ConfigPick);
% title(titstr);
% legend('sdot','thetadot*rw','vp','KE','PE','TE','sddot','thetaddot','Location','best')
% set(gca,'FontSize',14);

fprintf('Model Prediction ')
toc;
% 
% % % % animation to ensure that results "look" right
% % % pause(10)
% % % figure()
% % % interppoints = linspace(Trackxvals(1),Trackxvals(end),2000);
% % % for index = 1:20:numel(tsim)
% % %     plot(interppoints,TrackPosition(interppoints),'r')
% % %     hold on
% % %     plot(xsim(index),ysim(index),'go')
% % %     hold off
% % %     pause(.001)
% % % end
% % % disp('Graphics are done')
% 
% 
% 
% 
% 
% 
