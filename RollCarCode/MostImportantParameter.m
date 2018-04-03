%% Determining the most important parameter.
% This function plots the number of passes against the roll car mass, the
% radius of gyration, and the drop height to determine which parameter is
% the most important.
load combinedConfigurations_03_22;

drop_height=[23.3,26.6,29.9,33.5,37.7,41.3,45.2,48.7,52.8,55.9]; % cm
passes=[];
mass=[];
r=[];
h_ID=[];

for m=1:length(combinedConfigurations_03_22)
    passes=[passes combinedConfigurations_03_22(m).passes];
    for n=1:combinedConfigurations_03_22(m).total_runs
        mass=[mass combinedConfigurations_03_22(m).m];
        r=[r combinedConfigurations_03_22(m).r];
        h_ID=[h_ID combinedConfigurations_03_22(m).h];
    end
end

h_actual=zeros(size(h_ID));
for m=1:length(h_actual)
    h_actual(m)=drop_height(h_ID(m));
end

%% Figure 1: passes vs m

figure(1);
plot(mass,passes,'ko');
xlabel('m (Roll car mass (g))');
ylabel('N (Number of passes)');
title('Relationship between Number of Passes and Roll Car Mass');
set(gca,'FontSize',14);

m_p_mdl=fitlm(mass,passes);
disp(['Number passes vs mass: R^2 =' num2str(m_p_mdl.Rsquared.Ordinary)]);

mass_reg=linspace(min(mass),max(mass),100);
mass_coeff=m_p_mdl.Coefficients.Estimate;
passes_m_reg=mass_coeff(1)+mass_coeff(2)*mass_reg;

hold on;
plot(mass_reg,passes_m_reg,'k-');
ylim([0 max(passes)+1]);

legend('Data',['Linear regression']); 
a=annotation('textbox',[.2 .8 .1 .1],'String',['N = ' num2str(mass_coeff(1),3) ... 
    ' + ' num2str(mass_coeff(2),3) 'm' char(10) 'R^2 = ' ...
    num2str(m_p_mdl.Rsquared.Ordinary,3)]);
set(a,'FontSize',14);

saveas(gcf,'Graphs\MostImportantParameter\m_passes.jpg');
%% Figure 2: passes vs r_g

figure(2);
plot(r,passes,'ko');
xlabel('r_g (Radius of gyration (mm))');
ylabel('N (Number of passes)');
title('Relationship between Number of Passes and Roll Car R_g');
set(gca,'FontSize',14);

r_p_mdl=fitlm(r,passes);
disp(['Number passes vs r_g: R^2 =' num2str(r_p_mdl.Rsquared.Ordinary)]);

r_reg=linspace(min(r),max(r),100);
r_coeff=r_p_mdl.Coefficients.Estimate;
passes_r_reg=r_coeff(1)+r_coeff(2)*r_reg;

hold on;
plot(r_reg,passes_r_reg,'k-');
ylim([0 max(passes)+1]);

legend('Data',['Linear regression']); 
a=annotation('textbox',[.2 .8 .1 .1],'String',['N = ' num2str(r_coeff(1),3) ... 
    ' - ' num2str(-1*r_coeff(2),3) 'r_g' char(10) 'R^2 = ' ...
    num2str(r_p_mdl.Rsquared.Ordinary,3)]);
set(a,'FontSize',14);

saveas(gcf,'Graphs\MostImportantParameter\r_passes.jpg');
%% Figure 3: passes vs h_actual

figure(3);
plot(h_actual,passes,'ko');
xlabel('h (Drop height (cm))');
ylabel('N (Number of passes)');
title('Relationship between Number of Passes and Drop Height');
set(gca,'FontSize',14);

h_actual_p_mdl=fitlm(h_actual,passes);
disp(['Number passes vs h_actual: R^2 =' num2str(h_actual_p_mdl.Rsquared.Ordinary)]);

h_actual_reg=linspace(min(h_actual),max(h_actual),100);
h_actual_coeff=h_actual_p_mdl.Coefficients.Estimate;
passes_h_actual_reg=h_actual_coeff(1)+h_actual_coeff(2)*h_actual_reg;

hold on;
plot(h_actual_reg,passes_h_actual_reg,'k-');
ylim([0 max(passes)+1]);

legend('Data',['Linear regression']); 
a=annotation('textbox',[.2 .8 .1 .1],'String',['N = ' num2str(h_actual_coeff(1),3) ... 
    ' + ' num2str(h_actual_coeff(2),3) 'h' char(10) 'R^2 = ' ...
    num2str(h_actual_p_mdl.Rsquared.Ordinary,3)]);
set(a,'FontSize',14);

saveas(gcf,'Graphs\MostImportantParameter\h_actual_passes.jpg');