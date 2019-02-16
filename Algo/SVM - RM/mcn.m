function [pValue] = mcn(x,varargin)
p = inputParser;
addRequired(p,'x',@(x) validateattributes(x,{'numeric'},{'real','finite','integer','nonnegative','nonnan','size',[2 2]}));
addOptional(p,'alpha',0.05, @(x) validateattributes(x,{'numeric'},{'scalar','real','finite','nonnan','>',0,'<',1}));
parse(p,x,varargin{:});
x=p.Results.x; alpha=p.Results.alpha;
clear p
ob=diag(fliplr(x));
chisquare=(abs(diff(ob))-1)^2/sum(ob);
Za=abs(-realsqrt(2)*erfcinv(alpha));
N=sum(x(:));
p=min(ob./N);
pp=max(ob(1)/ob(2),ob(2)/ob(1));
num=abs(realsqrt(N*p*(pp-1)^2)-realsqrt(Za^2*(pp+1)));
denom=realsqrt(pp+1-p*(pp-1)^2);
Zb=num/denom;
pwr=(1-0.5*erfc(-Zb/realsqrt(2)))*2;
pValue = 1-chi2cdf(chisquare,1);