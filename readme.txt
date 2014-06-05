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
 * get directly the dimension-th coordinate, without generating 
   the coordinates 1,2,...,dimension-1.

Overview of sequences

 * The Halton sequence (classic, leaped, reverse or scrambled),
 * The Sobol sequence (classic or scrambled),
 * The Faure sequence,
 * The Niederreiter arbitrary base sequence.
 
See the overview in the help provided with this toolbox.

Features
--------
 
The module provides the following help pages:
 * lowdisc_overview : An overview of the Low Discrepancy toolbox.

The flagship of this module is:
 * lowdisc_ldgen : Returns uniform numbers from a low discrepancy sequence.
 
Tutorials

 * lowdisc_plots — A gallery of low discrepancy sequences.
 * lowdisc_projections — An overview of bad 2D projections.
 * lowdisc_tmsnets — (t,m,s)-nets and low discrepancy sequences.
 * lowdisc_efficiency — Efficiency of Monte-Carlo and QMC.

Sequences:
 * lowdisc_cget : Returns the value associated with the given key.
 * lowdisc_configure : Configure a field of the object and returns the modified object.
 * lowdisc_destroy : Destroy the current object.
 * lowdisc_get : Quiery one not-configurable field.
 * lowdisc_new : Create a new object.
 * lowdisc_next : Returns the next term of the sequence
 * lowdisc_startup : Startup the sequence.
 
Static Functions:
 * lowdisc_methods : Returns available sequences.
 * lowdisc_stopall : Stop all fast sequences.

Favorable Parameters:
 * lowdisc_fauresuggest : Returns favorable parameters for Faure sequences.
 * lowdisc_haltonsuggest : Returns favorable parameters for Halton sequence.
 * lowdisc_niederbase : Returns optimal base for Niederreiter sequence.
 * lowdisc_niedersuggest : Returns favorable parameters for Niederreiter sequence.
 * lowdisc_sobolsuggest : Returns favorable parameters for Sobol sequences.
 
Support Functions:
 * lowdisc_getpath : Returns the path to the current module.
 * lowdisc_plotbmbox : Plot all elementary boxes with volume b^m
 * lowdisc_plotelembox : Plot elementary box
 * lowdisc_proj2d : Plots 2 dimensional projections.

Dependencies
------------

 * This module depends on Scilab (>=v5.4).
 * This module depends on the helptbx module.
 * This module depends on the Stixbox module (v>=2.2).
 * This module depends on the apifun module (v>=0.3).
 * This module depends on the number module (v>=1.2).
 * This module depends on the specfun module (v>=0.2).

TODO 
----
 * Put lowdisc_corrcoeff into Stixbox
 * create macros functions for Reverse Halton, Niederreiter and Faure 
   and put it into the "Macro Generators" section.
 * Remove verbose option from lowdisc_ldgen and lowdisc_configure
 * Add scrambling algorithms : RR2 from Kocis and Whiten, Matousek. 
   Can we program Reverse Halton as a scrambling ? 
   Can let the user define its scrambling function ?
 * Add algorithms to compute the discrepancy
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

Authors
-------

 * 2013 - Michael Baudin
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
Thanks to Jeanne Demgne for her feedback on this module.

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

History of the source code
--------------------------

The source code provided here is the result of the cumulated
work of several authors at different times.

From 1986 to 1992, Bennett Fox and then Paul Bratley and
Harald Niederreiter developped Fortran algorithms which
provided the Sobol, Faure and Niederreiter sequences.
These algorithms are described in several papers called Algorithm 647,
Algorithm 659 and Algorithm 738.

From 2003 to 2009, John Burkardt translated these
source codes into Matlab and C. He also developped a leaped Halton
sequence based on the 1997 paper by Kocis and Whiten.

From 2008 to 2013, Michael Baudin did early experiments
with interfacing the low discrepancy sequences from the Gnu Scientific Library.
Problems with the portability of the library under Windows and
limitations of the licence led me to the search for another
source of sequences.
I developped the Halton and Faure sequences as
Scilab macros from the algorithms provided by Paul Glasserman in his book.
Then I translated and re-structured the
Matlab and, later, the C source codes from John Burkardt.
I updated all the sequences, so that they all share the same parameters,
such as the skip and the leap parameters.
I also created the Reverse Halton sequence from the 2006 paper
by Vandewoestyne and Cools. This work was inspired by the
work done by O. Teytaud in the Gnu Scientific Library.
Much time was spent on the validation of the sequences provided in this
module.
Each sequence is associated with a collection of unit
tests which ensure the that the sequence is correctly computed.
We used the original Fortran 77 implementations as a base to compare
our results.
Several bugs were discovered this way and fixed in the
source code provided here.
A significant amount of energy was devoted to the 
validation of the sequences, so that we have a good 
confidence that, if the tests pass, then the sequence is correct.
