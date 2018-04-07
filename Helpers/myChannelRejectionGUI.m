% Function by Jens Madsen

function myChannelRejectionGUI(eeg,fs,badchannels,filename_badchannels,filename_location)
if nargin < 1
    samples = 10000;
    channels = 64;
    eeg = randn(samples,channels)*20;
end
if nargin < 2
    fs = 512;
end
if nargin < 4
    filename_location = './helpers/mes_coord.loc';
    filename_badchannels = 'badchannels.mat';
    badchannels = [];
    close
end
if nargin < 3
%     badchannels = [1 2 3];
end

Nchannels = size(eeg,2);
%% read channel information
if exist(filename_location,'file')
    fid = fopen(filename_location);
    channel_info = textscan(fid,'%s %s %s %s');
    channel_no = cellfun(@(s) str2double(s), channel_info{1});
    channel_names = cellfun(@(s) strrep(s,'.',''), channel_info{4},'UniformOutput',false);
    fclose(fid);
else
    channel_names = cell(Nchannels,1);
    channel_no = (1:Nchannels)';
end

%%
fprintf('Performing manual channel rejects...')

figureHandle = figure('WindowButtonDownFcn',@myFigureCallback,'Visible','on','Name',sprintf('Channel Rejection'),'units', 'normalized', ...
    'OuterPosition',[0 0.04 1 0.95],'Toolbar','none', 'Resize','on','MenuBar','none', 'color', [1 1 1],'DeleteFcn',@myDeleteFcn,'KeyPressFcn',@myKeyPressFcn);

% see of the bad channel file already exist and load it
if ~isempty(filename_badchannels) && exist(filename_badchannels,'file')
    figureHandle.UserData.BadChannels = importdata(filename_badchannels);
else
    if ~isempty(badchannels)
        if size(badchannels,1)==1, badchannels = badchannels'; end
        figureHandle.UserData.BadChannels = badchannels;
    else
        figureHandle.UserData.BadChannels = [];
    end
end

%% handle bad segment table data i.e. excel sheet specifying which segments should be removed
% figureHandle.UserData.BadSegment = false;

%% load all the data into the figure userdata to see betweeen callbacks
figureHandle.UserData.fs = fs;
figureHandle.UserData.channel_names = channel_names;
figureHandle.UserData.channel_no = channel_no;
figureHandle.UserData.channel_plotnames = cellfun(@(c,d) ['(' c ') ' num2str(d)],figureHandle.UserData.channel_names,num2cell(figureHandle.UserData.channel_no),'UniformOutput',false);
figureHandle.UserData.orig_data = eeg(1:(floor(size(eeg,1)/2)*2),:);
figureHandle.UserData.plot_data = figureHandle.UserData.orig_data;
figureHandle.UserData.Nsamples = size(figureHandle.UserData.orig_data,1);
figureHandle.UserData.maxSample = figureHandle.UserData.Nsamples-1;
figureHandle.UserData.minSample = 0;
figureHandle.UserData.maxTime = figureHandle.UserData.maxSample/figureHandle.UserData.fs;
figureHandle.UserData.minTime = figureHandle.UserData.minSample/figureHandle.UserData.fs;
figureHandle.UserData.TimeAxis = (figureHandle.UserData.minSample:figureHandle.UserData.maxSample)./figureHandle.UserData.fs;
figureHandle.UserData.plotLine_upper = [];
figureHandle.UserData.plotLine_lower = [];
figureHandle.UserData.Nchannels = size(figureHandle.UserData.orig_data,2);
figureHandle.UserData.maxVal = max(max(figureHandle.UserData.orig_data(:)));
figureHandle.UserData.minVal = min(min(figureHandle.UserData.orig_data(:)));
figureHandle.UserData.CurrentChannel = [];
if ~isempty(filename_badchannels)
    figureHandle.UserData.badchannel_savefilename = filename_badchannels;
else
    figureHandle.UserData.badchannel_savefilename = [];
end
figureHandle.UserData.histogram_interval = linspace(figureHandle.UserData.minVal,figureHandle.UserData.maxVal,50);
figureHandle.UserData.caxis = [-100, 100];
figureHandle.UserData.ylim_spectrum = [-80, 10];

