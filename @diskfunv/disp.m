function disp(F)
%DISP   Display a DISKFUNV.
%
% See also DISPLAY.

% Copyright 2017 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information. 

if is_octave()
    [fmt, spacing] = format();
    loose = strcmp(spacing, 'loose');
else
    loose = strcmp(get(0, 'FormatSpacing'), 'loose');
end

% Compact version
if ( isempty( F ) )
    fprintf('empty diskfunv\n\n')
    return
end

% Title in display: 
disp('diskfunv object containing')
if ( loose )
    fprintf('\n');
end

% Display the two DISKFUN components.
for j = 1:F.nComponents
    disp( F.components{j} );
end

end
