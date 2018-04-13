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

%% insert HACK!!! be warned
data_t = [(1:size(data,1))' data];

%these thresholds are set based on observations of he values in the trigger values
triggers_below = data_t(data_t(:,end)<=526336,:); 
triggers_above = data_t(data_t(:,end)>526336,:);

triggers_above(:,end) = bitand(2^8-1,triggers_above(:,end)); %8 bit encoding
triggers_below(:,end) = bitand(2^16-1,triggers_below(:,end)); %16 bit encoding

triggerchannel = [triggers_below; triggers_above];

[~,idx] = sort(triggerchannel(:,1));
triggerchannel = triggerchannel(idx,2);

%%
% triggerchannel = bitand(,data(:,end));
metaBDF.triggers.raw = [find(triggerchannel),find(triggerchannel)/metaBDF.fs,triggerchannel(triggerchannel~=0)];

% biosig toolbox automatically reads the trigger channel [sample, triggervalue]
metaBDF.triggers.biosig = [HDR.EVENT.POS HDR.EVENT.POS/HDR.EVENT.SampleRate HDR.EVENT.TYP];

