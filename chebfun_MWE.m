% A container for Octave Chebfun examples
% As we try to port Chebfun to Octave, let's keep track of what works.


disp("chebfun initialization: ");
x = chebfun('x', [-10 10])

disp("\nexamples of product : ");
disp("2*x");
disp(2*x);
disp("\n2.*x");
disp(2.*x);
disp("\nx*2");
disp(x*2);
disp("\nx.*2");
disp(x.*2);


disp("\nan example of division : ");
disp("x/2");
disp(x/2);

disp("\nan example of addition : ");
disp("x + x");
disp(x + x);

disp("\ntranscendental functions examples : ");
disp("sin(x)");
disp(sin(x));
disp("\ncos(x)");
disp(cos(x));


disp("\nanother more complicated examples : ");
disp("x/3 + 4");
disp(x/3 + 4);
disp("\nsin(x) + 4");
disp(sin(x) + 4);
disp("\nsin(x + x)");
disp(sin(x + x));
disp("\nsin(x + 2)");
disp(sin(x + 2));
disp("\nsin(2*x)");
disp(sin(2*x));
disp("\nsin(5*x + 3)");
disp(sin(5*x + 3));
disp("\nsin(cos(x))");
disp(sin(cos(x)));
disp("\nsin(cos(x + 2))");
disp(cos(sin(x + 2)));
disp("\nsin(cos(2*x + 2))");
disp(sin(cos(2*x + 2)));