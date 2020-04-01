function fig = M2plotdigraphs(M,parent)
%M2PLOTDIGRAPHS Summary of this function goes here
%   Detailed explanation goes here

if ~exist('parent')
   fig = gcf; 
else
   fig = parent;
end
[~ ,n,m] = size(M);         


YY = zeros(n,1);
XX = 1:n;
%
options = {'MarkerSize',8,'LineWidth',2,'ArrowSize',12,'XData',XX,'YData',YY};

izq_dg = digraph(M(:,:,1)); 
ax1 = subplot(1,3,1,'Parent',fig);
plot(izq_dg,options{:})
xticks(ax1,[])
yticks(ax1,[])

title('Control: $\leftarrow$','Interpreter','latex','FontSize',20)
%
der_dg = digraph(M(:,:,2)); 
ax2 = subplot(1,3,2,'Parent',fig);
plot(der_dg,options{:})
xticks(ax2,[])
yticks(ax2,[])

title('Control: $\rightarrow$','Interpreter','latex','FontSize',20)
%
nt_dg = digraph(M(:,:,3)); 
ax3 = subplot(1,3,3,'Parent',fig);
plot(nt_dg,options{:})
xticks(ax3,[])
yticks(ax2,[])

title('Control: $=$','Interpreter','latex','FontSize',20)
%%
end

