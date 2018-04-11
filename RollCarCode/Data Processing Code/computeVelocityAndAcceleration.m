function config_with_v_a=computeVelocityAndAcceleration(averagedConfigurations)
    config_with_v_a=averagedConfigurations;
    
    for m=1:length(averagedConfigurations)
        config_with_v_a(m).vx_err=averagedConfigurations(m).xerr;
        config_with_v_a(m).vy_err=averagedConfigurations(m).yerr;
        config_with_v_a(m).ax_err=averagedConfigurations(m).xerr;
        config_with_v_a(m).ay_err=averagedConfigurations(m).yerr;
        for n=1:length(averagedConfigurations(m).x)
            t=averagedConfigurations(m).t{n};
            x=averagedConfigurations(m).x{n};
            y=averagedConfigurations(m).y{n};
            [vx,ax]=derivative12(t,x);
            config_with_v_a(m).vx{n}=vx;
            config_with_v_a(m).ax{n}=ax;
            [vy,ay]=derivative12(t,y);
            config_with_v_a(m).vy{n}=vy;
            config_with_v_a(m).ay{n}=ay;
        end
    end
end