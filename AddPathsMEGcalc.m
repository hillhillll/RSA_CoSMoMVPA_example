%% Directories
% Get computer
comp = computer;

% MAC + Hard Drive
if strcmp(comp, 'MACI64') == 1
    % Paths
    scripts_dir = '/Users/pinheirochagas/Pedro/Stanford/code/RSA_CoSMoMVPA_example/';
    addpath(genpath(scripts_dir))
    fieldtrip_dir = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/fieldtrips/fieldtrip_lite/';   
    addpath(fieldtrip_dir)
    ft_defaults;
else
    error('You can only be using your macbook')
end