%in this code I will try to calculate the rms velocity
clear all;
load configurations_04_05_trimmed_v_and_a.mat;
temp = configurations_04_05_v_and_a;
for i = 1:length(temp)
    if length(temp(i).vx)==1 %if statement because there is some with more than 1 pass
    ax = temp(i).vx{1,:};
    ay = temp(i).vy{1,:};
    t = temp(i).t{1,:};
    vsquared = ax.^2+ay.^2;
    vrms(i) = sqrt(trapz(t,vsquared)/(t(end)-t(1)));
    else
    ax1 = temp(i).vx{1};
    ay1 = temp(i).vy{1};
    t1 = temp(i).t{1};
    vsquared1 = ax1.^2+ay1.^2;
    vrms1 = sqrt(trapz(t1,vsquared1)/(t1(end)-t1(1)));
    vx2 = temp(i).vx{2};
    vy2 = temp(i).vy{2};
    t2 = temp(i).t{2};
    vsquared2 = vx2.^2+vy2.^2;
    vrms2 = sqrt(trapz(t2,vsquared2)/(t2(end)-t2(1)));
    vrms(i) = sqrt(1/2*(vrms1.^2+vrms2.^2));
    end
end

for i = 1:length(temp)
    if length(temp(i).vx)==1 %if statement because there is some with more than 1 pass
    ax = temp(i).ax{1,:};
    ay = temp(i).ay{1,:};
    t = temp(i).t{1,:};
    asquared = ax.^2+ay.^2;
    arms(i) = sqrt(trapz(t,asquared)/(t(end)-t(1)));
    else
        ax1 = temp(i).ax{1};
    ay1 = temp(i).ay{1};
    t1 = temp(i).t{1};
    asquared1 = ax1.^2+ay1.^2;
    arms1 = sqrt(trapz(t1,asquared1)/(t1(end)-t1(1)));
    ax2 = temp(i).ax{2};
    ay2 = temp(i).ay{2};
    t2 = temp(i).t{2};
    asquared2 = ax2.^2+ay2.^2;
    arms2 = sqrt(trapz(t2,asquared2)/(t2(end)-t2(1)));
    arms(i) = sqrt(1/2*(arms1.^2+arms2.^2));
    end
end