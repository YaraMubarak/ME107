function [tlist,flist] = RungeKutta4(fprime,intv,fa,h)
if intv(2)-intv(1) <0
    error('Illegal interval')
elseif h <= 0
    error('Illegal Hmax')
end
tlist = intv(1):h:intv(2);
flist = reshape(fa,[numel(fa),1]);
w = reshape(fa,[numel(fa),1]);
for t = tlist(1:end-1) % only iterates through columns
    k1 = h*fprime(t,w);
    k2 = h*fprime(t+h/2,w+.5.*k1);
    k3 = h*fprime(t+h/2,w+.5.*k2);
    k4 = h*fprime(t+h,w+k3);
    w = w + (k1+2*k2+2*k3+k4)./6;
    flist = [flist,w];
end
tlist = tlist';
flist = flist';
end