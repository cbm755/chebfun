#!/bin/bash

# Very rough packaging script, many packages have a "Maintainers Makefile"
# that does a much nicer job.  But this might do for now!

A=chebfun-5.7.0+

rm -rf $A
rm -f $A.tar.gz
mkdir $A
cp NEWS DESCRIPTION $A
cp ../LICENSE.txt $A/COPYING
pushd $A
mkdir inst
cp -ra ../../* inst/
rm -rf inst/.git
rm -rf inst/.github
popd
tar zcvf $A.tar.gz $A

