% Defines and saves some shared settings. BE SURE TO EXECUTE this code
% AFTER EDITING, else the other programs will not see your new settings! 
% Some variables could be had directly from the data, but
% this is a bit easier to read.  

clear all

path_glob           = '../CMI-data/';
movies_dir          = [path_glob 'movies/'];
subject_rating_file = [path_glob 'subjects_data_ratings.mat'];
behaviorfile        = [path_glob 'crossCollapse_2015-04-07_02-04-09.xlsx'];

% define EOG and EEG channels
load([path_glob 'chan111.mat'],'chan111')
chan_eog = [1 32 8 14 17 21 25 125:128];
chan_eeg = setdiff(chan111,chan_eog); 
clear chan111 % no needed anymore
electrode_loc_file  = [path_glob 'GSN-HydroCel-129.sfp'];

% define democraphic categories we are interested in
category(1).demographic = 'DEM_001'; category(1).range = [ 8 11]; category(1).name = 'age-08-11';
category(2).demographic = 'DEM_001'; category(2).range = [12 15]; category(2).name = 'age-12-15';
category(3).demographic = 'DEM_002'; category(3).range = [ 1  1]; category(3).name = 'male';
category(4).demographic = 'DEM_002'; category(4).range = [ 2  2]; category(4).name = 'female';
category(5).demographic = 'DEM_002'; category(5).range = [ 1  2]; category(5).name = 'all';
conditions_to_run = 1:5; % you may pick a subset if you dont have the time. 

% desired sampling rate (data will be resameled to this rate)
fsref = 125; % Hz

movies(1).name='Diary of a Wimpy Kid Trailer';         movies(1).acronym='Wimpy';
movies(2).name='EHow Math';                            movies(2).acronym='EMath';
movies(3).name='Fun with Fractals';                    movies(3).acronym='Fract';
movies(4).name='Pre Algebra Lesson';                   movies(4).acronym='Algeb';
movies(5).name='Reading Lesson';                       movies(5).acronym='Read';
movies(6).name='Three Little Kittens - Despicable Me'; movies(6).acronym='DesMe';
M=length(movies); % we expect at most 6 eeg files per subject called EEGppmerg_?.mat


save settings % everything is needed, and what is not, we deleted already