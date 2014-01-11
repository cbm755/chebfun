function w = baryWeights(x)
%BARYWEIGHTS   Barycentric weights.
%   W = BARYWEIGHTS(X) returns scaled barycentric weights for the points in the
%   columm vector X. The weights are scaled such that norm(W, inf) == 1.

% [TODO]: Should this live in the trunk?

% Check inout dimension:
[n, m] = size(x);
if ( m > 1 )
    if ( n > 1 )
        error('CHEBFUN:baryweights:matrix', 'Input must be a vector.')
    else
        % Allow a row vector:
        n = m;
        x = x.';
    end
end

% Capacity:
if ( isreal(x) )
    C = 4/(max(x) - min(x));   % Capacity of interval.
else
    C = 1; % Scaling by capacity doesn't apply for complex nodes.
end

% Cpmpute the weights:
if ( (n < 2001) )              % For small n using matrices is faster.
   V = C*bsxfun(@minus, x, x.');
   V(1:n+1:end) = 1;
   VV = exp(sum(log(abs(V))));
   w = 1./(prod(sign(V)).*VV).';
   
else                           % For large n use a loop.
   w = ones(n,1);
   for j = 1:n
       v = C*(x(j) - x); v(j) = 1;
       vv = exp(sum(log(abs(v))));
       w(j) = 1./(prod(sign(v))*vv);
   end
end

% Scaling:
w = w./norm(w, inf);

end