% function MOG = init_mog( X, C )
%
% Creates a structure and fills in the initial parameter values.
% 
% Parameters are:
%   X - N by D data matrix, where each row is a data element 
%   C - Number of mixture components
function MOG = init_mog( X, C )

MOG = cell(2);