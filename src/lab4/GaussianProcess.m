function [ f_star, noise_star, LL ] = GaussianProcess( X, t, noise, x_star, K, k_star )
    L = chol( K + noise * eye(size(K) ), 'lower' );
    alpha = L'\(L\t);
    f_star = k_star' * alpha;
    v = L\k_star;
    noise_star = covariance_function( x_star, x_star ) - v'* v;
    n = size(X, 1);
    LL = -0.5 * t' * alpha - trace( log( L ) ) - n / 2 * log( 2 * pi ); 
end

