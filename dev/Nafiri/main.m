

mode = 1;
dt = 0.9;
FinalTime = 500;
Nx = 100;
Gamma = 0.1;

[u,v,theta,Et] = p1energyfem1(FinalTime,dt,Nx,mode,Gamma);
%[u,v,theta,Et] = p1energyfdm1(FinalTime,dt,Nx,mode,Gamma);
%[u,v,theta,Et] = data_effect_exp(FinalTime,dt,Nx,mode,Gamma);

AniThermalDisplacement(u,theta,Et,v)