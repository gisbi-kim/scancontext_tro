function H = EntropyOfVector(vec)

len = length(vec);

H = 0;
for ith=1:len
    pith = vec(ith);
    if(pith == 0)
        H = H + 0; % 0log0 = 0
    else
        H = H + ( -1 * (pith*log2(pith)) );
    end
end

end

