function SetIntegrator(idyn,method,varargin)
%CREATECASADIINTEGRATOR Summary of this function goes here
%   Detailed explanation goes here
    %%
    p = inputParser;
    addRequired(p,'idyn')
    addRequired(p,'method')
    addOptional(p,'TimeUniform',false)
    
    parse(p,idyn,method,varargin{:})
    %
    TimeUniform = p.Results.TimeUniform;
    %
    %% Get Vars
    F  = idyn.DynamicFcn;
    Nx = idyn.StateDimension;
    Nu = idyn.ControlDimension;
    tspan = idyn.tspan ;
    Nt = idyn.Nt;

    % Create Symbolical 
    State0  = idyn.State.sym; 
    Statetime   = casadi.SX.sym('Xt',Nx,Nt);
    Controltime = casadi.SX.sym('Ut',Nu,Nt);
    cl = class(idyn);
    %%
    M = idyn.MassMatrix;


    %% Set Integrator
    switch method
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'casadi' 
            Xs = idyn.State.sym;
            Us = idyn.Control.sym;
            ts = idyn.ts;
            dae = struct('x',Xs,'p',Us,'ode',idyn.DynamicFcn(ts,Xs,Us));
            
           opts = struct('tf',tspan(end)/Nt);

            F = casadi.integrator('F', 'idas', dae,opts);
            
            Integrator = @(State0,ControlTime)  InitAndControl2Sol(F,State0,ControlTime);
 
        case 'Euler'
        %%
            Statetime(:,1) = State0;
            for it = 2:Nt
                 dt = tspan(it) - tspan(it-1);
                 Statetime(:,it) = Statetime(:,it-1) + dt*(M\F(tspan(it-1),Statetime(:,it-1),Controltime(:,it-1)));
            end
            Integrator = casadi.Function('Ft',{State0,Controltime},{Statetime});
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'RK4'
        %%    
            Statetime(:,1) = State0;
            for it = 2:Nt
                dt = tspan(it) - tspan(it-1);
                k1 = F(tspan(it-1),Statetime(:,it-1),Controltime(:,it-1)  );
                k2 = F(tspan(it-1) + 0.5*dt, Statetime(:,it-1)+ 0.5*k1*dt  , 0.5*Controltime(:,it-1) + 0.5*Controltime(:,it));
                k3 = F(tspan(it-1) + 0.5*dt, Statetime(:,it-1)+ 0.5*k2*dt  , 0.5*Controltime(:,it-1) + 0.5*Controltime(:,it));
                k4 = F(tspan(it-1) + 1.0*dt, Statetime(:,it-1)+ 1.0*k3*dt  , 1.0*Controltime(:,it));
                Statetime(:,it) = Statetime(:,it-1) + (1/6)*dt*(M\(k1+k2+k3+k4));
            end
            %
            Integrator = casadi.Function('Ft',{State0,Controltime},{Statetime});
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'RK8'
            Statetime(:,1) = State0;

            for it = 2:Nt
                dt = tspan(it) - tspan(it-1);
                Statetime(:,it) = RK8(F, tspan(it), Statetime(:,it-1), dt,Controltime(:,it-1),Controltime(:,it) );
            end
            %
            Integrator = casadi.Function('Ft',{State0,Controltime},{Statetime});            
        case 'LinearBackwardEuler'
            mustBeMember(cl,{'linearode','linearpde1d'})
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5555%%
            if TimeUniform
                N = idyn.StateDimension;
                MA = M\idyn.A;
                MB = M\idyn.B;
                %
                dt = tspan(2) - tspan(1);
                %
                idyn.C = speye(N,N)-dt*(MA);
                idyn.D = idyn.C\(dt*(MB));

                Statetime(:,1) = State0;

                for it = 2:Nt
                    Statetime(:,it) = idyn.C\Statetime(:,it-1) +  idyn.D*Controltime(:,it-1);
                end
                Integrator = casadi.Function('Ft',{State0,Controltime},{Statetime});
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5555%%
            else
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5555%%

                N = idyn.StateDimension;
                MA = M\idyn.A;
                MB = M\idyn.B;
                Statetime(:,1) = State0;

                for it = 2:Nt
                    dt = tspan(it) - tspan(it-1);
                    %
                    idyn.C = speye(N,N)-dt*(MA);

                    idyn.D = idyn.C\(dt*(MB));

                    Statetime(:,it) = idyn.C\Statetime(:,it-1) +  idyn.D*Controltime(:,it-1);
                end
                Integrator = casadi.Function('Ft',{State0,Controltime},{Statetime});
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'SemiLinearBackwardEuler'
            mustBeMember(cl,{'semilinearpde1d','semilinearpde2d'})

            NLT = idyn.NonLinearTerm;%
            Ys  = idyn.State.sym;
            
            
            gpre = casadi.Function('g',{Ys},{NLT(Ys(1))./Ys(1)});
            ValueInZero = gpre(1e-7);

            g = casadi.Function('g',{Ys},{ (Ys~=0).*gpre(Ys+1e-7) + (Ys==0).*ValueInZero});

            A = idyn.A;
            B = idyn.B;
            %
            Statetime(:,1) = State0;
            for it = 2:Nt
                dt = idyn.tspan(it) - idyn.tspan(it-1);
                C  = diag(1-dt*g(Statetime(:,it-1))) - dt*A;
                yu = Statetime(:,it-1)  + B*Controltime(:,it-1);
                Statetime(:,it) = C\yu;
            end
            Integrator = casadi.Function('Ft',{State0,Controltime},{Statetime});  
        %% 
        case 'OperatorSplitting'
            mustBeMember(cl,{'semilinearpde1d','semilinearpde2d'})

            N = idyn.StateDimension;

            Statetime(:,1) = State0;

            for it = 2:Nt
                %
                NLT = idyn.NonLinearTerm;
                %
                dt = tspan(it) - tspan(it-1);
                % compute matrices
                idyn.C = speye(N,N)-(0.5*dt)*(M\idyn.A);
                idyn.D = idyn.C\((0.5*dt)*(M\idyn.B));
                %
                % Lineal Part
                State = idyn.C\Statetime(:,it-1) +  idyn.D*Controltime(:,it-1);
                % no lineal Part
                Control = 0.5*Controltime(:,it-1) + 0.5*Controltime(:,it);
                t  = 0.5*tspan(it-1) + 0.5*tspan(it);
                Statetime(:,it) = State + 0.5*dt*(M\NLT(t,State,Control));
            end
            Integrator = casadi.Function('Ft',{State0,Controltime},{Statetime});
            
    end
    %%
    idyn.method = method;
    idyn.solver = Integrator;
    idyn.HasSolver = true;
    
    function sol = InitAndControl2Sol(F,InitialCondition,Control)
        
        sol = casadi.DM(Nx,Nt);
        
        sol(:,1) = InitialCondition;
        for its = 2:Nt
            solution =  F('x0',sol(:,its-1),'p',Control(:,its-1));
            sol(:,its) = solution.xf;
        end
    end
end



