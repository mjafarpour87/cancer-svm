clc;
clear all;
warning off;

FeaturesCount=10;
TrainPercent=70;

BC_Tumor=xlsread('SelectedCommonGene.xlsx','BC_Tumor');
BC_Normal=xlsread('SelectedCommonGene.xlsx','BC_Normal');
CRC_Tumor=xlsread('SelectedCommonGene.xlsx','CRC_Tumor');
CRC_Normal=xlsread('SelectedCommonGene.xlsx','CRC_Normal');

[x GenSymbol]=xlsread('SelectedCommonGene.xlsx','BC_Tumor','A2:A11594');
[x BCTitles]=xlsread('SelectedCommonGene.xlsx','BC_Tumor','A1:AQ1');
[x CRCTitles]=xlsread('SelectedCommonGene.xlsx','CRC_Tumor','A1:CU1');
[x NormalTitles]=xlsread('SelectedCommonGene.xlsx','CRC_Normal','A1:CU1');

BCTrainCount=round(size(BC_Tumor,2)*TrainPercent/100);
CRCTrainCount=round(size(CRC_Tumor,2)*TrainPercent/100);
NormalTrainCount=round(size(CRC_Normal,2)*TrainPercent/100);

BC_Normal_Mean=mean(BC_Normal(:,1:BCTrainCount),2);
CRC_Tumor_Mean=mean(CRC_Tumor(:,1:CRCTrainCount),2);
CRC_Normal_Mean=mean(CRC_Normal(:,1:NormalTrainCount),2);

Factor=CRC_Normal_Mean./BC_Normal_Mean;
Factor=repmat(Factor,1,size(BC_Tumor,2));
BC_Tumor_Scaled=BC_Tumor.*Factor;
BC_Tumor_Mean=mean(BC_Tumor_Scaled,2);

BCCRCNormalSum=BC_Tumor_Mean+CRC_Tumor_Mean+CRC_Normal_Mean;
BCFactor=BC_Tumor_Mean./BCCRCNormalSum;
CRCFactor=CRC_Tumor_Mean./BCCRCNormalSum;
NormalFactor=CRC_Normal_Mean./BCCRCNormalSum;

BCCRCDiff=abs(BCFactor-CRCFactor);
BCNormalDiff=abs(BCFactor-NormalFactor);
CRCNormalDiff=abs(CRCFactor-NormalFactor);
BCCRCNormalFactor=[BCCRCDiff BCNormalDiff CRCNormalDiff];
Shanon=sum(BCCRCNormalFactor.*log(1./BCCRCNormalFactor),2);

Indices=(1:size(Shanon,1))';
Data=[Indices Shanon];
Data=sortrows(Data,-2);
SelectedIndices=Data(1:FeaturesCount,1);

xlswrite('SelectedBestFeatures.xlsx',BC_Tumor_Scaled(SelectedIndices,:),'BC','B2');
xlswrite('SelectedBestFeatures.xlsx',CRC_Tumor(SelectedIndices,:),'CRC','B2');
xlswrite('SelectedBestFeatures.xlsx',CRC_Normal(SelectedIndices,:),'Normal','B2');

xlswrite('SelectedBestFeatures.xlsx',GenSymbol(SelectedIndices,:),'BC','A2');
xlswrite('SelectedBestFeatures.xlsx',GenSymbol(SelectedIndices,:),'CRC','A2');
xlswrite('SelectedBestFeatures.xlsx',GenSymbol(SelectedIndices,:),'Normal','A2');

xlswrite('SelectedBestFeatures.xlsx',BCTitles,'BC','A1');
xlswrite('SelectedBestFeatures.xlsx',CRCTitles,'CRC','A1');
xlswrite('SelectedBestFeatures.xlsx',CRCTitles,'Normal','A1');

figure
hold
plot(BC_Tumor_Scaled(SelectedIndices,1),BC_Tumor_Scaled(SelectedIndices,2),'rs');
plot(CRC_Normal(SelectedIndices,1),CRC_Normal(SelectedIndices,2),'bo');
plot(CRC_Tumor(SelectedIndices,1),CRC_Tumor(SelectedIndices,2),'gx');

