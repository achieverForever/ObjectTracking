function [X, P] = kalman_predict(X, P, A, Q);
% [X, P] = kalman_predict(X, P, A, H, Q) projects the state and covariance 
% estimates forward from time step t to t+1.
%
% INPUT :
% X - STATE VECTOR ESTIMATE at time step t
% P - PRIORI ESTIMATE COVARIANCE at time step t
% A - TRANSITION MATRIX which projects X at time step t towards time step t+1
% Q - SYSTEM ERROR which is a zero mean gaussian distribution
%
% OUTPUT :
% X - STATE VECTOR ESTIMATE at time step t+1
% P - COVARIANCE ESTIMATE at time step t+1

% Predicted state 
X = A * X;	

% Predicted error covariance 
P = A * P * A' + Q;

return


