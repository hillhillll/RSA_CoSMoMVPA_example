function dataout = calc_downsample(data, resamplefs) 

% Define configuration file
cfg.resamplefs = resamplefs;
cfg.detrend    = 'no';
cfg.demean     = 'no';
cfg.feedback   = 'text';
cfg.trials     = 'all';

dataout = ft_resampledata(cfg, data);

data_fs = data.fsample; % fix this

% for i=1:length(data.triggers)
%     dataout.triggers{i}(:,1) = round(data.triggers{i}(:,1)/(data_fs/cfg.resamplefs)); % Correct the timing of the triggers
% end

dataout.sampleinfo = data.sampleinfo; % this is the original sample raw information
dataout.trialinfo = data.trialinfo;

end