clc
clear all

[BCN]=xlsread('BC.xlsx','BC_normal','A2:AT22284');
[BCT]=xlsread('BC.xlsx','BC_tumor','A2:AS22284');
[x BCGenSymbol]=xlsread('BC.xlsx','BC_normal','B2:B22284');
BCGenSymbol(BCN(:,3)==1)=[];

[CRCN]=xlsread('CRC.xlsx','CRC_normal','A2:CW49387');
[CRCT]=xlsread('CRC.xlsx','CRC_tumor','A2:CW49387');
[x CRCGenSymbol]=xlsread('CRC.xlsx','CRC_normal','B2:B49387');
CRCGenSymbol(CRCN(:,3)==1)=[];

i=1;
j=1;
BCMN=zeros(size(BCGenSymbol,1),size(BCN,2));
BCMT=zeros(size(BCGenSymbol,1),size(BCT,2));
while(i<size(BCN,1))
    sn=BCN(i,:);
    st=BCT(i,:);
    c=1;
    i=i+1;

    while(and(i<size(BCN,1), BCN(i,3)==1))
        sn=sn+BCN(i,:);
        st=st+BCT(i,:);

        c=c+1;
        i=i+1;
    end
    
    BCMN(j,:)=sn./c;
    BCMT(j,:)=st./c;
    j=j+1;
end

BCMN(:,1:3)=[];
BCMT(:,1:3)=[];

i=1;
j=1;
CRCMN=zeros(size(CRCGenSymbol,1),size(CRCN,2));
CRCMT=zeros(size(CRCGenSymbol,1),size(CRCT,2));
while(i<size(CRCN,1))
    sn=CRCN(i,:);
    st=CRCT(i,:);
    c=1;
    i=i+1;

    while(and(i<size(CRCN,1), CRCN(i,3)==1))
        sn=sn+CRCN(i,:);
        st=st+CRCT(i,:);

        c=c+1;
        i=i+1;
    end
    
    CRCMN(j,:)=sn./c;
    CRCMT(j,:)=st./c;
    j=j+1;
end

CRCMN(:,1:3)=[];
CRCMT(:,1:3)=[];

i=1;
j=1;

while(i<=size(BCGenSymbol,1))
   sw=0;
   while(j<=size(CRCGenSymbol,1))
       if(strcmp(BCGenSymbol(i),CRCGenSymbol(j)))
           sw=1;
           break;
       else
           j=j+1;
       end
   end
   
   if(sw==0)
       BCGenSymbol(i)=[];
       BCMN(i,:)=[];
       BCMT(i,:)=[];
       j=i;
   else
       i=i+1;
   end
end

i=1;
j=1;

while(i<=size(CRCGenSymbol,1))
   sw=0;
   while(j<=size(BCGenSymbol,1))
       if(strcmp(CRCGenSymbol(i),BCGenSymbol(j)))
           sw=1;
           break;
       else
           j=j+1;
       end
   end
   
   if(sw==0)
       CRCGenSymbol(i)=[];
       CRCMN(i,:)=[];
       CRCMT(i,:)=[];
       j=i;
   else
       i=i+1;
   end
end



