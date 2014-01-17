function play_video(fname);
% play_video - display a video in a Matlab figure

video = myVideoReader(fname);
while nextFrame(video)
	f = getFrame(video);
	imshow(f);
	pause(0.01);
end
return