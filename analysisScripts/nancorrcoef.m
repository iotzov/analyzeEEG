function [c,p]=nancorrcoef(x,y)

if nargin==1
    y = x;
end

[N,Mx]=size(x);
[N,My]=size(y);

c=nan(Mx,My);p=c;
for i=1:Mx,
    for j=1:My
        indx = find(~isnan(x(:,i).*y(:,j)));
        [ctmp,ptmp] = corrcoef(x(indx,i),y(indx,j));
        if numel(ctmp)>1
            c(i,j) = ctmp(1,2);
            p(i,j) = ptmp(1,2);
        end
    end
end

