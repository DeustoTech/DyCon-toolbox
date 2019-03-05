function GradientMethod(IP)

    [N,~ ] = size(IP.dynamics.A);
    
    InitialCondition = zeros(N,1);
    clf
    plot(1:length(IP.FinalState),IP.FinalState,'r*-')
    for iter = 1:1000
        IP.dynamics.InitialCondition = InitialCondition;
        [~ , StateVector] =  solve(IP.dynamics);

        pause(0.1)
        IP.adjoint.dynamics.InitialCondition = IP.adjoint.FinalCondition(StateVector(end,:));
        
        line(1:length(StateVector(end,:)),1e6*StateVector(end,:))
        %line(1:length(StateVector(1,:)),StateVector(1,:))
        
        
        [~ , AdjointVector] = solve(IP.adjoint.dynamics);
        AdjointVector = flipud(AdjointVector);

        Gradient = AdjointVector(1,:);
        InitialCondition = InitialCondition - 1e3*Gradient';
        display(norm(1e3*Gradient)/norm(InitialCondition))
    end
    
    figure
    plot(IP.dynamics.StateVector.Numeric(end,:))
    hold on 
    plot(IP.FinalState)
end

