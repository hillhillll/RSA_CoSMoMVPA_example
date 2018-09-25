%% RSA COSMO example
% Pedro Pinheiro-Chagas 2018

%% Initialize directories and paths
InitDirsMEGcalc
AddPathsMEGcalc

% COSMO MVPA
cd(cosmo_mvpa_dir)
cosmo_set_path()

%% List subjects
sub_name_all = {'s03', 's04'};

%% Calculate RSA - single or multiple regression
% Parameters
operation = 'calc';
timesphere = 2;
single_or_mr = 's';
downsample = 125; % Hz

for subj = 1:length(sub_name_all)
    % Load data and convert to cosmo
    load([data_dir sub_name_all{subj} '_calc_lp30.mat']) % lp30
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

%% Load all data
for p = 1:length(sub_name_all)
    load([rsa_result_dir 'RSA_all_DSM_' operation '_tbin' num2str(timesphere) '_' sub_name_all{p} '_reg_result.mat'])
    fieldnames_RSA = fieldnames(RSA);
    for f = 1:length(fieldnames_RSA)
        RSA_all.(operation).(fieldnames_RSA{f}){p}=RSA.(fieldnames_RSA{f});
        RSA_all.(operation).(fieldnames_RSA{f}){p}.samples=RSA.(fieldnames_RSA{f}).samples(f,:);
        RSA_all.(operation).(fieldnames_RSA{f}){p}.sa.labels=RSA.(fieldnames_RSA{f}).sa.labels(f);
        RSA_all.(operation).(fieldnames_RSA{f}){p}.sa.metric=RSA.(fieldnames_RSA{f}).sa.metric(f);
    end
end

%% Calculate stats
for f = 1:length(fieldnames_RSA)
    RSAres = RSAstats(RSA_all.(operation).(fieldnames_RSA{f}), [operation '_' fieldnames_RSA{f}]);
end

%% Plot
colors = parula(length(fieldnames_RSA));

% Predefine some y_lim
y_lims = zeros(1,2,1);

figureDim = [0 0 .6 .5];
figure('units','normalized','outerposition',figureDim)
x_lim = [-.2 3.2];
for i = 1:length(fieldnames_RSA)
    subplot(length(fieldnames_RSA),1,i)  
    y_lims(i,:) = mvpaPlot(RSAres, 'RSA', colors(i,:), x_lim, y_lims(i,:), 'A');
    sub_pos = get(gca,'position'); % get subplot axis position
    set(gca,'position',sub_pos.*[1 1 1 1.3]) % stretch its width and height
    set(gca,'FontSize',18) % stretch its width and height
    if i == length(fieldnames_RSA)
        set(gca,'XColor','k')
        set(gca, 'XTickLabel', [x_lim(1) 0:.4:x_lim(end)])
        xlabel('Time (s)')
    end
end

