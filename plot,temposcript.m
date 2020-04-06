[data] = SEV2mat('C:\Users\vikaa\Dropbox\dlx56 2.0\nature neuroscience\final version\TEMPO example+scripts/TEMPO-EEGsync-170427-171301/720T1-190117-085715/');

temposcript

for f=1,
n = 0;
for i=1:8977-300,
n = n+1;
sig{f}(n) = mean(mean(rsq{f}(i:i+300) > shuf99(i:i+300)'));
end
end


figure('Name', '720T1, 011719, 40Hz', 'NumberTitle', 'off')

imagesc(sig{1})
caxis([0.01 0.1])
colormap('jet')
