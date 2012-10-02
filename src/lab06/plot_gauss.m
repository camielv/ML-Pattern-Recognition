% function plot_gauss(M,C)
%
% Plot a contour of a Gaussian PDF
%
% Parameters are:
%   M - the mean
%   C - the covariance
function plot_gauss(M,C)
 [V,L] = eig(C);        % eigen-decomposition of cov matrix C = V L V' ,  L is diagonal
 
 l     = diag(L);       % select diagonal
 
 phi   = acos(V(1,1));  % angle of first eigenvector with x-axis
 if V(2,1) < 0;  phi   = 2*pi - phi; end % could be mirrored if first ev. points down
 
 plot(M(1),M(2),'k.',M(1),M(2),'k+');  % plot center

 ellipse(2*sqrt(l(1)),2*sqrt(l(2)),phi,M(1),M(2),'k'); % plot ellipse at the 95% mass iso 
 
