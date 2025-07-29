function tf = compatible_verLessThan(package, version)

if (nargin ~= 2)
    error ('CHEBFUN:compatible_verLessThan', ...
        'Needs two arguments PACKAGE and VERSION');
end

if ( ~ischar (package) || height (package) ~= 1)
    error ('CHEBFUN:compatible_verLessThan', ...
        'PACKAGE must be a string');
end

if ( is_octave () )
    % We're going to bail here for now, maybe we'll add a check later
    tf = verLessThan("octave", "9.4.0");
    return; 
end

tf = verLessThan(package, version);
    
end
