%% MATLAB Intro Review
% In today's class we will review some of most important concepts and commands that you saw with Max
%in Michaelmas. If we have any other topic you will like me to go over, send me an email an we will 
%go over in next week. 

%% Basic commands 
%To personalize your layout just go to: Home -> Layout
%We can also use the Preferences menu to change formats (e.g. Numeric Display)

% To open the command history:
commandhistory

% Some useful commands for the CW/Workspace:
x = exp (1) 
y = log (x); %With semicolon we don't display the variable
home %Gives us more space in the command window
clc %Clears command window
clear all %Clears all variables


%% Running Functions
% In coding, we usually call functions. In the case of MATLAB, these can be build-in function (as
%mean(), max() etc) or functions that we have created. Kevin's MFE toolbox is very useful because he
%has already coded for us many function which are cumbersome and complicated. This "toolbox" is
%nothing more than a folder with a bunch of MATLAB functions that we call at our will. 

% To check if we have the function we are interested in instaled, we can use the command "which":
which class_likelihood

% In order to call a function, we need to let MATLAB know about its path:
%Home-> Environment -> Set Path 
% Now lets a look at a simple likelihood function:
normal_likelihood(0,0,1)


%% Tables 
% Tables allow us to combine different data types in the same structure. We cannot have different
%data formats using regular matrices. 
load momentum
data = [date, mom_01, mom_02, mom_03, mom_04, mom_05, mom_06, mom_07, mom_08, mom_09, mom_10]; 
%Error! Regular matrices do not allow us to deal with different types of data. In order to do this,
%we will need to use Tables!
help table 
data = table(date, mom_01, mom_02, mom_03, mom_04, mom_05, mom_06, mom_07, mom_08, mom_09, mom_10)

% As you saw it with Max, to access info in tables we need curly brackets {}:
data{3,2:end}
% If we use parenthesis (), we build a sub-table using the information from the table:
data(1:10, [1, 2, 11])
% We can also use the names of the columns to select the data (using curly brackets):
data(1:10,{'date', 'mom_01', 'mom_10'})

% To build a table where the rows are different point in time we use the function "timetable":
time_data = timetable(mom_01, mom_02, mom_03, mom_04, mom_05, mom_06, mom_07, mom_08, mom_09, ...
                 mom_10, 'Rowtime', date) %See how we can use the "..."
% Since we already have the "data" table, we could have done:
time_data = table2timetable(data(:,2:end), 'RowTimes', date)

%% Logical operators (boodleans)
% Another important type of variable in coding are boodleans. These are variables that either take
%the value of 1 (true) or 0 (false). 
% When we use logical operators in MATLAB, we get boodleans as output. That is, logical operators 
%produce logical true (1) or logical false (0). 
% We can use these logical operators to count the number of "trues" for a given condition, and hence
%check the number of elements that respect this condition. For exaple, count the number of negative 
%returns in a given portfolio:
sum(mom_01<0)
% Or, more generally, counting the number of negative returns in each portfolio:
sum(data{:, 2:end}<0)

% We can use the function "find" to get the indices of the elements that respect a given condition:
find(mom_01<0)

%% For Loops
% Lets use some of the functions from Michaelmas to generate a random walk with a for loop.

clear all

% Using the function "randn" to generate a vector of standard normal random variables:
e = randn(100,1);
% Now creating the vector y:
rw1 = zeros(100,1);
% And start by setting the first element:
rw1(1,1) = e (1,1);
% Doing the loop:
for i=2:100
    
    rw1(i,1) = rw1(i-1,1) + e(i,1);
    
end
% We finally use the function "plot" to plot y:
plot(rw1)

% Alternativelly, we could have used the "cumsum" function:
help cumsum
rw2 = cumsum(e);
plot(rw2)

% More formally:
disp('Difference:')
disp(max(max(abs(rw1-rw2))))
