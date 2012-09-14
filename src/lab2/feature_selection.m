%% Loading in all files
spam_train_dir = strcat(pwd, '/spam/train/');
ham_train_dir = strcat(pwd, '/ham/train/');

% Files from training set
spam_train_files = dir( spam_train_dir );
ham_train_files = dir( ham_train_dir );

% Get words
spam_train_count = countwords( spam_train_dir );
ham_train_count = countwords( ham_train_dir );

total = merge_ws( spam_train_count, ham_train_count );

%%
words = fields( total );
array = cell( size( words, 1 ), 4 );

for i = 1:size(words,1),
    word = words(i);
    array{i,1} = word;
    array{i,2} = total.( word{1,1} );
    array{i,3} = spam_train_count.( word{1,1} );
    array{i,4} = ham_train_count.( word{1,1} );
end