% function Y = lmvnpdf(X,MU,SIGMA)
%
% Compute the log of probability density for the data X
% under the Gaussian PDF with mean MU and covariance SIGMA
%
% Parameters are:
%   X     - The data matrix, where each row is a data element
%   MU    - The mean vector of the Gaussian distribution
%   SIGMA - The covariance matrix of the Gaussian distribution
function Y = lmvnpdf(X,MU,SIGMA)
  DCOV = det(SIGMA);
  ICOV = inv(SIGMA);
  [N,DIM] = size(X);
  DIFF = X - repmat(MU,N,1);
  Y = -.5 * (DIM * log(2*pi) + log(DCOV) + sum((DIFF * ICOV) .* DIFF,2));
end
