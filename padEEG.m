function [padded] = padEEG(padStart, padEnd, eegData)

	padded = eegData.data;
	fs = eegData.srate
	fwdS = eegData.event.latency(1)/fs;
	fwdE = eegData.event.latency(2)/fs;
	bwdS = eegData.event.latency(3)/fs;
	bwdE = eegData.event.latency(4)/fs;
