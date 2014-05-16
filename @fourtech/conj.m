function f = conj(f)
%CONJ   Complex conjugate of a FOURTECH.
%   CONJ(F) is the complex conjugate of F. For a complex F,
%   CONJ(F) = REAL(F) - 1i*IMAG(F).
%
% See also REAL, IMAG.

% Copyright 2014 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org for Chebfun information.

% No need to conjugate a real function
if isreal(f)
    return;
end

% Conjugate the values:
f.values = conj(f.values);

% Could just recompute the coefficients for the conjugated values.
% f.coeffs = f.vals2coeffs(f.values);
% But this exploits the properties of the interpolant in complex exponential
% form:
f.coeffs = flipud(conj(f.coeffs));

end