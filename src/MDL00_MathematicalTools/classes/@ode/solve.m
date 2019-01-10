function solve(ListOfODEs,varargin)
% description: Metodo de Es
% autor: JOroya
% MandatoryInputs:   
%  ListOfODEs: 
%    description: List of ODEs
%    class: ControlProblem
%    dimension: [1x1]

    for iode = ListOfODEs
    % each ODE
        p = inputParser;

        addRequired(p,'iode')
        %
        Udefault = iode.U;
        %
        addOptional(p,'U',Udefault)
        addOptional(p,'TimeInverse',false)

        parse(p,iode,varargin{:})

        U = p.Results.U;
        TimeInverse = p.Results.TimeInverse;
        %%
        if isempty(U)
           if isa(iode,'LinearODE')
                [nrow, ncol] = size(iode.B); 
                 U = zeros(length(iode.tline),ncol);
           else
                U = zeros(length(iode.tline),length(iode.symU));
           end
        end
        %% Comprobar que YT esta definido
        if TimeInverse && isempty(iode.YT)
            error('To solve in reverse in time, the property YT must be define.')
        end

        %%
        U_fun   = @(t)   interp1(iode.tline,U,t)';   
        % Creamos dY/dt (t,Y)  a partir de la funcion dY_dt_uDepen    
        dY_dt   = @(t,Y) double(iode.numF(t,Y,U_fun(t)));

        % Obtenemos Y = [y(t1) y(t2) ... ] 

        if ~TimeInverse
            [~,iode.Y] = ode45(dY_dt,iode.tline,iode.Y0);
        else
            [~,iode.Y] = ode45(-dY_dt,iode.tline,iode.YT);
            iode.Y = flipud(iode.Y);
        end

        iode.U = U;
    end
end

