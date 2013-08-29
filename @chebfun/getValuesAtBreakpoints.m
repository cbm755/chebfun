function vals = getValuesAtBreakpoints(funs, ends, op)
%GETVALUESATBREAKPOINTS   Determine values between neighbouring FUN objects.
%   VALS = GETVALUESATBREAKPOINTS(FUNS, ENDS, OP) returns the values at
%   breakpoints ENDS between FUN objects. If OP can be evaluated at ENDS then
%   VALS = OP(ENDS). Otherwise VALS(j) is the average of the right and left
%   limits of its neighbouring funs for interior breaks and the limits from the
%   left and right for the VALS(1) and VALS(end), respectively.

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org for Chebfun information.

% Determine the number of intervals:
numFuns = numel(funs);

% Trivial empty case:
if ( (numFuns == 1) && isempty(funs) )
    vals = [];
    return
end

% Determine the number of columns:
numCols = size(funs{1}, 2);

% Initialise vals:
vals = zeros(numFuns+1, numCols);

if ( (nargin < 3) || isnumeric(op) || iscell(op) )
    % Function handle not provided.

    vals(1,:) = get(funs{1}, 'lval');
    % Take the mean of the FUNs on either side of the break:
    for k = 2:numFuns
        vals(k,:) = (get(funs{k-1}, 'rval') + get(funs{k}, 'lval'))/2;
    end
    vals(numFuns+1,:) = get(funs{numFuns}, 'rval');

else
    % Function handle provided.

    % Evaluate the function handle at the breaks:
    vals(1:numFuns+1,:) = feval(op, ends.');

end

end