function [Q, R, E] = qr(f, outputFlag)
%QR   QR factorisation of an array-valued FOURTECH.
%   [Q, R] = QR(F) returns a QR factorisation of F such that F = Q*R, where the
%   FOURTECH Q is orthogonal (with respect to the continuous L^2 norm on [-1,1])
%   and of the same size as F and R is an m x m upper-triangular matrix when F
%   has m columns.
%
%   [Q, R, E] = QR(F) produces unitary Q, upper-triangular R, and a permutation
%   matrix E so that F*E = Q*R. The column permutation E is chosen to reduce
%   fill-in in R.
%
%   [Q, R, E] = QR(F, 'vector') returns the permutation information as a vector
%   instead of a matrix.  That is, E is a row vector such that F(:,E) = Q*R.
%   Similarly, [Q, R, E] = QR(F, 'matrix') returns a permutation matrix E. This
%   is the default behavior.
%
%   [1] L.N. Trefethen, "Householder triangularization of a quasimatrix", IMA J
%   Numer Anal (2010) 30 (4): 887-897.

% Copyright 2014 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

% Deal with empty case:
if ( isempty(f) )
    Q = f;
    R = [];
    E = [];
    return
end

% Default option:
defaultOutput = 'matrix';

if ( nargin < 2 || isempty(outputFlag) )
    outputFlag = defaultOutput;
end

% If f has only one column we simply scale it.
if ( size(f, 2) == 1 )
    R = sqrt(innerProduct(f, f));
    Q = f./R;
    E = 1;
    return
end

% Simplify so that we don't do any extra work: (QR is O(m*n^2)? :/ )
f = simplify(f);

% Call Trefethen's Householder implementation:
[Q, R, E] = qr_householder(f, outputFlag);

% Update epslevel.
% Since we don't know how to do this properly, we essentially assume that QR has
% condition number one. Therefore we assume Q has the same global accuracy as f,
% and simply factor out the new vscale. [TODO]: It may be sensible to include some
% knowledge of R here?
col_acc = f.epslevel.*f.vscale;  % Accuracy of each column in f.
glob_acc = max(col_acc);         % The best of these.
epslevelApprox = glob_acc./Q.vscale; % Scale out vscale of Q.
Q.epslevel = updateEpslevel(Q, epslevelApprox);

end

function [f, R, Eperm] = qr_householder(f, flag)

% Get some useful values
[n, numCols] = size(f);
tol = max(f.epslevel.*f.vscale);

% Make the discrete analog of f:
newN = 2*max(n, numCols);
A = get(prolong(f, newN), 'values');

% Create the Fourier nodes and quadrature weights:
x = f.fourpts(newN);
w = f.quadwts(newN);

% Define the inner product as an anonymous function:
ip = @(f, g) w * (conj(f) .* g);

% Work with sines and cosines instead of complex exponentials.
E1 = cos(pi*x*(0:floor(numCols/2))); E1(:,1) = E1(:,1)/sqrt(2); 
E2 = sin(pi*x*(1:ceil(numCols/2)-1));
E = zeros(size(A));
E(:,[1 2:2:end]) = E1; 
E(:,3:2:end) = E2; 

% Call the abstract QR method:
[Q, R] = abstractQR(A, E, ip, @(v) norm(v, inf), tol);

f.values = Q; 
f.coeffs = f.vals2coeffs(Q); 

% If any columns of f where not real, we cannot guarantee that the colummns
% of Q should remain real.
f.isReal(:) = all(f.isReal);

% Update the vscale:
f.vscale = max(abs(f.values), [], 1);

% Additional output argument:
if ( nargout == 3 )
    if ( nargin == 2 && strcmp(flag, 'vector') )
        Eperm = 1:numCols;
    else
        Eperm = eye(numCols);
    end
end

end