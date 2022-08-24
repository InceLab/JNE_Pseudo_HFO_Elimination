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
N = size(dat,1); % Length of dictionary
[~,DL,DR,DF] = Create_Dictionary(N,2000); % create the Gabor dictionary at 2000 Hz sampling frequency
Dict.DL = DL.Atom;
Dict.DR = DR.Atom;
Dict.DF = DF.Atom;
Dict.frq.DL = DL.frq;
Dict.frq.DR = DR.frq;
Dict.frq.DF = DF.frq;

%% OMP Feature Extraction
filename = sprintf('Example_of_Events_HFO_%.f',no);

%% OMP
OMP_reconst_draw(dat(:,no),Dict,fs,filename); % OMP process with Gabor Dictionary