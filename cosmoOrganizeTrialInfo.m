function [stim,stimfull] = cosmoOrganizeTrialInfo(trialinfo)

for i = 1:length(trialinfo.operand1)
    if trialinfo.operator(i) == 1
        operator_sign = '+';
    elseif trialinfo.operator(i) == -1
        operator_sign = '-';      
    elseif trialinfo.operator(i) == 0
        operator_sign = '=';
    else
    end
        
    stim(i) = {[num2str(trialinfo.operand1(i)), operator_sign num2str(trialinfo.operand2(i))]};
    stimfull(i) = {[num2str(trialinfo.operand1(i)), operator_sign num2str(trialinfo.operand2(i)) '=' num2str(trialinfo.presResult(i))]}; 
end

end

