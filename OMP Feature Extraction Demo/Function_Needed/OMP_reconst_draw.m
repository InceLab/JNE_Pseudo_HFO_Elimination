function OMP_reconst_draw(dat,Dict,fs,filename)
%  OMP_reconst_draw(raw,Dict,fs,stop)
% ########################################################################
% Input: dat: raw event
%        Dict: Dictionary of atoms (visit Create_Dictionary function for
%        details)
%        fs: Sampling frequency
%        filename: files to be saved in .avi format (text file)
% ########################################################################

% Initial parameters
% Do Not change these parameters!
stop.iter = 24; % Stopping criteria-1
stop.Res = 0.01; % Stopping criteria-2
stop.DRes = -1; % Stopping criteria-3
stop.minIteration = 1; % Stopping criteria-4

t = 1/fs:1/fs:length(dat)/fs; % time index
rng = 1.05*max(abs(dat)); % range of raw event
DLSize = size(Dict.DL,2);% low band dictionary size
frq = [Dict.frq.DL Dict.frq.DR Dict.frq.DF];% Dictionary frequency
Dictionary = [Dict.DL Dict.DR Dict.DF];%Dictionary atoms

% OMP Process
[OMP.reconstructed,OMP.coeff,OMP.loc,OMP.Residual,OMP.Error,~,~]...
    = OMP_Visualize(Dictionary,dat,30,stop.Res,stop.DRes,stop.minIteration);

% Compute the V-Factor
for k=1:stop.iter
    [~,~,V(k)] = VFactor(OMP.Residual(:,k));
end

% Visualization
fg = figure();
writerObj = VideoWriter(filename);
writerObj.FrameRate = 5;
writerObj.Quality = 75;
open(writerObj);
set(fg, 'Units', 'inches', 'Position', [3 3 12 10]);
set(gcf,'Renderer','zbuffer'); 


txt = 'OMP Representation using Gabor atoms!';
text(0.1,0.5,txt,'Color','black','FontSize',20)
axis off;
box off;

%pause(2);
for frmV = 1:2*writerObj.FrameRate
    frame = getframe(gcf);
    writeVideo(writerObj,frame);
    pause(1/writerObj.FrameRate);
end
clf(fg);

for k=1:stop.iter
    sgt = sgtitle('OMP reconstruction using Gabor atoms','Color','red');
    sgt.FontSize = 12;
    
    subplot(11,4,[1 2 5 6]);%plot signal and approximation
    plot(t,dat,'b','LineWidth',1.2);
    xlim([1/fs length(dat)/fs]);
    yticks([-floor(rng) -floor(rng/2) 0 ceil(rng/2) ceil(rng)]);
    xticks([]);
    ylim([-rng rng]);
    ylabel('Amplitude (uV)');
    hold on
    plot(t,OMP.reconstructed(:,k),'-r','LineWidth',1.2);hold off
    legend('raw','reconstructed','Location','southeast');
    
    subplot(11,4,[3 4 7 8]);%plot the approximation error
    stem(1:k,1-OMP.Error(1:k),'k');
    xlim([0.5 stop.iter+0.5]);
    ylim([0 1]);
    xticks([]);
    ylabel('Accuracy');
    txt = sprintf('Approximation Error: %.3f',OMP.Error(k));
    grid on;
    title(txt);
    
    subplot(11,4,[9 10 13 14]);%plot the Residual waveform
    plot(t,OMP.Residual(:,k+1),'r','LineWidth',1.2);
    xlim([1/fs length(dat)/fs]);
    legend('Residual Signal','Location','southwest');
    rng2 = 1.05*max(abs(OMP.Residual(:,k+1)));
    if rng2>100
        ylim([-120 120])
    elseif rng2<100 & rng2>50
        ylim([-100 100]);
    elseif rng2<50 & rng2>25
        ylim([-50 50]);
    elseif rng2<25 & rng2>10
        ylim([-25 25]);
    else
        ylim([-10 10]);
    end
    ylabel('Amplitude (uV)');
    
    subplot(11,4,[11 12 15 16]);%plot the V-factor
    stem(1:k,V(1:k),'k');
    xlim([0.5 stop.iter+0.5]);
    ylim([0 20]);
    xlabel('Iteration');
    ylabel('V-Factor');
    txt = sprintf('V-Factor: %.2f',V(k));
    grid on;
    title(txt);
    
    subplot(11,4,[k+20]);%plot the selected atom
    if OMP.loc(k) > DLSize
        plot(t,Dictionary(:,OMP.loc(k)),'r');
        txt = sprintf('\\color{%s}Atom:%d Coeff:%.2f','black',k,OMP.coeff(OMP.loc(k)));
        title(txt);
        axis off;
        box off;
    elseif OMP.loc(k) <= DLSize && abs(frq(OMP.loc(k))-60)<7.5
        plot(t,Dictionary(:,OMP.loc(k)),'b');
        txt = sprintf('\\color{%s}Atom:%d Coeff:%.2f','black',k,OMP.coeff(OMP.loc(k)));
        title(txt);
        axis off;
        box off;
    else
        plot(t,Dictionary(:,OMP.loc(k)),'k');
        txt = sprintf('\\color{%s}Atom:%d Coeff:%.2f','black',k,OMP.coeff(OMP.loc(k)));
        title(txt);
        axis off;
        box off;
    end


    for frmV = 1:1*writerObj.FrameRate
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
        pause(1/writerObj.FrameRate);
    end
    
