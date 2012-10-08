%function [Q LL] = mog_E_step( X, MOG )
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
function [Q LL] = mog_E_step( X, MOG )
    % Initialize Q
    Q = zeros( size( X, 1 ), size( MOG, 1 ) );
    
    % Loop over all components
    for k = 1:size(MOG,1)
        Q(:,k) = mvnpdf( X, MOG{k}.MU, MOG{k}.SIGMA ) * MOG{k}.W;
    end

    % Normalize and calculate log-likelihood
    Q = Q ./ repmat( sum( Q,2 ), 1, size(MOG,1) );
    LL = sum( log( sum( Q ) ) );
end