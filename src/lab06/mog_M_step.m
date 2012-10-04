% function MOG = mog_M_step( X, Q, MOG ) 
% 
% Implements the M step of the algorithm.
%
% The function returns the updated parameter values.
%   
% Parameters are:
%   X - The data matrix
%   Q - The corresponding responsibilities
%   MOG - The current parameter values. 
function MOG = mog_M_step( X, Q, MOG )

for i = 1:size( MOG, 1)
    sQ = sum( Q(:,i) );
    rQ = repmat( Q(:,i), 1, size( X, 2 ) );
    rMU = repmat( MOG{i}.MU, size( X, 1 ), 1 );
    
    MOG{i}.MU = sum( rQ .* X / sQ );
    
    SIGMA = ( ( rQ .* ( X - rMU ) )' * ( X - rMU ) ) / sQ;
    
    if cond( SIGMA ) < 10^10
        MOG{i}.SIGMA = SIGMA;
    end
    
    MOG{i}.W = sQ;   
end