%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ASSIGNMENT TYPE AND NUMBER: In-Class Activity #1
% PROGRAM PURPOSE: Calculating data set average and plot data set values
% AUTHOR: Ian McKinney
% DATE: 1/18/21
% CREDIT TO(if applicable):

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clear workspace and command window
clear, clc

% STEP 1: DEFINE THE PROBLEM
% Daily Temperature Average
% Program reads data from file, calculates temp. average, plots temps vs
% time
 
% GIVENS: Temperature and time data (Excel file) 
% FIND: Average temperature AND Plot temp.vs time

% Getting data from file:
tempData = readmatrix('temps24hrs.xlsx');
% Store name of data file in variable filename
% This step is not necessary but it makes the program more flexible


% Extract data from Excel file, store in variable "tempData"
% Note that ONLY NUMERIC DATA is retrieved

 
% In order to calculate the average, we need the temperature data
% All data from the file was imported as one matrix; 
% therefore, some data preparation is
% needed before we can perform the calculation

% Extract temperature data from tempData, store in variable "temps"
% The temp data is located in column 2 of tempData
temps = tempData(:, 2);

% Extract time data from tempData, store in variable "hours"
% The time data is located in column 1 of tempData
hours = tempData(:, 1);

% STEP 2: DIAGRAMS (NOT APPLICABLE)

% STEP 3: THEORY
% To calculate the average of a dataset, we must add all elements and then
% divide the sum by the size of the dataset (number of elements)

% STEP 4: ASSUMPTIONS
% Not needed here, this is a very simple problem

% STEP 5: SOLUTION STEPS
% Calculates temperature average by adding all elements and diving 
% by number of elements 
% tempsAve = sum(temps)/numel(temps);

% A more efficient way is to use MATLAB library function mean()
tempsAve = mean(tempData);

% STEP 6: IDENTIFY RESULTS
% Display result (average daily temperatures)
fprintf('The average daily temperatures in F is %.1f \n', tempsAve)
 
% Display daily temperature chart - plot(x,y)
plot(hours, temps)
title('Daily Temperatures')
xlabel('Hours')
ylabel('Temps (F)')
