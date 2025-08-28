# Chebfun Status On Octave

---

As of August 23, 2025, Chebfun status on Octave is still preliminary. 1D Chebfun is working fairly decently. Differential equation solvers (chebop), 2D and 3D Chebfun are not presumed to be working currently.

## Relevant Octave bugs

--------------------

[GNU Octave - Bugs: bug #44035, unable to subclass built-in types [Savannah]](https://savannah.gnu.org/bugs/?44035). Problem crops in up `@domain`.

[GNU Octave - Bugs: bug #65179, Arrays of classdef objects not... [Savannah]](https://savannah.gnu.org/bugs/index.php?65179). A ginormous pain currently. Very limited support is available for object arrays. All object array operations should be looked at with extreme suspicion.

[GNU Octave - Bugs: bug #54028, copy of non-handle class instance... [Savannah]](https://savannah.gnu.org/bugs/index.php?54028). See issues #12 and #13 for an in-depth explanation of the issue.

[GNU Octave - Bugs: bug #66659, Octave crashes with SIGSEGV when... [Savannah]](https://savannah.gnu.org/bugs/index.php?66659). Can be worked around. Create a dummy function like `dummy_fcn.m`, have the function execute the code you are interested in. Then set the breakpoint in `dummy_fcn`, and step through the code from there.

Probably others!

## Patches applied to Octave core to help Chebfun run

Make sure your version of Octave has all of these patches applied.

[GNU Octave - Patches: patch #10537, Support for InferiorClasses... [Savannah]](https://savannah.gnu.org/patch/index.php?10537). Not merged yet.

[GNU Octave - Bugs: bug #67362, Subsref should resolve to property... [Savannah]](https://savannah.gnu.org/bugs/index.php?67362). Merged into Octave default branch.

[GNU Octave - Bugs: bug #65179, Arrays of classdef objects not... [Savannah]](https://savannah.gnu.org/bugs/index.php?65179). Merged into Octave default branch.

[GNU Octave - Bugs: bug #67413, Stacktrace from error should show... [Savannah]](https://savannah.gnu.org/bugs/index.php?67413). Not necessary, but very useful for debugging.

- - - - - - - - - - - - - - - -

Older notes
-----------

```diff
- Issue: class-related functions not same as private static methods

- My interpretation of the Matlab docs if that calling a static method
- should require the class name (or instance) and dot notation
- ("myclass.mystaticmethod()").
- Citations:

- [http://www.mathworks.co.uk/help/matlab/matlab_oop/static-methods.html]

- > % Calling a static method requires the class name

- [http://www.mathworks.co.uk/help/matlab/matlab_oop/developing-classes--typical-workflow.html]

- Matlab seems to allow you to be sloppy in this way inside your own class
- (or at least I can't find it documented anywhere that you are allowed to do this.)

- If really you want to use functions without the dot, there is another
- feature: "class-related function" which are also private to the m-file
- (and not e.g., methods of the class defined in other m-files).
+ No longer a problem in Octave, see https://savannah.gnu.org/bugs/?41723
```

Current Test Statuses:
-----------

**Update as you see fit, do all tests on octave_dev branch*

Total number of tests:
1104
Number of successful tests:
576
Number of failed tests:
50
Number of crashed tests:
478
