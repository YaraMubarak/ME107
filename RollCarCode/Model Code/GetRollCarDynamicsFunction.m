function RCDAF = GetRollCarDynamicsFunction(m,rw,rg,mus,muk,CD,CL,TrackPosition_s,TrackSlope_s,TrackCurvature_s)
rhoa = 1.275;
ACS = .1*.0678 +2*.1188*.02;
RCDAF = @(t,x) RollCarDynamics(t,x);

    function xdot = RollCarDynamics(t,x)
    s = x(1);
    sdot = x(2);
    theta = x(3);
    thetadot = x(4);

    phi = atan(TrackSlope_s(s));
    k = TrackCurvature_s(s);

    Fr = GetStuff();

    Fr_et = Fr(1);
    Fr_en = Fr(2);
    
    % fundamental equations for without slip
    xdot = zeros(4,1);
    xdot(1) = x(2);
    xdot(2) = Fr_et/(m*(1+rg^2/rw^2));
    xdot(3) = x(4);
    xdot(4) = xdot(2)/rw;

    Fn = m*k*x(2)^2 - Fr_en;
    Ff = m*xdot(2) - Fr_et;
  
    % fprintf('Ff: %f \t Fn: %f \t Fr_et: %f \t Fr_en: %f \t sdot: %f \t sddot: %f \t thetadot: %f \t thetaddot: %f \n',Ff,Fn,Fr_et,Fr_en,sdot,xdot(2),thetadot,xdot(4))
    
    StaticMax = mus*Fn;
    if abs(Ff) <= StaticMax
        edit = 'nothing'; % better way to do non event?
    else % fundamental equations for case with slip
        % fprintf('Help I am slipping! \n')
        Ff = -muk*Fn*sign(rw*thetadot-sdot);
        xdot(2) = (Fr_et + Ff)/m;
        xdot(4) = Ff*rw/(m*rg^2);
        % fprintf('Ff: %f \t Fn: %f \t Fr_et: %f \t Fr_en: %f \t sdot: %f \t sddot: %f \t thetadot: %f \t thetaddot: %f \n',Ff,Fn,Fr_et,Fr_en,sdot,xdot(2),thetadot,xdot(4))
    end
    
    % to be removed checks wether energy conserved
    KineticEnergy = .5*m*sdot^2 + .5*m*rg^2*thetadot^2;
    PotentialEnergy = m*9.81*TrackPosition_s(s);
    TotalEnergy = KineticEnergy + PotentialEnergy;
    % fprintf('t: %f \t KE: %d \t PE: %d \t TE: %d \n',t,KineticEnergy,PotentialEnergy,TotalEnergy);
    
        function Fr = GetStuff()
            Faero = .5*ACS*rhoa*sdot^2*[-sign(sdot)*CD,CL];     
            Fg = -9.81*m*[sin(phi),cos(phi)];
            Fr = Fg + Faero;
        end % GetStuff
    end % RollCarDynamics
end % GetRollCarDynamicsFunction