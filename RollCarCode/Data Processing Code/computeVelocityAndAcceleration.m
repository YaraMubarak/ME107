function config_with_v_a=computeVelocityAndAcceleration(averagedConfigurations)
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
            %{
            terr=averagedConfigurations(m).terr{n};
            
            delta_x=diff(x);
            delta_y=diff(y);
            delta_t=diff(t);
            delta_x(length(t))=delta_x(length(t)-1);
            delta_y(length(t))=delta_y(length(t)-1);
            delta_t(length(t))=delta_t(length(t)-1);
            
            u_delta_t=zeros(size(delta_t));
            for p=1:length(terr)-1
                u_delta_t(p)=sqrt(terr(p)^2+terr(p+1)^2);
            end
            u_delta_t(length(t))=u_delta_t(length(t)-1);
            
            u_vx=delta_x./delta_t.^2.*u_delta_t;
            u_vy=delta_y./delta_t.^2.*u_delta_t;
            
            delta_vx=diff(vx);
            delta_vy=diff(vy);
            
            delta_vx(length(t))=delta_vx(length(t)-1);
            delta_vy(length(t))=delta_vy(length(t)-1);
            
            u_delta_vx=zeros(size(delta_vx));
            u_delta_vy=zeros(size(delta_vy));
            
            for p=1:length(terr)-1
                u_delta_vx(p)=sqrt((delta_vx(p))^2+(delta_vx(p+1))^2);
                u_delta_vy(p)=sqrt((delta_vy(p))^2+(delta_vy(p+1))^2);
            end
            
            u_ax=sqrt((delta_vx./delta_t.^2.*u_delta_t).^2+...
                (u_delta_vx./delta_t).^2);
            u_ay=sqrt((delta_vy./delta_t.^2.*u_delta_t).^2+...
                (u_delta_vy./delta_t).^2);
            %}
            
            config_with_v_a(m).vx_err{n}=u_vx;
            config_with_v_a(m).vy_err{n}=u_vy;
            config_with_v_a(m).ax_err{n}=u_ax;
            config_with_v_a(m).ay_err{n}=u_ay;
        end
    end
end