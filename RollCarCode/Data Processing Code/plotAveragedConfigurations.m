function []=plotAveragedConfigurations(averagedConfigurations,config_parameter)

    if isempty(config_parameter)
        len=length(averagedConfigurations);
    else
        len=length(config_parameter);
    end

drop_height=[23.3,26.6,29.9,33.5,37.7,41.3,45.2,48.7,52.8,55.9]; % cm
for count=1:len
    
    if ~isempty(config_parameter)
            m=find([averagedConfigurations.m]==config_parameter(count).m & ...
            [averagedConfigurations.r]==config_parameter(count).r & ...
            [averagedConfigurations.h]==config_parameter(count).h);
    else
            m=count;
    end
    
    passes=averagedConfigurations(m).passes;
    mass=averagedConfigurations(m).m;
    r=averagedConfigurations(m).r;
    height=drop_height(averagedConfigurations(m).h);
    xData=averagedConfigurations(m).x;
    xerr=averagedConfigurations(m).xerr;
    yData=averagedConfigurations(m).y;
    yerr=averagedConfigurations(m).yerr;
    tData=averagedConfigurations(m).t;
    terr=averagedConfigurations(m).terr;
    
    legendText=cell(1,length(passes));
    for n=1:length(passes)
        if isnan(terr{n})
            terr{n}=zeros(size(xData{n}));
        end
        
        figure(2*m-1);
        hold on;
        errorbar(tData{n},xData{n},xerr,terr{n});
        hold off;
        figure(2*m);
        hold on;
        errorbar(tData{n},yData{n},yerr,terr{n});
        hold off;
        legendText{n}=[num2str(passes(n)) ' passes'];
        
    end
    figure(2*m-1);
    title(['Mass ' num2str(mass) ' g, ' 'R_g ' ...
            num2str(r) ' mm, ' ' Height ' ...
            num2str(height) ' cm']);
    xlabel('Time (s)');
    ylabel('X position (cm)');
    legend(legendText,'Location','best');
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Kinematics/' ...
        'X_M' strrep(num2str(mass),'.','_') 'R_g' ...
            strrep(num2str(r),'.','_') 'Height' ...
            strrep(num2str(height),'.','_')],'jpg');
    
    figure(2*m);
    title(['Mass ' num2str(mass) ' g, ' 'R_g ' ...
            num2str(r) ' mm, ' ' Height  ' ...
            num2str(height) ' cm']);
    xlabel('Time (s)');
    ylabel('X position (cm)');
    legend(legendText,'Location','best');
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Kinematics/' ...
        'Y_M' num2str(mass) 'R_g' ...
            num2str(r) 'Height' ...
            num2str(height)],'jpg');
end
end