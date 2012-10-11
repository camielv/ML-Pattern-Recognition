% function Log = logsumexp( LN1, LN2 )
% 
% Computes the sum of the two given log probabilities in an efficient way.
function Log = logsumexp( LN1, LN2 )
    % The sign function flips the sign of the absolute value, if the other
    % log was greater. This ensures we take the right value (and is faster
    % than an if-statement).
    Log = LN1 + log(ones(size(LN1)) + exp(sign(LN2 - LN1) * abs(LN2 - LN1)));
end