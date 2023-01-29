clc;
clear all;
warning off;

FeaturesCount=10;
TrainPercent=70;

CRC_Tumor=xlsread('SelectedCommonGene.xlsx','CRC_Tumor');
CRC_Normal=xlsread('SelectedCommonGene.xlsx','CRC_Normal');

[x GenSymbol]=xlsread('SelectedCommonGene.xlsx','CRC_Tumor','A2:A11594');
[x CRCTitles]=xlsread('SelectedCommonGene.xlsx','CRC_Tumor','A1:CU1');
[x NormalTitles]=xlsread('SelectedCommonGene.xlsx','CRC_Normal','A1:CU1');

CRCTrainCount=round(size(CRC_Tumor,2)*TrainPercent/100);

CRC_Mean=mean(CRC_Tumor(:,1:CRCTrainCount),2);
Normal_Mean=mean(CRC_Normal(:,1:CRCTrainCount),2);

CRCNormalFactor=abs(log(CRC_Mean./Normal_Mean));

Indices=(1:size(CRCNormalFactor,1))';
Data=[Indices CRCNormalFactor];
Data=sortrows(Data,-2);
SelectedIndices=Data(1:FeaturesCount,1);

xlswrite('SelectedBestCRCFeatures.xlsx',CRC_Tumor(SelectedIndices,:),'CRC','B2');
xlswrite('SelectedBestCRCFeatures.xlsx',CRC_Normal(SelectedIndices,:),'Normal','B2');

xlswrite('SelectedBestCRCFeatures.xlsx',GenSymbol(SelectedIndices,:),'CRC','A2');
xlswrite('SelectedBestCRCFeatures.xlsx',GenSymbol(SelectedIndices,:),'Normal','A2');

xlswrite('SelectedBestCRCFeatures.xlsx',CRCTitles,'CRC','A1');
xlswrite('SelectedBestCRCFeatures.xlsx',NormalTitles,'Normal','A1');

figure
hold
plot(CRC_Tumor(SelectedIndices,1),CRC_Tumor(SelectedIndices,2),'ro');
plot(CRC_Normal(SelectedIndices,1),CRC_Normal(SelectedIndices,2),'gx');

