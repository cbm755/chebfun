function varargout = fourcoeffs(f,N)
%FOURCOEFFS   Fourier coefficients of a CHEBFUN.
%   C = FOURCOEFFS(F, N) returns the first N Fourier coefficients of F
%   using complex-exponential form.  Specifically: 
%   If N is odd
%       F(x) = C(1)*z^(N-1)/2 + C(2)*z^((N-1)/2-1) + ... + C((N+1)/2) + ... 
%                + C(N)*z^(-(N-1)/2)
%   If N is even
%       F(x) = C(1)*z^(N/2-1) + C(2)*z^(N/2-2) + ... + C(N/2) + ...
%                + C(N-1)*z^(-N/2-1) + 1/2*C(N)*(z^(N/2) + z^(-N/2))
%   where z = exp(1i*omega*x) and omega = 2*pi/L, and L = diff(f.domain). 
%
%   If F is array-valued with M columns, then C is an MxN matrix.
%
%   [A,B] = FOURCOEFFS(F, N) returns the first N Fourier coefficients of F
%   using trignometric form.  Specifically:
%   If N is odd
%      F(x) = A(1)*cos((N-1)/2*omega*x) + B(1)*sin((N-1)/2*omega*x) +  
%             A(2)*cos((N-1)/2-1)*omega*x) + B(2)*sin((N-1)/2-1)*omega*x) +
%             ... + A((N-1)/2)*cos(omega*x) + B((N-1)/2)*sin(omega*x) + A((N+1)/2)
%   If N is even
%      F(x) = A(1)*cos(N/2*omega*x) + B(1)*sin(N/2*omega*x) +  
%             A(2)*cos((N/2-1)*omega*x) + B(2)*sin((N/2-1)*omega*x) + 
%             ... + A(N/2-1)*cos(omega*x) + B(N/2-1)*sin(omega*x) + A(N/2)
%   where omega = 2*pi/L, and L = diff(f.domain).
%   Note that the number of rows in A exceeds the number of rows in B by 1
%   since A contains the constant term.
%
%   If F is array-valued with M columns, then C (or A and B) contain(s) M
%   rows with each row corresponding to the Fourier coefficients for
%   chebfun.
%
% See also CHEBCOEFFS.

% Copyright 2014 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org/ for Chebfun information.

% Trivial empty case:
if ( isempty(f) )
    varargout = [];
    return
end

if ( numel(f) > 1 )
    % TODO: Why not?
    error('CHEBFUN:fourcoeffs:quasia', 'FOURCOEFFS does not support quasimatrices.');
end

%% Error checking:
if nargin == 1
    error('CHEBFUN:fourcoeffs:inputN','Input N is required.')
end

if ( N <= 0 )
    varargout = [];
    return
end
if ( ~isscalar(N) || isnan(N) )
    error('CHEBFUN:chebpoly:inputN', 'Input N must be a scalar.');
end

% Force N to be odd.
N = N + 1 - mod(N,2);

numFuns = numel(f.funs);

if ( numFuns ~= 1 )
    f = merge(f);
end

%% Compute the coefficients.

if ~f.funs{1}.onefun.ishappy
    warning('These results may not be accurate since f is not resolved. Consider reconstructing f with splitting on');
end

if isa(f.funs{1}.onefun,'fourtech') && numFuns == 1
    C = fourcoeffs(f.funs{1}.onefun,N).';
% Compute the coefficients via inner products.
else
    if isa(f.funs{1}.onefun,'fourtech')
        f = four2cheb(f);
    end
    d = f.domain([1, end]);
    L = diff(d);
    omega = 2*pi/L;
    x = chebfun('x', d, 'tech','chebtech');
    numCols = numColumns(f);
    C = zeros(numCols, N);
    f = mat2cell(f);
    % Handle the possible non-symmetry in the modes.
    if mod(N,2) == 1
        modes = (N-1)/2:-1:-(N-1)/2;
    else
%         modes = N/2-1:-1:-N/2;
        modes = N/2:-1:-N/2;
    end
    for j = 1:numCols
        count = 1;
        for k = modes
            F = exp(-1i*k*omega*x);
            I = (f{j}.*F);
            C(j, count) = 1/L*sum(I);
            count = count + 1;
        end
    end
end

varargout{1} = C;

end