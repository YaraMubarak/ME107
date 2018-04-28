function config_with_v_a=computeVelocityAndAcceleration(averagedConfigurations)
% This function computes the velocity and acceleration of each
% configuration.
    config_with_v_a=averagedConfigurations;
    
    for m=1:length(averagedConfigurations)
        for n=1:length(averagedConfigurations(m).x)
            t=averagedConfigurations(m).t{n};
            x=averagedConfigurations(m).x{n};
            y=averagedConfigurations(m).y{n};
            terr=averagedConfigurations(m).terr{n};
            [vx,u_vx,ax,u_ax]=derivative12_spline(t,terr,x);
            config_with_v_a(m).vx{n}=vx;
            config_with_v_a(m).ax{n}=ax;
            [vy,u_vy,ay,u_ay]=derivative12_spline(t,terr,y);
            config_with_v_a(m).vy{n}=vy;
            config_with_v_a(m).ay{n}=ay;
            
            config_with_v_a(m).vx_err{n}=u_vx;
            config_with_v_a(m).vy_err{n}=u_vy;
            config_with_v_a(m).ax_err{n}=u_ax;
            config_with_v_a(m).ay_err{n}=u_ay;
        end
    end
end