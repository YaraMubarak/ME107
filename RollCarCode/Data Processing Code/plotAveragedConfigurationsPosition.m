function []=plotAveragedConfigurationsPosition(averagedConfigurations,config_parameter,save)

    if isempty(config_parameter)
        len=length(averagedConfigurations);
    else
        len=length(config_parameter);
    end

drop_height=[23.3,26.6,29.9,33.5,37.7,41.3,45.2,48.7,52.8,55.9]; % cm
for count=1:3
    
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
    vxerr=averagedConfigurations(m).vx_err;
    yData=averagedConfigurations(m).y;
    yerr=averagedConfigurations(m).yerr;
    vyerr=averagedConfigurations(m).vy_err;
    tData=averagedConfigurations(m).t;
    terr=averagedConfigurations(m).terr;
    
    vxData=averagedConfigurations(m).vx;
    vyData=averagedConfigurations(m).vy;
    axData=averagedConfigurations(m).ax;
    ayData=averagedConfigurations(m).ay;
    
    legendText=cell(1,length(passes));
    for n=1:length(xData)
        if isnan(terr{n})
            terr{n}=zeros(size(xData{n}));
        end
        
        figure(6*m-5);
        hold on;
        errorbar(tData{n},xData{n},-xerr{n},xerr{n},-terr{n},terr{n});
        figure(6*m-4);
        hold on;
        errorbar(tData{n},vxData{n},-xerr{n},xerr{n},-terr{n},terr{n});
        figure(6*m-3);
        hold on;
        errorbar(tData{n},axData{n},-xerr{n},xerr{n},-terr{n},terr{n});
        figure(6*m-2);
        hold on;
        errorbar(tData{n},yData{n},-yerr{n},yerr{n},-terr{n},terr{n});
        figure(6*m-1);
        hold on;
        errorbar(tData{n},vyData{n},-yerr{n},yerr{n},-terr{n},terr{n});
        figure(6*m);
        hold on;
        errorbar(tData{n},ayData{n},-yerr{n},yerr{n},-terr{n},terr{n});
        legendText{n}=[num2str(passes(n)) ' passes'];
        
    end
    
    titleText=['Mass ' num2str(mass) ' g, ' 'R_g ' ...
            num2str(r) ' mm, ' ' Height ' ...
            num2str(height) ' cm'];
    
    figure(6*m-5);
    title(titleText);
    xlabel('Time (s)');
    ylabel('X position (cm)');
    legend(legendText,'Location','best');    
    set(gca,'FontSize',14);
    
    if save
    
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Position/' ...
        'X_M' strrep(num2str(mass),'.','_') 'R_g' ...
            strrep(num2str(r),'.','_') 'Height' ...
            strrep(num2str(height),'.','_')],'jpg');

    end
        
    figure(6*m-4);
    title(titleText);
    xlabel('Time (s)');
    ylabel('v_x (X velocity (cm/s))');
    legend(legendText,'Location','best');    
    set(gca,'FontSize',14);
    
    if save
    
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Position/' ...
        'VX_M' strrep(num2str(mass),'.','_') 'R_g' ...
            strrep(num2str(r),'.','_') 'Height' ...
            strrep(num2str(height),'.','_')],'jpg');

    end
    
    figure(6*m-3);
    title(titleText);
    xlabel('Time (s)');
    ylabel('a_x (X acceleration (cm/s^2))');
    legend(legendText,'Location','best');    
    set(gca,'FontSize',14);
    
    if save
    
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Position/' ...
        'AX_M' strrep(num2str(mass),'.','_') 'R_g' ...
            strrep(num2str(r),'.','_') 'Height' ...
            strrep(num2str(height),'.','_')],'jpg');

    end
    
    figure(6*m-2);
    title(titleText);
    xlabel('Time (s)');
    ylabel('Y position (cm)');
    legend(legendText,'Location','best');
    set(gca,'FontSize',14);
    
    if save
    
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Position/' ...
        'Y_M' strrep(num2str(mass),'.','_') 'R_g' ...
            strrep(num2str(r),'.','_') 'Height' ...
            strrep(num2str(height),'.','_')],'jpg');
        
    end
    
    figure(6*m-1);
    title(titleText);
    xlabel('Time (s)');
    ylabel('v_y (Y velocity (cm/s))');
    legend(legendText,'Location','best');
    set(gca,'FontSize',14);
    
    if save
    
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Position/' ...
        'VY_M' strrep(num2str(mass),'.','_') 'R_g' ...
            strrep(num2str(r),'.','_') 'Height' ...
            strrep(num2str(height),'.','_')],'jpg');
        
    end
       
    figure(6*m);
    title(titleText);
    xlabel('Time (s)');
    ylabel('a_y (Y acceleration (cm/s^2))');
    legend(legendText,'Location','best');
    set(gca,'FontSize',14);
    
    if save
    
    saveas(gcf,...
        ['/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Graphs/Position/' ...
        'AY_M' strrep(num2str(mass),'.','_') 'R_g' ...
            strrep(num2str(r),'.','_') 'Height' ...
            strrep(num2str(height),'.','_')],'jpg');
        
    end
    
end
end