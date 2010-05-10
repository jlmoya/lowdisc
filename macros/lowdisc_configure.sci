// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = lowdisc_configure (this,key,value)
  // Configure a field of the object and returns the modified object.
  //
  // Calling Sequence
  //   this = lowdisc_configure (this,key,value)
  //
  // Parameters
  //   this: the current object
  //   key: a string. The name of the option to get. All options which can be set with lowdisc_configure can be get with lowdisc_cget.
  //   value: the value associated with the key. Its type depends on the value of the key.
  //
  // Description
  //   This command allows to configure the state of the current object.
  //   It requires to take the current object both as an input
  //   and output argument.
  //  The following keys are available.
  //  <itemizedlist>
  //   <listitem>"-verbose" : a boolean, the verbose mode (default : %f).</listitem>
  //   <listitem>"-dimension" : a positive floating point integer, 
  //     the dimension of the space, i.e.
  //     the size of the vector returned by the command lowdisc_next (default = 1).</listitem>
  //   <listitem>"-vandercorputbasis" : a positive floating point integer, greater or equal to 2, 
  //     the basis used in the Van Der Corput sequence (default = 2).
  //     The value is expected to be . It should be a prime number, but that
  //     is not checked by the configure method.</listitem>
  //   <listitem>"-primeslist" : a row array of positive floating point integers, 
  //     at matrix of prime numbers used in the several low discrepancy sequences.
  //     The expected matrix must have a 1xn shape, with n an integer greater than 2.
  //     The default list is made of the 100 first prime numbers, from 2 to 541, which
  //     enables the user to generate sequences up to 100 dimensions.
  //     If a larger dimension problem is to process, that feature should enable users to
  //     customize the list to meet the required dimension.
  //     The user should be warned that the Halton sequence may produce poor convergence
  //     rate if the dimension is larger than 15.</listitem>
  //   <listitem>"-sequenceindex" : a positive floating point integer,
  //     the starting index of the low discrepancy sequences.
  //     When a sequence is created this setting is initialized to 0.
  //     Whenever the randonumber_next method is called, the sequence index
  //     is updated and incremented with 1. If this option is passed to the lowdisc_cget
  //     method, it allows to know the number of vectors which have allready
  //     been generated.
  //     If this option is set, it allows to modify the behaviour of the low discrepancy
  //     sequences, which take into account this index to produce the next element
  //     in the sequence.
  //     The -sequenceindex optin should therefore generally not be set, 
  //     except in specific situations
  //     where the user has particular requirements on the low discrepancy
  //     sequence to generate.</listitem>
  //   <listitem>"-skip" : a positive floating point integer, 
  //     the number of terms to skip at startup. 
  //     When the sequence is started up with the lowdisc_startup method,
  //     the algorithm generates skip elements, which are immediately
  //     discarded. This option allows to start the simulation at a later
  //     point in the sequence. 
  //     For example, Fox recommends to skip the qs^4 - 2 first terms in the 
  //     Faure sequence, where qs is the prime number associated with the 
  //     sequence. This number can be retrieved with 
  //     qs = lowdisc_get ( rng , "-faureprime" ).</listitem>
  //   <listitem>"-leap" : a positive floating point integer, 
  //     the number of elements to ignore from element to element (default = 0).
  //     Each time the lowdisc_next function is called, the immediate element
  //     is retrieved. Then, in order to prepare for the next call,
  //     there are leap elements which are generated and immediately
  //     discarded. This option allows to generate alternative 
  //     sequences based on the same basic generator.</listitem>
  //  </itemizedlist>
  //
  //   Because of the limitation of floating point integers, 
  //   the lowdisc_next function is able to generate at most 
  //   2^52  = 4 503 599 627 370 496 experiments.
  //   Fast sequences are based on the intermediate storage of the 
  //   iteration index on a 32 bits C int. This implies 
  //   that these sequences are able to generate at most 
  //   2^32-1 = 4 294 967 295 experiments. 
  //
  //   Some sequences are limited in the maximum number of dimensions, 
  //   because they use internally fixed tables of parameters (e.g. the Sobol 
  //   sequence).
  //   Some other sequences can be extended with the "-primeslist" option.
  //   The "-primeslist" option can be configure with a table of 
  //   primes computed with the lowdisc_primes100(), lowdisc_primes1000()
  //   or lowdisc_primes10000() functions. The maximum dimension 
  //   which can be attained with these tables depends on the sequence.
  //   See the specific settings of each sequence below for detail.
  //
  // Examples
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","faure");
  //   rng = lowdisc_configure(rng,"-dimension",3);
  //   method = lowdisc_cget(rng,"-method")
  //   nbdim = lowdisc_cget(rng,"-dimension")
  //   i = lowdisc_cget(rng,"-sequenceindex")
  //   verbose = lowdisc_cget(rng,"-verbose")
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO

    select this.method
    case "halton" then
      this.sequence     = ldhalton_configure ( this.sequence , key , value )
    case "faure" then
      this.sequence     = ldfaure_configure ( this.sequence , key , value )
    case "reversehalton" then
      this.sequence     = ldrevhal_configure ( this.sequence , key , value )
    case "sobol" then
      this.sequence     = ldsobol_configure ( this.sequence , key , value )
    case "niederreiter-base-2" then
      this.sequence     = ldnied2_configure ( this.sequence , key , value )
    case "reversehaltonf" then
      this.sequence     = ldrevhalf_configure ( this.sequence , key , value )
    case "niederreiter-base-2f" then
      this.sequence     = ldnied2f_configure ( this.sequence , key , value )
    case "sobolf" then
      this.sequence     = ldsobolf_configure ( this.sequence , key , value )
    case "fauref" then
      this.sequence     = ldfauref_configure ( this.sequence , key , value )
    case "haltonf" then
      this.sequence     = ldhaltonf_configure ( this.sequence , key , value )
    else
      errmsg = sprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_configure" , this.method);
      error(errmsg);
    end
endfunction

