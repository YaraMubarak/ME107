function RCDAF = GetRollCarDynamicsFunction(m,rw,rg,mus,muk,CD,CRF,IDK,TrackPosition_s,TrackSlope_s,TrackConcavity_s,TrackCurvature_s)
rhoa = 1.275;
ACS = .1*.0678 +2*.1188*.02;
RollingCorrectionTime = .1;
velreltol = .01;
RCDAF = @(t,x) RollCarDynamics(t,x);

    function xdot = RollCarDynamics(t,x)
    slipping = false;
        
    s = x(1);
    sdot = x(2);
    theta = x(3);
    thetadot = x(4);

    phi = atan(TrackSlope_s(s));
    k = TrackCurvature_s(s);
    
    vp = sdot - thetadot*rw;
    if abs(vp) > velreltol*max(abs([sdot,thetadot*rw]))
        slipping = true;
    end

    
    %fprintf('t = %.3f vp = %.6f \n',t,vp)

    Fr = GetStuff();

    Fr_et = Fr(1);
    Fr_en = Fr(2);
    
    % fundamental equations for without slip
    xdot = zeros(4,1);
    xdot(1) = x(2);
    xdot(2) = Fr_et/(m*(1+rg^2/rw^2));
    xdot(3) = xdot(1)/rw;
    xdot(4) = xdot(2)/rw;

    Fn = m*k*x(2)^2 - Fr_en;
    Ff = m*xdot(2) - Fr_et;
  
    % fprintf('Ff: %f \t Fn: %f \t Fr_et: %f \t Fr_en: %f \t sdot: %f \t sddot: %f \t thetadot: %f \t thetaddot: %f \n',Ff,Fn,Fr_et,Fr_en,sdot,xdot(2),thetadot,xdot(4))
    
    StaticMax = abs(mus*Fn); % based on en switching direction can have negative Fn!
    if abs(Ff) > StaticMax
        slipping = true;
    end
    
    if slipping % fundamental equations for case with slip
        %fprintf('t = %.3f Help I am slipping! \n',t)
        Ff = -abs(muk*Fn)*MyDefinedsgn(vp);
        xdot(2) = (Fr_et + Ff)/m;
        xdot(3) = x(4);
        xdot(4) = -Ff*rw/(m*rg^2);
    else
        % Added Numerical Viscosity
        correction = vp/RollingCorrectionTime;
        xdot(2) = xdot(2) - correction/m;
        xdot(4) = xdot(4) + correction*rw/(m*rg^2);
        % fprintf('Ff: %f \t Fn: %f \t Fr_et: %f \t Fr_en: %f \t sdot: %f \t sddot: %f \t thetadot: %f \t thetaddot: %f \n',Ff,Fn,Fr_et,Fr_en,sdot,xdot(2),thetadot,xdot(4))
    end
    
    % to be removed checks wether energy conserved
%     KineticEnergy = .5*m*sdot^2 + .5*m*rg^2*thetadot^2;
%     PotentialEnergy = m*9.81*TrackPosition_s(s);
%     TotalEnergy = KineticEnergy + PotentialEnergy;
    % fprintf('t: %f \t KE: %d \t PE: %d \t TE: %d \n',t,KineticEnergy,PotentialEnergy,TotalEnergy);
    
        function Fr = GetStuff()
            Faero = .5*ACS*rhoa*sdot^2*[-MyDefinedsgn(sdot)*CD,0];
            et = [1;TrackSlope_s(s)]/sqrt(1+TrackSlope_s(s)^2);
            en = MyDefinedsgn(TrackConcavity_s(s))*[-TrackSlope_s(s);1]/sqrt(1+TrackSlope_s(s)^2);
            Fg_et = dot([0,-1],et);
            Fg_en = dot([0,-1],en);
            Fg = 9.81*m*[Fg_et,Fg_en];
            Fr = Fg + Faero;
            FnGetStuff = abs(m*k*x(2)^2 - Fr(2));
            FIDK = -MyDefinedsgn(sdot)*[IDK + CRF*FnGetStuff,0];
            Fr = Fr + FIDK;
        end % GetStuff
    end % RollCarDynamics
end % GetRollCarDynamicsFunction