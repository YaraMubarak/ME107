function MeanSquareError = ME107RollCarGetMSE(vector,Tdata,Xdata,Ydata,TimeStep,m,rw,rg,s_to_x,TrackPosition_s,TrackSlope_s,TrackConcavity_s,TrackCurvature_s,Passes)

CD = vector(1);
CRF = vector(2);
IDK = vector(3);
muk = vector(4);
mus = muk*vector(5);
sinit = vector(6);

RCDAF = GetRollCarDynamicsFunction(m,rw,rg,mus,muk,CD,CRF,IDK,TrackPosition_s,TrackSlope_s,TrackConcavity_s,TrackCurvature_s);

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
xfunction = @(xx) interp1(tsim,xsim,xx,'pchip');
yfunction = @(xx) interp1(tsim,ysim,xx,'pchip');

MeanSquareError = mean(sqrt((xfunction(Tdata)-Xdata).^2 + (yfunction(Tdata)-Ydata).^2));
fprintf('Mean Square Error: %.6f \n', MeanSquareError)

end