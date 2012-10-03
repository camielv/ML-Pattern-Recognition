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
MOG = MOG;