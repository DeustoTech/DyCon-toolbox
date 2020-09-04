function plot_GD(state)

re = state(:,1:Ne);
ve = state(:,Ne+1:2*Ne);
%
rd = state(:,2*Ne+1:2*Ne+Nd);
vd = state(:,2*Ne+1+Nd:end);

plot()
end

