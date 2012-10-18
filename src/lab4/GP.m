%% Contour plot of distribution
figure;
mu    = [0,0];
sigma = [1,0;0,3];

[X, Y] = meshgrid( linspace(-5, 5), linspace(-5, 5) );
data = [X(:), Y(:)];
Z = mvnpdf( data, mu, sigma );
subplot(3,1,1)
contour( X, Y, reshape(Z, size(X,1), size(Y,1) ) )
xlabel( '$x_1$', 'interpreter', 'latex' );
ylabel( '$x_2$', 'interpreter', 'latex' );

subplot(3,1,2)
data2 = mvnpdf( X(1,:)', mu(1), sigma(1,1) );
plot( data2 );
xlabel( '$x_1$', 'interpreter', 'latex' );
ylabel( '$P(x_1)$', 'interpreter', 'latex' );

subplot( 3,1,3 )
x2 = -3: 1 : 3;
num = size(x2,2);
lambda = inv( sigma );

henk = lambda(1,2) * ( X(2,:) - mu(2) ) / lambda(1,1);

hold all;
for i = 1:num
    data3 = mvnpdf( X(1,:)', mu(1) - lambda(1,2) * ( x2(i) - mu(2) ) / lambda(1,1), lambda(1,1)  );
    plot( data3, 'DisplayName', sprintf( '$x_2 = %d$', x2(i) ) );
end
hold off;

xlabel( '$x_1$', 'interpreter', 'latex' );
ylabel( '$P(x_1|x_2)$', 'interpreter', 'latex' );
legend1 = legend( 'show' );
set( legend1, 'Interpreter', 'latex' );

%% 3d plot of other distribution
figure;
mu    = [0,0];
sigma = [1, 0.7; 0.7, 1];

[X, Y] = meshgrid( linspace(-5, 5), linspace(-5, 5) );
data = [X(:), Y(:)];
Z = mvnpdf( data, mu, sigma );
subplot(3,1,1)
plot3( X, Y, reshape( Z, size(X,1), size(Y,1) ) );
xlabel( '$x_1$', 'interpreter', 'latex' );
ylabel( '$x_2$', 'interpreter', 'latex' );

subplot(3,1,2)
data2 = mvnpdf( X(1,:)', mu(1), sigma(1,1) );
plot( data2 );
xlabel( '$x_1$', 'interpreter', 'latex' );
ylabel( '$P(x_1)$', 'interpreter', 'latex' );

subplot( 3,1,3 )
x2 = -3: 1 : 3;
num = size(x2,2);
lambda = inv( sigma );

hold all;
for i = 1:num
    data3 = mvnpdf( X(1,:)', mu(1) - lambda(1,2) * ( x2(i) - mu(2) ) / lambda(1,1), lambda(1,1)  );
    plot( data3, 'DisplayName', sprintf( '$x_2 = %d$', x2(i) ) );
end
hold off;

xlabel( '$x_1$', 'interpreter', 'latex' );
ylabel( '$P(x_1|x_2)$', 'interpreter', 'latex' );
legend1 = legend( 'show' );
set( legend1, 'Interpreter', 'latex' );

%% Assignment 2
ratio    = 0.6;
dataset  = load( 'chirps.mat' );
length   = size(dataset.chirps, 1);
training = dataset.chirps( 1:round( ratio * length ), : );
test     = dataset.chirps( round( ratio * length )+1:end, : );

X = training(:, 1); % Training inputs
t = training(:, 2); % Training targets

x_star = test(:, 1); % Training inputs

K = zeros( size(X,1) );
k_star = zeros(size(X,1),1);

for i = 1:size(X,1)
    k_star(i) = covariance_function(X(i,1),x_star);
    for j = 1:size(X,1)
        K(i,j) = covariance_function(X(i,:),X(j,:));
    end
end
noise = 0.001;
Mu, Sigma, LL = GaussianProcess( X, t,noise, x_star, K, k_star);