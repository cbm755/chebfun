function div = divergence( fx, fy, fz ) 
%DIVERGENCE  Numerical surface divergence of a SPHEREFUN. 
%   D = DIVERGENCE(FX, FY, FZ) returns the numerical surface divergence of the
%   vector field [FX FY FZ], where each component is a SPHEREFUN F and the
%   whole field is expressed in Cartesian coordinates. 
%
% See also GRADIENT, CURL, VORTICITY

% Copyright 2015 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

div = diff(fx, 1) + diff(fy, 2) + diff(fz, 3);

end

