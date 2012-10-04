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
    rMU = repmat( MOG{i}.MU, size( X, 1), 1 );
    
    MOG{i}.MU = sum( rQ .* X / sQ );
    MOG{i}.SIGMA = ( rQ .* (X - rMU))' * (X - rMU) / sQ;
    MOG{i}.W = sQ;
    
    size(MOG{i}.SIGMA)
end