function f = plus(obj, g)
%+   CHEBFUN plus.
%   F + G adds CHEBFUNs F and G, or a scalar to a CHEBFUN if either F or G is a
%   scalar.
%
%   H = PLUS(F, G) is called for the syntax 'F + G'.
%
%   The dimensions of F and G must be compatible. Note that scalar expansion is
%   _not_ supported if both F and G are CHEBFUN objects.

% Copyright 2017 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.
f = chebfun();

if ( ~isa(obj, 'chebfun') )   % ??? + CHEBFUN
    
    % Ensure CHEBFUN is the first input:
    f = plus(g, obj);
    return
    
elseif ( isempty(g) )       % CHEBFUN + []
    
    f = [];
    return
    
elseif ( isnumeric(g) )     % CHEBFUN + double

    temp_funs = obj.funs;
    temp_pointValues = obj.pointValues;
    temp_domain = obj.mydomain;
    
    if ( numel(obj) == 1 )
        % Array-valued case:
        
        % Transpose g if f is transposed:
        if ( obj(1).isTransposed )
            g = g.';
        end
        
        % Add g to the FUNs:
	
        for k = 1:numel(obj.funs)
            f.funs{k} = temp_funs{k} + g;
        end
	% todo: reassign?
        % Add g to the pointValues:
        if ( (size(temp_pointValues, 2) == 1) &&  (numColumns(f) > 1) )
            f.pointValues = repmat(temp_pointValues, 1, size(g, 2)); % Allow expansion in f.
        end
        if ( size(g, 2) > 1 )
            g = repmat(g, length(obj.domain), 1);             % Allow expansion in g.
        end
        %disp("before set")
        %disp(obj.pointValues)
        
        f.pointValues = temp_pointValues + g; 
        %f = set_private_point_values(f, "pointValues", temp_pointValues + g); 
        %disp("after set")
        %f.pointValues = temp_pointValues + g;
    else
        % Quasimatrix case:
        
        numCols = numel(obj);
        % Promote g if required:
        if ( isscalar(g) )
            g = repmat(g, 1, numCols);
        elseif ( length(g) ~= numCols || min(size(g)) ~= 1 )
            error('CHEBFUN:CHEBFUN:plus:dims', 'Matrix dimensions must agree.');
        end
        % Transpose g if f is a row CHEBFUN:
        if ( f(1).isTransposed )
            g = g.';
        end
        % Loop over the columns:
        for k = 1:numCols
            f(k) = f(k) + g(k);
        end
        
    end
    
elseif ( ~isa(g, 'chebfun') ) % CHEBFUN + ???
    
    error('CHEBFUN:CHEBFUN:plus:unknown', ...
        ['Undefined function ''plus'' for input arguments of type %s ' ...
        'and %s.'], class(f), class(g));
    
elseif ( isempty(obj) )         % empty CHEBFUN + CHEBFUN
    
    % Nothing to do. (Return empty CHEBFUN as output).
    return
    
else                          % CHEBFUN + CHEBFUN
    
    temp_funs = obj.funs;
    temp_pointValues = obj.pointValues;
    temp_domain = obj.mydomain;
    
    % Check to see if one CHEBFUN is transposed:
    if ( xor(f(1).isTransposed, g(1).isTransposed) )
        error('CHEBFUN:CHEBFUN:plus:matdim', ...
            'Matrix dimensions must agree. (One input is transposed).');
    end
        
    dimCheck(obj, g);
    
    if ( numel(obj) == 1 && numel(g) == 1 )
        % CHEBFUN case:
        
        % If one of the two CHEBFUNs uses a PERIODICTECH reprensetation, 
        % cast it to a NONPERIODICTECH.
        if ( ~isPeriodicTech(temp_funs{1}) && isPeriodicTech(g.funs{1}) )
            g = chebfun(g, g.domain, 'tech', get(f.funs{1}, 'tech'));
        elseif ( isPeriodicTech(temp_funs{1}) && ~isPeriodicTech(g.funs{1}) )
            f = chebfun(obj, obj.domain, 'tech', get(g.funs{1}, 'tech'));
        end
        
        % Overlap the CHEBFUN objects:
        [f, g] = overlap(obj, g);
        
        % Add the pointValues:
        f.pointValues = temp_pointValues + g.pointValues;
        % Add the FUNs:
        for k = 1:numel(temp_funs)
            f.funs{k} = temp_funs{k} + g.funs{k};
        end

    else
        % QUASIMATRIX case:
        
        % Convert to cell for simplicity
        f = cheb2cell(obj);
        g = cheb2cell(g);
        
        % Loop over the columns:
        if ( numel(obj) == 1 )
            for k = numel(g):-1:1
                h(k) = obj{1} + g{k};
            end
        elseif ( numel(g) == 1 )
            for k = numel(f):-1:1
                h(k) = obj{k} + g{1};
            end
        else % numel(f) = numel(g)
            for k = numel(obj):-1:1
                h(k) = obj{k} + g{k};
            end
        end
        f = h;
        
    end

end

f.mydomain = temp_domain;

%disp(f);
%disp(f.funs);
%disp(f.mydomain);
%disp(f.pointValues);

% Set small breakpoint values to zero:
f = thresholdBreakpointValues(f);

end