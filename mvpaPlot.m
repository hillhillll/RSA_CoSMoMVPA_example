function y_lim = mvpaPlot(res, gatdiagorRSA, color_plot, x_lim, y_lim, timelock)

%% Plotting
if strcmp(gatdiagorRSA, 'diag') == 1 || strcmp(gatdiagorRSA, 'RSA')
    decodingPlotDiag(res, gatdiagorRSA)
elseif strcmp(gatdiagorRSA, 'diag_cross_cond')
    decodingPlotDiagCrossCond(res)
end
        
    %% Plot diagonal
    function decodingPlotDiag(res, gatdiagorRSA)    
        % Define plot parameters        
        LineWidthLine = 1;
        LineWidthLineThick = 3;
        LineCol = [.5 .5 .5];

        % Get data
        if strcmp(gatdiagorRSA, 'diag') == 1 
            chance = double(res.chance);
            data = squeeze(res.all_diagonals);
            times_plot = res.times(1:size(data,2));
            sig_plot = res.p_values_diagonal_fdr<0.05;
%              sig_plot = res.p_values_diagonal<0.05;
        elseif strcmp(gatdiagorRSA, 'RSA') == 1 
            chance = 0;
            data = res.ds_stacked_RSA.samples;
            times_plot = res.timevect;
            sig_plot = res.sig_tp_RSA;
        end
             
        % Average data
        data_avg = mean(data,1);
        data_sem = std(data)/sqrt(size(data,1));
        
        % Correct single points
        for i=2:length(sig_plot)-1
            if sig_plot(i) == 1 && (sig_plot(i-1) == 0 && sig_plot(i+1) == 0);
                sig_plot(i+1) = 1;
            else
            end
        end
        
        % Initialize plot lines
        y_lim = plotLines(chance,x_lim, y_lim, data_avg, data_sem, timelock);
        
        % result
        hold on
        plt = shadedErrorBar(times_plot,data_avg,data_sem, {'color', color_plot, 'LineWidth',0.001});
        plot(times_plot,data_avg,'LineWidth',LineWidthLine, 'Color', LineCol)
        plt.patch.FaceAlpha = 1;
        
        % Highlight significant time points
        times_plot(sig_plot==0 | data_avg<chance) = nan;
        data_avg(sig_plot==0 | data_avg<chance) = nan;
        plot(times_plot, data_avg,  'LineWidth',  LineWidthLineThick, 'Color', 'k')       
        area_plot = area(times_plot,data_avg, chance, 'FaceColor', color_plot, 'LineStyle', 'none');
        area_plot.FaceAlpha = 0.9;   

    end

    %% Plot diagonal cross cond
    function decodingPlotDiagCrossCond(res)
        
        % Define plot parameters        
        LineWidthLine = 1;
        LineWidthLineThick = 3;
        LineCol = [.5 .5 .5];
        
        % Define data
        chance = res.chance;
        data = res.data;
        times_plot = res.times_plot;
        sig_plot = res.sig_plot;
        
        % Average data
        data_avg = mean(data,1);
        data_sem = std(data)/sqrt(size(data,1));
        
        % Correct single points
        for i=2:length(sig_plot)-1
            if sig_plot(i) == 1 && (sig_plot(i-1) == 0 && sig_plot(i+1) == 0);
                sig_plot(i+1) = 1;
            else
            end
        end
        
        % Initialize plot lines
        y_lim = plotLines(chance,x_lim, y_lim, data_avg, data_sem, timelock);
        
        % result
        hold on
        plt = shadedErrorBar(times_plot,data_avg,data_sem, {'color', color_plot, 'LineWidth',0.001});
        plot(times_plot,data_avg,'LineWidth',LineWidthLine, 'Color', LineCol)
        plt.patch.FaceAlpha = 1;
        
        % Highlight significant time points
        times_plot(sig_plot==0 | data_avg<chance) = nan;
        data_avg(sig_plot==0 | data_avg<chance) = nan;
        plot(times_plot, data_avg,  'LineWidth',  LineWidthLineThick, 'Color', 'k')       
        area_plot = area(times_plot,data_avg, chance, 'FaceColor', color_plot, 'LineStyle', 'none');
        area_plot.FaceAlpha = 0.9; 
        box on
        
    end
        
    %% Plot lines
    function y_lim = plotLines(chance,x_lim,y_lim, data_avg, data_sem, timelock)
        % timing
        t.A = 0;
        t.sign = round(47*16.7)/1000;
        t.B = 2*t.sign;
        t.equal = 3*t.sign;
        t.C = 4*t.sign;
        t.Cd = 4.5*t.sign;
        t.tC = t.C - 3.200;
        
        LineWidthMark = 1;
        LineCol = [.5 .5 .5];
        % Plot
        xlim(x_lim)
        if sum(y_lim) == 0
            y_lim = [round((min(data_avg)-max(data_sem))*100)/100  round((max(data_avg)+max(data_sem))*100)/100];
            ylim(y_lim)
        else
            ylim(y_lim)
        end
        %box on
        
        set(gca, 'YTick', [y_lim(1) chance y_lim(end)]);
        set(gca, 'XTickLabel', '');
        set(gca, 'YTickLabel', {'', chance, y_lim(end)});
       
        if strcmp(timelock, 'A') == 1
            x_ticks = [x_lim(1) 0:.4:x_lim(end)];
            line(xlim,[chance chance], 'Color', LineCol, 'LineWidth', LineWidthMark);
            line([t.A t.A], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
            line([t.sign t.sign], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
            line([t.B t.B], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
            line([t.equal t.equal], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
            line([t.C t.C], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
        elseif strcmp(timelock, 'C') == 1
            x_ticks = [x_lim(1) 0:.4:x_lim(end)];
            line(xlim,[chance chance], 'Color', LineCol, 'LineWidth', LineWidthMark);
            line([t.tC t.tC], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
%             set(gca, 'YTickLabel', '');    
        elseif strcmp(timelock, 'RT') == 1
            x_ticks = [x_lim(1):.4:x_lim(end)];
            line(xlim,[chance chance], 'Color', LineCol, 'LineWidth', LineWidthMark);
            line([0 0], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
%             set(gca, 'YTickLabel', ''); 
        elseif strcmp(timelock, 'cross_cond') == 1
            x_ticks = 0:.4:x_lim(end);
            line(xlim,[chance chance], 'Color', LineCol, 'LineWidth', LineWidthMark);
        else
        end
        
       set(gca, 'XTick', x_ticks);
       set(gca,'XColor','w')

    end
    






end