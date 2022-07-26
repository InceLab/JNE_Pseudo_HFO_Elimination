function [y,coeff,loc,residual,Error,Error_side,Error_center]=OMP_Visualize(D,X,L,S1,S2,S3) 
%=============================================
% Sparse coding of a group of signals based on a given 
% dictionary and specified number of atoms to use. 
% input arguments: 
%               D - the dictionary (its columns MUST be normalized).
%               X - the signals to represent
%               L - the max. number of coefficients for each signal.
%               S1 - the min Error to stop OMP
%               S2 - the min Error Difference to stop OMP
%               S3 - Minimum Iteration
% output arguments: 
%               A - sparse coefficient matrix.
%=============================================
% if nargin==6
%     pre = 0;
% end
[n,P]=size(X);
[n,K]=size(D);
Error_Diff = [];
for k=1:1:P
    a=[];
    x=X(:,k);
%     if pre==0
        residual(:,1)=x;
%     else
%         residual(:,1)=pre;
%     end
    indx = [];
    for j=1:1:L % iteration
        proj=D'*residual(:,j);
        [maxVal,pos]=max(abs(proj));
        pos=pos(1);
        indx=[indx pos];
        a=pinv(D(:,indx(1:j)))*x;
        residual(:,j+1)=x-D(:,indx(1:j))*a;
        y(:,j) = D(:,indx(1:j))*a;
        %Error
        t1=round(size(y,1)/3);
        t2=round(2*size(y,1)/3);
        Error(j)=sqrt(sum(residual(:,j+1).^2))/sqrt(sum(X.^2));
        Error_side(j) = (sum(abs(residual(1:150,j+1)))+sum(abs(residual(t2+1:end,j+1))))/(sum(abs(X(1:t1)))+sum(abs(X(t2+1:end))));
        Error_center(j) = sum(abs(residual(t1+1:t2,j+1)))/sum(abs(X(t1+1:t2)));
        temp=zeros(K,1);
        temp(indx(1:j))=a;
        coeff(:,k)=(temp);
        loc = indx;
        
        if j>1
            Error_diff(j-1) = Error(j-1) - Error(j) ;
        end
        % Error Breakpoint
        if j>S3
            if (Error(j) < S1) | (Error_diff(j-1)<S2)
                break;
            end
        end 
        %plot_OMP(X,y,D,Error,residual,coeff,loc,j,anim)
    end
end
return;