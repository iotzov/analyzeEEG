% saves some global settings
% review this file to set filenames and make sure that files and directories exist
settings

% generates EEGraw_?.mat files in each subject directory (m????????).
% Requires eeglab
egi2mat

% takes EEGraw_?.mat and generates EEGpp_?.mat. 
% Requires inexact_alm_rpca.m
preprocess

% generates subjects_data_ratings.mat. Works incrementally on new subjects only
% Required manual intervention. 
manual_ratings

% generates data volumes in movie directory for each movie and each subject category
merge

% computes ISC for different subject categories
ISC

%
results

