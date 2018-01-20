classdef (InferiorClasses = {?chebfun}) domain
%DOMAIN   Utility class for CHEBFUN. Mostly for backward compatibility.

% Copyright 2017 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DOMAIN Class Description:
%
% DOMAIN inherits from a standard Matlab DOUBLE. A domain object only
% contains vector for the endpoints and breakpoints of the interval it
% represents. This class is lightly documented, since it is mostly intended
% for backward compatibility.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CLASS PROPERTIES:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties ( Access = public )
        data
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CLASS CONSTRUCTOR:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Access = public, Static = false )

        function obj = domain(varargin)
            %Constructor for the DOMIAN class.
            
            if ((nargin == 1) && isa (varargin{1}, 'domain'))
                obj = varargin{1};
                return
            end

            % Return an empty DOMAIN on null input:
            if ( nargin == 0 )
                data = [];
            else
                data = horzcat(varargin{:});
            end
            
            % Create the domain:
            %obj = obj@double(data);
            obj.data = data;
            
        end
        
    end     
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CLASS METHODS:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Access = public, Static = false )
        
        function out = validate(x)
            dom = x.data;
            out = true;
            if ( ~isnumeric(dom) || any(isnan(dom)) )
                out = false;
            elseif ( isempty(dom) )
                return
            elseif ( size(dom, 1) > 1 || size(dom, 2) < 2 )
                out = false;
            elseif ( any(diff(dom) <= 0) )
                out = false;
            end
            if ( out == false && nargout == 0 )
                error('CHEBFUN:DOMAIN:domain:invalid', ...
                    'Ends must be a 1xM vector of ordered doubles.');
            end
        end
        
        function display(dom)
            disp(dom.data)
        end

        function out = subsref(d, s)
            % broken on Octave:
            %out = subsref@double(d, s);
            %out = double(out(s));
            switch s.type
                case '()'
                    assert (length(s.subs) == 1)
                    out = d.data(s.subs{1});
                otherwise
                    s
                    error('not implemented')
            end
        end

        function out = numel(d)
            out = numel(d.data);
        end

        function [n,m] = size(d)
            if (nargout == 0 || nargout == 1)
                n = size(d.data);
            elseif (nargout == 2)
                [n, m] = size(d.data);
            else
                error('not implemented');
            end
        end

        function out = transpose(d)
            out = domain(d.data.');
        end

        function out = double(d)
            out = d.data;
        end

        function out = feval(s, dom)
            out = feval(s, dom.data);
        end

        function [varargout] = setdiff(varargin)
            for i=1:nargin
                varargin{i} = double(varargin{i});
            end
            [varargout{1:nargout}] = setdiff(varargin{:});
            % TODO?
            varargout{1} = domain(varargout{1});
        end
        
        function varargout = sprintf(varargin)
            % This is required as built-in subsref does not know what to do with
            % a DOMAIN object.
            
            varargin = domain2double(varargin{:});
            
            % Call built-in SPRINTF:
            varargout{1:nargout} = sprintf(varargin{:});
        end
                   
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% STATIC METHODS:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Access = public, Static = true )
        
        % Merge two domains:
        newDom = merge(varargin)
        
        function varargin = toDouble(varargin)
            % Cast DOMAIN to DOUBLE:
            for k = 1:nargin
                if ( isa(varargin{k}, 'domain') )
                    varargin{k} = double(varargin{k});
                end
            end
        end
        
    end
    
end
