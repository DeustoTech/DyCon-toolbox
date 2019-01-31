% Quiero Resolver 

A = [-1 0 ;0 -1]; 
B = [1 0 ;0 1];
VectorState = sym('y',[2 1]);
Control     = sym('u',[2 1]);

DynamicEq = A*VectorState + B*Control;

%%
iODE = ode(DynamicEq,VectorState,Control);
iODE.Type = 'InitialCondition';
iODE.Condition = [ 1 1]';

solve(iODE)
plot(iODE)

%%
iODE = ode(DynamicEq,VectorState,Control);
iODE.Type = 'FinalCondition';
iODE.Condition = [ 1 1]';

solve(iODE)
plot(iODE)
