function [lost_trials, data] = timelock(data, subject, position)
    %% Initialize dirs
    InitDirsMEGcalc
    %%

    if strcmp(position, 'response')
        % Time-lock to the response
        for i = 1:length(data.trial)
            if data.trialinfo.delay(i) == 1
                time_epoch = 3.6 + data.trialinfo.rt(i)/1000 + .1;
            else
                time_epoch = 3.2 + data.trialinfo.rt(i)/1000 + .1;
            end

            if time_epoch <= max(data.time{1})
                good_trials(i) = 1;
                time_resp = round((abs(min(data.time{1}))+time_epoch)*data.fsample);
                time_before_resp = round((abs(min(data.time{1}))+time_epoch)*data.fsample) - round(0.9*data.fsample);
                locked_data{i} = data.trial{i}(:,time_before_resp:time_resp);
                locked_data_ECGEOG{i} = data.ECGEOG{i}(:,time_before_resp:time_resp);
            else
                good_trials(i) = 0;
            end
        end
        locked_data = locked_data(good_trials==1);
        locked_data_ECGEOG = locked_data_ECGEOG(good_trials==1);
        data.trial = locked_data;
        data.ECGEOG = locked_data_ECGEOG;

        % Correct trialinfo
        trialinfo_names = fieldnames(data.trialinfo);
        for i = 1:length(trialinfo_names)
            data.trialinfo.(trialinfo_names{i}) = data.trialinfo.(trialinfo_names{i})(good_trials==1);
        end

        % Correct sample info, triggers and ECGEOG just in case
        data.sampleinfo = data.sampleinfo(good_trials==1, :);
        data.triggers = data.triggers(good_trials==1);

        % Correct time
        data.time = {};
        for i = 1:length(data.trial)
            data.time{i} = -0.8:0.004:.1;
        end

        lost_trials = [length(good_trials) sum(good_trials) 1-sum(good_trials)/length(good_trials)]; 
        save([data_dir subject '_' 'calc' '_AICA_TLresponse.mat'], 'data')   % Save the structure in MAT file


    elseif strcmp(position, 'result')
        % Time-lock to the response
        for i = 1:length(data.trial)
            if data.trialinfo.delay(i) == 1
                    time_epoch = 3.6;
            else
                time_epoch = 3.2;
            end
            time_resp = round((abs(min(data.time{1}))+time_epoch)*data.fsample) + 0.8*data.fsample;
            time_before_resp = round((abs(min(data.time{1}))+time_epoch)*data.fsample) - round(0.2*data.fsample);
            locked_data{i} = data.trial{i}(:,time_before_resp:time_resp);
            locked_data_ECGEOG{i} = data.ECGEOG{i}(:,time_before_resp:time_resp);
        end
        
        data.trial = locked_data;
        data.ECGEOG = locked_data_ECGEOG;

        % Correct time
        data.time = {};
        for i = 1:length(data.trial)
            data.time{i} = -0.2:0.004:.8;
        end
        % Save
        lost_trials = 0; 
        save([data_dir subject '_' 'calc' '_AICA_TLresult.mat'], 'data')   % Save the structure in MAT file

        
    elseif strcmp(position, '3')       
        % Time-lock and concatenate to 2nd operand
        for i = 1:length(data.trial)
            time_epoch = 3.2;
            
            time_resp = round((abs(min(data.time{1}))+time_epoch)*data.fsample) + 0.8*data.fsample;
            time_before_resp = round((abs(min(data.time{1}))+time_epoch)*data.fsample) - round(0.2*data.fsample);
            locked_data{i} = data.trial{i}(:,time_before_resp:time_resp);
            locked_data_ECGEOG{i} = data.ECGEOG{i}(:,time_before_resp:time_resp);
        end
        
        data.trial = locked_data;
        data.ECGEOG = locked_data_ECGEOG;

        % Correct time
        data.time = {};
        for i = 1:length(data.trial)
            data.time{i} = -0.2:0.004:.8;
        end
        
    elseif strcmp(position, 'op2')       
        % Time-lock and concatenate to 2nd operand
        for i = 1:length(data.trial)
            time_epoch = 1.6;
            
            time_resp = round((abs(min(data.time{1}))+time_epoch)*data.fsample) + 1.6*data.fsample;
            time_before_resp = round((abs(min(data.time{1}))+time_epoch)*data.fsample) - round(0.1*data.fsample);
            locked_data{i} = data.trial{i}(:,time_before_resp:time_resp);
            locked_data_ECGEOG{i} = data.ECGEOG{i}(:,time_before_resp:time_resp);
        end
        
        data.trial = locked_data;
        data.ECGEOG = locked_data_ECGEOG;

        % Correct time
        data.time = {};
        for i = 1:length(data.trial)
            data.time{i} = -0.1:0.004:1.6;
        end
        
        % Save
        lost_trials = 0; 
        
 elseif strcmp(position, 'A')       
        for i = 1:length(data.trial)
            time_epoch = [-.2 3.2];
            
            timeStart = find(data.time{1} > time_epoch(1)); timeStart = timeStart(1);
            timeStop = find(data.time{1} > time_epoch(2)); timeStop = timeStop(1);
            
            locked_data{i} = data.trial{i}(:,timeStart:timeStop);
            locked_data_ECGEOG{i} = data.ECGEOG{i}(:,timeStart:timeStop);
        end
        
        data.trial = locked_data;
        data.ECGEOG = locked_data_ECGEOG;

        % Correct time
        data.time = {};
        for i = 1:length(data.trial)
            data.time{i} = time_epoch(1):1/data.fsample:time_epoch(2);
        end
        
        % Save
        lost_trials = 0; 

        
    end



end
