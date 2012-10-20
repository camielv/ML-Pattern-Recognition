function [ f_star, noise_star, LL ] = GaussianProcess( X, t, noise, x_star, K, k_star, theta, l )
    L = chol( K + noise * eye(size(K) ), 'lower' );
    alpha = L'\(L\t);
    f_star = k_star' * alpha;
    v = L\k_star;
    noise_star = covariance_function( x_star, x_star, theta, l ) - v'* v;
    n = size(X, 1);
    
    sum = 0;
    for i = 1:n
        sum = sum + log(L(i,i)) - ( n/2 * log( 2 * pi ) );
    end
    LL = -0.5 * t' * alpha - sum;
    %LL = -0.5 * t' * alpha - trace( log( L ) ) - ( n / 2 * log( 2 * pi ) ); 
end

