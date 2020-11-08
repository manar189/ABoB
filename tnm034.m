function faceId = tnm034(im)
%TNM034 Matches an input face image against a database of faces.
%   
%   im: Image of unknown face, RGB-image in uint8 format in the
%   range [0,255].
%
%   id: The identity number (integer) of the identified person,
%   i.e. ‘1’, ‘2’,…,‘16’ for the persons belonging to ‘db1’
%   and ‘0’ for all other faces.


normIm = detectFace(im);
faceId = classifyFace(normIm);

end