end


pause(1);
clf(fg);


subplot(3,2,[1 2]);
plot(t,dat,'b','LineWidth',1.2);
xlim([1/fs length(dat)/fs]);
yticks([-floor(rng) -floor(rng/2) 0 ceil(rng/2) ceil(rng)]);
xticks([]);
ylim([-rng rng]);
ylabel('Amplitude (uV)');
title('Raw wave');

subplot(3,2,[3 4]);
plot(t,OMP.reconstructed(:,end),'r','LineWidth',1.2);
xlim([1/fs length(dat)/fs]);
yticks([-floor(rng) -floor(rng/2) 0 ceil(rng/2) ceil(rng)]);
xticks([]);
ylim([-rng rng]);
ylabel('Amplitude (uV)');
title('Reconstructed wave');

subplot(3,2,5);

tf = [];
for j=1:length(OMP.loc)
    [tf(:,:,j),f,t] = wvd(Dictionary(:,OMP.loc(j)),fs,'smoothedPseudo',hanning(127),hanning(65));
    [tf(:,:,j)] = (abs(tf(:,:,j))).*sqrt(abs(OMP.coeff(OMP.loc(j))));
end
wv_tf_map = sum(tf,3);
imagesc(t,f,wv_tf_map)
axis xy
colorbar;
colormap(jet);
ylim([0 600]);
xlabel('Time (ms)');ylabel('Frequency (Hz)');
title('WVD time-frequency map');


subplot(3,2,6);
env_p = 4;
min_th = 5;
fc = 80;
Nc = 4;
[b,a] = butter(4,[80 600]/(fs/2));
HFOBand = filtfilt(b,a,dat);
HFOSize = length(HFOBand);
envR_side = [buffered_stats(HFOBand(1:round(HFOSize*1/3)),16,12,'std'),...
    buffered_stats(HFOBand(round(2*HFOSize/3):HFOSize),16,12,'std')];
env_th = env_p.*median(envR_side);

tf = [];
for j=1:length(OMP.loc)
   if OMP.loc(j)>DLSize
       p = hfo_amp_detector(OMP.coeff(OMP.loc(j)).*Dictionary(:,OMP.loc(j)),[],max(min_th,env_th),fs,fc,Nc);
       if p==1
            [tf(:,:,j),f,t] = wvd(Dictionary(:,OMP.loc(j)),fs,'smoothedPseudo',hanning(127),hanning(65));
            [tf(:,:,j)] = (abs(tf(:,:,j))).*sqrt(abs(OMP.coeff(OMP.loc(j))));
       else
           % Do nothing
       end
   else
        [tf(:,:,j),f,t] = wvd(Dictionary(:,OMP.loc(j)),fs,'smoothedPseudo',hanning(127),hanning(65));
        [tf(:,:,j)] = (abs(tf(:,:,j))).*sqrt(abs(OMP.coeff(OMP.loc(j))));
   end
end
wv_tf_map = sum(tf,3);
imagesc(t,f,wv_tf_map)
axis xy
colorbar;
colormap(jet);
ylim([0 600]);
xlabel('Time (ms)');ylabel('Frequency (Hz)');
title('WVD time-frequency map of HFO atoms');

for frmV = 1:1*writerObj.FrameRate
    frame = getframe(gcf);
    writeVideo(writerObj,frame);
    pause(1/writerObj.FrameRate);
end
pause(1);

close(writerObj);

end
    

