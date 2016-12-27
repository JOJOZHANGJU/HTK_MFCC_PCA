%PCA for .MFCC in HTK

%%%%%Load Training Data%%%%%%
[trDataPaths] = textread('Train.txt','%s');
[teDataPaths] = textread('Test.txt','%s');
savePath = '';
[trRow,trCols] = size(trDataPaths);
[teRow,teCols] = size(teDataPaths);
trDataAll = [];
for tr = 1:trRow
    trDataPath = trDataPaths{tr};
    trDataFiles = dir(fullfile(trDataPath,'*.mfcc'));

    TR = cell(length(trDataFiles),1);
    for TRNUM = 1:length(trDataFiles)
        TR{TRNUM,1} = trDataFiles(TRNUM).name;
    end
    [TRSort,TRIndex] = sort_nat(TR);
    trDataWord = [];
    for r = 1:length(trDataFiles)
        trDataFile =  TRSort{r};
        [trData,trFp,trDt,trTc,trT]=readhtk([trDataPath,'\',trDataFile]);
        trWord{r}=trData;
        trDataWord = cat(1,trWord{:});
    end
    dataAll{tr} = trDataWord;
    trDataAll = cat(1,dataAll{:});
end

%%%%%%%%PCA%%%%%%%%%
[mappedX, mapping] = pca(trDataAll, 45);

%%%%%%%For Test Data%%%%%%
for te = 1:teRow
    teDataPath = teDataPaths{te};
    teDataFiles = dir(fullfile(teDataPath,'*.mfcc'));
    te = cell(length(teDataFiles),1);
    for TENUM = 1:length(teDataFiles)
        TE{TENUM,1} = teDataFiles(TENUM).name;
    end
    [TESort,TEIndex] = sort_nat(TE);
    for e = 1:length(teDataFiles)
        teDataFile =  TESort{e};
        [teData,teFp,teDt,teTc,teT]=readhtk([teDataPath,'\',teDataFile]);
		teData=bsxfun(@minus, teData, mean(trDataAll));
        transd = teData * mapping.M;
		writehtk([savePath,teDataFile],transd,teFp,teTc);
    end
end













