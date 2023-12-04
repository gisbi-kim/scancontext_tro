clear

%% Path info 
Dataset = 'NCLT';
Method = 'SCI';
% ResultsDir = strcat('Result/', Dataset, '/', Method, '/');

ResultsDir = 'Result/';

%% Params 
FigIdx = 1;
figure(FigIdx); clf;

TopNindexes = [25];
nTopNindexes = length(TopNindexes);

%% Main 
SequenceNames = dir(ResultsDir); SequenceNames(1:2, :) = []; SequenceNames = {SequenceNames(:).name};
nSequences = length(SequenceNames);

for ithTopN = 1:nTopNindexes
    
    TopNidx = TopNindexes(ithTopN);
    
    for ithSeq = 1:nSequences

        % seq info 
        ithSeqName = SequenceNames{ithSeq};
        ithSeqPath = strcat(ResultsDir, ithSeqName, '/');
        ithSeqPRcurveData = dir(ithSeqPath); ithSeqPRcurveData(1:2, :) = []; ithSeqPRcurveData = {ithSeqPRcurveData(:).name};

        % load 
        nCorrectRejectionsAll = load(strcat(ithSeqPath, ithSeqPRcurveData{1}));
        nCorrectRejectionsAll = nCorrectRejectionsAll.nCorrectRejections;
        nCorrectRejectionsForThisTopN = nCorrectRejectionsAll(TopNidx, :);

        nFalseAlarmsAll = load(strcat(ithSeqPath, ithSeqPRcurveData{2}));
        nFalseAlarmsAll = nFalseAlarmsAll.nFalseAlarms;
        nFalseAlarmsForThisTopN = nFalseAlarmsAll(TopNidx, :);

        nHitsAll = load(strcat(ithSeqPath, ithSeqPRcurveData{3}));
        nHitsAll = nHitsAll.nHits;
        nHitsForThisTopN = nHitsAll(TopNidx, :);

        nMissesAll = load(strcat(ithSeqPath, ithSeqPRcurveData{4}));
        nMissesAll = nMissesAll.nMisses;
        nMissesForThisTopN = nMissesAll(TopNidx, :);

        % info 
        nTopNs = size(nCorrectRejectionsAll, 1);
        nThres = size(nCorrectRejectionsAll, 2);

        % main 
        Precisions = [];
        Recalls = [];
        Accuracies = [];
        for ithThres = 1:nThres
            nCorrectRejections = nCorrectRejectionsForThisTopN(ithThres);
            nFalseAlarms = nFalseAlarmsForThisTopN(ithThres);
            nHits = nHitsForThisTopN(ithThres);
            nMisses = nMissesForThisTopN(ithThres);
            
            nTotalTestPlaces = nCorrectRejections + nFalseAlarms + nHits + nMisses;
            
            Precision = nHits / (nHits + nFalseAlarms);
            Recall = nHits / (nHits + nMisses);
            Acc = (nHits + nCorrectRejections)/nTotalTestPlaces;
            
            Precisions = [Precisions; Precision];
            Recalls = [Recalls; Recall];
            Accuracies = [Accuracies; Acc];          
        end

        % draw 
        figure(FigIdx); 
        plot(Recalls, Precisions, 'LineWidth', 2); % commonly x axis is recall
        title('SCI at NCLT');
        xlabel('Recall'); ylabel('Precision');
        % axis equal;
        xlim([0, 1]); ylim([0,1]);
        grid on; grid minor;
        hold on;

    end

    lgd = legend(SequenceNames, 'Location', 'best');
    lgd.FontSize = 9;
    lgd.FontWeight = 'bold';


    %% save 
    % fileName = strcat('./results/', testDate, '_PRcurveWithEntropyThresVarying.png');
    % saveas(gcf, fileName)
    % 
    % fileName = strcat('./results/', testDate, '_EntireWorkSpace.mat');
    % save(fileName)

end


