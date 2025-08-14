function F = uminus(F)
%-   CHEBFUN unary minus.
%   -F negates the CHEBFUN F.
%
%   G = UMINUS(A) is called for the syntax '-A'.

% Copyright 2017 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

if is_octave()
    % implementation below hits a COW bug in upstream octave
    % https://github.com/cbm755/chebfun/issues/13
    % https://savannah.gnu.org/bugs/index.php?54028
    F = -1*F;
    return
end

% Handle the empty case:
if ( isempty(F) )
    return
end

% Loop over the columns:
for j = 1:numel(F) 
    % Negate the pointValues:
    F(j).pointValues = -F(j).pointValues;

    % Negate each of the FUNs:
    for k = 1:numel(F(j).funs)
        F(j).funs{k} = uminus(F(j).funs{k});
    end
end

end
