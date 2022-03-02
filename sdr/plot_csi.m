% given a 200x52x1x<number of captures> matrix of csi data,
% plot the 52 points per packet on a scatter plot, and animate
% over the 200 packets per capture as well as the <number of captures> captures
% per capture session to show what the csi looked like
% over time

% set complex to 1 for a complex plot, 0 for a real plot
% example usage plot_csi(nothing, hand, jazz, 1)

function plot_csi(csi1, csi2, csi3, complex)
    figure(1)
    if (complex) % plot in complex plane
        for capture = 1:length(csi1(:,:,:))
            for packet = 1:length(csi1)
                plot(csi1(packet,:,capture), '*r')
                hold on
                plot(csi2(packet,:,capture), '*b')
                hold on
                plot(csi3(packet,:,capture), '*g')
                hold off
                xlim([-0.006 0.006]);
                ylim([-0.006 0.006]);
                title(strcat('red 1 blue 2.  capture ', string(capture), ...
                    ' packet', string(packet)))
                drawnow
                pause(0.01)
            end
        end
    else % take phase and mag and plot in real plane
        for capture = 1:length(csi1(:,:,:))
            for packet = 1:length(csi1)
                x = normalize(abs(csi1(packet,:,capture)));
                y = angle(csi1(packet,:,capture));
                plot(x,y,'*r')
                hold on
                x = normalize(abs(csi2(packet,:,capture)));
                y = angle(csi2(packet,:,capture));
                plot(x,y,'*b')
                hold on
                x = normalize(abs(csi3(packet,:,capture)));
                y = angle(csi3(packet,:,capture));
                plot(x,y,'*g')
                hold off
                title(strcat('red 1 blue 2.  capture ', string(capture), ...
                    ' packet', string(packet)))
                xlabel('normalized amplitude');
                ylabel('phase');
                xlim([-4 4]);
                ylim([-4 4]);
                drawnow
                pause(0.01)
            end
        end
    end
end