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
chirps = load( 'chirps.mat' );
X = chirps.chirps(:, 1); % Training inputs
t = chirps.chirps(:, 2); % Training targets
