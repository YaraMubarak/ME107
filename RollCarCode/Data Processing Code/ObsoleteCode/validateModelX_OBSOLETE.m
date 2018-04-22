function[]=validateModelX(model_x,model_t_end,model_x_max,m,rg,h,realData)
    ind=[[realData.m]==m & [realData.r]==rg & convertHeightSR([realData.h])==h];
    
    tReal=realData(ind).t{1};
    xReal=realData(ind).x{1};
    
    length_test=100;
    
    m_test=m*ones(length_test,1);
    rg_test=rg*ones(length_test,1);
    height_test=h*ones(length_test,1);
    
    t_end=predict(model_t_end,[m,rg,h]);
    x_max=predict(model_x_max,[m,rg,h]);
    
    t_nondim=linspace(0,t_end,length_test)/t_end;
    x_nondim_pred=predict(model_x,[m_test,rg_test,height_test,t_nondim']);
    
    t_sim=t_nondim*t_end;
    x_pred=x_nondim_pred*x_max;
    
    plot(t_sim,x_pred);
    hold on;
    plot(tReal,xReal);
    legend('Simulation','Real');
end