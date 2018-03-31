function RCDAF = GetRollCarDynamicsFunction(m,rw,rg,mus,muk,CD,CL,TrackPosition_s,TrackSlope_s,TrackCurvature_s)
rhoa = 1.275;
ACS = .1*.1; % random at moment, will refine

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

    xdot = zeros(4,1);
    xdot(1) = x(2);
    xdot(2) = Fr_et/(m*(2-rg^2/rw^2));
    xdot(3) = x(4);
    xdot(4) = xdot(2)/rw;

    Fn = m*k*(x(2)^2 + rw*x(2)*x(4)) - Fr_en;
    Ff = xdot(2)*m*rg^2/rw^2;
    
    StaticMax = mus*Fn;
    fprintf('Ff: %f \t StaticMax: %f \n',Ff,StaticMax)
    
    KineticEnergy = .5*m*sdot^2 + .5*m*rg^2*thetadot^2;
    PotentialEnergy = m*9.81*TrackPosition_s(s);
    TotalEnergy = KineticEnergy + PotentialEnergy;
    fprintf('KE: %d \t PE: %d \t TE: %d \n',KineticEnergy,PotentialEnergy,TotalEnergy);
    
        function Fr = GetStuff()
            Faero = .5*ACS*rhoa*sdot^2*[-sign(sdot)*CD,CL];     
            Fg = 9.81*m*[-sin(phi),cos(phi)];
            Fr = Fg + Faero;
        end % GetStuff
    end % RollCarDynamics
end % GetRollCarDynamicsFunction