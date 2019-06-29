function AMPLFileFixedFinalTime(iCP,name)
%CREATEAMPLFILE Summary of this function goes here
%   Detailed explanation goes here

idyn = iCP.Dynamics;
Ydim = idyn.StateDimension;
Udim = idyn.ControlDimension;
Nt   = idyn.Nt;
T    = idyn.FinalTime;
dt   = idyn.dt;

sep  = repmat('#',1,10);

fileID = fopen(name,'w');
fprintf(fileID,['param Ydim = ',num2str(Ydim),';',newline]);
fprintf(fileID,['param Udim = ',num2str(Udim),';',newline]);
fprintf(fileID,['param Nt   = ',num2str(Nt),';',newline]);
fprintf(fileID,['param T    = ',num2str(T),';',newline]);
fprintf(fileID,['param Y0 {1..Ydim};',newline]);
fprintf(fileID,['param dt    = ',num2str(dt),';',newline]);
%% vars
fprintf(fileID,['var Y {i in 1..Nt, j in 1..Ydim};',newline]);
fprintf(fileID,['var U {i in 1..Nt, j in 1..Udim};',newline]);
if iCP.Dynamics.lineal
    fprintf(fileID,['param A {1..Ydim,1..Ydim};',newline]);
    fprintf(fileID,['param M {1..Ydim,1..Ydim};',newline]);
    fprintf(fileID,['param B {1..Udim,1..Ydim};',newline]);

end
%
fprintf(fileID,[newline,sep,newline,newline]);
fprintf(fileID,['data;']);
fprintf(fileID,[newline,sep,newline,newline]);

if iCP.Dynamics.lineal
    A = iCP.Dynamics.A;
    str = ['param A: ',num2str(1:Ydim),':='];
    fprintf(fileID,[str,newline]);

    for i = 1:Ydim
        str = num2str(i);
        str = [str,'  ',num2str(A(i,:))];
        if i == Ydim
            fprintf(fileID,[str,';',newline]);
        else
            fprintf(fileID,[str,newline]);
        end
    end
    %%
    separation
    B = iCP.Dynamics.B;
    str = ['param B: ',num2str(1:Udim),':='];
    fprintf(fileID,[str,newline]);

    for i = 1:Ydim
        str = num2str(i);
        str = [str,'  ',num2str(B(i,:))];
        if i == Ydim
            fprintf(fileID,[str,';',newline]);
        else
            fprintf(fileID,[str,newline]);
        end
    end

    separation
    %%
    M = iCP.Dynamics.MassMatrix;
    str = ['param M: ',num2str(1:Ydim),':='];
    fprintf(fileID,[str,newline]);

    for i = 1:Ydim
        str = num2str(i);
        str = [str,'  ',num2str(M(i,:))];
        if i == Ydim
            fprintf(fileID,[str,';',newline]);
        else
            fprintf(fileID,[str,newline]);
        end
    end
end
fprintf(fileID,[newline,sep,newline,newline]);

