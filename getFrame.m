function r = getFrame(reader)
% getFrame - read the next frame from a stateful VideoReader

    frame = get(reader, 'UserData');
    r = read(reader, get(reader, 'UserData'));
    r = double(rgb2gray(r));
    set(reader, 'UserData', frame + 1);
return