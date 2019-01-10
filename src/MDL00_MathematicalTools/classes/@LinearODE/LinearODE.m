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
        function obj = LinearODE(A,B,varargin)
            if nargin == 0
               A = 1;
               B = 1;
            end
            
            p = inputParser;
            addRequired(p,'A')
            addRequired(p,'B')
            addOptional(p,'Y0',[])
            addOptional(p,'dt',0.1)
            addOptional(p,'T',1)
            addOptional(p,'sym',true)

            parse(p,A,B,varargin{:})
            
            dt = p.Results.dt;
            Y0 = p.Results.Y0;
            T = p.Results.T;
            sym = p.Results.sym;
            [nrowA, ncolA] = size(A);
            
            if nrowA ~= ncolA
                error('A must be square')
            end
            
            [nrowB, ncolB] = size(B);
            if nrowB ~= nrowA
                error(['B must have ',num2str(nrowA),' rows.'])
            end
            
            if isempty(Y0)
               Y0 = zeros(nrowA,1); 
            end

            numF = @(t,Y,U) A*Y + B*U; 
%%    
            paramsODE = {'sym',sym,'numF',numF, ...
                         'dt',dt,'T',T,'Y0',Y0};
            if sym
                syms t
                symY = SymsVector('y',ncolA);
                symU = SymsVector('u',ncolB);  
                symF  = A*symY + B*symU;
            else
                symY = [];symU = [];symF  = [];                
            end
            %%
            obj = obj@ode(symF,symY,symU,paramsODE{:});

            obj.A = A;
            obj.B = B;
            obj.Udim = ncolB;
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

