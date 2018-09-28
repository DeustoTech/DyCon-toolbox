function result = forall(input_cell,operation)
%FORALL Summary of this function goes here
%   Detailed explanation goes here
    switch operation
        case 'plus'
            
        case 'mean'
            n = length(input_cell);
            
            result = input_cell{1};
            for i = 2:n
                result = result + input_cell{i};
            end
            result = result/n;
    end
end

