% FIELDS of a configuration parameter struct:
%
% - m (mass, in grams)
% - r (radius of gyration, in mm)
% - h (height, in cm)
%
%
% NOTE: to simply plot all configurations, pass an empty array as
% config_parameter.

function []=plotCombinedConfigurations(combinedConfigurations,config_parameter)

    if isempty(config_parameter)
        len=length(combinedConfigurations);
    else
        len=length(config_parameter);
    end
    
    for m=1:len
        
        if ~isempty(config_parameter)
            index=find([combinedConfigurations.m]==config_parameter(m).m & ...
            [combinedConfigurations.r]==config_parameter(m).r & ...
            [combinedConfigurations.h]==config_parameter(m).h);
        else
            index=m;
        end
        
        mass=combinedConfigurations(index).m;
        r=combinedConfigurations(index).r;
        h=combinedConfigurations(index).h;
        
        legendText=cell(1,combinedConfigurations(index).total_runs);
        
        for n=1:combinedConfigurations(index).total_runs
            figure(2*(m-1)+1);
            hold on;
            %{
            errorbar(combinedConfigurations(index).t{n},...
                combinedConfigurations(index).x{n},...
                combinedConfigurations(index).xerr{n},...
                combinedConfigurations(index).terr{n}...
                );
            %}
            plot(combinedConfigurations(index).t{n},...
                combinedConfigurations(index).x{n},'.-');
            figure(2*m);
            hold on;
            %{
            errorbar(combinedConfigurations(index).t{n},...
                combinedConfigurations(index).y{n},...
                combinedConfigurations(index).yerr{n},...
                combinedConfigurations(index).terr{n}...
                );
            %}
            plot(combinedConfigurations(index).t{n},...
                combinedConfigurations(index).y{n},'.-');
            legendText{n}=['Run ' num2str(n)];
        end
        figure(2*(m-1)+1);
        xlabel('Time (s)');
        ylabel('x coordinate (cm)');
        title(['Mass ' num2str(mass) ' g, ' 'R_g ' ...
            num2str(r) ' mm, ' ' Height # ' ...
            num2str(h)]);
        set(gca,'FontSize',14);
        l=legend(legendText);
        set(l,'Location','best');
        figure(2*m);
        xlabel('Time (s)');
        ylabel('y coordinate (cm)');
        title(['Mass ' num2str(mass) ' g, ' 'R_g ' ...
            num2str(r) ' mm, ' ' Height # ' ...
            num2str(h)]);
        set(gca,'FontSize',14);
        l=legend(legendText);
        set(l,'Location','best');
    end
end