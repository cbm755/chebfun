function display(X)
%DISPLAY   Display information about a LINOP.
%
% See also DISP.

% Copyright 2017 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org/ for Chebfun information.

  if is_octave()
    [fmt, spacing] = format();
    compact = strcmp(spacing, 'compact');
else
    compact = strcmp(get(0, 'FormatSpacing'), 'compact');
end

if ( compact )
	disp([inputname(1), ' =']);
	disp(X);
else
	disp(' ');
	disp([inputname(1), ' =']);
	disp(' ');
    disp(X);
end

end


