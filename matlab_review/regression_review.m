%% MATLAB Linear Regression Review
% Check Max's answers to these questions.

%% Lets first load the factors data:
load FF_Data
y = FFResearchDataFactors{:,1};
x = FFResearchDataFactors{:,2:4};


%% Estimating a linear regression
% If we simply want to estimate coefficients of a linear projection, we can use "\":
betas = x\y

% But we are often interested in other properties, hence it is recommented to use a more complete
%function (see "ols" function):
[b,tstat,s2,VCV,VCV_white,R2,R2bar,yhat] = ols(y,x,0);

disp('T-Stats')
disp(tstat')
% Very large T-Stats idicating that the coefficients are highly significant. 

disp('Adjusted R-Squared:')
disp(diag(R2bar)')
% Although R2's are not the greatest measure of how good a model is, this model seems to be 
%explaining a fair amount of variation in the dependent variable.


%% Rolling Regression
clear all
clc

% Lets replicate the estimation of the parameters above as many times as possible using 60
%consecutive months at each time. 
% You already saw rolling regressions with both Matthias and Max. Now lets re-do exercise 48, but 
%try to do it using the "while" loop rather than the "for" loop. 

%First, lets load the data again:
load FF_Data
full_y = FFResearchDataFactors{:,1};
full_x = FFResearchDataFactors{:,2:4};

size = length(full_y);
betas = zeros(size-59,3);
i = 1;
while i<=(size-59)
    y = full_y(i:i+59);
    x = full_x(i:i+59, :);
    betas(i,:) = ols(y,x,0)'; %Note that since we just want the first output of the function we can
    %write that the estimated betas are equal to the OLS function. 
    i = i + 1;
end

%% Building the Plots
% Lets now redo exercise 48, but again trying to use "while" rather than "for" loops.

% In order to plot the betas for the full sample, we need to calculate them again:
b = ols(full_y,full_x,0);

% We will also need vector of the rolling variances for the rolling betas in order to constuct
%the asked "confidence interval". Lets do it in the same way we did for the rolling betas:
vars = zeros(size-59,3);
i = 1;
while i<=(size-59)
    y = full_y(i:i+59);
    x = full_x(i:i+59, :);
    [~, ~, ~, ~, VCVW] = ols(y,x,0); %Now getting White's VCV as the 5th output of our OLS function.
    vars(i,:) = diag(VCVW)'; %Then using the elements on the diagonal of the variance covariance 
    %matrix to construct our series of variances.
    i=i+1;
end
var_60 = mean(vars); %Taking the mean of all vars estimated using 60 months.

%Plotting the rolling betas and the constants:
titles = {'MKT Factor','SMB Factor','HML Factor'};
i=1;
figure()
while i<=3
    subplot(3,1,i)
    const = ones(length(betas(:,i)), 1) * b(i); %Creating the "constant" (beta(i) estimated using
    %the full sample) to plot with the rolling beta(i).
    CI_up = const + 1.96 * sqrt(var_60(i)); %Creating the upper band constant.
    CI_down = const - 1.96 * sqrt(var_60(i)); %Creating the lower band constant.
    plot([betas(:,i), const, CI_up, CI_down])
    title(titles{i})
    axis tight
    i=i+1;
end

