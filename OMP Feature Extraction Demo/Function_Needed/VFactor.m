function [V1,V2,V3] = VFactor(Data,Wnd,Overlap,position)
% [V1,V2,V3] = VFactor(Data,Wnd,Overlap,position)
% This function calculate the V-Factor in three different ways
% Input>>> Data: input signal
%          Wnd: length of window 
%          Overlap: amount of overlap
%          Position: parts of data included in Vfactor calculation
% Outputs>>> V1=(max(abs(Data)))/median(std(Windowed_Data))
%            V2=(max(Data)-min(Data))/median(std(Windowed_Data))
%            V3=(max(Data)-min(Data))/std(Data)

    if nargin==3
        position = [1 length(Data)];
    end
    if nargin==2
        Overlap = round(numel(Data)./2);
        position = [1 length(Data)];
    end
    if nargin==1
        Overlap = round(numel(Data)./2);
        Wnd = numel(Data);
        position = [1 length(Data)];
    end
    Data = Data(position(1):position(2));
    M = Data(bsxfun(@plus,(1:Wnd),(0:Overlap:length(Data)-Wnd)'));
    S = median(std(M'));
    V3 = (max(Data)-min(Data))./std(Data);
    V2 = (max(Data)-min(Data))./S;
    V1 = max(abs(diff(Data)))./S;
end

