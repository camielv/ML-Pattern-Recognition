%% Loading in train data.
spam_train_dir = strcat( pwd, '\spam\train\');
ham_train_dir = strcat( pwd, '\ham\train\');

% Files from training set
spam_train_files = dir( spam_train_dir );
ham_train_files = dir( ham_train_dir );

% Get words
spam_train_words = countwords( spam_train_dir );
ham_train_words = countwords( ham_train_dir );

total = merge_ws( spam_train_words, ham_train_words );

%% New struct containing all data.
words = fields( total );

% Total word count per set
ham_train_count = 0;
spam_train_count = 0;

% Total distinct word count per set
ham_train_distinct_count = size( fields( ham_train_words ), 1 );
spam_train_distinct_count = size( fields( spam_train_words ), 1 );

% Total distinct word count
total_distinct_count = size( words, 1 );

% Struct with word counts
array = cell( total_distinct_count, 8 );
index = struct( total );

% Fill struct with [WORD, WORD_TOTAL_COUNT, WORD_COUNT_IN_SPAM, WORD_COUNT_IN_HAM, P(word) in SPAM, P(word) in ham, abs difference between Probabilities]
for i = 1:total_distinct_count,
    word = words(i);
    index.(word{1}) = i;
    %setfield( index(1), word, i );
    array{i,1} = word;
    array{i,2} = total.( word{1,1} );
    if isfield( spam_train_words, word{1,1} ) == 1
        array{i,3} = spam_train_words.( word{1,1} );
    else
        array{i,3} = 0;
    end
    spam_train_count = spam_train_count + array{i,3};
    
    if isfield( ham_train_words, word{1,1} ) == 1
        array{i,4} = ham_train_words.( word{1,1} );
    else
        array{i,4} = 0;
    end
    ham_train_count = ham_train_count + array{i,4};
end

% Total words in both sets.
total_train_count = spam_train_count + ham_train_count;

% Calculate probabilities
for i = 1:total_distinct_count,
    array{i,5} = log( array{i,3} / spam_train_count );
    array{i,6} = log( array{i,4} / ham_train_count );
    array{i,7} = log( ( array{i,3} + array{i,4} ) / total_train_count );
    array{i,8} = abs( array{i,5} - array{i,6} );
end

%%

p_ham = 1.0;
p_spam = 1.0;

features = cell();

