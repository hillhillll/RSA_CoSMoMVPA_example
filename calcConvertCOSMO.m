function data_cosmo = calcConvertCOSMO(data)
% Ft timelock preserving trials
cfg = [];
cfg.keeptrials = 'yes';
datatmp = ft_timelockanalysis(cfg, data);
data_cosmo = cosmo_meeg_dataset(datatmp);
% Add trialinfo to cosmo
fieldNames = fieldnames(data.trialinfo);
for f = 1:length(fieldNames)
    data_cosmo.sa.(fieldNames{f}) = data.trialinfo.(fieldNames{f});
end
end

