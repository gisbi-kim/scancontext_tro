function NormalizedH = NormalizedEntropyOfVector(vec)

len = length(vec);

% max entropy 
maxEntropy = -len*(1/len * log2(1/len));

H = 0;
for ith=1:len
    pith = vec(ith);
    if(pith == 0)
        H = H + 0; % 0log0 = 0
    else
        H = H + ( -1 * (pith*log2(pith)) );
    end
end

% return 
NormalizedH = H/maxEntropy;

end

