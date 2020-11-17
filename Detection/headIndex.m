function [topRow] = findThreshold(skinMask)
%HEADINDEX Summary of this function goes here
%   This function returns the index of where the heads most left, right,
%   top and bottom point are taken from the faceMask. This is used for the
%   assumption that the mouth is in a specific area of the face.

[nRow, nCol] = size(skinMask);

%do some sum and take the first row
colSum = sum(skinMask, 1);
rowSum = sum(skinMask, 2);

%to find the top element
for i = 1:nRow
    if rowSum(i) >= 1
        topRow = i;
        break 
    end
end

%to find bottom element
for i = nRow:-1:1
    if rowSum(i) >= 1
        bottomRow = i;
        break 
    end
end

%need some transposing for the columns then do sum for each column
%apparently no need for transpose hehe
for i = 1:nCol
    if colSum(i) >= 1
        leftCol = i;
        break 
    end
end

%to find bottom element
for i = nCol:-1:1
    if colSum(i) >= 1
        rightCol = i;
        break 
    end
end

end

