classdef (InferiorClasses = {?double}) chebop
%CHEBOP  CHEBOP class for representing operators on functions defined on [a,b].
% N = CHEBOP(OP) creates a CHEBOP object N with operator defined by OP, which
% should be a handle to a function (often created using an anonymous function)
% that accepts a chebfun or a chebmatrix consisting of chebfuns and scalars as
% input and returns a CHEBFUN (or CHEBMATRIX). The first input argument to OP is
% the independent variable X, while all others represent dependent functions of
% X; if only one input argument is accepted by OP, it is the dependent variable.
% In case of coupled systems, the function OP must return vertically, not
% horizontally, concatenated elements. Note, this differs from the V4 syntax.
%
% Examples of N.OP:
%
%   One dependent variable:
%       @(x, u) x.*diff(u) + u;
%   No explicit independent variable:
%       @(u) diff(u,2) - exp(u);
%   Three dependent variables:
%       @(x, u, v, w) [ u.*diff(v) ; diff(u, 2) + w; diff(w) - v ];
%   Three dependent variables, chebmatrix syntax:
%       @(x, u) [ u{1}.*diff(u{2}) ; diff(u{1}, 2) + u{3}; diff(u{3}) - u{2} ];
%   Function handle to a function defined in an .m-file:
%       @myOperator
%
% Note that when N.OP has two or more input arguments, the first one _MUST_ be
% the independent variable. When N.OP is specified as a function handle to a
% method specified in an .m-file, like in the last example above, and that
% function uses the CHEBMATRIX notation, e.g. diff(u{1}) + u{2}), it is
% necessary to either pass an initial guess to the operator via N.INIT (see
% below), or specify the number of variables that the operator operates on via
% N.NUMVARS.
%
% The number of elements in the output CHEBMATRIX should typically equal the
% number of dependent variables, whether specified as names or CHEBMATRIX
% elements (see section on parameter-dependent problems below).
%
% By default, the operator acts on CHEBFUN objects defined on the domain [-1,1].
% CHEBOP(OP, D), for a vector D, gives a different domain, with breakpoints (if
% any) described by D.
%
% %% BOUNDARY CONDITIONS: %%
%
% CHEBOP(OP, D, LBC, RBC) specifies boundary conditions for functions at the
% left and right endpoints of the domain D. Possible values for LBC and RBC are:
%
%   []          : No condition (for only assigning LBC or RBC in constructor).
%   scalar      : All variables equal the given value.
%   'dirichlet' : All variables equal zero.
%   'neumann'   : All variables have derivative zero.
%   function    : A function handle that must accept all dependent variables as
%                 given in OP and return a CHEBFUN or CHEBMATRIX. All elements
%                 of the result are evaluated at the endpoint, and for the
%                 solution of the BVP, they are made to equal zero.
%
% A boundary condition function may be nonlinear; it must not accept the
% independent variable X as an input. Again, in case of systems, the function
% describing the boundary conditions must return vertically concatenated
% elements (again, differing from V4 syntax).
%
% Examples of boundary condition functionals::
%
%   @(u) diff(u) - 2;               % set u' = 2 at the appropriate endpoint
%   @(u, v, w) [ u - 1 ; w ];       % set u = 1 and w = 0 at the endpoint
%   @(u) [u{1} - 1; u{3}];          % Same as above, using CHEBMATRIX syntax.
%   @(u, v, w) u.*v - diff(w);      % set u*v = w' at the endpoint
%
% CHEBOP(OP, D, BC) gives boundary or other side conditions in an alternate
% form. Choices for BC are:
%
%   scalar      : All variables equal the given value at both endpoints.
%   'dirichlet' : All variables equal zero at both endpoints.
%   'neumann'   : All variables have derivative zero at both endpoints.
%   'periodic'  : Impose periodicity on all dependent variables.
%   function    : See below.
%
% Note that the 'dirichlet' and 'neumann' keywords impose behavior that may not
% be identical to the common understanding of Dirichlet or Neumann conditions in
% every problem. When BC is passed in the CHEBOP call, the more specialized
% fields LBC and RBC are ignored. Furthermore, note that CHEBOP(OP, DOM, 0) is
% not equivalent to CHEBOP(OP, DOM, 0, []).
%
% If BC is given a function handle, then each condition must give points
% explicitly or otherwise evaluate to a scalar. The function handle must return
% a column vector, not a row vector. Example:
%   @(x, u) [ u(1) - u(0) ; sum(x.*u) ] % set u(1) = u(0), and integral
%                                       % of x.*u over the whole interval = 0.
%
% Boundary conditions may also be assigned to the CHEBOP N after it has been
% constructed, by N.lbc = ..., N.rbc = ..., and N.bc = ... . This will overwrite
% the conditions currently stored in the field being assigned to, but not the
% other fields, with an exception of keywords as noted below).
%
% CHEBOP(OP, ..., 'init', U) provides a CHEBFUN/CHEBMATRIX as a starting point
% for nonlinear iterations or a PDE solution. See CHEBOP/SOLVEBVP and
% CHEBOP/PDE15S for details.
%
% Note that many fields can be set after the CHEBOP object N is created: N.op,
% N.lbc, N.rbc, N.bc, N.init can all be assigned new values. Setting N.bc to any
% of 'dirichlet', 'neumann', or 'periodic', removes pre-existing entries in
% N.lbc, N.rbc, and N.bc.
%
% Example:
%
%   N = chebop(-5, 5);  % Constructs an empty CHEBOP on the interval [-5,5]
%   N.op = @(x, u) 0.01*diff(u, 2) - x.*u;
%   N.bc = 'dirichlet';
%   plot(N\1)
%
% %% PARAMETER DEPENDENT PROBLEMS: %%
%CHEBGUIexporterEIG
% CHEBOP supports solving systems of equations containing unknown parameters
% without the need to introduce extra equations into the system. Simply add the
% unknown parameters as the final variables.
%
% Example:
%
%   % y'' + x.*y + p = 0, y(-1) = 1, y'(-1) = 1, y(1) = 1 can be solved via
%   N = chebop(@(x, y, p) diff(y,2) + x.*y + p)
%   N.lbc = @(y, p) [y - 1 ; diff(y)];
%   N.rbc = @(y, p) y - 1;
%   plot(N\0)
%
% Parameters can be positioned at different locations if a double is passed in
% the CHEBMATRIX input to N.init.
%
% Example:
%
%   N = chebop(@(x, p, y) diff(y,2) + x.*y + p)
%   N.lbc = @(p, y) [y - 1 ; diff(y)];
%   N.rbc = @(p, y) y - 1;
%   N.init = [1 ; chebfun(1)];
%   plot(N\0)
%
% See also CHEBOP/MTIMES, CHEBOP/MLDIVIDE, CHEBOPPREF.

