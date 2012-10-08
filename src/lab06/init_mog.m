% function MOG = init_mog( X, C )
%
% Creates a structure and fills in the initial parameter values.
% 
% Parameters are:
%   X - N by D data matrix, where each row is a data element 
%   C - Number of mixture components
function MOG = init_mog( X, C )
MOG = cell(C,1);

% Find bounds for mu
min_mu = min( X );
max_mu = max( X );

%mus = [[0 0]; [1,1]; [0,1]; [1,0] ];

for i = 1:C
    MOG{i} = struct( 'MU', random( 'Uniform', min_mu, max_mu ), ...
                     'SIGMA', random('Uniform', 0.05, 1) * eye( size( X, 2 ) ), ...
                     'W', 1 / C );
end