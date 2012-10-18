%% Contour plot of distribution
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
cc = hsv(size(x2,2));

hold all
for i = 1:size(x2,2)
    data3 = mvnpdf( [ X(1,:)', repmat( x2(i), size(X,1), 1 )  ], mu, sigma );
    plot( data3 ); %, 'color', cc(i,:) )
end

xlabel( '$x_1$', 'interpreter', 'latex' );
ylabel( '$P(x_1|x_2)$', 'interpreter', 'latex' );
hold off

%% 3d plot of other distribution
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
cc = hsv(size(x2,2));

hold all
for i = 1:size(x2,2)
    data3 = mvnpdf( [ X(1,:)', repmat( x2(i), size(X,1), 1 )  ], mu, sigma );
    plot( data3 ); %, 'color', cc(i,:) )
end

xlabel( '$x_1$', 'interpreter', 'latex' );
ylabel( '$P(x_1|x_2)$', 'interpreter', 'latex' );
hold off


%% Assignment 2
chirps = load( 'chirps.mat' );
X = chirps.chirps(:, 1); % Training inputs
t = chirps.chirps(:, 2); % Training targets


