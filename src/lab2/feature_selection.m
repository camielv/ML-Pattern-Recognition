%% Loading in train data.
spam_train_dir = [ pwd filesep 'spam' filesep 'train' filesep ];
ham_train_dir  = [ pwd filesep 'ham'  filesep 'train' filesep ];

% Files from training set
spam_train_files = dir( spam_train_dir );
ham_train_files  = dir( ham_train_dir );

% Get words
spam_train_words = countwords( spam_train_dir );
ham_train_words  = countwords( ham_train_dir  );
total            = merge_ws( spam_train_words, ham_train_words );

%% New struct containing all data.
words = fields( total );

% Lambda for Add-lambda smoothing
lambda = 1;

% Total word count per set
ham_train_count  = 0;
spam_train_count = 0;

% Total distinct word count per set
ham_train_distinct_count  = size( fields( ham_train_words ), 1 );
spam_train_distinct_count = size( fields( spam_train_words ), 1 );

% Total distinct word count
total_distinct_count = size( words, 1 );

% Struct with word counts
array = cell( total_distinct_count, 8 );

% Fill struct with [WORD, WORD_TOTAL_COUNT, WORD_COUNT_IN_SPAM,
% WORD_COUNT_IN_HAM, P(F|SPAM), P(F|HAM), P(F), FEATURE VALUE.
for i = 1:total_distinct_count,
    word = words(i);
    array{i,1} = word;
    array{i,2} = total.( word{1,1} );
    if isfield( spam_train_words, word{1,1} ) == 1
        array{i,3} = spam_train_words.( word{1,1} ) + lambda;
    else
        array{i,3} = lambda;
    end
    spam_train_count = spam_train_count + array{i,3};
    
    if isfield( ham_train_words, word{1,1} ) == 1
        array{i,4} = ham_train_words.( word{1,1} ) + lambda;
    else
        array{i,4} = lambda;
    end
    ham_train_count = ham_train_count + array{i,4};
end

% Total words in both sets.
total_train_count = spam_train_count + ham_train_count + total_distinct_count * lambda;

% Calculate probabilities and selection values
for i = 1:total_distinct_count,
    array{i,5} = log( array{i,3} / spam_train_count );
    array{i,6} = log( array{i,4} / ham_train_count );
    array{i,7} = log( ( array{i,3} + array{i,4} ) / total_train_count );
    array{i,8} = max( array{i,5} - array{i,6}, array{i,6} - array{i,5} ) + array{i,7};
end

%% Init
DIR_HAM      = [ pwd filesep 'ham'  filesep 'test' ];
DIR_SPAM     = [ pwd filesep 'spam' filesep 'test' ];
FILES_HAM    = dir( DIR_HAM  );
FILES_SPAM   = dir( DIR_SPAM );
SIZE_HAM     = size( FILES_HAM,  1 );
SIZE_SPAM    = size( FILES_SPAM, 1 );

P_SPAM_INITIAL = 0.3;
P_HAM_INITIAL = 0.7;

% Sort to selection criteria
array = sortrows( array, 8 );

%% Feature Selection + Bayes
max_k = 500;
C_array = cell( max_k, 1 );

for k = 1:max_k,
    k
    % Take k best features
    best_features = array( total_distinct_count-k : total_distinct_count, : );

    % Fill array with best features
    features = cell( 1, k );
    num_features = size( features, 1 );
    for i = 1:k,
        word = best_features{i,1};
        features(1, i) = word(1);
    end

    % Naive Bayes

    C = zeros(2,2);

    for i = 3:SIZE_HAM
        probe = [ DIR_HAM filesep FILES_HAM(i).name];
        result = presentre( probe , features );

        p_ham = P_HAM_INITIAL;
        p_spam = P_SPAM_INITIAL;
        
        for j = 1:num_features
            if ~result( j )
                continue
            end
            p_spam = p_spam + best_features{j, 5};
            p_ham = p_ham + best_features{j, 6};    
        end

        if p_ham > p_spam
            C(1,1) = C(1,1) + 1;
        else
            C(2,1) = C(2,1) + 1;
        end
    end

    for i = 3:SIZE_SPAM
        probe = [ DIR_SPAM filesep FILES_SPAM(i).name];
        result = presentre( probe , features );
        
        p_ham = P_HAM_INITIAL;
        p_spam = P_SPAM_INITIAL;
        
        for j = 1:num_features
            if ~result( j )
                continue
            end
            p_spam = p_spam + best_features{j,5};
            p_ham = p_ham + best_features{j,6};    
        end

        if  p_spam > p_ham
            C(2,2) = C(2,2) + 1;
        else
            C(1,2) = C(1,2) + 1;
        end
    end
    C_array{k} = C;
end

%% Fill cell to plot
plot_cell = cell( max_k, 1 );
for i= 1:max_k,
    M = C_array{i};
    plot_cell{i} = M(1,1) + M(2,2);
end

%%
x = 0:0.05:1;
y = 0:0.05:1;
[X,Y] = meshgrid(x,y);
%Z = 1 ./ ( 1 - abs( X - Y ) );
Z = abs( X - Y );
surf( X, Y, Z );