function goodEyes = mouthEyeDist(mouth,eyes)
%MOUTHEYEDIST Returns eye positions that have others within similar
%distance from mouth.
%   Detailed explanation goes here

thresh = 4;
goodEyes = [];
for i = 1:size(eyes,1)
    dist1 = norm(mouth - eyes(i,:));
    for j = 1:size(eyes,1)
        % Don't check if same eye
        if(i ~= j)
            dist2 = norm(mouth - eyes(j,:));
            % Checks if distace between eyes is less than thresh
            if(abs(dist1 - dist2) < thresh)
                goodEyes = [goodEyes;i j];
                break;
            end
        end
        
    end
end

end

