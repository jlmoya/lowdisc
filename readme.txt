Low Discrepancy toolbox

Purpose
-------

The goal of this toolbox is to provide a collection of low discrepancy
sequences. These random numbers are designed to be used in a Monte-Carlo
simulation. For example, low discrepancy sequences provide a higher
convergence rate to the Monte-Carlo method when used in numerical
integration. The toolbox takes into account the dimension of the problem, i.e.
generate vectors with arbitrary size.

The current prototype has the following features :
 * manage arbitrary number of dimensions,
 * skips a given number of elements in the sequence,
 * leaps (i.e. ignores) a given number of elements from call to call,
 * fast sequences based on compiled source code,
 * suggest optimal settings to use the best of the sequences,
 * object oriented programming.

Overview of sequences
 * The Halton sequence,
 * The Sobol sequence,
 * The Faure sequence,
 * The Reverse Halton sequence of Vandewoestyne and Cools,
 * The Niederreiter base 2 and arbitrary base sequence.
 
This component currently provides the following sequences:
 * "slow" sequences based on macros : Halton, Sobol, Faure, Reverse Halton, Niederreiter base 2,
 * "fast" sequences based on C source code : Halton, Sobol, Faure, Reverse Halton, Niederreiter in arbitrary base.

See the overview in the help provided with this toolbox.

Features
--------
 
The module provides the following help pages:
 * lowdisc_overview : An overview of the Low Discrepancy toolbox.
 * lowdisc_projections : An overview of bad 2D projections.

The flagship of this module is:
 * lowdisc_ldgen : Returns uniform numbers from a low discrepancy sequence.
 
Sequences:
 * lowdisc_cget : Returns the value associated with the given key.
 * lowdisc_configure : Configure a field of the object and returns the modified object.
 * lowdisc_destroy : Destroy the current object.
 * lowdisc_get : Quiery one not-configurable field.
 * lowdisc_new : Create a new object.
 * lowdisc_next : Returns the next term of the sequence
 * lowdisc_startup : Startup the sequence.
 
Macro Generators:
 * lowdisc_haltonnext : Returns the next element of the Halton sequence.
 * lowdisc_sobolnext : Generates a new quasirandom Sobol vector.
 * lowdisc_sobolskip : Skip elements in the Sobol sequence.
 * lowdisc_sobolstart : Initialize the Sobol sequence.
 * lowdisc_vandercorput : Returns the i-th term of the Van Der Corput sequence.
 
Static Functions:
 * lowdisc_fauresuggest : Returns favorable parameters for Faure sequences.
 * lowdisc_haltonsuggest : Returns favorable parameters for Halton sequence.
 * lowdisc_methods : Returns available sequences.
 * lowdisc_niederbase : Returns optimal base for Niederreiter sequence.
 * lowdisc_niedersuggest : Returns favorable parameters for Niederreiter sequence.
 * lowdisc_primes100 : Returns a matrix containing the 100 first primes.
 * lowdisc_primes1000 : Returns a matrix containing the 1000 first primes.
 * lowdisc_primes10000 : Returns a matrix containing the 10000 first primes.
 * lowdisc_sobolsuggest : Returns favorable parameters for Sobol sequences.
 * lowdisc_soboltau : Returns favorable starting seeds for Sobol sequences.
 * lowdisc_stopall : Stop all fast sequences.
 
Support Functions:
 * lowdisc_bary : Returns the digits of a number given the basis.
 * lowdisc_bitand : Bitwise AND.
 * lowdisc_bithi1 : Returns the position of the high one bit base 2 in an integer.
 * lowdisc_bitlo0 : Returns the position of the low zero bit base 2 in an integer.
 * lowdisc_bitor : bitwise OR
 * lowdisc_bitxor : Bitwise logical XOR operator.
 * lowdisc_corrcoef : Correlation coefficients
 * lowdisc_dec2bin : Convert a decimal floating point integer into binary.
 * lowdisc_proj2d : Plots 2 dimensional projections.

Dependencies
------------

 * This module depends on the Stixbox module (function cov).
 * This module depends on the assert module.
 * This module depends on the helptbx module.

TODO 
----
 * update the next to get all elements in one call
 * change assert_typereal to assert_type with variable name and variable index
 * synchronize the lowdisc_ldgen against the inprb_ldgen function in the intprb module : make a apifun module and make it depend on it.
 * create separate functions for the slow (macros) versions of Reverse Halton, Niederreiter and Faure.

Author
------

 * 2009-2011 - DIGITEO - Michael Baudin
 * 2008-2009 - INRIA - Michael Baudin
 * 2003-2009 - John Burkardt
 * 1994 - Paul Bratley, Bennett Fox, Harald Niederreiter
 * 1986-1988 - Bennett Fox

Licence
-------

This toolbox is distributed under the GNU LGPL license.

Acknowledgements
----------------

Michael Baudin thanks John Burkardt for his help during 
the development of this library.
Thanks to Alan Cornet, Pierre Marechal for the technical help
for this project.
Thanks to Jean-Philippe Chancelier for finding bugs in the 
source code of the gateway.


