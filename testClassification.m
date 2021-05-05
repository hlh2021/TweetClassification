
addpath('nlp lib\funcs')

fid = fopen('dataset\clean_content.txt');
tline = fgets(fid);

corpus_array = {};

corpus_array{end + 1} = tline;

while ischar(tline)
    %disp(tline)
    tline = fgets(fid);
    corpus_array{end + 1} = tline;
end

fclose(fid);

featureVector = featurize(corpus_array(1 : end - 1)', 500, 0, 0);


rand_shuffle = randperm(size(featureVector, 1));

featureVector = featureVector(rand_shuffle, :);

feat_tf = featureVector;

fid = fopen('dataset\topic.txt');
tline = fgets(fid);

label_array = {};

label_array{end + 1} = tline;

while ischar(tline)
    %disp(tline)
    tline = fgets(fid);
    label_array{end + 1} = tline;
end

fclose(fid);

[aa_label, ~, label]= unique(label_array(1:end-1));

label = label(rand_shuffle);

nfold = 5;


rng(1);

output = mycrossvalidate2(label, label, nfold);



% %% Random Forest
% 
% all_samples = 0;
% 
% correct_predict = 0;
% 
% for i = 1 : nfold
% 
% %     fprintf('Fold %d...', i);
% 
% B = TreeBagger(50, featureVector(output{i, 1}, :), label(output{i, 1}), 'OOBPred', 'Off');
% 
% % oobErrorBaggedEnsemble = oobError(B);
% % 
% % plot(oobErrorBaggedEnsemble)
% 
% [pred, score] = predict(B, featureVector(output{i, 3}, :));
% 
% num_pred = [];
% 
% for j = 1 : length(pred)
%     num_pred(j, 1) = str2num(pred{j});
% end
% 
% correct_predict = correct_predict + sum(num_pred == label(output{i, 3}));
% 
% all_samples = all_samples + length(output{1, 3});
% %     fprintf('Done \n');
% 
% end
% 
% acc_rf_without = correct_predict / all_samples;
% fprintf('Random Forest with TC feature: %g\n', acc_rf_without);
% 
%% SVM

all_samples = 0;

correct_predict = 0;

for i = 1 : nfold
    
%     fprintf('Fold %d...', i);

% svm = fitcecoc(featureVector(output{i, 1}, :), label(output{i,1}));
t1 = templateSVM('Standardize',1,'KernelFunction','gaussian');
svm = fitcecoc(featureVector(output{i, 1}, :), label(output{i,1}), 'Learners', t1);

% oobErrorBaggedEnsemble = oobError(B);
% 
% plot(oobErrorBaggedEnsemble)

[pred, score] = predict(svm, featureVector(output{i, 3}, :));

num_pred = [];

correct_predict = correct_predict + sum(pred == label(output{i, 3}));

all_samples = all_samples + length(output{1, 3});

% fprintf('Done \n');

end

acc_svm_without = correct_predict / all_samples;
fprintf('SVM with TC feature: %g\n', acc_svm_without);



%%

feature_terms = [30, 40, 50, 60, 70, 80, 90,100];
for iter = 1 : size(feature_terms, 2)
    terms = feature_terms(iter);
    fprintf('feature freq: %g\n', terms);

fid = fopen('dataset\keywords.txt');
tline = fgets(fid);

corpus_array = {};

corpus_array{end + 1} = tline;

while ischar(tline)
    %disp(tline)
    tline = fgets(fid);
    corpus_array{end + 1} = tline;
end

fclose(fid);

feat_key = featurize_key(corpus_array(1 : end - 1)', terms, 0, 0);

fid = fopen('dataset\entities.txt');
tline = fgets(fid);

corpus_array = {};

corpus_array{end + 1} = tline;

while ischar(tline)
    %disp(tline)
    tline = fgets(fid);
    corpus_array{end + 1} = tline;
end

fclose(fid);

feat_entity = featurize_key(corpus_array(1 : end - 1)', terms, 0, 0);

featureVector = [0.5*feat_key, feat_entity];
% featureVector = [feat_key];
% featureVector = [feat_entity];

missing_mask = sum(featureVector') == 0;



fid = fopen('dataset\topic.txt');
tline = fgets(fid);

label_array = {};

label_array{end + 1} = tline;

while ischar(tline)
    %disp(tline)
    tline = fgets(fid);
    label_array{end + 1} = tline;
end

fclose(fid);

[aa_label, ~, label]= unique(label_array(1:end-1));

featureVector(missing_mask, :) = [];

label(missing_mask, :) = [];

fprintf('data size: %g\n', size(featureVector, 1));
fprintf('feature vocabulary size: %g\n', size(featureVector, 2));

rng(1);

output = mycrossvalidate2(label, label, nfold);
%%
% % Random Forest
% 
% all_samples = 0;
% 
% correct_predict = 0;
% 
% for i = 1 : nfold
% 
% %     fprintf('Fold %d...', i);
% 
% B = TreeBagger(50, featureVector(output{i, 1}, :), label(output{i, 1}), 'OOBPred', 'Off');
% 
% % oobErrorBaggedEnsemble = oobError(B);
% % 
% % plot(oobErrorBaggedEnsemble)
% 
% [pred, score] = predict(B, featureVector(output{i, 3}, :));
% 
% num_pred = [];
% 
% for j = 1 : length(pred)
%     num_pred(j, 1) = str2num(pred{j});
% end
% 
% correct_predict = correct_predict + sum(num_pred == label(output{i, 3}));
% 
% all_samples = all_samples + length(output{1, 3});
% %     fprintf('Done \n');
% 
% end
% 
% fprintf('Random Forest with LLDA feature: %g\n', correct_predict / all_samples);

%% SVM

all_samples = 0;

correct_predict = 0;

for i = 1 : nfold
    
%     fprintf('Fold %d...', i);

% svm = fitcecoc(featureVector(output{i, 1}, :), label(output{i,1}));
t = templateSVM('Standardize',1,'KernelFunction','gaussian');
svm = fitcecoc(featureVector(output{i, 1}, :), label(output{i,1}), 'Learners', t);

% oobErrorBaggedEnsemble = oobError(B);
% 
% plot(oobErrorBaggedEnsemble)

[pred, score] = predict(svm, featureVector(output{i, 3}, :));

num_pred = [];

correct_predict = correct_predict + sum(pred == label(output{i, 3}));

all_samples = all_samples + length(output{1, 3});

% fprintf('Done \n');

end

fprintf('SVM with LLDA feature: %g\n', correct_predict / all_samples);


end


%%
%CNN

% run('D:\Documents\MATLAB\matconvnet\matlab\vl_setupnn.m');
% 
% fid = fopen('dataset\clean_content.txt');
% tline = fgets(fid);
% 
% corpus_array = {};
% 
% corpus_array{end + 1} = tline;
% 
% while ischar(tline)
%     %disp(tline)
%     tline = fgets(fid);
%     corpus_array{end + 1} = tline;
% end
% 
% fclose(fid);
% 
% featureVector = featurize2(corpus_array(1 : end - 1)', 100, 0, 0);
% 
% 
% 
% fid = fopen('dataset\topic.txt');
% tline = fgets(fid);
% 
% label_array = {};
% 
% label_array{end + 1} = tline;
% 
% while ischar(tline)
%     %disp(tline)
%     tline = fgets(fid);
%     label_array{end + 1} = tline;
% end
% 
% fclose(fid);
% 
% [aa_label, ~, label]= unique(label_array(1:end-1));
% 
% 
% nfold = 5;
% 
% 
% rng(1);
% 
% output = mycrossvalidate2(label, label, nfold);
% 
% 
% all_samples = 0;
% 
% correct_predict = 0;
% 
% for i = 1 : nfold
%     
%     fprintf('Fold %d...', i);
%     
%     acc = TextCNNTrain(featureVector(:, :, 1, output{i, 1}), label(output{i, 1}), featureVector(:, :, 1, output{i, 3}), label(output{i, 3}));
% 
%     correct_predict = correct_predict + acc(2) - acc(1);
% 
%     all_samples = all_samples + acc(2);
% 
%     fprintf('Done \n');
% 
% end
% 
% fprintf('CNN with Learned feature: %g\n', correct_predict / all_samples);

