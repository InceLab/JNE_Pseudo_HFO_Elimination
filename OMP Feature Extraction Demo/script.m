clc
clear
close all
%% Add path to Functions
s = pwd;
path_to_Data = strcat(s,'\','Data_Needed');
path_to_function = strcat(s,'\','Function_Needed');
addpath(path_to_Data);
addpath(path_to_function);
Base = path_to_Data;
List = dir(fullfile(Base, '*.mat*'));

%% Load Data

load('Example_Events.mat');
no = 1;
dat = Example.HFO(:,no);
%% Create the Dictionary
% Stopping criteria for adaptive sparse representation
stop.L.iter = 15;
stop.L.Res = 0.01;
stop.L.DRes = 0.005;
stop.R.crs = 4;
stop.R.iter = 5;
stop.R.DRes = 0.01;
stop.FR.crs = 4;
stop.FR.iter = 5;
stop.FR.DRes = 0.01;

N = size(dat,1);
[~,DL,DR,DF] = Create_Dictionary(N,2000);
Dict.DL = DL.Atom;
Dict.DR = DR.Atom;
Dict.DF = DF.Atom;
Dict.frq.DL = DL.frq;
Dict.frq.DR = DR.frq;
Dict.frq.DF = DF.frq;

%% OMP Feature Extraction
filename = sprintf('Example_of_Events_HFO_%.f',no);

%% OMP
OMP_reconst_draw(dat(:,no),Dict,fs,filename);