% Copyright 2014 by The University of Oxford and The Chebfun Developers. See
% http://www.chebfun.org/ for Chebfun information.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CLASS PROPERTIES:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties ( Access = public )
        domain = [];    % Domain of the operator
        op = [];        % The operator
        lbc = [];       % Left boCHEBGUIexporterEIGundary condition(s)
        rbc = [];       % Right boundary condition(s)
        bc = [];        % Other/internal/mixed boundary conditions
        init = [];      % Initial guess of a solution
        numVars = [];   % Number of variables the the CHEBOP operates on.
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CLASS CONSTRUCTOR:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Access = public, Static = false )
        
        function N = chebop(op, dom, lbcIn, rbcIn, init)
            % CHEBOP constructor
            
            if ( nargin == 0 )
                return
            end
            
            % No domain passed:
            if ( nargin < 2 )
                if ( ~isnumeric(op) )
                    % Get default domain from CHEBPREF():
                    p = cheboppref();
                    dom = p.domain;
                else
                    % DOM was passed, but no OP.
                    dom = op;
                    op = [];
                end
            elseif ( nargin == 2 && isnumeric(op) )
                dom = [op, dom];
                op = [];
            end
            
            % Assign operator and domain:
            N.op = op;
            N.domain = dom;
            
            % Assign BCs and INIT if they were passed:
            if ( nargin == 3 )
                % CHEBOP(OP, DOM, BC):
                N.bc = lbcIn;
            elseif ( nargin == 4 )
                if ( isa(rbcIn, 'function_handle') || ischar(rbcIn) || ...
                        isnumeric(rbcIn))
                    % CHEBOP(OP, DOM, LBC, RBC):
                    N.lbc = lbcIn;
                    N.rbc = rbcIn;
                else
                    % CHEBOP(OP, DOM, BC, INIT):
                    N.bc = lbcIn;
                    N.init = rbcIn;
                end
            elseif ( nargin >= 4 )
                % CHEBOP(OP, DOM, LBC, RBC, INIT):
                N.lbc = lbcIn;
                N.rbc = rbcIn;
                N.init = init;
            end
            
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CLASS METHODS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Access = public, Static = false )
        
        % Find selected eigenvalues and eigenfunctions of a linear CHEBOP.
        varargout = eigs(N, varargin)
        
        % Linearize a CHEBOP around a CHEBFUN u.
        [L, res, isLinear, u] = linearize(N, u, x, flag);  
        
        %\   Chebop backslash.
        varargout = mldivide(N, rhs, pref)
        
        % The number of input arguments to a CHEBOP .OP field.
        nIn = nargin(N)
        
        % Alternate & syntax for BC's.
        N = and(N,BC)
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% PRIVATE METHODS:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Access = private, Static = false )

        % Find damped Newton step.
        [u, dampingInfo] = dampingErrorBased(N, u, rhs, delta, L, ...
            disc, dampingInfo)
        
        % Parse boundary conditions for CHEBOP object.
        result = parseBC(N, BC, type)
        
        % Solve a nonlinear problem posed with CHEBOP
        [u, info] = solvebvpNonlinear(N, rhs, L, u0, res, pref, displayInfo)
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% HIDDEN NON-STATIC METHODS IMPLEMENTED IN OTHER FILES:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Access = public, Static = false, Hidden = true )
        
        % Find selected eigenvalues and eigenfunctions of a linear CHEBOP.
        varargout = eig(varargin);
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% STATIC HIDDEN METHODS:       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Access = private, Static = true )
        
        % Controls information displayed for Newton iterations
        [displayFig, displayTimer] = displayInfo(mode, varargin);
        
        % Display at the finish of Newton iteration.
        displayInfoFinal(u, delta, iterNo, errEstDE, errEstBC, displayFig, ...
            displayTimer, pref)
        
        % Display special information when N.INIT solves the BVP:
        displayInfoExactInitial(pref)
        
        % Display at the start of Newton iteration.
        [displayFig, displayTimer] = displayInfoInit(u,pref);
        
        % Display during Newton iteration.        
        [displayTimer, stopReq] = displayInfoIter(u, delta, iterNo, normdu, ...
            cFactor, errEst, lendu, lambda, lenu, displayFig, displayTimer, ...
            pref);
        
        % Display special information for linear problems.
        displayInfoLinear(u, normRes, pref)

        % Solve a linear problem posed with CHEBOP.
        [u, info] = solvebvpLinear(L, rhs, Ninit, displayInfo, pref)
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %% METHODS IMPLEMENTED IN THIS FILE:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    methods
        
        function N = set.lbc(N, val)
            %CHEBOP.SET.LBC   Set left boundary condition of a CHEBOP.
            %   CHEBOP.SET.LBC offers more control of setting left boundary
            %   conditions than simply accessing the .lbc field, or using standard
            %   subsref.
            
            N.lbc = parseBC(N, val, 'lrbc');            
        end
        
        function N = set.rbc(N, val)
            %CHEBOP.SET.RBC   Set right boundary condition of a CHEBOP.
            %   CHEBOP.SET.RBC offers more control of setting right boundary
            %   conditions than simply accessing the .rbc field, or using standard
            %   subsref.
            
            N.rbc = parseBC(N, val, 'lrbc');
        end
        
        function N = set.bc(N, val)
            %CHEBOP.SET.BC   Set constraints of a CHEBOP.
            %   CHEBOP.SET.BC offers more control of setting constraints than
            %   simply accessing the .bc field, or using standard subsref. In
            %   particular, note that setting SET.BC(N, VAL) where VAL is
            %   numeric will actually set N.BC = [] and N.LBC = N.RBC = VAL.
            %   SET.BC(N, STR) works similarly when STR is one of 'dirichlet',
            %   'neuman', or 'periodic'.
            
            % Do this in a separate method for clarity.
            if ( isstruct(val) )
                if ( isfield(val,'left') )
                    N.lbc = parseBC(N, val.left, 'lrbc'); %#ok<MCSUP>
                end
                if ( isfield(val, 'right') )
                    N.rbc = parseBC(N, val.right, 'lrbc'); %#ok<MCSUP>
                end
                if ( isfield(val, 'other') )
                    N.bc = parseBC(N, val.other, 'bc');
                end
                
            elseif ( strcmpi(val, 'periodic') )
                N.lbc = [];
                N.rbc = [];
                N.bc = 'periodic';
                
                
            elseif ( ischar(val) || isstruct(val) || isnumeric(val) )
                % V4 style keywords and numeric settings are understood to
                % apply to both ends.
                N.bc = [];
                result = parseBC(N, val, 'bc');
                N.lbc = result; %#ok<MCSUP>
                N.rbc = result; %#ok<MCSUP>
                
            else
                % A proper function was supplied.
                N.bc = parseBC(N, val, 'bc');
                
            end
            
        end
        
        function N = set.op(N, val)
            %CHEBOP.SET.OP   Set the differential equation part of a CHEBOP.
            %   CHEBOP.SET.OP offers more control of setting the DE left
            %   boundary conditions than simply accessing the .op field, or
            %   using standard subsref.
            
            % We're happy with function handles
            if ( isa(val, 'function_handle') || isempty(val) )
                N.op = val;
            elseif ( iscell(val) )
                error('CHEBFUN:CHEBOP:setOp:type', ...
                    ['Specifying differential equation as a cell of ', ...
                    'anonymous \nfunctions is no longer supported. Please '...
                    'use the syntax \n   N.op = @(x,u,v) [diff(u,2) + v; ' ...
                    '...]\ninstead of \n   N.op = {@(x,u,v) diff(u) + v; ' ...
                    '@{x,u,v) ...}']);
            else
                error('CHEBFUN:CHEBOP:setOp:type', ...
                    'Unknown type of argument for .op field of a chebop.');
            end
        end
        
        function N = set.init(N, val)
            %CHEBOP.SET.INIT   Set the initial guess for a nonlinear CHEBOP.
            %   CHEBOP.SET.INIT offers more control of setting the initial guess
            %   for the Newton solves used for nonlinar ODES than simply
            %   accessing the .init field, or using standard subsref. In
            %   particular, it checks that the guess is of an appropriate form
            %   (i.e., CHEBMATRIX rather than quasimatrix.). See CHEBOP
            %   documentation for further details.
            
            % Did we get a horizontally concatenated initial guess?
            if ( isa(val, 'chebfun') && size(val, 2) > 1 )
                val = chebmatrix(mat2cell(val).');
                warning('CHEBFUN:CHEBOP:setInit:vertcat', ...
                    ['Passing a horizontally concatenated initial guess is ' ...
                    'deprecated, and might not be supported in future ' ...
                    'versions of Chebfun. Please use vertical concatenation '...
                    'for initial guesses.'])
            end
            
            N.init = val;
            
        end   
        
        function out = isempty(N)
            %ISEMPTY   Check if the CHEBOP N is empty.            
            out = true;
            % Loop through all the fields of N:
            for prop = fieldnames(N).'
                p = char(prop);
                if ( ~isempty(N.(p)) )
                    % If any field is non-empty, return false:
                    out = false;
                    break
                end
            end
        end
                
        
    end   
    
end

