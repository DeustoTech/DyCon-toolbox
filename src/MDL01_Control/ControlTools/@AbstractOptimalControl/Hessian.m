function H = Hessian(iCP,YU,Lambda)
idyn  = iCP.Dynamics;
% Get Dimension
Ydim = idyn.StateDimension;   Udim = idyn.ControlDimension;   Nt = idyn.Nt;
% reshape State
YU = reshape(YU,Nt,Ydim+Udim);
Y = YU(:,1:Ydim);
U = YU(:,1+Ydim:end);
%

tspan = idyn.tspan;
dt    = idyn.dt;
iFun  = iCP.Functional;


%% Get First and Second Derivatives

d2L_dU2   = iFun.LagrangeDerivatives.ControlControl.Num;
d2L_dY2   = iFun.LagrangeDerivatives.StateState.Num;
d2L_dUdY  = iFun.LagrangeDerivatives.StateControl.Num;
d2Psi_dY2 = iFun.TerminalCostDerivatives.StateState.Num;
%
Diffs = idyn.Derivatives;
d2F_dU2  = Diffs.ControlControl.Num;
d2F_dY2  = Diffs.StateState.Num;
d2F_dUdY = Diffs.StateControl.Num;

%% Init

%% Hessian of Cost - Lagrange Term
HessCost = zeros(Nt*(Ydim+Udim),Nt*(Ydim+Udim));

for i = 1:Nt-1
   d2L_dY2_num  = d2L_dY2(tspan(i),Y(i,:).',U(i,:).');
   d2L_dUdY_num = d2L_dUdY(tspan(i),Y(i,:).',U(i,:).');
   d2L_dU2_num  = d2L_dU2(tspan(i),Y(i,:).',U(i,:).');

   for j1 = 1:Ydim
       for j2 = 1:Ydim
           nrow = (j1 -1)*Nt + i;
           ncol = (j2 -1)*Nt + i;
           HessCost(nrow,ncol) = dt*d2L_dY2_num(j2,j1); 
           HessCost(ncol,nrow) = dt*d2L_dY2_num(j2,j1); 
       end
       
       for j2 = 1:Udim
           nrow = (j1 -1)*Nt + i;
           ncol = (j2 -1)*Nt + i + Ydim*Nt;
           HessCost(nrow,ncol) = dt*d2L_dUdY_num(j1,j2); 
           HessCost(ncol,nrow) = dt*d2L_dUdY_num(j1,j2); 
       end
   end
   
   for j1 = 1:Udim
       for j2 = 1:Udim
           nrow = (j1 -1)*Nt + i + Ydim*Nt;
           ncol = (j2 -1)*Nt + i + Ydim*Nt;
           HessCost(nrow,ncol) = dt*d2L_dU2_num(j1,j2); 
           HessCost(ncol,nrow) = dt*d2L_dU2_num(j1,j2); 

       end
   end
