function r = nextFrame(reader);
% nextFrame - return true if there more frames

r = get(reader, 'UserData') <= get(reader, 'NumberOfFrames');
return;
