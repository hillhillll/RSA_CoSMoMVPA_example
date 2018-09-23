function data = calc_scaler(data)

for i = 1:length(data.trial)
    for ii = 1:size(data.trial{i},1)
        data.trial{i}(ii,:) = zscore(data.trial{i}(ii,:));
    end
end

end