%function [Q LL] = mog_E_step_log( X, MOG )
%
% Implements the E-step of the algorithm. 
%  
% The function does not change the parameters but computes Q, a matrix 
% that contains the probability of each mixture component given the data 
% p(z|x, theta) and LL, the log-likelihood of the data set under the 
% mixture model.
%
% Parameters are:
%   X - the data,
%   MOG -  the current parameter values. 
function [Q LL] = mog_E_step_log( X, MOG )
    % Initialize Q
    Q = zeros( size( X, 1 ), size( MOG, 1 ) );
    
    % Loop over all components
    for k = 1:size(MOG,1)
        Q(:,k) = lmvnpdf( X, MOG{k}.MU, MOG{k}.SIGMA ) + log( MOG{k}.W );
    end

    % Normalize and calculate log-likelihood
    Q = Q - repmat( logsum( Q, 2 ), 1, size(MOG,1) );
    LL = logsum( logsum( Q, 2 ), 1 )
    
    Q = exp( Q );
end