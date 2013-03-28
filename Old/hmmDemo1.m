prtPath( 'alpha', 'beta' ); %for prtDataSetTimeSeries
A = [.9 .1 0; 0 .9 .1; .1 0 .9];
gaussians = repmat(prtRvMvn('sigma',eye(2)),3,1);
gaussians(1).mu = [-2 -2];
gaussians(2).mu = [2 -2];
gaussians(3).mu = [2 2];

sourceHmm = prtRvHmm('pi',[1 1 1]/3,...
    'transitionMatrix',A,...
    'components',gaussians);
%x = sourceHmm.draw([100 150 100 300 100 25]);
x = sourceHmm.draw([100 100 100 100 100 100]);

%x = sourceHmm.draw([250]);
ds = prtDataSetTimeSeries(x);

gaussiansLearn = repmat(prtRvMvn,3,1);
learnHmm = prtRvHmm('components',gaussiansLearn);
learnHmm = learnHmm.mle(ds);
learnHmm.logPdf(ds)

%% 
prtPath( 'alpha', 'beta' ); %for prtDataSetTimeSeries
A = [.9 .1;.9 .1];
gaussians = repmat(prtRvMvn('sigma',eye(2)),2,1);
gaussians(1).mu = [-2 -2];
gaussians(2).mu = [2 -2];
%gaussians(3).mu = [2 2];

sourceHmm = prtRvHmm('pi',[1 0],...
    'transitionMatrix',A,...
    'components',gaussians);
%x = sourceHmm.draw([100 150 100 300 100 25]);
x = sourceHmm.draw([100 100 100 100 100 100]);

%x = sourceHmm.draw([250]);
ds = prtDataSetTimeSeries(x);

gaussiansLearn = repmat(prtRvMvn,2,1);
learnHmm = prtRvHmm('components',gaussiansLearn);
learnHmm = learnHmm.mle(ds);
learnHmm.logPdf(ds)



%%

newA = [.7 .3 0; 0 .9 .1; .2 0 .8];
newGaussians = repmat(prtRvMvn('sigma',eye(2)),3,1);
newGaussians(1).mu = [-1 -2];
newGaussians(2).mu = [2 -1];
newGaussians(3).mu = [2 3];

newHmm = prtRvHmm('pi',[1 1 1]/3,...
    'transitionMatrix',newA,...
    'components',newGaussians);
z = newHmm.draw([100 100 100 100 100 100]);
newDs = prtDataSetTimeSeries(z);

likelihoods = [learnHmm.logPdf(ds),learnHmm.logPdf(newDs)]

[~,class] = max(likelihoods,[],2) % should pick class 1 every time

