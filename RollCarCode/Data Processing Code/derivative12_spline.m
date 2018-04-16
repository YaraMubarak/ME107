function [deriv1,deriv1err,deriv2,deriv2err]=derivative12_spline(xData,xerr,yData)
    d=3;
    num_el=4;
    
    if length(xData)<num_el
        num_el=3;
        d=2;
    end
    
    deriv1=zeros(size(xData));
    deriv1err=zeros(size(xData));
    deriv2=zeros(size(yData));
    deriv2err=zeros(size(xData));
    deriv3=zeros(size(yData));
    for m=1:length(xData)-num_el+1 
        ws = warning('off','all');
        p=polyfit(xData(m:m+num_el-1),yData(m:m+num_el-1),d);
        warning(ws);
        p_prime=polyder(p);
        p_prime_prime=polyder(p_prime);
        p_prime_prime_prime=polyder(p_prime_prime);
        for n=0:num_el-1
            deriv1(m+n)=polyval(p_prime,xData(m+n));
            deriv2(m+n)=polyval(p_prime_prime,xData(m+n));
            deriv3(m+n)=polyval(p_prime_prime_prime,xData(m+n));
            
            if ~isnan(xerr)
                deriv1err(m+n)=deriv2(m+n)*xerr(m+n);
                deriv2err(m+n)=deriv3(m+n)*xerr(m+n);
            else
                deriv1err(m+n)=0;
                deriv2err(m+n)=0;
            end
        end
        m=m+num_el-1;
    end
    
end