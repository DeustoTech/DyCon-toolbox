function U = UpdateControlWithConstraints(iCP,U)
%UPDATECONTROLWITHCONSTRAINTS Summary of this function goes here
%   Detailed explanation goes here
    Umax = iCP.constraints.Umax;
    Umin = iCP.constraints.Umin;

    if ~isempty(Umax)
       U(U>Umax) = Umax; 
    end
    if ~isempty(Umin)
       U(U<Umin) = Umin; 
    end
    
end

