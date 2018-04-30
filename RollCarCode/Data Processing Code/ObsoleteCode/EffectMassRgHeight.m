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

values=[minMass,avMass,maxMass];

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
type='mass'; % Change this depending on what you are plotting

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
vxerr=cell(1,3);
vyerr=cell(1,3);
axerr=cell(1,3);
ayerr=cell(1,3);

colors={'r-','b-','p-'};
colors1={'r--','b--','p--'};

indices=[min_ind(1), av_ind(1), max_ind(1)];

for m=[1,2,3]
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

saveFig=false;
baseText=['Effect of ' type ' on '];

        figure(1);
        hold on;
        for m=1:length(configs)
            terr=configs(m).terr{1};
            t=configs(m).t{1};
            mass=configs(m).m*ones(size(configs(m).t{1}));
            x=configs(m).x{1};
            inBetweenT=[t-terr, fliplr(t+terr)];
            inBetweenX=[x, fliplr(x)];
            inBetweenMass=[mass, fliplr(mass)];
            fill3(inBetweenT,inBetweenMass,inBetweenX,rand);
            xlabel('Time');
            ylabel('Mass');
            zlabel('X position');
        end