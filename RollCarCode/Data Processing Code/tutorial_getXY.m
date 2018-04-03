%% Usage of the getXY function
% This is a sample script demonstrating use of the getXY function.
GlobalPath = 'C:\Users\pcarl\Documents\College Things\ME 107\Roll Car\';
fileName = 'F111_10_run1.xlsx';
filepath = strcat(GlobalPath,fileName);
[Xdata,Ydata,Tdata]=getXY(filepath);
Xdata = Xdata/100;
Ydata = Ydata/100;

m = 1; % kg
rw = .15; % m
rg = .15; % m
mus = .1;
muk = .08;
CD = 0;
CL = 0;

RCDAF = GetRollCarDynamicsFunction(m,rw,rg,mus,muk,CD,CL,TrackPosition_s,TrackSlope_s,TrackCurvature_s);
[tsim,xvectsim] = ode45(RCDAF,[0,25],[.6;0;0;0]);
ssim = xvectsim(:,1);
xsim = [];
for a = 1:numel(ssim)
xsim = [xsim;s_to_x(ssim(a))];
end
ysim = TrackPosition(xsim);

sdot = xvectsim(:,2);
thetadot = xvectsim(:,4);
KineticEnergy = .5*m*sdot.^2 + .5*m*rg^2*thetadot.^2;
PotentialEnergy = m*9.81*TrackPosition_s(ssim)';
TotalEnergy = .5*KineticEnergy + PotentialEnergy;
figure(); hold on; plot(KineticEnergy,'r');plot(PotentialEnergy,'g');plot(TotalEnergy,'b')

figure();
hold on
plot(Tdata,Xdata,'k-x');
plot(tsim,xsim,'r--');
xlabel('Time (s)');
ylabel('x (m)');
title('x vs t');
legend('Dsts  X Position','Simulation X Position','Location','best')
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



pause(1)
figure()
for index = 1:numel(tsim)
    plot(interppoints,TrackPosition(interppoints),'r')
    hold on
    plot(xsim(index),ysim(index),'go')
    hold off
    pause(.001)
end
disp('Graphics are done')











