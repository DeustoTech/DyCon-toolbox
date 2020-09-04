%% Two drivers, Flexible time

clear all

% Parameters and the dynamics
Ne_sqrt =9; 
Ne      = Ne_sqrt^2;
Nd =2 ; 
%
Ut = target([5*(rand-0.5);5*(rand-0.5)]);

NormVec = @(u) u./NormArray(u);

CoUeVe = @(st,Ne) sqrt(norm(CoUe(st,Ne)*perp(NormVec(Uem(st,Ne) - Ut.r))));

%% FEEDBACK LAW 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CosAng   = @(st) CosArray(  (Ud(st,Nd) - Uem(st,Ne))  , ( Ut.r         - Uem(st,Ne))  );

SinAng   = @(st) SinArray(  (Ud(st,Nd) - Uem(st,Ne))  , ( Ut.r         - Uem(st,Ne))  );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CosAngVe = @(st) CosArray(  1e-3 + Vem(st,Ne)            , ( Ut.r         - Uem(st,Ne))  );
%
SinAngVe = @(st) SinArray( 1e-3 + Vem(st,Ne)             , ( Ut.r         - Uem(st,Ne))  );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CosVar = @(st) CosArray( EigVecPlus(CoUe(st,Ne))         , ( Ud(st,Nd) - Uem(st,Ne))  );
%
SinVar = @(st) SinArray( EigVecPlus(CoUe(st,Ne))         , ( Ud(st,Nd) - Uem(st,Ne))  );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CosUem   = @(st) CosArray(  (Ud(st,Nd) - Uem2(st,Ne,Nd))  , (  Uem(st,Ne)        - Uem2(st,Ne,Nd))  );

SinUem   = @(st) SinArray(  (Ud(st,Nd) - Uem2(st,Ne,Nd))  , ( Uem(st,Ne)         - Uem2(st,Ne,Nd))  );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CosUem3   = @(st) CosArray(  (Ud(st,Nd) - Uem3(st,Ut,Ne,Nd))  , (  Ut.r        - Uem3(st,Ut,Ne,Nd))  );

SinUem3   = @(st) SinArray(  (Ud(st,Nd) - Uem3(st,Ut,Ne,Nd))  , ( Ut.r         - Uem3(st,Ut,Ne,Nd))  );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% POLICY 1 - Conducir al Target
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fr = @(r,rmin) 5e-1*((rmin./(r+1e-3)).^2 - 1);

%% Conducir
Cent_1 = @(st)  fr( NormArray( Ud(st,Nd) - Uem(st,Ne)),  sqrt(2*norm(CoUe(st,Ne))) ) + 0.4*(norm(Vem(st,Ne)) - 2);
Perp_1 = @(st) (   2*SinAng(st).*(CosAng(st)+1)  - 0.15*SinAngVe(st) );

Pi_1 = @(st,dist)  Cent_1(st).*NormVec(     Ud(st,Nd) - Uem(st,Ne)  )     + ...
                   Perp_1(st).*NormVec(perp(Ud(st,Nd) - Uem(st,Ne)) );
      
%%  Recoger al centro
Cent_2 = @(st)  fr( NormArray( Ud(st,Nd) - Uem(st,Ne)),2 )    ;
Perp_2 = @(st) (   2*SinUem(st).*(CosUem(st)+1)  );

Pi_2 = @(st,dist)  Cent_2(st).*NormVec(     Ud(st,Nd) - Uem2(st,Ne,Nd)  )     + ...
                   Perp_2(st).*NormVec(perp(Ud(st,Nd) - Uem2(st,Ne,Nd)) );

%%  Recoger al Target
Cent_3 = @(st)  fr( NormArray( Ud(st,Nd) - Uem2(st,Ne,Nd)), 0 ) ;
Perp_3 = @(st) (   2*SinUem3(st).*(CosUem3(st)+1)  );

Pi_3 = @(st,dist)  Cent_3(st).*NormVec(     Ud(st,Nd) - Uem3(st,Ut,Ne,Nd)  )     + ...
                   Perp_3(st).*NormVec(perp(Ud(st,Nd) - Uem3(st,Ut,Ne,Nd)) );

%%  Espera - 
Cent_4 = @(st)  fr( NormArray( Ud(st,Nd) - Uem(st,Ne)), 2+sqrt(2*norm(CoUe(st,Ne))))       ;
Perp_4 = @(st)  0.25 +(   2*SinAng(st).*(CosAng(st)+1)   );

Pi_4 = @(st,dist)  Cent_4(st).*NormVec(     Ud(st,Nd) - Uem(st,Ne)  )    + ...
                   Perp_4(st).*NormVec(perp(Ud(st,Nd) - Uem(st,Ne)) );
%%

%%
Pi = @(st,omega) theta(+norm(Uem(st,Ne)-Ut.r)- 5 ).*theta(-sqrt(norm(CoUe(st,Ne)))+omega).*Pi_1(st,omega)   + ...
                 theta(+norm(Uem(st,Ne)-Ut.r)- 5 ).*theta(+sqrt(norm(CoUe(st,Ne)))-omega).*Pi_2(st,omega)   + ...
                 theta(-norm(Uem(st,Ne)-Ut.r)+ 5 ).*theta(+sqrt(norm(CoUe(st,Ne)))-omega).*Pi_3(st,omega)   + ...
                 theta(-norm(Uem(st,Ne)-Ut.r)+ 5 ).*theta(-sqrt(norm(CoUe(st,Ne)))+omega).*Pi_4(st,omega); 

Sat =   @(u)  sign(u).*min(abs(u),10);

Pi_f = @(st,omega) Pi(st,omega);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DYNAMIC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F = @(t,st,Pi_f,omega) DynamicGuidance(st,Pi_f(st,omega),Ne,Nd);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% symF_ftn is the vector field for the dynamics
%% Initial data 
st0 = IntialConditionGuidance(Ne,Nd);
%%
liveAnimation(F,Pi_f,st0,Ne,Nd,Ut)
%%
st_sym = casadi.SX.sym('st',[4*Nd + 4*Ne, 1])
