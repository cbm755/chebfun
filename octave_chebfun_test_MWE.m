% A container for Octave tests
% As we try to port Chebfun to Octave, let's keep track of what works.
% Eventually we have a goal to run the whole Chebfun test suite but small steps first.

%!test
%! % make a chebfun
%! x = chebfun('x');
%! assert (isa(x, 'chebfun'))

%!test
%! f = chebfun('x', [-2 2]);
%! assert (isequal (f.domain, [-2 2]))

%!test
%! f = chebfun('x + x', [-5 5]);
%! assert (isequal (f.pointValues, [-10;10]))

%!test
%! f = chebfun('2*x + 3', [-1 1]);
%! assert (isequal (f(1), 5))
%! assert (isequal (f(0), 3))

%!test
%! f = chebfun('x/3 + 4', [-10 10]);
%! assert (isequal (f(0), 4))
%! assert (isequal (f(3), 5))

%!test
%! f = chebfun('sin(x)', [0 pi]);
%! area = integral(f);
%! assert (area, 2, -2*eps)
%assert (abs(area - 2) <= 4*eps)

%!test
%! f = chebfun('sin(x) + 2', [0 pi]);
%! area = integral(f);
%! assert (area, 8.283185307179588, -2*eps)

%!test
%! f = chebfun('sin(cos(2*x + 2))', [0 pi]);
%! area = integral(f);
%! assert (area, 0, -2*eps)