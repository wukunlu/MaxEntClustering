function [Lambda] = sensitivity_embed_m(W, Lambda_bp, z, net, varargin)
% ---------------- calculate the sensitivity of top layer 
% input: 
%        z:  net input at M layer, i.e., z = w_{M}h_{M-1}+b_{M}
%        Lambda_bp: sensitivity of J2 at m+1 layer
%        H:  the representation of x at the M/2-layer
% output: 
%        Lambda: the sensitivity of J2 at M/2 layer (i.e., the mid layer)
% written by Xi Peng
% Dec. 2015, I2R, A*STAR
% ---------------- 
if  length(varargin)==0 % default 
    sd = 1 - tanh(z).^2;  % gradient of s(z_{m}), default func is tanh
else
    switch cell2mat(varargin{1})
        case 'tanh'
            sd = 1 - tanh(z).^2;
        case 'sigmoid' 
            tmp = 1 ./ (1 + exp(-z));
            sd = tmp .* (1-tmp);
        case 'nssigmoid'
            [~, sd] = nonsaturate_sigmoid_act(z);
        case 'relu'            
            alpha = net.alpha;
            sd = 1./(1+exp(-alpha*z));
        otherwise
            fprintf('The specified activation fun (%s) is not support!\n', varargin);
    end
end

Lambda = W'*Lambda_bp.*sd;
