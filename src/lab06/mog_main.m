%% Load data
banana = load( 'banana.mat' );
%scatter( spiral.A(:,1), spiral.A(:,2) )
%% Split set
ratio = 0.9;
training.A = banana.A(1: round( size(banana.A, 1) * ratio), :); 
training.B = banana.B(1: round( size(banana.B, 1) * ratio), :);
test.A     = banana.A(round( size(banana.A, 1) * ratio) + 1: end, :);
test.B     = banana.B(round( size(banana.B, 1) * ratio) + 1: end, :);

%% Plot bananas
hold on
scatter( banana.A(:,1), banana.A(:,2), 'MarkerEdgeColor', [128, 70, 27] / 256 )
scatter( banana.B(:,1), banana.B(:,2), 'MarkerEdgeColor',[218, 165, 32] / 256 )
hold off

%% Calculate means
mu_A    = mean( training.A );
Sigma_A = cov(  training.A );

mu_B    = mean( training.B );
Sigma_B = cov(  training.B );

%% Plot Gausses
hold on
plot_gauss( mu_A, Sigma_A )
plot_gauss( mu_B, Sigma_B )
hold off

%% Calculate probabilities for each data point
C = zeros(2);

LL_A = lmvnpdf( test.A, mu_A, Sigma_A );
LL_B = lmvnpdf( test.A, mu_B, Sigma_B );
P = LL_A - LL_B;
P( P > 0 ) = 1;
P( P < 0 ) = 0;
C(1,1) = sum( P );
C(1,2) = size( test.A,1 ) - sum(P);

LL_A = lmvnpdf( test.B, mu_A, Sigma_A );
LL_B = lmvnpdf( test.B, mu_B, Sigma_B );
P = LL_B - LL_A;
P( P > 0 ) = 1;
P( P < 0 ) = 0;
C(2,2) = sum( P );
C(2,1) = size( test.B,1 ) - sum(P);

%% 
spiral = load('spiral.mat');

%%
components = 4;
[LL, MOGA] = em_mog( training.A, components, 2 );
[LL, MOGB] = em_mog( training.B, components, 2 );

%% Calculate probabilities for each data point
C = zeros(2);
P_A = 0;
P_B = 0;
for i = 1:components
    P_A = P_A + mvnpdf( test.A, MOGA{i}.MU, MOGA{i}.SIGMA ) * MOGA{i}.W;
    P_B = P_B + mvnpdf( test.A, MOGB{i}.MU, MOGB{i}.SIGMA ) * MOGB{i}.W;
end
P = P_A - P_B;
P( P > 0 ) = 1;
P( P < 0 ) = 0;
C(1,1) = sum( P );
C(1,2) = size( test.A,1 ) - sum(P);


P_A = 0;
P_B = 0;
for i = 1:components
    P_A = P_A + mvnpdf( test.B, MOGA{i}.MU, MOGA{i}.SIGMA ) * MOGA{i}.W;
    P_B = P_B + mvnpdf( test.B, MOGB{i}.MU, MOGB{i}.SIGMA ) * MOGB{i}.W;
end
P = P_B - P_A;
P( P > 0 ) = 1;
P( P < 0 ) = 0;
C(2,2) = sum( P );
C(2,1) = size( test.B,1 ) - sum(P);

%% Plot 3D
x = 0:0.02:1;
y = -1:0.02:1;
X = repmat(x',size(y,2), 1);
Y = reshape( repmat(y,size(x,2),1), size(x,2) * size(y,2), 1);

Z = zeros( size(x,2) * size(y,2), 1 );

for k = 1:size(MOGA,1)
    Z = Z + mvnpdf( [X Y], MOGA{k}.MU, MOGA{k}.SIGMA ) * MOGA{k}.W;
end

Z = Z / sum(sum(Z));
Z = reshape( Z, size(x,2), size(y,2) );
[X,Y] = meshgrid( x, y );

surf( X', Y', Z );

xlabel('$x_1$', 'Interpreter', 'latex' );
ylabel('$x_2$', 'Interpreter', 'latex' );
zlabel('$P(\textbf{x})$', 'Interpreter', 'latex' );

axis([0 1 -1 1 0 max(max(Z))] );
