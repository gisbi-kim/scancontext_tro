ResultsDir = './pr_result/';

%%
title_str = strcat('KITTI 00');

%% Params 
FigIdx = 2;
figure(FigIdx); clf;

TopNindexes = [1];
name = 'top1';

nTopNindexes = length(TopNindexes);

%% Main 
SequenceNames = dir(ResultsDir); SequenceNames(1:2, :) = []; SequenceNames = {SequenceNames(:).name};
nSequences = length(SequenceNames);

all_Precisions = {};
all_Recalls = {};

for ithTopN = 1:nTopNindexes
    
    TopNidx = TopNindexes(ithTopN);
    
    line_width = 4;
    
    LineColors = colorcube(nSequences);
    LineColors = linspecer(nSequences,'qualitative');
%     LineColors = linspecer(nSequences,'sequential');
    LineColors = flipud(LineColors);

    AUCs = zeros(1, nSequences);
    for ithSeq = 1:nSequences

        % seq info 
        ithSeqName = SequenceNames{ithSeq};
        SequenceNames{ithSeq} = string(ithSeqName);
        
        ithSeqPath = strcat(ResultsDir, ithSeqName, '/');
        ithSeqPRcurveData = dir(ithSeqPath); ithSeqPRcurveData(1:2, :) = []; ithSeqPRcurveData = {ithSeqPRcurveData(:).name};

        % load 
        nCorrectRejectionsAll = load(strcat(ithSeqPath, ithSeqPRcurveData{1}));
        nCorrectRejectionsAll = nCorrectRejectionsAll.num_correct_rejections;
        nCorrectRejectionsForThisTopN = nCorrectRejectionsAll(TopNidx, :);

        nFalseAlarmsAll = load(strcat(ithSeqPath, ithSeqPRcurveData{2}));
        nFalseAlarmsAll = nFalseAlarmsAll.num_false_alarms;
        nFalseAlarmsForThisTopN = nFalseAlarmsAll(TopNidx, :);

        nHitsAll = load(strcat(ithSeqPath, ithSeqPRcurveData{3}));
        nHitsAll = nHitsAll.num_hits;
        nHitsForThisTopN = nHitsAll(TopNidx, :);

        nMissesAll = load(strcat(ithSeqPath, ithSeqPRcurveData{4}));
        nMissesAll = nMissesAll.num_misses;
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

        num_points = length(Precisions);
        Precisions(1) = 1;
        AUC = 0;
        for ith = 1:num_points-1    
            small_area = 1/2 * (Precisions(ith) + Precisions(ith+1)) * (Recalls(ith+1)-Recalls(ith));
            AUC = AUC + small_area;
        end
        AUCs(ithSeq) = AUC;
        
        all_Precisions{ithSeq} = Precisions;
        all_Recalls{ithSeq} = Recalls;        
        
        % draw 
        figure(FigIdx); 
        set(gcf, 'Position', [10 10 800 500]);
        
        fontsize = 10;
        p = plot(Recalls, Precisions, 'LineWidth', line_width); % commonly x axis is recall
        title(title_str, 'FontSize', fontsize);
        xlabel('Recall', 'FontSize', fontsize); ylabel('Precision', 'FontSize', fontsize);
        set(gca, 'FontSize', fontsize+5)
        xticks([0 0.2 0.4 0.6 0.8 1.0])
        xticklabels({'0','0.2','0.4','0.6','0.8','1'})
        yticks([0 0.2 0.4 0.6 0.8 1.0])
        yticklabels({'0','0.2','0.4','0.6','0.8','1'})

        p(1).Color = LineColors(ithSeq, :);
        p(1).MarkerEdgeColor = LineColors(ithSeq, :);
        % axis equal;
        xlim([0, 1]); ylim([0,1]);
        grid on; grid minor;
        hold on;
        
    end

    lgd = legend(SequenceNames, 'Location', 'best');
    lgd.FontSize = fontsize + 3;
    lgd.FontWeight = 'bold';

    grid minor;

    name = 'prcurve';
    print('-bestfit', name,'-dpdf')

end

