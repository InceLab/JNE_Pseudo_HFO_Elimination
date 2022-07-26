function c = dctmtxphase(n,phase)
    % This function creates dicrete cosine transform elemenets in different
    % phases
    % phase should be in radian format
    %inputs:n=size of DCT element
    %       phase= in Radian
    %output:c= DCT elemets aformentioned phase
    [cc,rr] = meshgrid(0:n-1);
    c = sqrt(2 / n) * cos(pi * (2*cc + 1) .* rr / (2 * n)+phase);
    
    c(1,:) = c(1,:) / sqrt(2);
end 

