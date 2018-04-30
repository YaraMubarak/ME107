%% Effect of Mass on X and Y using data from 04/12.
clear all;
load configurations_04_12_trimmed_v_and_a;
configs=configurations_04_12_trimmed_v_and_a;
values=[configs.m];
sorted_values=sort(unique(values));

%% Effect of Rg on X and Y using data from 04/12.

clear all;
load configurations_04_12_trimmed_v_and_a;
configs=configurations_04_12_trimmed_v_and_a;
values=[configs.r];
sorted_values=sort(unique(values));

%% Effect of H on X and Y using data from 04/12.

clear all;
load configurations_04_12_trimmed_v_and_a;
configs=configurations_04_12_trimmed_v_and_a;
values=[configs.h];
for m=1:length(values)
    values(m)=convertHeightSR(values(m));
end

sorted_values=sort(unique(values));


%% Plotting
close all;
type='Mass '; % Change this.
ylabelText=' Mass (g)'; % Changes this.

saveFig=false;
baseText=['Effect of ' type ' on '];

colors={'r','b','m','c','k'};

        figure(1);
        hold on;
        for m=1:length(configs)
            terr=configs(m).terr{1};
            t=configs(m).t{1};
            val=values(m)*ones(size(configs(m).t{1}));
            x=configs(m).x{1};
            ind=find(sorted_values==values(m));
            inBetweenT=[t-terr, fliplr(t+terr)];
            inBetweenX=[x, fliplr(x)];
            inBetweenMass=[val, fliplr(val)];
            fill3(inBetweenT,inBetweenMass,inBetweenX,colors{mod(ind(1),length(colors))+1},'Linestyle','none');
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
            terr=configs(m).terr{1};
            t=configs(m).t{1};
            val=values(m)*ones(size(configs(m).t{1}));
            y=configs(m).y{1};
            ind=find(sorted_values==values(m));
            inBetweenT=[t-terr, fliplr(t+terr)];
            inBetweenY=[y, fliplr(y)];
            inBetweenMass=[val, fliplr(val)];
            fill3(inBetweenT,inBetweenMass,inBetweenY,colors{mod(ind(1),length(colors))+1},'Linestyle','none');
            xlabel('Time (s)');
            ylabel(ylabelText);
            zlabel('Y position (cm)');
            title([baseText ' Y Position']);
            set(gca,'FontSize',14);
            grid on;
        end
        
        figure(3);
        hold on;
        for m=1:length(configs)
            terr=configs(m).terr{1};
            t=configs(m).t{1};
            val=values(m)*ones(size(configs(m).t{1}));
            vx=configs(m).vx{1};
            vx_err=configs(m).vx_err{1};
            vx_err=vx_err.*(vx_err<=50);
            ind=find(sorted_values==values(m));
            inBetweenT=[t-terr, fliplr(t+terr)];
            inBetweenVx=[vx-vx_err, fliplr(vx+vx_err)];
            inBetweenMass=[val, fliplr(val)];
            fill3(inBetweenT,inBetweenMass,inBetweenVx,colors{mod(ind(1),length(colors))+1},'Linestyle','none');
            xlabel('Time (s)');
            ylabel(ylabelText);
            zlabel('X Velocity (cm/s)');
            title([baseText ' X Velocity']);
            set(gca,'FontSize',14);
            grid on;
        end
        
        figure(4);
        hold on;
        for m=1:length(configs)
            terr=configs(m).terr{1};
            t=configs(m).t{1};
            val=values(m)*ones(size(configs(m).t{1}));
            vy=configs(m).vy{1};
            vy_err=configs(m).vy_err{1};
            vy_err=vy_err.*(vy_err<=50);
            ind=find(sorted_values==values(m));
            inBetweenT=[t-terr, fliplr(t+terr)];
            inBetweenVy=[vy-vy_err, fliplr(vy+vy_err)];
            inBetweenMass=[val, fliplr(val)];
            fill3(inBetweenT,inBetweenMass,inBetweenVy,colors{mod(ind(1),length(colors))+1},'Linestyle','none');
            xlabel('Time (s)');
            ylabel(ylabelText);
            zlabel('Y Velocity (cm/s)');
            title([baseText ' Y Velocity']);
            set(gca,'FontSize',14);
            grid on;
        end
        
        figure(5);
        hold on;
        for m=1:length(configs)
            terr=configs(m).terr{1};
            t=configs(m).t{1};
            val=values(m)*ones(size(configs(m).t{1}));
            ax=configs(m).ax{1};
            ax_err=configs(m).ax_err{1};
            ax_err=ax_err.*(ax_err<=50);
            ind=find(sorted_values==values(m));
            inBetweenT=[t-terr, fliplr(t+terr)];
            inBetweenAx=[ax-ax_err, fliplr(ax+ax_err)];
            inBetweenMass=[val, fliplr(val)];
            fill3(inBetweenT,inBetweenMass,inBetweenAx,colors{mod(ind(1),length(colors))+1},'Linestyle','none');
            xlabel('Time (s)');
            ylabel(ylabelText);
            zlabel('X Acceleration (cm/s^2)');
            title([baseText ' X Acceleration']);
            set(gca,'FontSize',14);
            grid on;
        end
        
        figure(6);
        hold on;
        for m=1:length(configs)
            terr=configs(m).terr{1};
            t=configs(m).t{1};
            val=values(m)*ones(size(configs(m).t{1}));
            ay=configs(m).ay{1};
            ay_err=configs(m).ay_err{1};
            ay_err=ay_err.*(ay_err<=50);
            ind=find(sorted_values==values(m));
            inBetweenT=[t-terr, fliplr(t+terr)];
            inBetweenAy=[ay-ay_err, fliplr(ay+ay_err)];
            inBetweenMass=[val, fliplr(val)];
            fill3(inBetweenT,inBetweenMass,inBetweenAy,colors{mod(ind(1),length(colors))+1},'Linestyle','none');
            xlabel('Time (s)');
            ylabel(ylabelText);
            zlabel('Y Acceleration (cm/s^2)');
            title([baseText ' Y Acceleration']);
            set(gca,'FontSize',14);
            grid on;
        end