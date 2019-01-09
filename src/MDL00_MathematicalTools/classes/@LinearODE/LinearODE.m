classdef LinearODE < ode
    % description: The representation of ode Y'(t) = A*Y + B*U
    % visible: true
    
    properties
        % type: "double"
        % dimension: [NxN]
        % default: "none"
        % description: "Matrix Dynamics"
        A                                           double
        % type: "double"
        % dimension: [NxM]
        % default: "none"
        % description: "Control Matrix"
        B                                           double
    end
    
    methods
        function obj = LinearODE(A,B)
            if nargin == 0
               A = 1;
               B = 1;
            end
            [nrowA, ncolA] = size(A);
            
            if nrowA ~= ncolA
                error('A must be square')
            end
            
            [nrowB, ncolB] = size(B);
            if nrowB ~= nrowA
                error(['B must have ',num2str(nrowA),' rows.'])
            end
            
            syms t
            symY = SymsVector('y',nrowA);
            symU = SymsVector('u',ncolB);

%%
            Fsym  = A*symY + B*symU;
           
            obj = obj@ode(Fsym,symY,symU);
            obj.A = A;
            obj.B = B;
        end
             
    end
    %%
    methods (Static)
        function z = zeros(varargin)
          %% Zeros constructor 
             if (nargin == 0)
                z = LinearODE;
             elseif any([varargin{:}] <= 0)
             % For zeros with any dimension <= 0   
                z = LinearODE.empty(varargin{:});
             else
             % Use property default values
                z = repmat(LinearODE,varargin{:});
             end
        end
    end
end

