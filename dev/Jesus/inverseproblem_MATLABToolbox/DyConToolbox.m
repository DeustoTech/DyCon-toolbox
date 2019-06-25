clear

%% Specify PDE Coefficients
% primal
dynamics = createpde(1);
g = GeoInvProblem;

importGeometry(dynamics,'DyCon.stl');

%geometryFromEdges(dynamics,g);
specifyCoefficients(dynamics,'m',0,'d',1,'c',1,'a',0,'f',0);
%applyBoundaryCondition(dynamics,'Edge',(1:4),'r',@bcd);
generateMesh(dynamics);
% adjoint
% adjoint = createpde(1);
% g = GeoInvProblem;
% geometryFromEdges(adjoint,g);
% specifyCoefficients(adjoint,'m',0,'d',1,'c',1,'a',0,'f',@(loc,state) -AdvectionTerm(loc,state));
% applyBoundaryCondition(adjoint,'Edge',(1:4),'r',@bcd);
% generateMesh(adjoint,'Hmax',0.2);

all_points = (1:265);

%applyBoundaryCondition(dynamics,'dirichlet','Face',all_points,'r',@bcd);
applyBoundaryCondition(dynamics,'neumann','Face',all_points);


%% Init Condition

gauss = @(max,sigma,x,y) max*exp(-(x.^2 + y.^2).^2/sigma.^2 );

u0fun =  @(location) gauss(1   , 1  ,location.x + 37.7409   ,location.y +22.6864   )    + ...
                     gauss(10  , 0.001  ,location.x + 0.50   ,location.y         )    + ...
                     gauss(50  ,  0.001 ,location.x + 0.50   ,location.y + 0.5   )   ;
                 
 u0fun = @(location) 10*sin(20*pi*location.x).*sin(20*pi*location.y).*sin(20*pi*location.z)
setInitialConditions(dynamics,u0fun)
%% Obtain Final Condition

T = 0.5;
tspan = linspace(0,T,5);

%%

result = solvepde(dynamics,tspan);
u = result.NodalSolution;
%pdeplot3D(dynamics,'XYData',u(:,end),'ColorBar','off','Mesh','off');

newtspan = linspace(0,T,100);
newu  = interp1(tspan,u',newtspan);

figure('Unit','norm','Position',[0 0 1 1])

%%
gif('DyCon.gif')
for i = 1:1:100
pdeplot3D(dynamics,'ColormapData',newu(i,:),'Mesh','off','FaceAlpha',0.4);
view(50-50*(i/100),40+(50/100)*i)
lightangle(20,20)
caxis([0 5])
pause(0.001)
gif
end



uT = u(:,end);
%%

u0 = uT*0;
%
setInitialConditions(dynamics,u0')
dresult = solvepde(dynamics,tspan);
ui = dresult.NodalSolution;


setInitialConditions(adjoint.ui(end,:)-uT)
presult = solvepde(adjoint,tspan);

pi = presult.NodalSolution(end,:);





%%



function f = AdvectionTerm(location,state)
    % Now the particular functional form of f
    %vx = 30*cos(2*pi*location.x); vy = 20*sin(2*pi*location.y);
    vx = -(location.x.^2 + (location.y).^2)     +  ...
         (location.x.^2 + (location.y + 2).^2) +  ...
         ((location.x + 1).^2 + (location.y +1).^2);
    vy = vx;
    % vx = 1;
    % vy = 0;
    f = vx.*state.ux + vy.*state.uy;

end
function bcMatrix = bcd(self, location, state)
    T = 5;
    bcMatrix =0.1*sin(4*pi*state.time/T); % OK to vectorize
    bcMatrix = 5;
end
%%
% To play the movie 10 times, use the |movie(hf,M,10)| command.