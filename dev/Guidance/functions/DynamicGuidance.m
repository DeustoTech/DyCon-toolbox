
function F = DynamicGuidance(State,Control,Ne,Nd)



[ue,ve,ud,vd] = state2coord(State,Ne,Nd);

%% fuerza de repulsion - driver - evader

dot_ve = - 0.45*ve;
for j=1:Nd
  dot_ve = dot_ve -f_de(sum((ud(:,j)-ue).^2,1)).*(ud(:,j)-ue)/2;
end

%% fuerza evader evader

Differences  = -ue' + reshape(ue,1,2,Ne);
Squares      = sum(Differences.^2,2);

Fee = Differences.*f_ee(Squares)/(Ne-1);
Fee_total =  reshape(sum(Fee,3),Ne,2)';
%%
dot_ve = dot_ve - Fee_total;

%% fuerza driver driver

dot_vd = -5*vd;
% 
for j=1:Nd
   dot_vd = dot_vd +f_dd(sum((ud(:,j)-ud).^2,1)).*(ud(:,j)-ud)/2;
end


F = [ve(:)',dot_ve(:)',vd(:)',dot_vd(:)' + Control(:)']';