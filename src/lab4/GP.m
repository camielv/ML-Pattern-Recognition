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

X = training(:,1);
t = training(:,2);

%%
ratio    = 0.6;
dataset  = load( 'curve.mat' );
training = dataset.curvetrain;
test     = dataset.curvetest;

X = training(:,1);
t = training(:,2);

%%
hold on
scatter( training(:,1), training(:,2) );
scatter( test(:,1), test(:,2) )
hold off

xlabel( 'Frequency in Hz', 'interpreter', 'latex' );
ylabel( 'Temperature in Fahrenheit', 'interpreter', 'latex' );

%% GP

figure;
K = zeros( size(X,1) );

%theta = 1;
%l = 0.1109;
%noise = 0.0906;

theta = 100;
l = 0.1;
noise = 0.7;

%theta = 100;
%l = 0.01;
%noise = 0.01;

for i = 1:size(X,1)
    for j = 1:size(X,1)
        K(i,j) = covariance_function(X(i),X(j), theta, l );
    end
end


%range = 12 : 22;
range = linspace(0,1);
num = size( range, 2 );
mu = zeros( 1, num );
sigma = zeros( 1, num );

% Cholesky
L = chol( K + noise * eye(size(K) ), 'lower' );
alpha = L'\(L\t);
n = size(X, 1);
sum = 0;
for i = 1:n
    sum = sum + log(L(i,i)) - ( n/2 * log( 2 * pi ) );
end
LL = -0.5 * t' * alpha - sum;
%LL = -0.5 * t' * alpha - trace( log( L ) ) - n / 2 * log( 2 * pi )

for i = 1:num
    k_star = zeros( size( X,1), 1 );
    %fprintf('iteration %d\n', i);

    for j = 1:size(X,1)
        [k_star(j)] = covariance_function( X(j), range(i), theta, l );
    end

    mu(i) = k_star' * alpha;
    v = L\k_star;
    sigma(i) = covariance_function( range(i), range(i), theta, l ) - v'* v;
end

upper = mu + sigma;
lower = mu - sigma;

%x = [range,range];
%y = [lower,upper];
%plot( x, y );

xx = [ range, fliplr( range ) ];
yy = [ lower, fliplr( upper ) ];
%plot( X, Y)
patch( xx, yy, [0.5 0.5 0.5], 'DisplayName', 'Gaussian Process prediction' );

hold on

scatter( training(:,1), training(:,2), 'DisplayName', 'Training Set');
scatter( test(:,1), test(:,2), 'DisplayName', 'Test Set' );
hold off

legend1 = legend( 'show' );
set( legend1, 'Location', 'NorthWest' )
set( legend1, 'Interpreter', 'latex' );

xlabel( 'Frequency in Hz', 'interpreter', 'latex' );
ylabel( 'Temperature in Fahrenheit', 'interpreter', 'latex' );

%% Fitting
K = zeros( size(X,1) );

noise = linspace(0.01, 4,   100);
theta = linspace(1, 300,    100);
l     = linspace(0.01, 10,  100);
high  = -inf;
para  = [0, 0, 0];

%% Brute force
for x = 1:size(l,2)
    for y = 1:size(theta,2)
        for i = 1:size(X,1)
            for j = 1:size(X,1)
                K(i,j) = covariance_function(X(i),X(j), theta(y), l(x) );
            end
        end
        for z = 1:size(noise,2)
            L = chol( K + (noise(z) * eye(size(K) )), 'lower' );
            alpha = L'\(L\t);
            n = size(X, 1);
            sum = 0;
            for i = 1:n
                sum = sum + log(L(i,i)) - ( n/2 * log( 2 * pi ) );
            end
            LL = -0.5 * t' * alpha - sum;
            if LL > high
                high = LL;
                para = [x,y,z];
            end
        end
    end
end