%% pre compute histograms and spectra
for iChannel = 1:figureHandle.UserData.Nchannels
    figureHandle.UserData.histograms(iChannel,:) = hist(figureHandle.UserData.plot_data(:,iChannel),figureHandle.UserData.histogram_interval);
    figureHandle.UserData.spectra_Y(iChannel,:) = fft(figureHandle.UserData.plot_data(:,iChannel),figureHandle.UserData.Nsamples)/figureHandle.UserData.Nsamples;
    figureHandle.UserData.dbPower(iChannel) = db(std(figureHandle.UserData.plot_data(:,iChannel)));
end

figureHandle.UserData.spectra_f = linspace(0,figureHandle.UserData.fs/2,figureHandle.UserData.Nsamples/2+1);

%% create some uicontrols
pbh = uicontrol(figureHandle,'Style', 'pushbutton','Tag','pushbutton', 'String', 'Select channel','units', 'normalized','FontSize',15,'Position', [0.27 0.9 0.07 0.07], 'Callback',@mySelectbuttonCallback);
pbh_save = uicontrol(figureHandle,'Style', 'pushbutton','Tag','savebutton', 'String', 'Save and exit','units', 'normalized','FontSize',15,'Position', [0.35 0.9 0.07 0.07], 'Callback',@mySavebuttonCallback);
pbh_zero = uicontrol(figureHandle,'Style', 'pushbutton','Tag','zerobutton', 'String', 'Zero and replot','units', 'normalized','FontSize',15,'Position', [0.27 0.78 0.07 0.07], 'Callback',@myZerobuttonCallback);
pbh_reset = uicontrol(figureHandle,'Style', 'pushbutton','Tag','resetbutton', 'String', 'Reset','units', 'normalized','FontSize',15,'Position', [0.35 0.78 0.07 0.07], 'Callback',@myResetbuttonCallback);
% cbh_badsegment = uicontrol(figureHandle,'Style', 'checkbox','Tag','badsegment','Value',double(figureHandle.UserData.BadSegment), 'String', 'Bad segment','units', 'normalized','FontSize',15,'BackgroundColor', [1 1 1],'Position', [0.43 0.78 0.07 0.03], 'Callback',@myBadsegmentcheckboxCallback);
lbh = uicontrol(figureHandle,'Style', 'listbox','Tag','listbox', 'units', 'normalized','FontSize',15,'Position', [0.51 0.77 0.1 0.22],'String',figureHandle.UserData.BadChannels);

%% create some axis
axesHandle_EEG = axes('Position',[0.04 0.2 0.95 0.55],'Tag','EEG data','HitTest','off');drawnow
axesHandle_Hist = axes('Position',[0.04 0.78 0.2 0.2],'Tag','Histogram','HitTest','off', 'Xtick',[],'Ytick',[],'Title','Channel histogram');drawnow
axesHandle_Series = axes('Position',[0.04 0.05 0.95 0.1],'Tag','EEG timeseries','HitTest','off', 'Xtick',[],'Ytick',[]);drawnow
axesHandle_Spectrum = axes('Position',[0.65 0.80 0.3 0.18],'Tag','Spectrum','HitTest','off', 'Xtick',[],'Ytick',[],'Title','Spectrum');drawnow

