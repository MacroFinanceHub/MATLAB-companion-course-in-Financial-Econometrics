function [b,tstat,s2,VCV,VCV_white,R2,R2bar,yhat]=ols(y,x,c)
% PURPOSE
%   Estimate coefficients using OLS and many other properties of the fitted model
%
% INPUTS:
%   y - n by 1 vector containing the dependent variable
%   X - n by k matrix of regressors (should not contain a constant!)
%   c - Boolean (zero or one) indicating whether the model has a constant or not
%
% OUTPUT:
%   b          - Parameter estimates
%   tstat      - t-statistic of the estimated coefficients (using VCV)
%   s2         - Estimated variance of residual (uses n, not n-1)
%   VCV        - Homoskedastic VCV (Variance Covariance Matrix)
%   VCV_white  - White's Heteroskedasticity consistent VCV
%   R2         - R-squared
%   R2bar      - Degree of freedom adjusted R2
%   yhat       - Fitted values for y using the model
%
% Length of data:
n = length(y);
% Number of regressors:
k = size(x,2);
% Add constant if needed (note the difference between this IF and others we have done! We don't need
%to specify the condition because c is itself a Boolean variable):
if c
    x = [ones(n,1) x];
    k = k + 1;
end

% Compute OLS coefficients (using "\"):
b = x\y;
% Compute fitted values:
yhat = x*b;
% Compute errors:
e = y - yhat;
% Compute s2 (sum of squared residuals divided by n):
s2 = e'*e/n;
% Compute (X'*X)^(-1) (will need it later):
XX_inv = inv(x'*x/n);
% Compute homoskedastic covariance matrix:
VCV = s2 * XX_inv/n;
% Compute t-stat using homoskedastic VCV:
tstat = b./sqrt(diag(VCV));

% Now lets calculate White's Heteroskedastic Robust Covariance Matrix.
% First we calculate the term E[(e^2)x'x] (call it XEX):
XEX = zeros(k);
for i=1:n
    XEX = XEX + e(i,:).^2*x(i,:)'*x(i,:);
end
XEX = XEX/n;
% White's VCV:
VCV_white = XX_inv * XEX * XX_inv' / n;

% Demean y to get TSS (Total Sum of Squares) if the model has a constant:
if c
    y = y-mean(y);
end
% Compute R2 and R2bar:
R2 = 1 - (e'*e)/(y'*y);
R2bar = 1-(1-R2)*(n-1)/(n-k);
