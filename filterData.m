function data = filterData(data, conds)
%%
% Get the indices
conds_idx = selecCondsMegCalc(data.trialinfo, conds);
data.trial = data.trial(conds_idx);
data.trialinfo = structfun(@(x) x(conds_idx), data.trialinfo, 'UniformOutput', false);
data.time = data.time(conds_idx);
data.ECGEOG = data.ECGEOG(conds_idx);
data.sampleinfo = data.sampleinfo(conds_idx,:);
% data.triggers = data.triggers(conds_idx);
data = rmfield(data, 'triggers');
end