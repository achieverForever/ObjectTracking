%%%%%%%%%%%%%%%%%% Step 1 - Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
close all; 

fname = 'C:\Users\asus\Desktop\All in One\Object Tracking\Code\My\car-1.avi';

video = myVideoReader(fname);

% Load background image, by default the first frame
bk_img = getFrame(video);
% figure(1); subplot(142); imshow(uint8(bk_img), []); title('Background Image');
w = video.Width;
h = video.Height;
n = video.NumberOfFrames;

% Kalman filter initialization

MEASURE_NOISE_FACTOR = 6;
ESTIMATE_ERROR_FACTOR = 30;

X = [0; 0; 0; 0];	% System model (posX, posY, velX, velY)

Z = [0; 0];	% Measurement value

A = [1 0 1 0;	% Transition matrix
0 1 0 1;
0 0 1 0;
0 0 0 1];

H = [1 0 0 0;	% Measurement matrix
0 1 0 0];

P = ones(4) * ESTIMATE_ERROR_FACTOR;	% Estimate error covariance

Q = eye(4);	% Sytem noise

R = eye(2) * MEASURE_NOISE_FACTOR^2;	% Measurement noise


disp('Running...');

% Initialize the update rate and deviation of the background subtractor
p = 0.03;	% Update rate
sigma = 30;	% Difference threshold

img_bw = zeros(h, w);
img = zeros(h, w);
i = 0;
centrd = zeros(1, 2);
bbox = zeros(1, 4);
while(nextFrame(video))

%%%%%%%%%%%%%%%%%% Step 2 - Background Subtraction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	img = getFrame(video);	

	% Rolling average update
	bk_img = p * img + (1 - p) * bk_img;	

	img_bw = abs(bk_img - img) > sigma;


%%%%%%%%%%%%%%%%%%%%%%% Step 3 - Blob Extraction and Denoising %%%%%%%%%%%%%%%%%%%%%%%

	% Perform morphological operations to remove noisy pixels and fill the holes
    img_bw = imclose(img_bw, strel('rectangle', [5,5]));

	CC = bwconncomp(img_bw);
	L = labelmatrix(CC);

	stats = regionprops(L, 'Area', 'Centroid', 'BoundingBox');

	areas = [stats.Area];
	[value, idx] = max(areas);

	isDetected = 0;

	if idx > 0
		isDetected = 1;
		centrd = stats(idx).Centroid;
		bbox = stats(idx).BoundingBox;
	end


%%%%%%%%%%%%%%%%%%%% Step 4 - Kalman Filter Tracking %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	Z = centrd';	% Get the current measurement

	% Prediction
	[X, P] = kalman_predict(X, P, A, Q);

	% Correction if measurement exists
	if isDetected 
		[X, P] = kalman_correct(X, P, Z, H, R);
	end

	figure(1); subplot(142); imshow(uint8(img), []); title('Tracking')
	e_z = H * X;	% Get the estimate value
	e_x = e_z(1);
	e_y = e_z(2);
	
	if isDetected 
		bbox_w = bbox(3);
		bbox_h = bbox(4);
		rectangle('Position', [e_x-bbox_w*.5, e_y-bbox_h*.5, bbox_w, bbox_h], 'EdgeColor', 'g', 'LineWidth', 2);
		rectangle('Position', [Z(1)-3, Z(2)-3, 6, 6], 'EdgeColor', 'r', 'LineWidth', 2);
	else
		rectangle('Position', [e_x-5, e_y-5, 5, 5], 'EdgeColor', 'g', 'LineWidth', 2);
	end

	figure(1); subplot(141); imshow(uint8(img), []); title('Original');
	figure(1); subplot(143); imshow(uint8(img_bw), []); title('Backgournd Subtracted');
	figure(1); subplot(144); imshow(label2rgb(L)); title('Label Matrix');

	text(10, 10, num2str(i), 'Color', 'w');	% Display the frame number

	i = i + 1;
end

clear imgs;


