function [deriv1,deriv2]=derivative12(xData,yData)
    d=3;
    num_el=10;
    
    
    if length(xData)<num_el
        num_el=3;
        d=2;
    end
    
    deriv1=zeros(size(xData));
    deriv2=zeros(size(yData));
    for m=1:length(xData)-num_el+1 
        p=polyfit(xData(m:m+num_el-1),yData(m:m+num_el-1),d);
        p_prime=polyder(p);
        p_prime_prime=polyder(p_prime);
        
        for n=0:num_el-1
            deriv1(m+n)=polyval(p_prime,xData(m+n));
            deriv2(m+n)=polyval(p_prime_prime,xData(m+n));
        end
        m=m+num_el-1;
    end
    
end