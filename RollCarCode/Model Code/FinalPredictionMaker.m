clear all; close all; clc;
tic;
TimeStep = 5e-4;

m = 1.8987;
DropHeight = 7;
rg = .0417;
rg = sqrt(2)*rg;
rw = .11882; % from solid works model

CD = .71;
CRF = .0033;
IDK = .0025;
muk = .094;
mus = muk*1.25;
DeltaS = .005;
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

% plot lots of figures to determine if simulation is physical or not
figure();
hold on;
plot(tsim,KineticEnergy,'r');
plot(tsim,PotentialEnergy,'g');
plot(tsim,TotalEnergy,'b')
titstr = sprintf('Simulation Energy vs time');
title(titstr)
xlabel('Time [s]')
ylabel('Energy [joules]')
legend('KE','PE','TE','Location','Best')

figure();
hold on
plot(tsim,xsim,'k');
xlabel('Time [s]');
ylabel('x [m]');
titstr = sprintf('Simulation x vs t');
title(titstr);
set(gca,'FontSize',14);

figure();
hold on
plot(tsim,ysim,'k')
xlabel('Time [s]');
ylabel('y [m]');
titstr = sprintf('Simulation y vs t ');
title(titstr);
set(gca,'FontSize',14);

figure();
hold on
plot(tsim,sdot,'k')
xlabel('Time [s]');
ylabel('Speed [m/s]');
titstr = sprintf('Simulation Speed vs t');
title(titstr);
set(gca,'FontSize',14);

figure();
hold on
plot(tsim,sddot,'k')
xlabel('Time [s]');
ylabel('Acceleration [m/s^2]');
titstr = sprintf('Simulation Acceleration vs t');
title(titstr);
set(gca,'FontSize',14);

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
