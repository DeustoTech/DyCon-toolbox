function solve(iode,varargin)
% description: Metodo de Es
% autor: JOroya
% MandatoryInputs:   
% iCP: 
%    name: Control Problem
%    description: 
%    class: ControlProblem
%    dimension: [1x1]
% OptionalInputs:
% U0:
%    name: Initial Control 
%    description: matrix 
%    class: double
%    dimension: [length(iCP.tline)]
%    default:   empty

    p = inputParser;
    
    addRequired(p,'iode')
    %
    u0_default = zeros(length(iode.tline),length(iode.symU));
    %
    addOptional(p,'U',u0_default)
    addOptional(p,'TimeInverse',false)

    parse(p,iode,varargin{:})
    
    U = p.Results.U;
    TimeInverse = p.Results.TimeInverse;
    %% Comprobar que YT esta definido
    if TimeInverse && isempty(iode.YT)
        error('To solve in reverse in time, the property YT must be define.')
    end
    
    %%
    U_fun   = @(t)   interp1(iode.tline,U,t);   
    % Creamos dY/dt (t,Y)  a partir de la funcion dY_dt_uDepen    
    dY_dt   = @(t,Y) double(iode.numF(t,Y,U_fun(t)));
    
    % Obtenemos Y = [y(t1) y(t2) ... ] 
    
    tinit = iode.tline(1);
    tend = iode.tline(end);
    if ~TimeInverse
        [~,iode.Y] = ode45(dY_dt,[tinit,tend],iode.Y0);
    else
        [~,iode.Y] = ode45(-dY_dt,[tinit,tend],iode.YT);
        iode.Y = flipud(iode.Y);
    end
end

