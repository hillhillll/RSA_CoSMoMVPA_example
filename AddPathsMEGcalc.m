%% Directories
% Get computer
comp = computer;

% MAC + Hard Drive
if strcmp(comp, 'MACI64') == 1
    % Paths
    scripts_dir = '/Users/pinheirochagas/Pedro/Stanford/code/cosmo_RSA_pipeline/';
    addpath(genpath(scripts_dir))
    fieldtrip_dir = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/fieldtrips/fieldtrip_lite/';   
    addpath(fieldtrip_dir)
    ft_defaults;
    % Linux
else
    error('You can only be using your macbook')
end