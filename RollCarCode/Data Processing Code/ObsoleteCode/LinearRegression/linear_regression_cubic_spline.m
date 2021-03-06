%% Load Data

clear all;
close all;
load configurations_04_12_trimmed_v_and_a;
configs=configurations_04_12_trimmed_v_and_a;
mass=[];
rg=[];
height=[];
passes=[];
mass_repeat=[];
rg_repeat=[];
height_repeat=[];
t_end=[];
x_max=[];
x_end=[];
count=0;
for m=1:length(configs)
    for n=1:length(configs(m).passes)
        passes=[passes; configs(m).passes(n)];
        count=count+1;
    end
end

t=[];
t_nondim=[];
x=[];
x_nondim=[];
y=[];
vx=[];
vy=[];
ax=[];
ay=[];

count=1;
for m=1:length(configs)
    for n=1:length(configs(m).passes)
        mass=[mass; configs(m).m];
        rg=[rg; configs(m).r];
        height=[height; convertHeightSR(configs(m).h)];
        t_end=[t_end; configs(m).t{n}(end)];
        x_max=[x_max; max(configs(m).x{n})];
        x_end=[x_end; configs(m).x{n}(end)];
        t=[t configs(m).t{n}];
        t_nondim=[t_nondim configs(m).t{n}/configs(m).t{n}(end)];
        x=[x configs(m).x{n}];
        x_nondim=[x_nondim configs(m).x{n}/max(configs(m).x{n})];
        y=[y configs(m).y{n}];
        vx=[vx configs(m).vx{n}];
        vy=[vy configs(m).vy{n}];
        ax=[ax configs(m).ax{n}];
        ay=[ay configs(m).ay{n}];
        
        mass_repeat=[mass_repeat; configs(m).m*ones(length(configs(m).t{n}),1)];
        rg_repeat=[rg_repeat; configs(m).r*ones(length(configs(m).t{n}),1)];
        height_repeat=[height_repeat; convertHeightSR(configs(m).h)*ones(length(configs(m).t{n}),1)];
        count=count+1;
    end
end

t=t';
t_nondim=t_nondim';
x=x';
x_nondim=x_nondim';
y=y';
vx=vx';
vy=vy';
ax=ax';
ay=ay';

%% Make tables.
T_model_t_end=table(mass,rg,height,t_end);
T_model_x_max=table(mass,rg,height,x_max);
T_model_x_end=table(mass,rg,height,x_end);
T_model_passes=table(mass,rg,height,passes);
T_model_x=table(mass_repeat,rg_repeat,height_repeat,t,x);
T_model_y=table(mass_repeat,rg_repeat,height_repeat,t,y);
T_model_vx=table(mass_repeat,rg_repeat,height_repeat,t,vx);
T_model_vy=table(mass_repeat,rg_repeat,height_repeat,t,vy);
T_model_ax=table(mass_repeat,rg_repeat,height_repeat,t,ax);
T_model_ay=table(mass_repeat,rg_repeat,height_repeat,t,ay);
T_model_t_nondim_x_nondim=table(mass_repeat,rg_repeat,height_repeat,t_nondim,x_nondim);

modeltype='poly2333';

%% Make model: t_end

model_t_end=fitlm(T_model_t_end,'t_end ~ mass*rg^2*height');

%% Make model: x_max

model_x_max=fitlm(T_model_x_max,'x_max ~ mass*rg^2*height');

%% Make model: x_end

model_x_end=fitlm(T_model_x_end,'x_end ~ mass*rg^2*height');

%% Make model: passes.
model_passes=fitlm(T_model_passes,'passes ~ mass*rg^2*height');

%% Find models for x,y

degree=0;
extrema=struct('t',[],'x',[],'y',[],'m',[],'r',[],'h',[]);

count=1;
for m=1:length(configs)
    for n=1:length(configs(m).x)
        
    begin_left_hillx=213.9+129.7+180.7+108.8;
    xData=configs(m).x{n};
    yData=configs(m).y{n};
    tData=configs(m).t{n};
    
    made_it_over_hill=true;
    increasing=true;
    last_index=1;
    index=2;
    passes=0;
    
    extrema_struct.t=tData(1);
    extrema_struct.x=xData(1);
    extrema_struct.y=yData(1);
    
    while made_it_over_hill && index<=length(xData)
        localXMax=68.1+213.9+129.7+180.7+108.8;
        
        if xData(index)<xData(index-1) && increasing
            extrema_struct.t=[extrema_struct.t tData(index)];
            extrema_struct.x=[extrema_struct.x xData(index)];
            extrema_struct.y=[extrema_struct.y yData(index)];
            increasing=false;
            localXMax=xData(index-1);
            if localXMax<begin_left_hillx
                made_it_over_hill=false;
            else
                last_index=index;
                passes=passes+1;
            end
        elseif xData(index)>xData(index-1) && ~increasing
            increasing=true;
            extrema_struct.t=[extrema_struct.t tData(index)];
            extrema_struct.x=[extrema_struct.x xData(index)];
            extrema_struct.y=[extrema_struct.y yData(index)];
            last_index=index;
        end
        
        index=index+1;
    end
    extrema_struct.t=[extrema_struct.t tData(length(tData))];
    extrema_struct.x=[extrema_struct.x xData(length(xData))];
    extrema_struct.y=[extrema_struct.y yData(length(yData))];
    
    
    extrema_struct.m=configs(m).m;
    extrema_struct.r=configs(m).r;
    extrema_struct.h=convertHeightSR(configs(m).h);
    
    extrema(count)=extrema_struct;
    
    count=count+1;
    end
end

