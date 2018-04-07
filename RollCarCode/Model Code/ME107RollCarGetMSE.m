function MeanSquareError = ME107RollCarGetMSE(vector,Tdata,Xdata,Ydata,TimeStep,m,rw,rg,s_to_x,TrackPosition_s,TrackSlope_s,TrackCurvature_s)

CD = vector(1);
CL = vector(2);
muk = vector(3);
mus = muk*vector(4);
sinit = vector(5);

RCDAF = GetRollCarDynamicsFunction(m,rw,rg,mus,muk,CD,CL,TrackPosition_s,TrackSlope_s,TrackCurvature_s);

[tsim,xvectsim] = RungeKutta4(RCDAF,[0,Tdata(end)],[sinit;0;0;0],TimeStep);
ssim = xvectsim(:,1);
% ! there is hysterisis in the call to s_to_x so this dumnb thing is
% required. have no clue as to cause fo hysterisis, perhapse how code was
% optimized to run on vector inputs.
xsim = zeros([numel(ssim),1]);
for apple = 1:numel(ssim) 
    xsim(apple) = s_to_x(ssim(apple));
end
% for good measure ill do this one the same way, yes it is less efficient
% but i don't care. 
ysim = zeros([numel(ssim),1]);
for plum = 1:numel(xsim)
    ysim(plum) = TrackPosition_s(ssim(plum));
end
xfunction = @(xx) linterp(tsim,xsim,xx);
yfunction = @(xx) linterp(tsim,ysim,xx);

MeanSquareError = mean(sqrt((xfunction(Tdata)-Xdata).^2 + (yfunction(Tdata)-Ydata).^2));
fprintf('Mean Square Error: %.6f \n', MeanSquareError)

end