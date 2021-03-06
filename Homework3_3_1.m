%%
clear all
close all
[xTrain, tTrain, xValid, tValid, xTest, tTest] = LoadMNIST(3);
%%
layers = [imageInputLayer([28 28 1])
fullyConnectedLayer(100)
reluLayer   
fullyConnectedLayer(100)
reluLayer 
fullyConnectedLayer(10)
softmaxLayer
classificationLayer];

options = trainingOptions( 'sgdm', ...
    'Momentum', 0.9, ...
    'MaxEpochs',200, ...
    'ValidationData', {xValid,tValid}, ...
    'InitialLearnRate', 0.01, ...
    'Shuffle', 'every-epoch',...
    'MiniBatchSize', 8192, ...
    'ValidationFrequency', 30, ...
    'ValidationPatience', 5);

trainedNet = trainNetwork(xTrain,tTrain, layers,options) ;
%%
[predictedTrain,trainScores] = classify(trainedNet,xTrain);
[predictedValidation,validationScores] = classify(trainedNet,xValid);
[predictedTest,testScores] = classify(trainedNet,xTest);

%%
%Classification Error Computation
counterTrain = 0;
counterValid = 0;
counterTest = 0;
for i=1:size(tTrain)
    if(tTrain(i)~=predictedTrain(i))
        counterTrain = counterTrain+1;
    end
end
C_train = (1/size(tTrain,1)) * counterTrain;

for i=1:size(tTest)
    if(tTest(i)~=predictedTest(i))
        counterTest = counterTest+1;
    end
end
C_test = (1/size(tTest,1)) * counterTest;

for i=1:size(tValid)
    if(tValid(i)~=predictedValidation(i))
        counterValid = counterValid+1;
    end
end
C_valid = (1/size(tValid,1)) * counterValid;