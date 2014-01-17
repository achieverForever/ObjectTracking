function [X, P] = kalman_correct(X, P, Z, H, R);
% [X, P] = kalman_correct(X, P, Z, H, R) calculates the difference between our 
% predicted and mesured states, then we calculate the Kanman Gain K, which is
% used to weight between predicted and measured states according to the ratio 
% between the Measurement Error Covariance R and the Priori Estimate Covariance P
% For example, the less the Measurement Error Covariance R, the more trusted the actual
% measurement Zt+1. On the other hand, the less the Priori Estimate Covariance P, the 
% more trusted the predicted measurement H * Xk.
%
% INPUT :
% X - STATE VECTOR ESTIMATE at time step t
% P - PRIORI ESTIMATE COVARIANCE at time step t
% Z - Actual MEASUREMENT at time step t+1
% H - TRANSITION MATRIX
% R - MEASUREMENT NOISE
%
% OUTPUT :
% X - STATE VECTOR at time step t+1 (combined with prediction and measurement)
% P - COVARIANCE at time step t+1

I = eye(size(X, 1));

% Measurement error/innovation(difference between predicted and measured states)
y = Z - H * X;

% Kalman Gain
K = P * H' * inv((H * P * H' + R));

% Correct our prediction using Kalman Gain
X = X + K * y

% Update Priori Estimate Covariance
P = (I - K * H) * P;

return


