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

%% x_max

x_max=[];
a=[];
b=[];
mass_a=[];
rg_a=[];
height_a=[];
mass_b=[];
rg_b=[];
height_b=[];
count_a=0;
count_b=0;
for m=1:length(configs)
    for n=1:length(configs(m).passes)
        t_end=max(configs(m).t{n});
        t=configs(m).t{n};
        x_data=configs(m).x{n};
        if configs(m).passes(n)>=0
        count_a=count_a+1;
        mass_a=[mass_a; configs(m).m];
        rg_a=[rg_a; configs(m).r];
        height_a=[height_a; convertHeightSR(configs(m).h)];        x_max=max(x_data);
        T=max(t)/(configs(m).passes(n)+0.5);
        f=1/T;
        
        x_data=x_data';
        t=t';
        x_model_fun=@(a,x) a(1)+((x_max/2)).*sin(2*pi*f*x(:,1)+a(2));
        beta0=[0;0];
        
        
        table_data=table(t,x_data);
        model_x=fitnlm(table_data,x_model_fun,beta0);
        
        
        a(count_a,1)=model_x.Coefficients{1,1};
        a(count_a,2)=model_x.Coefficients{2,1};
        else
            count_b=count_b+1;
            mass_b=[mass_b; configs(m).m];
            rg_b=[rg_b; configs(m).r];
            height_b=[height_b; convertHeightSR(configs(m).h)];
            t=t';
            x_data=x_data';
            table_data=table(t,x_data);
            model_x=fitlm(table_data,'x_data ~ t^3');
            
            for k=1:4
                b(count_b,k)=model_x.Coefficients{k,1};
            end
            
        end
        
        %{
        t_test=linspace(0,max(t))';
        x_test=predict(model_x,t_test);
        
        
        plot(t_test,x_test);
        hold on;
        plot(configs(m).t{n},configs(m).x{n});
        hold off;
        disp('');
        %}
    end
end

%% Make Model: x

T_model_a1=table(mass_a,rg_a,height_a,a(:,1));
T_model_a2=table(mass_a,rg_a,height_a,a(:,2));

%{
T_model_b1=table(mass_b,rg_b,height_b,b(:,1));
T_model_b2=table(mass_b,rg_b,height_b,b(:,2));
T_model_b3=table(mass_b,rg_b,height_b,b(:,3));
T_model_b4=table(mass_b,rg_b,height_b,b(:,4));
T_model_b5=table(mass_b,rg_b,height_b,b(:,5));
T_model_b6=table(mass_b,rg_b,height_b,b(:,6));
%}

model_a1=fitlm(T_model_a1,'Var4 ~ mass_a*rg_a*height_a');
model_a2=fitlm(T_model_a2,'Var4 ~ mass_a*rg_a*height_a');
%{
model_b1=fitlm(T_model_b1,'Var4 ~ mass_b*rg_b*height_b');
model_b2=fitlm(T_model_b2,'Var4 ~ mass_b*rg_b*height_b');
model_b3=fitlm(T_model_b3,'Var4 ~ mass_b*rg_b*height_b');
model_b4=fitlm(T_model_b4,'Var4 ~ mass_b*rg_b*height_b');
model_b5=fitlm(T_model_b5,'Var4 ~ mass_b*rg_b*height_b');
model_b6=fitlm(T_model_b6,'Var4 ~ mass_b*rg_b*height_b');
%}
model_a={model_a1,model_a2};
model_b={}%{model_b1,model_b2,model_b3,model_b4};

%% Validate Model: x

for configNumber=1:length(configs)
tReal=configs(configNumber).t{1};
xReal=configs(configNumber).x{1};
m=configs(configNumber).m;
rg=configs(configNumber).r;
h=convertHeightSR(configs(configNumber).h);

validateModelX(model_passes,model_x_max,model_a,model_b,model_t_end,tReal,xReal,m,rg,h);

disp('');
end

%% Test Model on New Configuration

m=1000;
rg=40;
h=50;
validateModelX(model_passes,model_x_max,model_a,model_b,model_t_end,[],[],m,rg,h);
