Low Discrepancy toolbox

Purpose

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

This module currently provides the following functions:
* lowdisc_cget : Returns the value associated with the given key for the given object.
* lowdisc_configure : Update one option of the current object and returns an updated object.
* lowdisc_destroy : Destroy the current object and returns an updated object.
* lowdisc_new : Creates and returns a new sequence.
* lowdisc_next : Returns the next vector in the sequence.
* lowdisc_startup : Startup a random number object.

Provides the following functions to extend the maximum dimension of the Halton and Faure sequences
* lowdisc_primes100 : Returns a matrix containing the 100 first primes.
* lowdisc_primes1000 : Returns a matrix containing the 1000 first primes.
* lowdisc_primes10000 : Returns a matrix containing the 10000 first primes.

Provides the following functions to suggest expert settings for the sequences :
 * lowdisc_fauresuggest : Returns favorable parameters for Faure sequences.
 * lowdisc_haltonsuggest : Returns favorable parameters for Halton sequence.
 * lowdisc_niederbase : Returns optimal base for Niederreiter sequence.
 * lowdisc_niedersuggest : Returns favorable parameters for Niederreiter sequence.
 * lowdisc_sobolsuggest : Returns favorable parameters for Sobol sequences.
 * lowdisc_soboltau : Returns favorable starting seeds for Sobol sequences.

This component currently provides the following sequences:
 * "slow" sequences based on macros : Halton, Sobol, Faure, Reverse Halton, Niederreiter base 2,
 * "fast" sequences based on C source code : Halton, Sobol, Faure, Reverse Halton, Niederreiter in arbitrary base.

See the overview in the help provided with this toolbox.

Author

2009-2010 - DIGITEO - Michael Baudin
2008-2009 - INRIA - Michael Baudin
2003-2009 - John Burkardt
1994 - Paul Bratley, Bennett Fox, Harald Niederreiter
1986-1986 - Bennett Fox

Licence

This toolbox is distributed under the GNU LGPL license.

Acknowledgements

Michael Baudin thanks John Burkardt for his help during 
the development of this library.
Thanks to Alan Cornet, Pierre Marechal for the technical help
for this project.


