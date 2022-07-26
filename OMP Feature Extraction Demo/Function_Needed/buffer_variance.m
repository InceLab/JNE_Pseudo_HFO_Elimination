function [y] = buffer_variance(data,frame,overlap,type)
%   [y] = buffer_variance(data,frame,overlap,type)
%   input  data: input vector of data
%         frame: frame size (scalar value)
%       overlap: overlap size between frames (scalar value)
%          type: i.e. std, mean, median, ...
    if nargin<4
        type = 'std';
    end

    s = buffer(data,frame,overlap,'nodelay');
    switch type
        case 'std'
               y = std(s);
        case 'mean'
               y = mean(s);
        case 'median'
               y = median(s);
        case 'var'
               y = var(s);
    end

end