mass_repeat_model=cell(1,2*max([configs.passes])+2);
rg_repeat_model=cell(1,2*max([configs.passes])+2);
h_repeat_model=cell(1,2*max([configs.passes])+2);

for m=1:length(extrema)
    for n=1:length(extrema(m).t)
        mass_repeat_model{n}=[mass_repeat_model{n}; extrema(m).m];
        rg_repeat_model{n}=[rg_repeat_model{n}; extrema(m).r];
        h_repeat_model{n}=[h_repeat_model{n}; extrema(m).h];
    end
end


model_extrema=cell(3,2*max([configs.passes])+2);
combinedExtrema=cell(3,2*max([configs.passes])+2);

for m=1:length(extrema)
    for n=1:length(extrema(m).t)
        combinedExtrema{1,n}=[combinedExtrema{1,n}; extrema(m).t(n)];
        combinedExtrema{2,n}=[combinedExtrema{2,n}; extrema(m).x(n)];
        combinedExtrema{3,n}=[combinedExtrema{3,n}; extrema(m).y(n)];
    end
end

for m=1:2*max([configs.passes])+2
    for n=1:3
        tbl=table(mass_repeat_model{m},rg_repeat_model{m},h_repeat_model{m},combinedExtrema{n,m},'VariableNames',{'mass','rg','height','Var4'});%model_extrema{n,m}=fitlm(tbl,'Var4 ~ mass+rg+height+division_num');
        model_extrema{n,m}=fitlm(tbl,'Var4 ~ height*mass*rg:rg');
        disp('');
    end
end

disp('');
%% Validate the model

for configNumber=1:length(configs)

m_sim=configs(configNumber).m; % g
r_sim=configs(configNumber).r; % mm
h_sim=convertHeightSR(configs(configNumber).h); % cm

% Predict total run time

t_end=predict(model_t_end,[m_sim, r_sim, h_sim]);

% Predict num passes

passes=round(predict(model_passes,[m_sim, r_sim, h_sim]));

% Predict coeffs

num_extrema=2*passes+2;

t_test=[];
x_sim=[];
y_sim=[];

for m=1:num_extrema-1
    
    t1=predict(model_extrema{1,m},[m_sim,r_sim,h_sim]);
    t2=predict(model_extrema{1,m+1},[m_sim,r_sim,h_sim]);
    x1=predict(model_extrema{2,m},[m_sim,r_sim,h_sim]);
    x2=predict(model_extrema{2,m+1},[m_sim,r_sim,h_sim]);
    y1=predict(model_extrema{3,m},[m_sim,r_sim,h_sim]);
    y2=predict(model_extrema{3,m+1},[m_sim,r_sim,h_sim]);
    
    t_temp=linspace(t1,t2,100);
    x_temp=spline([t1,t2],[0,x1,x2,0],t_temp);
    y_temp=spline([t1,t2],[0,y1,y2,0],t_temp);
    
    t_test=[t_test(1:end-1) t_temp];
    x_sim=[x_sim(1:end-1) x_temp];
    y_sim=[y_sim(1:end-1) y_temp];
    disp('');
end


t_v=t_test(1:end-1);
vx_sim=diff(x_sim)./diff(t_test);
vy_sim=diff(y_sim)./diff(t_test);

t_a=t_test(1:end-2);
ax_sim=diff(vx_sim)./diff(t_v);
ay_sim=diff(vy_sim)./diff(t_v);

plot(t_test,x_sim);
hold on;
plot(configs(configNumber).t{1},configs(configNumber).x{1});
hold off;
xlabel('Time (s)');
ylabel('X position (cm)');
legend('Predicted by Model','Experimental Data','Location','best');
set(gca,'FontSize',14);
titleText=['Mass ' num2str(m_sim) ' g, ' 'R_g ' ...
            num2str(r_sim) ' mm, ' ' Height ' ...
            num2str(h_sim) ' cm'];
title(titleText);
disp('');
end

%% Run the model on a New Case

m_sim=1898.7; % g
r_sim=41.7; % mm
h_sim=45.2; % cm

% Predict total run time

t_end=predict(model_t_end,[m_sim, r_sim, h_sim]);

% Predict num passes

passes=round(predict(model_passes,[m_sim, r_sim, h_sim]));

% Predict coeffs

num_extrema=2*passes+2;

t_test=[];
x_sim=[];
y_sim=[];

for m=1:num_extrema-1
    
    t1=predict(model_extrema{1,m},[m_sim,r_sim,h_sim]);
    t2=predict(model_extrema{1,m+1},[m_sim,r_sim,h_sim]);
    x1=predict(model_extrema{2,m},[m_sim,r_sim,h_sim]);
    x2=predict(model_extrema{2,m+1},[m_sim,r_sim,h_sim]);
    y1=predict(model_extrema{3,m},[m_sim,r_sim,h_sim]);
    y2=predict(model_extrema{3,m+1},[m_sim,r_sim,h_sim]);
    
    t_temp=linspace(t1,t2,100);
    x_temp=spline([t1,t2],[0,x1,x2,0],t_temp);
    y_temp=spline([t1,t2],[0,y1,y2,0],t_temp);
    
    t_test=[t_test(1:end-1) t_temp];
    x_sim=[x_sim(1:end-1) x_temp];
    y_sim=[y_sim(1:end-1) y_temp];
    disp('');
end

t_v=t_test(1:end-1);
vx_sim=diff(x_sim)./diff(t_test);
vy_sim=diff(y_sim)./diff(t_test);

t_a=t_test(1:end-2);
ax_sim=diff(vx_sim)./diff(t_v);
ay_sim=diff(vy_sim)./diff(t_v);

plot(t_test,x_sim);
xlabel('Time (s)');
ylabel('X position (cm)');
set(gca,'FontSize',14);