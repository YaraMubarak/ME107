function [deriv1,deriv1err,deriv2,deriv2err]=derivative12(xData,yData)
    d=3;
    num_el=10;
    
    if length(xData)<num_el
        num_el=3;
        d=2;
    end
    
    deriv1=zeros(size(xData));
    deriv1err=zeros(size(xData));
    deriv2=zeros(size(yData));
    deriv2err=zeros(size(xData));
    for m=1:length(xData)-num_el+1 
        
        if d==3
            T=[0 0;
               1 0;
               2 0;
               3 0];
        elseif d==2
            T=[0 0;
               1 0;
               2 0];
        end
        
        linear_reg=fitlm(xData(m:m+num_el-1),yData(m:m+num_el-1),...
            T);
        stats=linear_reg.Coefficients;
        if d==3
            p=[stats.Estimate(4) stats.Estimate(3) stats.Estimate(2) stats.Estimate(1)];
            se_coeff=[stats.SE(1) stats.SE(2) stats.SE(3) stats.SE(4)];
            u_coeff=tinv(0.975,length(xData)-2)*se_coeff;
            
        elseif d==2
            p=[stats.Estimate(3) stats.Estimate(2) stats.Estimate(1)];
            se_coeff=[stats.SE(1) stats.SE(2) stats.SE(3)];
            u_coeff=tinv(0.975,length(xData)-2)*se_coeff;
        end
        %{
        p=polyfit(xData(m:m+num_el-1),yData(m:m+num_el-1),d);
        %}        
        p_prime=polyder(p);
        p_prime_prime=polyder(p_prime);
        for n=0:num_el-1
            deriv1(m+n)=polyval(p_prime,xData(m+n));
            deriv2(m+n)=polyval(p_prime_prime,xData(m+n));
            if d==3
                deriv1err(m+n)=sqrt((1*u_coeff(2))^2+...
                    (2*xData(m+n)*u_coeff(3))^2+...
                    (6*xData(m+n)*u_coeff(4))^2);
                deriv2err(m+n)=sqrt((2*u_coeff(3))^2+...
                    (6*xData(m+n)*u_coeff(4))^2);
                
            elseif d==2
                deriv1err(m+n)=sqrt((1*u_coeff(2))^2+...
                    (2*xData(m+n)*u_coeff(3))^2);
                deriv2err(m+n)=sqrt((2*u_coeff(3))^2);
            end
        end
        m=m+num_el-1;
    end
    
end