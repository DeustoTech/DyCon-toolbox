function varargout = ConstraintDynamics(iCP,Y,U)
%CONTRAINTDYNAMICS Summary of this function goes here
%   Detailed explanation goes here
persistent Ydim Udim
if isempty(Ydim) 
    Ydim = iCP.Dynamics.StateDimension;
    Udim = iCP.Dynamics.ControlDimension;    
end

indextime = 1:iCP.Dynamics.Nt;
tspan     = iCP.Dynamics.tspan;
Nt        = iCP.Dynamics.Nt;
Params    = [iCP.Dynamics.Params.value];

Fnum = iCP.Dynamics.DynamicEquation.Num;

%F = arrayfun(@(it) Fnum(tspan(it),Y(it,:)',U(it,:)',Params),indextime,'UniformOutput',false);
F = zeros(iCP.Dynamics.Nt,Ydim);
for it = 1:Nt
    F(it,:) = Fnum(tspan(it),Y(it,:)',U(it,:)',Params);
end
%F = [F{:}].';


Nt  = iCP.Dynamics.Nt;
dt  = iCP.Dynamics.dt;

c = [];
ceq  = zeros(Nt -1,Ydim);
theta = 1;
for i = 1:Ydim
    ceq(:,i) = (- Y(2:Nt,i) + Y(1:Nt-1,i) + dt.*( (1-theta)*F(1:Nt-1,i) + theta*F(2:Nt,i) ));
end

%ceq = ceq(:);

ceq = [Y(1,:) - iCP.Dynamics.InitialCondition.';  ...
       ceq];


varargout{1} = c;
varargout{2} = ceq;

if nargout > 2
    varargout{3} = [];
    
    Funum = iCP.Dynamics.Derivatives.Control.Num;
    Fynum = iCP.Dynamics.Derivatives.State.Num;
    
    %% State 
    Jacob = zeros((Nt)*(Ydim+Udim),(Nt-1)*Ydim);
    
    for i = 1:Ydim
       for j = 2:Nt
          Fy1 = Fynum(tspan(j),Y(j,:).',U(j,:).',Params);
          %
          Fy2 = Fynum(tspan(j-1),Y(j-1,:).',U(j-1,:).',Params);
          
          for k = 1:Ydim
             irow = (k-1)*Nt + j;
             icol = (i-1)*Nt + j;
             
             Jacob(irow,icol) = -double(k==i) + dt*theta*Fy1(k,i) ;
             
             irow = (k-1)*Nt + j - 1;
             icol = (i-1)*Nt + j  ;            
             Jacob(irow,icol) =  double(k==i) + dt*(1-theta)*Fy2(k,i) ;

          end
       end
    end 
    %% State - Initial Datum
    for iter = 0:Ydim-1
        Jacob(iter*Nt+1,iter*Nt+1) = 1;
    end

    %% Control 
    for i = 1:Udim
       for j = 2:Nt
          Fu1 = Funum(tspan(j),Y(j,:).',U(j,:).',Params);
          Fu2 = Funum(tspan(j-1),Y(j-1,:).',U(j-1,:).',Params);
          for k = 1:Udim
             %
             irow = (k-1)*Nt + j + Nt*Ydim ;
             icol = (i-1)*Nt + j;
             
             Jacob(irow,icol) =  dt*(theta)*Fu1(k,i) ;
             %
             irow = (k-1)*Nt + j - 1  + Nt*Ydim ;
             icol = (i-1)*Nt + j;
             
             Jacob(irow,icol) =  dt*(1-theta)*Fu2(k,i) ;
             

          end
       end
    end     
    varargout{4} = sparse(Jacob);

end
end

