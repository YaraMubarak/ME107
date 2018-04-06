function ChildrenVect = ME107RollCarMakeNChildren(N,bounds)
% CD_bounds = [0,3];
% CL_bounds = [0,.1];
% muk_bounds = [0,.5];
% mus_times_bounds = [1,2];
% Random_bounds = [CD_bounds;CL_bounds;muk_bounds;mus_times_bounds];
% N = 3;
% bounds = Random_bounds;


elements = numel(bounds)/2;
ChildrenVect = zeros([elements,N]);
LowerVect = bounds(:,1);
UpperVect = bounds(:,2);
for mango = 1:N
    WeightsVect = rand([elements,1]);
    NewVect = LowerVect + WeightsVect.*(UpperVect-LowerVect);
    ChildrenVect(:,mango) = NewVect;
end
end
    