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
* leaps (i.e. ignores) a given number of elements from call to call.

This module currently provides the following functions:
* lowdisc_cget : Returns the value associated with the given key for the given object.
* lowdisc_configure : Update one option of the current object and returns an updated object.
* lowdisc_destroy : Destroy the current object and returns an updated object.
* lowdisc_new : Creates and returns a new sequence.
* lowdisc_next : Returns the next vector in the sequence.
* lowdisc_startup : Startup a random number object.

This component currently provides the following sequences:
* "slow" sequences based on macros : vandercorput, halton, faure, reversehalton, sobol, niederreiter-base-2,
* "fast" sequences based on C source code : reversehaltonf, niederreiter-base-2f, sobolf, fauref, haltonf.

The internal design of the toolbox is based on the 
following hierarchy.
 * lowdisc is the highest level component.
   It allows to access to any sequence with a constructor based 
   on a string representing the sequence. For example, rng = lowdisc_new("halton")
   creates a new Halton sequence.
   In this framework, the lowdisc component allows to access to all sequences
   with a single API, where all the methods are valid for all sequences and 
   all sequences share the same options.
 * ldhalton_new (), ldfaure_new (), etc... are each implementing a specific
   low discrepancy sequence. Each sequence is independent of the others.
   Each sequence has its specific options, but all must implement the 
   following methods : new, destroy, configure, cget, get, startup and next.

See the overview in the help provided with this toolbox.

Author

Michael Baudin

Licence

This toolbox is distributed under the GNU LGPL license.



