function [time,state,control] = symvars(obj)
    state   = obj.State.sym;
    control = obj.Control.sym;
    time    = obj.ts;
end