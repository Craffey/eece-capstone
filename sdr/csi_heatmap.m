
function amp = csi_heatmap(csi1, csi2, label1, label2)
    xvalues = 1:200;
    yvalues = 1:52;

    
    for capture = 1:min(size(csi1, 3), size(csi2, 3))
        amp1 = permute(normalize(abs(csi1(:,:,capture))), [2 1]);
        ang1 = permute(angle(csi1(:,:,capture)), [2 1]);
        amp2 = permute(normalize(abs(csi2(:,:,capture))), [2 1]);
        ang2 = permute(angle(csi2(:,:,capture)), [2 1]);
        figure(1);
        set(gcf,'Position',[100 100 1500 1000]);

        % create amplitude heatmap
        subplot(2, 2, 1);
        h1 = heatmap(xvalues,yvalues,amp1);
        h1.Title = strcat(label1, ' amplitude');
        h1.XLabel = 'Packet Num';
        h1.YLabel = 'subcarrier';
        
        % create amplitude heatmap
        subplot(2, 2, 2);
        h1 = heatmap(xvalues,yvalues,amp2);
        h1.Title = strcat(label2, ' amplitude');
        h1.XLabel = 'Packet Num';
        h1.YLabel = 'subcarrier';

        % create phase heatmap
        subplot(2, 2, 3);
        h2 = heatmap(xvalues,yvalues,ang1);
        h2.Title = strcat(label1, ' phase');
        h2.XLabel = 'Packet Num';
        h2.YLabel = 'subcarrier';

        % create phase heatmap
        subplot(2, 2, 4);
        h2 = heatmap(xvalues,yvalues,ang2);
        h2.Title = strcat(label2, ' phase');
        h2.XLabel = 'Packet Num';
        h2.YLabel = 'subcarrier';
        
        saveas(gcf, strcat('plots/Heatmap_', string(capture), '.jpg'))
    end
end