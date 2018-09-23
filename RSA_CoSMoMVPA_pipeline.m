%% RSA COSMO example
% Pedro Pinheiro-Chagas 2018

%% Initialize directories and paths
InitDirsMEGcalc
AddPathsMEGcalc

% COSMO MVPA
cd(cosmo_mvpa_dir)
cosmo_set_path()

%% List subjects
sub_name_all = {'s03'};

%% Calculate RSA - single or multiple regression
% Parameters
operation = 'calc';
timesphere = 2;
single_or_mr = 's';
downsample = 125; % Hz

for subj = 1:length(sub_name_all)
    % Load data and convert to cosmo
    load([data_dir sub_name_all{subj} '_calc.mat']) % lp30
    % Select trials
    data = filterData(data, operation);
    % Crop data
    [~, data] = timelock(data, sub_name_all{subj}, 'A');
    % Downsample data
    data = calc_downsample(data, 125);
    % Scaler - z-score channels to put mag and grad in the same scale
    data = calc_scaler(data);
    % Convert to cosmo MVPA
    data_cosmo = calcConvertCOSMO(data);
    % Organize trialinfo and leave only the stim field
    [stim, stimfull] = cosmoOrganizeTrialInfo(data_cosmo.sa);
    % Select only the calculation trials
    data_cosmo.sa = [];
    data_cosmo.sa.stim = stim';
    % Run RSA
    cosmoRSA(sub_name_all{subj}, data_cosmo, timesphere, operation, single_or_mr)
end

% Load all data MR
for p = 1:length(sub_name_all)
    load([rsa_result_dir 'RSA_all_DSM_mr_' operation '_tbin' num2str(timesphere) '_' sub_name_all{p} '.mat'])
    fieldnames_RSA = RSA.predictors;
    for f = 1:length(fieldnames_RSA)
        RSA_all.(operation).(fieldnames_RSA{f}){p}=RSA.result_reg_everything;
        RSA_all.(operation).(fieldnames_RSA{f}){p}.samples=RSA.result_reg_everything.samples(f,:);
        RSA_all.(operation).(fieldnames_RSA{f}){p}.sa.labels=RSA.result_reg_everything.sa.labels(f);
        RSA_all.(operation).(fieldnames_RSA{f}){p}.sa.metric=RSA.result_reg_everything.sa.metric(f);
    end
end

load([rsa_result_dir '/group_rsa_mr/RSA_stats_model_', RSA_model, '_all_DSM_MR_operator_reg_result.mat']);
% Calculate stats
for f = 1:length(fieldnames_RSA)
    RSAstats(RSA_all.(operation).(fieldnames_RSA{f}), [operation '_' fieldnames_RSA{f}])
end
