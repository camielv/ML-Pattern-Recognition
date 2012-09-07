%% Load the data
data = load( 'twoclass.mat' );
N = size(data.A,1);

%% Split the data into train and test set
% Create a random permutation
select = randperm( N );
p = N * 0.75;

% Select according to permutation
train = data.A(select(1:p),:);
test = data.A(select(p+1:N),:);

% New permutation for second class
select = randperm( N );

% Select according to permutation
train = [train; data.B(select(1:p),:)];
test = [test; data.B(select(p+1:N),:)];

% Create the labels
train_labels = [ repmat( [1 0], p, 1 ); repmat( [0 1], p, 1 ) ];
test_labels = [ repmat( [1 0], N - p, 1 ); repmat( [0 1], N - p, 1 ) ];

%% Plot data in train set
hold on;
scatter( train(1:p,1), train(1:p,2), 'r' )
scatter( train(p+1:2*p,1), train(p+1:2*p,2), 'b' )
hold off;

%% Train a knn-classifier
neighbors = 2;
NET = knn( 2, 2, neighbors, train, train_labels );

%%