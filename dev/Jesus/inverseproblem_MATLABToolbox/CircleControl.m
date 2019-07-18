function circle

%% Specify PDE Coefficients
% primal
[dynamics,mesh] = DynamicsInvProblem;
specifyCoefficients(dynamics,'m',0,'d',1,'c',1  , 'a',0,'f',0,'Face',1);
specifyCoefficients(dynamics,'m',0,'d',1,'c',1 , 'a',0,'f',0,'Face',2);
[adjoint,mesh]  = DynamicsInvProblem;
specifyCoefficients(adjoint,'m',0,'d',1,'c',1  , 'a',0,'f',0,'Face',1);
specifyCoefficients(adjoint,'m',0,'d',1,'c',1 , 'a',0,'f',0,'Face',2);
setInitialConditions(adjoint,1);


figure
subplot(1,2,1)
pdemesh(dynamics)
subplot(1,2,2)
pdegplot(dynamics,'facelabel','on')


Nodes = dynamics.Mesh.Nodes';
%% Obtain Final Condition

%% Generate Target 
alpha = 1;
TargetFcn = @(x,y) 4*exp(-((x-0).^2 + (y+1).^2)/alpha^2);
%TargetFcn = @(x,y) sin(2*pi/alpha.*x.*y);

YTarget = TargetFcn(Nodes(:,1),Nodes(:,2));
%%
T = 0.5;
tspan = linspace(0,T,7);


%% Control

UControl.ListOfIndexs   = findNodes(mesh,'region','Face',2);
UControl.XYData         = dynamics.Mesh.Nodes(:,UControl.ListOfIndexs)';
UControl.Data           = zeros(length(tspan),length(UControl.ListOfIndexs));
UControl.tspan          = tspan;

reptspan = repmat(tspan,length(UControl.XYData(:,1)),1);
reptspan = reptspan(:);

repspace = repmat(UControl.XYData,length(tspan),1);

UControl.XYtData        = [repspace reptspan UControl.Data(:)];
UControl.fcn            =  scatteredInterpolant(UControl.XYtData(:,1),UControl.XYtData(:,2),UControl.XYtData(:,3),UControl.XYtData(:,4),'nearest');



%delete(dynamics.EquationCoefficients.CoefficientAssignments)

[Distance2Target,state] = Control2Value(UControl);

gradientU = dynamics2gradient(state);
LengthStep = 0.01;


subplot(1,2,1)
pdeplot(dynamics,'XYData',YTarget,'Zdata',YTarget)
view(0,90); caxis([-0.5 4])

subplot(1,2,2)
for iter = 1:500
    % solve direct dynamics
    newUControl = UControl;
    
    newUControl.Data = UControl.Data - LengthStep*gradientU';
    [newDistance2Target,newstate] = Control2Value(newUControl);

    while newDistance2Target > Distance2Target
        LengthStep = 0.5*LengthStep;
        newUControl.Data = UControl.Data - LengthStep*gradientU';
        [newDistance2Target,newstate] = Control2Value(newUControl);
    end
    if LengthStep < 5
        LengthStep      = 2*LengthStep;
    end
    Distance2Target = newDistance2Target;
    state           = newstate;
    UControl        = newUControl;
    gradientU       = dynamics2gradient(state);

    newDistance2Target
    LengthStep
    pdeplot(dynamics,'XYData',state(:,end),'Zdata',state(:,end))
    view(0,90); caxis([-0.5 4])
    pause(0.1)
end

function [Distance2Target,uu] = Control2Value(UControl)

    UControl.XYtData        = [repspace reptspan UControl.Data(:)];
    UControl.fcn            =  scatteredInterpolant(UControl.XYtData(:,1),UControl.XYtData(:,2),UControl.XYtData(:,3),UControl.XYtData(:,4),'linear');

    delete(dynamics.EquationCoefficients.CoefficientAssignments)

    specifyCoefficients(dynamics,'m',0,'d',1,'c',1  , 'a',0,'f',@(location,state)ControlSource(location,state,UControl),'Face',2);
    specifyCoefficients(dynamics,'m',0,'d',1,'c',1 , 'a',0,'f',0,'Face',1);
    
    resultt = solvepde(dynamics,tspan);
    uu = resultt.NodalSolution;
    Distance2Target = norm(abs(uu(:,end) - YTarget));

end

function animation(istate,Ucontrol)
    figure;
    newtspan = linspace(tspan(1),tspan(end),20);
    newstate = interp1(tspan,istate',newtspan)';

    for it = 1:length(newtspan)
    subplot(1,2,1)
    pdeplot(dynamics,'XYData',newstate(:,it),'Zdata',newstate(:,it))
    view(0,90);caxis([0 4])
    subplot(1,2,2)
    pdeplot(dynamics,'XYData',newstate(:,it),'Zdata',newstate(:,it))
    view(0,0);caxis([0 4]);zlim([-3 3])
    pause(0.1)
    end

end
function gradientU = dynamics2gradient(u)
    AdjointFinalCondition = u(:,end) - YTarget;
    InterpAdjoint = scatteredInterpolant(Nodes(:,1),Nodes(:,2),AdjointFinalCondition,'linear');
    u0fun = @(location) InterpAdjoint(location.x,location.y);

    delete(adjoint.InitialConditions.InitialConditionAssignments)
    setInitialConditions(adjoint,u0fun);

    resultAdjoint = solvepde(adjoint,tspan);

    p = resultAdjoint.NodalSolution;

    gradientU = p(UControl.ListOfIndexs,:);
    gradientU = fliplr(gradientU); 
end
%%
end
function results = ControlSource(location,state,UControl)
    %
    if  length(location.x) > 1
        state.time = repmat(state.time,1,length(location.x));
    end
    results = UControl.fcn(location.x,location.y,state.time);

end