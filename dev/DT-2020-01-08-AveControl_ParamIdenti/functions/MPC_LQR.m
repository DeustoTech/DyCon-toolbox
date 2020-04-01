function  a = MPC_LQR(t,s,params,T,N)
%MPC_LQR Summary of this function goes here
%   Detailed explanation goes here

    persistent afun times
    
    if isempty(afun)
        times = 0;
        afun = point2LQR(@cartpole_dynamics,params,s,0);
    else
        if t < times*(T/N)
            times = times - 1;
            afun = point2LQR(@cartpole_dynamics,params,s,0);
        elseif t >= (times+1)*(T/N)
            times = times + 1;
            afun = point2LQR(@cartpole_dynamics,params,s,0);
        end
    end
    
    a = afun(t,s);
end

