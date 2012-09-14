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
scatter( train(1:p,1), train(1:p,2), 'p', 'r' )
scatter( train(p+1:2*p,1), train(p+1:2*p,2), '*','b' )
hold off;

%% Train a knn-classifier
neighbors = 5;
NET = knn( 2, 2, neighbors, train, train_labels );

%% Evaluate the classifier
Y = knnfwd( NET, test );

[C,Rate] = confmat( Y, test_labels )

%% Loop to make a graph
Rates = zeros(1,20);
max_k = 1500;
stepsize = 5;
for i = 1 : max_k/stepsize,
    NET = knn( 2, 2, (i-1)*stepsize, train, train_labels );
    Y = knnfwd( NET, test );
    [C,Rate] = confmat( Y, test_labels );
    Rates(i) = 1.0 - Rate(1) / 100.0;
end

plot( Rates )

%% Cross-validation
folds = 10;
indices = crossvalind('Kfold', 2*p, folds );
best = zeros(folds,1);

for i = 1:folds,
    % Create instances
    test_indices = (indices == i);
    train_indices = ~test_indices; 
    
    % Temporary dataset, excluding the current validation set
    temp_train = train( train_indices, : ); 
    temp_labels = train_labels( train_indices, : );
    
    % Validation set and labels
    validation = train( test_indices, : );
    validation_labels = train_labels( test_indices, : );
    
    % Set parameters
    max_k = 500;
    Rates = zeros( 1, max_k/stepsize );
    stepsize = 5;
    
    % Calculate the different error rates for k
    for j = 1:max_k/stepsize,
        NET = knn( 2, 2, (j-1)*stepsize, temp_train, temp_labels );
        Y = knnfwd( NET, validation );
        
        [C,Rate] = confmat( Y, validation_labels );
        Rates(j) = 1.0 - Rate(1) / 100.0;
    end
    
    % Find the best value for k
    current_best = find( Rates == min( Rates ) );
    best(i) = (current_best(1) - 1) * stepsize;
end