function [rsq] = tempofit(y, x1, x2, offsets)
L = length(offsets);

N = size(x2);

Y = y';
X = [x1; x2]';

[B,BINT,R,RINT,STATS] = regress(Y, [X, ones(N(2),1)]);
rsq(1) = STATS(1);

for i=1:length(offsets), 
    Y = y(1:N(2)-offsets(i))'; 
    X = [x1(1:(N(2)-offsets(i))); x2(:,(1+offsets(i)):N(2))]'; 
    [B,BINT,R,RINT,STATS] = regress(Y,[X, ones(N(2)-offsets(i),1)]);
    rsq(1+i) = STATS(1);
end
for i=1:length(offsets),
    Y = y(1+offsets(i):N(2))';
    X = [x1(1+offsets(i):N(2)); x2(:,1:N(2)-offsets(i))]';
    [B,BINT,R,RINT,STATS] = regress(Y,[X, ones(N(2)-offsets(i),1)]);
    rsq(1+length(offsets)+i) = STATS(1);
end
