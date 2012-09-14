%% Loading in all files
spam_train_dir = strcat(pwd, '/spam/train/');
ham_train_dir = strcat(pwd, '/ham/train/');

% Files from training set
spam_train_files = dir( spam_train_dir );
ham_train_files = dir( ham_train_dir );

% Get words
spam_train_count = countwords( spam_train_dir );
ham_train_count = countwords( ham_train_dir );
