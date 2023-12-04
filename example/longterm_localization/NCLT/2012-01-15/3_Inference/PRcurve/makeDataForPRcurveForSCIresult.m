clear
addpath(genpath('./'));

%% Setup 
Dataset = 'NCLT';
Method = 'LearningSCI';
ResultDir = strcat('/media/gskim/IRAP-ADV1/Data/ICRA2019/Experiments/#. trunk/', Dataset, '/', Method, '/10m/results_predictionvectors/base0/');

NCLTTestDateNames = {'2012-02-04', '2012-03-17', '2012-05-26', '2012-06-15', '2012-08-20', '2012-09-28', '2012-10-28', '2012-11-16', '2013-02-23', '2013-04-05'};
nNCLTTestDates = length(NCLTTestDateNames);


%% Main 
for ithDate = 1:nNCLTTestDates
    
    TestDateName = NCLTTestDateNames{ithDate};

    % path 
    SeenGTs_Path = strcat(ResultDir, TestDateName, '_seen_GT.npy');
    SeenPredictions_Path = strcat(ResultDir, TestDateName, '_seen_predicted.npy');
    
    UnseenGTs_Path = strcat(ResultDir, TestDateName, '_unseen_GT.npy');
    UnseenPredictions_Path = strcat(ResultDir, TestDateName, '_unseen_predicted.npy');

    % load
    SeenGTs = double(readNPY(SeenGTs_Path));
    SeenPredictions = double(readNPY(SeenPredictions_Path));
    UnseenGTs = double(readNPY(UnseenGTs_Path));
    UnseenPredictions = double(readNPY(UnseenPredictions_Path));
    
    % info 
    nSeenPlaces = size(SeenGTs, 1);
    nUnseenPlaces = size(UnseenGTs, 1);

    % concate seen and unseen for convenience 
%     TotalGTs = [SeenGTs; UnseenGTs];
    TotalPredictions = [SeenPredictions; UnseenPredictions];
    TotalSeenFlags = [ ones(nSeenPlaces, 1); zeros(nUnseenPlaces, 1)]; % seen (1) or unseen (0)
    nTotalTestPlaces = nSeenPlaces + nUnseenPlaces;
    nTestData = nTotalTestPlaces;
    
    
    %% Main 

    % policy (top N)
    TopN = 25;
    TopNs = linspace(1, TopN, TopN);
    nTopNs = length(TopNs);

    % Entropy thresholds 
    Thresholds = linspace(0, 1, 200); 
    nThresholds = length(Thresholds);

    % Main variables to store the result for drawing PR curve 
    nHits = zeros(nTopNs, nThresholds); 
    nFalseAlarms = zeros(nTopNs, nThresholds); 
    nCorrectRejections = zeros(nTopNs, nThresholds); 
    nMisses = zeros(nTopNs, nThresholds);
    
    for ith=1:nTestData
        tic

        % Flag: Seen(1) or Unseen(0) 
        SeenOrUnseen = TotalSeenFlags(ith);

        % GT place idx (in this code, use it only for the seen case. thus knowing unseen place index is unnecessary in this case for PR curve analysis  
        if(SeenOrUnseen == 1)
            [dummy, ithTruthPlaceIdx] = max(SeenGTs(ith, :)); % but this idx is not the real place index, plz refer the scikitlearn label maker 
        else
            ithTruthPlaceIdx = nan;
        end
        
        % ith prediction vector
        ithPrediction = TotalPredictions(ith, :);    

        % entropy 
        EntropyOfPrediction = NormalizedEntropyOfVector(ithPrediction); % Entropy for module 1 (new place detection) 
        
        % top N predictions 
        [NearestSoftmaxOutputs, idxs] = sort(ithPrediction, 'descend');
        NearestPlaceIdxs = idxs(1:TopN); % as mentioned above: this idx is not the real place index, plz refer the scikitlearn label maker 


        for ithTopN = 1:nTopNs
            
            ithNearestPlaceIdxs = NearestPlaceIdxs(1:ithTopN);
            
            for ithThres = 1:nThresholds
                
                ithDistThreshold = Thresholds(ithThres);

                % main  
                if(EntropyOfPrediction >= ithDistThreshold) 
                % if over the theshold, it is considered unseen.
                % for unseen considered, no step 2 (recognition of place index), and just quit now. 
                    if(SeenOrUnseen == 0)
                        % TN: Correct Rejection
                        nCorrectRejections(ithTopN, ithThres) = nCorrectRejections(ithTopN, ithThres) + 1;
                    else            
                        % FN: MISS
                        nMisses(ithTopN, ithThres) = nMisses(ithTopN, ithThres) + 1; 
                    end
                else
                    % if under the theshold, it is considered seen.
                    % and then check the correctness
                    if( ismember(ithTruthPlaceIdx, ithNearestPlaceIdxs) )
                        % TP: Hit
                        nHits(ithTopN, ithThres) = nHits(ithTopN, ithThres) + 1;
                    else
                        % FP: False Alarm 
                        nFalseAlarms(ithTopN, ithThres) = nFalseAlarms(ithTopN, ithThres) + 1;            
                    end
                end

            end

        end

        message = strcat(num2str(ith), "/", num2str(nTestData), " of ", TestDateName);
        disp(message);
        toc

    end

    
    % save the results (PR curve is for the later.)
    savePath = strcat('Result/', TestDateName, '/');
    if(~(7==exist(savePath,'dir')))
        mkdir(savePath);
    end
    save(strcat(savePath, 'nCorrectRejections.mat'), 'nCorrectRejections');
    save(strcat(savePath, 'nMisses.mat'), 'nMisses');
    save(strcat(savePath, 'nHits.mat'), 'nHits');
    save(strcat(savePath, 'nFalseAlarms.mat'), 'nFalseAlarms');

end






