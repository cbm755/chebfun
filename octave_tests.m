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

%!test
%! x = chebfun('x');
%! f = x*2;

%!test
%! % premult by a constant fails
%! x = chebfun('x');
%! f = 2*x;

%!test
%! % upstream copy-on-write bug causes uminus to mutate input
%! % see workaround in @chebfun/uminus.m
%! % https://github.com/cbm755/chebfun/issues/13
%! % https://savannah.gnu.org/bugs/index.php?54028
%! x = chebfun('x');
%! g = 2 + x;
%! A = -g;
%! assert (A(-1) < 0)
%! % but g should NOT be changed
%! assert (g(-1) > 0)
%! assert (g(-0.99) > 0)
%! assert (g(0.99) > 0)
%! assert (g(1) > 0)
%! A = -g;
%! assert (A(-1) < 0)
%! assert (g(-1) > 0)
%! assert (g(-0.99) > 0)
%! assert (g(0.99) > 0)
%! assert (g(1) > 0)
