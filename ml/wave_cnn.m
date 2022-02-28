%csi = 4D matrix of CSI data captured    
%label = matrix of labels as integers
%num_gestures = number of distinct samples/classes

function [net_info, perf, trainedNet] = wave_cnn(csi,label, num_gestures)
    temp(:, :, 1, :) = csi;
    csi = temp;
    tic; % start time
    
    % prepare csi for training data
    csi_abs = abs(csi);
    csi_ang = angle(csi);
    csi_tensor = [csi_abs,csi_ang];
    
    %store labels as a categorical array
    word = categorical(label);

    t0 = toc; % pre-processing time
    
    [M,N,S,T] = size(csi_tensor);
    
    % [M,N,S,T]: CSI matrix for each instance
    % M = # CSI samples (200)
    % N = # subcarriers (30)
    % S = # antennas (1-3)
    % T = # total gesture samples (5520 total, 20 gestures)
    
    rng(42); % For reproducibility
    n_epoch = 10;
    learn_rate = 0.01;
    l2_factor = 0.01;
    
    % Convolutional Neural Network settings
    layers = [imageInputLayer([M N S]);
              convolution2dLayer(4,4,'Padding',0);
              batchNormalizationLayer();
              reluLayer();
              maxPooling2dLayer(4,'Stride',4); 
              fullyConnectedLayer(num_gestures);
              softmaxLayer();
              classificationLayer()];
                         
    % get training/testing input
    K = 5;
    cv = cvpartition(T,'kfold',K); % 20% for testing
    k = 1; % for k=1:K
    trainIdx = find(training(cv,k));
    testIdx = find(test(cv,k));
    trainCsi = csi_tensor(:,:,:,trainIdx);
    trainWord = word(trainIdx,1);
    testCsi = csi_tensor(:,:,:,testIdx);
    testWord = word(testIdx,1);
    valData = {testCsi,testWord};
    
    % training options for the Convolutional Neural Network
    options = trainingOptions('sgdm','ExecutionEnvironment','cpu',...
                          'MaxEpochs',n_epoch,...
                          'InitialLearnRate',learn_rate,...
                          'L2Regularization',l2_factor,...
                          'ValidationData',valData,...
                          'ValidationFrequency',10,...
                          'ValidationPatience',Inf,...
                          'Shuffle','every-epoch',...
                          'Verbose',false,...
                          'Plots','training-progress');

    [trainedNet,tr{k,1}] = trainNetwork(trainCsi,trainWord,layers,options);
    t1 = toc; % training end time

    [YTest, scores] = classify(trainedNet,testCsi);
    TTest = testWord;
    test_accuracy = sum(YTest == TTest)/numel(TTest);
    t2 = toc; % testing end time

    net_info = tr;
    perf = test_accuracy;
    

end