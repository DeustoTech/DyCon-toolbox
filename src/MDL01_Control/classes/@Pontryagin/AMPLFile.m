function AMPLFile(iCP,name,varargin)
%CREATEAMPLFILE Summary of this function goes here
%   Detailed explanation goes here


p = inputParser;
addRequired(p,'iCP')
addRequired(p,'name')
addOptional(p,'theta',1)
addOptional(p,'FixedTime',true)
addOptional(p,'ControlGuess',[])
addOptional(p,'StateGuess',[])


parse(p,iCP,name,varargin{:})

theta = p.Results.theta;
FixedTime =  p.Results.FixedTime;

idyn = iCP.Dynamics;
Ydim = idyn.StateDimension;
Udim = idyn.ControlDimension;
Nt   = idyn.Nt;
T    = idyn.FinalTime;
dt   = idyn.dt;

StateGuess   = p.Results.StateGuess;
ControlGuess = p.Results.ControlGuess;
%%
sep  = repmat('#',1,10);

fileID = fopen(name,'w');
fprintf(fileID,['param Ydim = ',num2str(Ydim),';',newline]);
fprintf(fileID,['param Udim = ',num2str(Udim),';',newline]);
fprintf(fileID,['param Nt   = ',num2str(Nt),';',newline]);

if FixedTime
    fprintf(fileID,['param T    = ',num2str(T),';',newline]);
    fprintf(fileID,['param dt    = ',num2str(dt),';',newline]);

else
    fprintf(fileID,['var T>=0;',newline]);
    fprintf(fileID,['var dt    = T/Nt;',newline]);

end

fprintf(fileID,['param Y0 {1..Ydim};',newline]);
fprintf(fileID,['param YGuess {1..Nt,1..Ydim};',newline]);
fprintf(fileID,['param UGuess {1..Nt,1..Udim};',newline]);

%% vars
fprintf(fileID,['var Y {i in 1..Nt, j in 1..Ydim};',newline]);
fprintf(fileID,['var U {i in 1..Nt, j in 1..Udim};',newline]);
if iCP.Dynamics.lineal
    fprintf(fileID,['param A {1..Ydim,1..Ydim};',newline]);
    fprintf(fileID,['param M {1..Ydim,1..Ydim};',newline]);
    fprintf(fileID,['param B {1..Ydim,1..Udim};',newline]);
end
%
fprintf(fileID,[newline,sep,newline,newline]);
fprintf(fileID,['data;']);
fprintf(fileID,[newline,sep,newline,newline]);

if iCP.Dynamics.lineal
    WriteLinealDynamics
end

fprintf(fileID,[newline,sep,newline,newline]);

% Initial Condition
fprintf(fileID,['param Y0: ',num2str(1:Ydim),' := ',newline, ...
                 '1 ',num2str(iCP.Dynamics.InitialCondition.'),';',newline,newline]);
%% Initial Guess

if ~isempty(StateGuess)

    fprintf(fileID,['param YGuess: ',num2str(1:Ydim),' := ',newline]);
    for it = 1:Nt
        if it ~= Nt
            fprintf(fileID,[num2str(it),' ',num2str(StateGuess(it,:)),newline]);
        else
            fprintf(fileID,[num2str(it),' ',num2str(StateGuess(it,:)),';',newline]);
        end
    end

end
%
if ~isempty(ControlGuess)

    fprintf(fileID,['param UGuess: ',num2str(1:Udim),' := ',newline]);
    for it = 1:Nt
        if it ~= Nt
            fprintf(fileID,[num2str(it),' ',num2str(ControlGuess(it,:)),newline]);
        else
            fprintf(fileID,[num2str(it),' ',num2str(ControlGuess(it,:)),';',newline]);

        end
    end

end


if ~isempty(StateGuess)
    str = 'let {i in 1..Nt, j in 1..Ydim} Y[i,j] := YGuess[i,j];';
    fprintf(fileID,[newline,str,newline,newline]);
end
if ~isempty(ControlGuess)
    str = 'let {i in 1..Nt, j in 1..Udim} U[i,j] := UGuess[i,j];';
    fprintf(fileID,[newline,str,newline,newline]);
end




fprintf(fileID,[newline,sep,newline,newline]);
%%

%% cost functional 
t = idyn.symt;
Y = idyn.StateVector.Symbolic;
U = idyn.Control.Symbolic;
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
%%
str = 'subject to InitialCondition {i in 1..Ydim}: Y[1,i] = Y0[i];';
fprintf(fileID,[newline,str,newline,newline]);

fprintf(fileID,[newline,sep,newline,newline]);
%%


if ~iCP.Dynamics.lineal
    F  = idyn.DynamicEquation.Num;

    Y = sym('Statebefore',[Ydim 1]);
    U = sym('Controlbefore',[Udim 1]);
    F  = F(t,Y,U);

    Ya = sym('State',[Ydim 1]);
    Ua = sym('Control',[Udim 1]);
    Fa  = idyn.DynamicEquation.Num;

    Fa = Fa(t,Ya,Ua);


    strcalculation = '';
    for i = 1:Ydim
        str = ['subject to dynamics_',num2str(i),' {j in 2..Nt}:'];
        strcalculation =[strcalculation,str,    '  - Y[j-1,',num2str(i),'] + Y[j,',num2str(i),']', ...
                                            ' = ',num2str(theta),'*dt*(',char(F(i)),') + ',num2str(1-theta),'*dt*(',char(Fa(i)),');',newline];
    end

    
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

    fprintf(fileID,strcalculation);
        
else
    % Es lineal
    separation

    %%
    %%
    str = 'subject to dynamics {j in 1..Nt-1, i in 1..Ydim}:';
    fprintf(fileID,[str,newline]);

    str = ['sum {l in 1..Ydim} M[i,l]*Y[j+1,l]', ...
           ' =    sum {l in 1..Ydim} M[i,l]*Y[j,l] + ', ...
           '   dt*sum {l in 1..Ydim}(A[i,l]*Y[j,l]) + ', ...
           '   dt*sum {l in 1..Udim}(B[i,l]*U[j,l]);'];
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


%%
fprintf(fileID,['option ipopt_options "halt_on_ampl_error yes";',newline]);

fprintf(fileID,['solve;',newline,newline]);

separation

print1var('cost')
print1var('T')
print1var('Ydim')
print1var('Udim')
%%
PrintInFile(['printf: " # Variable - State - ',num2str(Nt),' - ',num2str(Ydim),'\\n";'])
PrintInFile( 'printf {j in 1..Nt, i in 1..Ydim}: " %%24.16e\\n", Y[j,i];')
PrintInFile(['printf: " # Variable - Control - ',num2str(Nt),' - ',num2str(Udim),'\\n";']);
PrintInFile( 'printf {j in 1..Nt, i in 1..Udim}: " %%24.16e\\n", U[j,i];');
PrintInFile( 'printf: " Variable";');
PrintInFile( 'printf: " EndAMPLExecution";');

fclose(fileID);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
    function separation
        sep  = repmat('#',1,10);
        fprintf(fileID,newline);
        fprintf(fileID,[sep,newline]);
        fprintf(fileID,[sep,newline]);
        fprintf(fileID,newline);

    end

    function print1var(string)
        stringinfun=['printf: " # Variable - ',string,' - 1 \\n";'];
        fprintf(fileID,[stringinfun,newline]);
        stringinfun=['printf: " %%24.16e\\n", ',string,';'];
        fprintf(fileID,[stringinfun,newline]);
    end

    function PrintInFile(string)
        fprintf(fileID,[string,newline]);
    end

    function WriteLinealDynamics
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
end

