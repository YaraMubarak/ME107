%% Load Data

clear all;
load configurations_04_12_trimmed_v_and_a;
configs=configurations_04_12_trimmed_v_and_a;
mass=[];
rg=[];
height=[];
passes=[];
mass_repeat=[];
rg_repeat=[];
height_repeat=[];
count=0;
for m=1:length(configs)
    for n=1:length(configs(m).passes)
        passes=[passes; configs(m).passes(n)];
        count=count+1;
    end
end

t=[];
x=[];
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
        t=[t configs(m).t{n}];
        x=[x configs(m).x{n}];
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
x=x';
y=y';
vx=vx';
vy=vy';
ax=ax';
ay=ay';

%% Make tables.
T_model_passes=table(mass,rg,height,passes);
T_model_x=table(mass_repeat,rg_repeat,height_repeat,t,x);
T_model_y=table(mass_repeat,rg_repeat,height_repeat,t,y);
T_model_vx=table(mass_repeat,rg_repeat,height_repeat,t,vx);
T_model_vy=table(mass_repeat,rg_repeat,height_repeat,t,vy);
T_model_ax=table(mass_repeat,rg_repeat,height_repeat,t,ax);
T_model_ay=table(mass_repeat,rg_repeat,height_repeat,t,ay);

modeltype='poly2333';

%% Make model: passes.
model_passes=fitlm(T_model_passes,'passes ~ mass*rg^2*height');
%% Make model: x
model_x=fitlm(T_model_x,'x ~ mass_repeat*rg_repeat^2*height_repeat+t');
%% Make model: y
model_y=fitlm(T_model_y,modeltype);
%% Make model: vx
model_vx=fitlm(T_model_vx,modeltype);
%% Make model: vy
model_vy=fitlm(T_model_vy,modeltype);
%% Make model: ax
model_ax=fitlm(T_model_ax,modeltype);
%% Make model: ay
model_ay=fitlm(T_model_ay,modeltype);