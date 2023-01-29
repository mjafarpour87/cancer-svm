clc;
clear all;
warning off;

TrainPercent=70;

%BC
BC=xlsread('SelectedBestBCFeatures.xlsx','BC');
Normal=xlsread('SelectedBestBCFeatures.xlsx','Normal');

BCTrainSampleCount=round(TrainPercent*size(BC,2)/100);
NormalTrainSampleCount=round(TrainPercent*size(Normal,2)/100);

TrainSet=[BC(:,1:BCTrainSampleCount) Normal(:,1:NormalTrainSampleCount)];
TrainTarget=[ones(1,BCTrainSampleCount) 2.*ones(1,NormalTrainSampleCount)];
TestSet=[BC(:,BCTrainSampleCount+1:end) Normal(:,NormalTrainSampleCount+1:end)];
TestTarget=[ones(1,size(BC,2)-BCTrainSampleCount) 2.*ones(1,size(Normal,2)-NormalTrainSampleCount)];

net = feedforwardnet(10);
net = train(net,TrainSet,TrainTarget);
Target = net(TestSet);
Target=round(Target);

figure
hold on
gscatter(TestSet(1,:),TestSet(2,:),Target);
title('BC and Normal Classification Regions');
legend('BC','Normal');
axis tight
hold off

BC_Fitted_Percent_With_NN=100*sum(Target==TestTarget)/size(Target,2)

%CRC
CRC=xlsread('SelectedBestCRCFeatures.xlsx','CRC');
Normal=xlsread('SelectedBestCRCFeatures.xlsx','Normal');

BCTrainSampleCount=round(TrainPercent*size(CRC,2)/100);
NormalTrainSampleCount=round(TrainPercent*size(Normal,2)/100);

TrainSet=[CRC(:,1:BCTrainSampleCount) Normal(:,1:NormalTrainSampleCount)];
TrainTarget=[ones(1,BCTrainSampleCount) 2.*ones(1,NormalTrainSampleCount)];
TestSet=[CRC(:,BCTrainSampleCount+1:end) Normal(:,NormalTrainSampleCount+1:end)];
TestTarget=[ones(1,size(CRC,2)-BCTrainSampleCount) 2.*ones(1,size(Normal,2)-NormalTrainSampleCount)];

net = feedforwardnet(10);
net = train(net,TrainSet,TrainTarget);
Target = net(TestSet);
Target=round(Target);

figure
hold on
gscatter(TestSet(1,:),TestSet(2,:),Target);
title('CRC and Normal Classification Regions');
legend('CRC','Normal');
axis tight
hold off

CRC_Fitted_Percent_With_NN=100*sum(Target==TestTarget)/size(Target,2)

%BC CRC
BC=xlsread('SelectedBestFeatures.xlsx','BC');
CRC=xlsread('SelectedBestFeatures.xlsx','CRC');
Normal=xlsread('SelectedBestFeatures.xlsx','Normal');

BCTrainSampleCount=round(TrainPercent*size(BC,2)/100);
CRCTrainSampleCount=round(TrainPercent*size(CRC,2)/100);
NormalTrainSampleCount=round(TrainPercent*size(Normal,2)/100);

minCount=min([BCTrainSampleCount CRCTrainSampleCount NormalTrainSampleCount]);

TrainSet=[BC(:,1:BCTrainSampleCount) CRC(:,1:CRCTrainSampleCount) Normal(:,1:NormalTrainSampleCount)];
TrainTarget=[ones(1,BCTrainSampleCount) 2.*ones(1,CRCTrainSampleCount) 3.*ones(1,NormalTrainSampleCount)];
TestSet=[BC(:,BCTrainSampleCount+1:end) CRC(:,CRCTrainSampleCount+1:end) Normal(:,NormalTrainSampleCount+1:end)];
TestTarget=[ones(1,size(BC,2)-BCTrainSampleCount) 2.*ones(1,size(CRC,2)-CRCTrainSampleCount) 3.*ones(1,size(Normal,2)-NormalTrainSampleCount)];

net = feedforwardnet(10);
net = train(net,TrainSet,TrainTarget);
Target = net(TestSet);
Target=round(Target);

figure
hold on
gscatter(TestSet(1,:),TestSet(2,:),Target);
title('BC, CRC, and Normal Classification Regions');
legend('BC','CRC','Normal');
axis tight
hold off

BC_CRC_Fitted_Percent_With_SVM=100*sum(Target==TestTarget)/size(Target,2)