end
%% Hessian of Cost - Terminal Term
d2Psi_dY2_num = d2Psi_dY2(tspan(end),Y(end,:).');
for j1 = 1:Ydim
   for j2 = 1:Ydim
       nrow = (j1)*Nt;
       ncol = (j2)*Nt;
       HessCost(nrow,ncol) = d2Psi_dY2_num(j1,j2); 
       HessCost(ncol,nrow) = d2Psi_dY2_num(j1,j2); 
   end
end
%% Hessian of Contraints Ceq

%%
theta = 1;
iter = 0;

HessCell = cell(1,Nt*Ydim);
for j1 = 1:Ydim 
   for i1 = 1:Nt
       
   %%
       iter = iter  + 1;
       if i1 == 1
           HessCell{iter} = sparse(Nt*(Ydim+Udim),Nt*(Ydim+Udim));   
           continue
       end
       HessCell{iter} = sparse(Nt*(Ydim+Udim),Nt*(Ydim+Udim));   
  
       % State
       d2F_dY2_num_1 = d2F_dY2(tspan(i1-1),Y(i1-1,:).',U(i1-1,:).');
       d2F_dY2_num_1 = reshape(d2F_dY2_num_1,Ydim,Ydim,Ydim);
       
       d2F_dY2_num_2 = d2F_dY2(tspan(i1),Y(i1,:).',U(i1,:).');
       d2F_dY2_num_2 = reshape(d2F_dY2_num_2,Ydim,Ydim,Ydim);
       % State-Control
       d2F_dYdU_num_1 = d2F_dUdY(tspan(i1-1),Y(i1-1,:).',U(i1-1,:).');
       d2F_dYdU_num_1 = reshape(d2F_dYdU_num_1,Ydim,Ydim,Udim);
       
       d2F_dYdU_num_2 = d2F_dUdY(tspan(i1),Y(i1,:).',U(i1,:).');
       d2F_dYdU_num_2 = reshape(d2F_dYdU_num_2,Ydim,Ydim,Udim);       
       % Control-Control
       d2F_dU_2num_1 = d2F_dU2(tspan(i1-1),Y(i1-1,:).',U(i1-1,:).');
       d2F_dU_2num_1 = reshape(d2F_dU_2num_1,Ydim,Udim,Udim);
       
       d2F_dU_2num_2 = d2F_dU2(tspan(i1),Y(i1,:).',U(i1,:).');
       d2F_dU_2num_2 = reshape(d2F_dU_2num_2,Ydim,Udim,Udim);     
   %%    
       for j2 = 1:Ydim
           %
           for j3 = 1:Ydim
               nrow = (j2-1)*Nt + i1;
               ncol = (j3-1)*Nt + i1;
               HessCell{iter}(nrow,ncol) = dt*theta*d2F_dY2_num_2(j1,j2,j3);
               HessCell{iter}(ncol,nrow) = dt*theta*d2F_dY2_num_2(j1,j2,j3);
               %
               nrow = (j2-1)*Nt + i1 - 1;
               ncol = (j3-1)*Nt + i1 - 1;               
               HessCell{iter}(nrow,ncol) = dt*(1-theta)*d2F_dY2_num_1(j1,j2,j3);
               HessCell{iter}(ncol,nrow) = dt*(1-theta)*d2F_dY2_num_1(j1,j2,j3);              
           end
           %
           for j3 = 1:Udim
               nrow = (j2-1)*Nt + i1 ;
               ncol = (j3-1)*Nt + i1 + Ydim*Nt;
               HessCell{iter}(nrow,ncol) = dt*theta*d2F_dYdU_num_2(j1,j2,j3);
               HessCell{iter}(ncol,nrow) = dt*theta*d2F_dYdU_num_2(j1,j2,j3);
               %
               nrow = (j2-1)*Nt + i1 - 1;
               ncol = (j3-1)*Nt + i1 - 1 + Ydim*Nt;               
               HessCell{iter}(nrow,ncol) = dt*(1-theta)*d2F_dYdU_num_1(j1,j2,j3);
               HessCell{iter}(ncol,nrow) = dt*(1-theta)*d2F_dYdU_num_1(j1,j2,j3);              
           end
       end
       
       for j2 = 1:Udim
           %
           for j3 = 1:Udim
               nrow = (j2-1)*Nt + i1 + Ydim*Nt;
               ncol = (j3-1)*Nt + i1 + Ydim*Nt;      
               HessCell{iter}(ncol,nrow) = dt*theta*(d2F_dU_2num_2(j1,j2,j3));
               HessCell{iter}(nrow,ncol) = dt*theta*(d2F_dU_2num_2(j1,j2,j3));
               %
               nrow = (j2-1)*Nt + i1 + Ydim*Nt - 1;
               ncol = (j3-1)*Nt + i1 + Ydim*Nt - 1;     
               HessCell{iter}(ncol,nrow) = dt*theta*(d2F_dU_2num_1(j1,j2,j3));
               HessCell{iter}(nrow,ncol) = dt*theta*(d2F_dU_2num_1(j1,j2,j3));               

           end
       end
   end
   
   
   
end

H = Lambda.eqnonlin(1)*HessCell{1};
for i = 2:Ydim*Nt
    H = H + Lambda.eqnonlin(i)*HessCell{i};
end

H = H + HessCost;

end

