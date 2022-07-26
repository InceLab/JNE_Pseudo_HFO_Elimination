function p=hfo_amp_detector(x,sD,th,fs,fc,Nc)
% function p=hfo_amp_detector(x,sD,th,fs)
% x is the filtered signal in HFO range
% sD is the standard deviation threshold
% th is the amplitude threshold. 4uV default
% fs s the sampling rate
% Fc minimum HFO frequency
% Nc is the min number of threshold crossings. 3 default


if nargin<2
    th=4; % Amp threshold is set to 4uV
    fs=2000;
    fc=80;
    Nc=4; % 4 crossings -> completing one period
end

if isempty(sD) && isempty(th) 
    th=4;
elseif sD>4 %4uV
    th=sD;
end

N=round(1/fc*fs);
h=ones(Nc-1,1);
p=0;


[~,ix] = zerocross_count((x-th)'); 

if ~isempty(ix)
    ix=diff(ix);
    if ~isempty(ix)
        dx=conv(ix<N,h);
        if sum(dx>=Nc-1)
            p=1;
            return;
        end
    end
end



[~,ix] = zerocross_count((x+th)'); 

if ~isempty(ix)
    ix=diff(ix);
    if ~isempty(ix)
    dx=conv(ix<N,h);
        if sum(dx>=Nc-1)
            p=1;
            return;
        end
    end
end