%% plot eeg on the image
ip1 = imagesc(axesHandle_EEG,figureHandle.UserData.TimeAxis,figureHandle.UserData.channel_no,eeg','HitTest','off'); drawnow, set(axesHandle_EEG,'Tag','EEG data');
caxis(axesHandle_EEG,figureHandle.UserData.caxis )
set(axesHandle_EEG,'YTick',figureHandle.UserData.channel_no)
set(axesHandle_EEG,'YTickLabels',figureHandle.UserData.channel_plotnames)
set(axesHandle_EEG,'YMinorTick','off')

%% set some properties on the different axes
set(axesHandle_EEG,'Ydir','Normal')
set(axesHandle_EEG,'TickLength',[0 0])
hold(axesHandle_EEG,'on');
ylabel(axesHandle_EEG,'Channels')
xlabel(axesHandle_Series,'Time [sec]')
set(axesHandle_Series,'TickLength',[0 0])
xlabel(axesHandle_Spectrum,'Frequency [Hz]')
ylim(axesHandle_Spectrum,figureHandle.UserData.ylim_spectrum)
waitfor(figureHandle) %this pauses the command prompt until the figure has been closed

% handles the checkbox if the segment is 'bad' or 'good'
% function myBadsegmentcheckboxCallback(checkboxHandle,eventdata)
% figureHandle = get(checkboxHandle,'Parent');
% if figureHandle.UserData.BadSegment == true
%     figureHandle.UserData.BadSegment = false;
% else
%     figureHandle.UserData.BadSegment = true;
% end

%% this function handles all keypressed
function myKeyPressFcn(figureHandle,eventdata)
switch get(figureHandle,'CurrentKey')
    case 'uparrow'
        if ~isempty(figureHandle.UserData.CurrentChannel)
            figureHandle.UserData.CurrentChannel = min(figureHandle.UserData.CurrentChannel+1,figureHandle.UserData.Nchannels);
            draw_points(figureHandle);
        end
    case 'downarrow'
        if ~isempty(figureHandle.UserData.CurrentChannel)
            figureHandle.UserData.CurrentChannel = max(figureHandle.UserData.CurrentChannel-1,1);
            draw_points(figureHandle);
        end
    case {'s','space'}
        childrenHandles = get(figureHandle,'Children');
        buttonHandle = childrenHandles(cellfun(@(s) contains(s,'pushbutton'), arrayfun(@(s) s.Tag,childrenHandles,'UniformOutput',false)));
        mySelectbuttonCallback(buttonHandle,eventdata)
end

function badchannels = myDeleteFcn(figureHandle,eventdata)
badchannels = figureHandle.UserData.BadChannels;
bla = 1;

%% the reset button
function myResetbuttonCallback(buttonHandle,eventdata)
% first get all the handles for the different axis in the figure
figureHandle = get(buttonHandle,'Parent');
axesHandle  = get(figureHandle,'Children');
axesHandle_EEG = axesHandle(cellfun(@(s) contains(s,'EEG data'), arrayfun(@(s) s.Tag,axesHandle,'UniformOutput',false)));
childrenHandles = get(figureHandle,'Children');
listboxHandle = childrenHandles(cellfun(@(s) contains(s,'listbox'), arrayfun(@(s) s.Tag,childrenHandles,'UniformOutput',false)));

%reset the data and badchannels
figureHandle.UserData.plot_data = figureHandle.UserData.orig_data;
figureHandle.UserData.BadChannels = [];

% re-compute all histograms and spectra
figureHandle.UserData.maxVal = max(max(figureHandle.UserData.plot_data(:)));
figureHandle.UserData.minVal = min(min(figureHandle.UserData.plot_data(:)));
figureHandle.UserData.histogram_interval = linspace(figureHandle.UserData.minVal,figureHandle.UserData.maxVal,50);

for iChannel = 1:figureHandle.UserData.Nchannels
    figureHandle.UserData.histograms(iChannel,:) = hist(figureHandle.UserData.plot_data(:,iChannel),figureHandle.UserData.histogram_interval);
    figureHandle.UserData.spectra_Y(iChannel,:) = fft(figureHandle.UserData.plot_data(:,iChannel),figureHandle.UserData.Nsamples)/figureHandle.UserData.Nsamples;
    figureHandle.UserData.dbPower(iChannel) = db(std(figureHandle.UserData.plot_data(:,iChannel)));
end

%plot the reset eeg data
imagesc(axesHandle_EEG,figureHandle.UserData.TimeAxis,1:figureHandle.UserData.Nchannels,figureHandle.UserData.plot_data','HitTest','off'); drawnow, set(axesHandle_EEG,'Tag','EEG data');

%reset the listbox with badchannels
listboxHandle.String = figureHandle.UserData.BadChannels;

%% simply zeros out the selected channels and replots the eeg channels
function myZerobuttonCallback(buttonHandle,eventdata)
% first get all the handles for the different axis in the figure
figureHandle = get(buttonHandle,'Parent');
axesHandle  = get(figureHandle,'Children');
axesHandle_EEG = axesHandle(cellfun(@(s) contains(s,'EEG data'), arrayfun(@(s) s.Tag,axesHandle,'UniformOutput',false)));

% zero out data of the selected channels
figureHandle.UserData.plot_data(:,figureHandle.UserData.BadChannels) = 0;

%replot the data
imagesc(axesHandle_EEG,figureHandle.UserData.TimeAxis,1:figureHandle.UserData.Nchannels,figureHandle.UserData.plot_data','HitTest','off'); drawnow, set(axesHandle_EEG,'Tag','EEG data');

%set the axis again
caxis(axesHandle_EEG,figureHandle.UserData.caxis)

% recomputes the histograms and spectra when they are now zerod out
figureHandle.UserData.maxVal = max(max(figureHandle.UserData.plot_data(:)));
figureHandle.UserData.minVal = min(min(figureHandle.UserData.plot_data(:)));
figureHandle.UserData.histogram_interval = linspace(figureHandle.UserData.minVal,figureHandle.UserData.maxVal,50);

for iChannel = 1:figureHandle.UserData.Nchannels
    figureHandle.UserData.histograms(iChannel,:) = hist(figureHandle.UserData.plot_data(:,iChannel),figureHandle.UserData.histogram_interval);
    figureHandle.UserData.spectra_Y(iChannel,:) = fft(figureHandle.UserData.plot_data(:,iChannel),figureHandle.UserData.Nsamples)/figureHandle.UserData.Nsamples;
end

%% save the data and close the figure
function mySavebuttonCallback(buttonHandle,eventdata)
try
    fprintf('Saving bad channels...')
    figureHandle = get(buttonHandle,'Parent');
    badchannels = figureHandle.UserData.BadChannels;
    if ~isempty(figureHandle.UserData.badchannel_savefilename)
        save(figureHandle.UserData.badchannel_savefilename,'badchannels');
    end
    
%     if isfield(figureHandle.UserData,'badsegment_savefilename')
%         fprintf('Saving bad segments...')
%         if figureHandle.UserData.BadSegment
%             toWrite = {'Remove'};
%         else
%             toWrite = {''};
%         end
%         xlswrite(figureHandle.UserData.badsegment_savefilename,toWrite,'Sheet1',figureHandle.UserData.BadSegment_excelposition)
%     end
    fprintf('Done\n')
    close(figureHandle)
catch
    fprintf('Failed\n')
end


function mySelectbuttonCallback(buttonHandle,eventdata)
figureHandle = get(buttonHandle,'Parent');
if ~isempty(figureHandle.UserData.CurrentChannel)
%     fprintf('You selected channel %d\n',figureHandle.UserData.CurrentChannel)
end
childrenHandles = get(figureHandle,'Children');
listboxHandle = childrenHandles(cellfun(@(s) contains(s,'listbox'), arrayfun(@(s) s.Tag,childrenHandles,'UniformOutput',false)));
figureHandle.UserData.BadChannels = unique([figureHandle.UserData.BadChannels; figureHandle.UserData.CurrentChannel]);
listboxHandle.String = figureHandle.UserData.BadChannels;
bla = 1;

%% callback handling all button presses on the figure
function myFigureCallback(figureHandle,eventdata)
% first get all the handles for the different axis in the figure
axesHandle  = get(figureHandle,'Children');
axesHandle_EEG = axesHandle(cellfun(@(s) contains(s,'EEG data'), arrayfun(@(s) s.Tag,axesHandle,'UniformOutput',false)));

% get the coordinates of the buttonpress
coordinates = get(axesHandle_EEG,'CurrentPoint');
selectedChannel = round(coordinates(1,2)); %can only select an integer channel
selectedTime = coordinates(1,1);

% only react if the buttonpress is on the eeg axes
if (selectedTime>figureHandle.UserData.minSample && selectedTime<figureHandle.UserData.maxSample && selectedChannel>=1 && selectedChannel<=figureHandle.UserData.Nchannels)
    figureHandle.UserData.CurrentChannel = selectedChannel;
    draw_points(figureHandle)
end

%% function handling drawing on the eeg axes, histogram and spectra
function draw_points(figureHandle)
% first get all the handles for the different axis in the figure
axesHandle  = get(figureHandle,'Children');
axesHandle_EEG = axesHandle(cellfun(@(s) contains(s,'EEG data'), arrayfun(@(s) s.Tag,axesHandle,'UniformOutput',false)));
axesHandle_Hist = axesHandle(cellfun(@(s) contains(s,'Histogram'), arrayfun(@(s) s.Tag,axesHandle,'UniformOutput',false)));
axesHandle_Series = axesHandle(cellfun(@(s) contains(s,'EEG timeseries'), arrayfun(@(s) s.Tag,axesHandle,'UniformOutput',false)));
axesHandle_Spectrum = axesHandle(cellfun(@(s) contains(s,'Spectrum'), arrayfun(@(s) s.Tag,axesHandle,'UniformOutput',false)));

%% plot the selected channel
% delete plot line if its already in the figure
if ~isempty(figureHandle.UserData.plotLine_upper)
    delete(figureHandle.UserData.plotLine_upper)
end
if ~isempty(figureHandle.UserData.plotLine_lower)
    delete(figureHandle.UserData.plotLine_lower)
end

hold(axesHandle_EEG,'on')
axesHandle_Tag = axesHandle_EEG.Tag;
figureHandle.UserData.plotLine_upper = plot(axesHandle_EEG,[figureHandle.UserData.minTime figureHandle.UserData.maxTime],[figureHandle.UserData.CurrentChannel+0.5 figureHandle.UserData.CurrentChannel+0.5],'Color',[1 1 1],'LineWidth',1);
figureHandle.UserData.plotLine_lower = plot(axesHandle_EEG,[figureHandle.UserData.minTime figureHandle.UserData.maxTime],[figureHandle.UserData.CurrentChannel-0.5 figureHandle.UserData.CurrentChannel-0.5],'Color',[1 1 1],'LineWidth',1);
%     fprintf('You pressed Channel=%d, Time=%1.3f on axes %s\n',selectedChannel,selectedTime,axesHandle_EEG.Tag)
set(axesHandle_EEG,'Tag',axesHandle_Tag) %the plot command resets the tag field on the handle, so we reset it (there might be a better way, its a bit hacky)
drawnow % flush the graphics buffer

%% plot the histogram of the selected channel
axesHandle_Tag = axesHandle_Hist.Tag;
cla(axesHandle_Hist,'reset') %clear the axis to get ready for the new plot
bar(axesHandle_Hist,figureHandle.UserData.histogram_interval,figureHandle.UserData.histograms(figureHandle.UserData.CurrentChannel,:),'k')
title(axesHandle_Hist,sprintf('Histogram of channel %d (%s) power=%1.3f dB',figureHandle.UserData.CurrentChannel,figureHandle.UserData.channel_names{figureHandle.UserData.CurrentChannel},figureHandle.UserData.dbPower(figureHandle.UserData.CurrentChannel)))
set(axesHandle_Hist,'Ygrid','on')
set(axesHandle_Hist,'Tag',axesHandle_Tag) %the plot command resets the tag field on the handle, so we reset it (there might be a better way, its a bit hacky)
drawnow % flush the graphics buffer

%% plot the time series of the selected channel
axesHandle_Tag = axesHandle_Series.Tag;
cla(axesHandle_Series,'reset') %clear the axis to get ready for the new plot
plot(axesHandle_Series,figureHandle.UserData.TimeAxis,figureHandle.UserData.plot_data(:,figureHandle.UserData.CurrentChannel));
title(axesHandle_Series,sprintf('Time series of channel %d (%s)',figureHandle.UserData.CurrentChannel,figureHandle.UserData.channel_names{figureHandle.UserData.CurrentChannel}))
set(axesHandle_Series,'Tag',axesHandle_Tag) %the plot command resets the tag field on the handle, so we reset it (there might be a better way, its a bit hacky)
xlabel(axesHandle_Series,'Time [sec]')
xlim(axesHandle_Series,[figureHandle.UserData.minTime figureHandle.UserData.maxTime])
set(axesHandle_Series,'TickLength',[0 0])
set(axesHandle_Series,'YGrid','on')
drawnow % flush the graphics buffer

%% plot the spectrum of the selected channel
axesHandle_Tag = axesHandle_Spectrum.Tag;
cla(axesHandle_Spectrum,'reset') %clear the axis to get ready for the new plot
plot(axesHandle_Spectrum,figureHandle.UserData.spectra_f,10*log10(2*abs(figureHandle.UserData.spectra_Y(figureHandle.UserData.CurrentChannel,1:figureHandle.UserData.Nsamples/2+1)).^2));
title(axesHandle_Spectrum,sprintf('Single-Sided Power Spectrum of channel %d (%s)',figureHandle.UserData.CurrentChannel,figureHandle.UserData.channel_names{figureHandle.UserData.CurrentChannel}))
xlabel(axesHandle_Spectrum,'Frequency [Hz]')
ylabel(axesHandle_Spectrum,'10log_1_0|Y(F)|^2')
xlim(axesHandle_Spectrum,[min(figureHandle.UserData.spectra_f),64])
ylim(axesHandle_Spectrum,figureHandle.UserData.ylim_spectrum)
set(axesHandle_Spectrum,'Ygrid','on')
set(axesHandle_Spectrum,'Tag',axesHandle_Tag) %the plot command resets the tag field on the handle, so we reset it (there might be a better way, its a bit hacky)
drawnow % flush the graphics buffer