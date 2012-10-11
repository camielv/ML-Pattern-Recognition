function Log = logsumexp( LN1, LN2 )
Log = LN1 + log( ones( size(LN1) ) + exp( sign( LN2 - LN1) * abs( LN2 - LN1 ) ) );
end