%% 
% We use DyCon Toolbox for solving numerically the following control 
% problem: given any $T>0$, find a control function $g\in L^2( ( -1 , 1) \times (0,T))$ 
% such that the corresponding solution to the parabolic problem
%%
% $$
% \begin{equation}\label{frac_heat}
%   \begin{cases}
%       z_t+(d_x^2)^s z = g\chi_\omega, & (x,t)\in(-1,1)\times(0,T) \\
%       z = 0, & (x,t)\in[\mathbb{R}\setminus(-1,1)]\times(0,T) \\
%       z(x,0) = z_0(x), & x\in(-1,1)
%   \end{cases}
% \end{equation} $$
%%
% satisfies $z(x,T)=0$.
%%
% Here, for all $s\in(0,1)$, $(-d_x^2)^s$ denotes the one-dimensional 
% fractional Laplace operator, defined as the following singular integral
%%
% $$
% \begin{equation*}
%   (-d_x^2)^s z(x) = c_s P.V. \int_{\mathbb{R}}
%   \frac{z(x)-z(y)}{|x-y|^{1+2s}}\,dy.
% \end{equation*} $$
%% Discretization of the problem
% As a first thing, we need to discretize \eqref{frac_heat}. 
% Hence, let us consider a uniform N-points mesh on the interval $(-1,1)$.
N = 100;
xi = -1; xf = 1;
xline = linspace(xi,xf,N+2);
xline = xline(2:end-1);
%%
% Out of that, we can construct the FE approxiamtion of the fractional
% Lapalcian, using the program FEFractionalLaplacian developped by our
% team, which implements the methodology described in [1].
s = 0.8;
A = -FEFractionalLaplacian(s,1,N);
M = MassMatrix(xline);
%%
% Moreover, we build the matrix $B$ defining the action of the control, by
% using the program "BInterior" (see below).
a = -0.3; b = 0.8;
B = BInterior(xline,a,b,'Mass',true);
%%
% We can then define a final time and an initial datum
FinalTime = 0.5;
Y0 =sin(pi*xline');
%%
% and construct the system
%%
% $$
% \begin{equation}\label{abstract_syst}
%   \begin{cases}
%       Y'(t) = AY(t)+BU(t), & t\in(0,T)
%       Y(0) = Y0.
%   \end{cases}
% \end{equation}
% $$

dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'Nt',100);
dynamics.mesh = {xline};
dynamics.MassMatrix = M;
%%
Y0 =cos(pi*xline');
Y0(xline > 0.2) = 0;
Y0(xline < -0.2) = 0;
dynamics.InitialCondition = Y0;
solve(dynamics);
%%

ssline = linspace(0.01,0.99,14);




iter = 0;
for s = ssline
    iter = iter + 1;
    A = -FEFractionalLaplacian(s,1,N);
    dynamics.A = A;
    [tspan,Ysolution] = solve(dynamics);
    Data(iter).Y = Ysolution;
end

%%
fig = animation_FLD(ssline,Data,xline)
saveas(fig,'Barchart2.png')

%% References
% 
% [1] U. Biccari and V. Hern\'andez-Santamar\'ia - \textit{Controllability 
%     of a one-dimensional fractional heat equation: theoretical and 
%     numerical aspects}, IMA J. Math. Control. Inf., to appear 
function fig = animation_FLD(ssline,Data,xline)
%% Graphs 


FontSize = 20;
FontSizeaxis = 15;
N = length(xline)
Nt = length(Data(1).Y(:,1));
fig = figure('unit','norm','Color',[0 0 0]);
ax  = axes('Parent',fig,'Color',[0 0 0]);
ax.XColor = 'w';
ax.YColor = 'w';
ax.ZColor = 'w';
ax.YAxis.FontSize = FontSizeaxis;
ax.XAxis.FontSize = FontSizeaxis;
view(ax,31,28)
iter = 0;
zlim([0 1])
%xlabel(ax,'s-fractional order')
%ylabel(ax,'space')
ax.ZAxis.Visible = 'off';
yticks(ax,[])
xticks(ax,[0 0.2 0.4 0.6 0.8 1])
Nss = length(ssline);

Color = jet(Nss);

%text = annotation('textbox',[0.3  0.72 0.6 0.1],'String','Fractional Calculus','Color','k','interp','latex','FontSize',FontSize,'LineStyle','none');
text = annotation('textbox',[0.32 0.66 0.3 0.1],'String','$u_t  + (-\Delta)^s u = 0$','Color','k','interp','latex','FontSize',FontSize,'LineStyle','none');
for s = ssline
    iter = iter + 1;
    lines(iter) = line(s*ones(1,N),xline,Data(iter).Y(1,:),'Parent',ax,'Color',Color(iter,:),'LineWidth',2);
end


%%
    it = 60;
    iter = 0;
    for s = ssline
        iter = iter + 1;
        lines(iter).ZData = Data(iter).Y(it,:);
    end


end



