
function aniGuidance(ue,ud,Ut,Ne,Nd,Nt)


clf
xlim([-6 6])
ylim([-6 6])

for i=1:Ne
    line(ue(:,1,i),ue(:,2,i),'Color',[0.5 0.5 1])
    pe(i) = line(ue(1,1,i),ue(1,2,i),'Marker','.','MarkerSize',15,'Color','b');
end
%
for i=1:Nd
    line(ud(:,1 ,i),ud(:,2,i),'Color',[1 0.5 0.5])
    pd(i) =line(ud(1,1,i),ud(1,2,i),'Marker','.','MarkerSize',15,'Color','r');
end

line(Ut(1),Ut(2),'Marker','s','color','k')

daspect([1 1 1])
for i=1:Nt
    for j=1:Ne
        pe(j).XData = ue(i,1,j);
        pe(j).YData = ue(i,2,j);
    end
    for j=1:Nd
        pd(j).XData = ud(i,1,j);
        pd(j).YData = ud(i,2,j);
    end
    pause(0.1)
end

end