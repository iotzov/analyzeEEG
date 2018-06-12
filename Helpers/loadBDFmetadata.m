function [metaBDF,HDR] = loadBDFmetadata(filename)
if nargin < 1
    filename = '..\data\bdffiles\2017\02.bdf';
end
%% jenma/jmad 2018

metaBDF.filename = filename;

% create struct for biosig
input.FileName = filename;
input.FLAG.OVERFLOWDETECTION = 0;

%use biosig to open and read the BDF file
HDR = sopen(input,'r');
triggerchannels = HDR.NS;

% only read triggerchannel
HDR = sopen(input,'r',triggerchannels);

% get some meta from header
metaBDF.Nsec = HDR.NRec; %length of recording
metaBDF.fs = HDR.SampleRate; %sampling frequency

% read the triggerchannel
[data,HDR] = sread(HDR, inf); %read all the data there are
sclose(HDR);

% extract triggers from the raw channel [sample, triggervalue]
triggerchannel_computer = bitand(2^8-1, data); %8 bit encoding
triggerchannel_stimtracker = bitand(2^8-1, bitshift(data,-8)); %16 bit encoding

%%
% triggerchannel = bitand(,data(:,end));
metaBDF.triggers.raw_computer = [find(triggerchannel_computer),find(triggerchannel_computer)/metaBDF.fs,triggerchannel_computer(triggerchannel_computer~=0)];
metaBDF.triggers.raw_stimtracker = [find(triggerchannel_stimtracker),find(triggerchannel_stimtracker)/metaBDF.fs,triggerchannel_stimtracker(triggerchannel_stimtracker~=0)];

% biosig toolbox automatically reads the trigger channel [sample, triggervalue]
metaBDF.triggers.biosig = [HDR.EVENT.POS HDR.EVENT.POS/HDR.EVENT.SampleRate HDR.EVENT.TYP];