function RSAstats(RSA_all, RSA_model)
%% Sample code for Significance Testing for RSA in Cosmo
% Lina Teichmann
% May 2017
%**************************************************************************
% Add CosmoMVPA to path & clear variables before running
%**************************************************************************
InitDirsMEGcalc

ds_stacked_RSA = cosmo_stack(RSA_all);
nparticipants = size(ds_stacked_RSA.samples,1);


%% RSA: significance testing - monte-carlo-cluster corrected for multiple comparisons
ds_stacked_RSA.sa.targets = ones(nparticipants,1);
ds_stacked_RSA.sa.chunks=(1:nparticipants)';

neighborhood = cosmo_cluster_neighborhood(ds_stacked_RSA); 
opt = struct();
opt.niter = 10000; % 10000
opt.h0_mean=0;
opt.null=[];

tfce_ds = cosmo_montecarlo_cluster_stat(ds_stacked_RSA,neighborhood,opt);
sig_tp_RSA = tfce_ds.samples>1.6449; % one-tailed: we are only interested what is above chance. 
timevect = ds_stacked_RSA.a.fdim.values{1};

RSAres.neighborhood = neighborhood;
RSAres.ds_stacked_RSA = ds_stacked_RSA;
RSAres.tfce_ds = tfce_ds;
RSAres.sig_tp_RSA = sig_tp_RSA;
RSAres.timevect = timevect;
RSAres.opt = opt;

%% Save results
%save([rsa_result_dir '/group_rsa_mr_searchlight/RSA_stats_model_', RSA_model, 'all_DSM_MR_searchlight.mat'], 'RSAres');
save([rsa_result_dir '/group_rsa_mr/RSA_stats_model_', RSA_model, '_all_DSM_MR_operator_reg_result.mat'], 'RSAres');
%save([rsa_result_dir '/group_rsa/RSA_stats_model_', RSA_model, '_all_DSM.mat'], 'RSAres');

end





