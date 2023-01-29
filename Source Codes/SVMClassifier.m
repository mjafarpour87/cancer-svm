clc;
clear all;
close all;
warning off;

TrainPercent=70;

%BC
BC=xlsread('SelectedBestBCFeatures.xlsx','BC');
Normal=xlsread('SelectedBestBCFeatures.xlsx','Normal');

BCTrainSampleCount=round(TrainPercent*size(BC,2)/100);
NormalTrainSampleCount=round(TrainPercent*size(Normal,2)/100);

TrainSet=[BC(:,1:BCTrainSampleCount) Normal(:,1:NormalTrainSampleCount)]';
TrainTarget=[ones(1,BCTrainSampleCount) 2.*ones(1,NormalTrainSampleCount)]';
TestSet=[BC(:,BCTrainSampleCount+1:end) Normal(:,NormalTrainSampleCount+1:end)]';
TestTarget=[ones(1,size(BC,2)-BCTrainSampleCount) 2.*ones(1,size(Normal,2)-NormalTrainSampleCount)]';

SVMModel=fitcsvm(TrainSet,TrainTarget);
Target=predict(SVMModel,TestSet);

figure
hold on
gscatter(TestSet(:,1),TestSet(:,2),Target);
title('BC and Normal Classification Regions');
legend('BC','Normal');
axis tight
hold off

BC_Fitted_Percent_With_SVM=100*sum(Target==TestTarget)/size(Target,1)

%CRC
CRC=xlsread('SelectedBestCRCFeatures.xlsx','CRC');
Normal=xlsread('SelectedBestCRCFeatures.xlsx','Normal');

CRCTrainSampleCount=round(TrainPercent*size(CRC,2)/100);
NormalTrainSampleCount=round(TrainPercent*size(Normal,2)/100);

TrainSet=[CRC(:,1:CRCTrainSampleCount) Normal(:,1:NormalTrainSampleCount)]';
TrainTarget=[ones(1,CRCTrainSampleCount) 2.*ones(1,NormalTrainSampleCount)]';
TestSet=[CRC(:,CRCTrainSampleCount+1:end) Normal(:,NormalTrainSampleCount+1:end)]';
TestTarget=[ones(1,size(CRC,2)-CRCTrainSampleCount) 2.*ones(1,size(Normal,2)-NormalTrainSampleCount)]';

SVMModel=fitcsvm(TrainSet,TrainTarget);
Target=predict(SVMModel,TestSet);

figure
hold on
gscatter(TestSet(:,1),TestSet(:,2),Target);
title('CRC and Normal Classification Regions');
legend('CRC','Normal');
axis tight
hold off

CRC_Fitted_Percent_With_SVM=100*sum(Target==TestTarget)/size(Target,1)


%BC CRC
BC=xlsread('SelectedBestFeatures.xlsx','BC');
CRC=xlsread('SelectedBestFeatures.xlsx','CRC');
Normal=xlsread('SelectedBestFeatures.xlsx','Normal');

BCTrainSampleCount=round(TrainPercent*size(BC,2)/100);
CRCTrainSampleCount=round(TrainPercent*size(CRC,2)/100);
NormalTrainSampleCount=round(TrainPercent*size(Normal,2)/100);

minCount=min([BCTrainSampleCount CRCTrainSampleCount NormalTrainSampleCount]);

TrainSet=[BC(:,1:minCount) CRC(:,1:minCount) Normal(:,1:minCount)]';
TrainTarget=[ones(1,minCount) 2.*ones(1,minCount) 3.*ones(1,minCount)]';
TestSet=[BC(:,minCount+1:end) CRC(:,minCount+1:end) Normal(:,minCount+1:end)]';
TestTarget=[ones(1,size(BC,2)-minCount) 2.*ones(1,size(CRC,2)-minCount) 3.*ones(1,size(Normal,2)-minCount)]';

% SVMModel=fitcsvm(TrainSet',TrainTarget');
% Target=predict(SVMModel,TestSet');

SVMModels = cell(3,1);
classes = unique(TrainTarget);
% rng(1); % For reproducibility

% For Test Samples
for j = 1:numel(classes)
    indx = (TrainTarget==classes(j)); % Create binary classes for each classifier
    SVMModels{j} = fitcsvm(TrainSet,indx,'ClassNames',[false true],'Standardize',true,...
        'KernelFunction','rbf','BoxConstraint',1);
end

Scores = zeros(size(TestTarget,1),numel(classes));

for j = 1:numel(classes)
    [~,score] = predict(SVMModels{j},TestSet);
    Scores(:,j) = score(:,2); % Second column contains positive-class scores
end

[~,Target] = max(Scores,[],2);

figure
hold on
gscatter(TestSet(:,1),TestSet(:,2),Target);
title('BC, CRC, and Normal Classification Regions');
legend('BC','CRC','Normal');
axis tight
hold off

BC_CRC_Fitted_Percent_With_SVM=100*sum(Target==TestTarget)/size(Target,1)
