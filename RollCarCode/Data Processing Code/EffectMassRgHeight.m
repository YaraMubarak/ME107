%% Effect of Mass on X and Y using data from 04/12.
clear all;
load configurations_04_12_trimmed_v_and_a;
configs=configurations_04_12_trimmed_v_and_a;
mass=[configs.m];
sorted_mass=sort(mass);
minMass=min(mass);
maxMass=max(mass);
avMass=sorted_mass(round(length(sorted_mass)/2));

[~,min_ind]=find([configs.m]==minMass);
[~,max_ind]=find([configs.m]==maxMass);
[~,av_ind]=find([configs.m]==avMass);

%% Effect of Rg on X and Y using data from 04/12.

clear all;
load configurations_04_12_trimmed_v_and_a;
configs=configurations_04_12_trimmed_v_and_a;
rg=[configs.r];
sorted_rg=sort(rg);
minRg=min(rg);
maxRg=max(rg);
avRg=sorted_rg(round(length(sorted_rg)/2));

[~,min_ind]=find([configs.r]==minRg);
[~,max_ind]=find([configs.r]==maxRg);
[~,av_ind]=find([configs.r]==avRg);

%% Effect of H on X and Y using data from 04/12.

clear all;
load configurations_04_12_trimmed_v_and_a;
configs=configurations_04_12_trimmed_v_and_a;
h=[configs.h];
sorted_h=sort(h);
minh=min(h);
maxh=max(h);
avh=sorted_h(round(length(sorted_h)/2));

[~,min_ind]=find([configs.h]==minh);
[~,max_ind]=find([configs.h]==maxh);
[~,av_ind]=find([configs.h]==avh);


%% Plotting

close all;

type='h'; % Change this

t=cell(1,3);
x=cell(1,3);
y=cell(1,3);
vx=cell(1,3);
vy=cell(1,3);
ax=cell(1,3);
ay=cell(1,3);
terr=cell(1,3);
xerr=cell(1,3);
yerr=cell(1,3);
axerr=cell(1,3);
ayerr=cell(1,3);

indices=[min_ind(1), av_ind(1), max_ind(1)];

for m=1:3
    t{m}=configs(indices(m)).t{1};
    terr{m}=configs(indices(m)).terr{1};
    x{m}=configs(indices(m)).x{1};
    xerr{m}=configs(indices(m)).xerr{1};
    y{m}=configs(indices(m)).y{1};
    yerr{m}=configs(indices(m)).yerr{1};
    vx{m}=configs(indices(m)).vx{1};
    vxerr{m}=configs(indices(m)).vx_err{1};
    vy{m}=configs(indices(m)).vy{1};
    vyerr{m}=configs(indices(m)).vy_err{1};
    ax{m}=configs(indices(m)).ax{1};
    axerr{m}=configs(indices(m)).ax_err{1};
    ay{m}=configs(indices(m)).ay{1};
    ayerr{m}=configs(indices(m)).ay_err{1};
end

save=true;
baseText=['Effect of ' type ' on '];

        figure(1);
        hold on;
        for m=1:3
        errorbar(t{m},x{m},-xerr{m},xerr{m},-terr{m},terr{m});
        end
        figure(2);
        hold on;
        for m=1:3
        errorbar(t{m},vx{m},-vxerr{m},vxerr{m},-terr{m},terr{m});
        end
        figure(3);
        hold on;
        for m=1:3
        errorbar(t{m},ax{m},-axerr{m},axerr{m},-terr{m},terr{m});
        end
        figure(4);
        hold on;
        for m=1:3
        errorbar(t{m},y{m},-yerr{m},yerr{m},-terr{m},terr{m});
        end
        figure(5);
        hold on;
        for m=1:3
        errorbar(t{m},vy{m},-vyerr{m},vyerr{m},-terr{m},terr{m});
        end
        figure(6);
        hold on;
        for m=1:3
        errorbar(t{m},ay{m},-ayerr{m},ayerr{m},-terr{m},terr{m});
        end
        legendText={['Lowest ' type], ['Closest to average ' type], ['Largest ' type]};
        
        
    
    figure(1);
    titleText=[baseText 'X Position'];
    title(titleText);
    title(titleText);
    xlabel('Time (s)');
    ylabel('X position (cm)');
    legend(legendText,'Location','best');    
    set(gca,'FontSize',14);
    
    if save
    
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Comparison/' ...
        'COMPARISON_X_' type],'jpg');

    end
    
    figure(2);
    titleText=[baseText 'X Velocity'];
    title(titleText);
    xlabel('Time (s)');
    ylabel('v_x (X velocity (cm/s))');
    legend(legendText,'Location','best');    
    set(gca,'FontSize',14);
    
    if save
    
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Comparison/' ...
        'COMPARISON_VX_' type],'jpg');

    end
    
    figure(3);
    titleText=[baseText 'X Acceleration'];
    title(titleText);
    xlabel('Time (s)');
    ylabel('a_x (X acceleration (cm/s^2))');
    legend(legendText,'Location','best');    
    set(gca,'FontSize',14);
    
    if save
    
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Comparison/' ...
        'COMPARISON_AX_' type],'jpg');

    end
    
    figure(4);
    titleText=[baseText ' Y Position'];
    title(titleText);
    xlabel('Time (s)');
    ylabel('Y position (cm)');
    legend(legendText,'Location','best');
    set(gca,'FontSize',14);
    
    if save
    
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Comparison/' ...
        'COMPARISON_Y_' type],'jpg');
        
    end
    
    figure(5);
    titleText=[baseText ' Y Velocity'];
    title(titleText);
    xlabel('Time (s)');
    ylabel('v_y (Y velocity (cm/s))');
    legend(legendText,'Location','best');
    set(gca,'FontSize',14);
    
    if save
    
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Comparison/' ...
        'COMPARISON_VY_' type],'jpg');
        
    end
       
    figure(6);
    titleText=[baseText ' Y Acceleration'];
    title(titleText);
    xlabel('Time (s)');
    ylabel('a_y (Y acceleration (cm/s^2))');
    legend(legendText,'Location','best');
    set(gca,'FontSize',14);
    
    if save
    
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Comparison/' ...
        'COMPARISON_AY_' type],'jpg');
        
    end