
function amp = csi_heatmap(csi)
    xvalues = 1:200;
    yvalues = 1:52;
    amp = permute(normalize(abs(csi(:,:,1))), [2 1]);
    ang = permute(angle(csi(:,:,1)), [2 1]);
    
    % create amplitude heatmap
    figure(1)
    h1 = heatmap(xvalues,yvalues,amp);
    h1.Title = 'amplitude heatmap';
    h1.XLabel = 'Packet Num';
    h1.YLabel = 'subcarrier';
    
    % create phase heatmap
    figure(2)
    h2 = heatmap(xvalues,yvalues,ang);
    h2.Title = 'phase heatmap';
    h2.XLabel = 'Packet Num';
    h2.YLabel = 'subcarrier';
end