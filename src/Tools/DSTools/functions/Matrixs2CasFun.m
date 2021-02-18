function [DynamicFcn,x,u] = Matrixs2CasFun(A,B,varargin)
%GENERATELINEARMATRIX Summary of this function goes here
%   Detailed explanation goes here

        p = inputParser;
        
        addRequired(p,'A')
        addRequired(p,'B')
        addOptional(p,'NameStateVar','x')
        addOptional(p,'NameControlVar','u')
        parse(p,A,B,varargin{:})
        
        NameStateVar   = p.Results.NameStateVar;
        NameControlVar = p.Results.NameControlVar;

        %% Validations
        [Anrow ,Ancol]= size(A);
        [Bnrow ,Bncol]= size(B);

        if Anrow ~= Ancol
            error('A must be square')
        elseif Anrow ~= Bnrow
           error('B columns must be equal to A dimension') 
        end

        import casadi.*

        StateDim   = Anrow;
        ControlDim = Bncol;

        t = SX.sym('t');
        x = SX.sym(NameStateVar, StateDim  ,1);
        u = SX.sym(NameControlVar, ControlDim,1);

        DynamicFcn= A*x+B*u;
end

