function [ prob ] = multTPdf( x,mu,sigma,v )
%MUTLT return probablities for mutivariate student t

p = length(mu);
Nr = gammaln((v+p)/2);

mrep = repmat(mu(:)', size(x,1), 1); % replicate the mean across rows
x = x-mrep;
xprod = sum((x*inv(sigma)).*x,2);
Dr = gammaln(v/2) + 0.5*log(det(sigma)) + (p/2)*log(v) + (p/2)*log(pi) +((v+p)/2)*log(1 + ((1/v) * xprod)) ;

prob =  exp(Nr - Dr);
%p = Nr/Dr;


end


