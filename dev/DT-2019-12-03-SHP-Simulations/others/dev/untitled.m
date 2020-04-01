Nt = 200;
tspan = 1:Nt;
Nq = 15;
qspan = 1:Nq;

%%
Ptq = @(t,q) min(1,0.8*Window(t,30*1,30*2)   *  (floor(q/3)==q/3) + ...
             0.2*Window(t,30*0,30*3)   *  (floor(q/4)==q/4) + ...
             0.4*Window(t,30*4,30*6)   *  (floor(q/5)==q/5) + ...
             0.5*Window(t,30*4,30*6)   *  (floor(q/2)==q/2)) ;

%%
close all
fig = figure('unit','norm','pos',[0 0.1 1 0.3]);
ax  = axes('Parent',fig);
hold(ax,'on')
[tms,qms] = meshgrid(tspan,qspan);
Color = jet(Nq);
for iq = 1:Nq
    Ptqspan = Ptq(tspan,iq);
    options = {'o:','Parent',ax,'Color',Color(iq,:),'MarkerFaceColor','y'};
    stem3(iq+0*tspan,tspan,Ptqspan','filled',options{:})
end
xlabel('queue')
ylabel('time')
zlabel('Probability')
view(-10,50)
grid on
%%
iuser = user(Ptq);
%%

epoch = 100;

traj_opinion = zeros(Nt,epoch);

for it = 1:Nt
    
    traj_opinion(it,1) = opinion(iuser,it,5);
end
    

%%