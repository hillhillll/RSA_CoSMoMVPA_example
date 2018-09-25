%% Directories
% Get computer
comp = computer;

% MAC + Hard Drive
if strcmp(comp, 'MACI64') == 1
    data_root_dir = '/Users/pinheirochagas/Pedro/Stanford/code/RSA_CoSMoMVPA_example/';
    cosmo_mvpa_dir = '/Users/pinheirochagas/Pedro/NeuroSpin/Methods/CoSMoMVPA/mvpa';
else
    error('You can only be using your macbook')
end

% Directories
bst_db_dir = [data_root_dir 'brainstorm_db/']; % Brainstorm database folder
bst_db_data_dir = [data_root_dir 'brainstorm_db/calc/data/']; % Brainstorm database folder
data_dir = '/Users/pinheirochagas/Pedro/drive/NeuroSpin/RSA_CoSMoMVPA_example/data/';
data_sss_dir = [data_root_dir 'data/sss/'];
erf_result_dir = [data_root_dir 'results/erf/'];
rsa_result_dir = '/Users/pinheirochagas/Pedro/drive/NeuroSpin/RSA_CoSMoMVPA_example/results/RSA/';
erf_fig_dir = [data_root_dir 'results/erf/figures/'];
erf_stat_dir = [data_root_dir 'results/erf/stats/'];
tfa_data_dir = [data_root_dir 'data/TFA/'];
searchlight_result_dir = [data_root_dir 'results/searchlight/'];
dec_res_dir_ind = [data_root_dir 'results/decoding/individual_results/'];
dec_res_dir_group = [data_root_dir 'results/decoding/group_results/'];
beh_res_dir_group = [data_root_dir 'results/behavior/'];