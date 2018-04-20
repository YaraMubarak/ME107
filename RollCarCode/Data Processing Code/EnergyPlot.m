%% Energy Plot
clear all;
load configurations_04_12_trimmed_v_and_a;
configs=configurations_04_12_trimmed_v_and_a;
g=9.81; % m/s^2
E_av=zeros(size(configs));
E0=0; % J
for m=1:length(configs)
    t=configs(m).t{1};
    y=configs(m).y{1};
    vy=configs(m).vy{1};
    vx=configs(m).vx{1};
    v=sqrt(vy.^2+vx.^2);
    
    E0=[E0 configs(m).m/1000*g*y(1)/100]; % in J
    E=configs(m).m/1000*g*y/100+1/2*configs(m).m/1000*(v/100).^2; % in J
    E_av(m)=mean(E);
end

saveFig=true;

close all;
figure(1);
hold on;
mass=[configs.m];
plot(mass,E_av,'kx');
hold on;
plot(mass,E0*ones(size(E_av)),'k-');
xlabel('Mass (g)');
ylabel('Energy (J)');
legend('Average energy of experimental configurations','Idealized physics model',...
    'Location','Best');
title('Energy of Experimental Configurations vs. Ideal Physics Model');
set(gca,'FontSize',14);

if saveFig
saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Model/' ...
        'mass_energy'],'jpg');
end

figure(2);
hold on;
rg=[configs.r];
height=convertHeightSR([configs.h]);
plot(rg,E_av,'kx');
hold on;
plot(rg,E0*ones(size(E_av)),'k-');
xlabel('R_g (mm)');
ylabel('Energy (J)');
legend('Average energy of experimental configurations','Idealized physics model',...
    'Location','Best');
title('Energy of Experimental Configurations vs. Ideal Physics Model');
set(gca,'FontSize',14);

if saveFig
saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Model/' ...
        'rg_energy'],'jpg');
end

figure(3);
hold on;
height=convertHeightSR([configs.h]);
plot(height,E_av,'kx');
hold on;
plot(height,E0*ones(size(E_av)),'k-');
xlabel('Drop Height (cm)');
ylabel('Energy (J)');
legend('Average energy of experimental configurations','Idealized physics model',...
    'Location','Best');
title('Energy of Experimental Configurations vs. Ideal Physics Model');
set(gca,'FontSize',14);

if saveFig
saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Model/' ...
        'h_energy'],'jpg');
end