%% Initial Condition
fprintf(fileID,['param Y0: ',num2str(1:Ydim),' := ',newline, ...
                 '1 ',num2str(iCP.Dynamics.InitialCondition.'),';',newline,newline]);

%% cost functional 
t = idyn.symt;
Y = idyn.StateVector.Symbolic;
U = idyn.Control.Symbolic;

%%
str = 'subject to InitialCondition {i in 1..Ydim}: Y[1,i] = Y0[i];';
fprintf(fileID,[newline,str,newline,newline]);

fprintf(fileID,[newline,sep,newline,newline]);

%%

Psi = iCP.Functional.TerminalCost.Num;
PsiChar = char(sym(Psi(t,Y)));

for i = Ydim:-1:1
   PsiChar = replace(PsiChar, char(Y(i)),['Y[Nt,',num2str(i),']']); 
end
%
L = iCP.Functional.Lagrange.Num;
LCharSym = char(sym(L(t,Y,U)));
LChar = ['dt*(sum{i in 1..Nt-1}'];
Lcharcal = [' (',LCharSym,'))'];

for i = Ydim:-1:1
   Lcharcal = replace(Lcharcal, char(Y(i)),['Y[i,',num2str(i),']']); 
end
for i = Udim:-1:1
   Lcharcal = replace(Lcharcal, char(U(i)),['U[i,',num2str(i),']']); 
end
%
LChar = [LChar,Lcharcal];
fprintf(fileID,['minimize cost:  ',PsiChar,' + ',LChar,';',newline]);

%%
fprintf(fileID,[newline,sep,newline,newline]);
%%
F  = idyn.DynamicEquation.Num;
F  = F(t,Y,U);

Ya = sym('State',[Ydim 1]);
Ua = sym('Control',[Udim 1]);
Fa  = idyn.DynamicEquation.Num;

Fa = Fa(t,Ya,Ua);

theta = 1;
if ~iCP.Dynamics.lineal

    for i = 1:Ydim
        str = ['subject to dynamics_',num2str(i),' {j in 2..Nt}:'];
        strcalculation =[    '  - Y[j-1,',num2str(i),'] + Y[j,',num2str(i),']', ...
                                            ' = ',num2str(theta),'*dt*(',char(F(i)),') + ',num2str(1-theta),'*dt*(',char(Fa(i)),');',newline];

        for j = Udim:-1:1
            strcalculation = replace(strcalculation,char(U(j)),['U[j,',num2str(j),']']);
        end
        for j = Ydim:-1:1
            strcalculation = replace(strcalculation,char(Y(j)),['Y[j,',num2str(j),']']);
        end
        
        for j = Udim:-1:1
            strcalculation = replace(strcalculation,char(Ua(j)),['U[j-1,',num2str(j),']']);
        end
        for j = Ydim:-1:1
            strcalculation = replace(strcalculation,char(Ya(j)),['Y[j-1,',num2str(j),']']);
        end
        
        fprintf(fileID,[str,strcalculation]);

    end

else

    separation

    %%
    fprintf(fileID,[str,newline,newline]);
    %%
    str = 'subject to dynamics {j in 1..Nt-1, i in 1..Ydim}:';
    fprintf(fileID,[str,newline]);

    str = ['sum {l in 1..Ydim} M[i,l]*Y[j+1,l]', ...
           ' =    sum {l in 1..Ydim} M[i,l]*Y[j,l] + ', ...
           '   dt*sum {l in 1..Ydim}(A[i,l]*Y[j,l] + ', ...
           '   B[i,l]*U[j,l]);'];
    fprintf(fileID,[str,newline,newline]);

end

separation
if ~isempty(iCP.Constraints.MaxControl)
        str = ['subject to maxControl {j in 1..Nt ,i in 1..Udim}: U[j,i] <=',num2str(iCP.Constraints.MaxControl),';'];
        fprintf(fileID,[str,newline]);
end
if ~isempty(iCP.Constraints.MinControl)
        str = ['subject to minControl {j in 1..Nt ,i in 1..Udim}: U[j,i] >=',num2str(iCP.Constraints.MinControl),';'];
        fprintf(fileID,[str,newline]);
end

separation

fprintf(fileID,['solve;',newline,newline]);

separation

print1var('cost')
print1var('T')
print1var('Ydim')
print1var('Udim')

str = ['printf: " # Variable - State - ',num2str(Nt),' - ',num2str(Ydim),'\\n";'];
fprintf(fileID,[str,newline]);

str = 'printf {j in 1..Nt, i in 1..Ydim}: " %%24.16e\\n", Y[j,i];';
fprintf(fileID,[str,newline]);
%%
str = ['printf: " # Variable - Control - ',num2str(Nt),' - ',num2str(Udim),'\\n";'];
fprintf(fileID,[str,newline]);

str = 'printf {j in 1..Nt, i in 1..Udim}: " %%24.16e\\n", U[j,i];';
fprintf(fileID,[str,newline]);

str = 'printf: " Variable";';
fprintf(fileID,[str,newline]);
%
str = 'printf: " EndAMPLExecution";';
fprintf(fileID,[str,newline]);

fclose(fileID);

    function separation
        sep  = repmat('#',1,10);
        fprintf(fileID,[newline]);
        fprintf(fileID,[sep,newline]);
        fprintf(fileID,[sep,newline]);
        fprintf(fileID,[newline]);

    end

    function print1var(string)
        str=['printf: " # Variable - ',string,' - 1 \\n";'];
        fprintf(fileID,[str,newline]);
        str=['printf: " %%d\\n", ',string,';'];
        fprintf(fileID,[str,newline]);
    end
end

