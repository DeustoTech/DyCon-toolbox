function U = UpdateControlWithConstraints(iconstraints,U)
%UPDATECONTROLWITHCONSTRAINTS changes U into a subset to fit it with constraints.
%   It does nothing when isempty(iCP.constraints).
    Umax        = iconstraints.Umax;
    Umin        = iconstraints.Umin;
    Projector  = iconstraints.Projector;

    if ~isempty(Umax)
       U(U>Umax) = Umax; 
    end
    if ~isempty(Umin)
       U(U<Umin) = Umin; 
    end
    if ~isempty(Projector)
       U = Projector(U);
    end
    
end

