function r = myVideoReader(fname);
% myVideoReader - create a stateful mmreader object.

r = mmreader(fname);
set(r, 'UserData', 1);
return
