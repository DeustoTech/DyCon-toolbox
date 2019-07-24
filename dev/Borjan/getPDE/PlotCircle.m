fid=fopen('values.txt');
C = textscan(fid, '%s');
C = C{:};
values = arrayfun(@(C) str2num(C{:}),C,'UniformOutput',true);
%%
fid=fopen('points.txt');
C = textscan(fid, '%s');
C = C{:};
nodes = arrayfun(@(C) str2num(C{:}),C,'UniformOutput',true);
%%
fid=fopen('spike_elements.txt');
C = textscan(fid, '%s');
C = C{:};
elemets = arrayfun(@(C) str2num(C{:}),C,'UniformOutput',true);
elemets = reshape(elemets,3,length(elemets)/3)';
%%
nodes = reshape(nodes,2,1288)';

%%
%%
clf
ip = patch(nodes(:,1),nodes(:,2),values,values,'LineStyle','none');
ip.Faces = elemets + 1;

%%
clf
ip = plot3(nodes(:,1),nodes(:,2),values,'LineStyle','none','Marker','o');
