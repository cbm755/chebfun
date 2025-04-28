function display(X)
%DISPLAY   Display information about a CHEBFUN.
%   DISPLAY(F) outputs important information about the CHEBFUN F to the command
%   window, including its domain of definition, its length (number of sample
%   values used to represent it), and a summary of its values at its endpoints.
%   DISPLAY(F) is called automatically when the semicolon is not used at the end
%   of a statement that results in a CHEBFUN.
%
%   Note that the VSCALE displayed is that returned by VSCALE(F, 'SUP').
%
% See also DISP.

% Copyright 2017 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org/ for Chebfun information.

if (exist('OCTAVE_VERSION', 'builtin') )
    if (compare_versions(OCTAVE_VERSION(), '4.3.0', '>='))
        [fmt, spacing] = format();
        loose = strcmp(spacing, 'loose');
    else
        loose = eval('! __compactformat__ ()');
    end
else
    loose = strcmp(get(0, 'FormatSpacing'), 'loose');
end

if ( ~ loose )
    disp([inputname(1), ' =']);
    disp(X);
else
    fprintf('\n');
    disp([inputname(1), ' =']);
    fprintf('\n');
    disp(X);
end

end
