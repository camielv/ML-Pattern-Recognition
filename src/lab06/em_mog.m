% [LogL,mog] = em_mog(X,C,verbose);
%
% Parameters are:
%   X (N x D) : data matrix 
%   C         : number of mixture components
%   verbose   : verbosity (1 prints info, 2 prints and draws)
%
% Jakob Verbeek (University of Amsterdam)
% http://www.science.uva.nl/~jverbeek
%
% Modified Oct 2008 Gwenn Englebienne  
function [LogL,mog] = em_mog(X,C,verbose)

epsilon       = 1e-5;
max_iters     = 1000;
min_iters     = 20;

[N,D]         = size(X); 

if verbose
  fprintf('--> running EM for MoG\n');
  fprintf('    mixture components: %d\n',C);
  fprintf('    data: %d points in %d dimensions\n',N,D);
end

% --------   Initialisation
mog       = init_mog(X,C);
if verbose>1
  clf
  plot(X(:,1),X(:,2),'bo');              
  hold on;
  for i=1:C
    plot_gauss(mog{i}.MU,mog{i}.SIGMA);
  end
  hold off
  drawnow;
  %pause
end
LogL = zeros(max_iters,1);

for iter=1:max_iters; % EM loops          
  [Q, LL]     = mog_E_step(X,mog);        % E-step
  LogL(iter)  = LL;
  mog         = mog_M_step(X,Q,mog);      % M-step
  
  if iter > 1
    rel_change = (LogL(iter)-LogL(iter-1)) / abs(mean(LogL(iter-1:iter)));

    if rel_change < 0
      fprintf('Log likelihood decreased in iteration %d\n',iter)
    end
    if verbose
      fprintf('iteration %3d   Logl %.2f  relative increment  %.6f\n',iter, LogL(end),rel_change)
    end
    if verbose>1
      clf
      plot(X(:,1),X(:,2),'bo');              
      hold on;
      for i=1:C
        plot_gauss(mog{i}.MU,mog{i}.SIGMA);
      end
      drawnow
      hold off
    end
    if ~isfinite(rel_change) | ((rel_change < epsilon) & (iter > min_iters))
      break
    end
  end    
end
