frequencies = [40]; % frequencies to analyze (in Hz)
bandwidth = 0.5; % filter around each frequency using this
                 % bandwidth (relative to the center frequency). 
                 % used for 20 Hz and 40 Hz; for 60Hz, used: 0.33333333

window = round(data.x.fs); %fs is sampling frequencies. window is the number of samples in each second (window is 1sec)
dt = 1/data.x.fs; %timestep

nshuffles = 100; %number of shuffles

clear rsq x z allshuf meanshuf shuf95 shuf99 maxshuf;
x(1,:) = double(data.x.data(1,:)); %convert datatype to double with sev function
x(2,:) = double(data.x.data(2,:));
x(3,:) = double(data.x.data(3,:));
x(4,:) = double(data.x.data(4,:));

N = length(x(1,:)); %length of data points there are

nf = 0; %initializing counter of frequencies

R = ceil((N-window)*rand(1,nshuffles)); %to randomly choose time segments for shuffled data

for f=frequencies,
    nf = nf + 1
    L = ceil(3*(1/f*(1-0.5*bandwidth))/dt+1); %length of time it will filter
    B = fir1(L, f*[1-0.5*bandwidth 1+0.5*bandwidth]*dt*2);%generates filter
    for i=1:4,
        z(i,:) = filtfilt(B, 1, x(i,:)); %z is filtered version of x (runs forward and backward using filtfilt -- if it goes in one direction, there will be a phase delay
    end
    
    n = 0;%going through vector from first timepoint to end. take data in 1sec chunks. n is chunk number
    for in=1:window:(N-window),
        n = n+1
       rsq{nf}(n,:) = tempofit(z(3,in:in+window-1), z(4,in:in+window-1), z(1:2,in:in+window-1), []);
        for i=1:nshuffles, %does regression to use 3 inputs to fit 4
            % shuffle one mneon signal and compute the goodness of
            % fit using the shuffled signal
            tmp(i,:) = tempofit(z(3,in:in+window-1), z(4,in:in+window-1), [z(1,R(i):R(i)+window-1); z(2,in:in+window-1)], []);%1 is right mneon shuffled,
        end
        tmp2 = sort(tmp);
        shuf99(1,n) = tmp2(99,1);
    end
end