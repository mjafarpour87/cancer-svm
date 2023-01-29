clc;
clear all;
warning off;

FeaturesCount=10;
TrainPercent=70;

BC_Tumor=xlsread('SelectedCommonGene.xlsx','BC_Tumor');
BC_Normal=xlsread('SelectedCommonGene.xlsx','BC_Normal');

[x GenSymbol]=xlsread('SelectedCommonGene.xlsx','BC_Tumor','A2:A11594');
[x BCTitles]=xlsread('SelectedCommonGene.xlsx','BC_Tumor','A1:AQ1');
[x NormalTitles]=xlsread('SelectedCommonGene.xlsx','BC_Normal','A1:AQ1');

BCTrainCount=round(size(BC_Tumor,2)*TrainPercent/100);

BC_Mean=mean(BC_Tumor(:,1:BCTrainCount),2);
Normal_Mean=mean(BC_Normal(:,1:BCTrainCount),2);

BCNormalFactor=abs(log(BC_Mean./Normal_Mean));

Indices=(1:size(BCNormalFactor,1))';
Data=[Indices BCNormalFactor];
Data=sortrows(Data,-2);
SelectedIndices=Data(1:FeaturesCount,1);

xlswrite('SelectedBestBCFeatures.xlsx',BC_Tumor(SelectedIndices,:),'BC','B2');
xlswrite('SelectedBestBCFeatures.xlsx',BC_Normal(SelectedIndices,:),'Normal','B2');

xlswrite('SelectedBestBCFeatures.xlsx',GenSymbol(SelectedIndices,:),'BC','A2');
xlswrite('SelectedBestBCFeatures.xlsx',GenSymbol(SelectedIndices,:),'Normal','A2');

xlswrite('SelectedBestBCFeatures.xlsx',BCTitles,'BC','A1');
xlswrite('SelectedBestBCFeatures.xlsx',NormalTitles,'Normal','A1');

figure
hold
plot(BC_Tumor(SelectedIndices,1),BC_Tumor(SelectedIndices,2),'ro');
plot(BC_Normal(SelectedIndices,1),BC_Normal(SelectedIndices,2),'bx');

