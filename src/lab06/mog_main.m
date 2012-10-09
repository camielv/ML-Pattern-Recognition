%% Load data
banana = load( 'banana.mat' );

%% Plot bananas
hold on
scatter( banana.A(:,1), banana.A(:,2), 'MarkerEdgeColor', [128, 70, 27] / 256 )
scatter( banana.B(:,1), banana.B(:,2), 'MarkerEdgeColor',[218, 165, 32] / 256 )
hold off

%% Calculate means
mu_A = mean( banana.A );
Sigma_A = cov( banana.A );

mu_B = mean( banana.B );
Sigma_B = cov( banana.B );

%% Plot Gausses
hold on
plot_gauss( mu_A, Sigma_A )
plot_gauss( mu_B, Sigma_B )
hold off

%% Calculate probabilities for each data point
C = zeros(2);

LL_A = lmvnpdf( banana.A, mu_A, Sigma_A );
LL_B = lmvnpdf( banana.A, mu_B, Sigma_B );
P = LL_A - LL_B;
P( P > 0 ) = 1;
P( P < 0 ) = 0;
C(1,1) = sum( P );
C(1,2) = size( banana.A,1 ) - sum(P);

LL_A = lmvnpdf( banana.B, mu_A, Sigma_A );
LL_B = lmvnpdf( banana.B, mu_B, Sigma_B );
P = LL_B - LL_A;
P( P > 0 ) = 1;
P( P < 0 ) = 0;
C(2,2) = sum( P );
C(2,1) = size( banana.B,1 ) - sum(P);

%% 
data = [banana.A];
[LL, MOG] = em_mog( data, 6, 2 );

%% Plot 3D
x = 0:0.02:1;
y = -1:0.02:1;
X = repmat(x',size(y,2), 1);
Y = reshape( repmat(y,size(x,2),1), size(x,2) * size(y,2), 1);

Z = zeros( size(x,2) * size(y,2), 1 );

for k = 1:size(MOG,1)
    Z = Z + mvnpdf( [X Y], MOG{k}.MU, MOG{k}.SIGMA ) * MOG{k}.W;
end

Z = Z / sum(sum(Z));
Z = reshape( Z, size(x,2), size(y,2) );
[X,Y] = meshgrid( x, y );

surf( X', Y', Z );

xlabel('x');
ylabel('y');

axis([0 1 -1 1 0 max(Z)] );