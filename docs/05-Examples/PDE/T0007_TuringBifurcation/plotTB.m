function plotTB(St,Wt_tot,Ns,model,hOld)
%%

Nodes    = model.Mesh.Nodes;

%%
Ut =  Wt_tot(1:Ns,:);
Vt =  Wt_tot(Ns+1:end,:);
%
Ut_total = [sum(full(Ut))];
Vt_total = [sum(full(Vt))];
%
hmax = 0.01;
generateMesh(model,'Hmax',hmax,'GeometricOrder','linear','Hgrad',2);

fn_Nodes    = model.Mesh.Nodes;
fn_Elements = model.Mesh.Elements;
generateMesh(model,'Hmax',hOld,'GeometricOrder','linear','Hgrad',2);

clf
%%
subplot(2,3,4)
title('U','Color','w')
axis('off')
%ZData = full(Ut(:,1));
ZData = griddata(Nodes(1,:),Nodes(2,:), full(Ut(:,1)),fn_Nodes(1,:),fn_Nodes(2,:),'cubic')';
upacth = patch('Vertices',fn_Nodes','Faces',fn_Elements(1:3,:)','FaceVertexCData',ZData,'FaceColor','interp','LineStyle','none');
colorbar;colormap jet

caxis([-0.5 0.5])
%caxis([-5 5])

%%
subplot(2,3,5)
title('V','Color','w')
axis('off')
%ZData = full(Vt(:,1));
ZData = griddata(Nodes(1,:),Nodes(2,:), full(Vt(:,1)),fn_Nodes(1,:),fn_Nodes(2,:),'cubic')';
vpacth = patch('Vertices',fn_Nodes','Faces',fn_Elements(1:3,:)','FaceVertexCData',ZData,'FaceColor','interp','LineStyle','none');
colorbar;colormap jet
caxis([-0.5 0.5])
%caxis([-5 5])

%%
subplot(2,3,6)
title('W','Color','w')
axis('off')
%ZData = full(Vt(:,1));
ZData = griddata(Nodes(1,:),Nodes(2,:), full(St(:,1)),fn_Nodes(1,:),fn_Nodes(2,:),'cubic')';
cpacth = patch('Vertices',fn_Nodes','Faces',fn_Elements(1:3,:)','FaceVertexCData',ZData,'FaceColor','interp','LineStyle','none');
colorbar;colormap jet

minSt = min(min(full(St))) ;
maxSt = max(max(full(St))) ;

caSt = max([abs(minSt) abs(maxSt)]);
caxis([-caSt caSt])
%caxis([-5000 5000])

%%
%
upacth.Parent.Parent.Color = [0 0 0];
upacth.Parent.Color = [0 0 0];

%
subplot(2,1,1)
cla
plot(Ut_total,'b','LineWidth',2)
hold on 
plot(Vt_total,'r','LineWidth',2)
xlabel('time','Color','w')
grid on

iu = plot(1,Ut_total(1),'b.','MarkerSize',15,'LineWidth',8);
yticks([])
iv = plot(1,Vt_total(1),'r.','MarkerSize',15,'LineWidth',8);
xticks([])
iu.Parent.XAxis.Color = 'w';
iu.Parent.YAxis.Color = 'w';
iu.Parent.Color = [0 0 0];
legend({'U','V'},'Color','w')

for it=2:50:length(Ut_total)
    iu.XData = it;iu.YData = Ut_total(it);
    iv.XData = it;iv.YData = Vt_total(it);
    
    %%
    ZData = griddata(Nodes(1,:),Nodes(2,:), full(St(:,it)),fn_Nodes(1,:),fn_Nodes(2,:),'cubic')';
    cpacth.FaceVertexCData = ZData;
    %%
    ZData = griddata(Nodes(1,:),Nodes(2,:), full(Ut(:,it)),fn_Nodes(1,:),fn_Nodes(2,:),'cubic')';
    upacth.FaceVertexCData = ZData;
    %%
    ZData = griddata(Nodes(1,:),Nodes(2,:), full(Vt(:,it)),fn_Nodes(1,:),fn_Nodes(2,:),'cubic')';
    vpacth.FaceVertexCData = ZData;
    pause(0.001)
end


end

