function r = get_Image(fnames, i);
% getImage - Read in the i th image of the f_list and convert it to gray scale
r = double(rgb2gray(imread(fnames{i})));