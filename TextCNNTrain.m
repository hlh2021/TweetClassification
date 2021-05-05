function acc = TextCNNTrain(train_feat, train_label, val_feat, val_label)




curpartition = [1*ones(length(train_label),1); 3*ones(length(val_label),1)];


imdb.images.data = single(cat(4, train_feat, val_feat));
imdb.images.data_mean = 0;
imdb.images.labels = single([train_label', val_label']);
imdb.images.set = curpartition;
imdb.meta.sets = {'train', 'val'} ;
imdb.meta.classes = {'no';'yes'};

[~, info] = mycnncore(imdb);

[~, idx] = min(info.val.error2(:, 1)./info.val.error2(:, 2));

acc = info.val.error2(idx, :);










function [net, info] = mycnncore(imdb)
% CNN_MNIST  Demonstrated MatConNet on MNIST




opts.dataDir = fullfile('data','mnist') ;
opts.expDir = fullfile('data','mnist-baseline') ;
delete( fullfile(opts.expDir,'*.*'));
opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');
opts.train.batchSize = 200 ;
opts.train.numEpochs = 80 ;
opts.train.continue = true ;
% opts.train.useGpu = true ;
opts.train.gpus = [] ;
opts.train.learningRate = [0.03*ones(1, 18000) 0.01*ones(1, 20) 0.001*ones(1,15)]  ;
%opts.train.learningRate = [0.001*ones(1, 10) 0.0001*ones(1, 200) 0.0001*ones(1,15)]  ;
opts.train.expDir = opts.expDir ;
%opts = vl_argparse(opts, varargin) ;

% --------------------------------------------------------------------
%                                                         Prepare data
% --------------------------------------------------------------------


% Define a network similar to LeNet
f=1/100 ;
net.layers = {} ;

%118
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', f*randn(174,38,1,128, 'single'), ...
                           'biases', zeros(1, 128, 'single'), ...
                           'stride', 1, ...
                           'pad', 0) ;
%                       net.layers{end+1} = struct('type', 'relu') ;
% net.layers{end+1} = struct('type', 'pool', ...
%                            'method', 'max', ...
%                            'pool', [1 2], ...
%                            'stride', 2, ...
%                            'pad', 0) ;

 
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', f*randn(1, 1, 128, 256, 'single'),...
                           'biases', zeros(1, 256,'single'), ...
                           'stride', 1, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', f*randn(1,1,256, 10, 'single'), ...
                           'biases', zeros(1, 10, 'single'), ...
                           'stride', 1, ...
                           'pad', 0) ;
                       %net.layers{end+1} = struct('type', 'relu') ;
                   
net.layers{end+1} = struct('type', 'softmaxloss') ;
% --------------------------------------------------------------------
%                                                                Train
% --------------------------------------------------------------------

% Take the mean out and make GPU if needed
net.normalization.averageImage = mean(imdb.images.data,4);
imdb.images.data = bsxfun(@minus, imdb.images.data, net.normalization.averageImage) ;
if opts.train.gpus ~= []
  imdb.images.data = gpuArray(imdb.images.data) ;
end

[net, info] = cnn_train(net, imdb, @getBatch, ...
    opts.train, ...
    'val', find(imdb.images.set == 3)) ;

% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;

% --------------------------------------------------------------------

