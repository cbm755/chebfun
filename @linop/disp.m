function disp(L)
%DISP   Pretty-print a linop summary.
%
% See also DISPLAY.

% Copyright 2017 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

% Obtain size of the linop
[m, n] = size(L);

% Determine whether format is compact or loose:
if is_octave()
    [fmt, spacing] = format();
    loose = strcmp(spacing, 'loose');
else
    loose = strcmp(get(0, 'FormatSpacing'), 'loose');
end

if ( loose )
    fprintf('\n');
end

fprintf('   %ix%i linear operator', m,n)

if ( loose )
    fprintf('\n');
end

nc = size(L.constraint.functional, 1);
if ( nc == 1 )
    fprintf('\n   with 1 constraint/boundary condition.')
elseif ( nc > 0 )
    fprintf('\n   with %i constraints/boundary conditions.',nc)
end

if ( loose )
    fprintf('\n');
end

fprintf('\n');

end
