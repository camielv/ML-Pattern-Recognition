function [ k ] = covariance_function( x, x_prime, theta, l )
    k = theta * exp( -1 / (2*l)  * (x - x_prime)' * (x - x_prime) ); 
end

