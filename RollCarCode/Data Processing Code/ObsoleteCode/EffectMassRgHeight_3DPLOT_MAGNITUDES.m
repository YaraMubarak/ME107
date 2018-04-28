%% Effect of Mass on X and Y using data from 04/12.
clear all;
load configurations_04_12_trimmed_v_and_a;
configs=configurations_04_12_trimmed_v_and_a;
values=[configs.m];

%% Effect of Rg on X and Y using data from 04/12.

clear all;
load configurations_04_12_trimmed_v_and_a;
configs=configurations_04_12_trimmed_v_and_a;
values=[configs.r];

%% Effect of H on X and Y using data from 04/12.

clear all;
load configurations_04_12_trimmed_v_and_a;
configs=configurations_04_12_trimmed_v_and_a;
values=[configs.h];

for m=1:length(values)
    values(m)=convertHeightSR(values(m));
end


%% Plotting
close all;
type='r_g'; % Change this.
ylabelText='r_g (mm)'; % Changes this.

saveFig=false;
baseText=['Effect of ' type ' on '];

        figure(1);
        hold on;
        for m=1:length(configs)
            t=configs(m).t{1};
            val=values(m)*ones(size(configs(m).t{1}));
            x=configs(m).x{1};
            plot3(t,val,x);
            xlabel('Time (s)');
            ylabel(ylabelText);
            zlabel('X position (cm)');
            title([baseText ' X Position']);
            set(gca,'FontSize',14);
            grid on;
        end
        
        figure(2);
        hold on;
        for m=1:length(configs)
            t=configs(m).t{1};
            val=values(m)*ones(size(configs(m).t{1}));
            y=configs(m).y{1};
            plot3(t,val,y);
            xlabel('Time (s)');
            ylabel(ylabelText);
            zlabel('Y position (cm)');
            title([baseText ' Y Position']);
            set(gca,'FontSize',14);
            grid on;
        end
        
        figure(3);
        hold on;
        v_err=[];
        for m=1:length(configs)
            t=configs(m).t{1};
            val=values(m)*ones(size(configs(m).t{1}));
            vx=configs(m).vx{1};
            vy=configs(m).vy{1};
            vx_err=configs(m).vx_err{1};
            vy_err=configs(m).vy_err{1};
            v_err=[v_err sqrt(vx_err.^2+vy_err.^2)];
            plot3(t,val,sqrt(vx.^2+vy.^2));
            xlabel('Time (s)');
            ylabel(ylabelText);
            zlabel('Velocity Magnitude (cm/s)');
            title([baseText ' Velocity Magnitude']);
            set(gca,'FontSize',14);
            grid on;
        end
        v_err_mean=mean(v_err);
        
        figure(4);
        hold on;
        for m=1:length(configs)
            terr=configs(m).terr{1};
            t=configs(m).t{1};
            val=values(m)*ones(size(configs(m).t{1}));
            ax=configs(m).ax{1};
            ay=configs(m).ay{1};
            plot3(t,val,sqrt(ax.^2+ay.^2));
            xlabel('Time (s)');
            ylabel(ylabelText);
            zlabel('Acceleration Magnitude (cm/s^2)');
            title([baseText ' Acceleration Magnitude']);
            set(gca,'FontSize',14);
            
            grid on;
        end