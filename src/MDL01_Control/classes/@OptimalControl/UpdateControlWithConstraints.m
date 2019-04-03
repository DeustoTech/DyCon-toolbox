function U = UpdateControlWithConstraints(iCP,U)
%UPDATECONTROLWITHCONSTRAINTS changes U into a subset to fit it with constraints.
%   It does nothing when isempty(iCP.constraints).
    Umax = iCP.constraints.Umax;
    Umin = iCP.constraints.Umin;
    Projection = iCP.constraints.Projection;

    if ~isempty(Umax)
       U(U>Umax) = Umax; 
    end
    if ~isempty(Umin)
       U(U<Umin) = Umin; 
    end
    if ~isempty(Projection)
       U = Projection(U);
    end
    
end

