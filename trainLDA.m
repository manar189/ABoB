load('trainingFaces.mat')

% Number of classes
C = 16; 

% Eigenfaces
A = faces - meanAll;
L = A' * A;
[V, S] = eig(L);
sortedV = sortEigenvalues(V, diag(S));
U = A * sortedV(:, end-(N-C-1):end);

% sortedU = sortEigenvalues(U, diag(S));
% majorU = U(:, end-(N-C-1):end);
majorU = U;

% Project mu
% pMu = majorU'*mu;
pMeanAll = majorU'*meanAll;

% Initialize scatter matrices
Sb = zeros(N-C);
Sw = zeros(N-C);

% Iterate over each class, keeping track of the starting index in faces
mu = zeros(w*h, C);
start = 1;
for c = 1:C
    className = pad(int2str(c), 2, 'left', '0');
    Ni = length(dir("Pictures\LDA\" + className + "\*.jpg"));
    
    % Compute mu for the current class
    classFaces = faces(:, start:start+Ni-1);
    mu(:, c) = mean(classFaces, 2);
    
    % Project mu
    pMu = majorU'*mu(:, c);
    
    % Between class scatter matrix
    Sb = Sb + Ni * (pMeanAll - pMu)*(pMeanAll - pMu)';
    
    % Project faces of the current class
    pFaces = majorU'*classFaces;
    % Within class scatter matrix
    Ai = pFaces - pMu;
    Sw = Sw + Ai*Ai';
    
    start = start + Ni;
end

% Compute Fisher faces
[fisherU, fisherS] = eig(Sw, Sb);
F = majorU * fisherU(:, 1:c-1);

% Project mean faces for each class onto Fisher space
muW = F'*mu;

save('fisher.mat', 'F', 'muW')