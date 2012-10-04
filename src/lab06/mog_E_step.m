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

Q = zeros( size( X, 1 ), size( MOG, 1 ) );
for i = 1:size(MOG,1)
    Q(:,i) = mvnpdf( X, MOG{i}.MU, MOG{i}.SIGMA ) * MOG{i}.W;
end

LL = 0;