function AniMDP(x0,Pi,M,R)
%ANIMDP Summary of this function goes here
%   Detailed explanation goes here

fig = figure('unit','norm','pos',[0 0 1 1]);
uip1 = uipanel('Parent',fig,'unit','norm','pos',[0 0.7 1 0.3]);
uip1 = M2plotdigraphs(M,uip1);
%
uip2 = uipanel('Parent',fig,'unit','norm','pos',[0 0.0 1 0.7]);

mainchain = digraph(M(:,:,1)*0);
axmain = axes('Parent',uip2);
options = {'MarkerSize',12,'LineWidth',2,'ArrowSize',12};

[n,~] = size(M(:,:,1));
mainplot = plot(mainchain,'Parent',axmain,options{:});
mainplot.NodeCData = zeros(n,1);
mainplot.YData = -1 + 0*mainplot.YData;
mainplot.NodeFontSize = 17;

caxis([-1 1])
hold on 
bar(1:n,R(1:n))

maxR = max(R(1:n));
ylim([-2 2+maxR])
yticks(mainplot.Parent,[-2:(4+maxR)/6:(2+maxR)])
[Ntm,~ ] = size(Pi);
xs = x0;


mainplot.NodeCData = xs;
[~ ,idxs] = max(xs);
l1 = line(idxs,-1,'Marker','.','MarkerSize',90);
l1.Parent.Children = flipud(l1.Parent.Children);
    
tt = title(axmain,'t = 0','FontSize',20);
for it = 1:Ntm
    [~ ,idxs] = max(xs);
    l1.XData = idxs;
    xs = M(:,:,Pi(it,idxs))'*xs;
    
    mainplot.NodeCData = +xs;
    pause(0.1)
    mainplot.NodeCData = -xs;
    pause(0.1)
    mainplot.NodeCData = +xs;
    pause(0.1)
    
    
    tt.String = "t = "+it;
    pause(1) 
    
end
end

