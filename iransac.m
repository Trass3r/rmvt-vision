%   data is NxM where M is the number of data points, each of dimension N

function iransac(func, data, varargin)

    global iransac_func

    options.est_fun = @estfunc;
    options.man_fun = @errorfunc;

    sigma = 0;

    % set RANSAC options
    options.epsilon = 1e-6;
    options.P_inlier = 1-1e-4;
    options.sigma = sigma;
    options.validateMSS_fun = [];
    options.est_fun = @estfunc;
    options.man_fun = @errorfunc;
    options.mode = 'MSAC';
    options.Ps = [];
    options.notify_iter = [];
    options.min_iters = 1000;
    options.fix_seed = false;
    options.reestimate = true;
    options.stabilize = false;

    iransac_func = func;

    [results,options] = RANSAC(data, options);
end

%   est_fun             = function that estimates Theta.
%                         [Theta k] = estimate_foo(X, s)
%
function [theta,k] = estfunc(X, s)
    global iransac_func

    disp('estfunc');
    if (nargin == 0) || isempty(X)
        theta = [];
        k = iransac_func('size');
        return;
    end;

    if (nargin == 2) && ~isempty(s)
        X = X(:, s);
    end;
    theta = iransac_func('estimate', X);
end

%   man_fun             = function that returns the residual error.
%                         Should be in the form of:
%
%                         [E T_noise_squared] = man_fun(Theta, X)
function [E,T_noise] = errorfunc(theta, X, sigma, P_inlier)
    global iransac_func

    disp('errorfunc');
    E = []
    if ~isempty(theta) && ~isempty(X)
        E = iransac_func('error', X, theta);
    end
if (nargout > 1)
    
    if (P_inlier == 0)
        T_noise = sigma;
    else
        % Assumes the errors are normally distributed. Hence the sum of
        % their squares is Chi distributed (with 4 DOF since the symmetric 
        % distance contributes for two terms and the dimensionality is 2)
        
        % compute the inverse probability
        T_noise = sigma^2 * chi2inv_LUT(P_inlier, 4);

    end;
    
end;

end

% results           = structure containing the following fields:
%
%   Theta               = estimated parameter vector
%   E                   = fitting error obtained from man_fun
%   CS                  = consensus set (true -> inliers, false -> outliers)
%   J                   = cost of the solution
%   iter                = number of iterations
%   time                = time to perform the computation

% X                 = input data. The data id provided as a matrix that has
%                     dimesnsions 2dxN where d is the data dimensionality
%                     and N is the number of elements
%
% options           = structure containing the following fields:
%
%   sigma               = noise std
%   P_inlier            = Chi squared probability threshold for inliers
%                         (i.e. the probability that an point whose squared
%                          error is less than T_noise_squared is an inlier)
%                         (default = 0.99)
%   T_noise_squared     = Error threshold (overrides sigma)
%   epsilon             = False Alarm Rate (i.e. the probability we never
%                         pick a good minimal sample set) (default = 1e-3)
%   Ps                  = sampling probability ( 1 x size(X, 2) )
%                         (default: uniform, i.e. Ps is empty)
%   ind_tabu            = logical array indicating the elements that should
%                         not be considered to construct the MSS (default
%                         is empty)
%   validateMSS_fun     = function that validates a MSS
%                         Should be in the form of:
%
%                         flag = validateMSS_foo(X, s)
%
%   validateTheta_fun   = function that validates a parameter vector
%                         Should be in the form of:
%
%                         flag = validateTheta_foo(X, Theta, s)
%
%   est_fun             = function that estimates Theta.
%                         Should be in the form of:
%
%                         [Theta k] = estimate_foo(X, s)
%
%   man_fun             = function that returns the residual error.
%                         Should be in the form of:
%
%                         [E T_noise_squared] = man_fun(Theta, X)
%
%   mode                = algorithm flavour
%                         'RANSAC'  -> Fischler & Bolles
%                         'MSAC'    -> Torr & Zisserman
%
%
%   max_iters           = maximum number of iterations  (default = inf)
%   min_iters           = minimum number of iterations  (default = 0)
%   max_no_updates      = maximum number of iterations with no updates
%                         (default = inf)
%   fix_seed            = true to fix the seed of the random number
%                         generator so that the results on the same data
%                         set are repeatable (default = false)
%   reestimate          = true to resestimate the parameter vector using
%                         all the detected inliers
%                         (default = false)
%   verbose             = true for verbose output
%                         (default = true)
%   notify_iters        = if verbose output is on then print some
%                         information every notify_iters iterations.
%                         If empty information is displayed only for
%                         updates (default = [])
%
% OUTPUT:
%
