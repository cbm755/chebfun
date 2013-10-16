classdef operatorBlock < linBlock
    
    properties
    end
    
    methods
        function A = operatorBlock(domain)
            A = A@linBlock(domain);
        end
        
        function varargout = size(A,dim)
            % S = SIZE(A)
            % [M,N] = SIZE(A)
            % P = SIZE(A,K)
            %
            m = [Inf Inf];

            if nargin > 1
                varargout = {m(dim)};
            elseif nargout <= 1
                varargout = {m};
            else
                varargout = {m(1) m(2)};
            end
        end

        
        function C = mtimes(A,B)
            % A*B
            % If A,B both linops, or one is linop and one scalar, the
            % result is the composed linop.
            %
            % A*f
            % If A is a linop and f is a chebfun, return the chebfun
            % resulting from application of A to f.
            %
            % A*u
            % If A is a linop and u is a matrix, return the matrix
            % resulting from application of the discretization of A to u.
            %
            
            % No error checking here.
            % Which case?
            if isa(B,'chebfun')
                C = op(A);
                C = C(B);
            elseif isnumeric(B)
                N = size(B,1);    % discretization size
                L = matrix(A,N);
                C = L*B;
            else
                % A scalar is converted into a constant chebfun, which is then
                % diagnified. 
                if isnumeric(A)
                    A = linBlock.diag( chebfun(A,B.domain) );
                elseif isnumeric(B)
                    B = linBlock.diag( chebfun(B,A.domain) );
                end
                
                C = operatorBlock(A.domain);
                
                % The instantiation class must recognize mtimes as a
                % functional composition.
                C.delayFun = @(z) A.delayFun(z) * B.delayFun(z);
                C.diffOrder = A.diffOrder + B.diffOrder;
            end
        end
        
        function C = plus(A,B)
            % C = A + B
            if isnumeric(A)
                A = A*linop.eye(B.domain);
            elseif isnumeric(B)
                B = B*linop.eye(A.domain);
            end
            dom = union(A.domain, B.domain);
            C = operatorBlock(dom);
            C.delayFun = @(z) A.delayFun(z) + B.delayFun(z);
            C.diffOrder = max(A.diffOrder,B.diffOrder);
        end
        
        function B = mpower(A,pow)
            if (pow~=round(pow)) || (pow < 0)
                error('Power must be an integer.')
            end
            B = linop.eye(A.domain);
            for i = 1:pow
                B = B*A;
            end
        end
        
        function out = iszero(A)
            % TODO: Implement this.
            out = false;
        end
        


    end
    
end