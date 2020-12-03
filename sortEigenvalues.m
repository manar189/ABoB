function [sortedEigVec] = sortEigenvalues(unsortedEigVec, unsortedEigVal)
%SORTEIGENVALUES Summary of this function goes here
%   Sorts the eigenvectors after the size of the eigenvalues

[~, ind] = sort(unsortedEigVal);
sortedEigVec = unsortedEigVec(:, ind);

end

