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

%% Find coeffs for x

degree=0;
coeffs_data=struct('matrix',[],'columns',[],'m',[],'r',[],'h',[]);

count=1;
for m=1:length(configs)
    for n=1:length(configs(m).x)
        
    begin_left_hillx=213.9+129.7+180.7+108.8;
    xData=configs(m).x{n};
    tData=configs(m).t{n};
    
    made_it_over_hill=true;
    increasing=true;
    last_index=1;
    index=2;
    passes=0;
    
    coeffs_matrix=[];
    
    while made_it_over_hill && index<=length(xData)
        localXMax=68.1+213.9+129.7+180.7+108.8;
        
        if xData(index)<xData(index-1) && increasing
            actual_degree=min(degree,index-last_index-1);
            if actual_degree<0
                actual_degree=0;
            end
            coeffs=polyfit(tData(last_index:index),xData(last_index:index),actual_degree)';
            
            if actual_degree<degree
                coeffs=[zeros(degree-actual_degree,1); coeffs];
            end
            
            coeffs_matrix=[coeffs_matrix, coeffs];
            
            disp('');
            
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
            actual_degree=min(degree,index-last_index-1);
            if actual_degree<0
                actual_degree=0;
            end
            coeffs=polyfit(tData(last_index:index),xData(last_index:index),actual_degree)';
            
            if actual_degree<degree
                coeffs=[zeros(degree-actual_degree,1); coeffs];
            end
            
            coeffs_matrix=[coeffs_matrix, coeffs];
            
            disp('');
            last_index=index;
            
        end
        
        index=index+1;
    end
    actual_degree=min(degree,length(xData)-last_index-1);
    if actual_degree<0
        actual_degree=0;
    end
    coeffs=polyfit(tData(last_index:end),xData(last_index:end),actual_degree)';
            
    if actual_degree<degree
        coeffs=[zeros(degree-actual_degree,1); coeffs];
    end
            
    coeffs_matrix=[coeffs_matrix, coeffs];
    
    coeff_struct.matrix=coeffs_matrix;
    coeff_struct.columns=size(coeffs_matrix,2);
    coeff_struct.m=configs(m).m;
    coeff_struct.r=configs(m).r;
    coeff_struct.h=configs(m).h;
    
    coeffs_data(count)=coeff_struct;
    
    count=count+1;
    end
end

c_models=cell(degree,max([coeffs_data.columns]));
mass_repeat_c=cell(1,max([coeffs_data.columns]));
rg_repeat_c=cell(1,max([coeffs_data.columns]));
h_repeat_c=cell(1,max([coeffs_data.columns]));
combined_coeffs=cell(degree,max([coeffs_data.columns]));

for m=1:length(coeffs_data)
    
    for p=1:degree
    for n=1:coeffs_data(m).columns
        try
        combined_coeffs{p,n}=[combined_coeffs{p,n}; coeffs_data(m).matrix(p,n)];
        catch Exception
            disp('');
        end
    end
    end
end

for m=1:length(coeffs_data)
    for n=1:coeffs_data(m).columns
        mass_repeat_c{n}=[mass_repeat_c{n}; coeffs_data(m).m];%coeffs_data(m).m*ones(length(coeffs_data(m).matrix(:,n)),1)];
        rg_repeat_c{n}=[rg_repeat_c{n}; coeffs_data(m).r];%coeffs_data(m).r*ones(length(coeffs_data(m).matrix(:,n)),1)];
        h_repeat_c{n}=[h_repeat_c{n}; convertHeightSR(coeffs_data(m).h)];%convertHeightSR(coeffs_data(m).h)*ones(length(coeffs_data(m).matrix(:,n)),1)];
    end
end

for m=1:max([coeffs_data.columns])
    for p=1:degree
    tbl=table(mass_repeat_c{m},rg_repeat_c{m},h_repeat_c{m},combined_coeffs{p,m},'VariableNames',{'mass','rg','height','c'});
    c_models{p,m}=fitlm(tbl,'c ~ mass+rg+height');
    disp('');
    end
end


%% Test the model

m_sim=1044.4; % g
r_sim=43.9; % mm
h_sim=23.3; % cm

% Predict total run time

t_end=predict(model_t_end,[m_sim, r_sim, h_sim]);

% Predict num passes

passes=predict(model_passes,[m_sim, r_sim, h_sim]);

t_each_division=(t_end)/(passes+0.5);

% Predict coeffs

num_divisions=2*passes+1;

t_test=[];
x_sim=[];

for m=1:num_divisions
    if m==num_divisions
        t_local=linspace(t_each_division*(m-1),t_end,100);
    else
        t_local=linspace(t_each_division*(m-1),t_each_division*m,100);
    end
    t_test=[t_test t_local];
    
    coeffs_sim=zeros(degree,1);
    for n=1:degree
        mdl=c_models{n,m};
        coeffs_sim(n)=predict(mdl,[m_sim,r_sim,h_sim]);
    end
    
    x_local=polyval(coeffs_sim,t_local);
    x_sim=[x_sim x_local];
    plot(t_test,x_sim);
    disp('');
end

disp('');
