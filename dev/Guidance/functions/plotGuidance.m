
function plotGuidance(ue,ud,Ut,Ne,Nd)


clf
xlim([-4 4])
ylim([-4 4])

for i=1:Ne
    line(ue(:,1,i),ue(:,2,i),'Color','b')
    line(ue(1,1,i),ue(1,2,i),'Marker','.','MarkerSize',15,'Color','b')
    line(ue(end,1,i),ue(end,2,i),'Marker','x','MarkerSize',7,'Color','b')
end
%
for i=1:Nd
    line(ud(:,1,i),ud(:,2,i),'Color','r')
    line(ud(1,1,i),ud(1,2,i),'Marker','.','MarkerSize',15,'Color','r')
    line(ud(end,1,i),ud(end,2,i),'Marker','x','MarkerSize',7,'Color','r')
end

line(Ut(1),Ut(2),'Marker','s','color','k')
daspect([1 1 1])

end