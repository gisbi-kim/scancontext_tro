function [files] = osdir(path)
    files = dir(path); files(1:2) = []; files = {files(:).name};
end

