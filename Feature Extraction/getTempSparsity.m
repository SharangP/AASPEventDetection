function [ tsparFeatures ] = getTempSparsity(track, nWin,step);
% short time energy

buff_long = buffer(track,nWin,nWin-step);

twoNorm = sqrt(sum(abs(buff_long).^2,1));   % The two-norm of each column
% pNorm = sum(abs(buff_long).^p,1).^(1/p);  % The p-norm of each column (define p first)
infNorm = max(buff_long,[],1);              % The infinity norm (max value) of each column

t_sparse = infNorm./twoNorm;
% t_rat = t_sparse(2:end)./t_sparse(1:end-1);
t_rat = (t_sparse(2:end)-t_sparse(1:end-1)).^2;

mu_ts = mean(t_sparse);
var_ts = var(t_sparse);
max_ts = min(t_sparse);
min_ts = min(t_sparse);

mu_rat = mean(t_rat);
var_rat = var(t_rat);
max_rat = min(t_rat);
min_rat = min(t_rat);

% tsparFeatures = [mu_ts var_ts max_ts min_ts mu_rat var_rat max_rat min_rat];
% tsparFeatures = [mu_rat var_rat max_rat min_rat];

tsparFeatures = [mu_ts var_ts max_ts min_ts];

end

