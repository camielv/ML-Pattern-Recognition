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
data = [banana.A; banana.B];
em_mog( data, 2, 2 )