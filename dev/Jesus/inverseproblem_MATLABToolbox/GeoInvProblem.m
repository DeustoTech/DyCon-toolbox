function g = GeoInvProblem()
%GEOINVPROBLEM Summary of this function goes here
%   Detailed explanation goes here
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
C1 = [   +1.0   ,  ...    % circle code
         +0.2   ,  ...    % x - coordinate
         -1.0   ,  ...    % y - coordinate
          1.5]' ;         % radius
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
C2 = [   +1.0   ,  ...    % circle code
         +0.2   ,  ...    % x - coordinate
         -1.0   ,  ...    % y - coordinate
          0.8]' ;         % radius
            


gm = [C1,C2];
sf = 'C1+C2';


%
ns = char('C1','C2');
ns = ns';
g = decsg(gm,sf,ns);
end

