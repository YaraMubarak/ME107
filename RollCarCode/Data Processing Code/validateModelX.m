function []=validateModelX(model_passes,model_x_max,model_a,model_b,model_t_end,tReal,xReal,m,rg,h)
    passes=predict(model_passes,[m,rg,h]);
    x_max=predict(model_x_max,[m,rg,h]);
    
    tTest=linspace(0,predict(model_t_end,[m,rg,h]),100);
    xTest=[];
    
    if passes>=0
        T=predict(model_t_end,[m,rg,h])/(passes+0.5);
        f=1/T;
        a1=predict(model_a{1},[m,rg,h]);
        a2=predict(model_a{2},[m,rg,h]);
        xTest=a1+((x_max/2)).*sin(2*pi*f*tTest+a2);
    else
        b1=predict(model_b{1},[m,rg,h]);
        b2=predict(model_b{2},[m,rg,h]);
        b3=predict(model_b{3},[m,rg,h]);
        b4=predict(model_b{4},[m,rg,h]);
        %{
        b5=predict(model_b{5},[m,rg,h]);
        b6=predict(model_b{6},[m,rg,h]);
        %}
        xTest=b1+b2*tTest+b3*tTest.^2+b4*tTest.^3;%+b4*tTest.^3+b5*tTest.^4+b6*tTest.^5;
    end
    
    plot(tTest,xTest);
    hold on;
    plot(tReal,xReal);
    xlabel('Time (s)');
    ylabel('X Position (cm)');
    legend('Simulation','Real');
    hold off;
end