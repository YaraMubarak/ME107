function config_with_v_a=computeVelocityAndAcceleration(averagedConfigurations)
    config_with_v_a=averagedConfigurations;
    config_with_v_a.vx=cell(1,length(averagedConfigurations.x));
    config_with_v_a.vy=cell(1,length(averagedConfigurations.y));
    config_with_v_a.vx_err=cell(1,length(averagedConfigurations.x));
    config_with_v_a.ax=cell(1,length(averagedConfigurations.x));
    config_with_v_a.ay=cell(1,length(averagedConfigurations.y));
    
    for m=1:length(averagedConfigurations)
        for n=1:length(averagedConfigurations.x)
            config_with_v_a.vx{n}=diff(averagedConfigurations.x{n})./...
                diff(averagedConfigurations.t{n});
            config_with_v_a.vy{n}=diff(averagedConfigurations.y{n})./...
                diff(averagedConfigurations.t{n});
            config_with_v_a.ax=diff(config_with_v_a.vx{n})./...
                diff(averagedConfigurations.t{n});
            config_with_v_a.ay=diff(config_with_v_a.vy{n})./...
                diff(averagedConfigurations.t{n});
        
            v_err;
            a_err;
        end
    end
end