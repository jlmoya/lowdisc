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
 * This module depends on the apifun module.

TODO 
----
 * Use apifun
 * Put lowdisc_corrcoeff into Stixbox
 * Use number_bary instead of lowdisc_bary
 * create macros functions for Reverse Halton, Niederreiter and Faure 
   and put it into the "Macro Generators" section.
 * Remove lowdisc_primes100, lowdisc_primes1000, lowdisc_primes10000 
   and use the functions from the "number" module.
 * Remove verbose option from lowdisc_ldgen and lowdisc_configure
 * Add scrambling algorithms : RR2 from Kocis and Whiten, Matousek. 
   Can we program Reverse Halton as a scrambling ? 
   Can let the user define its scrambling function ?
 * Add algorithms to compute the discrepancy
 * Add test cases on integrals as in Bratley and Fox
 * check interaction between skip and leap for all sequences
 * for C-based sequences, vectorize the calls to the fast 
   sequences, so that we can get several elements at the same time
 * replace dim_num by dim everywhere in the macros
 * update the name of the next routines of the C library : 
   i4_sobol > i4_sobol_next, etc... 
   Review all the .h to be sure of this update.
 * see if the Gray code of the index can be computed 
   directly, so that the skip and leap options of 
   Sobol sequence is faster
 * replace basis by base where appropriate in Faure sequence
 * create a graycode function
 * update the C source codes and use C++ classes

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

Internal Design
---------------

The internal design of the toolbox is based on the 
following hierarchy of internal (i.e. undocumented) functions.

The ldhalton_*, ldfaure_*, etc... functions are each implementing 
a specific low discrepancy sequence. Each sequence is independent of the others.
Each sequence has its specific options, but all must implement the
following methods : new, destroy, configure, cget, get, startup and next.
The purpose of these functions is the following:
 * ld<sequence>_new: creates a new sequence with type <sequence>
 * ld<sequence>_configure: configure an option of the sequence (e.g. -dimension)
 * ld<sequence>_cget: get the value of a configurable options (e.g. -dimension)
 * ld<sequence>_get: get the value of a non-configurable options (e.g. -speed)
 * ld<sequence>_startup: startup the sequence
 * ld<sequence>_next: returns the next element in the sequence
 * ld<sequence>_destroy: destroys the sequence
For example, the Faure sequence is associated with the following functions 
ldfaure_new, ldfaure_destroy, ldfaure_configure, ldfaure_cget, ldfaure_get, 
ldfaure_startup and ldfaure_next.

The ldbase_* functions provide an abstract sequence object.
This class gathers the source code shared by all sequences.
 * ldbase_new: creates a new abstract sequence
 * ldbase_cget: get the value of a configurable options (e.g. -dimension)
 * ldbase_configure: configure an option of the sequence (e.g. -dimension)
 * ldbase_get: get the value of a non-configurable options (e.g. -speed)
 * ldbase_incr: increments the index counter
 * ldbase_indexset: sets the index counter
 * ldbase_startup: starts the sequence (i.e. sets index to 0)
 * ldbase_destroy: destroys the sequence

The _lowdisc_* functions are "hidden" (i.e. undocumented) functions which 
provides the fast low discrepancy functions. 

Main module:
 * _lowdisc_startup: startup the module
 * _lowdisc_shutdown: shutdown the module
  
Fast Sobol:
 * _lowdisc_sobolfnext: returns the next element
 * _lowdisc_sobolfstart: starts the sequence
 * _lowdisc_sobolfstop: stops the sequence
 * _lowdisc_sobolfdimget: returns the dimension of the sequence
 * _lowdisc_sobolfisstart: returns 1 if the sequence is started up, 0 if not

Fast Halton:
 * _lowdisc_haltonfnext: returns the next element
 * _lowdisc_haltonfstart: starts the sequence
 * _lowdisc_haltonfstop: stops the sequence
 * _lowdisc_haltonfdimget: returns the dimension of the sequence
 * _lowdisc_haltonfbaseget: returns the basis of the sequence
 * _lowdisc_haltonfseedget: returns the index of the sequence
 * _lowdisc_haltonfleapget: returns the leap of the sequence
 * _lowdisc_haltonfisstart: returns 1 if the sequence is started up, 0 if not

Fast Faure:
 * _lowdisc_faurefbaseget: 
 * _lowdisc_faurefnext: returns the next element
 * _lowdisc_faurefstart: starts the sequence
 * _lowdisc_faurefstop: stops the sequence
 * _lowdisc_faurefisstart: returns 1 if the sequence is started up, 0 if not
 * _lowdisc_faurefdimget: returns the dimension of the sequence

Fast Reverse Halton:
 * _lowdisc_revhaltfnext: returns the next element
 * _lowdisc_revhaltfstart: starts the sequence
 * _lowdisc_revhaltfstop: stops the sequence
 * _lowdisc_revhaltfbaseget: returns the basis of the sequence
 * _lowdisc_revhaltfdimget: returns the dimension of the sequence
 * _lowdisc_revhaltfisstart: returns 1 if the sequence is started up, 0 if not

Fast Niederreiter:
 * _lowdisc_niedfnext: returns the next element
 * _lowdisc_niedfstart: starts the sequence
 * _lowdisc_niedfstop: stops the sequence
 * _lowdisc_niedfbaseget: returns the basis of the sequence
 * _lowdisc_niedfdimget: returns the dimension of the sequence
 * _lowdisc_niedfskipget: returns the skip of the sequence
 * _lowdisc_niedfisstart: returns 1 if the sequence is started up, 0 if not

